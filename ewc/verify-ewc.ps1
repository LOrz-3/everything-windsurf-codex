$ErrorActionPreference = 'Continue'

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$Results = New-Object System.Collections.Generic.List[object]

function Add-Result {
    param(
        [Parameter(Mandatory = $true)][ValidateSet('PASS', 'WARN', 'FAIL')][string]$Status,
        [Parameter(Mandatory = $true)][string]$Check,
        [Parameter(Mandatory = $true)][string]$Detail
    )

    $Results.Add([pscustomobject]@{
        Status = $Status
        Check = $Check
        Detail = $Detail
    }) | Out-Null
}

function Test-FilePresent {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Name
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Add-Result -Status 'FAIL' -Check $Name -Detail "Missing file: $Path"
        return $false
    }

    $item = Get-Item -LiteralPath $Path
    if ($item.Length -le 0) {
        Add-Result -Status 'FAIL' -Check $Name -Detail "Empty file: $Path"
        return $false
    }

    Add-Result -Status 'PASS' -Check $Name -Detail "Found non-empty file: $Path"
    return $true
}

function Get-TextUtf8 {
    param([Parameter(Mandatory = $true)][string]$Path)

    try {
        $encoding = New-Object System.Text.UTF8Encoding($false)
        return [System.IO.File]::ReadAllText($Path, $encoding)
    }
    catch {
        Add-Result -Status 'FAIL' -Check 'read text' -Detail "Cannot read UTF-8 text: $Path ; $($_.Exception.Message)"
        return ''
    }
}

function Test-NoBom {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Name
    )

    try {
        $bytes = [System.IO.File]::ReadAllBytes($Path)
        if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
            Add-Result -Status 'WARN' -Check $Name -Detail "UTF-8 BOM detected: $Path"
        }
        else {
            Add-Result -Status 'PASS' -Check $Name -Detail "No UTF-8 BOM detected: $Path"
        }
    }
    catch {
        Add-Result -Status 'FAIL' -Check $Name -Detail "Cannot inspect file bytes: $Path ; $($_.Exception.Message)"
    }
}

function Test-Frontmatter {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string[]]$RequiredFields
    )

    $text = Get-TextUtf8 -Path $Path
    if ($text -notmatch "(?s)^---\s*\r?\n(.*?)\r?\n---") {
        Add-Result -Status 'FAIL' -Check $Name -Detail "Missing YAML frontmatter: $Path"
        return
    }

    $frontmatter = $Matches[1]
    $missing = @()
    foreach ($field in $RequiredFields) {
        if ($frontmatter -notmatch "(?m)^$([regex]::Escape($field))\s*:") {
            $missing += $field
        }
    }

    if ($missing.Count -gt 0) {
        Add-Result -Status 'FAIL' -Check $Name -Detail "Frontmatter missing fields: $($missing -join ', ')"
    }
    else {
        Add-Result -Status 'PASS' -Check $Name -Detail "Frontmatter contains fields: $($RequiredFields -join ', ')"
    }
}

function Test-Phrases {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string[]]$Phrases,
        [Parameter(Mandatory = $false)][ValidateSet('FAIL', 'WARN')][string]$MissingStatus = 'FAIL'
    )

    $text = Get-TextUtf8 -Path $Path
    $missing = @()

    foreach ($phrase in $Phrases) {
        if ($text.IndexOf($phrase, [System.StringComparison]::OrdinalIgnoreCase) -lt 0) {
            $missing += $phrase
        }
    }

    if ($missing.Count -gt 0) {
        Add-Result -Status $MissingStatus -Check $Name -Detail "Missing phrases: $($missing -join ' | ')"
    }
    else {
        Add-Result -Status 'PASS' -Check $Name -Detail 'All required phrases found'
    }
}

$RootReadme = Join-Path $ProjectRoot 'README.md'
$EnglishReadme = Join-Path $ProjectRoot 'README.en.md'
$SpanishMexicoReadme = Join-Path $ProjectRoot 'README.es-MX.md'
$FrenchReadme = Join-Path $ProjectRoot 'README.fr.md'
$License = Join-Path $ProjectRoot 'LICENSE'
$Notice = Join-Path $ProjectRoot 'NOTICE.md'
$Gitignore = Join-Path $ProjectRoot '.gitignore'
$CoreReadme = Join-Path $ProjectRoot 'ewc\README.md'
$Verify = Join-Path $ProjectRoot 'ewc\verify-ewc.ps1'
$Workflow = Join-Path $ProjectRoot 'workflows\ewc.md'
$MaintenanceSkill = Join-Path $ProjectRoot 'skills\ewc-maintenance\SKILL.md'
$DelegationSkill = Join-Path $ProjectRoot 'skills\codex-delegation\SKILL.md'
$CodexCollab = Join-Path $ProjectRoot 'global_workflows\codex-collab.md'
$McpExample = Join-Path $ProjectRoot 'examples\mcp_config.codex.json'

$CriticalFiles = @(
    @{ Path = $RootReadme; Name = 'root README' },
    @{ Path = $EnglishReadme; Name = 'English README' },
    @{ Path = $SpanishMexicoReadme; Name = 'Spanish Mexico README' },
    @{ Path = $FrenchReadme; Name = 'French README' },
    @{ Path = $License; Name = 'LICENSE' },
    @{ Path = $Notice; Name = 'NOTICE' },
    @{ Path = $Gitignore; Name = '.gitignore' },
    @{ Path = $CoreReadme; Name = 'EWC core README' },
    @{ Path = $Verify; Name = 'EWC verify script' },
    @{ Path = $Workflow; Name = 'EWC workflow' },
    @{ Path = $MaintenanceSkill; Name = 'EWC maintenance skill' },
    @{ Path = $DelegationSkill; Name = 'codex-delegation skill' },
    @{ Path = $CodexCollab; Name = 'codex-collab workflow' },
    @{ Path = $McpExample; Name = 'MCP config example' }
)

foreach ($file in $CriticalFiles) {
    Test-FilePresent -Path $file.Path -Name $file.Name | Out-Null
}

if (Test-Path -LiteralPath $Workflow -PathType Leaf) {
    Test-Frontmatter -Path $Workflow -Name 'workflow frontmatter' -RequiredFields @('description')
}

if (Test-Path -LiteralPath $MaintenanceSkill -PathType Leaf) {
    Test-Frontmatter -Path $MaintenanceSkill -Name 'maintenance skill frontmatter' -RequiredFields @('name', 'description')
}

if (Test-Path -LiteralPath $DelegationSkill -PathType Leaf) {
    Test-Frontmatter -Path $DelegationSkill -Name 'delegation skill frontmatter' -RequiredFields @('name', 'description')
}

if (Test-Path -LiteralPath $CodexCollab -PathType Leaf) {
    Test-Frontmatter -Path $CodexCollab -Name 'codex-collab frontmatter' -RequiredFields @('description')
}

if (Test-Path -LiteralPath $RootReadme -PathType Leaf) {
    Test-Phrases -Path $RootReadme -Name 'root README phrases' -Phrases @(
        'Everything-Windsurf-Codex',
        'Windsurf',
        'Cascade',
        'Codex MCP',
        'Codex CLI fallback',
        'workspace-write',
        'GitHub',
        'UTF-8',
        'secrets',
        'HAOP',
        'Harness-Agent Orchestration Protocol',
        'AI coding harness',
        'CLI-capable Agent',
        '.prompt.txt',
        '.log',
        '.last.md',
        'everything-claude-code'
    )
}

if (Test-Path -LiteralPath $EnglishReadme -PathType Leaf) {
    Test-Phrases -Path $EnglishReadme -Name 'English README phrases' -Phrases @(
        'Everything-Windsurf-Codex',
        'Windsurf / Cascade',
        'Codex MCP',
        'Codex CLI fallback',
        'delegated execution agent',
        'not tied to Windsurf',
        'HAOP',
        'Harness-Agent Orchestration Protocol',
        'portable multi-agent',
        'CLI-capable agent',
        'non-invasive',
        'zero-dependency',
        'split-network',
        'workspace-write',
        'secrets'
    )
}

if (Test-Path -LiteralPath $SpanishMexicoReadme -PathType Leaf) {
    Test-Phrases -Path $SpanishMexicoReadme -Name 'Spanish Mexico README phrases' -Phrases @(
        'Everything-Windsurf-Codex',
        'Windsurf / Cascade',
        'Codex MCP',
        'Codex CLI fallback',
        'agente de ejecuci',
        'HAOP',
        'Harness-Agent Orchestration Protocol',
        'Frontend AI coding harness',
        'Backend CLI-capable agent',
        'no invasivo',
        'sin dependencias',
        'red dividida',
        'workspace-write',
        'secrets'
    )
}

if (Test-Path -LiteralPath $FrenchReadme -PathType Leaf) {
    Test-Phrases -Path $FrenchReadme -Name 'French README phrases' -Phrases @(
        'Everything-Windsurf-Codex',
        'Windsurf / Cascade',
        'Codex MCP',
        'Codex CLI fallback',
        "agent d'ex",
        'HAOP',
        'Harness-Agent Orchestration Protocol',
        'Frontend AI coding harness',
        'Backend CLI-capable agent',
        'non intrusif',
        'aucun service',
        'split-network',
        'workspace-write',
        'secrets'
    )
}

if (Test-Path -LiteralPath $CoreReadme -PathType Leaf) {
    Test-Phrases -Path $CoreReadme -Name 'core README phrases' -Phrases @(
        'business rules source',
        'workspace-write',
        'Codex CLI fallback',
        'MCP',
        'Cascade',
        'secrets'
    )
}

if (Test-Path -LiteralPath $Workflow -PathType Leaf) {
    Test-Phrases -Path $Workflow -Name 'workflow phrases' -Phrases @(
        'Codex CLI fallback',
        'workspace-write',
        'AGENTS.md',
        '.prompt.txt',
        '.log',
        '.last.md',
        'business rules source'
    )
}

if (Test-Path -LiteralPath $MaintenanceSkill -PathType Leaf) {
    Test-Phrases -Path $MaintenanceSkill -Name 'maintenance skill phrases' -Phrases @(
        'EWC',
        'Codex CLI fallback',
        'MCP',
        'workspace-write',
        'codex-delegation',
        'secrets',
        'Cascade',
        'AGENTS.md',
        'prompt'
    )
}

if (Test-Path -LiteralPath $DelegationSkill -PathType Leaf) {
    Test-Phrases -Path $DelegationSkill -Name 'delegation skill phrases' -Phrases @(
        'workspace-write',
        'Codex',
        'MCP',
        'Cascade',
        'diff',
        'prompt',
        'fallback'
    )
}

if (Test-Path -LiteralPath $CodexCollab -PathType Leaf) {
    Test-Phrases -Path $CodexCollab -Name 'codex-collab phrases' -Phrases @(
        'MCP',
        'CLI fallback',
        'fallback',
        'log',
        'Windsurf'
    )
}

foreach ($target in @($RootReadme, $EnglishReadme, $SpanishMexicoReadme, $FrenchReadme, $License, $Notice, $Gitignore, $CoreReadme, $Verify, $Workflow, $MaintenanceSkill, $DelegationSkill, $CodexCollab, $McpExample)) {
    if (Test-Path -LiteralPath $target -PathType Leaf) {
        Test-NoBom -Path $target -Name "encoding: $target"
    }
}

try {
    $codex = Get-Command codex -ErrorAction SilentlyContinue
    if ($codex) {
        $version = (& codex --version 2>&1 | Out-String).Trim()
        Add-Result -Status 'PASS' -Check 'Codex CLI version' -Detail "codex --version returned: $version"
    }
    else {
        Add-Result -Status 'WARN' -Check 'Codex CLI version' -Detail 'codex command not found in PATH; configure Codex before using CLI fallback.'
    }
}
catch {
    Add-Result -Status 'WARN' -Check 'Codex CLI version' -Detail "codex --version failed: $($_.Exception.Message)"
}

Write-Host '# EWC Verification Report'
Write-Host "GeneratedAt: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Host "ProjectRoot: $ProjectRoot"
Write-Host ''

foreach ($result in $Results) {
    Write-Host "[$($result.Status)] $($result.Check) - $($result.Detail)"
}

$pass = @($Results | Where-Object { $_.Status -eq 'PASS' }).Count
$warn = @($Results | Where-Object { $_.Status -eq 'WARN' }).Count
$fail = @($Results | Where-Object { $_.Status -eq 'FAIL' }).Count

Write-Host ''
Write-Host "Summary: PASS=$pass WARN=$warn FAIL=$fail"

if ($fail -gt 0) {
    Write-Host 'Result: FAIL'
    exit 1
}

if ($warn -gt 0) {
    Write-Host 'Result: WARN'
    exit 0
}

Write-Host 'Result: PASS'
exit 0

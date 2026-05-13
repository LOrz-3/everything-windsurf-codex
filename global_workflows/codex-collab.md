---
description: Use Codex MCP/CLI as a sub-agent while Cascade dispatches, reviews, and accepts the result
---
# Codex MCP / CLI Collaboration Workflow

Cascade dispatches and Codex executes. The user can keep Windsurf as the main entry point.

Use Codex MCP for small local tasks. Use Codex CLI fallback for large scans, long-running work, complete logs, progress feedback, MCP delays, encoding/network debugging, or external resource reading.

## 1. Responsibilities

| Role | Responsibility |
|---|---|
| **Windsurf** | Main workspace where the user describes requests, views files, observes results, and accepts delivery. |
| **Cascade** | Chooses channel, writes prompts, limits permissions, reviews output, validates, and delivers final result. |
| **Codex** | Executes large reads, drafts, batch edits, test triage, and low-risk validation. |

Economic rule: long documents, full-page prototypes, DDL/API docs, and large scans go to Codex. One-line bugs, small UI tweaks, and judgment-heavy decisions stay with Cascade/user.

## 2. Safety boundaries

1. Default to read-only.
2. Do not let Cascade and Codex edit the same files simultaneously.
3. Do not put secrets into prompts, logs, or code.
4. Do not perform destructive delete/reset/cleanup operations.
5. Write tasks must explicitly list allowed files or directories.

## 3. Codex MCP for small local tasks

Example MCP configuration:

```json
{
  "codex": {
    "command": "<path-to-codex-executable>",
    "args": ["mcp-server"]
  }
}
```

Read-only task template:

```text
tool: mcp0_codex
cwd: <project-root>
sandbox: read-only
approval-policy: on-request
prompt: Read-only analysis task: <task>. Do not modify files. Output: 1. relevant files 2. conclusion 3. risks 4. recommendations.
```

Scoped write task template:

```text
tool: mcp0_codex
cwd: <project-root>
sandbox: workspace-write
approval-policy: on-request
prompt: Modify task: <task>. Only modify: <files-or-directories>. Do not modify anything else. Output summary, changed files, validation, and risks.
```

Notes:

- Avoid `approval-policy=never` for file probes; it may block Codex internal read-only shell commands.
- MCP may not create `.windsurf/codex-runs` logs, so final reports should state channel, cwd, sandbox, and approval policy.
- If MCP waits too long or gives no progress feedback, switch to CLI fallback.
- CLI fallback does not replace Windsurf; it moves background execution, network fallback, and long logs to Codex while the user stays in Windsurf.

## 4. CLI fallback initialization

```powershell
$workspace = "<project-root>"
$ts = Get-Date -Format 'yyyyMMdd-HHmmss'
New-Item -ItemType Directory -Force -Path (Join-Path $workspace ".windsurf\codex-runs") | Out-Null
chcp 65001 | Out-Null
[Console]::InputEncoding  = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$env:PYTHONIOENCODING = "utf-8"
```

Important:

- Write prompt files using `[System.IO.File]::WriteAllText($path, $content, [System.Text.UTF8Encoding]::new($false))`.
- Avoid PowerShell 5.1 `Set-Content -Encoding UTF8` when BOM causes tool parsing issues.
- Add `--skip-git-repo-check` when the working directory may not be a Git repository.

## 5. CLI read-only template

```powershell
$log = Join-Path $workspace ".windsurf\codex-runs\codex-ro-$ts.log"
$pf  = Join-Path $workspace ".windsurf\codex-runs\codex-ro-$ts.prompt.txt"
[System.IO.File]::WriteAllText($pf, "Read-only analysis task: <task>. Do not modify files. Output relevant files, conclusion, risks, and recommendations.", [System.Text.UTF8Encoding]::new($false))
$cmd = 'chcp 65001>nul && type "' + $pf + '" | "<path-to-codex-executable>" exec --sandbox read-only --ephemeral --skip-git-repo-check -C "' + $workspace + '" - > "' + $log + '" 2>&1'
cmd /c $cmd
cmd /c "chcp 65001>nul && type `"$log`""
```

## 6. CLI scoped write template

```powershell
$log = Join-Path $workspace ".windsurf\codex-runs\codex-wr-$ts.log"
$pf  = Join-Path $workspace ".windsurf\codex-runs\codex-wr-$ts.prompt.txt"
[System.IO.File]::WriteAllText($pf, "Modify task: <task>. Only modify: <files-or-directories>. Do not modify anything else. Output summary, changed files, and validation.", [System.Text.UTF8Encoding]::new($false))
$cmd = 'chcp 65001>nul && type "' + $pf + '" | "<path-to-codex-executable>" exec --sandbox workspace-write --ephemeral --skip-git-repo-check -C "' + $workspace + '" - > "' + $log + '" 2>&1'
cmd /c $cmd
cmd /c "chcp 65001>nul && type `"$log`""
```

## 7. Acceptance

After Codex completes, Cascade must:

1. Show the key output and log path.
2. Check whether any file was changed outside the allowed scope.
3. Read key files or inspect diffs.
4. Validate the result.
5. Request Codex rework or patch manually if needed.

## 8. Troubleshooting

| Issue | Cause | Fix |
|---|---|---|
| MCP cannot see Codex tool | Windsurf has not reloaded MCP config | Reload MCP panel or restart Windsurf/Cascade. |
| MCP read-only probe blocked | `approval-policy=never` blocks internal shell probes | Use `read-only` + `on-request`. |
| Not inside a trusted directory | Workdir is not a Git repo | Add `--skip-git-repo-check`. |
| Chinese output garbled | PowerShell 5.1 pipeline encoding | Use `cmd /c chcp 65001>nul && type prompt \| codex exec ... > log 2>&1`. |
| External resource reading fails in Windsurf | Windsurf/Cascade network path may differ | Use Codex CLI fallback and keep logs. |

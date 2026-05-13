# Everything-Windsurf-Codex / EWC

<p align="center">
  <strong>A multi-agent collaboration workflow with Windsurf / Cascade as the main entry point and Codex as the delegated execution agent</strong>
</p>

<p align="center">
  <a href="./LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-green.svg"></a>
  <img alt="Windsurf" src="https://img.shields.io/badge/Windsurf-main%20workspace-0EA5E9.svg">
  <img alt="Codex" src="https://img.shields.io/badge/Codex-MCP%20%2F%20CLI%20fallback-7C3AED.svg">
  <img alt="Validation" src="https://img.shields.io/badge/Validation-PASS-brightgreen.svg">
</p>

<p align="center">
  <a href="./README.md">简体中文</a> |
  <strong>English</strong> |
  <a href="./README.es-MX.md">Español (México)</a> |
  <a href="./README.fr.md">Français</a>
</p>

## Project introduction

Everything-Windsurf-Codex / EWC is a lightweight multi-agent collaboration workflow. It is not a Windsurf plugin, and it does not replace Cascade with Codex inside Windsurf.

The core idea is simple: users continue working in Windsurf, while Cascade remains responsible for understanding the request, breaking down the task, choosing the execution channel, limiting permissions, reviewing results, and delivering the final answer. Codex MCP and Codex CLI fallback act as delegated execution agents for lightweight probes, long-running tasks, large scans, batch execution, network fallback, and reviewable logs.

If this project helps you in any way, please consider giving it a Star to encourage me.

In short:

- **Windsurf / Cascade**: the user-facing main entry point, dispatcher, reviewer, and final delivery layer.
- **Codex MCP**: a lightweight execution agent delegated by Cascade for small tasks.
- **Codex CLI fallback**: a delegated execution agent used by Cascade for long-running tasks, large scans, network fallback, batch execution, and reviewable logs.

## Why EWC

Many users like Windsurf because the IDE, chat panel, file preview, and interaction flow all stay in one place.

But in real work, some tasks are not ideal for waiting inside the chat panel:

- Scanning a large repository.
- Drafting long documents.
- Batch edits, formatting, or test investigation.
- Keeping a complete execution log for later review.
- MCP calls taking too long or lacking progress feedback.
- Windsurf / Cascade direct access to GitHub or other overseas resources being unstable.

EWC does not replace Windsurf or bypass Cascade. It keeps the user inside Windsurf and lets Cascade dispatch different execution agents, while Codex handles time-consuming, repetitive, log-sensitive, or network-sensitive tasks as a delegated backend agent.

## Design philosophy: non-invasive and zero-dependency

EWC does not require installing a new IDE plugin, deploying a SaaS service, or moving your project to a specific platform.

It is mainly composed of Markdown documents, workflows, skills, and prompt rules. It relies on a capability Windsurf / Cascade already has: reading documents, understanding rules, and collaborating under constraints.

This makes EWC more like a portable collaboration method than a closed system that locks users into a single toolchain:

- **Non-invasive**: you can start by reading the README and copying a small set of rules.
- **No single-platform lock-in**: the core ideas are role separation, channel selection, safety boundaries, and reviewable logs.
- **No background service dependency**: there is no extra service to register, deploy, or maintain.
- **No unlimited AI authority**: the goal is not to make AI more unrestricted, but to make multiple agents collaborate within clear boundaries.

## Core collaboration model

```text
User continues to describe requests in Windsurf
        
Cascade understands intent, breaks down the task, and selects a channel
        
Small tasks: Cascade or Codex MCP
Long / network / log-sensitive tasks: Codex CLI fallback
        
Codex executes inside a sandbox and an explicitly authorized scope
        
Cascade reviews outputs, diffs, logs, and validation results
        
User accepts the result in Windsurf
```

## Channel selection

| Scenario | Recommended channel |
|---|---|
| Quick read-only analysis of one or two local files | Cascade or Codex MCP |
| Small edits with a clear scope | Cascade or Codex MCP + `workspace-write` |
| Large scans, long tasks, batch edits, test investigation | Codex CLI fallback |
| Tasks requiring complete logs or progress review | Codex CLI fallback |
| MCP takes too long or lacks progress feedback | Codex CLI fallback |
| GitHub / overseas resources are unstable | Codex CLI fallback |
| Business decisions, technical trade-offs, final acceptance | User + Cascade |

## Naturally fits split-network workflows

In environments where domestic resources are accessed directly while overseas resources go through a proxy, or in any other complex network setup, EWC naturally fits a split-network workflow.

It does not force all tools, tasks, and network access through a single entry point. Instead, it separates interaction, dispatching, execution, and network access into independently configurable channels:

- **Windsurf / Cascade**: remains the main entry point for local interaction, request understanding, task dispatching, result review, and final acceptance.
- **Codex MCP**: handles small lightweight tasks and can run in an independent MCP environment when needed.
- **Codex CLI fallback**: handles long-running tasks, large scans, GitHub / overseas resource access, batch execution, and complete logs.

This means that even if Windsurf / Cascade direct access to some overseas resources is unstable, you do not need to force Windsurf's network environment to change. You can delegate those tasks to the more suitable Codex CLI fallback channel.

In other words, EWC does not treat unstable network access as a problem that must be fixed inside one tool. Through multi-agent separation, it naturally splits local interaction, direct domestic access, proxied overseas access, and background execution.

## Reviewable log chain

The key value of CLI fallback is reviewability. A standard execution should preserve at least:

```text
.windsurf/codex-runs/codex-<topic>-<yyyyMMdd-HHmmss>.prompt.txt
.windsurf/codex-runs/codex-<topic>-<yyyyMMdd-HHmmss>.log
.windsurf/codex-runs/codex-<topic>-<yyyyMMdd-HHmmss>.last.md
```

This allows the user and Cascade to review:

- **Prompt**: what Codex was asked to do.
- **Log**: what happened during execution.
- **Last answer**: the final answer Codex produced.

## Safety boundaries

- **Do not read secrets**: never read or output secrets, tokens, `auth.json`, private keys, or other credentials.
- **No default write permission**: Codex may modify files only when explicitly authorized by the user or Cascade.
- **Write scope must be explicit**: the prompt must list the allowed files or directories.
- **No out-of-scope edits**: files outside the authorized scope must not be modified.
- **Review is required**: Cascade reviews diffs, runs validation, and asks for rework when needed.
- **Do not replace business rules**: EWC is an orchestration and validation layer, not a business rules source.
- **Consistent encoding**: README, workflows, skills, and prompts should use UTF-8 without BOM.

## Repository layout

```text
.
 README.md
 README.en.md
 README.es-MX.md
 README.fr.md
 LICENSE
 NOTICE.md
 .gitignore
 ewc/
   README.md
   verify-ewc.ps1
 workflows/
   ewc.md
 global_workflows/
   codex-collab.md
 skills/
   ewc-maintenance/
     SKILL.md
   codex-delegation/
      SKILL.md
 examples/
    mcp_config.codex.json
```

## How to use

The simplest way to use EWC is not necessarily to copy every file manually. You can start by talking to the AI in Windsurf and giving it this project link so it can learn the EWC collaboration model.

You can say this in Windsurf / Cascade:

```text
Please read and learn the collaboration model in this project:
https://github.com/LOrz-3/everything-windsurf-codex

After that, please collaborate with me using the EWC model:
1. Keep Windsurf / Cascade as the main entry point, dispatcher, reviewer, and final delivery layer.
2. Use Codex MCP only for small lightweight tasks.
3. Use Codex CLI fallback for long-running tasks, large scans, batch execution, network fallback, or tasks requiring complete logs.
4. Before Codex writes files, the allowed write scope must be explicitly authorized.
5. After finishing, explain the execution channel, changed files, validation result, and risks.
```

If your AI can access GitHub, it can directly read the README, workflows, skills, and contribution rules. If GitHub access is unstable, clone this repository first or copy the key files into your current Windsurf workspace before asking the AI to read them.

## Quick start

### 1. Copy the workflow

Copy the workflow file into your Windsurf project workflow directory:

```text
workflows/ewc.md -> <workspace>/.windsurf/workflows/ewc.md
```

### 2. Copy the skills

Copy the skill files into your Windsurf skills directory:

```text
skills/ewc-maintenance/SKILL.md
skills/codex-delegation/SKILL.md
```

### 3. Configure Codex MCP

Use this template as a reference:

```text
examples/mcp_config.codex.json
```

The template does not contain any real API key or private local path.

### 4. Run validation

From the repository root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\ewc\verify-ewc.ps1
```

Expected result:

```text
Result: PASS
```

## Who this is for

- Users who like the Windsurf workflow and want to keep requesting and accepting work inside Windsurf.
- Users who want Codex to handle long-running tasks, large scans, and batch execution.
- Users who want AI task execution to have logs that can be reviewed and audited.
- Users who want clear boundaries between MCP and CLI fallback.
- Users who want to build their own lightweight Everything-Windsurf-Codex workflow.

## What this is not for

- Replacing project business rules.
- Bypassing Cascade or human review.
- Handling secrets, tokens, or private keys.
- Treating Codex as an unrestricted write agent.
- Copying directly into every project without adapting local paths and permissions.

## Contribution and maintenance

Issues and Pull Requests are welcome for suggestions, fixes, and documentation improvements.

This project prioritizes the following positioning: Windsurf is the main entry point, Cascade handles dispatching and review, and Codex MCP/CLI fallback performs controlled execution. Changes that affect core positioning, permission boundaries, log strategy, or security rules should be discussed and validated carefully.

If you contribute consistently and understand the project's safety boundaries and maintenance principles, you can contact the author to discuss collaborative maintenance.

Please read before contributing:

- [Contributing Guide](CONTRIBUTING.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Security Policy](SECURITY.md)

## Suggested GitHub Topics

If you publish or fork this project on GitHub, suggested topics are:

```text
windsurf
codex
cascade
mcp
workflow
ai-coding
cli-fallback
developer-tools
```

## Acknowledgements

EWC is inspired by the multi-tool collaboration ideas explored in [`everything-claude-code`](https://github.com/affaan-m/everything-claude-code).

Thanks to the `everything-claude-code` project for exploring cross-AI-coding-harness workflows, shared rules, skill accumulation, and tool adaptation patterns. EWC borrows the idea of shared collaboration conventions plus tool-specific adapters, and independently reorganizes it for the Windsurf + Cascade + Codex MCP/CLI fallback scenario.

Special thanks to [@why41bg](https://github.com/why41bg) for supporting the exploration of this project and for giving me the opportunity to experience and validate the Codex GPT-5.4 workflow.

This project is an independent Windsurf + Cascade + Codex MCP/CLI fallback workflow system. It is not affiliated with, endorsed by, or maintained by the original ECC authors.

If you copy or redistribute third-party code, scripts, templates, or documentation, keep the corresponding copyright notices and license texts.

## License

MIT License. See [LICENSE](LICENSE).

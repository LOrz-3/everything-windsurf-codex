---
description: Maintain Everything-Windsurf-Codex/EWC orchestration and validation rules
---
# EWC Workflow

## Purpose

Use this workflow to maintain Everything-Windsurf-Codex / EWC as an orchestration and validation layer.

It standardizes:

- The division of responsibility among Windsurf, Cascade, Codex MCP, and Codex CLI fallback.
- How Windsurf remains the main entry point while Codex CLI fallback handles long, network-heavy, or log-heavy work.
- When Codex may use `workspace-write` within an explicitly authorized scope.
- CLI fallback log requirements.
- UTF-8 without BOM, secrets safety, and GitHub / external resource fallback rules.

This workflow is not a business rules source and does not replace project-level `AGENTS.md`.

## When to use

Use this workflow when you need to:

1. Update EWC README, workflow, validation script, or maintenance skill.
2. Clarify Codex write permission and scope limits.
3. Add or refine Codex CLI fallback log rules.
4. Convert a long Windsurf task into a Codex CLI fallback prompt.
5. Verify that EWC remains usable, reviewable, and iterative.

## Execution rules

- Windsurf / Cascade remains the main entry and final delivery surface.
- Cascade dispatches tasks, reviews diffs, runs validation, and requests rework.
- Codex MCP is suitable for short and lightweight local tasks.
- Codex CLI fallback is suitable for long tasks, large scans, complete logs, progress review, network fallback, and batch execution.
- Codex may write only when the user or Cascade explicitly authorizes a limited file or directory scope.
- Write prompts must list the allowed files or directories.
- Do not read or output secrets, tokens, `auth.json`, private keys, or credentials.

## CLI fallback contract

A reviewable CLI fallback run should keep:

```text
.windsurf/codex-runs/codex-<topic>-<yyyyMMdd-HHmmss>.prompt.txt
.windsurf/codex-runs/codex-<topic>-<yyyyMMdd-HHmmss>.log
.windsurf/codex-runs/codex-<topic>-<yyyyMMdd-HHmmss>.last.md
```

Final reports should include:

- The execution channel.
- The log path.
- The changed files, if any.
- Validation result.
- Risks and assumptions.

## Validation

Run from the EWC repository root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\ewc\verify-ewc.ps1
```

The result should be `PASS` before release.

## Forbidden actions

- Do not use EWC as a business implementation skill.
- Do not bypass Cascade review.
- Do not expand Codex write scope without explicit authorization.
- Do not let validation scripts auto-fix files.

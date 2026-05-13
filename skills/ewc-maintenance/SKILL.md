---
name: ewc-maintenance
description: Maintain Everything-Windsurf-Codex/EWC orchestration and validation rules for Windsurf, Cascade, Codex MCP, and Codex CLI fallback.
---
# EWC Maintenance Skill

## When to use

Use this skill when a task involves:

1. Maintaining EWC README, workflow, validation script, or related skills.
2. Adjusting channel selection rules among Windsurf, Cascade, Codex MCP, and Codex CLI fallback.
3. Capturing long-term rules for Codex write permission, logs, UTF-8 without BOM, and secrets safety.
4. Reviewing MCP delays, missing progress feedback, network instability, or CLI fallback failures.
5. Keeping Windsurf as the main entry point while Codex CLI fallback works as a background executor.
6. Verifying that EWC is usable, reviewable, and iterative.

## Boundary

This skill maintains the orchestration and validation layer only.

- It does not replace `codex-delegation`.
- It does not replace product, compiler, API, data model, or domain-specific skills.
- It does not decide project strategy by itself.
- It does not replace Cascade's final review and acceptance.
- It is not a business rules source.

## Rule locations

Recommended EWC rule locations:

- `ewc/README.md`
- `workflows/ewc.md`
- `skills/ewc-maintenance/SKILL.md`
- `skills/codex-delegation/SKILL.md`
- `global_workflows/codex-collab.md`

Stable project-specific rules can be synchronized into the target project's `AGENTS.md`.

## When to use Codex CLI fallback

Prefer Codex CLI fallback instead of MCP when:

1. The task is a large scan, long task, batch edit, or test triage.
2. The task needs complete logs, progress feedback, or user-visible replay.
3. MCP waits too long, gives no progress feedback, or fails with unclear cancellation.
4. Windsurf direct network access is unstable or external resources need to be read.
5. MCP is affected by sandbox, approval policy, network, or provider connection issues.
6. The user wants to stay in Windsurf for request and review while Codex executes in the background.

MCP is best for short and lightweight tasks, such as read-only analysis of one or two local files.

## Windsurf + Codex fallback collaboration

- Windsurf / Cascade is the main entry, dispatcher, reviewer, and final delivery surface.
- Codex MCP is the fast sub-agent for short and lightweight tasks.
- Codex CLI fallback is the background executor for long tasks, network fallback, batch execution, and reviewable logs.
- CLI fallback must keep prompt, log, and last answer artifacts.
- This keeps the Windsurf user experience while moving slow, low-feedback, or unstable work to Codex CLI.

## Codex write permission

Codex is not limited to read-only work.

When the user or Cascade explicitly authorizes a limited set of files or directories, Codex may use `workspace-write` within that scope.

Requirements:

- The prompt must list the allowed files or directories.
- Codex must not modify files outside the authorized scope.
- Cascade must review the diff, run validation, and request rework if needed.
- If Codex writes bad changes, Cascade takes over repair and updates the rules if necessary.

## Validation

After maintenance, run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\ewc\verify-ewc.ps1
```

Expected status:

- `PASS`: usable structure.
- `WARN`: usable but with non-critical risks.
- `FAIL`: not releasable until fixed.

## Forbidden actions

- Do not read or output secrets, tokens, `auth.json`, private keys, or credentials.
- Do not use this maintenance skill as a business implementation skill.
- Do not bypass Cascade review.
- Do not let validation scripts auto-fix files.
- Do not expand Codex write scope without explicit authorization.

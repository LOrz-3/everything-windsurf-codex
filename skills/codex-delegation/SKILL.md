---
name: codex-delegation
description: Delegate large scans, batch edits, test triage, and token-heavy work to Codex MCP/CLI while Cascade reviews and accepts the result.
---
# Codex Delegation Skill

## When to trigger

Use this skill when Cascade determines that a task involves:

1. High token consumption: long documents, full-page prototypes, DDL/API docs, large repository scans.
2. Repetitive mechanical work: batch renaming, formatting, template generation.
3. Read-only reconnaissance: mapping project structure, modules, or failure logs.
4. Saving Cascade budget: the task is obvious execution work suitable for Codex.

## When not to trigger

- One-line bugs or tiny UI tweaks are usually faster for Cascade.
- Key business decisions and architecture decisions require Cascade/user judgment.
- Secrets or private data should not be delegated.
- High-risk delete, reset, migration, or destructive operations should not be delegated.

## Execution flow

1. Cascade defines the task and permission scope.
2. Choose the channel:
   - Local small read-only task: Codex MCP.
   - Large scan, long task, complete logs, progress feedback, MCP delay, network fallback, or background execution while the user stays in Windsurf: Codex CLI fallback.
3. For MCP read-only tasks, use `sandbox=read-only` and `approval-policy=on-request`.
4. For MCP write tasks, use `sandbox=workspace-write` only with explicit allowed file or directory scope.
5. Cascade reviews output, checks diffs, validates, and requests rework if needed.

## Codex write permission

Codex may write files only when explicitly authorized.

Requirements:

- The prompt must list allowed files or directories.
- Files outside the authorized scope must not be changed.
- Cascade reviews diffs and validates the result.
- Long-running, log-sensitive, network-sensitive, or progress-sensitive tasks should use CLI fallback instead of MCP.

## Windsurf main entry + CLI fallback

The user can continue using Windsurf to describe requests, inspect files, review results, and accept the final delivery.

When a task is better suited for Codex CLI fallback, Cascade turns the Windsurf request into a prompt, limits the sandbox and write scope, lets Codex execute in the background, and brings `.prompt.txt`, `.log`, and `.last.md` artifacts back to Windsurf for review.

## MCP defaults

| Scenario | sandbox | approval-policy | Notes |
|---|---|---|---|
| Read-only reconnaissance | `read-only` | `on-request` | Default; lets Codex request read-only shell commands. |
| Scoped write | `workspace-write` | `on-request` | Prompt must list allowed files or directories. |
| Not recommended | any | `never` | May block Codex internal read-only shell probes. |

## Safety

- Do not read or output secrets, tokens, `auth.json`, private keys, or credentials.
- Do not expand write scope without explicit authorization.
- Do not bypass Cascade review.

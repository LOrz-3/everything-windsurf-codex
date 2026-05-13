# EWC Core

This directory contains the core documentation and validation script for Everything-Windsurf-Codex / EWC.

## Positioning

EWC is an orchestration and validation layer for Windsurf + Cascade + Codex MCP + Codex CLI fallback collaboration.

It is not a business rules source. Project-level `AGENTS.md`, business documentation, and domain-specific skills remain authoritative for business decisions.

## Core rules

| Topic | Rule |
|---|---|
| Orchestration | EWC coordinates Windsurf, Cascade, Codex MCP, and Codex CLI fallback. |
| Windsurf main entry | The user can keep Windsurf as the main IDE and chat interface. |
| Cascade | Cascade dispatches tasks, limits permissions, reviews diffs, runs validation, and delivers results. |
| Codex MCP | Use for short and lightweight local tasks. |
| Codex CLI fallback | Use for long tasks, large scans, network fallback, full logs, progress review, and batch execution. |
| Write permission | Codex may use `workspace-write` only when the prompt explicitly lists the allowed files or directories. |
| Logs | CLI fallback should keep `.prompt.txt`, `.log`, and `.last.md`. |
| Encoding | Keep workflows, skills, and prompts in UTF-8 without BOM. |
| Secrets | Never read or output secrets, tokens, `auth.json`, private keys, or credentials. |

## When to use CLI fallback

Prefer Codex CLI fallback when:

- The task scans many files or takes a long time.
- The user needs progress visibility or complete logs.
- MCP waits too long or gives no progress feedback.
- GitHub or other network resources are unstable from Windsurf.
- The task needs a reproducible log chain for review.

## Validation

Run from repository root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\ewc\verify-ewc.ps1
```

Expected result:

```text
Result: PASS
```

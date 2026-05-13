# Everything-Windsurf-Codex / EWC

EWC is a lightweight collaboration workflow system for Windsurf users who want to keep Windsurf as the main working interface while delegating heavy, long-running, or log-sensitive tasks to Codex MCP or Codex CLI fallback.

EWC 是一个面向 Windsurf 用户的轻量协作工作流系统：用户继续在 Windsurf / Cascade 中提出需求、查看文件、审查结果和完成验收；Codex MCP 负责短小任务；Codex CLI fallback 负责长任务、网络兜底、批量执行和可复核日志链条。

## Why EWC

- **Keep Windsurf as the main workspace**: Some users prefer Windsurf's IDE, chat panel, file preview, and interaction style.
- **Use Codex as a background executor**: Let Codex handle repository scans, draft generation, batch edits, test triage, and long-running work.
- **Prefer MCP for small tasks**: Use Codex MCP for short local read-only probes or narrow scoped edits.
- **Use CLI fallback for hard cases**: Switch to Codex CLI fallback when tasks need full logs, progress visibility, network fallback, or stable replay.
- **Make results reviewable**: CLI fallback records `.prompt.txt`, `.log`, and `.last.md` so Cascade and the user can review what happened.
- **Keep safety boundaries clear**: Codex may write only when the user or Cascade explicitly authorizes a limited file or directory scope.

## Collaboration model

```text
User works in Windsurf
        ↓
Cascade understands intent and chooses the channel
        ↓
Small task: Cascade or Codex MCP
Heavy / long / network / log task: Codex CLI fallback
        ↓
Codex executes within sandbox and scope limits
        ↓
Cascade reviews output, diffs, logs, and validation
        ↓
User accepts the result in Windsurf
```

## Repository layout

```text
.
├─ README.md
├─ LICENSE
├─ NOTICE.md
├─ .gitignore
├─ ewc/
│  ├─ README.md
│  └─ verify-ewc.ps1
├─ workflows/
│  └─ ewc.md
├─ global_workflows/
│  └─ codex-collab.md
├─ skills/
│  ├─ ewc-maintenance/
│  │  └─ SKILL.md
│  └─ codex-delegation/
│     └─ SKILL.md
└─ examples/
   └─ mcp_config.codex.json
```

## Quick start

1. Clone or copy this repository.
2. Copy `workflows/ewc.md` into your Windsurf project workflow directory, for example `<workspace>/.windsurf/workflows/ewc.md`.
3. Copy `skills/ewc-maintenance/SKILL.md` into your Windsurf skills directory.
4. Copy `skills/codex-delegation/SKILL.md` into your Windsurf skills directory.
5. If you use a global collaboration workflow, copy `global_workflows/codex-collab.md` into your Windsurf global workflows directory.
6. Configure Codex MCP using `examples/mcp_config.codex.json` as a template.
7. Run the verification script from this repository:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\ewc\verify-ewc.ps1
```

## Channel selection rules

| Scenario | Recommended channel |
|---|---|
| One or two local files, quick read-only probe | Codex MCP or Cascade directly |
| Narrow scoped edit with explicit authorization | Codex MCP with `workspace-write` or Cascade |
| Long task, large repository scan, batch edit, test triage | Codex CLI fallback |
| Need complete logs or progress review | Codex CLI fallback |
| MCP waits too long or gives no progress feedback | Codex CLI fallback |
| GitHub / non-mainland network resource reading is unstable in Windsurf | Codex CLI fallback |
| Final judgment, business decision, acceptance | Cascade and user |

## Safety rules

- Do not read or output secrets, tokens, `auth.json`, private keys, or credential files.
- Do not let Codex modify files unless the prompt explicitly lists the allowed files or directories.
- Do not modify files outside the authorized scope.
- Do not let Cascade and Codex edit the same files at the same time.
- Do not treat EWC as a business rules source. EWC is an orchestration and validation layer.
- Keep prompts, workflows, and skills in UTF-8 without BOM.

## CLI fallback log contract

A reproducible CLI fallback run should keep at least:

```text
.windsurf/codex-runs/codex-<topic>-<yyyyMMdd-HHmmss>.prompt.txt
.windsurf/codex-runs/codex-<topic>-<yyyyMMdd-HHmmss>.log
.windsurf/codex-runs/codex-<topic>-<yyyyMMdd-HHmmss>.last.md
```

Final reports should show the log path and summarize the result, changed files, validation, and risks.

## Acknowledgements

EWC is inspired by the public project [`everything-claude-code`](https://github.com/affaan-m/everything-claude-code).

This project is an independent Windsurf + Cascade + Codex MCP/CLI fallback workflow system. It is not affiliated with, endorsed by, or maintained by the original ECC authors.

## License

MIT License. See [LICENSE](LICENSE).

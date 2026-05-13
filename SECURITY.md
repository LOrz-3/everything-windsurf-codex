# Security Policy

## 安全原则

Everything-Windsurf-Codex / EWC 是一个工作流和文档型项目，但仍然需要重视敏感信息、权限边界和日志安全。

## 请不要提交

请不要在 Issue、Pull Request、commit 或日志中提交：

- API key、token、password、secret。
- `auth.json` 或其他认证文件。
- 私钥、证书、SSH key。
- `.env` 或 `.env.*` 文件。
- 个人绝对路径、内部仓库路径或公司私有信息。
- 未脱敏的 `.log`、`.prompt.txt`、`.last.md`。
- 包含敏感业务数据的截图或导出文件。

## Codex / MCP / CLI fallback 安全边界

- 默认使用 read-only 进行分析。
- Codex 只有在用户或 Cascade 明确授权时才可以写入。
- 写入 prompt 必须列出允许修改的文件或目录。
- 不允许修改授权范围外的文件。
- CLI fallback 日志应先脱敏再公开。
- 验证脚本应保持只读检查，不应自动修复或删除文件。

## 报告安全问题

如果你发现安全问题，请优先通过 GitHub Issue 报告，并避免公开敏感细节。

建议包含：

1. 问题概述。
2. 影响范围。
3. 复现步骤。
4. 你建议的修复方向。
5. 已脱敏的示例或日志片段。

如果问题涉及真实凭据、私有路径或未公开信息，请先移除敏感内容再提交。

## 维护响应

维护者会尽量：

- 确认问题是否影响 EWC 的安全边界。
- 修正文档、`.gitignore`、验证脚本或工作流规则。
- 在必要时补充说明，避免用户误提交敏感信息。

## 支持版本

当前仅维护 `main` 分支。

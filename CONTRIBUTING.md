# Contributing to Everything-Windsurf-Codex / EWC

感谢你愿意参与 Everything-Windsurf-Codex / EWC。

EWC 是一个面向 Windsurf + Cascade + Codex MCP/CLI fallback 的轻量协作工作流系统。欢迎通过 Issue 和 Pull Request 提出建议、修复问题、改进文档或补充工作流。

## 欢迎的贡献

- **文档改进**：修正 typo、补充使用说明、优化示例。
- **工作流优化**：改进 Windsurf workflow、Codex delegation、CLI fallback 使用说明。
- **验证增强**：改进 `ewc/verify-ewc.ps1` 的只读检查能力。
- **安全边界补充**：完善 secrets、sandbox、write scope、日志留痕规则。
- **跨平台建议**：补充 Windows、macOS、Linux 下的使用差异。
- **Issue 反馈**：报告不清晰的文档、不可复现的步骤或潜在风险。

## 项目定位

请优先保持以下定位：

- Windsurf / Cascade 是主入口、调度者、审查者和最终交付者。
- Codex MCP 适合短小轻量任务。
- Codex CLI fallback 适合长任务、大范围扫描、网络兜底、完整日志和批量执行。
- Codex 写入必须经过明确授权，并限制在指定文件或目录内。
- EWC 是编排层和验证层，不是业务规则源。

## 不建议的贡献

- 提交 secrets、token、`auth.json`、私钥或凭据。
- 提交 `.log`、`.prompt.txt`、`.last.md` 等本地运行产物。
- 将个人绝对路径写入文档，例如 `C:\Users\...` 或本机工具路径。
- 绕过 Cascade / maintainer 审查，扩大 Codex 写入权限。
- 让验证脚本自动修复文件；验证脚本应保持只读检查。
- 引入大型依赖或复杂框架，破坏轻量定位。

## 提交 Issue

提交 Issue 时建议包含：

1. 你遇到的问题或建议。
2. 你正在使用的工具组合，例如 Windsurf、Cascade、Codex MCP、Codex CLI。
3. 最小复现步骤或截图。
4. 你期望的行为。
5. 如果涉及日志，请先移除敏感信息。

## 提交 Pull Request

提交 PR 前请确认：

1. 修改范围清晰，不包含无关格式化。
2. 没有提交 secrets、日志、prompt 运行产物或个人路径。
3. 如果修改 workflow、skill、README 或验证脚本，请运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\ewc\verify-ewc.ps1
```

4. PR 描述中说明：
   - 改了什么。
   - 为什么改。
   - 如何验证。
   - 是否影响安全边界或写入权限。

## 维护者协作

欢迎长期稳定贡献者参与维护。

一般建议先通过 Issue 和 PR 参与；如果你持续贡献高质量改动，并理解 EWC 的安全边界、权限模型和项目定位，可以联系项目作者讨论协作维护方式。

维护者应遵守：

- 不直接合并高风险权限变更。
- 不扩大 Codex 写入范围，除非有明确讨论和验证。
- 不提交敏感信息或本地运行产物。
- 保持 README、workflow、skill 和验证脚本之间的一致性。
- 对外部项目保持清晰致谢和许可证合规。

## 许可证

提交贡献即表示你同意你的贡献按照本项目的 MIT License 发布。

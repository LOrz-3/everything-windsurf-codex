# Everything-Windsurf-Codex / EWC

<p align="center">
  <strong>一种以 Windsurf / Cascade 为主入口、Codex 为后台执行 Agent 的多 Agent 协作工作流系统</strong>
</p>

<p align="center">
  <a href="./LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-green.svg"></a>
  <img alt="Windsurf" src="https://img.shields.io/badge/Windsurf-main%20workspace-0EA5E9.svg">
  <img alt="Codex" src="https://img.shields.io/badge/Codex-MCP%20%2F%20CLI%20fallback-7C3AED.svg">
  <img alt="Validation" src="https://img.shields.io/badge/Validation-PASS-brightgreen.svg">
</p>

<p align="center">
  <strong>简体中文</strong> |
  <a href="./README.en.md">English</a> |
  <a href="./README.es-MX.md">Español (México)</a> |
  <a href="./README.fr.md">Français</a>
</p>

## 项目简介

Everything-Windsurf-Codex / EWC 是一种轻量级多 Agent 协作方式，而不是“在 Windsurf 里用 Codex 替代 Cascade”的插件方案。

它的核心特色是：用户仍然在 Windsurf 中工作，Cascade 继续负责理解需求、拆分任务、选择通道、限制权限、审查结果和最终交付；Codex MCP / Codex CLI fallback 则作为被调度的执行型 Agent，处理短小探查、长任务、大范围扫描、批量执行、网络兜底和可复核日志。

如果这个项目对您产生了任何帮助，请点击 Star 鼓励我喵。

简单说：

- **Windsurf / Cascade**：面向用户的主入口、调度者、审查者、最终交付者。
- **Codex MCP**：被 Cascade 调度的轻量执行 Agent，适合短小任务。
- **Codex CLI fallback**：被 Cascade 调度的后台执行 Agent，适合长任务、大范围扫描、网络兜底、批量执行和可复核日志链条。

EWC is a lightweight multi-agent collaboration workflow. Windsurf / Cascade remains the main user-facing workspace, dispatcher, reviewer, and final delivery surface, while Codex MCP and Codex CLI fallback act as delegated execution agents for lightweight probes, long-running tasks, network fallback, batch execution, and reviewable logs.

## 为什么需要 EWC

很多人喜欢 Windsurf 的原因很直接：IDE、聊天面板、文件预览和交互节奏都在一个地方，很顺手。

但在实际使用中，有些任务并不适合一直卡在聊天面板里等待：

- 大范围扫描仓库。
- 生成长文档或初稿。
- 批量修改、格式统一、测试排查。
- 需要完整过程日志，方便之后复盘。
- MCP 等待时间长、没有进度反馈。
- Windsurf / Cascade 直连读取 GitHub 或其他境外资料不稳定。

EWC 的做法不是替代 Windsurf，也不是绕开 Cascade，而是让用户继续留在 Windsurf 中工作，由 Cascade 调度不同执行 Agent，把耗时、重复、需要日志或网络兜底的任务交给 Codex 在后台完成。

## 设计理念：非侵入式、零依赖

EWC 不要求用户安装新的 IDE 插件，不要求部署 SaaS 服务，也不要求把项目迁移到某个特定平台。

它主要由 Markdown 文档、workflow、skill 和 prompt 规则组成，依赖的是 Windsurf / Cascade 已经具备的“阅读文档、理解规则、按约束协作”的能力。

这意味着 EWC 更像是一套可复制的协作方法，而不是一个会把用户锁进某个工具链的封闭系统：

- **不侵入现有项目**：可以先从阅读 README 和复制少量规则开始。
- **不绑定单一平台**：核心思想是角色分工、通道选择、安全边界和日志复核。
- **不依赖后台服务**：没有额外服务需要注册、部署或维护。
- **不追求无限授权**：重点不是让 AI 更“自由”，而是让多 Agent 在明确边界内协作。

## 核心协作模式

```text
用户继续在 Windsurf 中提出需求
        
Cascade 理解意图、拆分任务、选择通道
        
短小任务：Cascade 或 Codex MCP
长任务 / 网络任务 / 日志任务：Codex CLI fallback
        
Codex 在 sandbox 和授权范围内执行
        
Cascade 审查输出、diff、日志和验证结果
        
用户在 Windsurf 中验收
```

## 通道选择

| 场景 | 推荐通道 |
|---|---|
| 一两个本地文件的快速只读分析 | Cascade 或 Codex MCP |
| 范围明确的小修改 | Cascade 或 Codex MCP + `workspace-write` |
| 大范围扫描、长任务、批量修改、测试排查 | Codex CLI fallback |
| 需要完整日志或进度复盘 | Codex CLI fallback |
| MCP 等待时间长或缺少进度反馈 | Codex CLI fallback |
| GitHub / 境外资料读取不稳定 | Codex CLI fallback |
| 业务判断、技术取舍、最终验收 | 用户 + Cascade |

## 天生适配分流模式

在“国内资源直连、国外资源走代理”或其他网络环境复杂的场景下，EWC 天生适配分流模式。

它不要求所有工具、所有任务、所有网络访问都挤在同一个入口里完成，而是把交互、调度、执行和网络访问拆成可以独立配置的通道：

- **Windsurf / Cascade**：保持主入口，负责本地交互、需求理解、任务调度、结果审查和最终验收。
- **Codex MCP**：负责短小轻量任务，可以按需运行在独立 MCP 环境中。
- **Codex CLI fallback**：负责长任务、大范围扫描、GitHub / 境外资料读取、批量执行和完整日志。

这样即使 Windsurf / Cascade 直连某些境外资源不稳定，也不需要强行改造 Windsurf 的网络环境；可以把对应任务交给更适合的 Codex CLI fallback 通道处理。

换句话说，EWC 不把“网络访问不稳定”视为必须在单一工具里修复的问题，而是通过多 Agent 分工，把本地交互、国内直连、国外代理和后台执行自然拆开。

## 可复核日志链条

CLI fallback 的关键价值是可复核。一次标准执行至少应保留：

```text
.windsurf/codex-runs/codex-<topic>-<yyyyMMdd-HHmmss>.prompt.txt
.windsurf/codex-runs/codex-<topic>-<yyyyMMdd-HHmmss>.log
.windsurf/codex-runs/codex-<topic>-<yyyyMMdd-HHmmss>.last.md
```

这样用户和 Cascade 可以回看：

- **Prompt**：当时让 Codex 做了什么。
- **Log**：Codex 执行过程中发生了什么。
- **Last answer**：Codex 最终输出了什么结论。

## 安全边界

- **不读取敏感信息**：禁止读取或输出 secrets、token、`auth.json`、private key 或其他凭据。
- **不默认允许写入**：Codex 只有在用户或 Cascade 明确授权时才可以修改文件。
- **写入必须限范围**：prompt 必须显式列出允许修改的文件或目录。
- **不越权修改**：禁止修改授权范围外的文件。
- **必须审查结果**：Cascade 负责审查 diff、运行验证、要求返工。
- **不替代业务规则**：EWC 是编排层和验证层，不是 business rules source。
- **统一编码**：README、workflow、skill、prompt 建议使用 UTF-8 without BOM。

## 仓库结构

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

## 食用方法

最简单的使用方式不是先手动复制所有文件，而是直接在 Windsurf 中和 AI 对话，把这个项目链接发给它，让它先学习 EWC 的协作方式。

你可以在 Windsurf / Cascade 中这样说：

```text
请阅读并学习这个项目的协作方式：
https://github.com/LOrz-3/everything-windsurf-codex

之后请按 EWC 的方式和我协作：
1. Windsurf / Cascade 保持主入口、调度者、审查者和最终交付者。
2. Codex MCP 只用于短小轻量任务。
3. 长任务、大范围扫描、批量执行、网络兜底或需要完整日志的任务，请使用 Codex CLI fallback。
4. Codex 写入文件前必须先明确授权范围。
5. 任务完成后请说明执行通道、改动文件、验证结果和风险。
```

如果你的 AI 能访问 GitHub，它可以直接读取 README、workflow、skill 和贡献规则；如果访问 GitHub 不稳定，可以先 clone 本仓库，或者把关键文件复制到当前 Windsurf workspace 中再让 AI 阅读。

## 快速开始

### 1. 复制 workflow

将文件复制到你的 Windsurf 项目 workflow 目录：

```text
workflows/ewc.md -> <workspace>/.windsurf/workflows/ewc.md
```

### 2. 复制 skills

将技能文件复制到你的 Windsurf skills 目录：

```text
skills/ewc-maintenance/SKILL.md
skills/codex-delegation/SKILL.md
```

### 3. 配置 Codex MCP

参考模板：

```text
examples/mcp_config.codex.json
```

模板中不会包含任何真实 API key 或本机私有路径。

### 4. 运行验证

在本仓库根目录执行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\ewc\verify-ewc.ps1
```

期望结果：

```text
Result: PASS
```

## 适合谁使用

- 喜欢 Windsurf 工作流，希望继续留在 Windsurf 里提需求和验收的人。
- 希望用 Codex 处理长任务、大扫描和批量执行的人。
- 希望 AI 任务过程有日志、可复盘、可审查的人。
- 希望 MCP 和 CLI fallback 有明确边界的人。
- 希望搭建自己轻量版 Everything-Windsurf-Codex 工作流的人。

## 不适合做什么

- 不适合替代项目业务规则。
- 不适合绕过 Cascade 或人工审查。
- 不适合处理 secrets、token、私钥等敏感信息。
- 不适合把 Codex 当作无限制写入代理。
- 不适合直接照搬到所有项目而不做本地路径和权限调整。

## 贡献与维护

欢迎通过 Issue 和 Pull Request 提出建议、修复问题或改进文档。

本项目优先保持以下定位：Windsurf 作为主入口，Cascade 负责调度与审查，Codex MCP/CLI fallback 负责受控执行。涉及项目核心定位、权限边界、日志策略和安全规则的修改，需要经过充分讨论和验证。

如果你长期稳定贡献，并理解本项目的安全边界和维护原则，可以联系项目作者讨论协作维护方式。

参与前建议阅读：

- [贡献指南](CONTRIBUTING.md)
- [行为准则](CODE_OF_CONDUCT.md)
- [安全策略](SECURITY.md)

## 建议 GitHub Topics

如果你在 GitHub 上发布本项目，建议添加：

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

## 致谢 / Acknowledgements

EWC 受公开项目 [`everything-claude-code`](https://github.com/affaan-m/everything-claude-code) 的多工具协作思想启发。

感谢 `everything-claude-code` 项目对跨 AI coding harness 工作流、共享规则、技能沉淀和工具适配模式的探索。EWC 借鉴的是这类共享协作口径 + 不同工具适配的思想，并面向 Windsurf + Cascade + Codex MCP/CLI fallback 场景做了独立整理。

特别感谢 [@why41bg](https://github.com/why41bg) 对本项目探索过程的支持，以及让我有机会体验和验证 Codex GPT-5.4 工作流。

This project is an independent Windsurf + Cascade + Codex MCP/CLI fallback workflow system. It is not affiliated with, endorsed by, or maintained by the original ECC authors.

If you copy or redistribute third-party code, scripts, templates, or documentation, keep the corresponding copyright notices and license texts.

## License

MIT License. See [LICENSE](LICENSE).
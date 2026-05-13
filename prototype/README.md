# HAOP Console 静态原型

这个目录包含 EWC/HAOP 项目的第一版 **HAOP Console** 静态产品原型。

HAOP Console 不是日常工作的入口，也不替代 Windsurf、Cascade、Cursor、Claude Code、VS Code Agent 或其他前台 AI coding harness。日常编码、交互和主工作流仍然发生在前台 Agent / foreground AI coding harness 中。这个原型展示的是一个伴随式管理界面（companion console），用于管理后台 CLI-capable agents、权限 profiles、委派模板、运行记录、可复核日志链条和风险提示。

## 文件

- `prototype/haop-console.html`：单文件静态 HTML 原型，内联 CSS 和少量本地 JavaScript。

## 本地预览

可在仓库根目录启动一个简单的本地 HTTP server：

```bash
python -m http.server 8080
```

然后访问：

```text
http://localhost:8080/prototype/haop-console.html
```

## 边界说明

- 这是纯静态原型，不接真实命令。
- 不执行 shell，不访问网络（network access）。
- 不依赖 CDN 或任何外部字体、图标、CSS、JS、第三方库。
- 不管理 secrets、tokens、`auth.json`、private keys 或其他敏感配置。
- 页面中的 agents、profiles、history、logs、matrix 均为 mock 数据，仅用于产品表达和截图展示。

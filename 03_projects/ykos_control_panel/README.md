# YkOS Control Panel

## Goal

构建一个本地优先的小型 GUI，让用户可以用按钮和清晰面板操作 YkOS：

- 同步 Google Drive、本地 YkOS、GitHub。
- 检查 inbox 和 pending Memory Transaction。
- 快速打开最新记忆快照。
- 生成给 ChatGPT、Gemini、NotebookLM、Codex 的高质量提示词。
- 查看 daily review 和同步日志。

## Why

当前 YkOS 已经具备 Markdown 知识库、Drive 同步、GitHub 同步和 Memory Transaction 规则，但主要入口仍是命令行和手写提示词。

GUI 的作用是降低操作摩擦：

- 用户不需要记复杂命令。
- 新 AI 会话可以快速获得标准 prompt。
- 同步、检阅和审查变成可见流程。
- 风险动作在界面上明确提示。

## Repository Boundary

控制面板应用程序独立放在：

```text
E:\project\YkOS-ControlPanel
```

YkOS 主仓库只保留本项目的设计记录、API 合同和提示词：

```text
E:\project\YkOS\03_projects\ykos_control_panel
```

原因：

- YkOS 是 Markdown 长期记忆源。
- Control Panel 是操作工具。
- 前端依赖、构建产物和应用代码不应污染知识库仓库。

## MVP Scope

v0.4 只做控制面板，不做复杂自动化：

- Dashboard 状态页。
- Sync Center。
- Inbox Review。
- Memory Transactions 列表。
- Prompt Launcher。
- Daily Reviews。

## Non-goals

- 不接 API。
- 不做 MCP Server。
- 不做爬虫。
- 不自动审批知识库。
- 不直接写入 `02_knowledge/`。
- 不把整个 YkOS 镜像到 Google Drive。
- 不做复杂权限系统。

## Backend Contract

后端应暴露这些本地能力：

- `status`：读取 Drive 路径、Git 状态、pending 数、inbox 数。
- `drive_sync`：运行 `scripts/ykos_sync.ps1`。
- `super_sync_plan`：运行 `scripts/ykos_super_sync.ps1 -Mode Plan`。
- `super_sync_apply`：运行 `scripts/ykos_super_sync.ps1 -Mode Apply`。
- `latest_snapshot`：定位最新 `05_outputs/reports/*ykos_memory_snapshot_for_drive.md`。
- `list_inbox`：列出 `01_inbox/` 文件。
- `list_memory_transactions`：列出 pending / approved / rejected。
- `generate_prompt`：根据任务类型生成可复制 prompt。

## Frontend Design Direction

前端由 Gemini 设计，方向是：

- 简洁、工具型、低装饰。
- 首页直接是控制面板，不做营销 landing page。
- 多用状态、列表、按钮、标签页。
- 避免大面积渐变和花哨插画。
- 重点展示“现在是否安全同步”和“下一步该做什么”。

## Next Actions

1. 把 `07_prompts/gemini/ykos_gui_design.md` 发给 Gemini。
2. 让 Gemini 产出静态 HTML/CSS/JS 原型。
3. 本地 Codex 在 `E:\project\YkOS-ControlPanel` 实现最小后端。
4. 用真实脚本跑通 Drive Sync / Super Sync Plan。
5. 再决定是否接入 Apply。

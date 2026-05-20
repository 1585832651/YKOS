# 2026-05-19 YkOS 最新记忆快照

## 目的

本文件用于同步到 Google Drive，供 NotebookLM、Gemini、Google AI Studio 等 Google 工具读取。

Google Drive 只作为交换层，不作为最终记忆源。最终记忆源仍然是：

- 本地 YkOS 仓库：`E:\project\YkOS`
- GitHub 仓库：`1585832651/YKOS`

## 当前稳定身份记忆

来源：`MEMORY.md`

- 用户是华中科技大学人工智能专业研究生。
- 用户研究方向是 AI + 电网。
- 用户希望成为 AI + 能源方向的研究型 Builder。
- YkOS 应支持科研、项目推进、内容生产和多工具复盘。
- YkOS 不依赖聊天记录作为长期记忆。

## 当前核心方向

来源：`MEMORY.md`

- AI + 电网科研。
- AI Agent 与企业 Agent 系统。
- Vibe Coding 与 AI 辅助软件构建。
- 公众号与自媒体内容。
- 投资研究。

## 当前系统规则

来源：`MEMORY.md`、`AGENTS.md`、`WORKFLOW.md`

- 每次重要工具输出必须包含 Memory Delta。
- 重要更新必须先进入 `04_memory_transactions/pending/`。
- 正式记忆只应包含经过审核、有用且有来源的信息。
- `01_inbox/` 保存未审核输入。
- `04_memory_transactions/pending/` 保存待审核记忆变更。
- `02_knowledge/` 只保存经过确认的长期知识。
- MVP 阶段不接 API、不写爬虫、不做 MCP Server、不安装依赖。

## 已批准的长期知识

来源：`04_memory_transactions/approved/2026-05-19_ykos_build_experience.md`

### 本地 Codex 与 GitHub Cloud Codex 协作模式

来源：`02_knowledge/vibe_coding/ykos_local_cloud_codex_workflow.md`

- 本地 Codex App 负责本地环境、Google Drive、Obsidian、PowerShell、本机脚本和真实运行验证。
- GitHub Cloud Codex 负责 GitHub issue、PR、仓库内代码和文档修改。
- GitHub 仓库作为两者之间的代码与文档同步点。
- Cloud Codex 不能验证本机 `G:\`、Obsidian 和 PowerShell 环境。
- 本地 Codex 可以验证真实环境，但网络 push 可能受沙箱限制，需要本机 PowerShell 或授权执行。

### Memory Transaction 工作流

来源：`02_knowledge/agents/ykos_memory_transaction_workflow.md`

标准路径：

```text
工具输出 / 对话 / Drive 输入
-> 01_inbox/
-> 04_memory_transactions/pending/
-> 人工审核
-> 02_knowledge/
```

核心规则：

- 不把 AI 聊天记录直接当长期记忆。
- 所有重要工具输出必须先进入 pending Memory Transaction。
- 人工审核后，才允许进入正式知识库。
- 事实、推理、决策和风险必须分开记录。
- 脚本不能自动审批正式知识库变更。

### YkOS 使用偏好

来源：`02_knowledge/self/ykos_working_preferences.md`

- YkOS 项目的说明性文字默认使用中文。
- 工具名、路径、命令、协议关键词可以保留英文。
- 自动化脚本应先提供 Plan / dry-run，再提供 Apply。
- 测试必须尽量真实运行，而不是只停留在设计层。
- 失败应记录原因并修复，不能假装通过。

## 当前 Google Drive 同步状态

来源：`scripts/ykos_config.json`、`scripts/ykos_sync.ps1`

当前 Drive 路径：

```text
G:\我的云端硬盘\YkOS_Drive
```

当前同步映射：

```text
Drive -> 本地 inbox
G:\我的云端硬盘\YkOS_Drive\02_notebooklm_exports -> 01_inbox/notebooklm
G:\我的云端硬盘\YkOS_Drive\03_gemini_outputs -> 01_inbox/gemini
G:\我的云端硬盘\YkOS_Drive\04_google_ai_studio -> 01_inbox/gemini
G:\我的云端硬盘\YkOS_Drive\01_sources\papers -> 01_inbox/papers

本地 -> Drive
05_outputs/reports -> G:\我的云端硬盘\YkOS_Drive\00_export_to_ykos\reports
05_outputs/prompts -> G:\我的云端硬盘\YkOS_Drive\00_export_to_ykos\prompts
```

## 当前待审核事项

来源：`04_memory_transactions/pending/`

- 多个 Drive Sync / Super Sync 运行记录仍在 pending。
- 这些记录主要反映同步脚本运行状态，不等于长期知识。
- 需要人工判断哪些同步经验应进入正式知识库。

## 给 NotebookLM / Gemini 的使用方式

读取本文件时，请遵守：

- 把本文件视为当前 YkOS 状态快照，而不是唯一事实源。
- 如果要提出知识库更新，必须输出 Memory Delta。
- 不要直接要求写入 `02_knowledge/`。
- 对任何新增事实，必须标明来源。
- 对推理、建议和判断，必须和事实分开。

## Memory Delta

### New Facts

- 来源：`MEMORY.md`
  - 事实：YkOS 的长期定位是个人 AI 知识库与工作流中枢。
- 来源：`02_knowledge/`
  - 事实：YkOS 已形成本地 Codex App 与 GitHub Cloud Codex 的双执行器协作模式。
- 来源：`scripts/ykos_config.json`
  - 事实：当前 Google Drive 交换路径为 `G:\我的云端硬盘\YkOS_Drive`。

### Inference / Analysis

- Google Drive 应作为 Google 工具读取 YkOS 状态的交换层。
- 最新记忆同步到 Drive 时，应优先同步快照文件，而不是直接镜像正式知识库。

### Decisions

- 本快照放入 `05_outputs/reports/`，由现有同步脚本导出到 Google Drive。
- 本快照不修改 `02_knowledge/`。
- 本快照不代表 pending 内容已获批准。

### Open Questions

- 是否需要建立固定的每日 `ykos_memory_snapshot_for_drive.md` 覆盖式文件？
- 是否需要让 NotebookLM 只读取快照，而不读取整个 Drive 交换层？

### Next Actions

- 运行 `scripts/ykos_sync.ps1` 将本快照同步到 Google Drive。
- 在 Google Drive 中确认本文件出现在 `00_export_to_ykos/reports/`。
- 如果 NotebookLM/Gemini 读取本快照后产生新结论，应回写到 Drive 输入区，再进入 YkOS inbox。

# 给 Gemini 的任务：设计 YkOS Control Panel GUI

请先读取：

```text
00_README_FOR_GOOGLE_TOOLS.md
00_export_to_ykos/reports/2026-05-19_ykos_memory_snapshot_for_drive.md
```

然后执行下面的设计任务。

---

# Gemini Prompt：设计 YkOS Control Panel GUI

你现在是 YkOS Control Panel 的前端设计师。请基于下面的产品说明，设计一个简洁、实用、本地优先的 GUI 原型。

## 项目背景

YkOS 是用户的个人 AI 知识库与工作流中枢。

用户身份：

- 华中科技大学人工智能专业研究生。
- 研究方向：AI + 电网。
- 目标：成为 AI + 能源方向的研究型 Builder。

YkOS 当前连接：

- 本地 YkOS：`E:\project\YkOS`
- Google Drive：`G:\我的云端硬盘\YkOS_Drive`
- GitHub：`1585832651/YKOS`
- 工具：ChatGPT、Codex、Gemini、NotebookLM、Google AI Studio、Obsidian。

## 设计目标

设计一个本地控制面板，让用户可以：

1. 一键查看 YkOS 当前状态。
2. 一键运行 Google Drive 同步。
3. 一键运行 Super Sync Plan。
4. 在确认安全后运行 Super Sync Apply。
5. 检查 inbox 文件。
6. 检查 pending Memory Transaction。
7. 打开最新记忆快照。
8. 生成给 ChatGPT / Gemini / NotebookLM / Codex 的高质量提示词。
9. 查看 daily review 和同步日志。

## 必须遵守的系统规则

- Google Drive 是交换层，不是最终知识库。
- 最终知识源是本地 YkOS + GitHub。
- 长期记忆必须是 Markdown。
- 重要更新必须先进入 `04_memory_transactions/pending/`。
- 不能直接写 `02_knowledge/`。
- 所有事实必须有来源。
- 工具输出必须生成 Memory Delta。
- 危险动作必须先 Plan 后 Apply。

## 页面结构

请设计一个单页应用，有这些区域：

### 1. 顶部栏

显示：

- YkOS Control Panel
- 当前仓库路径
- Drive 状态
- GitHub 状态

### 2. Dashboard

展示状态卡片：

- Drive Path：connected / missing
- Git：ahead / behind / clean / dirty
- Pending Memory Transactions 数量
- Inbox 新文件数量
- Latest Snapshot
- Latest Daily Review

主要按钮：

- 检查状态
- 打开最新记忆快照
- 生成今日简报 Prompt

### 3. Sync Center

显示三个主要操作：

- Drive Sync
  - 说明：同步 Drive 输入和本地输出；不 commit / push。
- Super Sync Plan
  - 说明：预演完整同步；不写文件、不 commit、不 push。
- Super Sync Apply
  - 说明：执行同步、生成记录、commit、push。

要求：

- Apply 按钮必须视觉上更谨慎。
- Apply 前需要显示确认状态。
- 输出日志区域必须清晰。

### 4. Inbox Review

按来源展示：

- NotebookLM
- Gemini
- ChatGPT
- Papers
- Web
- Ideas

每个文件显示：

- 文件名
- 修改时间
- 来源目录
- 是否已有 Memory Delta

按钮：

- 预览
- 生成总结 Prompt
- 生成 Memory Delta Prompt

### 5. Memory Transactions

展示：

- Pending
- Approved
- Rejected

每条显示：

- 文件名
- 时间
- 来源
- 风险提示
- 人工审核状态

按钮：

- 预览
- 复制审核 Checklist

不要设计自动 approve 为主功能。

### 6. Prompt Launcher

提供可复制 prompt：

- 今日主线
- 晚间复盘
- NotebookLM 输出整理
- Gemini 审核
- Codex 本地仓库审计
- Memory Delta 生成

每个 prompt 都必须要求：

- 输出 Summary
- 输出 Sources
- 区分 Facts / Inference / Decisions
- 输出 Next Actions
- 输出 Memory Delta

### 7. Daily Reviews

展示最近 daily review：

- 日期
- 文件名
- 摘要
- 关联 pending

## 视觉风格

请做成工作台风格，不要做营销页。

风格要求：

- 简洁、克制、信息密度适中。
- 类似本地开发工具、任务控制台、知识库仪表盘。
- 颜色不要只有单一蓝紫色。
- 不要大渐变背景。
- 不要夸张插画。
- 卡片圆角不超过 8px。
- 按钮清晰区分普通动作、预演动作、危险动作。
- 重点突出状态、列表、日志和下一步动作。

## 输出要求

请输出：

1. UI 设计说明。
2. 页面布局。
3. 组件清单。
4. 关键交互流程。
5. 文案建议。
6. 状态颜色规则。
7. 一个可直接实现的 HTML/CSS/JS 静态原型。
8. Memory Delta。

## 可用示例数据

```json
{
  "repoPath": "E:\\project\\YkOS",
  "drivePath": "G:\\我的云端硬盘\\YkOS_Drive",
  "driveStatus": "connected",
  "gitStatus": "dirty",
  "ahead": 0,
  "behind": 0,
  "pendingCount": 8,
  "inboxCount": 1,
  "latestSnapshot": "2026-05-19_ykos_memory_snapshot_for_drive.md",
  "latestReview": "2026-05-20_drive_sync_review.md"
}
```

## Memory Delta

请在最终输出中包含：

- New Facts
- Inference / Analysis
- Decisions
- Open Questions
- Next Actions
- Source / Artifact

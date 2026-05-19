# YkOS 工作流

## 每日早间简报

输入：

- `MEMORY.md`
- `ROADMAP.md`
- `TASKS.md`
- 最近的每日或每周复盘

输出：

- 今日唯一主线。
- P0 任务列表。
- 风险与阻塞。
- 如稳定记忆需要变化，则输出 Memory Delta。

回流路径：

- `06_reviews/daily/YYYY-MM-DD_morning.md`
- 待审核记忆更新进入 `04_memory_transactions/pending/`

## 工作会话

1. 从 `TASKS.md` 选择一个任务。
2. 只收集完成任务所需的最小来源。
3. 产出或编辑 Markdown 文件。
4. 原始工具输出保留在 inbox 或 outputs。
5. 结束时输出摘要、变更文件、风险、下一步动作和 Memory Delta。

## 工具输出协议

每次有意义的工具输出必须说明：

- 来源或输入文件。
- 提取到的事实。
- 假设或推理。
- 影响文件。
- Memory Delta。

## Memory Transaction

重要更新使用 `04_memory_transactions/pending/TEMPLATE.md`。Memory Transaction 应区分事实、推理、决策、拟议修改和风险。

状态规则：

- pending：已提出，等待审核。
- approved：已接受并可应用。
- rejected：未接受，但保留用于追踪。

## 晚间复盘

输入：

- 已完成工作。
- 工具输出。
- 文件变更。
- pending Memory Transaction。

输出：

- 每日复盘。
- 必要时更新 TASKS。
- 拟议 Memory Transaction。

回流路径：

- `06_reviews/daily/YYYY-MM-DD_evening.md`
- `04_memory_transactions/pending/`

## 每周复盘

输入：

- 每日复盘。
- 已完成项目变更。
- ROADMAP 与 TASKS。

输出：

- 每周总结。
- 下周 P0/P1。
- 过时假设。
- 已批准记忆更新。

回流路径：

- `06_reviews/weekly/YYYY-WW.md`

## 工具回流路径

- ChatGPT：`01_inbox/chatgpt/`、`06_reviews/`、`04_memory_transactions/pending/`
- Codex：直接修改仓库、`06_reviews/`、`04_memory_transactions/pending/`
- Gemini：`01_inbox/gemini/`、`05_outputs/`
- NotebookLM：`01_inbox/notebooklm/`，审核后进入 `02_knowledge/`
- opencode：`05_outputs/code/`、项目目录
- Web Search：`01_inbox/web/`
- X / Twitter Search：`01_inbox/twitter_x/`

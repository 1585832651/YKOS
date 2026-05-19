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

## Google Drive Exchange Workflow

Google Drive 是 NotebookLM、Gemini、Google AI Studio 与本地 YkOS 之间的交换层，不是最终记忆源。

输入路径：

- `G:\我的云端硬盘\YkOS_Drive\02_notebooklm_exports` -> `01_inbox/notebooklm`
- `G:\我的云端硬盘\YkOS_Drive\03_gemini_outputs` -> `01_inbox/gemini`
- `G:\我的云端硬盘\YkOS_Drive\04_google_ai_studio` -> `01_inbox/gemini`
- `G:\我的云端硬盘\YkOS_Drive\01_sources\papers` -> `01_inbox/papers`

输出路径：

- `05_outputs/reports` -> `G:\我的云端硬盘\YkOS_Drive\00_export_to_ykos\reports`
- `05_outputs/prompts` -> `G:\我的云端硬盘\YkOS_Drive\00_export_to_ykos\prompts`

运行方式：

1. Google 工具输出先放入 Drive 对应目录。
2. 手动运行 `scripts/ykos_sync.ps1`。
3. 脚本把 Drive 输入复制到 `01_inbox/`，并生成 pending Memory Transaction。
4. 脚本生成 daily review，用于记录同步文件数量和审核事项。
5. 人工审核 pending Memory Transaction。
6. 只有人工 approve 后，内容才允许进入 `02_knowledge/`。
7. GitHub push 前必须确认 pending 审核状态和正式知识库变更。

禁止规则：

- Drive 输出不能直接写入 `02_knowledge/`。
- 同步脚本不能修改 `02_knowledge/`。
- 同步脚本不能执行 git commit 或 git push。
- 同步脚本不能同步 `.git`。
- 同步脚本不能删除文件。

## 工具回流路径

- ChatGPT：`01_inbox/chatgpt/`、`06_reviews/`、`04_memory_transactions/pending/`
- Codex：直接修改仓库、`06_reviews/`、`04_memory_transactions/pending/`
- Gemini：`01_inbox/gemini/`、`05_outputs/`
- NotebookLM：`01_inbox/notebooklm/`，审核后进入 `02_knowledge/`
- opencode：`05_outputs/code/`、项目目录
- Web Search：`01_inbox/web/`
- X / Twitter Search：`01_inbox/twitter_x/`

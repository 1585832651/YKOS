# 工具登记表

| 工具 | 角色 | 输入 | 输出 | 回流路径 | 状态 |
| --- | --- | --- | --- | --- | --- |
| ChatGPT | 策略、综合、每日计划、复盘 | MEMORY、ROADMAP、TASKS、选定 inbox 笔记 | briefing、review、Memory Delta | `01_inbox/chatgpt/`、`04_memory_transactions/pending/`、`06_reviews/` | 计划中 |
| Codex | 本地仓库编辑、审计、编码工作流 | 本地文件、任务说明 | 文件修改、审计报告、Memory Delta | 仓库文件、`06_reviews/`、`04_memory_transactions/pending/` | 已启用 |
| NotebookLM | 基于来源的阅读与综合 | 论文、文档、来源包 | 有来源的笔记 | `01_inbox/notebooklm/`，审核后进入 `02_knowledge/` | 计划中 |
| Gemini / Google AI Studio | 长上下文分析与多模态探索 | 笔记、论文、图片、提示词 | 草稿、对比、假设 | `01_inbox/gemini/`、`05_outputs/` | 计划中 |
| opencode | 本地编码 Agent 工作流 | 仓库任务、文件 | 代码修改、实现说明 | `05_outputs/code/`、项目目录 | 计划中 |
| Google Drive | 文件存储与来源交换 | 文档、PDF、导出笔记 | 来源文件与共享文档 | `01_inbox/raw/`、外部 Drive 文件夹 | 计划中 |
| Obsidian | 本地知识浏览与链接 | Markdown vault | 双链笔记、导航 | 整个仓库作为 vault | 计划中 |
| GitHub | 版本控制与发布 | 本地 Git 仓库 | 远程提交、issue、release | GitHub 远程仓库 | 已启用 |
| Web Search | 当前事实发现 | 搜索问题 | 有来源的原始发现 | `01_inbox/web/`、Memory Transaction | 手动 |
| X / Twitter Search | 社交信号与专家追踪 | 主题查询、账号 | 线索、观点、引用 | `01_inbox/twitter_x/` | 手动 |

## 登记规则

工具输出默认不是正式知识。它必须有明确回流路径，在适用时保留来源，并在推进正式知识库前生成 Memory Delta。

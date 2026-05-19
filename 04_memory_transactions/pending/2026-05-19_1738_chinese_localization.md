# 2026-05-19 17:38 中文化 Memory Delta

## Memory Delta

### 新事实

- 来源：用户本次指令
  - 事实：用户要求 YkOS 项目的 README 等文字信息全部使用中文。
- 来源：本次本地文件修改
  - 事实：根目录核心文件、`00_system/` 同步副本、项目页、提示词模板、Memory Transaction 文件、每日复盘文件已统一改为中文表达。
- 来源：本次同步检查
  - 事实：`AGENTS.md`、`MEMORY.md`、`ROADMAP.md`、`TASKS.md`、`INDEX.md`、`TOOL_REGISTRY.md`、`WORKFLOW.md` 与 `00_system/` 中的对应副本保持一致。

### 推理 / 分析

- YkOS 是用户个人长期知识库，中文表达更符合当前使用习惯和后续维护成本。
- 工具名、文件名、命令名、路径和 Memory Delta 等协议关键词可以保留英文，因为这些属于系统标识或外部工具名称。

### 决策

- YkOS 的说明性文字默认使用中文。
- 后续新增文档、复盘、Prompt、Memory Transaction 应优先使用中文。
- 英文只用于工具名、文件名、代码命令、固定协议关键词或必要专有名词。

### 开放问题

- 是否需要后续把目录名也中文化？当前建议不改目录名，以保持工具兼容性和路径稳定。
- 是否需要增加一份中文写作风格指南，约束后续文档语气和格式？

### 下一步动作

- 提交并推送本次中文化修改。
- 后续新增内容时，优先按中文模板写入。
- 在下一轮结构审计中检查是否还有说明性英文残留。

### 来源 / 产物

- 用户指令：要求项目文字信息全部使用中文。
- `README.md`
- `AGENTS.md`
- `MEMORY.md`
- `ROADMAP.md`
- `TASKS.md`
- `INDEX.md`
- `TOOL_REGISTRY.md`
- `WORKFLOW.md`
- `00_system/`
- `03_projects/`
- `04_memory_transactions/pending/`
- `06_reviews/daily/`
- `07_prompts/`

## 是否需要人工审核

是。该 Memory Delta 记录了项目文档语言策略，应由用户确认后再决定是否进入正式记忆。

## 状态

pending

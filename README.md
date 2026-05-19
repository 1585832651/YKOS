# YkOS

YkOS 是一个个人 AI 知识库与工作流中枢。它用于沉淀长期 Markdown 记忆、科研笔记、项目状态、工具输出审核，并服务 ChatGPT、Codex、Gemini、NotebookLM、opencode、Google Drive、Obsidian 和 GitHub 的后续接入。

## MVP v0.1 目标

YkOS v0.1 只搭建仓库骨架和运行协议：

- 建立稳定的 Markdown-first 记忆文件。
- 划分 inbox、知识库、项目、输出、复盘和提示词区域。
- 建立 Memory Delta 与 Memory Transaction 规则。
- 创建 AI + 电网、Agent、内容创作、投资研究等方向的项目页。
- 创建可重复使用的 ChatGPT 与 Codex Prompt 模板。

## 当前不做什么

- 不接 API。
- 不写 MCP Server。
- 不做爬虫。
- 不引入外部依赖。
- 不做自动化同步。
- 不创建复杂脚本。

## 目录说明

- `00_system/`：系统协议归档区。MVP 初始化时与根目录入口文件保持一致。
- `01_inbox/`：来自工具和外部来源的原始输入，进入审核前先放这里。
- `02_knowledge/`：经过审核的长期知识，按主题分类。
- `03_projects/`：当前项目空间与项目说明文件。
- `04_memory_transactions/`：待审核、已批准、已拒绝的记忆更新。
- `05_outputs/`：文章、代码、备忘录、报告、提示词等成品输出。
- `06_reviews/`：每日、每周、每月复盘记录。
- `07_prompts/`：ChatGPT、Codex、Gemini、NotebookLM、opencode 可复用提示词。

## 工具回流路径

1. ChatGPT、Gemini、NotebookLM、Codex、opencode、Web Search、X / Twitter Search 可以产生有价值的输出。
2. 原始或未验证输出先进入 `01_inbox/` 或 `05_outputs/`。
3. 每次重要工具输出都必须包含 Memory Delta。
4. 重要更新先形成文件，放入 `04_memory_transactions/pending/`。
5. 只有经过审核且有来源的事实，才能进入 `02_knowledge/`、`MEMORY.md`、`ROADMAP.md` 或项目文件。

## 核心规则

AI 聊天记录不是长期记忆。长期记忆必须沉淀为 Markdown，并包含来源、审核状态和清晰的归属。

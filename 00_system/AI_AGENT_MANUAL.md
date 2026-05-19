# YkOS AI Agent 使用手册

## 1. 你的角色

你是在 YkOS 仓库中工作的 AI Agent。你的任务不是把聊天记录保存下来，而是把有价值的信息沉淀为可审核、可追溯的 Markdown 文件。

工作目录：

```text
E:\project\YkOS
```

最终记忆源：

- 本地 YkOS 仓库
- GitHub 仓库 `1585832651/YKOS`

交换层：

- Google Drive：`G:\我的云端硬盘\YkOS_Drive`

## 2. 必读文件

每次开始实质性工作前，至少读取：

- `AGENTS.md`
- `MEMORY.md`
- `ROADMAP.md`
- `TASKS.md`
- `WORKFLOW.md`
- `TOOL_REGISTRY.md`
- `00_system/DRIVE_SYNC.md`

如果任务涉及测试或同步，再读取：

- `scripts/ykos_config.json`
- `scripts/ykos_sync.ps1`
- `scripts/ykos_day_simulation.py`
- `00_system/DAY_SIMULATION_FLOW.md`

## 3. 核心原则

1. 不把 AI 聊天记录当长期记忆。
2. 长期记忆必须是 Markdown。
3. 所有重要输出必须生成 Memory Delta。
4. 所有事实必须有来源；无来源内容只能作为观点、假设或待验证项。
5. 重要更新必须先进入 `04_memory_transactions/pending/`。
6. 未经人工审核，不得写入 `02_knowledge/`。
7. Google Drive 是交换层，不是最终记忆源。
8. 不删除用户文件，不同步 `.git`，不自动 commit / push，除非用户明确要求。

## 4. 目录职责

- `00_system/`：系统规范、流程图、Agent 手册、同步规范。
- `01_inbox/`：未审核输入，包括 NotebookLM、Gemini、论文、网页、想法。
- `02_knowledge/`：正式知识库，只能写入人工审核后的内容。
- `03_projects/`：项目页和项目上下文。
- `04_memory_transactions/pending/`：待审核 Memory Transaction。
- `04_memory_transactions/approved/`：已批准 Memory Transaction。
- `04_memory_transactions/rejected/`：已拒绝 Memory Transaction。
- `05_outputs/`：日志、报告、文章、代码、prompt 等输出。
- `06_reviews/`：daily / weekly / monthly 复盘。
- `07_prompts/`：给 ChatGPT、Codex 等工具复用的提示词。
- `scripts/`：本地脚本与配置。

## 5. Google Drive 同步流程

配置文件：

```text
scripts/ykos_config.json
```

当前 Drive 路径：

```text
G:\我的云端硬盘\YkOS_Drive
```

同步脚本：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ykos_sync.ps1
```

同步规则：

- Drive `02_notebooklm_exports` -> `01_inbox/notebooklm`
- Drive `03_gemini_outputs` -> `01_inbox/gemini`
- Drive `04_google_ai_studio` -> `01_inbox/gemini`
- Drive `01_sources/papers` -> `01_inbox/papers`
- 本地 `05_outputs/reports` -> Drive `00_export_to_ykos/reports`
- 本地 `05_outputs/prompts` -> Drive `00_export_to_ykos/prompts`

脚本会生成：

- `04_memory_transactions/pending/YYYY-MM-DD_HHmm_drive_sync.md`
- `06_reviews/daily/YYYY-MM-DD_drive_sync_review.md`

脚本不得：

- 修改 `02_knowledge/`
- 删除文件
- commit
- push
- 同步 `.git`
- 调 API
- 写 MCP Server

## 6. 一天自动化模拟测试

脚本：

```text
scripts/ykos_day_simulation.py
```

dry-run：

```powershell
D:\anaconda\envs\rl311\python.exe scripts\ykos_day_simulation.py --repo-root . --dry-run --seed 20260519
```

真实同步测试：

```powershell
D:\anaconda\envs\rl311\python.exe scripts\ykos_day_simulation.py --repo-root . --seed 20260519
```

测试会生成：

- `04_memory_transactions/pending/YYYY-MM-DD_HHmm_day_simulation.md`
- `06_reviews/daily/YYYY-MM-DD_day_simulation_review.md`
- `05_outputs/logs/YYYY-MM-DD_HHmm_day_simulation_log.md`
- `05_outputs/logs/YYYY-MM-DD_HHmm_day_simulation_log.json`
- `00_system/DAY_SIMULATION_FLOW.md`

当前已验证结果：

- dry-run 通过。
- 非 dry-run 通过。
- `ykos_sync.ps1` 真实执行状态为 `ok`。
- 当前 inbox 文件数为 `0`，所以已验证流程，但还未验证真实知识抽取质量。

## 7. Memory Transaction 写法

模板：

```text
04_memory_transactions/pending/TEMPLATE.md
```

必须包含：

- ID
- 触发原因
- 来源
- 提取事实
- 推理
- 决策
- 影响文件
- 拟议修改
- 风险
- 是否需要人工审核
- 状态

规则：

- 事实必须有来源。
- 推理必须标记不确定性。
- 自动审批只能作为模拟状态，不能替代人工审核。
- 进入正式知识库前必须人工 approve。

## 8. 工作输出格式

每次完成实质性工作后，输出：

1. 摘要
2. 变更文件
3. 测试结果
4. 风险
5. 下一步动作
6. Memory Delta

## 9. Git 规则

默认只改文件，不自动 commit / push。

只有用户明确要求“提交”“push”“上传 GitHub”时，才执行：

```powershell
git -c safe.directory=E:/project/YkOS status --short --branch
git -c safe.directory=E:/project/YkOS add <明确文件>
git -c safe.directory=E:/project/YkOS commit -m "<message>"
git -c safe.directory=E:/project/YkOS push
```

不要把以下内容误提交：

- `.obsidian/`
- 未确认的 `02_knowledge/` 草稿
- Python 缓存 `__pycache__/`
- `.pyc`
- secrets / credentials / `.env`

## 10. 遇到冲突时

- 如果 GitHub cloud Codex 和本地 Codex 都改了同一块内容，先 fetch，再审 diff，不要直接覆盖。
- 如果 Drive 路径无法访问，先记录失败原因，不要猜路径。
- 如果 inbox 为空，报告“流程通过但知识抽取未验证”。
- 如果用户要求自动化，仍必须保留人工审核门禁。

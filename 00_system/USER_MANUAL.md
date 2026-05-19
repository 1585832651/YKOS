# YkOS 用户使用手册

## 1. YkOS 是什么

YkOS 是你的个人 AI 知识库与工作流中枢。它不是聊天记录仓库，而是一个把 ChatGPT、Codex、Gemini、NotebookLM、Google Drive、Obsidian、GitHub 的输出沉淀为长期 Markdown 记忆的系统。

当前定位：

- 本地 YkOS：最终工作区。
- GitHub：版本控制与远程备份。
- Google Drive：Google 工具交换层。
- Obsidian：浏览和编辑 Markdown。
- AI Agent：帮你执行、整理、审计和生成 Memory Delta。

## 2. 你每天怎么用

### 早上

1. 打开 YkOS 仓库：

   ```powershell
   cd E:\project\YkOS
   ```

2. 看三个文件：

   ```text
   MEMORY.md
   ROADMAP.md
   TASKS.md
   ```

3. 如果用 ChatGPT 做早间简报，复制：

   ```text
   07_prompts/chatgpt/morning_briefing.md
   ```

4. 让 AI 给出今日唯一主线。

### 工作中

把不同工具输出放到对应地方：

- NotebookLM 输出：`G:\我的云端硬盘\YkOS_Drive\02_notebooklm_exports`
- Gemini 输出：`G:\我的云端硬盘\YkOS_Drive\03_gemini_outputs`
- Google AI Studio 输出：`G:\我的云端硬盘\YkOS_Drive\04_google_ai_studio`
- 论文 PDF 或笔记：`G:\我的云端硬盘\YkOS_Drive\01_sources\papers`

然后运行同步：

```powershell
cd E:\project\YkOS
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ykos_sync.ps1
```

同步后先看：

```text
01_inbox/
04_memory_transactions/pending/
06_reviews/daily/
```

不要直接把 Drive 或 AI 输出写进 `02_knowledge/`。

### 晚上

1. 看当天 review：

   ```text
   06_reviews/daily/
   ```

2. 审核 pending：

   ```text
   04_memory_transactions/pending/
   ```

3. 只把确认过、有来源、有长期价值的内容推进 `02_knowledge/`。

4. 提交 GitHub：

   ```powershell
   git -c safe.directory=E:/project/YkOS status
   git -c safe.directory=E:/project/YkOS add .
   git -c safe.directory=E:/project/YkOS commit -m "update YkOS notes"
   git -c safe.directory=E:/project/YkOS push
   ```

提交前先确认不要误提交 `.obsidian/` 或无意义空文件。

## 3. Google Drive 怎么用

Google Drive 不是正式知识库，只是交换层。

当前路径：

```text
G:\我的云端硬盘\YkOS_Drive
```

Drive 目录用途：

- `00_export_to_ykos/`：从本地 YkOS 导出给 Google 工具看的内容。
- `01_sources/`：论文、报告、文档、幻灯片等来源材料。
- `02_notebooklm_exports/`：NotebookLM 导出结果。
- `03_gemini_outputs/`：Gemini 输出。
- `04_google_ai_studio/`：Google AI Studio 输出。
- `05_chatgpt_exports/`：ChatGPT 导出。
- `99_archive/`：以后归档用。

同步脚本会把 Drive 输入复制到本地 inbox：

- NotebookLM -> `01_inbox/notebooklm`
- Gemini -> `01_inbox/gemini`
- Google AI Studio -> `01_inbox/gemini`
- Papers -> `01_inbox/papers`

## 4. Memory Transaction 怎么审

所有重要更新先进入：

```text
04_memory_transactions/pending/
```

你审核时看 5 件事：

1. 事实有没有来源？
2. 推理和事实有没有分开？
3. 是否真的值得长期保存？
4. 应该进入 `02_knowledge/`，还是只留在项目页？
5. 有没有风险或相反解释？

审核结果：

- 认可：移动到 `approved/`，再按需更新 `02_knowledge/`。
- 不认可：移动到 `rejected/`。
- 需要修改：留在 `pending/`，让 AI 重写。

## 5. 一天自动化模拟测试怎么跑

dry-run 测试：

```powershell
cd E:\project\YkOS
D:\anaconda\envs\rl311\python.exe scripts\ykos_day_simulation.py --repo-root . --dry-run --seed 20260519
```

真实同步测试：

```powershell
cd E:\project\YkOS
D:\anaconda\envs\rl311\python.exe scripts\ykos_day_simulation.py --repo-root . --seed 20260519
```

输出会进入：

- `04_memory_transactions/pending/`
- `06_reviews/daily/`
- `05_outputs/logs/`
- `00_system/DAY_SIMULATION_FLOW.md`

最近一次测试结果：

- 同步状态：`ok`
- inbox 文件数：`0`
- 说明：流程已跑通，但还需要放入真实 NotebookLM / Gemini / Papers 输入来测试知识抽取质量。

## 6. GitHub 和本地 Codex 怎么分工

本地 Codex App：

- 适合处理本地路径、Google Drive、Obsidian、本机脚本、真实文件同步。

GitHub cloud Codex：

- 适合处理 GitHub issue、PR、仓库内代码和文档改动。

建议流程：

1. GitHub issue 提需求。
2. cloud Codex 可以生成 PR 或 commit。
3. 本地 Codex 拉取代码，在本机跑真实测试。
4. 测试通过后再 merge / push。

不要让两个 Codex 同时改同一批文件而不审 diff。

## 7. 当前项目状态

已经完成：

- v0.1 Markdown 骨架。
- 中文化文档。
- v0.3 Google Drive 同步层。
- 一天自动化模拟测试脚本。
- Mermaid 流程图。
- pending / review / log 测试产物。

仍需补齐：

- 真实 NotebookLM 输入。
- 真实 Gemini 审核输入。
- 第一批 AI + 电网知识笔记。
- pending -> approved -> `02_knowledge/` 的人工审核样例。
- GitHub issue / PR 的稳定协作流程。

## 8. 常用命令

查看状态：

```powershell
git -c safe.directory=E:/project/YkOS status --short --branch
```

同步 Google Drive：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ykos_sync.ps1
```

跑一天模拟：

```powershell
D:\anaconda\envs\rl311\python.exe scripts\ykos_day_simulation.py --repo-root . --seed 20260519
```

查看最新文件：

```powershell
tree /F /A
```

提交：

```powershell
git -c safe.directory=E:/project/YkOS add .
git -c safe.directory=E:/project/YkOS commit -m "update YkOS"
git -c safe.directory=E:/project/YkOS push
```

## 9. 使用底线

- 不要把 AI 说的话直接当事实。
- 不要把 Drive 当正式知识库。
- 不要跳过 pending。
- 不要让脚本自动写 `02_knowledge/`。
- 不要把投资研究写成荐股。
- 不要把无来源内容推进长期记忆。

# 2026-05-19 YkOS 构建对话整理

## 来源

- 本地 Codex App 对话。
- GitHub 仓库：`1585832651/YKOS`。
- GitHub issue #1：`[YKOS-v0.3] Design Google Drive + GitHub sync workflow`。
- 本地项目目录：`E:\project\YkOS`。
- Google Drive 本地路径：`G:\我的云端硬盘\YkOS_Drive`。

## 原始背景

用户希望搭建 YkOS，作为个人 AI 知识库与工作流中枢。核心原则是：不把 AI 聊天记录当长期记忆，长期记忆必须沉淀为 Markdown，工具输出必须生成 Memory Delta，重要更新先进入 `04_memory_transactions/pending/`。

## 今日主要过程

1. 搭建 YkOS v0.1 Markdown 骨架。
2. 创建根目录核心文件与 `00_system/` 同步副本。
3. 创建 4 个项目页：
   - `power_doc_agent`
   - `ai_grid_research`
   - `public_account`
   - `investment_research`
4. 创建 Prompt 模板、Memory Transaction 模板和 bootstrap review。
5. 初始化本地 Git，创建第一次 commit，并推送到 GitHub。
6. 将项目文案统一中文化。
7. 设计 Google Drive ↔ 本地 YkOS ↔ GitHub 同步层。
8. 创建 `scripts/ykos_sync.ps1` 和真实配置 `scripts/ykos_config.json`。
9. 测试 Google Drive 同步层，生成 Drive sync Memory Transaction 和 daily review。
10. 读取 GitHub issue #1，发现 GitHub Cloud Codex 可以通过 issue 评论在云端生成代码。
11. 明确本地 Codex App 与 GitHub Cloud Codex 是两个不同执行环境：
    - 本地 Codex 适合本机路径、Google Drive、Obsidian、本机脚本运行。
    - GitHub Cloud Codex 适合 issue 驱动开发、PR、仓库内代码修改。
12. 创建并测试一天自动化模拟脚本 `scripts/ykos_day_simulation.py`。
13. 创建 Mermaid 流程图 `00_system/DAY_SIMULATION_FLOW.md`。
14. 创建 AI Agent 使用手册和用户使用手册。
15. 创建 Super Sync 脚本 `scripts/ykos_super_sync.ps1`。
16. 将脚本、文档、测试产物提交并推送到 GitHub。

## 关键发现

- 本地 Codex App 和 GitHub Cloud Codex 的能力边界不同，应该分工协作。
- Google Drive 适合作为 NotebookLM / Gemini / Google AI Studio 的交换层，但不适合作为最终知识库。
- GitHub 适合作为版本控制和远程最终状态，但本地路径、Drive、本机脚本必须由本地环境验证。
- Memory Transaction 是防止 AI 输出直接污染正式知识库的关键门禁。
- `01_inbox/` 是未审核入口，`02_knowledge/` 是正式知识库，两者不能混用。

## 踩坑记录

- Codex 沙箱中访问 GitHub 和 `G:\` 经常需要提权，本机 PowerShell 可以正常执行。
- GitHub push 在 Codex 沙箱中可能失败，需要用户本地执行或授权网络。
- Windows PowerShell 读取中文 `.ps1` 时可能出现编码问题，需要使用 UTF-8 BOM 或避免破坏 here-string。
- `powershell` 默认加载用户 profile，可能触发 conda 权限问题；脚本中应使用 `-NoProfile`。
- GitHub Cloud Codex 的评论不一定立刻进入本地 main，需要本地 fetch / 检查 / 测试。

## 值得长期沉淀的经验

- YkOS 的最终记忆源是本地仓库 + GitHub。
- Google Drive 是 Google 工具交换层，不是正式知识库。
- 本地 Codex 与 GitHub Cloud Codex 应形成“双执行器”结构。
- 所有 AI / 工具输出先进入 inbox 或 pending，再人工审核。
- 自动化脚本可以验证流程，但不能替代人工判断。

## 不应直接沉淀为知识的内容

- 一次性命令输出。
- 无来源的兴奋表达或情绪。
- 未验证的自动化假设。
- 空文件、空 inbox、空 knowledge 草稿。
- 没有人工审核的 AI 总结。

## 下一步

- 人工审核本文件对应的 Memory Transaction。
- 确认哪些经验可以进入 `02_knowledge/vibe_coding/`、`02_knowledge/agents/`、`02_knowledge/self/`。
- 用真实 NotebookLM / Gemini / Papers 输入测试知识抽取质量。

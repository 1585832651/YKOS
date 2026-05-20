# YkOS Google Drive 使用说明

## 你正在读取什么

这里是 YkOS 的 Google Drive 交换层，不是最终知识库。

YkOS 是用户的个人 AI 知识库与工作流中枢，用于连接 ChatGPT、Codex、Gemini、NotebookLM、Google Drive、Obsidian 和 GitHub。

最终记忆源是：

- 本地 YkOS 仓库：`E:\project\YkOS`
- GitHub 仓库：`1585832651/YKOS`

Google Drive 的作用是：

- 给 NotebookLM / Gemini / Google AI Studio 提供可读取材料。
- 接收这些工具的输出。
- 作为本地 YkOS 与 Google 工具之间的交换层。

不要把 Google Drive 当作完整知识库，也不要假设这里包含全部历史。

## 当前目录含义

```text
YkOS_Drive/
├── 00_export_to_ykos/
│   ├── reports/   # 本地 YkOS 导出的记忆快照、报告、检阅材料
│   └── prompts/   # 给 Gemini / NotebookLM / Google AI Studio 使用的提示词和操作说明
├── 01_sources/
│   ├── papers/    # 论文和外部文献来源
│   ├── reports/   # 外部报告
│   ├── docs/      # 外部文档
│   └── slides/    # 外部幻灯片
├── 02_notebooklm_exports/  # NotebookLM 输出回写区
├── 03_gemini_outputs/      # Gemini 输出回写区
├── 04_google_ai_studio/    # Google AI Studio 输出回写区
├── 05_chatgpt_exports/     # ChatGPT 导出交换区
└── 99_archive/             # 归档区
```

## 推荐读取顺序

如果你是 Gemini、NotebookLM 或 Google AI Studio，请按这个顺序读取：

1. 先读本文件：`00_README_FOR_GOOGLE_TOOLS.md`
2. 再读最新记忆快照：`00_export_to_ykos/reports/*ykos_memory_snapshot_for_drive.md`
3. 再读任务相关材料，例如论文、报告、Gemini 输出或 NotebookLM 输出。
4. 最后输出结构化结果，并包含 Memory Delta。

## 当前最新记忆入口

优先读取：

```text
00_export_to_ykos/reports/2026-05-19_ykos_memory_snapshot_for_drive.md
```

如果未来出现更新日期的同名快照，请优先读取最新日期版本。

## 输出必须怎么写

你的输出必须使用 Markdown，并包含以下结构：

```text
# 标题

## Summary

## Sources

## New Facts

## Inference / Analysis

## Decisions

## Open Questions

## Next Actions

## Memory Delta
```

要求：

- 事实必须标明来源。
- 推理和事实必须分开。
- 没有来源的内容只能写成观点、假设或建议。
- 不要声称已经修改正式知识库。
- 不要把临时对话当作长期记忆。
- 不要绕过 pending 审核。

## 回写到哪里

如果你是 NotebookLM，请把输出保存到：

```text
02_notebooklm_exports/
```

如果你是 Gemini，请把输出保存到：

```text
03_gemini_outputs/
```

如果你是 Google AI Studio，请把输出保存到：

```text
04_google_ai_studio/
```

文件名建议：

```text
YYYY-MM-DD_HHmm_tool_topic.md
```

示例：

```text
2026-05-20_0930_gemini_ykos_review.md
2026-05-20_1015_notebooklm_paper_summary.md
```

## 什么不能做

- 不要直接写入 `02_knowledge/`。
- 不要把 Google Drive 当最终记忆源。
- 不要把未经审核的内容说成已批准知识。
- 不要删除、覆盖或重命名已有文件。
- 不要要求自动同步整个仓库到 Google Drive。
- 不要生成荐股、交易建议或无来源投资结论。

## 什么可以做

- 可以总结最新记忆快照。
- 可以审查 YkOS 当前工作流。
- 可以整理论文、报告和工具输出。
- 可以生成待审核 Memory Delta。
- 可以提出下一步最小行动。
- 可以指出来源不足、逻辑跳跃和风险。

## 给 Gemini / NotebookLM 的标准任务指令

你可以直接使用下面这段：

```text
请先读取本 Google Drive 中的 `00_README_FOR_GOOGLE_TOOLS.md`，再读取 `00_export_to_ykos/reports/` 中最新的 `ykos_memory_snapshot_for_drive` 文件。

基于这些材料，请完成：

1. 总结 YkOS 当前定位和系统规则。
2. 判断哪些内容是已批准长期记忆，哪些只是 pending 或临时输出。
3. 提出今天最小行动计划。
4. 输出一份可回写到 YkOS 的 Memory Delta。

要求：
- 所有事实必须标明来源。
- 推理和建议必须单独列出。
- 不要直接要求写入正式知识库。
- 最终输出使用 Markdown。
```

## Memory Delta

### New Facts

- 来源：本文件
  - 事实：Google Drive 被定义为 YkOS 的工具交换层，不是最终知识库。
- 来源：`scripts/ykos_config.json`
  - 事实：本地 YkOS 与 Google Drive 的同步通过固定目录映射完成。

### Inference / Analysis

- Gemini 和 NotebookLM 每次新会话都会缺少上下文，因此 Drive 根目录需要一个稳定入口说明。
- 入口说明应明确读取顺序、目录语义和回写规则。

### Decisions

- 使用 `00_README_FOR_GOOGLE_TOOLS.md` 作为 Google 工具入口文件。
- Google 工具输出必须回写到对应 exports 目录，再由本地 YkOS 同步进入 inbox。

### Next Actions

- 将本文件同步到 Google Drive。
- 后续每次更新同步规则时，同步更新本文件。

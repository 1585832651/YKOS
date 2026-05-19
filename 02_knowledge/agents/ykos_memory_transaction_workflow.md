# YkOS Memory Transaction 工作流

## 来源

- `AGENTS.md`
- `WORKFLOW.md`
- `04_memory_transactions/pending/TEMPLATE.md`
- `01_inbox/chatgpt/2026-05-19_ykos_build_conversation.md`
- `04_memory_transactions/pending/2026-05-19_ykos_build_experience.md`

## 核心结论

YkOS 不把 AI 聊天记录直接当长期记忆。所有重要工具输出必须先进入 pending Memory Transaction，经过人工审核后，才能进入正式知识库。

## 标准路径

```text
工具输出 / 对话 / Drive 输入
-> 01_inbox/
-> 04_memory_transactions/pending/
-> 人工审核
-> 02_knowledge/
```

## 为什么需要 pending

- AI 输出可能没有来源。
- 工具输出可能互相矛盾。
- 一次性执行日志不一定有长期价值。
- 用户偏好、项目决策和领域事实需要分开处理。
- 正式知识库应保持干净、稳定、可追溯。

## Memory Transaction 必须包含

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

## 审核标准

人工审核时检查：

1. 事实是否有来源。
2. 推理是否与事实分开。
3. 内容是否有长期复用价值。
4. 是否应进入正式知识库，而不是只留在项目页或 review。
5. 是否存在风险、反例或过时可能。

## 状态含义

- `pending`：已提出，等待审核。
- `approved`：已批准，可以推进知识库。
- `rejected`：不进入知识库，但保留记录用于追踪。

## 禁止事项

- 不把聊天原文直接塞进 `02_knowledge/`。
- 不把无来源观点写成事实。
- 不让脚本自动修改正式知识库。
- 不用自动审批替代人工判断。

## 当前实践

2026-05-19 的 YkOS 构建经历先被整理到：

- `01_inbox/chatgpt/2026-05-19_ykos_build_conversation.md`
- `06_reviews/daily/2026-05-19_ykos_build_review.md`
- `04_memory_transactions/pending/2026-05-19_ykos_build_experience.md`

人工确认后，再拆分进入正式知识库。

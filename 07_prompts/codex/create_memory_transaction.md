# Codex 创建 Memory Transaction 提示词

请根据本次本地仓库修改，生成一个 Memory Transaction 文件草案。

输入：

- `git status`
- 本次修改的文件列表
- 关键 diff 摘要
- 任务目标
- 人工提供的来源或上下文

要求：

1. 不要把所有改动都写成长期记忆。
2. 只提取对未来有复用价值的事实、决策和系统规则。
3. 区分事实、推理、决策和风险。
4. 如果来源只是本次对话或本地文件，请明确写出。
5. 输出内容应可保存到 `04_memory_transactions/pending/YYYY-MM-DD_short-title.md`。
6. 结束时必须输出 Memory Delta。

输出格式：

## Memory Transaction

- ID：
- 触发原因：
- 来源：
- 提取事实：
- 推理：
- 决策：
- 影响文件：
- 拟议修改：
- 风险：
- 是否需要人工审核：
- 状态：pending

## 建议文件名

## Memory Delta

- 新事实：
- 新决策：
- 假设变化：
- 影响文件：
- 待审核项：

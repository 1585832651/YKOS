# YkOS 使用偏好

## 来源

- `01_inbox/chatgpt/2026-05-19_ykos_build_conversation.md`
- `06_reviews/daily/2026-05-19_ykos_build_review.md`
- `04_memory_transactions/pending/2026-05-19_ykos_build_experience.md`

## 语言偏好

- YkOS 项目的说明性文字默认使用中文。
- 工具名、路径、命令、协议关键词可以保留英文。
- README、手册、review、Memory Transaction 应优先使用中文。

## 自动化偏好

- 用户希望尽可能自动化，但不能牺牲可控性。
- 自动化脚本应先提供 Plan / dry-run，再提供 Apply。
- 脚本可以生成 pending、review、日志和测试产物。
- 脚本不能绕过人工审核直接写入正式知识库。

## 测试偏好

- 用户希望功能通过真实运行验证，而不是只停留在设计层。
- 本地路径、Google Drive、PowerShell、GitHub push 等必须在真实环境中测试。
- 如果测试失败，应记录失败原因并修复，而不是假装通过。

## 知识库偏好

- `01_inbox/` 保存未审核输入。
- `04_memory_transactions/pending/` 保存待审核记忆变更。
- `06_reviews/` 保存阶段性复盘。
- `02_knowledge/` 只保存经过确认的长期知识。

## 工具协作偏好

- 本地 Codex App 用于本机环境验证和本地自动化。
- GitHub Cloud Codex 用于 issue 驱动的云端代码和文档修改。
- 两者通过 GitHub 仓库同步，不应互相覆盖未经审核的改动。

## 当前工作习惯

- 先让 AI 执行和整理。
- 再看 pending Memory Transaction。
- 确认后再推进正式知识库。
- 最后 commit + push 形成远程版本。

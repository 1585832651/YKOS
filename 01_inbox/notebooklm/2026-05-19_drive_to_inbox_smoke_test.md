# 2026-05-19 Drive 到 Inbox 同步验收

## 目的

验证 Google Drive 的 NotebookLM 输出区可以同步进入本地 YkOS inbox。

## 来源

- Drive 文件：`G:\我的云端硬盘\YkOS_Drive\02_notebooklm_exports\2026-05-19_drive_to_inbox_smoke_test.md`
- 目标目录：`E:\project\YkOS\01_inbox\notebooklm`

## Memory Delta

- 新事实：该文件用于验证 Drive 输入到本地 inbox 的同步链路。
- 决策：测试输入先进入 `01_inbox/notebooklm/`，不进入正式知识库。

# 2026-05-20 Drive README Review

## 1. 本次完成了什么

- 为 Google Drive 交换层创建面向 Gemini / NotebookLM / Google AI Studio 的入口说明。
- 明确 Google Drive 不是最终知识库，只是工具交换层。
- 明确目录含义、读取顺序、输出格式和回写路径。
- 生成 pending Memory Transaction。

## 2. 创建的文件

- `05_outputs/prompts/00_README_FOR_GOOGLE_TOOLS.md`
- `04_memory_transactions/pending/2026-05-20_1138_drive_readme.md`

## 3. 预期 Drive 位置

通过 `scripts/ykos_sync.ps1` 同步后，应出现在：

```text
G:\我的云端硬盘\YkOS_Drive\00_export_to_ykos\prompts\00_README_FOR_GOOGLE_TOOLS.md
```

同时建议复制到 Drive 根目录：

```text
G:\我的云端硬盘\YkOS_Drive\00_README_FOR_GOOGLE_TOOLS.md
```

## 4. 需要人工审批的地方

- 是否将 Drive README 作为长期稳定规则写入正式知识库。
- 是否后续将 README 做成固定覆盖文件，而不是日期版本。

## 5. 下一步建议

- 同步到 Google Drive。
- 用 Gemini 或 NotebookLM 读取该 README 和最新记忆快照。
- 要求工具输出 Summary、Next Actions 和 Memory Delta。

## Memory Delta

- 新事实：
  - Google Drive 需要面向 Google 工具的入口说明文件。
- 新决策：
  - 入口说明使用 `00_README_FOR_GOOGLE_TOOLS.md`。
- 待审核：
  - 是否将该入口规则纳入 `00_system/DRIVE_SYNC.md`。

# Google Drive 同步规范

## 1. Google Drive 的定位

- Google Drive 是 Google 工具交换层，用于承接 NotebookLM、Gemini、Google AI Studio 等工具的输入输出。
- Google Drive 不是 YkOS 的最终知识库。
- YkOS 的最终记忆源是本地仓库 `E:\project\YkOS` 与 GitHub 仓库 `1585832651/YKOS`。
- Google Drive 中的内容必须先进入本地 inbox，经 Memory Transaction 与人工审核后，才可能进入正式知识库。

## 2. 目录映射

Drive 输入到本地 inbox：

| Google Drive 目录 | 本地 YkOS 目录 |
| --- | --- |
| `02_notebooklm_exports` | `01_inbox/notebooklm` |
| `03_gemini_outputs` | `01_inbox/gemini` |
| `04_google_ai_studio` | `01_inbox/gemini` |
| `01_sources/papers` | `01_inbox/papers` |

本地输出到 Drive：

| 本地 YkOS 目录 | Google Drive 目录 |
| --- | --- |
| `05_outputs/reports` | `00_export_to_ykos/reports` |
| `05_outputs/prompts` | `00_export_to_ykos/prompts` |

## 3. 同步规则

- Drive 输入必须先进 `01_inbox/`。
- 所有重要输入必须生成 Memory Transaction。
- 人工审批后，内容才允许进入 `02_knowledge/`。
- 同步脚本只做文件复制、统计、pending Memory Transaction 和 daily review 记录。
- 同步脚本不得修改 `02_knowledge/`。
- 同步脚本不得执行 git commit 或 git push。

## 4. 禁止事项

- 不同步 `.git`。
- 不把 Google Docs 当作正式记忆。
- 不绕过 `04_memory_transactions/pending/` 审查。
- 不自动修改正式知识库。
- 不删除 Drive 或本地文件。
- 不接 API。
- 不做 MCP Server。
- 不把整个 YkOS repo 复制到 Google Drive。

## 5. 每日流程

1. NotebookLM / Gemini / Google AI Studio 将输出放入 Google Drive 的对应目录。
2. 在本地运行 `scripts/ykos_sync.ps1`。
3. 检查脚本生成的 pending Memory Transaction。
4. 人工审核并决定 approve / revise / reject。
5. 只有审核通过的内容才能进入正式知识库。
6. 人工确认后再执行 git commit 和 git push。

## 6. 当前路径状态

当前 Google Drive 本地同步路径已由用户确认：

```text
G:\我的云端硬盘\YkOS_Drive
```

本地配置文件 `scripts/ykos_config.json` 应使用该路径作为 `drive_path`。如果后续更换 Google Drive 同步盘符或目录，只修改配置文件，不修改同步规则。

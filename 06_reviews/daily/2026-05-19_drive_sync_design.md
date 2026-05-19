# 2026-05-19 Drive Sync 设计记录

## 1. 本次完成了什么

- 落地了 YkOS v0.3 的 Google Drive ↔ 本地 YkOS ↔ GitHub 半自动同步层。
- 创建或更新了 Google Drive 同步规范：`00_system/DRIVE_SYNC.md`。
- 创建了配置模板：`scripts/ykos_config.example.json`。
- 创建了真实配置：`scripts/ykos_config.json`。
- 创建或更新了同步脚本：`scripts/ykos_sync.ps1`。
- 更新了 `TOOL_REGISTRY.md`、`WORKFLOW.md`、`INDEX.md` 及 `00_system/` 中对应系统文件副本。
- 未执行同步脚本，未修改 `02_knowledge/`，未 commit，未 push。

## 2. 是否检测到 Google Drive 路径

路径已由用户确认。

## 3. 实际路径是什么

```text
G:\我的云端硬盘\YkOS_Drive
```

该路径已写入 `scripts/ykos_config.json` 的 `drive_path` 字段。

## 4. 如果没检测到，用户需要怎么配置

当前不需要走“未检测到路径”的分支。

如果未来更换 Google Drive 本地同步路径，只需要修改：

```text
scripts/ykos_config.json
```

把 `drive_path` 改成新的完整路径即可。

## 5. 创建或修改了哪些文件

- `00_system/DRIVE_SYNC.md`
- `scripts/ykos_config.example.json`
- `scripts/ykos_config.json`
- `scripts/ykos_sync.ps1`
- `06_reviews/daily/2026-05-19_drive_sync_design.md`
- `TOOL_REGISTRY.md`
- `WORKFLOW.md`
- `INDEX.md`
- `00_system/TOOL_REGISTRY.md`
- `00_system/WORKFLOW.md`
- `00_system/INDEX.md`

## 6. 当前风险

- 同步脚本尚未在真实 Drive 内容上执行过，首次运行后需要人工复核复制结果。
- Drive 中的文件进入 inbox 后仍然是未验证内容，不能直接进入正式知识库。
- `scripts/ykos_config.json` 包含本机绝对路径，适合当前机器；换机器后需要重新配置。
- 当前仍有本地未跟踪项 `.obsidian/` 和 `02_knowledge/`，本次任务未处理它们。

## 7. 下一步动作

1. 手动运行 `scripts/ykos_sync.ps1`。
2. 检查 `01_inbox/notebooklm/`、`01_inbox/gemini/`、`01_inbox/papers/`。
3. 检查脚本生成的 pending Memory Transaction。
4. 人工审核后再决定是否更新 `02_knowledge/`。
5. 人工确认后再 commit + push GitHub。

## 8. Memory Delta

- 新事实：
  - YkOS v0.3 已确认 Google Drive 本地同步路径为 `G:\我的云端硬盘\YkOS_Drive`。
  - Google Drive 被定位为 NotebookLM、Gemini、Google AI Studio 等 Google 工具的交换层。
  - 最终记忆源仍然是本地 YkOS 仓库与 GitHub。
- 新决策：
  - `scripts/ykos_config.json` 使用真实 `drive_path`。
  - 同步脚本只负责文件交换、统计、pending Memory Transaction 和 daily review，不修改正式知识库。
  - 同步脚本不执行 git commit 或 git push。
- 假设变化：
  - v0.3 不再停留在“未配置 Drive 路径”状态，进入“路径已配置、等待首次运行验证”状态。
- 影响文件：
  - `00_system/DRIVE_SYNC.md`
  - `scripts/ykos_config.example.json`
  - `scripts/ykos_config.json`
  - `scripts/ykos_sync.ps1`
  - `06_reviews/daily/2026-05-19_drive_sync_design.md`
  - `TOOL_REGISTRY.md`
  - `WORKFLOW.md`
  - `INDEX.md`
- 待审核项：
  - 用户需要在首次运行脚本后审核复制结果和生成的 pending Memory Transaction。

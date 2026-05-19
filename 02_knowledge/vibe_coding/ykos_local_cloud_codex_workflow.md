# YkOS 本地 Codex 与 GitHub Cloud Codex 协作模式

## 来源

- `01_inbox/chatgpt/2026-05-19_ykos_build_conversation.md`
- `06_reviews/daily/2026-05-19_ykos_build_review.md`
- `04_memory_transactions/pending/2026-05-19_ykos_build_experience.md`
- GitHub issue #1：`[YKOS-v0.3] Design Google Drive + GitHub sync workflow`

## 核心结论

YkOS 适合采用“双执行器”模式：

- 本地 Codex App 负责本地环境、Google Drive、Obsidian、PowerShell、本机脚本和真实运行验证。
- GitHub Cloud Codex 负责 GitHub issue、PR、仓库内代码和文档修改。
- GitHub 仓库作为两者之间的代码与文档同步点。

## 本地 Codex App 适合做什么

- 读取和修改 `E:\project\YkOS` 本地文件。
- 访问本机 Google Drive 同步目录：`G:\我的云端硬盘\YkOS_Drive`。
- 运行 PowerShell 脚本，例如 `scripts/ykos_sync.ps1` 和 `scripts/ykos_super_sync.ps1`。
- 验证 Obsidian、本机 Python、Git、Drive 文件路径是否真实可用。
- 在推送前做本地测试和风险检查。

## GitHub Cloud Codex 适合做什么

- 根据 GitHub issue 生成仓库内代码或文档修改。
- 创建 commit、PR 或 issue 回复。
- 处理不依赖本机路径的仓库任务。
- 生成可由本地 Codex 拉取并测试的初稿。

## 推荐流程

1. 在 GitHub issue 中描述需求。
2. GitHub Cloud Codex 可以生成 PR 或 commit。
3. 本地 Codex 执行 `git fetch`，检查 cloud 产物。
4. 本地 Codex 在真实本机环境中运行脚本和测试。
5. 通过后再 merge、commit 或 push。

## 风险

- 两个 Codex 可能同时修改同一文件，必须先 fetch 和审 diff。
- Cloud Codex 无法验证本机 `G:\`、Obsidian 和 PowerShell 环境。
- 本地 Codex 可以验证真实环境，但网络 push 可能受沙箱限制，需要本机 PowerShell 执行。

## 当前状态

- 已验证本地 Drive 同步脚本可运行。
- 已验证一天自动化模拟脚本可运行。
- 已创建 Super Sync 脚本作为本地协同同步入口。

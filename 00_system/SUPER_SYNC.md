# YkOS Super Sync 规范

## 1. 目标

`scripts/ykos_super_sync.ps1` 用于把三层状态协同起来：

- 本地 YkOS 仓库
- Google Drive 交换层
- GitHub 远程仓库

它不是替代人工审核的自动知识沉淀工具，而是一个同步编排器。

## 2. 执行模式

默认只预演：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ykos_super_sync.ps1
```

实际执行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ykos_super_sync.ps1 -Mode Apply
```

自定义提交信息：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ykos_super_sync.ps1 -Mode Apply -CommitMessage "sync: update YkOS"
```

只同步 Drive，不 push：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ykos_super_sync.ps1 -Mode Apply -SkipGitPush
```

## 3. 同步策略

1. 读取 `scripts/ykos_config.json`。
2. 检查本地 YkOS 和 Google Drive 路径。
3. 扫描 Drive / YkOS 映射目录中的同名不同内容文件。
4. `git fetch --all --prune` 获取 GitHub 最新状态。
5. 调用 `scripts/ykos_sync.ps1` 完成 Drive 与 inbox / outputs 交换。
6. 生成 pending Memory Transaction 和 daily review。
7. Apply 模式下暂存允许提交的文件。
8. 如有本地变更，创建 commit。
9. 如果远端有新提交，执行 `git pull --rebase`。
10. 无冲突后执行 `git push`。

## 4. 冲突处理

如果发现 Drive 与 YkOS 映射目录存在同名不同内容文件：

- Plan 模式只报告。
- Apply 模式停止执行。
- 用户需要人工判断哪一份是正确版本。

如果 GitHub 和本地都发生了提交：

- 脚本先 commit 本地变更。
- 再执行 rebase。
- 如果 rebase 冲突，脚本停止，等待人工处理。

## 5. 安全边界

脚本不会：

- 删除文件。
- 同步 `.git`。
- 绕过 pending 审核。
- 自动判断正式知识是否可写入。
- 自动解决 Git rebase 冲突。

脚本默认排除：

- `.obsidian/`
- `__pycache__/`
- `.pyc`
- `.env`
- `secrets/`
- `credentials/`

## 6. 私有仓库说明

如果 GitHub 仓库是私有仓库，脚本仍然可以使用，但前提是本机 Git 已经具备访问权限，例如：

- 已登录 GitHub Desktop / Git Credential Manager。
- 已配置可用 HTTPS 凭据。
- 已配置 SSH key 并使用 SSH remote。

脚本不会保存或管理 GitHub token。

## 7. 推荐使用顺序

每天工作结束时：

1. 运行 Plan。
2. 检查冲突报告。
3. 如果没有冲突，运行 Apply。
4. 查看生成的 `04_memory_transactions/pending/*_super_sync.md`。
5. 查看 `06_reviews/daily/*_super_sync_review.md`。

## 8. 与人工审核的关系

Super sync 只保证文件流动和 Git 状态协调，不保证知识正确。

正式知识仍然必须经过：

```text
01_inbox -> pending Memory Transaction -> 人工审核 -> 02_knowledge
```

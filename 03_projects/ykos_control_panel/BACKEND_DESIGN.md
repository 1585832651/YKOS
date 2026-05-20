# YkOS Control Panel Backend Design

## Summary

后端是 YkOS Control Panel 的本地执行层。它负责连接前端按钮和本地 YkOS 能力：

- 文件扫描。
- Markdown 读取。
- Prompt 生成。
- 同步脚本执行。
- job 日志。
- pending / review 记录。

v0.4 后端不做 AI 推理，也不接任何外部 API。

## Runtime

推荐：

```text
Python 3 + 标准库
```

入口文件：

```text
E:\project\YkOS-ControlPanel\backend\ykos_control_panel_server.py
```

启动命令：

```powershell
cd E:\project\YkOS
python E:\project\YkOS-ControlPanel\backend\ykos_control_panel_server.py --host 127.0.0.1 --port 8765 --config E:\project\YkOS\scripts\ykos_config.json
```

如果使用本机 Anaconda Python：

```powershell
cd E:\project\YkOS
D:\anaconda\envs\rl311\python.exe E:\project\YkOS-ControlPanel\backend\ykos_control_panel_server.py --host 127.0.0.1 --port 8765 --config E:\project\YkOS\scripts\ykos_config.json
```

## Services

### Config

读取：

```text
scripts/ykos_config.json
```

返回：

- `ykos_root`
- `drive_path`
- `inbox_mapping`
- `export_mapping`
- `pending_path`
- `review_path`

### Status

聚合状态：

- Drive 是否存在。
- Git branch。
- Git dirty 状态。
- ahead / behind。
- inbox 文件数量。
- pending 数量。
- latest snapshot。
- latest review。

### Files

列出和读取：

- `01_inbox/`
- `04_memory_transactions/`
- `05_outputs/`
- `06_reviews/`
- `07_prompts/`

### Prompts

生成 prompt：

- 今日主线。
- 晚间复盘。
- Gemini 审核。
- NotebookLM 总结。
- Codex 仓库审计。
- Memory Delta。

### Jobs

运行：

- Drive Sync。
- Super Sync Plan。
- Super Sync Apply。

## API Contract

完整 API 见：

```text
03_projects/ykos_control_panel/API_CONTRACT.md
```

## Job Execution Rules

### Drive Sync

调用：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ykos_sync.ps1 -ConfigPath .\scripts\ykos_config.json
```

特性：

- 会写 pending。
- 会写 daily review。
- 不 commit。
- 不 push。

### Super Sync Plan

调用：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ykos_super_sync.ps1 -Mode Plan
```

特性：

- 预演完整同步。
- 不写文件。
- 不 commit。
- 不 push。

### Super Sync Apply

调用：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ykos_super_sync.ps1 -Mode Apply
```

特性：

- 会同步。
- 会生成 pending / review。
- 会 commit。
- 会 push。

保护：

- 必须先有成功的 Super Sync Plan。
- 前端必须显示确认。
- 后端必须检查 plan 时间和风险状态。

## Directory Rules

允许读取：

- `00_system/`
- `01_inbox/`
- `03_projects/`
- `04_memory_transactions/`
- `05_outputs/`
- `06_reviews/`
- `07_prompts/`
- 根目录 Markdown 文件。

禁止读取或写入：

- `.git/`
- `.obsidian/`
- `.env`
- `secrets/`
- `credentials/`

禁止写入：

- `02_knowledge/`

例外：

- 后续如果用户明确审批知识库写入，应通过单独人工流程实现，不作为 v0.4 GUI 后端默认能力。

## Data Persistence

不使用数据库。

使用文件保存状态：

```text
05_outputs/logs/control_panel/
```

每个 job 两份记录：

```text
YYYY-MM-DD_HHmm_<job_type>.json
YYYY-MM-DD_HHmm_<job_type>.md
```

## Error Handling

后端返回统一错误：

```json
{
  "ok": false,
  "error": {
    "code": "DRIVE_PATH_MISSING",
    "message": "Google Drive 路径不存在",
    "detail": "G:\\我的云端硬盘\\YkOS_Drive"
  }
}
```

常见错误码：

- `CONFIG_MISSING`
- `DRIVE_PATH_MISSING`
- `YKOS_ROOT_MISSING`
- `GIT_FETCH_FAILED`
- `SYNC_CONFLICT`
- `JOB_ALREADY_RUNNING`
- `PLAN_REQUIRED`
- `PLAN_EXPIRED`
- `PATH_NOT_ALLOWED`
- `FILE_NOT_FOUND`

## Frontend Integration Notes

前端不要直接假设本地文件存在，应先调用：

```text
GET /api/status
```

按钮启用逻辑：

- Drive missing：禁用 Drive Sync。
- Git behind：Super Sync Apply 前显示 rebase 风险。
- pending > 0：显示待审核提示。
- plan 未成功：禁用 Apply。
- job running：禁用所有 sync 按钮。

## Next Implementation Step

先实现只读接口：

```text
GET /api/health
GET /api/status
GET /api/snapshots/latest
GET /api/files/inbox
GET /api/files/memory-transactions?state=pending
```

再接脚本执行：

```text
POST /api/jobs/drive-sync
POST /api/jobs/super-sync-plan
GET /api/jobs/<job_id>
```

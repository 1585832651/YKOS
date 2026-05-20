# YkOS Control Panel API Contract

## Base URL

```text
http://127.0.0.1:8765
```

## Response Envelope

成功：

```json
{
  "ok": true,
  "data": {}
}
```

失败：

```json
{
  "ok": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "错误说明",
    "detail": "可选详情"
  }
}
```

## GET /api/health

检查后端是否在线。

Response:

```json
{
  "ok": true,
  "data": {
    "service": "ykos-control-panel",
    "version": "0.4",
    "time": "2026-05-20T12:00:00+08:00"
  }
}
```

## GET /api/status

读取 YkOS 当前状态。

Response:

```json
{
  "ok": true,
  "data": {
    "repo": {
      "path": "E:\\project\\YkOS",
      "exists": true
    },
    "drive": {
      "path": "G:\\我的云端硬盘\\YkOS_Drive",
      "exists": true
    },
    "git": {
      "branch": "main",
      "dirty": true,
      "ahead": 0,
      "behind": 0,
      "has_upstream": true
    },
    "counts": {
      "inbox": 1,
      "pending": 8,
      "approved": 1,
      "rejected": 0,
      "daily_reviews": 12
    },
    "latest": {
      "snapshot": "05_outputs/reports/2026-05-19_ykos_memory_snapshot_for_drive.md",
      "daily_review": "06_reviews/daily/2026-05-20_drive_sync_review.md"
    },
    "jobs": {
      "running": false,
      "last_job": null,
      "last_successful_plan": null
    }
  }
}
```

## GET /api/snapshots/latest

获取最新记忆快照。

Response:

```json
{
  "ok": true,
  "data": {
    "path": "05_outputs/reports/2026-05-19_ykos_memory_snapshot_for_drive.md",
    "name": "2026-05-19_ykos_memory_snapshot_for_drive.md",
    "size": 5634,
    "modified_at": "2026-05-19T23:16:03+08:00",
    "content": "# 2026-05-19 YkOS 最新记忆快照..."
  }
}
```

## GET /api/files/inbox

列出 inbox 文件。

Query:

```text
source=notebooklm|gemini|chatgpt|papers|web|ideas|all
```

Response:

```json
{
  "ok": true,
  "data": {
    "source": "all",
    "files": [
      {
        "path": "01_inbox/notebooklm/2026-05-19_drive_to_inbox_smoke_test.md",
        "name": "2026-05-19_drive_to_inbox_smoke_test.md",
        "source": "notebooklm",
        "size": 509,
        "modified_at": "2026-05-19T23:00:20+08:00",
        "has_memory_delta": false
      }
    ]
  }
}
```

## GET /api/files/memory-transactions

列出 Memory Transaction。

Query:

```text
state=pending|approved|rejected
```

Response:

```json
{
  "ok": true,
  "data": {
    "state": "pending",
    "files": [
      {
        "path": "04_memory_transactions/pending/2026-05-20_1158_ykos_gui_control_panel.md",
        "name": "2026-05-20_1158_ykos_gui_control_panel.md",
        "size": 1690,
        "modified_at": "2026-05-20T11:58:00+08:00",
        "risk_flags": []
      }
    ]
  }
}
```

## GET /api/files/reviews/daily

列出 daily review。

Response:

```json
{
  "ok": true,
  "data": {
    "files": [
      {
        "path": "06_reviews/daily/2026-05-20_ykos_gui_design.md",
        "name": "2026-05-20_ykos_gui_design.md",
        "size": 1200,
        "modified_at": "2026-05-20T11:58:00+08:00"
      }
    ]
  }
}
```

## GET /api/files/read

读取允许范围内的 Markdown / JSON / TXT 文件。

Query:

```text
path=relative/path.md
```

Response:

```json
{
  "ok": true,
  "data": {
    "path": "04_memory_transactions/pending/example.md",
    "name": "example.md",
    "size": 1000,
    "modified_at": "2026-05-20T12:00:00+08:00",
    "sha256": "hash",
    "content": "# Markdown..."
  }
}
```

## GET /api/prompts

生成 prompt。

Query:

```text
type=morning_briefing|evening_review|gemini_review|notebooklm_summary|codex_repo_audit|memory_delta|inbox_file_review|latest_snapshot_review
path=optional/relative/file.md
```

Response:

```json
{
  "ok": true,
  "data": {
    "type": "latest_snapshot_review",
    "title": "检阅最新 YkOS 记忆快照",
    "prompt": "请读取以下文件..."
  }
}
```

## POST /api/jobs/drive-sync

运行 Drive Sync。

Request:

```json
{}
```

Response:

```json
{
  "ok": true,
  "data": {
    "job_id": "2026-05-20_1200_drive_sync",
    "status": "running"
  }
}
```

## POST /api/jobs/super-sync-plan

运行 Super Sync Plan。

Request:

```json
{}
```

Response:

```json
{
  "ok": true,
  "data": {
    "job_id": "2026-05-20_1200_super_sync_plan",
    "status": "running"
  }
}
```

## POST /api/jobs/super-sync-apply

运行 Super Sync Apply。

Request:

```json
{
  "plan_job_id": "2026-05-20_1200_super_sync_plan",
  "confirm": "APPLY_SUPER_SYNC"
}
```

Rules:

- `plan_job_id` 必须存在。
- plan 必须成功。
- plan 必须在 10 分钟内。
- `confirm` 必须等于 `APPLY_SUPER_SYNC`。

Response:

```json
{
  "ok": true,
  "data": {
    "job_id": "2026-05-20_1208_super_sync_apply",
    "status": "running"
  }
}
```

## GET /api/jobs/{job_id}

查询 job。

Response:

```json
{
  "ok": true,
  "data": {
    "job_id": "2026-05-20_1200_super_sync_plan",
    "type": "super_sync_plan",
    "status": "succeeded",
    "started_at": "2026-05-20T12:00:00+08:00",
    "ended_at": "2026-05-20T12:00:06+08:00",
    "exit_code": 0,
    "stdout": "==> 读取配置...",
    "stderr": "",
    "risk_flags": [],
    "artifacts": []
  }
}
```

## Forbidden Capabilities

后端不得提供这些接口：

```text
POST /api/shell
POST /api/git/reset
POST /api/files/write-knowledge
POST /api/memory/approve
DELETE /api/files/*
```

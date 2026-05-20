# 给 Gemini 的补充材料：YkOS Control Panel 后端 API 合同

请在设计 YkOS Control Panel 前端时，遵守以下后端边界。

## Repository Boundary

前端和后端应用代码位于：

```text
E:\project\YkOS-ControlPanel
```

YkOS 主仓库只作为知识库和同步目标：

```text
E:\project\YkOS
```

## Backend Base URL

```text
http://127.0.0.1:8765
```

## 前端应该优先调用

```text
GET /api/health
GET /api/status
GET /api/snapshots/latest
GET /api/files/inbox
GET /api/files/memory-transactions?state=pending
GET /api/files/reviews/daily
GET /api/prompts?type=latest_snapshot_review
```

## 同步按钮对应接口

```text
Drive Sync -> POST /api/jobs/drive-sync
Super Sync Plan -> POST /api/jobs/super-sync-plan
Super Sync Apply -> POST /api/jobs/super-sync-apply
```

## Apply 交互规则

Super Sync Apply 必须更谨慎：

1. 用户先运行 Super Sync Plan。
2. Plan 成功后，前端才启用 Apply。
3. Apply 请求必须包含：

```json
{
  "plan_job_id": "最近成功的 plan job id",
  "confirm": "APPLY_SUPER_SYNC"
}
```

## 前端状态规则

- Drive missing：禁用 Drive Sync。
- job running：禁用所有 sync 按钮。
- plan 未成功：禁用 Apply。
- pending > 0：显示待审核提示。
- git behind > 0：显示 rebase 风险。
- dirty = true：显示本地有未提交变更。

## 后端不会提供

```text
任意 shell
自动 approve
直接写 02_knowledge
git reset
删除文件
外部 API
```

## 前端设计要求

- 把每个按钮和真实后端动作对应起来。
- 每个危险动作必须有解释。
- 日志输出区域要能展示 stdout / stderr。
- Prompt Launcher 只生成 prompt，不调用外部 AI。
- Memory Transactions 页面不要把自动 approve 设计成主按钮。

## 参考文件

```text
00_system/CONTROL_PANEL_BACKEND.md
03_projects/ykos_control_panel/API_CONTRACT.md
03_projects/ykos_control_panel/BACKEND_DESIGN.md
```

## Memory Delta

- 新事实：YkOS Control Panel 后端将以本地 HTTP API 暴露状态、文件、prompt 和 job 操作。
- 决策：前端必须先支持 Plan，再允许 Apply。
- 风险：如果前端忽略后端安全边界，会把 GUI 做成不可落地的危险操作台。

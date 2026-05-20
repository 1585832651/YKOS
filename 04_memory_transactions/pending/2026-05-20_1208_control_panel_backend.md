# 2026-05-20_1208 Control Panel Backend Memory Transaction

## ID

2026-05-20_1208_control_panel_backend

## Trigger

用户要求在 Gemini 设计前端期间，先设计 YkOS Control Panel 后端。

## Sources

- 用户 2026-05-20 对话请求。
- `00_system/GUI_CONTROL_PANEL.md`
- `03_projects/ykos_control_panel/README.md`
- `scripts/ykos_sync.ps1`
- `scripts/ykos_super_sync.ps1`

## Extracted Facts

- YkOS 已有 Drive Sync 和 Super Sync 脚本。
- Control Panel 后端需要支撑状态查看、文件检阅、Prompt 生成和脚本执行。
- 用户希望 GUI 简单、可操作、能降低调用和检阅成本。

## Inference

- 后端 v0.4 应设计成本地 HTTP 控制服务，而不是云端服务。
- 关键风险在于路径访问、命令执行和 Apply 操作保护。
- 先做 API 合同，可以让 Gemini 的前端设计更贴近真实可实现能力。

## Decisions

- 后端优先使用 Python 标准库。
- 服务只监听 `127.0.0.1:8765`。
- 后端只提供白名单任务，不提供任意 shell。
- `super_sync_apply` 必须依赖最近成功的 `super_sync_plan`。
- 后端不直接写 `02_knowledge/`。

## Affected Files

- `00_system/CONTROL_PANEL_BACKEND.md`
- `03_projects/ykos_control_panel/BACKEND_DESIGN.md`
- `03_projects/ykos_control_panel/API_CONTRACT.md`
- `05_outputs/prompts/2026-05-20_ykos_backend_contract_for_gemini.md`
- `04_memory_transactions/pending/2026-05-20_1208_control_panel_backend.md`

## Proposed Patch

新增后端架构设计、API 合同、前端对接说明和 pending Memory Transaction。

## Risks

- 如果后端暴露任意命令执行，GUI 会变成高风险入口。
- 如果 Apply 缺少 Plan 保护，用户可能误触发 commit / push。
- 如果路径校验不足，可能读取或暴露敏感文件。

## Human Review Required

Yes

## Status

pending

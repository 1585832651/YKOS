# 2026-05-20_1418 Control Panel Repo Split Memory Transaction

## ID

2026-05-20_1418_control_panel_repo_split

## Trigger

用户指出控制面板应用程序和 YkOS 知识库放在同一个仓库中并不合适，因为这会增加在整理知识库时误改控制面板代码的风险，并要求按“应用程序独立、知识库保留设计文档”的方向完成重构。

## Sources

- 用户 2026-05-20 对话请求
- `00_system/GUI_CONTROL_PANEL.md`
- `00_system/CONTROL_PANEL_BACKEND.md`
- `03_projects/ykos_control_panel/README.md`
- `E:\project\YkOS-ControlPanel`

## Extracted Facts

- YkOS 主仓库定位是 Markdown 长期记忆源。
- Control Panel 定位是操作工具，不是知识库内容本身。
- Gemini 生成的控制面板前端是 Vite + React + TypeScript 工程。
- 控制面板应用已迁移到独立目录 `E:\project\YkOS-ControlPanel`。
- YkOS 主仓库已移除 `03_projects/ykos_control_panel/frontend/` 和 `scripts/ykos_control_panel_server.py`。

## Inference

- 控制面板应用如果留在知识库仓库，会增加依赖、构建产物和应用代码污染 Markdown 记忆源的风险。
- 独立项目可以让控制面板按软件工程节奏演进，而 YkOS 主仓库继续保持知识库结构稳定。

## Decisions

- `E:\project\YkOS` 只保留控制面板设计规范、API 合同、提示词和审计记录。
- `E:\project\YkOS-ControlPanel` 承载 React/Vite 前端和本地后端服务。
- 控制面板通过配置读取 `E:\project\YkOS\scripts\ykos_config.json`。
- 后续控制面板代码变更应在独立项目中完成，再把必要规则回写到 YkOS 的文档和 pending。

## Affected Files

- `00_system/GUI_CONTROL_PANEL.md`
- `00_system/CONTROL_PANEL_BACKEND.md`
- `03_projects/ykos_control_panel/README.md`
- `03_projects/ykos_control_panel/BACKEND_DESIGN.md`
- `05_outputs/prompts/2026-05-20_ykos_backend_contract_for_gemini.md`
- `06_reviews/daily/2026-05-20_control_panel_backend.md`
- `E:\project\YkOS-ControlPanel`

## Proposed Patch

- 保留 YkOS 主仓库中的控制面板设计文档和 API 合同。
- 将应用代码迁移到独立目录。
- 从 YkOS 主仓库删除控制面板前端和后端应用代码。

## Risks

- `E:\project\YkOS-ControlPanel` 目前是独立本地目录，尚未初始化 Git。
- 前端依赖尚未安装和构建验证。
- 后端可运行性需要在本机 Python 环境中继续测试。

## Human Review Required

Yes

## Status

pending

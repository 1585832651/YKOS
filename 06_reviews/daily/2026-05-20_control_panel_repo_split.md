# 2026-05-20 Control Panel Repo Split Review

## 1. 本次完成了什么

- 将控制面板应用从 YkOS 主知识库中拆出。
- 创建独立项目目录：`E:\project\YkOS-ControlPanel`。
- 迁移 Gemini 生成的 React / Vite 前端到独立项目。
- 迁移本地后端服务到独立项目的 `backend/`。
- 从 YkOS 主仓库删除控制面板前端目录和后端应用脚本。
- 更新 YkOS 中的控制面板设计文档，明确仓库边界。

## 2. 当前项目边界

YkOS 主知识库：

```text
E:\project\YkOS
```

保留：

- Markdown 知识库。
- Memory Transaction。
- Prompt 和 workflow。
- 同步脚本。
- Control Panel 设计规范、API 合同和项目说明。

控制面板应用：

```text
E:\project\YkOS-ControlPanel
```

保留：

- React / Vite 前端。
- 本地后端服务。
- 前端依赖配置。
- 独立运行说明。

## 3. 当前风险

- 独立控制面板项目尚未独立初始化 Git。
- 前端 `npm install` 和 `npm run build` 尚未执行。
- 后端还需要在真实本机环境中测试 `GET /api/status`。

## 4. 下一步建议

1. 在 `E:\project\YkOS-ControlPanel` 初始化独立 Git。
2. 安装前端依赖并运行前端。
3. 启动后端并测试 `http://127.0.0.1:8765/api/status`。
4. 前端接入后端状态和同步 job。
5. YkOS 主仓库只提交设计文档和重构记录。

## Memory Delta

- 新事实：
  - 控制面板应用已从 YkOS 主知识库拆出到 `E:\project\YkOS-ControlPanel`。
- 推理：
  - 应用代码和长期记忆源分离，可以降低误改和仓库污染风险。
- 决策：
  - YkOS 主仓库不承载控制面板前端工程。
  - 控制面板通过配置访问 YkOS，而不是嵌入 YkOS。
- 待审核：
  - 是否为 `E:\project\YkOS-ControlPanel` 初始化独立 Git 仓库。

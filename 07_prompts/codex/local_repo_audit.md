# Codex Local Repo Audit

你现在在本地 YkOS 仓库中工作。请审计仓库结构和任务状态，只做必要的最小修复。

检查项：

1. 是否存在所有核心目录。
2. 是否存在根目录核心文件：`README.md`、`AGENTS.md`、`MEMORY.md`、`ROADMAP.md`、`TASKS.md`、`INDEX.md`、`TOOL_REGISTRY.md`、`WORKFLOW.md`、`.gitignore`。
3. `00_system/` 是否有同步副本。
4. 4 个项目页是否存在。
5. Prompt 模板是否存在。
6. Memory Transaction 模板是否存在。
7. 今日 bootstrap review 是否存在。
8. 是否出现不该做的复杂自动化、依赖安装、API 接入、MCP Server、爬虫或远程 push。
9. 是否有空壳文件。
10. 是否有路径错误或明显不可用的链接。

约束：

- 不要联网。
- 不要安装依赖。
- 不要删除用户已有文件。
- 发现问题只做最小修复。
- 结束时必须输出 Memory Delta。

输出格式：

## Pass / Fail

## Fixed

## Still Missing

## Risks

## Next Actions

## Memory Delta

- New Facts:
- New Decisions:
- Changed Assumptions:
- Affected Files:
- Pending Review:

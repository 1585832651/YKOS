#!/usr/bin/env python3
"""YkOS one-day automation simulation.

This script is intentionally dependency-free. It exercises the v0.3 workflow:
Drive sync, inbox scan, pending Memory Transaction generation, simulated
morning/afternoon work, structured logs, Mermaid flow output, and daily review.
"""

from __future__ import annotations

import argparse
import json
import random
import subprocess
import sys
from dataclasses import dataclass, asdict
from datetime import datetime
from pathlib import Path
from typing import Iterable


INBOX_TARGETS = {
    "NotebookLM": Path("01_inbox/notebooklm"),
    "Gemini": Path("01_inbox/gemini"),
    "Papers": Path("01_inbox/papers"),
}

PROJECTS = [
    "power_doc_agent",
    "ai_grid_research",
    "public_account",
    "investment_research",
]


@dataclass
class InboxItem:
    source: str
    path: str
    size: int
    modified: str
    summary: str


@dataclass
class SimulationResult:
    timestamp: str
    seed: int
    dry_run: bool
    sync_status: str
    sync_stdout: str
    sync_stderr: str
    inbox_items: list[InboxItem]
    morning_plan: list[str]
    paper_reading: list[str]
    idea_notes: list[str]
    project_actions: dict[str, list[str]]
    approval_status: str
    generated_files: list[str]


def read_text(path: Path, max_chars: int = 800) -> str:
    try:
        return path.read_text(encoding="utf-8", errors="replace")[:max_chars].strip()
    except OSError as exc:
        return f"读取失败：{exc}"


def ensure_dir(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def repo_path(repo_root: Path, relative: str | Path) -> Path:
    return repo_root / Path(relative)


def scan_inbox(repo_root: Path) -> list[InboxItem]:
    items: list[InboxItem] = []
    for source, relative_dir in INBOX_TARGETS.items():
        folder = repo_path(repo_root, relative_dir)
        ensure_dir(folder)
        for path in sorted(folder.rglob("*")):
            if not path.is_file():
                continue
            if ".git" in path.parts:
                continue
            stat = path.stat()
            text = read_text(path)
            first_line = next((line.strip() for line in text.splitlines() if line.strip()), "")
            summary = first_line[:160] if first_line else "空文件或无可读文本"
            items.append(
                InboxItem(
                    source=source,
                    path=str(path.relative_to(repo_root)),
                    size=stat.st_size,
                    modified=datetime.fromtimestamp(stat.st_mtime).isoformat(timespec="seconds"),
                    summary=summary,
                )
            )
    return items


def run_sync(repo_root: Path, config: Path, dry_run: bool) -> tuple[str, str, str]:
    if dry_run:
        return ("dry-run-skip", "dry-run：未执行 scripts/ykos_sync.ps1", "")

    sync_script = repo_path(repo_root, "scripts/ykos_sync.ps1")
    if not sync_script.exists():
        return ("missing-script", "", f"未找到同步脚本：{sync_script}")
    if not config.exists():
        return ("missing-config", "", f"未找到配置文件：{config}")

    command = [
        "powershell",
        "-NoProfile",
        "-ExecutionPolicy",
        "Bypass",
        "-File",
        str(sync_script),
        "-ConfigPath",
        str(config),
    ]
    completed = subprocess.run(
        command,
        cwd=str(repo_root),
        text=True,
        encoding="utf-8",
        errors="replace",
        capture_output=True,
    )
    status = "ok" if completed.returncode == 0 else f"failed:{completed.returncode}"
    return (status, completed.stdout.strip(), completed.stderr.strip())


def choose(rng: random.Random, values: Iterable[str], count: int) -> list[str]:
    values = list(values)
    if not values:
        return []
    return rng.sample(values, k=min(count, len(values)))


def build_simulation(
    repo_root: Path,
    config: Path,
    seed: int,
    dry_run: bool,
) -> SimulationResult:
    rng = random.Random(seed)
    timestamp = datetime.now().strftime("%Y-%m-%d_%H%M")
    sync_status, sync_stdout, sync_stderr = run_sync(repo_root, config, dry_run=dry_run)
    inbox_items = scan_inbox(repo_root)

    pending_files = sorted(repo_path(repo_root, "04_memory_transactions/pending").glob("*.md"))
    morning_plan = [
        f"检查 pending Memory Transaction 数量：{len(pending_files)}",
        "确认今日主线：验证 Google Drive -> inbox -> pending -> review 闭环",
        "优先处理 NotebookLM、Gemini、Papers 三类输入",
    ]

    paper_focus = [
        "抽取论文问题定义、方法、数据来源和评估指标",
        "标记没有来源的推论，不推进正式知识库",
        "为 AI + 电网研究生成可审核的问题清单",
        "把可复用洞见转成 pending Memory Transaction",
    ]
    paper_reading = choose(rng, paper_focus, 3)

    idea_pool = [
        "把文档 Agent 的输入格式拆成来源、任务、约束、输出四段",
        "为公众号选题建立从研究笔记到文章草稿的转换模板",
        "投资研究只保留事实和问题，不输出交易建议",
        "为 AI Grid Research 建立论文 intake checklist",
        "把 Gemini 审核意见作为反方审查输入",
    ]
    idea_notes = choose(rng, idea_pool, 3)

    project_actions = {
        "power_doc_agent": [
            "检查文档输入清单",
            "设计文档到 Memory Delta 的抽取字段",
        ],
        "ai_grid_research": [
            "整理论文阅读问题",
            "标注 AI + 电网主题的待验证假设",
        ],
        "public_account": [
            "从今日研究中提取一个公众号选题",
            "区分事实证据和个人观点",
        ],
        "investment_research": [
            "记录行业观察问题",
            "避免把研究结论写成荐股建议",
        ],
    }

    approval_status = rng.choice(["pending-review", "approved-simulation-only"])

    return SimulationResult(
        timestamp=timestamp,
        seed=seed,
        dry_run=dry_run,
        sync_status=sync_status,
        sync_stdout=sync_stdout,
        sync_stderr=sync_stderr,
        inbox_items=inbox_items,
        morning_plan=morning_plan,
        paper_reading=paper_reading,
        idea_notes=idea_notes,
        project_actions=project_actions,
        approval_status=approval_status,
        generated_files=[],
    )


def render_memory_transaction(result: SimulationResult) -> str:
    inbox_lines = "\n".join(
        f"  - {item.source}: {item.path} ({item.size} bytes) - {item.summary}"
        for item in result.inbox_items
    ) or "  - 未发现现有 inbox 文件。"

    action_lines = "\n".join(
        f"  - {project}: " + "；".join(actions)
        for project, actions in result.project_actions.items()
    )

    return f"""# {result.timestamp} 一天自动化模拟 Memory Transaction

- ID：MT-{result.timestamp}-day-simulation
- 触发原因：基于 YkOS v0.3 要求，测试本地 ↔ Google Drive ↔ GitHub 工作流的一天模拟闭环。
- 来源：
  - scripts/ykos_day_simulation.py
  - scripts/ykos_sync.ps1
  - scripts/ykos_config.json
  - 01_inbox/notebooklm/
  - 01_inbox/gemini/
  - 01_inbox/papers/
- 提取事实：
  - 同步执行状态：{result.sync_status}
  - dry-run：{result.dry_run}
  - 扫描到 inbox 文件数：{len(result.inbox_items)}
{inbox_lines}
- 推理：
  - 本次模拟用于验证流程完整性，不代表内容已进入正式知识库。
  - inbox 中的内容仍需人工审查来源、事实类型和可复用价值。
- 决策：
  - 自动审批仅作为模拟状态：{result.approval_status}
  - 不修改 02_knowledge/。
  - 不自动执行 git commit 或 git push。
- 影响文件：
  - 04_memory_transactions/pending/{result.timestamp}_day_simulation.md
  - 06_reviews/daily/{result.timestamp[:10]}_day_simulation_review.md
  - 05_outputs/logs/{result.timestamp}_day_simulation_log.md
  - 05_outputs/logs/{result.timestamp}_day_simulation_log.json
  - 00_system/DAY_SIMULATION_FLOW.md
- 拟议修改：
  - 将本次模拟作为 v0.3 工作流测试记录保留在 pending 与 daily review 中。
  - 正式知识库更新必须等待人工审核。
- 风险：
  - 如果同步脚本真实运行失败，需要优先修复 Drive 路径或 PowerShell 执行环境。
  - 如果 inbox 输入为空，本次测试只能验证流程，不能验证知识抽取质量。
  - 模拟审批不能替代人工审批。
- 是否需要人工审核：是。
- 状态：{result.approval_status}

## 项目操作摘要

{action_lines}
"""


def render_markdown_log(result: SimulationResult) -> str:
    inbox_lines = "\n".join(
        f"- {item.source}: `{item.path}`，{item.size} bytes，摘要：{item.summary}"
        for item in result.inbox_items
    ) or "- 未发现 inbox 文件。"

    project_sections = "\n".join(
        "### " + project + "\n" + "\n".join(f"- {action}" for action in actions)
        for project, actions in result.project_actions.items()
    )

    return f"""# {result.timestamp} YkOS 一天自动化模拟日志

## 运行信息

- seed：{result.seed}
- dry-run：{result.dry_run}
- 同步状态：{result.sync_status}
- 自动审批模拟状态：{result.approval_status}

## 早晨日历提醒

{chr(10).join(f"- {item}" for item in result.morning_plan)}

## Inbox 扫描

{inbox_lines}

## 上午论文阅读与思路整理

{chr(10).join(f"- {item}" for item in result.paper_reading)}

## 想法记录

{chr(10).join(f"- {item}" for item in result.idea_notes)}

## 下午多项目操作

{project_sections}

## ChatGPT / Codex / Gemini 输出整合

- ChatGPT：形成今日主线、复盘问题和 Memory Delta 检查点。
- Codex：执行同步脚本、扫描 inbox、生成 pending 与 review。
- Gemini：作为反方审查输入，重点检查逻辑漏洞和待验证假设。

## 同步脚本输出

```text
{result.sync_stdout or "(无 stdout)"}
```

## 同步脚本错误

```text
{result.sync_stderr or "(无 stderr)"}
```
"""


def render_review(result: SimulationResult) -> str:
    return f"""# {result.timestamp[:10]} 一天自动化模拟 Review

## 1. 今天完成了什么

- 运行 YkOS 一天自动化模拟脚本。
- 使用现有 `scripts/ykos_sync.ps1` 执行或模拟同步步骤。
- 扫描 NotebookLM、Gemini、Papers inbox。
- 生成 pending Memory Transaction。
- 生成结构化 Markdown / JSON 日志。
- 生成 Mermaid 流程图文档。
- 模拟早晨提醒、上午论文阅读、想法记录和下午多项目操作。

## 2. 运行结果

- seed：{result.seed}
- dry-run：{result.dry_run}
- 同步状态：{result.sync_status}
- inbox 文件数：{len(result.inbox_items)}
- 自动审批模拟状态：{result.approval_status}

## 3. 需要人工审批的地方

- pending Memory Transaction 是否保留、修订或拒绝。
- 模拟审批逻辑是否可以作为后续测试标准。
- 是否需要加入真实 NotebookLM / Gemini / Papers 输入继续测试。

## 4. 下一步建议

- 用真实 Drive 输入重新运行非 dry-run 测试。
- 检查 pending 文件和日志。
- 通过人工审核后再考虑更新正式知识库。

## Memory Delta

- 新事实：
  - YkOS 已具备一天自动化流程模拟脚本。
  - 本次运行同步状态为 {result.sync_status}。
  - 本次扫描到 inbox 文件数为 {len(result.inbox_items)}。
- 新决策：
  - 自动审批只保留在模拟层，不替代人工审核。
- 假设变化：
  - 可以通过脚本回放验证日常流程，而不是直接自动沉淀正式知识。
- 影响文件：
  - 04_memory_transactions/pending/{result.timestamp}_day_simulation.md
  - 05_outputs/logs/{result.timestamp}_day_simulation_log.md
  - 05_outputs/logs/{result.timestamp}_day_simulation_log.json
  - 06_reviews/daily/{result.timestamp[:10]}_day_simulation_review.md
  - 00_system/DAY_SIMULATION_FLOW.md
- 待审核项：
  - 人工确认本次模拟是否满足 v0.3 流程测试目标。
"""


def render_flow_doc() -> str:
    return """# YkOS 一天自动化模拟流程图

## Google Drive ↔ 本地 YkOS ↔ GitHub

```mermaid
flowchart LR
  Drive["Google Drive 交换层"] --> Inbox["01_inbox"]
  Inbox --> Pending["04_memory_transactions/pending"]
  Pending --> Review["人工审核"]
  Review --> Knowledge["02_knowledge"]
  Local["本地 YkOS"] --> GitHub["GitHub 最终同步"]
  Drive --> Local
  Local --> Drive
```

## Memory Transaction 流程

```mermaid
flowchart TD
  Input["NotebookLM / Gemini / Papers 输入"] --> Inbox["01_inbox"]
  Inbox --> Delta["生成 Memory Delta"]
  Delta --> Pending["pending Memory Transaction"]
  Pending --> Human["人工审核"]
  Human -->|approve| Knowledge["02_knowledge"]
  Human -->|revise| Pending
  Human -->|reject| Rejected["04_memory_transactions/rejected"]
```

## 每日 Review 流程

```mermaid
flowchart TD
  Morning["早晨提醒"] --> Work["上午阅读与想法整理"]
  Work --> Projects["下午多项目操作"]
  Projects --> Logs["结构化日志 Markdown / JSON"]
  Logs --> Review["daily review 占位文件"]
  Review --> Pending["pending 审核事项"]
```

## 项目模块关系

```mermaid
flowchart LR
  Inbox["01_inbox"] --> AIGrid["AI Grid Research"]
  Inbox --> PowerDoc["Power Doc Agent"]
  Inbox --> Public["Public Account"]
  Inbox --> Invest["Investment Research"]
  AIGrid --> Knowledge["02_knowledge"]
  PowerDoc --> Knowledge
  Public --> Outputs["05_outputs/articles"]
  Invest --> Outputs2["05_outputs/reports"]
  Knowledge --> Projects["03_projects"]
```
"""


def write_outputs(repo_root: Path, result: SimulationResult) -> SimulationResult:
    pending_dir = repo_path(repo_root, "04_memory_transactions/pending")
    review_dir = repo_path(repo_root, "06_reviews/daily")
    logs_dir = repo_path(repo_root, "05_outputs/logs")
    flow_file = repo_path(repo_root, "00_system/DAY_SIMULATION_FLOW.md")

    for folder in (pending_dir, review_dir, logs_dir, flow_file.parent):
        ensure_dir(folder)

    pending_file = pending_dir / f"{result.timestamp}_day_simulation.md"
    review_file = review_dir / f"{result.timestamp[:10]}_day_simulation_review.md"
    log_md = logs_dir / f"{result.timestamp}_day_simulation_log.md"
    log_json = logs_dir / f"{result.timestamp}_day_simulation_log.json"

    pending_file.write_text(render_memory_transaction(result), encoding="utf-8")
    review_file.write_text(render_review(result), encoding="utf-8")
    log_md.write_text(render_markdown_log(result), encoding="utf-8")
    log_json.write_text(
        json.dumps(asdict(result), ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    flow_file.write_text(render_flow_doc(), encoding="utf-8")

    result.generated_files = [
        str(pending_file.relative_to(repo_root)),
        str(review_file.relative_to(repo_root)),
        str(log_md.relative_to(repo_root)),
        str(log_json.relative_to(repo_root)),
        str(flow_file.relative_to(repo_root)),
    ]
    log_json.write_text(
        json.dumps(asdict(result), ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description="Run YkOS one-day workflow simulation.")
    parser.add_argument("--repo-root", default=".", help="YkOS repo root.")
    parser.add_argument("--config", default="scripts/ykos_config.json", help="ykos_sync config path.")
    parser.add_argument("--seed", type=int, default=20260519, help="Deterministic random seed.")
    parser.add_argument("--dry-run", action="store_true", help="Skip actual ykos_sync.ps1 execution.")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve()
    config = (repo_root / args.config).resolve()

    if not repo_root.exists():
        print(f"repo-root 不存在：{repo_root}", file=sys.stderr)
        return 2

    result = build_simulation(
        repo_root=repo_root,
        config=config,
        seed=args.seed,
        dry_run=args.dry_run,
    )
    result = write_outputs(repo_root, result)

    print("YkOS 一天自动化模拟完成")
    print(f"seed: {result.seed}")
    print(f"dry-run: {result.dry_run}")
    print(f"sync_status: {result.sync_status}")
    print(f"inbox_items: {len(result.inbox_items)}")
    print("generated_files:")
    for path in result.generated_files:
        print(f"- {path}")

    return 0 if result.sync_status in {"ok", "dry-run-skip"} else 1


if __name__ == "__main__":
    raise SystemExit(main())

# YkOS Agent Protocol

## Owner Identity

- Owner: a graduate student in Artificial Intelligence at Huazhong University of Science and Technology.
- Research direction: AI + power grid.
- Builder direction: AI + energy research builder, with interest in research systems, DoResearch, Vibe Coding, public-account content, enterprise Agents, and investment research.

## System Goal

YkOS is a Markdown-first personal AI knowledge base and workflow hub. It coordinates outputs from ChatGPT, Codex, Gemini, NotebookLM, opencode, Google Drive, Obsidian, GitHub, Web Search, and X / Twitter Search.

## Core Principles

1. Do not treat AI chat history as long-term memory.
2. Long-term memory must be distilled into Markdown.
3. Every meaningful tool output must generate a Memory Delta.
4. Every fact needs a source. Unsourced content is only an opinion, hypothesis, or working assumption.
5. Important updates first enter `04_memory_transactions/pending/`.
6. Do not directly pollute formal knowledge files with unreviewed material.
7. Keep MVP v0.1 simple. Do not over-engineer.

## Memory Delta Rules

Each significant output should include:

- New Facts: sourced facts discovered or confirmed.
- New Decisions: decisions made in this work session.
- Changed Assumptions: assumptions that were added, removed, or modified.
- Affected Files: files that should be created, changed, or reviewed.
- Pending Review: items requiring human validation.

## Write Rules

- Put raw input in `01_inbox/`.
- Put approved domain knowledge in `02_knowledge/`.
- Put active project notes in `03_projects/`.
- Put proposed memory updates in `04_memory_transactions/pending/`.
- Put finished deliverables in `05_outputs/`.
- Put review records in `06_reviews/`.
- Put reusable prompts in `07_prompts/`.

## Opposition Review Rules

Before promoting content into formal memory, check:

- Is the source explicit and retrievable?
- Is this fact, inference, decision, or preference?
- Is there a competing explanation?
- Could this become outdated quickly?
- Does this belong in project context instead of global memory?
- Is the update useful for future work, or only noise?

## Prohibited Actions

- Do not install dependencies unless explicitly requested.
- Do not connect APIs unless explicitly requested.
- Do not build MCP Servers in MVP v0.1.
- Do not create crawlers or automated sync.
- Do not push to remote repositories.
- Do not delete existing user files.
- Do not write secrets, credentials, or private tokens into the repo.
- Do not promote unsourced claims into stable memory.

## Required Output Format

For substantial work, respond with:

1. Summary
2. Changed Files
3. Risks
4. Next Actions
5. Memory Delta

# YkOS

YkOS is a personal AI knowledge base and workflow hub. It is designed for long-term Markdown memory, research notes, project tracking, and tool-output review across ChatGPT, Codex, Gemini, NotebookLM, opencode, Google Drive, Obsidian, and GitHub.

## MVP v0.1 Goal

YkOS v0.1 only builds the repository skeleton and operating protocol:

- stable Markdown-first memory files
- inbox, knowledge, project, output, review, and prompt areas
- Memory Delta and Memory Transaction rules
- project pages for current AI + grid, Agent, content, and investment research tracks
- prompt templates for repeatable ChatGPT and Codex workflows

## Current Non-goals

- no API integration
- no MCP Server
- no crawler
- no external dependency
- no automation sync
- no GitHub remote setup or push
- no complex scripts

## Directory Map

- `00_system/`: archived system protocol files. These mirror the root entry files at MVP initialization.
- `01_inbox/`: raw incoming material from tools and sources before review.
- `02_knowledge/`: approved long-term knowledge organized by domain.
- `03_projects/`: active project spaces and project README files.
- `04_memory_transactions/`: pending, approved, and rejected memory updates.
- `05_outputs/`: finished articles, code, memos, reports, and prompts.
- `06_reviews/`: daily, weekly, and monthly review records.
- `07_prompts/`: reusable prompts for ChatGPT, Codex, Gemini, NotebookLM, and opencode.

## Tool Return Flow

1. ChatGPT, Gemini, NotebookLM, Codex, opencode, Web Search, and X / Twitter Search may produce useful output.
2. Raw or unverified output goes to `01_inbox/` or `05_outputs/`.
3. Every important tool output must include a Memory Delta.
4. Important updates first become a file in `04_memory_transactions/pending/`.
5. Only reviewed and sourced facts should be promoted into `02_knowledge/`, `MEMORY.md`, `ROADMAP.md`, or project files.

## Core Rule

AI chat logs are not long-term memory. Long-term memory must be distilled into Markdown with sources, review status, and clear ownership.

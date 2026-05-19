# YkOS Workflow

## Daily Morning Briefing

Inputs:

- `MEMORY.md`
- `ROADMAP.md`
- `TASKS.md`
- latest daily or weekly review

Output:

- one main line for the day
- P0 task list
- risks and blockers
- Memory Delta if any stable memory should change

Return path:

- `06_reviews/daily/YYYY-MM-DD_morning.md`
- pending memory changes go to `04_memory_transactions/pending/`

## Work Session

1. Select one task from `TASKS.md`.
2. Gather only the minimum necessary sources.
3. Produce or edit Markdown files.
4. Keep raw tool output in inbox or outputs.
5. End with Summary, Changed Files, Risks, Next Actions, and Memory Delta.

## Tool Output Protocol

Every meaningful tool output must state:

- source or input files
- facts extracted
- assumptions or inferences
- files affected
- Memory Delta

## Memory Transaction

Use `04_memory_transactions/pending/TEMPLATE.md` for important updates. A Memory Transaction should separate facts, inferences, decisions, proposed patches, and risks.

Promotion rule:

- pending: proposed and awaiting review
- approved: accepted and applied
- rejected: not accepted, retained for traceability

## Evening Review

Inputs:

- completed work
- tool outputs
- changed files
- pending Memory Transactions

Output:

- daily review
- updated TASKS if needed
- proposed Memory Transactions

Return path:

- `06_reviews/daily/YYYY-MM-DD_evening.md`
- `04_memory_transactions/pending/`

## Weekly Review

Inputs:

- daily reviews
- completed project changes
- ROADMAP and TASKS

Output:

- weekly summary
- next week P0/P1
- stale assumptions
- approved memory updates

Return path:

- `06_reviews/weekly/YYYY-WW.md`

## Tool Return Paths

- ChatGPT: `01_inbox/chatgpt/`, `06_reviews/`, `04_memory_transactions/pending/`
- Codex: direct repo edits, `06_reviews/`, `04_memory_transactions/pending/`
- Gemini: `01_inbox/gemini/`, `05_outputs/`
- NotebookLM: `01_inbox/notebooklm/`, then reviewed notes in `02_knowledge/`
- opencode: `05_outputs/code/`, project folders
- Web Search: `01_inbox/web/`
- X / Twitter Search: `01_inbox/twitter_x/`

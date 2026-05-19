# Tool Registry

| Tool | Role | Input | Output | Return Path | Status |
| --- | --- | --- | --- | --- | --- |
| ChatGPT | Strategy, synthesis, daily planning, review | MEMORY, ROADMAP, TASKS, selected inbox notes | briefings, reviews, Memory Delta | `01_inbox/chatgpt/`, `04_memory_transactions/pending/`, `06_reviews/` | planned |
| Codex | Local repo editing, audits, coding workflow | local files, task specs | file changes, audit reports, Memory Delta | repo files, `06_reviews/`, `04_memory_transactions/pending/` | active |
| NotebookLM | Source-grounded reading and synthesis | papers, docs, source packs | source-grounded notes | `01_inbox/notebooklm/`, `02_knowledge/` after review | planned |
| Gemini / Google AI Studio | Long-context analysis and multimodal exploration | notes, papers, images, prompts | drafts, comparisons, hypotheses | `01_inbox/gemini/`, `05_outputs/` | planned |
| opencode | Local coding agent workflow | repo tasks, files | code edits, implementation notes | `05_outputs/code/`, project folders | planned |
| Google Drive | File storage and source exchange | docs, PDFs, exported notes | source files and shared docs | `01_inbox/raw/`, external Drive folders | planned |
| Obsidian | Local knowledge browsing and linking | Markdown vault | linked notes, navigation | whole repo as vault | planned |
| GitHub | Version control and publication | local Git repo | remote commits, issues, releases | future remote repository | planned |
| Web Search | Current fact discovery | search queries | sourced raw findings | `01_inbox/web/`, Memory Transactions | manual |
| X / Twitter Search | Social signal and expert tracking | topic queries, accounts | leads, claims, references | `01_inbox/twitter_x/` | manual |

## Registry Rule

Tool output is not formal knowledge by default. It must return through a file path, include sources where applicable, and generate a Memory Delta before promotion.

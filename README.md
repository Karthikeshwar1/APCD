# APCD

Concise project docs and a Progress log, so any new AI coding session can **pick up where you left off**. Say "pick up where we left" or "check what's next in the todo list and continue", and the agent verifies the log against the repo and continues.

It keeps the parts of persistent-agent products (Cursor Projects, OpenAI dots, Grok Bot) that are just files: one short always-loaded entry file, on-demand topic docs, a task log, a resume routine. It doesn't replace their cloud computer, schedules or chat integrations.

## Install

```bash
claude plugin marketplace add <owner>/apcd
claude plugin install apcd@apcd
```

Then, in a project: `/apcd:run`. It shows a plan and applies on yes.

| Command | What it does |
|---|---|
| `/apcd:run` | Set up, or update. Adopts existing docs (`STATUS.md`, `AGENTS.md`, `docs/`) instead of duplicating them. |
| `/apcd:run customize` | Change tools or tree. |
| `/apcd:run trim` | Tighten wording, keep every fact, show the diff. |
| `/apcd:run check` | Report size budgets, stale Checkpoint, dead links, missing shims. No edits. |
| `/apcd:resume` | Resume (also triggers on the phrases above). |

The first run asks one question: defaults, customize, or plan only. Defaults need no further input.

## What it writes (all in your repo, all markdown)

- One canonical entry file: `CLAUDE.md`, or `AGENTS.md` if you use other tools. It holds the rules, a docs index and the Progress log.
- `README.md` for humans, and `docs/<topic>.md` topic docs, read only when needed.
- A tiny `apcd:protocol` block in the entry file carries the resume and upkeep rules, so **resume works without the plugin installed**: teammates, cloud sessions and other tools follow the repo.
- One-line **shims** pointing other tools at `AGENTS.md` (`CLAUDE.md`, `GEMINI.md`, Copilot, Aider). Most tools read `AGENTS.md` and need nothing.
- Options are an HTML comment in the entry file (Claude Code strips it: zero tokens). Nothing personal is written, and nothing lives outside the repo, so `git clone` reproduces the setup.

## Principles

- **Concise**: every doc as short as it can be and still clear.
- **Loaded only when needed**: the index says `path: read when <trigger>`; topic docs stay out of context until then.
- **Low maintenance**: the agent updates the docs in the same pass as the work.
- **Lossless**: overflow moves verbatim to an archive, never deleted.

## Limits

- The rules are advisory text. A model can skip them; hooks are the only enforcement.
- Token savings are not measured. Research on context files is mixed: they help for non-obvious conventions and state, less for repo overviews. Keep the docs to what the code can't tell you.
- Verified against the Claude Code docs for plugins and skills; the shims for other tools follow their published file conventions and are less tested.

## License

MIT

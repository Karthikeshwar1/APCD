# APCD

Concise project docs and a Progress list, so any new AI coding session can **pick up where you left off**. Say "pick up where we left off" or "what's next", and the agent reads Progress and continues.

## Install

```bash
claude plugin marketplace add Karthikeshwar1/APCD
claude plugin install apcd@apcd
```

Then, in a project: `/apcd:run` (use the prefix; `/run` is a built-in). It shows a plan and applies on yes. Re-run any time to refresh.

## What it writes (all in your repo, all markdown)

- One entry file: `CLAUDE.md`, or `AGENTS.md` if you also use other tools. It holds decisions, rules, a docs index and **Progress** (Next, Done, Notes).
- `docs/<topic>.md` for anything longer than a few lines, read only when needed.
- One-line shims for tools that don't read `AGENTS.md` (`CLAUDE.md`, `GEMINI.md`, Aider).

The resume line lives in Progress itself, so **resume works without the plugin**: teammates and other tools just follow the repo.

## Limits

- The rules are advisory text; a model can skip them.
- Token savings are not measured. Keep the docs to what the code can't tell you.
- Shims for other tools follow their published file conventions and are less tested.

## License

MIT

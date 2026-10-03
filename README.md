# APCD (Auto-Project-Context-Doc)

Concise project docs plus a Progress list, so any new AI coding session can pick up where you left off.

## Install

```bash
claude plugin marketplace add Karthikeshwar1/APCD
claude plugin install apcd@apcd
```

## Use

Run `/apcd:run` in a project (keep the prefix; `/run` is built in). It shows a plan, applies on yes, and is safe to re-run.

It writes one entry file, `CLAUDE.md` (or `AGENTS.md` if you use other tools): Decisions, Rules, Docs, Progress. Longer topics go in `docs/<topic>.md`. Existing docs are copied verbatim, never deleted. Then say "pick up where we left off". Resume needs no plugin: it is plain markdown in the repo.

## Limits

Rules are advisory; a model can skip them (small models skip more, and may add a filler Next item on a repo with no TODOs). Gemini CLI reads `GEMINI.md`, which the skill points at `AGENTS.md`. Aider needs `read: AGENTS.md` in `.aider.conf.yml`; add it yourself.

MIT

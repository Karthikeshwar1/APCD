---
name: run
description: "Set up or refresh APCD project docs: one concise entry file (CLAUDE.md or AGENTS.md) with a Progress list any new session can resume from."
disable-model-invocation: true
---

Set up or refresh this project's docs so a new session can pick up where the last one stopped. Safe to re-run.

## Steps
1. Read README.md, CLAUDE.md, AGENTS.md, docs/ and the code layout. Ask only what you can't infer (goal, key decisions).
2. Entry file: `AGENTS.md` if the repo shows any non-Claude tool (`AGENTS.md`, `GEMINI.md`, `.cursor/`, `.github/copilot-instructions.md`, `.aider*`), else `CLAUDE.md`.
3. Show a short plan; apply on yes.
4. Adopt, don't duplicate: keep existing docs and paths, add only what's missing. If progress is already tracked elsewhere (e.g. `STATUS.md`), the Progress section is a one-line link to it. Ask before moving or deleting human-written text.
5. On re-run: fix dead links and stale facts, tighten wording (keep every fact), add missing shims.

## Rules
- Concise: every doc as short as it can be and still clear. Link, don't duplicate. Dates `YYYY-MM-DD`.
- A topic needing more than ~5 lines gets `docs/<topic>.md`, listed in the entry file as `path: read when <trigger>`. Don't `@`-import topic docs: imports load every session.
- Markdown only, all in the repo, nothing personal. Entry file under ~150 lines.

## Entry file
```markdown
# <Project>
<What it is and why, 1–2 lines. How to run: README.md.>

## Decisions
- <choice>: <why> (YYYY-MM-DD)

## Rules
- <Conventions the code doesn't show.>

## Docs (read when needed)
- `docs/<topic>.md`: read when <trigger>

## Progress
"Pick up where we left off" / "what's next": start the first Next item.
Keep this section and the docs current and concise as you work; drop old Done items (git has them).
- Next:
  1. <item>
- Done: <item> (YYYY-MM-DD)
- Notes: <surprises, dead ends> (YYYY-MM-DD)
```

## README.md (only if missing)
```markdown
# <Project>
<What it is, 1–2 lines.>

## Run
<Requirements and commands>

## Docs
- [<Topic>](docs/<topic>.md)
```

## Shims (only when the entry file is AGENTS.md)
- `CLAUDE.md`: `@AGENTS.md`
- `GEMINI.md`: `@AGENTS.md`, if Gemini CLI is used
- `.aider.conf.yml`: `read: AGENTS.md`, if Aider is used

Other tools read `AGENTS.md` directly. Codex truncates it past 32 KiB.

---
name: run
description: "Set up or refresh APCD (Auto-Project-Context-Doc) project docs: one concise entry file (CLAUDE.md or AGENTS.md) with a Progress list any new session can resume from."
disable-model-invocation: true
---

Set up or refresh this project's docs so a new session can pick up where the last one stopped. Safe to re-run.

## Steps
1. Read README.md, CLAUDE.md, AGENTS.md, docs/ and the code (including TODOs). Ask only what you can't infer.
2. Entry file: `AGENTS.md` if the repo shows a non-Claude tool (`GEMINI.md`, `.cursor/`, `.github/copilot-instructions.md`, `.aider*`), else `CLAUDE.md`. With AGENTS.md, also write `CLAUDE.md` as `@AGENTS.md`, and put `@AGENTS.md` first in any existing `GEMINI.md` (keep its content).
3. Before shortening or rewriting any existing doc, copy it unchanged to `docs/<topic>.md` (`cp`, never retype), and list it as `path: read when <trigger>`.
4. Show a short plan; apply on yes.
5. Adopt, don't duplicate: keep existing docs. If a progress file already exists (e.g. `docs/state/STATUS.md`), Progress is only `- Status: <its path>`.

## Rules
- Concise, under ~150 lines, link don't duplicate, dates `YYYY-MM-DD`, markdown only, nothing personal. Remove docs entries whose file doesn't exist; keep only the last 3 Done items (git has them).
- Never delete facts. Never `@`-import topic docs.
- Edit docs only, never code. Never git commit. Never invent.
- Keep the template headings verbatim.

## Entry file
```markdown
# <Project>
<What it is and why, 1–2 lines. How to run.>

## Decisions
- <choice>: <why> (YYYY-MM-DD)

## Rules
- <Conventions the code doesn't show.>

## Docs (read when needed)
- `docs/<topic>.md`: read when <trigger>

## Progress
- Next:
  1. <item>
- Done: <item> (YYYY-MM-DD)
```

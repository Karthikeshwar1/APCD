<div align="center">

# APCD

### Auto-Project-Context-Doc

**Concise project docs and a Progress list, so any new AI coding session picks up where you left off.**

`Claude Code plugin` · `one command` · `plain markdown` · `MIT`

</div>

---

## Why

Every new AI session starts blind. APCD writes one short entry file that tells it what the project is, what was decided, and what's next, with no plugin needed to read it afterwards.

## Install

```bash
claude plugin marketplace add Karthikeshwar1/APCD
claude plugin install apcd@apcd
```

## Use

In any project:

```
/apcd:run
```

It reads your repo, shows a short plan, and applies on **yes**. Safe to re-run. Keep the `apcd:` prefix, since `/run` is built in.

Later, in any session or tool, say:

> pick up where we left off

## What you get

```
CLAUDE.md          # or AGENTS.md if you use other tools
docs/<topic>.md    # long topics, read only when needed
```

The entry file stays under ~150 lines:

| Section | Holds |
|---|---|
| **Decisions** | Choices and why, dated |
| **Rules** | Conventions the code doesn't show |
| **Docs** | Index of `docs/` files with *read when* triggers |
| **Progress** | Next, Done (last 3), Notes (dead ends) |

Empty sections are omitted, not filled with placeholders.

## Safe by design

- Edits docs only: never your code, never `git commit`.
- Existing docs are copied verbatim to `docs/` before any shortening. Facts are never deleted.
- Existing progress trackers (e.g. `STATUS.md`) are linked, not duplicated.
- No secrets, emails or personal paths are written.
- Re-running with nothing changed is a no-op.

## Works with other tools

| Tool | How |
|---|---|
| Claude Code | Reads `CLAUDE.md` |
| Codex, Cursor, Copilot | Read `AGENTS.md` |
| Gemini CLI | `GEMINI.md` gets `@AGENTS.md` added at the top |
| Aider | Add `read: AGENTS.md` to `.aider.conf.yml` yourself |

## Limits

- Commit your docs before running it, then review the diff.
- Rules are advisory text. Small models skip them more: on a very large hand-written entry file, haiku once in three runs rewrote it without keeping the copy (sonnet kept all facts). It may also add a filler Next item on repos with no TODOs.
- Tested with headless Claude runs on fixtures.

## License

MIT

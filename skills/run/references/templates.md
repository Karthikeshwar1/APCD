# APCD templates

`<docs>` = `docs/` (tree: single) or `.claude/docs/` (tree: twin).

## Options block
First lines of the canonical entry file. An HTML comment: Claude Code strips it, so it costs no tokens.
```markdown
<!-- apcd:options
tree: single      # single | twin
tools: claude     # claude, agents, gemini, copilot, aider (agents = Codex, Cursor, Windsurf, Cline, Zed, Junie, Amp, Kilo, Roo)
progress: here    # here = the Progress section of this file, or a path such as docs/state/STATUS.md
-->
```
Canonical entry file: `CLAUDE.md` when `tools` is only `claude`, else `AGENTS.md`.

## Entry file (CLAUDE.md or AGENTS.md)
```markdown
<options block>
# <Project>
<What it is and why, 1–2 lines. Run/architecture live in README.md; don't repeat.>

## Decisions (inputs, revisable)
- <choice>: <why> (YYYY-MM-DD)

## Rules & conventions
- Ask whenever something is ambiguous or the decision is the user's to make.
- Keep all text super concise; waste no tokens.
- <Optional project preferences the user opts into, e.g. "check what's current online before choosing libraries or models". Only what they chose; nothing personal.>

<!-- apcd:protocol v1 -->
## Resume & upkeep
- Progress lives in the `## Progress` section of this file unless the `progress:` option names another file.
- Resume ("pick up where we left", "what's next"): verify Progress against `git status` and `git log <Checkpoint>..HEAD` (ignore docs-only commits); run `Check`, and on failure fix or flag it first (flip a regressed item back to `[ ]`); take the first Next item not `[!]`; say "Resuming: <item>"; open only the docs it needs; continue. Ask instead if the item is ambiguous, Progress contradicts the repo, or the step is irreversible, costly or the user's call. If nothing is unblocked, report the blockers.
- Upkeep, same pass as the work: rewrite Now; one Next item at a time, done only after its check, evidence in Done; append surprises and failed approaches to Notes; update README Status and affected docs. Notes and Decisions are append-only (supersede, don't delete).
- Session end: refresh Progress and `Checkpoint`; leave `Check` passing or say in Now why not; suggest a commit, never commit unasked.
- Only the main session edits Progress; subagents get a brief (objective, output, boundaries, done-criteria) and report back.
- Overflow (~20 Progress lines, ~150 entry-file lines): move the oldest entries verbatim to `<docs>/progress-archive.md`, leave a one-line pointer; never read it unless asked.
<!-- /apcd:protocol -->

## Layout (non-obvious only)
- `<dir>/`: <purpose>

## Docs (read only when needed)
- `<docs>/<topic>.md`: read when <trigger>

## Progress
- Checkpoint: <short-sha> (YYYY-MM-DD): last commit these notes describe
- Check: <command that proves the project works, e.g. `npm test`; omit if none>
- Now: <what is in flight, ≤3 lines>
- Next: status `[ ]` todo, `[~]` doing, `[!]` blocked on <who/what>
  1. [ ] <item>
- Done: <item>: <evidence> (YYYY-MM-DD)
- Notes: <surprises, failed approaches and why> (YYYY-MM-DD)
- Open questions: <question>
```

## README.md (human entry)
```markdown
# <Project>
<What it is, 1–2 lines.>

## Architecture
<Small diagram if useful>

## Requirements
<Runtime, versions, hardware>

## Run
<Commands>

## Status
<One line> (YYYY-MM-DD)

## Docs
- [<Topic>](<docs>/<topic>.md)
```

## Shims
Only when the canonical file is `AGENTS.md`. A shim holds no content, just a pointer. Create one per chosen tool.

| Tool | Shim |
|---|---|
| Claude Code | `CLAUDE.md`: `@AGENTS.md` |
| Gemini CLI | `GEMINI.md`: `@AGENTS.md` |
| GitHub Copilot | `.github/copilot-instructions.md`: `Read AGENTS.md at the repo root.` |
| Aider | `.aider.conf.yml`: `read: AGENTS.md` (YAML because the tool requires it) |
| Codex, Cursor, Windsurf, Cline, Zed, Junie, Amp, Kilo, Roo | none, they read `AGENTS.md` |

Codex silently truncates `AGENTS.md` past 32 KiB; keep it well under.

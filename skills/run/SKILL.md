---
name: run
description: "Set up, update, customize, trim or check APCD project docs (concise docs + a Progress log). Run by hand: /apcd:run [customize | trim | check]."
argument-hint: "[customize | trim | check]"
disable-model-invocation: true
---

Mode: `$ARGUMENTS` (none = set up or update). Templates, options and shims: `${CLAUDE_SKILL_DIR}/references/templates.md`. Read it before writing.

## Conventions
- **Layout**: canonical entry file (always loaded) · `README.md` (human entry) · `<docs>/<topic>.md` (topic docs, read on demand). Default `tree: single` (`docs/`). Propose `twin` in one line when the project is big (~8+ topic docs, or Claude-only notes clutter human docs); on yes, move Claude-only docs to `.claude/docs/`.
- **Split**: a topic needing more than ~4–5 lines gets its own topic doc, indexed from the entry file as `path: read when <trigger>`. Shorter info stays inline.
- **Index, don't import**: never `@path` for topic docs (imports load eagerly, defeating on-demand loading). The only import is a one-line shim to the canonical file.
- **Concise is the design**: every doc and edit as short as it can be and still clear; link, don't duplicate; dates `YYYY-MM-DD`.
- **Markdown only**: no scripts or JSON unless a tool forces it (shims).
- **Decisions are inputs**: follow them; propose a revision when evidence changes; the user decides.
- **Everything in the project**: state and options live in committed repo files. Nothing personal, nothing outside the repo.

## No argument: set up or update
1. Read README.md, CLAUDE.md, AGENTS.md, docs and the code layout. Ask about anything unclear (goal, stack, decisions).
2. No options block yet: ask once with AskUserQuestion: **Defaults (Recommended)** / Customize / Show plan only. Defaults: `tree: single`, `tools` = those detected in the repo, else `claude`. Customize: ask the tools (multi-select: other AGENTS.md readers, Gemini CLI, GitHub Copilot, Aider) and the tree. Options block exists: use it, don't ask.
3. Show the plan; apply on yes.
4. **Adopt, don't duplicate**: if equivalents exist (STATUS.md, AGENTS.md, docs/), keep their paths and map to them (set `progress:` to an existing STATUS.md). Add only what's missing: options block, protocol block, `Checkpoint`, `Check`, shims. Ask before moving or deleting human-written text.
5. Otherwise write the canonical entry file and `README.md` from the templates, topic docs only where the split rule demands, and the shims the options call for.
6. Detect the test/build command for `Check`; seed `Checkpoint` from `git rev-parse --short HEAD`.
7. Protocol block missing or older than `v1`: replace just that block.
Re-running is safe: add only what's missing.

## customize
Re-ask the option questions, update the options block, add or remove shims to match. Show the plan first.

## trim
Tighten wording in the entry file and topic docs: merge duplicates, cut filler, keep every fact. Show the diff; apply on yes. Progress overflow goes verbatim to `<docs>/progress-archive.md`; anything else removed is in git.

## check
Report only, no edits:
- entry file lines (~150) and bytes (Codex truncates `AGENTS.md` past 32 KiB); Progress lines (~20)
- `git log <Checkpoint>..HEAD`: commits since, ignoring docs-only
- protocol block present and `v1`; options block present
- docs links that point to missing files; index lines without a `read when` trigger
- shims present for each chosen tool and still one line
End with the smallest list of fixes.

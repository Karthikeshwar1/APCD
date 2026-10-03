# APCD findings (final)

**Bottom line.** `plugin-variants/v21` is 25% smaller than the shipped skill (2321 -> 1740 B) and its README is 29% smaller (1210 -> 865 B). It passed the full scenario suite on haiku (the cheapest model), passed the two hardest scenarios on sonnet, and fixes one data-loss bug and several other defects in the shipped skill. Evidence and the exact diff are below. Everything here is for you to act on.

**Cost / safety note.** All testing used only the `claude` CLI under your claude.ai login (no API keys are set; Gemini, Google and OpenAI were never called and no Gemini tool was run). 87 headless runs; the CLI's own cost estimate totals about $7.5, and I cannot tell whether that is billed to your plan or is just a usage figure. Gemini and Aider behavior came from their public docs only.

## Before / after
| Metric | Original | v21 (proposed) |
|---|---|---|
| SKILL.md | 2321 B | 1740 B (-25%) |
| README.md | 1210 B | 865 B (-29%), file `plugin-variants/v21/README.md` |
| Entry file on the sandbox (S1) | v8 (original + fixes): 923 B | 627 B (-32%) |
| Sandbox chain (S1 -> S2 -> S3, hidden tests of 5) | v8: 0 -> 5 -> 5 | 0 -> 5 -> 5; S2 21 turns / $0.11, S3 1 turn |
| Oversized human CLAUDE.md (182 facts) | lost 180 facts (v6) | 182/182 kept, 3 of 3 runs (2 haiku, 1 sonnet) |
| Second /apcd:run | n/a | no-op (md5 identical) |
| Agent commits during /apcd:run | 1 (a-base) | 0 in all 8 suite runs |

## How it was tested (test matrix)
| Test type | What it catches | Cost |
|---|---|---|
| `static.sh` lint of SKILL.md | contradictions ("one-line link" vs the template), size, personal data, duplicate headings | free |
| `check-entry.sh` validator | dead links, docs index pointing to missing files, bad @imports, personal data | free |
| Fixture scenarios a-i (`setup.sh`, `assert.sh`) | empty repo; existing docs + STATUS.md; multi-tool (.cursor, GEMINI.md); oversized human CLAUDE.md; stale re-run; personal data; prompt injection; copilot + aider | $0.04-0.17 each |
| Sandbox chain (`chain.sh`, tiny Node project `tasklog` + hidden acceptance tests) | does the doc make a fresh session do the real work; Progress freshness; doc growth | $0.2-0.4 per 3-session chain |
| Frozen-state A/B (`frozen.sh`) | isolates the value of one element by changing only it | ~$0.1 per cell |
| Mid-task resume, link-layout resume | resume after partial work, or via a `- Status:` link | ~$0.12-0.16 |
| Second run, sonnet cross-check | idempotence; haiku-only vs real wording problems | ~$0.05 / ~$0.15-0.25 |

The harness lives in `apcd-evals/`; `LOG.md` has every run.

## Ranked problems and fixes (original -> v21)
1. **Data loss on a large human-written entry file** (severity: high)
   - Evidence: fixture e (194-line CLAUDE.md, 182 `FACT-*` markers). v6 (original + 1 line) cut it to 16 lines and deleted 180 markers. A "never delete, move overflow" rule in the Rules section worked 2 of 4 times; a reworded variant (v20) got 0/1 (one `Edit` replaced the whole file).
   - Fix: a numbered STEP before the plan: "Before shortening or rewriting any existing doc, copy it unchanged to `docs/<topic>.md` (`cp`, never retype), and list it as `path: read when <trigger>`", plus "Never delete facts." in Rules.
   - Verified: v21 on e: haiku 182/182 twice (verbatim copies `docs/claude-verbose.md`, `docs/claude-backup.md`), sonnet 182/182. Lesson: procedural steps beat prose rules on small models.
2. **STATUS.md-style trackers duplicated into the entry file** (scenario b). Progress copied the Next list the tracker already owns.
   - Fix (step 5): "If a progress file already exists (e.g. `docs/state/STATUS.md`), Progress is only `- Status: <its path>`."
   - Verified: b passes on v13 to v21; a fresh session followed the link, did the work and updated STATUS.md. The wording must name an existing file: a looser wording leaked `- Status: Initial setup` into repos with no tracker (a-v14, g-v15).
3. **Dead links and stale Done items not cleaned on re-run** (scenario f). Deleting the shipped re-run step cost this.
   - Fix (Rules): "Remove docs entries whose file doesn't exist; keep only the last 3 Done items (git has them)."
   - Verified: abstract wording "Fix dead links" was ignored 2/2; the checkable wording passed on haiku (f-v18, f-v21) and sonnet (f-v17).
4. **Agent commits unasked**: a-base ran `git commit`. Fix: "Never git commit." Verified: 0 commits in all later runs.
5. **Next-list wording backfires** (two attempts). "Leave Next empty if no work is known" made haiku ignore the TODOs in the code, so the next session took 43 turns / $0.27 and invented a bloated Progress format. "Next is the TODOs found in the repo" made the docs command implement the code itself (hidden tests 5/5 right after setup).
   - Fix: no Next clause, plus "Edit docs only, never code."
   - Verified: chains v20 and v21: 3 Next items from the 3 TODOs, no code touched.
6. **Self-contradiction in the shipped skill**: "Progress is a one-line link" vs the template's Next/Done block (found by `static.sh`). Resolved by item 2.
7. **Resume lines under Progress are not load-bearing.** Frozen A/B, with vs without the two lines: "pick up where we left off" 5/5 vs 5/5; "what's next?" 0/5 (it only answered) vs 5/5. Removed, which also saves context in every future session. Mid-task resume and link-layout resume also worked without them.
8. **Gemini CLI wiring.** Per its docs, Gemini CLI reads only `GEMINI.md` by default but supports `@file` imports, so the shipped `@AGENTS.md` shim is valid. My v10 deleted it and Gemini sessions then never saw Progress.
   - Fix (step 2): "put `@AGENTS.md` first in any existing `GEMINI.md` (keep its content)".
   - Verified: sonnet yes (twice); haiku yes in d-v21. Earlier wordings failed on haiku; one combined sentence made it forget `CLAUDE.md` entirely, hence two sentences.
9. **Haiku-only drift (not fixable by wording).** It leaves `(none yet)` and empty headings, adds filler Next items ("Build initial API structure") on repos with no TODOs, and applies .cursor rules inconsistently. Sonnet follows the template. The empty-section problem remains in v21.

## Diff: original SKILL.md -> v21 (unified, exact)
```diff
--- ../apcd/skills/run/SKILL.md	2026-10-03 00:35:49.190691000 +0530
+++ plugin-variants/v21/skills/run/SKILL.md	2026-10-03 04:41:12.367891500 +0530
@@ -7,21 +7,22 @@
 Set up or refresh this project's docs so a new session can pick up where the last one stopped. Safe to re-run.
 
 ## Steps
-1. Read README.md, CLAUDE.md, AGENTS.md, docs/ and the code layout. Ask only what you can't infer (goal, key decisions).
-2. Entry file: `AGENTS.md` if the repo shows any non-Claude tool (`AGENTS.md`, `GEMINI.md`, `.cursor/`, `.github/copilot-instructions.md`, `.aider*`), else `CLAUDE.md`.
-3. Show a short plan; apply on yes.
-4. Adopt, don't duplicate: keep existing docs and paths, add only what's missing. If progress is already tracked elsewhere (e.g. `STATUS.md`), the Progress section is a one-line link to it. Ask before moving or deleting human-written text.
-5. On re-run: fix dead links and stale facts, tighten wording (keep every fact), add missing shims.
+1. Read README.md, CLAUDE.md, AGENTS.md, docs/ and the code (including TODOs). Ask only what you can't infer.
+2. Entry file: `AGENTS.md` if the repo shows a non-Claude tool (`GEMINI.md`, `.cursor/`, `.github/copilot-instructions.md`, `.aider*`), else `CLAUDE.md`. With AGENTS.md, also write `CLAUDE.md` as `@AGENTS.md`, and put `@AGENTS.md` first in any existing `GEMINI.md` (keep its content).
+3. Before shortening or rewriting any existing doc, copy it unchanged to `docs/<topic>.md` (`cp`, never retype), and list it as `path: read when <trigger>`.
+4. Show a short plan; apply on yes.
+5. Adopt, don't duplicate: keep existing docs. If a progress file already exists (e.g. `docs/state/STATUS.md`), Progress is only `- Status: <its path>`.
 
 ## Rules
-- Concise: every doc as short as it can be and still clear. Link, don't duplicate. Dates `YYYY-MM-DD`.
-- A topic needing more than ~5 lines gets `docs/<topic>.md`, listed in the entry file as `path: read when <trigger>`. Don't `@`-import topic docs: imports load every session.
-- Markdown only, all in the repo, nothing personal. Entry file under ~150 lines.
+- Concise, under ~150 lines, link don't duplicate, dates `YYYY-MM-DD`, markdown only, nothing personal. Remove docs entries whose file doesn't exist; keep only the last 3 Done items (git has them).
+- Never delete facts. Never `@`-import topic docs.
+- Edit docs only, never code. Never git commit. Never invent.
+- Keep the template headings verbatim.
 
 ## Entry file
 ```markdown
 # <Project>
-<What it is and why, 1–2 lines. How to run: README.md.>
+<What it is and why, 1–2 lines. How to run.>
 
 ## Decisions
 - <choice>: <why> (YYYY-MM-DD)
@@ -33,29 +34,7 @@
 - `docs/<topic>.md`: read when <trigger>
 
 ## Progress
-"Pick up where we left off" / "what's next": start the first Next item.
-Keep this section and the docs current and concise as you work; drop old Done items (git has them).
 - Next:
   1. <item>
 - Done: <item> (YYYY-MM-DD)
-- Notes: <surprises, dead ends> (YYYY-MM-DD)
 ```
-
-## README.md (only if missing)
-```markdown
-# <Project>
-<What it is, 1–2 lines.>
-
-## Run
-<Requirements and commands>
-
-## Docs
-- [<Topic>](docs/<topic>.md)
-```
-
-## Shims (only when the entry file is AGENTS.md)
-- `CLAUDE.md`: `@AGENTS.md`
-- `GEMINI.md`: `@AGENTS.md`, if Gemini CLI is used
-- `.aider.conf.yml`: `read: AGENTS.md`, if Aider is used
-
-Other tools read `AGENTS.md` directly. Codex truncates it past 32 KiB.
```

## Things deleted, with evidence (delete first, restore about 10%)
| Deleted | Evidence | Verdict |
|---|---|---|
| Two resume lines under Progress + "verbatim" rule | frozen A/B, chains, mid-task, link layout | DELETED, no loss |
| README.md template in the skill | scenario a no longer creates a README; repos in all other tests had one | DELETED; accepted loss (entry file has "How to run") |
| `.aider.conf.yml` shim | docs: Aider never auto-reads AGENTS.md; haiku did not create it reliably anyway | DELETED; README tells the user the one line to add |
| Codex 32 KiB line, Notes line, README "Limits" bullets | no test depends on them | DELETED |
| Re-run step (5) | f lost its dead-link cleanup | RESTORED as one Rules clause |
| `## Docs` template section | v11 (removed): data loss on e | RESTORED |
| GEMINI shim | Gemini docs + the v10 gap | RESTORED as one clause |

Untested candidates to delete: `plugin.json` `keywords` and the duplicate description in `marketplace.json` (655 B across both files). The empty-heading problem might be solved by deleting the "Keep the template headings verbatim" rule, but that is untested and risks breaking e.

## Open questions for you
- Aider: do you want it wired? v21 leaves it to the user (one line in the README). A skill clause did not make haiku create it reliably.
- Is haiku a supported model? It leaves empty headings and filler Next items; sonnet does not. v21 is tuned so haiku does not lose data or break resume, not to be pretty.
- Should plain (non-plugin) sessions also be told "never git commit"? That rule only governs `/apcd:run`; it would have to live in the entry file's Rules.
- "Start the first Next item" is no longer in the entry file; sessions still resume on "pick up where we left off". OK to change the README promise to that?
- Scenario a no longer creates a README. Acceptable?
- `/apcd:run` says "apply on yes" with no non-interactive path. My harness appended "apply without asking".

## Known gaps and test hygiene
- n=1 per cell on haiku except where noted. Variance is large: the same wording passed and failed e within one variant family.
- `assert.sh`'s "no new commit" reads a copy without `.git` (vacuous); commits were verified by hand in `tmp/<name>` for all 8 suite runs.
- STATUS-link resume and mid-task resume were tested with v10/v13-era entry files, not re-run on v21 (v21 writes the same entry-file shape).
- My first fixture had an ambiguous TODO (`[x| ]`); fixed after the first chains, so v8/v9 chain numbers are not strictly comparable to v10 and later.

## Proposed SKILL.md (v21, 1740 B; before: 2321 B)
Source: `plugin-variants/v21/skills/run/SKILL.md`.

````markdown
---
name: run
description: "Set up or refresh APCD project docs: one concise entry file (CLAUDE.md or AGENTS.md) with a Progress list any new session can resume from."
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
````

## Proposed README.md

````markdown
# APCD

Concise project docs plus a Progress list, so any new AI coding session can pick up where you left off.

## Install

```bash
claude plugin marketplace add Karthikeshwar1/APCD
claude plugin install apcd@apcd
```

## Use

Run `/apcd:run` in a project (keep the prefix; `/run` is built in). It shows a plan, applies on yes, and is safe to re-run.

It writes one entry file, `CLAUDE.md` (or `AGENTS.md` if you use other tools): Decisions, Rules, Docs, Progress. Longer topics go in `docs/<topic>.md`. Then say "pick up where we left off" and the agent starts the first Next item. Resume needs no plugin: it is plain markdown in the repo.

## Limits

Rules are advisory; a model can skip them (small models skip more). Gemini CLI reads `GEMINI.md`, which the skill points at `AGENTS.md`. Aider needs `read: AGENTS.md` in `.aider.conf.yml`; add it yourself.

MIT
````

## Addendum: v22 (shipped)
v21 with "Keep the template headings verbatim" replaced by "Omit any section with nothing real to put in it: no placeholders, no filler." Haiku on a, d, e, f: all assertions pass (e 182/182) and the empty headings from problem 9 are gone. Residual: a filler Next item on repos with no TODOs (every Next-clause tried backfired, see problem 5).

## Addendum: v23 (shipped)
Final regression on v22 found two gaps: a secret-looking key copied into the entry (g) and a dead-end Notes fact dropped on re-run (f), because v22 removed the Notes line. v23 restores `- Notes:` in the template and adds "Never write secrets, keys, emails or personal paths." Re-test (haiku): f 2/2, g 2/2, a, b pass. Chain v22: S1 0/5, S2 5/5, S3 5/5, 0 commits.
Open risk: scenario e (182 facts) on haiku is flaky: v23 gave 180, 182, 0 of 182. Rewording step 3 to a line-count trigger (v24) was worse, 0/3, so it was reverted. Mitigation is in the README: commit first, review the diff. Total eval runs about 100.

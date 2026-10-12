#!/bin/sh
# APCD docs nudge. `mark` (PostToolUse, async): count code edits, clear on doc edits.
# `stop` (Stop): if code changed but the entry file wasn't touched, ask once for a minimal update.
# Silent no-op outside APCD projects; never fails the session. Disable: APCD_HOOK=off
trap 'exit 0' EXIT
[ "$APCD_HOOK" = off ] && exit 0
D=${CLAUDE_PROJECT_DIR:-.}
E=$(grep -ls '^## Progress' "$D/AGENTS.md" "$D/CLAUDE.md" | head -1)
[ -n "$E" ] || exit 0
IN=$(cat)
S=$(printf %s "$IN" | grep -o '"session_id" *: *"[^"]*"' | head -1 | sed 's/.*: *"//; s/"$//; s/[^A-Za-z0-9_-]//g')
[ -n "$S" ] || exit 0
M=${TMPDIR:-/tmp}/apcd-$S

case $1 in
mark)
  F=$(printf %s "$IN" | grep -o '"file_path" *: *"[^"]*"' | head -1 | sed 's/.*: *"//; s/"$//; s/\\/\//g')
  case $F in
  */CLAUDE.md|*/AGENTS.md|*/docs/*.md) rm -f "$M" ;;   # docs touched: clean slate
  *.md|"") ;;                                          # other markdown: not a code change
  *) echo . >> "$M" ;;
  esac ;;
stop)
  printf %s "$IN" | grep -q '"stop_hook_active" *: *true' && exit 0
  [ -f "$M" ] && [ "$(wc -l < "$M")" -ge 2 ] || exit 0  # 1 edit is usually a tweak, not progress
  rm -f "$M"
  N=; [ "$(wc -l < "$E")" -gt 150 ] && N=" It is over 150 lines: move detail to docs/<topic>.md (copy verbatim, then link) instead of growing it."
  printf '%s\n' '{"decision":"block","reason":"APCD: code changed this session but project docs were not touched. Re-read Progress in '"$(basename "$E")"' (or the status file it links). Make the smallest edit that keeps it true: Done (last 3 only), Next, Notes; Decisions/Rules/docs only if they changed. If nothing new, change nothing and reply \"docs current\". Do not commit.'"$N"'"}' ;;
esac

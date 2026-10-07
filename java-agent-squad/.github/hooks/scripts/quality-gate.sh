#!/usr/bin/env bash
# Stop hook (scoped to the Tech Lead agent): the agent cannot finish while tests are red.
set -u
INPUT="$(cat)"
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
LOGS="$ROOT/.github/hooks/logs"; mkdir -p "$LOGS"
cd "$ROOT" || exit 0

# Already sent back once? Let it stop, so a broken build can't burn AI credits forever.
printf '%s' "$INPUT" | tr -d '\r\n' | grep -qE '"stop_hook_active"[[:space:]]*:[[:space:]]*true' && exit 0
[ -f pom.xml ] || exit 0
# In a Git repo, skip the gate when nothing under src/ changed (e.g. a pure Q&A turn).
if git rev-parse --is-inside-work-tree >/dev/null 2>&1 && [ -z "$(git status --porcelain -- src)" ]; then exit 0; fi

printf '%s  🧪 quality gate: running mvn test…\n' "$(date +%H:%M:%S)" >> "$LOGS/timeline.log"
OUT="$(mvn -B -q test 2>&1)"; CODE=$?
if [ $CODE -eq 0 ]; then
  printf '%s  ✅ quality gate GREEN — agent may finish\n' "$(date +%H:%M:%S)" >> "$LOGS/timeline.log"
  exit 0
fi

printf '%s  🔁 quality gate RED — sending the agent back to work\n' "$(date +%H:%M:%S)" >> "$LOGS/timeline.log"
SUMMARY="$(printf '%s\n' "$OUT" | grep -E 'Tests run:|FAIL|expected|ERROR\]|Exception' | grep -vE '^\[FX\]|Help|-X switch|-e switch|See |dump|For more information|^\[ERROR\][[:space:]]*$' | head -15 \
  | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/\t/ /g' | tr -d '\r' | awk 'BEGIN{ORS="\\n"}{print}')"
REASON="Quality gate: mvn test is failing. You are not done. Fix the production code (not the tests) until mvn -q test passes, then summarize.\\n$SUMMARY"
printf '{"decision":"block","reason":"%s","hookSpecificOutput":{"hookEventName":"Stop","decision":"block","reason":"%s"}}\n' "$REASON" "$REASON"
exit 0

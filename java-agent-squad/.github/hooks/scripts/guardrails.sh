#!/usr/bin/env bash
# PreToolUse guardrail. Blocks destructive terminal commands and edits to the hooks themselves.
# Exit code 2 = block (Local harness and Copilot CLI/SDK both treat it as a deny).
set -u
INPUT="$(cat)"
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FLAT="$(printf '%s' "$INPUT" | tr -d '\r\n')"
TOOL="$(printf '%s' "$FLAT" | sed -nE 's/.*"(tool_name|toolName)"[[:space:]]*:[[:space:]]*"([^"]*)".*/\2/p')"

deny() {
  REASON="$1"
  mkdir -p "$ROOT/.github/hooks/logs"
  printf '%s  ⛔ BLOCKED %s — %s\n' "$(date +%H:%M:%S)" "$TOOL" "$REASON" >> "$ROOT/.github/hooks/logs/timeline.log"
  printf '{"permissionDecision":"deny","permissionDecisionReason":"%s","hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$REASON" "$REASON"
  echo "Blocked by .github/hooks/guardrails.json: $REASON" >&2
  exit 2
}

if printf '%s' "$TOOL" | grep -qiE 'terminal|bash|powershell|shell|execute|run_in|command'; then
  printf '%s' "$FLAT" | grep -qE 'rm[[:space:]]+-[a-zA-Z]*(rf|fr)|Remove-Item[^"]*-Recurse' && deny "Recursive delete is not allowed. Ask the human to do it."
  printf '%s' "$FLAT" | grep -qE 'git[[:space:]]+push'                 && deny "Agents may not push. Open a PR from the Agents window instead."
  printf '%s' "$FLAT" | grep -qE 'git[[:space:]]+reset[[:space:]]+--hard|git[[:space:]]+clean' && deny "Destructive git command. Use checkpoints to undo."
  printf '%s' "$FLAT" | grep -qE 'mvn[^"]*[[:space:]]deploy'           && deny "Deploys are performed by the release pipeline, not by agents."
  printf '%s' "$FLAT" | grep -qE 'curl[^"]*\|[[:space:]]*(ba|z)?sh'    && deny "Piping remote scripts into a shell is not allowed."
fi

if printf '%s' "$TOOL" | grep -qiE 'edit|create|write|replace|patch|insert'; then
  printf '%s' "$FLAT" | grep -qE '\.github[/\\]+hooks' && deny "Agents may not modify their own guardrails (.github/hooks)."
fi

exit 0

#!/usr/bin/env bash
# Audit trail for every agent lifecycle event.
#   .github/hooks/logs/audit.jsonl   machine-readable, one event per line
#   .github/hooks/logs/timeline.log  human-readable; `tail -f` it during a demo
set -u
EVENT="${1:-Unknown}"
INPUT="$(cat)"
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
LOGS="$ROOT/.github/hooks/logs"
mkdir -p "$LOGS"

FLAT="$(printf '%s' "$INPUT" | tr -d '\r\n')"
field() { # first string value for any of the given keys (handles Local and Copilot payload shapes)
  for k in "$@"; do
    v="$(printf '%s' "$FLAT" | sed -nE "s/.*\"$k\"[[:space:]]*:[[:space:]]*\"(([^\"\\\\]|\\\\.)*)\".*/\1/p")"
    [ -n "$v" ] && { printf '%s' "$v" | cut -c1-110; return; }
  done
}

NOW="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
printf '{"logged_at":"%s","event":"%s","payload":%s}\n' "$NOW" "$EVENT" "${FLAT:-null}" >> "$LOGS/audit.jsonl"

T="$(date +%H:%M:%S)"
case "$EVENT" in
  SessionStart)     LINE="🚀 session started" ;;
  UserPromptSubmit) LINE="💬 prompt: $(field prompt)" ;;
  PreToolUse)       LINE="🛠️  $(field tool_name toolName)  $(field command filePath file_path path query)" ;;
  SubagentStart)    LINE="🤖 ┌ subagent START  $(field agent_type agentName agent_name)" ;;
  SubagentStop)     LINE="🤖 └ subagent DONE   $(field agent_type agentName agent_name)" ;;
  Stop)             LINE="🏁 agent turn finished" ;;
  *)                LINE="•  $EVENT" ;;
esac
printf '%s  %s\n' "$T" "$LINE" >> "$LOGS/timeline.log"

# Some events can inject context into the conversation.
case "$EVENT" in
  SessionStart)
    BRANCH="$(git -C "$ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'not a git repo')"
    JAVA="$(java -version 2>&1 | head -1 | tr -d '"')"
    printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"Ledgerly Payments | branch: %s | %s | Guardrail hooks are active: pushes, deploys, recursive deletes and edits to .github/hooks are blocked."}}\n' "$BRANCH" "$JAVA"
    ;;
  SubagentStart)
    printf '{"hookSpecificOutput":{"hookEventName":"SubagentStart","additionalContext":"You are a subagent of the Ledgerly squad. Cite every finding as file:line. Return a concise Markdown table, not prose."}}\n'
    ;;
esac
exit 0

#!/usr/bin/env bash
# Live view of everything the agents do. Run in a terminal next to the chat during the demo.
cd "$(dirname "$0")/.."
mkdir -p .github/hooks/logs && touch .github/hooks/logs/timeline.log
echo "👀 Watching .github/hooks/logs/timeline.log (Ctrl+C to stop)"
tail -n 0 -f .github/hooks/logs/timeline.log

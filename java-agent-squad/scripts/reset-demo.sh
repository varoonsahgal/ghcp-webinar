#!/usr/bin/env bash
# Put the repo back to the buggy baseline and clear the hook logs. (Humans only — the guardrail blocks agents from this.)
set -e
cd "$(dirname "$0")/.."
git reset -q --hard demo-start
git clean -qfd src
rm -rf .github/hooks/logs target
echo "🔄 Reset to demo-start. Logs cleared."

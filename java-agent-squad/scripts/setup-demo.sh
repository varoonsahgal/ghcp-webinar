#!/usr/bin/env bash
# One-time: turn this folder into a Git repo with a "demo-start" tag so you can reset between runs.
set -e
cd "$(dirname "$0")/.."
[ -d .git ] || git init -q -b main
git add -A
git -c user.name="Demo" -c user.email="demo@example.com" commit -q -m "Ledgerly legacy baseline" || true
git tag -f demo-start >/dev/null
echo "✅ Ready. Baseline tagged as demo-start. Reset any time with scripts/reset-demo.sh"

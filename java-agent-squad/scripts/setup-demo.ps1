Set-Location (Join-Path $PSScriptRoot "..")
if (-not (Test-Path .git)) { git init -q -b main }
git add -A
git -c user.name="Demo" -c user.email="demo@example.com" commit -q -m "Ledgerly legacy baseline"
git tag -f demo-start | Out-Null
Write-Output "Ready. Baseline tagged as demo-start. Reset any time with scripts\reset-demo.ps1"

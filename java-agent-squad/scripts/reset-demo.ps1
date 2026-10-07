Set-Location (Join-Path $PSScriptRoot "..")
git reset -q --hard demo-start
git clean -qfd src
Remove-Item -Recurse -Force .github\hooks\logs, target -ErrorAction SilentlyContinue
Write-Output "Reset to demo-start. Logs cleared."

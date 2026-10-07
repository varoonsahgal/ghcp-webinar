Set-Location (Join-Path $PSScriptRoot "..")
New-Item -ItemType Directory -Force .github\hooks\logs | Out-Null
if (-not (Test-Path .github\hooks\logs\timeline.log)) { New-Item .github\hooks\logs\timeline.log | Out-Null }
Write-Output "Watching .github\hooks\logs\timeline.log (Ctrl+C to stop)"
Get-Content .github\hooks\logs\timeline.log -Wait -Tail 0 -Encoding UTF8

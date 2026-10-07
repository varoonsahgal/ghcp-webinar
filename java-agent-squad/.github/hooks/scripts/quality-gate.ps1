# Stop hook (Windows version of quality-gate.sh): the agent cannot finish while tests are red.
$raw  = [Console]::In.ReadToEnd()
$root = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
$logs = Join-Path $root ".github\hooks\logs"; New-Item -ItemType Directory -Force -Path $logs | Out-Null
Set-Location $root
function Log([string]$m) { Add-Content -Path (Join-Path $logs "timeline.log") -Value "$(Get-Date -Format HH:mm:ss)  $m" -Encoding UTF8 }

if ($raw -match '"stop_hook_active"\s*:\s*true') { exit 0 }
if (-not (Test-Path "pom.xml")) { exit 0 }
$inGit = (git rev-parse --is-inside-work-tree 2>$null) -eq "true"
if ($inGit -and -not (git status --porcelain -- src)) { exit 0 }

Log "🧪 quality gate: running mvn test…"
$out = (& mvn -B -q test 2>&1 | Out-String)
if ($LASTEXITCODE -eq 0) { Log "✅ quality gate GREEN — agent may finish"; exit 0 }

Log "🔁 quality gate RED — sending the agent back to work"
$summary = ($out -split "`n" | Where-Object { $_ -match 'Tests run:|FAIL|expected|ERROR\]|Exception' -and $_ -notmatch '^\[FX\]|Help|-X switch|-e switch|See |dump|For more information|^\[ERROR\]\s*$' } | Select-Object -First 15) -join "`n"
$reason = "Quality gate: mvn test is failing. You are not done. Fix the production code (not the tests) until mvn -q test passes, then summarize.`n$summary"
@{ decision = "block"; reason = $reason; hookSpecificOutput = @{ hookEventName = "Stop"; decision = "block"; reason = $reason } } | ConvertTo-Json -Compress
exit 0

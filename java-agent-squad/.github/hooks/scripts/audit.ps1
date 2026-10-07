# Audit trail for every agent lifecycle event (Windows version of audit.sh).
param([string]$Event = "Unknown")
$ErrorActionPreference = "SilentlyContinue"
$raw  = [Console]::In.ReadToEnd()
$root = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
$logs = Join-Path $root ".github\hooks\logs"
New-Item -ItemType Directory -Force -Path $logs | Out-Null
$p = $null; try { $p = $raw | ConvertFrom-Json } catch {}

function Pick([string[]]$names, $obj) {
  foreach ($n in $names) { if ($obj -and $obj.$n) { $v = "$($obj.$n)"; return $v.Substring(0, [Math]::Min(110, $v.Length)) } }
  return ""
}
$flat = ($raw -replace "[`r`n]", "")
if (-not $flat) { $flat = "null" }
$now = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
Add-Content -Path (Join-Path $logs "audit.jsonl") -Value "{`"logged_at`":`"$now`",`"event`":`"$Event`",`"payload`":$flat}" -Encoding UTF8

$args1 = if ($p.tool_input) { $p.tool_input } else { $p.toolArgs }
$line = switch ($Event) {
  "SessionStart"     { "🚀 session started" }
  "UserPromptSubmit" { "💬 prompt: $(Pick @('prompt') $p)" }
  "PreToolUse"       { "🛠️  $(Pick @('tool_name','toolName') $p)  $(Pick @('command','filePath','file_path','path','query') $args1)" }
  "SubagentStart"    { "🤖 ┌ subagent START  $(Pick @('agent_type','agentName','agent_name') $p)" }
  "SubagentStop"     { "🤖 └ subagent DONE   $(Pick @('agent_type','agentName','agent_name') $p)" }
  "Stop"             { "🏁 agent turn finished" }
  default            { "•  $Event" }
}
Add-Content -Path (Join-Path $logs "timeline.log") -Value "$(Get-Date -Format HH:mm:ss)  $line" -Encoding UTF8

if ($Event -eq "SessionStart") {
  $branch = (git -C $root rev-parse --abbrev-ref HEAD 2>$null); if (-not $branch) { $branch = "not a git repo" }
  $java = ((java -version 2>&1) | Select-Object -First 1) -replace '"', ''
  @{ hookSpecificOutput = @{ hookEventName = "SessionStart"; additionalContext = "Ledgerly Payments | branch: $branch | $java | Guardrail hooks are active: pushes, deploys, recursive deletes and edits to .github/hooks are blocked." } } | ConvertTo-Json -Compress
}
if ($Event -eq "SubagentStart") {
  @{ hookSpecificOutput = @{ hookEventName = "SubagentStart"; additionalContext = "You are a subagent of the Ledgerly squad. Cite every finding as file:line. Return a concise Markdown table, not prose." } } | ConvertTo-Json -Compress
}
exit 0

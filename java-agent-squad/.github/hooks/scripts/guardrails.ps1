# PreToolUse guardrail (Windows version of guardrails.sh). Exit code 2 = block.
$raw  = [Console]::In.ReadToEnd()
$root = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
$p = $null; try { $p = $raw | ConvertFrom-Json } catch {}
$tool = if ($p.tool_name) { $p.tool_name } else { $p.toolName }

function Deny([string]$reason) {
  $logs = Join-Path $root ".github\hooks\logs"; New-Item -ItemType Directory -Force -Path $logs | Out-Null
  Add-Content -Path (Join-Path $logs "timeline.log") -Value "$(Get-Date -Format HH:mm:ss)  ⛔ BLOCKED $tool — $reason" -Encoding UTF8
  @{ permissionDecision = "deny"; permissionDecisionReason = $reason;
     hookSpecificOutput = @{ hookEventName = "PreToolUse"; permissionDecision = "deny"; permissionDecisionReason = $reason } } | ConvertTo-Json -Compress
  [Console]::Error.WriteLine("Blocked by .github/hooks/guardrails.json: $reason")
  exit 2
}

if ($tool -match 'terminal|bash|powershell|shell|execute|run_in|command') {
  if ($raw -match 'rm\s+-[a-zA-Z]*(rf|fr)|Remove-Item[^"]*-Recurse') { Deny "Recursive delete is not allowed. Ask the human to do it." }
  if ($raw -match 'git\s+push')                                      { Deny "Agents may not push. Open a PR from the Agents window instead." }
  if ($raw -match 'git\s+reset\s+--hard|git\s+clean')                { Deny "Destructive git command. Use checkpoints to undo." }
  if ($raw -match 'mvn[^"]*\sdeploy')                                { Deny "Deploys are performed by the release pipeline, not by agents." }
  if ($raw -match '(curl|iwr|Invoke-WebRequest)[^"]*\|\s*(iex|Invoke-Expression|(ba|z)?sh)') { Deny "Piping remote scripts into a shell is not allowed." }
}
if ($tool -match 'edit|create|write|replace|patch|insert') {
  if ($raw -match '\.github[/\\]+hooks') { Deny "Agents may not modify their own guardrails (.github/hooks)." }
}
exit 0

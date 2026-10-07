# Lists lines that commonly hide money bugs. Run from the repo root.
param([string]$Root = "src/main/java")
Write-Output "== Money smells in $Root =="
$checks = [ordered]@{
  'double-money'    = '\b(double|float|Double|Float)\b[^;(]*(amount|total|principal|price|rate|interest|usd|balance)'
  'manual-round'    = 'Math\.round\('
  'int-division'    = 'days / 36[05]'
  'bigdecimal-ctor' = 'new BigDecimal\([0-9.]+\)'
  'legacy-date'     = 'java\.util\.(Date|Calendar)|SimpleDateFormat'
}
foreach ($k in $checks.Keys) {
  Get-ChildItem -Path $Root -Recurse -Filter *.java |
    Select-String -Pattern $checks[$k] |
    ForEach-Object { "[$k] $($_.Path):$($_.LineNumber): $($_.Line.Trim())" }
}

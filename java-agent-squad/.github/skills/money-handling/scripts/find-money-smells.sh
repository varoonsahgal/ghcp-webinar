#!/usr/bin/env bash
# Lists lines that commonly hide money bugs. Run from the repo root.
set -u
ROOT="${1:-src/main/java}"
echo "== Money smells in $ROOT =="
grep -rnE '\b(double|float|Double|Float)\b[^;(]*(amount|total|principal|price|rate|interest|usd|balance)' "$ROOT" | sed 's/^/[double-money]   /'
grep -rnE 'Math\.round\(' "$ROOT"                          | sed 's/^/[manual-round]   /'
grep -rnE '\b[a-zA-Z_]+ / 365\b|days / 36[05]' "$ROOT"     | sed 's/^/[int-division]   /'
grep -rnE 'new BigDecimal\([0-9.]+\)' "$ROOT"             | sed 's/^/[bigdecimal-ctor]/'
grep -rnE 'java\.util\.(Date|Calendar)|SimpleDateFormat' "$ROOT" | sed 's/^/[legacy-date]    /'
exit 0

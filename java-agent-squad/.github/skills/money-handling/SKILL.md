---
name: money-handling
description: Bank-grade rules for representing, rounding, splitting and converting money in Java. Use whenever code touches amounts, currency, interest, installments, FX conversion or rounding, or when reviewing code for financial-calculation bugs.
---

# Money handling (Ledgerly standard)

Follow these rules for every monetary calculation.

## 1. Representation
- Use `java.math.BigDecimal` for amounts. Never `double`/`float` — binary floating point cannot represent 0.10 exactly.
- Construct from strings or `BigDecimal.valueOf(long, scale)`: `new BigDecimal("100.00")`. Never `new BigDecimal(0.1)`.
- Keep currency next to the amount. A `record Money(BigDecimal amount, Currency currency)` is the preferred shape.
- Compare with `compareTo`, not `equals` (`2.0` and `2.00` are not `equals`).

## 2. Rounding
- Store and display at the currency's minor units: `Currency.getInstance("USD").getDefaultFractionDigits()` (USD 2, JPY 0).
- Default rounding mode is **`RoundingMode.HALF_EVEN`** (banker's rounding) unless a regulation says otherwise.
- Round **once**, at the end of a calculation, not at every intermediate step.

## 3. Splitting an amount (installments, allocations)
Splitting must be **lossless**: the parts must sum exactly to the total.
Use the *largest-remainder* method:
1. `base = total / n`, rounded **down** to minor units.
2. `remainder = total - base * n` (a whole number of cents).
3. Add one cent to the first `remainder` parts.

Example: 100.00 / 3 → `[33.34, 33.33, 33.33]` (sum 100.00). Never `[33.33, 33.33, 33.33]`.

## 4. Interest
- Day count ACT/365: `principal × rate × days / 365`. Do the division **last** in `BigDecimal` with an explicit scale (e.g. `MathContext.DECIMAL64`), then round to minor units.
- Watch for integer division: `days / 365` is `0` for any `int days < 365`.

## 5. FX conversion
- Rates are `BigDecimal`. Reject unknown currencies with a clear exception (no `NullPointerException`).
- Round the converted amount to the **target** currency's minor units.

## Tools in this skill
- Run `scripts/find-money-smells.sh` (macOS/Linux/Git Bash) or `scripts/find-money-smells.ps1` (Windows) from the repo root to list suspicious lines quickly.
- For a worked rounding-mode table, read [references/rounding-cheatsheet.md](references/rounding-cheatsheet.md) only when you need it.

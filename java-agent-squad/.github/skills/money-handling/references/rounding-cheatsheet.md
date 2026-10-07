# Rounding mode cheat sheet

| Input | HALF_UP | HALF_EVEN (default) | DOWN | CEILING |
|------:|--------:|--------------------:|-----:|--------:|
| 2.345 | 2.35 | 2.34 | 2.34 | 2.35 |
| 2.355 | 2.36 | 2.36 | 2.35 | 2.36 |
| -2.345 | -2.35 | -2.34 | -2.34 | -2.34 |

Why HALF_EVEN? Over millions of transactions HALF_UP biases totals upward;
HALF_EVEN rounds ties to the nearest even digit, so errors cancel out.

```java
BigDecimal cents = amount.setScale(2, RoundingMode.HALF_EVEN);
```

---
name: junit5-tests
description: How to write and run JUnit 5 tests in this repository, including red-green bug reproduction, parameterized tests and naming. Use when asked to add, fix or review tests, or to reproduce a bug with a failing test.
---

# JUnit 5 testing conventions

## Rules
- JUnit 5 (`org.junit.jupiter`) only. No AssertJ, Mockito or new dependencies.
- One test class per production class: `src/test/java/com/ledgerly/payments/<Class>Test.java`.
- Test names describe behaviour: `splitsHundredIntoThreeWithoutLosingAPenny()`.
- Add `@DisplayName` with the business rule in plain English.
- Prefer `@ParameterizedTest` + `@CsvSource` when the same rule has several examples.
- For `BigDecimal`, assert with `compareTo` or `assertEquals(new BigDecimal("33.34"), actual)` using the same scale.

## Reproducing a bug (red → green)
1. Write the test that captures the **correct** business behaviour.
2. Run only that class and confirm it **fails for the expected reason**:
   `mvn -q -Dtest=<ClassName>Test test`
3. Report the failing assertion message verbatim. Do not change production code unless you were asked to fix it.

## Template
```java
@DisplayName("Installments never lose or invent money")
@ParameterizedTest(name = "{0} split {1} ways sums back to {0}")
@CsvSource({ "100.00, 3", "200.00, 3", "0.05, 2", "999.99, 7" })
void partsAlwaysSumToTotal(String total, int parts) {
    var plan = new InstallmentPlanner().split(new BigDecimal(total), parts);
    assertEquals(0, plan.stream().reduce(BigDecimal.ZERO, BigDecimal::add)
                        .compareTo(new BigDecimal(total)));
}
```

## Running
- All tests: `mvn -q test` — a silent exit code 0 means green.
- Surefire reports land in `target/surefire-reports/` if you need full stack traces.

# Ledgerly Payments — project instructions

Legacy Java payments service (2014). Treat it like production banking code.

## Build & test
- Java 17, Maven, JUnit 5 only. **Do not add new dependencies** to `pom.xml`.
- Run all tests: `mvn -q test`
- Run one test class: `mvn -q -Dtest=InstallmentPlannerTest test`
- Run the nightly batch: `mvn -q compile && java -cp target/classes com.ledgerly.payments.App`

## Conventions for new or changed code
- Money is `BigDecimal`, never `double` or `float`. See the `money-handling` skill.
- Dates are `java.time` (`LocalDate`, `Instant`), never `java.util.Date` or `Calendar`.
- Never log full account numbers, card numbers, or secrets. Mask to the last 4 digits.
- Prefer small, reviewable changes. Keep public class names stable.
- Every bug fix ships with a test that failed before the fix.

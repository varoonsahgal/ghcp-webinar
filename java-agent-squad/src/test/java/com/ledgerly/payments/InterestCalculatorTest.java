package com.ledgerly.payments;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class InterestCalculatorTest {

    @Test
    void oneFullYear() {
        assertEquals(500.0, new InterestCalculator().accruedInterest(10_000, 5, 365), 0.001);
    }
}

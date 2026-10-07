package com.ledgerly.payments;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class FxConverterTest {

    @Test
    void sameCurrencyIsUnchanged() {
        assertEquals(42.0, new FxConverter().convert(42.0, "USD", "USD", "TEST"), 0.0001);
    }
}

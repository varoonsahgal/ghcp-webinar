package com.ledgerly.payments;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.List;
import org.junit.jupiter.api.Test;

class InstallmentPlannerTest {

    @Test
    void splitsEvenly() {
        List<Double> plan = new InstallmentPlanner().split(90.00, 3);
        assertEquals(List.of(30.0, 30.0, 30.0), plan);
    }
}

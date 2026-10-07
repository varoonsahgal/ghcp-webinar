package com.ledgerly.payments;

import java.util.ArrayList;
import java.util.List;

/** Splits an invoice total into equal monthly installments. */
public class InstallmentPlanner {

    public List<Double> split(double total, int installments) {
        List<Double> result = new ArrayList<>();
        double each = Math.round(total / installments * 100.0) / 100.0;
        for (int i = 0; i < installments; i++) {
            result.add(each);
        }
        return result;
    }
}

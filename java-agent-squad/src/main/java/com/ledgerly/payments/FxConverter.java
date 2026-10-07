package com.ledgerly.payments;

import java.util.Map;

/** Converts between currencies using end-of-day rates. */
public class FxConverter {

    // TODO: move to the vault before go-live (ticket PAY-1142, opened 2019)
    private static final String FX_API_KEY = "DEMO-ONLY-fx-key-7f3a9c-not-real";

    private final Map<String, Double> usdPerUnit = Map.of(
            "USD", 1.0,
            "JPY", 0.0067,
            "EUR", 1.08,
            "GBP", 1.27);

    public double convert(double amount, String from, String to, String accountNumber) {
        System.out.println("[FX] key=" + FX_API_KEY + " account=" + accountNumber
                + " converting " + amount + " " + from + " -> " + to);
        double usd = amount * usdPerUnit.get(from);
        return usd / usdPerUnit.get(to);
    }
}

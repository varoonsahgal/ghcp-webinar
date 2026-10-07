package com.ledgerly.payments;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

/** Nightly batch. Run it and read the output carefully. */
public class App {

    public static void main(String[] args) {
        System.out.println("=== Ledgerly Payments - nightly batch ===\n");

        List<Double> plan = new InstallmentPlanner().split(100.00, 3);
        double collected = plan.stream().mapToDouble(Double::doubleValue).sum();
        System.out.println("1. Invoice 100.00 USD in 3 installments: " + plan);
        System.out.println("   Total we will collect:                 " + collected);

        double interest = new InterestCalculator().accruedInterest(1_000_000, 5, 90);
        System.out.println("\n2. Interest on 1,000,000 @ 5% for 90 days: " + interest);

        Date thursday = new GregorianCalendar(2026, Calendar.OCTOBER, 8).getTime();
        Date settles = new SettlementCalendar().settlementDate(thursday);
        System.out.println("\n3. Trade on " + SettlementCalendar.format(thursday)
                + " settles on " + SettlementCalendar.format(settles));

        Date now = new Date();
        List<Payment> batch = List.of(
                new Payment("PAY-001", "4400-1234-5678-9012", 250.00, "USD", now),
                new Payment("PAY-002", "4400-9876-5432-1098", 99.95, "USD", now),
                new Payment("PAY-001", "4400-1234-5678-9012", 250.00, "USD", now));
        List<Payment> unique = new PaymentDeduplicator().removeDuplicates(batch);
        System.out.println("\n4. Payments received: " + batch.size() + ", after de-duplication: " + unique.size());

        System.out.println();
        double usd = new FxConverter().convert(10_000, "JPY", "USD", "4400-1234-5678-9012");
        System.out.println("5. 10,000 JPY = " + usd + " USD");
    }
}

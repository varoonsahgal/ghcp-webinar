package com.ledgerly.payments;

import java.util.Date;

/**
 * A single customer payment.
 * Written in 2014. "Temporary" until the new core banking platform arrives.
 */
public class Payment {

    private final String id;
    private final String accountNumber;
    private final double amount;
    private final String currency;
    private final Date createdAt;

    public Payment(String id, String accountNumber, double amount, String currency, Date createdAt) {
        this.id = id;
        this.accountNumber = accountNumber;
        this.amount = amount;
        this.currency = currency;
        this.createdAt = createdAt;
    }

    public String getId() { return id; }
    public String getAccountNumber() { return accountNumber; }
    public double getAmount() { return amount; }
    public String getCurrency() { return currency; }
    public Date getCreatedAt() { return createdAt; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Payment)) return false;
        return id.equals(((Payment) o).id);
    }

    @Override
    public String toString() {
        return "Payment{" + id + ", " + amount + " " + currency + "}";
    }
}

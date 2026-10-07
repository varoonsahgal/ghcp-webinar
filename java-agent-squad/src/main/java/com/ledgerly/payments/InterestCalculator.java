package com.ledgerly.payments;

/** Simple interest, ACT/365 day count. */
public class InterestCalculator {

    /**
     * @param principal         amount on deposit
     * @param annualRatePercent e.g. 5 means 5% per year
     * @param days              number of days the money was held
     */
    public double accruedInterest(double principal, double annualRatePercent, int days) {
        return principal * (annualRatePercent / 100) * (days / 365);
    }
}

package com.ledgerly.payments;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/** The upstream gateway sometimes sends the same payment twice. */
public class PaymentDeduplicator {

    public List<Payment> removeDuplicates(List<Payment> payments) {
        Set<Payment> unique = new HashSet<>(payments);
        return new ArrayList<>(unique);
    }
}

package com.ledgerly.payments;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import org.junit.jupiter.api.Test;

class SettlementCalendarTest {

    @Test
    void mondayTradeSettlesWednesday() {
        Date monday = new GregorianCalendar(2026, Calendar.OCTOBER, 5).getTime();
        Date wednesday = new GregorianCalendar(2026, Calendar.OCTOBER, 7).getTime();
        assertEquals(wednesday, new SettlementCalendar().settlementDate(monday));
    }
}

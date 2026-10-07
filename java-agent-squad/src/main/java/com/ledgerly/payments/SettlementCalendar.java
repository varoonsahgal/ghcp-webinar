package com.ledgerly.payments;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/** Trades settle T+2 business days. Weekends are not business days. */
public class SettlementCalendar {

    private static final SimpleDateFormat FMT = new SimpleDateFormat("EEE yyyy-MM-dd");

    public Date settlementDate(Date tradeDate) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(tradeDate);
        cal.add(Calendar.DAY_OF_MONTH, 2);
        if (cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY) {
            cal.add(Calendar.DAY_OF_MONTH, 1);
        }
        return cal.getTime();
    }

    public static String format(Date date) {
        return FMT.format(date);
    }
}

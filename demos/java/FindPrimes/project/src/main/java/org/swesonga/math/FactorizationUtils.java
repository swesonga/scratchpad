package org.swesonga.math;

import java.math.BigInteger;
import java.text.SimpleDateFormat;
import java.util.Date;

public class FactorizationUtils {
    final static BigInteger ZERO = BigInteger.ZERO;
    final static BigInteger ONE = BigInteger.ONE;
    final static BigInteger TWO = BigInteger.TWO;
    final static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss ");

    static int countTrailingZeros(BigInteger number) {
        // Handle special case
        if (number.compareTo(BigInteger.ZERO) == 0) {
            return 0;
        }

        int zeros = 0;

        while (number.remainder(TWO).compareTo(ZERO) == 0) {
            zeros++;
            number = number.divide(TWO);
        }

        return zeros;
    }

    static BigInteger computeMaxPower(BigInteger a, BigInteger b)
    {
        BigInteger power = ZERO;

        if (a.compareTo(ZERO) == 1 && b.compareTo(ZERO) == 1) {
            // A binary search approach would be more efficient
            while (a.remainder(b).compareTo(ZERO) == 0) {
                power = power.add(ONE);
                a = a.divide(b);
            }
        }

        return power;
    }

    static void printDate()
    {
        String formattedDate = dateFormat.format(new Date(System.currentTimeMillis()));
        System.out.print(formattedDate);
    }

    static synchronized void logMessage(String message, boolean showThreadId)
    {
        printDate();
        
        if (showThreadId) {
            message = "tid " + Thread.currentThread().getId() + " " + message;
        }
        System.out.println(message);
    }

    static void logMessage(String message)
    {
        logMessage(message, true);
    }
}
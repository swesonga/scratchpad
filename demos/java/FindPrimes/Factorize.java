/*
 * Simple class for factorizing arbitrarily large natural numbers.
 * This program is useful for exploring performance monitoring tools
 * using a simple app that does something non-trivial.
 *
 * Author: Saint Wesonga
 *
 *  javac Factorize.java
 *
 * Sample Usage:
 *
 *  java Factorize 65
 *  java Factorize 438880205542
 *  java Factorize 43888020554297731
 *  java Factorize 4388802055429773100203726550535118822125
 */
import java.math.BigInteger;

public class Factorize {
    final static BigInteger ZERO = BigInteger.ZERO;
    final static BigInteger ONE = BigInteger.ONE;
    final static BigInteger TWO = BigInteger.TWO;

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

    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("Usage: Factorize [Number]");
            return;
        }

        // Ingore possibility of invalid or negative numbers
        BigInteger number;

        try {
            number = new BigInteger(args[0]);
        }
        catch (NumberFormatException nfe) {
            System.err.println("The specified number must be a valid base 10 number.");
            return;
        }

        if (number.compareTo(TWO) < 1) {
            System.err.println("The specified number must be greater than 2.");
            return;
        }

        long factors = 0;
        int trailingZeros = countTrailingZeros(number);
        if (trailingZeros > 0) {
            number = number.divide(TWO.pow(trailingZeros));
            System.out.println("Found a factor: 2^{" + trailingZeros + "}");

            if (number.compareTo(ONE) == 0) {
                return;
            }

            factors++;
        }

        var sqrt = number.sqrt();
        BigInteger i = ONE.add(TWO);

        while (true) {
            if (number.remainder(i).compareTo(ZERO) == 0) {
                factors++;
                var maxPowerOfi = computeMaxPower(number, i);
                System.out.println("Found a factor: " + i + "^{" + maxPowerOfi + "} of " + number);
                number = number.divide(maxPowerOfi);
            }

            if (i.compareTo(sqrt) >= 0) {
                break;
            }

            i = i.add(TWO);
        }

        System.out.println("Number of prime bases found: " + factors);
    }
}
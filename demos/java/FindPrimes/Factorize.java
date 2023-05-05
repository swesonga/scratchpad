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
 *
 * BigInteger documentation:
 *
 *  https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/math/BigInteger.html
 *
 */
import java.math.BigInteger;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Factorize {
    final static BigInteger ZERO = BigInteger.ZERO;
    final static BigInteger ONE = BigInteger.ONE;
    final static BigInteger TWO = BigInteger.TWO;

    BigInteger input, inputSqrt, sqrt;
    // Biggest factor of the input still to be factorized by this Runnable
    BigInteger number;

    // Next prime factor candidate
    BigInteger i;

    long divisibilityTests;

    public long factors;

    public Factorize(BigInteger input) {
        this.input = input;
        this.number = input;
        inputSqrt = input.sqrt();
        sqrt = inputSqrt;
        this.i = ONE;
    }

    public void ExtractLargestPowerOf2() {
        int trailingZeros = FactorizationUtils.countTrailingZeros(input);
        if (trailingZeros > 0) {
            FactorizationUtils.logMessage("Found a factor: 2^{" + trailingZeros + "} of " + number);
            number = number.divide(TWO.pow(trailingZeros));

            factors++;
        }
    }

    public BigInteger GetNextPrimeFactorCandidate() {
        i = i.add(TWO);
        return i;
    }

    public void IncrementDivisibilityTests() {
        divisibilityTests++;
    }

    public void RunFactorization() {

        FactorizationUtils.logMessage("Testing divisibility by odd numbers up to floor(sqrt(" + input + ")) = " + sqrt);
        long progressMsgFrequency = 1L << 0;

        i = GetNextPrimeFactorCandidate();

        while (i.compareTo(sqrt) <= 0) {
            if (divisibilityTests % progressMsgFrequency == 0) {
                FactorizationUtils.logMessage("Testing divisibility by " + i);
            }

            if (number.remainder(i).compareTo(ZERO) == 0) {
                factors++;
                var maxPowerOfi = FactorizationUtils.computeMaxPower(number, i);
                FactorizationUtils.logMessage("Found a factor: " + i + "^{" + maxPowerOfi + "} of " + number);
                number = number.divide(i.pow(maxPowerOfi.intValue()));
                sqrt = number.sqrt();
            }

            i = GetNextPrimeFactorCandidate();
            IncrementDivisibilityTests();
        }
    }

    public void LogCompletion() {
        if (factors == 0) {
            FactorizationUtils.logMessage(input + " is prime.\n");
        }
        else {
            long totalPrimeFactors = factors;
            if (number.compareTo(ONE) == 1) {
                totalPrimeFactors++;
            }

            FactorizationUtils.logMessage("Completed with number = " + number);

            FactorizationUtils.logMessage(input + " is composite. Found " + totalPrimeFactors + " prime factors (" + factors
                                + ") of which are less than or equal to floor(sqrt(" + input + ")) = "
                                + inputSqrt + "\n");
        }
    }

    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("Usage: Factorize [Number [Threads]]");
            return;
        }

        BigInteger input;

        try {
            input = new BigInteger(args[0]);
        }
        catch (NumberFormatException nfe) {
            System.err.println("Error: " + args[0] + " is not a valid base 10 number.");
            return;
        }

        if (input.compareTo(TWO) < 1) {
            System.err.println("The specified number must be greater than 2.");
            return;
        }

        var factorize = new Factorize(input);
        factorize.ExtractLargestPowerOf2();
        factorize.RunFactorization();
        factorize.LogCompletion();
    }
}
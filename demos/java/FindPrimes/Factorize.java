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
 *  java Factorize 42039582593802342572091
 *
 * BigInteger documentation:
 *
 *  https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/math/BigInteger.html
 *
 */
import java.math.BigInteger;
import java.text.SimpleDateFormat;
import java.util.concurrent.atomic.AtomicLong;
import java.util.ArrayList;
import java.util.Date;

public class Factorize implements Runnable {
    final static BigInteger ZERO = BigInteger.ZERO;
    final static BigInteger ONE = BigInteger.ONE;
    final static BigInteger TWO = BigInteger.TWO;

    BigInteger input, inputSqrt, sqrt;
    // Biggest factor of the input still to be factorized by this Runnable
    BigInteger number;

    // Next prime factor candidate
    BigInteger nextPrimeFactorCandidate;

    AtomicLong divisibilityTests;

    private long factors;
    private long progressMsgFrequency = 1L << 31;

    public Factorize(BigInteger input) {
        this.input = input;
        this.number = input;
        inputSqrt = input.sqrt();
        sqrt = inputSqrt;
        this.nextPrimeFactorCandidate = ONE;
        this.divisibilityTests = new AtomicLong();
    }

    public void ExtractLargestPowerOf2() {
        int trailingZeros = FactorizationUtils.countTrailingZeros(input);
        if (trailingZeros > 0) {
            FactorizationUtils.logMessage("Found a factor: 2^{" + trailingZeros + "} of " + number);
            number = number.divide(TWO.pow(trailingZeros));

            factors++;
        }
    }

    public synchronized BigInteger GetNextPrimeFactorCandidate() {
        nextPrimeFactorCandidate = nextPrimeFactorCandidate.add(TWO);
        return nextPrimeFactorCandidate;
    }

    public void StartFactorization(int numThreads) throws InterruptedException {
        FactorizationUtils.logMessage("Testing divisibility by odd numbers up to floor(sqrt(" + input + ")) = " + sqrt);

        var threads = new ArrayList<Thread>();

        for (int i = 0; i < numThreads; i++) {
            var thread = new Thread(this);
            threads.add(thread);

            thread.start();
        }

        for (int i = 0; i < numThreads; i++) {
            threads.get(i).join();
        }

        LogCompletion();
    }

    public void run() {

        BigInteger i = GetNextPrimeFactorCandidate();

        while (i.compareTo(sqrt) <= 0) {
            if (divisibilityTests.getAndIncrement() % progressMsgFrequency == 0) {
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

    public static void main(String[] args) throws InterruptedException {
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

        int threads = 1;
        if (args.length > 1) {
            try {
                threads = Integer.parseInt(args[1]);
            }
            catch (NumberFormatException nfe) {
                System.err.println("Error: " + args[1] + " is not a valid number of threads.");
                return;
            }
        }

        var factorize = new Factorize(input);
        factorize.ExtractLargestPowerOf2();
        factorize.StartFactorization(threads);
    }
}
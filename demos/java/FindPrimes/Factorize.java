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
 *  java Factorize 42039582593802342572091 6
 *
 * BigInteger documentation:
 *
 *  https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/math/BigInteger.html
 *
 */
import java.math.BigInteger;
import java.text.SimpleDateFormat;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.Executors;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.ArrayList;
import java.util.Date;

public class Factorize implements Runnable {
    final static BigInteger ZERO = BigInteger.ZERO;
    final static BigInteger ONE = BigInteger.ONE;
    final static BigInteger TWO = BigInteger.TWO;

    final static int USE_EXECUTOR = 1;

    BigInteger input, inputSqrt, sqrt;
    // Biggest factor of the input still to be factorized by this Runnable
    BigInteger largestUnfactorizedDivisor;

    // Next prime factor candidate
    BigInteger nextPrimeFactorCandidate;

    AtomicLong divisibilityTests;

    private AtomicLong factors;
    private long progressMsgFrequency = 1L << 31;

    private enum ExecutionMode {
        SINGLE_THREAD,
        CUSTOM_THREAD_COUNT_VIA_THREAD_CLASS,
        CUSTOM_THREAD_COUNT_VIA_EXECUTOR_SERVICE,
    }

    public Factorize(BigInteger input) {
        this.input = input;
        this.largestUnfactorizedDivisor = input;
        inputSqrt = input.sqrt();
        sqrt = inputSqrt;
        this.nextPrimeFactorCandidate = ONE;
        this.divisibilityTests = new AtomicLong();
        this.factors = new AtomicLong();
    }

    public void ExtractLargestPowerOf2() {
        int trailingZeros = FactorizationUtils.countTrailingZeros(input);
        if (trailingZeros > 0) {
            FactorizationUtils.logMessage("Found a factor: 2^{" + trailingZeros + "} of " + input);
            largestUnfactorizedDivisor = largestUnfactorizedDivisor.divide(TWO.pow(trailingZeros));

            factors.getAndIncrement();
        }
    }

    public synchronized BigInteger GetNextPrimeFactorCandidate() {
        nextPrimeFactorCandidate = nextPrimeFactorCandidate.add(TWO);
        return nextPrimeFactorCandidate;
    }

    public synchronized BigInteger getLargestUnfactorizedDivisor() {
        return largestUnfactorizedDivisor;
    }

    public synchronized BigInteger DivideFactor(BigInteger factor) {
        largestUnfactorizedDivisor = largestUnfactorizedDivisor.divide(factor);
        sqrt = largestUnfactorizedDivisor.sqrt();

        return largestUnfactorizedDivisor;
    }

    private void LaunchThreadsManually(int numThreads) throws InterruptedException {
        var threads = new ArrayList<Thread>();

        for (int i = 0; i < numThreads; i++) {
            var thread = new Thread(this);
            threads.add(thread);

            thread.start();
        }

        for (int i = 0; i < numThreads; i++) {
            var thread = threads.get(i);
            thread.join();
        }
    }

    private void LaunchThreadsViaExecutor(int numThreads) throws InterruptedException {
        ExecutorService pool = Executors.newFixedThreadPool(numThreads);

        for (int i = 0; i < numThreads; i++) {
            pool.execute(this);
        }

        pool.awaitTermination(365 * 24 * 3600, TimeUnit.SECONDS);
        pool.shutdown();
    }

    public void StartFactorization(int numThreads, ExecutionMode executionMode) throws InterruptedException {
        FactorizationUtils.logMessage("Testing divisibility by odd numbers up to floor(sqrt(" + input + ")) = " + sqrt);

        switch (executionMode) {
            case SINGLE_THREAD:
                FactorizationUtils.logMessage("Using main thread to run tasks.");
                run();
                break;
            case CUSTOM_THREAD_COUNT_VIA_EXECUTOR_SERVICE:
                FactorizationUtils.logMessage("Using executor service to run tasks.");
                LaunchThreadsViaExecutor(numThreads);
                break;
            case CUSTOM_THREAD_COUNT_VIA_THREAD_CLASS:
                FactorizationUtils.logMessage("Using Thread.start to run tasks.");
                LaunchThreadsManually(numThreads);
                break;
        }

        LogCompletion();
    }

    public void run() {

        BigInteger i = GetNextPrimeFactorCandidate();

        while (i.compareTo(sqrt) <= 0) {
            boolean showPeriodicMessages = divisibilityTests.getAndIncrement() % progressMsgFrequency == 0;
            if (showPeriodicMessages) {
                FactorizationUtils.logMessage("Testing divisibility by " + i);
            }

            BigInteger number = getLargestUnfactorizedDivisor();

            if (number.remainder(i).compareTo(ZERO) == 0) {
                factors.getAndIncrement();
                var maxPowerOfi = FactorizationUtils.computeMaxPower(number, i);
                var factor = i.pow(maxPowerOfi.intValue());
                BigInteger oldNumber = number;
                number = DivideFactor(factor);
                FactorizationUtils.logMessage("Found a factor: " + i + "^{" + maxPowerOfi + "} = " + factor + " of " + oldNumber + ". Number is now " + number);
            }

            i = GetNextPrimeFactorCandidate();
            if (showPeriodicMessages) {
                FactorizationUtils.logMessage("Next prime factor candidate: " + i);
            }
        }

        FactorizationUtils.logMessage("Thread complete.");
    }

    public void LogCompletion() {
        if (factors.get() == 0) {
            FactorizationUtils.logMessage(input + " is prime.\n");
        }
        else {
            long totalPrimeFactors = factors.get();
            if (largestUnfactorizedDivisor.compareTo(ONE) == 1) {
                totalPrimeFactors++;
            }

            FactorizationUtils.logMessage("Completed with largestUnfactorizedDivisor = " + largestUnfactorizedDivisor);

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

        ExecutionMode executionMode = ExecutionMode.SINGLE_THREAD;
        if (args.length > 1) {
            var executionModeAsStr = args[1];
            try {
                executionMode = ExecutionMode.valueOf(executionModeAsStr);
            }
            catch (IllegalArgumentException ex) {
                System.err.println("Error: " + executionModeAsStr + " is not a valid execution mode.");
                return;
            }

            if (executionMode != ExecutionMode.SINGLE_THREAD && args.length > 2) {
                var threadsAsStr = args[2];
                try {
                    threads = Integer.parseInt(threadsAsStr);
                    System.out.println("Using " + threads + " threads.");
                }
                catch (NumberFormatException nfe) {
                    System.err.println("Error: " + threadsAsStr + " is not a valid number of threads.");
                    return;
                }
            }
        }

        var factorize = new Factorize(input);
        factorize.ExtractLargestPowerOf2();

        factorize.StartFactorization(threads, executionMode);
    }
}
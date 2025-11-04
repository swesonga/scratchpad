/*
 * Standalone test for MonitorEnterExit.testMutualExclusion
 * Extracted from MonitorEnterExit.java to run without JUnit dependencies
 */

/*
export JAVA_HOME=/c/java/binaries/jdk/aarch64/2025-10/windows-jdk25u/jdk-25.0.1+8/
export JAVA_HOME=/c/java/binaries/jdk/aarch64/2025-09/windows-jdk25u/jdk-25+36/
$JAVA_HOME/bin/javac StandaloneMutualExclusionTest.java
$JAVA_HOME/bin/java StandaloneMutualExclusionTest --all
*/

public class StandaloneMutualExclusionTest {
    /**
     * Test mutual exclusion of monitors with platform and virtual threads.
     * This is the core test from MonitorEnterExit.testMutualExclusion
     */
    static void testMutualExclusion(int nPlatformThreads, int nVirtualThreads) throws Exception {
        System.out.printf("Testing with %d platform threads and %d virtual threads%n", 
                          nPlatformThreads, nVirtualThreads);

        class Counter {
            int count;
            synchronized void increment() {
                count++;
                Thread.yield();
            }
        }

        var counter = new Counter();
        int nThreads = nPlatformThreads + nVirtualThreads;
        var threads = new Thread[nThreads];
        int index = 0;

        // Create platform threads
        for (int i = 0; i < nPlatformThreads; i++) {
            threads[index] = Thread.ofPlatform()
                    .name("platform-" + index)
                    .unstarted(counter::increment);
            index++;
        }

        // Create virtual threads  
        for (int i = 0; i < nVirtualThreads; i++) {
            threads[index] = Thread.ofVirtual()
                    .name("virtual-" + index)
                    .unstarted(counter::increment);
            index++;
        }

        // Start all threads
        for (Thread thread : threads) {
            thread.start();
        }

        // Wait for all threads to terminate
        for (Thread thread : threads) {
            thread.join();
        }

        // Verify mutual exclusion worked correctly
        if (counter.count != nThreads) {
            throw new RuntimeException(String.format(
                "Expected count %d but got %d - mutual exclusion failed!", 
                nThreads, counter.count));
        }

        System.out.printf("✓ Success: All %d threads completed, counter = %d%n", 
                          nThreads, counter.count);
    }

    /**
     * Generate test cases - same logic as the original threadCounts() method
     * 0,2,4,..16 platform threads. 2,4,6,..32 virtual threads.
     */
    static void runAllTestCases() throws Exception {
        System.out.println("Running mutual exclusion tests...");

        int testCount = 0;
        int passCount = 0;

        for (int np = 0; np <= 16; np += 2) {  // 0,2,4,...,16 platform threads
            for (int nv = 2; nv <= 32; nv += 2) {  // 2,4,6,...,32 virtual threads
                testCount++;
                try {
                    testMutualExclusion(np, nv);
                    passCount++;
                } catch (Exception e) {
                    System.err.printf("✗ FAILED: testMutualExclusion(%d, %d) - %s%n", 
                                     np, nv, e.getMessage());
                    e.printStackTrace();
                }
            }
        }

        System.out.printf("%nTest Results: %d/%d passed%n", passCount, testCount);
        if (passCount != testCount) {
            System.exit(1);  // Exit with error code if any tests failed
        }
    }

    /**
     * Run a smaller subset of tests for quick verification
     */
    static void runQuickTests() throws Exception {
        System.out.println("Running quick mutual exclusion tests...");

        // Test a few representative cases
        int[][] testCases = {
            {0, 2},   // Only virtual threads
            {2, 0},   // Only platform threads  
            {2, 2},   // Mixed
            {4, 8},   // More virtual threads
            {8, 4},   // More platform threads
            {0, 16},  // Many virtual threads
            {8, 16}   // Mixed with many threads
        };

        int testCount = 0;
        int passCount = 0;

        for (int[] testCase : testCases) {
            int np = testCase[0];
            int nv = testCase[1];
            testCount++;

            try {
                testMutualExclusion(np, nv);
                passCount++;
            } catch (Exception e) {
                System.err.printf("✗ FAILED: testMutualExclusion(%d, %d) - %s%n", 
                                 np, nv, e.getMessage());
                e.printStackTrace();
            }
        }

        System.out.printf("%nQuick Test Results: %d/%d passed%n", passCount, testCount);
        if (passCount != testCount) {
            System.exit(1);
        }
    }

    public static void main(String[] args) throws Exception {
        System.out.println("Standalone Mutual Exclusion Test");
        System.out.println("Java Version: " + System.getProperty("java.version"));
        System.out.println("OS: " + System.getProperty("os.name") + " " + System.getProperty("os.arch"));

        // Print JVM flags that might be relevant
        String vmArgs = System.getProperty("java.vm.name") + " " + 
                        System.getProperty("java.vm.version");
        System.out.println("JVM: " + vmArgs);

        // Check command line arguments
        boolean runAll = args.length > 0 && args[0].equals("--all");

        if (args.length > 0 && !args[0].equals("--all") && !args[0].equals("--quick")) {
            System.out.println("Usage: java StandaloneMutualExclusionTest [--quick|--all]");
            System.out.println("  --quick: Run a small subset of test cases (default)");
            System.out.println("  --all:   Run all possible test case combinations");
            System.exit(1);
        }

        try {
            long startTime = System.currentTimeMillis();

            if (runAll) {
                runAllTestCases();
            } else {
                runQuickTests();
            }

            long duration = System.currentTimeMillis() - startTime;
            System.out.printf("All tests completed successfully in %d ms%n", duration);

        } catch (Exception e) {
            System.err.println("Test execution failed: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}
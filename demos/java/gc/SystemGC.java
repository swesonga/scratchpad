/**
 * $JAVA_HOME/bin/javac -d . SystemGC.java
 * $JAVA_HOME/bin/java SystemGC 1000 5
 * export CURRDATE=`date +%Y-%m-%d_%H%M%S`; time $JAVA_HOME/bin/java -Xmx2g -XX:+UseSerialGC -XX:+UseCompressedOops -XX:HeapBaseMinAddress=0x120000000000 -Xint -Xlog:gc*=debug,safepoint:file=serialgc.$CURRDATE.log::filecount=0 -Xlog:pagesize=trace:file=pagesize.$CURRDATE.txt::filecount=0 -Xlog:os=trace:file=os.$CURRDATE.txt::filecount=0 SystemGC 1000 5
 *
 * Java Commands:
 * 
 *  https://docs.oracle.com/en/java/javase/17/docs/specs/man/javac.html
 *  https://docs.oracle.com/en/java/javase/17/docs/specs/man/java.html
 */

public class SystemGC {

    public static void main(String[] args) throws InterruptedException {
        int interval_millis = 5000;
        int iterations = Integer.MAX_VALUE;

        if (args.length > 0) {
            try {
                interval_millis = Integer.parseInt(args[0]);
            }
            catch (NumberFormatException nfe) {
                System.err.println("Error: " + args[0] + " is not a valid sleep interval.");
                return;
            }
        }

        if (args.length > 1) {
            try {
                iterations = Integer.parseInt(args[1]);
            }
            catch (NumberFormatException nfe) {
                System.err.println("Error: " + args[1] + " is not a valid iteration count.");
                return;
            }
        }

        System.out.printf("Running %d System.gc() iterations with %d ms pauses in between...", iterations, interval_millis);

        for (int i = 0; i < iterations; i++) {
            System.gc();
            Thread.sleep(interval_millis);
        }
    }
}

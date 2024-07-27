/**
export JAVA_HOME=~/java/binaries/jdk/x64/jdk-21.0.2+13
$JAVA_HOME/bin/javac CopyArray.java
$JAVA_HOME/bin/java CopyArray
 */

public class CopyArray {
    public static void main(String[] args) {
        int length = 0xdead;
        int srcPos = 0;

        if (args.length > 0) {
            try {
                int userLength = Integer.parseInt(args[0]);
                length = userLength;
            }
            catch (Throwable e) {
                System.err.println("Ignoring invalid user arguments.");
            }
        }

        Object[] src = new Object[length];
        Object[] dest = new Object[length];

        for (int i = 0; i < src.length; i++) {
            src[i] = new Object();
        }

        System.arraycopy(src, srcPos, dest, 0, length);
    }
}
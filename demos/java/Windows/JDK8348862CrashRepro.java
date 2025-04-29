/*
  export JAVA_HOME=~/java/binaries/jdk/aarch64/jdk-23.0.2+7/
  export JAVA_HOME=/c/java/forks/openjdk/jdk/build/windows-aarch64-server-slowdebug/images/jdk
  $JAVA_HOME/bin/javac JDK8348862CrashRepro.java
  export CURRDATE=`date +%Y-%m-%d_%H%M%S`; time $JAVA_HOME/bin/java -Xlog:gc*=debug,safepoint:file=gc.$CURRDATE.log::filecount=0 -Xlog:pagesize=trace:file=pagesize.$CURRDATE.txt::filecount=0 -Xlog:os=trace:file=os.$CURRDATE.txt::filecount=0 JDK8348862CrashRepro
 */

/*
  set JAVA_HOME=C:/java/binaries/jdk/aarch64/jdk-23.0.2+7
  %JAVA_HOME%/bin/javac JDK8348862CrashRepro.java
  %JAVA_HOME%/bin/java JDK8348862CrashRepro
 */

import sun.misc.Unsafe;
import java.lang.reflect.Field;

public class JDK8348862CrashRepro {
    public static void main(String... args) throws Exception {
        if (args.length > 0) {
            System.out.println("Crash:");
            getUnsafe().putInt(0L, 0);
        }
        System.out.println("Didn't crash!");
    }

    private static Unsafe getUnsafe() throws NoSuchFieldException, IllegalAccessException {
        Field theUnsafe = Unsafe.class.getDeclaredField("theUnsafe");
        theUnsafe.setAccessible(true);
        return (Unsafe) theUnsafe.get(null);
    }
}

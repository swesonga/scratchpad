/*
  export JAVA_HOME=/c/java/binaries/jdk/aarch64/2026-01/windows-jdk25u/jdk-25.0.2+10
  export JAVA_HOME=/d/java/binaries/jdk/x64/2026-01/windows-jdk25u/jdk-25.0.2+10
  $JAVA_HOME/bin/javac GetTempPath2.java
  $JAVA_HOME/bin/java GetTempPath2
 */

/*
  set JAVA_HOME=D:/java/binaries/jdk/x64/2026-01/windows-jdk25u/jdk-25.0.2+10
  %JAVA_HOME%/bin/javac GetTempPath2.java
  %JAVA_HOME%/bin/java GetTempPath2
 */

/*
Download pstools from https://learn.microsoft.com/en-us/sysinternals/downloads/pstools
psexec -s -i cmd.exe
*/

public class GetTempPath2 {
    public static void main (String[] args) {  
         System.out.println("java.io.tmpdir: " + System.getProperty("java.io.tmpdir"));
    }
}

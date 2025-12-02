
export JAVA_HOME24=/c/java/binaries/jdk/aarch64/2025-07/windows-jdk24u/jdk-24.0.2+12
export JAVA_HOME25=/c/java/binaries/jdk/aarch64/2025-09/windows-jdk25u/jdk-25+36
export JAVA_HOME=/c/java/binaries/jdk/aarch64/2025-10/windows-jdk25u/jdk-25.0.1+8
export JAVA_HOME_FORKS=/c/java/forks/openjdk/jdk/build/windows-aarch64-server-slowdebug/images/jdk
export JAVA_HOME_FORKS_DUPS=/c/java/forks/dups/openjdk/jdk/build/windows-aarch64-server-slowdebug/images/jdk
export JAVA_HOME_FORKS_DUPS3=/c/java/forks/dups3/openjdk/jdk/build/windows-aarch64-server-slowdebug/images/jdk
export JAVA_HOME_FORKS_DUPS4=/c/java/forks/dups4/openjdk/jdk/build/windows-aarch64-server-slowdebug/images/jdk
export JAVA_HOME_MS_JDK25U=/c/java/ms/openjdk-jdk25u/build/windows-aarch64-server-slowdebug/images/jdk
export JAVA_HOME_LOCAL=/c/java/binaries/jdk/aarch64/local/jdk-windows-aarch64-server-release-2025-10-01_130524

$JAVA_HOME/bin/javac StandaloneMutualExclusionTest.java
$JAVA_HOME/bin/java -XX:+CreateCoredumpOnCrash StandaloneMutualExclusionTest

$JAVA_HOME/bin/jcmd
$JAVA_HOME/bin/jstack -l -e <pid>

/c/software/visualvm_22/bin/visualvm.exe

export CURRDATE=`date +%Y-%m-%d_%H%M%S`; date; \
time $JAVA_HOME/bin/java \
  -Xcomp \
  -XX:TieredStopAtLevel=1 \
  -XX:LockingMode=2 \
  -Xlog:monitorinflation=debug,continuations=debug:deadlock.$CURRDATE.txt:time,pid,tid,level \
  -Xlog:os=info:file=os.$CURRDATE.txt::filecount=0 \
  -Xlog:os+thread=info:file=os+thread.$CURRDATE.txt::filecount=0 \
  -XX:+UnlockDiagnosticVMOptions \
  -XX:+JavaMonitorsInStackTrace \
  -XX:LightweightFastLockingSpins=1 \
  -XX:+CreateCoredumpOnCrash \
  -XX:+UseSerialGC \
  StandaloneMutualExclusionTest 0 2 --printCount --yield

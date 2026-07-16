export OS=macosx
export PATHPREFIX=~
export JDKSRCPATH=$PATHPREFIX/java/forks/openjdk/jdk/
export DEBUGLEVEL=slowdebug
export JDKARCH=aarch64
export JDKBUILDPATH="${JDKSRCPATH}/build/${OS}-${JDKARCH}-server-${DEBUGLEVEL}"
export JDKTOTEST="${JDKBUILDPATH}/images/jdk"
export JTREGNATIVEPATH1="${JDKBUILDPATH}/support/test/hotspot/jtreg/native/lib"
export JTREGNATIVEPATH2="${JDKBUILDPATH}/support/test/jdk/jtreg/native/lib"
export JTREGNATIVEPATH3="${JDKBUILDPATH}/support/test/lib/native/lib"
export GTEST_NATIVEPATH="${JDKBUILDPATH}/images/test/hotspot/gtest"
export GTESTPATH="${GTEST_NATIVEPATH}/server"
export JTREGBINPATH=$PATHPREFIX/java/binaries/jtreg/jtreg-8.3+1
export TESTTORUN=test/hotspot/jtreg/compiler/c2/aarch64/TestTrampoline.java

./run-jtreg-test.sh $JDKSRCPATH $JDKTOTEST $JTREGBINPATH/lib/jtreg.jar $TESTTORUN -nativepath:$JTREGNATIVEPATH1

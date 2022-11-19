#!/bin/bash
#
# Run the foreign function & memory API jtreg tests.
#
# To download jtreg, run this command:
#
#  curl -Lo jtreg-7+1.tar.gz https://ci.adoptopenjdk.net/view/Dependencies/job/dependency_pipeline/lastSuccessfulBuild/artifact/jtreg/jtreg-7+1.tar.gz
#
# To build the artifacts, run this script from the root of the JDK repo:
#
#  /Users/saint/repos/scratchpad/scripts/java/cygwin/build-aarch64.sh
#
# To run the foreign function & memory tests, use a command line similar to this one:
#
#  time ./run-foreign-abi-tests.sh /Users/saint/repos/java/forks/panama-foreign /Users/saint/repos/java/infra/bin/jtreg /Users/saint/repos/java/forks/panama-foreign/build/macosx-aarch64-server-release
#  time ./run-foreign-abi-tests.sh ~/java/forks/panama-foreign ~/java/binaries/jtreg7 ~/java/forks/panama-foreign/build/linux-x86_64-server-slowdebug
#  time ./run-foreign-abi-tests.sh /d/java/forks/panama-foreign /d/java/binaries/jtreg7 /d/java/forks/panama-foreign/build/windows-x86_64-server-slowdebug
#

jdk_repo=$1
jtreg_path=$2
jdk_artifacts=$3

cd $jdk_repo

declare -a java_foreign_tests=(
 "test/jdk/java/foreign/callarranger/TestAarch64CallArranger.java"
 "test/jdk/java/foreign/callarranger/TestSysVCallArranger.java"
 "test/jdk/java/foreign/callarranger/TestWindowsCallArranger.java"
 "test/jdk/java/foreign/stackwalk/TestStackWalk.java"
 "test/jdk/java/foreign/StdLibTest.java"
 "test/jdk/java/foreign/TestAdaptVarHandles.java"
 "test/jdk/java/foreign/TestArrays.java"
 "test/jdk/java/foreign/TestByteBuffer.java"
 "test/jdk/java/foreign/TestFree.java"
 "test/jdk/java/foreign/TestFunctionDescriptor.java"
 "test/jdk/java/foreign/TestHandshake.java"
 "test/jdk/java/foreign/TestIllegalLink.java"
 "test/jdk/java/foreign/TestIntrinsics.java"
 "test/jdk/java/foreign/TestLayoutEquality.java"
 "test/jdk/java/foreign/TestLayoutPaths.java"
 "test/jdk/java/foreign/TestLayouts.java"
 "test/jdk/java/foreign/TestMemoryAccess.java"
 "test/jdk/java/foreign/TestMemoryAlignment.java"
 "test/jdk/java/foreign/TestMismatch.java"
 "test/jdk/java/foreign/TestNative.java"
 "test/jdk/java/foreign/TestNoForeignUnsafeOverride.java"
 "test/jdk/java/foreign/TestNulls.java"
 "test/jdk/java/foreign/TestReshape.java"
 "test/jdk/java/foreign/TestSegments.java"
 "test/jdk/java/foreign/TestSharedAccess.java"
 "test/jdk/java/foreign/TestSlices.java"
 "test/jdk/java/foreign/TestSpliterator.java"
 "test/jdk/java/foreign/TestTypeAccess.java"
 "test/jdk/java/foreign/TestUpcallHighArity.java"
 "test/jdk/java/foreign/TestVarArgs.java"
 "test/jdk/java/foreign/TestVarHandleCombinators.java"
 "test/jdk/java/foreign/valist/VaListTest.java"
)

echo "java version launching jtreg:"
java -version

# https://stackoverflow.com/questions/8880603/loop-through-an-array-of-strings-in-bash
for java_test in "${java_foreign_tests[@]}"
do
    java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -testjdk:$jdk_artifacts/jdk -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib $java_test
done

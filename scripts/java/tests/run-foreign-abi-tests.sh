#!/bin/bash
#
# Run the foreign function & memory API jtreg tests.
#
# To download and set up jtreg, run these commands:
#
#  curl -Lo jtreg-7.1.1+1.tar.gz https://ci.adoptopenjdk.net/view/Dependencies/job/dependency_pipeline/lastSuccessfulBuild/artifact/jtreg/jtreg-7.1.1+1.tar.gz
#  tar xzf jtreg-7.1.1+1.tar.gz
#  cp -r jtreg jtreg-7.1.1+1
#
# To build the artifacts, run this script from the root of the JDK repo:
#
#  /Users/saint/repos/scratchpad/scripts/java/cygwin/build-jdk.sh
#
# To see the tests and the test subdirectories:
#
#  cd /Users/saint/repos/java/forks/panama-foreign/test/jdk/java/foreign
#  ls -1 *Test*.java
#  ls -1d */
#
# To run the foreign function & memory tests, use a command line similar to this one:
#
#  time ./run-foreign-abi-tests.sh /Users/saint/repos/java/forks/panama-foreign /Users/saint/repos/java/infra/bin/jtreg /Users/saint/repos/java/forks/panama-foreign/build/macosx-aarch64-server-release
#  time ./run-foreign-abi-tests.sh  ~/repos/java/forks/panama-foreign ~/repos/java/infra/bin/jtreg ~/repos/java/forks/panama-foreign/build/macosx-aarch64-server-release
#
#  time ./run-foreign-abi-tests.sh ~/java/forks/panama-foreign ~/java/binaries/jtreg7 ~/java/forks/panama-foreign/build/linux-x86_64-server-slowdebug
#  time ./run-foreign-abi-tests.sh /d/java/forks/panama-foreign /d/java/binaries/jtreg-7.1.1+1 /d/java/forks/panama-foreign/build/windows-x86_64-server-slowdebug
#

jdk_repo=$1
jtreg_path=$2
jdk_artifacts=$3

cd $jdk_repo

declare -a java_foreign_tests=(
 "test/jdk/java/foreign/callarranger/TestLinuxAarch64CallArranger.java"
 "test/jdk/java/foreign/callarranger/TestMacOsAarch64CallArranger.java"
 "test/jdk/java/foreign/callarranger/TestWindowsAarch64CallArranger.java"
 "test/jdk/java/foreign/callarranger/TestSysVCallArranger.java"
 "test/jdk/java/foreign/callarranger/TestWindowsCallArranger.java"
 "test/jdk/java/foreign/stackwalk/TestStackWalk.java"
 "test/jdk/java/foreign/LibraryLookupTest.java"
 "test/jdk/java/foreign/MemoryLayoutPrincipalTotalityTest.java"
 "test/jdk/java/foreign/MemoryLayoutTypeRetentionTest.java"
 "test/jdk/java/foreign/SafeFunctionAccessTest.java"
 "test/jdk/java/foreign/StdLibTest.java"
 "test/jdk/java/foreign/TestAdaptVarHandles.java"
 "test/jdk/java/foreign/TestArrayCopy.java"
 "test/jdk/java/foreign/TestArrays.java"
 "test/jdk/java/foreign/TestByteBuffer.java"
 "test/jdk/java/foreign/TestClassLoaderFindNative.java"
 "test/jdk/java/foreign/TestDowncallBase.java"
 "test/jdk/java/foreign/TestDowncallScope.java"
 "test/jdk/java/foreign/TestDowncallStack.java"
 "test/jdk/java/foreign/TestFallbackLookup.java"
 "test/jdk/java/foreign/TestFree.java"
 "test/jdk/java/foreign/TestFunctionDescriptor.java"
 "test/jdk/java/foreign/TestHandshake.java"
 "test/jdk/java/foreign/TestHeapAlignment.java"
 "test/jdk/java/foreign/TestIllegalLink.java"
 "test/jdk/java/foreign/TestIntrinsics.java"
 "test/jdk/java/foreign/TestLargeSegmentCopy.java"
 "test/jdk/java/foreign/TestLayoutEquality.java"
 "test/jdk/java/foreign/TestLayoutPaths.java"
 "test/jdk/java/foreign/TestLayouts.java"
 "test/jdk/java/foreign/TestLinker.java"
 "test/jdk/java/foreign/TestMatrix.java"
 "test/jdk/java/foreign/TestMemoryAccess.java"
 "test/jdk/java/foreign/TestMemoryAccessInstance.java"
 "test/jdk/java/foreign/TestMemoryAlignment.java"
 "test/jdk/java/foreign/TestMemoryDereference.java"
 "test/jdk/java/foreign/TestMemoryInspection.java"
 "test/jdk/java/foreign/TestMemorySession.java"
 "test/jdk/java/foreign/TestMismatch.java"
 "test/jdk/java/foreign/TestNULLAddress.java"
 "test/jdk/java/foreign/TestNative.java"
 "test/jdk/java/foreign/TestNoForeignUnsafeOverride.java"
 "test/jdk/java/foreign/TestNulls.java"
 "test/jdk/java/foreign/TestReshape.java"
 "test/jdk/java/foreign/TestScopedOperations.java"
 "test/jdk/java/foreign/TestSegmentAllocators.java"
 "test/jdk/java/foreign/TestSegmentCopy.java"
 "test/jdk/java/foreign/TestSegmentOffset.java"
 "test/jdk/java/foreign/TestSegmentOverlap.java"
 "test/jdk/java/foreign/TestSegments.java"
 "test/jdk/java/foreign/TestSharedAccess.java"
 "test/jdk/java/foreign/TestSlices.java"
 "test/jdk/java/foreign/TestSpliterator.java"
 "test/jdk/java/foreign/TestStringEncoding.java"
 "test/jdk/java/foreign/TestTypeAccess.java"
 "test/jdk/java/foreign/TestUnsupportedLinker.java"
 "test/jdk/java/foreign/TestUpcallAsync.java"
 "test/jdk/java/foreign/TestUpcallException.java"
 "test/jdk/java/foreign/TestUpcallHighArity.java"
 "test/jdk/java/foreign/TestUpcallScope.java"
 "test/jdk/java/foreign/TestUpcallStack.java"
 "test/jdk/java/foreign/TestUpcallStructScope.java"
 "test/jdk/java/foreign/TestValueLayouts.java"
 "test/jdk/java/foreign/TestVarArgs.java"
 "test/jdk/java/foreign/TestVarHandleCombinators.java"
 "test/jdk/java/foreign/valist/VaListTest.java"
)

echo "launching jtreg from $jdk_repo"
echo "java version launching jtreg:"
java -version

# https://stackoverflow.com/questions/8880603/loop-through-an-array-of-strings-in-bash
for java_test in "${java_foreign_tests[@]}"
do
    date
    time java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -testjdk:$jdk_artifacts/jdk -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib $java_test

    echo "----------------"
done

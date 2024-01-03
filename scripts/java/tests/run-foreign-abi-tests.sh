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
#  ~/repos/scratchpad/scripts/java/cygwin/build-jdk.sh
#
# To see the tests and the test subdirectories:
#
#  cd ~/repos/java/forks/panama-foreign/test/jdk/java/foreign
#  ls -1 *Test*.java
#  ls -1d */
#
# To run the foreign function & memory tests, use a command line similar to this one:
#
#  time ./run-foreign-abi-tests.sh ~/repos/java/forks/panama-foreign ~/java/binaries/jtreg-7.3.1+1 ~/repos/java/forks/panama-foreign/build/macosx-aarch64-server-release
#  time ./run-foreign-abi-tests.sh ~/java/forks/openjdk/jdk ~/java/binaries/jtreg-7.3.1+1 ~/java/forks/openjdk/jdk/build/linux-x86_64-server-slowdebug
#  time ./run-foreign-abi-tests.sh /d/java/forks/panama-foreign /d/java/binaries/jtreg-7.3.1 /d/java/forks/panama-foreign/build/windows-x86_64-server-slowdebug
#  time ./run-foreign-abi-tests.sh /c/java/forks/openjdk/jdk /c/java/binaries/jtreg-7.3.1 /c/java/forks/openjdk/jdk/build/windows-aarch64-server-slowdebug
#
set -e

jdk_repo=$1
jtreg_path=$2
jdk_artifacts=$3

cd $jdk_repo

declare -a java_foreign_tests=(
 "test/jdk/java/foreign/arraystructs/TestArrayStructs.java"
#"test/jdk/java/foreign/callarranger/CallArrangerTestBase.java"
#"test/jdk/java/foreign/callarranger/platform/PlatformLayouts.java"
 "test/jdk/java/foreign/callarranger/TestLayoutEquality.java"
 "test/jdk/java/foreign/callarranger/TestLinuxAArch64CallArranger.java"
 "test/jdk/java/foreign/callarranger/TestMacOsAArch64CallArranger.java"
 "test/jdk/java/foreign/callarranger/TestRISCV64CallArranger.java"
 "test/jdk/java/foreign/callarranger/TestSysVCallArranger.java"
 "test/jdk/java/foreign/callarranger/TestWindowsAArch64CallArranger.java"
 "test/jdk/java/foreign/callarranger/TestWindowsCallArranger.java"
#"test/jdk/java/foreign/CallGeneratorHelper.java"
 "test/jdk/java/foreign/capturecallstate/TestCaptureCallState.java"
#"test/jdk/java/foreign/channels/AbstractChannelsTest.java"
 "test/jdk/java/foreign/channels/TestAsyncSocketChannels.java"
 "test/jdk/java/foreign/channels/TestSocketChannels.java"
 "test/jdk/java/foreign/CompositeLookupTest.java"
 "test/jdk/java/foreign/critical/TestCritical.java"
 "test/jdk/java/foreign/critical/TestCriticalUpcall.java"
 "test/jdk/java/foreign/critical/TestStressAllowHeap.java"
 "test/jdk/java/foreign/dontrelease/TestDontRelease.java"
#"test/jdk/java/foreign/enablenativeaccess/NativeAccessDynamicMain.java"
#"test/jdk/java/foreign/enablenativeaccess/org/openjdk/foreigntest/unnamed/PanamaMainUnnamedModule.java"
#"test/jdk/java/foreign/enablenativeaccess/panama_module/module-info.java"
#"test/jdk/java/foreign/enablenativeaccess/panama_module/org/openjdk/foreigntest/PanamaMainDirect.java"
#"test/jdk/java/foreign/enablenativeaccess/panama_module/org/openjdk/foreigntest/PanamaMainInvoke.java"
#"test/jdk/java/foreign/enablenativeaccess/panama_module/org/openjdk/foreigntest/PanamaMainJNI.java"
#"test/jdk/java/foreign/enablenativeaccess/panama_module/org/openjdk/foreigntest/PanamaMainReflection.java"
 "test/jdk/java/foreign/enablenativeaccess/TestEnableNativeAccess.java"
#"test/jdk/java/foreign/enablenativeaccess/TestEnableNativeAccessBase.java"
 "test/jdk/java/foreign/enablenativeaccess/TestEnableNativeAccessDynamic.java"
 "test/jdk/java/foreign/enablenativeaccess/TestEnableNativeAccessJarManifest.java"
 "test/jdk/java/foreign/handles/Driver.java"
#"test/jdk/java/foreign/handles/invoker_module/handle/invoker/MethodHandleInvoker.java"
#"test/jdk/java/foreign/handles/invoker_module/module-info.java"
#"test/jdk/java/foreign/handles/lookup_module/handle/lookup/MethodHandleLookup.java"
#"test/jdk/java/foreign/handles/lookup_module/module-info.java"
 "test/jdk/java/foreign/largestub/TestLargeStub.java"
 "test/jdk/java/foreign/LibraryLookupTest.java"
#"test/jdk/java/foreign/loaderLookup/invoker/Invoker.java"
#"test/jdk/java/foreign/loaderLookup/lookup/Lookup.java"
 "test/jdk/java/foreign/loaderLookup/TestLoaderLookup.java"
 "test/jdk/java/foreign/loaderLookup/TestLoaderLookupJNI.java"
 "test/jdk/java/foreign/MemoryLayoutPrincipalTotalityTest.java"
 "test/jdk/java/foreign/MemoryLayoutTypeRetentionTest.java"
#"test/jdk/java/foreign/NativeTestHelper.java"
 "test/jdk/java/foreign/nested/TestNested.java"
 "test/jdk/java/foreign/normalize/TestNormalize.java"
 "test/jdk/java/foreign/passheapsegment/TestPassHeapSegment.java"
 "test/jdk/java/foreign/SafeFunctionAccessTest.java"
 "test/jdk/java/foreign/stackwalk/TestAsyncStackWalk.java"
 "test/jdk/java/foreign/stackwalk/TestReentrantUpcalls.java"
 "test/jdk/java/foreign/stackwalk/TestStackWalk.java"
 "test/jdk/java/foreign/StdLibTest.java"
 "test/jdk/java/foreign/TestAccessModes.java"
 "test/jdk/java/foreign/TestAdaptVarHandles.java"
 "test/jdk/java/foreign/TestAddressDereference.java"
 "test/jdk/java/foreign/TestArrayCopy.java"
 "test/jdk/java/foreign/TestArrays.java"
 "test/jdk/java/foreign/TestByteBuffer.java"
 "test/jdk/java/foreign/TestClassLoaderFindNative.java"
 "test/jdk/java/foreign/TestDeadlock.java"
 "test/jdk/java/foreign/TestDereferencePath.java"
#"test/jdk/java/foreign/TestDowncallBase.java"
 "test/jdk/java/foreign/TestDowncallScope.java"
 "test/jdk/java/foreign/TestDowncallStack.java"
 "test/jdk/java/foreign/TestFallbackLookup.java"
 "test/jdk/java/foreign/TestFree.java"
 "test/jdk/java/foreign/TestFunctionDescriptor.java"
 "test/jdk/java/foreign/TestHandshake.java"
 "test/jdk/java/foreign/TestHeapAlignment.java"
 "test/jdk/java/foreign/TestHFA.java"
 "test/jdk/java/foreign/TestIllegalLink.java"
 "test/jdk/java/foreign/TestIntrinsics.java"
 "test/jdk/java/foreign/TestLargeSegmentCopy.java"
 "test/jdk/java/foreign/TestLayoutPaths.java"
 "test/jdk/java/foreign/TestLayouts.java"
 "test/jdk/java/foreign/TestLinker.java"
 "test/jdk/java/foreign/TestMatrix.java"
 "test/jdk/java/foreign/TestMemoryAccess.java"
 "test/jdk/java/foreign/TestMemoryAccessInstance.java"
 "test/jdk/java/foreign/TestMemoryAlignment.java"
 "test/jdk/java/foreign/TestMemoryDereference.java"
 "test/jdk/java/foreign/TestMemorySession.java"
 "test/jdk/java/foreign/TestMismatch.java"
 "test/jdk/java/foreign/TestNative.java"
#"test/jdk/java/foreign/TestNoForeignUnsafeOverride.java"
 "test/jdk/java/foreign/TestNULLAddress.java"
 "test/jdk/java/foreign/TestNulls.java"
 "test/jdk/java/foreign/TestOfBufferIssue.java"
 "test/jdk/java/foreign/TestReshape.java"
 "test/jdk/java/foreign/TestRestricted.java"
 "test/jdk/java/foreign/TestScope.java"
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
 "test/jdk/java/foreign/TestStringEncodingJumbo.java"
 "test/jdk/java/foreign/TestStubAllocFailure.java"
 "test/jdk/java/foreign/TestTypeAccess.java"
 "test/jdk/java/foreign/TestUpcallAsync.java"
#"test/jdk/java/foreign/TestUpcallBase.java"
 "test/jdk/java/foreign/TestUpcallException.java"
 "test/jdk/java/foreign/TestUpcallHighArity.java"
 "test/jdk/java/foreign/TestUpcallScope.java"
 "test/jdk/java/foreign/TestUpcallStack.java"
 "test/jdk/java/foreign/TestUpcallStructScope.java"
 "test/jdk/java/foreign/TestValueLayouts.java"
 "test/jdk/java/foreign/TestVarArgs.java"
 "test/jdk/java/foreign/TestVarHandleCombinators.java"
 "test/jdk/java/foreign/upcalldeopt/TestUpcallDeopt.java"
#"test/jdk/java/foreign/UpcallTestHelper.java"
 "test/jdk/java/foreign/virtual/TestVirtualCalls.java"
)

echo "launching jtreg from $jdk_repo"
echo "java version launching jtreg:"
$JAVA_HOME/bin/java -version


declare -a existing_tests=()
declare -a missing_tests=()
declare -i tests_found=0

# https://stackoverflow.com/questions/8880603/loop-through-an-array-of-strings-in-bash
for java_test in "${java_foreign_tests[@]}"
do
    date
    if test -f $java_test ; then
        # note: incrementing a counter in the loop is unnecessary because the
        #       the array length can be easily computed. This is here to
        #       illustrate that no spaces are allowed around the += operator
        # see https://stackoverflow.com/questions/21035121/increment-variable-value-by-1-shell-programming
        tests_found+=1

        # note: parenthesis are required to avoid having only 1 element in the array when the loop completes!
        # see https://stackoverflow.com/questions/55316852/append-elements-to-an-array-in-bash
        existing_tests+=($java_test)

        command="$JAVA_HOME/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -testjdk:$jdk_artifacts/jdk -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib $java_test"

        echo -e "Executing: $command"
        time $command
     else
         missing_tests+=($java_test)
     fi

    echo "----------------"
done

tests_not_found=${#missing_tests[@]}

echo "Found $tests_found tests on disk. $tests_not_found tests missing."

echo "Missing tests: "
for java_test in ${missing_tests[@]}
do
    echo $java_test
done | sort

echo -e "\nCommits that deleted the missing files:"
for java_test in ${missing_tests[@]}
do
    echo -e "---------------------------------------\n"
    echo -e "Last commit to modify $java_test\n"
    git_command="git log --full-history -1 -- ./$java_test"
    $git_command
done

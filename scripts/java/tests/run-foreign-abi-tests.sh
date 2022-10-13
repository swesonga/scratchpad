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
#  time run-foreign-abi-tests.sh /Users/saint/repos/java/forks/panama-foreign /Users/saint/repos/java/infra/bin/jtreg /Users/saint/repos/java/forks/panama-foreign/build/macosx-aarch64-server-release
#

jdk_repo=$1
jtreg_path=$2
jdk_artifacts=$3

cd $jdk_repo

$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/callarranger/TestAarch64CallArranger.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/callarranger/TestSysVCallArranger.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/callarranger/TestWindowsCallArranger.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/stackwalk/TestStackWalk.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/StdLibTest.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestAdaptVarHandles.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestArrays.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestByteBuffer.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestFree.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestFunctionDescriptor.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestHandshake.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestIllegalLink.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestIntrinsics.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestLayoutEquality.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestLayoutPaths.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestLayouts.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestMemoryAccess.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestMemoryAlignment.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestMismatch.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestNative.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestNoForeignUnsafeOverride.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestNulls.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestReshape.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestSegments.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestSharedAccess.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestSlices.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestSpliterator.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestTypeAccess.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestUpcallHighArity.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestVarArgs.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/TestVarHandleCombinators.java
$jdk_artifacts/jdk/bin/java -jar $jtreg_path/lib/jtreg.jar -agentvm -timeoutFactor:4 -concurrency:4 -verbose:fail,error,summary -nativepath:$jdk_artifacts/support/test/jdk/jtreg/native/lib test/jdk/java/foreign/valist/VaListTest.java

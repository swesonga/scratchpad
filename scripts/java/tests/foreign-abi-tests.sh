#!/bin/bash

# Run from the root of the OpenJDK repo

declare -a java_tests=(
 "test/jdk/java/foreign/TestCircularInit2.java"
 "test/jdk/java/foreign/callarranger/TestSysVCallArranger.java"
 "test/jdk/java/foreign/valist/VaListTest.java"
 "test/jdk/java/foreign/callarranger/TestWindowsCallArranger.java"
 "test/jdk/java/foreign/TestCircularInit1.java"
 "test/jdk/java/foreign/TestArrays.java"
 "test/jdk/java/foreign/TestFree.java"
 "test/jdk/java/foreign/TestIllegalLink.java"
 "test/jdk/java/foreign/TestFunctionDescriptor.java"
 "test/jdk/java/foreign/TestLayoutAttributes.java"
 "test/jdk/java/foreign/TestCondy.java"
 "test/jdk/java/foreign/TestLayoutEquality.java"
 "test/jdk/java/foreign/TestLayoutConstants.java"
 "test/jdk/java/foreign/callarranger/TestAarch64CallArranger.java"
 "test/jdk/java/foreign/stackwalk/TestStackWalk.java"
 "test/jdk/java/foreign/TestLayoutPaths.java"
 "test/jdk/java/foreign/TestLibraryLookup.java"
 "test/jdk/java/foreign/TestAdaptVarHandles.java"
 "test/jdk/java/foreign/TestLayouts.java"
 "test/jdk/java/foreign/TestAddressHandle.java"
 "test/jdk/java/foreign/TestMemoryAlignment.java"
 "test/jdk/java/foreign/TestMemoryAccessStatics.java"
 "test/jdk/java/foreign/TestMemoryCopy.java"
 "test/jdk/java/foreign/TestNative.java"
 "test/jdk/java/foreign/TestNoForeignUnsafeOverride.java"
 "test/jdk/java/foreign/TestMismatch.java"
 "test/jdk/java/foreign/TestReshape.java"
 "test/jdk/java/foreign/TestMemoryHandleAsUnsigned.java"
 "test/jdk/java/foreign/TestNulls.java"
 "test/jdk/java/foreign/TestByteBuffer.java"
 "test/jdk/java/foreign/TestSlices.java"
 "test/jdk/java/foreign/TestRebase.java"
 "test/jdk/java/foreign/TestTypeAccess.java"
 "test/jdk/java/foreign/TestNativeScope.java"
 "test/jdk/java/foreign/TestIntrinsics.java"
 "test/jdk/java/foreign/TestSpliterator.java"
 "test/jdk/java/foreign/TestUpcallStubs.java"
 "test/jdk/java/foreign/TestVarHandleCombinators.java"
 "test/jdk/java/foreign/TestVarArgs.java"
 "test/jdk/java/foreign/TestSegments.java"
 "test/jdk/java/foreign/TestMemoryAccess.java"
 "test/jdk/java/foreign/TestUpcallHighArity.java"
 "test/jdk/java/foreign/TestSharedAccess.java"
 "test/jdk/java/foreign/StdLibTest.java"
 "test/jdk/java/foreign/TestCleaner.java"
 "test/jdk/java/foreign/TestDowncall.java"
 "test/jdk/java/foreign/TestHandshake.java"
 "test/jdk/java/foreign/TestUpcall.java"
)

declare -a existing_tests=()
declare -a missing_tests=()

declare -i tests_found=0

# https://stackoverflow.com/questions/8880603/loop-through-an-array-of-strings-in-bash
for java_test in "${java_tests[@]}"
do
   if test -f $java_test ; then
       # note: incrementing a counter in the loop is unnecessary because the
       #       the array length can be easily computed. This is here to
       #       illustrate that no spaces are allowed around the += operator
       # see https://stackoverflow.com/questions/21035121/increment-variable-value-by-1-shell-programming
       tests_found+=1

       # note: parenthesis are required to avoid having only 1 element in the array when the loop completes!
       # see https://stackoverflow.com/questions/55316852/append-elements-to-an-array-in-bash
       existing_tests+=($java_test)
   else
       missing_tests+=($java_test)
   fi
done

tests_not_found=${#missing_tests[@]}

echo "Found $tests_found tests on disk. $tests_not_found tests missing."

echo "Missing tests: "
for java_test in ${missing_tests[@]}
do
    echo $java_test
done

echo -e "\nExisting tests: "
for java_test in "${existing_tests[@]}"
do
    echo $java_test
done

echo -e "\nCommits that deleted the missing files:"
for java_test in ${missing_tests[@]}
do
    echo -e "---------------------------------------\n"
    echo -e "Last commit to modify $java_test\n"
    git_command="git log --full-history -1 -- ./$java_test"
    $git_command
done

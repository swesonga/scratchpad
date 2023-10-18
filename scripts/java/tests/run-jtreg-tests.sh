#!/bin/bash
#
# To test a release branch, for example, run these commands first
#
#  git clone https://github.com/microsoft/openjdk-jdk17u
#  cd openjdk-jdk17u
#  git checkout release/jdk-17.0.5_8
#

# Exit immediately if a command exits with a non-zero status. See
# https://unix.stackexchange.com/questions/22726/how-to-conditionally-do-something-if-a-command-succeeded-or-failed
# https://stackoverflow.com/questions/19622198/what-does-set-e-mean-in-a-bash-script
#set -e

declare -a ui_tests=(
 "test/jdk/java/awt/Focus/8000326/SetFocusTraversalKeysEnabledTest.java"
 "test/jdk/java/awt/Focus/8282640/ScrollPaneFocusBugTest.java"
 "test/jdk/javax/swing/JButton/4659800/SpaceKeyActivatesButton.java"
 "test/jdk/javax/swing/JComboBox/JComboBoxPopupMenuEventTest.java"
 "test/jdk/javax/swing/JFileChooser/JFileChooserSetLocationTest.java"
 "test/jdk/javax/swing/JLabel/4138746/JLabelMnemonicsTest.java"
 "test/jdk/javax/swing/JList/4618767/JListSelectedElementTest.java"
 "test/jdk/javax/swing/JRootPane/DefaultButtonTest.java"
 "test/jdk/javax/swing/JSpinner/4670051/DateFieldUnderCursorTest.java"
 "test/jdk/javax/swing/JSplitPane/4164779/JSplitPaneKeyboardNavigationTest.java"
 "test/jdk/javax/swing/JSplitPane/4615365/JSplitPaneDividerLocationTest.java"
 "test/jdk/javax/swing/JSplitPane/4820080/JSplitPaneDragColorTest.java"
 "test/jdk/javax/swing/JTextArea/4514331/TabShiftsFocusToNextComponent.java"
 "test/jdk/javax/swing/JTextField/4532513/DefaultCaretRequestsFocusTest.java"
 "test/jdk/javax/swing/JTree/4518432/JTreeNodeCopyPasteTest.java"
 "test/jdk/javax/swing/JTree/4618767/JTreeSelectedElementTest.java"
)

declare -a java_tests=(
 "test/hotspot/jtreg/compiler/c2/ClearArray.java"
 "test/hotspot/jtreg/compiler/c2/irTests/scalarReplacement/AllocationMergesTests.java"
 "test/hotspot/jtreg/compiler/intrinsics/unsafe/HeapByteBufferTest.java#id1"
 "test/hotspot/jtreg/compiler/loopopts/TestOverUnrolling2.java"
 "test/hotspot/jtreg/compiler/loopopts/superword/TestPeeledReductionNode.java"
 "test/hotspot/jtreg/compiler/rangechecks/TestRangeCheckCmpUUnderflow.java"
 "test/hotspot/jtreg/vmTestbase/gc/gctests/LargeObjects/large002/TestDescription.java"
 "test/hotspot/jtreg/vmTestbase/gc/gctests/LargeObjects/large002/TestDescription.java"
 "test/hotspot/jtreg/vmTestbase/gc/gctests/LargeObjects/large003/TestDescription.java"
 "test/hotspot/jtreg/vmTestbase/gc/gctests/LargeObjects/large004/TestDescription.java"
 "test/hotspot/jtreg/vmTestbase/gc/gctests/LargeObjects/large005/TestDescription.java"
 "test/jdk/java/nio/file/Files/probeContentType/Basic.java"
 "test/jdk/security/infra/java/security/cert/CertPathValidator/certification/QuoVadisCA.java"
 "test/langtools/tools/javac/6257443/T6257443.java"
 "test/langtools/tools/javac/8074306/TestSyntheticNullChecks.java"
 "test/langtools/tools/javac/StringConcat/TestIndyStringConcat.java"
 "test/langtools/tools/javac/jvm/ClassRefDupInConstantPoolTest.java"
 "test/langtools/tools/javac/warnings/suppress/PackageInfo.java"
)

# https://github.com/microsoft/openjdk-jdk/pull/9
declare -a pr_tests_00009=(
 "test/jdk/javax/management/mxbean/MXBeanInteropTest1.java"
)

declare -a rsa_tests=(
 "test/jdk/sun/security/rsa/RSAPaddingCheck.java"
)

declare -a docker_tests=(
 "test/jdk/jdk/internal/platform/docker/TestLimitsUpdating.java"
 "test/hotspot/jtreg/containers/docker/TestLimitsUpdating.java"
)

if [ $# -lt 2 ]
then
    echo "Usage:    ./run-jtreg-tests.sh openjdk-repo-path test-jdk-path jtreg-jar-path"
    echo -e "\nExamples:"
    echo "          ./run-jtreg-tests.sh /c/java/ms/openjdk-jdk11u /c/java/binaries/jdk/x64/jdk-11.0.17+8 /c/java/binaries/jtreg-6.1+1/lib/jtreg.jar"
    echo "          ./run-jtreg-tests.sh /d/java/ms/openjdk-jdk17u /d/java/binaries/jdk/x64/jdk-17.0.8+7  /d/java/binaries/jtreg-7.3+1/lib/jtreg.jar"
    echo "          ./run-jtreg-tests.sh /d/java/ms/openjdk-jdk17u /d/java/binaries/jdk/x86/jdk-17.0.8+7  /d/java/binaries/jtreg-7.3+1/lib/jtreg.jar"
    echo "          ./run-jtreg-tests.sh ~/java/ms/openjdk-jdk ~/java/ms/openjdk-jdk/build/linux-x86_64-server-slowdebug/jdk ~/java/binaries/jtreg-7.3+1/lib/jtreg.jar"
    echo "          ./run-jtreg-tests.sh ~/java/forks/jdk      ~/java/forks/jdk/build/linux-x86_64-server-slowdebug/jdk ~/java/binaries/jtreg-7.3+1/lib/jtreg.jar"
    echo "          ./run-jtreg-tests.sh ~/java/forks/openjdk/jdk17u-dev ~/java/forks/openjdk/jdk17u-dev/build/linux-x86_64-server-slowdebug/jdk ~/java/binaries/jtreg-7.3.1/lib/jtreg.jar"
    exit
fi

openjdk_repo_path=$1
test_jdk=$2
jtreg_jar_path=$3

$test_jdk/bin/java -version

echo -e "\nChanging current directory to $openjdk_repo_path\n"
cd $openjdk_repo_path

# https://stackoverflow.com/questions/1886374/how-to-find-the-length-of-an-array-in-shell
echo -e "Tests to Run: ${#docker_tests[@]}"
declare -a missing_tests=()

# https://stackoverflow.com/questions/8880603/loop-through-an-array-of-strings-in-bash
for java_test in "${docker_tests[@]}"
do
   if test -f $java_test ; then
       date;
       echo -e "\n\n\n---- Running $java_test ----"

       command="$test_jdk/bin/java -Xmx512m -jar $jtreg_jar_path -agentvm -ignore:quiet -automatic -xml -vmoption:-Xmx512m -timeoutFactor:4 -concurrency:1 -testjdk:$test_jdk -verbose:fail,error,summary $java_test"

       echo -e "Executing: $command"
       time $command
   else
       missing_tests+=($java_test)
   fi
done

date
num_missing_tests=${#missing_tests[@]}

if [ $num_missing_tests -ne '0' ]; then
    echo -e "\nMissing tests: ${num_missing_tests}"
    echo "---------------------------------------"
    for java_test in ${missing_tests[@]}
    do
        echo $java_test
    done | sort

    for java_test in ${missing_tests[@]}
    do
        echo -e "---------------------------------------\n"
        echo -e "Last commit to modify missing file $java_test\n"
        git_command="git log --full-history -1 -- ./$java_test"
        $git_command
    done
fi
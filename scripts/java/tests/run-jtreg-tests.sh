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
set -e

declare -a java_tests=(
 "java/awt/Focus/8000326/SetFocusTraversalKeysEnabledTest.java"
 "java/awt/Focus/8282640/ScrollPaneFocusBugTest.java"
 "javax/swing/JButton/4659800/SpaceKeyActivatesButton.java"
 "javax/swing/JComboBox/JComboBoxPopupMenuEventTest.java"
 "javax/swing/JFileChooser/JFileChooserSetLocationTest.java"
 "javax/swing/JLabel/4138746/JLabelMnemonicsTest.java"
 "javax/swing/JList/4618767/JListSelectedElementTest.java"
 "javax/swing/JRootPane/DefaultButtonTest.java"
 "javax/swing/JSpinner/4670051/DateFieldUnderCursorTest.java"
 "javax/swing/JSplitPane/4164779/JSplitPaneKeyboardNavigationTest.java"
 "javax/swing/JSplitPane/4615365/JSplitPaneDividerLocationTest.java"
 "javax/swing/JSplitPane/4820080/JSplitPaneDragColorTest.java"
 "javax/swing/JTextArea/4514331/TabShiftsFocusToNextComponent.java"
 "javax/swing/JTextField/4532513/DefaultCaretRequestsFocusTest.java"
 "javax/swing/JTree/4518432/JTreeNodeCopyPasteTest.java"
 "javax/swing/JTree/4618767/JTreeSelectedElementTest.java"
)

if [ $# -lt 2 ]
then
    echo "Usage:   run-jtreg-tests.sh openjdk-repo-path test-jdk-path jtreg-jar-path"
    echo "Example: run-jtreg-tests.sh /d/java/ms/openjdk-jdk17u /d/java/binaries/jdk/jdk-17.0.5+8 /d/java/binaries/jtreg7/lib/jtreg.jar"
    exit
fi

openjdk_repo_path=$1
test_jdk=$2
jtreg_jar_path=$3

cd $openjdk_repo_path

declare -a missing_tests=()

# https://stackoverflow.com/questions/8880603/loop-through-an-array-of-strings-in-bash
for java_test in "${java_tests[@]}"
do
   java_test="test/jdk/${java_test}"
   if test -f $java_test ; then
       $test_jdk/bin/java -Xmx512m -jar $jtreg_jar_path -agentvm -ignore:quiet -automatic -xml -vmoption:-Xmx512m -timeoutFactor:4 -concurrency:1 -testjdk:$test_jdk -verbose:fail,error,summary $java_test
   else
       missing_tests+=($java_test)
   fi
done

echo "Missing tests: "
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

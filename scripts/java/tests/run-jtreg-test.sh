#!/bin/bash

if [ $# -lt 4 ]
then
    echo "Usage:    ./run-jtreg-test.sh openjdk-repo-path test-jdk-path jtreg-jar-path test-path test-flags"
    echo -e "\nExample:"
    echo "          ./run-jtreg-test.sh /d/java/forks/openjdk/jdk /d/java/forks/openjdk/jdk/build/windows-x86_64-server-slowdebug/jdk  /c/java/binaries/jtreg/jtreg-7.4+1/lib/jtreg.jar test/hotspot/jtreg/serviceability/sa/ClhsdbFindPC.java -nativepath:/d/java/forks/openjdk/jdk/build/windows-x86_64-server-slowdebug/images/test/hotspot/jtreg/native"
    echo "          ./run-jtreg-test.sh /c/java/forks/openjdk/jdk /c/java/forks/openjdk/jdk/build/windows-aarch64-server-slowdebug/jdk /c/java/binaries/jtreg/jtreg-7.4+1/lib/jtreg.jar test/hotspot/jtreg/serviceability/sa/ClhsdbFindPC.java -nativepath:/c/java/forks/openjdk/jdk/build/windows-aarch64-server-slowdebug/images/test/hotspot/jtreg/native"
    exit
fi

openjdk_repo_path=$1
test_jdk=$2
jtreg_jar_path=$3
java_test=$4
test_flags=$5

$test_jdk/bin/java -version

echo -e "\nChanging current directory to $openjdk_repo_path\n"
cd $openjdk_repo_path

echo -e "Test to Run: ${java_test}"
declare -a missing_tests=()

if test -f $java_test ; then
    date;
    echo -e "\n\n\n---- Running $java_test ----"

    # Use -verbose:all to get all output (e.g. when debugging)
    command="$test_jdk/bin/java -Xmx512m -jar $jtreg_jar_path -agentvm -ignore:quiet -automatic -xml -vmoption:-Xmx512m -timeoutFactor:4 -concurrency:1 -testjdk:$test_jdk -verbose:fail,error,summary $test_flags $java_test"

    echo -e "Executing: $command"
    time $command

#    for i in {1..10}; do
#        echo -e "\n=== Iteration $i of 10 ==="
#        time $command
#    done
else
    missing_tests+=($java_test)
fi

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
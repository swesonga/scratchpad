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

declare -a java_tests=(
 # "test/hotspot/jtreg/applications/scimark/Scimark.java"
 "test/hotspot/jtreg/compiler/gcbarriers/UnsafeIntrinsicsTest.java"
)

# https://github.com/microsoft/openjdk-jdk/pull/9
declare -a pr_tests_00009=(
 "test/jdk/javax/management/mxbean/MXBeanInteropTest1.java"
)

declare -a security_tests=(
 # "test/jdk/sun/security/rsa/RSAPaddingCheck.java"
 "test/jdk/security/infra/java/security/cert/CertPathValidator/certification/CAInterop.java"
 "test/jdk/security/infra/java/security/cert/CertPathValidator/certification/DigicertCSRootG5.java"
 "test/jdk/security/infra/java/security/cert/CertPathValidator/certification/EmSignRootG2CA.java"
)

# Use -Ddocker.support=true in the test_flags if you get "Test results: no tests selected"
declare -a docker_tests=(
 "test/jdk/jdk/internal/platform/docker/TestLimitsUpdating.java"
 "test/hotspot/jtreg/containers/docker/TestLimitsUpdating.java"
)

if [ $# -lt 2 ]
then
    echo "Usage:    ./run-jtreg-tests.sh openjdk-repo-path test-jdk-path jtreg-jar-path"
    echo -e "\nExamples:"
    echo "          ./run-jtreg-tests.sh /c/java/ms/openjdk-jdk11u /c/java/binaries/jdk/x64/jdk-11.0.17+8 /c/java/binaries/jtreg-7.3.1/lib/jtreg.jar"
    echo "          ./run-jtreg-tests.sh /d/java/ms/openjdk-jdk17u /d/java/binaries/jdk/x64/jdk-17.0.9+8  /c/java/binaries/jtreg-7.3.1/lib/jtreg.jar"
    echo "          ./run-jtreg-tests.sh /d/java/forks/openjdk/jdk17u-dev /d/java/binaries/jdk/x64/jdk-17.0.9+8  /c/java/binaries/jtreg-7.3.1/lib/jtreg.jar"
    echo "          ./run-jtreg-tests.sh ~/java/ms/openjdk-jdk ~/java/ms/openjdk-jdk/build/linux-x86_64-server-slowdebug/jdk ~/java/binaries/jtreg-7.3+1/lib/jtreg.jar"
    echo "          ./run-jtreg-tests.sh ~/java/forks/jdk      ~/java/forks/jdk/build/linux-x86_64-server-slowdebug/jdk ~/java/binaries/jtreg-7.3+1/lib/jtreg.jar"
    echo "          ./run-jtreg-tests.sh ~/java/forks/openjdk/jdk17u-dev ~/java/forks/openjdk/jdk17u-dev/build/linux-x86_64-server-slowdebug/jdk ~/java/binaries/jtreg-7.3.1/lib/jtreg.jar"
    exit
fi

openjdk_repo_path=$1
test_jdk=$2
jtreg_jar_path=$3
test_flags=$4

$test_jdk/bin/java -version

echo -e "\nChanging current directory to $openjdk_repo_path\n"
cd $openjdk_repo_path

# https://stackoverflow.com/questions/1886374/how-to-find-the-length-of-an-array-in-shell
echo -e "Tests to Run: ${#java_tests[@]}"
declare -a missing_tests=()

# https://stackoverflow.com/questions/8880603/loop-through-an-array-of-strings-in-bash
for java_test in "${java_tests[@]}"
do
   if test -f $java_test ; then
       date;
       echo -e "\n\n\n---- Running $java_test ----"

       command="$test_jdk/bin/java -Xmx512m -jar $jtreg_jar_path -agentvm -ignore:quiet -automatic -xml -vmoption:-Xmx512m -timeoutFactor:4 -concurrency:1 -testjdk:$test_jdk -verbose:fail,error,summary $test_flags $java_test"

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
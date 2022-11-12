#!/bin/bash
#
# Usage: getbuilds ~/Downloads /c/dev/java/abi/builds devbranch jdk test
#

# Exit immediately if a command exits with a non-zero status. See
# https://unix.stackexchange.com/questions/22726/how-to-conditionally-do-something-if-a-command-succeeded-or-failed
# https://stackoverflow.com/questions/19622198/what-does-set-e-mean-in-a-bash-script
set -e

source_dir=$1
abi_path=$2
dir_pattern=$3
jdk_prefix=$4
test_prefix=$5

timestamp=`date +%Y-%m-%d_%H%M%S`

if [ $# -lt 5 ]
then
    echo "Usage: getbuilds ~/Downloads /c/dev/java/abi/builds devbranch jdk test"
    exit
fi

mkdir -p $abi_path
cd $abi_path

artifact_dir="$dir_pattern-$timestamp"
mkdir -p $artifact_dir
cd $artifact_dir
mv $1/*.zip .

jdk_artifact_dir="jdk"

echo "Creating JDK artifact directory: $jdk_artifact_dir"
mkdir -p $jdk_artifact_dir
cd $jdk_artifact_dir

jdk_zip="../$jdk_prefix*.zip"
jdk_zip_path="`ls -1 $jdk_zip`"

timestamp=`date +%Y-%m-%d_%H%M%S`
echo "$timestamp: Unzipping $jdk_zip_path into `pwd`"
unzip -q $jdk_zip_path

cd ..
test_zip_path="$test_prefix*.zip"

timestamp=`date +%Y-%m-%d_%H%M%S`
echo "$timestamp: Unzipping $test_zip_path into `pwd`"
unzip -q `ls -1 $test_zip_path`

date
echo "Unzip complete"

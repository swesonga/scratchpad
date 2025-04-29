#!/bin/bash
#
# Download and install Cygwin if running on Windows:
#  mkdir -p ~/cygwin
#  cd ~/cygwin
#  curl -Lo setup-x86_64.exe https://www.cygwin.com/setup-x86_64.exe
#  setup-x86_64.exe -q -P autoconf -P make -P unzip -P zip
#
# A boot JDK may be required if building the latest code from upstream.
# Download JDKs from https://adoptium.net/temurin/releases/?version=20 or
# https://learn.microsoft.com/en-us/java/openjdk/download e.g.
#
#  mkdir -p ~/java/binaries/jdk/x64
#  cd ~/java/binaries/jdk/x64
#  wget https://aka.ms/download-jdk/microsoft-jdk-17.0.7-linux-x64.tar.gz
#
# To download and set up jtreg, run these commands:
#
#  cd ~/java/binaries/jtreg/
#  curl -Lo jtreg-7.4+1.tar.gz https://ci.adoptium.net/view/Dependencies/job/dependency_pipeline/lastSuccessfulBuild/artifact/jtreg/jtreg-7.4+1.tar.gz
#  tar xzf jtreg-7.4+1.tar.gz
#  mv jtreg jtreg-7.4+1
#
#  curl -Lo jtreg-7.5.1+1.tar.gz https://builds.shipilev.net/jtreg/jtreg-7.5.1%2B1.zip
#  unzip -q jtreg-7.5.1+1.tar.gz
#  mv jtreg jtreg-7.5.1+1
#
# To download googletest (use the "release-1.8.1" branch for JDK 17):
#
#  cd /c/repos
#  git clone -b v1.13.0 https://github.com/google/googletest
#
# For details on the options for configuring the build, see
# https://github.com/openjdk/jdk/blob/master/doc/building.md#running-configure
# Use jdk-17.0.6+10 as the boot JDK if building JDK 17. Otherwise,
# to configure the build on tip for:
#
# x86_64 Debug (Windows):
#  bash configure --with-debug-level=slowdebug --with-boot-jdk=/cygdrive/c/java/binaries/jdk/x64/jdk-24+36 --with-jtreg=/cygdrive/c/java/binaries/jtreg/jtreg-7.5.1+1 --with-gtest=/cygdrive/c/repos/googletest --with-extra-ldflags=-profile
#  bash configure --with-debug-level=slowdebug --with-boot-jdk=/cygdrive/c/java/binaries/jdk/x64/jdk-24+36 --with-jtreg=/cygdrive/c/java/binaries/jtreg/jtreg-7.5.1+1 --with-gtest=/cygdrive/c/repos/googletest --with-extra-ldflags=-profile --with-hsdis=llvm --with-llvm=/cygdrive/c/software/llvm/llvm-x86_64/
#
# x86_64 Debug (Linux):
#  bash configure --with-debug-level=slowdebug --with-boot-jdk=~/java/binaries/jdk/x64/jdk-24+36 --with-jtreg=/home/saint/java/binaries/jtreg/jtreg-7.5.1+1 --with-gtest=/home/saint/repos/googletest
#
# x86_64 Release (Windows):
#  bash configure --with-boot-jdk=/cygdrive/c/java/binaries/jdk/x64/jdk-24+36 --with-jtreg=/cygdrive/c/java/binaries/jtreg/jtreg-7.5.1+1 --with-gtest=/cygdrive/c/repos/googletest
#  bash configure --with-boot-jdk=/cygdrive/c/java/binaries/jdk/x64/jdk-24+36 --with-jtreg=/cygdrive/c/java/binaries/jtreg/jtreg-7.5.1+1 --with-gtest=/cygdrive/c/repos/googletest --with-hsdis=llvm --with-llvm=/cygdrive/c/software/llvm/llvm-x86_64/
#
# x86_64 Release (Linux):
#  bash configure --with-boot-jdk=~/java/binaries/jdk/x64/jdk-24+36 --with-jtreg=/home/saint/java/binaries/jtreg/jtreg-7.5.1+1 --with-gtest=/home/saint/repos/googletest
#
# aarch64 Debug (Windows) (for cross compiling, otherwise replace x64 in boot jdk path):
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-debug-level=slowdebug --with-jtreg=/cygdrive/c/java/binaries/jtreg/jtreg-7.5.1+1 --with-gtest=/cygdrive/c/repos/googletest --with-extra-ldflags=-profile --with-boot-jdk=/cygdrive/c/java/binaries/jdk/x64/jdk-24+36
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-debug-level=slowdebug --with-jtreg=/cygdrive/c/java/binaries/jtreg/jtreg-7.5.1+1 --with-gtest=/cygdrive/c/repos/googletest --with-extra-ldflags=-profile --with-boot-jdk=/cygdrive/c/java/binaries/jdk/x64/jdk-24+36 --with-hsdis=llvm --with-llvm=/cygdrive/c/software/llvm/llvm-aarch64/
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-debug-level=slowdebug --with-jtreg=/cygdrive/c/java/binaries/jtreg/jtreg-7.5.1+1 --with-gtest=/cygdrive/c/repos/googletest --with-extra-ldflags=-profile --with-boot-jdk=/cygdrive/c/java/forks/jdk/build/windows-x86_64-server-slowdebug/jdk --with-hsdis=llvm --with-llvm=/cygdrive/c/software/llvm/llvm-aarch64/
#
# aarch64 Release (Windows) (for cross compiling, otherwise replace x64 in boot jdk path):
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-jtreg=/cygdrive/c/java/binaries/jtreg/jtreg-7.5.1+1 --with-gtest=/cygdrive/c/repos/googletest --with-boot-jdk=/cygdrive/c/java/binaries/jdk/x64/jdk-24+36
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-jtreg=/cygdrive/c/java/binaries/jtreg/jtreg-7.5.1+1 --with-gtest=/cygdrive/c/repos/googletest --with-boot-jdk=/cygdrive/c/java/binaries/jdk/x64/jdk-24+36 --with-hsdis=llvm --with-llvm=/cygdrive/c/software/llvm/llvm-aarch64/
#
# Run this script as follows:
#
#  time /cygdrive/c/repos/scratchpad/scripts/java/cygwin/build-jdk.sh windows x86_64 slowdebug
#  time ~/repos/scratchpad/scripts/java/cygwin/build-jdk.sh linux x86_64 slowdebug
#

# Exit immediately if a command exits with a non-zero status. See
# https://unix.stackexchange.com/questions/22726/how-to-conditionally-do-something-if-a-command-succeeded-or-failed
# https://stackoverflow.com/questions/19622198/what-does-set-e-mean-in-a-bash-script
set -e

function log_message()
{
    current_time=`date +%Y-%m-%d%t%H:%M:%S`
    echo "$current_time $1"
}

if [ $# -lt 3 ]
then
    echo -e "Usage: build-jdk.sh os architecture debug_level build_hsdis\n"
    echo -e "Examples:\n"
    echo "       build-jdk.sh windows x86_64 release 0"
    echo "       build-jdk.sh windows x86_64 slowdebug 1"
    exit
fi

timestamp=`date +%Y-%m-%d_%H%M%S`

# TODO: automatically detect current os and architecture if not specified.
# Select either the x86_64 or aarch64 architectures
os=$1
arch=$2
debug_level=$3
build_hsdis=$4
llvm_path=/cygdrive/c/software/llvm/llvm-$arch
log_root="build/mylogs"
# use "debug" for a more detailed log
log_verbosity=cmdlines
redirect_output=1
build_conf="${os}-${arch}-server-${debug_level}"

log_message "Starting $build_conf build with timestamp $timestamp for OS type $OSTYPE"
log_message "Latest commits:"
git log -2
log_message "Git repo status:"
git status
mkdir -p $log_root

images_log="$log_root/images-${build_conf}-${timestamp}.txt"
jtreg_native_log="$log_root/test-${build_conf}-${timestamp}.txt"
test_image_log="$log_root/test-image-${build_conf}-${timestamp}.txt"

images_zip="jdk-${build_conf}-${timestamp}.zip"
support_test_zip="support-test-${build_conf}-${timestamp}.zip"
images_test_zip="images-test-${build_conf}-${timestamp}.zip"

build_command="make images CONF=$build_conf LOG=$log_verbosity"
log_message "Building images using command: $build_command"
if [ $redirect_output -ne 0 ]; then
    $build_command > $images_log
else
    $build_command
fi

built_jdk="build/${build_conf}/images/jdk/"

log_message "Zipping the JDK in $built_jdk into $images_zip"
cd $built_jdk

zip -qru $images_zip .
mv $images_zip ../..
cd ../../../../

build_command="make build-test-jdk-jtreg-native CONF=$build_conf LOG=$log_verbosity"
log_message "Building jtreg native binaries using command: $build_command"
if [ $redirect_output -ne 0 ]; then
    $build_command > $jtreg_native_log
else
    $build_command
fi

build_command="make test-image CONF=$build_conf LOG=$log_verbosity"
log_message "Building test image using command: $build_command"
if [ $redirect_output -ne 0 ]; then
    $build_command > $test_image_log
else
    $build_command
fi

if [ $build_hsdis -ne 0 ]; then
    hsdis_build_log="$log_root/hsdis_build-${timestamp}.txt"
    hsdis_install_log="$log_root/hsdis_install-${timestamp}.txt"

    build_command="make build-hsdis CONF=$build_conf LOG=$log_verbosity"
    log_message "Building hsdis using command: $build_command"
    if [ $redirect_output -ne 0 ]; then
        $build_command > $hsdis_build_log
    else
        $build_command
    fi

    build_command="make install-hsdis CONF=$build_conf LOG=$log_verbosity"
    log_message "Installing hsdis using command: $build_command"
    if [ $redirect_output -ne 0 ]; then
        $build_command > $hsdis_install_log
    else
        $build_command
    fi

    cp "${llvm_path}/bin/LLVM-C.dll" "${built_jdk}/bin"
fi

build_conf_dir="build/${build_conf}"
log_message "Zipping support/test into $support_test_zip (switching from `pwd` to $build_conf_dir)"
cd $build_conf_dir
zip -qru $support_test_zip support/test

log_message "Zipping images/test into $images_test_zip"
zip -qru $images_test_zip images/test

log_message "Build complete"
date

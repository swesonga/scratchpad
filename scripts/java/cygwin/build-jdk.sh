#!/bin/bash
#
# Execute in Cygwin after configuring the repo.
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
#  curl -Lo jtreg-7.3+1.tar.gz https://ci.adoptopenjdk.net/view/Dependencies/job/dependency_pipeline/lastSuccessfulBuild/artifact/jtreg/jtreg-7.3+1.tar.gz
#  tar xzf jtreg-7.3+1.tar.gz
#  mv jtreg jtreg-7.3+1
#
# To download googletest (use the "release-1.8.1" branch for JDK 17):
#
#  cd /c/repos
#  git clone -b v1.13.0 https://github.com/google/googletest
#
# Use jdk-17.0.6+10 as the boot JDK if building JDK 17. Otherwise,
# to configure the build on tip for:
#
# x86_64 Debug:
#  bash configure --with-debug-level=slowdebug --with-boot-jdk=/cygdrive/c/java/binaries/jdk/x64/jdk-21+35 --with-jtreg=/cygdrive/c/java/binaries/jtreg-7.3.1 --with-gtest=/cygdrive/c/repos/googletest
#  bash configure --with-debug-level=slowdebug --with-boot-jdk=/cygdrive/c/java/binaries/jdk/x64/jdk-21+35 --with-jtreg=/cygdrive/c/java/binaries/jtreg-7.3.1 --with-gtest=/cygdrive/c/repos/googletest --with-hsdis=llvm --with-llvm=/cygdrive/c/software/llvm/llvm-x86_64/
#
# x86_64 Release:
#  bash configure --with-boot-jdk=/cygdrive/c/java/binaries/jdk/x64/jdk-21+35 --with-jtreg=/cygdrive/c/java/binaries/jtreg-7.3.1 --with-gtest=/cygdrive/c/repos/googletest
#  bash configure --with-boot-jdk=/cygdrive/c/java/binaries/jdk/x64/jdk-21+35 --with-jtreg=/cygdrive/c/java/binaries/jtreg-7.3.1 --with-gtest=/cygdrive/c/repos/googletest --with-hsdis=llvm --with-llvm=/cygdrive/c/software/llvm/llvm-x86_64/
#
# aarch64 Debug (for cross compiling, otherwise replace x64 in boot jdk path):
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-debug-level=slowdebug --with-jtreg=/cygdrive/c/java/binaries/jtreg-7.3.1 --with-gtest=/cygdrive/c/repos/googletest --with-boot-jdk=/cygdrive/c/java/binaries/jdk/x64/jdk-21+35
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-debug-level=slowdebug --with-jtreg=/cygdrive/c/java/binaries/jtreg-7.3.1 --with-gtest=/cygdrive/c/repos/googletest --with-boot-jdk=/cygdrive/c/java/binaries/jdk/x64/jdk-21+35 --with-hsdis=llvm --with-llvm=/cygdrive/c/software/llvm/llvm-aarch64/
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-debug-level=slowdebug --with-jtreg=/cygdrive/c/java/binaries/jtreg-7.3.1 --with-gtest=/cygdrive/c/repos/googletest --with-boot-jdk=/cygdrive/c/java/forks/jdk/build/windows-x86_64-server-slowdebug/jdk --with-hsdis=llvm --with-llvm=/cygdrive/c/software/llvm/llvm-aarch64/
#
# aarch64 Release (for cross compiling, otherwise replace x64 in boot jdk path):
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-jtreg=/cygdrive/c/java/binaries/jtreg-7.3.1 --with-gtest=/cygdrive/c/repos/googletest --with-boot-jdk=/cygdrive/c/java/binaries/jdk/x64/jdk-21+35
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-jtreg=/cygdrive/c/java/binaries/jtreg-7.3.1 --with-gtest=/cygdrive/c/repos/googletest --with-boot-jdk=/cygdrive/c/java/binaries/jdk/x64/jdk-21+35 --with-hsdis=llvm --with-llvm=/cygdrive/c/software/llvm/llvm-aarch64/
#
# Run this script as follows:
#
#  time /cygdrive/c/repos/scratchpad/scripts/java/cygwin/build-jdk.sh windows x86_64 0 release
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

if [ $# -lt 4 ]
then
    echo -e "Usage: build-jdk.sh os architecture build_hsdis debug_level\n"
    echo -e "Examples:\n"
    echo "       build-jdk.sh windows x86_64 0 release"
    echo "       build-jdk.sh windows x86_64 1 slowdebug"
    exit
fi

timestamp=`date +%Y-%m-%d_%H%M%S`

# TODO: automatically detect current os and architecture if not specified.
# Select either the x86_64 or aarch64 architectures
os=$1
arch=$2
build_hsdis=$3
debug_level=$4
llvm_path=/cygdrive/c/software/llvm/llvm-$arch
log_root="build/mylogs"
# use "debug" for a more detailed log
log_verbosity=cmdlines
redirect_output=1
build_conf="${os}-${arch}-server-${debug_level}"

log_message "Starting $build_conf build with timestamp $timestamp for OS type $OSTYPE"
mkdir -p $log_root

images_log="$log_root/images-${build_conf}-${timestamp}.txt"
jtreg_native_log="$log_root/test-${build_conf}-${timestamp}.txt"
test_image_log="$log_root/test-image-${build_conf}-${timestamp}.txt"

images_zip="jdk-${build_conf}-${timestamp}.zip"
test_zip="test-${build_conf}-${timestamp}.zip"

log_message "Building images"
if [ $redirect_output -ne 0 ]; then
    make images CONF=$build_conf LOG=$log_verbosity > $images_log
else
    make images CONF=$build_conf LOG=$log_verbosity
fi

built_jdk="build/${build_conf}/jdk/"

log_message "Zipping the JDK into $images_zip"
cd $built_jdk

log_message "Building jtreg native binaries"
if [ $redirect_output -ne 0 ]; then
    make build-test-jdk-jtreg-native CONF=$build_conf LOG=$log_verbosity > $jtreg_native_log
else
    make build-test-jdk-jtreg-native CONF=$build_conf LOG=$log_verbosity
fi

log_message "Building test image"
if [ $redirect_output -ne 0 ]; then
    make test-image CONF=$build_conf LOG=$log_verbosity > $test_image_log
else
    make test-image CONF=$build_conf LOG=$log_verbosity
fi

if [ $build_hsdis -ne 0 ]; then
    hsdis_build_log="$log_root/hsdis_build-${timestamp}.txt"
    hsdis_install_log="$log_root/hsdis_install-${timestamp}.txt"

    log_message "Building hsdis"
    if [ $redirect_output -ne 0 ]; then
        make build-hsdis CONF=$build_conf LOG=$log_verbosity > $hsdis_build_log
    else
        make build-hsdis CONF=$build_conf LOG=$log_verbosity
    fi

    log_message "Installing hsdis"
    if [ $redirect_output -ne 0 ]; then
        make install-hsdis CONF=$build_conf LOG=$log_verbosity > $hsdis_install_log
    else
        make install-hsdis CONF=$build_conf LOG=$log_verbosity
    fi

    cp "${llvm_path}/bin/LLVM-C.dll" "${built_jdk}/bin"
fi

zip -qru $images_zip .
mv $images_zip ..

log_message "Zipping support/test into $test_zip"
cd ..
zip -qru $test_zip support/test

if [ $# -gt 0 ]
then
    log_message "Moving $images_zip to $1"
    mv $images_zip $1

    log_message "Moving $test_zip to $1"
    mv $test_zip $1
fi

log_message "Build complete"
date

#!/bin/bash
#
# Execute in Cygwin after configuring the repo.
# A boot JDK may be required if building the latest code from upstream.
# Download JDKs from https://adoptium.net/temurin/releases/?version=19
#
# x86_64 Debug:
#  bash configure --with-debug-level=slowdebug --with-boot-jdk=/cygdrive/d/dev/Software/java/jdk-19+36
#  bash configure --with-debug-level=slowdebug --with-boot-jdk=/cygdrive/d/dev/Software/java/jdk-19+36  --with-hsdis=llvm --with-llvm=/cygdrive/d/dev/software/llvm-x86_64/
#
# x86_64 Release:
#  bash configure --with-boot-jdk=/cygdrive/d/dev/Software/java/jdk-19+36
#  bash configure --with-boot-jdk=/cygdrive/d/dev/Software/java/jdk-19+36  --with-hsdis=llvm --with-llvm=/cygdrive/d/dev/software/llvm-x86_64/
#
# aarch64 Debug:
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-debug-level=slowdebug --with-boot-jdk=/cygdrive/d/java/binaries/jdk/x64/jdk-19+34
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-debug-level=slowdebug --with-boot-jdk=/cygdrive/d/java/binaries/jdk/x64/jdk-19+34  --with-hsdis=llvm --with-llvm=/cygdrive/d/dev/software/llvm-aarch64/
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-debug-level=slowdebug --with-boot-jdk=/cygdrive/d/java/forks/jdk/build/windows-x86_64-server-slowdebug/jdk  --with-hsdis=llvm --with-llvm=/cygdrive/d/dev/software/llvm-aarch64/
#
# aarch64 Release:
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-boot-jdk=/cygdrive/d/java/binaries/jdk/x64/jdk-19+34
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-boot-jdk=/cygdrive/d/java/binaries/jdk/x64/jdk-19+34  --with-hsdis=llvm --with-llvm=/cygdrive/d/dev/software/llvm-aarch64/
#
# Run this script as follows:
#
#  time /cygdrive/d/dev/repos/scratchpad/scripts/java/cygwin/build-jdk.sh /cygdrive/c/shared/java/builds/
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

timestamp=`date +%Y-%m-%d_%H%M-%S`

# TODO: make these configurable
# Select either the x86_64 or aarch64 architectures
arch=x86_64
os=windows
build_hsdis=1
debug_level=slowdebug
llvm_path=/cygdrive/d/dev/software/llvm-$arch
log_root="build/mylogs"
# use "debug" for a more detailed log
log_verbosity=cmdlines
redirect_output=1
build_conf="${os}-${arch}-server-${debug_level}"

log_message "Starting $debug_level build with timestamp $timestamp for OS type $OSTYPE"
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

built_jdk="build/${build_conf}/jdk/"

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

log_message "Zipping the JDK into $images_zip"
cd $built_jdk
zip -qru $images_zip .
mv $images_zip ..

log_message "Zipping support/test into $test_zip"
cd ..
zip -qru $test_zip support/test

log_message "Build complete"

if [ $# -gt 0 ]
then
    log_message "Moving $images_zip to $1"
    mv $images_zip $1

    log_message "Moving $test_zip to $1"
    mv $test_zip $1
fi

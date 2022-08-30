#!/bin/bash
#
# Execute in Cygwin after configuring the repo.
# A boot JDK may be required if building the latest code from upstream.
#
# Debug:
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-debug-level=slowdebug --with-boot-jdk=/cygdrive/d/dev/repos/java/infra/binaries/jdk-18.0.2
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-debug-level=slowdebug --with-boot-jdk=/cygdrive/d/dev/repos/java/infra/binaries/jdk-18.0.2  --with-hsdis=llvm --with-llvm=/cygdrive/d/dev/software/llvm-aarch64/
#
# Release:
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-boot-jdk=/cygdrive/d/dev/repos/java/infra/binaries/jdk-18.0.2
#  bash configure --openjdk-target=aarch64-unknown-cygwin --with-boot-jdk=/cygdrive/d/dev/repos/java/infra/binaries/jdk-18.0.2  --with-hsdis=llvm --with-llvm=/cygdrive/d/dev/software/llvm-aarch64/
#
# Run this script as follows:
#
#  time /cygdrive/d/dev/repos/scratchpad/scripts/java/cygwin/build-aarch64.sh
#

function log_message()
{
    current_time=`date +%Y-%m-%d_%H%M-%S`
    echo "$current_time $1"
}

timestamp=`date +%Y-%m-%d_%H%M-%S`

# TODO: make these configurable
debug_level=slowdebug
build_hsdis=1
llvm_path=/cygdrive/d/dev/software/llvm-aarch64

log_message "Starting $debug_level build with timestamp $timestamp"

images_log="build/abi-${timestamp}.txt"
jtreg_native_log="build/test-${timestamp}.txt"

images_zip="jdk-${timestamp}.zip"
test_zip="test-${timestamp}.zip"

log_message "Building images"
make images CONF=$debug_level LOG=debug > $images_log

log_message "Building jtreg native binaries"
make build-test-jdk-jtreg-native CONF=$debug_level LOG=debug > $jtreg_native_log

built_jdk="build/windows-aarch64-server-${debug_level}/jdk/"

if [ $build_hsdis -ne 0 ]; then
    hsdis_build_log="build/hsdis_build-${timestamp}.txt"
    hsdis_install_log="build/hsdis_install-${timestamp}.txt"

    log_message "Building hsdis"
    make build-hsdis CONF=$debug_level LOG=debug > $hsdis_build_log

    log_message "Installing hsdis"
    make install-hsdis CONF=$debug_level LOG=debug > $hsdis_install_log

    cp "${llvm_path}/bin/LLVM-C.dll" "${built_jdk}/bin"
fi

log_message "Zipping the JDK"
cd $built_jdk
zip -qru $images_zip .
mv $images_zip ..

log_message "Zipping support/test"
cd ..
zip -qru $test_zip support/test

log_message "Build complete"

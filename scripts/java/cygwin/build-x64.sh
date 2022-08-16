#!/bin/bash
#
# Execute in Cygwin after configuring the repo.
# A boot JDK may be required if building the latest code from upstream.
#
# Debug:
#  bash configure --with-debug-level=slowdebug --with-boot-jdk=/cygdrive/d/dev/repos/java/infra/binaries/jdk-18.0.2
#  bash configure --with-debug-level=slowdebug --with-boot-jdk=/cygdrive/d/dev/repos/java/infra/binaries/jdk-18.0.2  --with-hsdis=llvm --with-llvm=/cygdrive/d/dev/software/llvm-x64/
#
# Release:
#  bash configure --with-boot-jdk=/cygdrive/d/dev/repos/java/infra/binaries/jdk-18.0.2
#  bash configure --with-boot-jdk=/cygdrive/d/dev/repos/java/infra/binaries/jdk-18.0.2  --with-hsdis=llvm --with-llvm=/cygdrive/d/dev/software/llvm-x64/
#
# Run this script as follows:
#
#  time /cygdrive/d/dev/repos/scratchpad/scripts/java/cygwin/build-x64.sh
#

timestamp=`date +%Y-%m-%d_%H%M-%S`

# TODO: make these configurable
debug_level=slowdebug
build_hsdis=1
llvm_path=/cygdrive/d/dev/software/llvm-x64

echo "Starting build at $timestamp"

images_log="build/abi-x64-${timestamp}.txt"
jtreg_native_log="build/test-x64-${timestamp}.txt"

images_zip="jdk-x64-${timestamp}.zip"
test_zip="test-x64-${timestamp}.zip"

echo "Building images"
make images CONF=$debug_level LOG=debug > $images_log

echo "Building jtreg native binaries"
make build-test-jdk-jtreg-native CONF=$debug_level LOG=debug > $jtreg_native_log

built_jdk="build/windows-x86_64-server-${debug_level}/jdk/"

if [ $build_hsdis -ne 0 ]; then
    hsdis_build_log="build/hsdis_build-x64-${timestamp}.txt"
    hsdis_install_log="build/hsdis_install-x64-${timestamp}.txt"

    echo "Building hsdis"
    make build-hsdis CONF=$debug_level LOG=debug > $hsdis_build_log

    echo "Installing hsdis"
    make install-hsdis CONF=$debug_level LOG=debug > $hsdis_install_log

    cp "${llvm_path}/bin/LLVM-C.dll" "${built_jdk}/bin"
fi

echo "Zipping the JDK"
cd $built_jdk
zip -qru $images_zip .
mv $images_zip ..

echo "Zipping support/test"
cd ..
zip -qru $test_zip support/test

completion_time=`date +%Y-%m-%d_%H%M-%S`
echo "Completing build at $completion_time"

#!/bin/bash
export jdk21u_BOOT_JDK_TAG=jdk-21.0.9+10
export jdk21u_BOOT_JDK_PATH=/cygdrive/c/java/binaries/jdk/aarch64/2025-10/windows-jdk21u/$jdk21u_BOOT_JDK_TAG
export jdk21u_OPENJDK_REPO_PATH=/cygdrive/c/java/ms/openjdk-jdk21u

export jdk25u_BOOT_JDK_TAG=jdk-25.0.1+8
export jdk25u_BOOT_JDK_PATH=/cygdrive/c/java/binaries/jdk/aarch64/2025-10/windows-jdk25u/$jdk25u_BOOT_JDK_TAG
export jdk25u_OPENJDK_REPO_PATH=/cygdrive/c/java/ms/openjdk-jdk25u

# Set variables based on JDK version argument (default to jdk25u)
JDK_VERSION=${1:-jdk25u}

case $JDK_VERSION in
    jdk21u)
        export BOOT_JDK_TAG=$jdk21u_BOOT_JDK_TAG
        export BOOT_JDK_PATH=$jdk21u_BOOT_JDK_PATH
        export OPENJDK_REPO_PATH=$jdk21u_OPENJDK_REPO_PATH
        ;;
    jdk25u)
        export BOOT_JDK_TAG=$jdk25u_BOOT_JDK_TAG
        export BOOT_JDK_PATH=$jdk25u_BOOT_JDK_PATH
        export OPENJDK_REPO_PATH=$jdk25u_OPENJDK_REPO_PATH
        ;;
    *)
        echo "Unknown JDK version: $JDK_VERSION"
        echo "Usage: $0 [jdk21u|jdk25u] [--configure]"
        exit 1
        ;;
esac

export JTREG_VER=8.1+1
export JTREG_PATH=/cygdrive/c/java/binaries/jtreg/jtreg-$JTREG_VER
export GTEST_PATH=/cygdrive/c/repos/googletest
export OPENJDK_DEBUG_LEVEL=slowdebug

echo -e "\nChanging current directory to $OPENJDK_REPO_PATH\n"
cd $OPENJDK_REPO_PATH

if [[ "$2" == "--configure" ]]; then
    date; time bash configure                    \
        --with-debug-level=$OPENJDK_DEBUG_LEVEL  \
        --with-jtreg=$JTREG_PATH                 \
        --with-gtest=$GTEST_PATH                 \
        --with-extra-ldflags=-profile            \
        --with-boot-jdk=$BOOT_JDK_PATH
fi

time /cygdrive/c/repos/scratchpad/scripts/java/cygwin/build-jdk.sh windows aarch64 $OPENJDK_DEBUG_LEVEL

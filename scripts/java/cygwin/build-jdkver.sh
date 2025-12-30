#!/bin/bash

# Detect current OS
OS_NAME=$(uname -s)
case $OS_NAME in
    CYGWIN*|MINGW*|MSYS*)
        OS="windows"
        PATHPREFIX="/cygdrive/c"
        ;;
    Darwin)
        OS="macosx"
        PATHPREFIX="/Users/saint"
        ;;
    Linux)
        OS="linux"
        PATHPREFIX="/home/saint"
        ;;
    *)
        echo "Unsupported OS: $OS_NAME"
        exit 1
        ;;
esac

# Detect current architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCH="x64"
        ;;
    aarch64|arm64)
        ARCH="aarch64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

export jdk21u_BOOT_JDK_TAG=jdk-21.0.9+10
export jdk21u_BOOT_JDK_PATH=$PATHPREFIX/java/binaries/jdk/$ARCH/2025-10/$OS-jdk21u/$jdk21u_BOOT_JDK_TAG
export jdk21u_OPENJDK_REPO_PATH=$PATHPREFIX/java/ms/openjdk-jdk21u

export jdk25u_BOOT_JDK_TAG=jdk-25.0.1+8
export jdk25u_BOOT_JDK_PATH=$PATHPREFIX/java/binaries/jdk/$ARCH/2025-10/$OS-jdk25u/$jdk25u_BOOT_JDK_TAG
export jdk25u_OPENJDK_REPO_PATH=$PATHPREFIX/java/ms/openjdk-jdk25u

export tip_BOOT_JDK_TAG=jdk-25.0.1+8
export tip_BOOT_JDK_PATH=$PATHPREFIX/java/binaries/jdk/$ARCH/2025-10/$OS-jdk25u/$tip_BOOT_JDK_TAG
export tip_OPENJDK_REPO_PATH=$PATHPREFIX/java/ms/openjdk-jdk
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
    tip)
        export BOOT_JDK_TAG=$tip_BOOT_JDK_TAG
        export BOOT_JDK_PATH=$tip_BOOT_JDK_PATH
        export OPENJDK_REPO_PATH=$tip_OPENJDK_REPO_PATH
        ;;
    *)
        echo "Unknown JDK version: $JDK_VERSION"
        echo "Usage: $0 [jdk21u|jdk25u] [--configure]"
        exit 1
        ;;
esac

export JTREG_VER=8.1+1
export JTREG_PATH=$PATHPREFIX/java/binaries/jtreg/jtreg-$JTREG_VER
export GTEST_PATH=$PATHPREFIX/repos/googletest
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

# Change $ARCH if you want to build for a different architecture than the current one
time $PATHPREFIX/repos/scratchpad/scripts/java/cygwin/build-jdk.sh $OS $ARCH $OPENJDK_DEBUG_LEVEL

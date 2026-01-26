#!/bin/bash

# Detect current OS
OS_NAME=$(uname -s)
case $OS_NAME in
    CYGWIN*|MINGW*|MSYS*)
        OS="windows"
        PATHPREFIX="/cygdrive/c"
        OS_EXTRA_CONFIGURE_ARGS="--with-extra-ldflags=-profile"
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
BUILDARCH=$(uname -m)
case $BUILDARCH in
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

export jdk11u_BOOT_JDK_TAG=jdk-11.0.29+7
export jdk11u_BOOT_JDK_PATH=$PATHPREFIX/java/binaries/jdk/$ARCH/2025-10/$OS-jdk11u/$jdk11u_BOOT_JDK_TAG
export jdk11u_OPENJDK_REPO_PATH=$PATHPREFIX/java/ms/openjdk-jdk11u
# googletest branch: release-1.8.1

export jdk17u_BOOT_JDK_TAG=jdk-17.0.17+10
export jdk17u_BOOT_JDK_PATH=$PATHPREFIX/java/binaries/jdk/$ARCH/2025-10/$OS-jdk17u/$jdk17u_BOOT_JDK_TAG
export jdk17u_OPENJDK_REPO_PATH=$PATHPREFIX/java/ms/openjdk-jdk17u
# googletest branch: release-1.8.1

export jdk18u_BOOT_JDK_TAG=$jdk17u_BOOT_JDK_TAG
export jdk18u_BOOT_JDK_PATH=$jdk17u_BOOT_JDK_PATH
export jdk18u_OPENJDK_REPO_PATH=$PATHPREFIX/java/forks/openjdk/jdk
# googletest branch: release-1.8.1

export jdk19u_BOOT_JDK_TAG=jdk-19.0.2+7
export jdk19u_BOOT_JDK_PATH=$PATHPREFIX/java/binaries/jdk/$ARCH/adoptium/$jdk19u_BOOT_JDK_TAG
export jdk19u_OPENJDK_REPO_PATH=$PATHPREFIX/java/forks/openjdk/jdk
# googletest branch: release-1.8.1

export jdk21u_BOOT_JDK_TAG=jdk-21.0.9+10
export jdk21u_BOOT_JDK_PATH=$PATHPREFIX/java/binaries/jdk/$ARCH/2025-10/$OS-jdk21u/$jdk21u_BOOT_JDK_TAG
export jdk21u_OPENJDK_REPO_PATH=$PATHPREFIX/java/ms/openjdk-jdk21u
# googletest branch: v1.14.0

export jdk25u_BOOT_JDK_TAG=jdk-25.0.1+8
export jdk25u_BOOT_JDK_PATH=$PATHPREFIX/java/binaries/jdk/$ARCH/2025-10/$OS-jdk25u/$jdk25u_BOOT_JDK_TAG
export jdk25u_OPENJDK_REPO_PATH=$PATHPREFIX/java/ms/openjdk-jdk25u
# googletest branch: v1.14.0

export tip_BOOT_JDK_TAG=jdk-25.0.1+8
export tip_BOOT_JDK_PATH=$PATHPREFIX/java/binaries/jdk/$ARCH/2025-10/$OS-jdk25u/$tip_BOOT_JDK_TAG
export tip_OPENJDK_REPO_PATH=$PATHPREFIX/java/ms/openjdk-jdk
# googletest branch: v1.14.0

# Set variables based on JDK version argument (default to jdk25u)
JDK_VERSION=${1:-jdk25u}

case $JDK_VERSION in
    jdk11u)
        export BOOT_JDK_TAG=$jdk11u_BOOT_JDK_TAG
        export BOOT_JDK_PATH=$jdk11u_BOOT_JDK_PATH
        export OPENJDK_REPO_PATH=$jdk11u_OPENJDK_REPO_PATH
        ;;
    jdk17u)
        export BOOT_JDK_TAG=$jdk17u_BOOT_JDK_TAG
        export BOOT_JDK_PATH=$jdk17u_BOOT_JDK_PATH
        export OPENJDK_REPO_PATH=$jdk17u_OPENJDK_REPO_PATH
        ;;
    jdk18u)
        export BOOT_JDK_TAG=$jdk18u_BOOT_JDK_TAG
        export BOOT_JDK_PATH=$jdk18u_BOOT_JDK_PATH
        export OPENJDK_REPO_PATH=$jdk18u_OPENJDK_REPO_PATH
        ;;
    jdk19u)
        export BOOT_JDK_TAG=$jdk19u_BOOT_JDK_TAG
        export BOOT_JDK_PATH=$jdk19u_BOOT_JDK_PATH
        export OPENJDK_REPO_PATH=$jdk19u_OPENJDK_REPO_PATH
        ;;
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
export OPENJDK_VARIANT=server
export BUILD_HSDIS=0

echo -e "\nChanging current directory to $OPENJDK_REPO_PATH\n"
cd $OPENJDK_REPO_PATH

LLVM_PATH=$PATHPREFIX/repos/llvm/llvm-project/build_llvm_AArch64/install_local_release_21.x
LLVM_EXTRA_CONFIGURE_ARGS="--with-hsdis=llvm --with-llvm=$LLVM_PATH"
WIN_AARCH64_CROSS_COMPILE_EXTRA_CONFIGURE_ARGS="--openjdk-target=aarch64-unknown-cygwin"
EXTRA_CONFIGURE_ARGS="$OS_EXTRA_CONFIGURE_ARGS"

if [[ "$2" == "--configure" ]]; then
    date; time bash configure                    \
        --with-debug-level=$OPENJDK_DEBUG_LEVEL  \
        --with-jtreg=$JTREG_PATH                 \
        --with-gtest=$GTEST_PATH                 \
        --with-boot-jdk=$BOOT_JDK_PATH           \
        $EXTRA_CONFIGURE_ARGS
fi

# Change $ARCH if you want to build for a different architecture than the current one
time $PATHPREFIX/repos/scratchpad/scripts/java/cygwin/build-jdk.sh $OS $BUILDARCH $OPENJDK_DEBUG_LEVEL $OPENJDK_VARIANT $BUILD_HSDIS

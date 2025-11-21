export JTREG_VER=8.1+1
export BOOT_JDK_TAG=jdk-25+36
export BOOT_JDK_PATH=/cygdrive/c/java/binaries/jdk/aarch64/2025-09/windows-jdk25u/$BOOT_JDK_TAG
export JTREG_PATH=/cygdrive/c/java/binaries/jtreg/jtreg-$JTREG_VER
export GTEST_PATH=/cygdrive/c/repos/googletest
export OPENJDK_REPO_PATH=/cygdrive/c/java/ms/openjdk-jdk25u

echo -e "\nChanging current directory to $OPENJDK_REPO_PATH\n"
cd $OPENJDK_REPO_PATH

if [[ "$1" == "--configure" ]]; then
    date; time bash configure         \
        --with-debug-level=slowdebug  \
        --with-jtreg=$JTREG_PATH      \
        --with-gtest=$GTEST_PATH      \
        --with-extra-ldflags=-profile \
        --with-boot-jdk=$BOOT_JDK_PATH
fi

time /cygdrive/c/repos/scratchpad/scripts/java/cygwin/build-jdk.sh windows aarch64 slowdebug

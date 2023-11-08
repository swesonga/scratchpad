# Run using this command:
# time /cygdrive/c/repos/scratchpad/scripts/java/cygwin/aqa-tests-jdk21.sh

# export TEST_JDK_HOME=/cygdrive/c/java/binaries/jdk/aarch64/jdk-21.0.1+12
# export TESTIMAGE_PATH=/cygdrive/c/java/binaries/jdk/aarch64/jdk-21.0.1+12-test-image
export TEST_JDK_HOME=C:\\java\\binaries\\jdk\\aarch64\\jdk-21.0.1+12
export TESTIMAGE_PATH=C:\\java\\binaries\\jdk\\aarch64\\jdk-21.0.1+12-test-image
export USE_TESTENV_PROPERTIES=true BUILD_LIST=openjdk

mkdir -p /cygdrive/c/java/aqa/2023-10/jdk21
cd /cygdrive/c/java/aqa/2023-10/jdk21

git clone --depth 1 -b v0.9.7-release https://github.com/adoptium/aqa-tests.git
cd aqa-tests/openjdk

git clone --depth 1 -q --reference-if-able $HOME/openjdk_cache -b jdk-21.0.1+12 https://github.com/adoptium/jdk21u.git openjdk-jdk
cd ../

./get.sh
./compile.sh
cd TKG
make _jdk_security3_0

# export TEST_JDK_HOME=/cygdrive/c/java/binaries/jdk/aarch64/jdk-11.0.19+7
# export TESTIMAGE_PATH=/cygdrive/c/java/binaries/jdk/aarch64/jdk-11.0.19+7-test-image
export TEST_JDK_HOME=C:\\java\\binaries\\jdk\\aarch64\\jdk-11.0.19+7
export TESTIMAGE_PATH=C:\\java\\binaries\\jdk\\aarch64\\jdk-11.0.19+7-test-image

mkdir -p /cygdrive/c/java/aqa/apr2023
cd /cygdrive/c/java/aqa/apr2023

git clone --depth 1 -b v0.9.7-release https://github.com/adoptium/aqa-tests.git
cd aqa-tests/openjdk

git clone --depth 1 -q --reference-if-able $HOME/openjdk_cache -b jdk-11.0.19+7 https://github.com/adoptium/jdk11u.git openjdk-jdk
cd ../

./get.sh
./compile.sh
cd TKG
make _jdk_security3_1

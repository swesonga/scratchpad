# TODO: verify these URLs
curl -Lo apache-ant-1.9.16-bin.tar.gz https://dlcdn.apache.org//ant/binaries/apache-ant-1.9.16-bin.tar.gz
curl -Lo ant-contrib-1.0b2-bin.tar.gz https://sourceforge.net/projects/ant-contrib/files/ant-contrib/ant-contrib-1.0b2/ant-contrib-1.0b2-bin.tar.gz/download
tar xzf apache-ant-1.9.16-bin.tar.gz
tar xzf ant-contrib-1.0b2-bin.tar.gz
cp ant-contrib-1.0b2-bin/lib/ant-contrib.jar apache-ant-1.9.16-bin/lib/

export JAVA_HOME=/cygdrive/c/java/binaries/jdk/x64/jdk-21+35
export ANT_HOME=/cygdrive/c/software/apache-ant-1.9.16
export OLD_PATH=$PATH
export PATH=$OLD_PATH:$JAVA_HOME/bin:$ANT_HOME/bin

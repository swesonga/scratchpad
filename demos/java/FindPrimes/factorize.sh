#!/bin/bash
#
lower_lim=3
upper_lim=100

if [ $# -gt 1 ]
then
    lower_lim=$1
    upper_lim=$2
elif [ $# -gt 0 ]
then
    upper_lim=$1
fi

# export JAVA_HOME /c/java/binaries/jdk/x64/jdk-20+36

$JAVA_HOME/bin/javac Factorize.java

for ((i=$lower_lim; i<=$upper_lim; i++))
do
    echo "Factorizing $i"
    $JAVA_HOME/bin/java Factorize $i
    echo "---------------------------------------------------"
done

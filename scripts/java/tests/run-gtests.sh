#!/bin/bash

cd /d/java/ms/openjdk-jdk
cd build/windows-x86_64-server-slowdebug/images/test/hotspot/gtest/server
./gtestLauncher.exe -jdk:/d/java/ms/openjdk-jdk/build/windows-x86_64-server-slowdebug/images/jdk

# To launch the gtests from a bash command line
# /d/java/ms/openjdk-jdk/build/windows-x86_64-server-slowdebug/images/test/hotspot/gtest/server/gtestLauncher.exe -jdk:/d/java/ms/openjdk-jdk/build/windows-x86_64-server-slowdebug/images/jdk

# Some gtests are executed using jtreg. These need the -nativepath argument.
# It should be set to one of the paths mentioned at
# https://github.com/openjdk/jdk/blob/50b17d9846f7727a5f7225e1b093b6bdff909478/test/hotspot/jtreg/gtest/GTestWrapper.java#L49
#
# /c/java/binaries/jdk/x64/jdk-21.0.2+13/bin/java -Xmx512m -jar /c/java/binaries/jtreg-7.3.1/lib/jtreg.jar -agentvm -ignore:quiet -automatic -xml -vmoption:-Xmx512m -timeoutFactor:4 -concurrency:1 -testjdk:/d/java/ms/openjdk-jdk/build/windows-x86_64-server-slowdebug/images/jdk -verbose:fail,error,summary -nativepath:/d/java/ms/openjdk-jdk/build/windows-x86_64-server-slowdebug/images/test/hotspot/jtreg/native test/hotspot/jtreg/gtest/WindowsProcessorGroups.java


# To debug the gtests in Visual Studio
# 1. Open the properties of the project
# 2. Go to Configuration Properties > Debugging
# 3. Enter these values:
#      Command:           D:\java\ms\openjdk-jdk\build\windows-x86_64-server-slowdebug\images\test\hotspot\gtest\server\gtestLauncher.exe
#      Command Arguments: -jdk:D:\java\ms\openjdk-jdk\build\windows-x86_64-server-slowdebug\jdk
#      Working Directory: D:\java\ms\openjdk-jdk\build\windows-x86_64-server-slowdebug\images\test\hotspot\gtest\server

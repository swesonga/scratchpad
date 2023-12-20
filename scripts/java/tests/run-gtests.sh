#!/bin/bash

cd /d/java/ms/openjdk-jdk
cd build/windows-x86_64-server-slowdebug/images/test/hotspot/gtest/server
./gtestLauncher.exe -jdk:/d/java/ms/openjdk-jdk/build/windows-x86_64-server-slowdebug/jdk

# To launch the gtests from a bash command line
# /d/java/ms/openjdk-jdk/build/windows-x86_64-server-slowdebug/images/test/hotspot/gtest/server/gtestLauncher.exe -jdk:/d/java/ms/openjdk-jdk/build/windows-x86_64-server-slowdebug/jdk

# To debug the gtests in Visual Studio
# 1. Open the properties of the project
# 2. Go to Configuration Properties > Debugging
# 3. Enter these values:
#      Command:           D:\java\ms\openjdk-jdk\build\windows-x86_64-server-slowdebug\images\test\hotspot\gtest\server\gtestLauncher.exe
#      Command Arguments: -jdk:D:\java\ms\openjdk-jdk\build\windows-x86_64-server-slowdebug\jdk
#      Working Directory: D:\java\ms\openjdk-jdk\build\windows-x86_64-server-slowdebug\images\test\hotspot\gtest\server

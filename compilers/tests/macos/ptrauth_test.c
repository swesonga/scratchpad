#ifdef USEFULLPATH
#include "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/./MacOSX.sdk/System/Library/Frameworks/Kernel.framework/Versions/A/Headers/ptrauth.h"
#else
#include <ptrauth.h>
#endif

#include <stdio.h>

int main(int argc, char** argv)
{
    printf("Test the ptrauth.h include on macOS\n\n");
    printf("Compile with either of these commands:\n\n");
    printf("    clang++ -Wall -std=c++14 ptrauth_test.c\n\n");
    printf("    clang++ -Wall -std=c++14 -DUSEFULLPATH ptrauth_test.c\n\n");
    return 0;
}

/*
* Test code for investigating behavior of the /volatile compiler option.
*
* - cl /c /Od /volatile:ms volatileflag.cpp
* - dumpbin /disasm /out:volatileflag.asm volatileflag.obj
* - dumpbin /all /out:volatileflag.txt volatileflag.obj
*
* - cl /c /O2 /volatile:ms /Fo"volatileflag-o2.obj" volatileflag.cpp
* - dumpbin /disasm /out:volatileflag-o2.asm volatileflag-o2.obj
* - dumpbin /all /out:volatileflag-o2.txt volatileflag-o2.obj
*
* Tool documentation:
* - https://docs.microsoft.com/en-us/cpp/build/reference/compiler-options
* - https://docs.microsoft.com/en-us/cpp/build/reference/out-dumpbin
*/

#include <stdio.h>

int main()
{
    int val = 42;
    volatile int* result = &val;
    *result = 0xdeadbeef;
}

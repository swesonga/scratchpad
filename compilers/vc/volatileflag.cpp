/*
Test code for investigating behavior of the /volatile compiler option.

cl /c /Od /volatile:iso /Fo"volatileflag-iso.obj" volatileflag.cpp
cl /c /Od /volatile:ms  /Fo"volatileflag-ms.obj"  volatileflag.cpp
dumpbin /disasm /out:volatileflag-iso.asm volatileflag-iso.obj
dumpbin /all    /out:volatileflag-iso.ms  volatileflag-ms.obj

cl /c /O2 /volatile:iso /Fo"volatileflag-iso-o2.obj" volatileflag.cpp
cl /c /O2 /volatile:ms  /Fo"volatileflag-ms-o2.obj"  volatileflag.cpp
dumpbin /disasm /out:volatileflag-iso-o2.asm volatileflag-iso-o2.obj
dumpbin /all    /out:volatileflag-ms-o2.txt  volatileflag-ms-o2.obj

Tool documentation:
- https://docs.microsoft.com/en-us/cpp/build/reference/compiler-options
- https://docs.microsoft.com/en-us/cpp/build/reference/out-dumpbin
*/

#include <stdio.h>

int main()
{
    int val = 42;
    volatile int* result = &val;
    *result = 0xdeadbeef;
}

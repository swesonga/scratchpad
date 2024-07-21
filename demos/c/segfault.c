/*
* Set up Visual Studio ARM64 build command prompt by running:
*
*   "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsamd64_arm64.bat"
*
*   To compile (unoptimized):
       cl segfault.c
       dumpbin /disasm /out:segfault.asm segfault.obj
       dumpbin /all /out:segfault.txt segfault.obj

*   To compile (optimized):
       cl /O2 /Fo"segfault-optimized.obj" segfault.c
       dumpbin /disasm /out:segfault-optimized.asm segfault-optimized.obj
       dumpbin /all /out:segfault-optimized.txt segfault-optimized.obj
*/

#include <stdio.h>

int main()
{
    void* segfault_address = (void*)0xDEAD00000000C0DEULL;
    int x = *(int*)segfault_address;

    printf("x = %d\n", x);
}

/*
* Test code for investigating code generation for variadic functions.
*
* - cl /c /Od aarch64-abi-test-printf-manyargs.cpp
* - dumpbin /disasm /out:printf-abi-many.asm aarch64-abi-test-printf-manyargs.obj
* - dumpbin /all /out:printf-abi-many.txt aarch64-abi-test-printf-manyargs.obj
*
* - cl /c /O2 /Fo"aarch64-abi-test-printf-manyargs-o2.obj" aarch64-abi-test-printf-manyargs.cpp
* - dumpbin /disasm /out:printf-abi-many-o2.asm aarch64-abi-test-printf-manyargs-o2.obj
* - dumpbin /all /out:printf-abi-many-o2.txt aarch64-abi-test-printf-manyargs-o2.obj
*
* Test case author: Saint Wesonga
*
* Tool documentation:
* - https://docs.microsoft.com/en-us/cpp/build/reference/compiler-options
* - https://docs.microsoft.com/en-us/cpp/build/reference/out-dumpbin
*/

#include <stdio.h>

int main()
{
    int result = printf("%.4f,%.4f,%.4f,%s,%.4f,%.4f,%s,%.4f,%.4f,%s,%.4f,%.4f,%s",
                        1.2345, 1.2345, 1.2345, "str1",
                        1.2345, 1.2345, "str2",
                        1.2345, 1.2345, "str3",
                        1.2345, 1.2345, "str4");
}

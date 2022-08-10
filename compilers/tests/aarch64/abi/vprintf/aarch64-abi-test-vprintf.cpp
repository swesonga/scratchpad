/*
* Test code for investigating code generation for variadic functions.
*
* - cl /c /Od xaarch64-abi-test-vprintf.cpp
* - dumpbin /disasm /out:vprintf-abi.asm aarch64-abi-test-vprintf.obj
* - dumpbin /all /out:vprintf-abi.txt aarch64-abi-test-vprintf.obj
*
* - cl /c /O2 /Fo"aarch64-abi-test-vprintf-o2.obj" aarch64-abi-test-vprintf.cpp
* - dumpbin /disasm /out:vprintf-abi-o2.asm aarch64-abi-test-vprintf-o2.obj
* - dumpbin /all /out:vprintf-abi-o2.txt aarch64-abi-test-vprintf-o2.obj
*
* Test case author: Saint Wesonga
*/

#include <cstdarg>
#include <stdio.h>

// https://stackoverflow.com/questions/1485805/whats-the-difference-between-the-printf-and-vprintf-function-families-and-when
int printmsg(const char* fmt, ...)
{
    va_list args;
    va_start(args, fmt);
    int result = vprintf(fmt, args);
    va_end(args);
    return result;
}

// https://github.com/openjdk/jdk/blob/18cd16d2eae2ee624827eb86621f3a4ffd98fe8c/test/jdk/java/foreign/StdLibTest.java#L314
int main()
{
    int result = printmsg("%.4f,%.4f,%.4f,%s", 1.2345, 1.2345, 1.2345, "str");
}

/*
* To compile using Visual C++:
*
*     cl /TC /WX /std:c17 /permissive- utftest.c
*
* Visual C++ compiler options documentation:
*
*     https://learn.microsoft.com/en-us/cpp/build/reference/compiler-options-listed-alphabetically
*
*     /TC Specifies all source files are C.
*     /WX Treat warnings as errors.
*     /std:c17 C17 standard ISO/IEC 9899:2018.
*     /permissive- Set standard-conformance mode.
*/

#include <stdio.h>

int main()
{
    printf("☃");
    return 0;
}
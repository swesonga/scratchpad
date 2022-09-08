/*
 * Copyright (c) 2020, Oracle and/or its affiliates. All rights reserved.
 *  DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 *  This code is free software; you can redistribute it and/or modify it
 *  under the terms of the GNU General Public License version 2 only, as
 *  published by the Free Software Foundation.
 *
 *  This code is distributed in the hope that it will be useful, but WITHOUT
 *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 *  version 2 for more details (a copy is included in the LICENSE file that
 *  accompanied this code).
 *
 *  You should have received a copy of the GNU General Public License version
 *  2 along with this work; if not, write to the Free Software Foundation,
 *  Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 *   Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
 *  or visit www.oracle.com if you need additional information or have any
 *  questions.
 *
 */
 
 /*
* Code for investigating MSVC ARM64 ABI code generation.
* Extracted from https://github.com/openjdk/jdk/blob/18cd16d2eae2ee624827eb86621f3a4ffd98fe8c/test/jdk/java/foreign/libVarArgs.c
*
*   Compile using
*       cl /c SimpleVarArgs.c
*       dumpbin /disasm /out:SimpleVarArgs.asm SimpleVarArgs.obj
*       dumpbin /all /out:SimpleVarArgs.txt SimpleVarArgs.obj
*/

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>

typedef void (*writeback_t)(int, void*);

typedef struct {
    writeback_t writeback;
    int* argids;
} call_info;

struct S_D { double p0; };
struct S_DDD { double p0; double p1; double p2; };
struct S_FFF { float p0; float p1; float p2; };

void varargs(call_info* info, int num, ...) {
    va_list a_list;
    va_start(a_list, num);

    struct S_D x = va_arg(a_list, struct S_D);
    printf("%f", x.p0);

    va_end(a_list);
}

void call_S_D()
{
    call_info ci;
    struct S_D struct_double = { 24.0 };
    varargs(&ci, 0x1234, struct_double);
}

void call_S_FFF()
{
    call_info ci;
    struct S_FFF struct_float_3 = { 1234.5, 24.0, 12.0 };
    varargs(&ci, 0x5678, struct_float_3);
}

void call_S_DDD()
{
    call_info ci;
    struct S_DDD struct_double_3 = { 1234.5, 24.0, 12.0 };
    varargs(&ci, 0x5678, struct_double_3);
}

int main()
{
}

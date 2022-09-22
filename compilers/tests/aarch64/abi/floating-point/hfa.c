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
* Derived from https://github.com/openjdk/jdk/blob/18cd16d2eae2ee624827eb86621f3a4ffd98fe8c/test/jdk/java/foreign/libVarArgs.c
*
*   Compile using
*       cl /c hfa.c
*       dumpbin /disasm /out:hfa.asm hfa.obj
*       dumpbin /all /out:hfa.txt hfa.obj
*/

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>

struct S_F { float p0; };
struct S_FF { float p0; float p1; };
struct S_FFF { float p0; float p1; float p2; };
struct S_FFFF { float p0; float p1; float p2; float p3; };

struct S_D { double p0; };
struct S_DD { double p0; double p1; };
struct S_DDD { double p0; double p1; double p2; };
struct S_DDDD { double p0; double p1; double p2; double p3; };

void func_S_F(int flag, struct S_F floats)
{
}

void func_S_FF(int flag, struct S_FF floats)
{
}

void func_S_FFF(int flag, struct S_FFF floats)
{
}

void func_S_FFFF(int flag, struct S_FFFF floats)
{
}

void func_S_D(int flag, struct S_D doubles)
{
}

void func_S_DD(int flag, struct S_DD doubles)
{
}

void func_S_DDD(int flag, struct S_DDD doubles)
{
}

void func_S_DDDD(int flag, struct S_DDDD doubles)
{
}

void call_S_F()
{
    struct S_F struct_float_1 = { 1234.56789012345 };
    func_S_F(0xCAFE0123, struct_float_1);
}

void call_S_FF()
{
    struct S_FF struct_float_2 = { 1234.56789012345, 240.0 };
    func_S_FF(0xCAFE1234, struct_float_2);
}

void call_S_FFF()
{
    struct S_FFF struct_float_3 = { 1234.56789012345, 2400.0, 1200.0 };
    func_S_FFF(0xCAFE2345, struct_float_3);
}

void call_S_FFFF()
{
    struct S_FFFF struct_float_4 = { 1234.56789012345, 24000.0, 12000.0, 3.14159265358979323846 };
    func_S_FFFF(0xCAFE4567, struct_float_4);
}

void call_S_D()
{
    struct S_D struct_double_1 = { 1234.56789012345 };
    func_S_D(0xCAFE5678, struct_double_1);
}

void call_S_DD()
{
    struct S_DD struct_double_2 = { 1234.56789012345, 240.0 };
    func_S_DD(0xCAFE6789, struct_double_2);
}

void call_S_DDD()
{
    struct S_DDD struct_double_3 = { 1234.56789012345, 2400.0, 1200.0 };
    func_S_DDD(0xCAFE7890, struct_double_3);
}

void call_S_DDDD()
{
    struct S_DDDD struct_double_4 = { 1234.56789012345, 24000.0, 12000.0, 3.14159265358979323846 };
    func_S_DDDD(0xCAFE890A, struct_double_4);
}

int main()
{
}

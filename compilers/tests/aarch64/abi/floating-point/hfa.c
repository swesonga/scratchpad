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
* Set up Visual Studio build command prompt by running:
*
*   "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsamd64_arm64.bat"
*
*   To compile (unoptimized):
*       cl /c hfa.c
*       dumpbin /disasm /out:hfa.asm hfa.obj
*       dumpbin /all /out:hfa.txt hfa.obj
*
*   To compile (optimized):
*       cl /c /O2 /Fo"hfa-optimized.obj" hfa.c
*       dumpbin /disasm /out:hfa-optimized.asm hfa-optimized.obj
*       dumpbin /all /out:hfa-optimized.txt hfa-optimized.obj
*
* Variadic function documentation:
*  - https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/va-arg-va-copy-va-end-va-start
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

struct S_I { int p0; };
struct S_II { int p0; int p1; };
struct S_III { int p0; int p1; int p2; };
struct S_IIII { int p0; int p1; int p2; int p3; };

/*
* Struct with 1 float
*/
float func_S_F(int flag, struct S_F floats)
{
    return floats.p0;
}

float variadic_func_S_F(int flag, ...)
{
    va_list argptr;
    va_start(argptr, flag);
    struct S_F floats = va_arg(argptr, struct S_F);
    va_end(argptr);
    
    return floats.p0;
}

float call_S_F()
{
    struct S_F struct_float_1 = { 1234.56789012345 };
    return func_S_F(0xCAFE0123, struct_float_1);
}

float call_variadic_S_F()
{
    struct S_F struct_float_1 = { 1234.56789012345 };
    return variadic_func_S_F(0xCAFE0123, struct_float_1);
}

/*
* Struct with 2 floats
*/
float func_S_FF(int flag, struct S_FF floats)
{
    return floats.p0 + floats.p1;
}

float variadic_func_S_FF(int flag, ...)
{
    va_list argptr;
    va_start(argptr, flag);
    struct S_FF floats = va_arg(argptr, struct S_FF);
    va_end(argptr);
    
    return floats.p0 + floats.p1;
}

float call_S_FF()
{
    struct S_FF struct_float_2 = { 1234.56789012345, 240.0 };
    return func_S_FF(0xCAFE1234, struct_float_2);
}

float call_variadic_S_FF()
{
    struct S_FF struct_float_2 = { 1234.56789012345, 240.0 };
    return variadic_func_S_FF(0xCAFE1234, struct_float_2);
}

/*
* Struct with 3 floats
*/
float func_S_FFF(int flag, struct S_FFF floats)
{
    return floats.p0 + floats.p1 + floats.p2;
}

float variadic_func_S_FFF(int flag, ...)
{
    va_list argptr;
    va_start(argptr, flag);
    struct S_FFF floats = va_arg(argptr, struct S_FFF);
    va_end(argptr);
    
    return floats.p0 + floats.p1 + floats.p2;
}

float call_S_FFF()
{
    struct S_FFF struct_float_3 = { 1234.56789012345, 2400.0, 1200.0 };
    return func_S_FFF(0xCAFE2345, struct_float_3);
}

float call_variadic_S_FFF()
{
    struct S_FFF struct_float_3 = { 1234.56789012345, 2400.0, 1200.0 };
    return variadic_func_S_FFF(0xCAFE2345, struct_float_3);
}

/*
* Struct with 4 floats
*/
float func_S_FFFF(int flag, struct S_FFFF floats)
{
    return floats.p0 + floats.p1 + floats.p2 + floats.p3;
}

float variadic_func_S_FFFF(int flag, ...)
{
    va_list argptr;
    va_start(argptr, flag);
    struct S_FFFF floats = va_arg(argptr, struct S_FFFF);
    va_end(argptr);
    
    return floats.p0 + floats.p1 + floats.p2 + floats.p3;
}

float call_S_FFFF()
{
    struct S_FFFF struct_float_4 = { 1234.56789012345, 24000.0, 12000.0, 3.14159265358979323846 };
    return func_S_FFFF(0xCAFE4567, struct_float_4);
}

float call_variadic_S_FFFF()
{
    struct S_FFFF struct_float_4 = { 1234.56789012345, 24000.0, 12000.0, 3.14159265358979323846 };
    return variadic_func_S_FFFF(0xCAFE4567, struct_float_4);
}

/*
* Struct with 1 double
*/
double func_S_D(int flag, struct S_D doubles)
{
    return doubles.p0;
}

double variadic_func_S_D(int flag, ...)
{
    va_list argptr;
    va_start(argptr, flag);
    struct S_D doubles = va_arg(argptr, struct S_D);
    va_end(argptr);
    
    return doubles.p0;
}

double call_S_D()
{
    struct S_D struct_double_1 = { 1234.56789012345 };
    return func_S_D(0xCAFE5678, struct_double_1);
}

double call_variadic_S_D()
{
    struct S_D struct_double_1 = { 1234.56789012345 };
    return variadic_func_S_D(0xCAFE5678, struct_double_1);
}

/*
* Struct with 2 doubles
*/
double func_S_DD(int flag, struct S_DD doubles)
{
    return doubles.p0 + doubles.p1;
}

double variadic_func_S_DD(int flag, ...)
{
    va_list argptr;
    va_start(argptr, flag);
    struct S_DD doubles = va_arg(argptr, struct S_DD);
    va_end(argptr);
    
    return doubles.p0 + doubles.p1;
}

double call_S_DD()
{
    struct S_DD struct_double_2 = { 1234.56789012345, 240.0 };
    return func_S_DD(0xCAFE6789, struct_double_2);
}

double call_variadic_S_DD()
{
    struct S_DD struct_double_2 = { 1234.56789012345, 240.0 };
    return variadic_func_S_DD(0xCAFE6789, struct_double_2);
}

/*
* Struct with 3 doubles
*/
double func_S_DDD(int flag, struct S_DDD doubles)
{
    return doubles.p0 + doubles.p1 + doubles.p2;
}

double variadic_func_S_DDD(int flag, ...)
{
    va_list argptr;
    va_start(argptr, flag);
    struct S_DDD doubles = va_arg(argptr, struct S_DDD);
    va_end(argptr);
    
    return doubles.p0 + doubles.p1 + doubles.p2;
}

double call_S_DDD()
{
    struct S_DDD struct_double_3 = { 1234.56789012345, 2400.0, 1200.0 };
    return func_S_DDD(0xCAFE7890, struct_double_3);
}

double call_variadic_S_DDD()
{
    struct S_DDD struct_double_3 = { 1234.56789012345, 2400.0, 1200.0 };
    return variadic_func_S_DDD(0xCAFE7890, struct_double_3);
}

/*
* Struct with 4 doubles
*/
double func_S_DDDD(int flag, struct S_DDDD doubles)
{
    return doubles.p0 + doubles.p1 + doubles.p2 + doubles.p3;
}

double variadic_func_S_DDDD(int flag, ...)
{
    va_list argptr;
    va_start(argptr, flag);
    struct S_DDDD doubles = va_arg(argptr, struct S_DDDD);
    va_end(argptr);
    
    return doubles.p0 + doubles.p1 + doubles.p2 + doubles.p3;
}

double call_S_DDDD()
{
    struct S_DDDD struct_double_4 = { 1234.56789012345, 24000.0, 12000.0, 3.14159265358979323846 };
    return func_S_DDDD(0xCAFE890A, struct_double_4);
}

double call_variadic_S_DDDD()
{
    struct S_DDDD struct_double_4 = { 1234.56789012345, 24000.0, 12000.0, 3.14159265358979323846 };
    return variadic_func_S_DDDD(0xCAFE890A, struct_double_4);
}

float sum_struct_hfa_floats(int num_floats, ...)
{
    va_list argptr;
    va_start(argptr, num_floats);

    float sum = 0.0f;

    switch (num_floats)
    {
        case 1: {
            struct S_F floats = va_arg(argptr, struct S_F);
            sum = floats.p0;
            break;
        }
        case 2: {
            struct S_FF floats = va_arg(argptr, struct S_FF);
            sum = floats.p0 + floats.p1;
            break;
        }
        case 3: {
            struct S_FFF floats = va_arg(argptr, struct S_FFF);
            sum = floats.p0 + floats.p1 + floats.p2;
            break;
        }
        case 4: {
            struct S_FFFF floats = va_arg(argptr, struct S_FFFF);
            sum = floats.p0 + floats.p1 + floats.p2 + floats.p3;
            break;
        }
    }

    va_end(argptr);
    return sum;
}

double sum_struct_hfa_doubles(int num_doubles, ...)
{
    va_list argptr;
    va_start(argptr, num_doubles);

    double sum = 0.0f;

    switch (num_doubles)
    {
        case 1: {
            struct S_D doubles = va_arg(argptr, struct S_D);
            sum = doubles.p0;
            break;
        }
        case 2: {
            struct S_DD doubles = va_arg(argptr, struct S_DD);
            sum = doubles.p0 + doubles.p1;
            break;
        }
        case 3: {
            struct S_DDD doubles = va_arg(argptr, struct S_DDD);
            sum = doubles.p0 + doubles.p1 + doubles.p2;
            break;
        }
        case 4: {
            struct S_DDDD doubles = va_arg(argptr, struct S_DDDD);
            sum = doubles.p0 + doubles.p1 + doubles.p2 + doubles.p3;
            break;
        }
    }

    va_end(argptr);
    return sum;
}

float sum_spilled_struct_hfa_floats(int num_floats,
    int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, ...)
{
    va_list argptr;
    va_start(argptr, arg6);

    int sum_of_ints = arg1 + arg2 + arg3 + arg4 + arg5 + arg6;
    float sum = sum_of_ints;

    switch (num_floats)
    {
        case 1: {
            struct S_F floats = va_arg(argptr, struct S_F);
            sum += floats.p0;
            break;
        }
        case 2: {
            struct S_FF floats = va_arg(argptr, struct S_FF);
            sum += floats.p0 + floats.p1;
            break;
        }
        case 3: {
            struct S_FFF floats = va_arg(argptr, struct S_FFF);
            sum += floats.p0 + floats.p1 + floats.p2;
            break;
        }
        case 4: {
            struct S_FFFF floats = va_arg(argptr, struct S_FFFF);
            sum += floats.p0 + floats.p1 + floats.p2 + floats.p3;
            break;
        }
    }

    va_end(argptr);
    return sum;
}

double sum_spilled_struct_hfa_doubles(int num_doubles,
    int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, ...)
{
    va_list argptr;
    va_start(argptr, arg6);

    int sum_of_ints = arg1 + arg2 + arg3 + arg4 + arg5 + arg6;
    double sum = sum_of_ints;

    switch (num_doubles)
    {
        case 1: {
            struct S_D doubles = va_arg(argptr, struct S_D);
            sum += doubles.p0;
            break;
        }
        case 2: {
            struct S_DD doubles = va_arg(argptr, struct S_DD);
            sum += doubles.p0 + doubles.p1;
            break;
        }
    }

    va_end(argptr);
    return sum;
}

int sum_spilled_struct_ints(int num_ints,
    int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, ...)
{
    va_list argptr;
    va_start(argptr, arg6);

    int sum = arg1 + arg2 + arg3 + arg4 + arg5 + arg6;

    switch (num_ints)
    {
        case 1: {
            struct S_I data = va_arg(argptr, struct S_I);
            sum += data.p0;
            break;
        }
        case 2: {
            struct S_II data = va_arg(argptr, struct S_II);
            sum += data.p0 + data.p1;
            break;
        }
        case 3: {
            struct S_III data = va_arg(argptr, struct S_III);
            sum += data.p0 + data.p1 + data.p2;
            break;
        }
        case 4: {
            struct S_IIII data = va_arg(argptr, struct S_IIII);
            sum += data.p0 + data.p1 + data.p2 + data.p3;
            break;
        }
    }

    va_end(argptr);
    return sum;
}

int sum_spilled_struct_1int_nonvariadic(int arg0,
    int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, struct S_I data)
{
    int sum = arg0 + arg1 + arg2 + arg3 + arg4 + arg5 + arg6;
    sum += data.p0;
    return sum;
}

int sum_spilled_struct_2ints_nonvariadic(int arg0,
    int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, struct S_II data)
{
    int sum = arg0 + arg1 + arg2 + arg3 + arg4 + arg5 + arg6;
    sum += data.p0 + data.p1;
    return sum;
}

int sum_spilled_struct_3ints_nonvariadic(int arg0,
    int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, struct S_III data)
{
    int sum = arg0 + arg1 + arg2 + arg3 + arg4 + arg5 + arg6;
    sum += data.p0 + data.p1 + data.p2;
    return sum;
}

int sum_spilled_struct_4ints_nonvariadic(int arg0,
    int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, struct S_IIII data)
{
    int sum = arg0 + arg1 + arg2 + arg3 + arg4 + arg5 + arg6;
    sum += data.p0 + data.p1 + data.p2 + data.p3;
    return sum;
}

float sum_spilled_struct_hfa_1float_nonvariadic(float arg0,
    float arg1, float arg2, float arg3, float arg4, float arg5, float arg6, struct S_F floats)
{
    float sum = arg0 + arg1 + arg2 + arg3 + arg4 + arg5 + arg6;
    sum += floats.p0;
    return sum;
}

float sum_spilled_struct_hfa_2floats_nonvariadic(float arg0,
    float arg1, float arg2, float arg3, float arg4, float arg5, float arg6, struct S_FF floats)
{
    float sum = arg0 + arg1 + arg2 + arg3 + arg4 + arg5 + arg6;
    sum += floats.p0 + floats.p1;
    return sum;
}

float sum_spilled_struct_hfa_3floats_nonvariadic(float arg0,
    float arg1, float arg2, float arg3, float arg4, float arg5, float arg6, struct S_FFF floats)
{
    float sum = arg0 + arg1 + arg2 + arg3 + arg4 + arg5 + arg6;
    sum += floats.p0 + floats.p1 + floats.p2;
    return sum;
}

float sum_spilled_struct_hfa_4floats_nonvariadic(float arg0,
    float arg1, float arg2, float arg3, float arg4, float arg5, float arg6, struct S_FFFF floats)
{
    float sum = arg0 + arg1 + arg2 + arg3 + arg4 + arg5 + arg6;
    sum += floats.p0 + floats.p1 + floats.p2 + floats.p3;
    return sum;
}

float sum_spilled_nonvariadic_struct_hfa_floats_to_variadic_func(int num_floats,
    int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, struct S_FFFF arg7, ...)
{
    va_list argptr;
    va_start(argptr, arg7);

    int sum_of_ints = arg1 + arg2 + arg3 + arg4 + arg5 + arg6;
    float sum = sum_of_ints + arg7.p0 + arg7.p1 + arg7.p2 + arg7.p3;

    switch (num_floats)
    {
        case 1: {
            struct S_F floats = va_arg(argptr, struct S_F);
            sum += floats.p0;
            break;
        }
        case 2: {
            struct S_FF floats = va_arg(argptr, struct S_FF);
            sum += floats.p0 + floats.p1;
            break;
        }
        case 3: {
            struct S_FFF floats = va_arg(argptr, struct S_FFF);
            sum += floats.p0 + floats.p1 + floats.p2;
            break;
        }
        case 4: {
            struct S_FFFF floats = va_arg(argptr, struct S_FFFF);
            sum += floats.p0 + floats.p1 + floats.p2 + floats.p3;
            break;
        }
    }

    va_end(argptr);
    return sum;
}

float sum_spilled_struct_hfa_3floats_variadic(float arg0,
    float arg1, float arg2, float arg3, float arg4, float arg5, float arg6, struct S_FFF floats, ...)
{
    float sum = arg0 + arg1 + arg2 + arg3 + arg4 + arg5 + arg6;
    sum += floats.p0 + floats.p1 + floats.p2;
    return sum;
}

int main()
{
    /*
    struct S_DDDD struct_double_4 = { 1.2, 3.4, 4.5, 5.6 };
    float sum1 = func_S_DDDD(0xCAFE890A, struct_double_4);
    float sum2 = sum_struct_hfa_doubles(4, struct_double_4);
    printf("sum1 = %f\nsum2 = %f\n", sum1, sum2);
    */
    struct S_FFFF struct_f4 = { 1.2f, 3.4f, 4.5f, 5.6f };
    float sum1 = func_S_FFFF(0xCAFE890A, struct_f4);
    float sum2 = sum_spilled_struct_hfa_floats(4, 2, 3, 4, 5, 6, 7, struct_f4);
    printf("sum1 = %f\nsum2 = %f\n", sum1, sum2);

    struct S_FFFF struct_arg7 = { 6.7f, 7.8f, 8.9f, 9.0f };
    float sum3 = sum_spilled_nonvariadic_struct_hfa_floats_to_variadic_func(4, 1, 2, 3, 4, 5, 6, struct_arg7, struct_f4);
    printf("sum3 = %f\n", sum3);

    struct S_FFF struct_f3 = { 3.4f, 4.5f, 5.6f };
    float sum4 = sum_spilled_struct_hfa_3floats_variadic(0, 10, 20, 30, 40, 50, 60, struct_f3, struct_f4);
    printf("sum4 = %f\n", sum4);
}

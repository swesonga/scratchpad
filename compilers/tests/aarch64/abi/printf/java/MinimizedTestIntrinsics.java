/*
 *  Copyright (c) 2020, 2022, Oracle and/or its affiliates. All rights reserved.
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
 *  Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
 *  or visit www.oracle.com if you need additional information or have any
 *  questions.
 */

/*
* Extracted from https://github.com/openjdk/jdk/blob/18cd16d2eae2ee624827eb86621f3a4ffd98fe8c/test/jdk/java/foreign/TestIntrinsics.java
* by removing testng dependencies
*
* - javac --enable-preview --release 20 MinimizedTestIntrinsics.java
* - java --enable-preview MinimizedTestIntrinsics
*
* Related Documentation:
* - https://nipafx.dev/enable-preview-language-features/
*/

import java.lang.foreign.Addressable;
import java.lang.foreign.Linker;
import java.lang.foreign.FunctionDescriptor;
import java.lang.foreign.ValueLayout;
import java.lang.foreign.SymbolLookup;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodType;
import java.util.ArrayList;
import java.util.List;

import java.lang.foreign.MemoryLayout;

import static java.lang.invoke.MethodType.methodType;
import static java.lang.foreign.ValueLayout.JAVA_CHAR;

public class MinimizedTestIntrinsics {
    public static final ValueLayout.OfBoolean C_BOOL = ValueLayout.JAVA_BOOLEAN;
    public static final ValueLayout.OfByte C_CHAR = ValueLayout.JAVA_BYTE;
    public static final ValueLayout.OfShort C_SHORT = ValueLayout.JAVA_SHORT.withBitAlignment(16);
    public static final ValueLayout.OfInt C_INT = ValueLayout.JAVA_INT.withBitAlignment(32);
    public static final ValueLayout.OfLong C_LONG_LONG = ValueLayout.JAVA_LONG.withBitAlignment(64);
    public static final ValueLayout.OfFloat C_FLOAT = ValueLayout.JAVA_FLOAT.withBitAlignment(32);
    public static final ValueLayout.OfDouble C_DOUBLE = ValueLayout.JAVA_DOUBLE.withBitAlignment(64);

    static final Linker abi = Linker.nativeLinker();
    static {
        System.loadLibrary("Intrinsics");
    }

    public static Addressable findNativeOrThrow(String name) {
        return SymbolLookup.loaderLookup().lookup(name).orElseThrow();
    }

    public static void main(String[] args) throws Throwable {
        var abiTests = tests();
        for (int i = 0; i < abiTests.size(); i++) {
            testIntrinsics(abiTests.get(i));
        }
    }

    private static void assertEquals(Object found, Object expected) throws Exception {
        if (found != expected) {
            throw new Exception("Expected " + expected + " but found " + found);
        }
    }

    private interface RunnableX {
        void run() throws Throwable;
    }

    public static void testIntrinsics(RunnableX test) throws Throwable {
        for (int i = 0; i < 20_000; i++) {
            test.run();
        }
    }

    public static List<RunnableX> tests() {
        List<RunnableX> testsList = new ArrayList<>();

        interface AddTest {
            void add(MethodHandle target, Object expectedResult, Object... args);
        }

        AddTest tests = (mh, expectedResult, args) -> testsList.add(() -> {
            Object actual = mh.invokeWithArguments(args);
            assertEquals(actual, expectedResult);
        });

        interface AddIdentity {
            void add(String name, Class<?> carrier, MemoryLayout layout, Object arg);
        }

        AddIdentity addIdentity = (name, carrier, layout, arg) -> {
            Addressable ma = findNativeOrThrow(name);
            MethodType mt = methodType(carrier, carrier);
            FunctionDescriptor fd = FunctionDescriptor.of(layout, layout);

            tests.add(abi.downcallHandle(ma, fd), arg, arg);
            tests.add(abi.downcallHandle(fd), arg, ma, arg);
        };

        { // empty
            Addressable ma = findNativeOrThrow("empty");
            MethodType mt = methodType(void.class);
            FunctionDescriptor fd = FunctionDescriptor.ofVoid();
            tests.add(abi.downcallHandle(ma, fd), null);
        }

        addIdentity.add("identity_bool",   boolean.class, C_BOOL,   true);
        addIdentity.add("identity_char",   byte.class,    C_CHAR,   (byte) 10);
        addIdentity.add("identity_short",  short.class,   C_SHORT, (short) 10);
        addIdentity.add("identity_int",    int.class,     C_INT,           10);
        addIdentity.add("identity_long",   long.class,    C_LONG_LONG,     10L);
        addIdentity.add("identity_float",  float.class,   C_FLOAT,         10F);
        addIdentity.add("identity_double", double.class,  C_DOUBLE,        10D);

        { // identity_va
            Addressable ma = findNativeOrThrow("identity_va");
            MethodType mt = methodType(int.class, int.class, double.class, int.class, float.class, long.class);
            FunctionDescriptor fd = FunctionDescriptor.of(C_INT, C_INT).asVariadic(C_DOUBLE, C_INT, C_FLOAT, C_LONG_LONG);
            tests.add(abi.downcallHandle(ma, fd), 1, 1, 10D, 2, 3F, 4L);
        }

        { // high_arity
            MethodType baseMT = methodType(void.class, int.class, double.class, long.class, float.class, byte.class,
                    short.class, char.class);
            FunctionDescriptor baseFD = FunctionDescriptor.ofVoid(C_INT, C_DOUBLE, C_LONG_LONG, C_FLOAT, C_CHAR,
                    C_SHORT, JAVA_CHAR);
            Object[] args = {1, 10D, 2L, 3F, (byte) 0, (short) 13, 'a'};
            for (int i = 0; i < args.length; i++) {
                Addressable ma = findNativeOrThrow("invoke_high_arity" + i);
                MethodType mt = baseMT.changeReturnType(baseMT.parameterType(i));
                FunctionDescriptor fd = baseFD.changeReturnLayout(baseFD.argumentLayouts().get(i));
                Object expected = args[i];
                tests.add(abi.downcallHandle(ma, fd), expected, args);
            }
        }

        return testsList;
    }
}

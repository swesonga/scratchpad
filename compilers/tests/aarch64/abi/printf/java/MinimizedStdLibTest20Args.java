/*
 * Copyright (c) 2020, 2022, Oracle and/or its affiliates. All rights reserved.
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 only, as
 * published by the Free Software Foundation.
 *
 * This code is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * version 2 for more details (a copy is included in the LICENSE file that
 * accompanied this code).
 *
 * You should have received a copy of the GNU General Public License version
 * 2 along with this work; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
 * or visit www.oracle.com if you need additional information or have any
 * questions.
 */

/*
* Test for investigating code generation for variadic functions.
* Extracted from https://github.com/openjdk/jdk/blob/18cd16d2eae2ee624827eb86621f3a4ffd98fe8c/test/jdk/java/foreign/StdLibTest.java#L123-L136
*
* - javac --enable-preview --release 20 MinimizedStdLibTest20Args.java
* - java --enable-preview MinimizedStdLibTest20Args
*
* Related Documentation:
* - https://nipafx.dev/enable-preview-language-features/
*/

import java.lang.foreign.*;
import java.lang.invoke.*;
import java.util.*;
import java.util.function.*;
import java.util.stream.*;

public class MinimizedStdLibTest20Args {
    public static final ValueLayout.OfByte C_CHAR = ValueLayout.JAVA_BYTE;
    public static final ValueLayout.OfInt C_INT = ValueLayout.JAVA_INT.withBitAlignment(32);
    public static final ValueLayout.OfDouble C_DOUBLE = ValueLayout.JAVA_DOUBLE.withBitAlignment(64);
    public static final ValueLayout.OfAddress C_POINTER = ValueLayout.ADDRESS.withBitAlignment(64);

    final static Linker abi = Linker.nativeLinker();
    final static Addressable printfAddr = abi.defaultLookup().lookup("printf").get();
    final static FunctionDescriptor printfBase = FunctionDescriptor.of(C_INT, C_POINTER);

    public static void main(String[] args) throws Throwable {
        var failingPrintfArgs = Arrays.asList(new PrintfArg[] {
            PrintfArg.CHAR, PrintfArg.DOUBLE, PrintfArg.INTEGRAL, PrintfArg.DOUBLE,
            PrintfArg.DOUBLE, PrintfArg.DOUBLE, PrintfArg.DOUBLE, PrintfArg.DOUBLE,
            PrintfArg.DOUBLE, PrintfArg.DOUBLE, PrintfArg.DOUBLE, PrintfArg.DOUBLE,
            PrintfArg.DOUBLE, PrintfArg.DOUBLE, PrintfArg.DOUBLE, PrintfArg.DOUBLE,
            PrintfArg.DOUBLE, PrintfArg.DOUBLE, PrintfArg.DOUBLE, PrintfArg.DOUBLE
         });

        test_printf(failingPrintfArgs);
    }

    private static void assertEquals(int found, int expected) throws Exception {
        if (found != expected) {
            throw new Exception("Expected " + expected + " but found " + found);
        }
    }

    static void test_printf(List<PrintfArg> args) throws Throwable {
        String formatArgs = args.stream().map(a -> a.format).collect(Collectors.joining(","));

        String formatString = "hello(" + formatArgs + ")\n";

        String expected = String.format(formatString, args.stream().map(a -> a.javaValue).toArray());

        int found = printf(formatString, args);

        if (found != expected.length()) {
            System.out.println("--------------------------------------------------------");
            System.out.println("formatString=" + formatString);
            System.out.println("expected=" + expected);
            System.out.println("found length=" + found);
            System.out.println("expected.length()=" + expected.length());
            
            Thread.sleep(3000);
        }

        assertEquals(found, expected.length());
    }

    // DataProvider
    public static Object[][] printfArgs() {
        ArrayList<List<PrintfArg>> res = new ArrayList<>();
        List<List<PrintfArg>> perms = new ArrayList<>(perms(0, PrintfArg.values()));
        for (int i = 0 ; i < 100 ; i++) {
            Collections.shuffle(perms);
            res.addAll(perms);
        }
        return res.stream()
                .map(l -> l.toArray())
                .toArray(Object[][]::new);
    }

    static int printf(String format, List<PrintfArg> args) throws Throwable {
        try (MemorySession session = MemorySession.openConfined()) {
            MemorySegment formatStr = session.allocateUtf8String(format);
            MethodHandle mh = specializedPrintf(args);
            var finalArgs = args.stream().map(a -> a.nativeValue(session)).toArray();
            return (int)mh.invoke(formatStr, finalArgs);
        }
    }

    private static MethodHandle specializedPrintf(List<PrintfArg> args) {
        FunctionDescriptor fd = printfBase;
        List<MemoryLayout> variadicLayouts = new ArrayList<>(args.size());
        for (PrintfArg arg : args) {
            variadicLayouts.add(arg.layout);
        }
        MethodHandle mh = abi.downcallHandle(printfAddr,
                fd.asVariadic(variadicLayouts.toArray(new MemoryLayout[args.size()])));
        return mh.asSpreader(1, Object[].class, args.size());
    }

    enum PrintfArg implements BiConsumer<VaList.Builder, MemorySession> {

        INTEGRAL(int.class, C_INT, "%d", session -> 42, 42, VaList.Builder::addVarg),
        STRING(MemoryAddress.class, C_POINTER, "%s", session -> {
            var segment = MemorySegment.allocateNative(4, session);
            segment.setUtf8String(0, "str");
            return segment.address();
        }, "str", VaList.Builder::addVarg),
        CHAR(byte.class, C_CHAR, "%c", session -> (byte) 'h', 'h',
                (builder, layout, value) -> builder.addVarg(C_INT, (int) value)),
        DOUBLE(double.class, C_DOUBLE, "%.4f", session -> 1.2345d, 1.2345d, VaList.Builder::addVarg);

        final Class<?> carrier;
        final ValueLayout layout;
        final String format;
        final Function<MemorySession, ?> nativeValueFactory;
        final Object javaValue;
        @SuppressWarnings("rawtypes")
        final VaListBuilderCall builderCall;

        <Z, L extends ValueLayout> PrintfArg(Class<?> carrier,
                L layout,
                String format,
                Function<MemorySession, Z> nativeValueFactory,
                Object javaValue,
                VaListBuilderCall<Z, L> builderCall) {
            this.carrier = carrier;
            this.layout = layout;
            this.format = format;
            this.nativeValueFactory = nativeValueFactory;
            this.javaValue = javaValue;
            this.builderCall = builderCall;
        }

        @Override
        @SuppressWarnings("unchecked")
        public void accept(VaList.Builder builder, MemorySession session) {
            builderCall.build(builder, layout, nativeValueFactory.apply(session));
        }

        interface VaListBuilderCall<V, L> {
            void build(VaList.Builder builder, L layout, V value);
        }

        public Object nativeValue(MemorySession session) {
            return nativeValueFactory.apply(session);
        }
    }

    static <Z> Set<List<Z>> perms(int count, Z[] arr) {
        if (count == arr.length) {
            return Set.of(List.of());
        }

        return Arrays.stream(arr)
                .flatMap(num -> {
                    Set<List<Z>> perms = perms(count + 1, arr);
                    return Stream.concat(
                            //take n
                            perms.stream().map(l -> {
                                List<Z> li = new ArrayList<>(l);
                                li.add(num);
                                return li;
                            }),
                            //drop n
                            perms.stream());
                }).collect(Collectors.toCollection(LinkedHashSet::new));
    }
}

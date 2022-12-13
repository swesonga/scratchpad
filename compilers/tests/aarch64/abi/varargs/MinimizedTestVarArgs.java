/*
 * Copyright (c) 2020, 2022, Oracle and/or its affiliates. All rights reserved.
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
* Extracted from https://github.com/openjdk/jdk/blob/18cd16d2eae2ee624827eb86621f3a4ffd98fe8c/test/jdk/java/foreign/TestVarArgs.java
* by removing base classes and testng dependencies
*
* - javac --enable-preview --release 20 MinimizedTestVarArgs.java
* - java --enable-preview MinimizedTestVarArgs
*
* Related Documentation:
* - https://nipafx.dev/enable-preview-language-features/
*/

import java.lang.foreign.Arena;
import java.lang.foreign.Linker;
import java.lang.foreign.FunctionDescriptor;
import java.lang.foreign.GroupLayout;
import java.lang.foreign.MemoryLayout;
import java.lang.foreign.MemorySegment;
import java.lang.foreign.MemorySession;
import java.lang.foreign.PaddingLayout;
import java.lang.foreign.SymbolLookup;
import java.lang.foreign.ValueLayout;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.lang.invoke.VarHandle;

import java.util.ArrayList;
import java.util.List;
import java.util.Stack;
import java.util.stream.Collectors;
import java.util.function.Consumer;

import static java.lang.foreign.MemoryLayout.PathElement.*;

public class MinimizedTestVarArgs {
    public static final ValueLayout.OfInt C_INT = ValueLayout.JAVA_INT.withBitAlignment(32);
    public static final ValueLayout.OfAddress C_POINTER = ValueLayout.ADDRESS.withBitAlignment(64);
    public static final ValueLayout.OfFloat C_FLOAT = ValueLayout.JAVA_FLOAT.withBitAlignment(32);
    public static final ValueLayout.OfDouble C_DOUBLE = ValueLayout.JAVA_DOUBLE.withBitAlignment(64);

    static final int SAMPLE_FACTOR = Integer.parseInt((String)System.getProperties().getOrDefault("generator.sample.factor", "-1"));

    static final int MAX_FIELDS = 3;
    static final int MAX_PARAMS = 3;
    static final int CHUNK_SIZE = 600;

    static final VarHandle VH_IntArray = C_INT.arrayElementVarHandle();
    static final MethodHandle MH_CHECK;

    static final Linker LINKER = Linker.nativeLinker();
    static {
        System.loadLibrary("VarArgs");
        try {
            MH_CHECK = MethodHandles.lookup().findStatic(MinimizedTestVarArgs.class, "check",
                    MethodType.methodType(void.class, int.class, MemorySegment.class, List.class));
        } catch (ReflectiveOperationException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    public static MemorySegment findNativeOrThrow(String name) {
        return SymbolLookup.loaderLookup().find(name).orElseThrow();
    }

    static final MemorySegment VARARGS_ADDR = findNativeOrThrow("varargs");

    private static void assertEquals(Object found, Object expected) throws Exception {
        if (found != expected &&
            ((found != null && !found.equals(expected)) ||
             (expected != null && !expected.equals(found)))) {
            throw new Exception("Expected " + expected + " but found " + found);
        }
    }

    private static void assertTrue(boolean condition) throws Exception {
        assertEquals(condition, true);
    }

    public static boolean isIntegral(MemoryLayout layout) {
        return layout instanceof ValueLayout valueLayout && isIntegral(valueLayout.carrier());
    }

    static boolean isIntegral(Class<?> clazz) {
        return clazz == byte.class || clazz == char.class || clazz == short.class
                || clazz == int.class || clazz == long.class;
    }

    public static boolean isPointer(MemoryLayout layout) {
        return layout instanceof ValueLayout valueLayout && valueLayout.carrier() == MemorySegment.class;
    }

    public static void main(String[] args) throws Throwable {
        var tests = functions();
        for (int i = 0; i < tests.length; i++) {
            var params = tests[i];

            int count = (int)params[0];
            String fName = (String)params[1];
            Ret ret = (Ret)params[2];
            List<ParamType> paramTypes = (List<ParamType>)params[3];
            List<StructFieldType> fields = (List<StructFieldType>)params[4];

            System.out.print("Starting test " + i + " for " + fName + " ... ");
            // if ("f0_V_S_FFF".equals(fName))
            testVarArgs(count, fName, ret, paramTypes, fields);
            System.out.println("Finished test " + i + " for " + fName);
        }

        System.out.println("Test complete");
    }

    public static void testVarArgs(int count, String fName, Ret ret, // ignore this stuff
                            List<ParamType> paramTypes, List<StructFieldType> fields) throws Throwable {
        List<Arg> args = makeArgs(paramTypes, fields, fName);

        try (Arena arena = Arena.openConfined()) {
            MethodHandle checker = MethodHandles.insertArguments(MH_CHECK, 2, args);
            MemorySegment writeBack = LINKER.upcallStub(checker, FunctionDescriptor.ofVoid(C_INT, C_POINTER), arena.session());
            MemorySegment callInfo = MemorySegment.allocateNative(CallInfo.LAYOUT, arena.session());;
            MemorySegment argIDs = MemorySegment.allocateNative(MemoryLayout.sequenceLayout(args.size(), C_INT), arena.session());;

            MemorySegment callInfoPtr = callInfo;

            CallInfo.writeback(callInfo, writeBack);
            CallInfo.argIDs(callInfo, argIDs);

            for (int i = 0; i < args.size(); i++) {
                VH_IntArray.set(argIDs, (long) i, args.get(i).id.ordinal());
            }

            List<MemoryLayout> argLayouts = new ArrayList<>();
            argLayouts.add(C_POINTER); // call info
            argLayouts.add(C_INT); // size

            FunctionDescriptor baseDesc = FunctionDescriptor.ofVoid(argLayouts.toArray(MemoryLayout[]::new));
            Linker.Option varargIndex = Linker.Option.firstVariadicArg(baseDesc.argumentLayouts().size());
            FunctionDescriptor desc = baseDesc.appendArgumentLayouts(args.stream().map(a -> a.layout).toArray(MemoryLayout[]::new));

            MethodHandle downcallHandle = LINKER.downcallHandle(VARARGS_ADDR, desc, varargIndex);

            List<Object> argValues = new ArrayList<>();
            argValues.add(callInfoPtr); // call info
            argValues.add(args.size());  // size
            args.forEach(a -> argValues.add(a.value));

            downcallHandle.invokeWithArguments(argValues);

            // args checked by upcall
        }
    }

    private static List<Arg> makeArgs(List<ParamType> paramTypes, List<StructFieldType> fields, String fName) throws Exception {
        List<Arg> args = new ArrayList<>();
        for (ParamType pType : paramTypes) {
            MemoryLayout layout = pType.layout(fields);
            List<Consumer<Object>> checks = new ArrayList<>();
            Object arg = makeArg(layout, checks, true, fName);
            Arg.NativeType type = Arg.NativeType.of(pType.type(fields));
            args.add(pType == ParamType.STRUCT
                ? Arg.structArg(type, layout, arg, checks)
                : Arg.primitiveArg(type, layout, arg, checks));
        }
        return args;
    }

    //helper methods from CallGeneratorHelper

    @SuppressWarnings("unchecked")
    static Object makeArg(MemoryLayout layout, List<Consumer<Object>> checks, boolean check, String fName) throws Exception {
        if (layout instanceof GroupLayout) {
            MemorySegment segment = MemorySegment.allocateNative(layout, MemorySession.implicit());
            initStruct(segment, (GroupLayout)layout, checks, check, fName);
            return segment;
        } else if (isPointer(layout)) {
            MemorySegment segment = MemorySegment.allocateNative(1L, MemorySession.implicit());
            if (check) {
                checks.add(o -> {
                    try {
                        assertEquals(o, segment);
                    } catch (Throwable ex) {
                        throw new IllegalStateException(ex);
                    }
                });
            }
            return segment;
        } else if (layout instanceof ValueLayout) {
            if (isIntegral(layout)) {
                if (check) {
                    checks.add(o -> {
                        try {
                            assertEquals(o, 42);
                        } catch (Exception ex) {
                            System.err.println(fName + " " + ex);
                        }
                    });
                }
                return 42;
            } else if (layout.bitSize() == 32) {
                if (check) {
                    checks.add(o -> {
                        try {
                            assertEquals(o, 12f);
                        } catch (Exception ex) {
                            System.err.println(fName + " " + ex);
                        }
                    });
                }
                return 12f;
            } else {
                if (check) {
                    checks.add(o -> {
                        try {
                            assertEquals(o, 24d);
                        } catch (Exception ex) {
                            System.err.println(fName + " " + ex);
                        }
                    });
                }
                return 24d;
            }
        } else {
            throw new IllegalStateException("Unexpected layout: " + layout);
        }
    }

    static void initStruct(MemorySegment str, GroupLayout g, List<Consumer<Object>> checks, boolean check, String fName) throws Exception {
        for (MemoryLayout l : g.memberLayouts()) {
            if (l instanceof PaddingLayout) continue;
            VarHandle accessor = g.varHandle(MemoryLayout.PathElement.groupElement(l.name().get()));
            List<Consumer<Object>> fieldsCheck = new ArrayList<>();
            Object value = makeArg(l, fieldsCheck, check, fName);
            //set value
            accessor.set(str, value);
            //add check
            if (check) {
                assertTrue(fieldsCheck.size() == 1);
                checks.add(o -> {
                    MemorySegment actual = (MemorySegment)o;
                    try {
                        fieldsCheck.get(0).accept(accessor.get(actual));
                    } catch (Throwable ex) {
                        throw new IllegalStateException(ex);
                    }
                });
            }
        }
    }

    private static void check(int index, MemorySegment ptr, List<Arg> args) throws Exception {
        Arg varArg = args.get(index);
        MemoryLayout layout = varArg.layout;
        MethodHandle getter = varArg.getter;
        List<Consumer<Object>> checks = varArg.checks;
        try (Arena arena = Arena.openConfined()) {
            MemorySegment seg = MemorySegment.ofAddress(ptr.address(), layout.byteSize(), arena.session());
            Object obj = getter.invoke(seg);
            checks.forEach(check -> check.accept(obj));
        } catch (Throwable e) {
            throw new Exception(e);
        }
    }

    private static class CallInfo {
        static final MemoryLayout LAYOUT = MemoryLayout.structLayout(
                C_POINTER.withName("writeback"), // writeback
                C_POINTER.withName("argIDs")); // arg ids

        static final VarHandle VH_writeback = LAYOUT.varHandle(groupElement("writeback"));
        static final VarHandle VH_argIDs = LAYOUT.varHandle(groupElement("argIDs"));

        static void writeback(MemorySegment seg, MemorySegment addr) {
            VH_writeback.set(seg, addr);
        }
        static void argIDs(MemorySegment seg, MemorySegment addr) {
            VH_argIDs.set(seg, addr);
        }
    }

    private static final class Arg {
        final NativeType id;
        final MemoryLayout layout;
        final Object value;
        final MethodHandle getter;
        final List<Consumer<Object>> checks;

        private Arg(NativeType id, MemoryLayout layout, Object value, MethodHandle getter, List<Consumer<Object>> checks) {
            this.id = id;
            this.layout = layout;
            this.value = value;
            this.getter = getter;
            this.checks = checks;
        }

        private static Arg primitiveArg(NativeType id, MemoryLayout layout, Object value, List<Consumer<Object>> checks) {
            return new Arg(id, layout, value, layout.varHandle().toMethodHandle(VarHandle.AccessMode.GET), checks);
        }

        private static Arg structArg(NativeType id, MemoryLayout layout, Object value, List<Consumer<Object>> checks) {
            return new Arg(id, layout, value, MethodHandles.identity(MemorySegment.class), checks);
        }

        enum NativeType {
            INT,
            FLOAT,
            DOUBLE,
            POINTER,
            S_I,
            S_F,
            S_D,
            S_P,
            S_II,
            S_IF,
            S_ID,
            S_IP,
            S_FI,
            S_FF,
            S_FD,
            S_FP,
            S_DI,
            S_DF,
            S_DD,
            S_DP,
            S_PI,
            S_PF,
            S_PD,
            S_PP,
            S_III,
            S_IIF,
            S_IID,
            S_IIP,
            S_IFI,
            S_IFF,
            S_IFD,
            S_IFP,
            S_IDI,
            S_IDF,
            S_IDD,
            S_IDP,
            S_IPI,
            S_IPF,
            S_IPD,
            S_IPP,
            S_FII,
            S_FIF,
            S_FID,
            S_FIP,
            S_FFI,
            S_FFF,
            S_FFD,
            S_FFP,
            S_FDI,
            S_FDF,
            S_FDD,
            S_FDP,
            S_FPI,
            S_FPF,
            S_FPD,
            S_FPP,
            S_DII,
            S_DIF,
            S_DID,
            S_DIP,
            S_DFI,
            S_DFF,
            S_DFD,
            S_DFP,
            S_DDI,
            S_DDF,
            S_DDD,
            S_DDP,
            S_DPI,
            S_DPF,
            S_DPD,
            S_DPP,
            S_PII,
            S_PIF,
            S_PID,
            S_PIP,
            S_PFI,
            S_PFF,
            S_PFD,
            S_PFP,
            S_PDI,
            S_PDF,
            S_PDD,
            S_PDP,
            S_PPI,
            S_PPF,
            S_PPD,
            S_PPP,
            ;

            public static NativeType of(String type) {
                return NativeType.valueOf(switch (type) {
                    case "int" -> "INT";
                    case "float" -> "FLOAT";
                    case "double" -> "DOUBLE";
                    case "void*" -> "POINTER";
                    default -> type.substring("struct ".length());
                });
            }
        }
    }

    enum Ret {
        VOID,
        NON_VOID
    }

    enum StructFieldType {
        INT("int", C_INT),
        FLOAT("float", C_FLOAT),
        DOUBLE("double", C_DOUBLE),
        POINTER("void*", C_POINTER);

        final String typeStr;
        final MemoryLayout layout;

        StructFieldType(String typeStr, MemoryLayout layout) {
            this.typeStr = typeStr;
            this.layout = layout;
        }

        MemoryLayout layout() {
            return layout;
        }

        @SuppressWarnings("unchecked")
        static List<List<StructFieldType>>[] perms = new List[10];

        static List<List<StructFieldType>> perms(int i) {
            if (perms[i] == null) {
                perms[i] = generateTest(i, values());
            }
            return perms[i];
        }
    }

    enum ParamType {
        INT("int", C_INT),
        FLOAT("float", C_FLOAT),
        DOUBLE("double", C_DOUBLE),
        POINTER("void*", C_POINTER),
        STRUCT("struct S", null);

        private final String typeStr;
        private final MemoryLayout layout;

        ParamType(String typeStr, MemoryLayout layout) {
            this.typeStr = typeStr;
            this.layout = layout;
        }

        String type(List<StructFieldType> fields) {
            return this == STRUCT ?
                    typeStr + "_" + sigCode(fields) :
                    typeStr;
        }

        MemoryLayout layout(List<StructFieldType> fields) {
            if (this == STRUCT) {
                long offset = 0L;
                List<MemoryLayout> layouts = new ArrayList<>();
                long align = 0;
                for (StructFieldType field : fields) {
                    MemoryLayout l = field.layout();
                    long padding = offset % l.bitAlignment();
                    if (padding != 0) {
                        layouts.add(MemoryLayout.paddingLayout(padding));
                        offset += padding;
                    }
                    layouts.add(l.withName("field" + offset));
                    align = Math.max(align, l.bitAlignment());
                    offset += l.bitSize();
                }
                long padding = offset % align;
                if (padding != 0) {
                    layouts.add(MemoryLayout.paddingLayout(padding));
                }
                return MemoryLayout.structLayout(layouts.toArray(new MemoryLayout[0]));
            } else {
                return layout;
            }
        }

        @SuppressWarnings("unchecked")
        static List<List<ParamType>>[] perms = new List[10];

        static List<List<ParamType>> perms(int i) {
            if (perms[i] == null) {
                perms[i] = generateTest(i, values());
            }
            return perms[i];
        }
    }

    static <Z> List<List<Z>> generateTest(int i, Z[] elems) {
        List<List<Z>> res = new ArrayList<>();
        generateTest(i, new Stack<>(), elems, res);
        return res;
    }

    static <Z> void generateTest(int i, Stack<Z> combo, Z[] elems, List<List<Z>> results) {
        if (i == 0) {
            results.add(new ArrayList<>(combo));
        } else {
            for (Z z : elems) {
                combo.push(z);
                generateTest(i - 1, combo, elems, results);
                combo.pop();
            }
        }
    }

    public static Object[][] functions() {
        int functions = 0;
        List<Object[]> downcalls = new ArrayList<>();
        for (Ret r : Ret.values()) {
            for (int i = 0; i <= MAX_PARAMS; i++) {
                if (r != Ret.VOID && i == 0) continue;
                for (List<ParamType> ptypes : ParamType.perms(i)) {
                    String retCode = r == Ret.VOID ? "V" : ptypes.get(0).name().charAt(0) + "";
                    String sigCode = sigCode(ptypes);
                    if (ptypes.contains(ParamType.STRUCT)) {
                        for (int j = 1; j <= MAX_FIELDS; j++) {
                            for (List<StructFieldType> fields : StructFieldType.perms(j)) {
                                String structCode = sigCode(fields);
                                int count = functions;
                                int fCode = functions++ / CHUNK_SIZE;
                                String fName = String.format("f%d_%s_%s_%s", fCode, retCode, sigCode, structCode);
                                if (SAMPLE_FACTOR == -1 || (count % SAMPLE_FACTOR) == 0) {
                                    downcalls.add(new Object[]{count, fName, r, ptypes, fields});
                                }
                            }
                        }
                    } else {
                        String structCode = sigCode(List.<StructFieldType>of());
                        int count = functions;
                        int fCode = functions++ / CHUNK_SIZE;
                        String fName = String.format("f%d_%s_%s_%s", fCode, retCode, sigCode, structCode);
                        if (SAMPLE_FACTOR == -1 || (count % SAMPLE_FACTOR) == 0) {
                            downcalls.add(new Object[]{count, fName, r, ptypes, List.of()});
                        }
                    }
                }
            }
        }
        return downcalls.toArray(new Object[0][]);
    }

    static <Z extends Enum<Z>> String sigCode(List<Z> elems) {
        return elems.stream().map(p -> p.name().charAt(0) + "").collect(Collectors.joining());
    }
}

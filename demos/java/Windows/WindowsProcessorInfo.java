/**
 * References:
 *  https://docs.oracle.com/en/java/javase/22/docs/api/java.base/java/lang/foreign/SymbolLookup.html
 *  https://openjdk.org/jeps/454
 */

/*
  export JAVA_HOME=~/java/binaries/jdk/x64/jdk-22+36/
  $JAVA_HOME/bin/javac WindowsProcessorInfo.java
  $JAVA_HOME/bin/java --enable-native-access=ALL-UNNAMED WindowsProcessorInfo
 */

/*
  set JAVA_HOME=C:/java/binaries/jdk/x64/jdk-22+36
  %JAVA_HOME%/bin/javac WindowsProcessorInfo.java
  %JAVA_HOME%/bin/java --enable-native-access=ALL-UNNAMED WindowsProcessorInfo
 */
import java.lang.foreign.*;
import java.lang.invoke.MethodHandle;
import java.lang.invoke.VarHandle;

public class WindowsProcessorInfo {

    private static final String GetActiveProcessorCountFunction = "GetActiveProcessorCount";
    private static final String GetSystemInfoFunction = "GetSystemInfo";

    private static final short ALL_PROCESSOR_GROUPS = (short)0xffff;

    private static void printActiveProcessorCount() {
        Linker linker = Linker.nativeLinker();

        try (Arena arena = Arena.ofConfined()) {
            SymbolLookup kernel32 = SymbolLookup.libraryLookup("kernel32.dll", arena);
            MemorySegment getActiveProcessorCountMS = kernel32.find(GetActiveProcessorCountFunction).orElseThrow();

            // https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-getactiveprocessorcount
            MethodHandle getActiveProcessorCount = linker.downcallHandle(
                getActiveProcessorCountMS,
                FunctionDescriptor.of(ValueLayout.JAVA_INT, ValueLayout.JAVA_SHORT)
            );

            try {
                // System.out.println("MethodHandle getActiveProcessorCount: " + getActiveProcessorCount);
                int activeProcessorCount = (int)getActiveProcessorCount.invoke(ALL_PROCESSOR_GROUPS);
                System.out.println("Active Processor Count:      " + activeProcessorCount);
            } catch (Throwable e) {
                System.err.println(e);
            }
        }
    }

    /* From C:/Program Files (x86)/Windows Kits/10/Include/10.0.22621.0/um/sysinfoapi.h

typedef struct _SYSTEM_INFO {
    union {
        DWORD dwOemId;          // Obsolete field...do not use
        struct {
            WORD wProcessorArchitecture;
            WORD wReserved;
        } DUMMYSTRUCTNAME;
    } DUMMYUNIONNAME;
    DWORD dwPageSize;
    LPVOID lpMinimumApplicationAddress;
    LPVOID lpMaximumApplicationAddress;
    DWORD_PTR dwActiveProcessorMask;
    DWORD dwNumberOfProcessors;
    DWORD dwProcessorType;
    DWORD dwAllocationGranularity;
    WORD wProcessorLevel;
    WORD wProcessorRevision;
} SYSTEM_INFO, *LPSYSTEM_INFO;
    */
    private static void printSYSTEM_INFONumberOfProcessors() {
        StructLayout systemInfoStructLayout = MemoryLayout.structLayout(
           ValueLayout.JAVA_INT.withName("dwOemId"),
           ValueLayout.JAVA_INT.withName("dwPageSize"),
           ValueLayout.ADDRESS.withName("lpMinimumApplicationAddress"),
           ValueLayout.ADDRESS.withName("lpMaximumApplicationAddress"),
           ValueLayout.JAVA_LONG.withName("dwActiveProcessorMask"),
           ValueLayout.JAVA_INT.withName("dwNumberOfProcessors"),
           ValueLayout.JAVA_INT.withName("dwProcessorType"),
           ValueLayout.JAVA_INT.withName("dwAllocationGranularity"),
           ValueLayout.JAVA_SHORT.withName("wProcessorLevel"),
           ValueLayout.JAVA_SHORT.withName("wProcessorRevision")
        );

        VarHandle dwOemIdHandle                     = systemInfoStructLayout.varHandle(MemoryLayout.PathElement.groupElement("dwOemId"));
        VarHandle dwPageSizeHandle                  = systemInfoStructLayout.varHandle(MemoryLayout.PathElement.groupElement("dwPageSize"));
        VarHandle lpMinimumApplicationAddressHandle = systemInfoStructLayout.varHandle(MemoryLayout.PathElement.groupElement("lpMinimumApplicationAddress"));
        VarHandle lpMaximumApplicationAddressHandle = systemInfoStructLayout.varHandle(MemoryLayout.PathElement.groupElement("lpMaximumApplicationAddress"));
        VarHandle dwActiveProcessorMaskHandle       = systemInfoStructLayout.varHandle(MemoryLayout.PathElement.groupElement("dwActiveProcessorMask"));
        VarHandle dwNumberOfProcessorsHandle        = systemInfoStructLayout.varHandle(MemoryLayout.PathElement.groupElement("dwNumberOfProcessors"));
        VarHandle dwProcessorTypeHandle             = systemInfoStructLayout.varHandle(MemoryLayout.PathElement.groupElement("dwProcessorType"));
        VarHandle dwAllocationGranularityHandle     = systemInfoStructLayout.varHandle(MemoryLayout.PathElement.groupElement("dwAllocationGranularity"));
        VarHandle wProcessorLevelHandle             = systemInfoStructLayout.varHandle(MemoryLayout.PathElement.groupElement("wProcessorLevel"));
        VarHandle wProcessorRevisionHandle          = systemInfoStructLayout.varHandle(MemoryLayout.PathElement.groupElement("wProcessorRevision"));

        Linker linker = Linker.nativeLinker();

        try (Arena arena = Arena.ofConfined()) {
            SymbolLookup kernel32 = SymbolLookup.libraryLookup("kernel32.dll", arena);
            MemorySegment getSystemInfoMS = kernel32.find(GetSystemInfoFunction).orElseThrow();

            // https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getsysteminfo
            MethodHandle getSystemInfo = linker.downcallHandle(
                getSystemInfoMS,
                FunctionDescriptor.ofVoid(ValueLayout.ADDRESS) // not systemInfoStructLayout!
            );

            MemorySegment systemInfo = arena.allocate(systemInfoStructLayout);

            try {
                // System.out.println("MethodHandle getSystemInfo: " + getSystemInfo);
                getSystemInfo.invoke(systemInfo);

                // https://docs.oracle.com/en/java/javase/22/docs/api/java.base/java/lang/foreign/MemoryLayout.html#varHandle(java.lang.foreign.MemoryLayout.PathElement...)
                var dwNumberOfProcessors = (int)dwNumberOfProcessorsHandle.get(systemInfo, 0L);
                System.out.println("dwOemId:                     " + (int)dwOemIdHandle.get(systemInfo, 0L));
                System.out.println("dwPageSize:                  " + (int)dwPageSizeHandle.get(systemInfo, 0L));
                System.out.println("lpMinimumApplicationAddress: " + String.format("0x%016X", ((MemorySegment)lpMinimumApplicationAddressHandle.get(systemInfo, 0L)).address()));
                System.out.println("lpMaximumApplicationAddress: " + String.format("0x%016X", ((MemorySegment)lpMaximumApplicationAddressHandle.get(systemInfo, 0L)).address()));
                System.out.println("dwActiveProcessorMask:       " + String.format("0x%016X", (long)dwActiveProcessorMaskHandle.get(systemInfo, 0L)));
                System.out.println("dwNumberOfProcessors:        " + (int)dwNumberOfProcessorsHandle.get(systemInfo, 0L));
                System.out.println("dwProcessorType:             " + (int)dwProcessorTypeHandle.get(systemInfo, 0L));
                System.out.println("dwAllocationGranularity:     " + (int)dwAllocationGranularityHandle.get(systemInfo, 0L));
                System.out.println("wProcessorLevel:             " + (short)wProcessorLevelHandle.get(systemInfo, 0L));
                System.out.println("wProcessorRevision :         " + (short)wProcessorRevisionHandle.get(systemInfo, 0L));
            } catch (Throwable e) {
                System.err.println(e);
            }
        }
    }

    public static void main(String[] args) {
        printActiveProcessorCount();
        printSYSTEM_INFONumberOfProcessors();
    }
}

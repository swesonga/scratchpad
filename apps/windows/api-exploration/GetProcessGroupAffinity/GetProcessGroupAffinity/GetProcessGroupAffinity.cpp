// To test this application using the start command on the command prompt:
//
// start /b /affinity 000000000000000f "Simple App for Testing Group Affinity" GetProcessGroupAffinity.exe
//
// For the start command's parameter descriptions, see
// https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/start

#include "GetProcessGroupAffinity.h"
#include "../../include/WindowsErrorHandling.h"
#include <Windows.h>

using namespace std;

int printAffinity() {
    DWORD_PTR processAffinityMask;
    DWORD_PTR systemAffinityMask;

    // https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-getprocessaffinitymask
    if (!GetProcessAffinityMask(GetCurrentProcess(), &processAffinityMask, &systemAffinityMask)) {
        PrintError(TEXT("GetProcessAffinityMask"), GetLastError());
        return -1;
    }

    printf("Process Affinity Mask: 0x%08llx\n", processAffinityMask);
    printf("System  Affinity Mask: 0x%08llx\n", systemAffinityMask);

    return 0;
}

int main()
{
    USHORT groupCount = 0;
    DWORD lastError = 0;

    if (GetProcessGroupAffinity(GetCurrentProcess(), &groupCount, &groupCount) != 0 ||
        ((lastError = GetLastError()) != ERROR_INSUFFICIENT_BUFFER)) {
        printf("Unexpected result code from GetProcessGroupAffinity().\n");
        PrintError(TEXT("GetProcessGroupAffinity"), lastError);
        return -1;
    }

    printf("Groups with assigned threads: %d\n", groupCount);

    WORD activeProcessorGroupCount = GetActiveProcessorGroupCount();
    if (activeProcessorGroupCount == 0) {
        PrintError(TEXT("GetActiveProcessorGroupCount"), GetLastError());
    }
    else {
        printf("Active Processor Group Count: %d\n\n", activeProcessorGroupCount);
    }

    DWORD activeProcessorCount = GetActiveProcessorCount(ALL_PROCESSOR_GROUPS);
    if (activeProcessorCount == 0) {
        PrintError(TEXT("GetActiveProcessorCount"), GetLastError());
    }
    else {
        printf("Active Processor Count:       %d\n\n", activeProcessorCount);
    }

    printAffinity();
}

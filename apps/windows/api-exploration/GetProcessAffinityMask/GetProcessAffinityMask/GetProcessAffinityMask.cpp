// GetProcessAffinityMask.cpp : Defines the entry point for the application.
//

#include "GetProcessAffinityMask.h"
#include "../../include/WindowsErrorHandling.h"
#include <Windows.h>

using namespace std;

int main()
{
    DWORD_PTR processAffinityMask;
    DWORD_PTR systemAffinityMask;

    // https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-getprocessaffinitymask
    if (!GetProcessAffinityMask(GetCurrentProcess(), &processAffinityMask, &systemAffinityMask)) {
        PrintError(TEXT("GetProcessAffinityMask"), GetLastError());
        return -1;
    }

    printf("Process Affinity Mask: 0x%08llx\n", processAffinityMask);
    printf("System  Affinity Mask: 0x%08llx\n", systemAffinityMask);
}

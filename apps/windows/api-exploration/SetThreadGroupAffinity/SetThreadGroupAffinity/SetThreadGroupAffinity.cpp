// To test this application using the start command on the command prompt:
//
// start /b /wait /node 0 /affinity 000000000000000f "Test App for Affinity" SetThreadGroupAffinity.exe 3f
//
// For the start command's parameter descriptions, see
// https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/start

#define UNICODE
#include "SetThreadGroupAffinity.h"
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

int main(int argc, TCHAR* argv[])
{
    if (argc < 2)
    {
        printf("Usage: SetThreadGroupAffinity groupaffinity\n"
            "Group affinities are specified as 64-bit hex values\n");
        return 1;
    }

    unsigned long long userSpecifiedAffinity = strtoull(argv[1], nullptr, 16);

    if (printAffinity()) {
        return -1;
    }

    GROUP_AFFINITY groupAffinity {};
    groupAffinity.Mask = userSpecifiedAffinity;
    groupAffinity.Group = 0;
    if (!SetThreadGroupAffinity(GetCurrentThread(), &groupAffinity, NULL)) {
        PrintError(TEXT("SetThreadGroupAffinity"), GetLastError());
        return -1;
    }

    printf("SetThreadGroupAffinity succeeded with mask: 0x%08llx\n\n", userSpecifiedAffinity);

    if (printAffinity()) {
        return -1;
    }

    Sleep(5000);
    return 0;
}

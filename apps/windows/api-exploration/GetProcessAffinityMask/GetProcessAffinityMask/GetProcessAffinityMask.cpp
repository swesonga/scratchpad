// To test this application using the start command on the command prompt:
//
// start /b /wait /node 0 /affinity 000000000000000f "Simple App for Testing Affinity" GetProcessAffinityMask.exe
//
// For the start command's parameter descriptions, see
// https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/start

#include "GetProcessAffinityMask.h"
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
    char choice;

    while (true) {
        printAffinity();

        cout << endl;
        cout << "Press Q to quit or any other key to display the current process affinity" << endl;
        cin >> choice;

        switch (choice) {
        case 'q':
        case 'Q':
            return 0;
        default:
            break;
        }
    }
}

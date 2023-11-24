#include "GetVersionEx.h"
#include "../../include/WindowsErrorHandling.h"
#include <Windows.h>

using namespace std;

int main()
{
    OSVERSIONINFO osvi;

    ZeroMemory(&osvi, sizeof(OSVERSIONINFO));
    osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);

    // https://learn.microsoft.com/en-us/cpp/error-messages/compiler-warnings/compiler-warning-level-3-c4996?view=msvc-170
//#pragma warning(suppress : 4996)

    // https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getversionexw
    if (!GetVersionEx(&osvi)) {
        PrintError(TEXT("GetVersionEx"), GetLastError());
        return -1;
    }

    printf("OS Major Version: %d\n", osvi.dwMajorVersion);
    printf("OS Minor Version: %d\n", osvi.dwMinorVersion);
    printf("OS Build Number:  %d\n", osvi.dwBuildNumber);

    // return 0; // Why is this optional?
}

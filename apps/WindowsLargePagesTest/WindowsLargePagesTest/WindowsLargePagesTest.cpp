#include <Windows.h>
#include <strsafe.h>
#include <stdio.h>

// This function is a modification of the example at
// https://learn.microsoft.com/en-us/windows/win32/debug/retrieving-the-last-error-code
void PrintError(LPCTSTR lpszFunction, DWORD lastError)
{
    LPVOID lpMsgBuf;
    LPVOID lpDisplayBuf;

    // https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-formatmessage
    FormatMessage(
        FORMAT_MESSAGE_ALLOCATE_BUFFER |
        FORMAT_MESSAGE_FROM_SYSTEM |
        FORMAT_MESSAGE_IGNORE_INSERTS,
        NULL,
        lastError,
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        (LPTSTR)&lpMsgBuf,
        0, NULL);

    // Display the error message

    // https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-localalloc
    lpDisplayBuf = (LPVOID)LocalAlloc(LMEM_ZEROINIT,
        (lstrlen((LPCTSTR)lpMsgBuf) + lstrlen((LPCTSTR)lpszFunction) + 40) * sizeof(TCHAR));

    // https://learn.microsoft.com/en-us/windows/win32/api/strsafe/nf-strsafe-stringcchprintfw
    StringCchPrintf((LPTSTR)lpDisplayBuf,
        LocalSize(lpDisplayBuf) / sizeof(TCHAR),
        TEXT("%s failed with error %d: %s"), lpszFunction, lastError, lpMsgBuf);

    // https://learn.microsoft.com/en-us/cpp/c-runtime-library/format-specification-syntax-printf-and-wprintf-functions
    printf("%ls\n", (LPCTSTR)lpDisplayBuf);

    // https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-localfree
    LocalFree(lpMsgBuf);
    LocalFree(lpDisplayBuf);
}

int main(int argc, char** argv)
{
    if (argc < 5) {
        printf("Usage: WindowsLargePagesTest lpAddress dwSize flAllocationType flProtect\n");
        printf("All arguments must be in hexadecimal\n\n");
        printf("Example:\n WindowsLargePagesTest 0 f000000 20003000 40\n\n");
        return 0;
    }

    const char* addressArg = argv[1];
    const char* sizeArg = argv[2];
    const char* allocationTypeArg = argv[3];
    const char* protectArg = argv[4];

    // https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/strtoull-strtoull-l-wcstoull-wcstoull-l?view=msvc-170
    const int base = 16;
    auto address = strtoull(addressArg, NULL, base);
    auto size = strtoull(sizeArg, NULL, base);
    auto allocationType = strtoull(allocationTypeArg, NULL, base);
    auto protect = strtoull(protectArg, NULL, base);

    DWORD lastError;

    if (allocationType & MEM_LARGE_PAGES) {
        // https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-openprocess
        HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION, FALSE, GetCurrentProcessId());
        if (!hProcess) {
            PrintError(TEXT("OpenProcess"), GetLastError());
            return -1;
        }

        // https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-openprocesstoken
        HANDLE hToken = NULL;
        if (!OpenProcessToken(hProcess, TOKEN_ADJUST_PRIVILEGES, &hToken)) {
            PrintError(TEXT("OpenProcessToken"), GetLastError());
            return -1;
        }

        // https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-lookupprivilegevaluew
        LUID luid;
        if (!LookupPrivilegeValue(NULL, TEXT("SeLockMemoryPrivilege"), &luid)) {
            PrintError(TEXT("LookupPrivilegeValue"), GetLastError());
            return -1;
        }

        TOKEN_PRIVILEGES tp;
        tp.PrivilegeCount = 1;
        tp.Privileges[0].Luid = luid;
        tp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;

        // https://learn.microsoft.com/en-us/windows/win32/api/securitybaseapi/nf-securitybaseapi-adjusttokenprivileges
        BOOL adjustedTokenPrivileges = AdjustTokenPrivileges(hToken, false, &tp, sizeof(tp), NULL, NULL);
        lastError = GetLastError();

        if (!adjustedTokenPrivileges || lastError != ERROR_SUCCESS) {
            PrintError(TEXT("AdjustTokenPrivileges"), lastError);
            return -1;
        }

        printf("Successfully adjusted token privileges.\n");
    }

    // https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualalloc
    LPVOID pointer = VirtualAlloc((LPVOID)address, (SIZE_T)size, (DWORD)allocationType, (DWORD)protect);
    lastError = GetLastError();

    // https://learn.microsoft.com/en-us/cpp/c-runtime-library/format-specification-syntax-printf-and-wprintf-functions
    printf("VirtualAlloc returned %p\n", pointer);

    if (!pointer) {
        PrintError(TEXT("VirtualAlloc"), lastError);
    }

    return 0;
}

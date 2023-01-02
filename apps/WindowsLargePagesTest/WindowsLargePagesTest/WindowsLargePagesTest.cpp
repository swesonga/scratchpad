#include <Windows.h>
#include <strsafe.h>
#include <stdio.h>
#include "WindowsLargePagesTest.h"

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

    lpDisplayBuf = (LPVOID)LocalAlloc(LMEM_ZEROINIT,
        (lstrlen((LPCTSTR)lpMsgBuf) + lstrlen((LPCTSTR)lpszFunction) + 40) * sizeof(TCHAR));

    StringCchPrintf((LPTSTR)lpDisplayBuf,
        LocalSize(lpDisplayBuf) / sizeof(TCHAR),
        TEXT("%s failed with error %d: %s"), lpszFunction, lastError, lpMsgBuf);

    printf("%hs\n", (LPCTSTR)lpDisplayBuf);

    LocalFree(lpMsgBuf);
    LocalFree(lpDisplayBuf);
}

int main(int argc, char** argv)
{
    const DWORD flags = MEM_RESERVE | MEM_COMMIT | MEM_LARGE_PAGES;

    LPVOID pointer = VirtualAlloc(0, 0x0f000000, flags, PAGE_EXECUTE_READWRITE);
    DWORD lastError = GetLastError();

    // https://learn.microsoft.com/en-us/cpp/c-runtime-library/format-specification-syntax-printf-and-wprintf-functions
    printf("VirtualAlloc(0, 0x0f000000, MEM_RESERVE | MEM_COMMIT | MEM_LARGE_PAGES, PAGE_EXECUTE_READWRITE) returned %p\n", pointer);

    if (!pointer) {
        PrintError(TEXT("VirtualAlloc"), lastError);
    }
}

#include <strsafe.h>
#include <tchar.h>
#include <Windows.h>

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
    printf("%lS\n", (LPCTSTR)lpDisplayBuf);

    // https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-localfree
    LocalFree(lpMsgBuf);
    LocalFree(lpDisplayBuf);
}

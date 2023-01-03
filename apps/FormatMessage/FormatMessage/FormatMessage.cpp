#include <Windows.h>
#include <strsafe.h>
#include <stdio.h>

// This function is a modification of the example at
// https://learn.microsoft.com/en-us/windows/win32/debug/retrieving-the-last-error-code
void PrintError(DWORD lastError)
{
    LPVOID lpMsgBuf;
    LPVOID lpDisplayBuf;

    // https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-formatmessage
    FormatMessage(
        FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM |FORMAT_MESSAGE_IGNORE_INSERTS,
        NULL,
        lastError,
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        (LPTSTR)&lpMsgBuf,
        0, NULL);

    // Display the error message

    lpDisplayBuf = (LPVOID)LocalAlloc(LMEM_ZEROINIT, (lstrlen((LPCTSTR)lpMsgBuf) + 40) * sizeof(TCHAR));

    size_t displayBufSizeInChars = LocalSize(lpDisplayBuf) / sizeof(TCHAR);

    // https://learn.microsoft.com/en-us/windows/win32/api/strsafe/nf-strsafe-stringcchprintfw
    StringCchPrintf((LPTSTR)lpDisplayBuf, displayBufSizeInChars, TEXT("Error %d: %s"), lastError, lpMsgBuf);

    printf("%hs\n", (LPCTSTR)lpDisplayBuf);

    LocalFree(lpMsgBuf);
    LocalFree(lpDisplayBuf);
}

int main(int argc, char** argv)
{
    if (argc < 2) {
        printf("Usage: FormatMessage errorCode [base]\n");
        printf("The optional base argument defaults to 10 and must be specified in base 10\n\n");
        printf("Example:\n");
        printf(" FormatMessage 1450\n");
        printf(" FormatMessage 5AA 16\n\n");
        return 0;
    }

    int base = 10;

    const char* errorCodeArg = argv[1];

    if (argc > 2) {
        const char* baseArg = argv[2];
        base = (int)strtoll(baseArg, NULL, 10);
    }

    // https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/strtoull-strtoull-l-wcstoull-wcstoull-l?view=msvc-170
    auto errorCode = (DWORD) strtoull(errorCodeArg, NULL, base);

    PrintError(errorCode);

    return 0;
}

#include <windows.h>
#include <strsafe.h>
#include <stdio.h>
#include "deletefile.h"

// For an overview of string types, see
// https://stackoverflow.com/questions/321413/lpcstr-lpctstr-and-lptstr

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
        TEXT("%s failed with error %d: %s"),
        lpszFunction, lastError, lpMsgBuf);

    printf("%ls\n", (LPCTSTR)lpDisplayBuf);

    LocalFree(lpMsgBuf);
    LocalFree(lpDisplayBuf);
}

int main(int argc, char** argv)
{
    if (argc <= 1) {
        printf("Please specify path to file to delete\n");
        return -1;
    }

    auto path = argv[1];
    DWORD lastError = 0;

    // https://learn.microsoft.com/en-us/windows/win32/fileio/opening-a-file-for-reading-or-writing
    HANDLE hFile = CreateFileA(path,
        GENERIC_READ,          // open for reading
        0,       // do not share
        NULL,                  // default security
        OPEN_EXISTING,         // existing file only
        FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, // normal file
        NULL);                 // no attr. template

    if (hFile == INVALID_HANDLE_VALUE) {
        lastError = GetLastError();
        PrintError(TEXT("CreateFile"), lastError);
        return -1;
    }

    printf("Opened the file\n");

    BOOL succeeded = CloseHandle(hFile);
    lastError = GetLastError();
    if (lastError != ERROR_SUCCESS) {
        PrintError(TEXT("CloseHandle"), lastError);
        return -1;
    }

    printf("Closed the file\n");

    succeeded = DeleteFileA(path);

    lastError = GetLastError();
    if (lastError != ERROR_SUCCESS) {
        PrintError(TEXT("DeleteFile"), lastError);
        return -1;
    }

    if (!succeeded) {
        printf("Could not delete file\n");
        return -1;
    }

    printf("Successfully deleted file\n");
    return 0;
}

#ifndef UNICODE
#define UNICODE
#endif

#include <windows.h>
#include <strsafe.h>
#include <stdio.h>

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

int main(int argc, char** argv)
{
    if (argc < 4) {
        printf("Please specify path to file to open, map, and truncate\n\n");
        printf("Usage:\n\n");
        printf(" TruncateFile pathToFile newSize mapFile\n\n");
        printf("pathToFile: path to the file to truncate\n");
        printf("newSize:    path to the file to truncate\n");
        printf("mapFile:    1 to map the file before truncation, 0 otherwise\n");
        return -1;
    }

    auto path = argv[1];
    const char* sizeArg = argv[2];
    auto mapFileArg = argv[3];

    unsigned int mapFile = atoi(mapFileArg);
    auto size = strtoll(sizeArg, NULL, 10);

    // https://learn.microsoft.com/en-us/windows/win32/fileio/opening-a-file-for-reading-or-writing
    HANDLE hFile = CreateFileA(path,
        GENERIC_READ | GENERIC_WRITE,
        0,       // do not share
        NULL,                  // default security
        OPEN_EXISTING,         // existing file only
        FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, // normal file
        NULL);                 // no attr. template

    if (hFile == INVALID_HANDLE_VALUE) {
        PrintError(TEXT("CreateFile"), GetLastError());
        return -1;
    }

    printf("Opened the file\n");

    if (mapFile) {
        // https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-getfilesize
        DWORD dwFileSize = GetFileSize(hFile, NULL);
        if (dwFileSize == INVALID_FILE_SIZE) {
            PrintError(TEXT("GetFileSize"), GetLastError());
            return -1;
        }

        HANDLE hMapFile = CreateFileMapping(hFile,          // current file handle
            NULL,           // default security
            PAGE_READWRITE, // read/write permission
            0,              // size of mapping object, high
            dwFileSize,     // size of mapping object, low
            NULL);          // name of mapping object

        if (!hMapFile) {
            PrintError(TEXT("CreateFileMapping"), GetLastError());
            return -1;
        }

        printf("Successfully mapped the file\n");
    }

    FILE_END_OF_FILE_INFO feofi;
    feofi.EndOfFile.QuadPart = size;

    if (!SetFileInformationByHandle(hFile,
        FileEndOfFileInfo,
        &feofi,
        sizeof(FILE_END_OF_FILE_INFO))) {
        PrintError(TEXT("SetFileInformationByHandle"), GetLastError());
        return -1;
    }

    printf("Successfully truncated the file\n");

    BOOL succeeded = CloseHandle(hFile);
    DWORD lastError = GetLastError();
    if (lastError != ERROR_SUCCESS) {
        PrintError(TEXT("CloseHandle"), lastError);
        return -1;
    }

    printf("Closed the file\n");
    return 0;
}

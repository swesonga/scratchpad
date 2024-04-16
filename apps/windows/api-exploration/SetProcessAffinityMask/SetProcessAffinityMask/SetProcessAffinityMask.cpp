//#define UNICODE
#include "SetProcessAffinityMask.h"
#include "../../include/WindowsErrorHandling.h"
#include <Windows.h>
#include <cassert>

int main(int argc, TCHAR* argv[])
{
    TCHAR* commandLine = argv[0];

    if (argc < 3)
    {
        printf("Usage: %S executable affinity\n"
            "Affinity is specified as a 64-bit hex value.\n", commandLine);
        return 1;
    }

    unsigned long long affinity;

#ifdef UNICODE
    affinity = wcstoull(argv[2], nullptr, 16);
#else
    affinity = strtoull(argv[2], nullptr, 16);
#endif
    printf("Affinity mask set to 0x%08llx.\n", affinity);

    STARTUPINFO si;
    PROCESS_INFORMATION pi;

    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    ZeroMemory(&pi, sizeof(pi));

    printf("Start the child process...\n\n");
    if (!CreateProcess(NULL,   // No module name (use command line)
        argv[1],        // Command line
        NULL,           // Process handle not inheritable
        NULL,           // Thread handle not inheritable
        FALSE,          // Set handle inheritance to FALSE
        CREATE_SUSPENDED,              // No creation flags
        NULL,           // Use parent's environment block
        NULL,           // Use parent's starting directory 
        &si,            // Pointer to STARTUPINFO structure
        &pi)           // Pointer to PROCESS_INFORMATION structure
        )
    {
        PrintError(TEXT("CreateProcess"), GetLastError());
        return 1;
    }

    if (!SetProcessAffinityMask(pi.hProcess, affinity)) {
        PrintError(TEXT("SetProcessAffinityMask"), GetLastError());
        return 1;
    }

    if (ResumeThread(pi.hThread) == ((DWORD)-1)) {
        PrintError(TEXT("ResumeThread"), GetLastError());
        return 1;
    }

    // Wait until child process exits.
    WaitForSingleObject(pi.hProcess, INFINITE);

    // Close process and thread handles. 
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
    return 0;
}

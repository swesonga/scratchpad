#include "CreateJobObjectBasic.h"
#include "../../include/WindowsErrorHandling.h"
#include <Windows.h>

int main(int argc, TCHAR* argv[])
{
    Sleep(3000);
    if (argc > 1) {
        HANDLE jobHandle = CreateJobObject(NULL, TEXT("Test Job"));
        Sleep(5000);
        if (!jobHandle) {
            PrintError(TEXT("CreateJobObject"), GetLastError());
            return 1;
        }
        else if (GetLastError() == ERROR_ALREADY_EXISTS) {
            printf("CreateJobObject returned handle to an existing job.\n");
        }
        printf("CreateJobObject completed.\n");
    }

    Sleep(3000);
    return 0;
}

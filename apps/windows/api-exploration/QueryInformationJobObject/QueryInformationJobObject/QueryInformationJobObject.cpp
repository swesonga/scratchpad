#define UNICODE
#include "QueryInformationJobObject.h"
#include "../../include/WindowsErrorHandling.h"
#include <Windows.h>

int main(int argc, TCHAR* argv[])
{
    GROUP_AFFINITY* groupAffinities = nullptr;
    DWORD length = 0;

    if (!QueryInformationJobObject(NULL, JobObjectGroupInformationEx, groupAffinities, 0, &length)) {
        DWORD lastError = GetLastError();
        PrintError(TEXT("QueryInformationJobObject"), lastError);

        if (lastError == ERROR_ACCESS_DENIED) {
            printf("This process is not running in a job.\n");
            return 0;
        }

        if (lastError == ERROR_INSUFFICIENT_BUFFER) {
            DWORD numGroups = length / sizeof(GROUP_AFFINITY);
            printf("QueryInformationJobObject set ReturnLength to %d.\n", length);
            printf("sizeof(GROUP_AFFINITY) = %d.\n", (DWORD)sizeof(GROUP_AFFINITY));
            printf("Allocating memory for %d GROUP_AFFINITY structs.\n", numGroups);

            groupAffinities = (GROUP_AFFINITY*)malloc(length);
            if (NULL == groupAffinities) {
                printf("Failed to allocated required buffer size!\n");
                return -1;
            }

            if (!QueryInformationJobObject(NULL, JobObjectGroupInformationEx, groupAffinities, length, &length)) {
                PrintError(TEXT("QueryInformationJobObject"), GetLastError());
                return 1;
            }

            numGroups = length / sizeof(GROUP_AFFINITY);
            for (DWORD i = 0; i < numGroups; i++) {
                printf("groupAffinities[%d].Group: %d\n", i, groupAffinities[i].Group);
                printf("groupAffinities[%d].Mask:  0x%08llx\n\n", i, groupAffinities[i].Mask);
            }

            return 0;
        }

        return -1;
    }

    printf("Unexpected success of the QueryInformationJobObject function.\n");
    return 0;
}

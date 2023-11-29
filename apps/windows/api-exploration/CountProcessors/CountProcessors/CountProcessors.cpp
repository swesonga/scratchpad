#define UNICODE
#include "CountProcessors.h"
#include "../../include/WindowsErrorHandling.h"
#include <Windows.h>
#include <cassert>

int printAffinity() {
    DWORD_PTR processAffinityMask;
    DWORD_PTR systemAffinityMask;

    // https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-getprocessaffinitymask
    if (!GetProcessAffinityMask(GetCurrentProcess(), &processAffinityMask, &systemAffinityMask)) {
        PrintError(TEXT("GetProcessAffinityMask"), GetLastError());
        return -1;
    }

    printf("Process Affinity Mask: 0x%08llx\n", processAffinityMask);
    printf("System  Affinity Mask: 0x%08llx\n", systemAffinityMask);

    return 0;
}

typedef BOOL(WINAPI* LPFN_GET_LOGICAL_PROCESSOR_INFORMATION_EX)(
    LOGICAL_PROCESSOR_RELATIONSHIP, PSYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX, PDWORD);

int main()
{
    LPFN_GET_LOGICAL_PROCESSOR_INFORMATION_EX glpiex;

    glpiex = (LPFN_GET_LOGICAL_PROCESSOR_INFORMATION_EX)GetProcAddress(
        GetModuleHandle(TEXT("kernel32")),
        "GetLogicalProcessorInformationEx");
    if (NULL == glpiex)
    {
        wprintf(TEXT("GetLogicalProcessorInformationEx is not supported.\n"));
        return (1);
    }

    LOGICAL_PROCESSOR_RELATIONSHIP relationshipType = RelationGroup;
    PSYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX buffer = NULL;
    DWORD returnedLength = 0;

    // https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getlogicalprocessorinformationex
    if (!glpiex(relationshipType, buffer, &returnedLength)) {
        // https://learn.microsoft.com/en-us/windows/win32/api/errhandlingapi/nf-errhandlingapi-getlasterror
        DWORD lastError = GetLastError();

        if (lastError == ERROR_INSUFFICIENT_BUFFER) {
            printf("The buffer is not large enough to contain all of the data. Required buffer length: %d\n", returnedLength);
            printf("Allocating required buffer size...\n\n");
            buffer = (PSYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX)malloc(returnedLength);

            if (NULL == buffer) {
                printf("Failed to allocated required buffer size!\n");
                return -1;
            }

            if (!glpiex(relationshipType, buffer, &returnedLength)) {
                lastError = GetLastError();
                PrintError(TEXT("GetLogicalProcessorInformationEx"), lastError);
                assert(lastError != ERROR_INSUFFICIENT_BUFFER);
            }
        }
        else {
            PrintError(TEXT("GetLogicalProcessorInformationEx"), lastError);
            return -1;
        }
    }

    if (buffer == NULL) {
        printf("Failed to allocate and fill buffer!\n");
        return -1;
    }

    DWORD maximumProcessors = 0;
    DWORD activeProcessors = 0;
    DWORD processorGroups = 0;

    PSYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX pSytemLogicalProcessorInfo = buffer;
    DWORD byteOffset = 0;
    while (byteOffset + sizeof(SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX) <= returnedLength)
    {
        switch (pSytemLogicalProcessorInfo->Relationship) {
        case RelationGroup:
            // https://learn.microsoft.com/en-us/windows/win32/api/winnt/ns-winnt-group_relationship
            // TODO: should this be = instead of +=? How many such records are there?
            // There should be only one based on the above link.
            processorGroups = pSytemLogicalProcessorInfo->Group.ActiveGroupCount;
            printf("----------------------------\n");

            // The number of active groups on the system. This member indicates the number of PROCESSOR_GROUP_INFO structures in the GroupInfo array.
            printf("Active Group Count:    %d\n", processorGroups);

            for (DWORD i = 0; i < processorGroups; i++) {
                PROCESSOR_GROUP_INFO groupInfo = pSytemLogicalProcessorInfo->Group.GroupInfo[i];

                activeProcessors += groupInfo.ActiveProcessorCount;
                maximumProcessors += groupInfo.MaximumProcessorCount;

                // The maximum number of processors in the group.
                printf("MaximumProcessorCount: %d\n", groupInfo.MaximumProcessorCount);

                // The number of active processors in the group.
                printf("ActiveProcessorCount:  %d\n", groupInfo.ActiveProcessorCount);

                // A bitmap that specifies the affinity for zero or more active processors within the group.
                printf("ActiveProcessorMask:   %llx\n\n", groupInfo.ActiveProcessorMask);
            }
            break;
        }

        byteOffset += sizeof(SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX);
        pSytemLogicalProcessorInfo++;
    }

    printf("Number of Processor Groups:   %d\n", processorGroups);
    printf("Number of Active Processors:  %d\n", activeProcessors);
    printf("Maximum Number of Processors: %d\n\n", maximumProcessors);

    printAffinity();

    Sleep(10000);
}
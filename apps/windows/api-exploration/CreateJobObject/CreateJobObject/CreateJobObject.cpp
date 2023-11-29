#include "CreateJobObject.h"
#include "../../include/WindowsErrorHandling.h"
#include <Windows.h>
#include <cassert>

int _tmain(int argc, TCHAR* argv[])
{
    TCHAR* commandLine = argv[0];

    if (argc < 3)
    {
        printf("Usage: %S cmdline groupaffinity1 [groupaffinity2 ...]\n"
            "Group affinities are specified as 64-bit hex values\n", commandLine);
        return 1;
    }

    int affinityArgCount = argc - 2;

    printf("Allocating memory for %d affinity masks.\n", affinityArgCount);
    unsigned long long* affinities = new unsigned long long[affinityArgCount]; // TODO: delete me

    for (int i = 0; i < affinityArgCount; i++) {
        affinities[i] = strtoull(argv[2 + i], nullptr, 16);
        printf("Affinity mask %d set to 0x%08llx.\n", i, affinities[i]);
    }

    HANDLE jobHandle = CreateJobObject(NULL, TEXT("Group Affinity Testing Job"));
    if (!jobHandle) {
        PrintError(TEXT("CreateJobObject"), GetLastError());
        return 1;
    }
    else if (GetLastError() == ERROR_ALREADY_EXISTS) {
        printf("CreateJobObject returned handle to an existing job.\n");
    }

    // Get the GROUP_AFFINITY structures
    GROUP_AFFINITY* groupAffinities = NULL;
    DWORD numGroupAffinities = 0;
    typedef BOOL(WINAPI* LPFN_GET_LOGICAL_PROCESSOR_INFORMATION_EX)(
        LOGICAL_PROCESSOR_RELATIONSHIP, PSYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX, PDWORD);

    LPFN_GET_LOGICAL_PROCESSOR_INFORMATION_EX glpiex;

    glpiex = (LPFN_GET_LOGICAL_PROCESSOR_INFORMATION_EX)GetProcAddress(
        GetModuleHandle(TEXT("kernel32")),
        "GetLogicalProcessorInformationEx");
    if (NULL == glpiex)
    {
        _tprintf(TEXT("GetLogicalProcessorInformationEx is not supported.\n"));
        return (1);
    }

    LOGICAL_PROCESSOR_RELATIONSHIP relationshipType = RelationProcessorCore;
    PSYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX buffer = NULL;
    DWORD returnedLength = 0;
    DWORD byteOffset = 0;

    DWORD processorCores = 0;

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

    PSYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX pSytemLogicalProcessorInfo = buffer;
    while (byteOffset + sizeof(SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX) <= returnedLength)
    {
        switch (pSytemLogicalProcessorInfo->Relationship) {
        
        case RelationProcessorCore:
            PROCESSOR_RELATIONSHIP processorRelationship = pSytemLogicalProcessorInfo->Processor;
            groupAffinities = processorRelationship.GroupMask;
            numGroupAffinities = processorRelationship.GroupCount;

            for (int i = 0; i < numGroupAffinities; i++) {
                KAFFINITY affinityMask = (i < affinityArgCount) ? affinities[i] : groupAffinities[i].Mask;
                groupAffinities[i].Mask = affinityMask;

                printf("ProcessorCore %d, Group %d, PROCESSOR_RELATIONSHIP.GroupMask 0x%08llx - Set mask to 0x%08llx.\n",
                    processorCores, i, groupAffinities[i].Mask, affinityMask);
            }

            processorCores++;
            break;
        }

        byteOffset += sizeof(SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX);
        pSytemLogicalProcessorInfo++;
    }

    printf("Processor Cores:    %d\n", processorCores);

    JOBOBJECTINFOCLASS jobObjectInformationClass = JobObjectGroupInformationEx;

    DWORD sizeOfGroupData = sizeof(GROUP_AFFINITY) * numGroupAffinities;
    if (groupAffinities == NULL) {
        printf("No group affinity structures available.\n");
        return 1;
    }

    if (!SetInformationJobObject(jobHandle, jobObjectInformationClass, groupAffinities, sizeOfGroupData)) {
        PrintError(TEXT("SetInformationJobObject"), GetLastError());
        return 1;
    }
    else {
        printf("SetInformationJobObject succeeded.\n");
    }

    STARTUPINFO si;
    PROCESS_INFORMATION pi;

    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    ZeroMemory(&pi, sizeof(pi));

    // Start the child process. 
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

    if (!AssignProcessToJobObject(jobHandle, pi.hProcess)) {
        PrintError(TEXT("AssignProcessToJobObject"), GetLastError());
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

/*
 * Code for investigating MSVC code generation for accessing arrays of structs.
 *
 * Set up Visual Studio build command prompt for ARM64 by running:
 *
 *   "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsamd64_arm64.bat"
 *
 * To compile (unoptimized):
 *       cl /c /std:c++17 /permissive- array_of_structs.cpp
 *       dumpbin /disasm /out:array_of_structs.asm array_of_structs.obj
 *       dumpbin /all /out:array_of_structs.txt array_of_structs.obj
 *
 * To compile (optimized):
 *       cl /c /O2 /std:c++17 /permissive- /Fo"array_of_structs-optimized.obj" array_of_structs.cpp
 *       dumpbin /disasm /out:array_of_structs-optimized.asm array_of_structs-optimized.obj
 *       dumpbin /all /out:array_of_structs-optimized.txt array_of_structs-optimized.obj
 */

#include <Windows.h>
#include <cassert>

void arrayOfStructsUpdatingPointer(DWORD processor_groups) {
    PROCESSOR_GROUP_INFO* group_info = (PROCESSOR_GROUP_INFO*)malloc(sizeof(PROCESSOR_GROUP_INFO) * processor_groups);
    assert(group_info != nullptr);

    DWORD logical_processors = 0;
    for (DWORD i = 0; i < processor_groups; i++, group_info++) {
        logical_processors += group_info->ActiveProcessorCount;
    }
}

void arrayOfStructsIndexingBasePointer(DWORD processor_groups) {
    PROCESSOR_GROUP_INFO* group_info = (PROCESSOR_GROUP_INFO*)malloc(sizeof(PROCESSOR_GROUP_INFO) * processor_groups);
    assert(group_info != nullptr);

    DWORD logical_processors = 0;
    for (DWORD i = 0; i < processor_groups; i++) {
        logical_processors += group_info[i].ActiveProcessorCount;
    }
}

int main()
{
    DWORD processor_groups = 4;
    arrayOfStructsUpdatingPointer(processor_groups);
    arrayOfStructsIndexingBasePointer(processor_groups);
}

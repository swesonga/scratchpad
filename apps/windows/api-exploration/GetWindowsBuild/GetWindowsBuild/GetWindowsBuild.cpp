#include "GetWindowsBuild.h"
#include <Windows.h>
#include <VersionHelpers.h>
#include "../../include/WindowsErrorHandling.h"

void GetWindowsVersion(int* major_version, int* minor_version, int* build_number) {
    LPWSTR kernel32_path = NULL;
    LPWSTR version_info = NULL;
    DWORD version_size = 0;

    // Get the full path to \Windows\System32\kernel32.dll and use that for
    // determining what version of Windows we're running on.
    UINT buffer_size = GetSystemDirectoryW(NULL, 0);
    if (buffer_size == 0) {
        printf("GetSystemDirectoryW() failed: GetLastError->%ld.", GetLastError());
        return;
    }

    UINT filename_chars = (UINT)strlen("\\kernel32.dll");

    // buffer_size includes the terminating null character
    UINT size = (buffer_size + filename_chars) * sizeof(WCHAR);
    kernel32_path = (LPWSTR)malloc(size);
    if (kernel32_path == NULL) {
        printf("os::malloc() failed to allocate %ld bytes for the kernel32.dll path", size);
        return;
    }

    UINT non_null_chars_written = GetSystemDirectoryW(kernel32_path, size);
    if (non_null_chars_written == 0) {
        printf("GetSystemDirectoryW() failed: GetLastError->%ld.", GetLastError());
        goto free_mem;
    }

    wcsncat(kernel32_path, L"\\kernel32.dll", filename_chars);

    // https://stackoverflow.com/questions/7028304/error-lnk2019-when-using-getfileversioninfosize
    version_size = GetFileVersionInfoSizeW(kernel32_path, NULL);
    if (version_size == 0) {
        printf("GetFileVersionInfoSizeW() failed: GetLastError->%ld.", GetLastError());
        goto free_mem;
    }

    version_info = (LPWSTR)malloc(version_size);
    if (version_info == NULL) {
        printf("os::malloc() failed to allocate %ld bytes for GetFileVersionInfoW buffer", version_size);
        goto free_mem;
    }

    if (!GetFileVersionInfoW(kernel32_path, 0, version_size, version_info)) {
        printf("GetFileVersionInfoW() failed: GetLastError->%ld.", GetLastError());
        goto free_mem;
    }

    VS_FIXEDFILEINFO* file_info;
    if (!VerQueryValueW(version_info, L"\\", (LPVOID*)&file_info, &size)) {
        printf("VerQueryValueW() failed. Cannot determine Windows version.");
        goto free_mem;
    }

    *major_version = HIWORD(file_info->dwProductVersionMS);
    *minor_version = LOWORD(file_info->dwProductVersionMS);
    *build_number = HIWORD(file_info->dwProductVersionLS);

free_mem:
    free(kernel32_path);
    free(version_info);
    return;
}

// https://learn.microsoft.com/en-us/windows/win32/sysinfo/operating-system-version
int main()
{
    OSVERSIONINFO osvi;

    ZeroMemory(&osvi, sizeof(OSVERSIONINFO));
    osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);

    // https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getversionexw

    // https://learn.microsoft.com/en-us/cpp/error-messages/compiler-warnings/compiler-warning-level-3-c4996?view=msvc-170
#pragma warning(suppress : 4996)
    if (!GetVersionEx(&osvi)) {
        PrintError(TEXT("GetLogicalProcessorInformationEx"), GetLastError());
        return -1;
    }

    printf("GetVersionEx OS Major Version: %d\n", osvi.dwMajorVersion);
    printf("GetVersionEx OS Minor Version: %d\n", osvi.dwMinorVersion);
    printf("GetVersionEx OS Build Number:  %d\n\n", osvi.dwBuildNumber);

    int major_version = 0;
    int minor_version = 0;
    int build_number = 0;

    GetWindowsVersion(&major_version, &minor_version, &build_number);

    int isWin10 = IsWindows10OrGreater();
    int isWinServer = IsWindowsServer();
    printf("IsWindows10OrGreater: %d\n", isWin10);
    printf("IsWindowsServer:      %d\n", isWinServer);

    printf("GetFileVersionInfoW OS Major Version: %d\n", major_version);
    printf("GetFileVersionInfoW OS Minor Version: %d\n", minor_version);
    printf("GetFileVersionInfoW OS Build Number:  %d\n\n", build_number);
}
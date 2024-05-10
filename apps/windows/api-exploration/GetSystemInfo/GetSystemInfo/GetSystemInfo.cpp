#include <Windows.h>
#include <stdio.h>
#include <inttypes.h>

int main()
{
  SYSTEM_INFO system_info;
  GetSystemInfo(&system_info);

  printf("dwPageSize:                  %d\n", system_info.dwPageSize);

  // Links from Microsoft Copilot: "how to printf a 64-bit pointer"
  // https://stackoverflow.com/questions/9053658/correct-format-specifier-to-print-pointer-or-address
  // https://stackoverflow.com/questions/1255099/whats-the-proper-use-of-printf-to-display-pointers-padded-with-0s
  // https://stackoverflow.com/questions/32112497/how-to-printf-a-64-bit-integer-as-hex
  // https://stackoverflow.com/questions/2844/how-do-you-format-an-unsigned-long-long-int-using-printf
  printf("lpMinimumApplicationAddress: 0x%016" PRIXPTR "\n", (uintptr_t)system_info.lpMinimumApplicationAddress);
  printf("lpMaximumApplicationAddress: 0x%016" PRIXPTR "\n", (uintptr_t)system_info.lpMaximumApplicationAddress);
  printf("dwActiveProcessorMask:       0x%016" PRIXPTR "\n", system_info.dwActiveProcessorMask);

  printf("dwNumberOfProcessors:        %d\n", system_info.dwNumberOfProcessors);
  printf("dwProcessorType:             %d\n", system_info.dwProcessorType);
  printf("dwAllocationGranularity:     %d\n", system_info.dwAllocationGranularity);
  printf("wProcessorLevel:             %d\n", system_info.wProcessorLevel);
  printf("wProcessorRevision:          %d\n", system_info.wProcessorRevision);
  return 0;
}

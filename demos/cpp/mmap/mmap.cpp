/*
* To compile using GCC:
*
*     g++ -std=c++11 -o mmap mmap.cpp
*/

#include <sys/mman.h>
#include <iostream>

int main()
{
  std::cout << "Creating a new mapping in the virtual address space..." << std::endl;

  void* address = (void*)0;
  size_t length = (1 << 30);
  int protection = PROT_READ | PROT_WRITE;
  int flags = MAP_ANONYMOUS | MAP_PRIVATE | MAP_NORESERVE;
  int fd = -1;
  int offset = 0;

  void* result = mmap((void*)address, length, protection, flags, fd, offset);

  std::cout << "result: " << std::hex << result << std::endl;

  std::cout << "Press any key to exit" << std::endl;
  std::cin.get();
  return 0;
}

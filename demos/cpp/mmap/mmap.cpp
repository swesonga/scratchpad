/*
  To compile using GCC:

    g++ -std=c++11 -o mmap mmap.cpp

  Sample usage:

    ./mmap 1234abcd0000 1073741824

  To report a memory map of the process on Linux:

    pmap -x <pid>

  To report a memory map of the process on macOS:

    vmmap <pid>
*/

#include <sys/mman.h>
#include <iostream>
#include <unistd.h>

int main(int argc, char** argv)
{
  std::cout << "Creating a new mapping in the virtual address space by" << std::endl;

  void* address = (void*)0;
  size_t length = (1 << 30);
  int protection = PROT_READ | PROT_WRITE;
  int flags = MAP_ANONYMOUS | MAP_PRIVATE | MAP_NORESERVE;
  int fd = -1;
  int offset = 0;

  if (argc > 1) {
    address = (void*)strtoull(argv[1], nullptr, 16);
  }
  if (argc > 2) {
    length = strtoull(argv[2], nullptr, 10);
  }

  void* result = mmap((void*)address, length, protection, flags, fd, offset);

  std::cout << "calling mmap(0x"
    << std::hex << address
    << ", 0x" << length
    << ", 0x" << protection
    << ", 0x" << flags
    << ", 0x" << fd
    << ", 0x" << offset
    << ')'
    << std::endl;

  std::cout << "result: " << std::hex << result << std::endl;

  auto pid = getpid();

  std::cout << "Press any key to exit (pid " << std::dec << pid << ")" << std::endl;
  std::cin.get();
  return 0;
}

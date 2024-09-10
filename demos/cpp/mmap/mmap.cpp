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
  auto pid = getpid();

  std::cout << "To report a memory map of this process (pid " << pid << "), run one of these commands:" << std::endl << std::endl;
  std::cout << " pmap -x " << pid << std::endl;
  std::cout << " vmmap " << pid << std::endl << std::endl;

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

  size_t bytes_to_write = 0;
  if (argc > 3) {
    bytes_to_write = strtoull(argv[3], nullptr, 10);
  }

  if (bytes_to_write > 0) {
    std::cout << "Writing " << std::dec << bytes_to_write << " bytes to the new mapping." << std::endl;
  }

  for (size_t i = 0; i < bytes_to_write; i++) {
    *((char*)(result) + i) = '0';
  }

  size_t bytes_not_needed_after_write = 0;
  if (argc > 4) {
    bytes_not_needed_after_write = strtoull(argv[4], nullptr, 10);
  }

  if (bytes_not_needed_after_write > 0) {
    std::cout << "Press ENTER to advise that memory is not needed..." << std::endl;
    std::cin.get();

    uintptr_t address_to_advise = (uintptr_t)address + (uintptr_t)length - (uintptr_t)bytes_not_needed_after_write;
    madvise((void*)address_to_advise, bytes_not_needed_after_write, MADV_DONTNEED);

    std::cout << "calling madvise(0x"
    << std::hex << address_to_advise
    << ", 0x" << bytes_not_needed_after_write
    << ", 0x" << MADV_DONTNEED
    << ')'
    << std::endl;
  }

  std::cout << "Press ENTER to exit..." << std::endl;
  std::cin.get();
  return 0;
}

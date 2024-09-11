/*
  To compile using GCC:

    g++ -std=c++11 -o mmap mmap.cpp

  Sample usage:

    ./mmap address length bytes_to_write bytes_not_needed_after_write ranges_to_alloc
    ./mmap 1234abcd0000 2147483647 1073741824 1073741824 16
    ./mmap 1234abcd0000 2147483647 2147483647 2147483647 16

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

  if (argc == 1) {
    std::cout << "Usage: mmap address length bytes_to_write bytes_not_needed_after_write ranges_to_alloc" << std::endl;
    return 0;
  }

  std::cout << "Creating a new mapping in the virtual address space by" << std::endl;

  void* cmdline_address = (void*)0;
  size_t length = (1 << 30);
  int protection = PROT_READ | PROT_WRITE;
  int flags = MAP_ANONYMOUS | MAP_PRIVATE | MAP_NORESERVE;
  int fd = -1;
  int offset = 0;

  if (argc > 1) {
    cmdline_address = (void*)strtoull(argv[1], nullptr, 16);
  }
  if (argc > 2) {
    length = strtoull(argv[2], nullptr, 10);
  }

  unsigned long long ranges_to_alloc = 1;
  if (argc > 4) {
    ranges_to_alloc = strtoull(argv[5], nullptr, 10);
  }

  const unsigned long long addr_range_increment = 0x100000000000;

  for (unsigned long long i = 0; i < ranges_to_alloc; i++) {
    unsigned long long address = (unsigned long long)cmdline_address + (i * addr_range_increment);
    void* result = mmap((void*)address, length, protection, flags, fd, offset);

    std::cout << "calling mmap("
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

    if (i < ranges_to_alloc - 1) {
      std::cout << std::dec << i+1 << " of " << ranges_to_alloc << " mmap/madvise invocations complete. Press ENTER to continue to next mmap allocation..." << std::endl;
      std::cin.get();
    }
  }

  std::cout << "Press ENTER to exit..." << std::endl;
  std::cin.get();
  return 0;
}

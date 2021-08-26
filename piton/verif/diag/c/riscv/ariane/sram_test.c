// On-chip Static memory test
// Author: Alexander Kropotov, Barcelona Supercomputing Center

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

// #include <fcntl.h>
// #include <sys/mman.h>

int main(int argc, char ** argv) {
  enum {
    SRAM_BASEADDR = 0xfff0400000, // + 0x00100000,
    SRAM_ADRRANGE = 0x00020000
  };

  uint32_t volatile* memPtr = (uint32_t*)SRAM_BASEADDR;
  // int fid = open("/dev/mem", O_RDWR);
  // if( fid < 0 ) {
  //   printf("Could not open /dev/mem \n");
  //   exit(1);
  // }
  // memPtr = (uint32_t*)mmap(0, SRAM_ADRRANGE, PROT_READ|PROT_WRITE, MAP_SHARED, fid, SRAM_BASEADDR);
  // if (memPtr == MAP_FAILED) {
  //   printf("Memory mapping of On-chip Static memory failed.\n");
  //   exit(1);
  // }
  size_t const memWords = SRAM_ADRRANGE / sizeof(uint32_t);

  printf("-- Running On-chip Static memory test --\n");
  printf("Testing On-chip memory at addr 0x%lx(virt: 0x%lx) with size %d \n", SRAM_BASEADDR, (size_t)memPtr, SRAM_ADRRANGE);
  printf(" Checking memory with random values from %x to %x \n", 0, RAND_MAX);
  // first clearing previously stored values
  for (size_t addr = 0; addr < memWords; ++addr) memPtr[addr] = 0;
  // srand(1);
  for (size_t addr = 0; addr < memWords; ++addr) memPtr[addr] = ~addr; //rand();
  // srand(1);
  for (size_t addr = 0; addr < memWords; ++addr) {
    uint32_t expectVal = ~addr; //rand();
    if (memPtr[addr] != expectVal) {
      printf("\nERROR: Incorrect readback of word at addr %x from Mem: %x, expected: %x \n", addr, memPtr[addr], expectVal);
      exit(1);
    }
  }

  printf(" Checking byte Endianess of the memory \n");
  uint32_t volatile  wordRef = 0x12345678;
  uint8_t  volatile* byteRef = (uint8_t*)(&wordRef);
  for (size_t addr = 0; addr < memWords; ++addr) memPtr[addr] = 0x12345678;
  for (size_t addr = 0; addr < memWords; ++addr)
  for (size_t byteIdx = 0; byteIdx < sizeof(uint32_t); ++byteIdx) {
    uint8_t volatile* bytePtr = (uint8_t*)(&memPtr[addr]);
    if (bytePtr[byteIdx] != byteRef[byteIdx]) {
      printf("\nERROR: Incorrect Endianess of word at addr %x from Mem: %x vs reference word %x \n", addr, memPtr[addr], wordRef);
      for (size_t byteIdx = 0; byteIdx < sizeof(uint32_t); ++byteIdx)
        printf("Idx: %x, Read byte: %x, Ref byte: %x \n", byteIdx, bytePtr[byteIdx], byteRef[byteIdx]);
      exit(1);
    }
  }

  printf("-- On-chip Static memory test Passed --\n");

  return 0;
}

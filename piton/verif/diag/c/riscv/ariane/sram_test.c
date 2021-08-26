// On-chip Static memory test
// Author: Alexander Kropotov, Barcelona Supercomputing Center

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char ** argv) {
  enum {
    SRAM_BASEADDR = 0xfff0400000, // + 0x00100000,
    SRAM_ADRRANGE = 0x00020000
  };
  uint32_t volatile* memPtr = (uint32_t*)SRAM_BASEADDR;
  size_t const memWords = SRAM_ADRRANGE / sizeof(uint32_t);

  printf("-- Running On-chip Static memory test --\n");
  printf("Checking memories with random values from %x to %x \n", 0, RAND_MAX);
  // first clearing previously stored values
  for (size_t addr = 0; addr < memWords; ++addr) memPtr[addr] = 0;
  // srand(1);
  for (size_t addr = 0; addr < memWords; ++addr) memPtr[addr] = ~addr; //rand();
  // srand(1);
  printf("Checking On-chip memory at addr 0x%lx(virt: 0x%lx) with size %d \n", SRAM_BASEADDR, (size_t)memPtr, SRAM_ADRRANGE);
  for (size_t addr = 0; addr < memWords; ++addr) {
    uint32_t expectVal = ~addr; //rand();
    if (memPtr[addr] != expectVal) {
      printf("\nERROR: Incorrect readback of word at addr %x from Mem: %x, expected: %x \n", addr, memPtr[addr], expectVal);
      exit(1);
    }
  }
  printf("-- On-chip Static memory test Passed --\n");

  return 0;
}

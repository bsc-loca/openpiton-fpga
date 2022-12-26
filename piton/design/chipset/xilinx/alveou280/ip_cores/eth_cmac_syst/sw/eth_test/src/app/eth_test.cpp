
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <algorithm>
#include <time.h>
#include <fcntl.h>
#include <sys/mman.h>
// #include <vector>
// #include <string>
// #include <xil_sleeptimer.h>
// #include <cassert>
// #include <iostream>
// #include <fstream>
// #include <sstream>
// #include <thread>
// #include <chrono>
// #include <fcntl.h>
// #include <sys/stat.h>

#include "EthSyst.h"
#include "ping_test.h"

// using namespace std;

int udp_perf_client();
int udp_perf_server();
int tcp_perf_client();
int tcp_perf_server();

// Instance of the Ethernet System driver, global since cache methods are called from Xilinx DMA driver
EthSyst ethSyst;

int main(int argc, char *argv[])
{
  // Tx/Rx memories 
  size_t const txMemSize  = TX_MEM_CPU_ADRRANGE;
  size_t const rxMemSize  = RX_MEM_CPU_ADRRANGE;
  size_t const sgMemSize  = SG_MEM_CPU_ADRRANGE;
  size_t const txrxMemSize = std::min(txMemSize, rxMemSize);
  size_t const txMemWords = txMemSize / sizeof(uint32_t);
  size_t const rxMemWords = rxMemSize / sizeof(uint32_t);
  size_t const sgMemWords = sgMemSize / sizeof(uint32_t);

  enum {ETH_WORD_SIZE = ETH_DMA_AXIS_WIDTH / 8,
        DMA_AXI_BURST = ETH_WORD_SIZE * std::max(XPAR_AXI_DMA_0_MM2S_BURST_SIZE, // the parameter set in Vivado AXI_DMA IP
                                                 XPAR_AXI_DMA_0_S2MM_BURST_SIZE),
        DMA_PACKET_LEN   = txrxMemSize/3     - sizeof(uint32_t), // the parameter to play with (no issies met for any values and granularities)
        ETH_PACKET_LEN   = ETH_WORD_SIZE*150 - sizeof(uint32_t), // the parameter to play with (no issues met for granularity=sizeof(uint32_t) and range=[(1...~150)*ETH_WORD_SIZE]
                                                                 // (defaults in Eth100Gb IP as min/max packet length=64...9600(but only upto 9596 works)))
      #ifdef DMA_MEM_HBM
        ETH_MEMPACK_SIZE = ETH_PACKET_LEN
      #else
        ETH_MEMPACK_SIZE = ETH_PACKET_LEN > DMA_AXI_BURST/2  ? ((ETH_PACKET_LEN + DMA_AXI_BURST-1) / DMA_AXI_BURST) * DMA_AXI_BURST :
                           ETH_PACKET_LEN > DMA_AXI_BURST/4  ? DMA_AXI_BURST/2  :
                           ETH_PACKET_LEN > DMA_AXI_BURST/8  ? DMA_AXI_BURST/4  :
                           ETH_PACKET_LEN > DMA_AXI_BURST/16 ? DMA_AXI_BURST/8  :
                           ETH_PACKET_LEN > DMA_AXI_BURST/32 ? DMA_AXI_BURST/16 : ETH_PACKET_LEN
        // ETH_PACKET_DECR = 7*sizeof(uint32_t) // optional length decrement for some packets for test purposes
      #endif
  };
  #if defined(TXRX_MEM_CACHED) || defined(SG_MEM_CACHED)
    // Dummy memory for flushing cache
    enum { CACHE_LINE = 0x40,
           CACHE_SIZE = 0x10000*4};
    uint8_t volatile dummyMem[CACHE_SIZE];
  #endif


  while (true) {

    printf("\n");
    printf("------ Ethernet Test App ------\n");
    printf("Please enter test mode:\n");
    printf("  Single board self-diag/loopback tests: l\n");
    printf("  Two boards diag communication tests:   c\n");
    printf("  Two boards IP-based tests:             i\n");
    printf("  Ethernet link setup:                   s\n");
    printf("  Finish:                                f\n");
    char choice;
    scanf("%s", &choice);
    printf("You have entered: %c\n\n", choice);


    switch (choice) {
      case 'l': {
        #ifdef DMA_MEM_HBM
        printf("------- Running DMA Tx/Rx/SG memory test (HBM-based) -------\n");
        enum {MEM_TEST_COMBINATIONS = 2};
        #else
        printf("------- Running DMA Tx/Rx/SG memory test (SRAM-based) -------\n");
        enum {MEM_TEST_COMBINATIONS = 1};
        #endif
        ethSyst.timerCntInit(); // initializing Timer
        for (size_t memCase = 0; memCase < MEM_TEST_COMBINATIONS; ++memCase) {
        // first clearing previously stored values
        for (size_t addr = 0; addr < txMemWords; ++addr) ethSyst.txMem  [addr] = 0;
        for (size_t addr = 0; addr < rxMemWords; ++addr) ethSyst.rxMem  [addr] = 0;
        for (size_t addr = 0; addr < sgMemWords; ++addr) ethSyst.sgMem  [addr] = 0;
        for (size_t addr = 0; addr < txMemWords; ++addr) ethSyst.txMemNC[addr] = 0;
        for (size_t addr = 0; addr < rxMemWords; ++addr) ethSyst.rxMemNC[addr] = 0;
        for (size_t addr = 0; addr < sgMemWords; ++addr) ethSyst.sgMemNC[addr] = 0;

        size_t txMemAddr;
        size_t rxMemAddr;
        size_t sgMemAddr;
        uint8_t  volatile* txMemWr8 ;
        uint16_t volatile* txMemWr16;
        uint32_t volatile* txMemWr32;
        uint64_t volatile* txMemWr64;
        uint8_t  volatile* rxMemWr8 ;
        uint16_t volatile* rxMemWr16;
        uint32_t volatile* rxMemWr32;
        uint64_t volatile* rxMemWr64;
        uint8_t  volatile* sgMemWr8 ;
        uint16_t volatile* sgMemWr16;
        uint32_t volatile* sgMemWr32;
        uint64_t volatile* sgMemWr64;
        bool wrCachMem = memCase & 0x1;
        if (wrCachMem) {
        printf("Filling assigned regions with random values from %0X to %0X: \n", 0, RAND_MAX);
        txMemAddr = ethSyst.TX_MEM_ADDR;
        rxMemAddr = ethSyst.RX_MEM_ADDR;
        sgMemAddr = ethSyst.SG_MEM_ADDR;
        txMemWr8  = reinterpret_cast<uint8_t  volatile*>(ethSyst.txMem);
        txMemWr16 = reinterpret_cast<uint16_t volatile*>(ethSyst.txMem);
        txMemWr32 = reinterpret_cast<uint32_t volatile*>(ethSyst.txMem);
        txMemWr64 = reinterpret_cast<uint64_t volatile*>(ethSyst.txMem);
        rxMemWr8  = reinterpret_cast<uint8_t  volatile*>(ethSyst.rxMem);
        rxMemWr16 = reinterpret_cast<uint16_t volatile*>(ethSyst.rxMem);
        rxMemWr32 = reinterpret_cast<uint32_t volatile*>(ethSyst.rxMem);
        rxMemWr64 = reinterpret_cast<uint64_t volatile*>(ethSyst.rxMem);
        sgMemWr8  = reinterpret_cast<uint8_t  volatile*>(ethSyst.sgMem);
        sgMemWr16 = reinterpret_cast<uint16_t volatile*>(ethSyst.sgMem);
        sgMemWr32 = reinterpret_cast<uint32_t volatile*>(ethSyst.sgMem);
        sgMemWr64 = reinterpret_cast<uint64_t volatile*>(ethSyst.sgMem);
        } else {
        printf("Filling non-cached regions with random values from %0X to %0X: \n", 0, RAND_MAX);
        txMemAddr = ethSyst.TX_MEMNC_ADDR;
        rxMemAddr = ethSyst.RX_MEMNC_ADDR;
        sgMemAddr = ethSyst.SG_MEMNC_ADDR;
        txMemWr8  = reinterpret_cast<uint8_t  volatile*>(ethSyst.txMemNC);
        txMemWr16 = reinterpret_cast<uint16_t volatile*>(ethSyst.txMemNC);
        txMemWr32 = reinterpret_cast<uint32_t volatile*>(ethSyst.txMemNC);
        txMemWr64 = reinterpret_cast<uint64_t volatile*>(ethSyst.txMemNC);
        rxMemWr8  = reinterpret_cast<uint8_t  volatile*>(ethSyst.rxMemNC);
        rxMemWr16 = reinterpret_cast<uint16_t volatile*>(ethSyst.rxMemNC);
        rxMemWr32 = reinterpret_cast<uint32_t volatile*>(ethSyst.rxMemNC);
        rxMemWr64 = reinterpret_cast<uint64_t volatile*>(ethSyst.rxMemNC);
        sgMemWr8  = reinterpret_cast<uint8_t  volatile*>(ethSyst.sgMemNC);
        sgMemWr16 = reinterpret_cast<uint16_t volatile*>(ethSyst.sgMemNC);
        sgMemWr32 = reinterpret_cast<uint32_t volatile*>(ethSyst.sgMemNC);
        sgMemWr64 = reinterpret_cast<uint64_t volatile*>(ethSyst.sgMemNC);
        }

        size_t const axiWidth = 512 / 8;
        srand(1);
        uint64_t val = 0;
        if      (!wrCachMem)                         printf("  ");
        else if (txMemAddr == ethSyst.TX_MEMNC_ADDR) printf("  Non-cached ");
        else                                         printf("  Cached ");
        printf("TX at addr 0x%lX(virt: 0x%lX) with size %ld \n", txMemAddr, size_t(txMemWr32), txMemSize);
        for (size_t addr = 0; addr < txMemSize; ++addr) {
          uint64_t rand64 = rand();
          val = (val >> 8) | (rand64 << 56);
          size_t axiWordIdx = addr/axiWidth;
          // changing written data type every wide AXI word
          if (axiWordIdx%4 == 0) txMemWr8 [addr  ] = val >> 56;
          if (axiWordIdx%4 == 1) txMemWr16[addr/2] = val >> 48;
          if (axiWordIdx%4 == 2) txMemWr32[addr/4] = val >> 32;
          if (axiWordIdx%4 == 3) txMemWr64[addr/8] = val;
        }
        if      (!wrCachMem)                         printf("  ");
        else if (rxMemAddr == ethSyst.RX_MEMNC_ADDR) printf("  Non-cached ");
        else                                         printf("  Cached ");
        printf("RX at addr 0x%lX(virt: 0x%lX) with size %ld \n", rxMemAddr, size_t(rxMemWr32), rxMemSize);
        for (size_t addr = 0; addr < rxMemSize; ++addr) {
          uint64_t rand64 = rand();
          val = (val >> 8) | (rand64 << 56);
          size_t axiWordIdx = addr/axiWidth;
          // changing written data type every wide AXI word
          if (axiWordIdx%4 == 0) rxMemWr8 [addr  ] = val >> 56;
          if (axiWordIdx%4 == 1) rxMemWr16[addr/2] = val >> 48;
          if (axiWordIdx%4 == 2) rxMemWr32[addr/4] = val >> 32;
          if (axiWordIdx%4 == 3) rxMemWr64[addr/8] = val;
        }
        if      (!wrCachMem)                         printf("  ");
        else if (sgMemAddr == ethSyst.SG_MEMNC_ADDR) printf("  Non-cached ");
        else                                         printf("  Cached ");
        printf("BD at addr 0x%lX(virt: 0x%lX) with size %ld \n", sgMemAddr, size_t(sgMemWr32), sgMemSize);
        for (size_t addr = 0; addr < sgMemSize; ++addr) {
          uint64_t rand64 = rand();
          val = (val >> 8) | (rand64 << 56);
          size_t axiWordIdx = addr/axiWidth;
          // changing written data type every wide AXI word
          if (axiWordIdx%4 == 0) sgMemWr8 [addr  ] = val >> 56;
          if (axiWordIdx%4 == 1) sgMemWr16[addr/2] = val >> 48;
          if (axiWordIdx%4 == 2) sgMemWr32[addr/4] = val >> 32;
          if (axiWordIdx%4 == 3) sgMemWr64[addr/8] = val;
        }
        #if defined(TXRX_MEM_CACHED) || defined(SG_MEM_CACHED)
        if (wrCachMem) // flushing cache
          for (size_t addr = 0; addr < CACHE_SIZE; addr += CACHE_LINE) dummyMem[addr] = 0;
        #endif

        uint8_t  volatile* txMemRd8 ;
        uint16_t volatile* txMemRd16;
        uint32_t volatile* txMemRd32;
        uint64_t volatile* txMemRd64;
        uint8_t  volatile* rxMemRd8 ;
        uint16_t volatile* rxMemRd16;
        uint32_t volatile* rxMemRd32;
        uint64_t volatile* rxMemRd64;
        uint8_t  volatile* sgMemRd8 ;
        uint16_t volatile* sgMemRd16;
        uint32_t volatile* sgMemRd32;
        uint64_t volatile* sgMemRd64;
        bool rdCachMem = memCase & 0x1;
        if (rdCachMem) {
        printf("Reading assigned regions: \n");
        txMemAddr = ethSyst.TX_MEM_ADDR;
        rxMemAddr = ethSyst.RX_MEM_ADDR;
        sgMemAddr = ethSyst.SG_MEM_ADDR;
        txMemRd8  = reinterpret_cast<uint8_t  volatile*>(ethSyst.txMem);
        txMemRd16 = reinterpret_cast<uint16_t volatile*>(ethSyst.txMem);
        txMemRd32 = reinterpret_cast<uint32_t volatile*>(ethSyst.txMem);
        txMemRd64 = reinterpret_cast<uint64_t volatile*>(ethSyst.txMem);
        rxMemRd8  = reinterpret_cast<uint8_t  volatile*>(ethSyst.rxMem);
        rxMemRd16 = reinterpret_cast<uint16_t volatile*>(ethSyst.rxMem);
        rxMemRd32 = reinterpret_cast<uint32_t volatile*>(ethSyst.rxMem);
        rxMemRd64 = reinterpret_cast<uint64_t volatile*>(ethSyst.rxMem);
        sgMemRd8  = reinterpret_cast<uint8_t  volatile*>(ethSyst.sgMem);
        sgMemRd16 = reinterpret_cast<uint16_t volatile*>(ethSyst.sgMem);
        sgMemRd32 = reinterpret_cast<uint32_t volatile*>(ethSyst.sgMem);
        sgMemRd64 = reinterpret_cast<uint64_t volatile*>(ethSyst.sgMem);
        } else {
        printf("Reading non-cached regions: \n");
        txMemAddr = ethSyst.TX_MEMNC_ADDR;
        rxMemAddr = ethSyst.RX_MEMNC_ADDR;
        sgMemAddr = ethSyst.SG_MEMNC_ADDR;
        txMemRd8  = reinterpret_cast<uint8_t  volatile*>(ethSyst.txMemNC);
        txMemRd16 = reinterpret_cast<uint16_t volatile*>(ethSyst.txMemNC);
        txMemRd32 = reinterpret_cast<uint32_t volatile*>(ethSyst.txMemNC);
        txMemRd64 = reinterpret_cast<uint64_t volatile*>(ethSyst.txMemNC);
        rxMemRd8  = reinterpret_cast<uint8_t  volatile*>(ethSyst.rxMemNC);
        rxMemRd16 = reinterpret_cast<uint16_t volatile*>(ethSyst.rxMemNC);
        rxMemRd32 = reinterpret_cast<uint32_t volatile*>(ethSyst.rxMemNC);
        rxMemRd64 = reinterpret_cast<uint64_t volatile*>(ethSyst.rxMemNC);
        sgMemRd8  = reinterpret_cast<uint8_t  volatile*>(ethSyst.sgMemNC);
        sgMemRd16 = reinterpret_cast<uint16_t volatile*>(ethSyst.sgMemNC);
        sgMemRd32 = reinterpret_cast<uint32_t volatile*>(ethSyst.sgMemNC);
        sgMemRd64 = reinterpret_cast<uint64_t volatile*>(ethSyst.sgMemNC);
        }

        // checking written values
        srand(1);
        val = 0;
        if      (!rdCachMem)                         printf("  ");
        else if (txMemAddr == ethSyst.TX_MEMNC_ADDR) printf("  Non-cached ");
        else                                         printf("  Cached ");
        printf("TX at addr 0x%lX(virt: 0x%lX) with size %ld \n", txMemAddr, size_t(txMemRd32), txMemSize);
        for (size_t addr = 0; addr < txMemSize; ++addr) {
          uint64_t rand64 = rand();
          val = (val >> 8) | (rand64 << 56);
          // checking readback using different data types
          if (                 txMemRd8 [addr  ] != val >> 56) {
            printf("\nERROR: Incorrect readback of Byte at addr %lx from Tx Mem: %x, expected: %lx \n",
                         addr, txMemRd8 [addr  ],   val >> 56);
            exit(1);
          }
          if ((addr%2) == 1 && txMemRd16[addr/2] != val >> 48) {
            printf("\nERROR: Incorrect readback of Word-16 at addr %lx from Tx Mem: %x, expected: %lx \n",
                         addr, txMemRd16[addr/2],   val >> 48);
            exit(1);
          }
          if ((addr%4) == 3 && txMemRd32[addr/4] != val >> 32) {
            printf("\nERROR: Incorrect readback of Word-32 at addr %lx from Tx Mem: %x, expected: %lx \n",
                         addr, txMemRd32[addr/4],   val >> 32);
            exit(1);
          }
          if ((addr%8) == 7 && txMemRd64[addr/8] != val) {
            printf("\nERROR: Incorrect readback of Word-64 at addr %lx from Tx Mem: %lx, expected: %lx \n",
                         addr, txMemRd64[addr/8],   val);
            exit(1);
          }
        }
        if      (!rdCachMem)                         printf("  ");
        else if (rxMemAddr == ethSyst.RX_MEMNC_ADDR) printf("  Non-cached ");
        else                                         printf("  Cached ");
        printf("RX at addr 0x%lX(virt: 0x%lX) with size %ld \n", rxMemAddr, size_t(rxMemRd32), rxMemSize);
        for (size_t addr = 0; addr < rxMemSize; ++addr) {
          uint64_t rand64 = rand();
          val = (val >> 8) | (rand64 << 56);
          // checking readback using different data types
          if (                 rxMemRd8 [addr  ] != val >> 56) {
            printf("\nERROR: Incorrect readback of Byte at addr %lx from Rx Mem: %x, expected: %lx \n",
                         addr, rxMemRd8 [addr  ],   val >> 56);
            exit(1);
          }
          if ((addr%2) == 1 && rxMemRd16[addr/2] != val >> 48) {
            printf("\nERROR: Incorrect readback of Word-16 at addr %lx from Rx Mem: %x, expected: %lx \n",
                         addr, rxMemRd16[addr/2],   val >> 48);
            exit(1);
          }
          if ((addr%4) == 3 && rxMemRd32[addr/4] != val >> 32) {
            printf("\nERROR: Incorrect readback of Word-32 at addr %lx from Rx Mem: %x, expected: %lx \n",
                         addr, rxMemRd32[addr/4],   val >> 32);
            exit(1);
          }
          if ((addr%8) == 7 && rxMemRd64[addr/8] != val) {
            printf("\nERROR: Incorrect readback of Word-64 at addr %lx from Rx Mem: %lx, expected: %lx \n",
                         addr, rxMemRd64[addr/8],   val);
            exit(1);
          }
        }
        if      (!rdCachMem)                         printf("  ");
        else if (sgMemAddr == ethSyst.SG_MEMNC_ADDR) printf("  Non-cached ");
        else                                         printf("  Cached ");
        printf("BD at addr 0x%lX(virt: 0x%lX) with size %ld \n", sgMemAddr, size_t(sgMemRd32), sgMemSize);
        for (size_t addr = 0; addr < sgMemSize; ++addr) {
          uint64_t rand64 = rand();
          val = (val >> 8) | (rand64 << 56);
          // checking readback using different data types
          if (                 sgMemRd8 [addr  ] != val >> 56) {
            printf("\nERROR: Incorrect readback of Byte at addr %lx from BD Mem: %x, expected: %lx \n",
                         addr, sgMemRd8 [addr  ],   val >> 56);
            exit(1);
          }
          if ((addr%2) == 1 && sgMemRd16[addr/2] != val >> 48) {
            printf("\nERROR: Incorrect readback of Word-16 at addr %lx from BD Mem: %x, expected: %lx \n",
                         addr, sgMemRd16[addr/2],   val >> 48);
            exit(1);
          }
          if ((addr%4) == 3 && sgMemRd32[addr/4] != val >> 32) {
            printf("\nERROR: Incorrect readback of Word-32 at addr %lx from BD Mem: %x, expected: %lx \n",
                         addr, sgMemRd32[addr/4],   val >> 32);
            exit(1);
          }
          if ((addr%8) == 7 && sgMemRd64[addr/8] != val) {
            printf("\nERROR: Incorrect readback of Word-64 at addr %lx from BD Mem: %lx, expected: %lx \n",
                         addr, sgMemRd64[addr/8],   val);
            exit(1);
          }
        }

        printf("Measuring Tx/Rx memory memcpy() bandwidth with size %ld: \n", txrxMemSize);
        timespec sysStart, sysFin;

        // Tx mem to Rx mem
        srand(1);
        for (size_t addr = 0; addr < rxMemWords; ++addr) rxMemRd32[addr] = 0;
        for (size_t addr = 0; addr < txMemWords; ++addr) txMemWr32[addr] = rand();

        clock_gettime(CLOCK_REALTIME, &sysStart);
        XTmrCtr_Start(&ethSyst.timerCnt, 0); // Start Timer 0
        memcpy((void*)(rxMemRd32), (const void*)(txMemWr32), txrxMemSize);
        float ownTime = XTmrCtr_GetValue(&ethSyst.timerCnt, 0) * ethSyst.TIMER_TICK;
        clock_gettime(CLOCK_REALTIME, &sysFin);
        float sysTime = (sysFin.tv_sec  - sysStart.tv_sec ) * 1e9 +
                        (sysFin.tv_nsec - sysStart.tv_nsec) * 1.;

        srand(1);
        for (size_t addr = 0; addr < rxMemWords; ++addr)
         if (rxMemRd32[addr] != uint32_t(rand())) {
            printf("\nERROR: Incorrect readback of Word-32 at addr %lx from Rx Mem after memcpy(): %x \n", addr, rxMemRd32[addr]);
            exit(1);
          }
        float ownSpeed = txrxMemSize / ownTime * 1e9/(1024*1024);
        float sysSpeed = txrxMemSize / sysTime * 1e9/(1024*1024);
        printf("  Tx mem to Rx mem own time: %f ns, Speed: %f MB/s \n", ownTime, ownSpeed);
        printf("  Tx mem to Rx mem sys time: %f ns, Speed: %f MB/s \n", sysTime, sysSpeed);

        // Rx mem to Tx mem
        srand(1);
        for (size_t addr = 0; addr < txMemWords; ++addr) txMemRd32[addr] = 0;
        for (size_t addr = 0; addr < rxMemWords; ++addr) rxMemWr32[addr] = ~rand();

        clock_gettime(CLOCK_REALTIME, &sysStart);
        XTmrCtr_Start(&ethSyst.timerCnt, 1); // Start Timer 1
        memcpy((void*)(txMemRd32), (const void*)(rxMemWr32), txrxMemSize);
        ownTime = XTmrCtr_GetValue(&ethSyst.timerCnt, 1) * ethSyst.TIMER_TICK;
        clock_gettime(CLOCK_REALTIME, &sysFin);
        sysTime = (sysFin.tv_sec  - sysStart.tv_sec ) * 1e9 +
                  (sysFin.tv_nsec - sysStart.tv_nsec) * 1.;

        srand(1);
        for (size_t addr = 0; addr < txMemWords; ++addr)
         if (txMemRd32[addr] != uint32_t(~rand())) {
            printf("\nERROR: Incorrect readback of Word-32 at addr %lx from Tx Mem after memcpy(): %x \n", addr, txMemRd32[addr]);
            exit(1);
          }
        ownSpeed = txrxMemSize / ownTime * 1e9/(1024*1024);
        sysSpeed = txrxMemSize / sysTime * 1e9/(1024*1024);
        printf("  Rx mem to Tx mem own time: %f ns, Speed: %f MB/s \n", ownTime, ownSpeed);
        printf("  Rx mem to Tx mem sys time: %f ns, Speed: %f MB/s \n", sysTime, sysSpeed);

        printf("------- Combination %ld checked -------\n", memCase);
        } //for (size_t memCase = 0; memCase < MEM_TEST_COMBINATIONS; ++memCase)
        printf("------- DMA Tx/Rx/SG memory test PASSED -------\n\n");


        printf("------- System SRAM memcpy() bandwidth at addr 0x%lX", SRAM_SYST_BASEADDR);
        int fid = open("/dev/mem", O_RDWR);
        if( fid < 0 ) {
          printf("Could not open /dev/mem.\n");
          exit(1);
        }
        uint32_t volatile* sramSys = reinterpret_cast<uint32_t*>(mmap(0, SRAM_SYST_ADRRANGE, PROT_READ|PROT_WRITE, MAP_SHARED, fid, SRAM_SYST_BASEADDR));
        if (sramSys == MAP_FAILED) {
          printf("Memory mapping of system SRAM failed.\n");
          exit(1);
        }
        printf("(virt: 0x%lX) with size %ld (DUMMY TEST NOW) -------\n", size_t(sramSys), SRAM_SYST_ADRRANGE);
        // size_t const sramWords = SRAM_SYST_ADRRANGE / sizeof(uint32_t);

        // Low to High SRAM
        srand(1);
        // for (size_t addr = 0; addr < sramWords/2; ++addr) sramSys[addr] = rand();

        timespec sysStart, sysFin;
        clock_gettime(CLOCK_REALTIME, &sysStart);
        XTmrCtr_Start(&ethSyst.timerCnt, 0); // Start Timer 0
        // memcpy((void*)(sramSys + sramWords/2), (const void*)(sramSys), SRAM_SYST_ADRRANGE/2);
        float ownTime = XTmrCtr_GetValue(&ethSyst.timerCnt, 0) * ethSyst.TIMER_TICK;
        clock_gettime(CLOCK_REALTIME, &sysFin);
        float sysTime = (sysFin.tv_sec  - sysStart.tv_sec ) * 1e9 +
                        (sysFin.tv_nsec - sysStart.tv_nsec) * 1.;

        srand(1);
        // for (size_t addr = sramWords/2; addr < sramWords; ++addr)
        //  if (sramSys[addr] != uint32_t(rand())) {
        //     printf("\nERROR: Incorrect readback of word-32 at addr %lx from High system SRAM half after memcpy(): %x \n", addr, sramSys[addr]);
        //     exit(1);
        //   }
        float ownSpeed = SRAM_SYST_ADRRANGE/2 / ownTime * 1e9/(1024*1024);
        float sysSpeed = SRAM_SYST_ADRRANGE/2 / sysTime * 1e9/(1024*1024);
        printf("Low to High SRAM own time: %f ns, Speed: %f MB/s \n", ownTime, ownSpeed);
        printf("Low to High SRAM sys time: %f ns, Speed: %f MB/s \n", sysTime, sysSpeed);

        // High to Low SRAM
        srand(1);
        // for (size_t addr = sramWords/2; addr < sramWords; ++addr) sramSys[addr] = ~rand();

        clock_gettime(CLOCK_REALTIME, &sysStart);
        XTmrCtr_Start(&ethSyst.timerCnt, 1); // Start Timer 1
        // memcpy((void*)(sramSys), (const void*)(sramSys + sramWords/2), SRAM_SYST_ADRRANGE/2);
        ownTime = XTmrCtr_GetValue(&ethSyst.timerCnt, 1) * ethSyst.TIMER_TICK;
        clock_gettime(CLOCK_REALTIME, &sysFin);
        sysTime = (sysFin.tv_sec  - sysStart.tv_sec ) * 1e9 +
                  (sysFin.tv_nsec - sysStart.tv_nsec) * 1.;

        srand(1);
        // for (size_t addr = 0; addr < sramWords/2; ++addr)
        //  if (sramSys[addr] != uint32_t(~rand())) {
        //     printf("\nERROR: Incorrect readback of word-32 at addr %lx from Low system SRAM half after memcpy(): %x \n", addr, sramSys[addr]);
        //     exit(1);
        //   }
        ownSpeed = SRAM_SYST_ADRRANGE/2 / ownTime * 1e9/(1024*1024);
        sysSpeed = SRAM_SYST_ADRRANGE/2 / sysTime * 1e9/(1024*1024);
        printf("High to Low SRAM own time: %f ns, Speed: %f MB/s \n", ownTime, ownSpeed);
        printf("High to Low SRAM sys time: %f ns, Speed: %f MB/s \n", sysTime, sysSpeed);

        printf("------- System SRAM memcpy() bandwidth measurement PASSED -------\n\n");


        ethSyst.axiDmaInit();
        ethSyst.switch_LB_DMA_Eth(true,  true); // Tx switch: DMA->LB, LB->Eth
        ethSyst.switch_LB_DMA_Eth(false, true); // Rx switch: LB->DMA, Eth->LB

        printf("------- Running DMA Short Loopback test -------\n");
        sleep(1); // in seconds

        srand(1);
        for (size_t addr = 0; addr < txMemWords; ++addr) ethSyst.txMem[addr] = rand();
        for (size_t addr = 0; addr < rxMemWords; ++addr) ethSyst.rxMem[addr] = 0;
        #ifdef TXRX_MEM_CACHED
          // flushing cache
          for (size_t addr = 0; addr < CACHE_SIZE; addr += CACHE_LINE) dummyMem[addr] = 0;
        #endif

        size_t packets = txrxMemSize/DMA_PACKET_LEN;
        if (XAxiDma_HasSg(&ethSyst.axiDma))
          packets = std::min(packets,
                    std::min(ethSyst.txBdCount,
                             ethSyst.rxBdCount));
        printf("DMA: Transferring %ld whole packets with length %d bytes between memories with common size %ld bytes \n",
                    packets, DMA_PACKET_LEN, txrxMemSize);
        size_t dmaTxMemPtr = size_t(ethSyst.TX_MEM_ADDR);
        size_t dmaRxMemPtr = size_t(ethSyst.RX_MEM_ADDR);
        if (XAxiDma_HasSg(&ethSyst.axiDma)) {
          XAxiDma_Bd* rxBdPtr = ethSyst.dmaBDAlloc(true,  packets, DMA_PACKET_LEN, DMA_PACKET_LEN, dmaRxMemPtr); // Rx
          XAxiDma_Bd* txBdPtr = ethSyst.dmaBDAlloc(false, packets, DMA_PACKET_LEN, DMA_PACKET_LEN, dmaTxMemPtr); // Tx
          ethSyst.dmaBDTransfer                   (true,  packets, packets,        rxBdPtr); // Rx
          ethSyst.dmaBDTransfer                   (false, packets, packets,        txBdPtr); // Tx
          txBdPtr             = ethSyst.dmaBDPoll (false, packets); // Tx
          rxBdPtr             = ethSyst.dmaBDPoll (true,  packets); // Rx
          ethSyst.dmaBDFree                       (false, packets, DMA_PACKET_LEN, txBdPtr); // Tx
          ethSyst.dmaBDFree                       (true,  packets, DMA_PACKET_LEN, rxBdPtr); // Rx

          uint32_t transDat = packets * DMA_PACKET_LEN;
          float txTime = XTmrCtr_GetValue(&ethSyst.timerCnt, 0) * ethSyst.TIMER_TICK;
          float rxTime = XTmrCtr_GetValue(&ethSyst.timerCnt, 1) * ethSyst.TIMER_TICK;
          float txSpeed = (transDat * 8) / txTime;
          float rxSpeed = (transDat * 8) / rxTime;
          printf("Transfer: %d Bytes \n", transDat);
          printf("Tx time: %f ns, Speed: %f Gb/s \n", txTime, txSpeed);
          printf("Rx time: %f ns, Speed: %f Gb/s \n", rxTime, rxSpeed);

        }
        else for (size_t packet = 0; packet < packets; packet++) {
		      int status = XAxiDma_SimpleTransfer(&(ethSyst.axiDma), dmaRxMemPtr, DMA_PACKET_LEN, XAXIDMA_DEVICE_TO_DMA);
         	if (XST_SUCCESS != status) {
            printf("\nERROR: XAxiDma Rx transfer %ld failed with status %d\n", packet, status);
            exit(1);
	        }
		      status = XAxiDma_SimpleTransfer(&(ethSyst.axiDma), dmaTxMemPtr, DMA_PACKET_LEN, XAXIDMA_DMA_TO_DEVICE);
         	if (XST_SUCCESS != status) {
            printf("\nERROR: XAxiDma Tx transfer %ld failed with status %d\n", packet, status);
            exit(1);
	        }
		      while ((XAxiDma_Busy(&(ethSyst.axiDma),XAXIDMA_DEVICE_TO_DMA)) ||
			           (XAxiDma_Busy(&(ethSyst.axiDma),XAXIDMA_DMA_TO_DEVICE))) {
            // printf("Waiting untill last Tx/Rx transfer finishes \n");
            // sleep(1); // in seconds, user wait process
          }
          dmaTxMemPtr += DMA_PACKET_LEN;
          dmaRxMemPtr += DMA_PACKET_LEN;
    		}

        for (size_t addr = 0; addr < (packets * DMA_PACKET_LEN)/sizeof(uint32_t); ++addr) {
          if (ethSyst.rxMem[addr] != ethSyst.txMem[addr]) {
            printf("\nERROR: Incorrect data transferred by DMA at addr %ld: %0X, expected: %0X \n", addr, ethSyst.rxMem[addr], ethSyst.txMem[addr]);
            exit(1);
          }
        }
        printf("------- DMA Short Loopback test PASSED -------\n\n");

        ethSyst.ethCoreInit();
        ethSyst.ethCoreBringup(true);  // loopback mode
        ethSyst.switch_LB_DMA_Eth(true,  false); // Tx switch: DMA->Eth, Eth LB->DMA LB
        ethSyst.switch_LB_DMA_Eth(false, false); // Rx switch: Eth->DMA, DMA LB->Eth LB
        ethSyst.ethTxRxEnable(); // Enabling Ethernet TX/RX
        sleep(1); // in seconds

        printf("------- Running DMA Near-end loopback test -------\n");
        srand(1);
        for (size_t addr = 0; addr < txMemWords; ++addr) ethSyst.txMem[addr] = rand();
        for (size_t addr = 0; addr < rxMemWords; ++addr) ethSyst.rxMem[addr] = 0;
        #ifdef TXRX_MEM_CACHED
          // flushing cache
          for (size_t addr = 0; addr < CACHE_SIZE; addr += CACHE_LINE) dummyMem[addr] = 0;
        #endif

        packets = txrxMemSize/ETH_MEMPACK_SIZE;
        if (XAxiDma_HasSg(&ethSyst.axiDma))
          packets = std::min(packets,
                    std::min(ethSyst.txBdCount,
                             ethSyst.rxBdCount));
      #ifdef DMA_MEM_HBM
        size_t txBunch = packets;
      #else
        size_t txBunch = ETH_PACKET_LEN > ETH_WORD_SIZE*4 ? 1 : packets; // whole bunch Tx kick-off for small packets
      #endif
        printf("DMA: Transferring %ld whole packets with length %d bytes between memories with common size %ld bytes (packet allocation %d bytes) \n",
                    packets, ETH_PACKET_LEN, txrxMemSize, ETH_MEMPACK_SIZE);
        dmaTxMemPtr = size_t(ethSyst.TX_MEM_ADDR);
        dmaRxMemPtr = size_t(ethSyst.RX_MEM_ADDR);
        if (XAxiDma_HasSg(&ethSyst.axiDma)) {
          XAxiDma_Bd* rxBdPtr = ethSyst.dmaBDAlloc(true,  packets, ETH_PACKET_LEN, ETH_MEMPACK_SIZE, dmaRxMemPtr); // Rx
          XAxiDma_Bd* txBdPtr = ethSyst.dmaBDAlloc(false, packets, ETH_PACKET_LEN, ETH_MEMPACK_SIZE, dmaTxMemPtr); // Tx
          ethSyst.dmaBDTransfer                   (true,  packets, packets,        rxBdPtr); // Rx
          ethSyst.dmaBDTransfer                   (false, packets, txBunch,        txBdPtr); // Tx, each packet kick-off for big packets
          txBdPtr             = ethSyst.dmaBDPoll (false, packets); // Tx
          rxBdPtr             = ethSyst.dmaBDPoll (true,  packets); // Rx
          ethSyst.dmaBDFree                       (false, packets, ETH_PACKET_LEN, txBdPtr); // Tx
          ethSyst.dmaBDFree                       (true,  packets, ETH_PACKET_LEN, rxBdPtr); // Rx

          uint32_t transDat = packets * ETH_PACKET_LEN;
          float txTime = XTmrCtr_GetValue(&ethSyst.timerCnt, 0) * ethSyst.TIMER_TICK;
          float rxTime = XTmrCtr_GetValue(&ethSyst.timerCnt, 1) * ethSyst.TIMER_TICK;
          float txSpeed = (transDat * 8) / txTime;
          float rxSpeed = (transDat * 8) / rxTime;
          printf("Transfer: %d Bytes \n", transDat);
          printf("Tx time: %f ns, Speed: %f Gb/s \n", txTime, txSpeed);
          printf("Rx time: %f ns, Speed: %f Gb/s \n", rxTime, rxSpeed);
        }
        else for (size_t packet = 0; packet < packets; packet++) {
          int status = XAxiDma_SimpleTransfer(&(ethSyst.axiDma), dmaRxMemPtr, ETH_PACKET_LEN, XAXIDMA_DEVICE_TO_DMA);
          if (XST_SUCCESS != status) {
            printf("\nERROR: XAxiDma Rx transfer %ld failed with status %d\n", packet, status);
            exit(1);
          }
          status = XAxiDma_SimpleTransfer(&(ethSyst.axiDma), dmaTxMemPtr, ETH_PACKET_LEN, XAXIDMA_DMA_TO_DEVICE);
          if (XST_SUCCESS != status) {
            printf("\nERROR: XAxiDma Tx transfer %ld failed with status %d\n", packet, status);
            exit(1);
          }
          while ((XAxiDma_Busy(&(ethSyst.axiDma),XAXIDMA_DEVICE_TO_DMA)) ||
                 (XAxiDma_Busy(&(ethSyst.axiDma),XAXIDMA_DMA_TO_DEVICE))) {
            // printf("Waiting untill Tx/Rx transfer finishes \n");
            // sleep(1); // in seconds, user wait process
          }
          dmaTxMemPtr += ETH_MEMPACK_SIZE;
          dmaRxMemPtr += ETH_MEMPACK_SIZE;
        }

        for (size_t packet = 0; packet < packets; packet++)
        for (size_t word   = 0; word < ETH_MEMPACK_SIZE/sizeof(uint32_t); word++) {
          size_t addr = packet*ETH_MEMPACK_SIZE/sizeof(uint32_t) + word;
          if (word < ETH_PACKET_LEN/sizeof(uint32_t)) {
            if (ethSyst.rxMem[addr] != ethSyst.txMem[addr]) {
              printf("\nERROR: Incorrect data transferred by DMA in 32-bit word %ld of packet %ld at addr %ld: %0X, expected: %0X \n",
                          word, packet, addr, ethSyst.rxMem[addr], ethSyst.txMem[addr]);
              exit(1);
            }
          }
          else if (word == ETH_PACKET_LEN/sizeof(uint32_t)) {
            uint32_t expectVal = ethSyst.txMem[addr] & ((1<<(8*(ETH_PACKET_LEN%sizeof(uint32_t))))-1);
            if (ethSyst.rxMem[addr] != expectVal) {
              printf("\nERROR: Incorrect data transferred by DMA in last 32-bit word %ld of packet %ld at addr %ld: %0X, expected: %0X \n",
                          word, packet, addr, ethSyst.rxMem[addr], expectVal);
              exit(1);
            }
          }
          else if (ethSyst.rxMem[addr] != 0) {
              printf("\nERROR: Data in 32-bit word %ld of packet %ld overwrite stored zero at addr %ld: %0X \n",
                         word, packet, addr, ethSyst.rxMem[addr]);
              exit(1);
          }
        }

        ethSyst.ethTxRxDisable(); //Disabling Ethernet TX/RX
        printf("------- DMA Near-end loopback test PASSED -------\n\n");

      }
      break;


      case 'c': {
        printf("------- Running 2-boards communication test -------\n");
        printf("Please make sure that the same mode is running on the other side and confirm with 'y'...\n");
        char confirm;
        scanf("%s", &confirm);
        printf("%c\n", confirm);
        if (confirm != 'y') break;

        ethSyst.timerCntInit(); // initializing Timer
        ethSyst.ethCoreInit();
        ethSyst.ethCoreBringup(false); // non-loopback mode
        ethSyst.axiDmaInit();
        ethSyst.switch_LB_DMA_Eth(true,  false); // Tx switch: DMA->Eth, Eth LB->DMA LB
        ethSyst.switch_LB_DMA_Eth(false, false); // Rx switch: Eth->DMA, DMA LB->Eth LB
        ethSyst.ethTxRxEnable(); // Enabling Ethernet TX/RX
        sleep(1); // in seconds

        printf("------- Async DMA 2-boards communication test -------\n");

        srand(1);
        for (size_t addr = 0; addr < txMemWords; ++addr) ethSyst.txMem[addr] = rand();
        for (size_t addr = 0; addr < rxMemWords; ++addr) ethSyst.rxMem[addr] = 0;
        #ifdef TXRX_MEM_CACHED
          // flushing cache
          for (size_t addr = 0; addr < CACHE_SIZE; addr += CACHE_LINE) dummyMem[addr] = 0;
        #endif

        size_t packets = txrxMemSize/ETH_MEMPACK_SIZE;
        if (XAxiDma_HasSg(&ethSyst.axiDma))
          packets = std::min(packets,
                    std::min(ethSyst.txBdCount,
                             ethSyst.rxBdCount));
      #ifdef DMA_MEM_HBM
        size_t txBunch = packets;
      #else
        size_t txBunch = ETH_PACKET_LEN > ETH_WORD_SIZE*4 ? 1 : packets; // whole bunch Tx kick-off for small packets
      #endif
        printf("DMA: Transferring %ld whole packets with length %d bytes between memories with common size %ld bytes (packet allocation %d bytes) \n",
                    packets, ETH_PACKET_LEN, txrxMemSize, ETH_MEMPACK_SIZE);
        size_t dmaTxMemPtr = size_t(ethSyst.TX_MEM_ADDR);
        size_t dmaRxMemPtr = size_t(ethSyst.RX_MEM_ADDR);
        if (XAxiDma_HasSg(&ethSyst.axiDma)) {
          XAxiDma_Bd* rxBdPtr = ethSyst.dmaBDAlloc(true,  packets, ETH_PACKET_LEN, ETH_MEMPACK_SIZE, dmaRxMemPtr); // Rx
          XAxiDma_Bd* txBdPtr = ethSyst.dmaBDAlloc(false, packets, ETH_PACKET_LEN, ETH_MEMPACK_SIZE, dmaTxMemPtr); // Tx
          ethSyst.dmaBDTransfer                   (true,  packets, packets,        rxBdPtr); // Rx
          sleep(3); // in seconds, timeout before Tx transfer to make sure opposite side also has set Rx transfer
          ethSyst.dmaBDTransfer                   (false, packets, txBunch,        txBdPtr); // Tx, each packet kick-off for big packets
          txBdPtr             = ethSyst.dmaBDPoll (false, packets); // Tx
          rxBdPtr             = ethSyst.dmaBDPoll (true,  packets); // Rx
          ethSyst.dmaBDFree                       (false, packets, ETH_PACKET_LEN, txBdPtr); // Tx
          ethSyst.dmaBDFree                       (true,  packets, ETH_PACKET_LEN, rxBdPtr); // Rx

          uint32_t transDat = packets * ETH_PACKET_LEN;
          float txTime = XTmrCtr_GetValue(&ethSyst.timerCnt, 0) * ethSyst.TIMER_TICK;
          float rxTime = XTmrCtr_GetValue(&ethSyst.timerCnt, 1) * ethSyst.TIMER_TICK;
          float txSpeed = (transDat * 8) / txTime;
          float rxSpeed = (transDat * 8) / rxTime;
          printf("Transfer: %d Bytes \n", transDat);
          printf("Tx time: %f ns, Speed: %f Gb/s \n", txTime, txSpeed);
          if (0) printf("Rx time: %f ns, Speed: %f Gb/s \n", rxTime, rxSpeed); // meaningless here
        }
        else for (size_t packet = 0; packet < packets; packet++) {
          int status = XAxiDma_SimpleTransfer(&(ethSyst.axiDma), dmaRxMemPtr, ETH_PACKET_LEN, XAXIDMA_DEVICE_TO_DMA);
          if (XST_SUCCESS != status) {
            printf("\nERROR: XAxiDma Rx transfer %ld failed with status %d\n", packet, status);
            exit(1);
          }
          if (packet == 0) sleep(1); // in seconds, timeout before 1st packet Tx transfer to make sure opposite side also has set Rx transfer
          status = XAxiDma_SimpleTransfer(&(ethSyst.axiDma), dmaTxMemPtr, ETH_PACKET_LEN, XAXIDMA_DMA_TO_DEVICE);
          if (XST_SUCCESS != status) {
            printf("\nERROR: XAxiDma Tx transfer %ld failed with status %d\n", packet, status);
            exit(1);
          }
          while ((XAxiDma_Busy(&(ethSyst.axiDma),XAXIDMA_DEVICE_TO_DMA)) ||
                 (XAxiDma_Busy(&(ethSyst.axiDma),XAXIDMA_DMA_TO_DEVICE))) {
            // printf("Waiting untill Tx/Rx transfer finishes \n");
            // sleep(1); // in seconds, user wait process
          }
          dmaTxMemPtr += ETH_MEMPACK_SIZE;
          dmaRxMemPtr += ETH_MEMPACK_SIZE;
        }

        for (size_t packet = 0; packet < packets; packet++)
        for (size_t word   = 0; word < ETH_MEMPACK_SIZE/sizeof(uint32_t); word++) {
          size_t addr = packet*ETH_MEMPACK_SIZE/sizeof(uint32_t) + word;
          if (word < ETH_PACKET_LEN/sizeof(uint32_t)) {
            if (ethSyst.rxMem[addr] != ethSyst.txMem[addr]) {
              printf("\nERROR: Incorrect data transferred by DMA in 32-bit word %ld of packet %ld at addr %ld: %0X, expected: %0X \n",
                          word, packet, addr, ethSyst.rxMem[addr], ethSyst.txMem[addr]);
              exit(1);
            }
          }
          else if (word == ETH_PACKET_LEN/sizeof(uint32_t)) {
            uint32_t expectVal = ethSyst.txMem[addr] & ((1<<(8*(ETH_PACKET_LEN%sizeof(uint32_t))))-1);
            if (ethSyst.rxMem[addr] != expectVal) {
              printf("\nERROR: Incorrect data transferred by DMA in last 32-bit word %ld of packet %ld at addr %ld: %0X, expected: %0X \n",
                          word, packet, addr, ethSyst.rxMem[addr], expectVal);
              exit(1);
            }
          }
          else if (ethSyst.rxMem[addr] != 0) {
              printf("\nERROR: Data in 32-bit word %ld of packet %ld overwrite stored zero at addr %ld: %0X \n",
                          word, packet, addr, ethSyst.rxMem[addr]);
              exit(1);
          }
        }
        printf("------- Async DMA 2-boards communication test PASSED -------\n\n");


        printf("------- Round-trip DMA 2-boards communication test -------\n");
        srand(1);
        for (size_t addr = 0; addr < txMemWords; ++addr) ethSyst.txMem[addr] = rand();
        for (size_t addr = 0; addr < rxMemWords; ++addr) ethSyst.rxMem[addr] = 0;
        #ifdef TXRX_MEM_CACHED
          // flushing cache
          for (size_t addr = 0; addr < CACHE_SIZE; addr += CACHE_LINE) dummyMem[addr] = 0;
        #endif

        packets = txrxMemSize/ETH_MEMPACK_SIZE;
        if (XAxiDma_HasSg(&ethSyst.axiDma))
          packets = std::min(packets,
                    std::min(ethSyst.txBdCount,
                             ethSyst.rxBdCount));
      #ifdef DMA_MEM_HBM
        txBunch = packets;
      #else
        txBunch = ETH_PACKET_LEN > ETH_WORD_SIZE*4 ? 1 : packets; // whole bunch Tx kick-off for small packets
      #endif
        printf("DMA: Transferring %ld whole packets with length %d bytes between memories with common size %ld bytes (packet allocation %d bytes) \n",
                    packets, ETH_PACKET_LEN, txrxMemSize, ETH_MEMPACK_SIZE);
        dmaTxMemPtr = size_t(ethSyst.TX_MEM_ADDR);
        dmaRxMemPtr = size_t(ethSyst.RX_MEM_ADDR);
        if (XAxiDma_HasSg(&ethSyst.axiDma)) {
          XAxiDma_Bd* rxBdPtr = ethSyst.dmaBDAlloc(true,  packets, ETH_PACKET_LEN, ETH_MEMPACK_SIZE, dmaRxMemPtr); // Rx
          XAxiDma_Bd* txBdPtr = ethSyst.dmaBDAlloc(false, packets, ETH_PACKET_LEN, ETH_MEMPACK_SIZE, dmaTxMemPtr); // Tx
          ethSyst.dmaBDTransfer                   (true,  packets, packets,        rxBdPtr); // Rx
          if (ethSyst.physConnOrder) { // depending on board instance play "initiator" role
            printf("Initiator side: starting the transfer and receiving it back \n");
            sleep(3); // in seconds, timeout before Tx transfer to make sure opposite side also has set Rx transfer
            ethSyst.dmaBDTransfer                 (false, packets, txBunch,        txBdPtr); // Tx, each packet kick-off for big packets
            txBdPtr           = ethSyst.dmaBDPoll (false, packets); // Tx
            rxBdPtr           = ethSyst.dmaBDPoll (true,  packets); // Rx
          } else { // depending on board instance play "responder" role
            printf("Responder side: accepting the transfer and sending it back \n");
            rxBdPtr           = ethSyst.dmaBDPoll (true,  packets); // Rx
            ethSyst.dmaBDTransfer                 (false, packets, txBunch,        txBdPtr); // Tx, each packet kick-off for big packets
            txBdPtr           = ethSyst.dmaBDPoll (false, packets); // Tx
          }
          ethSyst.dmaBDFree                       (false, packets, ETH_PACKET_LEN, txBdPtr); // Tx
          ethSyst.dmaBDFree                       (true,  packets, ETH_PACKET_LEN, rxBdPtr); // Rx
          uint32_t transDat = packets * ETH_PACKET_LEN;
          float txTime = XTmrCtr_GetValue(&ethSyst.timerCnt, 0) * ethSyst.TIMER_TICK;
          float rxTime = XTmrCtr_GetValue(&ethSyst.timerCnt, 1) * ethSyst.TIMER_TICK;
          float txSpeed = (    transDat * 8) / txTime;
          float rxSpeed = (2 * transDat * 8) / rxTime; //transfer is doubled due to round-trip
          printf("Transfer: %d Bytes \n", transDat);
          printf("Tx time: %f ns, Speed: %f Gb/s \n", txTime, txSpeed);
          if (ethSyst.physConnOrder) printf("Rx time: %f ns, Speed: %f Gb/s \n", rxTime, rxSpeed);
        }
        else {
          printf("For Simple DMA mode no Round-trip exchange is done, Asynch exchange is executed instead \n");
          for (size_t packet = 0; packet < packets; packet++) {
          int status = XAxiDma_SimpleTransfer(&(ethSyst.axiDma), dmaRxMemPtr, ETH_PACKET_LEN, XAXIDMA_DEVICE_TO_DMA);
          if (XST_SUCCESS != status) {
            printf("\nERROR: XAxiDma Rx transfer %ld failed with status %d\n", packet, status);
            exit(1);
          }
          if (packet == 0) sleep(1); // in seconds, timeout before 1st packet Tx transfer to make sure opposite side also has set Rx transfer
          status = XAxiDma_SimpleTransfer(&(ethSyst.axiDma), dmaTxMemPtr, ETH_PACKET_LEN, XAXIDMA_DMA_TO_DEVICE);
          if (XST_SUCCESS != status) {
            printf("\nERROR: XAxiDma Tx transfer %ld failed with status %d\n", packet, status);
            exit(1);
          }
          while ((XAxiDma_Busy(&(ethSyst.axiDma),XAXIDMA_DEVICE_TO_DMA)) ||
                 (XAxiDma_Busy(&(ethSyst.axiDma),XAXIDMA_DMA_TO_DEVICE))) {
            // printf("Waiting untill Tx/Rx transfer finishes \n");
            // sleep(1); // in seconds, user wait process
          }
          dmaTxMemPtr += ETH_MEMPACK_SIZE;
          dmaRxMemPtr += ETH_MEMPACK_SIZE;
          }
        }

        for (size_t packet = 0; packet < packets; packet++)
        for (size_t word   = 0; word < ETH_MEMPACK_SIZE/sizeof(uint32_t); word++) {
          size_t addr = packet*ETH_MEMPACK_SIZE/sizeof(uint32_t) + word;
          if (word < ETH_PACKET_LEN/sizeof(uint32_t)) {
            if (ethSyst.rxMem[addr] != ethSyst.txMem[addr]) {
              printf("\nERROR: Incorrect data transferred by DMA in 32-bit word %ld of packet %ld at addr %ld: %0X, expected: %0X \n",
                          word, packet, addr, ethSyst.rxMem[addr], ethSyst.txMem[addr]);
              exit(1);
            }
          }
          else if (word == ETH_PACKET_LEN/sizeof(uint32_t)) {
            uint32_t expectVal = ethSyst.txMem[addr] & ((1<<(8*(ETH_PACKET_LEN%sizeof(uint32_t))))-1);
            if (ethSyst.rxMem[addr] != expectVal) {
              printf("\nERROR: Incorrect data transferred by DMA in last 32-bit word %ld of packet %ld at addr %ld: %0X, expected: %0X \n",
                          word, packet, addr, ethSyst.rxMem[addr], expectVal);
              exit(1);
            }
          }
          else if (ethSyst.rxMem[addr] != 0) {
              printf("\nERROR: Data in 32-bit word %ld of packet %ld overwrite stored zero at addr %ld: %0X \n",
                          word, packet, addr, ethSyst.rxMem[addr]);
              exit(1);
          }
        }

        ethSyst.ethTxRxDisable(); //Disabling Ethernet TX/RX
        printf("------- Round-trip DMA 2-boards communication test PASSED -------\n\n");
      }
      break;


      case 'i': {
        printf("------- Running 2-boards IP-based tests -------\n");
        printf("Please make sure that the same mode is running on the other side and confirm with 'y'...\n");
        char confirm;
        scanf("%s", &confirm);
        printf("%c\n", confirm);
        if (confirm != 'y') break;

        ethSyst.timerCntInit(); // initializing Timer
        ethSyst.ethCoreInit();
        ethSyst.ethCoreBringup(false); // non-loopback mode
        ethSyst.axiDmaInit();
        ethSyst.switch_LB_DMA_Eth(true,  false); // Tx switch: DMA->Eth, Eth LB->DMA LB
        ethSyst.switch_LB_DMA_Eth(false, false); // Rx switch: Eth->DMA, DMA LB->Eth LB
        ethSyst.ethTxRxEnable(); // Enabling Ethernet TX/RX

        while (true) {
          printf("\n------- Please choose particular IP-based test:\n");
          printf("  Ping reply   test:       p\n");
          printf("  Ping request test:       q\n");
          printf("  LwIP UDP Server (empty): u\n");
          printf("  LwIP UDP Client (empty): d\n");
          printf("  LwIP TCP Server (empty): t\n");
          printf("  LwIP TCP Client (empty): c\n");
          printf("  Exit to main menu:       e\n");
          char choice;
          scanf("%s", &choice);
          printf("You have entered: %c\n\n", choice);

          switch (choice) {
            case 'p': {
              printf("------- Ping Reply test -------\n");
              PingReplyTest pingReplyTest(&ethSyst);
              int status = pingReplyTest.pingReply();
              if (status != XST_SUCCESS) {
                printf("\nERROR: Ping Reply test failed with status %d\n", status);
                exit(1);
              }
              printf("------- Ping Reply test finished -------\n\n");
            }
            break;

            case 'q': {
              printf("------- Ping Request test -------\n");
              PingReqstTest pingReqstTest(&ethSyst);
            	int status = pingReqstTest.pingReqst();
	            if (status != XST_SUCCESS) {
		            printf("\nERROR: Ping Request test failed with status %d\n", status);
                exit(1);
	            }
              printf("------- Ping Request test finished -------\n\n");
            }
            break;

            case 'u': {
              printf("------- LwIP UDP Perf Server -------\n");
            	// int status = udp_perf_server();
	            // if (status != XST_SUCCESS) {
		          //   printf("\nERROR: LwIP UDP Perf Server failed with status %d\n", status);
              //   exit(1);
	            // }
              printf("------- LwIP UDP Perf Server finished -------\n\n");
            }
            break;

            case 'd': {
              printf("------- LwIP UDP Perf Client -------\n");
            	// int status = udp_perf_client();
	            // if (status != XST_SUCCESS) {
		          //   printf("\nERROR: LwIP UDP Perf Client failed with status %d\n", status);
              //   exit(1);
	            // }
              printf("------- LwIP UDP Perf Client finished -------\n\n");
            }
            break;

            case 't': {
              printf("------- LwIP TCP Perf Server -------\n");
            	// int status = tcp_perf_server();
	            // if (status != XST_SUCCESS) {
		          //   printf("\nERROR: LwIP TCP Perf Server failed with status %d\n", status);
              //   exit(1);
	            // }
              printf("------- LwIP TCP Perf Server finished -------\n\n");
            }
            break;

            case 'c': {
              printf("------- LwIP TCP Perf Client -------\n");
            	// int status = tcp_perf_client();
	            // if (status != XST_SUCCESS) {
		          //   printf("\nERROR: LwIP TCP Perf Client failed with status %d\n", status);
              //   exit(1);
	            // }
              printf("------- LwIP TCP Perf Client finished -------\n\n");
            }
            break;

            case 'e':
              printf("------- Exiting to main menu -------\n");
              break;

            default: printf("Please choose right option\n");
          }
          if (choice == 'e') break;
        }

        ethSyst.ethTxRxDisable();
      }
      break;

      case 's': {
        printf("------- Ethernet link setup -------\n");
        ethSyst.ethCoreInit();
        ethSyst.switch_LB_DMA_Eth(true,  false); // Tx switch: DMA->Eth, Eth LB->DMA LB
        ethSyst.switch_LB_DMA_Eth(false, false); // Rx switch: Eth->DMA, DMA LB->Eth LB
        ethSyst.ethTxRxEnable(); // Enabling Ethernet TX/RX
      }
      break;

      case 'f':
        printf("------- Exiting the app -------\n");
        return(0);

      default: printf("Please choose right option\n");
    }
  }
}

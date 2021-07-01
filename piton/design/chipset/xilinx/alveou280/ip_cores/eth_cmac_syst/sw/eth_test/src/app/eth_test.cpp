
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <algorithm>
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

bool txIntrProcessed;
void dmaTxTestHandler() {
  printf("Tx Handler has started: %d\n", txIntrProcessed);
  // Indicate the interrupt has been processed using a shared variable.
	txIntrProcessed = true;
}
void dmaTxTestFastHandler() {
  printf("Fast ");
  dmaTxTestHandler();
}

bool rxIntrProcessed;
void dmaRxTestHandler()
{
  printf("Rx Handler has started: %d\n", rxIntrProcessed);
  // Indicate the interrupt has been processed using a shared variable.
	rxIntrProcessed = true;
}
void dmaRxTestFastHandler() {
  printf("Fast ");
  dmaRxTestHandler();
}

int main(int argc, char *argv[])
{
  EthSyst ethSyst; // Instance of the Ethernet System driver
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
        CPU_PACKET_LEN   = ETH_WORD_SIZE * 8, // the parameter to play with
        CPU_PACKET_WORDS = (CPU_PACKET_LEN + ETH_WORD_SIZE - 1) / ETH_WORD_SIZE,
        DMA_PACKET_LEN   = txrxMemSize/3     - sizeof(uint32_t), // the parameter to play with (no issies met for any values and granularities)
        ETH_PACKET_LEN   = ETH_WORD_SIZE*150 - sizeof(uint32_t), // the parameter to play with (no issues met for granularity=sizeof(uint32_t) and range=[(1...~150)*ETH_WORD_SIZE]
                                                                 // (defaults in Eth100Gb IP as min/max packet length=64...9600(but only upto 9596 works)))
        ETH_MEMPACK_SIZE = ETH_PACKET_LEN > DMA_AXI_BURST/2  ? ((ETH_PACKET_LEN + DMA_AXI_BURST-1) / DMA_AXI_BURST) * DMA_AXI_BURST :
                           ETH_PACKET_LEN > DMA_AXI_BURST/4  ? DMA_AXI_BURST/2  :
                           ETH_PACKET_LEN > DMA_AXI_BURST/8  ? DMA_AXI_BURST/4  :
                           ETH_PACKET_LEN > DMA_AXI_BURST/16 ? DMA_AXI_BURST/8  :
                           ETH_PACKET_LEN > DMA_AXI_BURST/32 ? DMA_AXI_BURST/16 : ETH_PACKET_LEN
        // ETH_PACKET_DECR = 7*sizeof(uint32_t) // optional length decrement for some packets for test purposes
  };
  enum { // hardware defined depths of channels
        SHORT_LOOPBACK_DEPTH  = 104,
        TRANSMIT_FIFO_DEPTH   = 40,
        DMA_TX_LOOPBACK_DEPTH = CPU_PACKET_WORDS==1 ? 95 : 96,
        DMA_RX_LOOPBACK_DEPTH = CPU_PACKET_WORDS==1 ? 43 : 40
  };


  while (true) {

    printf("\n");
    printf("------ Ethernet Test App ------\n");
    printf("Please enter test mode:\n");
    printf("  Single board self-diag/loopback tests: l\n");
    printf("  Two boards diag communication tests:   c\n");
    printf("  Two boards IP-based tests:             i\n");
    printf("  Finish:                                f\n");
    char choice;
    scanf("%s", &choice);
    printf("You have entered: %c\n\n", choice);


    switch (choice) {
      case 'l': {
        printf("------- Running DMA Tx/Rx/SG memory test -------\n");
        printf("Checking memories with random values from %0X to %0X \n", 0, RAND_MAX);
        // first clearing previously stored values
        for (size_t addr = 0; addr < txMemWords; ++addr) ethSyst.txMem[addr] = 0;
        for (size_t addr = 0; addr < rxMemWords; ++addr) ethSyst.rxMem[addr] = 0;
        for (size_t addr = 0; addr < sgMemWords; ++addr) ethSyst.sgMem[addr] = 0;
        srand(1);
        for (size_t addr = 0; addr < txMemWords; ++addr) ethSyst.txMem[addr] = rand();
        for (size_t addr = 0; addr < rxMemWords; ++addr) ethSyst.rxMem[addr] = rand();
        for (size_t addr = 0; addr < sgMemWords; ++addr) ethSyst.sgMem[addr] = rand();
        srand(1);
        printf("Checking TX memory at addr 0x%lX(virt: 0x%lX) with size %ld \n", ETH_SYST_BASEADDR+TX_MEM_CPU_BASEADDR, size_t(ethSyst.txMem), txMemSize);
        for (size_t addr = 0; addr < txMemWords; ++addr) {
          uint32_t expectVal = rand(); 
          if (ethSyst.txMem[addr] != expectVal) {
            printf("\nERROR: Incorrect readback of word at addr %0lX from Tx Mem: %0X, expected: %0X \n", addr, ethSyst.txMem[addr], expectVal);
            exit(1);
          }
        }
        printf("Checking RX memory at addr 0x%lX(virt: 0x%lX) with size %ld \n", ETH_SYST_BASEADDR+RX_MEM_CPU_BASEADDR, size_t(ethSyst.rxMem), rxMemSize);
        for (size_t addr = 0; addr < rxMemWords; ++addr) {
          uint32_t expectVal = rand(); 
          if (ethSyst.rxMem[addr] != expectVal) {
            printf("\nERROR: Incorrect readback of word at addr %0lX from Rx Mem: %0X, expected: %0X \n", addr, ethSyst.rxMem[addr], expectVal);
            exit(1);
          }
        }
        printf("Checking BD memory at addr 0x%lX(virt: 0x%lX) with size %ld \n", ETH_SYST_BASEADDR+SG_MEM_CPU_BASEADDR, size_t(ethSyst.sgMem), sgMemSize);
        for (size_t addr = 0; addr < sgMemWords; ++addr) {
          uint32_t expectVal = rand(); 
          if (ethSyst.sgMem[addr] != expectVal) {
            printf("\nERROR: Incorrect readback of word at addr %0lX from SG Mem: %0X, expected: %0X \n", addr, ethSyst.sgMem[addr], expectVal);
            exit(1);
          }
        }
        printf("------- DMA Tx/Rx/SG memory test PASSED -------\n\n");

        ethSyst.axiDmaInit();

        printf("------- Running DMA Short Loopback test -------\n");
        ethSyst.switch_CPU_DMAxEth_LB(true,  true); // Tx switch: DMA->LB, CPU->Eth
        ethSyst.switch_CPU_DMAxEth_LB(false, true); // Rx switch: LB->DMA, Eth->CPU
        sleep(1); // in seconds

        srand(1);
        for (size_t addr = 0; addr < txMemWords; ++addr) ethSyst.txMem[addr] = rand();
        for (size_t addr = 0; addr < rxMemWords; ++addr) ethSyst.rxMem[addr] = 0;

        size_t packets = txrxMemSize/DMA_PACKET_LEN;
        if (XAxiDma_HasSg(&ethSyst.axiDma))
          packets = std::min(packets,
                    std::min(ethSyst.txBdCount,
                             ethSyst.rxBdCount));
        printf("DMA: Transferring %ld whole packets with length %d bytes between memories with common size %ld bytes \n",
                    packets, DMA_PACKET_LEN, txrxMemSize);
        size_t dmaTxMemPtr = size_t(ethSyst.txMem);
        size_t dmaRxMemPtr = size_t(ethSyst.rxMem);
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

        ethSyst.ethCoreInit(true);

        printf("------- Running DMA Near-end loopback test -------\n");
        ethSyst.switch_CPU_DMAxEth_LB(true,  false); // Tx switch: DMA->Eth, CPU->LB
        ethSyst.switch_CPU_DMAxEth_LB(false, false); // Rx switch: Eth->DMA, LB->CPU
        sleep(1); // in seconds

        srand(1);
        for (size_t addr = 0; addr < txMemWords; ++addr) ethSyst.txMem[addr] = rand();
        for (size_t addr = 0; addr < rxMemWords; ++addr) ethSyst.rxMem[addr] = 0;

        ethSyst.ethTxRxEnable(); // Enabling Ethernet TX/RX

        packets = txrxMemSize/ETH_MEMPACK_SIZE;
        if (XAxiDma_HasSg(&ethSyst.axiDma))
          packets = std::min(packets,
                    std::min(ethSyst.txBdCount,
                             ethSyst.rxBdCount));
        size_t txBunch = ETH_PACKET_LEN > ETH_WORD_SIZE*4 ? 1 : packets; // whole bunch Tx kick-off for small packets
        printf("DMA: Transferring %ld whole packets with length %d bytes between memories with common size %ld bytes (packet allocation %d bytes) \n",
                    packets, ETH_PACKET_LEN, txrxMemSize, ETH_MEMPACK_SIZE);
        dmaTxMemPtr = size_t(ethSyst.txMem);
        dmaRxMemPtr = size_t(ethSyst.rxMem);
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

        ethSyst.ethCoreInit(false);

        printf("------- CPU 2-boards communication test -------\n");
        ethSyst.switch_CPU_DMAxEth_LB(true,  true); // Tx switch: CPU->Eth, DMA->LB
        ethSyst.switch_CPU_DMAxEth_LB(false, true); // Rx switch: Eth->CPU, LB->DMA
        sleep(1); // in seconds

        // transmitToChan(CPU_PACKET_WORDS, TRANSMIT_FIFO_DEPTH, false, true);
        ethSyst.ethTxRxEnable(); // Enabling Ethernet TX/RX

        sleep(1); // in seconds, delay not to use blocking read in receive process
        // receiveFrChan (CPU_PACKET_WORDS, TRANSMIT_FIFO_DEPTH);
        ethSyst.ethTxRxDisable(); //Disabling Ethernet TX/RX
        printf("------- CPU 2-boards communication test PASSED -------\n\n");

        ethSyst.axiDmaInit();

        printf("------- Async DMA 2-boards communication test -------\n");
        ethSyst.switch_CPU_DMAxEth_LB(true,  false); // Tx switch: DMA->Eth, CPU->LB
        ethSyst.switch_CPU_DMAxEth_LB(false, false); // Rx switch: Eth->DMA, LB->CPU
        sleep(1); // in seconds

        srand(1);
        for (size_t addr = 0; addr < txMemWords; ++addr) ethSyst.txMem[addr] = rand();
        for (size_t addr = 0; addr < rxMemWords; ++addr) ethSyst.rxMem[addr] = 0;

        ethSyst.ethTxRxEnable(); // Enabling Ethernet TX/RX

        size_t packets = txrxMemSize/ETH_MEMPACK_SIZE;
        if (XAxiDma_HasSg(&ethSyst.axiDma))
          packets = std::min(packets,
                    std::min(ethSyst.txBdCount,
                             ethSyst.rxBdCount));
        size_t txBunch = ETH_PACKET_LEN > ETH_WORD_SIZE*4 ? 1 : packets; // whole bunch Tx kick-off for small packets
        printf("DMA: Transferring %ld whole packets with length %d bytes between memories with common size %ld bytes (packet allocation %d bytes) \n",
                    packets, ETH_PACKET_LEN, txrxMemSize, ETH_MEMPACK_SIZE);
        size_t dmaTxMemPtr = size_t(ethSyst.txMem);
        size_t dmaRxMemPtr = size_t(ethSyst.rxMem);
        if (XAxiDma_HasSg(&ethSyst.axiDma)) {
          XAxiDma_Bd* rxBdPtr = ethSyst.dmaBDAlloc(true,  packets, ETH_PACKET_LEN, ETH_MEMPACK_SIZE, dmaRxMemPtr); // Rx
          XAxiDma_Bd* txBdPtr = ethSyst.dmaBDAlloc(false, packets, ETH_PACKET_LEN, ETH_MEMPACK_SIZE, dmaTxMemPtr); // Tx
          ethSyst.dmaBDTransfer                   (true,  packets, packets,        rxBdPtr); // Rx
          sleep(1); // in seconds, timeout before Tx transfer to make sure opposite side also has set Rx transfer
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
          else if (ethSyst.rxMem[addr] != 0) {
              printf("\nERROR: Data in 32-bit word %ld of packet %ld overwrite stored zero at addr %ld: %0X \n",
                          word, packet, addr, ethSyst.rxMem[addr]);
              exit(1);
          }
        }

        ethSyst.ethTxRxDisable(); //Disabling Ethernet TX/RX
        printf("------- Async DMA 2-boards communication test PASSED -------\n\n");


        printf("------- Round-trip DMA 2-boards communication test -------\n");
        ethSyst.switch_CPU_DMAxEth_LB(true,  false); // Tx switch: DMA->Eth, CPU->LB
        ethSyst.switch_CPU_DMAxEth_LB(false, false); // Rx switch: Eth->DMA, LB->CPU
        sleep(1); // in seconds

        srand(1);
        for (size_t addr = 0; addr < txMemWords; ++addr) ethSyst.txMem[addr] = rand();
        for (size_t addr = 0; addr < rxMemWords; ++addr) ethSyst.rxMem[addr] = 0;

        ethSyst.ethTxRxEnable(); // Enabling Ethernet TX/RX

        packets = txrxMemSize/ETH_MEMPACK_SIZE;
        if (XAxiDma_HasSg(&ethSyst.axiDma))
          packets = std::min(packets,
                    std::min(ethSyst.txBdCount,
                             ethSyst.rxBdCount));
        txBunch = ETH_PACKET_LEN > ETH_WORD_SIZE*4 ? 1 : packets; // whole bunch Tx kick-off for small packets
        printf("DMA: Transferring %ld whole packets with length %d bytes between memories with common size %ld bytes (packet allocation %d bytes) \n",
                    packets, ETH_PACKET_LEN, txrxMemSize, ETH_MEMPACK_SIZE);
        dmaTxMemPtr = size_t(ethSyst.txMem);
        dmaRxMemPtr = size_t(ethSyst.rxMem);
        if (XAxiDma_HasSg(&ethSyst.axiDma)) {
          XAxiDma_Bd* rxBdPtr = ethSyst.dmaBDAlloc(true,  packets, ETH_PACKET_LEN, ETH_MEMPACK_SIZE, dmaRxMemPtr); // Rx
          XAxiDma_Bd* txBdPtr = ethSyst.dmaBDAlloc(false, packets, ETH_PACKET_LEN, ETH_MEMPACK_SIZE, dmaTxMemPtr); // Tx
          ethSyst.dmaBDTransfer                   (true,  packets, packets,        rxBdPtr); // Rx
          if (ethSyst.physConnOrder) { // depending on board instance play "initiator" role
            printf("Initiator side: starting the transfer and receiving it back \n");
            sleep(1); // in seconds, timeout before Tx transfer to make sure opposite side also has set Rx transfer
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

        ethSyst.ethCoreInit(false); // non-loopback mode
        printf("\n------- Physical connection is established -------\n");

        while (true) {
          ethSyst.ethSystInit(); // resetting hardware before any test
          printf("\n------- Please choose particular IP-based test:\n");
          printf("  Ping reply test:      p\n");
          printf("  Ping request test:    q\n");
          printf("  LwIP UDP Perf Server: u\n");
          printf("  LwIP UDP Perf Client: d\n");
          printf("  LwIP TCP Perf Server: t\n");
          printf("  LwIP TCP Perf Client: c\n");
          printf("  Exit to main menu:    e\n");
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

      case 'f':
        printf("------- Exiting the app -------\n");
        return(0);

      default: printf("Please choose right option\n");
    }
  }
}

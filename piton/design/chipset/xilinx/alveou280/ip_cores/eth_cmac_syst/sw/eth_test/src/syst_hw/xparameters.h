#ifndef XPARAMETERS_H  // prevent circular inclusions
#define XPARAMETERS_H  // by using protection macros

// Some pre-definitions for Timer driver (needed as defines)
#define XPAR_XTMRCTR_NUM_INSTANCES  1
#define XPAR_TMRCTR_0_DEVICE_ID     0
#define XPAR_TMRCTR_0_CLOCK_FREQ_HZ 100000000U

enum {
  // Definitions extracted from common OpenPiton devices_ariane.xml
        ETH_SYST_BASEADDR = 0xfff0800000,
        ETH_SYST_ADRRANGE = 0x400000,
  // Some pre-definitions for DMA driver
   XPAR_XAXIDMA_NUM_INSTANCES      = 1,
   XPAR_AXIDMA_0_DEVICE_ID         = 0,
   XPAR_AXIDMA_0_NUM_MM2S_CHANNELS = 1,
   XPAR_AXIDMA_0_NUM_S2MM_CHANNELS = 1,
   XPAR_AXI_DMA_0_MICRO_DMA        = 0,
   XPAR_AXI_DMA_0_ADDR_WIDTH       = 32,
  // Definitions extracted from Ethernet subsystem BD tcl script
   ETH_CORE_MAX_PACK_SIZE = 9600 ,
   ETH_CORE_MIN_PACK_SIZE = 64 ,
   XPAR_AXIDMA_0_INCLUDE_MM2S_DRE = 1, XPAR_AXIDMA_0_INCLUDE_MM2S = XPAR_AXIDMA_0_INCLUDE_MM2S_DRE ,
   XPAR_AXIDMA_0_INCLUDE_S2MM_DRE = 1, XPAR_AXIDMA_0_INCLUDE_S2MM = XPAR_AXIDMA_0_INCLUDE_S2MM_DRE ,
   XPAR_AXIDMA_0_INCLUDE_SG = 1 ,
   XPAR_AXIDMA_0_M_AXI_MM2S_DATA_WIDTH = 512, XPAR_AXIDMA_0_M_AXI_S2MM_DATA_WIDTH = XPAR_AXIDMA_0_M_AXI_MM2S_DATA_WIDTH ,
   ETH_DMA_AXIS_WIDTH = 512 ,
   XPAR_AXI_DMA_0_MM2S_BURST_SIZE = 64 ,
   XPAR_AXI_DMA_0_S2MM_BURST_SIZE = 64 ,
   XPAR_AXIDMA_0_SG_INCLUDE_STSCNTRL_STRM = 0 ,
   XPAR_AXIDMA_0_SG_LENGTH_WIDTH = 22 ,
     XPAR_TMRCTR_0_BASEADDR = 0x00015000 , AXI_TIMER_0_ADRRANGE = 0x00001000 // [get_bd_addr_spaces s_axi] [get_bd_addr_segs axi_timer_0/S_AXI/Reg] -force
  ,  ETH100GB_BASEADDR = 0x00000000 , ETH100GB_ADRRANGE = 0x00010000 // [get_bd_addr_spaces s_axi] [get_bd_addr_segs eth100gb/s_axi/Reg] -force
  ,  XPAR_AXIDMA_0_BASEADDR = 0x00010000 , ETH_DMA_ADRRANGE = 0x00001000 // [get_bd_addr_spaces s_axi] [get_bd_addr_segs eth_dma/S_AXI_LITE/Reg] -force
  ,  GT_CTL_BASEADDR = 0x00013000 , GT_CTL_ADRRANGE = 0x00001000 // [get_bd_addr_spaces s_axi] [get_bd_addr_segs gt_ctl/S_AXI/Reg] -force
  ,  RX_AXIS_SWITCH_BASEADDR = 0x00012000 , RX_AXIS_SWITCH_ADRRANGE = 0x00001000 // [get_bd_addr_spaces s_axi] [get_bd_addr_segs rx_axis_switch/S_AXI_CTRL/Reg] -force
  ,  RX_MEM_CPU_BASEADDR = 0x00200000 , RX_MEM_CPU_ADRRANGE = 0x00080000 // [get_bd_addr_spaces s_axi] [get_bd_addr_segs rx_mem_cpu/S_AXI/Mem0] -force
  ,  SG_MEM_CPU_BASEADDR = 0x00300000 , SG_MEM_CPU_ADRRANGE = 0x00080000 // [get_bd_addr_spaces s_axi] [get_bd_addr_segs sg_mem_cpu/S_AXI/Mem0] -force
  ,  TX_AXIS_SWITCH_BASEADDR = 0x00011000 , TX_AXIS_SWITCH_ADRRANGE = 0x00001000 // [get_bd_addr_spaces s_axi] [get_bd_addr_segs tx_axis_switch/S_AXI_CTRL/Reg] -force
  ,  TX_MEM_CPU_BASEADDR = 0x00100000 , TX_MEM_CPU_ADRRANGE = 0x00080000 // [get_bd_addr_spaces s_axi] [get_bd_addr_segs tx_mem_cpu/S_AXI/Mem0] -force
  ,  TX_RX_CTL_STAT_BASEADDR = 0x00014000 , TX_RX_CTL_STAT_ADRRANGE = 0x00001000 // [get_bd_addr_spaces s_axi] [get_bd_addr_segs tx_rx_ctl_stat/S_AXI/Reg] -force
};
#endif // end of protection macro

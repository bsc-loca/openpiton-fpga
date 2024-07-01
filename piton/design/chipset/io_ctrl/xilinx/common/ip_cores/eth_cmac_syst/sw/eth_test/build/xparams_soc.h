// SOC (Standalone Lox) hw parameters
#ifndef XPARAMS_SOC_H  // prevent circular inclusions
#define XPARAMS_SOC_H  // by using protection macros
enum {
        DRAM_CACHE_BASEADDR = 0x80000000,
        DRAM_CACHE_ADRRANGE = 0x1DFFE0000,
        DRAM_UNCACHE_BASEADDR = 0x60000000,
        DRAM_UNCACHE_ADRRANGE = 0x20000000,
        ETH_SYST_BASEADDR = 0x40400000,
      DRAM_BASEADDR = 0x60000000 // DRAM base address in CPU address space
      // DRAM_BASEADDR = 0x5FFE0000
};
#endif // end of protection macro

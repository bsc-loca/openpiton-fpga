
# Script to generate C-header containing hardware definitions for SOC

set dv_xml [open ../../../../../../../../../xilinx/alveou280/devices_ariane.xml r]
set bd_hdr [open ./xparams_soc.h                                                w]

puts $bd_hdr "// SOC (OpenPiton) hw parameters"
puts $bd_hdr "#ifndef XPARAMS_SOC_H  // prevent circular inclusions"
puts $bd_hdr "#define XPARAMS_SOC_H  // by using protection macros"

puts $bd_hdr "enum {"
puts $bd_hdr "  // Definitions extracted from common OpenPiton devices.xml"

while {[gets $dv_xml line] >= 0} {
  # extracting whole Ethernet subsystem address definitions
  if      {[string first "<name>net</name>" $line] >= 0} {
    while {[string first "</port>"          $line] <  0} {
      gets $dv_xml line
      if        {[string first "<base>"     $line] >= 0} {
        set line [string map  {"<base>"  "ETH_SYST_BASEADDR = "}  $line]
        set line [string map  {"</base>" ","}                     $line]
      } else {
        continue
      }
      puts $bd_hdr $line
    }
  }
  # extracting cached SDRAM address definitions
  if      {[string first "<name>mem</name>" $line] >= 0} {
    while {[string first "</port>"          $line] <  0} {
      gets $dv_xml line
      if        {[string first "<base>"     $line] >= 0} {
        set line [string map  {"<base>"  "DRAM_CACHE_BASEADDR = "}  $line]
        set line [string map  {"</base>" ","}                 $line]
      } elseif  {[string first "<length>"   $line] >= 0} {
        set line [string map  {"<length>" "DRAM_CACHE_ADRRANGE = "} $line]
        set line [string map  {"</length>" ","}               $line]
      } else {
        continue
      }
      puts $bd_hdr $line
    }
  }
  # extracting uncached SDRAM address definitions
  if      {[string first "<name>dma_pool</name>" $line] >= 0} {
    while {[string first "</port>"               $line] <  0} {
      gets $dv_xml line
      if        {[string first "<base>"          $line] >= 0} {
        set line [string map  {"<base>"  "DRAM_UNCACHE_BASEADDR = "}  $line]
        set line [string map  {"</base>" ","}                         $line]
      } elseif  {[string first "<length>"        $line] >= 0} {
        set line [string map  {"<length>" "DRAM_UNCACHE_ADRRANGE = "} $line]
        set line [string map  {"</length>" ","}                       $line]
      } else {
        continue
      }
      puts $bd_hdr $line
    }
  }
}
puts $bd_hdr "      DRAM_BASEADDR = 0x0 // DRAM base address in CPU address space"

puts $bd_hdr "};"
puts $bd_hdr "#endif // end of protection macro"

close $bd_hdr
close $dv_xml

# Modified by Barcelona Supercomputing Center on March 3rd, 2024i
# Copyright (c) 2016 Princeton University
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Princeton University nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#----------------- System Clock -------------------
set_property -dict {PACKAGE_PIN AY38 IOSTANDARD LVDS} [get_ports chipset_clk_osc_n]
set_property -dict {PACKAGE_PIN AY37 IOSTANDARD LVDS} [get_ports chipset_clk_osc_p]
#create_clock -period 3.3333 -name CHIPSET_CLK_P [get_ports chipset_clk_osc_p]
set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets chipset/clk_mmcm/inst/clkin1_ibufds/O]
set chip_clk [get_clocks -of_objects [get_pins -hierarchical clk_mmcm/chipset_clk]]
#--------------------------------------------



#----------------- PCIe signals -------------------
set_property PACKAGE_PIN BD21              [get_ports pcie_perstn]
set_property IOSTANDARD  LVCMOS18          [get_ports pcie_perstn]
set_property PACKAGE_PIN AM10              [get_ports pcie_refclk_n]
set_property PACKAGE_PIN AM11              [get_ports pcie_refclk_p]
create_clock -period 10.000 -name PCIE_CLK [get_ports pcie_refclk_p]

# Timing constraints for clock domains crossings (CDC)
set qdma_clk [get_clocks -of_objects [get_pins -hierarchical qdma_0/axi_aclk]]
#set_false_path -from $qdma_clk -to $chip_clk
# controlling resync paths to be less than source clock period
# (-datapath_only to exclude clock paths)
set_max_delay -datapath_only -from $qdma_clk -to $chip_clk [expr [get_property -min period $qdma_clk] * 0.9]

# Specifying the placement of PCIe clock domain modules into single SLR to facilitate routing
# https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_1/ug912-vivado-properties.pdf#page=386
#Collecting all units from correspondingly PCIe domain,
set pcie_clk_units [get_cells -of_objects [get_nets -of_objects [get_pins -hierarchical qdma_0/axi_aclk]]]
#Setting specific SLR to which PCIe pins are wired since placer may miss it if just "group_name" is applied
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells [list "$pcie_clk_units" chip chipset jtag_shell]]
#--------------------------------------------

#----------------- JTAG CDC -------------------
# Timing constraints for clock domains crossings (CDC)
set jtag_clk [get_clocks -of_objects [get_pins -hierarchical jtag_shell/dbg_jtag_tck]]
# set_false_path -from $xxx_clk -to $yyy_clk
# controlling resync paths to be less than source clock period
# (-datapath_only to exclude clock paths)
# For JTAG clock we consider both edges
set_max_delay -datapath_only -from $chip_clk -to $jtag_clk [expr [get_property -min period $chip_clk] * 0.9    ]
set_max_delay -datapath_only -from $jtag_clk -to $chip_clk [expr [get_property -min period $jtag_clk] * 0.9 / 2]
#--------------------------------------------

#----------------- UART -------------------
set_property -dict {PACKAGE_PIN BB20 IOSTANDARD LVCMOS18} [get_ports uart_tx]
set_property -dict {PACKAGE_PIN BF18 IOSTANDARD LVCMOS18} [get_ports uart_rx]
#--------------------------------------------

#----------------- Bitstream Configuration -------------------
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property BITSTREAM.CONFIG.CONFIGFALLBACK Enable [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 85.0 [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN disable [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR Yes [current_design]
# --------------------------------------------------------------

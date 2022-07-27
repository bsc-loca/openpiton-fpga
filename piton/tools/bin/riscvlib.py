#!/bin/python
# Modified by Barcelona Supercomputing Center on March 3rd, 2022
# Copyright 2019 ETH Zurich and University of Bologna.
# Copyright and related rights are licensed under the Solderpad Hardware
# License, Version 0.51 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
# http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
# or agreed to in writing, software, hardware and materials distributed under
# this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
#
# Author: Michael Schaffner <schaffner@iis.ee.ethz.ch>, ETH Zurich
# Date: 04.02.2019
# Description: Device tree generation script for OpenPiton+Ariane.
# Modification:
# Date: 01/09/2021
# Accept Lagarto as CPU


import pyhplib
import os
import subprocess
from pyhplib import *

# this prints some system information, to be printed by the bootrom at power-on
# dts path needs to be chosen in the caller process
def get_bootrom_info(devices, nCpus, cpuFreq, timeBaseFreq, periphFreq, dtsPath, timeStamp, core):

    gitver_cmd = "git log | grep commit -m1 | LD_LIBRARY_PATH= awk -e '{print $2;}'"
    piton_ver  = subprocess.check_output([gitver_cmd], shell=True)
    core_ver = subprocess.check_output(["cd %s && %s" % (dtsPath, gitver_cmd)], shell=True)

    # get length of memory
    memLen  = 0
    for i in range(len(devices)):
        if devices[i]["name"] == "mem":
            memLen  = devices[i]["length"]

    if 'PROTOSYN_RUNTIME_BOARD' in os.environ:
        boardName = os.environ['PROTOSYN_RUNTIME_BOARD']
        if not boardName:
            boardName = 'None (Simulation)'
    else:
        boardName = 'None (Simulation)'

    if 'CONFIG_SYS_FREQ' in os.environ:
        sysFreq = os.environ['CONFIG_SYS_FREQ']
        sysFreq = "%d MHz" % int(float(int(sysFreq))/1e6)
    else:
        sysFreq = "Unknown"

    tmpStr = '''// Info string generated with get_bootrom_info(...)
// OpenPiton + %s framework
// Date: %s

const char info[] = {
"\\r\\n\\r\\n"
"----------------------------------------\\r\\n"
"--     OpenPiton+%s Platform          --\\r\\n"
"----------------------------------------\\r\\n"
"OpenPiton Version: %s                   \\r\\n"
"%s Version:    %s                       \\r\\n"
"                                        \\r\\n"
"FPGA Board:        %s                   \\r\\n"
"Build Date:        %s                   \\r\\n"
"                                        \\r\\n"
"#X-Tiles:          %d                   \\r\\n"
"#Y-Tiles:          %d                   \\r\\n"
"#Cores:            %d                   \\r\\n"
"Core Freq:         %s                   \\r\\n"
"Network:           %s                   \\r\\n"
"DRAM Size:         %d MB                \\r\\n"
"                                        \\r\\n"
"L1I Size / Assoc:  %3d kB / %d          \\r\\n"
"L1D Size / Assoc:  %3d kB / %d          \\r\\n"
"L15 Size / Assoc:  %3d kB / %d          \\r\\n"
"L2  Size / Assoc:  %3d kB / %d          \\r\\n"
"----------------------------------------\\r\\n\\r\\n\\r\\n"
};

''' % (core,
       timeStamp,
       core,
       piton_ver[0:8],
       core,
       core_ver[0:8],
       boardName,
       timeStamp,
       int(os.environ['PITON_X_TILES']),
       int(os.environ['PITON_Y_TILES']),
       int(os.environ['PITON_NUM_TILES']),
       sysFreq,
       os.environ['PITON_NETWORK_CONFIG'],
       int(memLen/1024/1024),
       int(os.environ['CONFIG_L1I_SIZE'])/1024,
       int(os.environ['CONFIG_L1I_ASSOCIATIVITY']),
       int(os.environ['CONFIG_L1D_SIZE'])/1024,
       int(os.environ['CONFIG_L1D_ASSOCIATIVITY']),
       int(os.environ['CONFIG_L15_SIZE'])/1024,
       int(os.environ['CONFIG_L15_ASSOCIATIVITY']),
       int(os.environ['CONFIG_L2_SIZE'] )/1024,
       int(os.environ['CONFIG_L2_ASSOCIATIVITY'] ))

    with open(dtsPath + '/info.h','w') as file:
        file.write(tmpStr)


# format reg leaf entry
def _reg_fmt(addrBase, addrLen, addrCells, sizeCells):

    assert addrCells >= 1 or addrCells <= 2
    assert sizeCells >= 0 or sizeCells <= 2

    tmpStr = " "

    if addrCells >= 2:
        tmpStr += "0x%08x " % (addrBase >> 32)

    if addrCells >= 1:
        tmpStr += "0x%08x " % (addrBase & 0xFFFFFFFF)

    if sizeCells >= 2:
        tmpStr += "0x%08x " % (addrLen >> 32)

    if sizeCells >= 1:
        tmpStr += "0x%08x " % (addrLen & 0xFFFFFFFF)

    return tmpStr

def gen_riscv_dts(devices, nCpus, cpuFreq, timeBaseFreq, periphFreq, dtsPath, timeStamp, core):

    assert nCpus >= 1

    # get UART base
    uartBase = 0xDEADBEEF
    for i in range(len(devices)):
        if devices[i]["name"] == "uart":
            uartBase = devices[i]["base"]


    tmpStr = '''// DTS generated with gen_riscv_dts(...)
// OpenPiton + %s framework
// Date: %s

/dts-v1/;

/ {
    #address-cells = <2>;
    #size-cells = <2>;
    compatible = "eth,%s-bare-dev";
    model = "eth,%s-bare";
    // TODO: interrupt-based UART is currently very slow
    // with this configuration. this needs to be fixed.
    // chosen {
    //     stdout-path = "/soc/uart@%08x:115200";
    // };
    cpus {
        #address-cells = <1>;
        #size-cells = <0>;
        timebase-frequency = <%d>;
    ''' % (core, timeStamp, core, core, uartBase, timeBaseFreq)

    if core == "Lagarto":
        riscv_isa = "rv64ima"
        dts_core = "lagarto"
    elif core == "Ariane":
        riscv_isa = "rv64imafdc"
        dts_core = "ariane"

    for k in range(nCpus):
        tmpStr += '''
        CPU%d: cpu@%d {
            clock-frequency = <%d>;
            device_type = "cpu";
            reg = <%d>;
            status = "okay";
            compatible = "eth, %s", "riscv";
            riscv,isa = "%s";
            mmu-type = "riscv,sv39";
            tlb-split;
            // HLIC - hart local interrupt controller
            CPU%d_intc: interrupt-controller {
                #interrupt-cells = <1>;
                interrupt-controller;
                compatible = "riscv,cpu-intc";
            };
        };
        ''' % (k,k,cpuFreq,k,core,riscv_isa,k)

    tmpStr += '''
    };
    '''

    # this parses the device structure read from the OpenPiton devices*.xml file
    # only get main memory ranges here
    for i in range(len(devices)):
        if devices[i]["name"] == "mem":
            addrBase = devices[i]["base"]
            addrLen  = devices[i]["length"]
            tmpStr += '''
    memory@%08x {
        device_type = "memory";
        reg = <%s>;
    };
            ''' % (addrBase, _reg_fmt(addrBase, addrLen, 2, 2))

    tmpStr += '''
    soc {
        #address-cells = <2>;
        #size-cells = <2>;
        compatible = "eth,%s-bare-soc", "simple-bus";
        ranges;
    ''' % (core)

    # TODO: this needs to be extended
    # get the number of interrupt sources
    numIrqs = 0
    devWithIrq = ["uart", "net"];
    for i in range(len(devices)):
        if devices[i]["name"] in devWithIrq:
            numIrqs += 1


    # get the remaining periphs
    ioDeviceNr=1
    for i in range(len(devices)):
        # CLINT
        if devices[i]["name"] == "ariane_clint" or devices[i]["name"] == "lagarto_clint" :
            addrBase = devices[i]["base"]
            addrLen  = devices[i]["length"]
            tmpStr += '''
        clint@%08x {
            compatible = "riscv,clint0";
            interrupts-extended = <''' % (addrBase)
            for k in range(nCpus):
                tmpStr += "&CPU%d_intc 3 &CPU%d_intc 7 " % (k,k)
            tmpStr += '''>;
            reg = <%s>;
            reg-names = "control";
        };
            ''' % (_reg_fmt(addrBase, addrLen, 2, 2))
        # PLIC
        if devices[i]["name"] == "ariane_plic" or devices[i]["name"] == "lagarto_plic":
            addrBase = devices[i]["base"]
            addrLen  = devices[i]["length"]
            tmpStr += '''
        PLIC0: plic@%08x {
            #address-cells = <0>;
            #interrupt-cells = <1>;
            compatible = "riscv,plic0";
            interrupt-controller;
            interrupts-extended = <''' % (addrBase)
            for k in range(nCpus):
                tmpStr += "&CPU%d_intc 11 &CPU%d_intc 9 " % (k,k)
            tmpStr += '''>;
            reg = <%s>;
            riscv,max-priority = <7>;
            riscv,ndev = <%d>;
        };
            ''' % (_reg_fmt(addrBase, addrLen, 2, 2), numIrqs)
        # DTM
        if devices[i]["name"] == "ariane_debug" or devices[i]["name"] == "lagarto_debug":
            addrBase = devices[i]["base"]
            addrLen  = devices[i]["length"]
            tmpStr += '''
        debug-controller@%08x {
            compatible = "riscv,debug-013";
            interrupts-extended = <''' % (addrBase)
            for k in range(nCpus):
                tmpStr += "&CPU%d_intc 65535 " % (k)
            tmpStr += '''>;
            reg = <%s>;
            reg-names = "control";
        };
            ''' % (_reg_fmt(addrBase, addrLen, 2, 2))
        # UART
        if devices[i]["name"] == "uart":
            addrBase = devices[i]["base"]
            addrLen  = devices[i]["length"]
            tmpStr += '''
        uart@%08x {
            compatible = "ns16550";
            reg = <%s>;
            clock-frequency = <%d>;
            current-speed = <115200>;
            interrupt-parent = <&PLIC0>;
            interrupts = <%d>;
            reg-shift = <0>; // regs are spaced on 8 bit boundary (modified from Xilinx UART16550 to be ns16550 compatible)
        };
            ''' % (addrBase, _reg_fmt(addrBase, addrLen, 2, 2), periphFreq, ioDeviceNr)
            ioDeviceNr+=1

        # Ethernet
        if devices[i]["name"] == "net":
            addrBase = devices[i]["base"]
            addrLen  = devices[i]["length"]
            tmpStr += '''
            eth: eth0@%08x {
            compatible = "xlnx,xps-ethernetlite-1.00.a";
            device_type = "network";
            reg = <%s>;
            phy-mode = "10gbase-r";
            local-mac-address = [00 0a 35 00 00 00];
            interrupt-parent = <&PLIC0>;
            interrupts = <%d>;
            xlnx,duplex = <0x1>;
            xlnx,include-global-buffers = <0x0>;
            xlnx,include-internal-loopback = <0x1>;
            xlnx,include-mdio = <0x0>;
            xlnx,rx-ping-pong = <0x1>;
            xlnx,s-axi-id-width = <0x1>;
            xlnx,select-xpm = <0x1>;
            xlnx,tx-ping-pong = <0x1>;
            xlnx,use-internal = <0x0>;
            };
            ''' % (addrBase, _reg_fmt(addrBase, addrLen, 2, 2), ioDeviceNr)
            ioDeviceNr+=1

        # eth: lowrisc-eth@%08x {
        #     compatible = "lowrisc-eth";
        #     device_type = "network";
        #     interrupt-parent = <&PLIC0>;
        #     interrupts = <3 0>;
        #     local-mac-address = [ee e1 e2 e3 e4 e5];
        #     reg = <%s>;
        # };

    tmpStr += '''
    };
};
    '''

    # this needs to match
    assert ioDeviceNr-1 == numIrqs

    with open(dtsPath + '/' + dts_core + '.dts','w') as file:
        file.write(tmpStr)



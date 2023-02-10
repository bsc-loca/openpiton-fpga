# MEEP SHELL

## Definition

The **meep_shell** folder can be anywhere in the EA directory structure. The Shell searches for this folder and creates a symbolink link to it in the accelerator root folder.

| File Name      | Description           | 
| -------------  |:---------------------:|
| **accelerator_def.csv**    | Defines how the EA is presented to the MEEP FPGA Shell. Ethernet,       Aurora, HBM Channels or Clocks are defined here.  |
| **accelerator_mod.sv**      | A verilog (or system verilog) top module definition, or wrapper. It can be the EA top module. The interfaces need to match with the names used on the accelerator_def.csv file     |
| **accelerator_init.sh** | A script used for the EA to initialitize itself. (e.g, clone submodules)      |
| **accelerator_build.sh** | A script used for the EA to build potential RTL files (e.g, OpenPiton manycore generation, DVINO chisel)     |
| **accelerator_bin.sh** | A script used for the EA to build potential binaries (e.g, bootrom, linux)     |

## **accelerator_build.sh**
In OpenPiton there are different configuration that we can use in order to implement a specfic project. Using this 
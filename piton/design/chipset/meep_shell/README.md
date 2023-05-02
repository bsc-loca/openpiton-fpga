# MEEP SHELL

## Definition

The **meep_shell** folder can be anywhere in the EA directory structure. The Shell searches for this folder and creates a symbolink link to it in the accelerator root folder.

| File Name                |                                                                                  Description                                                                                   |
| ------------------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| **accelerator_def.csv**  |                               Defines how the EA is presented to the MEEP FPGA Shell. Ethernet, Aurora, HBM Channels or Clocks are defined here.                               |
| **accelerator_mod.sv**   | A verilog (or system verilog) top module definition, or wrapper. It can be the EA top module. The interfaces need to match with the names used on the accelerator_def.csv file |
| **accelerator_init.sh**  |                                                    A script used for the EA to initialitize itself. (e.g, clone submodules)                                                    |
| **accelerator_build.sh** |                                    A script used for the EA to build potential RTL files (e.g, OpenPiton manycore generation, DVINO chisel)                                    |
| **accelerator_bin.sh**   |                                                   A script used for the EA to build potential binaries (e.g, bootrom, linux)                                                   |

## **accelerator_build.sh**

With OpenPiton framework we can build differents "ACME_EA" flavours. There are several combinations, at the moment we have three different builds. (WiP)
Here, we want to explain how to use this script:

### Help menu

1.**Help** :hospital: : Here you will find the ACME_EA combinations, and flags we have available.

    ./accelerator_build.sh -h

2.**Syntax** :writing_hand: : If you want to know the syntax. There you can fin very detail information to identify the values used.

    ./accelerator_build.sh -s

### Build ACME_EA :package:

At this moment, we can know wich acme_ea flavour we can use, and how to use.

    ./accelerator_build.sh <EA_name> <protosyn_flags>

For example

    ./accelerator_build.sh acme_ea_4a pronoc

:flags: In case, you dont want to add any flag. There are some mandatory flags that are by default.

    --meep --eth --ncmem --hbm

Note: if you enter an incorrect name, it will generate an error and the script will exit. It will happend if you add a wrong flag.

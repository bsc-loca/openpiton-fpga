
#To build basic Ariane design:
#  $ cd $PITON_ROOT/
#  $ source piton/ariane_setup.sh # Piton tools setup (https://github.com/PrincetonUniversity/openpiton#environment-setup-1)
#  $ protosyn --board alveou55c --design system --core ariane --x_tiles 1 --y_tiles 1 --uart-dmw ddr --zeroer_off
#             --eth                     # adding Ethernet unit
#             --ethport <num>           # define board-level Ethernet port (default=0)
#             --hbm                     # define HBM as primary system memory
#             --multimc                 # implement design with multiple connections to system memory (HBM)
#             --pronoc                  # specifies that the ProNoC NoC shall be used instead of PitonNoC
#             --bram-test hello_world.c # adding VCS-based simulation
#             --verdi-dbg  # creating Verdi compliant simulation database for above test (verdi run inside ./build dir (-sx is optional): verdi -ssf ./novas.fsdb)
#             --mgui                    # run ManyGUI traffic visualizer while simulating above test


script=${BASH_SOURCE[0]}
if [ $script == $0 ]; then
    echo "ERROR: You must source this script"
    exit 2
fi

#Load PCIe bitstream to FPGA and setup host PCIe environment
hw_server -d
BITSREAM=../../../../../build/alveou55c/system/alveou55c_system/alveou55c_system.runs/impl_1/system.bit
if [ ! -f "$BITSREAM" ]; then
  echo "Native OP bitstream $BITSREAM doesn't exist, trying OP under MEEP_SHELL implementation:"
  BITSREAM=../../../../../../bitstream/system.bit
fi
source /home/tools/fpga-tools/fpga/load-bitstream.sh qdma $BITSREAM

#Some sanity checks
lspci -vd 10ee:
ls /dev/qdma* -al
dmesg | grep tty

pcienum=`lspci -m -d 10ee:| cut -d' ' -f 1 | cut -d ':' -f 1`
# dma-ctl qdma${pcienum}000 reg dump

#Applying both resets to the design
dma-ctl qdma${pcienum}000 reg write bar 2 0x0 0x0

#To setup UART on Nanu after reboot: sudo modprobe ftdi_sio

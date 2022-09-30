
#To build basic Ariane design:
#  $ cd $PITON_ROOT/
#  $ source piton/ariane_setup.sh # Piton tools setup (https://github.com/PrincetonUniversity/openpiton#environment-setup-1)
#  $ protosyn --board alveou280 --design system --core ariane --x_tiles 1 --y_tiles 1 --uart-dmw ddr --zeroer_off
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
source /home/tools/scripts/load-bitstream-beta.sh qdma ../../../../../build/alveou280/system/alveou280_system/alveou280_system.runs/impl_1/system.bit
# source /home/tools/scripts/load-bitstream-beta.sh qdma ../../../../../../fpga_shell/bitstream/system.bit

#Some sanity checks
# dma-ctl qdma08000 reg dump
# dma-ctl qdma08001 reg dump
# dma-ctl qdma08002 reg dump
# dma-ctl qdma08003 reg dump
lspci -vd 10ee:
ls /dev/qdma* -al
dmesg | grep tty

#Applying both resets to the design
dma-ctl qdma08000 reg write bar 2 0x0 0x0

#To setup UART on Nanu after reboot: sudo modprobe ftdi_sio

ROOT_DIR  = $(PWD)
VIVADO_VER  := 2021.2
VIVADO_PATH := /opt/Xilinx/Vivado/$(VIVADO_VER)/bin/
VIVADO_XLNX := $(VIVADO_PATH)/vivado
VIVADO_OPT  := -mode batch -nolog -nojournal -notrace -source
FPGA_BOARD  ?= u55c

#Options: generateIP

OPTIONS = endianess_swapper

all: endianess_swapper

default: endianess_swapper

ip: default

#Generate the target IP

$(OPTIONS): 
	@(echo "Generate IP for the Alveo $(FPGA_BOARD) as $@")
	$(VIVADO_XLNX) $(VIVADO_OPT)  ./tcl/gen_project.tcl -tclargs $(FPGA_BOARD) $@
	@(echo "IP created under folder $@")


clean:
	git clean -f
	@(cd ip; find . -type f ! -name "*.tcl" -exec rm -r {} \;)
	rm -rf xgui project endianess* 




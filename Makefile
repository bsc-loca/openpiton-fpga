
FPGA_TARGET ?= alveou280
ROOT_DIR    =  $(PWD)
PROJECT_SUBDIR =  $(ROOT_DIR)/build/$(FPGA_TARGET)/system/
PROJECT_DIR = $(PROJECT_SUBDIR)/$(FPGA_TARGET)_system/$(FPGA_TARGET)_system.xpr
DATE        =  `date +'%a %b %e %H:%M:$S %Z %Y'`
SYNTH_DCP   =  $(ROOT_DIR)/dcp/synthesis.dcp 
IMPL_DCP    =  $(ROOT_DIR)/dcp/implementation.dcp 
BIT_FILE    =  $(ROOT_DIR)/bitstream/system.bit
TCL_DIR     =  $(ROOT_DIR)/piton/tools/src/proto/common
VIVADO_VER  := "2021.2"
VIVADO_PATH := /opt/Xilinx/Vivado/$(VIVADO_VER)/bin/
VIVADO_XLNX := $(VIVADO_PATH)/vivado
VIVADO_OPT  := -mode batch -nolog -nojournal -notrace -source
CORE        ?= lagarto
# This needs to match the path set in <core>_setup.sh
RISCV_DIR   := $(ROOT_DIR)/riscv
SHELL := /bin/bash
XTILES ?= 1
YTILES ?= 1
PROTO_OPTIONS ?= --vpu --vnpm --eth --hbm

#Don't rely on this to call the subprograms
export PATH := $(VIVADO_PATH):$(PATH)

.PHONY: clean clean_synthesis clean_implementation

all: initialize synthesis implementation bitstream


test:
	@echo "Your core is $(CORE)"
	@echo "FPGA TARGET: $(FPGA_TARGET)"

initialize: $(RISCV_DIR)

synthesis: $(SYNTH_DCP)

implementation: $(IMPL_DCP)

bitstream: $(BIT_FILE)

incremental:
	@echo "Source a tcl so Vivado takes the latest dcp file to configure incremental implementaiton"


$(RISCV_DIR):
	source piton/$(CORE)_setup.sh; \
	piton/$(CORE)_build_tools.sh	

protosyn: clean_project $(RISCV_DIR)
	source piton/$(CORE)_setup.sh; \
	protosyn --board $(FPGA_TARGET) --design system --core $(CORE) --x_tiles $(XTILES) --y_tiles $(YTILES) --zeroer_off $(PROTO_OPTIONS)

$(SYNTH_DCP):
	$(VIVADO_XLNX $(VIVADO_OPT) $(TCL_DIR)/gen_synthesis.tcl -tclargs $(PROJECT_DIR)

$(IMPL_DCP): $(SYNTH_DCP)
	$(VIVADO_XLNX) $(VIVADO_OPT) $(TCL_DIR)/gen_implementation.tcl -tclargs $(ROOT_DIR)
	
$(BIT_FILE): $(IMPL_DCP)
	$(VIVADO_XLNX) $(VIVADO_OPT) $(TCL_DIR)/gen_bitstream.tcl -tclargs $(ROOT_DIR)

### Create targets to be used only in the CI/CD environment. They do not have requirements 

ci_implementation:
	$(VIVADO_XLNX) $(VIVADO_OPT) $(TCL_DIR)/gen_implementation.tcl -tclargs $(ROOT_DIR)

ci_bitstream:
	$(VIVADO_XLNX) $(VIVADO_OPT) $(TCL_DIR)/gen_bitstream.tcl -tclargs $(ROOT_DIR)

### Cleaning calls ###
	
clean_all: clean_project
	rm -rf $(PROJECT_SUBDIR)
	
clean_synthesis:	
	rm -rf dcp/*

clean_implementation:
	rm -rf dcp/implementation.dcp bitstream reports

clean_project: clean_synthesis clean_implementation
	rm -rf $(PROJECT_DIR)


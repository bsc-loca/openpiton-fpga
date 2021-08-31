FPGA_TARGET = alveou280
PROJECT_DIR = build/$(FPGA_TARGET)/system/$(FPGA_TARGET)_system/$(FPGA_TARGET)_system.xpr
ROOT_DIR    =  $(PWD)
DATE        =  `date +'%a %b %e %H:%M:$S %Z %Y'`
SYNTH_DCP   =  $(ROOT_DIR)/dcp/synthesis.dcp 
IMPL_DCP    =  $(ROOT_DIR)/dcp/implementation.dcp 
BIT_FILE    =  $(ROOT_DIR)/bitstream/system.bit
TCL_DIR     =  $(ROOT_DIR)/piton/tools/src/proto/common
VIVADO_VER  := "2020.1"
VIVADO_PATH := /opt/Xilinx/Vivado/$(VIVADO_VER)/bin/
VIVADO_XLNX := $(VIVADO_PATH)/vivado
VIVADO_OPT  = -mode batch -nolog -nojournal -notrace -source

export PATH := $(VIVADO_PATH):$(PATH)

.PHONY: clean clean_synthesis clean_implementation

all: initialize synthesis implementation bitstream


synthesis: $(SYNTH_DCP)

implementation: $(IMPL_DCP)

bitstream: $(BIT_FILE)

initialize: clean
	protosyn --board $(FPGA_TARGET) --design system --core ariane --x_tiles 1 --y_tiles 1 --uart-dmw ddr --zeroer_off --vnpm

$(SYNTH_DCP): $(PROJECT_FILE)
	$(VIVADO_XLNX $(VIVADO_OPT) $(TCL_DIR)/gen_synthesis.tcl -tclargs $(PROJECT_DIR)

$(IMPL_DCP): $(SYNTH_DCP)
	$(VIVADO_XLNX) $(VIVADO_OPT) $(TCL_DIR)/gen_implementation.tcl -tclargs $(ROOT_DIR)
	
$(BIT_FILE): $(IMPL_DCP)
	$(VIVADO_XLNX) $(VIVADO_OPT) $(TCL_DIR)/gen_bitstream.tcl -tclargs $(ROOT_DIR)
	
clean: 
	rm -rf $(PROJECT_DIR) dcp bitstream reports
	
clean_synthesis:	
	rm -rf dcp/*

clean_implementation:
	rm -rf dcp/implementation.dcp bitstream reports



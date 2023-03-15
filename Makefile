
FPGA_TARGET ?= alveou280
ROOT_DIR    =  $(PWD)
PITON_BUILD_DIR = $(ROOT_DIR)/build
PROJECT_SUBDIR =  $(PITON_BUILD_DIR)/$(FPGA_TARGET)/system/
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
RISCV   ?= $(ROOT_DIR)/riscv
SHELL := /bin/bash
XTILES ?= 1
YTILES ?= 1
MULTIMC =
MULTIMC_INDICES = 


MC_OPTION = 

ifdef MULTIMC
	MC_OPTION = --multimc $(MULTIMC)
	ifdef MULTIMC_INDICES
	MC_OPTION = --multimc $(MULTIMC) --multimc_indices $(MULTIMC_INDICES)
	endif
endif


 
PROTO_OPTIONS ?= --vnpm --eth --hbm --pronoc
MORE_OPTIONS ?= ""

#Don't rely on this to call the subprograms
export PATH := $(VIVADO_PATH):$(PATH)

.PHONY: clean clean_synthesis clean_implementation

all: initialize synthesis implementation bitstream


test:
	@echo "Your core is $(CORE)"
	@echo "FPGA TARGET: $(FPGA_TARGET)"

initialize: $(RISCV)

synthesis: $(SYNTH_DCP)

implementation: $(IMPL_DCP)

bitstream: $(BIT_FILE)

incremental:
	@echo "Source a tcl so Vivado takes the latest dcp file to configure incremental implementaiton"


$(RISCV):
	git clone https://github.com/riscv/riscv-gnu-toolchain; \
	cd riscv-gnu-toolchain; \
	./configure --prefix=$@ && make -j8; \
	cd $(ROOT_DIR); \

# Protosyn rule is connected with the piton/design/chipset/meep_shell/accelerator_build.sh script. In order with the values we define there
#Theses variables $CORE, $XTILES, $YTILES, and $PROTO_OPTIONS have the specific values to create the infrasctructure. We removed the vpu because it is 
#already defined in the PROTO_OPTIONS variable
protosyn: clean_project $(RISCV)
	source piton/$(CORE)_setup.sh; \
	protosyn --board $(FPGA_TARGET) --design system --core $(CORE) --x_tiles $(XTILES) --y_tiles $(YTILES)  --zeroer_off $(PROTO_OPTIONS) $(MC_OPTION) $(MORE_OPTIONS)

$(SYNTH_DCP): $(PROJECT_FILE)
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


# Compile the riscv-test baremetal
test_riscv_fpga:
	${MAKE} -C /piton/design/chip/tile/vas_tile_core/modules/riscv-tests/benchmarks fpga


test_riscv_clean:
	${MAKE} -C /piton/design/chip/tile/vas_tile_core/modules/riscv-tests/benchmarks clean

test_riscv_bin:
	${MAKE} -C /piton/design/chip/tile/vas_tile_core/modules/riscv-tests/benchmarks clean

### Cleaning calls ###

clean: clean_project
	
clean_all: clean_project
	rm -rf $(PITON_BUILD_DIR)/alveo*
	
clean_synthesis:	
	rm -rf dcp/*

clean_implementation:
	rm -rf dcp/implementation.dcp bitstream reports

clean_project: clean_synthesis clean_implementation
	rm -rf $(PROJECT_DIR)


`ifdef MEEP_COSIM

package vpu_scoreboard_pkg;

  import EPI_pkg::*;

localparam VRF_DATA = EPI_pkg::ELEN;
localparam VRF_WBITS = EPI_pkg::VRF_WBITS;
localparam VRF_WPACK = VRF_DATA/VRF_WBITS;
localparam BANK_SIZE = 80;
localparam MIN_SEW = 8;
localparam N_BANKS = EPI_pkg::N_BANKS;
localparam N_LANES = EPI_pkg::N_LANES;
localparam MAX_64BIT_BLOCKS = EPI_pkg::MAX_64BIT_BLOCKS;
localparam MAX_VLEN = EPI_pkg::MAX_VLEN;

typedef struct {
  logic [VRF_WBITS-1:0] subbank[VRF_WPACK][0:BANK_SIZE-1];
} bank_vreg_t;

typedef struct {
  bank_vreg_t bank [N_BANKS-1:0];
} lane_vreg_t;

typedef struct {
  bit error;
  int elem_index;
  string error_msg;
} vec_mismatch_t;

typedef logic [MAX_VLEN/MAX_64BIT_BLOCKS-1:0] vreg_elements_t [$:MAX_VLEN/MIN_SEW-1];

endpackage

`endif


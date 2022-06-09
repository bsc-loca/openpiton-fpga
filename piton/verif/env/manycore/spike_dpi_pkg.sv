package spike_dpi_pkg;

    import EPI_pkg::*;

// Spike data
typedef logic [DATA_PATH_WIDTH-1:0] vec_operand_t [MAX_VLEN/MIN_SEW-1:0];

// This struct contains 4 vector registers:
//

typedef struct
{
    longint unsigned old_vd [MAX_64BIT_BLOCKS-1:0];
    longint unsigned vd     [MAX_64BIT_BLOCKS-1:0];
    longint unsigned vs1    [MAX_64BIT_BLOCKS-1:0];
    longint unsigned vs2    [MAX_64BIT_BLOCKS-1:0];
    longint unsigned vs3    [MAX_64BIT_BLOCKS-1:0];
    longint unsigned vmask  [MAX_64BIT_BLOCKS-1:0];
} vector_operands_t;

typedef struct
{
    vec_operand_t old_vd;
    vec_operand_t vd;
    vec_operand_t vs1;
    vec_operand_t vs2;
    vec_operand_t vs3;
    vec_operand_t vmask;
} formatted_vector_operands_t;

typedef struct {
    byte unsigned frm;
    byte unsigned fflags;
    byte unsigned trap_illegal;
} csrs_t;

typedef struct
{
    longint unsigned pc;
    int unsigned ins;
    longint unsigned destination_reg;
    longint unsigned rs1;
    longint unsigned rs2;
    longint unsigned fp_rs1;
    byte unsigned simm5;
    int unsigned vstart;
    int unsigned vl;
    int unsigned vxrm;
    int unsigned frm;
    int unsigned vlmul;
    int unsigned vsew;
    int unsigned vill;
    int unsigned vxsat;
    int unsigned vlen;
    int unsigned elen;
    vector_operands_t vector_operands;
    csrs_t csrs;
    formatted_vector_operands_t formatted_vector_operands;
} core_info_t;

typedef struct
{
  longint unsigned next_pc;
  longint unsigned dst;
  longint unsigned reg_wr_valid;
  longint unsigned data;
  longint unsigned xcpt;
  longint unsigned xcpt_cause;
  longint unsigned csr_priv_lvl;
  longint unsigned csr_xcpt;
  longint unsigned csr_xcpt_cause;
  longint unsigned csr_tval;
  int  rs1;
  int  rs2;
  int  rs3;
} core_commit_info_t;

// DPI function calls from spike/spike_main/spike-dpi.cc
  import "DPI-C" function void setup(input longint argc, input string argv, input int num_harts);
  import "DPI-C" function void stop_execution();
  import "DPI-C" function void start_execution();
  import "DPI-C" function void step(output core_info_t core_info, input int hart_id);
  import "DPI-C" function void get_spike_commit_info(output core_commit_info_t core_info, input int hart_id);
  import "DPI-C" function int  run_until_vector_ins(inout core_info_t core_info);
  import "DPI-C" function void feed_reduction_result(input longint vpu_result, input int vdest);
  import "DPI-C" function int  get_memory_data(output longint mem_element, input longint mem_addr);
  import "DPI-C" function longint unsigned spike_get_csr(input int csr);
  import "DPI-C" function void spike_set_external_interrupt(input longint mip_val);

endpackage

/* * ---------------------------------------------------------
* Project Name   : MEEP
* File           : lagarto_openpiton_wrapper.sv
* Organization   : Barcelona Supercomputing Center
* Author(s)      : Ivan Vera
* Email(s)       : ivan.vera@bsc.es
* References     :
* ------------------------------------------------------------
* Revision History
*  Revision   | Author     | Commit | Description
*  0.1        | Ivan Vera  | 
* ------------------------------------------------------------
*/

//import drac_pkg::*;
//import EPI_pkg::*;
//import drac_icache_pkg::*;
import ariane_pkg::*;
import drac_pkg::*;

module lagarto_verilog_wrap #(
  parameter int unsigned               RASDepth              = 2,
  parameter int unsigned               BTBEntries            = 32,
  parameter int unsigned               BHTEntries            = 128,
  // debug module base address
  parameter logic [63:0]               DmBaseAddress         = 64'h0,
  // swap endianess in l15 adapter
  parameter bit                        SwapEndianess         = 1,
  // PMA configuration

  // idempotent region
  parameter int unsigned               NrNonIdempotentRules  =  0,
  parameter logic [NrMaxRules*64-1:0]  NonIdempotentAddrBase = '0,
  parameter logic [NrMaxRules*64-1:0]  NonIdempotentLength   = '0,
  // executable regions
  parameter int unsigned               NrExecuteRegionRules  =  0,
  parameter logic [NrMaxRules*64-1:0]  ExecuteRegionAddrBase = '0,
  parameter logic [NrMaxRules*64-1:0]  ExecuteRegionLength   = '0,
  // cacheable regions
  parameter int unsigned               NrCachedRegionRules   =  0,
  parameter logic [NrMaxRules*64-1:0]  CachedRegionAddrBase  = '0,
  parameter logic [NrMaxRules*64-1:0]  CachedRegionLength    = '0
)(
//------------------------------------------------------------------------------------
// ORIGINAL INPUTS OF LAGARTO 
//------------------------------------------------------------------------------------
    input logic                 clk_i,
    input logic                 reset_l,      // this is an openpiton-specific name, do not change (hier. paths in TB use this)
    output logic                spc_grst_l,   // this is an openpiton-specific name, do not change (hier. paths in TB use this)
    input addr_t                RESET_ADDRESS,

    input  [63:0]               boot_addr_i,  // reset boot address
    input  [63:0]               hart_id_i,    // hart id in a multicore environment (reflected in a CSR)

    // L15 (memory side)
    output wt_cache_pkg::l15_req_t       l15_req_o,
    input  wt_cache_pkg::l15_rtrn_t      l15_rtrn_i,

    // PMU
    output logic[24:0]          pmu_sig_o
);

    localparam ariane_pkg::ariane_cfg_t ArianeOpenPitonCfg = '{
      RASDepth:              RASDepth,
      BTBEntries:            BTBEntries,
      BHTEntries:            BHTEntries,
      // idempotent region
      NrNonIdempotentRules:  NrNonIdempotentRules,
      NonIdempotentAddrBase: NonIdempotentAddrBase,
      NonIdempotentLength:   NonIdempotentLength,
      NrExecuteRegionRules:  NrExecuteRegionRules,
      ExecuteRegionAddrBase: ExecuteRegionAddrBase,
      ExecuteRegionLength:   ExecuteRegionLength,
      // cached region
      NrCachedRegionRules:   NrCachedRegionRules,
      CachedRegionAddrBase:  CachedRegionAddrBase,
      CachedRegionLength:    CachedRegionLength,
      // cache config
      Axi64BitCompliant:     1'b0,
      SwapEndianess:         SwapEndianess,
      // debug
      DmBaseAddress:         DmBaseAddress
    };


  logic [15:0] wake_up_cnt_d, wake_up_cnt_q;
  logic rst_n;

  assign wake_up_cnt_d = (wake_up_cnt_q[$high(wake_up_cnt_q)]) ? wake_up_cnt_q : wake_up_cnt_q + 1;

  always_ff @(posedge clk_i or negedge reset_l) begin : p_regs
    if(~reset_l) begin
      wake_up_cnt_q <= 0;
    end else begin
      wake_up_cnt_q <= wake_up_cnt_d;
    end
  end

  // reset gate this
  assign rst_n = wake_up_cnt_q[$high(wake_up_cnt_q)] & reset_l;

  /////////////////////////////
  // synchronizers
  /////////////////////////////

  // reset synchronization
  synchronizer i_sync (
    .clk         ( clk_i      ),
    .presyncdata ( rst_n      ),
    .syncdata    ( spc_grst_l )
  );

logic    CSR_EXCEPTION;
bus64_t  CSR_CAUSE;
ariane_pkg::exception_t ex_i;
logic   [11:0]       CSR_RW_ADDR;
bus64_t              CSR_RW_WDATA;
bus64_t              CSR_RW_RDATA;
csr_cmd_t            CSR_RW_CMD;
logic                CSR_RETIRE;
bus64_t              CSR_PC;
addr_t               CSR_EPC;
addr_t               CSR_TRAP_VECTOR_BASE;
logic                CSR_ERET; 
logic                CSR_STALL; 
logic                dcache_en_csr;
logic                en_translation;           
logic                en_ld_st_translation; 
logic                icache_en_csr;

csr_cmd_t csr_op;
//assign ex_i.cause  =  riscv_pkg::exception_cause_t'(CSR_CAUSE);
assign ex_i.cause  = CSR_CAUSE;
assign ex_i.tval   = CSR_PC;
assign ex_i.valid  = CSR_EXCEPTION;
riscv::priv_lvl_t   priv_lvl;
riscv::priv_lvl_t   ld_st_priv_lvl_csr_o;
logic sum;
logic mxr;
logic [43:0] satp_ppn;
logic asid;
ariane_pkg::exception_t csr_ex_o;
logic flush;
logic interrupt;
logic [63:0] interrupt_cause;
logic tvm;
logic tsr;

csr_regfile i_csr_regfile (
  .clk_i                 ( clk_i ),
  .rst_ni                ( spc_grst_l ),
  .time_irq_i            ( 0 ),
  .flush_o               ( flush    ),
  .halt_csr_o            ( CSR_STALL),
  //.commit_instr_i        ( ),
  .commit_ack_i          ( 0 ),
  .boot_addr_i           ( boot_addr_i ),
  .hart_id_i             ( hart_id_i ),
  .wfi_detect_op_i       ( wfi_detect_op_i),
  .ex_i                  ( ex_i ),
  .csr_op_i              ( CSR_RW_CMD ),
  .csr_addr_i            ( CSR_RW_ADDR ),
  .csr_wdata_i           ( CSR_RW_WDATA ),
  .csr_rdata_o           ( CSR_RW_RDATA),
  .dirty_fp_state_i      ( 1'b0 ),
  .csr_write_fflags_i    ( 0 ),
  .pc_i                  ( CSR_PC ),
  .csr_exception_o       ( csr_ex_o),
  .epc_o                 ( CSR_EPC),
  .eret_o                ( CSR_ERET),
  .trap_vector_base_o    ( CSR_TRAP_VECTOR_BASE),
  .priv_lvl_o            ( priv_lvl ),
  .fs_o                  ( ),
  .fflags_o              ( ),
  .frm_o                 ( ),
  .fprec_o               ( ),
  .irq_ctrl_o            ( ),
  .interrupt_o           ( interrupt ),
  .interrupt_cause_o     ( interrupt_cause ),


  .en_translation_o      ( en_translation),
  .en_ld_st_translation_o( en_ld_st_translation),
  .ld_st_priv_lvl_o      ( ld_st_priv_lvl_csr_o),
  .sum_o                 (sum ),
  .mxr_o                 (mxr ),
  .satp_ppn_o            (satp_ppn ),
  .asid_o                (asid ),
  .irq_i                 ( 0 ),
  .ipi_i                 ( 0 ),
  .debug_req_i           ( 0 ),
  .set_debug_pc_o        ( ),
  .tvm_o                 ( tvm ),
  .tw_o                  ( ),
  .tsr_o                 ( tsr),
  .debug_mode_o          ( ),
  .single_step_o         ( ),
  .icache_en_o           (icache_en_csr),
  .dcache_en_o           (dcache_en_csr),
  .perf_addr_o           ( ),
  .perf_data_o           ( ),
  .perf_data_i           ( 0 ),
  .perf_we_o             ( )
);


logic[24:0] pmu_sig;
// First signal is set to 1 to count clock cycles
assign pmu_sig[0] = 1'b1;
assign pmu_sig_o = pmu_sig;

lagarto_openpiton_top #(
  .ArianeCfg(ArianeOpenPitonCfg)
) lagarto_m20 (
    .clk_i               (clk_i                  ),
    .rstn_i              (spc_grst_l             ),
    .SOFT_RST            (1'h1                   ),
    .RESET_ADDRESS       (boot_addr_i            ),
    //DEBUG RING SIGNALS INPUT
    .debug_halt_i        (1'b0                   ),
    .IO_FETCH_PC_VALUE   (0                      ),
    .IO_FETCH_PC_UPDATE  (1'b0                   ),
    .IO_REG_READ         (1'b0                   ),
    .IO_REG_ADDR         (5'b0                   ),
    .IO_REG_WRITE        (1'b0                   ),
    .IO_REG_WRITE_DATA   (64'h0000_0000_0000_0000),
    .DMEM_ORDERED        (1'b0                   ),

    // CSR Input
    .CSR_RW_RDATA        (CSR_RW_RDATA           ),
    .CSR_CSR_STALL       (CSR_STALL              ),
    .CSR_XCPT            (csr_ex_o.valid         ),
    .CSR_XCPT_CAUSE      (csr_ex_o.cause         ),
    .CSR_TVAL            (csr_ex_o.tval          ),
    //.CSR_TVAL          (CSR_TRAP_VECTOR_BASE),
    //.CSR_XCPT          (1'b0            ),
    //.CSR_XCPT_CAUSE    (64'h0000_0000_0000_0000),
    //.CSR_TVAL          (64'h0000_0000_0000_0000),
    .CSR_ERET            (CSR_ERET               ),
    .CSR_EVEC            (CSR_EPC                ),
    .CSR_INTERRUPT       (interrupt              ),
    .CSR_INTERRUPT_CAUSE (interrupt_cause        ),
    .csr_flush_i         (flush                  ),
    .io_csr_csr_replay   (1'b0                   ),
    .csr_priv_lvl_i      (priv_lvl               ),
    .csr_ld_st_priv_lvl_i(ld_st_priv_lvl_csr_o   ),
    .csr_vpu_data_i      (0                      ),
    .tvm_i               (tvm                    ),
    .tsr_i               (tsr                    ),

    .csr_dcache_enable_i (dcache_en_csr          ), 
    .csr_icache_enable_i (icache_en_csr          ), 
    .en_translation_i    (en_translation         ),
    .en_ld_st_translation_i(en_ld_st_translation ),
    .sum_i                 (sum),
    .mxr_i                 (mxr),
    .satp_ppn_i            (satp_ppn),
    .asid_i                (asid),
    // CSR Output
    .CSR_RW_ADDR          (CSR_RW_ADDR),
    .CSR_RW_CMD           (CSR_RW_CMD),
    .CSR_RW_WDATA         (CSR_RW_WDATA),
    .CSR_EXCEPTION        (CSR_EXCEPTION),
    .CSR_RETIRE           (),
    .CSR_CAUSE            (CSR_CAUSE),
    .CSR_PC               (CSR_PC),
    .fflags_o             (),
    .vxsat_o              (),
    .valid_vec_csr_o      (),

    .l15_req_o           (l15_req_o              ),
    .l15_rtrn_i          (l15_rtrn_i             ),
    
    .dbg_re_i            (1'b0                   ),
    .dbg_we_i            (1'b0                   ),
    .dbg_address_i       ({DBG_ADDR_WIDTH{1'b0}} ),
    .dbg_write_data_i    ({DBG_ADDR_WIDTH{1'b0}} ),

    // PMU signals
    .io_core_pmu_new_instruction(pmu_sig[1]),
    .io_core_pmu_is_branch(pmu_sig[2]),
    .io_core_pmu_is_branch_hit(pmu_sig[3]),
    .io_core_pmu_is_branch_false_positive(pmu_sig[4]),
    .io_core_pmu_branch_taken(pmu_sig[5]),
    .io_core_pmu_branch_taken_hit(pmu_sig[6]),
    .io_core_pmu_branch_taken_b_not_detected(pmu_sig[7]),
    .io_core_pmu_branch_taken_addr_miss(pmu_sig[8]),
    .io_core_pmu_branch_not_taken_hit(pmu_sig[9]),
    .io_core_pmu_stall_if(pmu_sig[10]),
    .io_core_pmu_stall_id(pmu_sig[11]),
    .io_core_pmu_stall_rr(pmu_sig[12]),
    .io_core_pmu_stall_exe(pmu_sig[13]),
    .io_core_pmu_stall_wb(pmu_sig[14]),
    .io_core_pmu_EXE_STORE(pmu_sig[15]),
    .io_core_pmu_EXE_LOAD(pmu_sig[16]),
    .io_core_pmu_dcache_request(pmu_sig[17]),
    .io_core_pmu_dcache_miss(pmu_sig[18]),
    .io_core_pmu_dmiss_l2miss(pmu_sig[19]),
    .io_core_pmu_icache_request(pmu_sig[20]),
    .io_core_pmu_icache_miss(pmu_sig[21]),
    .io_core_pmu_imiss_l2miss(pmu_sig[22]),
    .io_core_pmu_dtlb_miss(pmu_sig[23]),
    .io_core_pmu_itlb_miss(pmu_sig[24])
);

endmodule

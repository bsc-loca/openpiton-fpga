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
    input  wt_cache_pkg::l15_rtrn_t      l15_rtrn_i
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
addr_t               CSR_PC;
addr_t               CSR_EPC;
addr_t               CSR_TVAL;
logic                CSR_ERET; 
logic                dcache_en_csr;
logic                en_translation;           
logic                en_ld_st_translation; 
logic                icache_en_csr;

csr_cmd_t csr_op;
//assign ex_i.cause  =  riscv_pkg::exception_cause_t'(CSR_CAUSE);
assign ex_i.cause  = CSR_CAUSE;
assign ex_i.tval   = CSR_PC;
assign ex_i.valid  = CSR_EXCEPTION;
riscv::priv_lvl_t   priv_lvl_csr_o;
logic sum;
logic mxr;
logic [43:0] satp_ppn;
logic asid;

csr_regfile i_csr_regfile (
  .clk_i                 ( clk_i ),
  .rst_ni                ( spc_grst_l ),
  .time_irq_i            ( 0 ),
  .flush_o               ( ),
  .halt_csr_o            ( ),
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
  .csr_exception_o       ( ),
  .epc_o                 ( CSR_EPC),
  .eret_o                ( CSR_ERET),
  .trap_vector_base_o    ( ),
  //.trap_vector_base_o    ( CSR_TVAL),
  .priv_lvl_o            ( priv_lvl_csr_o ),
  .fs_o                  ( ),
  .fflags_o              ( ),
  .frm_o                 ( ),
  .fprec_o               ( ),
  .irq_ctrl_o            ( ),
  .en_translation_o      ( en_translation),
  .en_ld_st_translation_o( en_ld_st_translation),
  .ld_st_priv_lvl_o      ( ),
  .sum_o                 (sum ),
  .mxr_o                 (mxr ),
  .satp_ppn_o            (satp_ppn ),
  .asid_o                (asid ),
  .irq_i                 ( 0 ),
  .ipi_i                 ( 0 ),
  .debug_req_i           ( 0 ),
  .set_debug_pc_o        ( ),
  .tvm_o                 ( ),
  .tw_o                  ( ),
  .tsr_o                 ( ),
  .debug_mode_o          ( ),
  .single_step_o         ( ),
  .icache_en_o           (icache_en_csr),
  .dcache_en_o           (dcache_en_csr),
  .perf_addr_o           ( ),
  .perf_data_o           ( ),
  .perf_data_i           ( 0 ),
  .perf_we_o             ( )
);


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
    .CSR_CSR_STALL       (1'b0                   ),
    .CSR_XCPT            (1'b0                   ),
    .CSR_XCPT_CAUSE      (64'h0000_0000_0000_0000),
    .CSR_TVAL            (64'h0000_0000_0000_0000),
    //.CSR_TVAL            (CSR_TVAL               ),
    .CSR_ERET            (CSR_ERET               ),
    //.CSR_EVEC            (CSR_EPC                ),
    .CSR_EVEC            (),
    .CSR_INTERRUPT       (1'b0                   ),
    .CSR_INTERRUPT_CAUSE (64'h0000_0000_0000_0000),
    .io_csr_csr_replay   (1'b0                   ),
    .csr_priv_lvl_i      (priv_lvl_csr_o         ),
    .csr_vpu_data_i      (0                      ),
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
    
    // debugging module signal
    .io_core_pmu_l2_hit_i(1'b0                   ),
    .io_dc_gvalid_i      (1'b0                   ),
    .io_dc_addrbit_i     (2'b0                   )
);

endmodule

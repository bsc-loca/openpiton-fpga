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

    lagarto_openpiton_top #(.ArianeCfg(ArianeOpenPitonCfg)) 
    lagarto_m20 (
        .clk_i               (clk_i                  ),
        .rstn_i              (spc_grst_l             ),
        .SOFT_RST            (1'h1                   ),
        .RESET_ADDRESS       (RESET_ADDRESS          ),
        //DEBUG RING SIGNALS INPUT
        .debug_halt_i        (1'b0                   ),
        .IO_FETCH_PC_VALUE   (0                      ),
        .IO_FETCH_PC_UPDATE  (1'b0                   ),
        .IO_REG_READ         (1'b0                   ),
        .IO_REG_ADDR         (5'b0                   ),
        .IO_REG_WRITE        (1'b0                   ),
        .IO_REG_WRITE_DATA   (64'h0000_0000_0000_0000),
        .DMEM_ORDERED        (1'b0                   ),
        // CSR
        .CSR_RW_RDATA        (64'h0000_0000_0000_0000),
        .CSR_CSR_STALL       (1'b0                   ),
        .CSR_XCPT            (1'b0                   ),
        .CSR_XCPT_CAUSE      (64'h0000_0000_0000_0000),
        .CSR_TVAL            (64'h0000_0000_0000_0000),
        .CSR_ERET            (1'b0                   ),
        .CSR_EVEC            (64'h0000_0000_0000_0000),
        .CSR_INTERRUPT       (1'b0                   ),
        .CSR_INTERRUPT_CAUSE (64'h0000_0000_0000_0000),
        .io_csr_csr_replay   (1'b0                   ),
        .csr_priv_lvl_i      (2'b00                  ),
        .csr_vpu_data_i      (0                      ),
        
        
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

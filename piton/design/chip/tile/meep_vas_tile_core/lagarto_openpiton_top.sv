/* * ---------------------------------------------------------
* Project Name   : DRAC
* File           : top_drac.sv
* Organization   : Barcelona Supercomputing Center
* Author(s)      : Guillem Cabo Pitarch
*                : Alberto Gonzalez Trejo
* Email(s)       : guillem.cabo@bsc.es
*                : alberto.gonzalez@bsc.es
*                : gerard.candon@bsc.es
* References     :
* ------------------------------------------------------------
* Revision History
*  Revision   | Author     | Commit | Description
*  0.1        | Guillem.CP | 
*  0.2        | Guillem.LP       | Add vpu inst
*  0.3        | Alberto Gonzalez | OVI vector mem ops support
*  0.4        | Gerard Candón    | OVI vector mem ops support for all SEW
*  0.5        | Julian Pavon     | Adding the debug ring connections
* ------------------------------------------------------------
*/

import drac_pkg::*;
import EPI_pkg::*;
import drac_icache_pkg::*;
import ariane_pkg::*;

module lagarto_openpiton_top #(
  parameter ariane_pkg::ariane_cfg_t ArianeCfg       = ariane_pkg::ArianeDefaultConfig  // contains cacheable regions
)(
//------------------------------------------------------------------------------------
// ORIGINAL INPUTS OF LAGARTO 
//------------------------------------------------------------------------------------
    input logic                 clk_i,
    input logic                 rstn_i,
    input logic                 SOFT_RST,
    input addr_t                RESET_ADDRESS,

//------------------------------------------------------------------------------------
// DEBUG RING SIGNALS INPUT
//------------------------------------------------------------------------------------    
    input                       debug_halt_i,

    input addr_t                IO_FETCH_PC_VALUE,
    input                       IO_FETCH_PC_UPDATE,
    
    input                       IO_REG_READ,
    input  [4:0]                IO_REG_ADDR,
    input                       IO_REG_WRITE,
    input bus64_t               IO_REG_WRITE_DATA,

    input                       DMEM_ORDERED,

//------------------------------------------------------------------------------------
// CSR INPUT INTERFACE
//------------------------------------------------------------------------------------
    input bus64_t               CSR_RW_RDATA,
    input logic                 CSR_CSR_STALL,
    input logic                 CSR_XCPT,
    input [63:0]                CSR_XCPT_CAUSE,
    input [63:0]                CSR_TVAL,
    input logic                 CSR_ERET,
    input addr_t                CSR_EVEC,
    input logic                 CSR_INTERRUPT,
    input bus64_t               CSR_INTERRUPT_CAUSE,
    input logic                 csr_flush_i,
    input logic                 io_csr_csr_replay,
    input [1:0]                 csr_priv_lvl_i,
    input ovi_csr_data_t        csr_vpu_data_i,
    input logic                 csr_dcache_enable_i,
    input logic                 csr_icache_enable_i,
    input logic                 en_translation_i,           // enable VA translation
    input logic                 en_ld_st_translation_i, 
`ifdef PITON_LAGARTO
    input logic                 sum_i,
    input logic                 mxr_i,
    input [43:0]                satp_ppn_i,
    input logic                 asid_i,
`endif
//-----------------------------------------------------------------------------------
// CSR OUTPUT INTERFACE
//-----------------------------------------------------------------------------------
    output logic   [11:0]       CSR_RW_ADDR,
    `ifdef PITON_LAGARTO
        output csr_cmd_t            CSR_RW_CMD,
    `else 
        output logic   [2:0]        CSR_RW_CMD,
    `endif 
    output bus64_t              CSR_RW_WDATA,
    output logic                CSR_EXCEPTION,
    output logic                CSR_RETIRE,
    output bus64_t              CSR_CAUSE,
`ifdef PITON_LAGARTO
    output bus64_t              CSR_PC,
`else 
    output addr_t               CSR_PC,
`endif

    output fflags_t             fflags_o,
    output logic                vxsat_o,
    output logic                valid_vec_csr_o,


`ifdef PITON_LAGARTO

  // L15 (memory side)
  output wt_cache_pkg::l15_req_t       l15_req_o,
  input  wt_cache_pkg::l15_rtrn_t      l15_rtrn_i,

`else 

//------------------------------------------------------------------------------------
// I-CANCHE INPUT INTERFACE
//------------------------------------------------------------------------------------
    
    input logic                 PTWINVALIDATE     ,
    input logic                 TLB_RESP_MISS     ,
    input logic                 TLB_RESP_XCPT_IF  ,
    input logic  [19:0]         itlb_resp_ppn_i   ,   
    input logic                 iptw_resp_valid_i ,
    //==============================================================
    
    //- From L2
    input  logic                io_mem_grant_valid                 ,
    input  logic [127:0]        io_mem_grant_bits_data             ,
    input  logic   [1:0]        io_mem_grant_bits_addr_beat        ,
    

//----------------------------------------------------------------------------------
// D-CACHE  INTERFACE
//----------------------------------------------------------------------------------
    input logic                 DMEM_REQ_READY,
    input bus64_t               DMEM_RESP_BITS_DATA_SUBW,
    input logic                 DMEM_RESP_BITS_NACK,
    input logic                 DMEM_RESP_BITS_REPLAY,
    input logic                 DMEM_RESP_VALID,
    input logic                 DMEM_XCPT_MA_ST,
    input logic                 DMEM_XCPT_MA_LD,
    input logic                 DMEM_XCPT_PF_ST,
    input logic                 DMEM_XCPT_PF_LD,

//-----------------------------------------------------------------------------------
// I-CACHE OUTPUT INTERFACE
//-----------------------------------------------------------------------------------
    
    output logic [27:0]         TLB_REQ_BITS_VPN,
    output logic                TLB_REQ_VALID,

    //- To L2
    output logic                io_mem_acquire_valid               ,
    output logic  [25:0]        io_mem_acquire_bits_addr_block     ,
    output logic                io_mem_acquire_bits_client_xact_id ,
    output logic   [1:0]        io_mem_acquire_bits_addr_beat      ,
    output logic [127:0]        io_mem_acquire_bits_data           ,
    output logic                io_mem_acquire_bits_is_builtin_type,
    output logic   [2:0]        io_mem_acquire_bits_a_type         ,
    output logic  [16:0]        io_mem_acquire_bits_union          ,
    output logic                io_mem_grant_ready                 ,

//-----------------------------------------------------------------------------------
// D-CACHE  OUTPUT INTERFACE
//-----------------------------------------------------------------------------------
    output logic                DMEM_REQ_VALID,  
    output logic   [3:0]        DMEM_OP_TYPE,
    output logic   [4:0]        DMEM_REQ_CMD,
    output bus64_t              DMEM_REQ_BITS_DATA,
    output addr_t               DMEM_REQ_BITS_ADDR,
    output logic   [7:0]        DMEM_REQ_BITS_TAG,
    output logic                DMEM_REQ_INVALIDATE_LR,
    output logic                DMEM_REQ_BITS_KILL,

`endif

//-----------------------------------------------------------------------------------
// DEBUGGING MODULE SIGNALS
//-----------------------------------------------------------------------------------

// PC
    output addr_t               IO_FETCH_PC,
    output addr_t               IO_DEC_PC,
    output addr_t               IO_RR_PC,
    output addr_t               IO_EXE_PC,
    output addr_t               IO_WB_PC,
// WB
    output logic                IO_WB_PC_VALID,
    output logic  [4:0]         IO_WB_ADDR,
    output logic                IO_WB_WE,
    output bus64_t              IO_WB_BITS_ADDR,

    output bus64_t              IO_REG_READ_DATA,

    // VPU DEBUGGING INTERFACE
    input  logic                        dbg_re_i,
    input  logic                        dbg_we_i,
    input  logic [DBG_ADDR_WIDTH-1:0]   dbg_address_i,
    output logic [DBG_DATA_WIDTH-1:0]   dbg_read_data_o,
    input  logic [DBG_DATA_WIDTH-1:0]   dbg_write_data_i,


//-----------------------------------------------------------------------------
// PMU INTERFACE
//-----------------------------------------------------------------------------
    input  logic                io_core_pmu_l2_hit_i        ,
    input  logic                io_dc_gvalid_i     ,
    input  [1:0]                io_dc_addrbit_i    ,
    output logic                io_core_pmu_branch_miss     ,
    output logic                io_core_pmu_is_branch       ,
    output logic                io_core_pmu_branch_taken    , 
    output logic                io_core_pmu_EXE_STORE       ,
    output logic                io_core_pmu_EXE_LOAD        ,
    output logic                io_core_pmu_new_instruction ,
    output logic                io_core_pmu_icache_req      ,
    output logic                io_core_pmu_icache_kill     ,
    output logic                io_core_pmu_stall_if        ,
    output logic                io_core_pmu_stall_id        ,
    output logic                io_core_pmu_stall_rr        ,
    output logic                io_core_pmu_stall_exe       ,
    output logic                io_core_pmu_stall_wb        ,           
    output logic                io_core_pmu_buffer_miss     ,           
    output logic                io_core_pmu_imiss_kill      ,           
    output logic                io_core_pmu_dmiss_l2hit     ,           
    output logic                io_core_pmu_icache_bussy    ,
    output logic                io_core_pmu_imiss_time      

);


localparam ST_BUFF_PTR_WIDTH = EPI_pkg::STORE_CREDITS > 1 ? $clog2(EPI_pkg::STORE_CREDITS << 4) + 1 : 1;
localparam ITEM_BUFF_PTR_WIDTH = EPI_pkg::MASK_CREDITS > 1 ? $clog2(EPI_pkg::MASK_CREDITS) : 1;

logic st_buf_wr_en;
logic st_buf_rd_en;
logic st_buff_empty;
logic st_buff_full;
logic st_buff_filled;
logic [ST_BUFF_PTR_WIDTH:0] st_buff_wr_ptr;
logic [ST_BUFF_PTR_WIDTH:0] st_buff_rd_ptr;
logic [31:0] st_buff_rd_ptr_increment;

logic store_credit_cpu_vpu;

logic [0:((EPI_pkg::STORE_CREDITS + 1) << 4) - 1][8:0] vstore_buffer; //16 bytes per credit, credits + 1 for padding

logic dcache_lock;

vlem_store_data_t velem_store_int;

logic store_data_valid_q;

logic item_buff_wr_en;
logic item_buff_rd_en;
logic item_buff_empty;
logic item_buff_full;
logic item_buff_filled;
logic [ITEM_BUFF_PTR_WIDTH-1:0] item_buff_wr_ptr;
logic [ITEM_BUFF_PTR_WIDTH-1:0] item_buff_rd_ptr;

logic [EPI_pkg::MASK_CREDITS-1:0][0:EPI_pkg::ITEM_WIDTH-1] ovi_item_buffer;

ovi_mask_idx_t mask_idx_vpu_cpu_d, mask_idx_vpu_cpu_int;
logic mask_idx_credit_cpu_vpu;

ovi_item_t ovi_item_int;


// Response Interface icache to datapath
resp_icache_cpu_t resp_icache_interface_datapath;

// Request Datapath to Icache interface
req_cpu_icache_t req_datapath_icache_interface;

// Response Interface dcache to datapath
resp_dcache_cpu_t resp_dcache_interface_datapath;

// Request Datapath to Dcache interface
req_cpu_dcache_t req_datapath_dcache_interface;

// Response CSR Interface to datapath
resp_csr_cpu_t resp_csr_interface_datapath;

addr_t dcache_addr;

// struct debug input/output
debug_in_t debug_in;
debug_out_t debug_out;

//iCache
iresp_o_t      icache_resp  ;
ireq_i_t       lagarto_ireq ;
tresp_i_t      itlb_tresp   ;
treq_o_t       itlb_treq    ;
ifill_resp_i_t ifill_resp   ;
ifill_req_o_t  ifill_req    ;
logic          iflush       ;
logic          flush_ctrl;

//dCache
    // AMO Interface
amo_req_t    dcache_amo_req;
amo_resp_t   dcache_amo_resp;

        //Atomic Req
wire        lagarto_atm_req_valid       ; 
amo_t       lagarto_atm_req_amo_op      ;
wire [1:0]  lagarto_atm_req_size        ;
wire [63:0] lagarto_atm_req_operand_a   ;
wire [63:0] lagarto_atm_req_operand_b   ; 

    //Load Store INterface
dcache_req_i_t[2:0] dcache_lsu_req;   
dcache_req_o_t[2:0] dcache_lsu_resp;

wire [DCACHE_INDEX_WIDTH-1:0]  lagarto_ld_req_addr_index ;
wire [DCACHE_TAG_WIDTH-1:0]    lagarto_ld_req_addr_tag   ;
wire [63:0]                    lagarto_ld_req_wdata      ;
wire                           lagarto_ld_req_valid      ;
wire                           lagarto_ld_req_we         ;
wire [7:0]                     lagarto_ld_req_be         ;
wire [1:0]                     lagarto_ld_req_size       ;
wire                           lagarto_ld_req_kill       ;
wire                           lagarto_ld_req_tag_valid  ;
wire [DCACHE_INDEX_WIDTH-1:0]  lagarto_st_req_addr_index ;
wire [DCACHE_TAG_WIDTH-1:0]    lagarto_st_req_addr_tag   ;
wire [63:0]                    lagarto_st_req_wdata      ;
wire                           lagarto_st_req_valid      ;
wire                           lagarto_st_req_we         ;
wire [7:0]                     lagarto_st_req_be         ;
wire [1:0]                     lagarto_st_req_size       ;
wire                           lagarto_st_req_kill       ;
wire                           lagarto_st_req_tag_valid  ;   

wire            dcache_ld_data_gnt; 
wire            dcache_ld_data_rvalid; 
wire [63:0]     dcache_ld_data_rdata; 

wire            dcache_st_data_gnt; 

    //TLB
wire        lsu_dtlb_hit;
wire        lsu_dtlb_valid;
wire [63:0] lsu_paddr   ;
wire        lsu_req     ;
logic       lsu_req_dly ;
logic       lsu_req_raising_e;
wire [63:0] lsu_vaddr   ;
wire        lsu_store   ;
wire        lsu_load    ;

ariane_pkg::exception_t lsu_dtlb_exception;

//--PMU
to_PMU_t       pmu_flags    ;
logic          buffer_miss  ;
logic imiss_time_pmu  ;
logic imiss_kill_pmu ;
logic imiss_l2_hit ;
logic dmiss_l2_hit ;
logic dcache_resp_lock;

assign debug_in.halt_valid=debug_halt_i;
assign debug_in.change_pc_addr={24'b0,IO_FETCH_PC_VALUE};
assign debug_in.change_pc_valid=IO_FETCH_PC_UPDATE;
assign debug_in.reg_read_valid=IO_REG_READ;
assign debug_in.reg_read_write_addr=IO_REG_ADDR;
assign debug_in.reg_write_valid=IO_REG_WRITE;
assign debug_in.reg_write_data=IO_REG_WRITE_DATA;

    
assign IO_FETCH_PC=debug_out.pc_fetch;
assign IO_DEC_PC=debug_out.pc_dec;
assign IO_RR_PC=debug_out.pc_rr;
assign IO_EXE_PC=debug_out.pc_exe;
assign IO_WB_PC=debug_out.pc_wb;
assign IO_WB_PC_VALID=debug_out.wb_valid;
assign IO_WB_ADDR=debug_out.wb_reg_addr;
assign IO_WB_WE=debug_out.wb_reg_we;
assign IO_REG_READ_DATA=debug_out.reg_read_data;

`ifndef PITON_LAGARTO
// Register to save the last access to memory 
always @(posedge clk_i, negedge rstn_i) begin
    if(~rstn_i)
        dcache_addr <= 0;
    else
        dcache_addr <= DMEM_REQ_BITS_ADDR;
end
`endif 

assign IO_WB_BITS_ADDR = {24'b0,dcache_addr};

assign resp_csr_interface_datapath.csr_rw_rdata = CSR_RW_RDATA;
// NOTE:resp_csr_interface_datapath.csr_replay is a "ready" signal that indicate
// that the CSR are not blocked. In the implementation, since we only have one 
// inorder core any access to the CSR/PCR will be available. In multicore
// scenarios or higher performance cores you may need csr_replay.
assign resp_csr_interface_datapath.csr_replay = 1'b0; 
assign resp_csr_interface_datapath.csr_stall = CSR_CSR_STALL;
assign resp_csr_interface_datapath.csr_exception = CSR_XCPT;
assign resp_csr_interface_datapath.csr_exception_cause = CSR_XCPT_CAUSE;
assign resp_csr_interface_datapath.csr_tval = CSR_TVAL;
assign resp_csr_interface_datapath.csr_eret = CSR_ERET;
assign resp_csr_interface_datapath.csr_evec = {{25{CSR_EVEC[39]}},CSR_EVEC[38:0]};
assign resp_csr_interface_datapath.csr_interrupt = CSR_INTERRUPT;
assign resp_csr_interface_datapath.csr_interrupt_cause = CSR_INTERRUPT_CAUSE;
 
// Request Datapath to CSR
req_cpu_csr_t req_datapath_csr_interface;

assign CSR_RW_ADDR      = req_datapath_csr_interface.csr_rw_addr;
assign CSR_RW_CMD       = req_datapath_csr_interface.csr_rw_cmd;
assign CSR_RW_WDATA     = req_datapath_csr_interface.csr_rw_data;
assign CSR_EXCEPTION    = req_datapath_csr_interface.csr_exception;
assign CSR_RETIRE       = req_datapath_csr_interface.csr_retire;
assign CSR_CAUSE        = req_datapath_csr_interface.csr_xcpt_cause;
assign CSR_PC           = req_datapath_csr_interface.csr_pc;

`ifndef PITON_LAGARTO
//L2 Network conection - response
assign ifill_resp.data  = io_mem_grant_bits_data             ;  
assign ifill_resp.beat  = io_mem_grant_bits_addr_beat        ;
assign ifill_resp.valid = io_mem_grant_valid                 ;
assign ifill_resp.ack   = io_mem_grant_bits_addr_beat[0] &
                          io_mem_grant_bits_addr_beat[1] ;
`endif

//L2 Network conection - request
assign io_mem_acquire_valid                = ifill_req.valid        ;
assign io_mem_acquire_bits_addr_block      = ifill_req.paddr        ;
assign io_mem_acquire_bits_client_xact_id  =   1'b0                 ;
assign io_mem_acquire_bits_addr_beat       =   2'b0                 ;
assign io_mem_acquire_bits_data            = 127'b0                 ;
assign io_mem_acquire_bits_is_builtin_type =   1'b1                 ;
assign io_mem_acquire_bits_a_type          =   3'b001               ;
assign io_mem_acquire_bits_union           =  17'b00000000111000001 ;
assign io_mem_grant_ready                  =   1'b1                 ;

//TLB conection
`ifndef PITON_LAGARTO
assign itlb_tresp.miss   = TLB_RESP_MISS     ;
assign itlb_tresp.ptw_v  = iptw_resp_valid_i ;
assign itlb_tresp.ppn    = itlb_resp_ppn_i   ;
assign itlb_tresp.xcpt   = TLB_RESP_XCPT_IF  ;
`endif
assign TLB_REQ_BITS_VPN  = itlb_treq.vpn     ;
assign TLB_REQ_VALID     = itlb_treq.valid   ;

//-- PMU conection
assign io_core_pmu_icache_req       = lagarto_ireq.valid                    ; 
assign io_core_pmu_icache_kill      = lagarto_ireq.kill                     ;
assign io_core_pmu_stall_if         = pmu_flags.stall_if                    ;  
assign io_core_pmu_stall_id         = pmu_flags.stall_id                    ; 
assign io_core_pmu_stall_rr         = pmu_flags.stall_rr                    ; 
assign io_core_pmu_stall_exe        = pmu_flags.stall_exe                   ; 
assign io_core_pmu_stall_wb         = pmu_flags.stall_wb                    ; 
assign io_core_pmu_branch_miss      = pmu_flags.branch_miss                 ; 
assign io_core_pmu_is_branch        = pmu_flags.is_branch                   ; 
assign io_core_pmu_branch_taken     = pmu_flags.branch_taken                ; 
assign io_core_pmu_new_instruction  = req_datapath_csr_interface.csr_retire ;
assign io_core_pmu_buffer_miss      = imiss_l2_hit                          ;
assign io_core_pmu_dmiss_l2hit      = dmiss_l2_hit                          ;
assign io_core_pmu_imiss_time       = imiss_time_pmu                        ;
assign io_core_pmu_imiss_kill       = imiss_kill_pmu                        ;
assign io_core_pmu_icache_bussy     = !icache_resp.ready                    ;

// OVI CSR fields
logic [EPI_pkg::CSR_VSTART_WIDTH-1:0] ovi_csr_vstart;
logic [EPI_pkg::CSR_VLEN_WIDTH-1:0] ovi_csr_vl;
logic [EPI_pkg::CSR_VXRM_WIDTH-1:0] ovi_csr_vxrm;
logic [EPI_pkg::CSR_FRM_WIDTH-1:0] ovi_csr_frm;
logic [EPI_pkg::CSR_VSEW_WIDTH:0] ovi_csr_vsew; // 3 bits instead of 2
logic [EPI_pkg::CSR_VLMUL_WIDTH-1:0] ovi_csr_vlmul;
logic ovi_csr_vill;

vpu_issue_disp_t req_cpu_vpu_issue_int;
vpu_completed_t  resp_vpu_cpu_comp_d, resp_vpu_cpu_comp_int;
logic vpu_cpu_credit_int;

ovi_load_t load_cpu_vpu_int;
ovi_store_t store_vpu_cpu_d, store_vpu_cpu_int;
ovi_memop_t memop_cpu_vpu_int;

logic memop_sync_start_vpu_cpu_d, memop_sync_start_vpu_cpu;

fflags_t fflags_d, fflags_q;
logic vxsat_d, vxsat_q;

logic [DBG_DATA_WIDTH-1:0]   dbg_read_data_d, dbg_read_data_q;

vpu_state_t vpu_state_int;
logic [31:0] velem_cnt;
logic dtlb_miss;
logic dtlb_miss_st;
logic dtlb_miss_ld;
logic dtlb_miss_ma_st;
logic dtlb_miss_ma_ld;
// data is misaligned
logic data_misaligned;
logic data_misaligned_dly;
logic overflow;

datapath datapath_inst(
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .reset_addr_i(RESET_ADDRESS),
    // Input datapath
    .soft_rstn_i(SOFT_RST),
    .resp_icache_cpu_i(resp_icache_interface_datapath), 
    .resp_dcache_cpu_i(resp_dcache_interface_datapath), 
    .resp_csr_cpu_i(resp_csr_interface_datapath),
    .ovi_csr_vl_i(ovi_csr_vl),
    .ovi_csr_vsew_i(ovi_csr_vsew),
    .resp_vpu_cpu_i(resp_vpu_cpu_comp_int),
    .ovi_memop_sync_start_i(memop_sync_start_vpu_cpu),
    .velem_store_i(velem_store_int),
    .ovi_item_i(ovi_item_int),
    .debug_i(debug_in),
    .csr_priv_lvl_i(csr_priv_lvl_i),
`ifdef PITON_LAGARTO
    .en_ld_st_translation_i (en_ld_st_translation_i),
`endif
    // Output datapath
    .req_cpu_dcache_o(req_datapath_dcache_interface),
    .req_cpu_icache_o(req_datapath_icache_interface),
    .req_cpu_csr_o(req_datapath_csr_interface),
    .vpu_state_o(vpu_state_int),
    .ovi_memop_sync_end_o(memop_cpu_vpu_int),
    .req_cpu_vpu_o(req_cpu_vpu_issue_int),
    .ovi_load_o(load_cpu_vpu_int),
    .velem_cnt_o(velem_cnt),
    .debug_o(debug_out),
    //PMU                                                   
    .pmu_flags_o        (pmu_flags)
);


`ifdef PITON_LAGARTO


  icache_interface icache_interface_inst(
    .clk_i(clk_i),
    .rstn_i(rstn_i),

    // Inputs ICache
    .icache_resp_datablock_i    ( icache_resp.data  ),
    .icache_resp_vaddr_i        ( icache_resp.vaddr ), 
    .icache_resp_valid_i        ( icache_resp.valid ),
    .icache_req_ready_i         ( icache_resp.ready ), 
    .tlb_resp_xcp_if_i          ( icache_resp.xcpt  ), 
   
    // Outputs ICache
    .icache_invalidate_o    ( iflush             ), 
    .icache_req_bits_idx_o  ( lagarto_ireq.idx   ), 
    .icache_req_kill_o      ( lagarto_ireq.kill  ), 
    .icache_req_valid_o     ( lagarto_ireq.valid ),
    .icache_req_bits_vpn_o  ( lagarto_ireq.vpn   ), 

    // Fetch stage interface - Request packet from fetch_stage
    .req_fetch_icache_i(req_datapath_icache_interface),
    
    // Fetch stage interface - Response packet icache to fetch
    .resp_icache_fetch_o(resp_icache_interface_datapath),
    //PMU
    .buffer_miss_o (buffer_miss )
  );

  // I$ Address translation request
  ariane_pkg::icache_areq_o_t icache_mmu_areq;
  ariane_pkg::icache_areq_i_t mmu_icache_areq;
  // I$ Data request
  ariane_pkg::icache_dreq_i_t icache_dreq_i;
  ariane_pkg::icache_dreq_o_t icache_dreq_o;

  assign icache_dreq_i.req     = lagarto_ireq.valid;
  assign icache_dreq_i.kill_s1 = iflush;
  assign icache_dreq_i.kill_s2 = lagarto_ireq.kill;
  assign icache_dreq_i.vaddr   = {lagarto_ireq.vpn, lagarto_ireq.idx};
  assign icache_resp.data  = icache_dreq_o.data;
  assign icache_resp.vaddr = icache_dreq_o.vaddr;
  assign icache_resp.valid = icache_dreq_o.valid;
  assign icache_resp.ready = icache_dreq_o.ready;
  assign icache_resp.xcpt  = icache_dreq_o.valid && icache_dreq_o.ex.valid;
  
  // D$ request
                                                                                           
  assign dcache_lsu_req[1].address_index =  lagarto_ld_req_addr_index;     
  assign dcache_lsu_req[1].address_tag   =  lagarto_ld_req_addr_tag  ;     
  assign dcache_lsu_req[1].data_wdata    =  lagarto_ld_req_wdata     ;     
  assign dcache_lsu_req[1].data_req      =  lagarto_ld_req_valid     ;     
  assign dcache_lsu_req[1].data_we       =  lagarto_ld_req_we        ;     
  assign dcache_lsu_req[1].data_be       =  lagarto_ld_req_be        ;     
  assign dcache_lsu_req[1].data_size     =  lagarto_ld_req_size      ;     
  assign dcache_lsu_req[1].kill_req      =  lagarto_ld_req_kill      ;     
  assign dcache_lsu_req[1].tag_valid     =  lagarto_ld_req_tag_valid ;

  assign dcache_lsu_req[2].address_index =  lagarto_st_req_addr_index;     
  assign dcache_lsu_req[2].address_tag   =  lagarto_st_req_addr_tag  ;     
  assign dcache_lsu_req[2].data_wdata    =  lagarto_st_req_wdata     ;     
  assign dcache_lsu_req[2].data_req      =  lagarto_st_req_valid     ;     
  assign dcache_lsu_req[2].data_we       =  lagarto_st_req_we        ;     
  assign dcache_lsu_req[2].data_be       =  lagarto_st_req_be        ;     
  assign dcache_lsu_req[2].data_size     =  lagarto_st_req_size      ;     
  assign dcache_lsu_req[2].kill_req      =  lagarto_st_req_kill      ;     
  assign dcache_lsu_req[2].tag_valid     =  lagarto_st_req_tag_valid ;

  assign dcache_amo_req.req              =  lagarto_atm_req_valid    ;
  assign dcache_amo_req.amo_op           =  lagarto_atm_req_amo_op   ;
  assign dcache_amo_req.size             =  lagarto_atm_req_size     ;
  assign dcache_amo_req.operand_a        =  lagarto_atm_req_operand_a;  
  assign dcache_amo_req.operand_b        =  lagarto_atm_req_operand_b;

  // this is a cache subsystem that is compatible with OpenPiton
  wt_cache_subsystem #(
    .ArianeCfg ( ArianeCfg )
  ) i_cache_subsystem (
    // to D$
    .clk_i             (clk_i          ),
    .rst_ni            (rstn_i         ),
    
    // I$
    //.icache_en_i       (!dcache_resp_lock),
    .icache_en_i       (csr_icache_enable_i),
    .icache_flush_i    (iflush         ),
    .icache_miss_o     (               ),
    // I$ address translation requests
    .icache_areq_i     (mmu_icache_areq),
    .icache_areq_o     (icache_mmu_areq),
    // I$ data requests
    .icache_dreq_i     (icache_dreq_i  ),
    .icache_dreq_o     (icache_dreq_o  ),
    
    // D$
    .dcache_enable_i   (csr_dcache_enable_i),
    .dcache_flush_i    (               0),
    .dcache_flush_ack_o(               ),
    // to commit stage
    .dcache_amo_req_i  (dcache_amo_req ),
    .dcache_amo_resp_o (dcache_amo_resp),

    // from PTW, Load Unit  and Store Unit
    .dcache_miss_o     (               ),
    .dcache_req_ports_i(dcache_lsu_req ),
    .dcache_req_ports_o(dcache_lsu_resp),
    // write buffer status
    .wbuffer_empty_o   (               ),
    
    .l15_req_o         (l15_req_o      ),
    .l15_rtrn_i        (l15_rtrn_i     )
);

    assign dcache_ld_data_gnt    = dcache_lsu_resp[1].data_gnt    ;               
    assign dcache_ld_data_rvalid = dcache_lsu_resp[1].data_rvalid ;               
    assign dcache_ld_data_rdata  = dcache_lsu_resp[1].data_rdata  ;

    assign dcache_st_data_gnt    = dcache_lsu_resp[2].data_gnt    ;               

    ariane_pkg::exception_t misaligned_exception;
    assign overflow = !((&lsu_vaddr[63:riscv::VLEN-1]) == 1'b1 || (|lsu_vaddr[63:riscv::VLEN-1]) == 1'b0);


// ------------------------
    // Misaligned Exception
    // ------------------------
    // we can detect a misaligned exception immediately
    // the misaligned exception is passed to the functional unit via the MMU, which in case
    // can augment the exception if other memory related exceptions like a page fault or access errors
    always_comb begin : data_misaligned_detection

        misaligned_exception = {
            64'b0,
            64'b0,
            1'b0
        };

        data_misaligned = 1'b0;

        if (lsu_req_raising_e) begin
            case (req_datapath_dcache_interface.instr_type)
                // double word
                LD, SD,
                AMO_LRD, AMO_SCD,
                AMO_SWAPD, AMO_ADDD, AMO_ANDD, AMO_ORD,
                AMO_XORD, AMO_MAXD, AMO_MAXDU, AMO_MIND,
                AMO_MINDU: begin
                    if (lsu_vaddr[2:0] != 3'b000) begin
                        data_misaligned = 1'b1;
                    end
                end
                // word
                LW, LWU, SW, 
                AMO_LRW, AMO_SCW,
                AMO_SWAPW, AMO_ADDW, AMO_ANDW, AMO_ORW,
                AMO_XORW, AMO_MAXW, AMO_MAXWU, AMO_MINW,
                AMO_MINWU: begin
                    if (lsu_vaddr[1:0] != 2'b00) begin
                        data_misaligned = 1'b1;
                    end
                end
                // half word
                LH, LHU, SH: begin
                    if (lsu_vaddr[0] != 1'b0) begin
                        data_misaligned = 1'b1;
                    end
                end
                // byte -> is always aligned
                default:;
            endcase
        end

        if (data_misaligned) begin

            if (!lsu_store) begin
                misaligned_exception = {
                    riscv::LD_ADDR_MISALIGNED,
                    {{64-riscv::VLEN{1'b0}},lsu_vaddr},
                    1'b1
                };

            end else if (lsu_store) begin
                misaligned_exception = {
                    riscv::ST_ADDR_MISALIGNED,
                    {{64-riscv::VLEN{1'b0}},lsu_vaddr},
                    1'b1
                };
            end
        end

        if (en_ld_st_translation_i && overflow) begin

            if (!lsu_store) begin
                misaligned_exception = {
                    riscv::LD_ACCESS_FAULT,
                    {{64-riscv::VLEN{1'b0}},lsu_vaddr},
                    1'b1
                };

            end else if (lsu_store) begin
                misaligned_exception = {
                    riscv::ST_ACCESS_FAULT,
                    {{64-riscv::VLEN{1'b0}},lsu_vaddr},
                    1'b1
                };
            end
        end
    end

always_ff @(posedge clk_i or negedge rstn_i) begin
    if(~rstn_i) begin
        lsu_req_dly         <= 0;
        data_misaligned_dly <= 0;
    end else begin
        lsu_req_dly         <= lsu_req;
        data_misaligned_dly <= data_misaligned;
    end
end

assign lsu_req_raising_e = lsu_req & !lsu_req_dly;
  mmu #(
        .INSTR_TLB_ENTRIES(16),
        .DATA_TLB_ENTRIES (16),
        .ASID_WIDTH       (ASID_WIDTH),
        .ArianeCfg        (ArianeCfg)
    ) i_mmu (
    .clk_i                 (clk_i           ),
    .rst_ni                (rstn_i          ),
    .flush_i               (                ),
    .enable_translation_i  (en_translation_i),
    .en_ld_st_translation_i(en_ld_st_translation_i),
    // Address translation request
    .icache_areq_i         (icache_mmu_areq ),
    .icache_areq_o         (mmu_icache_areq ),
    
    .misaligned_ex_i       (misaligned_exception),
    .lsu_req_i             (lsu_req             ),
    .lsu_vaddr_i           (lsu_vaddr           ),
    .lsu_is_store_i        (lsu_store           ),
    .lsu_dtlb_hit_o        (lsu_dtlb_hit        ),
    .lsu_valid_o           (lsu_dtlb_valid      ),
    .lsu_paddr_o           (lsu_paddr           ),
    .lsu_exception_o       (lsu_dtlb_exception  ),
    .priv_lvl_i            (riscv::priv_lvl_t'(csr_priv_lvl_i) ),
    .ld_st_priv_lvl_i      (riscv::priv_lvl_t'(csr_priv_lvl_i) ),
    .sum_i                 (sum_i               ),
    .mxr_i                 (mxr                 ),
    .satp_ppn_i            (satp_ppn_i          ),
    .asid_i                (asid_i              ),
    .flush_tlb_i           (                    ),
    .itlb_miss_o           (                    ),
    .dtlb_miss_o           (dtlb_miss           ),
    .req_port_i            (dcache_lsu_resp[0]  ),
    .req_port_o            (dcache_lsu_req[0]   )
  );   

  lagarto_dcache_interface lagarto_dcache_interface_inst(
    .clk_i                      (clk_i                          ),
    .rstn_i                     (rstn_i                         ),
    .req_cpu_dcache_i           (req_datapath_dcache_interface  ),
    .dtlb_hit_i                 (lsu_dtlb_hit                   ),
    .dtlb_valid_i               (lsu_dtlb_valid                 ),
    .paddr_i                    (lsu_paddr                      ),
    .mmu_req_o                  (lsu_req                        ),
    .mmu_vaddr_o                (lsu_vaddr                      ),
    .mmu_store_o                (lsu_store                      ),
    .mmu_load_o                 (lsu_load                       ),
    .ld_mem_req_addr_index_o    (lagarto_ld_req_addr_index      ),
    .ld_mem_req_addr_tag_o      (lagarto_ld_req_addr_tag        ),
    .ld_mem_req_wdata_o         (lagarto_ld_req_wdata           ),
    .ld_mem_req_valid_o         (lagarto_ld_req_valid           ),
    .ld_mem_req_we_o            (lagarto_ld_req_we              ),
    .ld_mem_req_be_o            (lagarto_ld_req_be              ),
    .ld_mem_req_size_o          (lagarto_ld_req_size            ),
    .ld_mem_req_kill_o          (lagarto_ld_req_kill            ),
    .ld_mem_req_tag_valid_o     (lagarto_ld_req_tag_valid       ),
    .st_mem_req_addr_index_o    (lagarto_st_req_addr_index      ),
    .st_mem_req_addr_tag_o      (lagarto_st_req_addr_tag        ),
    .st_mem_req_wdata_o         (lagarto_st_req_wdata           ),
    .st_mem_req_valid_o         (lagarto_st_req_valid           ),
    .st_mem_req_we_o            (lagarto_st_req_we              ),
    .st_mem_req_be_o            (lagarto_st_req_be              ),
    .st_mem_req_size_o          (lagarto_st_req_size            ),
    .st_mem_req_kill_o          (lagarto_st_req_kill            ),
    .st_mem_req_tag_valid_o     (lagarto_st_req_tag_valid       ),
    .atm_mem_req_valid          (lagarto_atm_req_valid          ),
    .atm_mem_req_amo_op         (lagarto_atm_req_amo_op         ),
    .atm_mem_req_size           (lagarto_atm_req_size           ),
    .atm_mem_req_operand_a      (lagarto_atm_req_operand_a      ),
    .atm_mem_req_operand_b      (lagarto_atm_req_operand_b      ),
    .ack_atm_i                  (dcache_amo_resp.ack            ),
    .dmem_resp_atm_data_i       (dcache_amo_resp.result         ),
    .dmem_resp_data_i           (dcache_ld_data_rdata           ),    
    .dmem_resp_valid_i          (dcache_ld_data_rvalid          ),
    .dmem_resp_nack_i           (0                              ), //TODO !
    .dmem_xcpt_ma_st_i          (dtlb_miss_ma_st                ), 
    .dmem_xcpt_ma_ld_i          (dtlb_miss_ma_ld                ),
    .dmem_xcpt_pf_st_i          (dtlb_miss_st                   ), 
    .dmem_xcpt_pf_ld_i          (dtlb_miss_ld                   ), 
    .dmem_resp_gnt_st_i         (dcache_st_data_gnt             ),
    .dmem_resp_gnt_ld_i         (dcache_ld_data_gnt             ),
    // Response towards Lagarto
    .resp_dcache_cpu_o          (resp_dcache_interface_datapath)    
);

assign dtlb_miss_st = lsu_dtlb_exception.valid & lsu_store      & lsu_req & (!data_misaligned_dly);
assign dtlb_miss_ld = lsu_dtlb_exception.valid & (!lsu_store)   & lsu_req & (!data_misaligned_dly);
assign dtlb_miss_ma_st = lsu_dtlb_exception.valid & lsu_store      & lsu_req & data_misaligned_dly;
assign dtlb_miss_ma_ld = lsu_dtlb_exception.valid & (!lsu_store)   & lsu_req & data_misaligned_dly;
assign dcache_resp_lock = resp_dcache_interface_datapath.lock;
`else // Original lowrisc-lagarto
  
icache_interface icache_interface_inst(
    .clk_i(clk_i),
    .rstn_i(rstn_i),

    // Inputs ICache
    .icache_resp_datablock_i    ( icache_resp.data  ),
    .icache_resp_vaddr_i        ( icache_resp.vaddr ), 
    .icache_resp_valid_i        ( icache_resp.valid ),
    .icache_req_ready_i         ( icache_resp.ready ), 
    .tlb_resp_xcp_if_i          ( icache_resp.xcpt  ), 
   
    // Outputs ICache
    .icache_invalidate_o    ( iflush             ), 
    .icache_req_bits_idx_o  ( lagarto_ireq.idx   ), 
    .icache_req_kill_o      ( lagarto_ireq.kill  ), 
    .icache_req_valid_o     ( lagarto_ireq.valid ),
    .icache_req_bits_vpn_o  ( lagarto_ireq.vpn   ), 

    // Fetch stage interface - Request packet from fetch_stage
    .req_fetch_icache_i(req_datapath_icache_interface),
    
    // Fetch stage interface - Response packet icache to fetch
    .resp_icache_fetch_o(resp_icache_interface_datapath),
    //PMU
    .buffer_miss_o (buffer_miss )
);

dcache_interface dcache_interface_inst(
    .clk_i(clk_i),
    .rstn_i(rstn_i),

    .req_cpu_dcache_i(req_datapath_dcache_interface),

    // DCACHE Answer
    .dmem_resp_replay_i(DMEM_RESP_BITS_REPLAY),
    .dmem_resp_data_i(DMEM_RESP_BITS_DATA_SUBW),
    .dmem_req_ready_i(DMEM_REQ_READY),
    .dmem_resp_valid_i(DMEM_RESP_VALID), 
    .dmem_resp_nack_i(DMEM_RESP_BITS_NACK),
    .dmem_xcpt_ma_st_i(DMEM_XCPT_MA_ST),
    .dmem_xcpt_ma_ld_i(DMEM_XCPT_MA_LD),
    .dmem_xcpt_pf_st_i(DMEM_XCPT_PF_ST),
    .dmem_xcpt_pf_ld_i(DMEM_XCPT_PF_LD),

    // Interface request
    .dmem_req_valid_o(DMEM_REQ_VALID),
    .dmem_req_cmd_o(DMEM_REQ_CMD),
    .dmem_req_addr_o(DMEM_REQ_BITS_ADDR),
    .dmem_op_type_o(DMEM_OP_TYPE),
    .dmem_req_data_o(DMEM_REQ_BITS_DATA),
    .dmem_req_tag_o(DMEM_REQ_BITS_TAG),
    .dmem_req_invalidate_lr_o(DMEM_REQ_INVALIDATE_LR),
    .dmem_req_kill_o(DMEM_REQ_BITS_KILL),

    // PMU
    .dmem_is_store_o ( io_core_pmu_EXE_STORE ),
    .dmem_is_load_o  ( io_core_pmu_EXE_LOAD  ),
    
    // DCACHE Answer to cpu
    .resp_dcache_cpu_o(resp_dcache_interface_datapath) 
);


top_icache icache (
    .clk_i              ( clk_i         ) ,
    .rstn_i             ( rstn_i        ) ,
    .flush_i            ( iflush        ) , 
    .lagarto_ireq_i     ( lagarto_ireq  ) , //- From Lagarto.
    .icache_resp_o      ( icache_resp   ) , //- To Lagarto.
    .mmu_tresp_i        ( itlb_tresp    ) , //- From MMU.
    .icache_treq_o      ( itlb_treq     ) , //- To MMU.
    .ifill_resp_i       ( ifill_resp    ) , //- From upper levels.
    .icache_ifill_req_o ( ifill_req     ) ,  //- To upper levels. 
    .imiss_time_pmu_o    ( imiss_time_pmu ) ,
    .imiss_kill_pmu_o    ( imiss_kill_pmu )
);


//PMU  
assign imiss_l2_hit = ifill_resp.ack & io_core_pmu_l2_hit_i & ifill_resp.valid ; 
assign dmiss_l2_hit = io_dc_gvalid_i & ( io_dc_addrbit_i[0] & io_dc_addrbit_i[1] ) & 
                                                                io_core_pmu_l2_hit_i;
`endif 


// --------------------------
// OVI vector stores support
// --------------------------

assign ovi_csr_vstart = csr_vpu_data_i[13:0];
assign ovi_csr_vl = csr_vpu_data_i[28:14];
assign ovi_csr_vsew = csr_vpu_data_i[38:36];

assign dcache_lock = resp_dcache_interface_datapath.lock;

assign st_buf_rd_en = (st_buff_rd_ptr < st_buff_wr_ptr) || st_buff_filled;
assign st_buf_wr_en = (st_buff_rd_ptr > (st_buff_wr_ptr+16)) || ~st_buff_filled;

assign st_buff_empty = ~st_buf_rd_en;
assign st_buff_full = ~st_buf_wr_en;

always_comb begin
    case (ovi_csr_vsew)
        SEW8: begin
            if (vpu_state_int == VSTORE_INFLIGHT && (velem_cnt & 7) == 0) begin
                st_buff_rd_ptr_increment = 8;
            end else begin
                st_buff_rd_ptr_increment = 1;
            end
        end
        SEW16: begin
            if (vpu_state_int == VSTORE_INFLIGHT && (velem_cnt & 3) == 0) begin
                st_buff_rd_ptr_increment = 8;
            end else begin
                st_buff_rd_ptr_increment = 2;
            end
        end
        SEW32: begin
            if (vpu_state_int == VSTORE_INFLIGHT && (velem_cnt & 1) == 0) begin
                st_buff_rd_ptr_increment = 8;
            end else begin
                st_buff_rd_ptr_increment = 4;
            end
        end
        default: begin
            st_buff_rd_ptr_increment = 8;
        end
    endcase
end

always_comb begin
    velem_store_int.data[7:0] = vstore_buffer[st_buff_rd_ptr];
    velem_store_int.data[15:8] = vstore_buffer[st_buff_rd_ptr+1];
    velem_store_int.data[23:16] = vstore_buffer[st_buff_rd_ptr+2];
    velem_store_int.data[31:24] = vstore_buffer[st_buff_rd_ptr+3];
    velem_store_int.data[39:32] = vstore_buffer[st_buff_rd_ptr+4];
    velem_store_int.data[47:40] = vstore_buffer[st_buff_rd_ptr+5];
    velem_store_int.data[55:48] = vstore_buffer[st_buff_rd_ptr+6];
    velem_store_int.data[63:56] = vstore_buffer[st_buff_rd_ptr+7];
end
assign velem_store_int.valid = ~st_buff_empty && (vpu_state_int == VSTORE_INFLIGHT || (vpu_state_int == VSCATTER_INFLIGHT && ~item_buff_empty));

always_ff @(posedge clk_i or negedge rstn_i) begin
    if(~rstn_i) begin
        st_buff_rd_ptr <= 0;
        st_buff_wr_ptr <= 0;
        vstore_buffer <= '{default: 0};
        store_credit_cpu_vpu <= 0;
        store_data_valid_q <= 0;
    end else begin
        if (resp_vpu_cpu_comp_int.valid) begin
            st_buff_rd_ptr <= 0;
            st_buff_wr_ptr <= 0;
            vstore_buffer <= '{default: 0};
            store_credit_cpu_vpu <= 0;
            store_data_valid_q <= 0;
        end else begin
            //Write into the store buffer
            if ((store_data_valid_q | store_vpu_cpu_int.store_valid) && ((vpu_state_int == VSTORE_INFLIGHT) || (vpu_state_int == VSCATTER_INFLIGHT)) && st_buf_wr_en) begin
                vstore_buffer[st_buff_wr_ptr] <= store_vpu_cpu_int.store_data[7:0];
                vstore_buffer[st_buff_wr_ptr+1] <= store_vpu_cpu_int.store_data[15:8];
                vstore_buffer[st_buff_wr_ptr+2] <= store_vpu_cpu_int.store_data[23:16];
                vstore_buffer[st_buff_wr_ptr+3] <= store_vpu_cpu_int.store_data[31:24];
                vstore_buffer[st_buff_wr_ptr+4] <= store_vpu_cpu_int.store_data[39:32];
                vstore_buffer[st_buff_wr_ptr+5] <= store_vpu_cpu_int.store_data[47:40];
                vstore_buffer[st_buff_wr_ptr+6] <= store_vpu_cpu_int.store_data[55:48];
                vstore_buffer[st_buff_wr_ptr+7] <= store_vpu_cpu_int.store_data[63:56];
                vstore_buffer[st_buff_wr_ptr+8] <= store_vpu_cpu_int.store_data[71:64];
                vstore_buffer[st_buff_wr_ptr+9] <= store_vpu_cpu_int.store_data[79:72];
                vstore_buffer[st_buff_wr_ptr+10] <= store_vpu_cpu_int.store_data[87:80];
                vstore_buffer[st_buff_wr_ptr+11] <= store_vpu_cpu_int.store_data[95:88];
                vstore_buffer[st_buff_wr_ptr+12] <= store_vpu_cpu_int.store_data[103:96];
                vstore_buffer[st_buff_wr_ptr+13] <= store_vpu_cpu_int.store_data[111:104];
                vstore_buffer[st_buff_wr_ptr+14] <= store_vpu_cpu_int.store_data[119:112];
                vstore_buffer[st_buff_wr_ptr+15] <= store_vpu_cpu_int.store_data[127:120];
                if (st_buff_wr_ptr + 16 == ((EPI_pkg::STORE_CREDITS) << 4)) begin
                    st_buff_wr_ptr <= 0;
                end else begin
                    st_buff_wr_ptr <= st_buff_wr_ptr + 16;
                end
            end
            
            //Read from store buffer
            if (st_buf_rd_en && ~dcache_lock && (vpu_state_int == VSTORE_INFLIGHT || (vpu_state_int == VSCATTER_INFLIGHT && ~item_buff_empty))) begin
                if (st_buff_rd_ptr + st_buff_rd_ptr_increment == ((EPI_pkg::STORE_CREDITS) << 4)) begin
                    st_buff_rd_ptr <= 0;
                end else begin
                    st_buff_rd_ptr <= st_buff_rd_ptr + st_buff_rd_ptr_increment;
                end
                store_credit_cpu_vpu <= ~st_buff_full; //Return a credit each time we read and we are able to write
            end else begin
                store_credit_cpu_vpu <= 0;
            end

            if (~st_buf_wr_en) begin
                store_data_valid_q <= store_data_valid_q | store_vpu_cpu_int.store_valid;
            end else begin
                store_data_valid_q <= 0;
            end
        end//if (resp_vpu_cpu_comp_int.valid)
    end
end

always_ff @(posedge clk_i or negedge rstn_i) begin
    if(~rstn_i) begin
        st_buff_filled <= 0;
    end else begin
        if (resp_vpu_cpu_comp_int.valid) begin
            st_buff_filled <= 0;
        end else begin
            //Read from store buffer
        if ((st_buf_rd_en && ~dcache_lock && (vpu_state_int == VSTORE_INFLIGHT || (vpu_state_int == VSCATTER_INFLIGHT && ~item_buff_empty))) && ((st_buff_rd_ptr + st_buff_rd_ptr_increment == ((EPI_pkg::STORE_CREDITS) << 4)))) begin
                st_buff_filled <= 0;
            end else begin
                //Write into the store buffer
                if (((store_data_valid_q | store_vpu_cpu_int.store_valid) && ((vpu_state_int == VSTORE_INFLIGHT) || (vpu_state_int == VSCATTER_INFLIGHT)) && st_buf_wr_en) && (st_buff_wr_ptr + 16 == ((EPI_pkg::STORE_CREDITS) << 4))) begin
                    st_buff_filled <= 1;
                end
            end
        end
    end
end

// --------------------------
// OVI vector gather/scatter
// --------------------------
assign item_buff_rd_en = (item_buff_rd_ptr < item_buff_wr_ptr) || item_buff_filled;
assign item_buff_wr_en = (item_buff_rd_ptr > item_buff_wr_ptr) || ~item_buff_filled;

assign item_buff_empty = ~item_buff_rd_en;
assign item_buff_full = ~item_buff_wr_en;

assign ovi_item_int.mask_idx_valid = ~item_buff_empty && (vpu_state_int == VGATHER_INFLIGHT || (vpu_state_int == VSCATTER_INFLIGHT && ~st_buff_empty));
assign ovi_item_int.mask_idx_item = ovi_item_buffer[item_buff_rd_ptr];

always_ff @(posedge clk_i or negedge rstn_i) begin
    if (~rstn_i) begin
        item_buff_rd_ptr <= 0;
        item_buff_wr_ptr <= 0;
        ovi_item_buffer <= '{default: 0};
        mask_idx_credit_cpu_vpu <= 0;
    end else begin
        if(resp_vpu_cpu_comp_int.valid) begin
            item_buff_rd_ptr <= 0;
            item_buff_wr_ptr <= 0;
            ovi_item_buffer <= '{default: 0};
            mask_idx_credit_cpu_vpu <= 0;
        end else begin
            //Write into the item buffer
            if (mask_idx_vpu_cpu_int.mask_idx_valid && ((vpu_state_int == VGATHER_INFLIGHT) || (vpu_state_int == VSCATTER_INFLIGHT)) && item_buff_wr_en) begin
                ovi_item_buffer[item_buff_wr_ptr] <= mask_idx_vpu_cpu_int.mask_idx_item;
                if (item_buff_wr_ptr + 1 == EPI_pkg::MASK_CREDITS) begin
                    item_buff_wr_ptr <= 0;
                end else begin
                    item_buff_wr_ptr <= item_buff_wr_ptr + 1;
                end
            end

            //Read from the item buffer
            if (item_buff_rd_en && ~dcache_lock && (vpu_state_int == VGATHER_INFLIGHT || (vpu_state_int == VSCATTER_INFLIGHT && ~st_buff_empty))) begin
                if (item_buff_rd_ptr + 1 == EPI_pkg::MASK_CREDITS) begin
                    item_buff_rd_ptr <= 0;
                end else begin
                    item_buff_rd_ptr <= item_buff_rd_ptr + 1;
                end
                mask_idx_credit_cpu_vpu <= ~item_buff_empty;
            end else begin
                mask_idx_credit_cpu_vpu <= 0;
            end
        end
    end
end

always_ff @(posedge clk_i or negedge rstn_i) begin
    if (~rstn_i) begin
        item_buff_filled <= 0;
    end else begin
        if(resp_vpu_cpu_comp_int.valid) begin
            item_buff_filled <= 0;
        end else begin

            //Read from the item buffer
            if ((item_buff_rd_en && ~dcache_lock && (vpu_state_int == VGATHER_INFLIGHT || (vpu_state_int == VSCATTER_INFLIGHT && ~st_buff_empty))) && (item_buff_rd_ptr + 1 == EPI_pkg::MASK_CREDITS)) begin
                item_buff_filled <= 0;
            end else begin

                //Write into the item buffer
                if ((mask_idx_vpu_cpu_int.mask_idx_valid && ((vpu_state_int == VGATHER_INFLIGHT) || (vpu_state_int == VSCATTER_INFLIGHT)) && item_buff_wr_en) && (item_buff_wr_ptr + 1 == EPI_pkg::MASK_CREDITS)) begin
                    item_buff_filled <= 1;
                end
            end
        end
    end
end

//multi_lane_wrapper #(.N_LANES (EPI_pkg::N_LANES), .CORE_INSTR(EPI_pkg::INSTR_WIDTH),
`ifdef ILM_SYNTHESIS
vpu_drac_wrapper
`else
vpu_drac_wrapper #(.N_LANES (EPI_pkg::N_LANES), .CORE_INSTR(EPI_pkg::INSTR_WIDTH),
                     .CORE_DATA (EPI_pkg::XREG_WIDTH), .DATA_WIDTH (EPI_pkg::DATA_PATH_WIDTH),
                     .COMMAND_WIDTH(EPI_pkg::UNPACK_WIDTH), .RNM_INSTR(EPI_pkg::RENAMING_WIDTH),
                     .MEM_Q_WIDTH(EPI_pkg::MEM_Q_WIDTH), .ARITH_Q_WIDTH(EPI_pkg::ARITH_Q_WIDTH)
                    )
`endif
    vpu_inst(
        .clk_i                  ( clk_i ),
        .rsn_i                  ( rstn_i ),
        .issue_valid_i          ( req_cpu_vpu_issue_int.valid ),
        .issue_instr_i          ( req_cpu_vpu_issue_int.inst ),
        .issue_data_i           ( req_cpu_vpu_issue_int.data ),
        .issue_sb_id_i          ( req_cpu_vpu_issue_int.sb_id ),
        .issue_csr_i            ( csr_vpu_data_i ),
        .issue_credit_o         ( vpu_cpu_credit_d ),
        .dispatch_sb_id_i       ( req_cpu_vpu_issue_int.sb_id ),
        .dispatch_nxt_sen_i     ( req_cpu_vpu_issue_int.valid ),
        .dispatch_kill_i        ( 1'b0 ),
        .completed_valid_o      ( resp_vpu_cpu_comp_d.valid ),
        .completed_sb_id_o      ( resp_vpu_cpu_comp_d.sb_id ),
        .completed_fflags_o     ( fflags_d ),
        .completed_vxsat_o      ( vxsat_d ),
        .completed_dst_reg_o    ( resp_vpu_cpu_comp_d.dst_reg_data ),
        .completed_vstart_o     ( resp_vpu_cpu_comp_d.vstart ),
        .completed_illegal_o    ( resp_vpu_cpu_comp_d.illegal_inst ),
        .memop_sync_start_o     ( memop_sync_start_vpu_cpu_d ),
        .memop_sync_end_i       ( memop_cpu_vpu_int.memop_sync_end ),
        .memop_sb_id_i          ( memop_cpu_vpu_int.memop_sb_id ),
        .memop_vstart_vlfof_i   ( memop_cpu_vpu_int.memop_vstart_vlfof ),
        .load_valid_i           ( load_cpu_vpu_int.load_valid ),
        .load_data_i            ( load_cpu_vpu_int.load_data ),
        .load_seq_id_i          ( load_cpu_vpu_int.load_seq_id ),
        .load_mask_valid_i      ( load_cpu_vpu_int.load_mask_valid ),
        .load_mask_i            ( load_cpu_vpu_int.load_mask ),
        .store_valid_o          ( store_vpu_cpu_d.store_valid ),
        .store_data_o           ( store_vpu_cpu_d.store_data ),
        .store_credit_i         ( store_credit_cpu_vpu ),
        .mask_idx_valid_o       ( mask_idx_vpu_cpu_d.mask_idx_valid ),
        .mask_idx_item_o        ( mask_idx_vpu_cpu_d.mask_idx_item ),
        .mask_idx_last_idx_o    ( mask_idx_vpu_cpu_d.mask_idx_last_idx ),
        .mask_idx_credit_i      ( mask_idx_credit_cpu_vpu ),
        .dbg_re_i               ( dbg_re_i                ),
        .dbg_we_i               ( dbg_we_i                ),
        .dbg_address_i          ( dbg_address_i           ),
        .dbg_read_data_o        ( dbg_read_data_d         ),
        .dbg_write_data_i       ( dbg_write_data_i        )
);

//This register serves the purpose of reducing the critical path
always_ff @(posedge clk_i or negedge rstn_i) begin
    if(~rstn_i) begin
        vpu_cpu_credit_int <= 0;
        resp_vpu_cpu_comp_int.valid <= 0;
        resp_vpu_cpu_comp_int.sb_id <= 0;
        resp_vpu_cpu_comp_int.dst_reg_data <= 0;
        resp_vpu_cpu_comp_int.vstart <= 0;
        resp_vpu_cpu_comp_int.illegal_inst <= 0;
        fflags_q <= 0;
        vxsat_q <= 0;
        memop_sync_start_vpu_cpu <= 0;
        store_vpu_cpu_int.store_valid <= 0;
        store_vpu_cpu_int.store_data <= 0;
        mask_idx_vpu_cpu_int.mask_idx_valid <= 0;
        mask_idx_vpu_cpu_int.mask_idx_item <= 0;
        mask_idx_vpu_cpu_int.mask_idx_last_idx <= 0;
        dbg_read_data_q <= 0;
    end else begin
        vpu_cpu_credit_int <= vpu_cpu_credit_d;
        resp_vpu_cpu_comp_int.valid <= resp_vpu_cpu_comp_d.valid;
        resp_vpu_cpu_comp_int.sb_id <= resp_vpu_cpu_comp_d.sb_id;
        resp_vpu_cpu_comp_int.dst_reg_data <= resp_vpu_cpu_comp_d.dst_reg_data;
        resp_vpu_cpu_comp_int.vstart <= resp_vpu_cpu_comp_d.vstart;
        resp_vpu_cpu_comp_int.illegal_inst <= resp_vpu_cpu_comp_d.illegal_inst;
        fflags_q <= fflags_d;
        vxsat_q <= vxsat_d;
        memop_sync_start_vpu_cpu <= memop_sync_start_vpu_cpu_d;
        store_vpu_cpu_int.store_valid <= store_vpu_cpu_d.store_valid;
        store_vpu_cpu_int.store_data <= store_vpu_cpu_d.store_data;
        mask_idx_vpu_cpu_int.mask_idx_valid <= mask_idx_vpu_cpu_d.mask_idx_valid;
        mask_idx_vpu_cpu_int.mask_idx_item <= mask_idx_vpu_cpu_d.mask_idx_item;
        mask_idx_vpu_cpu_int.mask_idx_last_idx <= mask_idx_vpu_cpu_d.mask_idx_last_idx;
        dbg_read_data_q <= dbg_read_data_d;
    end
end


	

assign valid_vec_csr_o = resp_vpu_cpu_comp_int.valid && !resp_vpu_cpu_comp_int.illegal_inst;
assign vpu_comp_o = resp_vpu_cpu_comp_int;
assign vpu_cpu_credit_o = vpu_cpu_credit_int;
assign fflags_o = fflags_q;
assign vxsat_o = vxsat_q;
assign dbg_read_data_o = dbg_read_data_q;

endmodule

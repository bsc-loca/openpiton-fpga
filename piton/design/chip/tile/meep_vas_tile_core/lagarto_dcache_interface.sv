//`default_nettype none
//`include "drac_pkg.sv"
import drac_pkg::*;

/* -----------------------------------------------
 * Project Name   : 
 * File           : 
 * Organization   : Barcelona Supercomputing Center
 * Author(s)      : Bachir Fradj
 * Email(s)       : bfradj@bsc.es
 * -----------------------------------------------
 * Revision History
 *  Revision   | Author     | Description
 *  0.1        | bfradj     |
 * -----------------------------------------------
 */
 
// Interface with Data Cache. Stores a Memory request until it finishes

module lagarto_dcache_interface (
    input  wire         clk_i,               // Clock
    input  wire         rstn_i,              // Negative Reset Signal
    // Request from Lagarto
    input req_cpu_dcache_t req_cpu_dcache_i, // Interface with cpu
    
    // From/Towards TLB
    input           dtlb_hit_i,
    input  [63:0]   paddr_i,
    output          mmu_req_o,
    output [63:0]   mmu_vaddr_o,
    output          mmu_store_o,
    output          mmu_load_o, 
    // Request towards Cacache_subsystemche
    output [DCACHE_INDEX_WIDTH-1:0]     ld_mem_req_addr_index_o  ,
    output [DCACHE_TAG_WIDTH-1:0]       ld_mem_req_addr_tag_o    ,
    output [63:0]                       ld_mem_req_wdata_o       ,
    output                              ld_mem_req_valid_o       ,
    output                              ld_mem_req_we_o          ,
    output [7:0]                        ld_mem_req_be_o          ,
    output [1:0]                        ld_mem_req_size_o        ,
    output                              ld_mem_req_kill_o        ,
    output                              ld_mem_req_tag_valid_o   ,
    output [DCACHE_INDEX_WIDTH-1:0]     st_mem_req_addr_index_o  ,
    output [DCACHE_TAG_WIDTH-1:0]       st_mem_req_addr_tag_o    ,
    output [63:0]                       st_mem_req_wdata_o       ,
    output                              st_mem_req_valid_o       ,
    output                              st_mem_req_we_o          ,
    output [7:0]                        st_mem_req_be_o          ,
    output [1:0]                        st_mem_req_size_o        ,
    output                              st_mem_req_kill_o        ,
    output                              st_mem_req_tag_valid_o   ,

    // DCACHE Answer
    input  bus64_t      dmem_resp_data_i,    // Readed data from Cache
    input  logic        dmem_resp_valid_i,   // Response is valid
    input  logic        dmem_resp_nack_i,    // Cache request not accepted
    input  logic        dmem_xcpt_ma_st_i,   // Missaligned store
    input  logic        dmem_xcpt_ma_ld_i,   // Missaligned load
    input  logic        dmem_xcpt_pf_st_i,   // DTLB miss on store
    input  logic        dmem_xcpt_pf_ld_i,   // DTLB miss on load

    // Response towards Lagarto
    output resp_dcache_cpu_t resp_dcache_cpu_o

);


logic is_load_instr;
logic is_store_instr;
logic kill_mem_ope;
logic mem_xcpt;
bus64_t dmem_req_addr_64;

wire st_translation_req ;
wire mem_req_valid      ;
wire str_rdy            ;
wire trns_ena           ;

wire dcache_lock;

parameter MEM_NOP   = 2'b00,
          MEM_LOAD  = 2'b01,
          MEM_STORE = 2'b10,
          MEM_AMO   = 2'b11;

logic [1:0] type_of_op;

// registers of tlb exceptions to not propagate the stall signal
logic dmem_xcpt_ma_st_reg;
logic dmem_xcpt_ma_ld_reg; 
logic dmem_xcpt_pf_st_reg;
logic dmem_xcpt_pf_ld_reg;


// ----------------------
// Extract Bytes from Op
// ----------------------

// There has been a exception
assign mem_xcpt = dmem_xcpt_ma_st_i | dmem_xcpt_ma_ld_i | dmem_xcpt_pf_st_i | dmem_xcpt_pf_ld_i;
assign kill_mem_ope = mem_xcpt | req_cpu_dcache_i.kill;

ld_st_FSM ld_st_FSM(
    .clk                  (clk_i                 ),
    .rst                  (rstn_i                ),
    .is_store_i           (is_store_instr        ),
    .is_load_i            (is_load_instr         ),
    .kill_mem_op_i        (kill_mem_ope          ),
    .ld_resp_valid_i      (dmem_resp_valid_i     ),
    .dtlb_hit_i           (dtlb_hit_i            ),
    .str_rdy_o            (str_rdy               ),
    .mem_req_valid_o      (mem_req_valid         ),
    .st_translation_req_o (st_translation_req    ),
    .trns_ena             (trns_ena              ),
    .dmem_lock_o          (dcache_lock           )    
    );


l1_dcache_adapter l1_dcache_adapter(
    .clk                      (clk_i                        ),
    .rst                      (rstn_i                       ),
    .is_store_i               (is_store_instr               ),
    .is_load_i                (is_load_instr                ),
    .vaddr_i                  (dmem_req_addr_64             ),   
    .paddr_i                  (paddr_i                      ),     
    .data_i                   (req_cpu_dcache_i.data_rs2    ),   
    .op_bits_type_i           (req_cpu_dcache_i.mem_size[1:0]),
    .dtlb_hit_i               (dtlb_hit_i                   ),    
    .st_translation_req_i     (st_translation_req           ),
    .mem_req_valid_i          (mem_req_valid                ),
    .str_rdy_i                (str_rdy                      ),
    .translation_req_o        (mmu_req_o                    ),   
    .vaddr_o                  (mmu_vaddr_o                  ),   
    .is_store_o               (mmu_store_o                  ),
    .is_load_o                (mmu_load_o                   ),
    .drain_nc                 (                             ),
    .trns_ena_i               (trns_ena                     ),
    .ld_mem_req_addr_index_o  (ld_mem_req_addr_index_o      ),
    .ld_mem_req_addr_tag_o    (ld_mem_req_addr_tag_o        ),
    .ld_mem_req_wdata_o       (ld_mem_req_wdata_o           ),
    .ld_mem_req_valid_o       (ld_mem_req_valid_o           ),
    .ld_mem_req_we_o          (ld_mem_req_we_o              ),
    .ld_mem_req_be_o          (ld_mem_req_be_o              ),
    .ld_mem_req_size_o        (ld_mem_req_size_o            ),
    .ld_mem_req_kill_o        (ld_mem_req_kill_o            ),
    .ld_mem_req_tag_valid_o   (ld_mem_req_tag_valid_o       ),
    .st_mem_req_addr_index_o  (st_mem_req_addr_index_o      ),
    .st_mem_req_addr_tag_o    (st_mem_req_addr_tag_o        ),
    .st_mem_req_wdata_o       (st_mem_req_wdata_o           ),
    .st_mem_req_valid_o       (st_mem_req_valid_o           ),
    .st_mem_req_we_o          (st_mem_req_we_o              ),
    .st_mem_req_be_o          (st_mem_req_be_o              ),
    .st_mem_req_size_o        (st_mem_req_size_o            ),
    .st_mem_req_kill_o        (st_mem_req_kill_o            ),
    .st_mem_req_tag_valid_o   (st_mem_req_tag_valid_o       )
);

//-------------------------------------------------------------
// STATE MACHINE LOGIC
//-------------------------------------------------------------
// UPDATE STATE
always@(posedge clk_i, negedge rstn_i) begin
    if(~rstn_i)begin
        dmem_xcpt_ma_st_reg <= 1'b0;
        dmem_xcpt_ma_ld_reg <= 1'b0; 
        dmem_xcpt_pf_st_reg <= 1'b0;
        dmem_xcpt_pf_ld_reg <= 1'b0;

    end else begin
        dmem_xcpt_ma_st_reg <= dmem_xcpt_ma_st_i;
        dmem_xcpt_ma_ld_reg <= dmem_xcpt_ma_ld_i; 
        dmem_xcpt_pf_st_reg <= dmem_xcpt_pf_st_i;
        dmem_xcpt_pf_ld_reg <= dmem_xcpt_pf_ld_i;
    end
end

// Decide type of memory operation
always_comb begin
    type_of_op      = MEM_NOP;
    case(req_cpu_dcache_i.instr_type)
        AMO_LRW,AMO_LRD:         begin
                                    type_of_op = MEM_AMO;
        end
        AMO_SCW,AMO_SCD:         begin
                                    type_of_op = MEM_AMO;
        end
        AMO_SWAPW,AMO_SWAPD:     begin
                                    type_of_op = MEM_AMO;
        end
        AMO_ADDW,AMO_ADDD:       begin
                                    type_of_op = MEM_AMO;
        end
        AMO_XORW,AMO_XORD:       begin
                                    type_of_op = MEM_AMO;
        end
        AMO_ANDW,AMO_ANDD:       begin
                                    type_of_op = MEM_AMO;
        end
        AMO_ORW,AMO_ORD:         begin
                                    type_of_op = MEM_AMO;
        end
        AMO_MINW,AMO_MIND:       begin
                                    type_of_op = MEM_AMO;
        end
        AMO_MAXW,AMO_MAXD:       begin
                                    type_of_op = MEM_AMO;
        end
        AMO_MINWU,AMO_MINDU:     begin
                                    type_of_op = MEM_AMO;
        end
        AMO_MAXWU,AMO_MAXDU:     begin  
                                    type_of_op = MEM_AMO;
        end
        LD,LW,LWU,LH,LHU,LB,LBU: begin
                                    type_of_op = MEM_LOAD;

        end
        SD,SW,SH,SB:             begin
                                    type_of_op = MEM_STORE;

        end
        default: begin
                            
                                    `ifdef ASSERTIONS
                                        // DOES NOT NEED ASSERTION
                                    `endif
        end
    endcase
end

assign is_store_instr = !req_cpu_dcache_i.kill & (type_of_op == MEM_STORE) & req_cpu_dcache_i.valid;
assign is_load_instr  = !req_cpu_dcache_i.kill & (type_of_op == MEM_LOAD)  & req_cpu_dcache_i.valid;

// Dcache interface is ready
assign resp_dcache_cpu_o.ready = dmem_resp_valid_i & (type_of_op != MEM_STORE);

// Readed data from load
assign resp_dcache_cpu_o.data = dmem_resp_data_i;
//Lock
assign resp_dcache_cpu_o.lock  = dcache_lock;
// Fill exceptions for exe stage
assign resp_dcache_cpu_o.xcpt_ma_st = dmem_xcpt_ma_st_reg;
assign resp_dcache_cpu_o.xcpt_ma_ld = dmem_xcpt_ma_ld_reg;
assign resp_dcache_cpu_o.xcpt_pf_st = dmem_xcpt_pf_st_reg;
assign resp_dcache_cpu_o.xcpt_pf_ld = dmem_xcpt_pf_ld_reg;

assign resp_dcache_cpu_o.addr       = dmem_req_addr_64;

endmodule

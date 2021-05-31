//`default_nettype none
//`include "drac_pkg.sv"
import drac_pkg::*;
import ariane_pkg::*;

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
    input  wire         clk_i   ,               // Clock
    input  wire         rstn_i  ,              // Negative Reset Signal
    // Request from Lagarto
    input req_cpu_dcache_t req_cpu_dcache_i, // Interface with cpu
    
    // From/Towards TLB
    input           dtlb_hit_i  ,
    input           dtlb_valid_i,
    input  [63:0]   paddr_i     ,
    output          mmu_req_o   ,
    output [63:0]   mmu_vaddr_o ,
    output          mmu_store_o ,
    output          mmu_load_o  , 
    // Request towards Cacache_subsystemche
        //Load
    output [DCACHE_INDEX_WIDTH-1:0]     ld_mem_req_addr_index_o  ,
    output [DCACHE_TAG_WIDTH-1:0]       ld_mem_req_addr_tag_o    ,
    output [63:0]                       ld_mem_req_wdata_o       ,
    output                              ld_mem_req_valid_o       ,
    output                              ld_mem_req_we_o          ,
    output [7:0]                        ld_mem_req_be_o          ,
    output [1:0]                        ld_mem_req_size_o        ,
    output                              ld_mem_req_kill_o        ,
    output                              ld_mem_req_tag_valid_o   ,
        //Store
    output [DCACHE_INDEX_WIDTH-1:0]     st_mem_req_addr_index_o  ,
    output [DCACHE_TAG_WIDTH-1:0]       st_mem_req_addr_tag_o    ,
    output [63:0]                       st_mem_req_wdata_o       ,
    output                              st_mem_req_valid_o       ,
    output                              st_mem_req_we_o          ,
    output [7:0]                        st_mem_req_be_o          ,
    output [1:0]                        st_mem_req_size_o        ,
    output                              st_mem_req_kill_o        ,
    output                              st_mem_req_tag_valid_o   ,
        //Atomic Req
    output logic    atm_mem_req_valid       ,       // this request is valid
    output amo_t    atm_mem_req_amo_op      ,       // atomic memory operation to perform
    output [1:0]    atm_mem_req_size        ,       // 2'b10 --> word operation, 2'b11 --> double word operation
    output [63:0]   atm_mem_req_operand_a   ,       // address
    output [63:0]   atm_mem_req_operand_b   ,    
        //Atomic Resp
    input           ack_atm_i           ,           // Response is valid
    input  bus64_t  dmem_resp_atm_data_i,           // result

    // DCACHE Answer
    input  bus64_t      dmem_resp_data_i,    // Readed data from Cache
    input  logic        dmem_resp_valid_i,   // Response is valid
    input  logic        dmem_resp_nack_i,    // Cache request not accepted
    input  logic        dmem_xcpt_ma_st_i,   // Missaligned store
    input  logic        dmem_xcpt_ma_ld_i,   // Missaligned load
    input  logic        dmem_xcpt_pf_st_i,   // DTLB miss on store
    input  logic        dmem_xcpt_pf_ld_i,   // DTLB miss on load

    input  logic        dmem_resp_gnt_st_i,   // DTLB miss on load

    // Response towards Lagarto
    output resp_dcache_cpu_t resp_dcache_cpu_o

);


logic is_load_instr ;
logic is_store_instr;
logic is_atm_instr  ;
logic kill_mem_ope  ;
logic mem_xcpt      ;

bus64_t dmem_req_addr_64    ;
reg[63:0] dmem_req_addr_reg ;

wire st_translation_req ;
wire mem_req_valid      ;
wire str_rdy            ;
wire trns_ena           ;

parameter MEM_NOP   = 2'b00,
          MEM_LOAD  = 2'b01,
          MEM_STORE = 2'b10,
          MEM_AMO   = 2'b11;

logic   [1:0] type_of_op        ;
reg     [1:0] type_of_op_reg    ;
amo_t   type_of_op_atm    ;
amo_t   type_of_op_atm_reg;

// registers of tlb exceptions to not propagate the stall signal
logic dmem_xcpt_ma_st_reg;
logic dmem_xcpt_ma_ld_reg; 
logic dmem_xcpt_pf_st_reg;
logic dmem_xcpt_pf_ld_reg;

//ATOMIC
logic [2:0] state_atm;

parameter ResetState    = 3'b000,
          Idle          = 3'b001,
          Transaction   = 3'b010,
          MakeRequest   = 3'b011,
          WaitResponse  = 3'b100;

logic atm_trans_req_valid   ;


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
    .st_resp_gnt_i        (dmem_resp_gnt_st_i    ),
    .dtlb_hit_i           (dtlb_hit_i            ),
    .str_rdy_o            (str_rdy               ),
    .mem_req_valid_o      (mem_req_valid         ),
    .st_translation_req_o (st_translation_req    ),
    .trns_ena             (trns_ena              )  
    );

assign dmem_req_addr_64 = (type_of_op == MEM_AMO) ? req_cpu_dcache_i.data_rs1 : req_cpu_dcache_i.data_rs1 + req_cpu_dcache_i.imm;

always @ (posedge clk_i) begin
    if (!rstn_i) dmem_req_addr_reg <= 64'b0;
    else if ( is_store_instr | is_load_instr ) dmem_req_addr_reg <=  dmem_req_addr_64;
    else dmem_req_addr_reg <= dmem_req_addr_reg;
end

always @ (posedge clk_i) begin
    if (!rstn_i) begin
        type_of_op_reg      <= 2'b0;
        type_of_op_atm_reg  <= AMO_NONE; 
    end else if ( !req_cpu_dcache_i.kill & req_cpu_dcache_i.valid ) begin
        type_of_op_reg      <=  type_of_op;
        type_of_op_atm_reg  <=  type_of_op_atm;

    end else begin 
        type_of_op_reg      <= type_of_op_reg;
        type_of_op_atm_reg  <= type_of_op_atm_reg;
    end
end

l1_dcache_adapter l1_dcache_adapter(
    .clk                      (clk_i                        ),
    .rst                      (rstn_i                       ),
    .is_store_i               (is_store_instr               ),
    .is_load_i                (is_load_instr                ),
    .is_op_atm_i              (is_atm_instr                 ),
    .vaddr_i                  (dmem_req_addr_64             ),   
    .paddr_i                  (paddr_i                      ),     
    .data_i                   (req_cpu_dcache_i.data_rs2    ),   
    .op_bits_type_i           (req_cpu_dcache_i.mem_size[1:0]),
    .dtlb_hit_i               (dtlb_hit_i                   ),    
    .st_translation_req_i     (st_translation_req           ),
    .st_translation_req_amt_i (atm_trans_req_valid          ), 
    .mem_req_valid_i          (mem_req_valid                ),
    .dmem_resp_gnt_st_i       (dmem_resp_gnt_st_i           ),
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
    type_of_op_atm  = AMO_NONE;
    case(req_cpu_dcache_i.instr_type)
        AMO_LRW,AMO_LRD:         begin
                                    type_of_op      = MEM_AMO;
                                    type_of_op_atm  = AMO_LR;
        end
        AMO_SCW,AMO_SCD:         begin
                                    type_of_op = MEM_AMO;
                                    type_of_op_atm  = AMO_SC;
        end
        AMO_SWAPW,AMO_SWAPD:     begin
                                    type_of_op = MEM_AMO;
                                    type_of_op_atm  = AMO_SWAP;
        end
        AMO_ADDW,AMO_ADDD:       begin
                                    type_of_op = MEM_AMO;
                                    type_of_op_atm  = AMO_ADD;
        end
        AMO_XORW,AMO_XORD:       begin
                                    type_of_op = MEM_AMO;
                                    type_of_op_atm  = AMO_XOR;
        end
        AMO_ANDW,AMO_ANDD:       begin
                                    type_of_op = MEM_AMO;
                                    type_of_op_atm  = AMO_AND;
        end
        AMO_ORW,AMO_ORD:         begin
                                    type_of_op = MEM_AMO;
                                    type_of_op_atm  = AMO_OR;
        end
        AMO_MINW,AMO_MIND:       begin
                                    type_of_op = MEM_AMO;
                                    type_of_op_atm  = AMO_MIN;
        end
        AMO_MAXW,AMO_MAXD:       begin
                                    type_of_op = MEM_AMO;
                                    type_of_op_atm  = AMO_MAX;
        end
        AMO_MINWU,AMO_MINDU:     begin
                                    type_of_op = MEM_AMO;
                                    type_of_op_atm  = AMO_MINU;
        end
        AMO_MAXWU,AMO_MAXDU:     begin  
                                    type_of_op = MEM_AMO;
                                    type_of_op_atm  = AMO_MAXU;
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
assign is_atm_instr   = !req_cpu_dcache_i.kill & (type_of_op == MEM_AMO)   & req_cpu_dcache_i.valid;
//ATOMIC
always @ (posedge clk_i) begin
    case(state_atm)
        // IN RESET STATE
        ResetState: begin
            atm_mem_req_valid   = 1'b0;  // NO request
            atm_trans_req_valid = 1'b0;
            state_atm           = Idle;        // Next state IDLE
        end
        // IN IDLE STATE
        Idle: begin
            atm_trans_req_valid = is_atm_instr;
            atm_mem_req_valid   = 1'b0;

            state_atm           = is_atm_instr ?  Transaction : req_cpu_dcache_i.kill ? ResetState : Idle;
        end

        Transaction: begin
            if ( dtlb_valid_i ) begin
                atm_trans_req_valid = 1'b0;
                atm_mem_req_valid   = (!kill_mem_ope)  ? 1'b1 : 1'b0;
                state_atm           = (!kill_mem_ope)  ? MakeRequest : ResetState;

            end
            else begin
                atm_trans_req_valid = 1'b0;
                atm_mem_req_valid   = 1'b0;
                state_atm           = Transaction;
            end
        end
        // IN MAKE REQUEST STATE
        MakeRequest: begin
                atm_mem_req_valid   = 1'b0;
                state_atm           = (!kill_mem_ope) ? WaitResponse : ResetState ;
            //end
        end
        // IN WAIT RESPONSE STATE
        WaitResponse: begin
            if(ack_atm_i) begin
                atm_mem_req_valid   = 1'b0;
                state_atm           = Idle;
            end else begin
                atm_mem_req_valid   = (!kill_mem_ope)  ? 1'b1 : 1'b0;
                state_atm           = kill_mem_ope? ResetState : WaitResponse;
            end
        end
    endcase
    if(~rstn_i) begin
        state_atm           = ResetState; 
        atm_mem_req_valid   = 1'b0;
        atm_trans_req_valid = 1'b0;
    end 
end

assign atm_mem_req_amo_op       = type_of_op_atm_reg        ;
assign atm_mem_req_size         = st_mem_req_size_o         ; // or ld_mem_req_size_o, same 
assign atm_mem_req_operand_a    = paddr_i                   ;
assign atm_mem_req_operand_b    = req_cpu_dcache_i.data_rs2 ;

// Dcache interface is ready
assign resp_dcache_cpu_o.ready  = (type_of_op_reg == MEM_LOAD) ? dmem_resp_valid_i : ack_atm_i;

// Readed data from load
assign resp_dcache_cpu_o.data   = (type_of_op_reg == MEM_LOAD) ? dmem_resp_data_i : dmem_resp_atm_data_i;

//Lock
always_comb begin
    if ( kill_mem_ope       | dmem_resp_valid_i | 
         dmem_resp_gnt_st_i | ack_atm_i         )   resp_dcache_cpu_o.lock <= 1'b0;    
    else                                            resp_dcache_cpu_o.lock <= req_cpu_dcache_i.valid;
end
// Fill exceptions for exe stage
assign resp_dcache_cpu_o.xcpt_ma_st = dmem_xcpt_ma_st_reg;
assign resp_dcache_cpu_o.xcpt_ma_ld = dmem_xcpt_ma_ld_reg;
assign resp_dcache_cpu_o.xcpt_pf_st = dmem_xcpt_pf_st_reg;
assign resp_dcache_cpu_o.xcpt_pf_ld = dmem_xcpt_pf_ld_reg;

assign resp_dcache_cpu_o.addr       = dmem_req_addr_reg;

endmodule
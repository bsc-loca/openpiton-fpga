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
    
    //From TLB
    input           dtlb_hit_i,
    input  [63:0]   paddr_i,
    // Request from Lagarto
    input req_cpu_dcache_t req_cpu_dcache_i, // Interface with cpu
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

    // Response from cache_subsystem
    input         ld_resp_valid_i
    // Response towards Lagarto

);


logic is_load_instr;
logic is_store_instr;

wire st_translation_req ;
wire mem_req_valid      ;
wire str_rdy            ;
wire trns_ena           ;





always_comb begin
    is_load_instr = 0;
    is_store_instr = 0;

    case(req_cpu_dcache_i.instr_type)
        LD,LW,LWU,LH,LHU,LB,LBU: begin
            is_load_instr = 1'b1; // Load
        end

        SD,SW,SH,SB:             begin
            is_store_instr = 1'b1; // store

        end

        default: begin
            is_load_instr  = 0;
            is_store_instr = 0;
        end
    endcase
end



// ld_st_FSM ld_st_FSM(
//     .clk                  (clk_i                 ),
//     .rst                  (rstn_i                ),
//     .is_store_i           (is_sotre_instr        ),
//     .is_load_i            (is_load_instr         ),
//     .kill_mem_op_i        (req_cpu_dcache_i.kill ),
//     .ld_resp_valid_i      (ld_resp_valid_i       ),
//     .dtlb_hit_i           (dtlb_hit_i            ),
//     .str_rdy_o            (str_rdy               ),
//     .mem_req_valid_o      (mem_req_valid         ),
//     .st_translation_req_o (st_translation_req    ),
//     .trns_ena             (trns_ena              ),
//     .dmem_lock_o          (                      )    
//     );


// l1_dcache_adapter l1_dcache_adapter(
//     .clk                      (clk_i                         ),
//     .rst                      (rstn_i                        ),
//     .is_store_i               (is_sotre_instr                ),
//     .is_load_i                (is_load_instr                 ),
//     .vaddr_i                  (req_cpu_dcache_i.io_base_addr ),   
//     .paddr_i                  (paddr_i                       ),     
//     .data_i                   (req_cpu_dcache_i.imm          ),   
//     .op_bits_type_i           (req_cpu_dcache_i.instr_type   ),
//     .dtlb_hit_i               (dtlb_hit_i                    ),    
//     .st_translation_req_i     (st_translation_req            ),
//     .mem_req_valid_i          (mem_req_valid                 ),
//     .str_rdy_i                (str_rdy                       ),
//     .translation_req_o        (                          ),   
//     .vaddr_o                  (                          ),   
//     .is_store_o               (                          ),
//     .is_load_o                (                          ),
//     .drain_nc                 (                          ),
//     .trns_ena_i               (trns_ena                  ),
//     .ld_mem_req_addr_index_o  (ld_mem_req_addr_index_o   ),
//     .ld_mem_req_addr_tag_o    (ld_mem_req_addr_tag_o     ),
//     .ld_mem_req_wdata_o       (ld_mem_req_wdata_o        ),
//     .ld_mem_req_valid_o       (ld_mem_req_valid_o        ),
//     .ld_mem_req_we_o          (ld_mem_req_we_o           ),
//     .ld_mem_req_be_o          (ld_mem_req_be_o           ),
//     .ld_mem_req_size_o        (ld_mem_req_size_o         ),
//     .ld_mem_req_kill_o        (ld_mem_req_kill_o         ),
//     .ld_mem_req_tag_valid_o   (ld_mem_req_tag_valid_o    ),
//     .st_mem_req_addr_index_o  (st_mem_req_addr_index_o   ),
//     .st_mem_req_addr_tag_o    (st_mem_req_addr_tag_o     ),
//     .st_mem_req_wdata_o       (st_mem_req_wdata_o        ),
//     .st_mem_req_valid_o       (st_mem_req_valid_o        ),
//     .st_mem_req_we_o          (st_mem_req_we_o           ),
//     .st_mem_req_be_o          (st_mem_req_be_o           ),
//     .st_mem_req_size_o        (st_mem_req_size_o         ),
//     .st_mem_req_kill_o        (st_mem_req_kill_o         ),
//     .st_mem_req_tag_valid_o   (st_mem_req_tag_valid_o    )
// );

endmodule

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

    input req_cpu_dcache_t req_cpu_dcache_i, // Interface with cpu



    // Request TO DCACHE
    output [DCACHE_INDEX_WIDTH-1:0]   ld_mem_req_addr_index_o  ,
    output [DCACHE_TAG_WIDTH-1:0]     ld_mem_req_addr_tag_o    ,
    output [63:0]                     ld_mem_req_wdata_o       ,
    output                            ld_mem_req_valid_o       ,
    output                            ld_mem_req_we_o          ,
    output [7:0]                      ld_mem_req_be_o          ,
    output [1:0]                      ld_mem_req_size_o        ,
    output                            ld_mem_req_kill_o        ,
    output                            ld_mem_req_tag_valid_o   ,
    output [DCACHE_INDEX_WIDTH-1:0]   st_mem_req_addr_index_o  ,
    output [DCACHE_TAG_WIDTH-1:0]     st_mem_req_addr_tag_o    ,
    output [63:0]                     st_mem_req_wdata_o       ,
    output                            st_mem_req_valid_o       ,
    output                            st_mem_req_we_o          ,
    output [7:0]                      st_mem_req_be_o          ,
    output [1:0]                      st_mem_req_size_o        ,
    output                            st_mem_req_kill_o        ,
    output                            st_mem_req_tag_valid_o   
);


endmodule

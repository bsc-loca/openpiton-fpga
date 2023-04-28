/* -----------------------------------------------------------
* Project Name  : MEEP
* Organization  : Barcelona Supercomputing Center
* Email         : zeeshan.ali@bsc.es-
* Description   : To code uArchitectural functional coverpoints and cover properties
                : for backend of the core (exu/lsu, wb/commit/CSR stages)
* ------------------------------------------------------------*/

import drac_pkg::*;
import riscv_pkg::*;

module cov_backend (
    input logic                 clk_i,
    input logic                 rsn_i
    );

    localparam WINDOW_SIZE  = 5;
    localparam SV39_VA_SIZE = 39;

    /* ----- Declare internal signals & develop internal logic for coverage here -----*/ 
    logic canonical_violation;
    riscv_pkg::exception_cause_t be_exception_cause;
    logic be_exception_valid;



    /* ----- Declare coverage MACROS here -----*/ 

    // macro to check whether two events collide each other with the given clock cycles difference
    `define event1_collides_event2(sig1, sig2, cycle_diff) \
    property ``sig1``_collides_``sig2``_p; \
        @(negedge clk_i) disable iff(~rsn_i) \
        ``sig1`` |-> ##``cycle_diff`` ``sig2``; \
    endproperty \
    cover property(``sig1``_collides_``sig2``_p);
    
    /* ----- Declare cover properties here -----*/ 
    generate
        begin: lsu_cover_properties
            begin: reset_collides_clock
                for (genvar i=0; i<WINDOW_SIZE; i++) begin: reset_collides_clock
                    `event1_collides_event2(rsn_i, clk_i, i)
                end
            end
        end: lsu_cover_properties
    endgenerate

    /* ----- Declare cover groups here -----*/
    covergroup backend_exceptions_cg;

    endgroup: backend_exceptions_cg
    backend_exceptions_cg backend_exceptions_cg_inst;

    /* ----- Instantiate cover groups here -----*/
    initial
    begin
        backend_exceptions_cg_inst = new();
    end

    /* ----- Sample cover groups here -----*/
    always @ (negedge clk_i)
    begin
        backend_exceptions_cg_inst.sample();
    end

endmodule

// bind lagarto_m20 cov_backend coverage_backend (
//     .clk_i(core_ref_clk),
//     .rsn_i(sys_rst_n)
// );
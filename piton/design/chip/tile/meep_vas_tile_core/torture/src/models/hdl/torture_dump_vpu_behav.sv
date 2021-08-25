// Module used to dump information comming from writeback stage
module torture_dump_vpu_behav
(
// General input
input clk, rst,
// Control Input
input completed_valid,
input completed_illegal,
// Attributes input
input [VADDR_WIDTH-1:0] vreg_dst,
input [LVADDR_WIDTH-1:0] lreg_dst,
input [CSR_VSEW_WIDTH-1:0] sew,
input [CSR_VLEN_WIDTH-1:0] vlen,
input widening,
input reduction,
input reduction_wi,
input [SB_WIDTH-1:0] sb_id,
// Data input
input [N_LANES-1:0] [N_BANKS-1:0] [7:0] [VRF_DEPTH-1:0] [VRF_ADDR-1:0] lanes
);

typedef struct {
	logic [N_LANES-1:0][N_BANKS-1:0][7:0][(2*VRF_DEPTH)-1:0][VRF_ADDR-1:0] lanes;
} dpi_param_t;

// DPI calls definition
import "DPI-C" function
 void torture_dump_vpu (input longint unsigned completed_valid, input longint unsigned completed_illegal, input longint unsigned vreg_dst, input longint unsigned lreg_dst, input longint unsigned sew, input longint unsigned vlen, input longint unsigned widening, input longint unsigned reduction, input longint unsigned reduction_wi, input longint unsigned sb_id, inout dpi_param_t dpi_param);
import "DPI-C" function void torture_signature_init_vpu();

// we create the behav model to control it
`ifndef VERILATOR
initial begin
  torture_signature_init_vpu();
  clear_output_vpu();
end
`endif

// Main always
always @(posedge clk) begin
    dpi_param_t dpi_param;
    dpi_param.lanes = lanes;
    if(completed_valid)
        torture_dump_vpu(completed_valid, completed_illegal, vreg_dst, lreg_dst, sew, vlen, widening, reduction, reduction_wi, sb_id, dpi_param);
end

endmodule

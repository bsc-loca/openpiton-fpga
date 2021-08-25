// Module used to dump information comming from writeback stage
module torture_dump_behav
(
// General input
input	clk, rst,
// Control Input
input	commit_valid,
input	reg_wr_valid,
// Data Input
input [63:0] pc, inst, reg_dst, data,
// Exception Input
input   xcpt,
input [63:0] xcpt_cause,
input [1:0] csr_priv_lvl,
input [63:0] csr_rw_data,
input   csr_xcpt,
input [63:0] csr_xcpt_cause,
input [63:0] csr_tval,
input vpu_completed
);

// DPI calls definition
import "DPI-C" function
 void torture_dump (input longint unsigned PC, input longint unsigned inst, input longint unsigned dst, input longint unsigned reg_wr_valid, input longint unsigned data, input longint unsigned xcpt, input longint unsigned xcpt_cause, input longint unsigned csr_priv_lvl_next, input longint unsigned csr_xcpt, input longint unsigned csr_xcpt_cause, input longint unsigned csr_tval, input longint unsigned vpu_completed);
import "DPI-C" function void torture_signature_init();

// we create the behav model to control it
`ifndef VERILATOR
initial begin
  torture_signature_init();
  //clear_output();
end
`endif

// Main always
always @(posedge clk) begin
	if(commit_valid)
		torture_dump(pc[39:0], inst, reg_dst, reg_wr_valid, data, xcpt, xcpt_cause, csr_priv_lvl, csr_xcpt, csr_xcpt_cause, csr_tval, vpu_completed);
end

endmodule

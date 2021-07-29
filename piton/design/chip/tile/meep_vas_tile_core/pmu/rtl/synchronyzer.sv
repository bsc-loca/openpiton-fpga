
module synchronyzer_2_stage (
    input in, clk,
    output out
);

logic stage1, stage2;

always_ff @(posedge clk ) begin
    stage1 <= in;
    stage2 <= stage1;
end

assign out = stage2;
    
endmodule
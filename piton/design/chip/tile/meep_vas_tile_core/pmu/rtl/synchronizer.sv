// Title      : synchronizer_2_stage
// Project    : MEEP
// License    : <License type>
/*****************************************************************************/
// File        : synchronizer.sv
// Author      : Pablo Criado Albillos; pablo.criado@bsc.es
// Company     : Barcelona Supercomputing Center (BSC)
// Created     : 28/07/2021
// Last update : 30/07/2021
/*****************************************************************************/
// Description: 2 stage synchronizer for OpenPiton PMU
//
// Comments    :
/*****************************************************************************/
// Copyright (c) 2021 BSC
/*****************************************************************************/
// Revisions  :
// Date/Time                Version               Engineer
// 28/07/2021               1.0                   pablo.criado@bsc.es
// Comments   : Initial implementation
/*****************************************************************************/


module synchronizer_2_stage (
    input  in,
    clk,
    output out
);

  logic stage1, stage2;

  always_ff @(posedge clk) begin
    stage1 <= in;
    stage2 <= stage1;
  end

  assign out = stage2;

endmodule

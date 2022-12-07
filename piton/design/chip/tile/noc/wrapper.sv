
    
    
/****************************************************************************
 * wrapper.sv
 ****************************************************************************/

  
  
  
/**
 * Module: pronoc_to_piton_wrapper
 * 
 * TODO: Add module documentation
 */
`timescale      1ns/1ps

`include "define.tmp.h"
 
`define PRESERVED_DATw (`MSG_LENGTH_WIDTH + `MSG_TYPE_WIDTH + `MSG_MSHRID_WIDTH + `MSG_OPTIONS_1_WIDTH )
`define HEAD_DATw  (FPAYw-MSB_BE-1) 
`define ADDR_CODED (`HEAD_DATw-`PRESERVED_DATw)

module piton_to_pronoc_endp_addr_converter 
	import pronoc_pkg::*; 
#(
	parameter CHIP_SET_PORT = 3
)	
(
	default_chipid_i,
	piton_chipid_i,
	piton_coreid_x_i,
	piton_coreid_y_i,
		
	pronoc_endp_addr_o,
	piton_end_addr_coded_o
);
	
	input  [`NOC_CHIPID_WIDTH-1:0]  default_chipid_i;
	input  [`NOC_CHIPID_WIDTH-1:0]  piton_chipid_i;
	input  [`NOC_X_WIDTH-1:0]       piton_coreid_x_i;
	input  [`NOC_Y_WIDTH-1:0]       piton_coreid_y_i;
	
	
	output reg [EAw-1 : 0] pronoc_endp_addr_o;
	output reg    [`ADDR_CODED-1 : 0] piton_end_addr_coded_o;
	
	//coded for FMESH topology
	generate 
	
	localparam
		NX = T1,
		NY = T2,
		Xw = log2(NX),    // number of node in x axis
		Yw = log2(NY);    // number of node in y axis
	if(TOPOLOGY == "FMESH") begin 
		always @ (*) begin 
			pronoc_endp_addr_o = {EAw{1'b0}};
			if(piton_chipid_i == default_chipid_i ) begin 
				pronoc_endp_addr_o [Yw+Xw-1 : 0] =  {piton_coreid_y_i[Yw-1 : 0],  piton_coreid_x_i[Xw-1 : 0]};
			end else begin //send it to next chip
				pronoc_endp_addr_o [EAw-1 : Yw+Xw] =  CHIP_SET_PORT;  // router 0,0 west port; 
			end
		end	
	end else begin //"mesh" 
		always @ (*) begin 
			pronoc_endp_addr_o = {EAw{1'b0}};
			pronoc_endp_addr_o [Yw+Xw-1 : 0] =  {piton_coreid_y_i[Yw-1 : 0],  piton_coreid_x_i[Xw-1 : 0]};			
		end	
	end
	endgenerate

	always @ (*) begin 
		piton_end_addr_coded_o = {`ADDR_CODED{1'b0}};
		piton_end_addr_coded_o [Yw+Xw-1 : 0] =   {piton_coreid_y_i[Yw-1 : 0],  piton_coreid_x_i[Xw-1 : 0]};
		if(piton_chipid_i == 8192 ) begin 
			piton_end_addr_coded_o[`ADDR_CODED-1]=1'b1;
		end// TODO need to know how chip id coded from zero to max or from 8192 to zero
	end	
	
	
endmodule	


module pronoc_to_piton_endp_addr_converter 
 	import pronoc_pkg::*; 
(
	piton_end_addr_coded_i,	
	
	piton_chipid_o,
	piton_coreid_x_o,
	piton_coreid_y_o
	
);
//coded for FMESH topology
localparam
	NX = T1,
	NY = T2,
	Xw = log2(NX),    // number of node in x axis
	Yw = log2(NY);    // number of node in y axis

output  [`NOC_CHIPID_WIDTH-1:0]  piton_chipid_o;
output  reg [`NOC_X_WIDTH-1:0]   piton_coreid_x_o;
output  reg [`NOC_Y_WIDTH-1:0]   piton_coreid_y_o;
	
input   [`ADDR_CODED-1 : 0] piton_end_addr_coded_i;


	always @(*)begin 
		piton_coreid_x_o = {`MSG_DST_X_WIDTH{1'b0}}; 
		piton_coreid_y_o = {`MSG_DST_Y_WIDTH{1'b0}}; 
		{piton_coreid_y_o[Yw-1 : 0],  piton_coreid_x_o[Xw-1 : 0]}=piton_end_addr_coded_i [Yw+Xw-1 : 0];
	end
	//TODO regen chip ID 
	assign piton_chipid_o = (piton_end_addr_coded_i[`ADDR_CODED-1]==1'b1)? 8192 : 0;
	
endmodule



module piton_to_pronoc_wrapper 
	import pronoc_pkg::*; 
	#(
	parameter NOC_NUM=1,
	parameter TILE_NUM =0,
	parameter CHIP_SET_PORT = 3,
	parameter FLATID_WIDTH=8
	)(
	default_chipid,  default_coreid_x, default_coreid_y, flat_tileid,	
	reset, clk,
	dataIn, validIn, yummyIn,
	current_r_addr_i,
	chan_out
	);	
	//piton 
	input  [`NOC_CHIPID_WIDTH-1:0]  default_chipid;
	input  [`NOC_X_WIDTH-1:0]       default_coreid_x;
	input  [`NOC_Y_WIDTH-1:0]       default_coreid_y;
	input  [FLATID_WIDTH-1:0] flat_tileid;
	
	input [`NOC_DATA_WIDTH-1:0]         dataIn;
	input                               validIn;
	input                               yummyIn;
	
	//pronoc
	input [RAw-1 : 0] current_r_addr_i;
	output  smartflit_chanel_t chan_out; 
	
	input reset,clk;
	
	enum bit [1:0] {HEADER, BODY,TAIL} flit_type,flit_type_next;
	
	
	
	wire [`MSG_DST_CHIPID_WIDTH-1   :0] dest_chipid = dataIn [ `MSG_DST_CHIPID];
	wire [`MSG_DST_X_WIDTH-1        :0] dest_x      = dataIn [ `MSG_DST_X];
	wire [`MSG_DST_Y_WIDTH-1        :0] dest_y      = dataIn [ `MSG_DST_Y];
	wire [`MSG_DST_FBITS_WIDTH-1    :0] dest_fbits  = dataIn [ `MSG_DST_FBITS];
	wire [`MSG_LENGTH_WIDTH-1       :0] length      = dataIn [ `MSG_LENGTH ];
	wire [`MSG_TYPE_WIDTH-1         :0] msg_type    = dataIn [ `MSG_TYPE ]; 
	wire [`MSG_MSHRID_WIDTH-1       :0] mshrid      = dataIn [ `MSG_MSHRID ];
	wire [`MSG_OPTIONS_1_WIDTH-1    :0] option1     = dataIn [ `MSG_OPTIONS_1];
	
	reg [`MSG_LENGTH_WIDTH-1       :0] counter, counter_next;
	reg tail,head;
	
	always @ (*) begin 
		counter_next = counter;
		flit_type_next =flit_type;
		tail=1'b0;
		head=1'b0;
		if(validIn)begin 
			case(flit_type) 
				HEADER:begin 
					counter_next = length;
					head=1'b1;
					if(length == 0)begin
						tail=1'b1;
					end else if (length == 1) begin 
						flit_type_next = TAIL;
					end else begin 
						flit_type_next = BODY;
					end 
				end
				BODY: begin 
					counter_next = counter -1'b1;
					if(counter == 2) begin 
						flit_type_next = TAIL;
					end
				end
				TAIL: begin 
					flit_type_next = HEADER;
					tail=1'b1;
				end
			endcase
				
		end
	end
	
	always @ (posedge clk) begin 
		if(reset) begin 
			flit_type<=HEADER;
			counter<=0;
		end else begin 
			flit_type<=flit_type_next;
			counter<=counter_next;
		end
	end
	
	wire [EAw-1 : 0] src_e_addr, dest_e_addr;
	wire [DSTPw-1 : 0] destport;
	wire [`ADDR_CODED-1 : 0] dest_coded;
	
	piton_to_pronoc_endp_addr_converter #(.CHIP_SET_PORT(CHIP_SET_PORT)) src_conv (
		.default_chipid_i  (default_chipid),
		.piton_chipid_i    (default_chipid),
		.piton_coreid_x_i  (default_coreid_x),
		.piton_coreid_y_i  (default_coreid_y),
	    
		.pronoc_endp_addr_o (src_e_addr),
		.piton_end_addr_coded_o()
		
	);	
	
	piton_to_pronoc_endp_addr_converter dst_conv (
		.default_chipid_i  (default_chipid),
		.piton_chipid_i    (dest_chipid),
		.piton_coreid_x_i  (dest_x),
		.piton_coreid_y_i  (dest_y),	    
		.pronoc_endp_addr_o (dest_e_addr),
		.piton_end_addr_coded_o(dest_coded)
		
	);	
		
	
	
	conventional_routing #(
			.TOPOLOGY(TOPOLOGY),
			.ROUTE_NAME(ROUTE_NAME),
			.ROUTE_TYPE(ROUTE_TYPE),
			.T1(T1),
			.T2(T2),
			.T3(T3),
			.RAw(RAw),
			.EAw(EAw),
			.DSTPw(DSTPw),
			.LOCATED_IN_NI(1)
		)
		routing_module
		(
			.reset(reset),
			.clk(clk),
			.current_r_addr(current_r_addr_i),
			.dest_e_addr(dest_e_addr),
			.src_e_addr(src_e_addr),
			.destport(destport)
		);
	
			
	
	//endp_addr_decoder  #( .TOPOLOGY(TOPOLOGY), .T1(T1), .T2(T2), .T3(T3), .EAw(EAw),  .NE(NE)) decod1 ( .id(TILE_NUM), .code(current_e_addr));
	
	
		
	
	wire [`HEAD_DATw-1 : 0] head_data= {dest_coded ,length, msg_type,  mshrid,option1}; 
	
	wire [Fw-1 : 0] header_flit;
	reg [WEIGHTw-1 : 0] win;
	
	always @(*) begin 
		win={WEIGHTw{1'b0}};
		win[0]=1'b1;
	end
	
	
	
	header_flit_generator	#(
		.DATA_w(`HEAD_DATw) // header flit can carry Optional data. The data will be placed after control data.  Fpay >= DATA_w + CTRL_BITS_w  
   	)head_gen(
    	.flit_out(header_flit),    
		.src_e_addr_in(src_e_addr),
		.dest_e_addr_in(dest_e_addr),
		.destport_in(destport),
		.class_in(1'b0),
		.weight_in(win), 
		.vc_num_in(1'b1),
		.be_in(1'b0),
		.data_in(head_data)    
	);
	
	assign chan_out.ctrl_chanel.credit_init_val = 4;
	
	assign chan_out.flit_chanel.flit.hdr_flag =head;
	assign chan_out.flit_chanel.flit.tail_flag=tail;
	assign chan_out.flit_chanel.flit.vc=1'b1;
	assign chan_out.flit_chanel.flit_wr=validIn;
	assign chan_out.flit_chanel.credit=yummyIn;
	assign chan_out.flit_chanel.flit.payload = (flit_type==	HEADER)? header_flit[Fpay-1 : 0] : dataIn;
	assign chan_out.smart_chanel = {SMART_CHANEL_w{1'b0}};
	assign chan_out.flit_chanel.congestion = {CONGw{1'b0}};
	
	/*
	always @ (posedge clk) begin 
		if(validIn==1'b1 && flit_type==	HEADER)begin 
			$display("%t***Tile %d ***NoC %d************payload length =%d*************************",$time,TILE_NUM,NOC_NUM,length);
			$display("%t*** src (c=%d,x=%d,y=%d) sends to dst (c=%d,x=%d,y=%d chan_out=%x)",$time,
					default_chipid, default_coreid_x, default_coreid_y, dest_chipid,dest_x,dest_y,chan_out);
//$finish;
		end
	end
	*/
	/*
	//synthesis translate_off
	reg [7: 0] yy;
	initial begin //make sure address decoding match between ProNoC and Openpiton 
		#100
		yy = (TILE_NUM / `X_TILES )%`Y_TILES ;
		if((default_coreid_y != yy ) || 
		(default_coreid_x != (TILE_NUM % `X_TILES ))) begin 
		$display ("ERROR: Address missmatch! ");
		$finish;
		end		
	end
	//synthesis translate_on
	*/
endmodule
/********************************
 * 		pronoc_to_piton_wrapper  
 * ***************************/



module pronoc_to_piton_wrapper 
		import pronoc_pkg::*; 
#(
	parameter NOC_NUM=1,
	parameter PORT_NUM=0,
	parameter TILE_NUM =0,
	parameter FLATID_WIDTH=8
)(
	default_chipid,  default_coreid_x, default_coreid_y, flat_tileid,	
	reset, clk,
	dataOut, validOut, yummyOut,
	current_r_addr_o,
	chan_in
);	
	//piton out
	input  [`NOC_CHIPID_WIDTH-1:0]  default_chipid;
	input  [`NOC_X_WIDTH-1:0]       default_coreid_x;
	input  [`NOC_Y_WIDTH-1:0]       default_coreid_y;
	input  [FLATID_WIDTH-1:0] flat_tileid;
	
	output [`NOC_DATA_WIDTH-1:0]        dataOut;
	output                              validOut;
	output                              yummyOut;
	
	output [RAw-1 : 0] current_r_addr_o;
	
	//pronoc in
	input  smartflit_chanel_t chan_in; 
	
	input reset,clk;
	
	
	assign current_r_addr_o = chan_in.ctrl_chanel.neighbors_r_addr;
	
	
	localparam
		NX = T1,
		NY = T2,
		Xw = log2(NX),    // number of node in x axis
		Yw = log2(NY);    // number of node in y axis
	
	
	enum bit [1:0] {HEADER, BODY,TAIL} flit_type,flit_type_next;
	
	hdr_flit_t hdr_flit;
	wire [`HEAD_DATw-1 : 0] head_dat;

	//extract ProNoC header flit data
	header_flit_info #(
		.DATA_w(`HEAD_DATw)
	)extract(
		.flit(chan_in.flit_chanel.flit),
		.hdr_flit(hdr_flit),		
		.data_o(head_dat)    
	);
	
	wire [`NOC_DATA_WIDTH-1:0] header_flit;
	
	wire [`MSG_DST_CHIPID_WIDTH-1   :0] dest_chipid;
	reg  [`MSG_DST_X_WIDTH-1        :0] dest_x     ;
	reg  [`MSG_DST_Y_WIDTH-1        :0] dest_y     ;
	wire [`MSG_DST_FBITS_WIDTH-1    :0] dest_fbits ;
	wire [`MSG_LENGTH_WIDTH-1       :0] length     ;
	wire [`MSG_TYPE_WIDTH-1         :0] msg_type   ;
	wire [`MSG_MSHRID_WIDTH-1       :0] mshrid     ;
	wire [`MSG_OPTIONS_1_WIDTH-1    :0] option1    ;
	
	wire [`ADDR_CODED-1 : 0] dest_coded;
	
	assign {dest_coded, length, msg_type, mshrid, option1}  =	 head_dat; 
	
	pronoc_to_piton_endp_addr_converter addr_conv ( 
		.piton_end_addr_coded_i(dest_coded),		
		.piton_chipid_o (dest_chipid),
		.piton_coreid_x_o(dest_x),
		.piton_coreid_y_o(dest_y)	
	);
		                                               
	
	
	
	
	wire [MAX_P-1:0] destport_one_hot;
	
	
	//	FBITS coding
	localparam [3: 0] 
		FBITS_WEST		 =  4'b0010, 
		FBITS_SOUTH      =  4'b0011,   
		FBITS_EAST       =  4'b0100,   
		FBITS_NORTH      =  4'b0101,   
		FBITS_PROCESSOR  =  4'b0000;  
	/*	
		ProNoC destination port order num
	    LOCAL   =   0
	    EAST    =   1
        NORTH   =   2 
        WEST    =   3
        SOUTH   =   4		 
	*/	
		
	//assign dest_fbits =		(PORT_NUM==0) ? 4'b0000:4'b0010;//offchip	
	
	/*
	always @(posedge clk) begin
		if(validOut) begin 
			$display("********************************************destport_one_hot=%b; dest_fbits=%b",destport_one_hot,dest_fbits);
			$finish;
		end
	end
	*/
	
	assign dest_fbits = 
		(destport_one_hot [LOCAL]) ? FBITS_PROCESSOR:
		(destport_one_hot [EAST ]) ? FBITS_EAST:
		(destport_one_hot [NORTH]) ? FBITS_NORTH:
		(destport_one_hot [WEST ]) ? FBITS_WEST:
		FBITS_SOUTH;
	
	wire [DSTPw-1 : 0] dstp_encoded = hdr_flit.destport;
	
	
	
	localparam 
		ELw = log2(T3),
		Pw  = log2(MAX_P),
		PLw = (TOPOLOGY == "FMESH") ? Pw : ELw;

	wire [PLw-1 : 0] endp_p_in;
	generate
	if(TOPOLOGY == "FMESH") begin : fmesh
		fmesh_endp_addr_decode #(
			.T1(T1),
			.T2(T2),
			.T3(T3),
			.EAw(EAw)
		)
		endp_addr_decode
		(
			.e_addr(hdr_flit.dest_e_addr),
			.ex(),
			.ey(),
			.ep(endp_p_in),
			.valid()
		);
	end else begin : mesh
		mesh_tori_endp_addr_decode #(
			.TOPOLOGY("MESH"),
			.T1(T1),
			.T2(T2),
			.T3(T3),
			.EAw(EAw)
		)
		endp_addr_decode
		(
			.e_addr(hdr_flit.dest_e_addr),
			.ex( ),
			.ey( ),
			.el(endp_p_in),
			.valid( )
		);

	end
	endgenerate
	destp_generator #(
			.TOPOLOGY(TOPOLOGY),
			.ROUTE_NAME(ROUTE_NAME),
			.ROUTE_TYPE(ROUTE_TYPE),
			.T1(T1),
			.NL(T3),
			.P(MAX_P),
			.PLw(PLw),
			.DSTPw(DSTPw),		
			.SELF_LOOP_EN (SELF_LOOP_EN),
			.SW_LOC(PORT_NUM)
		)
		decoder
		(
			.destport_one_hot (destport_one_hot),
			.dest_port_encoded(dstp_encoded),             
			.dest_port_out(),   
			.endp_localp_num(endp_p_in),
			.swap_port_presel(),
			.port_pre_sel(),
			.odd_column(1'b0)
		);
	
	
	
	assign header_flit [ `MSG_DST_CHIPID] = dest_chipid; 
	assign header_flit [ `MSG_DST_X]      = dest_x; 
	assign header_flit [ `MSG_DST_Y]      = dest_y; 
	assign header_flit [ `MSG_DST_FBITS]  = dest_fbits; 
	assign header_flit [ `MSG_LENGTH ]    = length; 
	assign header_flit [ `MSG_TYPE ]      = msg_type; 
	assign header_flit [ `MSG_MSHRID ]    = mshrid; 
	assign header_flit [ `MSG_OPTIONS_1]  = option1; 
		
	
	wire head = chan_in.flit_chanel.flit.hdr_flag;
	wire tail = chan_in.flit_chanel.flit.tail_flag;
	
	assign validOut = chan_in.flit_chanel.flit_wr;
	assign yummyOut = chan_in.flit_chanel.credit;
	assign dataOut  = (head)? header_flit[Fpay-1 : 0] : chan_in.flit_chanel.flit.payload;
	

endmodule

	
/*********************
 *   pack noc_top ports 
 * 	
 * 	******************/
 

	
	
module  noc_top_packed 
	import pronoc_pkg::*; 
(
	reset,
	clk,    
	chan_in_all,
	chan_out_all  
);
  
  	
	input   clk,reset;
	//local ports 
	input   smartflit_chanel_t [NE-1 : 0] chan_in_all  ;
	output  smartflit_chanel_t [NE-1 : 0] chan_out_all ;	

	smartflit_chanel_t chan_in_all_unpacked  [NE-1 : 0];
	smartflit_chanel_t chan_out_all_unpacked [NE-1 : 0];
	
	
	genvar i;
	
	generate
	for (i=0;i<NE;i++) begin: E_
		assign chan_in_all_unpacked[i]=chan_in_all[i];
		assign chan_out_all[i] = chan_out_all_unpacked[i];
	end//for
	endgenerate
	
	
	noc_top unpacked (
		.reset(reset),
		.clk(clk),    
		.chan_in_all(chan_in_all_unpacked),
		.chan_out_all(chan_out_all_unpacked)			
	);
	
	
endmodule	


module ground_pronoc_end_port 
		import pronoc_pkg::*; 
	#(
		parameter TILE_NUM=0,
		parameter NOC=1
	)(
		clk,
		reset,
		chan_in,
		chan_out		
    );
	
	input  reset,clk;
	input   smartflit_chanel_t chan_in;
	output  smartflit_chanel_t	chan_out;
	
	assign chan_out = {SMARTFLIT_CHANEL_w{1'b0}};
	//synthesis translate_off
	always @(posedge clk) begin 
		if(chan_in.flit_chanel.flit_wr) begin
			$display("%t: ERROR: a flit has been recived in grounded NoC %d port %d:flit:%h",$time,NOC,TILE_NUM,chan_in.flit_chanel.flit);
			$finish;
		end
	end
	//synthesis translate_on

endmodule


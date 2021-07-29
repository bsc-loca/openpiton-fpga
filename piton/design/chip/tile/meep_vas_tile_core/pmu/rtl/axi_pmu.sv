
	module axi_pmu #
	(
		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 64,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 64
		// Amount of counters
		// parameter integer N_COUNTERS	= 23,
		// Configuration registers
		// parameter integer N_CONF_REGS	= 1
	)
	(
		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write channel Protection type. This signal indicates the
    		// privilege and security level of the transaction, and whether
    		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave) 
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte lanes hold
    		// valid data. There is one write strobe bit for each eight
    		// bits of the write data bus.    
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Protection type. This signal indicates the privilege
    		// and security level of the transaction, and whether the
    		// transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY,

		//TODO use parameters
		// Interface to counters
		// Read interface		
		output logic counter_read_enable,
		input logic counter_read_valid,
        output logic[7:0] counter_read_address,
        input logic[63:0] counter_read_data, 
		// Write interface
		output logic counter_write_enable,
		input logic counter_write_valid,
        output logic[7:0] counter_write_address,
		output logic[63:0] counter_write_data
	);

	// AXI4LITE signals
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	logic axi_awaddr_ready;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arready;
	reg [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rvalid;

	// Example-specific design signals
	// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)
	// TODO remove ADDR_LSB
    localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	localparam integer OPT_MEM_ADDR_BITS = 4;
	
	localparam integer ADDRESS_OFFSET = 'hfff5100000;

	reg	 aw_en;

	// I/O Connections assignments
	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RVALID	= axi_rvalid;


	// Writing logic
	always_ff @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awready <= 1'b0;
	      aw_en <= 1'b1;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // slave is ready to accept write address when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_awready <= 1'b1;
	          aw_en <= 1'b0;
	        end
	        else if (S_AXI_BREADY && axi_bvalid)
	            begin
	              aw_en <= 1'b1;
	              axi_awready <= 1'b0;
	            end
	      else           
	        begin
	          axi_awready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_awaddr latching
	// This process is used to latch the address when both 
	// S_AXI_AWVALID and S_AXI_WVALID are valid. 

	always_ff @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awaddr <= 0;
		  axi_awaddr_ready <= 0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          	// Write Address latching 
	          	axi_awaddr <= S_AXI_AWADDR;
		  		axi_awaddr_ready <= 1;
			end else if(axi_awaddr_ready) begin
				axi_awaddr <= 0;
				axi_awaddr_ready <= 0;
			end
	    end 
	end       

	// Write logic

	// Implement axi_wready generation
	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	// de-asserted when reset is low. 

	// Synchronyzer for read_valid signal from register bank
	logic counter_write_valid_syn;
	synchronyzer_2_stage write_syn(
	.in(counter_write_valid),
	.out(counter_write_valid_syn),
	.clk(S_AXI_ACLK)
	);

	always_ff @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_wready <= 1'b0;
	      axi_bvalid  <= 0;
	      axi_bresp   <= 2'b0;
		counter_write_enable <= 1'b0;
	    end 
	  else
	    begin    
	      if ( axi_awaddr_ready ) begin
				// slave is ready to accept write data when 
				// there is a valid write address and write data
				// on the write address and data bus. This design 
				// expects no outstanding transactions. 
	          	axi_wready <= 1'b1;

			  	// Send write data to register bank
				counter_write_enable <= 1'b1;
				counter_write_address <= (axi_awaddr-ADDRESS_OFFSET)>>3;	// Access must be 8-byte aligned
				counter_write_data <= S_AXI_WDATA;
	        end else begin
	          axi_wready <= 1'b0;
	        end

		if(counter_write_enable && counter_write_valid_syn) begin
				// Data is written
				counter_write_enable <= 1'b0;
				counter_write_address <= 0;
				counter_write_data <= 0;

				axi_bvalid <= 1'b1;
	          	axi_bresp  <= 2'b0;
			end else if(S_AXI_BREADY && axi_bvalid) begin
				axi_bvalid <= 1'b0;
			end
	    end 
	end       





	// Read address logic

	always_ff @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_arready <= 1'b0;
	      axi_araddr  <= {C_S_AXI_ADDR_WIDTH{1'b0}};
	    end 
	  else
	    begin    
	      if (~axi_arready && S_AXI_ARVALID)
	        begin
	          // indicates that the slave has acceped the valid read address
	          axi_arready <= 1'b1;
	          // Read address latching
	          axi_araddr  <= S_AXI_ARADDR;
	        end
	      else
	        begin
	          axi_arready <= 1'b0;
	        end
	    end 
	end       

	// Read data logic

	// Synchronyzer for read_valid signal from register bank
	logic counter_read_valid_syn;
	synchronyzer_2_stage read_syn(
	.in(counter_read_valid),
	.out(counter_read_valid_syn),
	.clk(S_AXI_ACLK)
	);

	always_ff @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
		// Reset all to 0
	    begin
	      axi_rvalid <= 0;
	      axi_rresp  <= 0;
		  counter_read_enable <= 0;
	    end 
	  else
	    begin    
	      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid) begin
				// When address is ready, request data to register bank 
				if(~counter_read_enable) begin
					counter_read_address <= (axi_araddr-ADDRESS_OFFSET)>>3;
					counter_read_enable <= 1'b1;
				end
	          axi_rresp  <= 2'b0; // 'OKAY' response  What to do with this signal??
	    	end else if(counter_read_enable && ~axi_rvalid && counter_read_valid_syn) begin
				// If data has been requested to register bank and it is ready, read it, assign it to output and set rvalid signal
				counter_read_enable <= 1'b0;
				axi_rvalid <= 1'b1;
				axi_rdata <= counter_read_data;
			end else if (axi_rvalid && S_AXI_RREADY)
	        begin
	          // Deassert valid signal and remove output data when read by master
	          axi_rvalid <= 1'b0;
			  axi_rdata <= 0;
	        end                
	    end
	end    
endmodule
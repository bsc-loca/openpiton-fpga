
// simulation parameter setting

`ifdef INCLUDE_SIM_PARAM
	localparam 
		TRAFFIC="RANDOM",
		PCK_SIZ_SEL="random-range",	
	  	AVG_LATENCY_METRIC= "HEAD_2_TAIL",
		//simulation min and max packet size. The injected packet take a size randomly selected between min and max value
		MIN_PACKET_SIZE=5,
		MAX_PACKET_SIZE=5,
		STOP_PCK_NUM=200000,
		STOP_SIM_CLK=100000;
	    		
	localparam HOTSPOT_NODE_NUM = 0;
	hotspot_t  hotspot_info [0:0];
	
		
	
		
	
	 localparam DISCRETE_PCK_SIZ_NUM=1;
	 rnd_discrete_t rnd_discrete [DISCRETE_PCK_SIZ_NUM-1:0];

		
		parameter INJRATIO=10; 


localparam CUSTOM_NODE_NUM=0;
	wire [NEw-1 : 0] custom_traffic_t   [NE-1 : 0];
	wire [NE-1 : 0] custom_traffic_en;
	
	


`endif			
			

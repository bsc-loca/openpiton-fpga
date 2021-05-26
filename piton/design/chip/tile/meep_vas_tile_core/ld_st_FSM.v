/* Copyright 2019 Computing Research Center of the National Polytechnic Institute
 * of Mexico - CIC IPN.
 * 
 *
 * File:   store_FSM.sv 
 * Author: Neiel I. Leyva S.
 * Date:   16.08.2019
 *
 * Maquina de estados para store - comunicacion con dCache
 */  
    

//used between TLB and data cache
module ld_st_FSM(
    input      clk                  ,
    input      rst                  ,
    input      is_store_i           ,
    input      is_load_i            ,
    input      kill_mem_op_i        ,
    input      dtlb_hit_i           ,
    input      ld_resp_valid_i      ,    
    output     str_rdy_o            ,
    output reg mem_req_valid_o      ,
    output reg st_translation_req_o ,
    output reg trns_ena,
    output reg dmem_lock_o          
);

    reg  cnt_ena;
    reg  is_load_bf;
    wire unlock;
    wire req_valid;

    assign req_valid = is_store_i | is_load_i;
    
    reg [2:0] EstadoSiguiente,Edo_Sgte;
    parameter   NO_REQ        = 3'b000,
			    TRANSLATION   = 3'b001,
			    REQ_VALID     = 3'b010,
			    WAITING_TRNS  = 3'b011,
                WAITING_LD_ST = 3'b100;

    always@(posedge clk, negedge rst) begin
        if(!rst) EstadoSiguiente = 3'b000;
        else     EstadoSiguiente = Edo_Sgte;
    end

//----------------------------------------------------------------FSM
    always @ ( posedge clk ) begin
	    case (EstadoSiguiente)
            NO_REQ: begin
                mem_req_valid_o      <= 1'b0;
                st_translation_req_o <= 1'b0;
                cnt_ena              <= 1'b0;
                Edo_Sgte             <= (kill_mem_op_i  ) ? NO_REQ      : 
			                            (req_valid      ) ? TRANSLATION : 
                                                            NO_REQ      ;
                                                                                
                dmem_lock_o          <= (kill_mem_op_i ) ? 1'b0 : 
			                            (req_valid     ) ? 1'b1 : 
                                                           1'b0 ;
                                                                                                
                trns_ena             <= req_valid;          
            end
            
            TRANSLATION: begin
                mem_req_valid_o      <= 1'b0;
                st_translation_req_o <= (kill_mem_op_i ) ? 1'b0   : 1'b1 ;
                cnt_ena              <= 1'b0;
                Edo_Sgte             <= (kill_mem_op_i ) ? NO_REQ : WAITING_TRNS ;
                dmem_lock_o          <= (kill_mem_op_i ) ? 1'b0   : 1'b1 ; 
                trns_ena             <= 1'b1;          
            end
            
            REQ_VALID: begin
                mem_req_valid_o      <= (kill_mem_op_i)  ? 1'b0 : 1'b1;
                st_translation_req_o <= 1'b0;
                cnt_ena              <= (!is_load_bf);

                Edo_Sgte             <= (kill_mem_op_i)  ? NO_REQ : WAITING_LD_ST;

                dmem_lock_o          <= (kill_mem_op_i ) ? 1'b0  : 1'b1 ; 
                trns_ena             <= 1'b0;          
            end
            
            WAITING_TRNS: begin
                if ( dtlb_hit_i ) begin
                    mem_req_valid_o      <= 1'b0;
                    st_translation_req_o <= 1'b0;
                    cnt_ena              <= 1'b0;
                    Edo_Sgte             <= REQ_VALID  ; 
                    dmem_lock_o          <= 1'b0 ; 
                    trns_ena             <= 1'b0;          
                end
                else begin
                    mem_req_valid_o      <= 1'b0;
                    st_translation_req_o <= 1'b0;
                    cnt_ena              <= (!is_load_bf);
                    Edo_Sgte             <= WAITING_TRNS; 
                    dmem_lock_o          <= 1'b1 ; 
                    trns_ena             <= 1'b1;          
                end
            end
	            
            WAITING_LD_ST: begin
                if ( unlock || ld_resp_valid_i ) begin
                    mem_req_valid_o      <= 1'b0;
                    st_translation_req_o <= 1'b0;
                    cnt_ena              <= 1'b0;
                    Edo_Sgte             <= NO_REQ  ; 
                    dmem_lock_o          <= 1'b0 ; 
                    trns_ena             <= 1'b0;          
                end
                else begin
                    mem_req_valid_o      <= 1'b0;
                    st_translation_req_o <= 1'b0;
                    //cnt_ena              <= 1'b1;
                    Edo_Sgte             <= WAITING_LD_ST; 
                    dmem_lock_o          <= 1'b1; 
                    trns_ena             <= 1'b0;          
            
                end
            end
            
	    endcase
    end
//-------------------------------------------------------------------
    reg [2:0] cnt;

    always @ (posedge clk ) begin
        if (!rst) cnt = 3'b0;
        else if (cnt_ena) cnt = cnt + 1'b1;
        else cnt = 1'b0;
    end

    assign unlock = cnt[2];
    assign str_rdy_o = cnt_ena;

    always @ (posedge clk) begin
        if (!rst || mem_req_valid_o) is_load_bf <= 1'b0;
        else if (is_load_i)          is_load_bf <= is_load_i;
        else                         is_load_bf <= is_load_bf;
    end

endmodule


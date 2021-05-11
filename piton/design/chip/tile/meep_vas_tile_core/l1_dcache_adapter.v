
/* Copyright 2019 Computing Research Center of the National Polytechnic Institute
 * of Mexico - CIC IPN.
 * 
 *
 * File:   l1_dcache_adapter.sv 
 * Author: Neiel I. Leyva S.
 * Date:   16.08.2019
 *
 * Adaptador de load y stores para L1 Cache System
 */  
module l1_dcache_adapter(
    input            clk                   ,
    input            rst                   ,
    input            is_store_i            ,
    input            is_load_i            ,
    input  [63:0]    vaddr_i               ,   
    input  [63:0]    paddr_i               ,  
    input  [63:0]    data_i                ,   
    input   [1:0]    op_bits_type_i        ,   
    input            dtlb_hit_i            ,  
    input            st_translation_req_i  , 
    input            str_rdy_i             ,  
    input            mem_req_valid_i       ,  
    input            trns_ena_i           ,
    output           translation_req_o     ,   
    output [63:0]    vaddr_o               ,   
    output           is_store_o            ,   
    output           is_load_o             ,   
    output           drain_nc               ,  
    output [10:0]    ld_mem_req_addr_index_o  ,
    output [44:0]    ld_mem_req_addr_tag_o    ,
    output [63:0]    ld_mem_req_wdata_o       ,
    output           ld_mem_req_valid_o       ,
    output           ld_mem_req_we_o          ,
    output     [7:0] ld_mem_req_be_o          ,
    output     [1:0] ld_mem_req_size_o        ,
    output           ld_mem_req_kill_o        ,
    output           ld_mem_req_tag_valid_o   ,
    output [10:0]    st_mem_req_addr_index_o  ,
    output [44:0]    st_mem_req_addr_tag_o    ,
    output [63:0]    st_mem_req_wdata_o       ,
    output           st_mem_req_valid_o       ,
    output           st_mem_req_we_o          ,
    output     [7:0] st_mem_req_be_o          ,
    output     [1:0] st_mem_req_size_o        ,
    output           st_mem_req_kill_o        ,
    output           st_mem_req_tag_valid_o   
);

    reg   [7:0]  mem_req_be_o       ;
    reg  [63:0]  st_vaddr_bf        ;
    reg  [63:0]  st_data_bf         ;
    reg   [1:0]  st_op_bits_type_bf ;
    reg   [2:0]  st_addr20_bf       ;
    reg          is_store_bf        ;
    reg          is_load_bf        ;
    reg          st_translation_req ;
    reg  [63:0]  paddr_bf           ;
    reg  [63:0]  paddr_q            ;
    //reg  [63:0]  paddr_q2           ;
    reg          mem_req_valid_bf   ;
    wire         is_load            ;
    wire [63:0]  st_vaddr           ;
    wire [63:0]  ld_vaddr           ;
    wire  [2:0]  op_bits_type       ;
    wire  [2:0]  addr20             ;

    assign is_load = 1'b0;
    assign ld_vaddr = 64'b0;

    assign drain_nc = is_load_i | is_store_i;

    //--------------------------------------- Buffer para sincronizar datos
    //- Sincroniza los datos para la solicitud de traduccion 
    //- en un store, con la maquina de estados 
    always @ ( posedge clk) begin 
        if ( !rst || (!trns_ena_i && !is_store_i && !is_load_i)) 
                                           st_vaddr_bf <= 64'b0 ;
        else if ( is_store_i || is_load_i) st_vaddr_bf <= vaddr_i;
        else                               st_vaddr_bf <= st_vaddr_bf;
    end

    always @ ( posedge clk) begin
        if (!rst || (!trns_ena_i && !is_store_i && mem_req_valid_i)) 
                                                   is_store_bf <= 1'b0;
        else if ( is_store_i )                     is_store_bf <= 1'b1;
        else                                       is_store_bf <= is_store_bf;
    end
    
    always @ ( posedge clk) begin
        if (!rst || (!trns_ena_i && !is_load_i && mem_req_valid_i)) 
                                is_load_bf <= 1'b0;
        else if ( is_load_i )   is_load_bf <= 1'b1;
        else                    is_load_bf <= is_load_bf;
    end
    
    //- Sincroniza los datos para la solicitud a dcache 
    //- de un store con la maquina de estados 
    always @ ( posedge clk ) begin
        if ( is_store_i || is_load_i ) begin
            st_data_bf         <= data_i           ;
            st_op_bits_type_bf <= op_bits_type_i   ; 
            st_addr20_bf       <= vaddr_i[2:0]     ; 
        end     
        else if ( !mem_req_valid_bf ) begin 
            st_data_bf         <= st_data_bf          ;
            st_op_bits_type_bf <= st_op_bits_type_bf  ; 
            st_addr20_bf       <= st_addr20_bf        ; 
        end
        else begin
            st_data_bf         <= 64'b0 ;
            st_op_bits_type_bf <=  2'b0 ; 
            st_addr20_bf       <=  3'b0 ; 
        end
    end

    always @ ( posedge clk ) begin
        if (!rst) mem_req_valid_bf <= 1'b0;
        else      mem_req_valid_bf <= mem_req_valid_i;
    end

    always @ (posedge clk) begin
        if (str_rdy_i)  paddr_q = paddr_q;
        else            paddr_q = paddr_i;
    end
    
    //-- Tipo de operacion B, H, W 
    assign op_bits_type = ( mem_req_valid_i ) ? {1'b0,st_op_bits_type_bf} : 3'b100;
    assign addr20       = ( mem_req_valid_i ) ? st_addr20_bf    : 3'b0;
    
    always @ (*) begin
        case (op_bits_type)
            3'b011: mem_req_be_o <= 8'b11111111;
            3'b010: begin
                case (addr20)
                    3'b000  : mem_req_be_o <= 8'b00001111;
                    3'b001  : mem_req_be_o <= 8'b00011110;
                    3'b010  : mem_req_be_o <= 8'b00111100;
                    3'b011  : mem_req_be_o <= 8'b01111000;
                    3'b100  : mem_req_be_o <= 8'b11110000;
                    default : mem_req_be_o <= 8'b00000000;        
                endcase
            end
            3'b001: begin
                case (addr20)
                    3'b000  : mem_req_be_o <= 8'b00000011;
                    3'b001  : mem_req_be_o <= 8'b00000110;
                    3'b010  : mem_req_be_o <= 8'b00001100;
                    3'b011  : mem_req_be_o <= 8'b00011000;
                    3'b100  : mem_req_be_o <= 8'b00110000;
                    3'b101  : mem_req_be_o <= 8'b01100000;
                    3'b110  : mem_req_be_o <= 8'b11000000;
                    default : mem_req_be_o <= 8'b00000000;  
                endcase
            end
            3'b000: begin
                case (addr20)
                    3'b000  : mem_req_be_o <=  8'b0000_0001;
                    3'b001  : mem_req_be_o <=  8'b0000_0010;
                    3'b010  : mem_req_be_o <=  8'b0000_0100;
                    3'b011  : mem_req_be_o <=  8'b0000_1000;
                    3'b100  : mem_req_be_o <=  8'b0001_0000;
                    3'b101  : mem_req_be_o <=  8'b0010_0000;
                    3'b110  : mem_req_be_o <=  8'b0100_0000;
                    3'b111  : mem_req_be_o <=  8'b1000_0000;
                    default : mem_req_be_o <=  8'b0000_0000;
                endcase
            end
            default :mem_req_be_o <=  8'b0000_0000;
        endcase
    end

    //-------------------------------------------------------------------- 
    //------------------------------------------------ interfaz con la mmu
    assign is_store_o        = is_store_bf;
    assign is_load_o         = is_load_bf;
    assign vaddr_o           = ( is_store_o || is_load_o ) ? st_vaddr_bf : 64'b0;
    assign translation_req_o = ( is_store_o || is_load_o ) ? st_translation_req_i : 1'b0;

    //-------------------------------------------------------------------- 
    //----------------------------------------------interfaz con la dcache
    //- store request 
    assign st_mem_req_addr_index_o = paddr_q[10:0]  ;
    assign st_mem_req_addr_tag_o   = paddr_q[55:11] ;
    assign st_mem_req_wdata_o      = st_data_bf     ;
    assign st_mem_req_valid_o      = mem_req_valid_i & is_store_o;  
    assign st_mem_req_we_o         = mem_req_valid_i & is_store_o;
    assign st_mem_req_be_o         = mem_req_be_o;
    assign st_mem_req_size_o       = st_op_bits_type_bf ;
    //assign st_mem_req_size_o       = 2'b11 ;
    assign st_mem_req_kill_o       = 1'b0;
    assign st_mem_req_tag_valid_o  = 1'b0;
    
    //- load request
    assign ld_mem_req_addr_index_o = paddr_q[10:0]  ;
    assign ld_mem_req_addr_tag_o   = paddr_q[55:11] ;
    assign ld_mem_req_wdata_o      = 64'b0     ;
    assign ld_mem_req_valid_o      = mem_req_valid_i & is_load_o;  
    assign ld_mem_req_we_o         = 1'b0 ; 
    assign ld_mem_req_be_o         = mem_req_be_o;
    assign ld_mem_req_size_o       = st_op_bits_type_bf ;
    assign ld_mem_req_kill_o       = 1'b0;
    assign ld_mem_req_tag_valid_o  = 1'b1;
    //assign ld_mem_req_tag_valid_o  = (mem_req_valid_i & is_load_o);
endmodule

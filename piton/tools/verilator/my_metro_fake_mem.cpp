/*
Copyright (c) 2019 Princeton University
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Princeton University nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
#include "Vmetro_fake_mem.h"
#include "verilated.h"
#include <iostream>
//#define VERILATOR_VCD 0

#ifdef VERILATOR_VCD
#include "verilated_vcd_c.h"
#endif
#include <iomanip>

#include "mcs_map_info.h"

const int ALL_NOC      = 1;
// Compilation flags parameters
const int PITON_X_TILES = X_TILES;
const int PITON_Y_TILES = Y_TILES;


uint64_t main_time = 0; // Current simulation time
uint64_t clk = 0;
Vmetro_fake_mem* top;
int rank, dest, size;
short test_end=0;
int smart_max=0;

void initialize();


int getRank();
int getSize();
void finalize();
unsigned short mpi_receive_finish();
void mpi_send_finish(unsigned short message, int rank);
void mpi_send_chan(void * chan, size_t len, int dest, int rank, int flag);
void mpi_receive_chan(void * chan, size_t len, int origin, int flag);



#ifdef VERILATOR_VCD
VerilatedVcdC* tfp;
#endif
// This is a 64-bit integer to reduce wrap over issues and
// // allow modulus. You can also use a double, if you wish.
double sc_time_stamp () { // Called by $time in Verilog
return main_time; // converts to double, to match
// what SystemC does
}

void tick() {
    top->core_ref_clk = 1;
    main_time += 250;
    top->eval();
#ifdef VERILATOR_VCD
    tfp->dump(main_time);
#endif
    top->core_ref_clk = 0;
    main_time += 250;
    top->eval();
#ifdef VERILATOR_VCD
    tfp->dump(main_time);
#endif
}



void  mpi_work_opt_fake_mem(){
    //test_end = test_end or (top->good_end==1 or top->bad_end==1);
    
    mpi_send_chan(&top->noc_chanel_out, sizeof(top->noc_chanel_out),  dest, rank, ALL_NOC);
    mpi_receive_chan(&top->noc_chanel_in, sizeof(top->noc_chanel_in), dest, ALL_NOC);
}

int get_rank_fromXY(int x, int y) {
    return 1 + ((x)+((PITON_X_TILES)*y));
}


void mpi_tick() {
    top->core_ref_clk = 1;    
    top->eval();
    main_time += 250;
    
    #ifdef VERILATOR_VCD
    tfp->dump(main_time);
    #endif
    
    for(int i=0; i<smart_max+2; i++) {
        top->core_ref_clk = 0;  
        mpi_work_opt_fake_mem();
        top->eval();
    }
    
    main_time += 250;
    
    #ifdef VERILATOR_VCD
    tfp->dump(main_time);
    #endif
       
   
  
    
    

}

void reset_and_init() {
    

    top->core_ref_clk = 0;

    init_jbus_model_call((char *) "mem.image", 0);

    //std::cout << "Before first ticks" << std::endl << std::flush;
    tick();
    mpi_tick();
  
    for (int i = 0; i < 100; i++) {
        tick();
    }
   // top->pll_rst_n = 1;

   
    for (int i = 0; i < 10; i++) {
        tick();
    }
   // top->clk_en = 1;

//    // After 100 cycles release reset

    for (int i = 0; i < 100; i++) {
        tick();
    }
    top->sys_rst_n = 1;

//    // Wait for SRAM init, trin: 5000 cycles is about the lowest
//    repeat(5000)@(posedge `CHIP_INT_CLK);
    for (int i = 0; i < 5000; i++) {
        tick();
    }

    std::cout << "Reset complete (fake_mem)" << std::endl << std::flush;
}

int main(int argc, char **argv, char **env) {
    //std::cout << "Started" << std::endl << std::flush;
    Verilated::commandArgs(argc, argv);
    top = new Vmetro_fake_mem;
    //std::cout << "Vmetro_fake_mem created" << std::endl << std::flush;

#ifdef VERILATOR_VCD
    Verilated::traceEverOn(true);
    tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("my_metro_fake_mem.vcd");

    Verilated::debug(1);
#endif

    // MPI work 
    initialize();
    rank = getRank();
    size = getSize();
    
    printf("*************rank=%d\n",rank);
    
    //MC RANK starts with 1+ piton_x*piton_y
    int mc_start_rank = PITON_X_TILES * PITON_Y_TILES +1;
    int mc_num = rank - mc_start_rank;
    if(mc_num >= MCS_NUM && MCS_NUM> 0){
    	printf("Error: invalid rank (%d) for fake mem. It mapped to mc (%d) while the number of MC are %d\n",rank,mc_num,MCS_NUM);
    	exit(1);
    }
    printf("*************mc_num=%d\n",mc_num);
    dest =get_rank_fromXY(mc_map[mc_num].x , mc_map[mc_num].y);
     printf("*************dest=%d\n",dest);
    //std::cout << "fake_mem size: " << size << ", rank: " << rank <<  std::endl;
    


    reset_and_init();
    smart_max = top->smart_max;

   
    bool test_exit = false;
    uint64_t checkTestEnd=14000;
    while (!Verilated::gotFinish() and !test_exit) { 
        mpi_tick();
        if (checkTestEnd==0) {
            //std::cout << "Checking Finish fake_mem" << std::endl;
            test_exit= mpi_receive_finish();
            checkTestEnd=1000;
           
            //std::cout << "Finishing: " << test_end << std::endl;
        }
        else {
            checkTestEnd--;
        }
    }

  

    #ifdef VERILATOR_VCD
    std::cout << "Trace done" << std::endl;
    tfp->close();
    #endif

    finalize();

    delete top;
    exit(0);
}

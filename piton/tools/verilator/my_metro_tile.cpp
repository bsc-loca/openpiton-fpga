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
#include "Vmetro_tile.h"
#include "verilated.h"
#include <iostream>

#include "mcs_map_info.h"

//#define VERILATOR_VCD 0

//#define KONATA_EN

//#define REPORT_RANKS


#ifdef VERILATOR_VCD
#include "verilated_vcd_c.h"
#endif
#include <iomanip>

#ifdef KONATA_EN
#include "dpi_konata.h"
#endif

const int ALL_NOC      = 1;

// Compilation flags parameters
const int PITON_X_TILES = X_TILES;
const int PITON_Y_TILES = Y_TILES;

uint64_t main_time = 0; // Current simulation time
uint64_t clk = 0;
Vmetro_tile* top;
int rank, dest, size;
int rankN, rankS, rankW, rankE;
int tile_x, tile_y;//, PITON_X_TILES, PITON_Y_TILES;
int smart_max=0;

#define RANK_NUM 4
int MY_RANK [RANK_NUM];

#define EAST       0
#define NORTH      1
#define WEST       2
#define SOUTH      3


void mpi_send_chan(void * chan, size_t len, int dest, int rank, int flag);
void mpi_receive_chan(void * chan, size_t len, int origin, int flag);




void initialize();
int getRank();
int getSize();
void finalize();
unsigned short mpi_receive_finish();
void mpi_send_finish(unsigned short message, int rank);




#ifdef VERILATOR_VCD
VerilatedVcdC* tfp;
#endif
// This is a 64-bit integer to reduce wrap over issues and
// // allow modulus. You can also use a double, if you wish.
double sc_time_stamp () { // Called by $time in Verilog
    return main_time; // converts to double, to match
    // what SystemC does
}

int get_rank_fromXY(int x, int y) {
    return 1 + ((x)+((PITON_X_TILES)*y));
}

// MPI ID funcitons
int getDimX () {
    if (rank==0) // Should never happen
        return 0;
    else
        return (rank-1)%PITON_X_TILES;
}

int getDimY () {
    if (rank==0) // Should never happen
        return 0;
    else
        return (rank-1)/PITON_X_TILES;
}

int get_edge_rank (int port) {

	int m;
	for (m=0;m< MCS_NUM; m++){
		if(mc_map[m].x==tile_x && mc_map[m].y == tile_y && mc_map[m].p == port) return (m + 1 + (PITON_X_TILES*PITON_Y_TILES));
	}
	return -1;
}


int getRankN () {
    if (tile_y == 0)
    	return get_edge_rank(PITON_PORT_N); 
       // return -1;
    else
        return get_rank_fromXY(tile_x, tile_y-1);
}

int getRankS () {
    if (tile_y+1 == PITON_Y_TILES)
       return get_edge_rank(PITON_PORT_S); 
       // return -1;
    else
        return get_rank_fromXY(tile_x, tile_y+1);
}

int getRankE () {
    if (tile_x+1 == PITON_X_TILES)
        return get_edge_rank(PITON_PORT_E); 
       // return -1;
    else
        return get_rank_fromXY(tile_x+1, tile_y);
}

int getRankW () {
    if (rank==1) { // go to chipset
        return 0;
    }
    else if (tile_x == 0) {
       return get_edge_rank(PITON_PORT_W); 
       // return -1;
    }
    else {
        return get_rank_fromXY(tile_x-1, tile_y);
    }
}

void tick() {
    top->core_ref_clk =1;
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


void mpi_work_opt() {
    int i;

    for (i=0;i<RANK_NUM;i++){
        if (MY_RANK[i] != -1)  mpi_send_chan(&top->noc_chanel_out[i], sizeof(top->noc_chanel_out[i]), MY_RANK[i], rank, ALL_NOC);
        if (MY_RANK[i] != -1)  mpi_receive_chan(&top->noc_chanel_in[i], sizeof(top->noc_chanel_in[i]), MY_RANK[i], ALL_NOC);
    }
   
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
        mpi_work_opt();
        top->eval();
    }
    
     main_time += 250;
    
#ifdef VERILATOR_VCD
    tfp->dump(main_time);
#endif
   
    

}

void reset_and_init() {
// Clocks initial value
    top->core_ref_clk = 0;

// Resets are held low at start of boot
    top->sys_rst_n = 0;
    top->pll_rst_n = 0;
    top->ok_iob = 0;

// Mostly DC signals set at start of boot

    top->pll_bypass = 1; // trin: pll_bypass is a switch in the pll; not reliable
    top->clk_mux_sel = 0; // selecting ref clock
    top->pll_rangea = 1; // 10x ref clock
    top->async_mux = 0;
    tick();
    mpi_tick();

    for (int i = 0; i < 100; i++) {
        tick();
    }
    top->pll_rst_n = 1;


    for (int i = 0; i < 10; i++) {
        tick();
    }
    top->clk_en = 1;


    for (int i = 0; i < 100; i++) {
        tick();
    }

    top->sys_rst_n = 1;


    for (int i = 0; i < 5000; i++) {
        tick();
    }

    top->ok_iob = 1;

}



int main(int argc, char **argv, char **env) {
    //std::cout << "Started" << std::endl << std::flush;
    Verilated::commandArgs(argc, argv);

    top = new Vmetro_tile;
    //std::cout << "Vmetro_tile created" << std::endl << std::flush;

    

    // MPI work 
    initialize();
    rank = getRank();
    size = getSize();
    
    
    //std::cout << "Vmetro_tile MPI created" << std::endl << std::flush;
#ifdef KONATA_EN
    konata_signature_init();
    konata_signature->clear_output();
#endif

#ifdef VERILATOR_VCD
    Verilated::traceEverOn(true);
    tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    std::cout << "dunno why we entered" << std::endl << std::flush;
    std::string tracename ("my_metro_tile"+std::to_string(rank)+".vcd");
    const char *cstr = tracename.c_str();
    tfp->open(cstr);
    Verilated::debug(1);
#endif
    
    if (rank==0) {
        dest = 1;
    } else {
        dest = 0;
    }
    
    tile_x = getDimX();
    tile_y = getDimY();
    rankN  = getRankN();
    rankS  = getRankS();
    rankW  = getRankW();
    rankE  = getRankE();


    MY_RANK[NORTH] = rankN;
    MY_RANK[EAST]  = rankE;
    MY_RANK[WEST]  = rankW;
    MY_RANK[SOUTH] = rankS;

    #ifdef REPORT_RANKS
	printf("** RANK(%d): N:%d E:%d W:%d S:%d\n",rank, rankN, rankE, rankW, rankS);
    #endif
    
    //std::cout << "Vmetro_tile MPI middle" << std::endl << std::flush;

    #ifdef VERILATOR_VCD
    std::cout << "TILE size: " << size << ", rank: " << rank <<  std::endl;
    std::cout << "tile_y: " << tile_y << std::endl;
    std::cout << "tile_x: " << tile_x << std::endl;
    std::cout << "rankN: " << rankN << std::endl;
    std::cout << "rankS: " << rankS << std::endl;
    std::cout << "rankW: " << rankW << std::endl;
    std::cout << "rankE: " << rankE << std::endl;
    #endif

    top->default_chipid = 0;
    top->default_coreid_x = tile_x;
    top->default_coreid_y = tile_y;
    top->flat_tileid = rank-1;

    //std::cout << "Vmetro_tile MPI before reset" << std::endl << std::flush;

    reset_and_init();
    
    smart_max = top->smart_max;
    
     if (rank==1) std::cout << "smart_max=" << smart_max << std::endl << std::flush;
    

    //std::cout << "Vmetro_tile MPI after reset" << std::endl << std::flush;

    bool test_exit = false;
    uint64_t checkTestEnd=14000;
    while (!Verilated::gotFinish() and !test_exit) { 
        mpi_tick();
        if (checkTestEnd==0) {
            //std::cout << "Checking Finish TILE" << std::endl;
            test_exit= mpi_receive_finish();
            checkTestEnd=1000;
            //std::cout << "Finishing: " << test_exit << std::endl;
            //std::cout << "." << std::flush;
        }
        else {
            checkTestEnd--;
        }
    }
    std::cout << "ticks: " << std::setprecision(10) << sc_time_stamp() << " , cycles: " << sc_time_stamp()/500 << std::endl;

    #ifdef VERILATOR_VCD
    std::cout << "Trace done" << std::endl;
    tfp->close();
    #endif

    finalize();
    top->final();

    delete top;
    exit(0);
}

#include "dpi_torture_vpu.h"
#include <iostream>
#include <fstream>
#include <iomanip>
#include <string>

#define HEX_SB_ID( x ) std::setw(1) << std::hex << (unsigned long)(x)
#define HEX_VDATA( x ) std::setw(2) << std::setfill('0') << std::hex << (unsigned long)( x )
#define DEC_VLEN( x ) std::dec << (unsigned long) (x)
#define DEC_VDST( x )  "v" << std::setw(2) << std::setfill(' ') << std::dec << (long)( x )

// Global objects
tortureSignatureVpu *torture_signature_vpu;

// Global Variables

// System Verilog DPI
void torture_dump_vpu (unsigned long long completed_valid, unsigned long long completed_illegal, unsigned long long vreg_dst, unsigned long long lreg_dst, unsigned long long sew, unsigned long long vlen, unsigned long long widening, unsigned long long reduction, unsigned long long reduction_wi, unsigned long long sb_id, svLogicVecVal *dpi_param){
	
	if(torture_signature_vpu->dump_check_vpu()){
		if(completed_valid) {
			torture_signature_vpu->dump_file_vpu(completed_illegal, vreg_dst, lreg_dst, sew, vlen, widening, reduction, reduction_wi, sb_id, dpi_param);
		}
	}
}

void torture_signature_init_vpu(){
	torture_signature_vpu = new tortureSignatureVpu;
	torture_signature_vpu->clear_output_vpu();
}

// Torture Signature
void tortureSignatureVpu::disable_vpu()
{
	dump_valid_vpu = false;
}

void tortureSignatureVpu::set_dump_file_name_vpu(std::string name)
{
	signatureFileNameVpu = name;
}

bool tortureSignatureVpu::dump_check_vpu()
{
	return dump_valid_vpu;
}

void tortureSignatureVpu::clear_output_vpu()
{
	signatureFileVpu.open(signatureFileNameVpu, std::ios::out);
	signatureFileVpu.close();
}

void tortureSignatureVpu::dump_file_vpu(unsigned long long completed_illegal, unsigned long long vreg_dst, unsigned long long lreg_dst, unsigned long long sew, unsigned long long vlen, unsigned long long widening, unsigned long long reduction, unsigned long long reduction_wi, unsigned long long sb_id, svLogicVecVal *dpi_param){

	//REASON FOR THIS UNPADDING
	//When passing the array with the information of the VRF from the torture dump hdl to this cpp file
	//a padding of zeroes is added for 4 bytes every 4 bytes. For example, assuming each position of the array
	//contains the value of the address (0, 1, 2, 3, etc), we receive this:
	//lanes[0][0][0][0]  = 0
	//lanes[0][0][0][1]  = 1
	//lanes[0][0][0][2]  = 2
	//lanes[0][0][0][3]  = 3
	//lanes[0][0][0][4]  = 0
	//lanes[0][0][0][5]  = 0
	//lanes[0][0][0][6]  = 0
	//lanes[0][0][0][7]  = 0
	//lanes[0][0][0][8]  = 4
	//lanes[0][0][0][9]  = 5
	//lanes[0][0][0][10] = 6
	//lanes[0][0][0][11] = 7
	//lanes[0][0][0][12] = 0
	//...
	//I haven't figured out how to solve this, but I can 100% confirm this padding is added between the sv file of the torture dump
	//and this cpp file. If someone has any idea of why this happens or wants to discuss this, please contact me at gerard.candon@bsc.es
	//I don't like this absurd unpadding solution, but for now it will have to suffice.
	
	char lanes_unpadded [N_LANES][N_BANKS][8][VRF_DEPTH];
	for (int i = 0; i<N_LANES; ++i) {
		for (int j = 0; j<N_BANKS; ++j) {
			for (int z = 0; z < 8; ++z) {
				int addr = 0;
				for (int w = 0; w < 2*VRF_DEPTH; ++w) {
					if ((w % 8) < 4) {
						lanes_unpadded[i][j][z][addr] = ((dpi_param_t *)dpi_param)->lanes[i][j][z][w];
						++addr;
					}
				}
			}
		}
	}

	///////////////////////////////////////
	//EXTRACTING INFORMATION FROM THE VRF//
	///////////////////////////////////////
	
	int elements = 0;
	int lane = 0;
	int elems_per_lane = MAX_64_BIT_BLOCKS/N_LANES; 
	int bank = (vreg_dst*elems_per_lane)%N_BANKS; 
	int addr = (vreg_dst*elems_per_lane)/N_BANKS; 
	int sub_banks = 8;
	unsigned char data [MAX_VLEN/MIN_SEW];

	for (int i = 0; i < MAX_VLEN/MIN_SEW; i += 8) { 
		//On each iteration, we visit all the sub-banks of a given lane, bank and address
		data[i] = lanes_unpadded[lane][bank][0][addr];
		data[i+1] = lanes_unpadded[lane][bank][1][addr];
		data[i+2] = lanes_unpadded[lane][bank][2][addr];
		data[i+3] = lanes_unpadded[lane][bank][3][addr];
		data[i+4] = lanes_unpadded[lane][bank][4][addr];
		data[i+5] = lanes_unpadded[lane][bank][5][addr];
		data[i+6] = lanes_unpadded[lane][bank][6][addr];
		data[i+7] = lanes_unpadded[lane][bank][7][addr];

		lane++;
		if (lane == N_LANES) {
			lane = 0;
			bank++;
			if (bank == N_BANKS) {
				bank = 0;
				addr++;
			}
		}
	}

	////////////////
	//FILE DUMPING//
	////////////////
	
	unsigned long long vl = vlen;
	if (reduction_wi) vl = 2;
	else {
		if (reduction) vl = 1;
		if (widening) vl = vl * 2;	
	}
	signatureFileVpu.open(signatureFileNameVpu, std::ios::out | std::ios::app);

	if (completed_illegal) signatureFileVpu << "ILLEGAL\n";
	
	else {
		//We write in reverse order on the file, from MSElem to LSElem
		//If i is greater than vlen, then the DPI has to print zeroes
		//If this was a widening instruction, vlen should be doubled
		switch(sew) {
			case 0: //8
				signatureFileVpu << "e8 m1 l" << DEC_VLEN(vlen) << " " << DEC_VDST(lreg_dst) << " 0x";
				for (int i = 511; i >= 0; --i) {
					if (i > (vl-1)) signatureFileVpu << HEX_VDATA(0);
					else signatureFileVpu << HEX_VDATA(data[i]);
				}
				break;
			case 1: //16
				signatureFileVpu << "e16 m1 l" << DEC_VLEN(vlen) << " " << DEC_VDST(lreg_dst) << " 0x";
				for (int i = 511; i >= 1; i-=2) {
					if (i > ((vl*2)-1)) {
						signatureFileVpu << HEX_VDATA(0) <<
								    HEX_VDATA(0);
					}
					else {
						signatureFileVpu << HEX_VDATA(data[i]) <<
							            HEX_VDATA(data[i-1]);
					}
				}
				break;
			case 2: //32
				signatureFileVpu << "e32 m1 l" << DEC_VLEN(vlen) << " " << DEC_VDST(lreg_dst) << " 0x";
				for (int i = 511; i >= 3; i-=4) {
					if (i > ((vl*4)-1)) {
						signatureFileVpu << HEX_VDATA(0) <<
							            HEX_VDATA(0) <<
							            HEX_VDATA(0) <<
							            HEX_VDATA(0);
					}
					else {
						signatureFileVpu << HEX_VDATA(data[i]) <<
							            HEX_VDATA(data[i-1]) <<
							            HEX_VDATA(data[i-2]) <<
							            HEX_VDATA(data[i-3]);
					}
				}
				break;
			case 3: //64
				signatureFileVpu << "e64 m1 l" << DEC_VLEN(vlen) << " " << DEC_VDST(lreg_dst) << " 0x";
				for (int i = 511; i >= 7; i-=8) {
					if (i > ((vl*8)-1)) {
						signatureFileVpu << HEX_VDATA(0) <<
						                    HEX_VDATA(0) <<
						          	    HEX_VDATA(0) <<
						          	    HEX_VDATA(0) <<
						          	    HEX_VDATA(0) <<
						          	    HEX_VDATA(0) <<
						          	    HEX_VDATA(0) <<
						          	    HEX_VDATA(0);
					}
					else {
						signatureFileVpu << HEX_VDATA(data[i]) <<
						                    HEX_VDATA(data[i-1]) <<
						          	    HEX_VDATA(data[i-2]) <<
						          	    HEX_VDATA(data[i-3]) <<
						          	    HEX_VDATA(data[i-4]) <<
						          	    HEX_VDATA(data[i-5]) <<
						          	    HEX_VDATA(data[i-6]) <<
						          	    HEX_VDATA(data[i-7]);
					}
				}
				break;
			default:
				signatureFileVpu << "INVALID SEW";
			}
		signatureFileVpu << "\n";
	}
	signatureFileVpu.close();
}

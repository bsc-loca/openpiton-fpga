// See LICENSE for license details.

#ifndef DPI_TORTURE_VPU_H
#define DPI_TORTURE_VPU_H

#include <svdpi.h>
#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <string>

#define CAUSE_MISALIGNED_FETCH 0x0
#define CAUSE_FAULT_FETCH 0x1
#define CAUSE_ILLEGAL_INSTRUCTION 0x2
#define CAUSE_BREAKPOINT 0x3
#define CAUSE_MISALIGNED_LOAD 0x4
#define CAUSE_FAULT_LOAD 0x5
#define CAUSE_MISALIGNED_STORE 0x6
#define CAUSE_FAULT_STORE 0x7
#define CAUSE_USER_ECALL 0x8
#define CAUSE_SUPERVISOR_ECALL 0x9
#define CAUSE_HYPERVISOR_ECALL 0xa
#define CAUSE_MACHINE_ECALL 0xb

#define N_LANES 2
#define N_BANKS 5
#define VRF_DEPTH 256
#define VRF_ADDR 8
#define MAX_64_BIT_BLOCKS 64
#define MAX_VLEN 4096
#define MIN_SEW 8

#ifdef __cplusplus
extern "C" {
#endif

struct dpi_param_t {
	uint8_t lanes [2][5][8][512];
};

  extern void torture_dump_vpu (unsigned long long completed_valid, unsigned long long completed_illegal, unsigned long long vreg_dst, unsigned long long lreg_dst, unsigned long long sew, unsigned long long vlen, unsigned long long widening, unsigned long long reduction, unsigned long long reduction_wi, unsigned long long sb_id, svLogicVecVal *dpi_param);
  extern void torture_signature_init_vpu();
#ifdef __cplusplus
}
#endif

// Class to hold the torture signature
class tortureSignatureVpu {
    uint64_t * signature_vpu;
    std::ofstream signatureFileVpu; // file where the info is dumped
    std::string signatureFileNameVpu = "signature_vpu.txt";
    bool dump_valid_vpu = true;

public:
    tortureSignatureVpu()
    {
        signature_vpu = (uint64_t*) calloc(32,sizeof(uint64_t));
    }

    virtual ~tortureSignatureVpu() { free(signature_vpu); }

    void disable_vpu();

    void set_dump_file_name_vpu(std::string name);

    bool dump_check_vpu();

    void clear_output_vpu();

    void dump_file_vpu(unsigned long long completed_illegal, unsigned long long vreg_dst, unsigned long long lreg_dst, unsigned long long sew, unsigned long long vlen, unsigned long long widening, unsigned long long reduction, unsigned long long reduction_wi, unsigned long long sb_id, svLogicVecVal *dpi_param);
    };

    // Global torture_signature_vpu
    extern tortureSignatureVpu *torture_signature_vpu;

#endif

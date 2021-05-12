#include "dpi_torture.h"
#include <iostream>
#include <fstream>
#include <iomanip>
#include <string>

#define HEX_PC( x ) "0x" << std::setw(16) << std::setfill('0') << std::hex << (long)( x )
#define HEX_INST( x ) "0x" << std::setw(8) << std::setfill('0') << std::hex << (long)( x )
#define HEX_DATA( x ) "0x" << std::setw(16) << std::setfill('0') << std::hex << (long)( x )
#define DEC_DST( x ) "x" << std::setw(2) << std::setfill(' ') << std::dec << (long)( x )
#define DEC_PRIV( x ) std::setw(1) << std::dec << (long)( x )

// Global objects
tortureSignature *torture_signature;

// Global Variables
uint64_t last_PC=0, last_inst=0, last_data=0, last_dst=0;

// System Verilog DPI
void torture_dump (unsigned long long PC, unsigned long long inst, unsigned long long dst, unsigned long long reg_wr_valid, unsigned long long data, unsigned long long xcpt, unsigned long long xcpt_cause, unsigned long long csr_priv_lvl, unsigned long long csr_rw_data, unsigned long long csr_xcpt, unsigned long long csr_xcpt_cause, unsigned long long csr_tval){
    
    //Exceptions can come from the core (xcpt) or from the csrs (csr_xcpt)
    //And cannot happen both at once, so a simple OR suffices
    unsigned long long var_xcpt = xcpt | csr_xcpt;
    unsigned long long var_xcpt_cause = xcpt_cause | csr_xcpt_cause;
    //We need to extend the PC sign
    signed long long signedPC = PC;
    signedPC = signedPC << 24;
    signedPC = signedPC >> 24;


    if(torture_signature->dump_check()){
        if(reg_wr_valid) {
            torture_signature->update_signature(dst, data);
        }
        if((last_PC == signedPC) && (last_inst == inst) && (last_dst == dst) && (last_data == data))
        {

        }else{

            if (inst == 0x00000073) { //ecall
                var_xcpt = 1;
                if (csr_priv_lvl == 0) var_xcpt_cause = CAUSE_USER_ECALL;
                else if (csr_priv_lvl == 1) var_xcpt_cause = CAUSE_SUPERVISOR_ECALL;
                //else if (csr_priv_lvl == 3) var_xcpt_cause = CAUSE_MACHINE_ECALL;
            }
            else if (inst == 0x00100073) { //ebreak
                var_xcpt = 1;
                var_xcpt_cause = CAUSE_BREAKPOINT;
            }
            else if (inst == 0x9f019073) { //hardcoded tohost exception
                var_xcpt = 1;
                var_xcpt_cause = CAUSE_ILLEGAL_INSTRUCTION;
            }

            torture_signature->dump_file(signedPC, inst, dst, reg_wr_valid, var_xcpt, var_xcpt_cause, data, csr_priv_lvl, csr_rw_data, csr_tval);
            last_PC = signedPC;
            last_inst = inst;
            last_dst = dst;
            last_data = data;
        }
    }
}

void torture_signature_init(){
    torture_signature = new tortureSignature;
}

// Torture Signature
void tortureSignature::disable()
{
    dump_valid = false;
}

void tortureSignature::set_dump_file_name(std::string name)
{
    signatureFileName = name;
}

bool tortureSignature::dump_check()
{
    return dump_valid;
}

void tortureSignature::clear_output()
{
    signatureFile.open(signatureFileName, std::ios::out);
    signatureFile.close();
}

void tortureSignature::update_signature(uint64_t dst, uint64_t data){
    signature[dst] = data;
}

void tortureSignature::dump_file(uint64_t PC, uint64_t inst, uint64_t dst, uint64_t reg_wr_valid, uint64_t xcpt, uint64_t xcpt_cause, uint64_t data, uint64_t csr_priv_lvl, uint64_t csr_rw_data, uint64_t csr_tval){
    // file dumping
    
    signatureFile.open(signatureFileName, std::ios::out | std::ios::app);
    if ( xcpt_cause != CAUSE_INSTR_PAGE_FAULT){  // Neiel-leyva
        signatureFile << "core   0: " << HEX_PC(PC) << " (" << HEX_INST(inst) << ") " << "DASM(" << HEX_INST(inst) << ")" << "\n";
    }

    //exceptions
    if (xcpt) {
        signatureFile.close();
        if (inst == 0x9f019073) dump_xcpt(xcpt_cause, PC, 0); //Write tohost, 0 in tval
        else dump_xcpt(xcpt_cause, PC, csr_tval);
        signatureFile.open(signatureFileName, std::ios::out | std::ios::app);
    }
    else {
        signatureFile << DEC_PRIV(csr_priv_lvl) << " " << HEX_PC(PC) << " (" << HEX_INST(inst) << ")";
        if (reg_wr_valid) {
            signatureFile << " " << DEC_DST(dst) << " " << HEX_DATA(signature[dst]);
        }
        signatureFile << "\n";
    }
    signatureFile.close();
}

void tortureSignature::dump_xcpt(uint64_t xcpt_cause, uint64_t epc, uint64_t tval) {
    signatureFile.open(signatureFileName, std::ios::out | std::ios::app);
    signatureFile << "core   0: exception ";
    switch (xcpt_cause) {
        case CAUSE_MISALIGNED_FETCH:
            signatureFile << "trap_misaligned_fetch";
            break;
        case CAUSE_FAULT_FETCH:
            signatureFile << "trap_fault_fetch";
            break;
        case CAUSE_ILLEGAL_INSTRUCTION:
            signatureFile << "trap_illegal_instruction";
            break;
        case CAUSE_BREAKPOINT:
            signatureFile << "trap_breakpoint";
            break;
        case CAUSE_MISALIGNED_LOAD:
            signatureFile << "trap_load_address_misaligned";
            break;
        case CAUSE_FAULT_LOAD:
            signatureFile << "trap_fault_load";
            break;
        case CAUSE_MISALIGNED_STORE:
            signatureFile << "trap_store_address_misaligned";
            break;
        case CAUSE_FAULT_STORE:
            signatureFile << "trap_fault_store";
            break;
        case CAUSE_USER_ECALL:
            signatureFile << "trap_user_ecall";
            break;
        case CAUSE_SUPERVISOR_ECALL:
            signatureFile << "trap_supervisor_ecall";
            break;
        case CAUSE_MACHINE_ECALL:
            signatureFile << "trap_machine_ecall";
            break;
        case CAUSE_INSTR_PAGE_FAULT:
            //signatureFile << "trap_instruction_ecall";
            signatureFile << "trap_instruction_page_fault"; // Neiel-leyva
            break;
        case CAUSE_LD_PAGE_FAULT:
            signatureFile << "trap_load_page_fault";
            break;
        case CAUSE_ST_AMO_PAGE_FAULT:
            signatureFile << "trap_store_page_fault";
            break;
        default:
            signatureFile << "Error";
    }
    signatureFile << ", epc " << HEX_PC(epc) << "\n";

    //If it's not an ecall, print tval
    if (xcpt_cause != CAUSE_USER_ECALL && xcpt_cause != CAUSE_SUPERVISOR_ECALL && xcpt_cause != CAUSE_MACHINE_ECALL) {
        signatureFile << "core   0:           tval " << HEX_DATA(tval) << "\n";
    }

    signatureFile.close();
}


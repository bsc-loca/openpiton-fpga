package cov_core_defs;
import drac_pkg::*;
import riscv_pkg::*;
import ariane_pkg::*;
import wt_cache_pkg::*;

parameter TLB_ENTRIES = 16;
parameter NUM_IS_BRANCH_ENTRIES = 64;

typedef struct packed {
      logic [ASID_WIDTH-1:0] asid;
      logic [8:0]            vpn2;
      logic [8:0]            vpn1;
      logic [8:0]            vpn0;
      logic                  is_2M;
      logic                  is_1G;
      logic                  valid;
    } [TLB_ENTRIES-1:0] tlb_tags_q_t;

endpackage
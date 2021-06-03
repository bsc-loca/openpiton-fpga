onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/clk_i
add wave -noupdate /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/reset_l
add wave -noupdate /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/CSR_RETIRE
add wave -noupdate /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/CSR_PC
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/clk_i
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/rstn_i
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/req_fetch_icache_i
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/icache_resp_datablock_i
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/icache_resp_vaddr_i
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/icache_resp_valid_i
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/icache_req_ready_i
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/tlb_resp_xcp_if_i
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/icache_invalidate_o
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/icache_req_bits_idx_o
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/icache_req_kill_o
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/icache_req_valid_o
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/icache_req_bits_vpn_o
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/resp_icache_fetch_o
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/buffer_miss_o
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/icache_line_reg_q
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/icache_line_reg_d
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/icache_line_int
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/pc_buffer_d
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/pc_buffer_q
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/old_pc_req_d
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/old_pc_req_q
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/valid_buffer_q
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/valid_buffer_d
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/buffer_diff_int
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/icache_access_needed_int
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/state_int
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/next_state_int
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/do_request_int
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/new_addr_req
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/is_same_addr
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/a_valid_resp
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/to_NoReqi
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/kill
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/to_NoReq
add wave -noupdate -group icache_inf /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/icache_interface_inst/tlb_req_valid_o
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/clk_i
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/rst_ni
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/flush_i
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/en_i
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/miss_o
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/areq_i
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/areq_o
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/dreq_i
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/dreq_o
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/mem_rtrn_vld_i
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/mem_rtrn_i
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/mem_data_req_o
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/mem_data_ack_i
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/mem_data_o
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/cache_en_d
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/cache_en_q
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/vaddr_d
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/vaddr_q
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/paddr_is_nc
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/cl_hit
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/cache_rden
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/cache_wren
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/cmp_en_d
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/cmp_en_q
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/flush_d
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/flush_q
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/update_lfsr
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/inv_way
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/rnd_way
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/repl_way
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/repl_way_oh_d
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/repl_way_oh_q
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/all_ways_valid
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/inv_en
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/flush_en
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/flush_done
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/flush_cnt_d
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/flush_cnt_q
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/cl_we
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/cl_req
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/cl_index
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/cl_offset_d
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/cl_offset_q
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/cl_tag_d
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/cl_tag_q
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/cl_sel
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/vld_req
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/vld_we
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/vld_wdata
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/vld_rdata
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/vld_addr
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/state_d
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/state_q
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/hit_idx
add wave -noupdate -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_icache/tag_write_duplicate_test
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/clk_i
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/rst_ni
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/flush_i
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/update_i
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/lu_access_i
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/lu_asid_i
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/lu_vaddr_i
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/lu_content_o
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/lu_is_2M_o
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/lu_is_1G_o
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/lu_hit_o
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/tags_q
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/tags_n
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/content_q
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/content_n
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/vpn0
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/vpn1
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/vpn2
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/lu_hit
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/replace_en
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/plru_tree_q
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_mmu/i_itlb/plru_tree_n
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/clk
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/rst_n
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/transducer_l15_rqtype
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/transducer_l15_amo_op
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/transducer_l15_nc
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/transducer_l15_size
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/transducer_l15_threadid
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/transducer_l15_prefetch
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/transducer_l15_invalidate_cacheline
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/transducer_l15_blockstore
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/transducer_l15_blockinitstore
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/transducer_l15_l1rplway
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/transducer_l15_val
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/transducer_l15_address
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/transducer_l15_data
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/transducer_l15_data_next_entry
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/transducer_l15_csm_data
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_ack
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_header_ack
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_val
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_returntype
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_l2miss
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_error
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_noncacheable
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_atomic
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_threadid
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_prefetch
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_f4b
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_data_0
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_data_1
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_data_2
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_data_3
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_inval_icache_all_way
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_inval_dcache_all_way
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_inval_address_15_4
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_cross_invalidate
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_cross_invalidate_way
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_inval_dcache_inval
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_inval_icache_inval
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_inval_way
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_transducer_blockinitstore
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/transducer_l15_req_ack
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/noc1_out_rdy
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/noc2_in_val
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/noc2_in_data
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/noc3_out_rdy
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/dmbr_l15_stall
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/chipid
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/coreid_x
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/coreid_y
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/config_l15_read_res_data_s3
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/config_csm_en
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/config_system_tile_count_5_0
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/config_home_alloc_method
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/config_hmt_base
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/noc1_out_val
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/noc1_out_data
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/noc2_in_rdy
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/noc3_out_val
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/noc3_out_data
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_dmbr_l1missIn
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_dmbr_l1missTag
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_dmbr_l2responseIn
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_dmbr_l2missIn
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_dmbr_l2missTag
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_config_req_val_s2
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_config_req_rw_s2
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_config_write_req_data_s2
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/l15_config_req_address_s2
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/srams_rtap_data
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/rtap_srams_bist_command
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/rtap_srams_bist_data
add wave -noupdate -group L15 /cmp_top/system/chip/tile0/l15/config_system_tile_count
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/clk
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/rst_n
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/chipid
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/coreid_x
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/coreid_y
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/noc1_valid_in
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/noc1_data_in
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/noc1_ready_in
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/noc3_valid_in
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/noc3_data_in
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/noc3_ready_in
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/noc2_valid_out
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/noc2_data_out
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/noc2_ready_out
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/srams_rtap_data
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/rtap_srams_bist_command
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/rtap_srams_bist_data
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/data_rtap_data
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/dir_rtap_data
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/tag_rtap_data
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/state_rtap_data
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_cam_en_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_wr_state_en_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_wr_data_en_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_pending_ready_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_state_in_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_data_in_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_data_mask_in_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_inv_counter_rd_index_in_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_wr_index_in_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_addr_in_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_rd_en_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_wr_state_en_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_wr_data_en_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_inc_counter_en_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_state_in_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_data_in_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_data_mask_in_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_rd_index_in_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_wr_index_in_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_hit
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_hit_index
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/rd_mshr_state_out
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/rd_mshr_data_out
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/cam_mshr_data_out
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/pending_mshr_data_out
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_inv_counter_out
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_empty_slots
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_pending
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_pending_index
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/mshr_empty_index
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/state_rd_en_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/state_wr_en_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/state_rd_addr_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/state_wr_addr_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/state_data_in_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/state_data_mask_in_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/state_rd_en_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/state_wr_en_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/state_rd_addr_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/state_wr_addr_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/state_data_in_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/state_data_mask_in_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/state_data_out
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/tag_clk_en_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/tag_rdw_en_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/tag_addr_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/tag_data_in_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/tag_data_mask_in_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/tag_clk_en_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/tag_rdw_en_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/tag_addr_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/tag_data_in_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/tag_data_mask_in_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/tag_data_out
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/dir_clk_en_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/dir_rdw_en_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/dir_addr_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/dir_data_in_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/dir_data_mask_in_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/dir_clk_en_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/dir_rdw_en_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/dir_addr_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/dir_data_in_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/dir_data_mask_in_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/dir_data_out
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/data_clk_en_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/data_rdw_en_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/data_addr_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/data_data_in_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/data_data_mask_in_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/data_clk_en_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/data_rdw_en_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/data_addr_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/data_data_in_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/data_data_mask_in_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/data_data_out
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/smc_rd_en
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/smc_rd_diag_en
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/smc_wr_diag_en
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/smc_flush_en
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/smc_addr_op
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/smc_rd_addr_in
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/smc_wr_en_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/smc_wr_addr_in_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/smc_data_in_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/smc_wr_en_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/smc_wr_addr_in_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/smc_data_in_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/broadcast_counter_op_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/broadcast_counter_op_val_p1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/broadcast_counter_op_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/broadcast_counter_op_val_p2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/smc_hit
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/smc_data_out
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/smc_valid_out
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/smc_tag_out
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/broadcast_counter_zero1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/broadcast_counter_max1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/broadcast_counter_avail1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/broadcast_chipid_out1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/broadcast_x_out1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/broadcast_y_out1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/broadcast_counter_zero2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/broadcast_counter_max2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/broadcast_counter_avail2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/broadcast_chipid_out2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/broadcast_x_out2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/broadcast_y_out2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/reg_rd_en
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/reg_wr_en
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/reg_rd_addr_type
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/reg_wr_addr_type
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/reg_data_out
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/reg_data_in
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/l2_access_valid
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/l2_miss_valid
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/data_ecc_corr_error
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/data_ecc_uncorr_error
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/data_ecc_addr
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/error_addr
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/my_nodeid
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/core_max
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/csm_en
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/smt_base_addr
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/pipe2_valid_S1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/pipe2_valid_S2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/pipe2_valid_S3
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/pipe2_msg_type_S1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/pipe2_msg_type_S2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/pipe2_msg_type_S3
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/pipe2_addr_S1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/pipe2_addr_S2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/pipe2_addr_S3
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/active_S1
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/active_S2
add wave -noupdate -group L2 /cmp_top/system/chip/tile0/l2/active_S3
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/clk
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/reset
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/data_in
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/valid_in
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/yummy_out
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/data_out
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/valid_out
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/ready_in
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/yummy_out_f
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/valid_temp_f
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/count_f
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/is_one_f
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/is_two_or_more_f
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/count_plus_1
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/count_minus_1
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/up
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/down
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/valid_temp
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/count_temp
add wave -noupdate -group NOC2_Bootrom /cmp_top/system/chipset/chipset_impl/noc2_lagarto_bootrom_to_xbar/top_bits_zero_temp
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/clk_i
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/rst_ni
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/time_irq_i
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/flush_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/halt_csr_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/commit_ack_i
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/boot_addr_i
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/hart_id_i
add wave -noupdate -group CSR -expand /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/ex_i
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/wfi_detect_op_i
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/csr_op_i
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/csr_addr_i
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/csr_wdata_i
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/csr_rdata_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/dirty_fp_state_i
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/csr_write_fflags_i
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/pc_i
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/csr_exception_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/epc_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/eret_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/trap_vector_base_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/priv_lvl_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/fs_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/fflags_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/frm_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/fprec_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/irq_ctrl_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/en_translation_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/en_ld_st_translation_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/ld_st_priv_lvl_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/sum_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mxr_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/satp_ppn_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/asid_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/irq_i
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/ipi_i
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/debug_req_i
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/set_debug_pc_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/tvm_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/tw_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/tsr_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/debug_mode_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/single_step_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/icache_en_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/dcache_en_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/perf_addr_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/perf_data_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/perf_data_i
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/perf_we_o
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/read_access_exception
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/update_access_exception
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/privilege_violation
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/csr_we
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/csr_read
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/csr_wdata
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/csr_rdata
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/trap_to_priv_lvl
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/en_ld_st_translation_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/en_ld_st_translation_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mprv
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mret
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/sret
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/dret
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/dirty_fp_state_csr
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mstatus_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mstatus_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/satp_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/satp_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/dcsr_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/dcsr_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/csr_addr
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/priv_lvl_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/priv_lvl_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/debug_mode_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/debug_mode_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mtvec_rst_load_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/dpc_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/dpc_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/dscratch0_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/dscratch0_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/dscratch1_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/dscratch1_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mtvec_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mtvec_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/medeleg_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/medeleg_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mideleg_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mideleg_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mip_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mip_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mie_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mie_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mcounteren_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mcounteren_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mscratch_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mscratch_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mepc_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mepc_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mcause_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mcause_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mtval_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mtval_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/stvec_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/stvec_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/scounteren_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/scounteren_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/sscratch_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/sscratch_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/sepc_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/sepc_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/scause_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/scause_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/stval_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/stval_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/dcache_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/dcache_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/icache_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/icache_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/wfi_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/wfi_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/cycle_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/cycle_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/instret_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/instret_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/fcsr_q
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/fcsr_d
add wave -noupdate -group CSR /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/i_csr_regfile/mask
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/clk_i
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/rstn_i
add wave -noupdate -expand -group dcache_if -expand /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/req_cpu_dcache_i
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/dtlb_hit_i
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/dtlb_valid_i
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/paddr_i
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/mmu_req_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/mmu_vaddr_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/mmu_store_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/mmu_load_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/ld_mem_req_addr_index_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/ld_mem_req_addr_tag_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/ld_mem_req_wdata_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/ld_mem_req_valid_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/ld_mem_req_we_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/ld_mem_req_be_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/ld_mem_req_size_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/ld_mem_req_kill_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/ld_mem_req_tag_valid_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/st_mem_req_addr_index_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/st_mem_req_addr_tag_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/st_mem_req_wdata_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/st_mem_req_valid_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/st_mem_req_we_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/st_mem_req_be_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/st_mem_req_size_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/st_mem_req_kill_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/st_mem_req_tag_valid_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/atm_mem_req_valid
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/atm_mem_req_amo_op
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/atm_mem_req_size
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/atm_mem_req_operand_a
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/atm_mem_req_operand_b
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/ack_atm_i
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/dmem_resp_atm_data_i
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/dmem_resp_data_i
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/dmem_resp_valid_i
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/dmem_resp_nack_i
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/dmem_xcpt_ma_st_i
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/dmem_xcpt_ma_ld_i
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/dmem_xcpt_pf_st_i
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/dmem_xcpt_pf_ld_i
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/dmem_resp_gnt_st_i
add wave -noupdate -expand -group dcache_if -expand /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/resp_dcache_cpu_o
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/dmem_resp_data_result
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/mask
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/is_load_instr
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/is_store_instr
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/is_atm_instr
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/kill_mem_ope
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/mem_xcpt
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/dmem_req_addr_64
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/dmem_req_addr_reg
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/st_translation_req
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/mem_req_valid
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/str_rdy
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/trns_ena
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/type_of_op
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/type_of_op_reg
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/type_of_op_atm
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/type_of_op_atm_reg
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/dmem_xcpt_ma_st_reg
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/dmem_xcpt_ma_ld_reg
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/dmem_xcpt_pf_st_reg
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/dmem_xcpt_pf_ld_reg
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/state_atm
add wave -noupdate -expand -group dcache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/lagarto_dcache_interface_inst/atm_trans_req_valid
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/clk_i
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/rst_ni
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/enable_i
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/flush_i
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/flush_ack_o
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/miss_o
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/wbuffer_empty_o
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/amo_req_i
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/amo_resp_o
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/req_ports_i
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/req_ports_o
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/mem_rtrn_vld_i
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/mem_rtrn_i
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/mem_data_req_o
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/mem_data_ack_i
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/mem_data_o
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/cache_en
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/wr_cl_vld
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/wr_cl_nc
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/wr_cl_we
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/wr_cl_tag
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/wr_cl_idx
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/wr_cl_off
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/wr_cl_data
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/wr_cl_data_be
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/wr_vld_bits
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/wr_req
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/wr_ack
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/wr_idx
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/wr_off
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/wr_data
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/wr_data_be
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/miss_req
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/miss_ack
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/miss_nc
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/miss_we
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/miss_wdata
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/miss_paddr
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/miss_vld_bits
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/miss_size
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/miss_id
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/miss_replay
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/miss_rtrn_vld
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/miss_rtrn_id
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/rd_prio
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/rd_tag_only
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/rd_req
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/rd_ack
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/rd_tag
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/rd_idx
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/rd_off
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/rd_data
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/rd_vld_bits
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/rd_hit_oh
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/tx_paddr
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/tx_vld
add wave -noupdate -expand -group wt_dcache /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/wbuffer_data
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/clk_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rst_ni
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rd_tag_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rd_idx_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rd_off_i
add wave -noupdate -expand -group wt_dcache_mem -expand /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rd_req_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rd_tag_only_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rd_prio_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rd_ack_o
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rd_vld_bits_o
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rd_hit_oh_o
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rd_data_o
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wr_cl_vld_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wr_cl_nc_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wr_cl_we_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wr_cl_tag_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wr_cl_idx_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wr_cl_off_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wr_cl_data_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wr_cl_data_be_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wr_vld_bits_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wr_req_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wr_ack_o
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wr_idx_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wr_off_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wr_data_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wr_data_be_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wbuffer_data_i
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/bank_req
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/bank_we
add wave -noupdate -expand -group wt_dcache_mem -expand /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/bank_be
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/bank_idx
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/bank_idx_d
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/bank_idx_q
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/bank_off_d
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/bank_off_q
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/bank_wdata
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/bank_rdata
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rdata_cl
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rd_tag
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/vld_req
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/vld_we
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/vld_wdata
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/tag_rdata
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/vld_addr
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/vld_sel_d
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/vld_sel_q
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wbuffer_hit_oh
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wbuffer_be
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wbuffer_rdata
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rdata
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wbuffer_cmp_addr
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/cmp_en_d
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/cmp_en_q
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rd_acked
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/bank_collision
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rd_req_masked
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rd_req_prio
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rd_req
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wr_cl_off
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/wbuffer_hit_idx
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/rd_hit_idx
add wave -noupdate -expand -group wt_dcache_mem /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/tag_write_duplicate_test
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/clk_i
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rst_ni
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/cache_en_i
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/empty_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/req_port_i
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/req_port_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/miss_ack_i
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/miss_paddr_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/miss_req_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/miss_we_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/miss_wdata_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/miss_vld_bits_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/miss_nc_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/miss_size_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/miss_id_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/miss_rtrn_vld_i
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/miss_rtrn_id_i
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rd_tag_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rd_idx_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rd_off_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rd_req_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rd_tag_only_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rd_ack_i
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rd_data_i
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rd_vld_bits_i
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rd_hit_oh_i
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wr_cl_vld_i
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wr_cl_idx_i
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wr_req_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wr_ack_i
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wr_idx_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wr_off_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wr_data_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wr_data_be_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wbuffer_data_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/tx_paddr_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/tx_vld_o
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/tx_stat_d
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/tx_stat_q
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wbuffer_d
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wbuffer_q
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/valid
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/dirty
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/tocheck
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wbuffer_hit_oh
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/inval_hit
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/bdirty
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/next_ptr
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/dirty_ptr
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/hit_ptr
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wr_ptr
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/check_ptr_d
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/check_ptr_q
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/check_ptr_q1
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rtrn_ptr
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/tx_id
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rtrn_id
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/bdirty_off
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/tx_be
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wr_paddr
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rd_paddr
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rd_tag_d
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rd_tag_q
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rd_hit_oh_d
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rd_hit_oh_q
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/check_en_d
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/check_en_q
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/check_en_q1
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/full
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/dirty_rd_en
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rdy
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/rtrn_empty
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/evict
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/nc_pending_d
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/nc_pending_q
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/addr_is_nc
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wbuffer_wren
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/free_tx_slots
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wr_cl_vld_q
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wr_cl_vld_d
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wr_cl_idx_q
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wr_cl_idx_d
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wbuffer_check_mux
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wbuffer_dirty_mux
add wave -noupdate -expand -group wt_dcache_wb /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_wbuffer/wtag_comp
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/clk_i}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/rst_ni}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/cache_en_i}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/req_port_i}
add wave -noupdate -expand -group wt_dcache_ctrl -expand {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/req_port_o}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/miss_req_o}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/miss_ack_i}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/miss_we_o}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/miss_wdata_o}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/miss_vld_bits_o}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/miss_paddr_o}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/miss_nc_o}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/miss_size_o}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/miss_id_o}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/miss_replay_i}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/miss_rtrn_vld_i}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/wr_cl_vld_i}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/rd_tag_o}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/rd_idx_o}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/rd_off_o}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/rd_req_o}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/rd_tag_only_o}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/rd_ack_i}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/rd_data_i}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/rd_vld_bits_i}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/rd_hit_oh_i}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/state_d}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/state_q}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/address_tag_d}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/address_tag_q}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/address_idx_d}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/address_idx_q}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/address_off_d}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/address_off_q}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/vld_data_d}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/vld_data_q}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/save_tag}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/rd_req_d}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/rd_req_q}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/rd_ack_d}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/rd_ack_q}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/data_size_d}
add wave -noupdate -expand -group wt_dcache_ctrl {/cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/gen_rd_ports[1]/i_wt_dcache_ctrl/data_size_q}
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/clk_i
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/rst_ni
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/enable_i
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/flush_i
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/flush_ack_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/miss_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/wbuffer_empty_i
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/cache_en_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/amo_req_i
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/amo_resp_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/miss_req_i
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/miss_ack_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/miss_nc_i
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/miss_we_i
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/miss_wdata_i
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/miss_paddr_i
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/miss_vld_bits_i
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/miss_size_i
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/miss_id_i
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/miss_replay_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/miss_rtrn_vld_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/miss_rtrn_id_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/tx_paddr_i
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/tx_vld_i
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/wr_cl_vld_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/wr_cl_nc_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/wr_cl_we_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/wr_cl_tag_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/wr_cl_idx_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/wr_cl_off_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/wr_cl_data_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/wr_cl_data_be_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/wr_vld_bits_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/mem_rtrn_vld_i
add wave -noupdate -expand -group wt_dcache_miss_unit -expand /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/mem_rtrn_i
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/mem_data_req_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/mem_data_ack_i
add wave -noupdate -expand -group wt_dcache_miss_unit -expand /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/mem_data_o
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/state_d
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/state_q
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/mshr_d
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/mshr_q
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/repl_way
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/inv_way
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/rnd_way
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/mshr_vld_d
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/mshr_vld_q
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/mshr_vld_q1
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/mshr_allocate
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/update_lfsr
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/all_ways_valid
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/enable_d
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/enable_q
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/flush_ack_d
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/flush_ack_q
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/flush_en
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/flush_done
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/mask_reads
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/lock_reqs
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/amo_sel
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/miss_is_write
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/amo_req_d
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/amo_req_q
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/amo_data
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/amo_rtrn_mux
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/tmp_paddr
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/miss_port_idx
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/cnt_d
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/cnt_q
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/miss_req_masked_d
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/miss_req_masked_q
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/inv_vld
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/inv_vld_all
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/cl_write_en
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/load_ack
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/store_ack
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/amo_ack
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/mshr_rdrd_collision_d
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/mshr_rdrd_collision_q
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/mshr_rdrd_collision
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/tx_rdwr_collision
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/mshr_rdwr_collision
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/sc_fail
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/sc_pass
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/sc_backoff_over
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/store_sent
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/stores_inflight_d
add wave -noupdate -expand -group wt_dcache_miss_unit /cmp_top/system/chip/tile0/g_lagarto_m20_core/core/lagarto_m20/i_cache_subsystem/i_wt_dcache/i_wt_dcache_missunit/stores_inflight_q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {36461771 ps} 1}
quietly wave cursor active 1
configure wave -namecolwidth 207
configure wave -valuecolwidth 169
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {35858701 ps} {37064841 ps}

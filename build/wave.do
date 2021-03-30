onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/IO_FETCH_PC
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/clk_i
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/rstn_i
add wave -noupdate -group icache_if -expand -group {From FETCH} -color magenta -itemcolor magenta -subitemconfig {/cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/req_fetch_icache_i.valid {-color magenta -itemcolor magenta} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/req_fetch_icache_i.vaddr {-color magenta -itemcolor magenta} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/req_fetch_icache_i.invalidate_icache {-color magenta -itemcolor magenta} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/req_fetch_icache_i.invalidate_buffer {-color magenta -itemcolor magenta} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/req_fetch_icache_i.inval_fetch {-color magenta -itemcolor magenta}} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/req_fetch_icache_i
add wave -noupdate -group icache_if -expand -group {To FETCH} -color Plum -itemcolor Plum /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/resp_icache_fetch_o
add wave -noupdate -group icache_if -expand -group {From I-Cache} -color orange -itemcolor orange /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/icache_resp_datablock_i
add wave -noupdate -group icache_if -expand -group {From I-Cache} -color orange -itemcolor orange /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/icache_resp_vaddr_i
add wave -noupdate -group icache_if -expand -group {From I-Cache} -color orange -itemcolor orange /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/icache_resp_valid_i
add wave -noupdate -group icache_if -expand -group {From I-Cache} -color orange -itemcolor orange /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/icache_req_ready_i
add wave -noupdate -group icache_if -expand -group {From I-Cache} -color orange -itemcolor orange /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/tlb_resp_xcp_if_i
add wave -noupdate -group icache_if -expand -group {To I-Cache} -color cyan -itemcolor cyan /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/icache_invalidate_o
add wave -noupdate -group icache_if -expand -group {To I-Cache} -color cyan -itemcolor cyan /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/icache_req_bits_idx_o
add wave -noupdate -group icache_if -expand -group {To I-Cache} -color cyan -itemcolor cyan /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/icache_req_kill_o
add wave -noupdate -group icache_if -expand -group {To I-Cache} -color cyan -itemcolor cyan /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/icache_req_valid_o
add wave -noupdate -group icache_if -expand -group {To I-Cache} -color cyan -itemcolor cyan /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/icache_req_bits_vpn_o
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/buffer_miss_o
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/icache_line_reg_q
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/icache_line_reg_d
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/icache_line_int
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/pc_buffer_d
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/pc_buffer_q
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/old_pc_req_d
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/old_pc_req_q
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/valid_buffer_q
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/valid_buffer_d
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/buffer_diff_int
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/icache_access_needed_int
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/buffer_miss_int
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/state_int
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/next_state_int
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/do_request_int
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/new_addr_req
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/is_same_addr
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/a_valid_resp
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/to_NoReqi
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/kill
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/to_NoReq
add wave -noupdate -group icache_if /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/icache_interface_inst/tlb_req_valid_o
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/clk_i
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/rst_ni
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/flush_i
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/en_i
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/miss_o
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/areq_i
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/areq_o
add wave -noupdate -expand -group wt_icache -color cyan -itemcolor cyan -expand -subitemconfig {/cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/dreq_i.req {-color cyan -itemcolor cyan} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/dreq_i.kill_s1 {-color cyan -itemcolor cyan} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/dreq_i.kill_s2 {-color cyan -itemcolor cyan} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/dreq_i.vaddr {-color cyan -itemcolor cyan}} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/dreq_i
add wave -noupdate -expand -group wt_icache -color orange -itemcolor orange -expand -subitemconfig {/cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/dreq_o.ready {-color orange -itemcolor orange} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/dreq_o.valid {-color orange -itemcolor orange} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/dreq_o.data {-color orange -itemcolor orange} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/dreq_o.vaddr {-color orange -itemcolor orange} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/dreq_o.ex {-color orange -itemcolor orange}} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/dreq_o
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/mem_rtrn_vld_i
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/mem_rtrn_i
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/mem_data_req_o
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/mem_data_ack_i
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/mem_data_o
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/cache_en_d
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/cache_en_q
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/vaddr_d
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/vaddr_q
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/paddr_is_nc
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/cl_hit
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/cache_rden
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/cache_wren
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/cmp_en_d
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/cmp_en_q
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/flush_d
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/flush_q
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/update_lfsr
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/inv_way
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/rnd_way
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/repl_way
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/repl_way_oh_d
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/repl_way_oh_q
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/all_ways_valid
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/inv_en
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/flush_en
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/flush_done
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/flush_cnt_d
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/flush_cnt_q
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/cl_we
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/cl_req
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/cl_index
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/cl_offset_d
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/cl_offset_q
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/cl_tag_d
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/cl_tag_q
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/cl_sel
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/vld_req
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/vld_we
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/vld_wdata
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/vld_rdata
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/vld_addr
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/state_d
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/state_q
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/hit_idx
add wave -noupdate -expand -group wt_icache /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_cache_subsystem/i_wt_icache/tag_write_duplicate_test
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/clk_i
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/rst_ni
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/flush_i
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/update_i
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/lu_access_i
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/lu_asid_i
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/lu_vaddr_i
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/lu_content_o
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/lu_is_2M_o
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/lu_is_1G_o
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/lu_hit_o
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/tags_q
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/tags_n
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/content_q
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/content_n
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/vpn0
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/vpn1
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/vpn2
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/lu_hit
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/replace_en
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/plru_tree_q
add wave -noupdate -group iTLB /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/i_itlb/plru_tree_n
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/clk_i
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/rst_ni
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/flush_i
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/enable_translation_i
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/en_ld_st_translation_i
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/icache_areq_i
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/icache_areq_o
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/lsu_req_i
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/lsu_vaddr_i
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/lsu_is_store_i
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/lsu_dtlb_hit_o
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/lsu_valid_o
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/lsu_paddr_o
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/priv_lvl_i
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/ld_st_priv_lvl_i
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/sum_i
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/mxr_i
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/satp_ppn_i
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/asid_i
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/flush_tlb_i
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/itlb_miss_o
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/dtlb_miss_o
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/req_port_i
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/req_port_o
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/iaccess_err
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/daccess_err
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/ptw_active
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/walking_instr
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/ptw_error
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/update_vaddr
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/update_ptw_itlb
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/update_ptw_dtlb
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/itlb_lu_access
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/itlb_content
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/itlb_is_2M
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/itlb_is_1G
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/itlb_lu_hit
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/dtlb_lu_access
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/dtlb_content
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/dtlb_is_2M
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/dtlb_is_1G
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/dtlb_lu_hit
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/match_any_execute_region
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/lsu_vaddr_n
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/lsu_vaddr_q
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/dtlb_pte_n
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/dtlb_pte_q
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/lsu_req_n
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/lsu_req_q
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/lsu_is_store_n
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/lsu_is_store_q
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/dtlb_hit_n
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/dtlb_hit_q
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/dtlb_is_2M_n
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/dtlb_is_2M_q
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/dtlb_is_1G_n
add wave -noupdate -group MMU /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/i_mmu/dtlb_is_1G_q
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/clk_i
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/rstn_i
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/valid_fetch_i
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/id_cu_i
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/rr_cu_i
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/exe_cu_i
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/wb_cu_i
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/csr_cu_i
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/correct_branch_pred_i
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/debug_halt_i
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/debug_change_pc_i
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/debug_wr_valid_i
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/vpu_compl_instr_i
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/ovi_memop_sync_start_i
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/ovi_memop_sync_end_i
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/vpu_issue_valid_o
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/pipeline_ctrl_o
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/pipeline_flush_o
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/cu_if_o
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/invalidate_icache_o
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/invalidate_buffer_o
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/cu_rr_o
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/vpu_state_o
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/vpu_state_q
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/vpu_state_d
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/jump_enable_int
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/exception_enable_q
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/exception_enable_d
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/vector_load_inflight
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/vector_store_inflight
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/vector_gather_inflight
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/vector_scatter_inflight
add wave -noupdate -expand -group {Control Unit} /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/control_unit_inst/pipeline_ctrl_int
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/clk_i
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/rstn_i
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/reset_addr_i
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/stall_i
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/stall_debug_i
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/cu_if_i
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/invalidate_icache_i
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/invalidate_buffer_i
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/pc_jump_i
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/resp_icache_cpu_i
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/exe_if_branch_pred_i
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/retry_fetch_i
add wave -noupdate -expand -group IF -expand /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/req_cpu_icache_o
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/fetch_o
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/next_pc
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/pc
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/ex_addr_misaligned_int
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/ex_if_addr_fault_int
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/ex_if_page_fault_int
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/branch_predict_is_branch
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/branch_predict_taken
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/branch_predict_addr
add wave -noupdate -expand -group IF /cmp_top/system/chip/tile0/g_lagarto_m20_core/i_top_drac/datapath_inst/if_stage_inst/rst_load_reset_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {318500 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 523
configure wave -valuecolwidth 187
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {311270 ps} {316647 ps}

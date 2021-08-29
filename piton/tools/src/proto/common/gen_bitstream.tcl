
proc bitstream { g_root_dir } {
	
	mkdir -p $g_root_dir/bitstream
	open_checkpoint $g_root_dir/dcp/implementation.dcp
	write_bitstream -force ${g_root_dir}/bitstream/system.bit
}

bitstream $g_root_dir


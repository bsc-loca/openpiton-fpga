set g_project_dir ""
set g_root_dir $env::PITON_ROOT
set g_number_of_jobs $env::NUMBER_JOBS

if { $::argc > 0 } {
 set g_project_dir $::argv
 puts "project directory is $g_project_dir"
}

open_project ${g_project_dir}/${g_project_name}.xpr

proc synthesis { g_root_dir g_number_of_jobs} {

	set number_of_jobs $g_number_of_jobs
	reset_run synth_1
	launch_runs synth_1 -jobs ${g_number_of_jobs}
	puts "Waiting for the Out Of Context IPs to be synthesized..."
	wait_on_run synth_1
	open_run synth_1
	write_checkpoint -force $g_root_dir/dcp/synthesis.dcp
}

synthesis $g_root_dir $g_number_of_jobs

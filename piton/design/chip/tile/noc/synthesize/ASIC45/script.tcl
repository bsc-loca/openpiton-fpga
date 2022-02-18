#Get tcl shell path relative to current script
set tcl_path	[file dirname [info script]] 


set TARGET_PATH $env(TARGET_PATH)
set CELLIB $env(CELLIB)
set TOP $env(TOP)


#==============================================================================
set systemTimeStart [clock seconds]
puts ""
puts ""
puts "======================================================="
puts "======================================================="
puts "Starting at [clock format $systemTimeStart -format %H:%M:%S]"
puts "======================================================="
#==============================================================================

set_host_options -max_cores 8

set hdlin_sv_ieee_assignment_patterns 2

puts ""
puts ""
puts "========================="
puts "========================="
puts "SETTING LIBRARIES"
puts "========================="
puts "========================="


##--convert the ".lib" file to a ".db" file (DC works using ".db" library files
if {[file exists "${CELLIB}/NangateOpenCellLibrary_typical_ecsm.db"] == 0} {
   puts "convert the .lib file to a .db!";
   file mkdir $CELLIB
   enable_write_lib_mode
   read_lib "${CELLIB}/NangateOpenCellLibrary_typical_ecsm.lib"
   #write_lib $CELLIB/tcbn65lphpbwptc.db
   write_lib NangateOpenCellLibrary -f db -o $CELLIB/NangateOpenCellLibrary_typical_ecsm.db
}



##--define paths to files
#lpnd_dir
lappend search_path $CELLIB/
lappend search_path $TARGET_PATH/


#add here the path to the ".v" file
set target_library ""
lappend target_library NangateOpenCellLibrary_typical_ecsm.db

set synthetic_library [list dw_foundation.sldb]
set link_library [concat  [concat  * $target_library] $synthetic_library]

file mkdir $TARGET_PATH/WORK
file mkdir $TARGET_PATH/out

define_design_lib WORK -path $TARGET_PATH/WORK




file mkdir $TARGET_PATH/report

#/* do not allow wire type tri in the netlist */
set verilogout_no_tri ture

#/* to fix those pesky escaped names */
#/* the following variable was obsoleted in 3.1 */
#/* read_array_naming_style = %s_%d */
set bus_naming_style {%s[%d]}


set period  [ expr 0.4] 


# clear memory
remove_design -all


        


analayze_all_rtls



#general DC command
elaborate $TOP
link
   



  


   check_design
   create_clock [get_port clk] -name "clk"  -period $period 
   
   #set_wire_load_model -name "TSMC32K_Lowk_Conservative" -library "tcbn65lphpbwptc" 
   set_wire_load_mode "enclosed"
   #/* connect to all ports in the design, even if driven by the same net */
   
   set_fix_multiple_port_nets -all -constants -buffer_constants [get_designs *]

   #Enable DC-Ultra optimizations and embedded script
   compile_ultra   
                              
   #Write report files     
   report_power  > $TARGET_PATH/report/pow.txt
   report_area   > $TARGET_PATH/report/area.txt
   report_timing > $TARGET_PATH/report/tim.txt

   #/* always do change_names before write... */ 
   redirect change_names { change_names -rules verilog -hierarchy -verbose }

   #generate output file for IC Compiler for layout.
   write -format ddc -output $TARGET_PATH/out/top_synthesized.ddc
   #create gate-level verilog synthesized file.
   write -format verilog -output $TARGET_PATH/out/top_synthesized.v
   #write a design constraint file.
   write_sdc -nosplit $TARGET_PATH/out/top_synthesized.sdc


	

#exit	

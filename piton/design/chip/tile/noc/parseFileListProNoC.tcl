#set_param project.singleFileAddWarning.Threshold 500 

set PRONOC_ROOT "/home/alireza/work/git/OpenPiton/meep_openpiton/piton/design/chip/tile/noc"

set fp [open "${PRONOC_ROOT}/Flist.pronoc" r]
puts "$PRONOC_ROOT/Flist.pronoc"

set file_data [read $fp]
set data [split $file_data "\n"]

set PRONOC_RTL_FILES {}

set PRONOC_INCLUDE_DIRS {}

foreach line $data {
 #puts "${line}"
 
 
 if {[regexp {^\+incdir\+} $line match]} {
 	set dir [regsub {^\+incdir\+} $line ""] 
 	lappend PRONOC_INCLUDE_DIRS "${PRONOC_ROOT}/${dir}" 
    puts " include dir: ${PRONOC_ROOT}/${dir}"    
}
 
 
 set line [regsub -all  {\r} $line ""]
 set line [regsub -all  {\+.*} $line ""] 
 set line [regsub {cpp.*} $line ""]
 set line [regsub {//.*} $line ""]
 set line [regsub {#.*} $line ""]
 #set line [regsub {../*} $line ""]
 if  {[string trim $line] eq ""} then continue
 lappend PRONOC_RTL_FILES "${PRONOC_ROOT}/${line}" 
 puts "${PRONOC_ROOT}/${line}"
} 
close $fp


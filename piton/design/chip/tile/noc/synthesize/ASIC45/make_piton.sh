#!/bin/bash

SCRPT_FULL_PATH=$(realpath ${BASH_SOURCE[0]})
SCRPT_DIR_PATH=$(dirname $SCRPT_FULL_PATH)

PITON_ROOT=$(realpath $SCRPT_DIR_PATH/../../../../../../..) 
echo $PITON_ROOT


x=3
y=3


work="$PITON_ROOT/build/asic_piton"
top="piton_mesh"


conf="${x}x${y}"

#step 1 generate open piton router
filename=$SCRPT_DIR_PATH/../../pmesh_conf
line=$(head -n 1 $filename)
echo $line
if [ "$line" != "$conf" ]; then
	echo "rebuild openpiton for $conf mesh configuration"
bash -c "
	cd $PITON_ROOT/ 
	pwd
	source $PITON_ROOT/piton/ariane_setup.sh; 
	cd $PITON_ROOT/ 
	source $PITON_ROOT/piton/piton_settings.bash;  
	echo $ARIANE_ROOT
	sims -sys=manycore -x_tiles=$x -y_tiles=$y -msm_build -ariane -config_rtl=BSC_RTL_SRAMS -pronoc
"
	echo "$conf" > $filename
fi









list="proc analayze_all_rtls {} {\n	 analyze -format sverilog {"
lpnd=""

make_tcl () {
	fname=$1
	oname=$2
	local DIR="$(dirname "${fname}")"


	#echo $oname
	
	pwd

	
	while read line; do	
		# reading each line
		#echo $line
        cd $DIR
	
       
		if test -f "$DIR/$line"; then
			list="${list}$DIR/$line "
			# "$DIR/$line"   $PITON_ROOT/build/src_verilog/  
		fi
		line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//')"   # remove only the leading white spaces
		if [[ $line == -F* ]] || [[ $line == -f* ]] ; then 
			line=${line:2}   # Remove the first three chars (leaving 4..end)
			line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//')"   # remove only the leading white spaces
			#echo $line
	 		echo "got another file list $line"
			make_tcl "$DIR/$line" "$oname"
		fi

		if [[ $line == +incdir+* ]] ; then 
			line=${line:8}   # Remove the first three chars (leaving 4..end)
			lpnd="${lpnd} lappend search_path $DIR/$line\n"
		fi

	done < $fname

	
	#echo $list
	

}




mkdir -p  $work
filename=$SCRPT_DIR_PATH/file_list.f
tcl_name="$work/script.tcl"
rm -f $tcl_name


make_tcl $filename "$tcl_name"
list="\n${list}}\n}"
lpnd="\n${lpnd}\n"
echo -ne $list>>"$tcl_name"
echo -ne $lpnd>>"$tcl_name"
cat $SCRPT_DIR_PATH/script.tcl >> $tcl_name

#more $tcl_name
#exit

export TARGET_PATH=$work
export CELLIB="$SCRPT_DIR_PATH/stdcell_lib45"
export TOP="$top"
  
cd $work
dc_shell  -f script.tcl -o $work/out.log






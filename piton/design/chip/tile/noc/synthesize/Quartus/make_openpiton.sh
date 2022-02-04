#!/bin/bash

SCRPT_FULL_PATH=$(realpath ${BASH_SOURCE[0]})
SCRPT_DIR_PATH=$(dirname $SCRPT_FULL_PATH)

x=3
y=3


work="$PITON_ROOT/build/quartus_piton"
top="quartus_piton_mesh"


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





copy_filelist () {
	fname=$1
	local DIR="$(dirname "${fname}")"


	echo $DIR
	pwd

	
	while read line; do	
		# reading each line
		#echo $line
        cd $DIR
       
		if test -f "$DIR/$line"; then
			echo "copy $DIR/$line "
			cp "$DIR/$line"   $PITON_ROOT/build/src_verilog/  
		fi
		line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//')"   # remove only the leading white spaces
		if [[ $line == -F* ]] || [[ $line == -f* ]] ; then 
			line=${line:2}   # Remove the first three chars (leaving 4..end)
			line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//')"   # remove only the leading white spaces
			echo $line
	 		echo "got another file list $line"
			copy_filelist "$DIR/$line"
		fi
	done < $fname
}






make_qsf () {
	fname=$1
	oname=$2
	local DIR="$(dirname "${fname}")"


	echo $oname
	
	pwd

	
	while read line; do	
		# reading each line
		#echo $line
        cd $DIR
	
       
		if test -f "$DIR/$line"; then
			echo "set_global_assignment -name SYSTEMVERILOG_FILE $DIR/$line">>"$oname"
			# "$DIR/$line"   $PITON_ROOT/build/src_verilog/  
		fi
		line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//')"   # remove only the leading white spaces
		if [[ $line == -F* ]] || [[ $line == -f* ]] ; then 
			line=${line:2}   # Remove the first three chars (leaving 4..end)
			line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//')"   # remove only the leading white spaces
			#echo $line
	 		echo "got another file list $line"
			make_qsf "$DIR/$line" "$oname"
		fi

		if [[ $line == +incdir+* ]] ; then 
			line=${line:8}   # Remove the first three chars (leaving 4..end)
			echo "set_global_assignment -name SEARCH_PATH $DIR/$line">>"$oname"
		fi

	done < $fname
}




mkdir -p  $work
filename=$SCRPT_DIR_PATH/file_list.f
qsf_name="$work/openpiton_mesh.qsf"
cp -f $SCRPT_DIR_PATH/openpiton_mesh.qsf $qsf_name

echo "set_global_assignment -name TOP_LEVEL_ENTITY $top">>$qsf_name
make_qsf $filename "$qsf_name"




if [[ -z "${Quartus_bin}" ]]; then
  #"Some default value because Quartus_bin is undefined"
  Quartus_bin="/home/alireza/intelFPGA_lite/18.1/quartus/bin"
else
  Quartus_bin="${Quartus_bin}"
fi

cd $work
$Quartus_bin/quartus_map --64bit openpiton_mesh --read_settings_files=on
$Quartus_bin/quartus_fit --64bit openpiton_mesh --read_settings_files=on 
$Quartus_bin/quartus_asm --64bit openpiton_mesh --read_settings_files=on
$Quartus_bin/quartus_sta --64bit openpiton_mesh	

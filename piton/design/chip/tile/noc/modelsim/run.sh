#!/bin/bash	
	
SCRPT_FULL_PATH=$(realpath ${BASH_SOURCE[0]})
SCRPT_DIR_PATH=$(dirname $SCRPT_FULL_PATH)

x=8
y=8
conf="${x}x${y}"



if [ $# -eq 0 ]
  then
    echo "Usage ./run.sh  injection_ratio %\n"
	exit
fi


filename=$SCRPT_DIR_PATH/../pmesh_conf

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









#run simulation
	cd $SCRPT_DIR_PATH
	rm -Rf $PITON_ROOT/build/rtl_work		
	mkdir -p $PITON_ROOT/build/rtl_work		
			sed -i "s/ INJRATIO=[[:digit:]]\+/ INJRATIO=$1/" sim_param.sv
			vsim -c -do model.tcl 
			wait
			

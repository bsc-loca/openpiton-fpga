#!/bin/bash

SCRPT_FULL_PATH=$(realpath ${BASH_SOURCE[0]})
SCRPT_DIR_PATH=$(dirname $SCRPT_FULL_PATH)


APP_SCALAR_PATH=$PITON_ROOT/piton/design/chip/tile/noc/benchmark/app-scalar
result_dir=$PITON_ROOT/build/verilator/results
image_dir=$PITON_ROOT/build/verilator/images
PITON_ROOT_PATH=$PITON_ROOT
VERILATOR_MODEL_ROOT=$PITON_ROOT/build/verilator/models/





#list of applications
my_apps=(  "mt-axpy:1024" "mt-vvadd:128" "mt-matmul:64" "mt-spmv:64"  "mt-somier:15" )

x=4
y=4
compile_app=0
compile_verilator=0
run_verilator=0


# link in adapted syscalls.c such that the benchmarks can be used in the OpenPiton TB
  cd $APP_SCALAR_PATH/common_ariane
  rm syscalls.c util.h
  ln -s ${PITON_ROOT}/piton/verif/diag/assembly/include/riscv/ariane/syscalls.c
  ln -s ${PITON_ROOT}/piton/verif/diag/assembly/include/riscv/ariane/util.h



help="./run [options]  
    
      [options]
      -h show this help 
      -x <int number>  : Enter the number of tile in x dimention
                         The default value is 4.
      -y <int number>  : Enter the number of tile in y dimention
                         The default value is 4.
      -c               : Comple scalar applications
      -v               : Compile verilator models. 
      -r               : Run all models
      "  
      #EOF

while getopts "h?x:y:cvr" opt; do
  case "$opt" in
    h|\?)
      echo "$help"     
      exit 0
      ;;
    x) x=$OPTARG
      ;; 
    y) y=$OPTARG
      ;;  
    c) compile_app=1
      ;; 
    v) compile_verilator=1
      ;;  
    r) run_verilator=1
      ;;            
  esac
done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift


if [ $compile_app == 0 ] && [ $compile_verilator == 0 ] && [ $run_verilator == 0 ]; then 
  echo "$help" 
  echo "
  You need to select atleast of -c -v -r options
  "   
fi










compile_benchmarks(){

    for app in "${my_apps[@]}" ; do
        name="${app%%:*}"
        size="${app##*:}"
        for n in 16 2 4 8 1 ; do
            out=$result_dir/log/$name
            mkdir -p $out
            
            echo "*********************compile $name --size:$size for $n core************"  
            #compile benchmarks
            cd $APP_SCALAR_PATH/$name; bash ./ariane-compile.sh  $n $size 
            wait
            #generate image file
            cd $PITON_ROOT/build
            rm diag.ev
            rm mem.image
            rm symbol.tbl 
               
               bash -c "
               
               export PITON_ROOT=$PITON_ROOT_PATH
            cd $PITON_ROOT_PATH
            source ./piton/ariane_setup.sh 
               source $PITON_ROOT/piton/piton_settings.bash;  
               
               cd $PITON_ROOT/build
            sims -sys=manycore  -ariane -precompiled ${name}${n}.riscv -asm_diag_root $APP_SCALAR_PATH/${name}/bin/ 
            wait
            "
            wait
            #copy image files            
            mkdir -p $image_dir/$name$n
            cp diag.ev $image_dir/$name$n/
            cp mem.image $image_dir/$name$n/
	    cp symbol.tbl $image_dir/$name$n/
                            
        done     
    done

}



# Declare a string array
#arrVar=("org")

arrVar=()

get_pronoc_model_names(){
   for file in $SCRPT_DIR_PATH/pronoc_param/*.v; do    
        
        echo "$file"
        filename=$(basename  $file)
        echo "$filename"
        name="${filename%%.*}"
        echo "$name"
        # Add new element at the end of the array
    	arrVar+=("$name")
    done

}



run_cmd="+wait_cycle_to_kill=10 +dowarningfinish +doerrorfinish +spc_pipe=0 +vcs+dumpvarsoff +finish_mask=0x1111111111111111 +TIMEOUT=8000000 +tg_seed=0  +dv_root=/users/amonemi/openpiton_lagarto/piton "



sim_bulid (){
    
    arg=$1
    echo "************Generate model ************************"
    echo "sims -sys=manycore -x_tiles=$x -y_tiles=$y -vlt_build -ariane $arg"
    
    bash -c "
export PITON_ROOT=$PITON_ROOT_PATH

cd $PITON_ROOT_PATH
source ./piton/ariane_setup.sh 

cd $PITON_ROOT_PATH/build/

sims -sys=manycore -x_tiles=$x -y_tiles=$y -vlt_build -ariane  $arg

wait;

" 
wait;

}




make_model(){
   name=$1
   arg=$2

   path=$VERILATOR_MODEL_ROOT/$name

    #delete old files
    rm -r $PITON_ROOT_PATH/build/manycore/rel-0.1/obj_dir/*   
    rm -rf $path 
    mkdir -p $path 
    sim_bulid $arg     
    cp $PITON_ROOT/build/manycore/rel-0.1/obj_dir/Vcmp_top  $path/Vcmp_top
   

   

}


make_all_models(){
    #step1 create deafult model
    make_model "org"

    #step2 create pronoc models
    for file in $SCRPT_DIR_PATH/pronoc_param/*.v; do    
        
        echo "$file"
        filename=$(basename  $file)
        echo "$filename"
        name="${filename%%.*}"
        echo "$name"
        rm $PITON_ROOT/piton/design/chip/tile/noc/noc_localparam.v
        cp $file $PITON_ROOT/piton/design/chip/tile/noc/noc_localparam.v
        make_model  "$name" "-pronoc"
    done
}





sim_run(){
    bin=$1 
    path=$2
   
    cd $path;
    traps=$(perl $SCRPT_DIR_PATH/get_traps.pl)

    echo "***************run model $bin in $path**************"        

    bash -c "
    export PITON_ROOT=$PITON_ROOT_PATH

    cd $PITON_ROOT_PATH
    source ./piton/ariane_setup.sh 

    cd $path
    echo \"cd $path $bin $run_cmd $traps\"

    $bin $run_cmd $traps > $path/log

" &    


}



run_all_models(){    
   # Iterate the loop to read and print each array element
   for model in "${arrVar[@]}"
   do
       echo "***********************model :$model ******************"
       for app in "${my_apps[@]}" ; do
           name="${app%%:*}"
           size="${app##*:}"
           echo "***********************app :$name size $size ******************"
           for n in 16 2 4 8 1 ; do
           #copy models
           path=$image_dir/$name$n
           bin=$VERILATOR_MODEL_ROOT/$model/Vcmp_top            
           #run all app in parallel
           sim_run $bin $path         
           done  
           wait
           #copy results
           for n in 16 2 4 8 1 ; do
           mkdir -p $result_dir/${model}/${app}${n}
           cp -r   $path/fake_uart.log   $result_dir/${model}/${app}${n}
           tail -n 50 $path/log > $result_dir/${model}/log_end-${app}${n}
           done        
        done
    done
    
    echo "simulation is done!"

}



	#arrVar+=("org")  #piton noc
	get_pronoc_model_names



if [ $compile_app == 1 ]; then 

    echo "******************************"
    echo "*"
    echo "*"
    echo "*"
    echo "*          compile_benchmarks "
    echo "*"
    echo "*"
    echo "*"
    echo "*"
    echo "******************************"


    compile_benchmarks

fi


if [ $compile_verilator == 1 ]; then

    echo "******************************"
    echo "*"
    echo "*"
    echo "*"
    echo "*         make_verilator models"
    echo "*"
    echo "*"
    echo "*"
    echo "*"
    echo "******************************"


    make_all_models;
    wait

fi

if [ $run_verilator == 1 ]; then

    echo "******************************"
    echo "*"
    echo "*"
    echo "*"
    echo "*          RUN                "
    echo "*"
    echo "*"
    echo "*"
    echo "*"
    echo "******************************"
    
    run_all_models
    
fi

echo "Done!"


echo 'Test to check that all configurations run successfully'

SIMS='sims -sys=manycore -x_tiles=1 -y_tiles=1 -config_rtl=FPU_ZAGREB -config_rtl=BSC_RTL_SRAMS -no_verbose'
rm -f result.log status.log

echo 'Available configs:'
echo '0. lagarto '
CORE_CONFIG+=(" -lagarto ")
echo '1. lagarto + sa_hevc'
CORE_CONFIG+=(" -lagarto -sa_hevc_enable ")
echo '2. lagarto + sa_nn'
CORE_CONFIG+=(" -lagarto -sa_nn_enable ")
echo '3. lagarto + sa_nn + sa_hevc'
CORE_CONFIG+=(" -lagarto -sa_nn_enable -sa_hevc_enable ")
echo '4. lagarto + vpu'
CORE_CONFIG+=(" -lagarto -vpu_enable ")
echo '5. lagarto + vpu + sa_hevc'
CORE_CONFIG+=(" -lagarto -vpu_enable -sa_hevc_enable ")
echo '6. lagarto + vpu + sa_nn'
CORE_CONFIG+=(" -lagarto -vpu_enable -sa_nn_enable ")
echo '7. lagarto + vpu + sa_nn + sa_hevc'
CORE_CONFIG+=(" -lagarto -vpu_enable -sa_nn_enable -sa_hevc_enable ")
echo 'All of them support cov and cosim flag'

FEATURES+=(" ")
FEATURES+=(" -cov ")
FEATURES+=(" -cosim -config_rtl=OPENPITON_LAGARTO_COMMIT_LOG")
FEATURES+=(" -cov -cosim -config_rtl=OPENPITON_LAGARTO_COMMIT_LOG")

for features_id in $(seq 0 $((${#FEATURES[@]} - 1)))
do
    for config_id in $(seq 0 $((${#CORE_CONFIG[@]} - 1)))
    do
        rm -rf manycore
        echo "Running: " $SIMS " -msm_build " ${CORE_CONFIG[$config_id]} ${FEATURES[$features_id]}
        $SIMS -msm_build ${CORE_CONFIG[$config_id]} ${FEATURES[$features_id]} > /dev/null
        echo "Running: " $SIMS " -msm_run rv64ui-p-addi.S -lagarto -precompiled" ${CORE_CONFIG[$config_id]} ${FEATURES[$features_id]}
        $SIMS -msm_run rv64ui-p-addi.S -lagarto -precompiled ${FEATURES[$features_id]} > status.log
        if grep -q 'Simulation -> PASS (HIT GOOD TRAP)' status.log 
        then
          echo "PASS " ${CORE_CONFIG[$config_id]} ${FEATURES[$features_id]} |tee -a result.log
        else
          echo "FAILED" ${CORE_CONFIG[$config_id]} ${FEATURES[$features_id]} |tee -a result.log
          exit 1
        fi
    done
done

cat result.log

#echo '5. ariane core without support for cosim and cov'
#sims -sys=manycore -x_tiles=1 -y_tiles=1 -msm_build -lagarto -config_rtl=BSC_RTL_SRAMS -config_rtl=FPU_ZAGREB

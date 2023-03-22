echo 'Test to check that all configurations run successfully'

SIMS='sims -sys=manycore -x_tiles=1 -y_tiles=1 -config_rtl=FPU_ZAGREB -config_rtl=BSC_RTL_SRAMS -config_rtl=MINIMAL_MONITORING'
rm result.log status.log

echo 'Available configs:'
echo '0. lagarto '
CORE_CONFIG+=(" -lagarto ")
echo '1. lagarto + sa'
CORE_CONFIG+=(" -lagarto -sa_enable ")
echo '2. lagarto + vpu '
CORE_CONFIG+=(" -lagarto -vpu_enable ")
echo '3. lagarto + vpu + sa'
CORE_CONFIG+=(" -lagarto -vpu_enable -sa_enable ")
echo 'All of them support cov flag'
echo 'Only the ones with VPU support cosim flags'

FEATURES+=(" ")
FEATURES+=(" -cov ")

for features_id in $(seq 0 $((${#FEATURES[@]} - 1)))
do
    for config_id in $(seq 0 $((${#CORE_CONFIG[@]} - 1)))
    do
        rm -rf manycore
        echo "Running: " $SIMS " -msm_build " ${CORE_CONFIG[$config_id]} ${FEATURES[$features_id]}
        $SIMS -msm_build ${CORE_CONFIG[$config_id]} ${FEATURES[$features_id]} > /dev/null
        echo "Running: " $SIMS " -msm_run rv64ui-p-addi.S -lagarto -precompiled" ${CORE_CONFIG[$config_id]} ${FEATURES[$features_id]}
        $SIMS -msm_run rv64ui-p-addi.S -lagarto -precompiled ${CORE_CONFIG[$config_id]} ${FEATURES[$features_id]} > status.log
        if grep -q 'Simulation -> PASS (HIT GOOD TRAP)' status.log 
        then
          echo "PASS " ${CORE_CONFIG[$config_id]} ${FEATURES[$features_id]} |tee -a result.log
        else
          echo "FAILED" ${CORE_CONFIG[$config_id]} ${FEATURES[$features_id]} |tee -a result.log
          exit 1
        fi
    done
done

FEATURES=(" -cosim -config_rtl=OPENPITON_LAGARTO_COMMIT_LOG")
FEATURES+=(" -cov -cosim -config_rtl=OPENPITON_LAGARTO_COMMIT_LOG")
# For cosim purposes, only cores + VPU are supported
for features_id in $(seq 0 $((${#FEATURES[@]} - 1)))
do
    for config_id in $(seq 2 3)
    do
        rm -rf manycore
        echo "Running: " $SIMS " -msm_build " ${CORE_CONFIG[$config_id]} ${FEATURES[$features_id]}
        $SIMS -msm_build ${CORE_CONFIG[$config_id]} ${FEATURES[$features_id]} > /dev/null

        echo "Running: " $SIMS " -msm_run rv64ui-p-addi.S -lagarto -precompiled" ${CORE_CONFIG[$config_id]} ${FEATURES[$features_id]}
        $SIMS -msm_run rv64ui-p-addi.S -lagarto -precompiled ${CORE_CONFIG[$config_id]} ${FEATURES[$features_id]} > status.log
        if grep -q 'Simulation -> PASS (HIT GOOD TRAP)' status.log
        then
          echo "PASS" ${CORE_CONFIG[$config_id]} ${FEATURES[$features_id]} |tee -a result.log
        else
          echo "FAILED" ${CORE_CONFIG[$config_id]} ${FEATURES[$features_id]} |tee -a result.log
          exit 1
        fi
    done
done

#echo '5. ariane core without support for cosim and cov'
#sims -sys=manycore -x_tiles=1 -y_tiles=1 -msm_build -lagarto -config_rtl=BSC_RTL_SRAMS -config_rtl=FPU_ZAGREB




sims -sys=manycore -x_tiles=1 -y_tiles=1 -msm_build -lagarto -config_rtl=BSC_RTL_SRAMS -config_rtl=FPU_ZAGREB -config_rtl=OPENPITON_LAGARTO_COMMIT_LOG

rm isa_test_result.csv
echo "ISA Test, Resuilt"

while IFS="" read -r p || [ -n "$p" ]
do
  printf 'Running ISA TEST: %s\n' "$p"
  sims -sys=manycore -msm_run -x_tiles=1 -y_tiles=1 $p.S -lagarto -precompiled 
  if grep 'Simulation -> PASS (HIT GOOD TRAP)' status.log
  then
    echo "$p, PASS" >> isa_test_result.csv
  else
    echo "$p, FAILED" >> isa_test_result.csv
  fi

done < isa_test_list.txt

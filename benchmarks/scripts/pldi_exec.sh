#/bin/csh

foreach i ("benchmark3_gasol_gas.txt" "benchmark3_gasol_size.txt" "benchmark3_greedy.txt" "benchmark3_sat_all_greedy.txt" "benchmark3_sat_base_greedy.txt")
 echo $i
 time ../../bin/forves -opt_rep 20 -pipeline_rep 20 -opt size -mu basic -su basic -ms basic -ss basic -ssv_c basic -mem_c po -strg_c po -sha3_c basic < ../pldi/$i > /tmp/res_$i
end

foreach i ("benchmark4_gasol_gas.txt" "benchmark4_gasol_size.txt" "benchmark4_greedy.txt" "benchmark4_sat_all_greedy.txt" "benchmark4_sat_base_greedy.txt")
 echo $i
 time ../../bin/forves -opt_rep 20 -pipeline_rep 20 -opt size -mu basic -su basic -ms basic -ss basic -ssv_c basic -mem_c po -strg_c po -sha3_c basic < ../pldi/$i > /tmp/res_$i
end

foreach i ("benchmark5_gasol_gas.txt" "benchmark5_gasol_size.txt" "benchmark5_greedy.txt" "benchmark5_sat_all_greedy.txt" "benchmark5_sat_base_greedy.txt")
 echo $i
 time ../../bin/forves -opt_rep 20 -pipeline_rep 20 -opt size -mu basic -su basic -ms basic -ss basic -ssv_c basic -mem_c po -strg_c po -sha3_c basic < ../pldi/$i > /tmp/res_$i
end

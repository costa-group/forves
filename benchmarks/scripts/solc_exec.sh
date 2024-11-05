#/bin/csh

foreach i ("blockTraces_dec_1_2022_nodups_adapted.txt")
  echo $i
  time ../../bin/forves -opt_rep 20 -pipeline_rep 20 -opt size -mu basic -su basic -ms basic -ss basic -ssv_c basic -mem_c po -strg_c po -sha3_c basic < ../solc/$i > /tmp/solc_$i
end

foreach i ("blockTraces_dec_1_2022_nodups_adapted.txt")
  echo "$i (solc extended optimizations)"
  time ../../bin/forves -opt_rep 20 -pipeline_rep 20 -opt solc -mu basic -su basic -ms basic -ss basic -ssv_c basic -mem_c po -strg_c po -sha3_c basic < ../solc/$i > /tmp/solc_full_pipeline_$i
end
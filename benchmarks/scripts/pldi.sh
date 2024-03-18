#/bin/csh

foreach i ( `ls ~/tmp/evm/evaluation_evm/` )
  foreach j (`ls ~/tmp/evm/evaluation_evm/$i`)
    set out="${i:h}_${j:h}.txt"
    echo $out;
    python3 gen_tests_for_ocaml.py ~/tmp/evm/evaluation_evm/${i:h}/${j:h} > /dev/null
  end
end
   

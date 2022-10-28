#! /bin/bash

for f in ./blocks/*.txt;  do
    nlines=`wc -l < $f`
    nblocks=$(( nlines/3 ))
	echo "$f"
	echo "($nblocks blocks)";
	echo '-----------------------------------------------------'
	echo '| Dataset and checker          |  #Yes   | Time (s) |'
	echo '-------------------------------|---------|----------|'
	start=`date +%s%N`
	n0=`./bin/checker -alg 0 < $f | grep true | wc -l`
	end=`date +%s%N`
	ex_time_ns=`expr $end - $start`
	ex_time0_s=`echo "scale=2; $ex_time_ns / 1000000000" | bc`
 
    start=`date +%s%N`
	n1=`./bin/checker -alg 1 < $f | grep true | wc -l`
	end=`date +%s%N`
	ex_time_ns=`expr $end - $start`
	ex_time1_s=`echo "scale=2; $ex_time_ns / 1000000000" | bc`
	
	start=`date +%s%N`
	n2=`./bin/checker -alg 2 < $f | grep true | wc -l`
	end=`date +%s%N`
	ex_time_ns=`expr $end - $start`
	ex_time2_s=`echo "scale=2; $ex_time_ns / 1000000000" | bc`
	
	echo "| evm_eq_block_chkr (CHKR)     |     $n0 |      $ex_time0_s |"
    echo "| evm_eq_block_chkr' (CHKR')   |     $n1 |      $ex_time1_s |"
    echo "| evm_eq_block_chkr'' (CHKR'') |     $n2 |      $ex_time2_s |"
    echo '-----------------------------------------------------'
	echo
done;

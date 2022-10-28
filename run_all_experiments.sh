#! /bin/bash

for f in ./blocks/*.txt;  do
    nlines=`wc -l < $f`
    nblocks=$(( nlines/3 ))
	echo "$f"
	echo "($nblocks blocks)";
	echo '---------------------------------'
	n0=`./bin/checker -alg 0 < $f | grep true | wc -l`
	n1=`./bin/checker -alg 1 < $f | grep true | wc -l`
	n2=`./bin/checker -alg 2 < $f | grep true | wc -l`
	echo "* evm_eq_block_chkr (CHKR): $n0"
    echo "* evm_eq_block_chkr' (CHKR') : $n1"
    echo "* evm_eq_block_chkr'' (CHKR'') : $n2"
	echo
done;

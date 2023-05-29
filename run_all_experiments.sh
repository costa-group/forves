#! /bin/bash

TMPFILE=/tmp/forves_out

for f in ./blocks/*.txt;  do
    echo "$f"
    
    start=`date +%s%N`
    ./bin/checker -alg 0 < $f > $TMPFILE
    end=`date +%s%N`
    nblocks=`wc -l < $TMPFILE`
    n0=`cat $TMPFILE | grep true | wc -l`
    ex_time_ns=`expr $end - $start`
    ex_time0_s=`echo "scale=2; $ex_time_ns / 1000000000" | bc`
 
    start=`date +%s%N`
    ./bin/checker -alg 2 < $f > $TMPFILE
    end=`date +%s%N`
    n2=`cat $TMPFILE | grep true | wc -l`
    ex_time_ns=`expr $end - $start`
    ex_time2_s=`echo "scale=2; $ex_time_ns / 1000000000" | bc`

    echo "($nblocks blocks)";
    echo '--------------------------------'
    echo '| Checker |  #Yes   | Time (s) |'
    echo '|---------|---------|----------|'    
    printf "| CHKR    | %7s | %8s |\n" $n0 $ex_time0_s
    printf "| CHKR^s  | %7s | %8s |\n" $n2 $ex_time2_s
    echo '--------------------------------'
    echo
done;

#! /bin/bash

# $1: filename of benchmarks
# $2: filename with results
mostrar_resultados () {
  local ntrue=`cat $2 | grep true | wc -l`
  local nfalse=`cat $2 | grep false | wc -l`
  local n=`expr $ntrue + $nfalse`
  local percentage=$( echo "scale=3; $ntrue * 100 / $n" | bc -l )
  echo "$1 ($n blocks)"
  echo " * true: $ntrue, $percentage % (missing $nfalse)"
  echo "   time: $3 seconds"
  echo
}


TMPFILE=`mktemp`
echo $TMPFILE


echo "____________________"
echo "| MEMORY & STORAGE |"
echo "--------------------"
for f in ./benchmarks/memory_and_storage/*gas*.txt; do
    start=`date +%s.%N`
    ./bin/checker -opt all -opt_rep 5 -pipeline_rep 5 -mu basic -su basic -ms basic -ss basic -ssv_c basic -mem_c po -strg_c po -sha3_c trivial -i $f -o $TMPFILE
    end=`date +%s.%N`
    runtime=$( echo "$end - $start" | bc -l )
    mostrar_resultados $f  $TMPFILE $runtime
done;
for f in ./benchmarks/memory_and_storage/*size*.txt; do
    start=`date +%s.%N`
    ./bin/checker -opt all_size -opt_rep 5 -pipeline_rep 5 -mu basic -su basic -ms basic -ss basic -ssv_c basic -mem_c po -strg_c po -sha3_c trivial -i $f -o $TMPFILE
    end=`date +%s.%N`
    runtime=$( echo "$end - $start" | bc -l )
    mostrar_resultados $f  $TMPFILE $runtime
done;


echo "______________"
echo "| STACK ONLY |"
echo "--------------"
start=`date +%s.%N`
f=./benchmarks/stack_only/solc_semantic_tests.txt
./bin/checker -opt all -opt_rep 5 -pipeline_rep 5 -i $f -o $TMPFILE
end=`date +%s.%N`
runtime=$( echo "$end - $start" | bc -l )
mostrar_resultados $f $TMPFILE $runtime
for f in ./benchmarks/stack_only/*gas*.txt; do
    start=`date +%s.%N`
    ./bin/checker -opt all -opt_rep 5 -pipeline_rep 5 -i $f -o $TMPFILE
    end=`date +%s.%N`
    runtime=$( echo "$end - $start" | bc -l )
    mostrar_resultados $f  $TMPFILE $runtime
done;
for f in ./benchmarks/stack_only/*size*.txt; do
    start=`date +%s.%N`
    ./bin/checker -opt all_size -opt_rep 5 -pipeline_rep 5 -i $f -o $TMPFILE
    end=`date +%s.%N`
    runtime=$( echo "$end - $start" | bc -l )
    mostrar_resultados $f  $TMPFILE $runtime
done;

rm $TMPFILE




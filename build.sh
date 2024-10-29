#!/bin/bash

if [ $# -gt 1 ] || ([ $# == 1 ] && [ $1 != "-memo" ]); 
then 
    echo "Builds the FORVES checker"
    echo 
    echo "Usage: $0 [-memo]"
    echo "    -memo: Enable memoization when comparing memories"
    exit
fi

coq_makefile -f _CoqProject -o Makefile

# touch block_equiv_checker.v

make 

if [ $# == 1 ] && [ $1 == "-memo" ]; 
then 
    echo "Enabling memoization..."
    python3 patch.py
fi

make -C ocaml_interface/


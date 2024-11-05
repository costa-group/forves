#!/bin/bash

if [ $# -gt 1 ] || ([ $# == 1 ] && [ $1 != "--memo" ]); 
then 
    echo "Builds the FORVES checker"
    echo 
    echo "Usage: $0 [--memo]"
    echo "    --memo: Enable memoization when comparing symbolic memories"
    exit
fi

# Forces OCaml extraction 
touch extract_ocaml.v

coq_makefile -f _CoqProject -o Makefile

# touch block_equiv_checker.v

make 

if [ $# == 1 ] && [ $1 == "--memo" ]; 
then
    echo
    echo "**************************" 
    echo "** Enabling memoization **"
    echo "**************************" 
    python3 patch.py
    echo
fi

make -C ocaml_interface/


#!/bin/bash

coq_makefile -f _CoqProject -o Makefile
make 
python3 patch.py
make -C ocaml_interface/


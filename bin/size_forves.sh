#!/bin/bash

# Takes input from stdin

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
"$SCRIPT_DIR/forves" -opt_rep 20 -pipeline_rep 20 -opt all_size -mu basic -su basic -ms basic -ss basic -ssv_c basic_w_eq_chk -mem_c po -strg_c po -sha3_c basic

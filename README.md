# FORVES: Formally Verified EVM Block-Optimizations

FORVES is a verification tool to automatically prove the correctness of EVM (Ethereum Virtual Machine) block-optimizations on Ethereum smart contracts using the Coq proof assistant. The EVM equivalence verifier takes two blocks of jump-free EVM instructions, the original block and the optimized one, as well as the initial stack size, and determines if they are equivalent, i.e., if they have the same semantic behavior. 

This repository contains the source code of the verifier, all the Coq proofs, experiments, as well as precompiled binaries for Linux. 


## Table of Contents

1. [Requirements and setup](#requirements)
2. [Compiling the verfier and validating Coq proofs](#compiling)
3. [Executing the verifier](#executing)
4. [License](#license)

<a name="requirements"></a>
## 1 Requirements and setup

The repository contains two precompiled binary versions of the verifier for Ubuntu 22.04 LTS, but they should work in any other Linux distribution: 

   * `bin/forves`: binary verifier dynamically linked to the following standard Linux libraries
       
         $ ldd forves 
	     linux-vdso.so.1 
	     libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 
	     libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 
	     /lib64/ld-linux-x86-64.so.2 


   * `bin/static_forves`: binary verifier statically linked

The repository also contains the Coq source code to compile the EVM equivalence verifier from scratch. It depends on the following components:

   * The Coq Proof Assistant, version 8.15.2
   * OCaml 4.13.1
   * The Coq library coq-bbv, version 1.4
   * Python 3 for running some scripts

<a name="compiling"></a>
## 2 Compiling the verifier and validating Coq proofs

To compile the binary verifiers and validate all the Coq proofs, there is a `build.sh` script:

    $ ./build.sh
    COQDEP VFILES
    COQC constants.v
    COQC program.v
    COQC execution_state.v
    COQC misc.v
    COQC stack_operation_instructions.v
    COQC symbolic_state.v
    COQC concrete_interpreter.v
    COQC eval_common.v
    COQC symbolic_state_eval.v
    (...)
    COQC tests.v

    make: entering directory '/home/ubuntu/ocaml_interface'
    ocamlopt -c checker.mli -o checker.cmi
    ocamlopt -c checker.ml -o checker.cmx
    ocamlopt -o forves  checker.cmx str.cmxa main.ml 
    mv forves ../bin
    ...
    mv static_forves ../bin
    make: Leaving directory '/home/ubuntu/ocaml_interface'

The `build.sh` script accepts a parameter `--memo` to compile the checker enabling memoization when comparing symbolic memories. Memoization obtains better execution times when processing big blocks, but has a sligth overhead in small blocks. It is enabled during compilation as follows:

    $ ./build.sh --memo
    
<a name="executing"></a>
## 3 Executing the verifier

After compiling the verifier, the directory `bin/` will contain the executables  `forves` (dynamically linked) and `static_forves` (statically linked). Both behave the same and only differ in the linking process, so in the following examples we will only use the dynamically linked `forves`.

The verifier accepts several parameters to configure the verification process, which are shown using the `-help` argument: 

    $ bin/forves -help

    Usage:
    bin/forves [options] < filename
     or
    bin/forves -i filename [options]

      -opt Rule-based optimizations to be applied iteratively. Possible values:
        * none: disable optimizations
        * all: use all optimizations starting with 'eval'
        * all_size: use all optimizations starting with 'div_shl' and 'mul_shl' (useful for size)
        * A list of comma-separated optimizations (without white spaces). Available optimizations are: 
            eval,add_zero,not_not,and_and,and_origin,mul_shl,div_shl,shr_zero_x,shr_x_zero,eq_zero,sub_x_x,
            and_zero,div_one,lt_x_one,gt_one_x,and_address,mul_one,iszero_gt,eq_iszero,and_caller,iszero3,
            add_sub,shl_zero_x,sub_zero,shl_x_zero,mul_zero,div_x_x,div_zero,mod_one,mod_zero,mod_x_x,
            exp_x_zero,exp_x_one,exp_one_x,exp_zero_x,exp_two_x,gt_zero_x,gt_x_x,lt_x_zero,lt_x_x,eq_x_x,
            iszero_sub,iszero_lt,iszero_xor,iszero2_gt,iszero2_lt,iszero2_eq,xor_x_x,xor_zero,xor_xor,       
            or_or,or_and,and_or,and_not,or_not,or_x_x,and_x_x,or_zero,or_ffff,and_ffff,and_coinbase,
            balance_address,slt_x_x,sgt_x_x,mem_solver,strg_solver,jumpi_eval
      -mu memory updater (trivial, basic)
      -su storage updater (trivial, basic)
      -ms mload solver (trivial, basic)
      -ss sload solver (trivial, basic)
      -ssv_c sstack_value comparator (trivial, basic, basic_w_eq_chk)
      -mem_c memory comparator (trivial, basic, po)
      -strg_c storage comparator (trivial, basic, po)
      -sha3_c sha3 comparator (trivial, basic)
      -opt_rep repetitions of each optimization
      -pipeline_rep optimization pipeline repetitions
      -i Input file (standard input if not provided)
      -o Output file (standard output if not provided)
      -help  Display this list of options
      --help  Display this list of options

The verifier reads a sequence of blocks from the input (standard input or file) to check its equivalence. Each case if formed by 3 lines:    

    optimized block
    original block
    initial stack size

The first line is the optimized block of EVM instructions, the second line contains the original block of EVM instructions, and the third line has the initial stack size. The verifier will read triplets until the end of the file (EOF, introduced by **Ctrl-d** in the terminal) and show all the results. For each case, it will show a line `Example N: X` where `N` is the case number and `X` is a Boolean: `true` if the blocks are equivalent and `false` if the verifier cannot determine the equivalence.

Example:

    $ bin/forves -opt_rep 20 -pipeline_rep 20 -opt all -mu basic -su basic -ms basic -ss basic -ssv_c basic_w_eq_chk -mem_c po -strg_c po -sha3_c basic
    DUP2 DUP2 MSTORE DUP1 DUP1 MLOAD MUL PUSH1 0x0 ADD DUP2 MSTORE MUL
    DUP1 SWAP2 MUL DUP1 SWAP2 MSTORE
    2

    PUSH1 0x5
    PUSH1 0x5 PUSH1 0x0 ADD
    0

    ADD DUP1
    DUP2 DUP2 ADD SWAP2 ADD
    2

    PUSH1 0x5 PUSH1 0x0
    PUSH1 0x5 
    3
    (Ctrl-d)
    Example 0: true
    Example 1: true
    Example 2: true
    Example 3: false


It is usually easier to include all the cases to verify in a single text file with the previously defined format and use it as input.

Example:

    $ bin/forves -opt_rep 20 -pipeline_rep 20 -opt all -mu basic -su basic -ms basic -ss basic -ssv_c basic_w_eq_chk -mem_c po -strg_c po -sha3_c basic -i benchmarks/pldi/benchmark3_greedy.txt 
    Example 0: true
    Example 1: true
    Example 2: true
    (...)
    Example 6166: true
    Example 6167: true
    Example 6168: true



<a name="license"></a>
## 4 License

The code is licensed under the [GNU General Public License 3.0](https://www.gnu.org/licenses/gpl-3.0.html), also included in our repository in the `COPYING` file.


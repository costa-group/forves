Artifact of the Paper (Formally Verified EVM Block-Optimizations)
=================================================================


Table of Contents
=================
1. Contents of the artifact
2. Requirements and setup
3. Compiling the checker and validating Coq proofs
4. Executing the checker
5. Running experiments
6. License



1 Contents of the artifact
==========================
This artifact includes a verification tool to automatically prove the 
correctness of EVM (Ethereum Virtual Machine) block-optimizations on
Ethereum smart contracts using the Coq proof assistant. The EVM equivalence 
checker takes two blocks of jump-free EVM instructions, the original block and 
the optimized one, as well as the initial stack size, and determines if they are
equivalent, i.e., if they have the same semantic behavior. The artifact has been 
built to be executed inside the TACAS 23 Artifact Evaluation VM available at 
https://zenodo.org/record/7113223.



2 Requirements and setup
========================
This artifact already contains two precompiled binary versions of the checker
for Ubuntu 22.04 LTS: 

   * `bin/checker`: binary checker dynamically linked to some standard Linux 
                  libraries
   * `bin/static_checker`: binary checker statically compiled

The artifact also contains the Coq source code, Debian packages, and the
required Coq libraries to compile the EVM equivalence checker from scratch. It
depends on the following components:

   * The Coq Proof Assistant, version 8.15.0
   * OCaml 4.13.1
   * The Coq library coq-bbv, version 1.3

To install these dependencies, unzip the artifact in the home directory (we
assume `/home/tacas23/forves`) and execute the following commands with root
privileges in the root directory of the artifact (i.e, `/home/tacas23/forves`):

    $ cd /home/tacas23/forves
    $ sudo make install_deb
    $ sudo make install_bbv



3 Compiling the checker and validating Coq proofs
=================================================
The directory `src/` contains all the Coq functions that define the EVM equivalence
checker as well as all the lemmas and theorems that guarantee its soundness. To
compile the binary checkers and validate all the proofs, execute the following 
command in the root directory of the artifact:

    $ cd /home/tacas23/forves
    $ make checker
    chmod u+x ./scripts/build_checker.sh
    ./scripts/build_checker.sh
 
    Compiling EVM block checker
      & Validating Coq proofs  
    ===========================
    make[1]: Entering directory '/home/tacas23/forves/src'
    CLEAN
    make[1]: Leaving directory '/home/tacas23/forves/src'
    make[1]: Entering directory '/home/tacas23/forves/src'
    COQDEP VFILES
    COQC definitions.v
    COQC interpreter.v
    COQC optimizations.v
    COQC checker.v
    COQC tests.v
    COQC parser.v
    COQC extract.v
    ...
 
    DONE

    Execute EVM checker with:
    $ ./bin/checker < blocks.txt
  
  

4 Executing the checker
=======================
After compiling the checker, the directory `bin/` will contain the executables 
`checker` (dynamically linked) and `static_checker` (statically linked). Both
behave the same and only differ in the linking process, so in the following 
examples we will only use the dynamically linked `checker`.

The checker accepts two parameters: the algorithm used to check the equivalence
(`-alg`) and the list of optimizations to use (`-opt`) when checking the
equivalence. The latter parameter is only used when applying an algorithm that
uses optimizations (`-opt 1` or `-opt 2`):

    $ bin/checker --help
    checker [options] < filename

      -alg The algorithm to apply, use 0 for evm_eq_block_chkr, 1 for   
           evm_eq_block_chkr', and 2 for evm_eq_block_chkr'' (default: 2)

      -opt A list of comma-separated optimizations (without white spaces) 
           to be applied iteratively. Available optimizations are: 
           add_zero mul_one mul_zero not_not div_one eq_zero gt_one lt_one 
           or_zero sub_x_x iszero3 and_and_l and_and_r. 
           By default all optimizations are applied. 
	        Example: -opt add_zero,not_not,gt_one

      -help  Display this list of options

      --help  Display this list of options

The checker reads a sequence of blocks to check its equivalence from the 
standard input. Each case if formed by 3 lines: the first one is the 
optimized block of EVM instructions, the second line contains the original
block of EVM instructions, and the third line has the initial stack size. The
checker will read triplets until the end of the file (EOF, introduced by Ctrl-d
in the terminal) and show all the results. For each case, it will show a line 
`Example N: X` where `N` is the case number and `X` is a Boolean: `true` if
the blocks are equivalent and `false` if the checker cannot determine the 
equivalence.

Example:

    $ ./bin/checker
    MUL
    PUSH1 0x0 ADD MUL
    5
    PUSH1 0x0 MUL
    PUSH1 0x0 ADD
    1
    (Ctrl-d)
    Example 1: true
    Example 2: false

It is usually easier to include all the cases to check in a single text file
with the previously defined format and redirect the standard input to that file.
Example:

    ./bin/checker < ./blocks/1_gas_notopt_notsimp.txt
    Example 1: true
    Example 2: true
    Example 3: true
    Example 4: true
    ...
    Example 685: true
    Example 686: true
    Example 687: true


5 Running experiments
=====================
ADDITIONAL REQUIREMENTS: None, all software dependencies are included in the 
artifact. There are no hardware requirements.

EXPERIMENT RUNTIME: less than 3 seconds in the TACAS 23 Virtual Machine 
executed on `Intel(R) Core(TM) i7-10750H CPU @ 2.60GHz` with 32 GB.

The experiments in Section 5 of the paper process all the blocks extracted
from the BottleCastle smart contract:

 https://etherscan.io/address/0x7293f550c7c0B8e5B564C033FB4296AdF7c771aA). 
 
These blocks are extracted by first compiling the Solidity source code
of the contract with `solc` and then executing the `GASOL`
optimizer. Depending on the combination of options in each phase, we
obtain 8 different sets of blocks, which are stored in the files with
names `N_RES_SOLCOPT_SIMP.txt` in the `./blocks` directory:

   * `N` is the number of the set of blocks. The first file corresponds to
     the first line of Table 5.1 of the paper, the second file corresponds
     to the second line of Table 5.1, and so on.
   * `RES`: resource optimized by `GASOL`, can be `gas` or `size`.
   * `SOLCOPT`: whether optimizations have been enabled in `solc`. 
      Possible values are `opt` (optimizations enabled) or `notopt` 
      (optimizations disabled).
   * `SIMP`: whether simplification rules have been applied by `GASOL` or 
     not. Possible values are `simp` (simplification rules have been
     used in GASOL) or `notsimp` (simplification rules have not been used 
     in GASOL).

To reproduce the experiments included in Section 5 of the paper, simply execute
the following script:

    $ ./run_all_experiments.sh

The script will show 8 blocks of results, one for each line of Table 5.1 of the
paper. In each block of results, the script will show the file processed by the
checker and the results (number of blocks proven equivalent and time) for each
one of the algorithms: `evm_eq_block_chkr`, `evm_eq_block_chkr'`, and 
`evm_eq_block_chkr''`. Example:

    $ ./run_all_experiments.sh 
    ./blocks/1_gas_notopt_notsimp.txt
    (687 blocks)
    -----------------------------------------------------
    | Checker                      |  #Yes   | Time (s) |
    -------------------------------|---------|----------|
    | evm_eq_block_chkr   (CHKR)   |     687 |      .11 |
    | evm_eq_block_chkr'  (CHKR')  |     552 |      .09 |
    | evm_eq_block_chkr'' (CHKR'') |     687 |      .11 |
    -----------------------------------------------------
    
    ./blocks/2_gas_opt_notsimp.txt
    (414 blocks)
    ...




6 License
=========
All the Coq source files that form the EVM equivalence checker have license
GNU GENERAL PUBLIC LICENSE Version 3, included in the file `src/License.txt`.

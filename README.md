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
7. Smart contracts used in the benchmarks



1 Contents of the artifact
==========================
This artifact includes a verification tool to automatically prove the 
correctness of EVM (Ethereum Virtual Machine) block-optimizations on
Ethereum smart contracts using the Coq proof assistant. The EVM equivalence 
checker takes two blocks of jump-free EVM instructions, the original block and 
the optimized one, as well as the initial stack size, and determines if they are
equivalent, i.e., if they have the same semantic behavior. 

The artifact contains an Ubuntu Server 22.04 virtual machine with all the software alredy installed and configured (user: `ubuntu`, password: `ubuntu`).



2 Requirements and setup
========================
This artifact already contains two precompiled binary versions of the checker
for Ubuntu 22.04 LTS: 

   * `bin/checker`: binary checker dynamically linked to standard Linux libraries
   * `bin/static_checker`: binary checker statically compiled

The artifact also contains the Coq source code, Debian packages, and the
required Coq libraries to compile the EVM equivalence checker from scratch. It
depends on the following components:

   * The Coq Proof Assistant, version 8.15.0
   * OCaml 4.13.1
   * The Coq library coq-bbv, version 1.3



3 Compiling the checker and validating Coq proofs
=================================================
The directory `/home/ubuntu/forves/` contains all the Coq functions that define the EVM equivalence
checker as well as all the lemmas and theorems that guarantee its soundness. To
compile the binary checkers and validate all the proofs, execute the following 
commands in the `forves` directory:

    $ cd /home/ubuntu/forves

    $ make clean
    CLEAN

    $ make clean -C ocaml_interface/
    make: entering directory '/home/ubuntu/ocaml_interface'
    rm -f *.cmi
    rm -f *.cmx
    rm -f *.o
    rm -f checker
    rm -f ../bin/checker
    rm -f static_checker
    rm -f ../bin/static_checker
    make: Leaving directory '/home/ubuntu/ocaml_interface'

    $ make
    COQDEP VFILES
    COQC definitions.v
    COQC interpreter.v
    COQC optimizations.v
    COQC checker.v
    COQC tests.v
    COQC parser.v
    COQC extract.v

    $ make -C ocaml_interface/
    make: entering directory '/home/ubuntu/ocaml_interface'
    ocamlopt -c checker.mli -o checker.cmi
    ocamlopt -c checker.ml -o checker.cmx
    ocamlopt -o checker  checker.cmx str.cmxa main.ml 
    mv checker ../bin
    ...
    mv static_checker ../bin
    make: Leaving directory '/home/ubuntu/ocaml_interface'  



4 Executing the checker
=======================
After compiling the checker, the directory `bin/` will contain the executables 
`checker` (dynamically linked) and `static_checker` (statically linked). Both
behave the same and only differ in the linking process, so in the following 
examples we will only use the dynamically linked `checker`.

The checker accepts two parameters: the algorithm used to check the equivalence
(`-alg`) and the list of optimizations to use (`-opt`) when checking the
equivalence. 
The `-alg` parameter can take the following values:

* `0`: does not apply any simplification rule
* `1`: applies simplification rules in the original block
* `2` (**default**): applies simplification rules in both the original and the optimized block

The `-opt` parameter is only used when applying an algorithm that
uses optimizations (`-opt 1` or `-opt 2`) and its default value is applying all the simplification rules:

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
standard input. Each case if formed by 3 lines: 

    optimized block
    original block
    initial stack size

The first one is the 
optimized block of EVM instructions, the second line contains the original
block of EVM instructions, and the third line has the initial stack size. The
checker will read triplets until the end of the file (EOF, introduced by **Ctrl-d**
in the terminal) and show all the results. For each case, it will show a line 
`Example N: X` where `N` is the case number and `X` is a Boolean: `true` if
the blocks are equivalent and `false` if the checker cannot determine the 
equivalence.

Example:

    $ bin/checker 
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
    Example 2: false


It is usually easier to include all the cases to check in a single text file
with the previously defined format and redirect the standard input to that file.
Example:

    $ $ bin/checker < blocks/solc_semantic_tests.txt
    Example 0: true
    Example 1: true
    Example 2: true
    ...
    Example 1277: false
    Example 1278: true
    Example 1279: true



5 Running experiments
=====================
ADDITIONAL REQUIREMENTS: None, all software dependencies are included in the 
virtual machine. There are no hardware requirements.

EXPERIMENT RUNTIME: 1 minute and 30 seconds in the virtual machine 
executed with VirtualBox 6.1 on `Intel(R) Core(TM) i7-10750H CPU @ 2.60GHz` with 32 GB.

The experiments in Section 5 include two sets of benchmarks:

* Blocks from 96 real smart contracts optimized by `GASOL` with respecto to both size and gas. These blocks are extracted by first compiling the Solidity source code of the contract with `solc` and then executing the `GASOL` optimizer. Depending on the resource to optimize (gas or size) and whether simplification rules have been applied by GASOL or not, we obtain 4 sets of of blocks, which are stored in the files with
names `GASOL_RES_SIMP.txt` in the `blocks` directory:

  * `GASOL_gas_no_simp.txt`
  * `GASOL_gas_simp.txt`
  * `GASOL_size_no_simp.txt`
  * `GASOL_size_simp.txt`

* Blocks extracted from the smart contracts in the semantic test suite of the solc compiler (https://github.com/ethereum/solidity/tree/develop/test/libsolidity/s
emanticTests/externalContracts) optimized by the official `solc` compiler. These blocks are in the file `solc_semantic_tests.txt` insided the `blocks` directory:


To reproduce the experiments included in Section 5 of the paper, simply execute the following script:

    $ ./run_all_experiments.sh

The script will show 5 blocks of results, the first four blocks correspond to the lines in Table 5.1 of the paper and the last block correpond to the semantic test suite of the solc compiler. In each block of results, the script will show the file processed by the
checker and the total number of blocks, as well as and the results (number of blocks proven equivalent and time) for the algorithms `CHECKER` (parameter `-opt 0`) and `CHECKER^s` (parameter `-opt 2`). Example:

    $ time ./run_all_experiments.sh 
    ./blocks/GASOL_gas_no_simp.txt
    (36624 blocks)
    --------------------------------
    | Checker |  #Yes   | Time (s) |
    |---------|---------|----------|
    | CHKR    |   36624 |     3.23 |
    | CHKR^s  |   36624 |    15.18 |
    --------------------------------

    ./blocks/GASOL_gas_simp.txt
    (43228 blocks)
    --------------------------------
    | Checker |  #Yes   | Time (s) |
    |---------|---------|----------|
    | CHKR    |   27149 |     6.48 |
    | CHKR^s  |   43109 |    18.34 |
    --------------------------------

    ./blocks/GASOL_size_no_simp.txt
    (35754 blocks)
    --------------------------------
    | Checker |  #Yes   | Time (s) |
    |---------|---------|----------|
    | CHKR    |   35754 |     3.23 |
    | CHKR^s  |   35754 |    16.81 |
    --------------------------------

    ./blocks/GASOL_size_simp.txt
    (32192 blocks)
    --------------------------------
    | Checker |  #Yes   | Time (s) |
    |---------|---------|----------|
    | CHKR    |   31488 |     3.30 |
    | CHKR^s  |   31798 |    16.75 |
    --------------------------------
    
    ./blocks/solc_semantic_tests.txt
    (1280 blocks)
    --------------------------------
    | Checker |  #Yes   | Time (s) |
    |---------|---------|----------|
    | CHKR    |     525 |      .36 |
    | CHKR^s  |    1045 |      .65 |
    --------------------------------





6 License
=========
All the Coq source files that form the EVM equivalence checker have license
GNU GENERAL PUBLIC LICENSE Version 3, included in the file `src/License.txt`.



7 Smart contracts used in the benchmarks
========================================

1. https://etherscan.io/address/0x0621213b273bff05d679d9b1c68ec18cf989168f
1. https://etherscan.io/address/0x0edc5ac3da3df2e4643aca1a777ca9eb6656117a
1. https://etherscan.io/address/0x0f066b014adb057cdfc6c587965fbaa14151dfa5
1. https://etherscan.io/address/0x100739d55a4e8361dcca7e872426c4b6aadeb201
1. https://etherscan.io/address/0x16c19aaae850bb0282b38686fb071fe37edecf1f
1. https://etherscan.io/address/0x16d1884381d94b372e6020a28bf41bbabe8c1f26
1. https://etherscan.io/address/0x1c52b09ccddd1b6999400b038c7e0680eaf03dcd
1. https://etherscan.io/address/0x1Ee8923Db533Ecb7A4650cCc8829D6F114D718f9
1. https://etherscan.io/address/0x269028c988db0e6786de1f4ff66af7c033d0f6c8
1. https://etherscan.io/address/0x2ccc239e97d01ad4c39a323327bc1a1f4cb43076
1. https://etherscan.io/address/0x2e12AE85aF4121156F62ad4D059415C746fe615c
1. https://etherscan.io/address/0x34662bf3ad9b3a70ea5b46ad81f4e9cab4d89a7f
1. https://etherscan.io/address/0x359651fb6636cb650Fa47F11C9D35533BbFF8158
1. https://etherscan.io/address/0x3948b7b6b8812439ddcbc8fa42cac8e213191792
1. https://etherscan.io/address/0x3ae30bb991be0d54fddfedc7d6556e20daa97c71
1. https://etherscan.io/address/0x3e456b66425f02bfe3896c1cc3b8513ff660b4bf
1. https://etherscan.io/address/0x4152e8133d79279881013789100246a907884b9e
1. https://etherscan.io/address/0x4226cac9567e991f956f644b656ce4aa0599c63e
1. https://etherscan.io/address/0x44f8217a9dbb45ef2491da6aa18826bd6ded7847
1. https://etherscan.io/address/0x450f184242894d068a71d3abfa296a73df1e192c
1. https://etherscan.io/address/0x4757388aa7e3490106092bde16c23e2858c7d405
1. https://etherscan.io/address/0x47B51F81E03fB068d776CcB78b08F59e5256B944
1. https://etherscan.io/address/0x49173F2BF921Ce4124A8C6aBad3c5875Ff40D951
1. https://etherscan.io/address/0x49566ab7ef0d4da06a3117e9e4fb3e9947abaf96
1. https://etherscan.io/address/0x4d2d88d73ab4062d61b1eb68b5808b9176cef271
1. https://etherscan.io/address/0x4d37D0aB328e1D449Ea8CFc3b0B7364B398c41E0
1. https://etherscan.io/address/0x4E4bd1f64232450bEa37c4CB76D4b4cda3d46DAa
1. https://etherscan.io/address/0x4f73c17195d0f77c1fc4175345b9251a9fb21849
1. https://etherscan.io/address/0x4f89a0d9d868a39ec7024828dcaaae140a1a7ff3
1. https://etherscan.io/address/0x5036f390F631f66284253864aE351B0297E32f03
1. https://etherscan.io/address/0x50b6c438f108b5c0145142f54d538e704c55995b
1. https://etherscan.io/address/0x54adf7604d25ac9476fc467e93dfdb29af1077ee
1. https://etherscan.io/address/0x58760b75093a8462eb2eab2c5769ba5c0b18fa68
1. https://etherscan.io/address/0x5d2fdd14e44b090f2eef03c715d414039f86d7bd
1. https://etherscan.io/address/0x60e600a4d09297f9e9bb6eb90373f48e7830e69c
1. https://etherscan.io/address/0x6365303A5E1C1327b36bDa8C22440be94eCCbcA1
1. https://etherscan.io/address/0x64b88f10faf1603b70fb7370a00c43369f329515
1. https://etherscan.io/address/0x697720ee431148a586a546551de6c4d575e4d8d0
1. https://etherscan.io/address/0x6cd5a65e85c9603df74d4311d76145820556548a
1. https://etherscan.io/address/0x6e53a6441b24cb773adcc6e6f9d43e956e7c9a6e
1. https://etherscan.io/address/0x70001ba1ba4d85739e7b6a7c646b8aba5ed6c888
1. https://etherscan.io/address/0x702197775Ab2B462Af51Ba11b38d103AaA0bb443
1. https://etherscan.io/address/0x72BD2930663b30dBA3cd362bc1f8C2251E24C73A
1. https://etherscan.io/address/0x766a339751Df1705364D961b4f7f87309F210355
1. https://etherscan.io/address/0x7a741d7ff3da76d722fa4a37455f099efd0ef168
1. https://etherscan.io/address/0x7bd251d43d8ee259acde7788ec93b7f3d6626dd2
1. https://etherscan.io/address/0x7dDA9F944c3Daf27fbe3B8f27EC5f14FE3fa94BF
1. https://etherscan.io/address/0x7F197F94cA6e57Fd983cE0fa29710cfA3b842bf8
1. https://etherscan.io/address/0x89872650fa1a391f58b4e144222bb02e44db7e3b
1. https://etherscan.io/address/0x8EfbD976709c2bD46bdaf0c3Db83E875F1451BAE
1. https://etherscan.io/address/0x8f093895cd4c54eab897c6377e1bf85fe5b4e948
1. https://etherscan.io/address/0x8f3b62dd6a9bf905516f433c214753934b337e05
1. https://etherscan.io/address/0x90f24a2432a8b2e87b5a2026855181317890d129
1. https://etherscan.io/address/0x949205a8e58bd1e5eb043c6379d1e7564a85039a
1. https://etherscan.io/address/0x94a79038D97e22AC47C9Aa41624f948BDd7ac27D
1. https://etherscan.io/address/0x99E2C293A8A6c3dAE6A591CEA322D0c3Cd231B2C
1. https://etherscan.io/address/0xa403f555e419e56F49ba90022f7E7d0d3e86522D
1. https://etherscan.io/address/0xa7b30042c7e798d0be8e466bf879388acddc526f
1. https://etherscan.io/address/0xaa30979b30523bff7ca2ba434d126d15ad5b0905
1. https://etherscan.io/address/0xAa7B19b68a1da16f272564e74b0e99f969c4DF6a
1. https://etherscan.io/address/0xAbF18841Dca279a030bd9A9122F4460Da57ad547
1. https://etherscan.io/address/0xAbf52Fc6e5C0e6E44Daac7C6ca79498302D9B0CA
1. https://etherscan.io/address/0xb4e2ebaf639fd03aebe85bd0960b49ade9879b0f
1. https://etherscan.io/address/0xb4feb1f99fc9e2688729fc899e1ee3631bbebded
1. https://etherscan.io/address/0xb5615b9799427280cbc34a33233ef59b6409a711
1. https://etherscan.io/address/0xb595e208833164d43a08ce529acc2b803d33c30e
1. https://etherscan.io/address/0xb6105c0fa743290f94da9bf304ac45c19f4b2851
1. https://etherscan.io/address/0xb8ec5b27de7d971d74e8531baa27853cffdfae1d
1. https://etherscan.io/address/0xbb4ed94d1f743a8bba6318c821a7e9cf1d632c96
1. https://etherscan.io/address/0xbdafddc47d1cbac27f80a918908922aa6bf4b5bc
1. https://etherscan.io/address/0xbdf9d5752ec89a3b7c3b7ffe31f5bd565016c221
1. https://etherscan.io/address/0xc581bced4dedab50e8bfdcc67b2a36b92e013d78
1. https://etherscan.io/address/0xcbdbc7c264c1abff6646bdd5ba13f1664823b0cd
1. https://etherscan.io/address/0xcc07e50a953c8c61f5dc077ed171e46210e9783e
1. https://etherscan.io/address/0xcCFFC73347B05cBDCCe7c3de2a0AdEcDAa8AEf51
1. https://etherscan.io/address/0xcD097cdB473286a10Cf19CbA9597E4400e8B6943
1. https://etherscan.io/address/0xcfc131c7810f9f7ec859bd3dd020bdb4bb06a5a8
1. https://etherscan.io/address/0xd2947e1e2ea5c4cd14aaa2b7492549129b087daa
1. https://etherscan.io/address/0xda44b167ca409b7fc51ccbd6ef3338b8e19999a8
1. https://etherscan.io/address/0xde1972989f633f10b6e6dc581b785c4618aa8490
1. https://etherscan.io/address/0xdfd5235a6d3e184ba27307d7d21ae9b425ff4e6d
1. https://etherscan.io/address/0xe45D283123607B7D97856d49C965faa40542BA94
1. https://etherscan.io/address/0xe7a2241e92c7b7299452e63d53af6692dfcd0367
1. https://etherscan.io/address/0xe8d2f4b9edbb0244167339c3a8daa6d82d959e72
1. https://etherscan.io/address/0xEadC2a6fff036C12e62A74392d4c6CA77A5Ea007
1. https://etherscan.io/address/0xeb453a070c20e79ff148e0506bd02c30b577af43
1. https://etherscan.io/address/0xEf78B55bD7bC090F809535f3B32Bcf1E050815df
1. https://etherscan.io/address/0xF0B0ccED14b2d1D47C351F5Bc0B33AA79470997e
1. https://etherscan.io/address/0xf1cb8f9738adff8c280d6eae8e2285a839b79f80
1. https://etherscan.io/address/0xF2281cA8693B1d35D7a73700909ec8535A57156D
1. https://etherscan.io/address/0xf508bda527d4ef9db712eb0100f1cd8f573bbe88
1. https://etherscan.io/address/0xf66ff968773e45dad3e1ac13ffbb63fae0eb1624
1. https://etherscan.io/address/0xf7a84edAc5539b75AFaaA04f1103dBf9Db4b09c6
1. https://etherscan.io/address/0xfa1c9bf3de714059b3c019facdcaef785cab098e
1. https://etherscan.io/address/0xfc21969625ae8933e85b49df3cc28aa7092fcfc7
1. https://etherscan.io/address/0xfeff9661617cbba5a2ed3a69000f4bf1e266be71
\end

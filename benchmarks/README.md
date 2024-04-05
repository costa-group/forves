# Benchmarks

* `pldi`: Benchmarks used in the PLDI'24 paper [1]. Contain EVM blocks optimized by GASOL [2] and Superstack [1] from real smart contracts.
* `memory_and_storage`: EVM blocks optimized by GASOL [2] from real smart contracts.
* `scripts`: auxiliary scripts to extract and change the format of EVM blocks.
* `solc`: EVM blocks extracted from the semantic test suite of the solc compiler (https://github.com/ethereum/solidity/tree/develop/test/libsolidity/semanticTests/externalContracts), optimized by `solc`.
* `stack_only`: Benchmarks used in the CAV'23 paper [3]. Contain EVM blocks optimized by GASOL [2] with __only stack operations__ (no memory or storage).


## References 

[1] E. Albert, M. G. de la Banda, A. Hernández-Cerezo, A. Ignatiev,
A. Rubio, and P. J. Stuckey, “SuperStack: Superoptimization of Stack-
Bytecode via Greedy, Constraint-based, and SAT Techniques,” in Proc.
PLDI 2024. ACM, 2024.

[2] E. Albert, P. Gordillo, A. Hernández-Cerezo, and A. Rubio, “A
Max-SMT superoptimizer for EVM handling memory and storage,”
in Proc. TACAS 2022, ser. LNCS vol. 13243. Springer, 2022, pp.
201–219. Available: https://doi.org/10.1007/978-3-030-99524-9 11

[3] E. Albert, S. Genaim, D. Kirchner, E. Martin-Martin. “Formally Verified EVM Block-Optimizations,” in Enea, C., Lal, A. (eds) Computer Aided Verification. CAV 2023. Lecture Notes in Computer Science, vol 13966. Springer 2023, Cham. https://doi.org/10.1007/978-3-031-37709-9_9



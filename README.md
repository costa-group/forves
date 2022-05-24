# coq-evm

## FORmally VErified block optimizationS
 
A fully automated and formally verified tool to verify the semantic equivalence of two loop-free fragments of EVM code.

## Compilation

This project is developed using the Coq Platform version `coq-platform.2022.01.0~8.13~2022.01` with compiler `ocaml-base-compiler.4.10.2` and also requires the package [`coq-bbv` version 1.2](http://coq.io/opam/coq-bbv.1.2.html). It can be compiled with the following commands:

    $ coq_makefile -f _CoqProject -o Makefile
    $ make

## License

The library `lib/evmModel.v`, obtained from https://github.com/ivan71kmayshan27/coq-evm, is licensed under the [GNU Lesser General Public License v3.0](https://www.gnu.org/licenses/lgpl-3.0.html).

The rest of the code is licensed under the [GNU General Public License 3.0](https://www.gnu.org/licenses/gpl-3.0.html), also included in our repository in the `COPYING` file.


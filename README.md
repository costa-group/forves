# coq-evm

## FORmally VErified block optimizationS
 
A fully automated and formally verified tool to verify the semantic equivalence of two loop-free fragments of EVM code.

## Compilation

This project is developed using Coq 8.15.2 and requires the package [`coq-bbv` version 1.3](http://coq.io/opam/coq-bbv.1.3.html). It can be compiled with the following commands:

    $ coq_makefile -f _CoqProject -o Makefile
    $ make

## License

The code is licensed under the [GNU General Public License 3.0](https://www.gnu.org/licenses/gpl-3.0.html), also included in our repository in the `COPYING` file.


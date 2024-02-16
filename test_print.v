Require Import List. 
Require Import bbv.Word.

Require Import Coq.NArith.NArith.

Require Import FORVES.constants.
Import Constants.

Require Import FORVES.program.
Import Program.

Require Import FORVES.block_equiv_checker.
Import BlockEquivChecker.

Require Import FORVES.symbolic_state.
Import SymbolicState.

Require Import FORVES.stack_operation_instructions.
Import StackOpInstrs.

Require Import FORVES.execution_state.
Import ExecutionState.

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import FORVES.optimizations_def.
Import Optimizations_Def.

Require Import FORVES.optimizations.sub_x_x.
Import Opt_sub_x_x.
Require Import FORVES.optimizations.and_address.
Import Opt_and_address.

Require Import FORVES.symbolic_execution.
Import SymbolicExecution.

Require Import FORVES.storage_ops_solvers.
Import StorageOpsSolvers.

Require Import FORVES.storage_ops_solvers_impl.
Import StorageOpsSolversImpl.

Require Import FORVES.memory_ops_solvers.
Import MemoryOpsSolvers.

Require Import FORVES.memory_ops_solvers_impl.
Import MemoryOpsSolversImpl.

Require Import FORVES.symbolic_state_cmp.
Import SymbolicStateCmp.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.symbolic_execution_soundness.
Import SymbolicExecutionSoundness.

Require Import FORVES.symbolic_state_eval.
Import SymbolicStateEval.

Require Import FORVES.symbolic_state.
Import SymbolicState.

Require Import FORVES.symbolic_state_cmp_impl.
Import SymbolicStateCmpImpl.

Require Import FORVES.sstack_val_cmp_impl.
Import SStackValCmpImpl.

Require Import FORVES.sstack_val_cmp_impl_soundness.
Import SStackValCmpImplSoundness.

Require Import FORVES.sha3_cmp_impl.
Import SHA3CmpImpl.

Require Import FORVES.sha3_cmp_impl_soundness.
Import SHA3CmpImplSoundness.

Require Import FORVES.storage_cmp_impl.
Import StorageCmpImpl.

Require Import FORVES.storage_cmp_impl_soundness.
Import StorageCmpImplSoundness.


Require Import FORVES.memory_cmp_impl.
Import MemoryCmpImpl.

Require Import FORVES.memory_cmp_impl_soundness.
Import MemoryCmpImplSoundness.

Require Import FORVES.storage_ops_solvers_impl.
Import StorageOpsSolversImpl.

Require Import FORVES.storage_ops_solvers_impl_soundness.
Import StorageOpsSolversImplSoundness.

Require Import FORVES.memory_ops_solvers_impl.
Import MemoryOpsSolversImpl.

Require Import FORVES.memory_ops_solvers_impl_soundness.
Import MemoryOpsSolversImplSoundness.

Require Import FORVES.misc.
Import Misc.

Require Import FORVES.optimizations_common.
Import Optimizations_Common.

Require Import FORVES.parser.
Import Parser.

From Coq Require Import Strings.String.

From Coq Require Import Lists.List. Import ListNotations.

(* For debugging 
   https://github.com/coq-community/reduction-effects/
*)
From ReductionEffect Require Import PrintingEffect.


Module Test_Print.

(* string to block that always succeed *)
Definition str2block (s : string) : block :=
  match parse_block s with
  | None => []
  | Some b => b
  end.

(* Alejandro's example *) 
(*
METAPUSH 5 0x240 SWAP7 PUSH1 0x40 MLOAD PUSH4 0x2671a551 PUSH1 0xe1 SHL DUP2 MSTORE PUSH1 0x20 DUP2 PUSH1 0x4 ADD MSTORE PUSH1 0x1 DUP2 PUSH1 0x24 ADD MSTORE SWAP7 DUP8 PUSH1 0x44 ADD MSTORE DUP7 PUSH1 0x64 ADD MSTORE DUP6 PUSH1 0x84 ADD MSTORE DUP5 PUSH1 0xa4 ADD MSTORE DUP4 PUSH1 0xc4 ADD MSTORE DUP3 PUSH1 0xe4 ADD MSTORE DUP1 PUSH1 0x20 MSTORE PUSH1 0x0 PUSH1 0x0 MSTORE PUSH1 0x40 MLOAD METAPUSH 3 0x3038 PUSH1 0x40 MSTORE PUSH1 0x55 PUSH1 0xb KECCAK256 PUSH1 0x1 PUSH1 0x1 PUSH1 0xa0 SHL SUB SWAP1 AND SWAP3 SWAP1 PUSH1 0x40 MSTORE PUSH1 0x20 SWAP1 PUSH1 0x0 SWAP1 PUSH2 0x104 SWAP1 PUSH1 0x0 DUP7
METAPUSH 5 0x240 SWAP7 PUSH1 0x40 MLOAD SWAP7 PUSH4 0x2671a551 PUSH1 0xe1 SHL DUP9 MSTORE PUSH1 0x20 PUSH1 0x4 DUP10 ADD MSTORE PUSH1 0x1 PUSH1 0x24 DUP10 ADD MSTORE PUSH1 0x44 DUP9 ADD MSTORE PUSH1 0x64 DUP8 ADD MSTORE PUSH1 0x84 DUP7 ADD MSTORE PUSH1 0xa4 DUP6 ADD MSTORE PUSH1 0xc4 DUP5 ADD MSTORE PUSH1 0xe4 DUP4 ADD MSTORE METAPUSH 5 0x178 POP PUSH1 0x20 PUSH1 0x0 PUSH2 0x104 PUSH1 0x1 DUP1 PUSH1 0xa0 SHL SUB SWAP5 PUSH1 0x40 MLOAD SWAP6 DUP1 METAPUSH 3 0x3036 AND PUSH1 0xff PUSH1 0xa0 SHL OR DUP5 MSTORE DUP6 DUP6 MSTORE METAPUSH 3 0x3038 PUSH1 0x40 MSTORE PUSH1 0x55 PUSH1 0xb KECCAK256 AND SWAP6 PUSH1 0x40 MSTORE DUP3 DUP1 MSTORE DUP3 DUP7
500
*)
Eval cbv in 
(evm_eq_block_chkr_lazy SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "METAPUSH 5 0x240 SWAP7 PUSH1 0x40 MLOAD PUSH4 0x2671a551 PUSH1 0xe1 SHL DUP2 MSTORE PUSH1 0x20 DUP2 PUSH1 0x4 ADD MSTORE PUSH1 0x1 DUP2 PUSH1 0x24 ADD MSTORE SWAP7 DUP8 PUSH1 0x44 ADD MSTORE DUP7 PUSH1 0x64 ADD MSTORE DUP6 PUSH1 0x84 ADD MSTORE DUP5 PUSH1 0xa4 ADD MSTORE DUP4 PUSH1 0xc4 ADD MSTORE DUP3 PUSH1 0xe4 ADD MSTORE DUP1 PUSH1 0x20 MSTORE PUSH1 0x0 PUSH1 0x0 MSTORE PUSH1 0x40 MLOAD METAPUSH 3 0x3038 PUSH1 0x40 MSTORE PUSH1 0x55 PUSH1 0xb KECCAK256 PUSH1 0x1 PUSH1 0x1 PUSH1 0xa0 SHL SUB SWAP1 AND SWAP3 SWAP1 PUSH1 0x40 MSTORE PUSH1 0x20 SWAP1 PUSH1 0x0 SWAP1 PUSH2 0x104 SWAP1 PUSH1 0x0 DUP7")
 (str2block "METAPUSH 5 0x240 SWAP7 PUSH1 0x40 MLOAD SWAP7 PUSH4 0x2671a551 PUSH1 0xe1 SHL DUP9 MSTORE PUSH1 0x20 PUSH1 0x4 DUP10 ADD MSTORE PUSH1 0x1 PUSH1 0x24 DUP10 ADD MSTORE PUSH1 0x44 DUP9 ADD MSTORE PUSH1 0x64 DUP8 ADD MSTORE PUSH1 0x84 DUP7 ADD MSTORE PUSH1 0xa4 DUP6 ADD MSTORE PUSH1 0xc4 DUP5 ADD MSTORE PUSH1 0xe4 DUP4 ADD MSTORE METAPUSH 5 0x178 POP PUSH1 0x20 PUSH1 0x0 PUSH2 0x104 PUSH1 0x1 DUP1 PUSH1 0xa0 SHL SUB SWAP5 PUSH1 0x40 MLOAD SWAP6 DUP1 METAPUSH 3 0x3036 AND PUSH1 0xff PUSH1 0xa0 SHL OR DUP5 MSTORE DUP6 DUP6 MSTORE METAPUSH 3 0x3038 PUSH1 0x40 MSTORE PUSH1 0x55 PUSH1 0xb KECCAK256 AND SWAP6 PUSH1 0x40 MSTORE DUP3 DUP1 MSTORE DUP3 DUP7")
 7).
 
 Eval cbv in 
 print [[]].
 
 
 End Test_Print.
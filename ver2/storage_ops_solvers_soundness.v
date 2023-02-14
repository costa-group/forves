Require Import Arith.  
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import Coq.NArith.NArith.
Require Import List.
Import ListNotations.
Require Import Coq.Logic.FunctionalExtensionality.

Require Import FORVES.constants.
Import Constants.

Require Import FORVES.program.
Import Program.

Require Import FORVES.execution_state.
Import ExecutionState.

Require Import FORVES.stack_operation_instructions.
Import StackOpInstrs.

Require Import FORVES.misc.
Import Misc.

Require Import FORVES.symbolic_state.
Import SymbolicState.

Require Import FORVES.symbolic_state_eval.
Import SymbolicStateEval.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.storage_ops_solvers.
Import StorageOpsSolvers.

Require Import FORVES.storage_ops_solvers_impl.
Import StorageOpsSolversImpl.

Module StorageOpsSolversSoundness.

 

Lemma basic_sload_solver_snd: sload_solver_snd basic_sload_solver.
Admitted.


Lemma basic_sstorage_updater_snd: sstorage_updater_snd basic_sstorage_updater.
Admitted.

End StorageOpsSolversSoundness.

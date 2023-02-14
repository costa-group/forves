Require Import FORVES.program.
Import Program.

Require Import FORVES.stack_operation_instructions.
Import StackOpInstrs.

Require Import FORVES.execution_state.
Import ExecutionState.

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import FORVES.optimizations_def.
Import Optimizations_Def.

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

Module BlockEquivChecker.


  (* mload solvers *)
  Inductive mload_solver_v :=
  | MLoadSolver (f: mload_solver_ext_type) (H_snd: mload_solver_ext_snd f).

  Inductive available_mload_solvers :=
  | MLoadSolver_Trivial
  | MLoadSolver_Basic.

  Definition get_mload_solver (tag: available_mload_solvers) : mload_solver_v :=
    match tag with
    | MLoadSolver_Trivial => MLoadSolver trivial_mload_solver trivial_mload_solver_snd
    | MLoadSolverStrgUpdater_Basic => MLoadSolver basic_mload_solver basic_mload_solver_snd
  end.

  (* sload solvers *)
  Inductive sload_solver_v :=
  | SLoadSolver (f: sload_solver_ext_type) (H_snd: sload_solver_ext_snd f).

  Inductive available_sload_solvers :=
  | SLoadSolver_Trivial
  | SLoadSolver_Basic.

  Definition get_sload_solver (tag: available_sload_solvers) : sload_solver_v :=
    match tag with
    | SLoadSolver_Trivial => SLoadSolver trivial_sload_solver trivial_sload_solver_snd
    | SLoadSolverStrgUpdater_Basic => SLoadSolver basic_sload_solver basic_sload_solver_snd
  end.

  (* memory updaters *)
  Inductive smemory_updater_v :=
  | SMemUpdater (f: smemory_updater_ext_type) (H_snd: smemory_updater_ext_snd f).

  Inductive available_smemory_updaters :=
  | SMemUpdater_Trivial
  | SMemUpdater_Basic.

  Definition get_smemory_updater (tag: available_smemory_updaters) : smemory_updater_v :=
    match tag with
    | SMemUpdater_Trivial => SMemUpdater trivial_smemory_updater trivial_smemory_updater_snd
    | SMemUpdater_Basic => SMemUpdater basic_smemory_updater basic_smemory_updater_snd
  end.

  (* storage updaters *)
  Inductive sstorage_updater_v :=
  | SStrgUpdater (f: sstorage_updater_ext_type) (H_snd: sstorage_updater_ext_snd f).

  Inductive available_sstorage_updaters :=
  | SStrgUpdater_Trivial
  | SStrgUpdater_Basic.

  Definition get_sstorage_updater (tag: available_sstorage_updaters) : sstorage_updater_v :=
    match tag with
    | SStrgUpdater_Trivial => SStrgUpdater trivial_sstorage_updater trivial_sstorage_updater_snd
    | SStrgUpdater_Basic => SStrgUpdater basic_sstorage_updater basic_sstorage_updater_snd
  end.



  
  (* Memory comparators *)
  Inductive smemory_cmp_v :=
  | SMemCmp (f: smemory_cmp_ext_t) (H_snd: safe_smemory_cmp_ext_wrt_sstack_value_cmp f).

  Inductive available_memory_cmp :=
  | SMemCmp_Trivial
  | SMemCmp_Basic.

  Definition get_memory_cmp (tag: available_memory_cmp) : smemory_cmp_v :=
    match tag with
    | SMemCmp_Trivial => SMemCmp trivial_memory_cmp trivial_memory_cmp_snd
    | SMemCmp_Basic => SMemCmp basic_memory_cmp basic_memory_cmp_snd
  end.

  (* Storage comparators *)
  Inductive sstorage_cmp_v :=
  | SStrgCmp (f: sstorage_cmp_ext_t) (H_snd: safe_sstorage_cmp_ext_wrt_sstack_value_cmp f).

  Inductive available_storage_cmp :=
  | SStrgCmp_Trivial
  | SStrgCmp_Basic.

  Definition get_storage_cmp (tag: available_storage_cmp) : sstorage_cmp_v :=
    match tag with
    | SStrgCmp_Trivial => SStrgCmp trivial_storage_cmp trivial_storage_cmp_snd
    | SStrgCmp_Basic => SStrgCmp basic_storage_cmp basic_storage_cmp_snd
  end.


  (* SHA3 comparators *)
  Inductive sha3_cmp_v :=
  | SHA3Cmp (f: sha3_cmp_ext_t) (H_snd: safe_sha3_cmp_ext_wrt_sstack_value_cmp f).

  Inductive available_sha3_cmp :=
  | SHA3Cmp_Trivial.

  Definition get_sha3_cmp (tag: available_sha3_cmp) : sha3_cmp_v :=
    match tag with
    | SHA3Cmp_Trivial => SHA3Cmp  trivial_sha3_cmp trivial_sha3_cmp_snd
  end.


  (* sstack_val comparators *)
  Inductive sstack_val_cmp_v :=
  | SStackValCmp (f: sstack_val_cmp_ext_2_t) (H_snd: safe_sstack_value_cmp_wrt_others f) (H_d0_snd: sstack_val_cmp_fail_for_d_eq_0 f).

  Inductive available_sstack_val_cmp :=
  | SStackValCmp_Trivial
  | SStackValCmp_Basic.

  Definition get_sstack_val_cmp (tag: available_sstack_val_cmp) : sstack_val_cmp_v :=
    match tag with
    | SStackValCmp_Trivial => SStackValCmp trivial_compare_sstack_val trivial_compare_sstack_val_snd trivial_compare_sstack_val_d0_snd
    | SStackValCmp_Basic => SStackValCmp basic_compare_sstack_val basic_compare_sstack_val_snd basic_compare_sstack_val_d0_snd
  end.



Definition evm_eq_block_chkr
  (smem_updater: smemory_updater_ext_type) 
  (sstrg_updater: sstorage_updater_ext_type)
  (mload_solver: mload_solver_ext_type) 
  (sload_solver: sload_solver_ext_type)
  (sstack_value_cmp_ext: sstack_val_cmp_ext_2_t)
  (smemory_cmp_ext: smemory_cmp_ext_t)
  (sstorage_cmp_ext: sstorage_cmp_ext_t)
  (sha3_cmp_ext: sha3_cmp_ext_t)
  (opt: optim)
  (opt_p p: block)
  (k: nat) 
  : bool :=
  let sstack_value_cmp_1 := sstack_value_cmp_ext smemory_cmp_ext sstorage_cmp_ext sha3_cmp_ext in
  let smem_updater' := smem_updater sstack_value_cmp_1 in
  let sstrg_updater' := sstrg_updater sstack_value_cmp_1 in
  let mload_solver' := mload_solver sstack_value_cmp_1 in
  let sload_solver' := sload_solver sstack_value_cmp_1 in
  match evm_sym_exec smem_updater' sstrg_updater' mload_solver' sload_solver' opt_p k evm_stack_opm with
  | None => false
  | Some sst_opt => 
      match evm_sym_exec smem_updater' sstrg_updater' mload_solver' sload_solver' p k evm_stack_opm with 
      | None => false
      | Some sst_p => let (sst_opt', _) := opt sst_opt in 
                      let (sst_p',   _) := opt sst_p in
                      let d := S (max (get_maxidx_smap (get_smap_sst sst_opt')) (get_maxidx_smap (get_smap_sst sst_p'))) in
                      let sstack_value_cmp := sstack_value_cmp_1 d in
                      let smemory_cmp := smemory_cmp_ext sstack_value_cmp in
                      let sstorage_cmp := sstorage_cmp_ext sstack_value_cmp in
                      sstate_cmp sstack_value_cmp smemory_cmp sstorage_cmp sst_p' sst_opt' evm_stack_opm
      end
  end.



End BlockEquivChecker.

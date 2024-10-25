Require Import List.
 
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

Require Import FORVES.optimizations.add_zero.
Import Opt_add_zero.
Require Import FORVES.optimizations.eval.
Import Opt_eval.
Require Import FORVES.optimizations.not_not.
Import Opt_not_not.
Require Import FORVES.optimizations.and_and.
Import Opt_and_and.
Require Import FORVES.optimizations.and_origin.
Import Opt_and_origin.
Require Import FORVES.optimizations.mul_shl.
Import Opt_mul_shl.
Require Import FORVES.optimizations.div_shl.
Import Opt_div_shl.
Require Import FORVES.optimizations.shr_zero_x.
Import Opt_shr_zero_x.
Require Import FORVES.optimizations.shr_x_zero.
Import Opt_shr_x_zero.
Require Import FORVES.optimizations.eq_zero.
Import Opt_eq_zero.
Require Import FORVES.optimizations.sub_x_x.
Import Opt_sub_x_x.
Require Import FORVES.optimizations.and_zero.
Import Opt_and_zero.
Require Import FORVES.optimizations.div_one.
Import Opt_div_one.
Require Import FORVES.optimizations.lt_x_one.
Import Opt_lt_x_one.
Require Import FORVES.optimizations.gt_one_x.
Import Opt_gt_one_x.
Require Import FORVES.optimizations.and_address.
Import Opt_and_address.
Require Import FORVES.optimizations.mul_one.
Import Opt_mul_one.
Require Import FORVES.optimizations.iszero_gt.
Import Opt_iszero_gt.
Require Import FORVES.optimizations.eq_iszero.
Import Opt_eq_iszero.
Require Import FORVES.optimizations.and_caller.
Import Opt_and_caller.
Require Import FORVES.optimizations.iszero3.
Import Opt_iszero3.
Require Import FORVES.optimizations.add_sub.
Import Opt_add_sub.
Require Import FORVES.optimizations.shl_zero_x.
Import Opt_shl_zero_x.
Require Import FORVES.optimizations.sub_zero.
Import Opt_sub_zero.
Require Import FORVES.optimizations.shl_x_zero.
Import Opt_shl_x_zero.
Require Import FORVES.optimizations.mul_zero.
Import Opt_mul_zero.
Require Import FORVES.optimizations.div_x_x.
Import Opt_div_x_x.
Require Import FORVES.optimizations.div_zero.
Import Opt_div_zero.
Require Import FORVES.optimizations.mod_one.
Import Opt_mod_one.
Require Import FORVES.optimizations.mod_zero.
Import Opt_mod_zero.
Require Import FORVES.optimizations.mod_x_x.
Import Opt_mod_x_x.
Require Import FORVES.optimizations.exp_x_zero.
Import Opt_exp_x_zero.
Require Import FORVES.optimizations.exp_x_one.
Import Opt_exp_x_one.
Require Import FORVES.optimizations.exp_one_x.
Import Opt_exp_one_x.
Require Import FORVES.optimizations.exp_zero_x.
Import Opt_exp_zero_x.
Require Import FORVES.optimizations.exp_two_x.
Import Opt_exp_two_x.
Require Import FORVES.optimizations.gt_zero_x.
Import Opt_gt_zero_x.
Require Import FORVES.optimizations.gt_x_x.
Import Opt_gt_x_x.
Require Import FORVES.optimizations.lt_x_zero.
Import Opt_lt_x_zero.
Require Import FORVES.optimizations.lt_x_x.
Import Opt_lt_x_x.
Require Import FORVES.optimizations.eq_x_x.
Import Opt_eq_x_x.
Require Import FORVES.optimizations.iszero_sub.
Import Opt_iszero_sub.
Require Import FORVES.optimizations.iszero_lt.
Import Opt_iszero_lt.
Require Import FORVES.optimizations.iszero_xor.
Import Opt_iszero_xor.
Require Import FORVES.optimizations.iszero2_gt.
Import Opt_iszero2_gt.
Require Import FORVES.optimizations.iszero2_lt.
Import Opt_iszero2_lt.
Require Import FORVES.optimizations.iszero2_eq.
Import Opt_iszero2_eq.
Require Import FORVES.optimizations.xor_x_x.
Import Opt_xor_x_x.
Require Import FORVES.optimizations.xor_zero.
Import Opt_xor_zero.
Require Import FORVES.optimizations.xor_xor.
Import Opt_xor_xor.
Require Import FORVES.optimizations.or_or.
Import Opt_or_or.
Require Import FORVES.optimizations.or_and.
Import Opt_or_and.
Require Import FORVES.optimizations.and_or.
Import Opt_and_or.
Require Import FORVES.optimizations.and_not.
Import Opt_and_not.
Require Import FORVES.optimizations.or_not.
Import Opt_or_not.
Require Import FORVES.optimizations.or_x_x.
Import Opt_or_x_x.
Require Import FORVES.optimizations.and_x_x.
Import Opt_and_x_x.
Require Import FORVES.optimizations.or_zero.
Import Opt_or_zero.
Require Import FORVES.optimizations.or_ffff.
Import Opt_or_ffff.
Require Import FORVES.optimizations.and_ffff.
Import Opt_and_ffff.
Require Import FORVES.optimizations.and_coinbase.
Import Opt_and_coinbase.
Require Import FORVES.optimizations.balance_address.
Import Opt_balance_address.
Require Import FORVES.optimizations.slt_x_x.
Import Opt_slt_x_x.
Require Import FORVES.optimizations.sgt_x_x.
Import Opt_sgt_x_x.
Require Import FORVES.optimizations.mem_solver.
Import Opt_mem_solver.
Require Import FORVES.optimizations.strg_solver.
Import Opt_strg_solver.
Require Import FORVES.optimizations.jumpi_eval.
Import Opt_jumpi_eval.
Require Import FORVES.optimizations.sub_const.
Import Opt_sub_const.
Require Import FORVES.optimizations.add_add_const.
Import Opt_add_add_const.
Require Import FORVES.optimizations.iszero2_lt_zero.
Import Opt_iszero2_lt_zero.
Require Import FORVES.optimizations.gt_x_zero_lt.
Import Opt_gt_x_zero_lt.
Require Import FORVES.optimizations.iszero2_slt.
Import Opt_iszero2_slt.
Require Import FORVES.optimizations.shl_shr.
Import Opt_shl_shr.
Require Import FORVES.optimizations.and_and_mask.
Import Opt_and_and_mask.
Require Import FORVES.optimizations.and_shr.
Import Opt_and_shr.

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

Require Import FORVES.symbolic_state_cmp_soundness.
Import SymbolicStateCmpSoundness.

Require Import FORVES.optimizations_ext_def.
Import Optimizations_Ext_Def.

Require Import FORVES.misc.
Import Misc.

From Coq Require Import Lists.List. Import ListNotations.

(* For debugging with print_id *)
From ReductionEffect Require Import PrintingEffect.

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
    | MLoadSolver_Basic => MLoadSolver basic_mload_solver basic_mload_solver_snd
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
  | SMemCmp_Basic
  | SMemCmp_PO.

  Definition get_memory_cmp (tag: available_memory_cmp) : smemory_cmp_v :=
    match tag with
    | SMemCmp_Trivial => SMemCmp trivial_memory_cmp trivial_memory_cmp_snd
    | SMemCmp_Basic => SMemCmp basic_memory_cmp basic_memory_cmp_snd
    | SMemCmp_PO => SMemCmp po_memory_cmp po_memory_cmp_snd
  end.

  (* Storage comparators *)
  Inductive sstorage_cmp_v :=
  | SStrgCmp (f: sstorage_cmp_ext_t) (H_snd: safe_sstorage_cmp_ext_wrt_sstack_value_cmp f).

  Inductive available_storage_cmp :=
  | SStrgCmp_Trivial
  | SStrgCmp_Basic
  | SStrgCmp_PO.
  

  Definition get_storage_cmp (tag: available_storage_cmp) : sstorage_cmp_v :=
    match tag with
    | SStrgCmp_Trivial => SStrgCmp trivial_storage_cmp trivial_storage_cmp_snd
    | SStrgCmp_Basic => SStrgCmp basic_storage_cmp basic_storage_cmp_snd
    | SStrgCmp_PO => SStrgCmp po_storage_cmp po_storage_cmp_snd
  end.


  (* SHA3 comparators *)
  Inductive sha3_cmp_v :=
  | SHA3Cmp (f: sha3_cmp_ext_t) (H_snd: safe_sha3_cmp_ext_wrt_sstack_value_cmp f).

  Inductive available_sha3_cmp :=
  | SHA3Cmp_Trivial
  | SHA3Cmp_Basic.

  Definition get_sha3_cmp (tag: available_sha3_cmp) : sha3_cmp_v :=
    match tag with
    | SHA3Cmp_Trivial => SHA3Cmp trivial_sha3_cmp trivial_sha3_cmp_snd
    | SHA3Cmp_Basic => SHA3Cmp basic_sha3_cmp basic_sha3_cmp_snd
  end.


  (* sstack_val comparators *)
  Inductive sstack_val_cmp_v :=
  | SStackValCmp (f: sstack_val_cmp_ext_2_t) (H_snd: safe_sstack_value_cmp_wrt_others f) (H_d0_snd: sstack_val_cmp_fail_for_d_eq_0 f).

  Inductive available_sstack_val_cmp :=
  | SStackValCmp_Trivial
  | SStackValCmp_Basic
  | SStackValCmp_Basic_w_eq_chk.

  Definition get_sstack_val_cmp (tag: available_sstack_val_cmp) : sstack_val_cmp_v :=
    match tag with
    | SStackValCmp_Trivial => SStackValCmp trivial_compare_sstack_val trivial_compare_sstack_val_snd trivial_compare_sstack_val_d0_snd
    | SStackValCmp_Basic => SStackValCmp basic_compare_sstack_val basic_compare_sstack_val_snd basic_compare_sstack_val_d0_snd
    | SStackValCmp_Basic_w_eq_chk => SStackValCmp basic_compare_sstack_val_w_eq_chk basic_compare_sstack_val_w_eq_chk_snd basic_compare_sstack_val_w_eq_chk_d0_snd
    end.
  
  
Inductive available_optimization_step :=
| OPT_eval
| OPT_add_zero
| OPT_not_not
| OPT_and_and
| OPT_and_origin
| OPT_mul_shl
| OPT_div_shl
| OPT_shr_zero_x
| OPT_shr_x_zero
| OPT_eq_zero
| OPT_sub_x_x
| OPT_and_zero
| OPT_div_one
| OPT_lt_x_one
| OPT_gt_one_x
| OPT_and_address
| OPT_mul_one
| OPT_iszero_gt
| OPT_eq_iszero
| OPT_and_caller
| OPT_iszero3
| OPT_add_sub
| OPT_shl_zero_x
| OPT_sub_zero
| OPT_shl_x_zero
| OPT_mul_zero
| OPT_div_x_x
| OPT_div_zero
| OPT_mod_one
| OPT_mod_zero
| OPT_mod_x_x
| OPT_exp_x_zero
| OPT_exp_x_one
| OPT_exp_one_x
| OPT_exp_zero_x
| OPT_exp_two_x
| OPT_gt_zero_x
| OPT_gt_x_x
| OPT_lt_x_zero
| OPT_lt_x_x
| OPT_eq_x_x
| OPT_iszero_sub
| OPT_iszero_lt
| OPT_iszero_xor
| OPT_iszero2_gt
| OPT_iszero2_lt
| OPT_iszero2_eq
| OPT_xor_x_x
| OPT_xor_zero
| OPT_xor_xor
| OPT_or_or
| OPT_or_and
| OPT_and_or
| OPT_and_not
| OPT_or_not
| OPT_or_x_x
| OPT_and_x_x
| OPT_or_zero
| OPT_or_ffff
| OPT_and_ffff
| OPT_and_coinbase
| OPT_balance_address
| OPT_slt_x_x
| OPT_sgt_x_x

| OPT_mem_solver
| OPT_strg_solver
| OPT_jumpi_eval

| OPT_sub_const
| OPT_add_add_const
| OPT_iszero2_lt_zero
| OPT_gt_x_zero_lt
| OPT_iszero2_slt
| OPT_shl_shr
| OPT_and_and_mask
| OPT_and_shr
.


Definition list_opt_steps := list available_optimization_step.

Definition get_optimization_step (tag: available_optimization_step) : opt_entry :=
match tag with 
| OPT_eval => OpEntry optimize_eval_sbinding optimize_eval_sbinding_snd
| OPT_add_zero => OpEntry optimize_add_zero_sbinding optimize_add_zero_sbinding_snd
| OPT_not_not => OpEntry optimize_not_not_sbinding optimize_not_not_sbinding_snd
| OPT_and_and => OpEntry optimize_and_and_sbinding optimize_and_and_sbinding_snd
| OPT_and_origin => OpEntry optimize_and_origin_sbinding optimize_and_origin_sbinding_snd
| OPT_mul_shl => OpEntry optimize_mul_shl_sbinding optimize_mul_shl_sbinding_snd
| OPT_div_shl => OpEntry optimize_div_shl_sbinding optimize_div_shl_sbinding_snd
| OPT_shr_zero_x => OpEntry optimize_shr_zero_x_sbinding optimize_shr_zero_x_sbinding_snd
| OPT_shr_x_zero => OpEntry optimize_shr_x_zero_sbinding optimize_shr_x_zero_sbinding_snd
| OPT_eq_zero => OpEntry optimize_eq_zero_sbinding optimize_eq_zero_sbinding_snd
| OPT_sub_x_x => OpEntry optimize_sub_x_x_sbinding optimize_sub_x_x_sbinding_snd
| OPT_and_zero => OpEntry optimize_and_zero_sbinding optimize_and_zero_sbinding_snd
| OPT_div_one => OpEntry optimize_div_one_sbinding optimize_div_one_sbinding_snd
| OPT_lt_x_one => OpEntry optimize_lt_x_one_sbinding optimize_lt_x_one_sbinding_snd
| OPT_gt_one_x => OpEntry optimize_gt_one_x_sbinding optimize_gt_one_x_sbinding_snd
| OPT_and_address => OpEntry optimize_and_address_sbinding optimize_and_address_sbinding_snd
| OPT_mul_one => OpEntry optimize_mul_one_sbinding optimize_mul_one_sbinding_snd
| OPT_iszero_gt => OpEntry optimize_iszero_gt_sbinding optimize_iszero_gt_sbinding_snd
| OPT_eq_iszero => OpEntry optimize_eq_iszero_sbinding optimize_eq_iszero_sbinding_snd
| OPT_and_caller => OpEntry optimize_and_caller_sbinding optimize_and_caller_sbinding_snd
| OPT_iszero3 => OpEntry optimize_iszero3_sbinding optimize_iszero3_sbinding_snd
| OPT_add_sub => OpEntry optimize_add_sub_sbinding optimize_add_sub_sbinding_snd
| OPT_shl_zero_x => OpEntry optimize_shl_zero_x_sbinding optimize_shl_zero_x_sbinding_snd
| OPT_sub_zero => OpEntry optimize_sub_zero_sbinding optimize_sub_zero_sbinding_snd
| OPT_shl_x_zero => OpEntry optimize_shl_x_zero_sbinding optimize_shl_x_zero_sbinding_snd
| OPT_mul_zero => OpEntry optimize_mul_zero_sbinding optimize_mul_zero_sbinding_snd
| OPT_div_x_x => OpEntry optimize_div_x_x_sbinding optimize_div_x_x_sbinding_snd
| OPT_div_zero => OpEntry optimize_div_zero_sbinding optimize_div_zero_sbinding_snd
| OPT_mod_one => OpEntry optimize_mod_one_sbinding optimize_mod_one_sbinding_snd
| OPT_mod_zero => OpEntry optimize_mod_zero_sbinding optimize_mod_zero_sbinding_snd
| OPT_mod_x_x => OpEntry optimize_mod_x_x_sbinding optimize_mod_x_x_sbinding_snd
| OPT_exp_x_zero => OpEntry optimize_exp_x_zero_sbinding optimize_exp_x_zero_sbinding_snd
| OPT_exp_x_one => OpEntry optimize_exp_x_one_sbinding optimize_exp_x_one_sbinding_snd
| OPT_exp_one_x => OpEntry optimize_exp_one_x_sbinding optimize_exp_one_x_sbinding_snd
| OPT_exp_zero_x => OpEntry optimize_exp_zero_x_sbinding optimize_exp_zero_x_sbinding_snd
| OPT_exp_two_x => OpEntry optimize_exp_two_x_sbinding optimize_exp_two_x_sbinding_snd
| OPT_gt_zero_x => OpEntry optimize_gt_zero_x_sbinding optimize_gt_zero_x_sbinding_snd
| OPT_gt_x_x => OpEntry optimize_gt_x_x_sbinding optimize_gt_x_x_sbinding_snd
| OPT_lt_x_zero => OpEntry optimize_lt_x_zero_sbinding optimize_lt_x_zero_sbinding_snd
| OPT_lt_x_x => OpEntry optimize_lt_x_x_sbinding optimize_lt_x_x_sbinding_snd
| OPT_eq_x_x => OpEntry optimize_eq_x_x_sbinding optimize_eq_x_x_sbinding_snd
| OPT_iszero_sub => OpEntry optimize_iszero_sub_sbinding optimize_iszero_sub_sbinding_snd
| OPT_iszero_lt => OpEntry optimize_iszero_lt_sbinding optimize_iszero_lt_sbinding_snd
| OPT_iszero_xor => OpEntry optimize_iszero_xor_sbinding optimize_iszero_xor_sbinding_snd
| OPT_iszero2_gt => OpEntry optimize_iszero2_gt_sbinding optimize_iszero2_gt_sbinding_snd
| OPT_iszero2_lt => OpEntry optimize_iszero2_lt_sbinding optimize_iszero2_lt_sbinding_snd
| OPT_iszero2_eq => OpEntry optimize_iszero2_eq_sbinding optimize_iszero2_eq_sbinding_snd
| OPT_xor_x_x => OpEntry optimize_xor_x_x_sbinding optimize_xor_x_x_sbinding_snd
| OPT_xor_zero => OpEntry optimize_xor_zero_sbinding optimize_xor_zero_sbinding_snd
| OPT_xor_xor => OpEntry optimize_xor_xor_sbinding optimize_xor_xor_sbinding_snd
| OPT_or_or => OpEntry optimize_or_or_sbinding optimize_or_or_sbinding_snd
| OPT_or_and => OpEntry optimize_or_and_sbinding optimize_or_and_sbinding_snd
| OPT_and_or => OpEntry optimize_and_or_sbinding optimize_and_or_sbinding_snd
| OPT_and_not => OpEntry optimize_and_not_sbinding optimize_and_not_sbinding_snd
| OPT_or_not => OpEntry optimize_or_not_sbinding optimize_or_not_sbinding_snd
| OPT_or_x_x => OpEntry optimize_or_x_x_sbinding optimize_or_x_x_sbinding_snd
| OPT_and_x_x => OpEntry optimize_and_x_x_sbinding optimize_and_x_x_sbinding_snd
| OPT_or_zero => OpEntry optimize_or_zero_sbinding optimize_or_zero_sbinding_snd
| OPT_or_ffff => OpEntry optimize_or_ffff_sbinding optimize_or_ffff_sbinding_snd
| OPT_and_ffff => OpEntry optimize_and_ffff_sbinding optimize_and_ffff_sbinding_snd
| OPT_and_coinbase => OpEntry optimize_and_coinbase_sbinding optimize_and_coinbase_sbinding_snd
| OPT_balance_address => OpEntry optimize_balance_address_sbinding optimize_balance_address_sbinding_snd
| OPT_slt_x_x => OpEntry optimize_slt_x_x_sbinding optimize_slt_x_x_sbinding_snd
| OPT_sgt_x_x => OpEntry optimize_sgt_x_x_sbinding optimize_sgt_x_x_sbinding_snd

| OPT_mem_solver => OpEntry optimize_mem_solver_sbinding optimize_mem_solver_sbinding_snd
| OPT_strg_solver => OpEntry optimize_strg_solver_sbinding optimize_strg_solver_sbinding_snd
| OPT_jumpi_eval => OpEntry optimize_jumpi_eval_sbinding optimize_jumpi_eval_sbinding_snd

| OPT_sub_const => OpEntry optimize_sub_const_sbinding optimize_sub_const_sbinding_snd
| OPT_add_add_const => OpEntry optimize_add_add_const_sbinding optimize_add_add_const_sbinding_snd
| OPT_iszero2_lt_zero => OpEntry optimize_iszero2_lt_zero_sbinding optimize_iszero2_lt_zero_sbinding_snd
| OPT_gt_x_zero_lt => OpEntry optimize_gt_x_zero_lt_sbinding optimize_gt_x_zero_lt_sbinding_snd
| OPT_iszero2_slt => OpEntry optimize_iszero2_slt_sbinding optimize_iszero2_slt_sbinding_snd
| OPT_shl_shr => OpEntry optimize_shl_shr_sbinding optimize_shl_shr_sbinding_snd
| OPT_and_and_mask => OpEntry optimize_and_and_mask_sbinding optimize_and_and_mask_sbinding_snd
| OPT_and_shr => OpEntry optimize_and_shr_sbinding optimize_and_shr_sbinding_snd
end.

Definition all_optimization_steps := 
  [
   OPT_eval
   ;OPT_add_zero
   ;OPT_not_not
   ;OPT_and_and  
   ;OPT_and_origin
   ;OPT_div_shl
   ;OPT_mul_shl
   ;OPT_shr_zero_x
   ;OPT_shr_x_zero
   ;OPT_eq_zero
   ;OPT_sub_x_x 
   ;OPT_and_zero
   ;OPT_div_one 
   ;OPT_lt_x_one 
   ;OPT_gt_one_x 
   ;OPT_and_address
   ;OPT_mul_one
   ;OPT_iszero_gt
   ;OPT_eq_iszero
   ;OPT_and_caller
   ;OPT_iszero3
   ;OPT_add_sub
   ;OPT_shl_zero_x
   ;OPT_sub_zero
   ;OPT_shl_x_zero
   ;OPT_mul_zero
   ;OPT_div_x_x  (* TODO:  useless: checking X <> 0 requires X to be a value
                           so DIV(X,X) contains constants and will be avaluated
                           by the "eval" optimization *)
   ;OPT_div_zero
   ;OPT_mod_one
   ;OPT_mod_zero
   ;OPT_mod_x_x
   ;OPT_exp_x_zero
   ;OPT_exp_x_one
   ;OPT_exp_one_x
   ;OPT_exp_zero_x
   ;OPT_exp_two_x
   ;OPT_gt_zero_x
   ;OPT_gt_x_x
   ;OPT_lt_x_zero
   ;OPT_lt_x_x
   ;OPT_eq_x_x
   ;OPT_iszero_sub
   ;OPT_iszero_lt
   ;OPT_iszero_xor
   ;OPT_iszero2_gt
   ;OPT_iszero2_lt
   ;OPT_iszero2_eq
   ;OPT_iszero2_slt
   ;OPT_xor_x_x
   ;OPT_xor_zero
   ;OPT_xor_xor
   ;OPT_or_or
   ;OPT_or_and
   ;OPT_and_or
   ;OPT_and_not
   ;OPT_or_not
   ;OPT_or_x_x
   ;OPT_and_x_x
   ;OPT_or_zero
   ;OPT_or_ffff
   ;OPT_and_ffff
   ;OPT_and_coinbase
   ;OPT_balance_address
   ;OPT_slt_x_x
   ;OPT_sgt_x_x

   ;OPT_sub_const
   ;OPT_add_add_const
   ;OPT_iszero2_lt_zero
   ;OPT_gt_x_zero_lt
   ;OPT_shl_shr
   ;OPT_and_and_mask
   ;OPT_and_shr
   
   ;OPT_jumpi_eval
   ;OPT_mem_solver
   ;OPT_strg_solver

].

Definition all_optimization_steps' := 
  [OPT_div_shl;
   OPT_mul_shl;
   OPT_eval; 
   OPT_add_zero; 
   OPT_not_not; 
   OPT_and_and;    
   OPT_and_origin; 
   OPT_shr_zero_x; 
   OPT_shr_x_zero; 
   OPT_eq_zero; 
   OPT_sub_x_x; 
   OPT_and_zero; 
   OPT_div_one; 
   OPT_lt_x_one; 
   OPT_gt_one_x; 
   OPT_and_address; 
   OPT_mul_one; 
   OPT_iszero_gt; 
   OPT_eq_iszero;
   OPT_and_caller;
   OPT_iszero3;
   OPT_add_sub;
   OPT_shl_zero_x;
   OPT_sub_zero;
   OPT_shl_x_zero;
   OPT_mul_zero;
   OPT_div_x_x;  (* TODO:  useless: checking X <> 0 requires X to be a value
                           so DIV(X,X) contains constants and will be avaluated
                           by the "eval" optimization *)
   OPT_div_zero;
   OPT_mod_one;
   OPT_mod_zero;
   OPT_mod_x_x;
   OPT_exp_x_zero;
   OPT_exp_x_one;
   OPT_exp_one_x;
   OPT_exp_zero_x;
   OPT_exp_two_x;
   OPT_gt_zero_x;
   OPT_gt_x_x;
   OPT_lt_x_zero;
   OPT_lt_x_x;
   OPT_eq_x_x;
   OPT_iszero_sub;
   OPT_iszero_lt;
   OPT_iszero_xor;
   OPT_iszero2_gt;
   OPT_iszero2_lt;
   OPT_iszero2_eq;
   (* OPT_iszero2_slt; *)
   OPT_xor_x_x;
   OPT_xor_zero;
   OPT_xor_xor;
   OPT_or_or;
   OPT_or_and;
   OPT_and_or;
   OPT_and_not;
   OPT_or_not;
   OPT_or_x_x;
   OPT_and_x_x;
   OPT_or_zero;
   OPT_or_ffff;
   OPT_and_ffff;
   OPT_and_coinbase;
   OPT_balance_address;
   OPT_slt_x_x;
   OPT_sgt_x_x

   (*;OPT_sub_const
   ;OPT_add_add_const
   ;OPT_iszero2_lt_zero
   ;OPT_gt_x_zero_lt
   ;OPT_iszero2_slt
   ;OPT_shl_shr
   ;OPT_and_and_mask
   ;OPT_and_shr*)

   ;OPT_jumpi_eval
   ;OPT_mem_solver
   ;OPT_strg_solver   
].

  
Fixpoint get_pipeline (l: list_opt_steps) : opt_pipeline :=
match l with 
| nil => nil
| tag::r => (get_optimization_step tag)::(get_pipeline r)
end.


Definition checker_type := block -> block -> nat -> bool.

Definition evm_eq_block_chkr'
  (memory_updater: smemory_updater_ext_type) 
  (storage_updater: sstorage_updater_ext_type)
  (mload_solver: mload_solver_ext_type) 
  (sload_solver: sload_solver_ext_type)
  (sstack_value_cmp_ext: sstack_val_cmp_ext_2_t)
  (smemory_cmp_ext: smemory_cmp_ext_t)
  (sstorage_cmp_ext: sstorage_cmp_ext_t)
  (sha3_cmp_ext: sha3_cmp_ext_t)
  (opt_pipeline: opt_pipeline)
  (opt_step_rep: nat)
  (opt_pipeline_rep: nat)
  (***)
  (opt_p p: block)
  (k: nat) 
  : bool :=
    let sstack_value_cmp_1 := sstack_value_cmp_ext smemory_cmp_ext sstorage_cmp_ext sha3_cmp_ext in
  let memory_updater' := memory_updater sstack_value_cmp_1 in
  let storage_updater' := storage_updater sstack_value_cmp_1 in
  let mload_solver' := mload_solver sstack_value_cmp_1 in
  let sload_solver' := sload_solver sstack_value_cmp_1 in

  match evm_sym_exec memory_updater' storage_updater' mload_solver' sload_solver' opt_p k evm_stack_opm with
  | None => false
  | Some sst_opt => 
      match evm_sym_exec memory_updater' storage_updater' mload_solver' sload_solver' p k evm_stack_opm with 
      | None => false
      | Some sst_p => (* Builds optimization *)
          let maxid := S (max (get_maxidx_smap (get_smap_sst sst_opt)) (get_maxidx_smap (get_smap_sst sst_p))) in
          let sstack_value_cmp := sstack_value_cmp_1 maxid in
          
          (* Combines standard optimization and extended optimizations *)
          (*let opt := apply_opt_combined_n_times_pipeline_k opt_pipeline test_opt_ext_pipeline
                     sstack_value_cmp opt_step_rep opt_pipeline_rep in*)
          let opt := apply_opt_n_times_pipeline_k opt_pipeline 
                       sstack_value_cmp opt_step_rep 
                       opt_pipeline_rep in
          (* opt is sound if sstack_value_cmp is "safe_sstack_val_cmp" *)

          let (sst_opt', _) := opt sst_opt in 
          let (sst_p',   _) := opt sst_p in

          let smemory_cmp := smemory_cmp_ext sstack_value_cmp in
          let sstorage_cmp := sstorage_cmp_ext sstack_value_cmp in
          sstate_cmp sstack_value_cmp smemory_cmp sstorage_cmp sst_p' sst_opt' evm_stack_opm
      end
  end.
  

Definition evm_eq_block_chkr_lazy
  (memory_updater_tag: available_smemory_updaters) 
  (storage_updater_tag: available_sstorage_updaters)
  (mload_solver_tag: available_mload_solvers) 
  (sload_solver_tag: available_sload_solvers)
  (sstack_value_cmp_tag: available_sstack_val_cmp)
  (memory_cmp_tag: available_memory_cmp)
  (storage_cmp_tag: available_storage_cmp)
  (sha3_cmp_tag: available_sha3_cmp)
  
  (*(opt: optim)*)
  (optimization_steps: list_opt_steps)
  (opt_step_rep: nat)
  (opt_pipeline_rep: nat) :=
  
  match get_smemory_updater memory_updater_tag with
  | SMemUpdater memory_updater _ =>
      match get_sstorage_updater storage_updater_tag with
      | SStrgUpdater storage_updater _ =>
          match get_mload_solver mload_solver_tag with
          | MLoadSolver mload_solver _ =>
             match get_sload_solver sload_solver_tag with
             | SLoadSolver sload_solver _ =>
                 match get_sstack_val_cmp sstack_value_cmp_tag with
                 | SStackValCmp sstack_val_cmp _ _ =>
                     match get_memory_cmp memory_cmp_tag with
                     | SMemCmp memory_cmp _ =>
                         match get_storage_cmp storage_cmp_tag with 
                         | SStrgCmp storage_cmp _ =>
                             match get_sha3_cmp sha3_cmp_tag with
                               | SHA3Cmp sha3_cmp _ => 
                                   match get_pipeline optimization_steps with
                                   | opt_pipeline =>
                                       fun  (opt_p p: block) (k: nat) =>
                                         evm_eq_block_chkr' memory_updater storage_updater mload_solver sload_solver sstack_val_cmp memory_cmp storage_cmp sha3_cmp opt_pipeline opt_step_rep opt_pipeline_rep opt_p p k
                                   end
                             end
                         end
                     end
                 end
             end
          end
      end
  end.



Definition evm_eq_block_chkr
  (memory_updater_tag: available_smemory_updaters) 
  (storage_updater_tag: available_sstorage_updaters)
  (mload_solver_tag: available_mload_solvers) 
  (sload_solver_tag: available_sload_solvers)
  (sstack_value_cmp_tag: available_sstack_val_cmp)
  (memory_cmp_tag: available_memory_cmp)
  (storage_cmp_tag: available_storage_cmp)
  (sha3_cmp_tag: available_sha3_cmp)
  
  (opt_pipeline: list_opt_steps)
  (opt_step_rep: nat)
  (opt_pipeline_rep: nat)
  
  (opt_p p: block)
  (k: nat) : bool :=
  let chkr := evm_eq_block_chkr_lazy memory_updater_tag storage_updater_tag mload_solver_tag sload_solver_tag sstack_value_cmp_tag memory_cmp_tag storage_cmp_tag sha3_cmp_tag opt_pipeline opt_step_rep opt_pipeline_rep in
  chkr opt_p p k.




Definition sem_eq_blocks (p1 p2: block) (k: nat) : Prop :=
forall (in_st: state),
length (get_stack_st in_st) = k ->
exists (out_st1 out_st2 : state),
evm_exec_block_c p1 in_st evm_stack_opm = Some out_st1 /\
evm_exec_block_c p2 in_st evm_stack_opm = Some out_st2 /\
eq_execution_states out_st1 out_st2.

Definition eq_block_chkr_snd (chkr : checker_type) : Prop :=
forall (p1 p2: block) (k: nat),
chkr p1 p2 k = true -> sem_eq_blocks p1 p2 k.


  End BlockEquivChecker.

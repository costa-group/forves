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

Require Import FORVES.symbolic_state_cmp.
Import SymbolicStateCmp.

Module StorageOpsSolversImpl.

 
(* Basic/trivial solvers *)  

(* Doesn't check the storage for the value, just returns an abstract load *)
Definition trivial_sload_solver (sstack_val_cmp: sstack_val_cmp_ext_1_t) (skey: sstack_val) (sstrg: sstorage) (instk_height: nat) (m: smap) (ops: stack_op_instr_map) :=
  SymSLOAD skey sstrg.


(* Doesn't check the storage, just appends the abstract store *)
Definition trivial_sstorage_updater (sstack_val_cmp: sstack_val_cmp_ext_1_t) (update: storage_update sstack_val) (sstrg: sstorage) (instk_height: nat) (m: smap) (ops: stack_op_instr_map) :=
  (update::sstrg).


Definition not_eq_keys (skey skey': sstack_val) : bool :=
  match skey, skey' with
  | Val v1, Val v2 => negb (weqb v1 v2)
  | _, _ => false
  end.

Fixpoint basic_sload_solver (sstack_val_cmp: sstack_val_cmp_ext_1_t) (skey: sstack_val) (sstrg: sstorage) (instk_height: nat) (m: smap) (ops: stack_op_instr_map) :=
  match sstrg with
  | [] => SymSLOAD skey []
  | (U_SSTORE _ skey' svalue)::sstrg' =>
      if sstack_val_cmp (S (get_maxidx_smap m)) skey skey' (get_maxidx_smap m) (get_bindings_smap m) (get_maxidx_smap m) (get_bindings_smap m) instk_height ops then
        SymBasicVal svalue
      else
        if not_eq_keys skey skey' then
          basic_sload_solver sstack_val_cmp skey sstrg' instk_height m ops
        else
          SymSLOAD skey sstrg
  end.


Fixpoint basic_sload_updater_remove_dups (sstack_val_cmp: sstack_val_cmp_ext_1_t) (skey: sstack_val) (sstrg: sstorage) (instk_height: nat) (m: smap) (ops: stack_op_instr_map) :=
  match sstrg with
  | [] => []
  | (U_SSTORE _ skey' svalue)::sstrg' =>
      if sstack_val_cmp (S (get_maxidx_smap m)) skey skey' (get_maxidx_smap m) (get_bindings_smap m) (get_maxidx_smap m) (get_bindings_smap m) instk_height ops then
        basic_sload_updater_remove_dups sstack_val_cmp skey sstrg' instk_height m ops (* we can also stop, since we will have at most one duplicate *)
      else if not_eq_keys skey skey' then
             (U_SSTORE sstack_val skey' svalue)::(basic_sload_updater_remove_dups sstack_val_cmp skey sstrg' instk_height m ops)
           else
             sstrg
  end.
                                      
Definition basic_sstorage_updater (sstack_val_cmp: sstack_val_cmp_ext_1_t) (update: storage_update sstack_val) (sstrg: sstorage) (instk_height: nat) (m: smap) (ops: stack_op_instr_map) :=
  match update with
  | U_SSTORE _ skey _ =>
      update::(basic_sload_updater_remove_dups sstack_val_cmp skey sstrg instk_height m ops)
  end.

End StorageOpsSolversImpl.

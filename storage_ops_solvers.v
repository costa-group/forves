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

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.symbolic_state_cmp.
Import SymbolicStateCmp.

Module StorageOpsSolvers.



(* sv smem instk_height m ops -> load_res *)
Definition sload_solver_type := sstack_val -> sstorage -> nat -> smap -> stack_op_instr_map -> smap_value.

Definition sload_solver_ext_type := sstack_val_cmp_ext_1_t -> sstack_val -> sstorage -> nat -> smap -> stack_op_instr_map -> smap_value.

Definition sload_solver_valid_res (sload_solver: sload_solver_type) :=
  forall m sstrg skey instk_height smv ops,
    valid_sstorage instk_height (get_maxidx_smap m) sstrg -> (* The storage is valid *)
    valid_sstack_value instk_height (get_maxidx_smap m) skey -> (* The key is valid *)    
    sload_solver skey sstrg instk_height m ops = smv ->
    valid_smap_value instk_height (get_maxidx_smap m) ops smv.

Definition sload_solver_correct_res (sload_solver: sload_solver_type) :=
  forall m sstrg skey instk_height smv ops idx1 m1,
    valid_smap instk_height (get_maxidx_smap m) (get_bindings_smap m) ops -> (* The smap is valid *)
    valid_sstorage instk_height (get_maxidx_smap m) sstrg -> (* The storage is valid *)
    valid_sstack_value instk_height (get_maxidx_smap m) skey -> (* The key is valid *)    
    sload_solver skey sstrg instk_height m ops = smv -> (* The value was resolved *)
    add_to_smap m smv = (idx1, m1) ->
    exists idx2 m2,
      add_to_smap m (SymSLOAD skey sstrg) = (idx2, m2) /\
        forall stk mem strg ctx,
          length stk = instk_height ->
          exists v,
            eval_sstack_val(FreshVar idx1) stk mem strg ctx (get_maxidx_smap m1) (get_bindings_smap m1) ops = Some v /\
              eval_sstack_val(FreshVar idx2) stk mem strg ctx (get_maxidx_smap m2) (get_bindings_smap m2) ops = Some v.

Definition sload_solver_snd (sload_solver: sload_solver_type) :=
  sload_solver_valid_res sload_solver /\ sload_solver_correct_res sload_solver.

Definition sload_solver_ext_snd (sload_solver: sload_solver_ext_type) :=
  forall sstack_val_cmp,
    safe_sstack_val_cmp_ext_1 sstack_val_cmp ->
    sload_solver_snd (sload_solver sstack_val_cmp).

(* u sstrg instk_height m ops -> strg' *)
Definition sstorage_updater_type := storage_update sstack_val -> sstorage -> nat -> smap -> stack_op_instr_map -> sstorage.
Definition sstorage_updater_ext_type := sstack_val_cmp_ext_1_t -> storage_update sstack_val -> sstorage -> nat -> smap -> stack_op_instr_map -> sstorage.

Definition sstorage_updater_valid_res (sstorage_updater: sstorage_updater_type) :=
  forall m sstrg sstrg' u instk_height ops,
    valid_sstorage instk_height (get_maxidx_smap m) sstrg -> (* The storage is valid *)
    valid_sstorage_update instk_height (get_maxidx_smap m) u -> (* The update is valid *)    
    sstorage_updater u sstrg instk_height m ops = sstrg' ->
    valid_sstorage instk_height (get_maxidx_smap m) sstrg'. (* The new storage is valid *)

Definition sstorage_updater_correct_res (sstorage_updater: sstorage_updater_type) :=
  forall m sstrg sstrg' u instk_height ops,
    valid_smap instk_height (get_maxidx_smap m) (get_bindings_smap m) ops -> (* The smap is valid *)
    valid_sstorage instk_height (get_maxidx_smap m) sstrg -> (* The storage is valid *)
    valid_sstorage_update instk_height (get_maxidx_smap m) u -> (* The update is valid *)    
    sstorage_updater u sstrg instk_height m ops = sstrg' ->
    forall stk mem strg ctx,
      length stk = instk_height ->
      exists strg1 strg2,
        eval_sstorage (u::sstrg) (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops = Some strg1 /\
          eval_sstorage sstrg' (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops = Some strg2 /\
          eq_storage strg1 strg2.

Definition sstorage_updater_snd (sstorage_updater: sstorage_updater_type) :=
  sstorage_updater_valid_res sstorage_updater /\ sstorage_updater_correct_res sstorage_updater.
  
Definition sstorage_updater_ext_snd (sstorage_updater: sstorage_updater_ext_type) :=
  forall sstack_val_cmp,
    safe_sstack_val_cmp_ext_1 sstack_val_cmp ->
    sstorage_updater_snd (sstorage_updater sstack_val_cmp).
  
  

End StorageOpsSolvers.

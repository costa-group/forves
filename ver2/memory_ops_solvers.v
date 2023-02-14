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

Module MemoryOpsSolvers.

(* sv smem instk_height m ops -> smap_value *)
Definition mload_solver_type := sstack_val -> smemory -> nat -> smap -> stack_op_instr_map -> smap_value.
            
Definition mload_solver_valid_res (mload_solver: mload_solver_type) :=
  forall m smem soffset instk_height smv ops,
    valid_smemory instk_height (get_maxidx_smap m) smem -> (* The memory is valid *)
    valid_sstack_value instk_height (get_maxidx_smap m) soffset -> (* The offset is valid *)    
    mload_solver soffset smem instk_height m ops = smv ->
    valid_smap_value instk_height (get_maxidx_smap m) ops smv.

Definition mload_solver_correct_res (mload_solver: mload_solver_type) :=
  forall m smem soffset instk_height smv ops idx1 m1,
    valid_smemory instk_height (get_maxidx_smap m) smem -> (* The memory is valid *)
    valid_sstack_value instk_height (get_maxidx_smap m) soffset -> (* The offset is valid *)    
    mload_solver soffset smem instk_height m ops = smv -> (* The value was resolved *)
    add_to_smap m smv = (idx1, m1) ->
    exists idx2 m2,
      add_to_smap m (SymMLOAD soffset smem) = (idx2, m2) /\
        forall stk mem strg ctx,
        exists v,
          eval_sstack_val(FreshVar idx1) stk mem strg ctx (get_maxidx_smap m1) (get_bindings_smap m1) ops = Some v /\
            eval_sstack_val(FreshVar idx2) stk mem strg ctx (get_maxidx_smap m2) (get_bindings_smap m2) ops = Some v.

Definition mload_solver_snd (mload_solver: mload_solver_type) :=
  mload_solver_valid_res mload_solver /\ mload_solver_correct_res mload_solver.


(* u smem instk_height m ops -> smem' *)
Definition smemory_updater_type := memory_update sstack_val -> smemory -> nat -> smap -> stack_op_instr_map -> smemory.


Definition smemory_updater_valid_res (smemory_updater: smemory_updater_type) :=
  forall m smem smem' u instk_height ops,
    valid_smemory instk_height (get_maxidx_smap m) smem -> (* The memory is valid *)
    valid_smemory_update instk_height (get_maxidx_smap m) u -> (* The update is valid *)    
    smemory_updater u smem instk_height m ops = smem' ->
    valid_smemory instk_height (get_maxidx_smap m) smem'. (* The new memory is valid *)

Definition smemory_updater_correct_res (smemory_updater: smemory_updater_type) :=
  forall m smem smem' u instk_height ops,
    valid_smemory instk_height (get_maxidx_smap m) smem -> (* The memory is valid *)
    valid_smemory_update instk_height (get_maxidx_smap m) u -> (* The update is valid *)    
    smemory_updater u smem instk_height m ops = smem' ->
    forall stk mem strg ctx,
      exists mem1 mem2,
        eval_smemory (u::smem) (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops = Some mem1 /\
          eval_smemory smem' (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops = Some mem2 /\
          eq_memory mem1 mem2.

Definition smemory_updater_snd (smemory_updater: smemory_updater_type) :=
  smemory_updater_valid_res smemory_updater /\ smemory_updater_correct_res smemory_updater.


End MemoryOpsSolvers.

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

Require Import FORVES.memory_ops_solvers.
Import MemoryOpsSolvers.

Require Import FORVES.symbolic_state_cmp.
Import SymbolicStateCmp.

Module MemoryOpsSolversImpl.

(* Doesn't check the memory for the value, just returns an abstract load *)
Definition basic_mload_solver: mload_solver_type :=
  fun (soffset: sstack_val) =>
  fun (smem: smemory) =>
  fun (instk_height: nat) =>
  fun (m: smap) =>
  fun (ops: stack_op_instr_map) =>
  SymMLOAD soffset smem.

Lemma basic_mload_solver_snd: mload_solver_snd basic_mload_solver.
Admitted.

(* Doesn't check the memory, just appends the abstract store *)
Definition basic_smemory_updater: smemory_updater_type :=
  fun (update: memory_update sstack_val) =>
  fun (smem: smemory) =>
  fun (instk_height: nat) =>
  fun (m: smap) =>
  fun (ops: stack_op_instr_map) =>
  (update::smem).

Lemma basic_smemory_updater_snd: smemory_updater_snd basic_smemory_updater.
Admitted.


Definition mstore_updates_do_not_overlap (soffset soffset': sstack_val) : bool :=
  match soffset, soffset' with
  | Val v1, Val v2 =>
      let addr := (wordToN v1) in
      let addr' := (wordToN v2) in
      orb (addr+31 <? addr')%N (addr'+31 <? addr)%N
  | _, _ => false
  end.

Definition mstore8_updates_do_not_overlap (soffset soffset': sstack_val) : bool :=
  match soffset, soffset' with
  | Val v1, Val v2 =>
      let addr := (wordToN v1) in
      let addr' := (wordToN v2) in
      orb (addr <? addr')%N (addr'+31 <? addr)%N
  | _, _ => false
  end.

Fixpoint adv_mload_solver (sstack_val_cmp: sstack_val_cmp_ext_1_t) (soffset: sstack_val) (smem: smemory) (instk_height: nat) (m: smap) (ops: stack_op_instr_map) :=
  match smem with
  | [] => SymMLOAD soffset []
  | (U_MSTORE _ soffset' svalue)::smem' =>
      if sstack_val_cmp (S (get_maxidx_smap m)) soffset soffset' (get_maxidx_smap m) (get_bindings_smap m) (get_maxidx_smap m) (get_bindings_smap m) instk_height ops then
        SymBasicVal svalue
      else
        if mstore_updates_do_not_overlap soffset soffset' then
          adv_mload_solver sstack_val_cmp soffset smem' instk_height m ops
        else
          SymMLOAD soffset' smem
  | (U_MSTORE8 _ soffset' svalue)::smem' =>
      if mstore8_updates_do_not_overlap soffset soffset' then
        adv_mload_solver sstack_val_cmp soffset smem' instk_height m ops
      else
        SymMLOAD soffset' smem             
  end.


End MemoryOpsSolversImpl.

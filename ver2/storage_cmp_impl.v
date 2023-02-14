Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import Coq.NArith.NArith.
Require Import List.
Import ListNotations.

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

Require Import FORVES.eval_common.
Import EvalCommon.

Module StorageCmpImpl.


  Definition sstorage_cmp_t := sstorage -> sstorage -> nat -> sbindings -> nat -> sbindings -> nat -> stack_op_instr_map -> bool.
(* sstack_val_cmp sstrg1 sstrg2 maxidx1 sb1 maxid2 sb2 instk_height ops -> bool *)
Definition sstorage_cmp_ext_t := sstack_val_cmp_t -> sstorage_cmp_t.


Definition trivial_storage_cmp (sstack_val_cmp : sstack_val_cmp_t) (sstrg1 sstrg2 :sstorage) (maxidx1: nat) (sb1: sbindings) (maxidx2: nat) (sb2: sbindings) (instk_height: nat) (ops: stack_op_instr_map) : bool :=
  false.

Fixpoint basic_storage_cmp (sstack_val_cmp : sstack_val_cmp_t) (sstrg1 sstrg2 :sstorage) (maxidx1: nat) (sb1: sbindings) (maxidx2: nat) (sb2: sbindings) (instk_height: nat) (ops: stack_op_instr_map) : bool :=
  match sstrg1,sstrg2 with
  | [], [] => true
  | (U_SSTORE _ skey1 svalue1)::sstrg1', (U_SSTORE _ skey2 svalue2)::sstrg2' =>
      if sstack_val_cmp skey1 skey2 maxidx1 sb1 maxidx2 sb2 instk_height ops then 
        if sstack_val_cmp svalue1 svalue2 maxidx1 sb1 maxidx2 sb2 instk_height ops then
          basic_storage_cmp sstack_val_cmp sstrg1' sstrg2' maxidx1 sb1 maxidx2 sb2 instk_height ops
        else
          false
      else
        false
  | _, _ => false
  end.

                                                                                                                                                                                                             


End StorageCmpImpl.

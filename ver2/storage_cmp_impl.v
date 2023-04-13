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


  (* just handles the case of empty storage updates *)
  Definition trivial_storage_cmp (sstack_val_cmp : sstack_val_cmp_t) (sstrg1 sstrg2 :sstorage) (maxidx1: nat) (sb1: sbindings) (maxidx2: nat) (sb2: sbindings) (instk_height: nat) (ops: stack_op_instr_map) : bool :=
  match sstrg1,sstrg2 with
  | [], [] => true
  | _, _ =>  false
  end.

  (* identical storage updates *)
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

  
  Definition swap_storage_update (u1 u2 : storage_update sstack_val) : bool :=
    match u1, u2 with
    | U_SSTORE _ (Val v1) _, U_SSTORE _ (Val v2) _ => ((wordToN v2) <? (wordToN v1))%N
    | _,_ => false                                                             
    end.
  
  Fixpoint reorder_updates' (d : nat) (sstrg :sstorage) : bool * sstorage :=
    match d with
    | O => (false,sstrg)
    | S d' =>
        match sstrg with
        | u1::u2::sstrg' =>
            if swap_storage_update u1 u2 then
              match reorder_updates' d' (u1::sstrg') with
                (_,sstrg'') => (true,u2::sstrg'')
              end
            else
              match reorder_updates' d' (u2::sstrg') with
                (r,sstrg'') => (r,u1::sstrg'')
              end
        | _ => (false,sstrg)
        end
    end.

  (* n is basically the length of sstrg, we pass it as a parameter to
  avoid computing *)
  Fixpoint reorder_storage_updates (d n: nat) (sstrg :sstorage) : sstorage :=
    match d with
    | O => sstrg
    | S d' =>
        match reorder_updates' n sstrg with
        |  (changed,sstrg') =>
             if changed then
               reorder_storage_updates d' n sstrg'
             else
               sstrg'
        end
    end.


  Definition po_storage_cmp (sstack_val_cmp : sstack_val_cmp_t) (sstrg1 sstrg2 :sstorage) (maxidx1: nat) (sb1: sbindings) (maxidx2: nat) (sb2: sbindings) (instk_height: nat) (ops: stack_op_instr_map) : bool :=
    let n1 := length sstrg1 in
    let n2 := length sstrg2 in
    if (n1 =? n2) then 
      let sstrg1' := reorder_storage_updates n1 n1 sstrg1 in
      let sstrg2' := reorder_storage_updates n2 n2 sstrg2 in
      basic_storage_cmp sstack_val_cmp sstrg1' sstrg2' maxidx1 sb1 maxidx2 sb2 instk_height ops
    else
      false.
      
End StorageCmpImpl.

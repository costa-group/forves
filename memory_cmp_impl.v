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

Module MemoryCmpImpl.


  (* just handles the case of empty memory updates *)
  Definition trivial_memory_cmp (sstack_val_cmp: sstack_val_cmp_t) (smem1 smem2 :smemory) (maxidx1: nat) (sb1: sbindings) (maxidx2: nat) (sb2: sbindings) (instk_height: nat) (ops: stack_op_instr_map) : bool :=
    match smem1,smem2 with
    | [], [] => true
    | _, _ => false
    end.

  (* identical memory updates *)
  Fixpoint basic_memory_cmp (sstack_val_cmp: sstack_val_cmp_t) (smem1 smem2 :smemory) (maxidx1: nat) (sb1: sbindings) (maxidx2: nat) (sb2: sbindings) (instk_height: nat) (ops: stack_op_instr_map) : bool :=
    match smem1,smem2 with
    | [], [] => true
    | (U_MSTORE _ soffset1 svalue1)::sstrg1', (U_MSTORE _ soffset2 svalue2)::sstrg2' =>
        if sstack_val_cmp soffset1 soffset2 maxidx1 sb1 maxidx2 sb2 instk_height ops then 
          if sstack_val_cmp svalue1 svalue2 maxidx1 sb1 maxidx2 sb2 instk_height ops then
            basic_memory_cmp sstack_val_cmp sstrg1' sstrg2' maxidx1 sb1 maxidx2 sb2 instk_height ops
          else
            false
        else
          false
    | (U_MSTORE8 _ soffset1 svalue1)::sstrg1', (U_MSTORE8 _ soffset2 svalue2)::sstrg2' =>
      if sstack_val_cmp soffset1 soffset2 maxidx1 sb1 maxidx2 sb2 instk_height ops then 
        if sstack_val_cmp svalue1 svalue2 maxidx1 sb1 maxidx2 sb2 instk_height ops then
          basic_memory_cmp sstack_val_cmp sstrg1' sstrg2' maxidx1 sb1 maxidx2 sb2 instk_height ops
        else
          false
      else
        false
          
    | _, _ => false
    end.

  
  Definition swap_memory_update (u1 u2 : memory_update sstack_val) (maxid: nat) (sb: sbindings) : bool :=
    match u1, u2 with
    | U_MSTORE _ offset1 _, U_MSTORE _ offset2 _ =>
        match follow_in_smap offset1 maxid sb, follow_in_smap offset2 maxid sb with
        | Some (FollowSmapVal (SymBasicVal (Val v1)) _ _), Some (FollowSmapVal (SymBasicVal (Val v2)) _ _)=>
            ((wordToN v2)+31 <? (wordToN v1))%N
        | _, _ => false
        end
    | U_MSTORE8 _ offset1 _, U_MSTORE8 _ offset2 _ =>
        match follow_in_smap offset1 maxid sb, follow_in_smap offset2 maxid sb with
        | Some (FollowSmapVal (SymBasicVal (Val v1)) _ _), Some (FollowSmapVal (SymBasicVal (Val v2)) _ _) =>
            ((wordToN v2) <? (wordToN v1))%N
        | _, _ => false
        end
    | U_MSTORE _ offset1 _, U_MSTORE8 _ offset2 _ =>
        match follow_in_smap offset1 maxid sb, follow_in_smap offset2 maxid sb with
        | Some (FollowSmapVal (SymBasicVal (Val v1)) _ _), Some (FollowSmapVal (SymBasicVal (Val v2)) _ _) =>
            ((wordToN v2) <? (wordToN v1))%N
        | _, _ => false
        end
    | U_MSTORE8 _ offset1 _, U_MSTORE _ offset2 _ =>
        match follow_in_smap offset1 maxid sb, follow_in_smap offset2 maxid sb with
        | Some (FollowSmapVal (SymBasicVal (Val v1)) _ _), Some ( FollowSmapVal (SymBasicVal (Val v2)) _ _) =>
            ((wordToN v2)+31 <? (wordToN v1))%N
        | _, _ => false
        end
    end.
  
  Fixpoint reorder_updates' (d : nat) (smem :smemory) (maxidx: nat) (sb: sbindings) : bool * smemory :=
    match d with
    | O => (false,smem)
    | S d' =>
        match smem with
        | u1::u2::smem' =>
            if swap_memory_update u1 u2 maxidx sb then
              match reorder_updates' d' (u1::smem') maxidx sb with
                (_,smem'') => (true,u2::smem'')
              end
            else
              match reorder_updates' d' (u2::smem') maxidx sb with
                (r,smem'') => (r,u1::smem'')
              end
        | _ => (false,smem)
        end
    end.

  (* n is basically the length of smem, we pass it as a parameter to
  avoid computing *)
  Fixpoint reorder_memory_updates (d n: nat) (smem :smemory) (maxidx: nat) (sb: sbindings) : smemory :=
    match d with
    | O => smem
    | S d' =>
        match reorder_updates' n smem maxidx sb with
        |  (changed,smem') =>
             if changed then
               reorder_memory_updates d' n smem' maxidx sb
             else
               smem'
        end
    end.


  Definition po_memory_cmp (sstack_val_cmp : sstack_val_cmp_t) (smem1 smem2 :smemory) (maxidx1: nat) (sb1: sbindings) (maxidx2: nat) (sb2: sbindings) (instk_height: nat) (ops: stack_op_instr_map) : bool :=
    let n1 := length smem1 in
    let n2 := length smem2 in
    if (n1 =? n2) then 
      let smem1' := reorder_memory_updates n1 n1 smem1 maxidx1 sb1 in
      let smem2' := reorder_memory_updates n2 n2 smem2 maxidx2 sb2 in
      basic_memory_cmp sstack_val_cmp smem1' smem2' maxidx1 sb1 maxidx2 sb2 instk_height ops
    else
      false.
      
  
End MemoryCmpImpl.

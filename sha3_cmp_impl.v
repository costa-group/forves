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

Require Import FORVES.memory_cmp_impl.
Import MemoryCmpImpl.

Module SHA3CmpImpl.


Definition trivial_sha3_cmp (sstack_val_cmp: sstack_val_cmp_t) (soffset1 ssize1: sstack_val) (smem1 :smemory) (soffset2 ssize2: sstack_val) (smem2 :smemory) (maxidx1: nat) (sb1: sbindings) (maxidx2: nat) (sb2: sbindings) (instk_height: nat) (ops: stack_op_instr_map) : bool :=
  false.


Definition update_out_of_slot (u : memory_update sstack_val) (min max: N) (maxidx: nat) (sb: sbindings) (instk_height: nat) (ops: stack_op_instr_map) :=
    match u with
    | U_MSTORE _ offset _ =>
        match follow_in_smap offset maxidx sb with
        | Some (FollowSmapVal (SymBasicVal (Val v)) _ _) =>
            orb ((wordToN v)+31 <? min)%N (max <? (wordToN v))%N
        | _ => false
        end
    | U_MSTORE8 _ offset _ =>
        match follow_in_smap offset maxidx sb with
        | Some (FollowSmapVal (SymBasicVal (Val v)) _ _) =>
            orb ((wordToN v) <? min)%N (max <? (wordToN v))%N
        | _ => false
        end
    end.
  
Fixpoint remove_out_of_slot' (smem :smemory) (min max: N) (maxidx: nat) (sb: sbindings) (instk_height: nat) (ops: stack_op_instr_map) : smemory :=
    match smem with
    | [] => []
    | u::us =>
        if (update_out_of_slot u min max maxidx sb instk_height ops) 
        then remove_out_of_slot' us min max maxidx sb instk_height ops
        else u::(remove_out_of_slot' us min max maxidx sb instk_height ops)
    end.

Definition remove_out_of_slot (smem :smemory) (soffset ssize: sstack_val) (maxidx: nat) (sb: sbindings) (instk_height: nat) (ops: stack_op_instr_map) : smemory :=
        match follow_in_smap soffset maxidx sb, follow_in_smap ssize maxidx sb with
        | Some (FollowSmapVal (SymBasicVal (Val v1)) _ _), Some (FollowSmapVal (SymBasicVal (Val v2)) _ _) =>
            remove_out_of_slot' smem (wordToN v1) ((wordToN v1)+(wordToN v2)-1)%N maxidx sb instk_height ops
        | _, _ => smem
        end. 

Definition basic_sha3_cmp (sstack_val_cmp: sstack_val_cmp_t) (soffset1 ssize1: sstack_val) (smem1 :smemory) (soffset2 ssize2: sstack_val) (smem2 :smemory) (maxidx1: nat) (sb1: sbindings) (maxidx2: nat) (sb2: sbindings) (instk_height: nat) (ops: stack_op_instr_map) : bool :=
  if (andb (sstack_val_cmp soffset1 soffset2 maxidx1 sb1 maxidx2 sb2 instk_height ops) (sstack_val_cmp ssize1 ssize2 maxidx1 sb1 maxidx2 sb2 instk_height ops)) then
    let smem1 := remove_out_of_slot smem1 soffset1 ssize1 maxidx1 sb1 instk_height ops in
    let smem2 := remove_out_of_slot smem2 soffset2 ssize2 maxidx2 sb2 instk_height ops in
    po_memory_cmp sstack_val_cmp smem1 smem2 maxidx1 sb1 maxidx2 sb2 instk_height ops
  else
    false.



End SHA3CmpImpl.

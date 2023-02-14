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

                                                                                                                                                                                                             


End MemoryCmpImpl.

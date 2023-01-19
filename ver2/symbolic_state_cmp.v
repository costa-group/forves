
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

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import FORVES.eval_common.
Import EvalCommon.

Module SymbolicStateCmp.

(* sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops *)
Definition sstack_val_cmp := sstack_val -> sstack_val -> nat -> sbindings -> nat -> sbindings -> nat -> stack_op_instr_map -> bool.

Definition sstack_val_cmp_snd (f_cmp : sstack_val_cmp) :=
  forall sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops,
    f_cmp sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops = true ->
    forall stk mem strg ctx,
      instk_height = length stk ->
      valid_sstack_value instk_height maxidx1 sv1 ->
      valid_sstack_value instk_height maxidx2 sv2 ->
      valid_bindings instk_height maxidx1 sb1 ops ->
      valid_bindings instk_height maxidx2 sb2 ops ->
      eval_sstack_val sv1 stk mem strg ctx maxidx1 sb1 ops = eval_sstack_val sv1 stk mem strg ctx maxidx1 sb1 ops.



Definition symbolic_state_cmp := sstate -> sstate -> stack_op_instr_map -> bool.



Definition symbolic_state_cmp_snd (f_cmp : sstack_val_cmp) :=
  forall sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops,
    f_cmp sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops = true ->
    forall stk mem strg ctx,
      length stk = instk_height ->
      eval_sstack_val sv1 stk mem strg ctx maxidx1 sb1 ops = eval_sstack_val sv1 stk mem strg ctx maxidx1 sb1 ops.

End SymbolicStateCmp.

  

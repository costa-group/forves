
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


(*
Definition symbolic_state_cmp_snd (f_cmp : sstack_val_cmp) :=
  forall sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops,
    f_cmp sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops = true ->
    forall stk mem strg ctx,
      length stk = instk_height ->
      eval_sstack_val sv1 stk mem strg ctx maxidx1 sb1 ops = eval_sstack_val sv1 stk mem strg ctx maxidx1 sb1 ops.
      (*Enrique: shouldn't it use eval_sstate instead of eval_sstack_val and
        complete (packed) symbolic states? *)
*)

(* Enrique: version with eval_sstate *)
Definition symbolic_state_cmp_snd (f_cmp : symbolic_state_cmp) :=
  forall sst1 sst2 ops instk_height,
    f_cmp sst1 sst2 ops = true ->
    forall st,
      length (get_stack_st st) = instk_height ->
      eval_sstate st sst1 ops = eval_sstate st sst2 ops.


(* Definition of symbolic state comparator *)

(* Trivially sound comparator that always returns false *)
Definition dummy_symbolic_state_cmp : symbolic_state_cmp :=
  fun (sst1: sstate) =>
  fun (sst2: sstate) =>
  fun (ops: stack_op_instr_map) => 
  false.
  
Lemma dummy_symbolic_state_cmp_snd: symbolic_state_cmp_snd dummy_symbolic_state_cmp.
Proof.
unfold symbolic_state_cmp_snd.
intros sst1 sst2 ops instk_height Hdummy.
unfold dummy_symbolic_state_cmp in Hdummy.
discriminate.
Qed.

End SymbolicStateCmp.

  

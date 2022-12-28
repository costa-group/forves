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

Require Import FORVES.flat_symbolic_state.
Import FlatSymbolicState.

Require Import FORVES.flat_symbolic_state_eval.
Import FlatSymbolicStateEval.


Lemma flat_sstate_eval_snd:
  forall init_st sst fsst ops,
    sstate_to_flat_sstate sst = Some fsst ->
    eval_sstate init_st sst ops = eval_flat_sstate init_st fsst ops.
Proof.
Admitted.


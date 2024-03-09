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

Require Import FORVES.sha3_cmp_impl.
Import SHA3CmpImpl.

Require Import FORVES.eval_common.
Import EvalCommon.

Module SHA3CmpImplSoundness.


  Lemma trivial_sha3_cmp_snd:
    safe_sha3_cmp_ext_wrt_sstack_value_cmp trivial_sha3_cmp.
  Proof.
    unfold safe_sha3_cmp_ext_wrt_sstack_value_cmp.
    unfold safe_sha3_cmp_ext_d.
    unfold safe_sha3_cmp.
    unfold trivial_sha3_cmp.
    intros.
    discriminate.
  Qed.
    
  Lemma basic_sha3_cmp_snd:
    safe_sha3_cmp_ext_wrt_sstack_value_cmp basic_sha3_cmp.
  Proof.
    Admitted.

End SHA3CmpImplSoundness.

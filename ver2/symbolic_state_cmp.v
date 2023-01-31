
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



(* sv1 sv2 maxidx1 sb1 maxid2 sb2 instk_height ops -> bool *)
Definition sstack_val_cmp_t := sstack_val -> sstack_val -> nat -> sbindings -> nat -> sbindings -> nat -> stack_op_instr_map -> bool.

(* sstack_val_cmp smem1 smem2 maxidx1 sb1 maxid2 sb2 instk_height ops -> bool *)
Definition smemory_cmp_t := sstack_val_cmp_t -> smemory -> smemory -> nat -> sbindings -> nat -> sbindings -> nat -> stack_op_instr_map -> bool.

(* sstack_val_cmp sstrg1 sstrg2 maxidx1 sb1 maxid2 sb2 instk_height ops -> bool *)
Definition sstorage_cmp_t := sstack_val_cmp_t -> sstorage -> sstorage -> nat -> sbindings -> nat -> sbindings -> nat -> stack_op_instr_map -> bool.

(* sstack_val_cmp smemory_cmp soffset1 ssize1 smem1 soffset2 ssize2 smem2 maxidx1 sb1 maxid2 sb2 instk_height ops -> bool *)
Definition sha3_cmp_t  := sstack_val_cmp_t -> sstack_val -> sstack_val -> smemory -> sstack_val -> sstack_val -> smemory -> nat -> sbindings -> nat -> sbindings -> nat -> stack_op_instr_map -> bool.

Definition sstack_val_cmp_ext_1_t := nat -> sstack_val_cmp_t.

Definition sstack_val_cmp_ext_2_t := smemory_cmp_t -> sstorage_cmp_t -> sha3_cmp_t -> sstack_val_cmp_ext_1_t.



Definition make_sstack_val_cmp (sstack_value_cmp: sstack_val_cmp_ext_1_t) (d :nat) :=
  (fun sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops => sstack_value_cmp d sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops).

Definition make_sstack_val_cmp_ext_1 (smemory_cmp: smemory_cmp_t) (sstorage_cmp: sstorage_cmp_t) (sha3_cmp: sha3_cmp_t) (sstack_value_cmp: sstack_val_cmp_ext_2_t) :=
  (fun d sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops => sstack_value_cmp smemory_cmp sstorage_cmp sha3_cmp d sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops).


Definition safe_smemory_cmp_d (smemory_cmp: smemory_cmp_t) (sstack_val_cmp: sstack_val_cmp_ext_1_t) (d: nat) :=
  forall smem1 smem2 maxidx1 sb1 maxidx2 sb2 instk_height ops,
    valid_bindings instk_height maxidx1 sb1 ops ->
    valid_bindings instk_height maxidx2 sb2 ops ->
    valid_smemory instk_height maxidx1 smem1 ->
    valid_smemory instk_height maxidx2 smem2 ->
    smemory_cmp (make_sstack_val_cmp sstack_val_cmp d) smem1 smem2 maxidx1 sb1 maxidx2 sb2 instk_height ops = true ->
    forall stk mem strg ctx,
      exists mem',
           eval_smemory smem1 maxidx1 sb1 stk mem strg ctx ops = Some mem' /\
             eval_smemory smem1 maxidx1 sb1 stk mem strg ctx ops = Some mem'.

Definition safe_sstorage_cmp_d (sstorage_cmp: sstorage_cmp_t) (sstack_val_cmp: sstack_val_cmp_ext_1_t) (d: nat) :=
  forall sstrg1 sstrg2 maxidx1 sb1 maxidx2 sb2 instk_height ops,
    valid_bindings instk_height maxidx1 sb1 ops ->
    valid_bindings instk_height maxidx2 sb2 ops ->
    valid_sstorage instk_height maxidx1 sstrg1 ->
    valid_sstorage instk_height maxidx2 sstrg2 ->
    sstorage_cmp (make_sstack_val_cmp sstack_val_cmp d) sstrg1 sstrg2 maxidx1 sb1 maxidx2 sb2 instk_height ops = true ->
    forall stk mem strg ctx,
    exists strg',
      eval_sstorage sstrg1 maxidx1 sb1 stk mem strg ctx ops = Some strg' /\
        eval_sstorage sstrg1 maxidx1 sb1 stk mem strg ctx ops = Some strg'.

Definition safe_sha3_cmp_d (sha3_cmp: sha3_cmp_t) (sstack_val_cmp: sstack_val_cmp_ext_1_t) (d: nat) :=
  forall soffset1 ssize1 smem1 soffset2 ssize2 smem2 maxidx1 sb1 maxidx2 sb2 instk_height ops,
    valid_sstack_value instk_height maxidx1 soffset1 ->
    valid_sstack_value instk_height maxidx1 ssize1 ->
    valid_sstack_value instk_height maxidx2 soffset2 ->
    valid_sstack_value instk_height maxidx2 ssize2 ->
    valid_bindings instk_height maxidx1 sb1 ops ->
    valid_bindings instk_height maxidx2 sb2 ops ->
    valid_smemory instk_height maxidx1 smem1 ->
    valid_smemory instk_height maxidx2 smem2 ->
    sha3_cmp (make_sstack_val_cmp sstack_val_cmp d) soffset1 ssize1 smem1 soffset2 ssize2 smem2 maxidx1 sb1 maxidx2 sb2 instk_height ops = true ->
    forall stk mem strg ctx,
      exists offset1 size1 mem1 offset2 size2 mem2,
      eval_smemory smem1 maxidx1 sb1 stk mem strg ctx ops = Some mem1 /\
      eval_smemory smem1 maxidx1 sb1 stk mem strg ctx ops = Some mem2 /\
      eval_sstack_val soffset1 stk mem strg ctx maxidx1 sb1 ops = Some offset1 /\
      eval_sstack_val ssize1 stk mem strg ctx maxidx1 sb1 ops = Some size1 /\
      eval_sstack_val soffset2 stk mem strg ctx maxidx1 sb1 ops = Some offset2 /\
      eval_sstack_val ssize2 stk mem strg ctx maxidx1 sb1 ops = Some size2 /\
      (get_keccak256_ctx ctx) (wordToNat size1) (mload' mem1 offset1 (wordToNat size1)) =
      (get_keccak256_ctx ctx) (wordToNat size2) (mload' mem2 offset2 (wordToNat size2)).

Definition safe_sstack_val_cmp_ext_2_d (smemory_cmp: smemory_cmp_t) (sstorage_cmp: sstorage_cmp_t) (sha3_cmp: sha3_cmp_t) (sstack_val_cmp: sstack_val_cmp_ext_2_t) (d: nat) :=
  forall sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops,
    valid_sstack_value instk_height maxidx1 sv1 ->
    valid_sstack_value instk_height maxidx2 sv2 ->
    valid_bindings instk_height maxidx1 sb1 ops ->
    valid_bindings instk_height maxidx2 sb2 ops ->
    sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp d sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops = true ->
    forall stk mem strg ctx,
    exists v,
      eval_sstack_val sv1 stk mem strg ctx maxidx1 sb1 ops = Some v /\
      eval_sstack_val sv2 stk mem strg ctx maxidx2 sb2 ops = Some v.


Definition safe_smemory_cmp (smemory_cmp: smemory_cmp_t) (sstack_val_cmp: sstack_val_cmp_ext_1_t) :=
  forall d, safe_smemory_cmp_d smemory_cmp sstack_val_cmp d.

Definition safe_sstorage_cmp (sstorage_cmp: sstorage_cmp_t) (sstack_val_cmp: sstack_val_cmp_ext_1_t) :=
  forall d, safe_sstorage_cmp_d sstorage_cmp sstack_val_cmp d.

Definition safe_sha3_cmp (sha3_cmp: sha3_cmp_t) (sstack_val_cmp: sstack_val_cmp_ext_1_t) :=
  forall d, safe_sha3_cmp_d sha3_cmp sstack_val_cmp d.

Definition safe_sstack_val_cmp_ext_2 (smemory_cmp: smemory_cmp_t) (sstorage_cmp: sstorage_cmp_t) (sha3_cmp: sha3_cmp_t) (sstack_val_cmp: sstack_val_cmp_ext_2_t) :=
  forall d, safe_sstack_val_cmp_ext_2_d smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp d.

Definition safe_smemory_cmp_wrt_sstack_value_cmp (smemory_cmp: smemory_cmp_t) (sstorage_cmp: sstorage_cmp_t) (sha3_cmp: sha3_cmp_t) (sstack_val_cmp: sstack_val_cmp_ext_2_t) :=
  forall d,
    safe_sstack_val_cmp_ext_2_d smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp d ->
    safe_smemory_cmp_d smemory_cmp (make_sstack_val_cmp_ext_1 smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp) d.

Definition safe_sstorage_cmp_wrt_sstack_value_cmp (smemory_cmp: smemory_cmp_t) (sstorage_cmp: sstorage_cmp_t) (sha3_cmp: sha3_cmp_t) (sstack_val_cmp: sstack_val_cmp_ext_2_t) :=
  forall d,
    safe_sstack_val_cmp_ext_2_d smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp d ->
    safe_sstorage_cmp_d sstorage_cmp (make_sstack_val_cmp_ext_1 smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp) d.

Definition safe_sha3_cmp_wrt_sstack_value_cmp (smemory_cmp: smemory_cmp_t) (sstorage_cmp: sstorage_cmp_t) (sha3_cmp: sha3_cmp_t) (sstack_val_cmp: sstack_val_cmp_ext_2_t) :=
  forall d,
    safe_sstack_val_cmp_ext_2_d smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp d ->
    safe_sha3_cmp_d sha3_cmp (make_sstack_val_cmp_ext_1 smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp) d.

Definition safe_sstack_value_cmp_wrt_others (smemory_cmp: smemory_cmp_t) (sstorage_cmp: sstorage_cmp_t) (sha3_cmp: sha3_cmp_t) (sstack_val_cmp: sstack_val_cmp_ext_2_t) :=
  forall d,
    safe_smemory_cmp_d smemory_cmp (make_sstack_val_cmp_ext_1 smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp) d ->
    safe_sstorage_cmp_d sstorage_cmp (make_sstack_val_cmp_ext_1 smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp) d ->
    safe_sha3_cmp_d sha3_cmp (make_sstack_val_cmp_ext_1 smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp) d ->
    safe_sstack_val_cmp_ext_2_d smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp (S d).

Lemma safe_gh:
  forall (smemory_cmp: smemory_cmp_t) (sstorage_cmp: sstorage_cmp_t) (sha3_cmp: sha3_cmp_t) (sstack_val_cmp: sstack_val_cmp_ext_2_t),
    safe_smemory_cmp_wrt_sstack_value_cmp smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp ->
    safe_sstorage_cmp_wrt_sstack_value_cmp smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp ->
    safe_sha3_cmp_wrt_sstack_value_cmp smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp ->
    safe_sstack_value_cmp_wrt_others smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp ->
    safe_smemory_cmp smemory_cmp (make_sstack_val_cmp_ext_1 smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp) /\
    safe_sstorage_cmp sstorage_cmp (make_sstack_val_cmp_ext_1 smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp) /\
    safe_sha3_cmp sha3_cmp (make_sstack_val_cmp_ext_1 smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp) /\
      safe_sstack_val_cmp_ext_2  smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp.
Proof.
Admitted.

End SymbolicStateCmp.

  

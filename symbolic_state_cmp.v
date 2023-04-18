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


Definition symbolic_state_cmp := sstate -> sstate -> stack_op_instr_map -> bool.


(* Enrique: version with eval_sstate *)
Definition symbolic_state_cmp_snd (f_cmp : symbolic_state_cmp) :=
  forall sst1 sst2 ops,
    valid_sstate sst1 ops ->
    valid_sstate sst2 ops ->
    f_cmp sst1 sst2 ops = true ->
    forall st,
      length (get_stack_st st) = (get_instk_height_sst sst1) ->
      exists st',
        eval_sstate st sst1 ops = Some st' /\
          eval_sstate st sst2 ops = Some st'.


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

(* smem1 smem2 maxidx1 sb1 maxid2 sb2 instk_height ops -> bool *)
Definition smemory_cmp_t := smemory -> smemory -> nat -> sbindings -> nat -> sbindings -> nat -> stack_op_instr_map -> bool.
(* sstack_val_cmp smem1 smem2 maxidx1 sb1 maxid2 sb2 instk_height ops -> bool *)
Definition smemory_cmp_ext_t := sstack_val_cmp_t -> smemory_cmp_t.

(* sstrg1 sstrg2 maxidx1 sb1 maxid2 sb2 instk_height ops -> bool *)
Definition sstorage_cmp_t := sstorage -> sstorage -> nat -> sbindings -> nat -> sbindings -> nat -> stack_op_instr_map -> bool.
(* sstack_val_cmp sstrg1 sstrg2 maxidx1 sb1 maxid2 sb2 instk_height ops -> bool *)
Definition sstorage_cmp_ext_t := sstack_val_cmp_t -> sstorage_cmp_t.

(* soffset1 ssize1 smem1 soffset2 ssize2 smem2 maxidx1 sb1 maxid2 sb2 instk_height ops -> bool *)
Definition sha3_cmp_t := sstack_val -> sstack_val -> smemory -> sstack_val -> sstack_val -> smemory -> nat -> sbindings -> nat -> sbindings -> nat -> stack_op_instr_map -> bool.
(* sstack_val_cmp soffset1 ssize1 smem1 soffset2 ssize2 smem2 maxidx1 sb1 maxid2 sb2 instk_height ops -> bool *)
Definition sha3_cmp_ext_t  := sstack_val_cmp_t -> sha3_cmp_t.


(* d sv1 sv2 maxidx1 sb1 maxid2 sb2 instk_height ops -> bool *)
Definition sstack_val_cmp_ext_1_t := nat -> sstack_val_cmp_t.
(* smemory_cmp sstorage_cmp sha3_cmp d sv1 sv2 maxidx1 sb1 maxid2 sb2 instk_height ops -> bool *)
Definition sstack_val_cmp_ext_2_t := smemory_cmp_ext_t -> sstorage_cmp_ext_t -> sha3_cmp_ext_t -> sstack_val_cmp_ext_1_t.


(* Comparing stack value always fail for d=0 (d is used to bound
recursion depth, have a decreasing argument, and to make some circular
dependencies between lemmas inductive *)
Definition sstack_val_cmp_fail_for_d_eq_0 (sstack_value_cmp: sstack_val_cmp_ext_2_t) :=
  forall smemory_cmp sstorage_cmp sha3_cmp sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops,
   sstack_value_cmp smemory_cmp sstorage_cmp sha3_cmp 0 sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops = false.

Definition safe_smemory_cmp (smemory_cmp: smemory_cmp_t) :=
  forall smem1 smem2 maxidx1 sb1 maxidx2 sb2 instk_height ops,
    valid_bindings instk_height maxidx1 sb1 ops ->
    valid_bindings instk_height maxidx2 sb2 ops ->
    valid_smemory instk_height maxidx1 smem1 ->
    valid_smemory instk_height maxidx2 smem2 ->
    smemory_cmp smem1 smem2 maxidx1 sb1 maxidx2 sb2 instk_height ops = true ->
    forall stk mem strg ctx,
      exists mem',
           eval_smemory smem1 maxidx1 sb1 stk mem strg ctx ops = Some mem' /\
             eval_smemory smem2 maxidx2 sb2 stk mem strg ctx ops = Some mem'.

Definition safe_sstorage_cmp (sstorage_cmp: sstorage_cmp_t) :=
  forall sstrg1 sstrg2 maxidx1 sb1 maxidx2 sb2 instk_height ops,
    valid_bindings instk_height maxidx1 sb1 ops ->
    valid_bindings instk_height maxidx2 sb2 ops ->
    valid_sstorage instk_height maxidx1 sstrg1 ->
    valid_sstorage instk_height maxidx2 sstrg2 ->
    sstorage_cmp sstrg1 sstrg2 maxidx1 sb1 maxidx2 sb2 instk_height ops = true ->
    forall stk mem strg ctx,
    exists strg',
      eval_sstorage sstrg1 maxidx1 sb1 stk mem strg ctx ops = Some strg' /\
        eval_sstorage sstrg2 maxidx2 sb2 stk mem strg ctx ops = Some strg'.

Definition safe_sha3_cmp (sha3_cmp: sha3_cmp_t) :=
  forall soffset1 ssize1 smem1 soffset2 ssize2 smem2 maxidx1 sb1 maxidx2 sb2 instk_height ops,
    valid_sstack_value instk_height maxidx1 soffset1 ->
    valid_sstack_value instk_height maxidx1 ssize1 ->
    valid_sstack_value instk_height maxidx2 soffset2 ->
    valid_sstack_value instk_height maxidx2 ssize2 ->
    valid_bindings instk_height maxidx1 sb1 ops ->
    valid_bindings instk_height maxidx2 sb2 ops ->
    valid_smemory instk_height maxidx1 smem1 ->
    valid_smemory instk_height maxidx2 smem2 ->
    sha3_cmp soffset1 ssize1 smem1 soffset2 ssize2 smem2 maxidx1 sb1 maxidx2 sb2 instk_height ops = true ->
    forall stk mem strg ctx,
      exists offset1 size1 mem1 offset2 size2 mem2 v,
      eval_smemory smem1 maxidx1 sb1 stk mem strg ctx ops = Some mem1 /\
      eval_smemory smem2 maxidx2 sb2 stk mem strg ctx ops = Some mem2 /\
      eval_sstack_val soffset1 stk mem strg ctx maxidx1 sb1 ops = Some offset1 /\
      eval_sstack_val ssize1 stk mem strg ctx maxidx1 sb1 ops = Some size1 /\
      eval_sstack_val soffset2 stk mem strg ctx maxidx2 sb2 ops = Some offset2 /\
      eval_sstack_val ssize2 stk mem strg ctx maxidx2 sb2 ops = Some size2 /\
      (get_keccak256_ctx ctx) (wordToNat size1) (mload' mem1 offset1 (wordToNat size1)) = v /\
      (get_keccak256_ctx ctx) (wordToNat size2) (mload' mem2 offset2 (wordToNat size2)) = v.

Definition safe_sstack_val_cmp (f_cmp : sstack_val_cmp_t) :=
  forall sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops,
    valid_sstack_value instk_height maxidx1 sv1 ->
    valid_sstack_value instk_height maxidx2 sv2 ->
    valid_bindings instk_height maxidx1 sb1 ops ->
    valid_bindings instk_height maxidx2 sb2 ops ->
    f_cmp sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops = true ->
    forall stk mem strg ctx,
      length stk = instk_height ->
      exists v,
        eval_sstack_val sv1 stk mem strg ctx maxidx1 sb1 ops = Some v /\
          eval_sstack_val sv2 stk mem strg ctx maxidx2 sb2 ops = Some v.

Definition safe_smemory_cmp_ext_d (smemory_cmp: smemory_cmp_ext_t) (sstack_val_cmp: sstack_val_cmp_ext_1_t) (d: nat) :=
    forall d', d' <= d -> safe_smemory_cmp (smemory_cmp (sstack_val_cmp d')).

Definition safe_sstorage_cmp_ext_d (sstorage_cmp: sstorage_cmp_ext_t) (sstack_val_cmp: sstack_val_cmp_ext_1_t) (d: nat) :=
    forall d', d' <= d -> safe_sstorage_cmp (sstorage_cmp (sstack_val_cmp d')).

Definition safe_sha3_cmp_ext_d (sha3_cmp: sha3_cmp_ext_t) (sstack_val_cmp: sstack_val_cmp_ext_1_t) (d: nat) :=
    forall d', d' <= d -> safe_sha3_cmp (sha3_cmp (sstack_val_cmp d')).


Definition safe_sstack_val_cmp_ext_1_d (sstack_val_cmp: sstack_val_cmp_ext_1_t) (d: nat) :=
  forall d', d' <= d -> safe_sstack_val_cmp (sstack_val_cmp d').

Definition safe_sstack_val_cmp_ext_2_d (sstack_val_cmp: sstack_val_cmp_ext_2_t) (smemory_cmp: smemory_cmp_ext_t) (sstorage_cmp: sstorage_cmp_ext_t) (sha3_cmp: sha3_cmp_ext_t)  (d: nat) :=
    safe_sstack_val_cmp_ext_1_d (sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp) d.


Definition safe_smemory_cmp_ext (smemory_cmp: smemory_cmp_ext_t) (sstack_val_cmp: sstack_val_cmp_ext_1_t) :=
  forall d, safe_smemory_cmp_ext_d smemory_cmp sstack_val_cmp d.

Definition safe_sstorage_cmp_ext (sstorage_cmp: sstorage_cmp_ext_t) (sstack_val_cmp: sstack_val_cmp_ext_1_t) :=
  forall d, safe_sstorage_cmp_ext_d sstorage_cmp sstack_val_cmp d.

Definition safe_sha3_cmp_ext (sha3_cmp: sha3_cmp_ext_t) (sstack_val_cmp: sstack_val_cmp_ext_1_t) :=
  forall d, safe_sha3_cmp_ext_d sha3_cmp sstack_val_cmp d.

Definition safe_sstack_val_cmp_ext_2 (sstack_val_cmp: sstack_val_cmp_ext_2_t) (smemory_cmp: smemory_cmp_ext_t) (sstorage_cmp: sstorage_cmp_ext_t) (sha3_cmp: sha3_cmp_ext_t)  :=
  forall d, safe_sstack_val_cmp_ext_2_d sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp d.

Definition safe_sstack_val_cmp_ext_1 (sstack_val_cmp: sstack_val_cmp_ext_1_t) :=
  forall d, safe_sstack_val_cmp_ext_1_d sstack_val_cmp d.



Definition safe_smemory_cmp_ext_wrt_sstack_value_cmp (smemory_cmp: smemory_cmp_ext_t) :=
  forall (d: nat) (sstack_val_cmp: sstack_val_cmp_ext_1_t),
    safe_sstack_val_cmp_ext_1_d sstack_val_cmp d ->
    safe_smemory_cmp_ext_d smemory_cmp sstack_val_cmp d.

Definition safe_sstorage_cmp_ext_wrt_sstack_value_cmp (sstorage_cmp: sstorage_cmp_ext_t) :=
  forall (d: nat) (sstack_val_cmp: sstack_val_cmp_ext_1_t),
    safe_sstack_val_cmp_ext_1_d sstack_val_cmp d ->
    safe_sstorage_cmp_ext_d sstorage_cmp sstack_val_cmp d.

Definition safe_sha3_cmp_ext_wrt_sstack_value_cmp  (sha3_cmp: sha3_cmp_ext_t) :=
  forall (d: nat) (sstack_val_cmp: sstack_val_cmp_ext_1_t),
    safe_sstack_val_cmp_ext_1_d sstack_val_cmp d ->
    safe_sha3_cmp_ext_d sha3_cmp sstack_val_cmp d.

Definition safe_sstack_value_cmp_wrt_others (sstack_val_cmp: sstack_val_cmp_ext_2_t) :=
  forall (d: nat) (smemory_cmp: smemory_cmp_ext_t) (sstorage_cmp: sstorage_cmp_ext_t) (sha3_cmp: sha3_cmp_ext_t),   
    safe_smemory_cmp_ext_d smemory_cmp (sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp) d ->
    safe_sstorage_cmp_ext_d sstorage_cmp (sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp) d ->
    safe_sha3_cmp_ext_d sha3_cmp (sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp) d ->
    safe_sstack_val_cmp_ext_2_d sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp (S d).

Lemma forall_dist_over_and:
  forall (P1 P2 : nat -> Prop),
    (forall d, P1 d /\ P2 d) <->
              ((forall d, P1 d)/\(forall d, P2 d)).
Proof.
  intros.
  split.
  - split.
    + intro. apply H.
    + intro. apply H.
  - intuition.
Qed.

Lemma safe_ext_2_implies_safe_ext_1:
  forall d smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp,
    safe_sstack_val_cmp_ext_2_d sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp d ->
    safe_sstack_val_cmp_ext_1_d (sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp) d.
Proof.
  intros d smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp H_ext_2.
  unfold safe_sstack_val_cmp_ext_2_d in H_ext_2.
  unfold safe_sstack_val_cmp_ext_1_d.
  apply H_ext_2.
Qed.


Lemma safe_ext_smemory_sstorage_sha3_cmp:
  forall (smemory_cmp: smemory_cmp_ext_t) (sstorage_cmp: sstorage_cmp_ext_t) (sha3_cmp: sha3_cmp_ext_t) (sstack_val_cmp: sstack_val_cmp_ext_2_t),
    sstack_val_cmp_fail_for_d_eq_0 sstack_val_cmp ->
    safe_smemory_cmp_ext_wrt_sstack_value_cmp smemory_cmp ->
    safe_sstorage_cmp_ext_wrt_sstack_value_cmp sstorage_cmp ->
    safe_sha3_cmp_ext_wrt_sstack_value_cmp sha3_cmp ->
    safe_sstack_value_cmp_wrt_others sstack_val_cmp ->
    safe_smemory_cmp_ext smemory_cmp (sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp)/\
    safe_sstorage_cmp_ext sstorage_cmp (sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp) /\
    safe_sha3_cmp_ext sha3_cmp (sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp).
Proof.
  intros smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp H_d0 H_s_mem H_s_strg H_s_sha3 H_s_ssval.

  unfold safe_smemory_cmp_ext.
  unfold safe_sstorage_cmp_ext.
  unfold safe_sha3_cmp_ext.
  unfold safe_smemory_cmp_ext_wrt_sstack_value_cmp in H_s_mem.
  unfold safe_sstorage_cmp_ext_wrt_sstack_value_cmp in H_s_strg.
  unfold safe_sha3_cmp_ext_wrt_sstack_value_cmp in H_s_sha3.
  unfold safe_sstack_value_cmp_wrt_others in H_s_ssval.
  
  rewrite <- forall_dist_over_and.
  rewrite <- forall_dist_over_and.
  
  induction d as [|d'].
  - split.
    + apply H_s_mem.
      unfold safe_sstack_val_cmp_ext_1_d.
      intros d' H_d'_le_0.
      apply Nat.leb_le in H_d'_le_0 as H_d'_le_0_leb.
      unfold safe_sstack_val_cmp.
      intros.
      destruct d'; try discriminate.
      unfold sstack_val_cmp_fail_for_d_eq_0 in H_d0.
      pose proof (H_d0 smemory_cmp sstorage_cmp sha3_cmp sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops).
      rewrite H5 in H3.
      discriminate H3.
    + split.
      * apply H_s_strg.
        unfold safe_sstack_val_cmp_ext_1_d.
        intros d' H_d'_le_0.
        apply Nat.leb_le in H_d'_le_0 as H_d'_le_0_leb.
        unfold safe_sstack_val_cmp.
        intros.
        destruct d'; try discriminate.
        unfold sstack_val_cmp_fail_for_d_eq_0 in H_d0.
        pose proof (H_d0 smemory_cmp sstorage_cmp sha3_cmp sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops).
        rewrite H5 in H3.
        discriminate.
      * apply H_s_sha3.
        unfold safe_sstack_val_cmp_ext_1_d.
        intros d' H_d'_le_0.
        apply Nat.leb_le in H_d'_le_0 as H_d'_le_0_leb.
        unfold safe_sstack_val_cmp.
        intros.
        destruct d'; try discriminate.
        unfold sstack_val_cmp_fail_for_d_eq_0 in H_d0.
        pose proof (H_d0 smemory_cmp sstorage_cmp sha3_cmp sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops).
        rewrite H5 in H3.
        discriminate.
  - destruct IHd' as [IHd'_mem [IHd'_strg IHd'_sha3]].
    pose proof (H_s_ssval d' smemory_cmp sstorage_cmp sha3_cmp IHd'_mem IHd'_strg IHd'_sha3) as H_s_ssval_Sd'.
    apply safe_ext_2_implies_safe_ext_1 in H_s_ssval_Sd'.
    split.
    + apply H_s_mem.
      apply H_s_ssval_Sd'.
    + split.
      * apply H_s_strg.
        apply H_s_ssval_Sd'.
      * apply H_s_sha3.
        apply H_s_ssval_Sd'.
Qed.


Lemma safe_ext_sstack_val_cmp:
  forall (smemory_cmp: smemory_cmp_ext_t) (sstorage_cmp: sstorage_cmp_ext_t) (sha3_cmp: sha3_cmp_ext_t) (sstack_val_cmp: sstack_val_cmp_ext_2_t),
    sstack_val_cmp_fail_for_d_eq_0 sstack_val_cmp ->
    safe_smemory_cmp_ext_wrt_sstack_value_cmp smemory_cmp ->
    safe_sstorage_cmp_ext_wrt_sstack_value_cmp sstorage_cmp ->
    safe_sha3_cmp_ext_wrt_sstack_value_cmp sha3_cmp ->
    safe_sstack_value_cmp_wrt_others sstack_val_cmp ->
    safe_sstack_val_cmp_ext_2 sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp.
Proof.
  intros smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp H_d0 H_s_mem H_s_strg H_s_sha3 H_s_ssval.
  pose proof (safe_ext_smemory_sstorage_sha3_cmp smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp H_d0 H_s_mem H_s_strg H_s_sha3 H_s_ssval) as [H_smem [H_sstrg H_sha3]].
  unfold safe_sstack_value_cmp_wrt_others in H_s_ssval.
  unfold safe_sstack_val_cmp_ext_2.

  destruct d as [|d'].
  - unfold safe_sstack_val_cmp_ext_2_d.
    unfold safe_sstack_val_cmp_ext_1_d.
    intros d' H_d'_le_0.
    apply Nat.leb_le in H_d'_le_0 as H_d'_le_0_leb.
    unfold safe_sstack_val_cmp.
    intros sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_sv1 H_valid_sv2 H_valid_sb1 H_valid_sb2 H_sstack_val_cmp_fail_for_d_eq_0.
    destruct d'; try discriminate.
    unfold sstack_val_cmp_fail_for_d_eq_0 in H_d0.
    pose proof (H_d0 smemory_cmp sstorage_cmp sha3_cmp sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops) as H_d0.
    rewrite H_d0 in H_sstack_val_cmp_fail_for_d_eq_0.
    discriminate.
  -
    unfold safe_smemory_cmp_ext in H_smem. pose proof (H_smem d') as H_smem.
    unfold safe_sstorage_cmp_ext in H_sstrg. pose proof (H_sstrg d') as H_sstrg.
    unfold safe_sha3_cmp_ext in H_sha3. pose proof (H_sha3 d') as H_sha3.
    
    pose proof (H_s_ssval d' smemory_cmp sstorage_cmp sha3_cmp H_smem H_sstrg H_sha3) as H_s_ssval_Sd'.

    apply H_s_ssval_Sd'.
Qed.


Lemma safe_ext_all_cmp:
  forall (smemory_cmp: smemory_cmp_ext_t) (sstorage_cmp: sstorage_cmp_ext_t) (sha3_cmp: sha3_cmp_ext_t) (sstack_val_cmp: sstack_val_cmp_ext_2_t),
    sstack_val_cmp_fail_for_d_eq_0 sstack_val_cmp ->
    safe_smemory_cmp_ext_wrt_sstack_value_cmp smemory_cmp ->
    safe_sstorage_cmp_ext_wrt_sstack_value_cmp sstorage_cmp ->
    safe_sha3_cmp_ext_wrt_sstack_value_cmp sha3_cmp ->
    safe_sstack_value_cmp_wrt_others sstack_val_cmp ->
    
    safe_sstack_val_cmp_ext_2 sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp /\
      safe_smemory_cmp_ext smemory_cmp (sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp) /\
      safe_sstorage_cmp_ext sstorage_cmp (sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp) /\
      safe_sha3_cmp_ext sha3_cmp (sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp).

Proof.
  intros smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp H_d0 H_s_mem H_s_strg H_s_sha3 H_s_ssval.
  split.
  - apply safe_ext_sstack_val_cmp.
    + apply H_d0.
    + apply H_s_mem.
    + apply H_s_strg.
    + apply H_s_sha3.
    + apply H_s_ssval.
  - apply safe_ext_smemory_sstorage_sha3_cmp.
    + apply H_d0.
    + apply H_s_mem.
    + apply H_s_strg.
    + apply H_s_sha3.
    + apply H_s_ssval.
Qed.

Lemma safe_all_cmp:
  forall (smemory_cmp: smemory_cmp_ext_t) (sstorage_cmp: sstorage_cmp_ext_t) (sha3_cmp: sha3_cmp_ext_t) (sstack_val_cmp: sstack_val_cmp_ext_2_t),
    sstack_val_cmp_fail_for_d_eq_0 sstack_val_cmp ->
    safe_smemory_cmp_ext_wrt_sstack_value_cmp smemory_cmp ->
    safe_sstorage_cmp_ext_wrt_sstack_value_cmp sstorage_cmp ->
    safe_sha3_cmp_ext_wrt_sstack_value_cmp sha3_cmp ->
    safe_sstack_value_cmp_wrt_others sstack_val_cmp ->
    forall d,
    safe_sstack_val_cmp (sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp d) /\
      safe_smemory_cmp (smemory_cmp (sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp d)) /\
      safe_sstorage_cmp (sstorage_cmp (sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp d)) /\
      safe_sha3_cmp (sha3_cmp (sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp d)).
Proof.
  intros smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp H_d0 H_s_mem H_s_strg H_s_sha3 H_s_ssval.
  intro d.

  pose proof (safe_ext_all_cmp smemory_cmp sstorage_cmp sha3_cmp sstack_val_cmp H_d0 H_s_mem H_s_strg H_s_sha3 H_s_ssval) as [H_safe_sstack_val_cmp_ext [H_safe_smemory_cmp_ext [H_safe_sstorage_cmp_ext H_safe_sha3_cmp_ext]]].

  assert (H_d_le_d: d<=d). intuition.
  repeat split.
  - unfold safe_sstack_val_cmp_ext_2 in H_safe_sstack_val_cmp_ext.
    unfold safe_sstack_val_cmp_ext_2_d in H_safe_sstack_val_cmp_ext.
    unfold safe_sstack_val_cmp_ext_1_d in H_safe_sstack_val_cmp_ext.
    apply H_safe_sstack_val_cmp_ext with (d:=d)(d':=d).
    apply H_d_le_d.
  - unfold safe_smemory_cmp_ext in H_safe_smemory_cmp_ext.
    unfold safe_smemory_cmp_ext_d in H_safe_smemory_cmp_ext.    
    apply H_safe_smemory_cmp_ext  with (d:=d)(d':=d).
    apply H_d_le_d.
  - unfold safe_sstorage_cmp_ext in H_safe_sstorage_cmp_ext.
    unfold safe_sstorage_cmp_ext_d in H_safe_sstorage_cmp_ext.    
    apply H_safe_sstorage_cmp_ext  with (d:=d)(d':=d).
    apply H_d_le_d.
  - unfold safe_sha3_cmp_ext in H_safe_sha3_cmp_ext.
    unfold safe_sha3_cmp_ext_d in H_safe_sha3_cmp_ext.    
    apply H_safe_sha3_cmp_ext  with (d:=d)(d':=d).
    apply H_d_le_d.
Qed.
 

Lemma safe_smemory_cmp_ext_d_lt:
  forall smemory_cmp sstack_val_cmp d1 d2,
    d1 <= d2 ->
    safe_smemory_cmp_ext_d smemory_cmp sstack_val_cmp d2 ->
    safe_smemory_cmp_ext_d smemory_cmp sstack_val_cmp d1.
Proof.
  intros smemory_cmp sstack_val_cmp d1 d2 H_d1_le_d2 H_safe_smem_d2.
  unfold safe_smemory_cmp_ext_d.
  intros d' H_d'_lt_d1.
  unfold safe_smemory_cmp_ext_d in H_safe_smem_d2.
  apply H_safe_smem_d2.
  intuition.
Qed.

Lemma safe_sstorage_cmp_ext_d_lt:
  forall sstorage_cmp sstack_val_cmp d1 d2,
    d1 <= d2 ->
    safe_sstorage_cmp_ext_d sstorage_cmp sstack_val_cmp d2 ->
    safe_sstorage_cmp_ext_d sstorage_cmp sstack_val_cmp d1.
Proof.
  intros sstorage_cmp sstack_val_cmp d1 d2 H_d1_le_d2 H_safe_sstrg_d2.
  unfold safe_sstorage_cmp_ext_d.
  intros d' H_d'_lt_d1.
  unfold safe_sstorage_cmp_ext_d in H_safe_sstrg_d2.
  apply H_safe_sstrg_d2.
  intuition.
Qed.

Lemma safe_sha3_cmp_ext_d_lt:
  forall sha3_cmp sstack_val_cmp d1 d2,
    d1 <= d2 ->
    safe_sha3_cmp_ext_d sha3_cmp sstack_val_cmp d2 ->
    safe_sha3_cmp_ext_d sha3_cmp sstack_val_cmp d1.
Proof.
  intros sha3_cmp sstack_val_cmp d1 d2 H_d1_le_d2 H_safe_sha3_d2.
  unfold safe_sha3_cmp_ext_d.
  intros d' H_d'_lt_d1.
  unfold safe_sha3_cmp_ext_d in H_safe_sha3_d2.
  apply H_safe_sha3_d2.
  intuition.
Qed.

Lemma safe_sstack_val_cmp_ext_2_d_le:
  forall sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp d1 d2,
    d1 <= d2 -> 
    safe_sstack_val_cmp_ext_2_d sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp d2 ->
    safe_sstack_val_cmp_ext_2_d sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp d1.
Proof.
Proof.
  intros sstack_val_cmp smemory_cmp sstorage_cmp sha3_cmp d1 d2 H_d1_le_d2 H_safe_sstack_val_cmp_d2.
  unfold safe_sstack_val_cmp_ext_2_d.
  unfold safe_sstack_val_cmp_ext_1_d.
  intros d' H_d'_lt_d1.
  unfold safe_sstack_val_cmp_ext_2_d in H_safe_sstack_val_cmp_d2.
  unfold safe_sstack_val_cmp_ext_1_d in H_safe_sstack_val_cmp_d2.
  apply H_safe_sstack_val_cmp_d2.
  intuition.
Qed.


End SymbolicStateCmp.

  

Require Import bbv.Word.
Require Import Nat. 
Require Import Coq.NArith.NArith.
Require Import Coq.Bool.Bool.

Require Import Coq.Logic.FunctionalExtensionality.

Require Import FORVES.constants.
Import Constants.

Require Import FORVES.symbolic_state.
Import SymbolicState.

Require Import FORVES.symbolic_state_eval.
Import SymbolicStateEval.

Require Import FORVES.symbolic_state_cmp.
Import SymbolicStateCmp.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.execution_state.
Import ExecutionState.

Require Import FORVES.stack_operation_instructions.
Import StackOpInstrs.

Require Import FORVES.program.
Import Program.

Require Import FORVES.symbolic_state_cmp_impl.
Import SymbolicStateCmpImpl.

Require Import FORVES.symbolic_state_eval_facts.
Import SymbolicStateEvalFacts.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.misc.
Import Misc.

Require Import FORVES.eval_common.
Import EvalCommon.

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import FORVES.optimizations_def.
Import Optimizations_Def.

Require Import FORVES.optimizations_common.
Import Optimizations_Common.

Require Import List.
Import ListNotations.

(* For debugging with print_id *)
(* From ReductionEffect Require Import PrintingEffect. *)


Module Opt_and_shr.


Fixpoint mask_0_1' (n: N) (size: nat): option nat :=
  match size with
  | O => None
  | S size' => 
      if N.eqb n (N.sub (N.pow (2%N) (N.of_nat size)) 1) then Some size
      else mask_0_1' n size'
  end.


Definition mask_0_1 (w: EVMWord) : option nat :=
  mask_0_1' (wordToN w) EVMWordSize.


Definition mask_0_1_follow (sv: sstack_val) 
  (maxid: nat) (sb: sbindings): option nat :=
match follow_in_smap sv maxid sb with
  | Some (FollowSmapVal (SymBasicVal (Val v)) _ _) => mask_0_1 v
  | _ => None
end.


Definition is_shr_const (sv: sstack_val)
  (maxid: nat) (sb: sbindings) :=
match follow_in_smap sv maxid sb with 
| Some (FollowSmapVal (SymOp SHR [arg1; arg2]) idx' sb') => 
    match follow_in_smap arg1 idx' sb' with
    | Some (FollowSmapVal (SymBasicVal (Val v)) _ _) => 
        Some (wordToNat v, arg2)
    | _ => None
    end
| _ => None
end.


(* AND(2^A-1, SHR(B,X)) = SHR(B,X) if EVMWordSize-B <= A and A, B  constants *)
Definition optimize_and_shr_sbinding : opt_smap_value_type :=   
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 

match val with
| SymOp AND [arg1; arg2] => 
  match mask_0_1_follow arg1 maxid sb with
  | Some a => 
    match is_shr_const arg2 maxid sb with
    | Some (b, x) => 
      if (EVMWordSize-b <=? a) then (SymOp SHR [Val (natToWord EVMWordSize b); x], true)
      else (val, false) 
    | None => (val, false)
    end
  | None => 
    match mask_0_1_follow arg2 maxid sb with 
    | Some a => 
      match is_shr_const arg1 maxid sb with
      | Some (b, x) => 
        if (EVMWordSize-b <=? a) then (SymOp SHR [Val (natToWord EVMWordSize b); x], true)
        else (val, false) 
      | None => (val, false) 
      end
    | None => (val, false)
    end
  end
| _ => (val, false)
end.


Lemma and_shr_snd: forall (a b x: EVMWord) (a' b': nat) (exts: externals),  
mask_0_1 a = Some a' ->
wordToNat b = b' ->
EVMWordSize - b' <= a' ->
evm_and exts [a; evm_shr exts [b; x]] = evm_shr exts [b; x].
Proof.
Admitted.



Lemma optimize_and_shr_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_and_shr_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros _ Hvalid_smapv_val Hvalid Hoptm_sbinding.
unfold optimize_and_shr_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try try inject_rw Hoptm_sbinding eq_val'.
destruct args as [|arg1 r1]; try inject_rw Hoptm_sbinding eq_val'.
destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
destruct r2; try inject_rw Hoptm_sbinding eq_val'.
destruct (mask_0_1_follow arg1 n sb) as [a|] eqn: is_mask_arg1.
- destruct (is_shr_const arg2 n sb) as [[b x]|] eqn: eq_is_shr_const_arg2
    ; try inject_rw Hoptm_sbinding eq_val'.
  destruct (EVMWordSize - b <=? a) eqn: eq_b_a; try inject_rw Hoptm_sbinding eq_val'.
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
  simpl. unfold valid_stack_op_instr. simpl.
  split; try intuition.
  unfold is_shr_const in eq_is_shr_const_arg2.
  destruct (follow_in_smap arg2 n sb) as [fsmv2|] eqn: Hfollow_arg2;
    try discriminate.
  destruct fsmv2 as [smv_arg2 idx' sb'].
  destruct (smv_arg2) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
  destruct label2; try discriminate.
  destruct args2 as [|arg21 r2]; try discriminate.
  destruct r2 as [|arg22 r2']; try discriminate.
  destruct r2'; try discriminate.
  destruct (follow_in_smap arg21 idx' sb') as [fsmv21|] eqn: Hfollow_arg21;
    try discriminate.
  destruct fsmv21 as [smv_arg21 idx'' sb''].
  destruct (smv_arg21) as [arg21_ss|_2|label21 args21|_4|_5|_6]; try discriminate.
  destruct (arg21_ss) as [arg21v| |]; try discriminate.
  injection eq_is_shr_const_arg2 as eq_b eq_x.
  rewrite <- eq_x.

  unfold valid_smap_value in Hvalid_smapv_val.
  unfold valid_stack_op_instr in Hvalid_smapv_val.
  simpl in Hvalid_smapv_val.
  destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].

  pose proof (valid_follow_in_smap sb arg2 instk_height n evm_stack_opm
    (SymOp SHR [arg21; arg22]) idx' sb' Hvalid_arg2 Hvalid Hfollow_arg2) as H.
  destruct H as [Hvalid_shr [Hvalid_sb' Himpl]].
  simpl in Hvalid_shr. unfold valid_stack_op_instr in Hvalid_shr. simpl in Hvalid_shr. 
  destruct Hvalid_shr as [_ [Hvalid_arg21 [Hvalid_arg22 _]]].
  pose proof (not_basic_value_smv_symop SHR [arg21; arg22]) as Hnotbasic.
  apply Himpl in Hnotbasic.
  apply valid_sstack_value_gt with (n:=idx'); try assumption.
  
- destruct (mask_0_1_follow arg2 n sb) as [a|]; try inject_rw Hoptm_sbinding eq_val'.
  destruct (is_shr_const arg1 n sb) as [[b x]|] eqn: eq_is_shr_const_arg1
    ; try inject_rw Hoptm_sbinding eq_val'.
  destruct (EVMWordSize - b <=? a) eqn: eq_b_a; try inject_rw Hoptm_sbinding eq_val'.
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
  simpl. unfold valid_stack_op_instr. simpl.
  split; try intuition.
  unfold is_shr_const in eq_is_shr_const_arg1.
  destruct (follow_in_smap arg1 n sb) as [fsmv1|] eqn: Hfollow_arg1;
    try discriminate.
  destruct fsmv1 as [smv_arg1 idx' sb'].
  destruct (smv_arg1) as [| |label1 args1| | | ]; try discriminate.
  destruct label1; try discriminate.
  destruct args1 as [|arg11 r1]; try discriminate.
  destruct r1 as [|arg12 r1']; try discriminate.
  destruct r1'; try discriminate.
  destruct (follow_in_smap arg11 idx' sb') as [fsmv11|] eqn: Hfollow_arg11;
    try discriminate.
  destruct fsmv11 as [smv_arg11 idx'' sb''].
  destruct (smv_arg11) as [arg11_ss| | | | | ]; try discriminate.
  destruct (arg11_ss) as [arg11v| |]; try discriminate.
  injection eq_is_shr_const_arg1 as eq_b eq_x.
  rewrite <- eq_x.

  unfold valid_smap_value in Hvalid_smapv_val.
  unfold valid_stack_op_instr in Hvalid_smapv_val.
  simpl in Hvalid_smapv_val.
  destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].

  pose proof (valid_follow_in_smap sb arg1 instk_height n evm_stack_opm
  (SymOp SHR [arg11; arg12]) idx' sb' Hvalid_arg1 Hvalid Hfollow_arg1) as H.
  destruct H as [Hvalid_shr [Hvalid_sb' Himpl]].
  simpl in Hvalid_shr. unfold valid_stack_op_instr in Hvalid_shr. simpl in Hvalid_shr. 
  destruct Hvalid_shr as [_ [Hvalid_arg11 [Hvalid_arg12 _]]].
  pose proof (not_basic_value_smv_symop SHR [arg11; arg12]) as Hnotbasic.
  apply Himpl in Hnotbasic.
  apply valid_sstack_value_gt with (n:=idx'); try assumption.
Qed.



Lemma optimize_and_shr_sbinding_snd:
opt_sbinding_snd optimize_and_shr_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_and_shr_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_and_shr_sbinding_smapv_valid. 

- (* evaluation is preserved *) 
  intros stk mem strg exts v Hlen Heval_orig.
  unfold optimize_and_shr_sbinding in Hoptm_sbinding.
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymOp label args *)
  destruct label eqn: eq_label; try inject_rw Hoptm_sbinding eq_val'.
  destruct args as [|arg1 r1] eqn: eq_args; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r2; try inject_rw Hoptm_sbinding eq_val'.
  destruct (mask_0_1_follow arg1 idx sb) as [a|] eqn: eq_mask_arg1.
  + destruct (is_shr_const arg2 idx sb) as [[b x]|] eqn: is_shr_const_arg2;
      try inject_rw Hoptm_sbinding eq_val'.
    destruct (EVMWordSize - b <=? a) eqn: eq_b_a; try inject_rw Hoptm_sbinding eq_val'.
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.

    unfold mask_0_1_follow in eq_mask_arg1.
    destruct (follow_in_smap arg1 idx sb) as [fsmv1|] eqn: Hfollow_arg1;
      try discriminate.
    destruct fsmv1 as [smv_arg1 idx' sb'].
    destruct (smv_arg1) as [arg1_ss| | | | | ]; try discriminate.
    destruct (arg1_ss) as [arg1v| |]; try discriminate.

    unfold is_shr_const in is_shr_const_arg2.
    destruct (follow_in_smap arg2 idx sb) as [fsmv2|] eqn: Hfollow_arg2;
      try discriminate.
    destruct fsmv2 as [smv_arg2 idx'' sb''].
    destruct (smv_arg2) as [ | |label2 args2| | | ]; try discriminate.
    destruct label2; try discriminate.
    destruct args2 as [|arg21 r2]; try discriminate.
    destruct r2 as [|arg22 r2']; try discriminate.
    destruct r2'; try discriminate.
    destruct (follow_in_smap arg21 idx'' sb'') as [fsmv21|] eqn: Hfollow_arg21;
      try discriminate.
    destruct fsmv21 as [smv_arg21 idx''' sb'''].
    destruct (smv_arg21) as [arg21_ss| | | | | ]; try discriminate.
    destruct (arg21_ss) as [arg21v| |]; try discriminate.
    injection is_shr_const_arg2 as eq_b eq_x.
    rewrite <- eq_x.
    rewrite <- eq_b.

    unfold eval_sstack_val in Heval_orig.
    simpl in Heval_orig. rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
    simpl in Heval_orig.
    destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb evm_stack_opm)
      as [arg1v'|] eqn: eval_arg1; try discriminate.
    destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb evm_stack_opm)
      as [arg2v'|] eqn: eval_arg2; try discriminate.
    rewrite <- Heval_orig.

    destruct Hvalid as [eq_maxidx [Hvalid_arg1_arg2 Hvalid_sb]].
    rewrite -> eq_maxidx in eval_arg2.
    simpl in eval_arg2.
    rewrite -> Hfollow_arg2 in eval_arg2.
    simpl in eval_arg2.
    destruct (eval_sstack_val' idx arg21 stk mem strg exts idx'' sb''
      evm_stack_opm) as [arg21v'|] eqn: eval_arg21; try discriminate.
    destruct (eval_sstack_val' idx arg22 stk mem strg exts idx'' sb''
      evm_stack_opm) as [arg22v'|] eqn: eval_arg22; try discriminate.
    injection eval_arg2 as eq_arg2v'.
    rewrite <- eq_arg2v'.

    unfold eval_sstack_val.
    simpl. rewrite -> PeanoNat.Nat.eqb_refl. simpl.
    rewrite -> eq_maxidx.
    rewrite -> eval_sstack_val'_const.
    pose proof (follow_suffix sb arg2 idx (SymOp SHR [arg21; arg22]) idx'' sb'' 
      Hfollow_arg2) as Hprefix.
    destruct Hprefix as [prefix sb_prefix].
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_arg22.
    pose proof (eval_sstack_val'_extend_sb instk_height idx stk mem strg exts idx
      sb sb'' evm_stack_opm prefix Hvalid_sb sb_prefix arg22 arg22v' eval_arg22)
      as eval_arg22_alt.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_arg22_alt.
    rewrite -> eval_arg22_alt.
    rewrite <- evm_shr_step with (exts:=exts).
    
    rewrite -> natToWord_wordToNat.
    rewrite -> eq_maxidx in eval_arg1.
    simpl in eval_arg1.
    rewrite -> Hfollow_arg1 in eval_arg1.
    injection eval_arg1 as eq_arg1v'.
    rewrite -> eq_arg1v' in eq_mask_arg1.

    assert (eval_arg21_alt := eval_arg21).
    apply eval'_succ_then_nonzero in eval_arg21 as [pidx eq_idx].
    rewrite -> eq_idx in eval_arg21_alt.
    simpl in eval_arg21_alt.
    rewrite -> Hfollow_arg21 in eval_arg21_alt.
    injection eval_arg21_alt as eq_arg21v'.
    rewrite -> eq_arg21v'.
    rewrite <- evm_and_step with (exts:=exts).
    rewrite -> eq_arg21v' in eq_b.
    apply PeanoNat.Nat.leb_le in eq_b_a.
    rewrite -> and_shr_snd with (a':=a)(b':=b); try intuition.
  + destruct (mask_0_1_follow arg2 idx sb) as [a|] eqn: eq_mask_arg2;
      try inject_rw Hoptm_sbinding eq_val'.
    destruct (is_shr_const arg1 idx sb) as [[b x]|] eqn: is_shr_const_arg1;
      try inject_rw Hoptm_sbinding eq_val'.
    destruct (EVMWordSize - b <=? a) eqn: eq_b_a; try inject_rw Hoptm_sbinding eq_val'.
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.

    unfold mask_0_1_follow in eq_mask_arg2.
    destruct (follow_in_smap arg2 idx sb) as [fsmv2|] eqn: Hfollow_arg2;
      try discriminate.
    destruct fsmv2 as [smv_arg2 idx' sb'].
    destruct (smv_arg2) as [arg2_ss| | | | | ]; try discriminate.
    destruct (arg2_ss) as [arg2v| |]; try discriminate.

    unfold is_shr_const in is_shr_const_arg1.
    destruct (follow_in_smap arg1 idx sb) as [fsmv1|] eqn: Hfollow_arg1;
      try discriminate.
    destruct fsmv1 as [smv_arg1 idx'' sb''].
    destruct (smv_arg1) as [ | |label1 args1| | | ]; try discriminate.
    destruct label1; try discriminate.
    destruct args1 as [|arg11 r1]; try discriminate.
    destruct r1 as [|arg12 r1']; try discriminate.
    destruct r1'; try discriminate.
    destruct (follow_in_smap arg11 idx'' sb'') as [fsmv11|] eqn: Hfollow_arg11;
      try discriminate.
    destruct fsmv11 as [smv_arg11 idx''' sb'''].
    destruct (smv_arg11) as [arg11_ss| | | | | ]; try discriminate.
    destruct (arg11_ss) as [arg11v| |]; try discriminate.
    injection is_shr_const_arg1 as eq_b eq_x.
    rewrite <- eq_x.
    rewrite <- eq_b.

    unfold eval_sstack_val in Heval_orig.
    simpl in Heval_orig. rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
    simpl in Heval_orig.
    destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb evm_stack_opm)
      as [arg1v'|] eqn: eval_arg1; try discriminate.
    destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb evm_stack_opm)
      as [arg2v'|] eqn: eval_arg2; try discriminate.
    rewrite <- Heval_orig.

    destruct Hvalid as [eq_maxidx [Hvalid_arg1_arg2 Hvalid_sb]].
    rewrite -> eq_maxidx in eval_arg1.
    simpl in eval_arg1.
    rewrite -> Hfollow_arg1 in eval_arg1.
    simpl in eval_arg1.
    destruct (eval_sstack_val' idx arg11 stk mem strg exts idx'' sb''
      evm_stack_opm) as [arg11v'|] eqn: eval_arg11; try discriminate.
    destruct (eval_sstack_val' idx arg12 stk mem strg exts idx'' sb''
      evm_stack_opm) as [arg12v'|] eqn: eval_arg12; try discriminate.
    injection eval_arg1 as eq_arg1v'.
    rewrite <- eq_arg1v'.

    unfold eval_sstack_val.
    simpl. rewrite -> PeanoNat.Nat.eqb_refl. simpl.
    rewrite -> eq_maxidx.
    rewrite -> eval_sstack_val'_const.
    pose proof (follow_suffix sb arg1 idx (SymOp SHR [arg11; arg12]) idx'' sb'' 
      Hfollow_arg1) as Hprefix.
    destruct Hprefix as [prefix sb_prefix].
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_arg12.
    pose proof (eval_sstack_val'_extend_sb instk_height idx stk mem strg exts idx
      sb sb'' evm_stack_opm prefix Hvalid_sb sb_prefix arg12 arg12v' eval_arg12)
      as eval_arg12_alt.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_arg12_alt.
    rewrite -> eval_arg12_alt.
    rewrite <- evm_shr_step with (exts:=exts).

    rewrite -> natToWord_wordToNat.
    rewrite -> eq_maxidx in eval_arg2.
    simpl in eval_arg2.
    rewrite -> Hfollow_arg2 in eval_arg2.
    injection eval_arg2 as eq_arg2v'.
    rewrite -> eq_arg2v' in eq_mask_arg2.

    assert (eval_arg11_alt := eval_arg11).
    apply eval'_succ_then_nonzero in eval_arg11 as [pidx eq_idx].
    rewrite -> eq_idx in eval_arg11_alt.
    simpl in eval_arg11_alt.
    rewrite -> Hfollow_arg11 in eval_arg11_alt.
    injection eval_arg11_alt as eq_arg11v'.
    rewrite -> eq_arg11v'.
    rewrite <- evm_and_step with (exts:=exts).
    rewrite -> eq_arg11v' in eq_b.
    apply PeanoNat.Nat.leb_le in eq_b_a.
    rewrite -> and_comm.
    rewrite -> and_shr_snd with (a':=a)(b':=b); try intuition.      
Qed.


End Opt_and_shr.

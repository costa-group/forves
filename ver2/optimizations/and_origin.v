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


Module Opt_and_origin.



Definition two_exp_160_minus_1 : EVMWord := 
let diff := EVMWordSize - EVMAddrSize in
zext (wones EVMAddrSize) diff.

Lemma two_exp_160_minus_1_ok: wordToN two_exp_160_minus_1 = (Npow2 160 - 1)%N.
Proof.
reflexivity.
Qed.


Definition is_origin_mask (sv1 sv2: sstack_val) (fcmp: sstack_val_cmp_t) 
  (maxid instk_height: nat) (sb: sbindings) (ops: stack_op_instr_map) : bool :=
match follow_in_smap sv1 maxid sb with 
| Some (FollowSmapVal (SymOp ORIGIN []) idx' sb') => 
    fcmp sv2 (Val two_exp_160_minus_1) maxid sb maxid sb instk_height ops
| _ => false
end.



(* AND(ORIGIN,2^160-1) = ORIGIN
   AND(2^160-1,ORIGIN) = ORIGIN *)
Definition optimize_and_origin_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp AND [arg1;arg2] => 
  if is_origin_mask arg1 arg2 fcmp maxid instk_height sb ops ||
     is_origin_mask arg2 arg1 fcmp maxid instk_height sb ops 
  then (SymOp ORIGIN [], true)
  else (val, true)
| _ => (val, true)
end.


(*
Lemma zext_zero_eq: forall (sz: nat) (w: word sz),
zext w 0 = w.
Pro
*)


Lemma masking_extension_word: forall (sz1 sz2: nat) (w: word sz1), 
wand (zext w sz2) (zext (wones sz1) sz2) = zext w sz2.
Proof.
intros sz1 sz2. revert sz2.
induction sz2 as [|sz2' IH].
- intros w. admit.
- intros w. unfold zext.
Admitted.


Lemma optimize_and_origin_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_and_origin_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n ops fcmp sb val val' flag.
intros Hvalid_smapv_val Hvalid Hoptm_sbinding.
unfold optimize_and_origin_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try try inject_rw Hoptm_sbinding eq_val'.
destruct args as [|arg1 r1]; try inject_rw Hoptm_sbinding eq_val'.
destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
destruct r2; try inject_rw Hoptm_sbinding eq_val'.
destruct (is_origin_mask arg1 arg2 fcmp n instk_height sb ops || 
          is_origin_mask arg2 arg1 fcmp n instk_height sb ops) 
  eqn: is_origin; try inject_rw Hoptm_sbinding eq_val'.
unfold orb in is_origin.

unfold valid_smap_value in Hvalid_smapv_val.
unfold valid_stack_op_instr in Hvalid_smapv_val.
destruct (ops AND).
destruct Hvalid_smapv_val as [Hlen_and Hvalid_arg1_arg2].
simpl in Hvalid_arg1_arg2.
destruct Hvalid_arg1_arg2 as [Hvalid_arg1 [Hvalid_arg2 _]].

destruct (is_origin_mask arg1 arg2 fcmp n instk_height sb ops) 
  eqn: is_origin_arg1_arg2.
- injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'. 
  unfold is_origin_mask in is_origin_arg1_arg2.
  destruct (follow_in_smap arg1 n sb) as [fsmv1|] eqn: eq_follow_arg1; 
    try discriminate.
  destruct fsmv1 as [smv_arg1 idx1' sb1'] eqn: eq_fsmv_arg1.
  destruct (smv_arg1) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
  destruct label2; try discriminate.
  destruct args2; try discriminate.
  pose proof (valid_follow_in_smap sb arg1 instk_height n ops 
    (SymOp ORIGIN []) idx1' sb1' Hvalid_arg1 Hvalid eq_follow_arg1)
    as Hvalid2.
  destruct Hvalid2 as [Hvalid_smpv [_ Himpl]].
  pose proof (not_basic_value_smv_symop ORIGIN []) as eq_not_basic.
  apply Himpl in eq_not_basic as n_gt_idx1'.
  apply gt_add in n_gt_idx1'. destruct n_gt_idx1' as [k n_gt_idx1'].
  rewrite -> n_gt_idx1'.
  apply valid_smap_value_incr with (m:=k) in Hvalid_smpv.
  assumption.
  
- destruct (is_origin_mask arg2 arg1 fcmp n instk_height sb ops) 
  eqn: is_origin_arg2_arg1; try discriminate.
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'. 
  unfold is_origin_mask in is_origin_arg2_arg1.
  destruct (follow_in_smap arg2 n sb) as [fsmv2|] eqn: eq_follow_arg2; 
    try discriminate.
  destruct fsmv2 as [smv_arg2 idx2' sb2'] eqn: eq_fsmv_arg2.
  destruct (smv_arg2) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
  destruct label2; try discriminate.
  destruct args2; try discriminate.
  pose proof (valid_follow_in_smap sb arg2 instk_height n ops 
    (SymOp ORIGIN []) idx2' sb2' Hvalid_arg2 Hvalid eq_follow_arg2)
    as Hvalid2.
  destruct Hvalid2 as [Hvalid_smpv [_ Himpl]].
  pose proof (not_basic_value_smv_symop ORIGIN []) as eq_not_basic.
  apply Himpl in eq_not_basic as n_gt_idx2'.
  apply gt_add in n_gt_idx2'. destruct n_gt_idx2' as [k n_gt_idx2'].
  rewrite -> n_gt_idx2'.
  apply valid_smap_value_incr with (m:=k) in Hvalid_smpv.
  assumption.
Qed.


Lemma evm_stack_opm_AND:
evm_stack_opm AND = OpImp 2 evm_and (Some and_comm) (Some and_ctx_ind).
Proof.
reflexivity.
Qed.

Lemma lenght2: forall {T: Type} (x y: T), (length [x; y] =? 2) = true.
Proof.
intros T x y.
reflexivity.
Qed.


Lemma optimize_and_origin_sbinding_snd:
opt_sbinding_snd optimize_and_origin_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_and_origin_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_and_origin_sbinding_smapv_valid. 

- (* evaluation is preserved *) 
  (*intros stk mem strg ctx v Hlen Heval_orig.
  unfold optimize_and_and2_sbinding in Hoptm_sbinding.
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymOp label args *)
  destruct label eqn: eq_label; try inject_rw Hoptm_sbinding eq_val'.
  destruct args as [|arg1 r1] eqn: eq_args; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r2; try inject_rw Hoptm_sbinding eq_val'.
  destruct (follow_in_smap arg1 idx sb) as [fsmv|] eqn: eq_follow_arg1;
    try inject_rw Hoptm_sbinding eq_val'.
  destruct fsmv as [smv idx' sb'] eqn: eq_fsmv.
  destruct smv as [_1|_2|label2 args2|_4|_5|_6] eqn: eq_smv;
    try inject_rw Hoptm_sbinding eq_val'.
  destruct label2 eqn: eq_label2; try inject_rw Hoptm_sbinding eq_val'.
  destruct args2 as [|arg11 r21]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r21 as [|arg12 r22]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r22; try inject_rw Hoptm_sbinding eq_val'.
  
  assert (Heval_orig_copy := Heval_orig).
  unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
  rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
  simpl in Heval_orig.
  destruct maxidx as [| maxidx'] eqn: eq_maxidx; try discriminate.
  rewrite -> eval_sstack_val'_one_step in Heval_orig at 1.
  rewrite -> eq_follow_arg1 in Heval_orig.
  rewrite -> evm_stack_opm_AND in Heval_orig.
  rewrite -> lenght2 in Heval_orig.
  unfold map_option in Heval_orig.
  destruct (eval_sstack_val' maxidx' arg11 stk mem strg ctx idx' sb' 
    evm_stack_opm) as [arg11v|] eqn: eval_arg11; try discriminate.
  destruct (eval_sstack_val' maxidx' arg12 stk mem strg ctx idx' sb' 
    evm_stack_opm) as [arg12v|] eqn: eval_arg12; try discriminate.
  destruct (eval_sstack_val' (S maxidx') arg2 stk mem strg ctx idx sb evm_stack_opm)
    as [arg2v|] eqn: eval_arg2; try discriminate.
    
  injection Heval_orig as eq_v.
  rewrite <- eq_v.
  
  destruct (fcmp arg11 arg2 idx' sb' idx sb instk_height evm_stack_opm) 
    eqn: eq_fcmp_arg11_arg2.
  + injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    unfold eval_sstack_val.
    rewrite -> eval_sstack_val'_one_step. 
    rewrite -> follow_in_smap_head_op.
    rewrite -> evm_stack_opm_AND. 
    rewrite -> lenght2.
    unfold map_option.
    
    pose proof (follow_suffix sb arg1 idx (SymOp AND [arg11; arg12]) idx' sb'
      eq_follow_arg1) as Hprefix_sb.
    destruct Hprefix_sb as [prefix Hprefix_sb].
    simpl in Hvalid.
    destruct Hvalid as [eq_idx [Hvalid_stack_op Hvalid_sb]].
    unfold valid_stack_op_instr in Hvalid_stack_op. simpl in Hvalid_stack_op.
    destruct Hvalid_stack_op as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
    
    pose proof (valid_follow_in_smap sb arg1 instk_height idx evm_stack_opm
      (SymOp AND [arg11; arg12]) idx' sb' Hvalid_arg1 Hvalid_sb
      eq_follow_arg1) as Hvalid2.
    destruct Hvalid2 as [Hvalid_smapv_and [Hvalid_sb' Himpl]].
    pose proof (not_basic_value_smv_symop AND [arg11;arg12]) as not_basic_and.
    apply Himpl in not_basic_and.
    unfold valid_smap_value in Hvalid_smapv_and.
    unfold valid_stack_op_instr in Hvalid_smapv_and. 
    rewrite -> evm_stack_opm_AND in Hvalid_smapv_and.
    destruct Hvalid_smapv_and as [_ Hvalid_arg11_arg12].
    simpl in Hvalid_arg11_arg12.
    destruct Hvalid_arg11_arg12 as [Hvalid_arg11_idx' [Hvalid_arg12_idx' _]].
    symmetry in Hlen.
    pose proof (Hsafe_sstack_val_cmp arg11 arg2 idx' sb' idx sb instk_height 
      evm_stack_opm Hvalid_arg11_idx' Hvalid_arg2 Hvalid_sb' Hvalid_sb
      eq_fcmp_arg11_arg2 stk mem strg ctx Hlen) as Hcmp_eval.
    destruct Hcmp_eval as [vv [eval_arg11_vv eval_arg2_vv]].
    unfold eval_sstack_val in eval_arg11_vv.
    unfold eval_sstack_val in eval_arg2_vv.

    assert (eval_arg11_idx := eval_arg11).
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_arg11_idx. 
    
    assert (eval_arg12_idx := eval_arg12).
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_arg12_idx.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_arg11_idx.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_arg12_idx.
    pose proof (eval_sstack_val'_extend_sb instk_height (S maxidx') stk
      mem strg ctx idx sb sb' evm_stack_opm prefix Hvalid_sb Hprefix_sb
      arg11 arg11v eval_arg11_idx) as Heval_arg11_sb.
    rewrite -> Heval_arg11_sb.
    pose proof (eval_sstack_val'_extend_sb instk_height (S maxidx') stk
      mem strg ctx idx sb sb' evm_stack_opm prefix Hvalid_sb Hprefix_sb
      arg12 arg12v eval_arg12_idx) as Heval_arg12_sb.
    rewrite -> Heval_arg12_sb. simpl.
    
    (* arg11v must be arg2v *)
    rewrite -> eq_idx in eval_arg2.
    rewrite -> eval_arg2 in eval_arg2_vv.
    assert (S idx' < S maxidx') as s_idx'_lt_s_maxidx'.
    * intuition.
    * rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_arg11_vv. 
      apply eval_sstack_val'_preserved_when_depth_extended_lt 
        with (d2:=S maxidx')in eval_arg11_vv; try assumption.
      rewrite -> eval_arg11_idx in eval_arg11_vv.
      rewrite <- eval_arg11_vv in eval_arg2_vv.
      injection eval_arg2_vv as eq_arg2v_argv11v.
      rewrite -> eq_arg2v_argv11v.
      rewrite -> wand_wand2_1.
      reflexivity.
      
  + destruct (fcmp arg12 arg2 idx' sb' idx sb instk_height evm_stack_opm)
      eqn: eq_fcmp_arg12_arg2; try inject_rw Hoptm_sbinding eq_val';
      try (rewrite -> eq_v; inject_rw Hoptm_sbinding eq_val').
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    unfold eval_sstack_val.
    rewrite -> eval_sstack_val'_one_step. 
    rewrite -> follow_in_smap_head_op.
    rewrite -> evm_stack_opm_AND. 
    rewrite -> lenght2.
    unfold map_option.
    
    pose proof (follow_suffix sb arg1 idx (SymOp AND [arg11; arg12]) idx' sb'
      eq_follow_arg1) as Hprefix_sb.
    destruct Hprefix_sb as [prefix Hprefix_sb].
    simpl in Hvalid.
    destruct Hvalid as [eq_idx [Hvalid_stack_op Hvalid_sb]].
    unfold valid_stack_op_instr in Hvalid_stack_op. simpl in Hvalid_stack_op.
    destruct Hvalid_stack_op as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
    
    pose proof (valid_follow_in_smap sb arg1 instk_height idx evm_stack_opm
      (SymOp AND [arg11; arg12]) idx' sb' Hvalid_arg1 Hvalid_sb
      eq_follow_arg1) as Hvalid2.
    destruct Hvalid2 as [Hvalid_smapv_and [Hvalid_sb' Himpl]].
    pose proof (not_basic_value_smv_symop AND [arg11;arg12]) as not_basic_and.
    apply Himpl in not_basic_and.
    unfold valid_smap_value in Hvalid_smapv_and.
    unfold valid_stack_op_instr in Hvalid_smapv_and. 
    rewrite -> evm_stack_opm_AND in Hvalid_smapv_and.
    destruct Hvalid_smapv_and as [_ Hvalid_arg11_arg12].
    simpl in Hvalid_arg11_arg12.
    destruct Hvalid_arg11_arg12 as [Hvalid_arg11_idx' [Hvalid_arg12_idx' _]].
    symmetry in Hlen.
    pose proof (Hsafe_sstack_val_cmp arg12 arg2 idx' sb' idx sb instk_height 
      evm_stack_opm Hvalid_arg12_idx' Hvalid_arg2 Hvalid_sb' Hvalid_sb
      eq_fcmp_arg12_arg2 stk mem strg ctx Hlen) as Hcmp_eval.
    destruct Hcmp_eval as [vv [eval_arg12_vv eval_arg2_vv]].
    unfold eval_sstack_val in eval_arg12_vv.
    unfold eval_sstack_val in eval_arg2_vv.

    assert (eval_arg11_idx := eval_arg11).
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_arg11_idx. 
    
    assert (eval_arg12_idx := eval_arg12).
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_arg12_idx.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_arg11_idx.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_arg12_idx.
    pose proof (eval_sstack_val'_extend_sb instk_height (S maxidx') stk
      mem strg ctx idx sb sb' evm_stack_opm prefix Hvalid_sb Hprefix_sb
      arg11 arg11v eval_arg11_idx) as Heval_arg11_sb.
    rewrite -> Heval_arg11_sb.
    pose proof (eval_sstack_val'_extend_sb instk_height (S maxidx') stk
      mem strg ctx idx sb sb' evm_stack_opm prefix Hvalid_sb Hprefix_sb
      arg12 arg12v eval_arg12_idx) as Heval_arg12_sb.
    rewrite -> Heval_arg12_sb. simpl.
    
    (* arg12v must be arg2v *)
    rewrite -> eq_idx in eval_arg2.
    rewrite -> eval_arg2 in eval_arg2_vv.
    assert (S idx' < S maxidx') as s_idx'_lt_s_maxidx'.
    * intuition.
    * rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_arg12_vv.
      apply eval_sstack_val'_preserved_when_depth_extended_lt 
        with (d2:=S maxidx')in eval_arg12_vv; try assumption.
      rewrite -> eval_arg12_idx in eval_arg12_vv.
      rewrite <- eval_arg12_vv in eval_arg2_vv.
      injection eval_arg2_vv as eq_arg2v_argv12v.
      rewrite -> eq_arg2v_argv12v.
      rewrite -> wand_wand2_2.
      reflexivity.*)

Admitted.

End Opt_and_origin.

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


Module Opt_iszero2_lt_zero.


(* ISZERO(ISZERO(X) = LT(0,X) 
   https://github.com/ethereum/solidity/blob/abc46f309676637164076ca1a5b805cd90635bfa/libevmasm/RuleList.h#L180
*)
Definition optimize_iszero2_lt_zero_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp ISZERO [arg1] => 
  match follow_in_smap arg1 maxid sb with
  | Some (FollowSmapVal (SymOp ISZERO [arg2]) idx' sb') => 
      (SymOp LT [Val WZero; arg2], true)
  | _ => (val, false)
  end
| _ => (val, false)
end.

Lemma diff_zero_gt_zero: forall x,
weqb x WZero = false -> (0 <? wordToN x)%N = true.
Proof.
intros x H.
apply weqb_false in H.
unfold WZero in H.
apply wordToN_neq_0 in H.
pose proof (N.div_0_l (wordToN x) H) as HH.
pose proof (N.div_small_iff 0 (wordToN x) H) as HHH.
rewrite -> HHH in HH.
rewrite <- N.ltb_lt in HH.
assumption.
Qed.


Lemma evm_iszero2_lt_zero_snd: forall exts x,
evm_iszero exts [evm_iszero exts [x]] = evm_lt exts [WZero; x].
Proof.
intros exts x.
unfold evm_iszero.
unfold evm_eq.
destruct (weqb x WZero) eqn: eq_x_zero.
- apply weqb_true_iff in eq_x_zero.
  rewrite -> eq_x_zero.
  reflexivity.
- unfold evm_lt.
  simpl.
  apply diff_zero_gt_zero in eq_x_zero.
  rewrite -> eq_x_zero.
  reflexivity.
Qed.


Lemma def_ev_iszero: forall exts x,
evm_iszero exts [x] = if weqb x WZero then WOne else WZero.
Proof.
intros exts x.
intuition.
Qed.


Lemma optimize_iszero2_lt_zero_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_iszero2_lt_zero_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros _ Hvalid_smapv_val Hvalid Hoptm_sbinding.
unfold optimize_iszero2_lt_zero_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct label; try try inject_rw Hoptm_sbinding eq_val'.
destruct args as [|arg1 r1]; try inject_rw Hoptm_sbinding eq_val'.
destruct r1; try inject_rw Hoptm_sbinding eq_val'.
destruct (follow_in_smap arg1 n sb) as [fsmv2|] eqn: eq_follow_arg1;
  try inject_rw Hoptm_sbinding eq_val'.
destruct fsmv2 as [smv2 idx' sb'].
destruct smv2 as [basicv|pushtagv|label2 args2|offset smem|key sstrg|
  offset size smem] eqn: eq_args2; try inject_rw Hoptm_sbinding eq_val'.
  
destruct label2; try try inject_rw Hoptm_sbinding eq_val'.
destruct args2 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
destruct r2; try inject_rw Hoptm_sbinding eq_val'.
injection Hoptm_sbinding as eq_val' _.
rewrite <- eq_val'.

simpl in Hvalid_smapv_val. unfold valid_stack_op_instr in Hvalid_smapv_val.
simpl in Hvalid_smapv_val.
destruct Hvalid_smapv_val as [_ [Hvalid_arg1 _]].
pose proof (valid_follow_in_smap sb arg1 instk_height n evm_stack_opm
  (SymOp ISZERO [arg2]) idx' sb' Hvalid_arg1 Hvalid eq_follow_arg1) 
  as [Hvalid_arg2 [Hvalid_sb' Himpl2]].
pose proof (not_basic_value_smv_symop ISZERO [arg2]) as Hnot_basic2.
apply Himpl2 in Hnot_basic2.

simpl in Hvalid_arg2. unfold valid_stack_op_instr in Hvalid_arg2.
simpl in Hvalid_arg2. destruct Hvalid_arg2 as [_ [Hvalid_arg2 _]].

simpl. unfold valid_stack_op_instr. simpl. split; try intuition.
pose proof (gt_add n idx' Hnot_basic2) as [k2 eq_n].
apply valid_sstack_value_extended_by_i with (i:=k2) in Hvalid_arg2.
rewrite -> eq_n.
assumption.
Qed.


Lemma optimize_iszero2_lt_zero_sbinding_snd:
opt_sbinding_snd optimize_iszero2_lt_zero_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_iszero2_lt_zero_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_iszero2_lt_zero_sbinding_smapv_valid. 

- (* evaluation is preserved *) 
  intros stk mem strg exts v Hlen Heval_orig.
  unfold optimize_iszero2_lt_zero_sbinding in Hoptm_sbinding.
  destruct val as [| |label1 args1| | | ] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
  destruct label1; try inject_rw Hoptm_sbinding eq_val'.
  destruct args1 as [|arg1 r1]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r1; try inject_rw Hoptm_sbinding eq_val'.
  destruct (follow_in_smap arg1 idx sb) as [fsmv2|] eqn: eq_follow_arg1;
  try inject_rw Hoptm_sbinding eq_val'.
  destruct fsmv2 as [smv2 idx' sb'] eqn: eq_fsmv2.
  destruct smv2 as [ | |label2 args2| | | ] eqn: eq_args2; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct label2; try inject_rw Hoptm_sbinding eq_val'.
  destruct args2 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r2; try inject_rw Hoptm_sbinding eq_val'.
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.

  unfold eval_sstack_val in Heval_orig.
  simpl in Heval_orig. rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
  rewrite -> evm_stack_opm_ISZERO in Heval_orig.
  rewrite -> length_one in Heval_orig.
  simpl in Heval_orig.
  destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb evm_stack_opm) as 
    [arg1_v|] eqn: eval_arg1; try discriminate.
  destruct maxidx as [ | n] eqn: eq_maxidx; try discriminate.
  unfold eval_sstack_val' in eval_arg1.
  rewrite -> eq_follow_arg1 in eval_arg1.
  rewrite -> evm_stack_opm_ISZERO in eval_arg1.
  rewrite -> length_one in eval_arg1.
  simpl in eval_arg1.
  fold eval_sstack_val' in eval_arg1.
  destruct (eval_sstack_val' n arg2 stk mem strg exts idx' sb' evm_stack_opm) as 
    [arg2_v|] eqn: eval_arg2; try discriminate.
  injection eval_arg1 as eq_arg1_v.
  rewrite <- eq_arg1_v in Heval_orig.
  rewrite <- Heval_orig.

  unfold eval_sstack_val.
  rewrite <- eq_maxidx.
  simpl.
  rewrite -> PeanoNat.Nat.eqb_refl.
  rewrite -> evm_stack_opm_LT.
  rewrite -> length_two.
  simpl.
  rewrite -> eq_maxidx.
  rewrite -> eval_sstack_val'_const.

  apply follow_suffix in eq_follow_arg1.
  destruct eq_follow_arg1 as [pref eq_sb].
  unfold valid_bindings in Hvalid.
  destruct Hvalid as [eq_n_idx [valid_iszero_arg1 valid_sb]].
  fold valid_bindings in valid_sb.
  rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_arg2.
  apply eval_sstack_val'_extend_sb with (instk_height:=instk_height)
    (sb:=sb)(prefix:=pref) in eval_arg2; try assumption.
  apply eval_sstack_val'_preserved_when_depth_extended in eval_arg2.
  rewrite -> eval_arg2.

  rewrite <- def_ev_iszero with (exts:=exts).
  rewrite <- def_ev_iszero with (exts:=exts).
  rewrite -> evm_iszero2_lt_zero_snd.
  reflexivity.
Qed.


End Opt_iszero2_lt_zero.

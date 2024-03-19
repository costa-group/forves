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


Module Opt_iszero3.


(* ISZERO(ISZERO(ISZERO(X)) = ISZERO(X) *)
Definition optimize_iszero3_sbinding : opt_smap_value_type := 
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
      match follow_in_smap arg2 idx' sb' with
      | Some (FollowSmapVal (SymOp ISZERO [arg3]) idx'' sb'') => 
          (SymOp ISZERO [arg3], true)
      | _ => (val, false)
      end
  | _ => (val, false)
  end
| _ => (val, false)
end.


Lemma evm_iszero3_snd: forall ctx x,
evm_iszero ctx [evm_iszero ctx [evm_iszero ctx [x]]] = evm_iszero ctx [x].
Proof.
intros ctx x.
simpl.
destruct (weqb x WZero) eqn: eq_x_zero; try reflexivity.
Qed.


Lemma optimize_iszero3_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_iszero3_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros _ Hvalid_smapv_val Hvalid Hoptm_sbinding.
unfold optimize_iszero3_sbinding in Hoptm_sbinding.
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
destruct (follow_in_smap arg2) as [fsmv3|] eqn: eq_follow_arg2;
  try inject_rw Hoptm_sbinding eq_val'.
destruct fsmv3 as [smv3 idx'' sb''].
destruct smv3 as [basicv|pushtagv|label3 args3|offset smem|key sstrg|
  offset size smem] eqn: eq_args3; try inject_rw Hoptm_sbinding eq_val'.
destruct label3; try try inject_rw Hoptm_sbinding eq_val'.
destruct args3 as [|arg3 r3]; try inject_rw Hoptm_sbinding eq_val'.
destruct r3; try inject_rw Hoptm_sbinding eq_val'.
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
pose proof (valid_follow_in_smap sb' arg2 instk_height idx' evm_stack_opm
  (SymOp ISZERO [arg3]) idx'' sb'' Hvalid_arg2 Hvalid_sb' eq_follow_arg2)
  as [Hvalid_arg3 [Hvalid_sb'' Himpl3]].
pose proof (not_basic_value_smv_symop ISZERO [arg3]) as Hnot_basic3.
apply Himpl3 in Hnot_basic3.

pose proof (gt_add idx' idx'' Hnot_basic3) as [k3 eq_idx']. 
pose proof (gt_add n idx' Hnot_basic2) as [k2 eq_n].
rewrite -> eq_idx' in eq_n.
rewrite -> Plus.plus_assoc_reverse in eq_n.
apply valid_smap_value_incr with (m:=k3+k2) in Hvalid_arg3.
rewrite -> eq_n.
assumption.
Qed.


Lemma optimize_iszero3_sbinding_snd:
opt_sbinding_snd optimize_iszero3_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_iszero3_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_iszero3_sbinding_smapv_valid. 

- (* evaluation is preserved *) 
  intros stk mem strg ctx v Hlen Heval_orig.
  unfold optimize_iszero3_sbinding in Hoptm_sbinding.
  destruct (val) as [basicv|pushtagv|label1 args1|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
  destruct label1; try try inject_rw Hoptm_sbinding eq_val'.
  destruct args1 as [|arg1 r1]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r1; try inject_rw Hoptm_sbinding eq_val'.
  destruct (follow_in_smap arg1 idx sb) as [fsmv2|] eqn: eq_follow_arg1;
  try inject_rw Hoptm_sbinding eq_val'.
  destruct fsmv2 as [smv2 idx' sb'].
  destruct smv2 as [basicv|pushtagv|label2 args2|offset smem|key sstrg|
    offset size smem] eqn: eq_args2; try inject_rw Hoptm_sbinding eq_val'.
  
  destruct label2; try try inject_rw Hoptm_sbinding eq_val'.
  destruct args2 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r2; try inject_rw Hoptm_sbinding eq_val'.
  destruct (follow_in_smap arg2) as [fsmv3|] eqn: eq_follow_arg2;
    try inject_rw Hoptm_sbinding eq_val'.
  destruct fsmv3 as [smv3 idx'' sb''].
  destruct smv3 as [basicv|pushtagv|label3 args3|offset smem|key sstrg|
    offset size smem] eqn: eq_args3; try inject_rw Hoptm_sbinding eq_val'.
  destruct label3; try try inject_rw Hoptm_sbinding eq_val'.
  destruct args3 as [|arg3 r3]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r3; try inject_rw Hoptm_sbinding eq_val'.
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
  
  unfold eval_sstack_val in Heval_orig.
  simpl in Heval_orig. rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
  simpl in Heval_orig.
  destruct (eval_sstack_val' maxidx arg1 stk mem strg ctx idx sb evm_stack_opm)
    as [arg1_v|] eqn: eval_arg1; try discriminate.
  destruct maxidx as [|maxidx']; try discriminate. simpl in eval_arg1.
  rewrite -> eq_follow_arg1 in eval_arg1. simpl in eval_arg1.
  destruct maxidx' as [|maxidx'']; try discriminate.
  simpl in eval_arg1. rewrite -> eq_follow_arg2 in eval_arg1.
  simpl in eval_arg1.
  
  destruct (eval_sstack_val' maxidx'' arg3 stk mem strg ctx idx'' sb'' 
    evm_stack_opm) as [arg3v|] eqn: eval_arg3; try discriminate.
  unfold eval_sstack_val.
  
  pose proof (follow_suffix sb arg1 idx (SymOp ISZERO [arg2]) idx' sb'
    eq_follow_arg1) as [p1 eq_sb].
  pose proof (follow_suffix sb' arg2 idx'(SymOp ISZERO [arg3]) idx'' sb''
    eq_follow_arg2) as [p2 eq_sb'].
  rewrite -> eq_sb' in eq_sb.
  rewrite -> app_assoc in eq_sb.
  
  rewrite -> eval_sstack_val'_one_step. 
  rewrite -> follow_in_smap_head_op.
  rewrite -> evm_stack_opm_ISZERO.
  rewrite -> length_one.
  unfold map_option.
  
  simpl in Hvalid. destruct Hvalid as [_ [Hvalid_arg1 Hvalid_sb]].
  apply eval_sstack_val'_preserved_when_depth_extended in eval_arg3 as eval_arg3.
  apply eval_sstack_val'_preserved_when_depth_extended in eval_arg3 as eval_arg3.
  rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_arg3.
  pose proof (eval_sstack_val'_extend_sb instk_height (S (S maxidx'')) stk 
    mem strg ctx idx sb sb'' evm_stack_opm (p1 ++ p2) Hvalid_sb eq_sb arg3
    arg3v eval_arg3) as eval_arg3_sb.
  rewrite -> eval_arg3_sb. rewrite <- Heval_orig.
  injection eval_arg1 as eq_arg1_v.
  rewrite <- eq_arg1_v. simpl.
  destruct (weqb arg3v WZero) eqn: eq_arg3v_WZero; try reflexivity.
Qed.

End Opt_iszero3.

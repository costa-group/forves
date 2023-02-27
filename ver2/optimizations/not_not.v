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


Module Opt_not_not.


Definition follow_to_op (sv: sstack_val) (maxidx: nat) (sb: sbindings) 
  : option follow_in_smap_ret_t :=
match follow_in_smap sv maxidx sb with
| Some (FollowSmapVal (SymOp op args) idx' sb') => 
    Some (FollowSmapVal (SymOp op args) idx' sb')
| _ => None
end.


(* NOT(NOT(X)) = X *)
Definition optimize_not_not_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp NOT [arg1] => 
  match follow_to_op arg1 maxid sb with
  | Some (FollowSmapVal (SymOp NOT [arg2]) idx' sb') => 
      (SymBasicVal arg2, true)
  | _ => (val, false)
  end
| _ => (val, false)
end.


Lemma optimize_not_not_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_not_not_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n ops fcmp sb val val' flag.
intros Hvalid_smapv_val Hvalid Hoptm_sbinding.
unfold optimize_not_not_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try try inject_rw Hoptm_sbinding eq_val'.
destruct args as [|arg1 r1] eqn: eq_args; try inject_rw Hoptm_sbinding eq_val'.
destruct r1; try inject_rw Hoptm_sbinding eq_val'.
destruct (follow_to_op arg1 n sb) as [fsmv|] eqn: eq_follow1;
  try inject_rw Hoptm_sbinding eq_val'.
destruct fsmv as [smv idx' sb'] eqn: eq_fsmv.
destruct smv as [x1|x2|label2 args2|x4|x5|x6] eqn: eq_smv;
  try inject_rw Hoptm_sbinding eq_val'.
destruct label2 eqn: eq_label2; try inject_rw Hoptm_sbinding eq_val'.
destruct args2 as [|arg2 r2] eqn: eq_args2; try inject_rw Hoptm_sbinding eq_val'.
destruct r2 as [|x1] eqn: eq_r2; try inject_rw Hoptm_sbinding eq_val'.
injection Hoptm_sbinding as eq_val' _.
rewrite <- eq_val'.
unfold valid_stack_op_instr in Hvalid_smapv_val.
unfold valid_smap_value in Hvalid_smapv_val.
unfold valid_stack_op_instr in Hvalid_smapv_val.
destruct (ops NOT) as [nargs f Hcomm Hctx_indep] eqn: eq_ops.
destruct Hvalid_smapv_val as [eq_len eq_valid_args1].
simpl in eq_valid_args1.
destruct eq_valid_args1 as [eq_valid_arg1 _].
simpl.
unfold follow_to_op in eq_follow1.
destruct (follow_in_smap arg1 n sb) as [fsmv1|] eqn: eq_follow_arg1;
  try discriminate.
destruct fsmv1  as [smv1 idx1 sb1] eqn: eq_fsmv1.
destruct smv1 as [x1|x2|op1 args1|x4|x5|x6] eqn: eq_smv1; try discriminate.
injection eq_follow1 as eq_op1 eq_args1 eq_idx1 eq_sb1.
rewrite -> eq_op1 in eq_follow_arg1.
rewrite -> eq_args1 in eq_follow_arg1.
rewrite -> eq_idx1 in eq_follow_arg1.
rewrite -> eq_sb1 in eq_follow_arg1.
pose proof (valid_follow_in_smap sb arg1 instk_height n ops
  (SymOp NOT [arg2]) idx' sb' eq_valid_arg1 Hvalid eq_follow_arg1) 
  as Hnew_valid.
destruct Hnew_valid as [Hvalid_smap_idx' [Hvalid_sb' Himp]].
assert (not_basic_value_smv (SymOp NOT [arg2]) = true) as not_basic_not_arg2.
- intuition.
- apply Himp in not_basic_not_arg2 as n_gt_idx'.
  simpl in Hvalid_smap_idx'.
  unfold valid_stack_op_instr in Hvalid_smap_idx'.
  rewrite -> eq_ops in Hvalid_smap_idx'.
  simpl in Hvalid_smap_idx'.
  destruct Hvalid_smap_idx' as [_ [Hvalid_sstack_value_arg2_idx' _]].
  apply valid_sstack_value_gt with (n:=idx'); try assumption.
Qed.


Lemma wnot_idempotent: forall {sz : nat} (w : word sz), wnot (wnot w) = w.
Proof.
intros. induction w.
- reflexivity.
- simpl. rewrite <- negb_involutive_reverse.
  rewrite -> IHw.
  reflexivity.
Qed.


Lemma optimize_not_not_sbinding_snd:
opt_sbinding_snd optimize_not_not_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_not_not_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_not_not_sbinding_smapv_valid. 
    
- (* evaluation is preserved *) 
  intros stk mem strg ctx v Hlen Heval_orig.
  (*assert (Hlen2 := Hlen).
  rewrite -> Hlen in Hlen2.
  rewrite <- Hlen in Hlen2 at 2.*)
  unfold optimize_not_not_sbinding in Hoptm_sbinding.
  (*pose proof (Hvalid_maxidx instk_height maxidx idx val sb evm_stack_opm
      Hvalid) as eq_maxidx_idx.*)
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymOp label args *)
  destruct label eqn: eq_label; try inject_rw Hoptm_sbinding eq_val'.
  destruct args as [|arg1 r1] eqn: eq_args; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct r1 as [|_a _b] eqn: eq_r1; try inject_rw Hoptm_sbinding eq_val'.
  destruct (follow_to_op arg1 idx sb) as [fsmv|] eqn: eq_follow_arg1;
    try inject_rw Hoptm_sbinding eq_val'.
  destruct fsmv as [smv idx' sb'] eqn: eq_fsmv.
  destruct smv as [_1|_2|label2 args2|_4|_5|_6] eqn: eq_smv;
    try inject_rw Hoptm_sbinding eq_val'.
  destruct label2 eqn: eq_label2; try inject_rw Hoptm_sbinding eq_val'.
  destruct args2 as [|arg2 r2] eqn: eq_args2; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct r2; try inject_rw Hoptm_sbinding eq_val'.
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
  
  unfold eval_sstack_val in Heval_orig.
  simpl in Heval_orig. rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
  simpl in Heval_orig.
  destruct (eval_sstack_val' maxidx arg1 stk mem strg ctx idx sb evm_stack_opm)
    as [arg1_v|] eqn: eq_eval_arg1_sb; try discriminate.
  rewrite <- Heval_orig.
  destruct maxidx as [|maxidx'] eqn: eq_maxidx; try discriminate. 
  simpl in eq_eval_arg1_sb.
  unfold follow_to_op in eq_follow_arg1.
  destruct (follow_in_smap arg1 idx sb) as [fsmv1|] 
    eqn: eq_follow_smap_arg1; try discriminate.
  destruct fsmv1 as [smv1 idx1 sb1] eqn: eq_fsmv1. 
  destruct smv1 as [_a|_b|op' args'|_d|_e|_f] eqn: eq_smv1;
    try discriminate.
  injection eq_follow_arg1 as eq_op' eq_args' eq_idx' eq_sb1.
  rewrite -> eq_op' in eq_eval_arg1_sb.
  simpl in eq_eval_arg1_sb. rewrite -> eq_args' in eq_eval_arg1_sb.
  simpl in eq_eval_arg1_sb.
  destruct (eval_sstack_val' maxidx' arg2 stk mem strg ctx idx1 sb1 
    evm_stack_opm) as [arg2v|] eqn: eq_eval_arg2_sb1; try discriminate.
  injection eq_eval_arg1_sb as eq_arg1v.
  rewrite <- eq_arg1v. simpl.
  
  unfold eval_sstack_val. 
  rewrite <- eval_sstack_val'_freshvar.
  apply eval_sstack_val'_preserved_when_depth_extended in eq_eval_arg2_sb1.
  apply eval_sstack_val'_preserved_when_depth_extended in eq_eval_arg2_sb1.
  rewrite -> eq_op' in eq_follow_smap_arg1.
  rewrite -> eq_args' in eq_follow_smap_arg1.
  pose proof (follow_suffix sb arg1 idx (SymOp NOT [arg2]) idx1 sb1
    eq_follow_smap_arg1) as eq_sb_prefix.
  destruct eq_sb_prefix as [prefix eq_sb_prefix].
  simpl in Hvalid. 
  destruct Hvalid as [eq_idx_maxidx' [Hvalid_stack_op Hvalid_sb1]].
  pose proof (eval_sstack_val'_extend_sb_indep instk_height idx 
    (S (S maxidx')) stk mem strg ctx idx1 (S maxidx') sb sb1 evm_stack_opm
    prefix Hvalid_sb1 eq_sb_prefix arg2 arg2v eq_eval_arg2_sb1)
    as eq_eval_ext.
  rewrite -> eq_eval_ext.
  rewrite -> wnot_idempotent.
  reflexivity.
Qed.


End Opt_not_not.

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


Module Opt_iszero_sub.


Definition is_sub (sv: sstack_val) (fcmp: sstack_val_cmp_t) 
  (maxid instk_height: nat) (sb: sbindings) (ops: stack_op_instr_map) :=
match follow_in_smap sv maxid sb with 
| Some (FollowSmapVal (SymOp SUB [arg1; arg2]) idx' sb') => 
      Some [arg1; arg2]
| _ => None
end.



(* ISZERO(SUB(X, Y)) = EQ(X, Y) *)
Definition optimize_iszero_sub_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp ISZERO [arg1] => 
  match is_sub arg1 fcmp maxid instk_height sb ops with
  | Some args => (SymOp EQ args, true)
  | _ => (val, false)
  end
| _ => (val, false)
end.



Lemma iszero_sub_correct: forall (x y: EVMWord) ctx,
evm_iszero ctx [wminus x y] = evm_eq ctx [x; y].
Proof.
intros. simpl.
destruct (weqb (wminus x y) WZero) eqn: eq_wminus_x_y.
- apply weqb_true_iff in eq_wminus_x_y.
  apply sub_0_eq in eq_wminus_x_y.
  apply weqb_eq in eq_wminus_x_y.
  rewrite -> eq_wminus_x_y.
  reflexivity.
- apply weqb_false in eq_wminus_x_y.
  apply word_neq in eq_wminus_x_y.
  apply weqb_ne in eq_wminus_x_y.
  rewrite -> eq_wminus_x_y.
  reflexivity.
Qed.




Lemma optimize_iszero_sub_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_iszero_sub_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros Hvalid_smapv_val Hvalid Hoptm_sbinding.
unfold optimize_iszero_sub_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try try inject_rw Hoptm_sbinding eq_val'.
destruct args as [|arg1 r1]; try inject_rw Hoptm_sbinding eq_val'.
destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
destruct (is_sub arg1 fcmp n instk_height sb evm_stack_opm) as [args|] 
  eqn: is_sub_arg1; try inject_rw Hoptm_sbinding eq_val'.
injection Hoptm_sbinding as eq_val' _.
rewrite <- eq_val'.
unfold is_sub in is_sub_arg1.
destruct (follow_in_smap arg1 n sb) as [fsmv1|] eqn: Hfollow_arg1;
    try discriminate.
destruct fsmv1 as [smv_arg1 idx' sb'].
destruct (smv_arg1) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
destruct label2; try discriminate.
destruct args2 as [|xx r2]; try discriminate.
destruct r2 as [|yy r2']; try discriminate.
destruct r2'; try discriminate.
injection is_sub_arg1 as eq_args.
rewrite <- eq_args.

simpl in Hvalid_smapv_val. unfold valid_stack_op_instr in Hvalid_smapv_val.
simpl in Hvalid_smapv_val.
destruct Hvalid_smapv_val as [_ [Hvalid_sstack_arg1 _]].
pose proof (valid_follow_in_smap sb arg1 instk_height n evm_stack_opm
  (SymOp SUB [xx; yy]) idx' sb' Hvalid_sstack_arg1 Hvalid Hfollow_arg1) as Himpl.
destruct Himpl as [Hvalid_sub [Hvalid_sb' Himpl]].
pose proof (not_basic_value_smv_symop SUB [xx; yy]) as Hnot_basic.
apply Himpl in Hnot_basic.
unfold valid_smap_value in Hvalid_sub. 
unfold valid_stack_op_instr in Hvalid_sub.
simpl in Hvalid_sub.
destruct Hvalid_sub as [_ [Hvalid_xx [Hvalid_yy _]]].
apply valid_sstack_value_gt with (m:=n) in Hvalid_xx; try assumption.
apply valid_sstack_value_gt with (m:=n) in Hvalid_yy; try assumption.

simpl. unfold valid_stack_op_instr. simpl. 
intuition.
Qed.


Lemma optimize_iszero_sub_sbinding_snd:
opt_sbinding_snd optimize_iszero_sub_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_iszero_sub_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_iszero_sub_sbinding_smapv_valid. 

- (* evaluation is preserved *) 
  intros stk mem strg ctx v Hlen Heval_orig.
  unfold optimize_iszero_sub_sbinding in Hoptm_sbinding.
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymOp label args *)
  destruct label eqn: eq_label; try inject_rw Hoptm_sbinding eq_val'.
  destruct args as [|arg1 r1] eqn: eq_args; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
  destruct (is_sub arg1 fcmp idx instk_height sb evm_stack_opm) 
    as [largs|] eqn: is_sub_arg1; try inject_rw Hoptm_sbinding eq_val'.
  
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
  unfold is_sub in is_sub_arg1.
  destruct (follow_in_smap arg1 idx sb) as [fsmv1|] eqn: Hfollow_arg1;
    try discriminate.
  destruct fsmv1 as [smv_arg1 idx' sb'].
  destruct (smv_arg1) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
  destruct label2; try discriminate.
  destruct args2 as [|xx r2]; try discriminate.
  destruct r2 as [|yy r2']; try discriminate.
  destruct r2'; try discriminate.
  injection is_sub_arg1 as eq_largs.
  rewrite <- eq_largs.
      
  unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
  rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
  simpl in Heval_orig.
  destruct (eval_sstack_val' maxidx arg1 stk mem strg ctx idx sb 
    evm_stack_opm) as [arg1v|] eqn: eval_arg1; try discriminate.
  
  simpl in Hvalid.
  destruct Hvalid as [eq_maxidx' [Hvalid_arg1 Hvalid_sb]].
  unfold valid_stack_op_instr in Hvalid_arg1.
  simpl in Hvalid_arg1.
  destruct Hvalid_arg1 as [_ [Hvalid_arg1 _]].
  pose proof (follow_suffix sb arg1 idx (SymOp SUB [xx; yy]) idx' sb'
    Hfollow_arg1) as [prefix sb_prefix].
  
  (* rewrite <- Heval_orig.  *)
  (*destruct maxidx as [|maxidx'] eqn: eq_maxidx; 
    try (simpl in eval_arg1; discriminate).*)
  rewrite -> eq_maxidx' in eval_arg1.
  simpl in eval_arg1.
  rewrite -> Hfollow_arg1 in eval_arg1.
  simpl in eval_arg1.
  destruct (eval_sstack_val' idx xx stk mem strg ctx idx' sb' 
    evm_stack_opm) as [xxv|] eqn: eval_xx_sb'; try discriminate.
  destruct (eval_sstack_val' idx yy stk mem strg ctx idx' sb' 
    evm_stack_opm) as [yyv|] eqn: eval_yy_sb'; try discriminate.
  unfold eval_sstack_val in eval_arg1. simpl.
  
  unfold eval_sstack_val. 
  rewrite -> eval_sstack_val'_one_step.
  rewrite -> follow_in_smap_head_op.
  rewrite -> evm_stack_opm_EQ.
  rewrite -> length_two.
  unfold map_option.
  simpl.
  
  rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_xx_sb'.
  pose proof (eval_sstack_val'_extend_sb instk_height idx stk mem strg
    ctx idx sb sb' evm_stack_opm prefix Hvalid_sb sb_prefix xx xxv
    eval_xx_sb') as eval_x_sb.
  apply eval_sstack_val'_preserved_when_depth_extended in eval_x_sb.
  rewrite <- eq_maxidx' in eval_x_sb.
  rewrite -> eval_x_sb. 
  
  rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_yy_sb'.
  pose proof (eval_sstack_val'_extend_sb instk_height idx stk mem strg
    ctx idx sb sb' evm_stack_opm prefix Hvalid_sb sb_prefix yy yyv
    eval_yy_sb') as eval_y_sb.
  apply eval_sstack_val'_preserved_when_depth_extended in eval_y_sb.
  rewrite <- eq_maxidx' in eval_y_sb.
  rewrite -> eval_y_sb.
  
  injection eval_arg1 as eq_arg1v.
  rewrite <- eq_arg1v in Heval_orig.
  rewrite <- Heval_orig.
  rewrite -> iszero_sub_correct.
  reflexivity.
Qed.


End Opt_iszero_sub.

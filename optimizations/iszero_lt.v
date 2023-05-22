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


Module Opt_iszero_lt.


Definition is_lt_zero (sv: sstack_val) (fcmp: sstack_val_cmp_t) 
  (maxid instk_height: nat) (sb: sbindings) (ops: stack_op_instr_map) :=
match follow_in_smap sv maxid sb with 
| Some (FollowSmapVal (SymOp LT [arg1; arg2]) idx' sb') => 
    if fcmp arg1 (Val WZero) maxid sb maxid sb instk_height ops
    then Some arg2
    else None
| _ => None
end.



(* ISZERO(LT(0, X)) = ISZERO(X) *)
Definition optimize_iszero_lt_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp ISZERO [arg] => 
  match is_lt_zero arg fcmp maxid instk_height sb ops with
  | Some x => (SymOp ISZERO [x], true)
  | None => (val, false)
  end
| _ => (val, false)
end.




Lemma zero_lt_then_diff_zero: forall x,
(0 <? wordToN x)%N = true -> x <> WZero.
Proof.
intros x. intros H.
rewrite -> N.ltb_lt in H.
intuition.
rewrite -> H0 in H.
simpl in H.
intuition.
Qed.


Lemma zero_not_lt_then_eq_zero_N: forall (x:N),
~ (0 < x)%N -> x = 0%N.
Proof.
intros x H.
rewrite N.nlt_ge in H.
apply N.le_0_r in H.
assumption.
Qed.


Lemma NToWord_eq: forall size a b,
a = b -> NToWord size a = NToWord size b.
Proof.
intros size a b H.
rewrite -> H.
reflexivity.
Qed.


Lemma zero_not_lt_then_eq_zero: forall x,
(0 <? wordToN x)%N = false -> x = WZero.
Proof.
intros x. intros H.
destruct (weqb x WZero) eqn: eq_x_zero.
- apply weqb_sound in eq_x_zero.
  assumption.
- apply weqb_false in eq_x_zero.
  rewrite -> N.ltb_nlt in H.
  apply zero_not_lt_then_eq_zero_N in H.
  apply NToWord_eq with (size:=EVMWordSize) in H.
  rewrite -> NToWord_wordToN in H.
  rewrite H in eq_x_zero.
  intuition.
Qed.


Lemma iszero_lt_zero_snd: forall ctx x,
evm_iszero ctx [evm_lt ctx [WZero; x]] = evm_iszero ctx [x].
Proof.
intros ctx x.
simpl.
destruct (0 <? wordToN x)%N eqn: eq_x_gt_zero.
- apply zero_lt_then_diff_zero in eq_x_gt_zero.
  apply weqb_ne in eq_x_gt_zero.
  rewrite -> eq_x_gt_zero.
  reflexivity.
- apply zero_not_lt_then_eq_zero in eq_x_gt_zero as x_eq_zero.
  rewrite -> x_eq_zero. 
  reflexivity.
Qed.




Lemma optimize_iszero_lt_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_iszero_lt_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros Hvalid_smapv_val Hvalid Hoptm_sbinding.
unfold optimize_iszero_lt_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try try inject_rw Hoptm_sbinding eq_val'.
destruct args as [|arg1 r1]; try inject_rw Hoptm_sbinding eq_val'.
destruct r1; try inject_rw Hoptm_sbinding eq_val'.
destruct (is_lt_zero arg1 fcmp n instk_height sb evm_stack_opm) as [x|] 
  eqn: is_lt_zero_arg1.
- injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
  unfold is_lt_zero in is_lt_zero_arg1.
  destruct (follow_in_smap arg1 n sb) as [fsmv1|] eqn: Hfollow_arg1;
    try discriminate.
  destruct fsmv1 as [smv_arg1 idx' sb'].
  destruct (smv_arg1) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
  destruct label2; try discriminate.
  destruct args2 as [|zerov r2]; try discriminate.
  destruct r2 as [|xx r2']; try discriminate.
  destruct r2'; try discriminate.
  destruct (fcmp zerov (Val WZero) n sb n sb instk_height evm_stack_opm) eqn: fcmp_onev;
    try discriminate.
    
  simpl in Hvalid_smapv_val. unfold valid_stack_op_instr in Hvalid_smapv_val.
  simpl in Hvalid_smapv_val.
  destruct Hvalid_smapv_val as [_ [Hvalid_arg1 _]].
  injection is_lt_zero_arg1 as eq_xx. rewrite -> eq_xx in Hfollow_arg1.
  pose proof (valid_follow_in_smap sb arg1 instk_height n evm_stack_opm
    (SymOp LT [zerov; x]) idx' sb' Hvalid_arg1 Hvalid Hfollow_arg1) as Himpl.
  destruct Himpl as [Hvalid_lt [Hvalid_sb' Himpl]].
  pose proof (not_basic_value_smv_symop LT [zerov;x]) as Hnot_basic.
  apply Himpl in Hnot_basic.
  unfold valid_smap_value in Hvalid_lt. 
  unfold valid_stack_op_instr in Hvalid_lt.
  simpl in Hvalid_lt.
  destruct Hvalid_lt as [_ [Hvalid_zero_idx' [Hvalid_x_idx' _]]].
  apply valid_sstack_value_gt with (m:=n) in Hvalid_x_idx'; try assumption.
  
  simpl. unfold valid_stack_op_instr.
  simpl. 
  intuition.
- inject_rw Hoptm_sbinding eq_val'.
Qed.


Lemma optimize_iszero_lt_sbinding_snd:
opt_sbinding_snd optimize_iszero_lt_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_iszero_lt_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_iszero_lt_sbinding_smapv_valid. 

- (* evaluation is preserved *) 
  intros stk mem strg ctx v Hlen Heval_orig.
  unfold optimize_iszero_lt_sbinding in Hoptm_sbinding.
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymOp label args *)
  destruct label eqn: eq_label; try inject_rw Hoptm_sbinding eq_val'.
  destruct args as [|arg1 r1] eqn: eq_args;
    try inject_rw Hoptm_sbinding eq_val'.
  destruct r1; try inject_rw Hoptm_sbinding eq_val'.
  destruct (is_lt_zero arg1 fcmp idx instk_height sb evm_stack_opm) 
    as [x|] eqn: is_lt_zero_arg1; try inject_rw Hoptm_sbinding eq_val'.
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
  unfold is_lt_zero in is_lt_zero_arg1.
  destruct (follow_in_smap arg1 idx sb) as [fsmv1|] eqn: Hfollow_arg1;
    try discriminate.
  destruct fsmv1 as [smv_arg1 idx' sb'].
  destruct (smv_arg1) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
  destruct label2; try discriminate.
  destruct args2 as [|zerov r2]; try discriminate.
  destruct r2 as [|xx r2']; try discriminate.
  destruct r2'; try discriminate.
  destruct (fcmp zerov (Val WZero) idx sb idx sb instk_height evm_stack_opm) eqn: fcmp_onev;
    try discriminate.
      
  unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
  rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
  simpl in Heval_orig.
  destruct (eval_sstack_val' maxidx arg1 stk mem strg ctx idx sb 
    evm_stack_opm) as [arg1v|] eqn: eval_arg1; try discriminate.
    
  unfold eval_sstack_val. simpl.
  rewrite -> PeanoNat.Nat.eqb_refl. simpl.
  pose proof (eval'_succ_then_nonzero maxidx arg1 stk mem strg ctx idx sb
     evm_stack_opm arg1v eval_arg1) as [n eq_maxidx].
  rewrite -> eq_maxidx in eval_arg1. simpl in eval_arg1.
  rewrite -> Hfollow_arg1 in eval_arg1. simpl in eval_arg1.
  destruct (eval_sstack_val' n zerov stk mem strg ctx idx' sb'
    evm_stack_opm) as [zerovv|] eqn: eval_zerov; try discriminate.
  destruct (eval_sstack_val' n xx stk mem strg ctx idx' sb'
    evm_stack_opm) as [xxv|] eqn: eval_xx; try discriminate.
  injection is_lt_zero_arg1 as eq_x.
  rewrite -> eq_x in eval_xx.
    
  pose proof (follow_suffix sb arg1 idx (SymOp LT [zerov; xx]) idx' sb'
    Hfollow_arg1) as [prefix sb_prefix].
  simpl in Hvalid.
  destruct Hvalid as [eq_maxidx' [Hvalid_arg1 Hvalid_sb]].
  unfold valid_stack_op_instr in Hvalid_arg1.
  simpl in Hvalid_arg1.
  destruct Hvalid_arg1 as [_ [Hvalid_arg1 _]].
  rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_xx.
  pose proof (eval_sstack_val'_extend_sb instk_height n stk mem strg
    ctx idx sb sb' evm_stack_opm prefix Hvalid_sb sb_prefix x xxv
    eval_xx) as eval_x_sb.
  apply eval_sstack_val'_preserved_when_depth_extended in eval_x_sb.
  rewrite <- eq_maxidx in eval_x_sb.
  rewrite -> eval_x_sb.
  rewrite <- Heval_orig.
    
  pose proof (valid_follow_in_smap sb arg1 instk_height idx evm_stack_opm
    (SymOp LT [zerov; xx]) idx' sb' Hvalid_arg1 Hvalid_sb Hfollow_arg1)
    as [Hvalid_smv [Hvalid_sb' Himpl]].
  pose proof (not_basic_value_smv_symop LT [zerov; xx]) as Hnot_basic.
  apply Himpl in Hnot_basic as idx_gt_idx'.
  unfold valid_smap_value in Hvalid_smv.
  unfold valid_stack_op_instr in Hvalid_smv.
  simpl in Hvalid_smv.
  destruct Hvalid_smv as [_ [Hvalid_onev [Hvalid_xx _]]].
  pose proof (valid_sstack_value_gt instk_height idx' idx zerov Hvalid_onev
    idx_gt_idx') as Hvalid_zero.
  symmetry in Hlen.
     
  pose proof (valid_sstack_value_const instk_height idx WZero) as Hvalid_WZero.
  pose proof (Hsafe_sstack_val_cmp zerov (Val WZero) idx sb idx sb instk_height
    evm_stack_opm Hvalid_zero Hvalid_WZero Hvalid_sb Hvalid_sb fcmp_onev
    stk mem strg ctx Hlen) as [vv [eval_zerov' eval_WZero]].
  unfold eval_sstack_val in eval_zerov'.
  unfold eval_sstack_val in eval_WZero.
  rewrite -> eval_sstack_val'_const in eval_WZero.
  rewrite <- eval_WZero in eval_zerov'.
  apply eval_sstack_val'_preserved_when_depth_extended in eval_zerov.
  rewrite <- eq_maxidx' in eval_zerov'.
  rewrite <- eq_maxidx  in eval_zerov.
  rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_zerov.
  pose proof (eval_sstack_val'_extend_sb instk_height maxidx stk mem strg
    ctx idx sb sb' evm_stack_opm prefix Hvalid_sb sb_prefix zerov zerovv
    eval_zerov) as eval_zerov_sb.
  rewrite -> eval_zerov' in eval_zerov_sb.
  injection eval_zerov_sb as eq_zerovv.

  injection eval_arg1 as eq_argv1.
  rewrite <- eq_argv1. simpl.
  pose proof (iszero_lt_zero_snd ctx xxv) as H. simpl in H.
  rewrite <- H. rewrite <- eq_zerovv. simpl.
  reflexivity.
Qed.


End Opt_iszero_lt.

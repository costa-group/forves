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


Module Opt_add_sub.


Definition is_sub_x (sv x: sstack_val) (fcmp: sstack_val_cmp_t) 
  (maxid instk_height: nat) (sb: sbindings) (ops: stack_op_instr_map) :=
match follow_in_smap sv maxid sb with 
| Some (FollowSmapVal (SymOp SUB [arg1; arg2]) idx' sb') => 
    if fcmp arg2 x maxid sb maxid sb instk_height ops
    then Some arg1
    else None
| _ => None
end.



(* ADD(X, SUB(Y,X)) = Y
   ADD(SUB(Y,X), X) = Y *)
Definition optimize_add_sub_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp ADD [arg1; arg2] => 
  match is_sub_x arg1 arg2 fcmp maxid instk_height sb ops with
  | Some y => (SymBasicVal y, true)
  | None => match is_sub_x arg2 arg1 fcmp maxid instk_height sb ops with
            | Some y => (SymBasicVal y, true)
            | None => (val, false)
            end
  end
| _ => (val, false)
end.


Lemma optimize_add_sub_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_add_sub_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros _ Hvalid_smapv_val Hvalid Hoptm_sbinding.
unfold optimize_add_sub_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try try inject_rw Hoptm_sbinding eq_val'.
destruct args as [|arg1 r1]; try inject_rw Hoptm_sbinding eq_val'.
destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
destruct r2; try inject_rw Hoptm_sbinding eq_val'.
destruct (is_sub_x arg1 arg2 fcmp n instk_height sb evm_stack_opm) as [y|] eqn: is_shl_arg1.
- injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
  unfold is_sub_x in is_shl_arg1.
  destruct (follow_in_smap arg1 n sb) as [fsmv1|] eqn: Hfollow_arg1;
    try discriminate.
  destruct fsmv1 as [smv_arg1 idx' sb'].
  destruct (smv_arg1) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
  destruct label2; try discriminate.
  destruct args2 as [|yy r2]; try discriminate.
  destruct r2 as [|x r2']; try discriminate.
  destruct r2'; try discriminate.
  destruct (fcmp x arg2 n sb n sb instk_height evm_stack_opm) eqn: fcmp_x_arg2;
    try discriminate.
  injection is_shl_arg1 as eq_yy.
  rewrite -> eq_yy in Hfollow_arg1.
    
  simpl in Hvalid_smapv_val. unfold valid_stack_op_instr in Hvalid_smapv_val.
  simpl in Hvalid_smapv_val.
  destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [_ _]]].
  pose proof (valid_follow_in_smap sb arg1 instk_height n evm_stack_opm
    (SymOp SUB [y; x]) idx' sb' Hvalid_arg1 Hvalid Hfollow_arg1) as Himpl.
  destruct Himpl as [Hvalid_sub [Hvalid_sb' Himpl]].
  pose proof (not_basic_value_smv_symop SUB [y;x]) as Hnot_basic.
  apply Himpl in Hnot_basic.
  unfold valid_smap_value in Hvalid_sub.
  unfold valid_stack_op_instr in Hvalid_sub.
  simpl in Hvalid_sub.
  destruct Hvalid_sub as [_ [Hvalid_y_idx' _]].
  apply valid_sstack_value_gt with (m:=n) in Hvalid_y_idx'; try assumption.
- destruct (is_sub_x arg2 arg1 fcmp n instk_height sb evm_stack_opm) as [y|] 
    eqn: is_sub_arg2; try inject_rw Hoptm_sbinding eq_val'.
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
  unfold is_sub_x in is_sub_arg2.
  destruct (follow_in_smap arg2 n sb) as [fsmv2|] eqn: Hfollow_arg2;
    try discriminate.
  destruct fsmv2 as [smv_arg2 idx' sb'].
  destruct (smv_arg2) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
  destruct label2; try discriminate.
  destruct args2 as [|yy r2]; try discriminate.
  destruct r2 as [|x r2']; try discriminate.
  destruct r2'; try discriminate.
  destruct (fcmp x arg1 n sb n sb instk_height evm_stack_opm) eqn: fcmp_x_arg1;
    try discriminate.
  injection is_sub_arg2 as eq_yy.
  rewrite -> eq_yy in Hfollow_arg2.
    
  simpl in Hvalid_smapv_val. unfold valid_stack_op_instr in Hvalid_smapv_val.
  simpl in Hvalid_smapv_val.
  destruct Hvalid_smapv_val as [_ [_ [Hvalid_arg2 _]]].
  pose proof (valid_follow_in_smap sb arg2 instk_height n evm_stack_opm
    (SymOp SUB [y; x]) idx' sb' Hvalid_arg2 Hvalid Hfollow_arg2) as Himpl.
  destruct Himpl as [Hvalid_sub [Hvalid_sb' Himpl]].
  pose proof (not_basic_value_smv_symop SUB [y;x]) as Hnot_basic.
  apply Himpl in Hnot_basic.
  unfold valid_smap_value in Hvalid_sub. 
  unfold valid_stack_op_instr in Hvalid_sub.
  simpl in Hvalid_sub.
  destruct Hvalid_sub as [_ [Hvalid_y _]].
  apply valid_sstack_value_gt with (m:=n) in Hvalid_y; try assumption.
Qed.


Lemma optimize_add_sub_sbinding_snd:
opt_sbinding_snd optimize_add_sub_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_add_sub_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_add_sub_sbinding_smapv_valid. 

- (* evaluation is preserved *) 
  intros stk mem strg exts v Hlen Heval_orig.
  unfold optimize_add_sub_sbinding in Hoptm_sbinding.
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymOp label args *)
  destruct label eqn: eq_label; try inject_rw Hoptm_sbinding eq_val'.
  destruct args as [|arg1 r1] eqn: eq_args; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r2; try inject_rw Hoptm_sbinding eq_val'.
  destruct (is_sub_x arg1 arg2 fcmp idx instk_height sb evm_stack_opm) 
    as [y|] eqn: is_sub_arg1.
  + injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    unfold is_sub_x in is_sub_arg1.
    destruct (follow_in_smap arg1 idx sb) as [fsmv1|] eqn: Hfollow_arg1;
      try discriminate.
    destruct fsmv1 as [smv_arg1 idx' sb'].
    destruct (smv_arg1) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
    destruct label2; try discriminate.
    destruct args2 as [|yy r2]; try discriminate.
    destruct r2 as [|x r2']; try discriminate.
    destruct r2'; try discriminate.
    destruct (fcmp x arg2 idx sb idx sb instk_height evm_stack_opm) 
      eqn: fcmp_x_arg2; try discriminate.
    injection is_sub_arg1 as eq_yy.
    rewrite -> eq_yy in Hfollow_arg1.

    unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
    rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
    simpl in Heval_orig.
    destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb 
      evm_stack_opm) as [arg1v|] eqn: eval_arg1; try discriminate.
    destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb
      evm_stack_opm) as [arg2v|] eqn: eval_arg2; try discriminate.
    rewrite <- Heval_orig.
    
    unfold eval_sstack_val.
    rewrite <- eval_sstack_val'_freshvar.
    destruct maxidx as [|maxidx'] eqn: eq_maxidx; try discriminate.
    simpl in eval_arg1. rewrite -> Hfollow_arg1 in eval_arg1.
    simpl in eval_arg1.
    destruct (eval_sstack_val' maxidx' y stk mem strg exts idx' sb' 
      evm_stack_opm) as [yv|] eqn: eval_y; try discriminate.
    destruct (eval_sstack_val' maxidx' x stk mem strg exts idx' sb' 
      evm_stack_opm) as [xv|] eqn: eval_x; try discriminate.
    injection eval_arg1 as eq_arg1v.
    rewrite <- eq_arg1v.

    simpl in Hvalid.
    destruct Hvalid as [eq_maxidx' [Hvalid_arg1_arg2 Hvalid_sb]].
    unfold valid_stack_op_instr in Hvalid_arg1_arg2.
    simpl in Hvalid_arg1_arg2.
    destruct Hvalid_arg1_arg2 as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
    pose proof (follow_suffix sb arg1 idx (SymOp SUB [y; x]) idx' sb'
      Hfollow_arg1) as [prefix sb_prefix].
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_y.
    pose proof (eval_sstack_val'_extend_sb instk_height maxidx' stk mem strg
      exts idx sb sb' evm_stack_opm prefix Hvalid_sb sb_prefix y yv eval_y) 
      as eval_y_sb.
    rewrite -> eval'_maxidx_indep_eq with (m:=(S maxidx')) in eval_y_sb.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_y_sb.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_y_sb.
    rewrite -> eval_y_sb.

    pose proof (valid_follow_in_smap sb arg1 instk_height idx evm_stack_opm
      (SymOp SUB [y; x]) idx' sb' Hvalid_arg1 Hvalid_sb Hfollow_arg1)
      as [Hvalid_smv [Hvalid_sb' Himpl]].
    pose proof (not_basic_value_smv_symop SUB [y;x]) as Hnot_basic.
    apply Himpl in Hnot_basic as idx_gt_idx'.
    unfold valid_smap_value in Hvalid_smv.
    unfold valid_stack_op_instr in Hvalid_smv.
    simpl in Hvalid_smv.
    destruct Hvalid_smv as [_ [Hvalid_y [Hvalid_x _]]].
    pose proof (valid_sstack_value_gt instk_height idx' idx x Hvalid_x
      idx_gt_idx') as Hvalid_x_sb.
    symmetry in Hlen.
    
    pose proof (Hsafe_sstack_val_cmp x arg2 idx sb idx sb instk_height
      evm_stack_opm Hvalid_x_sb Hvalid_arg2 Hvalid_sb Hvalid_sb fcmp_x_arg2
      stk mem strg exts Hlen) as [xv' [eval_x' eval_arg2']].
    unfold eval_sstack_val in eval_x'.
    unfold eval_sstack_val in eval_arg2'.
    rewrite <- eq_maxidx' in eval_arg2'.
    rewrite -> eval_arg2 in eval_arg2'.
    injection eval_arg2' as eq_xv'.
    rewrite -> eq_xv'.
    
    rewrite <- eq_maxidx' in eval_x'.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_x.
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_x.
    apply eval_sstack_val'_extend_sb with (instk_height:=instk_height)(sb:=sb)
      (prefix:=prefix) in eval_x; try assumption.
    rewrite -> eval_x in eval_x'.
    injection eval_x' as eq_xv.
    rewrite <- eq_xv.
    
    simpl. rewrite -> wminus_wplus_undo. reflexivity.

  + destruct (is_sub_x arg2 arg1 fcmp idx instk_height sb evm_stack_opm) 
      as [y|] eqn: is_sub_arg2; try inject_rw Hoptm_sbinding eq_val'.
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    unfold is_sub_x in is_sub_arg2.
    destruct (follow_in_smap arg2 idx sb) as [fsmv2|] eqn: Hfollow_arg2;
      try discriminate.
    destruct fsmv2 as [smv_arg2 idx' sb'].
    destruct (smv_arg2) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
    destruct label2; try discriminate.
    destruct args2 as [|yy r2]; try discriminate.
    destruct r2 as [|x r2']; try discriminate.
    destruct r2'; try discriminate.
    destruct (fcmp x arg1 idx sb idx sb instk_height evm_stack_opm) 
      eqn: fcmp_x_arg1; try discriminate.
    injection is_sub_arg2 as eq_yy.
    rewrite -> eq_yy in Hfollow_arg2.

    unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
    rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
    simpl in Heval_orig.
    destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb 
      evm_stack_opm) as [arg1v|] eqn: eval_arg1; try discriminate.
    destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb
      evm_stack_opm) as [arg2v|] eqn: eval_arg2; try discriminate.
    rewrite <- Heval_orig.
    
    unfold eval_sstack_val.
    rewrite <- eval_sstack_val'_freshvar.
    destruct maxidx as [|maxidx'] eqn: eq_maxidx; try discriminate.
    simpl in eval_arg2. rewrite -> Hfollow_arg2 in eval_arg2.
    simpl in eval_arg2.
    destruct (eval_sstack_val' maxidx' y stk mem strg exts idx' sb' 
      evm_stack_opm) as [yv|] eqn: eval_y; try discriminate.
    destruct (eval_sstack_val' maxidx' x stk mem strg exts idx' sb' 
      evm_stack_opm) as [xv|] eqn: eval_x; try discriminate.
    injection eval_arg2 as eq_arg2v.
    rewrite <- eq_arg2v.

    simpl in Hvalid.
    destruct Hvalid as [eq_maxidx' [Hvalid_arg1_arg2 Hvalid_sb]].
    unfold valid_stack_op_instr in Hvalid_arg1_arg2.
    simpl in Hvalid_arg1_arg2.
    destruct Hvalid_arg1_arg2 as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
    pose proof (follow_suffix sb arg2 idx (SymOp SUB [y; x]) idx' sb'
      Hfollow_arg2) as [prefix sb_prefix].
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_y.
    pose proof (eval_sstack_val'_extend_sb instk_height maxidx' stk mem strg
      exts idx sb sb' evm_stack_opm prefix Hvalid_sb sb_prefix y yv eval_y) 
      as eval_y_sb.
    rewrite -> eval'_maxidx_indep_eq with (m:=(S maxidx')) in eval_y_sb.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_y_sb.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_y_sb.
    rewrite -> eval_y_sb.

    pose proof (valid_follow_in_smap sb arg2 instk_height idx evm_stack_opm
      (SymOp SUB [y; x]) idx' sb' Hvalid_arg2 Hvalid_sb Hfollow_arg2)
      as [Hvalid_smv [Hvalid_sb' Himpl]].
    pose proof (not_basic_value_smv_symop SUB [y;x]) as Hnot_basic.
    apply Himpl in Hnot_basic as idx_gt_idx'.
    unfold valid_smap_value in Hvalid_smv.
    unfold valid_stack_op_instr in Hvalid_smv.
    simpl in Hvalid_smv.
    destruct Hvalid_smv as [_ [Hvalid_y [Hvalid_x _]]].
    pose proof (valid_sstack_value_gt instk_height idx' idx x Hvalid_x
      idx_gt_idx') as Hvalid_x_sb.
    symmetry in Hlen.
    
    pose proof (Hsafe_sstack_val_cmp x arg1 idx sb idx sb instk_height
      evm_stack_opm Hvalid_x_sb Hvalid_arg1 Hvalid_sb Hvalid_sb fcmp_x_arg1
      stk mem strg exts Hlen) as [xv' [eval_x' eval_arg1']].
    unfold eval_sstack_val in eval_x'.
    unfold eval_sstack_val in eval_arg1'.
    rewrite <- eq_maxidx' in eval_arg1'.
    rewrite -> eval_arg1 in eval_arg1'.
    injection eval_arg1' as eq_xv'.
    rewrite -> eq_xv'.
    
    rewrite <- eq_maxidx' in eval_x'.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_x.
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_x.
    apply eval_sstack_val'_extend_sb with (instk_height:=instk_height)(sb:=sb)
      (prefix:=prefix) in eval_x; try assumption.
    rewrite -> eval_x in eval_x'.
    injection eval_x' as eq_xv.
    rewrite <- eq_xv.
    
    simpl. 
    rewrite -> wplus_comm. 
    rewrite -> wminus_wplus_undo. 
    reflexivity.
Qed.


End Opt_add_sub.

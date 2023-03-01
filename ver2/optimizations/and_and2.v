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


Module Opt_and_and2.

(* sv1 sv2 maxidx1 sb1 maxid2 sb2 instk_height ops -> bool *)
Definition sstack_val_cmp_t := sstack_val -> sstack_val -> nat -> sbindings -> nat -> sbindings -> nat -> stack_op_instr_map -> bool.

(* AND(AND(X,Y), X) = AND(X,Y)
   AND(AND(X,Y), Y) = AND(X,Y)
 *)
Definition optimize_and_and2_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp AND [arg1;arg2] => 
  match follow_in_smap arg1 maxid sb with
  | Some (FollowSmapVal (SymOp AND [arg11;arg12]) idx' sb') => 
      if fcmp arg11 arg2 idx' sb' maxid sb instk_height ops then 
        (SymOp AND [arg11;arg12], true)
      else if fcmp arg12 arg2 idx' sb' maxid sb instk_height ops then 
        (SymOp AND [arg2;arg11], true)
      else 
        (val, false)
  | _ => (val, false)
  end
| _ => (val, false)
end.


Lemma wand_x_x: forall (x: EVMWord),
wand x x = x.
Proof.
induction x as [|b n x' IH].
- reflexivity.
- unfold wand. simpl. fold wand.
  rewrite -> andb_diag.
  rewrite -> IH.
  reflexivity.
Qed.


Lemma wand_wand2_1: forall (x y: EVMWord),
wand (wand x y) x = wand x y.
Proof.
intros x y.
rewrite -> wand_comm.
rewrite -> wand_assoc.
rewrite -> wand_x_x.
reflexivity.
Qed.

Lemma wand_wand2_2: forall (x y: EVMWord),
wand (wand x y) y = wand x y.
Proof.
intros x y.
rewrite <- wand_assoc.
rewrite -> wand_x_x.
rewrite -> wand_comm.
reflexivity.
Qed.


Lemma optimize_and_and2_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_and_and2_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n ops fcmp sb val val' flag.
intros Hvalid_smapv_val Hvalid Hoptm_sbinding.
unfold optimize_and_and2_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try try inject_rw Hoptm_sbinding eq_val'.
destruct args as [|arg1 r1]; try inject_rw Hoptm_sbinding eq_val'.
destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
destruct r2; try inject_rw Hoptm_sbinding eq_val'.
destruct (follow_in_smap arg1 n sb) as [fsmv_arg1|] eqn: eq_follow_arg1;
  try inject_rw Hoptm_sbinding eq_val'.
destruct fsmv_arg1 as [smv_arg1 idx' sb'] eqn: eq_fsmv_arg1.
destruct smv_arg1 as [x1|x2|label2 args2|x4|x5|x6] eqn: eq_smv;
  try inject_rw Hoptm_sbinding eq_val'.
destruct label2; try inject_rw Hoptm_sbinding eq_val'.
destruct args2 as [|arg11 r12]; try inject_rw Hoptm_sbinding eq_val'.
destruct r12 as [|arg12 r22]; try inject_rw Hoptm_sbinding eq_val'.
destruct r22; try inject_rw Hoptm_sbinding eq_val'.

assert (Hvalid_smapv_val_copy := Hvalid_smapv_val).
simpl in Hvalid_smapv_val.
unfold valid_stack_op_instr in Hvalid_smapv_val.
destruct (ops AND) as [nargs f Hcomm Hctx_indep] eqn: eq_ops_and.
destruct Hvalid_smapv_val as [Hlen_nargs Hvalid_arg1_arg2].
simpl in Hvalid_arg1_arg2.
destruct Hvalid_arg1_arg2 as [Hvalid_arg1 [Hvalid_arg2]].

pose proof (valid_follow_in_smap sb arg1 instk_height n ops
      (SymOp AND [arg11; arg12]) idx' sb' Hvalid_arg1 Hvalid
      eq_follow_arg1) as Hvalid2.
destruct Hvalid2 as [Hvalid_smap [Hvalid_sb' Himpl]].
simpl in Hvalid_smap. unfold valid_stack_op_instr in Hvalid_smap.
rewrite -> eq_ops_and in Hvalid_smap.
destruct Hvalid_smap as [Hlen_nargs' Hvalid_arg11_arg12].
simpl in Hvalid_arg11_arg12.
destruct Hvalid_arg11_arg12 as [Hvalid_arg11 [Hvalid_arg12 _]].
pose proof (not_basic_value_smv_symop AND [arg11; arg12]) as eq_not_basic.
apply Himpl in eq_not_basic as n_gt_idx'.

destruct (fcmp arg11 arg2 idx' sb' n sb instk_height ops) 
  eqn: fcmp_arg1_arg11.
- injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'. 
  simpl. unfold valid_stack_op_instr. 
  rewrite -> eq_ops_and. split; try assumption. 
  simpl. split; try intuition.
  apply valid_sstack_value_gt with (n:=idx'); try assumption.
  apply valid_sstack_value_gt with (n:=idx'); try assumption.
   
- destruct (fcmp arg12 arg2 idx' sb' n sb instk_height ops) 
  eqn: fcmp_arg1_arg22; try inject_rw Hoptm_sbinding eq_val'.
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'. 
  simpl. unfold valid_stack_op_instr. 
  rewrite -> eq_ops_and. split; try assumption. 
  simpl. split; try intuition.
  apply valid_sstack_value_gt with (n:=idx'); try assumption.
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

Search eval_sstack_val'.

Lemma optimize_and_and1_sbinding_snd:
opt_sbinding_snd optimize_and_and2_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_and_and2_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_and_and2_sbinding_smapv_valid. 

- (* evaluation is preserved *) 
  intros stk mem strg ctx v Hlen Heval_orig.
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
    
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_arg11.
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_arg12.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_arg11.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_arg12.
    pose proof (eval_sstack_val'_extend_sb instk_height (S maxidx') stk
      mem strg ctx idx sb sb' evm_stack_opm prefix Hvalid_sb Hprefix_sb
      arg11 arg11v eval_arg11) as Heval_arg11_sb.
    pose proof (eval_sstack_val'_extend_sb instk_height (S maxidx') stk
      mem strg ctx idx sb sb' evm_stack_opm prefix Hvalid_sb Hprefix_sb
      arg12 arg12v eval_arg12) as Heval_arg12_sb.
    rewrite -> Heval_arg11_sb.
    rewrite -> Heval_arg12_sb. simpl.
    
    (* arg11v must be equal to arg2v *)
    (* TODO *)
    symmetry in Hlen.
    pose proof (Hsafe_sstack_val_cmp arg11 arg2 idx' sb' idx sb instk_height 
      evm_stack_opm). Hvalid_arg11 Hvalid_arg2 Hvalid_sb' Hvalid_sb
      eq_fcmp_arg11_arg2 stk mem strg ctx Hlen) as Hcmp_eval.
    destruct Hcmp_eval as [vv [eval_arg11_vv eval_arg2_vv]].
    
(*    
    apply eval_sstack_val'_preserved_when_depth_extended in eval_arg11.
    rewrite -> eval_arg11.
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_arg12.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_arg12.
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
    
    pose proof (eval_sstack_val'_extend_sb instk_height (S maxidx') stk
      mem strg ctx idx sb sb' evm_stack_opm prefix Hvalid_sb Hprefix_sb
      arg12 arg12v eval_arg12) as Heval_arg12_sb.
    rewrite -> Heval_arg12_sb. simpl.
    
    (* arg11v must be equal to arg2v *)
    (*TODO continue *)
    simpl in Hvalid_smapv_and. unfold valid_stack_op_instr in Hvalid_smapv_and.
    simpl in Hvalid_smapv_and.
    destruct Hvalid_smapv_and as [_ [valid_arg11 [valid_arg12 _]]].
    
    pose proof (not_basic_value_smv_symop AND [arg11;arg12]) as not_basic_and.
    apply Himpl in not_basic_and as idx_gt_idx'.
     
    symmetry in Hlen.
    pose proof (Hsafe_sstack_val_cmp arg11 arg2 idx' sb' idx sb instk_height 
      evm_stack_opm valid_arg11 Hvalid_arg2 Hvalid_sb' Hvalid_sb
      eq_fcmp_arg11_arg2 stk mem strg ctx Hlen) as Hcmp_eval.
    destruct Hcmp_eval as [vv [eval_arg11_vv eval_arg2_vv]].
    
    injection eq_idx as eq_idx.
    unfold eval_sstack_val in eval_arg11_vv.
    unfold eval_sstack_val in eval_arg2_vv.
    rewrite <- eq_idx in eval_arg2_vv. rewrite <- eq_idx in eval_arg11.
    rewrite -> eval_arg1 in eval_arg1_vv.
    pose proof (not_basic_value_smv_symop AND [arg21;arg22]) as not_basic_and.
    apply Himpl in not_basic_and.
    rewrite -> eq_idx in eval_arg21.
    assert (S idx' <= idx) as Hleq.
    * intuition.
    * pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S idx') 
        idx idx' sb' arg21 vv stk mem strg ctx evm_stack_opm Hleq
        eval_arg21_vv) as eval_arg21'.
      rewrite -> eval_arg21 in eval_arg21'.
      rewrite <- eval_arg1_vv in eval_arg21'.
      injection eval_arg21' as eq_arg21v_arg1v.
      rewrite -> eq_arg21v_arg1v.
      rewrite -> wand_wand1_1.
      reflexivity.

  + destruct (fcmp arg1 arg22 idx sb idx' sb' instk_height evm_stack_opm)
      eqn: eq_fcmp_arg1_arg22; try inject_rw Hoptm_sbinding eq_val'.
    rewrite <- Heval_orig.
    simpl.
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    unfold eval_sstack_val.
    rewrite -> eval_sstack_val'_one_step. 
    rewrite -> follow_in_smap_head_op.
    rewrite -> evm_stack_opm_AND. 
    rewrite -> lenght2.
    unfold map_option.
    rewrite -> eval_arg1.
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_arg21.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_arg21.
    pose proof (follow_suffix sb arg2 idx (SymOp AND [arg21; arg22]) idx' sb'
      eq_follow_arg2) as Hprefix_sb.
    destruct Hprefix_sb as [prefix Hprefix_sb].
    simpl in Hvalid.
    destruct Hvalid as [eq_idx [Hvalid_stack_op Hvalid_sb]].
    pose proof (eval_sstack_val'_extend_sb instk_height (S maxidx') stk
      mem strg ctx idx sb sb' evm_stack_opm prefix Hvalid_sb Hprefix_sb
      arg21 arg21v eval_arg21) as Heval_arg21_sb.
    rewrite -> Heval_arg21_sb. simpl.
    
    unfold valid_stack_op_instr in Hvalid_stack_op. simpl in Hvalid_stack_op.
    destruct Hvalid_stack_op as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
    pose proof (valid_follow_in_smap sb arg2 instk_height idx evm_stack_opm
      (SymOp AND [arg21; arg22]) idx' sb' Hvalid_arg2 Hvalid_sb
      eq_follow_arg2) as Hvalid2.
    destruct Hvalid2 as [Hvalid_smapv_and [Hvalid_sb' Himpl]].
    simpl in Hvalid_smapv_and. unfold valid_stack_op_instr in Hvalid_smapv_and.
    simpl in Hvalid_smapv_and.
    destruct Hvalid_smapv_and as [_ [valid_arg21 [valid_arg22 _]]].

    symmetry in Hlen.
    pose proof (Hsafe_sstack_val_cmp arg1 arg22 idx sb idx' sb' instk_height 
      evm_stack_opm Hvalid_arg1 valid_arg22 Hvalid_sb Hvalid_sb'
      eq_fcmp_arg1_arg22 stk mem strg ctx Hlen) as Hcmp_eval.
    destruct Hcmp_eval as [vv [eval_arg1_vv eval_arg22_vv]].
    
    injection eq_idx as eq_idx.
    unfold eval_sstack_val in eval_arg1_vv.
    unfold eval_sstack_val in eval_arg22_vv.
    rewrite <- eq_idx in eval_arg1_vv. rewrite <- eq_idx in eval_arg1.
    rewrite -> eval_arg1 in eval_arg1_vv.
    pose proof (not_basic_value_smv_symop AND [arg21;arg22]) as not_basic_and.
    apply Himpl in not_basic_and.
    rewrite -> eq_idx in eval_arg22.
    assert (S idx' <= idx) as Hleq.
    * intuition.
    * pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S idx') 
        idx idx' sb' arg22 vv stk mem strg ctx evm_stack_opm Hleq
        eval_arg22_vv) as eval_arg22'.
      rewrite -> eval_arg22 in eval_arg22'.
      rewrite <- eval_arg1_vv in eval_arg22'.
      injection eval_arg22' as eq_arg22v_arg1v.
      rewrite -> eq_arg22v_arg1v.
      rewrite <- wand_wand1_2.
      reflexivity.*)
Qed.

End Opt_and_and2.

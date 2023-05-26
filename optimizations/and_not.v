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

Require Import Coq.Program.Equality.


Module Opt_and_not.


(* 
  AND(X, NOT(X)) = 0
  AND(NOT(X), X) = 0
*)
Definition is_not (x: sstack_val) (sv: sstack_val) (fcmp: sstack_val_cmp_t) 
  (maxid instk_height: nat) (sb: sbindings) (ops: stack_op_instr_map) :=
match follow_in_smap sv maxid sb with 
| Some (FollowSmapVal (SymOp NOT [arg]) idx' sb') => 
      fcmp x arg maxid sb idx' sb' instk_height ops
| _ => false
end.


 
Definition optimize_and_not_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp AND [arg1;arg2] =>
  if is_not arg1 arg2 fcmp maxid instk_height sb ops then
    (SymBasicVal (Val WZero), true)
  else if is_not arg2 arg1 fcmp maxid instk_height sb ops then
    (SymBasicVal (Val WZero), true)
  else 
    (val, false)
| _ => (val, false)
end.




(* 
  AND(X, NOT(X)) = 0
  AND(NOT(X), X) = 0
 *)
Lemma wand_not_1: forall (size: nat) (x: word size),
wand x (wnot x) = wzero size.
Proof.
dependent induction x.
- intuition.
- unfold wand. unfold bitwp. unfold wnot. simpl.
  fold wnot. fold bitwp. fold wand.
  rewrite -> andb_negb_r.
  unfold wzero. unfold natToWord. simpl. fold natToWord. fold (wzero n).
  rewrite -> IHx.
  reflexivity.
Qed.

Lemma wand_not_2: forall (size: nat) (x: word size),
wand (wnot x) x = wzero size.
Proof.
intros size x.
rewrite -> wand_comm.
apply wand_not_1.
Qed.


Lemma optimize_and_not_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_and_not_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros Hvalid_smapv_val Hvalid Hoptm_sbinding.
unfold optimize_and_not_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try try inject_rw Hoptm_sbinding eq_val'.
destruct args as [|arg1 r1]; try inject_rw Hoptm_sbinding eq_val'.
destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
destruct r2 as [|arg3 r3]; try inject_rw Hoptm_sbinding eq_val'.
destruct (is_not arg1 arg2 fcmp n instk_height sb evm_stack_opm) 
  eqn: eq_is_not.
- unfold is_not in eq_is_not.
  destruct (follow_in_smap arg2 n sb) as [fsmv_arg2|] eqn: eq_follow_arg2;
    try discriminate.
  destruct fsmv_arg2 as [smv_arg2 idx' sb'] eqn: eq_fsmv_arg2.
  destruct smv_arg2 as [x1|x2|label2 args2|x4|x5|x6] eqn: eq_smv;
    try discriminate.
  destruct label2 eqn: eq_label2; try inject_rw Hoptm_sbinding eq_val';
    try discriminate.
  destruct args2 as [|arg21 r21]; try discriminate.
  destruct r21; try discriminate.
  destruct (fcmp arg1 arg21 n sb idx' sb' instk_height evm_stack_opm)
    eqn: eq_fcmp_arg1_arg21; try discriminate.

  (* arg1 ~ arg21 *)
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
  unfold valid_smap_value. unfold valid_sstack_value.
  intuition.
  
- destruct (is_not arg2 arg1 fcmp n instk_height sb evm_stack_opm) 
    eqn: eq_is_not'; try inject_rw Hoptm_sbinding eq_val'.
  unfold is_not in eq_is_not'.
  destruct (follow_in_smap arg1 n sb) as [fsmv_arg1|] eqn: eq_follow_arg1;
    try discriminate.
  destruct fsmv_arg1 as [smv_arg1 idx' sb'] eqn: eq_fsmv_arg1.
  destruct smv_arg1 as [x1|x2|label2 args2|x4|x5|x6] eqn: eq_smv;
    try discriminate.
  destruct label2 eqn: eq_label2; try inject_rw Hoptm_sbinding eq_val';
    try discriminate.
  destruct args2 as [|arg11 r11]; try discriminate.
  destruct r11; try discriminate.
  destruct (fcmp arg2 arg11 n sb idx' sb' instk_height evm_stack_opm)
    eqn: eq_fcmp_arg2_arg11; try discriminate.
  
  (* arg2 ~ arg11 *)
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
  unfold valid_smap_value. unfold valid_sstack_value.
  intuition.
Qed.


Lemma optimize_and_not_sbinding_snd:
opt_sbinding_snd optimize_and_not_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_and_not_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_and_not_sbinding_smapv_valid. 

- (* evaluation is preserved *) 
  intros stk mem strg ctx v Hlen Heval_orig.
  unfold optimize_and_not_sbinding in Hoptm_sbinding.
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymOp label args *)
  destruct label eqn: eq_label; try inject_rw Hoptm_sbinding eq_val'.
  destruct args as [|arg1 r1] eqn: eq_args; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r2; try inject_rw Hoptm_sbinding eq_val'.
  destruct (is_not arg1 arg2 fcmp idx instk_height sb evm_stack_opm) 
    eqn: eq_is_not.
    
  + injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    
    unfold is_not in eq_is_not.
    destruct (follow_in_smap arg2 idx sb) as [fsmv|] eqn: eq_follow_arg2;
      try discriminate.
    destruct fsmv as [smv idx' sb'].
    destruct smv as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
    destruct label2 eqn: eq_label2; try discriminate.
    destruct args2 as [|arg21 r21]; try discriminate.
    destruct r21; try discriminate.
    destruct (fcmp arg1 arg21 idx sb idx' sb' instk_height evm_stack_opm)
      eqn: eq_fcmp_arg1_arg21; try discriminate.
      
    (* arg1 ~ arg21 *)
    unfold eval_sstack_val in Heval_orig.
    unfold eval_sstack_val.
    rewrite <- eval_sstack_val'_freshvar.
    
    rewrite -> eval_sstack_val'_const.
    simpl in Heval_orig.
    rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
    simpl in Heval_orig.
    destruct (eval_sstack_val' maxidx arg1 stk mem strg ctx idx sb 
      evm_stack_opm) as [arg1v|] eqn: eq_eval_arg1; try discriminate.
    destruct (eval_sstack_val' maxidx arg2 stk mem strg ctx idx sb 
      evm_stack_opm) as [arg2v|] eqn: eq_eval_arg2; try discriminate.
    rewrite <- Heval_orig.
     
    (* Every expression is valid *)
      simpl in Hvalid.
      destruct Hvalid as [eq_maxidx [Hvalid_and Hvalid_sb]].
      unfold valid_stack_op_instr in Hvalid_and.
      simpl in Hvalid_and.
      destruct Hvalid_and as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
      pose proof (valid_follow_in_smap sb arg2 instk_height idx 
        evm_stack_opm (SymOp NOT [arg21]) idx' sb' Hvalid_arg2
        Hvalid_sb eq_follow_arg2) as [Hvalid_or [Hvalid_sb' Himpl]]. 
      pose proof (not_basic_value_smv_symop NOT [arg21]) as eq_not_basic.
       apply Himpl in eq_not_basic as idx_gt_idx'.
      unfold valid_stack_op_instr in Hvalid_or.
      unfold valid_smap_value in Hvalid_or.
      unfold valid_stack_op_instr in Hvalid_or.
      simpl in Hvalid_or.
      destruct Hvalid_or as [_ [Hvalid_arg21 _]].

      rewrite -> eq_maxidx in eq_eval_arg2.
      simpl in eq_eval_arg2.
      rewrite -> eq_follow_arg2 in eq_eval_arg2.
      simpl in eq_eval_arg2.
      destruct (eval_sstack_val' idx arg21 stk mem strg ctx idx' sb' 
        evm_stack_opm) as [arg21v|] eqn: eq_eval_arg21; try discriminate.
      injection eq_eval_arg2 as eq_arg2v.
      rewrite <- eq_arg2v.
      unfold evm_and.

      (* arg1v and arg21v are the same *)
      symmetry in Hlen.
      pose proof (Hsafe_sstack_val_cmp arg1 arg21 idx sb idx' sb' instk_height 
        evm_stack_opm Hvalid_arg1 Hvalid_arg21 Hvalid_sb Hvalid_sb'
        eq_fcmp_arg1_arg21 stk mem strg ctx Hlen) as [vv [eval_arg1 
        eval_arg21]].
      unfold eval_sstack_val in eval_arg1.
      rewrite <- eq_maxidx in eval_arg1.
      rewrite -> eq_eval_arg1 in eval_arg1.
      unfold eval_sstack_val in eval_arg21.
      apply eval_sstack_val'_preserved_when_depth_extended in 
        eq_eval_arg21.
      apply Gt.gt_n_S in idx_gt_idx' as Sidx_gt_Sidx'.
      pose proof (eval_sstack_val'_preserved_when_depth_extended_lt (S idx')
        (S idx) idx' sb' arg21 vv stk mem strg ctx evm_stack_opm Sidx_gt_Sidx'
        eval_arg21) as eval_arg21_alt.
      rewrite -> eval_arg21_alt in eq_eval_arg21.
      rewrite <- eval_arg1 in eq_eval_arg21.
      injection eq_eval_arg21 as eq_arg1v_arg21v.
      rewrite -> eq_arg1v_arg21v.

      rewrite -> wand_not_1.
      reflexivity.
      
+ destruct (is_not arg2 arg1 fcmp idx instk_height sb evm_stack_opm) 
    eqn: eq_is_not'; try inject_rw Hoptm_sbinding eq_val'.
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
    
  unfold is_not in eq_is_not'.
  destruct (follow_in_smap arg1 idx sb) as [fsmv|] eqn: eq_follow_arg1;
    try discriminate.
  destruct fsmv as [smv idx' sb'].
  destruct smv as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
  destruct label2 eqn: eq_label2; try discriminate.
  destruct args2 as [|arg11 r11]; try discriminate.
  destruct r11; try discriminate.
  destruct (fcmp arg2 arg11 idx sb idx' sb' instk_height evm_stack_opm)
      eqn: eq_fcmp_arg2_arg11; try discriminate.
      
  (* arg2 ~ arg11 *)
  unfold eval_sstack_val in Heval_orig.
  unfold eval_sstack_val.
  rewrite <- eval_sstack_val'_freshvar.
    
  rewrite -> eval_sstack_val'_const.
  simpl in Heval_orig.
  rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
  simpl in Heval_orig.
  destruct (eval_sstack_val' maxidx arg1 stk mem strg ctx idx sb 
    evm_stack_opm) as [arg1v|] eqn: eq_eval_arg1; try discriminate.
  destruct (eval_sstack_val' maxidx arg2 stk mem strg ctx idx sb 
    evm_stack_opm) as [arg2v|] eqn: eq_eval_arg2; try discriminate.
  rewrite <- Heval_orig.
     
  (* Every expression is valid *)
  simpl in Hvalid.
  destruct Hvalid as [eq_maxidx [Hvalid_and Hvalid_sb]].
  unfold valid_stack_op_instr in Hvalid_and.
  simpl in Hvalid_and.
  destruct Hvalid_and as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
  pose proof (valid_follow_in_smap sb arg1 instk_height idx 
    evm_stack_opm (SymOp NOT [arg11]) idx' sb' Hvalid_arg1
    Hvalid_sb eq_follow_arg1) as [Hvalid_or [Hvalid_sb' Himpl]]. 
  pose proof (not_basic_value_smv_symop NOT [arg11]) as eq_not_basic.
  apply Himpl in eq_not_basic as idx_gt_idx'.
  unfold valid_stack_op_instr in Hvalid_or.
  unfold valid_smap_value in Hvalid_or.
  unfold valid_stack_op_instr in Hvalid_or.
  simpl in Hvalid_or.
  destruct Hvalid_or as [_ [Hvalid_arg11 _]].

  rewrite -> eq_maxidx in eq_eval_arg1.
  simpl in eq_eval_arg1.
  rewrite -> eq_follow_arg1 in eq_eval_arg1.
  simpl in eq_eval_arg1.
  destruct (eval_sstack_val' idx arg11 stk mem strg ctx idx' sb' 
    evm_stack_opm) as [arg11v|] eqn: eq_eval_arg11; try discriminate.
  injection eq_eval_arg1 as eq_arg1v.
  rewrite <- eq_arg1v.
  unfold evm_and.

  (* arg2v and arg11v are the same *)
  symmetry in Hlen.
  pose proof (Hsafe_sstack_val_cmp arg2 arg11 idx sb idx' sb' instk_height 
    evm_stack_opm Hvalid_arg2 Hvalid_arg11 Hvalid_sb Hvalid_sb'
    eq_fcmp_arg2_arg11 stk mem strg ctx Hlen) as [vv [eval_arg2 
    eval_arg11]].
  unfold eval_sstack_val in eval_arg2.
  rewrite <- eq_maxidx in eval_arg2.
  rewrite -> eq_eval_arg2 in eval_arg2.
  unfold eval_sstack_val in eval_arg11.
  apply eval_sstack_val'_preserved_when_depth_extended in 
    eq_eval_arg11.
  apply Gt.gt_n_S in idx_gt_idx' as Sidx_gt_Sidx'.
  pose proof (eval_sstack_val'_preserved_when_depth_extended_lt (S idx')
    (S idx) idx' sb' arg11 vv stk mem strg ctx evm_stack_opm Sidx_gt_Sidx'
    eval_arg11) as eval_arg11_alt.
  rewrite -> eval_arg11_alt in eq_eval_arg11.
  rewrite <- eval_arg2 in eq_eval_arg11.
  injection eq_eval_arg11 as eq_arg2v_arg11v.
  rewrite -> eq_arg2v_arg11v.
 
  rewrite -> wand_not_2.
  reflexivity.
Qed.

End Opt_and_not.

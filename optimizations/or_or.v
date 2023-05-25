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


Module Opt_or_or.

(* 
  OR(X, OR(X, Y)) = OR(X,Y)
  OR(X, OR(Y, X)) = OR(X,Y)
  OR(OR(X, Y), X) = OR(X,Y)
  OR(OR(Y, X), X) = OR(X,Y)
 *)
 
Definition is_or (x: sstack_val) (sv: sstack_val) (fcmp: sstack_val_cmp_t) 
  (maxid instk_height: nat) (sb: sbindings) (ops: stack_op_instr_map) :=
match follow_in_smap sv maxid sb with 
| Some (FollowSmapVal (SymOp OR [arg1; arg2]) idx' sb') => 
      if fcmp x arg1 maxid sb idx' sb' instk_height ops then 
        Some arg2
      else if fcmp x arg2 maxid sb idx' sb' instk_height ops then 
        Some arg1
      else None
| _ => None
end.


 
Definition optimize_or_or_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp OR [arg1;arg2] =>
  match is_or arg1 arg2 fcmp maxid instk_height sb ops with
  | Some y => (SymOp OR [arg1;y], true)
  | None => 
    match is_or arg2 arg1 fcmp maxid instk_height sb ops with
    | Some y => (SymOp OR [arg2;y], true)
    | None => (val, false)
    end
  end
| _ => (val, false)
end.


Lemma wor_x_x: forall (x: EVMWord),
wor x x = x.
Proof.
induction x as [|b n x' IH].
- reflexivity.
- unfold wor. simpl. fold wor.
  rewrite -> orb_diag.
  rewrite -> IH.
  reflexivity.
Qed.

Lemma wor_wor_1: forall (x y: EVMWord),
wor x (wor x y) = wor x y.
Proof.
intros x y.
rewrite -> wor_assoc.
rewrite -> wor_x_x.
reflexivity.
Qed.

Lemma wor_wor_2: forall (x y: EVMWord),
wor x (wor y x) = wor x y.
Proof.
intros x y.
rewrite -> (wor_comm y x).
apply wor_wor_1.
Qed.

Lemma wor_wor_3: forall (x y: EVMWord),
wor (wor x y) x = wor x y.
Proof.
intros x y.
rewrite -> (wor_comm x y).
rewrite <- wor_assoc.
rewrite -> wor_x_x.
rewrite -> wor_comm.
reflexivity.
Qed.

Lemma wor_wor_4: forall (x y: EVMWord),
wor (wor y x) x = wor x y.
Proof.
intros x y.
rewrite -> (wor_comm y x).
apply wor_wor_3.
Qed.


Lemma optimize_or_or_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_or_or_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros Hvalid_smapv_val Hvalid Hoptm_sbinding.
unfold optimize_or_or_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try try inject_rw Hoptm_sbinding eq_val'.
destruct args as [|arg1 r1]; try inject_rw Hoptm_sbinding eq_val'.
destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
destruct r2 as [|arg3 r3]; try inject_rw Hoptm_sbinding eq_val'.
destruct (is_or arg1 arg2 fcmp n instk_height sb evm_stack_opm) 
  as [y|] eqn: eq_is_or.
- unfold is_or in eq_is_or.
  destruct (follow_in_smap arg2 n sb) as [fsmv_arg2|] eqn: eq_follow_arg2;
    try discriminate.
  destruct fsmv_arg2 as [smv_arg2 idx' sb'] eqn: eq_fsmv_arg2.
  destruct smv_arg2 as [x1|x2|label2 args2|x4|x5|x6] eqn: eq_smv;
    try inject_rw Hoptm_sbinding eq_val'; try discriminate.
  destruct label2 eqn: eq_label2; try inject_rw Hoptm_sbinding eq_val';
    try discriminate.
  destruct args2 as [|arg21 r21]; try discriminate.
  destruct r21 as [|arg22 r22]; try discriminate.
  destruct r22; try discriminate.
  destruct (fcmp arg1 arg21 n sb idx' sb' instk_height evm_stack_opm)
    eqn: eq_fcmp_arg1_arg21.
    
  + (* arg1 ~ arg21 *)
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    simpl in Hvalid_smapv_val.
    unfold valid_stack_op_instr in Hvalid_smapv_val.
    simpl in Hvalid_smapv_val.
    destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
    
    pose proof (valid_follow_in_smap sb arg2 instk_height n evm_stack_opm
      (SymOp OR [arg21; arg22]) idx' sb' Hvalid_arg2 Hvalid
      eq_follow_arg2) as Hvalid2.
    destruct Hvalid2 as [Hvalid_smap [Hvalid_sb' Himpl]].
    simpl in Hvalid_smap. unfold valid_stack_op_instr in Hvalid_smap.
    simpl in Hvalid_smap.
    destruct Hvalid_smap as [_ [_ [Hvalid_arg22 _]]].
    pose proof (not_basic_value_smv_symop OR [arg21; arg22]) as eq_not_basic.
    apply Himpl in eq_not_basic as n_gt_idx'.
    
    injection eq_is_or as eq_y.
    rewrite <- eq_y.
    apply valid_sstack_value_gt with (m:=n) in Hvalid_arg22; try assumption.
    simpl. unfold valid_stack_op_instr. simpl. intuition.
  + destruct (fcmp arg1 arg22 n sb idx' sb' instk_height evm_stack_opm)
      eqn: eq_fcmp_arg1_arg22; try discriminate.
    * (* arg1 ~ arg22 *)
      injection Hoptm_sbinding as eq_val' _.
      rewrite <- eq_val'.
      simpl in Hvalid_smapv_val.
      unfold valid_stack_op_instr in Hvalid_smapv_val.
      simpl in Hvalid_smapv_val.
      destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
      
      pose proof (valid_follow_in_smap sb arg2 instk_height n evm_stack_opm
        (SymOp OR [arg21; arg22]) idx' sb' Hvalid_arg2 Hvalid
        eq_follow_arg2) as Hvalid2.
      destruct Hvalid2 as [Hvalid_smap [Hvalid_sb' Himpl]].
      simpl in Hvalid_smap. unfold valid_stack_op_instr in Hvalid_smap.
      simpl in Hvalid_smap.
      destruct Hvalid_smap as [_ [Hvalid_arg21 _]].
      pose proof (not_basic_value_smv_symop OR [arg21; arg22]) as eq_not_basic.
      apply Himpl in eq_not_basic as n_gt_idx'.
      
      injection eq_is_or as eq_y.
      rewrite <- eq_y.
      apply valid_sstack_value_gt with (m:=n) in Hvalid_arg21; try assumption.
      simpl. unfold valid_stack_op_instr. simpl. intuition.
- destruct (is_or arg2 arg1 fcmp n instk_height sb evm_stack_opm) 
    as [y|] eqn: eq_is_or'; try inject_rw Hoptm_sbinding eq_val'.
  unfold is_or in eq_is_or'.
  destruct (follow_in_smap arg1 n sb) as [fsmv_arg1|] eqn: eq_follow_arg1;
    try discriminate.
  destruct fsmv_arg1 as [smv_arg1 idx' sb'] eqn: eq_fsmv_arg1.
  destruct smv_arg1 as [x1|x2|label2 args2|x4|x5|x6] eqn: eq_smv;
    try discriminate.
  destruct label2 eqn: eq_label2; try inject_rw Hoptm_sbinding eq_val';
    try discriminate.
  destruct args2 as [|arg11 r11]; try discriminate.
  destruct r11 as [|arg12 r12]; try discriminate.
  destruct r12; try discriminate.
  destruct (fcmp arg2 arg11 n sb idx' sb' instk_height evm_stack_opm)
    eqn: eq_fcmp_arg2_arg11.
    
  + (* arg2 ~ arg11 *)
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    simpl in Hvalid_smapv_val.
    unfold valid_stack_op_instr in Hvalid_smapv_val.
    simpl in Hvalid_smapv_val.
    destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
    
    pose proof (valid_follow_in_smap sb arg1 instk_height n evm_stack_opm
      (SymOp OR [arg11; arg12]) idx' sb' Hvalid_arg1 Hvalid
      eq_follow_arg1) as Hvalid1.
    destruct Hvalid1 as [Hvalid_smap [Hvalid_sb' Himpl]].
    simpl in Hvalid_smap. unfold valid_stack_op_instr in Hvalid_smap.
    simpl in Hvalid_smap.
    destruct Hvalid_smap as [_ [_ [Hvalid_arg12 _]]].
    pose proof (not_basic_value_smv_symop OR [arg11; arg12]) as eq_not_basic.
    apply Himpl in eq_not_basic as n_gt_idx'.
    
    injection eq_is_or' as eq_y.
    rewrite <- eq_y.
    apply valid_sstack_value_gt with (m:=n) in Hvalid_arg12; try assumption.
    simpl. unfold valid_stack_op_instr. simpl. intuition.
  + destruct (fcmp arg2 arg12 n sb idx' sb' instk_height evm_stack_opm)
        eqn: eq_fcmp_arg2_arg12; try discriminate.
    (* arg1 ~ arg22 *)
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    simpl in Hvalid_smapv_val.
    unfold valid_stack_op_instr in Hvalid_smapv_val.
    simpl in Hvalid_smapv_val.
    destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
        
    pose proof (valid_follow_in_smap sb arg1 instk_height n evm_stack_opm
      (SymOp OR [arg11; arg12]) idx' sb' Hvalid_arg1 Hvalid
      eq_follow_arg1) as Hvalid1.
    destruct Hvalid1 as [Hvalid_smap [Hvalid_sb' Himpl]].
    simpl in Hvalid_smap. unfold valid_stack_op_instr in Hvalid_smap.
    simpl in Hvalid_smap.
    destruct Hvalid_smap as [_ [Hvalid_arg11 _]].
    pose proof (not_basic_value_smv_symop OR [arg11; arg12]) as eq_not_basic.
    apply Himpl in eq_not_basic as n_gt_idx'.
    
    injection eq_is_or' as eq_y.
    rewrite <- eq_y.
    apply valid_sstack_value_gt with (m:=n) in Hvalid_arg11; try assumption.
    simpl. unfold valid_stack_op_instr. simpl. intuition.
Qed.


Lemma evm_stack_opm_OR:
evm_stack_opm OR = OpImp 2 evm_or (Some or_comm) (Some or_ctx_ind).
Proof.
reflexivity.
Qed.

Lemma lenght2: forall {T: Type} (x y: T), (length [x; y] =? 2) = true.
Proof.
intros T x y.
reflexivity.
Qed.


Lemma optimize_or_or_sbinding_snd:
opt_sbinding_snd optimize_or_or_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_or_or_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_or_or_sbinding_smapv_valid. 

- (* evaluation is preserved *) 
  intros stk mem strg ctx v Hlen Heval_orig.
  unfold optimize_or_or_sbinding in Hoptm_sbinding.
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymOp label args *)
  destruct label eqn: eq_label; try inject_rw Hoptm_sbinding eq_val'.
  destruct args as [|arg1 r1] eqn: eq_args; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r2 as [|arg3 r3]; try inject_rw Hoptm_sbinding eq_val'.
  destruct (is_or arg1 arg2 fcmp idx instk_height sb evm_stack_opm) 
    as [y|] eqn: eq_is_or.
  + injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    
    unfold is_or in eq_is_or.
    destruct (follow_in_smap arg2 idx sb) as [fsmv|] eqn: eq_follow_arg2;
      try discriminate.
    destruct fsmv as [smv idx' sb'].
    destruct smv as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
    destruct label2 eqn: eq_label2; try discriminate.
    destruct args2 as [|arg21 r21]; try discriminate.
    destruct r21 as [|arg22 r22]; try discriminate.
    destruct r22; try discriminate.
    
    destruct (fcmp arg1 arg21 idx sb idx' sb' instk_height evm_stack_opm)
      eqn: eq_fcmp_arg1_arg21.
    * (* arg1 ~ arg21 *)
      
      unfold eval_sstack_val in Heval_orig.
      unfold eval_sstack_val.
    
      injection eq_is_or as eq_y.
      rewrite <- eq_y.
      
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
      destruct Hvalid as [eq_maxidx [Hvalid_or Hvalid_sb]].
      unfold valid_stack_op_instr in Hvalid_or.
      simpl in Hvalid_or.
      destruct Hvalid_or as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
      pose proof (valid_follow_in_smap sb arg2 instk_height idx 
        evm_stack_opm (SymOp OR [arg21; arg22]) idx' sb' Hvalid_arg2
        Hvalid_sb eq_follow_arg2) as [Hvalid_or [Hvalid_sb' Himpl]]. 
      pose proof (not_basic_value_smv_symop OR [arg21; arg22]) as eq_not_basic.
       apply Himpl in eq_not_basic as idx_gt_idx'.
      unfold valid_stack_op_instr in Hvalid_or.
      unfold valid_smap_value in Hvalid_or.
      unfold valid_stack_op_instr in Hvalid_or.
      simpl in Hvalid_or.
      destruct Hvalid_or as [_ [Hvalid_arg21 [Hvalid_arg22 _]]].

      rewrite -> eq_maxidx in eq_eval_arg2.
      simpl in eq_eval_arg2.
      rewrite -> eq_follow_arg2 in eq_eval_arg2.
      simpl in eq_eval_arg2.
      destruct (eval_sstack_val' idx arg21 stk mem strg ctx idx' sb' 
        evm_stack_opm) as [arg21v|] eqn: eq_eval_arg21; try discriminate.
      destruct (eval_sstack_val' idx arg22 stk mem strg ctx idx' sb' 
        evm_stack_opm) as [arg22v|] eqn: eq_eval_arg22; try discriminate.
      injection eq_eval_arg2 as eq_arg2v.
      rewrite <- eq_arg2v.
      unfold evm_or.

      (* arg1v or arg21v are the same *)
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
      
      simpl. rewrite -> PeanoNat.Nat.eqb_refl. simpl.
      rewrite -> eq_eval_arg1.
      rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eq_eval_arg22.
      apply follow_suffix in eq_follow_arg2 as [prefix eq_prefix].
      pose proof (eval_sstack_val'_extend_sb instk_height idx stk mem strg
        ctx idx sb sb' evm_stack_opm prefix Hvalid_sb eq_prefix arg22 arg22v
        eq_eval_arg22) as eval_arg22_alt.
      apply eval_sstack_val'_preserved_when_depth_extended in eval_arg22_alt.
      rewrite -> eq_maxidx.
      rewrite -> eval_arg22_alt. simpl.
      
      rewrite <- eq_arg1v_arg21v.
      rewrite -> wor_wor_1.
      reflexivity.

    * destruct (fcmp arg1 arg22 idx sb idx' sb' instk_height evm_stack_opm)
        eqn: eq_fcmp_arg1_arg22; try discriminate.
      (* arg1 ~ arg22 *)
      unfold eval_sstack_val in Heval_orig.
      unfold eval_sstack_val.
    
      injection eq_is_or as eq_y.
      rewrite <- eq_y.
      
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
      destruct Hvalid as [eq_maxidx [Hvalid_or Hvalid_sb]].
      unfold valid_stack_op_instr in Hvalid_or.
      simpl in Hvalid_or.
      destruct Hvalid_or as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
      pose proof (valid_follow_in_smap sb arg2 instk_height idx 
        evm_stack_opm (SymOp OR [arg21; arg22]) idx' sb' Hvalid_arg2
        Hvalid_sb eq_follow_arg2) as [Hvalid_or [Hvalid_sb' Himpl]]. 
      pose proof (not_basic_value_smv_symop OR [arg21; arg22]) as eq_not_basic.
       apply Himpl in eq_not_basic as idx_gt_idx'.
      unfold valid_stack_op_instr in Hvalid_or.
      unfold valid_smap_value in Hvalid_or.
      unfold valid_stack_op_instr in Hvalid_or.
      simpl in Hvalid_or.
      destruct Hvalid_or as [_ [Hvalid_arg21 [Hvalid_arg22 _]]].

      rewrite -> eq_maxidx in eq_eval_arg2.
      simpl in eq_eval_arg2.
      rewrite -> eq_follow_arg2 in eq_eval_arg2.
      simpl in eq_eval_arg2.
      destruct (eval_sstack_val' idx arg21 stk mem strg ctx idx' sb' 
        evm_stack_opm) as [arg21v|] eqn: eq_eval_arg21; try discriminate.
      destruct (eval_sstack_val' idx arg22 stk mem strg ctx idx' sb' 
        evm_stack_opm) as [arg22v|] eqn: eq_eval_arg22; try discriminate.
      injection eq_eval_arg2 as eq_arg2v.
      rewrite <- eq_arg2v.
      unfold evm_or.

      (* arg1v or arg22v are the same *)
      symmetry in Hlen.
      pose proof (Hsafe_sstack_val_cmp arg1 arg22 idx sb idx' sb' instk_height 
        evm_stack_opm Hvalid_arg1 Hvalid_arg22 Hvalid_sb Hvalid_sb'
        eq_fcmp_arg1_arg22 stk mem strg ctx Hlen) as [vv [eval_arg1 
        eval_arg22]].
      unfold eval_sstack_val in eval_arg1.
      rewrite <- eq_maxidx in eval_arg1.
      rewrite -> eq_eval_arg1 in eval_arg1.
      unfold eval_sstack_val in eval_arg22.
      apply eval_sstack_val'_preserved_when_depth_extended in 
        eq_eval_arg22.
      apply Gt.gt_n_S in idx_gt_idx' as Sidx_gt_Sidx'.
      pose proof (eval_sstack_val'_preserved_when_depth_extended_lt (S idx')
        (S idx) idx' sb' arg22 vv stk mem strg ctx evm_stack_opm Sidx_gt_Sidx'
        eval_arg22) as eval_arg22_alt.
      rewrite -> eval_arg22_alt in eq_eval_arg22.
      rewrite <- eval_arg1 in eq_eval_arg22.
      injection eq_eval_arg22 as eq_arg1v_arg22v.
      rewrite -> eq_arg1v_arg22v.
      
      simpl. rewrite -> PeanoNat.Nat.eqb_refl. simpl.
      rewrite -> eq_eval_arg1.
      rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eq_eval_arg21.
      apply follow_suffix in eq_follow_arg2 as [prefix eq_prefix].
      pose proof (eval_sstack_val'_extend_sb instk_height idx stk mem strg
        ctx idx sb sb' evm_stack_opm prefix Hvalid_sb eq_prefix arg21 arg21v
        eq_eval_arg21) as eval_arg21_alt.
      apply eval_sstack_val'_preserved_when_depth_extended in eval_arg21_alt.
      rewrite -> eq_maxidx.
      rewrite -> eval_arg21_alt. simpl.
      
      rewrite <- eq_arg1v_arg22v.
      rewrite -> wor_wor_2.
      reflexivity.
      
  + destruct (is_or arg2 arg1 fcmp idx instk_height sb evm_stack_opm) 
      as [y|] eqn: eq_is_or'; try inject_rw Hoptm_sbinding eq_val'.
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    
    unfold is_or in eq_is_or'.
    destruct (follow_in_smap arg1 idx sb) as [fsmv|] eqn: eq_follow_arg1;
      try discriminate.
    destruct fsmv as [smv idx' sb'].
    destruct smv as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
    destruct label2 eqn: eq_label2; try discriminate.
    destruct args2 as [|arg11 r11]; try discriminate.
    destruct r11 as [|arg12 r12]; try discriminate.
    destruct r12; try discriminate.
    
    destruct (fcmp arg2 arg11 idx sb idx' sb' instk_height evm_stack_opm)
      eqn: eq_fcmp_arg2_arg11.

    * (* arg2 ~ arg11 *)
      unfold eval_sstack_val in Heval_orig.
      unfold eval_sstack_val.
    
      injection eq_is_or' as eq_y.
      rewrite <- eq_y.
      
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
      destruct Hvalid as [eq_maxidx [Hvalid_or Hvalid_sb]].
      unfold valid_stack_op_instr in Hvalid_or.
      simpl in Hvalid_or.
      destruct Hvalid_or as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
      pose proof (valid_follow_in_smap sb arg1 instk_height idx 
        evm_stack_opm (SymOp OR [arg11; arg12]) idx' sb' Hvalid_arg1
        Hvalid_sb eq_follow_arg1) as [Hvalid_or [Hvalid_sb' Himpl]]. 
      pose proof (not_basic_value_smv_symop OR [arg11; arg12]) as eq_not_basic.
      apply Himpl in eq_not_basic as idx_gt_idx'.
      unfold valid_stack_op_instr in Hvalid_or.
      unfold valid_smap_value in Hvalid_or.
      unfold valid_stack_op_instr in Hvalid_or.
      simpl in Hvalid_or.
      destruct Hvalid_or as [_ [Hvalid_arg11 [Hvalid_arg12 _]]].

      rewrite -> eq_maxidx in eq_eval_arg1.
      simpl in eq_eval_arg1.
      rewrite -> eq_follow_arg1 in eq_eval_arg1.
      simpl in eq_eval_arg1.
      destruct (eval_sstack_val' idx arg11 stk mem strg ctx idx' sb' 
        evm_stack_opm) as [arg11v|] eqn: eq_eval_arg11; try discriminate.
      destruct (eval_sstack_val' idx arg12 stk mem strg ctx idx' sb' 
        evm_stack_opm) as [arg12v|] eqn: eq_eval_arg12; try discriminate.
      injection eq_eval_arg1 as eq_arg1v.
      rewrite <- eq_arg1v.
      unfold evm_or.

      (* arg2v or arg11v are the same *)
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
      
      simpl. rewrite -> PeanoNat.Nat.eqb_refl. simpl.
      rewrite -> eq_eval_arg2.
      rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eq_eval_arg12.
      apply follow_suffix in eq_follow_arg1 as [prefix eq_prefix].
      pose proof (eval_sstack_val'_extend_sb instk_height idx stk mem strg
        ctx idx sb sb' evm_stack_opm prefix Hvalid_sb eq_prefix arg12 arg12v
        eq_eval_arg12) as eval_arg12_alt.
      apply eval_sstack_val'_preserved_when_depth_extended in eval_arg12_alt.
      rewrite -> eq_maxidx.
      rewrite -> eval_arg12_alt. simpl.
      
      rewrite <- eq_arg2v_arg11v.
      rewrite -> wor_wor_3.
      reflexivity.
      
    * destruct (fcmp arg2 arg12 idx sb idx' sb' instk_height evm_stack_opm)
        eqn: eq_fcmp_arg2_arg12; try discriminate.
      (* arg2 ~ arg12 *)
      unfold eval_sstack_val in Heval_orig.
      unfold eval_sstack_val.
    
      injection eq_is_or' as eq_y.
      rewrite <- eq_y.
      
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
      destruct Hvalid as [eq_maxidx [Hvalid_or Hvalid_sb]].
      unfold valid_stack_op_instr in Hvalid_or.
      simpl in Hvalid_or.
      destruct Hvalid_or as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
      pose proof (valid_follow_in_smap sb arg1 instk_height idx 
        evm_stack_opm (SymOp OR [arg11; arg12]) idx' sb' Hvalid_arg1
        Hvalid_sb eq_follow_arg1) as [Hvalid_or [Hvalid_sb' Himpl]]. 
      pose proof (not_basic_value_smv_symop OR [arg11; arg12]) as eq_not_basic.
      apply Himpl in eq_not_basic as idx_gt_idx'.
      unfold valid_stack_op_instr in Hvalid_or.
      unfold valid_smap_value in Hvalid_or.
      unfold valid_stack_op_instr in Hvalid_or.
      simpl in Hvalid_or.
      destruct Hvalid_or as [_ [Hvalid_arg11 [Hvalid_arg12 _]]].

      rewrite -> eq_maxidx in eq_eval_arg1.
      simpl in eq_eval_arg1.
      rewrite -> eq_follow_arg1 in eq_eval_arg1.
      simpl in eq_eval_arg1.
      destruct (eval_sstack_val' idx arg11 stk mem strg ctx idx' sb' 
        evm_stack_opm) as [arg11v|] eqn: eq_eval_arg11; try discriminate.
      destruct (eval_sstack_val' idx arg12 stk mem strg ctx idx' sb' 
        evm_stack_opm) as [arg12v|] eqn: eq_eval_arg12; try discriminate.
      injection eq_eval_arg1 as eq_arg1v.
      rewrite <- eq_arg1v.
      unfold evm_or.

      (* arg2v or arg12v are the same *)
      symmetry in Hlen.
      pose proof (Hsafe_sstack_val_cmp arg2 arg12 idx sb idx' sb' instk_height 
        evm_stack_opm Hvalid_arg2 Hvalid_arg12 Hvalid_sb Hvalid_sb'
        eq_fcmp_arg2_arg12 stk mem strg ctx Hlen) as [vv [eval_arg2 
        eval_arg12]].
      unfold eval_sstack_val in eval_arg2.
      rewrite <- eq_maxidx in eval_arg2.
      rewrite -> eq_eval_arg2 in eval_arg2.
      unfold eval_sstack_val in eval_arg12.
      apply eval_sstack_val'_preserved_when_depth_extended in 
        eq_eval_arg12.
      apply Gt.gt_n_S in idx_gt_idx' as Sidx_gt_Sidx'.
      pose proof (eval_sstack_val'_preserved_when_depth_extended_lt (S idx')
        (S idx) idx' sb' arg12 vv stk mem strg ctx evm_stack_opm Sidx_gt_Sidx'
        eval_arg12) as eval_arg12_alt.
      rewrite -> eval_arg12_alt in eq_eval_arg12.
      rewrite <- eval_arg2 in eq_eval_arg12.
      injection eq_eval_arg12 as eq_arg2v_arg12v.
      rewrite -> eq_arg2v_arg12v.
      
      simpl. rewrite -> PeanoNat.Nat.eqb_refl. simpl.
      rewrite -> eq_eval_arg2.
      rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eq_eval_arg11.
      apply follow_suffix in eq_follow_arg1 as [prefix eq_prefix].
      pose proof (eval_sstack_val'_extend_sb instk_height idx stk mem strg
        ctx idx sb sb' evm_stack_opm prefix Hvalid_sb eq_prefix arg11 arg11v
        eq_eval_arg11) as eval_arg11_alt.
      apply eval_sstack_val'_preserved_when_depth_extended in eval_arg11_alt.
      rewrite -> eq_maxidx.
      rewrite -> eval_arg11_alt. simpl.
      
      rewrite <- eq_arg2v_arg12v.
      rewrite -> wor_wor_4.
      reflexivity.
Qed.

End Opt_or_or.

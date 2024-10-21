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


Module Opt_and_shr.


Fixpoint is_2_pow_n_minus_1' (n: N) (size: nat): option nat :=
  match size with
  | O => None
  | S size' => 
      if N.eqb n (N.sub (N.pow (2%N) (N.of_nat size)) 1) then Some size
      else is_2_pow_n_minus_1' n size'
  end.


Definition is_2_pow_n_minus_1 (w: EVMWord) : option nat :=
  is_2_pow_n_minus_1' (wordToN w) EVMWordSize.


Definition is_2_pow_n_minus_1_follow (sv: sstack_val) 
  (maxid: nat) (sb: sbindings): option nat :=
match follow_in_smap sv maxid sb with
  | Some (FollowSmapVal (SymBasicVal (Val v)) _ _) => 
      is_2_pow_n_minus_1 v
  | _ => None
end.


Definition is_shr_const (sv: sstack_val)
  (maxid: nat) (sb: sbindings) :=
match follow_in_smap sv maxid sb with 
| Some (FollowSmapVal (SymOp SHR [arg1; arg2]) idx' sb') => 
    match is_2_pow_n_minus_1_follow arg1 idx' sb' with
    | Some size => Some (size, arg2)
    | None => None
    end
| _ => None
end.


(* AND(2^A-1, SHR(B,X)) = SHR(B,X) if B >= A and A, B *)
Definition optimize_and_shr_sbinding : opt_smap_value_type :=   
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
(val, false).
(*
TODO: FINISH

match val with
| SymOp AND [arg1; arg2] => 
  match is_2_pow_n_minus_1_follow arg1 maxid sb with
  | Some a => 
    match is_shr_const arg2 maxid sb with
    | Some (b, x) => 
      if (leb b a)%nat then (SymOp SHR [Val natToWord EVMWord b; x], true)
      else (val, false) 
    | None => (val, false) 
    end
  | None => 
    match is_2_pow_n_minus_1_follow arg2 maxid sb with 
    | Some a => 
      match is_shr_const arg1 maxid sb with
      | Some (b, x) => 
        if b >= a then (SymOp SHR [Val natToWord EVMWord b; x], true)
        else (val, false) 
      | None => (val, false) 
      end
    | None => (val, false)
    end
  end
| _ => (val, false)
end.
*)


Lemma optimize_and_shr_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_and_shr_sbinding.
Proof.
Admitted.
(*
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros _ Hvalid_smapv_val Hvalid Hoptm_sbinding.
unfold optimize_and_shr_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try try inject_rw Hoptm_sbinding eq_val'.
destruct args as [|arg1 r1]; try inject_rw Hoptm_sbinding eq_val'.
destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
destruct r2; try inject_rw Hoptm_sbinding eq_val'.
destruct (is_shl_1 arg1 fcmp n instk_height sb evm_stack_opm) as [x|] eqn: is_shl_arg1.
- injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
  unfold is_shl_1 in is_shl_arg1.
  destruct (follow_in_smap arg1 n sb) as [fsmv1|] eqn: Hfollow_arg1;
    try discriminate.
  destruct fsmv1 as [smv_arg1 idx' sb'].
  destruct (smv_arg1) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
  destruct label2; try discriminate.
  destruct args2 as [|xx r2]; try discriminate.
  destruct r2 as [|onev r2']; try discriminate.
  destruct r2'; try discriminate.
  destruct (fcmp onev (Val WOne) n sb n sb instk_height evm_stack_opm) eqn: fcmp_onev;
    try discriminate.
    
  simpl in Hvalid_smapv_val. unfold valid_stack_op_instr in Hvalid_smapv_val.
  simpl in Hvalid_smapv_val.
  destruct Hvalid_smapv_val as [_ Hvalid_sstack_arg1_arg2].
  unfold valid_sstack in Hvalid_sstack_arg1_arg2.
  destruct Hvalid_sstack_arg1_arg2 as [Hvalid_arg1 [Hvalid_arg2 _]].
  injection is_shl_arg1 as eq_xx. rewrite -> eq_xx in Hfollow_arg1.
  pose proof (valid_follow_in_smap sb arg1 instk_height n evm_stack_opm
    (SymOp SHL [x; onev]) idx' sb' Hvalid_arg1 Hvalid Hfollow_arg1) as Himpl.
  destruct Himpl as [Hvalid_shl [Hvalid_sb' Himpl]].
  pose proof (not_basic_value_smv_symop SHL [x;onev]) as Hnot_basic.
  apply Himpl in Hnot_basic.
  unfold valid_smap_value in Hvalid_shl. 
  unfold valid_stack_op_instr in Hvalid_shl.
  simpl in Hvalid_shl.
  destruct Hvalid_shl as [Hnargs Hvalid_idx'].
  simpl in Hnargs.
  unfold valid_sstack in Hvalid_idx'.
  destruct Hvalid_idx' as [Hvalid_x _].
  apply valid_sstack_value_gt with (m:=n) in Hvalid_x; try assumption.
  
  simpl. unfold valid_stack_op_instr.
  simpl. 
  intuition.
- destruct (is_shl_1 arg2 fcmp n instk_height sb evm_stack_opm) as [y|] eqn: is_shl_arg2;
    try inject_rw Hoptm_sbinding eq_val'.
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
  unfold is_shl_1 in is_shl_arg2.
  destruct (follow_in_smap arg2 n sb) as [fsmv2|] eqn: Hfollow_arg2;
    try discriminate.
  destruct fsmv2 as [smv_arg2 idx' sb'].
  destruct (smv_arg2) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
  destruct label2; try discriminate.
  destruct args2 as [|yy r2]; try discriminate.
  destruct r2 as [|onev r2']; try discriminate.
  destruct r2'; try discriminate.
  destruct (fcmp onev (Val WOne) n sb n sb instk_height evm_stack_opm) eqn: fcmp_onev;
    try discriminate.
    
  simpl in Hvalid_smapv_val. unfold valid_stack_op_instr in Hvalid_smapv_val.
  simpl in Hvalid_smapv_val.
  destruct Hvalid_smapv_val as [_ Hvalid_sstack_arg1_arg2].
  unfold valid_sstack in Hvalid_sstack_arg1_arg2.
  destruct Hvalid_sstack_arg1_arg2 as [Hvalid_arg1 [Hvalid_arg2 _]].
  injection is_shl_arg2 as eq_yy. rewrite -> eq_yy in Hfollow_arg2.
  pose proof (valid_follow_in_smap sb arg2 instk_height n evm_stack_opm
    (SymOp SHL [y; onev]) idx' sb' Hvalid_arg2 Hvalid Hfollow_arg2) as Himpl.
  destruct Himpl as [Hvalid_shl [Hvalid_sb' Himpl]].
  pose proof (not_basic_value_smv_symop SHL [y;onev]) as Hnot_basic.
  apply Himpl in Hnot_basic.
  unfold valid_smap_value in Hvalid_shl. 
  unfold valid_stack_op_instr in Hvalid_shl.
  simpl in Hvalid_shl.
  destruct Hvalid_shl as [Hnargs Hvalid_idx'].
  simpl in Hnargs.
  unfold valid_sstack in Hvalid_idx'.
  destruct Hvalid_idx' as [Hvalid_y _].
  apply valid_sstack_value_gt with (m:=n) in Hvalid_y; try assumption.
  
  simpl. unfold valid_stack_op_instr.
  simpl. 
  intuition.
Qed.
*)


Lemma optimize_and_shr_sbinding_snd:
opt_sbinding_snd optimize_and_shr_sbinding.
Proof.
Admitted.
(*
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_and_shr_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_and_shr_sbinding_smapv_valid. 

- (* evaluation is preserved *) 
  intros stk mem strg exts v Hlen Heval_orig.
  unfold optimize_and_shr_sbinding in Hoptm_sbinding.
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymOp label args *)
  destruct label eqn: eq_label; try inject_rw Hoptm_sbinding eq_val'.
  destruct args as [|arg1 r1] eqn: eq_args; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r2; try inject_rw Hoptm_sbinding eq_val'.
  destruct (is_shl_1 arg1 fcmp idx instk_height sb evm_stack_opm) 
    as [x|] eqn: is_shl_arg1.
  + injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    unfold is_shl_1 in is_shl_arg1.
    destruct (follow_in_smap arg1 idx sb) as [fsmv1|] eqn: Hfollow_arg1;
      try discriminate.
    destruct fsmv1 as [smv_arg1 idx' sb'].
    destruct (smv_arg1) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
    destruct label2; try discriminate.
    destruct args2 as [|xx r2]; try discriminate.
    destruct r2 as [|onev r2']; try discriminate.
    destruct r2'; try discriminate.
    destruct (fcmp onev (Val WOne) idx sb idx sb instk_height evm_stack_opm) eqn: fcmp_onev;
      try discriminate.
      
    unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
    rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
    simpl in Heval_orig.
    destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb 
      evm_stack_opm) as [arg1v|] eqn: eval_arg1; try discriminate.
    destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb
      evm_stack_opm) as [arg2v|] eqn: eval_arg2; try discriminate.
    rewrite <- Heval_orig. simpl.
    
    unfold eval_sstack_val. simpl.
    rewrite -> PeanoNat.Nat.eqb_refl. simpl.
    rewrite -> eval_arg2.
    destruct maxidx as [|maxidx'] eqn: eq_maxidx; try discriminate.
    unfold eval_sstack_val' in eval_arg1.
    rewrite -> Hfollow_arg1 in eval_arg1.
    simpl in eval_arg1. fold eval_sstack_val' in eval_arg1.
    destruct (eval_sstack_val' maxidx' xx stk mem strg exts idx' sb'
      evm_stack_opm) as [xxv|] eqn: eval_xx_sb'; try discriminate.
    destruct (eval_sstack_val' maxidx' onev stk mem strg exts idx' sb'
      evm_stack_opm) as [onev_v|] eqn: eval_onev; try discriminate.
    injection is_shl_arg1 as eq_xx. rewrite -> eq_xx in eval_xx_sb'.
    injection eval_arg1 as eq_arg1v. rewrite <- eq_arg1v.
    
    simpl in Hvalid.
    destruct Hvalid as [eq_maxidx' [Hvalid_arg1_arg2 Hvalid_sb]].
    unfold valid_stack_op_instr in Hvalid_arg1_arg2.
    simpl in Hvalid_arg1_arg2.
    destruct Hvalid_arg1_arg2 as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
    pose proof (follow_suffix sb arg1 idx (SymOp SHL [xx; onev]) idx' sb'
      Hfollow_arg1) as [prefix sb_prefix].
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_xx_sb'.
    pose proof (eval_sstack_val'_extend_sb instk_height maxidx' stk mem strg
      exts idx sb sb' evm_stack_opm prefix Hvalid_sb sb_prefix x xxv
      eval_xx_sb') as eval_x_sb.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_x_sb.
    rewrite -> eval_x_sb. 
    
    pose proof (valid_follow_in_smap sb arg1 instk_height idx evm_stack_opm
      (SymOp SHL [xx; onev]) idx' sb' Hvalid_arg1 Hvalid_sb Hfollow_arg1)
      as [Hvalid_smv [Hvalid_sb' Himpl]].
    pose proof (not_basic_value_smv_symop SHL [xx;onev]) as Hnot_basic.
    apply Himpl in Hnot_basic as idx_gt_idx'.
    unfold valid_smap_value in Hvalid_smv.
    unfold valid_stack_op_instr in Hvalid_smv.
    simpl in Hvalid_smv.
    destruct Hvalid_smv as [_ [Hvalid_xx [Hvalid_onev _]]].
    pose proof (valid_sstack_value_gt instk_height idx' idx onev Hvalid_onev
      idx_gt_idx') as Hvalid_onev_sb.
    symmetry in Hlen.
    pose proof (valid_sstack_value_const instk_height idx WOne) as Hvalid_WOne.
    pose proof (Hsafe_sstack_val_cmp onev (Val WOne) idx sb idx sb instk_height
      evm_stack_opm Hvalid_onev_sb Hvalid_WOne Hvalid_sb Hvalid_sb fcmp_onev
      stk mem strg exts Hlen) as [vv [eval_onev' eval_WOne]].
    rewrite -> eval_sstack_val_const in eval_WOne.
    rewrite <- eval_WOne in eval_onev'.
    unfold eval_sstack_val in eval_onev'.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_onev.
    rewrite -> eq_maxidx' in eval_onev.
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_onev.
    apply eval_sstack_val'_extend_sb with (instk_height:=instk_height)(sb:=sb)
      (prefix:=prefix) in eval_onev; try assumption.
    rewrite -> eval_onev' in eval_onev.
    injection eval_onev as eq_onev_v.
    rewrite <- eq_onev_v.
    
    simpl. rewrite <- wmult_shl'_1.
    reflexivity.
  + destruct (is_shl_1 arg2 fcmp idx instk_height sb evm_stack_opm) as [y|] 
    eqn: is_shl_arg2; try inject_rw Hoptm_sbinding eq_val'.
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    unfold is_shl_1 in is_shl_arg2.
    destruct (follow_in_smap arg2 idx sb) as [fsmv2|] eqn: Hfollow_arg2;
      try discriminate.
    destruct fsmv2 as [smv_arg2 idx' sb'].
    destruct (smv_arg2) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
    destruct label2; try discriminate.
    destruct args2 as [|yy r2]; try discriminate.
    destruct r2 as [|onev r2']; try discriminate.
    destruct r2'; try discriminate.
    destruct (fcmp onev (Val WOne) idx sb idx sb instk_height evm_stack_opm) 
      eqn: fcmp_onev; try discriminate.
      
    unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
    rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
    simpl in Heval_orig.
    destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb 
      evm_stack_opm) as [arg1v|] eqn: eval_arg1; try discriminate.
    destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb
      evm_stack_opm) as [arg2v|] eqn: eval_arg2; try discriminate.
    rewrite <- Heval_orig. simpl.
    
    unfold eval_sstack_val. simpl.
    rewrite -> PeanoNat.Nat.eqb_refl. simpl.
    rewrite -> eval_arg1.
    destruct maxidx as [|maxidx'] eqn: eq_maxidx; try discriminate.
    unfold eval_sstack_val' in eval_arg2.
    rewrite -> Hfollow_arg2 in eval_arg2.
    simpl in eval_arg2. fold eval_sstack_val' in eval_arg2.
    destruct (eval_sstack_val' maxidx' yy stk mem strg exts idx' sb'
      evm_stack_opm) as [yyv|] eqn: eval_yy_sb'; try discriminate.
    destruct (eval_sstack_val' maxidx' onev stk mem strg exts idx' sb'
      evm_stack_opm) as [onev_v|] eqn: eval_onev; try discriminate.
    injection is_shl_arg2 as eq_yy. rewrite -> eq_yy in eval_yy_sb'.
    injection eval_arg2 as eq_arg2v. rewrite <- eq_arg2v.
    
    simpl in Hvalid.
    destruct Hvalid as [eq_maxidx' [Hvalid_arg1_arg2 Hvalid_sb]].
    unfold valid_stack_op_instr in Hvalid_arg1_arg2.
    simpl in Hvalid_arg1_arg2.
    destruct Hvalid_arg1_arg2 as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
    pose proof (follow_suffix sb arg2 idx (SymOp SHL [yy; onev]) idx' sb'
      Hfollow_arg2) as [prefix sb_prefix].
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_yy_sb'.
    pose proof (eval_sstack_val'_extend_sb instk_height maxidx' stk mem strg
      exts idx sb sb' evm_stack_opm prefix Hvalid_sb sb_prefix y yyv
      eval_yy_sb') as eval_y_sb.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_y_sb.
    rewrite -> eval_y_sb.
    simpl. 
    
    pose proof (valid_follow_in_smap sb arg2 instk_height idx evm_stack_opm
      (SymOp SHL [yy; onev]) idx' sb' Hvalid_arg2 Hvalid_sb Hfollow_arg2)
      as [Hvalid_smv [Hvalid_sb' Himpl]].
    pose proof (not_basic_value_smv_symop SHL [yy;onev]) as Hnot_basic.
    apply Himpl in Hnot_basic as idx_gt_idx'.
    unfold valid_smap_value in Hvalid_smv.
    unfold valid_stack_op_instr in Hvalid_smv.
    simpl in Hvalid_smv.
    destruct Hvalid_smv as [_ [Hvalid_yy [Hvalid_onev _]]].
    pose proof (valid_sstack_value_gt instk_height idx' idx onev Hvalid_onev
      idx_gt_idx') as Hvalid_onev_sb.
    symmetry in Hlen.
    pose proof (valid_sstack_value_const instk_height idx WOne) as Hvalid_WOne.
    pose proof (Hsafe_sstack_val_cmp onev (Val WOne) idx sb idx sb instk_height
      evm_stack_opm Hvalid_onev_sb Hvalid_WOne Hvalid_sb Hvalid_sb fcmp_onev
      stk mem strg exts Hlen) as [vv [eval_onev' eval_WOne]].
    rewrite -> eval_sstack_val_const in eval_WOne.
    rewrite <- eval_WOne in eval_onev'.
    unfold eval_sstack_val in eval_onev'.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_onev.
    rewrite -> eq_maxidx' in eval_onev.
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_onev.
    apply eval_sstack_val'_extend_sb with (instk_height:=instk_height)(sb:=sb)
      (prefix:=prefix) in eval_onev; try assumption.
    rewrite -> eval_onev' in eval_onev.
    injection eval_onev as eq_onev_v.
    rewrite <- eq_onev_v.
    
    rewrite <- wmult_shl'_1.
    rewrite -> wmult_comm.
    reflexivity.
Qed.
*)

End Opt_and_shr.

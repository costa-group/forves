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


Module Opt_eq_iszero.


Definition is_iszero (sv: sstack_val) (fcmp: sstack_val_cmp_t) 
  (maxid instk_height: nat) (sb: sbindings) (ops: stack_op_instr_map) :=
match follow_in_smap sv maxid sb with 
| Some (FollowSmapVal (SymOp ISZERO [arg]) idx' sb') => Some arg
| _ => None
end.



(* EQ(ISZERO(X), 1) = EQ(1, ISZERO(X)) = ISZERO(X) *)
Definition optimize_eq_iszero_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp EQ [arg1; arg2] => 
  match is_iszero arg1 fcmp maxid instk_height sb ops with
  | Some x => if fcmp arg2 (Val WOne) maxid sb maxid sb instk_height ops
              then (SymOp ISZERO [x], true)
              else (val, false)
  | None => match is_iszero arg2 fcmp maxid instk_height sb ops with
            | Some x => if fcmp arg1 (Val WOne) maxid sb maxid sb instk_height ops
                        then (SymOp ISZERO [x], true)
                        else (val, false)
            | None => (val, false)
            end
  end
| _ => (val, false)
end.




Lemma eq_iszero_one_l_snd: forall exts x,
evm_eq exts [evm_iszero exts [x]; WOne] = evm_iszero exts [x].
Proof.
intros exts x.
unfold evm_iszero. unfold evm_eq.
destruct (weqb x WZero) eqn: eq_weqb.
- reflexivity.
- reflexivity.
Qed.


Lemma eq_iszero_one_r_snd: forall exts x,
evm_eq exts [WOne; evm_iszero exts [x]] = evm_iszero exts [x].
Proof.
intros exts x.
unfold evm_iszero. unfold evm_eq.
destruct (weqb x WZero) eqn: eq_weqb.
- reflexivity.
- reflexivity.
Qed.





Lemma optimize_eq_iszero_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_eq_iszero_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros _ Hvalid_smapv_val Hvalid Hoptm_sbinding.
unfold optimize_eq_iszero_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try try inject_rw Hoptm_sbinding eq_val'.
destruct args as [|arg1 r1]; try inject_rw Hoptm_sbinding eq_val'.
destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
destruct r2; try inject_rw Hoptm_sbinding eq_val'.
destruct (is_iszero arg1 fcmp n instk_height sb evm_stack_opm) as [x|] 
  eqn: is_iszero_arg1.
- destruct (fcmp arg2 (Val WOne) n sb n sb instk_height evm_stack_opm)
    eqn: eq_fcmp_arg2_one; try inject_rw Hoptm_sbinding eq_val'.
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
  unfold is_iszero in is_iszero_arg1.
  destruct (follow_in_smap arg1 n sb) as [fsmv1|] eqn: Hfollow_arg1;
    try discriminate.
  destruct fsmv1 as [smv_arg1 idx' sb'].
  destruct (smv_arg1) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
  destruct label2; try discriminate.
  destruct args2 as [|xx r2]; try discriminate.
  destruct r2; try discriminate.
  injection is_iszero_arg1 as eq_xx. rewrite -> eq_xx in Hfollow_arg1.
    
  simpl in Hvalid_smapv_val. unfold valid_stack_op_instr in Hvalid_smapv_val.
  simpl in Hvalid_smapv_val.
  destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
  pose proof (valid_follow_in_smap sb arg1 instk_height n evm_stack_opm
    (SymOp ISZERO [x]) idx' sb' Hvalid_arg1 Hvalid Hfollow_arg1) as Himpl.
  destruct Himpl as [Hvalid_iszero [Hvalid_sb' Himpl]].
  pose proof (not_basic_value_smv_symop ISZERO [x]) as Hnot_basic.
  apply Himpl in Hnot_basic.
  unfold valid_smap_value in Hvalid_iszero. 
  unfold valid_stack_op_instr in Hvalid_iszero.
  simpl in Hvalid_iszero.
  destruct Hvalid_iszero as [_ [Hvalid_x_idx' _]].
  apply valid_sstack_value_gt with (m:=n) in Hvalid_x_idx'; try assumption.
  
  simpl. unfold valid_stack_op_instr.
  simpl. 
  intuition.
- destruct (is_iszero arg2 fcmp n instk_height sb evm_stack_opm) as [x|]
    eqn: is_iszero_arg2; try inject_rw Hoptm_sbinding eq_val'.
  destruct (fcmp arg1 (Val WOne) n sb n sb instk_height evm_stack_opm)
    eqn: eq_fcmp_arg1_one; try inject_rw Hoptm_sbinding eq_val'.
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
  unfold is_iszero in is_iszero_arg2.
  destruct (follow_in_smap arg2 n sb) as [fsmv1|] eqn: Hfollow_arg2;
    try discriminate.
  destruct fsmv1 as [smv_arg1 idx' sb'].
  destruct (smv_arg1) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
  destruct label2; try discriminate.
  destruct args2 as [|xx r2]; try discriminate.
  destruct r2; try discriminate.
  injection is_iszero_arg2 as eq_xx. rewrite -> eq_xx in Hfollow_arg2.
    
  simpl in Hvalid_smapv_val. unfold valid_stack_op_instr in Hvalid_smapv_val.
  simpl in Hvalid_smapv_val.
  destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
  pose proof (valid_follow_in_smap sb arg2 instk_height n evm_stack_opm
    (SymOp ISZERO [x]) idx' sb' Hvalid_arg2 Hvalid Hfollow_arg2) as Himpl.
  destruct Himpl as [Hvalid_iszero [Hvalid_sb' Himpl]].
  pose proof (not_basic_value_smv_symop ISZERO [x]) as Hnot_basic.
  apply Himpl in Hnot_basic.
  unfold valid_smap_value in Hvalid_iszero. 
  unfold valid_stack_op_instr in Hvalid_iszero.
  simpl in Hvalid_iszero.
  destruct Hvalid_iszero as [_ [Hvalid_x_idx' _]].
  apply valid_sstack_value_gt with (m:=n) in Hvalid_x_idx'; try assumption.
  
  simpl. unfold valid_stack_op_instr.
  simpl. 
  intuition.
Qed.


Lemma evm_iszero_def: forall exts x,
evm_iszero exts [x] = if weqb x WZero then WOne else WZero.
Proof.
intuition.
Qed.


Lemma optimize_eq_iszero_sbinding_snd:
opt_sbinding_snd optimize_eq_iszero_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_eq_iszero_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_eq_iszero_sbinding_smapv_valid. 

- (* evaluation is preserved *) 
  intros stk mem strg exts v Hlen Heval_orig.
  unfold optimize_eq_iszero_sbinding in Hoptm_sbinding.
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymOp label args *)
  destruct label eqn: eq_label; try inject_rw Hoptm_sbinding eq_val'.
  destruct args as [|arg1 r1] eqn: eq_args; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r2; try inject_rw Hoptm_sbinding eq_val'.
  destruct (is_iszero arg1 fcmp idx instk_height sb evm_stack_opm) 
    as [x|] eqn: is_iszero_arg1.
  + destruct (fcmp arg2 (Val WOne) idx sb idx sb instk_height evm_stack_opm)
      eqn: eq_fcmp_arg2_one; try inject_rw Hoptm_sbinding eq_val'.
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    unfold is_iszero in is_iszero_arg1.
    destruct (follow_in_smap arg1 idx sb) as [fsmv1|] eqn: Hfollow_arg1;
      try discriminate.
    destruct fsmv1 as [smv_arg1 idx' sb'].
    destruct (smv_arg1) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
    destruct label2; try discriminate.
    destruct args2 as [|xx r2]; try discriminate.
    destruct r2; try discriminate.
    injection is_iszero_arg1 as eq_xx. rewrite -> eq_xx in Hfollow_arg1.
      
    unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
    rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
    simpl in Heval_orig.
    destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb 
      evm_stack_opm) as [arg1v|] eqn: eval_arg1; try discriminate.
    destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb 
      evm_stack_opm) as [arg2v|] eqn: eval_arg2; try discriminate.

    unfold eval_sstack_val. simpl.
    rewrite -> PeanoNat.Nat.eqb_refl. simpl.
    pose proof (eval'_succ_then_nonzero maxidx arg1 stk mem strg exts idx sb
       evm_stack_opm arg1v eval_arg1) as [n eq_maxidx].
    rewrite -> eq_maxidx in eval_arg1. simpl in eval_arg1.
    rewrite -> Hfollow_arg1 in eval_arg1. simpl in eval_arg1.
    destruct (eval_sstack_val' n x stk mem strg exts idx' sb'
      evm_stack_opm) as [xv|] eqn: eval_x; try discriminate.
    injection eval_arg1 as eq_argv1.
    rewrite <- evm_iszero_def with (exts:=exts) in eq_argv1.
    rewrite <- eq_argv1 in Heval_orig.
    
    pose proof (follow_suffix sb arg1 idx (SymOp ISZERO [x]) idx' sb'
      Hfollow_arg1) as [prefix sb_prefix].
    simpl in Hvalid.
    destruct Hvalid as [eq_maxidx' [Hvalid_eq Hvalid_sb]].
    unfold valid_stack_op_instr in Hvalid_eq.
    simpl in Hvalid_eq.
    destruct Hvalid_eq as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_x.
    pose proof (eval_sstack_val'_extend_sb instk_height n stk mem strg
      exts idx sb sb' evm_stack_opm prefix Hvalid_sb sb_prefix x xv
      eval_x) as eval_x_sb.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_x_sb.
    rewrite <- eq_maxidx in eval_x_sb.
    rewrite -> eval_x_sb.
    rewrite <- Heval_orig.
    
    pose proof (valid_sstack_value_const instk_height idx WOne) as Hvalid_WOne.
    symmetry in Hlen.
    pose proof (Hsafe_sstack_val_cmp arg2 (Val WOne) idx sb idx sb instk_height
      evm_stack_opm Hvalid_arg2 Hvalid_WOne Hvalid_sb Hvalid_sb eq_fcmp_arg2_one
      stk mem strg exts Hlen) as [vone [eval_onev' eval_WOne]].
    unfold eval_sstack_val in eval_onev'.
    unfold eval_sstack_val in eval_WOne.
    rewrite -> eval_sstack_val'_const in eval_WOne.
    rewrite <- eval_WOne in eval_onev'.
    
    rewrite <- eq_maxidx' in eval_onev'.
    rewrite -> eval_onev' in eval_arg2.
    injection eval_arg2 as eq_argv2.
    rewrite <- eq_argv2.
    
    rewrite -> eq_iszero_one_l_snd.
    reflexivity.

  + destruct (is_iszero arg2 fcmp idx instk_height sb evm_stack_opm) 
    as [x|] eqn: is_iszero_arg2; try inject_rw Hoptm_sbinding eq_val'.
    
    destruct (fcmp arg1 (Val WOne) idx sb idx sb instk_height evm_stack_opm)
      eqn: eq_fcmp_arg1_one; try inject_rw Hoptm_sbinding eq_val'.
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    unfold is_iszero in is_iszero_arg2.
    destruct (follow_in_smap arg2 idx sb) as [fsmv1|] eqn: Hfollow_arg2;
      try discriminate.
    destruct fsmv1 as [smv_arg1 idx' sb'].
    destruct (smv_arg1) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
    destruct label2; try discriminate.
    destruct args2 as [|xx r2]; try discriminate.
    destruct r2; try discriminate.
    injection is_iszero_arg2 as eq_xx. rewrite -> eq_xx in Hfollow_arg2.
      
    unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
    rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
    simpl in Heval_orig.
    destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb 
      evm_stack_opm) as [arg1v|] eqn: eval_arg1; try discriminate.
    destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb 
      evm_stack_opm) as [arg2v|] eqn: eval_arg2; try discriminate.

    unfold eval_sstack_val. simpl.
    rewrite -> PeanoNat.Nat.eqb_refl. simpl.
    pose proof (eval'_succ_then_nonzero maxidx arg1 stk mem strg exts idx sb
       evm_stack_opm arg1v eval_arg1) as [n eq_maxidx].
    rewrite -> eq_maxidx in eval_arg2. simpl in eval_arg2.
    rewrite -> Hfollow_arg2 in eval_arg2. simpl in eval_arg2.
    destruct (eval_sstack_val' n x stk mem strg exts idx' sb'
      evm_stack_opm) as [xv|] eqn: eval_x; try discriminate.
    injection eval_arg2 as eq_argv2.
    rewrite <- evm_iszero_def with (exts:=exts) in eq_argv2.
    rewrite <- eq_argv2 in Heval_orig.
    
    pose proof (follow_suffix sb arg2 idx (SymOp ISZERO [x]) idx' sb'
      Hfollow_arg2) as [prefix sb_prefix].
    simpl in Hvalid.
    destruct Hvalid as [eq_maxidx' [Hvalid_eq Hvalid_sb]].
    unfold valid_stack_op_instr in Hvalid_eq.
    simpl in Hvalid_eq.
    destruct Hvalid_eq as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
    rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_x.
    pose proof (eval_sstack_val'_extend_sb instk_height n stk mem strg
      exts idx sb sb' evm_stack_opm prefix Hvalid_sb sb_prefix x xv
      eval_x) as eval_x_sb.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_x_sb.
    rewrite <- eq_maxidx in eval_x_sb.
    rewrite -> eval_x_sb.
    rewrite <- Heval_orig.
    
    pose proof (valid_sstack_value_const instk_height idx WOne) as Hvalid_WOne.
    symmetry in Hlen.
    pose proof (Hsafe_sstack_val_cmp arg1 (Val WOne) idx sb idx sb instk_height
      evm_stack_opm Hvalid_arg1 Hvalid_WOne Hvalid_sb Hvalid_sb eq_fcmp_arg1_one
      stk mem strg exts Hlen) as [vone [eval_onev' eval_WOne]].
    unfold eval_sstack_val in eval_onev'.
    unfold eval_sstack_val in eval_WOne.
    rewrite -> eval_sstack_val'_const in eval_WOne.
    rewrite <- eval_WOne in eval_onev'.
    
    rewrite <- eq_maxidx' in eval_onev'.
    rewrite -> eval_onev' in eval_arg1.
    injection eval_arg1 as eq_argv1.
    rewrite <- eq_argv1.
    
    rewrite -> eq_iszero_one_r_snd.
    reflexivity.
Qed.


End Opt_eq_iszero.

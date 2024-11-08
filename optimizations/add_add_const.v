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


Module Opt_add_add_const.


Definition is_const (sv: sstack_val) (maxid: nat) (sb: sbindings) :=
match follow_in_smap sv maxid sb with 
| Some (FollowSmapVal (SymBasicVal (Val v)) idx' sb') => Some v
| _ => None
end.


Definition is_add_const (sv: sstack_val) (maxid: nat) (sb: sbindings) :=
match follow_in_smap sv maxid sb with 
| Some (FollowSmapVal (SymOp ADD [arg1; arg2]) idx' sb') => 
    match is_const arg1 maxid sb' with
    | Some c1 => Some (c1, arg2)
    | None => match is_const arg2 maxid sb' with
              | Some c2 => Some (c2, arg1)
              | None => None
              end
    end
| _ => None
end.

(* ADD(const1, ADD(const2, X))) = ADD(const1+const2, X) *)
Definition optimize_add_add_const_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp ADD [arg1; arg2] => 
  match is_const arg1 maxid sb with  
  | Some c1 => match is_add_const arg2 maxid sb with
               | Some (c2, x) => (* ADD(c1, ADD(c2,x)) *)
                                let sum := wplus c1 c2 in 
                                (SymOp ADD [Val sum; x], true)
               | None => (val, false)
               end
  | None => match is_const arg2 maxid sb with
            | Some c2 => match is_add_const arg1 maxid sb with
                         | Some (c1, x) => (* ADD(ADD(c1,x), c2) *)
                                          let sum := wplus c1 c2 in 
                                          (SymOp ADD [Val sum; x], true)
                         | None => (val, false)
                         end
            | None => (val, false)
            end
  end
| _ => (val, false)
end.


Lemma evm_add_assoc: forall (exts: externals) (v1 v2 v3: EVMWord), 
evm_add exts [evm_add exts [v1; v2]; v3] = evm_add exts [v1; evm_add exts [v2; v3]].
Proof.
intros exts v1 v2 v3.
unfold evm_add.
rewrite -> wplus_assoc.
reflexivity.
Qed.


Lemma optimize_add_add_const_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_add_add_const_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros _ Hvalid_smapv_val Hvalid Hoptm_sbinding.
unfold optimize_add_add_const_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try try inject_rw Hoptm_sbinding eq_val'.
destruct args as [|arg1 r1]; try inject_rw Hoptm_sbinding eq_val'.
destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
destruct r2; try inject_rw Hoptm_sbinding eq_val'.
destruct (is_const arg1 n sb) as [v1|] eqn: is_const_arg1.
- destruct (is_add_const arg2 n sb) as [[c2 x]|] eqn: is_add_const_arg2;
    try inject_rw Hoptm_sbinding eq_val'.
  unfold valid_smap_value in Hvalid_smapv_val.
  unfold valid_stack_op_instr in Hvalid_smapv_val.
  simpl in Hvalid_smapv_val.
  destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
  unfold is_add_const in is_add_const_arg2.
  destruct (follow_in_smap arg2 n sb) as [fsmv2|] eqn: Hfollow_arg2;
    try discriminate.
  destruct fsmv2 as [smv_arg2 idx' sb'].
  destruct (smv_arg2) as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
  destruct label2; try discriminate.
  destruct args2 as [|yy r2]; try discriminate.
  destruct r2 as [|c' r2']; try discriminate.
  destruct r2'; try discriminate.
  destruct (is_const yy n sb') as [c''|] eqn: is_const_yy.
  + injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    unfold valid_smap_value. 
    unfold valid_stack_op_instr.
    simpl. split; try intuition.

    injection is_add_const_arg2 as eq_c'' eq_c'.
    pose proof (valid_follow_in_smap sb arg2 instk_height n evm_stack_opm
      (SymOp ADD [yy; c']) idx' sb' Hvalid_arg2 Hvalid Hfollow_arg2) 
      as [eq_valid_add [_ Hnotbasic]].
    pose proof (not_basic_value_smv_symop ADD [yy; c']) as add_not_basic.
    apply Hnotbasic in add_not_basic.
    rewrite <- eq_c'.

    unfold valid_smap_value in eq_valid_add.
    unfold valid_stack_op_instr in eq_valid_add.
    simpl in eq_valid_add.
    destruct eq_valid_add as [_ [_ [Hvalid_c' _]]].
    apply gt_add in add_not_basic as eq_n.
    destruct eq_n as [k eq_n].
    rewrite -> eq_n.
    apply valid_sstack_value_extended_by_i.
    assumption.
  + destruct (is_const c' n sb') as [c''|] eqn: is_const_c'; try discriminate.
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    unfold valid_smap_value. 
    unfold valid_stack_op_instr.
    simpl. split; try intuition.

    injection is_add_const_arg2 as eq_c'' eq_c'.
    pose proof (valid_follow_in_smap sb arg2 instk_height n evm_stack_opm
      (SymOp ADD [yy; c']) idx' sb' Hvalid_arg2 Hvalid Hfollow_arg2) 
      as [eq_valid_add [_ Hnotbasic]].
    pose proof (not_basic_value_smv_symop ADD [yy; c']) as add_not_basic.
    apply Hnotbasic in add_not_basic.
    rewrite <- eq_c'.

    unfold valid_smap_value in eq_valid_add.
    unfold valid_stack_op_instr in eq_valid_add.
    simpl in eq_valid_add.
    destruct eq_valid_add as [_ [Hvalid_yy [_ _]]].
    apply gt_add in add_not_basic as eq_n.
    destruct eq_n as [k eq_n].
    rewrite -> eq_n.
    apply valid_sstack_value_extended_by_i.
    assumption.
- destruct (is_const arg2 n sb) as [c''|] eqn: is_const_arg2; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct (is_add_const arg1 n sb) as [[c1 x]|] eqn: is_add_const_arg1;
    try inject_rw Hoptm_sbinding eq_val'.
  unfold valid_smap_value in Hvalid_smapv_val.
  unfold valid_stack_op_instr in Hvalid_smapv_val.
  simpl in Hvalid_smapv_val.
  destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
  unfold is_add_const in is_add_const_arg1.
  destruct (follow_in_smap arg1 n sb) as [fsmv1|] eqn: Hfollow_arg1;
    try discriminate.
  destruct fsmv1 as [smv_arg1 idx' sb'].
  destruct (smv_arg1) as [_1|_2|label1 args1|_4|_5|_6]; try discriminate.
  destruct label1; try discriminate.
  destruct args1 as [|yy r1]; try discriminate.
  destruct r1 as [|c' r1']; try discriminate.
  destruct r1'; try discriminate.
  destruct (is_const yy n sb') as [c_yy|] eqn: is_const_yy.
  + injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    unfold valid_smap_value. 
    unfold valid_stack_op_instr.
    simpl. split; try intuition.

    injection is_add_const_arg1 as eq_c'' eq_c'.
    pose proof (valid_follow_in_smap sb arg1 instk_height n evm_stack_opm
      (SymOp ADD [yy; c']) idx' sb' Hvalid_arg1 Hvalid Hfollow_arg1) 
      as [eq_valid_add [_ Hnotbasic]].
    pose proof (not_basic_value_smv_symop ADD [yy; c']) as add_not_basic.
    apply Hnotbasic in add_not_basic.
    rewrite <- eq_c'.

    unfold valid_smap_value in eq_valid_add.
    unfold valid_stack_op_instr in eq_valid_add.
    simpl in eq_valid_add.
    destruct eq_valid_add as [_ [_ [Hvalid_c' _]]].
    apply gt_add in add_not_basic as eq_n.
    destruct eq_n as [k eq_n].
    rewrite -> eq_n.
    apply valid_sstack_value_extended_by_i.
    assumption.
  + destruct (is_const c' n sb') as [c_yy|] eqn: is_const_c'; try discriminate.
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    unfold valid_smap_value. 
    unfold valid_stack_op_instr.
    simpl. split; try intuition.

    injection is_add_const_arg1 as eq_c'' eq_c'.
    pose proof (valid_follow_in_smap sb arg1 instk_height n evm_stack_opm
      (SymOp ADD [yy; c']) idx' sb' Hvalid_arg1 Hvalid Hfollow_arg1) 
      as [eq_valid_add [_ Hnotbasic]].
    pose proof (not_basic_value_smv_symop ADD [yy; c']) as add_not_basic.
    apply Hnotbasic in add_not_basic.
    rewrite <- eq_c'.

    unfold valid_smap_value in eq_valid_add.
    unfold valid_stack_op_instr in eq_valid_add.
    simpl in eq_valid_add.
    destruct eq_valid_add as [_ [Hvalid_yy [_ _]]].
    apply gt_add in add_not_basic as eq_n.
    destruct eq_n as [k eq_n].
    rewrite -> eq_n.
    apply valid_sstack_value_extended_by_i.
    assumption.
Qed.    
  


Lemma optimize_add_add_const_sbinding_snd:
opt_sbinding_snd optimize_add_add_const_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_add_add_const_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_add_add_const_sbinding_smapv_valid. 
- (* evaluation is preserved *) 
  intros stk mem strg exts v Hlen Heval_orig.
  unfold optimize_add_add_const_sbinding in Hoptm_sbinding.
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymOp label args *)
  destruct label eqn: eq_label; try inject_rw Hoptm_sbinding eq_val'.
  destruct args as [|arg1 r1] eqn: eq_args; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r2; try inject_rw Hoptm_sbinding eq_val'.
  destruct (is_const arg1 idx sb) as [c1|] eqn: is_const_arg1.
  + destruct (is_add_const arg2 idx sb) as [[c2 x]|] eqn: is_add_const_arg2;
      try inject_rw Hoptm_sbinding eq_val'.
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
    rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
    simpl in Heval_orig.
    destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb evm_stack_opm)
      as [varg1|] eqn: eval_arg1; try discriminate.
    destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb evm_stack_opm)
      as [varg2|] eqn: eval_arg2; try discriminate.
    injection Heval_orig as eq_v.
    rewrite <- eq_v.

    unfold is_add_const in is_add_const_arg2.
    destruct (follow_in_smap arg2 idx sb) as [fsmv2|] eqn: Hfollow_arg2;
      try discriminate.
    destruct fsmv2 as [smv_arg2 idx' sb'].
    destruct (smv_arg2) as [| |label2 args2| | | ]; try discriminate.
    destruct label2; try discriminate.
    destruct args2 as [|arg21 r2]; try discriminate.
    destruct r2 as [|arg22 r2']; try discriminate.
    destruct r2'; try discriminate.
    destruct (is_const arg21 idx sb') as [c21|] eqn: is_const_arg21.

    * (* ADD(c1, ADD(c2, X)) *)
      unfold is_const in is_const_arg21.
      destruct (follow_in_smap arg21 idx sb') as [fsmv21|] eqn: Hfollow_arg21;
        try discriminate.
      destruct fsmv21 as [smv_v21 idx'' sb''].
      destruct (smv_v21) as [sv21| | | | | ]; try discriminate.
      destruct sv21 as [v21| |]; try discriminate.

      unfold valid_bindings in Hvalid.
      destruct Hvalid as [eq_maxidx [Hvalid_smap_value Hvalid_bindings_sb]].
      fold valid_bindings in Hvalid_bindings_sb.

      unfold is_const in is_const_arg1.
      destruct (follow_in_smap arg1 idx sb) as [fsmv1|] eqn: Hfollow_arg1;
        try discriminate.
      destruct fsmv1 as [smv_arg1 idx1 sb1].
      destruct (smv_arg1) as [sv1| | | | | ]; try discriminate.
      destruct sv1 as [v1| |]; try discriminate.

      rewrite -> eq_maxidx in eval_arg1.
      rewrite -> eq_maxidx in eval_arg2.
      unfold eval_sstack_val' in eval_arg1.
      rewrite -> Hfollow_arg1 in eval_arg1.
      
      unfold eval_sstack_val' in eval_arg2.
      fold eval_sstack_val' in eval_arg2.
      rewrite -> Hfollow_arg2 in eval_arg2.
      rewrite -> evm_stack_opm_ADD in eval_arg2.
      rewrite -> length_two in eval_arg2.
      unfold map_option in eval_arg2.

      destruct (eval_sstack_val' idx arg21 stk mem strg exts idx' sb' evm_stack_opm) 
        as [v21v|] eqn: eval_arg21; try discriminate.
      destruct (eval_sstack_val' idx arg22 stk mem strg exts idx' sb' evm_stack_opm)
        as [v22|] eqn: eval_arg22; try discriminate.
      injection eval_arg2 as eq_varg2.
      rewrite <- eq_varg2.

      unfold eval_sstack_val.
      simpl.
      rewrite -> PeanoNat.Nat.eqb_refl.
      simpl.
      rewrite -> eq_maxidx.
      rewrite -> eval_sstack_val'_const.

      injection is_add_const_arg2 as eq_c2 eq_x.
      rewrite <- eq_x.
      pose proof (follow_suffix sb arg2 idx (SymOp ADD [arg21; arg22]) idx' sb'
        Hfollow_arg2) as Hfollow.
      destruct Hfollow as [prefix sb_prefix].
      rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_arg22.
      pose proof (eval_sstack_val'_extend_sb instk_height idx stk mem strg exts idx sb
        sb' evm_stack_opm prefix Hvalid_bindings_sb sb_prefix arg22 v22 eval_arg22)
        as Heval_arg22.
      apply eval_sstack_val'_preserved_when_depth_extended in Heval_arg22.
      rewrite -> Heval_arg22.

      injection is_const_arg1 as eq_c1.
      rewrite <- eq_c1.
      injection eval_arg1 as eq_varg1.
      rewrite <- eq_varg1.
      injection is_const_arg21 as eq_c21.
      rewrite <- eq_c2.
      rewrite <- eq_c21.

      apply eval_sstack_val'_preserved_when_depth_extended in eval_arg21.
      apply eval'_maxidx_indep with (m:=idx) in eval_arg21.
      unfold eval_sstack_val' in eval_arg21.
      rewrite Hfollow_arg21 in eval_arg21.
      injection eval_arg21 as eq_v21.
      rewrite <- eq_v21.
      simpl.
      rewrite <- evm_add_step with (exts:=exts).
      rewrite <- evm_add_step with (exts:=exts).
      rewrite <- evm_add_step with (exts:=exts).
      rewrite <- evm_add_step with (exts:=exts).
      rewrite -> evm_add_assoc.
      reflexivity.

    * (* ADD(c1, ADD(X, c2)) *)
      unfold is_const in is_add_const_arg2.
      destruct (follow_in_smap arg22 idx sb') as [fsmv22|] eqn: Hfollow_arg22;
        try discriminate.
      destruct fsmv22 as [smv_v22 idx'' sb''].
      destruct (smv_v22) as [sv22| | | | | ]; try discriminate.
      destruct sv22 as [v22| |]; try discriminate.

      unfold valid_bindings in Hvalid.
      destruct Hvalid as [eq_maxidx [Hvalid_smap_value Hvalid_bindings_sb]].
      fold valid_bindings in Hvalid_bindings_sb.

      unfold is_const in is_const_arg1.
      destruct (follow_in_smap arg1 idx sb) as [fsmv1|] eqn: Hfollow_arg1;
        try discriminate.
      destruct fsmv1 as [smv_arg1 idx1 sb1].
      destruct (smv_arg1) as [sv1| | | | | ]; try discriminate.
      destruct sv1 as [v1| |]; try discriminate.

      rewrite -> eq_maxidx in eval_arg1.
      rewrite -> eq_maxidx in eval_arg2.
      unfold eval_sstack_val' in eval_arg1.
      rewrite -> Hfollow_arg1 in eval_arg1.
    
      unfold eval_sstack_val' in eval_arg2.
      fold eval_sstack_val' in eval_arg2.
      rewrite -> Hfollow_arg2 in eval_arg2.
      rewrite -> evm_stack_opm_ADD in eval_arg2.
      rewrite -> length_two in eval_arg2.
      unfold map_option in eval_arg2.

      destruct (eval_sstack_val' idx arg21 stk mem strg exts idx' sb' evm_stack_opm) 
        as [v21|] eqn: eval_arg21; try discriminate.
      destruct (eval_sstack_val' idx arg22 stk mem strg exts idx' sb' evm_stack_opm)
        as [v22v|] eqn: eval_arg22; try discriminate.
      injection eval_arg2 as eq_varg2.
      rewrite <- eq_varg2.

      unfold eval_sstack_val.
      simpl.
      rewrite -> PeanoNat.Nat.eqb_refl.
      simpl.
      rewrite -> eq_maxidx.
      rewrite -> eval_sstack_val'_const.

      injection is_add_const_arg2 as eq_c2 eq_x.
      rewrite <- eq_x.
      pose proof (follow_suffix sb arg2 idx (SymOp ADD [arg21; arg22]) idx' sb'
        Hfollow_arg2) as Hfollow.
      destruct Hfollow as [prefix sb_prefix].
      rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_arg21.
      pose proof (eval_sstack_val'_extend_sb instk_height idx stk mem strg exts idx sb
        sb' evm_stack_opm prefix Hvalid_bindings_sb sb_prefix arg21 v21 eval_arg21)
        as Heval_arg21.
      apply eval_sstack_val'_preserved_when_depth_extended in Heval_arg21.
      rewrite -> Heval_arg21.

      injection is_const_arg1 as eq_c1.
      rewrite <- eq_c1.
      injection eval_arg1 as eq_varg1.
      rewrite <- eq_varg1.
      rewrite <- eq_c2.
      
      apply eval_sstack_val'_preserved_when_depth_extended in eval_arg22.
      apply eval'_maxidx_indep with (m:=idx) in eval_arg22.
      unfold eval_sstack_val' in eval_arg22.
      rewrite Hfollow_arg22 in eval_arg22.
      injection eval_arg22 as eq_v22.
      rewrite <- eq_v22.
      simpl.
      rewrite <- evm_add_step with (exts:=exts).
      rewrite <- evm_add_step with (exts:=exts).
      rewrite <- evm_add_step with (exts:=exts).
      rewrite <- evm_add_step with (exts:=exts).
      rewrite -> evm_add_assoc.
      rewrite -> add_comm with (a:=v21)(b:=v22).
      reflexivity.

  + destruct (is_const arg2 idx sb) as [c2|] eqn: is_const_arg2;
      try inject_rw Hoptm_sbinding eq_val'.
    destruct (is_add_const arg1 idx sb) as [[c1 x]|] eqn: is_add_const_arg1;
      try inject_rw Hoptm_sbinding eq_val'.
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
    rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
    simpl in Heval_orig.
    destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb evm_stack_opm)
      as [varg1|] eqn: eval_arg1; try discriminate.
    destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb evm_stack_opm)
      as [varg2|] eqn: eval_arg2; try discriminate.
    injection Heval_orig as eq_v.
    rewrite <- eq_v.

    unfold is_add_const in is_add_const_arg1.
    destruct (follow_in_smap arg1 idx sb) as [fsmv1|] eqn: Hfollow_arg1;
      try discriminate.
    destruct fsmv1 as [smv_arg1 idx' sb'].
    destruct (smv_arg1) as [| |label1 args1| | | ]; try discriminate.
    destruct label1; try discriminate.
    destruct args1 as [|arg11 r1]; try discriminate.
    destruct r1 as [|arg12 r1']; try discriminate.
    destruct r1'; try discriminate.
    destruct (is_const arg11 idx sb') as [c1'|] eqn: is_const_arg11.

    * (* ADD(ADD(c1, X), c2) *)
      unfold is_const in is_const_arg11.
      destruct (follow_in_smap arg11 idx sb') as [fsmv11|] eqn: Hfollow_arg11;
        try discriminate.
      destruct fsmv11 as [smv_v11 idx'' sb''].
      destruct (smv_v11) as [sv11| | | | | ]; try discriminate.
      destruct sv11 as [v11| |]; try discriminate.

      unfold valid_bindings in Hvalid.
      destruct Hvalid as [eq_maxidx [Hvalid_smap_value Hvalid_bindings_sb]].
      fold valid_bindings in Hvalid_bindings_sb.

      unfold is_const in is_const_arg2.
      destruct (follow_in_smap arg2 idx sb) as [fsmv2|] eqn: Hfollow_arg2;
        try discriminate.
      destruct fsmv2 as [smv_arg2 idx1 sb2].
      destruct (smv_arg2) as [sv2| | | | | ]; try discriminate.
      destruct sv2 as [v2| |]; try discriminate.

      rewrite -> eq_maxidx in eval_arg1.
      rewrite -> eq_maxidx in eval_arg2.
      unfold eval_sstack_val' in eval_arg2.
      rewrite -> Hfollow_arg2 in eval_arg2.
      
      unfold eval_sstack_val' in eval_arg1.
      fold eval_sstack_val' in eval_arg1.
      rewrite -> Hfollow_arg1 in eval_arg1.
      rewrite -> evm_stack_opm_ADD in eval_arg1.
      rewrite -> length_two in eval_arg1.
      unfold map_option in eval_arg1.

      destruct (eval_sstack_val' idx arg11 stk mem strg exts idx' sb' evm_stack_opm) 
        as [v11v|] eqn: eval_arg11; try discriminate.
      destruct (eval_sstack_val' idx arg12 stk mem strg exts idx' sb' evm_stack_opm)
        as [v12|] eqn: eval_arg12; try discriminate.
      injection eval_arg1 as eq_varg1.
      rewrite <- eq_varg1.

      unfold eval_sstack_val.
      simpl.
      rewrite -> PeanoNat.Nat.eqb_refl.
      simpl.
      rewrite -> eq_maxidx.
      rewrite -> eval_sstack_val'_const.

      injection is_add_const_arg1 as eq_c1 eq_x.
      rewrite <- eq_x.
      pose proof (follow_suffix sb arg1 idx (SymOp ADD [arg11; arg12]) idx' sb'
        Hfollow_arg1) as Hfollow.
      destruct Hfollow as [prefix sb_prefix].
      rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_arg12.
      pose proof (eval_sstack_val'_extend_sb instk_height idx stk mem strg exts idx sb
        sb' evm_stack_opm prefix Hvalid_bindings_sb sb_prefix arg12 v12 eval_arg12)
        as Heval_arg12.
      apply eval_sstack_val'_preserved_when_depth_extended in Heval_arg12.
      rewrite -> Heval_arg12.

      injection is_const_arg11 as eq_c1'.
      rewrite <- eq_c1.
      rewrite <- eq_c1'.
      injection eval_arg2 as eq_varg2.
      rewrite <- eq_varg2.
      injection is_const_arg2 as eq_c2.
      rewrite <- eq_c2.

      apply eval_sstack_val'_preserved_when_depth_extended in eval_arg11.
      apply eval'_maxidx_indep with (m:=idx) in eval_arg11.
      unfold eval_sstack_val' in eval_arg11.
      rewrite Hfollow_arg11 in eval_arg11.
      injection eval_arg11 as eq_v11.
      rewrite <- eq_v11.
      simpl.
      rewrite <- evm_add_step with (exts:=exts).
      rewrite <- evm_add_step with (exts:=exts).
      rewrite <- evm_add_step with (exts:=exts).
      rewrite <- evm_add_step with (exts:=exts).
      rewrite -> evm_add_assoc.
      rewrite -> evm_add_assoc.
      rewrite -> add_comm with (a:=v2)(b:=v12).
      reflexivity.

    * (* ADD(ADD(X, c1), c2) *)
      unfold is_const in is_add_const_arg1.
      destruct (follow_in_smap arg12 idx sb') as [fsmv12|] eqn: Hfollow_arg12;
        try discriminate.
      destruct fsmv12 as [smv_v12 idx'' sb''].
      destruct (smv_v12) as [sv12| | | | | ]; try discriminate.
      destruct sv12 as [v12| |]; try discriminate.

      unfold valid_bindings in Hvalid.
      destruct Hvalid as [eq_maxidx [Hvalid_smap_value Hvalid_bindings_sb]].
      fold valid_bindings in Hvalid_bindings_sb.

      unfold is_const in is_const_arg2.
      destruct (follow_in_smap arg2 idx sb) as [fsmv2|] eqn: Hfollow_arg2;
        try discriminate.
      destruct fsmv2 as [smv_arg2 idx1 sb2].
      destruct (smv_arg2) as [sv2| | | | | ]; try discriminate.
      destruct sv2 as [v2| |]; try discriminate.

      rewrite -> eq_maxidx in eval_arg1.
      rewrite -> eq_maxidx in eval_arg2.
      unfold eval_sstack_val' in eval_arg2.
      rewrite -> Hfollow_arg2 in eval_arg2.
     
      unfold eval_sstack_val' in eval_arg1.
      fold eval_sstack_val' in eval_arg1.
      rewrite -> Hfollow_arg1 in eval_arg1.
      rewrite -> evm_stack_opm_ADD in eval_arg1.
      rewrite -> length_two in eval_arg1.
      unfold map_option in eval_arg1.

      destruct (eval_sstack_val' idx arg11 stk mem strg exts idx' sb' evm_stack_opm) 
        as [v11|] eqn: eval_arg11; try discriminate.
      destruct (eval_sstack_val' idx arg12 stk mem strg exts idx' sb' evm_stack_opm)
        as [v12v|] eqn: eval_arg12; try discriminate.
      injection eval_arg1 as eq_varg1.
      rewrite <- eq_varg1.

      unfold eval_sstack_val.
      simpl.
      rewrite -> PeanoNat.Nat.eqb_refl.
      simpl.
      rewrite -> eq_maxidx.
      rewrite -> eval_sstack_val'_const.

      injection is_add_const_arg1 as eq_c1 eq_x.
      rewrite <- eq_x.
      pose proof (follow_suffix sb arg1 idx (SymOp ADD [arg11; arg12]) idx' sb'
        Hfollow_arg1) as Hfollow.
      destruct Hfollow as [prefix sb_prefix].
      rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eval_arg11.
      pose proof (eval_sstack_val'_extend_sb instk_height idx stk mem strg exts idx sb
        sb' evm_stack_opm prefix Hvalid_bindings_sb sb_prefix arg11 v11 eval_arg11)
        as Heval_arg11.
      apply eval_sstack_val'_preserved_when_depth_extended in Heval_arg11.
      rewrite -> Heval_arg11.

      rewrite <- eq_c1.
      injection eval_arg2 as eq_varg2.
      rewrite <- eq_varg2.
      injection is_const_arg2 as eq_c2.
      rewrite <- eq_c2.

      apply eval_sstack_val'_preserved_when_depth_extended in eval_arg12.
      apply eval'_maxidx_indep with (m:=idx) in eval_arg12.
      unfold eval_sstack_val' in eval_arg12.
      rewrite Hfollow_arg12 in eval_arg12.
      injection eval_arg12 as eq_v12.
      rewrite <- eq_v12.
      simpl.
      rewrite <- evm_add_step with (exts:=exts).
      rewrite <- evm_add_step with (exts:=exts).
      rewrite <- evm_add_step with (exts:=exts).
      rewrite <- evm_add_step with (exts:=exts).
      rewrite -> evm_add_assoc.
      rewrite -> add_comm with (a:=v11)(b:=v12).
      rewrite -> evm_add_assoc.
      rewrite -> add_comm with (a:=v11)(b:=v2). 
      reflexivity.
Qed.      


End Opt_add_add_const.


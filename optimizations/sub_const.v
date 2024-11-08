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

(* For debugging with print_id *)
(* From ReductionEffect Require Import PrintingEffect. *)


Module Opt_sub_const.


(* 
  SUB(X, A) = ADD(X, -A)
*)
Definition optimize_sub_const_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp SUB [arg1;arg2] =>
  match follow_to_val arg2 maxid sb with
  | Some v => 
      let negv := wminus WZero v in
      (SymOp ADD [arg1; (Val negv)], true)   
  | _ => (val, false)
  end
| _ => (val, false)
end.  


Lemma evm_sub_add: forall (exts: externals) (x y: EVMWord),
evm_sub exts [x; y] = evm_add exts [x; wneg y].
Proof.
intros.
unfold evm_sub. unfold evm_add.
apply wminus_def.
Qed.


Lemma wminus_wneg: forall x, wminus WZero x = wneg x.
Proof.
intros.
rewrite -> wminus_def.
apply wzero_wplus.
Qed.


Lemma optimize_sub_const_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_sub_const_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros _ Hvalid_smapv_val Hvalid Hoptm_sbinding.
unfold optimize_sub_const_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try try inject_rw Hoptm_sbinding eq_val'.
destruct args as [|arg1 r1]; try inject_rw Hoptm_sbinding eq_val'.
destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
destruct r2 as [|arg3 r3]; try inject_rw Hoptm_sbinding eq_val'.
destruct (follow_to_val arg2 n sb) as [v|] eqn: eq_follow_to_val_arg2;
  try inject_rw Hoptm_sbinding eq_val'.
injection Hoptm_sbinding as eq_val' _.
rewrite <- eq_val'.
simpl in Hvalid_smapv_val.
simpl.
unfold valid_stack_op_instr in Hvalid_smapv_val.
simpl in Hvalid_smapv_val.
destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
unfold valid_stack_op_instr.
simpl.
intuition.
Qed.


Lemma optimize_sub_const_sbinding_snd:
opt_sbinding_snd optimize_sub_const_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_sub_const_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_sub_const_sbinding_smapv_valid. 

- (* evaluation is preserved *) 
  intros stk mem strg exts v Hlen Heval_orig.
  unfold optimize_sub_const_sbinding in Hoptm_sbinding.
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymOp label args *)
  destruct label eqn: eq_label; try inject_rw Hoptm_sbinding eq_val'.
  destruct args as [|arg1 r1] eqn: eq_args; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r2; try inject_rw Hoptm_sbinding eq_val'.
  destruct (follow_to_val arg2 idx sb) as [varg2|] eqn: eq_follow_to_val_arg2;
    try inject_rw Hoptm_sbinding eq_val'.
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
  
  unfold eval_sstack_val in Heval_orig.
  simpl in Heval_orig.
  rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
  simpl in Heval_orig.
  destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb 
    evm_stack_opm) as [arg1v|] eqn: eq_eval_arg1; try discriminate.
  destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb 
    evm_stack_opm) as [arg2v|] eqn: eq_eval_arg2; try discriminate.
  injection Heval_orig as eq_v.
  rewrite <- eq_v.

  unfold eval_sstack_val.
  simpl.
  rewrite -> PeanoNat.Nat.eqb_refl.
  simpl.
  rewrite -> eq_eval_arg1.

  unfold valid_bindings in Hvalid.
  destruct Hvalid as [eq_maxidx [Hvalid_and Hvalid_sb]].
  fold valid_bindings in Hvalid_sb.
  rewrite -> eq_maxidx.
  rewrite -> eval_sstack_val'_const.
  rewrite <- evm_minus_step with (exts:=exts).
  rewrite <- evm_minus_step with (exts:=exts).
  rewrite -> evm_minus_step with (exts:=exts).
  rewrite -> wminus_wneg.
  rewrite <- evm_sub_add.

  unfold follow_to_val in eq_follow_to_val_arg2.
  destruct (follow_in_smap arg2 idx sb) as [fsmv|] eqn: eq_follow_arg2;
    try discriminate.
  destruct fsmv as [smv idx' sb'].
  destruct smv as [vv|_2|_3|_4|_5|_6]; try discriminate.
  destruct vv as [vv'| |]; try discriminate.

  rewrite -> eq_maxidx in eq_eval_arg2.
  simpl in eq_eval_arg2.
  rewrite -> eq_follow_arg2 in eq_eval_arg2.
  injection eq_follow_to_val_arg2 as eq_varg2.
  rewrite -> eq_varg2 in eq_follow_arg2.
  injection eq_eval_arg2 as eq_arg2v.
  rewrite <- eq_arg2v.
  rewrite <- eq_varg2.

  reflexivity.
Qed.  


End Opt_sub_const.

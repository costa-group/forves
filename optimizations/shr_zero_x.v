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


Module Opt_shr_zero_x.


(* SHR(0, X) = X *)
Definition optimize_shr_zero_x_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp SHR [zero; x] => 
  if fcmp zero (Val WZero) maxid sb maxid sb instk_height ops then 
    (SymBasicVal x, true)
  else
    (val, false)
| _ => (val, false)
end.


(* For optimization SHR(0,X) = X *)
Lemma shr_zero_x_equiv: forall x,
wdiv x (wlshift WOne (wordToNat WZero)) = x.
Proof.
intros x. simpl. rewrite -> wlshift_0.
unfold wdiv. unfold wordBin. simpl.
rewrite -> N.div_1_r. simpl.
rewrite -> NToWord_wordToN.
reflexivity.
Qed.


Lemma shr_zero_x_equiv': forall x,
wdiv x (wlshift' WOne (wordToNat WZero)) = x.
Proof.
intros x. 
rewrite -> wlshift_alt.
apply shr_zero_x_equiv.
Qed.


Lemma optimize_shr_zero_x_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_shr_zero_x_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros _ Hvalid_smapv_val Hvalid Hoptm_sbinding.
unfold optimize_shr_zero_x_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try try inject_rw Hoptm_sbinding eq_val'.
destruct args as [|zero r1]; try inject_rw Hoptm_sbinding eq_val'.
destruct r1 as [|x r2]; try inject_rw Hoptm_sbinding eq_val'.
destruct r2; try inject_rw Hoptm_sbinding eq_val'.
destruct (fcmp zero (Val WZero) n sb n sb instk_height evm_stack_opm) 
  eqn: fcmp_zero_WZero; try inject_rw Hoptm_sbinding eq_val'.
injection Hoptm_sbinding as eq_val' _.
rewrite <- eq_val'.
simpl. 
unfold valid_smap_value in Hvalid_smapv_val.
unfold valid_stack_op_instr in Hvalid_smapv_val.
simpl in Hvalid_smapv_val.
intuition.
Qed.


Lemma optimize_shr_zero_x_sbinding_snd:
opt_sbinding_snd optimize_shr_zero_x_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_shr_zero_x_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_shr_zero_x_sbinding_smapv_valid. 

- (* evaluation is preserved *) 
  intros stk mem strg ctx v Hlen Heval_orig.
  unfold optimize_shr_zero_x_sbinding in Hoptm_sbinding.
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymOp label args *)
  destruct label eqn: eq_label; try inject_rw Hoptm_sbinding eq_val'.
  destruct args as [|zero r1] eqn: eq_args; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct r1 as [|x r2]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r2; try inject_rw Hoptm_sbinding eq_val'.
  destruct (fcmp zero (Val WZero) idx sb idx sb instk_height evm_stack_opm)
    eqn: fcmp_zero_WZero; try inject_rw Hoptm_sbinding eq_val'.
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
      
  unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
  rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
  simpl in Heval_orig.
  destruct (eval_sstack_val' maxidx zero stk mem strg ctx idx sb 
    evm_stack_opm) as [arg1v|] eqn: eval_arg1; try discriminate.
  destruct (eval_sstack_val' maxidx x stk mem strg ctx idx sb
    evm_stack_opm) as [arg2v|] eqn: eval_arg2; try discriminate.
  rewrite <- Heval_orig. simpl.
  unfold eval_sstack_val.
  rewrite <- eval_sstack_val'_freshvar.
  apply eval_sstack_val'_preserved_when_depth_extended in eval_arg2.
  rewrite -> eval'_maxidx_indep_eq with (m:=maxidx) in eval_arg2.
  rewrite -> eval_arg2.
  
  simpl in Hvalid. 
  destruct Hvalid as [eq_maxid [Hvalid_smap_value Hvalid_bindings_sb]].
  unfold valid_smap_value in Hvalid_smap_value.
  unfold valid_stack_op_instr in Hvalid_smap_value.
  simpl in Hvalid_smap_value.
  destruct Hvalid_smap_value as [_ [Hvalid_arg1 [Hvalid_arg2 _ ]]].
  pose proof (valid_sstack_value_const instk_height idx WZero) as valid_WZero.
  symmetry in Hlen.
  pose proof (Hsafe_sstack_val_cmp zero (Val WZero) idx sb idx sb instk_height
    evm_stack_opm Hvalid_arg1 valid_WZero Hvalid_bindings_sb 
    Hvalid_bindings_sb fcmp_zero_WZero stk mem strg ctx Hlen)
    as [vv [eval_zero eval_wzero]].
  unfold eval_sstack_val in eval_zero.
  unfold eval_sstack_val in eval_wzero.
  rewrite -> eval_sstack_val'_const in eval_wzero.
  rewrite <- eval_wzero in eval_zero.
  rewrite <- eq_maxid in eval_zero.
  rewrite -> eval_zero in eval_arg1.
  injection eval_arg1 as eq_arg1v.
  rewrite <- eq_arg1v.
  rewrite -> shr_zero_x_equiv'. 
  reflexivity.
Qed.


End Opt_shr_zero_x.

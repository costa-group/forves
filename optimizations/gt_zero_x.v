Require Import bbv.Word.
Require Import Nat. 
Require Import Coq.NArith.NArith.

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


Module Opt_gt_zero_x.


(* GT(0,X) = 0 *)
Definition optimize_gt_zero_x_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp GT [arg1; arg2] => 
  if fcmp arg1 (Val WZero) maxid sb maxid sb instk_height ops then
     (SymBasicVal (Val WZero), true)
  else
    (val, false)
| _ => (val, false)
end.






Lemma optimize_gt_zero_x_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_gt_zero_x_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros _ Hvalid_smapv_val Hvalid_sb Hoptm_sbinding.
unfold optimize_gt_zero_x_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try inject_rw Hoptm_sbinding eq_val'.
(* GT *)
destruct args as [|arg1 r1] eqn: eq_args; try 
  (injection Hoptm_sbinding as eq_val' eq_flag;
  rewrite <- eq_val'; assumption).
destruct r1 as [|arg2 r2] eqn: eq_r1; try 
  (injection Hoptm_sbinding as eq_val' eq_flag;
  rewrite <- eq_val'; assumption).
destruct r2 as [|arg3 r3] eqn: eq_r2; try 
  (injection Hoptm_sbinding as eq_val' eq_flag;
  rewrite <- eq_val'; assumption).
destruct (fcmp arg1 (Val WZero) n sb n sb instk_height evm_stack_opm)
  eqn: eq_fcmp_arg1; try inject_rw Hoptm_sbinding eq_val'.
injection Hoptm_sbinding as eq_val' eq_flag.
rewrite <- eq_val'.
simpl. intuition.
Qed.




Lemma gt_zero_x_zero: forall (x: EVMWord) exts,
evm_gt exts [WZero; x] = WZero.
Proof.
intros. simpl. 
destruct ((wordToN x) <? 0)%N eqn: eq_x_lt_zero.
- apply N.ltb_lt in eq_x_lt_zero. 
  pose proof (N.nlt_0_r (wordToN x)) as H.
  contradiction.
- reflexivity.
Qed.


Lemma optimize_gt_zero_x_sbinding_snd:
opt_sbinding_snd optimize_gt_zero_x_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_gt_zero_x_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_gt_zero_x_sbinding_smapv_valid. 
    
- (* evaluation is preserved *) 
  intros stk mem strg exts v Hlen Heval_orig.
  assert (Hlen2 := Hlen).
  rewrite -> Hlen in Hlen2.
  rewrite <- Hlen in Hlen2 at 2.
  unfold optimize_gt_zero_x_sbinding in Hoptm_sbinding.
  pose proof (Hvalid_maxidx instk_height maxidx idx val sb evm_stack_opm
      Hvalid) as eq_maxidx_idx.
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymOp label args *)
  destruct label; try inject_rw Hoptm_sbinding eq_val'.
  destruct args as [|arg1 r1] eqn: eq_args; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct r1 as [|arg2 r2] eqn: eq_r1; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct r2 as [|arg3 r3] eqn: eq_r2; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct (fcmp arg1 (Val WZero) idx sb idx sb instk_height) 
    eqn: fcmp_arg1_zero; try inject_rw Hoptm_sbinding eq_val'.
  (* arg2 ~ WZero *)
  injection Hoptm_sbinding as eq_val' _. 
  rewrite <- eq_val'.
  unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
  rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
  simpl in Heval_orig.
  destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb evm_stack_opm)
    as [varg1|] eqn: eval_arg1; try discriminate.
  destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb evm_stack_opm)
    as [varg2|] eqn: eval_arg2; try discriminate.

  unfold valid_bindings in Hvalid.
  destruct Hvalid as [eq_maxid [Hvalid_smap_value Hvalid_bindings_sb]].
  unfold valid_smap_value in Hvalid_smap_value.
  unfold valid_stack_op_instr in Hvalid_smap_value.
  simpl in Hvalid_smap_value.
  destruct (Hvalid_smap_value) as [_ [Hvalid_arg1 [Hvalid_arg2 _ ]]].
  fold valid_bindings in Hvalid_bindings_sb.

  pose proof (valid_sstack_value_const instk_height idx v) as Hvalid_zero.
  pose proof (Hsafe_sstack_val_cmp arg1 (Val WZero) idx sb idx sb 
    instk_height evm_stack_opm Hvalid_arg1 Hvalid_zero Hvalid_bindings_sb
    Hvalid_bindings_sb fcmp_arg1_zero stk mem strg exts Hlen2)
    as [vzero [Heval_arg1 Heval_vzero]].
  rewrite -> eval_sstack_val_const in Heval_vzero.
  rewrite <- Heval_vzero in Heval_arg1.
    
  unfold eval_sstack_val in Heval_arg1.
  rewrite -> eq_maxidx_idx in Heval_arg1.
  rewrite -> Heval_arg1 in eval_arg1.
  injection eval_arg1 as eq_varg1.
  rewrite <- eq_varg1 in Heval_orig.
  rewrite -> gt_zero_x_zero in Heval_orig.
  rewrite <- Heval_orig.

  unfold eval_sstack_val.
  simpl.
  rewrite -> PeanoNat.Nat.eqb_refl. simpl.
  reflexivity.
Qed.


End Opt_gt_zero_x.

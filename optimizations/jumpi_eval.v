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


Module Opt_jumpi_eval.


(* 
JUMPI(Dest,B) = 0    if B is constant and B = 0 
JUMPI(Dest,B) = Dest if B is constant and B <> 0
*)
Definition optimize_jumpi_eval_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp JUMPI [arg1; arg2] => 
  match follow_in_smap arg2 maxid sb with
  | Some (FollowSmapVal (SymBasicVal (Val v)) _ _) => 
      if weqb v WZero 
      then (SymBasicVal (Val WZero), true)
      else (SymBasicVal arg1, true)
  | _ => (val, false)
  end
| _ => (val, false)
end.






Lemma optimize_jumpi_eval_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_jumpi_eval_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros _ Hvalid_smapv_val Hvalid_sb Hoptm_sbinding.
unfold optimize_jumpi_eval_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
   try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try inject_rw Hoptm_sbinding eq_val'. try 
(* JUMPI *)
destruct args as [|arg1 r1] eqn: eq_args; try inject_rw Hoptm_sbinding eq_val'.
destruct r1 as [|arg2 r2] eqn: eq_r1; try inject_rw Hoptm_sbinding eq_val'.
destruct r2 as [|arg3 r3] eqn: eq_r2; try inject_rw Hoptm_sbinding eq_val'.
destruct (follow_in_smap arg2 n sb) as [fsmv|] eqn: eq_follow_arg2
  ; try inject_rw Hoptm_sbinding eq_val'.
destruct fsmv as [smv] eqn: eq_fsmv; try inject_rw Hoptm_sbinding eq_val'.
destruct smv as [val2| | | | | ] eqn: eq_svm; try inject_rw Hoptm_sbinding eq_val'.  
destruct val2 as [v2| | ] eqn: eq_val2; try inject_rw Hoptm_sbinding eq_val'.
destruct (weqb v2 WZero) eqn: eq_v2_wzero.
* injection Hoptm_sbinding as eq_val' eq_flag.
  rewrite <- eq_val'.
  simpl.
  intuition.
* injection Hoptm_sbinding as eq_val' eq_flag.
  rewrite <- eq_val'.
  simpl in Hvalid_smapv_val. unfold valid_stack_op_instr in Hvalid_smapv_val.
  simpl in Hvalid_smapv_val.
  destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
  simpl.
  assumption.
Qed.


Lemma evm_jumpi_zero: forall exts a b,
weqb b WZero = true ->
evm_jumpi exts [a; b] = WZero.
Proof.
intros exts a b Hb_z. simpl.
rewrite -> Hb_z.
reflexivity.
Qed.


Lemma evm_jumpi_not_zero: forall exts a b,
weqb b WZero = false ->
evm_jumpi exts [a; b] = a.
Proof.
intros exts a b Hb_not_z. simpl.
rewrite -> Hb_not_z.
reflexivity.
Qed.


Lemma optimize_jumpi_eval_sbinding_snd:
opt_sbinding_snd optimize_jumpi_eval_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_jumpi_eval_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_jumpi_eval_sbinding_smapv_valid. 
    
- (* evaluation is preserved *) 
  intros stk mem strg exts v Hlen Heval_orig.
  assert (Hlen2 := Hlen).
  rewrite -> Hlen in Hlen2.
  rewrite <- Hlen in Hlen2 at 2.
  unfold optimize_jumpi_eval_sbinding in Hoptm_sbinding.
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
  destruct (follow_in_smap arg2 idx sb) as [fsmv|] eqn: eq_follow_arg2; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct fsmv as [smv] eqn: eq_fsmv; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct smv as [val2| | | | | ] eqn: eq_svm; try inject_rw Hoptm_sbinding eq_val'.  
  destruct val2 as [v2| | ] eqn: eq_val2; try inject_rw Hoptm_sbinding eq_val'.
  destruct (weqb v2 WZero) eqn: eq_v2_wzero.
  * injection Hoptm_sbinding as eq_val' _. 
    rewrite <- eq_val'.
    unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
    rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
    simpl in Heval_orig.
    destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb evm_stack_opm)
      as [varg1|] eqn: eval_arg1; try discriminate.
    destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb evm_stack_opm)
      as [varg2|] eqn: eval_arg2; try discriminate.

    rewrite <- eq_maxidx_idx in eval_arg2.
    simpl in eval_arg2.
    rewrite -> eq_follow_arg2 in eval_arg2.
    injection eval_arg2 as eq_v2.
    rewrite <- eq_v2 in Heval_orig.
    unfold evm_jumpi in Heval_orig.
    rewrite -> eq_v2_wzero in Heval_orig.
    rewrite <- Heval_orig.
 
    unfold eval_sstack_val.
    rewrite <- eval_sstack_val'_freshvar.
    rewrite -> eval_sstack_val'_const.
    reflexivity.
* injection Hoptm_sbinding as eq_val' _. 
  rewrite <- eq_val'.
  unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
  rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
  simpl in Heval_orig.
  destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb evm_stack_opm)
    as [varg1|] eqn: eval_arg1; try discriminate.
  destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb evm_stack_opm)
    as [varg2|] eqn: eval_arg2; try discriminate.

  rewrite <- eq_maxidx_idx in eval_arg2.
  simpl in eval_arg2.
  rewrite -> eq_follow_arg2 in eval_arg2.
  injection eval_arg2 as eq_v2.
  rewrite <- eq_v2 in Heval_orig.
  unfold evm_jumpi in Heval_orig.
  rewrite -> eq_v2_wzero in Heval_orig.
  rewrite <- Heval_orig.

  unfold eval_sstack_val.
  rewrite <- eval_sstack_val'_freshvar.
  rewrite -> eval'_maxidx_indep_eq with (m:=idx).
  apply eval_sstack_val'_preserved_when_depth_extended in eval_arg1.
  rewrite -> eval_arg1.
  reflexivity.
Qed.

End Opt_jumpi_eval.

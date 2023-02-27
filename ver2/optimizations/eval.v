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


Module Opt_eval.


(* EVAL *)
Definition optimize_eval_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp op args => 
  match follow_to_val_args args maxid sb with
  | Some vargs => 
    match ops op with
    | OpImp nargs f Hcomm Hctx_indep => 
      match Hctx_indep with
      | Some _ => if (List.length args =? nargs) then
                    (SymBasicVal (Val (f empty_context vargs)), true)
                  else 
                    (val, false)
      | None => (val, false)
      end
    end
  | None => (val, false)
  end
| _ => (val, false)
end.






Lemma optimize_eval_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_eval_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n ops fcmp sb val val' flag.
intros Hvalid_smapv_val Hvalid_sb Hoptm_sbinding.
unfold optimize_eval_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; try (
    injection Hoptm_sbinding as eq_val' _;
    rewrite <- eq_val';
    assumption).
(* SymOp label args *)
destruct (follow_to_val_args args n sb) as [vargs|] eqn: eq_follow; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct (ops label) as [nargs f Hcomm Hctx_indep] eqn: eq_ops_label; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct (Hctx_indep) as [H|]; try inject_rw Hoptm_sbinding eq_val'.
destruct (length args =? nargs); try inject_rw Hoptm_sbinding eq_val'.
injection Hoptm_sbinding as eq_val' _.
rewrite <- eq_val'.
simpl. intuition.
Qed.


Lemma optimize_eval_sbinding_snd:
opt_sbinding_snd optimize_eval_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_eval_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_eval_sbinding_smapv_valid. 
    
- (* evaluation is preserved *) 
  intros stk mem strg ctx v Hlen Heval_orig.
  (*assert (Hlen2 := Hlen).
  rewrite -> Hlen in Hlen2.
  rewrite <- Hlen in Hlen2 at 2.*)
  unfold optimize_eval_sbinding in Hoptm_sbinding.
  (*pose proof (Hvalid_maxidx instk_height maxidx idx val sb evm_stack_opm
      Hvalid) as eq_maxidx_idx.*)
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymOp label args *)
  destruct (follow_to_val_args args idx sb) as [vargs|] eqn: eq_follow; 
  try inject_rw Hoptm_sbinding eq_val'.
  destruct (evm_stack_opm label) as [nargs f Hcomm Hctx_indep] 
    eqn: eq_ops_label; try inject_rw Hoptm_sbinding eq_val'.
  destruct (Hctx_indep) as [H|] eqn: eq_Hctx; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct (length args =? nargs) eqn: eq_len; 
    try inject_rw Hoptm_sbinding eq_val'.
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.
  unfold eval_sstack_val. simpl.
  rewrite -> PeanoNat.Nat.eqb_refl.
  unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
  rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
  rewrite -> eq_ops_label in Heval_orig.
  rewrite -> eq_len in Heval_orig.
  destruct (map_option
                 (fun sv' : sstack_val =>
                  eval_sstack_val' maxidx sv' stk mem strg ctx idx sb
                    evm_stack_opm) args) as [vargs'|] eqn: eq_mapo;
    try discriminate.
  pose proof (follow_to_val_args_eval_eq args idx sb vargs maxidx stk mem 
    strg ctx vargs' eq_follow eq_mapo) as eq_vargs'.
  rewrite <- eq_vargs' in Heval_orig.
  rewrite -> H with (ctx2:=ctx).
  assumption.
Qed.


End Opt_eval.

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


Module Opt_balance_address.


(* BALANCE(ADDRESS) = SELFBALANCE *)
Definition optimize_balance_address_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp BALANCE [arg1] => 
  match follow_in_smap arg1 maxid sb with 
  | Some (FollowSmapVal (SymOp ADDRESS []) idx' sb') => 
       (SymOp SELFBALANCE [], true)
  | _ => (val, false)
  end
| _ => (val, false)
end.



Lemma optimize_balance_address_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_balance_address_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros Hvalid_smapv_val Hvalid_sb Hoptm_sbinding.
unfold optimize_balance_address_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try inject_rw Hoptm_sbinding eq_val'.
(* BALANCE *)
destruct args as [|arg1 r1] eqn: eq_args; try 
  (injection Hoptm_sbinding as eq_val' eq_flag;
  rewrite <- eq_val'; assumption).
destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
destruct (follow_in_smap arg1 n sb) as [fsmv_arg1|] eqn: eq_follow_arg1;
  try inject_rw Hoptm_sbinding eq_val'.
destruct fsmv_arg1 as [smv_arg1 idx' sb'].
destruct smv_arg1 as [x1|x2|label1 args1|x4|x5|x6]; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct label1; try inject_rw Hoptm_sbinding eq_val'.
destruct args1;  try inject_rw Hoptm_sbinding eq_val'.

injection Hoptm_sbinding as eq_val' eq_flag.
rewrite <- eq_val'.
unfold valid_smap_value.
unfold valid_stack_op_instr.
simpl.
intuition.
Qed.


Lemma balance_address: forall ctx,
evm_balance ctx [evm_address ctx []] = evm_selfbalance ctx [].
Proof.
intros ctx.
unfold evm_address. unfold evm_balance.
unfold evm_selfbalance.
rewrite zext_split1.
reflexivity.
Qed.


Lemma optimize_balance_address_sbinding_snd:
opt_sbinding_snd optimize_balance_address_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_balance_address_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_balance_address_sbinding_smapv_valid. 
    
- (* evaluation is preserved *) 
  intros stk mem strg ctx v Hlen Heval_orig.
  (*assert (Hlen2 := Hlen).
  rewrite -> Hlen in Hlen2.
  rewrite <- Hlen in Hlen2 at 2.*)
  unfold optimize_balance_address_sbinding in Hoptm_sbinding.
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymOp label args *)
  destruct label; try inject_rw Hoptm_sbinding eq_val'.
  destruct args as [|arg1 r1]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
  destruct (follow_in_smap arg1 idx sb) as [fsmv_arg1|] eqn: eq_follow_arg1;
    try inject_rw Hoptm_sbinding eq_val'.
  destruct fsmv_arg1 as [smv_arg1 idx' sb'].
  destruct smv_arg1 as [x1|x2|label1 args1|x4|x5|x6]; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct label1; try inject_rw Hoptm_sbinding eq_val'.
  destruct args1;  try inject_rw Hoptm_sbinding eq_val'.
 
  injection Hoptm_sbinding as eq_val' _. 
  rewrite <- eq_val'.
  unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
  rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
  simpl in Heval_orig.
  destruct (eval_sstack_val' maxidx arg1 stk mem strg ctx idx sb evm_stack_opm)
    as [varg1|] eqn: eval_arg1; try discriminate.
  rewrite <- Heval_orig.
  
  destruct maxidx as [|maxidx'] eqn: eq_maxidx; try discriminate.
  simpl in eval_arg1.
  rewrite -> eq_follow_arg1 in eval_arg1.
  simpl in eval_arg1.
  injection eval_arg1 as eq_varg1.
  rewrite <- eq_varg1.
  
  (* simpl was extremely slow, so I've evaluated the call step-by-step
     manually *)
  unfold eval_sstack_val. unfold eval_sstack_val'.
  rewrite -> follow_in_smap_head_op.
  rewrite -> evm_stack_opm_SELFBALANCE.
  rewrite -> length_zero.
  rewrite -> map_option_empty.
  rewrite -> balance_address.
  reflexivity.
Qed.


End Opt_balance_address.

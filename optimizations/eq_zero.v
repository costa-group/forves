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


Module Opt_eq_zero.


(* EQ(X,0) = ISZERO(X)
   EQ(0,X) = ISZERO(X) *)
Definition optimize_eq_zero_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp EQ [arg1; arg2] => 
  if fcmp arg1 (Val WZero) maxid sb maxid sb instk_height ops then
    (SymOp ISZERO [arg2], true)
  else if fcmp arg2 (Val WZero) maxid sb maxid sb instk_height ops then
    (SymOp ISZERO [arg1], true)
  else
    (val, false)
| _ => (val, false)
end.


Lemma eq_zero_iszero1: forall (x: EVMWord) exts,
evm_eq exts [WZero; x] = evm_iszero exts [x].
Proof.
intros. unfold evm_iszero. 
rewrite -> eq_comm. reflexivity.
Qed.

Lemma eq_zero_iszero2: forall (x: EVMWord) exts,
evm_eq exts [x; WZero] = evm_iszero exts [x].
Proof.
intros. unfold evm_iszero. 
rewrite -> eq_comm. reflexivity.
Qed.




Lemma optimize_eq_zero_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_eq_zero_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros _ Hvalid_smapv_val Hvalid_sb Hoptm_eq_zero_sbinding.
unfold optimize_eq_zero_sbinding in Hoptm_eq_zero_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val.
+ injection Hoptm_eq_zero_sbinding as eq_val' eq_flag.
  rewrite <- eq_val'.
  assumption.
+ injection Hoptm_eq_zero_sbinding as eq_val' eq_flag.
  rewrite <- eq_val'.
  assumption.
+ destruct label eqn: eq_label; try 
      (injection Hoptm_eq_zero_sbinding as eq_val' eq_flag;
      rewrite <- eq_val'; assumption).
  (* ADD *)
  destruct args as [|arg1 r1] eqn: eq_args; try 
    (injection Hoptm_eq_zero_sbinding as eq_val' eq_flag;
    rewrite <- eq_val'; assumption).
  destruct r1 as [|arg2 r2] eqn: eq_r1; try 
    (injection Hoptm_eq_zero_sbinding as eq_val' eq_flag;
    rewrite <- eq_val'; assumption).
  destruct r2; try 
    (injection Hoptm_eq_zero_sbinding as eq_val' eq_flag;
    rewrite <- eq_val'; assumption).
  destruct (fcmp arg1 (Val WZero) n sb n sb instk_height evm_stack_opm)
    eqn: eq_fcmp_arg1.
  * injection Hoptm_eq_zero_sbinding as eq_val' eq_flag.
    rewrite <- eq_val'.
    simpl in Hvalid_smapv_val. unfold valid_stack_op_instr in Hvalid_smapv_val.
    simpl in Hvalid_smapv_val.
    destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
    simpl. unfold valid_stack_op_instr. simpl.
    intuition.
  * destruct (fcmp arg2 (Val WZero) n sb n sb instk_height evm_stack_opm) 
      eqn: eq_fcmp_arg2; try (injection Hoptm_eq_zero_sbinding as eq_val' eq_flag;
      rewrite <- eq_val'; assumption).
    injection Hoptm_eq_zero_sbinding as eq_val' eq_flag.
    rewrite <- eq_val'.
    simpl in Hvalid_smapv_val. unfold valid_stack_op_instr in Hvalid_smapv_val.
    simpl in Hvalid_smapv_val.
    destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
    simpl. unfold valid_stack_op_instr. simpl.
    intuition.
  + injection Hoptm_eq_zero_sbinding as eq_val' eq_flag.
    rewrite <- eq_val'.
    assumption.
  + injection Hoptm_eq_zero_sbinding as eq_val' eq_flag.
    rewrite <- eq_val'.
    assumption.
  + injection Hoptm_eq_zero_sbinding as eq_val' eq_flag.
    rewrite <- eq_val'.
    assumption.
Qed.


Lemma optimize_eq_zero_sbinding_snd:
opt_sbinding_snd optimize_eq_zero_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_eq_zero_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_eq_zero_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_eq_zero_sbinding_smapv_valid. 
    
- (* evaluation is preserved *) 
  intros stk mem strg exts v Hlen Heval_orig.
  assert (Hlen2 := Hlen).
  rewrite -> Hlen in Hlen2.
  rewrite <- Hlen in Hlen2 at 2.
  unfold optimize_eq_zero_sbinding in Hoptm_eq_zero_sbinding.
  pose proof (Hvalid_maxidx instk_height maxidx idx val sb evm_stack_opm
      Hvalid) as eq_maxidx_idx.
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_eq_zero_sbinding eq_val'.
  (* SymOp label args *)
  destruct label; try inject_rw Hoptm_eq_zero_sbinding eq_val'.
  destruct args as [|arg1 r1] eqn: eq_args; 
    try inject_rw Hoptm_eq_zero_sbinding eq_val'.
  destruct r1 as [|arg2 r2] eqn: eq_r1; 
    try inject_rw Hoptm_eq_zero_sbinding eq_val'.
  destruct r2; try inject_rw Hoptm_eq_zero_sbinding eq_val'.
  destruct (fcmp arg1 (Val WZero) idx sb idx sb instk_height) 
    eqn: fcmp_arg1_zero.
  + (* arg1 ~ WZero *)
    injection Hoptm_eq_zero_sbinding as eq_val' _. 
    rewrite <- eq_val'.
    unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
    rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
    simpl in Heval_orig.
    destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb evm_stack_opm)
      as [varg1|] eqn: eval_arg1; try discriminate.
    destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb evm_stack_opm)
      as [varg2|] eqn: eval_arg2; try discriminate.
    unfold safe_sstack_val_cmp in Hsafe_sstack_val_cmp.

    unfold valid_bindings in Hvalid.
    destruct Hvalid as [eq_maxid [Hvalid_smap_value Hvalid_bindings_sb]].
    unfold valid_smap_value in Hvalid_smap_value.
    unfold valid_stack_op_instr in Hvalid_smap_value.
    simpl in Hvalid_smap_value.
    destruct (Hvalid_smap_value) as [_ [Hvalid_arg1 [Hvalid_arg2 _ ]]].
    fold valid_bindings in Hvalid_bindings_sb.

    pose proof (valid_sstack_value_const instk_height idx v) as 
      Hvalid_zero.
    pose proof (Hsafe_sstack_val_cmp arg1 (Val WZero) idx sb idx sb 
      instk_height evm_stack_opm Hvalid_arg1 Hvalid_zero Hvalid_bindings_sb
      Hvalid_bindings_sb fcmp_arg1_zero stk mem strg exts Hlen2)
      as [vzero [Heval_arg1 Heval_vzero]].
    assert (Heval_arg1_copy := Heval_arg1).
    unfold eval_sstack_val in Heval_arg1_copy.
    rewrite -> eval_sstack_val_const in Heval_vzero.
    rewrite <- Heval_vzero in Heval_arg1.
    
    unfold eval_sstack_val.
    rewrite -> eq_maxid in eval_arg1.
    rewrite -> Heval_arg1_copy in eval_arg1.
    injection eval_arg1 as eq_varg1.
    injection Heval_vzero as eq_vzero.
    rewrite <- eq_varg1 in Heval_orig.
    rewrite <- eq_vzero in Heval_orig.
    simpl. rewrite -> PeanoNat.Nat.eqb_refl.
    simpl. rewrite -> eval_arg2. 
    rewrite <- Heval_orig.
    
    rewrite -> eq_zero_iszero1.
    reflexivity.

  + (* arg2 ~ WZero *)
    destruct (fcmp arg2 (Val WZero) idx sb idx sb instk_height evm_stack_opm)
      eqn: fcmp_arg2_zero; try (injection Hoptm_eq_zero_sbinding as eq_val'; 
                                rewrite <- eq_val';
                                assumption).
    injection Hoptm_eq_zero_sbinding as eq_val' _.
    rewrite <- eq_val'.
    unfold eval_sstack_val in Heval_orig.
    simpl in Heval_orig.
    rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
    simpl in Heval_orig.
    destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb 
      evm_stack_opm) as [varg1|] eqn: eval_arg1; try discriminate.
    destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb 
      evm_stack_opm) as [varg2|] eqn: eval_arg2; try discriminate.
    unfold safe_sstack_val_cmp in Hsafe_sstack_val_cmp.
      
    unfold valid_bindings in Hvalid.
    destruct Hvalid as [eq_maxid [Hvalid_smap_value Hvalid_bindings_sb]].
    unfold valid_smap_value in Hvalid_smap_value.
    unfold valid_stack_op_instr in Hvalid_smap_value.
    simpl in Hvalid_smap_value.
    destruct (Hvalid_smap_value) as [_ [Hvalid_arg1 [Hvalid_arg2 _ ]]].
    fold valid_bindings in Hvalid_bindings_sb.
      
    pose proof (valid_sstack_value_const instk_height idx v) as 
      Hvalid_zero.
    pose proof (Hsafe_sstack_val_cmp arg2 (Val WZero) idx sb idx sb 
      instk_height evm_stack_opm Hvalid_arg2 Hvalid_zero Hvalid_bindings_sb
      Hvalid_bindings_sb fcmp_arg2_zero stk mem strg exts Hlen2)
      as [vzero [Heval_arg2 Heval_vzero]].
    assert (Heval_arg2_copy := Heval_arg2).
    unfold eval_sstack_val in Heval_arg2_copy.
    rewrite -> eval_sstack_val_const in Heval_vzero.
    rewrite <- Heval_vzero in Heval_arg2.
    
    unfold eval_sstack_val.
    rewrite -> eq_maxid in eval_arg2.
    rewrite -> Heval_arg2_copy in eval_arg2.
    injection eval_arg2 as eq_varg2.
    injection Heval_vzero as eq_vzero.
    rewrite <- eq_varg2 in Heval_orig.
    rewrite <- eq_vzero in Heval_orig.
    simpl.
    simpl. rewrite -> PeanoNat.Nat.eqb_refl.
    simpl. rewrite -> eval_arg1. 
    rewrite <- Heval_orig.
    
    rewrite -> eq_zero_iszero2.
    reflexivity.
Qed.


End Opt_eq_zero.

Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import Coq.NArith.NArith.
Require Import List.
Import ListNotations.

Require Import FORVES.constants.
Import Constants.

Require Import FORVES.program.
Import Program.

Require Import FORVES.execution_state.
Import ExecutionState.

Require Import FORVES.stack_operation_instructions.
Import StackOpInstrs.

Require Import FORVES.misc.
Import Misc.

Require Import FORVES.symbolic_state.
Import SymbolicState.

Require Import FORVES.symbolic_execution.
Import SymbolicExecution.

Require Import FORVES.symbolic_execution.
Import SymbolicExecution.

Require Import FORVES.symbolic_state_eval.
Import SymbolicStateEval.

Require Import FORVES.flat_symbolic_state.
Import FlatSymbolicState.

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Module SymbolicExecutionSoundness.

Definition eq_con_sym (st: state) (sst: sstate) (ops: stack_op_instr_map) : Prop :=
  exists (st': state),
    eval_sstate st sst ops = Some st' /\
    eq_execution_states st st'.
  
  
Definition snd_state_transformer ( tr : state -> stack_op_instr_map -> option state ) (symtr : sstate ->  stack_op_instr_map -> option sstate )  : Prop :=
  forall (sst sst': sstate) (ops : stack_op_instr_map),
    symtr sst ops = Some sst' ->
    forall (st: state),
      eq_con_sym st sst ops ->
        exists (st': state), tr st ops = Some st' /\ eq_con_sym st' sst' ops.



Lemma push_snd:
  forall w, snd_state_transformer (push_c w) (push_s w).       
Proof.
Admitted.

Lemma pop_snd:
  snd_state_transformer pop_c pop_s.       
Proof.
Admitted.

Lemma dup_snd:
  forall k, snd_state_transformer (dup_c k) (dup_s k).       
Proof.
Admitted.

Lemma swap_snd:
  forall k, snd_state_transformer (swap_c k) (swap_s k).
Proof.
Admitted.

Lemma sload_snd:
  snd_state_transformer sload_c sload_s.
Proof.
Admitted.

Lemma sstore_snd:
  snd_state_transformer sstore_c sstore_s.
Proof.
Admitted.

Lemma mload_snd:
  snd_state_transformer mload_c mload_s.
Proof.
Admitted.

Lemma mstore8_snd:
  snd_state_transformer mstore8_c mstore8_s.
Proof.
Admitted.

Lemma mstore_snd:
  snd_state_transformer mstore_c mstore_s.
Proof.
Admitted.

Lemma sha3_snd:
  snd_state_transformer sha3_c sha3_s.
Proof.
Admitted.

Lemma exec_stack_op_intsr_snd:
  forall label, snd_state_transformer (exec_stack_op_intsr_c label) (exec_stack_op_intsr_s label).
Proof.
Admitted.


Lemma evm_exec_instr_snd:
  forall (i : instr),
    snd_state_transformer (evm_exec_instr_c i) (evm_exec_instr_s i).
Proof.
  destruct i.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply push_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply pop_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply dup_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply swap_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply mload_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply mstore_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply mstore8_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply sload_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply sstore_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply sha3_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply sha3_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply exec_stack_op_intsr_snd.
Qed.

  
Lemma evm_exec_block_snd:
  forall (p : block),
    snd_state_transformer (evm_exec_block_c p) (evm_exec_block_s p).
Proof.
  unfold snd_state_transformer.
  induction p as [| i p' IHp'].
  - intros. simpl. exists st. split.
    + reflexivity.
    + injection H as H1. rewrite <- H1. apply H0.
  - intros. unfold evm_exec_block_s in H. fold evm_exec_block_s in H.
    destruct (evm_exec_instr_s i sst ops) eqn:E.
    + apply evm_exec_instr_snd in E as E0. destruct E0 with (st:=st). apply H0.
      apply IHp' with (st:=x) in H.
      * destruct H. exists x0. split.
        ** unfold evm_exec_block_c. destruct H1. rewrite H1. fold evm_exec_block_c. destruct H. apply H.
        ** destruct H. apply H2.
      * destruct H1. apply H2.
    + discriminate H.
Qed.


Theorem symbolic_exec_snd:
  forall (p : block) (instk_height : nat) (sst : sstate) (ops : stack_op_instr_map),
    evm_sym_exec p instk_height ops = Some sst -> 
    forall (st : state), 
      length (get_stack_st st) = instk_height -> 
      exists (st': state),
        evm_exec_block_c p st ops = Some st' /\
          eq_con_sym st' sst ops. 
Proof.
  Admitted.

Check symbolic_exec_snd.
  
End SymbolicExecutionSoundness.

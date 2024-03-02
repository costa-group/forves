Require Import Arith.  
Require Import Nat. 
Require Import Bool.
Require Import bbv.Word. 
Require Import Coq.NArith.NArith.
Require Import List.
Import ListNotations.
Require Import Coq.Logic.FunctionalExtensionality.

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

Require Import FORVES.symbolic_state_eval.
Import SymbolicStateEval.

Require Import FORVES.symbolic_state_eval_facts.
Import SymbolicStateEvalFacts.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.memory_ops_solvers.
Import MemoryOpsSolvers.

Require Import FORVES.memory_ops_solvers_impl.
Import MemoryOpsSolversImpl.

Require Import FORVES.symbolic_state_cmp.
Import SymbolicStateCmp.

Require Import FORVES.eval_common.
Import EvalCommon.

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import FORVES.symbolic_execution_soundness.
Import SymbolicExecutionSoundness.

Require Import storage_ops_solvers_impl_soundness.
Import StorageOpsSolversImplSoundness.

Module MemoryOpsSolversImplSoundnessMisc.

  Ltac assoc_ones :=
  intros;
  repeat rewrite N.add_assoc;
  reflexivity.

Lemma assoc_ones_2 : forall x, (x+1+1 = x+(1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_3 : forall x, (x+1+1+1 = x+(1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_4 : forall x, (x+1+1+1+1 = x+(1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_5 : forall x, (x+1+1+1+1+1 = x+(1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_6 : forall x, (x+1+1+1+1+1+1 = x+(1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_7 : forall x, (x+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_8 : forall x, (x+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_9 : forall x, (x+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_10: forall x, (x+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_11: forall x, (x+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_12: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_13: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_14: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_15: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_16: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_17: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_18: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_19: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_20: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_21: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_22: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_23: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_24: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_25: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_26: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_27: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_28: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_29: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_30: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.
Lemma assoc_ones_31: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.

Lemma assoc_ones_32: forall x, (x+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = x+(1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1))%N. Proof. assoc_ones. Qed.


Lemma Reduce_ones_2 : (1+1 = 2)%N. Proof. intuition. Qed.
Lemma Reduce_ones_3 : (1+1+1 = 3)%N. Proof. intuition. Qed.
Lemma Reduce_ones_4 : (1+1+1+1 = 4)%N. Proof. intuition. Qed.
Lemma Reduce_ones_5 : (1+1+1+1+1 = 5)%N. Proof. intuition. Qed.
Lemma Reduce_ones_6 : (1+1+1+1+1+1 = 6)%N. Proof. intuition. Qed.
Lemma Reduce_ones_7 : (1+1+1+1+1+1+1 = 7)%N. Proof. intuition. Qed.
Lemma Reduce_ones_8 : (1+1+1+1+1+1+1+1 = 8)%N. Proof. intuition. Qed.
Lemma Reduce_ones_9 : (1+1+1+1+1+1+1+1+1 = 9)%N. Proof. intuition. Qed.
Lemma Reduce_ones_10: (1+1+1+1+1+1+1+1+1+1 = 10)%N. Proof. intuition. Qed.
Lemma Reduce_ones_11: (1+1+1+1+1+1+1+1+1+1+1 = 11)%N. Proof. intuition. Qed.
Lemma Reduce_ones_12: (1+1+1+1+1+1+1+1+1+1+1+1 = 12)%N. Proof. intuition. Qed.
Lemma Reduce_ones_13: (1+1+1+1+1+1+1+1+1+1+1+1+1 = 13)%N. Proof. intuition. Qed.
Lemma Reduce_ones_14: (1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 14)%N. Proof. intuition. Qed.
Lemma Reduce_ones_15: (1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 15)%N. Proof. intuition. Qed.
Lemma Reduce_ones_16: (1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 16)%N. Proof. intuition. Qed.
Lemma Reduce_ones_17: (1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 17)%N. Proof. intuition. Qed.
Lemma Reduce_ones_18: (1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 18)%N. Proof. intuition. Qed.
Lemma Reduce_ones_19: (1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 19)%N. Proof. intuition. Qed.
Lemma Reduce_ones_20: (1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 20)%N. Proof. intuition. Qed.
Lemma Reduce_ones_21: (1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 21)%N. Proof. intuition. Qed.
Lemma Reduce_ones_22: (1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 22)%N. Proof. intuition. Qed.
Lemma Reduce_ones_23: (1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 23)%N. Proof. intuition. Qed.
Lemma Reduce_ones_24: (1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 24)%N. Proof. intuition. Qed.
Lemma Reduce_ones_25: (1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 25)%N. Proof. intuition. Qed.
Lemma Reduce_ones_26: (1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 26)%N. Proof. intuition. Qed.
Lemma Reduce_ones_27: (1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 27)%N. Proof. intuition. Qed.
Lemma Reduce_ones_28: (1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 28)%N. Proof. intuition. Qed.
Lemma Reduce_ones_29: (1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 29)%N. Proof. intuition. Qed.
Lemma Reduce_ones_30: (1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 30)%N. Proof. intuition. Qed.
Lemma Reduce_ones_31: (1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 31)%N. Proof. intuition. Qed.
Lemma Reduce_ones_32: (1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1 = 32)%N. Proof. intuition. Qed.


Lemma H_1_lt_32: (1<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_2_lt_32: (2<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_3_lt_32: (3<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_4_lt_32: (4<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_5_lt_32: (5<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_6_lt_32: (6<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_7_lt_32: (7<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_8_lt_32: (8<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_9_lt_32: (9<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_10_lt_32: (10<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_11_lt_32: (11<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_12_lt_32: (12<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_13_lt_32: (13<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_14_lt_32: (14<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_15_lt_32: (15<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_16_lt_32: (16<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_17_lt_32: (17<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_18_lt_32: (18<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_19_lt_32: (19<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_20_lt_32: (20<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_21_lt_32: (21<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_22_lt_32: (22<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_23_lt_32: (23<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_24_lt_32: (24<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_25_lt_32: (25<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_26_lt_32: (26<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_27_lt_32: (27<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_28_lt_32: (28<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_29_lt_32: (29<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_30_lt_32: (30<32)%N. Proof.  apply Nlt_in. intuition. Qed.
Lemma H_31_lt_32: (31<32)%N. Proof.  apply Nlt_in. intuition. Qed.

Lemma H_1_le_31: (1<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_2_le_31: (2<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_3_le_31: (3<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_4_le_31: (4<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_5_le_31: (5<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_6_le_31: (6<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_7_le_31: (7<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_8_le_31: (8<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_9_le_31: (9<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_10_le_31: (10<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_11_le_31: (11<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_12_le_31: (12<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_13_le_31: (13<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_14_le_31: (14<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_15_le_31: (15<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_16_le_31: (16<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_17_le_31: (17<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_18_le_31: (18<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_19_le_31: (19<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_20_le_31: (20<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_21_le_31: (21<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_22_le_31: (22<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_23_le_31: (23<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_24_le_31: (24<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_25_le_31: (25<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_26_le_31: (26<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_27_le_31: (27<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_28_le_31: (28<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_29_le_31: (29<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_30_le_31: (30<=31)%N. Proof.  apply N.lt_le_incl. apply Nlt_in. intuition. Qed.
Lemma H_31_le_31: (31<=31)%N. Proof.  intuition. Qed.


Lemma do_not_overlap_mload_aux_0 n i k (offset offset' : word n) (H_i_lt_32: (i<32)%N) (H_o: (wordToN offset + 31 <? wordToN offset')%N || (wordToN offset' + k <? wordToN offset)%N = true):
    (wordToN offset + i =? wordToN offset'= false)%N.
Proof.
  intros.
  apply orb_prop in H_o.
  destruct H_o.
  + rewrite N.eqb_neq.
    apply Nneq_in.
    rewrite N.ltb_lt in H.
    apply Nlt_out in H.
    intuition.
  + rewrite N.eqb_neq.
    apply Nneq_in.
    rewrite N.ltb_lt in H.
    apply Nlt_out in H.
    intuition.
Qed.  

Lemma do_not_overlap_mload_aux_1 n j i k (offset offset' : word n) (H_j_lt_k: (j<=k)%N) (H_j_lt_32: (j<32)%N) (H_i_lt_32: (i<32)%N) (H_o: (wordToN offset + 31 <? wordToN offset')%N || (wordToN offset' + k <? wordToN offset)%N = true):
    (wordToN offset + i =? wordToN offset' + j = false)%N.
Proof.
  intros.
  apply orb_prop in H_o.
  destruct H_o.
  + rewrite N.eqb_neq.
    apply Nneq_in.
    rewrite N.ltb_lt in H.
    apply Nlt_out in H.
    intuition.
  + rewrite N.eqb_neq.
    apply Nneq_in.
    rewrite N.ltb_lt in H.
    apply Nlt_out in H.
    intuition.
    Qed.

Lemma do_not_overlap_mload_aux mem value' updates i offset offset' (H_i_lt_32: (i<32)%N) (H_not_overlap: (wordToN offset + 31 <? wordToN offset')%N || (wordToN offset' + 31 <? wordToN offset)%N = true):
    (update_memory mem (U_MSTORE EVMWord offset' value' :: updates)) ((wordToN offset)+i)%N =
    (update_memory mem  updates) ((wordToN (offset : EVMWord)+i))%N.
Proof.
  unfold update_memory.
  remember ((fix update_memory (mem0 : memory) (updates0 : memory_updates EVMWord) {struct updates0} : memory := match updates0 with
                                                                                                                 | [] => mem0
                                                                                                                 | u :: us => update_memory' (update_memory mem0 us) u
                                                                                                                 end) mem updates) as XX.
  unfold update_memory'.
  unfold ConcreteInterpreter.mstore.
  unfold ConcreteInterpreter.mstore'.
  unfold BytesInEVMWord.

  rewrite assoc_ones_31.
  rewrite Reduce_ones_31.

  rewrite assoc_ones_30.
  rewrite Reduce_ones_30.

  rewrite assoc_ones_29.
  rewrite Reduce_ones_29.

  rewrite assoc_ones_28.
  rewrite Reduce_ones_28.

  rewrite assoc_ones_27.
  rewrite Reduce_ones_27.

  rewrite assoc_ones_26.
  rewrite Reduce_ones_26.

  rewrite assoc_ones_25.
  rewrite Reduce_ones_25.

  rewrite assoc_ones_24.
  rewrite Reduce_ones_24.

  rewrite assoc_ones_23.
  rewrite Reduce_ones_23.

  rewrite assoc_ones_22.
  rewrite Reduce_ones_22.

  rewrite assoc_ones_21.
  rewrite Reduce_ones_21.

  rewrite assoc_ones_20.
  rewrite Reduce_ones_20.

  rewrite assoc_ones_19.
  rewrite Reduce_ones_19.

  rewrite assoc_ones_18.
  rewrite Reduce_ones_18.

  rewrite assoc_ones_17.
  rewrite Reduce_ones_17.

  rewrite assoc_ones_16.
  rewrite Reduce_ones_16.

  rewrite assoc_ones_15.
  rewrite Reduce_ones_15.

  rewrite assoc_ones_14.
  rewrite Reduce_ones_14.

  rewrite assoc_ones_13.
  rewrite Reduce_ones_13.

  rewrite assoc_ones_12.
  rewrite Reduce_ones_12.

  rewrite assoc_ones_11.
  rewrite Reduce_ones_11.

  rewrite assoc_ones_10.
  rewrite Reduce_ones_10.

    rewrite assoc_ones_9.
  rewrite Reduce_ones_9.

  rewrite assoc_ones_8.
  rewrite Reduce_ones_8.

  rewrite assoc_ones_7.
  rewrite Reduce_ones_7.

  rewrite assoc_ones_6.
  rewrite Reduce_ones_6.

  rewrite assoc_ones_5.
  rewrite Reduce_ones_5.

  rewrite assoc_ones_4.
  rewrite Reduce_ones_4.

  rewrite assoc_ones_3.
  rewrite Reduce_ones_3.

  rewrite assoc_ones_2.
  rewrite Reduce_ones_2.



  rewrite (do_not_overlap_mload_aux_0 EVMWordSize i 31%N offset offset' H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 1%N i 31%N  offset offset' H_1_le_31 H_1_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 2%N i 31%N offset offset' H_2_le_31 H_2_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 3%N i 31%N offset offset' H_3_le_31 H_3_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 4%N i  31%N offset offset' H_4_le_31 H_4_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 5%N i  31%N offset offset' H_5_le_31 H_5_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 6%N i  31%N offset offset' H_6_le_31 H_6_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 7%N i  31%N offset offset' H_7_le_31 H_7_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 8%N i  31%N offset offset' H_8_le_31 H_8_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 9%N i  31%N offset offset' H_9_le_31 H_9_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 10%N i  31%N offset offset' H_10_le_31 H_10_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 11%N i  31%N offset offset' H_11_le_31 H_11_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 12%N i  31%N offset offset' H_12_le_31 H_12_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 13%N i  31%N offset offset' H_13_le_31 H_13_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 14%N i  31%N offset offset' H_14_le_31 H_14_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 15%N i  31%N offset offset' H_15_le_31 H_15_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 16%N i  31%N offset offset' H_16_le_31 H_16_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 17%N i  31%N offset offset' H_17_le_31 H_17_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 18%N i  31%N offset offset' H_18_le_31 H_18_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 19%N i  31%N offset offset' H_19_le_31 H_19_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 20%N i  31%N offset offset' H_20_le_31 H_20_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 21%N i  31%N offset offset' H_21_le_31 H_21_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 22%N i  31%N offset offset' H_22_le_31 H_22_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 23%N i  31%N offset offset' H_23_le_31 H_23_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 24%N i  31%N offset offset' H_24_le_31 H_24_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 25%N i  31%N offset offset' H_25_le_31 H_25_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 26%N i  31%N offset offset' H_26_le_31 H_26_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 27%N i  31%N offset offset' H_27_le_31 H_27_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 28%N i  31%N offset offset' H_28_le_31 H_28_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 29%N i  31%N offset offset' H_29_le_31 H_29_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 30%N i  31%N offset offset' H_30_le_31 H_30_lt_32 H_i_lt_32 H_not_overlap).
  rewrite (do_not_overlap_mload_aux_1 EVMWordSize 31%N i  31%N offset offset' H_31_le_31 H_31_lt_32 H_i_lt_32 H_not_overlap).
  reflexivity.
Qed.

Lemma do_not_overlap_mload_aux' mem value' updates i offset offset' (H_i_lt_32: (i<32)%N) (H_not_overlap: (wordToN offset + 31 <? wordToN offset')%N || (wordToN offset' + 0 <? wordToN offset)%N = true):
    (update_memory mem (U_MSTORE8 EVMWord offset' value' :: updates)) ((wordToN offset)+i)%N =
    (update_memory mem  updates) ((wordToN (offset : EVMWord)+i))%N.
Proof.
  unfold update_memory.
  remember ((fix update_memory (mem0 : memory) (updates0 : memory_updates EVMWord) {struct updates0} : memory := match updates0 with
                                                                                                                 | [] => mem0
                                                                                                                 | u :: us => update_memory' (update_memory mem0 us) u
                                                                                                                 end) mem updates) as XX.
  unfold update_memory'.
  unfold ConcreteInterpreter.mstore.
  unfold ConcreteInterpreter.mstore'.

  



  rewrite (do_not_overlap_mload_aux_0 EVMWordSize i 0%N offset offset' H_i_lt_32 H_not_overlap).
  reflexivity.
Qed.

End MemoryOpsSolversImplSoundnessMisc.

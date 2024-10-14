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

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import FORVES.eval_common.
Import EvalCommon.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.


Require Import FORVES.symbolic_state_eval.
Import SymbolicStateEval.

Require Import FORVES.symbolic_state_rename.
Import SymbolicStateRename.

Module SymbolicStateRenameFacts.
  Lemma sstate_insert_bindings_snd:
    forall (sst sst': sstate)  (nbs : list sbinding),
      sstate_insert_bindings sst nbs = Some sst' ->
      (valid_sstate sst' evm_stack_opm /\ 
         get_instk_height_sst sst = get_instk_height_sst sst' /\
         forall (st st': state), eval_sstate st sst  evm_stack_opm = Some st' ->
                                 eval_sstate st sst' evm_stack_opm = Some st').
  Proof.
    Admitted.
End SymbolicStateRenameFacts.


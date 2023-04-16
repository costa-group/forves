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

Require Import FORVES.symbolic_state_eval.
Import SymbolicStateEval.


Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.symbolic_state_cmp.
Import SymbolicStateCmp.

Require Import FORVES.eval_common.
Import EvalCommon.

Module SHA3CmpImpl.


Definition trivial_sha3_cmp (sstack_val_cmp: sstack_val_cmp_t) (soffset1 ssize1: sstack_val) (smem1 :smemory) (soffset2 ssize2: sstack_val) (smem2 :smemory) (maxidx1: nat) (sb1: sbindings) (maxidx2: nat) (sb2: sbindings) (instk_height: nat) (ops: stack_op_instr_map) : bool :=
  false.


End SHA3CmpImpl.

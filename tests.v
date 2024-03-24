Require Import bbv.Word. 
Require Import Nat.
Require Import Coq.NArith.NArith.

Require Import FORVES.constants.
Import Constants.

Require Import FORVES.symbolic_execution.
Import SymbolicExecution.

Require Import FORVES.storage_ops_solvers_impl.
Import StorageOpsSolversImpl.

Require Import FORVES.memory_ops_solvers_impl.
Import MemoryOpsSolversImpl.

Require Import FORVES.symbolic_state.
Import SymbolicState.

Require Import FORVES.symbolic_state_cmp.
Import SymbolicStateCmp.

Require Import FORVES.program.
Import Program.

Require Import FORVES.stack_operation_instructions.
Import StackOpInstrs.

Require Import FORVES.symbolic_state.
Import SymbolicState.

Require Import List.
Import ListNotations.

Require Import FORVES.execution_state.
Import ExecutionState.

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.


Require Import FORVES.constants.
Import Constants.


Require Import List. 
Require Import bbv.Word.

Require Import Coq.NArith.NArith.

Require Import FORVES.constants.
Import Constants.

Require Import FORVES.program.
Import Program.

Require Import FORVES.block_equiv_checker.
Import BlockEquivChecker.

Require Import FORVES.symbolic_state.
Import SymbolicState.

Require Import FORVES.stack_operation_instructions.
Import StackOpInstrs.

Require Import FORVES.execution_state.
Import ExecutionState.

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import FORVES.optimizations_def.
Import Optimizations_Def.

Require Import FORVES.optimizations.sub_x_x.
Import Opt_sub_x_x.
Require Import FORVES.optimizations.and_address.
Import Opt_and_address.

Require Import FORVES.symbolic_execution.
Import SymbolicExecution.

Require Import FORVES.storage_ops_solvers.
Import StorageOpsSolvers.

Require Import FORVES.storage_ops_solvers_impl.
Import StorageOpsSolversImpl.

Require Import FORVES.memory_ops_solvers.
Import MemoryOpsSolvers.

Require Import FORVES.memory_ops_solvers_impl.
Import MemoryOpsSolversImpl.

Require Import FORVES.symbolic_state_cmp.
Import SymbolicStateCmp.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.symbolic_execution_soundness.
Import SymbolicExecutionSoundness.

Require Import FORVES.symbolic_state_eval.
Import SymbolicStateEval.

Require Import FORVES.symbolic_state.
Import SymbolicState.

Require Import FORVES.symbolic_state_cmp_impl.
Import SymbolicStateCmpImpl.

Require Import FORVES.sstack_val_cmp_impl.
Import SStackValCmpImpl.

Require Import FORVES.sstack_val_cmp_impl_soundness.
Import SStackValCmpImplSoundness.

Require Import FORVES.sha3_cmp_impl.
Import SHA3CmpImpl.

Require Import FORVES.sha3_cmp_impl_soundness.
Import SHA3CmpImplSoundness.

Require Import FORVES.storage_cmp_impl.
Import StorageCmpImpl.

Require Import FORVES.storage_cmp_impl_soundness.
Import StorageCmpImplSoundness.


Require Import FORVES.memory_cmp_impl.
Import MemoryCmpImpl.

Require Import FORVES.memory_cmp_impl_soundness.
Import MemoryCmpImplSoundness.

Require Import FORVES.storage_ops_solvers_impl.
Import StorageOpsSolversImpl.

Require Import FORVES.storage_ops_solvers_impl_soundness.
Import StorageOpsSolversImplSoundness.

Require Import FORVES.memory_ops_solvers_impl.
Import MemoryOpsSolversImpl.

Require Import FORVES.memory_ops_solvers_impl_soundness.
Import MemoryOpsSolversImplSoundness.

Require Import FORVES.misc.
Import Misc.

Require Import FORVES.optimizations_common.
Import Optimizations_Common.

Require Import FORVES.parser.
Import Parser.

From Coq Require Import Strings.String.

From Coq Require Import Lists.List. Import ListNotations.



Module OptimizationRuleTests.

(* string to block that always succeed *)
Definition str2block (s : string) : block :=
  match parse_block s with
  | None => []
  | Some b => b
  end.
  
Definition check_rule (s1 s2: string) (step: available_optimization_step) :=
let b1 := str2block s1 in
let b2 := str2block s2 in 
let r1 := (evm_eq_block_chkr SMemUpdater_Basic SStrgUpdater_Basic
   MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_PO
   SStrgCmp_Basic SHA3Cmp_Trivial 
   [step] 10 10 b1 b2 3) in
let r2 := (evm_eq_block_chkr SMemUpdater_Basic SStrgUpdater_Basic
   MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_PO
   SStrgCmp_Basic SHA3Cmp_Trivial 
   [] 10 10 b1 b2 3) in
r1 = true /\ r2 = false.

Example ex_balance_address:
(* BALANCE(ADDRESS) = SELFBALANCE *)
check_rule "ADDRESS BALANCE"
           "SELFBALANCE"
           OPT_balance_address.
Proof. unfold check_rule. intuition. Qed.

Example ex_and_coinbase1:
(* AND(COINBASE, 2^160 - 1) = COINBASE *)
check_rule "PUSH20 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF COINBASE AND"
           "COINBASE"
           OPT_and_coinbase.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_coinbase2:
check_rule "COINBASE PUSH20 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND"
           "COINBASE"
           OPT_and_coinbase.
Proof. unfold check_rule. intuition. Qed.

Example ex_and_ffff1:
(* AND(2^256-1,X) = X *) 
check_rule "PUSH32 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff AND"
           ""
           OPT_and_ffff.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_ffff2:
(* AND(X,2^256-1) = X *) 
check_rule "PUSH32 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff SWAP1 AND"
           ""
           OPT_and_ffff.
Proof. unfold check_rule. intuition. Qed.

Example ex_or_ffff1:
(* OR(2^256-1,X) = 2^256-1 *) 
check_rule "PUSH32 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff OR"
           "POP PUSH32 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
           OPT_or_ffff.
Proof. unfold check_rule. intuition. Qed.
Example ex_or_ffff2:
(* OR(X,2^256-1) = 2^256-1 *) 
check_rule "PUSH32 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff SWAP1 OR"
           "POP PUSH32 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
           OPT_or_ffff.
Proof. unfold check_rule. intuition. Qed.

Example ex_or_zero1:
(* OR(X, 0) = X *) 
check_rule "PUSH1 0x0 OR"
           ""
           OPT_or_zero.
Proof. unfold check_rule. intuition. Qed.
Example ex_or_zero2:
(* OR(X, 0) = X *) 
check_rule "PUSH1 0x0 SWAP1 OR"
           ""
           OPT_or_zero.
Proof. unfold check_rule. intuition. Qed.

Example ex_and_x_x:
(* AND(X, X) = X *) 
check_rule "DUP1 AND"
           ""
           OPT_and_x_x.
Proof. unfold check_rule. intuition. Qed.

Example ex_or_x_x:
(* OR(X, X) = X *) 
check_rule "DUP1 OR"
           ""
           OPT_or_x_x.
Proof. unfold check_rule. intuition. Qed.

Example ex_or_not1:
(* OR(NOT(X), X) = 2^256-1 *) 
check_rule "DUP1 NOT OR"
           "POP PUSH32 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
           OPT_or_not.
Proof. unfold check_rule. intuition. Qed.
Example ex_or_not2:
(* OR(X, NOT(X)) = 0 *) 
check_rule "DUP1 NOT SWAP1 OR"
           "POP PUSH32 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
           OPT_or_not.
Proof. unfold check_rule. intuition. Qed.

Example ex_and_not1:
(* AND(NOT(X), X) = 0 *) 
check_rule "DUP1 NOT AND"
           "POP PUSH1 0x0"
           OPT_and_not.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_not2:
(* AND(X, NOT(X)) = 0 *) 
check_rule "DUP1 NOT SWAP1 AND"
           "POP PUSH1 0x0"
           OPT_and_not.
Proof. unfold check_rule. intuition. Qed.

Example ex_and_or1:
(* AND(OR(X, Y), X) = X *) 
check_rule "DUP1 SWAP2 SWAP1 OR AND"
           "SWAP1 POP"
           OPT_and_or.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_or2:
(* AND(OR(Y, X), X) = X *)
check_rule "DUP1 SWAP2 OR AND"
           "SWAP1 POP"
           OPT_and_or.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_or3:
(* AND(X, OR(X, Y)) = X *)
check_rule "DUP1 SWAP2 SWAP1 OR SWAP1 AND"
           "SWAP1 POP"
           OPT_and_or.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_or4:
(* AND(X, OR(Y, X)) = X *)
check_rule "DUP1 SWAP2 OR SWAP1 AND"
           "SWAP1 POP"
           OPT_and_or.
Proof. unfold check_rule. intuition. Qed.

Example ex_or_and1:
(* OR(AND(X, Y), X) = X *) 
check_rule "DUP1 SWAP2 SWAP1 AND OR"
           "SWAP1 POP"
           OPT_or_and.
Proof. unfold check_rule. intuition. Qed.
Example ex_or_and2:
(* OR(AND(Y, X), X) = X *)
check_rule "DUP1 SWAP2 AND OR"
           "SWAP1 POP"
           OPT_or_and.
Proof. unfold check_rule. intuition. Qed.
Example ex_or_and3:
(* OR(X, AND(X, Y)) = X *)
check_rule "DUP1 SWAP2 SWAP1 AND SWAP1 OR"
           "SWAP1 POP"
           OPT_or_and.
Proof. unfold check_rule. intuition. Qed.
Example ex_or_and4:
(* OR(X, AND(Y, X)) = X *)
check_rule "DUP1 SWAP2 AND SWAP1 OR"
           "SWAP1 POP"
           OPT_or_and.
Proof. unfold check_rule. intuition. Qed.

Example ex_or_or1:
(* OR(OR(X, Y), X) = OR(X,Y) *) 
check_rule "DUP1 SWAP2 SWAP1 OR OR"
           "OR"
           OPT_or_or.
Proof. unfold check_rule. intuition. Qed.
Example ex_or_or1':
(* OR(OR(X, Y), X) = OR(Y,X) *) 
check_rule "DUP1 SWAP2 SWAP1 OR OR"
           "SWAP1 OR"
           OPT_or_or.
Proof. unfold check_rule. intuition. Qed.
Example ex_or_or2:
(* OR(OR(Y, X), X) = OR(X,Y) *)
check_rule "DUP1 SWAP2 OR OR"
           "OR"
           OPT_or_or.
Proof. unfold check_rule. intuition. Qed.
Example ex_or_or2':
(* OR(OR(Y, X), X) = OR(Y,X) *)
check_rule "DUP1 SWAP2 OR OR"
           "SWAP1 OR"
           OPT_or_or.
Proof. unfold check_rule. intuition. Qed.
Example ex_or_or3:
(* OR(X, OR(X, Y)) = OR(X,Y) *)
check_rule "DUP1 SWAP2 SWAP1 OR SWAP1 OR"
           "OR"
           OPT_or_or.
Proof. unfold check_rule. intuition. Qed.
Example ex_or_or3':
(* OR(X, OR(X, Y)) = OR(Y,X) *)
check_rule "DUP1 SWAP2 SWAP1 OR SWAP1 OR"
           "SWAP1 OR"
           OPT_or_or.
Proof. unfold check_rule. intuition. Qed.
Example ex_or_or4:
(* OR(OR(Y, X), X) = OR(X,Y) *)
check_rule "DUP1 SWAP2 OR SWAP1 OR"
           "OR"
           OPT_or_or.
Proof. unfold check_rule. intuition. Qed.
Example ex_or_or4':
(* OR(OR(Y, X), X) = OR(Y,X) *)
check_rule "DUP1 SWAP2 OR SWAP1 OR"
           "SWAP1 OR"
           OPT_or_or.
Proof. unfold check_rule. intuition. Qed.

Example ex_xor_xor1:
(* XOR(X, XOR(X,Y)) = Y *) 
check_rule "DUP1 SWAP2 SWAP1 XOR SWAP1 XOR"
           "POP"
           OPT_xor_xor.
Proof. unfold check_rule. intuition. Qed.
Example ex_xor_xor2:
(* XOR(X, XOR(Y,X)) = Y *) 
check_rule "DUP1 SWAP2 XOR SWAP1 XOR"
           "POP"
           OPT_xor_xor.
Proof. unfold check_rule. intuition. Qed.
Example ex_xor_xor3:
(* XOR(XOR(X,Y), X) = Y *) 
check_rule "DUP1 SWAP2 SWAP1 XOR XOR"
           "POP"
           OPT_xor_xor.
Proof. unfold check_rule. intuition. Qed.
Example ex_xor_xor4:
(* XOR(XOR(Y,X), X) = Y *) 
check_rule "DUP1 SWAP2 XOR XOR"
           "POP"
           OPT_xor_xor.
Proof. unfold check_rule. intuition. Qed.

Example ex_xor_zero1:
(* XOR(X, 0) = X *) 
check_rule "PUSH1 0x0 XOR"
           ""
           OPT_xor_zero.
Proof. unfold check_rule. intuition. Qed.
Example ex_xor_zero2:
(* XOR(X, 0) = X *) 
check_rule "PUSH1 0x0 SWAP1 XOR"
           ""
           OPT_xor_zero.
Proof. unfold check_rule. intuition. Qed.

Example ex_xor_x_x:
(* XOR(X, X) = 0 *) 
check_rule "DUP1 XOR"
           "POP PUSH1 0x0"
           OPT_xor_x_x.
Proof. unfold check_rule. intuition. Qed.

Example ex_iszero2_eq:
(* ISZERO(ISZERO(EQ(X, Y))) = EQ(X,Y) *) 
check_rule "EQ ISZERO ISZERO"
           "EQ"
           OPT_iszero2_eq.
Proof. unfold check_rule. intuition. Qed.
Example ex_iszero2_eq2:
check_rule "EQ ISZERO ISZERO"
           "SWAP1 EQ"
           OPT_iszero2_eq.
Proof. unfold check_rule. intuition. Qed.
Example ex_iszero2_eq3:
check_rule "SWAP1 EQ ISZERO ISZERO"
           "EQ"
           OPT_iszero2_eq.
Proof. unfold check_rule. intuition. Qed.
Example ex_iszero2_eq4:
check_rule "EQ ISZERO ISZERO"
           "SWAP1 EQ"
           OPT_iszero2_eq.
Proof. unfold check_rule. intuition. Qed.

Example ex_iszero2_lt:
(* ISZERO(ISZERO(LT(X, Y))) = LT(X, Y) *) 
check_rule "LT ISZERO ISZERO"
           "LT"
           OPT_iszero2_lt.
Proof. unfold check_rule. intuition. Qed.

Example ex_iszero2_gt:
(* ISZERO(ISZERO(GT(X, Y))) = GT(X, Y) *) 
check_rule "GT ISZERO ISZERO"
           "GT"
           OPT_iszero2_gt.
Proof. unfold check_rule. intuition. Qed.

Example ex_iszero_xor:
(* ISZERO(XOR(X, Y)) = EQ(X, Y) *) 
check_rule "XOR ISZERO"
           "EQ"
           OPT_iszero_xor.
Proof. unfold check_rule. intuition. Qed.

Example ex_iszero_lt:
(* ISZERO(LT(0, X)) = ISZERO(X) *) 
check_rule "PUSH1 0x0 LT ISZERO"
           "ISZERO"
           OPT_iszero_lt.
Proof. unfold check_rule. intuition. Qed.


Example ex_iszero_sub:
(* ISZERO(SUB(X, Y)) = EQ(X, Y) *) 
check_rule "SUB ISZERO"
           "EQ"
           OPT_iszero_sub.
Proof. unfold check_rule. intuition. Qed.

Example ex_eq_x_x:
check_rule "PUSH1 0x20 PUSH1 0x20 EQ"
           "PUSH1 0x1"
           OPT_eq_x_x.
Proof. unfold check_rule. intuition. Qed.

Example ex_lt_x_x:
check_rule "PUSH1 0x20 PUSH1 0x20 LT"
           "PUSH1 0x0"
           OPT_lt_x_x.
Proof. unfold check_rule. intuition. Qed.

Example ex_lt_x_zero:
check_rule "PUSH1 0x0 PUSH1 0x20 LT"
           "PUSH1 0x0"
           OPT_lt_x_zero.
Proof. unfold check_rule. intuition. Qed.

Example ex_gt_x_x:
check_rule "DUP1 GT"
           "POP PUSH1 0x0"
           OPT_gt_x_x.
Proof. unfold check_rule. intuition. Qed.

Example ex_gt_zero_x:
check_rule "PUSH1 0x0 GT"
           "POP PUSH1 0x0"
           OPT_gt_zero_x.
Proof. unfold check_rule. intuition. Qed.

Example ex_exp_two_x:
check_rule "PUSH1 0x10 PUSH1 0x2 EXP"
           "PUSH1 0x1 PUSH1 0x10 SHL"
           OPT_exp_two_x.
Proof. unfold check_rule. intuition. Qed.

Example ex_exp_zero_x:
check_rule "PUSH1 0x10 PUSH1 0x0 EXP"
           "PUSH1 0x10 ISZERO"
           OPT_exp_zero_x.
Proof. unfold check_rule. intuition. Qed.

Example ex_exp_one_x:
check_rule "PUSH1 0x1 EXP"
           "POP PUSH1 0x1"
           OPT_exp_one_x.
Proof. unfold check_rule. intuition. Qed.

Example ex_exp_x_one:
check_rule "PUSH1 0x1 SWAP1 EXP"
           ""
           OPT_exp_x_one.
Proof. unfold check_rule. intuition. Qed.

Example ex_exp_x_zero:
check_rule "PUSH1 0x0 SWAP1 EXP"
           "POP PUSH1 0x1"
           OPT_exp_x_zero.
Proof. unfold check_rule. intuition. Qed.

Example ex_mod_x_x:
check_rule "DUP1 MOD"
           "POP PUSH1 0x0"
           OPT_mod_x_x.
Proof. unfold check_rule. intuition. Qed.

Example ex_mod_zero:
check_rule "PUSH1 0x0 SWAP1 MOD"
           "POP PUSH1 0x0"
           OPT_mod_zero.
Proof. unfold check_rule. intuition. Qed.

Example ex_mod_one:
check_rule "PUSH1 0x1 SWAP1 MOD"
           "POP PUSH1 0x0"
           OPT_mod_one.
Proof. unfold check_rule. intuition. Qed.

Example ex_div_zero:
check_rule "PUSH1 0x0 SWAP1 DIV"
           "POP PUSH1 0x0"
           OPT_div_zero.
Proof. unfold check_rule. intuition. Qed.

Example ex_div_x_x:
check_rule "PUSH1 0x6 PUSH1 0x6 DIV"
           "PUSH1 0x1"
           OPT_eval.
Proof. unfold check_rule. intuition. Qed.

Example ex_mul_zero1:
check_rule "PUSH1 0x0 MUL"
           "POP PUSH1 0x0"
           OPT_mul_zero.
Proof. unfold check_rule. intuition. Qed.
Example ex_mul_zero2:
check_rule "PUSH1 0x0 SWAP1 MUL"
           "POP PUSH1 0x0"
           OPT_mul_zero.
Proof. unfold check_rule. intuition. Qed.

Example ex_shl_x_zero:
check_rule "PUSH1 0x0 SWAP1 SHL"
           "POP PUSH1 0x0"
           OPT_shl_x_zero.
Proof. unfold check_rule. intuition. Qed.

Example ex_sub_zero:
check_rule "PUSH1 0x0 SWAP1 SUB"
           ""
           OPT_sub_zero.
Proof. unfold check_rule. intuition. Qed.

Example ex_shl_zero_x:
check_rule "PUSH1 0x0 SHL"
           ""
           OPT_shl_zero_x.
Proof. unfold check_rule. intuition. Qed.


Example ex_add_sub1:
check_rule "DUP1 SWAP2 SUB ADD"
           "POP"
           OPT_add_sub.
Proof. unfold check_rule. intuition. Qed.
Example ex_add_sub2:
check_rule "DUP1 SWAP2 SUB SWAP1 ADD"
           "POP"
           OPT_add_sub.
Proof. unfold check_rule. intuition. Qed.

Example ex_iszero3:
check_rule "ISZERO ISZERO ISZERO"
           "ISZERO"
           OPT_iszero3.
Proof. unfold check_rule. intuition. Qed.

Example ex_and_caller1:
(* AND(CALLER, 2^160 - 1) = CALLER *)
check_rule "PUSH20 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF CALLER AND"
           "CALLER"
           OPT_and_caller.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_caller2:
check_rule "CALLER PUSH20 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND"
           "CALLER"
           OPT_and_caller.
Proof. unfold check_rule. intuition. Qed.


Example ex_eq_zero1:
(* EQ(X, 0) = ISZERO(X) *)
check_rule "PUSH1 0x0 EQ"
           "ISZERO"
           OPT_eq_zero.
Proof. unfold check_rule. intuition. Qed.
Example ex_eq_zero2:
check_rule "PUSH1 0x0 SWAP1 EQ"
           "ISZERO"
           OPT_eq_zero.
Proof. unfold check_rule. intuition. Qed.

Example ex_iszero_gt:
(* ISZERO(GT(X, 0)) = ISZERO(X) *)
check_rule "PUSH1 0x0 SWAP1 GT ISZERO"
           "ISZERO"
           OPT_iszero_gt.
Proof. unfold check_rule. intuition. Qed.

Example ex_mul_one1:
(* MUL(X,1) = X *)
check_rule "PUSH1 0x1 MUL"
           ""
           OPT_mul_one.
Proof. unfold check_rule. intuition. Qed.
Example ex_mul_one2:
check_rule "PUSH1 0x1 SWAP1 MUL"
           ""
           OPT_mul_one.
Proof. unfold check_rule. intuition. Qed.

Example ex_and_address1:
(* AND(ADDRESS, 2^160 - 1) = ADDRESS *)
check_rule "PUSH20 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ADDRESS AND"
           "ADDRESS"
           OPT_and_address.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_address2:
check_rule "ADDRESS PUSH20 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND"
           "ADDRESS"
           OPT_and_address.
Proof. unfold check_rule. intuition. Qed.

Example ex_gt_one_x:
(* GT(1, X) = ISZERO(X) *)
check_rule "PUSH1 0x1 GT"
           "ISZERO"
           OPT_gt_one_x.
Proof. unfold check_rule. intuition. Qed.

Example ex_lt_x_one:
(* LT(X, 1) = ISZERO(X) *)
check_rule "PUSH1 0x1 SWAP1 LT"
           "ISZERO"
           OPT_lt_x_one.
Proof. unfold check_rule. intuition. Qed.

Example ex_div_one:
(* DIV(X, 1) = X *)
check_rule "PUSH1 0x1 SWAP1 DIV"
           ""
           OPT_div_one.
Proof. unfold check_rule. intuition. Qed.

Example ex_and_zero1:
(* AND(X, 0) = 0 *)
check_rule "PUSH1 0x0 AND"
           "POP PUSH1 0x0"
           OPT_and_zero.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_zero2:
check_rule "PUSH1 0x0 SWAP1 AND"
           "POP PUSH1 0x0"
           OPT_and_zero.
Proof. unfold check_rule. intuition. Qed.

Example ex_sub_x_x:
(* SUB(X, X) = 0 *)
check_rule "DUP1 SUB"
           "POP PUSH1 0x0"
           OPT_sub_x_x.
Proof. unfold check_rule. intuition. Qed.

Example ex_eq_iszero1:
(* EQ(1, ISZERO(X)) = ISZERO(X) *)
check_rule "ISZERO PUSH1 0x1 EQ"
           "ISZERO"
           OPT_eq_iszero.
Proof. unfold check_rule. intuition. Qed.
Example ex_eq_iszero2:
check_rule "ISZERO PUSH1 0x1 SWAP1 EQ"
           "ISZERO"
           OPT_eq_iszero.
Proof. unfold check_rule. intuition. Qed.

Example ex_shr_x_zero:
(* SHR(X, 0) = 0 *)
check_rule "PUSH1 0x0 SWAP1 SHR"
           "POP PUSH1 0x0"
           OPT_shr_x_zero.
Proof. unfold check_rule. intuition. Qed.

Example ex_shr_zero_x:
(* SHR(0, X) = X *)
check_rule "PUSH1 0x0 SHR"
           ""
           OPT_shr_zero_x.
Proof. unfold check_rule. intuition. Qed.

Example ex_div_shl:
(* DIV(X, SHL(Y, 1)) = SHR(Y, X) *)
check_rule "PUSH1 0x1 SWAP1 SHL SWAP1 DIV"
           "SHR"
           OPT_div_shl.
Proof. unfold check_rule. intuition. Qed.

Example ex_mul_shl1:
(* MUL(SHL(X, 1), Y ) = SHL(X, Y)
   MUL(X, SHL(Y, 1)) = SHL(Y, X) *)
check_rule "PUSH1 0x1 SWAP1 SHL MUL"
           "SHL"
           OPT_mul_shl.
Proof. unfold check_rule. intuition. Qed.
Example ex_mul_shl2:
(* MUL(SHL(X, 1), Y ) = SHL(X, Y)
   MUL(X, SHL(Y, 1)) = SHL(Y, X) *)
check_rule "PUSH1 0x1 SWAP1 SHL SWAP1 MUL"
           "SHL"
           OPT_mul_shl.
Proof. unfold check_rule. intuition. Qed.

Example ex_and_origin1:
(* AND(ORIGIN, 2^160 - 1) = ORIGIN *)
check_rule "PUSH20 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ORIGIN AND"
           "ORIGIN"
           OPT_and_origin.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_origin2:
check_rule "ORIGIN PUSH20 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND"
           "ORIGIN"
           OPT_and_origin.
Proof. unfold check_rule. intuition. Qed.

Example ex_and_and1:
(* AND(AND(X, Y), X) = AND(X,Y) *) 
check_rule "DUP1 SWAP2 SWAP1 AND AND"
           "AND"
           OPT_and_and.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_and1':
(* AND(AND(X, Y), X) = AND(Y,X) *) 
check_rule "DUP1 SWAP2 SWAP1 AND AND"
           "SWAP1 AND"
           OPT_and_and.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_and2:
(* AND(AND(Y, X), X) = AND(X,Y) *)
check_rule "DUP1 SWAP2 AND AND"
           "AND"
           OPT_and_and.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_and2':
(* AND(AND(Y, X), X) = AND(Y,X) *)
check_rule "DUP1 SWAP2 AND AND"
           "SWAP1 AND"
           OPT_and_and.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_and3:
(* AND(X, AND(X, Y)) = AND(X,Y) *)
check_rule "DUP1 SWAP2 SWAP1 AND SWAP1 AND"
           "AND"
           OPT_and_and.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_and3':
(* AND(X, AND(X, Y)) = AND(Y,X) *)
check_rule "DUP1 SWAP2 SWAP1 AND SWAP1 AND"
           "SWAP1 AND"
           OPT_and_and.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_and4:
(* AND(AND(Y, X), X) = AND(X,Y) *)
check_rule "DUP1 SWAP2 AND SWAP1 AND"
           "AND"
           OPT_and_and.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_and4':
(* AND(AND(Y, X), X) = AND(Y,X) *)
check_rule "DUP1 SWAP2 AND SWAP1 AND"
           "SWAP1 AND"
           OPT_and_and.
Proof. unfold check_rule. intuition. Qed.

Example ex_not_not:
(* NOT(NOT(X)) = X *)
check_rule "NOT NOT"
           ""
           OPT_not_not.
Proof. unfold check_rule. intuition. Qed.

Example ex_eval1:
(* eval(op,X) = op(X) *)
check_rule "PUSH1 0x0 NOT"
           "PUSH32 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
           OPT_eval.
Proof. unfold check_rule. intuition. Qed.
Example ex_eval2:
(* eval(op,X,Y) = op(X,Y) *)
check_rule "PUSH1 0x3 PUSH1 0x2 ADD"
           "PUSH1 0x5"
           OPT_eval.
Proof. unfold check_rule. intuition. Qed.

Example ex_add_zero1:
(* ADD(X,0) = X *)
check_rule "PUSH1 0x0 SWAP1 ADD"
           ""
           OPT_add_zero.
Proof. unfold check_rule. intuition. Qed.
Example ex_add_zero2:
check_rule "PUSH1 0x0 ADD"
           ""
           OPT_add_zero.
Proof. unfold check_rule. intuition. Qed.

(*
(* Optimization not included *)
Example ex_add_add_1:
(* ADD(ADD(3,x),2) *)
check_rule "PUSH1 0x2 SWAP1 PUSH1 0x3 ADD ADD"
           "PUSH1 0x5 ADD"
           OPT_add_add.
Proof. unfold check_rule. intuition. Qed.

Example ex_add_add_2:
(* ADD(ADD(x,3),2) *)
check_rule "PUSH1 0x2 PUSH1 0x3 SWAP2 ADD ADD"
           "PUSH1 0x5 ADD"
           OPT_add_add.
Proof. unfold check_rule. intuition. Qed.

Example ex_add_add_3:
(* ADD(3, ADD(x,2)) *)
check_rule "PUSH1 0x2 SWAP1 ADD PUSH1 0x3 ADD"
           "PUSH1 0x5 ADD"
           OPT_add_add.
Proof. unfold check_rule. intuition. Qed.

Example ex_add_add_4:
(* ADD(3, ADD(2,x)) *)
check_rule "PUSH1 0x2 ADD PUSH1 0x3 ADD"
           "PUSH1 0x5 ADD"
           OPT_add_add.
Proof. unfold check_rule. intuition. Qed.
*)

End OptimizationRuleTests.


Module EVMStackOpTests.

(* Tests for evm_shr because of their alternative definition *)
Example ex_shr_1: evm_shr empty_externals [WZero; WOne] = WOne.
Proof.
reflexivity.
Qed.

Example ex_shr_2: 
evm_shr empty_externals [WZero; natToWord EVMWordSize 555] = 
  natToWord EVMWordSize 555.
Proof.
reflexivity.
Qed.

Example ex_shr_3: 
evm_shr empty_externals [natToWord EVMWordSize 10; natToWord EVMWordSize 1024] = 
  WOne.
Proof.
reflexivity.
Qed.

Example ex_shr_4: 
evm_shr empty_externals [natToWord EVMWordSize 11; natToWord EVMWordSize 1024] = 
  WZero.
Proof.
reflexivity.
Qed.

Example ex_shr_5: 
evm_shr empty_externals [WOne; natToWord EVMWordSize 2] = 
  WOne.
Proof.
reflexivity.
Qed.

Example ex_shr_6: 
evm_shr empty_externals [natToWord EVMWordSize 4; natToWord EVMWordSize 255] = 
natToWord EVMWordSize 15.
Proof.
reflexivity.
Qed.

Example ex_shr_7: 
evm_shr empty_externals [natToWord EVMWordSize 16; WZero] = WZero.
Proof.
reflexivity.
Qed.

Example ex_shr_8: 
evm_shr empty_externals [natToWord EVMWordSize 255; WOne] = WZero.
Proof.
reflexivity.
Qed.

Example ex_shr_9: 
evm_shr empty_externals [natToWord EVMWordSize 547; WOne] = WZero.
Proof.
reflexivity.
Qed.

End EVMStackOpTests.





Module SymbExecTests.
  
(*Compute (evm_exec_block_c [PUSH 1 0x7; PUSH 1 0x1; OpInstr ADD] 
                          empty_state
                          evm_stack_opm).
2, SymMETAPUSH' 5 53)*)
(* 
   Some (ExState stk=[0x8] 
                 mem=fun _ : N => 0 
                 strg=fun _ : N => 0 
                 empty_externals
        ) 
*)

(*
Compute (evm_sym_exec trivial_smemory_updater trivial_sstorage_updater trivial_mload_solver
  trivial_sload_solver [PUSH 1 0x7; PUSH 1 0x1; OpInstr ADD] 0 evm_stack_opm).
(* 
   Some (SymExState instk_h=0 
                    stk=[FreshVar 0] 
                    mem=[] 
                    strg=[] 
                    exts=SymExts
                    smap=(SymMap 1 [(0, SymOp ADD [0x1;0x7])])
        )
*)



Compute (evm_exec_block_c [OpInstr ADD]  
                          (make_st [WOne; WOne; WOne] 
                                   empty_memory empty_storage empty_externals)
                          evm_stack_opm).
(*
   Some (ExState stk=[0x2;0x1] 
                 mem=fun _ : N => 0 
                 strg=fun _ : N => 0 
                 empty_externals
        ) 
*)

Compute (evm_sym_exec trivial_smemory_updater trivial_sstorage_updater trivial_mload_solver
  trivial_sload_solver [OpInstr ADD] 3 evm_stack_opm).
(* 
  Some (SymExState instk_h=3 
                   stk=[FreshVar 0; InStackVar 2] 
                   mem=[] 
                   strg=[] 
                   exts=SymExts
                   smap=(SymMap 1 [(0, SymOp ADD [InStackVar 0; InStackVar 1])])
       )
*)






Compute (evm_exec_block_c [PUSH 1 0xFF; PUSH 1 0x0; MSTORE; PUSH 1 0x0; MLOAD]  
                          (make_st [WOne] 
                                   empty_memory empty_storage empty_externals)
                          evm_stack_opm).
(*
   Some (ExState stk=[0xFF;0x1]
                 mem=fun 0=>0x0, 1=>0x0, 2=0x0, ..., 31=>0xFF, _=>0x0
                 strg=fun N=>0x0
                 empty_externals
*)

Compute (evm_sym_exec trivial_smemory_updater trivial_sstorage_updater trivial_mload_solver
  trivial_sload_solver [PUSH 1 0xFF; PUSH 1 0x0; MSTORE; PUSH 1 0x0; MLOAD] 1 evm_stack_opm).
(*
   Some (SymExState instk_h=1 
                    stk=[FreshVar 0; InStackVar 0]
                    mem=[U_MSTORE addr=0x0 val=0xFF]
                    strg=[]
                    exts=SymExts
                    smap=SymMap 1 [(0, SymMLOAD 0x0 [U_MSTORE 0x0 0xFF])]
                      >> smap could be simplified <<
        )
*)




Definition storage_test (key:N) : EVMWord :=
match key with
| 0%N => natToWord EVMWordSize 0xFF
| _ => WZero
end.

Compute (evm_exec_block_c [PUSH 1 0x0; SLOAD; PUSH 1 0x7; MSTORE]  
                          (make_st [WOne] 
                                   empty_memory 
                                   storage_test
                                   empty_externals)
                          evm_stack_opm).
(*
   Some (ExState stk=[0x1]
                 mem=fun 0=>0x0, 1=>0x0, 2=0x0, ..., 31=>0xFF, _=>0x0
                 strg=fun 0=>0xFF  _=>0x0
                 empty_externals
        )
*)

Compute (evm_sym_exec trivial_smemory_updater trivial_sstorage_updater trivial_mload_solver
  trivial_sload_solver [PUSH 1 0x0; SLOAD; PUSH 1 0x7; MSTORE] 1 evm_stack_opm).
(*
   Some (SymExState instk_h=1 
                    stk=[InStackVar 0]
                    mem=[U_MSTORE 0x7 (FreshVar 0)]
                    strg=[]
                    smap=SymMap 1 [(0,SymSLOAD 0x0)]
       )
*)
*)

End SymbExecTests.


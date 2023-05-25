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

Require Import FORVES.optimizations.add_zero.
Import Opt_add_zero.
Require Import FORVES.optimizations.eval.
Import Opt_eval.
Require Import FORVES.optimizations.not_not.
Import Opt_not_not.
Require Import FORVES.optimizations.and_and1.
Import Opt_and_and1.
Require Import FORVES.optimizations.and_and2.
Import Opt_and_and2.
Require Import FORVES.optimizations.and_origin.
Import Opt_and_origin.
Require Import FORVES.optimizations.mul_shl.
Import Opt_mul_shl.
Require Import FORVES.optimizations.div_shl.
Import Opt_div_shl.
Require Import FORVES.optimizations.shr_zero_x.
Import Opt_shr_zero_x.
Require Import FORVES.optimizations.shr_x_zero.
Import Opt_shr_x_zero.
 Require Import FORVES.optimizations.eq_zero.
Import Opt_eq_zero.
Require Import FORVES.optimizations.sub_x_x.
Import Opt_sub_x_x.
Require Import FORVES.optimizations.and_zero.
Import Opt_and_zero.
Require Import FORVES.optimizations.div_one.
Import Opt_div_one.
Require Import FORVES.optimizations.lt_x_one.
Import Opt_lt_x_one.
Require Import FORVES.optimizations.gt_one_x.
Import Opt_gt_one_x.
Require Import FORVES.optimizations.and_address.
Import Opt_and_address.
Require Import FORVES.optimizations.mul_one.
Import Opt_mul_one.
Require Import FORVES.optimizations.iszero_gt.
Import Opt_iszero_gt.
Require Import FORVES.optimizations.eq_iszero.
Import Opt_eq_iszero.

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


Module Tests.

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
check_rule "SWAP1 DUP2 AND AND"
           "AND"
           OPT_and_and.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_and2:
check_rule "DUP2 SWAP1 AND AND"
           "AND"
           OPT_and_and.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_and3:
check_rule "SWAP1 DUP2 AND SWAP1 AND"
           "AND"
           OPT_and_and.
Proof. unfold check_rule. intuition. Qed.
Example ex_and_and4:
check_rule "DUP2 AND SWAP1 AND"
           "AND"
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

End Tests.




Module Debug.


  (* string to block that always succeed *)
  Definition str2block (s : string) : block :=
    match parse_block s with
    | None => []
    | Some b => b
    end.
    
Compute 
(str2block "ADD PUSH1 0x20 ADD MLOAD PUSH32 0xFF00000000000000000000000000000000000000000000000000000000000000 AND DUP5 DUP5 PUSH1 0x64 DUP2 PUSH1 0x1c").
  

Inductive sstack_val_dbg : Type :=
| Val' (val: N)
| InStackVar' (var: nat)
| FreshVar' (var: nat).

Definition sstack_dbg : Type := list sstack_val_dbg.

Definition smemory_dbg : Type := memory_updates sstack_val_dbg.

Definition sstorage_dbg : Type := storage_updates sstack_val_dbg.

Inductive smap_value_dbg : Type :=
| SymBasicVal' (val: sstack_val_dbg)
| SymMETAPUSH' (cat: N) (val: N)
| SymOp' (label : stack_op_instr) (args : sstack_dbg)
| SymMLOAD' (offset: sstack_val_dbg) (smem : smemory_dbg)
| SymSLOAD' (key: sstack_val_dbg) (sstrg : sstorage_dbg)
| SymSHA3' (offset: sstack_val_dbg) (size: sstack_val_dbg) (smem : smemory_dbg).

Definition sbinding_dbg : Type := nat*smap_value_dbg.
Definition sbindings_dbg : Type := list sbinding_dbg.
Inductive smap_dbg := SymMap' (maxid : nat) (bindings: sbindings_dbg).

Inductive sstate_dbg :=
| SymExState' (instk_height: nat) (sstk: sstack_dbg) (smem: smemory_dbg) 
              (sstg: sstorage_dbg) (sctx : scontext) (sm: smap_dbg).



Definition sstack_val_to_dbg (v: sstack_val) : sstack_val_dbg :=
match v with
| Val v => Val' (wordToN v)
| InStackVar var => InStackVar' var
| FreshVar var => FreshVar' var
end.

Definition sstack_to_dbg (s: sstack) : sstack_dbg :=
map sstack_val_to_dbg s.

Definition memory_update_to_dbg (mu: memory_update sstack_val) : 
  memory_update sstack_val_dbg :=
match mu with
| U_MSTORE _ offset value => U_MSTORE sstack_val_dbg (sstack_val_to_dbg offset)
                                    (sstack_val_to_dbg value)
| U_MSTORE8 _ offset value => U_MSTORE8  sstack_val_dbg (sstack_val_to_dbg offset)
                                    (sstack_val_to_dbg value)
end.

Definition smemory_to_dbg (mem: smemory) : smemory_dbg :=
map memory_update_to_dbg mem.

Definition sstorage_update_to_dbg (su: storage_update sstack_val) : 
  storage_update sstack_val_dbg :=
match su with
| U_SSTORE _ key value => U_SSTORE sstack_val_dbg (sstack_val_to_dbg key)
                                    (sstack_val_to_dbg value)
end.

Definition sstorage_to_dbg (sto: sstorage) : sstorage_dbg :=
map sstorage_update_to_dbg sto.

Definition smap_value_to_dbg (smv: smap_value) : smap_value_dbg :=
match smv with
| SymBasicVal v => SymBasicVal' (sstack_val_to_dbg v)
| SymMETAPUSH cat v => SymMETAPUSH' cat v
| SymOp label args => SymOp' label (sstack_to_dbg args)
| SymMLOAD offset smem => SymMLOAD' (sstack_val_to_dbg offset) 
                                    (smemory_to_dbg smem)
| SymSLOAD key sstrg => SymSLOAD' (sstack_val_to_dbg key)
                                  (sstorage_to_dbg sstrg)
| SymSHA3 offset size smem => SymSHA3' (sstack_val_to_dbg offset)
                                       (sstack_val_to_dbg size)
                                       (smemory_to_dbg smem)
end.

Definition sbinding_to_dbg (b: sbinding) : sbinding_dbg :=
match b with
| (n,v) => (n, smap_value_to_dbg v)
end.

Definition sbindings_to_dbg (bs: sbindings) : sbindings_dbg :=
map sbinding_to_dbg bs.

Definition smap_to_dbg (sm: smap) : smap_dbg :=
match sm with
| SymMap m bs => SymMap' m (sbindings_to_dbg bs)
end.

Definition sstate_to_dbg (s: sstate) : sstate_dbg :=
match s with
| SymExState instk_height sstk smem sstg sctx sm =>
    SymExState' instk_height (sstack_to_dbg sstk) (smemory_to_dbg smem)
                (sstorage_to_dbg sstg) sctx (smap_to_dbg sm)
end.




Definition evm_eq_block_chkr'_dbg
  (memory_updater: smemory_updater_ext_type) 
  (storage_updater: sstorage_updater_ext_type)
  (mload_solver: mload_solver_ext_type) 
  (sload_solver: sload_solver_ext_type)
  (sstack_value_cmp_ext: sstack_val_cmp_ext_2_t)
  (smemory_cmp_ext: smemory_cmp_ext_t)
  (sstorage_cmp_ext: sstorage_cmp_ext_t)
  (sha3_cmp_ext: sha3_cmp_ext_t)
  (*(opt: optim)*)
  (opt_pipeline: opt_pipeline)
  (opt_step_rep: nat)
  (opt_pipeline_rep: nat)
  (***)
  (opt_p p: block)
  (k: nat) 
  : (bool * option sstate_dbg * option sstate_dbg) :=
  let sstack_value_cmp_1 := sstack_value_cmp_ext smemory_cmp_ext sstorage_cmp_ext sha3_cmp_ext in
  let memory_updater' := memory_updater sstack_value_cmp_1 in
  let storage_updater' := storage_updater sstack_value_cmp_1 in
  let mload_solver' := mload_solver sstack_value_cmp_1 in
  let sload_solver' := sload_solver sstack_value_cmp_1 in

  match evm_sym_exec memory_updater' storage_updater' mload_solver' sload_solver' opt_p k evm_stack_opm with
  | None => (false, None, None)
  | Some sst_opt => 
      match evm_sym_exec memory_updater' storage_updater' mload_solver' sload_solver' p k evm_stack_opm with 
      | None => (false, Some (sstate_to_dbg sst_opt), None)
      | Some sst_p => (* Builds optimization *)
                      let maxid := S (max (get_maxidx_smap (get_smap_sst sst_opt)) (get_maxidx_smap (get_smap_sst sst_p))) in
                      let sstack_value_cmp := sstack_value_cmp_1 maxid in
                      let opt := apply_opt_n_times_pipeline_k opt_pipeline 
                                 sstack_value_cmp opt_step_rep 
                                 opt_pipeline_rep in
                     (* opt is sound if sstack_value_cmp is "safe_sstack_val_cmp" *)
  
                      let (sst_opt', _) := opt sst_opt in 
                      let (sst_p',   _) := opt sst_p in
                      let d := S (max (get_maxidx_smap (get_smap_sst sst_opt')) (get_maxidx_smap (get_smap_sst sst_p'))) in
                      let sstack_value_cmp := sstack_value_cmp_1 d in
                      let smemory_cmp := smemory_cmp_ext sstack_value_cmp in
                      let sstorage_cmp := sstorage_cmp_ext sstack_value_cmp in
                      (sstate_cmp sstack_value_cmp smemory_cmp sstorage_cmp sst_p' sst_opt' evm_stack_opm,
                       Some (sstate_to_dbg sst_opt'), Some (sstate_to_dbg sst_p'))
      end
  end.
  

Definition evm_eq_block_chkr_lazy_dbg
  (memory_updater_tag: available_smemory_updaters) 
  (storage_updater_tag: available_sstorage_updaters)
  (mload_solver_tag: available_mload_solvers) 
  (sload_solver_tag: available_sload_solvers)
  (sstack_value_cmp_tag: available_sstack_val_cmp)
  (memory_cmp_tag: available_memory_cmp)
  (storage_cmp_tag: available_storage_cmp)
  (sha3_cmp_tag: available_sha3_cmp)
  
  (*(opt: optim)*)
  (optimization_steps: list_opt_steps)
  (opt_step_rep: nat)
  (opt_pipeline_rep: nat) :=
  
  match get_smemory_updater memory_updater_tag with
  | SMemUpdater memory_updater _ =>
      match get_sstorage_updater storage_updater_tag with
      | SStrgUpdater storage_updater _ =>
          match get_mload_solver mload_solver_tag with
          | MLoadSolver mload_solver _ =>
             match get_sload_solver sload_solver_tag with
             | SLoadSolver sload_solver _ =>
                 match get_sstack_val_cmp sstack_value_cmp_tag with
                 | SStackValCmp sstack_val_cmp _ _ =>
                     match get_memory_cmp memory_cmp_tag with
                     | SMemCmp memory_cmp _ =>
                         match get_storage_cmp storage_cmp_tag with 
                         | SStrgCmp storage_cmp _ =>
                             match get_sha3_cmp sha3_cmp_tag with
                               | SHA3Cmp sha3_cmp _ => 
                                   match get_pipeline optimization_steps with
                                   | opt_pipeline =>
                                       fun  (opt_p p: block) (k: nat) =>
                                         evm_eq_block_chkr'_dbg memory_updater storage_updater mload_solver sload_solver sstack_val_cmp memory_cmp storage_cmp sha3_cmp opt_pipeline opt_step_rep opt_pipeline_rep opt_p p k
                                   end    
                             end
                         end
                     end
                 end
             end
          end
      end
  end.


(* From GASOL_gas_simp #1256*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 [PUSH 1 0x40; MLOAD; PUSH 1 0x40; MLOAD; OpInstr SUB]
 [PUSH 1 0x0]
 (*[PUSH 20 0xffffffffffffffffffffffffffffffffffffffff; OpInstr AND; 
  PUSH 32 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925;
  PUSH 1 0x0; PUSH 1 0x40; MLOAD]
 [PUSH 1 0x1; PUSH 1 0x1; PUSH 1 0xa0; OpInstr SHL; OpInstr SUB; OpInstr AND;
  PUSH 32 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925;
  PUSH 1 0x40; MLOAD; PUSH 1 0x40; MLOAD; DUP 1; SWAP 2; OpInstr SUB; SWAP 1]*)
 1).


Compute
  let memory_updater := basic_smemory_updater in
  let storage_updater := basic_sstorage_updater in
  let mload_solver := basic_mload_solver in
  let sload_solver := basic_sload_solver in
  let sstack_value_cmp_ext := basic_compare_sstack_val in
  let smemory_cmp_ext := basic_memory_cmp in
  let sstorage_cmp_ext := basic_storage_cmp in
  let sha3_cmp_ext := trivial_sha3_cmp in
  let sstack_value_cmp_1 := sstack_value_cmp_ext smemory_cmp_ext sstorage_cmp_ext sha3_cmp_ext in
  let sstack_value_cmp := sstack_value_cmp_1 2 in
  sstack_value_cmp (FreshVar 0) (FreshVar 1) 3 [(2, SymOp SUB [FreshVar 1; FreshVar 0]); (1, SymMLOAD (Val (natToWord 256 64)) []); (0, SymMLOAD (Val (natToWord 256 64)) [])] 3 [(2, SymOp SUB [FreshVar 1; FreshVar 0]); (1, SymMLOAD (Val (natToWord 256 64)) []); (0, SymMLOAD (Val (natToWord 256 64)) [])] 3 evm_stack_opm.
  
  
Compute 
  let memory_updater := basic_smemory_updater in
  let storage_updater := basic_sstorage_updater in
  let mload_solver := basic_mload_solver in
  let sload_solver := basic_sload_solver in
  let sstack_value_cmp_ext := basic_compare_sstack_val in
  let smemory_cmp_ext := basic_memory_cmp in
  let sstorage_cmp_ext := basic_storage_cmp in
  let sha3_cmp_ext := trivial_sha3_cmp in
  let sstack_value_cmp_1 := sstack_value_cmp_ext smemory_cmp_ext sstorage_cmp_ext sha3_cmp_ext in
  let sstack_value_cmp := sstack_value_cmp_1 2 in
  let sb := [(2, SymOp SUB [FreshVar 1; FreshVar 0]); 
             (1, SymMLOAD (Val (natToWord 256 64)) []); 
             (0, SymMLOAD (Val (natToWord 256 64)) [])] in

  optimize_sub_x_x_sbinding (SymOp SUB [FreshVar 1; FreshVar 0]) 
                            sstack_value_cmp
                            sb
                            2
                            0
                            evm_stack_opm.


Compute (wordToN two_exp_160_minus_1).
(* From GASOL_gas_simp #846 *)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 20 20
 (*
 [OpInstr ADDRESS]
 
 [OpInstr ADDRESS; PUSH 1 0x1;PUSH 1 0x1; PUSH 1 0xa0; OpInstr SHL; OpInstr SUB; 
  OpInstr AND]
 [OpInstr ADDRESS; PUSH 1 0x1; PUSH 1 0xa0; PUSH 1 0x2; OpInstr EXP; 
  OpInstr SUB; OpInstr AND]*)

 [PUSH 20 0xffffffffffffffffffffffffffffffffffffffff; OpInstr AND; 
  OpInstr ADDRESS; PUSH 32 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
  PUSH 1 0x13; PUSH 1 0x40; MLOAD; PUSH 9 0x3635c9adc5dea00000; DUP 2]
 [PUSH 1 0x1; PUSH 1 0x1; PUSH 1 0xa0; OpInstr SHL; OpInstr SUB; OpInstr AND;
  OpInstr ADDRESS; PUSH 1 0x1; PUSH 1 0x1; PUSH 1 0xa0; OpInstr SHL; OpInstr SUB;
  OpInstr AND; PUSH 32 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
  PUSH 9 0x3635c9adc5dea00000; PUSH 1 0x40; MLOAD; PUSH 1 0x13; SWAP 2; DUP 2]

 1).
 
Compute (
let val := SymOp AND [FreshVar 5; FreshVar 3] in
let fcmp := basic_compare_sstack_val basic_memory_cmp basic_storage_cmp 
             trivial_sha3_cmp 1 in
let sb := [(2, SymOp AND [FreshVar 1; FreshVar 0]);
           (1,
               SymBasicVal
                 (Val (two_exp_160_minus_1)));
           (0, SymOp ADDRESS [])] in
let maxid := 3 in
let instk_height := 1 in
let ops := evm_stack_opm in

(*ollow_in_smap (FreshVar 1) maxid sb).*)
(*fcmp (FreshVar 1) (Val two_exp_160_minus_1) maxid sb maxid sb instk_height ops).*)

optimize_and_address_sbinding (SymOp AND [FreshVar 0; FreshVar 1]) 
  fcmp sb maxid instk_height ops).
  
  
(*
GASOL size simp
# serial number: 4847
# csv: 0xfeff9661617cbba5a2ed3a69000f4bf1e266be71.sol.csv
# block id: Kitsunami_run_code_of_0_block_346_0
# rules applied: ['DIV(X,SHL(Y,1))']
POP PUSH1 0x6 SLOAD PUSH1 0xa0 SHR PUSH1 0xff AND ISZERO
POP PUSH1 0x6 SLOAD PUSH1 0x1 PUSH1 0xa0 SHL SWAP1 DIV PUSH1 0xff AND ISZERO
1
*)  
(* Works with all_optimization_steps' but not with all_optimization_steps *)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps' 10 10
 [POP; PUSH 1 0x6; SLOAD; PUSH 1 0xa0; OpInstr SHR; PUSH 1 0xff; OpInstr AND; 
  OpInstr ISZERO]
 [POP; PUSH 1 0x6; SLOAD; PUSH 1 0x1; PUSH 1 0xa0; OpInstr SHL; SWAP 1;
  OpInstr DIV; PUSH 1 0xff; OpInstr AND; OpInstr ISZERO]
 1).
 
 
(*
GASOL gas simp
# serial number: 932
# csv: 0x54adf7604d25ac9476fc467e93dfdb29af1077ee.sol.csv
# block id: AiDay_run_code_of_0_block_164_0
# rules applied: ["EVAL ('160', '1', 'shl')"]
PUSH21 0x10000000000000000000000000000000000000000 PUSH1 0x11 SLOAD DIV PUSH1 0xff AND ISZERO PUSH1 0xd6
PUSH1 0x11 SLOAD PUSH1 0x1 PUSH1 0xa0 SHL SWAP1 DIV PUSH1 0xff AND ISZERO PUSH1 0xd6
0
*)
(* Works with all_optimization_steps but not with all_optimization_steps' *)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 [PUSH 21 0x10000000000000000000000000000000000000000; PUSH 1 0x11; SLOAD;
  OpInstr DIV; PUSH 1 0xff; OpInstr AND; OpInstr ISZERO; PUSH 1 0xd6]
 [PUSH 1 0x11; SLOAD; PUSH 1 0x1; PUSH 1 0xa0; OpInstr SHL; SWAP 1; 
  OpInstr DIV; PUSH 1 0xff; OpInstr AND; OpInstr ISZERO; PUSH 1 0xd6]
 1).
 


(* *********************************** *)
(* Blocks from solc_semantic_tests.txt *)
(* *********************************** *)


(* RULE: ADD(X, SUB(Y,X)) = Y *) 
(* Lemma: wminus_wplus_undo *)
(* Probably blocks #213 -- #222 *)
(*
# 213
PUSH1 0xe PUSH1 0xf CALLDATASIZE PUSH1 0x4 PUSH1 0x10
PUSH1 0xe PUSH1 0x4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH1 0xf SWAP2 SWAP1 PUSH1 0x10
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 [PUSH 1 0xe; PUSH 1 0xf; OpInstr CALLDATASIZE; PUSH 1 0x4; PUSH 1 0x10]
 [PUSH 1 0xe; PUSH 1 0x4; DUP 1; OpInstr CALLDATASIZE; OpInstr SUB; DUP 2; 
  OpInstr ADD; SWAP 1; PUSH 1 0xf; SWAP 2; SWAP 1; PUSH 1 0x10]
 0).
 

(* RULE: ISZERO(ISZERO(X)) = GT(X,0) *)
(* 
# 243
POP PUSH8 0xDE0B6B3A7640000 DUP1 DUP3 MOD DUP1 ISZERO ISZERO SWAP2 SUB MUL ADD SWAP1
PUSH8 0xDE0B6B3A7640000 DUP3 MOD DUP1 PUSH8 0xDE0B6B3A7640000 SUB PUSH1 0x0 DUP3 GT DUP2 MUL DUP5 ADD SWAP3 POP POP POP SWAP2 SWAP1 POP
500 
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 [POP; PUSH 8 0xDE0B6B3A7640000; DUP 1; DUP 3; OpInstr MOD; DUP 1; OpInstr ISZERO;
  OpInstr ISZERO; SWAP 2; OpInstr SUB; OpInstr MUL; OpInstr ADD; SWAP 1]
 [PUSH 8 0xDE0B6B3A7640000; DUP 3; OpInstr MOD; DUP 1; PUSH 8 0xDE0B6B3A7640000;
  OpInstr SUB; PUSH 1 0x0; DUP 3; OpInstr GT; DUP 2; OpInstr MUL; DUP 5; 
  OpInstr ADD; SWAP 3; POP; POP; POP; SWAP 2; SWAP 1; POP]
 3).
 
 
(* RULES: ADD(X,ADD(Y,Z)) = ADD(ADD(X,Y),Z) 
          SHR(D, SHL(D, SHR(D, V))) = SHR(D, V)
          AND(2^N-1, SHR(256-N, X) = SHR(256-N, X)
*)
(* 
# 1049
ADD PUSH1 0x20 ADD MLOAD PUSH1 0xF8 SHR
PUSH1 0x20 ADD ADD MLOAD PUSH1 0xF8 SHR PUSH1 0xF8 SHL PUSH1 0xF8 SHR PUSH1 0xFF AND
500 
*) 
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 [OpInstr ADD; PUSH 1 0x20; OpInstr ADD; MLOAD; PUSH 1 0xF8; OpInstr SHR]
 [PUSH 1 0x20; OpInstr ADD; OpInstr ADD; MLOAD; PUSH 1 0xF8; OpInstr SHR; 
  PUSH 1 0xF8; OpInstr SHL; PUSH 1 0xF8; OpInstr SHR; PUSH 1 0xFF; OpInstr AND]
 2).


(* RULES: ADD(X,ADD(Y,Z)) = ADD(ADD(X,Y),Z) 
          SHR(D, SHL(D, SHR(D, V))) = SHR(D, V)
          AND(2^N-1, SHR(256-N, X) = SHR(256-N, X)
          AND(2^A-1, AND(2^B-1, X)) = AND(2^N-1, X)
              where A,B constant values <= 256 and N = min(A, B)
*) 
(*
# 1052
ADD PUSH1 0x20 ADD MLOAD PUSH1 0xF8 SHR SWAP1 SHL
PUSH1 0x20 ADD ADD MLOAD PUSH1 0xF8 SHR PUSH1 0xF8 SHL PUSH1 0xF8 SHR PUSH1 0xFF AND PUSH3 0xFFFFFF AND SWAP1 SHL
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 [OpInstr ADD; PUSH 1 0x20; OpInstr ADD; MLOAD; PUSH 1 0xF8; OpInstr SHR;
  SWAP 1; OpInstr SHL]
 [PUSH 1 0x20; OpInstr ADD; OpInstr ADD; MLOAD; PUSH 1 0xF8; OpInstr SHR; 
  PUSH 1 0xF8; OpInstr SHL; PUSH 1 0xF8; OpInstr SHR; PUSH 1 0xFF; OpInstr AND;
  PUSH 3 0xFFFFFF; OpInstr AND; SWAP 1; OpInstr SHL]
 3).
 

(* RULES: ADD(X,ADD(Y,Z)) = ADD(ADD(X,Y),Z) 
          SHR(D, SHL(D, SHR(D, V))) = SHR(D, V)
          AND(2^N-1, SHR(256-N, X) = SHR(256-N, X)
          AND(2^A-1, AND(2^B-1, X)) = AND(2^N-1, X)
              where A,B constant values <= 256 and N = min(A, B)
*)
(*
# 1054
ADD PUSH1 0x20 ADD MLOAD PUSH1 0x55 SWAP3 SWAP2 PUSH1 0xF8 SWAP2 SWAP1 SWAP2 SHR SWAP1 SHL PUSH1 0x56
PUSH1 0x20 ADD ADD MLOAD PUSH1 0xF8 SHR PUSH1 0xF8 SHL PUSH1 0xF8 SHR PUSH1 0xFF AND PUSH3 0xFFFFFF AND SWAP1 SHL PUSH1 0x55 SWAP2 SWAP1 PUSH1 0x56
500
*) 
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "ADD PUSH1 0x20 ADD MLOAD PUSH1 0x55 SWAP3 SWAP2 PUSH1 0xF8 SWAP2 SWAP1 SWAP2 SHR SWAP1 SHL PUSH1 0x56")
 (str2block "PUSH1 0x20 ADD ADD MLOAD PUSH1 0xF8 SHR PUSH1 0xF8 SHL PUSH1 0xF8 SHR PUSH1 0xFF AND PUSH3 0xFFFFFF AND SWAP1 SHL PUSH1 0x55 SWAP2 SWAP1 PUSH1 0x56")
 4).


(* RULES: ADD(X,ADD(Y,Z)) = ADD(ADD(X,Y),Z) 
          AND((2^256-1)-(2^N-1), X) = SHL(N, SHR(N, X))
*)
(*
# 1060
ADD PUSH1 0x20 ADD MLOAD PUSH32 0xFF00000000000000000000000000000000000000000000000000000000000000 AND DUP5 DUP5 PUSH1 0x64 DUP2 PUSH1 0x1c
PUSH1 0x20 ADD ADD MLOAD PUSH1 0xF8 SHR PUSH1 0xF8 SHL DUP5 DUP5 DUP1 PUSH1 0x64 SWAP1 PUSH1 0x1c
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 [OpInstr ADD; PUSH 1 0x20; OpInstr ADD; MLOAD; 
  PUSH 32 0xFF00000000000000000000000000000000000000000000000000000000000000;
  OpInstr AND; DUP 5; DUP 5; PUSH 1 0x64; DUP 2; PUSH 1 0x1c]
 [PUSH 1 0x20; OpInstr ADD; OpInstr ADD; MLOAD; PUSH 1 0xF8; OpInstr SHR;
  PUSH 1 0xF8; OpInstr SHL; DUP 5; DUP 5; DUP 1; PUSH 1 0x64; SWAP 1;
  PUSH 1 0x1c]
 6).
 
 

(* RULE: SHL(0,X) = X *)
(*
# 1196
SWAP3 POP
PUSH1 0x0 SHL SWAP3 POP
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "SWAP3 POP")
 (str2block "PUSH1 0x0 SHL SWAP3 POP")
 4).
 

(* RULE: SUB(X,0) = X *)
(*
# 9
SWAP1 POP DUP1 DUP1 PUSH1 0x8a JUMPI
SWAP1 POP DUP1 PUSH1 0x0 DUP2 SUB PUSH1 0x8a JUMPI
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "SWAP1 POP DUP1 DUP1 PUSH1 0x8a JUMPI")
 (str2block "SWAP1 POP DUP1 PUSH1 0x0 DUP2 SUB PUSH1 0x8a JUMPI")
 2).


(* RULE: SUB(X,0) = X *)
(*
# 11
SWAP1 POP DUP1 DUP1 PUSH1 0x8a JUMPI
SWAP1 POP DUP1 PUSH1 0x0 DUP2 SUB PUSH1 0x8a JUMPI
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "SWAP1 POP DUP1 DUP1 PUSH1 0x8a JUMPI")
 (str2block "SWAP1 POP DUP1 PUSH1 0x0 DUP2 SUB PUSH1 0x8a JUMPI")
 2).
 

(* RULE: (X+Y)+Z = (Z+X)+Y *)
(* 
# 21
PUSH1 0x20 SWAP1 DUP2 MUL SWAP2 SWAP1 SWAP2 ADD ADD MLOAD MLOAD PUSH1 0x0 PUSH1 0xed
PUSH1 0x20 MUL PUSH1 0x20 ADD ADD MLOAD PUSH1 0x0 ADD MLOAD PUSH1 0x0 PUSH1 0x2 DUP2 LT PUSH1 0xed JUMPI
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "PUSH1 0x20 SWAP1 DUP2 MUL SWAP2 SWAP1 SWAP2 ADD ADD MLOAD MLOAD PUSH1 0x0 PUSH1 0xed")
 (str2block "PUSH1 0x20 MUL PUSH1 0x20 ADD ADD MLOAD PUSH1 0x0 ADD MLOAD PUSH1 0x0 PUSH1 0x2 DUP2 LT PUSH1 0xed JUMPI")
 2).


(* RULE: (X+Y)+Z = (Z+X)+Y *)
(*
# 24
PUSH1 0x20 SWAP1 DUP2 MUL SWAP2 SWAP1 SWAP2 ADD ADD MLOAD MLOAD PUSH1 0x1 PUSH1 0xf5
PUSH1 0x20 MUL PUSH1 0x20 ADD ADD MLOAD PUSH1 0x0 ADD MLOAD PUSH1 0x1 PUSH1 0x2 DUP2 LT PUSH1 0xf5 JUMPI
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "PUSH1 0x20 SWAP1 DUP2 MUL SWAP2 SWAP1 SWAP2 ADD ADD MLOAD MLOAD PUSH1 0x1 PUSH1 0xf5")
 (str2block "PUSH1 0x20 MUL PUSH1 0x20 ADD ADD MLOAD PUSH1 0x0 ADD MLOAD PUSH1 0x1 PUSH1 0x2 DUP2 LT PUSH1 0xf5 JUMPI")
 2).
 


(* RULE: SUB(X,0) = X *)
(*
# 31
SWAP1 POP DUP1 DUP1 PUSH2 0x10d JUMPI
SWAP1 POP DUP1 PUSH1 0x0 DUP2 SUB PUSH2 0x10d JUMPI
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "SWAP1 POP DUP1 DUP1 PUSH2 0x10d JUMPI")
 (str2block "SWAP1 POP DUP1 PUSH1 0x0 DUP2 SUB PUSH2 0x10d JUMPI")
 2).



(* RULE: ADD(X,1) = SUB(X, 2^256-1) *)
(*
# 44
PUSH1 0x0 PUSH1 0x1 DUP3 ADD PUSH2 0x17b JUMPI
PUSH1 0x0 DUP1 NOT DUP3 SUB PUSH2 0x17b JUMPI
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "PUSH1 0x0 PUSH1 0x1 DUP3 ADD PUSH2 0x17b JUMPI")
 (str2block "PUSH1 0x0 DUP1 NOT DUP3 SUB PUSH2 0x17b JUMPI")
 1).
 
 
(* RULE: (X+Y)+Z = (Z+X)+Y *)
(*
# 76
PUSH1 0x20 SWAP1 DUP2 MUL SWAP2 SWAP1 SWAP2 ADD ADD MLOAD MLOAD PUSH1 0x0 PUSH1 0xed
PUSH1 0x20 MUL PUSH1 0x20 ADD ADD MLOAD PUSH1 0x0 ADD MLOAD PUSH1 0x0 PUSH1 0x2 DUP2 LT PUSH1 0xed JUMPI
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "PUSH1 0x20 SWAP1 DUP2 MUL SWAP2 SWAP1 SWAP2 ADD ADD MLOAD MLOAD PUSH1 0x0 PUSH1 0xed")
 (str2block "PUSH1 0x20 MUL PUSH1 0x20 ADD ADD MLOAD PUSH1 0x0 ADD MLOAD PUSH1 0x0 PUSH1 0x2 DUP2 LT PUSH1 0xed JUMPI")
 2).


(* RULE: (X+Y)+Z = (Z+X)+Y *)
(*
# 79
PUSH1 0x20 SWAP1 DUP2 MUL SWAP2 SWAP1 SWAP2 ADD ADD MLOAD MLOAD PUSH1 0x1 PUSH1 0xf5
PUSH1 0x20 MUL PUSH1 0x20 ADD ADD MLOAD PUSH1 0x0 ADD MLOAD PUSH1 0x1 PUSH1 0x2 DUP2 LT PUSH1 0xf5 JUMPI
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "PUSH1 0x20 SWAP1 DUP2 MUL SWAP2 SWAP1 SWAP2 ADD ADD MLOAD MLOAD PUSH1 0x1 PUSH1 0xf5")
 (str2block "PUSH1 0x20 MUL PUSH1 0x20 ADD ADD MLOAD PUSH1 0x0 ADD MLOAD PUSH1 0x1 PUSH1 0x2 DUP2 LT PUSH1 0xf5 JUMPI")
 2).


(* RULE: ADD(X,N) = SUB(X, 2^256-N) *)
(* special case ADD(X, 2^255) = SUB(X, 2^255) *)
(* special case ADD(X, 1) = SUB(X, 2^256-1) *)
(* # 99 *)
(* # 174 *)
(* # 490 *)
(* # 624 *)
(* # 633 *)
(* # 928 *)
(* # 930 *)
(* # 1068 *)
(* # 1232 *)

(* RULE: ADD(X,N) = SUB(X, 2^256-N) *)
(* special case ADD(X, 2^255) = SUB(X, 2^255) *)
(* special case ADD(X, 1) = SUB(X, 2^256-1) *)
(*
# 177
PUSH1 0x0 PUSH32 0x8000000000000000000000000000000000000000000000000000000000000000 DUP3 ADD PUSH1 0x6c JUMPI
PUSH1 0x0 PUSH1 0x1 PUSH1 0xFF SHL DUP3 SUB PUSH1 0x6c JUMPI
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "PUSH1 0x0 PUSH32 0x8000000000000000000000000000000000000000000000000000000000000000 DUP3 ADD PUSH1 0x6c JUMPI")
 (str2block "PUSH1 0x0 PUSH1 0x1 PUSH1 0xFF SHL DUP3 SUB PUSH1 0x6c JUMPI")
 1).

(* RULE: ISZERO(ISZERO(X)) = GT(X,0) *)
(*
# 243
POP PUSH8 0xDE0B6B3A7640000 DUP1 DUP3 MOD DUP1 ISZERO ISZERO SWAP2 SUB MUL ADD SWAP1
PUSH8 0xDE0B6B3A7640000 DUP3 MOD DUP1 PUSH8 0xDE0B6B3A7640000 SUB PUSH1 0x0 DUP3 GT DUP2 MUL DUP5 ADD SWAP3 POP POP POP SWAP2 SWAP1 POP
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "POP PUSH8 0xDE0B6B3A7640000 DUP1 DUP3 MOD DUP1 ISZERO ISZERO SWAP2 SUB MUL ADD SWAP1")
 (str2block "PUSH8 0xDE0B6B3A7640000 DUP3 MOD DUP1 PUSH8 0xDE0B6B3A7640000 SUB PUSH1 0x0 DUP3 GT DUP2 MUL DUP5 ADD SWAP3 POP POP POP SWAP2 SWAP1 POP")
 3).

(* RULE: ADD(X, N) = SUB(X, 2^256-N) *)
(*
# 247
PUSH8 0xDE0B6B3A7640000 DUP2 MUL SWAP3 POP SWAP1 POP DUP3 DUP2 SHR PUSH32 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF21F494C589C0000 DUP2 ADD PUSH1 0x83 JUMPI
SWAP1 POP PUSH8 0xDE0B6B3A7640000 DUP2 MUL SWAP2 POP PUSH1 0x0 DUP2 DUP5 SWAP1 SHR SWAP1 POP PUSH8 0xDE0B6B3A7640000 DUP2 SUB PUSH1 0x83 JUMPI
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "PUSH8 0xDE0B6B3A7640000 DUP2 MUL SWAP3 POP SWAP1 POP DUP3 DUP2 SHR PUSH32 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF21F494C589C0000 DUP2 ADD PUSH1 0x83 JUMPI")
 (str2block "SWAP1 POP PUSH8 0xDE0B6B3A7640000 DUP2 MUL SWAP2 POP PUSH1 0x0 DUP2 DUP5 SWAP1 SHR SWAP1 POP PUSH8 0xDE0B6B3A7640000 DUP2 SUB PUSH1 0x83 JUMPI")
 4).

(* RULE: ISZERO(ISZERO(LT(X,Y))) = LT(X,Y) *)
(*
# 557
SWAP1 DUP2 DUP2 LT PUSH2 0x1ba JUMPI
SWAP1 DUP2 DUP2 LT ISZERO PUSH1 0x0 EQ PUSH2 0x1ba JUMPI
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "SWAP1 DUP2 DUP2 LT PUSH2 0x1ba JUMPI")
 (str2block "SWAP1 DUP2 DUP2 LT ISZERO PUSH1 0x0 EQ PUSH2 0x1ba JUMPI")
 2).

(* Odd case: JUMPI implementation? *)
(*
# 584
POP
POP PUSH1 0x0 PUSH1 0x87 JUMPI
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "POP")
 (str2block "POP PUSH1 0x0 PUSH1 0x87 JUMPI")
 1).

(* RULE: ADD(X,N) = SUB(X, 2^256-N) *)
(* 
# 761
PUSH8 0xDE0B6B3A7640000 DUP2 MUL SWAP4 POP SWAP1 POP DUP4 DUP2 SAR PUSH32 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF21F494C589C0000 DUP2 ADD PUSH2 0x10e JUMPI
SWAP1 POP PUSH8 0xDE0B6B3A7640000 DUP2 MUL SWAP3 POP PUSH1 0x0 DUP2 DUP6 SWAP1 SAR SWAP1 POP PUSH8 0xDE0B6B3A7640000 DUP2 SUB PUSH2 0x10e JUMPI
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "PUSH8 0xDE0B6B3A7640000 DUP2 MUL SWAP4 POP SWAP1 POP DUP4 DUP2 SAR PUSH32 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF21F494C589C0000 DUP2 ADD PUSH2 0x10e JUMPI")
 (str2block "SWAP1 POP PUSH8 0xDE0B6B3A7640000 DUP2 MUL SWAP3 POP PUSH1 0x0 DUP2 DUP6 SWAP1 SAR SWAP1 POP PUSH8 0xDE0B6B3A7640000 DUP2 SUB PUSH2 0x10e JUMPI")
 5).

(* RULE: ISZERO(ISZERO(LT(X,Y))) = LT(X,Y) *)
(* 
# 1024
SWAP1 DUP2 DUP2 LT PUSH2 0x210 JUMPI
SWAP1 DUP2 DUP2 LT ISZERO PUSH1 0x0 EQ PUSH2 0x210 JUMPI
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "SWAP1 DUP2 DUP2 LT PUSH2 0x210 JUMPI")
 (str2block "SWAP1 DUP2 DUP2 LT ISZERO PUSH1 0x0 EQ PUSH2 0x210 JUMPI")
 2).

(* RULE: ISZERO(ISZERO(SLT(X,Y))) = SLT(X,Y) *)
(*
# 1026
PUSH8 0xDE0B6B3A7640000 SWAP2 DUP3 DUP3 SLT PUSH2 0x215 JUMPI
PUSH8 0xDE0B6B3A7640000 SWAP2 DUP3 DUP3 SLT ISZERO PUSH1 0x0 EQ PUSH2 0x215 JUMPI
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "PUSH8 0xDE0B6B3A7640000 SWAP2 DUP3 DUP3 SLT PUSH2 0x215 JUMPI")
 (str2block "PUSH8 0xDE0B6B3A7640000 SWAP2 DUP3 DUP3 SLT ISZERO PUSH1 0x0 EQ PUSH2 0x215 JUMPI")
 2).

(* EQ(X,Y) = ISZERO(SUB(X,Y))) *) 
(*
# 1221
DUP2 DUP2 AND DUP4 DUP3 AND DUP2 DUP2 SUB SWAP2 EQ PUSH1 0xc8 JUMPI
PUSH1 0x0 DUP2 DUP4 AND DUP3 DUP6 AND SUB SWAP1 POP DUP1 PUSH1 0x0 EQ PUSH1 0xc8 JUMPI
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "DUP2 DUP2 AND DUP4 DUP3 AND DUP2 DUP2 SUB SWAP2 EQ PUSH1 0xc8 JUMPI")
 (str2block "PUSH1 0x0 DUP2 DUP4 AND DUP3 DUP6 AND SUB SWAP1 POP DUP1 PUSH1 0x0 EQ PUSH1 0xc8 JUMPI")
 3).

(* EQ(X,Y) = ISZERO(SUB(X,Y))) *) 
(*
# 1277
SWAP2 DUP3 AND SWAP2 AND DUP2 DUP2 EQ PUSH2 0x11a JUMPI
DUP1 SWAP2 AND SWAP2 AND SWAP1 DUP2 DUP2 SUB ISZERO PUSH2 0x11a JUMPI
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "SWAP2 DUP3 AND SWAP2 AND DUP2 DUP2 EQ PUSH2 0x11a JUMPI")
 (str2block "DUP1 SWAP2 AND SWAP2 AND SWAP1 DUP2 DUP2 SUB ISZERO PUSH2 0x11a JUMPI")
 3).


Compute
  let b1 := str2block "PUSH1 0x0 DUP1 PUSH1 0xa4 MSTORE ADDRESS PUSH1 0xa0 PUSH1 0x84 MSTORE PUSH1 0x4 MSTORE PUSH1 0x0 PUSH1 0xc4 DUP2 PUSH4 0x79212195 PUSH1 0xe1 SHL DUP5 MSTORE DUP5 PUSH1 0x64 MSTORE DUP4 DUP7 GAS" in
  let b2 := str2block "PUSH4 0x79212195 PUSH1 0xe1 SHL PUSH1 0x0 MSTORE ADDRESS PUSH1 0x4 MSTORE DUP1 PUSH1 0x64 MSTORE PUSH1 0xa0 PUSH1 0x84 MSTORE PUSH1 0x0 PUSH1 0xa4 MSTORE PUSH1 0x0 DUP1 PUSH1 0xc4 PUSH1 0x0 DUP1 DUP7 GAS" in
  (evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
     MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_PO
     SStrgCmp_Basic SHA3Cmp_Trivial 
     all_optimization_steps' 10 10 b1 b2 2).


Compute
  let b1 := str2block "METAPUSH 5 0x0 PUSH1 0x40 MLOAD PUSH1 0xfb PUSH1 0x20 PUSH1 0x1f NOT DUP4 DUP7 SUB ADD DUP4 MSTORE MSTORE PUSH1 0x40 PUSH1 0x0 DUP7 SWAP7 DUP2 MSTORE KECCAK256 METAPUSH 5 0x0 DUP2 SWAP2 SWAP5 PUSH1 0x40 MSTORE" in 
  let b2 := str2block "PUSH1 0x40 DUP1 MLOAD PUSH1 0x1f NOT DUP2 DUP5 SUB ADD DUP2 MSTORE SWAP2 DUP2 MSTORE PUSH1 0x0 DUP5 DUP2 MSTORE PUSH1 0xfb PUSH1 0x20 MSTORE KECCAK256 SWAP1 METAPUSH 5 0x0 SWAP1 DUP3 METAPUSH 5 0x0" in 
  (evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
     MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_PO
     SStrgCmp_Basic SHA3Cmp_Trivial 
     all_optimization_steps' 10 10 b1 b2 3).









Compute
  let b1 := str2block "PUSH1 0x20 PUSH1 0x40 DUP5 PUSH1 0x1 DUP4 MSTORE PUSH1 0x0 MSTORE MLOAD ADD PUSH1 0x40 PUSH1 0x0 KECCAK256 DUP3 SWAP1 METAPUSH 5 0x0 SWAP3 METAPUSH 5 0x0" in
  let b2 := str2block "DUP1 PUSH1 0x1 PUSH1 0x0 DUP6 DUP2 MSTORE PUSH1 0x20 ADD SWAP1 DUP2 MSTORE PUSH1 0x20 ADD PUSH1 0x0 KECCAK256 PUSH1 0x40 MLOAD PUSH1 0x20 ADD METAPUSH 5 0x0 SWAP3 SWAP2 SWAP1 METAPUSH 5 0x0" in 
  (evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
     MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_PO
     SStrgCmp_Basic SHA3Cmp_Trivial 
     all_optimization_steps' 10 10 b1 b2 3).
     

Compute
  let b1 := str2block "PUSH1 0x1 GT" in
  let b2 := str2block "ISZERO" in 
  (evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
     MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_PO
     SStrgCmp_Basic SHA3Cmp_Trivial 
     all_optimization_steps 10 10 b1 b2 1).



(* Attempts to prove DIV(X, SHL(Y,1)) = SHR(Y,X) *)
Lemma div_mult_2 (x y:N):
y <> (0%N) -> 
N.div x (y*2) = N.div (N.div x y) 2.
Proof.
intros. rewrite -> N.div_div; try intuition.
Qed.

Lemma shr_one_div_2 (x: EVMWord):
wrshift x 1 = wdiv x (NToWord EVMWordSize 2).
Proof.
Search (wrshift' _ 1).
Search (wdiv _ _).
Check (eq_rec_r).
unfold wrshift. intuition.
Admitted.

Lemma y_not_wzero_succ: forall y,
y <> WZero ->
exists n, wordToNat y = S n.
Proof.
Admitted.

Lemma natToWord_distr_times: forall size a b,
natToWord size (a * b) = wmult (natToWord size a) (natToWord size b).
Proof.
Admitted.

Lemma NToWord_distr_times: forall size a b,
NToWord size (a * b) = wmult (NToWord size a) (NToWord size b).
Proof.
Admitted.

Lemma div_shl_is_shr (x y: EVMWord):
wdiv x (wlshift WOne (wordToNat y)) = wrshift x (wordToNat y).
Proof.
destruct (weqb y WZero) eqn: eq_y_zero.
- apply weqb_sound in eq_y_zero.
  rewrite -> eq_y_zero. simpl.
  rewrite -> wrshift_0.
  rewrite -> wlshift_0.
  unfold wdiv. unfold wordBin. simpl. 
  rewrite -> N.div_1_r.
  rewrite -> NToWord_wordToN.
  reflexivity.
- apply weqb_false in eq_y_zero.
  rewrite -> wlshift_mul_pow2.
  apply y_not_wzero_succ in eq_y_zero.
  destruct eq_y_zero as [n eq_y].
  rewrite -> eq_y. rewrite -> pow2_S.
  unfold wdiv. unfold wordBin.
  rewrite -> natToWord_distr_times.
  Search wmult.
  pose proof (wmult_unit_r 
    (wmult (natToWord EVMWordSize 2) (natToWord EVMWordSize (pow2 n))))
    as Hmult_unit.
  rewrite wmult_comm in Hmult_unit.
  fold WOne in Hmult_unit.
  rewrite -> Hmult_unit.
  unfold wmult. unfold wordBin.
  rewrite -> NToWord_distr_times.
  rewrite -> NToWord_wordToN.
  rewrite -> NToWord_wordToN.
  admit.
Admitted.
(* END Attempts to prove DIV(X, SHL(Y,1)) = SHR(Y,X) *)

Search wxor.

End Debug.
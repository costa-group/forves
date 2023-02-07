Require Import bbv.Word. 
Require Import Nat.
Require Import Coq.NArith.NArith.

Require Import FORVES.constants.
Import Constants.

Require Import FORVES.symbolic_execution.
Import SymbolicExecution.

Require Import FORVES.memory_ops_solvers.
Import MemoryOpsSolvers.

Require Import FORVES.storage_ops_solvers.
Import StorageOpsSolvers.

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

Module Tests.


Compute (evm_exec_block_c [PUSH 1 0x7; PUSH 1 0x1; OpInstr ADD] 
                          empty_state
                          evm_stack_opm).
(* 
   Some (ExState stk=[0x8] 
                 mem=fun _ : N => 0 
                 strg=fun _ : N => 0 
                 empty_context
        ) 
*)

Compute (evm_sym_exec basic_smemory_updater basic_sstorage_updater basic_mload_solver
  basic_sload_solver [PUSH 1 0x7; PUSH 1 0x1; OpInstr ADD] 0 evm_stack_opm).
(* 
   Some (SymExState instk_h=0 
                    stk=[FreshVar 0] 
                    mem=[] 
                    strg=[] 
                    ctx=SymCtx
                    smap=(SymMap 1 [(0, SymOp ADD [0x1;0x7])])
        )
*)



Compute (evm_exec_block_c [OpInstr ADD]  
                          (make_st [WOne; WOne; WOne] 
                                   empty_memory empty_storage empty_context)
                          evm_stack_opm).
(*
   Some (ExState stk=[0x2;0x1] 
                 mem=fun _ : N => 0 
                 strg=fun _ : N => 0 
                 empty_context
        ) 
*)

Compute (evm_sym_exec basic_smemory_updater basic_sstorage_updater basic_mload_solver
  basic_sload_solver [OpInstr ADD] 3 evm_stack_opm).
(* 
  Some (SymExState instk_h=3 
                   stk=[FreshVar 0; InStackVar 2] 
                   mem=[] 
                   strg=[] 
                   ctx=SymCtx
                   smap=(SymMap 1 [(0, SymOp ADD [InStackVar 0; InStackVar 1])])
       )
*)






Compute (evm_exec_block_c [PUSH 1 0xFF; PUSH 1 0x0; MSTORE; PUSH 1 0x0; MLOAD]  
                          (make_st [WOne] 
                                   empty_memory empty_storage empty_context)
                          evm_stack_opm).
(*
   Some (ExState stk=[0xFF;0x1]
                 mem=fun 0=>0x0, 1=>0x0, 2=0x0, ..., 31=>0xFF, _=>0x0
                 strg=fun N=>0x0
                 empty_context
*)

Compute (evm_sym_exec basic_smemory_updater basic_sstorage_updater basic_mload_solver
  basic_sload_solver [PUSH 1 0xFF; PUSH 1 0x0; MSTORE; PUSH 1 0x0; MLOAD] 1 evm_stack_opm).
(*
   Some (SymExState instk_h=1 
                    stk=[FreshVar 0; InStackVar 0]
                    mem=[U_MSTORE addr=0x0 val=0xFF]
                    strg=[]
                    ctx=SymCtx
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
                                   empty_context)
                          evm_stack_opm).
(*
   Some (ExState stk=[0x1]
                 mem=fun 0=>0x0, 1=>0x0, 2=0x0, ..., 31=>0xFF, _=>0x0
                 strg=fun 0=>0xFF  _=>0x0
                 empty_context
        )
*)

Compute (evm_sym_exec basic_smemory_updater basic_sstorage_updater basic_mload_solver
  basic_sload_solver [PUSH 1 0x0; SLOAD; PUSH 1 0x7; MSTORE] 1 evm_stack_opm).
(*
   Some (SymExState instk_h=1 
                    stk=[InStackVar 0]
                    mem=[U_MSTORE 0x7 (FreshVar 0)]
                    strg=[]
                    smap=SymMap 1 [(0,SymSLOAD 0x0)]
       )
*)


End Tests.


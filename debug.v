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


Module Debug.

(* string to block that always succeed *)
Definition str2block (s : string) : block :=
  match parse_block s with
  | None => []
  | Some b => b
  end.
    
(*Compute 
(str2block "ADD PUSH1 0x20 ADD MLOAD PUSH32 0xFF00000000000000000000000000000000000000000000000000000000000000 AND DUP5 DUP5 PUSH1 0x64 DUP2 PUSH1 0x1c").
*)

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
  
  
(* Eval cbv in *)
Compute
  let b1 := str2block "PUSH1 0xFF PUSH1 0x20 PUSH1 0x0 ADD MSTORE PUSH1 0xFF PUSH1 0x0 MSTORE PUSH1 0x40 MLOAD PUSH1 0x40 MLOAD" in
  let b2 := str2block "PUSH1 0xFF PUSH1 0x20 MSTORE PUSH1 0xFF PUSH1 0x0 MSTORE PUSH1 0x40 MLOAD PUSH1 0x40 MLOAD" in 
  (evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
   MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_PO
   SStrgCmp_Basic SHA3Cmp_Basic
   all_optimization_steps 10 10 b1 b2 0).

Compute
  let b1 := str2block "PUSH1 0x65 PUSH1 0x20 MSTORE PUSH1 0x1 PUSH1 0x1 PUSH1 0xa0 SHL SUB DUP9 DUP2 AND PUSH1 0x0 MSTORE DUP5 SWAP1 AND SWAP1 PUSH4 0x50d25bcd SWAP1 PUSH1 0x40 PUSH1 0x0 KECCAK256 PUSH1 0x40 MLOAD DUP1 PUSH1 0x4 ADD SWAP3 DUP5 PUSH1 0xe0 SHL SWAP1 SWAP2 MSTORE SWAP1 PUSH1 0x2 ADD DUP1 SLOAD PUSH1 0xff NOT AND SWAP1 SWAP2 PUSH1 0xff AND OR SWAP1 SSTORE PUSH1 0x20 PUSH1 0x40 MLOAD DUP1 DUP4 SUB DUP2 DUP7" in
  let b2 := str2block "PUSH1 0x65 PUSH1 0x0 DUP10 PUSH1 0x1 PUSH1 0x1 PUSH1 0xa0 SHL SUB AND PUSH1 0x1 PUSH1 0x1 PUSH1 0xa0 SHL SUB AND DUP2 MSTORE PUSH1 0x20 ADD SWAP1 DUP2 MSTORE PUSH1 0x20 ADD PUSH1 0x0 KECCAK256 PUSH1 0x2 ADD PUSH1 0x0 PUSH2 0x100 EXP DUP2 SLOAD DUP2 PUSH1 0xff MUL NOT AND SWAP1 DUP4 PUSH1 0xff AND MUL OR SWAP1 SSTORE POP DUP3 PUSH1 0x1 PUSH1 0x1 PUSH1 0xa0 SHL SUB AND PUSH4 0x50d25bcd PUSH1 0x40 MLOAD DUP2 PUSH4 0xffffffff AND PUSH1 0xe0 SHL DUP2 MSTORE PUSH1 0x4 ADD PUSH1 0x20 PUSH1 0x40 MLOAD DUP1 DUP4 SUB DUP2 DUP7" in 
  (evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
   MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_PO
   SStrgCmp_Basic SHA3Cmp_Basic
   all_optimization_steps 10 10 b1 b2 8).
   
Compute
  let b1 := str2block "PUSH1 0xFF PUSH1 0x20 PUSH1 0x0 ADD SSTORE PUSH1 0xFF PUSH1 0x0 SSTORE PUSH1 0x40 SLOAD PUSH1 0x40 SLOAD" in
  let b2 := str2block "PUSH1 0xFF PUSH1 0x20 SSTORE PUSH1 0xFF PUSH1 0x0 SSTORE PUSH1 0x40 SLOAD PUSH1 0x40 SLOAD" in 
  (evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
   MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_PO
   SStrgCmp_Basic SHA3Cmp_Basic
   all_optimization_steps 10 10 b1 b2 0).   
  
(*  
  
Compute
  let b1 := str2block "PUSH1 0xf SLOAD PUSH1 0xa0 SHR PUSH1 0xff AND ISZERO METAPUSH 5 0x145" in
  let b2 := str2block "PUSH1 0xf SLOAD PUSH1 0x1 PUSH1 0xa0 SHL SWAP1 DIV PUSH1 0xff AND ISZERO METAPUSH 5 0x145" in
  let h := 5 in
  (evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
   MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic_w_eq_chk SMemCmp_PO
   SStrgCmp_Basic SHA3Cmp_Basic
   all_optimization_steps 10 10 b1 b2 h).
  
  
  
(* Test of OPT_mem_solver *)
Compute
  let b1 := str2block "PUSH1 0xFF PUSH1 0x5 MSTORE PUSH1 0x5 MLOAD" in
  let b2 := str2block "PUSH1 0xFF PUSH1 0x5 MSTORE PUSH1 0x5 PUSH1 0x0 ADD MLOAD" in 
  (evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
   MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_PO
   SStrgCmp_Basic SHA3Cmp_Basic
   all_optimization_steps 10 10 b1 b2 0).
   
(* Test of OPT_strg_solver *)
Compute
  let b1 := str2block "PUSH1 0xFF PUSH1 0x15 SSTORE PUSH1 0x15 SLOAD" in
  let b2 := str2block "PUSH1 0xFF PUSH1 0x15 SSTORE PUSH1 0x0 PUSH1 0x15 ADD SLOAD" in 
  (evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
   MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_PO
   SStrgCmp_Basic SHA3Cmp_Basic
   all_optimization_steps 10 10 b1 b2 0).


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

(*follow_in_smap (FreshVar 1) maxid sb).*)
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
 
 
 
(* Alejandro's example *) 
(*
METAPUSH 5 0x240 SWAP7 PUSH1 0x40 MLOAD PUSH4 0x2671a551 PUSH1 0xe1 SHL DUP2 MSTORE PUSH1 0x20 DUP2 PUSH1 0x4 ADD MSTORE PUSH1 0x1 DUP2 PUSH1 0x24 ADD MSTORE SWAP7 DUP8 PUSH1 0x44 ADD MSTORE DUP7 PUSH1 0x64 ADD MSTORE DUP6 PUSH1 0x84 ADD MSTORE DUP5 PUSH1 0xa4 ADD MSTORE DUP4 PUSH1 0xc4 ADD MSTORE DUP3 PUSH1 0xe4 ADD MSTORE DUP1 PUSH1 0x20 MSTORE PUSH1 0x0 PUSH1 0x0 MSTORE PUSH1 0x40 MLOAD METAPUSH 3 0x3038 PUSH1 0x40 MSTORE PUSH1 0x55 PUSH1 0xb KECCAK256 PUSH1 0x1 PUSH1 0x1 PUSH1 0xa0 SHL SUB SWAP1 AND SWAP3 SWAP1 PUSH1 0x40 MSTORE PUSH1 0x20 SWAP1 PUSH1 0x0 SWAP1 PUSH2 0x104 SWAP1 PUSH1 0x0 DUP7
METAPUSH 5 0x240 SWAP7 PUSH1 0x40 MLOAD SWAP7 PUSH4 0x2671a551 PUSH1 0xe1 SHL DUP9 MSTORE PUSH1 0x20 PUSH1 0x4 DUP10 ADD MSTORE PUSH1 0x1 PUSH1 0x24 DUP10 ADD MSTORE PUSH1 0x44 DUP9 ADD MSTORE PUSH1 0x64 DUP8 ADD MSTORE PUSH1 0x84 DUP7 ADD MSTORE PUSH1 0xa4 DUP6 ADD MSTORE PUSH1 0xc4 DUP5 ADD MSTORE PUSH1 0xe4 DUP4 ADD MSTORE METAPUSH 5 0x178 POP PUSH1 0x20 PUSH1 0x0 PUSH2 0x104 PUSH1 0x1 DUP1 PUSH1 0xa0 SHL SUB SWAP5 PUSH1 0x40 MLOAD SWAP6 DUP1 METAPUSH 3 0x3036 AND PUSH1 0xff PUSH1 0xa0 SHL OR DUP5 MSTORE DUP6 DUP6 MSTORE METAPUSH 3 0x3038 PUSH1 0x40 MSTORE PUSH1 0x55 PUSH1 0xb KECCAK256 AND SWAP6 PUSH1 0x40 MSTORE DUP3 DUP1 MSTORE DUP3 DUP7
500
*)
Compute 
(evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
 MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Basic
 SStrgCmp_Basic SHA3Cmp_Trivial 
 all_optimization_steps 10 10
 (str2block "METAPUSH 5 0x240 SWAP7 PUSH1 0x40 MLOAD PUSH4 0x2671a551 PUSH1 0xe1 SHL DUP2 MSTORE PUSH1 0x20 DUP2 PUSH1 0x4 ADD MSTORE PUSH1 0x1 DUP2 PUSH1 0x24 ADD MSTORE SWAP7 DUP8 PUSH1 0x44 ADD MSTORE DUP7 PUSH1 0x64 ADD MSTORE DUP6 PUSH1 0x84 ADD MSTORE DUP5 PUSH1 0xa4 ADD MSTORE DUP4 PUSH1 0xc4 ADD MSTORE DUP3 PUSH1 0xe4 ADD MSTORE DUP1 PUSH1 0x20 MSTORE PUSH1 0x0 PUSH1 0x0 MSTORE PUSH1 0x40 MLOAD METAPUSH 3 0x3038 PUSH1 0x40 MSTORE PUSH1 0x55 PUSH1 0xb KECCAK256 PUSH1 0x1 PUSH1 0x1 PUSH1 0xa0 SHL SUB SWAP1 AND SWAP3 SWAP1 PUSH1 0x40 MSTORE PUSH1 0x20 SWAP1 PUSH1 0x0 SWAP1 PUSH2 0x104 SWAP1 PUSH1 0x0 DUP7")
 (str2block "METAPUSH 5 0x240 SWAP7 PUSH1 0x40 MLOAD SWAP7 PUSH4 0x2671a551 PUSH1 0xe1 SHL DUP9 MSTORE PUSH1 0x20 PUSH1 0x4 DUP10 ADD MSTORE PUSH1 0x1 PUSH1 0x24 DUP10 ADD MSTORE PUSH1 0x44 DUP9 ADD MSTORE PUSH1 0x64 DUP8 ADD MSTORE PUSH1 0x84 DUP7 ADD MSTORE PUSH1 0xa4 DUP6 ADD MSTORE PUSH1 0xc4 DUP5 ADD MSTORE PUSH1 0xe4 DUP4 ADD MSTORE METAPUSH 5 0x178 POP PUSH1 0x20 PUSH1 0x0 PUSH2 0x104 PUSH1 0x1 DUP1 PUSH1 0xa0 SHL SUB SWAP5 PUSH1 0x40 MLOAD SWAP6 DUP1 METAPUSH 3 0x3036 AND PUSH1 0xff PUSH1 0xa0 SHL OR DUP5 MSTORE DUP6 DUP6 MSTORE METAPUSH 3 0x3038 PUSH1 0x40 MSTORE PUSH1 0x55 PUSH1 0xb KECCAK256 AND SWAP6 PUSH1 0x40 MSTORE DUP3 DUP1 MSTORE DUP3 DUP7")
 7).
 

 

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
  let b1 := str2block "PUSH1 0x40 PUSH1 0x0 DUP7 PUSH1 0x0 MSTORE PUSH1 0x7 PUSH1 0x20 MSTORE KECCAK256 PUSH1 0x4 ADD DUP2 DUP2 SLOAD DUP2 LT METAPUSH 5 0x388" in
  let b2 := str2block "PUSH1 0x0 DUP6 DUP2 MSTORE PUSH1 0x7 PUSH1 0x20 MSTORE PUSH1 0x40 SWAP1 KECCAK256 PUSH1 0x4 ADD DUP1 SLOAD DUP3 SWAP1 DUP2 LT METAPUSH 5 0x184" in 
  (evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
     MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_PO
     SStrgCmp_Basic SHA3Cmp_Trivial 
     all_optimization_steps' 10 10 b1 b2 5).

Compute
  let b1 := str2block "PUSH1 0x40 DUP1 MLOAD PUSH1 0x80 DUP1 DUP3 ADD DUP4 MSTORE PUSH32 0x209DD15EBFF5D46C4BD888E51A93CF99A7329636C63514396B4A452003A35BF7 DUP3 DUP5 ADD SWAP1 DUP2 MSTORE PUSH32 0x4BF11CA01483BFA8B34B43561848D28905960114C8AC04049AF4B6315A41678 PUSH1 0x60 DUP1 DUP6 ADD SWAP2 SWAP1 SWAP2 MSTORE SWAP1 DUP4 MSTORE DUP4 MLOAD DUP1 DUP6 ADD DUP6 MSTORE PUSH32 0x2BB8324AF6CFC93537A2AD1A445CFD0CA2A71ACD7AC41FADBF933C2A51BE344D DUP2 MSTORE PUSH32 0x120A2A4CF30C1BF9845F20C6FE39E07EA2CCE61F0C9BB048165FE5E4DE877550 PUSH1 0x20 DUP3 DUP2 ADD SWAP2 SWAP1 SWAP2 MSTORE DUP1 DUP6 ADD SWAP2 SWAP1 SWAP2 MSTORE SWAP3 DUP6 MSTORE DUP4 MLOAD DUP1 DUP6 ADD DUP6 MSTORE PUSH32 0x2ECA0C7238BF16E83E7A1E6C5D49540685FF51380F309842A98561558019FC02 DUP2 MSTORE PUSH32 0x3D3260361BB8451DE5FF5ECD17F010FF22F5C31CDF184E9020B06FA5997DB84 DUP2 DUP6 ADD MSTORE DUP6 DUP5 ADD MSTORE DUP4 MLOAD DUP1 DUP4 ADD DUP6 MSTORE PUSH32 0x2E89718AD33C8BED92E210E81D1853435399A271913A6520736A4729CF0D51EB DUP2 DUP7 ADD SWAP1 DUP2 MSTORE PUSH32 0x1A9E2FFA2E92599B68E44DE5BCF354FA2642BD4F26B259DAA6F7CE3ED57AEB3 DUP3 DUP5 ADD MSTORE DUP2 MSTORE DUP5 MLOAD DUP1 DUP7 ADD DUP7 MSTORE PUSH32 0x14A9A87B789A58AF499B314E13C3D65BEDE56C07EA2D418D6874857B70763713 DUP2 MSTORE PUSH32 0x178FB49A2D6CD347DC58973FF49613A20757D0FCC22079F9ABD10C3BAEE24590 DUP2 DUP7 ADD MSTORE DUP2 DUP6 ADD MSTORE DUP6 DUP6 ADD MSTORE DUP4 MLOAD DUP1 DUP4 ADD DUP6 MSTORE PUSH32 0x25F83C8B6AB9DE74E7DA488EF02645C5A16A6652C3C71A15DC37FE3A5DCB7CB1 DUP2 DUP7 ADD SWAP1 DUP2 MSTORE PUSH32 0x22ACDEDD6308E3BB230D226D16A105295F523A8A02BFC5E8BD2DA135AC4C245D DUP3 DUP5 ADD MSTORE DUP2 MSTORE DUP5 MLOAD DUP1 DUP7 ADD DUP7 MSTORE PUSH32 0x65BBAD92E7C4E31BF3757F1FE7362A63FBFEE50E7DC68DA116E67D600D9BF68 DUP2 MSTORE PUSH32 0x6D302580DC0661002994E7CD3A7F224E7DDC27802777486BF80F40E4CA3CFDB DUP2 DUP7 ADD MSTORE DUP2 DUP6 ADD MSTORE DUP6 DUP3 ADD MSTORE DUP4 MLOAD DUP1 DUP6 ADD DUP6 MSTORE PUSH32 0x15794AB061441E51D01E94640B7E3084A07E02C78CF3103C542BC5B298669F21 DUP2 MSTORE PUSH32 0x14DB745C6780E9DF549864CEC19C2DAF4531F6EC0C89CC1C7436CC4D8D300C6D DUP2 DUP6 ADD MSTORE DUP6 DUP4 ADD MSTORE DUP4 MLOAD DUP1 DUP4 ADD DUP6 MSTORE PUSH32 0x1F39E4E4AFC4BC74790A4A028AFF2C3D2538731FB755EDEFD8CB48D6EA589B5E DUP2 DUP7 ADD SWAP1 DUP2 MSTORE PUSH32 0x283F150794B6736F670D6A1033F9B46C6F5204F50813EB85C8DC4B59DB1C5D39 DUP3 DUP5 ADD MSTORE DUP2 MSTORE DUP5 MLOAD DUP1 DUP7 ADD DUP7 MSTORE PUSH32 0x140D97EE4D2B36D99BC49974D18ECCA3E7AD51011956051B464D9E27D46CC25E DUP2 MSTORE PUSH32 0x764BB98575BD466D32DB7B15F582B2D5C452B36AA394B789366E5E3CA5AABD4 DUP2 DUP7 ADD MSTORE DUP2 DUP6 ADD MSTORE PUSH1 0xA0 DUP7 ADD MSTORE DUP4 MLOAD SWAP2 DUP3 ADD DUP5 MSTORE PUSH32 0x217CEE0A9AD79A4493B5253E2E4E3A39FC2DF38419F230D341F60CB064A0AC29 DUP3 DUP6 ADD SWAP1 DUP2 MSTORE PUSH32 0xA3D76F140DB8418BA512272381446EB73958670F00CF46F1D9E64CBA057B53C SWAP2 DUP4 ADD SWAP2 SWAP1 SWAP2 MSTORE DUP2 MSTORE DUP3 MLOAD DUP1 DUP5 ADD SWAP1 SWAP4 MSTORE PUSH32 0x26F64A8EC70387A13E41430ED3EE4A7DB2059CC5FC13C067194BCC0CB49A9855 DUP4 MSTORE PUSH32 0x2FD72BD9EDB657346127DA132E5B82AB908F5816C826ACB499E22F2412D1A2D7 DUP4 DUP4 ADD MSTORE SWAP1 DUP2 ADD SWAP2 SWAP1 SWAP2 MSTORE PUSH1 0xC0 DUP3 ADD MSTORE PUSH1 0xA METAPUSH 5 0x278" in
  let b2 := str2block "PUSH1 0x40 MLOAD DUP1 PUSH1 0x40 ADD PUSH1 0x40 MSTORE DUP1 PUSH1 0x40 MLOAD DUP1 PUSH1 0x40 ADD PUSH1 0x40 MSTORE DUP1 PUSH32 0x209DD15EBFF5D46C4BD888E51A93CF99A7329636C63514396B4A452003A35BF7 DUP2 MSTORE PUSH1 0x20 ADD PUSH32 0x4BF11CA01483BFA8B34B43561848D28905960114C8AC04049AF4B6315A41678 DUP2 MSTORE POP DUP2 MSTORE PUSH1 0x20 ADD PUSH1 0x40 MLOAD DUP1 PUSH1 0x40 ADD PUSH1 0x40 MSTORE DUP1 PUSH32 0x2BB8324AF6CFC93537A2AD1A445CFD0CA2A71ACD7AC41FADBF933C2A51BE344D DUP2 MSTORE PUSH1 0x20 ADD PUSH32 0x120A2A4CF30C1BF9845F20C6FE39E07EA2CCE61F0C9BB048165FE5E4DE877550 DUP2 MSTORE POP DUP2 MSTORE POP DUP2 PUSH1 0x0 ADD DUP2 SWAP1 MSTORE POP PUSH1 0x40 MLOAD DUP1 PUSH1 0x40 ADD PUSH1 0x40 MSTORE DUP1 PUSH32 0x2ECA0C7238BF16E83E7A1E6C5D49540685FF51380F309842A98561558019FC02 DUP2 MSTORE PUSH1 0x20 ADD PUSH32 0x3D3260361BB8451DE5FF5ECD17F010FF22F5C31CDF184E9020B06FA5997DB84 DUP2 MSTORE POP DUP2 PUSH1 0x20 ADD DUP2 SWAP1 MSTORE POP PUSH1 0x40 MLOAD DUP1 PUSH1 0x40 ADD PUSH1 0x40 MSTORE DUP1 PUSH1 0x40 MLOAD DUP1 PUSH1 0x40 ADD PUSH1 0x40 MSTORE DUP1 PUSH32 0x2E89718AD33C8BED92E210E81D1853435399A271913A6520736A4729CF0D51EB DUP2 MSTORE PUSH1 0x20 ADD PUSH32 0x1A9E2FFA2E92599B68E44DE5BCF354FA2642BD4F26B259DAA6F7CE3ED57AEB3 DUP2 MSTORE POP DUP2 MSTORE PUSH1 0x20 ADD PUSH1 0x40 MLOAD DUP1 PUSH1 0x40 ADD PUSH1 0x40 MSTORE DUP1 PUSH32 0x14A9A87B789A58AF499B314E13C3D65BEDE56C07EA2D418D6874857B70763713 DUP2 MSTORE PUSH1 0x20 ADD PUSH32 0x178FB49A2D6CD347DC58973FF49613A20757D0FCC22079F9ABD10C3BAEE24590 DUP2 MSTORE POP DUP2 MSTORE POP DUP2 PUSH1 0x40 ADD DUP2 SWAP1 MSTORE POP PUSH1 0x40 MLOAD DUP1 PUSH1 0x40 ADD PUSH1 0x40 MSTORE DUP1 PUSH1 0x40 MLOAD DUP1 PUSH1 0x40 ADD PUSH1 0x40 MSTORE DUP1 PUSH32 0x25F83C8B6AB9DE74E7DA488EF02645C5A16A6652C3C71A15DC37FE3A5DCB7CB1 DUP2 MSTORE PUSH1 0x20 ADD PUSH32 0x22ACDEDD6308E3BB230D226D16A105295F523A8A02BFC5E8BD2DA135AC4C245D DUP2 MSTORE POP DUP2 MSTORE PUSH1 0x20 ADD PUSH1 0x40 MLOAD DUP1 PUSH1 0x40 ADD PUSH1 0x40 MSTORE DUP1 PUSH32 0x65BBAD92E7C4E31BF3757F1FE7362A63FBFEE50E7DC68DA116E67D600D9BF68 DUP2 MSTORE PUSH1 0x20 ADD PUSH32 0x6D302580DC0661002994E7CD3A7F224E7DDC27802777486BF80F40E4CA3CFDB DUP2 MSTORE POP DUP2 MSTORE POP DUP2 PUSH1 0x60 ADD DUP2 SWAP1 MSTORE POP PUSH1 0x40 MLOAD DUP1 PUSH1 0x40 ADD PUSH1 0x40 MSTORE DUP1 PUSH32 0x15794AB061441E51D01E94640B7E3084A07E02C78CF3103C542BC5B298669F21 DUP2 MSTORE PUSH1 0x20 ADD PUSH32 0x14DB745C6780E9DF549864CEC19C2DAF4531F6EC0C89CC1C7436CC4D8D300C6D DUP2 MSTORE POP DUP2 PUSH1 0x80 ADD DUP2 SWAP1 MSTORE POP PUSH1 0x40 MLOAD DUP1 PUSH1 0x40 ADD PUSH1 0x40 MSTORE DUP1 PUSH1 0x40 MLOAD DUP1 PUSH1 0x40 ADD PUSH1 0x40 MSTORE DUP1 PUSH32 0x1F39E4E4AFC4BC74790A4A028AFF2C3D2538731FB755EDEFD8CB48D6EA589B5E DUP2 MSTORE PUSH1 0x20 ADD PUSH32 0x283F150794B6736F670D6A1033F9B46C6F5204F50813EB85C8DC4B59DB1C5D39 DUP2 MSTORE POP DUP2 MSTORE PUSH1 0x20 ADD PUSH1 0x40 MLOAD DUP1 PUSH1 0x40 ADD PUSH1 0x40 MSTORE DUP1 PUSH32 0x140D97EE4D2B36D99BC49974D18ECCA3E7AD51011956051B464D9E27D46CC25E DUP2 MSTORE PUSH1 0x20 ADD PUSH32 0x764BB98575BD466D32DB7B15F582B2D5C452B36AA394B789366E5E3CA5AABD4 DUP2 MSTORE POP DUP2 MSTORE POP DUP2 PUSH1 0xA0 ADD DUP2 SWAP1 MSTORE POP PUSH1 0x40 MLOAD DUP1 PUSH1 0x40 ADD PUSH1 0x40 MSTORE DUP1 PUSH1 0x40 MLOAD DUP1 PUSH1 0x40 ADD PUSH1 0x40 MSTORE DUP1 PUSH32 0x217CEE0A9AD79A4493B5253E2E4E3A39FC2DF38419F230D341F60CB064A0AC29 DUP2 MSTORE PUSH1 0x20 ADD PUSH32 0xA3D76F140DB8418BA512272381446EB73958670F00CF46F1D9E64CBA057B53C DUP2 MSTORE POP DUP2 MSTORE PUSH1 0x20 ADD PUSH1 0x40 MLOAD DUP1 PUSH1 0x40 ADD PUSH1 0x40 MSTORE DUP1 PUSH32 0x26F64A8EC70387A13E41430ED3EE4A7DB2059CC5FC13C067194BCC0CB49A9855 DUP2 MSTORE PUSH1 0x20 ADD PUSH32 0x2FD72BD9EDB657346127DA132E5B82AB908F5816C826ACB499E22F2412D1A2D7 DUP2 MSTORE POP DUP2 MSTORE POP DUP2 PUSH1 0xC0 ADD DUP2 SWAP1 MSTORE POP PUSH1 0xA PUSH8 0xFFFFFFFFFFFFFFFF DUP2 GT ISZERO METAPUSH 5 0x278 JUMPI" in 
  (evm_eq_block_chkr_lazy_dbg SMemUpdater_Basic SStrgUpdater_Basic
     MLoadSolver_Basic SLoadSolver_Basic SStackValCmp_Basic SMemCmp_Trivial
     SStrgCmp_Trivial SHA3Cmp_Trivial 
     all_optimization_steps 10 10 b1 b2 500).
     

(* Attempts to prove DIV(X, SHL(Y,1)) = SHR(Y,X) *)
Lemma div_mult_2 (x y:N):
y <> (0%N) -> 
N.div x (y*2) = N.div (N.div x y) 2.
Proof.
intros. rewrite -> N.div_div; try 1intuition.
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

Compute (wones EVMWordSize).
*)

End Debug.

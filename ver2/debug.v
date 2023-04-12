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
Require Import FORVES.optimizations.lt_one.
Import Opt_lt_one.
Require Import FORVES.optimizations.gt_one.
Import Opt_gt_one.
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

From Coq Require Import Lists.List. Import ListNotations.

Module Debug.



Inductive sstack_val_dbg : Type :=
| Val' (val: N)
| InStackVar' (var: nat)
| FreshVar' (var: nat).

Definition sstack_dbg : Type := list sstack_val_dbg.

Definition smemory_dbg : Type := memory_updates sstack_val_dbg.

Definition sstorage_dbg : Type := storage_updates sstack_val_dbg.

Inductive smap_value_dbg : Type :=
| SymBasicVal' (val: sstack_val_dbg)
| SymPUSHTAG' (val: N)
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
| SymPUSHTAG v => SymPUSHTAG' v
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


End Debug.

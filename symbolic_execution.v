Require Import bbv.Word. 
Require Import Nat.
Require Import Coq.NArith.NArith.

Require Import FORVES.constants.
Import Constants.

Require Import FORVES.program.
Import Program.

Require Import FORVES.symbolic_state.
Import SymbolicState.

Require Import FORVES.misc.
Import Misc.

Require Import FORVES.stack_operation_instructions.
Import StackOpInstrs.

Require Import FORVES.memory_ops_solvers.
Import MemoryOpsSolvers.

Require Import FORVES.storage_ops_solvers.
Import StorageOpsSolvers. 

Require Import FORVES.execution_state.
Import ExecutionState.

Require Import List.
Import ListNotations.


Module SymbolicExecution.


Definition push_s (value : EVMWord) :=
  fun (sst : sstate) (ops: stack_op_instr_map) =>
    let sstk := get_stack_sst sst in
    match push (Val value) sstk with
    | None => None
    | Some sstk' => Some (set_stack_sst sst sstk')
    end.

Definition metapush_s (cat value : N) :=
  fun (sst : sstate) (ops: stack_op_instr_map) =>
    let sstk := get_stack_sst sst in
    let sm : smap := get_smap_sst sst in
    let v : smap_value := SymMETAPUSH cat value in
    match add_to_smap sm v with
    | pair key sm' =>
        match push (FreshVar key) sstk with
        | Some sstk' =>
            let sst' := set_stack_sst sst sstk' in
            let sst'' := set_smap_sst sst' sm' in
            Some sst''
        | None => None
        end
    end.

Definition pop_s (sst : sstate)  (ops: stack_op_instr_map) : option sstate :=
  let sstk := get_stack_sst sst in
  match pop sstk with
  | None => None
  | Some sstk' => Some (set_stack_sst sst sstk')
  end.

Definition dup_s (k : nat) (sst : sstate) (ops: stack_op_instr_map) : option sstate :=
  let sstk := get_stack_sst sst in
  match dup k sstk with
  | None => None
  | Some sstk' => Some (set_stack_sst sst sstk')
  end.

Definition swap_s (k : nat) (sst : sstate) (ops: stack_op_instr_map) : option sstate :=
  let sstk := get_stack_sst sst in
  match swap k sstk with
  | None => None
  | Some sstk' => Some (set_stack_sst sst sstk')
  end.

Definition mload_s (mload_solver: mload_solver_type) (sst : sstate) (ops: stack_op_instr_map) : option sstate :=
  let sm : smap := get_smap_sst sst in
  let smem : smemory := get_memory_sst sst in
  match get_stack_sst sst with
  | soffset::sstk =>
      (* let smv := SymMLOAD soffset smem in *)
      let smv :=  mload_solver soffset smem (get_instk_height_sst sst) (get_smap_sst sst) ops in                                       
      match add_to_smap sm smv with
      | pair key sm' =>
          let sst' := set_stack_sst sst ((FreshVar key)::sstk) in
          let sst'' := set_smap_sst sst' sm' in
          Some sst''
      end
  | _ => None
  end.

Definition sload_s (sload_solver: sload_solver_type) (sst : sstate) (ops: stack_op_instr_map) : option sstate :=
  let sm : smap := get_smap_sst sst in
  let sstrg : sstorage := get_storage_sst sst in
  match get_stack_sst sst with
  | skey::sstk =>
      (* let smv := SymSLOAD skey sstrg in *)
      let smv := sload_solver skey sstrg (get_instk_height_sst sst) (get_smap_sst sst) ops in
      match add_to_smap sm smv with
      | pair key sm' =>
          let sst' := set_stack_sst sst ((FreshVar key)::sstk) in
          let sst'' := set_smap_sst sst' sm' in
          Some sst''
      end
  | _ => None
  end.

Definition sha3_s (sst : sstate) (ops: stack_op_instr_map) : option sstate :=
  let sm : smap := get_smap_sst sst in
  let smem : smemory := get_memory_sst sst in
  match get_stack_sst sst with
  | soffset::ssize::sstk =>
      let sv := SymSHA3 soffset ssize smem in
      match add_to_smap sm sv with
      | pair key sm' =>
          let sst' := set_stack_sst sst ((FreshVar key)::sstk) in
          let sst'' := set_smap_sst sst' sm' in
          Some sst''
      end
  | _ => None end.

                                      
  
Definition mstore8_s (smem_updater: smemory_updater_type) (sst : sstate) (ops: stack_op_instr_map) : option sstate :=
  match get_stack_sst sst with
  | soffset::svalue::sstk =>
      let smem := get_memory_sst sst in
      let smem' := smem_updater (U_MSTORE8 sstack_val soffset svalue) smem (get_instk_height_sst sst) (get_smap_sst sst) ops in
      let sst' := set_memory_sst sst smem' in
      (* let sst' := set_memory_sst sst ((U_MSTORE8 sstack_val soffset svalue)::smem) in *)
      let sst'' := set_stack_sst sst' sstk in
      Some sst''
  | _ => None
  end.
      
Definition mstore_s (smem_updater: smemory_updater_type) (sst : sstate) (ops: stack_op_instr_map) : option sstate :=
  match get_stack_sst sst with
  | soffset::svalue::sstk =>
      let smem := get_memory_sst sst in
      let smem' := smem_updater (U_MSTORE sstack_val soffset svalue) smem (get_instk_height_sst sst) (get_smap_sst sst) ops in
      let sst' := set_memory_sst sst smem' in
      (* let sst' := set_memory_sst sst ((U_MSTORE sstack_val soffset svalue)::smem) in *)
      let sst'' := set_stack_sst sst' sstk in
      Some sst''
  | _ => None
  end.

Definition sstore_s (sstrg_updater: sstorage_updater_type) (sst : sstate) (ops: stack_op_instr_map) : option sstate :=
  match get_stack_sst sst with
  | skey::svalue::sstk =>
      let sstrg := get_storage_sst sst in
      let sstrg' := sstrg_updater (U_SSTORE sstack_val skey svalue) sstrg (get_instk_height_sst sst) (get_smap_sst sst) ops in
      let sst' := set_storage_sst sst sstrg' in
      (* let sst' := set_storage_sst sst ((U_SSTORE sstack_val key value)::sstrg) in *)
      let sst'' := set_stack_sst sst' sstk in
      Some sst''
  | _ => None
  end.

Fixpoint all_concrete' (l :list sstack_val) (maxidx: nat) (sb: sbindings) : option (list EVMWord) :=
  match l with
  | [] => Some []
  | sv::l' =>
    match follow_in_smap sv maxidx sb with
    | Some (FollowSmapVal (SymBasicVal (Val v)) _ _) =>
        match (all_concrete' l' maxidx sb) with
        | None => None
        | Some vs => Some (v::vs)
        end
    | _ => None
    end
  end.

Definition all_concrete (l : list sstack_val) (sst : sstate) :=
  let map := get_smap_sst sst in
  let maxidx := get_maxidx_smap map in
  let bs := get_bindings_smap map in
  all_concrete' l maxidx bs.


Definition exec_stack_op_intsr_w_eval_s (label : stack_op_instr) (sst : sstate) (ops : stack_op_instr_map) : option sstate :=
  match (ops label) with
  | OpImp nb_args f _ H_exts =>
      let sstk := get_stack_sst sst in
      match firstn_e nb_args sstk, skipn_e nb_args sstk with
      | Some s1,Some s2 =>
          match H_exts, all_concrete s1 sst with
          | Some _, Some vs =>
              let v := (f empty_externals vs) in
              let sst' := set_stack_sst sst ((Val v)::s2) in
              Some sst'
          | _,_ =>
              let sm : smap := get_smap_sst sst in
              let v : smap_value := SymOp label s1 in
              match add_to_smap sm v with
              | pair key sm' =>
                  let sst' := set_stack_sst sst ((FreshVar key)::s2) in
                  let sst'' := set_smap_sst sst' sm' in
                  Some sst''
              end
              
          end
      | _, _ => None
      end
  end.


Definition exec_stack_op_intsr_s (label : stack_op_instr) (sst : sstate) (ops : stack_op_instr_map) : option sstate :=
  match (ops label) with
  | OpImp nb_args f _ H_exts =>
      let sstk := get_stack_sst sst in
      match firstn_e nb_args sstk, skipn_e nb_args sstk with
      | Some s1,Some s2 =>
          let sm : smap := get_smap_sst sst in
          let v : smap_value := SymOp label s1 in
          match add_to_smap sm v with
          | pair key sm' =>
              let sst' := set_stack_sst sst ((FreshVar key)::s2) in
              let sst'' := set_smap_sst sst' sm' in
              Some sst''
          end
      | _, _ => None
      end
  end.

Definition evm_exec_instr_s (smem_updater: smemory_updater_type) (sstrg_updater: sstorage_updater_type) (mload_solver: mload_solver_type) (sload_solver: sload_solver_type) (inst: instr) (sst: sstate) (ops: stack_op_instr_map): option sstate :=
  match inst with
  | PUSH size w => (push_s (NToWord EVMWordSize w)) sst ops
  | METAPUSH cat v => (metapush_s cat v) sst ops
  | POP => pop_s sst ops
  | DUP pos => dup_s pos sst ops
  | SWAP pos => swap_s pos sst ops
  | MLOAD => mload_s mload_solver sst ops
  | MSTORE8 => mstore8_s smem_updater sst ops
  | MSTORE => mstore_s smem_updater sst ops
  | SLOAD => sload_s sload_solver sst ops
  | SSTORE => sstore_s sstrg_updater sst ops
  | SHA3 => sha3_s sst ops
  | KECCAK256 => sha3_s sst ops
  | OpInstr label => exec_stack_op_intsr_s label sst ops 
  end.

Fixpoint evm_exec_block_s (smem_updater: smemory_updater_type) (sstrg_updater: sstorage_updater_type) (mload_solver: mload_solver_type) (sload_solver: sload_solver_type) (p : block) (sst : sstate) (ops : stack_op_instr_map): option sstate :=
  match p with
  | [] => Some sst
  | instr::instrs' =>
      match (evm_exec_instr_s smem_updater sstrg_updater mload_solver sload_solver instr sst ops) with
      | None => None
      | Some sst' => evm_exec_block_s smem_updater sstrg_updater mload_solver sload_solver instrs' sst' ops
      end
  end.

Definition evm_sym_exec (smem_updater: smemory_updater_type) (sstrg_updater: sstorage_updater_type) (mload_solver: mload_solver_type) (sload_solver: sload_solver_type) (p : block) (instk_height: nat) (ops : stack_op_instr_map): option sstate :=
  let sst := gen_empty_sstate instk_height in 
  evm_exec_block_s smem_updater sstrg_updater mload_solver sload_solver p sst ops.


End SymbolicExecution.

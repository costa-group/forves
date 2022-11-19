Require Import bbv.Word.
Require Import Nat.

Require Import FORVES.constants.
Import FORVES_Constants.

Require Import FORVES.program.
Import FORVES_Program.

Require Import FORVES.symbolic_state.
Import FORVES_SymbolicState.

Require Import FORVES.misc.
Import FORVES_Misc.

Require Import FORVES.stack_operation_instructions.
Import FORVES_StackOpInstrs.

Require Import List.
Import ListNotations.


Module FORVES_SymbolicExecution.


Definition push_s (value : EVMWord) (sst : sstate) : option sstate :=
  let sstk := get_stack_sst sst in
  match push (Val value) sstk with
  | None => None
  | Some sstk' => Some (set_stack_sst sst sstk')
  end.

Definition pop_s (sst : sstate): option sstate :=
  let sstk := get_stack_sst sst in
  match pop sstk with
  | None => None
  | Some sstk' => Some (set_stack_sst sst sstk')
  end.

Definition dup_s (k : nat) (sst : sstate) : option sstate :=
  let sstk := get_stack_sst sst in
  match dup k sstk with
  | None => None
  | Some sstk' => Some (set_stack_sst sst sstk')
  end.

Definition swap_s (k : nat) (sst : sstate) : option sstate :=
  let sstk := get_stack_sst sst in
  match swap k sstk with
  | None => None
  | Some sstk' => Some (set_stack_sst sst sstk')
  end.

Definition mload_s (sst : sstate) : option sstate :=
  let sm : smap := get_smap_sst sst in
  let smem : smemory := get_memory_sst sst in
  match get_stack_sst sst with
  | offset::sstk =>
      let sv := SymMLOAD offset smem in
      match add_to_smap sm sv with
      | pair key sm' =>
          let sst' := set_stack_sst sst ((FreshVar key)::sstk) in
          let sst'' := set_smap_sst sst sm' in
          Some sst'
      end
  | _ => None
  end.

Definition sload_s (sst : sstate) : option sstate :=
  let sm : smap := get_smap_sst sst in
  let sstrg : sstorage := get_storage_sst sst in
  match get_stack_sst sst with
  | skey::sstk =>
      let sv := SymSLOAD skey sstrg in
      match add_to_smap sm sv with
      | pair key sm' =>
          let sst' := set_stack_sst sst ((FreshVar key)::sstk) in
          let sst'' := set_smap_sst sst sm' in
          Some sst'
      end
  | _ => None
  end.

Definition sha3_s (sst : sstate) : option sstate :=
  let sm : smap := get_smap_sst sst in
  let smem : smemory := get_memory_sst sst in
  match get_stack_sst sst with
  | offset::size::sstk =>
      let sv := SymSHA3 offset size smem in
      match add_to_smap sm sv with
      | pair key sm' =>
          let sst' := set_stack_sst sst ((FreshVar key)::sstk) in
          let sst'' := set_smap_sst sst sm' in
          Some sst'
      end
  | _ => None end.

                                      
  
Definition mstore8_s (sst : sstate) : option sstate :=
  match get_stack_sst sst with
  | offset::value::sstk =>
      let smem := get_memory_sst sst in
      let st' := set_memory_sst sst ((U_MSTORE8 sstack_val offset value)::smem) in
      let st'' := set_stack_sst sst sstk in
      Some st''
  | _ => None
  end.
      
Definition mstore_s (sst : sstate) : option sstate :=
  match get_stack_sst sst with
  | offset::value::sstk =>
      let smem := get_memory_sst sst in
      let st' := set_memory_sst sst ((U_MSTORE sstack_val offset value)::smem) in
      let st'' := set_stack_sst sst sstk in
      Some st''
  | _ => None
  end.

Definition sstore_s (sst : sstate) : option sstate :=
  match get_stack_sst sst with
  | key::value::sstk =>
      let sstrg := get_storage_sst sst in
      let st' := set_storage_sst sst ((U_SSTORE sstack_val key value)::sstrg) in
      let st'' := set_stack_sst sst sstk in
      Some st''
  | _ => None
  end.

Definition exec_op_s (sst : sstate) (ops : stack_op_instr_map) (label : stack_op_instr) : option sstate :=
  match (ops label) with
  | None => None
  | Some (OpImp nb_args func _) =>
      let sstk := get_stack_sst sst in
      match firstn_e nb_args sstk, skipn_e nb_args sstk with
      | Some s1,Some s2 =>
          let sm : smap := get_smap_sst sst in
          let v : smap_value := SymOp label s1 in
          match add_to_smap sm v with
          | pair key sm' =>
              let sst' := set_stack_sst sst ((FreshVar key)::s2) in
              let sst'' := set_smap_sst sst sm' in
              Some sst''
          end
      | _, _ => None
      end
  end.

Definition evm_sexec_instr (inst: instr) (sst: sstate) (ops: stack_op_instr_map) : option sstate :=
  match inst with
  | PUSH size w => push_s (NToWord EVMWordSize w) sst
  | POP => pop_s sst
  | DUP pos => dup_s pos sst
  | SWAP pos => swap_s pos sst
  | MLOAD => mload_s sst
  | MSTORE8 => mstore8_s sst
  | MSTORE => mstore_s sst
  | SLOAD => sload_s sst
  | SSTORE => sstore_s sst
  | SHA3 => sha3_s sst
  | KECCAK256 => sha3_s sst
  | OpInstr label => exec_op_s sst ops label
  end.

Fixpoint evm_sexec_block' (p : block) (sst : sstate) (ops : stack_op_instr_map) : option sstate :=
  match p with
  | [] => Some sst
  | inste::instrs' =>
      match (evm_sexec_instr inste sst ops) with
      | None => None
      | Some sst' => evm_sexec_block' instrs' sst' ops
      end
  end.

Definition evm_sexec_block (p : block) (instk_height: nat) (ops : stack_op_instr_map) : option sstate :=
  let sst := gen_empty_sstate instk_height in 
  evm_sexec_block' p sst ops.


End FORVES_SymbolicExecution.  

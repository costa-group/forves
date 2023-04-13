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




Module ConcreteInterpreter.

Definition push_c (v : EVMWord) (st : state) (ops : stack_op_instr_map) : option state :=
  let stk := get_stack_st st in
  match push v stk with
  | None => None
  | Some stk' => Some (set_stack_st st stk')
  end.

Definition pushtag_c (v1 v2 : N) (st : state) (ops : stack_op_instr_map) : option state :=
  let stk := get_stack_st st in
  let tags := (get_tags_ctx (get_context_st st)) in
  let v' := tags v1 v2 in
  match push v' stk with
  | None => None
  | Some stk' => Some (set_stack_st st stk')
  end.

Definition pop_c (st : state) (ops : stack_op_instr_map): option state := let stk := get_stack_st
st in match pop stk with | None => None | Some stk' => Some
(set_stack_st st stk') end.

Definition dup_c (k : nat) (st : state) (ops : stack_op_instr_map) : option state :=
  let stk := get_stack_st st in
  match dup k stk with
  | None => None
  | Some stk' => Some (set_stack_st st stk')
  end.

Definition swap_c (k : nat) (st : state) (ops : stack_op_instr_map) : option state :=
  let stk := get_stack_st st in
  match swap k stk with
  | None => None
  | Some stk' => Some (set_stack_st st stk')
  end.

Fixpoint mload'' (mem : memory) (offset : N) (n: nat) : word (n*8) :=
  match n with
  | O => WO : word (0*8)
  | S n' => bbv.Word.combine (mem offset) (mload'' mem (offset + 1)%N n')
  end.

Definition mload' (mem : memory) (offset : EVMWord) (n: nat) : word (n*8) :=
  mload'' mem (wordToN offset) n.

Definition mload (mem : memory) (offset : EVMWord) : EVMWord :=
  mload' mem offset 32.

Definition split1_byte {sz : nat} (w : word ((S sz)*8)) : word ((S 0)*8) :=
  split1 8 (sz*8) w.

Definition split2_byte {sz : nat} (w : word ((S sz)*8)):=
  split2 8 (sz*8) w.

Fixpoint mstore' {sz : nat} (mem : memory) : (word (sz*8)) -> N -> memory :=
  match sz with
  | O => fun _ _ => mem
  | S sz1' =>
      fun value offset =>
        let byte := split1_byte value in (* split1 8 (8*sz1') value in *)
        let mem' := fun offset' => if (offset' =? offset)%N then byte else mem offset' in
        mstore' mem' (split2_byte value) (offset+1)%N
  end.

Definition mstore {sz : nat} (mem : memory) (value : word (sz*8)) (offset: EVMWord) : memory :=
  mstore' mem value (wordToN offset).

Definition sload (strg : storage) (key : EVMWord) := strg (wordToN key).

Definition sstore (strg : storage) (key : EVMWord) (value : EVMWord) :=
  let nkey := (wordToN key) in
  fun key' => if (key' =? nkey)%N then value else strg key'.



Definition mload_c (st : state) (ops : stack_op_instr_map) : option state :=
  match get_stack_st st with
  | offset::stk => let v := mload (get_memory_st st) offset in
                   let st' := set_stack_st st (v::stk) in
                   Some st'
  | _ => None
  end.



Definition mstore8_c (st : state) (ops : stack_op_instr_map) : option state :=
  match get_stack_st st with
  | offset::value::stk =>
      let mem := mstore (get_memory_st st) (split1_byte (value: word ((S (pred BytesInEVMWord))*8))) offset in
      let st' := set_memory_st st mem in
      let st'' := set_stack_st st' stk in
      Some st''
  | _ => None
  end.

Definition mstore_c (st : state) (ops : stack_op_instr_map)  : option state :=
  match get_stack_st st with
  | offset::value::stk =>
      let mem := mstore (get_memory_st st) value offset in
      let st' := set_memory_st st mem in
      let st'' := set_stack_st st' stk in Some st''
  | _ => None
  end.

Definition sload_c (st : state) (ops : stack_op_instr_map) : option state :=
  match get_stack_st st with
  | key::stk =>
      let v := sload (get_storage_st st) key in
      let st' := set_stack_st st (v::stk) in
      Some st'
  | _ => None
  end.

Definition sstore_c (st : state) (ops : stack_op_instr_map) : option state :=
  match get_stack_st st with
  | key::value::stk =>
      let strg := sstore (get_storage_st st) key value in
      let st' := set_store_st st strg in
       let st'' := set_stack_st st' stk in
      Some st''
  | _ => None
  end.

(* just return 0 for now *)
Definition sha3_c (st : state) (ops : stack_op_instr_map) : option state :=
  match get_stack_st st with
  | offset::size::stk =>
      let f := get_keccak256_ctx (get_context_st st) in
      (*      let v := f (get_memory_st st) offset size in *)
      let v := f (wordToNat size) (mload' (get_memory_st st) offset (wordToNat size)) in
      let st' := set_stack_st st (v::stk) in
      Some st'
  | _ => None
  end.

Definition exec_stack_op_intsr_c (label : stack_op_instr) (st : state) (ops : stack_op_instr_map)  : option state :=
  match (ops label) with
  | OpImp nb_args func _ _ =>
      let stk := get_stack_st st in
      match firstn_e nb_args stk with
      | None => None
      | Some args => match skipn_e nb_args stk with
                     | None => None
                     | Some stk' =>
                         let v := func (get_context_st st) args in
                         let st':= set_stack_st st (v :: stk') in
                         Some st'
                     end
      end
  end.

(* Concrete interpreter *)
Definition evm_exec_instr_c (inst : instr) (st: state) (ops : stack_op_instr_map) : option state :=
  match inst with
  | PUSH size v => push_c (NToWord EVMWordSize v) st ops
  | PUSHTAG cat v => pushtag_c cat v st ops
  | POP => pop_c st ops
  | DUP k => dup_c k st ops
  | SWAP k => swap_c k st ops
  | MLOAD => mload_c st ops
  | MSTORE8 => mstore8_c st ops
  | MSTORE => mstore_c st ops
  | SLOAD => sload_c st ops
  | SSTORE => sstore_c st ops
  | SHA3 => sha3_c st ops
  | KECCAK256 => sha3_c st ops
  | OpInstr label => exec_stack_op_intsr_c label st ops
  end.

               
Fixpoint evm_exec_block_c (p : block) (st : state) (ops : stack_op_instr_map) : option state :=
  match p with
  | [] => Some st
  | instr::instrs' =>
      match evm_exec_instr_c instr st ops with
      | None => None
      | Some st' => evm_exec_block_c instrs' st' ops
      end
  end.





End ConcreteInterpreter.
  

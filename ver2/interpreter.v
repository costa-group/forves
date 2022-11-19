Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import Coq.NArith.NArith.
Require Import List.
Import ListNotations.

Module EVM_Def.

(* Byte *)
Definition EVMByteSize: nat := 8. 
Definition EVMByte := word EVMByteSize. 

(* Word *)
Definition BytesInEVMWord: nat := 32. 
Definition EVMWordSize: nat := BytesInEVMWord*EVMByteSize. 
Definition EVMWord:= word EVMWordSize.

(* Address *)
Definition ByteInEVMAddr : nat := 20. 
Definition EVMAddrSize : nat := ByteInEVMAddr*EVMByteSize.
Definition EVMAddr := word EVMAddrSize.

(* Predefined constants *)
Definition BZero: EVMByte  := natToWord EVMByteSize 0.
Definition BOne : EVMByte  := natToWord EVMByteSize 1.

Definition WZero: EVMWord  := natToWord EVMWordSize 0.
Definition WOne : EVMWord  := natToWord EVMWordSize 1.

Definition AZero: EVMAddr  := natToWord EVMAddrSize 0.
Definition AOne : EVMAddr  := natToWord EVMAddrSize 1.

(* Maximum size of the stack *)
Definition StackSize := 1024.


End EVM_Def.
Import EVM_Def.


(*

Stack operation instructions: they require only the context and the
stack as input, they compute a value (to be pushed to the stack) given
the input.

*)

Inductive stack_op_instr :=
| ADD
| MUL
| SUB
| DIV
| SDIV
| MOD
| SMOD
| ADDMOD
| MULMOD
| EXP
| SIGNEXTEND
| LT
| GT
| SLT
| SGT
| EQ
| ISZERO
| AND
| OR
| XOR
| NOT
| BYTE
| SHL
| SHR
| SAR
| ADDRESS
| BALANCE
| ORIGIN
| CALLER
| CALLVALUE
| CALLDATALOAD
| CALLDATASIZE
| CODESIZE
| GASPRICE
| EXTCODESIZE
| RETURNDATASIZE
| EXTCODEHASH
| BLOCKHASH
| COINBASE
| TIMESTAMP
| NUMBER
| DIFFICULTY
| GASLIMIT
| CHAINID
| SELFBALANCE
| BASEFEE.


Definition eqb_stack_op_instr (a b: stack_op_instr) : bool :=
  match a,b with
  | ADD,ADD => true
  | MUL,MUL => true
  | SUB,SUB => true
  | DIV,DIV => true
  | SDIV,SDIV => true
  | MOD,MOD => true
  | SMOD,SMOD => true
  | ADDMOD,ADDMOD => true
  | MULMOD,MULMOD => true
  | EXP,EXP => true
  | SIGNEXTEND,SIGNEXTEND => true
  | LT,LT => true
  | GT,GT => true
  | SLT,SLT => true
  | SGT,SGT => true
  | EQ,EQ => true
  | ISZERO,ISZERO => true
  | AND,AND => true
  | OR,OR => true
  | XOR,XOR => true
  | NOT,NOT => true
  | BYTE,BYTE => true
  | SHL,SHL => true
  | SHR,SHR => true
  | SAR,SAR => true
  | ADDRESS,ADDRESS => true
  | BALANCE,BALANCE => true
  | ORIGIN,ORIGIN => true
  | CALLER,CALLER => true
  | CALLVALUE,CALLVALUE => true
  | CALLDATALOAD,CALLDATALOAD => true
  | CALLDATASIZE,CALLDATASIZE => true
  | GASPRICE,GASPRICE => true
  | EXTCODESIZE,EXTCODESIZE => true
  | RETURNDATASIZE,RETURNDATASIZE => true
  | EXTCODEHASH,EXTCODEHASH => true
  | BLOCKHASH,BLOCKHASH => true
  | COINBASE,COINBASE => true
  | TIMESTAMP,TIMESTAMP => true
  | NUMBER,NUMBER => true
  | DIFFICULTY,DIFFICULTY => true
  | GASLIMIT,GASLIMIT => true
  | CHAINID,CHAINID => true
  | SELFBALANCE,SELFBALANCE => true
  | BASEFEE,BASEFEE => true
  | CODESIZE,CODESIZE => true
  | _,_ => false
  end.

Notation "m '=?i' n" := (eqb_stack_op_instr m n) (at level 100).


(*

Instructions: (1) the basic stack manipulation ones -- PUSH, POP, DUP
and SWAP; (2) instruction that operate on memory/store; and (3) the
stack operation instructions above.

*)


Inductive instr :=
| PUSH (size : nat) (v: N)
| POP
| DUP (pos: nat)
| SWAP (pos: nat)
| SLOAD
| SSTORE
| MLOAD
| MSTORE
| MSTORE8
| SHA3
| KECCAK256
| OpInstr (label: stack_op_instr).


(* A block is a list instructions *)
Definition block : Type := list instr.  


(*** Execution State and its auxiliary data-structures ***)

(* Stack is a list of EVMWord *)
Definition stack : Type := list EVMWord.
Definition empty_stack : stack := [].

(* Memory is a mapping from EVMWord to EVMByte. We do not keep its
accessed size, i.e., don't handle memory expansion, because we don't
track gas consumption. *)
Definition memory : Type := EVMWord -> EVMByte.
Definition empty_memory : memory := fun _ => BZero.

(* Storage is a function from EVMWord (key) to values EVMWord
(value). We don't model the warm/cold properies since we don't track
gas consumption *)
Definition storage : Type := EVMWord -> EVMWord.
Definition empty_storage : storage := fun _ => WZero.

(*

Context is a strute that we use to encapsulates all
contract/blockchain information, and operations that we don't want to
implement such as KECCAK256 (correctness will be shown for any value
of such operations). The structure is immutable.

*)

Inductive code_info :=
| CodeInfo (size : nat) (content : word size) (hash : EVMWord).

Inductive block_info :=
| BlockInfo (size : nat) (content : word size) (timestamp: EVMWord) (hash : EVMWord).

Inductive chunk :=
| Chunk (size : nat) (content : word size).
        
Inductive context :=
Ctx
  (address : EVMAddr)
  (balance : EVMAddr -> EVMWord)
  (origin : EVMAddr)
  (caller : EVMAddr)
  (callvalue : EVMWord)
  (data: chunk)
  (code : EVMAddr -> code_info ) 
  (gasprice : EVMWord)
  (outdata: chunk)
  (blokcs : EVMWord -> block_info)
  (miner : EVMAddr)
  (currblock : EVMWord)
  (gaslimit : EVMWord)
  (chainid : EVMWord)
  (basefee : EVMWord)
  (keccak256 : memory -> EVMWord -> EVMWord -> EVMWord)
  (_extra_1 : nat)
  (_extra_2 : nat)
  (_extra_3 : nat)
  (_extra_4 : nat)
  (_extra_5 : nat).


Definition empty_context : context :=
 Ctx
  AZero (* (address : EVMAddr) *)
  (fun _ => WZero) (* (balance : EVMAddr -> EVMWord) *)
  AZero (* (origin : EVMAddr) *)
  AZero (* (caller : EVMAddr) *)
  WZero (* (callvalue : EVMWord) *)
  (Chunk 0 WO) (* (data: chunk) *)
  (fun _ => CodeInfo 0 WO WZero) (* (code : EVMAddr -> code_info )  *)
  WZero (* (gasprice : EVMWord) *)
  (Chunk 0 WO) (* (outdata: chunk) *)
  (fun _ => BlockInfo 0 WO WZero WZero) (* (blokcs : EVMWord -> block_info) *)
  AZero (* (miner : EVMAddr) *)
  WZero (* (currblock : EVMWord) *)
  WZero (* (gaslimit : EVMWord) *)
  WZero (* (chainid : EVMWord) *)
  WZero (* (basefee : EVMWord) *)
  (fun _ _ _ => WZero) (* (keccak256 : memory -> EVMWord -> EVMWord -> EVMWord) *)
  0 (* (_extra_1 : nat) *)
  0 (* (_extra_2 : nat) *)
  0 (* (_extra_3 : nat) *)
  0 (* (_extra_4 : nat) *)
  0. (* (_extra_5 : nat) *)
    
(* Ctx _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ *)

Definition get_address_ctx (c : context) :=
  match c with
  | Ctx x _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_balance_ctx (c : context) :=
  match c with
  | Ctx _ x _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_origin_ctx (c : context) :=
  match c with
  | Ctx _ _ x _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_caller_ctx (c : context) :=
  match c with
  | Ctx _ _ _ x _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_callvalue_ctx (c : context) :=
  match c with
  | Ctx _ _ _ _ x _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_data_ctx (c : context) :=
  match c with
  | Ctx _ _ _ _ _ x _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_code_ctx (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ x _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_gasprice_ctx (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_outdata_ctx (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_blokcs_ctx (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_miner_ctx (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_currblock_ctx (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_gaslimit_ctx (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _ => x
  end.

Definition get_chainid_ctx (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ => x
  end.

Definition get_basefee_ctx (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ _ _ _ _ _ _ _ _ x _ _ _ _ _ _ => x
  end.

Definition get_keccak256_ctx (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ x _ _ _ _ _ => x
  end.



Inductive state :=
| ExState (stk: stack) (mem: memory) (stg: storage) (ctx :context).

Definition make_st (stk: stack) (mem: memory) (strg: storage) (ctx : context) : state :=
  ExState stk mem strg ctx.

Definition empty_state := make_st empty_stack empty_memory empty_storage empty_context.

Definition get_stack_st (st: state) : stack :=
  match st with
  | ExState stk _ _ _ => stk
  end.

Definition set_stack_st (st: state) (stk: stack) : state :=
  match st with
  | ExState _ mem strg ctx => ExState stk mem strg ctx
  end.

Definition get_memory_st (st: state) : memory :=
  match st with
  | ExState _ mem _ _=> mem
  end.

Definition set_memory_st (st: state) (mem: memory) : state :=
  match st with
  | ExState stk _ strg ctx => ExState stk mem strg ctx
  end.

Definition get_storage_st (st: state) : storage :=
  match st with
  | ExState _ _ strg _ => strg
  end.

Definition set_store_st (st: state) (strg: storage) : state :=
  match st with
  | ExState stk mem _ ctx => ExState stk mem strg ctx
  end.

Definition get_context_st (st: state) : context :=
  match st with
  | ExState _ _ _ ctx => ctx
  end.

Definition set_context_st (st: state) (ctx: context) : state :=
  match st with
  | ExState stk mem strg _ => ExState stk mem strg ctx
  end.
  
(************)



(* Some stack operation instructions are commutative, a property that
might be used when optimizing a block. The following definition models
this property. *)
Definition commutative_op (f : context -> list EVMWord -> EVMWord) : Prop :=
  forall (a b : EVMWord) (ctx : context), f ctx [a;b] = f ctx [b;a].

(* An implementation of a stack operation instructions *)
Inductive stack_op_impl :=
| OpImp (n : nat) (f : context -> list EVMWord -> EVMWord) (H : option (commutative_op f)).


(* The maps here link an opcode (oper_label) to an operator *)
 
Definition map (K V : Type) : Type := K -> option V.

Definition stack_op_instr_map := map stack_op_instr stack_op_impl.

Definition empty_imap {A : Type} : map stack_op_instr A :=
  (fun _ =>  None).

Definition updatei {A : Type} (m : map stack_op_instr A) (x : stack_op_instr) (v : A) :=
  fun x' => if x =?i x' then Some v else m x'.

Notation "x '|->i' v ';' m" := (updatei m x v) (at level 100, v at next level, right associativity).
Notation "x '|->i' v" := (updatei empty_imap x v) (at level 100).



(******* stack manipulation operators ********)


Definition firstn_e {A: Type} (n: nat) (l: list A) : option (list A) :=
  if n <=? length l then Some (firstn n l) else None.

Definition skipn_e {A: Type} (n:nat) (l:list A) : option (list A) :=
  if n <=? length l then Some (skipn n l) else None.

(* Polymorphic versions for manipulating the stack *)
Definition push {T : Type} (v : T) (stk : list T) : option (list T) :=
  if List.length(stk) <? StackSize then Some (v :: stk) else None.

Definition pop {T : Type} (stk: list T): option (list T) :=
  match stk with
  | x::stk' => Some stk'
  | _ => None
  end.

Definition dup {T: Type} (k : nat) (stk: list T) : option (list T) :=
  if ((k =? 0) || (16 <? k) || (StackSize <=? List.length(stk))) then None
  else match nth_error stk (pred k) with
       | None => None
       | Some x => Some (x::stk)
       end.

Definition swap {T: Type} (k : nat) (stk: list T) : option (list T) :=
  if ((k =? 0) || (16 <? k)) then None
  else match (nth_error stk k, stk) with
       | (Some v, h::t) => Some ([v] ++ ((firstn (k-1) t)) ++ [h] ++ (skipn (k+1) stk))
       | _ => None
       end.

(* version operating on execution states *)
Definition push_c (v : EVMWord) (st : state) : option state :=
  let stk := get_stack_st st in
  match push v stk with
  | None => None
  | Some stk' => Some (set_stack_st st stk')
  end.

Definition pop_c (st : state): option state := let stk := get_stack_st
st in match pop stk with | None => None | Some stk' => Some
(set_stack_st st stk') end.

Definition dup_c (k : nat) (st : state) : option state :=
  let stk := get_stack_st st in
  match dup k stk with
  | None => None
  | Some stk' => Some (set_stack_st st stk')
  end.

Definition swap_c (k : nat) (st : state) : option state :=
  let stk := get_stack_st st in
  match swap k stk with
  | None => None
  | Some stk' => Some (set_stack_st st stk')
  end.

Definition mload_ (mem : memory) (offset : EVMWord) :=
  fix mload_fix (n : nat) : word (n * 8) :=
    match n with
    | O => WO
    | S n' => bbv.Word.combine (mem (wplus offset (natToWord EVMWordSize n))) (mload_fix n')
    end.

Definition mload (mem : memory) (offset : EVMWord) : EVMWord :=
  mload_ mem offset 32.
  
Definition mstore8 (mem : memory) (offset : EVMWord) (value : EVMByte)
  := fun offset' => if (weqb offset' offset) then value else mem
  offset'.

Fixpoint mstore {sz : nat} (mem : memory) : (word sz) -> EVMWord -> memory :=
  match sz with
  | S (S (S (S (S (S (S (S sz1'))))))) =>
      fun value offset =>
        let byte := split1 8 sz1' value in
        let mem' := fun offset' => if (weqb offset' offset) then byte else mem offset' in
        mstore mem (bbv.Word.split2 8 sz1' value) (wplus offset WOne)
  | _ => fun _ _ => mem
  end.

Definition sload (strg : storage) (key : EVMWord) := strg key.

Definition sstore (strg : storage) (key : EVMWord) (value : EVMWord) :=
  fun key' => if (weqb key' key) then value else strg key'.

Definition mload_c (st : state) : option state :=
  match get_stack_st st with
  | offset::stk => let v := mload (get_memory_st st) offset in
                   let st' := set_stack_st st (v::stk) in
                   Some st'
  | _ => None end.

Definition mstore8_c (st : state) : option state :=
  match get_stack_st st with
  | offset::value::stk =>
      let mem := mstore8 (get_memory_st st) offset (split1 8 (EVMWordSize-8) value) in
      let st' := set_memory_st st mem in
      let st'' := set_stack_st st' stk in
      Some st''
  | _ => None end.

Definition mstore_c (st : state) : option state :=
  match get_stack_st st with
  | offset::value::stk =>
      let mem := mstore (get_memory_st st) offset value in
      let st' := set_memory_st st mem in
      let st'' := set_stack_st st' stk in Some st''
  | _ => None end.

Definition sload_c (st : state) : option state :=
  match get_stack_st st with
  | key::stk =>
      let v := sload (get_storage_st st) key in
      let st' := set_stack_st st (v::stk) in
      Some st'
  | _ => None end.

Definition sstore_c (st : state) : option state :=
  match get_stack_st st with
  | key::value::stk =>
      let strg := sstore (get_storage_st st) key value in
      let st' := set_store_st st strg in
      let st'' := set_stack_st st' stk in
      Some st''
  | _ => None end.

(* just return 0 for now *)
Definition sha3_c (st : state) : option state :=
  match get_stack_st st with
  | offset::size::stk =>
      let f := get_keccak256_ctx (get_context_st st) in
      let v := f (get_memory_st st) offset size in
      let st' := set_stack_st st (v::stk) in
      Some st'
  | _ =>
None end.

Definition exec_stack_op_intsr_c (st : state) (ops : stack_op_instr_map) (label : stack_op_instr) : option state :=
  match (ops label) with
  | None => None
  | Some (OpImp nb_args func _) =>
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
Definition evm_exec_instr (inst : instr) (st: state) (ops : stack_op_instr_map) : option state :=
  match inst with
  | PUSH size v => push_c (NToWord EVMWordSize v) st
  | POP => pop_c st
  | DUP k => dup_c k st
  | SWAP k => swap_c k st
  | MLOAD => mload_c st
  | MSTORE8 => mstore8_c st
  | MSTORE => mstore_c st
  | SLOAD => sload_c st
  | SSTORE => sstore_c st
  | SHA3 => sha3_c st
  | KECCAK256 => sha3_c st
  | OpInstr label => exec_stack_op_intsr_c st ops label
  end.

               
Fixpoint evm_exec_block (p : block) (st : state) (ops : stack_op_instr_map) : option state :=
  match p with
  | [] => Some st
  | instr::instrs' =>
      match evm_exec_instr instr st ops with
      | None => None
      | Some st' => evm_exec_block instrs' st' ops
      end
  end.




(* =================================================================
*) (** ** Implementation of current instructions *)

Definition evm_add (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wplus a b
  | _ => WZero
  end.

Lemma add_comm: commutative_op evm_add.
Proof.
  unfold commutative_op.
  intros.
  unfold evm_add.
  rewrite -> wplus_comm.
  reflexivity.
Qed.
        
Definition evm_mul (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wmult a b
  | _ => WZero
  end.


Definition evm_sub (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wminus a b
  | _ => WZero
  end.

Definition evm_div (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wdiv a b
  | _ => WZero
  end.

Definition evm_sdiv (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_mod (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_smod (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_addmod (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_mulmod (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_exp (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => NToWord EVMWordSize (N.pow (wordToN a) (wordToN b))
  | _ => WZero
  end.
  

Definition evm_signextend (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_lt (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => if (N.ltb (wordToN a) (wordToN b)) then WOne else WZero
  | _ => WZero
  end.

Definition evm_gt (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => evm_lt ctx [b; a]
  | _ => WZero
  end.

Definition evm_slt (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_sgt (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_eq (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => if weqb a b then WOne else WZero
  | _ => WZero
  end.
  
Definition evm_iszero (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a] => evm_eq ctx [a; WZero]
  | _ => WZero
  end.

Definition evm_and (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wand a b
  | _ => WZero
  end.

Definition evm_or (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wor a b
  | _ => WZero
  end.

Definition evm_xor (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wxor a b
  | _ => WZero
  end.

Definition evm_not (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a] => wnot a
  | _ => WZero
  end.

Definition evm_byte (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_shl (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wlshift' b (wordToNat a)
  | _ => WZero
  end.

Definition evm_shr (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wrshift' b (wordToNat a)
  | _ => WZero
  end.

Definition evm_sar (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_address (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_balance (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_origin (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_caller (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_callvalue (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_calldataload (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_calldatasize (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_codesize (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_gasprice (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_extcodesize (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_returndatasize (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_extcodehash (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_blockhash (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_coinbase (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_timestamp (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_number (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_difficulty (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_gaslimit (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_chainid (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_selfbalance (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_basefee (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.


Definition evm_stack_opm : stack_op_instr_map :=
  ADD |->i OpImp 2 evm_add (Some add_comm);
  MUL |->i OpImp 2 evm_mul None;
  SUB |->i OpImp 2 evm_sub None;
  DIV |->i OpImp 2 evm_div None;
  SDIV |->i OpImp 2 evm_sdiv None;
  MOD |->i OpImp 2 evm_mod None;
  SMOD |->i OpImp 2 evm_smod None;
  ADDMOD |->i OpImp 3 evm_addmod None;
  MULMOD |->i  OpImp 3 evm_mulmod None;
  EXP |->i OpImp 2 evm_exp None;
  SIGNEXTEND  |->i OpImp 2 evm_signextend None;
  LT |->i OpImp 2 evm_lt None;
  GT  |->i OpImp 2 evm_gt None;
  SLT |->i OpImp 2 evm_slt None;
  SGT |->i  OpImp 2 evm_sgt None;
  EQ |->i OpImp 2 evm_eq None;
  ISZERO |->i OpImp  1 evm_iszero None;
  AND |->i OpImp 2 evm_and None;
  OR |->i OpImp 2  evm_or None;
  XOR |->i OpImp 2 evm_xor None;
  NOT |->i OpImp 1 evm_not  None;
  BYTE |->i OpImp 2 evm_byte None;
  SHL |->i OpImp 2 evm_shl  None;
  SHR |->i OpImp 2 evm_shr None;
  SAR |->i OpImp 2 evm_sar None;
  ADDRESS |->i OpImp 0 evm_address None;
  BALANCE |->i OpImp 1  evm_balance None;
  ORIGIN |->i OpImp 0 evm_origin None;
  CALLER |->i  OpImp 0 evm_caller None;
  CALLVALUE |->i OpImp 0 evm_callvalue None;
  CALLDATALOAD |->i OpImp 1 evm_calldataload None;
  CALLDATASIZE |->i  OpImp 0 evm_calldatasize None;
  CODESIZE |->i OpImp 0 evm_codesize  None;
  GASPRICE |->i OpImp 0 evm_gasprice None;
  EXTCODESIZE |->i  OpImp 1 evm_extcodesize None;
  RETURNDATASIZE |->i OpImp 0  evm_returndatasize None;
  EXTCODEHASH |->i OpImp 1 evm_extcodehash  None;
  BLOCKHASH |->i OpImp 1 evm_blockhash None;
  COINBASE |->i OpImp  0 evm_coinbase None;
  TIMESTAMP |->i OpImp 0 evm_timestamp None;
  NUMBER |->i OpImp 0 evm_number None;
  DIFFICULTY |->i OpImp 0  evm_difficulty None;
  GASLIMIT |->i OpImp 0 evm_gaslimit None;
  CHAINID |->i OpImp 0 evm_chainid None;
  SELFBALANCE |->i OpImp 0  evm_selfbalance None;
  BASEFEE |->i OpImp 0 evm_basefee None.
 

(* symbolic stack *)

Inductive sstack_val : Type :=
| Val (val: EVMWord)
| InStackVar (var: nat)
| FreshVar (var: nat).

Definition sstack : Type := list sstack_val.
Definition empty_sstack : sstack := [].

(* Symbolic memory *)

Inductive memory_update (A : Type) : Type :=
| U_MSTORE (offset: A) (value: A)
| U_MSTORE8 (offset: A) (value: A).

Definition memory_updates (A : Type) : Type := list (memory_update A).

Definition smemory : Type := memory_updates sstack_val.
Definition empty_smemory : smemory := [].

(* Symbolic storage *)

Inductive storage_update (A : Type) : Type :=
| U_SSTORE (key: A) (value: A).

Definition storage_updates (A : Type) : Type := list (storage_update A).

Definition sstorage : Type := storage_updates sstack_val.
Definition empty_sstorage : sstorage := [].

Inductive scontext :=
  | SymCtx. 
Definition empty_scontext : scontext := SymCtx.

Inductive smap_value : Type :=
| SymBasicVal (val: sstack_val)
| SymOp (label : stack_op_instr) (args : list sstack_val)
| SymMLOAD (offset: sstack_val) (smem : smemory)
| SymSLOAD (key: sstack_val) (sstrg : sstorage)
| SymSHA3 (offset: sstack_val) (size: sstack_val) (smem : smemory).

Definition sbindings : Type := list (nat*smap_value).
Inductive smap := SymMap (maxid : nat) (map: sbindings).
Definition empty_smap : smap := SymMap 0 [].

Inductive sstate :=
| SymExState (instk_height: nat) (sstk: sstack) (smem: smemory) (sstg: sstorage) (sctx : scontext) (sm: smap).

Definition make_sst (instk_height: nat) (sstk: sstack) (smem: smemory) (sstrg: sstorage) (sctx : scontext) (sm: smap) : sstate :=
  SymExState instk_height sstk smem sstrg sctx sm.

Definition gen_empty_sstate (instk_height: nat) : sstate :=
  let ids := seq 0 instk_height in
  let sstk := List.map InStackVar ids in
  make_sst instk_height sstk empty_smemory empty_sstorage empty_scontext empty_smap.

Definition get_instk_height_sst (sst: sstate) : nat :=
  match sst with
  | SymExState instk_height _ _ _ _ _ => instk_height
  end.

Definition set_instk_height_sst (sst: sstate) (instk_height : nat) : sstate :=
  match sst with
  | SymExState _ sstk smem sstrg sctx sm => SymExState instk_height sstk smem sstrg sctx sm
  end.

Definition get_stack_sst (sst: sstate) : sstack :=
  match sst with
  | SymExState _ sstk _ _ _ _ => sstk
  end.

Definition set_stack_sst (sst: sstate) (sstk: sstack) : sstate :=
  match sst with
  | SymExState instk_height _ smem sstrg sctx sm => SymExState instk_height sstk smem sstrg sctx sm
  end.

Definition get_memory_sst (sst: sstate) : smemory :=
  match sst with
  | SymExState _ _ smem _ _ _ => smem
  end.

Definition set_memory_sst (sst: sstate) (smem: smemory) : sstate :=
  match sst with
  | SymExState instk_height sstk _ sstrg sctx sm => SymExState instk_height sstk smem sstrg sctx sm
  end.

Definition get_storage_sst (sst : sstate) : sstorage :=
  match sst with
  | SymExState _ _ _ sstrg _ _ => sstrg
  end.

Definition set_storage_sst (sst : sstate) (sstrg: sstorage) : sstate :=
  match sst with
  | SymExState instk_height sstk smem _ sctx sm => SymExState instk_height sstk smem sstrg sctx sm
  end.

Definition get_context_sst (sst : sstate) : scontext :=
  match sst with
  | SymExState _ _ _ _ sctx _ => sctx
  end.

Definition set_context_sst (sst : sstate) (sctx: scontext) : sstate :=
  match sst with
  | SymExState instk_height sstk smem sstrg _ sm => SymExState instk_height sstk smem sstrg sctx sm
  end.

Definition get_smap_sst (sst : sstate) : smap :=
  match sst with
  | SymExState _ _ _ _ _ sm => sm
  end.

Definition set_smap_sst (sst : sstate) (sm: smap) : sstate :=
  match sst with
  | SymExState instk_height sstk smem sstrg sctx _ => SymExState instk_height sstk smem sstrg sctx sm
  end.

Definition add_to_smap (sm : smap) (value : smap_value) : prod nat smap :=
  match sm with
  | SymMap maxid map =>
      let sm' := SymMap (S maxid) ((pair maxid value)::map) in
       pair maxid sm'
  end.

Fixpoint find_in_smap' (key : nat) (sm : list (nat*smap_value)) : option smap_value :=
  match sm with
  | [] => None
  | (pair k sv)::sm' => if k =? key then Some sv else find_in_smap' key sm'
  end.

Definition find_in_smap (key : nat) (sm : smap) : option smap_value :=
  match sm with
  | SymMap maxid map => find_in_smap' key map
  end.


(*

Inductive sexpr : Type :=
| SExpr_Val (val: EVMWord)
| SExpr_InStkVar (var : nat)
| SExpr_Op (label : stack_op_instr) (args : list sexpr)
| SExpr_MLOAD (offset: sstack_val) (smem : smemory)
| SExpr_SLOAD (key: sstack_val) (sstrg : sstorage)
| SExpr_SHA3 (offset: sstack_val) (size: sstack_val) (smem : smemory).

 *)

(************)


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



Definition update_memory' (mem: memory) (update : memory_update EVMWord) :=
  match update with
  | U_MSTORE _ offset value => mstore mem offset value
  | U_MSTORE8 _ offset value => mstore8 mem offset (split1 8 (EVMWordSize-8) value)
  end.

Fixpoint update_memory (mem: memory) (updates : memory_updates EVMWord) :=
  match updates with
  | [] => mem
  | u::us =>
      let mem' := update_memory' mem u in
      update_memory mem' us
  end.

Definition update_storage' (strg: storage) (update : storage_update EVMWord) :=
  match update with
  | U_SSTORE _ key value => sstore strg key value
  end.

Fixpoint update_storage (strg: storage) (updates : storage_updates EVMWord) :=
  match updates with
  | [] => strg
  | u::us =>
      let strg' := update_storage' strg u in
      update_storage strg' us
  end.

Fixpoint apply_f_list_sstack_val {A B : Type} (f: A -> option B) (l: list A) :
  option (list B) :=
match l with 
| nil => Some []
| elem::rs => let elem_oval := f elem in
              let rs_oval := apply_f_list_sstack_val f rs in
              match (elem_oval, rs_oval) with 
              | (Some elem_val, Some rs_val) => Some (elem_val::rs_val)
              | _ => None
              end
end.

        
Fixpoint eval_sstack_val (sv : sstack_val) (st: state) (sb: sbindings) (ops: stack_op_instr_map) : option EVMWord :=
  match sv with
  | Val v => Some v
  | InStackVar n =>
      let stk := get_stack_st st in
      match nth_error stk n with
      | Some v => Some v
      | None => None
      end
  | FreshVar idx =>
      match sb with
      | [] => None
      | (key,smv)::sb' =>
          if key =? idx then
            match smv with
            (* basic value *)
            | SymBasicVal v => eval_sstack_val v st sb' ops
            (* stack operation instruction *)
            | SymOp label args =>
                match ops label with
                | None => None
                | Some (OpImp nargs f _) => 
                    if (List.length args =? nargs) then
                      let f_eval_list := fun (sv': sstack_val) => eval_sstack_val sv' st sb' ops in
                      match apply_f_list_sstack_val f_eval_list args with
                      | None => None
                      | Some vargs => Some (f (get_context_st st) vargs)
                      end
                    else None
                end
            (* memory read *)
            | SymMLOAD soffset smem =>
                let f_eval_memupdate := fun (update: memory_update sstack_val) =>
                                          match update with
                                          | U_MSTORE _ soffset svalue =>
                                              let ooffset := eval_sstack_val soffset st sb' ops in
                                              let ovalue := eval_sstack_val svalue st sb' ops in
                                              match ooffset, ovalue with
                                              | Some offset, Some value => Some (U_MSTORE EVMWord offset value)
                                              | _, _ => None
                                              end
                                          | U_MSTORE8 _ soffset svalue =>
                                              let ooffset := eval_sstack_val soffset st sb' ops in
                                              let ovalue := eval_sstack_val svalue st sb' ops in
                                              match ooffset, ovalue with
                                              | Some offset, Some value => Some (U_MSTORE8 EVMWord offset value)
                                              | _, _ => None
                                              end
                                          end
                in
                match apply_f_list_sstack_val f_eval_memupdate smem with
                | None => None
                | Some mem_updates =>
                    match eval_sstack_val soffset st sb' ops with
                    | None => None
                    | Some offset =>
                        let mem := update_memory (get_memory_st st) mem_updates in
                        Some (mload mem offset)
                    end
                end
            (* storage read *)
            | SymSLOAD skey sstrg =>
                let f_eval_strgupdate := fun (update: storage_update sstack_val) =>
                                          match update with
                                          | U_SSTORE _ skey svalue =>
                                              let okey := eval_sstack_val skey st sb' ops in
                                              let ovalue := eval_sstack_val svalue st sb' ops in
                                              match okey, ovalue with
                                              | Some key, Some value => Some (U_SSTORE EVMWord key value)
                                              | _, _ => None
                                              end
                                          end
                in
                match apply_f_list_sstack_val f_eval_strgupdate sstrg with
                | None => None
                | Some strg_updates =>
                    match eval_sstack_val skey st sb' ops with
                    | None => None
                    | Some key =>
                        let strg := update_storage (get_storage_st st) strg_updates in
                        Some (sload strg key)
                    end
                end

            (* SHA3 and KECCAK256 *)
            | SymSHA3 soffset ssize smem =>
                                let f_eval_memupdate := fun (update: memory_update sstack_val) =>
                                          match update with
                                          | U_MSTORE _ soffset svalue =>
                                              let ooffset := eval_sstack_val soffset st sb' ops in
                                              let ovalue := eval_sstack_val svalue st sb' ops in
                                              match ooffset, ovalue with
                                              | Some offset, Some value => Some (U_MSTORE EVMWord offset value)
                                              | _, _ => None
                                              end
                                          | U_MSTORE8 _ soffset svalue =>
                                              let ooffset := eval_sstack_val soffset st sb' ops in
                                              let ovalue := eval_sstack_val svalue st sb' ops in
                                              match ooffset, ovalue with
                                              | Some offset, Some value => Some (U_MSTORE8 EVMWord offset value)
                                              | _, _ => None
                                              end
                                          end
                in
                match apply_f_list_sstack_val f_eval_memupdate smem with
                | None => None
                | Some mem_updates =>
                    match eval_sstack_val soffset st sb' ops with
                    | None => None
                    | Some offset =>
                        match eval_sstack_val ssize st sb' ops with
                        | None => None
                        | Some size =>
                            let mem := update_memory (get_memory_st st) mem_updates in
                            let f_sha3 := (get_keccak256_ctx (get_context_st st)) in
                            Some (f_sha3 mem offset size)
                        end
                    end
                end

            end
          else eval_sstack_val sv st sb' ops
      end
  end.




Fixpoint eval_sstack' (sstk: sstack) (st: state) (sb: sbindings) (ops: stack_op_instr_map) : option stack :=
  match sstk with
  | [] => Some []
  | sv::sstk' =>
      match eval_sstack_val sv st sb ops with
      | None => None
      | Some v =>
          match  eval_sstack' sstk' st sb ops with
          | None => None
          | Some vs => Some (v::vs)
          end
      end
  end.


Definition eval_sstack (st: state) (sst: sstate) (ops: stack_op_instr_map) : option stack :=
  let stk := get_stack_st st in
  let instk_height := (get_instk_height_sst sst) in
  if (length stk) =? instk_height then
    let sstk := get_stack_sst sst in
    match (get_smap_sst sst) with
    | SymMap _ sb => eval_sstack' sstk st sb ops
    end
  else
    None.


Definition eval_memory_update (update: memory_update sstack_val) (st: state) (sb: sbindings) (ops: stack_op_instr_map) : option (memory_update EVMWord) :=
  match update with
  | U_MSTORE _ soffset svalue =>
      let ooffset := eval_sstack_val soffset st sb ops in
      let ovalue := eval_sstack_val svalue st sb ops in
      match ooffset, ovalue with
      | Some offset, Some value => Some (U_MSTORE EVMWord offset value)
      | _, _ => None
      end
  | U_MSTORE8 _ soffset svalue =>
      let ooffset := eval_sstack_val soffset st sb ops in
      let ovalue := eval_sstack_val svalue st sb ops in
      match ooffset, ovalue with
      | Some offset, Some value => Some (U_MSTORE8 EVMWord offset value)
      | _, _ => None
      end
  end.

Fixpoint eval_memory_updates (smem : smemory) (st: state) (sb: sbindings) (ops: stack_op_instr_map) :=
  match smem with
  | [] => Some []
  | supdate::smem' =>
      match eval_memory_update supdate st sb ops with
      | None => None
      | Some update =>
          match eval_memory_updates smem' st sb ops with
          | None => None
          | Some updates => Some (update::updates)
          end
      end
  end.

Definition eval_smemory (st: state) (sst: sstate) (ops: stack_op_instr_map) : option memory :=
  match get_smap_sst sst with
  | SymMap _ sb =>
      let smem := get_memory_sst sst in
      match eval_memory_updates smem st sb ops with
      | None => None
      | Some updates =>
          let mem := (get_memory_st st) in
          let mem' := update_memory mem updates in
          Some mem'
      end
  end.



Definition eval_storage_update (update: storage_update sstack_val) (st: state) (sb: sbindings) (ops: stack_op_instr_map) : option (storage_update EVMWord) :=
  match update with
  | U_SSTORE _ skey svalue =>
      let okey := eval_sstack_val skey st sb ops in
      let ovalue := eval_sstack_val svalue st sb ops in
      match okey, ovalue with
      | Some key, Some value => Some (U_SSTORE EVMWord key value)
      | _, _ => None
      end
  end.

Fixpoint eval_storage_updates (strg : sstorage) (st: state) (sb: sbindings) (ops: stack_op_instr_map) :=
  match strg with
  | [] => Some []
  | supdate::sstrg' =>
      match eval_storage_update supdate st sb ops with
      | None => None
      | Some update =>
          match eval_storage_updates sstrg' st sb ops with
          | None => None
          | Some updates => Some (update::updates)
          end
      end
  end.

Definition eval_sstorage (st: state) (sst: sstate) (ops: stack_op_instr_map) : option storage :=
  match get_smap_sst sst with
  | SymMap _ sb =>
      let strg := get_storage_sst sst in
      match eval_storage_updates strg st sb ops with
      | None => None
      | Some updates =>
          let strg := (get_storage_st st) in
          let strg' := update_storage strg updates in
          Some strg'
      end
  end.


Definition eval_sstate (st: state) (sst: sstate) (ops: stack_op_instr_map) : option state :=
  match eval_sstack st sst ops with
  | None => None
  | Some stk =>
      match eval_smemory st sst ops with
      | None => None
      | Some mem =>
          match eval_sstorage st sst ops with
          | None => None
          | Some strg =>
              let ctx := get_context_st st in
              let sst' := make_st stk mem strg ctx in
              Some sst'
          end
      end
  end.

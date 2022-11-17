Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import Coq.NArith.NArith.
Require Import List.
Import ListNotations.

Module EVM_Def.

Definition BLen: nat := 8. 
Definition EVMByte := word BLen. 

Definition BZero: EVMByte  := natToWord BLen 0.
Definition BOne : EVMByte  := natToWord BLen 1.

Definition WLen: nat := 32*BLen. 
Definition EVMWord:= word WLen.

Definition StackLen := 1024.

Definition WZero: EVMWord  := natToWord WLen 0.
Definition WOne : EVMWord  := natToWord WLen 1.

Definition AddrLen : nat := 20*BLen. (* 20 bytes *)
Definition AddrWord := word AddrLen.

End EVM_Def.
Import EVM_Def.


Module Concrete.


(*
 
  Operations are supposed to compute a value given the input, and they
  not modify the state directly.

*)
  
(* Instructions that require the context and stack as input *)
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


(*

Instructions are (1) the basic stack manipulation ones -- PUSH, POP,
DUP and SWAP; (2) the 3 types defined above; and (3) the store/memory
instructions. Those of (1) and (3) will be directly handled in the
interpreter, the rest will be provide via an operations map.

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


Definition block := list instr.  

(* stack is a list of EVMWord *)
Definition stack := list EVMWord.

(* memory is a mapping from EVMWord to EVMByte *)
Definition memory := EVMWord -> EVMByte.
Definition empty_m := (fun (a : EVMWord) => BZero).

(* store is a function from addresses to values *)
Definition store := EVMWord -> EVMWord.

(*

Context encapsulates all contract/blockchain information, it never
changes durin the execution of a block.

We can extend it use to model operations that are not implemented, as
far as these operations are not use in a rule optimization. This can
be done simply by specifying the function in the context, and the
implementation simply forwards to that function. For example, below we
do this for KECCAK256 whose implementation is not really needed.

*)

(* the use of _ctx_ is just to avoid conflicts with other data types *)

Inductive code_info :=
| CodeInfo (size : nat) (content : word size) (hash : EVMWord).

Inductive block_info :=
| BlockInfo (size : nat) (content : word size) (timestamp: EVMWord) (hash : EVMWord).

Inductive chunk :=
| Chunk (size : nat) (content : word size).
        
Inductive context :=
Ctx
  (address : AddrWord)
  (balance : AddrWord -> EVMWord)
  (origin : AddrWord)
  (caller : AddrWord)
  (callvalue : EVMWord)
  (data: chunk)
  (code : AddrWord -> code_info ) 
  (gasprice : EVMWord)
  (outdata: chunk)
  (blokcs : EVMWord -> block_info)
  (miner : AddrWord)
  (currblock : EVMWord)
  (gaslimit : EVMWord)
  (chainid : EVMWord)
  (basefee : EVMWord)
  (keccak256 : memory -> EVMWord -> EVMWord -> EVMWord)
  (_extra_1 : unit)
  (_extra_2 : unit)
  (_extra_3 : unit)
  (_extra_4 : unit)
  (_extra_5 : unit).

(* Ctx _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ *)

Definition get_address (c : context) :=
  match c with
  | Ctx x _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_balance (c : context) :=
  match c with
  | Ctx _ x _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_origin (c : context) :=
  match c with
  | Ctx _ _ x _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_caller (c : context) :=
  match c with
  | Ctx _ _ _ x _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_callvalue (c : context) :=
  match c with
  | Ctx _ _ _ _ x _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_data (c : context) :=
  match c with
  | Ctx _ _ _ _ _ x _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_code (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ x _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_gasprice (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_outdata (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_blokcs (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_miner (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_currblock (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_gaslimit (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _ => x
  end.

Definition get_chainid (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ => x
  end.

Definition get_basefee (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ _ _ _ _ _ _ _ _ x _ _ _ _ _ _ => x
  end.

Definition get_keccak256 (c : context) :=
  match c with
  | Ctx _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ x _ _ _ _ _ => x
  end.


Definition comm_op (f : context -> list EVMWord -> EVMWord)  : Prop :=
  forall (a b : EVMWord) (c : context), f c [a; b] = f c [b; a].

Inductive op_impl :=
| OpImp (n : nat) (f : context -> list EVMWord -> EVMWord) (H : option (comm_op f)).


Definition eq_stack_op_instr (a b: stack_op_instr) : bool :=
    match a, b with
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

Notation "m '=?i' n" := (eq_stack_op_instr m n) (at level 100).


Inductive state :=
 | ExState (stk: stack) (mem: memory) (stg: store) (ctx :context).


(****** Execution state manipulation ******)
Definition get_stack_st (st: state) : stack :=
match st with
| ExState stk _ _  => stk
end.

Definition set_stack_st (st: state) (stk: stack) 
  : state :=
match st with
| ExState _ mem strg ctx => ExState stk mem strg ctx
end.

Definition get_memory_st (st: state) : memory :=
match st with
| ExState _ mem _ _=> mem
end.

Definition set_memory_st (st: state) (mem: memory) 
  : state :=
match st with
| ExState stk _ strg ctx => ExState stk mem strg ctx
end.

Definition get_store_st (st: state) : store :=
match st with
| ExState _ _ strg _ => strg
end.

Definition set_store_st (st: state) (strg: store)
  : state :=
match st with
| ExState stk mem _ ctx => ExState stk mem strg ctx
end.

Definition get_context_st (st: state) : context :=
match st with
| ExState _ _ _ ctx => ctx
end.

Definition set_context_st (st: state) (ctx: context)
  : state :=
match st with
| ExState stk mem strg _ => ExState stk mem strg ctx
end.

(************)

(* ================================================================= *)
(** ** Definition of maps *)

(* The maps here link an opcode (oper_label) to an operator *)

 
Definition map (K V : Type) : Type := K -> option V.

Definition empty_imap {A : Type} : map stack_op_instr A := (fun _ => None).
Definition updatei {A : Type} (m : map stack_op_instr A) 
    (x : stack_op_instr) (v : A) :=
fun x' => if x =?i x' then Some v else m x'.

Notation "x '|->i' v ';' m" := (updatei m x v)
  (at level 100, v at next level, right associativity).
Notation "x '|->i' v" := (updatei empty_imap x v)
  (at level 100).
  
Definition empty_nmap {A : Type} : map nat A := (fun _ => None).
Definition updaten {A : Type} (m : map nat A) (x : nat) (v : A) :=
  fun x' => if x =? x' then Some v else m x'.
Notation "x '|->n' v ';' m" := (updaten m x v)
  (at level 100, v at next level, right associativity).
Notation "x '|->n' v" := (updaten empty_nmap x v)
  (at level 100).
    
Definition stack_op_map := map stack_op_instr op_impl.


(******* stack manipulation operators ********)

(* Polymorphic versions for manipulating the stack *)
Definition push {T : Type} (v : T) (sk : list T) : option (list T) :=
if List.length(sk) <? StackLen then Some (v :: sk) else None.

Definition pop {T : Type} (sk: list T): option (list T) :=
match sk with
 | x::sk' => Some sk'
 | _ => None
end.

Definition dup {T: Type} (k : nat) (sk: list T) : option (list T) :=
if ((k =? 0) || (16 <? k) || (StackLen <=? List.length(sk))) then None
else match nth_error sk (pred k) with
  | None => None
  | Some x => Some (x::sk)
  end.

Definition swap {T: Type} (k : nat) (sk: list T) : option (list T) :=
if ((k =? 0) || (16 <? k)) then None
else match (nth_error sk k, sk) with
     | (Some v, h::t) => Some ([v] ++ ((firstn (k-1) t)) 
                               ++ [h] ++ (skipn (k+1) sk))
     | _  => None
     end.

(* version operating on execution states *)
Definition push_c (v : EVMWord) (st : state)
  : option state :=
let sk := get_stack_st st in
match push v sk with
| None => None
| Some sk' => Some (set_stack_st st sk')
end.

Definition pop_c (st : state): option state :=
let sk := get_stack_st st in
match pop sk with
 | None => None
 | Some sk' => Some (set_stack_st st sk')
end.

Definition dup_c (k : nat) (st : state) : option state  :=
let sk := get_stack_st st in
match dup k sk with
 | None => None
 | Some sk' => Some (set_stack_st st sk')
end.

Definition swap_c (k : nat) (st : state) : option state :=
let sk := get_stack_st st in
match swap k sk with
 | None => None
 | Some sk' => Some (set_stack_st st sk')
end.


Definition mload_ (mem : memory) (offset : EVMWord) :=
  fix mload_fix (n : nat) : word (n * 8) :=
    match n with
    | O => WO
    | S n' => bbv.Word.combine (mem (wplus offset (natToWord WLen n))) (mload_fix n')
    end.

Definition mload (mem : memory) (offset : EVMWord) : EVMWord :=
  mload_ mem offset 32.
  
Definition mstore8 (mem : memory) (offset : EVMWord) (value : EVMByte) :=
  fun offset' => if (weqb offset' offset) then value else mem offset'.

Fixpoint mstore {sz : nat} (mem : memory) : (word sz) -> EVMWord -> (EVMWord -> EVMByte) :=
  match sz with
  | S (S (S (S (S (S (S (S sz1'))))))) =>
      fun value offset =>
         let byte := split1 8 sz1' value in
         let mem' := fun offset' => if (weqb offset' offset) then byte else mem offset' in
         mstore mem (bbv.Word.split2 8 sz1' value) (wplus offset WOne)
  | _ => fun _ _ => mem
  end.



Definition firstn_e {A: Type} (n: nat) (l: list A) : option (list A) :=
  if n <=? length l then Some (firstn n l) else None.

Definition skipn_e {A: Type} (n:nat) (l:list A) : option (list A) :=
  if n <=? length l then Some (skipn n l) else None.

Definition sload (strg : store) (key : EVMWord) :=
  strg key.

Definition sstore (strg : store) (key : EVMWord) (value : EVMWord) :=
  fun key' => if (weqb key' key) then value else strg key'.

Definition mload_c (st : state) : option state :=
  let stk := get_stack_st st in
  match firstn_e 1 stk with
  | Some [offset] =>
      let v := mload (get_memory_st st) offset in
      match skipn_e 1 stk with
      | None => None
      | Some stk' => Some (set_stack_st st (v::stk'))
      end
  | _ => None
  end.

Definition mstore8_c (st : state) : option state :=
  let stk := get_stack_st st in
  match firstn_e 2 stk with
  | Some [offset;value] =>
      let mem := mstore8 (get_memory_st st) offset (split1 8 (WLen-8) value) in
      let st' := set_memory_st st mem in
      match skipn_e 2 stk with
      | None => None
      | Some stk' => Some (set_stack_st st' stk')
      end
  | _ => None
  end.


Definition mstore_c (st : state) : option state :=
  let stk := get_stack_st st in
  match firstn_e 2 stk with
  | Some [offset;value] =>
      let mem := mstore (get_memory_st st) offset value in
      let st' := set_memory_st st mem in
      match skipn_e 2 stk with
      | None => None
      | Some stk' => Some (set_stack_st st' stk')
      end
  | _ => None
  end.

Definition sload_c (st : state) : option state :=
  let stk := get_stack_st st in
  match firstn_e 1 stk with
  | Some [key] =>
      let v := sload (get_store_st st) key in
      match skipn_e 1 stk with
      | None => None
      | Some stk' => Some (set_stack_st st (v::stk'))
      end
  | _ => None
  end.

Definition sstore_c (st : state) : option state :=
  let stk := get_stack_st st in
  match firstn_e 2 stk with
  | Some [key;value] =>
      let strg := sstore (get_store_st st) key value in
      let st' := set_store_st st strg in
      match skipn_e 2 stk with
      | None => None
      | Some stk' => Some (set_stack_st st' stk')
      end
  | _ => None
  end.

(* just return 0 for now *)
Definition sha3_c (st : state) : option state :=
  let stk := get_stack_st st in
  match firstn_e 2 stk with
  | Some [offset;size] =>
      match skipn_e 2 stk with
      | None => None
      | Some stk' =>
          let f := get_keccak256 (get_context_st st) in
          let v := f (get_memory_st st) offset size in
          Some (set_stack_st st (v::stk'))
      end
  | _ => None
  end.



(* Concrete interpreter *)
Definition concr_intpreter_instr (inst : instr) (st: state) (ops : stack_op_map) : option state :=
  match inst with
  | PUSH size v => push_c (NToWord WLen v) st
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
  | OpInstr label =>
      match (ops label) with
      | Some (OpImp nb_args func _) => 
          let stk := get_stack_st st in
          match firstn_e nb_args stk with
          | Some args => match skipn_e nb_args stk with 
                         | Some stk' =>
                             let v :=  func (get_context_st st) args in 
                             Some (set_stack_st st (v :: stk'))
                         | None => None
                         end
          | None => None
          end
      | None => None
      end
  end.


Fixpoint concr_interpreter (p : block) (st : state)
  (ops : stack_op_map) : option state :=
  match p with
  | [] => Some st
  | inst::insts' =>
    match (concr_intpreter_instr inst st ops) with
    | None => None
    | Some st' => concr_interpreter insts' st' ops
    end
  end.





(* ================================================================= *)
(** ** Implementation of current instructions *)

Definition evm_add (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a; b] => (wplus a b)
  | _ => WZero
  end.

Definition evm_mul (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a; b] => (wmult a b)
  | _ => WZero
  end.

Definition evm_sub (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a; b] => (wminus a b)
  | _ => WZero
  end.

Definition evm_div (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a; b] => (wdiv a b)
  | _ => WZero
  end.

Definition evm_sdiv (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_mod (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_smod (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_addmod (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_mulmod (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_exp (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a; b] => (NToWord WLen (N.pow (wordToN a) (wordToN b)))
  | _ => WZero
  end.

Definition evm_signextend (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_lt (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a; b] => (if (N.ltb (wordToN a) (wordToN b)) then WOne else WZero)
  | _ => WZero
  end.

Definition evm_gt (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a; b] => evm_lt ctx [b; a]
  | _ => WZero
  end.

Definition evm_slt (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_sgt (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_eq (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a; b] => (if weqb a b then WOne else WZero)
  | _ => WZero
  end.

Definition evm_iszero (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a] => evm_eq ctx [a; WZero]
  | _ => WZero
  end.

Definition evm_and (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a; b] => (wand a b)
  | _ => WZero
  end.

Definition evm_or (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a; b] => (wor a b)
  | _ => WZero
  end.

Definition evm_xor (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a; b] => (wxor a b)
  | _ => WZero
  end.

Definition evm_not (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a] => (wnot a)
  | _ => WZero
  end.

Definition evm_byte (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_shl (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a; b] => (wlshift' b (wordToNat a))
  | _ => WZero
  end.

Definition evm_shr (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a; b] => (wrshift' b (wordToNat a))
  | _ => WZero
  end.

Definition evm_sar (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_address (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_balance (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_origin (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_caller (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_callvalue (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_calldataload (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_calldatasize (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_codesize (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_gasprice (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_extcodesize (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_returndatasize (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_extcodehash (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_blockhash (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_coinbase (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_timestamp (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_number (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_difficulty (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_gaslimit (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_chainid (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_selfbalance (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.

Definition evm_basefee (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [] => WOne
  | _ => WZero
  end.


Definition evm_stack_opm : stack_op_map :=
  ADD |->i OpImp 2 evm_add None;
  MUL |->i OpImp 2 evm_mul None;
  SUB |->i OpImp 2 evm_sub None;
  DIV |->i OpImp 2 evm_div None;
  SDIV |->i OpImp 2 evm_sdiv None;
  MOD |->i OpImp 2 evm_mod None;
  SMOD |->i OpImp 2 evm_smod None;
  ADDMOD |->i OpImp 3 evm_addmod None;
  MULMOD |->i OpImp 3 evm_mulmod None;
  EXP |->i OpImp 2 evm_exp None;
  SIGNEXTEND |->i OpImp 2 evm_signextend None;
  LT |->i OpImp 2 evm_lt None;
  GT |->i OpImp 2 evm_gt None;
  SLT |->i OpImp 2 evm_slt None;
  SGT |->i OpImp 2 evm_sgt None;
  EQ |->i OpImp 2 evm_eq None;
  ISZERO |->i OpImp 1 evm_iszero None;
  AND |->i OpImp 2 evm_and None;
  OR |->i OpImp 2 evm_or None;
  XOR |->i OpImp 2 evm_xor None;
  NOT |->i OpImp 1 evm_not None;
  BYTE |->i OpImp 2 evm_byte None;
  SHL |->i OpImp 2 evm_shl None;
  SHR |->i OpImp 2 evm_shr None;
  SAR |->i OpImp 2 evm_sar None;
  ADDRESS |->i OpImp 0 evm_address None;
  BALANCE |->i OpImp 1 evm_balance None;
  ORIGIN |->i OpImp 0 evm_origin None;
  CALLER |->i OpImp 0 evm_caller None;
  CALLVALUE |->i OpImp 0 evm_callvalue None;
  CALLDATALOAD |->i OpImp 1 evm_calldataload None;
  CALLDATASIZE |->i OpImp 0 evm_calldatasize None;
  CODESIZE |->i OpImp 0 evm_codesize None;
  GASPRICE |->i OpImp 0 evm_gasprice None;
  EXTCODESIZE |->i OpImp 1 evm_extcodesize None;
  RETURNDATASIZE |->i OpImp 0 evm_returndatasize None;
  EXTCODEHASH |->i OpImp 1 evm_extcodehash None;
  BLOCKHASH |->i OpImp 1 evm_blockhash None;
  COINBASE |->i OpImp 0 evm_coinbase None;
  TIMESTAMP |->i OpImp 0 evm_timestamp None;
  NUMBER |->i OpImp 0 evm_number None;
  DIFFICULTY |->i OpImp 0 evm_difficulty None;
  GASLIMIT |->i OpImp 0 evm_gaslimit None;
  CHAINID |->i OpImp 0 evm_chainid None;
  SELFBALANCE |->i OpImp 0 evm_selfbalance None;
  BASEFEE |->i OpImp 0 evm_basefee None.
 

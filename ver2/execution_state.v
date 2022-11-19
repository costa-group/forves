Require Import bbv.Word.

Require Import FORVES.constants.
Import Constants.

Require Import List.
Import ListNotations.

Module ExecutionState.
       
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
End ExecutionState.


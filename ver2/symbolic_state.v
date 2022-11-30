Require Import bbv.Word.
Require Import Nat.

Require Import FORVES.constants.
Import Constants.

Require Import FORVES.program.
Import Program.

Require Import List.
Import ListNotations.

Module SymbolicState.


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

Check seq_length.

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

Definition get_bindings_smap(sm: smap) :=
  match sm with
  | SymMap maxid bindings => bindings
  end.

Definition get_maxid_smap(sm: smap) :=
  match sm with
  | SymMap maxid bindings => maxid
  end.

  
Definition add_to_smap (sm : smap) (value : smap_value) : prod nat smap :=
  match sm with
  | SymMap maxid bindings =>
      let sm' := SymMap (S maxid) ((pair maxid value)::bindings) in
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

       
End SymbolicState.

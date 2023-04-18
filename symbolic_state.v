Require Import bbv.Word.
Require Import Nat. 
Require Import Coq.NArith.NArith.

Require Import FORVES.constants.
Import Constants.

Require Import FORVES.program.
Import Program.

Require Import FORVES.stack_operation_instructions.
Import StackOpInstrs.

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



(* Symbolic map: type, constructor, getters and setters *)

Inductive smap_value : Type :=
| SymBasicVal (val: sstack_val)
| SymMETAPUSH (cat val: N)
| SymOp (label : stack_op_instr) (args : list sstack_val)
| SymMLOAD (offset: sstack_val) (smem : smemory)
| SymSLOAD (key: sstack_val) (sstrg : sstorage)
| SymSHA3 (offset: sstack_val) (size: sstack_val) (smem : smemory).

Definition sbinding : Type := nat*smap_value.
Definition sbindings : Type := list sbinding.
Inductive smap := SymMap (maxid : nat) (bindings: sbindings).

Definition get_maxidx_smap (m: smap) :=
  match m with
  | SymMap maxidx _ => maxidx
  end.

Definition get_bindings_smap (m: smap) :=
  match m with
  | SymMap _ sb => sb
  end.

Definition empty_smap : smap := SymMap 0 [].


Definition add_to_smap (sm : smap) (value : smap_value) : prod nat smap :=
  match sm with
  | SymMap maxidx bindings =>
      let sm' := SymMap (S maxidx) ((pair maxidx value)::bindings) in
      pair maxidx sm'
  end.

Inductive follow_in_smap_ret_t :=
| FollowSmapVal (smv : smap_value) (key: nat) (sb: sbindings).


Definition is_fresh_var_smv (smv: smap_value) :=
  match smv with
  | SymBasicVal (FreshVar idx) => Some idx
  | _ => None
  end.

Definition not_basic_value_smv (smv: smap_value) :=
  match smv with
  | SymBasicVal _ => false
  | _ => true
  end.

Fixpoint follow_in_smap (sv: sstack_val) (maxidx: nat) (sb: sbindings) : option follow_in_smap_ret_t :=
  match sv with
  | Val v => Some (FollowSmapVal (SymBasicVal (Val v)) maxidx sb)
  | InStackVar n => Some (FollowSmapVal (SymBasicVal (InStackVar n)) maxidx sb)
  | FreshVar idx =>
      match sb with
      | [] => None
      | (key,smv)::sb' =>
          if key =? idx then
            match is_fresh_var_smv smv with
            | Some idx' => follow_in_smap (FreshVar idx') key sb'
            | None => Some (FollowSmapVal smv key sb')
            end
          else follow_in_smap sv key sb'
      end
  end.



(* Symbolic state: type, constructor, getters and setters *)

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

 


(* Abstraction over memory/storage comparators *) 

Definition sstack_val_cmp_type := sstack_val -> sstack_val -> bool.

(* eval offset1 size1 smem1 offset2 size2 smem2 -> bool *)
Definition sha3_cmp_type  := sstack_val_cmp_type -> sstack_val -> sstack_val -> smemory -> sstack_val -> sstack_val -> smemory -> bool.

(* eval smem1 smem2 -> bool *)  
Definition smemory_cmp_type := sstack_val_cmp_type -> smemory -> smemory -> bool.

(* sstrg1 sstrg2 -> bool *)
Definition sstorage_cmp_type := sstack_val_cmp_type -> sstorage -> sstorage -> bool.



(* Facts *)



Lemma instk_height_preserved_when_updating_stack_sst:
  forall sst sstk,
    get_instk_height_sst (set_stack_sst sst sstk) = get_instk_height_sst sst.
Proof.
  destruct sst.
  reflexivity.
Qed.

Lemma instk_height_preserved_when_updating_smap_sst:
  forall sst m,
    get_instk_height_sst (set_smap_sst sst m) = get_instk_height_sst sst.
Proof.
  destruct sst.
  reflexivity.
Qed.

Lemma instk_height_preserved_when_updating_storage_sst:
  forall sst sstrg,
    get_instk_height_sst (set_storage_sst sst sstrg) = get_instk_height_sst sst.
Proof.
  destruct sst.
  reflexivity.
Qed.

Lemma instk_height_preserved_when_updating_memory_sst:
  forall sst smem,
    get_instk_height_sst (set_memory_sst sst smem) = get_instk_height_sst sst.
Proof.
  destruct sst.
  reflexivity.
Qed.

Lemma smap_preserved_when_updating_stack_sst:
  forall sst sstk,
    get_smap_sst (set_stack_sst sst sstk) = get_smap_sst sst.
Proof.
  destruct sst.
  reflexivity.
Qed.

Lemma smap_preserved_when_updating_storage_sst:
  forall sst sstrg,
    get_smap_sst (set_storage_sst sst sstrg) = get_smap_sst sst.
Proof.
  destruct sst.
  reflexivity.
Qed.

Lemma smap_preserved_when_updating_memory_sst:
  forall sst smem,
    get_smap_sst (set_memory_sst sst smem) = get_smap_sst sst.
Proof.
  destruct sst.
  reflexivity.
Qed.

Lemma smemory_preserved_when_updating_storage_sst:
  forall sst sstrg,
    get_memory_sst (set_storage_sst sst sstrg) = get_memory_sst sst.
Proof.
  destruct sst.
  reflexivity.
Qed.

Lemma smemory_preserved_when_updating_stack_sst:
  forall sst sstk,
    get_memory_sst (set_stack_sst sst sstk) = get_memory_sst sst.
Proof.
  destruct sst.
  reflexivity.
Qed.

Lemma sstorage_preserved_when_updating_stack_sst:
  forall sst sstk,
    get_storage_sst (set_stack_sst sst sstk) = get_storage_sst sst.
Proof.
  destruct sst.
  reflexivity.
Qed.

Lemma sstorage_preserved_when_updating_memory_sst:
  forall sst smem,
    get_storage_sst (set_memory_sst sst smem) = get_storage_sst sst.
Proof.
  destruct sst.
  reflexivity.
Qed.


Lemma sstack_preserved_when_updating_smap_sst:
  forall sst m,
    get_stack_sst (set_smap_sst sst m) = get_stack_sst sst.
Proof.
  destruct sst.
  reflexivity.
Qed.


Lemma smemory_preserved_when_updating_smap_sst:
  forall sst m,
    get_memory_sst (set_smap_sst sst m) = get_memory_sst sst.
Proof.
  destruct sst.
  reflexivity.
Qed.

Lemma sstorage_preserved_when_updating_smap_sst:
  forall sst m,
    get_storage_sst (set_smap_sst sst m) = get_storage_sst sst.
Proof.
  destruct sst.
  reflexivity.
Qed.


Lemma set_and_then_get_smap_sst:
  forall sst m,
    get_smap_sst (set_smap_sst sst m) = m.
Proof.
  destruct sst.
  reflexivity.
Qed.

Lemma set_and_then_get_stack_sst:
  forall sst sstk,
    get_stack_sst (set_stack_sst sst sstk) = sstk.
Proof.
  destruct sst.
  reflexivity.
Qed.

Lemma set_and_then_get_storage_sst:
  forall sst sstrg,
    get_storage_sst (set_storage_sst sst sstrg) = sstrg.
Proof.
  destruct sst.
  reflexivity.
Qed.

Lemma set_and_then_get_memory_sst:
  forall sst smem,
    get_memory_sst (set_memory_sst sst smem) = smem.
Proof.
  destruct sst.
  reflexivity.
Qed.




End SymbolicState.

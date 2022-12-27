Require Import bbv.Word.
Require Import Nat.
Require Import Coq.NArith.NArith.

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
| SymPUSHTAG (val: N)
| SymOp (label : stack_op_instr) (args : list sstack_val)
| SymMLOAD (offset: sstack_val) (smem : smemory)
| SymSLOAD (key: sstack_val) (sstrg : sstorage)
| SymSHA3 (offset: sstack_val) (size: sstack_val) (smem : smemory).

Definition sbindings : Type := list (nat*smap_value).
Inductive smap := SymMap (maxid : nat) (bindings: sbindings).
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


(* MaxID is > any fresh variable in the map *)
Fixpoint fresh_var_gt_map (idx: nat) (map: sbindings) : Prop :=
match map with 
| nil => True
| (k,v)::t => idx > k /\ fresh_var_gt_map idx t
end.

(* Fresh variables in a map are strictly decreasing *)
Fixpoint strictly_decreasing_map (a: sbindings) : Prop :=
match a with
| [] => True
| (var1, e1)::t1 => match t1 with 
                    | [] => True
                    | (var2, e2)::t2 => var1 > var2 /\ 
                                        strictly_decreasing_map t1
                    end
end.

Definition valid_sstate (sst: sstate) : Prop :=
match sst with 
| SymExState _ _ _ _ _ (SymMap maxid m) =>
    (fresh_var_gt_map maxid m) /\
      (strictly_decreasing_map m)
end.

(* Facts *)


Lemma fresh_var_gt_map_maxid_S:
  forall  sm maxid,
    fresh_var_gt_map maxid sm ->
    fresh_var_gt_map (S maxid) sm.
Proof.
  induction sm as [|v sm' IHsm'].
  - auto.
  - intros.
    unfold fresh_var_gt_map in H.
    fold fresh_var_gt_map in H.
    destruct v as [k kvalue].
    destruct H.
    unfold fresh_var_gt_map.
    fold fresh_var_gt_map.
    split.
    + auto.
    + apply IHsm'.
      apply H0.
Qed.

Lemma valid_empty_sstate:
  forall k, valid_sstate (gen_empty_sstate k).
Proof.
  intro.
  simpl valid_sstate.  
  auto.
Qed.

Lemma add_to_map_valid_sstate:
  forall sst key sm value,
    valid_sstate sst ->
    (key,sm) = add_to_smap (get_smap_sst sst) value ->
    valid_sstate (set_smap_sst sst sm).
Proof.
  intros sst key sm value H_valid_sst H_add_to_smap.
  unfold valid_sstate.
  unfold valid_sstate in H_valid_sst.
  destruct sst as [instk_height sstk smem sstrg ctx sm'].
  destruct sm' as [maxid' m'].
  destruct H_valid_sst as [H_valid_sst_l H_valid_sst_r].
  simpl in  H_add_to_smap.
  injection H_add_to_smap as _ H_add_to_smap.
  simpl.
  destruct sm as [maxid m].
  injection H_add_to_smap as H_add_to_smap_maxid H_add_to_smap_maxid_map.
  rewrite H_add_to_smap_maxid_map.
  split.
  - simpl.
    split.
    + rewrite H_add_to_smap_maxid.
      apply Gt.gt_Sn_n.
    + rewrite H_add_to_smap_maxid.
      apply fresh_var_gt_map_maxid_S.
      apply H_valid_sst_l.
  - unfold strictly_decreasing_map.
    fold strictly_decreasing_map.
    destruct m'.
    + auto.
    + destruct p.
      unfold fresh_var_gt_map in H_valid_sst_l.
      intuition.
Qed.

Lemma valid_sstate_sstack_change:
  forall sst sstk,
    valid_sstate sst ->
    valid_sstate (set_stack_sst sst sstk).
Proof.
  intros.
  unfold valid_sstate in H.
  destruct sst.
  destruct sm.
  simpl.
  apply H.
Qed.

Lemma valid_sstate_smemory_change:
  forall sst smem,
    valid_sstate sst ->
    valid_sstate (set_memory_sst sst smem).
Proof.
  intros.
  unfold valid_sstate in H.
  destruct sst.
  destruct sm.
  simpl.
  apply H.
Qed.

Lemma valid_sstate_sstorage_change:
  forall sst sstrg,
    valid_sstate sst ->
    valid_sstate (set_memory_sst sst sstrg).
Proof.
  intros.
  unfold valid_sstate in H.
  destruct sst.
  destruct sm.
  simpl.
  apply H.
Qed.

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

Lemma smap_preserved_when_updating_stack_sst:
  forall sst sstk,
    get_smap_sst (set_stack_sst sst sstk) = get_smap_sst sst.
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

End SymbolicState.

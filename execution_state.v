 Require Import bbv.Word.

Require Import FORVES.constants.
Import Constants.

Require Import List.
Import ListNotations.

Require Import Coq.Logic.FunctionalExtensionality.
Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import Coq.NArith.NArith.
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
Definition memory : Type := N -> EVMByte.
Definition empty_memory : memory := fun _ => BZero.

(* Storage is a function from EVMWord (key) to values EVMWord
(value). We don't model the warm/cold properies since we don't track
gas consumption *)
Definition storage : Type := N -> EVMWord.
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

Inductive externals :=
| Exts
  (address : EVMAddr)
  (balance : EVMAddr -> EVMWord)
  (origin : EVMAddr)
  (caller : EVMAddr)
  (callvalue : EVMWord)
  (data: chunk)
  (code : EVMAddr -> code_info ) 
  (gasprice : EVMWord)
  (outdata: chunk)
  (blocks : EVMWord -> block_info)
  (miner : EVMAddr)
  (currblock : EVMWord)
  (gaslimit : EVMWord)
  (chainid : EVMWord)
  (basefee : EVMWord)
  (keccak256 : forall (n : nat), word (n*8) -> EVMWord)
  (tags : N -> N -> EVMWord)
  (prevrando : EVMWord)
  (_extra_3 : nat)
  (_extra_4 : nat)
  (_extra_5 : nat).



Definition empty_externals : externals :=
 Exts
  AZero (* (address : EVMAddr) *)
  (fun _ => WZero) (* (balance : EVMAddr -> EVMWord) *)
  AZero (* (origin : EVMAddr) *)
  AZero (* (caller : EVMAddr) *)
  WZero (* (callvalue : EVMWord) *)
  (Chunk 0 WO) (* (data: chunk) *)
  (fun _ => CodeInfo 0 WO WZero) (* (code : EVMAddr -> code_info )  *)
  WZero (* (gasprice : EVMWord) *)
  (Chunk 0 WO) (* (outdata: chunk) *)
  (fun _ => BlockInfo 0 WO WZero WZero) (* (blocks : EVMWord -> block_info) *)
  AZero (* (miner : EVMAddr) *)
  WZero (* (currblock : EVMWord) *)
  WZero (* (gaslimit : EVMWord) *)
  WZero (* (chainid : EVMWord) *)
  WZero (* (basefee : EVMWord) *)
  (fun _ _ => WZero) (* (keccak256 : memory -> EVMWord -> EVMWord -> EVMWord) *)
  (fun cat v => (NToWord EVMWordSize (cat + v))) (* tags: N -> EVMWord *)
  WZero (* PREVRANDAO : EVMWord*)
  0 (* (_extra_3 : nat) *)
  0 (* (_extra_4 : nat) *)
  0. (* (_extra_5 : nat) *)

(* Exts _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ *)

Definition get_address_exts (c : externals) :=
  match c with
  | Exts x _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_balance_exts (c : externals) :=
  match c with
  | Exts _ x _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_origin_exts (c : externals) :=
  match c with
  | Exts _ _ x _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_caller_exts (c : externals) :=
  match c with
  | Exts _ _ _ x _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_callvalue_exts (c : externals) :=
  match c with
  | Exts _ _ _ _ x _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_data_exts (c : externals) :=
  match c with
  | Exts _ _ _ _ _ x _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_code_exts (c : externals) :=
  match c with
  | Exts _ _ _ _ _ _ x _ _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_gasprice_exts (c : externals) :=
  match c with
  | Exts _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_outdata_exts (c : externals) :=
  match c with
  | Exts _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_blocks_exts (c : externals) :=
  match c with
  | Exts _ _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_miner_exts (c : externals) :=
  match c with
  | Exts _ _ _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_currblock_exts (c : externals) :=
  match c with
  | Exts _ _ _ _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _ _ => x
  end.

Definition get_gaslimit_exts (c : externals) :=
  match c with
  | Exts _ _ _ _ _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _ => x
  end.

Definition get_chainid_exts (c : externals) :=
  match c with
  | Exts _ _ _ _ _ _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ => x
  end.

Definition get_basefee_exts (c : externals) :=
  match c with
  | Exts _ _ _ _ _ _ _ _ _ _ _ _ _ _ x _ _ _ _ _ _ => x
  end.

Definition get_keccak256_exts (c : externals) :=
  match c with
  | Exts _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ x _ _ _ _ _ => x
  end.

Definition get_tags_exts (c : externals) :=
  match c with
  | Exts _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ x _ _ _ _ => x
  end.

Definition get_prevrandao_exts (c : externals) :=
  match c with
  | Exts _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ x _ _ _ => x
  end.

Inductive state :=
| ExState (stk: stack) (mem: memory) (strg: storage) (exts :externals).

Definition make_st (stk: stack) (mem: memory) (strg: storage) (exts : externals) : state :=
  ExState stk mem strg exts.

Definition empty_state := make_st empty_stack empty_memory empty_storage empty_externals.

Definition get_stack_st (st: state) : stack :=
  match st with
  | ExState stk _ _ _ => stk
  end.

Definition set_stack_st (st: state) (stk: stack) : state :=
  match st with
  | ExState _ mem strg exts => ExState stk mem strg exts
  end.

Definition get_memory_st (st: state) : memory :=
  match st with
  | ExState _ mem _ _=> mem
  end.

Definition set_memory_st (st: state) (mem: memory) : state :=
  match st with
  | ExState stk _ strg exts => ExState stk mem strg exts
  end.

Definition get_storage_st (st: state) : storage :=
  match st with
  | ExState _ _ strg _ => strg
  end.

Definition set_store_st (st: state) (strg: storage) : state :=
  match st with
  | ExState stk mem _ exts => ExState stk mem strg exts
  end.

Definition get_externals_st (st: state) : externals :=
  match st with
  | ExState _ _ _ exts => exts
  end.

Definition set_externals_st (st: state) (exts: externals) : state :=
  match st with
  | ExState stk mem strg _ => ExState stk mem strg exts
  end.
  



(* When two state are equivalent. It is not simply equivalent of terms
because memory and storage are functions, so we need functional
equivalence as well *)

Definition eq_stack (stk1 stk2: stack) : Prop := stk1 = stk2.

Definition eq_memory (mem1 mem2: memory) : Prop := forall w, mem1 w =
  mem2 w.

Definition eq_storage (strg1 strg2: storage) : Prop := forall w, strg1
  w = strg2 w.

Definition eq_externals (exts1 exts2: externals) : Prop := exts1 = exts2.

(*
Definition eq_execution_states (st1 st2: state) : Prop :=

  forall stk1 stk2 mem1 mem2 strg1 strg2 exts1 exts2,
    (stk1 = get_stack_st st1) ->
    (stk2 = get_stack_st st2) -> (mem1 = get_memory_st st1) ->
    (mem2 = get_memory_st st2) -> (strg1 = get_storage_st st1) ->
    (strg2 = get_storage_st st2) -> (exts1 = get_externals_st st1) ->
    (exts2 = get_externals_st st2) ->
    
    eq_stack stk1 stk2 /\ eq_memory mem1 mem2 /\ eq_storage strg1 strg2 /\ eq_externals exts1 exts2.
*)


Definition eq_execution_states (st1 st2: state) : Prop :=
    
    eq_stack (get_stack_st st1) (get_stack_st st2) /\
      eq_memory (get_memory_st st1) (get_memory_st st2) /\
      eq_storage (get_storage_st st1) (get_storage_st st2) /\
      eq_externals (get_externals_st st1) (get_externals_st st2).


(* Facts *)

(* A state is equal to itself *)
Lemma eq_execution_states_refl:
  forall (st: state), eq_execution_states st st.
Proof.
  intros.
  unfold eq_execution_states.
  intuition. (* this proves the stack and externals equivalence *)
  + unfold eq_memory. intro. reflexivity.
  + unfold eq_storage. intro. reflexivity.
Qed.


(* States equivalence -> states equality. This requires the functional extension, whcih is consistent. *)
Lemma eq_execution_states_ext:
  forall (st st': state),
    eq_execution_states st st' -> st = st'.
Proof.
  intros st st' H_eq.
  destruct st eqn:E_st.
  destruct st' eqn:E_st'.
  unfold eq_execution_states in H_eq.
  simpl in H_eq.
  destruct H_eq as [H_eq_stack [H_eq_mem [H_eq_strg H_eq_exts]]].

  unfold eq_stack in H_eq_stack.
  rewrite H_eq_stack.
  unfold eq_memory in H_eq_mem.
  apply functional_extensionality in H_eq_mem.
  rewrite H_eq_mem.
  unfold eq_storage in H_eq_strg.
  apply functional_extensionality in H_eq_strg. (* functional extension *)
  rewrite H_eq_strg.
  unfold eq_externals in H_eq_exts.
  rewrite H_eq_exts.
  reflexivity.
Qed.

(* Equal states have stack of the same length *)
Lemma eq_execution_states_stack_len:
  forall st st',
    eq_execution_states st st' ->
    length (get_stack_st st) = length (get_stack_st st').
Proof.
  intros st st' H_eq_states.
  apply eq_execution_states_ext in H_eq_states.
  rewrite H_eq_states.
  reflexivity.
Qed.

Lemma memory_preserved_when_updating_stack_st:
  forall st stk,
    get_memory_st (set_stack_st st stk) = get_memory_st st.
Proof.
  destruct st.
  reflexivity.
Qed.

Lemma storage_preserved_when_updating_stack_st:
  forall st stk,
    get_storage_st (set_stack_st st stk) = get_storage_st st.
Proof.
  destruct st.
  reflexivity.
Qed.

Lemma externals_preserved_when_updating_stack_st:
  forall st stk,
    get_externals_st (set_stack_st st stk) = get_externals_st st.
Proof.
  destruct st.
  reflexivity.
Qed.

Lemma set_and_then_get_stack_st:
  forall st stk,
    get_stack_st (set_stack_st st stk) = stk.
Proof.
  destruct st.
  reflexivity.
Qed.

End ExecutionState.


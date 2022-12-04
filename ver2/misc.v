Require Import List.
Import ListNotations.

Require Import Arith.
Require Import Nat.
Require Import Bool.

Require Import FORVES.execution_state.
Import ExecutionState.

Require Import FORVES.constants.
Import Constants.



Module Misc.


(* The maps here link an opcode (oper_label) to an operator *)
Definition omap (K V : Type) : Type := K -> option V.

Definition map (K V : Type) : Type := K -> V.


(**

It is like fold_right, but stops once f returns None (and returns None
in this case).

**)

Definition fold_right_option {A B : Type} (f: A -> option B)  :=

  fix fold_right_option_fix (l: list A) : option (list B) :=
    match l with 
    | nil => Some []
    | elem::rs => let elem_oval := f elem in
                  let rs_oval := fold_right_option_fix rs in
                  match (elem_oval, rs_oval) with 
                  | (Some elem_val, Some rs_val) => Some (elem_val::rs_val)
                  | _ => None
                  end
    end.


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


(** Facts about functions defined in this module **)


(* Just a relation between fold_right_option and its inner function
fold_right_option_fix. Trivial, but useful for induction and for
readability *)
Lemma fold_right_option_ho:
  forall A B f l,
  fold_right_option f l =
    (fix fold_right_option_fix (l: list A) : option (list B) :=
    match l with 
    | nil => Some []
    | elem::rs => let elem_oval := f elem in
                  let rs_oval := fold_right_option_fix rs in
                  match (elem_oval, rs_oval) with 
                  | (Some elem_val, Some rs_val) => Some (elem_val::rs_val)
                  | _ => None
                  end
    end) l.
Proof.
  reflexivity.
Qed.

  
(* When fold_right_option succeeds, the length of the result list is
  as the length of the input list *)
Lemma fold_right_option_len:
  forall (A B: Type) (f: A->option B) (l1: list A) (l2: list B),
    fold_right_option f l1 = Some l2 ->
    length l1 = length l2.
Proof.
  intros A B f.
  induction l1 as [|a l1' IHl1'].
  - intros l2 H_fold_r_nil.
    simpl in  H_fold_r_nil.
    injection  H_fold_r_nil as H_l2.
    rewrite <- H_l2.
    reflexivity.
  - intros l2 H_fold_r_cons.
    unfold fold_right_option in H_fold_r_cons.
    destruct (f a) eqn:E_fa.
    + rewrite <- fold_right_option_ho in H_fold_r_cons.
      destruct (fold_right_option f l1') eqn:E_fold_r_l1' in H_fold_r_cons.
      ++ apply IHl1' in E_fold_r_l1'.
         injection H_fold_r_cons as H_fold_r_cons. 
         rewrite <- H_fold_r_cons.
         simpl.
         rewrite E_fold_r_l1'.
         reflexivity.
      ++ discriminate H_fold_r_cons.
    + discriminate H_fold_r_cons.
Qed.

(* when fold_right_option succeeds on v::l1 and results in v::l2, and
l2 is the result of applying fold_right_option on l1.
*)

Lemma fold_right_option_hd:
  forall (A B: Type) (f: A->option B) (l1: list A) (l2: list B) (v : A) (e: B),
    fold_right_option f (v::l1) = Some (e::l2) ->
    f v = Some e /\ fold_right_option f l1 = Some l2.
Proof.
  intros A B f l1 l2 v e H_fold_r.
  unfold fold_right_option in H_fold_r.
  rewrite <- fold_right_option_ho in H_fold_r.
  destruct (f v) eqn:E_fv.
  + destruct (fold_right_option f l1) eqn:E_fold_r.
    ++ injection H_fold_r as H_b H_l2.
       rewrite H_b. rewrite H_l2.
       split; reflexivity.
    ++ discriminate.
  + discriminate.
Qed.

  
(* When fold_right_option succeeds, the i-th element of the output is
the result of applying f to the i-th element in the input.  *)
Lemma fold_right_option_nth:
  forall (A B: Type) (f: A->option B) (l1: list A) (l2: list B),
    fold_right_option f l1 = Some l2 ->
    forall k,
      k < length l1 ->
      exists v,
        nth_error l1 k = Some v /\
          nth_error l2 k = f v.
Proof.
  intros A B f.
  induction l1 as [|e l1' IHl1'].
  - intros l2 H_fold_r_nil k H_k_lt_len.
    rewrite <- Nat.ltb_lt in H_k_lt_len.
    simpl in H_k_lt_len.
    destruct k; discriminate.
  - intros l2 H_fold_r_cons k H_k_lt_len.
    destruct l2 eqn:E_l2.
    + unfold fold_right_option in H_fold_r_cons.
      rewrite <- fold_right_option_ho in H_fold_r_cons.
      destruct (f e) eqn:E_fa.
      ++ destruct (fold_right_option f l1') eqn:E_fold_r_l1' in H_fold_r_cons; discriminate.
      ++ discriminate.
    + apply fold_right_option_hd in H_fold_r_cons.
      destruct H_fold_r_cons as [H_hd H_tl].
      destruct k eqn:E_k.
      ++ simpl.
         rewrite <- H_hd.
         exists e.
         split; reflexivity.
      ++ simpl.
         simpl in H_k_lt_len. apply lt_S_n in H_k_lt_len.
         pose proof (IHl1' l H_tl n   H_k_lt_len) as IH.
         apply IH.
Qed.


End Misc.

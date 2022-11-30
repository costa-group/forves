Require Import List.
Import ListNotations.

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

  
Fixpoint app_f_succ_all {A B: Type} (f: A -> option B) (l: list A) : bool :=
  match l with
  | [] => true
  | x::l' =>
      match (f x) with
      | None => false
      | Some _ => app_f_succ_all f l'
      end
  end.
 
Lemma app_f_succ_all_tl:
  forall (A B: Type) (f: A->option B) (l: list A) (a: A),
    app_f_succ_all f (a::l) = true ->  app_f_succ_all f l = true.
Proof.
  intros.
  unfold app_f_succ_all in H.
  destruct (f a) in H.
  + apply H.
  + discriminate H.
Qed.

Lemma fold_right_option_succ:
  forall (A B: Type) (f: A->option B) (l: list A),
    app_f_succ_all f l = true ->  exists lr, fold_right_option f l = Some lr.

Proof.
  intros A B f l.
  induction l as [|a l' IHl'].
  - intros. exists []. reflexivity.
  - simpl. destruct (f a) eqn:fa.
    + intro. apply IHl' in H. destruct H. exists (b::x). rewrite H. reflexivity.
    + intro. discriminate.
Qed.      


Lemma fold_right_option_len:
  forall (A B: Type) (f: A->option B) (l1: list A) (l2: list B),
    fold_right_option f l1 = Some l2 ->
    length l1 = length l2.
Proof.
  induction l1 as [|a l1' IHl1'].
  - intros. simpl in H. injection H. intros. rewrite <- H0. reflexivity.
  - intros.
    unfold fold_right_option in H.
    destruct (f a).
    + destruct ((fix fold_right_option_fix (l : list A) : option (list B) :=
           match l with
           | [] => Some []
           | elem :: rs =>
               match f elem with
               | Some elem_val =>
                   match fold_right_option_fix rs with
                   | Some rs_val => Some (elem_val :: rs_val)
                   | None => None
                   end
               | None => None
               end
           end) l1') eqn:E0.
      ++ apply IHl1' in E0.
         injection H. intros.
         rewrite <- H0.
         simpl. rewrite E0. reflexivity.
      ++ discriminate.
    + discriminate.
Qed.


(*
Alternative implementation of fold_right_option, using List.fold_right
*)
Definition fold_right_option_2 {A B : Type} (f: A -> option B) (l: list A) : option (list B) :=
  let ff := fun b a =>
             match a with
             | None => None
             | Some xs =>
                 match (f b) with
                 | None => None
                 | Some v => Some (v::xs)
                 end
             end
  in
  fold_right ff (Some []) l.



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


End Misc.

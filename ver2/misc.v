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
Definition map (K V : Type) : Type := K -> option V.


(**

It is like fold_right, but stops once f returns None (and returns None
in this case).

**)

Fixpoint fold_right_option {A B : Type} (f: A -> option B) (l: list A) : option (list B) :=
match l with 
| nil => Some []
| elem::rs => let elem_oval := f elem in
              let rs_oval := fold_right_option f rs in
              match (elem_oval, rs_oval) with 
              | (Some elem_val, Some rs_val) => Some (elem_val::rs_val)
              | _ => None
              end
end.

Check fold_right.

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

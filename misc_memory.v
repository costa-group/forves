Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import List.
Import ListNotations.


Fixpoint word_to_bytes (size : nat) : word size -> option (list (word 8)) :=
  match size with
  | O => fun w => Some []
  | S (S (S (S (S (S (S (S size'))))))) =>
      fun w => match (word_to_bytes size' (split2 8 size' w)) with
               | Some l => Some ((split1 8 size' w)::l)
               | None => None
               end
  | _ => fun w => None
  end.

Fixpoint bytes_to_word (size : nat) : list (word 8) -> option (word size) :=
  match size with
  | O => fun l => match l with
                  | [] => Some (natToWord 0 0)
                  | _ => None
                  end
  | S (S (S (S (S (S (S (S size'))))))) =>
      fun l => match l with
               | [] => None
               | x::xs => match (bytes_to_word size' xs) with
                          | None => None
                          | Some w => Some (bbv.Word.combine x w)
                          end
               end
  | _ => fun l => None
  end.


Definition x := natToWord 16 1.
Definition y := natToWord 15 1.


Check word 0.

Theorem word_to_bytes_bytes_to_word:
  forall (size : nat) (w : word size) (l : list (word 8)), 
    word_to_bytes size w = Some l -> bytes_to_word size l = Some w.
Admitted.                    
    


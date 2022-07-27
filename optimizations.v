Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import List.
Require Import Coq_EVM.lib.evmModel.
Require Import Coq_EVM.datatypes.
Import EVM_Def Concrete Abstract.
Require Import Coq_EVM.interpreter.
Import Interpreter SFS.
Import ListNotations.



(* Enrique *)

(* ADD(0,X) --> X *)
Fixpoint optimize_map_add_zero1 (fresh_var: nat) (map: asfs_map): 
  option asfs_map :=
match map with
| [] => None
| (n, val)::t => if n =? fresh_var then
                 match val with
                 | ASFSOp ADD [Val WZero; arg2] =>
                     Some ((n, ASFSBasicVal arg2)::t)
                 | _ => None
                 end
                 else match optimize_map_add_zero1 fresh_var t with 
                      | None => None
                      | Some map' => Some ((n, val)::map')
                      end
end.

Definition optimize_func_map (f: nat -> asfs_map -> option asfs_map) 
  (fresh_var: nat) (s: asfs) : option asfs :=
match s with
| ASFSc height maxid stack map => 
    match f fresh_var map with
    | None => None
    | Some map' => Some (ASFSc height maxid stack map')
    end
end.

Definition optimize_add_zero1 (fresh_var: nat) (s: asfs) : option asfs :=
optimize_func_map optimize_map_add_zero1 fresh_var s.

Definition coherent_opm (ops: opm) : Prop :=
True.


Theorem optimize_add_zero1_safe: forall (a1 a2: asfs) (fresh_var: nat)
  (s: concrete_stack) (ops: opm),
optimize_add_zero1 fresh_var a1 = Some a2 ->
eval_asfs s a1 ops = eval_asfs s a2 ops.
Proof. 
Admitted.




(* Joseba *)
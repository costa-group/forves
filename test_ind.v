Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import List.
Require Import Program.Wf.
Require Import Coq_EVM.definitions.
Import EVM_Def Concrete Abstract.
Import ListNotations.

Inductive nat_tree : Set :=
| Const (n: nat)
| NNode' (n: nat) (ls: list nat_tree).

Check nat_tree_ind.


Section All.
  Variable T : Set.
  Variable P : T -> Prop.
  Fixpoint All (ls : list T ) : Prop :=
  match ls with
  | [] => True
  | h::t => P h /\ All t
  end.
End All.


Section stack_expr_ind'.
  Variable P : stack_expr -> Prop.
  Hypothesis UVal_case: forall (v: EVMWord), P (UVal v).
  Hypothesis UInStackVar_case: forall (n: nat), P (UInStackVar n).
  Hypothesis UOp_case : forall (opcode: oper_label)
                               (args : list stack_expr),
                           All stack_expr P args -> P (UOp opcode args).
                           
  Fixpoint stack_expr_ind' (e : stack_expr) : P e :=
  match e with
  | UVal v => UVal_case v
  | UInStackVar n => UInStackVar_case n
  | UOp opcode args => UOp_case opcode args
  ((fix list_stack_expr_ind (args : list stack_expr) : All stack_expr P args :=
    match args with
    | [] => I
    | h::t => conj (stack_expr_ind' h) (list_stack_expr_ind t)
    end) args)
  end.
End stack_expr_ind'.


Section nat_tree_ind'.
  Variable P : nat_tree -> Prop.
  Hypothesis Const_case: forall (n: nat), P (Const n).
  Hypothesis NNode'_case : forall (n : nat) (ls : list nat_tree),
                            All nat_tree P ls -> P (NNode' n ls).
  
  Fixpoint nat_tree_ind' (tr : nat_tree) : P tr :=
  match tr with
  | Const n => Const_case n
  | NNode' n ls => NNode'_case n ls
  ((fix list_nat_tree_ind (ls : list nat_tree) : All nat_tree P ls :=
    match ls with
    | [] => I
    | tr'::rest => conj (nat_tree_ind' tr') (list_nat_tree_ind rest)
    end) ls)
  end.
End nat_tree_ind'.
Check nat_tree_ind'.

(*
Section map.
  Variables T T' : Set.
  Variable F : T -> T'.
  
  Fixpoint map (ls : list T ) : list T' :=
  match ls with
  | [] => [] 
  | h::t => (F h)::(map t)
  end.
End map.
Check map.*)

Fixpoint sum (ls : list nat) : nat :=
match ls with
| [] => O
| h::t => h + (sum t)
end.


Fixpoint n_elems (tr: nat_tree) : nat :=
match tr with
| Const n => 1
| NNode' n ls => 1 + sum(List.map n_elems ls)
end.

Fixpoint n_elems' (tr: nat_tree) : nat :=
match tr with
| Const n => 1
| NNode' n ls => sum(List.map n_elems' ls) + 1
end.

Search (Forall).
Compute (
let a := NNode' 3 [] in
let b := Const 7 in
let c := NNode' 9 [b;a] in
(n_elems c, n_elems' c)
).

Lemma map_ext_All: forall {A B : Set} (f g : A -> B) (l : list A),
All A (fun x : A => f x = g x) l -> List.map f l = List.map g l.
Proof.
intros A B f g ls. revert f g.
induction ls as [|h t IH].
- intros. reflexivity.
- intros. simpl.
  simpl in H. destruct H as [eq_f_g_h HAll_t].
  rewrite -> eq_f_g_h.
  apply IH in HAll_t.
  rewrite HAll_t.
  reflexivity.
Qed.  

Search (_+1).
Lemma test_ind: forall (tr: nat_tree), n_elems tr = n_elems' tr.
Proof.
induction tr as [n|n ls IH] using nat_tree_ind'.
- reflexivity.
- simpl. apply map_ext_All in IH.
  rewrite IH. rewrite PeanoNat.Nat.add_1_r.
  reflexivity.
Qed.  


Check nat_tree_ind'.

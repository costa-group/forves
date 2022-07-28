Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import List.
Require Import Coq_EVM.datatypes.
Import EVM_Def Concrete Abstract.
Require Import Coq_EVM.interpreter.
Import Interpreter SFS.
(*Require Import Coq_EVM.lib.evmModel.*)
Import ListNotations.


(* Enrique *)

(*
Definition lnat := [2;4;6].

Fixpoint all_true (prop: nat -> Prop) (l: list nat)  : Prop :=
match l with
| [] => True
| h::t => (prop h) /\ (all_true prop t) 
end.


Theorem aaa: forall (l: list nat) (prop: nat -> Prop),
all_true prop l->
forall (v pos: nat), nth_error l pos = Some v -> prop v.
Proof.
induction l as [| h t IH].
- intros. destruct pos; try (simpl in H0; discriminate).
- intros. simpl in H.
  destruct H as [proph propt].
  destruct pos as [|pos'].
  + simpl in H0. injection H0 as H0. rewrite <- H0. assumption.
  + simpl in H0.
    pose proof (IH prop propt v pos').
    apply H in H0. assumption.
Qed.

Definition myeven (n: nat) :=
Nat.even n = true.
Check (myeven).

Theorem all_true_lnat: all_true myeven lnat.
Proof.
unfold lnat. simpl. intuition; try (unfold myeven; reflexivity).
Qed.

Theorem bbb: forall (n: nat) (pos: nat), 
nth_error lnat pos = Some n -> myeven n.
Proof.
apply aaa. apply all_true_lnat.
Qed.
*)


Definition stack_val_has_value (av: asfs_stack_val) (v: EVMWord) : bool :=
match av with 
| Val x => weqb x v
| _ => false
end.

(* ADD(0,X) --> X *)
Fixpoint optimize_map_add_zero1 (fresh_var: nat) (map: asfs_map): 
  option asfs_map :=
match map with
| [] => None
| (n, val)::t => if n =? fresh_var then
                 match val with
                 | ASFSOp ADD [arg1; arg2] => 
                     if stack_val_has_value arg1 EVM_Def.WZero then
                       Some ((n, ASFSBasicVal arg2)::t)
                     else if stack_val_has_value arg2 WZero then
                       Some ((n, ASFSBasicVal arg1)::t)
                     else None
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


Definition equiv_map_eval (m1 m2: asfs_map) (ops: opm): Prop :=
forall (stack: concrete_stack) (n: nat), 
  eval_asfs2_elem stack (FreshVar n) m1 ops = 
  eval_asfs2_elem stack (FreshVar n) m2 ops.


Lemma eq_eval_opt_add_zero: forall (m1 m2: asfs_map) (ops: opm) (n: nat)
  (stack: concrete_stack) (elem: asfs_stack_val),
ops ADD = Some (Op true 2 add) ->
optimize_map_add_zero1 n m1 = Some m2 ->
eval_asfs2_elem stack elem m1 ops = eval_asfs2_elem stack elem m2 ops.
Proof.
induction m1 as [|h t IH].
- intros. simpl in H0. discriminate.
- intros. simpl in H0. destruct h as [hn hv] eqn: eq_h.
  destruct (hn =? n) eqn: eq_hn_n.
  + destruct (hv) as [basicval|opval] eqn: eq_hv. 
    * admit.
    * admit.
  + destruct (optimize_map_add_zero1 n t) as [map'|]; try discriminate.
    
Admitted.


Lemma equiv_map_eval_opt_add_zero: forall (ops: opm) (n: nat) 
  (map map': asfs_map),
ops ADD = Some (Op true 2 add) ->
optimize_map_add_zero1 n map = Some map' ->
equiv_map_eval map map' ops.
Proof.
intros ops n map. revert ops n.
induction map as [|h t IH].
- intros. simpl in H0. discriminate.
- intros. simpl in H0.
  destruct h as [nh vh] eqn: eq_h.
  destruct (nh =? n) eqn: eq_nh_n.
  + admit.
  + destruct (optimize_map_add_zero1 n t); try discriminate.
    injection H0 as H0. rewrite <- H0.
    unfold equiv_map_eval. intros.
  
 unfold equiv_map_eval. intros.
Admitted.


Lemma eval_value: forall (stack: concrete_stack) (val: EVMWord) (m: asfs_map)
  (ops: opm),
eval_asfs2_elem stack (Val val) m ops = Some val.
Proof.
intros. destruct m; try (unfold eval_asfs2_elem; reflexivity).
Qed.

Lemma eval_var: forall (stack: concrete_stack) (var: nat) (m1 m2: asfs_map)
  (ops: opm),
eval_asfs2_elem stack (InStackVar var) m1 ops =
eval_asfs2_elem stack (InStackVar var) m2 ops.
Proof.
intros. destruct m1.
- destruct m2; try reflexivity.
- destruct m2; try reflexivity.
Qed.

Lemma eval_elem_equiv_map: forall (stack: concrete_stack) (elem: asfs_stack_val)
  (m1 m2: asfs_map) (ops: opm),
equiv_map_eval m1 m2 ops ->
eval_asfs2_elem stack elem m1 ops = eval_asfs2_elem stack elem m2 ops.
Proof.
intros.
destruct elem as [val|var|fvar] eqn: eq_elem.
- rewrite -> eval_value. rewrite -> eval_value. reflexivity.
- apply eval_var.
- unfold equiv_map_eval in H. 
  pose proof (H stack fvar). assumption.
Qed.

Lemma opt_add_zero_same_preservation: forall (fresh_var: nat) (h1 h2 maxid1 maxid2: nat) 
  (s1 s2: asfs_stack) (m1 m2: asfs_map),
optimize_add_zero1 fresh_var (ASFSc h1 maxid1 s1 m1) = 
  Some (ASFSc h2 maxid2 s2 m2) ->
h1 = h2 /\ maxid1 = maxid2 /\ s1 = s2.
Proof.
intros. unfold  optimize_add_zero1 in H. unfold optimize_func_map in H.
destruct (optimize_map_add_zero1 fresh_var m1); try discriminate.
injection H. intros H1 H2 H3 H4.
split; try assumption.
split; try assumption.
Qed.


Theorem optimize_add_zero1_safe_gen: forall (stk: asfs_stack) (ops: opm) (fresh_var: nat)
  (m m': asfs_map) (c: concrete_stack),
ops ADD = Some (Op true 2 add) ->
optimize_map_add_zero1 fresh_var m = Some m' ->
eval_asfs2 c stk m ops = eval_asfs2 c stk m' ops.
Proof.
induction stk as [| h t IH].
- reflexivity.
- intros. 
  pose proof (equiv_map_eval_opt_add_zero ops fresh_var m m' H H0) as 
    Hequiv_m_m'.
  unfold eval_asfs2. unfold apply_f_list_asfs_stack_val.
  destruct (eval_asfs2_elem c h m ops) as [h_eval|] eqn: eq_evalh.
  + pose proof (eval_elem_equiv_map c h m m' ops Hequiv_m_m')
      as eq_eval_h_m_m'.
    rewrite <- eq_eval_h_m_m'. rewrite -> eq_evalh.
    rewrite -> eval_asfs2_ho. rewrite -> eval_asfs2_ho.
    destruct (eval_asfs2 c t m ops) as [t_eval|] eqn: eq_eval_t_m.
    * pose proof (IH ops fresh_var m m' c H H0) as eq_eval_t_m_m'.
      rewrite <- eq_eval_t_m_m'. rewrite -> eq_eval_t_m.
      reflexivity.
    * pose proof (IH ops fresh_var m m' c H H0) as eq_eval_t_m_m'.
      rewrite <- eq_eval_t_m_m'. rewrite -> eq_eval_t_m.
      reflexivity.
  + pose proof (eval_elem_equiv_map c h m m' ops Hequiv_m_m')
      as eq_eval_h_m_m'.
    rewrite <- eq_eval_h_m_m'. rewrite -> eq_evalh.
    reflexivity.
Qed.


Theorem optimize_add_zero1_safe: forall (a1 a2: asfs) (fresh_var: nat)
  (c: concrete_stack) (ops: opm),
ops ADD = Some (Op true 2 add) ->
optimize_add_zero1 fresh_var a1 = Some a2 ->
eval_asfs c a1 ops = eval_asfs c a2 ops.
Proof.
(* Using optimize_add_zero1_safe_gen *)
intros a1 a2 fresh_var c ops HADD Hopt.
destruct a1 as [h1 maxid1 s1 m1] eqn: eq_a1.
destruct a2 as [h2 maxid2 s2 m2] eqn: eq_a2.
unfold optimize_add_zero1 in Hopt.
unfold optimize_func_map in Hopt.
destruct (optimize_map_add_zero1 fresh_var m1) as [m'|]eqn: eq_opt_map;
  try discriminate.
injection Hopt as eqh1_h2 eqmaxid eqs1s2 eqm'.
rewrite -> eqh1_h2. rewrite -> eqs1s2. rewrite <- eqm'.
unfold eval_asfs.
destruct (length c =? h2); try reflexivity.
apply optimize_add_zero1_safe_gen with (fresh_var:=fresh_var); try assumption.
Qed.


(*
Definition l_op := [optimize_add_zero1_gen; optimize_add_mul1_gen, ....]

Theorem t: forall e \in l_op, ASFS a, 
  e a ops => Some a' ->
  eval_asfs a opmap = eval a' opmap
  
Definition opt_scheme (lopt: list optimizations) (a: ASFS) := ...

Theorem t: (l: list optimization)
l is subset of l_op ->
opt_scheme l a = Some a' ->
eval a opmap = eval a' opmap.

Definition checker (p1 p2: prog) =
let asfs1 := symb_exec p1 opmap in
let asfs2 := symb_exec p2 opmap in
let opt_asfs1 := opt_scheme ([opt1; opt2;....]) a in
eq_asfs opt_asfs1  asfs2 opmap.

Proof obligations: [opt1; opt2;....] is a sublist of l:op
*)


(* Joseba *)
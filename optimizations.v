Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import List.
Require Import Coq_EVM.datatypes.
Import EVM_Def Concrete Abstract Optimizations.
Require Import Coq_EVM.interpreter.
Import Interpreter SFS.
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

(* EXPLANATION OPTIMIZATIONS

What is a safe optimization (a: ASFS) = a': ASFS?
-------------------------------------------------
1) Some optimizations like ADD(X,0) -> X or MUL(X,1) -> X completely preserve
the evaluation of any asfs_stack_value 'e', i.e., if a' = optimization a then
  eval_elem concrete_stack e a = eval_elem concrete_stack e a'
Both return None and Some x in the same cases.

2) Other optimizations like MUL(X,0) -> 0 do not completely preserve the 
evaluation *for any asfs_stack_value 'e'* if 'e' is ill-defined (for example
e = FresVar 57, where FreshVar 57 is not defined in the ASFS a). In these
cases the evaluation can return None for the ASFS a but the evaluation in 
a' returns 0. However, every successful evaluation in the ASFS a will obtain
the same value in the ASFS a':
  eval_elem concrete_stack e a = Some v ->
  eval_elem concrete_stack e a' = Some v
  
Clearly, 1) implies 2) because is stronger. In summary, our notion of "safe
optimization" must be 2), as all the optimizations will verify it and is 
strong enought for our needs


Do we need to impose some properties about the ASFS a?
------------------------------------------------------
Consider the optimization "NOT(NOT(X)) -> X" and an ASFS "a" with a mapping
with this (simplified) shape:

[ (100, NOT [FreshVar 75]), 
  (50, Val 16),
  (75, NOT [FreshVar 50]),
  (50, Val 5),
]

The evaluation of (FreshVar 100) will be NOT(NOT(5)) = 5.

The optimization NOT(NOT(X)) -> X will generate an optimized ASFS a' with a
mapping with this (simplified) shape, where (FreshVar 100) points directly to
the value in (FreshVar 50):

[ (100, FreshVar 50), 
  (50, Val 16),
  (75, NOT [FreshVar 50]),
  (50, Val 5),
]

Here, the evaluation of (FreshVar 100) will be 16. The problem here is that
when evaluating (FreshVar 100) in the ASFS a' we have found an occurrence of 
(FreshVar 50) with a different value that the one stored later in the mapping.

In order to have preservation of the evaluation with this optimization, we
cannot assume *any possible mapping* (as we have done in the rest of 
optimizations) but a *mapping without repetitions*. It is not a problem 
because the way we crete an ASFS with the symbolic execution there will never
be repetitions (we always take maxid+1 as the FreshVar number). Indeed, the 
mapping is *strictly decreasing in the fresh variable numbers*, which is a 
stronger property that implies the absence of repetitions and can be more 
convenient for the proofs.

Note that (so far) the optimization does not add any entry in the mapping but
changes the value related to some entry, so the property is preserved under
any optimization [which is mandatory in order to concatenate them]. 
*)



Module Optimizations.


(* General definitions to define different optimizations and useful common
   lemmas *)

Fixpoint stack_val_is_oper (oper: oper_label) (val: asfs_stack_val) 
  (m: asfs_map) {struct m}: option (list asfs_stack_val) :=
match val with 
| Val _ => None
| InStackVar _ => None
| FreshVar fvar => match m with
                   | [] => None
                   | (k,v)::t => 
                       if k =? fvar then
                         match v with
                         | ASFSOp opcode args =>
                           if oper =?i opcode then Some args
                           else None
                         | _ => None
                         end
                       else stack_val_is_oper oper val t
                   end
end.

(* Tries to apply the optimization 'opt' traversing all the free variables
   in the map. Stops as soon as it finds one that the optmization succeeds
*)
Fixpoint optimize_fresh_var2 (a: asfs) (m: asfs_map) 
 (opt: nat -> asfs -> option asfs): asfs*bool :=
match m with
| [] => (a, false)
| (n,_)::t => match opt n a with
              | None => optimize_fresh_var2 a t opt
              | Some a' => (a',true)
              end
end.

(* When an optimization is not applicable, optimize_fresh_var2 returns the
   same ASFS *)
Lemma optimize_fresh_var2_not_applicable: forall (a a': asfs) (m: asfs_map) 
 (opt: nat -> asfs -> option asfs),
optimize_fresh_var2 a m opt = (a', false) ->
a = a'.
Proof.
intros a a' m. revert a a'.
induction m as [|h t IH].
- intros. simpl in H. injection H. auto.
- intros. simpl in H. destruct h as [var expr] eqn: eq_h.
  destruct (opt var a) as [opta|] eqn: eq_opt_var_a.
  + discriminate.
  + apply IH in H. assumption.
Qed.


Definition optimize_fresh_var (opt: nat -> asfs -> option asfs) (a: asfs):
  asfs*bool :=
match a with
| ASFSc height maxid s m  => optimize_fresh_var2 a m opt
end.


Definition safe_optimization_fvar (opt: nat -> asfs -> option asfs) : Prop :=
forall (n: nat) (c cf: concrete_stack) (a opt_a: asfs),
eval_asfs c a opmap = Some cf ->
opt n a = Some opt_a ->
strictly_decreasing_map_asfs a ->
eval_asfs c opt_a opmap = Some cf /\ strictly_decreasing_map_asfs opt_a.


Definition safe_optimization (opt: asfs -> asfs*bool) : Prop :=
forall (c cf: concrete_stack) (a opt_a: asfs) (b: bool),
eval_asfs c a opmap = Some cf ->
opt a = (opt_a, b) ->
strictly_decreasing_map_asfs a ->
eval_asfs c opt_a opmap = Some cf /\ strictly_decreasing_map_asfs opt_a.


Lemma optimize_fresh_var2_preservation: forall (m: asfs_map) (a a': asfs) 
  (opt: nat -> asfs -> option asfs) (b: bool) (c cf: concrete_stack),
safe_optimization_fvar opt ->
optimize_fresh_var2 a m opt = (a', b) ->
strictly_decreasing_map_asfs a ->
eval_asfs c a opmap = Some cf ->
eval_asfs c a' opmap = Some cf /\ strictly_decreasing_map_asfs a'.
Proof.
intros m.
induction m as [| h t IH]. 
- intros. unfold optimize_fresh_var2 in H0. injection H0 as Hasfs Hfalse.
  rewrite <- Hasfs. split; try assumption. 
- intros. 
  unfold optimize_fresh_var2 in H0.
  destruct h as [fvar expr] eqn: eq_h.
  destruct (opt fvar a) as [opt_a|] eqn: eq_opt_fvar.
  + injection H0 as eqa'.
    unfold safe_optimization_fvar in H.
    rewrite -> eqa' in eq_opt_fvar.
    pose proof (H fvar c cf a a' H2 eq_opt_fvar H1) as [HH1 HH2].
    split; try assumption.
  + fold optimize_fresh_var2 in H0.
    pose proof (IH a a' opt b c cf H H0 H1 H2).
    assumption.
Qed.


Lemma optimize_fresh_var_preservation: forall (opt: nat -> asfs -> option asfs),
safe_optimization_fvar opt ->
safe_optimization (optimize_fresh_var opt).
Proof.
intros. 
unfold safe_optimization. intros.
destruct a as [ha maxa sa ma] eqn: eq_a.
unfold optimize_fresh_var in H1.
rewrite <- eq_a in H1. rewrite <- eq_a in H0.
rewrite <- eq_a in H2.
pose proof (optimize_fresh_var2_preservation ma a opt_a opt b c cf H H1 H2 H0).
assumption.
Qed.




Definition stack_val_has_value (av: asfs_stack_val) (v: EVMWord) : bool :=
match av with 
| Val x => weqb x v
| _ => false
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


Lemma stack_val_has_value_eval: forall (c: concrete_stack) 
  (elem: asfs_stack_val) (v: EVMWord) (m: asfs_map) (ops: opm),
stack_val_has_value elem v = true ->  
eval_asfs2_elem c elem m ops = Some v.
Proof.
intros. unfold stack_val_has_value in H.
destruct (elem) as [x|var|fvar] eqn: eq_elem; try discriminate.
apply weqb_sound in H. rewrite -> H.
destruct m; try reflexivity.
Qed.


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


(* If the evaluation of every element wrt. m1 is the same as wrt. m2,
   then the evaluation of any list of elements will be the same *)
Lemma eq_eval_elem_stack: forall (c: concrete_stack) (m1 m2: asfs_map)
  (ops: opm) (s: asfs_stack),
(forall (elem: asfs_stack_val), eval_asfs2_elem c elem m1 ops =
                                eval_asfs2_elem c elem m2 ops) ->
eval_asfs2 c s m1 ops = eval_asfs2 c s m2 ops.
Proof.
intros c m1 m2 ops s. revert c m1 m2 ops. 
induction s as [| h t IH].
- intros. reflexivity.
- intros c m1 m2 ops Heval_elem_eq. 
  unfold eval_asfs2. unfold apply_f_list_asfs_stack_val.
  rewrite -> eval_asfs2_ho. rewrite -> eval_asfs2_ho.
  destruct (eval_asfs2_elem c h m1 ops) as [eval_h|] eqn: eq_eval_h_m1.
  + pose proof (Heval_elem_eq h) as eq_eval_h_m1_m2.
    rewrite <- eq_eval_h_m1_m2.
    rewrite -> eq_eval_h_m1.
    pose proof (IH c m1 m2 ops Heval_elem_eq) as eq_eval_t_m1_m2.
    rewrite -> eq_eval_t_m1_m2.
    reflexivity.
  + pose proof (Heval_elem_eq h) as eq_eval_h_m1_m2.
    rewrite <- eq_eval_h_m1_m2.
    rewrite -> eq_eval_h_m1.
    reflexivity.
Qed.


(* If the successful evaluation of every element wrt. m1 is the same as 
   wrt. m2, then the successful evaluation of any list of elements will 
   be the same sucessfull value *)
Lemma eq_succ_eval_elem_stack: forall (c cf: concrete_stack) (m1 m2: asfs_map)
  (ops: opm) (s: asfs_stack),
(forall (elem: asfs_stack_val) (v: EVMWord), 
   eval_asfs2_elem c elem m1 ops = Some v ->
   eval_asfs2_elem c elem m2 ops = Some v) ->
eval_asfs2 c s m1 ops = Some cf -> 
eval_asfs2 c s m2 ops = Some cf.
Proof.
intros c cf m1 m2 ops s. revert c cf m1 m2 ops. 
induction s as [| h t IH].
- intros. unfold eval_asfs2 in H0. simpl in H0. 
  injection H0 as H0. rewrite <- H0.
  unfold eval_asfs2. simpl. reflexivity.
- intros c cf m1 m2 ops Heval_elem_eq. 
  unfold eval_asfs2. unfold apply_f_list_asfs_stack_val.
  rewrite -> eval_asfs2_ho. rewrite -> eval_asfs2_ho.
  destruct (eval_asfs2_elem c h m1 ops) as [eval_h|] eqn: eq_eval_h_m1;
    try (intros; discriminate).
  apply Heval_elem_eq in eq_eval_h_m1 as eq_eval_h_m2.
  rewrite -> eq_eval_h_m2.
  destruct (eval_asfs2 c t m1 ops) as [teval|] eqn: eq_eval_t_m1;
    try (intros; discriminate).
  pose proof (IH c teval  m1 m2 ops Heval_elem_eq eq_eval_t_m1)
    as eq_eval_t_m2.
  rewrite -> eq_eval_t_m2. intros. assumption.
Qed.



Lemma strictly_decreasing_preserv: forall (n:nat) (v: asfs_map_val) 
  (m: asfs_map),
strictly_decreasing_map ((n, v)::m) ->
strictly_decreasing_map m.
Proof.
intros n v m Hdecreasing_all.
simpl in Hdecreasing_all.
destruct m as [|h t] eqn: eq_m.
- simpl. intuition.
- destruct h as [v2 e2] eqn: eq_h. 
  intuition.
Qed.


(* If elem points to a function with inner_args (i.e., it is a FreshVar) then
   there is a suffix of the map s.t. inner_args are evaluated to values *)
Lemma evaluation_sufix_map: forall (m: asfs_map) (nbargs: nat)  
  (elem: asfs_stack_val)
  (inner_args: asfs_stack) (comm: bool) (func: list EVMWord -> option EVMWord)
  (val: EVMWord) (oper: oper_label) (ops: opm) (stack: concrete_stack),
stack_val_is_oper oper elem m = Some inner_args ->
ops oper = Some (Op comm nbargs func) ->
eval_asfs2_elem stack elem m ops = Some val ->
exists (prefix suffix: asfs_map) (inner_vals: concrete_stack), 
  m = prefix ++ suffix /\
  eval_asfs2 stack inner_args suffix ops = Some inner_vals /\
  func inner_vals = Some val.
Proof.
induction m as [| h t IH].
- intros. simpl in H. destruct elem; try discriminate H.
- intros. simpl in H.
  destruct elem as [| |fvar] eqn: eq_elem; try discriminate H.
  destruct h as [k e] eqn: eq_h.
  destruct (k =? fvar) eqn: eq_k_fvar.
  + destruct e as [basicval| opcode args] eqn: eq_e; try discriminate H.
    destruct (oper =?i opcode) eqn: eq_oper; try discriminate H.
    simpl in H1. rewrite -> eq_k_fvar in H1.
    apply eq_oper_label_correct in eq_oper.
    rewrite <- eq_oper in H1. rewrite -> H0 in H1.
    destruct (length args =? nbargs) eqn: eq_len_args; try discriminate H1.
    rewrite -> eval_asfs2_ho in H1.
    injection H as eq_args_inner. rewrite -> eq_args_inner in H1.
    destruct (eval_asfs2 stack inner_args t ops) as [vargs|] 
      eqn: eq_eval_inner_args; try discriminate H1.
    exists [(k, ASFSOp opcode args)]. exists t. exists vargs.
    split; try reflexivity.
    split; try assumption.
  + unfold eval_asfs2_elem in H1. rewrite -> eq_k_fvar in H1.
    fold eval_asfs2_elem in H1.
    pose proof (IH nbargs (FreshVar fvar) inner_args comm func val oper ops stack H
      H0 H1) as IHc.
    destruct IHc as [pref [ suff [inner_vals [Hpresuff [Hevalinner Hfunc]]]]].
    exists ((k, e)::pref). exists suff. exists inner_vals.
    split; try (split; assumption).
    simpl. rewrite -> Hpresuff.
    reflexivity.
Qed.


(* If we can evaluate a FreshVar, the in must appear in the map *)
Lemma eval_fvar_then_in_map: forall (stack: concrete_stack) (fvar: nat)
  (m: asfs_map) (ops: opm) (v: EVMWord),
eval_asfs2_elem stack (FreshVar fvar) m ops = Some v ->
exists (e: asfs_map_val), In (fvar, e) m.
Proof.
intros stack fvar m. revert stack fvar.
induction m as [|h t IH].
- intros. simpl in H. discriminate.
- intros. simpl in H.
  destruct h as [n e] eqn: eq_h.
  destruct (n =? fvar) eqn: eq_n_fvar.
  + rewrite -> Nat.eqb_eq in eq_n_fvar. 
    rewrite -> eq_n_fvar.
    exists e. intuition.
  + apply IH in H as [e' HInt].
    exists e'. apply in_cons. assumption.
Qed.


(* If a map is strictly_decreasing, then the head is > any entry in the tail *)
Lemma decreasing_cons_then_gt: forall (fvar n: nat) 
  (e efvar: asfs_map_val) (m: asfs_map),
In (fvar, efvar) m ->
strictly_decreasing_map ((n, e)::m) ->
n > fvar.
Proof.
intros fvar n e efvar m. revert fvar n e efvar.
induction m as [| hm tm IH].
- intros. simpl in H. contradiction.
- intros. simpl in H. destruct H.
  + rewrite -> H in H0. simpl in H0. 
    destruct H0 as [n_gt_fvar _ ]. assumption.
  + destruct hm as [hm_fvar hm_e] eqn: eq_hm.
    pose proof (strictly_decreasing_preserv n e ((hm_fvar, hm_e)::tm) H0)
      as Hdecresing_tail.
    pose proof (IH fvar hm_fvar hm_e efvar H Hdecresing_tail).
    simpl in H0. destruct H0 as [n_gt_hm_var _].
    apply gt_trans with (m:=hm_fvar); try assumption.
Qed.


(* If a map is strictly_decreasing, then the head is different from any 
   entry in the tail *)
Lemma decreasing_cons_then_different: forall (fvar n: nat) 
  (e efvar: asfs_map_val) (m: asfs_map),
In (fvar, efvar) m ->
strictly_decreasing_map ((n, e)::m) ->
n =? fvar = false.
Proof.
intros. 
pose proof (decreasing_cons_then_gt fvar n e efvar m H H0) as n_gt_fvar.
apply Nat.nle_gt in n_gt_fvar. simpl in n_gt_fvar.
apply Nat.leb_nle in n_gt_fvar.
apply gt_neq in n_gt_fvar.
assumption.
Qed.


(* The evaluation of an element does not change in strictly_decreasing maps
   when adding a new entry in the head *)
Lemma eval_elem_cons_decreasing_map: forall (stack: concrete_stack)
  (elem: asfs_stack_val) (n: nat) (e: asfs_map_val) (suffix m: asfs_map)
  (ops: opm) (v : EVMWord),
eval_asfs2_elem stack elem suffix ops = Some v ->
m = (n, e)::suffix ->
strictly_decreasing_map m ->
eval_asfs2_elem stack elem m ops = Some v.
Proof.
intros stack elem n e suffix m ops v Heval_suffix Hmcons Hdecreasing.
destruct elem as [val|var|fvar] eqn: eq_elem.
- pose proof (eval_value stack val suffix ops) as Heval_suffix_val.
  rewrite -> Heval_suffix  in Heval_suffix_val.
  rewrite -> Heval_suffix_val.
  apply eval_value.
- pose proof (eval_var stack var suffix m ops) as eq_eval_var.
  rewrite <- eq_eval_var. assumption.
- pose proof (eval_fvar_then_in_map stack fvar suffix ops v Heval_suffix)
    as [efvar Hfvar_in_suffix].
  rewrite -> Hmcons in Hdecreasing.
  pose proof (decreasing_cons_then_different fvar n e efvar suffix
    Hfvar_in_suffix Hdecreasing) as Hfvar_diff_n.
  rewrite -> Hmcons. simpl. rewrite -> Hfvar_diff_n.
  assumption.
Qed.

(* The evaluation of an element does not change in strictly_decreasing maps
   when adding a prefix of entries in the head of the map *)
Lemma eval_elem_bigger_decreasing_map: forall (stack: concrete_stack)
  (elem: asfs_stack_val) (prefix suffix m: asfs_map) (ops: opm)
  (v : EVMWord),
eval_asfs2_elem stack elem suffix ops = Some v ->
m = prefix ++ suffix ->
strictly_decreasing_map m ->
eval_asfs2_elem stack elem m ops = Some v.
Proof.
intros stack elem prefix. revert stack elem.
induction prefix as [|h t IH].
- intros stack elem suffix m ops v Hevalsuffix Hmprefixsuffix Hdecreasing.
  simpl in Hmprefixsuffix. rewrite -> Hmprefixsuffix.
  assumption.
- intros stack elem suffix m ops v Hevalsuffix Hmprefixsuffix Hdecreasing.
  simpl in Hmprefixsuffix. 
  destruct elem as [val|var|fvar] eqn: eq_elem.
  + pose proof (eval_value stack val suffix ops) as Heval_suffix_val.
    rewrite -> Hevalsuffix  in Heval_suffix_val.
    rewrite -> Heval_suffix_val.
    apply eval_value.
  + pose proof (eval_var stack var suffix m ops) as eq_eval_var.
    rewrite <- eq_eval_var. assumption.
  + destruct h as [n e] eqn: eq_h.
    assert (t ++ suffix = t ++ suffix) as Htsuffix; try reflexivity. 
    rewrite -> Hmprefixsuffix in Hdecreasing.
    pose proof (strictly_decreasing_preserv n e (t++suffix) Hdecreasing)
      as Hdecreasing_h_suffix.
    pose proof (IH stack (FreshVar fvar) suffix (t ++ suffix) ops v 
      Hevalsuffix Htsuffix Hdecreasing_h_suffix) as Heval_elem_t_suffix.
    rewrite <- Hmprefixsuffix in Hdecreasing.
    apply eval_elem_cons_decreasing_map with (n:=n) (e:=e) (suffix:=t++suffix);
      try assumption.
Qed.


(* If we evaluate an abstract stack (h::t) then we can evaluate the element 
   'h' and the tail 't' *)
Lemma eval_asfs2_cons: forall (h: asfs_stack_val) (t: asfs_stack) 
  (m: asfs_map) (ops: opm) (stack vals: concrete_stack),
eval_asfs2 stack (h :: t) m ops = Some vals ->
exists (v: EVMWord) (vals': concrete_stack),
  vals = v::vals' /\
  eval_asfs2_elem stack h m ops = Some v /\
  eval_asfs2 stack t m ops = Some vals'.
Proof.
intros. 
unfold eval_asfs2 in H. simpl in H.
destruct (eval_asfs2_elem stack h m ops) eqn: eq_eval_h_m; try discriminate.
rewrite -> eval_asfs2_ho in H.
destruct (eval_asfs2 stack t m ops ) eqn: eq_eval_t_m; try discriminate.
exists e. exists l. split; try (split; reflexivity).
injection H. intuition.
Qed.

(* If we can evaluate the element 'h' and an asfs_stack 't', then we can
   evaluate (h::t) *)
Lemma eval_asfs2_cons_r: forall (h: asfs_stack_val) (t: asfs_stack) 
  (m: asfs_map) (ops: opm) (stack vals': concrete_stack) (v: EVMWord),
eval_asfs2 stack t m ops = Some vals' ->
eval_asfs2_elem stack h m ops = Some v ->
eval_asfs2 stack (h :: t) m ops = Some (v::vals').
Proof. 
intros. unfold eval_asfs2. simpl.
rewrite -> H0. 
rewrite -> eval_asfs2_ho. rewrite -> H.
reflexivity.
Qed.


(* Both maps contains the same free vars *)
Fixpoint same_fvar_in_maps (m1 m2: asfs_map) {struct m1} : Prop :=
match m1 with
| [] => match m2 with 
        | [] => True
        | _  => False
        end
| (fvar1, _)::t1 => match m2 with
                    | [] => False
                    | (fvar2, _)::t2 => fvar1 = fvar2 /\ 
                                        same_fvar_in_maps t1 t2
                    end
end.


Lemma same_fvar_refl: forall (m: asfs_map),
same_fvar_in_maps m m.
Proof.
induction m as [|h t IH].
- intuition.
- intuition. simpl. split.
  + reflexivity.
  + apply IH.
Qed.



Lemma same_fvar_in_map_preserves_decreasingness: forall (m1 m2: asfs_map),
strictly_decreasing_map m1 ->
same_fvar_in_maps m1 m2 -> 
strictly_decreasing_map m2.
Proof.
induction m1 as [|h t IH].
- intros m2 Hdecr_m1 Hsame_fvars. 
  simpl in Hsame_fvars. destruct m2 eqn: eq_m2; try contradiction.
  intuition.
- intros m2 Hdecr_m1 Hsame_fvars. 
  simpl in Hsame_fvars. destruct h as [fvar efvar] eqn: eq_h.
  destruct m2 as [| h' t'] eqn: eq_m2; try contradiction.
  destruct h' as [fvar' efvar'] eqn: eq_h'.
  destruct Hsame_fvars as [eq_fvar_fvar' Hsame_vars_t_t'].
  rewrite <- eq_fvar_fvar'.
  simpl in Hdecr_m1.
  destruct t as [|h2 t2] eqn: eq_t.
  + simpl in Hsame_vars_t_t'. destruct t' eqn: eq_t'; try contradiction.
    intuition.
  + destruct h2 as [fvar2 efvar2] eqn: eq_h2.
    destruct Hdecr_m1 as [fvar_gt_fvar2 Hdecr_t1].
    pose proof (IH t' Hdecr_t1 Hsame_vars_t_t').
    simpl in Hsame_vars_t_t'.
    destruct t' as [|h2' t2'] eqn: eq_t'; try contradiction.
    destruct h2' as [fvar2' efvar2'] eqn: eq_h2'.
    destruct Hsame_vars_t_t' as [eq_fvar2_fvar2' _].
    rewrite <- eq_t'.
    simpl. rewrite -> eq_t'.
    rewrite <- eq_fvar2_fvar2'.
    rewrite -> eq_fvar2_fvar2' at 2.
    split; try assumption.
Qed.






(* The evaluation of an asfs_stack does not change in strictly_decreasing maps
   when adding a new prefix in the head of the map *)
Lemma eval_bigger_decreasing_map: forall (stack vals: concrete_stack)
  (abs: asfs_stack) (prefix suffix m: asfs_map) (ops: opm),
eval_asfs2 stack abs suffix ops = Some vals ->
m = prefix ++ suffix ->
strictly_decreasing_map m ->
eval_asfs2 stack abs m ops = Some vals.
Proof.
intros stack vals abs. revert stack vals.
induction abs as [|h t IH].
- intros stack vals prefix suffix m ops Hevalsuffix Hmprefixsuffix Hdecreasing.
  simpl in Hmprefixsuffix. rewrite -> Hmprefixsuffix.
  assumption.
- intros stack vals prefix suffix m ops Hevalsuffix Hmprefixsuffix Hdecreasing.
  simpl in Hevalsuffix.
  pose proof (eval_asfs2_cons h t suffix ops stack vals Hevalsuffix)
    as [hval [tval [eq_vals [Heval_h Heval_t]]]].
  pose proof (eval_asfs2_cons_r h t suffix ops stack tval hval Heval_t
    Heval_h) as eq_eval_h_t_suffix.
  rewrite -> Hevalsuffix in eq_eval_h_t_suffix.
  pose proof (IH stack tval prefix suffix m ops Heval_t Hmprefixsuffix
    Hdecreasing) as eq_eval_t_m.
  pose proof (eval_elem_bigger_decreasing_map stack h prefix suffix m ops
    hval Heval_h Hmprefixsuffix Hdecreasing) as eq_eval_h_m.
  pose proof (eval_asfs2_cons_r h t m ops stack tval hval eq_eval_t_m
    eq_eval_h_m) as eq_eval_h_t_m.
  rewrite -> eq_eval_h_t_m.
  symmetry. assumption.
Qed.




(*******************************************
  Optimization ADD(0,X) or ADD(X,0) --> X 
********************************************)
Fixpoint optimize_map_add_zero (fresh_var: nat) (map: asfs_map): 
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
                 else match optimize_map_add_zero fresh_var t with 
                      | None => None
                      | Some map' => Some ((n, val)::map')
                      end
end.

Definition optimize_add_zero_fvar (fresh_var: nat) (s: asfs) : option asfs :=
optimize_func_map optimize_map_add_zero fresh_var s.

Lemma word_add_0_x_is_x: forall (x: EVMWord),
add [WZero; x] = Some x.
Proof.
intros x. simpl.
rewrite -> wplus_wzero_2. reflexivity.
Qed.

Lemma word_add_x_0_is_x: forall (x: EVMWord),
add [x; WZero] = Some x.
Proof.
intros x. simpl.
rewrite -> wplus_wzero_1. reflexivity.
Qed.


(* Main lemma: every stack value is evaluated to the same value in the 
   original map and also in the optimized one for ADD_0 *)
Lemma eq_eval_opt_add_zero: forall (m1 m2: asfs_map) (ops: opm) (n: nat)
  (stack: concrete_stack),
ops ADD = Some (Op true 2 add) ->
optimize_map_add_zero n m1 = Some m2 ->
forall (elem: asfs_stack_val), eval_asfs2_elem stack elem m1 ops =
                               eval_asfs2_elem stack elem m2 ops.
Proof.
induction m1 as [|h t IH].
- intros. simpl in H0. discriminate.
- intros. simpl in H0. destruct h as [hn hv] eqn: eq_h.
  destruct (hn =? n) eqn: eq_hn_n.
  + (* We have found the fresh variable to optimize in the map *) 
    destruct (hv) as [basicval|opval] eqn: eq_hv. 
    * discriminate.
    * destruct (opval) eqn: eq_opval; try discriminate.
      destruct args as [| arg1 ta]; try discriminate.
      destruct ta as [| arg2 tta]; try discriminate.
      destruct tta; try discriminate.
      destruct (stack_val_has_value arg1 WZero) eqn: eq_arg1_zero.
      -- (* arg1 is WZero *)
         injection H0 as eq_m2. rewrite <- eq_m2.
         destruct elem as [val|var|fvar] eqn: eq_elem.
         ++ apply eval_value.
         ++ apply eval_var.
         ++ unfold eval_asfs2_elem. destruct (hn =? fvar) eqn: eq_vame_fvar.
            ** rewrite -> H. simpl. fold eval_asfs2_elem.
               rewrite -> stack_val_has_value_eval with (v:=WZero);
                 try assumption.
               destruct (eval_asfs2_elem stack arg2 t ops) as [arg2_val|]
                 eqn: eq_eval_arg2; try reflexivity.
               rewrite -> word_add_0_x_is_x. reflexivity.
            ** fold eval_asfs2_elem. reflexivity.
      -- (* arg2 is WZero *)
         destruct (stack_val_has_value arg2 WZero) eqn: eq_arg2_zero;
           try discriminate.
         injection H0 as eq_m2. rewrite <- eq_m2.
         destruct elem as [val|var|fvar] eqn: eq_elem.
         ++ apply eval_value.
         ++ apply eval_var.
         ++ unfold eval_asfs2_elem. destruct (hn =? fvar) eqn: eq_vame_fvar.
            ** rewrite -> H. simpl. fold eval_asfs2_elem.
               destruct (eval_asfs2_elem stack arg1 t ops) as [arg1_val|]
                 eqn: eq_eval_arg2; try reflexivity.
               rewrite -> stack_val_has_value_eval with (v:=WZero);
                 try assumption.
               rewrite -> word_add_x_0_is_x.
               reflexivity.
            ** fold eval_asfs2_elem. reflexivity.
  + (* This is not yet the fresh variable to optimize*) 
    destruct (optimize_map_add_zero n t) as [map'|] eqn: eq_optimize_t; 
      try discriminate.
    injection H0 as H0. rewrite <- H0. 
    destruct elem as [val|var|fvar] eqn: eq_elem; try reflexivity.
    simpl. destruct (hn =? fvar) eqn: eq_hn_fvar.
    * destruct hv eqn: eq_hv.
      -- apply IH with (n:=n); try assumption.
      -- rewrite -> eval_asfs2_ho. rewrite -> eval_asfs2_ho.
         pose proof (IH map' ops n stack H eq_optimize_t) as IHc.
         pose proof (eq_eval_elem_stack stack t map' ops args IHc) as
           eq_eval_t_map'.
         rewrite -> eq_eval_t_map'. reflexivity.
    * apply IH with (n:=n); try assumption.
Qed.

Theorem optimize_add_zero_fvar_eq: forall (a1 a2: asfs) (fresh_var: nat)
  (c: concrete_stack) (ops: opm),
ops ADD = Some (Op true 2 add) ->
optimize_add_zero_fvar fresh_var a1 = Some a2 ->
eval_asfs c a1 ops = eval_asfs c a2 ops.
Proof.
intros.
destruct a1 as [h1 maxid1 s1 m1] eqn: eq_a1.
destruct a2 as [h2 maxid2 s2 m2] eqn: eq_a2.
simpl in H0.
destruct (optimize_map_add_zero fresh_var m1) eqn: eq_opt_zero_map;
  try discriminate.
injection H0 as Hh1h2 Hmaxid1_2 Hs1s2 Hm1a.
rewrite -> Hm1a in eq_opt_zero_map.
pose proof (eq_eval_opt_add_zero m1 m2 ops fresh_var c H eq_opt_zero_map)
  as Hall_elem_eval_same_m1_m2.
simpl. rewrite -> Hh1h2. rewrite -> Hs1s2.
destruct (length c =? h2); try reflexivity.
apply eq_eval_elem_stack. assumption.
Qed.



Lemma opt_add_zero_same_fvar_in_maps: forall (n: nat)
  (m1 m2: asfs_map),
optimize_map_add_zero n m1 = Some m2 ->
same_fvar_in_maps m1 m2.
Proof.
intros n m1. revert n.
induction m1 as [| h t IH].
- intros n m2 Hopt. simpl in Hopt. discriminate.
- intros n m2 Hopt.
  simpl in Hopt.
  destruct h as [fvar efvar] eqn: eq_h.
  destruct (fvar =? n) eqn: eq_fvar_n.
  + destruct efvar eqn: eq_efvar; try discriminate.
    destruct opcode eqn: eq_opcode; try discriminate.
    destruct args as [| arg1 targs1] eqn: eq_args; try discriminate.
    destruct targs1 as [| arg2 targs2] eqn: eq_args1; try discriminate.
    destruct targs2 eqn: eq_args2; try discriminate.
    destruct (stack_val_has_value arg1 WZero).
    * injection Hopt as eq_m2. rewrite <- eq_m2.
      simpl. split; try reflexivity.
      apply same_fvar_refl.
    * destruct (stack_val_has_value arg2 WZero); try discriminate.
      injection Hopt as eq_m2. rewrite <- eq_m2.
      simpl. split; try reflexivity.
      apply same_fvar_refl.
  + destruct (optimize_map_add_zero n t) as [t_opt|] eqn: optimize_t;
      try discriminate.
    pose proof (strictly_decreasing_preserv fvar efvar t) 
      as Hdecr_t.
    pose proof (IH n t_opt optimize_t).
    simpl. injection Hopt as eq_m2. rewrite <- eq_m2.
    split; try reflexivity. assumption.
Qed.



Lemma opt_add_zero_decreasingness_preservation: forall (n: nat)
  (m1 m2: asfs_map),
strictly_decreasing_map m1 ->
optimize_map_add_zero n m1 = Some m2 ->
strictly_decreasing_map m2.
Proof.
intros.
apply opt_add_zero_same_fvar_in_maps in H0.
apply same_fvar_in_map_preserves_decreasingness with (m1:=m1);
  try assumption.
Qed.


(* This is the main ADD_0 optimization *)
Definition optimize_add_zero (a: asfs) : asfs*bool :=
optimize_fresh_var optimize_add_zero_fvar a.


Lemma optimize_add_zero_fvar_safe:
safe_optimization_fvar optimize_add_zero_fvar.
Proof.
unfold safe_optimization_fvar. intros.
assert (opmap ADD = Some (Op true 2 add)) as Hopmap_add; try reflexivity.
pose proof (optimize_add_zero_fvar_eq a opt_a n c opmap Hopmap_add H0)
  as Heq_eval_a_opta.
rewrite -> Heq_eval_a_opta in H.
rewrite -> H.
split; try reflexivity.
destruct opt_a as [hopt maxopt sopt mopt] eqn: eq_opt_a.
simpl.
destruct a as [ha maxa sa ma] eqn: eq_a.
simpl in H1. simpl in H0.
destruct (optimize_map_add_zero n ma) eqn: optimize_ma; try discriminate.
injection H0 as eq_h eq_max eq_stack eq_maps. 
rewrite -> eq_maps in optimize_ma.
apply opt_add_zero_decreasingness_preservation with (n:=n) (m1:=ma);
  try assumption.
Qed.


Theorem optimize_add_zero_safe:
safe_optimization optimize_add_zero.
Proof.
apply optimize_fresh_var_preservation.
apply optimize_add_zero_fvar_safe.
Qed.




(****************************************** 
  Optimization MUL(1,X) or MUL(X,1) --> X 
*******************************************)
Fixpoint optimize_map_mul_one (fresh_var: nat) (map: asfs_map): 
  option asfs_map :=
match map with
| [] => None
| (n, val)::t => if n =? fresh_var then
                 match val with
                 | ASFSOp MUL [arg1; arg2] => 
                     if stack_val_has_value arg1 WOne then
                       Some ((n, ASFSBasicVal arg2)::t)
                     else if stack_val_has_value arg2 WOne then
                       Some ((n, ASFSBasicVal arg1)::t)
                     else None
                 | _ => None
                 end
                 else match optimize_map_mul_one fresh_var t with 
                      | None => None
                      | Some map' => Some ((n, val)::map')
                      end
end.

Definition optimize_mul_one_fvar (fresh_var: nat) (s: asfs) : option asfs :=
optimize_func_map optimize_map_mul_one fresh_var s.

Search wmult.
Lemma word_mul_1_x_is_x: forall (x: EVMWord),
mul [WOne; x] = Some x.
Proof.
intros x. simpl.
rewrite -> wmult_unit. reflexivity.
Qed.

Lemma word_mul_x_1_is_x: forall (x: EVMWord),
mul [x; WOne] = Some x.
Proof.
intros x. simpl.
rewrite -> wmult_comm. rewrite -> wmult_unit. 
reflexivity.
Qed.


(* Main lemma: every stack value is evaluated to the same value in the 
   original map and also in the optimized one for MUL_1 *)
Lemma eq_eval_opt_mul_one_eq: forall (m1 m2: asfs_map) (ops: opm) (n: nat)
  (stack: concrete_stack),
ops MUL = Some (Op true 2 mul) ->
optimize_map_mul_one n m1 = Some m2 ->
forall (elem: asfs_stack_val), eval_asfs2_elem stack elem m1 ops =
                               eval_asfs2_elem stack elem m2 ops.
Proof.
induction m1 as [|h t IH].
- intros. simpl in H0. discriminate.
- intros. simpl in H0. destruct h as [hn hv] eqn: eq_h.
  destruct (hn =? n) eqn: eq_hn_n.
  + (* We have found the fresh variable to optimize in the map *) 
    destruct (hv) as [basicval|opval] eqn: eq_hv. 
    * discriminate.
    * destruct (opval) eqn: eq_opval; try discriminate.
      destruct args as [| arg1 ta]; try discriminate.
      destruct ta as [| arg2 tta]; try discriminate.
      destruct tta; try discriminate.
      destruct (stack_val_has_value arg1 WOne) eqn: eq_arg1_one.
      -- (* arg1 is WOne *)
         injection H0 as eq_m2. rewrite <- eq_m2.
         destruct elem as [val|var|fvar] eqn: eq_elem.
         ++ apply eval_value.
         ++ apply eval_var.
         ++ unfold eval_asfs2_elem. destruct (hn =? fvar) eqn: eq_vame_fvar.
            ** rewrite -> H. simpl. fold eval_asfs2_elem.
               rewrite -> stack_val_has_value_eval with (v:=WOne);
                 try assumption.
               destruct (eval_asfs2_elem stack arg2 t ops) as [arg2_val|]
                 eqn: eq_eval_arg2; try reflexivity.
               rewrite -> word_mul_1_x_is_x. reflexivity.
            ** fold eval_asfs2_elem. reflexivity.
      -- (* arg2 is One *)
         destruct (stack_val_has_value arg2 WOne) eqn: eq_arg2_one;
           try discriminate.
         injection H0 as eq_m2. rewrite <- eq_m2.
         destruct elem as [val|var|fvar] eqn: eq_elem.
         ++ apply eval_value.
         ++ apply eval_var.
         ++ unfold eval_asfs2_elem. destruct (hn =? fvar) eqn: eq_vame_fvar.
            ** rewrite -> H. simpl. fold eval_asfs2_elem.
               destruct (eval_asfs2_elem stack arg1 t ops) as [arg1_val|]
                 eqn: eq_eval_arg2; try reflexivity.
               rewrite -> stack_val_has_value_eval with (v:=WOne);
                 try assumption.
               rewrite -> word_mul_x_1_is_x.
               reflexivity.
            ** fold eval_asfs2_elem. reflexivity.
  + (* This is not yet the fresh variable to optimize*) 
    destruct (optimize_map_mul_one n t) as [map'|] eqn: eq_optimize_t; 
      try discriminate.
    injection H0 as H0. rewrite <- H0. 
    destruct elem as [val|var|fvar] eqn: eq_elem; try reflexivity.
    simpl. destruct (hn =? fvar) eqn: eq_hn_fvar.
    * destruct hv eqn: eq_hv.
      -- apply IH with (n:=n); try assumption.
      -- rewrite -> eval_asfs2_ho. rewrite -> eval_asfs2_ho.
         pose proof (IH map' ops n stack H eq_optimize_t) as IHc.
         pose proof (eq_eval_elem_stack stack t map' ops args IHc) as
           eq_eval_t_map'.
         rewrite -> eq_eval_t_map'. reflexivity.
    * apply IH with (n:=n); try assumption.
Qed.


Theorem optimize_mul_one_eq: forall (a1 a2: asfs) (fresh_var: nat)
  (c: concrete_stack) (ops: opm),
ops MUL = Some (Op true 2 mul) ->
optimize_mul_one_fvar fresh_var a1 = Some a2 ->
eval_asfs c a1 ops = eval_asfs c a2 ops.
Proof.
intros.
destruct a1 as [h1 maxid1 s1 m1] eqn: eq_a1.
destruct a2 as [h2 maxid2 s2 m2] eqn: eq_a2.
simpl in H0.
destruct (optimize_map_mul_one fresh_var m1) eqn: eq_opt_mul_one_map;
  try discriminate.
injection H0 as Hh1h2 Hmaxid1_2 Hs1s2 Hm1a.
rewrite -> Hm1a in eq_opt_mul_one_map.
pose proof (eq_eval_opt_mul_one_eq m1 m2 ops fresh_var c H eq_opt_mul_one_map)
  as Hall_elem_eval_same_m1_m2.
simpl. rewrite -> Hh1h2. rewrite -> Hs1s2.
destruct (length c =? h2); try reflexivity.
apply eq_eval_elem_stack. assumption.
Qed.


Lemma opt_mul_one_same_fvar_in_maps: forall (n: nat)
  (m1 m2: asfs_map),
optimize_map_mul_one n m1 = Some m2 ->
same_fvar_in_maps m1 m2.
Proof.
intros n m1. revert n.
induction m1 as [| h t IH].
- intros n m2 Hopt. simpl in Hopt. discriminate.
- intros n m2 Hopt.
  simpl in Hopt.
  destruct h as [fvar efvar] eqn: eq_h.
  destruct (fvar =? n) eqn: eq_fvar_n.
  + destruct efvar eqn: eq_efvar; try discriminate.
    destruct opcode eqn: eq_opcode; try discriminate.
    destruct args as [| arg1 targs1] eqn: eq_args; try discriminate.
    destruct targs1 as [| arg2 targs2] eqn: eq_args1; try discriminate.
    destruct targs2 eqn: eq_args2; try discriminate.
    destruct (stack_val_has_value arg1 WOne).
    * injection Hopt as eq_m2. rewrite <- eq_m2.
      simpl. split; try reflexivity.
      apply same_fvar_refl.
    * destruct (stack_val_has_value arg2 WOne); try discriminate.
      injection Hopt as eq_m2. rewrite <- eq_m2.
      simpl. split; try reflexivity.
      apply same_fvar_refl.
  + destruct (optimize_map_mul_one n t) as [t_opt|] eqn: optimize_t;
      try discriminate.
    pose proof (strictly_decreasing_preserv fvar efvar t) 
      as Hdecr_t.
    pose proof (IH n t_opt optimize_t).
    simpl. injection Hopt as eq_m2. rewrite <- eq_m2.
    split; try reflexivity. assumption.
Qed.


Lemma opt_mul_one_decreasingness_preservation: forall (n: nat)
  (m1 m2: asfs_map),
strictly_decreasing_map m1 ->
optimize_map_mul_one n m1 = Some m2 ->
strictly_decreasing_map m2.
Proof.
intros.
apply opt_mul_one_same_fvar_in_maps in H0.
apply same_fvar_in_map_preserves_decreasingness with (m1:=m1);
  try assumption.
Qed.


(* This is the main MUL_1 optimization *)
Definition optimize_mul_one (a: asfs) : asfs*bool :=
optimize_fresh_var optimize_mul_one_fvar a.


Lemma optimize_mul_one_fvar_safe:
safe_optimization_fvar optimize_mul_one_fvar.
Proof.
unfold safe_optimization_fvar. intros.
assert (opmap MUL = Some (Op true 2 mul)) as Hopmap_mul; try reflexivity.
pose proof (optimize_mul_one_eq a opt_a n c opmap Hopmap_mul H0)
  as Heq_eval_a_opta.
rewrite -> Heq_eval_a_opta in H.
rewrite -> H.
split; try reflexivity.
destruct opt_a as [hopt maxopt sopt mopt] eqn: eq_opt_a.
simpl.
destruct a as [ha maxa sa ma] eqn: eq_a.
simpl in H1. simpl in H0.
destruct (optimize_map_mul_one n ma) eqn: optimize_ma; try discriminate.
injection H0 as eq_h eq_max eq_stack eq_maps. 
rewrite -> eq_maps in optimize_ma.
apply opt_mul_one_decreasingness_preservation with (n:=n) (m1:=ma);
  try assumption.
Qed.


Theorem optimize_mul_one_safe:
safe_optimization optimize_mul_one.
Proof.
apply optimize_fresh_var_preservation.
apply optimize_mul_one_fvar_safe.
Qed.






(*****************************************
  Optimization MUL(0,X) or MUL(X,0) --> 0
******************************************)
Fixpoint optimize_map_mul_zero (fresh_var: nat) (map: asfs_map): 
  option asfs_map :=
match map with
| [] => None
| (n, val)::t => if n =? fresh_var then
                 match val with
                 | ASFSOp MUL [arg1; arg2] => 
                     if stack_val_has_value arg1 WZero then
                       Some ((n, ASFSBasicVal (Val WZero))::t)
                     else if stack_val_has_value arg2 WZero then
                       Some ((n, ASFSBasicVal (Val WZero))::t)
                     else None
                 | _ => None
                 end
                 else match optimize_map_mul_zero fresh_var t with 
                      | None => None
                      | Some map' => Some ((n, val)::map')
                      end
end.

Definition optimize_mul_zero_fvar (fresh_var: nat) (s: asfs) : option asfs :=
optimize_func_map optimize_map_mul_zero fresh_var s.

(* THIS IS THE MAIN MUL_0 OPTIMIZATION *)
Definition optimize_mul_zero : (asfs -> asfs*bool) :=
optimize_fresh_var optimize_mul_zero_fvar.


Lemma word_mul_0_x_is_0: forall (x: EVMWord),
mul [WZero; x] = Some WZero.
Proof.
intros x. simpl.
rewrite -> wmult_neut_l. reflexivity.
Qed.

Lemma word_mul_x_0_is_0: forall (x: EVMWord),
mul [x; WZero] = Some WZero.
Proof.
intros x. simpl.
rewrite -> wmult_neut_r. reflexivity.
Qed.


(* Main lemma: if a stack value is evaluated to a value in the original map
   then it is evaluated to the same value in the optimized map for MUL_0.
   
   NOTICE that MUL(ill-defined-value, 0) is evaluated to None in the original
   map but MUL(ill-defined-value, 0) ~~> 0 is evaluated to 0 in the optimized
   one, so THEY ARE NOT EQUAL FOR EVERY POSSIBLE stack_val *)
Lemma eq_succ_eval_opt_mul_zero: forall (m1 m2: asfs_map) (ops: opm) (n: nat)
  (stack: concrete_stack),
ops MUL = Some (Op true 2 mul) ->
optimize_map_mul_zero n m1 = Some m2 ->
forall (elem: asfs_stack_val) (v: EVMWord), 
  eval_asfs2_elem stack elem m1 ops = Some v ->
  eval_asfs2_elem stack elem m2 ops = Some v.
Proof.
induction m1 as [|h t IH].
- intros. simpl in H0. discriminate.
- intros. simpl in H0. destruct h as [hn hv] eqn: eq_h.
  destruct (hn =? n) eqn: eq_hn_n.
  + (* We have found the fresh variable to optimize in the map *) 
    destruct (hv) as [basicval|opval] eqn: eq_hv. 
    * discriminate.
    * destruct (opval) eqn: eq_opval; try discriminate.
      destruct args as [| arg1 ta]; try discriminate.
      destruct ta as [| arg2 tta]; try discriminate.
      destruct tta; try discriminate.
      destruct (stack_val_has_value arg1 WZero) eqn: eq_arg1_zero.
      -- (* arg1 is WZero *)
         injection H0 as eq_m2. rewrite <- eq_m2.
         destruct elem as [val|var|fvar] eqn: eq_elem.
         ++ rewrite -> eval_value in H1. injection H1 as H1.
            rewrite <- H1.
            rewrite -> eval_value. reflexivity.
         ++ pose proof (eval_var stack var ((hn, ASFSOp MUL [arg1; arg2]) :: t)
             ((hn, ASFSBasicVal (Val WZero)) :: t) ops) as Hsameeval.
            rewrite <- Hsameeval. assumption.
         ++ unfold eval_asfs2_elem. destruct (hn =? fvar) eqn: eq_vame_fvar.
            ** fold eval_asfs2_elem. simpl in H1.
               rewrite -> eq_vame_fvar in H1. rewrite -> H in H1.
               pose proof (stack_val_has_value_eval stack arg1 WZero t ops
                 eq_arg1_zero) as eq_eval_arg1.
               rewrite -> eq_eval_arg1 in H1.
               destruct (eval_asfs2_elem stack arg2 t ops) as [arg2_val|]
                 eqn: eq_eval_arg2; try discriminate.
               rewrite -> word_mul_0_x_is_0 in H1.
               injection H1 as H1. rewrite <- H1.
               destruct t; try reflexivity.
            ** fold eval_asfs2_elem. simpl in H1. rewrite -> eq_vame_fvar in H1.
               assumption.
      -- (* arg2 is WZero *)
         destruct (stack_val_has_value arg2 WZero) eqn: eq_arg2_zero;
           try discriminate.
         injection H0 as eq_m2. rewrite <- eq_m2.
         destruct elem as [val|var|fvar] eqn: eq_elem.
         ++ rewrite -> eval_value in H1. injection H1 as H1.
            rewrite <- H1.
            rewrite -> eval_value. reflexivity.
         ++ pose proof (eval_var stack var ((hn, ASFSOp MUL [arg1; arg2]) :: t)
             ((hn, ASFSBasicVal (Val WZero)) :: t) ops) as Hsameeval.
            rewrite <- Hsameeval. assumption.
         ++ unfold eval_asfs2_elem. destruct (hn =? fvar) eqn: eq_vame_fvar.
            ** fold eval_asfs2_elem. simpl in H1.
               rewrite -> eq_vame_fvar in H1. rewrite -> H in H1.
               destruct (eval_asfs2_elem stack arg1 t ops) as [arg1_val|]
                 eqn: eq_eval_arg1; try discriminate.
                pose proof (stack_val_has_value_eval stack arg2 WZero t ops
                 eq_arg2_zero) as eq_eval_arg2.
               rewrite -> eq_eval_arg2 in H1.
               rewrite -> word_mul_x_0_is_0 in H1.
               injection H1 as H1. rewrite <- H1.
               destruct t; try reflexivity.
            ** fold eval_asfs2_elem. simpl in H1. rewrite -> eq_vame_fvar in H1.
               assumption.
  + (* This is not yet the fresh variable to optimize*) 
    destruct (optimize_map_mul_zero n t) as [map'|] eqn: eq_optimize_t; 
      try discriminate.
    injection H0 as H0. rewrite <- H0. 
    destruct elem as [val|var|fvar] eqn: eq_elem.
    * rewrite -> eval_value. rewrite -> eval_value in H1. assumption.
    * pose proof (eval_var stack var ((hn, hv) :: t) ((hn, hv) :: map')
        ops) as eq_eval_instack.
      rewrite <- eq_eval_instack. assumption.
    * simpl. simpl in H1. destruct (hn =? fvar) eqn: eq_hn_fvar.
      -- destruct hv eqn: eq_hv.
         ++ apply IH with (n:=n); try assumption.
         ++ destruct (ops opcode) as [ops_val|] eqn: eq_ops_opcode; 
              try discriminate.
            destruct (ops_val) as [comm nargs func] eqn: eq_opval.
            destruct (length args =? nargs); try discriminate.
            rewrite -> eval_asfs2_ho in H1. rewrite -> eval_asfs2_ho.
            pose proof (IH map' ops n stack H eq_optimize_t) as
              eq_succ_eval_elem_t_map'.
            destruct (eval_asfs2 stack args t ops) as [vargs|] 
              eqn: eq_eval_args; try discriminate.
            pose proof (eq_succ_eval_elem_stack stack vargs t map' ops args
              eq_succ_eval_elem_t_map' eq_eval_args) as IHc.
            rewrite -> IHc. assumption.
      -- pose proof (IH map' ops n stack H eq_optimize_t (FreshVar fvar) v
           H1) as eq_succ_eval_elem_t_map'.
         rewrite -> eq_succ_eval_elem_t_map'.
         reflexivity.
Qed.


Theorem optimize_mul_zero_safe_success: forall (a1 a2: asfs) (fresh_var: nat)
  (c s: concrete_stack) (ops: opm),
ops MUL = Some (Op true 2 mul) ->
optimize_mul_zero_fvar fresh_var a1 = Some a2 ->
eval_asfs c a1 ops = Some s ->
eval_asfs c a2 ops = Some s.
Proof.
intros.
destruct a1 as [h1 maxid1 s1 m1] eqn: eq_a1.
destruct a2 as [h2 maxid2 s2 m2] eqn: eq_a2.
simpl in H0.
destruct (optimize_map_mul_zero fresh_var m1) eqn: eq_opt_mul_zero_map;
  try discriminate.
injection H0 as Hh1h2 Hmaxid1_2 Hs1s2 Hm1a.
rewrite -> Hm1a in eq_opt_mul_zero_map.
pose proof (eq_succ_eval_opt_mul_zero m1 m2 ops fresh_var c H eq_opt_mul_zero_map)
  as Hall_elem_succ_eval_same_m1_m2.
simpl. rewrite <- Hh1h2. rewrite <- Hs1s2.
simpl in H1. destruct (length c =? h1); try discriminate.
apply eq_succ_eval_elem_stack with (m1:=m1); try assumption.
Qed.


Lemma opt_mul_zero_same_fvar_in_maps: forall (n: nat)
  (m1 m2: asfs_map),
optimize_map_mul_zero n m1 = Some m2 ->
same_fvar_in_maps m1 m2.
Proof.
intros n m1. revert n.
induction m1 as [| h t IH].
- intros n m2 Hopt. simpl in Hopt. discriminate.
- intros n m2 Hopt.
  simpl in Hopt.
  destruct h as [fvar efvar] eqn: eq_h.
  destruct (fvar =? n) eqn: eq_fvar_n.
  + destruct efvar eqn: eq_efvar; try discriminate.
    destruct opcode eqn: eq_opcode; try discriminate.
    destruct args as [| arg1 targs1] eqn: eq_args; try discriminate.
    destruct targs1 as [| arg2 targs2] eqn: eq_args1; try discriminate.
    destruct targs2 eqn: eq_args2; try discriminate.
    destruct (stack_val_has_value arg1 WZero).
    * injection Hopt as eq_m2. rewrite <- eq_m2.
      simpl. split; try reflexivity.
      apply same_fvar_refl.
    * destruct (stack_val_has_value arg2 WZero); try discriminate.
      injection Hopt as eq_m2. rewrite <- eq_m2.
      simpl. split; try reflexivity.
      apply same_fvar_refl.
  + destruct (optimize_map_mul_zero n t) as [t_opt|] eqn: optimize_t;
      try discriminate.
    pose proof (strictly_decreasing_preserv fvar efvar t) 
      as Hdecr_t.
    pose proof (IH n t_opt optimize_t).
    simpl. injection Hopt as eq_m2. rewrite <- eq_m2.
    split; try reflexivity. assumption.
Qed.


Lemma opt_mul_zero_decreasingness_preservation: forall (n: nat)
  (m1 m2: asfs_map),
strictly_decreasing_map m1 ->
optimize_map_mul_zero n m1 = Some m2 ->
strictly_decreasing_map m2.
Proof.
intros.
apply opt_mul_zero_same_fvar_in_maps in H0.
apply same_fvar_in_map_preserves_decreasingness with (m1:=m1);
  try assumption.
Qed.



Theorem optimize_mul_zero_fvar_safe: 
safe_optimization_fvar optimize_mul_zero_fvar.
Proof.
unfold safe_optimization_fvar. intros.
split.
- apply optimize_mul_zero_safe_success with (a1:=a) (fresh_var:=n); 
    try intuition.
- destruct opt_a as [hopt maxopt sopt mopt] eqn: eq_opt_a.
  simpl.
  destruct a as [ha maxa sa ma] eqn: eq_a.
  simpl in H1. simpl in H0.
  destruct (optimize_map_mul_zero n ma) eqn: optimize_ma; try discriminate.
  injection H0 as eq_h eq_max eq_stack eq_maps. 
  rewrite -> eq_maps in optimize_ma.
  apply opt_mul_zero_decreasingness_preservation with (n:=n) (m1:=ma);
    try assumption.
Qed.

Theorem optimize_mul_zero_safe: 
safe_optimization optimize_mul_zero.
Proof.
apply optimize_fresh_var_preservation.
apply optimize_mul_zero_fvar_safe.
Qed.






(*****************************************
  Optimization NOT(NOT(X)) --> X
******************************************)
Fixpoint optimize_map_not_not (fresh_var: nat) (map: asfs_map): 
  option asfs_map :=
match map with
| [] => None
| (n, val)::t => if n =? fresh_var then
                 match val with
                 | ASFSOp NOT [arg] => 
                     match stack_val_is_oper NOT arg t with 
                     | Some [arg'] => Some ((n, ASFSBasicVal arg')::t)
                     | _ => None
                     end
                 | _ => None
                 end
                 else match optimize_map_not_not fresh_var t with 
                      | None => None
                      | Some map' => Some ((n, val)::map')
                      end
end.


(* Counterexample for the NOT_NOT optimization with an arbitrary map with
   repetitions *)
Example counterexample_notnot_any_ASFS:
let map: asfs_map := [(100, ASFSOp NOT [FreshVar 75]); 
                      (50,  ASFSBasicVal (Val WZero));
                      (75,  ASFSOp NOT [FreshVar 50]);
                      (50,  ASFSBasicVal (Val WOne))] in
let opt_map: asfs_map := [(100, ASFSBasicVal (FreshVar 50)); 
                          (50,  ASFSBasicVal (Val WZero));
                          (75,  ASFSOp NOT [FreshVar 50]);
                          (50,  ASFSBasicVal (Val WOne))] in
let some_map2 := optimize_map_not_not 100 map in
eval_asfs2_elem [] (FreshVar 100) map opmap = Some WOne /\
some_map2 = Some opt_map /\
eval_asfs2_elem [] (FreshVar 100) opt_map opmap = Some WZero.
Proof.
split; try (split; reflexivity).
Qed.


Definition optimize_not_not_fvar (fresh_var: nat) (s: asfs) : option asfs :=
optimize_func_map optimize_map_not_not fresh_var s.

(* THIS IS THE MAIN NOT_NOT OPTIMIZATION *)
Definition optimize_not_not : (asfs -> asfs*bool) :=
optimize_fresh_var optimize_not_not_fvar.


Lemma wnot_idempotent: forall {sz : nat} (w : word sz), wnot (wnot w) = w.
Proof.
intros. induction w.
- reflexivity.
- simpl. rewrite <- negb_involutive_reverse.
  rewrite -> IHw.
  reflexivity.
Qed.


(* Main lemma: every stack value is evaluated to the same value in the 
   original map and also in the optimized one for NOT_NOT *)
Lemma eq_succ_eval_opt_not_not_eq: forall (m1 m2: asfs_map) (ops: opm) (n: nat)
  (stack: concrete_stack),
ops NOT = Some (Op false 1 not) ->
optimize_map_not_not n m1 = Some m2 ->
strictly_decreasing_map m1 ->
forall (elem: asfs_stack_val) (v: EVMWord), 
  eval_asfs2_elem stack elem m1 ops = Some v ->
  eval_asfs2_elem stack elem m2 ops = Some v.
Proof.
induction m1 as [|h t IH].
- intros. simpl in H0. discriminate H0.
- intros m2 ops n stack Hops_not Hopt_m1 Hdecreasing_m1 elem v. 
  simpl in Hopt_m1. destruct h as [hn hv] eqn: eq_h.
  destruct (hn =? n) eqn: eq_hn_n.
  + (* We have found the fresh variable to optimize in the map *) 
    destruct (hv) as [basicval|opval] eqn: eq_hv. 
    * discriminate Hopt_m1.
    * destruct (opval) eqn: eq_opval; try discriminate.
      destruct args as [| arg1 ta]; try discriminate.
      destruct ta; try discriminate.
      destruct (stack_val_is_oper NOT arg1 t) as [inner_args|] 
        eqn: eq_arg_is_NOT; try discriminate.
      destruct inner_args as [| inner_arg inner_t] eqn: eq_inner_args;
        try discriminate.
      destruct inner_t eqn: eq_inner_t; try discriminate.
      injection Hopt_m1 as eq_m2. rewrite <- eq_m2.
      destruct elem as [val|var|fvar] eqn: eq_elem.
      -- rewrite -> eval_value. rewrite -> eval_value. intuition.
      -- rewrite -> eval_var with (m2 := ((hn, ASFSBasicVal inner_arg) :: t)). 
         intuition. 
      -- intros Heval_in_m1. 
         unfold eval_asfs2_elem. unfold eval_asfs2_elem in Heval_in_m1. 
         destruct (hn =? fvar) eqn: eq_vame_fvar.
         ++ fold eval_asfs2_elem. 
            rewrite -> Hops_not in Heval_in_m1. simpl in Heval_in_m1.
            fold eval_asfs2_elem in Heval_in_m1.
            destruct (eval_asfs2_elem stack arg1 t ops) eqn: eq_eval_arg1;
              try discriminate.
            pose proof (evaluation_sufix_map t 1 arg1 [inner_arg] false not
              e NOT ops stack eq_arg_is_NOT Hops_not eq_eval_arg1)
              as [prefix [suffix [inner_vals [eq_t_prefix [eq_eval_inner_arg
                 Hnot_inner]]]]].
              pose proof (strictly_decreasing_preserv hn (ASFSOp NOT [arg1])
                t Hdecreasing_m1) as Hdecreasing_t.
              pose proof (eval_bigger_decreasing_map stack inner_vals 
                [inner_arg] prefix suffix t ops eq_eval_inner_arg
              eq_t_prefix Hdecreasing_t) as eq_eval_inner_arg_t.
              unfold eval_asfs2 in eq_eval_inner_arg_t. 
              simpl in eq_eval_inner_arg_t.
              destruct (eval_asfs2_elem stack inner_arg t ops) as
                [inner_val|] eqn: eq_eval_inner_t; try discriminate.
              injection eq_eval_inner_arg_t as eq_inner_vals.
              rewrite <- eq_inner_vals in Hnot_inner.
              simpl in Hnot_inner. injection Hnot_inner as eq_e_not.
              simpl in Heval_in_m1. injection Heval_in_m1 as eq_v.
              rewrite <- eq_e_not in eq_v.
              rewrite -> wnot_idempotent in eq_v.
              rewrite -> eq_v.
              reflexivity.
         ++ fold eval_asfs2_elem in Heval_in_m1. fold eval_asfs2_elem. 
            assumption.
  + (* This is not yet the fresh variable to optimize*)
    destruct (optimize_map_not_not n t) as [map'|] eqn: eq_optimize_t; 
      try discriminate.
    injection Hopt_m1 as Hopt_m1. rewrite <- Hopt_m1. 
    destruct elem as [val|var|fvar] eqn: eq_elem.
    * rewrite -> eval_value. rewrite -> eval_value. intuition.
    * rewrite -> eval_var with (m2 := ((hn, hv) :: map')). intuition.
    * intros Heval_in_m1. 
      simpl. simpl in Heval_in_m1. 
      destruct (hn =? fvar) eqn: eq_hn_fvar.
      -- destruct hv eqn: eq_hv.
         ++ apply IH with (n:=n); try assumption.
            apply strictly_decreasing_preserv with (n:=hn) 
              (v:=ASFSBasicVal val). assumption.
         ++ destruct (ops opcode) as [ops_val|] eqn: eq_ops_opcode; 
              try discriminate.
            destruct (ops_val) as [comm nargs func] eqn: eq_opval.
            destruct (length args =? nargs); try discriminate.
            rewrite -> eval_asfs2_ho in Heval_in_m1. 
            rewrite -> eval_asfs2_ho.
            pose proof (strictly_decreasing_preserv hn (ASFSOp opcode args)
              t Hdecreasing_m1) as Hstrictly_decreasing_t.
            pose proof (IH map' ops n stack Hops_not eq_optimize_t
              Hstrictly_decreasing_t) as eq_succ_eval_elem_t_map'.
            destruct (eval_asfs2 stack args t ops) as [vargs|] 
              eqn: eq_eval_args; try discriminate.
            pose proof (eq_succ_eval_elem_stack stack vargs t map' ops args
              eq_succ_eval_elem_t_map' eq_eval_args) as IHc.
            rewrite -> IHc. assumption.
      -- pose proof (strictly_decreasing_preserv hn hv t Hdecreasing_m1) 
           as Hstrictly_decreasing_t.
         pose proof (IH map' ops n stack Hops_not eq_optimize_t 
           Hstrictly_decreasing_t (FreshVar fvar) v Heval_in_m1) 
           as eq_succ_eval_elem_t_map'.
         rewrite -> eq_succ_eval_elem_t_map'.
         reflexivity.
Qed.


Lemma eq_succ_eval_opt_not_not_eq_abs: forall (m1 m2: asfs_map) (ops: opm) 
  (n: nat) (stack: concrete_stack),
ops NOT = Some (Op false 1 not) ->
optimize_map_not_not n m1 = Some m2 ->
strictly_decreasing_map m1 ->
forall (abs: asfs_stack) (v: concrete_stack), 
  eval_asfs2 stack abs m1 ops = Some v ->
  eval_asfs2 stack abs m2 ops = Some v.
Proof.
induction abs as [| h t IH].
- intros. unfold eval_asfs2 in H2. simpl in H2. 
  unfold eval_asfs2. simpl. assumption.
- intros. 
  pose proof (eval_asfs2_cons h t m1 ops stack v H2) 
    as [hval [tval [eq_v [eval_h_m1 eval_t_m1]]]].
  pose proof (eq_succ_eval_opt_not_not_eq m1 m2 ops n stack H H0 H1 h hval
    eval_h_m1) as eval_h_m2.
  pose proof (IH tval eval_t_m1) as eval_t_m2.
  rewrite -> eq_v.
  apply eval_asfs2_cons_r; try assumption.
Qed.


Lemma opt_not_not_same_fvar_in_maps: forall (n: nat)
  (m1 m2: asfs_map),
optimize_map_not_not n m1 = Some m2 ->
same_fvar_in_maps m1 m2.
Proof.
intros n m1. revert n.
induction m1 as [| h t IH].
- intros n m2 Hopt. simpl in Hopt. discriminate.
- intros n m2 Hopt.
  simpl in Hopt.
  destruct h as [fvar efvar] eqn: eq_h.
  destruct (fvar =? n) eqn: eq_fvar_n.
  + destruct efvar eqn: eq_efvar; try discriminate.
    destruct opcode eqn: eq_opcode; try discriminate.
    destruct args as [| arg1 targs1] eqn: eq_args; try discriminate.
    destruct targs1 as [| arg2 targs2] eqn: eq_args1; try discriminate.
    destruct (stack_val_is_oper NOT arg1 t) as [inner_args|]; 
      try discriminate.
    destruct inner_args as [|arg' t_inner_args] eqn: eq_inner_args;
      try discriminate.
    destruct (t_inner_args) as [| ttt] eqn: eq_t_inner_args;
      try discriminate.
    injection Hopt as eq_m2. rewrite <- eq_m2.
    simpl. split; try reflexivity.
    apply same_fvar_refl.
  + destruct (optimize_map_not_not n t) as [t_opt|] eqn: optimize_t;
      try discriminate.
    pose proof (strictly_decreasing_preserv fvar efvar t) 
      as Hdecr_t.
    pose proof (IH n t_opt optimize_t).
    simpl. injection Hopt as eq_m2. rewrite <- eq_m2.
    split; try reflexivity. assumption.
Qed.


Lemma opt_not_not_decreasingness_preservation: forall (n: nat)
  (m1 m2: asfs_map),
strictly_decreasing_map m1 ->
optimize_map_not_not n m1 = Some m2 ->
strictly_decreasing_map m2.
Proof.
intros.
apply opt_not_not_same_fvar_in_maps in H0.
apply same_fvar_in_map_preserves_decreasingness with (m1:=m1);
  try assumption.
Qed.



Lemma optimize_not_not_fvar_safe:
safe_optimization_fvar optimize_not_not_fvar.
Proof.
unfold safe_optimization_fvar. intros.
unfold eval_asfs in H.
destruct a as [ha maxa absa ma] eqn: eq_a.
destruct opt_a as [hopt maxopt absopt mopt] eqn: eq_opt_a.
destruct (length c =? ha) eqn: eq_len; try discriminate.
assert (opmap NOT = Some (Op false 1 not)) as eq_opmap_NOT; try reflexivity.
simpl in H0. destruct (optimize_map_not_not n ma) as [ma' |] 
  eqn: eq_optmize_ma; try discriminate.
injection H0 as eq_h eq_max eq_abs eq_m.
rewrite -> eq_m in eq_optmize_ma.
simpl in H1.
pose proof (eq_succ_eval_opt_not_not_eq_abs ma mopt opmap n c eq_opmap_NOT
  eq_optmize_ma H1).
simpl. rewrite <- eq_h. rewrite -> eq_len.
apply H0 in H. rewrite -> eq_abs in H.
split.
- apply H. 
- apply opt_not_not_decreasingness_preservation with (n:=n) (m1:=ma);
    try assumption.
Qed.

Theorem optimize_not_not_safe:
safe_optimization optimize_not_not.
Proof.
apply optimize_fresh_var_preservation.
apply optimize_not_not_fvar_safe.
Qed.






(***************************************
Application of a list of optimizations
****************************************)

(* Applies the optimization 'n' times. Always returns 'true' *) 
Fixpoint apply_n_times (opt: optimization) (n: nat) (a: asfs) : asfs*bool :=
match n with
| 0 => (a, true)
| S n' => match opt a with
          | (a', _) => apply_n_times opt n' a'
          end
end.

Lemma safe_apply_n_times: forall (opt: optimization) (n: nat),
safe_optimization opt ->
safe_optimization (apply_n_times opt n).
Proof.
intros opt n. revert opt.
induction n as [| n' IH].
- intros. unfold safe_optimization. intros. 
  simpl in H1. injection H1 as eq_a_a' _. rewrite <- eq_a_a'. 
  split; try auto.
- intros. unfold safe_optimization. intros. 
  simpl in H1. destruct (opt a) as [a' flag] eqn: eq_opt_a.
  assert (Hcopy := H).
  unfold safe_optimization in H.
  pose proof (H c cf a a' flag H0 eq_opt_a H2) as 
   [Heval_a' Hstrictly_decr_a'].
  pose proof (IH opt Hcopy) as Hsafe_n'.
  unfold safe_optimization in Hsafe_n'.
  pose proof (Hsafe_n' c cf a' opt_a b Heval_a' H1 Hstrictly_decr_a').
  assumption.
Qed.


(* A pipeline of optimizations is safe if every optimization in the list 
   is safe (preserves succesful evaluations and decreasingness of the map *)
Definition safe_optimization_pipeline (l: list optimization) : Prop :=
Forall safe_optimization l.


(* Apply all the possible optimization functions in chain, always 
   returns true *)
Fixpoint apply_all_possible_opt (l_opt: list optimization) (a: asfs)
  : asfs*bool :=
match l_opt with
| nil => (a, true)
| opt::ropts => match opt a with
                | (a', _) => apply_all_possible_opt ropts a'
                end
end.

Theorem safe_apply_all_possible_opt: forall (l: list optimization),
safe_optimization_pipeline l -> 
safe_optimization (apply_all_possible_opt l).
Proof.
induction l as [|opt ropts IH].
- unfold safe_optimization. intros.
  simpl in H1. injection H1 as H1. 
  rewrite <- H1.
  split; try assumption.
- unfold safe_optimization. intros.
  unfold safe_optimization_pipeline in H.
  assert (Hcopy := H).
  apply Forall_inv in H.
  unfold safe_optimization_pipeline in IH.
  apply Forall_inv_tail in Hcopy.
  apply IH in Hcopy.
  unfold apply_all_possible_opt in H1.
  destruct (opt a) as [a1 flag] eqn: eq_opta.
  fold apply_all_possible_opt in H1.
  unfold safe_optimization in H.
  pose proof (H c cf a a1 flag H0 eq_opta H2) as [Heval_a1 Hstric_decr_a1].
  unfold safe_optimization in Hcopy.
  pose proof (Hcopy c cf a1 opt_a b Heval_a1 H1 Hstric_decr_a1).
  assumption.
Qed.


(* Applies the complete optimization pipeline 'n' times, each time trying
   to apply all the steps in order *)
Definition apply_pipeline_n_times (l_opt: list optimization) (n: nat) 
  (a: asfs) : asfs*bool :=
apply_n_times (apply_all_possible_opt l_opt) n a.


Theorem safe_apply_pipeline_n_times: forall (l: list optimization) (n: nat),
safe_optimization_pipeline l -> 
safe_optimization (apply_pipeline_n_times l n).
Proof.
intros.
apply safe_apply_all_possible_opt in H.
unfold apply_pipeline_n_times.
replace (fun a : asfs => apply_n_times (apply_all_possible_opt l) n a) with 
  (apply_n_times (apply_all_possible_opt l) n ) by auto.
  (* To remove the useless lambda expression using eta-conversion *)
apply safe_apply_n_times.
assumption.
Qed.

(* Apply the first optimization function possible, returns false only if 
   no optimization can be applied *)
Fixpoint apply_first_op (l_opt: list optimization) (a: asfs) : asfs*bool :=
match l_opt with
| nil => (a, false)
| opt::ropts => match opt a with
                | (a', true) => (a', true)
                | (_, false) => apply_first_op ropts a
                end
end.

Theorem apply_first_op_safety: forall (l: list optimization),
safe_optimization_pipeline l -> 
safe_optimization (apply_first_op l).
Proof.
induction l as [|opt ropts IH].
- unfold safe_optimization. intros.
  simpl in H1. injection H1 as eq_a_opta Hfalse.
  rewrite <- eq_a_opta. auto.
- unfold safe_optimization. intros.
  unfold safe_optimization_pipeline in H.
  assert (Hcopy := H).
  apply Forall_inv in H.
  unfold safe_optimization_pipeline in IH.
  apply Forall_inv_tail in Hcopy.
  apply IH in Hcopy.
  unfold apply_first_op in H1.
  destruct (opt a) as [a1 flag] eqn: eq_opta.
  destruct flag eqn: eq_flag.
  + unfold safe_optimization in H.
    pose proof (H c cf a a1 true H0 eq_opta H2).
    injection H1 as eqa1_opta.
    rewrite <- eqa1_opta.
    apply H3.
  + fold apply_first_op in H1.
    unfold safe_optimization in Hcopy.
    pose proof (Hcopy c cf a opt_a b H0 H1 H2).
    assumption.
Qed.

(*
  Enrique: X -> 0
  Better: X -> Y -> Z -> 0
*)




Definition our_optimization_pipeline := 
[optimize_add_zero; 
 optimize_mul_one; 
 optimize_mul_zero; 
 optimize_not_not].


Search Forall.
Theorem our_optimization_pipeline_is_safe: 
safe_optimization_pipeline our_optimization_pipeline.
Proof.
unfold safe_optimization_pipeline. 
apply Forall_cons; try apply optimize_add_zero_safe.
apply Forall_cons; try apply optimize_mul_one_safe.
apply Forall_cons; try apply optimize_mul_zero_safe.
apply Forall_cons; try apply optimize_not_not_safe.
apply Forall_nil.
Qed.



(*
Definition l_op := [optimize_add_zero_gen; optimize_add_mul1_gen, ....]

Theorem t: forall e \in l_op, ASFS a, 
  e a ops => Some a' ->
  eval_asfs a opmap = eval a' opmap
  
Definition opt_scheme (lopt: list optimizations) (a: ASFS) := ...

Theorem t: (l: list optimization)
l is subset of l_op ->
opt_scheme l a = Some a' ->
eval a opmap = eval a' opmap.

Definition checker (p1 p2: block) =
let asfs1 := symb_exec p1 opmap in
let asfs2 := symb_exec p2 opmap in
let opt_asfs1 := opt_scheme ([opt1; opt2;....]) a in
eq_asfs opt_asfs1  asfs2 opmap.

Proof obligations: [opt1; opt2;....] is a sublist of l:op
*)

End Optimizations.
Import Optimizations.


(* Joseba *)

(** Here I add a more naive approach to optimizations that allows the "empty"
    optimization, in case a specific optimization is not applicable.
    
    Examples:
      
      e = ASFSOp ADD [FreshVar 1; Val 0] 
      opt_add_0_elem e = ASFSBasicVal (FreshVar 1)
      
      e = ASFSOp ADD [FreshVar 1; FreshVar 2]
      opt_add_0_elem e = e
    
 *)

(* Definitions *)
Definition opt  := asfs_map_val -> asfs_map_val.
Definition optm := asfs_map -> asfs_map.
Definition opta := asfs -> asfs.
Definition optl := asfs -> asfs.

(* Simple optimizations *) 
Definition opt_add_0_elem (e: asfs_map_val) : asfs_map_val :=
  match e with
  | ASFSOp ADD [a1; a2] =>
      match stack_val_has_value a1 WZero,
            stack_val_has_value a2 WZero with
      | true, _      => ASFSBasicVal a2
      | _   , true   => ASFSBasicVal a1
      | false, false => e
      end
  | _ => e
  end.

Definition opt_add_0_check (e: asfs_map_val) : bool :=
  match e with
  | ASFSOp ADD [a1; a2] =>
      stack_val_has_value a1 WZero || 
      stack_val_has_value a2 WZero
  | _ => false
  end.

Definition opt_mul_1_elem (e: asfs_map_val) : asfs_map_val :=
  match e with
  | ASFSOp MUL [a1; a2] =>
      match stack_val_has_value a1 WOne,
            stack_val_has_value a2 WOne with
      | true, _      => ASFSBasicVal a2
      | _   , true   => ASFSBasicVal a1
      | false, false => e
      end
  | _ => e
  end.

Definition opt_mul_1_check (e: asfs_map_val) : bool :=
  match e with
  | ASFSOp MUL [a1; a2] =>
      stack_val_has_value a1 WOne ||
      stack_val_has_value a2 WOne
  | _ => false
  end.


(* Optimizations applications *)

Definition opt_map (o: opt) (m: asfs_map) : asfs_map :=
  let (a,b) := split m in
  let b' := List.map o b in
  combine a b'.

Fixpoint opt_map' (o: opt) (m: asfs_map) : asfs_map :=
  match m with
  | [] => []
  | (id, v)::m' => (id, o v)::(opt_map' o m')
  end.

Definition opt_asfs (om: optm) (a: asfs) : asfs :=
  match a with
  | ASFSc h id s m => ASFSc h id s (om m)
  end.

Fixpoint opt_list_asfs (l: list opta) (a : asfs) : asfs :=
  match l with
  | [] => a
  | o::l' => opt_list_asfs l' (o a)
  end.

Fixpoint opt_id (o: opt) (id: nat) (m : asfs_map): asfs_map :=
  match m with
  | [] => m
  | (id', v)::m' =>
      match id =? id' with
      | false => opt_id o id m'
      | true  => (id, o v)::m'
      end
  end.

(* Composition *)
Definition opt_add_0_map := opt_map' opt_add_0_elem.
Definition opt_add_0_id := (opt_id opt_add_0_elem).
Definition opt_add_0: opta := opt_asfs (opt_map opt_add_0_elem).
Definition opt_mul_1: opta := opt_asfs (opt_map opt_mul_1_elem).


(* Correctness *)
    
Theorem th2: forall (c: concrete_stack) (v: EVMWord) (id: nat) (m: asfs_map) (ops: opm),
  eval_asfs2_elem c (FreshVar id) ((id, ASFSBasicVal (Val v))::m) ops = Some v.
  Proof.
    intros. simpl. rewrite Nat.eqb_refl. destruct m; simpl; reflexivity. Qed.

Theorem th3: forall (c: concrete_stack) (id var: nat) (m: asfs_map) (ops: opm),
  eval_asfs2_elem c (FreshVar id) ((id, ASFSBasicVal (InStackVar var))::m) ops = nth_error c var.
  Proof.
    intros. simpl. rewrite Nat.eqb_refl. destruct m; simpl; reflexivity. Qed.

Theorem th4: forall {A B: Type} (la: list A) (lb: list B) (l : list (A*B)) (f: B -> B),
  (la, lb) = split l  -> 
  combine la (List.map f lb) = [] ->
  l = []. Admitted.

Theorem th5: forall {A B: Type} (l : list (A*B)) (ll: list A) (a: A) (b: B),
  split ((a, b) :: l) <> (ll, []).
Proof.
  intros A B l ll a b H.
  assert (HH:= split_combine ((a,b)::l)).
  rewrite H in HH. rewrite combine_nil in HH. discriminate.
Qed.


(* Theorem th_opt_add_0_elem: forall (e e': asfs_map_val) (c: concrete_stack) *)
(*   (m: asfs_map) (ops: opm), *) 
(*   ops ADD = Some (Op true 2 add)-> *)
(*   opt_add_0_elem e = e' -> *)
(*   eval_asfs2_elem c e m ops = eval_asfs2_elem c e' m ops. *)

Theorem th6: forall (p: nat*asfs_map_val) (m: asfs_map),
  opt_map' opt_add_0_elem (p :: m) <> [].
Proof.
  intros p m H. destruct m.
  - simpl in H. destruct p. discriminate. 
  - simpl in H. destruct p. destruct p0. discriminate.
Qed.

Theorem th7: forall (m: asfs_map),
  opt_map' opt_add_0_elem m = [] -> m = [].
Proof.
  intros. destruct m. reflexivity. cbn in H. destruct p. discriminate. Qed.

Theorem th7'': forall (m: asfs_map) (id: nat),
  opt_add_0_id id m = [] -> m = [].
Proof.
  intros. induction m as [| e m' IH]. 
  - reflexivity. 
  - cbn in H. destruct e. destruct (id =? n). admit.
Admitted.


Theorem th7': forall {A: Type} (a: A) (l: list A),
  a::l <> [].
Proof.
  intros A a l H. discriminate. Qed.

Theorem th8: forall (c: concrete_stack) (var: nat) (m: asfs_map) (ops: opm),
  eval_asfs2_elem c (InStackVar var) m ops = nth_error c var.
Proof.
  intros. destruct m; simpl; reflexivity. Qed.

Lemma th_opt_add_0_val: forall (m1 m2: asfs_map) (ops: opm) (e: asfs_stack_val)
  (c: concrete_stack) (val: EVMWord),
  ops ADD = Some (Op true 2 add) ->
  opt_add_0_map m1 = m2 ->
  e = Val val ->
  eval_asfs2_elem c e m1 ops = eval_asfs2_elem c e m2 ops.
  Proof.
    destruct m1.
    - intros m2 ops e c val H1 H2 H3.
      cbn in H2. rewrite <- H2. reflexivity.
    - intros m2 ops e c val H1 H2 H3.
      cbn. rewrite H3. rewrite eval_value. reflexivity.
  Qed.



Lemma th_opt_add_0_map: forall (m1 m2: asfs_map) (ops: opm)
  (c: concrete_stack) (id: nat),
  ops ADD = Some (Op true 2 add) ->
  opt_add_0_id id m1 = m2 ->
  forall (e: asfs_stack_val), eval_asfs2_elem c e m1 ops = 
                              eval_asfs2_elem c e m2 ops.
Proof.
  induction m1 as [|(id', v) m1' IH].
  - intros. cbn in H0. rewrite H0. reflexivity.
  - intros m2 ops c id H1 H2.
    cbn in H2. destruct (id =? id') eqn:Eq1.
    -- 
       assert (Eq1':= beq_nat_true id id' Eq1).
       destruct v as [bv|opval] eqn:Eq2.
       --- simpl in H2.
           rewrite <- Eq1'. rewrite H2. reflexivity.
       --- simpl in H2.
           destruct opval eqn:Eq3.
           ---- destruct args as [| arg1 args1] eqn:Eq4; 
                try rewrite <- Eq1'; try rewrite H2; try reflexivity. 
                destruct args1 as [| arg2 args2] eqn:Eq5;
                try rewrite <- Eq1'; try rewrite H2; try reflexivity. 
                destruct args2 as [| arg3 args3] eqn:Eq6;
                try rewrite <- Eq1'; try rewrite H2; try reflexivity. 
                destruct (stack_val_has_value arg1 WZero) eqn:Eq7.
                ----- assert (Eq7' := stack_val_has_value_eval c arg1 WZero m1' ops Eq7).
                      destruct e as [val|var|fvar] eqn:Eq8.
                      + rewrite <- H2. apply eval_value.
                      + rewrite <- H2. apply eval_var.
                      + 
                        simpl. 
                        destruct (id =? fvar) eqn:Eq9.
                        ++ rewrite H1. 
                           rewrite Eq7'.
                           destruct (eval_asfs2_elem c arg2 m1' ops) eqn:Eq10;
                            try rewrite -> word_add_0_x_is_x;
                            try (
                              rewrite <- H2; simpl; rewrite Eq9;
                              rewrite Eq10; reflexivity).

                        ++ rewrite <- H2. simpl. rewrite Eq9. reflexivity.
                ----- destruct (stack_val_has_value arg2 WZero) eqn:Eq8.
                      + assert (Eq8' := stack_val_has_value_eval c arg2 WZero m1' ops Eq8).
                        destruct e as [val|var|fvar] eqn:Eq9.
                        ++ rewrite <- H2. apply eval_value.
                        ++ rewrite <- H2. apply eval_var.
                        ++ simpl. destruct (id =? fvar) eqn:Eq10.
                           +++ rewrite H1. rewrite Eq8'.
                               destruct (eval_asfs2_elem c arg1 m1' ops) eqn:Eq11;
                                try rewrite word_add_x_0_is_x;
                                try (
                                    rewrite <- H2; simpl; rewrite Eq10; 
                                    rewrite Eq11; reflexivity).
                           +++ rewrite <- H2. simpl. rewrite Eq10. reflexivity.
                      + destruct e as [val|var|fvar] eqn:Eq9.
                        ++ rewrite <- H2. reflexivity.
                        ++ rewrite <- H2. reflexivity.
                        ++ simpl. destruct (id =? fvar) eqn:Eq10.
                           +++ rewrite H1.
                               destruct (eval_asfs2_elem c arg1 m1' ops) eqn:Eq11.
                               ++++ destruct (eval_asfs2_elem c arg2 m1' ops) eqn:Eq12.
                                    +++++ rewrite <- H2. simpl.
                                          rewrite Eq10. rewrite H1.
                                          rewrite Eq11. rewrite Eq12.
                                          reflexivity.
                                    +++++ rewrite <- H2. simpl.
                                          rewrite Eq10. rewrite H1.
                                          rewrite Eq11. rewrite Eq12.
                                          reflexivity.
                               ++++ rewrite <- H2. simpl.
                                    rewrite Eq10. rewrite H1.
                                    rewrite Eq11. reflexivity.
                           +++ rewrite <- H2. simpl. rewrite Eq10. reflexivity.
           ---- rewrite <- H2. rewrite Eq1'. reflexivity.
           ---- rewrite <- H2. rewrite Eq1'. reflexivity.
    -- destruct e as [val|var|fvar] eqn:Eq2.
       --- rewrite <- H2. rewrite eval_value. rewrite eval_value. reflexivity.
       --- rewrite <- H2. apply eval_var.
       --- rewrite <- H2. simpl. destruct (id' =? fvar) eqn:Eq3.
           ---- destruct v as [bv|opval] eqn:Eq4.
                ----- destruct bv as [val'|var'|fvar'] eqn:Eq5.
                      + admit.
                      + admit.
                      + admit.
                ----- destruct (ops opval) eqn:Eq5.
                      destruct o eqn:Eq6.
                      destruct (length args =? nb_args) eqn:Eq7.
                      + rewrite -> eval_asfs2_ho.
                        destruct m1'.
                        ++ admit.
                        ++ admit.
                      + admit.
                      + admit.
           ---- apply IH with (id:=id); try assumption; try reflexivity.

Admitted.



Theorem th_opt_add_0_correct: forall (c1 c2: concrete_stack) (a1 a2 : asfs) (ops: opm),
  length c1 = get_height_asfs a1 ->
  ops ADD = Some (Op true 2 add) ->
  eval_asfs c1 a1  ops = Some c2 -> 
  opt_add_0 a1 = a2 ->
  eval_asfs c1 a2 ops = Some c2.
  Proof.
    intros c1 c2 a1 a2 ops.
    intros H1 H2 H3 H4.
    
    (* Obtain some equalities *)
    destruct a1 as [h1 id1 s1 m1] eqn:Eq1.
    destruct a2 as [h2 id2 s2 m2] eqn:Eq2.
    unfold opt_add_0 in H4.
    unfold opt_asfs in H4. 
    injection H4 as Eqh Eqid Eqs Eqm.
    
    (* Reduce goal *)
    simpl in H1. apply Nat.eqb_eq in H1. 
    simpl. rewrite <- Eqh. rewrite H1.
     
    (* Transform *)
    simpl in H3. rewrite H1 in H3. rewrite <- Eqs.
    rewrite <- H3. symmetry.
    apply eq_eval_elem_stack.

    (* Apply th' *)

    Admitted.

(* Proof Test *)  
(*
Theorem th0: forall (c: concrete_stack) (e: asfs_stack_val) (m1 m2: asfs_map) (ops: opm) (id: nat),
  ops ADD = Some (Op true 2 add) ->
  opt_id opt_add_0_elem id m1 = m2 ->
  e = FreshVar id ->
  eval_asfs2_elem c e m1 ops = eval_asfs2_elem c e m2 ops.
Proof.
  intros c e m1 m2 ops id.
  revert c e    m2 ops id.
  induction m1 as [| entry m1' IH].
  (* Base Case: m1 = [] *)
  - intros c e m2 ops id.
    intros H1 H2 H3. 
    subst. reflexivity.
  (* Inductive Case: m1 = pair::m1' *)
  - intros c e m2 ops id.
    intros H1 H2 H3.
    simpl. 
    rewrite H3. 
    destruct entry as (id', v') eqn:Eq1.
    destruct (id' =? id) eqn:Eq2.

    (* Case: id' = id *)
    -- 
       destruct v' as [bv | opcode args] eqn:Eq3.
      
       (* Case: ASFSBasicVal bv *)
       ---
           simpl in H2. 
           rewrite Nat.eqb_sym in Eq2. 
           rewrite Eq2 in H2. 
           rewrite <- H2. simpl. 
           rewrite Nat.eqb_refl. 
           reflexivity.   
       
       (* Case: ASFSOp mv *)
       --- destruct (ops opcode) as [[comm nargs f]| None ] eqn:Eq4.
           
           (* Case: ops opcode = Some (Op comm nargs f) *)
           ---- destruct (length args =? nargs) eqn:Eq5.
                (* Case: |args| = nargs *)
                ----- simpl in H2.
                      rewrite Nat.eqb_sym in Eq2.
                      rewrite Eq2 in H2.
                      rewrite <- H2. simpl.
                      rewrite Nat.eqb_refl.
                      destruct opcode eqn:Eq6.
                      ------ rewrite H1 in Eq4.
                             injection Eq4 as Hc Hn Hf.
                             rewrite <- Hn in Eq5.
                             destruct args as [| arg1 args1] eqn:Eq7.
                             + discriminate.
                             + destruct args1 as [| arg2 args2] eqn:Eq8. 
                               ++ discriminate.
                               ++ destruct args2 as [| arg3 args3] eqn:Eq9.
                                  +++ destruct (stack_val_has_value arg1 WZero) eqn:Eq10.
                                      ++++ destruct (apply_f_list_asfs_stack_val 
                                           (fun elem': asfs_stack_val => 
                                           eval_asfs2_elem c elem' m1' ops) args) as 
                                           [args'|] eqn:Eq11. 
                                           +++++ rewrite Eq7 in Eq11. rewrite Eq11. 
                                                 destruct m1'.
                                                 ++++++ simpl. admit.
                                                 ++++++ discriminate. 
                                           +++++ admit. 
                                      ++++ admit.
                                  +++ discriminate .
                               


                      destruct 
                      (apply_f_list_asfs_stack_val 
                        (fun elem': asfs_stack_val => 
                          eval_asfs2_elem c elem' m1' ops) args) as [args'|]eqn:Eq6.
                          (* Case: ... = Some args' *)
                          ------ 
                                 simpl in H2. x1º
                                 rewrite Nat.eqb_sym in Eq2. 
                                 rewrite Eq2 in H2. 
                                 rewrite <- H2. simpl. 
                                 rewrite Nat.eqb_refl.
                                 destruct opcode eqn:Eq7;
                                   try (rewrite Eq4; rewrite Eq5; rewrite Eq6; reflexivity). 
                                 ------- rewrite H1 in Eq4. 
                                         injection Eq4 as Hc Hn Hf.
                                         rewrite <- Hn in Eq5.
                                         admit.


                          (* Case: ... = None *)
                          ------ 
                                 simpl in H2. 
                                 rewrite Nat.eqb_sym in Eq2. 
                                 rewrite Eq2 in H2. 
                                 rewrite <- H2. simpl. 
                                 rewrite Nat.eqb_refl.

                                 destruct opcode eqn:Eq7;
                                 (* Case: opcode = MUL *)
                                 (* Case: opcode = NOT *)
                                  try (rewrite Eq4; rewrite Eq5; rewrite Eq6; reflexivity).
                                 rewrite H1 in Eq4.
                                 injection Eq4 as Hc Hn Hf.
                                 rewrite <- Hn in Eq5.
                                 destruct args as [| arg1 args1] eqn:Eq8.
                                 ------- rewrite H1. simpl. reflexivity.
                                 ------- destruct args1 as [|arg2 args2] eqn:Eq9.
                                         -------- rewrite H1. simpl. reflexivity.
                                         -------- destruct args2 as [| arg3 args3] eqn:Eq10.
                                         + simpl in Eq6.       
                                           destruct (eval_asfs2_elem c arg1 m1' ops) eqn:Eq11.
                                           ++ destruct (eval_asfs2_elem c arg2 m1' ops) eqn:Eq12.
                                              +++ discriminate. 
                                              +++ destruct 
                                                  (stack_val_has_value arg1 WZero) eqn:Eq13.
                                                  ++++ destruct m1' eqn:Eq14.
                                                       +++++ destruct arg1 eqn:Eq15;
                                                             try (simpl in Eq12; discriminate).
                                                             rewrite Eq12. reflexivity.
                                                       +++++ destruct arg1 eqn:Eq15;
                                                             try (simpl in Eq12; discriminate).
                                                             rewrite Eq12. reflexivity.



                                                  ++++ destruct (stack_val_has_value arg2 WZero) 
                                                       eqn:Eq14.
                                                       +++++ admit.


                                                       +++++ rewrite H1. simpl.
                                                             rewrite Eq11.
                                                             rewrite Eq12.
                                                             reflexivity.
                                           ++ destruct (eval_asfs2_elem c arg1 m1' ops) eqn:Eq12.
                                              +++ discriminate.
                                              +++ destruct
                                                  (stack_val_has_value arg1 WZero) eqn:Eq13.
                                                  ++++ destruct m1' eqn:Eq14.
                                                       +++++ simpl. 
                                                             destruct arg1 eqn:Eq15; 
                                                             simpl in Eq12; discriminate.
                                                       +++++ simpl.
                                                             destruct arg1 eqn:Eq15; 
                                                             simpl in Eq12; discriminate.

                                                  ++++ destruct (stack_val_has_value arg2 WZero)
                                                       eqn:Eq14.
                                                       +++++ rewrite Eq12. reflexivity.
                                                       +++++ rewrite H1. 
                                                             simpl. rewrite Eq12. 
                                                             reflexivity. 



                                         + rewrite H1. simpl. reflexivity. 

                (* Case: |args| != nargs *)
                ----- 
                      simpl in H2. 
                      rewrite Nat.eqb_sym in Eq2. 
                      rewrite Eq2 in H2.
                      rewrite <- H2. simpl. 
                      rewrite Nat.eqb_refl.
                      destruct opcode eqn:Eq6; 
                      (* Case: opcode = MUL *)
                      (* Case: opcode = NOT *)
                        try (rewrite Eq4; rewrite Eq5; reflexivity).
                      (* Case: opcode = ADD *)
                        rewrite H1 in Eq4. 
                        injection Eq4 as Hc Hn Hf.
                        rewrite <- Hn in Eq5.
                        destruct args as [| arg1 args1] eqn:Eq7.
                        (* Case: args = [] *)
                        ------ rewrite H1. simpl. reflexivity.
                        (* Case: args = arg1::args1 *)
                        ------ destruct args1 as [| arg2 args2] eqn:Eq8.
                               (* Case: args1 = [] *)
                               ------- rewrite H1. simpl. reflexivity.
                               (* Case: args1 = arg2::args2 *)
                               ------- destruct args2 as [| arg3 args3] eqn:Eq9.
                                       (* Case: args2 = [] *)
                                       -------- discriminate.
                                       (* Case: args2 = arg3::args3 *)
                                       -------- rewrite H1. simpl. reflexivity.
           
           (* Case: ops opcode = None *) 
           ---- simpl in H2. 
                rewrite Nat.eqb_sym in Eq2. 
                rewrite Eq2 in H2. 
                rewrite <- H2. simpl.
                rewrite Nat.eqb_refl.

                destruct opcode eqn:Eq5;
                (* Case: opcode != ADD *)
                  try (rewrite Eq4; reflexivity).
                (* Case: opcode = ADD *)
                  rewrite H1 in Eq4. discriminate. 

    (* Case: id' != id *)
    -- simpl in H2. 
       rewrite Nat.eqb_sym in Eq2. 
       rewrite Eq2 in H2.
       rewrite <- H3.
       apply IH with (id := id); try assumption.
Admitted.
*)



(* Examples *)

Example p1 : block := [
  Opcode ADD;
  PUSH 1 (natToWord WLen 0); 
  PUSH 1 (natToWord WLen 2);
  Opcode ADD;
  PUSH 1 (natToWord WLen 1); 
  PUSH 1 (natToWord WLen 0);
  Opcode MUL
].

Definition extract_asfs (a: option asfs) : asfs :=
  match a with
  | None => empty_asfs 0
  | Some a' => a'
  end.

(* Create asfs a, asfs opt o1 and o2, and opta list ol *)
Example a1 := extract_asfs (symbolic_exec p1 3 opmap).
Example o1 := opt_asfs (opt_map opt_add_0_elem).
Example o2 := opt_asfs (opt_map opt_mul_1_elem).
Example ol := [o1; o2].

Example t1 := get_stack_asfs a1.
Example t2 := get_map_asfs a1.
Example t3 := o1 a1.
Example t4 := o2 a1.
Example t5 := opt_list_asfs ol a1.
  
Compute t1.
Compute t2.
Compute t3.
Compute t4.
Compute t5.



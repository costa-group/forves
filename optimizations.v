Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import Coq.NArith.NArith.
Require Import List.
Require Import Coq_EVM.definitions.
Import EVM_Def Concrete Abstract Optimizations.
Require Import Coq_EVM.interpreter.
Import Interpreter SFS.
Require Import Coq.Logic.FunctionalExtensionality.
Import ListNotations.



Module Optimizations.


(* General definitions to implement different optimizations and useful common
   lemmas *)

Fixpoint stack_val_is_oper_suffix (oper: oper_label) (val: asfs_stack_val) 
  (m: asfs_map) {struct m}: option ((list asfs_stack_val)*asfs_map*nat) :=
match val with 
| Val _ => None
| InStackVar _ => None
| FreshVar fvar => match m with
                   | [] => None
                   | (k,v)::t => 
                       if k =? fvar then
                         match v with
                         | ASFSBasicVal (FreshVar fv) =>
                             stack_val_is_oper_suffix oper (FreshVar fv) t
                         | ASFSOp opcode args =>
                             if oper =?i opcode
                             then Some (args,t,k)
                             else None
                         | _ => None
                         end
                       else stack_val_is_oper_suffix oper val t
                   end
end.

(* Simplified version to have only the inner arguments *)
Definition stack_val_is_oper (oper: oper_label) (val: asfs_stack_val) 
  (m: asfs_map): option (list asfs_stack_val) :=
match (stack_val_is_oper_suffix oper val m) with
| Some (l,_,_) => Some l
| _ => None
end. 

Lemma app_cons_lr: forall {X: Type} (l1 l2: list X) (e: X),
l1 ++ (e::l2) = (l1++[e])++l2.
Proof.
induction l1 as [|h t IH].
- intros. reflexivity.
- intros. rewrite <- app_comm_cons. rewrite <- app_comm_cons.
  rewrite <- app_comm_cons.
  rewrite -> IH. reflexivity.
Qed.

Lemma weqb_reflex: forall (x: EVMWord),
weqb x x = true.
Proof.
intros. apply weqb_true_iff. reflexivity. 
Qed.

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
forall (n: nat) (c cf: tstack) (a opt_a: asfs),
eval_asfs c a opmap = Some cf ->
opt n a = Some opt_a ->
valid_asfs a ->
eval_asfs c opt_a opmap = Some cf /\ valid_asfs opt_a.


Definition safe_optimization (opt: asfs -> asfs*bool) : Prop :=
forall (c cf: tstack) (a opt_a: asfs) (b: bool),
eval_asfs c a opmap = Some cf ->
opt a = (opt_a, b) ->
valid_asfs a ->
eval_asfs c opt_a opmap = Some cf /\ valid_asfs opt_a.


Lemma optimize_fresh_var2_preservation: forall (m: asfs_map) (a a': asfs) 
  (opt: nat -> asfs -> option asfs) (b: bool) (c cf: tstack),
safe_optimization_fvar opt ->
optimize_fresh_var2 a m opt = (a', b) ->
valid_asfs a ->
eval_asfs c a opmap = Some cf ->
eval_asfs c a' opmap = Some cf /\ valid_asfs a'.
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

Definition stack_val_has_value' (av: asfs_stack_val) (m: asfs_map)
  (v: EVMWord) : bool :=
match flat_stack_elem av m with
| Some (UVal x) => weqb x v
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


Lemma stack_val_has_value_eval: forall (c: tstack) 
  (elem: asfs_stack_val) (v: EVMWord) (m: asfs_map) (ops: opm),
stack_val_has_value elem v = true ->  
eval_asfs2_elem c elem m ops = Some v.
Proof.
intros. unfold stack_val_has_value in H.
destruct (elem) as [x|var|fvar] eqn: eq_elem; try discriminate.
apply weqb_sound in H. rewrite -> H.
destruct m; try reflexivity.
Qed.

Lemma stack_val_has_value_eval': forall (c: tstack) 
  (elem: asfs_stack_val) (v: EVMWord) (m: asfs_map) (ops: opm),
stack_val_has_value' elem m v = true ->  
eval_asfs2_elem c elem m ops = Some v.
Proof.
intros. unfold stack_val_has_value' in H.
destruct (flat_stack_elem elem m) as [expr|] eqn: eq_flat; try discriminate.
destruct expr as [x|var|var] eqn: eq_expr; try discriminate.
apply eval_tree_asfs_val with (s:=c)(ops:=ops) in eq_flat.
simpl in eq_flat.
apply weqb_sound in H. rewrite <- H.
assumption.
Qed.


Lemma eval_asfs2_val: forall (stack: tstack) (val: EVMWord) (m: asfs_map)
  (ops: opm),
eval_asfs2_elem stack (Val val) m ops = Some val.
Proof.
intros. destruct m; try (unfold eval_asfs2_elem; reflexivity).
Qed.


Lemma eval_var: forall (stack: tstack) (var: nat) (m1 m2: asfs_map)
  (ops: opm),
eval_asfs2_elem stack (InStackVar var) m1 ops =
eval_asfs2_elem stack (InStackVar var) m2 ops.
Proof.
intros. 
rewrite -> eval_asfs2_instackvar.
rewrite -> eval_asfs2_instackvar.
reflexivity.
Qed.


(* If the evaluation of every element wrt. m1 is the same as wrt. m2,
   then the evaluation of any list of elements will be the same *)
Lemma eq_eval_elem_stack: forall (c: tstack) (m1 m2: asfs_map)
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
Lemma eq_succ_eval_elem_stack: forall (c cf: tstack) (m1 m2: asfs_map)
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

(* If elem points to a function with inner_args (i.e., it is a FreshVar) with
   suffix, then there is a prefix s.t. 
   a) m = prefix + (fv, oper args)::suffix 
   b) the evaluation of elem in m is the same as evaluation f vargs in suff *)
Lemma evaluation_suffix_map': forall (m suffix: asfs_map) (nbargs: nat)  
  (elem: asfs_stack_val) (fv: nat)
  (inner_args: asfs_stack) (comm: bool) (func: list EVMWord -> option EVMWord)
  (val: EVMWord) (oper: oper_label) (ops: opm) (stack: tstack),
stack_val_is_oper_suffix oper elem m = Some (inner_args, suffix, fv) ->
ops oper = Some (Op comm nbargs func) ->
eval_asfs2_elem stack elem m ops = Some val ->
exists (prefix: asfs_map) (inner_vals: tstack), 
  m = prefix ++ ((fv, ASFSOp oper inner_args)::suffix) /\
  eval_asfs2 stack inner_args suffix ops = Some inner_vals /\
  func inner_vals = Some val.
Proof.
induction m as [| h t IH].
- intros. simpl in H. destruct elem; try discriminate H.
- intros. simpl in H.
  destruct elem as [| |fvar] eqn: eq_elem; try discriminate H.
  destruct h as [k v] eqn: eq_h.
  destruct (k =? fvar) eqn: eq_k_fvar.
  + destruct v as [basicval| opcode args] eqn: eq_e.
    * destruct basicval as [ | |fvar'] eqn: eqbasicval; try discriminate.
      simpl in H1. rewrite -> eq_k_fvar in H1.
      pose proof (IH suffix nbargs (FreshVar fvar') fv inner_args comm func val oper
        ops stack H H0 H1) as [eprefix [einner_vals [Ht [Heval Hfunc]]]].
      exists ((k, ASFSBasicVal (FreshVar fvar'))::eprefix).
      exists einner_vals.
      rewrite -> Ht.
      split; try auto.
    * destruct (oper =?i opcode) eqn: eq_opers; try discriminate.
      injection H as eq_args eq_suffix eq_fv.
      rewrite <- eq_suffix. rewrite <- eq_args. rewrite <- eq_fv.
      apply eq_oper_label_correct in eq_opers. rewrite -> eq_opers.
      exists [].
      simpl in H1. rewrite -> eq_k_fvar in H1.
      rewrite <- eq_opers in H1. rewrite -> H0 in H1.    
      destruct (length args =? nbargs) eqn: eq_len; try discriminate.
      rewrite -> eval_asfs2_ho in H1.
      destruct (eval_asfs2 stack args t ops) as [vargs|] eqn: eq_eval_args;
        try discriminate.
      exists vargs.
      split; try auto.
  + (* Recursive call *)
    unfold eval_asfs2_elem in H1. rewrite -> eq_k_fvar in H1.
    fold eval_asfs2_elem in H1.
    pose proof (IH suffix nbargs (FreshVar fvar) fv inner_args comm func
      val oper ops stack H H0 H1) as [prefix [inner_vals [eq_pref 
      [eq_eval_inner eq_func]]]].
    exists ((k, v)::prefix). exists inner_vals.
    rewrite -> eq_pref.
    split; try auto.
Qed.

(* If elem points to a function with inner_args (i.e., it is a FreshVar) then
   there is a suffix of the map s.t. inner_args are evaluated to values *)
Lemma evaluation_sufix_map: forall (m: asfs_map) (nbargs: nat)  
  (elem: asfs_stack_val)
  (inner_args: asfs_stack) (comm: bool) (func: list EVMWord -> option EVMWord)
  (val: EVMWord) (oper: oper_label) (ops: opm) (stack: tstack),
stack_val_is_oper oper elem m = Some inner_args ->
ops oper = Some (Op comm nbargs func) ->
eval_asfs2_elem stack elem m ops = Some val ->
exists (prefix suffix: asfs_map) (inner_vals: tstack), 
  m = prefix ++ suffix /\
  eval_asfs2 stack inner_args suffix ops = Some inner_vals /\
  func inner_vals = Some val.
Proof.
intros.
unfold stack_val_is_oper in H.
destruct (stack_val_is_oper_suffix oper elem m) as [p|] eqn: eq_p;
  try discriminate.
destruct (p) as [p1 fv]. destruct p1 as [args suffix].
injection H as H.
pose proof (evaluation_suffix_map' m suffix nbargs elem fv args comm func
  val oper ops stack eq_p H0 H1) as [prefix [vals [eq_pref [eq_eval eq_func]]]].
exists (prefix ++ [(fv, ASFSOp oper args)]). exists suffix. exists vals.
rewrite <- H.
split; try (split; try assumption).
rewrite <- app_cons_lr.
assumption.
Qed.


(* If we can evaluate a FreshVar, then it must appear in the map *)
Lemma eval_fvar_then_in_map: forall (stack: tstack) (fvar: nat)
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
Lemma eval_elem_cons_decreasing_map: forall (stack: tstack)
  (elem: asfs_stack_val) (n: nat) (e: asfs_map_val) (suffix m: asfs_map)
  (ops: opm) (v : EVMWord),
eval_asfs2_elem stack elem suffix ops = Some v ->
m = (n, e)::suffix ->
strictly_decreasing_map m ->
eval_asfs2_elem stack elem m ops = Some v.
Proof.
intros stack elem n e suffix m ops v Heval_suffix Hmcons Hdecreasing.
destruct elem as [val|var|fvar] eqn: eq_elem.
- pose proof (eval_asfs2_val stack val suffix ops) as Heval_suffix_val.
  rewrite -> Heval_suffix  in Heval_suffix_val.
  rewrite -> Heval_suffix_val.
  apply eval_asfs2_val.
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
Lemma eval_elem_bigger_decreasing_map: forall (stack: tstack)
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
  + pose proof (eval_asfs2_val stack val suffix ops) as Heval_suffix_val.
    rewrite -> Hevalsuffix  in Heval_suffix_val.
    rewrite -> Heval_suffix_val.
    apply eval_asfs2_val.
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
  (m: asfs_map) (ops: opm) (stack vals: tstack),
eval_asfs2 stack (h :: t) m ops = Some vals ->
exists (v: EVMWord) (vals': tstack),
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
  (m: asfs_map) (ops: opm) (stack vals': tstack) (v: EVMWord),
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


Lemma same_fvar_in_map_preserves_fresh_var_gt: forall (n:nat )(m1 m2: asfs_map),
fresh_var_gt_map n m1 ->
same_fvar_in_maps m1 m2 -> 
fresh_var_gt_map n m2.
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
    auto.
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
    rewrite -> eq_fvar2_fvar2'.
    split; try assumption.
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
Lemma eval_bigger_decreasing_map: forall (stack vals: tstack)
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
       Identity optimization 
*******************************************)
Definition optimize_id (a: asfs) : asfs*bool := (a, false).

Theorem optimize_id_safe:
safe_optimization optimize_id.
Proof.
unfold safe_optimization. intros.
unfold optimize_id in H0.
injection H0 as eq_a_opta _.
rewrite <- eq_a_opta.
auto.
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
                     if stack_val_has_value' arg1 t WZero then
                       Some ((n, ASFSBasicVal arg2)::t)
                     else if stack_val_has_value' arg2 t WZero then
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

(* This is the main ADD_0 optimization *)
Definition optimize_add_zero (a: asfs) : asfs*bool :=
optimize_fresh_var optimize_add_zero_fvar a.

Lemma word_add_0_x_is_x: forall (x: EVMWord),
evm_add [WZero; x] = Some x.
Proof.
intros x. simpl.
rewrite -> wplus_wzero_2. reflexivity.
Qed.

Lemma word_add_x_0_is_x: forall (x: EVMWord),
evm_add [x; WZero] = Some x.
Proof.
intros x. simpl.
rewrite -> wplus_wzero_1. reflexivity.
Qed.

(* Main lemma: every stack value is evaluated to the same value in the 
   original map and also in the optimized one for ADD_0 *)
Lemma eq_eval_opt_add_zero: forall (m1 m2: asfs_map) (ops: opm) (n: nat)
  (stack: tstack),
ops ADD = Some (Op true 2 evm_add) ->
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
      destruct (stack_val_has_value' arg1 t WZero ) eqn: eq_arg1_zero.
      -- (* arg1 is WZero *)
         injection H0 as eq_m2. rewrite <- eq_m2.
         destruct elem as [val|var|fvar] eqn: eq_elem.
         ++ apply eval_asfs2_val.
         ++ apply eval_var.
         ++ unfold eval_asfs2_elem. destruct (hn =? fvar) eqn: eq_vame_fvar.
            ** rewrite -> H. simpl. fold eval_asfs2_elem.
               rewrite -> stack_val_has_value_eval' with (v:=WZero);
                 try assumption.
               destruct (eval_asfs2_elem stack arg2 t ops) as [arg2_val|]
                 eqn: eq_eval_arg2; try reflexivity.
               rewrite -> word_add_0_x_is_x. reflexivity.
            ** fold eval_asfs2_elem. reflexivity.
      -- (* arg2 is WZero *)
         destruct (stack_val_has_value' arg2 t WZero) eqn: eq_arg2_zero;
           try discriminate.
         injection H0 as eq_m2. rewrite <- eq_m2.
         destruct elem as [val|var|fvar] eqn: eq_elem.
         ++ apply eval_asfs2_val.
         ++ apply eval_var.
         ++ unfold eval_asfs2_elem. destruct (hn =? fvar) eqn: eq_vame_fvar.
            ** rewrite -> H. simpl. fold eval_asfs2_elem.
               destruct (eval_asfs2_elem stack arg1 t ops) as [arg1_val|]
                 eqn: eq_eval_arg2; try reflexivity.
               rewrite -> stack_val_has_value_eval' with (v:=WZero);
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
  (c: tstack) (ops: opm),
ops ADD = Some (Op true 2 evm_add) ->
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
    destruct (stack_val_has_value' arg1 t WZero).
    * injection Hopt as eq_m2. rewrite <- eq_m2.
      simpl. split; try reflexivity.
      apply same_fvar_refl.
    * destruct (stack_val_has_value' arg2 t WZero); try discriminate.
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


Lemma optimize_add_zero_fvar_safe:
safe_optimization_fvar optimize_add_zero_fvar.
Proof.
unfold safe_optimization_fvar. intros.
split.
- assert (opmap ADD = Some (Op true 2 evm_add)) as Hopmap_add; try reflexivity.
  pose proof (optimize_add_zero_fvar_eq a opt_a n c opmap Hopmap_add H0)
    as Heq_eval_a_opta.
  rewrite -> Heq_eval_a_opta in H.
  rewrite -> H.
  split; try reflexivity.
- unfold valid_asfs.
  destruct opt_a as [hopt maxopt sopt mopt] eqn: eq_opt_a.
  destruct a as [ha maxa sa ma] eqn: eq_a.
  simpl in H1. simpl in H0.
  destruct (optimize_map_add_zero n ma) eqn: optimize_ma; try discriminate.
  injection H0 as eq_h eq_max eq_stack eq_maps. 
  rewrite -> eq_maps in optimize_ma.
  destruct H1 as [Hfreshv Hdecr].
  rewrite <- eq_max.
  rewrite <- eq_maps.
  split.
  + apply same_fvar_in_map_preserves_fresh_var_gt with (m1:=ma).
    * assumption.
    * apply opt_add_zero_same_fvar_in_maps with (n:=n).
      rewrite -> eq_maps. assumption.
  + apply opt_add_zero_decreasingness_preservation with (n:=n) (m1:=ma) 
      (m2:=a0) in Hdecr.
    * assumption.
    * rewrite -> eq_maps. assumption.
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
                     if stack_val_has_value' arg1 t WOne then
                       Some ((n, ASFSBasicVal arg2)::t)
                     else if stack_val_has_value' arg2 t WOne then
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

(* This is the main MUL_1 optimization *)
Definition optimize_mul_one (a: asfs) : asfs*bool :=
optimize_fresh_var optimize_mul_one_fvar a.

Lemma word_mul_1_x_is_x: forall (x: EVMWord),
evm_mul [WOne; x] = Some x.
Proof.
intros x. simpl.
rewrite -> wmult_unit. reflexivity.
Qed.

Lemma word_mul_x_1_is_x: forall (x: EVMWord),
evm_mul [x; WOne] = Some x.
Proof.
intros x. simpl.
rewrite -> wmult_comm. rewrite -> wmult_unit. 
reflexivity.
Qed.


(* Main lemma: every stack value is evaluated to the same value in the 
   original map and also in the optimized one for MUL_1 *)
Lemma eq_eval_opt_mul_one_eq: forall (m1 m2: asfs_map) (ops: opm) (n: nat)
  (stack: tstack),
ops MUL = Some (Op true 2 evm_mul) ->
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
      destruct (stack_val_has_value' arg1 t WOne) eqn: eq_arg1_one.
      -- (* arg1 is WOne *)
         injection H0 as eq_m2. rewrite <- eq_m2.
         destruct elem as [val|var|fvar] eqn: eq_elem.
         ++ apply eval_asfs2_val.
         ++ apply eval_var.
         ++ unfold eval_asfs2_elem. destruct (hn =? fvar) eqn: eq_vame_fvar.
            ** rewrite -> H. simpl. fold eval_asfs2_elem.
               rewrite -> stack_val_has_value_eval' with (v:=WOne);
                 try assumption.
               destruct (eval_asfs2_elem stack arg2 t ops) as [arg2_val|]
                 eqn: eq_eval_arg2; try reflexivity.
               rewrite -> word_mul_1_x_is_x. reflexivity.
            ** fold eval_asfs2_elem. reflexivity.
      -- (* arg2 is One *)
         destruct (stack_val_has_value' arg2 t WOne) eqn: eq_arg2_one;
           try discriminate.
         injection H0 as eq_m2. rewrite <- eq_m2.
         destruct elem as [val|var|fvar] eqn: eq_elem.
         ++ apply eval_asfs2_val.
         ++ apply eval_var.
         ++ unfold eval_asfs2_elem. destruct (hn =? fvar) eqn: eq_vame_fvar.
            ** rewrite -> H. simpl. fold eval_asfs2_elem.
               destruct (eval_asfs2_elem stack arg1 t ops) as [arg1_val|]
                 eqn: eq_eval_arg2; try reflexivity.
               rewrite -> stack_val_has_value_eval' with (v:=WOne);
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
  (c: tstack) (ops: opm),
ops MUL = Some (Op true 2 evm_mul) ->
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
    destruct (stack_val_has_value' arg1 t WOne).
    * injection Hopt as eq_m2. rewrite <- eq_m2.
      simpl. split; try reflexivity.
      apply same_fvar_refl.
    * destruct (stack_val_has_value' arg2 t WOne); try discriminate.
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


Lemma optimize_mul_one_fvar_safe:
safe_optimization_fvar optimize_mul_one_fvar.
Proof.
unfold safe_optimization_fvar. intros.
split.
- assert (opmap MUL = Some (Op true 2 evm_mul)) as Hopmap_mul; try reflexivity.
  pose proof (optimize_mul_one_eq a opt_a n c opmap Hopmap_mul H0)
    as Heq_eval_a_opta.
  rewrite -> Heq_eval_a_opta in H.
  rewrite -> H.
  split; try reflexivity.
- unfold valid_asfs.
  destruct opt_a as [hopt maxopt sopt mopt] eqn: eq_opt_a.
  destruct a as [ha maxa sa ma] eqn: eq_a.
  simpl in H1. simpl in H0.
  destruct (optimize_map_mul_one n ma) eqn: optimize_ma; try discriminate.
  injection H0 as eq_h eq_max eq_stack eq_maps. 
  rewrite -> eq_maps in optimize_ma.
  destruct H1 as [Hfreshv Hdecr].
  rewrite <- eq_max.
  rewrite <- eq_maps.
  split.
  + apply same_fvar_in_map_preserves_fresh_var_gt with (m1:=ma).
    * assumption.
    * apply opt_mul_one_same_fvar_in_maps with (n:=n).
      rewrite -> eq_maps. assumption.
  + apply opt_mul_one_decreasingness_preservation with (n:=n) (m1:=ma) 
      (m2:=a0) in Hdecr.
    * assumption.
    * rewrite -> eq_maps. assumption.
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
                     if stack_val_has_value' arg1 t WZero then
                       Some ((n, ASFSBasicVal (Val WZero))::t)
                     else if stack_val_has_value' arg2 t WZero then
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
evm_mul [WZero; x] = Some WZero.
Proof.
intros x. simpl.
rewrite -> wmult_neut_l. reflexivity.
Qed.

Lemma word_mul_x_0_is_0: forall (x: EVMWord),
evm_mul [x; WZero] = Some WZero.
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
  (stack: tstack),
ops MUL = Some (Op true 2 evm_mul) ->
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
      destruct (stack_val_has_value' arg1 t WZero) eqn: eq_arg1_zero.
      -- (* arg1 is WZero *)
         injection H0 as eq_m2. rewrite <- eq_m2.
         destruct elem as [val|var|fvar] eqn: eq_elem.
         ++ rewrite -> eval_asfs2_val in H1. injection H1 as H1.
            rewrite <- H1.
            rewrite -> eval_asfs2_val. reflexivity.
         ++ pose proof (eval_var stack var ((hn, ASFSOp MUL [arg1; arg2]) :: t)
             ((hn, ASFSBasicVal (Val WZero)) :: t) ops) as Hsameeval.
            rewrite <- Hsameeval. assumption.
         ++ unfold eval_asfs2_elem. destruct (hn =? fvar) eqn: eq_vame_fvar.
            ** fold eval_asfs2_elem. simpl in H1.
               rewrite -> eq_vame_fvar in H1. rewrite -> H in H1.
               pose proof (stack_val_has_value_eval' stack arg1 WZero t ops
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
         destruct (stack_val_has_value' arg2 t WZero) eqn: eq_arg2_zero;
           try discriminate.
         injection H0 as eq_m2. rewrite <- eq_m2.
         destruct elem as [val|var|fvar] eqn: eq_elem.
         ++ rewrite -> eval_asfs2_val in H1. injection H1 as H1.
            rewrite <- H1.
            rewrite -> eval_asfs2_val. reflexivity.
         ++ pose proof (eval_var stack var ((hn, ASFSOp MUL [arg1; arg2]) :: t)
             ((hn, ASFSBasicVal (Val WZero)) :: t) ops) as Hsameeval.
            rewrite <- Hsameeval. assumption.
         ++ unfold eval_asfs2_elem. destruct (hn =? fvar) eqn: eq_vame_fvar.
            ** fold eval_asfs2_elem. simpl in H1.
               rewrite -> eq_vame_fvar in H1. rewrite -> H in H1.
               destruct (eval_asfs2_elem stack arg1 t ops) as [arg1_val|]
                 eqn: eq_eval_arg1; try discriminate.
                pose proof (stack_val_has_value_eval' stack arg2 WZero t ops
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
    * rewrite -> eval_asfs2_val. rewrite -> eval_asfs2_val in H1. assumption.
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
  (c s: tstack) (ops: opm),
ops MUL = Some (Op true 2 evm_mul) ->
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
    destruct (stack_val_has_value' arg1 t WZero).
    * injection Hopt as eq_m2. rewrite <- eq_m2.
      simpl. split; try reflexivity.
      apply same_fvar_refl.
    * destruct (stack_val_has_value' arg2 t WZero); try discriminate.
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
- assert (opmap MUL = Some (Op true 2 evm_mul)) as Hopmap_mul; try reflexivity.
  pose proof (optimize_mul_zero_safe_success a opt_a n c cf opmap Hopmap_mul
     H0 H) as Heq_eval_a_opta.
  assumption.
- unfold valid_asfs.
  destruct opt_a as [hopt maxopt sopt mopt] eqn: eq_opt_a.
  destruct a as [ha maxa sa ma] eqn: eq_a.
  simpl in H1. simpl in H0.
  destruct (optimize_map_mul_zero n ma) eqn: optimize_ma; try discriminate.
  injection H0 as eq_h eq_max eq_stack eq_maps. 
  rewrite -> eq_maps in optimize_ma.
  destruct H1 as [Hfreshv Hdecr].
  rewrite <- eq_max.
  rewrite <- eq_maps.
  split.
  + apply same_fvar_in_map_preserves_fresh_var_gt with (m1:=ma).
    * assumption.
    * apply opt_mul_zero_same_fvar_in_maps with (n:=n).
      rewrite -> eq_maps. assumption.
  + apply opt_mul_zero_decreasingness_preservation with (n:=n) (m1:=ma) 
      (m2:=a0) in Hdecr.
    * assumption.
    * rewrite -> eq_maps. assumption.
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
  (stack: tstack),
ops NOT = Some (Op false 1 evm_not) ->
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
      -- rewrite -> eval_asfs2_val. rewrite -> eval_asfs2_val. intuition.
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
            pose proof (evaluation_sufix_map t 1 arg1 [inner_arg] false evm_not
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
    * rewrite -> eval_asfs2_val. rewrite -> eval_asfs2_val. intuition.
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
  (n: nat) (stack: tstack),
ops NOT = Some (Op false 1 evm_not) ->
optimize_map_not_not n m1 = Some m2 ->
strictly_decreasing_map m1 ->
forall (abs: asfs_stack) (v: tstack), 
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
assert (opmap NOT = Some (Op false 1 evm_not)) as eq_opmap_NOT; try reflexivity.
simpl in H0. destruct (optimize_map_not_not n ma) as [ma' |] 
  eqn: eq_optmize_ma; try discriminate.
injection H0 as eq_h eq_max eq_abs eq_m.
rewrite -> eq_m in eq_optmize_ma.
simpl in H1. destruct H1 as [fresh_var_gt strictly_decr].
simpl. rewrite <- eq_h. rewrite -> eq_len.
split; try split.
- rewrite -> eq_abs in H.
  pose proof (eq_succ_eval_opt_not_not_eq_abs ma mopt opmap n c eq_opmap_NOT
  eq_optmize_ma strictly_decr absopt cf H).
  assumption.
- apply opt_not_not_same_fvar_in_maps in eq_optmize_ma.
  apply same_fvar_in_map_preserves_fresh_var_gt with (m1:=ma).
  + rewrite <- eq_max. assumption.
  + assumption.
- apply opt_not_not_decreasingness_preservation with (n:=n) (m1:=ma);
    try assumption.
Qed.

Theorem optimize_not_not_safe:
safe_optimization optimize_not_not.
Proof.
apply optimize_fresh_var_preservation.
apply optimize_not_not_fvar_safe.
Qed.



(*****************************************
  Optimization EVAL
******************************************)
Definition flat_extract_const (v: asfs_stack_val) (m: asfs_map) 
  : option EVMWord :=
match flat_stack_elem v m with
| Some (UVal x) => Some x
| _ => None
end.

Lemma flat_extract_const_eval: forall (elem: asfs_stack_val) (m: asfs_map)
  (v: EVMWord) (stack: tstack) (ops: opm),
flat_extract_const elem m = Some v ->
eval_asfs2_elem stack elem m ops = Some v.
Proof.
intros. unfold flat_extract_const in H.
destruct (flat_stack_elem elem m) as [s|] eqn: flat_stack; try discriminate.
destruct s as [x|var|fvar]; try discriminate.
pose proof (eval_tree_asfs_val elem m (UVal x) stack ops flat_stack) as HH.
rewrite -> HH. simpl.
assumption.
Qed.


Definition const_list (l: list asfs_stack_val) (m: asfs_map) 
  : option (list EVMWord) :=
apply_f_opt_list (fun e => flat_extract_const e m) l.

Fixpoint optimize_map_eval (ops: opm) (fresh_var: nat) (map: asfs_map): 
  option asfs_map :=
match map with
| [] => None
| (n, val)::t => 
    if n =? fresh_var then
    match val with
    | ASFSOp oper args =>
        if (is_fully_defined oper) then
          match const_list args t with
          | Some wargs => 
              match ops oper with
              | Some (Op comm nargs f) => 
                  if length args =? nargs
                  then
                    match f wargs with
                    | Some v => Some ((n, ASFSBasicVal (Val v))::t)
                    | None => None
                    end
                  else None
              | None => None
              end
          | None => None
          end
        else None
    | _ => None
    end
    else
    match optimize_map_eval ops fresh_var t with 
    | None => None
    | Some map' => Some ((n, val)::map')
    end
end.

Definition optimize_eval_fvar (fresh_var: nat) (s: asfs): option asfs :=
optimize_func_map (optimize_map_eval opmap) fresh_var s.

(* THIS IS THE MAIN OPTIMIZATION *)
Definition optimize_eval : (asfs -> asfs*bool) :=
optimize_fresh_var optimize_eval_fvar.


Lemma eval_elem_fun: forall (stack: tstack) (t map': asfs_map) (ops: opm),
(forall elem : asfs_stack_val, eval_asfs2_elem stack elem t ops = eval_asfs2_elem stack elem map' ops) ->
forall elem : asfs_stack_val, (fun elem' : asfs_stack_val => eval_asfs2_elem stack elem' t ops) elem = 
                              (fun elem' : asfs_stack_val => eval_asfs2_elem stack elem' map' ops) elem.
Proof.
intros. simpl. rewrite -> H. reflexivity.
Qed.

Lemma const_list_apply_f: forall (args: list asfs_stack_val) (t: asfs_map)
  (wargs: list EVMWord) (stack: tstack) (ops: opm),
const_list args t = Some wargs -> 
apply_f_list_asfs_stack_val 
  (fun elem' : asfs_stack_val => eval_asfs2_elem stack elem' t ops) args
  = Some wargs.
Proof.
intros. destruct args as [|h1 t1] eqn: eq_args.
- simpl. simpl in H. assumption.
- simpl in H. destruct t1 as [|h2 t2].
  + destruct (flat_extract_const h1 t) eqn: flat_h1; try discriminate.
    simpl.
    apply flat_extract_const_eval with (stack:=stack)(ops:=ops) in flat_h1.
    rewrite -> flat_h1.
    assumption.
  + destruct t2 as [|h3 t3].
    * destruct (flat_extract_const h1 t) eqn: flat_h1; try discriminate.
      apply flat_extract_const_eval with (stack:=stack)(ops:=ops) in flat_h1.
      destruct (flat_extract_const h2 t) eqn: flat_h2; try discriminate.
      apply flat_extract_const_eval with (stack:=stack)(ops:=ops) in flat_h2.
      simpl. rewrite -> flat_h1. rewrite -> flat_h2.
      assumption. 
    * destruct t3 as [|h4 t4].
      -- destruct (flat_extract_const h1 t) eqn: flat_h1; try discriminate.
         apply flat_extract_const_eval with (stack:=stack)(ops:=ops) in flat_h1.
         destruct (flat_extract_const h2 t) eqn: flat_h2; try discriminate.
         apply flat_extract_const_eval with (stack:=stack)(ops:=ops) in flat_h2.
         destruct (flat_extract_const h3 t) eqn: flat_h3; try discriminate.
         apply flat_extract_const_eval with (stack:=stack)(ops:=ops) in flat_h3.
         simpl. rewrite -> flat_h1. rewrite -> flat_h2. rewrite -> flat_h3.
         assumption.
      -- destruct t4 as [|h5 t5]; try discriminate.
         destruct (flat_extract_const h1 t) eqn: flat_h1; try discriminate.
         apply flat_extract_const_eval with (stack:=stack)(ops:=ops) in flat_h1.
         destruct (flat_extract_const h2 t) eqn: flat_h2; try discriminate.
         apply flat_extract_const_eval with (stack:=stack)(ops:=ops) in flat_h2.
         destruct (flat_extract_const h3 t) eqn: flat_h3; try discriminate.
         apply flat_extract_const_eval with (stack:=stack)(ops:=ops) in flat_h3.
         destruct (flat_extract_const h4 t) eqn: flat_h4; try discriminate.
         apply flat_extract_const_eval with (stack:=stack)(ops:=ops) in flat_h4.
         simpl.
         rewrite -> flat_h1. rewrite -> flat_h2. 
         rewrite -> flat_h3. rewrite -> flat_h4.            
         assumption.
Qed. 


(* Main lemma: every stack value is evaluated to the same value in the 
   original map and also in the optimized one with EVAL *)
Lemma eq_eval_opt_eval: forall (m1 m2: asfs_map) (ops: opm) (n: nat)
  (stack: tstack),
optimize_map_eval ops n m1 = Some m2 ->
forall (elem: asfs_stack_val), eval_asfs2_elem stack elem m1 ops =
                               eval_asfs2_elem stack elem m2 ops.
Proof.
intro m1. induction m1 as [|h t IH].
- intros. destruct elem as [val|var|fvar] eqn: eq_elem.
  + rewrite -> eval_asfs2_val. rewrite -> eval_asfs2_val. reflexivity.
  + rewrite -> eval_asfs2_instackvar. rewrite -> eval_asfs2_instackvar.
    reflexivity.
  + simpl optimize_map_eval in H. discriminate.
- intros. destruct elem as [val|var|fvar] eqn: eq_elem.
  + rewrite -> eval_asfs2_val. rewrite -> eval_asfs2_val. reflexivity.
  + rewrite -> eval_asfs2_instackvar. rewrite -> eval_asfs2_instackvar.
    reflexivity.
  + simpl in H. destruct h as [mn mv] eqn: eq_h.
    destruct (mn =? n) eqn: eq_mn_n.
    * destruct mv as [basicv|op args] eqn: eq_mv; try discriminate.
      destruct (is_fully_defined op) eqn: eq_fully_def_op; try discriminate.
      destruct (const_list args t) as [wargs|] eqn: eq_const_list; 
        try discriminate.
      destruct (ops op) as [o|] eqn: eq_ops_op; try discriminate.
      destruct o as [comm nargs func] eqn: eq_o.
      destruct (length args =? nargs) eqn: eq_len_args; try discriminate.
      destruct (func wargs) as [v|] eqn: eq_func; try discriminate.
      injection H as H. rewrite <- H.
      simpl. destruct (mn =? fvar) eqn: eq_mn_fvar; try reflexivity.
      rewrite -> eq_ops_op.
      rewrite -> eval_asfs2_val.
      apply const_list_apply_f with (stack:=stack)(ops:=ops) in 
        eq_const_list as Happly_f.
      rewrite -> Happly_f. rewrite -> eq_len_args.
      assumption.
    * destruct (optimize_map_eval ops n t) as [map'|] eqn: eq_opt_n_t;
        try discriminate.
      injection H as H. rewrite <- H.
      simpl. destruct (mn =? fvar) eqn: eq_mn_fvar.
      -- destruct mv as [basicv|op args] eqn: eq_mv.
         ++ apply IH with (n:=n); try assumption.
         ++ destruct (ops op) as [o|] eqn: eq_ops_op; try reflexivity.
            destruct o as [comm nargs func] eqn: eq_o.
            destruct (length args =? nargs) eqn: eq_len_args; try reflexivity.
            pose proof (IH map' ops n stack eq_opt_n_t) as IHelem.
            pose proof (eval_elem_fun stack t map' ops IHelem) as HH.
            pose proof (@functional_extensionality asfs_stack_val 
              (option EVMWord)
              (fun elem' : asfs_stack_val => eval_asfs2_elem stack elem' t ops)
              (fun elem' : asfs_stack_val => eval_asfs2_elem stack elem' map' ops)
              HH) as eq_funs.
            rewrite -> eq_funs.
            reflexivity.
      -- apply IH with (n:=n); try assumption.
Qed.

Lemma optimize_eval_height: forall (n h1 mx1 h2 mx2: nat) (s1 s2: asfs_stack)
  (m1 m2: asfs_map),
optimize_eval_fvar n (ASFSc h1 mx1 s1 m1) = Some (ASFSc h2 mx2 s2 m2)
-> h1 = h2.
Proof.
intros. simpl in H. destruct m1 as [|hh tt] eqn: eq_m1.
- simpl in H. discriminate. 
- simpl in H. destruct hh as [fvar val].
  destruct (fvar =? n) eqn: eq_fvar_n.
  + destruct val as [basic|oper args]; try discriminate.
    destruct (is_fully_defined oper); try discriminate.
    destruct (const_list args tt); try discriminate.
    destruct (opmap oper); try discriminate.
    destruct o; try discriminate.
    destruct (length args =? nb_args); try discriminate.
    destruct (func l); try discriminate.
    injection H as Hhh. assumption.
  + destruct (optimize_map_eval opmap n tt) ; try discriminate.
    injection H as Hhh. assumption.
  Qed.

Theorem optimize_eval_fvar_eq: forall (a1 a2: asfs) (fresh_var: nat),
optimize_eval_fvar fresh_var a1 = Some a2 ->
forall (c: tstack), eval_asfs c a1 opmap = eval_asfs c a2 opmap.
Proof.
intros.
destruct a1 as [h1 maxid1 s1 m1] eqn: eq_a1.
destruct a2 as [h2 maxid2 s2 m2] eqn: eq_a2.
simpl in H.
destruct (optimize_map_eval opmap fresh_var m1) eqn: eq_opt_eval_map;
  try discriminate.
injection H as Hh1h2 Hmaxid1_2 Hs1s2 Hm1a.
rewrite -> Hm1a in eq_opt_eval_map.
pose proof (eq_eval_opt_eval m1 m2 opmap fresh_var c eq_opt_eval_map)
  as Hall_elem_eval_same_m1_m2.
simpl. rewrite -> Hh1h2. rewrite -> Hs1s2.
destruct (length c =? h2); try reflexivity.
apply eq_eval_elem_stack. assumption.
Qed.

Lemma opt_eval_same_fvar_in_maps: forall (n: nat)
  (m1 m2: asfs_map) (ops: opm),
optimize_map_eval ops n m1 = Some m2 ->
same_fvar_in_maps m1 m2.
Proof.
intros n m1. revert n.
induction m1 as [| h t IH].
- intros n m2 ops Hopt. simpl in Hopt. discriminate.
- intros n m2 ops Hopt.
  simpl in Hopt.
  destruct h as [fvar efvar] eqn: eq_h.
  destruct (fvar =? n) eqn: eq_fvar_n.
  + destruct efvar eqn: eq_efvar; try discriminate.
    destruct (is_fully_defined opcode); try discriminate.
    destruct (const_list args t) as [wargs|]; try discriminate.
    destruct (ops opcode) as [o|]; try discriminate.
    destruct o as [comm nargs f]; try discriminate.
    destruct (length args =? nargs); try discriminate.
    destruct (f wargs); try discriminate.
    injection Hopt as Hm2. rewrite <- Hm2.
    simpl. split; try reflexivity.
    apply same_fvar_refl.
  + destruct (optimize_map_eval ops n t) as [map'|] eqn: optimize_t;
      try discriminate.
    injection Hopt as Hm2. rewrite <- Hm2. simpl. split; try reflexivity.
    apply IH with (n:=n)(ops:=ops). assumption.
Qed.

Lemma opt_eval_decreasingness_preservation: forall (n: nat)
  (m1 m2: asfs_map) (ops: opm),
strictly_decreasing_map m1 ->
optimize_map_eval ops n m1 = Some m2 ->
strictly_decreasing_map m2.
Proof.
intros.
apply opt_eval_same_fvar_in_maps in H0.
apply same_fvar_in_map_preserves_decreasingness with (m1:=m1);
  try assumption.
Qed.



Lemma optimize_eval_fvar_safe:
safe_optimization_fvar optimize_eval_fvar.
Proof.
intros. unfold safe_optimization_fvar. intros.
split.
- pose proof (optimize_eval_fvar_eq a opt_a n H0 c) as H2.
  rewrite -> H2 in H. assumption.
- unfold valid_asfs.
  destruct opt_a as [hopt maxopt sopt mopt] eqn: eq_opt_a.
  destruct a as [ha maxa sa ma] eqn: eq_a.
  simpl in H1. simpl in H0.
  destruct (optimize_map_eval opmap n ma) eqn: optimize_ma; try discriminate.
  injection H0 as eq_h eq_max eq_stack eq_maps. 
  rewrite -> eq_maps in optimize_ma.
  destruct H1 as [Hfreshv Hdecr].
  rewrite <- eq_max.
  rewrite <- eq_maps.
  split.
  + apply same_fvar_in_map_preserves_fresh_var_gt with (m1:=ma).
    * assumption.
    * apply opt_eval_same_fvar_in_maps with (ops:=opmap)(n:=n).
      rewrite -> eq_maps. assumption.
  + apply opt_eval_decreasingness_preservation with (n:=n)(m1:=ma)(ops:=opmap)
      (m2:=a0) in Hdecr.
    * assumption.
    * rewrite -> eq_maps. assumption.
Qed.

Theorem optimize_eval_safe:
safe_optimization optimize_eval.
Proof.
apply optimize_fresh_var_preservation.
apply optimize_eval_fvar_safe. 
Qed.





(*******************************************
  Optimization DIV(X,1) --> X 
********************************************)
Fixpoint optimize_map_div_one (fresh_var: nat) (map: asfs_map): 
  option asfs_map :=
match map with
| [] => None
| (n, val)::t => if n =? fresh_var then
                 match val with
                 | ASFSOp DIV [arg1; arg2] => 
                     if stack_val_has_value' arg2 t WOne then
                       Some ((n, ASFSBasicVal arg1)::t)
                     else None
                 | _ => None
                 end
                 else match optimize_map_div_one fresh_var t with 
                      | None => None
                      | Some map' => Some ((n, val)::map')
                      end
end.

Lemma evm_div_one: forall (x: EVMWord), evm_div [x; WOne] = Some x.
Proof.
intros. simpl. unfold wdiv. unfold wordBin. simpl. 
rewrite -> N.div_1_r. rewrite -> NToWord_wordToN.
reflexivity.
Qed.
 

Definition optimize_div_one_fvar (fresh_var: nat) (s: asfs) : option asfs :=
optimize_func_map optimize_map_div_one fresh_var s.

(* This is the main optimization *)
Definition optimize_div_one (a: asfs) : asfs*bool :=
optimize_fresh_var optimize_div_one_fvar a.

Lemma eq_eval_opt_div_one: forall (m1 m2: asfs_map) (ops: opm) (n: nat)
  (stack: tstack),
ops DIV = Some (Op false 2 evm_div) ->
optimize_map_div_one n m1 = Some m2 ->
forall (elem: asfs_stack_val), eval_asfs2_elem stack elem m1 ops =
                               eval_asfs2_elem stack elem m2 ops.
Proof.
induction m1 as [|h t IH].
- intros. simpl in H0. discriminate.
- intros. simpl in H0. destruct h as [hn hv] eqn: eq_h.
  destruct (hn =? n) eqn: eq_hn_n.
  + (* We have found the fresh variable to optimize in the map *) 
    destruct (hv) as [basicval|opval] eqn: eq_hv; try discriminate.
    destruct (opval) eqn: eq_opval; try discriminate.
    destruct args as [| arg1 ta]; try discriminate.
    destruct ta as [| arg2 tta]; try discriminate.
    destruct tta; try discriminate.
    destruct (stack_val_has_value' arg2 t WOne ) eqn: eq_arg2_one;
      try discriminate.
    injection H0 as eq_m2. rewrite <- eq_m2.
    destruct elem as [val|var|fvar] eqn: eq_elem.
    * apply eval_asfs2_val.
    * apply eval_var.
    * simpl. destruct (hn =? fvar) eqn: eq_vame_fvar.
      -- rewrite -> H. 
         destruct (eval_asfs2_elem stack arg1 t ops) as [arg1_val|]
           eqn: eq_eval_arg2; try reflexivity.
         rewrite -> stack_val_has_value_eval' with (v:=WOne);
              try assumption.
         apply evm_div_one. 
      -- fold eval_asfs2_elem. reflexivity.
  + (* This is not yet the fresh variable to optimize*) 
    destruct (optimize_map_div_one n t) as [map'|] eqn: eq_optimize_t; 
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

Theorem optimize_div_one_fvar_eq: forall (a1 a2: asfs) (fresh_var: nat)
  (c: tstack) (ops: opm),
ops DIV = Some (Op false 2 evm_div) ->
optimize_div_one_fvar fresh_var a1 = Some a2 ->
eval_asfs c a1 ops = eval_asfs c a2 ops.
Proof.
intros.
destruct a1 as [h1 maxid1 s1 m1] eqn: eq_a1.
destruct a2 as [h2 maxid2 s2 m2] eqn: eq_a2.
simpl in H0.
destruct (optimize_map_div_one fresh_var m1) eqn: eq_opt_map;
  try discriminate.
injection H0 as Hh1h2 Hmaxid1_2 Hs1s2 Hm1a.
rewrite -> Hm1a in eq_opt_map.
pose proof (eq_eval_opt_div_one m1 m2 ops fresh_var c H eq_opt_map)
  as Hall_elem_eval_same_m1_m2.
simpl. rewrite -> Hh1h2. rewrite -> Hs1s2.
destruct (length c =? h2); try reflexivity.
apply eq_eval_elem_stack. assumption.
Qed.


Lemma opt_div_one_same_fvar_in_maps: forall (n: nat)
  (m1 m2: asfs_map),
optimize_map_div_one n m1 = Some m2 ->
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
    destruct (stack_val_has_value' arg2 t WOne); try discriminate.
    injection Hopt as eq_m2. rewrite <- eq_m2.
    simpl. split; try reflexivity.
    apply same_fvar_refl.
  + destruct (optimize_map_div_one n t) as [t_opt|] eqn: optimize_t;
      try discriminate.
    pose proof (strictly_decreasing_preserv fvar efvar t) 
      as Hdecr_t.
    pose proof (IH n t_opt optimize_t).
    simpl. injection Hopt as eq_m2. rewrite <- eq_m2.
    split; try reflexivity. assumption.
Qed.


Lemma opt_div_one_decreasingness_preservation: forall (n: nat)
  (m1 m2: asfs_map),
strictly_decreasing_map m1 ->
optimize_map_div_one n m1 = Some m2 ->
strictly_decreasing_map m2.
Proof.
intros.
apply opt_div_one_same_fvar_in_maps in H0.
apply same_fvar_in_map_preserves_decreasingness with (m1:=m1);
  try assumption.
Qed.


Lemma optimize_div_one_fvar_safe:
safe_optimization_fvar optimize_div_one_fvar.
Proof.
unfold safe_optimization_fvar. intros.
split.
- assert (opmap DIV = Some (Op false 2 evm_div)) as Hopmap; try reflexivity.
  pose proof (optimize_div_one_fvar_eq a opt_a n c opmap Hopmap H0)
    as Heq_eval_a_opta.
  rewrite -> Heq_eval_a_opta in H.
  rewrite -> H.
  split; try reflexivity.
- unfold valid_asfs.
  destruct opt_a as [hopt maxopt sopt mopt] eqn: eq_opt_a.
  destruct a as [ha maxa sa ma] eqn: eq_a.
  simpl in H1. simpl in H0.
  destruct (optimize_map_div_one n ma) eqn: optimize_ma; try discriminate.
  injection H0 as eq_h eq_max eq_stack eq_maps. 
  rewrite -> eq_maps in optimize_ma.
  destruct H1 as [Hfreshv Hdecr].
  rewrite <- eq_max.
  rewrite <- eq_maps.
  split.
  + apply same_fvar_in_map_preserves_fresh_var_gt with (m1:=ma).
    * assumption.
    * apply opt_div_one_same_fvar_in_maps with (n:=n).
      rewrite -> eq_maps. assumption.
  + apply opt_div_one_decreasingness_preservation with (n:=n) (m1:=ma) 
      (m2:=a0) in Hdecr.
    * assumption.
    * rewrite -> eq_maps. assumption.
Qed.

Theorem optimize_div_one_safe:
safe_optimization optimize_div_one.
Proof.
apply optimize_fresh_var_preservation.
apply optimize_div_one_fvar_safe.
Qed.




(*************************************************
  Optimization EQ(X,0) or EQ(0,X) --> ISZERO(X)
**************************************************)
Fixpoint optimize_map_eq_zero (fresh_var: nat) (map: asfs_map): 
  option asfs_map :=
match map with
| [] => None
| (n, val)::t => if n =? fresh_var then
                 match val with
                 | ASFSOp EQ [arg1; arg2] => 
                     if stack_val_has_value' arg1 t WZero then
                       Some ((n, ASFSOp ISZERO [arg2])::t)
                     else if stack_val_has_value' arg2 t WZero then
                       Some ((n, ASFSOp ISZERO [arg1])::t)
                     else None
                 | _ => None
                 end
                 else match optimize_map_eq_zero fresh_var t with 
                      | None => None
                      | Some map' => Some ((n, val)::map')
                      end
end.

Lemma eq_zero_iszero1: forall (x: EVMWord),
evm_eq [WZero; x] = evm_iszero [x].
Proof.
intros. unfold evm_eq.
destruct (weqb WZero x) eqn: H.
- apply weqb_sound in H. rewrite <- H. reflexivity.
- unfold evm_iszero. unfold evm_eq.
  apply weqb_false in H. apply not_eq_sym in H. apply weqb_ne in H.
  rewrite -> H. reflexivity.
Qed.

Lemma eq_zero_iszero2: forall (x: EVMWord),
evm_eq [x; WZero] = evm_iszero [x].
Proof.
intros. unfold evm_eq.
destruct (weqb WZero x) eqn: H.
- apply weqb_sound in H. rewrite <- H. reflexivity.
- unfold evm_iszero. unfold evm_eq. reflexivity.
Qed.

Definition optimize_eq_zero_fvar (fresh_var: nat) (s: asfs) : option asfs :=
optimize_func_map optimize_map_eq_zero fresh_var s.

(* This is the main optimization *)
Definition optimize_eq_zero (a: asfs) : asfs*bool :=
optimize_fresh_var optimize_eq_zero_fvar a.

Lemma eq_eval_opt_eq_zero: forall (m1 m2: asfs_map) (ops: opm) (n: nat)
  (stack: tstack),
ops EQ = Some (Op true 2 evm_eq) ->
ops ISZERO = Some (Op false 1 evm_iszero) ->
optimize_map_eq_zero n m1 = Some m2 ->
forall (elem: asfs_stack_val), eval_asfs2_elem stack elem m1 ops =
                               eval_asfs2_elem stack elem m2 ops.
Proof.
induction m1 as [|h t IH].
- intros. simpl in H1. discriminate.
- intros. simpl in H1. destruct h as [hn hv] eqn: eq_h.
  destruct (hn =? n) eqn: eq_hn_n.
  + (* We have found the fresh variable to optimize in the map *) 
    destruct (hv) as [basicval|opval] eqn: eq_hv; try discriminate.
    destruct (opval) eqn: eq_opval; try discriminate.
    destruct args as [| arg1 ta]; try discriminate.
    destruct ta as [| arg2 tta]; try discriminate.
    destruct tta; try discriminate.
    destruct (stack_val_has_value' arg1 t WZero) eqn: eq_arg1_zero;
      try discriminate.
    * (* arg1 is WZero *)
      injection H1 as eq_m2. rewrite <- eq_m2.
      destruct elem as [val|var|fvar] eqn: eq_elem.
      -- apply eval_asfs2_val.
      -- apply eval_var.
      -- simpl. destruct (hn =? fvar) eqn: eq_vame_fvar.
         ++ rewrite -> H. simpl. rewrite -> H0.
            rewrite -> stack_val_has_value_eval' with (v:=WZero);
               try assumption.
            destruct (eval_asfs2_elem stack arg2 t ops) as [arg2_val|]
               eqn: eq_eval_arg2; try reflexivity.
            apply eq_zero_iszero1.
         ++ fold eval_asfs2_elem. reflexivity.
    * (* arg2 is WZero *)
      destruct (stack_val_has_value' arg2 t WZero) eqn: eq_arg2_zero;
        try discriminate.
      injection H1 as eq_m2. rewrite <- eq_m2.
      destruct elem as [val|var|fvar] eqn: eq_elem.
      -- apply eval_asfs2_val.
      -- apply eval_var.
      -- simpl. destruct (hn =? fvar) eqn: eq_vame_fvar.
         ++ rewrite -> H. simpl. rewrite -> H0.
            destruct (eval_asfs2_elem stack arg1 t ops) as [arg1_val|]
               eqn: eq_eval_arg1; try reflexivity.
            rewrite -> stack_val_has_value_eval' with (v:=WZero);
               try assumption.
            apply eq_zero_iszero2.
         ++ fold eval_asfs2_elem. reflexivity.
  + (* This is not yet the fresh variable to optimize*) 
    destruct (optimize_map_eq_zero n t) as [map'|] eqn: eq_optimize_t; 
      try discriminate.
    injection H1 as H1. rewrite <- H1. 
    destruct elem as [val|var|fvar] eqn: eq_elem; try reflexivity.
    simpl. destruct (hn =? fvar) eqn: eq_hn_fvar.
    * destruct hv eqn: eq_hv.
      -- apply IH with (n:=n); try assumption.
      -- rewrite -> eval_asfs2_ho. rewrite -> eval_asfs2_ho.
         pose proof (IH map' ops n stack H H0 eq_optimize_t) as IHc.
         pose proof (eq_eval_elem_stack stack t map' ops args IHc) as
           eq_eval_t_map'.
         rewrite -> eq_eval_t_map'. reflexivity.
    * apply IH with (n:=n); try assumption.
Qed.

Theorem optimize_eq_zero_fvar_eq: forall (a1 a2: asfs) (fresh_var: nat)
  (c: tstack) (ops: opm),
ops EQ = Some (Op true 2 evm_eq) ->
ops ISZERO = Some (Op false 1 evm_iszero) ->
optimize_eq_zero_fvar fresh_var a1 = Some a2 ->
eval_asfs c a1 ops = eval_asfs c a2 ops.
Proof.
intros.
destruct a1 as [h1 maxid1 s1 m1] eqn: eq_a1.
destruct a2 as [h2 maxid2 s2 m2] eqn: eq_a2.
simpl in H1.
destruct (optimize_map_eq_zero fresh_var m1) eqn: eq_opt_map;
  try discriminate.
injection H1 as Hh1h2 Hmaxid1_2 Hs1s2 Hm1a.
rewrite -> Hm1a in eq_opt_map.
pose proof (eq_eval_opt_eq_zero m1 m2 ops fresh_var c H H0 eq_opt_map)
  as Hall_elem_eval_same_m1_m2.
simpl. rewrite -> Hh1h2. rewrite -> Hs1s2.
destruct (length c =? h2); try reflexivity.
apply eq_eval_elem_stack. assumption.
Qed.


Lemma opt_eq_zero_same_fvar_in_maps: forall (n: nat)
  (m1 m2: asfs_map),
optimize_map_eq_zero n m1 = Some m2 ->
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
    destruct (stack_val_has_value' arg1 t WZero).
    * injection Hopt as eq_m2. rewrite <- eq_m2.
      simpl. split; try reflexivity.
      apply same_fvar_refl.
    * destruct (stack_val_has_value' arg2 t WZero); try discriminate.
      injection Hopt as eq_m2. rewrite <- eq_m2.
      simpl. split; try reflexivity.
      apply same_fvar_refl.
  + destruct (optimize_map_eq_zero n t) as [t_opt|] eqn: optimize_t;
      try discriminate.
    pose proof (strictly_decreasing_preserv fvar efvar t) 
      as Hdecr_t.
    pose proof (IH n t_opt optimize_t).
    simpl. injection Hopt as eq_m2. rewrite <- eq_m2.
    split; try reflexivity. assumption.
Qed.


Lemma opt_eq_zero_decreasingness_preservation: forall (n: nat)
  (m1 m2: asfs_map),
strictly_decreasing_map m1 ->
optimize_map_eq_zero n m1 = Some m2 ->
strictly_decreasing_map m2.
Proof.
intros.
apply opt_eq_zero_same_fvar_in_maps in H0.
apply same_fvar_in_map_preserves_decreasingness with (m1:=m1);
  try assumption.
Qed.


Lemma optimize_eq_zero_fvar_safe:
safe_optimization_fvar optimize_eq_zero_fvar.
Proof.
unfold safe_optimization_fvar. intros.
split.
- assert (opmap EQ = Some (Op true 2 evm_eq)) as Hopmap; try reflexivity.
  assert (opmap ISZERO = Some (Op false 1 evm_iszero)) as Hopmap'; try reflexivity.
  pose proof (optimize_eq_zero_fvar_eq a opt_a n c opmap Hopmap Hopmap' H0)
    as Heq_eval_a_opta.
  rewrite -> Heq_eval_a_opta in H.
  rewrite -> H.
  split; try reflexivity.
- unfold valid_asfs.
  destruct opt_a as [hopt maxopt sopt mopt] eqn: eq_opt_a.
  destruct a as [ha maxa sa ma] eqn: eq_a.
  simpl in H1. simpl in H0.
  destruct (optimize_map_eq_zero n ma) eqn: optimize_ma; try discriminate.
  injection H0 as eq_h eq_max eq_stack eq_maps. 
  rewrite -> eq_maps in optimize_ma.
  destruct H1 as [Hfreshv Hdecr].
  rewrite <- eq_max.
  rewrite <- eq_maps.
  split.
  + apply same_fvar_in_map_preserves_fresh_var_gt with (m1:=ma).
    * assumption.
    * apply opt_eq_zero_same_fvar_in_maps with (n:=n).
      rewrite -> eq_maps. assumption.
  + apply opt_eq_zero_decreasingness_preservation with (n:=n) (m1:=ma) 
      (m2:=a0) in Hdecr.
    * assumption.
    * rewrite -> eq_maps. assumption.
Qed.

Theorem optimize_eq_zero_safe:
safe_optimization optimize_eq_zero.
Proof.
apply optimize_fresh_var_preservation.
apply optimize_eq_zero_fvar_safe. 
Qed.




(*************************************************
  Optimization GT(1,X) --> ISZERO(X)
**************************************************)
Fixpoint optimize_map_gt_one (fresh_var: nat) (map: asfs_map): 
  option asfs_map :=
match map with
| [] => None
| (n, val)::t => if n =? fresh_var then
                 match val with
                 | ASFSOp GT [arg1; arg2] => 
                     if stack_val_has_value' arg1 t WOne then
                       Some ((n, ASFSOp ISZERO [arg2])::t)
                     else None
                 | _ => None
                 end
                 else match optimize_map_gt_one fresh_var t with 
                      | None => None
                      | Some map' => Some ((n, val)::map')
                      end
end.

Lemma gt_iszero_natb: forall (x: nat),
x <? 1 = true <-> x = 0.
Proof.
split.
- intros. destruct x as [|x'].
  + reflexivity.
  + simpl in H. unfold ltb in H. simpl in H. discriminate.
- intros. rewrite -> H. auto.
Qed.

Lemma gt_iszero_nat: forall (x: nat),
x < 1 <-> x = 0.
Proof.
intros. rewrite <- Nat.ltb_lt. apply gt_iszero_natb.
Qed.

Lemma gt_iszero_nat'b: forall (x: nat),
x <? 1 = false <-> x <> 0.
Proof.
split.
- intros. destruct x as [|x'].
  + unfold ltb in H. rewrite -> Nat.leb_refl in H. discriminate.
  + auto.
- intros. destruct x as [|x']. 
  + unfold not in H. exfalso. auto.
  + unfold ltb. simpl. reflexivity.
Qed.

Lemma gt_iszero_natb': forall (x: nat),
x <? 1 = false <-> x <> 0.
Proof.
split.
- intros. destruct x as [|x'].
  + unfold ltb in H. rewrite -> Nat.leb_refl in H. discriminate.
  + auto.
- intros. destruct x as [|x']. 
  + unfold not in H. exfalso. auto.
  + unfold ltb. simpl. reflexivity.
Qed.

Lemma gt_lt_symm: forall (x y: nat), x >= y <-> y <= x.
Proof.
intros. unfold ge. split; try auto.
Qed.

Lemma gte_not_ltb: forall (x: nat),
x <? 1 = false <-> x >= 1.
Proof.
intros. rewrite -> gt_lt_symm. split.
- rewrite -> Nat.ltb_ge. auto. 
- rewrite -> Nat.ltb_nlt. apply le_not_lt. 
Qed.

Lemma gt_iszero_nat': forall (x: nat),
x >= 1 <-> x <> 0.
Proof.
intros. rewrite <- gte_not_ltb. apply gt_iszero_natb'.
Qed.


(* 
   N.ltb_lt: forall n m : N, (n <? m)%N = true <-> (n < m)%N
   N.ltb_ge: forall x y : N, (x <? y)%N = false <-> (y <= x)%N
  
   Nlt_in: forall n m : N, N.to_nat n < N.to_nat m -> (n < m)%N
   Nlt_out: forall n m : N, (n < m)%N -> N.to_nat n < N.to_nat m
   N.le_ge: forall n m : N, (n <= m)%N -> (m >= n)%N 
   Nge_out: forall n m : N, (n >= m)%N -> N.to_nat n >= N.to_nat m   
   
   Nneq_out: forall n m : N, n <> m -> N.to_nat n <> N.to_nat m
   Nneq_in: forall n m : N, N.to_nat n <> N.to_nat m -> n <> m
   
   nat_of_N_eq: forall n m : N, N.to_nat n = N.to_nat m -> n = m
*)
Lemma word_neq_zero: forall (x: EVMWord),
N.to_nat (wordToN x) <> 0 -> x <> WZero.
Proof.
intros. destruct (weqb x WZero) eqn: eq_x_wzero.
- apply weqb_sound in eq_x_wzero. rewrite eq_x_wzero in H.
  simpl in H. auto.
- apply weqb_false. assumption.
Qed.

Lemma Ntonat_1: (N.to_nat 1)%N = S 0.
Proof. auto. Qed.

Lemma Ntonat_0: (N.to_nat 0)%N = 0.
Proof. auto. Qed.

Lemma one_as_N:
N.to_nat (1)%N = 1.
Proof. auto. Qed.

Lemma gt_iszero: forall (x: EVMWord),
evm_gt [WOne; x] = evm_iszero [x].
Proof.
intros. simpl. destruct ((wordToN x <? 1)%N) eqn: H1.
- apply N.ltb_lt in H1.
  apply Nlt_out in H1. rewrite -> one_as_N in H1.
  apply gt_iszero_nat in H1.
  rewrite -> wordToN_to_nat in H1.
  apply wordToNat_eq_natToWord in H1. 
  rewrite -> H1. reflexivity.
- apply N.ltb_ge in H1.
  apply N.le_ge in H1.
  apply Nge_out in H1. rewrite -> one_as_N in H1.
  apply gt_iszero_nat' in H1.
  apply word_neq_zero in H1.
  simpl. apply weqb_ne in H1. rewrite -> H1.
  reflexivity.
Qed.

Definition optimize_gt_one_fvar (fresh_var: nat) (s: asfs) : option asfs :=
optimize_func_map optimize_map_gt_one fresh_var s.

(* This is the main optimization *)
Definition optimize_gt_one (a: asfs) : asfs*bool :=
optimize_fresh_var optimize_gt_one_fvar a.

Lemma eq_eval_opt_gt_one: forall (m1 m2: asfs_map) (ops: opm) (n: nat)
  (stack: tstack),
ops GT = Some (Op false 2 evm_gt) ->
ops ISZERO = Some (Op false 1 evm_iszero) ->
optimize_map_gt_one n m1 = Some m2 ->
forall (elem: asfs_stack_val), eval_asfs2_elem stack elem m1 ops =
                               eval_asfs2_elem stack elem m2 ops.
Proof.
induction m1 as [|h t IH].
- intros. simpl in H1. discriminate.
- intros. simpl in H1. destruct h as [hn hv] eqn: eq_h.
  destruct (hn =? n) eqn: eq_hn_n.
  + (* We have found the fresh variable to optimize in the map *) 
    destruct (hv) as [basicval|opval] eqn: eq_hv; try discriminate.
    destruct (opval) eqn: eq_opval; try discriminate.
    destruct args as [| arg1 ta]; try discriminate.
    destruct ta as [| arg2 tta]; try discriminate.
    destruct tta; try discriminate.
    destruct (stack_val_has_value' arg1 t WOne ) eqn: eq_arg1_one;
      try discriminate.
    injection H1 as eq_m2. rewrite <- eq_m2.
    destruct elem as [val|var|fvar] eqn: eq_elem.
    * apply eval_asfs2_val.
    * apply eval_var.
    * unfold eval_asfs2_elem. destruct (hn =? fvar) eqn: eq_vame_fvar.
      -- rewrite -> H. simpl. fold eval_asfs2_elem.
         rewrite -> stack_val_has_value_eval' with (v:=WOne);
           try assumption.
         rewrite -> H0.
         destruct (eval_asfs2_elem stack arg2 t ops) as [arg2_val|]
           eqn: eq_eval_arg2; try reflexivity.
         apply gt_iszero.
      -- fold eval_asfs2_elem. reflexivity.
  + (* This is not yet the fresh variable to optimize*) 
    destruct (optimize_map_gt_one n t) as [map'|] eqn: eq_optimize_t; 
      try discriminate.
    injection H1 as H1. rewrite <- H1. 
    destruct elem as [val|var|fvar] eqn: eq_elem; try reflexivity.
    simpl. destruct (hn =? fvar) eqn: eq_hn_fvar.
    * destruct hv eqn: eq_hv.
      -- apply IH with (n:=n); try assumption.
      -- rewrite -> eval_asfs2_ho. rewrite -> eval_asfs2_ho.
         pose proof (IH map' ops n stack H H0 eq_optimize_t) as IHc.
         pose proof (eq_eval_elem_stack stack t map' ops args IHc) as
           eq_eval_t_map'.
         rewrite -> eq_eval_t_map'. reflexivity.
    * apply IH with (n:=n); try assumption.
Qed.

Theorem optimize_gt_one_fvar_eq: forall (a1 a2: asfs) (fresh_var: nat)
  (c: tstack) (ops: opm),
ops GT = Some (Op false 2 evm_gt) ->
ops ISZERO = Some (Op false 1 evm_iszero) ->
optimize_gt_one_fvar fresh_var a1 = Some a2 ->
eval_asfs c a1 ops = eval_asfs c a2 ops.
Proof.
intros.
destruct a1 as [h1 maxid1 s1 m1] eqn: eq_a1.
destruct a2 as [h2 maxid2 s2 m2] eqn: eq_a2.
simpl in H1.
destruct (optimize_map_gt_one fresh_var m1) eqn: eq_opt_map;
  try discriminate.
injection H1 as Hh1h2 Hmaxid1_2 Hs1s2 Hm1a.
rewrite -> Hm1a in eq_opt_map.
pose proof (eq_eval_opt_gt_one m1 m2 ops fresh_var c H H0 eq_opt_map)
  as Hall_elem_eval_same_m1_m2.
simpl. rewrite -> Hh1h2. rewrite -> Hs1s2.
destruct (length c =? h2); try reflexivity.
apply eq_eval_elem_stack. assumption.
Qed.


Lemma opt_gt_one_same_fvar_in_maps: forall (n: nat)
  (m1 m2: asfs_map),
optimize_map_gt_one n m1 = Some m2 ->
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
    destruct (stack_val_has_value' arg1 t WOne); try discriminate.
    injection Hopt as eq_m2. rewrite <- eq_m2.
    simpl. split; try reflexivity.
    apply same_fvar_refl.
  + destruct (optimize_map_gt_one n t) as [t_opt|] eqn: optimize_t;
      try discriminate.
    pose proof (strictly_decreasing_preserv fvar efvar t) 
      as Hdecr_t.
    pose proof (IH n t_opt optimize_t).
    simpl. injection Hopt as eq_m2. rewrite <- eq_m2.
    split; try reflexivity. assumption.
Qed.


Lemma opt_gt_one_decreasingness_preservation: forall (n: nat)
  (m1 m2: asfs_map),
strictly_decreasing_map m1 ->
optimize_map_gt_one n m1 = Some m2 ->
strictly_decreasing_map m2.
Proof.
intros.
apply opt_gt_one_same_fvar_in_maps in H0.
apply same_fvar_in_map_preserves_decreasingness with (m1:=m1);
  try assumption.
Qed.


Lemma optimize_gt_one_fvar_safe:
safe_optimization_fvar optimize_gt_one_fvar.
Proof.
unfold safe_optimization_fvar. intros.
split.
- assert (opmap GT = Some (Op false 2 evm_gt)) as Hopmap; try reflexivity.
  assert (opmap ISZERO = Some (Op false 1 evm_iszero)) as Hopmap'; try reflexivity.
  pose proof (optimize_gt_one_fvar_eq a opt_a n c opmap Hopmap Hopmap' H0)
    as Heq_eval_a_opta.
  rewrite -> Heq_eval_a_opta in H.
  rewrite -> H.
  split; try reflexivity.
- unfold valid_asfs.
  destruct opt_a as [hopt maxopt sopt mopt] eqn: eq_opt_a.
  destruct a as [ha maxa sa ma] eqn: eq_a.
  simpl in H1. simpl in H0.
  destruct (optimize_map_gt_one n ma) eqn: optimize_ma; try discriminate.
  injection H0 as eq_h eq_max eq_stack eq_maps. 
  rewrite -> eq_maps in optimize_ma.
  destruct H1 as [Hfreshv Hdecr].
  rewrite <- eq_max.
  rewrite <- eq_maps.
  split.
  + apply same_fvar_in_map_preserves_fresh_var_gt with (m1:=ma).
    * assumption.
    * apply opt_gt_one_same_fvar_in_maps with (n:=n).
      rewrite -> eq_maps. assumption.
  + apply opt_gt_one_decreasingness_preservation with (n:=n) (m1:=ma) 
      (m2:=a0) in Hdecr.
    * assumption.
    * rewrite -> eq_maps. assumption.
Qed.

Theorem optimize_gt_one_safe:
safe_optimization optimize_gt_one.
Proof.
apply optimize_fresh_var_preservation.
apply optimize_gt_one_fvar_safe. 
Qed.



(*************************************************
  Optimization LT(X,1) --> ISZERO(X)
**************************************************)
Fixpoint optimize_map_lt_one (fresh_var: nat) (map: asfs_map): 
  option asfs_map :=
match map with
| [] => None
| (n, val)::t => if n =? fresh_var then
                 match val with
                 | ASFSOp LT [arg1; arg2] => 
                     if stack_val_has_value' arg2 t WOne then
                       Some ((n, ASFSOp ISZERO [arg1])::t)
                     else None
                 | _ => None
                 end
                 else match optimize_map_lt_one fresh_var t with 
                      | None => None
                      | Some map' => Some ((n, val)::map')
                      end
end.

Lemma evmgt_evmlt: forall (x y: EVMWord),
evm_gt [x;y] = evm_lt [y;x].
Proof.
intros. unfold evm_gt. reflexivity.
Qed.

Lemma lt_iszero: forall (x: EVMWord),
evm_lt [x; WOne] = evm_iszero [x].
Proof.
intros. rewrite <- evmgt_evmlt. 
apply gt_iszero. 
Qed.

Definition optimize_lt_one_fvar (fresh_var: nat) (s: asfs) : option asfs :=
optimize_func_map optimize_map_lt_one fresh_var s.

(* This is the main optimization *)
Definition optimize_lt_one (a: asfs) : asfs*bool :=
optimize_fresh_var optimize_lt_one_fvar a.

Lemma eq_eval_opt_lt_one: forall (m1 m2: asfs_map) (ops: opm) (n: nat)
  (stack: tstack),
ops LT = Some (Op false 2 evm_lt) ->
ops ISZERO = Some (Op false 1 evm_iszero) ->
optimize_map_lt_one n m1 = Some m2 ->
forall (elem: asfs_stack_val), eval_asfs2_elem stack elem m1 ops =
                               eval_asfs2_elem stack elem m2 ops.
Proof.
induction m1 as [|h t IH].
- intros. simpl in H1. discriminate.
- intros. simpl in H1. destruct h as [hn hv] eqn: eq_h.
  destruct (hn =? n) eqn: eq_hn_n.
  + (* We have found the fresh variable to optimize in the map *) 
    destruct (hv) as [basicval|opval] eqn: eq_hv; try discriminate.
    destruct (opval) eqn: eq_opval; try discriminate.
    destruct args as [| arg1 ta]; try discriminate.
    destruct ta as [| arg2 tta]; try discriminate.
    destruct tta; try discriminate.
    destruct (stack_val_has_value' arg2 t WOne ) eqn: eq_arg2_one;
      try discriminate.
    injection H1 as eq_m2. rewrite <- eq_m2.
    destruct elem as [val|var|fvar] eqn: eq_elem.
    * apply eval_asfs2_val.
    * apply eval_var.
    * unfold eval_asfs2_elem. destruct (hn =? fvar) eqn: eq_vame_fvar.
      -- rewrite -> H. simpl. fold eval_asfs2_elem.
         rewrite -> H0.
         destruct (eval_asfs2_elem stack arg1 t ops) as [arg1_val|]
           eqn: eq_eval_arg1; try reflexivity.
         rewrite -> stack_val_has_value_eval' with (v:=WOne);
           try assumption.
         apply lt_iszero.
      -- fold eval_asfs2_elem. reflexivity.
  + (* This is not yet the fresh variable to optimize*) 
    destruct (optimize_map_lt_one n t) as [map'|] eqn: eq_optimize_t; 
      try discriminate.
    injection H1 as H1. rewrite <- H1. 
    destruct elem as [val|var|fvar] eqn: eq_elem; try reflexivity.
    simpl. destruct (hn =? fvar) eqn: eq_hn_fvar.
    * destruct hv eqn: eq_hv.
      -- apply IH with (n:=n); try assumption.
      -- rewrite -> eval_asfs2_ho. rewrite -> eval_asfs2_ho.
         pose proof (IH map' ops n stack H H0 eq_optimize_t) as IHc.
         pose proof (eq_eval_elem_stack stack t map' ops args IHc) as
           eq_eval_t_map'.
         rewrite -> eq_eval_t_map'. reflexivity.
    * apply IH with (n:=n); try assumption.
Qed.

Theorem optimize_lt_one_fvar_eq: forall (a1 a2: asfs) (fresh_var: nat)
  (c: tstack) (ops: opm),
ops LT = Some (Op false 2 evm_lt) ->
ops ISZERO = Some (Op false 1 evm_iszero) ->
optimize_lt_one_fvar fresh_var a1 = Some a2 ->
eval_asfs c a1 ops = eval_asfs c a2 ops.
Proof.
intros.
destruct a1 as [h1 maxid1 s1 m1] eqn: eq_a1.
destruct a2 as [h2 maxid2 s2 m2] eqn: eq_a2.
simpl in H1.
destruct (optimize_map_lt_one fresh_var m1) eqn: eq_opt_map;
  try discriminate.
injection H1 as Hh1h2 Hmaxid1_2 Hs1s2 Hm1a.
rewrite -> Hm1a in eq_opt_map.
pose proof (eq_eval_opt_lt_one m1 m2 ops fresh_var c H H0 eq_opt_map)
  as Hall_elem_eval_same_m1_m2.
simpl. rewrite -> Hh1h2. rewrite -> Hs1s2.
destruct (length c =? h2); try reflexivity.
apply eq_eval_elem_stack. assumption.
Qed.


Lemma opt_lt_one_same_fvar_in_maps: forall (n: nat)
  (m1 m2: asfs_map),
optimize_map_lt_one n m1 = Some m2 ->
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
    destruct (stack_val_has_value' arg2 t WOne); try discriminate.
    injection Hopt as eq_m2. rewrite <- eq_m2.
    simpl. split; try reflexivity.
    apply same_fvar_refl.
  + destruct (optimize_map_lt_one n t) as [t_opt|] eqn: optimize_t;
      try discriminate.
    pose proof (strictly_decreasing_preserv fvar efvar t) 
      as Hdecr_t.
    pose proof (IH n t_opt optimize_t).
    simpl. injection Hopt as eq_m2. rewrite <- eq_m2.
    split; try reflexivity. assumption.
Qed.


Lemma opt_lt_one_decreasingness_preservation: forall (n: nat)
  (m1 m2: asfs_map),
strictly_decreasing_map m1 ->
optimize_map_lt_one n m1 = Some m2 ->
strictly_decreasing_map m2.
Proof.
intros.
apply opt_lt_one_same_fvar_in_maps in H0.
apply same_fvar_in_map_preserves_decreasingness with (m1:=m1);
  try assumption.
Qed.


Lemma optimize_lt_one_fvar_safe:
safe_optimization_fvar optimize_lt_one_fvar.
Proof.
unfold safe_optimization_fvar. intros.
split.
- assert (opmap LT = Some (Op false 2 evm_lt)) as Hopmap; try reflexivity.
  assert (opmap ISZERO = Some (Op false 1 evm_iszero)) as Hopmap'; try reflexivity.
  pose proof (optimize_lt_one_fvar_eq a opt_a n c opmap Hopmap Hopmap' H0)
    as Heq_eval_a_opta.
  rewrite -> Heq_eval_a_opta in H.
  rewrite -> H.
  split; try reflexivity.
- unfold valid_asfs.
  destruct opt_a as [hopt maxopt sopt mopt] eqn: eq_opt_a.
  destruct a as [ha maxa sa ma] eqn: eq_a.
  simpl in H1. simpl in H0.
  destruct (optimize_map_lt_one n ma) eqn: optimize_ma; try discriminate.
  injection H0 as eq_h eq_max eq_stack eq_maps. 
  rewrite -> eq_maps in optimize_ma.
  destruct H1 as [Hfreshv Hdecr].
  rewrite <- eq_max.
  rewrite <- eq_maps.
  split.
  + apply same_fvar_in_map_preserves_fresh_var_gt with (m1:=ma).
    * assumption.
    * apply opt_lt_one_same_fvar_in_maps with (n:=n).
      rewrite -> eq_maps. assumption.
  + apply opt_lt_one_decreasingness_preservation with (n:=n) (m1:=ma) 
      (m2:=a0) in Hdecr.
    * assumption.
    * rewrite -> eq_maps. assumption.
Qed.

Theorem optimize_lt_one_safe:
safe_optimization optimize_lt_one.
Proof.
apply optimize_fresh_var_preservation.
apply optimize_lt_one_fvar_safe. 
Qed.




(*************************************************
  Optimization OR(X,0) or OR(0,X) --> X
**************************************************)
Fixpoint optimize_map_or_zero (fresh_var: nat) (map: asfs_map): 
  option asfs_map :=
match map with
| [] => None
| (n, val)::t => if n =? fresh_var then
                 match val with
                 | ASFSOp OR [arg1; arg2] => 
                     if stack_val_has_value' arg1 t WZero then
                       Some ((n, ASFSBasicVal arg2)::t)
                     else if stack_val_has_value' arg2 t WZero then
                       Some ((n, ASFSBasicVal arg1)::t)
                     else None
                 | _ => None
                 end
                 else match optimize_map_or_zero fresh_var t with 
                      | None => None
                      | Some map' => Some ((n, val)::map')
                      end
end.

Lemma or_comm: forall (x y: EVMWord),
evm_or [x;y] = evm_or [y;x].
Proof.
intros. unfold evm_or. rewrite -> wor_comm. reflexivity.
Qed.

Lemma or_zero: forall (x: EVMWord),
evm_or [x;WZero] = Some x.
Proof.
intros. rewrite or_comm. unfold evm_or. rewrite -> wor_wzero. reflexivity.
Qed.


Definition optimize_or_zero_fvar (fresh_var: nat) (s: asfs) : option asfs :=
optimize_func_map optimize_map_or_zero fresh_var s.

Definition optimize_or_zero (a: asfs) : asfs*bool :=
optimize_fresh_var optimize_or_zero_fvar a.

Lemma eq_eval_opt_or_zero: forall (m1 m2: asfs_map) (ops: opm) (n: nat)
  (stack: tstack),
ops OR = Some (Op true 2 evm_or) ->
optimize_map_or_zero n m1 = Some m2 ->
forall (elem: asfs_stack_val), eval_asfs2_elem stack elem m1 ops =
                               eval_asfs2_elem stack elem m2 ops.
Proof.
induction m1 as [|h t IH].
- intros. simpl in H0. discriminate.
- intros. simpl in H0. destruct h as [hn hv] eqn: eq_h.
  destruct (hn =? n) eqn: eq_hn_n.
  + (* We have found the fresh variable to optimize in the map *) 
    destruct (hv) as [basicval|opval] eqn: eq_hv; try discriminate.
    destruct (opval) eqn: eq_opval; try discriminate.
    destruct args as [| arg1 ta]; try discriminate.
    destruct ta as [| arg2 tta]; try discriminate.
    destruct tta; try discriminate.
    destruct (stack_val_has_value' arg1 t WZero ) eqn: eq_arg1_zero.
    * (* arg1 is WZero *)
      injection H0 as eq_m2. rewrite <- eq_m2.
      destruct elem as [val|var|fvar] eqn: eq_elem.
      -- apply eval_asfs2_val.
      -- apply eval_var.
      -- unfold eval_asfs2_elem. destruct (hn =? fvar) eqn: eq_vame_fvar.
         ++ rewrite -> H. simpl. fold eval_asfs2_elem.
            rewrite -> stack_val_has_value_eval' with (v:=WZero);
              try assumption.
            destruct (eval_asfs2_elem stack arg2 t ops) as [arg2_val|]
              eqn: eq_eval_arg2; try reflexivity.
            rewrite -> or_comm. rewrite -> or_zero. reflexivity.
         ++ fold eval_asfs2_elem. reflexivity.
    * (* arg2 is WZero *)
      destruct (stack_val_has_value' arg2 t WZero) eqn: eq_arg2_zero;
        try discriminate.
      injection H0 as eq_m2. rewrite <- eq_m2.
      destruct elem as [val|var|fvar] eqn: eq_elem.
      -- apply eval_asfs2_val.
      -- apply eval_var.
      -- unfold eval_asfs2_elem. destruct (hn =? fvar) eqn: eq_vame_fvar.
         ++ rewrite -> H. simpl. fold eval_asfs2_elem.
            destruct (eval_asfs2_elem stack arg1 t ops) as [arg1_val|]
              eqn: eq_eval_arg2; try reflexivity.
            rewrite -> stack_val_has_value_eval' with (v:=WZero);
              try assumption.
            rewrite -> or_zero. reflexivity. 
         ++ fold eval_asfs2_elem. reflexivity.
  + (* This is not yet the fresh variable to optimize*) 
    destruct (optimize_map_or_zero n t) as [map'|] eqn: eq_optimize_t; 
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

Theorem optimize_or_zero_fvar_eq: forall (a1 a2: asfs) (fresh_var: nat)
  (c: tstack) (ops: opm),
ops OR = Some (Op true 2 evm_or) ->
optimize_or_zero_fvar fresh_var a1 = Some a2 ->
eval_asfs c a1 ops = eval_asfs c a2 ops.
Proof.
intros.
destruct a1 as [h1 maxid1 s1 m1] eqn: eq_a1.
destruct a2 as [h2 maxid2 s2 m2] eqn: eq_a2.
simpl in H0.
destruct (optimize_map_or_zero fresh_var m1) eqn: eq_opt_map;
  try discriminate.
injection H0 as Hh1h2 Hmaxid1_2 Hs1s2 Hm1a.
rewrite -> Hm1a in eq_opt_map.
pose proof (eq_eval_opt_or_zero m1 m2 ops fresh_var c H eq_opt_map)
  as Hall_elem_eval_same_m1_m2.
simpl. rewrite -> Hh1h2. rewrite -> Hs1s2.
destruct (length c =? h2); try reflexivity.
apply eq_eval_elem_stack. assumption.
Qed.


Lemma opt_or_zero_same_fvar_in_maps: forall (n: nat)
  (m1 m2: asfs_map),
optimize_map_or_zero n m1 = Some m2 ->
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
    destruct (stack_val_has_value' arg1 t WZero).
    * injection Hopt as eq_m2. rewrite <- eq_m2.
      simpl. split; try reflexivity.
      apply same_fvar_refl.
    * destruct (stack_val_has_value' arg2 t WZero); try discriminate.
      injection Hopt as eq_m2. rewrite <- eq_m2.
      simpl. split; try reflexivity.
      apply same_fvar_refl.
  + destruct (optimize_map_or_zero n t) as [t_opt|] eqn: optimize_t;
      try discriminate.
    pose proof (strictly_decreasing_preserv fvar efvar t) 
      as Hdecr_t.
    pose proof (IH n t_opt optimize_t).
    simpl. injection Hopt as eq_m2. rewrite <- eq_m2.
    split; try reflexivity. assumption.
Qed.


Lemma opt_or_zero_decreasingness_preservation: forall (n: nat)
  (m1 m2: asfs_map),
strictly_decreasing_map m1 ->
optimize_map_or_zero n m1 = Some m2 ->
strictly_decreasing_map m2.
Proof.
intros.
apply opt_or_zero_same_fvar_in_maps in H0.
apply same_fvar_in_map_preserves_decreasingness with (m1:=m1);
  try assumption.
Qed.


Lemma optimize_or_zero_fvar_safe:
safe_optimization_fvar optimize_or_zero_fvar.
Proof.
unfold safe_optimization_fvar. intros.
split.
- assert (opmap OR = Some (Op true 2 evm_or)) as Hopmap; try reflexivity.
  pose proof (optimize_or_zero_fvar_eq a opt_a n c opmap Hopmap H0)
    as Heq_eval_a_opta.
  rewrite -> Heq_eval_a_opta in H.
  rewrite -> H.
  split; try reflexivity.
- unfold valid_asfs.
  destruct opt_a as [hopt maxopt sopt mopt] eqn: eq_opt_a.
  destruct a as [ha maxa sa ma] eqn: eq_a.
  simpl in H1. simpl in H0.
  destruct (optimize_map_or_zero n ma) eqn: optimize_ma; try discriminate.
  injection H0 as eq_h eq_max eq_stack eq_maps. 
  rewrite -> eq_maps in optimize_ma.
  destruct H1 as [Hfreshv Hdecr].
  rewrite <- eq_max.
  rewrite <- eq_maps.
  split.
  + apply same_fvar_in_map_preserves_fresh_var_gt with (m1:=ma).
    * assumption.
    * apply opt_or_zero_same_fvar_in_maps with (n:=n).
      rewrite -> eq_maps. assumption.
  + apply opt_or_zero_decreasingness_preservation with (n:=n) (m1:=ma) 
      (m2:=a0) in Hdecr.
    * assumption.
    * rewrite -> eq_maps. assumption.
Qed.


Theorem optimize_or_zero_safe:
safe_optimization optimize_or_zero.
Proof.
apply optimize_fresh_var_preservation.
apply optimize_or_zero_fvar_safe.
Qed.





(*************************************************
  Optimization SUB(X,X) --> 0
**************************************************)
Fixpoint optimize_map_sub_x_x (fresh_var: nat) (map: asfs_map): 
  option asfs_map :=
match map with
| [] => None
| (n, val)::t => if n =? fresh_var then
                 match val with
                 | ASFSOp SUB [arg1; arg2] => 
                     match flat_stack_elem arg1 t with
                     | Some v1 =>
                         match flat_stack_elem arg2 t with 
                         | Some v2 => 
                             if compare_flat_asfs_map_val v1 v2 opmap 
                             then Some ((n, ASFSBasicVal (Val WZero))::t)
                             else None
                         | _ => None
                         end
                     
                     | _ => None
                     end 
                 | _ => None
                 end
                 else match optimize_map_sub_x_x fresh_var t with 
                      | None => None
                      | Some map' => Some ((n, val)::map')
                      end
end.

Definition optimize_sub_x_x_fvar (fresh_var: nat) (s: asfs) : option asfs :=
optimize_func_map optimize_map_sub_x_x fresh_var s.

(* This is the main optimization *)
Definition optimize_sub_x_x (a: asfs) : asfs*bool :=
optimize_fresh_var optimize_sub_x_x_fvar a.

Lemma sub_x_x: forall (x: EVMWord), wminus x x = WZero.
Proof. apply wminus_diag. Qed.


Lemma apply_f_equiv_funct: forall (args: list asfs_stack_val)
  (vargs: list EVMWord) (stack: tstack) (t t': asfs_map),
apply_f_list_asfs_stack_val
         (fun elem' : asfs_stack_val => eval_asfs2_elem stack elem' t opmap)
         args = Some vargs->
(forall (elem : asfs_stack_val) (v : EVMWord),
         eval_asfs2_elem stack elem t opmap = Some v ->
         eval_asfs2_elem stack elem t' opmap = Some v) ->
apply_f_list_asfs_stack_val
      (fun elem' : asfs_stack_val => eval_asfs2_elem stack elem' t' opmap)
      args = Some vargs.
Proof.
induction args as [|hh tt IH].
- intros. simpl in H. simpl. assumption.
- intros. simpl in H.
  destruct (eval_asfs2_elem stack hh t opmap) eqn: eval_h; try discriminate.
  destruct (
    apply_f_list_asfs_stack_val
        (fun elem' : asfs_stack_val => eval_asfs2_elem stack elem' t opmap)
        tt
  ) eqn: eval_tt; try discriminate.
  simpl. apply H0 in eval_h. rewrite -> eval_h.
  pose proof (IH l stack t t' eval_tt H0). rewrite -> H1.
  assumption.
Qed.

Lemma eq_succ_eval_opt_sub_x_x: forall (m1 m2: asfs_map) (n: nat)
  (stack: tstack),
optimize_map_sub_x_x n m1 = Some m2 ->
forall (elem: asfs_stack_val) (v: EVMWord), 
  eval_asfs2_elem stack elem m1 opmap = Some v ->
  eval_asfs2_elem stack elem m2 opmap = Some v.
Proof.
induction m1 as [|h t IH].
- intros. simpl in H0. discriminate.
- intros. destruct elem as [val|var|fvar] eqn: eq_elem.
  + rewrite -> eval_asfs2_val. rewrite -> eval_asfs2_val in H0. assumption.
  + rewrite -> eval_asfs2_instackvar. rewrite -> eval_asfs2_instackvar in H0. 
    assumption.
  + unfold optimize_map_sub_x_x in H. destruct h as [fv efv].
    destruct (fv =? n) eqn: eq_fv_n.
    * destruct efv as [|op args] eqn: eq_efv; try discriminate.
      destruct op; try discriminate.
      destruct args as [|arg1 t1]; try discriminate.
      destruct t1 as [|arg2 t2]; try discriminate.
      destruct t2 as [|arg3 t3]; try discriminate.
      destruct (flat_stack_elem arg1 t) as [v1|] eqn: flat_arg1; 
        try discriminate.
      destruct (flat_stack_elem arg2 t) as [v2|] eqn: flat_arg2; 
        try discriminate.
      destruct (compare_flat_asfs_map_val v1 v2 opmap) eqn: comp_arg1_arg2;
        try discriminate.
      injection H as Hm2. rewrite <- Hm2. simpl. simpl in H0.
      destruct (fv =? fvar) eqn: eq_fv_fvar; try assumption.
      destruct (eval_asfs2_elem stack arg1 t opmap) as [varg1|] eqn: eval_arg1;
        try discriminate.
      destruct (eval_asfs2_elem stack arg2 t opmap) as [varg2|] eqn: eval_arg2;
        try discriminate.
      apply compare_flat_eval with (s:=stack) in comp_arg1_arg2;
        try apply evm_stack_opm_validity.
      pose proof (eval_tree_asfs_val arg1 t v1 stack opmap flat_arg1) as Hf1.
      pose proof (eval_tree_asfs_val arg2 t v2 stack opmap flat_arg2) as Hf2.
      rewrite <- Hf1 in comp_arg1_arg2. rewrite <- Hf2 in comp_arg1_arg2.
      rewrite -> eval_arg1 in comp_arg1_arg2.
      rewrite -> eval_arg2 in comp_arg1_arg2.
      injection comp_arg1_arg2 as eq_varg1_varg2.
      rewrite <- eq_varg1_varg2 in H0.
      simpl in H0. rewrite -> sub_x_x in H0. rewrite <- H0.
      apply eval_asfs2_val.
    * fold optimize_map_sub_x_x in H.
       destruct (optimize_map_sub_x_x n t) as [map'|] eqn: opt_map;
        try discriminate.
      injection H as H. rewrite <- H.
      simpl. destruct (fv =? fvar) eqn: eq_fv_fvar.
      -- simpl in H0.  rewrite -> eq_fv_fvar in H0. 
         destruct (efv) as [basicval|op args] eqn: eq_efv.
         ++ apply IH with (n:=n); try assumption.
         ++ destruct (opmap op); try assumption. 
            destruct o as [comm nargs func]. 
            destruct (length args =? nargs); try assumption.
            pose proof (IH map' n stack opt_map) as IHelem.
            destruct (apply_f_list_asfs_stack_val
              (fun elem' : asfs_stack_val => eval_asfs2_elem stack elem' 
                t opmap) args) as [vargs|] eqn: apply_f_t; try discriminate.
            pose proof (apply_f_equiv_funct args vargs stack t map'
              apply_f_t IHelem).
            rewrite -> H1.
            assumption.
      -- simpl in H0. rewrite -> eq_fv_fvar in H0. 
         apply IH with (n:=n); try assumption.
Qed.

Theorem optimize_sub_x_x_safe_success: forall (a1 a2: asfs) (fresh_var: nat)
  (c s: tstack),
optimize_sub_x_x_fvar fresh_var a1 = Some a2 ->
eval_asfs c a1 opmap = Some s ->
eval_asfs c a2 opmap = Some s.
Proof.
intros.
destruct a1 as [h1 maxid1 s1 m1] eqn: eq_a1.
destruct a2 as [h2 maxid2 s2 m2] eqn: eq_a2.
simpl in H.
destruct (optimize_map_sub_x_x fresh_var m1) eqn: eq_opt_map;
  try discriminate.
injection H as Hh1h2 Hmaxid1_2 Hs1s2 Hm1a.
rewrite -> Hm1a in eq_opt_map.
pose proof (eq_succ_eval_opt_sub_x_x m1 m2 fresh_var c eq_opt_map)
  as Hall_elem_succ_eval_same_m1_m2.
simpl. rewrite <- Hh1h2. rewrite <- Hs1s2.
simpl in H0. destruct (length c =? h1); try discriminate.
apply eq_succ_eval_elem_stack with (m1:=m1); try assumption.
Qed.

Lemma opt_sub_x_x_same_fvar_in_maps: forall (n: nat)
  (m1 m2: asfs_map),
optimize_map_sub_x_x n m1 = Some m2 ->
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
    destruct (flat_stack_elem arg1 t); try discriminate.
    destruct (flat_stack_elem arg2 t); try discriminate.
    destruct (compare_flat_asfs_map_val s s0 opmap); try discriminate.
    injection Hopt as Hm2. rewrite <- Hm2.
    simpl. split; try reflexivity.
    apply same_fvar_refl.
  + destruct (optimize_map_sub_x_x n t) as [t_opt|] eqn: optimize_t;
      try discriminate.
    pose proof (strictly_decreasing_preserv fvar efvar t) 
      as Hdecr_t.
    pose proof (IH n t_opt optimize_t).
    simpl. injection Hopt as eq_m2. rewrite <- eq_m2.
    split; try reflexivity. assumption.
Qed.

Lemma opt_sub_x_x_decreasingness_preservation: forall (n: nat)
  (m1 m2: asfs_map),
strictly_decreasing_map m1 ->
optimize_map_sub_x_x n m1 = Some m2 ->
strictly_decreasing_map m2.
Proof.
intros.
apply opt_sub_x_x_same_fvar_in_maps in H0.
apply same_fvar_in_map_preserves_decreasingness with (m1:=m1);
  try assumption.
Qed.


Lemma optimize_sub_x_x_fvar_safe: 
safe_optimization_fvar optimize_sub_x_x_fvar.
Proof.
unfold safe_optimization_fvar. intros.
split.
- pose proof (optimize_sub_x_x_safe_success a opt_a n c cf H0 H) 
    as Heq_eval_a_opta.
  assumption.
- unfold valid_asfs.
  destruct opt_a as [hopt maxopt sopt mopt] eqn: eq_opt_a.
  destruct a as [ha maxa sa ma] eqn: eq_a.
  simpl in H1. simpl in H0.
  destruct (optimize_map_sub_x_x n ma) eqn: optimize_ma; try discriminate.
  injection H0 as eq_h eq_max eq_stack eq_maps. 
  rewrite -> eq_maps in optimize_ma.
  destruct H1 as [Hfreshv Hdecr].
  rewrite <- eq_max.
  rewrite <- eq_maps.
  split.
  + apply same_fvar_in_map_preserves_fresh_var_gt with (m1:=ma).
    * assumption.
    * apply opt_sub_x_x_same_fvar_in_maps with (n:=n).
      rewrite -> eq_maps. assumption.
  + apply opt_sub_x_x_decreasingness_preservation with (n:=n) (m1:=ma) 
      (m2:=a0) in Hdecr.
    * assumption.
    * rewrite -> eq_maps. assumption.
Qed.


Theorem optimize_sub_x_x_safe:
safe_optimization optimize_sub_x_x.
Proof.
apply optimize_fresh_var_preservation.
apply optimize_sub_x_x_fvar_safe.
Qed.



(********************************************************
  Optimization ISZERO(ISZERO(ISZERO(X))) --> ISZERO(X)
*********************************************************)
Fixpoint optimize_map_iszero3 (fresh_var: nat) (map: asfs_map): 
  option asfs_map :=
match map with
| [] => None
| (n1, val)::t => if n1 =? fresh_var then
                  match val with
                  | ASFSOp ISZERO [arg1] => 
                      match stack_val_is_oper_suffix ISZERO arg1 t with 
                      | Some ([arg2], t', n2) => 
                          match stack_val_is_oper_suffix ISZERO arg2 t' with
                          | Some ([X], t'', n3) => 
                              Some ((n1, ASFSOp ISZERO [X])::t)
                          | _ => None
                          end
                      | _ => None
                      end
                  | _ => None
                  end
                  else match optimize_map_iszero3 fresh_var t with 
                       | None => None
                       | Some map' => Some ((n1, val)::map')
                       end
end.

Definition optimize_iszero3_fvar (fresh_var: nat) (s: asfs) : option asfs :=
optimize_func_map optimize_map_iszero3 fresh_var s.

(* THIS IS THE MAIN OPTIMIZATION *)
Definition optimize_iszero3 : (asfs -> asfs*bool) :=
optimize_fresh_var optimize_iszero3_fvar.


Lemma is_zero_3: forall (a r1 r2 r3: EVMWord),
evm_iszero [a] = Some r1 ->
evm_iszero [r1] = Some r2 ->
evm_iszero [r2] = Some r3 ->
r1 = r3.
Proof.
intros. unfold evm_iszero in H. unfold evm_iszero in H0. unfold evm_iszero in H1.
destruct (weqb a WZero) eqn: eq_a_zero.
- unfold evm_eq in H. rewrite -> eq_a_zero in H. injection H as H. 
  rewrite <- H in H0. simpl in H0. injection H0 as H0.
  rewrite <- H0 in H1. unfold evm_eq in H1. 
  rewrite -> weqb_reflex in H1. injection H1 as H1.
  rewrite <- H. rewrite <- H1. reflexivity.
- unfold evm_eq in H. rewrite -> eq_a_zero in H. injection H as H. 
  rewrite <- H in H0. unfold evm_eq in H0. 
  rewrite -> weqb_reflex in H0.  simpl in H0. injection H0 as H0.
  rewrite <- H0 in H1. simpl in H1. injection H1 as H1.
  rewrite <- H. rewrite <- H1. reflexivity.
Qed.

(* Main lemma: every stack value is evaluated to the same value in the 
   original map and also in the optimized one for ISZERO3 *)
Lemma eq_succ_eval_opt_iszero3_eq: forall (m1 m2: asfs_map) (ops: opm) (n: nat)
  (stack: tstack),
ops ISZERO = Some (Op false 1 evm_iszero) ->
optimize_map_iszero3 n m1 = Some m2 ->
strictly_decreasing_map m1 ->
forall (elem: asfs_stack_val) (v: EVMWord), 
  eval_asfs2_elem stack elem m1 ops = Some v ->
  eval_asfs2_elem stack elem m2 ops = Some v.
Proof.
induction m1 as [|h t IH].
- intros. simpl in H0. discriminate H0.
- intros m2 ops n stack Hops_iszero Hopt_m1 Hdecreasing_m1 elem v. 
  simpl in Hopt_m1. destruct h as [hn hv] eqn: eq_h.
  destruct (hn =? n) eqn: eq_hn_n.
  + (* We have found the fresh variable to optimize in the map *) 
    destruct (hv) as [basicval|opval] eqn: eq_hv. 
    * discriminate Hopt_m1.
    * destruct (opval) eqn: eq_opval; try discriminate.
      destruct args as [| arg1 ta]; try discriminate.
      destruct ta; try discriminate.
      destruct (stack_val_is_oper_suffix ISZERO arg1 t) as [r2|]
        eqn: eq_stack_val_is_oper_arg1; try discriminate.
      destruct r2 as [r2' n2]. destruct r2' as [args2 t'].
      destruct args2 as [|arg2 targs2]; try discriminate.
      destruct targs2; try discriminate.
      destruct (stack_val_is_oper_suffix ISZERO arg2 t') as [r3|]
        eqn: eq_stack_val_is_oper_arg2; try discriminate.
      destruct r3 as [r3' n3]. destruct r3' as [args3 t''].
      destruct args3 as [|arg3 targs3]; try discriminate.
      destruct targs3; try discriminate.
      injection Hopt_m1 as Hm2. rewrite <- Hm2.
      destruct elem as [val|var|fvar] eqn: eq_elem.
      -- rewrite -> eval_asfs2_val. rewrite -> eval_asfs2_val. auto.
      -- rewrite -> eval_asfs2_instackvar. rewrite -> eval_asfs2_instackvar.
         auto. 
      -- simpl. destruct (hn =? fvar) eqn: eq_hn_fvar; try auto.
         (* Evaluating the same freshvar that was optimized *) 
         rewrite -> Hops_iszero. intros Heval_orig.
         destruct (eval_asfs2_elem stack arg1 t ops) as [val1|] 
           eqn: eq_eval_arg1; try discriminate.
         pose proof (evaluation_suffix_map' t t' 1 arg1 n2 [arg2] false
           evm_iszero val1 ISZERO ops stack eq_stack_val_is_oper_arg1
           Hops_iszero eq_eval_arg1) 
           as [pref1 [vargs1 [Hpref1 [Heval_arg2 Hiszero_vargs1]]]].
         pose proof (eval_asfs2_cons arg2 [] t' ops stack vargs1
           Heval_arg2) as [val2 [vals2' [Hvargs1 [Heval_arg2' Hvals2']]]].
         rewrite -> eval_asfs2_empty in Hvals2'.
         injection Hvals2' as Hvals2'. rewrite <- Hvals2' in Hvargs1.
         pose proof (evaluation_suffix_map' t' t'' 1 arg2 n3 [arg3] false
           evm_iszero val2 ISZERO ops stack eq_stack_val_is_oper_arg2
           Hops_iszero Heval_arg2')
           as [pref2 [vargs2 [Hpref2 [Heval_arg3 Hiszero_vargs2]]]].
         rewrite -> Hpref2 in Hpref1. simpl in Hpref1.
         rewrite -> app_cons_lr in Hpref1.
         rewrite -> app_assoc in Hpref1.
         rewrite -> app_cons_lr in Hpref1.
         apply strictly_decreasing_preserv in Hdecreasing_m1 as Hdecr_t.
         pose proof (eval_asfs2_cons arg3 [] t'' ops stack vargs2
           Heval_arg3) as [val3 [vals3' [Hvargs2 [Heval_arg3' Hvals3']]]].
         rewrite -> eval_asfs2_empty in Hvals3'.
         injection Hvals3' as Hvals3'. rewrite <- Hvals3' in Hvargs2.
         pose proof (eval_elem_bigger_decreasing_map stack arg3
         (((pref1 ++ [(n2, ASFSOp ISZERO [arg2])]) ++ pref2) ++
           [(n3, ASFSOp ISZERO [arg3])]) t'' t ops val3 Heval_arg3'
           Hpref1 Hdecr_t) as Heval_arg3_t.
         rewrite -> Heval_arg3_t.
         rewrite -> Hvargs1 in Hiszero_vargs1.
         rewrite -> Hvargs2 in Hiszero_vargs2.
         pose proof (is_zero_3 val3 val2 val1 v Hiszero_vargs2 Hiszero_vargs1
           Heval_orig) as Heqv.
         rewrite <- Heqv.
         assumption.
  + (* This is not yet the fresh variable to optimize *)
    destruct (optimize_map_iszero3 n t) as [map'|] eqn: eq_optimize_t; 
      try discriminate.
    injection Hopt_m1 as Hopt_m1. rewrite <- Hopt_m1. 
    destruct elem as [val|var|fvar] eqn: eq_elem.
    * rewrite -> eval_asfs2_val. rewrite -> eval_asfs2_val. intuition.
    * rewrite -> eval_var with (m2 := ((hn, hv) :: map')). intuition.
    * simpl. destruct (hn =? fvar) eqn: eq_hn_fvar.
      -- destruct hv as [basic|opcode args].
         ++ apply IH with (n:=n); try assumption.
            apply strictly_decreasing_preserv with (n:=hn)(v:=ASFSBasicVal basic).
            assumption.
         ++ destruct (ops opcode) as [ops_val|] eqn: eq_ops_opcode; 
              try discriminate.
            destruct (ops_val) as [comm nargs func] eqn: eq_opval.
            destruct (length args =? nargs); try discriminate.
            rewrite -> eval_asfs2_ho. 
            rewrite -> eval_asfs2_ho.
            pose proof (strictly_decreasing_preserv hn (ASFSOp opcode args)
              t Hdecreasing_m1) as Hstrictly_decreasing_t.
            pose proof (IH map' ops n stack Hops_iszero eq_optimize_t
              Hstrictly_decreasing_t) as eq_succ_eval_elem_t_map'.
            destruct (eval_asfs2 stack args t ops) as [vargs|] 
              eqn: eq_eval_args; try discriminate.
            pose proof (eq_succ_eval_elem_stack stack vargs t map' ops args
              eq_succ_eval_elem_t_map' eq_eval_args) as IHc.
            rewrite -> IHc. intuition.
      -- apply IH with (n:=n); try assumption.
         apply strictly_decreasing_preserv with (n:=hn)(v:=hv).
         assumption.
Qed.


Lemma eq_succ_eval_opt_iszero3_eq_abs: forall (m1 m2: asfs_map) (ops: opm) 
  (n: nat) (stack: tstack),
ops ISZERO = Some (Op false 1 evm_iszero) ->
optimize_map_iszero3 n m1 = Some m2 ->
strictly_decreasing_map m1 ->
forall (abs: asfs_stack) (v: tstack), 
  eval_asfs2 stack abs m1 ops = Some v ->
  eval_asfs2 stack abs m2 ops = Some v.
Proof.
induction abs as [| h t IH].
- intros. unfold eval_asfs2 in H2. simpl in H2. 
  unfold eval_asfs2. simpl. assumption.
- intros. 
  pose proof (eval_asfs2_cons h t m1 ops stack v H2) 
    as [hval [tval [eq_v [eval_h_m1 eval_t_m1]]]].
  pose proof (eq_succ_eval_opt_iszero3_eq m1 m2 ops n stack H H0 H1 h hval
    eval_h_m1) as eval_h_m2.
  pose proof (IH tval eval_t_m1) as eval_t_m2.
  rewrite -> eq_v.
  apply eval_asfs2_cons_r; try assumption.
Qed.

Lemma opt_iszero3_same_fvar_in_maps: forall (n: nat)
  (m1 m2: asfs_map),
optimize_map_iszero3 n m1 = Some m2 ->
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
    destruct (stack_val_is_oper_suffix ISZERO arg1 t) as [p|]; 
      try discriminate.
    destruct p as [r fv]. destruct r as [inner_args t'].
    destruct inner_args as [|arg' t_inner_args] eqn: eq_inner_args;
      try discriminate.
    destruct (t_inner_args) as [| ttt] eqn: eq_t_inner_args;
      try discriminate.
    destruct (stack_val_is_oper_suffix ISZERO arg' t') as [p'|];
      try discriminate.
    destruct p' as [r' fv']. destruct r' as [inner_args' t''].
    destruct inner_args' as [|X Xt]; try discriminate.
    destruct Xt; try discriminate.
    injection Hopt as eq_m2. rewrite <- eq_m2.
    simpl. split; try reflexivity.
    apply same_fvar_refl.
  + destruct (optimize_map_iszero3 n t) as [t_opt|] eqn: optimize_t;
      try discriminate.
    pose proof (strictly_decreasing_preserv fvar efvar t) 
      as Hdecr_t.
    pose proof (IH n t_opt optimize_t).
    simpl. injection Hopt as eq_m2. rewrite <- eq_m2.
    split; try reflexivity. assumption.
Qed.

Lemma opt_iszero3_decreasingness_preservation: forall (n: nat)
  (m1 m2: asfs_map),
strictly_decreasing_map m1 ->
optimize_map_iszero3 n m1 = Some m2 ->
strictly_decreasing_map m2.
Proof.
intros.
apply opt_iszero3_same_fvar_in_maps in H0.
apply same_fvar_in_map_preserves_decreasingness with (m1:=m1);
  try assumption.
Qed.

Lemma optimize_iszero3_fvar_safe:
safe_optimization_fvar optimize_iszero3_fvar.
Proof.
unfold safe_optimization_fvar. intros.
unfold eval_asfs in H.
destruct a as [ha maxa absa ma] eqn: eq_a.
destruct opt_a as [hopt maxopt absopt mopt] eqn: eq_opt_a.
destruct (length c =? ha) eqn: eq_len; try discriminate.
assert (opmap ISZERO = Some (Op false 1 evm_iszero)) as eq_opmap_ISZERO; 
  try reflexivity.
simpl in H0. destruct (optimize_map_iszero3 n ma) as [ma' |] 
  eqn: eq_optmize_ma; try discriminate.
injection H0 as eq_h eq_max eq_abs eq_m.
rewrite -> eq_m in eq_optmize_ma.
simpl in H1. destruct H1 as [fresh_var_gt strictly_decr].
simpl. rewrite <- eq_h. rewrite -> eq_len.
split; try split.
- rewrite -> eq_abs in H.
  pose proof (eq_succ_eval_opt_iszero3_eq_abs ma mopt opmap n c eq_opmap_ISZERO
  eq_optmize_ma strictly_decr absopt cf H).
  assumption.
- apply opt_iszero3_same_fvar_in_maps in eq_optmize_ma.
  apply same_fvar_in_map_preserves_fresh_var_gt with (m1:=ma).
  + rewrite <- eq_max. assumption.
  + assumption.
- apply opt_iszero3_decreasingness_preservation with (n:=n) (m1:=ma);
    try assumption.
Qed.

Theorem optimize_iszero3_safe:
safe_optimization optimize_iszero3.
Proof.
apply optimize_fresh_var_preservation.
apply optimize_iszero3_fvar_safe.
Qed.



(********************************************************
  Optimization AND(AND(X,Y), X) or AND(AND(X,Y), Y)
               -> AND(X,Y)
*********************************************************)
Lemma wand_id: forall (x: EVMWord),
wand x x = x.
Proof.
induction x as [|a b c IH].
- reflexivity.
- unfold wand. simpl. fold wand.
  rewrite -> IH. rewrite -> andb_diag. 
  reflexivity.
Qed.

Lemma wand_eq1: forall (x y z: EVMWord),
evm_and [x; y] = Some z ->
evm_and [z; y] = evm_and [x;y].
Proof.
intros. unfold evm_and in H. injection H as H.
unfold evm_and. rewrite <- H.
rewrite <- wand_assoc.
rewrite -> wand_id.
rewrite -> wand_comm.
reflexivity.
Qed.

Lemma and_comm: forall (x y: EVMWord),
evm_and [x;y] = evm_and [y;x].
Proof. 
intros. simpl. rewrite -> wand_comm. reflexivity.
Qed.

Lemma and_and_1: forall (val11 val12 val1 v: EVMWord),
evm_and [val11; val12] = Some val1 ->
evm_and [val1; val11] = Some v ->
evm_and [val11; val12] = Some v.
Proof.
intros. rewrite -> and_comm in H. apply wand_eq1 in H.
rewrite -> H in H0. rewrite -> and_comm in H0.
assumption.
Qed.

Lemma and_and_2: forall (val11 val12 val1 v: EVMWord),
evm_and [val11; val12] = Some val1 ->
evm_and [val1; val12] = Some v ->
evm_and [val11; val12] = Some v.
Proof.
intros. apply wand_eq1 in H.
rewrite -> H in H0. 
assumption.
Qed.


Fixpoint optimize_map_and_and_l (fresh_var: nat) (map: asfs_map): 
  option asfs_map :=
match map with
| [] => None
| (n, val)::t => if n =? fresh_var then
                 match val with
                 | ASFSOp AND [arg1;arg2] => 
                     match stack_val_is_oper AND arg1 t with 
                     | Some [arg11;arg12] => 
                         match flat_stack_elem arg2 t,
                               flat_stack_elem arg11 t,
                               flat_stack_elem arg12 t with
                         | Some farg2, Some farg11, Some farg12 =>
                             if compare_flat_asfs_map_val farg11 farg2 opmap 
                                ||
                                compare_flat_asfs_map_val farg12 farg2 opmap
                             then Some ((n,ASFSOp AND [arg11;arg12])::t)
                             else None
                         | _,_,_ => None
                         end
                     | _ => None
                     end
                 | _ => None
                 end
                 else match optimize_map_and_and_l fresh_var t with 
                      | None => None
                      | Some map' => Some ((n, val)::map')
                      end
end.

Definition optimize_and_and_l_fvar (fresh_var: nat) (s: asfs) : option asfs :=
optimize_func_map optimize_map_and_and_l fresh_var s.

(* THIS IS THE MAIN OPTIMIZATION *)
Definition optimize_and_and_l : (asfs -> asfs*bool) :=
optimize_fresh_var optimize_and_and_l_fvar.

Lemma eq_eval_opt_and_and_l: forall (m1 m2: asfs_map) (n: nat)
  (stack: tstack),
optimize_map_and_and_l n m1 = Some m2 ->
strictly_decreasing_map m1 ->
forall (elem: asfs_stack_val) (v: EVMWord), 
  eval_asfs2_elem stack elem m1 opmap = Some v ->
  eval_asfs2_elem stack elem m2 opmap = Some v.
Proof.
induction m1 as [|h t IH].
- intros. simpl in H. discriminate.
- intros. simpl in H. destruct h as [hn hv] eqn: eq_h.
  apply strictly_decreasing_preserv in H0.
  destruct elem as [val|var|fv].
  + rewrite -> eval_asfs2_val. assumption.
  + rewrite -> eval_asfs2_instackvar. assumption.
  + destruct (hn =? n) eqn: eq_hn_n.
    * (* We have found the fresh variable to optimize in the map *)
      destruct (hv) as [basicval|opval] eqn: eq_hv; try discriminate.
      destruct (opval) eqn: eq_opval; try discriminate.
      destruct args as [| arg1 ta]; try discriminate.
      destruct ta as [| arg2 tta]; try discriminate.
      destruct tta; try discriminate.
      destruct (stack_val_is_oper AND arg1 t) as [inner_args1|] 
        eqn: eq_stack_val_arg1; try discriminate.
      destruct inner_args1 as [|arg11 tinner_args1]; try discriminate.
      destruct tinner_args1 as [|arg12 tinner_args1']; try discriminate.
      destruct tinner_args1'; try discriminate.
      destruct (flat_stack_elem arg2 t) as [farg2|] eqn: flat_arg2;
        try discriminate.
      destruct (flat_stack_elem arg11 t) as [farg11|] eqn: flat_arg11;
        try discriminate.
      destruct (flat_stack_elem arg12 t) as [farg12|] eqn: flat_arg12;
        try discriminate.
      destruct (compare_flat_asfs_map_val farg11 farg2 opmap
                || compare_flat_asfs_map_val farg12 farg2 opmap)
        eqn: eq_compare_flat; try discriminate.
      injection H as Hm2. rewrite <- Hm2.
      apply orb_prop in eq_compare_flat.
      simpl in H1.
      destruct (hn =? fv) eqn: eq_hn_fv.
      -- destruct (eval_asfs2_elem stack arg1 t opmap) as [val1|] 
           eqn: eq_eval_arg1; try discriminate.
         destruct (eval_asfs2_elem stack arg2 t opmap) as [val2|] 
           eqn: eq_eval_arg2; try discriminate.
         simpl. rewrite -> eq_hn_fv.
         assert (opmap AND = Some (Op true 2 evm_and)) as eq_opmap_AND; 
           try reflexivity.
         pose proof (evaluation_sufix_map t 2 arg1 [arg11; arg12] true
           evm_and val1 AND opmap stack eq_stack_val_arg1 eq_opmap_AND
           eq_eval_arg1) as [pre1 [suf1 [inner1 [eq_t [
             eval_arg11_arg12 and_inner]]]]].
         unfold eval_asfs2 in eval_arg11_arg12. 
         simpl in eval_arg11_arg12.
         destruct (eval_asfs2_elem stack arg11 suf1 opmap) as [val11|]
           eqn: eval_arg11_suf; try discriminate.
         destruct (eval_asfs2_elem stack arg12 suf1 opmap) as [val12|]
           eqn: eval_arg12_suf; try discriminate.
         pose proof (eval_elem_bigger_decreasing_map stack arg11 pre1
           suf1 t opmap val11 eval_arg11_suf eq_t H0) as eval_arg11_t.
         rewrite -> eval_arg11_t.
           pose proof (eval_elem_bigger_decreasing_map stack arg12 pre1
           suf1 t opmap val12 eval_arg12_suf eq_t H0) as eval_arg12_t.
         rewrite -> eval_arg12_t.
         injection eval_arg11_arg12 as eq_inner1.
         rewrite <- eq_inner1 in and_inner.
         destruct eq_compare_flat as [equiv_farg11_farg2|equiv_farg12_farg2].
         ++ (* arg11 ~ arg2 *)
            apply compare_flat_eval with (s:=stack) in equiv_farg11_farg2;
              try (apply evm_stack_opm_validity).
            apply eval_tree_asfs_val with (s:=stack)(ops:=opmap) in 
              flat_arg11.
            rewrite <- flat_arg11 in equiv_farg11_farg2.
            apply eval_tree_asfs_val with (s:=stack)(ops:=opmap) in 
              flat_arg2.
            rewrite <- flat_arg2 in equiv_farg11_farg2.
            rewrite -> eq_eval_arg2 in equiv_farg11_farg2.
            rewrite -> equiv_farg11_farg2 in eval_arg11_t.
            injection eval_arg11_t as eq_vall2_val11.
            rewrite -> eq_vall2_val11 in H1.
            apply and_and_1 with (val1:=val1); try assumption.
         ++ (* arg12 ~ arg2 *)
              apply compare_flat_eval with (s:=stack) in equiv_farg12_farg2;
                try (apply evm_stack_opm_validity).
              apply eval_tree_asfs_val with (s:=stack)(ops:=opmap) in 
                flat_arg12.
              rewrite <- flat_arg12 in equiv_farg12_farg2.
              apply eval_tree_asfs_val with (s:=stack)(ops:=opmap) in 
                flat_arg2.
              rewrite <- flat_arg2 in equiv_farg12_farg2.
              rewrite -> eq_eval_arg2 in equiv_farg12_farg2.
              rewrite -> equiv_farg12_farg2 in eval_arg12_t.
              injection eval_arg12_t as eq_vall2_val12.
              rewrite -> eq_vall2_val12 in H1.
              apply and_and_2 with (val1:=val1); try assumption.
      -- simpl. rewrite -> eq_hn_fv. assumption.
    * (* This is not yet the fresh variable to optimize*) 
      destruct (optimize_map_and_and_l n t) as [map'|] eqn: eq_optimize_t; 
        try discriminate.
      injection H as Hm2. rewrite <- Hm2. 
      simpl. destruct (hn =? fv) eqn: eq_hn_fv. simpl in H1.
      -- destruct hv eqn: eq_hv.
         ++ rewrite -> eq_hn_fv in H1. 
            apply IH with (n:=n); try assumption.
         ++ rewrite -> eq_hn_fv in H1. 
            destruct (opmap opcode) as [op|]; try discriminate.
            destruct op as [comm nargs func]; try discriminate.
            destruct (length args =? nargs); try discriminate.
            destruct (apply_f_list_asfs_stack_val
                       (fun elem' : asfs_stack_val =>
                          eval_asfs2_elem stack elem' t opmap) args)
            eqn: eq_apply_f; try discriminate.
            pose proof (IH map' n stack eq_optimize_t H0) as IHc.
            pose proof (apply_f_equiv_funct args l stack t map' eq_apply_f IHc)
              as eq_apply_f_map'.
            rewrite -> eq_apply_f_map'. assumption.
      -- simpl in H1. rewrite -> eq_hn_fv in H1.
         apply IH with (n:=n); try assumption.
Qed.

Lemma eq_succ_eval_opt_and_and_l_eq_abs: forall (m1 m2: asfs_map) 
  (n: nat) (stack: tstack),
optimize_map_and_and_l n m1 = Some m2 ->
strictly_decreasing_map m1 ->
forall (abs: asfs_stack) (v: tstack), 
  eval_asfs2 stack abs m1 opmap = Some v ->
  eval_asfs2 stack abs m2 opmap = Some v.
Proof.
induction abs as [| h t IH].
- intros. unfold eval_asfs2 in H1. simpl in H1. 
  unfold eval_asfs2. simpl. assumption.
- intros. 
  pose proof (eval_asfs2_cons h t m1 opmap stack v H1) 
    as [hval [tval [eq_v [eval_h_m1 eval_t_m1]]]].
  pose proof (eq_eval_opt_and_and_l m1 m2 n stack H H0 h hval
    eval_h_m1) as eval_h_m2.
  pose proof (IH tval eval_t_m1) as eval_t_m2.
  rewrite -> eq_v.
  apply eval_asfs2_cons_r; try assumption.
Qed.

Lemma opt_and_and_l_same_fvar_in_maps: forall (n: nat)
  (m1 m2: asfs_map),
optimize_map_and_and_l n m1 = Some m2 ->
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
    destruct (stack_val_is_oper AND arg1 t) as [inner_args|]; try discriminate.
    destruct (inner_args) as [|arg11 ri]; try discriminate.
    destruct ri as [|arg12 ri']; try discriminate.
    destruct ri'; try discriminate.
    destruct (flat_stack_elem arg2 t) as [farg2|]; try discriminate.
    destruct (flat_stack_elem arg11 t) as [farg11|]; try discriminate.
    destruct (flat_stack_elem arg12 t) as [farg12|]; try discriminate.
    destruct (compare_flat_asfs_map_val farg11 farg2 opmap
              || compare_flat_asfs_map_val farg12 farg2 opmap);
      try discriminate.
    injection Hopt as Hm2. rewrite <- Hm2.
    simpl. split; try reflexivity.
    apply same_fvar_refl.
  + destruct (optimize_map_and_and_l n t) as [t_opt|] eqn: optimize_t;
      try discriminate.
    pose proof (strictly_decreasing_preserv fvar efvar t) 
      as Hdecr_t.
    pose proof (IH n t_opt optimize_t).
    simpl. injection Hopt as eq_m2. rewrite <- eq_m2.
    split; try reflexivity. assumption.
Qed.


Lemma opt_and_and_l_decreasingness_preservation: forall (n: nat)
  (m1 m2: asfs_map),
strictly_decreasing_map m1 ->
optimize_map_and_and_l n m1 = Some m2 ->
strictly_decreasing_map m2.
Proof.
intros.
apply opt_and_and_l_same_fvar_in_maps in H0.
apply same_fvar_in_map_preserves_decreasingness with (m1:=m1);
  try assumption.
Qed.


Lemma optimize_and_and_l_fvar_safe:
safe_optimization_fvar optimize_and_and_l_fvar.
Proof.
unfold safe_optimization_fvar. intros.
unfold eval_asfs in H.
destruct a as [ha maxa absa ma] eqn: eq_a.
destruct opt_a as [hopt maxopt absopt mopt] eqn: eq_opt_a.
destruct (length c =? ha) eqn: eq_len; try discriminate.
assert (opmap AND = Some (Op true 2 evm_and)) as eq_opmap; 
  try reflexivity.
simpl in H0. destruct (optimize_map_and_and_l n ma) as [ma' |] 
  eqn: eq_optmize_ma; try discriminate.
injection H0 as eq_h eq_max eq_abs eq_m.
rewrite -> eq_m in eq_optmize_ma.
simpl in H1. destruct H1 as [fresh_var_gt strictly_decr].
simpl. rewrite <- eq_h. rewrite -> eq_len.
split; try split.
- rewrite -> eq_abs in H.
  pose proof (eq_succ_eval_opt_and_and_l_eq_abs ma mopt n c eq_optmize_ma 
    strictly_decr absopt cf H).
  assumption.
- apply opt_and_and_l_same_fvar_in_maps in eq_optmize_ma.
  apply same_fvar_in_map_preserves_fresh_var_gt with (m1:=ma).
  + rewrite <- eq_max. assumption.
  + assumption.
- apply opt_and_and_l_decreasingness_preservation with (n:=n) (m1:=ma);
    try assumption.
Qed.

Theorem optimize_and_and_l_safe:
safe_optimization optimize_and_and_l.
Proof.
apply optimize_fresh_var_preservation.
apply optimize_and_and_l_fvar_safe.
Qed.




(********************************************************
  Optimization AND(X, AND(X,Y)) or AND(Y, AND(X,Y))
               -> AND(X,Y)
*********************************************************)
Fixpoint optimize_map_and_and_r (fresh_var: nat) (map: asfs_map): 
  option asfs_map :=
match map with
| [] => None
| (n, val)::t => if n =? fresh_var then
                 match val with
                 | ASFSOp AND [arg1;arg2] => 
                     match stack_val_is_oper AND arg2 t with 
                     | Some [arg21;arg22] => 
                         match flat_stack_elem arg1 t,
                               flat_stack_elem arg21 t,
                               flat_stack_elem arg22 t with
                         | Some farg1, Some farg21, Some farg22 =>
                             if compare_flat_asfs_map_val farg1 farg21 opmap 
                                ||
                                compare_flat_asfs_map_val farg1 farg22 opmap
                             then Some ((n,ASFSOp AND [arg21;arg22])::t)
                             else None
                         | _,_,_ => None
                         end
                     | _ => None
                     end
                 | _ => None
                 end
                 else match optimize_map_and_and_r fresh_var t with 
                      | None => None
                      | Some map' => Some ((n, val)::map')
                      end
end.

Lemma wand_eq2: forall (x y z: EVMWord),
evm_and [x; y] = Some z ->
evm_and [x; z] = evm_and [x;y].
Proof.
intros. unfold evm_and in H. injection H as H.
unfold evm_and. rewrite <- H.
rewrite -> wand_assoc.
rewrite -> wand_id.
reflexivity.
Qed.

Lemma and_and_3: forall (val21 val22 val2 v: EVMWord),
evm_and [val21; val22] = Some val2 ->
evm_and [val21; val2] = Some v ->
evm_and [val21; val22] = Some v.
Proof.
intros. apply wand_eq2 in H.
rewrite -> H in H0. assumption.
Qed.

Lemma and_and_4: forall (val21 val22 val2 v: EVMWord),
evm_and [val21; val22] = Some val2 ->
evm_and [val22; val2] = Some v ->
evm_and [val21; val22] = Some v.
Proof.
intros. apply wand_eq1 in H. rewrite <- and_comm in H.
rewrite -> H in H0. assumption.
Qed.

Definition optimize_and_and_r_fvar (fresh_var: nat) (s: asfs) : option asfs :=
optimize_func_map optimize_map_and_and_r fresh_var s.

(* THIS IS THE MAIN OPTIMIZATION *)
Definition optimize_and_and_r : (asfs -> asfs*bool) :=
optimize_fresh_var optimize_and_and_r_fvar.

Lemma eq_eval_opt_and_and_r: forall (m1 m2: asfs_map) (n: nat)
  (stack: tstack),
optimize_map_and_and_r n m1 = Some m2 ->
strictly_decreasing_map m1 ->
forall (elem: asfs_stack_val) (v: EVMWord), 
  eval_asfs2_elem stack elem m1 opmap = Some v ->
  eval_asfs2_elem stack elem m2 opmap = Some v.
Proof.
induction m1 as [|h t IH].
- intros. simpl in H. discriminate.
- intros. simpl in H. destruct h as [hn hv] eqn: eq_h.
  apply strictly_decreasing_preserv in H0.
  destruct elem as [val|var|fv].
  + rewrite -> eval_asfs2_val. assumption.
  + rewrite -> eval_asfs2_instackvar. assumption.
  + destruct (hn =? n) eqn: eq_hn_n.
    * (* We have found the fresh variable to optimize in the map *)
      destruct (hv) as [basicval|opval] eqn: eq_hv; try discriminate.
      destruct (opval) eqn: eq_opval; try discriminate.
      destruct args as [| arg1 ta]; try discriminate.
      destruct ta as [| arg2 tta]; try discriminate.
      destruct tta; try discriminate.
      destruct (stack_val_is_oper AND arg2 t) as [inner_args2|] 
        eqn: eq_stack_val_arg2; try discriminate.
      destruct inner_args2 as [|arg21 tinner_args2]; try discriminate.
      destruct tinner_args2 as [|arg22 tinner_args2']; try discriminate.
      destruct tinner_args2'; try discriminate.
      destruct (flat_stack_elem arg1 t) as [farg1|] eqn: flat_arg1;
        try discriminate.
      destruct (flat_stack_elem arg21 t) as [farg21|] eqn: flat_arg21;
        try discriminate.
      destruct (flat_stack_elem arg22 t) as [farg22|] eqn: flat_arg22;
        try discriminate.
      destruct (compare_flat_asfs_map_val farg1 farg21 opmap
                || compare_flat_asfs_map_val farg1 farg22 opmap)
        eqn: eq_compare_flat; try discriminate.
      injection H as Hm2. rewrite <- Hm2.
      apply orb_prop in eq_compare_flat.
      simpl in H1.
      destruct (hn =? fv) eqn: eq_hn_fv.
      -- destruct (eval_asfs2_elem stack arg1 t opmap) as [val1|] 
           eqn: eq_eval_arg1; try discriminate.
         destruct (eval_asfs2_elem stack arg2 t opmap) as [val2|] 
           eqn: eq_eval_arg2; try discriminate.
         simpl. rewrite -> eq_hn_fv.
         assert (opmap AND = Some (Op true 2 evm_and)) as eq_opmap_AND; 
           try reflexivity.
         pose proof (evaluation_sufix_map t 2 arg2 [arg21; arg22] true
           evm_and val2 AND opmap stack eq_stack_val_arg2 eq_opmap_AND
           eq_eval_arg2) as [pre [suf [inner2 [eq_t [
             eval_arg21_arg22 and_inner]]]]].
         unfold eval_asfs2 in eval_arg21_arg22. 
         simpl in eval_arg21_arg22.
         destruct (eval_asfs2_elem stack arg21 suf opmap) as [val21|]
           eqn: eval_arg21_suf; try discriminate.
         destruct (eval_asfs2_elem stack arg22 suf opmap) as [val22|]
           eqn: eval_arg22_suf; try discriminate.
         pose proof (eval_elem_bigger_decreasing_map stack arg21 pre
           suf t opmap val21 eval_arg21_suf eq_t H0) as eval_arg21_t.
         rewrite -> eval_arg21_t.
         pose proof (eval_elem_bigger_decreasing_map stack arg22 pre
           suf t opmap val22 eval_arg22_suf eq_t H0) as eval_arg22_t.
         rewrite -> eval_arg22_t.
         injection eval_arg21_arg22 as eq_inner2.
         rewrite <- eq_inner2 in and_inner.
         destruct eq_compare_flat as [equiv_farg1_farg21|equiv_farg1_farg22].
         ++ (* arg1 ~ arg21 *)
            apply compare_flat_eval with (s:=stack) in equiv_farg1_farg21;
              try (apply evm_stack_opm_validity).
            apply eval_tree_asfs_val with (s:=stack)(ops:=opmap) in 
              flat_arg1.
            rewrite <- flat_arg1 in equiv_farg1_farg21.
            apply eval_tree_asfs_val with (s:=stack)(ops:=opmap) in 
              flat_arg21.
            rewrite <- flat_arg21 in equiv_farg1_farg21.
            rewrite -> eq_eval_arg1 in equiv_farg1_farg21.
            rewrite <- equiv_farg1_farg21 in eval_arg21_t.
            injection eval_arg21_t as eq_val1_val21.
            rewrite -> eq_val1_val21 in H1.
            apply and_and_3 with (val2:=val2); try assumption.
         ++ (* arg1 ~ arg22 *)
              apply compare_flat_eval with (s:=stack) in equiv_farg1_farg22;
                try (apply evm_stack_opm_validity).
              apply eval_tree_asfs_val with (s:=stack)(ops:=opmap) in 
                flat_arg22.
              rewrite <- flat_arg22 in equiv_farg1_farg22.
              apply eval_tree_asfs_val with (s:=stack)(ops:=opmap) in 
                flat_arg1.
              rewrite <- flat_arg1 in equiv_farg1_farg22.
              rewrite -> eq_eval_arg1 in equiv_farg1_farg22.
              rewrite <- equiv_farg1_farg22 in eval_arg22_t.
              injection eval_arg22_t as eq_val1_val22.
              rewrite -> eq_val1_val22 in H1.
              apply and_and_4 with (val2:=val2); try assumption.
      -- simpl. rewrite -> eq_hn_fv. assumption.
    * (* This is not yet the fresh variable to optimize*) 
      destruct (optimize_map_and_and_r n t) as [map'|] eqn: eq_optimize_t; 
        try discriminate.
      injection H as Hm2. rewrite <- Hm2. 
      simpl. destruct (hn =? fv) eqn: eq_hn_fv. simpl in H1.
      -- destruct hv eqn: eq_hv.
         ++ rewrite -> eq_hn_fv in H1. 
            apply IH with (n:=n); try assumption.
         ++ rewrite -> eq_hn_fv in H1. 
            destruct (opmap opcode) as [op|]; try discriminate.
            destruct op as [comm nargs func]; try discriminate.
            destruct (length args =? nargs); try discriminate.
            destruct (apply_f_list_asfs_stack_val
                       (fun elem' : asfs_stack_val =>
                          eval_asfs2_elem stack elem' t opmap) args)
            eqn: eq_apply_f; try discriminate.
            pose proof (IH map' n stack eq_optimize_t H0) as IHc.
            pose proof (apply_f_equiv_funct args l stack t map' eq_apply_f IHc)
              as eq_apply_f_map'.
            rewrite -> eq_apply_f_map'. assumption.
      -- simpl in H1. rewrite -> eq_hn_fv in H1.
         apply IH with (n:=n); try assumption.
Qed.

Lemma eq_succ_eval_opt_and_and_r_eq_abs: forall (m1 m2: asfs_map) 
  (n: nat) (stack: tstack),
optimize_map_and_and_r n m1 = Some m2 ->
strictly_decreasing_map m1 ->
forall (abs: asfs_stack) (v: tstack), 
  eval_asfs2 stack abs m1 opmap = Some v ->
  eval_asfs2 stack abs m2 opmap = Some v.
Proof.
induction abs as [| h t IH].
- intros. unfold eval_asfs2 in H1. simpl in H1. 
  unfold eval_asfs2. simpl. assumption.
- intros. 
  pose proof (eval_asfs2_cons h t m1 opmap stack v H1) 
    as [hval [tval [eq_v [eval_h_m1 eval_t_m1]]]].
  pose proof (eq_eval_opt_and_and_r m1 m2 n stack H H0 h hval
    eval_h_m1) as eval_h_m2.
  pose proof (IH tval eval_t_m1) as eval_t_m2.
  rewrite -> eq_v.
  apply eval_asfs2_cons_r; try assumption.
Qed.

Lemma opt_and_and_r_same_fvar_in_maps: forall (n: nat)
  (m1 m2: asfs_map),
optimize_map_and_and_r n m1 = Some m2 ->
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
    destruct (stack_val_is_oper AND arg2 t) as [inner_args|]; try discriminate.
    destruct (inner_args) as [|arg21 ri]; try discriminate.
    destruct ri as [|arg22 ri']; try discriminate.
    destruct ri'; try discriminate.
    destruct (flat_stack_elem arg1 t) as [farg1|]; try discriminate.
    destruct (flat_stack_elem arg21 t) as [farg21|]; try discriminate.
    destruct (flat_stack_elem arg22 t) as [farg22|]; try discriminate.
    destruct (compare_flat_asfs_map_val farg1 farg21 opmap
              || compare_flat_asfs_map_val farg1 farg22 opmap);
      try discriminate.
    injection Hopt as Hm2. rewrite <- Hm2.
    simpl. split; try reflexivity.
    apply same_fvar_refl.
  + destruct (optimize_map_and_and_r n t) as [t_opt|] eqn: optimize_t;
      try discriminate.
    pose proof (strictly_decreasing_preserv fvar efvar t) 
      as Hdecr_t.
    pose proof (IH n t_opt optimize_t).
    simpl. injection Hopt as eq_m2. rewrite <- eq_m2.
    split; try reflexivity. assumption.
Qed.


Lemma opt_and_and_r_decreasingness_preservation: forall (n: nat)
  (m1 m2: asfs_map),
strictly_decreasing_map m1 ->
optimize_map_and_and_r n m1 = Some m2 ->
strictly_decreasing_map m2.
Proof.
intros.
apply opt_and_and_r_same_fvar_in_maps in H0.
apply same_fvar_in_map_preserves_decreasingness with (m1:=m1);
  try assumption.
Qed.


Lemma optimize_and_and_r_fvar_safe:
safe_optimization_fvar optimize_and_and_r_fvar.
Proof.
unfold safe_optimization_fvar. intros.
unfold eval_asfs in H.
destruct a as [ha maxa absa ma] eqn: eq_a.
destruct opt_a as [hopt maxopt absopt mopt] eqn: eq_opt_a.
destruct (length c =? ha) eqn: eq_len; try discriminate.
assert (opmap AND = Some (Op true 2 evm_and)) as eq_opmap; 
  try reflexivity.
simpl in H0. destruct (optimize_map_and_and_r n ma) as [ma' |] 
  eqn: eq_optmize_ma; try discriminate.
injection H0 as eq_h eq_max eq_abs eq_m.
rewrite -> eq_m in eq_optmize_ma.
simpl in H1. destruct H1 as [fresh_var_gt strictly_decr].
simpl. rewrite <- eq_h. rewrite -> eq_len.
split; try split.
- rewrite -> eq_abs in H.
  pose proof (eq_succ_eval_opt_and_and_r_eq_abs ma mopt n c eq_optmize_ma 
    strictly_decr absopt cf H).
  assumption.
- apply opt_and_and_r_same_fvar_in_maps in eq_optmize_ma.
  apply same_fvar_in_map_preserves_fresh_var_gt with (m1:=ma).
  + rewrite <- eq_max. assumption.
  + assumption.
- apply opt_and_and_r_decreasingness_preservation with (n:=n) (m1:=ma);
    try assumption.
Qed.


Theorem optimize_and_and_r_safe:
safe_optimization optimize_and_and_r.
Proof.
apply optimize_fresh_var_preservation.
apply optimize_and_and_r_fvar_safe.
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

Definition our_optimization_pipeline := 
[optimize_eval;         
 optimize_add_zero;     
 optimize_mul_one;      
 optimize_mul_zero;     
 optimize_not_not;      
 optimize_div_one;
 optimize_eq_zero;
 optimize_gt_one;
 optimize_lt_one;
 optimize_or_zero;
 optimize_sub_x_x;      
 optimize_iszero3;
 optimize_and_and_l;
 optimize_and_and_r].


Theorem our_optimization_pipeline_is_safe: 
safe_optimization_pipeline our_optimization_pipeline.
Proof.
unfold safe_optimization_pipeline.
apply Forall_cons; try apply optimize_eval_safe.
apply Forall_cons; try apply optimize_add_zero_safe.
apply Forall_cons; try apply optimize_mul_one_safe.
apply Forall_cons; try apply optimize_mul_zero_safe.
apply Forall_cons; try apply optimize_not_not_safe.
apply Forall_cons; try apply optimize_div_one_safe.
apply Forall_cons; try apply optimize_eq_zero_safe.
apply Forall_cons; try apply optimize_gt_one_safe.
apply Forall_cons; try apply optimize_lt_one_safe.
apply Forall_cons; try apply optimize_or_zero_safe.
apply Forall_cons; try apply optimize_sub_x_x_safe.
apply Forall_cons; try apply optimize_iszero3_safe.
apply Forall_cons; try apply optimize_and_and_l_safe.
apply Forall_cons; try apply optimize_and_and_r_safe.
apply Forall_nil.
Qed.


End Optimizations.
Import Optimizations.












(*

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
    
Theorem th2: forall (c: tstack) (v: EVMWord) (id: nat) (m: asfs_map) (ops: opm),
  eval_asfs2_elem c (FreshVar id) ((id, ASFSBasicVal (Val v))::m) ops = Some v.
  Proof.
    intros. simpl. rewrite Nat.eqb_refl. destruct m; simpl; reflexivity. Qed.

Theorem th3: forall (c: tstack) (id var: nat) (m: asfs_map) (ops: opm),
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


(* Theorem th_opt_add_0_elem: forall (e e': asfs_map_val) (c: tstack) *)
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

Theorem th8: forall (c: tstack) (var: nat) (m: asfs_map) (ops: opm),
  eval_asfs2_elem c (InStackVar var) m ops = nth_error c var.
Proof.
  intros. destruct m; simpl; reflexivity. Qed.

Lemma th_opt_add_0_val: forall (m1 m2: asfs_map) (ops: opm) (e: asfs_stack_val)
  (c: tstack) (val: EVMWord),
  ops ADD = Some (Op true 2 add) ->
  opt_add_0_map m1 = m2 ->
  e = Val val ->
  eval_asfs2_elem c e m1 ops = eval_asfs2_elem c e m2 ops.
  Proof.
    destruct m1.
    - intros m2 ops e c val H1 H2 H3.
      cbn in H2. rewrite <- H2. reflexivity.
    - intros m2 ops e c val H1 H2 H3.
      cbn. rewrite H3. rewrite eval_asfs2_val. reflexivity.
  Qed.



Lemma th_opt_add_0_map: forall (m1 m2: asfs_map) (ops: opm)
  (c: tstack) (id: nat),
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
                      + rewrite <- H2. apply eval_asfs2_val.
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
                        ++ rewrite <- H2. apply eval_asfs2_val.
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
       --- rewrite <- H2. rewrite eval_asfs2_val. rewrite eval_asfs2_val. reflexivity.
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



Theorem th_opt_add_0_correct: forall (c1 c2: tstack) (a1 a2 : asfs) (ops: opm),
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

*)

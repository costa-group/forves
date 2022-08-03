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


(* General definitions to define different optimizations and useful common
   lemmas *)
   
Fixpoint lookup_asfs_map (m: asfs_map) (fvar: nat) : option asfs_map_val :=
match m with
| [] => None
| (k,v)::t => if k =? fvar then Some v
              else lookup_asfs_map t fvar
end.   

(*Definition stack_val_is_oper (oper: gen_instr) (val: asfs_stack_val) 
  (m: asfs_map) : option (list asfs_stack_val) :=
match val with 
| Val _ => None
| InStackVar _ => None
| FreshVar fvar => match lookup_asfs_map m fvar with
                   | Some (ASFSOp opcode args) =>
                       if eq_gen_instr oper opcode then Some args
                       else None
                   | _ => None
                   end
end.*)

Fixpoint stack_val_is_oper (oper: gen_instr) (val: asfs_stack_val) 
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
                           if eq_gen_instr oper opcode then Some args
                           else None
                         | _ => None
                         end
                       else stack_val_is_oper oper val t
                   end
end.


Fixpoint optimize_fresh_var2 (a: asfs) (m: asfs_map) 
 (opt: nat -> asfs -> option asfs): asfs*bool :=
match m with
| [] => (a, false)
| (n,_)::t => match opt n a with
              | None => optimize_fresh_var2 a t opt
              | Some a' => (a',true)
              end
end.


Definition optimize_fresh_var (opt: nat -> asfs -> option asfs) (a: asfs):
  asfs*bool :=
match a with
| ASFSc height maxid s m  => optimize_fresh_var2 a m opt
end.


Definition safe_optimization_fvar (opt: nat -> asfs -> option asfs) :=
forall (n: nat) (c cf: concrete_stack) (a opt_a: asfs),
eval_asfs c a opmap = Some cf ->
opt n a = Some opt_a ->
eval_asfs c opt_a opmap = Some cf.


Definition safe_optimization (opt: asfs -> asfs*bool) :=
forall (c cf: concrete_stack) (a opt_a: asfs),
eval_asfs c a opmap = Some cf ->
opt a = (opt_a, true) ->
eval_asfs c opt_a opmap = Some cf.


Lemma optimize_fresh_var2_preservation: forall (m: asfs_map) (a a': asfs) 
  (opt: nat -> asfs -> option asfs) (c cf: concrete_stack),
safe_optimization_fvar opt ->
optimize_fresh_var2 a m opt = (a', true) ->
eval_asfs c a opmap = Some cf ->
eval_asfs c a' opmap = Some cf.
Proof.
intros m.
induction m as [| h t IH]. 
- intros. unfold optimize_fresh_var2 in H0. injection H0 as Hasfs Hfalse. 
  discriminate.
- intros. 
  unfold optimize_fresh_var2 in H0.
  destruct h as [fvar expr] eqn: eq_h.
  destruct (opt fvar a) as [opt_a|] eqn: eq_opt_fvar.
  + injection H0 as eqa'.
    unfold safe_optimization_fvar in H.
    rewrite -> eqa' in eq_opt_fvar.
    pose proof (H fvar c cf a a' H1 eq_opt_fvar).
    assumption.
  + fold optimize_fresh_var2 in H0.
    pose proof (IH a a' opt c cf H H0 H1).
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
pose proof (optimize_fresh_var2_preservation ma a opt_a opt c cf H H1 H0).
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
   be the same sucessfull value*)
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
reflexivity.
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
reflexivity.
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


Theorem optimize_mul_zero_fvar_safe: 
safe_optimization_fvar optimize_mul_zero_fvar.
Proof.
unfold safe_optimization_fvar. intros.
apply optimize_mul_zero_safe_success with (a1:=a) (fresh_var:=n); 
  try intuition.
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

(*
Lemma adsf:
stack_val_is_oper oper (FreshVar fvar) ((fvar,val) :: t) = Some inner_args ->
eval_asfs2 stack inner_args ((k, ASFSOp opcode args) :: t) ops =
     Some inner_vals ->
eval_asfs2 stack inner_args t ops = Some inner_vals
*)

Lemma val_is_oper_gen: forall (m: asfs_map) (oper: gen_instr)
 (arg: asfs_stack_val) (inner_args: list asfs_stack_val) 
 (stack inner_vals: concrete_stack) (ops: opm) 
 (func: list EVMWord -> option EVMWord)
 (comm: bool) (nbargs: nat),
stack_val_is_oper oper arg m = Some inner_args ->
ops oper = Some (Op comm nbargs func) ->
eval_asfs2 stack inner_args m ops = Some inner_vals ->
length inner_args = nbargs ->
eval_asfs2_elem stack arg m ops = func inner_vals.
Proof.
induction m as [|h t IH].
- intros. destruct arg as [const|var|fvar] eqn: eq_arg.
  + simpl in H. discriminate.
  + simpl in H. discriminate.
  + unfold stack_val_is_oper in H. unfold lookup_asfs_map in H.
    discriminate.
- intros. destruct arg as [const|var|fvar] eqn: eq_arg.
  + simpl in H. discriminate.
  + simpl in H. discriminate.
  + unfold stack_val_is_oper in H. 
    destruct h as [k v] eqn: eq_h.
    destruct (k =? fvar) eqn: eq_k_fvar.
    * destruct v as [|opcode args] eqn: eq_v; try discriminate.
      destruct (oper =?i opcode) eqn: eq_oper_opcode; try discriminate.
      injection H as H.
      unfold eval_asfs2_elem. rewrite -> eq_k_fvar.
      apply eq_gen_instr_correct in eq_oper_opcode.
      rewrite <- eq_oper_opcode. rewrite -> H0.
      rewrite -> H.
      apply Nat.eqb_eq in H2. rewrite -> H2.
      rewrite -> eval_asfs2_ho.
      admit.
    * unfold eval_asfs2_elem. rewrite -> eq_k_fvar.
      fold eval_asfs2_elem. fold stack_val_is_oper in H.
      apply IH with (oper:=oper) (inner_args:=inner_args) (comm:=comm)
        (nbargs:=nbargs); try assumption.
      unfold eval_asfs2 in H1. admit.
Admitted.

Lemma val_is_oper_unary: forall (oper: gen_instr) (m: asfs_map) 
 (arg inner_arg: asfs_stack_val) (stack: concrete_stack)
 (inner_val: EVMWord) (ops: opm) (func: list EVMWord -> option EVMWord)
 (comm: bool) (nbargs: nat),
stack_val_is_oper oper arg m = Some [inner_arg] ->
ops oper = Some (Op comm nbargs func) ->
eval_asfs2_elem stack inner_arg m ops = Some inner_val ->
eval_asfs2_elem stack arg m ops = func [inner_val].
Proof.
intros.
apply val_is_oper_gen with (oper:=oper)(inner_args:=[inner_arg])
 (comm:=comm)(nbargs:=nbargs); try assumption.
unfold eval_asfs2. unfold apply_f_list_asfs_stack_val.
rewrite -> H1. reflexivity.
Qed.

(* Could be generalized to any arity? Otherwise we need proofs for 1 and 2 
   arguments at least *)
Lemma eval_outer_implies_inner: forall (stack: concrete_stack) (op: gen_instr)
  (arg inner_arg: asfs_stack_val) (m: asfs_map) (ops: opm) (v: EVMWord),
eval_asfs2_elem stack arg m ops = Some v -> 
stack_val_is_oper op arg m = Some [inner_arg] ->
exists (v': EVMWord), eval_asfs2_elem stack inner_arg m ops = Some v'.
Proof.
Admitted.



(* Main lemma: every stack value is evaluated to the same value in the 
   original map and also in the optimized one for NOT_NOT *)
Lemma eq_succ_eval_opt_not_not_eq: forall (m1 m2: asfs_map) (ops: opm) (n: nat)
  (stack: concrete_stack),
ops NOT = Some (Op false 1 not) ->
optimize_map_not_not n m1 = Some m2 ->
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
      destruct ta; try discriminate.
      destruct (stack_val_is_oper NOT arg1 t) as [inner_args|] 
        eqn: eq_arg_is_NOT; try discriminate.
      destruct inner_args as [| inner_arg inner_t] eqn: eq_inner_args;
        try discriminate.
      destruct inner_t eqn: eq_inner_t; try discriminate.
      injection H0 as eq_m2. rewrite <- eq_m2.
      destruct elem as [val|var|fvar] eqn: eq_elem.
      -- rewrite -> eval_value in H1.
         rewrite -> eval_value. assumption.
      -- rewrite -> eval_var with (m2 := ((hn, ASFSBasicVal inner_arg) :: t))
           in H1. assumption.
      -- unfold eval_asfs2_elem. unfold eval_asfs2_elem in H1. 
         destruct (hn =? fvar) eqn: eq_vame_fvar.
         ++ fold eval_asfs2_elem. 
            rewrite -> H in H1. simpl in H1.
            fold eval_asfs2_elem in H1.
            destruct (eval_asfs2_elem stack arg1 t ops) eqn: eq_eval_arg1;
              try discriminate.
            pose proof (eval_outer_implies_inner stack NOT arg1 inner_arg
              t ops e eq_eval_arg1 eq_arg_is_NOT) as [v' Hevalinner].
            pose proof (val_is_oper_unary NOT t arg1 inner_arg stack  v' ops
              not false 1 eq_arg_is_NOT H Hevalinner).
            rewrite -> H0 in eq_eval_arg1.
            simpl in eq_eval_arg1. injection eq_eval_arg1 as eq_e.
            simpl in H1. injection H1 as H1. rewrite <- H1.
            simpl in H0.
            rewrite -> Hevalinner.
            rewrite <- eq_e.
            rewrite -> wnot_idempotent.
            reflexivity.
         ++ fold eval_asfs2_elem in H1. fold eval_asfs2_elem. 
            assumption.
  + (* This is not yet the fresh variable to optimize*) 
    destruct (optimize_map_not_not n t) as [map'|] eqn: eq_optimize_t; 
      try discriminate.
    injection H0 as H0. rewrite <- H0. 
    destruct elem as [val|var|fvar] eqn: eq_elem.
    * rewrite -> eval_value in H1. rewrite -> eval_value. assumption.
    * rewrite -> eval_var with (m2 := ((hn, hv) :: map'))
           in H1. assumption.
    * simpl. simpl in H1. 
      destruct (hn =? fvar) eqn: eq_hn_fvar.
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






(***************************************
Application of a list of optimizations
****************************************)

(* Apply all the optimization functions in chain, returns false if 
   some optimization cannot be applied *)
Fixpoint apply_all_op (l_opt: list optimization) (a: asfs) : asfs*bool :=
match l_opt with
| nil => (a, true)
| opt::ropts => match opt a with
                | (a', true) => apply_all_op ropts a'
                | (a', false) => (a, false)
                end
end.

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


(* A pipeline of optimizations if safe if every optimization in the list 
   is safe *)
Definition safe_optimization_pipeline (l: list optimization) :=
Forall safe_optimization l.


Theorem apply_all_op_safety: forall (l: list optimization),
safe_optimization_pipeline l -> 
safe_optimization (apply_all_op l).
induction l as [|opt ropts IH].
- unfold safe_optimization. intros.
  simpl in H1. injection H1 as H1. 
  rewrite <- H1.
  assumption.
- unfold safe_optimization. intros.
  unfold safe_optimization_pipeline in H.
  assert (Hcopy := H).
  apply Forall_inv in H.
  unfold safe_optimization_pipeline in IH.
  apply Forall_inv_tail in Hcopy.
  apply IH in Hcopy.
  unfold apply_all_op in H1.
  destruct (opt a) as [a1 flag] eqn: eq_opta.
  destruct flag eqn: eq_flag.
  + fold apply_all_op in H1.
    unfold safe_optimization in H.
    pose proof (H c cf a a1 H0 eq_opta).
    unfold safe_optimization in Hcopy.
    apply Hcopy with (a:=a1).
    * apply H2.
    * apply H1.
  + injection H1 as _ Hfalse. discriminate.
Qed.



Theorem apply_first_op_safety: forall (l: list optimization),
safe_optimization_pipeline l -> 
safe_optimization (apply_first_op l).
induction l as [|opt ropts IH].
- unfold safe_optimization. intros.
  simpl in H1. injection H1 as _ Hfalse. 
  discriminate.
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
    pose proof (H c cf a a1 H0 eq_opta).
    injection H1 as eqa1_opta.
    rewrite <- eqa1_opta.
    apply H2.
  + fold apply_first_op in H1.
    unfold safe_optimization in Hcopy.
    apply Hcopy with (a:=a).
    * apply H0.
    * apply H1.
Qed.


Theorem our_optimization_pipeline_is_safe: 
safe_optimization_pipeline [optimize_add_zero; optimize_mul_one; 
  optimize_mul_zero].
Proof.
unfold safe_optimization_pipeline. 
apply Forall_cons; try apply optimize_add_zero_safe.
apply Forall_cons; try apply optimize_mul_one_safe.
apply Forall_cons; try apply optimize_mul_zero_safe.
intuition.
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

Definition checker (p1 p2: prog) =
let asfs1 := symb_exec p1 opmap in
let asfs2 := symb_exec p2 opmap in
let opt_asfs1 := opt_scheme ([opt1; opt2;....]) a in
eq_asfs opt_asfs1  asfs2 opmap.

Proof obligations: [opt1; opt2;....] is a sublist of l:op
*)


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

(* Correctness *)
    
Theorem th2: forall (c: concrete_stack) (v: EVMWord) (id: nat) (m: asfs_map) (ops: opm),
  eval_asfs2_elem c (FreshVar id) ((id, ASFSBasicVal (Val v))::m) ops = Some v.
  Proof.
    intros. simpl. rewrite Nat.eqb_refl. destruct m; simpl; reflexivity. Qed.

Theorem th3: forall (c: concrete_stack) (id var: nat) (m: asfs_map) (ops: opm),
  eval_asfs2_elem c (FreshVar id) ((id, ASFSBasicVal (InStackVar var))::m) ops = nth_error c var.
  Proof.
    intros. simpl. rewrite Nat.eqb_refl. destruct m; simpl; reflexivity. Qed.

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

Example p1 : prog := [
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



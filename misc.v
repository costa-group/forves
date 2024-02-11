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

It is like map, but stops once f returns None (and returns None
in this case).

**)

Definition map_option {A B : Type} (f: A -> option B)  :=

  fix map_option_fix (l: list A) : option (list B) :=
    match l with 
    | nil => Some []
    | elem::rs => let elem_oval := f elem in
                  let rs_oval := map_option_fix rs in
                  match (elem_oval, rs_oval) with 
                  | (Some elem_val, Some rs_val) => Some (elem_val::rs_val)
                  | _ => None
                  end
    end.

Definition fold_right_two_lists {A B: Type} (f : A -> B -> bool) :=
  fix fold_right_fix (v : list A) : list B -> bool :=
    match v with
    | [] => fun w =>  match w with
                      | [] => true
                      | _ => false
                      end
    |vh::vt =>
       fun w => match w with
                | [] => false
                | wh::wt =>
                    if (f vh wh) then
                      (fold_right_fix vt wt)
                    else
                      false
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


(* Just a relation between map_option and its inner function
map_option_fix. Trivial, but useful for induction and for
readability *)
Lemma map_option_ho:
  forall A B f l,
  map_option f l =
    (fix map_option_fix (l: list A) : option (list B) :=
    match l with 
    | nil => Some []
    | elem::rs => let elem_oval := f elem in
                  let rs_oval := map_option_fix rs in
                  match (elem_oval, rs_oval) with 
                  | (Some elem_val, Some rs_val) => Some (elem_val::rs_val)
                  | _ => None
                  end
    end) l.
Proof.
  reflexivity.
Qed.


Lemma fold_right_two_lists_ho:
  forall A B f l1 l2,
  fold_right_two_lists f l1 l2 =
  (fix fold_right_fix (v : list A) : list B -> bool :=
    match v with
    | [] => fun w =>  match w with
                      | [] => true
                      | _ => false
                      end
    |vh::vt =>
       fun w => match w with
                | [] => false
                | wh::wt =>
                    if (f vh wh) then
                      (fold_right_fix vt wt)
                    else
                      false
                end
    end) l1 l2.
Proof.
  reflexivity.
Qed.


  
(* When map_option succeeds, the length of the result list is
  as the length of the input list *)
Lemma map_option_len:
  forall (A B: Type) (f: A->option B) (l1: list A) (l2: list B),
    map_option f l1 = Some l2 ->
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
    unfold map_option in H_fold_r_cons.
    destruct (f a) eqn:E_fa.
    + rewrite <- map_option_ho in H_fold_r_cons.
      destruct (map_option f l1') eqn:E_fold_r_l1' in H_fold_r_cons.
      ++ apply IHl1' in E_fold_r_l1'.
         injection H_fold_r_cons as H_fold_r_cons. 
         rewrite <- H_fold_r_cons.
         simpl.
         rewrite E_fold_r_l1'.
         reflexivity.
      ++ discriminate H_fold_r_cons.
    + discriminate H_fold_r_cons.
Qed.
  
(* when map_option succeeds on v::l1 and results in v::l2, and
l2 is the result of applying map_option on l1.
*)

Lemma map_option_hd:
  forall (A B: Type) (f: A->option B) (l1: list A) (l2: list B) (v : A) (e: B),
    map_option f (v::l1) = Some (e::l2) ->
    f v = Some e /\ map_option f l1 = Some l2.
Proof.
  intros A B f l1 l2 v e H_fold_r.
  unfold map_option in H_fold_r.
  rewrite <- map_option_ho in H_fold_r.
  destruct (f v) eqn:E_fv.
  + destruct (map_option f l1) eqn:E_fold_r.
    ++ injection H_fold_r as H_b H_l2.
       rewrite H_b. rewrite H_l2.
       split; reflexivity.
    ++ discriminate.
  + discriminate.
Qed.

Lemma map_option_split:
  forall (A B: Type) (f: A->option B) (l1: list A) (l2: list B) (v : A),
    map_option f (v::l1) = Some l2 ->
    exists e' l2',
    l2=(e'::l2') /\ f v = Some e' /\ map_option f l1 = Some l2'.
Proof.
  intros A B f l1 l2 v H_fold_r.
  pose proof (map_option_len A B f (v::l1) l2 H_fold_r) as H_fold_r_len.
  destruct l2 as [|x l] eqn:E_l2; try discriminate.
  pose proof (map_option_hd A B f l1 l v x H_fold_r) as H_fold_r_hd.
  destruct H_fold_r_hd as [H_fold_r_hd_0 H_fold_r_hd_1].
  exists x.
  exists l.
  auto.
Qed.  

(* When map_option succeeds, the i-th element of the output is
the result of applying f to the i-th element in the input.  *)
Lemma map_option_nth:
  forall (A B: Type) (f: A->option B) (l1: list A) (l2: list B),
    map_option f l1 = Some l2 ->
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
    + unfold map_option in H_fold_r_cons.
      rewrite <- map_option_ho in H_fold_r_cons.
      destruct (f e) eqn:E_fa.
      ++ destruct (map_option f l1') eqn:E_fold_r_l1' in H_fold_r_cons; discriminate.
      ++ discriminate.
    + apply map_option_hd in H_fold_r_cons.
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

Lemma map_option_app:
  forall (A B: Type) (f: A->option B) (l1 l2: list A) (rl1 rl2: list B),
    map_option f l1 = Some rl1 ->
    map_option f l2 = Some rl2 ->
    map_option f (l1++l2) = Some (rl1++rl2).
Proof.
  intros A B f.
  induction l1 as [|v l1' IHl1'].
  - intros.
    simpl in H.
    injection H as H.
    rewrite <- H.
    simpl.
    apply H0.
  - intros.
    destruct rl1.
    + apply map_option_len in H. discriminate.
    + apply map_option_hd in H.
      destruct H.
      pose proof (IHl1' l2 rl1 rl2 H1 H0).
      simpl.
      rewrite H. rewrite H2. reflexivity.
Qed.

Lemma map_option_singleton:
  forall A B (f: A -> option B) (v: A) (e: B),
    f v = Some e ->
    map_option f [v] = Some [e].
Proof.
  intros.
  unfold map_option.
  rewrite H.
  reflexivity.
Qed.

Lemma map_option_app1:
  forall (A B: Type) (f: A->option B) (l1 l2: list A) (rl: list B),
    map_option f (l1++l2) = Some (rl) ->
    exists rl1 rl2, rl=rl1++rl2 /\ length rl1 = length l1 /\ length rl2 = length l2.
Proof.
  induction l1 as [|e l1' IHl1'].
  - intros.
    simpl in H.
    exists []. exists rl.
    simpl.
    split; try split; try reflexivity.
    apply map_option_len in H.
    symmetry.
    apply H.
  - intros.
    simpl in H.
    destruct (f e) eqn:E_f_e; try discriminate.
    destruct (map_option f (l1' ++ l2)) eqn:E_mapo; try discriminate.
    injection H as H. 
    pose proof (IHl1' l2 l E_mapo) as IHl1'_0.
    destruct IHl1'_0 as [rl1 [rl2 [IHl1'_0_1 [IHl1'_0_2 IHl1'_3]]]].
    rewrite <- H.
    exists (b::rl1).
    exists rl2.
    split.
    + rewrite <- app_comm_cons.
      rewrite  IHl1'_0_1.
      reflexivity.
    + split.
      * simpl. rewrite   IHl1'_0_2. reflexivity.
      * apply   IHl1'_3.
Qed.

    
Lemma map_option_app2:
  forall (A B: Type) (f: A->option B) (l1 l2: list A) (rl1 rl2: list B),
    length l1 = length rl1 ->
    length l2 = length rl2 ->
    map_option f (l1++l2) = Some (rl1++rl2) ->
    map_option f l1 = Some rl1 /\ map_option f l2 = Some rl2.
Proof.
  intros A B f.
  induction l1 as [|v l1' IHl1'].
  - intros.
    destruct rl1.
    + unfold app in H1.
      split. reflexivity. apply H1.
    + discriminate.
  - intros.
    destruct rl1 as [|v' rl1'] eqn:E_rl1.
    discriminate.
    simpl app in H1.
    simpl in H.
    injection H as H.
    apply map_option_hd in H1 as [H2 H3].
    pose proof (IHl1' l2 rl1' rl2 H H0 H3) as [H4 H5].
    split.
    + unfold map_option.
      rewrite <- map_option_ho.
      rewrite H2.
      rewrite H4.
      reflexivity.
    + apply H5.
Qed.
    

Lemma map_option_swap:
  forall (A B: Type) (f: A->option B) (l1 l2 l3 l4: list A) (rl1 rl2 rl3 rl4: list B),
    length l1 = length rl1 ->
    length l2 = length rl2 ->
    length l3 = length rl3 ->
    length l4 = length rl4 ->
    map_option f (l1++l2++l3++l4) = Some (rl1++rl2++rl3++rl4) ->
    map_option f (l3++l2++l1++l4) = Some (rl3++rl2++rl1++rl4).
Proof.
  intros A B f.
  induction l1 as [|v l1' IHl1'].
  + intros l2 l3 l4 rl1 rl2 rl3 rl4 H_len_l1 H_len_l2 H_len_l3 H_len_l4 H_fldr.
    destruct rl1.
    2: discriminate.
    unfold app in H_fldr at 1.
    unfold app in H_fldr at 3.
    unfold app at 3.
    unfold app at 5.

    assert (length (l3++l4) = length (rl3++rl4) ).
     (* proof of the assert *)
     pose proof (app_length l3 l4).
     pose proof (app_length rl3 rl4).
     rewrite H.
     rewrite H0.
     rewrite H_len_l3.
     rewrite H_len_l4.
     reflexivity.
     (* end proof of assert *)
    pose proof (map_option_app2 A B f l2 (l3++l4) rl2 (rl3++rl4) H_len_l2 H H_fldr).
    destruct H0.
    pose proof (map_option_app2 A B f l3 l4 rl3 rl4 H_len_l3 H_len_l4 H1).
    destruct H2.
    
    
    ++ apply map_option_app.
       +++ apply H2.
       +++ apply map_option_app. apply H0. apply H3.
           
  + intros l2 l3 l4 rl1 rl2 rl3 rl4 H_len_l1 H_len_l2 H_len_l3 H_len_l4 H_fldr.
    destruct rl1 as [|v3 rl1'].
    ++ discriminate.
    ++ repeat (rewrite <- app_comm_cons in H_fldr).
       unfold map_option in H_fldr.
       destruct (f v) eqn:E_f_v. 
       2: discriminate.
       rewrite <- map_option_ho in H_fldr.
       destruct (map_option f (l1' ++ l2 ++ l3 ++ l4)) eqn:E_fldr2.
       2: discriminate.
       injection H_fldr as H_b H_l.
       rewrite H_l in E_fldr2.
       simpl in H_len_l1.
       injection H_len_l1 as H_len_l1'.
       pose proof (IHl1' l2 l3 l4 rl1' rl2 rl3 rl4 H_len_l1' H_len_l2 H_len_l3 H_len_l4 E_fldr2) as E_fldr3.
       assert ( length (l2++l1'++l4) = length(rl2 ++ rl1' ++ rl4) ).
       
       (* proof of the assert *)
         pose proof (app_length l2 (l1'++l4)).
         pose proof (app_length l1' l4).
         rewrite H0 in H.
         pose proof (app_length rl2 (rl1'++rl4)).
         pose proof (app_length rl1' rl4).
         rewrite H2 in H1.
         rewrite H.
         rewrite H1.
         rewrite H_len_l2.
         rewrite H_len_l1'.
         rewrite H_len_l4.
         reflexivity.        
       (* end proof of assert *)
         
       pose proof (map_option_app2 A B f l3 (l2++l1'++l4) rl3 (rl2++rl1'++rl4) H_len_l3 H E_fldr3) as [H_fldr4 H_fldr5].
       assert ( length (l1'++l4) = length(rl1' ++ rl4) ).
         (* proof of the assert *)
         pose proof (app_length l1' l4).
         pose proof (app_length rl1' rl4).
         rewrite H0.
         rewrite H1.
         rewrite H_len_l1'.
         rewrite H_len_l4.
         reflexivity.
         (* end proof of assert *)
       pose proof (map_option_app2 A B f l2 (l1'++l4) rl2 (rl1'++rl4) H_len_l2 H0 H_fldr5) as [H_fldr6 H_fldr7].
       pose proof (map_option_app2 A B f l1' l4 rl1' rl4 H_len_l1' H_len_l4 H_fldr7) as [H_fldr8 H_flr9].
       
       apply map_option_app.
       +++ apply H_fldr4.
       +++ apply map_option_app.
           ++++ apply H_fldr6.
           ++++ apply map_option_app.
                +++++ unfold map_option.
                rewrite <- map_option_ho.
                rewrite E_f_v.
                rewrite  H_fldr8.
                rewrite H_b.
                reflexivity.
                +++++ apply   H_flr9 .
Qed.


Lemma pop_succ_len:
  forall (A: Type) (stk: list A) (stk': list A),
    pop stk = Some stk' -> length stk > 0.
Proof.
  intros A stk stk' H_pop.
  unfold pop in H_pop.
  destruct stk.
  + discriminate.
  + simpl.
    apply gt_Sn_O.
Qed.

Lemma pop_fail:
  forall (A: Type) (stk: list A),
    pop stk = None -> stk = [].
Proof.
  intros A stk H_pop.
  unfold pop in H_pop.
  destruct stk.
  + reflexivity.
  + discriminate.
Qed.

Lemma skipn_nth:
  forall (A: Type)  (l: list A) (k: nat) (v: A),
    nth_error l k = Some v ->
    l = (firstn k l)++v::(skipn (k+1) l).
Proof.
  induction l as [|a l' IHl'].
  - intros.
    destruct k; discriminate.
  - intros.
    destruct k as [|k'].
    + simpl in H.
      simpl.
      injection H as H.
      rewrite H.
      reflexivity.
    + simpl in H.
      apply IHl' in H.
      rewrite Nat.add_1_r.
      rewrite Nat.add_1_r in H.
      simpl firstn.
      rewrite skipn_cons.
      rewrite <- app_comm_cons.
      rewrite <- H.
      reflexivity.
Qed.

Lemma skipn_nth1:
  forall (A: Type) (k: nat)  (l: list A) (v: A),
    nth_error l k = Some v ->
    l = (firstn k l)++v::(skipn (k+1) l).
Proof.
  induction k as [|k' IHk'].
  - intros.
    destruct l.
    discriminate.
    simpl in H.
    simpl.
    injection H as H.
    rewrite H.
    reflexivity.
  - intros.
    destruct l as [|e l'].
    + discriminate.
    + simpl in H.
      apply IHk' in H.
      rewrite Nat.add_1_r.
      rewrite Nat.add_1_r in H.
      simpl firstn.
      rewrite skipn_cons.
      rewrite <- app_comm_cons.
      rewrite <- H.
      reflexivity.
Qed.

Lemma swap_succ:
  forall (T: Type) (k : nat) (stk stk': list T),
    swap k stk = Some stk' ->
    exists (v v':T) (l1 l2: list T),
        stk  = v::(l1++(v'::l2)) /\
        stk' = v'::(l1++(v::l2)).
Proof.
  intros.
  unfold swap in H.
  destruct ((k =? 0) || (16 <? k)) eqn:E_k.
  discriminate.
  destruct (nth_error stk k) as [v''|] eqn:E_nth_err.
  2: discriminate.
  apply skipn_nth in E_nth_err as H_skipn.
  destruct stk as [|a stk''] eqn:E_stk.
  discriminate.
  injection H as H.
  exists a.
  exists v''.
  exists (firstn (k-1) stk''). (* l1 *)
  exists (skipn (k + 1) (a :: stk'')). (* l2 *)
  split.
  + assert (a :: firstn (k - 1) stk'' = firstn k (a::stk'')).
    (* proof of assert *)
     destruct k.
      discriminate.
      simpl.
      rewrite Nat.sub_0_r.
      reflexivity.
      (* end proof of assert *)
      
    rewrite <- H0 in H_skipn.
    rewrite H_skipn at 1.
    rewrite app_comm_cons.
    reflexivity.
  + symmetry.
    apply H.
Qed.

                  
                
Lemma app_same_len:
  forall {A} (l1 l2 rl1 rl2 : list A),
    length l1 = length rl1 ->
    length l2 = length rl2 ->
    l1++l2 = rl1++rl2 ->
    l1 = rl1 /\ l2 = rl2.
Proof.
  induction l1 as [|a l1' IHl1'].
  - simpl.
    intros l2 rl1 rl2 H_len_l1_rl1 H_l1_rl2 H_app.
    symmetry in H_len_l1_rl1.
    apply length_zero_iff_nil in H_len_l1_rl1.
    rewrite H_len_l1_rl1.
    rewrite H_len_l1_rl1 in H_app.
    simpl in H_app.
    rewrite H_app.
    split; try reflexivity.
  - simpl.
    intros l2 rl1 rl2 H_len_l1_rl1 H_l1_rl2 H_app.
    destruct rl1 as [|b rl1']; try discriminate.
    simpl in H_len_l1_rl1.
    injection H_len_l1_rl1 as H_len_l1_rl1.
    rewrite <- app_comm_cons in H_app.
    injection H_app as H_a_b H_app'.
    pose proof (IHl1' l2 rl1' rl2 H_len_l1_rl1 H_l1_rl2 H_app') as [IH1 IH2].
    split.
    + rewrite H_a_b.
      rewrite IH1.
      reflexivity.
    + apply IH2.
Qed.

Lemma skipn_same_len:
  forall {A B} (n: nat) (l1 :list A) (l2 : list B),
    length l1 = length l2 ->
    length (skipn n l1) = length (skipn n l2).
Proof.
  intros A B n l1 l2 H_len.
  repeat rewrite skipn_length.
  rewrite H_len.
  reflexivity.
Qed.

End Misc.

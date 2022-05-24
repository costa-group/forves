(* Enrique Martin - Univ. Complutense de Madrid
   Licensed under the GNU GENERAL PUBLIC LICENSE 3.0.

   You may obtain a copy of the License at
   https://www.gnu.org/licenses/gpl-3.0.txt
*)


Require Export Coq.Lists.List.
Require Export Coq.Strings.Ascii.
Require Export Coq.Strings.String.
Open Scope string_scope.



(* POSSIBLE IMPROVEMENTS:
   - Use faster mappings. Instead of list (key, value) use AVL or RB trees as in evmModel (FMapAVL)
   - Define domains as sets of strings
*)


(******************
  LISTS OF STRINGS 
 ******************)
(* 'In' function for list of strings but returning a boolean *)
Fixpoint In_list_str_eval (e: string) (l: list string) : bool :=
match l with 
  | nil => false
  | v::tail => orb (v =? e) (In_list_str_eval e tail)
end.

(* In and In_list_str_eval are equivalent *)
Lemma in_str_equiv_true: forall (e: string) (l: list string),
  In e l <-> In_list_str_eval e l = true.
Proof.
intros e l. split. 
 + induction l as [ | h t IH].
   - intros H. apply in_nil in H. contradiction.
   - intros H. destruct (eqb e h) eqn: elem_eq.
     * unfold In_list_str_eval. rewrite eqb_sym in elem_eq. rewrite elem_eq. reflexivity.
     * simpl. rewrite eqb_sym in elem_eq. rewrite elem_eq. simpl.
       simpl in H. destruct H.
       ++ rewrite <- eqb_eq in H. rewrite H in elem_eq.
          discriminate elem_eq.
       ++ apply IH in H. assumption.
 + induction l as [ | h t IH].
   - simpl. intros H. discriminate.
   - unfold In_list_str_eval. destruct (h =? e) eqn:eq_eh.
     * simpl. intros Htrue. rewrite eqb_sym in eq_eh. apply eqb_eq in eq_eh.
       left. symmetry. assumption.
     * simpl. fold In_list_str_eval. intros Hin. apply IH in Hin. right. assumption.
Qed.



(* In and In_list_str_eval are equivalent also in the negative case *)
Lemma in_str_equiv_false: forall (e: string) (l: list string),
  ~In e l <-> In_list_str_eval e l = false.
Proof.
intros e l. split. 
+ (* -> *)
  induction l as [ | h t IH].
  - intros Henotinnil. reflexivity.
  - intros Henotin. destruct (eqb e h) eqn: elem_eq.
    * simpl in Henotin.
      pose proof (Decidable.not_or (h = e) (In e t) Henotin) as Henotin_despl.
      destruct Henotin_despl as [Hehdiff Henotint].
      rewrite <- eqb_eq in Henotin.
      rewrite <- eqb_neq in Hehdiff.
      rewrite -> eqb_sym in elem_eq.
      rewrite elem_eq in Hehdiff.
      discriminate.
    * simpl in Henotin. simpl.
      pose proof (Decidable.not_or (h = e) (In e t) Henotin) as Henotin_despl.
      destruct Henotin_despl as [Hehdiff Henotint].
      rewrite -> eqb_sym in elem_eq.
      rewrite -> elem_eq. simpl.
      apply IH in Henotint as Hfinal.
      assumption.
+ (* <- *) induction l as [ | h t IH].
  - intro Hinevalfalse. simpl. unfold not. trivial.
  - intro Hinevalfalse. simpl in Hinevalfalse.
    destruct (eqb e h) eqn: elem_eq.
    * rewrite -> eqb_sym in elem_eq.
      rewrite -> elem_eq in Hinevalfalse. simpl in Hinevalfalse.
      discriminate.
    * rewrite -> eqb_sym in elem_eq.
      rewrite -> elem_eq in Hinevalfalse. simpl in Hinevalfalse.
      apply IH in Hinevalfalse.
      simpl.
      unfold not.
      intro Hin.
      destruct Hin as [Heq|HInet].
      ++ rewrite -> Heq in elem_eq.
         rewrite -> eqb_refl in elem_eq.
         discriminate.
      ++ contradiction.
Qed.

(* In is decidable: In e l /\ ~ In e l
   Useful to apply some lemma from library Coq.Logic.Decidable *)
Lemma in_decidable: forall (e: string) (l: list string),
Decidable.decidable (In e l).
Proof.
intros e l.
unfold Decidable.decidable.
rewrite in_str_equiv_true.
destruct (In_list_str_eval e l) eqn: eqevalin.
- left. reflexivity.
- right. apply Bool.diff_false_true.
Qed.


(* In_list_string_eval is dedicable
   Useful to apply some lemma from library Coq.Logic.Decidable *)
Lemma in_list_str_eval_decidable: forall (e: string) (l: list string) (b:bool),
Decidable.decidable (In_list_str_eval e l = b).
Proof.
intros e l b.
unfold Decidable.decidable.
destruct (In_list_str_eval e l) eqn: eqevalin.
- destruct b eqn: eqb. 
  + left. reflexivity.
  + right. apply Bool.diff_true_false.
- destruct b eqn: eqb. 
  + right. apply Bool.diff_false_true.
  + left. reflexivity.
Qed.


(* No element h of l1 appears in l2 *)
Fixpoint not_in_list (l1 l2: list string) : Prop :=
match l1 with
  | nil => True
  | h::t => ~ (In h l2) /\ (not_in_list t l2)
end.

Definition disjoint_eval (l1 l2: list string) : Prop :=
(not_in_list l1 l2).

Definition disjoint (l1 l2: list string) : Prop :=
forall (x: string), In x l1 -> ~ In x l2.

Lemma disjoint_extend: forall (l1 l2: list string) (elem: string),
disjoint l1 l2 ->
~ In elem l2 ->
disjoint (elem::l1) l2.
Proof.
intros l1 l2 elem Hdisjoint Hnotin.
unfold disjoint.
intro e. simpl.
rewrite <- eqb_eq.
destruct (elem =? e) eqn: eqeleme.
- simpl. rewrite -> eqb_eq in eqeleme.
  rewrite <- eqeleme. intro Htrue. assumption.
- unfold orb. intro He.
  destruct He as [Hfalse | Heinl1].
  + discriminate.
  + unfold disjoint in Hdisjoint.
    pose proof (Hdisjoint e) as Henotin.
    apply Henotin in Heinl1.
    assumption.
Qed.

Search In.


Lemma disjoint_split: forall (l1 l2: list string) (elem: string),
disjoint (elem::l1) l2 ->
~ In elem l2 /\ disjoint l1 l2.
Proof.
intros l1 l2 elem.
unfold disjoint.
intros Himpl.
split.
- pose proof (Himpl elem).
  pose proof (in_eq elem l1) as Helemincons.
  apply H in Helemincons.
  assumption.
- intros y.
  pose proof (Himpl y) as Himply.
  intros Hyinl1.
  pose proof (in_cons elem y l1) as Hyineleml1.
  apply Hyineleml1 in Hyinl1.
  apply Himply in Hyinl1.
  assumption.
Qed.



Lemma disjoint_equiv: forall (l1 l2: list string),
disjoint_eval l1 l2 <-> disjoint l1 l2.
Proof.
split.
- (* -> *) 
  induction l1 as [|h t IH].
  + simpl. intro Htrue. unfold disjoint.
    intro elem. simpl. intro Hfalse. contradiction.
  + simpl. intros [Hnotinl2 Hdisjoint].
    apply IH in Hdisjoint.
    apply disjoint_extend; try assumption.
- (* <- *)
  induction l1 as [|h t IH].
  + simpl. trivial. 
  + simpl. intro Hdisjoint.
    pose proof (disjoint_split t l2 h) as Hsplitdisjoint.
    apply Hsplitdisjoint in Hdisjoint.
    destruct Hdisjoint as [Hnotinl2 Hdisjointl2].
    apply IH in Hdisjointl2.
    split; try assumption.
Qed.



Lemma disjoint_sym: forall (l1 l2: list string),
  (disjoint l1 l2) -> (disjoint l2 l1).
Proof.
intros l1 l2.
unfold disjoint.
intro Hdisjoint.
intros elem Hxinl2.
destruct (In_list_str_eval elem l1) eqn: Helem_in_l1.
- rewrite <- in_str_equiv_true in Helem_in_l1.
  pose proof (Hdisjoint elem Helem_in_l1). contradiction.
- rewrite <- in_str_equiv_false in Helem_in_l1.
  assumption.
Qed.


Lemma disjoint_then_not_in: forall (l m: list string) (name: string),
disjoint l m ->
In name l ->
~ In name m.
Proof.
intros l m name Hdisjoint.
unfold disjoint in Hdisjoint.
pose proof (Hdisjoint name).
assumption.
Qed.





(**********
  MAPPINGS 
 **********)

(* Mapping as list of tuples with duplicates. Probably FMapAVL is better and faster, but we
   need to define keys as OrderedType and I don't know how to do that *)
Definition map (T : Type) : Type := list (string * T).
Definition empty_map {A : Type} : map A := nil.

Definition update {A : Type} (m : map A) (x : string) (v : A): map A :=
  (x,v) :: m.

Fixpoint lookup {A : Type} (m : map A) (x : string) : option A :=
match m with
  | nil => None
  | (y,v)::tail => if x =? y then Some v else (lookup tail x)
end.

(* Removes all mappings from key to a value, even if there are several *)
Fixpoint remove {A : Type} (m: map A) (key: string) : map A :=
match m with
| nil => nil
| ((h,v)::t) => if (h =? key) then ((remove t key)) else (h,v)::(remove t key)
end.

Example remove_ex1: remove (("a",1)::("a",2)::("a",3)::nil) "a" = nil.
Proof. reflexivity. Qed.
Example remove_ex2: remove (("a",1)::("b",2)::("a",3)::nil) "a" = ("b",2)::nil.
Proof. reflexivity. Qed.
Example remove_ex3: remove (("a",1)::("b",2)::("a",3)::nil) "key" = 
(("a",1)::("b",2)::("a",3)::nil).
Proof. reflexivity. Qed.



Fixpoint domain {A: Type} (m: map A) : list string :=
match m with
  | nil => nil
  | (k,v)::tail => k::(domain tail)
end.



(* looking for a key after updating the map returns the inserted value *)
Lemma update_lookup: forall (T: Type) (m:  map T) (key: string) (value: T),
  lookup (update m key value) key = Some value.
Proof.
  intros T m key value.
  unfold update. unfold lookup. destruct (key =? key) eqn: EqKey.
  - reflexivity.
  - rewrite -> (eqb_refl key) in EqKey. (* from Coq.Strings.String *)
    discriminate.
Qed.


(* looking for a different key after updating the map is the same as looking in the
   original map *)
Lemma update_lookup_diff: forall (T: Type) (m:  map T) (key1 key2: string) (value: T),
  key1 =? key2 = false -> lookup (update m key1 value) key2 = lookup m key2.
Proof.
  intros T m key1 key2 value HKey. unfold update. unfold lookup.
  rewrite -> (eqb_sym key1 key2) in HKey. (* from Coq.Strings.String *)
  rewrite HKey. reflexivity.
Qed.


Lemma lookup_then_key_in_domain: forall {A: Type} (m: map A) (key: string) 
      (value: A),
lookup m key = Some value -> In key (domain m).
Proof.
intros A m key value.
induction m as [ | pair tail].
- simpl. intro Hfalse. discriminate.
- unfold lookup.
  destruct (pair) as [k v].
  destruct (key =? k) eqn: eqkey.
    + apply eqb_eq in eqkey. rewrite -> eqkey. intro Hvalue.
      unfold domain. unfold In. left. reflexivity.
    + fold @lookup. (* The @ is needed because of the implicit parameter, otherwise
                       it cannot infer the type A *)
      intros Hlookuptail.
      unfold domain.
      unfold In.
      right.
      fold @domain. 
      apply IHtail in Hlookuptail.
      assumption.
Qed.



Lemma in_domain_then_lookup: forall {A: Type} (m: map A) (key: string),
In key (domain m) -> exists (value:A), lookup m key = Some value.
Proof.
intros A m key.
induction m as [ | pair tail].
- simpl. intro Hfalse. contradiction.
- destruct (pair) as [k v]. unfold domain.
  destruct (key =? k) eqn: eqkey.
  + apply eqb_eq in eqkey. rewrite -> eqkey. intro Hdespl. 
    exists v. unfold lookup.
    rewrite -> eqb_refl. reflexivity.
  + fold @domain. intro Hdespl.
    destruct Hdespl as [Hkeyfalse|Hintail].
    * rewrite eqb_neq in eqkey. rewrite Hkeyfalse in eqkey. contradiction.
    * unfold In in IHtail.
      apply IHtail in Hintail.
      unfold lookup.
      rewrite -> eqkey.
      fold @lookup.
      assumption.
Qed.



Lemma not_in_domain_then_lookup_none: forall {A: Type} (m: map A) (key: string),
~In key (domain m) -> lookup m key = None.
Proof.
intros A m key.
induction m as [ | pair tail].
- simpl. intro Hfalse. reflexivity.
- destruct (pair) as [k v]. unfold domain.
  destruct (key =? k) eqn: eqkey.
  + rewrite -> in_str_equiv_true. 
    unfold In_list_str_eval.
    rewrite eqb_sym.
    rewrite -> eqkey.
    simpl. 
    intro Hfalse. contradiction.
  + simpl. fold @domain. intro Hdespl.
    pose proof (Decidable.not_or (k = key) (In key (domain tail)) Hdespl) as Hindomain.
    destruct Hindomain as [Hkkey Hdomaintail].
    rewrite eqb_sym.
    rewrite <- eqb_neq in Hkkey.
    rewrite -> Hkkey.
    apply IHtail in Hdomaintail.
    assumption.
Qed.


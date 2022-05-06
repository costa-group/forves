From Coq_EVM Require Import evmModel.
Require Import Coq.Lists.List.
Require Import bbv.Word.
Require Import Coq.Init.Nat. (* for <? *)

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






(**********
  SFS 
 **********)

Definition abstract_stack := list string.

Inductive sfs_val : Type :=
  | SFSconst (v: EVMWord)
  | SFSname (name: string)
  | SFSbinop (op: OpCode) (name1 name2: string).
  (* SFSuop y SFSterop *)
  
Definition sfs_map := map sfs_val.

Inductive sfs : Type := 
  SFS (abs: abstract_stack) (map: sfs_map).

(* Initial stack and SFS map contains disjoint symbols *)
Definition disjoint_stack_sfs (stack: map EVMWord) (csfs: sfs) : Prop :=
match csfs with 
  | SFS abs sfsmap => disjoint (domain stack) (domain sfsmap)
end.



(* Syntactic equality of Opcode (instructions) 
   TODO: extend to all possible instructions and prove equivalence with =:
         - (EVMoper_eqb i1 i2) = true <-> i1 = i2
         - (EVMoper_eqb i1 i2) = false <-> i1 <> i2
   *)
Definition EVMoper_eqb (i1 i2: OpCode) : bool :=
match (i1, i2) with
 | (STOP, STOP) => true
 | (RETURN, RETURN) => true
 | (ComplexPriceOpcodeMk op1, ComplexPriceOpcodeMk op2) => false (* Not supported *)
 | (SimplePriceOpcodeMk op1, SimplePriceOpcodeMk op2) => match (op1, op2) with
                                                          | (ADD, ADD) => true
                                                          | (MUL, MUL) => true
                                                          | (SUB, SUB) => true
                                                          | (PUSH arg1 w1, PUSH arg2 w2) => andb (weqb arg1 arg2) (weqb w1 w2)
                                                          | (POP, POP) => true
                                                          | _ => false
                                                         end
 | _ => false
end.

Compute (EVMoper_eqb (SimplePriceOpcodeMk (PUSH (natToWord 5 7) (natToWord WLen 200))) 
                     (SimplePriceOpcodeMk POP)
).

(* Recursive function for syntactic equality *)
Definition sfsval_eqb (sfs1 sfs2: sfs_val) : bool :=
match (sfs1, sfs2) with
 | (SFSconst v1, SFSconst v2) => weqb v1 v2
 | (SFSname name1, SFSname name2) => name1 =? name2
 | (SFSbinop op1 arg11 arg12, SFSbinop op2 arg21 arg22) => 
      andb (EVMoper_eqb op1 op2) 
           (andb (arg11 =? arg21) (arg12 =? arg22))
 | _ => false
end.



(**********
 Generation of abstract stack names 
 **********)

Definition nat_to_ascii_digit (n: nat) : string := 
  let num := modulo n 10 in
  string_of_list_ascii ((ascii_of_nat ((nat_of_ascii "0") + n))::nil).

(* 'depth' is the fake argument for strong normalization *)
Fixpoint nat_to_string_aux (n: nat) (depth:nat): string :=
match depth with
 | 0 => ""
 | S m => if n <? 10 then (nat_to_ascii_digit n) 
          else
            let last_digit := modulo n 10 in
            let rest_num := div n 10 in
            append (nat_to_string_aux rest_num m) (nat_to_ascii_digit last_digit)
end.

(* String of the last 50 digits in 'n' *)
Definition nat_to_string (n: nat) : string :=
nat_to_string_aux n 50.


Fixpoint create_abs_stack_name_rev (n: nat) (prefix: string): list string :=
match n with
 | 0 => (append prefix (nat_to_string 0))::nil
 | S m => ((append prefix (nat_to_string (S m)))::(create_abs_stack_name_rev m prefix)) 
end.

Definition create_abs_stack_name (n: nat) (prefix: string): list string :=
rev (create_abs_stack_name_rev (n-1) prefix).

Compute (create_abs_stack_name 10 "s").


(*****************
 Generation of SFS from EVM bytecode
 Get a parameter of fresh abstract stack names to be used
 *****************)

(* arg is a word of length 5 that represents the argument of the PUSH: PUSH 1 = PUSH 00000, PUSH 2 = PUSH 00001, etc. *)
Definition abs_eval_push (arg: word 5) (word: EVMWord) (curr_sfs: sfs) (fresh_stack_names: list string)
  : option (sfs * list string) :=
match fresh_stack_names with
 | nil => None
 | next_stack_name::rest_stack_names => match curr_sfs with
                                         | SFS sfs_stack sfs_map => let value := pushWordPass word (wordToNat arg + 1) in
                                                                    Some (SFS (next_stack_name::sfs_stack) 
                                                                              (update sfs_map next_stack_name (SFSconst value)), 
                                                                          rest_stack_names)
                                         end
end.

Definition abs_eval_pop (curr_sfs: sfs) (fresh_stack_names: list string)
  : option (sfs * list string) :=
match curr_sfs with
 | SFS sfs_stack sfs_map => match sfs_stack with
                             | top::r => Some ((SFS r sfs_map), fresh_stack_names)
                             | nil => None
                            end
end.

(* General code for every simple binary operation in the stack *)
Definition abs_eval_binary (oper: OpCode) (curr_sfs: sfs) (fresh_stack_names: list string)
  : option (sfs * list string) :=
match fresh_stack_names with
 | nil => None
 | next_stack_name::rest_stack_names =>
     match curr_sfs with
      | SFS sfs_stack sfs_map =>
          match sfs_stack with
           | s0::s1::rstack => Some (SFS (next_stack_name::rstack) 
                                         (update sfs_map next_stack_name (SFSbinop oper s0 s1)),
                                     rest_stack_names)
           | _ => None
          end
     end
end.

Compute abs_eval_binary (SimplePriceOpcodeMk ADD) (SFS ("s0"::"s1"::nil) empty_map) ("nueva pos"::"otra mas"::nil).
Compute abs_eval_binary (SimplePriceOpcodeMk SUB) (SFS ("s0"::"s1"::"s2"::nil) empty_map) ("nueva pos"::"name2"::nil).


(* Function to evaluate an operation in a SFS *)
Definition abs_eval_op (oper: OpCode) (curr_sfs: sfs) (fresh_stack_names: list string)
  : option (sfs * list string) :=
match oper with
  | SimplePriceOpcodeMk ADD => abs_eval_binary (SimplePriceOpcodeMk ADD) curr_sfs fresh_stack_names
  | SimplePriceOpcodeMk MUL => abs_eval_binary (SimplePriceOpcodeMk MUL) curr_sfs fresh_stack_names
  | SimplePriceOpcodeMk SUB => abs_eval_binary oper curr_sfs fresh_stack_names
  | SimplePriceOpcodeMk (PUSH arg word) => abs_eval_push arg word curr_sfs fresh_stack_names
  | SimplePriceOpcodeMk POP => abs_eval_pop curr_sfs fresh_stack_names
 (* All binary instructions are evaluated the same
  | DIV	          => 5
  | SDIV	        => 5
  | MOD	          => 5
  | SMOD	        => 5
  | ADDMOD	      => 8
  | MULMOD	      => 8
  ----
  *)
  | _ => None
end.

Check (abs_eval_op).
Compute abs_eval_op (SimplePriceOpcodeMk ADD) (SFS ("s0"::"s1"::nil) empty_map) ("nueva pos"::"otra mas"::nil).
Compute abs_eval_op (SimplePriceOpcodeMk SUB) (SFS ("s0"::"s1"::nil) empty_map) ("nueva pos"::"otra mas"::nil).


Fixpoint abstract_eval_aux (program: list OpCode) (curr_sfs: sfs) (fresh_stack_names: list string)
  : option (sfs * list string) :=
match program with 
  | nil => Some (curr_sfs, fresh_stack_names)
  | oper::rprog => match abs_eval_op oper curr_sfs fresh_stack_names with
                    | None => None
                    | Some (new_sfs, new_stack_names) => abstract_eval_aux rprog new_sfs new_stack_names
                   end
end.

Definition abstract_eval (program: list OpCode)
  : option sfs :=
let ins := create_abs_stack_name 10 "s" in (* The 10 is fixed... *)
let outs := create_abs_stack_name StackLen "e" in (* generates 'StackLen' names*)
match abstract_eval_aux program (SFS ins empty_map) outs with
 | None => None
 | Some (final_sfs, _) => Some final_sfs
end.


Check abstract_eval (SimplePriceOpcodeMk ADD::nil).
Compute (abstract_eval (SimplePriceOpcodeMk ADD::nil)).
Compute (abstract_eval (SimplePriceOpcodeMk ADD::SimplePriceOpcodeMk MUL::nil)).
Compute (abstract_eval (SimplePriceOpcodeMk ADD::SimplePriceOpcodeMk POP::nil)).
Compute (abstract_eval (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 10))::SimplePriceOpcodeMk POP::nil)).


(*
(****************
 SFS equivalence [not used]
*****************)
Definition sfs_eq_symbol (d: nat) (symb1 symb2 : string) (map1 map2 : sfs_map) : bool :=
match (resolve_sfs_expr d (SFSname symb1) map1, resolve_sfs_expr d (SFSname symb2) map2) with
 | (None, _) => false
 | (_, None) => false
 | (Some sfs1, Some sfs2) => sfsval_eqb sfs1 sfs2
end.

Fixpoint sfs_eq_list (d: nat) (in1 in2 : abstract_stack) (map1 map2 : sfs_map) : bool :=
match in1 with 
 | nil => match in2 with
           | nil => true
           | _::_ => false
          end
 | v1::r1 => match in2 with
              | nil => false
              | v2::r2 => andb (sfs_eq_symbol d v1 v2 map1 map2) (sfs_eq_list d r1 r2 map1 map2)
             end
end.

Definition sfs_eqb (d: nat) (sfs1 sfs2 : sfs) : bool :=
match (sfs1, sfs2) with
 | (SFS in1 map1, SFS in2 map2) => sfs_eq_list d in1 in2 map1 map2
end.


(* Test: equivalent SFS *)
Compute (abstract_eval (SimplePriceOpcodeMk ADD::SimplePriceOpcodeMk POP::nil)).
Compute (abstract_eval (SimplePriceOpcodeMk POP::SimplePriceOpcodeMk POP::nil)).
Compute (
let prog1 := abstract_eval (SimplePriceOpcodeMk ADD::SimplePriceOpcodeMk POP::nil) in 
let prog2 := abstract_eval (SimplePriceOpcodeMk POP::SimplePriceOpcodeMk POP::nil) in 
match (prog1, prog2) with
 | (Some sfs1, Some sfs2) => Some (sfs_eqb 1024 sfs1 sfs2)
 | _ => None
end).

Compute (
let sfs1 := SFS ("s2"::"s3"::nil) (("e0",SFSbinop (SimplePriceOpcodeMk ADD) (SFSname "s0") (SFSname "s1"))::nil) in
let sfs2 := SFS ("e0"::"s3"::"s4"::nil) (("e0",SFSbinop (SimplePriceOpcodeMk SUB) (SFSname "s1")(SFSname "s2"))::nil) in
sfs_eqb 1024 sfs1 sfs2
).

(* Test: not equivalent SFS *)
Compute (abstract_eval (SimplePriceOpcodeMk ADD::SimplePriceOpcodeMk POP::nil)).
Compute (abstract_eval (SimplePriceOpcodeMk POP::SimplePriceOpcodeMk SUB::nil)).
Compute (
let prog1 := abstract_eval (SimplePriceOpcodeMk ADD::SimplePriceOpcodeMk POP::nil) in 
let prog2 := abstract_eval (SimplePriceOpcodeMk POP::SimplePriceOpcodeMk SUB::nil) in 
match (prog1, prog2) with
 | (Some sfs1, Some sfs2) => Some (sfs_eqb 1024 sfs1 sfs2)
 | _ => None
end).
*)



(*************
 Evaluation of a final stack position from concrete initial stack and a SFS 
**************) 

Definition empty_execution_state (stack: list (EVMWord)) : ExecutionState :=
  ExecutionStateMk stack 
                   (M.empty EVMWord)
                   (M.empty EVMWord)
                   (M.empty (list (word 8)))
                   0
                   nil.

Definition empty_callinfo : CallInfo := 
CallInfoMk nil 
           (natToWord WLen 0)
           (natToWord WLen 0)
           (natToWord WLen 0)
           (natToWord WLen 0)
           (natToWord WLen 0)
           nil
           (natToWord WLen 0)
           (natToWord WLen 0)
           (natToWord WLen 0)
           (natToWord WLen 0)
           (natToWord WLen 0)
           (natToWord WLen 0)
           (natToWord WLen 0)
           (M.empty EVMWord).


Definition evaluate_concrete_element (oper: OpCode) (args: list EVMWord) 
  : option EVMWord :=
(* relies on actOpcode, the EVM model function for evaluating programs. Here I construct an 
   ad-hoc program and stack and execute it inside an empty execution state and empty callinfo *)
match (actOpcode 1000 0 (empty_execution_state args) (oper::STOP::nil) empty_callinfo) with
 | inr (SuccessfulExecutionResultMk (ExecutionStateMk (e::_) _memory _storage _pc _contracts _)) => Some e
 | _ => None
end.


(* Dummy natural variable "d" for decreasingness *)
Fixpoint evaluate_sfs_from_map (d: nat) (concrete_stack: map EVMWord) (spec: sfs) (symbol: string)
  : option EVMWord :=
match d with
 | 0 => None
 | S d' => match lookup concrete_stack symbol with
            | Some value => Some value
            | None => match spec with 
                       | SFS _ sfsm => match lookup sfsm symbol with
                                        | Some (SFSconst v) => Some v
                                        | Some (SFSbinop oper name1 name2) => 
                                            match (evaluate_sfs_from_map d' concrete_stack spec name1,
                                                   evaluate_sfs_from_map d' concrete_stack spec name2) with
                                             | (Some v1, Some v2) => evaluate_concrete_element oper (v1::v2::nil)
                                             | _ => None
                                            end
                                        | Some (SFSname name) => evaluate_sfs_from_map d' concrete_stack spec name
                                        | None => None
                                       end
                      end
           end
end.


Lemma eval_more_steps: forall (d: nat) (stack: map EVMWord) (ini_abs: abstract_stack) 
(ini_sfs_map: sfs_map) (symbol: string) (val: EVMWord),
evaluate_sfs_from_map d stack (SFS ini_abs ini_sfs_map) symbol = Some val
-> evaluate_sfs_from_map (S d) stack (SFS ini_abs ini_sfs_map) symbol = Some val.
Proof.
intro d. induction d as [ | d' IH].
 - intros stack ini_abs ini_sfs_map symbol val.
   unfold evaluate_sfs_from_map. intro Hnonesome. discriminate.
 - intros stack ini_abs ini_sfs_map symbol val.
   remember (S d') as succdp eqn: Heqsuccdp. (* Defines succdp = S d', useful for unfolding *)
   rewrite -> Heqsuccdp at 1.
   unfold evaluate_sfs_from_map.
   destruct (lookup stack symbol) as [v | ] eqn: eqlookupstackvalue; try trivial.
   destruct (lookup ini_sfs_map symbol) as [v | ] eqn: eqlookupmapvalue; try trivial.
   destruct v as [value|name|op name1 name2] eqn: Hv.
   + trivial.
   + fold evaluate_sfs_from_map.
     rewrite -> Heqsuccdp.
     pose proof (IH stack ini_abs ini_sfs_map name val) as IHspec.
     rewrite -> Heqsuccdp in IHspec.
     assumption.
   + fold evaluate_sfs_from_map.
     destruct (evaluate_sfs_from_map d' stack (SFS ini_abs ini_sfs_map) name1) 
       as [v1|] eqn: Hevalname1.
     * destruct (evaluate_sfs_from_map d' stack (SFS ini_abs ini_sfs_map) name2) 
          as [v2|] eqn: Hevalname2.
       -- pose proof (IH stack ini_abs ini_sfs_map name1 v1) as IHspecname1.
          apply IHspecname1 in Hevalname1.
          rewrite -> Hevalname1.
          pose proof (IH stack ini_abs ini_sfs_map name2 v2) as IHspecname2.
          apply IHspecname2 in Hevalname2.
          rewrite -> Hevalname2.
          trivial.
       -- intro Hfalse. discriminate.
     * intro Hfalse. discriminate.
Qed.



Example push_4_3:
match abstract_eval (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 4))::
                     SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 3))::
                     SimplePriceOpcodeMk ADD::
                     nil) with
 | Some csfs => (*Some csfs*)
                (evaluate_sfs_from_map 1024 empty_map csfs "e0",
                 evaluate_sfs_from_map 1024 empty_map csfs "e1",
                 evaluate_sfs_from_map 1024 empty_map csfs "e2",
                 evaluate_sfs_from_map 1024 empty_map csfs "s0",
                 evaluate_sfs_from_map 1024 empty_map csfs "e3")
 | _ => (None, None, None, None, None)
end = (Some (natToWord WLen 4), 
       Some (natToWord WLen 3),
       Some (natToWord WLen 7),
       None,
       None).
Proof.
 reflexivity. Qed.


Definition safeWordToNat (w: option EVMWord) : option nat :=
match w with
 | None => None
 | Some w => Some (wordToNat w)
end.


Compute (let init_map := ("s0", natToWord WLen 6)::("s1", (natToWord WLen 5))::nil in 
         let spec := SFS nil (("e0", SFSbinop (SimplePriceOpcodeMk ADD) "s0" "s1")::nil) in 
         safeWordToNat (evaluate_sfs_from_map StackLen init_map spec "s1")).
Compute (let init_map := ("s0", natToWord WLen 6)::("s1", (natToWord WLen 5))::nil in 
         let spec := SFS nil (("e0", SFSbinop (SimplePriceOpcodeMk ADD) "s0" "s1")::nil) in 
         safeWordToNat (evaluate_sfs_from_map StackLen init_map spec "e0")).
Compute (let init_map := ("s0", natToWord WLen 6)::("s1", (natToWord WLen 5))::("s2", (natToWord WLen 2))::nil in 
         let spec := SFS nil (("e0", SFSbinop (SimplePriceOpcodeMk ADD) "s0" "s1")::
                              ("e1", SFSbinop (SimplePriceOpcodeMk MUL) "e0" "s2")::nil) in 
         safeWordToNat (evaluate_sfs_from_map StackLen init_map spec "e1")).
Compute (let init_map := ("s0", natToWord WLen 6)::("s1", (natToWord WLen 5))::
                         ("s2", (natToWord WLen 2))::("s3", (natToWord WLen 2))::nil in 
         let spec := SFS nil (("e0", SFSbinop (SimplePriceOpcodeMk ADD) ("s0") ("s1"))::
                              ("e1", SFSbinop (SimplePriceOpcodeMk MUL) ("e0") ("s2"))::
                              ("e2", SFSbinop (SimplePriceOpcodeMk SUB) ("e1") ("s3"))::nil) in 
         safeWordToNat (evaluate_sfs_from_map StackLen init_map spec "e2")).


(* Combining the abstract evaluation of a program and the concrete evaluation of a final stack position *)
Example ex1: 
let program := (SimplePriceOpcodeMk ADD::SimplePriceOpcodeMk MUL::nil) in
let stack   := (("s0", natToWord WLen 2)::("s1", natToWord WLen 5)::("s2", natToWord WLen 3)::
                ("s3", natToWord WLen 6)::nil) in
let sfso := abstract_eval program in
match sfso with
 | None => None
 | Some sfs => match (safeWordToNat (evaluate_sfs_from_map StackLen stack sfs "e1")) with
                | None => None
                | Some v => Some v
               end
end = Some 21.
Proof.
reflexivity. Qed.

(* Two SFS specifications are the same if given a concrete stack, they evaluate their
   abstract symbols to the same EVM values (EVMWord) *)
Fixpoint sfs_equiv_concrete_values_aux (concrete_stack: map EVMWord) 
  (abs1: abstract_stack) (sfsmap1: sfs_map) (abs2: abstract_stack) (sfsmap2: sfs_map) : bool :=
match (abs1, abs2) with
  | (nil, nil) => true  
  | (symb1::r1, symb2::r2) => 
      let v1 := evaluate_sfs_from_map 1024 concrete_stack (SFS abs1 sfsmap1) symb1 in
      let v2 := evaluate_sfs_from_map 1024 concrete_stack (SFS abs2 sfsmap2) symb2 in
      match (v1, v2) with
       | (Some w1, Some w2) => andb (weqb w1 w2) (sfs_equiv_concrete_values_aux concrete_stack r1 sfsmap1 r2 sfsmap2)
       | _ => false
      end
  | _ => false
end.


(* Two SFS are equivalent for a concrete stack if both have the same length and each SFS maps every
   stack position to the same concrete value (wrt. the concrete stack) *)
Definition sfs_equiv_concrete_values (concrete_stack: map EVMWord) (spec1 spec2: sfs) : bool :=
match (spec1, spec2) with
 | (SFS abs1 sfsmap1, SFS abs2 sfsmap2) => sfs_equiv_concrete_values_aux concrete_stack abs1 sfsmap1 abs2 sfsmap2
end.
Check sfs_equiv_concrete_values.


(* Generates an empty list of the same EVMWord *)
Fixpoint empty_concrete_stack (n: nat) : list EVMWord :=
match n with
 | 0 => nil
 | S n' => WZero :: (empty_concrete_stack n')
end.

(* Generates a full stack (mapping) from s_n to WZero *)
Definition full_emtpy_stack : map EVMWord :=
 let len := StackLen in
 List.combine (create_abs_stack_name len "s") (empty_concrete_stack len).
 

Compute (
let init_stack := full_emtpy_stack in
let osfs1 := abstract_eval ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 15)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 0)))::
                           SimplePriceOpcodeMk ADD::
                           nil) in
let osfs2 := abstract_eval ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 15)))::
                           nil) in
match (osfs1, osfs2) with
 | (Some sfs1, Some sfs2) => Some (sfs_equiv_concrete_values init_stack sfs1 sfs2)
 | _ => None
end
).

Compute (
let init_stack := full_emtpy_stack in
let osfs1 := abstract_eval ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 10)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 5)))::
                           SimplePriceOpcodeMk ADD::
                           nil) in
let osfs2 := abstract_eval ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 5)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 5)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 5)))::
                           SimplePriceOpcodeMk ADD::
                           SimplePriceOpcodeMk ADD::
                           nil) in
match (osfs1, osfs2) with
 | (Some sfs1, Some sfs2) => Some (sfs_equiv_concrete_values init_stack sfs1 sfs2)
 | _ => None
end
).

Compute (
let init_stack := full_emtpy_stack in
let osfs1 := abstract_eval ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 10)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 5)))::
                           SimplePriceOpcodeMk ADD::
                           nil) in
let osfs2 := abstract_eval ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 15)))::
                           nil) in
match (osfs1, osfs2) with
 | (Some sfs1, Some sfs2) => Some (sfs_equiv_concrete_values init_stack sfs1 sfs2)
 | _ => None
end
).

Compute (
let init_stack := full_emtpy_stack in
let osfs1 := abstract_eval ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 10)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 4)))::
                           SimplePriceOpcodeMk ADD::
                           nil) in
let osfs2 := abstract_eval ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 15)))::
                           nil) in
match (osfs1, osfs2) with
 | (Some sfs1, Some sfs2) => Some (sfs_equiv_concrete_values init_stack sfs1 sfs2)
 | _ => None
end
).



(*************
  POINTS-TO symbol to constant
 *************)

(* Checks if the mapping of the 'label' in the 'smap' is the constant 'value' in one step *)
Definition points_to_const (label: string) (smap: sfs_map) (value: EVMWord) : bool :=
match lookup smap label with
 | Some (SFSconst val) => weqb val value
 | _ => false
end.

Compute (
abstract_eval (SimplePriceOpcodeMk (PUSH (natToWord 5 0) WZero)::
               SimplePriceOpcodeMk ADD::
               nil)).

Compute (
match abstract_eval (SimplePriceOpcodeMk (PUSH (natToWord 5 0) WZero)::
                     SimplePriceOpcodeMk ADD::
                     nil) with
 | Some (SFS abs smap) => Some (points_to_const "e0" smap WZero)
 | _ => None
end
).


Lemma points_to_then_eval: forall (d:nat) (symb: string) (abs: abstract_stack)
      (csfs_map: sfs_map) (value val: EVMWord) (concrete_stack: map EVMWord),
 (points_to_const symb csfs_map value) = true
 -> lookup concrete_stack symb = None
 -> evaluate_sfs_from_map d concrete_stack (SFS abs csfs_map) symb = Some val 
 -> val = value.
Proof. 
 intros d symb abs csfs_map value val concrete_stack.
 unfold points_to_const.
 destruct (lookup csfs_map symb) as [s|] eqn: eqlookup.
 + destruct s as [ | name | ] eqn: eqs.
   - unfold evaluate_sfs_from_map. destruct d as [ | d'] eqn: eqd.
     * intros Heq HNonesome. discriminate.
     * intros Heq Hlookup. rewrite -> Hlookup.
       rewrite -> eqlookup.
       destruct d' as [ | d''] eqn: eqd'.
       ++ intros Hvval. injection Hvval.
          injection Hvval.
          intro eqvval.
          apply weqb_true_iff in Heq.
          rewrite -> Heq. intros Hvalueval.
          symmetry. assumption.
       ++ intros Hvval. injection Hvval.
          injection Hvval.
          intro eqvval.
          apply weqb_true_iff in Heq.
          rewrite -> Heq. intros Hvalueval.
          symmetry. assumption.
  - destruct (lookup csfs_map name) eqn: eqlookup2.
    * intros falsetrue. discriminate.
    * intros falsetrue. discriminate.
  - intros falsetrue. discriminate.
 + intros falsetrue. discriminate.
Qed.


(* If points_to detect that a symbol points to a constant in the SFS, then it cannot 
   appear in the stack because they are disjoint *)
Lemma points_to_not_in_stack: forall (stack: map EVMWord) (ini_abs: abstract_stack) 
                             (ini_sfs_map: sfs_map) (name: string) (val: EVMWord),
disjoint_stack_sfs stack (SFS ini_abs ini_sfs_map)
-> points_to_const name ini_sfs_map val = true
-> lookup stack name = None.
Proof.
intros stack ini_abs ini_sfs_map name val.
unfold disjoint_stack_sfs.
intro Hdisjoint.
unfold points_to_const.
destruct (lookup ini_sfs_map name) as [valname|] eqn: Hlookupmap;
  try (intro Hfalse; discriminate).
destruct valname as [constname|rname|op name1 name2] eqn: Hvalname;
  try (intro Hfalse; discriminate).
pose proof (@lookup_then_key_in_domain sfs_val ini_sfs_map name
  (SFSconst constname) Hlookupmap) as Hname_in_sfsmap.
pose proof (disjoint_then_not_in (domain stack) (domain ini_sfs_map)
  name Hdisjoint).
pose proof (disjoint_sym (domain stack) (domain ini_sfs_map) Hdisjoint)
  as Hdisjoint_sym.
pose proof (disjoint_then_not_in (domain ini_sfs_map) (domain stack)
  name Hdisjoint_sym Hname_in_sfsmap) as Hname_not_in_stack.
intro Heqconst.
pose proof (@not_in_domain_then_lookup_none EVMWord stack name
  Hname_not_in_stack) as Hlookup_none.
assumption.
Qed.



(**************
  OPTIMIZATION X+0 -> X
 **************)

(* ADD(X, 0) -> X and ADD(0, X) -> X *)
Definition optimize_add_zero (s: sfs) (var: string) : option sfs :=
match s with
 | SFS abs smap => 
     match lookup smap var with
      | Some (SFSbinop (SimplePriceOpcodeMk ADD) a b) =>
          if points_to_const a smap WZero then Some (SFS abs (update smap var (SFSname b)))
          else if points_to_const b smap WZero then Some (SFS abs (update smap var (SFSname a)))
          else None
      | _ => None
     end
end.

Compute (
match abstract_eval (SimplePriceOpcodeMk (PUSH (natToWord 5 0) WZero)::
                     SimplePriceOpcodeMk ADD::
                     nil) with
 | Some (SFS abs smap) => optimize_add_zero (SFS abs smap) "e1"
 | _ => None
end
).

Compute (
match abstract_eval (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 15))::
                     SimplePriceOpcodeMk (PUSH (natToWord 5 0) WZero)::
                     SimplePriceOpcodeMk ADD::
                     nil) with
 | Some (SFS abs smap) => optimize_add_zero (SFS abs smap) "e2"
 | _ => None
end
).


Lemma optimize_add_zero_same_abs: forall (symb: string)
      (ini_abs opt_abs: abstract_stack) (ini_sfs_map opt_sfs_map: sfs_map), 
optimize_add_zero (SFS ini_abs ini_sfs_map) symb = Some (SFS opt_abs opt_sfs_map) ->
ini_abs = opt_abs.
Proof.
intros symb ini_abs opt_abs ini_sfs_map opt_sfs_map.
unfold optimize_add_zero.
destruct (lookup ini_sfs_map symb) as [sfsvalue|] eqn:eqlookupsymb; try discriminate.
destruct sfsvalue as [ | |op name1 name2] eqn: eqsfsvalue; try discriminate.
destruct op as [ | | |instr] eqn: eqop; try discriminate.
 (* Tries to apply discrimiante for all instructions 'op', that succeeds except 
    for SimplePriceOpcodeMk *)
destruct instr eqn: eqinstr; try discriminate. 
(* Tries to apply discrimiante for all simple instructions 'instr', that succeeds except 
   for ADD *)
destruct (points_to_const name1 ini_sfs_map WZero) eqn: eqhaszeroa.
 - intro Hini_opt. injection Hini_opt. intros Hopt_map Hopt_abs. assumption.
 - destruct (points_to_const name2 ini_sfs_map WZero) eqn: eqhaszerob; try discriminate.
   intro Hini_opt. injection Hini_opt. intros Hopt_map Hopt_abs. assumption.
Qed.   
Check (optimize_add_zero_same_abs).



Lemma optimize_add_zero_symb_same_value_init: 
 forall (d: nat) (concrete_stack: map EVMWord) (ini_sfs opt_sfs: sfs) (symb: string)
 (c: EVMWord),
 lookup concrete_stack symb = Some c
 -> optimize_add_zero ini_sfs symb = Some opt_sfs
 -> evaluate_sfs_from_map d concrete_stack ini_sfs symb =
    evaluate_sfs_from_map d concrete_stack opt_sfs symb.
Proof.
 intros d stack ini_sfs opt_sfs symb c Hlookup HoptSome.
 unfold evaluate_sfs_from_map.
 unfold evaluate_sfs_from_map. destruct d as [ | d'] eqn:eqd; try reflexivity.
 rewrite -> Hlookup. reflexivity.
Qed.


(* Evaluating X+0 = X in EVM words *)
Lemma evalADDzero: forall (e: EVMWord),
 evaluate_concrete_element (SimplePriceOpcodeMk ADD) (WZero :: e :: nil) = Some e.
Proof.
 intros e. unfold evaluate_concrete_element. simpl.
 unfold WZero.
 rewrite -> wplus_wzero_2.
 reflexivity.
 Qed.
 
(* Evaluating 0+X = X in EVM words *) 
Lemma evalADDzero2: forall (e: EVMWord),
 evaluate_concrete_element (SimplePriceOpcodeMk ADD) (e :: WZero :: nil) = Some e.
Proof.
 intros e. unfold evaluate_concrete_element. simpl.
 unfold WZero.
 rewrite -> wplus_wzero_1.
 reflexivity.
 Qed.


(* If you can apply  the X+0 optimization in symbol 'symb', then it must be mapped
   to a some addition name1 + name2 in the SFS *)
Lemma opt_add_zero_then_binopADD: forall (ini_abs opt_abs: abstract_stack) 
   (ini_sfs_map opt_sfs_map: sfs_map) (symb: string),
optimize_add_zero (SFS ini_abs ini_sfs_map) symb = Some (SFS opt_abs opt_sfs_map) ->
exists (name1 name2: string), lookup ini_sfs_map symb = Some (SFSbinop 
  (SimplePriceOpcodeMk ADD) name1 name2).
Proof.
intros ini_abs opt_abs ini_sfs_map opt_sfs_map symb.
unfold optimize_add_zero.
destruct (lookup ini_sfs_map symb) as [symb_expr|] eqn: Hlookupsymb;
  try (intro Hfalse; discriminate).
destruct symb_expr as [value|name|op n1 n2]; try (intro Hfalse; discriminate).
destruct op as [ | | | oper]; try (intro Hfalse; discriminate).
destruct oper; try (intro Hfalse; discriminate).
destruct (points_to_const n1 ini_sfs_map WZero) eqn: Hpointsto_n1.
- intro Hopt. exists n1. exists n2. reflexivity.
- destruct (points_to_const n2 ini_sfs_map WZero) eqn: Hpointsto_name2; 
    try (intro Hfalse; discriminate).
  intro Hopt. exists n1. exists n2. reflexivity.
Qed.  


(* If you can apply the X+0 optimization in symbol 'symb', then the new SFS mapping
   is just the original one but replacing 'symb' *)
Lemma opt_add_zero_only_affects_symbol: forall (ini_abs opt_abs: abstract_stack) 
   (ini_sfs_map opt_sfs_map: sfs_map) (symb: string),
optimize_add_zero (SFS ini_abs ini_sfs_map) symb = Some (SFS opt_abs opt_sfs_map) ->
exists (sfsexpr: sfs_val), opt_sfs_map = update ini_sfs_map symb sfsexpr.
Proof.
intros ini_abs opt_abs ini_sfs_map opt_sfs_map symb.
unfold optimize_add_zero.
destruct (lookup ini_sfs_map symb) as [symb_expr|] eqn: Hlookupsymb;
  try (intro Hfalse; discriminate).
destruct symb_expr as [value|name|op n1 n2]; try (intro Hfalse; discriminate).
destruct op as [ | | | oper]; try (intro Hfalse; discriminate).
destruct oper; try (intro Hfalse; discriminate).
destruct (points_to_const n1 ini_sfs_map WZero) eqn: Hpointsto_n1.
- intro Hopt. injection Hopt. intro Hopt_sfs_map. intro Hopt_abs. 
  rewrite <- Hopt_sfs_map. exists (SFSname n2). reflexivity.
- destruct (points_to_const n2 ini_sfs_map WZero) eqn: Hpointsto_name2; 
    try (intro Hfalse; discriminate).
  intro Hopt. injection Hopt. intro Hopt_sfs_map. intro Hopt_abs. 
  rewrite <- Hopt_sfs_map. exists (SFSname n1). reflexivity.
Qed.


(* If you can apply the X+0 optimization in symbol 'symb', then the SFS mapping
   contained a name1 + name2 where
   a) name1 points to WZero and [symb |-> name2] in the new SFS mapping
   b) name1 does not point to WZero, name2 points to WZero and [symb |-> name1] 
        in the new SFS mapping *)
Lemma opt_add_zero_then_pointsto: forall (ini_abs opt_abs: abstract_stack) 
      (ini_sfs_map opt_sfs_map: sfs_map)
      (symb name1 name2: string),
optimize_add_zero (SFS ini_abs ini_sfs_map) symb = Some (SFS opt_abs opt_sfs_map) ->
lookup ini_sfs_map symb = 
  Some (SFSbinop (SimplePriceOpcodeMk ADD) name1 name2) ->
(points_to_const name1 ini_sfs_map WZero = true /\
 opt_sfs_map = update ini_sfs_map symb (SFSname name2)) 
\/ 
(points_to_const name1 ini_sfs_map WZero = false /\
 points_to_const name2 ini_sfs_map WZero = true /\
 opt_sfs_map = update ini_sfs_map symb (SFSname name1)).
Proof.
intros ini_abs opt_abs ini_sfs_map opt_sfs_map symb name1 name2.
unfold optimize_add_zero.
destruct (lookup ini_sfs_map symb) as [symb_expr|] eqn: Hlookupsymb;
  try (intro Hfalse; discriminate).
destruct symb_expr as [value|name|op n1 n2]; try (intro Hfalse; discriminate).
destruct op as [ | | | oper]; try (intro Hfalse; discriminate).
destruct oper; try (intro Hfalse; discriminate).
destruct (points_to_const n1 ini_sfs_map WZero) eqn: Hpointsto_n1.
- intro Hopt_sfs. injection Hopt_sfs. intro Hopt_sfs_map. intro Hopt_abs.
  intro Hsfsexpr. injection Hsfsexpr. intros Hn2 Hn1.
  left.
  symmetry in Hopt_sfs_map.
  rewrite <- Hn1.
  rewrite <- Hn2.
  split; try assumption.
- destruct (points_to_const n2 ini_sfs_map WZero) eqn: Hpointsto_n2; 
    try (intro Hfalse; discriminate).
  intro Hopt_sfs. injection Hopt_sfs. intro Hopt_sfs_map. intro Hopt_abs.
  intro Hsfsexpr. injection Hsfsexpr. intros Hn2 Hn1.
  right.
  symmetry in Hopt_sfs_map.
  rewrite <- Hn1.
  rewrite <- Hn2.
  split; try assumption.
  split; try assumption.
Qed.


(* In the add-zero optimization of symbol 'symb', all the other symbols points to the 
   SFS expression *)
Lemma optimize_add_zero_same_but_symb: 
 forall (symb symb2: string)
 (ini_abs opt_abs: abstract_stack) (ini_sfs_map opt_sfs_map: sfs_map), 
 symb =? symb2 = false
 -> optimize_add_zero (SFS ini_abs ini_sfs_map) symb = Some (SFS opt_abs opt_sfs_map) 
 -> lookup ini_sfs_map symb2 = lookup opt_sfs_map symb2.
Proof.
 intros symb symb2 ini_abs opt_abs ini_sfs_map opt_sfs_map HSymb Hopt.
 pose proof (opt_add_zero_only_affects_symbol ini_abs opt_abs ini_sfs_map
    opt_sfs_map symb Hopt) as Haffect_ex.
 destruct Haffect_ex as [sfsval Haffect].
 rewrite -> Haffect.
 pose proof (update_lookup_diff sfs_val ini_sfs_map symb symb2 sfsval
   HSymb) as Hlookup.
 rewrite -> Hlookup.
 reflexivity.
Qed.



Lemma pointsto_and_none_then_0_steps: forall (d: nat) (ini_abs: abstract_stack)
  (ini_sfs_map: sfs_map) (stack: map EVMWord) (val: EVMWord) (symbol: string),
disjoint_stack_sfs stack (SFS ini_abs ini_sfs_map) ->
points_to_const symbol ini_sfs_map val = true ->
evaluate_sfs_from_map d stack (SFS ini_abs ini_sfs_map) symbol = None ->
d = 0.
Proof.
intros d ini_abs ini_sfs_map stack val symbol Hdisjoint Hpointsto Heval.
(*remember Hpointsto as Hpointsto_orig eqn: eqpointsto. *)
(*unfold points_to_const in Hpointsto.*)
destruct (lookup ini_sfs_map symbol) as [sfs_expr|] eqn: eqlookup.
- destruct (sfs_expr) as [const|name|name1 name2] eqn: eqsfs_expr.
  * (* SFSconst *)
    unfold evaluate_sfs_from_map in Heval.
    destruct d as [|d']; try reflexivity.
    pose proof (points_to_not_in_stack stack ini_abs ini_sfs_map symbol val
      Hdisjoint Hpointsto) as Hnotinstack.
    rewrite -> Hnotinstack in Heval.
    rewrite -> eqlookup in Heval.
    discriminate.
  * (* SFSname *)
    unfold points_to_const in Hpointsto.
    rewrite -> eqlookup in Hpointsto.
    discriminate.
  * (* SFSbinop oper name1 name2 *) 
    unfold points_to_const in Hpointsto.
    rewrite -> eqlookup in Hpointsto.
    discriminate.
- unfold points_to_const in Hpointsto.
  rewrite -> eqlookup in Hpointsto.
  discriminate.
Qed.



(* 
   MAIN THEOREM FOR THE X+0 OPTIMIZATION 
   Evaluating a symbol in the original SFS returns the same as evaluating
   it in the optimized SFS 
*)
Theorem optimize_add_zero_correct: forall (d: nat) 
        (concrete_stack: map EVMWord) (ini_sfs opt_sfs: sfs) 
        (symbol_opt symbol: string),
disjoint_stack_sfs concrete_stack ini_sfs ->
optimize_add_zero ini_sfs symbol_opt = Some opt_sfs ->
evaluate_sfs_from_map d concrete_stack ini_sfs symbol = 
evaluate_sfs_from_map d concrete_stack opt_sfs symbol.
Proof.
intro d. induction d as [|d' IH].
- intros stack ini_sfs opt_sfs symbol_opt symbol Hdisjoint Hopt.
  reflexivity.
- intros stack ini_sfs opt_sfs symbol_opt symbol Hdisjoint Hopt.
  destruct ini_sfs as [ini_abs ini_sfs_map] eqn: eqini_sfs.
  destruct opt_sfs as [opt_abs opt_sfs_map] eqn: eqopt_sfs.
  unfold evaluate_sfs_from_map.
  destruct (lookup stack symbol) as [valstack|] eqn: eqlookupstack; try trivial.
  (* lookup stack symbol = None *)
  destruct (symbol_opt =? symbol) eqn: eqsymbolopt.
  + (* Evaluating the same symbol that was optimized *)
    pose proof (opt_add_zero_then_binopADD ini_abs opt_abs ini_sfs_map
       opt_sfs_map symbol_opt Hopt) as Hlookup_opt_symb_exists.
    destruct Hlookup_opt_symb_exists as [name1 Hlookup_opt_symb_exists2].
    destruct Hlookup_opt_symb_exists2 as [name2 Hlookup_opt_symb].
    apply -> eqb_eq in eqsymbolopt.
    rewrite -> eqsymbolopt in Hlookup_opt_symb.
    rewrite -> Hlookup_opt_symb.
    fold evaluate_sfs_from_map.
    rewrite -> eqsymbolopt in Hopt.
    pose proof (opt_add_zero_then_pointsto ini_abs opt_abs ini_sfs_map 
       opt_sfs_map symbol name1 name2 Hopt Hlookup_opt_symb) as Hoptimize_cases.
    destruct Hoptimize_cases as [Hoptimize_name1 | Hoptimize_name2].
    * destruct Hoptimize_name1 as [Hpointsto_name1 Hlookup_opt_symbol].
      destruct (evaluate_sfs_from_map d' stack (SFS ini_abs ini_sfs_map) name1)
         as [val1 | ] eqn: eqevalname1.
      -- destruct (evaluate_sfs_from_map d' stack (SFS ini_abs ini_sfs_map) name2)
            as [val2 |] eqn: eqevalname2.
         ++ pose proof (points_to_not_in_stack stack ini_abs ini_sfs_map name1
               WZero Hdisjoint Hpointsto_name1) as Hname1_not_in_stack.
            pose proof (points_to_then_eval d' name1 ini_abs ini_sfs_map WZero 
               val1 stack Hpointsto_name1 Hname1_not_in_stack eqevalname1) as Hval1_zero.
            rewrite -> Hval1_zero.
            rewrite -> evalADDzero.
            rewrite -> Hlookup_opt_symbol.
            pose proof (update_lookup sfs_val ini_sfs_map symbol 
               (SFSname name2)) as Hlookup_symbol_opt.
            rewrite -> Hlookup_symbol_opt.
            rewrite <- Hlookup_opt_symbol.
            rewrite <- eqopt_sfs.
            rewrite <- eqini_sfs in Hdisjoint.
            rewrite <- eqini_sfs in Hopt.
            rewrite <- eqopt_sfs in Hopt.
            rewrite <- eqini_sfs in eqevalname2.
            pose proof (IH stack ini_sfs opt_sfs symbol name2
               Hdisjoint Hopt) as IHspec.
            rewrite <- IHspec.
            rewrite -> eqevalname2.
            reflexivity.
         ++ pose proof (points_to_not_in_stack stack ini_abs ini_sfs_map name1
               WZero Hdisjoint Hpointsto_name1) as Hname1_not_in_stack.
            pose proof (points_to_then_eval d' name1 ini_abs ini_sfs_map WZero 
               val1 stack Hpointsto_name1 Hname1_not_in_stack eqevalname1) as Hval1_zero.
            rewrite -> Hlookup_opt_symbol.
            pose proof (update_lookup sfs_val ini_sfs_map symbol 
               (SFSname name2)) as Hlookup_symbol_opt.
            rewrite -> Hlookup_symbol_opt.
            rewrite <- Hlookup_opt_symbol.
            rewrite <- eqopt_sfs.
            rewrite <- eqini_sfs in Hdisjoint.
            rewrite <- eqini_sfs in Hopt.
            rewrite <- eqopt_sfs in Hopt.
            rewrite <- eqini_sfs in eqevalname2.
            pose proof (IH stack ini_sfs opt_sfs symbol name2
               Hdisjoint Hopt) as IHspec.
            rewrite <- IHspec.
            rewrite -> eqevalname2.
            reflexivity.
      -- rewrite -> Hlookup_opt_symbol.
         pose proof (pointsto_and_none_then_0_steps d' ini_abs ini_sfs_map stack
           WZero name1 Hdisjoint Hpointsto_name1 eqevalname1) as Hdiszero.
         pose proof (update_lookup sfs_val ini_sfs_map symbol 
               (SFSname name2)) as Hlookup_symbol_opt.
         rewrite -> Hlookup_symbol_opt.
         rewrite -> Hdiszero.
         reflexivity.
    * destruct Hoptimize_name2 as [Hpointsto_name1 [Hpointsto_name2 Hlookup_opt_symbol]].
      destruct (evaluate_sfs_from_map d' stack (SFS ini_abs ini_sfs_map) name1)
         as [val1 | ] eqn: eqevalname1.
      -- destruct (evaluate_sfs_from_map d' stack (SFS ini_abs ini_sfs_map) name2)
            as [val2 |] eqn: eqevalname2.
         ++ pose proof (points_to_not_in_stack stack ini_abs ini_sfs_map name2
               WZero Hdisjoint Hpointsto_name2) as Hname2_not_in_stack.
            pose proof (points_to_then_eval d' name2 ini_abs ini_sfs_map WZero 
               val2 stack Hpointsto_name2 Hname2_not_in_stack eqevalname2) as Hval2_zero.
            rewrite -> Hval2_zero.
            rewrite -> evalADDzero2.
            rewrite -> Hlookup_opt_symbol.
            pose proof (update_lookup sfs_val ini_sfs_map symbol 
               (SFSname name1)) as Hlookup_symbol_opt.
            rewrite -> Hlookup_symbol_opt.
            rewrite <- Hlookup_opt_symbol.
            rewrite <- eqopt_sfs.
            rewrite <- eqini_sfs in Hdisjoint.
            rewrite <- eqini_sfs in Hopt.
            rewrite <- eqopt_sfs in Hopt.
            rewrite <- eqini_sfs in eqevalname1.
            pose proof (IH stack ini_sfs opt_sfs symbol name1
               Hdisjoint Hopt) as IHspec.
            rewrite <- IHspec.
            rewrite -> eqevalname1.
            reflexivity.
         ++ rewrite -> Hlookup_opt_symbol.
            pose proof (pointsto_and_none_then_0_steps d' ini_abs ini_sfs_map stack
              WZero name2 Hdisjoint Hpointsto_name2 eqevalname2) as Hdiszero.
            pose proof (update_lookup sfs_val ini_sfs_map symbol 
               (SFSname name1)) as Hlookup_symbol_opt.
            rewrite -> Hlookup_symbol_opt.
            rewrite -> Hdiszero.
            reflexivity.
      -- rewrite -> Hlookup_opt_symbol.
         pose proof (update_lookup sfs_val ini_sfs_map symbol 
               (SFSname name1)) as Hlookup_symbol_opt.
         rewrite -> Hlookup_symbol_opt.
         rewrite <- Hlookup_opt_symbol.
         rewrite <- eqopt_sfs.
         rewrite <- eqini_sfs in Hdisjoint.
         rewrite <- eqini_sfs in Hopt.
         rewrite <- eqopt_sfs in Hopt.
         rewrite <- eqini_sfs in eqevalname1.
         pose proof (IH stack ini_sfs opt_sfs symbol name1
               Hdisjoint Hopt) as IHspec.
         rewrite <- IHspec.
         rewrite -> eqevalname1.
         reflexivity.
  + (* Evaluating a symbol different from the optimized one *)
     destruct (lookup ini_sfs_map symbol) as [symbolexpr|] eqn: eqlookupsymbol.
     * (* lookup ini_sfs_map = Some symbolexpr *)
       pose proof (opt_add_zero_only_affects_symbol ini_abs opt_abs
          ini_sfs_map opt_sfs_map symbol_opt Hopt) as Hupdate_opt.
       destruct Hupdate_opt as [symb_sfs_expr Hopt_sfs_map].
       rewrite -> Hopt_sfs_map.
       rewrite -> update_lookup_diff; try assumption.
       rewrite -> eqlookupsymbol.
       (* Folding/unfolding of SFS to apply the IH *)
       rewrite <- eqini_sfs in Hdisjoint.
       rewrite <- eqini_sfs in Hopt.
       rewrite <- eqopt_sfs in Hopt.
       rewrite <- eqini_sfs.
       rewrite <- Hopt_sfs_map.
       rewrite <- eqopt_sfs.
       destruct symbolexpr as [value|name|op name1 name2] eqn: eqsfsexpr.
       -- reflexivity.
       -- fold evaluate_sfs_from_map.
          pose proof (IH stack ini_sfs opt_sfs symbol_opt name 
            Hdisjoint Hopt) as IHname.
          assumption.
       -- fold evaluate_sfs_from_map.
          pose proof (IH stack ini_sfs opt_sfs symbol_opt name1
            Hdisjoint Hopt) as IHname1.
          rewrite <- IHname1.
          pose proof (IH stack ini_sfs opt_sfs symbol_opt name2
            Hdisjoint Hopt) as IHname2.
          rewrite <- IHname2.
          reflexivity.
     * (* lookup ini_sfs_map = None *)
       pose proof (optimize_add_zero_same_but_symb symbol_opt symbol
         ini_abs opt_abs ini_sfs_map opt_sfs_map eqsymbolopt Hopt) 
         as Hlookup.
       rewrite -> Hlookup in eqlookupsymbol.
       rewrite -> eqlookupsymbol.
       reflexivity.
Qed.



(************
  OPTIMIZATION X*1 -> X
  TODO
 ************)

Definition WOne: EVMWord  := natToWord WLen 1.

(* MUL(X, 1) -> X and MUL(1, X) -> X *)
Definition optimize_mul_one (s: sfs) (var: string) : option sfs :=
match s with
 | SFS abs smap => 
     match lookup smap var with
      | Some (SFSbinop (SimplePriceOpcodeMk MUL) a b) =>
          if points_to_const a smap WOne then Some (SFS abs (update smap var (SFSname b)))
          else if points_to_const b smap WOne then Some (SFS abs (update smap var (SFSname a)))
          else None
      | _ => None
     end
end.

Compute (
match abstract_eval (SimplePriceOpcodeMk (PUSH (natToWord 5 0) WOne)::
                     SimplePriceOpcodeMk MUL::
                     nil) with
 | Some (SFS abs smap) => optimize_mul_one (SFS abs smap) "e1"
 | _ => None
end
).

Compute (
match abstract_eval (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 15))::
                     SimplePriceOpcodeMk (PUSH (natToWord 5 0) WOne)::
                     SimplePriceOpcodeMk MUL::
                     nil) with
 | Some (SFS abs smap) => optimize_mul_one (SFS abs smap) "e2"
 | _ => None
end
).


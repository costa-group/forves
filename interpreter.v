Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import List.
Require Import Program.Wf.
Require Import Coq_EVM.definitions.
Import EVM_Def Concrete Abstract.
Import ListNotations.


Definition firstn_e {A: Type} (n: nat) (l: list A) : option (list A) :=
  if n <=? length l then Some (firstn n l) else None.

Definition skipn_e {A: Type} (n:nat) (l:list A) : option (list A) :=
  if n <=? length l then Some (skipn n l) else None.

Lemma skipn_e_len: forall {X: Type} (n: nat) (l1 l1': list X),
skipn_e n l1 = Some l1' -> length l1' = (length l1) - n.
Proof.
intros. unfold skipn_e in H.
destruct (n <=? length l1) eqn: eq_cond; try discriminate.
injection H as H. rewrite <- H.
rewrite -> skipn_length.
reflexivity.
Qed.

Lemma skipn_e_same_len: forall {X Y: Type} (n: nat) (l1 l1': list X)
  (l2 l2': list Y),
skipn_e n l1 = Some l1' -> 
skipn_e n l2 = Some l2' ->
length l1 = length l2 ->
length l1' = length l2'.
Proof.
intros.
apply skipn_e_len in H0.
apply skipn_e_len in H.
rewrite -> H. rewrite -> H0. rewrite -> H1.
reflexivity.
Qed.

Lemma same_length_firstn_e: forall (T1 T2: Type) (n: nat) (l1 res1: list T1) (l2: list T2),
firstn_e n l1 = Some res1 ->
length l1 = length l2 ->
exists (res2: list T2), firstn_e n l2 = Some res2.
Proof.
intros T1 T2 n l1 res1 l2 Hfirstn HeqLen.
unfold firstn_e in Hfirstn.
destruct (n <=? length l1) eqn: eq_n_len; try discriminate.
injection Hfirstn. intros eq_firstn.
unfold firstn_e. rewrite <- HeqLen. rewrite -> eq_n_len.
exists (firstn n l2).
reflexivity.
Qed.


Lemma same_length_skip_e: forall (T1 T2: Type) (n: nat) (l1 res1: list T1) (l2: list T2),
skipn_e n l1 = Some res1 ->
length l1 = length l2 ->
exists (res2: list T2), skipn_e n l2 = Some res2.
Proof.
intros T1 T2 n l1 res1 l2 Hskipn HeqLen.
unfold skipn_e in Hskipn.
destruct (n <=? length l1) eqn: eq_n_len; try discriminate.
injection Hskipn. intros eq_skipn.
unfold skipn_e. rewrite <- HeqLen. rewrite -> eq_n_len.
exists (skipn n l2).
reflexivity.
Qed.


Lemma firstn_skipn_e: forall (T: Type) (n: nat) (l l1 l2: list T),
firstn_e n l = Some l1 ->
skipn_e n l = Some l2 ->
l = l1 ++ l2.
Proof.
intros T n l l1 l2 Hfirst Hskip.
unfold firstn_e in Hfirst.
unfold skipn_e in Hskip.
destruct (n <=? length l) eqn: eq_length_l; try discriminate.
injection Hfirst. injection Hskip. intros eq_skip_l2 eq_firstn_l1.
pose proof (@firstn_skipn T n l) as eq_first_skip.
rewrite -> eq_firstn_l1 in eq_first_skip.
rewrite -> eq_skip_l2 in eq_first_skip.
symmetry. assumption.
Qed.


Lemma firstn_e_length: forall (T: Type) (n: nat) (l l2: list T),
firstn_e n l = Some l2 ->
length l2 = n.
Proof.
intros T n l l2 Hfirstne.
unfold firstn_e in Hfirstne.
destruct (n <=? length l) eqn: eq_n_len; try discriminate.
injection Hfirstne. intros Hl2. rewrite <- Hl2.
apply leb_complete in eq_n_len.
apply firstn_length_le.
assumption.
Qed.


Module Interpreter.



(****** opmap validity ******)
Definition stack_op_map_comm (ops: opm) : Prop := 
forall (instr: oper_label) (f: list EVMWord -> option EVMWord),
ops instr = Some (Op true 2 f) ->
forall (a b: EVMWord), f [a; b] = f [b; a].

Definition coherent_stack_op_map (ops: opm) : Prop :=
forall (instr: oper_label) (comm: bool) (n: nat) 
  (f: list EVMWord -> option EVMWord) (l: list EVMWord), 
ops instr = Some (Op comm n f) -> 
length l = n ->
exists (v: EVMWord), f l = Some v.

Definition valid_stack_op_map (ops: opm) : Prop :=
  stack_op_map_comm ops /\ coherent_stack_op_map ops.


Lemma evm_stack_opm_comm: stack_op_map_comm opmap.
Proof.
unfold stack_op_map_comm. intros i f H a b.
destruct i eqn: eq_i; try (
  unfold opmap in H; unfold updatei in H; simpl in H;
  injection H; intros; discriminate).
- (* ADD *) 
  unfold opmap in H. unfold updatei in H. simpl in H.
  injection H as eq_func. rewrite <- eq_func. simpl.
  rewrite -> wplus_comm. reflexivity.
- (* MUL *) 
  unfold opmap in H. unfold updatei in H. simpl in H.
  injection H as eq_func. rewrite <- eq_func. simpl.
  rewrite -> wmult_comm. reflexivity.
- (* EQ *)
  unfold opmap in H. unfold updatei in H. simpl in H.
  injection H as eq_f. rewrite <- eq_f.
  simpl. destruct (weqb a b) eqn: weqb_a_b.
  + apply weqb_sound in weqb_a_b as eq_a_b.
    rewrite <- eq_a_b in weqb_a_b. 
    rewrite -> eq_a_b in weqb_a_b at 1.
    rewrite -> weqb_a_b.
    reflexivity.
  + apply weqb_false in weqb_a_b as neq_a_b.
    apply not_eq_sym in neq_a_b.
    apply weqb_ne in neq_a_b.
    rewrite neq_a_b.
    reflexivity.
- (* AND *)
  unfold opmap in H. unfold updatei in H. simpl in H.
  injection H as eq_func. rewrite <- eq_func. simpl.
  rewrite -> wand_comm. reflexivity.
- (* OR *)
  unfold opmap in H. unfold updatei in H. simpl in H.
  injection H as eq_func. rewrite <- eq_func. simpl.
  rewrite -> wor_comm. reflexivity.
- (* XOR *)
  unfold opmap in H. unfold updatei in H. simpl in H.
  injection H as eq_func. rewrite <- eq_func. simpl.
  rewrite -> wxor_comm. reflexivity.
Qed.


Ltac oper_uninterpret0_coherent_tac l H :=
let a := fresh in
let r1 := fresh in
destruct l as [|a r1] eqn: eq_l; 
  [ exists WZero; reflexivity
    |
    simpl in H; discriminate
  ].

Ltac oper_uninterpret1_coherent_tac l H :=
let a := fresh in
let r1 := fresh in
let b := fresh in
let r2 := fresh in
destruct l as [|a r1] eqn: eq_l; 
  [ simpl in H; discriminate
    |
    destruct r1 as [|b r2] eqn: eq_r2;
      [ simpl; 
        exists WZero; reflexivity
      |
        simpl in H; discriminate
      ]
  ].


Ltac oper_1_coherent_tac l H woper :=
let a := fresh in
let r1 := fresh in
let b := fresh in
let r2 := fresh in
destruct l as [|a r1] eqn: eq_l; 
  [ simpl in H; discriminate
    |
    destruct r1 as [|b r2] eqn: eq_r2;
      [ simpl; 
        exists (woper a); reflexivity
      |
        simpl in H; discriminate
      ]
  ].
  
Ltac oper_uninterpret2_coherent_tac l H :=
let a := fresh in
let r1 := fresh in
let b := fresh in
let r2 := fresh in
let c := fresh in
let r3 := fresh in
destruct l as [|a r1] eqn: eq_l; 
  [ simpl in H; discriminate
    |
    destruct r1 as [|b r2] eqn: eq_r2;
      [simpl in H; discriminate
      |
      destruct r2 as [|c r3] eqn: eq_r3;
        [ simpl;
          exists WZero; reflexivity
        |
          simpl in H; discriminate
        ]
      ]
  ].

Ltac oper_2_coherent_tac l H woper :=
let a := fresh in
let r1 := fresh in
let b := fresh in
let r2 := fresh in
let c := fresh in
let r3 := fresh in
destruct l as [|a r1] eqn: eq_l; 
  [ simpl in H; discriminate
    |
    destruct r1 as [|b r2] eqn: eq_r2;
      [simpl in H; discriminate
      |
      destruct r2 as [|c r3] eqn: eq_r3;
        [ simpl;
          exists (woper a b); reflexivity
        |
          simpl in H; discriminate
        ]
      ]
  ].
  
Ltac oper_uninterpret3_coherent_tac l H :=
let a := fresh in let r1 := fresh in
let b := fresh in let r2 := fresh in
let c := fresh in let r3 := fresh in
let d := fresh in let r4 := fresh in
destruct l as [|a r1] eqn: eq_l; 
  [ simpl in H; discriminate
    |
    destruct r1 as [|b r2] eqn: eq_r1;
      [simpl in H; discriminate
      |
      destruct r2 as [|c r3] eqn: eq_r2;
        [ simpl in H; discriminate
          |
          destruct r3 as [| d r4] eqn: eq_r4;
          [ simpl;
            exists WZero; reflexivity
            |
            simpl in H; discriminate
          ]
        ]
      ]
  ].
  
Ltac oper_uninterpret4_coherent_tac l H :=
let a := fresh in let r1 := fresh in
let b := fresh in let r2 := fresh in
let c := fresh in let r3 := fresh in
let d := fresh in let r4 := fresh in
let e := fresh in let r5 := fresh in
destruct l as [|a r1] eqn: eq_l; 
  [ simpl in H; discriminate
    |
    destruct r1 as [|b r2] eqn: eq_r1;
      [simpl in H; discriminate
      |
      destruct r2 as [|c r3] eqn: eq_r2;
        [ simpl in H; discriminate
          |
          destruct r3 as [| d r4] eqn: eq_r4;
          [ simpl in H; discriminate
            |
            destruct r4 as [|e r5] eqn: eq_r5;
            [ simpl;
              exists WZero; reflexivity
              |
              simpl in H; discriminate
            ]
          ]
        ]
      ]
  ].   
  
Ltac rw_coherent H eq_func H0 eq_nb_args :=
unfold opmap in H; unfold updatei in H; simpl in H;
injection H as eq_flag eq_nb_args eq_func;
rewrite <- eq_func; rewrite <- eq_nb_args in H0.


Lemma evm_stack_opm_coherent: coherent_stack_op_map opmap.
Proof.
unfold coherent_stack_op_map. 
intros instr comm n f l H H0.
destruct instr eqn: eq_instr; 
try (
  rw_coherent H eq_func H0 eq_nb_args;
  oper_uninterpret0_coherent_tac l H0);
try (
  rw_coherent H eq_func H0 eq_nb_args;
  oper_uninterpret1_coherent_tac l H0);
try (
  rw_coherent H eq_func H0 eq_nb_args;
  oper_uninterpret2_coherent_tac l H0
);
try (
  rw_coherent H eq_func H0 eq_nb_args;
  oper_uninterpret3_coherent_tac l H0
);
try (
  rw_coherent H eq_func H0 eq_nb_args;
  oper_uninterpret4_coherent_tac l H0
).
- (* ADD *)
  rw_coherent H eq_func H0 eq_nb_args.
  oper_2_coherent_tac l H0 (@wplus WLen).
- (* MUL *)
  rw_coherent H eq_func H0 eq_nb_args.
  oper_2_coherent_tac l H0 (@wmult WLen).
- (* NOT *)
  rw_coherent H eq_func H0 eq_nb_args.
  oper_1_coherent_tac l H0 (@wnot WLen).
- (* EQ*)
  rw_coherent H eq_func H0 eq_nb_args.
  destruct l as [|a r1]; try (simpl in H0; discriminate).
  destruct r1 as [|b r2]; try (simpl in H0; discriminate). 
  destruct r2 as [|c r3]; try (simpl in H0; discriminate).
  simpl.
  exists ((if weqb a b then WOne else WZero)).
  reflexivity.
- (* AND *)
  rw_coherent H eq_func H0 eq_nb_args.
  oper_2_coherent_tac l H0 (@wand WLen).
- (* OR *)
  rw_coherent H eq_func H0 eq_nb_args.
  oper_2_coherent_tac l H0 (@wor WLen).
- (* XOR *)
  rw_coherent H eq_func H0 eq_nb_args.
  oper_2_coherent_tac l H0 (@wxor WLen).  
Qed.

Theorem evm_stack_opm_validity: valid_stack_op_map opmap.
Proof.
unfold valid_stack_op_map. split.
- apply evm_stack_opm_comm.
- apply evm_stack_opm_coherent.
Qed.
(************)





(****** Execution state manipulation ******)
Definition get_stack_es (es: execution_state) : tstack :=
match es with
| ExState stack _ _ => stack
end.

Definition set_stack_es (es: execution_state) (stack: tstack) : execution_state :=
match es with
| ExState _ memory storage => ExState stack memory storage
end.

Definition get_memory_es (es: execution_state) : tmemory :=
match es with
| ExState _ memory _ => memory
end.

Definition set_memory_es (es: execution_state) (memory: tmemory) : execution_state :=
match es with
| ExState stack _ storage => ExState stack memory storage
end.

Definition get_storage_es (es: execution_state) : tstorage :=
match es with
| ExState _ _ storage => storage
end.

Definition set_storage_es (es: execution_state) (storage: tstorage) : execution_state :=
match es with
| ExState stack memory _ => ExState stack memory storage
end.

(************)




(******* stack manipulation operators ********)

(* Polymorphic versions for manipulating the stack *)
Definition push {T : Type} (v : T) (sk : list T) : option (list T) :=
if List.length(sk) <? StackLen then Some (v :: sk) else None.

Definition pop {T : Type} (sk: list T): option (list T) :=
match sk with
 | x::sk' => Some sk'
 | _ => None
end.

Definition dup {T: Type} (k : nat) (sk: list T) : option (list T) :=
if ((k =? 0) || (16 <? k) || (StackLen <=? List.length(sk))) then None
else match nth_error sk (pred k) with
  | None => None
  | Some x => Some (x::sk)
  end.

Definition swap {T: Type} (k : nat) (sk: list T) : option (list T) :=
if ((k =? 0) || (16 <? k)) then None
else match (nth_error sk k, sk) with
     | (Some v, h::t) => Some ([v] ++ ((firstn (k-1) t)) ++ [h] ++ (skipn (k+1) sk))
     | _  => None
     end.

(* version operating on execution states *)
Definition push_c (v : EVMWord) (es : execution_state) : option execution_state :=
let sk := get_stack_es es in
match push v sk with
| None => None
| Some sk' => Some (set_stack_es es sk')
end.

Definition pop_c (es : execution_state): option execution_state :=
let sk := get_stack_es es in
match pop sk with
 | None => None
 | Some sk' => Some (set_stack_es es sk')
end.

Definition dup_c (k : nat) (es : execution_state) : option execution_state  :=
let sk := get_stack_es es in
match dup k sk with
 | None => None
 | Some sk' => Some (set_stack_es es sk')
end.

Definition swap_c (k : nat) (es : execution_state) : option execution_state :=
let sk := get_stack_es es in
match swap k sk with
 | None => None
 | Some sk' => Some (set_stack_es es sk')
end.


Lemma push_succeed: forall (T: Type) (e: T) (l1 l2: list T),
push e l1 = Some l2 -> l2 = e::l1.
Proof.
intros T e l1 l2 Hpush.
unfold push in Hpush.
destruct (length l1 <? StackLen); try discriminate.
symmetry in Hpush. injection Hpush.
trivial.
Qed.




Definition build_es_opt_stack (es: execution_state) (h: option EVMWord) (sk: tstack) : option execution_state :=
match h with
| None => None
| Some v => Some (set_stack_es es (v :: sk))
end.


(* Concrete interpreter *)
Definition concr_intpreter_instr (inst : instr) (es: execution_state)
  (ops : opm) : option execution_state :=
match inst with
  | PUSH size v => push_c v es
  | POP => pop_c es
  | DUP k => dup_c k es
  | SWAP k => swap_c k es
  | Opcode label =>
      let insk := get_stack_es es in
      match (ops label) with
      | Some (Op comm nb_args func) => 
          match firstn_e nb_args insk with
          | Some args => match skipn_e nb_args insk with 
                         | Some insk' => match func args with 
                                         | Some v => Some (set_stack_es es (v :: insk'))
                                         | None => None
                                         end 
                         | None => None
                         end
          | None => None
          end
      | None => None
      end
  end.

Fixpoint concr_interpreter (insts : block) (es : execution_state)
  (ops : opm) : option execution_state :=
  match insts with
  | [] => Some es
  | inst::insts' =>
    match (concr_intpreter_instr inst es ops) with
    | None => None
    | Some insk' => concr_interpreter insts' insk' ops
    end
  end.

End Interpreter.  


Module SFS.
Include Interpreter.

Definition get_height_asfs (a: asfs) : nat        := match a with ASFSc h _ _ _ => h end.
Definition get_maxid_asfs  (a: asfs) : nat        := match a with ASFSc _ i _ _ => i end.
Definition get_stack_asfs  (a: asfs) : asfs_stack := match a with ASFSc _ _ s _ => s end.
Definition get_map_asfs    (a: asfs) : asfs_map   := match a with ASFSc _ _ _ m => m end.

Definition set_height_asfs (a: asfs) (h': nat) : asfs := 
  match a with ASFSc h maxid s m => ASFSc h' maxid  s  m end.
Definition set_maxid_asfs (a: asfs) (maxid': nat) : asfs := 
  match a with ASFSc h maxid s m => ASFSc h  maxid' s  m end.
Definition set_stack_asfs (a: asfs) (s': asfs_stack) : asfs := 
  match a with ASFSc h maxid s m => ASFSc h  maxid  s' m end.
Definition set_map_asfs (a: asfs) (m': asfs_map) : asfs := 
  match a with ASFSc h maxid s m => ASFSc h  maxid  s  m' end.


Definition gen_initial_stack (size: nat): list asfs_stack_val :=
  let ids := seq 0 size in
  List.map InStackVar ids.

Definition empty_asfs (size: nat) : asfs :=
  let s := gen_initial_stack size in
  ASFSc size 0 s nil.
  
  
  
Lemma get_set_stack_idem: forall (a: asfs) (s: asfs_stack),
get_stack_asfs (set_stack_asfs a s) = s.
Proof.
intros. destruct a.
reflexivity.
Qed.


Definition asfs_map_add (m: asfs_map) (id: nat) (a: asfs_map_val) : asfs_map :=
  (id, a)::m.
  

Definition add_val_asfs (ops: opm) (a: asfs) (v: asfs_map_val) : option asfs :=
  let m   : asfs_map    := get_map_asfs a in
  let s   : asfs_stack  := get_stack_asfs a in
  let mid : nat         := get_maxid_asfs a in
  let m' : asfs_map     := asfs_map_add m mid v in 
  match push (FreshVar mid) s with 
  | None => None 
  | Some s' => Some (set_stack_asfs (set_map_asfs (set_maxid_asfs a (mid+1)) m') s')
  end.



Lemma add_val_asfs_incr: forall (ops: opm) (a a': asfs) (v: asfs_map_val),
add_val_asfs ops a v = Some a' ->
length (get_stack_asfs a') = S (length (get_stack_asfs a)).
Proof.
intros. unfold add_val_asfs in H.
destruct (push (FreshVar (get_maxid_asfs a)) (get_stack_asfs a)) 
  as [s'|] eqn: eq_push; try discriminate.
injection H as H. rewrite <- H.
rewrite -> get_set_stack_idem.
apply push_succeed in eq_push.
rewrite -> eq_push. simpl.
reflexivity.
Qed.



Definition symbolic_exec'' (ins: instr) (a: asfs) (ops: opm) : option asfs :=
  let s : asfs_stack := get_stack_asfs a in
  match ins with
  | PUSH size w => match push (Val w) s with None => None | Some s' => Some (set_stack_asfs a s') end
  | POP      => match pop s      with None => None | Some s' => Some (set_stack_asfs a s') end
  | DUP pos  => match dup pos s  with None => None | Some s' => Some (set_stack_asfs a s') end
  | SWAP pos => match swap pos s with None => None | Some s' => Some (set_stack_asfs a s') end
  | Opcode label =>
      match (ops label) with
      | None => None
      | Some (Op comm nargs f) => 
          match firstn_e nargs s, skipn_e nargs s with
          | Some s1, Some s2 => 
              let val : asfs_map_val := ASFSOp label s1 in
              let a'  : asfs         := set_stack_asfs a s2 in
              add_val_asfs ops a' val
          | _, _ => None
          end
      end
  end.

Fixpoint symbolic_exec' (p: block) (a: asfs) (ops: opm) : option asfs :=
  match p with
  | nil => Some a
  | ins::p' =>
      match symbolic_exec'' ins a ops with
      | None => None
      | Some a' => symbolic_exec' p' a' ops
      end
  end.

Definition symbolic_exec (p: block) (height: nat) (ops: opm) : option asfs :=
  let a : asfs := empty_asfs height in 
  symbolic_exec' p a ops.


Fixpoint apply_f_list_asfs_stack_val (f: asfs_stack_val -> option EVMWord) (l: asfs_stack) :
  option (list EVMWord) :=
match l with 
| nil => Some []
| elem::rs => let elem_oval := f elem in
              let rs_oval := apply_f_list_asfs_stack_val f rs in
              match (elem_oval, rs_oval) with 
              | (Some elem_val, Some rs_val) => Some (elem_val::rs_val)
              | _ => None
              end
end.


Fixpoint eval_asfs2_elem (c: tstack) (elem: asfs_stack_val) (m: asfs_map) (ops: opm) 
 {struct m} : option EVMWord :=
match elem with 
| Val v => Some v
| InStackVar idx => nth_error c idx
| FreshVar idx => 
     match m with 
     | nil => None
     | (k,v)::rm => if k =? idx then
                      match v with 
                      | ASFSBasicVal basicv => eval_asfs2_elem c basicv rm ops
                      | ASFSOp op args => 
                           match ops op with
                           | None => None
                           | Some (Op comm_flat nargs func) => 
                               if (List.length args =? nargs) then
                                 (* Lambda-abstraction to create a unary function over asfa_stack_val *)
                                 let f_eval_list := fun (elem': asfs_stack_val) => eval_asfs2_elem c elem' rm ops in
                                 match apply_f_list_asfs_stack_val f_eval_list args with
                                 | None => None
                                 | Some vargs => func vargs
                                 end
                               else None
                           end
                      end
                    else eval_asfs2_elem c elem rm ops
     end
end.

(* Define the evaluation of an asfs_stack in terms of the apply_f_list_asfs_stack_val *)
Definition eval_asfs2 (c: tstack) (s: asfs_stack) (m: asfs_map) (ops: opm) : option (list EVMWord) :=
let f_eval_list := fun (elem': asfs_stack_val) => eval_asfs2_elem c elem' m ops in
apply_f_list_asfs_stack_val f_eval_list s.


(* Trivial but useful for proofs *)
Lemma eval_asfs2_ho: forall (c: tstack) (s: asfs_stack) (m: asfs_map) (ops: opm),
apply_f_list_asfs_stack_val (fun (elem': asfs_stack_val) => eval_asfs2_elem c elem' m ops) s = 
eval_asfs2 c s m ops.
Proof. reflexivity. Qed.



Definition eval_asfs (c: tstack) (s: asfs) (ops: opm) : option (tstack) :=
match s with
| ASFSc height maxid curr_stack amap => 
    if List.length c =? height then
      eval_asfs2 c curr_stack amap ops
    else
      None (* evalution cannot succeed if the given stack has 
              a different size to the expected one *)
end.


Lemma concr_abs_stack_same_length_eval_asfs2: forall (in_stk curr_stk: tstack) 
  (abs: asfs_stack) (m: asfs_map) (ops: opm),
eval_asfs2 in_stk abs m ops = Some curr_stk ->
length abs = length curr_stk.
Proof.
intros in_stk curr_stk. revert in_stk.
induction curr_stk as [| h t IH].
- intros in_stk abs m ops Heval_abs. 
  destruct abs as [| ha ta] eqn: eq_abs; try trivial.
  unfold eval_asfs2 in Heval_abs. unfold apply_f_list_asfs_stack_val in Heval_abs.
  destruct (eval_asfs2_elem in_stk ha m ops) as [ha_val|] eqn: eval_ha;
    try discriminate.
  fold apply_f_list_asfs_stack_val in Heval_abs.
  rewrite -> eval_asfs2_ho in Heval_abs.
  destruct (eval_asfs2 in_stk ta m ops) as [ta_val|] eqn: eq_eval_ta;
    try discriminate.
- intros in_stk abs m ops Heval_abs.
  destruct abs as [| ha ta] eqn: eq_abs.
  + unfold eval_asfs2 in Heval_abs. unfold apply_f_list_asfs_stack_val in Heval_abs.
    discriminate.
  + unfold eval_asfs2 in Heval_abs. unfold apply_f_list_asfs_stack_val in Heval_abs.
    destruct (eval_asfs2_elem in_stk ha m ops) as [ha_val|] eqn: eval_ha;
      try discriminate.
    fold apply_f_list_asfs_stack_val in Heval_abs.
    rewrite -> eval_asfs2_ho in Heval_abs.
    destruct (eval_asfs2 in_stk ta m ops) as [ta_val|] eqn: eq_eval_ta;
      try discriminate.
    injection Heval_abs. intros eq_t eq_h. rewrite -> eq_t in eq_eval_ta.
    pose proof (IH in_stk ta m ops eq_eval_ta) as IH_ta_t.
    simpl. rewrite -> IH_ta_t.
    reflexivity.
Qed.


Lemma concr_abs_stack_same_length: forall (in_stk curr_stk: tstack) (curr_asfs: asfs)
        (ops: opm) (curr_es: execution_state),
eval_asfs in_stk curr_asfs ops = Some curr_stk ->
get_stack_es curr_es = curr_stk ->
length (get_stack_es curr_es) = length (get_stack_asfs curr_asfs).
Proof.
intros in_stk curr_stk curr_asfs ops curr_es Heval_asfs Hget_stack.
destruct curr_es as [stk mem store] eqn: eq_curr_es.
rewrite -> Hget_stack.
destruct curr_asfs as [height maxid abs map] eqn: eq_curr_asfs.
simpl.
unfold eval_asfs in Heval_asfs.
destruct (length in_stk =? height); try discriminate.
symmetry.
apply concr_abs_stack_same_length_eval_asfs2 with (m:= map) 
  (in_stk:=in_stk) (ops:= ops).
assumption.
Qed.

Lemma set_get_stack_es: forall (es: execution_state) (stk: tstack),
get_stack_es (set_stack_es es stk) = stk.
Proof.
intros es stk. unfold set_stack_es. destruct es.
reflexivity.
Qed.


Lemma eval_eq_stack_len: forall (in_stk out_stk: tstack) (height hc maxid: nat) (abs: asfs_stack)
  (map: asfs_map) (ops: opm),
length in_stk = height -> 
eval_asfs in_stk (ASFSc hc maxid abs map) ops = Some out_stk ->
height = hc.
Proof.
intros in_stk out_stk height hc maxid abs map ops Hlen Heval.
unfold eval_asfs in Heval.
destruct (length in_stk =? hc) eqn: eq_len_hc; try discriminate.
symmetry in eq_len_hc.
apply beq_nat_eq in eq_len_hc.
rewrite -> Hlen in eq_len_hc.
assumption.
Qed.


Lemma eval_const_val: forall (stk: tstack) (w: EVMWord) (map: asfs_map) (ops: opm),
eval_asfs2_elem stk (Val w) map ops = Some w.
Proof.
intros stk w map ops. unfold eval_asfs2_elem.
destruct map eqn: eq_m; try reflexivity.
(* unneeded unfolding, required by Coq to simplify because the map is the
   decreasing argument *)
Qed.


Lemma height_stack_eval: forall (in_stk curr_stk: tstack) (h mx: nat) 
      (abs: asfs_stack) (map: asfs_map) (ops: opm),
eval_asfs in_stk (ASFSc h mx abs map) ops = Some curr_stk ->
length abs = length curr_stk.
Proof.
intros in_stk curr_stk h mx abs map ops Heval.
unfold eval_asfs in Heval.
destruct (length in_stk =? h); try discriminate.
apply concr_abs_stack_same_length_eval_asfs2 with (in_stk:= in_stk)
  (m:=map) (ops:=ops).
assumption.
Qed.


Lemma eval_asfs2_compositional: forall (in_stk curr_stk args insk': tstack) 
  (stkc s1 s2: asfs_stack) (mapc: asfs_map) (ops: opm),
eval_asfs2 in_stk stkc mapc ops = Some curr_stk ->
stkc = s1 ++ s2 ->
curr_stk = args ++ insk' ->
length s1 = length args ->
eval_asfs2 in_stk s1 mapc ops = Some args /\ eval_asfs2 in_stk s2 mapc ops = Some insk'.
Proof.
intros in_stk curr_stk args insk' stkc s1.
revert in_stk curr_stk args insk' stkc.
induction s1 as [| h t IH ].
- intros in_stk curr_stk args insk' stkc s2 mapc ops Heval_stkc Hstkc_concat
    Hcurr_stk_concat Hlen. 
  split.
  + simpl in Hlen. symmetry in Hlen. rewrite -> length_zero_iff_nil in Hlen.
    rewrite -> Hlen. reflexivity.
  + simpl in Hstkc_concat. rewrite <- Hstkc_concat. 
    simpl in Hlen. symmetry in Hlen. rewrite -> length_zero_iff_nil in Hlen.
    rewrite -> Hlen in Hcurr_stk_concat. simpl in Hcurr_stk_concat.
    rewrite -> Hcurr_stk_concat in Heval_stkc.
    assumption.
- intros in_stk curr_stk args insk' stkc s2 mapc ops Heval_stkc Hstkc_concat
    Hcurr_stk_concat Hlen. 
  rewrite <- app_comm_cons in Hstkc_concat. rewrite -> Hstkc_concat in Heval_stkc.
  unfold eval_asfs2 in Heval_stkc. unfold apply_f_list_asfs_stack_val in Heval_stkc.
  destruct (eval_asfs2_elem in_stk h mapc ops) as [h_val|] eqn: eq_eval_h;
    try discriminate.
  fold apply_f_list_asfs_stack_val in Heval_stkc. rewrite -> eval_asfs2_ho in Heval_stkc.
  destruct (eval_asfs2 in_stk (t ++ s2) mapc ops) as [ts2_val|] eqn: eq_eval_t_s2;
    try discriminate.
  destruct args as [| argsh argst] eqn: eq_args; try ( simpl in Hlen; discriminate).
  simpl in Hlen. injection Hlen. intros eq_len_t.
  remember (t ++ s2) as stkc' eqn: eq_stkc'.
  injection Heval_stkc. intros eq_curr_stk. symmetry in eq_curr_stk.
  rewrite -> eq_curr_stk in Hcurr_stk_concat.
  rewrite <- app_comm_cons in Hcurr_stk_concat.
  injection Hcurr_stk_concat. intros eq_ts2_val eq_hval.
  pose proof (IH in_stk ts2_val argst insk' stkc' s2 mapc ops
    eq_eval_t_s2 eq_stkc' eq_ts2_val eq_len_t) as [eq_eval_t eq_eval_s2].
  split; try assumption.
  unfold eval_asfs2. unfold apply_f_list_asfs_stack_val.
  rewrite -> eq_eval_h. fold apply_f_list_asfs_stack_val.
  rewrite -> eval_asfs2_ho. rewrite -> eq_eval_t.
  rewrite -> eq_hval. reflexivity.
Qed.  

Lemma eval_asfs2_compositional_r: forall (in_stk curr_s1 curr_s2: tstack) 
  (s1 s2: asfs_stack) (mapc: asfs_map) (ops: opm),
eval_asfs2 in_stk s1 mapc ops = Some curr_s1 ->
eval_asfs2 in_stk s2 mapc ops = Some curr_s2 ->
eval_asfs2 in_stk (s1++s2) mapc ops = Some (curr_s1 ++ curr_s2).
Proof.
intros in_stk curr_s1 curr_s2 s1.
revert in_stk curr_s1 curr_s2.
induction s1 as [ | h t].
- intros in_stk curr_s1 curr_s2 s2 mapc ops Hevals1 Hevals2. simpl.
  pose proof (concr_abs_stack_same_length_eval_asfs2 in_stk curr_s1 [] mapc
    ops Hevals1) as eq_curr_s1_len.
  simpl in eq_curr_s1_len. symmetry in eq_curr_s1_len.
  apply length_zero_iff_nil in eq_curr_s1_len.
  rewrite -> eq_curr_s1_len. simpl. assumption.
- intros in_stk curr_s1 curr_s2 s2 mapc ops Hevals1 Hevals2. simpl.
  destruct curr_s1 as [ | hc tc] eqn: eq_curr_s1.
  + pose proof (concr_abs_stack_same_length_eval_asfs2 in_stk [] (h :: t)
      mapc ops Hevals1) as eqn_curr_s1_len. 
    simpl in eqn_curr_s1_len. discriminate.
  + unfold eval_asfs2 in Hevals1. unfold apply_f_list_asfs_stack_val in Hevals1.
    destruct (eval_asfs2_elem in_stk h mapc ops) as [elemv |] eqn: eq_evalh;
      try discriminate.
    fold apply_f_list_asfs_stack_val in Hevals1.
    rewrite -> eval_asfs2_ho in Hevals1.  
    destruct (eval_asfs2 in_stk t mapc ops) as [tval|] eqn: eq_evalt;
      try discriminate.
    injection Hevals1. intros eq_tc eq_hc. symmetry in eq_tc. symmetry in eq_hc.
    rewrite -> eq_hc. rewrite -> eq_tc.
    rewrite <- app_comm_cons. 
    unfold eval_asfs2. unfold apply_f_list_asfs_stack_val.
    rewrite -> eq_evalh. fold apply_f_list_asfs_stack_val.
    rewrite -> eval_asfs2_ho.
    pose proof (IHt in_stk tval curr_s2 s2 mapc ops eq_evalt Hevals2)
      as IHts2.
    rewrite -> IHts2.
    reflexivity. 
Qed.


Lemma eval_asfs2_compositional4: forall (in_stk curr_stk v1 v2 v3 v4: tstack) 
  (stkc s1 s2 s3 s4: asfs_stack) (mapc: asfs_map) (ops: opm),
eval_asfs2 in_stk stkc mapc ops = Some curr_stk ->
stkc = s1 ++ s2 ++ s3 ++ s4 ->
curr_stk = v1 ++ v2 ++ v3 ++ v4 ->
length s1 = length v1 ->
length s2 = length v2 ->
length s3 = length v3 ->
eval_asfs2 in_stk s1 mapc ops = Some v1
/\ eval_asfs2 in_stk s2 mapc ops = Some v2
/\ eval_asfs2 in_stk s3 mapc ops = Some v3
/\ eval_asfs2 in_stk s4 mapc ops = Some v4.
Proof.
intros in_stk curr_stk v1 v2 v3 v4 stck s1 s2 s3 s4 mapc ops Heval_stkc
  Hstkc_concat Hcurr_stk_concat Hlen1 Hlen2 Hlen3.
remember (s1 ++ s2) as s12 eqn: eq_s12.
remember (s3 ++ s4) as s34 eqn: eq_s34.
remember (v1 ++ v2) as v12 eqn: eq_v12.
remember (v3 ++ v4) as v34 eqn: eq_v34.
rewrite -> app_assoc in Hcurr_stk_concat.
rewrite -> app_assoc in Hstkc_concat.
rewrite <- eq_s12 in Hstkc_concat.
rewrite <- eq_v12 in Hcurr_stk_concat.
pose proof (app_length s1 s2) as eq_len_s1s2.
pose proof (app_length v1 v2) as eq_len_v1v2.
rewrite -> Hlen1 in eq_len_s1s2. rewrite -> Hlen2 in eq_len_s1s2.
rewrite <- eq_len_v1v2 in eq_len_s1s2.
rewrite <- eq_s12 in eq_len_s1s2. rewrite <- eq_v12 in eq_len_s1s2.
pose proof (eval_asfs2_compositional in_stk curr_stk v12 v34 stck s12 s34
  mapc ops Heval_stkc Hstkc_concat Hcurr_stk_concat eq_len_s1s2) 
  as [Heval_s12 Heval_s34].
pose proof (eval_asfs2_compositional in_stk v12 v1 v2 s12 s1 s2 mapc ops
  Heval_s12 eq_s12 eq_v12 Hlen1) as [Heval_s1 Heval_s2].
pose proof (eval_asfs2_compositional in_stk v34 v3 v4 s34 s3 s4 mapc ops
  Heval_s34 eq_s34 eq_v34 Hlen3) as [Heval_s3 Heval_s4].
split; try assumption.
split; try assumption.
split; try assumption.
Qed.


Lemma gt_neq: forall (n m : nat), n <=? m = false -> n =? m = false.
Proof.
  induction n as [|n' IHn'].
  - intros. destruct m.
    * discriminate H.
    * reflexivity.
  - intros. destruct m.
    * reflexivity.
    * simpl. simpl in H. apply IHn'. apply H.
Qed.



Lemma eval_asfs2_elem_extended_map_aux: forall
    (c: tstack) (elem: nat) 
    (m: asfs_map) (ops: opm) (w : EVMWord) (n: nat),
eval_asfs2_elem c (FreshVar elem) m ops = Some w ->
fresh_var_gt_map n m ->
n =? elem = false.
Proof.
  intros.
  induction m as [|x xs IH].
  - discriminate H.
  - simpl in H. simpl in H0.
    destruct x.
    + destruct (n0 =? elem) eqn:H1.
      ++ destruct (n <=? n0) eqn:H2.
         * rewrite -> Nat.eqb_eq in H1. rewrite -> H1 in H0. 
           destruct H0 as [n_gt_elem _]. 
           rewrite -> Nat.leb_le in H2. rewrite -> H1 in H2.
           pose proof (gt_not_le n elem n_gt_elem).
           contradiction.
         * apply gt_neq. apply beq_nat_true in H1. rewrite H1 in H2. apply H2.
           ++ destruct (n <=? n0) eqn:H2.
         * destruct H0 as [n_gt_n0 _]. 
           rewrite -> Nat.leb_le in H2. 
           pose proof (gt_not_le n n0 n_gt_n0).
           contradiction.
         * apply IH.
           ** apply H.
           ** apply H0.
Qed.


Lemma eval_asfs2_elem_extended_map: forall
    (c: tstack) (elem: asfs_stack_val) (m: asfs_map) (ops: opm) (w : EVMWord) (n: nat) (val: asfs_map_val),
eval_asfs2_elem c elem m ops = Some w ->
fresh_var_gt_map n m ->
eval_asfs2_elem c elem ((n, val)::m) ops = Some w.
Proof.
  intros.
  destruct m.
  - destruct elem.
    + unfold eval_asfs2_elem. unfold eval_asfs2_elem in H. rewrite -> H. reflexivity.
    + unfold eval_asfs2_elem. unfold eval_asfs2_elem in H. rewrite -> H. reflexivity.
    + unfold eval_asfs2_elem in H. discriminate H.
  - destruct elem.
    + unfold eval_asfs2_elem. unfold eval_asfs2_elem in H. rewrite -> H. reflexivity.
    + unfold eval_asfs2_elem. unfold eval_asfs2_elem in H. rewrite -> H. reflexivity.
    + assert (HHH: n =? var = false).
      ** apply eval_asfs2_elem_extended_map_aux with (c:=c)(elem:=var)(m:=(p::m))(w:=w)(ops:=ops).
         apply H. apply H0.
      ** simpl. destruct (n =? var).
         *** discriminate HHH.
         *** simpl in H. apply H.
Qed.




Lemma eval_asfs2_extended_map: forall (in_stk curr_stk: tstack) (s: asfs_stack) (map: asfs_map)
  (ops: opm) (n: nat) (val: asfs_map_val),
eval_asfs2 in_stk s map ops = Some curr_stk ->
fresh_var_gt_map n map ->
eval_asfs2 in_stk s ((n, val)::map) ops = Some curr_stk.
Proof.
  intros in_stk curr_stk s map ops n val.
  generalize dependent in_stk.
  generalize dependent curr_stk.
  generalize dependent map.
  generalize dependent val.
  generalize dependent ops.
  
  induction s as [|x s' IHs'].
  - intros. apply H.
  - intros.
    unfold eval_asfs2. unfold apply_f_list_asfs_stack_val.
     unfold eval_asfs2 in H. unfold apply_f_list_asfs_stack_val in H.
     rewrite -> eval_asfs2_ho. rewrite -> eval_asfs2_ho in H.
      destruct (eval_asfs2_elem in_stk x map0 ops) eqn:HH.
     + apply eval_asfs2_elem_extended_map with (n:=n)(val:=val) in HH.
       rewrite -> HH.
       destruct (eval_asfs2 in_stk s' map0 ops) eqn:HHH.
       * apply IHs' with (val:=val) in HHH.
         rewrite -> HHH.
         apply H.
         apply H0.
       * discriminate H.
       * apply H0.
     + discriminate H.
Qed.


(* Main lemma that relates curr_asfs to out_asfs in the case of executing an operator. 
   It relates their asfs_stacks and the results of their evaluation *)
Lemma opcode_exec_asfs_update: forall (ops: opm) (OpCode: oper_label) (comm_flag: bool)
  (nb_args hec maxc heo maxo: nat) (func: list EVMWord -> option EVMWord) (curr_es: execution_state)
  (args insk' in_stk curr_stk: list EVMWord) (v: EVMWord) (curr_asfs out_asfs: asfs) (stkc stko s1 s2: asfs_stack)
  (mapc mapo: asfs_map),

valid_asfs curr_asfs ->
get_stack_es curr_es = curr_stk ->
ops OpCode = Some (Op comm_flag nb_args func) ->
firstn_e nb_args (get_stack_es curr_es) = Some args ->
skipn_e nb_args (get_stack_es curr_es) = Some insk' ->
func args = Some v ->
curr_asfs = ASFSc hec maxc stkc mapc ->
eval_asfs2 in_stk stkc mapc ops = Some curr_stk ->
firstn_e nb_args (get_stack_asfs curr_asfs) = Some s1 ->
skipn_e nb_args (get_stack_asfs curr_asfs) = Some s2 ->
add_val_asfs ops (set_stack_asfs curr_asfs s2) (ASFSOp OpCode s1) = Some out_asfs ->
out_asfs = ASFSc heo maxo stko mapo ->
 stkc = s1 ++ s2 /\
 hec = heo /\
 exists (e: asfs_stack_val), 
   stko = e :: s2 /\
   eval_asfs2_elem in_stk e mapo ops = Some v /\
   eval_asfs2 in_stk s2 mapo ops = Some insk'.
Proof.
intros ops OpCode comm_flag nb_args hec maxc heo maxo func curr_es args insk' in_stk curr_stk v
  curr_asfs out_asfs stkc stko s1 s2 mapc mapo Hvalid_asfs Hcurrstk Hops Hfirstn_curr_es 
  Hskipn_curr_es Hfunc Hcurr_asfs Heval_curr Hfirstn_curr_asfs Hskipn_curr_asfs Haddval Hout_asfs.
  assert (Hfirstn_curr_asfs' := Hfirstn_curr_asfs).
  unfold firstn_e in Hfirstn_curr_asfs.
  destruct (nb_args <=? length (get_stack_asfs curr_asfs)) eqn: eq_nbargs_curr_asfs; 
    try discriminate.
  unfold skipn_e in Hskipn_curr_asfs. rewrite -> eq_nbargs_curr_asfs in Hskipn_curr_asfs.
  injection Hfirstn_curr_asfs. injection Hskipn_curr_asfs.
  intros Hskipn_s2 Hfirstn_s1.
  pose proof (@firstn_skipn asfs_stack_val nb_args (get_stack_asfs curr_asfs)) as eq_first_skip.
  rewrite -> Hfirstn_s1 in eq_first_skip. rewrite -> Hskipn_s2 in eq_first_skip.
  rewrite -> eq_first_skip. rewrite -> Hcurr_asfs. 
  rewrite -> Hcurr_asfs in eq_first_skip. simpl in eq_first_skip.
- split.
  + reflexivity.
  + split.
    * unfold add_val_asfs in Haddval.
      destruct (push
              (FreshVar
                 (get_maxid_asfs (set_stack_asfs curr_asfs s2)))
              (get_stack_asfs (set_stack_asfs curr_asfs s2))) eqn: eq_push_asfs_stack;
      try discriminate.
    injection Haddval. intros eq_out_asfs. unfold asfs_map_add in eq_out_asfs.
    rewrite -> Hcurr_asfs in Haddval. simpl in Haddval.
    injection Haddval. intros eq_out_asfs2. rewrite -> Hout_asfs in eq_out_asfs2.
    injection eq_out_asfs2. intros eq_mapo eq_s2 eq_maxo eq_hec_heo.
    assumption.
    * unfold add_val_asfs in Haddval.
      destruct (push
              (FreshVar
                 (get_maxid_asfs (set_stack_asfs curr_asfs s2)))
              (get_stack_asfs (set_stack_asfs curr_asfs s2))) eqn: eq_push_asfs_stack;
        try discriminate.
      injection Haddval. intros eq_out_asfs. unfold asfs_map_add in eq_out_asfs.
      rewrite -> Hcurr_asfs in Haddval. simpl in Haddval.
      unfold asfs_map_add in Haddval.
      pose proof (push_succeed asfs_stack_val 
         (FreshVar (get_maxid_asfs (set_stack_asfs curr_asfs s2)))
         (get_stack_asfs (set_stack_asfs curr_asfs s2)) l eq_push_asfs_stack) as eq_stack_push.
      exists (FreshVar (get_maxid_asfs (set_stack_asfs curr_asfs s2))).
      rewrite -> Hcurr_asfs in eq_out_asfs. simpl in eq_out_asfs.
      rewrite -> Hcurr_asfs.
      split.
      -- rewrite -> Hout_asfs in eq_out_asfs. injection eq_out_asfs.
      intros Hmapo Hstko Hmaxo Hheo. 
      rewrite <- Hstko. rewrite -> eq_stack_push. simpl.
      rewrite -> Hcurr_asfs. simpl. reflexivity.
      -- pose proof (firstn_skipn_e EVMWord nb_args (get_stack_es curr_es) args insk'
           Hfirstn_curr_es Hskipn_curr_es) as eq_curr_stk.
         rewrite -> Hcurrstk in eq_curr_stk.
         symmetry in eq_first_skip.
         pose proof (firstn_e_length EVMWord nb_args (get_stack_es curr_es) args
           Hfirstn_curr_es) as eq_length_args.
         pose proof (firstn_e_length asfs_stack_val nb_args (get_stack_asfs curr_asfs) s1
           Hfirstn_curr_asfs') as eq_length_s1.
         rewrite <- eq_length_args in eq_length_s1.
         pose proof (eval_asfs2_compositional in_stk curr_stk args insk' stkc s1 s2
           mapc ops Heval_curr eq_first_skip eq_curr_stk eq_length_s1) 
           as [Heval_asfs2_s1 Heval_asfs2_s2].
         rewrite -> Hout_asfs in eq_out_asfs.
         symmetry in eq_out_asfs.
         injection eq_out_asfs. intros Hmapo Hstko Hmaxo Hheo.
         unfold valid_asfs in Hvalid_asfs. rewrite -> Hcurr_asfs in Hvalid_asfs.
         split. 
         ++ simpl. rewrite -> Hmapo. simpl. rewrite -> Nat.eqb_refl.
            rewrite -> Hops. rewrite -> eq_length_args in eq_length_s1.
            rewrite -> eq_length_s1. rewrite -> Nat.eqb_refl.
            unfold eval_asfs2 in Heval_asfs2_s1.
            rewrite -> Heval_asfs2_s1.
            assumption.
         ++ rewrite -> Hmapo.
            destruct Hvalid_asfs as [fresh_var_gt _].
            pose proof (eval_asfs2_extended_map in_stk insk' s2 mapc ops maxc (ASFSOp OpCode s1)
              Heval_asfs2_s2 fresh_var_gt) as eq_eval_asfs2_s2_mapo.
            assumption.
Qed.


Lemma eval_asfs2_position': forall (in_stk curr_stk: tstack) (pos: nat)
  (sc: asfs_stack) (mc: asfs_map) (ops: opm) (a: asfs_stack_val) (x: EVMWord),
eval_asfs2 in_stk sc mc ops = Some curr_stk ->
nth_error sc pos = Some a ->
nth_error curr_stk pos = Some x -> 
eval_asfs2_elem in_stk a mc ops = Some x.
Proof.
intros in_stk curr_stk pos.
revert in_stk curr_stk.
induction pos as [| n'].
- intros in_stk curr_stk sc mc ops a x Heval_asfs Hnth_sc Hnth_curr_stk.
  unfold nth_error in Hnth_sc.
  destruct sc as [| sc_val sc_t] eqn: eq_sc; try discriminate.
  unfold nth_error in Hnth_curr_stk.
  destruct curr_stk as [| curr_stk_val curr_stk_t] eqn: eq_curr_stk; try discriminate.
  unfold eval_asfs in Heval_asfs.
  unfold eval_asfs2 in Heval_asfs. unfold apply_f_list_asfs_stack_val in Heval_asfs.
  destruct (eval_asfs2_elem in_stk sc_val mc ops) as [sc_val_v|] eqn: eq_sc_val;
    try discriminate.
  fold apply_f_list_asfs_stack_val in Heval_asfs.
  rewrite -> eval_asfs2_ho in Heval_asfs.
  destruct (eval_asfs2 in_stk sc_t mc ops) eqn: eq_sc_t; try discriminate.
  injection Hnth_sc. intros eq_a_sc_val.
  rewrite -> eq_a_sc_val in eq_sc_val.
  injection Hnth_curr_stk. intros eq_x.
  rewrite -> eq_x in Heval_asfs.
  injection Heval_asfs. intros eq_l eq_sc_val_v.
  rewrite -> eq_sc_val_v in eq_sc_val.
  assumption.
- intros in_stk curr_stk sc mc ops a x Heval_asfs Hnth_sc Hnth_curr_stk.
  unfold nth_error in Hnth_sc. 
  destruct sc as [| hsc tsc] eqn: eq_sc; try discriminate.
  fold (nth_error tsc n') in Hnth_sc.
  unfold nth_error in Hnth_curr_stk.
  destruct curr_stk as [| hcurr_stk tcurr_stk] eqn: eq_curr_stk; try discriminate.
  fold (nth_error tcurr_stk n') in Hnth_curr_stk.
  unfold eval_asfs2 in Heval_asfs. unfold apply_f_list_asfs_stack_val in Heval_asfs.
  destruct (eval_asfs2_elem in_stk hsc mc ops) as [hsc_val|] eqn: eq_hsc_eval;
    try discriminate.
  fold apply_f_list_asfs_stack_val in Heval_asfs. rewrite -> eval_asfs2_ho in Heval_asfs.
  destruct (eval_asfs2 in_stk tsc mc ops) as [tsc_val|] eqn: eq_tsc_eval;
    try discriminate.
  injection Heval_asfs. intros eq_tsc_val eq_hcurr_stk.
  rewrite <- eq_tsc_val in Hnth_curr_stk.
  pose proof (IHn' in_stk tsc_val tsc mc ops a x eq_tsc_eval Hnth_sc 
    Hnth_curr_stk).
  assumption.
Qed.

Lemma eval_asfs2_position: forall (in_stk curr_stk: tstack) (hc maxc pos: nat)
  (sc: asfs_stack) (mc: asfs_map) (ops: opm) (a: asfs_stack_val) (x: EVMWord),
eval_asfs in_stk (ASFSc hc maxc sc mc) ops = Some curr_stk ->
nth_error sc pos = Some a ->
nth_error curr_stk pos = Some x -> 
eval_asfs2_elem in_stk a mc ops = Some x.
Proof.
intros in_stk curr_stk hc maxc pos sc mc ops a x Heval_asfs Hnth_sc Hnth_curr_stk.
unfold eval_asfs in Heval_asfs.
destruct (length in_stk =? hc) eqn: eq_len_in_stk; try discriminate.
apply eval_asfs2_position' with (curr_stk:=curr_stk)(pos:=pos)(sc:=sc);
  try assumption.
Qed.

Lemma nat_sub_0: forall (n:nat),
n - 0 = n.
Proof. 
intros n. unfold sub.
destruct n as [|n'] eqn: eq_n; try reflexivity.
Qed.

Lemma list_concat: forall (T: Type) (l1 l2 l1' l2': list T),
l1 ++ l2 = l1' ++ l2' ->
length l1 = length l1' ->
l1 = l1' /\ l2 = l2'.
Proof.
intros T l1. induction l1 as [| h t IH].
- intros l2 l1' l2' Hconcat_eq Hlen_l1.
  symmetry in Hlen_l1.
  rewrite -> length_zero_iff_nil in Hlen_l1.
  rewrite -> Hlen_l1 in Hconcat_eq. simpl in Hconcat_eq.
  symmetry in Hlen_l1.
  split; try assumption.
- intros l2 l1' l2' Hconcat_eq Hlen_l1.
  destruct l1' as [| h1 t1] eqn: eq_l1'.
  + simpl in Hlen_l1. discriminate.
  + simpl in Hlen_l1. injection Hlen_l1. intros eq_len_t_t1.
    rewrite <- app_comm_cons in Hconcat_eq.
    rewrite <- app_comm_cons in Hconcat_eq.
    injection Hconcat_eq. intros eq_t_l2 eq_h.
    pose proof (IH l2 t1 l2' eq_t_l2 eq_len_t_t1) as [eq_t_t1 eq_l2_l2'].
    rewrite -> eq_h. rewrite -> eq_t_t1. rewrite -> eq_l2_l2'.
    split; try reflexivity.
Qed.

Lemma some_is_not_none: forall (T: Type) (e: option T) (v: T),
e = Some v -> e <> None.
Proof.
intros T e v Hesome.
rewrite -> Hesome. discriminate.
Qed.

Lemma length_cons: forall (T: Type) (l: list T) (e: T) (n: nat),
length l = n -> length (e::l) = S n.
Proof.
intros T l e n HLen. simpl. rewrite -> HLen. reflexivity.
Qed.

Lemma skipn_a_tail: forall (T: Type) (k: nat) (t l2: list T) (a: T),
skipn k t = a :: l2 -> l2 = skipn (k+1) t.
Proof.
intros T k. induction k as [| k'].
- intros t l2 a Hskipn.
  simpl in Hskipn. simpl. rewrite -> Hskipn. reflexivity.
- intros t l2 a Hskip. simpl in Hskip.
  destruct t as [|h tail] eqn: eq_t; try discriminate.
  pose proof (IHk' tail l2 a Hskip) as eq_l2_IH.
  rewrite -> eq_l2_IH.
  simpl. reflexivity.
Qed.

Lemma list_composition_for_swap: forall {T:Type} (k: nat) (h a: T) (t: list T),
k =? 0 = false -> 
nth_error (h::t) k = Some a ->
h::t = [h] ++ (firstn (k-1) t) ++ [a] ++ (skipn (k+1) (h::t)).
Proof.
intros T k h a t Hk_neq_0 Hnth_error_a.
simpl.
pose proof (@nth_error_split T (h::t) k a Hnth_error_a) as eq_split.
pose proof (@firstn_skipn T k (h::t)) as eq_first_skip.
unfold firstn in eq_first_skip.
destruct k as [|k'] eqn: eq_k.
- simpl in Hk_neq_0. discriminate.
- fold (firstn k' t) in eq_first_skip. simpl.
  destruct eq_split as [l1 [l2 [eq_split2 eq_len_l1]]].
  rewrite <- eq_first_skip. 
  rewrite -> nat_sub_0.
  rewrite -> app_comm_cons.
  rewrite -> eq_split2 in eq_first_skip at 2.
  assert (Hnth_error_a' := Hnth_error_a).
  simpl in Hnth_error_a'.
  apply some_is_not_none in Hnth_error_a'.
  apply nth_error_Some in Hnth_error_a'.
  apply Nat.lt_le_incl in Hnth_error_a'.
  pose proof (@firstn_length_le T t k' Hnth_error_a') as eq_len_firstn.
  pose proof (length_cons T (firstn k' t) h k' eq_len_firstn)
    as eq_length_h_firstn.
  rewrite <- eq_len_l1 in eq_length_h_firstn.
  pose proof (list_concat T (h :: firstn k' t) (skipn (S k') (h :: t))
    l1 (a::l2) eq_first_skip eq_length_h_firstn) as [eq_l1 eq_a_l2].
  rewrite -> eq_a_l2. 
  simpl in eq_a_l2.
  pose proof (skipn_a_tail T k' t l2 a eq_a_l2) as eq_l2.
  rewrite -> eq_l2.
  reflexivity.
Qed.

Lemma length_unitary_lists: forall {T1 T2: Type} (e1: T1) (e2: T2),
length [e1] = length [e2].
Proof. reflexivity. Qed.

Lemma length_firstn_lists: forall {T1 T2: Type} (l1: list T1) (l2: list T2) (k: nat),
length l1 = length l2 ->
length (firstn k l1) = length (firstn k l2).
Proof.
intros T1 T2 l1 l2 k Hlen1_len2.
pose proof (firstn_length k l1) as eqn_len_firstn_l1.
pose proof (firstn_length k l2) as eqn_len_firstn_l2.
rewrite -> Hlen1_len2 in eqn_len_firstn_l1.
rewrite -> eqn_len_firstn_l1.
rewrite -> eqn_len_firstn_l2.
reflexivity.
Qed.


Lemma length_skipn_lists: forall {T: Type} (l1 l2: list T) (k: nat),
length l1 = length l2 ->
length (skipn k l1) = length (skipn k l2).
Proof.
intros T l1 l2 k Hlen1_len2.
pose proof (skipn_length k l1) as eqn_len_skipn_l1.
pose proof (skipn_length k l2) as eqn_len_skipn_l2.
rewrite -> Hlen1_len2 in eqn_len_skipn_l1.
rewrite -> eqn_len_skipn_l1.
rewrite -> eqn_len_skipn_l2.
reflexivity.
Qed.


(* One step of execution with one instruction *)
Lemma correctness_symb_exec_step: forall (instruction: instr) (in_stk curr_stk out_stk: tstack) (ops:opm)
          (height: nat) (curr_es out_es: execution_state) (curr_asfs out_asfs: asfs),
valid_asfs curr_asfs ->
length in_stk = height ->
eval_asfs in_stk curr_asfs ops = Some curr_stk ->
get_stack_es curr_es = curr_stk ->
concr_intpreter_instr instruction curr_es ops = Some out_es ->
get_stack_es out_es = out_stk ->
symbolic_exec'' instruction curr_asfs ops = Some out_asfs ->
eval_asfs in_stk out_asfs ops = Some out_stk.
Proof.
intros instruction in_stk curr_stk out_stk ops height curr_es out_es curr_asfs out_asfs
  Hvalid_asfs HLen Hevalcurr Hes_curr Hconcr Hes_out Hsymbexec.
destruct instruction eqn: eq_instr.
- (* PUSH *)
  unfold concr_intpreter_instr in Hconcr.
  unfold symbolic_exec'' in Hsymbexec.
  unfold push_c in Hconcr.
  destruct (push w (get_stack_es curr_es)) as [sk'|] eqn: eq_push_w; try discriminate.
  destruct (push (Val w) (get_stack_asfs curr_asfs)) as [s'|] eqn: eq_push_asfs; try discriminate.
  unfold push in eq_push_w.
  unfold push in eq_push_asfs.
  pose proof (concr_abs_stack_same_length in_stk curr_stk curr_asfs ops curr_es
    Hevalcurr Hes_curr) as H_eq_length_stacks.
  rewrite <- H_eq_length_stacks in eq_push_asfs.
  destruct (length (get_stack_es curr_es) <? StackLen) eqn: eq_length_stack_concr; try discriminate.
  injection eq_push_w. injection eq_push_asfs.
  intros eq_s' eq_sk'. symmetry in eq_s'. symmetry in eq_sk'.
  injection Hconcr. intro eq_out_es. symmetry in eq_out_es.
  rewrite -> eq_out_es in Hes_out.
  pose proof (set_get_stack_es curr_es sk') as eq_set_get_es.
  rewrite -> eq_set_get_es in Hes_out.
  rewrite <- Hes_out. rewrite -> eq_sk'.
  injection Hsymbexec. intro eq_out_asfs. symmetry in eq_out_asfs.
  rewrite -> eq_out_asfs. rewrite -> eq_s'.
  destruct curr_asfs as [hc maxc curr_abs curr_map] eqn: eq_curr_map.
  simpl. rewrite -> HLen.
  unfold eval_asfs.
  destruct (set_stack_asfs curr_asfs (Val w :: get_stack_asfs curr_asfs)).
  pose proof (eval_eq_stack_len in_stk curr_stk height hc maxc curr_abs curr_map ops
    HLen Hevalcurr) as eq_height_hc.
  rewrite -> eq_height_hc. rewrite Nat.eqb_refl.
  unfold eval_asfs2. unfold apply_f_list_asfs_stack_val.
  rewrite -> eval_const_val.
  fold apply_f_list_asfs_stack_val.
  rewrite -> eval_asfs2_ho.
  simpl in Hevalcurr. rewrite -> HLen in Hevalcurr. rewrite -> eq_height_hc in Hevalcurr.
  rewrite Nat.eqb_refl in Hevalcurr. rewrite -> Hevalcurr.
  rewrite -> Hes_curr. reflexivity.
- (* POP *)
  unfold concr_intpreter_instr in Hconcr.
  unfold symbolic_exec'' in Hsymbexec.
  unfold pop_c in Hconcr.
  destruct (pop (get_stack_es curr_es)) as [sk'|] eqn: eq_pop_w; try discriminate.
  destruct (pop (get_stack_asfs curr_asfs)) as [s'|] eqn: eq_pop_asfs; try discriminate.
  unfold pop in eq_pop_w.
  unfold pop in eq_pop_asfs.
  injection Hconcr. intros eq_out_es. symmetry in eq_out_es.
  rewrite -> eq_out_es in Hes_out.
  rewrite -> set_get_stack_es in Hes_out.
  injection Hsymbexec. intros eq_out_asfs. symmetry in eq_out_asfs. rewrite -> eq_out_asfs.
  rewrite -> Hes_curr in eq_pop_w.
  destruct curr_stk as [|h'' sk''] eqn: eq_curr_stk; try discriminate.
  unfold eval_asfs in Hevalcurr.
  destruct curr_asfs as [h mx curr_stack curr_map] eqn: eq_curr_asfs.
  rewrite -> HLen in Hevalcurr.
  destruct (height =? h) eqn: eq_height_h; try discriminate.
  simpl in eq_pop_asfs.
  destruct curr_stack as [| poped t] eqn: eq_curr_stack; try discriminate.
  simpl. rewrite -> HLen.
  rewrite -> eq_height_h.
  unfold eval_asfs2 in Hevalcurr.
  unfold apply_f_list_asfs_stack_val in Hevalcurr.
  rewrite -> eval_asfs2_ho in Hevalcurr.
  destruct (eval_asfs2_elem in_stk poped curr_map ops) eqn: eq_eval_asfs2_elem; try discriminate.
  injection eq_pop_asfs. intros eq_t_s'. rewrite <- eq_t_s'.
  destruct (eval_asfs2 in_stk t curr_map ops) eqn: eval_asfs2_t; try discriminate.
  injection Hevalcurr. intros eq_l_c _.
  rewrite -> eq_l_c. rewrite <- Hes_out. 
  injection eq_pop_w. intros eq_c_sk'. rewrite <- eq_c_sk'.
  reflexivity.
- (* DUP *)
  unfold concr_intpreter_instr in Hconcr.
  unfold dup_c in Hconcr. rewrite -> Hes_curr in Hconcr.
  destruct (dup pos curr_stk) as [sk'|] eqn: eq_dup_pos_curr_stk; try discriminate.
  injection Hconcr. intros eq_out_es. symmetry in eq_out_es.
  rewrite -> eq_out_es in Hes_out.
  rewrite -> set_get_stack_es in Hes_out. rewrite <- Hes_out.
  unfold symbolic_exec'' in Hsymbexec.
  destruct curr_asfs as [hc maxc sc mc] eqn: eq_currs_asfs.
  simpl in Hsymbexec.
  destruct (dup pos sc) as [s'|] eqn: eq_dup_pos_sc; try discriminate.
  injection Hsymbexec. intros eq_out_asfs. symmetry in eq_out_asfs.
  rewrite -> eq_out_asfs. simpl.
  destruct (length in_stk =? hc) eqn: eq_length_in_stk.
  + unfold dup in eq_dup_pos_sc.
    destruct ((pos =? 0) || (16 <? pos) || (StackLen <=? length sc))
      eqn: eq_cond_push; try discriminate.
    destruct (nth_error sc (pred pos)) eqn: eq_nth_error_sc; try discriminate.
    injection eq_dup_pos_sc. intros eq_s'. symmetry in eq_s'.
    rewrite -> eq_s'.
    unfold dup in eq_dup_pos_curr_stk.
    pose proof (height_stack_eval in_stk curr_stk hc maxc sc mc ops
    Hevalcurr) as eq_length_sc_curr_stk.
    rewrite <- eq_length_sc_curr_stk in eq_dup_pos_curr_stk.
    rewrite -> eq_cond_push in eq_dup_pos_curr_stk.
    destruct (nth_error curr_stk (pred pos)) as [x|] eqn: eq_nth_error_curr_stk;
      try discriminate.
    injection eq_dup_pos_curr_stk. intros eq_sk'. symmetry in eq_sk'.
    rewrite -> eq_sk'.
    unfold eval_asfs2. unfold apply_f_list_asfs_stack_val.
    fold apply_f_list_asfs_stack_val.
    pose proof (eval_asfs2_position in_stk curr_stk hc maxc (pred pos) sc mc
      ops a x Hevalcurr eq_nth_error_sc eq_nth_error_curr_stk) 
      as eq_eval_asfs2_elem_a.
    rewrite -> eq_eval_asfs2_elem_a.
    rewrite -> eval_asfs2_ho.
    unfold eval_asfs in Hevalcurr. 
    rewrite eq_length_in_stk in Hevalcurr.
    rewrite -> Hevalcurr. reflexivity.    
  + simpl in Hevalcurr. rewrite -> eq_length_in_stk in Hevalcurr.
    discriminate.
- (* SWAP *)
  unfold concr_intpreter_instr in Hconcr.
  unfold swap_c in Hconcr. rewrite -> Hes_curr in Hconcr.
  destruct (swap pos curr_stk) as [sk'|] eqn: eq_swap_pos_curr_stk; try discriminate.
  injection Hconcr. intros eq_out_es. symmetry in eq_out_es.
  rewrite -> eq_out_es in Hes_out.
  rewrite -> set_get_stack_es in Hes_out. rewrite <- Hes_out.
  unfold symbolic_exec'' in Hsymbexec.
  destruct curr_asfs as [hc maxc sc mc] eqn: eq_currs_asfs.
  simpl in Hsymbexec.
  destruct (swap pos sc) as [s'|] eqn: eq_swap_pos_sc; try discriminate.
  injection Hsymbexec. intros eq_out_asfs. symmetry in eq_out_asfs.
  rewrite -> eq_out_asfs. simpl.
  destruct (length in_stk =? hc) eqn: eq_length_in_stk.
  + assert (Hevalcurr_orig := Hevalcurr).
    unfold swap in eq_swap_pos_sc.
    destruct ((pos =? 0) || (16 <? pos))
      eqn: eq_cond_swap; try discriminate.
    destruct (nth_error sc pos) eqn: eq_nth_error_sc; try discriminate.
    destruct sc as [| hsc tsc] eqn: eq_sc; try discriminate.
    injection eq_swap_pos_sc. intros eq_s'. symmetry in eq_s'.
    rewrite -> eq_s'.
    unfold swap in eq_swap_pos_curr_stk.
    rewrite -> eq_cond_swap in eq_swap_pos_curr_stk.
    destruct (nth_error curr_stk pos) as [x|] eqn: eq_nth_error_curr_stk;
      try discriminate.
    destruct curr_stk as [| hv tv] eqn: eq_curr_stk; try discriminate.
    injection eq_swap_pos_curr_stk. intros eq_sk'. symmetry in eq_sk'.
    rewrite -> eq_sk'.
    pose proof (orb_false_elim (pos =? 0) (16 <? pos) eq_cond_swap)
      as [eq_pos_neq_0 _].
    pose proof (list_composition_for_swap pos hsc a tsc eq_pos_neq_0
      eq_nth_error_sc) as eq_decomposition_hsc_tsc.
    unfold eval_asfs in Hevalcurr.
    rewrite -> eq_length_in_stk in Hevalcurr.
    pose proof (list_composition_for_swap pos hv x tv eq_pos_neq_0
      eq_nth_error_curr_stk) as eq_decomposition_hv_tv.
    rewrite <- eq_sc in Hevalcurr. rewrite <- eq_curr_stk in Hevalcurr.
    rewrite <- eq_sc in eq_decomposition_hsc_tsc at 1.
    rewrite <- eq_curr_stk in eq_decomposition_hv_tv at 1.
    pose proof (length_unitary_lists hsc hv) as eq_len_hsc_hv.
    rewrite <- eq_currs_asfs in Hevalcurr_orig.
    rewrite <- eq_curr_stk in Hevalcurr_orig.
    rewrite <- eq_curr_stk in Hes_curr.
    pose proof (concr_abs_stack_same_length in_stk curr_stk curr_asfs
      ops curr_es Hevalcurr_orig Hes_curr) as eqn_len_curr_stk_abs.
    rewrite -> Hes_curr in eqn_len_curr_stk_abs.
    rewrite -> eq_currs_asfs in eqn_len_curr_stk_abs.
    rewrite -> eq_curr_stk in eqn_len_curr_stk_abs.
    simpl in eqn_len_curr_stk_abs.
    injection eqn_len_curr_stk_abs. intros eq_len_tv_tsc.
    symmetry in eq_len_tv_tsc.
    pose proof (length_firstn_lists tsc tv (pos-1) eq_len_tv_tsc)
      as eq_len_firstn_tsc_tv.
    pose proof (length_unitary_lists a x) as eq_len_a_x.
    pose proof (eval_asfs2_compositional4 in_stk curr_stk [hv]
      (firstn (pos - 1) tv) [x] (skipn (pos + 1) (hv :: tv))
      sc [hsc] (firstn (pos - 1) tsc) [a] (skipn (pos + 1) (hsc :: tsc))
      mc ops Hevalcurr eq_decomposition_hsc_tsc eq_decomposition_hv_tv
      eq_len_hsc_hv eq_len_firstn_tsc_tv eq_len_a_x) 
      as [eq_eval_asfs2_hsc [eq_eval_asfs2_firstn 
        [eq_eval_asfs2_a eq_eval_asfs2_skipn]]].
    pose proof (eval_asfs2_compositional_r in_stk [x]
      (firstn (pos - 1) tv) [a] (firstn (pos - 1) tsc)
      mc ops eq_eval_asfs2_a eq_eval_asfs2_firstn) as Heval_a_firstn.
    simpl in Heval_a_firstn.
    pose proof (eval_asfs2_compositional_r in_stk [hv]
      (skipn (pos + 1) (hv :: tv)) [hsc] (skipn (pos + 1) (hsc :: tsc))
      mc ops eq_eval_asfs2_hsc eq_eval_asfs2_skipn) as Heval_hsc_skipn.
    simpl in Heval_hsc_skipn.
    pose proof (eval_asfs2_compositional_r in_stk (x :: firstn (pos - 1) tv)
      (hv :: skipn (pos + 1) (hv :: tv)) (a :: firstn (pos - 1) tsc)
      (hsc :: skipn (pos + 1) (hsc :: tsc)) mc ops
      Heval_a_firstn Heval_hsc_skipn) as eqn_eval_all.
    assumption.
  + simpl in Hevalcurr. rewrite -> eq_length_in_stk in Hevalcurr.
    discriminate.
- (* OpCode *)
    simpl in Hconcr. destruct (ops label) as [oper|] eqn: eq_ops_label; try discriminate.
    destruct oper as [comm_flag nb_args func] eqn: eq_oper.
    simpl in Hsymbexec. rewrite -> eq_ops_label in Hsymbexec.
    unfold build_es_opt_stack in Hconcr.
    destruct (firstn_e nb_args (get_stack_es curr_es)) as [args|] eqn: eq_firstn_stk;
      try discriminate.
    destruct (skipn_e nb_args (get_stack_es curr_es)) as [insk'|] eqn: eq_skipn_stk;
      try discriminate.
    destruct (func args) as [v|] eqn: eq_func_args; try discriminate.
    injection Hconcr. intro eq_out_es. symmetry in eq_out_es.
    rewrite -> eq_out_es in Hes_out.
    rewrite -> set_get_stack_es in Hes_out. rewrite <- Hes_out.
    pose proof (concr_abs_stack_same_length in_stk curr_stk curr_asfs ops curr_es
      Hevalcurr Hes_curr) as eq_length_stk_es_stk_curr_asf.
    pose proof (same_length_firstn_e EVMWord asfs_stack_val nb_args (get_stack_es curr_es) 
      args (get_stack_asfs curr_asfs) eq_firstn_stk eq_length_stk_es_stk_curr_asf)
      as Hfirstn_asfs_ok.
    destruct Hfirstn_asfs_ok as [s1 eq_firstn_asfs].
    rewrite -> eq_firstn_asfs in Hsymbexec.
    pose proof (same_length_skip_e EVMWord asfs_stack_val nb_args (get_stack_es curr_es)
      insk' (get_stack_asfs curr_asfs) eq_skipn_stk eq_length_stk_es_stk_curr_asf)
      as Hskipn_asfs_ok.
    destruct Hskipn_asfs_ok as [s2 eq_skipn_asfs].
    rewrite -> eq_skipn_asfs in Hsymbexec.
    destruct curr_asfs as [hec maxc stkc mapc] eqn: eq_curr_asfs.
    destruct out_asfs as [heo maxo stko mapo] eqn: eq_out_asfs.
    unfold eval_asfs in Hevalcurr.
    destruct (length in_stk =? hec) eqn: eq_len_in_stk; try discriminate.
    rewrite <- eq_curr_asfs in eq_firstn_asfs.
    rewrite <- eq_curr_asfs in eq_skipn_asfs.
    rewrite <- eq_curr_asfs in Hsymbexec.
    rewrite <- eq_out_asfs in Hsymbexec.
    rewrite <- eq_curr_asfs in Hvalid_asfs.
    pose proof (opcode_exec_asfs_update ops label comm_flag nb_args hec maxc heo maxo
      func curr_es args insk' in_stk curr_stk v curr_asfs out_asfs stkc stko s1 s2
      mapc mapo Hvalid_asfs Hes_curr eq_ops_label eq_firstn_stk eq_skipn_stk eq_func_args eq_curr_asfs
      Hevalcurr eq_firstn_asfs eq_skipn_asfs Hsymbexec eq_out_asfs) 
      as [eq_stkc [eq_hec_heo [top_elem [eq_stko [eq_eval_top_elem eq_eval_s2]]]]].
    unfold eval_asfs. rewrite <- eq_hec_heo. rewrite -> eq_len_in_stk.
    rewrite -> eq_stko. unfold eval_asfs2.
    unfold apply_f_list_asfs_stack_val.
    rewrite -> eq_eval_top_elem. fold apply_f_list_asfs_stack_val. 
    rewrite -> eval_asfs2_ho.
    rewrite -> eq_eval_s2.
    reflexivity.
Qed.


Lemma gt_succ: forall (n m: nat), n > m -> S n > m.
Proof.
auto.
Qed.


Lemma fresh_var_gt_succ: forall (maxc: nat) (mc: asfs_map),
fresh_var_gt_map maxc mc ->
fresh_var_gt_map (S maxc) mc.
Proof.
intros maxc mc. revert maxc.
induction mc as [|h t IH].
- intuition.
- intros maxc Hfresh_var_gt_h_t.
  unfold fresh_var_gt_map in Hfresh_var_gt_h_t.
  destruct h as [k v] eqn: eq_h.
  fold fresh_var_gt_map in Hfresh_var_gt_h_t.
  simpl. destruct Hfresh_var_gt_h_t as [maxc_gt_k fresh_gt_maxc_t].
  split.
  + apply gt_succ. assumption.
  + apply IH in fresh_gt_maxc_t. assumption.
Qed.


Lemma valid_asfs_preservation: forall (curr_asfs out_asfs: asfs) (instruction: instr) (ops: opm),
valid_asfs curr_asfs ->
symbolic_exec'' instruction curr_asfs ops = Some out_asfs ->
valid_asfs out_asfs.
Proof.
intros curr_asfs out_asfs instruction ops Hvalid_curr_asfs Hsymbexec.
destruct curr_asfs as [hc maxc absc mc] eqn: eq_curr_asfs.
destruct out_asfs as [ho maxo abso mo] eqn: eq_out_asfs.
simpl in Hvalid_curr_asfs.
unfold symbolic_exec'' in Hsymbexec.
destruct instruction eqn: eq_inst.
- (*PUSH *)
  destruct (push (Val w)
                (get_stack_asfs (ASFSc hc maxc absc mc))) as [s'|] eqn: eq_push;
    try discriminate.
  simpl in Hsymbexec.
  injection Hsymbexec. intros eq_mc_mo eq_s'_abso eq_maxc_maxo _.
  simpl. rewrite <- eq_mc_mo. rewrite <- eq_maxc_maxo.
  assumption.
- (* POP *)
  destruct (pop (get_stack_asfs (ASFSc hc maxc absc mc))); try discriminate.
  simpl in Hsymbexec.
  injection Hsymbexec. intros eq_mc_mo eq_s'_abso eq_maxc_maxo _.
  simpl. rewrite <- eq_mc_mo. rewrite <- eq_maxc_maxo.
  assumption.
- (* DUP*) 
  destruct (dup pos (get_stack_asfs (ASFSc hc maxc absc mc))); try discriminate.
  simpl in Hsymbexec.
  injection Hsymbexec. intros eq_mc_mo eq_s'_abso eq_maxc_maxo _.
  simpl. rewrite <- eq_mc_mo. rewrite <- eq_maxc_maxo.
  assumption.
- (* SWAP *)
  destruct (swap pos (get_stack_asfs (ASFSc hc maxc absc mc))); try discriminate.
  simpl in Hsymbexec.
  injection Hsymbexec. intros eq_mc_mo eq_s'_abso eq_maxc_maxo _.
  simpl. rewrite <- eq_mc_mo. rewrite <- eq_maxc_maxo.
  assumption.
- (* Operator *)
  destruct (ops label) eqn: eq_label; try discriminate.
  destruct o eqn: eqn_o.
  destruct (firstn_e nb_args
                (get_stack_asfs (ASFSc hc maxc absc mc))) eqn: eq_firstn;
  try discriminate.
  destruct (skipn_e nb_args
                (get_stack_asfs (ASFSc hc maxc absc mc))) eqn: eq_skipn;
  try discriminate.
  unfold add_val_asfs in Hsymbexec.
  destruct (push
                (FreshVar
                   (get_maxid_asfs
                      (set_stack_asfs (ASFSc hc maxc absc mc) l0)))
                (get_stack_asfs
                   (set_stack_asfs (ASFSc hc maxc absc mc) l0))) eqn: eq_push;
  try discriminate.
  simpl in Hsymbexec.
  injection Hsymbexec. intros eq_mo eq_abso eq_maxo eq_ho.
  rewrite <- eq_mo. rewrite <- eq_maxo.
  unfold asfs_map_add. unfold valid_asfs. unfold fresh_var_gt_map.
  pose proof (Nat.nle_succ_diag_l maxc) as Sn_not_lte_n.
  rewrite -> Nat.add_1_r.
  rewrite <- Nat.leb_nle in Sn_not_lte_n.
  fold fresh_var_gt_map.
  destruct (Hvalid_curr_asfs) as [fresh_gt_maxc strictly_decr_mc].
  split; try split.
  + apply gt_Sn_n.
  + apply fresh_var_gt_succ. assumption.
  + simpl. destruct mc as [|h t] eqn: eq_m; try auto.
    destruct h as [v e]. split; try assumption.
    simpl in fresh_gt_maxc. destruct fresh_gt_maxc as [Hmaxc_gt_v _].
    assumption.
Qed.


Lemma get_stack_es_ok: forall (stk: tstack) (memory: tmemory)
  (storage: tstorage),
get_stack_es ((ExState stk memory storage)) = stk.
Proof.
reflexivity.
Qed.

Lemma correctness_symb_exec_gen: forall (curr_asfs out_asfs: asfs) 
  (in_stk curr_stk out_stk: tstack) (height: nat) (ops: opm) 
  (curr_es out_es: execution_state) (p: block),
valid_asfs curr_asfs ->
length in_stk = height ->
eval_asfs in_stk curr_asfs ops = Some curr_stk ->
get_stack_es curr_es = curr_stk ->
concr_interpreter p curr_es ops = Some out_es ->
get_stack_es out_es = out_stk ->
symbolic_exec' p curr_asfs ops = Some out_asfs ->
eval_asfs in_stk out_asfs ops = Some out_stk.
Proof.
intros curr_asfs out_asfs in_stk curr_stk out_stk height ops curr_es out_es p.
revert curr_asfs out_asfs in_stk curr_stk out_stk height ops curr_es out_es.
induction p as [|instr rp IH].
- (* Base Case: p = [] *)
  intros curr_asfs out_asfs in_stk curr_stk out_stk height ops curr_es out_es
    Hvalid_curr Hlen Heval_curr Hget_stack_curr Hconcr_intr Hget_stack_out
    Hsymb_exec.
  injection Hconcr_intr as eq_curr_out_es. 
  injection Hsymb_exec  as eq_curr_out_asfs.
  rewrite <- eq_curr_out_es in Hget_stack_out.
  subst. assumption.
- (* Inductuve Case = p = instr::rp *)
  intros curr_asfs out_asfs in_stk curr_stk out_stk height ops curr_es out_es
  Hvalid_curr Hlen Heval_curr Hget_stack_curr Hconcr_intr Hget_stack_out
  Hsymb_exec.
  (* Introduce intermediate a' insk' stki *)
  simpl in Hsymb_exec. simpl in Hconcr_intr.
  (** a' *)
  destruct (symbolic_exec'' instr curr_asfs ops) as [a'|] eqn:eq_symb_exec'';
    try discriminate.
  (** insk' *)
  destruct (concr_intpreter_instr instr curr_es ops) as [insk'|] 
    eqn: eq_concr_instr; try discriminate.
  (** stki *)
  destruct insk' as [stki memi stori] eqn:eq_insk'.
  pose proof (get_stack_es_ok stki memi stori) as eq_get_stack_insk'.
  rewrite <- eq_insk' in eq_concr_instr.
  rewrite <- eq_insk' in Hconcr_intr.
  rewrite <- eq_insk' in eq_get_stack_insk'.
  (* Show validity of a' *)
  pose proof (valid_asfs_preservation curr_asfs a' instr ops Hvalid_curr
    eq_symb_exec'') as Hvalid_a'.
  (* Show that a' evaluates to stki *)
  pose proof (correctness_symb_exec_step instr in_stk curr_stk stki ops height
    curr_es insk' curr_asfs a' Hvalid_curr Hlen Heval_curr Hget_stack_curr
    eq_concr_instr eq_get_stack_insk' eq_symb_exec'') as Heval_instr.
  (* Apply IH *)
  apply IH with (curr_asfs:=a')(curr_stk:=stki)(height:=height)(curr_es:=insk')
    (out_es:=out_es); try assumption.
Qed.


Lemma valid_asfs_empty: forall (n: nat),
valid_asfs (empty_asfs n).
Proof.
intros n.
unfold valid_asfs. unfold empty_asfs.
split.
- simpl. auto.
- simpl. auto.
Qed.


Lemma nth_error_ok' : forall (T: Type) (l : list T) (i : nat),
i < length l -> 
exists (v: T), nth_error l i = Some v.
Proof.
intros T l i. revert T l.
induction i as [| i' IH].
- intros T l Hlen.
  destruct l as [| h t] eqn: eq_l.
  + simpl in Hlen. 
    pose proof (Nat.nlt_0_r 0). contradiction.
  + simpl. exists h. reflexivity.
- intros T l Hlen.
  destruct l as [| h t] eqn: eq_l.
  + simpl in Hlen. pose proof (Nat.nlt_0_r (S i')). contradiction.
  + simpl in Hlen. rewrite <- Nat.succ_lt_mono in Hlen.
    simpl.
    pose proof (IH T t Hlen). assumption.
Qed.

Lemma lt_minus_lt_0: forall (n m: nat),
m < n -> 0 < (n - m).
Proof.
intros n.
induction n as [| n' IH].
- intros m Hm_lt_0. 
  pose proof (Nat.nlt_0_r m).
  contradiction.
- intros m Hm_lt_sn.
  destruct m as [|m'] eqn: eq_m.
  + rewrite -> Nat.sub_0_r. assumption.
  + pose proof (lt_S_n m' n' Hm_lt_sn) as eq_m'_lt_n'.
    pose proof (IH m' eq_m'_lt_n') as IHc.
    rewrite -> Nat.sub_succ.
    assumption.
Qed.

Lemma succ_minus_succ: forall (n i: nat),
i < n -> S (n - S i) = n - i.
Proof.
intros n i H_i_lt_n.
rewrite -> Nat.sub_succ_r.
pose proof (lt_minus_lt_0 n i H_i_lt_n) as Hni_gt_0.
pose proof (Nat.succ_pred_pos (n - i) Hni_gt_0) as Hs_pred_n_i.
assumption.
Qed.


Lemma skipn_nth: forall (T: Type) (i: nat) (l: list T) (v: T),
nth_error l i = Some v -> 
skipn i l = v :: (skipn (S i) l).
Proof.
intros T i. induction i as [| i' IH].
- intros l v Hnth_error.
  destruct l as [|h t] eqn: eq_l.
  + simpl in Hnth_error. discriminate.
  + simpl in Hnth_error. simpl.
    injection Hnth_error. intros eq_h_v. rewrite -> eq_h_v.
    reflexivity.
- intros l v Hnth_error.
  destruct l as [|h t] eqn: eq_l.
  + simpl in Hnth_error. discriminate.
  + simpl in Hnth_error.
    rewrite -> skipn_cons.
    rewrite -> skipn_cons.
    pose proof (IH t v Hnth_error).
    assumption.
Qed.

(* We need to use it with i=length stk=n*)
(* This is only true for i<=n *)
Lemma empty_skip_eval: forall (i n: nat) (stk: tstack) (ops: opm),
length stk = n ->
i <= n -> n > 0 ->
eval_asfs2 stk (List.map InStackVar (seq (n-i) i)) [] ops = 
  Some (skipn (n-i) stk).
Proof.
intros i n stk ops.
induction i as [| i' IH].
- intros Hlen_stk Hi_n Hn. simpl. 
  rewrite -> Nat.sub_0_r.
  unfold eval_asfs2. unfold apply_f_list_asfs_stack_val.
  rewrite <- Hlen_stk. rewrite -> skipn_all.
  reflexivity.
- intros Hlen_stk Hi_n Hn. simpl. 
  unfold eval_asfs2. unfold apply_f_list_asfs_stack_val.
  rewrite -> eval_asfs2_ho. unfold eval_asfs2_elem.
  pose proof (gt_Sn_O i') as eq_Si_gt_0.
  pose proof (Nat.sub_lt n (S i') Hi_n eq_Si_gt_0) as eq_si_n.
  rewrite <- Hlen_stk in eq_si_n at 2.
  pose proof (@nth_error_ok' EVMWord stk (n - S i') eq_si_n) as
    eq_nth_error_value_ex.
  destruct (eq_nth_error_value_ex) as [x eq_nth_error_value].
  rewrite -> eq_nth_error_value.
  pose proof (le_Sn_le i' n Hi_n) as eq_i'_leq_n.
  pose proof (IH Hlen_stk eq_i'_leq_n Hn) as IHc.
  rewrite -> Nat.le_succ_l in Hi_n.
  pose proof (succ_minus_succ n i' Hi_n) as eq_n_i_succ.
  rewrite -> eq_n_i_succ.
  rewrite -> IHc.
  pose proof (skipn_nth EVMWord (n - (S i')) stk x eq_nth_error_value)
    as eq_skipn_x.
  rewrite -> eq_skipn_x. 
  rewrite -> eq_n_i_succ.
  reflexivity.
Qed. 



Lemma empty_skip_eval_zero: forall (i n: nat) (stk: tstack) (ops: opm),
length stk = n ->
i <= n -> n = 0 ->
eval_asfs2 stk (List.map InStackVar (seq (n-i) i)) [] ops = 
  Some (skipn (n-i) stk).
Proof.
intros i n stk ops Hlen_stk Hin_leq Hnzero.
rewrite -> Hnzero. simpl.
rewrite -> Hnzero in Hin_leq.
rewrite -> Nat.le_0_r in Hin_leq.
rewrite -> Hin_leq. simpl.
rewrite -> Hnzero in Hlen_stk.
destruct stk as [| h t] eqn: eq_stk.
- unfold eval_asfs2. unfold apply_f_list_asfs_stack_val.
  reflexivity.
- simpl in Hlen_stk. discriminate.
Qed.

Lemma empty_asfs_concr_stk: forall (n: nat) (stk: tstack) (ops: opm),
length stk = n ->
eval_asfs stk (empty_asfs n) ops = Some stk.
Proof.
intros n stk ops Hlen_stk. unfold empty_asfs.
unfold eval_asfs. rewrite -> Hlen_stk.
rewrite <- beq_nat_refl.
unfold gen_initial_stack.
destruct n as [| n'] eqn: eq_n.
- pose proof (eq_refl 0) as eq_0_0.
  pose proof (Nat.le_refl 0) as eq_leq_0.
  pose proof (empty_skip_eval_zero 0 0 stk ops Hlen_stk eq_leq_0 eq_0_0)
    as Heval_nil.
  rewrite -> Nat.sub_diag in Heval_nil.
  assumption.
- rewrite <- eq_n in Hlen_stk.
  pose proof (Nat.le_refl n) as eq_leq_n.
  pose proof (gt_Sn_O n') as eq_sn_gt_0.
  rewrite <- eq_n in eq_sn_gt_0.
  pose proof (empty_skip_eval n n stk ops Hlen_stk eq_leq_n eq_sn_gt_0)
    as eq_eval.
  rewrite -> Nat.sub_diag in eq_eval.
  rewrite -> eq_n in eq_eval.
  rewrite -> eq_eval.
  rewrite -> skipn_O.
  reflexivity.
Qed.


(* A complete block*)
Lemma correctness_symb_exec_eval: forall (p: block) (in_stk out_stk: tstack)
  (ops:opm) (height: nat) (in_es out_es: execution_state) (out_asfs: asfs),
length in_stk = height ->
get_stack_es in_es = in_stk ->
concr_interpreter p in_es ops = Some out_es ->
get_stack_es out_es = out_stk ->
symbolic_exec p height ops = Some out_asfs ->
eval_asfs in_stk out_asfs ops = Some out_stk.
Proof.
intros p in_stk out_stk ops height in_es out_es out_asfs Hlen_in_stk
  Hget_in_es Hconcr_p Hget_out_stk Hsymbolic_exec.
unfold symbolic_exec in Hsymbolic_exec.
pose proof (valid_asfs_empty height) as H_valid_empty.
pose proof (empty_asfs_concr_stk height in_stk ops Hlen_in_stk)
  as H_eval_empty.
pose proof (correctness_symb_exec_gen (empty_asfs height) out_asfs
  in_stk in_stk out_stk height ops in_es out_es p H_valid_empty
  Hlen_in_stk H_eval_empty Hget_in_es Hconcr_p Hget_out_stk
  Hsymbolic_exec).
assumption.
Qed.


Lemma symb_exec'_strictly_decreasing: forall (p: block) (a a': asfs) 
  (ops: opm),
valid_asfs a ->
symbolic_exec' p a ops = Some a' ->
valid_asfs a'.
Proof.
induction p as [| ins rp IH].
- intros. simpl in H0. injection H0 as eq_a_a'. 
  rewrite <- eq_a_a'. assumption.
- intros. simpl in H0. 
  destruct (symbolic_exec'' ins a ops) as [a''|] 
    eqn: eq_sym_exec''; try discriminate.
  apply valid_asfs_preservation in eq_sym_exec''; try assumption.
  apply IH in H0; try assumption.
Qed.


Lemma decreasing_asfs_empty_asfs: forall (height: nat),
valid_asfs (empty_asfs height).
Proof.
intros. simpl. auto.
Qed.


Lemma symb_exec_valid_asfs: forall (p: block) (height: nat) (ops: opm)
  (sfs: asfs),
symbolic_exec p height ops = Some sfs ->
valid_asfs sfs.
Proof.
intros.
unfold symbolic_exec in H.
apply symb_exec'_strictly_decreasing with (p:=p) (a:=empty_asfs height)
  (ops:=ops).
- apply decreasing_asfs_empty_asfs.
- assumption.
Qed.



Lemma push_same_len: forall {X Y: Type} (e: X) (l1 l2: list X) 
  (e': Y) (l1': list Y),
push e l1 = Some l2 ->
length l1 = length l1' ->
exists (l2': list Y), push e' l1' = Some l2'.
Proof.
intros. unfold push in H.
destruct (length l1 <? StackLen) eqn: Hlen_ok; try discriminate.
unfold push. rewrite -> H0 in Hlen_ok. rewrite -> Hlen_ok.
exists (e' :: l1'). reflexivity.
Qed.


Lemma push_same_len2: forall {X Y: Type} (e: X) (l1 l2: list X) 
  (e': Y) (l1' l2': list Y),
push e l1 = Some l2 ->
push e' l1' = Some l2' ->
length l1 = length l1' ->
length l2 = length l2'.
Proof.
intros. unfold push in H.
destruct (length l1 <? StackLen) eqn: Hlen_ok; try discriminate.
unfold push in H0. rewrite -> H1 in Hlen_ok. rewrite -> Hlen_ok in H0.
injection H as H. injection H0 as H0.
rewrite <- H0. simpl.
symmetry in H0.
rewrite <- H.
apply length_cons. assumption.
Qed.


Lemma length_s_then_cons: forall {X: Type} (l: list X) (n: nat),
length l = S n ->
exists (h: X) (t: list X), l = (h::t).
Proof.
intros. destruct l.
- simpl in H. discriminate.
- exists x. exists l. reflexivity.
Qed.


Lemma pop_same_len: forall {X Y: Type} (l1 l2: list X) (l1': list Y),
pop l1 = Some l2 ->
length l1 = length l1' ->
exists (l2': list Y), pop l1' = Some l2'.
Proof.
induction l1 as [| h t IH].
- intros. simpl in H. discriminate.
- intros. simpl in H. simpl in H0. symmetry in H0. 
  apply length_s_then_cons in H0 as [h' [t' eq_l1']].
  rewrite eq_l1'. simpl. exists t'.
  reflexivity.
Qed.


Lemma pop_len: forall {X: Type} (l1 l2: list X),
pop l1 = Some l2 ->
length l1 = S (length l2).
Proof.
intros. destruct l1 as [| h t]; try discriminate.
simpl in H. injection H as H. rewrite <- H.
simpl. reflexivity.
Qed.

Lemma dup_same_len: forall {X Y: Type} (pos: nat) (l1 l2: list X) 
  (l1': list Y),
dup pos l1 = Some l2 ->
length l1 = length l1' ->
exists (l2': list Y), dup pos l1' = Some l2'.
Proof.
intros. unfold dup in H.
destruct ((pos =? 0) || (16 <? pos) || (StackLen <=? length l1)) 
  eqn: cond_ok; try discriminate.
destruct (nth_error l1) as [x|] eqn: eq_nth_error; try discriminate.
unfold dup. rewrite -> H0 in cond_ok. rewrite -> cond_ok.
apply some_is_not_none in eq_nth_error.
apply nth_error_Some in eq_nth_error.
rewrite -> H0 in eq_nth_error.
apply nth_error_ok' in eq_nth_error.
destruct eq_nth_error as [v eq_nth_l1'].
rewrite -> eq_nth_l1'.
exists (v :: l1'). reflexivity.
Qed.

Lemma dup_len: forall {X: Type} (n:nat) (l1 l2: list X),
dup n l1 = Some l2 ->
S (length l1) = length l2.
Proof.
intros. unfold dup in H.
destruct ((n =? 0) || (16 <? n) || (StackLen <=? length l1)) eqn: cond_ok;
  try discriminate.
destruct (nth_error l1 (pred n)) as [x|] eqn: eq_nth_err; try discriminate.
injection H as H.
rewrite <- H. 
reflexivity.
Qed.


Lemma swap_same_len: forall {X Y: Type} (pos: nat) (l1 l2: list X) 
  (l1': list Y),
swap pos l1 = Some l2 ->
length l1 = length l1' ->
exists (l2': list Y), swap pos l1' = Some l2'.
Proof.
intros. unfold swap in H.
destruct ((pos =? 0) || (16 <? pos)) eqn: cond_ok; try discriminate.
destruct (nth_error l1 pos) as [v|] eqn: eq_nth_error_l1; try discriminate.
destruct (l1) as [| h t] eqn: eq_l1; try discriminate.
unfold swap. rewrite -> cond_ok.
apply some_is_not_none in eq_nth_error_l1.
apply nth_error_Some in eq_nth_error_l1.
rewrite -> H0 in eq_nth_error_l1.
apply nth_error_ok' in eq_nth_error_l1.
destruct eq_nth_error_l1 as [v' eq_nth_l1'].
rewrite -> eq_nth_l1'.
simpl in H0. symmetry in H0. apply length_s_then_cons in H0.
destruct H0 as [h' [t' eq_l1']]. rewrite eq_l1'.
exists ([v'] ++ firstn (pos - 1) t' ++ [h'] ++ skipn (pos + 1) (h' :: t')).
reflexivity.
Qed.


Lemma swap_same_len2: forall {X Y: Type} (n:nat) (l1 l2: list X)
  (l1' l2': list Y),
swap n l1 = Some l2 ->
swap n l1' = Some l2' ->
length l1 = length l1' ->
length l2 = length l2'.
Proof.
intros. unfold swap in H.
destruct ((n =? 0) || (16 <? n)) eqn: cond_ok; try discriminate.
destruct (nth_error l1 n) eqn: eq_nth_err; try discriminate.
destruct l1 as [|h t] eqn: eq_l1; try discriminate.
injection H as H.
unfold swap in H0. rewrite -> cond_ok in H0.
destruct (nth_error l1' n) eqn: eq_nth_err_concr; try discriminate.
destruct (l1') as [|h' t'] eqn: eq_l1'; try discriminate.
injection H0 as H0.
rewrite <- H. rewrite <- H0.
simpl.
rewrite -> app_length. rewrite -> app_length.
rewrite -> firstn_length. rewrite -> firstn_length.
simpl. rewrite -> skipn_length. rewrite -> skipn_length.
rewrite -> H1.
simpl in H1. injection H1 as H1.
rewrite -> H1.
reflexivity.
Qed.


Lemma symb_exec_step_len_presev: forall (i: instr) 
  (curr_asfs a': asfs) (ops: opm) (curr_es curr_es': execution_state),
symbolic_exec'' i curr_asfs ops = Some a' ->
length (get_stack_asfs curr_asfs) = length (get_stack_es curr_es) ->
concr_intpreter_instr i curr_es ops = Some curr_es' ->
length (get_stack_asfs a') = length (get_stack_es curr_es').
Proof.
intros. 
simpl in H1. destruct curr_es as [stack memory storage] eqn: eq_curr_es.
simpl in H0.
destruct i eqn: eq_i.
- (* PUSH *) 
  simpl in H. 
  destruct (push (Val w) (get_stack_asfs curr_asfs)) 
    as [s'|] eqn: eq_push_symb; try discriminate.
  simpl in H1.
  unfold push_c in H1. simpl in H1.
  destruct (push w stack) as [sk'|] eqn: eq_push_concr; try discriminate.
  injection H1 as H1. rewrite <- H1. simpl.
  pose proof (push_same_len2 (Val w) (get_stack_asfs curr_asfs) s' w
    stack sk' eq_push_symb eq_push_concr H0).
  injection H as H.
  rewrite <- H. simpl.
  rewrite -> get_set_stack_idem. assumption.
- (* POP *)
  simpl in H. 
  destruct (pop (get_stack_asfs curr_asfs)) 
    as [s'|] eqn: eq_pop_symb; try discriminate.
  unfold pop in H1. simpl in H1.
  unfold pop_c in H1. simpl in H1.
  destruct (pop stack) as [sk'|] eqn: eq_pop_concr; try discriminate.
  injection H1 as H1. rewrite <- H1. simpl.
  pose proof (pop_len (get_stack_asfs curr_asfs) s' eq_pop_symb) as
    Hlen_symb.
  injection H as H. rewrite <- H. 
  rewrite -> get_set_stack_idem.
  pose proof (pop_len stack sk' eq_pop_concr) as Hlen_concr.
  rewrite -> Hlen_concr in H0.
  rewrite -> Hlen_symb in H0.
  injection H0 as H0.
  assumption.
- (* DUP *)
  simpl in H. 
  destruct (dup pos (get_stack_asfs curr_asfs)) as [s'|] eqn: eq_dup_symb;
    try discriminate.
  simpl in H1. unfold dup_c in H1. simpl in H1.
  destruct (dup pos stack) as [sk'|] eqn: eq_dup_concr; try discriminate.
  injection H1 as H1. rewrite <- H1. simpl.
  apply dup_len in eq_dup_symb.
  apply dup_len in eq_dup_concr.
  injection H as H. rewrite <- H. rewrite get_set_stack_idem.
  rewrite <- eq_dup_symb. rewrite <- eq_dup_concr.
  auto.
- (* SWAP *)
  simpl in H. 
  destruct (swap pos (get_stack_asfs curr_asfs)) as [s'|] eqn: eq_swap_symb;
    try discriminate.
  simpl in H1. unfold swap_c in H1. simpl in H1.
  destruct (swap pos stack) as [sk'|] eqn: eq_swap_concr; try discriminate.
  injection H1 as H1. rewrite <- H1. simpl.
  pose proof (swap_same_len2 pos (get_stack_asfs curr_asfs) s' stack sk'
    eq_swap_symb eq_swap_concr H0).
  injection H as H. rewrite <- H. rewrite get_set_stack_idem.
  assumption.
- (* Operator *)
  simpl in H.
  destruct (ops label) as [oper|] eqn: eq_ops_label; try discriminate.
  destruct oper as [comm nargs f] eqn: eq_oper.
  destruct (firstn_e nargs (get_stack_asfs curr_asfs)) as [s1|] 
    eqn: eq_firstn_e_symb; try discriminate.
  destruct (skipn_e nargs (get_stack_asfs curr_asfs)) as [s2|]
    eqn: eq_skipn_e_symb; try discriminate.
  simpl in H.
  apply add_val_asfs_incr in H as HH.
  rewrite -> get_set_stack_idem in HH.
  simpl in H1. rewrite -> eq_ops_label in H1.
  destruct (firstn_e nargs stack) as [args|]
    eqn: eq_firstn_e_concr; try discriminate.
  destruct (skipn_e nargs stack) as [insk'|]
    eqn: eq_skipn_e_concr; try discriminate.
  destruct (f args) as [v|] eqn: eq_f_args; try discriminate.
  injection H1 as H1. rewrite <- H1.
  simpl.
  pose proof (skipn_e_same_len nargs (get_stack_asfs curr_asfs) s2 
    stack insk' eq_skipn_e_symb eq_skipn_e_concr H0)
    as H2.
  rewrite <- H2.
  assumption.
Qed.



Lemma correctness_symb_success_step: forall (instruction: instr) 
 (ops:opm) (curr_es: execution_state) (curr_asfs out_asfs: asfs),
valid_asfs curr_asfs ->
valid_stack_op_map ops ->
symbolic_exec'' instruction curr_asfs ops = Some out_asfs ->
length (get_stack_asfs curr_asfs) = length (get_stack_es curr_es)->
exists (out_es: execution_state), 
  concr_intpreter_instr instruction curr_es ops = Some out_es.
Proof.
intros instruction ops curr_es curr_asfs out_asfs H Hvalid_ops H0 H1.
destruct instruction eqn: eq_instr.
- (* PUSH *)
  simpl. unfold push_c.
  destruct curr_es as [curr_stk' memory storage] eqn: eq_curr_es. 
  simpl. simpl in H1. 
  simpl in H0.
  destruct (push (Val w) (get_stack_asfs curr_asfs)) as [s'|]
    eqn: eq_push_asfs_stack; try discriminate.
  pose proof (push_same_len (Val w) (get_stack_asfs curr_asfs) s' 
    w curr_stk' eq_push_asfs_stack H1) as [sk'' Hpush].
  rewrite Hpush.
  exists (ExState sk'' memory storage).
  reflexivity.
- (* POP *)
  simpl. unfold pop_c.
  destruct curr_es as [curr_stk' memory storage] eqn: eq_curr_es. 
  simpl. simpl in H1. 
  simpl in H0.
  destruct (pop (get_stack_asfs curr_asfs)) as [s'|]
    eqn: eq_pop_asfs_stack; try discriminate.
  
  pose proof (pop_same_len (get_stack_asfs curr_asfs) s' curr_stk'
    eq_pop_asfs_stack H1) as [sk'' Hpop].
  rewrite Hpop. exists (ExState sk'' memory storage).
  reflexivity.
- (* DUP *) 
  simpl. unfold dup_c.
  destruct curr_es as [curr_stk' memory storage] eqn: eq_curr_es. 
  simpl. simpl in H1. 
  simpl in H0.
  destruct (dup pos (get_stack_asfs curr_asfs)) as [s'|]
    eqn: eq_dup_asfs_stack; try discriminate.
  pose proof (dup_same_len pos (get_stack_asfs curr_asfs) s' curr_stk'
    eq_dup_asfs_stack H1) as [sk'' Hdup].
  rewrite Hdup. exists (ExState sk'' memory storage).
  reflexivity.
- (* SWAP *)
  simpl. unfold swap_c.
  destruct curr_es as [curr_stk' memory storage] eqn: eq_curr_es. 
  simpl. simpl in H1. 
  simpl in H0.
  destruct (swap pos (get_stack_asfs curr_asfs)) as [s'|]
    eqn: eq_swap_asfs_stack; try discriminate.
  pose proof (swap_same_len pos (get_stack_asfs curr_asfs) s' curr_stk'
    eq_swap_asfs_stack H1) as [sk'' Hswap].
  rewrite Hswap. exists (ExState sk'' memory storage).
  reflexivity.
- (* opcode *)
  simpl in H0. destruct (ops label) as [oper|] eqn: eq_ops_label; 
    try discriminate.
  destruct oper as [comm nargs f] eqn: eq_oper.
  simpl. rewrite eq_ops_label.
  destruct (firstn_e nargs (get_stack_asfs curr_asfs)) as [s1|] 
    eqn: eq_firstn_e_curr_asfs; try discriminate.
  destruct (skipn_e nargs (get_stack_asfs curr_asfs)) as [s2|]
    eqn: eq_skipn_e_curr_asfs; try discriminate.
  pose proof (same_length_firstn_e asfs_stack_val EVMWord nargs
    (get_stack_asfs curr_asfs) s1 (get_stack_es curr_es)
    eq_firstn_e_curr_asfs H1) as [vargs Hfirstn_e_es].
  rewrite -> Hfirstn_e_es.
  pose proof (same_length_skip_e asfs_stack_val EVMWord nargs
    (get_stack_asfs curr_asfs) s2 (get_stack_es curr_es)
    eq_skipn_e_curr_asfs H1) as [sk'' Hskipn_e_es].
  rewrite -> Hskipn_e_es.
  unfold valid_stack_op_map in Hvalid_ops.
  destruct Hvalid_ops as [_ Hcoherent_ops].
  unfold coherent_stack_op_map in Hcoherent_ops.
  apply Hcoherent_ops with (l:=vargs) in eq_ops_label.
  + destruct (eq_ops_label) as [v Hfvargs].
    rewrite -> Hfvargs.
    exists (set_stack_es curr_es (v :: sk'')).
    reflexivity.
  + apply firstn_e_length with (l:=get_stack_es curr_es).
    assumption.
Qed.



Lemma correctness_symb_success_gen: forall (p: block) 
  (curr_asfs out_asfs: asfs) (ops: opm) (curr_es: execution_state),
valid_asfs curr_asfs ->
valid_stack_op_map ops ->
symbolic_exec' p curr_asfs ops = Some out_asfs ->
length (get_stack_asfs curr_asfs) = length (get_stack_es curr_es) ->
exists (out_es: execution_state),
  concr_interpreter p curr_es ops = Some out_es.
Proof.
induction p as [| instr t IH].
- intros. simpl. exists curr_es. reflexivity.
- intros curr_asfs out_asfs ops curr_es H Hvalid_ops H0 H1. simpl in H0.
  destruct (symbolic_exec'' instr curr_asfs ops) as [a'|] eqn: eq_symb_instr;
    try discriminate.
  pose proof (correctness_symb_success_step instr ops curr_es curr_asfs
    a' H Hvalid_ops eq_symb_instr H1) as [curr_es' HH].
  pose proof (valid_asfs_preservation curr_asfs a' instr ops H eq_symb_instr)
    as valid_a'.
  pose proof (symb_exec_step_len_presev instr curr_asfs a' ops curr_es
    curr_es' eq_symb_instr H1 HH) as eq_len_curr_es'.
  pose proof (IH a' out_asfs ops curr_es' valid_a' Hvalid_ops H0 
    eq_len_curr_es') as [out_es eq_concr_exec].
  exists out_es. simpl. rewrite -> HH.
  assumption.
Qed.


Lemma correctness_symb_success: forall (p: block) (in_stk : tstack)
  (ops:opm) (height: nat) (in_es : execution_state) (out_asfs: asfs),
get_stack_es in_es = in_stk ->
length in_stk = height ->
symbolic_exec p height ops = Some out_asfs ->
valid_stack_op_map ops ->
exists (out_es: execution_state), 
   concr_interpreter p in_es ops = Some out_es.
Proof.
intros.
unfold symbolic_exec in H1.
pose proof (valid_asfs_empty height) as valid_empty_height.
assert (length (get_stack_asfs (empty_asfs height)) = height) as eq_len.
- simpl. unfold gen_initial_stack. 
  rewrite -> map_length.
  apply seq_length.
- rewrite <- eq_len in H0.
  rewrite <- H in H0.
  symmetry in H0.
  pose proof (correctness_symb_success_gen p (empty_asfs height) out_asfs
  ops in_es valid_empty_height H2 H1 H0).
  assumption.
Qed.


Theorem correctness_symb_exec: forall (p: block) (in_stk : tstack)
  (ops:opm) (height: nat) (in_es : execution_state) (out_asfs: asfs),
get_stack_es in_es = in_stk ->
length in_stk = height ->
symbolic_exec p height ops = Some out_asfs ->
valid_stack_op_map ops ->
exists (out_es: execution_state), 
   concr_interpreter p in_es ops = Some out_es /\ 
   eval_asfs in_stk out_asfs ops = Some (get_stack_es out_es).
Proof.
intros.
pose proof (correctness_symb_success p in_stk ops height in_es out_asfs
  H H0 H1 H2) as [out_es Hsucess].
exists out_es. split; try assumption.
assert (get_stack_es out_es = get_stack_es out_es) as HH; try reflexivity.
pose proof (correctness_symb_exec_eval p in_stk (get_stack_es out_es) ops
  height in_es out_es out_asfs H0 H Hsucess HH H1).
 assumption.
Qed.


Theorem sym_exec_snd: forall (p: block) (k: nat) (ops: opm)
  (sst: asfs),
valid_stack_op_map ops ->
symbolic_exec p k ops = Some sst ->
valid_asfs sst /\
 forall (in_st : execution_state) (in_stk : tstack),
   get_stack_es in_st = in_stk ->
   length in_stk = k ->
   exists (out_st : execution_state),
     concr_interpreter p in_st ops = Some out_st /\
     eval_asfs in_stk sst ops = Some (get_stack_es out_st).
Proof.
intros. split.
- apply symb_exec_valid_asfs with (p:=p) (height:=k) (ops:=ops).
  assumption.
- intros. apply correctness_symb_exec with (height:=k); try assumption.
Qed.










Definition is_comm_op (opcode: oper_label) (ops: opm) : bool :=
  match (ops opcode) with
  | Some (Op true _ _) => true
  | _ => false
  end.



(*
Fixpoint apply_f_opt_list {X Y: Type} (f: X -> option Y) (l: list X) :
  option (list Y) :=
match l with 
| [] => Some []
| elem::rs => let felem := f elem in
              let frs := apply_f_opt_list f rs in
              match (felem, frs) with 
              | (Some elem_val, Some rs_val) => Some (elem_val::rs_val)
              | _ => None
              end
end.*)


Definition apply_f_opt_list2 {A B: Type} (f : A -> option B) :=
fix apply_f_opt_list_fix (v : list A) : option (list B) :=
    match v with
    | [] => Some []
    |vh::vt =>   let felem := f vh in
                 let frs := apply_f_opt_list_fix vt in
                 match (felem, frs) with 
                 | (Some elem_val, Some rs_val) => Some (elem_val::rs_val)
                 | _ => None
                 end
    end.

(* Definition apply_f_list_fixed {X Y: Type} (f: X -> option Y) (l: list X): *)
(* For lists of at most 4 elements *)
Definition apply_f_opt_list {X Y: Type} (f: X -> option Y) (l: list X): 
  option (list Y) :=
match l with
| [] => Some []
| [a1] => match f a1 with
          | Some v1 => Some [v1]
          | _ => None
          end
| [a1; a2] => match f a1, f a2 with
              | Some v1, Some v2 => Some [v1; v2]
              | _, _ => None
              end
| [a1; a2; a3] => match f a1, f a2, f a3 with
                  | Some v1, Some v2, Some v3 => Some [v1; v2; v3]
                  | _, _, _ => None
                  end
| [a1; a2; a3; a4] => match f a1, f a2, f a3, f a4 with
                      | Some v1, Some v2, Some v3, Some v4 => 
                            Some [v1; v2; v3; v4]
                      | _, _, _, _ => None
                      end                  
| _ => None
end.


(* Evaluation of complete stack expressions (trees withouth fresh variables *)
Fixpoint eval_stack_expr (e: stack_expr) (s: tstack) (ops: opm) {struct e}: 
  option EVMWord :=
match e with
 | UVal val => Some val
 | UInStackVar idx => nth_error s idx
 | UOp label args => match ops label with
                     | None => None
                     | Some (Op comm nargs func) =>
                         if (List.length args =? nargs) then 
                           let f := fun (e: stack_expr) => 
                                      eval_stack_expr e s ops in
                           match apply_f_opt_list f args with
                           | Some args' => func args'
                           | _ => None
                           end
                         else None
                     end
end.


(* Creates the AST version of an asfs_stack_value (follows FreshVar links *)
Fixpoint flat_stack_elem (e: asfs_stack_val) (m: asfs_map) {struct m} 
  : option stack_expr :=
match e with
| Val v => Some (UVal v)
| InStackVar n => Some (UInStackVar n)
| FreshVar n => 
    match m with 
    | (idx, mv)::rm => 
         if idx =? n then
         match mv with
             | ASFSBasicVal (Val v) => Some (UVal v)
             | ASFSBasicVal (InStackVar n) => Some (UInStackVar n)
             | ASFSBasicVal (FreshVar n) => flat_stack_elem (FreshVar n) rm
             | ASFSOp opcode args =>
                 let f := fun (elem': asfs_stack_val) => 
                          flat_stack_elem elem' rm in
                 match apply_f_opt_list f args with
                 | Some fargs => Some (UOp opcode fargs)
                 | _ => None
                 end
             end
        else flat_stack_elem e rm
    | _ => None
    end
end.


(* For lists with at most 4 elements *)
Definition compare_lists_pred {X Y: Type} (f: X -> Y -> bool) 
  (l1: list X) (l2: list Y): bool :=
match l1,l2 with
| [], [] => true
| [h1], [h1'] => f h1 h1'
| [h1;h2], [h1';h2'] => f h1 h1' && f h2 h2'
| [h1;h2;h3], [h1';h2';h3'] => f h1 h1' && f h2 h2' && f h3 h3'
| [h1;h2;h3;h4], [h1';h2';h3';h4'] => f h1 h1' && f h2 h2' && 
                                      f h3 h3' && f h4 h4'
|_, _ => false
end.


Definition fold_left {A B: Type} (f : A -> B -> bool) :=
fix fold_left_fix (v : list A) : list B -> bool :=
    match v with
    | [] => fun w =>  match w with
                      | [] => true
                      | _ => false
                      end
    |vh::vt =>
        fun w => match w with
                      | [] => false
                      | wh::wt => (andb (f vh wh) (fold_left_fix vt wt))
                      end
end.


Fixpoint compare_flat_asfs_map_val (e1 e2 : stack_expr) (ops: opm) {struct e1}
  : bool :=
match e1, e2 with
| UVal v1, UVal v2 => weqb v1 v2
| UInStackVar var1, UInStackVar var2 => var1 =? var2 
| UOp opcode [a1;a2], UOp opcode' [a1';a2'] => 
  (opcode =?i opcode') && 
    ((compare_flat_asfs_map_val a1 a1' ops) &&
     (compare_flat_asfs_map_val a2 a2' ops) 
    ||
     (is_comm_op opcode ops) &&
     (compare_flat_asfs_map_val a1 a2' ops) &&
     (compare_flat_asfs_map_val a2 a1' ops)
    )
| UOp opcode1 args1, UOp opcode2 args2 => 
  if (eq_oper_label opcode1 opcode2) then
    compare_lists_pred (fun a b => compare_flat_asfs_map_val a b ops) args1 args2
  else
    false
| _,_ => false
end.



Fixpoint apply_pred_lists {X: Type} (f: X -> X -> bool) (l1 l2: list X) 
  {struct l1} : bool :=
match l1, l2 with 
| [], [] => true
| h1::t1, h2::t2 => (f h1 h2) && (apply_pred_lists f t1 t2)
| _, _ => false
end.

(* ENRIQUE: CANNOT DETECT DECREASING ARGUMENT!!!
(* Compares if two AST of flat_asfs_map_val are equivalent (considering
   commutativity) *)
Fixpoint compare_flat_asfs_map_val (e1 e2: flat_asfs_map_val) (ops: opm)
 {struct e1}: bool :=
match (e1, e2) with
| (FASFSBasicVal (Val v1), FASFSBasicVal (Val v2)) => weqb v1 v2
| (FASFSBasicVal (InStackVar v1), FASFSBasicVal (InStackVar v2)) => v1 =? v2
| (FASFSOp opcode [arg1;arg2], FASFSOp opcode' [arg1';arg2']) => 
  (* Binary case to consider commutativity *)
  false
| (FASFSOp opcode args, FASFSOp opcode' args') => 
      let f := fun (a b: flat_asfs_map_val) => 
                   compare_flat_asfs_map_val a b ops in
      (eq_oper_label opcode opcode') && (apply_pred_lists f args args')
| _ => false
end.
*)

(*
Fixpoint compare_flat_asfs_map_val (e1 e2: stack_expr) (ops: opm)
 {struct e1}: bool :=
match e1, e2 with
| UVal v1, UVal v2 => weqb v1 v2
| UInStackVar v1, UInStackVar v2 => v1 =? v2
| UOp opcode [], UOp opcode' [] => opcode =?i opcode'
| UOp opcode [arg], UOp opcode' [arg'] => 
    (opcode =?i opcode') && (compare_flat_asfs_map_val arg arg' ops)
| UOp opcode [arg1;arg2], UOp opcode' [arg1';arg2'] => 
  (* Binary case to consider commutativity *)
  (opcode =?i opcode') && 
    ((compare_flat_asfs_map_val arg1 arg1' ops) &&
     (compare_flat_asfs_map_val arg2 arg2' ops) 
    ||
     (is_comm_op opcode ops) &&
     (compare_flat_asfs_map_val arg1 arg2' ops) &&
     (compare_flat_asfs_map_val arg2 arg1' ops)
    )
(* General case for any length cannot be define because of termination *)
(*| (FASFSOp opcode args, FASFSOp opcode' args') => 
      let f := fun (a b: flat_asfs_map_val) => 
                   compare_flat_asfs_map_val a b ops in
      (eq_oper_label opcode opcode') && (apply_pred_lists f args args')*)
| _, _ => false
end.*)



Definition asfs_eq_stack_elem (e1 e2: asfs_stack_val) (m1 m2: asfs_map) 
  (ops: opm) : bool :=
match (flat_stack_elem e1 m1, flat_stack_elem e2 m2) with
| (Some fe1, Some fe2) => compare_flat_asfs_map_val fe1 fe2 ops
| _ => false
end.


Section All.
  Variable T : Type.
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


(*Section asfs_stack_val_ind'.
  Variable P : asfs_stack_val -> Prop.
  Hypothesis Val_case: forall (v: EVMWord), P (Val v).
  Hypothesis InStackVar_case: forall (n: nat), P (InStackVar n).
  Hypothesis FreshVarUOp_case : forall (opcode: oper_label)
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
End asfs_stack_val_ind'.*)


Lemma eval_asfs2_val: forall (s: tstack) (val: EVMWord) (m: asfs_map) 
  (ops: opm),
eval_asfs2_elem s (Val val) m ops = Some val.
Proof.
intros.
destruct m; try reflexivity.
Qed.

Lemma flat_stack_val: forall (val: EVMWord) (m: asfs_map),
flat_stack_elem (Val val) m = Some (UVal val).
Proof.
intros. destruct m; try reflexivity.
Qed.

Lemma eval_asfs2_instackvar: forall (s: tstack) (var: nat) (m: asfs_map) 
  (ops: opm),
eval_asfs2_elem s (InStackVar var) m ops = nth_error s var.
Proof.
intros.
destruct m; try reflexivity.
Qed.

Lemma flat_stack_instackvar: forall (n: nat) (m: asfs_map),
flat_stack_elem (InStackVar n) m = Some (UInStackVar n).
Proof.
intros. destruct m; try reflexivity.
Qed.


Lemma eval_tree_asfs_val: forall (e: asfs_stack_val) (m: asfs_map) 
  (fe: stack_expr) (s: tstack) (ops: opm),
flat_stack_elem e m = Some fe ->
eval_asfs2_elem s e m ops = eval_stack_expr fe s ops.
Proof.
intros e m. revert e. induction m as [|h t IH].
- intros.
  destruct e as [val|var|var] eqn: eq_e.
  + simpl in H. injection H as H.
    rewrite <- H. reflexivity.
  + simpl in H. injection H as H.
    rewrite <- H. reflexivity.
  + simpl in H. discriminate. 
- intros. destruct e as [val|var|var] eqn: eq_e.
  + simpl in H. injection H as H. rewrite <- H.
    reflexivity.
  + simpl in H. injection H as H. rewrite <- H.
    reflexivity.
  + simpl in H. destruct h as [idx mv] eqn: eq_h.
    destruct (idx =? var) eqn: eq_idx_var.
    * destruct mv as [basic|opcode args] eqn: eq_mv.
      -- destruct basic as [val'|var'|var'] eqn: eq_basic.
         ++ injection H as H. rewrite <- H. simpl.
            rewrite -> eq_idx_var. rewrite -> eval_asfs2_val.
            reflexivity.
         ++ injection H as H. rewrite <- H. simpl.
            rewrite -> eq_idx_var. rewrite -> eval_asfs2_instackvar.
            reflexivity.
         ++ simpl. rewrite -> eq_idx_var. 
            apply IH. assumption.
      -- unfold apply_f_opt_list in H.
         destruct args as [|h1 t1].
         ++ (* args = [] *)
            injection H as H. rewrite <- H. simpl.
            rewrite -> eq_idx_var. reflexivity.
         ++ destruct t1 as [|h2 t2].
            ** (* args = [a1] *)
               destruct (flat_stack_elem h1) as [v1|] eqn: flat_h1; 
                 try discriminate.
               injection H as H. rewrite <- H.
               simpl. rewrite -> eq_idx_var.
               apply IH with (s:=s)(ops:=ops) in flat_h1.
               rewrite -> flat_h1.
               reflexivity.
            ** destruct t2 as [|h3 t3]. 
               --- (* args = [a1;a2] *)
                   destruct (flat_stack_elem h1) as [v1|] eqn: flat_h1; 
                     try discriminate.
                   destruct (flat_stack_elem h2) as [v2|] eqn: flat_h2; 
                     try discriminate.
                   injection H as H. rewrite <- H.
                   simpl. rewrite -> eq_idx_var.
                   apply IH with (s:=s)(ops:=ops) in flat_h1.
                   apply IH with (s:=s)(ops:=ops) in flat_h2.
                   rewrite -> flat_h1.
                   rewrite -> flat_h2.
                   destruct (ops opcode) as [oper|]; try reflexivity.
                   destruct oper as [comm nargs f]; try reflexivity.
                   destruct nargs; try reflexivity.
                   destruct nargs; try reflexivity.
                   destruct nargs; try reflexivity.
                   destruct (eval_stack_expr v1 s ops); try reflexivity.
                   destruct (eval_stack_expr v2 s ops); try reflexivity.
               --- destruct t3 as [|h4 t4].
                   +++ (* args = [a1;a2;a3] *) 
                       admit.
                   +++ destruct t4 as [|h5 t5]; try discriminate.
                       (* args = [a1;a2;a3;a4] *)
                       admit.
    * simpl. rewrite -> eq_idx_var. 
      apply IH. assumption.
Qed.


Section All.
  Variable T : Type.
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

Lemma fold_left_len: forall {A B: Type} (l1: list A) (l2: list B)
  (f : A -> B -> bool),
fold_left f l1 l2 = true ->
length l1 = length l2.
Proof.
induction l1 as [|h t IH].
- intros. simpl in H. destruct l2 eqn: eq_l2; try discriminate.
  reflexivity.
- intros. simpl in H. destruct l2 as [| h' t'] eqn: eq_l2; try discriminate.
  apply andb_prop in H as [_ Hfold].
  apply IH in Hfold. simpl. rewrite Hfold. reflexivity.
Qed.



Lemma compare_flat_eval: forall (e1 e2 : stack_expr) (ops: opm),
compare_flat_asfs_map_val e1 e2 ops = true ->
valid_stack_op_map ops ->
forall (s: tstack), eval_stack_expr e1 s ops = 
                    eval_stack_expr e2 s ops.
Proof.
induction e1 as [v|var|opcode args IH] using stack_expr_ind'.
- intros. unfold compare_flat_asfs_map_val in H.
  destruct e2 as [v2|var2|opcode2 args2] eqn: eq_v2; try discriminate.
  simpl. apply weqb_sound in H. rewrite -> H.
  reflexivity.
- intros. unfold compare_flat_asfs_map_val in H.
  destruct e2 as [v2|var2|opcode2 args2] eqn: eq_v2; try discriminate.
  simpl. apply Nat.eqb_eq in H. rewrite -> H.
  reflexivity.
- intros. unfold compare_flat_asfs_map_val in H.
  destruct args as [|h1 t1] eqn: eq_args; try discriminate.
  + (* args = [] *)
    destruct e2 as [v2|var2|opcode2 args2] eqn: eq_e2; try discriminate.
    destruct (opcode =?i opcode2) eqn: eq_opcodes; try discriminate.
    fold compare_flat_asfs_map_val in H.
    unfold fold_left in H. destruct args2; try discriminate.
    apply eq_oper_label_correct in eq_opcodes.
    rewrite -> eq_opcodes.
    reflexivity.
  + destruct t1 as [|h2 t2] eqn: eq_t1.
    * (* args = h1::t1 *)
      destruct e2 as [v2|var2|opcode2 args2] eqn: eq_e2; try discriminate.
      destruct (opcode =?i opcode2) eqn: eq_opcodes; try discriminate.
      fold compare_flat_asfs_map_val in H.
      unfold compare_lists_pred in H.
      destruct args2 as [|h1' t1'] eqn: eq_arg2; try discriminate.
      destruct t1'; try discriminate.
      simpl in IH. destruct IH as [IH' _].
      pose proof (IH' h1' ops H H0 s) as Heval_h1_h1'.
      simpl. apply eq_oper_label_correct in eq_opcodes.
      rewrite <- eq_opcodes.
      rewrite -> Heval_h1_h1'.
      reflexivity.
    * destruct t2 as [|h3 t3] eqn: eq_t2.
      -- (* args = h1::h2::t2 *)
         destruct e2 as [v2|var2|opcode2 args2] eqn: eq_e2; try discriminate.
         fold compare_flat_asfs_map_val in H.
         destruct args2 as [|h1' t1'] eqn: eq_arg2.
         ++ destruct (opcode =?i opcode2) eqn: eq_opcodes; try discriminate.
         ++ destruct t1' as [|h2' t2'] eqn: eq_t1'; try (
              (destruct (opcode =?i opcode2) eqn: eq_opcodes; 
                 try discriminate);
               rewrite -> andb_false_r in H; discriminate).
            destruct t2' as [|h3' t3'] eqn: eq_t2'; try (
              (destruct (opcode =?i opcode2) eqn: eq_opcodes; 
                 try discriminate);
               rewrite -> andb_false_r in H;
               rewrite -> andb_false_r in H;
               discriminate
            ).
            destruct (opcode =?i opcode2) eqn: eq_opcodes; 
                 try discriminate.
            simpl in H.
            destruct (compare_flat_asfs_map_val h1 h1' ops &&
                      compare_flat_asfs_map_val h2 h2' ops)
              eqn: eq_compare_h1_h2; try discriminate.
            ** apply andb_true_iff in eq_compare_h1_h2
                 as [comp_h1 comp_h2].
               apply eq_oper_label_correct in eq_opcodes. 
               rewrite -> eq_opcodes.
               simpl in IH. destruct IH as [IH_h1 [IH_h2 _]].
               pose proof (IH_h1 h1' ops comp_h1 H0 s) as eq_eval_h1.
               pose proof (IH_h2 h2' ops comp_h2 H0 s) as eq_eval_h2.
               simpl. rewrite -> eq_eval_h1. rewrite -> eq_eval_h2.
               reflexivity.
            ** (* Commutative case *)
               destruct (is_comm_op opcode ops && 
                         compare_flat_asfs_map_val h1 h2' ops &&
                         compare_flat_asfs_map_val h2 h1' ops) 
                 eqn: eq_comm; try discriminate.
                 apply andb_true_iff in eq_comm as [eq_comm' comp_h2].
                 apply andb_true_iff in eq_comm' as [eq_comm comp_h1].
                 apply eq_oper_label_correct in eq_opcodes.
                 rewrite <- eq_opcodes.
                 simpl in IH. destruct IH as [IH_h1 [IH_h2 _]].
                 pose proof (IH_h1 h2' ops comp_h1 H0 s) as eq_eval_h1.
                 pose proof (IH_h2 h1' ops comp_h2 H0 s) as eq_eval_h2.
                 simpl. 
                 destruct (ops opcode) as [oper|] eqn: eq_opcode; 
                   try reflexivity.
                 destruct oper as [comm nargs func] eqn: eq_oper; 
                   try discriminate.
                 destruct nargs as [|nargs']; try reflexivity.
                 destruct nargs' as [|nargs'']; try reflexivity.
                 destruct nargs'' as [|nargs''']; try reflexivity.
                 destruct (eval_stack_expr h1 s ops) as [v1|] eqn: eval_h1.
                 --- rewrite <- eq_eval_h1. 
                     destruct (eval_stack_expr h2 s ops) as [v2|]
                       eqn: eval_h2.
                     +++ rewrite <- eq_eval_h2.
                         unfold valid_stack_op_map in H0.
                         destruct H0 as [Hcomm _].
                         unfold stack_op_map_comm in Hcomm.
                         unfold is_comm_op in eq_comm.
                         rewrite -> eq_opcode in eq_comm.
                         destruct comm eqn: eq_comm_true; try discriminate.
                         pose proof (Hcomm opcode func eq_opcode) as Hcomm_f.
                         rewrite -> Hcomm_f.
                         reflexivity.
                     +++ rewrite <- eq_eval_h2. reflexivity.
                 --- rewrite <- eq_eval_h1.
                     destruct (eval_stack_expr h2 s ops) as [v2|]
                       eqn: eval_h2.
                     +++ rewrite <- eq_eval_h2. reflexivity.
                     +++ rewrite <- eq_eval_h2. reflexivity.
      -- (* args = h1::h2::h3::t3 *)
         destruct e2 as [v2|var2|opcode2 args2] eqn: eq_e2; try discriminate.
         destruct (opcode =?i opcode2) eqn: eq_opcodes; try discriminate.
         simpl in H.
         fold compare_flat_asfs_map_val in H.
         destruct t3 as [|h4 t4] eqn: eq_t3.
         ++ destruct args2 as [|h1' t1'] eqn: eq_arg2; try discriminate.
            destruct t1' as [|h2' t2'] eqn: eq_t1'; try discriminate.
            destruct t2' as [|h3' t3'] eqn: eq_t2'; try discriminate.
            destruct t3' as [|h4' t4'] eqn: eq_t3'; try discriminate.
            apply andb_true_iff in H as [H comp_h3].
            apply andb_true_iff in H as [comp_h1 comp_h2].
            simpl in IH. destruct IH as [IH_h1 [IH_h2 [IH_h3 _]]].
            pose proof (IH_h1 h1' ops comp_h1 H0 s) as eq_eval_h1.
            pose proof (IH_h2 h2' ops comp_h2 H0 s) as eq_eval_h2.
            pose proof (IH_h3 h3' ops comp_h3 H0 s) as eq_eval_h3.
            simpl.
            apply eq_oper_label_correct in eq_opcodes.
            rewrite <- eq_opcodes.
            rewrite -> eq_eval_h1.
            rewrite -> eq_eval_h2.
            rewrite -> eq_eval_h3.
            reflexivity.
         ++ (* args = h1::h2::h3::h4::t4 *)
            destruct t4 as [|h5 t5] eqn: eq_t4; try discriminate.
            destruct args2 as [|h1' t1'] eqn: eq_arg2; try discriminate.
            destruct t1' as [|h2' t2'] eqn: eq_t1'; try discriminate.
            destruct t2' as [|h3' t3'] eqn: eq_t2'; try discriminate.
            destruct t3' as [|h4' t4'] eqn: eq_t3'; try discriminate.
            destruct t4' as [|h5' t5'] eqn: eq_t4'; try discriminate.
            apply andb_true_iff in H as [H comp_h4].
            apply andb_true_iff in H as [H comp_h3].
            apply andb_true_iff in H as [comp_h1 comp_h2].
            simpl in IH.
            simpl in IH. destruct IH as [IH_h1 [IH_h2 [IH_h3 [IH_h4 _]]]].
            pose proof (IH_h1 h1' ops comp_h1 H0 s) as eq_eval_h1.
            pose proof (IH_h2 h2' ops comp_h2 H0 s) as eq_eval_h2.
            pose proof (IH_h3 h3' ops comp_h3 H0 s) as eq_eval_h3.
            pose proof (IH_h4 h4' ops comp_h4 H0 s) as eq_eval_h4.
            simpl.
            apply eq_oper_label_correct in eq_opcodes.
            rewrite <- eq_opcodes.
            rewrite -> eq_eval_h1.
            rewrite -> eq_eval_h2.
            rewrite -> eq_eval_h3.
            rewrite -> eq_eval_h4.
            reflexivity.
Qed.


(* Main lemma for comparing ASFS values *)
Lemma compare_expr_eq_eval: forall (e1 e2: asfs_stack_val) (ops: opm) 
  (m1 m2: asfs_map),
asfs_eq_stack_elem e1 e2 m1 m2 ops = true ->
valid_stack_op_map ops ->
forall (s: tstack), eval_asfs2_elem s e1 m1 ops = eval_asfs2_elem s e2 m2 ops.
Proof.
intros. unfold asfs_eq_stack_elem in H.
destruct (flat_stack_elem e1 m1) as [fe1|] eqn: tree_e1; try discriminate.
destruct (flat_stack_elem e2 m2) as [fe2|] eqn: tree_e2; try discriminate.
pose proof (compare_flat_eval fe1 fe2 ops H H0 s).
apply eval_tree_asfs_val with (s:=s)(ops:=ops) in tree_e1.
rewrite -> tree_e1.
apply eval_tree_asfs_val with (s:=s)(ops:=ops) in tree_e2.
rewrite -> tree_e2.
assumption.
Qed.


Fixpoint asfs_eq_stack (s1 s2: asfs_stack) (m1 m2: asfs_map) (ops: opm) : bool :=
match s1, s2 with 
| nil, nil => true
| e1::r1, e2::r2 => (asfs_eq_stack_elem e1 e2 m1 m2 ops) && 
                    (asfs_eq_stack r1 r2 m1 m2 ops)
| _, _ => false
end.


Definition asfs_eq (a1 a2: asfs) (ops: opm) : bool :=
match a1, a2 with
| ASFSc height1 maxid1 curr_stack1 amap1, 
  ASFSc height2 maxid2 curr_stack2 amap2 => 
    let eq_size := height1 =? height2 in
    let eq_stack := asfs_eq_stack curr_stack1 curr_stack2 amap1 amap2 ops in
    eq_size && eq_stack
end.


Definition eq_ss (ss1 ss2: asfs) (ops: opm) : Prop :=
forall (s: tstack), eval_asfs s ss1 ops = eval_asfs s ss2 ops.

Lemma asfs_eq_stack_correct: forall (s1 s2: asfs_stack) (m1 m2: asfs_map) 
  (ops: opm),
asfs_eq_stack s1 s2 m1 m2 ops = true -> 
valid_stack_op_map ops ->
forall (s: tstack), eval_asfs2 s s1 m1 ops = eval_asfs2 s s2 m2 ops.
Proof.
induction s1 as [| h t IH].
- intros. unfold asfs_eq_stack in H. 
  destruct s2 as [|h' t']; try discriminate.
  reflexivity.
- intros s2 m1 m2 ops H H0 s. unfold asfs_eq_stack in H. 
  destruct s2 as [|h' t']; try discriminate.
  fold asfs_eq_stack in H.
  destruct (asfs_eq_stack_elem h h' m1 m2 ops) eqn: eq_stack_elem;
    try discriminate.
  destruct (asfs_eq_stack t t' m1 m2 ops) eqn: eq_stack_t;
    try discriminate.
  unfold eval_asfs2. unfold apply_f_list_asfs_stack_val.
  pose proof (compare_expr_eq_eval h h' ops m1 m2 eq_stack_elem H0 s)
    as eq_eval_h_h'.
  rewrite -> eq_eval_h_h'.
  destruct (eval_asfs2_elem s h m1 ops) as [v1|] eqn: eval_h.
  + fold apply_f_list_asfs_stack_val. rewrite eval_asfs2_ho.
    fold apply_f_list_asfs_stack_val. rewrite eval_asfs2_ho.
    pose proof (IH t' m1 m2 ops eq_stack_t H0 s) as IHc.
    rewrite -> IHc. reflexivity.
  + rewrite <- eq_eval_h_h'. reflexivity.
Qed.


Theorem asfs_eq_correctness:
  forall (a1 a2: asfs) (ops: opm),
  asfs_eq a1 a2 ops = true ->
  valid_stack_op_map ops ->
  eq_ss a1 a2 ops.
Proof.
intros.
unfold asfs_eq in H.
destruct a1 as [h1 mx1 s1 m1] eqn: eq_a1.
destruct a2 as [h2 mx2 s2 m2] eqn: eq_a2.
destruct (h1 =? h2) eqn: eq_h1_h2; try discriminate.
destruct (asfs_eq_stack s1 s2 m1 m2 ops) eqn: eq_stack; try discriminate.
unfold eq_ss. intros. simpl.
rewrite -> Nat.eqb_eq in eq_h1_h2. rewrite -> eq_h1_h2.
destruct (length s =? h2 ); try reflexivity.
apply asfs_eq_stack_correct; try assumption.
Qed.

End SFS.

Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import List.
Require Import Coq_EVM.lib.evmModel.
Require Import Coq_EVM.datatypes.
Import EVM_Def Concrete Abstract.
Import ListNotations.


Definition firstn_e {A: Type} (n: nat) (l: list A) : option (list A) :=
  if n <=? length l then Some (firstn n l) else None.

Definition skipn_e {A: Type} (n:nat) (l:list A) : option (list A) :=
  if n <=? length l then Some (skipn n l) else None.

Compute firstn 0 [1;2;3;4;5].
Compute firstn 1 [1;2;3;4;5].
Compute firstn 6 [1;2;3;4;5].

Compute firstn_e 0 [1;2;3;4;5].
Compute firstn_e 1 [1;2;3;4;5].
Compute firstn_e 6 [1;2;3;4;5].

Compute skipn 0 [1;2;3;4;5].
Compute skipn 1 [1;2;3;4;5].
Compute skipn 6 [1;2;3;4;5].

Compute skipn_e 0 [1;2;3;4;5].
Compute skipn_e 1 [1;2;3;4;5].
Compute skipn_e 6 [1;2;3;4;5].


Module Interpreter.

Inductive execution_state :=
 | ExState (stack: tstack) (memory: tmemory) (storage: tstorage).
 
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

(* stack manipulation operators *)

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
else match nth_error sk k with
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


Example test_swap0:
let state0 := ExState [(natToWord WLen 1);(natToWord WLen 2);(natToWord WLen 3)] empty_nmap empty_nmap in
swap_c 0 state0 = None.
Proof. 
reflexivity.
Qed.

Example test_swap1:
let state0 := ExState [(natToWord WLen 1);(natToWord WLen 2);(natToWord WLen 3)] empty_nmap empty_nmap in
let state1 := ExState [(natToWord WLen 2);(natToWord WLen 1);(natToWord WLen 3)] empty_nmap empty_nmap in 
swap_c 1 state0 = Some state1.
Proof. 
reflexivity.
Qed.

Example test_swap2:
let state0 := ExState [(natToWord WLen 1);(natToWord WLen 2);(natToWord WLen 3)] empty_nmap empty_nmap in
let state1 := ExState [(natToWord WLen 3);(natToWord WLen 2);(natToWord WLen 1)] empty_nmap empty_nmap in 
swap_c 2 state0 = Some state1.
Proof. 
reflexivity.
Qed.

Example test_swap_longer:
let state0 := ExState [(natToWord WLen 1);(natToWord WLen 2);(natToWord WLen 3)] empty_nmap empty_nmap in
swap_c 3 state0 = None.
Proof. 
reflexivity.
Qed.

Example test_swap_17:
let state0 := ExState [(natToWord WLen 1);(natToWord WLen 2);(natToWord WLen 3)] empty_nmap empty_nmap in
swap_c 17 state0 = None.
Proof. 
reflexivity.
Qed.

Example test_swap_16:
let state0 := ExState [(natToWord WLen 1);
                       (natToWord WLen 2);
                       (natToWord WLen 3);
                       (natToWord WLen 4);
                       (natToWord WLen 5);
                       (natToWord WLen 6);
                       (natToWord WLen 7);
                       (natToWord WLen 8);
                       (natToWord WLen 9);
                       (natToWord WLen 10);
                       (natToWord WLen 11);
                       (natToWord WLen 12);
                       (natToWord WLen 13);
                       (natToWord WLen 14);
                       (natToWord WLen 15);
                       (natToWord WLen 16);
                       (natToWord WLen 17)] empty_nmap empty_nmap in
let state1 := ExState [(natToWord WLen 17);
                       (natToWord WLen 2);
                       (natToWord WLen 3);
                       (natToWord WLen 4);
                       (natToWord WLen 5);
                       (natToWord WLen 6);
                       (natToWord WLen 7);
                       (natToWord WLen 8);
                       (natToWord WLen 9);
                       (natToWord WLen 10);
                       (natToWord WLen 11);
                       (natToWord WLen 12);
                       (natToWord WLen 13);
                       (natToWord WLen 14);
                       (natToWord WLen 15);
                       (natToWord WLen 16);
                       (natToWord WLen 1)] empty_nmap empty_nmap in
swap_c 16 state0 = Some state1.
Proof. 
reflexivity.
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

Fixpoint concr_interpreter (insts : prog) (es : execution_state)
  (ops : opm) : option execution_state :=
  match insts with
  | [] => Some es
  | inst::insts' =>
    match (concr_intpreter_instr inst es ops) with
    | None => None
    | Some insk' => concr_interpreter insts' insk' ops
    end
  end.

Compute (concr_interpreter 
        [PUSH 1 (natToWord WLen 7); Opcode ADD] 
        (ExState [(natToWord WLen 8);(natToWord WLen 2);(natToWord WLen 3)] empty_nmap empty_nmap)
        opmap).

End Interpreter.  


Module SFS.
Include Interpreter.

(** ** List Manipulation Functions *)
Fixpoint remove {A: Type} (eqa: A -> A -> bool) (l: list A) (a: A) : list A :=
  match l with
  | nil => nil
  | h::t => if eqa h a then t else h::(remove eqa t a)
  end.

Fixpoint member {A: Type} (eqa: A -> A -> bool) (l: list A) (a: A) : bool :=
  match l with
  | nil => false
  | h::t => if eqa h a then true else member eqa t a
  end.

Fixpoint subset {A: Type} (eqa: A -> A -> bool) (l1 l2 : list A) : bool :=
  match l1 with
  | nil => true
  | h::t => if member eqa l2 h then subset eqa t (remove eqa l2 h) else false
  end.

Compute subset Nat.eqb [1; 3; 2; 3] [1; 2; 3].

(* Set equality *)
Definition permutation {A: Type} (eqa: A -> A -> bool) (l1 l2 : list A) : bool := 
  (subset eqa l1 l2) && (subset eqa l2 l1).

(* Check equality element by element. Order matters *)
Fixpoint list_eq {A: Type} (eqa: A -> A -> bool) (l1 l2 : list A) : bool :=
  match l1, l2 with
  | nil, nil => true
  | h1::l1', h2::l2' => if eqa h1 h2 then list_eq eqa l1' l2' else false
  | _, _ => false
  end.

Compute list_eq Nat.eqb [1;2;3] [1;2;3;4].
Compute permutation Nat.eqb [1;3;2] [3;1;4].


(** ** Getter and Setter *)
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


(** ** Stack Manipulation and Creation *)
Definition in_to_asfs' (v: nat) : asfs_stack_val := InStackVar v.
Definition in_to_asfs  (s: in_stack) : asfs_stack := List.map in_to_asfs' s.

Definition concrete_to_asfs' (v: EVMWord) : asfs_stack_val := Val v.
Definition concrete_to_asfs  (s: list EVMWord) : asfs_stack := List.map concrete_to_asfs' s.

Fixpoint gen_initial_stack_inv {T: Type} (size: nat) (f: nat -> T): list T :=
  match size with
  | 0 => nil
  | S n => (f n)::(gen_initial_stack_inv n f)
  end.

Definition gen_initial_stack {T: Type} (size: nat) (f: nat -> T): list T :=
  rev (gen_initial_stack_inv size f).

Definition empty_asfs (size: nat) : asfs :=
  let s := gen_initial_stack size in_to_asfs' in
  ASFSc size 0 s nil.

(*
Definition asfs_stack_val_eq (a b: asfs_stack_val) : bool :=
  match a, b with
  | Val v1, Val v2 => weqb v1 v2
  | InStackVar v1, InStackVar v2 => Nat.eqb v1 v2
  | FreshVar v1, FreshVar v2 => Nat.eqb v1 v2
  | _, _ => false
  end.

Definition asfs_map_val_eq (ops: opm) (a b: asfs_map_val) : option bool :=
  match a, b with
  | ASFSBasicVal v1,  ASFSBasicVal v2  => Some (asfs_stack_val_eq v1 v2)
  | ASFSOp op1 args1, ASFSOp op2 args2 => 
      match eq_gen_instr op1 op2 with
      | true => 
          match ops op1 with
          | None => None
          | Some (Op comm nargs f) => 
              match comm with
              | true  => Some (permutation asfs_stack_val_eq args1 args2)
              | false => Some (list_eq asfs_stack_val_eq args1 args2)
              end
          end
      | false => Some false 
      end 
  | _, _ => Some false
  end.

Fixpoint asfs_map_get_id (ops: opm) (m: asfs_map) (a: asfs_map_val): option nat :=
  match m with
  | nil => None
  | h::m' => 
      match asfs_map_val_eq ops a (snd h) with
      | None => None
      | Some false => asfs_map_get_id ops m' a
      | Some true => Some (fst h)
      end
  end.
  
(* simplified version of Joseba's code *)
Fixpoint asfs_stack_val_list_eq (a b: list asfs_stack_val) : bool :=
  match a, b with
  | nil, nil => true
  | h1::t1, h2::t2 => asfs_stack_val_eq h1 h2 && asfs_stack_val_list_eq t1 t2
  | _, _ => false
  end.

Definition asfs_map_val_eq (ops: opm) (a b: asfs_map_val) : bool :=
  match a, b with
  | ASFSBasicVal v1,  ASFSBasicVal v2  => asfs_stack_val_eq v1 v2
  | ASFSOp op1 args1, ASFSOp op2 args2 => 
      eq_gen_instr op1 op2 && asfs_stack_val_list_eq args1 args2
  | _, _ => false
  end.

Fixpoint asfs_map_get_id (ops: opm) (m: asfs_map) (a: asfs_map_val): option nat :=
  match m with
  | nil => None
  | h::m' => 
      match asfs_map_val_eq ops a (snd h) with
      | false => asfs_map_get_id ops m' a
      | true => Some (fst h)
      end
  end.

(* We can use asfs_map_get_id for detecting if it is contained or not *)
(*Fixpoint asfs_map_contains (ops: opm) (m: asfs_map) (a: asfs_map_val): option bool :=
  match m with
  | nil => Some false
  | (k,v)::m' => 
      match asfs_map_val_eq ops a v with
      | None => None
      | Some false => asfs_map_contains ops m' a
      | Some true => Some true
      end
  end.*)
*)

Definition asfs_map_add (m: asfs_map) (id: nat) (a: asfs_map_val) : asfs_map :=
  (id, a)::m.
  
(*
Definition add_val_asfs (ops: opm) (a: asfs) (v: asfs_map_val) : option asfs :=
  let m   : asfs_map    := get_map_asfs a in
  let s   : asfs_stack  := get_stack_asfs a in
  let vin : option bool := asfs_map_contains ops m v in
  let vid : option nat  := asfs_map_get_id   ops m v in
  let mid : nat         := get_maxid_asfs a in
  match vin, vid with

    (* Value is in map, there is id *)
    (* (vid', s', m) *)
    | Some vin', Some vid' => 
        match push (FreshVar vid') s with None => None | Some s' =>
            Some (set_stack_asfs a s') end

    (* Value is not in map *)
    (* (maxid+1, s', m') *)
    | Some vin', None => 
        let m' : asfs_map := asfs_map_add m (mid+1) v in 
        match push (FreshVar (mid+1)) s with None => None | Some s' => 
            let a' : asfs := set_maxid_asfs a (mid+1) in
            Some (set_map_asfs a' m') end
  
    (* Owise *)
    | _, _ => None
  end.
*)  

(* simplification: always insert pair in asfs_map *)
Definition add_val_asfs (ops: opm) (a: asfs) (v: asfs_map_val) : option asfs :=
  let m   : asfs_map    := get_map_asfs a in
  let s   : asfs_stack  := get_stack_asfs a in
  let mid : nat         := get_maxid_asfs a in
  let m' : asfs_map     := asfs_map_add m mid v in 
  match push (FreshVar mid) s with 
  | None => None 
  | Some s' => Some (set_stack_asfs (set_map_asfs (set_maxid_asfs a (mid+1)) m') s')
  end.
(**)


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

Fixpoint symbolic_exec' (p: prog) (a: asfs) (ops: opm) : option asfs :=
  match p with
  | nil => Some a
  | ins::p' =>
      match symbolic_exec'' ins a ops with
      | None => None
      | Some a' => symbolic_exec' p' a' ops
      end
  end.

Definition symbolic_exec (p: prog) (height: nat) (ops: opm) : option asfs :=
  let a : asfs := empty_asfs height in 
  symbolic_exec' p a ops.

(* Symbolic Execution Tests *)

Example cs_0 : concrete_stack := [ 
  natToWord WLen 8;
  natToWord WLen 2;
  natToWord WLen 3
  ].

Example p_0 : prog := [
  PUSH 1 (natToWord WLen 5); 
  PUSH 1 (natToWord WLen 7); 
  PUSH 1 (natToWord WLen 7); 
  Opcode ADD;
  POP
].

Example  a_0 := match symbolic_exec p_0 3 opmap with None => empty_asfs 0 | Some a' => a' end.
Compute get_stack_asfs a_0.
Compute get_map_asfs a_0. 

Example cs_1 : concrete_stack := [ 
  natToWord WLen 1;
  natToWord WLen 2
  ].

Example p_1 : prog := [
  Opcode ADD;
  PUSH 1 (natToWord WLen 1); 
  PUSH 1 (natToWord WLen 2); 
  Opcode ADD
].

Example  a_1 := match symbolic_exec p_1 2 opmap with None => empty_asfs 0 | Some a' => a' end.
Compute get_stack_asfs a_1.
Compute get_map_asfs a_1. 


(* ENRIQUE:
   Explictitly unfolded the code for evaluating lists of ASFSOp arguments in order to avoid mutually
   recursive functions (one for one asfs_stack_val, the other for lists of asfs_stack_val) whose 
   definition would require Program Fixpoint with a lexicographically decreasing (map size, list size)
   that impose well-founded proof obligations and that complicates other proofs 
   [I dont't know how to simplify or rewrite a call to a Program Fixpoint] 
   Moreover, "Program Fixpoint" in mutually recursive definitions does not seem to be supported, although
   the Coq documentation says the opposite.
   *)
Fixpoint eval_asfs2_elem (c: concrete_stack) (elem: asfs_stack_val) (m: asfs_map) (ops: opm) : option EVMWord :=
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
                                 match args with
                                 | nil => func [] (* Operator without operands, call with empty list *)
                                 | [a1] => match eval_asfs2_elem c a1 rm ops with
                                           | Some v1 => func [v1]
                                           | None => None
                                           end
                                 | [a1;a2] => match eval_asfs2_elem c a1 rm ops, 
                                                    eval_asfs2_elem c a2 rm ops with
                                           | Some v1, Some v2 => func [v1; v2]
                                           | _, _ => None
                                           end
                                 | _ => None (* We do not consider operators with 3 or more arguments in our set of instructions *)
                                 end
                               else None
                           end
                      end
                    else eval_asfs2_elem c elem rm ops
     end
end.

Fixpoint eval_asfs2 (c: concrete_stack) (s: asfs_stack) (m: asfs_map) (ops: opm) : option (list EVMWord) :=
match s with 
| nil => Some []
| elem::rs => let elem_oval := eval_asfs2_elem c elem m ops in
              let rs_oval := eval_asfs2 c rs m ops in
              match (elem_oval, rs_oval) with 
              | (Some elem_val, Some rs_val) => Some (elem_val::rs_val)
              | _ => None
              end
end.

Definition eval_asfs (c: concrete_stack) (s: asfs) (ops: opm) : option (list EVMWord) :=
match s with
| ASFSc height maxid curr_stack amap => 
    if List.length c =? height then
      eval_asfs2 c curr_stack amap ops
    else
      None (* evalution cannot succeed if the given stack has a different size to the expected one *)
end.


Example test_eval_asfs_1:
let asfs := ASFSc 2 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 0; InStackVar 1])] in
let stack := [(natToWord WLen 5); (natToWord WLen 7)] in
eval_asfs stack asfs opmap = Some [wnot (natToWord WLen 12)].
Proof.
reflexivity. Qed.
Example test_eval_asfs_2:
let asfs := ASFSc 2 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 0; InStackVar 1])] in
let stack := [(natToWord WLen 8); (natToWord WLen 3)] in
eval_asfs stack asfs opmap = Some [wnot (natToWord WLen 11)].
Proof.
reflexivity. Qed.
Example test_eval_asfs_3:
let asfs := ASFSc 2 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 0; InStackVar 1])] in
let stack := [(natToWord WLen 2); (natToWord WLen 0)] in
eval_asfs stack asfs opmap = Some [wnot (natToWord WLen 2)].
Proof.
reflexivity. Qed.
Example test_eval_asfs_4:
let asfs := ASFSc 2 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 0; InStackVar 1])] in
let stack := [(natToWord WLen 0); (natToWord WLen 7)] in
eval_asfs stack asfs opmap = Some [wnot (natToWord WLen 7)].
Proof. reflexivity. Qed.


Lemma concr_abs_stack_same_length: forall (in_stk curr_stk: concrete_stack) (curr_asfs: asfs)
        (ops: opm) (curr_es: execution_state),
eval_asfs in_stk curr_asfs ops = Some curr_stk ->
get_stack_es curr_es = curr_stk ->
length (get_stack_es curr_es) = length (get_stack_asfs curr_asfs).
Proof.
Admitted.

Lemma set_get_stack_es: forall (es: execution_state) (stk: concrete_stack),
get_stack_es (set_stack_es es stk) = stk.
Proof.
intros es stk. unfold set_stack_es. destruct es.
reflexivity.
Qed.

Lemma eval_eq_stack_len: forall (in_stk out_stk: concrete_stack) (height hc maxid: nat) (abs: asfs_stack)
  (map: asfs_map) (ops: opm),
length in_stk = height -> 
eval_asfs in_stk (ASFSc hc maxid abs map) ops = Some out_stk ->
height = hc.
Proof.
Admitted.

Lemma eval_const_val: forall (stk: concrete_stack) (w: EVMWord) (map: asfs_map) (ops: opm),
eval_asfs2_elem stk (Val w) map ops = Some w.
Proof.
intros stk w map ops.
Admitted.


Lemma height_stack_eval: forall (in_stk curr_stk: concrete_stack) (h mx: nat) 
      (abs: asfs_stack) (map: asfs_map) (ops: opm),
eval_asfs in_stk (ASFSc h mx abs map) ops = Some curr_stk ->
length abs = length curr_stk.
Proof.
Admitted.

Lemma same_length_firstn_e: forall (T1 T2: Type) (n: nat) (l1 res1: list T1) (l2: list T2),
firstn_e n l1 = Some res1 ->
length l1 = length l2 ->
exists (res2: list T2), firstn_e n l2 = Some res2.
Proof.
intros T1 T2 n l1 res1 l2 HeqLen.
Admitted.

Lemma same_length_skip_e: forall (T1 T2: Type) (n: nat) (l1 res1: list T1) (l2: list T2),
skipn_e n l1 = Some res1 ->
length l1 = length l2 ->
exists (res2: list T2), skipn_e n l2 = Some res2.
Proof.
intros T1 T2 n l1 res1 l2 HeqLen.
Admitted.

Lemma push_succeed: forall (T: Type) (e: T) (l1 l2: list T),
push e l1 = Some l2 -> l2 = e::l1.
Admitted.


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
Admitted.


Lemma eval_asfs2_compositional: forall (in_stk curr_stk args insk': concrete_stack) 
  (stkc s1 s2: asfs_stack) (mapc: asfs_map) (ops: opm),
eval_asfs2 in_stk stkc mapc ops = Some curr_stk ->
stkc = s1 ++ s2 ->
curr_stk = args ++ insk' ->
length s1 = length args ->
eval_asfs2 in_stk s1 mapc ops = Some args /\ eval_asfs2 in_stk s2 mapc ops = Some insk'.
Proof.
Admitted.

Fixpoint fresh_var_not_in_map (idx: nat) (map: asfs_map) : bool :=
match map with 
| nil => true
| (k,v)::t => if k =? idx then false else fresh_var_not_in_map idx t
end.

Definition valid_asfs (sfs: asfs) : bool :=
match sfs with 
| ASFSc height maxid s m => fresh_var_not_in_map maxid m
end.

(* ++++++++++++++This is the important one+++++++++++++ *)
Lemma eval_asfs2_extended_map: forall (in_stk curr_stk: concrete_stack) (s: asfs_stack) (map: asfs_map)
  (ops: opm) (n: nat) (val: asfs_map_val),
eval_asfs2 in_stk s map ops = Some curr_stk ->
fresh_var_not_in_map n map = true ->
eval_asfs2 in_stk s ((n, val)::map) ops = Some curr_stk.
Proof.
Admitted.


(* This function should check that all the operands in ops have nbargs <= 2*)
(* I GUESS WE NEED TO CHANGE THE TYPE OF opm TO SOMETHING CONSTRUCTED (V.G. LISTS) *)
Definition is_coherent_ops_nbargs (ops: opm) : bool :=
true.

Lemma coherent_ops_nbargs_lt3: forall (ops: opm) (instr: gen_instr) (comm:bool) (nb_args: nat)
  (func: list EVMWord -> option EVMWord),
is_coherent_ops_nbargs ops = true ->
ops instr = Some (Op comm nb_args func) ->
nb_args < 3.
Proof.
Admitted.

Lemma length_gt3: forall (T: Type) (a1 a2 a3: T) (l: list T),
~ (length (a1::a2::a3::l)) < 3.
Proof.
Admitted.


(* Main lemma that relates curr_asfs to out_asfs in the case of executing an operator. 
   It relates their asfs_stacks and the results of their evaluation *)
Lemma opcode_exec_asfs_update: forall (ops: opm) (OpCode: gen_instr) (comm_flag: bool)
  (nb_args hec maxc heo maxo: nat) (func: list EVMWord -> option EVMWord) (curr_es: execution_state)
  (args insk' in_stk curr_stk: list EVMWord) (v: EVMWord) (curr_asfs out_asfs: asfs) (stkc stko s1 s2: asfs_stack)
  (mapc mapo: asfs_map),

is_coherent_ops_nbargs ops = true ->
valid_asfs curr_asfs = true ->
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
  curr_asfs out_asfs stkc stko s1 s2 mapc mapo Hops_coherent Hvalid_asfs Hcurrstk Hops Hfirstn_curr_es 
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
            destruct s1 as [|a1 t1] eqn: eq_s1.
            ** simpl in eq_length_s1. rewrite <- eq_length_s1 in eq_length_args.
               apply length_zero_iff_nil in eq_length_args.
               rewrite -> eq_length_args in Hfunc.
               assumption.
            ** destruct t1 as [|a2 t2] eqn: eq_t1.
            --- simpl in Heval_asfs2_s1. 
                destruct (eval_asfs2_elem in_stk a1 mapc ops) as [elem_val1|] eqn: eq_eval_a1;
                  try discriminate.
                injection Heval_asfs2_s1. intros eq_args_elem_val.
                rewrite <- eq_args_elem_val in Hfunc.
                assumption.
            --- destruct t2 as [|a3 l3] eqn: eq_t2.
               +++ destruct (eval_asfs2_elem in_stk a1 mapc ops) as [elem_val1|] eqn: eq_eval_a1.
                   *** destruct (eval_asfs2_elem in_stk a2 mapc ops) as [elem_val2|] eqn: eq_eval_a2.
                       ---- unfold eval_asfs2 in Heval_asfs2_s1.
                            rewrite -> eq_eval_a1 in Heval_asfs2_s1.
                            rewrite -> eq_eval_a2 in Heval_asfs2_s1. 
                            injection Heval_asfs2_s1. intros eq_args_a1_a2.
                            rewrite <- eq_args_a1_a2 in Hfunc.
                            assumption.
                       ---- unfold eval_asfs2 in Heval_asfs2_s1.
                            rewrite -> eq_eval_a1 in Heval_asfs2_s1.
                            rewrite -> eq_eval_a2 in Heval_asfs2_s1.
                            discriminate.
                   *** unfold eval_asfs2 in Heval_asfs2_s1.
                       rewrite -> eq_eval_a1 in Heval_asfs2_s1.
                       discriminate.
               +++ pose proof (coherent_ops_nbargs_lt3 ops OpCode comm_flag nb_args
                     func Hops_coherent Hops) as eq_nbargs_lt3. 
                   pose proof (length_gt3 asfs_stack_val a1 a2 a3 l3) as eq_nbargs_ge3.
                   rewrite -> eq_length_s1 in eq_nbargs_ge3. 
                   contradiction.
         ++ rewrite -> Hmapo.
            pose proof (eval_asfs2_extended_map in_stk insk' s2 mapc ops maxc (ASFSOp OpCode s1)
              Heval_asfs2_s2 Hvalid_asfs) as eq_eval_asfs2_s2_mapo.
            assumption.
Qed.


(* One step of execution with one instruction *)
Theorem correctness_symb_exec_step: forall (instruction: instr) (in_stk curr_stk out_stk: concrete_stack) (ops:opm)
          (height: nat) (curr_es out_es: execution_state) (curr_asfs out_asfs: asfs),
is_coherent_ops_nbargs ops = true ->
valid_asfs curr_asfs = true ->
length in_stk = height ->
eval_asfs in_stk curr_asfs ops = Some curr_stk ->
get_stack_es curr_es = curr_stk ->
concr_intpreter_instr instruction curr_es ops = Some out_es ->
get_stack_es out_es = out_stk ->
symbolic_exec'' instruction curr_asfs ops = Some out_asfs ->
eval_asfs in_stk out_asfs ops = Some out_stk.
Proof.
intros instruction in_stk curr_stk out_stk ops height curr_es out_es curr_asfs out_asfs
  Hcoherent_ops Hvalid_asfs HLen Hevalcurr Hes_curr Hconcr Hes_out Hsymbexec.
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
  rewrite -> eval_const_val.
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
  destruct curr_stk eqn: eq_curr_stk; try discriminate.
  unfold eval_asfs in Hevalcurr.
  destruct curr_asfs as [h mx curr_stack curr_map] eqn: eq_curr_asfs.
  rewrite -> HLen in Hevalcurr.
  destruct (height =? h) eqn: eq_height_h; try discriminate.
  simpl in eq_pop_asfs.
  destruct curr_stack as [| poped t] eqn: eq_curr_stack; try discriminate.
  simpl. rewrite -> HLen.
  rewrite -> eq_height_h.
  unfold eval_asfs2 in Hevalcurr.
  destruct (eval_asfs2_elem in_stk poped curr_map ops) eqn: eq_eval_asfs2_elem; try discriminate.
  fold eval_asfs2 in Hevalcurr.
  injection eq_pop_asfs. intros eq_t_s'. rewrite <- eq_t_s'.
  destruct (eval_asfs2 in_stk t curr_map ops) eqn: eval_asfs2_t; try discriminate.
  injection Hevalcurr. intros eq_l_c _.
  rewrite -> eq_l_c. rewrite <- Hes_out. 
  injection eq_pop_w. intros eq_c_sk'. rewrite <- eq_c_sk'.
  reflexivity.
- (* DUP *)
  admit.
- (* SWAP *)
  admit.
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
      mapc mapo Hcoherent_ops Hvalid_asfs Hes_curr eq_ops_label eq_firstn_stk eq_skipn_stk eq_func_args eq_curr_asfs
      Hevalcurr eq_firstn_asfs eq_skipn_asfs Hsymbexec eq_out_asfs) 
      as [eq_stkc [eq_hec_heo [top_elem [eq_stko [eq_eval_top_elem eq_eval_s2]]]]].
    unfold eval_asfs. rewrite <- eq_hec_heo. rewrite -> eq_len_in_stk.
    rewrite -> eq_stko. unfold eval_asfs2.
    rewrite -> eq_eval_top_elem. fold eval_asfs2.
    rewrite -> eq_eval_s2.
    reflexivity.
Admitted.




(* A complete program*)
Theorem correctness_symb_exec: forall (p: prog) (in_stk out_stk: concrete_stack) (ops:opm)
          (height: nat) (in_es out_es: execution_state) (out_asfs: asfs),
length in_stk = height ->
get_stack_es in_es = in_stk ->
concr_interpreter p in_es ops = Some out_es ->
get_stack_es out_es = out_stk ->
symbolic_exec p height ops = Some out_asfs ->
eval_asfs in_stk out_asfs ops = Some out_stk.
Proof.
Admitted.

(*


\forall opcode:instr, instk:list EVMword, currstk:list EVMword, ops: opm, height : nat, out_sfs, in_sfs : asfs

  length instk = height,
  eval_asfs instk in_sfs opm = Some currstk,
  conc_exec' opcode curr ops = Some out_stk,
  sym_exec' opcode in_sfs ops = Some out_asfs
 
  ->
 
  eval_asfs instk out_sfs opm = Some out_stk


\forall p:prog, instk:list EVMword, ops: opm, height : nat, out_sfs : asfs

  length instk = height,
  conc_exec p instk ops = Some out_stk,
  sym_exec height p ops = Some out_asfs 
  -> 
  eval_asfs instk out_asfs opm = Some out_stk

*)

Require Import Program.Wf.
(* Overkill: 22 obligations remaining!!! *)
Program Fixpoint asfs_eq_stack_elem (e1 e2: asfs_stack_val) (m1 m2: asfs_map) 
  {measure (List.length m1 + List.length m2)} : bool :=
match e1, e2 with 
| Val v1, Val v2 => weqb v1 v2
| InStackVar i1, InStackVar i2 => i1 =? i2
| FreshVar i1, FreshVar i2 => 
    match m1, m2 with 
    | (idx1, mv1)::rm1, (idx2, mv2)::rm2 => 
        if (idx1 =? i1) && (idx2 =? i2) then
          match mv1, mv2 with 
          | ASFSBasicVal av1, ASFSBasicVal av2 => asfs_eq_stack_elem av1 av2 rm1 rm2
          | ASFSOp opcode1 args1, ASFSOp opcode2 args2 => 
              if eq_gen_instr opcode1 opcode2 then 
                match args1, args2 with 
                | [], [] => true
                | [a1], [b1] => asfs_eq_stack_elem a1 b1 rm1 rm2
                | [a1;a2], [b1;b2] => (asfs_eq_stack_elem a1 b1 rm1 rm2) &&
                                      (asfs_eq_stack_elem a2 b2 rm1 rm2)
                | _, _  => false
                end
              else false
          | _, _ => false
          end
        else if idx1 =? i1 then
          asfs_eq_stack_elem e1 e2 m1 rm2
        else if idx2 =? i2 then
          asfs_eq_stack_elem e1 e2 rm1 m2
        else false
    | _, _ => false
    end
|_, _ => false
end.
Admit Obligations.

(* 
Alternative definition for asfs_eq_stack_elem:
1) Generate *nested* AST representation (asfs_val_nest) by replacing fresh variables:
    - Value
    - InStackVar nat
    - Op opcode [asfs_val_nest]
2) Compare both ASTs now without the map, so there is a clear syntactically 
   decreasing argument
*)





Fixpoint asfs_eq_stack (s1 s2: asfs_stack) (m1 m2: asfs_map) : bool :=
match s1, s2 with 
| nil, nil => true
| e1::r1, e2::r2 => (asfs_eq_stack_elem e1 e2 m1 m2) && (asfs_eq_stack r1 r2 m1 m2)
| _, _ => false
end.


Definition asfs_eq (a1 a2: asfs) : bool :=
match a1, a2 with
| ASFSc height1 maxid1 curr_stack1 amap1, ASFSc height2 maxid2 curr_stack2 amap2 => 
    let eq_size := height1 =? height2 in
    let eq_stack := asfs_eq_stack curr_stack1 curr_stack2 amap1 amap2 in
    eq_size && eq_stack
end.

Example test_eval_asfs_eq_1:
let asfs := ASFSc 2 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 0; InStackVar 1])] in
asfs_eq asfs asfs = true.
Proof.
reflexivity. Qed.
Example test_eval_asfs_eq_2:
let asfs1 := ASFSc 2 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 0; InStackVar 1])] in
let asfs2 := ASFSc 3 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 0; InStackVar 1])] in
asfs_eq asfs1 asfs2 = false.
Proof.
reflexivity. Qed.
Example test_eval_asfs_eq_3:
let asfs1 := ASFSc 2 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 0; InStackVar 1])] in
let asfs2 := ASFSc 2 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 1; InStackVar 0])] in
asfs_eq asfs1 asfs2 = false.
Proof.
reflexivity. Qed.

End SFS.






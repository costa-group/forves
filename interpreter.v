Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import List.
Require Import Program.Wf.
(*Require Import Coq_EVM.lib.evmModel.*)
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

(*
Definition concrete_to_asfs' (v: EVMWord) : asfs_stack_val := Val v.
Definition concrete_to_asfs  (s: list EVMWord) : asfs_stack := List.map concrete_to_asfs' s.
*)
(*Fixpoint gen_initial_stack_inv {T: Type} (size: nat) (f: nat -> T): list T :=
  match size with
  | 0 => nil
  | S n => (f n)::(gen_initial_stack_inv n f)
  end.
*)  

Definition gen_initial_stack (size: nat): list asfs_stack_val :=
  let ids := seq 0 size in
  List.map InStackVar ids.

Definition empty_asfs (size: nat) : asfs :=
  let s := gen_initial_stack size in
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


(* Try 1: eval_asfs2_elem_list has recursive calls with smaller maps but one call with the same map
          and a smaller list. Coq cannot detect decreasing argument because there is not one single 
          decreasing argument.
          The lexicographic decreasing element is de pair (length m, length l), that requires well_founded
          and generates one proof obligation:

well_founded
  (MR lex_let_nat_pair
     (fun
        recarg : {_ : concrete_stack &
                 {_ : asfs_stack &
                 {_ : asfs_map & opm}}} =>
      (length
         (projT1 (projT2 (projT2 recarg))),
      length (projT1 (projT2 recarg)))))          

*)


(* Try 2: 
  a) mutually recursive definition for eval_asfs2_elem and eval_asfs2 with the hint that
     m is the decreasing argument ({struct m}) -> <<Recursive call to eval_asfs2_elem 
     has principal argument equal to "m0" instead of "rm">>.
     
  b) mutually recursive definition for eval_asfs2_elem and eval_asfs2 with the measure
     (lenght m) as well-founded measure -> 5 proof obligations where I guess some of them
     cannot be proved, for example the one for "length m < length m0"
     
  c) mutually recursive definition for eval_asfs2_elem and eval_asfs2 with the lexicographic 
     measure (length m, length s) -> "s" cannot be used because is the argument of the 
     inner eval_asfs2_elem_list recursive function
*)

(* Solution: 1) HO function to apply 'f' to a list of asfs_stack_val 
             2) use the HO function in the definition of the function that evaluates one value
*)
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

Fixpoint eval_asfs2_elem (c: concrete_stack) (elem: asfs_stack_val) (m: asfs_map) (ops: opm) 
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
Definition eval_asfs2 (c: concrete_stack) (s: asfs_stack) (m: asfs_map) (ops: opm) : option (list EVMWord) :=
let f_eval_list := fun (elem': asfs_stack_val) => eval_asfs2_elem c elem' m ops in
apply_f_list_asfs_stack_val f_eval_list s.


(* Trivial but useful for proofs *)
Lemma eval_asfs2_ho: forall (c: concrete_stack) (s: asfs_stack) (m: asfs_map) (ops: opm),
apply_f_list_asfs_stack_val (fun (elem': asfs_stack_val) => eval_asfs2_elem c elem' m ops) s = 
eval_asfs2 c s m ops.
Proof. reflexivity. Qed.



Definition eval_asfs (c: concrete_stack) (s: asfs) (ops: opm) : option (concrete_stack) :=
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


Lemma concr_abs_stack_same_length_eval_asfs2: forall (in_stk curr_stk: concrete_stack) 
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


Lemma concr_abs_stack_same_length: forall (in_stk curr_stk: concrete_stack) (curr_asfs: asfs)
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
intros in_stk out_stk height hc maxid abs map ops Hlen Heval.
unfold eval_asfs in Heval.
destruct (length in_stk =? hc) eqn: eq_len_hc; try discriminate.
symmetry in eq_len_hc.
apply beq_nat_eq in eq_len_hc.
rewrite -> Hlen in eq_len_hc.
assumption.
Qed.


Lemma eval_const_val: forall (stk: concrete_stack) (w: EVMWord) (map: asfs_map) (ops: opm),
eval_asfs2_elem stk (Val w) map ops = Some w.
Proof.
intros stk w map ops. unfold eval_asfs2_elem.
destruct map eqn: eq_m; try reflexivity.
(* unneeded unfolding, required by Coq to simplify because the map is the
   decreasing argument *)
Qed.


Lemma height_stack_eval: forall (in_stk curr_stk: concrete_stack) (h mx: nat) 
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

Lemma push_succeed: forall (T: Type) (e: T) (l1 l2: list T),
push e l1 = Some l2 -> l2 = e::l1.
Proof.
intros T e l1 l2 Hpush.
unfold push in Hpush.
destruct (length l1 <? StackLen); try discriminate.
symmetry in Hpush. injection Hpush.
trivial.
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

Lemma eval_asfs2_compositional: forall (in_stk curr_stk args insk': concrete_stack) 
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

Lemma eval_asfs2_compositional_r: forall (in_stk curr_s1 curr_s2: concrete_stack) 
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


Lemma eval_asfs2_compositional4: forall (in_stk curr_stk v1 v2 v3 v4: concrete_stack) 
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

Fixpoint fresh_var_gt_map (idx: nat) (map: asfs_map) : bool :=
match map with 
| nil => true
| (k,v)::t => if idx <=? k then false else fresh_var_gt_map idx t
end.

Definition valid_asfs (sfs: asfs) : bool :=
match sfs with 
| ASFSc height maxid s m => fresh_var_gt_map maxid m
end.

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
    (c: concrete_stack) (elem: nat) 
    (m: asfs_map) (ops: opm) (w : EVMWord) (n: nat),
eval_asfs2_elem c (FreshVar elem) m ops = Some w ->
fresh_var_gt_map n m = true ->
n =? elem = false.
Proof.
  intros.
  induction m as [|x xs IH].
  - discriminate H.
  - simpl in H. simpl in H0.
    destruct x.
    + destruct (n0 =? elem) eqn:H1.
      ++ destruct (n <=? n0) eqn:H2.
         * discriminate H0.
         * apply gt_neq. apply beq_nat_true in H1. rewrite H1 in H2. apply H2.
           ++ destruct (n <=? n0) eqn:H2.
         * discriminate H0.
         * apply IH.
           ** apply H.
           ** apply H0.
Qed.           

    
Lemma eval_asfs2_elem_extended_map: forall
    (c: concrete_stack) (elem: asfs_stack_val) (m: asfs_map) (ops: opm) (w : EVMWord) (n: nat) (val: asfs_map_val),
eval_asfs2_elem c elem m ops = Some w ->
fresh_var_gt_map n m = true ->
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

(* ++++++++++++++This is the important one+++++++++++++ *)
Lemma eval_asfs2_extended_map: forall (in_stk curr_stk: concrete_stack) (s: asfs_stack) (map: asfs_map)
  (ops: opm) (n: nat) (val: asfs_map_val),
eval_asfs2 in_stk s map ops = Some curr_stk ->
fresh_var_gt_map n map = true ->
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
Lemma opcode_exec_asfs_update: forall (ops: opm) (OpCode: gen_instr) (comm_flag: bool)
  (nb_args hec maxc heo maxo: nat) (func: list EVMWord -> option EVMWord) (curr_es: execution_state)
  (args insk' in_stk curr_stk: list EVMWord) (v: EVMWord) (curr_asfs out_asfs: asfs) (stkc stko s1 s2: asfs_stack)
  (mapc mapo: asfs_map),

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
            pose proof (eval_asfs2_extended_map in_stk insk' s2 mapc ops maxc (ASFSOp OpCode s1)
              Heval_asfs2_s2 Hvalid_asfs) as eq_eval_asfs2_s2_mapo.
            assumption.
Qed.


Lemma eval_asfs2_position': forall (in_stk curr_stk: concrete_stack) (pos: nat)
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

Lemma eval_asfs2_position: forall (in_stk curr_stk: concrete_stack) (hc maxc pos: nat)
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
Theorem correctness_symb_exec_step: forall (instruction: instr) (in_stk curr_stk out_stk: concrete_stack) (ops:opm)
          (height: nat) (curr_es out_es: execution_state) (curr_asfs out_asfs: asfs),
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
    destruct (nth_error sc pos) eqn: eq_nth_error_sc; try discriminate.
    injection eq_dup_pos_sc. intros eq_s'. symmetry in eq_s'.
    rewrite -> eq_s'.
    unfold dup in eq_dup_pos_curr_stk.
    pose proof (height_stack_eval in_stk curr_stk hc maxc sc mc ops
    Hevalcurr) as eq_length_sc_curr_stk.
    rewrite <- eq_length_sc_curr_stk in eq_dup_pos_curr_stk.
    rewrite -> eq_cond_push in eq_dup_pos_curr_stk.
    destruct (nth_error curr_stk pos) as [x|] eqn: eq_nth_error_curr_stk;
      try discriminate.
    injection eq_dup_pos_curr_stk. intros eq_sk'. symmetry in eq_sk'.
    rewrite -> eq_sk'.
    unfold eval_asfs2. unfold apply_f_list_asfs_stack_val.
    fold apply_f_list_asfs_stack_val.
    pose proof (eval_asfs2_position in_stk curr_stk hc maxc pos sc mc
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

Lemma fresh_var_gt_succ: forall (maxc: nat) (mc: asfs_map),
fresh_var_gt_map maxc mc = true ->
fresh_var_gt_map (S maxc) mc = true.
Proof.
intros maxc mc. revert maxc.
induction mc as [|h t IH].
- intuition.
- intros maxc Hfresh_var_gt_h_t.
  unfold fresh_var_gt_map in Hfresh_var_gt_h_t.
  destruct h as [k v] eqn: eq_h.
  destruct (maxc <=? k) eqn: eq_maxc_leq_k; try discriminate.
  fold (fresh_var_gt_map maxc t) in Hfresh_var_gt_h_t.
  unfold fresh_var_gt_map.
  pose proof (leb_complete_conv k maxc eq_maxc_leq_k) as k_lt_maxc.
  pose proof (Nat.lt_lt_succ_r k maxc k_lt_maxc) as k_lt_succ_maxc.
  pose proof (leb_correct_conv k (S maxc) k_lt_succ_maxc) as k_succ_maxc_false.
  rewrite -> k_succ_maxc_false.
  fold fresh_var_gt_map.
  apply IH.
  assumption.
Qed.

(* Joseba will need it for the IH, as well as the proof that the initial
   asfs is valid by construction [the map is empty] *)
Lemma valid_asfs_preservation: forall (curr_asfs out_asfs: asfs) (instruction: instr) (ops: opm),
valid_asfs curr_asfs = true ->
symbolic_exec'' instruction curr_asfs ops = Some out_asfs ->
valid_asfs out_asfs = true.
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
  rewrite -> Sn_not_lte_n.
  fold fresh_var_gt_map.
  apply fresh_var_gt_succ.
  assumption.
Qed.


Lemma get_stack_es_ok: forall (stk: concrete_stack) (memory: tmemory)
  (storage: tstorage),
get_stack_es ((ExState stk memory storage)) = stk.
Proof.
reflexivity.
Qed.

Lemma correctness_symb_exec_gen: forall (curr_asfs out_asfs: asfs) 
  (in_stk curr_stk out_stk: concrete_stack) (height: nat) (ops: opm) 
  (curr_es out_es: execution_state) (p: prog),
valid_asfs curr_asfs = true ->
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
valid_asfs (empty_asfs n) = true.
Proof.
intros n.
unfold valid_asfs. unfold empty_asfs.
reflexivity.
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

Search (skipn (S _)).

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
Lemma empty_skip_eval: forall (i n: nat) (stk: concrete_stack) (ops: opm),
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

Search (_ <= 0).

Lemma empty_skip_eval_zero: forall (i n: nat) (stk: concrete_stack) (ops: opm),
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

Lemma empty_asfs_concr_stk: forall (n: nat) (stk: concrete_stack) (ops: opm),
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


(* A complete program*)
Theorem correctness_symb_exec: forall (p: prog) (in_stk out_stk: concrete_stack)
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


(*

- We should support commutativity -> require passing the opm
- Handle any number of arguments, woth a specific case for 2 args
- Add a theorem SFS_EQIV

    if asfs1 is equiv to asfs2, then for any concrete stack
    'stk', eval_asfs stk asfs1 opm =  eval_asfs stk asfs2 opm

- The main theorem

  for program P1, P2, height, in_stk, opm

  length in_stk = height
  asfs1 is symblic execution of P1 with height, opm
  asfs2 is symblic execution of P2 with height, opm
  SFS_EQIV(asfs1,asfs2)
  -> conc_exec in_stk P1 opm = conc_exec in_stk P2 opm

*)

(*
// + a1 b1 , + a2 b2

//   -> [ [[a1,a2],[b1,b2]], [[a1,b2],[b1,b2]] ]

//   -> [ [[a1,a2],[b1,b2]] ]
*)

Definition is_comm_op (opcode: gen_instr) (ops: opm) : bool :=
  match (ops opcode) with
  | Some (Op true _ _) => true
  | _ => false
  end.
  
 
Fixpoint flat_stack_elem (e: asfs_stack_val) (m: asfs_map)
  {struct m} : option flat_asfs_map_val :=
match e with
| Val v => Some (FASFSBasicVal (Val v))
| InStackVar n => Some (FASFSBasicVal (InStackVar n))
| FreshVar n => 
    match m with 
    | (idx, mv)::rm => 
         if idx =? n then
         match mv with
             | ASFSBasicVal (Val v) => Some (FASFSBasicVal (Val v))
             | ASFSBasicVal (InStackVar n) => Some (FASFSBasicVal (InStackVar n))
             | ASFSBasicVal (FreshVar n) => flat_stack_elem (FreshVar n) rm
             | ASFSOp opcode [arg] => match flat_stack_elem arg rm with
                 | Some farg => Some (FASFSOp opcode [farg])
                 | _ => None
                 end
             | ASFSOp opcode [arg1; arg2] => 
                 match (flat_stack_elem arg1 rm,
                        flat_stack_elem arg1 rm) with
                 | (Some farg1, Some farg2) => Some (FASFSOp opcode [farg1; farg2])
                 | _ => None
                 end
             | _ => None
             end
        else flat_stack_elem e rm
    | _ => None
    end
end.

Fixpoint compare_flat_asfs_map_val (e1 e2: flat_asfs_map_val) (ops: opm): bool :=
match (e1, e2) with
| (FASFSBasicVal (Val v1), FASFSBasicVal (Val v2)) => weqb v1 v2
| (FASFSBasicVal (InStackVar v1), FASFSBasicVal (InStackVar v2)) => v1 =? v2
| (FASFSOp opcode1 [farg1], FASFSOp opcode2 [farg2]) => 
      (eq_gen_instr opcode1 opcode2) && (compare_flat_asfs_map_val farg1 farg2 ops)
| (FASFSOp opcode1 [farg11;farg12], FASFSOp opcode2 [farg21; farg22]) => 
      (eq_gen_instr opcode1 opcode2) && (compare_flat_asfs_map_val farg11 farg21 ops)
      && (compare_flat_asfs_map_val farg12 farg22 ops)
  (* TODO add commutativity check *)
| _ => false
end.


Definition asfs_eq_stack_elem (e1 e2: asfs_stack_val) (m1 m2: asfs_map) 
  (ops: opm) : bool :=
match (flat_stack_elem e1 m1, flat_stack_elem e2 m2) with
| (Some fe1, Some fe2) => compare_flat_asfs_map_val fe1 fe2 ops
| _ => false
end.

(*
(* Overkill: 22 obligations remaining!!! *)
Program Fixpoint asfs_eq_stack_elem (e1 e2: asfs_stack_val) (m1 m2: asfs_map) 
  (ops: opm) {measure (List.length m1 + List.length m2)} : bool :=
match e1, e2 with 
| Val v1, Val v2 => weqb v1 v2
| InStackVar i1, InStackVar i2 => i1 =? i2
| FreshVar i1, FreshVar i2 => 
    match m1, m2 with 
    | (idx1, mv1)::rm1, (idx2, mv2)::rm2 => 
        if (idx1 =? i1) && (idx2 =? i2) then
          match mv1, mv2 with 
          | ASFSBasicVal av1, ASFSBasicVal av2 => asfs_eq_stack_elem av1 av2 rm1 rm2 ops
          | ASFSOp opcode1 args1, ASFSOp opcode2 args2 => 
              if eq_gen_instr opcode1 opcode2 then 
                match args1, args2 with 
                | [], [] => true
                | [a1], [b1] => asfs_eq_stack_elem a1 b1 rm1 rm2 ops
                | [a1;a2], [b1;b2] =>
                    ((asfs_eq_stack_elem a1 b1 rm1 rm2 ops) && (asfs_eq_stack_elem a2 b2 rm1 rm2 ops) ) ||
                    ( (is_comm_op opcode1 ops) && (asfs_eq_stack_elem a1 b2 rm1 rm2 ops) && (asfs_eq_stack_elem a2 b1 rm1 rm2 ops))
                | _, _  => false
                end
              else false
          | _, _ => false
          end
        else if idx1 =? i1 then
          asfs_eq_stack_elem e1 e2 m1 rm2 ops
        else if idx2 =? i2 then
          asfs_eq_stack_elem e1 e2 rm1 m2 ops
        else false
    | _, _ => false
    end
|_, _ => false
end.

(* Proof od obligations *)
Lemma length_s: forall (X: Type) (l : list X) (x : X),
    length (x::l) = S (length l).
Proof.
  intros. simpl. reflexivity.
Qed.


Lemma plus_s: forall (a b : nat),
    S a + S b = S (S a + b).
Proof.
  intros.
  rewrite <- plus_n_Sm.
  reflexivity. 
Qed.

Lemma a_lt_SSa: forall (a : nat), a < S (S a).
Proof.
  intros.
  apply le_lt_n_Sm.
  apply Nat.le_succ_diag_r.
Qed.

Next Obligation.
  rewrite -> length_s. rewrite -> length_s.
  rewrite -> plus_s.   rewrite -> plus_Sn_m.
  simpl. apply a_lt_SSa.
Qed.

Next Obligation.
  rewrite -> length_s. rewrite -> length_s.
  rewrite -> plus_s.   rewrite -> plus_Sn_m.
  simpl. apply a_lt_SSa.
Qed.

Next Obligation.
  rewrite -> length_s. rewrite -> length_s.
  rewrite -> plus_s.   rewrite -> plus_Sn_m.
  simpl. apply a_lt_SSa.
Qed.

Next Obligation.
  rewrite -> length_s. rewrite -> length_s.
  rewrite -> plus_s.   rewrite -> plus_Sn_m.
  simpl. apply a_lt_SSa.
Qed.

Next Obligation.
  rewrite -> length_s. rewrite -> length_s.
  rewrite -> plus_s.   rewrite -> plus_Sn_m.
  simpl. apply a_lt_SSa.
Qed.

Next Obligation.
  rewrite -> length_s. rewrite -> length_s.
  rewrite -> plus_s.   rewrite -> plus_Sn_m.
  simpl. apply a_lt_SSa.
Qed.

Next Obligation.
  intuition; try discriminate.
Qed.

Next Obligation.
  intuition; try discriminate.
Qed.

Next Obligation.
  intuition; try discriminate.
Qed.
Next Obligation.
  intuition; try discriminate.
Qed.

Next Obligation.
  intuition; try discriminate.
Qed.

Next Obligation.
  intuition; try discriminate.
Qed.

Next Obligation.
  intuition; try discriminate.
Qed.

Next Obligation.
  intuition; try discriminate.
Qed.

Next Obligation.
  intuition; try discriminate.
Qed.

Next Obligation.
  intuition; try discriminate.
Qed.

Next Obligation.
  intuition; try discriminate.
Qed.

Next Obligation.
  intuition; try discriminate.
Qed.
Next Obligation.
  intuition; try discriminate.
Qed.

Next Obligation.
  intuition; try discriminate.
Qed.
Next Obligation.
  intuition; try discriminate.
Qed.

Next Obligation.
  intuition; try discriminate.
Qed.
*)



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

Example test_eval_asfs_eq_1:
let asfs := ASFSc 2 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 0; InStackVar 1])] in
asfs_eq asfs asfs opmap = true.
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
asfs_eq asfs1 asfs2 opmap = false.
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
asfs_eq asfs1 asfs2 opmap = true.
Proof.
reflexivity. Qed.


Theorem asfs_eq_correctness:
  forall (a1 a2: asfs) (ops: opm) (s : concrete_stack),
  asfs_eq a1 a2 ops = true ->
  eval_asfs s a1 ops = eval_asfs s a2 ops.
Proof.
Admitted.    


End SFS.

(*

asfs_eq asfs1 asfs2 opmap ->
asfs_eq asfs2 asfs3 opmap ->
asfs_eq asfs1 asfs3 opmap

asfs_eq asfs1 asfs2 opmap ->
  asfs_eq asfs2 asfs1 opmap

check_block_eq b1 b2 opt -> bool

  asfs1 = sym_exec b1 opmap
  asfs2 = sym_exec b2 opmap
  asfs3 = opt asfs2 opmap
  return asfs_eq asfs1 asfs3 opmap


 *lemma*
  forall b1 b2
   asfs1 = sym_exec b1 opmap ->
   asfs2 = sym_exec b2 opmap ->
   asfs_eq asfs1 asfs2 opmap ->
     foall all in_stk conc in_stk b1 = conc in_stk b2



theorem:
forsll in_stk b1 b2 opt
  some requirment on 'opt' ->
   check_block_eq b1 b2 opt = true ->
    conc in_state in_stk b1 = conc in_stk b2

proof.

 - we know that asfs1 and asfs3 are equivalent
 - by requirement of 'opt' -> asfs1 and asfs2 are equiv
 
   which mean for any concrete stack, they eval to the same thing

*)



(*
Plan:

Phase 1: handle prog with no memory, and some optimizations

 - to go back to the add(x,0) optimization and rewrite in terms of
   the new representation (Enrique)

 - opfunc SFS => (SFS,bool): func SFS => SFS: add(x,0) ...

 - apply_all_op [opfunc1,...,optfuncn] SFS => (SFS,bool)   

 - opt_scheme SFS => SFS 

 - equiv_blocks p1 p2 height opt_scheme (Joseba)

     p1 -> SFS1
     p2 -> SFS2
     SFS2 -> opt_scheme -> SFS3
     equiv SFS1 SFS3

   equiv_gas ....
 
    -> equiv p1 p2 height opt_scheme_gas

  equiv_size ....
 
    -> equiv p1 p2 height opt_scheme_gas

 - f1, f2, f2 --> P(fi)  P is preservation of SFS

   l = [f1,f2,f3] 

   Plist(l) \for x \ in l. P(x)

   Prop Plist(l)
    nil | l=[]
    rec | l=x::l' && P(x) && Plist(l')

 - Generation of executable (Joseba)

    1. Coq -> OCaml (simple translation)
    2. Execute Coq

******
Enrique:

  - Look at simple optimiztions, ...

Joseba:

  - write a trivial optimizaer in=out
  - write equiv_blocks and proof correctness
  - look at code generation

Samir:

  - missing proof


Phase 2

Samir:

  - how we handle memory

Mem
[y,x,y,b4,b5,..x]

  STORE 9 (x,y)
  LOAD 0 -> (b1,x)

Store:

*)


  
  
              
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







(*

Store -> Easy -- map from addr to word 
Mem -> Diff -- map from add to bytes

Store is a list

 get add store -> if add is not in store return orig(add), otherwise return the value mapped to
 update add val store -> if store has add, morift its value, otherwise add addr->val

bbv

 w2b: Word -> List of bytes
 b2w: List of bytes -> Word

 (b2w (w2b w)) = w
 (w2b (b2w l)) = l

           
 update mem add val
  
  val -> list of bytes
  add->b1
  add+1 -> b2
  add+2 -> b3       
  ...           
       


*)

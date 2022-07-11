Require Import Arith.

Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import List.
Require Import Coq_EVM.lib.evmModel.
Import ListNotations.


Module Interpreter.

Definition WLen: nat := 1024. 
Definition EVMWord:= word WLen.
Definition StackLen := 1024.

(* General opcodes that operate on stack elements and return one value on top of stack*)
Inductive gen_instr :=
  | ADD
  | MUL
  | NOT.
  
Definition eq_gen_instr (a b: gen_instr) : bool :=
match (a, b) with
 | (ADD, ADD) => true
 | (MUL, MUL) => true
 | (NOT, NOT) => true 
 | _ => false
end.
Notation "m '=?i' n" := (eq_gen_instr m n) (at level 100).

(* PUSH, POP, DUP and SWAP are hardcoded, and the other opcodes are operators *)
Inductive instr :=
  | PUSH (size: nat) (w: EVMWord)
  | POP 
  | DUP (pos: nat)
  | SWAP (pos: nat)
  | Opcode (label: gen_instr).

(* function that evaluates a list of EVMWord, they are related to gen_instr *)
Inductive operator :=
  | Op (comm: bool) (nb_args : nat) (func : list EVMWord -> option EVMWord).
  
Definition add (args: list EVMWord) : option EVMWord :=
match args with
 | [a; b] => Some (wplus a b)
 | _ => None
 end.
 
Definition mul (args: list EVMWord) : option EVMWord :=
match args with
 | [a; b] => Some (wmult a b)
 | _ => None
 end.
 
Definition not (args: list EVMWord) : option EVMWord :=
match args with
 | [a] => Some (wnot a)
 | _ => None
 end.


(* Definition of maps *)
(* The maps here link an opcode (gen_instr) to an operator *)

Definition map (K V : Type) : Type := K -> option V.

Definition empty_imap {A : Type} : map gen_instr A := (fun _ => None).
Definition updatei {A : Type} (m : map gen_instr A) (x : gen_instr) (v : A) :=
  fun x' => if x =?i x' then Some v else m x'.
Notation "x '|->i' v ';' m" := (updatei m x v)
  (at level 100, v at next level, right associativity).
Notation "x '|->i' v" := (updatei empty_imap x v)
  (at level 100).
  
Example opmap : map gen_instr operator :=
ADD |->i Op true 2 add;
MUL |->i Op true 2 mul;
NOT |->i Op false 1 not.

Definition empty_nmap {A : Type} : map nat A := (fun _ => None).
Definition updaten {A : Type} (m : map nat A) (x : nat) (v : A) :=
  fun x' => if x =? x' then Some v else m x'.
Notation "x '|->n' v ';' m" := (updaten m x v)
  (at level 100, v at next level, right associativity).
Notation "x '|->n' v" := (updaten empty_nmap x v)
  (at level 100).
  

Compute (
3 |->n ADD;
4 |->n MUL;
5 |->n NOT).


(* Execution states *)
Definition tstack := list EVMWord.
Definition tmemory := map nat EVMWord.
Definition tstorage := map nat EVMWord.

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
  (ops : map gen_instr operator) : option execution_state :=
match inst with
  | PUSH size v => push_c v es
  | POP => pop_c es
  | DUP k => dup_c k es
  | SWAP k => swap_c k es
  | Opcode label =>
      let insk := get_stack_es es in
      match (ops label) with
      | Some (Op comm nb_args func) => build_es_opt_stack es (func (firstn nb_args insk)) (skipn nb_args insk)
      | None => None
      end
  end.

Fixpoint concr_interpreter (insts : list instr) (es : execution_state)
  (ops : map gen_instr operator) : option execution_state :=
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


(** Source: Integrating the EVM super-optimizer gasol into real-world compilers
    Link: https://eprints.ucm.es/id/eprint/67430/1/tfm_alejandro_hernandez_definitivo.pdf

    * STACK FUNCTIONAL SPECIFICATION (SFS) *
    
    Let B be a block and S0 its initial stack of size n that contains at
    each position i ∈ {0,..., n−1} a symbolic variable s_i that 
    represents the element stored at position i. 
    The stack functional specification of B is the output stack S of size m 
    that contains at each position j ∈ {0, ... , m−1} the element located 
    at position j in the stack after executing the EVM instructions of B. 
    Each element can be either 
      
      (1) a non-negative integer value, 
      (2) a variable si ∈ S0, or 
      (3) a symbolic expression composed by a functor OP with k parameters 
      a_1,..., a_k such that each a_i can be either of type (1), (2) or (3).

    The latter corresponds to an EVM instruction OP that operates on the stack 
    (other than SWAPk, PUSHk, DUPk, and POP) using k stack elements 
    s_i,..., s_i+k.

    Then, a SFS := 〈S0, S〉is composed of:
      
      1. S0: Initial stack of size n that contains at each position 
        i ∈ {0, ..., n−1} a symbolic variable s_i that represents 
        the element stored at position i.

      2. S: Output stack of size m that contains at each position 
        j ∈ {0,..., m−1}  the element located at position j in the stack after 
        executing the EVM instructions of B. Values are of the form 
        (1), (2) and (3).


    Implementation:

      Inductive sfs_val : Type :=
        | SFSVal (val : EVMWord)
        | SFSVar (var : nat)
        | SFSOp  (opcode : gen_instr) (args : list sfs_val).

      Definition sfs_stack   := list sfs_val.
      
      Inductive sfs : Type :=
        | SFSc (s0: basic_stack) (s: sfs_stack).



    * ABSTRACT STACK FUNCTIONAL SPECIFICATION (ASFS) *
    
    The motivation of this definition is based on avoiding composite elements 
    when representing the stack evolution in the Max-SMT problem
    
    Hence, for each non-basic opcode in a basic-block and each application 
    of that opcode to certain operands, a new stack variable is introduced. 
    These stack variables are denoted as __fresh stack__ variables, so that 
    a distinction can be made between them and the __initial stack variables__.

    Every fresh stack variable represents the application of an opcode 
    that consumes certain parameters. We need to keep track of the parameters 
    associated to each fresh stack variable, so an operator map is introduced 
    to link both. This map may contain recursive definitions when different 
    composite elements are chained, but no infinite recursive definitions can 
    be introduced due to its construction. All elements become shallow 
    as a result of this process.

    Then, an ASFS := 〈S0, S, M〉 is composed of:
    
      1. S0 initial stack: a list of stack variables s_0, ..., s_n with 
      no repeated elements.
      
      2. S final stack: a list that contains a series of either 
      stack variables or numerical values from 0 to 2^256 − 1.

      3. M uninterpreted operation map: a minimal map that links every 
      fresh new variable to its corresponding parameter
 *)

Inductive asfs_stack_val : Type :=
  | Val (val: EVMWord)
  | InStackVar (var: nat)
  | FreshVar (var: nat).

Inductive asfs_map_val : Type :=
  | ASFSBasicVal (val: asfs_stack_val)
  | ASFSOp  (opcode : gen_instr) (args : list asfs_stack_val).

Definition opm := map gen_instr operator.
Definition prog := list instr.

Definition concrete_stack := list EVMWord.
Definition in_stack := list (EVMWord+nat). (* Stack containing EVMWords, or ids *)
Definition asfs_stack  := list asfs_stack_val.
Definition asfs_map    := list (nat*asfs_map_val).

(** ASFS := 〈S0, S, M〉 *)
(** ASFS := 〈h, max, S, M〉 *)
Inductive asfs : Type :=
  | ASFSc (height maxid: nat) (s: asfs_stack) (m: asfs_map).

 
Fixpoint gen_initial_stack_inv {T: Type} (size: nat) (f: nat -> T): list T :=
match size with
 | 0 => nil
 | S n => (f n)::(gen_initial_stack_inv n f)
end.

Definition gen_initial_stack {T: Type} (size: nat) (f: nat -> T): list T :=
  rev (gen_initial_stack_inv size f).

(** 
Definition empty_sfs (size: nat) : SFS :=
let curr_stack := gen_initial_stack size pinStk in
SFSc 0 size curr_stack nil.

Compute empty_sfs 5.
*)

(** JOSEBA:
    I commented these previous SFS definition getters and setters in order
    to not break the code until we decide what information should [sfs]
    and [asfs] types contain.*)


(* Definition get_maxid_sfs (sfs: SFS) : nat :=*)
(* match sfs with*)
(*  | SFSc maxid is cs map => maxid*)
(* end.*)
(* Definition set_maxid_sfs (sfs: SFS) (idx: nat): SFS :=*)
(* match sfs with*)
(*  | SFSc maxid is cs map => SFSc idx is cs map*)
(* end.*)

(* Definition get_instk_size_sfs (sfs: SFS) : nat :=*)
(* match sfs with*)
(*  | SFSc maxid is cs map => is*)
(* end.*)
(* Definition set_instk_size_sfs (sfs: SFS) (instk_size: nat): SFS :=*)
(* match sfs with*)
(*  | SFSc maxid is cs map => SFSc maxid instk_size cs map*)
(* end.*)

(* Definition get_currstk_sfs (sfs: SFS) : AbsStk :=*)
(* match sfs with*)
(*  | SFSc maxid is cs map => cs*)
(* end.*)
(* Definition set_currstk_sfs (sfs: SFS) (currstk: AbsStk): SFS :=*)
(* match sfs with*)
(*  | SFSc maxid is cs map => SFSc maxid is currstk map*)
(* end.*)

(* Definition get_map_sfs (sfs: SFS) : SFSMap :=*)
(* match sfs with*)
(*  | SFSc maxid is cs map => map*)
(* end.*)
(* Definition set_map_sfs (sfs: SFS) (newmap: SFSMap): SFS :=*)
(* match sfs with*)
(*  | SFSc maxid is cs map => SFSc maxid is cs newmap*)
(* end.*)


(* ENRIQUE's COMMENTS:
   - the SymStk is not flattened, that's why you don't need the map in 
   the SFS or the idx to create fresh variables
   - I think that handling OpCode should fail (return None) in 'firstn' if 
   there are not enough values in the stack. 'firstn' simply takes 'n' 
   elements or the whole list if the size is smaller *)


Fixpoint id_to_asfs (s: list nat) : asfs_stack :=
  match s with
  | nil => nil
  | var::s' => (InStackVar var)::(id_to_asfs s')
  end.

Fixpoint in_to_asfs (s: in_stack) : asfs_stack :=
  match s with
  | nil => nil
  | h::s' => match h with
             | inl v  => (Val v)::(in_to_asfs s')
             | inr id => (InStackVar id)::(in_to_asfs s')
             end
  end.

Fixpoint concrete_to_asfs (s: list EVMWord) : asfs_stack :=
  match s with
  | nil => nil
  | val::s' => (Val val)::(concrete_to_asfs s')
  end.

Definition asfs_stack_val_eq (a b: asfs_stack_val) : bool :=
  match a, b with
  | Val v1, Val v2 => weqb v1 v2
  | InStackVar v1, InStackVar v2 => Nat.eqb v1 v2
  | FreshVar v1, FreshVar v2 => Nat.eqb v1 v2
  | _, _ => false
  end.

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

(* Set equality *)
Fixpoint permutation {A: Type} (eqa: A -> A -> bool) (l1 l2 : list A) : bool := 
  (subset eqa l1 l2) && (subset eqa l2 l1).

(* Check equality element by element. Order matters *)
Fixpoint list_eq {A: Type} (eqa: A -> A -> bool) (l1 l2 : list A) : bool :=
  match l1, l2 with
  | nil, nil => true
  | h1::l1', h2::l2' => if eqa h1 h2 then list_eq eqa l1' l2' else false
  | _, _ => false
  end.

Fixpoint firstn_error {A: Type} (n:nat) (l:list A) : option (list A) :=
  match n, l with
  | 0 , _ => Some nil
  | S n, nil => None
  | S n, h::t => 
      match firstn_error n t with
      | None => None
      | Some t' => Some (h::t')
      end
  end.

Fixpoint skipn_error {A: Type} (n:nat) (l:list A) : option (list A) :=
  match n, l with
  | 0 , _ => Some l
  | S n, nil => None
  | S n, h::t => skipn_error n t
  end.


Compute firstn_error 2 [1;2;3;4;5].
Compute skipn_error 6 [1;2;3;4;5].


Compute list_eq Nat.eqb [1;2;3] [1;2;3;4].
Compute permutation Nat.eqb [1;3;2] [3;1;4].

Definition asfs_map_val_eq (ops: opm) (a b: asfs_map_val) : option bool :=
  match a, b with
  | ASFSBasicVal v1,  ASFSBasicVal v2  => Some (asfs_stack_val_eq v1 v2)
  | ASFSOp op1 args1, ASFSOp op2 args2 => 
      if eq_gen_instr op1 op2 then
      match ops op1 with
      | None => None
      | Some (Op comm nargs f) =>
          if comm then Some (permutation asfs_stack_val_eq args1 args2) else 
          Some (list_eq asfs_stack_val_eq args1 args2)
      end
      else Some false
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

Fixpoint asfs_map_contains (ops: opm) (m: asfs_map) (a: asfs_map_val): option bool :=
  match m with
  | nil => Some false
  | h::m' => 
      match asfs_map_val_eq ops a (snd h) with
      | None => None
      | Some false => asfs_map_contains ops m' a
      | Some true => Some true
      end
  end.

Fixpoint asfs_map_add (m: asfs_map) (id: nat) (a: asfs_map_val) : asfs_map :=
  (id, a)::m.

Fixpoint symbolic_exec' (ops: opm) (maxid: nat) (s: asfs_stack) (m: asfs_map) 
  (ins: instr) : nat*(option asfs_stack)*asfs_map :=
  match ins with
  | PUSH size w  => (maxid, push (Val w) s, m)
  | POP          => (maxid, pop s, m)
  | DUP pos      => (maxid, dup pos s, m)
  | SWAP pos     => (maxid, swap pos s, m)
  | Opcode label =>
      match (ops label) with
      | None => (maxid, None, m)
      | Some (Op comm nargs f) =>
          let val : asfs_map_val := ASFSOp label (firstn nargs s) in
          let vin : option bool  := asfs_map_contains ops m val in
          let vid : option nat   := asfs_map_get_id   ops m val in
          match vin, vid with
          (* Value is in map, there is id *)
          | Some vin', Some vid' => 
              let s' : option asfs_stack := push (FreshVar vid') (skipn nargs s) in
              (vid', s', m)
           (* Value is not in map *)
          | Some vin', None => 
              let m' : asfs_map := asfs_map_add m (maxid+1) val in 
              let s' : option asfs_stack := push (FreshVar (maxid+1)) (skipn nargs s) in
              (maxid+1, s', m')
          (* Owise *)
          | _, _ => (maxid, None, m)
          end
      end
  end.

Fixpoint symbolic_exec (ops: opm) (maxid: nat) (s: asfs_stack) (m: asfs_map) 
  (p: prog) : nat*(option asfs_stack)*asfs_map :=
  match p with
  | nil => (maxid, Some s, m)
  | ins::p' =>
      match symbolic_exec' ops maxid s m ins with
      | (maxid', None   , m') => (maxid', None, m')
      | (maxid', Some s', m') => symbolic_exec ops maxid' s' m' p'
      end
  end.

Definition symbolic_execution (ops: opm) (maxid: nat) (s: in_stack) (p: prog) : 
  option asfs :=
  let s0 : asfs_stack := in_to_asfs s in 
  match symbolic_exec ops maxid s0 [] p with
  | (maxid', None, m') => None
  | (maxid', Some s', m') => Some (ASFSc (length s) maxid' s' m')
  end.

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

Example  se_0 := let s0 := concrete_to_asfs cs_0 in symbolic_exec opmap 3 s0 [] p_0.
Compute fst (fst se_0).
Compute snd (fst se_0). 
Compute snd se_0. 

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


Example  se_1 := let s0 := concrete_to_asfs cs_1 in symbolic_exec opmap 3 s0 [] p_1.
Compute fst (fst se_1).
Compute snd (fst se_1). 
Compute snd se_1. 


(* ENRIQUE:
   Explictitly unfolded the code for evaluating lists of ASFSOp arguments in order to avoid mutually
   recursive functions (one for one asfs_stack_val, the other for lists of asfs_stack_val) whose 
   definition would require Program Fixpoint with a lexicographically decreasing (map size, list size)
   that impose well-founded proof obligations and that complicates other proofs 
   [I dont't know how to simplify or rewrite a call to a Program Fixpoint] 
   Moreover, "Program Fixpoint" in mutually recursive definitions does not seem to be supported, although
   the Coq documentation says the opposite.
   *)
Fixpoint eval_asfs2_elem (c: list EVMWord) (elem: asfs_stack_val) (m: asfs_map) (ops: opm) : option EVMWord :=
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

Fixpoint eval_asfs2 (c: list EVMWord) (s: asfs_stack) (m: asfs_map) (ops: opm) : option (list EVMWord) :=
match s with 
| nil => Some []
| elem::rs => let elem_oval := eval_asfs2_elem c elem m ops in
              let rs_oval := eval_asfs2 c rs m ops in
              match (elem_oval, rs_oval) with 
              | (Some elem_val, Some rs_val) => Some (elem_val::rs_val)
              | _ => None
              end
end.

Definition eval_asfs (c: list EVMWord) (s: asfs) (ops: opm) : option (list EVMWord) :=
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






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
Definition asfs_stack  := list asfs_stack_val.
Definition asfs_map    := list (nat*asfs_map_val).

(** ASFS := 〈S0, S, M〉 *)
(** ASFS := 〈h, max, S, M〉 *)
Inductive asfs : Type :=
  | ASFSc (height maxid: nat) (s: asfs_stack) (m: asfs_map).


(* Some Useful tranformations *)

(* Definition basic_to_sfs' (a: basic_val) : sfs_val := *)
(*   match a with *)
(*   | Val v => SFSVal v *)
(*   | Var v => SFSVar v *)
(*   end. *)

(* Fixpoint basic_to_sfs (l: basic_stack) : sfs_stack := *)
(*   match l with *)
(*   | nil => nil *)
(*   | h::l' => (basic_to_sfs' h)::(basic_to_sfs l') *)
(*   end. *)

(* Definition asfs_to_sfs' (a: asfs_val) : sfs_val := *)
(*   match a with *)
(*   | ASFSVal v => SFSVal v *)
(*   | ASFSVar v => SFSVar v *)
(*   | ASFSFreshVar v => SFSVar v *)
(*   end. *)

(* Fixpoint asfs_to_sfs (s: asfs_stack) : sfs_stack := *)
(*   match s with *)
(*   | nil => nil *)
(*   | h::s' => (asfs_to_sfs' h)::(asfs_to_sfs s') *)
(*   end. *)



 
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


(** [symbolic_exec_aux] takes:
   
      - s: [SymStk]: A [list SFSval] representing the initial stack
        containing only symbolic references

      - prog: [list instrs]: EVM program.

      - ops: map gen_insts operator: A map telling us info about 
        how to compute arithmetic operations.

    and returns [option SymStk]*)

(* ENRIQUE's COMMENTS:
   - the SymStk is not flattened, that's why you don't need the map in 
   the SFS or the idx to create fresh variables
   - I think that handling OpCode should fail (return None) in 'firstn' if 
   there are not enough values in the stack. 'firstn' simply takes 'n' 
   elements or the whole list if the size is smaller *)

(* Fixpoint symbolic_exec' (s: sfs_stack) (ins: instr) (ops: opm): option sfs_stack:= *)
(*   match ins with *)
(*   | PUSH size w  => push (SFSVal w) s *)
(*   | POP          => pop s *)
(*   | DUP pos      => dup pos s *)
(*   | SWAP pos     => swap pos s *)
(*   | Opcode label => *)
(*       match (ops label) with *)
(*       | None => None *)
(*       | Some (Op comm nargs f) => *) 
(*           Some ((SFSOp label (firstn nargs s))::(skipn nargs s)) *)
(*       end *)
(*   end. *)

(* Fixpoint symbolic_exec (s0: sfs_stack) (p: prog) (ops: opm): option sfs_stack := *)
(*   match p with *)
(*   | nil => Some s0 *)
(*   | ins::p' => *) 
(*       match symbolic_exec' s0 ins ops with *)
(*       | None => None *)
(*       | Some s0' => symbolic_exec s0' p' ops *)
(*       end *)
(*   end. *)


(* Symbolic Execution Tests *)


(* Example cs : concrete_stack := [ *) 
(*   natToWord WLen 8; *)
(*   natToWord WLen 2; *)
(*   natToWord WLen 3 *)
(*   ]. *)

(* Example bs_0 : basic_stack := [ *)
(*   Val (natToWord WLen 8); *) 
(*   Val (natToWord WLen 2); *) 
(*   Val (natToWord WLen 3)]. *)

(* Example p_0 : prog := [ *)
(*   PUSH 1 (natToWord WLen 5); *) 
(*   PUSH 1 (natToWord WLen 7); *) 
(*   PUSH 1 (natToWord WLen 7); *) 
(*   Opcode ADD; *)
(*   POP *)
(* ]. *)

(* Compute let s0 := basic_to_sfs bs_0 in *)
(*         symbolic_exec s0 p_0 opmap. *)
  

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
                                 | nil => None (* Operator without operands. Can this happen?  *)
                                 | [a1] => match eval_asfs2_elem c a1 rm ops with
                                           | Some v1 => func [v1]
                                           | None => None
                                           end
                                 | [a1;a2] => match eval_asfs2_elem c a1 rm ops, 
                                                    eval_asfs2_elem c a2 rm ops with
                                           | Some v1, Some v2 => func [v1; v2]
                                           | _, _ => None
                                           end
                                 | [a1;a2;a3] => match eval_asfs2_elem c a1 rm ops, 
                                                       eval_asfs2_elem c a2 rm ops,
                                                       eval_asfs2_elem c a3 rm ops with
                                           | Some v1, Some v2, Some v3 => func [v1; v2; v3]
                                           | _, _, _ => None
                                           end
                                 | _ => None (* There are not operators for 4 or more arguments in our set of instructions *)
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
| ASFSc height maxid curr_stack amap => eval_asfs2 c curr_stack amap ops
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
  


End SFS.






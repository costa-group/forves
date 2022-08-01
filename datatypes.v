Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import List.
Require Import Coq_EVM.lib.evmModel.
Import ListNotations.



(* ################################################################# *)
(* * EVM related definitions *)
Module EVM_Def.
Definition WLen: nat := 256. 
Definition EVMWord:= word WLen.
Definition StackLen := 1024.
Definition WZero: EVMWord  := natToWord WLen 0.
Definition WOne : EVMWord  := natToWord WLen 1.
Definition WTrue: EVMWord  := natToWord WLen 1.
End EVM_Def.
Import EVM_Def.


(* ################################################################# *)
(** * Concrete *)

(** Execution State and Stack Machine related definitions *)
Module Concrete.

(** General opcodes that operate on stack elements and return one value on top of stack*)
Inductive gen_instr :=
  | ADD
  | MUL
  | NOT.
  
(** PUSH, POP, DUP and SWAP are hardcoded, and the other opcodes are operators *)
Inductive instr :=
  | PUSH (size: nat) (w: EVMWord)
  | POP 
  | DUP (pos: nat)
  | SWAP (pos: nat)
  | Opcode (label: gen_instr).
  
Definition prog := list instr.  

(** Function that evaluates a list of EVMWord, they are related to gen_instr *)
Inductive operator :=
  | Op (comm: bool) (nb_args : nat) (func : list EVMWord -> option EVMWord).

Definition eq_gen_instr (a b: gen_instr) : bool :=
match (a, b) with
 | (ADD, ADD) => true
 | (MUL, MUL) => true
 | (NOT, NOT) => true 
 | _ => false
end.
Notation "m '=?i' n" := (eq_gen_instr m n) (at level 100).


(* ================================================================= *)
(** ** Implementation of current instructions *)

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

(* ================================================================= *)
(** ** Definition of maps *)

(* The maps here link an opcode (gen_instr) to an operator *)

Definition map (K V : Type) : Type := K -> option V.

Definition empty_imap {A : Type} : map gen_instr A := (fun _ => None).
Definition updatei {A : Type} (m : map gen_instr A) (x : gen_instr) (v : A) :=
  fun x' => if x =?i x' then Some v else m x'.
Notation "x '|->i' v ';' m" := (updatei m x v)
  (at level 100, v at next level, right associativity).
Notation "x '|->i' v" := (updatei empty_imap x v)
  (at level 100).
  
Definition empty_nmap {A : Type} : map nat A := (fun _ => None).
Definition updaten {A : Type} (m : map nat A) (x : nat) (v : A) :=
  fun x' => if x =? x' then Some v else m x'.
Notation "x '|->n' v ';' m" := (updaten m x v)
  (at level 100, v at next level, right associativity).
Notation "x '|->n' v" := (updaten empty_nmap x v)
  (at level 100).
  
Definition opm := map gen_instr operator.
  
Definition opmap : opm :=
  ADD |->i Op true 2 add;
  MUL |->i Op true 2 mul;
  NOT |->i Op false 1 not.


(* ================================================================= *)
(* ** Execution states *)
Definition tstack := list EVMWord.
Definition tmemory := map nat EVMWord.
Definition tstorage := map nat EVMWord.

End Concrete.
Import Concrete.


(* ################################################################# *)
(** * Abstract *)

Module Abstract.

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

Definition concrete_stack := list EVMWord.
Definition in_stack := list nat.
Definition asfs_stack  := list asfs_stack_val.
Definition asfs_map    := list (nat*asfs_map_val).

(** ASFS := 〈S0, S, M〉 *)
(** ASFS := 〈h, max, S, M〉 *)
Inductive asfs : Type :=
  | ASFSc (height maxid: nat) (s: asfs_stack) (m: asfs_map).

End Abstract.

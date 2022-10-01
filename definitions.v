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
End EVM_Def.
Import EVM_Def.


(* ################################################################# *)
(** * Concrete *)

(** Execution State and Stack Machine related definitions *)
Module Concrete.

(** General opcodes that operate on stack elements and return one value on 
    top of the stack *)
Inductive oper_label :=
  | ADD
  | MUL
  | NOT
  | SUB
  | DIV
  | SDIV
  | MOD
  | SMOD
  | ADDMOD
  | MULMOD
  | EXP
  | SIGNEXTEND
  | LT
  | GT
  | SLT
  | SGT
  | EQ
  | ISZERO
  | AND
  | OR
  | XOR
  | BYTE
  | SHL
  | SHR
  | SAR
  | SHA3
  | KECCAK256
  | ADDRESS
  | BALANCE
  | ORIGIN
  | CALLER
  | CALLVALUE
  | CALLDATALOAD
  | CALLDATASIZE 
  | CODESIZE
  | GASPRICE
  | EXTCODESIZE
  | RETURNDATASIZE
  | EXTCODEHASH
  | BLOCKHASH
  | COINBASE
  | TIMESTAMP
  | NUMBER
  | DIFFICULTY
  | GASLIMIT
  | CHAINID
  | SELFBALANCE
  | BASEFEE
  | SLOAD
  | MLOAD
  | PC
  | MSIZE
  | GAS
  | CREATE
  | CREATE2.
  
(** PUSH, POP, DUP and SWAP are hardcoded, and the other opcodes are operators *)
Inductive instr :=
  | PUSH (size: nat) (w: EVMWord)
  | POP 
  | DUP (pos: nat)
  | SWAP (pos: nat)
  | Opcode (label: oper_label).
  
Definition block := list instr.  

(** Function that evaluates a list of EVMWord, they are related to oper_label *)
Inductive operator :=
  | Op (comm: bool) (nb_args : nat) (func : list EVMWord -> option EVMWord).

Definition eq_oper_label (a b: oper_label) : bool :=
match (a, b) with
 | (ADD, ADD) => true
 | (MUL, MUL) => true
 | (NOT, NOT) => true 
 | (SUB,SUB) => true
 | (DIV,DIV) => true
 | (SDIV,SDIV) => true
 | (MOD,MOD) => true
 | (SMOD,SMOD) => true
 | (ADDMOD,ADDMOD) => true
 | (MULMOD,MULMOD) => true
 | (EXP,EXP) => true
 | (SIGNEXTEND,SIGNEXTEND) => true
 | (LT,LT) => true
 | (GT,GT) => true
 | (SLT,SLT) => true
 | (SGT,SGT) => true
 | (EQ,EQ) => true
 | (ISZERO,ISZERO) => true
 | (AND,AND) => true
 | (OR,OR) => true
 | (XOR,XOR) => true
 | (BYTE,BYTE) => true
 | (SHL,SHL) => true
 | (SHR,SHR) => true
 | (SAR,SAR) => true
 | (SHA3,SHA3) => true
 | (KECCAK256,KECCAK256) => true
 | (ADDRESS,ADDRESS) => true
 | (BALANCE,BALANCE) => true
 | (ORIGIN,ORIGIN) => true
 | (CALLER,CALLER) => true
 | (CALLVALUE,CALLVALUE) => true
 | (CALLDATALOAD,CALLDATALOAD) => true
 | (CALLDATASIZE ,CALLDATASIZE ) => true
 | (CODESIZE,CODESIZE) => true
 | (GASPRICE,GASPRICE) => true
 | (EXTCODESIZE,EXTCODESIZE) => true
 | (RETURNDATASIZE,RETURNDATASIZE) => true
 | (EXTCODEHASH,EXTCODEHASH) => true
 | (BLOCKHASH,BLOCKHASH) => true
 | (COINBASE,COINBASE) => true
 | (TIMESTAMP,TIMESTAMP) => true
 | (NUMBER,NUMBER) => true
 | (DIFFICULTY,DIFFICULTY) => true
 | (GASLIMIT,GASLIMIT) => true
 | (CHAINID,CHAINID) => true
 | (SELFBALANCE,SELFBALANCE) => true
 | (BASEFEE,BASEFEE) => true
 | (SLOAD,SLOAD) => true
 | (MLOAD,MLOAD) => true
 | (PC,PC) => true
 | (MSIZE,MSIZE) => true
 | (GAS,GAS) => true
 | (CREATE,CREATE) => true
 | (CREATE2,CREATE2) => true
 | _ => false
end.
Notation "m '=?i' n" := (eq_oper_label m n) (at level 100).

Lemma eq_oper_label_correct:  forall (a b: oper_label),
eq_oper_label a b = true -> a = b.
Proof.
intros. unfold eq_oper_label in H. 
destruct a; try (destruct b; intuition).
Qed.



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

Definition eq (args: list EVMWord) : option EVMWord :=
match args with
 | [a; b] => Some (if weqb a b then WOne else WZero)
 | _ => None
end.

Definition and (args: list EVMWord) : option EVMWord :=
match args with
 | [a; b] => Some (wand a b)
 | _ => None
end.

Definition or (args: list EVMWord) : option EVMWord :=
match args with
 | [a; b] => Some (wor a b)
 | _ => None
end.

Definition xor (args: list EVMWord) : option EVMWord :=
match args with
 | [a; b] => Some (wxor a b)
 | _ => None
end.




Definition uninterp0 (args: list EVMWord) : option EVMWord :=
match args with
 | [] => Some WZero
 | _ => None
 end.

Definition uninterp1 (args: list EVMWord) : option EVMWord :=
match args with
 | [_] => Some WZero
 | _ => None
 end.

Definition uninterp2 (args: list EVMWord) : option EVMWord :=
match args with
 | [_;_] => Some WZero
 | _ => None
 end.

Definition uninterp3 (args: list EVMWord) : option EVMWord :=
match args with
 | [_;_;_] => Some WZero
 | _ => None
 end.

 Definition uninterp4 (args: list EVMWord) : option EVMWord :=
match args with
 | [_;_;_;_] => Some WZero
 | _ => None
 end.

(* ================================================================= *)
(** ** Definition of maps *)

(* The maps here link an opcode (oper_label) to an operator *)

Definition map (K V : Type) : Type := K -> option V.

Definition empty_imap {A : Type} : map oper_label A := (fun _ => None).
Definition updatei {A : Type} (m : map oper_label A) (x : oper_label) (v : A) :=
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
  
Definition opm := map oper_label operator.
  
Definition opmap : opm :=
  ADD |->i Op true 2 add;
  MUL |->i Op true 2 mul;
  NOT |->i Op false 1 not;
  SUB |->i Op false 2 uninterp2;
  DIV |->i Op false 2 uninterp2;
  SDIV |->i Op false 2 uninterp2;
  MOD |->i Op false 2 uninterp2;
  SMOD |->i Op false 2 uninterp2;
  ADDMOD |->i Op false 3 uninterp3;
  MULMOD |->i Op false 3 uninterp3;
  EXP |->i Op false 2 uninterp2;
  SIGNEXTEND |->i Op false 2 uninterp2;
  LT |->i Op false 2 uninterp2;
  GT |->i Op false 2 uninterp2;
  SLT |->i Op false 2 uninterp2;
  SGT |->i Op false 2 uninterp2;
  EQ |->i Op true 2 eq;
  ISZERO |->i Op false 1 uninterp1;
  AND |->i Op true 2 and;
  OR |->i Op true 2 or;
  XOR |->i Op true 2 xor;
  BYTE |->i Op false 2 uninterp2;
  SHL |->i Op false 2 uninterp2;
  SHR |->i Op false 2 uninterp2;
  SAR |->i Op false 2 uninterp2;
  SHA3 |->i Op false 2 uninterp2;
  KECCAK256 |->i Op false 2 uninterp2;
  ADDRESS |->i Op false 0 uninterp0;
  BALANCE |->i Op false 1 uninterp1;
  ORIGIN |->i Op false 0 uninterp0;
  CALLER |->i Op false 0 uninterp0;
  CALLVALUE |->i Op false 0 uninterp0;
  CALLDATALOAD |->i Op false 1 uninterp1;
  CALLDATASIZE  |->i Op false 0 uninterp0;
  CODESIZE |->i Op false 0 uninterp0;
  GASPRICE |->i Op false 0 uninterp0;
  EXTCODESIZE |->i Op false 1 uninterp1;
  RETURNDATASIZE |->i Op false 0 uninterp0;
  EXTCODEHASH |->i Op false 1 uninterp1;
  BLOCKHASH |->i Op false 0 uninterp0;
  COINBASE |->i Op false 0 uninterp0;
  TIMESTAMP |->i Op false 0 uninterp0;
  NUMBER |->i Op false 0 uninterp0;
  DIFFICULTY |->i Op false 0 uninterp0;
  GASLIMIT |->i Op false 0 uninterp0;
  CHAINID |->i Op false 0 uninterp0;
  SELFBALANCE |->i Op false 0 uninterp0;
  BASEFEE |->i Op false 0 uninterp0;
  SLOAD |->i Op false 1 uninterp1;
  MLOAD |->i Op false 1 uninterp1;
  PC |->i Op false 0 uninterp0;
  MSIZE |->i Op false 0 uninterp0;
  GAS |->i Op false 0 uninterp0;
  CREATE |->i Op false 3 uninterp3;
  CREATE2 |->i Op false 4 uninterp4. 


(* ================================================================= *)
(* ** Execution states *)
Definition tstack := list EVMWord.
Definition tmemory := map nat EVMWord.
Definition tstorage := map nat EVMWord.
Inductive execution_state :=
 | ExState (stack: tstack) (memory: tmemory) (storage: tstorage).

End Concrete.
Import Concrete.


(* ################################################################# *)
(** * Abstract *)

Module Abstract.


Inductive asfs_stack_val : Type :=
  | Val (val: EVMWord)
  | InStackVar (var: nat)
  | FreshVar (var: nat).


Inductive asfs_map_val : Type :=
  | ASFSBasicVal (val: asfs_stack_val)
  | ASFSOp (opcode : oper_label) (args : list asfs_stack_val).
  
  
Inductive stack_expr : Type :=
  | UVal (val: EVMWord)
  | UInStackVar (var: nat)
  | UOp (opcode : oper_label) (args : list stack_expr).

Definition asfs_stack  := list asfs_stack_val.
Definition asfs_map    := list (nat*asfs_map_val).

Inductive asfs : Type :=
  | ASFSc (height maxid: nat) (s: asfs_stack) (m: asfs_map).


(* MaxID is > any fresh variable in the map *)
Fixpoint fresh_var_gt_map (idx: nat) (map: asfs_map) : Prop :=
match map with 
| nil => True
| (k,v)::t => idx > k /\ fresh_var_gt_map idx t
end.

(* Fresh variables in a map are strictly decreasing *)
Fixpoint strictly_decreasing_map (a: asfs_map) {struct a} : Prop :=
match a with
| [] => True
| (var1, e1)::t1 => match t1 with 
                    | [] => True
                    | (var2, e2)::t2 => var1 > var2 /\ 
                                        strictly_decreasing_map t1
                    end
end.

Definition valid_asfs (sfs: asfs) : Prop :=
match sfs with 
| ASFSc height maxid s m => (fresh_var_gt_map maxid m) /\
                            (strictly_decreasing_map m)
end.

End Abstract.
Import Abstract.



Module Optimizations.

Definition optimization := asfs -> asfs*bool.

End Optimizations.
Import Optimizations. 

Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import Coq.NArith.NArith.
Require Import List.
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
Inductive stack_op_instr :=
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
  | GAS.
  
(** PUSH, POP, DUP and SWAP are hardcoded, and the other opcodes are operators *)
Inductive instr :=
  | PUSH (size: nat) (w: EVMWord)
  | POP 
  | DUP (pos: nat)
  | SWAP (pos: nat)
  | Opcode (label: stack_op_instr).
  
Definition block := list instr.  

Inductive stack_operation :=
  | StackOp (comm: bool) (n : nat) (f : list EVMWord -> option EVMWord).

Definition eq_stack_op_instr (a b: stack_op_instr) : bool :=
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
 | _ => false
end.
Notation "m '=?i' n" := (eq_stack_op_instr m n) (at level 100).

Lemma eq_stack_op_instr_correct:  forall (a b: stack_op_instr),
eq_stack_op_instr a b = true -> a = b.
Proof.
intros. unfold eq_stack_op_instr in H. 
destruct a; try (destruct b; intuition).
Qed.


(* ================================================================= *)
(** ** Implementation of current instructions *)

Definition evm_add (args: list EVMWord) : option EVMWord :=
match args with
 | [a; b] => Some (wplus a b)
 | _ => None
 end.
 
Definition evm_mul (args: list EVMWord) : option EVMWord :=
match args with
 | [a; b] => Some (wmult a b)
 | _ => None
 end.
 
Definition evm_not (args: list EVMWord) : option EVMWord :=
match args with
 | [a] => Some (wnot a)
 | _ => None
end.

Definition evm_eq (args: list EVMWord) : option EVMWord :=
match args with
 | [a; b] => Some (if weqb a b then WOne else WZero)
 | _ => None
end.

Definition evm_iszero (args: list EVMWord) : option EVMWord :=
match args with
 | [a] => evm_eq [a; WZero]
 | _ => None
end.

Definition evm_and (args: list EVMWord) : option EVMWord :=
match args with
 | [a; b] => Some (wand a b)
 | _ => None
end.

Definition evm_or (args: list EVMWord) : option EVMWord :=
match args with
 | [a; b] => Some (wor a b)
 | _ => None
end.

Definition evm_xor (args: list EVMWord) : option EVMWord :=
match args with
 | [a; b] => Some (wxor a b)
 | _ => None
end.

Definition evm_shl (args: list EVMWord) : option EVMWord :=
match args with
| [a; b] => Some (wlshift' b (wordToNat a))
| _ => None
end.

Definition evm_shr (args: list EVMWord) : option EVMWord :=
match args with
| [a; b] => Some (wrshift' b (wordToNat a))
| _ => None
end.

Definition evm_sub (args: list EVMWord) : option EVMWord :=
match args with
| [a; b] => Some (wminus a b)
| _ => None
end.

Definition evm_exp (args: list EVMWord) : option EVMWord :=
match args with
| [a; b] => Some (NToWord WLen (N.pow (wordToN a) (wordToN b)))
| _ => None
end.

Definition evm_div (args: list EVMWord) : option EVMWord :=
match args with
| [a; b] => Some (wdiv a b)
| _ => None
end.

Definition evm_lt (args: list EVMWord) : option EVMWord :=
match args with
| [a; b] => Some (if (N.ltb (wordToN a) (wordToN b)) then WOne else WZero)
| _ => None
end.

Definition evm_gt (args: list EVMWord) : option EVMWord :=
match args with
| [a; b] => evm_lt [b; a]
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

Definition empty_imap {A : Type} : map stack_op_instr A := (fun _ => None).
Definition updatei {A : Type} (m : map stack_op_instr A) 
    (x : stack_op_instr) (v : A) :=
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
  
Definition stack_op_map := map stack_op_instr stack_operation.
  

Definition fully_defined := [
  ADD;
  MUL;
  NOT;
  SUB;
  DIV;
  EXP;
  EQ ;
  ISZERO;
  AND;
  OR;
  XOR;
  SHL;
  SHR
  ].

Definition is_fully_defined (i : stack_op_instr) :=
  let  fix f ( l : list stack_op_instr) :=
            match l with
            | [] => false
            | x::xs => if (eq_stack_op_instr i x) then true else (f xs)
            end
  in
  f fully_defined.

Definition evm_stack_opm : stack_op_map :=
  ADD |->i StackOp true 2 evm_add;
  MUL |->i StackOp true 2 evm_mul;
  NOT |->i StackOp false 1 evm_not;
  SUB |->i StackOp false 2 evm_sub;
  DIV |->i StackOp false 2 evm_div;
  SDIV |->i StackOp false 2 uninterp2;
  MOD |->i StackOp false 2 uninterp2;
  SMOD |->i StackOp false 2 uninterp2;
  ADDMOD |->i StackOp false 3 uninterp3;
  MULMOD |->i StackOp false 3 uninterp3;
  EXP |->i StackOp false 2 evm_exp;
  SIGNEXTEND |->i StackOp false 2 uninterp2;
  LT |->i StackOp false 2 evm_lt;
  GT |->i StackOp false 2 evm_gt;
  SLT |->i StackOp false 2 uninterp2;
  SGT |->i StackOp false 2 uninterp2;
  EQ |->i StackOp true 2 evm_eq;
  ISZERO |->i StackOp false 1 evm_iszero;
  AND |->i StackOp true 2 evm_and;
  OR |->i StackOp true 2 evm_or;
  XOR |->i StackOp true 2 evm_xor;
  BYTE |->i StackOp false 2 uninterp2;
  SHL |->i StackOp false 2 evm_shl;
  SHR |->i StackOp false 2 evm_shr;
  SAR |->i StackOp false 2 uninterp2;
  SHA3 |->i StackOp false 2 uninterp2;
  KECCAK256 |->i StackOp false 2 uninterp2;
  ADDRESS |->i StackOp false 0 uninterp0;
  BALANCE |->i StackOp false 1 uninterp1;
  ORIGIN |->i StackOp false 0 uninterp0;
  CALLER |->i StackOp false 0 uninterp0;
  CALLVALUE |->i StackOp false 0 uninterp0;
  CALLDATALOAD |->i StackOp false 1 uninterp1;
  CALLDATASIZE  |->i StackOp false 0 uninterp0;
  CODESIZE |->i StackOp false 0 uninterp0;
  GASPRICE |->i StackOp false 0 uninterp0;
  EXTCODESIZE |->i StackOp false 1 uninterp1;
  RETURNDATASIZE |->i StackOp false 0 uninterp0;
  EXTCODEHASH |->i StackOp false 1 uninterp1;
  BLOCKHASH |->i StackOp false 0 uninterp0;
  COINBASE |->i StackOp false 0 uninterp0;
  TIMESTAMP |->i StackOp false 0 uninterp0;
  NUMBER |->i StackOp false 0 uninterp0;
  DIFFICULTY |->i StackOp false 0 uninterp0;
  GASLIMIT |->i StackOp false 0 uninterp0;
  CHAINID |->i StackOp false 0 uninterp0;
  SELFBALANCE |->i StackOp false 0 uninterp0;
  BASEFEE |->i StackOp false 0 uninterp0;
  SLOAD |->i StackOp false 1 uninterp1;
  MLOAD |->i StackOp false 1 uninterp1;
  PC |->i StackOp false 0 uninterp0;
  MSIZE |->i StackOp false 0 uninterp0;
  GAS |->i StackOp false 0 uninterp0.


(* ================================================================= *)
(* ** Execution states *)
Definition stack := list EVMWord.
Definition memory := map nat EVMWord.
Definition storage := map nat EVMWord.
Inductive state :=
 | ExState (stk: stack) (mem: memory) (stg: storage).

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
  | ASFSOp (opcode : stack_op_instr) (args : list asfs_stack_val).
  
  
Inductive stack_expr : Type :=
  | UVal (val: EVMWord)
  | UInStackVar (var: nat)
  | UOp (opcode : stack_op_instr) (args : list stack_expr).

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

Require Import bbv.Word.

Require Import Coq.NArith.NArith.

Require Import List.
Import ListNotations.

Require Import FORVES.execution_state.
Import ExecutionState.

Require Import FORVES.constants.
Import Constants.

Require Import FORVES.misc.
Import Misc.

Require Import FORVES.program.
Import Program.


Module StackOpInstrs.

(* Some stack operation instructions are commutative, a property that
might be used when optimizing a block. The following definition models
this property. *)
Definition commutative_op (f : context -> list EVMWord -> EVMWord) : Prop :=
  forall (a b : EVMWord) (ctx : context), f ctx [a;b] = f ctx [b;a].

(* An implementation of a stack operation instructions *)
Inductive stack_op_impl :=
| OpImp (n : nat) (f : context -> list EVMWord -> EVMWord) (H : option (commutative_op f)).



Definition stack_op_instr_map := map stack_op_instr stack_op_impl.

Definition empty_imap {A : Type} (def : A) : map stack_op_instr A :=
  (fun _ =>  def).

Definition updatei {A : Type} (m : map stack_op_instr A) (x : stack_op_instr) (v : A) :=
  fun x' => if x =?i x' then v else m x'.

Notation "x '|->i' v ';' m" := (updatei m x v) (at level 100, v at next level, right associativity).
Notation "x '|->i' v" := (updatei (empty_imap (OpImp 0 (fun (_:context) (_:list EVMWord) => WZero) None)) x v) (at level 100).






(* =================================================================
*) (** ** Implementation of current instructions *)

Definition evm_add (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wplus a b
  | _ => WZero
  end.

Lemma add_comm: commutative_op evm_add.
Proof.
  unfold commutative_op.
  intros.
  unfold evm_add.
  rewrite -> wplus_comm.
  reflexivity.
Qed.
        
Definition evm_mul (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wmult a b
  | _ => WZero
  end.


Definition evm_sub (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wminus a b
  | _ => WZero
  end.

Definition evm_div (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wdiv a b
  | _ => WZero
  end.

Definition evm_sdiv (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_mod (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_smod (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_addmod (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_mulmod (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_exp (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => NToWord EVMWordSize (N.pow (wordToN a) (wordToN b))
  | _ => WZero
  end.
  

Definition evm_signextend (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_lt (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => if (N.ltb (wordToN a) (wordToN b)) then WOne else WZero
  | _ => WZero
  end.

Definition evm_gt (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => evm_lt ctx [b; a]
  | _ => WZero
  end.

Definition evm_slt (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_sgt (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_eq (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => if weqb a b then WOne else WZero
  | _ => WZero
  end.
  
Definition evm_iszero (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a] => evm_eq ctx [a; WZero]
  | _ => WZero
  end.

Definition evm_and (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wand a b
  | _ => WZero
  end.

Definition evm_or (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wor a b
  | _ => WZero
  end.

Definition evm_xor (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wxor a b
  | _ => WZero
  end.

Definition evm_not (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a] => wnot a
  | _ => WZero
  end.

Definition evm_byte (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_shl (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wlshift' b (wordToNat a)
  | _ => WZero
  end.

Definition evm_shr (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wrshift' b (wordToNat a)
  | _ => WZero
  end.

Definition evm_sar (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_address (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_balance (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_origin (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_caller (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_callvalue (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_calldataload (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_calldatasize (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_codesize (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_gasprice (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_extcodesize (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_returndatasize (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_extcodehash (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_blockhash (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_coinbase (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_timestamp (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_number (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_difficulty (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_gaslimit (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_chainid (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_selfbalance (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_basefee (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.

Definition evm_stack_opm : stack_op_instr_map :=
  ADD |->i OpImp 2 evm_add (Some add_comm);
  MUL |->i OpImp 2 evm_mul None;
  SUB |->i OpImp 2 evm_sub None;
  DIV |->i OpImp 2 evm_div None;
  SDIV |->i OpImp 2 evm_sdiv None;
  MOD |->i OpImp 2 evm_mod None;
  SMOD |->i OpImp 2 evm_smod None;
  ADDMOD |->i OpImp 3 evm_addmod None;
  MULMOD |->i  OpImp 3 evm_mulmod None;
  EXP |->i OpImp 2 evm_exp None;
  SIGNEXTEND  |->i OpImp 2 evm_signextend None;
  LT |->i OpImp 2 evm_lt None;
  GT  |->i OpImp 2 evm_gt None;
  SLT |->i OpImp 2 evm_slt None;
  SGT |->i  OpImp 2 evm_sgt None;
  EQ |->i OpImp 2 evm_eq None;
  ISZERO |->i OpImp  1 evm_iszero None;
  AND |->i OpImp 2 evm_and None;
  OR |->i OpImp 2  evm_or None;
  XOR |->i OpImp 2 evm_xor None;
  NOT |->i OpImp 1 evm_not  None;
  BYTE |->i OpImp 2 evm_byte None;
  SHL |->i OpImp 2 evm_shl  None;
  SHR |->i OpImp 2 evm_shr None;
  SAR |->i OpImp 2 evm_sar None;
  ADDRESS |->i OpImp 0 evm_address None;
  BALANCE |->i OpImp 1  evm_balance None;
  ORIGIN |->i OpImp 0 evm_origin None;
  CALLER |->i  OpImp 0 evm_caller None;
  CALLVALUE |->i OpImp 0 evm_callvalue None;
  CALLDATALOAD |->i OpImp 1 evm_calldataload None;
  CALLDATASIZE |->i  OpImp 0 evm_calldatasize None;
  CODESIZE |->i OpImp 0 evm_codesize  None;
  GASPRICE |->i OpImp 0 evm_gasprice None;
  EXTCODESIZE |->i  OpImp 1 evm_extcodesize None;
  RETURNDATASIZE |->i OpImp 0  evm_returndatasize None;
  EXTCODEHASH |->i OpImp 1 evm_extcodehash  None;
  BLOCKHASH |->i OpImp 1 evm_blockhash None;
  COINBASE |->i OpImp  0 evm_coinbase None;
  TIMESTAMP |->i OpImp 0 evm_timestamp None;
  NUMBER |->i OpImp 0 evm_number None;
  DIFFICULTY |->i OpImp 0  evm_difficulty None;
  GASLIMIT |->i OpImp 0 evm_gaslimit None;
  CHAINID |->i OpImp 0 evm_chainid None;
  SELFBALANCE |->i OpImp 0  evm_selfbalance None;
  BASEFEE |->i OpImp 0 evm_basefee None.
 


End StackOpInstrs.

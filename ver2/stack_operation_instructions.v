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

Definition ctx_independent_op (f : context -> list EVMWord -> EVMWord) : Prop :=
  forall (l : list EVMWord) (ctx1 ctx2 : context), f ctx1 l = f ctx2 l.


(* An implementation of a stack operation instructions *)
Inductive stack_op_impl :=
| OpImp (n : nat) (f : context -> list EVMWord -> EVMWord) (H_comm : option (commutative_op f)) (H_ctx_ind: option (ctx_independent_op f)).


Definition stack_op_instr_map := map stack_op_instr stack_op_impl.

Definition empty_imap {A : Type} (def : A) : map stack_op_instr A :=
  (fun _ =>  def).

Definition updatei {A : Type} (m : map stack_op_instr A) (x : stack_op_instr) (v : A) :=
  fun x' => if x =?i x' then v else m x'.

Notation "x '|->i' v ';' m" := (updatei m x v) (at level 100, v at next level, right associativity).
Notation "x '|->i' v" := (updatei (empty_imap (OpImp 0 (fun (_:context) (_:list EVMWord) => WZero) None None)) x v) (at level 100).






(* =================================================================
*) (** ** Implementation of current instructions *)


Ltac comm_op_tac_trivial f H_comm_of_underlying_op :=
  unfold commutative_op;
  intros;
  unfold f;
  rewrite -> H_comm_of_underlying_op;
  reflexivity.

Ltac ctx_independent_tac f :=
  unfold ctx_independent_op;
  intros;
  unfold f;
  reflexivity.


Definition evm_add (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wplus a b
  | _ => WZero
  end.
Lemma add_comm: commutative_op evm_add.
Proof.
  comm_op_tac_trivial evm_add wplus_comm.
Qed.
Lemma add_ctx_ind: ctx_independent_op evm_add.
Proof.
  ctx_independent_tac evm_add.
Qed.

Definition evm_mul (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wmult a b
  | _ => WZero
  end.
Lemma mul_comm: commutative_op evm_mul.
Proof.
  comm_op_tac_trivial evm_mul wmult_comm.
Qed.
Lemma mul_ctx_ind: ctx_independent_op evm_mul.
Proof.
  ctx_independent_tac evm_mul.
Qed.


Definition evm_sub (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wminus a b
  | _ => WZero
  end.

Lemma sub_ctx_ind: ctx_independent_op evm_sub.
Proof.
  ctx_independent_tac evm_sub.
Qed.


Definition evm_div (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wdiv a b
  | _ => WZero
  end.
Lemma div_ctx_ind: ctx_independent_op evm_div.
Proof.
  ctx_independent_tac evm_div.
Qed.


Definition evm_sdiv (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.


Definition evm_mod (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wmod a b
  | _ => WZero
  end.
  
Lemma mod_ctx_ind: ctx_independent_op evm_mod.
Proof.
  ctx_independent_tac evm_mod.
Qed.


Definition evm_smod (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.



Definition evm_addmod (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b;c] => wmod (wplus a b) c
  | _ => WZero
  end.
Lemma addmod_ctx_ind: ctx_independent_op evm_addmod.
Proof.
  ctx_independent_tac evm_addmod.
Qed.

Definition evm_mulmod (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b;c] => wmod (wmult a b) c
  | _ => WZero
  end.
Lemma mulmod_ctx_ind: ctx_independent_op evm_mulmod.
Proof.
  ctx_independent_tac evm_mulmod.
Qed.


Definition evm_exp (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => NToWord EVMWordSize (N.pow (wordToN a) (wordToN b))
  | _ => WZero
  end.
Lemma exp_ctx_ind: ctx_independent_op evm_exp.
Proof.
  ctx_independent_tac evm_exp.
Qed.


Definition evm_signextend (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.


Definition evm_lt (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => if (N.ltb (wordToN a) (wordToN b)) then WOne else WZero
  | _ => WZero
  end.
Lemma lt_ctx_ind: ctx_independent_op evm_lt.
Proof.
  ctx_independent_tac evm_lt.
Qed.


Definition evm_gt (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => evm_lt ctx [b; a]
  | _ => WZero
  end.
Lemma gt_ctx_ind: ctx_independent_op evm_gt.
Proof.
  ctx_independent_tac evm_gt.
Qed.


Definition evm_slt (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.


Definition evm_sgt (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.


Definition evm_eq (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => if weqb a b then WOne else WZero
  | _ => WZero
  end.
Lemma eq_comm: commutative_op evm_eq.
Proof.
unfold commutative_op. intros a b ctx.
unfold evm_eq. 
destruct (weqb a b) eqn: eq_weqb_a_b.
- apply weqb_sound in eq_weqb_a_b.
  symmetry in eq_weqb_a_b.
  rewrite <- weqb_true_iff in eq_weqb_a_b.
  rewrite -> eq_weqb_a_b.
  reflexivity.
- apply weqb_false in eq_weqb_a_b.
  apply not_eq_sym in eq_weqb_a_b.
  apply weqb_ne in eq_weqb_a_b.
  rewrite -> eq_weqb_a_b.
  reflexivity.
Qed.
Lemma eq_ctx_ind: ctx_independent_op evm_eq.
Proof.
  ctx_independent_tac evm_eq.
Qed.

  
Definition evm_iszero (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a] => evm_eq ctx [a; WZero]
  | _ => WZero
  end.
Lemma iszero_ctx_ind: ctx_independent_op evm_iszero.
Proof.
  ctx_independent_tac evm_iszero.
Qed.


Definition evm_and (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wand a b
  | _ => WZero
  end.
Lemma and_comm: commutative_op evm_and.
Proof.
  comm_op_tac_trivial evm_and wand_comm.
Qed.
Lemma and_ctx_ind: ctx_independent_op evm_and.
Proof.
  ctx_independent_tac evm_and.
Qed.


Definition evm_or (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wor a b
  | _ => WZero
  end.
Lemma or_comm: commutative_op evm_or.
Proof.
  comm_op_tac_trivial evm_or wor_comm.
Qed.
Lemma or_ctx_ind: ctx_independent_op evm_or.
Proof.
  ctx_independent_tac evm_or.
Qed.


Definition evm_xor (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wxor a b
  | _ => WZero
  end.
Lemma xor_comm: commutative_op evm_xor.
Proof.
  comm_op_tac_trivial evm_xor wxor_comm.
Qed.
Lemma xor_ctx_ind: ctx_independent_op evm_xor.
Proof.
  ctx_independent_tac evm_xor.
Qed.


Definition evm_not (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a] => wnot a
  | _ => WZero
  end.
Lemma not_ctx_ind: ctx_independent_op evm_not.
Proof.
  ctx_independent_tac evm_not.
Qed.


Definition evm_byte (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.


Definition evm_shl (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wlshift b (wordToNat a)
  | _ => WZero
  end.
Lemma shl_ctx_ind: ctx_independent_op evm_shl.
Proof.
  ctx_independent_tac evm_shl.
Qed.


Definition evm_shr (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wrshift' b (wordToNat a)
  | _ => WZero
  end.
Lemma shr_ctx_ind: ctx_independent_op evm_shr.
Proof.
  ctx_independent_tac evm_shr.
Qed.


Definition evm_sar (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.



Definition evm_address (ctx : context) (args : list EVMWord) : EVMWord :=
let diff := EVMWordSize - EVMAddrSize in
zext (get_address_ctx ctx) diff.


Definition evm_balance (ctx : context) (args : list EVMWord) : EVMWord :=
  match args with
  | [a] => let diff := EVMWordSize - EVMAddrSize in
           let address := split1 EVMAddrSize diff a in
           (get_balance_ctx ctx) address
  | _ => WZero
  end.


Definition evm_origin (ctx : context) (args : list EVMWord) : EVMWord :=
let diff := EVMWordSize - EVMAddrSize in
zext (get_origin_ctx ctx) diff.


Definition evm_caller (ctx : context) (args : list EVMWord) : EVMWord :=
let diff := EVMWordSize - EVMAddrSize in
zext (get_caller_ctx ctx) diff.


Definition evm_callvalue (ctx : context) (args : list EVMWord) : EVMWord :=
get_callvalue_ctx ctx.


Definition evm_calldataload (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.


Definition evm_calldatasize (ctx : context) (args : list EVMWord) : EVMWord :=
match get_data_ctx ctx with
| Chunk size data => natToWord EVMWordSize size
end.


Definition evm_codesize (ctx : context) (args : list EVMWord) : EVMWord :=
let address := get_address_ctx ctx in
let info := (get_code_ctx ctx) address in
match info with 
| CodeInfo size content hash => natToWord EVMWordSize size
end.


Definition evm_gasprice (ctx : context) (args : list EVMWord) : EVMWord :=
get_gasprice_ctx ctx.


Definition evm_extcodesize (ctx : context) (args : list EVMWord) : EVMWord :=
match args with
| [a] => let diff := EVMWordSize - EVMAddrSize in
         let address := split1 EVMAddrSize diff a in
         let info := (get_code_ctx ctx) address in
         match info with 
         | CodeInfo size content hash => natToWord EVMWordSize size
         end
| _ => WZero
end.


Definition evm_returndatasize (ctx : context) (args : list EVMWord) : EVMWord :=
match get_outdata_ctx ctx with
| Chunk size data => natToWord EVMWordSize size
end.


Definition evm_extcodehash (ctx : context) (args : list EVMWord) : EVMWord :=
match args with
| [a] => let diff := EVMWordSize - EVMAddrSize in
         let address := split1 EVMAddrSize diff a in
         let info := (get_code_ctx ctx) address in
         match info with 
         | CodeInfo size content hash => hash
         end
| _ => WZero
end.


Definition evm_blockhash (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.


Definition evm_coinbase (ctx : context) (args : list EVMWord) : EVMWord :=
let diff := EVMWordSize - EVMAddrSize in
zext (get_miner_ctx ctx) diff.


Definition evm_timestamp (ctx : context) (args : list EVMWord) : EVMWord :=
let curr_block := get_currblock_ctx ctx in
let info := (get_blocks_ctx ctx) curr_block in
match info with 
| BlockInfo size content timestamp hash => timestamp
end.


Definition evm_number (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.


Definition evm_difficulty (ctx : context) (args : list EVMWord) : EVMWord :=
  WZero.
  

Definition evm_gaslimit (ctx : context) (args : list EVMWord) : EVMWord :=
get_gaslimit_ctx ctx.


Definition evm_chainid (ctx : context) (args : list EVMWord) : EVMWord :=
get_chainid_ctx ctx.


Definition evm_selfbalance (ctx : context) (args : list EVMWord) : EVMWord :=
let address := get_address_ctx ctx in
(get_balance_ctx ctx) address.


Definition evm_basefee (ctx : context) (args : list EVMWord) : EVMWord :=
get_basefee_ctx ctx.


Definition evm_stack_opm : stack_op_instr_map :=
  ADD |->i OpImp 2 evm_add (Some add_comm) (Some add_ctx_ind);
  MUL |->i OpImp 2 evm_mul (Some mul_comm) (Some mul_ctx_ind);
  SUB |->i OpImp 2 evm_sub None (Some sub_ctx_ind);
  DIV |->i OpImp 2 evm_div None (Some div_ctx_ind);
  SDIV |->i OpImp 2 evm_sdiv None None; (*TODO*)
  MOD |->i OpImp 2 evm_mod None (Some mod_ctx_ind);
  SMOD |->i OpImp 2 evm_smod None None; (*TODO*)
  ADDMOD |->i OpImp 3 evm_addmod None (Some addmod_ctx_ind);
  MULMOD |->i  OpImp 3 evm_mulmod None (Some mulmod_ctx_ind);
  EXP |->i OpImp 2 evm_exp None (Some exp_ctx_ind);
  SIGNEXTEND  |->i OpImp 2 evm_signextend None None; (*TODO*)
  LT |->i OpImp 2 evm_lt None (Some lt_ctx_ind);
  GT  |->i OpImp 2 evm_gt None (Some gt_ctx_ind);
  SLT |->i OpImp 2 evm_slt None None; (*TODO*)
  SGT |->i  OpImp 2 evm_sgt None None; (*TODO*)
  EQ |->i OpImp 2 evm_eq (Some eq_comm) (Some eq_ctx_ind);
  ISZERO |->i OpImp  1 evm_iszero None (Some iszero_ctx_ind);
  AND |->i OpImp 2 evm_and (Some and_comm) (Some and_ctx_ind);
  OR |->i OpImp 2  evm_or (Some or_comm) (Some or_ctx_ind);
  XOR |->i OpImp 2 evm_xor (Some xor_comm) (Some xor_ctx_ind);
  NOT |->i OpImp 1 evm_not  None (Some not_ctx_ind);
  BYTE |->i OpImp 2 evm_byte None None; (*TODO*)
  SHL |->i OpImp 2 evm_shl  None (Some shl_ctx_ind);
  SHR |->i OpImp 2 evm_shr None (Some shr_ctx_ind);
  SAR |->i OpImp 2 evm_sar None None; (*TODO*)
  ADDRESS |->i OpImp 0 evm_address None None;
  BALANCE |->i OpImp 1  evm_balance None None;
  ORIGIN |->i OpImp 0 evm_origin None None;
  CALLER |->i  OpImp 0 evm_caller None None;
  CALLVALUE |->i OpImp 0 evm_callvalue None None;
  CALLDATALOAD |->i OpImp 1 evm_calldataload None None; (*TODO*)
  CALLDATASIZE |->i  OpImp 0 evm_calldatasize None None;
  CODESIZE |->i OpImp 0 evm_codesize  None None;
  GASPRICE |->i OpImp 0 evm_gasprice None None; 
  EXTCODESIZE |->i  OpImp 1 evm_extcodesize None None;
  RETURNDATASIZE |->i OpImp 0  evm_returndatasize None None;
  EXTCODEHASH |->i OpImp 1 evm_extcodehash  None None;
  BLOCKHASH |->i OpImp 1 evm_blockhash None None; (*TODO*)
  COINBASE |->i OpImp  0 evm_coinbase None None;
  TIMESTAMP |->i OpImp 0 evm_timestamp None None;
  NUMBER |->i OpImp 0 evm_number None None; (*TODO*)
  DIFFICULTY |->i OpImp 0  evm_difficulty None None; (*TODO*)
  GASLIMIT |->i OpImp 0 evm_gaslimit None None;
  CHAINID |->i OpImp 0 evm_chainid None None;
  SELFBALANCE |->i OpImp 0  evm_selfbalance None None;
  BASEFEE |->i OpImp 0 evm_basefee None None.
 


End StackOpInstrs.

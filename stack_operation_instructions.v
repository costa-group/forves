Require Import bbv.Word.

Require Import Coq.NArith.NArith.
Require Import Coq.ZArith.ZArith.

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
Definition commutative_op (f : externals -> list EVMWord -> EVMWord) : Prop :=
  forall (a b : EVMWord) (exts : externals), f exts [a;b] = f exts [b;a].

Definition exts_independent_op (f : externals -> list EVMWord -> EVMWord) : Prop :=
  forall (l : list EVMWord) (exts1 exts2 : externals), f exts1 l = f exts2 l.


(* An implementation of a stack operation instructions *)
Inductive stack_op_impl :=
| OpImp (n : nat) (f : externals -> list EVMWord -> EVMWord) (H_comm : option (commutative_op f)) (H_exts_ind: option (exts_independent_op f)).


Definition stack_op_instr_map := map stack_op_instr stack_op_impl.

Definition empty_imap {A : Type} (def : A) : map stack_op_instr A :=
  (fun _ =>  def).

Definition updatei {A : Type} (m : map stack_op_instr A) (x : stack_op_instr) (v : A) :=
  fun x' => if x =?i x' then v else m x'.

Notation "x '|->i' v ';' m" := (updatei m x v) (at level 100, v at next level, right associativity).
Notation "x '|->i' v" := (updatei (empty_imap (OpImp 0 (fun (_:externals) (_:list EVMWord) => WZero) None None)) x v) (at level 100).






(* =================================================================
*) (** ** Implementation of current instructions *)


Ltac comm_op_tac_trivial f H_comm_of_underlying_op :=
  unfold commutative_op;
  intros;
  unfold f;
  rewrite -> H_comm_of_underlying_op;
  reflexivity.

Ltac exts_independent_tac f :=
  unfold exts_independent_op;
  intros;
  unfold f;
  reflexivity.


Definition evm_add (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wplus a b
  | _ => WZero
  end.
Lemma add_comm: commutative_op evm_add.
Proof.
  comm_op_tac_trivial evm_add wplus_comm.
Qed.
Lemma add_exts_ind: exts_independent_op evm_add.
Proof.
  exts_independent_tac evm_add.
Qed.


Definition evm_mul (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wmult a b
  | _ => WZero
  end.
Lemma mul_comm: commutative_op evm_mul.
Proof.
  comm_op_tac_trivial evm_mul wmult_comm.
Qed.
Lemma mul_exts_ind: exts_independent_op evm_mul.
Proof.
  exts_independent_tac evm_mul.
Qed.


Definition evm_sub (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wminus a b
  | _ => WZero
  end.

Lemma sub_exts_ind: exts_independent_op evm_sub.
Proof.
  exts_independent_tac evm_sub.
Qed.


Definition evm_div (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wdiv a b
  | _ => WZero
  end.
Lemma div_exts_ind: exts_independent_op evm_div.
Proof.
  exts_independent_tac evm_div.
Qed.


Definition evm_sdiv (exts : externals) (args : list EVMWord) : EVMWord :=
  WZero.


Definition evm_mod (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => if weqb b WZero then WZero else wmod a b
  | _ => WZero
  end.
  
Lemma mod_exts_ind: exts_independent_op evm_mod.
Proof.
  exts_independent_tac evm_mod.
Qed.


Definition evm_smod (exts : externals) (args : list EVMWord) : EVMWord :=
  WZero.



Definition evm_addmod (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b;c] => wmod (wplus a b) c
  | _ => WZero
  end.
Lemma addmod_exts_ind: exts_independent_op evm_addmod.
Proof.
  exts_independent_tac evm_addmod.
Qed.


Definition evm_mulmod (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b;c] => wmod (wmult a b) c
  | _ => WZero
  end.
Lemma mulmod_exts_ind: exts_independent_op evm_mulmod.
Proof.
  exts_independent_tac evm_mulmod.
Qed.


Definition evm_exp (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wordBin N.pow a b
  | _ => WZero
  end.
Lemma exp_exts_ind: exts_independent_op evm_exp.
Proof.
  exts_independent_tac evm_exp.
Qed.


Definition evm_signextend (exts : externals) (args : list EVMWord) : EVMWord :=
  WZero.


Definition evm_lt (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => if (N.ltb (wordToN a) (wordToN b)) then WOne else WZero
  | _ => WZero
  end.
Lemma lt_exts_ind: exts_independent_op evm_lt.
Proof.
  exts_independent_tac evm_lt.
Qed.


Definition evm_gt (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => evm_lt exts [b; a]
  | _ => WZero
  end.
Lemma gt_exts_ind: exts_independent_op evm_gt.
Proof.
  exts_independent_tac evm_gt.
Qed.


Definition evm_slt (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a; b] => if (Z.ltb (wordToZ a) (wordToZ b)) then WOne else WZero
  | _ => WZero
  end.
Lemma slt_exts_ind: exts_independent_op evm_slt.
Proof.
  exts_independent_tac evm_slt.
Qed.


Definition evm_sgt (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => evm_slt exts [b; a]
  | _ => WZero
  end.
Lemma sgt_exts_ind: exts_independent_op evm_sgt.
Proof.
  exts_independent_tac evm_sgt.
Qed.


Definition evm_eq (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => if weqb a b then WOne else WZero
  | _ => WZero
  end.
Lemma eq_comm: commutative_op evm_eq.
Proof.
unfold commutative_op. intros a b exts.
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
Lemma eq_exts_ind: exts_independent_op evm_eq.
Proof.
  exts_independent_tac evm_eq.
Qed.

  
Definition evm_iszero (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a] => evm_eq exts [a; WZero]
  | _ => WZero
  end.
Lemma iszero_exts_ind: exts_independent_op evm_iszero.
Proof.
  exts_independent_tac evm_iszero.
Qed.


Definition evm_and (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wand a b
  | _ => WZero
  end.
Lemma and_comm: commutative_op evm_and.
Proof.
  comm_op_tac_trivial evm_and wand_comm.
Qed.
Lemma and_exts_ind: exts_independent_op evm_and.
Proof.
  exts_independent_tac evm_and.
Qed.


Definition evm_or (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wor a b
  | _ => WZero
  end.
Lemma or_comm: commutative_op evm_or.
Proof.
  comm_op_tac_trivial evm_or wor_comm.
Qed.
Lemma or_exts_ind: exts_independent_op evm_or.
Proof.
  exts_independent_tac evm_or.
Qed.


Definition evm_xor (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wxor a b
  | _ => WZero
  end.
Lemma xor_comm: commutative_op evm_xor.
Proof.
  comm_op_tac_trivial evm_xor wxor_comm.
Qed.
Lemma xor_exts_ind: exts_independent_op evm_xor.
Proof.
  exts_independent_tac evm_xor.
Qed.


Definition evm_not (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a] => wnot a
  | _ => WZero
  end.
Lemma not_exts_ind: exts_independent_op evm_not.
Proof.
  exts_independent_tac evm_not.
Qed.


Definition evm_byte (exts : externals) (args : list EVMWord) : EVMWord :=
  WZero.


Definition evm_shl (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wordBin N.shiftl b a
  (*| [a;b] => wlshift' b (wordToNat a) *)
  (*| [shift;value] => NToWord EVMWordSize (N.shiftl (wordToN value) (wordToN shift))*)
  | _ => WZero
  end.
Lemma shl_exts_ind: exts_independent_op evm_shl.
Proof.
  exts_independent_tac evm_shl.
Qed.


(* Equivalent definition better suited for the DIV_SHL optimization *)
Definition evm_shr (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wordBin N.shiftr b a
  (*| [shift;value] => wdiv value (wlshift' WOne (wordToNat shift)) *)
  (*| [shift;value] => NToWord EVMWordSize (N.shiftl (wordToN value) (wordToN shift))*)
  | _ => WZero
  end.
(*
Definition evm_shr (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a;b] => wrshift' b (wordToNat a)
  | _ => WZero
  end.*)
Lemma shr_exts_ind: exts_independent_op evm_shr.
Proof.
  exts_independent_tac evm_shr.
Qed.


Definition evm_sar (exts : externals) (args : list EVMWord) : EVMWord :=
  WZero.


Definition evm_address (exts : externals) (args : list EVMWord) : EVMWord :=
let diff := EVMWordSize - EVMAddrSize in
zext (get_address_exts exts) diff.


Definition evm_balance (exts : externals) (args : list EVMWord) : EVMWord :=
  match args with
  | [a] => let diff := EVMWordSize - EVMAddrSize in
           let address := split1 EVMAddrSize diff a in
           (get_balance_exts exts) address
  | _ => WZero
  end.


Definition evm_origin (exts : externals) (args : list EVMWord) : EVMWord :=
let diff := EVMWordSize - EVMAddrSize in
zext (get_origin_exts exts) diff.


Definition evm_caller (exts : externals) (args : list EVMWord) : EVMWord :=
let diff := EVMWordSize - EVMAddrSize in
zext (get_caller_exts exts) diff.


Definition evm_callvalue (exts : externals) (args : list EVMWord) : EVMWord :=
get_callvalue_exts exts.


Definition evm_calldataload (exts : externals) (args : list EVMWord) : EVMWord :=
  WZero.


Definition evm_calldatasize (exts : externals) (args : list EVMWord) : EVMWord :=
match get_data_exts exts with
| Chunk size data => natToWord EVMWordSize size
end.


Definition evm_codesize (exts : externals) (args : list EVMWord) : EVMWord :=
let address := get_address_exts exts in
let info := (get_code_exts exts) address in
match info with 
| CodeInfo size content hash => natToWord EVMWordSize size
end.


Definition evm_gasprice (exts : externals) (args : list EVMWord) : EVMWord :=
get_gasprice_exts exts.


Definition evm_extcodesize (exts : externals) (args : list EVMWord) : EVMWord :=
match args with
| [a] => let diff := EVMWordSize - EVMAddrSize in
         let address := split1 EVMAddrSize diff a in
         let info := (get_code_exts exts) address in
         match info with 
         | CodeInfo size content hash => natToWord EVMWordSize size
         end
| _ => WZero
end.


Definition evm_returndatasize (exts : externals) (args : list EVMWord) : EVMWord :=
match get_outdata_exts exts with
| Chunk size data => natToWord EVMWordSize size
end.


Definition evm_extcodehash (exts : externals) (args : list EVMWord) : EVMWord :=
match args with
| [a] => let diff := EVMWordSize - EVMAddrSize in
         let address := split1 EVMAddrSize diff a in
         let info := (get_code_exts exts) address in
         match info with 
         | CodeInfo size content hash => hash
         end
| _ => WZero
end.


Definition evm_blockhash (exts : externals) (args : list EVMWord) : EVMWord :=
  WZero.


Definition evm_coinbase (exts : externals) (args : list EVMWord) : EVMWord :=
let diff := EVMWordSize - EVMAddrSize in
zext (get_miner_exts exts) diff.


Definition evm_timestamp (exts : externals) (args : list EVMWord) : EVMWord :=
let curr_block := get_currblock_exts exts in
let info := (get_blocks_exts exts) curr_block in
match info with 
| BlockInfo size content timestamp hash => timestamp
end.


Definition evm_number (exts : externals) (args : list EVMWord) : EVMWord :=
  WZero.


Definition evm_difficulty (exts : externals) (args : list EVMWord) : EVMWord :=
  WZero.
  

Definition evm_gaslimit (exts : externals) (args : list EVMWord) : EVMWord :=
get_gaslimit_exts exts.


Definition evm_chainid (exts : externals) (args : list EVMWord) : EVMWord :=
get_chainid_exts exts.


Definition evm_selfbalance (exts : externals) (args : list EVMWord) : EVMWord :=
let address := get_address_exts exts in
(get_balance_exts exts) address.


Definition evm_basefee (exts : externals) (args : list EVMWord) : EVMWord :=
get_basefee_exts exts.

Definition evm_gas (exts : externals) (args : list EVMWord) : EVMWord :=
  WZero.
Lemma gas_exts_ind: exts_independent_op evm_gas.
Proof.
  exts_independent_tac evm_gas.
Qed.

Definition evm_jumpi (exts : externals) (args: list EVMWord) : EVMWord :=
match args with
 | [a; b] => if weqb b WZero then WZero else a
 | _ => WZero
 end.
Lemma jumpi_exts_ind: exts_independent_op evm_jumpi.
Proof.
  exts_independent_tac evm_jumpi.
Qed.

Definition evm_prevrando (exts : externals) (args: list EVMWord) : EVMWord :=
  (get_prevrandao_exts exts).


Definition evm_stack_opm : stack_op_instr_map :=
  ADD |->i OpImp 2 evm_add (Some add_comm) (Some add_exts_ind);
  MUL |->i OpImp 2 evm_mul (Some mul_comm) (Some mul_exts_ind);
  SUB |->i OpImp 2 evm_sub None (Some sub_exts_ind);
  DIV |->i OpImp 2 evm_div None (Some div_exts_ind);
  SDIV |->i OpImp 2 evm_sdiv None None; (*TODO*)
  MOD |->i OpImp 2 evm_mod None (Some mod_exts_ind);
  SMOD |->i OpImp 2 evm_smod None None; (*TODO*)
  ADDMOD |->i OpImp 3 evm_addmod None (Some addmod_exts_ind);
  MULMOD |->i  OpImp 3 evm_mulmod None (Some mulmod_exts_ind);
  EXP |->i OpImp 2 evm_exp None (Some exp_exts_ind);
  SIGNEXTEND  |->i OpImp 2 evm_signextend None None; (*TODO*)
  LT |->i OpImp 2 evm_lt None (Some lt_exts_ind);
  GT  |->i OpImp 2 evm_gt None (Some gt_exts_ind);
  SLT |->i OpImp 2 evm_slt None (Some slt_exts_ind);
  SGT |->i  OpImp 2 evm_sgt None (Some sgt_exts_ind);
  EQ |->i OpImp 2 evm_eq (Some eq_comm) (Some eq_exts_ind);
  ISZERO |->i OpImp  1 evm_iszero None (Some iszero_exts_ind);
  AND |->i OpImp 2 evm_and (Some and_comm) (Some and_exts_ind);
  OR |->i OpImp 2  evm_or (Some or_comm) (Some or_exts_ind);
  XOR |->i OpImp 2 evm_xor (Some xor_comm) (Some xor_exts_ind);
  NOT |->i OpImp 1 evm_not  None (Some not_exts_ind);
  BYTE |->i OpImp 2 evm_byte None None; (*TODO*)
  SHL |->i OpImp 2 evm_shl  None (Some shl_exts_ind);
  SHR |->i OpImp 2 evm_shr None (Some shr_exts_ind);
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
  BASEFEE |->i OpImp 0 evm_basefee None None;
  GAS |->i OpImp 0 evm_gas None (Some gas_exts_ind);
  JUMPI |->i OpImp 2 evm_jumpi None (Some jumpi_exts_ind);
  PREVRANDAO |->i OpImp 0 evm_prevrando None None.
 


End StackOpInstrs.

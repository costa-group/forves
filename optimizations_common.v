Require Import bbv.Word.
Require Import Nat. 
Require Import Coq.NArith.NArith.
Require Import Coq.Bool.Bool.

Require Import Coq.Logic.FunctionalExtensionality.

Require Import FORVES.constants.
Import Constants.

Require Import FORVES.symbolic_state.
Import SymbolicState.

Require Import FORVES.symbolic_state_eval.
Import SymbolicStateEval.

Require Import FORVES.symbolic_state_cmp.
Import SymbolicStateCmp.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.execution_state.
Import ExecutionState.

Require Import FORVES.stack_operation_instructions.
Import StackOpInstrs.

Require Import FORVES.program.
Import Program.

Require Import FORVES.symbolic_state_cmp_impl.
Import SymbolicStateCmpImpl.

Require Import FORVES.symbolic_state_eval_facts.
Import SymbolicStateEvalFacts.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.misc.
Import Misc.

Require Import FORVES.eval_common.
Import EvalCommon.

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import Coq.Program.Equality.
(* For dependent induction and dependent destruction *)


Require Import List.
Import ListNotations.


Module Optimizations_Common.


Definition follow_to_val (sv: sstack_val) (maxidx: nat) (sb: sbindings) 
  : option EVMWord :=
match follow_in_smap sv maxidx sb with
| Some (FollowSmapVal (SymBasicVal (Val v)) idx' sb') => Some v
| _ => None
end.


Definition follow_to_val_args (args: sstack) (maxidx: nat) (sb: sbindings) 
  : option (list EVMWord) :=
let f_follow_list := fun (sv': sstack_val) => follow_to_val sv' maxidx sb in
map_option f_follow_list args.



(**************************************
   Auxiliary results about evaluation 
   used when proving optimizations 
**************************************)


(*************************************************)
(* Results about bitvectors                      *)
(*************************************************)

Lemma zext_split1: forall [sz : nat] (w : word sz) (n : nat), 
split1 sz n (zext w n) = w.
Proof.
intros. unfold zext. 
rewrite -> split1_combine.
reflexivity.
Qed.

Lemma wxor_x_x: forall (size: nat) (x: word size), wxor x x = wzero size.
Proof. 
dependent induction x.
- reflexivity.
- unfold wxor. unfold bitwp. simpl.
  rewrite -> Bool.xorb_nilpotent.
  fold bitwp. fold wxor.
  rewrite -> IHx.
  unfold wzero. unfold natToWord. simpl. fold natToWord.
  reflexivity.
Qed.

Lemma wand_x_x: forall (x: EVMWord),
wand x x = x.
Proof.
induction x as [|b n x' IH].
- reflexivity.
- unfold wand. simpl. fold wand.
  rewrite -> andb_diag.
  rewrite -> IH.
  reflexivity.
Qed.

Lemma wor_x_x: forall (x: EVMWord),
wor x x = x.
Proof.
induction x as [|b n x' IH].
- reflexivity.
- unfold wor. simpl. fold wor.
  rewrite -> orb_diag.
  rewrite -> IH.
  reflexivity.
Qed.

Lemma wones_evm:
wones EVMWordSize = 
  (WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true 
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true 
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true 
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true 
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true 
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true 
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true 
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true 
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true 
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true 
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true 
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true 
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true 
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true 
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true 
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true
(WS true (WS true (WS true (WS true (WS true (WS true (WS true (WS true WO
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
))))))))))))))))))))))))))))))))))))))))))).
Proof. reflexivity. Qed.

Definition two_exp_160_minus_1 : EVMWord := 
let diff := EVMWordSize - EVMAddrSize in
zext (wones EVMAddrSize) diff.

Lemma two_exp_160_minus_1_ok: wordToN two_exp_160_minus_1 = (Npow2 160 - 1)%N.
Proof.
reflexivity.
Qed.

Lemma two_exp_160_minus_1_ok': 
two_exp_160_minus_1 = wminus (wordBin N.pow (natToWord EVMWordSize 2)
                                     (natToWord EVMWordSize 160))
                             WOne.
Proof.
reflexivity.
Qed.


(* Distribution of wand over combine *)
Lemma wand_combine: forall (n1 n2: nat) (w1 w1': word n1) 
  (w2 w2': word n2), 
wand
  (Word.combine w1 w2)
  (Word.combine w1' w2') =
Word.combine (wand w1 w1') 
             (wand w2 w2').
Proof.
dependent induction w1.
- intros. simpl.
  dependent destruction w1'. simpl. reflexivity.
- intros. simpl. 
  dependent destruction w1'. simpl.
  unfold wand. simpl.
  fold wand.
  rewrite -> IHw1.
  reflexivity.
Qed.

(* Specialized version of wand_combine for the specific sizes *)
Lemma wand_combine_spec: forall w1 w2 w1' w2', 
@wand EVMWordSize 
  (@Word.combine EVMAddrSize w1 (EVMWordSize - EVMAddrSize) w2)
  (@Word.combine EVMAddrSize w1' (EVMWordSize - EVMAddrSize) w2') =
(@Word.combine EVMAddrSize (wand w1 w1') 
              (EVMWordSize - EVMAddrSize) (wand w2 w2')).
Proof.
intros w1 w2 w1' w2'.
rewrite <- wand_combine.
reflexivity.
Qed.


Lemma masking_address_extension_word: forall (w: word EVMAddrSize), 
  (zext w (EVMWordSize - EVMAddrSize)) =
  (@wand EVMWordSize
     (@zext EVMAddrSize w (EVMWordSize - EVMAddrSize))
     (@zext EVMAddrSize (wones EVMAddrSize) (EVMWordSize - EVMAddrSize))).
Proof.
intros w. unfold zext.
rewrite -> wand_combine_spec.
rewrite wand_comm.
rewrite wand_wones.
rewrite wand_wzero.
reflexivity.
Qed.


Lemma pow2_shl: forall x,
wlshift WOne x = natToWord EVMWordSize (2 ^ x).
Proof.
induction x as [|x' IH].
- simpl. rewrite -> wlshift_0. reflexivity.
- rewrite -> wlshift_mul_pow2. 
  rewrite -> wmult_unit.
  reflexivity.
Qed.


Lemma pow2_shl': forall x,
wlshift' WOne x = natToWord EVMWordSize (2 ^ x).
Proof.
intros x.
rewrite -> wlshift_alt.
apply pow2_shl.
Qed.



(*************************************************)
(* Results about operations in N                 *)
(*************************************************)
Lemma wordToN_one: wordToN WOne = 1%N.
Proof.
unfold WOne. unfold wordToN. unfold NToWord. simpl.
reflexivity.
Qed.


Lemma Npow2_EVMWordSize: Npow2 EVMWordSize = (2 ^ (N.of_nat EVMWordSize))%N.
Proof.
intuition.
Qed.


Lemma pow2_pos: forall (x: N), (0 < 2 ^ x)%N.
Proof.
intros x.
destruct x; try apply N.lt_0_1.
Qed.


Lemma NToWord_0: forall (n: nat), NToWord n 0 = wzero n.
Proof.
intros n.
unfold NToWord.
rewrite -> wzero'_def.
reflexivity.
Qed.


Lemma NToWord_multiple: forall (x: N) (n: nat),
NToWord n (Npow2 n * x) = wzero n.
Proof.
intros x n.
rewrite -> N.mul_comm.
rewrite <- drop_sub_N with (k:=x); try apply N.le_refl.
rewrite -> N.sub_diag.
rewrite -> NToWord_0.
reflexivity.
Qed.


Lemma diff_wzero_pos: forall (x: EVMWord), x <> WZero -> (0 < wordToN x)%N.
Proof.
intros x H.
apply wordToNat_nonZero in H.
destruct (wordToNat x) as [|x'] eqn: eq_x.
- intuition.
- rewrite -> wordToN_nat.
  rewrite -> eq_x.
  rewrite -> Nat2N.inj_succ.
  apply N.lt_0_succ.
Qed.


Lemma Ndiv_zero: forall (x: N), N.div x 0 = 0%N.
Proof.
intros x.
unfold N.div.
unfold N.div_eucl.
destruct x as [| x'] eqn: eq_x; try reflexivity.
Qed.


(*************************************************)
(* Steps in EVM operations                       *)
(*************************************************)
Lemma evm_shl_step: forall (exts: externals) (x y: EVMWord),
evm_shl exts [y; x] = wordBin N.shiftl x y.
Proof.
intros exts x y.
unfold evm_shl.
reflexivity.
Qed. 

Lemma evm_mul_step: forall (exts: externals) (x y: EVMWord),
evm_mul exts [x; y] = wmult x y.
Proof. 
intuition.
Qed.

Lemma evm_shr_step: forall (exts: externals) (x y: EVMWord),
evm_shr exts [y; x] = wordBin N.shiftr x y.
Proof.
intros exts x y.
unfold evm_shr.
reflexivity.
Qed. 

Lemma evm_div_step: forall (exts: externals) (x y: EVMWord),
evm_div exts [x; y] = wdiv x y.
Proof. 
intuition.
Qed.


(*************************************************)
(* Miscellaneous results                         *)
(*************************************************)

Lemma evm_stack_opm_SELFBALANCE: 
evm_stack_opm SELFBALANCE = OpImp 0 evm_selfbalance None None.
Proof.
reflexivity.
Qed.

Lemma evm_stack_opm_EQ: 
evm_stack_opm EQ = OpImp 2 evm_eq (Some eq_comm) (Some eq_exts_ind).
Proof.
intuition.
Qed.

Lemma evm_stack_opm_GT: 
evm_stack_opm GT = OpImp 2 evm_gt None (Some gt_exts_ind).
Proof.
intuition.
Qed.

Lemma evm_stack_opm_ISZERO: 
evm_stack_opm ISZERO = OpImp  1 evm_iszero None (Some iszero_exts_ind).
Proof.
intuition.
Qed.

Lemma evm_stack_opm_LT: 
evm_stack_opm LT = OpImp 2 evm_lt None (Some lt_exts_ind).
Proof.
intuition.
Qed.

Lemma length_zero: forall {X: Type}, length ([]: list X) =? 0 = true.
Proof.
intuition.
Qed.

Lemma length_one: forall {X: Type} (v: X), length [v] =? 1 = true.
Proof.
intuition.
Qed.

Lemma length_two: forall {T: Type} (x y: T), (length [x; y] =? 2) = true.
Proof.
intros T x y.
reflexivity.
Qed.

Lemma gt_iszero_nat: forall (x: nat),
x < 1 <-> x = 0.
Proof.
intros. intuition. 
Qed.

Lemma one_as_N:
N.to_nat (1)%N = 1.
Proof. auto. Qed.

Lemma gt_iszero_nat': forall (x: nat),
x >= 1 <-> x <> 0.
Proof.
intros. intuition. 
Qed.

Lemma word_neq_zero: forall (x: EVMWord),
N.to_nat (wordToN x) <> 0 -> x <> WZero.
Proof.
intros. destruct (weqb x WZero) eqn: eq_x_wzero.
- apply weqb_sound in eq_x_wzero. rewrite eq_x_wzero in H.
  simpl in H. auto.
- apply weqb_false. assumption.
Qed.

Lemma is_fresh_var_smv_fvar: forall fvar,
is_fresh_var_smv (SymBasicVal (FreshVar fvar)) = Some fvar.
Proof.
intuition.
Qed.

Lemma map_option_empty: forall {A B : Type} (f : A -> option B),
map_option f [] = Some [].
Proof.
intuition.
Qed.

Lemma map_option_preserv_functs: forall {A B : Type} (f g: A -> option B) (l: list A)
  (rl: list B),
map_option f l = Some rl ->
(forall x r, f x = Some r -> g x = Some r) ->
map_option g l = Some rl.
Proof.
intros A B f g l.
induction l as [|h t IH].
- intuition.
- intros rl Hmap_f Heq_f_g.
  simpl. simpl in Hmap_f.
  destruct (f h) as [eh|] eqn: eq_f_h; try discriminate.
  apply Heq_f_g in eq_f_h.
  rewrite -> eq_f_h.
  destruct (map_option f t) as [et|] eqn: eq_map_t; try discriminate.
  rewrite <- eq_map_t in IH.
  pose proof (IH et eq_map_t Heq_f_g) as eq_map_g_t. 
  rewrite -> eq_map_g_t. 
  assumption.
Qed.

Lemma some_is_not_none: forall {T: Type} (x: option T) (v: T),
x = Some v -> x <> None.
Proof.
intros T x v Hx.
rewrite -> Hx.
intuition.
discriminate.
Qed.

(* Macro to reduce some proofs like optimize_add_0_sbinding_snd *)
Ltac inject_rw H eqname:= 
injection H as eqname _;
rewrite <- eqname;
assumption.


Lemma gt_neq: forall n m, n > m -> n =? m = false.
Proof.
intros n m. revert n.
induction m as [|m' IH].
- intros n Hgt.
  destruct n as [|n']; try intuition.
- intros n Hgt. 
  destruct n as [|n'].
  + intuition.
  + simpl. apply Gt.gt_S_n in Hgt.
    intuition.
Qed.


Lemma is_fresh_var_some: forall v idx,
is_fresh_var_smv v = Some idx ->
v = SymBasicVal (FreshVar idx).
Proof.
intros v idx His_fresh.
destruct v; try (simpl in His_fresh; discriminate).
simpl in His_fresh.
destruct val as [v|var|fvar]; try discriminate.
injection His_fresh as eq_fvar.
rewrite -> eq_fvar.
reflexivity.
Qed.


Lemma leq_add: forall n m, 
n <= m -> exists k, n+k=m.
Proof.
intros n m. revert n.
induction m as [|m' IH].
- intros n Hleq. exists 0. intuition.
- intros n Hleq.
  destruct n as [|n'] eqn: eq_n.
  + exists (S m'). intuition.
  + apply Le.le_S_n in Hleq.
    apply IH in Hleq as [k' eq_n'_k'].
    exists k'. intuition.
Qed.


Lemma gt_add: forall n m, 
n > m -> exists k, n=m+k.
Proof.
intros n m. revert n.
induction m as [|m' IH].
- intros m Hgt. exists m. intuition.
- intros n Hgt.
  destruct n as [|n'] eqn: eq_n.
  + intuition.
  + apply Gt.gt_S_n in Hgt.
    apply IH in Hgt as [k' eq_n'_k'].
    exists k'. intuition.
Qed.


Lemma leq_diff_lt: forall n m,
n <= m -> n <> m -> n < m.
Proof.
intros n m Hleq Hdiff.
intuition.
Qed.



Lemma not_basic_value_smv_symop: forall label args,
not_basic_value_smv (SymOp label args) = true.
Proof.
reflexivity.
Qed.




(*************************************************)
(* Results about validity of values and bindings *)
(*************************************************)

Lemma valid_sstack_value_const: forall instk_height idx v,
valid_sstack_value instk_height idx (Val v).
Proof.
intros. simpl. intuition.
Qed.


Lemma Hvalid_maxidx: forall instk_height maxidx idx val sb ops,
valid_bindings instk_height maxidx ((idx, val) :: sb) ops ->
S idx = maxidx.
Proof.
intros instk_height maxidx idx val sb ops Hvalid.
unfold valid_bindings in Hvalid.
intuition.
Qed.


Lemma valid_sbindings_rec: forall instk_height maxidx n smapv sb ops,
valid_bindings instk_height maxidx ((n, smapv) :: sb) ops ->
valid_bindings instk_height n sb ops.
Proof.
intros instk_height maxidx n smapv sb ops Hvalid.
unfold valid_bindings in Hvalid.
destruct Hvalid as [_ [_ Hvalid']].
fold valid_bindings in Hvalid'.
assumption.
Qed.


Lemma valid_sstack_value_succ: forall instk_height n sv,
valid_sstack_value instk_height n sv ->
valid_sstack_value instk_height (S n) sv.
Proof.
intros instk_height n sv Hvalid.
unfold valid_sstack_value in Hvalid.
destruct sv as [v|var|fvar].
- intuition.
- intuition.
- simpl. intuition.
Qed.


Lemma valid_sstack_succ: forall instk_height n sstk,
valid_sstack instk_height n sstk ->
valid_sstack instk_height (S n) sstk.
Proof.
intros instk_height n sstk. revert instk_height n. 
induction sstk as [| h r IH].
- intuition.
- intros instk_height n Hvalid.
  unfold valid_sstack in Hvalid.
  destruct Hvalid as [Hvalid_sstack_value Hvalid_sstack'].
  fold valid_sstack in Hvalid_sstack'.
  unfold valid_sstack.
  split.
  + apply valid_sstack_value_succ. assumption.
  + fold valid_sstack. apply IH. assumption.
Qed.

Lemma valid_smemory_update_succ: forall instk_height n mem_upd,
valid_smemory_update instk_height n mem_upd ->
valid_smemory_update instk_height (S n) mem_upd.
Proof.
intros instk_height n mem_upd Hvalid.
destruct mem_upd eqn: eq_mem_upd.
- simpl in Hvalid.
  destruct Hvalid as [Hvalid_offset Hvalid_value].
  simpl. split.
  + apply valid_sstack_value_succ. assumption.
  + apply valid_sstack_value_succ. assumption.
- simpl in Hvalid.
  destruct Hvalid as [Hvalid_offset Hvalid_value].
  simpl. split.
  + apply valid_sstack_value_succ. assumption.
  + apply valid_sstack_value_succ. assumption.
Qed.


Lemma valid_smemory_succ: forall instk_height n smem,
valid_smemory instk_height n smem ->
valid_smemory instk_height (S n) smem.
Proof.
intros instk_height n smem. revert instk_height n.
induction smem as [|mem_upd rmem IH]. 
- intuition.
- intros instk_height n Hvalid.
  unfold valid_smemory in Hvalid.
  destruct Hvalid as [Hvalid_mem_upd Hvalid_smem_r].
  fold valid_smemory in Hvalid_smem_r.
  simpl. split.
  + apply valid_smemory_update_succ. assumption.
  + apply IH. assumption.
Qed.


Lemma valid_sstorage_succ: forall instk_height n sstr,
valid_sstorage instk_height n sstr ->
valid_sstorage instk_height (S n) sstr.
Proof.
intros instk_height n sstr. revert instk_height n.
induction sstr as [|sstr_upd rsstr IH].
- intuition.
- intros instk_height n Hvalid.
  unfold valid_sstorage in Hvalid.
  destruct Hvalid as [Hvalid_sstr_upd Hvalid_rsstr].
  fold valid_sstorage in Hvalid_rsstr.
  simpl. split.
  + destruct (sstr_upd) eqn: eq_sstr_upd.
    unfold valid_sstorage_update in Hvalid_sstr_upd.
    destruct Hvalid_sstr_upd as [Hvalid_key Hvalid_value].
    simpl. split.
    * apply valid_sstack_value_succ. assumption.
    * apply valid_sstack_value_succ. assumption.
  + apply IH. assumption.
Qed.


Lemma valid_smap_value_succ: forall instk_height n ops smapv,
valid_smap_value instk_height n ops smapv ->
valid_smap_value instk_height (S n) ops smapv.
Proof.
intros instk_height n ops smapv Hvalid.
unfold valid_smap_value in Hvalid.
destruct smapv as [v|tag|label args|offset smem|key sstr|offset size mem]
  eqn: eq_smapv.
- simpl. apply valid_sstack_value_succ. assumption.
- intuition.
- unfold valid_stack_op_instr in Hvalid. 
  destruct (ops label) as [nargs f Hcomm Hexts] eqn: eq_ops_label.
  destruct Hvalid as [Hlen Hvalid2].
  simpl. unfold valid_stack_op_instr. rewrite -> eq_ops_label.
  split; try assumption.
  apply valid_sstack_succ. assumption.
- destruct Hvalid as [Hvalid_offset Hvalid_smem].
  unfold valid_smap_value.
  split. 
  + apply valid_sstack_value_succ. assumption.
  + apply valid_smemory_succ. assumption.
- destruct Hvalid as [Hvalid_key Hvalid_sstr].
  simpl. split.
  + apply valid_sstack_value_succ. assumption.
  + apply valid_sstorage_succ. assumption.
- destruct Hvalid as [Hvalid_offset [Hvalid_size Hvalid_smem]].
  simpl. split; try split.
  + apply valid_sstack_value_succ. assumption.
  + apply valid_sstack_value_succ. assumption.
  + apply valid_smemory_succ. assumption.
Qed.


Lemma valid_bindings_unique_n: forall n1 n2 sb ops instk_height,
valid_bindings instk_height n1 sb ops ->
valid_bindings instk_height n2 sb ops ->
n1 = n2.
Proof.
intros n1 n2 sb ops instk_height.
intros Hvalid_n1 Hvalid_n2.
destruct sb as [| h t].
- simpl in Hvalid_n1.
  simpl in Hvalid_n2.
  intuition.
- destruct h as [k v].
  simpl in Hvalid_n1.
  destruct Hvalid_n1 as [eq_n1 [_ Hvalid_k]].
  destruct Hvalid_n2 as [eq_n2 [_ _]].
  intuition.
Qed.


Lemma valid_bindings_decr_head: forall n1 k1 k2 v1 v2 instk_height t ops,
valid_bindings instk_height n1 ((k1, v1) :: ((k2, v2) :: t)) ops ->
k1 > k2.
Proof.
intros n1 k1 k2 v1 v2 instk_height t ops.
intros Hvalid.
simpl in Hvalid.
intuition.
Qed.


Lemma valid_bindings_gte: forall instk_height n1 sb ops prefix sb',
valid_bindings instk_height n1 sb ops ->
sb = prefix ++ sb' ->
exists n2, valid_bindings instk_height n2 sb' ops /\
           forall k v, In (k,v) prefix -> k >= n2.
Proof.
intros instk_height n1 sb ops prefix.
revert instk_height n1 sb ops.
induction prefix as [|h t IH].
- intros instk_height n1 sb ops sb'.
  intros Hvalid Hprefix.
  simpl in Hprefix. rewrite <- Hprefix.
  exists n1. split.
  + assumption.
  + intros k v Hin. intuition.
- intros instk_height n1 sb ops sb'.
  intros Hvalid Hprefix.
  simpl in Hprefix. rewrite -> Hprefix in Hvalid.
  destruct h as [k1 v1] eqn: eq_h.
  assert (Hvalid_copy := Hvalid).
  simpl in Hvalid. destruct Hvalid as [eq_n1 [Hvalid_smap Hvalid_t_pref]].
  assert (t ++ sb' = t ++ sb') as eq_t_sb'; try reflexivity.
  pose proof (IH instk_height k1 (t ++ sb') ops sb' Hvalid_t_pref eq_t_sb') 
    as H.
  destruct H as [n2 [Hvalid' Hin_impl]].
  exists n2.
  split; try assumption.
  intros k v Hin.
  simpl in Hin. destruct Hin.
  + injection H as eq_k eq_v.
    rewrite <- eq_k.
    destruct t as [|h2 t2] eqn: eq_t.
    * simpl in Hvalid_t_pref.
      simpl in Hvalid_copy.
      destruct Hvalid_copy as [_ [_ Hvalid_t']].
      pose proof (valid_bindings_unique_n k1 n2 sb' ops instk_height
        Hvalid_t_pref Hvalid').
      intuition.
    * destruct h2 as [k2 v2] eqn: eq_h2.
      rewrite <- app_comm_cons in Hvalid_copy.
      pose proof (valid_bindings_decr_head n1 k1 k2 v1 v2 instk_height
        (t2 ++ sb') ops Hvalid_copy) as k1_gt_k2.
      assert (In (k2, v2) ((k2, v2) :: t2)) as Hin_k2; try intuition.
      pose proof (Hin_impl k2 v2 Hin_k2) as H.
      intuition.
  + apply Hin_impl with (v:=v); try assumption.
Qed.


Lemma valid_smap_value_incr: forall (m instk_height n : nat) 
  (ops : stack_op_instr_map) (smapv : smap_value),
valid_smap_value instk_height n ops smapv ->
valid_smap_value instk_height (n+m) ops smapv.
Proof.
induction m as [|m' IH].
- intuition. rewrite -> PeanoNat.Nat.add_0_r. assumption.
- intros instk_height n ops smap_value Hvalid_n.
  rewrite -> PeanoNat.Nat.add_succ_r.
  apply valid_smap_value_succ in Hvalid_n.
  apply IH in Hvalid_n.
  intuition.
Qed.  


Lemma valid_sstack_value_extended_by_i:  forall (i instk_height n : nat) (sv : sstack_val),
valid_sstack_value instk_height n sv ->
valid_sstack_value instk_height (n+i) sv.
Proof.
induction i as [|i' IH].
- intros instk_height n sv Hvalid.
  rewrite -> PeanoNat.Nat.add_0_r.
  assumption.
- intros instk_height n sv Hvalid.
  rewrite -> PeanoNat.Nat.add_succ_r.
  apply valid_sstack_value_succ.
  apply IH.
  assumption.
Qed.

Lemma valid_sstack_value_gt:  forall (instk_height n m : nat) (sv : sstack_val),
valid_sstack_value instk_height n sv ->
m > n ->
valid_sstack_value instk_height m sv.
Proof.
intros instk_height n m sv.
intros Hvalid Hgt.
apply gt_add in Hgt.
destruct Hgt as [k eq_m_n_k].
rewrite -> eq_m_n_k.
apply valid_sstack_value_extended_by_i.
assumption.
Qed.




(*************************************************)
(* Results about follow_in_smap                  *)
(*************************************************)

Lemma follow_in_smap_head_op: forall idx maxidx label args sb,
follow_in_smap (FreshVar idx) maxidx ((idx, SymOp label args) :: sb) = 
Some (FollowSmapVal (SymOp label args) idx sb).
Proof.
intros. simpl. rewrite -> PeanoNat.Nat.eqb_refl.
reflexivity.
Qed.


Lemma follow_in_smap_head: forall idx m sv sb,
follow_in_smap (FreshVar idx) m ((idx, SymBasicVal sv) :: sb) =
follow_in_smap sv idx sb.
Proof.
intros idx m sv sb.
unfold follow_in_smap at 1.
rewrite -> PeanoNat.Nat.eqb_refl.
fold follow_in_smap.
destruct sv as [val|var|fvar] eqn: eq_sv.
- simpl. destruct sb; try reflexivity.
- simpl. destruct sb; try reflexivity.
- simpl. reflexivity.
Qed.


Lemma follow_in_smap_fvar_maxidx_indep_eq: forall fvar n m sb,
follow_in_smap (FreshVar fvar) n sb = 
follow_in_smap (FreshVar fvar) m sb.
Proof.
intros fvar n m sb.
destruct sb as [|h r].
- reflexivity. 
- unfold follow_in_smap.
  reflexivity.
Qed.


Lemma follow_in_smap_instackvar: forall var maxidx sb,
follow_in_smap (InStackVar var) maxidx sb = 
  Some (FollowSmapVal (SymBasicVal (InStackVar var)) maxidx sb).
Proof.
intros var maxidx sb. 
destruct sb as [|h r]; try intuition. 
Qed.


Lemma follow_in_smap_val: forall v maxidx sb,
follow_in_smap (Val v) maxidx sb = 
  Some (FollowSmapVal (SymBasicVal (Val v)) maxidx sb).
Proof.
intros v maxidx sb. 
destruct sb as [|h r]; try intuition.
Qed.


Lemma follow_in_smap_chain: forall n1 n2 m sb,
follow_in_smap (FreshVar n1) m ((n1, SymBasicVal (FreshVar n2)) :: sb) =
follow_in_smap (FreshVar n2) n1 sb.
Proof.
intros n1 n2 m sb.
unfold follow_in_smap.
rewrite -> PeanoNat.Nat.eqb_refl. simpl. fold follow_in_smap.
reflexivity.
Qed.


Lemma follow_then_fvar_lt: forall maxidx sb ops instk_height n fvar fsm,
valid_bindings instk_height n sb ops ->
follow_in_smap (FreshVar fvar) maxidx sb = Some fsm ->
fvar < n.
Proof.
intros maxidx sb. revert maxidx.
induction sb as [| h t IH].
- intros maxidx ops instk_height n fvar fsm. 
  intros Hvalid Hfollow.
  simpl in Hfollow. discriminate.
- intros maxidx ops instk_height n fvar fsm. 
  intros Hvalid Hfollow.
  destruct h as [k v].
  simpl in Hvalid.
  destruct Hvalid as [eq_n [_ Hvalid']].
  simpl in Hfollow.
  destruct (k =? fvar) eqn: eq_k_fvar.
  + rewrite -> PeanoNat.Nat.eqb_eq in eq_k_fvar.
    rewrite <- eq_k_fvar.
    intuition.
  + rewrite -> follow_in_smap_fvar_maxidx_indep_eq with (m:=maxidx) in Hfollow.
    pose proof (IH maxidx ops instk_height k fvar fsm Hvalid' Hfollow).
    intuition.
Qed.


Lemma follow_in_smap_gt: forall fvar n1 n2 sb r instk_height ops,
follow_in_smap (FreshVar fvar) n1 sb = Some r ->
valid_bindings instk_height n2 sb ops ->
n2 > fvar.
Proof.
intros fvar n1 n2 sb. revert n1 n2.
induction sb as [| h t IH].
- intros n1 n2 r instk_height ops.
  intros Hfollow Hvalid.
  simpl in Hfollow. discriminate.
- intros n1 n2 r instk_height ops.
  intros Hfollow Hvalid.
  destruct h as [k v].
  simpl in Hfollow.
  simpl in Hvalid.
  destruct Hvalid as [eq_n2 [_ Hvalid_t]].
  destruct (k =? fvar) eqn: eq_k_fvar.
  + destruct (is_fresh_var_smv v) as [idx|].
    * rewrite -> PeanoNat.Nat.eqb_eq in eq_k_fvar.
      intuition.
    * rewrite -> PeanoNat.Nat.eqb_eq in eq_k_fvar.
      intuition.
  + pose proof (IH k k r instk_height ops Hfollow Hvalid_t).
    intuition.
Qed.


Lemma follow_in_smap_prefix_gt: forall fvar n1 n2 sb' r instk_height sb 
  ops prefix,
follow_in_smap (FreshVar fvar) n1 sb' = Some r ->
valid_bindings instk_height n2 sb ops ->
sb = prefix ++ sb' ->
forall k v, In (k,v) prefix -> k > fvar.
Proof.
intros fvar n1 n2 sb' r instk_height sb ops prefix.
intros Hfollow Hvalid Hprefix.
intros k v Hin.
pose proof (valid_bindings_gte instk_height n2 sb ops prefix sb' Hvalid
  Hprefix) as Hvalid_gte.
destruct Hvalid_gte as [nn [Hvalid_sb' Hk_in_prefix]].
pose proof (Hk_in_prefix k v Hin) as k_gte_nn.
pose proof (follow_in_smap_gt fvar n1 nn sb' r instk_height ops Hfollow
  Hvalid_sb').
intuition.
Qed.


Lemma follow_in_smap_prefix_diff: forall fvar n1 n2 sb' r instk_height sb 
  ops prefix,
follow_in_smap (FreshVar fvar) n1 sb' = Some r ->
valid_bindings instk_height n2 sb ops ->
sb = prefix ++ sb' ->
forall k v, In (k,v) prefix -> k =? fvar = false.
Proof.
intros fvar n1 n2 sb' r instk_height sb ops prefix.
intros Hfollow Hvalid Hprefix.
intros k v Hin.
pose proof (follow_in_smap_prefix_gt fvar n1 n2 sb' r instk_height sb ops 
  prefix Hfollow Hvalid Hprefix k v Hin) as k_gte_n2.
apply gt_neq. assumption.
Qed.


Lemma follow_in_smap_prefix: forall fvar n1 n2 sb' r instk_height n3 sb ops
  prefix,
follow_in_smap (FreshVar fvar) n1 sb' = Some r ->
valid_bindings instk_height n2 sb ops ->
sb = prefix ++ sb' ->
follow_in_smap (FreshVar fvar) n3 (prefix ++ sb') = Some r.
Proof.
intros fvar n1 n2 sb' r instk_height n3 sb ops prefix.
revert fvar n1 n2 sb' r instk_height n3 sb ops.
induction prefix as [| h t IH].
- intros fvar n1 n2 sb' r instk_height n3 sb ops.
  intros Hfollow Hvalid Hprefix.
  simpl.
  rewrite -> follow_in_smap_fvar_maxidx_indep_eq with (m:=n1).
  assumption.
- intros fvar n1 n2 sb' r instk_height n3 sb ops.
  intros Hfollow Hvalid Hprefix.
  destruct h as [k v] eqn: eq_h.
  assert (In (k,v) ((k, v) :: t)) as Hin; try intuition.
  pose proof (follow_in_smap_prefix_diff fvar n1 n2 sb' r instk_height sb
    ops (((k, v) :: t)) Hfollow Hvalid Hprefix k v Hin) as Hk_fvar.
  simpl. rewrite -> Hk_fvar.
  rewrite Hprefix in Hvalid. simpl in Hvalid.
  destruct Hvalid as [_ [_ Hvalid_t]].
  assert (t ++ sb' = t ++ sb') as eq_t; try reflexivity.
  pose proof (IH fvar n1 k sb' r instk_height k (t ++ sb') ops Hfollow
    Hvalid_t eq_t).
  assumption.
Qed.


Lemma follow_no_fresh: forall sb sv idx sv' idx' sb',
follow_in_smap sv idx sb = Some (FollowSmapVal sv' idx' sb') ->
is_fresh_var_smv sv' = None.
Proof.
induction sb as [| h t IH].
- intros sv idx sv' idx' sb' Hfollow. simpl in Hfollow.
  destruct sv as [val|var|fvar].
  + injection Hfollow as eq_sv' _ _.
    rewrite <- eq_sv'. reflexivity.
  + injection Hfollow as eq_sv' _ _.
    rewrite <- eq_sv'. reflexivity.
  + discriminate.
- intros sv idx sv' idx' sb' Hfollow. simpl in Hfollow.
  destruct sv as [val|var|fvar].
  + injection Hfollow as eq_sv' _ _.
    rewrite <- eq_sv'. reflexivity.
  + injection Hfollow as eq_sv' _ _.
    rewrite <- eq_sv'. reflexivity.
  + destruct h as [key smv] eqn: eq_h.
    destruct (key =? fvar) eqn: eq_key_fvar.
    * destruct (is_fresh_var_smv smv) as [idx2|] eqn: eq_is_fresh.
      -- apply IH in Hfollow. assumption.
      -- injection Hfollow as eq_sv' _ _.
         rewrite <- eq_sv'. assumption.
    * apply IH in Hfollow. assumption.
Qed.


Lemma follow_suffix: forall sb sv idx sv' idx' sb',
follow_in_smap sv idx sb = Some (FollowSmapVal sv' idx' sb') ->
exists prefix, sb = prefix ++ sb'.
Proof. 
induction sb as [|h t IH].
- intros sv idx sv' idx' sb' Hfollow.
  destruct sv as [val|var|fvar].
  + simpl in Hfollow.
    injection Hfollow as eq_sv' eq_idx' eq_sb'.
    rewrite <- eq_sb'.
    exists []. reflexivity.
  + simpl in Hfollow.
    injection Hfollow as eq_sv' eq_idx' eq_sb'.
    rewrite <- eq_sb'.
    exists []. reflexivity.
  + simpl in Hfollow. discriminate.
- intros sv idx sv' idx' sb' Hfollow.
  destruct sv as [val|var|fvar].
  + simpl in Hfollow.
    injection Hfollow as eq_sv' eq_idx' eq_sb'.
    rewrite <- eq_sb'.
    exists []. reflexivity.
  + simpl in Hfollow.
    injection Hfollow as eq_sv' eq_idx' eq_sb'.
    rewrite <- eq_sb'.
    exists []. reflexivity.
  + simpl in Hfollow. 
    destruct h as [key value] eqn: eq_h. 
    destruct (key =? fvar) eqn: eq_key_fvar.
    * destruct (is_fresh_var_smv value) as [idx''|] eqn: eq_is_fresh.
      -- apply IH in Hfollow.
         destruct Hfollow as [prefix' eq_t].
         exists ((key, value)::prefix').
         rewrite -> eq_t.
         simpl.
         reflexivity.
      -- injection Hfollow as eq_sv' eq_idx' eq_sb'.
         rewrite -> eq_sb'.
         exists [(key, value)].
         simpl.
         reflexivity.
    * apply IH in Hfollow as [prefix' eq_t].
      exists ((key, value)::prefix').
      rewrite -> eq_t.
      reflexivity.
Qed.


(* Calling follow_in_smap with valid bindings and a valid smap_value 
   cannot return None *)
Lemma valid_follow_not_none: forall instk_height idx sv sb ops,
valid_sstack_value instk_height idx sv ->
valid_bindings instk_height idx sb ops ->
follow_in_smap sv idx sb <> None.
Proof.
intros instk_height idx sv sb. revert instk_height idx sv.
induction sb as [| h t IH].
- intros instk_height idx sv ops Hvalid_sstack Hvalid_bindings.
  destruct sv as [val|var|fvar] eqn: eq_sv.
  + simpl. intuition. discriminate.
  + simpl. intuition. discriminate.
  + simpl. simpl in Hvalid_sstack. simpl in Hvalid_bindings. 
    intuition.
- intros instk_height idx sv ops Hvalid_sstack Hvalid_bindings.
  destruct sv as [val|var|fvar] eqn: eq_sv.
  + simpl. intuition. discriminate.
  + simpl. intuition. discriminate.
  + simpl. destruct h as [key smv] eqn: eq_h.
    destruct (key =? fvar) eqn: eq_key_fvar.
    * destruct (is_fresh_var_smv) eqn: eq_is_fresh.
      -- apply is_fresh_var_some in eq_is_fresh.
         rewrite eq_is_fresh in Hvalid_bindings.
         simpl in Hvalid_bindings.
         destruct Hvalid_bindings as [Hidx [Hn_key Hvalid_t]].
         apply IH with (instk_height:=instk_height)(ops:=ops); try assumption.
      -- intuition. discriminate. 
    * simpl in Hvalid_bindings.
      destruct Hvalid_bindings as [Hidx [Hvalid_smap Hvalid_t]].
      apply IH with (instk_height:=instk_height)(ops:=ops); try assumption.
      simpl. simpl in Hvalid_sstack.
      rewrite -> Hidx in Hvalid_sstack.
      apply Lt.lt_n_Sm_le in Hvalid_sstack.
      apply leq_diff_lt; try assumption.
      apply EqNat.beq_nat_false.
      rewrite PeanoNat.Nat.eqb_sym. assumption.
Qed.



Lemma follow_succ_no_fv: forall sb sb' smv idx a idx',
follow_in_smap smv idx sb = Some (FollowSmapVal a idx' sb') ->
is_fresh_var_smv a = None.
Proof.
induction sb as [| h t IH].
- intros sb' smv idx a idx' Hfollow.
  simpl in Hfollow. 
  destruct smv as [val|var|fvar]; 
    try (injection Hfollow as eq_a _ _;
         rewrite <- eq_a;
         reflexivity).
  discriminate.
- intros sb' smv idx a idx' Hfollow.
  destruct h as [key value].
  simpl in Hfollow.
  destruct smv as [val|var|fvar];
    try (injection Hfollow as eq_a _ _;
         rewrite <- eq_a;
         reflexivity).
  destruct (key =? fvar) eqn: eq_key_fvar.
  + destruct (is_fresh_var_smv value) eqn: eq_is_fresh.
    * apply IH in Hfollow. assumption. 
    * injection Hfollow as eq_a_value _ _.
      rewrite <- eq_a_value.
      assumption.
  + apply IH in Hfollow. assumption.
Qed.


Lemma follow_to_val_eval_eq: forall sv idx sb v d stk mem strg exts v',
follow_to_val sv idx sb = Some v ->
eval_sstack_val' d sv stk mem strg exts idx sb evm_stack_opm = Some v' ->
v = v'.
Proof.
intros sv idx sb v d stk mem strg exts v'.
intros Hfollow Heval.
unfold follow_to_val in Hfollow.
destruct (follow_in_smap sv idx sb) as [fsmv|] eqn: eq_follow; try discriminate.
destruct (fsmv) as [smv] eqn: eq_fsmv.
destruct (smv) as [basicv|x1|x2|x3|x4|x5] eqn: eq_smv; try discriminate.
destruct (basicv) as [val|var|fvar] eqn: eq_basicv; try discriminate.
unfold eval_sstack_val' in Heval.
destruct d as [|d']; try discriminate.
rewrite -> eq_follow in Heval.
rewrite -> Hfollow in Heval. 
injection Heval. trivial.
Qed.


Lemma follow_to_val_args_eval_eq: forall args idx sb vargs maxidx stk mem strg exts vargs',
follow_to_val_args args idx sb = Some vargs ->
map_option (fun sv' : sstack_val =>
             eval_sstack_val' maxidx sv' stk mem strg exts idx sb
               evm_stack_opm) args = Some vargs' ->
vargs = vargs'.
Proof.
induction args as [|h t IH].
- intros idx sb vargs maxidx stk mem strg exts vargs'.
  intros Hfollow Hmapo.
  simpl in Hfollow. simpl in Hmapo.
  rewrite -> Hfollow in Hmapo.
  injection Hmapo.
  intuition.
- intros idx sb vargs maxidx stk mem strg exts vargs'.
  intros Hfollow Hmapo.
  simpl in Hfollow.
  destruct (follow_to_val h idx sb) as [hv|] eqn: eq_follow_h; 
    try discriminate.
  destruct (follow_to_val_args t idx sb) as [tv|] eqn: eq_follow_t;
    try discriminate.
  simpl in Hmapo.
  destruct (eval_sstack_val' maxidx h stk mem strg exts idx sb evm_stack_opm)
    as [hv'|] eqn: eq_eval_h; try discriminate.
  destruct (map_option (fun sv' : sstack_val =>
             eval_sstack_val' maxidx sv' stk mem strg exts idx sb
               evm_stack_opm) t) as [tv'|] eqn: eq_mapo_t;
    try discriminate.
  pose proof (IH idx sb tv maxidx stk mem strg exts tv' eq_follow_t
    eq_mapo_t) as eq_tv'.
  injection Hmapo as eq_vargs'. rewrite <- eq_vargs'.
  injection Hfollow as eq_vargs. rewrite <- eq_vargs.
  rewrite <- eq_tv'.
  pose proof (follow_to_val_eval_eq h idx sb hv maxidx stk mem strg exts hv'
    eq_follow_h eq_eval_h) as eq_hv'.
  rewrite <- eq_hv'.
  reflexivity.
Qed.








(******************************************************)
(* Results about eval_sstack_val and eval_sstack_val' *)
(******************************************************)

(* Used to unfold eval_sstack_val' without applying any further 
   simplification *)
Lemma eval_sstack_val'_one_step: forall d' sv stk mem strg exts maxidx sb ops,
eval_sstack_val' (S d') sv stk mem strg exts maxidx sb ops =
      match follow_in_smap sv maxidx sb with
      | None => None
      | Some (FollowSmapVal smv maxidx' sb') =>
          match smv with
          | SymBasicVal (Val v) => Some v

          | SymBasicVal (InStackVar n) =>
              match nth_error stk n with
              | Some v => Some v
              | None => None
              end

          | SymBasicVal (FreshVar _) => None

          | SymMETAPUSH cat v =>
              let tags := (get_tags_exts exts) in Some (tags cat v)

          | SymOp label args =>
              match ops label with
              | OpImp nargs f _ _ =>
                  if (List.length args =? nargs) then
                    let f_eval_list := fun (sv': sstack_val) => eval_sstack_val' d' sv' stk mem strg exts maxidx' sb' ops in
                    match map_option f_eval_list args with
                    | None => None
                    | Some vargs => Some (f exts vargs)
                    end
                  else None
              end
 
            | SymMLOAD soffset smem =>
                let f_eval_mem_update := instantiate_memory_update (fun sv => eval_sstack_val' d' sv stk mem strg exts maxidx' sb' ops) in
                match map_option f_eval_mem_update smem with (* Evaluate the arguments of the updates *)
                | None => None
                | Some mem_updates =>
                    match eval_sstack_val' d' soffset stk mem strg exts maxidx' sb' ops with (* Evaluate the offset *)
                    | None => None
                    | Some offset =>
                        let mem := update_memory mem mem_updates in (* apply updates to the memory *)
                        Some (mload mem offset) (* lookup for the desired value in the memory *)
                    end
                end
                  
            | SymSLOAD skey sstrg =>
                let f_eval_strg_update := instantiate_storage_update (fun sv => eval_sstack_val' d' sv stk mem strg exts maxidx' sb' ops) in
                match map_option f_eval_strg_update sstrg with (* Evaluate the arguments of the updates *)
                | None => None
                | Some strg_updates =>
                    match eval_sstack_val' d' skey stk mem strg exts maxidx' sb' ops with (* Evaluate the key *)
                    | None => None
                    | Some key =>
                        let strg := update_storage strg strg_updates in (* apply updates to the storage *)
                        Some (sload strg key) (* lookup for the desired value in the storage *)
                    end
                end

            | SymSHA3 soffset ssize smem =>
                let f_eval_mem_update := instantiate_memory_update (fun sv => eval_sstack_val' d' sv stk mem strg exts maxidx' sb' ops) in
                match map_option f_eval_mem_update smem with (* Evaluate the arguments of the updates *)
                | None => None
                | Some mem_updates =>
                    match eval_sstack_val' d' soffset stk mem strg exts maxidx' sb' ops with (* Evaluate the offset *)
                    | None => None
                    | Some offset =>
                        match eval_sstack_val' d' ssize stk mem strg exts maxidx' sb' ops with (* Evaluate the size *)
                        | None => None
                        | Some size =>
                            let mem := update_memory mem mem_updates in (* apply updates to the memory *)
                            let f_sha3 := (get_keccak256_exts exts) in (* get the sha3 function from the externals and ... *)
                            Some (f_sha3 (wordToNat size) (mload' mem offset (wordToNat size))) (* ... apply it to the corresponding data *)
                        end
                    end
                end
          end
      end.
Proof.
intuition.
Qed.


Lemma eval'_maxidx_indep: forall d sv stk mem strg exts n m sb ops v,
eval_sstack_val' d sv stk mem strg exts n sb ops = Some v ->
eval_sstack_val' d sv stk mem strg exts m sb ops = Some v.
Proof.
intros d sv stk mem strg exts n m sb ops v Heval.
destruct d as [|d']; try discriminate.
rewrite -> eval_sstack_val'_one_step.
rewrite -> eval_sstack_val'_one_step in Heval.
destruct sv as [val|var|fvar] eqn: eq_sv.
* rewrite -> follow_in_smap_val.
  rewrite -> follow_in_smap_val in Heval.
  assumption.
* rewrite -> follow_in_smap_instackvar.
  rewrite -> follow_in_smap_instackvar in Heval.
  assumption.
* rewrite -> follow_in_smap_fvar_maxidx_indep_eq with (m:=n).  
  assumption.
Qed.


Lemma eval_sstack_val'_freshvar: forall n sv stk mem strg exts m sb ops idx, 
eval_sstack_val' n sv stk mem strg exts m sb ops = 
eval_sstack_val' n (FreshVar idx) stk mem strg exts m 
  ((idx, SymBasicVal sv) :: sb) ops.
Proof.
intros n sv stk mem strg exts m sb ops idx.
destruct n as [|n'] eqn: eq_n.
- reflexivity. 
- rewrite -> eval_sstack_val'_one_step. 
  rewrite -> eval_sstack_val'_one_step.
  destruct sv as [val|var|fvar] eqn: eq_fvar.
  * rewrite -> follow_in_smap_val.
    simpl. rewrite -> PeanoNat.Nat.eqb_refl.
    reflexivity. 
  * rewrite -> follow_in_smap_instackvar.
    simpl. rewrite -> PeanoNat.Nat.eqb_refl.
    reflexivity.
  * rewrite -> follow_in_smap_head.
    rewrite -> follow_in_smap_fvar_maxidx_indep_eq with (m:=idx).
    reflexivity.
Qed.


Lemma eval_sstack_def: forall (sstk: sstack) (maxidx: nat) (sb: sbindings) 
  (stk: stack) (mem: memory) (strg: storage) (exts: externals) 
  (ops: stack_op_instr_map),
eval_sstack sstk maxidx sb stk mem strg exts ops = 
map_option (fun sv => eval_sstack_val sv stk mem strg exts maxidx sb ops) sstk.
Proof.
intuition.
Qed.


Lemma eval'_maxidx_indep_eq:
  forall (d : nat) (sv : sstack_val) (stk : stack) 
    (mem : memory) (strg : storage) (exts : externals) 
    (n m : nat) (sb : sbindings) (ops : stack_op_instr_map),
  eval_sstack_val' d sv stk mem strg exts n sb ops = 
  eval_sstack_val' d sv stk mem strg exts m sb ops.
Proof.
intros d sv stk mem strg exts n m sb ops.
destruct d as [|d']; try reflexivity.
rewrite -> eval_sstack_val'_one_step.
rewrite -> eval_sstack_val'_one_step.
destruct sv as [val|var|fvar] eqn: eq_sv.
* rewrite -> follow_in_smap_val.
  rewrite -> follow_in_smap_val.
  reflexivity.
* rewrite -> follow_in_smap_instackvar.
  rewrite -> follow_in_smap_instackvar.
  reflexivity.
* rewrite -> follow_in_smap_fvar_maxidx_indep_eq with (m:=m).  
  reflexivity.
Qed.


Lemma eq_funs_len: forall maxidx stk mem strg exts n sb1 sb2 ops instk_height,
(forall (sv : sstack_val) (stk : stack)
             (mem : memory) (strg : storage) (exts : externals) 
             (v : EVMWord),
           instk_height = length stk ->
           eval_sstack_val' maxidx sv stk mem strg exts n sb1 ops = Some v ->
           eval_sstack_val' maxidx sv stk mem strg exts n sb2 ops = Some v) ->
instk_height = length stk -> 
forall sv r, 
  (fun sv' : sstack_val =>
     eval_sstack_val' maxidx sv' stk mem strg exts n sb1 ops) sv = Some r ->
  (fun sv' : sstack_val =>
     eval_sstack_val' maxidx sv' stk mem strg exts n sb2 ops) sv = Some r.
Proof.
intros maxidx stk mem strg exts n sb1 sb2 ops instk_height Hpreserv Hlen.
intros sv r Heval_f1.
simpl in Heval_f1.
simpl.
pose proof (Hpreserv sv stk mem strg exts r Hlen Heval_f1).
assumption.
Qed.

Lemma map_option_fun_sstack: forall maxidx stk mem strg exts n sb1 sb2 ops 
  instk_height,
(forall (sv : sstack_val) (stk : stack)
             (mem : memory) (strg : storage) (exts : externals) 
             (v : EVMWord),
           instk_height = length stk ->
           eval_sstack_val' maxidx sv stk mem strg exts n sb1 ops = Some v ->
           eval_sstack_val' maxidx sv stk mem strg exts n sb2 ops = Some v) ->
instk_height = length stk -> 
forall sv r, 
  (fun sv' : sstack_val =>
     eval_sstack_val' maxidx sv' stk mem strg exts n sb1 ops) sv = Some r ->
  (fun sv' : sstack_val =>
     eval_sstack_val' maxidx sv' stk mem strg exts n sb2 ops) sv = Some r.
Proof.
intros maxidx stk mem strg exts n sb1 sb2 ops instk_height Hpreserv Hlen.
intros sv r Heval_f1.
simpl in Heval_f1.
simpl.
pose proof (Hpreserv sv stk mem strg exts r Hlen Heval_f1).
assumption.
Qed.


Lemma map_option_sstack: forall maxidx stk mem strg exts n sb1 sb2 ops 
  instk_height args vargs,
map_option (fun sv' : sstack_val =>
              eval_sstack_val' maxidx sv' stk mem strg exts n sb1 ops)
              args = Some vargs ->
(forall (sv : sstack_val) (stk : stack)
             (mem : memory) (strg : storage) (exts : externals) 
             (v : EVMWord),
           instk_height = length stk ->
           eval_sstack_val' maxidx sv stk mem strg exts n sb1 ops = Some v ->
           eval_sstack_val' maxidx sv stk mem strg exts n sb2 ops = Some v) ->
instk_height = length stk ->           
map_option (fun sv' : sstack_val =>
              eval_sstack_val' maxidx sv' stk mem strg exts n sb2 ops)
            args = Some vargs.
Proof.
intros maxidx stk mem strg exts n sb1 sb2 ops instk_height args vargs Hmapo
  Hpreserv Hlen.
pose proof (map_option_fun_sstack maxidx stk mem strg exts n sb1 sb2 ops 
  instk_height Hpreserv Hlen) as Hfunct_equiv.
pose proof (map_option_preserv_functs 
  ((fun sv' : sstack_val =>
                eval_sstack_val' maxidx sv' stk mem strg exts n sb1 ops))
  (fun sv' : sstack_val =>
   eval_sstack_val' maxidx sv' stk mem strg exts n sb2 ops) args vargs
  Hmapo Hfunct_equiv).
assumption.
Qed.


Lemma same_instantiate_memory_update: forall (f g: sstack_val -> option EVMWord),
(forall x (r: EVMWord), f x = Some r -> g x = Some r) ->
forall (mem_upd: memory_update sstack_val) v,
instantiate_memory_update f mem_upd = Some v ->
instantiate_memory_update g mem_upd = Some v.
Proof.
intros f g Hpreserv mem_upd v Heval.
destruct mem_upd as [offset val|offset val].
- unfold instantiate_memory_update in Heval. 
  destruct (f offset) as [offsetv|] eqn: eq_eval_offset; try discriminate.
  destruct (f val) as [valv|] eqn: eq_eval_val; try discriminate.
  apply Hpreserv in eq_eval_offset; try assumption.
  apply Hpreserv in eq_eval_val; try assumption.
  unfold instantiate_memory_update.
  rewrite -> eq_eval_offset.
  rewrite -> eq_eval_val.
  rewrite <- Heval. reflexivity.
- unfold instantiate_memory_update in Heval. 
  destruct (f offset) as [offsetv|] eqn: eq_eval_offset; try discriminate.
  destruct (f val) as [valv|] eqn: eq_eval_val; try discriminate.
  apply Hpreserv in eq_eval_offset; try assumption.
  apply Hpreserv in eq_eval_val; try assumption.
  unfold instantiate_memory_update.
  rewrite -> eq_eval_offset.
  rewrite -> eq_eval_val.
  rewrite <- Heval. reflexivity.
Qed.

Lemma same_instantiate_storage_update: forall 
  (f g: sstack_val -> option EVMWord),
(forall x (r: EVMWord), f x = Some r -> g x = Some r) ->
forall (strg_upd: storage_update sstack_val) v,
instantiate_storage_update f strg_upd = Some v ->
instantiate_storage_update g strg_upd = Some v.
Proof.
intros f g Hpreserv strg_upd v Heval.
destruct strg_upd as [key value].
unfold instantiate_storage_update in Heval. 
destruct (f key) as [keyv|] eqn: eq_eval_key; try discriminate.
destruct (f value) as [valv|] eqn: eq_eval_value; try discriminate.
apply Hpreserv in eq_eval_key; try assumption.
apply Hpreserv in eq_eval_value; try assumption.
unfold instantiate_storage_update.
rewrite -> eq_eval_key.
rewrite -> eq_eval_value.
rewrite <- Heval. reflexivity.
Qed.


Lemma map_option_inst_mem_update: forall maxidx stk mem strg exts n sb1 sb2 ops 
  instk_height smem mem_updates, 
map_option (instantiate_memory_update
              (fun sv : sstack_val =>
                   eval_sstack_val' maxidx sv stk mem strg exts n sb1 ops))
           smem = Some mem_updates ->
(forall (sv : sstack_val) (stk : stack)
             (mem : memory) (strg : storage) (exts : externals) 
             (v : EVMWord),
           instk_height = length stk ->
           eval_sstack_val' maxidx sv stk mem strg exts n sb1 ops = Some v ->
           eval_sstack_val' maxidx sv stk mem strg exts n sb2 ops = Some v) ->
instk_height = length stk ->
map_option (instantiate_memory_update
             (fun sv : sstack_val =>
                  eval_sstack_val' maxidx sv stk mem strg exts n sb2 ops)) 
             smem = Some mem_updates.
Proof. 
intros maxidx stk mem strg exts n sb1 sb2 ops instk_height smem mem_updates
  Hmapo Hpreserv Hlen.
pose proof (eq_funs_len maxidx stk mem strg exts n sb1 sb2 ops 
  instk_height Hpreserv Hlen) as Hfunct_equiv.  
pose proof (same_instantiate_memory_update
  ((fun sv' : sstack_val =>
                eval_sstack_val' maxidx sv' stk mem strg exts n sb1 ops))
  (fun sv' : sstack_val =>
                eval_sstack_val' maxidx sv' stk mem strg exts n sb2 ops)                
  Hfunct_equiv) as Hinst_equiv.
pose proof (map_option_preserv_functs 
  (instantiate_memory_update
                (fun sv' : sstack_val =>
                 eval_sstack_val' maxidx sv' stk mem strg exts n sb1 ops))
  (instantiate_memory_update
                (fun sv' : sstack_val =>
                 eval_sstack_val' maxidx sv' stk mem strg exts n sb2 ops))
  smem mem_updates Hmapo Hinst_equiv) as Hmapo2.
rewrite -> Hmapo2.
reflexivity.
Qed.

Lemma map_option_inst_strg_update: forall maxidx stk mem strg exts n sb1 sb2 ops 
  instk_height sstrg strg_updates, 
map_option (instantiate_storage_update
              (fun sv : sstack_val =>
                   eval_sstack_val' maxidx sv stk mem strg exts n sb1 ops))
           sstrg = Some strg_updates ->
(forall (sv : sstack_val) (stk : stack)
             (mem : memory) (strg : storage) (exts : externals) 
             (v : EVMWord),
           instk_height = length stk ->
           eval_sstack_val' maxidx sv stk mem strg exts n sb1 ops = Some v ->
           eval_sstack_val' maxidx sv stk mem strg exts n sb2 ops = Some v) ->
instk_height = length stk ->
map_option (instantiate_storage_update
             (fun sv : sstack_val =>
                  eval_sstack_val' maxidx sv stk mem strg exts n sb2 ops)) 
             sstrg = Some strg_updates.
Proof. 
intros maxidx stk mem strg exts n sb1 sb2 ops instk_height sstrg strg_updates
  Hmapo Hpreserv Hlen.
pose proof (eq_funs_len maxidx stk mem strg exts n sb1 sb2 ops 
  instk_height Hpreserv Hlen) as Hfunct_equiv.  
pose proof (same_instantiate_storage_update
  ((fun sv' : sstack_val =>
                eval_sstack_val' maxidx sv' stk mem strg exts n sb1 ops))
  (fun sv' : sstack_val =>
                eval_sstack_val' maxidx sv' stk mem strg exts n sb2 ops)                
  Hfunct_equiv) as Hinst_equiv.
pose proof (map_option_preserv_functs 
  (instantiate_storage_update
                (fun sv' : sstack_val =>
                 eval_sstack_val' maxidx sv' stk mem strg exts n sb1 ops))
  (instantiate_storage_update
                (fun sv' : sstack_val =>
                 eval_sstack_val' maxidx sv' stk mem strg exts n sb2 ops))
  sstrg strg_updates Hmapo Hinst_equiv) as Hmapo2.
rewrite -> Hmapo2.
reflexivity.
Qed.


Lemma eval'_then_valid_sstack_value: forall d sv stk mem strg exts maxidx sb ops
  v instk_height n,
eval_sstack_val' (S d) sv stk mem strg exts maxidx sb ops = Some v ->
valid_bindings instk_height n sb ops ->
instk_height = length stk ->
valid_sstack_value instk_height n sv.
Proof.
intros d sv stk mem strg exts maxidx sb ops v instk_height n.
intros Heval Hvalid Hlen.
destruct sv as [val|var|fvar].
- simpl. intuition.
- simpl. simpl in Heval.
  rewrite -> follow_in_smap_instackvar in Heval.
  destruct (nth_error stk var) as [v'|] eqn: eq_nth_error; try discriminate.
  unfold follow_in_smap in Heval. unfold eval_sstack_val' in Heval.
  pose proof (some_is_not_none (nth_error stk var) v' eq_nth_error) 
    as eq_nth_not_none.
  pose proof (nth_error_Some stk var) as H.
  rewrite -> Hlen.
  rewrite <- H.
  assumption.
- simpl.
  simpl in Heval.
  destruct (follow_in_smap (FreshVar fvar) maxidx sb) as [fsm|] eqn: eq_follow;
    try discriminate.
  pose proof (follow_then_fvar_lt maxidx sb ops instk_height n fvar fsm
    Hvalid eq_follow).
  assumption.
Qed.


Lemma eval_sstack_val'_diff:
  forall (fvar idx : nat) (stk : stack) (mem : memory) 
    (strg : storage) (exts : externals) (d a b: nat) 
    (smapv : smap_value) (ops : stack_op_instr_map) 
    (sb : sbindings),
  (idx =? fvar) = false ->
  eval_sstack_val' (S d) (FreshVar fvar) stk mem strg exts a 
    ((idx, smapv) :: sb) ops =
  eval_sstack_val' (S d) (FreshVar fvar) stk mem strg exts b sb ops.
Proof.
intros fvar idx stk mem strg exts d a b smapv ops sb.
intros Hfvar_idx.
simpl. rewrite -> Hfvar_idx.
rewrite -> follow_in_smap_fvar_maxidx_indep_eq with (m:=b).
reflexivity.
Qed.


Lemma eval_sstack_val_const: forall v stk mem strg exts maxidx sb ops,
eval_sstack_val (Val v) stk mem strg exts maxidx sb ops = Some v.
Proof.
intros.
unfold eval_sstack_val.
unfold eval_sstack_val'.
rewrite -> follow_in_smap_val.
reflexivity.
Qed.


Lemma eval_sstack_val'_const: forall n v stk mem strg exts idx sb ops,
eval_sstack_val' (S n) (Val v) stk mem strg exts idx sb ops = Some v.
Proof.
intros n v stk mem strg exts idx sb ops.
simpl. rewrite -> follow_in_smap_val.
reflexivity.
Qed.


Lemma eval_sstack_val'_instackvar: forall n var stk mem strg exts idx sb ops,
eval_sstack_val' (S n) (InStackVar var) stk mem strg exts idx sb ops =   
  match nth_error stk var with
  | Some v => Some v
  | None => None
  end.
Proof.
intros n var stk mem strg exts idx sb ops.
simpl. rewrite -> follow_in_smap_instackvar.
reflexivity.
Qed.


Lemma eval_sstack_val'_extend_sb: forall instk_height n stk mem strg exts 
  idx sb sb' ops prefix,
valid_bindings instk_height idx sb ops ->
sb = prefix ++ sb' ->
forall sv v,
eval_sstack_val' n sv stk mem strg exts idx sb' ops = Some v ->
eval_sstack_val' n sv stk mem strg exts idx sb ops = Some v.
Proof.
intros instk_height n stk mem strg exts idx sb sb' ops prefix.
intros Hvalid Hprefix sv v Heval.
destruct n as [|n'] eqn: eq_n; try intuition.
destruct sv as [val|var|fvar] eqn: eq_sv.
- rewrite -> eval_sstack_val'_const.
  rewrite -> eval_sstack_val'_const in Heval.
  assumption.
- rewrite -> eval_sstack_val'_instackvar.
  rewrite -> eval_sstack_val'_instackvar in Heval.
  assumption.
- rewrite -> eval_sstack_val'_one_step in Heval. 
  destruct (follow_in_smap (FreshVar fvar) idx sb') as [follow_smap|] 
    eqn: Hfollow; try discriminate.
  rewrite -> eval_sstack_val'_one_step.
  pose proof (follow_in_smap_prefix fvar idx idx sb' follow_smap instk_height
    idx sb ops prefix Hfollow Hvalid Hprefix) as Hfollow'.
  rewrite <- Hprefix in Hfollow'.
  rewrite -> Hfollow'.
  assumption.
Qed.


Lemma eval_sstack_val'_extend_sb_indep: forall instk_height n d stk mem strg exts 
  m1 m2 sb sb' ops prefix,
valid_bindings instk_height n sb ops ->
sb = prefix ++ sb' ->
forall sv v, 
eval_sstack_val' d sv stk mem strg exts m1 sb' ops = Some v ->
eval_sstack_val' d sv stk mem strg exts m2 sb ops = Some v.
Proof.
intros instk_height n d stk mem strg exts m1 m2 sb sb' ops prefix.
intros Hvalid Hprefix sv v Heval.
rewrite -> eval'_maxidx_indep_eq with (m:=n) in Heval.
pose proof (eval_sstack_val'_extend_sb instk_height d stk mem strg exts n
  sb sb' ops prefix Hvalid Hprefix sv v Heval) as Heval2.
rewrite -> eval'_maxidx_indep_eq with (m:=m2) in Heval2.
assumption.
Qed.


Lemma lambda_eval'_maxid_indep_eq: forall d stk mem strg exts n m sb1 ops,
(fun sv : sstack_val =>
             eval_sstack_val' d sv stk mem strg exts n sb1 ops) = 
(fun sv : sstack_val =>
             eval_sstack_val' d sv stk mem strg exts m sb1 ops).
Proof.
intros.
apply functional_extensionality_dep.
intros x.
apply eval'_maxidx_indep_eq.
Qed.

Lemma lambda_eval'_eq: forall d stk mem strg exts m1 m2 sb1 sb2 ops,
(forall (sv : sstack_val) (v : EVMWord),
    eval_sstack_val' d sv stk mem strg exts m1 sb1 ops = Some v ->
    eval_sstack_val' d sv stk mem strg exts m2 sb2 ops = Some v) ->
(forall sv v,
   (fun sv : sstack_val =>
      eval_sstack_val' d sv stk mem strg exts m1 sb1 ops) sv = Some v ->
   (fun sv : sstack_val => 
      eval_sstack_val' d sv stk mem strg exts m2 sb2 ops) sv = Some v).
Proof.
intuition.
Qed.



Lemma map_option_preserv_prefix: forall d stk mem strg exts sb1 sb ops
  args vargs prefix instk_height n m1 m2,
map_option (fun sv : sstack_val =>
  eval_sstack_val' d sv stk mem strg exts m1 sb1 ops) args = Some vargs ->
sb = prefix ++ sb1 ->
valid_bindings instk_height n sb ops ->
map_option (fun sv : sstack_val => 
  eval_sstack_val' d sv stk mem strg exts m2 sb ops) args = Some vargs.
Proof.
intros d stk mem strg exts sb1 sb ops args vargs prefix instk_height n m1 m2.
intros Hmapo Hprefix Hvalid.
pose proof (eval_sstack_val'_extend_sb_indep instk_height n d stk mem strg 
  exts m1 m2 sb sb1 ops prefix Hvalid Hprefix) as Heq_evals.
pose proof (lambda_eval'_eq d stk mem strg exts m1 m2 sb1 sb ops Heq_evals) as
  Hlambda_eq.
pose proof (map_option_preserv_functs
  (fun sv0 : sstack_val =>
     eval_sstack_val' d sv0 stk mem strg exts m1 sb1 ops)
  (fun sv0 : sstack_val =>
     eval_sstack_val' d sv0 stk mem strg exts m2 sb ops) 
  args vargs Hmapo Hlambda_eq) as eq_mapo2.
rewrite -> eq_mapo2.
reflexivity.  
Qed.


Lemma map_option_preserv_prefix_inst_mem: forall d stk mem strg exts sb1 sb ops
  smem mem_updates prefix instk_height n m1 m2,
map_option (instantiate_memory_update (fun sv : sstack_val =>
  eval_sstack_val' d sv stk mem strg exts m1 sb1 ops)) smem = 
    Some mem_updates ->
sb = prefix ++ sb1 ->
valid_bindings instk_height n sb ops ->
map_option (instantiate_memory_update (fun sv : sstack_val =>
  eval_sstack_val' d sv stk mem strg exts m2 sb ops)) smem = 
    Some mem_updates.
Proof.
intros d stk mem strg exts sb1 sb ops smem mem_updates prefix instk_height n 
  m1 m2 Hmapo Hprefix Hvalid.
pose proof (eval_sstack_val'_extend_sb_indep instk_height n d stk mem strg 
  exts m1 m2 sb sb1 ops prefix Hvalid Hprefix) as Heq_evals.
pose proof (lambda_eval'_eq d stk mem strg exts m1 m2 sb1 sb ops Heq_evals)
  as Heq_lambdas.
pose proof (same_instantiate_memory_update
  (fun sv0 : sstack_val =>
               eval_sstack_val' d sv0 stk mem strg exts m1 sb1 ops)
  (fun sv0 : sstack_val =>
               eval_sstack_val' d sv0 stk mem strg exts m2 sb ops)
  Heq_lambdas) as Heq_lambdas_inst_mem.  
pose proof (map_option_preserv_functs
  (instantiate_memory_update (fun sv0 : sstack_val =>
     eval_sstack_val' d sv0 stk mem strg exts m1 sb1 ops))
  (instantiate_memory_update (fun sv0 : sstack_val => 
     eval_sstack_val' d sv0 stk mem strg exts m2 sb ops))
  smem mem_updates Hmapo Heq_lambdas_inst_mem ) as eq_mapo2.
rewrite -> eq_mapo2.
reflexivity.
Qed.


Lemma map_option_preserv_prefix_inst_strg: forall d stk mem strg exts sb1 sb ops
  sstrg strg_updates prefix instk_height n m1 m2,
map_option (instantiate_storage_update (fun sv : sstack_val =>
  eval_sstack_val' d sv stk mem strg exts m1 sb1 ops)) sstrg 
    = Some strg_updates ->
sb = prefix ++ sb1 ->
valid_bindings instk_height n sb ops ->
map_option (instantiate_storage_update (fun sv : sstack_val =>
  eval_sstack_val' d sv stk mem strg exts m2 sb ops)) sstrg 
    = Some strg_updates.
Proof.
intros d stk mem strg exts sb1 sb ops sstrg strg_updates prefix instk_height n 
  m1 m2 Hmapo Hprefix Hvalid.
pose proof (eval_sstack_val'_extend_sb_indep instk_height n d stk mem strg 
  exts m1 m2 sb sb1 ops prefix Hvalid Hprefix) as Heq_evals.
pose proof (lambda_eval'_eq d stk mem strg exts m1 m2 sb1 sb ops Heq_evals)
  as Heq_lambdas.
pose proof (same_instantiate_storage_update
  (fun sv0 : sstack_val =>
               eval_sstack_val' d sv0 stk mem strg exts m1 sb1 ops)
  (fun sv0 : sstack_val =>
               eval_sstack_val' d sv0 stk mem strg exts m2 sb ops)
  Heq_lambdas) as Heq_lambdas_inst_strg.
pose proof (map_option_preserv_functs
  (instantiate_storage_update (fun sv : sstack_val =>
     eval_sstack_val' d sv stk mem strg exts m1 sb1 ops))
  (instantiate_storage_update (fun sv : sstack_val =>
     eval_sstack_val' d sv stk mem strg exts m2 sb ops)) 
  sstrg strg_updates Hmapo Heq_lambdas_inst_strg) as eq_mapo2.
rewrite -> eq_mapo2.
reflexivity.
Qed.


Lemma eval_sstack_val'_follow_in_smap: forall d sv stk mem strg exts m
  sb ops v maxidx' sb' n sv_plain instk_height,
valid_bindings instk_height n sb ops ->  
eval_sstack_val' d sv stk mem strg exts n sb ops 
  = Some v ->
follow_in_smap sv n sb = Some (FollowSmapVal sv_plain maxidx' sb') ->
eval_sstack_val' d (FreshVar n) stk mem strg exts m 
  ((n, sv_plain) :: sb) ops = Some v.
Proof.
intros d sv stk mem strg exts m sb ops v maxidx' sb' n sv_plain 
  instk_height Hvalid Heval Hfollow.
(* TODO: destruct sv, the current proof is valid for freshvars.
         for values and instackvars it should be straightforward
*)
destruct d as [|d'].
- simpl in Heval. discriminate.
- simpl in Heval. 
  destruct (follow_in_smap sv n sb) as [fsmap|] eqn: eq_follow_sv;
    try discriminate.
  destruct fsmap as [sv1 maxid1 sb1] eqn: eq_fsmap.
  pose proof (follow_suffix sb sv n sv1 maxid1 sb1 eq_follow_sv)
    as eq_follow_suff.
  destruct eq_follow_suff as [prefix eq_prefix].
  simpl. rewrite -> PeanoNat.Nat.eqb_refl.
  injection Hfollow as eq_sv_plain eq_maxidx' eq_sb'.
  apply follow_no_fresh in eq_follow_sv.
  rewrite <- eq_sv_plain.
  rewrite -> eq_follow_sv.
  case sv1 as [basicv|tag|op args|offset smem|key sstrg|offset size smem]
    eqn: eq_sv1.
  + (* SymBasicVal basicv *)
    destruct basicv as [val|var|fvar] eqn: eq_basicv; try assumption.
  + (* SymMETAPUSH tag *)
    assumption.
  + (* SymOp op args *)
    destruct (ops op) as [nargs f H_comm H_exts_ind] eqn: eq_ops_op.
    destruct (length args =? nargs) eqn: eq_len; try discriminate.
    destruct (map_option
               (fun sv' : sstack_val =>
               eval_sstack_val' d' sv' stk mem strg exts maxid1 sb1 ops) args)
      as [vargs|] eqn: eq_mapo; try discriminate.
    rewrite <- Heval.
    rewrite -> lambda_eval'_maxid_indep_eq with (m:=maxid1).
    pose proof (map_option_preserv_prefix d' stk mem strg exts sb1 sb ops
      args vargs prefix instk_height n 
      maxid1 maxid1 eq_mapo eq_prefix Hvalid) as eq_mapo2.
    rewrite -> eq_mapo2.
    reflexivity.
  + (* SymMLOAD offset smem *)
    destruct (map_option
            (instantiate_memory_update
               (fun sv : sstack_val =>
                eval_sstack_val' d' sv stk mem strg exts maxid1 sb1 ops))
            smem) as [mem_updates|] eqn: eq_mapo; try discriminate.
    destruct (eval_sstack_val' d' offset stk mem strg exts maxid1 sb1 ops)  
      as [offsetv|] eqn: eq_eval_offset; try discriminate.
    rewrite <- Heval.
    pose proof (map_option_preserv_prefix_inst_mem d' stk mem strg exts sb1
      sb ops smem mem_updates prefix
      instk_height n maxid1 n eq_mapo eq_prefix Hvalid) as eq_mapo2.
    rewrite -> eq_mapo2.
    pose proof (eval_sstack_val'_extend_sb_indep instk_height n d' stk mem 
      strg exts maxid1 n sb sb1 ops prefix Hvalid eq_prefix
      offset offsetv eq_eval_offset) as eq_eval_offset2.
    rewrite -> eq_eval_offset2.
    reflexivity.
  + (* SymSLOAD key sstrg *)
    destruct (map_option
            (instantiate_storage_update
               (fun sv : sstack_val =>
                eval_sstack_val' d' sv stk mem strg exts maxid1 sb1 ops))
            sstrg) as [strg_updates|] eqn: eq_mapo; try discriminate.
    destruct (eval_sstack_val' d' key stk mem strg exts maxid1 sb1 ops)
      as [keyv|] eqn: eq_eval_key; try discriminate.
    rewrite <- Heval.
    pose proof (map_option_preserv_prefix_inst_strg d' stk mem strg exts sb1
      sb ops sstrg strg_updates prefix
      instk_height n maxid1 n eq_mapo eq_prefix Hvalid) as eq_mapo2.
    rewrite -> eq_mapo2.
    pose proof (eval_sstack_val'_extend_sb_indep instk_height n d' stk mem 
      strg exts maxid1 n sb sb1 ops prefix Hvalid eq_prefix
      key keyv eq_eval_key) as eq_eval_key2.
    rewrite -> eq_eval_key2.
    reflexivity.
  + (* SymSHA3 offset size smem *)
    destruct (map_option
            (instantiate_memory_update
               (fun sv : sstack_val =>
                eval_sstack_val' d' sv stk mem strg exts maxid1 sb1 ops))
            smem) as [mem_updates|] eqn: eq_mapo; try discriminate.
    destruct (eval_sstack_val' d' offset stk mem strg exts maxid1 sb1 ops)
      as [offsetv|] eqn: eq_eval_offset; try discriminate.
    destruct (eval_sstack_val' d' size stk mem strg exts maxid1 sb1 ops)
      as [sizev|] eqn: eq_eval_size; try discriminate.
    rewrite <- Heval.
    pose proof (map_option_preserv_prefix_inst_mem d' stk mem strg exts sb1
      sb ops smem mem_updates prefix
      instk_height n maxid1 n eq_mapo eq_prefix Hvalid) as eq_mapo2.
    rewrite -> eq_mapo2.
    pose proof (eval_sstack_val'_extend_sb_indep instk_height n d' stk mem 
      strg exts maxid1 n sb sb1 ops prefix Hvalid eq_prefix offset offsetv 
      eq_eval_offset) as eq_eval_offset2.
    rewrite -> eq_eval_offset2.
    pose proof (eval_sstack_val'_extend_sb_indep instk_height n d' stk mem 
      strg exts maxid1 n sb sb1 ops prefix Hvalid eq_prefix
      size sizev eq_eval_size) as eq_eval_size2.
    rewrite -> eq_eval_size2.
    reflexivity.
Qed.


(* Two successful evaluations return the same value in a valid prefix, 
   regardless of the number of steps or maxidx *)
Lemma eval_eq_prefix: forall instk_height n n' sb sb' ops sv stk mem strg 
  exts d d' prefix v1 v2,
valid_bindings instk_height n sb ops ->
n > n' ->
sb = prefix ++ sb' ->  
eval_sstack_val' d  sv stk mem strg exts n  sb  ops = Some v1 ->
eval_sstack_val' d' sv stk mem strg exts n' sb' ops = Some v2 ->
v1 = v2.
Proof.
intros instk_height n n' sb sb' ops sv stk mem strg exts d d' prefix v1 v2.
intros Hvalid n_gt_n' Hprefix Heval1 Heval2.
rewrite -> eval'_maxidx_indep_eq with (m:=n) in Heval2.  
apply eval_sstack_val'_extend_sb with (instk_height:=instk_height)(sb:=sb)
  (prefix:=prefix) in Heval2; try assumption.
destruct (d' <=? d) eqn: d'_lte_d.
- rewrite -> PeanoNat.Nat.leb_le in d'_lte_d.
  apply eval_sstack_val'_preserved_when_depth_extended_le with (d2:=d) in Heval2;
    try assumption.  
  rewrite -> Heval1 in Heval2.
  injection Heval2.
  trivial.
- rewrite -> PeanoNat.Nat.leb_gt in d'_lte_d.
  apply eval_sstack_val'_preserved_when_depth_extended_lt with (d2:=d') in Heval1;
    try assumption.  
  rewrite -> Heval1 in Heval2.
  injection Heval2.
  trivial.
Qed.


Lemma eval'_succ_then_nonzero: forall maxidx sv stk mem strg exts idx sb ops v,
eval_sstack_val' maxidx sv stk mem strg exts idx sb ops = Some v ->
exists n, maxidx = S n.
Proof.
intros maxidx sv stk mem strg exts idx sb ops v.
intros Heval.
destruct maxidx as [|n].
- simpl in Heval. discriminate.
- exists n. reflexivity.
Qed.


Lemma safe_fcm_ext_1: forall fcmp, 
  safe_sstack_val_cmp fcmp -> (safe_sstack_val_cmp_ext_1 (fun _ : nat => fcmp)).
Proof.
intros fcmp Hfcmp.
unfold safe_sstack_val_cmp_ext_1.
intros d. unfold safe_sstack_val_cmp_ext_1_d. intros d' Hd'.
assumption.
Qed.


End Optimizations_Common.

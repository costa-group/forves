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

Require Import FORVES.optimizations_def.
Import Optimizations_Def.

Require Import FORVES.optimizations_common.
Import Optimizations_Common.

Require Import List.
Import ListNotations.

Require Import Coq.Program.Equality.


Module Opt_and_and_mask.


Fixpoint is_2_pow_n_minus_1' (n: N) (size: nat): option nat :=
  match size with
  | O => None
  | S size' => 
      if N.eqb n (N.sub (N.pow (2%N) (N.of_nat size)) 1) then Some size
      else is_2_pow_n_minus_1' n size'
  end.


Definition is_2_pow_n_minus_1 (w: EVMWord) : option nat :=
  is_2_pow_n_minus_1' (wordToN w) EVMWordSize.


Definition is_mask_const (sv: sstack_val) (maxid: nat) (sb: sbindings) 
  : option EVMWord :=
  match follow_in_smap sv maxid sb with 
  | Some (FollowSmapVal (SymBasicVal (Val v)) idx' sb') => 
    match is_2_pow_n_minus_1 v with 
    | Some _ => Some v
    | None => None
    end
  | _ => None
  end.

  
Definition is_and_const_mask (sv: sstack_val)
  (maxid: nat) (sb: sbindings) :=
match follow_in_smap sv maxid sb with 
| Some (FollowSmapVal (SymOp AND [arg1; arg2]) idx' sb') => 
  match is_mask_const arg1 maxid sb' with
  | Some x => Some (x, arg2)
  | None => 
    match is_mask_const arg2 maxid sb' with
    | Some x => Some (x, arg1)
    | None => None
    end
  end
| _ => None
end.


Definition min_word (a b: EVMWord) : EVMWord :=
  if (N.ltb (wordToN a) (wordToN b)) 
  then a else b.


(* 
  AND(a, AND(b, X)) = AND(min(a,b), X)
  AND(a, AND(X, b)) = AND(min(a,b), X)
  AND(AND(b, X), a) = AND(min(a,b), X)
  AND(AND(X, b), a) = AND(min(a,b), X)
    if a = 2^a'-1 and b = 2^b'-1

  Solidity optimization 
  https://github.com/ethereum/solidity/blob/abc46f309676637164076ca1a5b805cd90635bfa/libevmasm/RuleList.h#L558    
 *) 


Definition optimize_and_and_mask_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp AND [arg1; arg2] =>
  match is_mask_const arg1 maxid sb with
  | Some aval =>
    match is_and_const_mask arg2 maxid sb with
    | Some (bval, x) =>
      let min_mask := min_word aval bval in 
      (SymOp AND [Val min_mask; x], true)
    | _ => (val, false)
    end
  | _ => 
    match is_mask_const arg2 maxid sb with
    | Some aval =>
      match is_and_const_mask arg1 maxid sb with
      | Some (bval, x) =>
        let min_mask := min_word aval bval in 
        (SymOp AND [Val min_mask; x], true)
      | _ => (val, false)
      end
    | _ => (val, false)
    end
  end
| _ => (val, false)
end.

(*
Lemma mask_sizes: forall (a: word EVMWordSize) (n: nat),
is_2_pow_n_minus_1 a = Some n ->
a = Word.combine (wzero (EVMWordSize -n)) (wones n).
*)


Lemma and_masks_snd: forall (a b m: EVMWord) (a' b': nat) (exts: externals),
is_2_pow_n_minus_1 a = Some a' ->
is_2_pow_n_minus_1 b = Some b' ->
m = min_word a b ->
evm_and exts [a; b] = m.
Proof.
Admitted.




Lemma and_and_mask_snd: forall (a b z m: EVMWord) (a' b': nat) (exts: externals),
is_2_pow_n_minus_1 a = Some a' ->
is_2_pow_n_minus_1 b = Some b' ->
m = min_word a b ->
evm_and exts [a; evm_and exts [b; z]] = evm_and exts [m; z].
Proof.
intros a b z m a' b' exts a_mask b_mask m_min.
unfold evm_and.
rewrite -> wand_assoc.
rewrite <- evm_and_step with (exts:=exts).
rewrite <- evm_and_step with (exts:=exts).
rewrite <- evm_and_step with (exts:=exts).
rewrite -> and_masks_snd with (a:=a)(m:=m)(a':=a')(b':=b'); try assumption.
reflexivity.
Qed.


(*
Example ex_and_and_mask1:
  let a := NToWord EVMWordSize 63 in  (* 2^6 - 1 *)  
  let b := NToWord EVMWordSize 255 in (* 2^8 - 1 *)  
  let z := NToWord EVMWordSize 4095 in  (* 2^12 - 1 *)

  evm_and empty_externals [a; evm_and empty_externals [b; z]] = 
  evm_and empty_externals [a; z].
Proof.
reflexivity.
Qed.  
*)


Lemma optimize_and_and_mask_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_and_and_mask_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros _ Hvalid_smapv_val Hvalid Hoptm_sbinding.
unfold optimize_and_and_mask_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try try inject_rw Hoptm_sbinding eq_val'.
destruct args as [|arg1 r1]; try inject_rw Hoptm_sbinding eq_val'.
destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
destruct r2 as [|arg3 r3]; try inject_rw Hoptm_sbinding eq_val'.

unfold valid_smap_value in Hvalid_smapv_val.
assert (Hvalid_smapv_val' := Hvalid_smapv_val).
unfold valid_stack_op_instr in Hvalid_smapv_val.
simpl in Hvalid_smapv_val.
destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].

destruct (is_mask_const arg1 n sb) as [aval|] eqn: eq_mask_arg1.
- destruct (is_and_const_mask arg2 n sb) as [[bval x]|] eqn: and_const_arg2
    ; try inject_rw Hoptm_sbinding eq_val'.
  unfold is_mask_const in eq_mask_arg1.
  destruct (follow_in_smap arg1 n sb) as [fsmv_arg1|] eqn: eq_follow_arg1;
    try discriminate.
  destruct fsmv_arg1 as [smv_arg1 idx' sb'].
  destruct smv_arg1 as [aval_ss_val| | | | | ]; try discriminate.
  destruct aval_ss_val as [aval'| |]; try discriminate.
  destruct (is_2_pow_n_minus_1 aval') as [na|] eqn: eq_is_mask_aval'; try discriminate.

  unfold is_and_const_mask in and_const_arg2.
  destruct (follow_in_smap arg2 n sb) as [fsmv_arg2|] eqn: eq_follow_arg2;
    try discriminate.
  destruct fsmv_arg2 as [smv_arg2 idx'' sb''].
  destruct smv_arg2 as [| |label2 args2| | | ]; try discriminate.
  destruct label2; try discriminate.
  destruct args2 as [|arg21 r21]; try discriminate.
  destruct r21 as [|arg22 r22]; try discriminate.
  destruct r22; try discriminate.

  destruct (is_mask_const arg21 n sb'') as [bval'|] eqn: eq_mask_arg21.
  + (* AND(a, AND(b, x) )*) 
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    injection and_const_arg2 as eq_bval eq_x.
    unfold valid_smap_value.
    unfold valid_stack_op_instr.
    simpl.
    split; try intuition.
    
    pose proof (valid_follow_in_smap sb arg2 instk_height n evm_stack_opm
      (SymOp AND [arg21; arg22]) idx'' sb'' Hvalid_arg2 Hvalid eq_follow_arg2)
      as Hvalid2.
    destruct Hvalid2 as [Hvalid_smap [Hvalid_sb'' Himpl]].
    pose proof (not_basic_value_smv_symop AND [arg21; arg22]) as Hnotbasic.
    apply Himpl in Hnotbasic.
    simpl in Hvalid_smap. unfold valid_stack_op_instr in Hvalid_smap.
    simpl in Hvalid_smap.
    destruct Hvalid_smap as [_ [_ [Hvalid_arg22 _]]].
    rewrite -> eq_x in Hvalid_arg22.
    apply valid_sstack_value_gt with (m:=n) in Hvalid_arg22; try assumption.
  + destruct (is_mask_const arg22 n sb'') as [bval''|] eqn: eq_mask_arg22;
      try discriminate.
    (* AND(a, AND(x, b) )*) 
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    injection and_const_arg2 as eq_bval eq_x.
    unfold valid_smap_value.
    unfold valid_stack_op_instr.
    simpl.
    split; try intuition.
    
    pose proof (valid_follow_in_smap sb arg2 instk_height n evm_stack_opm
      (SymOp AND [arg21; arg22]) idx'' sb'' Hvalid_arg2 Hvalid eq_follow_arg2)
      as Hvalid2.
    destruct Hvalid2 as [Hvalid_smap [Hvalid_sb'' Himpl]].
    pose proof (not_basic_value_smv_symop AND [arg21; arg22]) as Hnotbasic.
    apply Himpl in Hnotbasic.
    simpl in Hvalid_smap. unfold valid_stack_op_instr in Hvalid_smap.
    simpl in Hvalid_smap.
    destruct Hvalid_smap as [_ [Hvalid_arg21 [_  _]]].
    rewrite -> eq_x in Hvalid_arg21.
    apply valid_sstack_value_gt with (m:=n) in Hvalid_arg21; try assumption.
- destruct (is_mask_const arg2 n sb) as [aval|] eqn: eq_mask_arg2;
    try inject_rw Hoptm_sbinding eq_val'.
  destruct (is_and_const_mask arg1 n sb) as [[bval x]|] eqn: and_const_arg1
    ; try inject_rw Hoptm_sbinding eq_val'.
  unfold is_and_const_mask in and_const_arg1.
  destruct (follow_in_smap arg1 n sb) as [fsmv_arg1| ] eqn: eq_follow_arg1;
      try discriminate.
  destruct fsmv_arg1 as [smv_arg1 idx' sb'].
  destruct smv_arg1 as [| |label1 args1 | | | ]; try discriminate.
  destruct label1; try discriminate.
  destruct args1 as [|arg11 r1]; try discriminate.
  destruct r1 as [|arg12 r2]; try discriminate.
  destruct r2; try discriminate.
  
  destruct (is_mask_const arg11 n sb') as [bval'|] eqn: eq_mask_arg11.
  + (* AND(AND(b, x), a) *) 
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    injection and_const_arg1 as eq_bval eq_x.
    unfold valid_smap_value.
    unfold valid_stack_op_instr.
    simpl.
    split; try intuition.
    
    pose proof (valid_follow_in_smap sb arg1 instk_height n evm_stack_opm
      (SymOp AND [arg11; arg12]) idx' sb' Hvalid_arg1 Hvalid
      eq_follow_arg1) as Hvalid1.
    destruct Hvalid1 as [Hvalid_smap [Hvalid_sb' Himpl]].
    pose proof (not_basic_value_smv_symop AND [arg11; arg12]) as Hnotbasic.
    apply Himpl in Hnotbasic.

    simpl in Hvalid_smap.
    unfold valid_stack_op_instr in Hvalid_smap.
    simpl in Hvalid_smap.
    destruct Hvalid_smap as [_ [_ [Hvalid_arg12 _]]].
    rewrite -> eq_x in Hvalid_arg12.
    apply valid_sstack_value_gt with (m:=n) in Hvalid_arg12; try assumption.
  + destruct (is_mask_const arg12 n sb') as [bval'|] eqn: eq_mask_arg12;
      try discriminate.

    (* AND(AND(x, b), a) *)  
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    simpl.
    unfold valid_stack_op_instr.
    simpl.
    split; try intuition.
    injection and_const_arg1 as eq_bval eq_x.

    pose proof (valid_follow_in_smap sb arg1 instk_height n evm_stack_opm
      (SymOp AND [arg11; arg12]) idx' sb' Hvalid_arg1 Hvalid
      eq_follow_arg1) as Hvalid1.
    destruct Hvalid1 as [Hvalid_smap [Hvalid_sb' Himpl]].
    pose proof (not_basic_value_smv_symop AND [arg11; arg12]) as Hnotbasic.
    apply Himpl in Hnotbasic.

    simpl in Hvalid_smap.
    unfold valid_stack_op_instr in Hvalid_smap.
    simpl in Hvalid_smap.
    destruct Hvalid_smap as [_ [Hvalid_arg11 [_ _]]].
    rewrite -> eq_x in Hvalid_arg11.
    apply valid_sstack_value_gt with (m:=n) in Hvalid_arg11; try assumption.
Qed.


Lemma follow_in_smap_maxidx_indep_eq:
  forall ssv smv (n n' m : nat) (sb sb' : sbindings),
  follow_in_smap ssv n sb = Some (FollowSmapVal smv n' sb') ->
  exists m', follow_in_smap ssv m sb = Some (FollowSmapVal smv m' sb').
Proof.
intros ssv smv n n' m sb sb' Hfollow.
revert ssv smv n n' m sb' Hfollow.
induction sb as [|h t].
- intros ssv smv n n' m sb' Hfollow.
  destruct ssv as [v| n1| idx].
  + exists m. 
    simpl in Hfollow. 
    injection Hfollow as eq_smv eq_n eq_sb'.
    rewrite <- eq_sb'.
    rewrite <- eq_smv.
    simpl.
    reflexivity.
  + exists m. 
    simpl in Hfollow. 
    injection Hfollow as eq_smv eq_n eq_sb'.
    rewrite <- eq_sb'.
    rewrite <- eq_smv.
    simpl.
    reflexivity.
  + simpl in Hfollow. discriminate.
- intros ssv smv n n' m sb' Hfollow.
  destruct ssv as [v| n1| idx].
  + exists m. 
  simpl in Hfollow. 
  injection Hfollow as eq_smv eq_n eq_sb'.
  rewrite <- eq_sb'.
  rewrite <- eq_smv.
  simpl.
  reflexivity.
  + exists m. 
  simpl in Hfollow. 
  injection Hfollow as eq_smv eq_n eq_sb'.
  rewrite <- eq_sb'.
  rewrite <- eq_smv.
  simpl.
  reflexivity.
  + simpl in Hfollow.
    destruct h as [key' smv'].
    destruct (key' =? idx) eqn: eq_key'.
    * destruct (is_fresh_var_smv smv') as [idx'|] eqn: eq_isfresh.
      -- exists n'.
         simpl.
         rewrite -> eq_key'.
         rewrite -> eq_isfresh.
         assumption.
      -- exists n'.
         simpl.
         rewrite -> eq_key'.
         rewrite -> eq_isfresh.
         assumption.
    * pose proof (IHt (FreshVar idx) smv key' n' m sb' Hfollow).
      destruct H as [m' Hfollow'].
      exists n'.
      simpl.
      rewrite -> eq_key'.
      assumption.
Qed.      

  


Lemma optimize_and_and_mask_sbinding_snd:
opt_sbinding_snd optimize_and_and_mask_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_and_and_mask_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_and_and_mask_sbinding_smapv_valid. 

- (* evaluation is preserved *) 
  intros stk mem strg exts v Hlen Heval_orig.
  unfold optimize_and_and_mask_sbinding in Hoptm_sbinding.
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymOp label args *)
  destruct label eqn: eq_label; try inject_rw Hoptm_sbinding eq_val'.
  destruct args as [|arg1 r1] eqn: eq_args; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r2 as [|arg3 r3]; try inject_rw Hoptm_sbinding eq_val'.
  destruct (is_mask_const arg1 idx sb) 
    as [aval|] eqn: eq_is_const_arg1.

  + destruct (is_and_const_mask arg2 idx sb) as [[bval x]|] eqn: eq_is_and;
      try inject_rw Hoptm_sbinding eq_val'.
    unfold is_mask_const in eq_is_const_arg1.
    destruct (follow_in_smap arg1 idx sb) as [fsmv1|] eqn: eq_follow_arg1;
      try discriminate.
    destruct fsmv1 as [smv1 idx' sb'].
    destruct smv1 as [a_ss_val| | | | | ]; try discriminate.
    destruct a_ss_val as [aval'| |]; try discriminate.
    destruct (is_2_pow_n_minus_1 aval') as [na|] eqn: eq_is_mask_aval'; try discriminate.

    unfold is_and_const_mask in eq_is_and.
    destruct (follow_in_smap arg2 idx sb) as [fsmv2|] eqn: eq_follow_arg2;
      try discriminate.
    destruct fsmv2 as [smv2 idx'' sb''].
    destruct smv2 as [| |label2 args2| | | ]; try discriminate.
    destruct label2; try discriminate.
    destruct args2 as [|arg21 r21]; try discriminate.
    destruct r21 as [|arg22 r22]; try discriminate.
    destruct r22; try discriminate.
    destruct (is_mask_const arg21 idx sb'') as [bval'|] eqn: eq_is_mask_arg21.

    * (* AND(a, AND(b,X)) *)
      unfold is_mask_const in eq_is_mask_arg21.
      destruct (follow_in_smap arg21 idx sb'') as [fsmv21|] eqn: eq_follow_arg21;
        try discriminate.
      destruct fsmv21 as [smv21 idx''' sb'''].
      destruct smv21 as [b_ss_val| | | | | ]; try discriminate.
      destruct b_ss_val as [bval''| |]; try discriminate.
      destruct (is_2_pow_n_minus_1 bval'') as [nb|] eqn: eq_is_mask_bval''; try discriminate.
      
      unfold eval_sstack_val in Heval_orig.
      simpl in Heval_orig.
      rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
      simpl in Heval_orig.
      destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb 
        evm_stack_opm) as [arg1v|] eqn: eq_eval_arg1; try discriminate.
      destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb evm_stack_opm)
        as [arg2v|] eqn: eq_eval_arg2; try discriminate.

      injection Hoptm_sbinding as eq_val' _.
      rewrite <- eq_val'.
      rewrite <- Heval_orig.

      injection eq_is_and as eq_bval eq_x.
      rewrite -> eq_bval in eq_is_mask_arg21.
      injection eq_is_mask_arg21 as eq_bval''.
      rewrite -> eq_bval'' in eq_is_mask_bval''.
      injection eq_is_const_arg1 as eq_aval.
      rewrite -> eq_aval in eq_is_mask_aval'.
      rewrite <- eq_x.

      simpl in Hvalid.
      destruct Hvalid as [eq_maxidx [Hvalid_and Hvalid_sb]].

      rewrite eq_maxidx in eq_eval_arg1.
      simpl eval_sstack_val' in eq_eval_arg1.
      rewrite -> eq_follow_arg1 in eq_eval_arg1.
      injection eq_eval_arg1 as eq_arg1v.
      rewrite <- eq_arg1v.
      rewrite eq_aval.

      rewrite eq_maxidx in eq_eval_arg2.
      simpl in eq_eval_arg2.
      rewrite -> eq_follow_arg2 in eq_eval_arg2.
      simpl in eq_eval_arg2.
      destruct (eval_sstack_val' idx arg21 stk mem strg exts idx'' sb'' 
        evm_stack_opm) as [arg21v|] eqn: eq_eval_arg21; try discriminate.
      destruct (eval_sstack_val' idx arg22 stk mem strg exts idx'' sb'' 
        evm_stack_opm) as [arg22v|] eqn: eq_eval_arg22; try discriminate.

      apply eval'_succ_then_nonzero in eq_eval_arg21 as idx_gt_idx''.
      destruct idx_gt_idx'' as [p_idx succ_idx].
      rewrite -> succ_idx in eq_eval_arg21.
      simpl in eq_eval_arg21.
      apply follow_in_smap_maxidx_indep_eq with (m:=idx'') in eq_follow_arg21 as 
        eq_follow_arg21_alt.
      destruct eq_follow_arg21_alt as [idx'''_alt eq_follow_arg21_alt].
      rewrite -> eq_follow_arg21_alt in eq_eval_arg21.
      injection eq_eval_arg21 as eq_arg21v.

      unfold eval_sstack_val.
      simpl.
      rewrite -> PeanoNat.Nat.eqb_refl.
      simpl.
      rewrite -> eq_maxidx.
      rewrite -> eval_sstack_val'_const.
      apply follow_suffix in eq_follow_arg2 as eq_prefix_sb.
      destruct eq_prefix_sb as [prefix eq_prefix].
      apply eval_sstack_val'_preserved_when_depth_extended in eq_eval_arg22 
        as eq_eval_arg22_succ.
      rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eq_eval_arg22_succ.
      pose proof (eval_sstack_val'_extend_sb instk_height (S idx) stk mem strg exts idx
        sb sb'' evm_stack_opm prefix Hvalid_sb eq_prefix arg22 arg22v eq_eval_arg22_succ)
        as eval_arg22_alt.
      rewrite -> eval_arg22_alt.
      
      rewrite <- evm_and_step with (exts:=exts).
      injection eq_eval_arg2 as eq_arg2v.
      rewrite <- eq_arg2v.
      rewrite <- evm_and_step with (exts:=exts).
      rewrite <- eq_arg21v.
      rewrite -> eq_bval''.
      rewrite -> and_and_mask_snd with (m:=min_word aval bval)(a':=na)(b':=nb);
        try assumption; try reflexivity.

    * destruct (is_mask_const arg22 idx sb'') as [bval'|] eqn: eq_is_mask_arg22;
        try discriminate.
      (* AND(a, AND(X,b)) *)
      unfold is_mask_const in eq_is_mask_arg22.
      destruct (follow_in_smap arg22 idx sb'') as [fsmv22|] eqn: eq_follow_arg22;
        try discriminate.
      destruct fsmv22 as [smv22 idx''' sb'''].
      destruct smv22 as [b_ss_val| | | | | ]; try discriminate.
      destruct b_ss_val as [bval''| |]; try discriminate.
      destruct (is_2_pow_n_minus_1 bval'') as [nb|] eqn: eq_is_mask_bval''; try discriminate.
      
      unfold eval_sstack_val in Heval_orig.
      simpl in Heval_orig.
      rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
      simpl in Heval_orig.
      destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb 
        evm_stack_opm) as [arg1v|] eqn: eq_eval_arg1; try discriminate.
      destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb evm_stack_opm)
        as [arg2v|] eqn: eq_eval_arg2; try discriminate.

      injection Hoptm_sbinding as eq_val' _.
      rewrite <- eq_val'.
      rewrite <- Heval_orig.

      injection eq_is_and as eq_bval eq_x.
      rewrite -> eq_bval in eq_is_mask_arg22.
      injection eq_is_mask_arg22 as eq_bval''.
      rewrite -> eq_bval'' in eq_is_mask_bval''.
      injection eq_is_const_arg1 as eq_aval.
      rewrite -> eq_aval in eq_is_mask_aval'.
      rewrite <- eq_x.

      simpl in Hvalid.
      destruct Hvalid as [eq_maxidx [Hvalid_and Hvalid_sb]].

      rewrite eq_maxidx in eq_eval_arg1.
      simpl eval_sstack_val' in eq_eval_arg1.
      rewrite -> eq_follow_arg1 in eq_eval_arg1.
      injection eq_eval_arg1 as eq_arg1v.
      rewrite <- eq_arg1v.
      rewrite eq_aval.

      rewrite eq_maxidx in eq_eval_arg2.
      simpl in eq_eval_arg2.
      rewrite -> eq_follow_arg2 in eq_eval_arg2.
      simpl in eq_eval_arg2.
      destruct (eval_sstack_val' idx arg21 stk mem strg exts idx'' sb'' 
        evm_stack_opm) as [arg21v|] eqn: eq_eval_arg21; try discriminate.
      destruct (eval_sstack_val' idx arg22 stk mem strg exts idx'' sb'' 
        evm_stack_opm) as [arg22v|] eqn: eq_eval_arg22; try discriminate.

      apply eval'_succ_then_nonzero in eq_eval_arg22 as idx_gt_idx''.
      destruct idx_gt_idx'' as [p_idx succ_idx].
      rewrite -> succ_idx in eq_eval_arg22.
      simpl in eq_eval_arg22.
      apply follow_in_smap_maxidx_indep_eq with (m:=idx'') in eq_follow_arg22 as 
        eq_follow_arg22_alt.
      destruct eq_follow_arg22_alt as [idx'''_alt eq_follow_arg22_alt].
      rewrite -> eq_follow_arg22_alt in eq_eval_arg22.
      injection eq_eval_arg22 as eq_arg22v.

      unfold eval_sstack_val.
      simpl.
      rewrite -> PeanoNat.Nat.eqb_refl.
      simpl.
      rewrite -> eq_maxidx.
      rewrite -> eval_sstack_val'_const.
      apply follow_suffix in eq_follow_arg2 as eq_prefix_sb.
      destruct eq_prefix_sb as [prefix eq_prefix].
      apply eval_sstack_val'_preserved_when_depth_extended in eq_eval_arg21 
        as eq_eval_arg21_succ.
      rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eq_eval_arg21_succ.
      pose proof (eval_sstack_val'_extend_sb instk_height (S idx) stk mem strg exts idx
        sb sb'' evm_stack_opm prefix Hvalid_sb eq_prefix arg21 arg21v eq_eval_arg21_succ)
        as eval_arg21_alt.
      rewrite -> eval_arg21_alt.
      
      rewrite <- evm_and_step with (exts:=exts).
      injection eq_eval_arg2 as eq_arg2v.
      rewrite <- eq_arg2v.
      rewrite <- evm_and_step with (exts:=exts).
      rewrite <- eq_arg22v.
      rewrite -> eq_bval''.
      rewrite and_comm with (a:=arg21v)(b:=bval).
      rewrite -> and_and_mask_snd with (m:=min_word aval bval)(a':=na)(b':=nb);
        try assumption; try reflexivity.

  +  
Admitted.


End Opt_and_and_mask.

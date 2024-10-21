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

(* For debugging with print_id *)
From ReductionEffect Require Import PrintingEffect.


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
  match is_mask_const arg1 maxid sb with
  | Some x => Some (x, arg2)
  | None => 
    match is_mask_const arg2 maxid sb with
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
  AND(A, AND(B, X)) = AND(min(A,B), X)
  AND(A, AND(X, B)) = AND(min(A,B), X)
  AND(AND(B, X), A) = AND(min(A,B), X)
  AND(AND(X, B), A) = AND(min(A,B), X)
    if A = 2^N-1 and B = 2^N-1

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
      let _ := print_id [wordToN aval] in 
      match is_and_const_mask arg1 maxid sb with
      | Some (bval, x) =>
        let _ := print_id [wordToN aval; wordToN bval] in 
        let min_mask := min_word aval bval in 
        (SymOp AND [Val min_mask; x], true)
      | _ => (val, false)
      end
    | _ => (val, false)
    end
  end
| _ => (val, false)
end.


Definition dummy : sstack_val_cmp_t :=
fun (sv1: sstack_val) =>
fun (sv2: sstack_val) =>
fun (n1: nat) =>
fun (sb1: sbindings) =>
fun (n2: nat) =>
fun (sb2: sbindings) =>
fun (n3 : nat) =>
fun (ops: stack_op_instr_map) =>
false.


(*
Eval cbv in 
  let val := SymOp AND [Val (NToWord EVMWordSize 63); FreshVar 0] in
  let fcmp := dummy in
  let sb := [(0, SymOp AND [Val (NToWord EVMWordSize 4095); InStackVar 17])] in
  let maxid := 1 in
  let instk_height := 20 in
  let ops := evm_stack_opm in
  optimize_and_and_mask_sbinding val fcmp sb maxid instk_height ops.
*)


Lemma optimize_and_and_mask_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_and_and_mask_sbinding.
Proof.
Admitted.
(*
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
destruct (is_and arg1 arg2 fcmp n instk_height sb evm_stack_opm) 
  as [y|] eqn: eq_is_and.
- unfold is_and in eq_is_and.
  destruct (follow_in_smap arg2 n sb) as [fsmv_arg2|] eqn: eq_follow_arg2;
    try discriminate.
  destruct fsmv_arg2 as [smv_arg2 idx' sb'] eqn: eq_fsmv_arg2.
  destruct smv_arg2 as [x1|x2|label2 args2|x4|x5|x6] eqn: eq_smv;
    try discriminate.
  destruct label2 eqn: eq_label2; try inject_rw Hoptm_sbinding eq_val';
    try discriminate.
  destruct args2 as [|arg21 r21]; try discriminate.
  destruct r21 as [|arg22 r22]; try discriminate.
  destruct r22; try discriminate.
  destruct (fcmp arg1 arg21 n sb idx' sb' instk_height evm_stack_opm)
    eqn: eq_fcmp_arg1_arg21.
    
  + (* arg1 ~ arg21 *)
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    simpl in Hvalid_smapv_val.
    unfold valid_stack_op_instr in Hvalid_smapv_val.
    simpl in Hvalid_smapv_val.
    destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
    
    pose proof (valid_follow_in_smap sb arg2 instk_height n evm_stack_opm
      (SymOp AND [arg21; arg22]) idx' sb' Hvalid_arg2 Hvalid
      eq_follow_arg2) as Hvalid2.
    destruct Hvalid2 as [Hvalid_smap [Hvalid_sb' Himpl]].
    simpl in Hvalid_smap. unfold valid_stack_op_instr in Hvalid_smap.
    simpl in Hvalid_smap.
    destruct Hvalid_smap as [_ [_ [Hvalid_arg22 _]]].
    pose proof (not_basic_value_smv_symop AND [arg21; arg22]) as eq_not_basic.
    apply Himpl in eq_not_basic as n_gt_idx'.
    
    injection eq_is_and as eq_y.
    rewrite <- eq_y.
    apply valid_sstack_value_gt with (m:=n) in Hvalid_arg22; try assumption.
    simpl. unfold valid_stack_op_instr. simpl. intuition.
  + destruct (fcmp arg1 arg22 n sb idx' sb' instk_height evm_stack_opm)
      eqn: eq_fcmp_arg1_arg22; try discriminate.
    * (* arg1 ~ arg22 *)
      injection Hoptm_sbinding as eq_val' _.
      rewrite <- eq_val'.
      simpl in Hvalid_smapv_val.
      unfold valid_stack_op_instr in Hvalid_smapv_val.
      simpl in Hvalid_smapv_val.
      destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
      
      pose proof (valid_follow_in_smap sb arg2 instk_height n evm_stack_opm
        (SymOp AND [arg21; arg22]) idx' sb' Hvalid_arg2 Hvalid
        eq_follow_arg2) as Hvalid2.
      destruct Hvalid2 as [Hvalid_smap [Hvalid_sb' Himpl]].
      simpl in Hvalid_smap. unfold valid_stack_op_instr in Hvalid_smap.
      simpl in Hvalid_smap.
      destruct Hvalid_smap as [_ [Hvalid_arg21 _]].
      pose proof (not_basic_value_smv_symop AND [arg21; arg22]) as eq_not_basic.
      apply Himpl in eq_not_basic as n_gt_idx'.
      
      injection eq_is_and as eq_y.
      rewrite <- eq_y.
      apply valid_sstack_value_gt with (m:=n) in Hvalid_arg21; try assumption.
      simpl. unfold valid_stack_op_instr. simpl. intuition.
- destruct (is_and arg2 arg1 fcmp n instk_height sb evm_stack_opm) 
    as [y|] eqn: eq_is_and'; try inject_rw Hoptm_sbinding eq_val'.
  unfold is_and in eq_is_and'.
  destruct (follow_in_smap arg1 n sb) as [fsmv_arg1|] eqn: eq_follow_arg1;
    try discriminate.
  destruct fsmv_arg1 as [smv_arg1 idx' sb'] eqn: eq_fsmv_arg1.
  destruct smv_arg1 as [x1|x2|label2 args2|x4|x5|x6] eqn: eq_smv;
    try discriminate.
  destruct label2 eqn: eq_label2; try inject_rw Hoptm_sbinding eq_val';
    try discriminate.
  destruct args2 as [|arg11 r11]; try discriminate.
  destruct r11 as [|arg12 r12]; try discriminate.
  destruct r12; try discriminate.
  destruct (fcmp arg2 arg11 n sb idx' sb' instk_height evm_stack_opm)
    eqn: eq_fcmp_arg2_arg11.
    
  + (* arg2 ~ arg11 *)
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    simpl in Hvalid_smapv_val.
    unfold valid_stack_op_instr in Hvalid_smapv_val.
    simpl in Hvalid_smapv_val.
    destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
    
    pose proof (valid_follow_in_smap sb arg1 instk_height n evm_stack_opm
      (SymOp AND [arg11; arg12]) idx' sb' Hvalid_arg1 Hvalid
      eq_follow_arg1) as Hvalid1.
    destruct Hvalid1 as [Hvalid_smap [Hvalid_sb' Himpl]].
    simpl in Hvalid_smap. unfold valid_stack_op_instr in Hvalid_smap.
    simpl in Hvalid_smap.
    destruct Hvalid_smap as [_ [_ [Hvalid_arg12 _]]].
    pose proof (not_basic_value_smv_symop AND [arg11; arg12]) as eq_not_basic.
    apply Himpl in eq_not_basic as n_gt_idx'.
    
    injection eq_is_and' as eq_y.
    rewrite <- eq_y.
    apply valid_sstack_value_gt with (m:=n) in Hvalid_arg12; try assumption.
    simpl. unfold valid_stack_op_instr. simpl. intuition.
  + destruct (fcmp arg2 arg12 n sb idx' sb' instk_height evm_stack_opm)
        eqn: eq_fcmp_arg2_arg12; try discriminate.
    (* arg1 ~ arg22 *)
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    simpl in Hvalid_smapv_val.
    unfold valid_stack_op_instr in Hvalid_smapv_val.
    simpl in Hvalid_smapv_val.
    destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
        
    pose proof (valid_follow_in_smap sb arg1 instk_height n evm_stack_opm
      (SymOp AND [arg11; arg12]) idx' sb' Hvalid_arg1 Hvalid
      eq_follow_arg1) as Hvalid1.
    destruct Hvalid1 as [Hvalid_smap [Hvalid_sb' Himpl]].
    simpl in Hvalid_smap. unfold valid_stack_op_instr in Hvalid_smap.
    simpl in Hvalid_smap.
    destruct Hvalid_smap as [_ [Hvalid_arg11 _]].
    pose proof (not_basic_value_smv_symop AND [arg11; arg12]) as eq_not_basic.
    apply Himpl in eq_not_basic as n_gt_idx'.
    
    injection eq_is_and' as eq_y.
    rewrite <- eq_y.
    apply valid_sstack_value_gt with (m:=n) in Hvalid_arg11; try assumption.
    simpl. unfold valid_stack_op_instr. simpl. intuition.
Qed.
*)


Lemma optimize_and_and_mask_sbinding_snd:
opt_sbinding_snd optimize_and_and_mask_sbinding.
Proof.
Admitted.
(*
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
  destruct (is_and arg1 arg2 fcmp idx instk_height sb evm_stack_opm) 
    as [y|] eqn: eq_is_and.
  + injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    
    unfold is_and in eq_is_and.
    destruct (follow_in_smap arg2 idx sb) as [fsmv|] eqn: eq_follow_arg2;
      try discriminate.
    destruct fsmv as [smv idx' sb'].
    destruct smv as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
    destruct label2 eqn: eq_label2; try discriminate.
    destruct args2 as [|arg21 r21]; try discriminate.
    destruct r21 as [|arg22 r22]; try discriminate.
    destruct r22; try discriminate.
    
    destruct (fcmp arg1 arg21 idx sb idx' sb' instk_height evm_stack_opm)
      eqn: eq_fcmp_arg1_arg21.
    * (* arg1 ~ arg21 *)
      
      unfold eval_sstack_val in Heval_orig.
      unfold eval_sstack_val.
    
      injection eq_is_and as eq_y.
      rewrite <- eq_y.
      
      simpl in Heval_orig.
      rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
      simpl in Heval_orig.
      destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb 
        evm_stack_opm) as [arg1v|] eqn: eq_eval_arg1; try discriminate.
      destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb 
        evm_stack_opm) as [arg2v|] eqn: eq_eval_arg2; try discriminate.
      rewrite <- Heval_orig.
      
      (* Every expression is valid *)
      simpl in Hvalid.
      destruct Hvalid as [eq_maxidx [Hvalid_and Hvalid_sb]].
      unfold valid_stack_op_instr in Hvalid_and.
      simpl in Hvalid_and.
      destruct Hvalid_and as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
      pose proof (valid_follow_in_smap sb arg2 instk_height idx 
        evm_stack_opm (SymOp AND [arg21; arg22]) idx' sb' Hvalid_arg2
        Hvalid_sb eq_follow_arg2) as [Hvalid_and [Hvalid_sb' Himpl]]. 
      pose proof (not_basic_value_smv_symop AND [arg21; arg22]) as eq_not_basic.
       apply Himpl in eq_not_basic as idx_gt_idx'.
      unfold valid_stack_op_instr in Hvalid_and.
      unfold valid_smap_value in Hvalid_and.
      unfold valid_stack_op_instr in Hvalid_and.
      simpl in Hvalid_and.
      destruct Hvalid_and as [_ [Hvalid_arg21 [Hvalid_arg22 _]]].

      rewrite -> eq_maxidx in eq_eval_arg2.
      simpl in eq_eval_arg2.
      rewrite -> eq_follow_arg2 in eq_eval_arg2.
      simpl in eq_eval_arg2.
      destruct (eval_sstack_val' idx arg21 stk mem strg exts idx' sb' 
        evm_stack_opm) as [arg21v|] eqn: eq_eval_arg21; try discriminate.
      destruct (eval_sstack_val' idx arg22 stk mem strg exts idx' sb' 
        evm_stack_opm) as [arg22v|] eqn: eq_eval_arg22; try discriminate.
      injection eq_eval_arg2 as eq_arg2v.
      rewrite <- eq_arg2v.
      unfold evm_and.

      (* arg1v and arg21v are the same *)
      symmetry in Hlen.
      pose proof (Hsafe_sstack_val_cmp arg1 arg21 idx sb idx' sb' instk_height 
        evm_stack_opm Hvalid_arg1 Hvalid_arg21 Hvalid_sb Hvalid_sb'
        eq_fcmp_arg1_arg21 stk mem strg exts Hlen) as [vv [eval_arg1 
        eval_arg21]].
      unfold eval_sstack_val in eval_arg1.
      rewrite <- eq_maxidx in eval_arg1.
      rewrite -> eq_eval_arg1 in eval_arg1.
      unfold eval_sstack_val in eval_arg21.
      apply eval_sstack_val'_preserved_when_depth_extended in 
        eq_eval_arg21.
      apply Gt.gt_n_S in idx_gt_idx' as Sidx_gt_Sidx'.
      pose proof (eval_sstack_val'_preserved_when_depth_extended_lt (S idx')
        (S idx) idx' sb' arg21 vv stk mem strg exts evm_stack_opm Sidx_gt_Sidx'
        eval_arg21) as eval_arg21_alt.
      rewrite -> eval_arg21_alt in eq_eval_arg21.
      rewrite <- eval_arg1 in eq_eval_arg21.
      injection eq_eval_arg21 as eq_arg1v_arg21v.
      rewrite -> eq_arg1v_arg21v.
      
      simpl. rewrite -> PeanoNat.Nat.eqb_refl. simpl.
      rewrite -> eq_eval_arg1.
      rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eq_eval_arg22.
      apply follow_suffix in eq_follow_arg2 as [prefix eq_prefix].
      pose proof (eval_sstack_val'_extend_sb instk_height idx stk mem strg
        exts idx sb sb' evm_stack_opm prefix Hvalid_sb eq_prefix arg22 arg22v
        eq_eval_arg22) as eval_arg22_alt.
      apply eval_sstack_val'_preserved_when_depth_extended in eval_arg22_alt.
      rewrite -> eq_maxidx.
      rewrite -> eval_arg22_alt. simpl.
      
      rewrite <- eq_arg1v_arg21v.
      rewrite -> wand_wand_1.
      reflexivity.

    * destruct (fcmp arg1 arg22 idx sb idx' sb' instk_height evm_stack_opm)
        eqn: eq_fcmp_arg1_arg22; try discriminate.
      (* arg1 ~ arg22 *)
      unfold eval_sstack_val in Heval_orig.
      unfold eval_sstack_val.
    
      injection eq_is_and as eq_y.
      rewrite <- eq_y.
      
      simpl in Heval_orig.
      rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
      simpl in Heval_orig.
      destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb 
        evm_stack_opm) as [arg1v|] eqn: eq_eval_arg1; try discriminate.
      destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb 
        evm_stack_opm) as [arg2v|] eqn: eq_eval_arg2; try discriminate.
      rewrite <- Heval_orig.
      
      (* Every expression is valid *)
      simpl in Hvalid.
      destruct Hvalid as [eq_maxidx [Hvalid_and Hvalid_sb]].
      unfold valid_stack_op_instr in Hvalid_and.
      simpl in Hvalid_and.
      destruct Hvalid_and as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
      pose proof (valid_follow_in_smap sb arg2 instk_height idx 
        evm_stack_opm (SymOp AND [arg21; arg22]) idx' sb' Hvalid_arg2
        Hvalid_sb eq_follow_arg2) as [Hvalid_and [Hvalid_sb' Himpl]]. 
      pose proof (not_basic_value_smv_symop AND [arg21; arg22]) as eq_not_basic.
       apply Himpl in eq_not_basic as idx_gt_idx'.
      unfold valid_stack_op_instr in Hvalid_and.
      unfold valid_smap_value in Hvalid_and.
      unfold valid_stack_op_instr in Hvalid_and.
      simpl in Hvalid_and.
      destruct Hvalid_and as [_ [Hvalid_arg21 [Hvalid_arg22 _]]].

      rewrite -> eq_maxidx in eq_eval_arg2.
      simpl in eq_eval_arg2.
      rewrite -> eq_follow_arg2 in eq_eval_arg2.
      simpl in eq_eval_arg2.
      destruct (eval_sstack_val' idx arg21 stk mem strg exts idx' sb' 
        evm_stack_opm) as [arg21v|] eqn: eq_eval_arg21; try discriminate.
      destruct (eval_sstack_val' idx arg22 stk mem strg exts idx' sb' 
        evm_stack_opm) as [arg22v|] eqn: eq_eval_arg22; try discriminate.
      injection eq_eval_arg2 as eq_arg2v.
      rewrite <- eq_arg2v.
      unfold evm_and.

      (* arg1v and arg22v are the same *)
      symmetry in Hlen.
      pose proof (Hsafe_sstack_val_cmp arg1 arg22 idx sb idx' sb' instk_height 
        evm_stack_opm Hvalid_arg1 Hvalid_arg22 Hvalid_sb Hvalid_sb'
        eq_fcmp_arg1_arg22 stk mem strg exts Hlen) as [vv [eval_arg1 
        eval_arg22]].
      unfold eval_sstack_val in eval_arg1.
      rewrite <- eq_maxidx in eval_arg1.
      rewrite -> eq_eval_arg1 in eval_arg1.
      unfold eval_sstack_val in eval_arg22.
      apply eval_sstack_val'_preserved_when_depth_extended in 
        eq_eval_arg22.
      apply Gt.gt_n_S in idx_gt_idx' as Sidx_gt_Sidx'.
      pose proof (eval_sstack_val'_preserved_when_depth_extended_lt (S idx')
        (S idx) idx' sb' arg22 vv stk mem strg exts evm_stack_opm Sidx_gt_Sidx'
        eval_arg22) as eval_arg22_alt.
      rewrite -> eval_arg22_alt in eq_eval_arg22.
      rewrite <- eval_arg1 in eq_eval_arg22.
      injection eq_eval_arg22 as eq_arg1v_arg22v.
      rewrite -> eq_arg1v_arg22v.
      
      simpl. rewrite -> PeanoNat.Nat.eqb_refl. simpl.
      rewrite -> eq_eval_arg1.
      rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eq_eval_arg21.
      apply follow_suffix in eq_follow_arg2 as [prefix eq_prefix].
      pose proof (eval_sstack_val'_extend_sb instk_height idx stk mem strg
        exts idx sb sb' evm_stack_opm prefix Hvalid_sb eq_prefix arg21 arg21v
        eq_eval_arg21) as eval_arg21_alt.
      apply eval_sstack_val'_preserved_when_depth_extended in eval_arg21_alt.
      rewrite -> eq_maxidx.
      rewrite -> eval_arg21_alt. simpl.
      
      rewrite <- eq_arg1v_arg22v.
      rewrite -> wand_wand_2.
      reflexivity.
      
  + destruct (is_and arg2 arg1 fcmp idx instk_height sb evm_stack_opm) 
      as [y|] eqn: eq_is_and'; try inject_rw Hoptm_sbinding eq_val'.
    injection Hoptm_sbinding as eq_val' _.
    rewrite <- eq_val'.
    
    unfold is_and in eq_is_and'.
    destruct (follow_in_smap arg1 idx sb) as [fsmv|] eqn: eq_follow_arg1;
      try discriminate.
    destruct fsmv as [smv idx' sb'].
    destruct smv as [_1|_2|label2 args2|_4|_5|_6]; try discriminate.
    destruct label2 eqn: eq_label2; try discriminate.
    destruct args2 as [|arg11 r11]; try discriminate.
    destruct r11 as [|arg12 r12]; try discriminate.
    destruct r12; try discriminate.
    
    destruct (fcmp arg2 arg11 idx sb idx' sb' instk_height evm_stack_opm)
      eqn: eq_fcmp_arg2_arg11.

    * (* arg2 ~ arg11 *)
      unfold eval_sstack_val in Heval_orig.
      unfold eval_sstack_val.
    
      injection eq_is_and' as eq_y.
      rewrite <- eq_y.
      
      simpl in Heval_orig.
      rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
      simpl in Heval_orig.
      destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb 
        evm_stack_opm) as [arg1v|] eqn: eq_eval_arg1; try discriminate.
      destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb 
        evm_stack_opm) as [arg2v|] eqn: eq_eval_arg2; try discriminate.
      rewrite <- Heval_orig.
      
      (* Every expression is valid *)
      simpl in Hvalid.
      destruct Hvalid as [eq_maxidx [Hvalid_and Hvalid_sb]].
      unfold valid_stack_op_instr in Hvalid_and.
      simpl in Hvalid_and.
      destruct Hvalid_and as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
      pose proof (valid_follow_in_smap sb arg1 instk_height idx 
        evm_stack_opm (SymOp AND [arg11; arg12]) idx' sb' Hvalid_arg1
        Hvalid_sb eq_follow_arg1) as [Hvalid_and [Hvalid_sb' Himpl]]. 
      pose proof (not_basic_value_smv_symop AND [arg11; arg12]) as eq_not_basic.
      apply Himpl in eq_not_basic as idx_gt_idx'.
      unfold valid_stack_op_instr in Hvalid_and.
      unfold valid_smap_value in Hvalid_and.
      unfold valid_stack_op_instr in Hvalid_and.
      simpl in Hvalid_and.
      destruct Hvalid_and as [_ [Hvalid_arg11 [Hvalid_arg12 _]]].

      rewrite -> eq_maxidx in eq_eval_arg1.
      simpl in eq_eval_arg1.
      rewrite -> eq_follow_arg1 in eq_eval_arg1.
      simpl in eq_eval_arg1.
      destruct (eval_sstack_val' idx arg11 stk mem strg exts idx' sb' 
        evm_stack_opm) as [arg11v|] eqn: eq_eval_arg11; try discriminate.
      destruct (eval_sstack_val' idx arg12 stk mem strg exts idx' sb' 
        evm_stack_opm) as [arg12v|] eqn: eq_eval_arg12; try discriminate.
      injection eq_eval_arg1 as eq_arg1v.
      rewrite <- eq_arg1v.
      unfold evm_and.

      (* arg2v and arg11v are the same *)
      symmetry in Hlen.
      pose proof (Hsafe_sstack_val_cmp arg2 arg11 idx sb idx' sb' instk_height 
        evm_stack_opm Hvalid_arg2 Hvalid_arg11 Hvalid_sb Hvalid_sb'
        eq_fcmp_arg2_arg11 stk mem strg exts Hlen) as [vv [eval_arg2 
        eval_arg11]].
      unfold eval_sstack_val in eval_arg2.
      rewrite <- eq_maxidx in eval_arg2.
      rewrite -> eq_eval_arg2 in eval_arg2.
      unfold eval_sstack_val in eval_arg11.
      apply eval_sstack_val'_preserved_when_depth_extended in 
        eq_eval_arg11.
      apply Gt.gt_n_S in idx_gt_idx' as Sidx_gt_Sidx'.
      pose proof (eval_sstack_val'_preserved_when_depth_extended_lt (S idx')
        (S idx) idx' sb' arg11 vv stk mem strg exts evm_stack_opm Sidx_gt_Sidx'
        eval_arg11) as eval_arg11_alt.
      rewrite -> eval_arg11_alt in eq_eval_arg11.
      rewrite <- eval_arg2 in eq_eval_arg11.
      injection eq_eval_arg11 as eq_arg2v_arg11v.
      rewrite -> eq_arg2v_arg11v.
      
      simpl. rewrite -> PeanoNat.Nat.eqb_refl. simpl.
      rewrite -> eq_eval_arg2.
      rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eq_eval_arg12.
      apply follow_suffix in eq_follow_arg1 as [prefix eq_prefix].
      pose proof (eval_sstack_val'_extend_sb instk_height idx stk mem strg
        exts idx sb sb' evm_stack_opm prefix Hvalid_sb eq_prefix arg12 arg12v
        eq_eval_arg12) as eval_arg12_alt.
      apply eval_sstack_val'_preserved_when_depth_extended in eval_arg12_alt.
      rewrite -> eq_maxidx.
      rewrite -> eval_arg12_alt. simpl.
      
      rewrite <- eq_arg2v_arg11v.
      rewrite -> wand_wand_3.
      reflexivity.
      
    * destruct (fcmp arg2 arg12 idx sb idx' sb' instk_height evm_stack_opm)
        eqn: eq_fcmp_arg2_arg12; try discriminate.
      (* arg2 ~ arg12 *)
      unfold eval_sstack_val in Heval_orig.
      unfold eval_sstack_val.
    
      injection eq_is_and' as eq_y.
      rewrite <- eq_y.
      
      simpl in Heval_orig.
      rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
      simpl in Heval_orig.
      destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb 
        evm_stack_opm) as [arg1v|] eqn: eq_eval_arg1; try discriminate.
      destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb 
        evm_stack_opm) as [arg2v|] eqn: eq_eval_arg2; try discriminate.
      rewrite <- Heval_orig.
      
      (* Every expression is valid *)
      simpl in Hvalid.
      destruct Hvalid as [eq_maxidx [Hvalid_and Hvalid_sb]].
      unfold valid_stack_op_instr in Hvalid_and.
      simpl in Hvalid_and.
      destruct Hvalid_and as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
      pose proof (valid_follow_in_smap sb arg1 instk_height idx 
        evm_stack_opm (SymOp AND [arg11; arg12]) idx' sb' Hvalid_arg1
        Hvalid_sb eq_follow_arg1) as [Hvalid_and [Hvalid_sb' Himpl]]. 
      pose proof (not_basic_value_smv_symop AND [arg11; arg12]) as eq_not_basic.
      apply Himpl in eq_not_basic as idx_gt_idx'.
      unfold valid_stack_op_instr in Hvalid_and.
      unfold valid_smap_value in Hvalid_and.
      unfold valid_stack_op_instr in Hvalid_and.
      simpl in Hvalid_and.
      destruct Hvalid_and as [_ [Hvalid_arg11 [Hvalid_arg12 _]]].

      rewrite -> eq_maxidx in eq_eval_arg1.
      simpl in eq_eval_arg1.
      rewrite -> eq_follow_arg1 in eq_eval_arg1.
      simpl in eq_eval_arg1.
      destruct (eval_sstack_val' idx arg11 stk mem strg exts idx' sb' 
        evm_stack_opm) as [arg11v|] eqn: eq_eval_arg11; try discriminate.
      destruct (eval_sstack_val' idx arg12 stk mem strg exts idx' sb' 
        evm_stack_opm) as [arg12v|] eqn: eq_eval_arg12; try discriminate.
      injection eq_eval_arg1 as eq_arg1v.
      rewrite <- eq_arg1v.
      unfold evm_and.

      (* arg2v and arg12v are the same *)
      symmetry in Hlen.
      pose proof (Hsafe_sstack_val_cmp arg2 arg12 idx sb idx' sb' instk_height 
        evm_stack_opm Hvalid_arg2 Hvalid_arg12 Hvalid_sb Hvalid_sb'
        eq_fcmp_arg2_arg12 stk mem strg exts Hlen) as [vv [eval_arg2 
        eval_arg12]].
      unfold eval_sstack_val in eval_arg2.
      rewrite <- eq_maxidx in eval_arg2.
      rewrite -> eq_eval_arg2 in eval_arg2.
      unfold eval_sstack_val in eval_arg12.
      apply eval_sstack_val'_preserved_when_depth_extended in 
        eq_eval_arg12.
      apply Gt.gt_n_S in idx_gt_idx' as Sidx_gt_Sidx'.
      pose proof (eval_sstack_val'_preserved_when_depth_extended_lt (S idx')
        (S idx) idx' sb' arg12 vv stk mem strg exts evm_stack_opm Sidx_gt_Sidx'
        eval_arg12) as eval_arg12_alt.
      rewrite -> eval_arg12_alt in eq_eval_arg12.
      rewrite <- eval_arg2 in eq_eval_arg12.
      injection eq_eval_arg12 as eq_arg2v_arg12v.
      rewrite -> eq_arg2v_arg12v.
      
      simpl. rewrite -> PeanoNat.Nat.eqb_refl. simpl.
      rewrite -> eq_eval_arg2.
      rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eq_eval_arg11.
      apply follow_suffix in eq_follow_arg1 as [prefix eq_prefix].
      pose proof (eval_sstack_val'_extend_sb instk_height idx stk mem strg
        exts idx sb sb' evm_stack_opm prefix Hvalid_sb eq_prefix arg11 arg11v
        eq_eval_arg11) as eval_arg11_alt.
      apply eval_sstack_val'_preserved_when_depth_extended in eval_arg11_alt.
      rewrite -> eq_maxidx.
      rewrite -> eval_arg11_alt. simpl.
      
      rewrite <- eq_arg2v_arg12v.
      rewrite -> wand_wand_4.
      reflexivity.
Qed.
*)

End Opt_and_and_mask.

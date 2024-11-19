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

(* For debugging with print_id *)
(* From ReductionEffect Require Import PrintingEffect. *)

Require Import Coq.Program.Equality.


Module Opt_shl_shr.

(* Try to use an alternative definition of wand *)
Lemma wand_def: forall (a b : EVMWord), 
wand a b = wordBin N.land a b.
Proof.
Admitted.


(* Creates a bit mask 111...1000...0 with n 1s and 256-n 0s 
   as (111...111 >> n) << n *)
(* This bit mask is the number 2^256 - 2^n *)
Definition mask (n: N) : EVMWord :=
  NToWord EVMWordSize (N.shiftl (N.shiftr (N.ones (N.of_nat EVMWordSize)) n) n).
  (*let nN := NToWord EVMWordSize n in
  evm_shl empty_externals [
    nN; 
    evm_shr empty_externals [nN; wones EVMWordSize]
  ].
  *)

(*
Definition mask (n: N) : EVMWord :=
  NToWord EVMWordSize (N.sub (N.pow 2 256) (N.pow 2 n)).
*)

Lemma shl_shr_and_mask: forall (n: N) (x nn: EVMWord) (exts: externals),
  (n < Npow2 EVMWordSize)%N ->
  nn = NToWord EVMWordSize n ->
  evm_and exts [mask n; x] = 
    evm_shl exts [nn; evm_shr exts [nn; x]].
Proof.
intros n x nn exts lt_n eq_nn.
simpl. rewrite -> wand_def. unfold mask. unfold wordBin.
rewrite -> eq_nn.
pose proof (wordToN_NToWord_2 EVMWordSize) as H.
apply wordToN_NToWord_2 in lt_n as eq_n. 
rewrite -> eq_n.
rewrite <- N.ldiff_ones_r.
pose proof (@wordToN_NToWord_2 EVMWordSize (N.shiftr (wordToN x) n)).
rewrite -> @wordToN_NToWord_2 with (n:=(N.shiftr (wordToN x) n)).
- admit.
- admit.
Admitted.    
 
(* 
  SHL(N, SHR(N, X)) = AND(2^256 - 2^N, X)
 *)
Definition optimize_shl_shr_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp SHL [arg1;arg2] =>
    match follow_in_smap arg2 maxid sb with 
    | Some (FollowSmapVal (SymOp SHR [arg21; x]) idx' sb') => 
      if fcmp arg1 arg21 maxid sb idx' sb' instk_height ops then 
        match follow_in_smap arg21 idx' sb' with
        | Some (FollowSmapVal (SymBasicVal (Val n)) _ _) => 
            let mask_val := mask (wordToN n) in
            (SymOp AND [Val mask_val; x], true)
        | _ => (val, false)
        end 
      else (val, false)
    | _ => (val, false)
    end
| _ => (val, false)
end.    
  


Lemma optimize_shl_shr_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_shl_shr_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros _ Hvalid_smapv_val Hvalid Hoptm_sbinding.
unfold optimize_shl_shr_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
  offset size smem] eqn: eq_val; 
  try inject_rw Hoptm_sbinding eq_val'.
destruct label eqn: eq_label; try try inject_rw Hoptm_sbinding eq_val'.
destruct args as [|arg1 r1]; try inject_rw Hoptm_sbinding eq_val'.
destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
destruct r2 as [|arg3 r3]; try inject_rw Hoptm_sbinding eq_val'.
destruct (follow_in_smap arg2 n sb) as [fsmv_arg2|] eqn: eq_follow_arg2;
  try inject_rw Hoptm_sbinding eq_val'.
destruct fsmv_arg2 as [smv_arg2 idx' sb'] eqn: eq_fsmv_arg2.
destruct smv_arg2 as [x1|x2|label2 args2|x4|x5|x6] eqn: eq_smv;
  try inject_rw Hoptm_sbinding eq_val'.
destruct label2 eqn: eq_label2; try inject_rw Hoptm_sbinding eq_val';
  try inject_rw Hoptm_sbinding eq_val'.
destruct args2 as [| arg21 r21]; try inject_rw Hoptm_sbinding eq_val'.
destruct r21 as [|arg22 r22]; try inject_rw Hoptm_sbinding eq_val'.
destruct r22; try inject_rw Hoptm_sbinding eq_val'.
destruct (fcmp arg1 arg21 n sb idx' sb' instk_height evm_stack_opm)
    eqn: eq_fcmp_arg1_arg21; try inject_rw Hoptm_sbinding eq_val'.

destruct (follow_in_smap arg21 idx' sb') as [fsmv_arg21|] eqn: eq_follow_arg21
    ; try inject_rw Hoptm_sbinding eq_val'.
destruct fsmv_arg21 as [smv_arg21 idx'' sb''] eqn: eq_fsmv_arg21.
destruct smv_arg21 as [arg21_ss| | | | |] eqn: eq_smv21; try inject_rw Hoptm_sbinding eq_val'.
destruct arg21_ss as [v21| |]; try inject_rw Hoptm_sbinding eq_val'.
injection Hoptm_sbinding as eq_val' _.
rewrite <- eq_val'.

simpl. unfold valid_stack_op_instr. simpl.
split; try intuition.

unfold valid_smap_value in Hvalid_smapv_val.
unfold valid_stack_op_instr in Hvalid_smapv_val.
simpl in Hvalid_smapv_val.
destruct Hvalid_smapv_val as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].
apply valid_follow_in_smap with (instk_height:=instk_height)(ops:=evm_stack_opm) 
  in eq_follow_arg2; try assumption.
destruct (eq_follow_arg2) as [Hvalid_arg2' [Hvalid_sb' Himpl]].
unfold valid_smap_value in Hvalid_arg2'.
unfold valid_stack_op_instr in Hvalid_arg2'.
simpl in Hvalid_arg2'.
destruct Hvalid_arg2' as [_ [_ [Hvalid_arg22 _]]].
pose proof (not_basic_value_smv_symop SHR [arg21; arg22]) as Hnot_basic.
apply Himpl in Hnot_basic as idx_gt_idx'.
apply valid_sstack_value_gt with (n:=idx'); try assumption.
Qed.

Lemma optimize_shl_shr_sbinding_snd:
opt_sbinding_snd optimize_shl_shr_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_shl_shr_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_shl_shr_sbinding_smapv_valid. 

- (* evaluation is preserved *) 
  intros stk mem strg exts v Hlen Heval_orig.
  unfold optimize_shl_shr_sbinding in Hoptm_sbinding.
  destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymOp label args *)
  destruct label eqn: eq_label; try inject_rw Hoptm_sbinding eq_val'.
  destruct args as [|arg1 r1] eqn: eq_args; 
    try inject_rw Hoptm_sbinding eq_val'.
  destruct r1 as [|arg2 r2]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r2 as [|arg3 r3]; try inject_rw Hoptm_sbinding eq_val'.
  destruct (follow_in_smap arg2 idx sb) as [fsmv|] eqn: eq_follow_arg2;
    try inject_rw Hoptm_sbinding eq_val'.
  destruct fsmv as [smv idx' sb']; try inject_rw Hoptm_sbinding eq_val'.
  destruct smv as [_1|_2|label2 args2|_4|_5|_6]; try inject_rw Hoptm_sbinding eq_val'.
  destruct label2 eqn: eq_label2; try inject_rw Hoptm_sbinding eq_val'.
  destruct args2 as [|arg21 r21]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r21 as [|arg22 r22]; try inject_rw Hoptm_sbinding eq_val'.
  destruct r22; try inject_rw Hoptm_sbinding eq_val'.

  destruct (fcmp arg1 arg21 idx sb idx' sb' instk_height evm_stack_opm)
    eqn: eq_fcmp_arg1_arg21; try inject_rw Hoptm_sbinding eq_val'.
  destruct (follow_in_smap arg21 idx' sb') as [fsmv_arg21|] eqn: eq_follow_arg21
    ; try inject_rw Hoptm_sbinding eq_val'.
  destruct fsmv_arg21 as [smv_arg21 idx'' sb''] eqn: eq_fsmv_arg21.
  destruct smv_arg21 as [arg21_ss| | | | |] eqn: eq_smv21; try inject_rw Hoptm_sbinding eq_val'.
  destruct arg21_ss as [v21| |]; try inject_rw Hoptm_sbinding eq_val'.
  injection Hoptm_sbinding as eq_val' _.
  rewrite <- eq_val'.

  unfold eval_sstack_val in Heval_orig.
  simpl in Heval_orig.
  rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
  simpl in Heval_orig.
  destruct (eval_sstack_val' maxidx arg1 stk mem strg exts idx sb evm_stack_opm) 
    as [arg1v|] eqn: eq_eval_arg1; try discriminate.
  destruct (eval_sstack_val' maxidx arg2 stk mem strg exts idx sb evm_stack_opm)
    as [arg2v|] eqn: eq_eval_arg2; try discriminate.

  destruct Hvalid as [eq_maxid [Hvalid_smap_value Hvalid_sb]].
  rewrite -> eq_maxid in eq_eval_arg2.
  simpl in eq_eval_arg2.
  rewrite -> eq_follow_arg2 in eq_eval_arg2.
  simpl in eq_eval_arg2.
  destruct (eval_sstack_val' idx arg21 stk mem strg exts idx' sb' evm_stack_opm)
    as [arg21v|] eqn: eq_eval_arg21; try discriminate.
  destruct (eval_sstack_val' idx arg22 stk mem strg exts idx' sb' evm_stack_opm)
    as [arg22v|] eqn: eq_eval_arg22; try discriminate.

  unfold eval_sstack_val.
  simpl.
  rewrite -> PeanoNat.Nat.eqb_refl.
  simpl.
  rewrite -> eq_maxid.
  rewrite -> eval_sstack_val'_const.
  apply follow_suffix in eq_follow_arg2 as eq_prefix_sb.
  destruct eq_prefix_sb as [prefix eq_prefix].
  apply eval_sstack_val'_preserved_when_depth_extended in eq_eval_arg22 
        as eq_eval_arg22_succ.
  rewrite -> eval'_maxidx_indep_eq with (m:=idx) in eq_eval_arg22_succ.
  pose proof (eval_sstack_val'_extend_sb instk_height (S idx) stk mem strg exts idx
        sb sb' evm_stack_opm prefix Hvalid_sb eq_prefix arg22 arg22v eq_eval_arg22_succ)
        as eval_arg22_alt.
  rewrite -> eval_arg22_alt.

  rewrite <- Heval_orig.
  injection eq_eval_arg2 as eq_arg2v.
  rewrite <- eq_arg2v.
  rewrite <- evm_shr_step with (exts:=exts).

  pose proof (shl_shr_and_mask).

  apply eval'_succ_then_nonzero in eq_eval_arg22 as idx_gt_idx''.
  destruct idx_gt_idx'' as [p_idx succ_idx].
  rewrite -> succ_idx in eq_eval_arg22.
  simpl in eq_eval_arg21.
  rewrite -> succ_idx in eq_eval_arg21.
  simpl in eq_eval_arg21.
  rewrite -> eq_follow_arg21 in eq_eval_arg21.
  injection eq_eval_arg21 as eq_arg21v.
  rewrite <- eq_arg21v.

  unfold valid_smap_value in Hvalid_smap_value.
  unfold valid_stack_op_instr in Hvalid_smap_value.
  simpl in Hvalid_smap_value.
  destruct Hvalid_smap_value as [_ [Hvalid_arg1 [Hvalid_arg2 _]]].

  pose proof (valid_follow_in_smap sb arg2 instk_height idx evm_stack_opm
    (SymOp SHR [arg21; arg22]) idx' sb' Hvalid_arg2 Hvalid_sb eq_follow_arg2)
    as Hvalid_arg21_arg22.
  destruct Hvalid_arg21_arg22 as [Hvalid_arg21_arg22 [valid_sb' Hnot_basic]].
  simpl in Hvalid_arg21_arg22.
  unfold valid_stack_op_instr in Hvalid_arg21_arg22.
  simpl in Hvalid_arg21_arg22.
  destruct Hvalid_arg21_arg22 as [_ [Hvalid_arg21 [Hvalid_arg22 _]]].

  symmetry in Hlen.
  pose proof (Hsafe_sstack_val_cmp arg1 arg21 idx sb idx' sb' 
    instk_height evm_stack_opm Hvalid_arg1 Hvalid_arg21 Hvalid_sb valid_sb'
    eq_fcmp_arg1_arg21 stk mem strg exts Hlen) as Hfcmp.
  destruct Hfcmp as [vv [Heval_arg1 Heval_arg21]].
  unfold eval_sstack_val in Heval_arg1.
  unfold eval_sstack_val in Heval_arg21.
  rewrite <- eq_maxid in Heval_arg1.
  rewrite -> eq_eval_arg1 in Heval_arg1.
  simpl in Heval_arg21.
  rewrite -> eq_follow_arg21 in Heval_arg21.
  rewrite <- Heval_arg1 in Heval_arg21.
  injection Heval_arg21 as eq_arg1v.
  rewrite -> eq_arg1v.

  assert (HH := 3=4).
  pose proof (shl_shr_and_mask (wordToN arg1v) arg22v 
    (NToWord EVMWordSize (wordToN v21) )) as Hshl.
  rewrite -> NToWord_wordToN in Hshl.
  rewrite -> Hshl.
  + rewrite -> eq_arg1v. reflexivity.
  + rewrite -> NToWord_wordToN. assumption.
Qed.


End Opt_shl_shr.

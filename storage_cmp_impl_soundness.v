Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import Coq.NArith.NArith.
Require Import List.
Import ListNotations.

Require Import FORVES.constants.
Import Constants.

Require Import FORVES.program.
Import Program.

Require Import FORVES.execution_state.
Import ExecutionState.

Require Import FORVES.stack_operation_instructions.
Import StackOpInstrs.

Require Import FORVES.misc.
Import Misc.

Require Import FORVES.symbolic_state.
Import SymbolicState.

Require Import FORVES.symbolic_state_eval.
Import SymbolicStateEval.


Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.symbolic_state_cmp.
Import SymbolicStateCmp.

Require Import FORVES.storage_cmp_impl.
Import StorageCmpImpl.

Require Import FORVES.eval_common.
Import EvalCommon.

Module StorageCmpImplSoundness.

  Theorem trivial_storage_cmp_snd:
    safe_sstorage_cmp_ext_wrt_sstack_value_cmp trivial_storage_cmp.
  Proof.
    unfold safe_sstorage_cmp_ext_wrt_sstack_value_cmp.
    unfold safe_sstack_val_cmp_ext_1_d.
    unfold safe_sstorage_cmp_ext_d.
    unfold safe_sstorage_cmp.
    unfold trivial_storage_cmp.
    intros.
    destruct sstrg1; destruct sstrg2; try discriminate.
    exists strg.
    auto.
  Qed.
  

  Theorem basic_storage_cmp_snd:
    safe_sstorage_cmp_ext_wrt_sstack_value_cmp basic_storage_cmp.
  Proof.
    Admitted.
    (*
    unfold safe_sstorage_cmp_ext_wrt_sstack_value_cmp.
    intros d sstack_val_cmp H_sstack_val_cmp_snd.
    unfold safe_sstorage_cmp_ext_d.
    intros d' H_d'_le_d.
    unfold safe_sstorage_cmp.
    intros sstrg1 sstrg2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_sb1 H_valid_sb2.
    revert sstrg2.
    revert sstrg1.
    induction sstrg1 as [|u1 sstrg1' IHsstrg1'].
    + intros sstrg2 H_valid_sstrg1 H_valid_sstrg2 H_basic_strg_smp stk mem strg ctx.
      destruct sstrg2; try discriminate.
      exists strg.
      unfold eval_sstorage.
      simpl.
      split; reflexivity.
    + intros sstrg2 H_valid_sstrg1 H_valid_sstrg2 H_basic_strg_smp stk mem strg ctx.
      destruct sstrg2 as [|u2 sstrg2'] eqn:H_sstrg2.
      ++ simpl in H_basic_strg_smp.
         destruct u1.
         discriminate.
      ++ simpl in H_basic_strg_smp.
         destruct u1 as [skey1 svalue1] eqn:E_u1.
         destruct u2 as [skey2 svalue2] eqn:E_u2.
         destruct (sstack_val_cmp d' skey1 skey2 maxidx1 sb1 maxidx2 sb2 instk_height ops) eqn:E_cmp_skey1_skey2; try discriminate.
         destruct (sstack_val_cmp d' svalue1 svalue2 maxidx1 sb1 maxidx2 sb2 instk_height ops) eqn:E_cmp_svalue1_svalue2; try discriminate.
         simpl in H_valid_sstrg1.
         destruct H_valid_sstrg1 as [ [H_valid_skey1 H_valid_svalue1] H_valid_sstrg1'].
         simpl in H_valid_sstrg2.
         destruct H_valid_sstrg2 as [ [H_valid_skey2 H_valid_svalue2] H_valid_sstrg2'].
         pose proof (IHsstrg1' sstrg2' H_valid_sstrg1' H_valid_sstrg2' H_basic_strg_smp stk mem strg ctx) as IHsstrg1'_0.
         destruct IHsstrg1'_0 as [strg' [IHsstrg1'_0 IHsstrg1'_1]].

         unfold safe_sstack_val_cmp_ext_1_d in H_sstack_val_cmp_snd.
         pose proof (H_sstack_val_cmp_snd d' H_d'_le_d) as H_sstack_val_cmp_snd_d'.
         unfold safe_sstack_val_cmp in H_sstack_val_cmp_snd_d'.
         pose proof(H_sstack_val_cmp_snd_d' skey1 skey2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_skey1 H_valid_skey2 H_valid_sb1 H_valid_sb2 E_cmp_skey1_skey2 stk mem strg ctx H_s).
         pose proof (H_sstack_val_cmp_snd
*)
  
  Theorem po_storage_cmp_snd:
    safe_sstorage_cmp_ext_wrt_sstack_value_cmp po_storage_cmp.
  Proof.
  Admitted.


End StorageCmpImplSoundness.

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
    unfold safe_sstorage_cmp_ext_wrt_sstack_value_cmp.
    intros d sstack_val_cmp H_sstack_val_cmp_snd.
    unfold safe_sstorage_cmp_ext_d.
    intros d' H_d'_le_d.
    unfold safe_sstorage_cmp.
    intros sstrg1 sstrg2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_sb1 H_valid_sb2.
    revert sstrg2.
    revert sstrg1.
    induction sstrg1 as [|u1 sstrg1' IHsstrg1'].
    + intros sstrg2 H_valid_sstrg1 H_valid_sstrg2 H_basic_strg_smp stk mem strg ctx H_stk_len.
      destruct sstrg2; try discriminate.
      exists strg.
      unfold eval_sstorage.
      simpl.
      split; reflexivity.
    + intros sstrg2 H_valid_sstrg1 H_valid_sstrg2 H_basic_strg_smp stk mem strg ctx H_stk_len.
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
         pose proof (IHsstrg1' sstrg2' H_valid_sstrg1' H_valid_sstrg2' H_basic_strg_smp stk mem strg ctx H_stk_len) as IHsstrg1'_0.
         destruct IHsstrg1'_0 as [strg' [IHsstrg1'_0 IHsstrg1'_1]].

         unfold safe_sstack_val_cmp_ext_1_d in H_sstack_val_cmp_snd.
         pose proof (H_sstack_val_cmp_snd d' H_d'_le_d) as H_sstack_val_cmp_snd_d'.
         unfold safe_sstack_val_cmp in H_sstack_val_cmp_snd_d'.
         pose proof(H_sstack_val_cmp_snd_d' skey1 skey2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_skey1 H_valid_skey2 H_valid_sb1 H_valid_sb2 E_cmp_skey1_skey2 stk mem strg ctx H_stk_len) as H_eval_skey1_skey2.
         destruct H_eval_skey1_skey2 as [skey_1_2_v [H_eval_skey1 H_eval_skey2]].

         pose proof(H_sstack_val_cmp_snd_d' svalue1 svalue2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_svalue1 H_valid_svalue2 H_valid_sb1 H_valid_sb2 E_cmp_svalue1_svalue2 stk mem strg ctx H_stk_len) as H_eval_svalue1_svalue2.
         destruct H_eval_svalue1_svalue2 as [svalue_1_2_v [H_eval_svalue1 H_eval_svalue2]].
         exists (fun key => if (key =? wordToN skey_1_2_v)%N then svalue_1_2_v else strg' key).

         unfold eval_sstorage in IHsstrg1'_0.
         destruct (map_option (instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx1 sb1 ops)) sstrg1') as [updates1|] eqn:H_mo_sstrg1'; try discriminate.
         injection IHsstrg1'_0 as IHsstrg1'_0.
         
         unfold eval_sstorage in IHsstrg1'_1.
         destruct (map_option (instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx2 sb2 ops)) sstrg2') as [updates2|] eqn:H_mo_sstrg2'; try discriminate.
         injection IHsstrg1'_1 as IHsstrg1'_1.

         unfold eval_sstorage.
         unfold map_option.
         repeat rewrite <- map_option_ho.

         unfold instantiate_storage_update at 1.
         rewrite H_eval_skey1.
         rewrite H_eval_svalue1.
         
         unfold instantiate_storage_update at 2.
         rewrite H_eval_skey2.
         rewrite H_eval_svalue2.

         rewrite H_mo_sstrg1'.
         rewrite H_mo_sstrg2'.

         unfold update_storage.
         fold update_storage.

         rewrite IHsstrg1'_0.
         rewrite IHsstrg1'_1.

         split; try reflexivity.
  Qed.

         
  
  Theorem po_storage_cmp_snd:
    safe_sstorage_cmp_ext_wrt_sstack_value_cmp po_storage_cmp.
  Proof.
  Admitted.


End StorageCmpImplSoundness.

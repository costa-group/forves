Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import Coq.NArith.NArith.
Require Import List.
Import ListNotations.

Require Import Coq.Logic.FunctionalExtensionality.

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

Require Import FORVES.symbolic_state_eval_facts.
Import SymbolicStateEvalFacts.

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


Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

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
    + intros sstrg2 H_valid_sstrg1 H_valid_sstrg2 H_basic_strg_smp stk mem strg exts H_stk_len.
      destruct sstrg2; try discriminate.
      exists strg.
      unfold eval_sstorage.
      simpl.
      split; reflexivity.
    + intros sstrg2 H_valid_sstrg1 H_valid_sstrg2 H_basic_strg_smp stk mem strg exts H_stk_len.
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
         pose proof (IHsstrg1' sstrg2' H_valid_sstrg1' H_valid_sstrg2' H_basic_strg_smp stk mem strg exts H_stk_len) as IHsstrg1'_0.
         destruct IHsstrg1'_0 as [strg' [IHsstrg1'_0 IHsstrg1'_1]].

         unfold safe_sstack_val_cmp_ext_1_d in H_sstack_val_cmp_snd.
         pose proof (H_sstack_val_cmp_snd d' H_d'_le_d) as H_sstack_val_cmp_snd_d'.
         unfold safe_sstack_val_cmp in H_sstack_val_cmp_snd_d'.
         pose proof(H_sstack_val_cmp_snd_d' skey1 skey2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_skey1 H_valid_skey2 H_valid_sb1 H_valid_sb2 E_cmp_skey1_skey2 stk mem strg exts H_stk_len) as H_eval_skey1_skey2.
         destruct H_eval_skey1_skey2 as [skey_1_2_v [H_eval_skey1 H_eval_skey2]].

         pose proof(H_sstack_val_cmp_snd_d' svalue1 svalue2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_svalue1 H_valid_svalue2 H_valid_sb1 H_valid_sb2 E_cmp_svalue1_svalue2 stk mem strg exts H_stk_len) as H_eval_svalue1_svalue2.
         destruct H_eval_svalue1_svalue2 as [svalue_1_2_v [H_eval_svalue1 H_eval_svalue2]].
         exists (fun key => if (key =? wordToN skey_1_2_v)%N then svalue_1_2_v else strg' key).

         unfold eval_sstorage in IHsstrg1'_0.
         destruct (map_option (instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maxidx1 sb1 ops)) sstrg1') as [updates1|] eqn:H_mo_sstrg1'; try discriminate.
         injection IHsstrg1'_0 as IHsstrg1'_0.
         
         unfold eval_sstorage in IHsstrg1'_1.
         destruct (map_option (instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maxidx2 sb2 ops)) sstrg2') as [updates2|] eqn:H_mo_sstrg2'; try discriminate.
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

  Lemma f_v1_v2_neq:
    forall (g : N -> EVMWord) (v1 v2:N) (w1 w2 : EVMWord),
      (v1 =? v2)%N = false ->
      forall x,
      ( (fun key : N => if (key =? v1)%N then w1 else if (key =? v2)%N then w2 else g key) x)
      =
        ( (fun key : N => if (key =? v2)%N then w2 else if (key =? v1)%N then w1 else g key) x).
  Proof.
    intros g v1 v2 w1 w2 H_v1_neq_v2 x.
    simpl.
    destruct (x =? v1)%N eqn:E_x_v1; destruct (x =? v2)%N eqn:E_x_v2; try reflexivity.
    rewrite N.eqb_eq in E_x_v1. rewrite E_x_v1 in E_x_v2. rewrite H_v1_neq_v2 in E_x_v2. discriminate.
  Qed.

  Lemma f_v1_v2_neq_fun:
    forall (g : N -> EVMWord) (v1 v2:N) (w1 w2 : EVMWord),
      (v1 =? v2)%N = false ->
      (fun key : N => if (key =? v1)%N then w1 else if (key =? v2)%N then w2 else g key) 
      =
        (fun key : N => if (key =? v2)%N then w2 else if (key =? v1)%N then w1 else g key).
  Proof.
    intros g v1 v2 w1 w2 H_v1_neq_v2.
    apply functional_extensionality.
    apply f_v1_v2_neq.
    apply H_v1_neq_v2.
  Qed.

  
  Lemma swap_storage_update_snd:
    forall sstrg u1 u2 maxidx sb instk_height ops,
      valid_sstorage instk_height maxidx sstrg ->
      valid_sstorage_update instk_height maxidx u1 ->
      valid_sstorage_update instk_height maxidx u2 ->
      valid_bindings instk_height maxidx sb ops ->
      swap_storage_update u1 u2 maxidx sb = true ->
      forall stk mem strg exts, 
             length stk = instk_height ->
             exists strg' : storage,
               eval_sstorage (u1::u2::sstrg) maxidx sb stk mem strg exts ops = Some strg' /\
                 eval_sstorage (u2::u1::sstrg) maxidx sb stk mem strg exts ops = Some strg'.
  Proof.
    intros sstrg u1 u2 maxidx sb instk_height ops.
    intros H_valid_sstrg H_valid_u1 H_valid_u2 H_valid_bs H_swap.
    intros stk mem strg exts H_stk_len.
    destruct u1 as [skey1 svalue1] eqn:E_u1.
    destruct u2 as [skey2 svalue2] eqn:E_u2.
    unfold swap_storage_update in H_swap.
    destruct (follow_in_smap skey1 maxidx sb) eqn:E_follow_skey1; try discriminate; destruct f; destruct smv; try discriminate; destruct val eqn:E_v1; try discriminate.
    
    destruct (follow_in_smap skey2 maxidx sb) eqn:E_follow_skey2; try discriminate; destruct f; destruct smv; try discriminate; destruct val1 eqn:E_v2; try discriminate.
 
    assert(H_swap' := H_swap).
    rewrite N.ltb_lt in H_swap'.
    pose proof (N.lt_neq (wordToN val2) (wordToN val0) H_swap') as H_swap_neq.
    apply N.neq_sym in H_swap_neq.
    rewrite <- N.eqb_neq in H_swap_neq.
    
    
    assert(H_valid_u1' := H_valid_u1).
    simpl in H_valid_u1'.
    destruct H_valid_u1' as [H_valid_skey1 H_valid_svalue1].

    assert(H_valid_u2' := H_valid_u2).
    simpl in H_valid_u2'.
    destruct H_valid_u2' as [H_valid_skey2 H_valid_svalue2].

    
    pose proof (eval_sstack_val'_succ (S maxidx) instk_height skey1 stk mem strg exts maxidx sb ops (eq_sym H_stk_len) H_valid_skey1 H_valid_bs (gt_Sn_n maxidx)) as H_eval_skey1.
    destruct H_eval_skey1 as [skey1_v H_eval_skey1].

    pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue1 stk mem strg exts maxidx sb ops (eq_sym H_stk_len) H_valid_svalue1 H_valid_bs (gt_Sn_n maxidx)) as H_eval_svalue1.
    destruct H_eval_svalue1 as [svalue1_v H_eval_svalue1].

    pose proof (eval_sstack_val'_succ (S maxidx) instk_height skey2 stk mem strg exts maxidx sb ops (eq_sym H_stk_len) H_valid_skey2 H_valid_bs (gt_Sn_n maxidx)) as H_eval_skey2.
    destruct H_eval_skey2 as [skey2_v H_eval_skey2].

    pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue2 stk mem strg exts maxidx sb ops (eq_sym H_stk_len) H_valid_svalue2 H_valid_bs (gt_Sn_n maxidx)) as H_eval_svalue2.
    destruct H_eval_svalue2 as [svalue2_v H_eval_svalue2].
 
    unfold eval_sstorage.
    unfold map_option at 1.
    rewrite <- map_option_ho.

    unfold instantiate_storage_update at 1.
    unfold eval_sstack_val at 1.
    rewrite H_eval_skey1.
    unfold eval_sstack_val at 1.
    rewrite H_eval_svalue1.
    
    unfold instantiate_storage_update at 1.
    unfold eval_sstack_val at 1.
    rewrite H_eval_skey2.
    unfold eval_sstack_val at 1.
    rewrite H_eval_svalue2.

    unfold eval_sstorage.
    unfold map_option at 2.
    rewrite <- map_option_ho.

    unfold instantiate_storage_update at 2.
    unfold eval_sstack_val at 2.
    rewrite H_eval_skey2.
    unfold eval_sstack_val at 2.
    rewrite H_eval_svalue2.

    unfold instantiate_storage_update at 2.
    unfold eval_sstack_val at 2.
    rewrite H_eval_skey1.
    unfold eval_sstack_val at 2.
    rewrite H_eval_svalue1.
  
    pose proof (eval_sstorage_succ instk_height maxidx sb stk mem strg exts ops sstrg (eq_sym H_stk_len) H_valid_sstrg H_valid_bs) as H_eval_sstrg.
    destruct H_eval_sstrg as [strg' H_eval_sstrg].
    unfold eval_sstorage in H_eval_sstrg.

    destruct (map_option (instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maxidx sb ops)) sstrg) as [updates|] eqn:E_mo_eval_sstrg; try discriminate.

    exists (fun key => if (key =? wordToN skey1_v)%N then svalue1_v else if (key =? wordToN skey2_v)%N then svalue2_v else strg' key).

    simpl.

    injection H_eval_sstrg as H_eval_sstrg.
    rewrite H_eval_sstrg.
 
    unfold sstore.
    split; try reflexivity.
   
    unfold eval_sstack_val' in H_eval_skey1.
    fold eval_sstack_val' in H_eval_skey1.
    rewrite E_follow_skey1 in H_eval_skey1.
    injection H_eval_skey1 as H_eval_skey1.

    unfold eval_sstack_val' in H_eval_skey2.
    fold eval_sstack_val' in H_eval_skey2.
    rewrite E_follow_skey2 in H_eval_skey2.
    injection H_eval_skey2 as H_eval_skey2.

    rewrite H_eval_skey1 in H_swap_neq.
    rewrite H_eval_skey2 in H_swap_neq.

    pose proof (f_v1_v2_neq_fun strg' (wordToN skey1_v) (wordToN skey2_v) svalue1_v svalue2_v H_swap_neq) as H_f_v1_v2_neq_fun.

    rewrite H_f_v1_v2_neq_fun.
    reflexivity.
Qed.

  Lemma reorder_updates'_valid:
    forall maxidx sb instk_height ops,
      valid_bindings instk_height maxidx sb ops ->
      forall d sstrg b sstrg_r,
      valid_sstorage instk_height maxidx sstrg ->
      reorder_updates' d sstrg maxidx sb = (b,sstrg_r) ->
      valid_sstorage instk_height maxidx sstrg_r.
  Proof.
    intros maxidx sb instk_height ops H_valid_sb.
    induction d as [|d'' IHd'].
    + intros sstrg b sstrg_r H_valid_sstrg H_reorder'.
      simpl in H_reorder'.
      injection H_reorder' as H_b H_sstrg_r.
      rewrite <- H_sstrg_r.
      apply H_valid_sstrg.
    + intros sstrg b sstrg_r H_valid_sstrg H_reorder'.
      simpl in H_reorder'.
      destruct sstrg as [|u1 sstrg'] eqn:H_sstrg.
      ++ injection H_reorder' as H_b H_sstrg_r.
         rewrite <- H_sstrg_r.
         simpl.
         auto.
      ++  destruct sstrg' as [|u2 sstrg''] eqn:H_sstrg'.
          +++ injection H_reorder' as H_b H_sstrg_r.
              rewrite <- H_sstrg_r.
              simpl.
              split; try auto.
              apply H_valid_sstrg.
          +++ destruct (swap_storage_update u1 u2 maxidx sb) eqn:E_swap.
              ++++ destruct (reorder_updates' d'' (u1 :: sstrg'')) eqn:E_reorder'_rec.
                   injection H_reorder' as H_b H_sstrg_r.
                   rewrite <- H_sstrg_r.
                   simpl in H_valid_sstrg.
                   destruct H_valid_sstrg as [H_valid_u1 [H_valid_u2 H_valid_sstrg'']].
                   pose proof (IHd' (u1 :: sstrg'') b0 s (valid_sstorage_when_extended_with_valid_update instk_height maxidx u1 sstrg'' H_valid_u1 H_valid_sstrg'') E_reorder'_rec) as IHd'_0.
                   simpl.
                   split.
                   +++++ apply H_valid_u2.
                   +++++ apply IHd'_0.
              ++++ destruct (reorder_updates' d'' (u2 :: sstrg'')) eqn:E_reorder'_rec.
                   injection H_reorder' as H_b H_sstrg_r.
                   rewrite <- H_sstrg_r.
                   simpl in H_valid_sstrg.
                   destruct H_valid_sstrg as [H_valid_u1 [H_valid_u2 H_valid_sstrg'']].
                   pose proof (IHd' (u2 :: sstrg'') b0 s (valid_sstorage_when_extended_with_valid_update instk_height maxidx u2 sstrg'' H_valid_u2 H_valid_sstrg'') E_reorder'_rec) as IHd'_0.
                   simpl.
                   split.
                   +++++ apply H_valid_u1.
                   +++++ apply IHd'_0.
  Qed.

      

 
  Lemma reorder_updates'_snd:
    forall maxidx sb instk_height ops,
      valid_bindings instk_height maxidx sb ops ->
      forall d sstrg b sstrg_r,
      valid_sstorage instk_height maxidx sstrg ->
      reorder_updates' d sstrg maxidx sb = (b,sstrg_r) ->
      forall stk mem strg exts, 
             length stk = instk_height ->
             exists strg' : storage,
               eval_sstorage sstrg maxidx sb stk mem strg exts ops = Some strg' /\
                 eval_sstorage sstrg_r maxidx sb stk mem strg exts ops = Some strg'.
  Proof.
    intros maxidx sb instk_height ops H_valid_sb.
    induction d as [|d' IHd'].
    + intros sstrg b sstrg_r H_valid_sstrg H_reorder'.
      intros stk mem strg exts H_stk_len.
      simpl in H_reorder'.
      injection H_reorder' as H_b H_sstrg_r.
      rewrite <- H_sstrg_r.
      pose proof (eval_sstorage_succ instk_height maxidx sb stk mem strg exts ops sstrg (eq_sym H_stk_len) H_valid_sstrg H_valid_sb) as H_eval_sstrg.
      destruct H_eval_sstrg as [strg' H_eval_sstrg].
      exists strg'.
      split; apply H_eval_sstrg.
    + intros sstrg b sstrg_r H_valid_sstrg H_reorder'.
      intros stk mem strg exts H_stk_len.
      simpl in H_reorder'.
      destruct sstrg as [|u1 sstrg'] eqn:E_sstrg.
      ++ injection H_reorder' as H_b H_sstrg_r.
         rewrite <- H_sstrg_r.
         exists strg.
         unfold eval_sstorage.
         simpl.
         split; reflexivity.
      ++ destruct sstrg' as [|u2 sstrg''] eqn:E_sstrg'.
         +++ injection H_reorder' as H_b H_sstrg_r.
             rewrite <- H_sstrg_r.
             destruct u1 as [skey1 svalue1] eqn:E_u1.
             simpl in H_valid_sstrg.
             destruct H_valid_sstrg as [[H_valid_skey1 H_valid_svalue1] _].

             pose proof (eval_sstack_val'_succ (S maxidx) instk_height skey1 stk mem strg exts maxidx sb ops (eq_sym H_stk_len) H_valid_skey1 H_valid_sb (gt_Sn_n maxidx)) as E_eval_skey1.
             destruct E_eval_skey1 as [skey1_v E_eval_skey1].
             pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue1 stk mem strg exts maxidx sb ops (eq_sym H_stk_len) H_valid_svalue1 H_valid_sb (gt_Sn_n maxidx)) as E_eval_svalue1.
             destruct E_eval_svalue1 as [svalue1_v E_eval_svalue1].

             exists (fun key => if (key =? wordToN skey1_v)%N then svalue1_v else strg key).
             unfold eval_sstorage.
             unfold map_option.
             unfold instantiate_storage_update.
             unfold eval_sstack_val.
             rewrite E_eval_skey1.
             rewrite E_eval_svalue1.
             unfold update_storage.
             split; reflexivity.
         +++ destruct (swap_storage_update u1 u2 maxidx sb) eqn:E_swap.
             ++++ destruct (reorder_updates' d' (u1 :: sstrg'') maxidx sb) as [b' sstrg_r'] eqn:E_reorder'_rec.
                  injection H_reorder' as E_b E_sstrg_r.

                  simpl in H_valid_sstrg.
                  destruct H_valid_sstrg as [H_valid_u1 [H_valid_u2 H_valid_sstrg'']].
                   
                  pose proof (swap_storage_update_snd  sstrg'' u1 u2 maxidx sb instk_height ops H_valid_sstrg'' H_valid_u1 H_valid_u2 H_valid_sb E_swap stk mem strg exts H_stk_len) as H_swap_storage_update_snd.

                  destruct H_swap_storage_update_snd as [strg_aux [H_eval_u1_u2_sstrg'' H_eval_u2_u1_sstrg'' ]].
		  rewrite <- H_eval_u2_u1_sstrg'' in H_eval_u1_u2_sstrg''.
                  rewrite H_eval_u1_u2_sstrg''.
 
                  pose proof (IHd' (u1 :: sstrg'') b' sstrg_r' (valid_sstorage_when_extended_with_valid_update instk_height maxidx u1 sstrg'' H_valid_u1 H_valid_sstrg'') E_reorder'_rec stk mem strg exts H_stk_len) as IHd'_0.
                  destruct IHd'_0 as [strg' [H_eval_u1_sstrg'' H_eval_sstrg_r']].
                  rewrite <- E_sstrg_r.
                  
                  unfold eval_sstorage in H_eval_u1_sstrg''.
                  destruct (map_option (instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maxidx sb ops)) (u1 :: sstrg'')) as [updates1|] eqn:E_mo_1; try discriminate.
                  
                  unfold eval_sstorage in H_eval_sstrg_r'.
                  destruct (map_option (instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maxidx sb ops)) sstrg_r') as [updates2|] eqn:E_mo_2; try discriminate.
                  
                  destruct u2 as [skey2 svalue2] eqn:E_u2.
                  simpl in H_valid_u2.
                  destruct H_valid_u2 as [H_valid_skey2 H_valid_svalue2].

                  pose proof (eval_sstack_val'_succ (S maxidx) instk_height skey2 stk mem strg exts maxidx sb ops (eq_sym H_stk_len) H_valid_skey2 H_valid_sb (gt_Sn_n maxidx)) as E_eval_skey2.
                  destruct E_eval_skey2 as [skey2_v E_eval_skey2].
                  pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue2 stk mem strg exts maxidx sb ops (eq_sym H_stk_len) H_valid_svalue2 H_valid_sb (gt_Sn_n maxidx)) as E_eval_svalue2.
                  destruct E_eval_svalue2 as [svalue2_v E_eval_svalue2].
                  
                  unfold eval_sstorage.
                  unfold map_option.
                  repeat rewrite <- map_option_ho.
                  
                  unfold instantiate_storage_update at 1.
                  unfold eval_sstack_val at 1.
                  rewrite E_eval_skey2.
                  unfold eval_sstack_val at 1.
                  rewrite E_eval_svalue2.
                  
                  unfold instantiate_storage_update at 3.
                  unfold eval_sstack_val at 3.
                  rewrite E_eval_skey2.
                  unfold eval_sstack_val at 3.
                  rewrite E_eval_svalue2.

                  unfold map_option in E_mo_1.
                  destruct (instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maxidx sb ops) u1) as [elem_val|] eqn:E_elem_val; try discriminate.
                  
                  repeat rewrite <- map_option_ho in E_mo_1.
                  rewrite E_mo_1.
                  rewrite E_mo_2.

                  unfold update_storage.
                  fold update_storage.

                  injection H_eval_u1_sstrg'' as H_eval_u1_sstrg''.
                  rewrite H_eval_u1_sstrg''.
                  injection H_eval_sstrg_r' as H_eval_sstrg_r'.
                  rewrite H_eval_sstrg_r'.

                  exists (update_storage' strg' (U_SSTORE EVMWord skey2_v svalue2_v)).
                  split; reflexivity.
                  
             ++++ destruct (reorder_updates' d' (u2 :: sstrg'') maxidx sb) as [b' sstrg_r'] eqn:E_reorder'_rec.
                  simpl in H_valid_sstrg.
                  destruct H_valid_sstrg as [H_valid_u1 [H_valid_u2 H_valid_sstrg'']].

                  pose proof (IHd' (u2 :: sstrg'') b' sstrg_r' (valid_sstorage_when_extended_with_valid_update instk_height maxidx u2 sstrg'' H_valid_u2 H_valid_sstrg'') E_reorder'_rec stk mem strg exts H_stk_len) as IHd'_0.
                  destruct IHd'_0 as [strg' [H_eval_u2_sstrg'' H_eval_sstrg_r']].
                  injection H_reorder' as H_b' H_sstrg_r'.
                  rewrite <- H_sstrg_r'.

                  unfold eval_sstorage in H_eval_u2_sstrg''.
                  destruct (map_option (instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maxidx sb ops)) (u2 :: sstrg'')) as [updates1|] eqn:E_mo_1; try discriminate.
                  
                  unfold eval_sstorage in H_eval_sstrg_r'.
                  destruct (map_option (instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maxidx sb ops)) sstrg_r') as [updates2|] eqn:E_mo_2; try discriminate.
                  
                  destruct u1 as [skey1 svalue1] eqn:E_u1.
                  simpl in H_valid_u1.
                  destruct H_valid_u1 as [H_valid_skey1 H_valid_svalue1].

                  pose proof (eval_sstack_val'_succ (S maxidx) instk_height skey1 stk mem strg exts maxidx sb ops (eq_sym H_stk_len) H_valid_skey1 H_valid_sb (gt_Sn_n maxidx)) as E_eval_skey1.
                  destruct E_eval_skey1 as [skey1_v E_eval_skey1].
                  pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue1 stk mem strg exts maxidx sb ops (eq_sym H_stk_len) H_valid_svalue1 H_valid_sb (gt_Sn_n maxidx)) as E_eval_svalue1.
                  destruct E_eval_svalue1 as [svalue1_v E_eval_svalue1].
                  
                  unfold eval_sstorage.
                  unfold map_option.
                  repeat rewrite <- map_option_ho.
                  
                  unfold instantiate_storage_update at 1.
                  unfold eval_sstack_val at 1.
                  rewrite E_eval_skey1.
                  unfold eval_sstack_val at 1.
                  rewrite E_eval_svalue1.
                  
                  unfold instantiate_storage_update at 3.
                  unfold eval_sstack_val at 3.
                  rewrite E_eval_skey1.
                  unfold eval_sstack_val at 3.
                  rewrite E_eval_svalue1.

                  unfold map_option in E_mo_1.
                  destruct (instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maxidx sb ops) u2) as [elem_val|] eqn:E_elem_val; try discriminate.
                  
                  repeat rewrite <- map_option_ho in E_mo_1.
                  rewrite E_mo_1.
                  rewrite E_mo_2.

                  unfold update_storage.
                  fold update_storage.

                  injection H_eval_u2_sstrg'' as H_eval_u2_sstrg''.
                  rewrite H_eval_u2_sstrg''.
                  injection H_eval_sstrg_r' as H_eval_sstrg_r'.
                  rewrite H_eval_sstrg_r'.

                  exists (update_storage' strg' (U_SSTORE EVMWord skey1_v svalue1_v)).
                  split; reflexivity.
  Qed.


  Lemma reorder_storage_updates_valid:
    forall maxidx sb instk_height ops,
      valid_bindings instk_height maxidx sb ops ->
      forall d n sstrg sstrg_r,
      valid_sstorage instk_height maxidx sstrg ->
      reorder_storage_updates d n sstrg maxidx sb = sstrg_r ->
      valid_sstorage instk_height maxidx sstrg_r.
  Proof.
    intros maxidx sb instk_height ops H_valid_sb.
    induction d as [|d' IHd'].
    + intros n sstrg sstrg' H_valid_sstrg H_reorder.
      simpl in H_reorder.
      rewrite <- H_reorder.
      apply H_valid_sstrg.
    + intros n sstrg sstrg_r H_valid_sstrg H_reorder.
      unfold reorder_storage_updates in H_reorder.
      fold reorder_storage_updates in H_reorder.
      destruct (reorder_updates' n sstrg maxidx sb) as [changed sstrg'] eqn:E_reorder_update'.
      pose proof (reorder_updates'_valid maxidx sb instk_height ops H_valid_sb n sstrg changed sstrg' H_valid_sstrg E_reorder_update') as H_valid_sstrg'.
      destruct changed.
      ++ pose proof (IHd' n sstrg' sstrg_r H_valid_sstrg' H_reorder) as H_valid_sstrg_r.
         apply H_valid_sstrg_r.
      ++ rewrite <- H_reorder.
         apply H_valid_sstrg'.
Qed.



  Lemma reorder_storage_updates_snd:
    forall maxidx sb instk_height ops,
      valid_bindings instk_height maxidx sb ops ->
      forall d n sstrg sstrg_r,
        valid_sstorage instk_height maxidx sstrg ->
      reorder_storage_updates d n sstrg maxidx sb = sstrg_r ->
      forall stk mem strg exts, 
        length stk = instk_height ->
        exists strg' : storage,
          eval_sstorage sstrg maxidx sb stk mem strg exts ops = Some strg' /\
            eval_sstorage sstrg_r maxidx sb stk mem strg exts ops = Some strg'.
  Proof.
    intros maxidx sb instk_height ops H_valid_sb.
    induction d as [|d' IHd'].
    + intros n sstrg sstrg' H_valid_sstrg H_reorder stk mem strg exts H_stk_len.
      simpl in H_reorder.
      rewrite <- H_reorder.
      pose proof (eval_sstorage_succ instk_height maxidx sb stk mem strg exts ops sstrg (eq_sym H_stk_len) H_valid_sstrg H_valid_sb) as H_eval_sstrg.
      destruct H_eval_sstrg as [strg' H_eval_sstrg].
      exists strg'.
      split; apply H_eval_sstrg.
    + intros n sstrg sstrg' H_valid_sstrg H_reorder stk mem strg exts H_stk_len.
      simpl in H_reorder.
      destruct (reorder_updates' n sstrg maxidx sb) as [changed sstrg_r] eqn:E_reorder_updates'.
     
      pose proof (reorder_updates'_snd maxidx sb instk_height ops H_valid_sb n sstrg changed sstrg_r H_valid_sstrg E_reorder_updates' stk mem strg exts H_stk_len) as H_reorder_updates'_snd.
      destruct H_reorder_updates'_snd as [strg' [H_eval_sstrg H_eval_sstrg_r]].
      
      destruct changed eqn:E_changed.
      ++ pose proof (reorder_updates'_valid maxidx sb instk_height ops H_valid_sb n sstrg true sstrg_r H_valid_sstrg E_reorder_updates') as H_valid_sstrg_r.

         pose proof (IHd' n sstrg_r sstrg' H_valid_sstrg_r H_reorder stk mem strg exts H_stk_len) as IHd'_0.
         destruct IHd'_0 as [strg'' [H_eval_sstrg_r_bis H_eval_sstrg']].
         exists strg'.

         rewrite H_eval_sstrg_r in H_eval_sstrg_r_bis.
         injection H_eval_sstrg_r_bis as H_strg'_eq_strg''.
         rewrite <- H_strg'_eq_strg'' in H_eval_sstrg'.
         split.
         +++ apply H_eval_sstrg.
         +++ apply H_eval_sstrg'.
         
      ++ rewrite <- H_reorder.
         exists strg'.
         split.
         +++ apply H_eval_sstrg.
         +++ apply H_eval_sstrg_r.
  Qed.

  
  Theorem po_storage_cmp_snd:
    safe_sstorage_cmp_ext_wrt_sstack_value_cmp po_storage_cmp.
  Proof.
    unfold safe_sstorage_cmp_ext_wrt_sstack_value_cmp.
    unfold safe_sstorage_cmp_ext_d.
    unfold safe_sstorage_cmp.
    intros d sstack_val_cmp H_sstack_val_cmp_snd d' H_d'_le_d sstrg1 sstrg2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_sb1 H_valid_sb2 H_valid_sstrg1 H_valid_sstrg2 H_po_cmp stk mem strg exts H_stk_len.
    unfold po_storage_cmp in H_po_cmp.
    destruct (length sstrg1 =? length sstrg2); try discriminate.

    remember (reorder_storage_updates (length sstrg1) (length sstrg1) sstrg1 maxidx1 sb1) as sstrg1_r.
    remember (reorder_storage_updates (length sstrg2) (length sstrg2) sstrg2 maxidx2 sb2) as sstrg2_r.
    
    pose proof (reorder_storage_updates_snd maxidx1 sb1 instk_height ops H_valid_sb1 (length sstrg1) (length sstrg1) sstrg1 sstrg1_r H_valid_sstrg1 (eq_sym Heqsstrg1_r) stk mem strg exts H_stk_len) as H_reorder_storage_updates_snd_sstrg1_r.
    pose proof (reorder_storage_updates_valid maxidx1 sb1 instk_height ops H_valid_sb1 (length sstrg1) (length sstrg1) sstrg1 sstrg1_r H_valid_sstrg1 (eq_sym Heqsstrg1_r)) as H_valid_sstrg1_r.

    destruct H_reorder_storage_updates_snd_sstrg1_r as [strg1' [H_eval_sstrg1 H_eval_sstrg1_r]].

    pose proof (reorder_storage_updates_snd maxidx2 sb2 instk_height ops H_valid_sb2 (length sstrg2) (length sstrg2) sstrg2 sstrg2_r H_valid_sstrg2 (eq_sym Heqsstrg2_r) stk mem strg exts H_stk_len) as H_reorder_storage_updates_snd_sstrg2_r.
    pose proof (reorder_storage_updates_valid maxidx2 sb2 instk_height ops H_valid_sb2 (length sstrg2) (length sstrg2) sstrg2 sstrg2_r H_valid_sstrg2 (eq_sym Heqsstrg2_r)) as H_valid_sstrg2_r.

    destruct H_reorder_storage_updates_snd_sstrg2_r as [strg2' [H_eval_sstrg2 H_eval_sstrg2_r]].

    pose proof (basic_storage_cmp_snd) as H_basic_storage_cmp_snd.
    unfold safe_sstorage_cmp_ext_wrt_sstack_value_cmp in H_basic_storage_cmp_snd.
    unfold safe_sstorage_cmp_ext_d in H_basic_storage_cmp_snd.
    unfold safe_sstorage_cmp in H_basic_storage_cmp_snd.

    pose proof (H_basic_storage_cmp_snd d sstack_val_cmp H_sstack_val_cmp_snd d' H_d'_le_d sstrg1_r sstrg2_r maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_sb1 H_valid_sb2 H_valid_sstrg1_r H_valid_sstrg2_r H_po_cmp stk mem strg exts H_stk_len) as H_basic_cmp_snd.

    destruct H_basic_cmp_snd as [strg' [H_eval_sstrg1_r_bis H_eval_sstrg2_r_bis]].
    exists strg1'.
    split.
    + apply H_eval_sstrg1.
    + rewrite H_eval_sstrg2.
      rewrite H_eval_sstrg2_r_bis in H_eval_sstrg2_r.
      injection H_eval_sstrg2_r as H_eval_sstrg2_r.
      rewrite H_eval_sstrg1_r_bis in H_eval_sstrg1_r.
      injection H_eval_sstrg1_r as H_eval_sstrg1_r.
      rewrite <- H_eval_sstrg2_r.
      rewrite <- H_eval_sstrg1_r.
      reflexivity.
  Qed.

    


End StorageCmpImplSoundness.

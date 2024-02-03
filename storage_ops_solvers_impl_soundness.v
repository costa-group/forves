Require Import Arith.   
Require Import Nat.  
Require Import Bool.
Require Import bbv.Word.
Require Import Coq.NArith.NArith.
Require Import Coq.NArith.Nnat.
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

Require Import FORVES.storage_ops_solvers.
Import StorageOpsSolvers.

Require Import FORVES.storage_ops_solvers_impl.
Import StorageOpsSolversImpl.

Require Import FORVES.symbolic_execution_soundness.
Import SymbolicExecutionSoundness.

Require Import FORVES.sstack_val_cmp_impl_soundness.
Import SStackValCmpImplSoundness.
Module StorageOpsSolversImplSoundness.

 

  Lemma trivial_sload_solver_snd: sload_solver_ext_snd trivial_sload_solver.
  Proof.
    unfold sload_solver_ext_snd.
    unfold sload_solver_snd.
    intros.
    split.
    - unfold sload_solver_valid_res.
      intros.
      unfold trivial_sload_solver in H2.
      rewrite <- H2.
      simpl.
      intuition.
    - unfold sload_solver_correct_res.
      intros.
      unfold trivial_sload_solver in H3.
      rewrite <- H3 in H4.
      rewrite H4.
      exists idx1.
      exists m1.
      split; try reflexivity.
      intros.
      unfold eval_sstack_val.
      symmetry in H5.

      assert (H_valid_smap_value: valid_smap_value instk_height (get_maxidx_smap m) ops (SymSLOAD skey sstrg)). simpl. intuition.

      symmetry in H4.
      pose proof (add_to_smap_key_lt_maxidx m m1 idx1 (SymSLOAD skey sstrg) H4).
      pose proof (valid_sstack_val_freshvar instk_height (get_maxidx_smap m1) idx1 H6).
      symmetry in H4.
      pose proof (add_to_smap_valid_smap instk_height idx1 m m1 (SymSLOAD skey sstrg) ops H0 H_valid_smap_value H4).
      pose proof (eval_sstack_val'_succ (S (get_maxidx_smap m1)) instk_height (FreshVar idx1) stk mem strg ctx (get_maxidx_smap m1) (get_bindings_smap m1) ops H5 H7 H8 (gt_Sn_n (get_maxidx_smap m1))).
      destruct H9 as [v H9].
      exists v.
      split; apply H9.
  Qed.

  
  Lemma trivial_sstorage_updater_snd: sstorage_updater_ext_snd trivial_sstorage_updater.
  Proof.
    unfold sstorage_updater_ext_snd.
    intros sstack_val_cmp H_valid_sstack_val_cmp.
    unfold sstorage_updater_snd.
    split.
    - unfold sstorage_updater_valid_res.
      intros m sstrg sstrg' u instk_height ops H_valid_sstrg H_valid_u H_updater.
      unfold trivial_sstorage_updater in H_updater.
      rewrite <- H_updater.
      simpl.
      split.
      + apply H_valid_u.
      + apply H_valid_sstrg.
    - unfold sstorage_updater_correct_res.
      intros m sstrg sstrg' u instk_height ops H_valid_smap H_valid_sstrg H_valid_u H_updater.
      unfold trivial_sstorage_updater in H_updater.
      rewrite <- H_updater.
      intros stk mem strg ctx H_len_stk.
      pose proof (valid_sstorage_when_extended_with_valid_update instk_height (get_maxidx_smap m) u sstrg H_valid_u H_valid_sstrg) as H_valid_u_sstrg.
      unfold valid_smap in H_valid_smap.
      symmetry in H_len_stk.
      pose proof (eval_sstorage_succ instk_height (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops (u::sstrg) H_len_stk H_valid_u_sstrg H_valid_smap) as H_eval_sstorage_u_sstrg.
      destruct H_eval_sstorage_u_sstrg as [sstrg'' H_eval_sstorage_u_sstrg].
      exists sstrg''.
      exists sstrg''.
      repeat split; apply H_eval_sstorage_u_sstrg.
  Qed.
  
  Lemma not_eq_keys_snd:
    forall skey skey' maxidx sbindings instk_height ops,
      valid_bindings instk_height maxidx sbindings ops ->
      valid_sstack_value instk_height maxidx skey ->
      valid_sstack_value instk_height maxidx skey' ->
      not_eq_keys skey skey' maxidx sbindings instk_height ops = true ->
      forall stk mem strg ctx,
        (length stk) = instk_height ->
        exists v1 v2,
        eval_sstack_val' (S maxidx) skey stk mem strg ctx maxidx sbindings ops = Some v1 /\
          eval_sstack_val' (S maxidx) skey' stk mem strg ctx maxidx sbindings ops = Some v2 /\
          weqb v1 v2 = false.
  Proof.
    intros skey skey' maxidx sbindings instk_height ops.
    intros H_valid_bs H_valid_skey H_valid_skey' H_neq.
    unfold not_eq_keys in H_neq.
    destruct (follow_in_smap skey maxidx sbindings) as [skey_m|] eqn:E_follow_skey; try discriminate.
    destruct skey_m; try discriminate.
    destruct smv; try discriminate.
    destruct val; try discriminate.
    destruct (follow_in_smap skey' maxidx sbindings) as [skey'_m|] eqn:E_follow_skey'; try discriminate.
    destruct skey'_m; try discriminate.
    destruct smv; try discriminate.
    destruct val0; try discriminate.
    intros stk mem strg ctx.
    intros H_stk_len.
    unfold eval_sstack_val' at 1.
    rewrite E_follow_skey.
    unfold eval_sstack_val' at 1.
    rewrite E_follow_skey'.
    exists val.
    exists val0.
    split; try split; try reflexivity.
    rewrite negb_true_iff in H_neq.
    rewrite H_neq.
    reflexivity.
Qed.      
                                                                                             
Lemma H_map_o_sstrg:
  forall instk_height d stk mem strg ctx maxidx bs ops sstrg,
    valid_sstorage instk_height maxidx sstrg ->
    valid_bindings instk_height maxidx bs ops ->
    d > maxidx ->
    instk_height = length stk ->
    exists v,
      map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val' d sv stk mem strg ctx maxidx bs ops)) sstrg = Some v.
Proof.
induction sstrg as [|u sstrg' IHsstrg'].
+ intros. simpl. exists []. reflexivity.
+ intros H_valid_sstorage H_valid_bs H_d_gt_maxidx H_len_stk.
  unfold map_option.
  rewrite <- map_option_ho.
  unfold eval_common.EvalCommon.instantiate_storage_update at 1.
  destruct u as [skey' svalue'].
                            
  unfold valid_sstorage in H_valid_sstorage. fold valid_sstorage in H_valid_sstorage.
  destruct H_valid_sstorage as [H_valid_sstorage_0 H_valid_sstorage_1].
  unfold valid_sstorage_update in H_valid_sstorage_0.
  destruct H_valid_sstorage_0 as [H_valid_sstorage_0_0 H_valid_sstorage_0_1].

  pose proof (eval_sstack_val'_succ d instk_height skey' stk mem strg ctx maxidx bs ops H_len_stk H_valid_sstorage_0_0 H_valid_bs H_d_gt_maxidx) as eval_sstack_val'_succ_0.
  
  destruct eval_sstack_val'_succ_0 as [v eval_sstack_val'_succ_0].
  rewrite eval_sstack_val'_succ_0.
  pose proof (eval_sstack_val'_succ d instk_height svalue' stk mem strg ctx maxidx bs ops H_len_stk H_valid_sstorage_0_1 H_valid_bs H_d_gt_maxidx) as eval_sstack_val'_succ_1.
  destruct eval_sstack_val'_succ_1 as [v' eval_sstack_val'_succ_1].
  rewrite eval_sstack_val'_succ_1.

  pose proof (IHsstrg' H_valid_sstorage_1 H_valid_bs H_d_gt_maxidx H_len_stk) as IHsstrg'_0.
  destruct IHsstrg'_0 as [v'' IHsstrg'_0].
  rewrite IHsstrg'_0.
  exists (U_SSTORE EVMWord v v' :: v'').
  reflexivity.
  Qed.

Lemma ssload_sstore_same_address:
  forall strg addr value,
    (concrete_interpreter.ConcreteInterpreter.sload
       (concrete_interpreter.ConcreteInterpreter.sstore strg addr value) addr) = value.
Proof.
  intros strg addr value.
  unfold concrete_interpreter.ConcreteInterpreter.sstore.
  unfold concrete_interpreter.ConcreteInterpreter.sload.
  rewrite N.eqb_refl with (x:= (wordToN addr)).
  reflexivity.
Qed.  


Lemma eval_sstack_val'_immediate_fresh_var:
  forall d idx stk mem strg ctx value bs ops,
  eval_sstack_val' d (FreshVar idx) stk mem strg ctx (S idx) ((idx, SymBasicVal value) :: bs) ops =
    eval_sstack_val' d value stk mem strg ctx idx bs ops.
Proof.
  intros d idx stk mem strg ctx value bs ops.
  destruct d as [|d']; try reflexivity.
  destruct value as [v|i|i] eqn:E_value.
  + unfold eval_sstack_val'  at 1.
    fold eval_sstack_val'.
    rewrite follow_smap_first_match; try reflexivity.
    unfold eval_sstack_val'  at 1.
    fold eval_sstack_val'.
    rewrite follow_smap_V.
    reflexivity.
  + unfold eval_sstack_val'  at 1.
    fold eval_sstack_val'.
    rewrite follow_smap_first_match; try reflexivity.
    unfold eval_sstack_val'  at 1.
    fold eval_sstack_val'.
    rewrite follow_smap_InStackVar.
    reflexivity.
  + unfold eval_sstack_val'  at 1.
    fold eval_sstack_val'.
    unfold follow_in_smap.
    fold follow_in_smap.
    rewrite Nat.eqb_refl.
    unfold is_fresh_var_smv.
    unfold eval_sstack_val'  at 9.
    fold eval_sstack_val'.
    reflexivity.
Qed.    
    

  
   

  Lemma basic_sload_solver_snd: sload_solver_ext_snd basic_sload_solver.
  Proof.
    unfold sload_solver_ext_snd.
    intros sstack_val_cmp H_sstack_val_cmp_snd.
    unfold sload_solver_snd.
    split.

    (* valid *)
    - unfold sload_solver_valid_res.      
      intros m sstrg skey instk_height smv ops.
      induction sstrg as [|u sstrg' IH_sstrg'].
      + intros H_valid_sstrg H_valid_skey H_smv.
        simpl in H_smv.
        rewrite <- H_smv.
        simpl.
        auto.
      + intros H_valid_sstrg H_valid_skey H_smv.
        unfold basic_sload_solver in H_smv.
        fold basic_sload_solver in H_smv.
        destruct u as [skey' svalue] eqn:E_u.
        destruct (sstack_val_cmp (S (get_maxidx_smap m)) skey skey' (get_maxidx_smap m) (get_bindings_smap m) (get_maxidx_smap m) (get_bindings_smap m) instk_height ops) eqn:H_sstack_val_cmp_skey_skey'.
        ++ rewrite <- H_smv.
           simpl.
           apply H_valid_sstrg.
        ++ simpl in H_valid_sstrg.
           destruct H_valid_sstrg as [ [H_valid_skey' H_valid_svalue] H_valid_sstrg'].
           destruct (not_eq_keys skey skey' (get_maxidx_smap m) (get_bindings_smap m)) eqn:E_not_eq_keys.
           +++ pose proof (IH_sstrg' H_valid_sstrg' H_valid_skey H_smv) as IH_sstrg'_0.
               apply IH_sstrg'_0.
           +++ rewrite <- H_smv.
               simpl.
               auto.

    (* correcrt *)
    - unfold sload_solver_correct_res.
      intros m sstrg skey instk_height smv ops idx1 m1.
      intros H_valid_smap H_valid_sstrg H_valid_skey H_basic_sload_solver H_add_to_smap.
      induction sstrg as [| u sstrg' IH_sstrg'].
      + simpl in H_basic_sload_solver.
        rewrite <- H_basic_sload_solver in H_add_to_smap.
        exists idx1. exists m1.
        split; try auto.
        intros stk mem strg ctx H_len_stk.
        symmetry in H_len_stk.
        pose proof (symsload_valid_smv instk_height (get_maxidx_smap m) skey [] ops H_valid_skey H_valid_sstrg) as H_valid_smv.
        pose proof (add_to_smap_valid_smap instk_height idx1 m m1 (SymSLOAD skey []) ops H_valid_smap H_valid_smv H_add_to_smap) as H_valid_m1.
        assert (H_add_to_smap' := H_add_to_smap).
        symmetry in H_add_to_smap'.
        pose proof (add_to_smap_key_lt_maxidx m m1 idx1 (SymSLOAD skey []) H_add_to_smap') as H_idx1_lt_maxidx_m1.
        pose proof (valid_sstack_val_freshvar instk_height (get_maxidx_smap m1) idx1 H_idx1_lt_maxidx_m1) as H_valid_fresh_idx1.
        unfold valid_smap in H_valid_m1.
        pose proof (eval_sstack_val_succ (get_bindings_smap m1) instk_height (FreshVar idx1) stk mem strg ctx (get_maxidx_smap m1) ops H_len_stk H_valid_fresh_idx1 H_valid_m1) as H_eval_sstack_val.
        destruct H_eval_sstack_val as [v H_eval_sstack_val].
        exists v.
        rewrite H_eval_sstack_val.
        split; reflexivity.
      + unfold basic_sload_solver in H_basic_sload_solver.
        destruct u.
        simpl in H_valid_sstrg.
        destruct H_valid_sstrg as [[H_valid_key H_valid_value] H_valid_sstrg'].
        destruct (sstack_val_cmp (S (get_maxidx_smap m)) skey key (get_maxidx_smap m) (get_bindings_smap m) (get_maxidx_smap m) (get_bindings_smap m) instk_height ops) eqn:E_cmp_skey_key.
        
        * destruct m as [maxidx_m bs_m] eqn:E_m.
          exists maxidx_m.
          exists (SymMap (S maxidx_m) ((maxidx_m,(SymSLOAD skey (U_SSTORE sstack_val key value :: sstrg')))::bs_m)).
          split.
          ++ simpl. reflexivity.
          ++ intros stk mem strg ctx H_len_stk.
             rewrite <- H_basic_sload_solver in H_add_to_smap.
             simpl in H_add_to_smap.
             injection H_add_to_smap as H_idx1 H_m1.
             rewrite <- H_idx1.
             rewrite <- H_m1.
             simpl.
             unfold eval_sstack_val.
             rewrite eval_sstack_val'_immediate_fresh_var.
             remember (S maxidx_m) as S_maxidx_m.
             unfold eval_sstack_val' at 2.
             fold eval_sstack_val'.
             rewrite HeqS_maxidx_m.
             rewrite follow_smap_first_match; try reflexivity.  (* the reflexivity is for is_fresh_var_smv *)

             unfold symbolic_state_cmp.SymbolicStateCmp.safe_sstack_val_cmp_ext_1 in H_sstack_val_cmp_snd.
             pose proof (H_sstack_val_cmp_snd (S maxidx_m)) as H_sstack_val_cmp_snd.
             unfold symbolic_state_cmp.SymbolicStateCmp.safe_sstack_val_cmp_ext_1_d in H_sstack_val_cmp_snd.
             pose proof (H_sstack_val_cmp_snd (S maxidx_m) (Nat.le_refl (S maxidx_m) )) as H_sstack_val_cmp_snd.
             unfold symbolic_state_cmp.SymbolicStateCmp.safe_sstack_val_cmp in H_sstack_val_cmp_snd.
             pose proof (H_sstack_val_cmp_snd skey key maxidx_m bs_m maxidx_m bs_m instk_height ops H_valid_skey H_valid_key H_valid_smap H_valid_smap E_cmp_skey_key stk mem strg ctx H_len_stk) as H_sstack_val_cmp_snd.
             destruct H_sstack_val_cmp_snd as [v [H_sstack_val_cmp_snd_1 H_sstack_val_cmp_snd_2]].
             unfold eval_sstack_val in H_sstack_val_cmp_snd_1.
             unfold eval_sstack_val in H_sstack_val_cmp_snd_2.

             pose proof (valid_sstorage_update_kv instk_height maxidx_m key value H_valid_key H_valid_value) as H_valid_update.
             pose proof (valid_sstorage_when_extended_with_valid_update instk_height maxidx_m (U_SSTORE sstack_val key value) sstrg' H_valid_update H_valid_sstrg') as H_valid_u_sstrg'.
             pose proof (H_map_o_sstrg instk_height (S maxidx_m) stk mem strg ctx maxidx_m bs_m ops (U_SSTORE sstack_val key value :: sstrg') H_valid_u_sstrg' H_valid_smap (gt_Sn_n maxidx_m) (eq_sym H_len_stk)) as H_map_o_sstrg_0.
             destruct H_map_o_sstrg_0 as [v' H_map_o_sstrg_0].
             rewrite H_map_o_sstrg_0.
             rewrite H_sstack_val_cmp_snd_1.
             destruct v'.
             
             +++ pose proof (map_option_len (storage_update sstack_val) (storage_update EVMWord) (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val' (S maxidx_m) sv stk mem strg ctx maxidx_m bs_m ops)) (U_SSTORE sstack_val key value :: sstrg') [] H_map_o_sstrg_0) as H_l_len.
                 discriminate.
             +++ pose proof (map_option_hd (storage_update sstack_val) (storage_update EVMWord) (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val' (S maxidx_m) sv stk mem strg ctx maxidx_m bs_m ops)) sstrg' v' (U_SSTORE sstack_val key value) s H_map_o_sstrg_0) as H_map_o_sstrg_1.
                 destruct H_map_o_sstrg_1 as [H_map_o_sstrg_1_0 H_map_o_sstrg_1_1].

                 unfold eval_common.EvalCommon.instantiate_storage_update in H_map_o_sstrg_1_0.
                 rewrite H_sstack_val_cmp_snd_2 in H_map_o_sstrg_1_0.
                 destruct (eval_sstack_val' (S maxidx_m) value stk mem strg ctx maxidx_m bs_m ops) as [value_v|] eqn:E_eval_value; try discriminate.
                 pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx_m) (S (S maxidx_m)) maxidx_m bs_m value value_v stk mem strg ctx ops (Nat.le_succ_diag_r (S maxidx_m)) E_eval_value) as E_eval_value_0.
                 rewrite E_eval_value_0.

                 injection H_map_o_sstrg_1_0 as H_map_o_sstrg_1_0.
                 rewrite <- H_map_o_sstrg_1_0.

                 simpl.
                
                 rewrite ssload_sstore_same_address.
                 exists value_v.
                 split; reflexivity.
      * fold basic_sload_solver in H_basic_sload_solver.
        destruct (not_eq_keys skey key (get_maxidx_smap m) (get_bindings_smap m) instk_height ops) eqn:E_not_eq_keys.
        ** pose proof (IH_sstrg' H_valid_sstrg' H_basic_sload_solver) as IH_sstrg'_0.
           destruct IH_sstrg'_0 as [idx2 IH_sstrg'_0].
           destruct IH_sstrg'_0 as [m2 IH_sstrg'_0].
           destruct IH_sstrg'_0 as [IH_sstrg'_0_0 IH_sstrg'_0_1].
           destruct m eqn:E_m.
           simpl in IH_sstrg'_0_0.
           injection IH_sstrg'_0_0 as IH_sstrg'_0_0_0 IH_sstrg'_0_0_1.
           simpl.
           exists maxid.
           exists (SymMap (S maxid) ((maxid, SymSLOAD skey (U_SSTORE sstack_val key value :: sstrg')) :: bindings)).
           split; try reflexivity.
           intros stk mem strg ctx H_stk_len.
           simpl in H_add_to_smap.
           injection H_add_to_smap as H_add_to_smap_0 H_add_to_smap_1.
           rewrite <- H_add_to_smap_1.
           rewrite <- H_add_to_smap_0.
           simpl.
           rewrite <- IH_sstrg'_0_0_1 in IH_sstrg'_0_1.
           rewrite <- H_add_to_smap_1 in IH_sstrg'_0_1.
           rewrite <- IH_sstrg'_0_0_0 in IH_sstrg'_0_1.
           rewrite <- H_add_to_smap_0 in IH_sstrg'_0_1.
           simpl in IH_sstrg'_0_1.
           unfold eval_sstack_val.
           unfold eval_sstack_val in IH_sstrg'_0_1.
           remember (S maxid) as S_maxid.
           unfold eval_sstack_val' at 2.
           fold eval_sstack_val'.
           rewrite HeqS_maxid.
           rewrite follow_smap_first_match; try reflexivity.

           pose proof (valid_sstorage_update_kv instk_height maxid key value H_valid_key H_valid_value) as H_valid_update.
           pose proof (valid_sstorage_when_extended_with_valid_update instk_height maxid (U_SSTORE sstack_val key value) sstrg' H_valid_update H_valid_sstrg') as H_valid_u_sstrg'.
           pose proof (H_map_o_sstrg instk_height (S maxid) stk mem strg ctx maxid bindings ops (U_SSTORE sstack_val key value :: sstrg') H_valid_u_sstrg' H_valid_smap (gt_Sn_n maxid) (eq_sym H_stk_len)) as H_map_o_sstrg_0.
           destruct H_map_o_sstrg_0 as [v H_map_o_sstrg_0].
           rewrite H_map_o_sstrg_0.

           pose proof (IH_sstrg'_0_1 stk mem strg ctx H_stk_len) as IH_sstrg'_0_1_0.
           destruct IH_sstrg'_0_1_0 as [v' IH_sstrg'_0_1_0].
           destruct IH_sstrg'_0_1_0 as [IH_sstrg'_0_1_0_0 IH_sstrg'_0_1_0_1].
           exists v'.
           split.
           *** rewrite <- HeqS_maxid.
               apply IH_sstrg'_0_1_0_0.
           *** pose proof (eval_sstack_val'_succ (S maxid) instk_height skey stk mem strg ctx maxid bindings ops (eq_sym H_stk_len) H_valid_skey H_valid_smap (gt_Sn_n maxid)) as H_eval_skey.
               destruct H_eval_skey as [skey_v H_eval_skey].
               rewrite  H_eval_skey.
           
               destruct v.
             
             +++ pose proof (map_option_len (storage_update sstack_val) (storage_update EVMWord) (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val' (S maxid) sv stk mem strg ctx maxid bindings ops)) (U_SSTORE sstack_val key value :: sstrg') [] H_map_o_sstrg_0) as H_l_len.
                 discriminate.
             +++ pose proof (map_option_hd (storage_update sstack_val) (storage_update EVMWord) (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val' (S maxid) sv stk mem strg ctx maxid bindings ops)) sstrg' v (U_SSTORE sstack_val key value) s H_map_o_sstrg_0) as H_map_o_sstrg_1.
                 destruct H_map_o_sstrg_1 as [H_map_o_sstrg_1_0 H_map_o_sstrg_1_1].

                 unfold eval_common.EvalCommon.instantiate_storage_update in H_map_o_sstrg_1_0.

                 destruct (eval_sstack_val' (S maxid) key stk mem strg ctx maxid bindings ops) as [key_v|] eqn:E_eval_key; try discriminate.
                 destruct (eval_sstack_val' (S maxid) value stk mem strg ctx maxid bindings ops) as [value_v|] eqn:E_eval_value; try discriminate.
                 injection H_map_o_sstrg_1_0 as H_map_o_sstrg_1_0.
                 rewrite <- H_map_o_sstrg_1_0.

                 simpl.
                 remember (eval_common.EvalCommon.update_storage strg v) as strg_w_v.
                 unfold concrete_interpreter.ConcreteInterpreter.sstore.
                 unfold concrete_interpreter.ConcreteInterpreter.sload.

                 pose proof (not_eq_keys_snd skey key maxid bindings instk_height ops H_valid_smap H_valid_skey H_valid_key E_not_eq_keys stk mem strg ctx H_stk_len) as H_not_eq_keys_snd.
                 destruct H_not_eq_keys_snd as [v1 [v2 [not_eq_keys_snd_0 [not_eq_keys_snd_1 not_eq_keys_snd_3]]]].
                 rewrite H_eval_skey in not_eq_keys_snd_0.
                 injection not_eq_keys_snd_0 as not_eq_keys_snd_0.
                 rewrite not_eq_keys_snd_0.
                 rewrite E_eval_key in not_eq_keys_snd_1.
                 injection not_eq_keys_snd_1 as not_eq_keys_snd_1.
                 rewrite not_eq_keys_snd_1.

                 
                 assert( H_v1_neq_v2:  (wordToN v1 =? wordToN v2)%N = false ).
                 {
                   assert( (wordToNat v1) <> (wordToNat v2)).
                   {
                     apply wordToNat_neq1.
                     apply weqb_false.
                     apply not_eq_keys_snd_3.
                   }
                   rewrite wordToN_nat.
                   rewrite wordToN_nat.
                   rewrite N.eqb_neq.
                   intuition.
                 }

                 rewrite H_v1_neq_v2.
                 unfold eval_sstack_val' in IH_sstrg'_0_1_0_1.
                 fold eval_sstack_val' in IH_sstrg'_0_1_0_1.
                 rewrite HeqS_maxid in IH_sstrg'_0_1_0_1.
                 rewrite follow_smap_first_match in IH_sstrg'_0_1_0_1; try reflexivity.
                 destruct (map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val' (S maxid) sv stk mem strg ctx maxid bindings ops)) sstrg') eqn:E_map_op_sstrg'; try discriminate.
                 rewrite H_eval_skey in IH_sstrg'_0_1_0_1.
                 injection IH_sstrg'_0_1_0_1 as IH_sstrg'_0_1_0_1.
                 injection H_map_o_sstrg_1_1 as H_map_o_sstrg_1_1.
                 rewrite H_map_o_sstrg_1_1 in IH_sstrg'_0_1_0_1.
                 rewrite <- Heqstrg_w_v in IH_sstrg'_0_1_0_1.
                 unfold concrete_interpreter.ConcreteInterpreter.sload in IH_sstrg'_0_1_0_1.
                 rewrite not_eq_keys_snd_0 in IH_sstrg'_0_1_0_1.
                 rewrite IH_sstrg'_0_1_0_1.
                 reflexivity.
        ** rewrite <- H_basic_sload_solver in H_add_to_smap.
           exists idx1.
           exists m1.
           split.
           *** apply H_add_to_smap.
           *** intros stk mem strg ctx H_stk_len.
               destruct m.
               simpl in H_add_to_smap.
               injection H_add_to_smap as H_idx1 H_m1.
               rewrite <- H_idx1.
               rewrite <- H_m1.
               simpl.
               unfold eval_sstack_val.

               assert(H_valid_ext_bindings: valid_bindings instk_height (S maxid) ((maxid, SymSLOAD skey (U_SSTORE sstack_val key value :: sstrg')) :: bindings) ops). simpl. split; auto.
               
               pose proof (eval_sstack_val'_succ (S (S maxid)) instk_height (FreshVar maxid) stk mem strg ctx (S maxid) ((maxid, SymSLOAD skey (U_SSTORE sstack_val key value :: sstrg')) :: bindings) ops (eq_sym H_stk_len) (Nat.lt_succ_diag_r maxid) H_valid_ext_bindings (gt_Sn_n (S maxid))) as H_eval_FV_maxid.
               destruct  H_eval_FV_maxid as [v  H_eval_FV_maxid].
               exists v.
               rewrite H_eval_FV_maxid.
               split; reflexivity.
  Qed.

  Lemma basic_sstorage_updater_remove_dups_valid:
    forall sstack_val_cmp skey instk_height m ops sstrg sstrg_r,
      symbolic_state_cmp.SymbolicStateCmp.safe_sstack_val_cmp_ext_1 sstack_val_cmp ->
      valid_sstack_value instk_height (get_maxidx_smap m) skey ->
      valid_sstorage instk_height (get_maxidx_smap m) sstrg ->
      basic_sstorage_updater_remove_dups sstack_val_cmp skey sstrg instk_height m ops = sstrg_r ->
      valid_sstorage instk_height (get_maxidx_smap m) sstrg_r.
  Proof.
    intros sstack_val_cmp skey instk_height m ops.
    induction sstrg as [| u sstrg' IHsstrg'].
    + intros sstrg_r H_sstack_val_cmp_snd H_valid_skey H_valid_sstrg H_basic_sstorage_updater_remove_dups.
      simpl in H_basic_sstorage_updater_remove_dups.
      rewrite <- H_basic_sstorage_updater_remove_dups.
      reflexivity.
    + intros sstrg_r H_sstack_val_cmp_snd H_valid_skey H_valid_sstrg H_basic_sstorage_updater_remove_dups.
      unfold basic_sstorage_updater_remove_dups in H_basic_sstorage_updater_remove_dups.
      fold basic_sstorage_updater_remove_dups in H_basic_sstorage_updater_remove_dups.
      destruct u as [skey' svalue] eqn:E_u.
      destruct (sstack_val_cmp (S (get_maxidx_smap m)) skey skey' (get_maxidx_smap m) (get_bindings_smap m) (get_maxidx_smap m) (get_bindings_smap m) instk_height ops) eqn:E_cmp_skey_skey'.
      ++ apply IHsstrg'.
         +++ apply H_sstack_val_cmp_snd.
         +++ apply H_valid_skey.
         +++ apply H_valid_sstrg.
         +++ apply H_basic_sstorage_updater_remove_dups.
      ++ destruct (not_eq_keys skey skey' (get_maxidx_smap m) (get_bindings_smap m) instk_height ops) eqn:E_not_eq_keys.
         +++ destruct sstrg_r as [|u_r sstrg_r']; try discriminate.
             injection H_basic_sstorage_updater_remove_dups as H_u_r H_sstrg_r'.
             simpl.
             split.
             ++++ rewrite <- H_u_r.
                  simpl.
                  split; apply H_valid_sstrg.
             ++++ apply IHsstrg'.
                  +++++ apply H_sstack_val_cmp_snd.
                  +++++ apply H_valid_skey.
                  +++++ apply H_valid_sstrg.
                  +++++ apply H_sstrg_r'.
         +++ rewrite <- H_basic_sstorage_updater_remove_dups.
             simpl.
             split; try split; apply H_valid_sstrg.
  Qed.
      
    

  Lemma basic_sstorage_updater_snd: sstorage_updater_ext_snd basic_sstorage_updater.
    unfold sstorage_updater_ext_snd.
    intros sstack_val_cmp H_sstack_val_cmp_snd.
    unfold sstorage_updater_snd.
    split.
    (* Validity *)
    + unfold sstorage_updater_valid_res.
      intros m sstrg sstrg' u instk_height ops.
      intros H_valid_sstrg H_valid_u H_basic_sstrg_updater.
         unfold basic_sstorage_updater in H_basic_sstrg_updater.
         destruct u as [skey svalue] eqn:E_u.
         destruct sstrg' as [|u' sstrg'']; try discriminate.
         injection H_basic_sstrg_updater as H_u' H_sstrg''.
         rewrite <- H_u'.
         simpl.
         split; try split; try apply H_valid_u.
         
         apply basic_sstorage_updater_remove_dups_valid in H_sstrg''.
      ++ apply H_sstrg''.
      ++ apply H_sstack_val_cmp_snd.
      ++ apply H_valid_u.
      ++ apply H_valid_sstrg.
    + admit.
      
  Admitted.

End StorageOpsSolversImplSoundness.


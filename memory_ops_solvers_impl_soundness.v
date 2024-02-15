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

Require Import FORVES.memory_ops_solvers.
Import MemoryOpsSolvers.

Require Import FORVES.memory_ops_solvers_impl.
Import MemoryOpsSolversImpl.

Require Import FORVES.symbolic_state_cmp.
Import SymbolicStateCmp.

Require Import FORVES.symbolic_execution_soundness.
Import SymbolicExecutionSoundness.

Require Import storage_ops_solvers_impl_soundness.
Import StorageOpsSolversImplSoundness.

Module MemoryOpsSolversImplSoundness.

  Lemma trivial_mload_solver_snd: mload_solver_ext_snd trivial_mload_solver.
  Proof.
    unfold mload_solver_ext_snd.
    unfold mload_solver_snd.
    intros.
    split.
    - unfold mload_solver_valid_res.
      intros.
      unfold trivial_mload_solver in H2.
      rewrite <- H2.
      simpl.
      intuition.
    - unfold mload_solver_correct_res.
      intros.
      unfold trivial_mload_solver in H3.
      rewrite <- H3 in H4.
      rewrite H4.
      exists idx1.
      exists m1.
      split; try reflexivity.
      intros.
      unfold eval_sstack_val.
      symmetry in H5.

      assert (H_valid_smap_value: valid_smap_value instk_height (get_maxidx_smap m) ops (SymMLOAD soffset smem)). simpl. intuition.

      symmetry in H4.
      pose proof (add_to_smap_key_lt_maxidx m m1 idx1 (SymMLOAD soffset smem) H4).
      pose proof (valid_sstack_val_freshvar instk_height (get_maxidx_smap m1) idx1 H6).
      symmetry in H4.
      pose proof (add_to_smap_valid_smap instk_height idx1 m m1 (SymMLOAD soffset smem) ops H0 H_valid_smap_value H4).
      pose proof (eval_sstack_val'_succ (S (get_maxidx_smap m1)) instk_height (FreshVar idx1) stk mem strg ctx (get_maxidx_smap m1) (get_bindings_smap m1) ops H5 H7 H8 (gt_Sn_n (get_maxidx_smap m1))).
      destruct H9 as [v H9].
      exists v.
      split; apply H9.
  Qed.
  
  Lemma trivial_smemory_updater_snd: smemory_updater_ext_snd trivial_smemory_updater.
  Proof.
    unfold smemory_updater_ext_snd.
    intros sstack_val_cmp H_valid_sstack_val_cmp.
    unfold smemory_updater_snd.
    split.
    - unfold smemory_updater_valid_res.
      intros m smem smem' u instk_height ops H_valid_smem H_valid_u H_updater.
      unfold trivial_smemory_updater in H_updater.
      rewrite <- H_updater.
      simpl.
      split.
      + apply H_valid_u.
      + apply H_valid_smem.
    - unfold smemory_updater_correct_res.
      intros m smem smem' u instk_height ops H_valid_smap H_valid_smem H_valid_u H_updater.
      unfold trivial_smemory_updater in H_updater.
      rewrite <- H_updater.
      intros stk mem strg ctx H_len_stk.
      pose proof (valid_smemory_when_extended_with_valid_update instk_height (get_maxidx_smap m) u smem H_valid_u H_valid_smem) as H_valid_u_smem.
      unfold valid_smap in H_valid_smap.
      symmetry in H_len_stk.
      pose proof (eval_smemory_succ instk_height (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops (u::smem) H_len_stk H_valid_u_smem H_valid_smap) as H_eval_smemory_u_smem.
      destruct H_eval_smemory_u_smem as [smem'' H_eval_smemory_u_smem].
      exists smem''.
      exists smem''.
      repeat split; apply H_eval_smemory_u_smem.
  Qed.

Lemma  H_memory_slots_do_not_overlap:
    forall soffset soffset' size size' maxidx sbindings instk_height ops,
      valid_bindings instk_height maxidx sbindings ops ->
      valid_sstack_value instk_height maxidx soffset  ->
      valid_sstack_value instk_height maxidx soffset' ->
      memory_slots_do_not_overlap soffset soffset' size size' maxidx sbindings instk_height ops = true ->
      forall stk mem strg ctx,
        (length stk) = instk_height ->
        exists v1 v2,
        eval_sstack_val' (S maxidx) soffset stk mem strg ctx maxidx sbindings ops = Some v1 /\
          eval_sstack_val' (S maxidx) soffset' stk mem strg ctx maxidx sbindings ops = Some v2 /\
          orb ((wordToN v1)+size <? (wordToN v2))%N ((wordToN v2) + size' <? (wordToN v1))%N = true.
  Proof.
    intros soffset soffset' size size' maxidx sbindings instk_height ops.
    intros H_valid_sbindings H_valid_offset H_valid_offset' H_addr_nover.
    unfold memory_slots_do_not_overlap in H_addr_nover.
    
    destruct (follow_in_smap soffset maxidx sbindings) as [soffset_m|] eqn:E_follow_soffset; try discriminate.
    destruct soffset_m; try discriminate.
    destruct smv; try discriminate.
    destruct val; try discriminate.

    destruct (follow_in_smap soffset' maxidx sbindings) as [soffset'_m|] eqn:E_follow_soffset'; try discriminate.
    destruct soffset'_m; try discriminate.
    destruct smv; try discriminate.
    destruct val0; try discriminate.

    intros stk mem strg ctx.
    intros H_stk_len.
    unfold eval_sstack_val' at 1.
    rewrite E_follow_soffset.
    unfold eval_sstack_val' at 1.
    rewrite E_follow_soffset'.
    exists val.
    exists val0.
    split; try split; try reflexivity.
    apply H_addr_nover.
  Qed.


  Lemma  H_mstore8_is_included_in_mstore:
    forall soffset_mstore8 soffset_mstore maxidx sbindings instk_height ops,
      valid_bindings instk_height maxidx sbindings ops ->
      valid_sstack_value instk_height maxidx soffset_mstore8  ->
      valid_sstack_value instk_height maxidx soffset_mstore ->
      mstore8_is_included_in_mstore soffset_mstore8 soffset_mstore maxidx sbindings instk_height ops = true ->
      forall stk mem strg ctx,
        (length stk) = instk_height ->
        exists v1 v2,
        eval_sstack_val' (S maxidx) soffset_mstore8 stk mem strg ctx maxidx sbindings ops = Some v1 /\
          eval_sstack_val' (S maxidx) soffset_mstore stk mem strg ctx maxidx sbindings ops = Some v2 /\
          andb ((wordToN v2) <=? (wordToN v1) )%N ((wordToN v1) <=? (wordToN v2)+31)%N = true.
  Proof.
    intros soffset_mstore8 soffset_mstore maxidx sbindings instk_height ops.
    intros H_valid_sbindings H_valid_offset_mstore8 H_valid_offset_mstore H_addr_not_inc.
    unfold mstore8_is_included_in_mstore in H_addr_not_inc.

    destruct (follow_in_smap soffset_mstore8 maxidx sbindings) as [soffset_mstore8_m|] eqn:E_follow_soffset_mstore8; try discriminate.
    destruct soffset_mstore8_m; try discriminate.
    destruct smv; try discriminate.
    destruct val; try discriminate.

    destruct (follow_in_smap soffset_mstore maxidx sbindings) as [soffset_mstore_m|] eqn:E_follow_soffset_mstore; try discriminate.
    destruct soffset_mstore_m; try discriminate.
    destruct smv; try discriminate.
    destruct val0; try discriminate.

    intros stk mem strg ctx.
    intros H_stk_len.
    unfold eval_sstack_val' at 1.
    rewrite E_follow_soffset_mstore8.
    unfold eval_sstack_val' at 1.
    rewrite E_follow_soffset_mstore.
    exists val.
    exists val0.
    split; try split; try reflexivity.
    apply H_addr_not_inc.
  Qed.

  Lemma basic_mload_solver_valid:
    forall sstack_val_cmp,
      mload_solver_valid_res (basic_mload_solver sstack_val_cmp).
  Proof.
    intros sstack_val_cmp.
    unfold mload_solver_valid_res.
    intros m smem soffset instk_height smv ops H_valid_smem H_valid_offset.
    revert H_valid_smem.
    revert smem.
    induction smem as [|u smem' IHsmem'].
    + intros H_valid_smem H_basic_solver.
      simpl in H_basic_solver.
      rewrite <- H_basic_solver.
      simpl.
      split; auto.
    + intros H_valid_smem H_basic_solver.
      simpl in H_basic_solver.
      destruct u as [soffset' svalue|].
      ++ destruct (sstack_val_cmp (S (get_maxidx_smap m)) soffset soffset' (get_maxidx_smap m) (get_bindings_smap m) (get_maxidx_smap m) (get_bindings_smap m) instk_height ops) eqn:E_soffset_soffset'_cmp.
         +++ rewrite <- H_basic_solver.
             simpl.
             apply H_valid_smem.
         +++ destruct (memory_slots_do_not_overlap soffset soffset' 31 31) eqn:E_do_not_overlap.
             ++++ apply IHsmem'.
                  apply H_valid_smem.
                  apply H_basic_solver.
             ++++ rewrite <- H_basic_solver.
                  simpl.
                  split; auto.
      ++ destruct (memory_slots_do_not_overlap soffset offset 31 0) eqn:E_do_not_overlap.
         +++ apply IHsmem'.
             apply H_valid_smem.
             apply H_basic_solver.
         +++ rewrite <- H_basic_solver.
             simpl.
             split; auto.
  Qed.


  Lemma S_S_n_gt_n: forall n, S (S n) > n.
  Proof.
    auto.
  Qed.
  

                                                                                               
Lemma H_map_o_smem:
  forall instk_height d stk mem strg ctx maxidx bs ops smem,
    valid_smemory instk_height maxidx smem ->
    valid_bindings instk_height maxidx bs ops ->
    d > maxidx ->
    instk_height = length stk ->
    exists v,
      map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' d sv stk mem strg ctx maxidx bs ops)) smem = Some v.
Proof.
induction smem as [|u sstrg' IHsstrg'].
+ intros. simpl. exists []. reflexivity.
+ intros H_valid_smemory H_valid_bs H_d_gt_maxidx H_len_stk.
  unfold map_option.
  rewrite <- map_option_ho.
  unfold eval_common.EvalCommon.instantiate_memory_update at 1.
  destruct u as [soffset' svalue' | soffset' svalue'].

  ++ unfold valid_smemory in H_valid_smemory. fold valid_smemory in H_valid_smemory.
     destruct H_valid_smemory as [H_valid_smemory_0 H_valid_smemory_1].
     unfold valid_smemory_update in H_valid_smemory_0.
     destruct H_valid_smemory_0 as [H_valid_smemory_0_0 H_valid_smemory_0_1].

     pose proof (eval_sstack_val'_succ d instk_height soffset' stk mem strg ctx maxidx bs ops H_len_stk H_valid_smemory_0_0 H_valid_bs H_d_gt_maxidx) as eval_sstack_val'_succ_0.
  
     destruct eval_sstack_val'_succ_0 as [v eval_sstack_val'_succ_0].
     rewrite eval_sstack_val'_succ_0.
     pose proof (eval_sstack_val'_succ d instk_height svalue' stk mem strg ctx maxidx bs ops H_len_stk H_valid_smemory_0_1 H_valid_bs H_d_gt_maxidx) as eval_sstack_val'_succ_1.
     destruct eval_sstack_val'_succ_1 as [v' eval_sstack_val'_succ_1].
     rewrite eval_sstack_val'_succ_1.

     pose proof (IHsstrg' H_valid_smemory_1 H_valid_bs H_d_gt_maxidx H_len_stk) as IHsstrg'_0.
     destruct IHsstrg'_0 as [v'' IHsstrg'_0].
     rewrite IHsstrg'_0.
     exists (U_MSTORE EVMWord v v' :: v'').
     reflexivity.
  ++ unfold valid_smemory in H_valid_smemory. fold valid_smemory in H_valid_smemory.
     destruct H_valid_smemory as [H_valid_smemory_0 H_valid_smemory_1].
     unfold valid_smemory_update in H_valid_smemory_0.
     destruct H_valid_smemory_0 as [H_valid_smemory_0_0 H_valid_smemory_0_1].

     pose proof (eval_sstack_val'_succ d instk_height soffset' stk mem strg ctx maxidx bs ops H_len_stk H_valid_smemory_0_0 H_valid_bs H_d_gt_maxidx) as eval_sstack_val'_succ_0.
  
     destruct eval_sstack_val'_succ_0 as [v eval_sstack_val'_succ_0].
     rewrite eval_sstack_val'_succ_0.
     pose proof (eval_sstack_val'_succ d instk_height svalue' stk mem strg ctx maxidx bs ops H_len_stk H_valid_smemory_0_1 H_valid_bs H_d_gt_maxidx) as eval_sstack_val'_succ_1.
     destruct eval_sstack_val'_succ_1 as [v' eval_sstack_val'_succ_1].
     rewrite eval_sstack_val'_succ_1.

     pose proof (IHsstrg' H_valid_smemory_1 H_valid_bs H_d_gt_maxidx H_len_stk) as IHsstrg'_0.
     destruct IHsstrg'_0 as [v'' IHsstrg'_0].
     rewrite IHsstrg'_0.
     exists (U_MSTORE8 EVMWord v v' :: v'').
     reflexivity.
  Qed.


Lemma mload_mstore_same_address:
  forall mem addr value,
    (concrete_interpreter.ConcreteInterpreter.mload
       (concrete_interpreter.ConcreteInterpreter.mstore mem value addr) addr) = value.
Proof.
  Admitted.


Lemma do_not_overlap_mload:
  forall mem offset offset' value' updates,
    (wordToN offset + 31 <? wordToN offset')%N || (wordToN offset' + 31 <? wordToN offset)%N = true ->
    (concrete_interpreter.ConcreteInterpreter.mload'' (eval_common.EvalCommon.update_memory mem (U_MSTORE EVMWord offset' value' :: updates)) (wordToN offset) 32) =
    (concrete_interpreter.ConcreteInterpreter.mload'' (eval_common.EvalCommon.update_memory mem  updates) (wordToN (offset : EVMWord)) 32).
Proof.
  Admitted.

Lemma do_not_overlap_mload_0:
  forall mem offset offset' value' updates,
    (wordToN offset + 31 <? wordToN offset')%N || (wordToN offset' + 0 <? wordToN offset)%N = true ->
    (concrete_interpreter.ConcreteInterpreter.mload'' (eval_common.EvalCommon.update_memory mem (U_MSTORE8 EVMWord offset' value' :: updates)) (wordToN offset) 32) =
    (concrete_interpreter.ConcreteInterpreter.mload'' (eval_common.EvalCommon.update_memory mem  updates) (wordToN (offset : EVMWord)) 32).
Proof.
  Admitted.


Lemma two_consecutive_updates_same_address:
  forall soffset soffset' svalue svalue' smem maxidx bs stk mem strg ctx ops v,
    eval_sstack_val soffset stk mem strg ctx maxidx bs ops = Some v ->
    eval_sstack_val soffset' stk mem strg ctx maxidx bs ops = Some v ->
    eval_smemory (U_MSTORE sstack_val soffset svalue :: U_MSTORE sstack_val soffset' svalue' :: smem) maxidx bs stk mem strg ctx ops =
      eval_smemory (U_MSTORE sstack_val soffset svalue :: smem) maxidx bs stk mem strg ctx ops.
Proof.
Admitted.

Lemma two_consecutive_mstore8_updates_same_address:
  forall soffset soffset' svalue svalue' smem maxidx bs stk mem strg ctx ops v,
    eval_sstack_val soffset stk mem strg ctx maxidx bs ops = Some v ->
    eval_sstack_val soffset' stk mem strg ctx maxidx bs ops = Some v ->
    eval_smemory (U_MSTORE8 sstack_val soffset svalue :: U_MSTORE8 sstack_val soffset' svalue' :: smem) maxidx bs stk mem strg ctx ops =
      eval_smemory (U_MSTORE8 sstack_val soffset svalue :: smem) maxidx bs stk mem strg ctx ops.
Proof.
Admitted.

Lemma two_consecutive_updates_same_address_mstore8:
  forall soffset_mstore8 soffset_mstore svalue8 svalue smem maxidx bs stk mem strg ctx ops v1 v2,
    eval_sstack_val soffset_mstore8 stk mem strg ctx maxidx bs ops = Some v1 ->
    eval_sstack_val soffset_mstore stk mem strg ctx maxidx bs ops = Some v2 ->
    andb ((wordToN v2) <=? (wordToN v1) )%N ((wordToN v1) <=? (wordToN v2)+31)%N = true ->
    eval_smemory (U_MSTORE sstack_val soffset_mstore svalue :: U_MSTORE8 sstack_val soffset_mstore8 svalue8 :: smem) maxidx bs stk mem strg ctx ops =
      eval_smemory (U_MSTORE sstack_val soffset_mstore svalue :: smem) maxidx bs stk mem strg ctx ops.
Proof.
Admitted.

Lemma mem_eq_when_after_update_eq:
  forall mem1 mem2 u,
    eval_common.EvalCommon.update_memory' mem1 u = eval_common.EvalCommon.update_memory' mem2 u ->
    mem1 = mem2.
Admitted.
                                                                                                         
Lemma N_of_nat_Sn:
  forall x n, (x + N.of_nat (S n) = x+ 1 + N.of_nat n)%N.
Proof.
  intros x n.
  apply N2Nat.inj_iff.
  repeat rewrite N2Nat.inj_add.
  intuition.
Qed.


Lemma mstore'_not_touched_addresses_remain_the_same:
  forall sz mem w offset mem',
    concrete_interpreter.ConcreteInterpreter.mstore' mem  (w : (word (sz*8))) offset = mem' ->
    forall offset', (offset' >= offset + (N.of_nat sz))%N -> mem offset' = mem' offset'.
Proof.
  induction sz as [| sz' IHsz'].
  + intros mem w n mem' H_mstore' n' H_n'_gt_n.
    unfold concrete_interpreter.ConcreteInterpreter.mstore' in H_mstore'.
    rewrite H_mstore'.
    reflexivity.
  + intros mem w offset mem' H_mstore' offset' H_n'_gt_n.
    simpl in H_mstore'.
    rewrite N_of_nat_Sn in H_n'_gt_n.
    pose proof (IHsz' (fun offset' : N => if (offset' =? offset)%N then concrete_interpreter.ConcreteInterpreter.split1_byte w else mem offset')
                     (concrete_interpreter.ConcreteInterpreter.split2_byte w) (offset+1)%N mem' H_mstore' offset' H_n'_gt_n) as IHsz'_0.
    simpl in IHsz'_0.
    destruct ((offset' =? offset)%N) eqn:E_offset_eq_offset'.
    ++  apply N.eqb_eq in E_offset_eq_offset'.
        intuition.        
    ++ rewrite IHsz'_0.
       reflexivity.
Qed.

Lemma basic_mload_solver_snd: mload_solver_ext_snd basic_mload_solver.
  unfold mload_solver_ext_snd.
  unfold mload_solver_snd.
  intros sstack_val_cmp H_sstack_val_cmp.
  split. apply basic_mload_solver_valid.
  unfold mload_solver_correct_res.
  intros m smem soffset instk_height smv ops idx1 m1.
  intros H_valid_smap H_valid_smem H_valid_soffset H_basic_mload_solver H_add_to_smap.
  induction smem as [|u smem' IHsmem'].
  + exists idx1. exists m1.
    split.
    ++ simpl in H_basic_mload_solver.
       rewrite <- H_basic_mload_solver in H_add_to_smap.
       apply H_add_to_smap.
    ++ intros stk mem strg ctx H_stk_len.
       simpl in H_basic_mload_solver.
       rewrite <- H_basic_mload_solver in H_add_to_smap.
       destruct m as [maxidx bs] eqn:E_m.
       simpl in H_add_to_smap.
       injection H_add_to_smap as H_idx1 H_m1.
       rewrite <- H_m1.
       rewrite <- H_idx1.
       simpl.
       unfold eval_sstack_val.
       remember (S maxidx) as S_maxidx.
       unfold eval_sstack_val'.
       fold eval_sstack_val'.
       unfold follow_in_smap.
       fold follow_in_smap.
       rewrite Nat.eqb_refl.
       simpl.
       
       assert(H_S_S_maxid_gt_maxidx: (S (S maxidx) > maxidx)). auto.
       pose proof (eval_sstack_val'_succ (S maxidx) instk_height soffset stk mem strg ctx maxidx bs ops (eq_sym H_stk_len) H_valid_soffset H_valid_smap (gt_Sn_n maxidx)) as H_eval_soffset.
       destruct H_eval_soffset as [soffset_v H_eval_soffset].
       rewrite HeqS_maxidx.
       rewrite H_eval_soffset.
       exists (concrete_interpreter.ConcreteInterpreter.mload mem soffset_v).
       split; reflexivity.
  + unfold basic_mload_solver in H_basic_mload_solver.
    fold basic_mload_solver in H_basic_mload_solver.
    destruct u as [soffset' svalue | soffset' svalue] eqn:E_u.
    ++ destruct (sstack_val_cmp (S (get_maxidx_smap m)) soffset soffset' (get_maxidx_smap m) (get_bindings_smap m) (get_maxidx_smap m) (get_bindings_smap m) instk_height ops) eqn:E_cmp_soffset_soffset'.
       +++ rewrite <- H_basic_mload_solver in H_add_to_smap.
           destruct m as [maxidx bs] eqn:E_m.
           simpl in H_add_to_smap.
             injection H_add_to_smap as H_idx1 H_m1.
             rewrite <- H_idx1.
             rewrite <- H_m1.
             simpl.
             exists maxidx.
             exists (SymMap (S maxidx) ((maxidx, SymMLOAD soffset (U_MSTORE sstack_val soffset' svalue :: smem')) :: bs)).
             split; try reflexivity.
             intros stk mem strg ctx H_stk_len.
             simpl.
             unfold eval_sstack_val.
             
             pose proof (eval_sstack_val'_immediate_fresh_var (S (S maxidx)) maxidx stk mem strg ctx svalue bs ops) as H_eval_fresh_maxidx_0.
             rewrite  H_eval_fresh_maxidx_0.

             simpl in H_valid_smem.
             destruct H_valid_smem as [[H_valid_soffset' H_valid_svalue] H_valid_smem'].

             pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue stk mem strg ctx maxidx bs ops (eq_sym H_stk_len) H_valid_svalue H_valid_smap (gt_Sn_n maxidx)) as H_eval_svalue.
             destruct H_eval_svalue as [svalue_v H_eval_svalue].
             
             pose proof (eval_sstack_val'_preserved_when_depth_extended (S maxidx) maxidx bs svalue svalue_v stk mem strg ctx ops H_eval_svalue) as H_eval_svalue_bis.
             
             exists svalue_v.
             split. apply H_eval_svalue_bis.
             remember (S maxidx) as S_maxidx.
             unfold eval_sstack_val'.
             fold eval_sstack_val'.
             unfold follow_in_smap.
             rewrite Nat.eqb_refl.
             simpl.
             rewrite HeqS_maxidx.
             pose proof (eval_sstack_val'_succ (S maxidx) instk_height soffset' stk mem strg ctx maxidx bs ops (eq_sym H_stk_len) H_valid_soffset' H_valid_smap (gt_Sn_n maxidx)) as H_eval_soffset'.
             destruct  H_eval_soffset' as [soffset'_v H_eval_soffset'].
             rewrite H_eval_soffset'.
             rewrite HeqS_maxidx in  H_eval_svalue.
             rewrite H_eval_svalue.
             pose proof (H_map_o_smem instk_height (S maxidx) stk mem strg ctx maxidx bs ops smem' H_valid_smem' H_valid_smap (gt_Sn_n maxidx) (eq_sym H_stk_len)) as H_mo_1.
             destruct H_mo_1 as [v H_mo_1].
             rewrite H_mo_1.
             pose proof (eval_sstack_val'_succ (S maxidx) instk_height soffset stk mem strg ctx maxidx bs ops (eq_sym H_stk_len) H_valid_soffset H_valid_smap (gt_Sn_n maxidx)) as H_eval_soffset.
             destruct H_eval_soffset as [soffset_v H_eval_soffset].
             rewrite H_eval_soffset.
             simpl.
             simpl in E_cmp_soffset_soffset'.
             unfold safe_sstack_val_cmp_ext_1 in H_sstack_val_cmp.
             unfold safe_sstack_val_cmp_ext_1_d in H_sstack_val_cmp.
             unfold safe_sstack_val_cmp in H_sstack_val_cmp.
             pose proof (H_sstack_val_cmp (S maxidx) (S maxidx) (Nat.le_refl (S maxidx)) soffset soffset' maxidx bs maxidx bs instk_height ops H_valid_soffset H_valid_soffset' H_valid_smap H_valid_smap E_cmp_soffset_soffset' stk mem strg ctx H_stk_len) as H_eval_soffset_soffset'.
             unfold eval_sstack_val in H_eval_soffset_soffset'.
             destruct  H_eval_soffset_soffset' as [soffset_soffset'_v  [H_eval_soffset_bis  H_eval_soffset'_bis]].
             rewrite H_eval_soffset' in H_eval_soffset'_bis.
             injection H_eval_soffset'_bis as H_eval_soffset'_bis.
             rewrite H_eval_soffset in H_eval_soffset_bis.
             injection H_eval_soffset_bis as H_eval_soffset_bis.           
             rewrite H_eval_soffset'_bis.
             rewrite H_eval_soffset_bis.
             pose proof (mload_mstore_same_address (eval_common.EvalCommon.update_memory mem v) soffset_soffset'_v svalue_v) as H_mload_mstore_same_address.
             rewrite H_mload_mstore_same_address.
             reflexivity.
       +++ destruct (memory_slots_do_not_overlap soffset soffset' 31 31) eqn:E_not_overlap.
           ++++ destruct m as [maxidx sb] eqn:E_m.
                simpl in H_valid_smem.
                destruct H_valid_smem as [[H_valid_soffset' H_valid_svalue] H_valid_smem'].

                simpl.
                exists maxidx.
                exists (SymMap (S maxidx) ((maxidx, SymMLOAD soffset (U_MSTORE sstack_val soffset' svalue :: smem')) :: sb)).
                split; try reflexivity.

                intros stk mem strg ctx H_stk_len.

                pose proof (IHsmem' H_valid_smem' H_basic_mload_solver) as IHsmem'_0.
                destruct IHsmem'_0 as [idx2 [m2 [H_add_to_smap' IHsmem'_0]]].
                pose proof (IHsmem'_0 stk mem strg ctx H_stk_len) as IHsmem'_1.
                destruct IHsmem'_1 as [v' [H_eval_freshvar_idx1 H_eval_fresh_var_maxidx]].
                exists v'.
                split; auto.
                simpl.

                unfold eval_sstack_val.
                remember (S maxidx) as S_maxidx.
                unfold eval_sstack_val'.
                fold eval_sstack_val'.
                unfold follow_in_smap.
                rewrite Nat.eqb_refl.
                simpl.
 
                pose proof (H_memory_slots_do_not_overlap soffset soffset' 31 31 maxidx sb instk_height ops H_valid_smap H_valid_soffset H_valid_soffset' E_not_overlap stk mem strg ctx H_stk_len) as H_memory_slots_do_not_overlap_0.
                destruct H_memory_slots_do_not_overlap_0 as [v1' [v2' [H_eval_soffset_bis [H_eval_soffset' H_not_overlap]]]].
                rewrite HeqS_maxidx.
                
                rewrite H_eval_soffset'.
                pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue stk mem strg ctx maxidx sb ops (eq_sym H_stk_len) H_valid_svalue H_valid_smap (gt_Sn_n maxidx)) as H_eval_svalue.
                destruct H_eval_svalue as [svalue_v H_eval_svalue].
                rewrite H_eval_svalue.

                pose proof (H_map_o_smem instk_height (S maxidx) stk mem strg ctx maxidx sb ops smem' H_valid_smem' H_valid_smap (gt_Sn_n maxidx) (eq_sym H_stk_len)) as H_mo_1.
                destruct H_mo_1 as [v''' H_mo_1].
                rewrite H_mo_1.
                
                rewrite H_eval_soffset_bis.

                unfold concrete_interpreter.ConcreteInterpreter.mload.
                unfold concrete_interpreter.ConcreteInterpreter.mload'.

                pose proof (do_not_overlap_mload mem v1' v2' svalue_v v''' H_not_overlap) as H_do_not_overlap_mload.
                rewrite H_do_not_overlap_mload.
                
                simpl in H_add_to_smap'.
                injection H_add_to_smap' as H_idx2 H_m2.
                rewrite <- H_m2 in H_eval_fresh_var_maxidx.
                rewrite <- H_idx2 in H_eval_fresh_var_maxidx.
                simpl in H_eval_fresh_var_maxidx.

                unfold eval_sstack_val in H_eval_fresh_var_maxidx.
                rewrite <- HeqS_maxidx in H_eval_fresh_var_maxidx.
                unfold eval_sstack_val' in H_eval_fresh_var_maxidx.
                fold eval_sstack_val' in H_eval_fresh_var_maxidx.
                unfold follow_in_smap in H_eval_fresh_var_maxidx.
                rewrite Nat.eqb_refl in H_eval_fresh_var_maxidx.
                simpl in H_eval_fresh_var_maxidx.
                destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' S_maxidx sv stk mem strg ctx maxidx sb ops)) smem') as [smem_updates|] eqn:E_mo_1; try discriminate.
                
                
                rewrite HeqS_maxidx in H_eval_fresh_var_maxidx.
                rewrite H_eval_soffset_bis in H_eval_fresh_var_maxidx.
                injection H_eval_fresh_var_maxidx as H_v'.
                unfold concrete_interpreter.ConcreteInterpreter.mload in H_v'.
                unfold concrete_interpreter.ConcreteInterpreter.mload' in H_v'.
                rewrite HeqS_maxidx in E_mo_1.
                rewrite E_mo_1 in H_mo_1.
                injection H_mo_1 as H_mo_1.
                rewrite <- H_mo_1.
                rewrite <- H_v'.
                reflexivity.
           ++++ destruct m as [maxidx sb] eqn:E_m. 
                simpl.
                exists maxidx.
                exists (SymMap (S maxidx) ((maxidx, SymMLOAD soffset (U_MSTORE sstack_val soffset' svalue :: smem')) :: sb)).
                split; try reflexivity.
                intros stk mem strg ctx.
                intros H_stk_len.
                simpl.
                rewrite <- H_basic_mload_solver in H_add_to_smap.
                simpl in H_add_to_smap.
                injection H_add_to_smap as H_idx1 H_m1.
                rewrite <- H_m1.
                simpl.
                rewrite <- H_idx1.
                
                unfold eval_sstack_val.
                remember (S maxidx) as S_maxidx.

                assert(H_valid_freshvar_maxidx: valid_sstack_value instk_height S_maxidx (FreshVar maxidx)).
                  (* proof of assert *)
                   simpl.
                   rewrite HeqS_maxidx.
                   apply lt_n_Sn.

               assert(H_valid_ex_bs: valid_bindings instk_height S_maxidx ((maxidx, SymMLOAD soffset (U_MSTORE sstack_val soffset' svalue :: smem')) :: sb) ops).
                   (* proof of assert *)
                   rewrite HeqS_maxidx.
                   simpl.
                   split; try auto.
                   
                
                   pose proof (eval_sstack_val'_succ (S S_maxidx) instk_height (FreshVar maxidx) stk mem strg ctx S_maxidx ((maxidx, SymMLOAD soffset (U_MSTORE sstack_val soffset' svalue :: smem')) :: sb) ops (eq_sym H_stk_len) H_valid_freshvar_maxidx H_valid_ex_bs (gt_Sn_n S_maxidx)) as H_eval_freshvar_maxidx.
                   destruct H_eval_freshvar_maxidx as [v H_eval_freshvar_maxidx].
                   exists v.
                   split; apply H_eval_freshvar_maxidx.
                    
    (* MSTIRE8 -- copy of the previous one with changes that replace MSTORE by MSTORE8*)
    ++ destruct (memory_slots_do_not_overlap soffset soffset' 31 0) eqn:E_not_overlap.
       +++ destruct m as [maxidx sb] eqn:E_m.
          simpl in H_valid_smem.
          destruct H_valid_smem as [[H_valid_soffset' H_valid_svalue] H_valid_smem'].

          simpl.
          exists maxidx.
          exists (SymMap (S maxidx) ((maxidx, SymMLOAD soffset (U_MSTORE8 sstack_val soffset' svalue :: smem')) :: sb)).
          split; try reflexivity.

          intros stk mem strg ctx H_stk_len.

          pose proof (IHsmem' H_valid_smem' H_basic_mload_solver) as IHsmem'_0.
          destruct IHsmem'_0 as [idx2 [m2 [H_add_to_smap' IHsmem'_0]]].
          pose proof (IHsmem'_0 stk mem strg ctx H_stk_len) as IHsmem'_1.
          destruct IHsmem'_1 as [v' [H_eval_freshvar_idx1 H_eval_fresh_var_maxidx]].
          exists v'.
          split; auto.
          simpl.

          unfold eval_sstack_val.
          remember (S maxidx) as S_maxidx.
          unfold eval_sstack_val'.
          fold eval_sstack_val'.
          unfold follow_in_smap.
          rewrite Nat.eqb_refl.
          simpl.
 
          pose proof (H_memory_slots_do_not_overlap soffset soffset' 31 0 maxidx sb instk_height ops H_valid_smap H_valid_soffset H_valid_soffset' E_not_overlap stk mem strg ctx H_stk_len) as H_memory_slots_do_not_overlap_0.
          destruct H_memory_slots_do_not_overlap_0 as [v1' [v2' [H_eval_soffset_bis [H_eval_soffset' H_not_overlap]]]].
          rewrite HeqS_maxidx.
                
          rewrite H_eval_soffset'.
          pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue stk mem strg ctx maxidx sb ops (eq_sym H_stk_len) H_valid_svalue H_valid_smap (gt_Sn_n maxidx)) as H_eval_svalue.
          destruct H_eval_svalue as [svalue_v H_eval_svalue].
          rewrite H_eval_svalue.
          
          pose proof (H_map_o_smem instk_height (S maxidx) stk mem strg ctx maxidx sb ops smem' H_valid_smem' H_valid_smap (gt_Sn_n maxidx) (eq_sym H_stk_len)) as H_mo_1.
          destruct H_mo_1 as [v''' H_mo_1].
          rewrite H_mo_1.
                
          rewrite H_eval_soffset_bis.

          unfold concrete_interpreter.ConcreteInterpreter.mload.
          unfold concrete_interpreter.ConcreteInterpreter.mload'.

          pose proof (do_not_overlap_mload_0 mem v1' v2' svalue_v v''' H_not_overlap) as H_do_not_overlap_mload.
          rewrite H_do_not_overlap_mload.
                
          simpl in H_add_to_smap'.
          injection H_add_to_smap' as H_idx2 H_m2.
          rewrite <- H_m2 in H_eval_fresh_var_maxidx.
          rewrite <- H_idx2 in H_eval_fresh_var_maxidx.
          simpl in H_eval_fresh_var_maxidx.

          unfold eval_sstack_val in H_eval_fresh_var_maxidx.
          rewrite <- HeqS_maxidx in H_eval_fresh_var_maxidx.
          unfold eval_sstack_val' in H_eval_fresh_var_maxidx.
          fold eval_sstack_val' in H_eval_fresh_var_maxidx.
          unfold follow_in_smap in H_eval_fresh_var_maxidx.
          rewrite Nat.eqb_refl in H_eval_fresh_var_maxidx.
          simpl in H_eval_fresh_var_maxidx.
          destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' S_maxidx sv stk mem strg ctx maxidx sb ops)) smem') as [smem_updates|] eqn:E_mo_1; try discriminate.
                
                
          rewrite HeqS_maxidx in H_eval_fresh_var_maxidx.
          rewrite H_eval_soffset_bis in H_eval_fresh_var_maxidx.
          injection H_eval_fresh_var_maxidx as H_v'.
          unfold concrete_interpreter.ConcreteInterpreter.mload in H_v'.
          unfold concrete_interpreter.ConcreteInterpreter.mload' in H_v'.
          rewrite HeqS_maxidx in E_mo_1.
          rewrite E_mo_1 in H_mo_1.
          injection H_mo_1 as H_mo_1.
          rewrite <- H_mo_1.
          rewrite <- H_v'.
          reflexivity.
       +++ destruct m as [maxidx sb] eqn:E_m. 
           simpl.
           exists maxidx.
           exists (SymMap (S maxidx) ((maxidx, SymMLOAD soffset (U_MSTORE8 sstack_val soffset' svalue :: smem')) :: sb)).
           split; try reflexivity.
           intros stk mem strg ctx.
           intros H_stk_len.
           simpl.
           rewrite <- H_basic_mload_solver in H_add_to_smap.
           simpl in H_add_to_smap.
           injection H_add_to_smap as H_idx1 H_m1.
           rewrite <- H_m1.
           simpl.
           rewrite <- H_idx1.
                
           unfold eval_sstack_val.
           remember (S maxidx) as S_maxidx.

           assert(H_valid_freshvar_maxidx: valid_sstack_value instk_height S_maxidx (FreshVar maxidx)).
             (* proof of assert *)
             simpl.
             rewrite HeqS_maxidx.
             apply lt_n_Sn.

          assert(H_valid_ex_bs: valid_bindings instk_height S_maxidx ((maxidx, SymMLOAD soffset (U_MSTORE8 sstack_val soffset' svalue :: smem')) :: sb) ops).
            (* proof of assert *)
            rewrite HeqS_maxidx.
            simpl.
            split; try auto.
                   
                
            pose proof (eval_sstack_val'_succ (S S_maxidx) instk_height (FreshVar maxidx) stk mem strg ctx S_maxidx ((maxidx, SymMLOAD soffset (U_MSTORE8 sstack_val soffset' svalue :: smem')) :: sb) ops (eq_sym H_stk_len) H_valid_freshvar_maxidx H_valid_ex_bs (gt_Sn_n S_maxidx)) as H_eval_freshvar_maxidx.
            destruct H_eval_freshvar_maxidx as [v H_eval_freshvar_maxidx].
            exists v.
            split; apply H_eval_freshvar_maxidx.
Qed.


  Lemma basic_smemory_updater_remove_mstore_dups_valid:
    forall sstack_val_cmp soffset instk_height m ops smem smem_r,
      symbolic_state_cmp.SymbolicStateCmp.safe_sstack_val_cmp_ext_1 sstack_val_cmp ->
      valid_sstack_value instk_height (get_maxidx_smap m) soffset ->
      valid_smemory instk_height (get_maxidx_smap m) smem ->
      basic_smemory_updater_remove_mstore_dups sstack_val_cmp soffset smem instk_height m ops = smem_r ->
      valid_smemory instk_height (get_maxidx_smap m) smem_r.
  Proof.
    intros sstack_val_cmp soffset instk_height m ops.
    induction smem as [| u smem' IHsmem'].
    + intros smem_r H_sstack_val_cmp_snd H_valid_soffset H_valid_smem H_basic_smem_updater_remove_dups.
      simpl in H_basic_smem_updater_remove_dups.
      rewrite <- H_basic_smem_updater_remove_dups.
      reflexivity.
    + intros smem_r H_sstack_val_cmp_snd H_valid_soffset H_valid_smem H_basic_smem_updater_remove_dups.
      unfold basic_smemory_updater_remove_mstore_dups in H_basic_smem_updater_remove_dups.
      fold basic_smemory_updater_remove_mstore_dups in H_basic_smem_updater_remove_dups.
      destruct u as [soffset' svalue|soffset' svalue] eqn:E_u.
      ++ destruct (sstack_val_cmp (S (get_maxidx_smap m)) soffset soffset' (get_maxidx_smap m) (get_bindings_smap m) (get_maxidx_smap m) (get_bindings_smap m) instk_height ops) eqn:E_cmp_soffset_soffset'.
         +++ apply IHsmem'.
             ++++ apply H_sstack_val_cmp_snd.
             ++++ apply H_valid_soffset.
             ++++ apply H_valid_smem.
             ++++ apply H_basic_smem_updater_remove_dups.
         +++ destruct smem_r as [|u_r smem_r']; try discriminate.
             injection H_basic_smem_updater_remove_dups as H_u_r H_smem_r'.
             simpl.
             split.
             ++++ rewrite <- H_u_r.
                  simpl.
                  split; apply H_valid_smem.
             ++++ apply IHsmem'.
                  +++++ apply H_sstack_val_cmp_snd.
                  +++++ apply H_valid_soffset.
                  +++++ apply H_valid_smem.
                  +++++ apply H_smem_r'.
      ++ destruct (mstore8_is_included_in_mstore soffset' soffset) eqn:E_cmp_soffset_soffset'.
         +++ apply IHsmem'.
             ++++ apply H_sstack_val_cmp_snd.
             ++++ apply H_valid_soffset.
             ++++ apply H_valid_smem.
             ++++ apply H_basic_smem_updater_remove_dups.
         +++ destruct smem_r as [|u_r smem_r']; try discriminate.
             injection H_basic_smem_updater_remove_dups as H_u_r H_smem_r'.
             simpl.
             split.
             ++++ rewrite <- H_u_r.
                  simpl.
                  split; apply H_valid_smem.
             ++++ apply IHsmem'.
                  +++++ apply H_sstack_val_cmp_snd.
                  +++++ apply H_valid_soffset.
                  +++++ apply H_valid_smem.
                  +++++ apply H_smem_r'.
  Qed.

    Lemma basic_smemory_updater_remove_mstore8_dups_valid:
    forall sstack_val_cmp soffset instk_height m ops smem smem_r,
      symbolic_state_cmp.SymbolicStateCmp.safe_sstack_val_cmp_ext_1 sstack_val_cmp ->
      valid_sstack_value instk_height (get_maxidx_smap m) soffset ->
      valid_smemory instk_height (get_maxidx_smap m) smem ->
      basic_smemory_updater_remove_mstore8_dups sstack_val_cmp soffset smem instk_height m ops = smem_r ->
      valid_smemory instk_height (get_maxidx_smap m) smem_r.
  Proof.
    intros sstack_val_cmp soffset instk_height m ops.
    induction smem as [| u smem' IHsmem'].
    + intros smem_r H_sstack_val_cmp_snd H_valid_soffset H_valid_smem H_basic_smem_updater_remove_dups.
      simpl in H_basic_smem_updater_remove_dups.
      rewrite <- H_basic_smem_updater_remove_dups.
      reflexivity.
    + intros smem_r H_sstack_val_cmp_snd H_valid_soffset H_valid_smem H_basic_smem_updater_remove_dups.
      unfold basic_smemory_updater_remove_mstore8_dups in H_basic_smem_updater_remove_dups.
      fold basic_smemory_updater_remove_mstore8_dups in H_basic_smem_updater_remove_dups.
      destruct u as [soffset' svalue|soffset' svalue] eqn:E_u.
      ++ destruct smem_r as [|u_r smem_r']; try discriminate.
         injection H_basic_smem_updater_remove_dups as H_u_r H_smem_r'.
         simpl.
         split.
         +++ rewrite <- H_u_r.
             simpl.
             split; apply H_valid_smem.
         +++ apply IHsmem'.
             ++++ apply H_sstack_val_cmp_snd.
             ++++ apply H_valid_soffset.
             ++++ apply H_valid_smem.
             ++++ apply H_smem_r'.

      ++ destruct (sstack_val_cmp (S (get_maxidx_smap m)) soffset soffset' (get_maxidx_smap m) (get_bindings_smap m) (get_maxidx_smap m) (get_bindings_smap m) instk_height ops) eqn:E_cmp_soffset_soffset'.
         +++ apply IHsmem'.
             ++++ apply H_sstack_val_cmp_snd.
             ++++ apply H_valid_soffset.
             ++++ apply H_valid_smem.
             ++++ apply H_basic_smem_updater_remove_dups.
         +++ destruct smem_r as [|u_r smem_r']; try discriminate.
             injection H_basic_smem_updater_remove_dups as H_u_r H_smem_r'.
             simpl.
             split.
             ++++ rewrite <- H_u_r.
                  simpl.
                  split; apply H_valid_smem.
             ++++ apply IHsmem'.
                  +++++ apply H_sstack_val_cmp_snd.
                  +++++ apply H_valid_soffset.
                  +++++ apply H_valid_smem.
                  +++++ apply H_smem_r'.
  Qed.

  Lemma basic_smemory_updater_valid: 
    forall sstack_val_cmp : symbolic_state_cmp.SymbolicStateCmp.sstack_val_cmp_ext_1_t,
      symbolic_state_cmp.SymbolicStateCmp.safe_sstack_val_cmp_ext_1 sstack_val_cmp ->
      smemory_updater_valid_res (basic_smemory_updater sstack_val_cmp).
  Proof.
    intros sstack_val_cmp H_sstack_val_cmp_snd.
    unfold smemory_updater_valid_res.
    intros m smem smem' u instk_height ops.
    intros H_valid_smem H_valid_u H_basic_smem_updater.
    unfold basic_smemory_updater in H_basic_smem_updater.
    destruct u as [soffset svalue|soffset svalue] eqn:E_u.
    + destruct smem' as [|u' smem'']; try discriminate.
      injection H_basic_smem_updater as H_u' H_smem''.
      rewrite <- H_u'.
      simpl.
      split; try split; try apply H_valid_u.
      apply basic_smemory_updater_remove_mstore_dups_valid in H_smem''.
    
      ++ apply H_smem''.
      ++ apply H_sstack_val_cmp_snd.
      ++ apply H_valid_u.
      ++ apply H_valid_smem.
    + destruct smem' as [|u' smem'']; try discriminate.
      injection H_basic_smem_updater as H_u' H_smem''.
      rewrite <- H_u'.
      simpl.
      split; try split; try apply H_valid_u.
      apply basic_smemory_updater_remove_mstore8_dups_valid in H_smem''.
    
      ++ apply H_smem''.
      ++ apply H_sstack_val_cmp_snd.
      ++ apply H_valid_u.
      ++ apply H_valid_smem.
   Qed. 


  
  Lemma basic_smemory_updater_remove_dups_correct_eq_key:
    forall sstack_val_cmp soffset svalue instk_height stk mem strg ctx m ops smem1 smem2 mem1 mem2 v,
      symbolic_state_cmp.SymbolicStateCmp.safe_sstack_val_cmp_ext_1 sstack_val_cmp ->
      length stk = instk_height ->
      valid_sstack_value instk_height (get_maxidx_smap m) soffset ->
      valid_sstack_value instk_height (get_maxidx_smap m) svalue ->
      valid_smap instk_height (get_maxidx_smap m) (get_bindings_smap m) ops ->
      valid_smemory instk_height (get_maxidx_smap m) smem1 ->
      valid_smemory instk_height (get_maxidx_smap m) smem2 ->
      eval_smemory (U_MSTORE sstack_val soffset svalue :: smem1) (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops = Some mem1 ->
      eval_smemory (U_MSTORE sstack_val soffset svalue :: smem2) (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops = Some mem2 ->
      eval_sstack_val' (S (get_maxidx_smap m)) soffset stk mem strg ctx (get_maxidx_smap m)  (get_bindings_smap m) ops = Some v ->
      concrete_interpreter.ConcreteInterpreter.mload mem1 v = concrete_interpreter.ConcreteInterpreter.mload mem2 v.
  Proof.
    intros sstack_val_cmp soffset svalue instk_height stk mem strg ctx m ops smem1 smem2 mem1 mem2 v.
    intros H_sstack_val_cmp_snd H_stk_len H_valid_soffset H_valid_svalue H_valid_smap H_valid_smem1 H_valid_smem2 H_eval_smem1 H_eval_smem2 H_eval_soffset.

    unfold eval_smemory in H_eval_smem1.
    destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) (U_MSTORE sstack_val soffset svalue :: smem1)) as [updates1|] eqn:E_mo_1; try discriminate.
    injection H_eval_smem1 as H_mem1.

    unfold eval_smemory in H_eval_smem2.
    destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) (U_MSTORE sstack_val soffset svalue :: smem2)) as [updates2|] eqn:E_mo_2; try discriminate.
    injection H_eval_smem2 as H_mem2.
    

    pose proof (map_option_split (memory_update sstack_val) (memory_update EVMWord) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) smem1 updates1 (U_MSTORE sstack_val soffset svalue) E_mo_1) as E_mo_1_0.
    destruct E_mo_1_0 as [e1 [updates1' [E_updates1 [E_e1 H_mo_1_0]]]].

    pose proof (map_option_split (memory_update sstack_val) (memory_update EVMWord) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) smem2 updates2 (U_MSTORE sstack_val soffset svalue) E_mo_2) as E_mo_2_0.
    destruct E_mo_2_0 as [e2 [updates2' [E_updates2 [E_e2 H_mo_2_0]]]].


    unfold eval_common.EvalCommon.instantiate_memory_update in E_e1.
    unfold eval_sstack_val in E_e1.
    rewrite H_eval_soffset in E_e1.
    destruct (eval_sstack_val' (S (get_maxidx_smap m)) svalue stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops) as [svalue_v|] eqn:H_eval_svalue; try discriminate.
    injection E_e1 as E_e1.
    
    unfold eval_common.EvalCommon.instantiate_memory_update in E_e2.
    unfold eval_sstack_val in E_e2.
    rewrite H_eval_soffset in E_e2.
    rewrite H_eval_svalue in E_e2.
    injection E_e2 as E_e2.
    
    rewrite <- H_mem1.
    rewrite <- H_mem2.
    rewrite E_updates1.
    rewrite E_updates2.
    rewrite <- E_e1.
    rewrite <- E_e2.

    unfold eval_common.EvalCommon.update_memory.
    fold eval_common.EvalCommon.update_memory.
    unfold eval_common.EvalCommon.update_memory'.
    
    repeat rewrite mload_mstore_same_address.
    reflexivity.
  Qed.
    
  
    Lemma basic_smemory_updater_remove_mstore_dups_correct:
    forall sstack_val_cmp soffset svalue instk_height stk mem strg ctx m ops,
      symbolic_state_cmp.SymbolicStateCmp.safe_sstack_val_cmp_ext_1 sstack_val_cmp ->
      length stk = instk_height ->
      valid_sstack_value instk_height (get_maxidx_smap m) soffset ->
      valid_sstack_value instk_height (get_maxidx_smap m) svalue ->
      valid_smap instk_height (get_maxidx_smap m) (get_bindings_smap m) ops ->
      forall smem smem_r,
      valid_smemory instk_height (get_maxidx_smap m) smem ->
      basic_smemory_updater_remove_mstore_dups sstack_val_cmp soffset smem instk_height m ops = smem_r ->
      exists mem1 mem2,
        eval_smemory (U_MSTORE sstack_val soffset svalue :: smem) (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops =
          Some mem1 /\
          eval_smemory (U_MSTORE sstack_val soffset svalue :: smem_r) (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops = Some mem2 /\
          forall w, mem1 w = mem2 w.
    Proof.
      intros sstack_val_cmp soffset svalue instk_height stk mem strg ctx m ops.
      intros H_sstack_val_cmp_snd H_stk_len H_valid_soffset H_valid_svalue H_valid_smap.
 
      induction smem as [|u smem' IHsmem'].
      + intros smem_r H_valid_smem H_basic_mstore_up.
        simpl in H_basic_mstore_up.
        rewrite <- H_basic_mstore_up.
        assert(H_valid_u: valid_smemory instk_height (get_maxidx_smap m)  [U_MSTORE sstack_val soffset svalue]). simpl. auto.
        pose proof (eval_smemory_succ instk_height (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops [U_MSTORE sstack_val soffset svalue] (eq_sym H_stk_len) H_valid_u H_valid_smap) as H_eval_u.
        destruct H_eval_u as [smem' H_eval_u].
        rewrite H_eval_u.
        exists smem'.
        exists smem'.
        auto.
      + intros smem_r H_valid_smem H_basic_mstore_up.
        simpl in H_basic_mstore_up.
        destruct u as [soffset' svalue'|soffset' svalue'] eqn:E_u.
        (* MSTORE *)
        ++ simpl in H_valid_smem.
           destruct H_valid_smem as [ [H_valid_soffset' H_valid_svalue'] H_valid_smem'].
           destruct (sstack_val_cmp (S (get_maxidx_smap m)) soffset soffset' (get_maxidx_smap m) (get_bindings_smap m) (get_maxidx_smap m) (get_bindings_smap m) instk_height ops) eqn:E_cmp_soffset_soffset'.
           +++ pose proof (IHsmem' smem_r H_valid_smem' H_basic_mstore_up) as IHsmem'_0.       
               destruct IHsmem'_0 as [mem1' [mem2' [IHsmem'_0_1 [IHsmem'_0_2 IHsmem'_0_3]]]].
               unfold safe_sstack_val_cmp_ext_1_d in H_sstack_val_cmp_snd.
               unfold safe_sstack_val_cmp in H_sstack_val_cmp_snd.
               pose proof (H_sstack_val_cmp_snd (S (get_maxidx_smap m)) (S (get_maxidx_smap m)) (Nat.le_refl (S (get_maxidx_smap m))) soffset soffset' (get_maxidx_smap m) (get_bindings_smap m) (get_maxidx_smap m) (get_bindings_smap m) instk_height ops H_valid_soffset H_valid_soffset' H_valid_smap H_valid_smap E_cmp_soffset_soffset' stk mem strg ctx H_stk_len) as H_eq_soffset_soffset'.
               destruct H_eq_soffset_soffset' as [soffset_v [ H_eval_soffset H_eval_soffset']].

               pose proof (two_consecutive_updates_same_address soffset soffset' svalue svalue' smem' (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops soffset_v H_eval_soffset H_eval_soffset') as H_remove_soffset'.
               rewrite H_remove_soffset'.

               rewrite IHsmem'_0_1.
               rewrite IHsmem'_0_2.

               exists mem1'.
               exists mem2'.
               
               repeat split; try reflexivity.
               apply IHsmem'_0_3.
           +++ rewrite <- H_basic_mstore_up. 

               remember (basic_smemory_updater_remove_mstore_dups sstack_val_cmp soffset smem' instk_height m ops) as smem'_r.
               rewrite Heqsmem'_r in *.
               symmetry in Heqsmem'_r.
               rewrite Heqsmem'_r.
               
               pose proof (IHsmem' smem'_r H_valid_smem' Heqsmem'_r) as IHsmem'_0.
               destruct IHsmem'_0 as [mem1' [mem2' [H_eval_u_smem' [H_eval_u_smem'_r H_eq_mem1'_mem2']]]].
               apply functional_extensionality in H_eq_mem1'_mem2' as H_eq_mem1'_mem2'_f.

               pose proof (eval_sstack_val'_succ (S (get_maxidx_smap m)) instk_height soffset stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops (eq_sym H_stk_len) H_valid_soffset H_valid_smap (gt_Sn_n ((get_maxidx_smap m)))) as H_eval_soffset.
               destruct H_eval_soffset as [soffset_v H_eval_soffset].
               
               pose proof (eval_sstack_val'_succ (S (get_maxidx_smap m)) instk_height soffset' stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops (eq_sym H_stk_len) H_valid_soffset' H_valid_smap (gt_Sn_n ((get_maxidx_smap m)))) as H_eval_soffset'.
               destruct H_eval_soffset' as [soffset'_v H_eval_soffset'].

               pose proof (eval_sstack_val'_succ (S (get_maxidx_smap m)) instk_height svalue stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops (eq_sym H_stk_len) H_valid_svalue H_valid_smap (gt_Sn_n ((get_maxidx_smap m)))) as H_eval_svalue.
               destruct H_eval_svalue as [svlaue_v H_eval_svalue].

               pose proof (eval_sstack_val'_succ (S (get_maxidx_smap m)) instk_height svalue' stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops (eq_sym H_stk_len) H_valid_svalue' H_valid_smap (gt_Sn_n ((get_maxidx_smap m)))) as H_eval_svalue'.
               destruct H_eval_svalue' as [svlaue_v' H_eval_svalue'].

               unfold eval_smemory.
               unfold map_option.
               repeat rewrite <- map_option_ho.

               unfold eval_common.EvalCommon.instantiate_memory_update at 1.
               unfold eval_sstack_val.
               rewrite H_eval_soffset.
               rewrite H_eval_svalue.

               unfold eval_common.EvalCommon.instantiate_memory_update at 1.
               unfold eval_sstack_val.
               rewrite H_eval_soffset'.
               rewrite H_eval_svalue'.
              
               unfold eval_common.EvalCommon.instantiate_memory_update at 2.
               rewrite H_eval_soffset.
               rewrite H_eval_svalue.

               unfold eval_common.EvalCommon.instantiate_memory_update at 2.
               unfold eval_sstack_val.
               rewrite H_eval_soffset'.
               rewrite H_eval_svalue'.

               unfold eval_smemory in H_eval_u_smem'.
               unfold eval_sstack_val in  H_eval_u_smem'.
               

               destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val'  (S (get_maxidx_smap m)) sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) (U_MSTORE sstack_val soffset svalue :: smem')) as [updates1|] eqn:E_mo_1; try discriminate.
               pose proof (map_option_split (memory_update sstack_val) (memory_update EVMWord) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' (S (get_maxidx_smap m)) sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) smem' updates1 (U_MSTORE sstack_val soffset svalue) E_mo_1) as E_mo_1_split.
               destruct E_mo_1_split as [e1 [smem'' [E_updates_1 [E_mo_1_0 E_mo_1_1]]]].
               rewrite E_mo_1_1.

               unfold eval_smemory in H_eval_u_smem'_r.
               unfold eval_sstack_val in  H_eval_u_smem'_r.
               destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val'  (S (get_maxidx_smap m)) sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) (U_MSTORE sstack_val soffset svalue :: smem'_r)) as [updates2|] eqn:E_mo_2; try discriminate.
               pose proof (map_option_split (memory_update sstack_val) (memory_update EVMWord) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' (S (get_maxidx_smap m)) sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) smem'_r updates2 (U_MSTORE sstack_val soffset svalue) E_mo_2) as E_mo_2_split.
               destruct E_mo_2_split as [e2 [smem'_r' [E_updates_2 [E_mo_2_0 E_mo_2_1]]]].
               rewrite E_mo_2_1.

               exists (eval_common.EvalCommon.update_memory mem (U_MSTORE EVMWord soffset_v svlaue_v :: U_MSTORE EVMWord soffset'_v svlaue_v' :: smem'')).
               exists (eval_common.EvalCommon.update_memory mem (U_MSTORE EVMWord soffset_v svlaue_v :: U_MSTORE EVMWord soffset'_v svlaue_v' :: smem'_r')).
	       split. reflexivity.
               split. reflexivity.
               intro w.
               
               unfold eval_common.EvalCommon.update_memory.
               fold eval_common.EvalCommon.update_memory.

               unfold eval_common.EvalCommon.instantiate_memory_update in E_mo_1_0.
               rewrite H_eval_soffset in E_mo_1_0.
               rewrite H_eval_svalue in E_mo_1_0.
               injection E_mo_1_0 as E_e1.
               
               unfold eval_common.EvalCommon.instantiate_memory_update in E_mo_2_0.
               rewrite H_eval_soffset in E_mo_2_0.
               rewrite H_eval_svalue in E_mo_2_0.
               injection E_mo_2_0 as E_e2.

               rewrite E_updates_1 in H_eval_u_smem'.
               unfold eval_common.EvalCommon.update_memory in H_eval_u_smem'.
               fold eval_common.EvalCommon.update_memory in H_eval_u_smem'.
               injection H_eval_u_smem' as H_eval_u_smem'.

               rewrite E_updates_2 in H_eval_u_smem'_r.
               unfold eval_common.EvalCommon.update_memory in H_eval_u_smem'_r.
               fold eval_common.EvalCommon.update_memory in H_eval_u_smem'_r.
               injection H_eval_u_smem'_r as H_eval_u_smem'_r.
               rewrite H_eq_mem1'_mem2'_f in H_eval_u_smem'.
               rewrite <- H_eval_u_smem'_r in H_eval_u_smem'.

               rewrite <- E_e1 in H_eval_u_smem'.
               rewrite <- E_e2 in H_eval_u_smem'.

               apply mem_eq_when_after_update_eq in H_eval_u_smem'.
               rewrite H_eval_u_smem'.
               reflexivity.

        (* MSTOR8 *)
        ++ simpl in H_valid_smem.
           destruct H_valid_smem as [ [H_valid_soffset' H_valid_svalue'] H_valid_smem'].
           destruct (mstore8_is_included_in_mstore soffset' soffset) eqn:E_mstore8_inc.
           +++ pose proof (IHsmem' smem_r H_valid_smem' H_basic_mstore_up) as IHsmem'_0.
               destruct IHsmem'_0 as [mem1' [mem2' [IHsmem'_0_1 [IHsmem'_0_2 IHsmem'_0_3]]]].


               pose proof (H_mstore8_is_included_in_mstore soffset' soffset (get_maxidx_smap m) (get_bindings_smap m) instk_height ops H_valid_smap H_valid_soffset' H_valid_soffset E_mstore8_inc stk mem strg ctx H_stk_len) as E_mstore8_not_inc.
               destruct E_mstore8_not_inc as [soffset'_v [soffset_v [H_eval_soffset' [H_eval_soffset H_addr_inc]]]].
               
               pose proof (two_consecutive_updates_same_address_mstore8 soffset' soffset svalue' svalue smem' (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops soffset'_v soffset_v H_eval_soffset' H_eval_soffset H_addr_inc) as H_remove_soffset'.

               rewrite H_remove_soffset'.

               rewrite IHsmem'_0_1.
               rewrite IHsmem'_0_2.

               exists mem1'.
               exists mem2'.
               
               repeat split; try reflexivity.
               apply IHsmem'_0_3.

           +++ rewrite <- H_basic_mstore_up. 

               remember (basic_smemory_updater_remove_mstore_dups sstack_val_cmp soffset smem' instk_height m ops) as smem'_r.
               rewrite Heqsmem'_r in *.
               symmetry in Heqsmem'_r.
               rewrite Heqsmem'_r.
               
               pose proof (IHsmem' smem'_r H_valid_smem' Heqsmem'_r) as IHsmem'_0.
               destruct IHsmem'_0 as [mem1' [mem2' [H_eval_u_smem' [H_eval_u_smem'_r H_eq_mem1'_mem2']]]].
               apply functional_extensionality in H_eq_mem1'_mem2' as H_eq_mem1'_mem2'_f.

               pose proof (eval_sstack_val'_succ (S (get_maxidx_smap m)) instk_height soffset stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops (eq_sym H_stk_len) H_valid_soffset H_valid_smap (gt_Sn_n ((get_maxidx_smap m)))) as H_eval_soffset.
               destruct H_eval_soffset as [soffset_v H_eval_soffset].
               
               pose proof (eval_sstack_val'_succ (S (get_maxidx_smap m)) instk_height soffset' stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops (eq_sym H_stk_len) H_valid_soffset' H_valid_smap (gt_Sn_n ((get_maxidx_smap m)))) as H_eval_soffset'.
               destruct H_eval_soffset' as [soffset'_v H_eval_soffset'].

               pose proof (eval_sstack_val'_succ (S (get_maxidx_smap m)) instk_height svalue stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops (eq_sym H_stk_len) H_valid_svalue H_valid_smap (gt_Sn_n ((get_maxidx_smap m)))) as H_eval_svalue.
               destruct H_eval_svalue as [svlaue_v H_eval_svalue].

               pose proof (eval_sstack_val'_succ (S (get_maxidx_smap m)) instk_height svalue' stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops (eq_sym H_stk_len) H_valid_svalue' H_valid_smap (gt_Sn_n ((get_maxidx_smap m)))) as H_eval_svalue'.
               destruct H_eval_svalue' as [svlaue_v' H_eval_svalue'].

               unfold eval_smemory.
               unfold map_option.
               repeat rewrite <- map_option_ho.

               unfold eval_common.EvalCommon.instantiate_memory_update at 1.
               unfold eval_sstack_val.
               rewrite H_eval_soffset.
               rewrite H_eval_svalue.

               unfold eval_common.EvalCommon.instantiate_memory_update at 1.
               unfold eval_sstack_val.
               rewrite H_eval_soffset'.
               rewrite H_eval_svalue'.
              
               unfold eval_common.EvalCommon.instantiate_memory_update at 2.
               rewrite H_eval_soffset.
               rewrite H_eval_svalue.

               unfold eval_common.EvalCommon.instantiate_memory_update at 2.
               unfold eval_sstack_val.
               rewrite H_eval_soffset'.
               rewrite H_eval_svalue'.

               unfold eval_smemory in H_eval_u_smem'.
               unfold eval_sstack_val in  H_eval_u_smem'.
               

               destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val'  (S (get_maxidx_smap m)) sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) (U_MSTORE sstack_val soffset svalue :: smem')) as [updates1|] eqn:E_mo_1; try discriminate.
               pose proof (map_option_split (memory_update sstack_val) (memory_update EVMWord) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' (S (get_maxidx_smap m)) sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) smem' updates1 (U_MSTORE sstack_val soffset svalue) E_mo_1) as E_mo_1_split.
               destruct E_mo_1_split as [e1 [smem'' [E_updates_1 [E_mo_1_0 E_mo_1_1]]]].
               rewrite E_mo_1_1.

               unfold eval_smemory in H_eval_u_smem'_r.
               unfold eval_sstack_val in  H_eval_u_smem'_r.
               destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val'  (S (get_maxidx_smap m)) sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) (U_MSTORE sstack_val soffset svalue :: smem'_r)) as [updates2|] eqn:E_mo_2; try discriminate.
               pose proof (map_option_split (memory_update sstack_val) (memory_update EVMWord) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' (S (get_maxidx_smap m)) sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) smem'_r updates2 (U_MSTORE sstack_val soffset svalue) E_mo_2) as E_mo_2_split.
               destruct E_mo_2_split as [e2 [smem'_r' [E_updates_2 [E_mo_2_0 E_mo_2_1]]]].
               rewrite E_mo_2_1.

               exists (eval_common.EvalCommon.update_memory mem (U_MSTORE EVMWord soffset_v svlaue_v :: U_MSTORE8 EVMWord soffset'_v svlaue_v' :: smem'')).
               exists (eval_common.EvalCommon.update_memory mem (U_MSTORE EVMWord soffset_v svlaue_v :: U_MSTORE8 EVMWord soffset'_v svlaue_v' :: smem'_r')).
	       split. reflexivity.
               split. reflexivity.
               intro w.
               
               unfold eval_common.EvalCommon.update_memory.
               fold eval_common.EvalCommon.update_memory.

               unfold eval_common.EvalCommon.instantiate_memory_update in E_mo_1_0.
               rewrite H_eval_soffset in E_mo_1_0.
               rewrite H_eval_svalue in E_mo_1_0.
               injection E_mo_1_0 as E_e1.
               
               unfold eval_common.EvalCommon.instantiate_memory_update in E_mo_2_0.
               rewrite H_eval_soffset in E_mo_2_0.
               rewrite H_eval_svalue in E_mo_2_0.
               injection E_mo_2_0 as E_e2.

               rewrite E_updates_1 in H_eval_u_smem'.
               unfold eval_common.EvalCommon.update_memory in H_eval_u_smem'.
               fold eval_common.EvalCommon.update_memory in H_eval_u_smem'.
               injection H_eval_u_smem' as H_eval_u_smem'.

               rewrite E_updates_2 in H_eval_u_smem'_r.
               unfold eval_common.EvalCommon.update_memory in H_eval_u_smem'_r.
               fold eval_common.EvalCommon.update_memory in H_eval_u_smem'_r.
               injection H_eval_u_smem'_r as H_eval_u_smem'_r.
               rewrite H_eq_mem1'_mem2'_f in H_eval_u_smem'.
               rewrite <- H_eval_u_smem'_r in H_eval_u_smem'.

               rewrite <- E_e1 in H_eval_u_smem'.
               rewrite <- E_e2 in H_eval_u_smem'.

               apply mem_eq_when_after_update_eq in H_eval_u_smem'.
               rewrite H_eval_u_smem'.
               reflexivity.
Qed.



    Lemma basic_smemory_updater_remove_mstore8_dups_correct:
      forall sstack_val_cmp soffset svalue instk_height stk mem strg ctx m ops,
        symbolic_state_cmp.SymbolicStateCmp.safe_sstack_val_cmp_ext_1 sstack_val_cmp ->
        length stk = instk_height ->
        valid_sstack_value instk_height (get_maxidx_smap m) soffset ->
        valid_sstack_value instk_height (get_maxidx_smap m) svalue ->
        valid_smap instk_height (get_maxidx_smap m) (get_bindings_smap m) ops ->
        forall smem smem',
          valid_smemory instk_height (get_maxidx_smap m) smem ->
          basic_smemory_updater_remove_mstore8_dups sstack_val_cmp soffset smem instk_height m ops = smem' ->
          exists mem1 mem2,
            eval_smemory (U_MSTORE8 sstack_val soffset svalue :: smem) (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops =
          Some mem1 /\
              eval_smemory (U_MSTORE8 sstack_val soffset svalue :: smem') (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops = Some mem2 /\
              forall w, mem1 w = mem2 w.
    Proof.
      intros sstack_val_cmp soffset svalue instk_height stk mem strg ctx m ops.
      intros H_sstack_val_cmp_snd H_stk_len H_valid_soffset H_valid_svalue H_valid_smap.
 
      induction smem as [|u smem' IHsmem'].
      + intros smem_r H_valid_smem H_basic_mstore_up.
        simpl in H_basic_mstore_up.
        rewrite <- H_basic_mstore_up.
        assert(H_valid_u: valid_smemory instk_height (get_maxidx_smap m)  [U_MSTORE sstack_val soffset svalue]). simpl. auto.
        pose proof (eval_smemory_succ instk_height (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops [U_MSTORE8 sstack_val soffset svalue] (eq_sym H_stk_len) H_valid_u H_valid_smap) as H_eval_u.
        destruct H_eval_u as [smem' H_eval_u].
        rewrite H_eval_u.
        exists smem'.
        exists smem'.
        auto.
      + intros smem_r H_valid_smem H_basic_mstore_up.
        simpl in H_basic_mstore_up.
        destruct u as [soffset' svalue'|soffset' svalue'] eqn:E_u.
        (* MSTORE *)
        ++ simpl in H_valid_smem.
           destruct H_valid_smem as [ [H_valid_soffset' H_valid_svalue'] H_valid_smem'].

           rewrite <- H_basic_mstore_up. 

           remember (basic_smemory_updater_remove_mstore8_dups sstack_val_cmp soffset smem' instk_height m ops) as smem'_r.
           rewrite Heqsmem'_r in *.
           symmetry in Heqsmem'_r.
           rewrite Heqsmem'_r.
               
           pose proof (IHsmem' smem'_r H_valid_smem' Heqsmem'_r) as IHsmem'_0.
           destruct IHsmem'_0 as [mem1' [mem2' [H_eval_u_smem' [H_eval_u_smem'_r H_eq_mem1'_mem2']]]].
           apply functional_extensionality in H_eq_mem1'_mem2' as H_eq_mem1'_mem2'_f.
           
           pose proof (eval_sstack_val'_succ (S (get_maxidx_smap m)) instk_height soffset stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops (eq_sym H_stk_len) H_valid_soffset H_valid_smap (gt_Sn_n ((get_maxidx_smap m)))) as H_eval_soffset.
           destruct H_eval_soffset as [soffset_v H_eval_soffset].
           
           pose proof (eval_sstack_val'_succ (S (get_maxidx_smap m)) instk_height soffset' stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops (eq_sym H_stk_len) H_valid_soffset' H_valid_smap (gt_Sn_n ((get_maxidx_smap m)))) as H_eval_soffset'.
           destruct H_eval_soffset' as [soffset'_v H_eval_soffset'].
           
           pose proof (eval_sstack_val'_succ (S (get_maxidx_smap m)) instk_height svalue stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops (eq_sym H_stk_len) H_valid_svalue H_valid_smap (gt_Sn_n ((get_maxidx_smap m)))) as H_eval_svalue.
           destruct H_eval_svalue as [svlaue_v H_eval_svalue].
           
           pose proof (eval_sstack_val'_succ (S (get_maxidx_smap m)) instk_height svalue' stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops (eq_sym H_stk_len) H_valid_svalue' H_valid_smap (gt_Sn_n ((get_maxidx_smap m)))) as H_eval_svalue'.
           destruct H_eval_svalue' as [svlaue_v' H_eval_svalue'].
           
           unfold eval_smemory.
           unfold map_option.
           repeat rewrite <- map_option_ho.
           
           unfold eval_common.EvalCommon.instantiate_memory_update at 1.
           unfold eval_sstack_val.
           rewrite H_eval_soffset.
           rewrite H_eval_svalue.
           
           unfold eval_common.EvalCommon.instantiate_memory_update at 1.
           unfold eval_sstack_val.
           rewrite H_eval_soffset'.
           rewrite H_eval_svalue'.
           
           unfold eval_common.EvalCommon.instantiate_memory_update at 2.
           rewrite H_eval_soffset.
           rewrite H_eval_svalue.
           
           unfold eval_common.EvalCommon.instantiate_memory_update at 2.
           unfold eval_sstack_val.
           rewrite H_eval_soffset'.
           rewrite H_eval_svalue'.
           
           unfold eval_smemory in H_eval_u_smem'.
           unfold eval_sstack_val in  H_eval_u_smem'.
           

           destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val'  (S (get_maxidx_smap m)) sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) (U_MSTORE8 sstack_val soffset svalue :: smem')) as [updates1|] eqn:E_mo_1; try discriminate.
           pose proof (map_option_split (memory_update sstack_val) (memory_update EVMWord) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' (S (get_maxidx_smap m)) sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) smem' updates1 (U_MSTORE8 sstack_val soffset svalue) E_mo_1) as E_mo_1_split.
           destruct E_mo_1_split as [e1 [smem'' [E_updates_1 [E_mo_1_0 E_mo_1_1]]]].
           rewrite E_mo_1_1.

           unfold eval_smemory in H_eval_u_smem'_r.
           unfold eval_sstack_val in  H_eval_u_smem'_r.
           destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val'  (S (get_maxidx_smap m)) sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) (U_MSTORE8 sstack_val soffset svalue :: smem'_r)) as [updates2|] eqn:E_mo_2; try discriminate.
           pose proof (map_option_split (memory_update sstack_val) (memory_update EVMWord) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' (S (get_maxidx_smap m)) sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) smem'_r updates2 (U_MSTORE8 sstack_val soffset svalue) E_mo_2) as E_mo_2_split.
           destruct E_mo_2_split as [e2 [smem'_r' [E_updates_2 [E_mo_2_0 E_mo_2_1]]]].
           rewrite E_mo_2_1.
           
           exists (eval_common.EvalCommon.update_memory mem (U_MSTORE8 EVMWord soffset_v svlaue_v :: U_MSTORE EVMWord soffset'_v svlaue_v' :: smem'')).
           exists (eval_common.EvalCommon.update_memory mem (U_MSTORE8 EVMWord soffset_v svlaue_v :: U_MSTORE EVMWord soffset'_v svlaue_v' :: smem'_r')).
	   split. reflexivity.
           split. reflexivity.
           intro w.
           
           unfold eval_common.EvalCommon.update_memory.
           fold eval_common.EvalCommon.update_memory.
           
           unfold eval_common.EvalCommon.instantiate_memory_update in E_mo_1_0.
           rewrite H_eval_soffset in E_mo_1_0.
           rewrite H_eval_svalue in E_mo_1_0.
           injection E_mo_1_0 as E_e1.
           
           unfold eval_common.EvalCommon.instantiate_memory_update in E_mo_2_0.
           rewrite H_eval_soffset in E_mo_2_0.
           rewrite H_eval_svalue in E_mo_2_0.
           injection E_mo_2_0 as E_e2.
           
           rewrite E_updates_1 in H_eval_u_smem'.
           unfold eval_common.EvalCommon.update_memory in H_eval_u_smem'.
           fold eval_common.EvalCommon.update_memory in H_eval_u_smem'.
           injection H_eval_u_smem' as H_eval_u_smem'.
           
           rewrite E_updates_2 in H_eval_u_smem'_r.
           unfold eval_common.EvalCommon.update_memory in H_eval_u_smem'_r.
           fold eval_common.EvalCommon.update_memory in H_eval_u_smem'_r.
           injection H_eval_u_smem'_r as H_eval_u_smem'_r.
           rewrite H_eq_mem1'_mem2'_f in H_eval_u_smem'.
           rewrite <- H_eval_u_smem'_r in H_eval_u_smem'.
           
           rewrite <- E_e1 in H_eval_u_smem'.
           rewrite <- E_e2 in H_eval_u_smem'.
           
           apply mem_eq_when_after_update_eq in H_eval_u_smem'.
           rewrite H_eval_u_smem'.
           reflexivity.
           

        (* MSTORE8 *)
        ++ simpl in H_valid_smem.
           destruct H_valid_smem as [ [H_valid_soffset' H_valid_svalue'] H_valid_smem'].
           destruct (sstack_val_cmp (S (get_maxidx_smap m)) soffset soffset' (get_maxidx_smap m) (get_bindings_smap m) (get_maxidx_smap m) (get_bindings_smap m) instk_height ops) eqn:E_cmp_soffset_soffset'.
           +++ pose proof (IHsmem' smem_r H_valid_smem' H_basic_mstore_up) as IHsmem'_0.       
               destruct IHsmem'_0 as [mem1' [mem2' [IHsmem'_0_1 [IHsmem'_0_2 IHsmem'_0_3]]]].
               unfold safe_sstack_val_cmp_ext_1_d in H_sstack_val_cmp_snd.
               unfold safe_sstack_val_cmp in H_sstack_val_cmp_snd.
               pose proof (H_sstack_val_cmp_snd (S (get_maxidx_smap m)) (S (get_maxidx_smap m)) (Nat.le_refl (S (get_maxidx_smap m))) soffset soffset' (get_maxidx_smap m) (get_bindings_smap m) (get_maxidx_smap m) (get_bindings_smap m) instk_height ops H_valid_soffset H_valid_soffset' H_valid_smap H_valid_smap E_cmp_soffset_soffset' stk mem strg ctx H_stk_len) as H_eq_soffset_soffset'.
               destruct H_eq_soffset_soffset' as [soffset_v [ H_eval_soffset H_eval_soffset']].

               pose proof (two_consecutive_mstore8_updates_same_address soffset soffset' svalue svalue' smem' (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops soffset_v H_eval_soffset H_eval_soffset') as H_remove_soffset'.
               rewrite H_remove_soffset'.

               rewrite IHsmem'_0_1.
               rewrite IHsmem'_0_2.

               exists mem1'.
               exists mem2'.
               
               repeat split; try reflexivity.
               apply IHsmem'_0_3.
           +++ rewrite <- H_basic_mstore_up. 

               remember (basic_smemory_updater_remove_mstore8_dups sstack_val_cmp soffset smem' instk_height m ops) as smem'_r.
               rewrite Heqsmem'_r in *.
               symmetry in Heqsmem'_r.
               rewrite Heqsmem'_r.
               
               pose proof (IHsmem' smem'_r H_valid_smem' Heqsmem'_r) as IHsmem'_0.
               destruct IHsmem'_0 as [mem1' [mem2' [H_eval_u_smem' [H_eval_u_smem'_r H_eq_mem1'_mem2']]]].
               apply functional_extensionality in H_eq_mem1'_mem2' as H_eq_mem1'_mem2'_f.

               pose proof (eval_sstack_val'_succ (S (get_maxidx_smap m)) instk_height soffset stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops (eq_sym H_stk_len) H_valid_soffset H_valid_smap (gt_Sn_n ((get_maxidx_smap m)))) as H_eval_soffset.
               destruct H_eval_soffset as [soffset_v H_eval_soffset].
               
               pose proof (eval_sstack_val'_succ (S (get_maxidx_smap m)) instk_height soffset' stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops (eq_sym H_stk_len) H_valid_soffset' H_valid_smap (gt_Sn_n ((get_maxidx_smap m)))) as H_eval_soffset'.
               destruct H_eval_soffset' as [soffset'_v H_eval_soffset'].

               pose proof (eval_sstack_val'_succ (S (get_maxidx_smap m)) instk_height svalue stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops (eq_sym H_stk_len) H_valid_svalue H_valid_smap (gt_Sn_n ((get_maxidx_smap m)))) as H_eval_svalue.
               destruct H_eval_svalue as [svlaue_v H_eval_svalue].

               pose proof (eval_sstack_val'_succ (S (get_maxidx_smap m)) instk_height svalue' stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops (eq_sym H_stk_len) H_valid_svalue' H_valid_smap (gt_Sn_n ((get_maxidx_smap m)))) as H_eval_svalue'.
               destruct H_eval_svalue' as [svlaue_v' H_eval_svalue'].

               unfold eval_smemory.
               unfold map_option.
               repeat rewrite <- map_option_ho.

               unfold eval_common.EvalCommon.instantiate_memory_update at 1.
               unfold eval_sstack_val.
               rewrite H_eval_soffset.
               rewrite H_eval_svalue.

               unfold eval_common.EvalCommon.instantiate_memory_update at 1.
               unfold eval_sstack_val.
               rewrite H_eval_soffset'.
               rewrite H_eval_svalue'.
              
               unfold eval_common.EvalCommon.instantiate_memory_update at 2.
               rewrite H_eval_soffset.
               rewrite H_eval_svalue.

               unfold eval_common.EvalCommon.instantiate_memory_update at 2.
               unfold eval_sstack_val.
               rewrite H_eval_soffset'.
               rewrite H_eval_svalue'.

               unfold eval_smemory in H_eval_u_smem'.
               unfold eval_sstack_val in  H_eval_u_smem'.
               

               destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val'  (S (get_maxidx_smap m)) sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) (U_MSTORE8 sstack_val soffset svalue :: smem')) as [updates1|] eqn:E_mo_1; try discriminate.
               pose proof (map_option_split (memory_update sstack_val) (memory_update EVMWord) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' (S (get_maxidx_smap m)) sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) smem' updates1 (U_MSTORE8 sstack_val soffset svalue) E_mo_1) as E_mo_1_split.
               destruct E_mo_1_split as [e1 [smem'' [E_updates_1 [E_mo_1_0 E_mo_1_1]]]].
               rewrite E_mo_1_1.

               unfold eval_smemory in H_eval_u_smem'_r.
               unfold eval_sstack_val in  H_eval_u_smem'_r.
               destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val'  (S (get_maxidx_smap m)) sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) (U_MSTORE8 sstack_val soffset svalue :: smem'_r)) as [updates2|] eqn:E_mo_2; try discriminate.
               pose proof (map_option_split (memory_update sstack_val) (memory_update EVMWord) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' (S (get_maxidx_smap m)) sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) smem'_r updates2 (U_MSTORE8 sstack_val soffset svalue) E_mo_2) as E_mo_2_split.
               destruct E_mo_2_split as [e2 [smem'_r' [E_updates_2 [E_mo_2_0 E_mo_2_1]]]].
               rewrite E_mo_2_1.

               exists (eval_common.EvalCommon.update_memory mem (U_MSTORE8 EVMWord soffset_v svlaue_v :: U_MSTORE8 EVMWord soffset'_v svlaue_v' :: smem'')).
               exists (eval_common.EvalCommon.update_memory mem (U_MSTORE8 EVMWord soffset_v svlaue_v :: U_MSTORE8 EVMWord soffset'_v svlaue_v' :: smem'_r')).
	       split. reflexivity.
               split. reflexivity.
               intro w.
               
               unfold eval_common.EvalCommon.update_memory.
               fold eval_common.EvalCommon.update_memory.

               unfold eval_common.EvalCommon.instantiate_memory_update in E_mo_1_0.
               rewrite H_eval_soffset in E_mo_1_0.
               rewrite H_eval_svalue in E_mo_1_0.
               injection E_mo_1_0 as E_e1.
               
               unfold eval_common.EvalCommon.instantiate_memory_update in E_mo_2_0.
               rewrite H_eval_soffset in E_mo_2_0.
               rewrite H_eval_svalue in E_mo_2_0.
               injection E_mo_2_0 as E_e2.

               rewrite E_updates_1 in H_eval_u_smem'.
               unfold eval_common.EvalCommon.update_memory in H_eval_u_smem'.
               fold eval_common.EvalCommon.update_memory in H_eval_u_smem'.
               injection H_eval_u_smem' as H_eval_u_smem'.

               rewrite E_updates_2 in H_eval_u_smem'_r.
               unfold eval_common.EvalCommon.update_memory in H_eval_u_smem'_r.
               fold eval_common.EvalCommon.update_memory in H_eval_u_smem'_r.
               injection H_eval_u_smem'_r as H_eval_u_smem'_r.
               rewrite H_eq_mem1'_mem2'_f in H_eval_u_smem'.
               rewrite <- H_eval_u_smem'_r in H_eval_u_smem'.

               rewrite <- E_e1 in H_eval_u_smem'.
               rewrite <- E_e2 in H_eval_u_smem'.

               apply mem_eq_when_after_update_eq in H_eval_u_smem'.
               rewrite H_eval_u_smem'.
               reflexivity.
    Qed.
      


  Lemma basic_smemory_updater_snd: smemory_updater_ext_snd basic_smemory_updater.
    unfold smemory_updater_ext_snd.
    intros sstack_val_cmp H_sstack_val_cmp_snd.
    unfold smemory_updater_snd.
    split.
      (* Validity *)
    + apply basic_smemory_updater_valid.
      apply H_sstack_val_cmp_snd. 
    + unfold smemory_updater_correct_res.
      intros m smem smem' u instk_height ops H_valid_smap H_valid_smem H_valid_u H_basic_smem_updater.
      intros stk mem strg ctx H_stk_len.
      unfold basic_smemory_updater in H_basic_smem_updater.
      destruct u as [soffset svalue|soffset svalue] eqn:E_u.
      ++ simpl in H_valid_u.
         destruct H_valid_u as [H_valid_soffset H_valid_svalue].
         destruct smem' as [|u' smem'']; try discriminate.
         injection H_basic_smem_updater as H_u' H_smem''.
         pose proof (basic_smemory_updater_remove_mstore_dups_correct sstack_val_cmp soffset svalue instk_height stk mem strg ctx m ops H_sstack_val_cmp_snd H_stk_len H_valid_soffset H_valid_svalue H_valid_smap smem smem''  H_valid_smem H_smem'') as H_basic_smemory_updater_remove_mstore_dups_correct.
         destruct H_basic_smemory_updater_remove_mstore_dups_correct as [mem1 [mem2 H_basic_smemory_updater_remove_mstore_dups_correct]].
         destruct H_basic_smemory_updater_remove_mstore_dups_correct as [H_mem1 [H_mem2 H_eq_mem1_mem2]].
         rewrite <- H_u'.
         rewrite H_mem1.
         rewrite H_mem2.
         exists mem1.
         exists mem2.
         repeat split; try reflexivity.
         unfold eq_memory.
         apply H_eq_mem1_mem2.
      ++ simpl in H_valid_u.
         destruct H_valid_u as [H_valid_soffset H_valid_svalue].
         destruct smem' as [|u' smem'']; try discriminate.
         injection H_basic_smem_updater as H_u' H_smem''.
         pose proof (basic_smemory_updater_remove_mstore8_dups_correct sstack_val_cmp soffset svalue instk_height stk mem strg ctx m ops H_sstack_val_cmp_snd H_stk_len H_valid_soffset H_valid_svalue H_valid_smap smem smem''  H_valid_smem H_smem'') as H_basic_smemory_updater_remove_mstore8_dups_correct.
         destruct H_basic_smemory_updater_remove_mstore8_dups_correct as [mem1 [mem2 H_basic_smemory_updater_remove_mstore8_dups_correct]].
         destruct H_basic_smemory_updater_remove_mstore8_dups_correct as [H_mem1 [H_mem2 H_eq_mem1_mem2]].
         rewrite <- H_u'.
         rewrite H_mem1.
         rewrite H_mem2.
         exists mem1.
         exists mem2.
         repeat split; try reflexivity.
         unfold eq_memory.
         apply H_eq_mem1_mem2.
  Qed.

  

End MemoryOpsSolversImplSoundness.

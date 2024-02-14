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
      pose proof (valid_smemeory_when_extended_with_valid_update instk_height (get_maxidx_smap m) u smem H_valid_u H_valid_smem) as H_valid_u_smem.
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
      memory_slots_do_not_overlap soffset soffset' size size' = true ->
      forall stk mem strg ctx,
        (length stk) = instk_height ->
        exists v1 v2,
        eval_sstack_val' (S maxidx) soffset stk mem strg ctx maxidx sbindings ops = Some v1 /\
          eval_sstack_val' (S maxidx) soffset' stk mem strg ctx maxidx sbindings ops = Some v2 /\
          orb ((wordToN v1)+size <? (wordToN v2))%N ((wordToN v2) + size' <? (wordToN v1))%N = true.
  Proof.
    intros soffset soffset' size size' maxidx sbindings instk_height ops.
    intros H_valid_sbindings H_valid_offset H_valid_offset' H_addr_nover.
    intros stk mem strg ctx H_stk_len.

    pose proof (eval_sstack_val'_succ (S maxidx) instk_height soffset stk mem strg ctx maxidx sbindings ops (eq_sym H_stk_len) H_valid_offset H_valid_sbindings (gt_Sn_n maxidx)) as H_eval_soffset.
    pose proof (eval_sstack_val'_succ (S maxidx) instk_height soffset' stk mem strg ctx maxidx sbindings ops (eq_sym H_stk_len) H_valid_offset' H_valid_sbindings (gt_Sn_n maxidx)) as H_eval_soffset'.
    destruct H_eval_soffset as [soffset_v H_eval_soffset].
    destruct H_eval_soffset' as [soffset'_v H_eval_soffset'].

    exists soffset_v.
    exists soffset'_v.
    repeat split. apply H_eval_soffset. apply H_eval_soffset'.
    unfold memory_slots_do_not_overlap in H_addr_nover.

    destruct soffset; try discriminate.
    destruct soffset'; try discriminate.

    pose proof (eval_sstack_val'_Val val stk mem strg ctx maxidx sbindings ops) as H_eval_soffset_val.
    rewrite H_eval_soffset_val in H_eval_soffset.
    injection H_eval_soffset as H_eval_soffset.
    
    pose proof (eval_sstack_val'_Val val0 stk mem strg ctx maxidx sbindings ops) as H_eval_soffset'_val.
    rewrite H_eval_soffset'_val in H_eval_soffset'.
    injection H_eval_soffset' as H_eval_soffset'.

    rewrite <- H_eval_soffset.
    rewrite <- H_eval_soffset'.
    
    apply H_addr_nover.
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


  Lemma S_S_n_gr_b: forall n, S (S n) > n.
  Proof.
    auto.
  Qed.
  
      
    
  Lemma basic_mload_solver_snd: mload_solver_ext_snd basic_mload_solver.
    unfold mload_solver_ext_snd.
    unfold mload_solver_snd.
    intros sstack_val_cmp H_sstack_val_cmp.
    split. apply basic_mload_solver_valid.
    unfold mload_solver_correct_res.
    intros m smem soffset instk_height smv ops idx1 m1.
    intros H_valid_smap H_smem H_valid_soffset H_basic_mload_solver H_add_to_smap.
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
    + 
      
  Admitted.
  
  Lemma basic_smemory_updater_snd: smemory_updater_ext_snd basic_smemory_updater.
  Admitted.
  

End MemoryOpsSolversImplSoundness.

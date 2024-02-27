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

Require Import memory_ops_solvers_impl_soundness_misc.
Import MemoryOpsSolversImplSoundnessMisc.

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


Lemma mstore'_aux:
  forall sz addr (value : word (sz * 8)) mem,
    (fix mstore' (sz : nat) (mem0 : memory) {struct sz} : word (sz * 8) -> N -> memory :=
         match sz as sz0 return (word (sz0 * 8) -> N -> memory) with
         | 0 => fun (_ : word (0 * 8)) (_ : N) => mem0
         | S sz1' =>
             fun (value0 : word (S sz1' * 8)) (offset offset'0 : N) =>
             if (offset'0 =? offset)%N
             then concrete_interpreter.ConcreteInterpreter.split1_byte value0
             else mstore' sz1' mem0 (concrete_interpreter.ConcreteInterpreter.split2_byte value0) (offset + 1)%N offset'0
         end) sz mem value addr = concrete_interpreter.ConcreteInterpreter.mstore' mem value addr.
Proof.
  auto.
  Qed.

Lemma mload''_aux:
  forall n addr addr' x y,
      (addr' > addr)%N ->
         (concrete_interpreter.ConcreteInterpreter.mload''
            (fun offset' : N =>
               if (offset' =? addr)%N
               then x
               else y offset') addr' n) =
           (concrete_interpreter.ConcreteInterpreter.mload'' y addr' n).
Proof.
  induction n as [|n' IHn'].
  + intros.
    simpl.
    reflexivity.
  + intros addr addr' x y H_addr'_gt_addr'.
    unfold concrete_interpreter.ConcreteInterpreter.mload'' at 1.
    fold concrete_interpreter.ConcreteInterpreter.mload''.

    assert (H_addr'_neqb_addr: (addr' =? addr)%N = false).
      (* proof of assert *)
      rewrite N.eqb_neq.
      intuition.
    
      assert (H_addr'_1_gt_addr: (addr'+1> addr)%N).
      apply N.lt_gt.
      apply N.lt_lt_add_r.
      apply N.gt_lt in H_addr'_gt_addr'.
      apply H_addr'_gt_addr'.
      (****)
      
    rewrite H_addr'_neqb_addr.
    unfold concrete_interpreter.ConcreteInterpreter.mload'' at 2.
    fold concrete_interpreter.ConcreteInterpreter.mload''.

    pose proof (IHn' addr (addr'+1)%N x y H_addr'_1_gt_addr) as IHn'_0.
    rewrite IHn'_0.
    reflexivity.
Qed.



Lemma mload''_mstore'_same_address:
  forall n mem addr value,
  concrete_interpreter.ConcreteInterpreter.mload'' (concrete_interpreter.ConcreteInterpreter.mstore' mem (value: word (n*8)) addr) addr n = value.
Proof.
  induction n as [|n' IHn'].
  + intros mem addr value.
    simpl.
    rewrite word0.
    reflexivity.
  + intros mem addr value.
    unfold concrete_interpreter.ConcreteInterpreter.mstore'.
    rewrite mstore'_aux.
    unfold concrete_interpreter.ConcreteInterpreter.mload''.
    rewrite N.eqb_refl.
    fold concrete_interpreter.ConcreteInterpreter.mload''.

    destruct n' as [|n''] eqn:E_n'.
    ++ unfold concrete_interpreter.ConcreteInterpreter.mload''.
       unfold concrete_interpreter.ConcreteInterpreter.split1_byte.
       unfold concrete_interpreter.ConcreteInterpreter.split1_byte.
       unfold mul.
              
       pose proof (wordToZ_combine_WO (split1 8 0 value)) as H_wordToZ_combine_WO.
       apply wordToZ_inj in H_wordToZ_combine_WO.
       rewrite H_wordToZ_combine_WO at 1.
       
       pose proof (split1_0 value) as H_split1_0_0.
       unfold mul in H_split1_0_0.
       unfold add in H_split1_0_0.
       pose proof (H_split1_0_0 (eq_refl 8)) as H_split1_0_1.
       unfold eq_rect in H_split1_0_1.
       apply H_split1_0_1.
       
    ++ rewrite mload''_aux.
       +++ pose proof (IHn' mem (addr+1)%N (concrete_interpreter.ConcreteInterpreter.split2_byte value)) as IHn'_0.
           rewrite IHn'_0.
           unfold concrete_interpreter.ConcreteInterpreter.split1_byte.
           unfold concrete_interpreter.ConcreteInterpreter.split2_byte.
           apply Word.combine_split.
       +++ apply N.lt_gt.
           apply Nlt_in.
           rewrite N2Nat.inj_add.
           simpl.
           intuition.
Qed.

Lemma mload_mstore_same_address:
  forall mem addr value,
    (concrete_interpreter.ConcreteInterpreter.mload
       (concrete_interpreter.ConcreteInterpreter.mstore mem value addr) addr) = value.
Proof.
  intros mem addr value.
  unfold concrete_interpreter.ConcreteInterpreter.mload.
  unfold concrete_interpreter.ConcreteInterpreter.mload'.
  unfold concrete_interpreter.ConcreteInterpreter.mstore.
  apply mload''_mstore'_same_address.
Qed.

 


Lemma do_not_overlap_mload:
  forall mem offset offset' value' updates,
    (wordToN offset + 31 <? wordToN offset')%N || (wordToN offset' + 31 <? wordToN offset)%N = true ->
    (concrete_interpreter.ConcreteInterpreter.mload'' (eval_common.EvalCommon.update_memory mem (U_MSTORE EVMWord offset' value' :: updates)) (wordToN offset) 32) =
    (concrete_interpreter.ConcreteInterpreter.mload'' (eval_common.EvalCommon.update_memory mem  updates) (wordToN (offset : EVMWord)) 32).
Proof.
  intros mem offset offset' value' updates H_o.
  unfold concrete_interpreter.ConcreteInterpreter.mload''.

  rewrite assoc_ones_31.
  rewrite Reduce_ones_31.

  rewrite assoc_ones_30.
  rewrite Reduce_ones_30.

  rewrite assoc_ones_29.
  rewrite Reduce_ones_29.

  rewrite assoc_ones_28.
  rewrite Reduce_ones_28.

  rewrite assoc_ones_27.
  rewrite Reduce_ones_27.

  rewrite assoc_ones_26.
  rewrite Reduce_ones_26.

  rewrite assoc_ones_25.
  rewrite Reduce_ones_25.

  rewrite assoc_ones_24.
  rewrite Reduce_ones_24.

  rewrite assoc_ones_23.
  rewrite Reduce_ones_23.

  rewrite assoc_ones_22.
  rewrite Reduce_ones_22.

  rewrite assoc_ones_21.
  rewrite Reduce_ones_21.

  rewrite assoc_ones_20.
  rewrite Reduce_ones_20.

  rewrite assoc_ones_19.
  rewrite Reduce_ones_19.

  rewrite assoc_ones_18.
  rewrite Reduce_ones_18.

  rewrite assoc_ones_17.
  rewrite Reduce_ones_17.

  rewrite assoc_ones_16.
  rewrite Reduce_ones_16.

  rewrite assoc_ones_15.
  rewrite Reduce_ones_15.

  rewrite assoc_ones_14.
  rewrite Reduce_ones_14.

  rewrite assoc_ones_13.
  rewrite Reduce_ones_13.

  rewrite assoc_ones_12.
  rewrite Reduce_ones_12.

  rewrite assoc_ones_11.
  rewrite Reduce_ones_11.

  rewrite assoc_ones_10.
  rewrite Reduce_ones_10.

    rewrite assoc_ones_9.
  rewrite Reduce_ones_9.

  rewrite assoc_ones_8.
  rewrite Reduce_ones_8.

  rewrite assoc_ones_7.
  rewrite Reduce_ones_7.

  rewrite assoc_ones_6.
  rewrite Reduce_ones_6.

  rewrite assoc_ones_5.
  rewrite Reduce_ones_5.

  rewrite assoc_ones_4.
  rewrite Reduce_ones_4.

  rewrite assoc_ones_3.
  rewrite Reduce_ones_3.

  rewrite assoc_ones_2.
  rewrite Reduce_ones_2.


  rewrite (do_not_overlap_mload_aux mem value' updates 1 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 2 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 3 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 4 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 5 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 6 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 7 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 8 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 9 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 10 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 11 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 12 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 13 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 14 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 15 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 16 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 17 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 18 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 19 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 20 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 21 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 22 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 23 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 24 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 25 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 26 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 27 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 28 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 29 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 30 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux mem value' updates 31 offset offset' H_31_lt_32 H_o).

  assert ( H_O_0: (wordToN offset + 0 = wordToN offset)%N). apply N.add_0_r.
  rewrite <- H_O_0.
  rewrite (do_not_overlap_mload_aux mem value' updates 0 offset offset' H_31_lt_32 H_o).
  reflexivity.
Qed.

Lemma do_not_overlap_mload_0:
  forall mem offset offset' value' updates,
    (wordToN offset + 31 <? wordToN offset')%N || (wordToN offset' + 0 <? wordToN offset)%N = true ->
    (concrete_interpreter.ConcreteInterpreter.mload'' (eval_common.EvalCommon.update_memory mem (U_MSTORE8 EVMWord offset' value' :: updates)) (wordToN offset) 32) =
    (concrete_interpreter.ConcreteInterpreter.mload'' (eval_common.EvalCommon.update_memory mem  updates) (wordToN (offset : EVMWord)) 32).
Proof.
Proof.
  intros mem offset offset' value' updates H_o.
  unfold concrete_interpreter.ConcreteInterpreter.mload''.

  rewrite assoc_ones_31.
  rewrite Reduce_ones_31.

  rewrite assoc_ones_30.
  rewrite Reduce_ones_30.

  rewrite assoc_ones_29.
  rewrite Reduce_ones_29.

  rewrite assoc_ones_28.
  rewrite Reduce_ones_28.

  rewrite assoc_ones_27.
  rewrite Reduce_ones_27.

  rewrite assoc_ones_26.
  rewrite Reduce_ones_26.

  rewrite assoc_ones_25.
  rewrite Reduce_ones_25.

  rewrite assoc_ones_24.
  rewrite Reduce_ones_24.

  rewrite assoc_ones_23.
  rewrite Reduce_ones_23.

  rewrite assoc_ones_22.
  rewrite Reduce_ones_22.

  rewrite assoc_ones_21.
  rewrite Reduce_ones_21.

  rewrite assoc_ones_20.
  rewrite Reduce_ones_20.

  rewrite assoc_ones_19.
  rewrite Reduce_ones_19.

  rewrite assoc_ones_18.
  rewrite Reduce_ones_18.

  rewrite assoc_ones_17.
  rewrite Reduce_ones_17.

  rewrite assoc_ones_16.
  rewrite Reduce_ones_16.

  rewrite assoc_ones_15.
  rewrite Reduce_ones_15.

  rewrite assoc_ones_14.
  rewrite Reduce_ones_14.

  rewrite assoc_ones_13.
  rewrite Reduce_ones_13.

  rewrite assoc_ones_12.
  rewrite Reduce_ones_12.

  rewrite assoc_ones_11.
  rewrite Reduce_ones_11.

  rewrite assoc_ones_10.
  rewrite Reduce_ones_10.

    rewrite assoc_ones_9.
  rewrite Reduce_ones_9.

  rewrite assoc_ones_8.
  rewrite Reduce_ones_8.

  rewrite assoc_ones_7.
  rewrite Reduce_ones_7.

  rewrite assoc_ones_6.
  rewrite Reduce_ones_6.

  rewrite assoc_ones_5.
  rewrite Reduce_ones_5.

  rewrite assoc_ones_4.
  rewrite Reduce_ones_4.

  rewrite assoc_ones_3.
  rewrite Reduce_ones_3.

  rewrite assoc_ones_2.
  rewrite Reduce_ones_2.


  rewrite (do_not_overlap_mload_aux' mem value' updates 1 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 2 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 3 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 4 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 5 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 6 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 7 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 8 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 9 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 10 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 11 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 12 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 13 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 14 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 15 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 16 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 17 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 18 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 19 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 20 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 21 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 22 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 23 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 24 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 25 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 26 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 27 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 28 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 29 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 30 offset offset' H_31_lt_32 H_o).
  rewrite (do_not_overlap_mload_aux' mem value' updates 31 offset offset' H_31_lt_32 H_o).

  assert ( H_O_0: (wordToN offset + 0 = wordToN offset)%N). apply N.add_0_r.
  rewrite <- H_O_0.
  rewrite (do_not_overlap_mload_aux' mem value' updates 0 offset offset' H_31_lt_32 H_o).
  reflexivity.
Qed.


Lemma update_same_address_mstore'_aux:
  forall n mem (value: word (n*8)) z offset1 offset2 x,
    (x =? offset1)%N = false ->
    (concrete_interpreter.ConcreteInterpreter.mstore' mem value offset2) x =
      (concrete_interpreter.ConcreteInterpreter.mstore'
         (fun (offset':N) => if (offset' =? offset1)%N then z else mem offset')
         value
         offset2) x.
Proof. 
  induction n as [|n' IHn'].
  + intros.
    simpl.
    rewrite H.
    reflexivity.
  + intros.
    simpl.
    pose proof (IHn' mem (concrete_interpreter.ConcreteInterpreter.split2_byte value) z offset1 (offset2+1)%N x).
    rewrite H0.
    reflexivity.
    apply H.
Qed.

Lemma update_same_address_mstore'_a:
  forall n m mem (value: word (n*8)) (value' : word (m*8)) offset,
    n>=m ->
    concrete_interpreter.ConcreteInterpreter.mstore' mem value offset =
      concrete_interpreter.ConcreteInterpreter.mstore' (concrete_interpreter.ConcreteInterpreter.mstore' mem value' offset) value offset.
Proof.
  induction n as [|n' IHn'].
  + intros.
    assert(m=0). intuition.
    simpl.
    unfold concrete_interpreter.ConcreteInterpreter.mstore'.
    destruct m; try (discriminate || reflexivity).
  + intros.
    destruct m as [|m'] eqn:E_m.
    ++ unfold concrete_interpreter.ConcreteInterpreter.mstore' at 3.
       reflexivity.
    ++ assert(n'>=m'). intuition.
       pose proof (IHn' m' mem (concrete_interpreter.ConcreteInterpreter.split2_byte value) (concrete_interpreter.ConcreteInterpreter.split2_byte value') (offset+1)%N H0) as IHn'_0.
       
       apply functional_extensionality.
       intro x.
       simpl.
       
       destruct (x =? offset)%N eqn:E_x_offset; try reflexivity.
       
       pose proof (update_same_address_mstore'_aux n' (concrete_interpreter.ConcreteInterpreter.mstore' mem
        (concrete_interpreter.ConcreteInterpreter.split2_byte value') (offset + 1)) (concrete_interpreter.ConcreteInterpreter.split2_byte value) (concrete_interpreter.ConcreteInterpreter.split1_byte value') offset (offset+1) x E_x_offset).
       rewrite <- H1.
       rewrite IHn'_0.
       reflexivity.
Qed.



Lemma update_same_address_mstore':
  forall n mem (value value': word (n*8)) offset, 
    concrete_interpreter.ConcreteInterpreter.mstore' mem value offset =
      concrete_interpreter.ConcreteInterpreter.mstore' (concrete_interpreter.ConcreteInterpreter.mstore' mem value' offset) value offset.
Proof.
  intros.
  assert(H_ge_refl: n>=n). intuition.
  pose proof (update_same_address_mstore'_a n n mem value value' offset H_ge_refl) as H_0.
  apply H_0.
Qed.  


Lemma ge_Sn_Sm_ge_1:
  forall n m,
    S n > 0 -> S m < S n -> exists i, n = S i.
Proof.
  intros n m H1 H2.
  destruct n as [|n'] eqn:E_n.
  + apply lt_S_n in H2.
    destruct m.
    ++ apply Nat.lt_irrefl in H2. contradiction.
    ++ apply Nat.nlt_0_r in H2. contradiction.     
  + exists n'.
    reflexivity.
Qed.

Lemma N_x_nat_of_Si:
  forall x i,
    (x + N.of_nat (S i) = x + 1 + N.of_nat i)%N.
Proof.
  intros x i.
  rewrite Nat2N.inj_succ.
  rewrite <- N.add_1_l.
  repeat rewrite N.add_assoc.
  reflexivity.
Qed.



Lemma update_same_address_mstore8_mstore':
  forall i n mem (value : word (n*8)) (value': word (1*8)) offset,
    n > 0 ->
    i < n ->
    concrete_interpreter.ConcreteInterpreter.mstore' mem value offset =
      concrete_interpreter.ConcreteInterpreter.mstore' (concrete_interpreter.ConcreteInterpreter.mstore' mem value' (offset+ N.of_nat i)%N) value offset.
Proof.
  induction i as [|i' IHi'].
  + intros n mem value value' offset H_n_gt_0 H_i_lt_n.
    unfold  N.of_nat.
    rewrite N.add_0_r.
    apply update_same_address_mstore'_a.
    intuition.
  + destruct n as [|n'] eqn:E_n.
    ++ intros mem value value' offset H_n_gt_0 H_i_l.
       apply gt_irrefl in H_n_gt_0.
       contradiction.
    ++ intros mem value value' offset H_n_gt_0 H_i_lt_n.
       pose proof (ge_Sn_Sm_ge_1 n' i' H_n_gt_0 H_i_lt_n) as H_n'_ge_1.
       destruct H_n'_ge_1 as [n'' H_n'_ge_1].

       rewrite N_x_nat_of_Si.

       apply functional_extensionality.
       intro x.
       simpl.
       destruct (x =? offset)%N eqn:E_x_offset; try reflexivity.


       assert(H_n'_gt_0: n'>0). intuition.
       assert(H_i'_lt_n': i'<n'). intuition.
       pose proof (IHi' n' mem (concrete_interpreter.ConcreteInterpreter.split2_byte value) value' (offset+1)%N H_n'_gt_0 H_i'_lt_n') as IHi'_0.

       rewrite IHi'_0.
       simpl.
       reflexivity.
Qed.


Lemma two_consecutive_updates_same_address_conc:
  forall v v1 v2 mem mem',
    eval_common.EvalCommon.update_memory mem (U_MSTORE EVMWord v v1 :: U_MSTORE EVMWord v v2 :: mem') = eval_common.EvalCommon.update_memory mem (U_MSTORE EVMWord v v1 :: mem').
Proof.
  intros v v1 v2 mem mem'.
  simpl.
  remember (eval_common.EvalCommon.update_memory mem mem') as mem_i.
  
  unfold concrete_interpreter.ConcreteInterpreter.mstore.
  pose proof (update_same_address_mstore' 32 mem_i v1 v2 (wordToN v)).
  symmetry in H.
  rewrite H at 1.
  reflexivity.
Qed.

Lemma two_consecutive_mstore8_updates_same_address_conc:
  forall v v1 v2 mem mem',
    eval_common.EvalCommon.update_memory mem (U_MSTORE8 EVMWord v v1 :: U_MSTORE8 EVMWord v v2 :: mem') = eval_common.EvalCommon.update_memory mem (U_MSTORE8 EVMWord v v1 :: mem').
Proof.
  intros v v1 v2 mem mem'.
  simpl.
  remember (eval_common.EvalCommon.update_memory mem mem') as mem_i.
  
  unfold concrete_interpreter.ConcreteInterpreter.mstore.
  pose proof (update_same_address_mstore' 1 mem_i (concrete_interpreter.ConcreteInterpreter.split1_byte (v1 : word (BytesInEVMWord*8))) (concrete_interpreter.ConcreteInterpreter.split1_byte (v2 : word (BytesInEVMWord*8))) (wordToN v)).
  symmetry in H.
  rewrite H at 1.
  reflexivity.
Qed.


Lemma inter_n_j:
  forall n m j,
    (n <=? m) && (m <=? n+j) = true ->
    exists i, i <= j /\ (m = n+i).
Proof.
  intros n m j H.
  exists (m-n).
  apply andb_prop in H.
  destruct H as [H1 H2].
  rewrite Nat.leb_le in H1.
  rewrite Nat.leb_le in H2.
  split; try intuition.
Qed.

Lemma N_inter_n_j:
  forall n m j,
    ((n <=? m) && (m <=? n+ j) = true)%N ->
    exists i, (i <= j)%N /\ (m = n+i)%N.
Proof.
  intros n m j H0.
  apply andb_prop in H0.
  destruct H0 as [H0_1 H0_2].
  rewrite N.leb_le in H0_1.
  rewrite N.leb_le in H0_2.
  assert (H0_1_nat: N.to_nat n <= N.to_nat m). intuition.
  assert (H0_2_nat: N.to_nat m <= N.to_nat n + N.to_nat j). intuition.
  rewrite <- Nat.leb_le in H0_1_nat.
  rewrite <- Nat.leb_le in H0_2_nat.
  pose proof (conj H0_1_nat H0_2_nat) as H0_12.
  apply andb_true_intro in H0_12.
  pose proof (inter_n_j (N.to_nat n) (N.to_nat m) (N.to_nat j) H0_12) as H_nat.
  destruct H_nat as [i [H_nat_1 H_nat_2]].
  exists (N.of_nat i).
  split.
  + rewrite N.le_lteq.
    apply Nat.le_lteq in H_nat_1.
    destruct H_nat_1.
    ++ left. apply Nlt_in. rewrite Nat2N.id.
       apply H.
    ++ right. rewrite H. rewrite N2Nat.id. reflexivity.
  + pose proof N2Nat.inj.
    apply N2Nat.inj.
    rewrite N2Nat.inj_add.
    rewrite Nat2N.id.
    apply H_nat_2.
Qed.
  
  
  
Lemma two_consecutive_updates_same_address_mstore8_conc:
  forall offset offset_8 v1 v2 mem mem',
    (wordToN offset <=? wordToN offset_8)%N && (wordToN offset_8 <=? wordToN offset + 31)%N = true ->
    eval_common.EvalCommon.update_memory mem (U_MSTORE EVMWord offset v1 :: U_MSTORE8 EVMWord offset_8 v2 :: mem') = eval_common.EvalCommon.update_memory mem (U_MSTORE EVMWord offset v1 :: mem').
Proof.
  intros offset offset_8 v1 v2 mem mem' H.
  simpl.
  unfold concrete_interpreter.ConcreteInterpreter.mstore.
  
  pose proof (N_inter_n_j (wordToN offset) (wordToN offset_8) 31 H) as H_0.
  destruct H_0 as [i [H_0_0 H_0_1]].
  rewrite H_0_1.

  assert(H_32: (N.to_nat 32%N = 32)). intuition.
  assert(H1: BytesInEVMWord > 0). unfold BytesInEVMWord. intuition.
  assert(H2: N.to_nat i < BytesInEVMWord).
     unfold BytesInEVMWord.
     rewrite <- H_32.
     apply Nlt_out.
     rewrite <- N.lt_succ_r in H_0_0.
     simpl in H_0_0.
     apply H_0_0.
  
  pose proof (update_same_address_mstore8_mstore' (N.to_nat i) BytesInEVMWord (eval_common.EvalCommon.update_memory mem mem') v1 (concrete_interpreter.ConcreteInterpreter.split1_byte (v2: word ((S (pred BytesInEVMWord))*8))) (wordToN offset) H1 H2) as H3.
  rewrite N2Nat.id in H3.
  rewrite H3.
  reflexivity.
Qed.
  
  

                                                                                                                                    
Lemma two_consecutive_updates_same_address:
  forall soffset soffset' svalue svalue' smem instk_height maxidx bs stk mem strg ctx ops v,
    eval_sstack_val soffset stk mem strg ctx maxidx bs ops = Some v ->
    eval_sstack_val soffset' stk mem strg ctx maxidx bs ops = Some v ->
    valid_smemory instk_height maxidx smem ->
    valid_bindings instk_height maxidx bs ops ->
    valid_sstack_value instk_height maxidx soffset ->
    valid_sstack_value instk_height maxidx svalue ->
    valid_sstack_value instk_height maxidx soffset' ->
    valid_sstack_value instk_height maxidx svalue' ->
    length stk = instk_height ->
    eval_smemory (U_MSTORE sstack_val soffset svalue :: U_MSTORE sstack_val soffset' svalue' :: smem) maxidx bs stk mem strg ctx ops =
      eval_smemory (U_MSTORE sstack_val soffset svalue :: smem) maxidx bs stk mem strg ctx ops.
Proof.
  intros soffset soffset' svalue svalue' smem instk_height maxidx bs stk mem strg ctx ops v H_eval_soffset H_eval_soffset' H_valid_smem H_valid_bs H_valid_soffset H_valid_svalue H_vlaid_soffset' H_valid_svalue' H_stk_len.

  pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue stk mem strg ctx maxidx bs ops (eq_sym H_stk_len) H_valid_svalue H_valid_bs (gt_Sn_n maxidx)) as H_eval_svalue.
  destruct H_eval_svalue as [v1 H_eval_svalue].
  pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue' stk mem strg ctx maxidx bs ops (eq_sym H_stk_len) H_valid_svalue' H_valid_bs (gt_Sn_n maxidx)) as H_eval_svalue'.
  destruct H_eval_svalue' as [v2 H_eval_svalue'].

  unfold eval_smemory.
  unfold eval_sstack_val.

  assert( H_valid_u1_u2_smem: valid_smemory instk_height maxidx (U_MSTORE sstack_val soffset svalue :: U_MSTORE sstack_val soffset' svalue' :: smem)). simpl. auto.  
  pose proof (H_map_o_smem instk_height (S maxidx) stk mem strg ctx maxidx bs ops (U_MSTORE sstack_val soffset svalue :: U_MSTORE sstack_val soffset' svalue' :: smem) H_valid_u1_u2_smem H_valid_bs (gt_Sn_n maxidx) (eq_sym H_stk_len)) as H_map_o_smem_0.
  destruct H_map_o_smem_0 as [u1_u2_smem_v H_map_o_smem_0].
  rewrite H_map_o_smem_0.

  assert( H_valid_u1_smem: valid_smemory instk_height maxidx (U_MSTORE sstack_val soffset svalue ::  smem)). simpl. auto.  
  pose proof (H_map_o_smem instk_height (S maxidx) stk mem strg ctx maxidx bs ops (U_MSTORE sstack_val soffset svalue :: smem) H_valid_u1_smem H_valid_bs (gt_Sn_n maxidx) (eq_sym H_stk_len)) as H_map_o_smem_1.
  destruct H_map_o_smem_1 as [u1_smem_v H_map_o_smem_1].
  rewrite H_map_o_smem_1.

  pose proof (map_option_split_2 (memory_update sstack_val)  (memory_update EVMWord) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' (S maxidx) sv stk mem strg ctx maxidx bs ops)) smem u1_u2_smem_v (U_MSTORE sstack_val soffset svalue) (U_MSTORE sstack_val soffset' svalue') H_map_o_smem_0) as H_map_o_smem_0_0.
  destruct H_map_o_smem_0_0 as [u1_v [u2_v [smem_v [H_u1_u2_smem_v [H_map_o_smem_0_u1 [H_map_o_smem_0_u2 H_map_o_smem_0_smem]]]]]].

  unfold eval_common.EvalCommon.instantiate_memory_update in H_map_o_smem_0_u1.
  unfold eval_sstack_val in H_eval_soffset.
  rewrite H_eval_soffset in H_map_o_smem_0_u1.
  unfold eval_sstack_val in H_eval_svalue.
  rewrite H_eval_svalue in H_map_o_smem_0_u1.
  injection H_map_o_smem_0_u1 as H_map_o_smem_0_u1.

  unfold eval_common.EvalCommon.instantiate_memory_update in H_map_o_smem_0_u2.
  unfold eval_sstack_val in H_eval_soffset'.
  rewrite H_eval_soffset' in H_map_o_smem_0_u2.
  unfold eval_sstack_val in H_eval_svalue'.
  rewrite H_eval_svalue' in H_map_o_smem_0_u2.
  injection H_map_o_smem_0_u2 as H_map_o_smem_0_u2.
  
  pose proof (map_option_split (memory_update sstack_val)  (memory_update EVMWord) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' (S maxidx) sv stk mem strg ctx maxidx bs ops)) smem u1_smem_v (U_MSTORE sstack_val soffset svalue) H_map_o_smem_1) as H_map_o_smem_1_0.
  destruct H_map_o_smem_1_0 as [u1_v' [smem_v' [H_u1_smem_v' [H_map_o_smem_1_u1 H_map_o_smem_1_smem]]]].

  unfold eval_common.EvalCommon.instantiate_memory_update in H_map_o_smem_1_u1.
  rewrite H_eval_soffset in H_map_o_smem_1_u1.
  rewrite H_eval_svalue in H_map_o_smem_1_u1.
  injection H_map_o_smem_1_u1 as H_map_o_smem_1_u1.

  rewrite H_u1_smem_v'. 
  rewrite H_u1_u2_smem_v.
  rewrite <- H_map_o_smem_0_u1.
  rewrite <- H_map_o_smem_0_u2.
  rewrite <- H_map_o_smem_1_u1.

  rewrite H_map_o_smem_0_smem in H_map_o_smem_1_smem.
  injection H_map_o_smem_1_smem as H_map_o_smem_1_smem.
  rewrite <- H_map_o_smem_1_smem.

  rewrite two_consecutive_updates_same_address_conc.
  reflexivity.
Qed.


Lemma two_consecutive_mstore8_updates_same_address:
  forall soffset soffset' svalue svalue' smem instk_height maxidx bs stk mem strg ctx ops v,
    eval_sstack_val soffset stk mem strg ctx maxidx bs ops = Some v ->
    eval_sstack_val soffset' stk mem strg ctx maxidx bs ops = Some v ->
    valid_smemory instk_height maxidx smem ->
    valid_bindings instk_height maxidx bs ops ->
    valid_sstack_value instk_height maxidx soffset ->
    valid_sstack_value instk_height maxidx svalue ->
    valid_sstack_value instk_height maxidx soffset' ->
    valid_sstack_value instk_height maxidx svalue' ->
    length stk = instk_height ->
    eval_smemory (U_MSTORE8 sstack_val soffset svalue :: U_MSTORE8 sstack_val soffset' svalue' :: smem) maxidx bs stk mem strg ctx ops =
      eval_smemory (U_MSTORE8 sstack_val soffset svalue :: smem) maxidx bs stk mem strg ctx ops.
Proof. 
  intros soffset soffset' svalue svalue' smem instk_height maxidx bs stk mem strg ctx ops v H_eval_soffset H_eval_soffset' H_valid_smem H_valid_bs H_valid_soffset H_valid_svalue H_vlaid_soffset' H_valid_svalue' H_stk_len.

  pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue stk mem strg ctx maxidx bs ops (eq_sym H_stk_len) H_valid_svalue H_valid_bs (gt_Sn_n maxidx)) as H_eval_svalue.
  destruct H_eval_svalue as [v1 H_eval_svalue].
  pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue' stk mem strg ctx maxidx bs ops (eq_sym H_stk_len) H_valid_svalue' H_valid_bs (gt_Sn_n maxidx)) as H_eval_svalue'.
  destruct H_eval_svalue' as [v2 H_eval_svalue'].

  unfold eval_smemory.
  unfold eval_sstack_val.

  assert( H_valid_u1_u2_smem: valid_smemory instk_height maxidx (U_MSTORE8 sstack_val soffset svalue :: U_MSTORE8 sstack_val soffset' svalue' :: smem)). simpl. auto.  
  pose proof (H_map_o_smem instk_height (S maxidx) stk mem strg ctx maxidx bs ops (U_MSTORE8 sstack_val soffset svalue :: U_MSTORE8 sstack_val soffset' svalue' :: smem) H_valid_u1_u2_smem H_valid_bs (gt_Sn_n maxidx) (eq_sym H_stk_len)) as H_map_o_smem_0.
  destruct H_map_o_smem_0 as [u1_u2_smem_v H_map_o_smem_0].
  rewrite H_map_o_smem_0.

  assert( H_valid_u1_smem: valid_smemory instk_height maxidx (U_MSTORE8 sstack_val soffset svalue ::  smem)). simpl. auto.  
  pose proof (H_map_o_smem instk_height (S maxidx) stk mem strg ctx maxidx bs ops (U_MSTORE8 sstack_val soffset svalue :: smem) H_valid_u1_smem H_valid_bs (gt_Sn_n maxidx) (eq_sym H_stk_len)) as H_map_o_smem_1.
  destruct H_map_o_smem_1 as [u1_smem_v H_map_o_smem_1].
  rewrite H_map_o_smem_1.

  pose proof (map_option_split_2 (memory_update sstack_val)  (memory_update EVMWord) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' (S maxidx) sv stk mem strg ctx maxidx bs ops)) smem u1_u2_smem_v (U_MSTORE8 sstack_val soffset svalue) (U_MSTORE8 sstack_val soffset' svalue') H_map_o_smem_0) as H_map_o_smem_0_0.
  destruct H_map_o_smem_0_0 as [u1_v [u2_v [smem_v [H_u1_u2_smem_v [H_map_o_smem_0_u1 [H_map_o_smem_0_u2 H_map_o_smem_0_smem]]]]]].

  unfold eval_common.EvalCommon.instantiate_memory_update in H_map_o_smem_0_u1.
  unfold eval_sstack_val in H_eval_soffset.
  rewrite H_eval_soffset in H_map_o_smem_0_u1.
  unfold eval_sstack_val in H_eval_svalue.
  rewrite H_eval_svalue in H_map_o_smem_0_u1.
  injection H_map_o_smem_0_u1 as H_map_o_smem_0_u1.

  unfold eval_common.EvalCommon.instantiate_memory_update in H_map_o_smem_0_u2.
  unfold eval_sstack_val in H_eval_soffset'.
  rewrite H_eval_soffset' in H_map_o_smem_0_u2.
  unfold eval_sstack_val in H_eval_svalue'.
  rewrite H_eval_svalue' in H_map_o_smem_0_u2.
  injection H_map_o_smem_0_u2 as H_map_o_smem_0_u2.
  
  pose proof (map_option_split (memory_update sstack_val)  (memory_update EVMWord) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' (S maxidx) sv stk mem strg ctx maxidx bs ops)) smem u1_smem_v (U_MSTORE8 sstack_val soffset svalue) H_map_o_smem_1) as H_map_o_smem_1_0.
  destruct H_map_o_smem_1_0 as [u1_v' [smem_v' [H_u1_smem_v' [H_map_o_smem_1_u1 H_map_o_smem_1_smem]]]].

  unfold eval_common.EvalCommon.instantiate_memory_update in H_map_o_smem_1_u1.
  rewrite H_eval_soffset in H_map_o_smem_1_u1.
  rewrite H_eval_svalue in H_map_o_smem_1_u1.
  injection H_map_o_smem_1_u1 as H_map_o_smem_1_u1.

  rewrite H_u1_smem_v'. 
  rewrite H_u1_u2_smem_v.
  rewrite <- H_map_o_smem_0_u1.
  rewrite <- H_map_o_smem_0_u2.
  rewrite <- H_map_o_smem_1_u1.

  rewrite H_map_o_smem_0_smem in H_map_o_smem_1_smem.
  injection H_map_o_smem_1_smem as H_map_o_smem_1_smem.
  rewrite <- H_map_o_smem_1_smem.

  rewrite two_consecutive_mstore8_updates_same_address_conc.
  reflexivity.
Qed.


Lemma two_consecutive_updates_same_address_mstore8:
  forall soffset soffset' svalue svalue' smem instk_height maxidx bs stk mem strg ctx ops v1 v2,
    eval_sstack_val soffset stk mem strg ctx maxidx bs ops = Some v1 ->
    eval_sstack_val soffset' stk mem strg ctx maxidx bs ops = Some v2 ->
    valid_smemory instk_height maxidx smem ->
    valid_bindings instk_height maxidx bs ops ->
    valid_sstack_value instk_height maxidx soffset ->
    valid_sstack_value instk_height maxidx svalue ->
    valid_sstack_value instk_height maxidx soffset' ->
    valid_sstack_value instk_height maxidx svalue' ->
    length stk = instk_height ->
    andb ((wordToN v2) <=? (wordToN v1) )%N ((wordToN v1) <=? (wordToN v2)+31)%N = true ->
    eval_smemory (U_MSTORE sstack_val soffset' svalue' :: U_MSTORE8 sstack_val soffset svalue :: smem) maxidx bs stk mem strg ctx ops =
      eval_smemory (U_MSTORE sstack_val soffset' svalue' :: smem) maxidx bs stk mem strg ctx ops.
Proof.
  intros soffset soffset' svalue svalue' smem instk_height maxidx bs stk mem strg ctx ops v1 v2 H_eval_soffset H_eval_soffset' H_valid_smem H_valid_bs H_valid_soffset H_valid_svalue H_vlaid_soffset' H_valid_svalue' H_stk_len H_v1_in_v2.

  pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue stk mem strg ctx maxidx bs ops (eq_sym H_stk_len) H_valid_svalue H_valid_bs (gt_Sn_n maxidx)) as H_eval_svalue.
  destruct H_eval_svalue as [svalue_v H_eval_svalue].
  pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue' stk mem strg ctx maxidx bs ops (eq_sym H_stk_len) H_valid_svalue' H_valid_bs (gt_Sn_n maxidx)) as H_eval_svalue'.
  destruct H_eval_svalue' as [svalue'_v H_eval_svalue'].

  unfold eval_smemory.
  unfold eval_sstack_val.

  assert( H_valid_u1_u2_smem: valid_smemory instk_height maxidx (U_MSTORE sstack_val soffset' svalue' :: U_MSTORE8 sstack_val soffset svalue :: smem)). simpl. auto.  
  pose proof (H_map_o_smem instk_height (S maxidx) stk mem strg ctx maxidx bs ops (U_MSTORE sstack_val soffset' svalue' :: U_MSTORE8 sstack_val soffset svalue :: smem) H_valid_u1_u2_smem H_valid_bs (gt_Sn_n maxidx) (eq_sym H_stk_len)) as H_map_o_smem_0.
  destruct H_map_o_smem_0 as [u1_u2_smem_v H_map_o_smem_0].
  rewrite H_map_o_smem_0.

  assert( H_valid_u1_smem: valid_smemory instk_height maxidx (U_MSTORE sstack_val soffset' svalue' ::  smem)). simpl. auto.
  pose proof (H_map_o_smem instk_height (S maxidx) stk mem strg ctx maxidx bs ops (U_MSTORE sstack_val soffset' svalue' :: smem) H_valid_u1_smem H_valid_bs (gt_Sn_n maxidx) (eq_sym H_stk_len)) as H_map_o_smem_1.
  destruct H_map_o_smem_1 as [u1_smem_v H_map_o_smem_1].
  rewrite H_map_o_smem_1.

  pose proof (map_option_split_2 (memory_update sstack_val)  (memory_update EVMWord) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' (S maxidx) sv stk mem strg ctx maxidx bs ops)) smem u1_u2_smem_v (U_MSTORE sstack_val soffset' svalue') (U_MSTORE8 sstack_val soffset svalue) H_map_o_smem_0) as H_map_o_smem_0_0.
  destruct H_map_o_smem_0_0 as [u1_v [u2_v [smem_v [H_u1_u2_smem_v [H_map_o_smem_0_u1 [H_map_o_smem_0_u2 H_map_o_smem_0_smem]]]]]].

  unfold eval_common.EvalCommon.instantiate_memory_update in H_map_o_smem_0_u1.
  unfold eval_sstack_val in H_eval_soffset'.
  rewrite H_eval_soffset' in H_map_o_smem_0_u1.
  unfold eval_sstack_val in H_eval_svalue'.
  rewrite H_eval_svalue' in H_map_o_smem_0_u1.
  injection H_map_o_smem_0_u1 as H_map_o_smem_0_u1.

  unfold eval_common.EvalCommon.instantiate_memory_update in H_map_o_smem_0_u2.
  unfold eval_sstack_val in H_eval_soffset.
  rewrite H_eval_soffset in H_map_o_smem_0_u2.
  unfold eval_sstack_val in H_eval_svalue.
  rewrite H_eval_svalue in H_map_o_smem_0_u2.
  injection H_map_o_smem_0_u2 as H_map_o_smem_0_u2.
 
  pose proof (map_option_split (memory_update sstack_val)  (memory_update EVMWord) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' (S maxidx) sv stk mem strg ctx maxidx bs ops)) smem u1_smem_v (U_MSTORE sstack_val soffset' svalue') H_map_o_smem_1) as H_map_o_smem_1_0.
  destruct H_map_o_smem_1_0 as [u1_v' [smem_v' [H_u1_smem_v' [H_map_o_smem_1_u1 H_map_o_smem_1_smem]]]].

  unfold eval_common.EvalCommon.instantiate_memory_update in H_map_o_smem_1_u1.
  rewrite H_eval_soffset' in H_map_o_smem_1_u1.
  rewrite H_eval_svalue' in H_map_o_smem_1_u1.
  injection H_map_o_smem_1_u1 as H_map_o_smem_1_u1.

  rewrite H_u1_smem_v'. 
  rewrite H_u1_u2_smem_v.
  rewrite <- H_map_o_smem_0_u1.
  rewrite <- H_map_o_smem_0_u2.
  rewrite <- H_map_o_smem_1_u1.
 
  rewrite H_map_o_smem_0_smem in H_map_o_smem_1_smem.
  injection H_map_o_smem_1_smem as H_map_o_smem_1_smem.
  rewrite <- H_map_o_smem_1_smem.
  rewrite two_consecutive_updates_same_address_mstore8_conc.
  reflexivity.
  apply H_v1_in_v2.
Qed.


Lemma mem_eq_after_update'':
forall (n m : nat)  (mem1 mem2 : memory) (svalue1 : word (n * 8)) (svalue2 : word (m * 8)) (soffset1 soffset2 : N)  (w : N),
  concrete_interpreter.ConcreteInterpreter.mstore' mem1 svalue1 soffset1 w =
    concrete_interpreter.ConcreteInterpreter.mstore' mem2 svalue1 soffset1 w ->
  concrete_interpreter.ConcreteInterpreter.mstore'
    (concrete_interpreter.ConcreteInterpreter.mstore' mem1 svalue2 soffset2) svalue1 soffset1 w =
  concrete_interpreter.ConcreteInterpreter.mstore'
    (concrete_interpreter.ConcreteInterpreter.mstore' mem2 svalue2 soffset2) svalue1 soffset1 w.
Proof.
  induction n as [|n' IHn'].
  + induction m as [|m' IHm'].
    ++ intros mem1 mem2 svalue1 svalue2 soffset1 soffset2 w H.
       unfold concrete_interpreter.ConcreteInterpreter.mstore' in H.
       simpl.
       apply H.
    ++ intros mem1 mem2 svalue1 svalue2 soffset1 soffset2 w H.
       simpl.
       destruct (w =? soffset2)%N eqn:E_w_off2; try reflexivity.
       pose proof (IHm' mem1 mem2 svalue1 (concrete_interpreter.ConcreteInterpreter.split2_byte svalue2) soffset1 (soffset2 + 1)%N w H) as IHm'_0.
       simpl in IHm'_0.
       apply IHm'_0.
  +  intros m mem1 mem2 svalue1 svalue2 soffset1 soffset2 w H.
     simpl.
     destruct (w =? soffset1)%N eqn:E_w_off1; try reflexivity.
     simpl in H.
     rewrite E_w_off1 in H.
     pose proof (IHn' m mem1 mem2 (concrete_interpreter.ConcreteInterpreter.split2_byte svalue1) svalue2 (soffset1+1)%N soffset2 w H).
     apply H0.
Qed.

Lemma mem_eq_after_update':
  forall u1 u2 w mem1 mem2,
  (eval_common.EvalCommon.update_memory' mem1 u1) w =
  (eval_common.EvalCommon.update_memory' mem2 u1) w ->
  eval_common.EvalCommon.update_memory' (eval_common.EvalCommon.update_memory' mem1 u2) u1 w =
  eval_common.EvalCommon.update_memory' (eval_common.EvalCommon.update_memory' mem2 u2) u1 w.
Proof.
  intros.
  unfold eval_common.EvalCommon.update_memory'.
  unfold eval_common.EvalCommon.update_memory'.
  unfold concrete_interpreter.ConcreteInterpreter.mstore.
   
  destruct u1 as [soffset1 svalue1|soffset1 svalue1]; 
    destruct u2 as [soffset2 svalue2|soffset2 svalue2]; 

    apply mem_eq_after_update''; apply H.
Qed.

Lemma mem_eq_after_update:
  forall smem1 smem2 u1 u2 w mem,
  (eval_common.EvalCommon.update_memory' (eval_common.EvalCommon.update_memory mem smem1) u1) w =
  (eval_common.EvalCommon.update_memory' (eval_common.EvalCommon.update_memory mem smem2) u1) w ->
  eval_common.EvalCommon.update_memory' (eval_common.EvalCommon.update_memory' (eval_common.EvalCommon.update_memory mem smem1) u2) u1 w =
  eval_common.EvalCommon.update_memory' (eval_common.EvalCommon.update_memory' (eval_common.EvalCommon.update_memory mem smem2) u2) u1 w.
Proof.
  intros.
  pose proof (mem_eq_after_update' u1 u2 w (eval_common.EvalCommon.update_memory mem smem1) (eval_common.EvalCommon.update_memory mem smem2) H) as H_mem_eq_after_update'.
  apply H_mem_eq_after_update'.
Qed.

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
    remember (concrete_interpreter.ConcreteInterpreter.mstore' mem (concrete_interpreter.ConcreteInterpreter.split2_byte w) (offset + 1)) as mem''.
    pose proof (IHsz' mem (concrete_interpreter.ConcreteInterpreter.split2_byte w) (offset + 1)%N mem'' (eq_sym Heqmem'') offset' H_n'_gt_n) as IHsz'_0.
    rewrite <- H_mstore'.
    destruct (offset' =? offset)%N eqn:E_offset_offset'.
    ++ rewrite N.eqb_eq in E_offset_offset'.
       rewrite E_offset_offset' in H_n'_gt_n.
       contradiction H_n'_gt_n.
       destruct offset.
       +++ intuition.
       +++ intuition.
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

               pose proof (two_consecutive_updates_same_address soffset soffset' svalue svalue' smem' instk_height (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops soffset_v H_eval_soffset H_eval_soffset' H_valid_smem' H_valid_smap H_valid_soffset H_valid_svalue H_valid_soffset' H_valid_svalue' H_stk_len) as H_remove_soffset'.
               
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

               apply mem_eq_after_update.
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
               
               pose proof (two_consecutive_updates_same_address_mstore8 soffset' soffset svalue' svalue smem' instk_height (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops soffset'_v soffset_v H_eval_soffset' H_eval_soffset H_valid_smem' H_valid_smap H_valid_soffset' H_valid_svalue' H_valid_soffset H_valid_svalue H_stk_len H_addr_inc) as H_remove_soffset'.

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

               apply mem_eq_after_update.
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

           apply mem_eq_after_update.
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

               pose proof (two_consecutive_mstore8_updates_same_address soffset soffset' svalue svalue' smem' instk_height (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx ops soffset_v H_eval_soffset H_eval_soffset' H_valid_smem' H_valid_smap H_valid_soffset H_valid_svalue H_valid_soffset' H_valid_svalue' H_stk_len) as H_remove_soffset'.
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

               apply mem_eq_after_update.
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

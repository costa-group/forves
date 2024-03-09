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

Require Import FORVES.symbolic_state_eval_facts.
Import SymbolicStateEvalFacts.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.symbolic_state_cmp.
Import SymbolicStateCmp.

Require Import FORVES.memory_cmp_impl.
Import MemoryCmpImpl.

Require Import FORVES.eval_common.
Import EvalCommon.

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import Coq.Logic.FunctionalExtensionality.

Require Import FORVES.memory_ops_solvers_impl_soundness.
Import MemoryOpsSolversImplSoundness.

Module MemoryCmpImplSoundness.

  Theorem trivial_memory_cmp_snd:
    safe_smemory_cmp_ext_wrt_sstack_value_cmp trivial_memory_cmp.
  Proof.
    unfold safe_smemory_cmp_ext_wrt_sstack_value_cmp.
    unfold safe_sstack_val_cmp_ext_1_d.
    unfold safe_smemory_cmp_ext_d.
    unfold safe_smemory_cmp.
    unfold trivial_memory_cmp.
    intros.
    destruct smem1; destruct smem2; try discriminate.
    exists mem.
    auto.
  Qed.
  

  Theorem basic_memory_cmp_snd:
    safe_smemory_cmp_ext_wrt_sstack_value_cmp basic_memory_cmp.
  Proof.
    unfold safe_smemory_cmp_ext_wrt_sstack_value_cmp.
    intros d sstack_val_cmp H_sstack_val_cmp_snd.
    unfold safe_smemory_cmp_ext_d.
    intros d' H_d'_le_d.
    unfold safe_smemory_cmp.
    intros smem1 smem2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_sb1 H_valid_sb2.
    revert smem2.
    revert smem1.
    induction smem1 as [|u1 smem1' IHsmem1'].
    + intros smem2 H_valid_smem1 H_valid_smem2 H_basic_mem_cmp stk mem strg ctx H_stk_len.
      destruct smem2; try discriminate.
      exists mem.
      unfold eval_smemory.
      simpl.
      split; reflexivity.
    + intros smem2 H_valid_smem1 H_valid_smem2 H_basic_mem_cmp stk mem strg ctx H_stk_len.
      destruct smem2 as [|u2 smem2'] eqn:H_smem2.
      ++ simpl in H_basic_mem_cmp.
         destruct u1; try discriminate.
      ++ simpl in H_basic_mem_cmp.
         destruct u1 as [soffset1 svalue1|soffset1 svalue1] eqn:E_u1; destruct u2 as [soffset2 svalue2|soffset2 svalue2] eqn:E_u2; try discriminate.
         +++ destruct (sstack_val_cmp d' soffset1 soffset2 maxidx1 sb1 maxidx2 sb2 instk_height ops) eqn:E_cmp_soffset1_soffset2; try discriminate.
             destruct (sstack_val_cmp d' svalue1 svalue2 maxidx1 sb1 maxidx2 sb2 instk_height ops) eqn:E_cmp_svalue1_svalue2; try discriminate.
             simpl in H_valid_smem1.
             destruct H_valid_smem1 as [ [H_valid_soffset1 H_valid_svalue1] H_valid_smem1'].
             simpl in H_valid_smem2.
             destruct H_valid_smem2 as [ [H_valid_soffset2 H_valid_svalue2] H_valid_smem2'].
             pose proof (IHsmem1' smem2' H_valid_smem1' H_valid_smem2' H_basic_mem_cmp stk mem strg ctx H_stk_len) as IHsmem1'_0.
             destruct IHsmem1'_0 as [mem' [IHsmem1'_0 IHsmem1'_1]].
             
             unfold safe_sstack_val_cmp_ext_1_d in H_sstack_val_cmp_snd.
             pose proof (H_sstack_val_cmp_snd d' H_d'_le_d) as H_sstack_val_cmp_snd_d'.
             unfold safe_sstack_val_cmp in H_sstack_val_cmp_snd_d'.
             pose proof(H_sstack_val_cmp_snd_d' soffset1 soffset2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_soffset1 H_valid_soffset2 H_valid_sb1 H_valid_sb2 E_cmp_soffset1_soffset2 stk mem strg ctx H_stk_len) as H_eval_soffset1_soffset2.
             destruct H_eval_soffset1_soffset2 as [soffset_1_2_v [H_eval_soffset1 H_eval_soffset2]].
             
             pose proof(H_sstack_val_cmp_snd_d' svalue1 svalue2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_svalue1 H_valid_svalue2 H_valid_sb1 H_valid_sb2 E_cmp_svalue1_svalue2 stk mem strg ctx H_stk_len) as H_eval_svalue1_svalue2.
             destruct H_eval_svalue1_svalue2 as [svalue_1_2_v [H_eval_svalue1 H_eval_svalue2]].
             
             exists (mstore mem' svalue_1_2_v  soffset_1_2_v).
             
             unfold eval_smemory in IHsmem1'_0.
             destruct (map_option (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx1 sb1 ops)) smem1') as [updates1|] eqn:H_mo_smem1'; try discriminate.
             injection IHsmem1'_0 as IHsmem1'_0.
             
             unfold eval_smemory in IHsmem1'_1.
             destruct (map_option (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx2 sb2 ops)) smem2') as [updates2|] eqn:H_mo_smem2'; try discriminate.
             injection IHsmem1'_1 as IHsmem1'_1.
             
             unfold eval_smemory.
             unfold map_option.
             repeat rewrite <- map_option_ho.
             
             unfold instantiate_memory_update at 1.
             rewrite H_eval_soffset1.
             rewrite H_eval_svalue1.
             
             unfold instantiate_memory_update at 2.
             rewrite H_eval_soffset2.
             rewrite H_eval_svalue2.
             
             rewrite H_mo_smem1'.
             rewrite H_mo_smem2'.
             
             unfold update_memory.
             fold update_memory.
             
             rewrite IHsmem1'_0.
             rewrite IHsmem1'_1.
             
             simpl.
             split; reflexivity.
         (* copy of previous item *)
         +++ destruct (sstack_val_cmp d' soffset1 soffset2 maxidx1 sb1 maxidx2 sb2 instk_height ops) eqn:E_cmp_soffset1_soffset2; try discriminate.
             destruct (sstack_val_cmp d' svalue1 svalue2 maxidx1 sb1 maxidx2 sb2 instk_height ops) eqn:E_cmp_svalue1_svalue2; try discriminate.
             simpl in H_valid_smem1.
             destruct H_valid_smem1 as [ [H_valid_soffset1 H_valid_svalue1] H_valid_smem1'].
             simpl in H_valid_smem2.
             destruct H_valid_smem2 as [ [H_valid_soffset2 H_valid_svalue2] H_valid_smem2'].
             pose proof (IHsmem1' smem2' H_valid_smem1' H_valid_smem2' H_basic_mem_cmp stk mem strg ctx H_stk_len) as IHsmem1'_0.
             destruct IHsmem1'_0 as [mem' [IHsmem1'_0 IHsmem1'_1]].
             
             unfold safe_sstack_val_cmp_ext_1_d in H_sstack_val_cmp_snd.
             pose proof (H_sstack_val_cmp_snd d' H_d'_le_d) as H_sstack_val_cmp_snd_d'.
             unfold safe_sstack_val_cmp in H_sstack_val_cmp_snd_d'.
             pose proof(H_sstack_val_cmp_snd_d' soffset1 soffset2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_soffset1 H_valid_soffset2 H_valid_sb1 H_valid_sb2 E_cmp_soffset1_soffset2 stk mem strg ctx H_stk_len) as H_eval_soffset1_soffset2.
             destruct H_eval_soffset1_soffset2 as [soffset_1_2_v [H_eval_soffset1 H_eval_soffset2]].
             
             pose proof(H_sstack_val_cmp_snd_d' svalue1 svalue2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_svalue1 H_valid_svalue2 H_valid_sb1 H_valid_sb2 E_cmp_svalue1_svalue2 stk mem strg ctx H_stk_len) as H_eval_svalue1_svalue2.
             destruct H_eval_svalue1_svalue2 as [svalue_1_2_v [H_eval_svalue1 H_eval_svalue2]].
             
             exists (mstore mem' (split1_byte (svalue_1_2_v: word ((S (pred BytesInEVMWord))*8))) soffset_1_2_v).
             
             unfold eval_smemory in IHsmem1'_0.
             destruct (map_option (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx1 sb1 ops)) smem1') as [updates1|] eqn:H_mo_smem1'; try discriminate.
             injection IHsmem1'_0 as IHsmem1'_0.
             
             unfold eval_smemory in IHsmem1'_1.
             destruct (map_option (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx2 sb2 ops)) smem2') as [updates2|] eqn:H_mo_smem2'; try discriminate.
             injection IHsmem1'_1 as IHsmem1'_1.
             
             unfold eval_smemory.
             unfold map_option.
             repeat rewrite <- map_option_ho.
             
             unfold instantiate_memory_update at 1.
             rewrite H_eval_soffset1.
             rewrite H_eval_svalue1.
             
             unfold instantiate_memory_update at 2.
             rewrite H_eval_soffset2.
             rewrite H_eval_svalue2.
             
             rewrite H_mo_smem1'.
             rewrite H_mo_smem2'.
             
             unfold update_memory.
             fold update_memory.
             
             rewrite IHsmem1'_0.
             rewrite IHsmem1'_1.
             
             simpl.
             split; reflexivity.
  Qed.


    
  Lemma reorder_updates'_valid:
    forall maxidx sb instk_height ops,
      valid_bindings instk_height maxidx sb ops ->
      forall d smem b smem_r,
      valid_smemory instk_height maxidx smem ->
      reorder_updates' d smem maxidx sb = (b,smem_r) ->
      valid_smemory instk_height maxidx smem_r.
  Proof.
    intros maxidx sb instk_height ops H_valid_sb.
    induction d as [|d'' IHd'].
    + intros smem b smem_r H_valid_smem H_reorder'.
      simpl in H_reorder'.
      injection H_reorder' as H_b H_smem_r.
      rewrite <- H_smem_r.
      apply H_valid_smem.
    + intros smem b smem_r H_valid_smem H_reorder'.
      simpl in H_reorder'.
      destruct smem as [|u1 smem'] eqn:H_smem.
      ++ injection H_reorder' as H_b H_smem_r.
         rewrite <- H_smem_r.
         simpl.
         auto.
      ++  destruct smem' as [|u2 smem''] eqn:H_smem'.
          +++ injection H_reorder' as H_b H_smem_r.
              rewrite <- H_smem_r.
              simpl.
              split; try auto.
              apply H_valid_smem.
          +++ destruct (swap_memory_update u1 u2 maxidx sb) eqn:E_swap.
              ++++ destruct (reorder_updates' d'' (u1 :: smem'')) eqn:E_reorder'_rec.
                   injection H_reorder' as H_b H_smem_r.
                   rewrite <- H_smem_r.
                   simpl in H_valid_smem.
                   destruct H_valid_smem as [H_valid_u1 [H_valid_u2 H_valid_smem'']].
                   pose proof (IHd' (u1 :: smem'') b0 s (valid_smemory_when_extended_with_valid_update instk_height maxidx u1 smem'' H_valid_u1 H_valid_smem'') E_reorder'_rec) as IHd'_0.
                   simpl.
                   split.
                   +++++ apply H_valid_u2.
                   +++++ apply IHd'_0.
              ++++ destruct (reorder_updates' d'' (u2 :: smem'')) eqn:E_reorder'_rec.
                   injection H_reorder' as H_b H_smem_r.
                   rewrite <- H_smem_r.
                   simpl in H_valid_smem.
                   destruct H_valid_smem as [H_valid_u1 [H_valid_u2 H_valid_smem'']].
                   pose proof (IHd' (u2 :: smem'') b0 s (valid_smemory_when_extended_with_valid_update instk_height maxidx u2 smem'' H_valid_u2 H_valid_smem'') E_reorder'_rec) as IHd'_0.
                   simpl.
                   split.
                   +++++ apply H_valid_u1.
                   +++++ apply IHd'_0.
  Qed.

  Lemma x_eq_offset_false_implied:
    forall n offset1 offset2 x,
      (offset1+(N.of_nat (S n)) <=? offset2)%N = true ->
      (x =? offset1)%N = true ->
      (x =? offset2)%N = false.
  Proof.
    intros n offset1 offset2 x H_no_overlap H_x_offset1.
      simpl in H_no_overlap.
      rewrite N.eqb_eq in H_x_offset1.
      rewrite H_x_offset1.
      rewrite N.eqb_neq.
      apply N.lt_neq. 
      pose proof (N.leb_le (offset1 + N.pos (Pos.of_succ_nat n))%N offset2) as H_leb_le.
      rewrite H_leb_le in H_no_overlap.
      apply Nlt_in.
      intuition.
Qed.    

  Lemma n_le_m_implies_n_lt_m_plus_1:
    forall n m,
      (n <=? m = true -> n <? m+1 = true)%N.
  Proof.
    intros n m H_n_le_m.
    rewrite N.ltb_lt.
    rewrite N.leb_le in H_n_le_m.
    apply Nlt_in.
    intuition.
  Qed.

    Lemma n_le_m_implies_n_le_m_plus_1:
    forall n m,
      (n <=? m = true -> n <=? m+1 = true)%N.
  Proof.
    intros n m H_n_le_m.
    rewrite N.leb_le.
    rewrite N.leb_le in H_n_le_m.
    apply N.le_lteq.
    left.
    apply Nlt_in.
    intuition.
  Qed.

  Lemma Nle_in:
    forall n m : N, N.to_nat n <= N.to_nat m -> (n <= m)%N.
  Proof.
    intros n m H.
    apply Nat.le_lteq in H.
    destruct H.
    + apply Nlt_in in H.
      apply N.le_lteq.
      left.
      apply H.
    + apply N.le_lteq.
      right.
      apply nat_of_N_eq in H.
      apply H.
  Qed.

                                                    
  Lemma n_lt_m_implies_n_plus_1_le_m:
    forall n m,
      (n <? m = true -> n+1 <=? m = true)%N.
  Proof.
    intros n m H_n_lt_m.
    rewrite N.leb_le.
    pose proof Nlt_in.
    rewrite N.ltb_lt in H_n_lt_m.
    apply Nlt_out in H_n_lt_m.
    apply Nle_in.
    intuition.
  Qed.


  
Lemma update_same_address_mstore'_aux:
  forall n m mem (value1: word (S n*8)) (value2: word (m*8)) offset1 offset2 x,
    (offset1+(N.of_nat (S n)) <=? offset2)%N = true ->
    (x =? offset1)%N = true ->
    mstore'
      (fun offset' : N =>
         if (offset' =? offset1)%N
         then split1_byte value1
         else mstore' mem (split2_byte value1) (offset1 + 1) offset') value2 offset2
      x = split1_byte value1.
Proof.
  intros n m.
  revert m n.
  induction m as [|m'].
  + intros n mem value1 value2 offset1 offset2 x H_no_overlap H_x_eq_offset1.
    simpl.
    rewrite H_x_eq_offset1.
    reflexivity.
  + intros n mem value1 value2 offset1 offset2 x H_no_overlap H_x_eq_offset1.
    simpl.

    assert(H_x_offset2: (x =? offset2)%N = false). apply (x_eq_offset_false_implied n offset1 offset2 x H_no_overlap H_x_eq_offset1).
    
    assert(H_no_overlap':  (offset1 + N.of_nat (S n) <=? offset2+1)%N = true).
       apply (n_le_m_implies_n_le_m_plus_1 (offset1 + N.of_nat (S n))%N offset2 H_no_overlap).
    
    rewrite H_x_offset2.
    pose proof (IHm' n mem value1 (split2_byte value2) offset1 (offset2+1)%N x H_no_overlap' H_x_eq_offset1) as IHm'_0.
    apply IHm'_0.
Qed.

Lemma update_same_address_mstore'_aux'':
  forall n m mem (value1: word (S n*8)) (value2: word (m*8)) offset1 offset2 x,
    (offset1+(N.of_nat (S n)) <=? offset2)%N = true ->
    (x =? offset1)%N = false ->
    mstore'
      (fun offset' : N =>
         if (offset' =? offset1)%N
         then split1_byte value1
         else mstore' mem (split2_byte value1) (offset1 + 1) offset') value2 offset2
      x = mstore'
            (mstore' mem (split2_byte value1) (offset1 + 1)) value2 offset2 x.
Proof.
  intros n m.
  revert m n.
  induction m as [|m' IHm'].
  + intros n nmem value1 value2 offset1 offset2 x H_no_overlap H_x_offset1.
    simpl.
    rewrite H_x_offset1.
    reflexivity.
  + intros n mem value1 value2 offset1 offset2 x H_no_overlap H_x_offset1.
    simpl.
    destruct (x =? offset2)%N eqn:E_x_offset2; try reflexivity.

    assert(H_no_overlap':  (offset1 + N.of_nat (S n) <=? offset2+1)%N = true). 
       apply (n_le_m_implies_n_le_m_plus_1 (offset1 + N.of_nat (S n))%N offset2 H_no_overlap).

    pose proof (IHm' n mem value1 (split2_byte value2) offset1 (offset2+1)%N x H_no_overlap' H_x_offset1) as IHm'_0.

    apply IHm'_0.     
Qed.
  

  Lemma mstore_non_overlap_updates:
    forall n m mem offset1 (value1 : word (n*8)) offset2 (value2: word (m*8)),
      (offset1+(N.of_nat n) <=? offset2)%N = true ->
      mstore' (mstore' mem value1 offset1) value2 offset2 = 
        mstore' (mstore' mem value2 offset2) value1 offset1. 
  Proof.
    induction n as [|n' IHn'].
    + intros m mem offset1 value1 offset2 value2 H_no_overlap.
      unfold mstore' at 2.
      unfold mstore' at 2.
      reflexivity.
    + intros m mem offset1 value1 offset2 value2 H_no_overlap.
      apply functional_extensionality.
      intro x.
      simpl.
      destruct (x =? offset1)%N eqn:E_x_offset1.
      ++ rewrite update_same_address_mstore'_aux.
         reflexivity.
         apply H_no_overlap.
         apply E_x_offset1.
      ++ rewrite update_same_address_mstore'_aux''.
         
         assert (H_no_overlap': (offset1 + 1 + N.of_nat n' <=? offset2)%N = true). rewrite <- N_x_nat_of_Si. apply H_no_overlap.

         pose proof (IHn' m mem (offset1 + 1)%N (split2_byte value1) offset2 value2 H_no_overlap') as IHn'_0.
         rewrite IHn'_0.
         reflexivity.
         apply H_no_overlap.
         apply E_x_offset1.
  Qed.
       
  
    Lemma swap_memory_update_snd:
    forall smem u1 u2 maxidx sb instk_height ops,
      valid_smemory instk_height maxidx smem ->
      valid_smemory_update instk_height maxidx u1 ->
      valid_smemory_update instk_height maxidx u2 ->
      valid_bindings instk_height maxidx sb ops ->
      swap_memory_update u1 u2 maxidx sb = true ->
      forall stk mem strg ctx, 
             length stk = instk_height ->
             exists mem' : memory,
               eval_smemory (u1::u2::smem) maxidx sb stk mem strg ctx ops = Some mem' /\
                 eval_smemory (u2::u1::smem) maxidx sb stk mem strg ctx ops = Some mem'.
    Proof.
      intros smem u1 u2 maxidx sb instk_height ops.
      intros H_valid_smem H_valid_u1 H_valid_u2 H_valid_sb H_swap_mem_u.
      intros stk mem strg ctx.
      intros H_stk_len.
     
      pose proof (valid_smemory_when_extended_with_valid_update instk_height maxidx u1 smem H_valid_u1 H_valid_smem) as H_valid_u1_smem.

      pose proof (valid_smemory_when_extended_with_valid_update instk_height maxidx u2 (u1::smem) H_valid_u2 H_valid_u1_smem) as H_valid_u2_u1_smem.

      pose proof (valid_smemory_when_extended_with_valid_update instk_height maxidx u2 smem H_valid_u2 H_valid_smem) as H_valid_u2_smem.

      pose proof (valid_smemory_when_extended_with_valid_update instk_height maxidx u1 (u2::smem) H_valid_u1 H_valid_u2_smem) as H_valid_u1_u2_smem.

      pose proof (eval_smemory_succ instk_height maxidx sb stk mem strg ctx ops (u1::u2::smem) (eq_sym H_stk_len) H_valid_u1_u2_smem H_valid_sb) as H_eval_u1_u2_smem.

      pose proof (eval_smemory_succ instk_height maxidx sb stk mem strg ctx ops (u2::u1::smem) (eq_sym H_stk_len) H_valid_u2_u1_smem H_valid_sb) as H_eval_u2_u1_smem.

      destruct H_eval_u1_u2_smem as [mem1 H_eval_u1_u2_smem].
      destruct H_eval_u2_u1_smem as [mem2 H_eval_u2_u1_smem].
 
      unfold eval_smemory in H_eval_u1_u2_smem.

      destruct (map_option (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx sb ops)) (u1 :: u2 :: smem)) as [updates1|] eqn:E_mo1; try discriminate.

      injection H_eval_u1_u2_smem as H_eval_u1_u2_smem.

      unfold eval_smemory in H_eval_u2_u1_smem.

      destruct (map_option (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx sb ops)) (u2 :: u1 :: smem)) as [updates2|] eqn:E_mo2; try discriminate.

      injection H_eval_u2_u1_smem as H_eval_u2_u1_smem.

      pose proof (map_option_split_2 (memory_update sstack_val) (memory_update EVMWord) (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx sb ops)) smem updates1 u1 u2 E_mo1) as E_mo1_split.
      destruct E_mo1_split as [u1v1 [u2v1 [updates1' [H_updates1 [H_u1v1 [H_u2v1 H_mo1_0]]]]]].

      pose proof (map_option_split_2 (memory_update sstack_val) (memory_update EVMWord) (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx sb ops)) smem updates2 u2 u1 E_mo2) as E_mo2_split.
      destruct E_mo2_split as [u2v2 [u1v2 [updates2' [H_updates2 [H_u2v2 [H_u1v2 H_mo2_0]]]]]].
      
      assert(H_updates1'_eq_updates2': updates1' = updates2'). rewrite  H_mo2_0 in H_mo1_0. injection H_mo1_0 as H_mo1_0. rewrite H_mo1_0. reflexivity.

      assert(H_u1v1_u1v2: u1v1=u1v2). rewrite H_u1v2 in H_u1v1. injection H_u1v1 as H_u1v1. rewrite H_u1v1. reflexivity. 

      assert(H_u2v1_u2v2: u2v1=u2v2). rewrite H_u2v2 in H_u2v1. injection H_u2v1 as H_u2v1. rewrite H_u2v1. reflexivity.
      
      rewrite <- H_updates1'_eq_updates2' in H_updates2.
      rewrite <- H_u1v1_u1v2 in H_updates2.
      rewrite <- H_u2v1_u2v2 in H_updates2.
      
      rewrite H_updates1 in H_eval_u1_u2_smem.
      rewrite H_updates2 in H_eval_u2_u1_smem.

      unfold update_memory in H_eval_u1_u2_smem.
      fold update_memory in H_eval_u1_u2_smem.

      unfold update_memory in H_eval_u2_u1_smem.
      fold update_memory in H_eval_u2_u1_smem.

      destruct u1 as [soffset1 svalue1|soffset1 svalue1] eqn:E_u1; 
        destruct u2 as [soffset2 svalue2|soffset2 svalue2] eqn:E_u2.

      + unfold instantiate_memory_update in H_u1v1.
        destruct (eval_sstack_val soffset1 stk mem strg ctx maxidx sb ops) as [offset1_v|] eqn:E_eval_soffset1; try discriminate.
        destruct (eval_sstack_val svalue1 stk mem strg ctx maxidx sb ops) as [svalue1_v|] eqn:E_eval_svalue1; try discriminate.
        
        injection H_u1v1 as H_u1v1.
        rewrite <- H_u1v1 in H_eval_u1_u2_smem.
        rewrite <- H_u1v1 in H_eval_u2_u1_smem.

        unfold instantiate_memory_update in H_u2v1.
        destruct (eval_sstack_val soffset2 stk mem strg ctx maxidx sb ops) as [offset2_v|] eqn:E_eval_soffset2; try discriminate.
        destruct (eval_sstack_val svalue2 stk mem strg ctx maxidx sb ops) as [svalue2_v|] eqn:E_eval_svalue2; try discriminate.
        injection H_u2v1 as H_u2v1.
        rewrite <- H_u2v1 in H_eval_u2_u1_smem.
        rewrite <- H_u2v1 in H_eval_u1_u2_smem.

        simpl in H_eval_u1_u2_smem.
        simpl in H_eval_u2_u1_smem.
        unfold mstore in H_eval_u1_u2_smem.
        unfold mstore in H_eval_u2_u1_smem.

        unfold eval_smemory.
        rewrite E_mo1.
        rewrite E_mo2.
        rewrite H_updates1.
        rewrite H_updates2.
        rewrite <- H_u1v1.
        rewrite <- H_u2v1.
        unfold update_memory.
        fold update_memory.
        unfold update_memory'.
        unfold mstore.

        unfold swap_memory_update in H_swap_mem_u.
        destruct (follow_in_smap soffset1 maxidx sb) eqn:E_follow_in_smap_soffset1; try discriminate.
        destruct f; try discriminate.
        destruct smv; try discriminate.
        destruct val; try discriminate.
        destruct (follow_in_smap soffset2 maxidx sb)  eqn:E_follow_in_smap_soffset2; try discriminate.
        destruct f; try discriminate.
        destruct smv; try discriminate.
        destruct val0; try discriminate.

        assert(E_eval_soffset1_aux := E_eval_soffset1).
        unfold eval_sstack_val in E_eval_soffset1_aux.
        unfold eval_sstack_val' in E_eval_soffset1_aux.
        fold eval_sstack_val' in E_eval_soffset1_aux.
        rewrite E_follow_in_smap_soffset1 in E_eval_soffset1_aux.
        injection E_eval_soffset1_aux as E_eval_soffset1_aux.

        assert(E_eval_soffset2_aux := E_eval_soffset2).
        unfold eval_sstack_val in E_eval_soffset2_aux.
        unfold eval_sstack_val' in E_eval_soffset2_aux.
        fold eval_sstack_val' in E_eval_soffset2_aux.
        rewrite E_follow_in_smap_soffset2 in E_eval_soffset2_aux.
        injection E_eval_soffset2_aux as E_eval_soffset2_aux.
        
        rewrite E_eval_soffset1_aux in H_swap_mem_u.
        rewrite E_eval_soffset2_aux in H_swap_mem_u.

        
        assert( H_swap_mem_u_le: (wordToN offset2_v + 32 <=? wordToN offset1_v)%N = true).
          pose proof (n_lt_m_implies_n_plus_1_le_m (wordToN offset2_v + 31) (wordToN offset1_v) H_swap_mem_u) as H_swap_mem_u_le_aux.
          rewrite <- N.add_assoc in H_swap_mem_u_le_aux.
          simpl in H_swap_mem_u_le_aux.
          apply H_swap_mem_u_le_aux.
          

        pose proof (mstore_non_overlap_updates BytesInEVMWord BytesInEVMWord (update_memory mem updates1') (wordToN offset2_v) svalue2_v (wordToN offset1_v) svalue1_v H_swap_mem_u_le) as H_mstore_non_overlap_updates.
        rewrite H_mstore_non_overlap_updates.
        exists mem2.
        split; rewrite H_eval_u2_u1_smem; reflexivity.      
                                                                                  
      + unfold instantiate_memory_update in H_u1v1.
        destruct (eval_sstack_val soffset1 stk mem strg ctx maxidx sb ops) as [offset1_v|] eqn:E_eval_soffset1; try discriminate.
        destruct (eval_sstack_val svalue1 stk mem strg ctx maxidx sb ops) as [svalue1_v|] eqn:E_eval_svalue1; try discriminate.
        
        injection H_u1v1 as H_u1v1.
        rewrite <- H_u1v1 in H_eval_u1_u2_smem.
        rewrite <- H_u1v1 in H_eval_u2_u1_smem.

        unfold instantiate_memory_update in H_u2v1.
        destruct (eval_sstack_val soffset2 stk mem strg ctx maxidx sb ops) as [offset2_v|] eqn:E_eval_soffset2; try discriminate.
        destruct (eval_sstack_val svalue2 stk mem strg ctx maxidx sb ops) as [svalue2_v|] eqn:E_eval_svalue2; try discriminate.
        injection H_u2v1 as H_u2v1.
        rewrite <- H_u2v1 in H_eval_u2_u1_smem.
        rewrite <- H_u2v1 in H_eval_u1_u2_smem.

        simpl in H_eval_u1_u2_smem.
        simpl in H_eval_u2_u1_smem.
        unfold mstore in H_eval_u1_u2_smem.
        unfold mstore in H_eval_u2_u1_smem.

        unfold eval_smemory.
        rewrite E_mo1.
        rewrite E_mo2.
        rewrite H_updates1.
        rewrite H_updates2.
        rewrite <- H_u1v1.
        rewrite <- H_u2v1.
        unfold update_memory.
        fold update_memory.
        unfold update_memory'.
        unfold mstore.

        unfold swap_memory_update in H_swap_mem_u.
        destruct (follow_in_smap soffset1 maxidx sb) eqn:E_follow_in_smap_soffset1; try discriminate.
        destruct f; try discriminate.
        destruct smv; try discriminate.
        destruct val; try discriminate.
        destruct (follow_in_smap soffset2 maxidx sb)  eqn:E_follow_in_smap_soffset2; try discriminate.
        destruct f; try discriminate.
        destruct smv; try discriminate.
        destruct val0; try discriminate.

        assert(E_eval_soffset1_aux := E_eval_soffset1).
        unfold eval_sstack_val in E_eval_soffset1_aux.
        unfold eval_sstack_val' in E_eval_soffset1_aux.
        fold eval_sstack_val' in E_eval_soffset1_aux.
        rewrite E_follow_in_smap_soffset1 in E_eval_soffset1_aux.
        injection E_eval_soffset1_aux as E_eval_soffset1_aux.

        assert(E_eval_soffset2_aux := E_eval_soffset2).
        unfold eval_sstack_val in E_eval_soffset2_aux.
        unfold eval_sstack_val' in E_eval_soffset2_aux.
        fold eval_sstack_val' in E_eval_soffset2_aux.
        rewrite E_follow_in_smap_soffset2 in E_eval_soffset2_aux.
        injection E_eval_soffset2_aux as E_eval_soffset2_aux.
        
        rewrite E_eval_soffset1_aux in H_swap_mem_u.
        rewrite E_eval_soffset2_aux in H_swap_mem_u.
        
        assert( H_swap_mem_u_le: (wordToN offset2_v + 1 <=? wordToN offset1_v)%N = true).
          apply n_lt_m_implies_n_plus_1_le_m. apply H_swap_mem_u.

        pose proof (mstore_non_overlap_updates 1 BytesInEVMWord (update_memory mem updates1') (wordToN offset2_v) (split1_byte (svalue2_v : word ((S (pred BytesInEVMWord))*8))) (wordToN offset1_v) svalue1_v H_swap_mem_u_le) as H_mstore_non_overlap_updates.
        rewrite H_mstore_non_overlap_updates.
        exists mem2.
        split; rewrite <- H_eval_u2_u1_smem; reflexivity.      

      + unfold instantiate_memory_update in H_u1v1.
        destruct (eval_sstack_val soffset1 stk mem strg ctx maxidx sb ops) as [offset1_v|] eqn:E_eval_soffset1; try discriminate.
        destruct (eval_sstack_val svalue1 stk mem strg ctx maxidx sb ops) as [svalue1_v|] eqn:E_eval_svalue1; try discriminate.
        
        injection H_u1v1 as H_u1v1.
        rewrite <- H_u1v1 in H_eval_u1_u2_smem.
        rewrite <- H_u1v1 in H_eval_u2_u1_smem.

        unfold instantiate_memory_update in H_u2v1.
        destruct (eval_sstack_val soffset2 stk mem strg ctx maxidx sb ops) as [offset2_v|] eqn:E_eval_soffset2; try discriminate.
        destruct (eval_sstack_val svalue2 stk mem strg ctx maxidx sb ops) as [svalue2_v|] eqn:E_eval_svalue2; try discriminate.
        injection H_u2v1 as H_u2v1.
        rewrite <- H_u2v1 in H_eval_u2_u1_smem.
        rewrite <- H_u2v1 in H_eval_u1_u2_smem.

        simpl in H_eval_u1_u2_smem.
        simpl in H_eval_u2_u1_smem.
        unfold mstore in H_eval_u1_u2_smem.
        unfold mstore in H_eval_u2_u1_smem.

        unfold eval_smemory.
        rewrite E_mo1.
        rewrite E_mo2.
        rewrite H_updates1.
        rewrite H_updates2.
        rewrite <- H_u1v1.
        rewrite <- H_u2v1.
        unfold update_memory.
        fold update_memory.
        unfold update_memory'.
        unfold mstore.

        unfold swap_memory_update in H_swap_mem_u.
        destruct (follow_in_smap soffset1 maxidx sb) eqn:E_follow_in_smap_soffset1; try discriminate.
        destruct f; try discriminate.
        destruct smv; try discriminate.
        destruct val; try discriminate.
        destruct (follow_in_smap soffset2 maxidx sb)  eqn:E_follow_in_smap_soffset2; try discriminate.
        destruct f; try discriminate.
        destruct smv; try discriminate.
        destruct val0; try discriminate.

        assert(E_eval_soffset1_aux := E_eval_soffset1).
        unfold eval_sstack_val in E_eval_soffset1_aux.
        unfold eval_sstack_val' in E_eval_soffset1_aux.
        fold eval_sstack_val' in E_eval_soffset1_aux.
        rewrite E_follow_in_smap_soffset1 in E_eval_soffset1_aux.
        injection E_eval_soffset1_aux as E_eval_soffset1_aux.

        assert(E_eval_soffset2_aux := E_eval_soffset2).
        unfold eval_sstack_val in E_eval_soffset2_aux.
        unfold eval_sstack_val' in E_eval_soffset2_aux.
        fold eval_sstack_val' in E_eval_soffset2_aux.
        rewrite E_follow_in_smap_soffset2 in E_eval_soffset2_aux.
        injection E_eval_soffset2_aux as E_eval_soffset2_aux.
        
        rewrite E_eval_soffset1_aux in H_swap_mem_u.
        rewrite E_eval_soffset2_aux in H_swap_mem_u.
        
        assert( H_swap_mem_u_le: (wordToN offset2_v + 32 <=? wordToN offset1_v)%N = true).
          pose proof (n_lt_m_implies_n_plus_1_le_m (wordToN offset2_v + 31) (wordToN offset1_v) H_swap_mem_u) as H_swap_mem_u_le_aux.
          rewrite <- N.add_assoc in H_swap_mem_u_le_aux.
          simpl in H_swap_mem_u_le_aux.
          apply H_swap_mem_u_le_aux.
               
        pose proof (mstore_non_overlap_updates BytesInEVMWord 1 (update_memory mem updates1') (wordToN offset2_v) svalue2_v (wordToN offset1_v) (split1_byte (svalue1_v : word ((S (pred BytesInEVMWord))*8))) H_swap_mem_u_le) as H_mstore_non_overlap_updates.
        rewrite H_mstore_non_overlap_updates.
        exists mem2.
        split; rewrite <- H_eval_u2_u1_smem; reflexivity.      
        
      + unfold instantiate_memory_update in H_u1v1.
        destruct (eval_sstack_val soffset1 stk mem strg ctx maxidx sb ops) as [offset1_v|] eqn:E_eval_soffset1; try discriminate.
        destruct (eval_sstack_val svalue1 stk mem strg ctx maxidx sb ops) as [svalue1_v|] eqn:E_eval_svalue1; try discriminate.
        
        injection H_u1v1 as H_u1v1.
        rewrite <- H_u1v1 in H_eval_u1_u2_smem.
        rewrite <- H_u1v1 in H_eval_u2_u1_smem.

        unfold instantiate_memory_update in H_u2v1.
        destruct (eval_sstack_val soffset2 stk mem strg ctx maxidx sb ops) as [offset2_v|] eqn:E_eval_soffset2; try discriminate.
        destruct (eval_sstack_val svalue2 stk mem strg ctx maxidx sb ops) as [svalue2_v|] eqn:E_eval_svalue2; try discriminate.
        injection H_u2v1 as H_u2v1.
        rewrite <- H_u2v1 in H_eval_u2_u1_smem.
        rewrite <- H_u2v1 in H_eval_u1_u2_smem.

        simpl in H_eval_u1_u2_smem.
        simpl in H_eval_u2_u1_smem.
        unfold mstore in H_eval_u1_u2_smem.
        unfold mstore in H_eval_u2_u1_smem.

        unfold eval_smemory.
        rewrite E_mo1.
        rewrite E_mo2.
        rewrite H_updates1.
        rewrite H_updates2.
        rewrite <- H_u1v1.
        rewrite <- H_u2v1.
        unfold update_memory.
        fold update_memory.
        unfold update_memory'.
        unfold mstore.

        unfold swap_memory_update in H_swap_mem_u.
        destruct (follow_in_smap soffset1 maxidx sb) eqn:E_follow_in_smap_soffset1; try discriminate.
        destruct f; try discriminate.
        destruct smv; try discriminate.
        destruct val; try discriminate.
        destruct (follow_in_smap soffset2 maxidx sb)  eqn:E_follow_in_smap_soffset2; try discriminate.
        destruct f; try discriminate.
        destruct smv; try discriminate.
        destruct val0; try discriminate.

        assert(E_eval_soffset1_aux := E_eval_soffset1).
        unfold eval_sstack_val in E_eval_soffset1_aux.
        unfold eval_sstack_val' in E_eval_soffset1_aux.
        fold eval_sstack_val' in E_eval_soffset1_aux.
        rewrite E_follow_in_smap_soffset1 in E_eval_soffset1_aux.
        injection E_eval_soffset1_aux as E_eval_soffset1_aux.

        assert(E_eval_soffset2_aux := E_eval_soffset2).
        unfold eval_sstack_val in E_eval_soffset2_aux.
        unfold eval_sstack_val' in E_eval_soffset2_aux.
        fold eval_sstack_val' in E_eval_soffset2_aux.
        rewrite E_follow_in_smap_soffset2 in E_eval_soffset2_aux.
        injection E_eval_soffset2_aux as E_eval_soffset2_aux.
        
        rewrite E_eval_soffset1_aux in H_swap_mem_u.
        rewrite E_eval_soffset2_aux in H_swap_mem_u.
        
        assert( H_swap_mem_u_le: (wordToN offset2_v + 1 <=? wordToN offset1_v)%N = true).
          apply n_lt_m_implies_n_plus_1_le_m. apply H_swap_mem_u.

        
        pose proof (mstore_non_overlap_updates 1 1 (update_memory mem updates1') (wordToN offset2_v) (split1_byte (svalue2_v : word ((S (pred BytesInEVMWord))*8))) (wordToN offset1_v) (split1_byte (svalue1_v : word ((S (pred BytesInEVMWord))*8))) H_swap_mem_u_le) as H_mstore_non_overlap_updates.
        rewrite H_mstore_non_overlap_updates.
        exists mem2.
        split; rewrite <- H_eval_u2_u1_smem; reflexivity.
    Qed.

    
  Lemma reorder_updates'_snd:
    forall maxidx sb instk_height ops,
      valid_bindings instk_height maxidx sb ops ->
      forall d smem b smem_r,
      valid_smemory instk_height maxidx smem ->
      reorder_updates' d smem maxidx sb = (b,smem_r) ->
      forall stk mem strg ctx, 
             length stk = instk_height ->
             exists mem' : memory,
               eval_smemory smem maxidx sb stk mem strg ctx ops = Some mem' /\
                 eval_smemory smem_r maxidx sb stk mem strg ctx ops = Some mem'.
  Proof.
    intros maxidx sb instk_height ops H_valid_sb.
    induction d as [|d' IHd'].
    + intros smem b smem_r H_valid_smem H_reorder'.
      intros stk mem strg ctx H_stk_len.
      simpl in H_reorder'.
      injection H_reorder' as H_b H_smem_r.
      rewrite <- H_smem_r.
      pose proof (eval_smemory_succ instk_height maxidx sb stk mem strg ctx ops smem (eq_sym H_stk_len) H_valid_smem H_valid_sb) as H_eval_smem.
      destruct H_eval_smem as [strg' H_eval_smem].
      exists strg'.
      split; apply H_eval_smem.
    + intros smem b smem_r H_valid_smem H_reorder'.
      intros stk mem strg ctx H_stk_len.
      simpl in H_reorder'.
      destruct smem as [|u1 smem'] eqn:E_smem.
      ++ injection H_reorder' as H_b H_smem_r.
         rewrite <- H_smem_r.
         exists mem.
         unfold eval_smemory.
         simpl.
         split; reflexivity.
      ++ destruct smem' as [|u2 smem''] eqn:E_smem'.
         +++ injection H_reorder' as H_b H_smem_r.
             rewrite <- H_smem_r.
             destruct u1 as [soffset1 svalue1|soffset1 svalue1] eqn:E_u1.
             ++++ simpl in H_valid_smem.
                  destruct H_valid_smem as [[H_valid_soffset1 H_valid_svalue1] _].

                  pose proof (eval_sstack_val'_succ (S maxidx) instk_height soffset1 stk mem strg ctx maxidx sb ops (eq_sym H_stk_len) H_valid_soffset1 H_valid_sb (gt_Sn_n maxidx)) as E_eval_soffset1.
                  destruct E_eval_soffset1 as [soffset1_v E_eval_soffset1].
                  pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue1 stk mem strg ctx maxidx sb ops (eq_sym H_stk_len) H_valid_svalue1 H_valid_sb (gt_Sn_n maxidx)) as E_eval_svalue1.
                  destruct E_eval_svalue1 as [svalue1_v E_eval_svalue1].
                  
                  (*             exists (fun key => if (key =? wordToN soffset1_v)%N then svalue1_v else mem key). *)
                  unfold eval_smemory.
                  unfold map_option.
                  unfold instantiate_memory_update.
                  unfold eval_sstack_val.
                  rewrite E_eval_soffset1.
                  rewrite E_eval_svalue1.
                  unfold update_memory.
                  exists (update_memory' mem (U_MSTORE EVMWord soffset1_v svalue1_v)).
                  split; reflexivity.
             ++++ simpl in H_valid_smem.
                  destruct H_valid_smem as [[H_valid_soffset1 H_valid_svalue1] _].

                  pose proof (eval_sstack_val'_succ (S maxidx) instk_height soffset1 stk mem strg ctx maxidx sb ops (eq_sym H_stk_len) H_valid_soffset1 H_valid_sb (gt_Sn_n maxidx)) as E_eval_soffset1.
                  destruct E_eval_soffset1 as [soffset1_v E_eval_soffset1].
                  pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue1 stk mem strg ctx maxidx sb ops (eq_sym H_stk_len) H_valid_svalue1 H_valid_sb (gt_Sn_n maxidx)) as E_eval_svalue1.
                  destruct E_eval_svalue1 as [svalue1_v E_eval_svalue1].
                  
                  unfold eval_smemory.
                  unfold map_option.
                  unfold instantiate_memory_update.
                  unfold eval_sstack_val.
                  rewrite E_eval_soffset1.
                  rewrite E_eval_svalue1.
                  unfold update_memory.
                  exists (update_memory' mem (U_MSTORE8 EVMWord soffset1_v svalue1_v)).
                  split; reflexivity.
             
         +++ destruct (swap_memory_update u1 u2 maxidx sb) eqn:E_swap.
             ++++ destruct (reorder_updates' d' (u1 :: smem'') maxidx sb) as [b' smem_r'] eqn:E_reorder'_rec.
                  injection H_reorder' as E_b E_smem_r.

                  simpl in H_valid_smem.
                  destruct H_valid_smem as [H_valid_u1 [H_valid_u2 H_valid_smem'']].
                   
                  pose proof (swap_memory_update_snd  smem'' u1 u2 maxidx sb instk_height ops H_valid_smem'' H_valid_u1 H_valid_u2 H_valid_sb E_swap stk mem strg ctx H_stk_len) as H_swap_memory_update_snd.

                  destruct H_swap_memory_update_snd as [strg_aux [H_eval_u1_u2_smem'' H_eval_u2_u1_smem'' ]].
		  rewrite <- H_eval_u2_u1_smem'' in H_eval_u1_u2_smem''.
                  rewrite H_eval_u1_u2_smem''.
 
                  pose proof (IHd' (u1 :: smem'') b' smem_r' (valid_smemory_when_extended_with_valid_update instk_height maxidx u1 smem'' H_valid_u1 H_valid_smem'') E_reorder'_rec stk mem strg ctx H_stk_len) as IHd'_0.
                  destruct IHd'_0 as [mem' [H_eval_u1_smem'' H_eval_smem_r']].
                  rewrite <- E_smem_r.
                  
                  unfold eval_smemory in H_eval_u1_smem''.
                  destruct (map_option (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx sb ops)) (u1 :: smem'')) as [updates1|] eqn:E_mo_1; try discriminate.
                  
                  unfold eval_smemory in H_eval_smem_r'.
                  destruct (map_option (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx sb ops)) smem_r') as [updates2|] eqn:E_mo_2; try discriminate.
                  
                  destruct u2 as [soffset2 svalue2|soffset2 svalue2] eqn:E_u2.
                  +++++ simpl in H_valid_u2.
                        destruct H_valid_u2 as [H_valid_soffset2 H_valid_svalue2].

                        pose proof (eval_sstack_val'_succ (S maxidx) instk_height soffset2 stk mem strg ctx maxidx sb ops (eq_sym H_stk_len) H_valid_soffset2 H_valid_sb (gt_Sn_n maxidx)) as E_eval_soffset2.
                        destruct E_eval_soffset2 as [soffset2_v E_eval_soffset2].
                        pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue2 stk mem strg ctx maxidx sb ops (eq_sym H_stk_len) H_valid_svalue2 H_valid_sb (gt_Sn_n maxidx)) as E_eval_svalue2.
                        destruct E_eval_svalue2 as [svalue2_v E_eval_svalue2].
                  
                        unfold eval_smemory.
                        unfold map_option.
                        repeat rewrite <- map_option_ho.
                        
                        unfold instantiate_memory_update at 1.
                        unfold eval_sstack_val at 1.
                        rewrite E_eval_soffset2.
                        unfold eval_sstack_val at 1.
                        rewrite E_eval_svalue2.
                        
                        unfold instantiate_memory_update at 3.
                        unfold eval_sstack_val at 3.
                        rewrite E_eval_soffset2.
                        unfold eval_sstack_val at 3.
                        rewrite E_eval_svalue2.
                        
                        unfold map_option in E_mo_1.
                        destruct (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx sb ops) u1) as [elem_val|] eqn:E_elem_val; try discriminate.
                  
                        repeat rewrite <- map_option_ho in E_mo_1.
                        rewrite E_mo_1.
                        rewrite E_mo_2.
                        
                        unfold update_memory.
                        fold update_memory.
                        
                        injection H_eval_u1_smem'' as H_eval_u1_smem''.
                        rewrite H_eval_u1_smem''.
                        injection H_eval_smem_r' as H_eval_smem_r'.
                        rewrite H_eval_smem_r'.
                        
                        exists (update_memory' mem' (U_MSTORE EVMWord soffset2_v svalue2_v)).
                        split; reflexivity.

                                          +++++ simpl in H_valid_u2.
                        destruct H_valid_u2 as [H_valid_soffset2 H_valid_svalue2].

                        pose proof (eval_sstack_val'_succ (S maxidx) instk_height soffset2 stk mem strg ctx maxidx sb ops (eq_sym H_stk_len) H_valid_soffset2 H_valid_sb (gt_Sn_n maxidx)) as E_eval_soffset2.
                        destruct E_eval_soffset2 as [soffset2_v E_eval_soffset2].
                        pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue2 stk mem strg ctx maxidx sb ops (eq_sym H_stk_len) H_valid_svalue2 H_valid_sb (gt_Sn_n maxidx)) as E_eval_svalue2.
                        destruct E_eval_svalue2 as [svalue2_v E_eval_svalue2].
                  
                        unfold eval_smemory.
                        unfold map_option.
                        repeat rewrite <- map_option_ho.
                        
                        unfold instantiate_memory_update at 1.
                        unfold eval_sstack_val at 1.
                        rewrite E_eval_soffset2.
                        unfold eval_sstack_val at 1.
                        rewrite E_eval_svalue2.
                        
                        unfold instantiate_memory_update at 3.
                        unfold eval_sstack_val at 3.
                        rewrite E_eval_soffset2.
                        unfold eval_sstack_val at 3.
                        rewrite E_eval_svalue2.
                        
                        unfold map_option in E_mo_1.
                        destruct (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx sb ops) u1) as [elem_val|] eqn:E_elem_val; try discriminate.
                  
                        repeat rewrite <- map_option_ho in E_mo_1.
                        rewrite E_mo_1.
                        rewrite E_mo_2.
                        
                        unfold update_memory.
                        fold update_memory.
                        
                        injection H_eval_u1_smem'' as H_eval_u1_smem''.
                        rewrite H_eval_u1_smem''.
                        injection H_eval_smem_r' as H_eval_smem_r'.
                        rewrite H_eval_smem_r'.
                        
                        exists (update_memory' mem' (U_MSTORE8 EVMWord soffset2_v svalue2_v)).
                        split; reflexivity.

             ++++ destruct (reorder_updates' d' (u2 :: smem'') maxidx sb) as [b' smem_r'] eqn:E_reorder'_rec.
                  simpl in H_valid_smem.
                  destruct H_valid_smem as [H_valid_u1 [H_valid_u2 H_valid_smem'']].

                  pose proof (IHd' (u2 :: smem'') b' smem_r' (valid_smemory_when_extended_with_valid_update instk_height maxidx u2 smem'' H_valid_u2 H_valid_smem'') E_reorder'_rec stk mem strg ctx H_stk_len) as IHd'_0.
                  destruct IHd'_0 as [strg' [H_eval_u2_smem'' H_eval_smem_r']].
                  injection H_reorder' as H_b' H_smem_r'.
                  rewrite <- H_smem_r'.

                  unfold eval_smemory in H_eval_u2_smem''.
                  destruct (map_option (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx sb ops)) (u2 :: smem'')) as [updates1|] eqn:E_mo_1; try discriminate.
                  
                  unfold eval_smemory in H_eval_smem_r'.
                  destruct (map_option (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx sb ops)) smem_r') as [updates2|] eqn:E_mo_2; try discriminate.
                  
                  destruct u1 as [soffset1 svalue1|soffset1 svalue1] eqn:E_u1.
                  +++++ simpl in H_valid_u1.
                        destruct H_valid_u1 as [H_valid_soffset1 H_valid_svalue1].

                        pose proof (eval_sstack_val'_succ (S maxidx) instk_height soffset1 stk mem strg ctx maxidx sb ops (eq_sym H_stk_len) H_valid_soffset1 H_valid_sb (gt_Sn_n maxidx)) as E_eval_soffset1.
                        destruct E_eval_soffset1 as [soffset1_v E_eval_soffset1].
                        pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue1 stk mem strg ctx maxidx sb ops (eq_sym H_stk_len) H_valid_svalue1 H_valid_sb (gt_Sn_n maxidx)) as E_eval_svalue1.
                        destruct E_eval_svalue1 as [svalue1_v E_eval_svalue1].
                        
                        unfold eval_smemory.
                        unfold map_option.
                        repeat rewrite <- map_option_ho.
                        
                        unfold instantiate_memory_update at 1.
                        unfold eval_sstack_val at 1.
                        rewrite E_eval_soffset1.
                        unfold eval_sstack_val at 1.
                        rewrite E_eval_svalue1.
                        
                        unfold instantiate_memory_update at 3.
                        unfold eval_sstack_val at 3.
                        rewrite E_eval_soffset1.
                        unfold eval_sstack_val at 3.
                        rewrite E_eval_svalue1.
                        
                        unfold map_option in E_mo_1.
                        destruct (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx sb ops) u2) as [elem_val|] eqn:E_elem_val; try discriminate.
                        
                        repeat rewrite <- map_option_ho in E_mo_1.
                        rewrite E_mo_1.
                        rewrite E_mo_2.
                        
                        unfold update_memory.
                        fold update_memory.
                        
                        injection H_eval_u2_smem'' as H_eval_u2_smem''.
                        rewrite H_eval_u2_smem''.
                        injection H_eval_smem_r' as H_eval_smem_r'.
                        rewrite H_eval_smem_r'.
                        
                        exists (update_memory' strg' (U_MSTORE EVMWord soffset1_v svalue1_v)).
                        split; reflexivity.
                  +++++ simpl in H_valid_u1.
                        destruct H_valid_u1 as [H_valid_soffset1 H_valid_svalue1].

                        pose proof (eval_sstack_val'_succ (S maxidx) instk_height soffset1 stk mem strg ctx maxidx sb ops (eq_sym H_stk_len) H_valid_soffset1 H_valid_sb (gt_Sn_n maxidx)) as E_eval_soffset1.
                        destruct E_eval_soffset1 as [soffset1_v E_eval_soffset1].
                        pose proof (eval_sstack_val'_succ (S maxidx) instk_height svalue1 stk mem strg ctx maxidx sb ops (eq_sym H_stk_len) H_valid_svalue1 H_valid_sb (gt_Sn_n maxidx)) as E_eval_svalue1.
                        destruct E_eval_svalue1 as [svalue1_v E_eval_svalue1].
                        
                        unfold eval_smemory.
                        unfold map_option.
                        repeat rewrite <- map_option_ho.
                        
                        unfold instantiate_memory_update at 1.
                        unfold eval_sstack_val at 1.
                        rewrite E_eval_soffset1.
                        unfold eval_sstack_val at 1.
                        rewrite E_eval_svalue1.
                        
                        unfold instantiate_memory_update at 3.
                        unfold eval_sstack_val at 3.
                        rewrite E_eval_soffset1.
                        unfold eval_sstack_val at 3.
                        rewrite E_eval_svalue1.
                        
                        unfold map_option in E_mo_1.
                        destruct (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx sb ops) u2) as [elem_val|] eqn:E_elem_val; try discriminate.
                        
                        repeat rewrite <- map_option_ho in E_mo_1.
                        rewrite E_mo_1.
                        rewrite E_mo_2.
                        
                        unfold update_memory.
                        fold update_memory.
                        
                        injection H_eval_u2_smem'' as H_eval_u2_smem''.
                        rewrite H_eval_u2_smem''.
                        injection H_eval_smem_r' as H_eval_smem_r'.
                        rewrite H_eval_smem_r'.
                        
                        exists (update_memory' strg' (U_MSTORE8 EVMWord soffset1_v svalue1_v)).
                        split; reflexivity.
                        
  Qed.
  
  
    Lemma reorder_memory_updates_valid:
    forall maxidx sb instk_height ops,
      valid_bindings instk_height maxidx sb ops ->
      forall d n smem smem_r,
      valid_smemory instk_height maxidx smem ->
      reorder_memory_updates d n smem maxidx sb = smem_r ->
      valid_smemory instk_height maxidx smem_r.
    Proof.
    intros maxidx sb instk_height ops H_valid_sb.
    induction d as [|d' IHd'].
    + intros n smem smem' H_valid_smem H_reorder.
      simpl in H_reorder.
      rewrite <- H_reorder.
      apply H_valid_smem.
    + intros n smem smem_r H_valid_smem H_reorder.
      unfold reorder_memory_updates in H_reorder.
      fold reorder_memory_updates in H_reorder.
      destruct (reorder_updates' n smem maxidx sb) as [changed smem'] eqn:E_reorder_update'.
      pose proof (reorder_updates'_valid maxidx sb instk_height ops H_valid_sb n smem changed smem' H_valid_smem E_reorder_update') as H_valid_smem'.
      destruct changed.
      ++ pose proof (IHd' n smem' smem_r H_valid_smem' H_reorder) as H_valid_smem_r.
         apply H_valid_smem_r.
      ++ rewrite <- H_reorder.
         apply H_valid_smem'.
Qed.


    
  Lemma reorder_memory_updates_snd:
    forall maxidx sb instk_height ops,
      valid_bindings instk_height maxidx sb ops ->
      forall d n smem smem_r,
        valid_smemory instk_height maxidx smem ->
        reorder_memory_updates d n smem maxidx sb = smem_r ->
        forall stk mem strg ctx, 
          length stk = instk_height ->
          exists mem' : memory,
            eval_smemory smem maxidx sb stk mem strg ctx ops = Some mem' /\
            eval_smemory smem_r maxidx sb stk mem strg ctx ops = Some mem'.
  Proof.
    intros maxidx sb instk_height ops H_valid_sb.
    induction d as [|d' IHd'].
    + intros n smem smem' H_valid_smem H_reorder stk mem strg ctx H_stk_len.
      simpl in H_reorder.
      rewrite <- H_reorder.
      pose proof (eval_smemory_succ instk_height maxidx sb stk mem strg ctx ops smem (eq_sym H_stk_len) H_valid_smem H_valid_sb) as H_eval_smem.
      destruct H_eval_smem as [strg' H_eval_smem].
      exists strg'.
      split; apply H_eval_smem.
    + intros n smem smem' H_valid_smem H_reorder stk mem strg ctx H_stk_len.
      simpl in H_reorder.
      destruct (reorder_updates' n smem maxidx sb) as [changed smem_r] eqn:E_reorder_updates'.
     
      pose proof (reorder_updates'_snd maxidx sb instk_height ops H_valid_sb n smem changed smem_r H_valid_smem E_reorder_updates' stk mem strg ctx H_stk_len) as H_reorder_updates'_snd.
      destruct H_reorder_updates'_snd as [strg' [H_eval_smem H_eval_smem_r]].
      
      destruct changed eqn:E_changed.
      ++ pose proof (reorder_updates'_valid maxidx sb instk_height ops H_valid_sb n smem true smem_r H_valid_smem E_reorder_updates') as H_valid_smem_r.

         pose proof (IHd' n smem_r smem' H_valid_smem_r H_reorder stk mem strg ctx H_stk_len) as IHd'_0.
         destruct IHd'_0 as [strg'' [H_eval_smem_r_bis H_eval_smem']].
         exists strg'.

         rewrite H_eval_smem_r in H_eval_smem_r_bis.
         injection H_eval_smem_r_bis as H_strg'_eq_strg''.
         rewrite <- H_strg'_eq_strg'' in H_eval_smem'.
         split.
         +++ apply H_eval_smem.
         +++ apply H_eval_smem'.
         
      ++ rewrite <- H_reorder.
         exists strg'.
         split.
         +++ apply H_eval_smem.
         +++ apply H_eval_smem_r.
  Qed.
  
  Theorem po_memory_cmp_snd:
    safe_smemory_cmp_ext_wrt_sstack_value_cmp po_memory_cmp.
  Proof.
  Admitted.
  (*
    unfold safe_smemory_cmp_ext_wrt_sstack_value_cmp.
    unfold safe_smemory_cmp_ext_d.
    unfold safe_smemory_cmp.

    intros d sstack_val_cmp H_sstack_val_cmp_snd d' H_d'_le_d smem1 smem2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_sb1 H_valid_sb2 H_valid_smem1 H_valid_smem2 H_po_cmp stk mem strg ctx H_stk_len.

    unfold po_memory_cmp in H_po_cmp.
    destruct (length smem1 =? length smem2); try discriminate.
    

    remember (reorder_memory_updates (length smem1) (length smem1) smem1 maxidx1 sb1) as smem1_r.
    remember (reorder_memory_updates (length smem2) (length smem2) smem2 maxidx2 sb2) as smem2_r.

    pose proof (reorder_memory_updates_snd maxidx1 sb1 instk_height ops H_valid_sb1 (length smem1) (length smem1) smem1 smem1_r H_valid_smem1 (eq_sym Heqsmem1_r) stk mem strg ctx H_stk_len) as H_reorder_memory_updates_snd_smem1_r.
    
    pose proof (reorder_memory_updates_valid maxidx1 sb1 instk_height ops H_valid_sb1 (length smem1) (length smem1) smem1 smem1_r H_valid_smem1 (eq_sym Heqsmem1_r)) as H_valid_smem1_r.

    destruct H_reorder_memory_updates_snd_smem1_r as [mem1' [H_eval_smem1 H_eval_smem1_r]].


    pose proof (reorder_memory_updates_snd maxidx2 sb2 instk_height ops H_valid_sb2 (length smem2) (length smem2) smem2 smem2_r H_valid_smem2 (eq_sym Heqsmem2_r) stk mem strg ctx H_stk_len) as H_reorder_memory_updates_snd_smem2_r.
    pose proof (reorder_memory_updates_valid maxidx2 sb2 instk_height ops H_valid_sb2 (length smem2) (length smem2) smem2 smem2_r H_valid_smem2 (eq_sym Heqsmem2_r)) as H_valid_smem2_r.

    destruct H_reorder_memory_updates_snd_smem2_r as [mem2' [H_eval_smem2 H_eval_smem2_r]].

    pose proof (basic_memory_cmp_snd) as H_basic_memory_cmp_snd.
    unfold safe_smemory_cmp_ext_wrt_sstack_value_cmp in H_basic_memory_cmp_snd.
    unfold safe_smemory_cmp_ext_d in H_basic_memory_cmp_snd.
    unfold safe_smemory_cmp in H_basic_memory_cmp_snd.


    pose proof (H_basic_memory_cmp_snd d sstack_val_cmp H_sstack_val_cmp_snd d' H_d'_le_d smem1_r smem2_r maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_sb1 H_valid_sb2 H_valid_smem1_r H_valid_smem2_r H_po_cmp stk mem strg ctx H_stk_len) as H_basic_cmp_snd.

    destruct H_basic_cmp_snd as [mem' [H_eval_smem1_r_bis H_eval_smem2_r_bis]].
    exists mem1'.
    split.

    + apply H_eval_smem1.
    + rewrite H_eval_smem2.
      rewrite H_eval_smem2_r_bis in H_eval_smem2_r.
      injection H_eval_smem2_r as H_eval_smem2_r.
      rewrite H_eval_smem1_r_bis in H_eval_smem1_r.
      injection H_eval_smem1_r as H_eval_smem1_r.
      rewrite <- H_eval_smem2_r.
      rewrite <- H_eval_smem1_r.
      reflexivity.
  Qed.
*)

End MemoryCmpImplSoundness.

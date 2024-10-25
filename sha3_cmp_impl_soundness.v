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

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.symbolic_state_cmp.
Import SymbolicStateCmp.

Require Import FORVES.sha3_cmp_impl.
Import SHA3CmpImpl.

Require Import FORVES.eval_common.
Import EvalCommon.

Require Import FORVES.memory_cmp_impl_soundness.
Import MemoryCmpImplSoundness.

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Module SHA3CmpImplSoundness.


  Lemma trivial_sha3_cmp_snd:
    safe_sha3_cmp_ext_wrt_sstack_value_cmp trivial_sha3_cmp.
  Proof.
    unfold safe_sha3_cmp_ext_wrt_sstack_value_cmp.
    unfold safe_sha3_cmp_ext_d.
    unfold safe_sha3_cmp.
    unfold trivial_sha3_cmp.
    intros.
    discriminate.
  Qed.


  Lemma N_n_Sm_le_p_imp_m_lt_p:
    forall (m: nat) (n p: N),
      (n + N.of_nat (S m) <= p -> n<p)%N.
  Proof.
    intros m n p H.
    (* *)
    assert(H0: (N.of_nat (S m) > 0)%N). rewrite N.gt_lt_iff. apply Nlt_in. simpl. intuition.
    (* *)

    (* *)
    assert (H1: (n < n + N.of_nat (S m))%N). rewrite N.gt_lt_iff in H0. pose proof (N.lt_add_pos_r (N.of_nat (S m)) n H0) as H2. apply H2.
    (* *)

    pose proof (N.lt_le_trans n (n + N.of_nat (S m)) p H1 H) as H2.
    apply H2.
  Qed.
  
  Lemma mload_''_remove_first_update:
    forall (size: nat) (offset0 offset1: N) v mem,
    (offset0 < offset1)%N ->
       mload'' (fun offset : N => if (offset =? offset0)%N then v else mem offset) offset1 size =
         mload'' mem offset1 size.
  Proof.
    induction size as [|size' IHsize'].
    + intros offset0 offset1 v mem H_b.
      simpl.
      reflexivity.
    + intros offset0 offset1 v mem H_b.
      unfold mload''.
      fold mload''.
      pose proof (@or_introl (offset0 < offset1)%N (offset1 < offset0)%N H_b) as H_b_ext.
      apply N.lt_gt_cases in H_b_ext.
      rewrite <- N.eqb_neq in H_b_ext.
      rewrite N.eqb_sym.
      rewrite H_b_ext.
      apply N.lt_lt_succ_r in H_b as H_b2.
      rewrite <- N.add_1_r in H_b2.     
      pose proof (IHsize' offset0 (offset1+1)%N v mem H_b2) as IHsize'_0.
      rewrite  IHsize'_0.
      reflexivity.
  Qed.

  Lemma mload''_mstore'_out_of_slot'_1:
    forall (sz: nat) mem (offset offset': N) (size: nat) (value: word (sz*8)),
    (offset' + (N.of_nat sz) <= offset )%N ->
    exists v,
      mload'' mem offset size = v /\
      mload'' (mstore' mem value offset') offset size = v.
  Proof.
    induction sz as [|sz' IHsz'].
    + intros mem offset offset' size value H_b.
      simpl.
      exists (mload'' mem offset size).
      split; reflexivity.
    + intros mem offset offset' size value H_b.
      simpl.

      assert (H_offset'_lt_offsset: (offset' < offset)%N). pose proof (N_n_Sm_le_p_imp_m_lt_p sz' offset' offset H_b) as H0. apply H0.
      
      
      pose proof (mload_''_remove_first_update size offset' offset (split1_byte value) (mstore' mem (split2_byte value) (offset' + 1)) H_offset'_lt_offsset) as H_mload_''_remove_first_update.
      rewrite H_mload_''_remove_first_update.
      
      assert( H_bb : (offset' + 1 + N.of_nat sz' <= offset)%N). rewrite Nat2N.inj_succ in H_b. simpl in H_b. rewrite <- N.add_1_l in H_b. rewrite N.add_assoc in H_b. apply H_b.
      
      pose proof (IHsz' mem offset (offset' + 1)%N size (split2_byte value) H_bb) as IHsz'_0.
      destruct IHsz'_0 as [v' IHsz'_0].
      exists v'.
      apply IHsz'_0.
Qed.

  
    Lemma mem'_mstore'_out_of_slot'_1:
    forall (sz: nat) mem (offset offset': N) (value: word (sz*8)),
      (offset < offset')%N ->
      exists v,
        mem offset = v /\
          (mstore' mem value offset') offset = v.
  Proof.
    induction sz as [|sz' IHsz'].
    + intros mem offset offset' value H_b.
      simpl.
      exists (mem offset).
      split; reflexivity.
    + intros mem offset offset' value H_b.
      simpl.

      (* *)
      assert(H_offset_neq_offset': (offset =? offset' = false)%N).
        pose proof (@or_introl (offset < offset')%N (offset' < offset)%N H_b) as H_b_ext.
        apply N.lt_gt_cases in H_b_ext.
        rewrite <- N.eqb_neq in H_b_ext.
        apply H_b_ext.
      (* *)
      
      rewrite H_offset_neq_offset'.
      assert(H_bb: (offset < offset'+1)%N). apply N.lt_lt_add_r. apply H_b.
      
      pose proof (IHsz' mem offset (offset'+1)%N (split2_byte value) H_bb) as IHsz'_0.
      destruct IHsz'_0 as [v' [IHsz'_0 IHsz'_1]].
      rewrite IHsz'_0.
      rewrite IHsz'_1.
      exists v'.
      split; reflexivity.
Qed.

  
  Lemma mload''_mstore'_out_of_slot'_2:
    forall (size: nat)  (sz: nat) mem (offset offset': N) (value: word (sz*8)),
    (offset + (N.of_nat size) <= offset')%N ->
    exists v,
      mload'' mem offset size = v /\
      mload'' (mstore' mem value offset') offset size = v.
  Proof.
    induction size as [|size' IHsize'].
    + intros sz mem offset offset' value H_b.
      simpl.
      exists WO.
      split; reflexivity.
    + intros sz mem offset offset' value H_b.
      unfold mload''.
      fold mload''.
      (* *)
      assert(H_bb: (offset + 1 + N.of_nat size' <= offset')%N).
        rewrite Nat2N.inj_succ in H_b. simpl in H_b. rewrite <- N.add_1_l in H_b. rewrite N.add_assoc in H_b. apply H_b.
        (* *)
        
      pose proof (IHsize' sz mem (offset+1)%N offset' value H_bb) as IHsize'_0.
      destruct IHsize'_0 as [v' [IHsize'_0 IHsize'_1]].
      rewrite IHsize'_0.
      rewrite IHsize'_1.

      (* *)
      assert (H_offset_lt_offsset': (offset < offset')%N). pose proof (N_n_Sm_le_p_imp_m_lt_p size' offset offset' H_b) as H0. apply H0.
      (* *)
      
      pose proof (mem'_mstore'_out_of_slot'_1 sz mem offset offset' value H_offset_lt_offsset') as H_mem'_mstore'_out_of_slot'_1.
      destruct H_mem'_mstore'_out_of_slot'_1 as [v'' [H_mem'_mstore'_out_of_slot'_1_0 H_mem'_mstore'_out_of_slot'_1_1]].
      rewrite <- H_mem'_mstore'_out_of_slot'_1_0 in H_mem'_mstore'_out_of_slot'_1_1.
      rewrite H_mem'_mstore'_out_of_slot'_1_1.
      exists (Word.combine (mem offset) v').
      split; reflexivity.
Qed.      
        
                                 

  Lemma remove_out_of_slot'_valid:
    forall (min max: N) (smem smem': smemory) (maxidx : nat) (sb : sbindings) (instk_height : nat) (ops : stack_op_instr_map),
      valid_bindings instk_height maxidx sb ops ->
  valid_smemory instk_height maxidx smem ->
  remove_out_of_slot' smem min max maxidx sb instk_height ops = smem' ->
  valid_smemory instk_height maxidx smem'.
  Proof.
    intros min max.
    induction smem as [|u smem'' IHsmem''].
    + intros smem' maxidx sb instk_height ops.
      intros H_valid_sb H_valid_smem H_remove_out_of_slot'.
      simpl in H_remove_out_of_slot'.
      rewrite <- H_remove_out_of_slot'.
      simpl.
      apply I.
    + intros smem' maxidx sb instk_height ops.
      intros H_valid_sb H_valid_smem H_remove_out_of_slot'.
      unfold remove_out_of_slot' in H_remove_out_of_slot'.
      fold remove_out_of_slot' in H_remove_out_of_slot'.
      
      simpl in H_valid_smem.
      destruct H_valid_smem as [H_valid_u H_valid_smem''].
      destruct (update_out_of_slot u min max maxidx sb instk_height ops) eqn:H_out_of_slot.
      
      ++ pose proof (IHsmem'' smem' maxidx sb instk_height ops  H_valid_sb H_valid_smem'' H_remove_out_of_slot') as IHsmem''_0.
         apply IHsmem''_0.
      ++ remember (remove_out_of_slot' smem'' min max maxidx sb instk_height ops) as smem'''.
         pose proof (IHsmem'' smem''' maxidx sb instk_height ops  H_valid_sb H_valid_smem''  (eq_sym Heqsmem''')) as IHsmem''_0.
         rewrite <- H_remove_out_of_slot'.
         simpl; intuition.
  Qed.
  

  Lemma update_out_of_slot_snd_d1_aux_0:
    forall (n: nat) (value: word (n*8)) (offset' offset: N) (mem mem': memory),
      (N.to_nat offset) < (N.to_nat offset') ->
      mstore' mem value offset' = mem' ->
        (mem offset) = (mem' offset).
  Proof.
    induction n as [|n' IHn'].
    + intros value offset' offset mem mem' H_b H_mstore.
      simpl in H_mstore.
      rewrite H_mstore.
      reflexivity.
    +  intros value offset' offset mem mem' H_b H_mstore.
       rewrite <- H_mstore.
       simpl.
       destruct (offset =? offset')%N eqn:E_o_o'.
       ++ apply N.eqb_eq in E_o_o'.
          rewrite E_o_o' in H_b.
          intuition.
       ++ assert(H_o: (N.to_nat offset) < (N.to_nat (offset'+1))). intuition.
          remember (mstore' mem (split2_byte value) (offset' + 1)) as mem''.
          apply (IHn' (split2_byte value) (offset'+1)%N offset mem mem'' H_o (eq_sym Heqmem'')).
  Qed.


    Lemma update_out_of_slot_snd_d1_aux_1:
    forall size offset offset' mem v,
      (offset+ (N.of_nat size) <= offset')%N ->
      (mload'' (fun o : N => if (o =? offset')%N then v else mem o) offset size)
      = mload'' mem offset size.
  Proof.
    induction size as [|size' IHsize'].
    + simpl. intros. reflexivity.
    + intros offset offset' mem v H_b.
      simpl.
      destruct (offset =? offset')%N eqn:E_o_o'.
      ++ apply N.eqb_eq in E_o_o'.
         rewrite E_o_o' in H_b.
         intuition.
      ++ assert(H_b1: (offset + 1 + N.of_nat size' <= offset')%N).
         pose proof (memory_ops_solvers_impl_soundness.MemoryOpsSolversImplSoundness.N_of_nat_Sn offset size') as H0.
         rewrite H0 in H_b.
         apply H_b.
         rewrite (IHsize' (offset+1)%N offset' mem v H_b1).
         reflexivity.
  Qed.


  Lemma update_out_of_slot_snd_d1_aux:
    forall (n: nat) size (value: word (n*8)) (offset' offset: N) (mem mem': memory),
      (N.to_nat offset) + size <= (N.to_nat offset') ->
      mstore' mem value offset' = mem' ->
        (mload'' mem offset size) = (mload'' mem' offset size).
  Proof.
    induction n as [|n' IHn'].
    + intros size value offset' offset mem mem' H_b H_mstore.
      simpl in H_mstore.
      rewrite H_mstore.
      reflexivity.
    + intros size value offset' offset mem mem' H_b H_mstore.
      destruct size as [|size']; try reflexivity.
      rewrite <- H_mstore.
 
      simpl.

      destruct (offset =? offset')%N eqn:E_o_o'.
      ++ apply N.eqb_eq in E_o_o'.
         rewrite E_o_o' in H_b.
         intuition.
      ++ remember (mstore' mem (split2_byte value) (offset' + 1)) as mem''.
         assert(H_o1: N.to_nat offset < N.to_nat (offset' + 1)%N). intuition.
         rewrite (update_out_of_slot_snd_d1_aux_0 n' (split2_byte value) (offset' + 1)%N offset mem mem'' H_o1 (eq_sym Heqmem'')).
         assert(H_b1: (offset + 1 + N.of_nat size' <= offset')%N).
         rewrite <- (memory_ops_solvers_impl_soundness.MemoryOpsSolversImplSoundness.N_of_nat_Sn offset size').
         apply Nle_in.
         intuition.
         rewrite (update_out_of_slot_snd_d1_aux_1 size' (offset+1)%N offset' mem'' (split1_byte value) H_b1).
         assert(H_o2: N.to_nat (offset + 1) + size' <= N.to_nat (offset' + 1)). intuition.
         rewrite (IHn' size' (split2_byte value) (offset' + 1)%N (offset + 1)%N mem mem'' H_o2 (eq_sym Heqmem'')).
         reflexivity.
  Qed.


  
  Lemma update_out_of_slot_snd_d2_aux_0:
    forall (n: nat) (value: word (n*8)) (offset' offset: N) (mem mem': memory),
      (N.to_nat offset') + n <= (N.to_nat offset) ->
      mstore' mem value offset' = mem' ->
      (mem offset) = (mem' offset).
  Proof.
    induction n as [|n' IHn'].
    + intros value offset' offset mem mem' H_b H_mstore.
      simpl in H_mstore.
      rewrite H_mstore.
      reflexivity.
    +  intros value offset' offset mem mem' H_b H_mstore.
       rewrite <- H_mstore.
       simpl.
       destruct (offset =? offset')%N eqn:E_o_o'.
       ++ apply N.eqb_eq in E_o_o'. intuition.
       ++ assert(H_o: N.to_nat (offset' + 1) + n' <= N.to_nat offset). intuition.
          remember (mstore' mem (split2_byte value) (offset' + 1)) as mem''.
          apply (IHn' (split2_byte value) (offset'+1)%N offset mem mem'' H_o (eq_sym Heqmem'')).
Qed.

  Lemma update_out_of_slot_snd_d2_aux_1:
    forall size offset offset' mem v,
      (offset' < offset)%N ->
      (mload'' (fun o : N => if (o =? offset')%N then v else mem o) offset size)
      = mload'' mem offset size.
  Proof.
    induction size as [|size' IHsize'].
    + simpl. intros. reflexivity.
    + intros offset offset' mem v H_b.
      simpl.
      destruct (offset =? offset')%N eqn:E_o_o'.
      ++ apply N.eqb_eq in E_o_o'. intuition.
      ++ assert(H_b1: (offset' < offset+1)%N).
         apply N.lt_lt_add_r.
         apply H_b.         
         rewrite (IHsize' (offset+1)%N offset' mem v H_b1).
         reflexivity.
Qed.

  Lemma update_out_of_slot_snd_d2_aux:
    forall (n: nat) size (value: word (n*8)) (offset' offset: N) (mem mem': memory),
      (N.to_nat offset') + n <= (N.to_nat offset) ->
      mstore' mem value offset' = mem' ->
      (mload'' mem offset size) = (mload'' mem' offset size).
  Proof.
    induction n as [|n' IHn'].
    + intros size value offset' offset mem mem' H_b H_mstore.
      simpl in H_mstore.
      rewrite H_mstore.
      reflexivity.
    + intros size value offset' offset mem mem' H_b H_mstore.
      destruct size as [|size']; try reflexivity.
      rewrite <- H_mstore.
 
      simpl.

      destruct (offset =? offset')%N eqn:E_o_o'.
      ++ apply N.eqb_eq in E_o_o'.
         rewrite E_o_o' in H_b.         
         intuition.
      ++ remember (mstore' mem (split2_byte value) (offset' + 1)) as mem''.
         assert(H_o1: (N.to_nat (offset' + 1) + n' <= N.to_nat offset)). intuition.
         rewrite (update_out_of_slot_snd_d2_aux_0 n' (split2_byte value) (offset' + 1)%N offset mem mem'' H_o1 (eq_sym Heqmem'')).
         assert(H_b1: (offset' < offset + 1)%N).  apply Nlt_in. intuition.
         rewrite (update_out_of_slot_snd_d2_aux_1 size' (offset+1)%N offset' mem'' (split1_byte value) H_b1).
         assert(H_o2: N.to_nat (offset' + 1) + n' <= N.to_nat (offset + 1)). intuition.
         rewrite (IHn' size' (split2_byte value) (offset' + 1)%N (offset + 1)%N mem mem'' H_o2 (eq_sym Heqmem'')).
         reflexivity.
Qed.

  Lemma update_out_of_slot_snd_aux:
    forall (n: nat) size (value: word (n*8)) (offset' offset: N) (mem mem': memory),
      (N.to_nat offset) + size  <= (N.to_nat offset') \/ (N.to_nat offset') + n <= (N.to_nat offset)
      ->
      mstore' mem value offset' = mem' ->
      (mload'' mem offset size) = (mload'' mem' offset size).
  Proof.
    intros n size value offset' offset mem mem' H_b H_mstore'.
    destruct H_b as [H_b1 | H_b2].
    + apply (update_out_of_slot_snd_d1_aux n size value offset' offset mem mem' H_b1 H_mstore').
    + apply (update_out_of_slot_snd_d2_aux n size value offset' offset mem mem' H_b2 H_mstore').
  Qed.
  
  Lemma update_out_of_slot_snd_1:
    forall (min max: N) (u: memory_update sstack_val) (smem: smemory) (maxidx : nat) (sb : sbindings) (instk_height : nat) (ops : stack_op_instr_map) (stk : list EVMWord) (mem : memory) (strg : storage) (exts : externals) (mem1 mem1' : memory) (offset size : EVMWord),    
      length stk = instk_height ->    
      valid_bindings instk_height maxidx sb ops ->
      valid_smemory instk_height maxidx smem ->
      valid_smemory_update instk_height maxidx u ->
      eval_smemory smem maxidx sb stk mem strg exts ops = Some mem1 ->
      eval_smemory (u::smem) maxidx sb stk mem strg exts ops = Some mem1' ->
      ((wordToN offset) >= min)%N ->
      (((wordToN offset)+(wordToN size)) <= max)%N ->
      update_out_of_slot u min max maxidx sb instk_height ops = true ->
      exists v,
        (mload' mem1 offset (wordToNat size)) = v /\
          (mload' mem1' offset (wordToNat size)) = v.
  Proof.
    intros min max u smem maxidx sb instk_height ops stk mem strg exts mem1 mem1' offset size.
    intros H_stk_len H_valid_bs H_valid_smem H_valid_u H_eval_smem H_eval_u_smem H_lb H_ub H_update_oos.

    unfold eval_smemory in H_eval_smem.
    destruct (map_option (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maxidx sb ops)) smem) as [updates|] eqn:E_mo_updates; try discriminate.
    injection H_eval_smem as H_mem1.

    unfold eval_smemory in H_eval_u_smem.
    destruct (map_option (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maxidx sb ops)) (u::smem)) as [u_updates|] eqn:E_mo_u_updates; try discriminate.
    injection H_eval_u_smem as H_mem1'.

    pose proof (map_option_split (memory_update sstack_val) (memory_update EVMWord) (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maxidx sb ops)) smem u_updates u E_mo_u_updates) as E_mo_u_updates_0.
    destruct E_mo_u_updates_0 as [uv [updates' [H_u_updates [H_uv E_mo_updates']]]].
    rewrite E_mo_updates in E_mo_updates'.
    injection E_mo_updates' as E_updates'.
    rewrite <- E_updates' in H_u_updates.

    rewrite H_u_updates in H_mem1'.
    simpl in H_mem1'.
    rewrite H_mem1 in H_mem1'.
    
    destruct u as [uoffset uvalue|uoffset uvalue] eqn:E_u.
    + unfold update_out_of_slot in H_update_oos.
      destruct (follow_in_smap uoffset maxidx sb) eqn:E_follow_uoffset; try discriminate.
      destruct f; try discriminate.
      destruct smv; try discriminate.
      destruct val; try discriminate.
      simpl in H_uv.
      unfold eval_sstack_val in H_uv at 1.
      unfold eval_sstack_val' in H_uv.
      fold eval_sstack_val' in H_uv.
      rewrite E_follow_uoffset in H_uv.

      simpl in H_valid_u.
      destruct H_valid_u as [H_valid_uoffset H_valid_uvalue].
      
      pose proof (eval_sstack_val_succ sb instk_height uvalue stk mem strg exts maxidx ops (eq_sym H_stk_len) H_valid_uvalue H_valid_bs) as H_eval_uvalue.
      destruct H_eval_uvalue as [uvalue_v H_eval_uvalue].
      rewrite H_eval_uvalue in H_uv.
      injection H_uv as H_uv.

      rewrite <- H_uv in H_mem1'.
      simpl in H_mem1'.
      unfold mstore in H_mem1'.

      unfold mload'.

      apply orb_prop in H_update_oos.

      assert(H_b: N.to_nat (wordToN offset) + wordToNat size <= N.to_nat (wordToN val) \/
                    N.to_nat (wordToN val) + BytesInEVMWord <= N.to_nat (wordToN offset) ).

      (* of assert *)
      ++ destruct H_update_oos as [H_update_oos | H_update_oos].
         +++ right.
             rewrite N.ltb_lt in H_update_oos.
             apply N.ge_le in H_lb.
             pose proof (N.lt_le_trans (wordToN val + 31)%N min (wordToN offset) H_update_oos H_lb) as H0.
             apply Nlt_out in H0.
             apply lt_le_S in H0.
             rewrite N2Nat.inj_add in H0.
             rewrite <- Nat.add_succ_r in H0.
             simpl in H0.
             apply H0.
         +++ left.
             rewrite N.leb_le in H_update_oos.
             
             pose proof (N.le_trans (wordToN offset + wordToN size)%N max (wordToN val) H_ub H_update_oos) as H0.
             rewrite <- wordToN_to_nat.
             pose proof (N2Nat.inj_add (wordToN offset) (wordToN size)) as H1.
             rewrite <- H1. 
             intuition.
      ++ pose proof (update_out_of_slot_snd_aux BytesInEVMWord (wordToNat size) uvalue_v (wordToN val) (wordToN offset) mem1 mem1' H_b H_mem1') as H_mload''.
         rewrite H_mload''.
         exists (mload'' mem1' (wordToN offset) (wordToNat size)).
         split; try reflexivity.
    + unfold update_out_of_slot in H_update_oos.
      destruct (follow_in_smap uoffset maxidx sb) eqn:E_follow_uoffset; try discriminate.
      destruct f; try discriminate.
      destruct smv; try discriminate.
      destruct val; try discriminate.
      simpl in H_uv.
      unfold eval_sstack_val in H_uv at 1.
      unfold eval_sstack_val' in H_uv.
      fold eval_sstack_val' in H_uv.
      rewrite E_follow_uoffset in H_uv.

      simpl in H_valid_u.
      destruct H_valid_u as [H_valid_uoffset H_valid_uvalue].
      
      pose proof (eval_sstack_val_succ sb instk_height uvalue stk mem strg exts maxidx ops (eq_sym H_stk_len) H_valid_uvalue H_valid_bs) as H_eval_uvalue.
      destruct H_eval_uvalue as [uvalue_v H_eval_uvalue].
      rewrite H_eval_uvalue in H_uv.
      injection H_uv as H_uv.

      rewrite <- H_uv in H_mem1'.
      simpl in H_mem1'.
      unfold mstore in H_mem1'.

      unfold mload'.
      
      apply orb_prop in H_update_oos.

       assert(H_b: (N.to_nat (wordToN offset) + wordToNat size <= N.to_nat (wordToN val) \/ N.to_nat (wordToN val) + 1 <= N.to_nat (wordToN offset))). 

      (* of assert *)
      ++ destruct H_update_oos as [H_update_oos | H_update_oos].
         +++ right.
             rewrite N.ltb_lt in H_update_oos.
             intuition.
         +++ left.
             rewrite N.leb_le in H_update_oos.
             pose proof (N.le_trans (wordToN offset + wordToN size)%N max (wordToN val) H_ub H_update_oos) as H0.
             rewrite <- wordToN_to_nat.
             pose proof (N2Nat.inj_add (wordToN offset) (wordToN size)) as H1.
             rewrite <- H1. 
             intuition.
       (*end *)
      ++ pose proof (update_out_of_slot_snd_aux 1 (wordToNat size) (split1_byte (uvalue_v: word ((S (pred BytesInEVMWord))*8))) (wordToN val) (wordToN offset) mem1 mem1' H_b H_mem1') as H_mload''.
      rewrite H_mload''.
      exists (mload'' mem1' (wordToN offset) (wordToNat size)).
      split; try reflexivity.
  Qed.


  Lemma eval_smemory_u_mem_0:
    forall size offset offset' mem1 mem2 value,
      mload'' mem1 offset size = mload'' mem2 offset size ->
      mload'' (fun o' => if (offset' =? o')%N then value else mem1 o') offset size = mload'' (fun o' => if (offset' =? o')%N then value else mem2 o') offset size.
  Proof.
    induction size as [|size' IHsize'].
    + reflexivity.
    + intros offset offset' mem1 mem2 value H_mload''_mem1_mem2.
      simpl.
      
      simpl in H_mload''_mem1_mem2.
      pose proof (@combine_inj 8 (size'*8) (mem1 offset) (mload'' mem1 (offset + 1) size') (mem2 offset) (mload'' mem2 (offset + 1) size') H_mload''_mem1_mem2 ) as H_combine_inj.
      destruct H_combine_inj as [H_combine_inj_1 H_combine_inj_2].
      
      destruct (offset' =? offset)%N eqn:E_o_offse.
      ++ pose proof (IHsize' (offset+1)%N offset' mem1 mem2 value H_combine_inj_2) as IHsize'_0.
         rewrite IHsize'_0.
         reflexivity.
      ++ pose proof (IHsize' (offset+1)%N offset' mem1 mem2 value H_combine_inj_2) as IHsize'_0.
         rewrite IHsize'_0.
         rewrite H_combine_inj_1.
         reflexivity.
  Qed.
  
  Lemma eval_smemory_u_mem_1:
    forall n size offset offset' mem1 mem2 mem1' mem2' (value : word (n*8)) ,
      mload'' mem1 offset (S size) = mload'' mem2 offset (S size) ->
      mstore' mem1 value offset' = mem1' ->
      mstore' mem2 value offset' = mem2' ->
      mem1' offset = mem2' offset.
  Proof.
    induction n as [|n' IHn'].
    + intros size offset offset' mem1 mem2 mem1' mem2' value H_mload'' H_mstore'_mem1 H_mstore'_mem2.
      rewrite <- H_mstore'_mem1.
      rewrite <- H_mstore'_mem2.
      simpl.
      pose proof (@combine_inj 8 (size*8) (mem1 offset) (mload'' mem1 (offset + 1) size) (mem2 offset) (mload'' mem2 (offset + 1) size) H_mload'' ) as H_combine_inj.
      destruct H_combine_inj as [H_combine_inj_1 H_combine_inj_2].
      apply H_combine_inj_1.
    + intros size offset offset' mem1 mem2 mem1' mem2' value H_mload'' H_mstore'_mem1 H_mstore'_mem2.
      rewrite <- H_mstore'_mem1.
      rewrite <- H_mstore'_mem2.
      simpl.
      destruct (offset =? offset')%N; try reflexivity.
      remember (mstore' mem1 (split2_byte value) (offset' + 1)) as mem1''.
      remember (mstore' mem2 (split2_byte value) (offset' + 1)) as mem2''.
      pose proof (IHn' size offset (offset'+1)%N mem1 mem2 mem1'' mem2'' (split2_byte value) H_mload'' (eq_sym Heqmem1'') (eq_sym Heqmem2'')) as IHn'_0.
      apply IHn'_0.
  Qed.
  
  Lemma eval_smemory_u_mem_2:
    forall size n offset offset' mem1 mem2 mem1' mem2' (value : word (n*8)) ,
      mload'' mem1 offset size = mload'' mem2 offset size ->
      mstore' mem1 value offset' = mem1' ->
      mstore' mem2 value offset' = mem2' ->
      mload'' mem1' offset size = mload'' mem2' offset size.
  Proof. 
    induction size as [|size' IHsize'].
    + intros n offset offset' mem1 mem2 mem1' mem2' value H_mload''_mem1_mem2 H_mstore'_mem1 H_mstore'_mem2.
      simpl.
      reflexivity. 
    + induction n as [|n' IHn'].
      ++ intros offset offset' mem1 mem2 mem1' mem2' value H_mload''_mem1_mem2 H_mstore'_mem1 H_mstore'_mem2. 
         simpl in H_mload''_mem1_mem2.
         pose proof (@combine_inj 8 (size'*8) (mem1 offset) (mload'' mem1 (offset + 1) size') (mem2 offset) (mload'' mem2 (offset + 1) size') H_mload''_mem1_mem2 ) as H_combine_inj.
         destruct H_combine_inj as [H_combine_inj_1 H_combine_inj_2].
         simpl.
         pose proof (IHsize' 0 (offset + 1)%N offset' mem1 mem2 mem1' mem2' value H_combine_inj_2 H_mstore'_mem1 H_mstore'_mem2) as IHsize'_0.
         rewrite IHsize'_0.
         (**)
         assert (H_mem1'_mem2': mem1' offset = mem2' offset).
         rewrite <- H_mstore'_mem1.
         rewrite <- H_mstore'_mem2.
         simpl.
         apply H_combine_inj_1.
         rewrite H_mem1'_mem2'.
         reflexivity.
      ++ intros offset offset' mem1 mem2 mem1' mem2' value H_mload''_mem1_mem2 H_mstore'_mem1 H_mstore'_mem2.
         assert(H_mload''_mem1_mem2_0 := H_mload''_mem1_mem2).
         simpl in H_mload''_mem1_mem2.
         pose proof (@combine_inj 8 (size'*8) (mem1 offset) (mload'' mem1 (offset + 1) size') (mem2 offset) (mload'' mem2 (offset + 1) size') H_mload''_mem1_mem2 ) as H_combine_inj.
         destruct H_combine_inj as [H_combine_inj_1 H_combine_inj_2].
         simpl.
         pose proof (IHsize' (S n') (offset + 1)%N offset' mem1 mem2 mem1' mem2' value H_combine_inj_2 H_mstore'_mem1 H_mstore'_mem2) as IHsize'_0.
         rewrite IHsize'_0.

         pose proof (eval_smemory_u_mem_1 (S n') size' offset offset' mem1 mem2 mem1' mem2' value H_mload''_mem1_mem2_0 H_mstore'_mem1 H_mstore'_mem2 ) as H_eval_smemory_u_mem_1.
         rewrite H_eval_smemory_u_mem_1.
         reflexivity.
Qed.
           
  Lemma eval_smemory_u_mem_3:
    forall size n offset offset' mem1 mem2 mem1' mem2' (value : word (n*8)) ,
      mload' mem1 offset size = mload' mem2 offset size ->
      mstore' mem1 value offset' = mem1' ->
      mstore' mem2 value offset' = mem2' ->
      mload' mem1' offset size = mload' mem2' offset size.
  Proof.
    unfold mload'.
    intros size n offset offset' mem1 mem2 mem1' mem2' value.
    intros H_mload'' H_mstore'_mem1 H_mstore'_mem2.
    apply (eval_smemory_u_mem_2 size n (wordToN offset) offset' mem1 mem2 mem1' mem2' value H_mload'' H_mstore'_mem1 H_mstore'_mem2).
  Qed.

    Lemma eval_smemory_u_mem_4:
    forall u offset size mem1 mem2 mem1' mem2',
      mload' mem1 offset size = mload' mem2 offset size ->
      update_memory' mem1 u = mem1' ->
      update_memory' mem2 u = mem2' ->
      mload' mem1' offset size = mload' mem2' offset size.
    Proof.
      intros u offset size mem1 mem2 mem1' mem2'.
      intros H_mload' H_update_mem1 H_update_mem2.
      destruct u as [uoffset uvalue|uoffset uvalue].
      + simpl in *.
        unfold mstore in *.
        apply (eval_smemory_u_mem_3 size BytesInEVMWord offset (wordToN uoffset) mem1 mem2 mem1' mem2' uvalue H_mload' H_update_mem1 H_update_mem2).
      + simpl in *.
        unfold mstore in *.
        apply (eval_smemory_u_mem_3 size 1 offset (wordToN uoffset) mem1 mem2 mem1' mem2' (split1_byte (uvalue: word ((S (pred BytesInEVMWord))*8))) H_mload' H_update_mem1 H_update_mem2).
    Qed.
        
      
  Lemma eval_smemory_u_mem_5:
    forall updates offset size mem1 mem2 mem1' mem2',
      mload' mem1 offset size = mload' mem2 offset size ->
      update_memory mem1 updates = mem1' ->
      update_memory mem2 updates = mem2' ->
      mload' mem1' offset size = mload' mem2' offset size.
  Proof.
    induction updates as [|u updates' IHupdates'].
    + intros offset size mem1 mem2 mem1' mem2'.
      intros H_mload' H_update_mem1 H_update_mem2.
      simpl in *.
      rewrite <- H_update_mem1.
      rewrite <- H_update_mem2.
      apply H_mload'.
    + intros offset size mem1 mem2 mem1' mem2'.
      intros H_mload' H_update_mem1 H_update_mem2.
      simpl in H_update_mem1.
      simpl in H_update_mem2.
      remember (update_memory mem1 updates') as mem1''.
      remember (update_memory mem2 updates') as mem2''.
      pose proof (IHupdates' offset size mem1 mem2 mem1'' mem2'' H_mload' (eq_sym Heqmem1'') (eq_sym Heqmem2'')) as H_mload'_0.      
      apply (eval_smemory_u_mem_4 u offset size mem1'' mem2'' mem1' mem2' H_mload'_0 H_update_mem1 H_update_mem2).
  Qed.

  
  Lemma update_out_of_slot_snd_2:
    forall (smem1 smem2: smemory) (u: memory_update sstack_val) (maxidx : nat) (sb : sbindings) (instk_height : nat) (ops : stack_op_instr_map) (stk : list EVMWord) (mem : memory) (strg : storage) (exts : externals) (mem1 mem2 mem1' mem2' : memory) (offset size : EVMWord),    
      length stk = instk_height ->    
      valid_bindings instk_height maxidx sb ops ->
      valid_smemory instk_height maxidx smem1 ->
      valid_smemory instk_height maxidx smem2 ->
      valid_smemory_update instk_height maxidx u ->
      eval_smemory smem1 maxidx sb stk mem strg exts ops = Some mem1 ->
      eval_smemory smem2 maxidx sb stk mem strg exts ops = Some mem2 ->
      eval_smemory (u::smem1) maxidx sb stk mem strg exts ops = Some mem1' ->
      eval_smemory (u::smem2) maxidx sb stk mem strg exts ops = Some mem2' ->
      (mload' mem1 offset (wordToNat size)) = (mload' mem2 offset (wordToNat size)) ->
      exists v,
        (mload' mem1' offset (wordToNat size)) = v /\
          (mload' mem2' offset (wordToNat size)) = v.
  Proof.
    intros smem1 smem2 u maidx sb instk_height ops stk mem strg exts mem1 mem2 mem1' mem2' offset size.
    intros H_valid_len_stk H_valid_bs H_valid_smem1 H_valid_smem2 H_valid_u H_eval_smem1 H_eval_smem2 H_eval_u_smem1 H_eval_u_smem2 H_mload'.

    unfold eval_smemory in H_eval_smem1.
    destruct (map_option (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maidx sb ops)) smem1) as [updates1|] eqn:E_mo_updates1; try discriminate.
    injection H_eval_smem1 as H_mem1.
    
    unfold eval_smemory in H_eval_smem2.
    destruct (map_option (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maidx sb ops)) smem2) as [updates2|] eqn:E_mo_updates2; try discriminate.
    injection H_eval_smem2 as H_mem2.
    
    unfold eval_smemory in H_eval_u_smem1.
    destruct (map_option (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maidx sb ops)) (u::smem1)) as [u_updates1|] eqn:E_mo_u_updates1; try discriminate.
    injection H_eval_u_smem1 as H_mem1'.

    unfold eval_smemory in H_eval_u_smem2.
    destruct (map_option (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maidx sb ops)) (u::smem2)) as [u_updates2|] eqn:E_mo_u_updates2; try discriminate.
    injection H_eval_u_smem2 as H_mem2'.

    pose proof (map_option_split (memory_update sstack_val) (memory_update EVMWord) (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maidx sb ops)) smem1 u_updates1 u E_mo_u_updates1) as E_mo_u_updates1_0.
    destruct E_mo_u_updates1_0 as [uv1 [update1' [H_u_updates1 [H_uv1 H_updates1']]]].
    rewrite E_mo_updates1 in H_updates1'.
    injection H_updates1' as H_updates1'.

    pose proof (map_option_split (memory_update sstack_val) (memory_update EVMWord) (instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maidx sb ops)) smem2 u_updates2 u E_mo_u_updates2) as E_mo_u_updates2_0.
    destruct E_mo_u_updates2_0 as [uv2 [update2' [H_u_updates2 [H_uv2 H_updates2']]]].
    rewrite E_mo_updates2 in H_updates2'.
    injection H_updates2' as H_updates2'.

    rewrite H_uv1 in H_uv2.
    injection H_uv2 as H_uv2.

    rewrite <- H_uv2 in H_u_updates2.
    
    rewrite H_u_updates1 in H_mem1'.
    simpl in H_mem1'.
    
    rewrite H_u_updates2 in H_mem2'.
    simpl in H_mem2'.

    rewrite <- H_updates1' in H_mem1'.
    rewrite <- H_updates2' in H_mem2'.

    rewrite H_mem1 in H_mem1'.
    rewrite H_mem2 in H_mem2'.

    
    pose proof (eval_smemory_u_mem_4 uv1 offset (wordToNat size) mem1 mem2 mem1' mem2' H_mload' H_mem1' H_mem2') as H_mload'_0.
    rewrite H_mload'_0.
    exists (mload' mem2' offset (wordToNat size)).
    split; try reflexivity.
  Qed.

         
  Lemma remove_out_of_slot'_snd_1:
    forall (min max: N) (smem smem_r: smemory) (maxidx : nat) (sb : sbindings) (instk_height : nat) (ops : stack_op_instr_map)
           (stk : list EVMWord) (mem : memory) (strg : storage) (exts : externals) (mem1 mem1' : memory)
           (offset size : EVMWord),    
      length stk = instk_height ->    
      valid_bindings instk_height maxidx sb ops ->
      valid_smemory instk_height maxidx smem ->
      eval_smemory smem maxidx sb stk mem strg exts ops = Some mem1 ->
      eval_smemory smem_r maxidx sb stk mem strg exts ops = Some mem1' ->
      ((wordToN offset) >= min)%N ->
      (((wordToN offset)+(wordToN size)) <= max)%N ->
      remove_out_of_slot' smem min max maxidx sb instk_height ops = smem_r ->
      exists v,
        (mload' mem1 offset (wordToNat size)) = v /\
          (mload' mem1' offset (wordToNat size)) = v.
  Proof.
    intros min max.
    induction smem as [|u smem'].
    + intros smem_r maxidx sb instk_height ops stk mem strg exts mem1 mem1' offset size.
      intros H_len_stk H_valid_sb H_valid_smem H_eval_smem H_eval_smem_r H_lb H_ub H_remove_out_of_slot'.
      simpl in H_remove_out_of_slot'.
      rewrite <- H_remove_out_of_slot' in H_eval_smem_r.
      unfold eval_smemory in H_eval_smem.
      simpl in H_eval_smem.
      injection H_eval_smem as H_mem1.
      unfold eval_smemory in H_eval_smem_r.
      simpl in H_eval_smem_r.
      injection H_eval_smem_r as H_mem1'.
      rewrite <- H_mem1.
      rewrite <- H_mem1'.
      exists (mload' mem offset (wordToNat size)).
      split; reflexivity.
    + intros smem_r maxidx sb instk_height ops stk mem strg exts mem1 mem1' offset size.
      intros H_len_stk H_valid_sb H_valid_smem H_eval_smem H_eval_smem_r H_lb H_ub H_remove_out_of_slot'.
      unfold remove_out_of_slot' in H_remove_out_of_slot'.
      fold remove_out_of_slot' in H_remove_out_of_slot'.
      destruct (update_out_of_slot u min max maxidx sb instk_height ops) eqn:E_update_out_of_slot.
      ++ simpl in H_valid_smem.
         destruct H_valid_smem as [H_valid_u H_valid_smem'].
         pose proof (eval_smemory_succ instk_height maxidx sb stk mem strg exts ops smem' (eq_sym H_len_stk) H_valid_smem' H_valid_sb) as H_eval_smem'.
         destruct H_eval_smem' as [mem' H_eval_smem'].
         pose proof (update_out_of_slot_snd_1 min max u smem' maxidx sb instk_height ops stk mem strg exts mem' mem1 offset size H_len_stk H_valid_sb H_valid_smem' H_valid_u H_eval_smem' H_eval_smem H_lb H_ub E_update_out_of_slot) as H_update_out_of_slot_snd_1.
         destruct H_update_out_of_slot_snd_1 as [v [H_mload'_mem' H_mload_mem1]].
         rewrite <- H_mload'_mem' in H_mload_mem1.
         exists (mload' mem' offset (wordToNat size)).
         rewrite H_mload_mem1.
         split; try reflexivity.
         pose proof (IHsmem' smem_r maxidx sb instk_height ops stk mem strg exts mem' mem1' offset size H_len_stk H_valid_sb H_valid_smem' H_eval_smem' H_eval_smem_r H_lb H_ub H_remove_out_of_slot') as IHsmem'_0.
         destruct IHsmem'_0 as [v' [H_mload'_mem'_0 H_mload_mem1'_0]].
         rewrite H_mload'_mem'_0.
         rewrite H_mload_mem1'_0.
         reflexivity.
      ++ remember (remove_out_of_slot' smem' min max maxidx sb instk_height ops) as smem''.
         rewrite <- H_remove_out_of_slot' in H_eval_smem_r.
         simpl in H_valid_smem.
         destruct H_valid_smem as [H_valid_u H_valid_smem'].
         pose proof (remove_out_of_slot'_valid min max smem' smem'' maxidx sb instk_height ops H_valid_sb H_valid_smem' (eq_sym Heqsmem'')) as H_valid_smem''.
         pose proof (eval_smemory_succ instk_height maxidx sb stk mem strg exts ops smem' (eq_sym H_len_stk) H_valid_smem' H_valid_sb) as H_eval_smem'.
         destruct H_eval_smem' as [mem2 H_eval_smem'].
         
         pose proof (eval_smemory_succ instk_height maxidx sb stk mem strg exts ops smem'' (eq_sym H_len_stk) H_valid_smem'' H_valid_sb) as H_eval_smem''.
         destruct H_eval_smem'' as [mem2' H_eval_smem''].
         pose proof (IHsmem' smem'' maxidx sb instk_height ops stk mem strg exts mem2 mem2' offset size H_len_stk H_valid_sb H_valid_smem' H_eval_smem' H_eval_smem'' H_lb H_ub (eq_sym Heqsmem'' )) as IHsmem'_0.
         destruct IHsmem'_0 as [v' [IHsmem'_0_1 IHsmem'_0_2]].
         rewrite <- IHsmem'_0_2 in IHsmem'_0_1.
         pose proof (update_out_of_slot_snd_2 smem' smem'' u maxidx sb instk_height ops stk mem strg exts mem2 mem2' mem1 mem1' offset size H_len_stk H_valid_sb H_valid_smem' H_valid_smem'' H_valid_u H_eval_smem' H_eval_smem'' H_eval_smem H_eval_smem_r IHsmem'_0_1) as H_update_out_of_slot_snd_2.
         apply H_update_out_of_slot_snd_2.
  Qed.
             

Lemma remove_out_of_slot'_snd:
  forall (min max: N) (smem smem_r: smemory) (maxidx : nat) (sb : sbindings) (instk_height : nat) (ops : stack_op_instr_map)
         (stk : list EVMWord) (mem : memory) (strg : storage) (exts : externals) (mem1 mem1' : memory)
         (offset size : EVMWord),    
    length stk = instk_height ->    
    valid_bindings instk_height maxidx sb ops ->
    valid_smemory instk_height maxidx smem ->
    eval_smemory smem maxidx sb stk mem strg exts ops = Some mem1 ->
    eval_smemory smem_r maxidx sb stk mem strg exts ops = Some mem1' ->
    ((wordToN offset) >= min)%N ->
    ( ((wordToN offset)+(wordToN size)) <= max)%N ->
    remove_out_of_slot' smem min max maxidx sb instk_height ops = smem_r ->
    exists v,
      get_keccak256_exts exts (wordToNat size)
        (mload' mem1 offset (wordToNat size)) = v /\
        get_keccak256_exts exts (wordToNat size)
          (mload' mem1' offset (wordToNat size)) = v.
Proof.
  intros min max smem smem_r maxidx sb instk_height ops stk mem strg exts mem1 mem1' offset size.
  intros H_stk_len H_valid_sb H_valid_smem H_eval_smem H_eval_smem_r H_b1 H_b2 H_remove_out_of_slot'.
  pose proof (remove_out_of_slot'_snd_1 min max smem smem_r maxidx sb instk_height ops stk mem strg exts mem1 mem1' offset size H_stk_len H_valid_sb H_valid_smem H_eval_smem H_eval_smem_r H_b1 H_b2 H_remove_out_of_slot') as H_snd_1.
  destruct H_snd_1 as [v' [H_snd_1_0 H_snd_1_1]].
  rewrite H_snd_1_0.
  rewrite H_snd_1_1.
  exists (get_keccak256_exts exts (wordToNat size) v').
  split; reflexivity.
Qed.
  
Lemma remove_out_of_slot_valid:
    forall (soffset ssize : sstack_val) (smem smem': smemory) (maxidx : nat) (sb : sbindings) (instk_height : nat) (ops : stack_op_instr_map),
      valid_sstack_value instk_height maxidx soffset ->
      valid_sstack_value instk_height maxidx ssize ->
      valid_bindings instk_height maxidx sb ops ->
      valid_smemory instk_height maxidx smem ->
      remove_out_of_slot smem soffset ssize maxidx sb instk_height ops = smem' ->
      valid_smemory instk_height maxidx smem'.
  Proof.
    intros soffset ssize smem smem' maxidx sb instk_height ops.
    intros H_valid_soffset H_valid_ssize H_valid_sb H_valid_smem H_remove_out_of_slot.
    unfold remove_out_of_slot in H_remove_out_of_slot.
    destruct (follow_in_smap soffset maxidx sb).
     destruct f.
      destruct smv.
      destruct val.
      destruct (follow_in_smap ssize maxidx sb).
      destruct f.
      destruct smv.
      destruct val0.
      pose proof (remove_out_of_slot'_valid (wordToN val) (wordToN val + wordToN val0) smem smem' maxidx sb instk_height ops H_valid_sb H_valid_smem H_remove_out_of_slot) as H_valid_smem'.
      apply H_valid_smem'.

      (* TODO somehow did not suceed to write ot with repeat, try again *)
      rewrite <- H_remove_out_of_slot. apply H_valid_smem.
      rewrite <- H_remove_out_of_slot. apply H_valid_smem.
      rewrite <- H_remove_out_of_slot. apply H_valid_smem.
      rewrite <- H_remove_out_of_slot. apply H_valid_smem.
      rewrite <- H_remove_out_of_slot. apply H_valid_smem.
      rewrite <- H_remove_out_of_slot. apply H_valid_smem.
      rewrite <- H_remove_out_of_slot. apply H_valid_smem.
      rewrite <- H_remove_out_of_slot. apply H_valid_smem.
      rewrite <- H_remove_out_of_slot. apply H_valid_smem.
      rewrite <- H_remove_out_of_slot. apply H_valid_smem.
      rewrite <- H_remove_out_of_slot. apply H_valid_smem.
      rewrite <- H_remove_out_of_slot. apply H_valid_smem.
      rewrite <- H_remove_out_of_slot. apply H_valid_smem.
      rewrite <- H_remove_out_of_slot. apply H_valid_smem.
      rewrite <- H_remove_out_of_slot. apply H_valid_smem.
      rewrite <- H_remove_out_of_slot. apply H_valid_smem.
Qed.

  Lemma remove_out_of_slot_snd:
  forall (soffset ssize : sstack_val) (smem smem': smemory) (maxidx : nat) (sb : sbindings) (instk_height : nat) (ops : stack_op_instr_map),
  valid_sstack_value instk_height maxidx soffset ->
  valid_sstack_value instk_height maxidx ssize ->
  valid_bindings instk_height maxidx sb ops ->
  valid_smemory instk_height maxidx smem ->
  remove_out_of_slot smem soffset ssize maxidx sb instk_height ops = smem' ->
  forall (stk : list EVMWord) (mem : memory) (strg : storage) (exts : externals),
    length stk = instk_height ->    
    exists
      (offset size : EVMWord) (mem1 mem1' : memory) (v : EVMWord),
      eval_smemory smem maxidx sb stk mem strg exts ops = Some mem1 /\
        eval_smemory smem' maxidx sb stk mem strg exts ops = Some mem1' /\
        eval_sstack_val soffset stk mem strg exts maxidx sb ops = Some offset /\
        eval_sstack_val ssize stk mem strg exts maxidx sb ops = Some size /\
        get_keccak256_exts exts (wordToNat size)
          (mload' mem1 offset (wordToNat size)) = v /\
        get_keccak256_exts exts (wordToNat size)
          (mload' mem1' offset (wordToNat size)) = v.
  Proof.
    intros soffset ssize smem smem' maxidx sb instk_height ops.
    intros H_valid_soffset H_valid_ssize H_valid_sb H_valid_smem H_remove_out_of_slot.
    intros stk mem strg exts H_stk_len.

    pose proof (remove_out_of_slot_valid soffset ssize smem smem' maxidx sb instk_height ops H_valid_soffset H_valid_ssize H_valid_sb H_valid_smem H_remove_out_of_slot) as H_valid_smem'.

    pose proof (eval_smemory_succ instk_height maxidx sb stk mem strg exts ops smem (eq_sym H_stk_len) H_valid_smem H_valid_sb) as H_eval_smem.
    destruct H_eval_smem as [mem1 H_eval_smem].

    pose proof (eval_smemory_succ instk_height maxidx sb stk mem strg exts ops smem' (eq_sym H_stk_len) H_valid_smem' H_valid_sb) as H_eval_smem'.
    destruct H_eval_smem' as [mem1' H_eval_smem'].

    pose proof (eval_sstack_val_succ sb instk_height soffset stk mem strg exts maxidx ops (eq_sym H_stk_len) H_valid_soffset H_valid_sb) as H_eval_soffset.
    destruct H_eval_soffset as [soffset_v H_eval_soffset].

    pose proof (eval_sstack_val_succ sb instk_height ssize stk mem strg exts maxidx ops (eq_sym H_stk_len) H_valid_ssize H_valid_sb) as H_eval_ssize.
    destruct H_eval_ssize as [ssize_v H_eval_ssize].
    

    assert (H_aux: smem = smem' ->
                     exists (offset size : EVMWord) (mem0 mem1'0 : memory) (v : EVMWord),
    eval_smemory smem maxidx sb stk mem strg exts ops = Some mem0 /\
    eval_smemory smem' maxidx sb stk mem strg exts ops = Some mem1'0 /\
    eval_sstack_val soffset stk mem strg exts maxidx sb ops = Some offset /\
    eval_sstack_val ssize stk mem strg exts maxidx sb ops = Some size /\
    get_keccak256_exts exts (wordToNat size) (mload' mem0 offset (wordToNat size)) = v /\ get_keccak256_exts exts (wordToNat size) (mload' mem1'0 offset (wordToNat size)) = v
           ).
    (* proof of assert *)
    intro H_smem_eq_smem'.

    rewrite <- H_smem_eq_smem' in H_eval_smem'.
    assert(H_mem1_eq_mem1' := H_eval_smem').
    rewrite H_eval_smem in H_mem1_eq_mem1'.
    injection H_mem1_eq_mem1' as H_mem1_eq_mem1'.
    
    
    exists soffset_v. exists ssize_v. exists mem1. exists mem1'.
    exists (get_keccak256_exts exts (wordToNat ssize_v) (mload' mem1 soffset_v (wordToNat ssize_v))).
    rewrite <- H_smem_eq_smem'.
    rewrite H_mem1_eq_mem1'.
    split; try intuition.

    unfold remove_out_of_slot in H_remove_out_of_slot.
    destruct (follow_in_smap soffset maxidx sb) eqn:E_follow_soffset; try intuition.
    destruct f.
    destruct smv; try intuition.
    destruct val; try intuition.
    destruct (follow_in_smap ssize maxidx sb) eqn:E_follow_ssize; try intuition.
    destruct f.
    destruct smv; try intuition.
    destruct val0; try intuition.


    assert( H_eval_soffset' := H_eval_soffset).
    unfold eval_sstack_val in H_eval_soffset.
    unfold eval_sstack_val' in H_eval_soffset.
    fold eval_sstack_val' in H_eval_soffset.
    rewrite E_follow_soffset in H_eval_soffset.
    injection H_eval_soffset as H_val_eq_soffset.

    assert( H_eval_ssize' := H_eval_ssize).
    unfold eval_sstack_val in H_eval_ssize.
    unfold eval_sstack_val' in H_eval_ssize.
    fold eval_sstack_val' in H_eval_ssize.
    rewrite E_follow_ssize in H_eval_ssize.
    injection H_eval_ssize as H_val0_eq_ssize.

    
    assert(H_l: (wordToN soffset_v >= wordToN val)%N).
    (* proof of assert *)
    rewrite H_val_eq_soffset.
    apply N.le_ge.
    apply N.le_refl.
    (* end of proof of assert *)
    
    assert(H_u: (wordToN soffset_v + wordToN ssize_v  <= wordToN val + wordToN val0 )%N). 
    (* proof of assert *)
    rewrite H_val_eq_soffset.
    rewrite H_val0_eq_ssize.
    apply N.le_refl. 
    (* end of proof of assert *)

    pose proof (remove_out_of_slot'_snd (wordToN val) (wordToN val + wordToN val0) smem smem' maxidx sb instk_height ops stk mem strg exts mem1 mem1' soffset_v ssize_v H_stk_len H_valid_sb H_valid_smem H_eval_smem H_eval_smem' H_l H_u H_remove_out_of_slot) as H_remove_out_of_slot'_snd.
    destruct H_remove_out_of_slot'_snd as [v H_remove_out_of_slot'_snd].

    exists soffset_v. exists ssize_v. exists mem1. exists mem1'. exists v.
    intuition.
    
  Qed.

  Lemma basic_sha3_cmp_snd:
    safe_sha3_cmp_ext_wrt_sstack_value_cmp basic_sha3_cmp.
  Proof.
    unfold safe_sha3_cmp_ext_wrt_sstack_value_cmp.
    intros d sstack_val_cmp H_safe_sstack_val_cmp.
    unfold safe_sha3_cmp_ext_d.
    intros d' H_d'_le_d.
    unfold safe_sha3_cmp.
    intros soffset1 ssize1 smem1 soffset2 ssize2 smem2 maxidx1 sb1 maxidx2 sb2 instk_height ops.
    intros H_valid_soffset1 H_valid_ssize1 H_valid_soffset2 H_valid_ssize2 H_valid_sb1 H_valid_sb2 H_valid_smem1 H_valid_smem2.
    intros H_basic_sha3_cmp.
    intros stk mem strg exts H_stk_len.
    unfold basic_sha3_cmp in H_basic_sha3_cmp.
    destruct (sstack_val_cmp d' soffset1 soffset2 maxidx1 sb1 maxidx2 sb2 instk_height ops && sstack_val_cmp d' ssize1 ssize2 maxidx1 sb1 maxidx2 sb2 instk_height ops) eqn:H_eq_size_and_offset; try discriminate.
    apply andb_prop in H_eq_size_and_offset as [H_eq_soffset H_eq_ssize].
    remember (remove_out_of_slot smem1 soffset1 ssize1 maxidx1 sb1 instk_height ops) as smem1' eqn:H_smem1'.
    remember (remove_out_of_slot smem2 soffset2 ssize2 maxidx2 sb2 instk_height ops) as smem2' eqn:H_smem2'.

    pose proof (remove_out_of_slot_valid soffset1 ssize1 smem1 smem1' maxidx1 sb1 instk_height ops H_valid_soffset1 H_valid_ssize1 H_valid_sb1 H_valid_smem1 (eq_sym H_smem1')) as H_valid_smem1'.
    
    pose proof (remove_out_of_slot_snd soffset1 ssize1 smem1 smem1' maxidx1 sb1 instk_height ops H_valid_soffset1 H_valid_ssize1 H_valid_sb1 H_valid_smem1 (eq_sym H_smem1')) as H_out_of_slot_1_2.

    pose proof (H_out_of_slot_1_2 stk mem strg exts H_stk_len) as H_out_of_slot_1_2.
    destruct H_out_of_slot_1_2 as [ofsset1 [size1 [mem1 [mem1' [v1 [H_eval_smem1 [ H_eval_smem1' [ H_eval_soffset1 [ H_eval_ssize1 [H_sha3_mem1 H_sha3_mem1']]]]]]]]]].

    pose proof (remove_out_of_slot_valid soffset2 ssize2 smem2 smem2' maxidx2 sb2 instk_height ops H_valid_soffset2 H_valid_ssize2 H_valid_sb2 H_valid_smem2 (eq_sym H_smem2')) as H_valid_smem2'.

    pose proof (remove_out_of_slot_snd soffset2 ssize2 smem2 smem2' maxidx2 sb2 instk_height ops H_valid_soffset2 H_valid_ssize2 H_valid_sb2 H_valid_smem2 (eq_sym H_smem2')) as H_out_of_slot_2_2.
    
    pose proof (H_out_of_slot_2_2 stk mem strg exts H_stk_len) as H_out_of_slot_2_2.
    destruct H_out_of_slot_2_2 as [ofsset2 [size2 [mem2 [mem2' [v2 [H_eval_smem2 [ H_eval_smem2' [ H_eval_soffset2 [ H_eval_ssize2 [H_sha3_mem2 H_sha3_mem2']]]]]]]]]].

    pose proof (po_memory_cmp_snd) as H_po_memory_cmp_snd.
    unfold safe_smemory_cmp_ext_wrt_sstack_value_cmp in H_po_memory_cmp_snd.
    pose proof (H_po_memory_cmp_snd d sstack_val_cmp H_safe_sstack_val_cmp) as H_po_memory_cmp_snd.

    unfold safe_smemory_cmp_ext_d in H_po_memory_cmp_snd.
    pose proof (H_po_memory_cmp_snd d' H_d'_le_d) as H_po_memory_cmp_snd.
    unfold safe_smemory_cmp in H_po_memory_cmp_snd.
    pose proof (H_po_memory_cmp_snd smem1' smem2' maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_sb1 H_valid_sb2 H_valid_smem1' H_valid_smem2' H_basic_sha3_cmp stk mem strg exts H_stk_len) as H_po_memory_cmp_snd.
    destruct H_po_memory_cmp_snd as [mem' [H_eval_smem1'_aux H_eval_smem2'_aux]].

    rewrite H_eval_smem1'_aux in H_eval_smem1'.
    injection H_eval_smem1' as H_mem'_eq_mem1'.

    rewrite H_eval_smem2'_aux in H_eval_smem2'.
    injection H_eval_smem2' as H_mem'_eq_mem2'.

    rewrite H_mem'_eq_mem2' in H_mem'_eq_mem1'.

    exists ofsset1. exists size1. exists mem1.
    exists ofsset2. exists size2. exists mem2.
    exists v1.


    repeat split; try auto.


    unfold safe_sstack_val_cmp_ext_1_d in H_safe_sstack_val_cmp.
    pose proof (H_safe_sstack_val_cmp d' H_d'_le_d) as H_safe_sstack_val_cmp.
    unfold safe_sstack_val_cmp in H_safe_sstack_val_cmp.

    pose proof (H_safe_sstack_val_cmp soffset1 soffset2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_soffset1 H_valid_soffset2 H_valid_sb1 H_valid_sb2 H_eq_soffset stk mem strg exts H_stk_len) as H_safe_sstack_val_cmp_soffset.
    destruct H_safe_sstack_val_cmp_soffset as [v_soffset [H_eval_soffset1' H_eval_soffset2']].

    pose proof (H_safe_sstack_val_cmp ssize1 ssize2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_ssize1 H_valid_ssize2 H_valid_sb1 H_valid_sb2 H_eq_ssize stk mem strg exts H_stk_len) as H_safe_sstack_val_cmp_ssize.
    destruct H_safe_sstack_val_cmp_ssize as [v_ssize [H_eval_ssize1' H_eval_ssize2']].

    rewrite H_eval_soffset1 in H_eval_soffset1'.
    injection H_eval_soffset1' as H_size1_eq_v_soffset.

    rewrite H_eval_soffset2 in H_eval_soffset2'.
    injection H_eval_soffset2' as H_size2_eq_v_soffset.

    rewrite <- H_size1_eq_v_soffset in H_size2_eq_v_soffset.
    
    rewrite H_eval_ssize1 in H_eval_ssize1'.
    injection H_eval_ssize1' as H_size1_eq_v_ssize.

    rewrite H_eval_ssize2 in H_eval_ssize2'.
    injection H_eval_ssize2' as H_size2_eq_v_ssize.

    rewrite <- H_size1_eq_v_ssize in H_size2_eq_v_ssize.

    rewrite H_sha3_mem2.

    rewrite H_mem'_eq_mem1' in H_sha3_mem2'.
    rewrite H_size2_eq_v_soffset in H_sha3_mem2'.
    rewrite H_size2_eq_v_ssize in H_sha3_mem2'.

    rewrite H_sha3_mem2' in H_sha3_mem1'.
    apply H_sha3_mem1'.
  Qed.
  
End SHA3CmpImplSoundness.

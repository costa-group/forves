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
         destruct u1 as [skey1 svalue1|skey1 svalue1] eqn:E_u1; destruct u2 as [skey2 svalue2|skey2 svalue2] eqn:E_u2; try discriminate.
         +++ destruct (sstack_val_cmp d' skey1 skey2 maxidx1 sb1 maxidx2 sb2 instk_height ops) eqn:E_cmp_skey1_skey2; try discriminate.
             destruct (sstack_val_cmp d' svalue1 svalue2 maxidx1 sb1 maxidx2 sb2 instk_height ops) eqn:E_cmp_svalue1_svalue2; try discriminate.
             simpl in H_valid_smem1.
             destruct H_valid_smem1 as [ [H_valid_skey1 H_valid_svalue1] H_valid_smem1'].
             simpl in H_valid_smem2.
             destruct H_valid_smem2 as [ [H_valid_skey2 H_valid_svalue2] H_valid_smem2'].
             pose proof (IHsmem1' smem2' H_valid_smem1' H_valid_smem2' H_basic_mem_cmp stk mem strg ctx H_stk_len) as IHsmem1'_0.
             destruct IHsmem1'_0 as [mem' [IHsmem1'_0 IHsmem1'_1]].
             
             unfold safe_sstack_val_cmp_ext_1_d in H_sstack_val_cmp_snd.
             pose proof (H_sstack_val_cmp_snd d' H_d'_le_d) as H_sstack_val_cmp_snd_d'.
             unfold safe_sstack_val_cmp in H_sstack_val_cmp_snd_d'.
             pose proof(H_sstack_val_cmp_snd_d' skey1 skey2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_skey1 H_valid_skey2 H_valid_sb1 H_valid_sb2 E_cmp_skey1_skey2 stk mem strg ctx H_stk_len) as H_eval_skey1_skey2.
             destruct H_eval_skey1_skey2 as [skey_1_2_v [H_eval_skey1 H_eval_skey2]].
             
             pose proof(H_sstack_val_cmp_snd_d' svalue1 svalue2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_svalue1 H_valid_svalue2 H_valid_sb1 H_valid_sb2 E_cmp_svalue1_svalue2 stk mem strg ctx H_stk_len) as H_eval_svalue1_svalue2.
             destruct H_eval_svalue1_svalue2 as [svalue_1_2_v [H_eval_svalue1 H_eval_svalue2]].
             
             exists (mstore mem' svalue_1_2_v  skey_1_2_v).
             
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
             rewrite H_eval_skey1.
             rewrite H_eval_svalue1.
             
             unfold instantiate_memory_update at 2.
             rewrite H_eval_skey2.
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
         +++ destruct (sstack_val_cmp d' skey1 skey2 maxidx1 sb1 maxidx2 sb2 instk_height ops) eqn:E_cmp_skey1_skey2; try discriminate.
             destruct (sstack_val_cmp d' svalue1 svalue2 maxidx1 sb1 maxidx2 sb2 instk_height ops) eqn:E_cmp_svalue1_svalue2; try discriminate.
             simpl in H_valid_smem1.
             destruct H_valid_smem1 as [ [H_valid_skey1 H_valid_svalue1] H_valid_smem1'].
             simpl in H_valid_smem2.
             destruct H_valid_smem2 as [ [H_valid_skey2 H_valid_svalue2] H_valid_smem2'].
             pose proof (IHsmem1' smem2' H_valid_smem1' H_valid_smem2' H_basic_mem_cmp stk mem strg ctx H_stk_len) as IHsmem1'_0.
             destruct IHsmem1'_0 as [mem' [IHsmem1'_0 IHsmem1'_1]].
             
             unfold safe_sstack_val_cmp_ext_1_d in H_sstack_val_cmp_snd.
             pose proof (H_sstack_val_cmp_snd d' H_d'_le_d) as H_sstack_val_cmp_snd_d'.
             unfold safe_sstack_val_cmp in H_sstack_val_cmp_snd_d'.
             pose proof(H_sstack_val_cmp_snd_d' skey1 skey2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_skey1 H_valid_skey2 H_valid_sb1 H_valid_sb2 E_cmp_skey1_skey2 stk mem strg ctx H_stk_len) as H_eval_skey1_skey2.
             destruct H_eval_skey1_skey2 as [skey_1_2_v [H_eval_skey1 H_eval_skey2]].
             
             pose proof(H_sstack_val_cmp_snd_d' svalue1 svalue2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_svalue1 H_valid_svalue2 H_valid_sb1 H_valid_sb2 E_cmp_svalue1_svalue2 stk mem strg ctx H_stk_len) as H_eval_svalue1_svalue2.
             destruct H_eval_svalue1_svalue2 as [svalue_1_2_v [H_eval_svalue1 H_eval_svalue2]].
             
             exists (mstore mem' (split1_byte (svalue_1_2_v: word ((S (pred BytesInEVMWord))*8))) skey_1_2_v).
             
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
             rewrite H_eval_skey1.
             rewrite H_eval_svalue1.
             
             unfold instantiate_memory_update at 2.
             rewrite H_eval_skey2.
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
    Admitted.

    
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


End MemoryCmpImplSoundness.

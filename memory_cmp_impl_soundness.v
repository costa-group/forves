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


  
  Lemma swap_memory_updates_snd:
    forall sstrg u1 u2 maxidx sb instk_height ops,
      valid_smemory instk_height maxidx smem ->
      valid_smemory_update instk_height maxidx u1 ->
      valid_smemory_update instk_height maxidx u2 ->
      valid_bindings instk_height maxidx sb ops ->
      swap_memory_update u1 u2 maxidx sb = true ->
      forall stk mem strg ctx, 
             length stk = instk_height ->
             exists strg' : storage,
               eval_smemory (u1::u2::smem) maxidx sb stk mem strg ctx ops = Some strg' /\
                 eval_smemory (u2::u1::smem) maxidx sb stk mem strg ctx ops = Some strg'.
  Proof.
  Theorem po_memory_cmp_snd:
    safe_smemory_cmp_ext_wrt_sstack_value_cmp po_memory_cmp.
  Proof.
  Admitted.


End MemoryCmpImplSoundness.

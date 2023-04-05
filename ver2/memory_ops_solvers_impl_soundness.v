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
  
  Lemma basic_mload_solver_snd: mload_solver_ext_snd basic_mload_solver.    
  Admitted.
  
  Lemma basic_smemory_updater_snd: smemory_updater_ext_snd basic_smemory_updater.
  Admitted.
  

End MemoryOpsSolversImplSoundness.

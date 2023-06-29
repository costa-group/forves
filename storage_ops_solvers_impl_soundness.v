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

Require Import FORVES.storage_ops_solvers.
Import StorageOpsSolvers.

Require Import FORVES.storage_ops_solvers_impl.
Import StorageOpsSolversImpl.

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
        
      
            
    
      
  Admitted.
          
        
      
  Lemma basic_sstorage_updater_snd: sstorage_updater_ext_snd basic_sstorage_updater.
  Admitted.

End StorageOpsSolversImplSoundness.

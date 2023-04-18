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
  Admitted.
  (*
  Proof.
    
    unfold sload_solver_ext_snd.
    intros sstack_val_cmp H_safe_sstack_val_cmp.
    unfold sload_solver_snd.
    split.

    (* Valid smv *)
    - unfold sload_solver_valid_res.
      intros m sstrg skey instk_height smv ops.
      revert sstrg.
      induction sstrg as [|u sstrg' IHsstrg'].
      + simpl.
        intros _ H_valid_skey H_valid_solver.
        pose proof (symsload_valid_smv instk_height (get_maxidx_smap m) skey [] ops H_valid_skey (empty_sstrg_is_valid instk_height (get_maxidx_smap m))) as H_valid_smv.
        rewrite <- H_valid_solver.
        apply H_valid_smv.
      + intros H_valid_sstrg H_valid_skey H_solver.
        simpl in H_valid_sstrg.
        destruct H_valid_sstrg as [H_valid_u H_valid_sstrg'].
        unfold basic_sload_solver in H_solver.
        fold basic_sload_solver in H_solver.
        destruct u as [skey' svalue].
        destruct (sstack_val_cmp (S (get_maxidx_smap m)) skey skey' (get_maxidx_smap m) (get_bindings_smap m) (get_maxidx_smap m) (get_bindings_smap m) instk_height ops) eqn:E_sstack_val_cmp_skey_skey'.
        * rewrite <- H_solver.
          simpl.
          simpl in H_valid_u.
          apply H_valid_u.
        * destruct (not_eq_keys skey skey') eqn:E_neq_skey_skey'.
          ** pose proof (IHsstrg' H_valid_sstrg' H_valid_skey H_solver) as H_valid_smv.
             apply H_valid_smv.
          ** pose proof (valid_sstorage_when_extended_with_valid_update instk_height (get_maxidx_smap m) (U_SSTORE sstack_val skey' svalue) sstrg' H_valid_u H_valid_sstrg') as H_valid_u_sstrg'.
             pose proof (symsload_valid_smv instk_height (get_maxidx_smap m) skey (U_SSTORE sstack_val skey' svalue :: sstrg') ops H_valid_skey H_valid_u_sstrg') as H_valid_smv.
             rewrite <- H_solver.
             apply H_valid_smv.

    (* Correctness *)

    - unfold sload_solver_valid_res.
      intros m sstrg skey instk_height smv ops.
      revert sstrg.
      induction sstrg as [|u sstrg' IHsstrg'].
      + intros idx1 m1 H_valid_m H_valid_sstrg H_valid_skey H_solver H_add_to_smap.
        simpl in H_solver.
        rewrite <- H_solver in H_add_to_smap.
        exists idx1.
        exists m1.
        split.
        * apply H_add_to_smap.
        * intros stk mem strg ctx H_len_stk.
          destruct m as [maxidx sb] eqn:E_m.
          simpl in H_add_to_smap.
          injection H_add_to_smap as H_idx1 H_m1.
          rewrite <- H_idx1.
          rewrite <- H_m1.
          simpl.
          unfold eval_sstack_val.
          remember (S maxidx) as s_maxidx. (* avoid unfolding too much *)
          simpl.
          rewrite Nat.eqb_refl.
          simpl.
          rewrite Heqs_maxidx.
          symmetry in H_len_stk.
          simpl in H_valid_m.
          unfold valid_smap in H_valid_m.
          pose proof (eval_sstack_val'_succ (S maxidx) instk_height skey stk mem strg ctx maxidx sb ops H_len_stk H_valid_skey H_valid_m (gt_Sn_n maxidx)) as H_eval_skey_scc.
          destruct H_eval_skey_scc as [ckey H_eval_skey_scc].
          
          rewrite H_eval_skey_scc.
          exists (concrete_interpreter.ConcreteInterpreter.sload strg ckey).
          split; reflexivity.

      + intros idx1 m1 H_valid_m H_valid_sstrg H_valid_skey H_solver H_add_to_smap.
        simpl in H_solver.
        destruct u as [skey' svalue] eqn:E_u.
        destruct (sstack_val_cmp (S (get_maxidx_smap m)) skey skey' (get_maxidx_smap m) (get_bindings_smap m) (get_maxidx_smap m) (get_bindings_smap m) instk_height ops) eqn:E_cmp_skey_skey'.
        * destruct m as [maxidx sb] eqn:E_m.
          simpl in H_add_to_smap.
          injection H_add_to_smap as H_maxidx_eq_idx1 H_m1.
          exists maxidx.
          exists (SymMap (S maxidx) ((maxidx,(SymSLOAD skey (U_SSTORE sstack_val skey' svalue :: sstrg')))::sb)).
          split; try reflexivity.
          intros stk mem strg ctx H_len.
          rewrite <- H_m1.
          rewrite <- H_maxidx_eq_idx1.
          remember (S maxidx) as s_maxidx. (* avoid unfolding too much *)
          unfold eval_sstack_val at 2.
          unfold get_maxidx_smap.
          unfold get_bindings_smap.
          unfold eval_sstack_val'. fold eval_sstack_val'.
          unfold follow_in_smap at 1.
          rewrite Nat.eqb_refl.
          unfold is_fresh_var_smv at 1.

          symmetry in H_len.

          unfold valid_smap in H_valid_m.
          simpl in H_valid_m.
          unfold get_maxidx_smap in H_valid_sstrg.
          pose proof (valid_sstorage_S_maxidx instk_height maxidx (U_SSTORE sstack_val skey' svalue :: sstrg') H_valid_sstrg) as H_valid_sstrg_S_maxidx.
          pose proof (valid_bindings_S_maxidx instk_height maxidx).

          
          
          pose proof (eval_map_o_sstrg_succ).
          pose proof (eval_map_o_sstrg_succ instk_height (S maxidx) sb stk mem strg ctx ops (U_SSTORE sstack_val skey' svalue :: sstrg') H_len H_valid_sstrg_S_maxidx).
          
          unfold eval_sstack_val.
          simpl get_maxidx_smap.
          simpl get_bindings_smap.
          
          remember (S maxidx) as s_maxidx. (* avoid unfolding too much *)

          unfold eval_sstack_val' at 2.
          fold eval_sstack_val'.

          unfold valid_sstorage in H_valid_sstrg. fold valid_sstorage in H_valid_sstrg.
          unfold get_maxidx_smap in H_valid_sstrg.
          unfold get_bindings_smap in H_valid_sstrg.
          destruct H_valid_sstrg as [H_valid_u H_valid_sstrg'].
          assert(H_valid_u' := H_valid_u).
          simpl in H_valid_u'.
          destruct H_valid_u' as [H_valid_skey' H_valid_svalue].

          simpl in H_valid_m.
          assert(H_valid_sb := H_valid_m).
          unfold valid_smap in H_valid_sb.

          assert(H_valid_ext_sb: valid_bindings instk_height (S maxidx) ((maxidx, SymSLOAD skey (U_SSTORE sstack_val skey' svalue :: sstrg')) :: sb) ops).
          {
            simpl.
            repeat split.
            - apply H_valid_skey.
            - apply H_valid_skey'.
            - apply H_valid_svalue.
            - apply H_valid_sstrg'.
            - apply H_valid_sb.
            }.

          pose proof (follow_in_smap_suc ((maxidx, SymSLOAD skey (U_SSTORE sstack_val skey' svalue :: sstrg')) :: sb) (FreshVar maxidx) instk_height (S maxidx) ops (valid_sstack_val_freshvar_Sn_n instk_height maxidx) H_valid_ext_sb) as H_sollow_succ.
          
          destruct H_sollow_succ as [smv' [maxidx' [sb' [H_sollow_succ H_sollow_succ_not_FreshVar]]]].
          rewrite Heqs_maxidx.
          rewrite H_sollow_succ.

          simpl in H_valid_m.
          unfold valid_smap in H_valid_m.
          simpl.
          fold eval_sstack_val'.
          rewrite Nat.eqb_refl.

          simpl in H_add_to_smap.
          injection H_add_to_smap as H_idx1 H_m1.
          rewrite <- H_idx1.
          rewrite <- H_m1.
          rewrite <- H_solver.
          simpl.
          unfold eval_sstack_val.
          remember (S maxidx) as s_maxidx. (* avoid unfolding too much *)
          unfold eval_sstack_val' at 2.
          fold eval_sstack_val'.
          simpl.
          fold eval_sstack_val'.
          rewrite Nat.eqb_refl.

*)

          
       
          
        
        
      
  Lemma basic_sstorage_updater_snd: sstorage_updater_ext_snd basic_sstorage_updater.
  Admitted.

End StorageOpsSolversImplSoundness.

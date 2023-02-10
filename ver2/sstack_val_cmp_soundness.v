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

Require Import FORVES.sstack_val_cmp_impl.
Import SStackValCmpImpl.

Require Import FORVES.eval_common.
Import EvalCommon.


Module SStackValCmpImplSoundness.


 
  Lemma compare_sstack_val_d0_snd:
    sstack_val_cmp_fail_for_d_eq_0 compare_sstack_val.
  Proof.
    unfold sstack_val_cmp_fail_for_d_eq_0.
    intros.
    simpl.
    reflexivity.
  Qed.

  Lemma compare_sstack_val_snd:
    safe_sstack_value_cmp_wrt_others compare_sstack_val.
  Proof.
    unfold safe_sstack_value_cmp_wrt_others.
    induction d as [|d' IHd'].
    - intros smemory_cmp sstorage_cmp sha3_cmp H_safe_smemory_cmp H_safe_sstorage_cmp H_safe_sha3_cmp.
      unfold safe_sstack_val_cmp_ext_2_d.
      unfold safe_sstack_val_cmp_ext_1_d.
      intros d' H_d'_le_1.
      unfold safe_sstack_val_cmp.
      intros sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_sv1 H_valid_sv2 H_valid_sb1 H_valid_sb2 H_cmp_sv1_sv2.      apply Nat.leb_le in H_d'_le_1 as H_d'_le_1_leb.

      intros stk mem strg ctx H_len_stk.
      unfold eval_sstack_val.
      unfold eval_sstack_val'. fold eval_sstack_val'.

      destruct d' as [|d''] eqn:E_d'; try discriminate; destruct d'' as [|d'''] eqn:E_d''; try discriminate.
      unfold compare_sstack_val in H_cmp_sv1_sv2.
      
      pose proof (follow_in_smap_suc sb1 sv1 instk_height maxidx1 ops H_valid_sv1 H_valid_sb1) as H_follow_suc_sv1.
      destruct H_follow_suc_sv1 as [smv1 [maxidx1' [sb1' [H_follow_suc_sv1 _]]]].
      pose proof (follow_in_smap_suc sb2 sv2 instk_height maxidx2 ops H_valid_sv2 H_valid_sb2) as H_follow_suc_sv2.
      destruct H_follow_suc_sv2 as [smv2 [maxidx2' [sb2' [H_follow_suc_sv2 _]]]].

      rewrite H_follow_suc_sv1.
      rewrite H_follow_suc_sv2.

      rewrite H_follow_suc_sv1 in H_cmp_sv1_sv2.
      rewrite H_follow_suc_sv2 in H_cmp_sv1_sv2.

      pose proof (valid_follow_in_smap sb1 sv1 instk_height maxidx1 ops smv1 maxidx1' sb1' H_valid_sv1 H_valid_sb1 H_follow_suc_sv1) as H_follow_valid_sv1.
      pose proof (valid_follow_in_smap sb2 sv2 instk_height maxidx2 ops smv2 maxidx2' sb2' H_valid_sv2 H_valid_sb2 H_follow_suc_sv2) as H_follow_valid_sv2.

      destruct smv1 eqn:E_smv1; destruct smv2 eqn:E_smv2; try discriminate.

      + destruct val; destruct val0; try discriminate.
        * apply weqb_sound in H_cmp_sv1_sv2.
          rewrite H_cmp_sv1_sv2.
          exists val0.
          split; reflexivity.
        * apply andb_prop in H_cmp_sv1_sv2 as [H_var_va0 H_cmp_sv1_sv2].
          apply andb_prop in H_cmp_sv1_sv2 as [H_var_lt_inskt H_var0_lt_instk].
          apply Nat.eqb_eq in H_var_va0.
          rewrite H_var_va0.
          rewrite <- H_len_stk in H_var0_lt_instk.
          apply Nat.ltb_lt in H_var0_lt_instk.
          pose proof (nth_error_nth' stk WZero H_var0_lt_instk) as H_nth_error.
          rewrite H_nth_error.
          exists (nth var0 stk WZero).
          split; reflexivity.
      + apply N.eqb_eq in H_cmp_sv1_sv2. rewrite H_cmp_sv1_sv2. exists (get_tags_ctx ctx val0). split; reflexivity.
      + destruct (label =?i label0) eqn:E_eqb_label_label0; try discriminate.
        apply eqb_stack_op_instr_eq in E_eqb_label_label0 as E_eq_label_label0.
        rewrite <- E_eq_label_label0.
        rewrite <- E_eq_label_label0 in H_follow_suc_sv2.
        destruct (ops label) eqn:E_ops_label.
        destruct args as [|a args'] eqn:E_args; destruct args0 as [|a0 args0'] eqn:E_args_0.
        * simpl in H_cmp_sv1_sv2.
          simpl.
          destruct n.
          ** exists (f ctx []). split; reflexivity.
          ** simpl in H_follow_valid_sv1.
             simpl in H_follow_valid_sv2.
             destruct H_follow_valid_sv1 as [H_follow_valid_sv1_0 _].
             unfold valid_stack_op_instr in H_follow_valid_sv1_0.
             rewrite E_ops_label in H_follow_valid_sv1_0.
             destruct H_follow_valid_sv1_0 as [H_follow_valid_sv1_0 _].
             discriminate H_follow_valid_sv1_0.
        * simpl in H_cmp_sv1_sv2. destruct H_comm; discriminate.
        * simpl in H_cmp_sv1_sv2. destruct H_comm; try discriminate. destruct args'; try discriminate.
          destruct args'; try discriminate.
        * simpl in H_cmp_sv1_sv2. destruct H_comm; try discriminate.
          destruct args' as [| a' args'']; try discriminate.                                                      
          destruct args'' as [| a'' args''']; try discriminate.
          destruct args0' as [| a0' args0'']; try discriminate.
          destruct args0'' as [| a0'' args0''']; try discriminate.
      + unfold safe_sha3_cmp_ext_d in H_safe_sha3_cmp.
        pose proof (H_safe_sha3_cmp 0 (Nat.le_refl 0)) as H_safe_sha3_cmp.
        simpl in H_safe_sha3_cmp.
        unfold safe_sha3_cmp in H_safe_sha3_cmp.

        simpl in H_follow_valid_sv1.
        destruct H_follow_valid_sv1 as [ [H_follow_valid_offset [H_follow_valid_size H_follow_valid_smem]] [H_follow_valid_sb1' H_maxidx1_gt_maxidx1']].
        pose proof (H_maxidx1_gt_maxidx1' (eq_refl true)) as  H_maxidx1_gt_maxidx1'.
        
        simpl in H_follow_valid_sv2.
        destruct H_follow_valid_sv2 as [ [H_follow_valid_offset0 [H_follow_valid_size0 H_follow_valid_smem0]] [H_follow_valid_sb2' H_maxidx2_gt_maxidx2']].
        pose proof (H_maxidx2_gt_maxidx2' (eq_refl true)) as  H_maxidx2_gt_maxidx2'.
        
        
        pose proof (H_safe_sha3_cmp offset size smem offset0 size0 smem0 maxidx1' sb1' maxidx2' sb2' instk_height ops H_follow_valid_offset H_follow_valid_size H_follow_valid_offset0 H_follow_valid_size0 H_follow_valid_sb1' H_follow_valid_sb2' H_follow_valid_smem H_follow_valid_smem0 H_cmp_sv1_sv2 stk mem strg ctx) as H_safe_sha3_cmp.
        destruct H_safe_sha3_cmp as [coffset [csize [mem1 [coffset0 [csize0 [mem2 [v [H_eval_smem [H_eval_smem0 [H_eval_offset [H_eval_size [H_eval_offset0 [H_eval_size0 [H_sha3_mem1 H_sha3_mem2]]]]]]]]]]]]]].

        unfold eval_smemory in H_eval_smem.
        destruct (map_option (EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx1' sb1' ops)) smem) as [updates|] eqn:H_eval_smem_0; try discriminate.
        unfold eval_sstack_val in H_eval_smem_0.
        assert (H_maxidx1_ge_S_maxidx1': S maxidx1' <= maxidx1). intuition.
        pose proof (instantiate_memory_update_mapo_preserved_when_depth_ext_le smem (S maxidx1') maxidx1 stk mem strg ctx maxidx1' sb1' ops updates H_maxidx1_ge_S_maxidx1' H_eval_smem_0) as H_eval_smem_0_ext.
        rewrite H_eval_smem_0_ext.
        
        unfold eval_smemory in H_eval_smem0.
        destruct (map_option (EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx2' sb2' ops)) smem0) as [updates0|] eqn:H_eval_smem0_0; try discriminate.
        unfold eval_sstack_val in H_eval_smem0_0.
        assert (H_maxidx2_ge_S_maxidx2': S maxidx2' <= maxidx2). intuition.
        pose proof (instantiate_memory_update_mapo_preserved_when_depth_ext_le smem0 (S maxidx2') maxidx2 stk mem strg ctx maxidx2' sb2' ops updates0 H_maxidx2_ge_S_maxidx2' H_eval_smem0_0) as H_eval_smem0_0_ext.
        rewrite H_eval_smem0_0_ext.

        unfold eval_sstack_val in H_eval_offset.
        pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx1') maxidx1 maxidx1' sb1' offset coffset stk mem strg ctx ops H_maxidx1_ge_S_maxidx1' H_eval_offset) as H_eval_offset_0.
        rewrite H_eval_offset_0.

        unfold eval_sstack_val in H_eval_size.
        pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx1') maxidx1 maxidx1' sb1' size csize stk mem strg ctx ops H_maxidx1_ge_S_maxidx1' H_eval_size) as H_eval_size_0.
        rewrite H_eval_size_0.

        unfold eval_sstack_val in H_eval_offset0.
        pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx2') maxidx2 maxidx2' sb2' offset0 coffset0 stk mem strg ctx ops H_maxidx2_ge_S_maxidx2' H_eval_offset0) as H_eval_offset0_0.
        rewrite H_eval_offset0_0.

        unfold eval_sstack_val in H_eval_size0.
        pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx2') maxidx2 maxidx2' sb2' size0 csize0 stk mem strg ctx ops H_maxidx2_ge_S_maxidx2' H_eval_size0) as H_eval_size0_0.
        rewrite H_eval_size0_0.

        injection H_eval_smem as H_eval_smem.
        rewrite H_eval_smem.
        injection H_eval_smem0 as H_eval_smem0.
        rewrite H_eval_smem0.
        
        rewrite H_sha3_mem1.
        rewrite H_sha3_mem2.
        exists v.
        split; reflexivity.

    - intros smemory_cmp sstorage_cmp sha3_cmp H_safe_smemory_cmp H_safe_sstorage_cmp H_safe_sha3_cmp.
      unfold safe_sstack_val_cmp_ext_2_d.
      unfold safe_sstack_val_cmp_ext_1_d.
      unfold safe_sstack_val_cmp.
      intros d'0 H_d'0_le_SS_d'.
      intros sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops H_valid_sv1 H_valid_sv2 H_valid_sb1 H_valid_sb2 H_cmp_sv1_sv2.
      intros stk mem strg ctx.
      destruct d'0; try discriminate.
      simpl in H_cmp_sv1_sv2.
      unfold eval_sstack_val.
      unfold eval_sstack_val'. fold eval_sstack_val'.
      intros H_len_stk.

      assert(H_d'_le_Sd': d' <= S d'). intuition.

      pose proof (safe_smemory_cmp_ext_d_lt smemory_cmp (compare_sstack_val smemory_cmp sstorage_cmp sha3_cmp) d'  (S d') H_d'_le_Sd' H_safe_smemory_cmp) as H_safe_smemory_cmp_d'.
      pose proof (safe_sstorage_cmp_ext_d_lt sstorage_cmp (compare_sstack_val smemory_cmp sstorage_cmp sha3_cmp) d'  (S d') H_d'_le_Sd' H_safe_sstorage_cmp) as H_safe_sstorgae_cmp_d'.
      pose proof (safe_sha3_cmp_ext_d_lt sha3_cmp (compare_sstack_val smemory_cmp sstorage_cmp sha3_cmp) d'  (S d') H_d'_le_Sd' H_safe_sha3_cmp) as H_safe_sha3_cmp_d'.
      pose proof (IHd' smemory_cmp sstorage_cmp sha3_cmp H_safe_smemory_cmp_d' H_safe_sstorgae_cmp_d' H_safe_sha3_cmp_d') as H_safe_sstack_value_cmp_cmp_Sd'.
      
      assert(H_d'0_le_Sd': d'0 <= S d'). intuition.
        

      pose proof (safe_sstack_val_cmp_ext_2_d_le compare_sstack_val smemory_cmp sstorage_cmp sha3_cmp d'0 (S d') H_d'0_le_Sd' H_safe_sstack_value_cmp_cmp_Sd') as H_safe_sstack_value_cmp_cmp_d'0.

      pose proof (follow_in_smap_suc sb1 sv1 instk_height maxidx1 ops H_valid_sv1 H_valid_sb1) as H_follow_suc_sv1.
      destruct H_follow_suc_sv1 as [smv1 [maxidx1' [sb1' [H_follow_suc_sv1 _]]]].
      pose proof (follow_in_smap_suc sb2 sv2 instk_height maxidx2 ops H_valid_sv2 H_valid_sb2) as H_follow_suc_sv2.
      destruct H_follow_suc_sv2 as [smv2 [maxidx2' [sb2' [H_follow_suc_sv2 _]]]].

      rewrite H_follow_suc_sv1.
      rewrite H_follow_suc_sv2.

      rewrite H_follow_suc_sv1 in H_cmp_sv1_sv2.
      rewrite H_follow_suc_sv2 in H_cmp_sv1_sv2.

      pose proof (valid_follow_in_smap sb1 sv1 instk_height maxidx1 ops smv1 maxidx1' sb1' H_valid_sv1 H_valid_sb1 H_follow_suc_sv1) as H_follow_valid_sv1.
      pose proof (valid_follow_in_smap sb2 sv2 instk_height maxidx2 ops smv2 maxidx2' sb2' H_valid_sv2 H_valid_sb2 H_follow_suc_sv2) as H_follow_valid_sv2.
 
      destruct smv1 eqn:E_smv1; destruct smv2 eqn:E_smv2; try discriminate.
      
      + destruct val; destruct val0; try discriminate.
        * apply weqb_sound in H_cmp_sv1_sv2.
          rewrite H_cmp_sv1_sv2.
          exists val0.
          split; reflexivity.
        * apply andb_prop in H_cmp_sv1_sv2 as [H_var_va0 H_cmp_sv1_sv2].
          apply andb_prop in H_cmp_sv1_sv2 as [H_var_lt_inskt H_var0_lt_instk].
          apply Nat.eqb_eq in H_var_va0.
          rewrite H_var_va0.
          rewrite <- H_len_stk in H_var0_lt_instk.
          apply Nat.ltb_lt in H_var0_lt_instk.
          pose proof (nth_error_nth' stk WZero H_var0_lt_instk) as H_nth_error.
          rewrite H_nth_error.
          exists (nth var0 stk WZero).
          split; reflexivity.
      + apply N.eqb_eq in H_cmp_sv1_sv2. rewrite H_cmp_sv1_sv2. exists (get_tags_ctx ctx val0). split; reflexivity.
      + fold eval_sstack_val' in H_cmp_sv1_sv2. destruct (label =?i label0) eqn:E_eqb_label_label0; try discriminate.
        apply eqb_stack_op_instr_eq in E_eqb_label_label0 as E_eq_label_label0.
        rewrite <- E_eq_label_label0.
        rewrite <- E_eq_label_label0 in H_follow_suc_sv2.
        rewrite <- E_eq_label_label0 in H_follow_valid_sv2.

        destruct H_follow_valid_sv1 as [H_follow_valid_sv1_0 [H_follow_valid_sv1_1 H_follow_valid_sv1_2]].
        simpl in H_follow_valid_sv1_0.
        unfold valid_stack_op_instr in H_follow_valid_sv1_0.
        destruct (ops label) eqn:E_ops_label.
        destruct H_follow_valid_sv1_0 as [H_follow_valid_sv1_0_0 H_follow_valid_sv1_0_1].

        destruct H_follow_valid_sv2 as [H_follow_valid_sv2_0 [H_follow_valid_sv2_1 H_follow_valid_sv2_2]].
        simpl in H_follow_valid_sv2_0.
        unfold valid_stack_op_instr in H_follow_valid_sv2_0.
        rewrite E_ops_label in H_follow_valid_sv2_0.
        destruct H_follow_valid_sv2_0 as [H_follow_valid_sv2_0_0 H_follow_valid_sv2_0_1].

        apply Nat.eqb_eq in H_follow_valid_sv1_0_0 as H_follow_valid_sv1_0_0_eq.
        apply Nat.eqb_eq in H_follow_valid_sv2_0_0 as H_follow_valid_sv2_0_0_eq.

        rewrite H_follow_valid_sv1_0_0_eq.
        rewrite H_follow_valid_sv2_0_0_eq.
        assert(H_follow_valid_sv1_0_0_eq' := H_follow_valid_sv1_0_0_eq).
        rewrite <- H_follow_valid_sv2_0_0 in H_follow_valid_sv1_0_0_eq'.
        
        unfold safe_sstack_val_cmp_ext_2_d in H_safe_sstack_value_cmp_cmp_d'0.
        unfold safe_sstack_val_cmp_ext_1_d in H_safe_sstack_value_cmp_cmp_d'0.
        unfold safe_sstack_val_cmp in H_safe_sstack_value_cmp_cmp_d'0.
        
        assert(H_fldr:
                forall args1 args2,
                  valid_sstack instk_height maxidx1' args1 ->
                  valid_sstack instk_height maxidx2' args2 ->
                  fold_right_two_lists (fun e1 e2 : sstack_val => compare_sstack_val smemory_cmp sstorage_cmp sha3_cmp d'0 e1 e2 maxidx1' sb1' maxidx2' sb2' instk_height ops) args1 args2 = true ->
                  exists args',
                    map_option (fun sv' : sstack_val => eval_sstack_val' (S maxidx1') sv' stk mem strg ctx maxidx1' sb1' ops) args1 = Some args' /\
                      map_option (fun sv' : sstack_val => eval_sstack_val' (S maxidx2') sv' stk mem strg ctx maxidx2' sb2' ops) args2 = Some args').
        (* staring proof of assert *)
        * induction args1 as [|a1_1 args1'].
          ** destruct args2 as [|a1_2 args2']; try discriminate.
             intros.
             simpl.
             exists [].
             split; reflexivity.
          ** destruct args2 as [|a1_2 args2']; try discriminate.
             intros H_valid_sstack_args1 H_valid_sstack_args2 H_fldr.
             unfold fold_right_two_lists in H_fldr.
             rewrite <- fold_right_two_lists_ho in H_fldr.
             destruct (compare_sstack_val smemory_cmp sstorage_cmp sha3_cmp d'0 a1_1 a1_2
                         maxidx1' sb1' maxidx2' sb2' instk_height ops) eqn:E_cmp_a1_1_a1_2; try discriminate.
             simpl in H_valid_sstack_args1.
             destruct H_valid_sstack_args1 as [H_valid_a1_1 H_valid_arg1'].
             simpl in H_valid_sstack_args2.
             destruct H_valid_sstack_args2 as [H_valid_a1_2 H_valid_arg2'].
             
             pose proof (H_safe_sstack_value_cmp_cmp_d'0 d'0 (Nat.le_refl d'0) a1_1 a1_2 maxidx1' sb1' maxidx2' sb2' instk_height ops H_valid_a1_1 H_valid_a1_2 H_follow_valid_sv1_1 H_follow_valid_sv2_1 E_cmp_a1_1_a1_2 stk mem strg ctx H_len_stk) as H_eval_sstack_value_a1_1_a1_2.
             destruct H_eval_sstack_value_a1_1_a1_2 as [v [H_eval_sstack_value_a1_1 H_eval_sstack_value_a1_2]].

             unfold eval_sstack_val in H_eval_sstack_value_a1_1.
             unfold eval_sstack_val in H_eval_sstack_value_a1_2.
             unfold map_option.
             repeat rewrite <- map_option_ho.
             rewrite H_eval_sstack_value_a1_1.
             rewrite H_eval_sstack_value_a1_2.
             pose proof (IHargs1' args2' H_valid_arg1'  H_valid_arg2' H_fldr) as H_mapo.
             destruct H_mapo as [args' [H_mapo_args1' H_mapo_args2']].
             rewrite H_mapo_args1'.
             rewrite H_mapo_args2'.
             exists (v :: args').
             split; reflexivity.
        (* ending proof of assert *)
        * destruct (fold_right_two_lists
                      (fun e1 e2 : sstack_val =>
                       compare_sstack_val smemory_cmp sstorage_cmp sha3_cmp d'0 e1 e2 maxidx1' sb1' maxidx2' sb2'
                         instk_height ops) args args0) eqn:E_fldr.
          ** pose proof (H_fldr args args0 H_follow_valid_sv1_0_1 H_follow_valid_sv2_0_1 E_fldr) as H_fldr_0.
             destruct H_fldr_0 as [args' [H_fldr_0_0 H_fldr_0_1]].
             
             simpl in H_follow_valid_sv2_2.
             pose proof (H_follow_valid_sv2_2 (eq_refl true)) as H_follow_valid_sv2_2.
             
             simpl in H_follow_valid_sv1_2.
             pose proof (H_follow_valid_sv1_2 (eq_refl true)) as H_follow_valid_sv1_2.
             assert (H_maxidx1_ge_S_maxidx1': maxidx1 >= S maxidx1'). intuition.
             
             pose proof (eval_sstack_val'_mapo_preserved_when_depth_ext_le args (S maxidx1') maxidx1 stk mem strg ctx maxidx1' sb1' ops args' H_maxidx1_ge_S_maxidx1' H_fldr_0_0) as H_fldr_0_0_0.
             rewrite H_fldr_0_0_0.

             assert (H_maxidx2_ge_S_maxidx2': maxidx2 >= S maxidx2'). intuition.
             pose proof (eval_sstack_val'_mapo_preserved_when_depth_ext_le args0 (S maxidx2') maxidx2 stk mem strg ctx maxidx2' sb2' ops args' H_maxidx2_ge_S_maxidx2' H_fldr_0_1) as H_fldr_0_1_0.
             rewrite H_fldr_0_1_0.
             exists (f ctx args').
             split; reflexivity.
          ** destruct H_comm as [H_f_comm_proof|]; try discriminate.

             destruct args as [|a1 args]; try discriminate.
             destruct args as [|a2 args]; try discriminate.
             destruct args; try discriminate.
             destruct args0 as [|b1 args0]; try discriminate.
             destruct args0 as [|b2 args0]; try discriminate.
             destruct args0; try discriminate.

             destruct (compare_sstack_val smemory_cmp sstorage_cmp sha3_cmp d'0 a1 b2 maxidx1' sb1' maxidx2' sb2' instk_height ops) eqn:E_cmp_a1_b2; try discriminate.

             simpl in H_follow_valid_sv1_0_1.
             destruct H_follow_valid_sv1_0_1 as [H_follow_valid_a1 [H_follow_valid_a2 _]].
             simpl in H_follow_valid_sv2_0_1.
             destruct H_follow_valid_sv2_0_1 as [H_follow_valid_b1 [H_follow_valid_b2 _]].
             
             pose proof (H_safe_sstack_value_cmp_cmp_d'0 d'0 (Nat.le_refl d'0) a1 b2 maxidx1' sb1' maxidx2' sb2' instk_height ops H_follow_valid_a1 H_follow_valid_b2 H_follow_valid_sv1_1 H_follow_valid_sv2_1 E_cmp_a1_b2 stk mem strg ctx H_len_stk) as H_safe_sstack_value_cmp_a1_b2.
             unfold eval_sstack_val in H_safe_sstack_value_cmp_a1_b2.
             destruct H_safe_sstack_value_cmp_a1_b2 as [v1 [H_safe_sstack_value_cmp_a1 H_safe_sstack_value_cmp_b2]].

             pose proof (H_safe_sstack_value_cmp_cmp_d'0 d'0 (Nat.le_refl d'0) a2 b1 maxidx1' sb1' maxidx2' sb2' instk_height ops H_follow_valid_a2 H_follow_valid_b1 H_follow_valid_sv1_1 H_follow_valid_sv2_1 H_cmp_sv1_sv2 stk mem strg ctx H_len_stk) as H_safe_sstack_value_cmp_a2_b1.
             unfold eval_sstack_val in H_safe_sstack_value_cmp_a2_b1.
             destruct H_safe_sstack_value_cmp_a2_b1 as [v2 [H_safe_sstack_value_cmp_a2 H_safe_sstack_value_cmp_b1]].

             assert(H_Smaxidx1'_le_maxidx1: S maxidx1' <= maxidx1). intuition.
             pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx1') maxidx1 maxidx1' sb1' a1 v1 stk mem strg ctx ops H_Smaxidx1'_le_maxidx1 H_safe_sstack_value_cmp_a1) as H_safe_sstack_value_cmp_a1_ext.

             assert(H_Smaxidx2'_le_maxidx2: S maxidx2' <= maxidx2). intuition.
             pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx2') maxidx2 maxidx2' sb2' b2 v1 stk mem strg ctx ops H_Smaxidx2'_le_maxidx2 H_safe_sstack_value_cmp_b2) as H_safe_sstack_value_cmp_b2_ext.


             pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx1') maxidx1 maxidx1' sb1' a2 v2 stk mem strg ctx ops H_Smaxidx1'_le_maxidx1 H_safe_sstack_value_cmp_a2) as H_safe_sstack_value_cmp_a2_ext.

             pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx2') maxidx2 maxidx2' sb2' b1 v2 stk mem strg ctx ops H_Smaxidx2'_le_maxidx2 H_safe_sstack_value_cmp_b1) as H_safe_sstack_value_cmp_b1_ext.

             unfold map_option.
             rewrite H_safe_sstack_value_cmp_a1_ext.
             rewrite H_safe_sstack_value_cmp_b2_ext.
             rewrite H_safe_sstack_value_cmp_a2_ext.
             rewrite H_safe_sstack_value_cmp_b1_ext.

             exists (f ctx [v1; v2]).

             unfold commutative_op in H_f_comm_proof.
             rewrite H_f_comm_proof.
             split; reflexivity.
      + destruct (compare_sstack_val smemory_cmp sstorage_cmp sha3_cmp d'0 offset offset0 maxidx1' sb1' maxidx2' sb2' instk_height ops) eqn:E_cmp_offset_offset0; try discriminate.

        simpl in H_follow_valid_sv1.
        destruct H_follow_valid_sv1 as [[H_valid_offset H_valid_smem] [H_valid_sb1' H_maxidx1_gt_maxidx1']].
        pose proof (H_maxidx1_gt_maxidx1' (eq_refl true)) as H_maxidx1_gt_maxidx1'.

        simpl in H_follow_valid_sv2.
        destruct H_follow_valid_sv2 as [[H_valid_offset0 H_valid_smem0] [H_valid_sb2' H_maxidx2_gt_maxidx2']].
        pose proof (H_maxidx2_gt_maxidx2' (eq_refl true)) as H_maxidx2_gt_maxidx2'.


        pose proof (H_safe_sstack_value_cmp_cmp_d'0 d'0 (Nat.le_refl d'0) offset offset0 maxidx1' sb1' maxidx2' sb2' instk_height ops H_valid_offset H_valid_offset0 H_valid_sb1' H_valid_sb2' E_cmp_offset_offset0 stk mem strg ctx H_len_stk) as H_eval_offset_offset0.
        unfold eval_sstack_val in H_eval_offset_offset0.
        destruct H_eval_offset_offset0 as [v [H_eval_offset H_eval_offset0]].
        

        assert (H_Smaxidx1'_le_maxidx1: S maxidx1' <= maxidx1). intuition.
        pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx1') maxidx1 maxidx1' sb1' offset v stk mem strg ctx ops H_Smaxidx1'_le_maxidx1 H_eval_offset) as H_eval_soffset_ext.
        rewrite H_eval_soffset_ext.
        assert (H_Smaxidx2'_le_maxidx2: S maxidx2' <= maxidx2). intuition.
        pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx2') maxidx2 maxidx2' sb2' offset0 v stk mem strg ctx ops H_Smaxidx2'_le_maxidx2 H_eval_offset0) as H_eval_soffset0_ext.
        rewrite H_eval_soffset0_ext.

        unfold safe_smemory_cmp_ext_d in H_safe_smemory_cmp.
        unfold safe_smemory_cmp in H_safe_smemory_cmp.

        assert(H_d'0_le_d': d'0 <= S d'). intuition.

        pose proof (H_safe_smemory_cmp d'0 H_d'0_le_d' smem smem0 maxidx1' sb1' maxidx2' sb2' instk_height ops H_valid_sb1' H_valid_sb2' H_valid_smem H_valid_smem0 H_cmp_sv1_sv2 stk mem strg ctx) as H_safe_smemory_cmp_0.

        destruct H_safe_smemory_cmp_0 as [mem' [H_eval_mem H_eval_mem0]].
        unfold eval_smemory in H_eval_mem.
        unfold eval_smemory in H_eval_mem0.


        destruct (map_option
                   (instantiate_memory_update
                      (fun sv : sstack_val =>
                       eval_sstack_val sv stk mem strg ctx maxidx1'
                         sb1' ops)) smem) as [updates|] eqn:E_mapo_mem; try discriminate.
        unfold eval_sstack_val in E_mapo_mem.
        
        destruct (map_option
                    (instantiate_memory_update
                       (fun sv : sstack_val =>
                        eval_sstack_val sv stk mem strg ctx maxidx2'
                          sb2' ops)) smem0) as [updates0|] eqn:E_mapo_mem0; try discriminate.
        unfold eval_sstack_val in E_mapo_mem0.

        pose proof (instantiate_memory_update_mapo_preserved_when_depth_ext_le smem (S maxidx1') maxidx1 stk mem strg ctx maxidx1' sb1' ops updates H_Smaxidx1'_le_maxidx1 E_mapo_mem) as E_mapo_mem_ext.
        rewrite E_mapo_mem_ext.
        
        pose proof (instantiate_memory_update_mapo_preserved_when_depth_ext_le smem0 (S maxidx2') maxidx2 stk mem strg ctx maxidx2' sb2' ops updates0 H_Smaxidx2'_le_maxidx2 E_mapo_mem0) as E_mapo_mem0_ext.
        rewrite E_mapo_mem0_ext.

        injection H_eval_mem0 as H_eval_mem0.
        injection H_eval_mem as H_eval_mem.

        rewrite H_eval_mem0.
        rewrite H_eval_mem.

        exists (concrete_interpreter.ConcreteInterpreter.mload mem' v).
        split; reflexivity.
        
      + destruct (compare_sstack_val smemory_cmp sstorage_cmp sha3_cmp d'0 key key0 maxidx1' sb1' maxidx2' sb2' instk_height ops) eqn:E_cmp_key_key0; try discriminate.

        simpl in H_follow_valid_sv1.
        destruct H_follow_valid_sv1 as [[H_valid_key H_valid_sstrg] [H_valid_sb1' H_maxidx1_gt_maxidx1']].
        pose proof (H_maxidx1_gt_maxidx1' (eq_refl true)) as H_maxidx1_gt_maxidx1'.

        simpl in H_follow_valid_sv2.
        destruct H_follow_valid_sv2 as [[H_valid_key0 H_valid_sstrg0] [H_valid_sb2' H_maxidx2_gt_maxidx2']].
        pose proof (H_maxidx2_gt_maxidx2' (eq_refl true)) as H_maxidx2_gt_maxidx2'.


        pose proof (H_safe_sstack_value_cmp_cmp_d'0 d'0 (Nat.le_refl d'0) key key0 maxidx1' sb1' maxidx2' sb2' instk_height ops H_valid_key H_valid_key0 H_valid_sb1' H_valid_sb2' E_cmp_key_key0 stk mem strg ctx H_len_stk) as H_eval_key_key0.
        unfold eval_sstack_val in H_eval_key_key0.
        destruct H_eval_key_key0 as [v [H_eval_key H_eval_key0]].
        

        assert (H_Smaxidx1'_le_maxidx1: S maxidx1' <= maxidx1). intuition.
        pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx1') maxidx1 maxidx1' sb1' key v stk mem strg ctx ops H_Smaxidx1'_le_maxidx1 H_eval_key) as H_eval_skey_ext.
        rewrite H_eval_skey_ext.
        assert (H_Smaxidx2'_le_maxidx2: S maxidx2' <= maxidx2). intuition.
        pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx2') maxidx2 maxidx2' sb2' key0 v stk mem strg ctx ops H_Smaxidx2'_le_maxidx2 H_eval_key0) as H_eval_skey0_ext.
        rewrite H_eval_skey0_ext.

        unfold safe_sstorage_cmp_ext_d in H_safe_sstorage_cmp.
        unfold safe_sstorage_cmp in H_safe_sstorage_cmp.

        assert(H_d'0_le_d': d'0 <= S d'). intuition.

        pose proof (H_safe_sstorage_cmp d'0 H_d'0_le_d' sstrg sstrg0 maxidx1' sb1' maxidx2' sb2' instk_height ops H_valid_sb1' H_valid_sb2' H_valid_sstrg H_valid_sstrg0 H_cmp_sv1_sv2 stk mem strg ctx) as H_safe_sstorage_cmp_0.

        destruct H_safe_sstorage_cmp_0 as [strg' [H_eval_sstrg H_eval_sstrg0]].
        unfold eval_sstorage in H_eval_sstrg.
        unfold eval_sstorage in H_eval_sstrg0.


        destruct (map_option
                   (instantiate_storage_update
                      (fun sv : sstack_val =>
                       eval_sstack_val sv stk mem strg ctx maxidx1'
                         sb1' ops)) sstrg) as [updates|] eqn:E_mapo_strg; try discriminate.
        unfold eval_sstack_val in E_mapo_strg.
        
        destruct (map_option
                    (instantiate_storage_update
                       (fun sv : sstack_val =>
                        eval_sstack_val sv stk mem strg ctx maxidx2'
                          sb2' ops)) sstrg0) as [updates0|] eqn:E_mapo_strg0; try discriminate.
        unfold eval_sstack_val in E_mapo_strg0.

        pose proof (instantiate_storage_update_mapo_preserved_when_depth_ext_le sstrg (S maxidx1') maxidx1 stk mem strg ctx maxidx1' sb1' ops updates H_Smaxidx1'_le_maxidx1 E_mapo_strg) as E_mapo_strg_ext.
        rewrite E_mapo_strg_ext.
        
        pose proof (instantiate_storage_update_mapo_preserved_when_depth_ext_le sstrg0 (S maxidx2') maxidx2 stk mem strg ctx maxidx2' sb2' ops updates0 H_Smaxidx2'_le_maxidx2 E_mapo_strg0) as E_mapo_strg0_ext.
        rewrite E_mapo_strg0_ext.

        injection H_eval_sstrg0 as H_eval_sstrg0.
        injection H_eval_sstrg as H_eval_sstrg.

        rewrite H_eval_sstrg0.
        rewrite H_eval_sstrg.

        exists (concrete_interpreter.ConcreteInterpreter.sload strg' v).
        split; reflexivity.

      + assert(H_d'0_le_d': d'0 <= S d'). intuition.
        assert (H_Smaxidx1'_le_maxidx1: S maxidx1' <= maxidx1). intuition.
        assert (H_Smaxidx2'_le_maxidx2: S maxidx2' <= maxidx2). intuition.

        simpl in H_follow_valid_sv1.
        destruct H_follow_valid_sv1 as [[H_valid_offset [H_valid_size H_valid_smem]] [H_valid_sb1' H_maxidx1_gt_maxidx1']].
        pose proof (H_maxidx1_gt_maxidx1' (eq_refl true)) as H_maxidx1_gt_maxidx1'.

        simpl in H_follow_valid_sv2.
        destruct H_follow_valid_sv2 as [[H_valid_offset0 [H_valid_size0 H_valid_smem0]] [H_valid_sb2' H_maxidx2_gt_maxidx2']].
        pose proof (H_maxidx2_gt_maxidx2' (eq_refl true)) as H_maxidx2_gt_maxidx2'.

        destruct (if
                     compare_sstack_val smemory_cmp sstorage_cmp sha3_cmp d'0 offset offset0 maxidx1' sb1'
                       maxidx2' sb2' instk_height ops
                    then
                     if
                      compare_sstack_val smemory_cmp sstorage_cmp sha3_cmp d'0 size size0 maxidx1' sb1'
                        maxidx2' sb2' instk_height ops
                     then
                       smemory_cmp (compare_sstack_val smemory_cmp sstorage_cmp sha3_cmp d'0) smem smem0
                         maxidx1' sb1' maxidx2' sb2' instk_height ops
                     else false
                   else false) eqn:E_std_sha3.

        * destruct (compare_sstack_val smemory_cmp sstorage_cmp sha3_cmp d'0 offset offset0 maxidx1' sb1' maxidx2' sb2' instk_height ops) eqn:E_cmp_offset_offset0; try discriminate.
          destruct (compare_sstack_val smemory_cmp sstorage_cmp sha3_cmp d'0 size size0 maxidx1' sb1' maxidx2' sb2' instk_height ops) eqn:E_cmp_size_size0; try discriminate.



        pose proof (H_safe_sstack_value_cmp_cmp_d'0 d'0 (Nat.le_refl d'0) offset offset0 maxidx1' sb1' maxidx2' sb2' instk_height ops H_valid_offset H_valid_offset0 H_valid_sb1' H_valid_sb2' E_cmp_offset_offset0 stk mem strg ctx H_len_stk) as H_eval_offset_offset0.
        unfold eval_sstack_val in H_eval_offset_offset0.
        destruct H_eval_offset_offset0 as [v [H_eval_offset H_eval_offset0]].
        

        pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx1') maxidx1 maxidx1' sb1' offset v stk mem strg ctx ops H_Smaxidx1'_le_maxidx1 H_eval_offset) as H_eval_soffset_ext.
        rewrite H_eval_soffset_ext.
        pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx2') maxidx2 maxidx2' sb2' offset0 v stk mem strg ctx ops H_Smaxidx2'_le_maxidx2 H_eval_offset0) as H_eval_soffset0_ext.
        rewrite H_eval_soffset0_ext.


        pose proof (H_safe_sstack_value_cmp_cmp_d'0 d'0 (Nat.le_refl d'0) size size0 maxidx1' sb1' maxidx2' sb2' instk_height ops H_valid_size H_valid_size0 H_valid_sb1' H_valid_sb2' E_cmp_size_size0 stk mem strg ctx H_len_stk) as H_eval_size_size0.
        unfold eval_sstack_val in H_eval_size_size0.
        destruct H_eval_size_size0 as [v' [H_eval_size H_eval_size0]].
        

        pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx1') maxidx1 maxidx1' sb1' size v' stk mem strg ctx ops H_Smaxidx1'_le_maxidx1 H_eval_size) as H_eval_ssize_ext.
        rewrite H_eval_ssize_ext.
        pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx2') maxidx2 maxidx2' sb2' size0 v' stk mem strg ctx ops H_Smaxidx2'_le_maxidx2 H_eval_size0) as H_eval_ssize0_ext.
        rewrite H_eval_ssize0_ext.

        
        unfold safe_smemory_cmp_ext_d in H_safe_smemory_cmp.
        unfold safe_smemory_cmp in H_safe_smemory_cmp.


        pose proof (H_safe_smemory_cmp d'0 H_d'0_le_d' smem smem0 maxidx1' sb1' maxidx2' sb2' instk_height ops H_valid_sb1' H_valid_sb2' H_valid_smem H_valid_smem0 E_std_sha3 stk mem strg ctx) as H_safe_smemory_cmp_0.

        destruct H_safe_smemory_cmp_0 as [mem' [H_eval_mem H_eval_mem0]].
        unfold eval_smemory in H_eval_mem.
        unfold eval_smemory in H_eval_mem0.


        destruct (map_option
                   (instantiate_memory_update
                      (fun sv : sstack_val =>
                       eval_sstack_val sv stk mem strg ctx maxidx1'
                         sb1' ops)) smem) as [updates|] eqn:E_mapo_mem; try discriminate.
        unfold eval_sstack_val in E_mapo_mem.
        
        destruct (map_option
                    (instantiate_memory_update
                       (fun sv : sstack_val =>
                        eval_sstack_val sv stk mem strg ctx maxidx2'
                          sb2' ops)) smem0) as [updates0|] eqn:E_mapo_mem0; try discriminate.
        unfold eval_sstack_val in E_mapo_mem0.

        pose proof (instantiate_memory_update_mapo_preserved_when_depth_ext_le smem (S maxidx1') maxidx1 stk mem strg ctx maxidx1' sb1' ops updates H_Smaxidx1'_le_maxidx1 E_mapo_mem) as E_mapo_mem_ext.
        rewrite E_mapo_mem_ext.
        
        pose proof (instantiate_memory_update_mapo_preserved_when_depth_ext_le smem0 (S maxidx2') maxidx2 stk mem strg ctx maxidx2' sb2' ops updates0 H_Smaxidx2'_le_maxidx2 E_mapo_mem0) as E_mapo_mem0_ext.
        rewrite E_mapo_mem0_ext.

        injection H_eval_mem0 as H_eval_mem0.
        injection H_eval_mem as H_eval_mem.

        rewrite H_eval_mem0.
        rewrite H_eval_mem.
        exists (get_keccak256_ctx ctx (wordToNat v') (concrete_interpreter.ConcreteInterpreter.mload' mem' v (wordToNat v'))).
        split; reflexivity.
        * unfold safe_sha3_cmp_ext_d in H_safe_sha3_cmp.
          unfold safe_sha3_cmp in H_safe_sha3_cmp.
          pose proof (H_safe_sha3_cmp d'0 H_d'0_le_d' offset size smem offset0 size0 smem0 maxidx1' sb1' maxidx2' sb2' instk_height ops H_valid_offset H_valid_size H_valid_offset0 H_valid_size0 H_valid_sb1' H_valid_sb2' H_valid_smem H_valid_smem0 H_cmp_sv1_sv2 stk mem strg ctx) as H_safe_sha3_cmp_0.

          destruct H_safe_sha3_cmp_0 as [coffset [csize [mem1 [coffset0 [csize0 [mem2 [v [H_eval_smem [H_eval_smem0 [H_eval_offset [H_eval_size [H_eval_offset0 [H_eval_size0 [H_sha3_mem1 H_sha3_mem2]]]]]]]]]]]]]].

        unfold eval_smemory in H_eval_smem.
        destruct (map_option (EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx1' sb1' ops)) smem) as [updates|] eqn:H_eval_smem_0; try discriminate.
        unfold eval_sstack_val in H_eval_smem_0.
        assert (H_maxidx1_ge_S_maxidx1': S maxidx1' <= maxidx1). intuition.
        pose proof (instantiate_memory_update_mapo_preserved_when_depth_ext_le smem (S maxidx1') maxidx1 stk mem strg ctx maxidx1' sb1' ops updates H_maxidx1_ge_S_maxidx1' H_eval_smem_0) as H_eval_smem_0_ext.
        rewrite H_eval_smem_0_ext.
        
        unfold eval_smemory in H_eval_smem0.
        destruct (map_option (EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx2' sb2' ops)) smem0) as [updates0|] eqn:H_eval_smem0_0; try discriminate.
        unfold eval_sstack_val in H_eval_smem0_0.
        assert (H_maxidx2_ge_S_maxidx2': S maxidx2' <= maxidx2). intuition.
        pose proof (instantiate_memory_update_mapo_preserved_when_depth_ext_le smem0 (S maxidx2') maxidx2 stk mem strg ctx maxidx2' sb2' ops updates0 H_maxidx2_ge_S_maxidx2' H_eval_smem0_0) as H_eval_smem0_0_ext.
        rewrite H_eval_smem0_0_ext.

        unfold eval_sstack_val in H_eval_offset.
        pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx1') maxidx1 maxidx1' sb1' offset coffset stk mem strg ctx ops H_maxidx1_ge_S_maxidx1' H_eval_offset) as H_eval_offset_0.
        rewrite H_eval_offset_0.

        unfold eval_sstack_val in H_eval_size.
        pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx1') maxidx1 maxidx1' sb1' size csize stk mem strg ctx ops H_maxidx1_ge_S_maxidx1' H_eval_size) as H_eval_size_0.
        rewrite H_eval_size_0.

        unfold eval_sstack_val in H_eval_offset0.
        pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx2') maxidx2 maxidx2' sb2' offset0 coffset0 stk mem strg ctx ops H_maxidx2_ge_S_maxidx2' H_eval_offset0) as H_eval_offset0_0.
        rewrite H_eval_offset0_0.

        unfold eval_sstack_val in H_eval_size0.
        pose proof (eval_sstack_val'_preserved_when_depth_extended_le (S maxidx2') maxidx2 maxidx2' sb2' size0 csize0 stk mem strg ctx ops H_maxidx2_ge_S_maxidx2' H_eval_size0) as H_eval_size0_0.
        rewrite H_eval_size0_0.

        injection H_eval_smem as H_eval_smem.
        rewrite H_eval_smem.
        injection H_eval_smem0 as H_eval_smem0.
        rewrite H_eval_smem0.
        
        rewrite H_sha3_mem1.
        rewrite H_sha3_mem2.
        exists v.
        split; reflexivity.          
  Qed.

End SStackValCmpImplSoundness.


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

Require Import FORVES.flat_symbolic_state.
Import FlatSymbolicState.

Require Import FORVES.flat_symbolic_state_eval.
Import FlatSymbolicStateEval.


Lemma eval_sexpr_snd:
  forall sb maxidx sv stk mem strg exts ops flat_sb fsv,
    bindings_to_flat_bindings sb = Some flat_sb ->
    sstack_val_to_sexpr sv flat_sb = Some fsv ->
    eval_sstack_val sv stk mem strg exts maxidx sb ops = eval_sexpr fsv stk mem strg exts ops.
Proof.
  induction sb as [|p sb' IHsb'].
  - simpl.
    intros maxidx sv stk mem strg exts ops flat_sb fsv H_bs_to_flat_bs H_sstack_val_to_sexpr.
    injection H_bs_to_flat_bs as H_bs_to_flat_bs.
    rewrite <- H_bs_to_flat_bs in H_sstack_val_to_sexpr.
    simpl in H_sstack_val_to_sexpr.
    destruct sv; try (
      injection H_sstack_val_to_sexpr as H_sstack_val_to_sexpr;
      rewrite <- H_sstack_val_to_sexpr;
      simpl;
      reflexivity) || discriminate.
  - intros maxidx sv stk mem strg exts ops flat_sb fsv H_bs_to_flat_bs H_sstack_val_to_sexpr.
    
    destruct sv; try (
                     simpl;
                     destruct flat_sb; try discriminate;
                     simpl in H_sstack_val_to_sexpr;
                     injection H_sstack_val_to_sexpr as H_sstack_val_to_sexpr;
                     rewrite <- H_sstack_val_to_sexpr;
                     simpl;
                     reflexivity).

    destruct p as [key msv] eqn:E_p.
    
    simpl in H_bs_to_flat_bs.
    destruct (bindings_to_flat_bindings sb') as [flat_sb'|] eqn:E_fbs_sb'; try discriminate.
    destruct (smap_value_to_sexpr msv flat_sb') as [flat_sv|] eqn:E_smap_value_to_sexpr; try discriminate.
    injection H_bs_to_flat_bs as H_bs_to_flat_bs.
    rewrite <- H_bs_to_flat_bs in H_sstack_val_to_sexpr.
    
    simpl.

    destruct (key =? var) eqn:E_key_eqb_var.
    + 
      simpl in H_sstack_val_to_sexpr.
      rewrite E_key_eqb_var in H_sstack_val_to_sexpr.
      injection H_sstack_val_to_sexpr as H_sstack_val_to_sexpr.
      rewrite <- H_sstack_val_to_sexpr.
      destruct msv eqn:E_msv.
      * apply IHsb' with (sv:= val)(flat_sb:=flat_sb').
        ++ reflexivity.
        ++ destruct val; try (
                             destruct flat_sb';
                             simpl;
                             simpl in E_smap_value_to_sexpr;
                             injection E_smap_value_to_sexpr as E_smap_value_to_sexpr;
                             rewrite <- E_smap_value_to_sexpr;
                             reflexivity).
           destruct flat_sb'; try (simpl; simpl in E_smap_value_to_sexpr; discriminate).
           simpl.
           destruct p0.
           simpl in E_smap_value_to_sexpr.
           destruct (n =? var0) eqn:E_n_var0.
           +++ rewrite E_smap_value_to_sexpr. reflexivity.
           +++ apply E_smap_value_to_sexpr.
      * destruct flat_sb'; try (
                               simpl in E_smap_value_to_sexpr;
                               injection E_smap_value_to_sexpr as E_smap_value_to_sexpr;
                               rewrite <- E_smap_value_to_sexpr;
                               simpl;
                               reflexivity).
      * simpl in E_smap_value_to_sexpr.
        destruct (map_option (fun sv' : sstack_val => sstack_val_to_sexpr sv' flat_sb') args) as [sexpr_args|] eqn:E_sargs; try discriminate.
        injection E_smap_value_to_sexpr as E_smap_value_to_sexpr.
        rewrite <- E_smap_value_to_sexpr.
        unfold eval_sexpr.
        destruct (ops label) as [nrags f H_comm_ptoof H_exts_indp_proof] eqn:E_ops_label.
        destruct (length args =? nrags) eqn:E_len_args_nargs.
        ++ destruct (length sexpr_args =? nrags) eqn:E_len_sexpr_nargs.
           +++ fold eval_sexpr.
               assert (H_maps_option_aux: forall args sexpr_args, map_option (fun sv' : sstack_val => sstack_val_to_sexpr sv' flat_sb') args = Some sexpr_args -> map_option (fun sv' : sstack_val => eval_sstack_val sv' stk mem strg exts key sb' ops) args = map_option (fun fsv' : sexpr => eval_sexpr fsv' stk mem strg exts ops) sexpr_args).
               (* proof of assert start *)
               ++++ intro args0. induction args0 as [| a0 args0' IHargs0'].
                    +++++ intros sexpr_args0 H_map_option_sexpr_args. simpl in H_map_option_sexpr_args. injection H_map_option_sexpr_args as H_map_option_sexpr_args. rewrite <- H_map_option_sexpr_args. simpl.  reflexivity.
                    +++++ intros sexpr_args0 H_map_option_sexpr_args.
                    pose proof (map_option_len sstack_val sexpr (fun sv' : sstack_val => sstack_val_to_sexpr sv' flat_sb') (a0::args0') sexpr_args0 H_map_option_sexpr_args) as E_len_args_sexpr_args.
                          destruct sexpr_args0 as [|asexpr0 sexpr_args0'] eqn:E_sexpr_args0; try discriminate.
                          pose proof (map_option_hd sstack_val sexpr (fun sv' : sstack_val => sstack_val_to_sexpr sv' flat_sb') args0' sexpr_args0' a0 asexpr0 H_map_option_sexpr_args) as [H_map_option_sexpr_args_1 H_map_option_sexpr_args_2].
                          unfold map_option.
                          repeat rewrite <- map_option_ho.

                          assert (H_flat_sb'_refl: Some flat_sb' = Some flat_sb'). reflexivity.
                          pose proof (IHsb' key a0 stk mem strg exts ops flat_sb' asexpr0 H_flat_sb'_refl  H_map_option_sexpr_args_1 ) as H_map_option_aux_3.
                          rewrite <- H_map_option_aux_3. 
                          destruct (eval_sstack_val a0 stk mem strg exts key sb' ops); try reflexivity.

                          pose proof (IHargs0' sexpr_args0'  H_map_option_sexpr_args_2) as IHargs0'_1.
                          rewrite IHargs0'_1.
                          reflexivity.
               (* proof of assert end *)

               ++++ pose proof (H_maps_option_aux args sexpr_args E_sargs) as H_maps_option_aux_0.
                    rewrite H_maps_option_aux_0.
                    reflexivity.
           +++ pose proof (map_option_len sstack_val sexpr (fun sv' : sstack_val => sstack_val_to_sexpr sv' flat_sb') args sexpr_args E_sargs) as E_len_args_sexpr_args.
               rewrite <- E_len_args_sexpr_args in E_len_sexpr_nargs.
               rewrite E_len_sexpr_nargs in E_len_args_nargs.
               discriminate E_len_args_nargs.
        ++ destruct (length sexpr_args =? nrags) eqn:E_len_sexpr_args_nargs.
           +++ pose proof (map_option_len sstack_val sexpr (fun sv' : sstack_val => sstack_val_to_sexpr sv' flat_sb') args sexpr_args E_sargs) as E_len_args_sexpr_args.
               apply Nat.eqb_eq in E_len_sexpr_args_nargs as E_len_sexpr_args_nargs_eq.
               rewrite <- E_len_args_sexpr_args in E_len_sexpr_args_nargs_eq.
               rewrite <- E_len_sexpr_args_nargs_eq in E_len_args_nargs.
               rewrite <- E_len_args_sexpr_args in E_len_sexpr_args_nargs.
               rewrite <- E_len_sexpr_args_nargs_eq in E_len_sexpr_args_nargs.
               rewrite E_len_sexpr_args_nargs in E_len_args_nargs.
               discriminate E_len_args_nargs.
           +++ reflexivity.
      * simpl in E_smap_value_to_sexpr.
        destruct (map_option (eval_common.EvalCommon.instantiate_memory_update
                                (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb')) smem) as [sexpr_mem_updates|] eqn:E_map_option_mem_updates; try discriminate.
        destruct (sstack_val_to_sexpr offset flat_sb') as [sexpr_offset|] eqn:E_sstack_val_to_sexpr_offset; try discriminate.
        injection E_smap_value_to_sexpr as E_smap_value_to_sexpr.
        rewrite <- E_smap_value_to_sexpr.
        simpl.
        assert(H_map_option_0: forall smem sexpr_mem_updates,
                  map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb')) smem = Some sexpr_mem_updates ->
                  map_option
                    (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts key sb' ops)) smem = map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sexpr => eval_sexpr sv stk mem strg exts ops)) sexpr_mem_updates). 

        (* proof of assert starts here *)
        ++ intros smem0. induction smem0 as [|supdate0 smem0' IHsmem0'].
           +++ intros sexpr_mem_updates0 H_map_option_0_1. simpl in H_map_option_0_1. injection H_map_option_0_1 as H_map_option_0_1. rewrite <- H_map_option_0_1. simpl. reflexivity.
           +++ intros sexpr_mem_updates0 H_map_option_0_1.
               pose proof (map_option_len  (memory_update sstack_val) (memory_update sexpr) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb')) (supdate0 :: smem0') sexpr_mem_updates0 H_map_option_0_1) as H_map_option_0_1_len.
               destruct sexpr_mem_updates0 as [| sexpr_update0 sexpr_mem_updates0']; try discriminate.
               pose proof (map_option_hd (memory_update sstack_val) (memory_update sexpr) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb')) smem0' sexpr_mem_updates0' supdate0 sexpr_update0 H_map_option_0_1) as [H_map_option_0_1_1 H_map_option_0_1_2].

               unfold map_option.
               repeat rewrite <- map_option_ho.

               assert (H_flat_sb'_refl: Some flat_sb' = Some flat_sb'). reflexivity.
               destruct supdate0 eqn:E_supdate0; try (
                                                     simpl in H_map_option_0_1_1;
                                                     (destruct (sstack_val_to_sexpr offset0 flat_sb') eqn:E_sstack_val_to_sexpr_offset0; try discriminate);
                                                     (destruct (sstack_val_to_sexpr value flat_sb') eqn:E_sstack_val_to_sexpr_value; try discriminate);
                                                     injection   H_map_option_0_1_1 as H_map_option_0_1_1;
                                                     rewrite <- H_map_option_0_1_1;
                                                     simpl;
               
                                                     pose proof (IHsb' key offset0 stk mem strg exts ops flat_sb' s H_flat_sb'_refl E_sstack_val_to_sexpr_offset0) as H_map_option_aux_3;
                                                     rewrite H_map_option_aux_3;
                                                     pose proof (IHsb' key value stk mem strg exts ops flat_sb' s0 H_flat_sb'_refl E_sstack_val_to_sexpr_value) as H_map_option_aux_4;
                                                     rewrite H_map_option_aux_4;

                                                     pose proof (IHsmem0' sexpr_mem_updates0'  H_map_option_0_1_2) as H_map_option_aux_5;
                                                     rewrite H_map_option_aux_5;
                                                     reflexivity).

        (* proof of assert end here *)
        ++ pose proof (H_map_option_0 smem sexpr_mem_updates E_map_option_mem_updates) as H_map_option_1.
           rewrite H_map_option_1.

           assert (H_flat_sb'_refl: Some flat_sb' = Some flat_sb'). reflexivity.
           pose proof (IHsb' key offset stk mem strg exts ops flat_sb' sexpr_offset H_flat_sb'_refl E_sstack_val_to_sexpr_offset) as IHsb'_0.
           rewrite IHsb'_0.
           reflexivity.
      * simpl in E_smap_value_to_sexpr.
        destruct (map_option (eval_common.EvalCommon.instantiate_storage_update
                                (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb')) sstrg) as [sexpr_strg_updates|] eqn:E_map_option_strg_updates; try discriminate.
        destruct (sstack_val_to_sexpr key0 flat_sb') as [sexpr_key0|] eqn:E_sstack_val_to_sexpr_key0; try discriminate.
        injection E_smap_value_to_sexpr as E_smap_value_to_sexpr.
        rewrite <- E_smap_value_to_sexpr.
        simpl.

        assert(H_map_option_0: forall sstrg sexpr_strg_updates,
                  map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb')) sstrg = Some sexpr_strg_updates ->
                  map_option
                    (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts key sb' ops)) sstrg = map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv : sexpr => eval_sexpr sv stk mem strg exts ops)) sexpr_strg_updates).

        (* proof of assert stars here *)
        ++ intros sstrg0. induction sstrg0 as [|supdate0 sstrg0' IHsstrg0'].
           +++ intros sexpr_strg_updates0 H_map_option_0_1. simpl in H_map_option_0_1. injection H_map_option_0_1 as H_map_option_0_1. rewrite <- H_map_option_0_1. simpl. reflexivity.
           +++ intros sexpr_strg_updates0 H_map_option_0_1.

               pose proof (map_option_len  (storage_update sstack_val) (storage_update sexpr) (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb')) (supdate0 :: sstrg0') sexpr_strg_updates0 H_map_option_0_1) as H_map_option_0_1_len.
               destruct sexpr_strg_updates0 as [| sexpr_update0 sexpr_strg_updates0']; try discriminate.
               pose proof (map_option_hd (storage_update sstack_val) (storage_update sexpr) (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb')) sstrg0' sexpr_strg_updates0' supdate0 sexpr_update0 H_map_option_0_1) as [H_map_option_0_1_1 H_map_option_0_1_2].

               unfold map_option.
               repeat rewrite <- map_option_ho.

               destruct supdate0 eqn:E_supdate0.
               
               simpl in H_map_option_0_1_1.
               destruct (sstack_val_to_sexpr key1 flat_sb') eqn:E_sstack_val_to_sexpr_key1; try discriminate.
               destruct (sstack_val_to_sexpr value flat_sb') eqn:E_sstack_val_to_sexpr_value; try discriminate.
               injection H_map_option_0_1_1 as H_map_option_0_1_1.
               rewrite <- H_map_option_0_1_1.
               simpl.
               
               assert (H_flat_sb'_refl: Some flat_sb' = Some flat_sb'). reflexivity.
               pose proof (IHsb' key key1 stk mem strg exts ops flat_sb' s H_flat_sb'_refl E_sstack_val_to_sexpr_key1) as H_map_option_aux_3.
               rewrite H_map_option_aux_3.
               pose proof (IHsb' key value stk mem strg exts ops flat_sb' s0 H_flat_sb'_refl E_sstack_val_to_sexpr_value) as H_map_option_aux_4.
               rewrite H_map_option_aux_4.
               
               pose proof (IHsstrg0' sexpr_strg_updates0' H_map_option_0_1_2) as H_map_option_aux_5.
               rewrite H_map_option_aux_5.
               reflexivity.

        (* proof of assert ends here *)

        ++ pose proof (H_map_option_0 sstrg sexpr_strg_updates E_map_option_strg_updates) as H_map_option_0_1.
           rewrite H_map_option_0_1.
           assert (H_flat_sb'_refl: Some flat_sb' = Some flat_sb'). reflexivity.
           pose proof (IHsb' key key0 stk mem strg exts ops flat_sb' sexpr_key0 H_flat_sb'_refl E_sstack_val_to_sexpr_key0) as IHsb'_0.
           rewrite IHsb'_0.
           reflexivity.


        

      * simpl in E_smap_value_to_sexpr.
        destruct (map_option (eval_common.EvalCommon.instantiate_memory_update
                                (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb')) smem) as [sexpr_mem_updates|] eqn:E_map_option_mem_updates; try discriminate.
        destruct (sstack_val_to_sexpr offset flat_sb') as [sexpr_offset|] eqn:E_sstack_val_to_sexpr_offset; try discriminate.
        destruct (sstack_val_to_sexpr size flat_sb') as [sexpr_size|] eqn:E_sstack_val_to_sexpr_size; try discriminate.
        injection E_smap_value_to_sexpr as E_smap_value_to_sexpr.
        rewrite <- E_smap_value_to_sexpr.
        simpl.

        (* copy of assert of the case of mload, improve it later *)
        assert(H_map_option_0: forall smem sexpr_mem_updates,
                  map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb')) smem = Some sexpr_mem_updates ->
                  map_option
                    (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts key sb' ops)) smem = map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sexpr => eval_sexpr sv stk mem strg exts ops)) sexpr_mem_updates). 

        ++ intros smem0. induction smem0 as [|supdate0 smem0' IHsmem0'].
           +++ intros sexpr_mem_updates0 H_map_option_0_1. simpl in H_map_option_0_1. injection H_map_option_0_1 as H_map_option_0_1. rewrite <- H_map_option_0_1. simpl. reflexivity.
           +++ intros sexpr_mem_updates0 H_map_option_0_1.
               pose proof (map_option_len  (memory_update sstack_val) (memory_update sexpr) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb')) (supdate0 :: smem0') sexpr_mem_updates0 H_map_option_0_1) as H_map_option_0_1_len.
               destruct sexpr_mem_updates0 as [| sexpr_update0 sexpr_mem_updates0']; try discriminate.
               pose proof (map_option_hd (memory_update sstack_val) (memory_update sexpr) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb')) smem0' sexpr_mem_updates0' supdate0 sexpr_update0 H_map_option_0_1) as [H_map_option_0_1_1 H_map_option_0_1_2].

               unfold map_option.
               repeat rewrite <- map_option_ho.

               destruct supdate0 eqn:E_supdate0.
               ++++ simpl in H_map_option_0_1_1.
                    destruct (sstack_val_to_sexpr offset0 flat_sb') eqn:E_sstack_val_to_sexpr_offset0; try discriminate.
                    destruct (sstack_val_to_sexpr value flat_sb') eqn:E_sstack_val_to_sexpr_value; try discriminate.
                    injection   H_map_option_0_1_1 as H_map_option_0_1_1.
                    rewrite <- H_map_option_0_1_1.
                    simpl.
               
                    assert (H_flat_sb'_refl: Some flat_sb' = Some flat_sb'). reflexivity.
                    pose proof (IHsb' key offset0 stk mem strg exts ops flat_sb' s H_flat_sb'_refl E_sstack_val_to_sexpr_offset0) as H_map_option_aux_3.
                    rewrite H_map_option_aux_3.
                    pose proof (IHsb' key value stk mem strg exts ops flat_sb' s0 H_flat_sb'_refl E_sstack_val_to_sexpr_value) as H_map_option_aux_4.
                    rewrite H_map_option_aux_4.

                    pose proof (IHsmem0' sexpr_mem_updates0'  H_map_option_0_1_2) as H_map_option_aux_5.
                    rewrite H_map_option_aux_5.
                    reflexivity.
                    (* this is a copy of previous one, improve later *)
               ++++ simpl in H_map_option_0_1_1.
                    destruct (sstack_val_to_sexpr offset0 flat_sb') eqn:E_sstack_val_to_sexpr_offset0; try discriminate.
                    destruct (sstack_val_to_sexpr value flat_sb') eqn:E_sstack_val_to_sexpr_value; try discriminate.
                    injection   H_map_option_0_1_1 as H_map_option_0_1_1.
                    rewrite <- H_map_option_0_1_1.
                    simpl.
               
                    assert (H_flat_sb'_refl: Some flat_sb' = Some flat_sb'). reflexivity.
                    pose proof (IHsb' key offset0 stk mem strg exts ops flat_sb' s H_flat_sb'_refl E_sstack_val_to_sexpr_offset0) as H_map_option_aux_3.
                    rewrite H_map_option_aux_3.
                    pose proof (IHsb' key value stk mem strg exts ops flat_sb' s0 H_flat_sb'_refl E_sstack_val_to_sexpr_value) as H_map_option_aux_4.
                    rewrite H_map_option_aux_4.

                    pose proof (IHsmem0' sexpr_mem_updates0'  H_map_option_0_1_2) as H_map_option_aux_5.
                    rewrite H_map_option_aux_5.
                    reflexivity.
                   

        (* proof of assert end here *)
        ++ pose proof (H_map_option_0 smem sexpr_mem_updates E_map_option_mem_updates) as H_map_option_1.
           rewrite H_map_option_1.

           assert (H_flat_sb'_refl: Some flat_sb' = Some flat_sb'). reflexivity.
           pose proof (IHsb' key offset stk mem strg exts ops flat_sb' sexpr_offset H_flat_sb'_refl E_sstack_val_to_sexpr_offset) as IHsb'_0.
           rewrite IHsb'_0.
           pose proof (IHsb' key size stk mem strg exts ops flat_sb' sexpr_size H_flat_sb'_refl E_sstack_val_to_sexpr_size) as IHsb'_1.
           rewrite IHsb'_1.
           reflexivity.
        
    + simpl in H_sstack_val_to_sexpr.
      rewrite E_key_eqb_var in H_sstack_val_to_sexpr.
      apply IHsb' with (sv:=(FreshVar var))(flat_sb:=flat_sb').
      * reflexivity.
      * apply H_sstack_val_to_sexpr.

Qed.

Lemma eval_sexp_map:
  forall l maxidx flat_l sb flat_sb stk mem strg exts ops,
    bindings_to_flat_bindings sb = Some flat_sb ->
    map_option (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb) l = Some flat_l ->
    map_option (fun sv : sexpr => eval_sexpr sv stk mem strg exts ops) flat_l =
      map_option (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maxidx sb ops) l.
Proof.
  induction l as [|a l' IHl'].
  - intros maxidx flat_l sb flat_sb stk mem strg exts ops H_flat_sb H_map_option_0.
    simpl in H_map_option_0.
    injection H_map_option_0 as H_map_option_0.
    rewrite <- H_map_option_0.
    simpl.
    reflexivity.
  - intros maxidx flat_l sb flat_sb stk mem strg exts ops H_flat_sb H_map_option_0.
    pose proof (map_option_len sstack_val sexpr (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb) (a :: l') flat_l H_map_option_0) as H_map_option_1.
    destruct flat_l as [|flat_a flat_l']; try discriminate.
    pose proof (map_option_hd sstack_val sexpr (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb)  l' flat_l' a flat_a H_map_option_0) as [H_map_option_1_1 H_map_option_1_2].
    pose proof (eval_sexpr_snd sb maxidx a stk mem strg exts ops flat_sb flat_a H_flat_sb H_map_option_1_1) as H_eval_sexpr_snd.
    simpl.
    rewrite H_eval_sexpr_snd.
    pose proof (IHl' maxidx flat_l' sb flat_sb stk mem strg exts ops H_flat_sb H_map_option_1_2) as IHl'_0.
    rewrite IHl'_0.
    reflexivity.
Qed.

Lemma sst_to_fsst_instk_height:
  forall sst fsst,
    sstate_to_flat_sstate sst = Some fsst ->
    (get_instk_height_sst sst) = (get_instk_height_fsst fsst).
Proof.
  intros sst fsst H_sst_to_fsst.
  unfold sstate_to_flat_sstate in H_sst_to_fsst.
  destruct (get_smap_sst sst); try discriminate.
  destruct (bindings_to_flat_bindings bindings) as [flat_sb|]; try discriminate.
  destruct (sstack_to_flat_sstack sst flat_sb); try discriminate.
  destruct (smemory_to_flat_smemory sst flat_sb); try discriminate.
  destruct (sstorage_to_flat_sstorage sst flat_sb); try discriminate.
  injection H_sst_to_fsst as H_sst_to_fsst.
  rewrite <- H_sst_to_fsst.
  simpl.
  reflexivity.
Qed.



Lemma eval_flat_sstack_snd:
  forall sst fsst stk mem strg exts ops,
    sstate_to_flat_sstate sst = Some fsst ->
    eval_flat_sstack (get_stack_fsst fsst) stk mem strg exts ops = eval_sstack (get_stack_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) stk mem strg exts ops.
Proof.
  intros sst fsst stk mem strg exts ops H_sst_to_fsst.
  unfold eval_flat_sstack.
  unfold eval_sstack.
  unfold sstate_to_flat_sstate in H_sst_to_fsst.
  destruct (get_smap_sst sst) as [maxidx sb] eqn:E_get_smap.
  destruct (bindings_to_flat_bindings sb) as [flat_sb|] eqn:E_bindings; try discriminate.
  destruct (sstack_to_flat_sstack sst flat_sb) as [flat_sstk|] eqn:E_flat_sstk; try discriminate.
  destruct (smemory_to_flat_smemory sst flat_sb) as [flat_smem|] eqn:E_flat_smem; try discriminate.
  destruct (sstorage_to_flat_sstorage sst flat_sb) as [flat_sstrg|] eqn:E_flat_sstrg; try discriminate.
  injection H_sst_to_fsst as H_sst_to_fsst.
  unfold sstack_to_flat_sstack in E_flat_sstk.
  simpl in H_sst_to_fsst.
  rewrite <- H_sst_to_fsst.
  simpl.
  pose proof (eval_sexp_map (get_stack_sst sst) maxidx flat_sstk sb flat_sb stk mem strg exts ops E_bindings E_flat_sstk) as H_eval_sexp_map.
  apply H_eval_sexp_map.
Qed.

Lemma eval_flat_smemory_map:
  forall sb maxidx flat_sb stk mem strg exts ops smem flat_smem,
    bindings_to_flat_bindings sb = Some flat_sb ->
    map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb)) smem = Some flat_smem ->

  map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sexpr => eval_sexpr sv stk mem strg exts ops)) flat_smem =
    map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maxidx sb ops)) smem.
Proof.
  intros sb maxidx flat_sb stk mem strg exts ops.
  induction smem as [|u smem' IHsmem'].
  - intros flat_smem H_sbindings H_map_option. simpl in H_map_option. injection H_map_option as H_map_option. rewrite <- H_map_option. simpl. reflexivity.
  - intros flat_smem H_sbindings H_map_option.
    pose proof (map_option_len  (memory_update sstack_val) (memory_update sexpr) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb)) (u :: smem') flat_smem H_map_option) as H_map_option_len.
    destruct flat_smem as [| flat_u flat_smem']; try discriminate.

    pose proof (map_option_hd (memory_update sstack_val) (memory_update sexpr) (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb)) smem' flat_smem' u flat_u H_map_option) as [H_map_option_1 H_map_option_2].

    unfold map_option.
    repeat rewrite <- map_option_ho.

    destruct u; try (
                    simpl in H_map_option_1;
                    (destruct (sstack_val_to_sexpr offset flat_sb) as [flat_offset|] eqn:E_sstack_val_to_sexpr_offset; try discriminate);
                    (destruct (sstack_val_to_sexpr value flat_sb) as [flat_value|] eqn:E_sstack_val_to_sexpr_value; try discriminate);
                    injection H_map_option_1 as H_map_option_1;
                    rewrite <- H_map_option_1;
                    simpl;

                    pose proof (eval_sexpr_snd sb maxidx offset stk mem strg exts ops flat_sb flat_offset H_sbindings E_sstack_val_to_sexpr_offset) as H_eval_sexpr_snd_offset;
                    rewrite H_eval_sexpr_snd_offset;

                    pose proof (eval_sexpr_snd sb maxidx value stk mem strg exts ops flat_sb flat_value H_sbindings E_sstack_val_to_sexpr_value) as H_eval_sexpr_snd_value;
                    rewrite H_eval_sexpr_snd_value;

                    pose proof (IHsmem' flat_smem' H_sbindings  H_map_option_2) as IHsmem'_1;
                    rewrite IHsmem'_1;
                    reflexivity).
Qed.

Lemma eval_flat_smemory_snd:
  forall sst fsst stk mem strg exts ops,
    sstate_to_flat_sstate sst = Some fsst ->
    eval_flat_smemory (get_memory_fsst fsst) stk mem strg exts ops = eval_smemory (get_memory_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) stk mem strg exts ops.
Proof.
  intros sst fsst stk mem strg exts ops H_sst_to_fsst.
  unfold eval_flat_smemory.
  unfold eval_smemory.
  unfold sstate_to_flat_sstate in H_sst_to_fsst.
  destruct (get_smap_sst sst) as [maxidx sb] eqn:E_get_smap.
  unfold sstate_to_flat_sstate in H_sst_to_fsst.
  destruct (bindings_to_flat_bindings sb) as [flat_sb|] eqn:E_bindings; try discriminate.
  destruct (sstack_to_flat_sstack sst flat_sb) as [flat_sstk|] eqn:E_flat_sstk; try discriminate.
  destruct (smemory_to_flat_smemory sst flat_sb) as [flat_smem|] eqn:E_flat_smem; try discriminate.
  destruct (sstorage_to_flat_sstorage sst flat_sb) as [flat_sstrg|] eqn:E_flat_sstrg; try discriminate.
  injection H_sst_to_fsst as H_sst_to_fsst.
  rewrite <- H_sst_to_fsst.
  simpl.
  unfold smemory_to_flat_smemory in E_flat_smem.
  pose proof (eval_flat_smemory_map sb maxidx flat_sb stk mem strg exts ops (get_memory_sst sst) flat_smem E_bindings E_flat_smem) as H_eval_flat_smemory_map.
  rewrite H_eval_flat_smemory_map.
  reflexivity.
Qed.

Lemma eval_flat_sstorage_map:
  forall sb maxidx flat_sb stk mem strg exts ops sstrg flat_sstrg,
    bindings_to_flat_bindings sb = Some flat_sb ->
    map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb)) sstrg = Some flat_sstrg ->

  map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv : sexpr => eval_sexpr sv stk mem strg exts ops)) flat_sstrg =
    map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg exts maxidx sb ops)) sstrg.
Proof. (* it is the same as eval_flat_smemory_map *)
  intros sb maxidx flat_sb stk mem strg exts ops.
  induction sstrg as [|u sstrg' IHsstrg'].
  - intros flat_sstrg H_sbindings H_map_option. simpl in H_map_option. injection H_map_option as H_map_option. rewrite <- H_map_option. simpl. reflexivity.
  - intros flat_sstrg H_sbindings H_map_option.
    pose proof (map_option_len  (storage_update sstack_val) (storage_update sexpr) (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb)) (u :: sstrg') flat_sstrg H_map_option) as H_map_option_len.
    destruct flat_sstrg as [| flat_u flat_sstrg']; try discriminate.

    pose proof (map_option_hd (storage_update sstack_val) (storage_update sexpr) (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => sstack_val_to_sexpr sv flat_sb)) sstrg' flat_sstrg' u flat_u H_map_option) as [H_map_option_1 H_map_option_2].

    unfold map_option.
    repeat rewrite <- map_option_ho.

    destruct u.
    simpl in H_map_option_1.
    (destruct (sstack_val_to_sexpr key flat_sb) as [flat_key|] eqn:E_sstack_val_to_sexpr_key; try discriminate).
    (destruct (sstack_val_to_sexpr value flat_sb) as [flat_value|] eqn:E_sstack_val_to_sexpr_value; try discriminate).
    injection H_map_option_1 as H_map_option_1.
    rewrite <- H_map_option_1.
    simpl.
    
    pose proof (eval_sexpr_snd sb maxidx key stk mem strg exts ops flat_sb flat_key H_sbindings E_sstack_val_to_sexpr_key) as H_eval_sexpr_snd_key.
    rewrite H_eval_sexpr_snd_key.
    
    pose proof (eval_sexpr_snd sb maxidx value stk mem strg exts ops flat_sb flat_value H_sbindings E_sstack_val_to_sexpr_value) as H_eval_sexpr_snd_value.
    rewrite H_eval_sexpr_snd_value.
    
    pose proof (IHsstrg' flat_sstrg' H_sbindings  H_map_option_2) as IHsstrg'_1.
    rewrite IHsstrg'_1.
    reflexivity.
Qed.

Lemma eval_flat_sstorage_snd:
  forall sst fsst stk mem strg exts ops,
    sstate_to_flat_sstate sst = Some fsst ->
    eval_flat_sstorage (get_storage_fsst fsst) stk mem strg exts ops = eval_sstorage (get_storage_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) stk mem strg exts ops.
Proof.
  intros sst fsst stk mem strg exts ops H_sst_to_fsst.
  unfold eval_flat_sstorage.
  unfold eval_sstorage.
  unfold sstate_to_flat_sstate in H_sst_to_fsst.
  destruct (get_smap_sst sst) as [maxidx sb] eqn:E_get_smap.
  unfold sstate_to_flat_sstate in H_sst_to_fsst.
  destruct (bindings_to_flat_bindings sb) as [flat_sb|] eqn:E_bindings; try discriminate.
  destruct (sstack_to_flat_sstack sst flat_sb) as [flat_sstk|] eqn:E_flat_sstk; try discriminate.
  destruct (smemory_to_flat_smemory sst flat_sb) as [flat_smem|] eqn:E_flat_smem; try discriminate.
  destruct (sstorage_to_flat_sstorage sst flat_sb) as [flat_sstrg|] eqn:E_flat_sstrg; try discriminate.
  injection H_sst_to_fsst as H_sst_to_fsst.
  rewrite <- H_sst_to_fsst.
  simpl.
  unfold sstorage_to_flat_sstorage in E_flat_smem.
  pose proof (eval_flat_sstorage_map sb maxidx flat_sb stk mem strg exts ops (get_storage_sst sst) flat_sstrg E_bindings E_flat_sstrg) as H_eval_flat_sstorage_map.
  rewrite H_eval_flat_sstorage_map.
  reflexivity.
Qed.

Lemma eval_flat_sstate_snd:
  forall sst fsst st ops,
    sstate_to_flat_sstate sst = Some fsst ->
    eval_flat_sstate st fsst ops = eval_sstate st sst ops.
Proof.
  intros sst fsst st ops H_sst_to_fsst.

  pose proof (sst_to_fsst_instk_height sst fsst H_sst_to_fsst) as H_instk_height.
  unfold eval_flat_sstate.
  unfold eval_sstate.

  rewrite H_instk_height.
  
  pose proof (eval_flat_sstack_snd sst fsst (get_stack_st st) (get_memory_st st) (get_storage_st st) (get_externals_st st) ops H_sst_to_fsst) as H_eval_flat_sstack_snd.
  rewrite H_eval_flat_sstack_snd.

  pose proof (eval_flat_smemory_snd sst fsst (get_stack_st st) (get_memory_st st) (get_storage_st st) (get_externals_st st) ops H_sst_to_fsst) as H_eval_flat_smemory_snd.
  rewrite H_eval_flat_smemory_snd.

  pose proof (eval_flat_sstorage_snd sst fsst (get_stack_st st) (get_memory_st st) (get_storage_st st) (get_externals_st st) ops H_sst_to_fsst) as H_eval_flat_sstorage_snd.
  rewrite H_eval_flat_sstorage_snd.

  reflexivity.
Qed.

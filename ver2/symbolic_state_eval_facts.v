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

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.symbolic_state_eval.
Import SymbolicStateEval.

Require Import FORVES.eval_common.
Import EvalCommon.

Module SymbolicStateEvalFacts.

Lemma n_Sm_neq_lt:
  forall n m,
    n < S m -> n <> m -> n < m.
Proof.
  intros.
  apply lt_n_Sm_le in H.
  apply le_lt_or_eq in H.
  destruct H.
  + apply H.
  + contradiction.
Qed.

Lemma valid_sstack_value_FreshVar:
  forall instk_height key idx,
    idx<key -> valid_sstack_value instk_height key (FreshVar idx).
Proof.
  intros.
  simpl.
  apply H.
Qed.


Lemma eval_sstack_val'_succ:
  forall d instk_height sv stk mem strg ctx maxidx sb ops,
    instk_height = length stk ->
    valid_sstack_value instk_height maxidx sv ->
    valid_bindings instk_height maxidx sb ops ->
    d > maxidx ->
    exists v,
      eval_sstack_val' d sv stk mem strg ctx maxidx sb ops = Some v.
Proof.
  induction d as [|d' IHd'].
  - intros instk_height sv stk mem strg ctx maxidx sb ops H_instk_height H_valid_sv H_valid_sb H_d_S_maxid.
    apply Nat.nlt_0_r in H_d_S_maxid.
    contradiction.
    
    
  - intros instk_height sv stk mem strg ctx maxidx sb ops H_instk_height H_valid_sv H_valid_sb H_d_S_maxid.

    unfold eval_sstack_val'. fold eval_sstack_val'.
    
    pose proof (follow_in_smap_suc sb sv instk_height maxidx ops H_valid_sv H_valid_sb) as H_follow.
    destruct H_follow as [smv [maxidx' [sb' H_follow]]].
    destruct H_follow as [H_follow_1 H_follow_2].
    pose proof (valid_follow_in_smap sb sv instk_height maxidx ops smv maxidx' sb' H_valid_sv H_valid_sb H_follow_1) as H_follow_valid.

    destruct H_follow_valid as [H_follow_valid_0 [H_follow_valid_1 H_follow_valid_2]].
    rewrite H_follow_1.

    destruct smv as [sv' | v | label args | soffset smem | skey sstrg | soffset ssize smem ] eqn:E_smv.

    (* SymBasicVal *)
    ** destruct sv' as [val | var | idx' ] eqn:E_sv'.
       *** exists val. reflexivity.
       *** simpl in H_follow_valid_0.
           rewrite H_instk_height in H_follow_valid_0.
           apply nth_error_nth' with (d:=WZero) in H_follow_valid_0.
           rewrite H_follow_valid_0.
           exists (nth var stk WZero).
           reflexivity.
       *** discriminate H_follow_2.

    (* SymPUSHTAG  *)
    ** exists (get_tags_ctx ctx v). reflexivity.
       
    (* OpImp nargs f *)
    ** destruct (ops label) eqn:E_f.
       unfold valid_bindings in H_valid_sb. fold valid_bindings in H_valid_sb.
       simpl in H_follow_valid_0.
       unfold valid_stack_op_instr in H_follow_valid_0.
       rewrite E_f in H_follow_valid_0.
       destruct H_follow_valid_0 as [H_follow_valid_0_0 H_follow_valid_0_1].
       apply Nat.eqb_eq in H_follow_valid_0_0 as H_follow_valid_0_0_eqb.
       rewrite H_follow_valid_0_0_eqb.
       fold eval_sstack_val'.

       assert(H_eval_args: forall args0,
                 valid_sstack instk_height maxidx' args0 ->
                 exists v, map_option (fun sv' : sstack_val => eval_sstack_val' d' sv' stk mem strg ctx maxidx' sb' ops) args0 = Some v).
           (* proof of assert *)
           *** induction args0 as [|a args0' IHargs'].
               **** intros. exists []. reflexivity.
               **** intro H_valid_args0.
                    unfold valid_sstack in H_valid_args0. fold valid_sstack in H_valid_args0.
                    destruct H_valid_args0 as [H_valid_a H_valid_args0].
                    unfold map_option.
                    rewrite <- map_option_ho.
                    assert (H_d'_gt_maxidx': d' > maxidx'). intuition.
                    pose proof (IHd' instk_height a stk mem strg ctx maxidx' sb' ops H_instk_height H_valid_a H_follow_valid_1 H_d'_gt_maxidx') as IHd'_0.
                    destruct IHd'_0 as [v IHd'_0].
                    rewrite IHd'_0.
                    pose proof  IHargs'  H_valid_args0 as IHargs'_0.
                    destruct IHargs'_0 as [vargs0' IHargs'_0].
                    rewrite IHargs'_0.
                    exists (v :: vargs0').
                    reflexivity.
           (* end proof of assert *)

           *** pose proof (H_eval_args args H_follow_valid_0_1) as H_eval_args.
               destruct H_eval_args as [v H_eval_args].
               rewrite H_eval_args.
               exists (f ctx v).
               reflexivity.

        (* SymMLOAD *)
    ** unfold valid_smap_value in H_follow_valid_0.
       destruct H_follow_valid_0 as [H_valid_sb_1_0 H_valid_sb_1_1].

       assert(H_map_o_smem:
               forall smem0,
                 valid_smemory instk_height maxidx' smem0 ->
                 exists v,
                   map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv0 : sstack_val => eval_sstack_val' d' sv0 stk mem strg ctx maxidx' sb' ops)) smem0 = Some v).

           (* proof of assert *)
           *** induction smem0 as [|u smem0' IHsmem0'].
               **** intros. simpl. exists []. reflexivity.
               **** intro H_valid_smemory.
                    unfold map_option.
                    rewrite <- map_option_ho.
                    unfold eval_common.EvalCommon.instantiate_memory_update at 1.
                    destruct u as [soffset' svalue'|soffset' svalue'].

                    ***** unfold valid_smemory in H_valid_smemory. fold valid_smemory in H_valid_smemory.
                          destruct H_valid_smemory as [H_valid_smemory_0 H_valid_smemory_1].
                          unfold valid_smemory_update in H_valid_smemory_0.
                          destruct H_valid_smemory_0 as [H_valid_smemory_0_0 H_valid_smemory_0_1].
                          
                          assert (H_d'_gt_maxidx': d' > maxidx'). intuition.
                          pose proof (IHd' instk_height soffset' stk mem strg ctx maxidx' sb' ops H_instk_height H_valid_smemory_0_0 H_follow_valid_1 H_d'_gt_maxidx') as IHd'_0.
                          destruct IHd'_0 as [voffset IHd'_0].
                          rewrite IHd'_0.
                          pose proof (IHd' instk_height svalue' stk mem strg ctx maxidx' sb' ops H_instk_height H_valid_smemory_0_1 H_follow_valid_1 H_d'_gt_maxidx') as IHd'_1.
                          destruct IHd'_1 as [vvalue IHd'_1].
                          rewrite  IHd'_1.

                          pose proof (IHsmem0' H_valid_smemory_1) as IHsmem0'_0.
                          destruct IHsmem0'_0 as [vsmem0' IHsmem0'_0].
                          rewrite IHsmem0'_0.
                          exists (U_MSTORE EVMWord voffset vvalue :: vsmem0').
                          reflexivity.
                    ***** unfold valid_smemory in H_valid_smemory. fold valid_smemory in H_valid_smemory.
                          destruct H_valid_smemory as [H_valid_smemory_0 H_valid_smemory_1].
                          unfold valid_smemory_update in H_valid_smemory_0.
                          destruct H_valid_smemory_0 as [H_valid_smemory_0_0 H_valid_smemory_0_1].
                          
                          assert (H_d'_gt_maxidx': d' > maxidx'). intuition.
                          pose proof (IHd' instk_height soffset' stk mem strg ctx maxidx' sb' ops H_instk_height H_valid_smemory_0_0 H_follow_valid_1 H_d'_gt_maxidx') as IHd'_0.
                          destruct IHd'_0 as [voffset IHd'_0].
                          rewrite IHd'_0.
                          pose proof (IHd' instk_height svalue' stk mem strg ctx maxidx' sb' ops H_instk_height H_valid_smemory_0_1 H_follow_valid_1 H_d'_gt_maxidx') as IHd'_1.
                          destruct IHd'_1 as [vvalue IHd'_1].
                          rewrite  IHd'_1.

                          pose proof (IHsmem0' H_valid_smemory_1) as IHsmem0'_0.
                          destruct IHsmem0'_0 as [vsmem0' IHsmem0'_0].
                          rewrite IHsmem0'_0.
                          exists (U_MSTORE8 EVMWord voffset vvalue :: vsmem0').
                          reflexivity.

           (* end proof of assert *)
           *** pose proof (H_map_o_smem smem H_valid_sb_1_1) as H_map_o_smem_0.
               destruct H_map_o_smem_0 as [v H_map_o_smem_0].
               rewrite H_map_o_smem_0.

               assert (H_d'_gt_maxidx': d' > maxidx'). intuition.
               pose proof (IHd' instk_height soffset stk mem strg ctx maxidx' sb' ops H_instk_height H_valid_sb_1_0 H_follow_valid_1 H_d'_gt_maxidx') as IHd'_0.
               destruct IHd'_0 as [voffset IHd'_0].
               rewrite IHd'_0.

               exists (concrete_interpreter.ConcreteInterpreter.mload (eval_common.EvalCommon.update_memory mem v) voffset).
               reflexivity.

        (* SymSLOAD *)
        ** unfold valid_smap_value in H_follow_valid_0.
           destruct H_follow_valid_0 as [H_valid_sb_1_0 H_valid_sb_1_1].

           assert(H_map_o_sstrg:
                   forall sstrg0,
                     valid_sstorage instk_height maxidx' sstrg0 ->
                     exists v,
                       map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv0 : sstack_val => eval_sstack_val' d' sv0 stk mem strg ctx maxidx' sb' ops)) sstrg0 = Some v).
           
           (* proof of assert *)
           *** induction sstrg0 as [|u sstrg0' IHsstrg0'].
               **** intros. simpl. exists []. reflexivity.
               **** intro H_valid_sstorage.
                    unfold map_option.
                    rewrite <- map_option_ho.
                    unfold eval_common.EvalCommon.instantiate_storage_update at 1.
                    destruct u as [skey' svalue'].

                    unfold valid_sstorage in H_valid_sstorage. fold valid_sstorage in H_valid_sstorage.
                    destruct H_valid_sstorage as [H_valid_sstorage_0 H_valid_sstorage_1].
                    unfold valid_sstorage_update in H_valid_sstorage_0.
                    destruct H_valid_sstorage_0 as [H_valid_sstorage_0_0 H_valid_sstorage_0_1].

                    assert (H_d'_gt_maxidx': d' > maxidx'). intuition.
                    pose proof (IHd' instk_height skey' stk mem strg ctx maxidx' sb' ops H_instk_height H_valid_sstorage_0_0 H_follow_valid_1 H_d'_gt_maxidx') as IHd'_0.
                    destruct IHd'_0 as [voffset IHd'_0].
                    rewrite  IHd'_0.
                    
                    pose proof (IHd' instk_height svalue' stk mem strg ctx maxidx' sb' ops H_instk_height H_valid_sstorage_0_1 H_follow_valid_1 H_d'_gt_maxidx') as IHd'_1.
                    destruct IHd'_1 as [vvalue IHd'_1].
                    rewrite  IHd'_1.
                    
                    pose proof (IHsstrg0' H_valid_sstorage_1) as IHsstrg0'_0.
                    destruct IHsstrg0'_0 as [vsstrg0' IHsstrg0'_0].
                    rewrite IHsstrg0'_0.
                    exists (U_SSTORE EVMWord voffset vvalue :: vsstrg0').
                    reflexivity.
           (* end proof of assert *)
                    
           *** pose proof (H_map_o_sstrg sstrg H_valid_sb_1_1) as H_map_o_sstrg_0.
               destruct H_map_o_sstrg_0 as [v H_map_o_sstrg_0].
               rewrite H_map_o_sstrg_0.

               assert (H_d'_gt_maxidx': d' > maxidx'). intuition.
               pose proof (IHd' instk_height skey stk mem strg ctx maxidx' sb' ops H_instk_height H_valid_sb_1_0 H_follow_valid_1 H_d'_gt_maxidx') as IHd'_0.
               destruct IHd'_0 as [vkey IHd'_0].
               rewrite IHd'_0.

               exists (concrete_interpreter.ConcreteInterpreter.sload (eval_common.EvalCommon.update_storage strg v) vkey).
               reflexivity.

        (* SymSHA3 *)
        ** unfold valid_smap_value in H_follow_valid_0.
           destruct H_follow_valid_0 as [H_valid_sb_1_0 [H_valid_sb_1_1 H_valid_sb_1_2]].
           
           assert(H_map_o_smem:
               forall smem0,
                 valid_smemory instk_height maxidx' smem0 ->
                 exists v,
                   map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv0 : sstack_val => eval_sstack_val' d' sv0 stk mem strg ctx maxidx' sb' ops)) smem0 = Some v).

           (* proof of assert *)
           *** induction smem0 as [|u smem0' IHsmem0'].
               **** intros. simpl. exists []. reflexivity.
               **** intro H_valid_smemory.
                    unfold map_option.
                    rewrite <- map_option_ho.
                    unfold eval_common.EvalCommon.instantiate_memory_update at 1.
                    destruct u as [soffset' svalue'|soffset' svalue'].

                    ***** unfold valid_smemory in H_valid_smemory. fold valid_smemory in H_valid_smemory.
                          destruct H_valid_smemory as [H_valid_smemory_0 H_valid_smemory_1].
                          unfold valid_smemory_update in H_valid_smemory_0.
                          destruct H_valid_smemory_0 as [H_valid_smemory_0_0 H_valid_smemory_0_1].
                          
                          assert (H_d'_gt_maxidx': d' > maxidx'). intuition.
                          pose proof (IHd' instk_height soffset' stk mem strg ctx maxidx' sb' ops H_instk_height H_valid_smemory_0_0 H_follow_valid_1 H_d'_gt_maxidx') as IHd'_0.
                          destruct IHd'_0 as [voffset IHd'_0].
                          rewrite IHd'_0.
                          pose proof (IHd' instk_height svalue' stk mem strg ctx maxidx' sb' ops H_instk_height H_valid_smemory_0_1 H_follow_valid_1 H_d'_gt_maxidx') as IHd'_1.
                          destruct IHd'_1 as [vvalue IHd'_1].
                          rewrite  IHd'_1.

                          pose proof (IHsmem0' H_valid_smemory_1) as IHsmem0'_0.
                          destruct IHsmem0'_0 as [vsmem0' IHsmem0'_0].
                          rewrite IHsmem0'_0.
                          exists (U_MSTORE EVMWord voffset vvalue :: vsmem0').
                          reflexivity.
                    ***** unfold valid_smemory in H_valid_smemory. fold valid_smemory in H_valid_smemory.
                          destruct H_valid_smemory as [H_valid_smemory_0 H_valid_smemory_1].
                          unfold valid_smemory_update in H_valid_smemory_0.
                          destruct H_valid_smemory_0 as [H_valid_smemory_0_0 H_valid_smemory_0_1].
                          
                          assert (H_d'_gt_maxidx': d' > maxidx'). intuition.
                          pose proof (IHd' instk_height soffset' stk mem strg ctx maxidx' sb' ops H_instk_height H_valid_smemory_0_0 H_follow_valid_1 H_d'_gt_maxidx') as IHd'_0.
                          destruct IHd'_0 as [voffset IHd'_0].
                          rewrite IHd'_0.
                          pose proof (IHd' instk_height svalue' stk mem strg ctx maxidx' sb' ops H_instk_height H_valid_smemory_0_1 H_follow_valid_1 H_d'_gt_maxidx') as IHd'_1.
                          destruct IHd'_1 as [vvalue IHd'_1].
                          rewrite  IHd'_1.

                          pose proof (IHsmem0' H_valid_smemory_1) as IHsmem0'_0.
                          destruct IHsmem0'_0 as [vsmem0' IHsmem0'_0].
                          rewrite IHsmem0'_0.
                          exists (U_MSTORE8 EVMWord voffset vvalue :: vsmem0').
                          reflexivity.

           (* end proof of assert *)
           *** pose proof (H_map_o_smem smem H_valid_sb_1_2) as H_map_o_smem_0.
               destruct H_map_o_smem_0 as [v H_map_o_smem_0].
               rewrite H_map_o_smem_0.

               assert (H_d'_gt_maxidx': d' > maxidx'). intuition.
               pose proof (IHd' instk_height soffset stk mem strg ctx maxidx' sb' ops H_instk_height H_valid_sb_1_0 H_follow_valid_1 H_d'_gt_maxidx') as IHd'_0.
               destruct IHd'_0 as [voffset IHd'_0].
               rewrite IHd'_0.

               pose proof (IHd' instk_height ssize stk mem strg ctx maxidx' sb' ops H_instk_height H_valid_sb_1_1 H_follow_valid_1 H_d'_gt_maxidx') as IHd'_1.
               destruct IHd'_1 as [vsize IHd'_1].
               rewrite IHd'_1.

               exists (get_keccak256_ctx ctx (wordToNat vsize) (concrete_interpreter.ConcreteInterpreter.mload' (eval_common.EvalCommon.update_memory mem v) voffset(wordToNat vsize))).
               reflexivity.
Qed.

  
Lemma eval_sstack_val_succ:
  forall sb instk_height sv stk mem strg ctx maxidx ops,
    instk_height = length stk ->
    valid_sstack_value instk_height maxidx sv ->
    valid_bindings instk_height maxidx sb ops ->
    exists v,
      eval_sstack_val sv stk mem strg ctx maxidx sb ops = Some v.
Proof.
  intros sb instk_height sv stk mem strg ctx maxidx ops H_instk_height H_valid_sv H_valid_sb.
  unfold eval_sstack_val.
  assert (H_S_maxidx_gt_maxidx: S maxidx > maxidx ). auto.
  pose proof (eval_sstack_val'_succ (S maxidx) instk_height sv stk mem strg ctx maxidx sb ops H_instk_height H_valid_sv H_valid_sb H_S_maxidx_gt_maxidx) as H_eval_sstack_val'_succ.
  destruct H_eval_sstack_val'_succ as [v H_eval_sstack_val'_succ].
  exists v.
  apply H_eval_sstack_val'_succ.
Qed.

  
Lemma eval_map_o_sstk_succ:
  forall instk_height maxidx sb stk mem strg ctx ops sstk,
    instk_height = length stk ->
    valid_sstack instk_height maxidx sstk ->
    valid_bindings instk_height maxidx sb ops ->
    exists l,
      map_option (fun sv => eval_sstack_val sv stk mem strg ctx maxidx sb ops) sstk = Some l.
Proof.
  intros instk_height maxidx sb stk mem strg ctx ops.
  induction sstk as [|sv sstk' IHsstk'].
  - intros. simpl. exists []. reflexivity.
  - intros H_instk_height H_valid_sstk H_valid_sb.
    simpl in H_valid_sstk.
    destruct H_valid_sstk as [H_valid_sstk_0 H_valid_sstk_1].
    unfold map_option.
    rewrite <- map_option_ho.

    (* apply inudction hypothesis *)
    pose proof (IHsstk' H_instk_height H_valid_sstk_1 H_valid_sb) as IHsstk'_0.
    destruct IHsstk'_0 as [l IHsstk'_0].
    rewrite IHsstk'_0.

    pose proof (eval_sstack_val_succ sb instk_height sv stk mem strg ctx maxidx ops H_instk_height H_valid_sstk_0 H_valid_sb) as H_eval_sstack_val_succ_sv.
    destruct H_eval_sstack_val_succ_sv as [v H_eval_sstack_val_succ_sv].
    rewrite H_eval_sstack_val_succ_sv.
    exists (v :: l).
    reflexivity.
Qed.


Lemma eval_sstack_succ:
  forall instk_height maxidx sb stk mem strg ctx ops sstk,
    instk_height = length stk ->
    valid_sstack instk_height maxidx sstk ->
    valid_bindings instk_height maxidx sb ops ->
    exists l,
      eval_sstack sstk maxidx sb stk mem strg ctx ops = Some l.
Proof.
  intros instk_height maxidx sb stk mem strg ctx ops sstk H_instk_height H_valid_sstk H_valid_sb.
  unfold eval_sstack.
  pose proof (eval_map_o_sstk_succ instk_height maxidx sb stk mem strg ctx ops sstk H_instk_height H_valid_sstk H_valid_sb) as H_eval_map_o_sstack_val_succ.
  apply H_eval_map_o_sstack_val_succ.
Qed.



Lemma eval_map_o_smem_succ:
  forall instk_height maxidx sb stk mem strg ctx ops smem,
    instk_height = length stk ->
    valid_smemory instk_height maxidx smem ->
    valid_bindings instk_height maxidx sb ops ->
    exists mem',
      map_option
        (eval_common.EvalCommon.instantiate_memory_update
           (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx sb ops)) smem = Some mem'.
Proof.
  intros instk_height maxidx sb stk mem strg ctx ops.
  induction smem as [|u smem' IHsmem'].
  - intros. simpl. exists []. reflexivity.
  - intros H_instk_height H_valid_smem H_valid_sb.
    simpl in H_valid_smem.
    destruct H_valid_smem as [H_valid_smem_0 H_valid_smem_1].
    unfold map_option.
    rewrite <- map_option_ho.

    (* apply inudction hypothesis *)
    pose proof (IHsmem' H_instk_height H_valid_smem_1 H_valid_sb) as IHsmem'_0.
    destruct IHsmem'_0 as [l IHsmem'_0].
    rewrite IHsmem'_0.

    destruct u as [soffset svalue | soffset svalue].
    +  simpl.
       simpl in H_valid_smem_0.
       destruct H_valid_smem_0 as [H_valid_smem_0_1 H_valid_smem_0_2].

       pose proof (eval_sstack_val_succ sb instk_height soffset stk mem strg ctx maxidx ops H_instk_height H_valid_smem_0_1 H_valid_sb) as H_eval_sstack_val_succ_soffset.
       destruct H_eval_sstack_val_succ_soffset as [vsoffset H_eval_sstack_val_succ_soffset].
       rewrite H_eval_sstack_val_succ_soffset.
       
       pose proof (eval_sstack_val_succ sb instk_height svalue stk mem strg ctx maxidx ops H_instk_height H_valid_smem_0_2 H_valid_sb) as H_eval_sstack_val_succ_svalue.
       destruct H_eval_sstack_val_succ_svalue as [vsvalue H_eval_sstack_val_succ_svalue].
       rewrite H_eval_sstack_val_succ_svalue.

       exists (U_MSTORE EVMWord vsoffset vsvalue :: l).
       reflexivity.

    +  simpl.
       simpl in H_valid_smem_0.
       destruct H_valid_smem_0 as [H_valid_smem_0_1 H_valid_smem_0_2].

       pose proof (eval_sstack_val_succ sb instk_height soffset stk mem strg ctx maxidx ops H_instk_height H_valid_smem_0_1 H_valid_sb) as H_eval_sstack_val_succ_soffset.
       destruct H_eval_sstack_val_succ_soffset as [vsoffset H_eval_sstack_val_succ_soffset].
       rewrite H_eval_sstack_val_succ_soffset.
       
       pose proof (eval_sstack_val_succ sb instk_height svalue stk mem strg ctx maxidx ops H_instk_height H_valid_smem_0_2 H_valid_sb) as H_eval_sstack_val_succ_svalue.
       destruct H_eval_sstack_val_succ_svalue as [vsvalue H_eval_sstack_val_succ_svalue].
       rewrite H_eval_sstack_val_succ_svalue.

       exists (U_MSTORE8 EVMWord vsoffset vsvalue :: l).
       reflexivity.
Qed.

Lemma eval_smemory_succ:
  forall instk_height maxidx sb stk mem strg ctx ops smem,
    instk_height = length stk ->
    valid_smemory instk_height maxidx smem ->
    valid_bindings instk_height maxidx sb ops ->
    exists mem',
      eval_smemory smem maxidx sb stk mem strg ctx ops = Some mem'.
Proof.
  intros instk_height maxidx sb stk mem strg ctx ops smem H_instk_height H_valid_smem H_valid_sb.  
  unfold eval_smemory.
  pose proof (eval_map_o_smem_succ instk_height maxidx sb stk mem strg ctx ops smem H_instk_height H_valid_smem H_valid_sb) as H_eval_map_o_smem_val_succ.
  destruct H_eval_map_o_smem_val_succ as [umem' H_eval_map_o_smem_val_succ].
  rewrite H_eval_map_o_smem_val_succ.
  exists (eval_common.EvalCommon.update_memory mem umem').
  reflexivity.
Qed.

Lemma eval_map_o_sstrg_succ:
  forall instk_height maxidx sb stk mem strg ctx ops sstrg,
    instk_height = length stk ->
    valid_sstorage instk_height maxidx sstrg ->
    valid_bindings instk_height maxidx sb ops ->
    exists strg',
      map_option
        (eval_common.EvalCommon.instantiate_storage_update
           (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx sb ops)) sstrg = Some strg'.
Proof.
  intros instk_height maxidx sb stk mem strg ctx ops.
  induction sstrg as [|u sstrg' IHsstrg'].
  - intros. simpl. exists []. reflexivity.
  - intros H_instk_height H_valid_sstrg H_valid_sb.
    simpl in H_valid_sstrg.
    destruct H_valid_sstrg as [H_valid_sstrg_0 H_valid_sstrg_1].
    unfold map_option.
    rewrite <- map_option_ho.

    (* apply inudction hypothesis *)
    pose proof (IHsstrg' H_instk_height H_valid_sstrg_1 H_valid_sb) as IHsstrg'_0.
    destruct IHsstrg'_0 as [l IHsstrg'_0].
    rewrite IHsstrg'_0.

    destruct u as [skey svalue].
    simpl.
    simpl in H_valid_sstrg_0.
    destruct H_valid_sstrg_0 as [H_valid_sstrg_0_1 H_valid_sstrg_0_2].
    
    pose proof (eval_sstack_val_succ sb instk_height skey stk mem strg ctx maxidx ops H_instk_height H_valid_sstrg_0_1 H_valid_sb) as H_eval_sstack_val_succ_skey.
    destruct H_eval_sstack_val_succ_skey as [vskey H_eval_sstack_val_succ_skey].
    rewrite H_eval_sstack_val_succ_skey.
    
    pose proof (eval_sstack_val_succ sb instk_height svalue stk mem strg ctx maxidx ops H_instk_height H_valid_sstrg_0_2 H_valid_sb) as H_eval_sstack_val_succ_svalue.
    destruct H_eval_sstack_val_succ_svalue as [vsvalue H_eval_sstack_val_succ_svalue].
    rewrite H_eval_sstack_val_succ_svalue.
    
    exists (U_SSTORE EVMWord vskey vsvalue :: l).
    reflexivity.
Qed.

Lemma eval_sstorage_succ:
  forall instk_height maxidx sb stk mem strg ctx ops sstrg,
    instk_height = length stk ->
    valid_sstorage instk_height maxidx sstrg ->
    valid_bindings instk_height maxidx sb ops ->
    exists sstrg',
      eval_sstorage sstrg maxidx sb stk mem strg ctx ops = Some sstrg'.
Proof.
  intros instk_height maxidx sb stk mem strg ctx ops sstrg H_instk_height H_valid_sstrg H_valid_sb.  
  unfold eval_sstorage.
  pose proof (eval_map_o_sstrg_succ instk_height maxidx sb stk mem strg ctx ops sstrg H_instk_height H_valid_sstrg H_valid_sb) as H_eval_map_o_sstrg_val_succ.
  destruct H_eval_map_o_sstrg_val_succ as [ustrg' H_eval_map_o_sstrg_val_succ].
  rewrite H_eval_map_o_sstrg_val_succ.
  exists (eval_common.EvalCommon.update_storage strg ustrg').
  reflexivity.
Qed.


Lemma eval_sstate_succ:
  forall st sst ops,
    valid_sstate sst ops ->
    get_instk_height_sst sst = length (get_stack_st st) ->
    exists st',
      eval_sstate st sst ops = Some st'.
Proof.
  intros st sst ops H_valid_sstate H_instk_height.
  unfold valid_sstate in H_valid_sstate.
  destruct H_valid_sstate as [H_valid_smap [H_valid_sstk [H_valid_smem H_valid_sstrg]]].
  unfold eval_sstate.
  apply Nat.eqb_eq in H_instk_height as H_instk_height_eq.
  rewrite H_instk_height_eq.

  unfold valid_smap in H_valid_smap.
  destruct H_valid_smap as [_ [_ H_valid_sb]].

  pose proof (eval_sstack_succ (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st st) (get_memory_st st) (get_storage_st st) (get_context_st st) ops (get_stack_sst sst) H_instk_height H_valid_sstk H_valid_sb) as H_eval_sstack_succ.
  destruct H_eval_sstack_succ as [l H_eval_sstack_succ].
  rewrite H_eval_sstack_succ.

  pose proof (eval_smemory_succ (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st st) (get_memory_st st) (get_storage_st st) (get_context_st st) ops (get_memory_sst sst) H_instk_height H_valid_smem H_valid_sb) as H_eval_smemory_succ.
  destruct H_eval_smemory_succ as [mem' H_eval_smemory_succ].
  rewrite H_eval_smemory_succ.

  pose proof (eval_sstorage_succ (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st st) (get_memory_st st) (get_storage_st st) (get_context_st st) ops (get_storage_sst sst) H_instk_height H_valid_sstrg H_valid_sb) as H_eval_sstorage_succ.
  destruct H_eval_sstorage_succ as [strg' H_eval_sstorage_succ].
  rewrite H_eval_sstorage_succ.

  exists (make_st l mem' strg' (get_context_st st)).
  reflexivity.
Qed.

Lemma eval_sstack_val'_preserved_when_depth_extended:
  forall d maxidx sb sv v stk mem strg ctx ops,
    eval_sstack_val' d sv stk mem strg ctx maxidx sb ops = Some v ->
    eval_sstack_val' (S d) sv stk mem strg ctx maxidx sb ops = Some v.
Proof.
  induction d as [|d' IHd'].
  - discriminate.
  - intros maxidx sb sv v stk mem strg ctx ops H_eval_sstack_val'_d.

    assert(H_mapo:
            forall args maxidx sb l,
            (map_option (fun sv' : sstack_val => eval_sstack_val' d' sv' stk mem strg ctx maxidx sb ops) args) = Some l ->
            (map_option (fun sv' : sstack_val => eval_sstack_val' (S d') sv' stk mem strg ctx maxidx sb ops) args) = Some l).

    (* proof of assert *)
    + induction args as [|a args' IHargs'].
      * intuition.
      * intros maxidx0 sb0 l H_mapo.
        simpl in H_mapo.
        destruct (eval_sstack_val' d' a stk mem strg ctx maxidx0 sb0 ops) eqn:E_eval_sstack_val'; try discriminate.
        destruct (map_option (fun sv' : sstack_val => eval_sstack_val' d' sv' stk mem strg ctx maxidx0 sb0 ops) args') eqn:E_mapo'; try discriminate.
        pose proof (IHargs' maxidx0 sb0 l0 E_mapo') as IHargs'_0.
        pose proof (IHd' maxidx0 sb0 a e stk mem strg ctx ops E_eval_sstack_val') as IHd'_0.
        unfold map_option.
        rewrite <- map_option_ho.
        rewrite IHd'_0.
        rewrite IHargs'_0.
        apply   H_mapo.
    (* end proof of assert *)

    + remember (S d') as dd.
      rewrite Heqdd in H_eval_sstack_val'_d.
      simpl.
      simpl in H_eval_sstack_val'_d.
      destruct (follow_in_smap sv maxidx sb) as [x|] eqn:E_follow; try discriminate.
      destruct x eqn:E_x; try reflexivity.
      destruct smv eqn:E_smv.
      * apply H_eval_sstack_val'_d.
      * apply H_eval_sstack_val'_d.
      * destruct (ops label) eqn:E_label.
        destruct (length args =? n) eqn:E_len; try discriminate.
        destruct (map_option (fun sv' : sstack_val => eval_sstack_val' d' sv' stk mem strg ctx key sb0 ops) args) eqn:E_mapo; try discriminate.
        pose proof (H_mapo args key sb0 l E_mapo) as E_mapo_0.
        rewrite E_mapo_0.
        apply H_eval_sstack_val'_d.
      * assert(H_mapo_mem :
                forall args maxidx sb l,
                  (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv' : sstack_val => eval_sstack_val' d' sv' stk mem strg ctx maxidx sb ops)) args) = Some l ->
                  (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv' : sstack_val => eval_sstack_val' (S d') sv' stk mem strg ctx maxidx sb ops)) args) = Some l).
                (* proof of assert *)
            ** induction args as [|a args' IHargs'].
               *** intuition.
               *** intros maxidx0 sb1 l H_mapo_mem.
                   simpl in H_mapo_mem.
                   unfold eval_common.EvalCommon.instantiate_memory_update in H_mapo_mem at 1.
                   destruct a eqn:E_a.
                   **** destruct (eval_sstack_val' d' offset0 stk mem strg ctx maxidx0 sb1 ops) eqn:E_offset0; try discriminate.
                        destruct (eval_sstack_val' d' value stk mem strg ctx maxidx0 sb1 ops) eqn:E_value; try discriminate.
                        destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv' : sstack_val => eval_sstack_val' d' sv' stk mem strg ctx maxidx0 sb1 ops)) args') eqn:E_mapo_args'; try discriminate.
                        pose proof (IHd' maxidx0 sb1 offset0 e stk mem strg ctx ops E_offset0) as IHd'_0.
                        pose proof (IHd' maxidx0 sb1 value e0 stk mem strg ctx ops E_value) as IHd'_1.
                        pose proof (IHargs' maxidx0 sb1 l0 E_mapo_args') as IHargs'_0.
                        rewrite <- Heqdd.
                        simpl.
                        rewrite IHd'_0.
                        rewrite IHd'_1.
                        rewrite Heqdd.
                        rewrite IHargs'_0.
                        apply H_mapo_mem.
                   **** destruct (eval_sstack_val' d' offset0 stk mem strg ctx maxidx0 sb1 ops) eqn:E_offset0; try discriminate.
                        destruct (eval_sstack_val' d' value stk mem strg ctx maxidx0 sb1 ops) eqn:E_value; try discriminate.
                        destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv' : sstack_val => eval_sstack_val' d' sv' stk mem strg ctx maxidx0 sb1 ops)) args') eqn:E_mapo_args'; try discriminate.
                        pose proof (IHd' maxidx0 sb1 offset0 e stk mem strg ctx ops E_offset0) as IHd'_0.
                        pose proof (IHd' maxidx0 sb1 value e0 stk mem strg ctx ops E_value) as IHd'_1.
                        pose proof (IHargs' maxidx0 sb1 l0 E_mapo_args') as IHargs'_0.
                        rewrite <- Heqdd.
                        simpl.
                        rewrite IHd'_0.
                        rewrite IHd'_1.
                        rewrite Heqdd.
                        rewrite IHargs'_0.
                        apply H_mapo_mem.
            (* end proof of assert *)
            ** destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' d' sv stk mem strg ctx key sb0 ops)) smem) eqn:E_mapo_smem; try discriminate.
               pose proof (H_mapo_mem smem key sb0 l E_mapo_smem) as H_mapo_mem_0.
               rewrite Heqdd.
               rewrite H_mapo_mem_0.
               destruct (eval_sstack_val' d' offset stk mem strg ctx key sb0 ops) eqn:E_eval_sstack_val'_offset; try discriminate.
               pose proof (IHd' key sb0 offset e stk mem strg ctx ops E_eval_sstack_val'_offset) as IHd'_0.
               rewrite <- Heqdd.
               rewrite IHd'_0.
               apply H_eval_sstack_val'_d.

      * assert(H_mapo_strg :
                forall args maxidx sb l,
                  (map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv' : sstack_val => eval_sstack_val' d' sv' stk mem strg ctx maxidx sb ops)) args) = Some l ->
                  (map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv' : sstack_val => eval_sstack_val' (S d') sv' stk mem strg ctx maxidx sb ops)) args) = Some l).
                (* proof of assert *)
            ** induction args as [|a args' IHargs'].
               *** intuition.
               *** intros maxidx0 sb1 l H_mapo_strg.
                   simpl in H_mapo_strg.
                   unfold eval_common.EvalCommon.instantiate_storage_update in H_mapo_strg at 1.
                   destruct a eqn:E_a.
                   destruct (eval_sstack_val' d' key1 stk mem strg ctx maxidx0 sb1 ops) eqn:E_key1; try discriminate.
                   destruct (eval_sstack_val' d' value stk mem strg ctx maxidx0 sb1 ops) eqn:E_value; try discriminate.
                   destruct (map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv' : sstack_val => eval_sstack_val' d' sv' stk mem strg ctx maxidx0 sb1 ops)) args') eqn:E_mapo_args'; try discriminate.
                        pose proof (IHd' maxidx0 sb1 key1 e stk mem strg ctx ops E_key1) as IHd'_0.
                        pose proof (IHd' maxidx0 sb1 value e0 stk mem strg ctx ops E_value) as IHd'_1.
                        pose proof (IHargs' maxidx0 sb1 l0 E_mapo_args') as IHargs'_0.
                        rewrite <- Heqdd.
                        simpl.
                        rewrite IHd'_0.
                        rewrite IHd'_1.
                        rewrite Heqdd.
                        rewrite IHargs'_0.
                        apply H_mapo_strg.
            (* end proof of assert *)
            ** destruct (map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val' d' sv stk mem strg ctx key sb0 ops)) sstrg) eqn:E_mapo_sstrg; try discriminate.
               pose proof (H_mapo_strg sstrg key sb0 l E_mapo_sstrg) as H_mapo_strg_0.
               rewrite Heqdd.
               rewrite H_mapo_strg_0.
               destruct (eval_sstack_val' d' key0 stk mem strg ctx key sb0 ops) eqn:E_eval_sstack_val'_offset; try discriminate.
               pose proof (IHd' key sb0 key0 e stk mem strg ctx ops E_eval_sstack_val'_offset) as IHd'_0.
               rewrite <- Heqdd.
               rewrite IHd'_0.
               apply H_eval_sstack_val'_d.
      * assert(H_mapo_mem :
                forall args maxidx sb l,
                  (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv' : sstack_val => eval_sstack_val' d' sv' stk mem strg ctx maxidx sb ops)) args) = Some l ->
                  (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv' : sstack_val => eval_sstack_val' (S d') sv' stk mem strg ctx maxidx sb ops)) args) = Some l).
                (* proof of assert *)
            ** induction args as [|a args' IHargs'].
               *** intuition.
               *** intros maxidx0 sb1 l H_mapo_mem.
                   simpl in H_mapo_mem.
                   unfold eval_common.EvalCommon.instantiate_memory_update in H_mapo_mem at 1.
                   destruct a eqn:E_a.
                   **** destruct (eval_sstack_val' d' offset0 stk mem strg ctx maxidx0 sb1 ops) eqn:E_offset0; try discriminate.
                        destruct (eval_sstack_val' d' value stk mem strg ctx maxidx0 sb1 ops) eqn:E_value; try discriminate.
                        destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv' : sstack_val => eval_sstack_val' d' sv' stk mem strg ctx maxidx0 sb1 ops)) args') eqn:E_mapo_args'; try discriminate.
                        pose proof (IHd' maxidx0 sb1 offset0 e stk mem strg ctx ops E_offset0) as IHd'_0.
                        pose proof (IHd' maxidx0 sb1 value e0 stk mem strg ctx ops E_value) as IHd'_1.
                        pose proof (IHargs' maxidx0 sb1 l0 E_mapo_args') as IHargs'_0.
                        rewrite <- Heqdd.
                        simpl.
                        rewrite IHd'_0.
                        rewrite IHd'_1.
                        rewrite Heqdd.
                        rewrite IHargs'_0.
                        apply H_mapo_mem.
                   **** destruct (eval_sstack_val' d' offset0 stk mem strg ctx maxidx0 sb1 ops) eqn:E_offset0; try discriminate.
                        destruct (eval_sstack_val' d' value stk mem strg ctx maxidx0 sb1 ops) eqn:E_value; try discriminate.
                        destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv' : sstack_val => eval_sstack_val' d' sv' stk mem strg ctx maxidx0 sb1 ops)) args') eqn:E_mapo_args'; try discriminate.
                        pose proof (IHd' maxidx0 sb1 offset0 e stk mem strg ctx ops E_offset0) as IHd'_0.
                        pose proof (IHd' maxidx0 sb1 value e0 stk mem strg ctx ops E_value) as IHd'_1.
                        pose proof (IHargs' maxidx0 sb1 l0 E_mapo_args') as IHargs'_0.
                        rewrite <- Heqdd.
                        simpl.
                        rewrite IHd'_0.
                        rewrite IHd'_1.
                        rewrite Heqdd.
                        rewrite IHargs'_0.
                        apply H_mapo_mem.
            (* end proof of assert *)
      ** destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' d' sv stk mem strg ctx key sb0 ops)) smem) eqn:E_mapo_smem; try discriminate.
        destruct (eval_sstack_val' d' offset stk mem strg ctx key sb0 ops) eqn:E_eval_offset; try discriminate.
        destruct (eval_sstack_val' d' size stk mem strg ctx key sb0 ops) eqn:E_eval_size; try discriminate.
        pose proof (H_mapo_mem smem key sb0 l E_mapo_smem) as E_mapo_0.
        pose proof (IHd' key sb0 offset e stk mem strg ctx ops E_eval_offset) as IHd'_0.
        pose proof (IHd' key sb0 size e0 stk mem strg ctx ops E_eval_size) as IHd'_1.
        rewrite IHd'_0.
        rewrite IHd'_1.
        rewrite Heqdd.
        rewrite E_mapo_0.
        apply H_eval_sstack_val'_d.
Qed.

Lemma eval_sstack_val'_preserved_when_depth_extended_by_i:
  forall i d maxidx sb sv v stk mem strg ctx ops,
    eval_sstack_val' d sv stk mem strg ctx maxidx sb ops = Some v ->
    eval_sstack_val' (d+i) sv stk mem strg ctx maxidx sb ops = Some v.
Proof.
  induction i as [|i' IHi'].
  - intros. rewrite Nat.add_0_r. apply H.
  - intros d maxidx sb sv v stk mem strg ctx ops H_eval_d.
    + pose proof (IHi' d maxidx sb sv v stk mem strg ctx ops H_eval_d) as IHi'_0.
      rewrite Nat.add_succ_r.
      apply eval_sstack_val'_preserved_when_depth_extended.
      apply IHi'_0.
Qed.

Lemma a_lt_b_a_plus_i_eq_b:
  forall a b,
    a <= b ->  a+(b-a) = b.
Proof.
  intuition.
Qed.
  
Lemma eval_sstack_val'_preserved_when_depth_extended_le:
  forall d1 d2 maxidx sb sv v stk mem strg ctx ops,
    d1 <= d2 ->
    eval_sstack_val' d1 sv stk mem strg ctx maxidx sb ops = Some v ->
    eval_sstack_val' d2 sv stk mem strg ctx maxidx sb ops = Some v.
Proof.
  intros d1 d2 maxidx sb sv v stk mem strg ctx ops H_d1_le_d2 H_eval_d1.
  apply a_lt_b_a_plus_i_eq_b in H_d1_le_d2.
  rewrite <- H_d1_le_d2.
  apply eval_sstack_val'_preserved_when_depth_extended_by_i.
  apply H_eval_d1.
Qed.

Lemma eval_sstack_val'_preserved_when_depth_extended_lt:
  forall d1 d2 maxidx sb sv v stk mem strg ctx ops,
    d1 < d2 ->
    eval_sstack_val' d1 sv stk mem strg ctx maxidx sb ops = Some v ->
    eval_sstack_val' d2 sv stk mem strg ctx maxidx sb ops = Some v.
Proof.
  intros.
  apply eval_sstack_val'_preserved_when_depth_extended_le with (d1:=d1); intuition.
Qed.


Lemma instantiate_memory_update_preserved_when_depth_ext_le:
  forall d1 d2 stk mem strg ctx maxidx sb ops u u',
    d1 <= d2 ->
    EvalCommon.instantiate_memory_update
      (fun sv : sstack_val => eval_sstack_val' d1 sv stk mem strg ctx maxidx sb ops) u = Some u' -> 
    EvalCommon.instantiate_memory_update
      (fun sv : sstack_val => eval_sstack_val' d2 sv stk mem strg ctx maxidx sb ops) u = Some u'.
  Proof.
    intros d1 d2 stk mem strg ctx maxidx sb ops u u' H_d1_le_d2 H_mem_u.
    destruct u as [soffset svalue|soffset svalue].
    - simpl.
      simpl in H_mem_u.
      destruct (eval_sstack_val' d1 soffset stk mem strg ctx maxidx sb ops) as [offset|] eqn:E_eval_soffset; try discriminate.
      destruct (eval_sstack_val' d1 svalue stk mem strg ctx maxidx sb ops) as [value|] eqn:E_eval_svalue; try discriminate.
      pose proof (eval_sstack_val'_preserved_when_depth_extended_le d1 d2 maxidx sb soffset offset stk mem strg ctx ops H_d1_le_d2 E_eval_soffset) as E_eval_soffset_d2.
      pose proof (eval_sstack_val'_preserved_when_depth_extended_le d1 d2 maxidx sb svalue value stk mem strg ctx ops H_d1_le_d2 E_eval_svalue) as E_eval_svalue_d2.
      rewrite E_eval_soffset_d2.
      rewrite E_eval_svalue_d2.
      rewrite <- H_mem_u.
      reflexivity.
    - simpl.
      simpl in H_mem_u.
      destruct (eval_sstack_val' d1 soffset stk mem strg ctx maxidx sb ops) as [offset|] eqn:E_eval_soffset; try discriminate.
      destruct (eval_sstack_val' d1 svalue stk mem strg ctx maxidx sb ops) as [value|] eqn:E_eval_svalue; try discriminate.
      pose proof (eval_sstack_val'_preserved_when_depth_extended_le d1 d2 maxidx sb soffset offset stk mem strg ctx ops H_d1_le_d2 E_eval_soffset) as E_eval_soffset_d2.
      pose proof (eval_sstack_val'_preserved_when_depth_extended_le d1 d2 maxidx sb svalue value stk mem strg ctx ops H_d1_le_d2 E_eval_svalue) as E_eval_svalue_d2.
      rewrite E_eval_soffset_d2.
      rewrite E_eval_svalue_d2.
      rewrite <- H_mem_u.
      reflexivity.
  Qed.      
    
  
  Lemma instantiate_memory_update_mapo_preserved_when_depth_ext_le:
    forall smem d1 d2 stk mem strg ctx maxidx sb ops updates,
      d1 <= d2 ->
      map_option (EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' d1 sv stk mem strg ctx maxidx sb ops)) smem = Some updates ->
      map_option (EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' d2 sv stk mem strg ctx maxidx sb ops)) smem = Some updates.
  Proof.
    induction smem as [|u smem' IHsmem'].
    - intros d1 d2 stk mem strg ctx maxidx sb ops updates H_d1_le_d2 H_mapo.
      simpl.
      simpl in H_mapo.
      rewrite <- H_mapo.
      reflexivity.
    - intros d1 d2 stk mem strg ctx maxidx sb ops updates H_d1_le_d2 H_mapo.
      simpl in H_mapo.
      destruct (EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' d1 sv stk mem strg ctx maxidx sb ops) u) as [elem_value|] eqn:E_inst_mem_up; try discriminate.
      destruct (map_option (EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' d1 sv stk mem strg ctx maxidx sb ops)) smem') as [rs_val|] eqn:E_inst_mapo; try discriminate.
      pose proof (instantiate_memory_update_preserved_when_depth_ext_le d1 d2 stk mem strg ctx maxidx sb ops u elem_value H_d1_le_d2 E_inst_mem_up) as E_inst_mem_up_d2.
      pose proof (IHsmem' d1 d2 stk mem strg ctx maxidx sb ops rs_val H_d1_le_d2 E_inst_mapo) as E_inst_mapo_d2.
      simpl.
      rewrite E_inst_mem_up_d2.
      rewrite E_inst_mapo_d2.
      rewrite <- H_mapo.
      reflexivity.
  Qed.
      
  Lemma eval_sstack_val'_mapo_preserved_when_depth_ext_le:
    forall sstk d1 d2 stk mem strg ctx maxidx sb ops stk',
      d1 <= d2 ->
      map_option (fun sv : sstack_val => eval_sstack_val' d1 sv stk mem strg ctx maxidx sb ops) sstk = Some stk' ->
      map_option (fun sv : sstack_val => eval_sstack_val' d2 sv stk mem strg ctx maxidx sb ops) sstk = Some stk'.
  Proof.
    induction sstk as [|sv sstk' IHsstk'].
    - intros d1 d2 stk mem strg ctx maxidx sb ops stk' H_d1_le_d2 H_mapo.
      simpl.
      simpl in H_mapo.
      rewrite <- H_mapo.
      reflexivity.
    - intros d1 d2 stk mem strg ctx maxidx sb ops stk' H_d1_le_d2 H_mapo.
      simpl in H_mapo.
      destruct (eval_sstack_val' d1 sv stk mem strg ctx maxidx sb ops) as [elem_val|] eqn:E_eval_sstack; try discriminate.
      destruct (map_option (fun sv : sstack_val => eval_sstack_val' d1 sv stk mem strg ctx maxidx sb ops) sstk') as [rs_val|] eqn:E_inst_mapo; try discriminate.
      pose proof (eval_sstack_val'_preserved_when_depth_extended_le d1 d2 maxidx sb sv elem_val stk mem strg ctx ops H_d1_le_d2 E_eval_sstack) as H_eval_sstack_val'_d2.
      pose proof (IHsstk' d1 d2 stk mem strg ctx maxidx sb ops rs_val H_d1_le_d2 E_inst_mapo) as E_inst_mapo_d2.
      simpl.
      rewrite H_eval_sstack_val'_d2.
      rewrite E_inst_mapo_d2.
      rewrite <- H_mapo.
      reflexivity.
  Qed.
      


Lemma eval_fvar_diff: forall (fvar n: nat) (stk: stack) (mem: memory) 
  (strg: storage) (ctx: context) (maxid: nat) (smapv: smap_value) 
  (ops: stack_op_instr_map) (sb: sbindings),
fvar =? n = false ->
eval_sstack_val (FreshVar fvar) stk mem strg ctx maxid ((n, smapv) :: sb) ops =
eval_sstack_val (FreshVar fvar) stk mem strg ctx maxid sb ops.
Proof.
Admitted.

End SymbolicStateEvalFacts.



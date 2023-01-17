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





(*
Fixpoint eval_sstack_val (sv : sstack_val) (stk : stack) (mem: memory) (strg: storage) (ctx: context) (maxidx: nat) (sb: sbindings) (ops: stack_op_instr_map) : option EVMWord :=  
*)
 

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

  
Lemma eval_sstack_val_succ:
  forall sb instk_height sv stk mem strg ctx maxidx ops,
    instk_height = length stk ->
    valid_sstack_value instk_height maxidx sv ->
    valid_bindings instk_height maxidx sb ops ->
    exists v,
      eval_sstack_val sv stk mem strg ctx maxidx sb ops = Some v.
Proof.
  induction sb as [|p sb'].
  - intros instk_height sv stk mem strg ctx maxidx ops H_instk_height H_valid_sv H_valid_sb.
    destruct sv as [val|n|idx] eqn:E_svn.
    + simpl. exists val. reflexivity.
    + simpl. unfold valid_sstack_value in H_valid_sv.
      rewrite H_instk_height in H_valid_sv. 
      pose proof (nth_error_nth' stk WZero H_valid_sv) as H_nth_error_stk.
      rewrite H_nth_error_stk.
      exists (nth n stk WZero).
      reflexivity.
    + simpl.
      simpl valid_bindings in H_valid_sb.
      simpl in H_valid_sv.
      rewrite H_valid_sb in H_valid_sv.
      pose proof Nat.nlt_0_r idx.
      contradiction.
  - intros instk_height sv stk mem strg ctx maxidx ops H_instk_height H_valid_sv H_valid_sb.
    destruct sv as [val|n|idx] eqn:E_sv.

    (* Val *)
    + simpl. exists val. reflexivity.

    (* InStackVar *)
    + simpl. unfold valid_sstack_value in H_valid_sv.
      rewrite H_instk_height in H_valid_sv. 
      pose proof (nth_error_nth' stk WZero H_valid_sv) as H_nth_error_stk.
      rewrite H_nth_error_stk.
      exists (nth n stk WZero).
      reflexivity.

    (* FreshVar *)
    + simpl.
      fold eval_sstack_val.
      destruct p as [key smv].
      destruct (key =? idx) eqn:E_key_eqb_idx.

      (* idx is equal to key *)
      * destruct smv as [sv' | v | label args | soffset smem | skey sstrg | soffset ssize smem ] eqn:E_smv.

        (* SymBasicVal *)
        ** unfold valid_bindings in H_valid_sb. fold valid_bindings in H_valid_sb.
           destruct H_valid_sb as [H_valid_sb_0 [H_valid_sb_1 H_valid_sb_2]].
           unfold valid_smap_value in H_valid_sb_1.
           pose proof (IHsb' instk_height sv' stk mem strg ctx key ops H_instk_height H_valid_sb_1 H_valid_sb_2) as IHsb'_0.
           apply IHsb'_0.

        (* SymPUSHTAG  *)
        ** exists (get_tags_ctx ctx v). reflexivity.

        (* OpImp nargs f *)
        ** destruct (ops label) eqn:E_f.
           unfold valid_bindings in H_valid_sb. fold valid_bindings in H_valid_sb.
           destruct H_valid_sb as [H_valid_sb_0 [H_valid_sb_1 H_valid_sb_2]].
           unfold valid_smap_value in H_valid_sb_1.
           unfold valid_stack_op_instr in H_valid_sb_1.
           rewrite E_f in H_valid_sb_1.
           destruct H_valid_sb_1 as [H_valid_sb_1_0 H_valid_sb_1_1].
           apply Nat.eqb_eq in H_valid_sb_1_0 as H_valid_sb_1_0_eqb.
           rewrite H_valid_sb_1_0_eqb.

           assert(H_eval_args: forall args0,
                     valid_sstack instk_height key args0 ->
                     exists v, map_option (fun sv' : sstack_val => eval_sstack_val sv' stk mem strg ctx key sb' ops) args0 = Some v).
           (* proof of assert *)
           *** induction args0 as [|a args0' IHargs'].
               **** intros. exists []. reflexivity.
               **** intro H_valid_args0.
                    unfold valid_sstack in H_valid_args0. fold valid_sstack in H_valid_args0.
                    destruct H_valid_args0 as [H_valid_a H_valid_args0].
                    unfold map_option.
                    rewrite <- map_option_ho.
                    pose proof (IHsb' instk_height a stk mem strg ctx key ops H_instk_height H_valid_a H_valid_sb_2) as IHsb'_0.
                    destruct IHsb'_0 as [v IHsb'_0].
                    rewrite IHsb'_0.
                    pose proof  IHargs'  H_valid_args0 as IHargs'_0.
                    destruct IHargs'_0 as [vargs0' IHargs'_0].
                    rewrite IHargs'_0.
                    exists (v :: vargs0').
                    reflexivity.
           (* end proof of assert *)

           *** pose proof (H_eval_args args H_valid_sb_1_1) as H_eval_args.
               destruct H_eval_args as [v H_eval_args].
               rewrite H_eval_args.
               exists (f ctx v).
               reflexivity.

        (* SymMLOAD *)
        ** unfold valid_bindings in H_valid_sb. fold valid_bindings in H_valid_sb.
           destruct H_valid_sb as [H_valid_sb_0 [H_valid_sb_1 H_valid_sb_2]].
           unfold valid_smap_value in H_valid_sb_1.
           destruct H_valid_sb_1 as [H_valid_sb_1_0 H_valid_sb_1_1].

           assert(H_map_o_smem:
                   forall smem0,
                     valid_smemory instk_height key smem0 ->
                     exists v,
                       map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv0 : sstack_val => eval_sstack_val sv0 stk mem strg ctx key sb' ops)) smem0 = Some v).

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
                          pose proof (IHsb' instk_height soffset' stk mem strg ctx key ops H_instk_height H_valid_smemory_0_0 H_valid_sb_2) as IHsb'_0.
                          destruct IHsb'_0 as [voffset IHsb'_0].
                          rewrite  IHsb'_0.
                          pose proof (IHsb' instk_height svalue' stk mem strg ctx key ops H_instk_height H_valid_smemory_0_1 H_valid_sb_2) as IHsb'_1.
                          destruct IHsb'_1 as [vvalue IHsb'_1].
                          rewrite  IHsb'_1.

                          pose proof (IHsmem0' H_valid_smemory_1) as IHsmem0'_0.
                          destruct IHsmem0'_0 as [vsmem0' IHsmem0'_0].
                          rewrite IHsmem0'_0.
                          exists (U_MSTORE EVMWord voffset vvalue :: vsmem0').
                          reflexivity.
                    ***** unfold valid_smemory in H_valid_smemory. fold valid_smemory in H_valid_smemory.
                          destruct H_valid_smemory as [H_valid_smemory_0 H_valid_smemory_1].
                          unfold valid_smemory_update in H_valid_smemory_0.
                          destruct H_valid_smemory_0 as [H_valid_smemory_0_0 H_valid_smemory_0_1].
                          pose proof (IHsb' instk_height soffset' stk mem strg ctx key ops H_instk_height H_valid_smemory_0_0 H_valid_sb_2) as IHsb'_0.
                          destruct IHsb'_0 as [voffset IHsb'_0].
                          rewrite  IHsb'_0.
                          pose proof (IHsb' instk_height svalue' stk mem strg ctx key ops H_instk_height H_valid_smemory_0_1 H_valid_sb_2) as IHsb'_1.
                          destruct IHsb'_1 as [vvalue IHsb'_1].
                          rewrite  IHsb'_1.

                          pose proof (IHsmem0' H_valid_smemory_1) as IHsmem0'_0.
                          destruct IHsmem0'_0 as [vsmem0' IHsmem0'_0].
                          rewrite IHsmem0'_0.
                          exists (U_MSTORE8 EVMWord voffset vvalue :: vsmem0').
                          reflexivity.

           (* end proof of assert *)
           *** pose proof (H_map_o_smem smem H_valid_sb_1_1) as H_map_o_smem_0.
               destruct H_map_o_smem_0 as [v H_map_o_smem_0].
               rewrite H_map_o_smem_0.

               pose proof (IHsb' instk_height soffset stk mem strg ctx key ops H_instk_height H_valid_sb_1_0 H_valid_sb_2) as IHsb'_0.
               destruct IHsb'_0 as [voffset IHsb'_0].
               rewrite IHsb'_0.

               exists (concrete_interpreter.ConcreteInterpreter.mload (eval_common.EvalCommon.update_memory mem v) voffset).
               reflexivity.

        (* SymMLOAD *)
        ** unfold valid_bindings in H_valid_sb. fold valid_bindings in H_valid_sb.
           destruct H_valid_sb as [H_valid_sb_0 [H_valid_sb_1 H_valid_sb_2]].
           unfold valid_smap_value in H_valid_sb_1.
           destruct H_valid_sb_1 as [H_valid_sb_1_0 H_valid_sb_1_1].

           assert(H_map_o_sstrg:
                   forall sstrg0,
                     valid_sstorage instk_height key sstrg0 ->
                     exists v,
                       map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv0 : sstack_val => eval_sstack_val sv0 stk mem strg ctx key sb' ops)) sstrg0 = Some v).
           
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
                    pose proof (IHsb' instk_height skey' stk mem strg ctx key ops H_instk_height H_valid_sstorage_0_0 H_valid_sb_2) as IHsb'_0.
                    destruct IHsb'_0 as [voffset IHsb'_0].
                    rewrite  IHsb'_0.
                    pose proof (IHsb' instk_height svalue' stk mem strg ctx key ops H_instk_height H_valid_sstorage_0_1 H_valid_sb_2) as IHsb'_1.
                    destruct IHsb'_1 as [vvalue IHsb'_1].
                    rewrite  IHsb'_1.
                    
                    pose proof (IHsstrg0' H_valid_sstorage_1) as IHsstrg0'_0.
                    destruct IHsstrg0'_0 as [vsstrg0' IHsstrg0'_0].
                    rewrite IHsstrg0'_0.
                    exists (U_SSTORE EVMWord voffset vvalue :: vsstrg0').
                    reflexivity.
           (* end proof of assert *)
                    
           *** pose proof (H_map_o_sstrg sstrg H_valid_sb_1_1) as H_map_o_sstrg_0.
               destruct H_map_o_sstrg_0 as [v H_map_o_sstrg_0].
               rewrite H_map_o_sstrg_0.

               pose proof (IHsb' instk_height skey stk mem strg ctx key ops H_instk_height H_valid_sb_1_0 H_valid_sb_2) as IHsb'_0.
               destruct IHsb'_0 as [vkey IHsb'_0].
               rewrite IHsb'_0.

               exists (concrete_interpreter.ConcreteInterpreter.sload (eval_common.EvalCommon.update_storage strg v) vkey).
               reflexivity.

        (* SymSHA3 *)
        ** unfold valid_bindings in H_valid_sb. fold valid_bindings in H_valid_sb.
           destruct H_valid_sb as [H_valid_sb_0 [H_valid_sb_1 H_valid_sb_2]].
           unfold valid_smap_value in H_valid_sb_1.
           destruct H_valid_sb_1 as [H_valid_sb_1_0 [H_valid_sb_1_1 H_valid_sb_1_2]].

           assert(H_map_o_smem:
                   forall smem0,
                     valid_smemory instk_height key smem0 ->
                     exists v,
                       map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv0 : sstack_val => eval_sstack_val sv0 stk mem strg ctx key sb' ops)) smem0 = Some v).

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
                          pose proof (IHsb' instk_height soffset' stk mem strg ctx key ops H_instk_height H_valid_smemory_0_0 H_valid_sb_2) as IHsb'_0.
                          destruct IHsb'_0 as [voffset IHsb'_0].
                          rewrite  IHsb'_0.
                          pose proof (IHsb' instk_height svalue' stk mem strg ctx key ops H_instk_height H_valid_smemory_0_1 H_valid_sb_2) as IHsb'_1.
                          destruct IHsb'_1 as [vvalue IHsb'_1].
                          rewrite  IHsb'_1.

                          pose proof (IHsmem0' H_valid_smemory_1) as IHsmem0'_0.
                          destruct IHsmem0'_0 as [vsmem0' IHsmem0'_0].
                          rewrite IHsmem0'_0.
                          exists (U_MSTORE EVMWord voffset vvalue :: vsmem0').
                          reflexivity.
                    ***** unfold valid_smemory in H_valid_smemory. fold valid_smemory in H_valid_smemory.
                          destruct H_valid_smemory as [H_valid_smemory_0 H_valid_smemory_1].
                          unfold valid_smemory_update in H_valid_smemory_0.
                          destruct H_valid_smemory_0 as [H_valid_smemory_0_0 H_valid_smemory_0_1].
                          pose proof (IHsb' instk_height soffset' stk mem strg ctx key ops H_instk_height H_valid_smemory_0_0 H_valid_sb_2) as IHsb'_0.
                          destruct IHsb'_0 as [voffset IHsb'_0].
                          rewrite  IHsb'_0.
                          pose proof (IHsb' instk_height svalue' stk mem strg ctx key ops H_instk_height H_valid_smemory_0_1 H_valid_sb_2) as IHsb'_1.
                          destruct IHsb'_1 as [vvalue IHsb'_1].
                          rewrite  IHsb'_1.

                          pose proof (IHsmem0' H_valid_smemory_1) as IHsmem0'_0.
                          destruct IHsmem0'_0 as [vsmem0' IHsmem0'_0].
                          rewrite IHsmem0'_0.
                          exists (U_MSTORE8 EVMWord voffset vvalue :: vsmem0').
                          reflexivity.

           (* end proof of assert *)
           *** pose proof (H_map_o_smem smem H_valid_sb_1_2) as H_map_o_smem_0.
               destruct H_map_o_smem_0 as [v H_map_o_smem_0].
               rewrite H_map_o_smem_0.

               pose proof (IHsb' instk_height soffset stk mem strg ctx key ops H_instk_height H_valid_sb_1_0 H_valid_sb_2) as IHsb'_0.
               destruct IHsb'_0 as [voffset IHsb'_0].
               rewrite IHsb'_0.

               pose proof (IHsb' instk_height ssize stk mem strg ctx key ops H_instk_height H_valid_sb_1_1 H_valid_sb_2) as IHsb'_1.
               destruct IHsb'_1 as [vsize IHsb'_1].
               rewrite IHsb'_1.

               exists (get_keccak256_ctx ctx (wordToNat vsize) (concrete_interpreter.ConcreteInterpreter.mload' (eval_common.EvalCommon.update_memory mem v) voffset(wordToNat vsize))).
               reflexivity.

      (* idx is different from key *)
      * unfold valid_bindings in H_valid_sb.
        fold valid_bindings in H_valid_sb.
        destruct H_valid_sb as [H_valid_sb_0 [H_valid_sb_1 H_valid_sb_2]].
        unfold valid_sstack_value in H_valid_sv.
        apply Nat.eqb_neq in E_key_eqb_idx as E_key_neq_idx.
        rewrite H_valid_sb_0 in H_valid_sv.
        apply not_eq_sym in E_key_neq_idx.
        pose proof (n_Sm_neq_lt idx key H_valid_sv E_key_neq_idx) as H_idx_lt_key.
        pose proof (valid_sstack_value_FreshVar instk_height key idx H_idx_lt_key) as H_valid_sstack_value_FreshVar.
        pose proof (IHsb' instk_height (FreshVar idx) stk mem strg ctx key ops H_instk_height H_valid_sstack_value_FreshVar H_valid_sb_2) as IHsb'_0.
        apply IHsb'_0.
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
      eval_sstate st sst ops =  Some st'.
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

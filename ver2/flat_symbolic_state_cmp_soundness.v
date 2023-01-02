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

Require Import FORVES.flat_symbolic_state.
Import FlatSymbolicState.

Require Import FORVES.flat_symbolic_state_eval.
Import FlatSymbolicStateEval.

Require Import FORVES.flat_symbolic_state_cmp.
Import FlatSymbolicStateCmp.

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import FORVES.eval_common.
Import EvalCommon.


Lemma nth_error_ok : forall (T: Type) (l : list T) (i : nat),
i < length l -> 
exists (v: T), nth_error l i = Some v.
Proof.
intros T l i. revert T l.
induction i as [| i' IH].
- intros T l Hlen.
  destruct l as [| h t] eqn: eq_l.
  + simpl in Hlen. 
    pose proof (Nat.nlt_0_r 0). contradiction.
  + simpl. exists h. reflexivity.
- intros T l Hlen.
  destruct l as [| h t] eqn: eq_l.
  + simpl in Hlen. pose proof (Nat.nlt_0_r (S i')). contradiction.
  + simpl in Hlen. rewrite <- Nat.succ_lt_mono in Hlen.
    simpl.
    pose proof (IH T t Hlen). assumption.
Qed.

Lemma sexp_cmp_snd:
  forall (mload_cmp: mload_cmp_type) (sload_cmp: sload_cmp_type) (sha3_cmp: sha3_cmp_type),
    mload_cmp_snd mload_cmp ->
    sload_cmp_snd sload_cmp ->
    sha3_cmp_snd sha3_cmp ->
    forall d e1 e2 instk_height ops stk mem strg ctx,
      length stk = instk_height ->
      sexp_cmp d e1 e2 instk_height ops mload_cmp sload_cmp sha3_cmp = true ->
      exists v,
        eval_sexpr e1 stk mem strg ctx ops = Some v /\
          eval_sexpr e2 stk mem strg ctx ops = Some v.
Proof.
  intros mload_cmp sload_cmp sha3_cmp H_mload_cmp H_sload_cmp H_sha3_cmp.
  induction d as [|d' IHd'].
  - intros e1 e2 instk_height ops stk mem strg ctx H_len_stk H_sexp_cmp.
    simpl in H_sexp_cmp.
    discriminate H_sexp_cmp.
  - intros e1 e2 instk_height ops stk mem strg ctx H_len_stk H_sexp_cmp.
    destruct e1 eqn:E_e1; destruct e2 eqn:E_e2; try discriminate.

    (* SExpr_Val *)
    + simpl in H_sexp_cmp.
      apply weqb_true_iff in H_sexp_cmp.
      simpl.
      rewrite <- H_sexp_cmp.
      exists val.
      split; reflexivity.

    (* SExpr_InStkVar *)
    + simpl in H_sexp_cmp.
      pose proof andb_prop (var =? var0) ((var <? instk_height) && (var0 <? instk_height)) H_sexp_cmp as [H_sexp_cmp_1 H_sexp_cmp_2].
      pose proof andb_prop (var <? instk_height) (var0 <? instk_height) H_sexp_cmp_2 as [H_sexp_cmp_3 H_sexp_cmp_4].
      apply Nat.eqb_eq in H_sexp_cmp_1.
      rewrite <- H_sexp_cmp_1.
      simpl. 
      apply Nat.ltb_lt in H_sexp_cmp_3.
      rewrite <- H_len_stk in H_sexp_cmp_3.
      pose proof (nth_error_ok EVMWord stk var H_sexp_cmp_3) as H_nth_error_ok.
      destruct H_nth_error_ok as [v H_nth_error_ok].
      rewrite H_nth_error_ok.
      exists v.
      split; reflexivity.
      
    (* SExpr_Op *)
    + simpl in H_sexp_cmp.
      destruct (label =?i label0) eqn:E_label_label0; try discriminate.
      apply eqb_stack_op_instr_eq in E_label_label0 as E_label_label0_eq.
      rewrite <- E_label_label0_eq.
      destruct (ops label) eqn:E_ops_label.
      destruct ((length args =? n) && (length args0 =? n)) eqn:E_len_args_and_args0; try discriminate.
      pose proof andb_prop (length args =? n) (length args0 =? n) E_len_args_and_args0 as [H_len_args H_len_args0].
      apply Nat.eqb_eq in H_len_args as H_len_args_eq.
      apply Nat.eqb_eq in H_len_args0 as H_len_args0_eq.

      destruct (fold_right_two_lists (fun e1 e2 : sexpr => sexp_cmp d' e1 e2 instk_height ops mload_cmp sload_cmp sha3_cmp) args args0) eqn:E_fldr.

      (* normal case, without commutativity *)
      * simpl.
        rewrite E_ops_label.
        rewrite H_len_args.
        rewrite H_len_args0.
        
        assert(H_map_op:
                forall args1 args2,
                  fold_right_two_lists (fun e1 e2 : sexpr => sexp_cmp d' e1 e2 instk_height ops mload_cmp sload_cmp sha3_cmp) args1 args2 = true
                  ->
                    exists l,
                      map_option (fun fsv' : sexpr => eval_sexpr fsv' stk mem strg ctx ops) args1 = Some l /\
                      map_option (fun fsv' : sexpr => eval_sexpr fsv' stk mem strg ctx ops) args2 = Some l).

        ++ (* proof of assert starts here *)
          induction args1 as [|a args1'].
          +++ intros args2 H_fldr. simpl in H_fldr. destruct args2; try discriminate. simpl. exists []. split; reflexivity.
          +++ intros args2 H_fldr. destruct args2; try discriminate.
              simpl in H_fldr.
              destruct (sexp_cmp d' a s instk_height ops mload_cmp sload_cmp sha3_cmp) eqn:E_sexp_cmp_a_s; try discriminate.

              pose proof (IHd' a s instk_height ops stk mem strg ctx H_len_stk E_sexp_cmp_a_s) as IHd'_0.
              destruct IHd'_0 as [v [IHd'_0_0 IHd'_0_1]].

              pose proof (IHargs1' args2 H_fldr) as IHargs1'_0.
              destruct IHargs1'_0 as [l [IHargs1'_0_0 IHargs1'_0_1]].
              unfold map_option.
              repeat rewrite <- map_option_ho.
              rewrite IHd'_0_0.
              rewrite IHd'_0_1.
              rewrite IHargs1'_0_0.
              rewrite IHargs1'_0_1.
              exists (v :: l).
              split; reflexivity.
        (* proof of assert end here *)

        ++ pose proof (H_map_op args args0 E_fldr) as H_map_op_0.
           destruct H_map_op_0 as [l [H_map_op_0_0 H_map_op_0_1]].
           rewrite H_map_op_0_0.
           rewrite H_map_op_0_1.
           exists (f ctx l).
           split; reflexivity.
              

      (* the case of commutative operations *)
      * destruct H_comm as [H_f_is_Comm|] eqn:E_H_comm ; try discriminate.
        destruct args as [|a1 args']; try discriminate.
        destruct args' as [|a2 args'']; try discriminate.
        destruct args''; try discriminate.
        destruct args0 as [|b1 args0']; try discriminate.
        destruct args0' as [|b2 args0'']; try discriminate.
        destruct args0''; try discriminate.
        
        apply andb_prop in H_sexp_cmp as [H_sexp_cmp_1 H_sexp_cmp_2].

        pose proof (IHd' a1 b2 instk_height ops stk mem strg ctx H_len_stk H_sexp_cmp_1) as H_sexp_cmp_1_0.
        destruct H_sexp_cmp_1_0 as [v1 [H_sexp_cmp_1_0 H_sexp_cmp_1_1]].

        pose proof (IHd' a2 b1 instk_height ops stk mem strg ctx H_len_stk H_sexp_cmp_2) as H_sexp_cmp_2_0.
        destruct H_sexp_cmp_2_0 as [v2 [H_sexp_cmp_2_0 H_sexp_cmp_2_1]].


        simpl.
        rewrite E_ops_label.
 
        unfold length in H_len_args_eq.
        rewrite <- H_len_args_eq.
        rewrite H_sexp_cmp_1_0.
        rewrite H_sexp_cmp_1_1.
        rewrite H_sexp_cmp_2_0.
        rewrite H_sexp_cmp_2_1.

        unfold commutative_op in H_f_is_Comm.
        rewrite H_f_is_Comm with (a:=v1)(b:=v2).

        exists (f ctx [v2; v1]).
        split; reflexivity.

    (* SExpr_PUSHTAG *)
    + simpl in H_sexp_cmp.
      apply N.eqb_eq in H_sexp_cmp.
      rewrite <- H_sexp_cmp.
      simpl.
      exists (get_tags_ctx ctx v).
      split; reflexivity.

    (* SExpr_MLOAD *)
    + simpl in H_sexp_cmp.
      destruct (sexp_cmp d' s s0 instk_height ops mload_cmp sload_cmp sha3_cmp) eqn:E_sexp_cmp_s_s0; try discriminate.
      pose proof (IHd' s s0 instk_height ops stk mem strg ctx H_len_stk E_sexp_cmp_s_s0) as IHd'_0.
      destruct IHd'_0 as [v [IHd'_0 IHd'_1]]. 

      unfold mload_cmp_snd in H_mload_cmp.
      pose proof (H_mload_cmp d' s smem smem0 instk_height ops H_sexp_cmp stk mem strg ctx v H_len_stk IHd'_0) as H_mload_cmp_0.
      
      destruct H_mload_cmp_0 as [mem1 [mem2 [mem_updates1 [mem_updates2 [H_mload_cmp_1_0 [H_mload_cmp_1_1 [H_mload_cmp_1_2 [H_mload_cmp_1_3 H_mload_cmp_1_4]]]]]]]].

      simpl.

      rewrite IHd'_0.
      rewrite IHd'_1.
      
      rewrite H_mload_cmp_1_0.
      rewrite H_mload_cmp_1_1.
      rewrite H_mload_cmp_1_2.
      rewrite H_mload_cmp_1_3.
      rewrite H_mload_cmp_1_4.

      exists (mload mem2 v).

      split; reflexivity. 



    (* SExpr_SLOAD *)
    + simpl in H_sexp_cmp.
      destruct (sexp_cmp d' s s0 instk_height ops mload_cmp sload_cmp sha3_cmp) eqn:E_sexp_cmp_s_s0; try discriminate.
      pose proof (IHd' s s0 instk_height ops stk mem strg ctx H_len_stk E_sexp_cmp_s_s0) as IHd'_0.
      destruct IHd'_0 as [v [IHd'_0 IHd'_1]]. 

      unfold sload_cmp_snd in H_sload_cmp.
      pose proof (H_sload_cmp d' s sstrg sstrg0 instk_height ops H_sexp_cmp stk mem strg ctx v H_len_stk IHd'_0) as H_sload_cmp_0.
      
      destruct H_sload_cmp_0 as [strg1 [strg2 [strg_updates1 [strg_updates2 [H_mload_cmp_1_0 [H_mload_cmp_1_1 [H_mload_cmp_1_2 [H_mload_cmp_1_3 H_mload_cmp_1_4]]]]]]]].

      simpl.

      rewrite IHd'_0.
      rewrite IHd'_1.
      
      rewrite H_mload_cmp_1_0.
      rewrite H_mload_cmp_1_1.
      rewrite H_mload_cmp_1_2.
      rewrite H_mload_cmp_1_3.
      rewrite H_mload_cmp_1_4.

      exists (sload strg2 v).

      split; reflexivity. 

    (* SExpr_SHA3 *)
    + simpl in H_sexp_cmp.
      destruct (sexp_cmp d' s1 s3 instk_height ops mload_cmp sload_cmp sha3_cmp) eqn:E_sexp_cmp_s1_s3; try discriminate.
      destruct (sexp_cmp d' s2 s4 instk_height ops mload_cmp sload_cmp sha3_cmp) eqn:E_sexp_cmp_s2_s4; try discriminate.

      pose proof (IHd' s1 s3 instk_height ops stk mem strg ctx H_len_stk E_sexp_cmp_s1_s3) as IHd'_0.
      destruct IHd'_0 as [v1 [IHd'_0 IHd'_1]]. 

      pose proof (IHd' s2 s4 instk_height ops stk mem strg ctx H_len_stk E_sexp_cmp_s2_s4) as IHd'_3.
      destruct IHd'_3 as [v2 [IHd'_3 IHd'_4]]. 

      unfold sha3_cmp_snd in H_sha3_cmp.
      pose proof (H_sha3_cmp d' s1 s2 smem smem0 instk_height ops H_sexp_cmp stk mem strg ctx v1 v2 H_len_stk IHd'_0 IHd'_3) as H_sha3_cmp_0.
      
      destruct H_sha3_cmp_0 as [mem1 [mem2 [mem_updates1 [mem_updates2 [H_mload_cmp_1_0 [H_mload_cmp_1_1 [H_mload_cmp_1_2 [H_mload_cmp_1_3 H_mload_cmp_1_4]]]]]]]].

      simpl.

      rewrite IHd'_0.
      rewrite IHd'_1.
      rewrite IHd'_3.
      rewrite IHd'_4.
      
      rewrite H_mload_cmp_1_0.
      rewrite H_mload_cmp_1_1.
      rewrite H_mload_cmp_1_2.
      rewrite H_mload_cmp_1_3.
      rewrite H_mload_cmp_1_4.

      exists (get_keccak256_ctx ctx (wordToNat v2) (mload' mem2 v1 (wordToNat v2))).

      split; reflexivity.
Qed.

    

Lemma flat_sstack_cmp_snd:
  forall (mload_cmp: mload_cmp_type) (sload_cmp: sload_cmp_type) (sha3_cmp: sha3_cmp_type),
    mload_cmp_snd mload_cmp ->
    sload_cmp_snd sload_cmp ->
    sha3_cmp_snd sha3_cmp ->
    forall d fsst1 fsst2 ops stk mem strg ctx,
      flat_sstack_cmp d fsst1 fsst2 ops mload_cmp sload_cmp sha3_cmp = true ->
      exists l,
        eval_flat_sstack stk mem strg ctx fsst1 ops = Some l /\
        eval_flat_sstack stk mem strg ctx fsst2 ops = Some l.
Proof.
  intros mload_cmp sload_cmp sha3_cmp H_mload_cmp H_sload_cmp H_sha3_cmp.
  

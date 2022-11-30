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

Require Import FORVES.symbolic_execution.
Import SymbolicExecution.

Require Import FORVES.symbolic_execution.
Import SymbolicExecution.

Require Import FORVES.symbolic_state_eval.
Import SymbolicStateEval.

Require Import FORVES.flat_symbolic_state.
Import FlatSymbolicState.

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Module SymbolicExecutionSoundness.


Lemma eq_execution_states_refl:
  forall (st: state), eq_execution_states st st.
Proof.
  unfold eq_execution_states.
  intros.
  rewrite H0. rewrite <- H.
  rewrite H2. rewrite <- H1.
  rewrite H4. rewrite <- H3.
  rewrite H6. rewrite <- H5.
  intuition. (* this proves the stack and context equivalence *)
  + unfold eq_memory. intro. reflexivity.
  + unfold eq_storage. intro. reflexivity.
Qed.


(*

A symbolic state sst is equivalent to a symbolic state st, wrt to an
initial state init_st, if when instantiating sst using init_st we get
st' that is equivalent to st. We use eq_execution_states and not '='
because memory/storage need functional equivalence

*)

Definition st_is_instance_of_sst (init_st st: state) (sst: sstate) (ops: stack_op_instr_map) : Prop :=
  exists (st': state),
    eval_sstate init_st sst ops = Some st' /\
    eq_execution_states st st'.
  
(*

A state transformer _tr_ and a symbolic state transformer _str_ are
equivalent, if when _str_ transforms _sst_ to _sst'_, then for any
initial state _init_st_ and a state _st_ such that _st_ is an instance
of _sst_ wrt _init_st_, _tr_ moves from _st_ to _st'_ such that _st'_
is an instance of _sst'_ wrt _init_st_.

*)

Definition snd_state_transformer ( tr : state -> stack_op_instr_map -> option state ) (symtr : sstate ->  stack_op_instr_map -> option sstate )  : Prop :=
  forall (sst sst': sstate) (ops : stack_op_instr_map),
    symtr sst ops = Some sst' ->
    forall (init_st st: state), st_is_instance_of_sst init_st st sst ops ->
    exists (st': state), tr st ops = Some st' /\ st_is_instance_of_sst init_st st' sst' ops.


(* applying eval_sstack_val on Val w returns Some w *)
Lemma eval_sstack_val_Val:
forall (w: EVMWord) (stk: stack) (mem: memory) (strg: storage) (ctx: context)  (bs: sbindings) (ops: stack_op_instr_map),
    eval_sstack_val (Val w) stk mem strg ctx bs ops = Some w.
Proof.
  intros.
  destruct bs; unfold eval_sstack_val; reflexivity.
Qed.

(* applying eval_sstack_val on InStackVar i returns (nth_error stk i) *)
Lemma eval_sstack_val_InStackVar:
forall (i:nat) (sst: sstate) (stk: stack) (mem: memory) (strg: storage) (ctx: context) (bs: sbindings) (ops: stack_op_instr_map),
    eval_sstack_val (InStackVar i) stk mem strg ctx bs ops = nth_error stk i.
Proof.
  intros.
  destruct bs; unfold eval_sstack_val; destruct (nth_error stk i); reflexivity; reflexivity.
Qed.


Lemma eval_sstack'_w:
  forall (w : EVMWord) (sstk: sstack) (stk stk': stack) (mem: memory) (strg: storage) (ctx: context) (sb: sbindings) (ops: stack_op_instr_map),
    eval_sstack' sstk stk mem strg ctx sb ops = Some stk' ->
    eval_sstack' ((Val w)::sstk) stk mem strg ctx sb ops = Some (w::stk').
Proof.
  intros w sstk stk stk' mem strg ctx sb ops H_eval_sstack'_stk.
  unfold eval_sstack'.
  unfold fold_right_option.
  rewrite eval_sstack_val_Val.
  unfold eval_sstack' in H_eval_sstack'_stk.
  unfold fold_right_option in H_eval_sstack'_stk. 
  rewrite H_eval_sstack'_stk.
  reflexivity.
Qed.


Lemma eval_sstate_w:
  forall (w : EVMWord) (sst : sstate) (st st': state) (ops: stack_op_instr_map),
    eval_sstate st sst ops = Some st' ->
    eval_sstate st (set_stack_sst sst ((Val w)::(get_stack_sst sst))) ops = Some (set_stack_st st' (w::(get_stack_st st'))).
Proof.
  intros.
  destruct sst eqn:Esst.
  destruct st eqn:Est.
  unfold eval_sstate.
  simpl.
  unfold eval_sstate in H.
  simpl in H.
  unfold eval_sstack in H.
  simpl in H.
  destruct (length stk =? instk_height) eqn:El.
  - destruct sm eqn:Esm.
    destruct (eval_sstack' sstk stk mem strg ctx map0 ops) eqn:Eevs'.
    + pose proof (eval_sstack'_w w sstk stk s mem strg ctx map0 ops Eevs').
      unfold eval_sstack.
      unfold get_instk_height_sst.
      rewrite El.
      unfold get_smap_sst.
      unfold get_stack_sst.
      rewrite H0.
      destruct (eval_smemory stk mem strg ctx (SymExState instk_height sstk smem sstg sctx (SymMap maxid map0)) ops) eqn:Em.
      ++ destruct (eval_sstorage stk mem strg ctx (SymExState instk_height sstk smem sstg sctx (SymMap maxid map0)) ops) eqn:Es.
         +++ unfold eval_smemory in Em.
             unfold get_smap_sst in Em.
             destruct (fold_right_option
           (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx map0 ops))
           (get_memory_sst (SymExState instk_height sstk smem sstg sctx (SymMap maxid map0)))) eqn:Efr1.
             ++++ unfold eval_sstorage in Es.
                  unfold get_smap_sst in Es.
                  destruct (fold_right_option
           (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx map0 ops))
           (get_storage_sst (SymExState instk_height sstk smem sstg sctx (SymMap maxid map0)))) eqn:Efr2.
                  +++++ unfold eval_smemory.
                  unfold get_smap_sst.
                  simpl.
                  simpl in Efr1.
                  rewrite Efr1.
                  unfold eval_sstorage.
                  unfold get_smap_sst.
                  simpl.
                  simpl in Efr2.
                  rewrite Efr2.
                  injection H. intros.
                  rewrite <- H1.
                  simpl.
                  injection Es. intros.
                  injection Em. intros.
                  rewrite H2.
                  rewrite H3.
                  unfold make_st.
                  reflexivity.
                  +++++ discriminate.
             ++++ discriminate.
         +++ discriminate.
      ++ discriminate.
    + discriminate.
  - discriminate.
Qed.

Search Nat.eqb.
Search list.

(*
Lemma eval_sstack'_len:
    forall (sstk: sstack) (stk stk': stack) (mem: memory) (strg: storage) (ctx: context) (sb: sbindings) (ops: stack_op_instr_map),
    eval_sstack' sstk stk mem strg ctx sb ops = Some stk' ->
    length sstk = length stk'.
Proof.
  intros.
  induction sstk as [|sv sstk' IHsstk'].
  + simpl in H. injection H. intros. rewrite <- H0. reflexivity.
  + unfold eval_sstack'  in H.
 *)

Lemma st_is_instance_of_sst_stk_len:
  forall (init_st st: state) (sst: sstate) (ops: stack_op_instr_map),
         st_is_instance_of_sst init_st st sst ops ->
         length (get_stack_sst sst) = length (get_stack_st st) /\
         length (get_stack_st init_st) = get_instk_height_sst sst.
Proof.
  intros.
  unfold st_is_instance_of_sst in H.
  destruct H as [st'].
  destruct H.
  unfold eval_sstate in H. unfold eval_sstack in H.
  destruct (length (get_stack_st init_st) =? get_instk_height_sst sst) eqn:E0.
  + apply beq_nat_true in E0.
    split.
    ++ destruct (get_smap_sst sst).
       destruct (eval_sstack' (get_stack_sst sst) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) 
                   (get_context_st init_st) map0 ops) eqn:Levs'.
       +++ destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) eqn:E1.
           ++++ destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) eqn:E2.
                +++++ injection H.
                intros.
                unfold eval_sstack' in Levs'.
                apply fold_right_option_len in Levs'.
                destruct st eqn:Est.
                destruct init_st eqn:Eist.
                unfold eq_execution_states in H0.
                simpl.
                rewrite <- H1 in H0.
                simpl in H0. 
                destruct H0 with (stk1:=stk)(stk2:=s)(mem1:=mem)(mem2:=m)(strg1:=strg)(strg2:=s0)(ctx1:=ctx)(ctx2:=ctx0).
                reflexivity. reflexivity. reflexivity. reflexivity. reflexivity.
                reflexivity. reflexivity. reflexivity.
                unfold eq_stack in H2. rewrite H2. apply Levs'.
                +++++ discriminate.
           ++++ discriminate.
       +++ discriminate.
    ++ apply E0.
  + discriminate.
Qed.

Lemma push_snd:
  forall w, snd_state_transformer (push_c w) (push_s w).
Proof.
intro w.
  unfold snd_state_transformer.
  intros.
  pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H0) as H1.
  destruct H1.
  unfold push_s in H.
  unfold push in H.
  destruct (length (get_stack_sst sst) <? StackSize) eqn:E0.
  -  exists (set_stack_st st (w::(get_stack_st st))).
     unfold push_c.
     unfold push.
     rewrite <- H1.
     rewrite E0.
     split.
     + reflexivity.
     + unfold st_is_instance_of_sst in H0.
       destruct H0 as [st'].
       destruct H0.
       injection H. intros.
       unfold st_is_instance_of_sst.
       exists (set_stack_st st' (w::(get_stack_st st'))).
       split.
       ++ pose proof (eval_sstate_w w sst init_st st' ops H0).
          rewrite H4 in H5. rewrite H5.
          reflexivity.
       ++ destruct st eqn:Est.
          destruct st' eqn:Est'.
          simpl.
          unfold eq_execution_states in H3.
          simpl in H3.
          pose proof (H3 stk stk0 mem mem0 strg strg0 ctx ctx0).
          destruct H5.
          reflexivity.
          reflexivity.
          reflexivity.
          reflexivity.
          reflexivity.
          reflexivity.
          reflexivity.
          reflexivity.
          destruct H6.
          destruct H7.
          unfold eq_execution_states. simpl. intros.
          rewrite H9.
          rewrite H10.
          rewrite H11.
          rewrite H12.
          rewrite H13.
          rewrite H14.
          rewrite H15.
          rewrite H16.
          split.
          +++ unfold eq_stack.
              unfold eq_stack in H5.
              rewrite H5.
              reflexivity.
          +++ split. apply H6. split. apply H7. apply H8.
  - discriminate.
Qed.  

Lemma pop_snd:
  snd_state_transformer pop_c pop_s.       
Proof.
Admitted.

Lemma dup_snd:
  forall k, snd_state_transformer (dup_c k) (dup_s k).       
Proof.
Admitted.

Lemma swap_snd:
  forall k, snd_state_transformer (swap_c k) (swap_s k).
Proof.
Admitted.

Lemma sload_snd:
  snd_state_transformer sload_c sload_s.
Proof.
Admitted.

Lemma sstore_snd:
  snd_state_transformer sstore_c sstore_s.
Proof.
Admitted.

Lemma mload_snd:
  snd_state_transformer mload_c mload_s.
Proof.
Admitted.

Lemma mstore8_snd:
  snd_state_transformer mstore8_c mstore8_s.
Proof.
Admitted.

Lemma mstore_snd:
  snd_state_transformer mstore_c mstore_s.
Proof.
Admitted.

Lemma sha3_snd:
  snd_state_transformer sha3_c sha3_s.
Proof.
Admitted.

Lemma exec_stack_op_intsr_snd:
  forall label, snd_state_transformer (exec_stack_op_intsr_c label) (exec_stack_op_intsr_s label).
Proof.
Admitted.


Lemma evm_exec_instr_snd:
  forall (i : instr),
    snd_state_transformer (evm_exec_instr_c i) (evm_exec_instr_s i).
Proof.
  destruct i.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply push_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply pop_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply dup_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply swap_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply mload_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply mstore_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply mstore8_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply sload_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply sstore_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply sha3_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply sha3_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply exec_stack_op_intsr_snd.
Qed.


(* evm_exec_block_s and evm_exec_block_c are sound transformers -- when applied to p *)
Lemma evm_exec_block_snd:
  forall (p : block),
    snd_state_transformer (evm_exec_block_c p) (evm_exec_block_s p).
Proof.
  unfold snd_state_transformer.
  induction p as [| i p' IHp']. (* induction of the length of the block p *)

  - simpl. (* execute the empty block -- in several places *)
    intros sst sst' ops H_sexec_nil.
    intros init_st st H_st_inst_sst.
    exists st. (* we use st since p=[], i.e., we don't execute anything *)
    split. (* split the conjuction into two goals *)
    + reflexivity.
    + injection H_sexec_nil as H_sst_eq_sst' (* infer that sst and sst' are equal *).
      rewrite <- H_sst_eq_sst'. (* replace sst' by sst in the goal *)
      apply H_st_inst_sst. (* the goal is the assumption H_st_inst_sst *)

  - intros sst sst' ops H_sexec_ip' init_st st H_st_inst_sst.

    (* unfold the symbolic execution of i::p' and fold the recursive call *)
    unfold evm_exec_block_s in H_sexec_ip'. 
    fold evm_exec_block_s in H_sexec_ip'.

    (* we split on the result of symbolically executiing i: Some sst'' or None *)
    destruct (evm_exec_instr_s i sst ops) as [sst''|] eqn:E_evm_exec_instr_s.

    (* the case of Some sst'' *)
    +
      (* derive relation between execution and symbolic execution of i *)
      apply evm_exec_instr_snd with (i:=i) in E_evm_exec_instr_s as E_evm_exec_instr_s_0.
      pose proof (E_evm_exec_instr_s_0 init_st st H_st_inst_sst) as E_evm_exec_instr_c.

      (* choose a value for exists st' and split the resulting conjunction *)
      destruct E_evm_exec_instr_c as [st' E_evm_exec_instr_c_st']. 
      destruct E_evm_exec_instr_c_st' as [E_evm_exec_instr_c_st'_left E_evm_exec_instr_c_st'_right].
      
      (* apply the induction hypothesis for symbolically exexuting p'
      from sst'' (the result of executing i) to st'. Use H_sexec_ip'
      for the premise that symbolic execution of p' succeeds *)
      pose proof (IHp' sst'' sst' ops H_sexec_ip') as IHp'_sst''_sst'.

      (* Now we derive the concrete execution of p' and solut the resulting conjunction *)
      pose proof (IHp'_sst''_sst' init_st st' E_evm_exec_instr_c_st'_right) as H_evm_exec_block_c_p'.
      destruct H_evm_exec_block_c_p' as [st'' H_evm_exec_block_c_p'_st''].
      destruct H_evm_exec_block_c_p'_st'' as [H_evm_exec_block_c_p'_st''_left H_evm_exec_block_c_p'_st''_right].

      (* choose a value for the existential variable in the goal and
      split the conjunction into two goals*)
      exists st''.
      split.
      
      * unfold evm_exec_block_c. (* unfold execution of i::p' *)
        rewrite E_evm_exec_instr_c_st'_left. (* use the assumption on the result of executing i *)
        fold evm_exec_block_c. (* fold the recursive call *)
        apply H_evm_exec_block_c_p'_st''_left. (* the goal is an assumption *)
        
      * apply H_evm_exec_block_c_p'_st''_right. (* the goal is an assumption *)

    (* The case of None *)
    + discriminate H_sexec_ip'.
Qed.



(* The instk_height of the symbolic state (gen_empty_sstate instk_height) is instk_height *)
Lemma instkh_gen_empty_instkh:
  forall instk_height,
    get_instk_height_sst (gen_empty_sstate instk_height) = instk_height.
Proof.
  intros. reflexivity.
Qed.

Search sub.

(* when i < length l, the access (nth_error l i) suceeds *)
Lemma nth_error_ok' :
  forall (T: Type) (l : list T) (i : nat),
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

(* if m<n then 0<n-m *)
Lemma lt_minus_lt_0: forall (n m: nat),
m < n -> 0 < (n - m).
Proof.
  intuition.
(*
intros n.
induction n as [| n' IH].
- intros m Hm_lt_0. 
  pose proof (Nat.nlt_0_r m).
  contradiction.
- intros m Hm_lt_sn.
  destruct m as [|m'] eqn: eq_m.
  + rewrite -> Nat.sub_0_r. assumption.
  + pose proof (lt_S_n m' n' Hm_lt_sn) as eq_m'_lt_n'.
    pose proof (IH m' eq_m'_lt_n') as IHc.
    rewrite -> Nat.sub_succ.
    assumption.
*)
Qed.

(* when i<n, (n-(i+1))+1=n-i *)
Lemma succ_minus_succ: forall (n i: nat),
i < n -> S (n - S i) = n - i.
Proof.
  intuition.
(*
intros n i H_i_lt_n.
rewrite -> Nat.sub_succ_r.
pose proof (lt_minus_lt_0 n i H_i_lt_n) as Hni_gt_0.
pose proof (Nat.succ_pred_pos (n - i) Hni_gt_0) as Hs_pred_n_i.
assumption.
*)
Qed.

(* if the i-th element is v, skipping i element we get v::(skipping i+1 elements) *)
Lemma skipn_nth:
  forall (T: Type) (i: nat) (l: list T) (v: T),
    nth_error l i = Some v -> 
    skipn i l = v :: (skipn (S i) l).
Proof.
  intros T i. induction i as [| i' IH].
  - intros l v Hnth_error.
    destruct l as [|h t] eqn: eq_l.
    + simpl in Hnth_error. discriminate.
    + simpl in Hnth_error. simpl.
      injection Hnth_error. intros eq_h_v. rewrite -> eq_h_v.
      reflexivity.
  - intros l v Hnth_error.
    destruct l as [|h t] eqn: eq_l.
    + simpl in Hnth_error. discriminate.
    + simpl in Hnth_error.
      rewrite -> skipn_cons.
      rewrite -> skipn_cons.
      pose proof (IH t v Hnth_error).
      assumption.
Qed.

Lemma gen_empty_sstate_eval_sstack'_snd:
  forall (i n : nat) (stk: stack) (mem: memory) (strg: storage) (ctx: context)  (bs: sbindings) (ops : stack_op_instr_map),
    length stk = n ->
    i <= n ->
    n >= 0 ->
    eval_sstack' (List.map InStackVar (seq (n-i) i)) stk mem strg ctx bs ops = Some (skipn (n-i) stk).
Proof.
  intros.
  induction i as [|i' IHi'].
  - simpl. rewrite -> Nat.sub_0_r. rewrite <- H. rewrite -> skipn_all. reflexivity.
  - destruct bs.
    simpl.
    pose proof (gt_Sn_O i') as eq_Si_gt_0.
    pose proof (Nat.sub_lt n (S i') H0 eq_Si_gt_0) as eq_si_n.
    rewrite <- H in eq_si_n at 2.
    pose proof (@nth_error_ok' EVMWord stk (n - S i') eq_si_n) as
      eq_nth_error_value_ex.
    destruct eq_nth_error_value_ex. rewrite H2.
  pose proof (succ_minus_succ n i' H0) as eq_n_i_succ.
  rewrite eq_n_i_succ.
  pose proof (le_Sn_le i' n H0) as eq_i'_leq_n.
  apply IHi' in eq_i'_leq_n.
  rewrite eq_i'_leq_n.
  pose proof (skipn_nth EVMWord (n - (S i')) stk x H2) as eq_skipn_x.
  rewrite eq_skipn_x.
  rewrite eq_n_i_succ. reflexivity.
  (* this is repetition of the above, should be rewritten using ; *)
    simpl.
    pose proof (gt_Sn_O i') as eq_Si_gt_0.
    pose proof (Nat.sub_lt n (S i') H0 eq_Si_gt_0) as eq_si_n.
    rewrite <- H in eq_si_n at 2.
    pose proof (@nth_error_ok' EVMWord stk (n - S i') eq_si_n) as
      eq_nth_error_value_ex.
    destruct eq_nth_error_value_ex. rewrite H2.
  pose proof (succ_minus_succ n i' H0) as eq_n_i_succ.
  rewrite eq_n_i_succ.
  pose proof (le_Sn_le i' n H0) as eq_i'_leq_n.
  apply IHi' in eq_i'_leq_n.
  rewrite eq_i'_leq_n.
  pose proof (skipn_nth EVMWord (n - (S i')) stk x H2) as eq_skipn_x.
  rewrite eq_skipn_x.
  rewrite eq_n_i_succ. reflexivity.  
Qed.


Lemma gen_empty_sstate_eval_sstack_snd:
  forall (n : nat) (stk: stack) (mem: memory) (strg: storage) (ctx: context) (sst: sstate) (sstk: sstack) (ops : stack_op_instr_map),
    length stk = n ->
    sst = (gen_empty_sstate n) ->
    sstk = (get_stack_sst sst) -> 
    eval_sstack stk mem strg ctx sst ops = Some stk.
Proof.
  intros.
  unfold eval_sstack.
  rewrite H0.
  rewrite instkh_gen_empty_instkh. rewrite H. rewrite Nat.eqb_refl.
  destruct (get_smap_sst (gen_empty_sstate n)).
  rewrite <- H0.
  rewrite <- H1.
  pose proof (gen_empty_sstate_eval_sstack'_snd n n stk mem strg ctx map0 ops).
  apply H2 in H.
  unfold gen_empty_sstate in H0. unfold make_sst in H0. rewrite H0 in H1. simpl in H1. rewrite H1.
  rewrite Nat.sub_diag in H. unfold skipn in H. apply H. apply le_n.
  destruct n.
  + apply le_n.
  + apply le_0_n.
Qed.

Lemma gen_empty_sstate_eval_smemory_snd:
  forall (stk: stack) (mem: memory) (strg: storage) (ctx: context) (instk_height: nat) (sst: sstate) (ops : stack_op_instr_map),
    sst = gen_empty_sstate instk_height ->
    eval_smemory stk mem strg ctx sst ops = Some mem.
Proof.
  intros.
  
  unfold gen_empty_sstate in H. unfold make_sst in H. unfold eval_smemory.
  unfold get_smap_sst. rewrite H. unfold empty_smap.
  unfold get_memory_sst. unfold empty_smemory.
  unfold fold_right_option.
  unfold eval_common.EvalCommon.update_memory. reflexivity.
Qed.

Lemma gen_empty_sstate_eval_sstorage_snd:
  forall (stk: stack) (mem: memory) (strg: storage) (ctx: context) (instk_height: nat) (sst: sstate) (ops : stack_op_instr_map),
    sst = gen_empty_sstate instk_height ->
    eval_sstorage stk mem strg ctx sst ops = Some strg.
Proof.
  intros.
  unfold gen_empty_sstate in H. unfold make_sst in H. unfold eval_sstorage.
  unfold get_smap_sst. rewrite H. unfold empty_smap.
  unfold get_storage_sst. unfold empty_sstorage.
  unfold fold_right_option.
  unfold eval_common.EvalCommon.update_storage. reflexivity.
Qed.

(* An initial symbolic state is equivalent to any state, as long as
they refer to a stack with the same size *)
Lemma gen_empty_sstate_snd:
  forall (st: state) (instk_height: nat) (sst: sstate) (ops : stack_op_instr_map),
    length (get_stack_st st) = instk_height ->
    sst = gen_empty_sstate instk_height ->
    st_is_instance_of_sst st st sst ops.
Proof.
  intros.
  unfold st_is_instance_of_sst.
  exists st.
  split.
  + unfold eval_sstate.
    assert(H1:=H0).
    assert(H2:=H0).
    pose proof (gen_empty_sstate_eval_sstack_snd instk_height (get_stack_st st) (get_memory_st st) (get_storage_st st) (get_context_st st) sst (get_stack_sst sst)) ops as E.
    apply E in H0.
    apply E in H. rewrite H.
    apply gen_empty_sstate_eval_smemory_snd with (stk:=(get_stack_st st))(mem:=(get_memory_st st))(strg:=(get_storage_st st))(ctx:=(get_context_st st))(ops:=ops) in H1. rewrite H1.
    apply gen_empty_sstate_eval_sstorage_snd with (stk:=(get_stack_st st))(mem:=(get_memory_st st))(strg:=(get_storage_st st))(ctx:=(get_context_st st))(ops:=ops) in H2. rewrite H2.
    destruct st. reflexivity.
    apply H1.
    reflexivity. apply H. reflexivity.
   + apply eq_execution_states_refl.
Qed.

Theorem symbolic_exec_snd:
  forall (p : block) (instk_height : nat) (sst : sstate) (ops : stack_op_instr_map),
    evm_sym_exec p instk_height ops = Some sst -> 
    forall (st : state), 
      length (get_stack_st st) = instk_height -> 
      exists (st': state),
        evm_exec_block_c p st ops = Some st' /\
          st_is_instance_of_sst st st' sst ops. 
Proof.
  intros.
  unfold evm_sym_exec in H.
  apply evm_exec_block_snd in H.
  apply H.
  apply gen_empty_sstate_snd with (instk_height:=instk_height)(sst:=(gen_empty_sstate instk_height)).
  + apply H0.
  + reflexivity.                    
Qed.


End SymbolicExecutionSoundness.

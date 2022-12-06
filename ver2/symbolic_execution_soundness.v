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
  intros.
  unfold eq_execution_states.
  intuition. (* this proves the stack and context equivalence *)
  + unfold eq_memory. intro. reflexivity.
  + unfold eq_storage. intro. reflexivity.
Qed.


Lemma eq_execution_states_ext:
  forall (st st': state),
    eq_execution_states st st' -> st = st'.
Proof.
  intros st st' H_eq.
  destruct st eqn:E_st.
  destruct st' eqn:E_st'.
  unfold eq_execution_states in H_eq.
  simpl in H_eq.
  destruct H_eq as [H_eq_stack [H_eq_mem [H_eq_strg H_eq_ctx]]].

  unfold eq_stack in H_eq_stack.
  rewrite H_eq_stack.
  unfold eq_memory in H_eq_mem.
  apply functional_extensionality in H_eq_mem.
  rewrite H_eq_mem.
  unfold eq_storage in H_eq_strg.
  apply functional_extensionality in H_eq_strg.
  rewrite H_eq_strg.
  unfold eq_context in H_eq_ctx.
  rewrite H_eq_ctx.
  reflexivity.
Qed.

Lemma eq_execution_states_stack_len:
  forall st st',
    eq_execution_states st st' ->
    length (get_stack_st st) = length (get_stack_st st').
Proof.
  intros st st' H_eq_states.
  apply eq_execution_states_ext in H_eq_states.
  rewrite H_eq_states.
  reflexivity.
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


(* applying eval_sstack_val on (Val w) returns Some w *)
Lemma eval_sstack_val_Val:
forall (w: EVMWord) (stk: stack) (mem: memory) (strg: storage) (ctx: context)  (bs: sbindings) (ops: stack_op_instr_map),
    eval_sstack_val (Val w) stk mem strg ctx bs ops = Some w.
Proof.
  intros.
  destruct bs; reflexivity.
Qed.

(* applying eval_sstack_val on (InStackVar i) returns (nth_error stk i) *)
Lemma eval_sstack_val_InStackVar:
forall (i:nat) (sst: sstate) (stk: stack) (mem: memory) (strg: storage) (ctx: context) (bs: sbindings) (ops: stack_op_instr_map),
    eval_sstack_val (InStackVar i) stk mem strg ctx bs ops = nth_error stk i.
Proof.
  intros.
  destruct bs; unfold eval_sstack_val; destruct (nth_error stk i); reflexivity.
Qed.

(* 
if applying eval_sstack' on sstk return Some stk', then applying it on (Val w)::sstk returns
Some (w::stk')
*)
Lemma eval_sstack'_w:
  forall (w : EVMWord) (sstk: sstack) (stk stk': stack) (mem: memory) (strg: storage) (ctx: context) (sb: sbindings) (ops: stack_op_instr_map),
    eval_sstack' sstk stk mem strg ctx sb ops = Some stk' ->
    eval_sstack' ((Val w)::sstk) stk mem strg ctx sb ops = Some (w::stk').
Proof.
  intros w sstk stk stk' mem strg ctx sb ops H_eval_sstack'_stk.
  unfold eval_sstack'.
  unfold fold_right_option.
  rewrite eval_sstack_val_Val.
  rewrite <- fold_right_option_ho.
  unfold eval_sstack' in H_eval_sstack'_stk.
  rewrite H_eval_sstack'_stk.
  reflexivity.
Qed.

Lemma eval_sstack'_len:
  forall (sstk: sstack) (stk stk': stack) (mem: memory) (strg: storage) (ctx: context) (sb: sbindings) (ops: stack_op_instr_map),
    eval_sstack' sstk stk mem strg ctx sb ops = Some stk' ->
    length sstk = length stk'.
Proof.
  intros sstl stk stk' mem strg ctx sb ops H_eval_sstack'.
  unfold eval_sstack' in H_eval_sstack'.
  apply fold_right_option_len in H_eval_sstack'.
  apply H_eval_sstack'.
Qed.

  
(* changing the symbolic stack does not affect eval_smemory *)
Lemma eval_smemory_preserved_when_sstack_changed:
  forall stk mem strg ctx sst sstk,
    eval_smemory stk mem strg ctx sst =
      eval_smemory stk mem strg ctx (set_stack_sst sst sstk).
Proof.
  intros.
  destruct sst.
  reflexivity.
Qed.

(* changing the symbolic stack does not affect eval_sstorage *)
Lemma eval_sstorage_preserved_when_sstack_changed:
  forall stk mem strg ctx sst sstk,
    eval_sstorage stk mem strg ctx sst =
      eval_sstorage stk mem strg ctx (set_stack_sst sst sstk).
Proof.
  intros.
  destruct sst.
  reflexivity.
Qed.

  
(* Like eval_sstack'_w, but stated on states.  *)
Lemma eval_sstate_w:
  forall (w : EVMWord) (sst : sstate) (st st': state) (ops: stack_op_instr_map),
    eval_sstate st sst ops = Some st' ->
    eval_sstate st (set_stack_sst sst ((Val w)::(get_stack_sst sst))) ops = Some (set_stack_st st' (w::(get_stack_st st'))).
Proof.
  intros w sst st st' ops H_eval_sst.
  unfold eval_sstate in H_eval_sst.
  unfold eval_sstack in H_eval_sst.
  destruct (get_smap_sst sst) as [maxid sb] eqn:E_smap_sst.
  destruct (length (get_stack_st st) =? get_instk_height_sst sst) eqn:E_len.
  2: {discriminate.}. (* the case of false leads to false assumption *)
  destruct (eval_sstack' (get_stack_sst sst) (get_stack_st st) (get_memory_st st) (get_storage_st st) (get_context_st st) sb ops) as [stk|] eqn:E_eval_sstack'.
  2: {discriminate.}. (* the case of None leads to false assumption *)
  unfold eval_sstate.
  unfold eval_sstack.
  rewrite instk_height_preserved_when_updating_stack_sst.
  rewrite E_len.
  rewrite smap_preserved_when_updating_stack_sst.
  rewrite E_smap_sst.
  rewrite set_and_then_get_stack_sst.

  pose proof (eval_sstack'_w w (get_stack_sst sst) (get_stack_st st) stk (get_memory_st st) (get_storage_st st) (get_context_st st) sb ops E_eval_sstack') as H_eval_sstack'_w.
  rewrite H_eval_sstack'_w.
  rewrite <- eval_smemory_preserved_when_sstack_changed.
  rewrite <- eval_sstorage_preserved_when_sstack_changed.

  destruct (eval_smemory (get_stack_st st) (get_memory_st st) (get_storage_st st) (get_context_st st) sst ops).
  2: {discriminate.}.

  destruct (eval_sstorage (get_stack_st st) (get_memory_st st) (get_storage_st st) (get_context_st st) sst ops).
  2: {discriminate.}.

  injection H_eval_sst as H_st'. (* get the value of st' *)
  rewrite <- H_st'. simpl.
  unfold make_st.

  reflexivity.
Qed.


(* when st is an instance of sst wrt to init_st, the length stacks in
st and sst are the same, and (get_instk_height_sst sst) is equal to
the length of the stack in init_st *)
Lemma st_is_instance_of_sst_stk_len:
  forall (init_st st: state) (sst: sstate) (ops: stack_op_instr_map),
         st_is_instance_of_sst init_st st sst ops ->
         length (get_stack_sst sst) = length (get_stack_st st) /\
         length (get_stack_st init_st) = get_instk_height_sst sst.
Proof.
  intros init_st st sst ops H_inst.
  unfold st_is_instance_of_sst in H_inst.
  destruct H_inst as [st' H_inst].
  destruct H_inst as [H_inst_l H_inst_r].
  unfold eval_sstate in H_inst_l.
  unfold eval_sstack in H_inst_l.
  destruct (length (get_stack_st init_st) =? get_instk_height_sst sst) eqn:E_len.
  2: {discriminate.}.
  destruct (get_smap_sst sst) as [maxid sb] eqn:E_smap.
  apply beq_nat_true in E_len.

  destruct (eval_sstack' (get_stack_sst sst) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) 
              (get_context_st init_st) sb ops) as [stk|] eqn:E_eval_sstack'.
  2: {discriminate.}.

  destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [mem|]  eqn:E_eval_smemory.
  2: {discriminate.}.

  destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [strg|]  eqn:E_eval_sstorage.
  2: {discriminate.}.
  split.
  + apply eval_sstack'_len in E_eval_sstack'.
    rewrite E_eval_sstack'.
    apply eq_execution_states_stack_len in H_inst_r.
    rewrite  H_inst_r.
    injection H_inst_l as H_st'.
    rewrite <- H_st'.
    unfold make_st.
    simpl.
    reflexivity.
  + apply E_len.
Qed.
  

(* push_s is a sound symbolic transformer *)
Lemma push_snd:
  forall w, snd_state_transformer (push_c w) (push_s w).
Proof.
  intro w.
  unfold snd_state_transformer.
  intros sst sst' ops H_push_s init_st st H_st_inst_sst.
  pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as H_inst_stk_len.
  destruct H_inst_stk_len as [H_inst_stk_len_l H_inst_stk_len_r].
  unfold push_s in H_push_s.
  unfold push in H_push_s.
  destruct (length (get_stack_sst sst) <? StackSize) eqn:E_stk_len.
  2: {discriminate.}.
  exists (set_stack_st st (w::(get_stack_st st))).
  unfold push_c.
  unfold push.
  rewrite <- H_inst_stk_len_l.
  rewrite E_stk_len.
  split.
  + reflexivity. 
  + injection H_push_s as H_sst'.
    rewrite <- H_sst'.
    unfold st_is_instance_of_sst in H_st_inst_sst.
    destruct H_st_inst_sst as [st' H_st_inst_sst].
    destruct H_st_inst_sst as [H_st_inst_sst_l H_st_inst_sst_r].
    unfold st_is_instance_of_sst.
    exists (set_stack_st st' (w::(get_stack_st st'))).
    split.
    ++ pose proof (eval_sstate_w w sst init_st st' ops  H_st_inst_sst_l) as H_eval_sstate_w.
       apply H_eval_sstate_w.
    ++ apply eq_execution_states_ext in H_st_inst_sst_r.
       rewrite H_st_inst_sst_r.
       apply eq_execution_states_refl.
Qed.

(* push_s is a sound symbolic transformer *)
Lemma pushtag_snd:
  forall v, snd_state_transformer (pushtag_c v) (pushtag_s v).
Proof.
Admitted.

Lemma pop_succ:
  forall init_st st sst ops l,
    st_is_instance_of_sst init_st st sst ops ->
    pop (get_stack_sst sst) = Some l ->
    exists v1 v2 l', (get_stack_sst sst)=v1::l /\ get_stack_st st = v2::l'.
Proof.
  intros.
  unfold pop in H0.
  destruct (get_stack_sst sst) eqn:E_stk_sst.
  discriminate.
  injection H0. intros.
  rewrite H1.
  exists s.
  unfold st_is_instance_of_sst in H.
  destruct H as [st' H].
  destruct H.
  unfold eval_sstate in H.
  unfold eval_sstack in H.
  destruct (length (get_stack_st init_st) =? get_instk_height_sst sst) eqn:E_len.
  2: {discriminate.}.
  destruct (get_smap_sst sst) as [maxid map0] eqn:E_map.
  rewrite E_stk_sst in H.
  simpl in H.
  destruct (eval_sstack_val s (get_stack_st init_st) (get_memory_st init_st)
              (get_storage_st init_st) (get_context_st init_st) map0 ops) in H.
  2: {discriminate.}.
  destruct (eval_sstack' s0 (get_stack_st init_st) (get_memory_st init_st)
            (get_storage_st init_st) (get_context_st init_st) map0 ops) in H.
  2: {discriminate.}.
  destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st) 
              (get_storage_st init_st) (get_context_st init_st) sst ops) in H.
  2: {discriminate.}.
  destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st) 
              (get_storage_st init_st) (get_context_st init_st) sst ops) in H.
  2: {discriminate.}.
  unfold make_st in H.
  injection H. intros.
  unfold eq_execution_states in H2.
  rewrite <- H3 in H2.
  simpl in H2.
  exists e. exists s1.
  split.
  + reflexivity.
  + destruct H2.
    unfold eq_stack in H2.
    rewrite H2.
    reflexivity.
Qed.

Lemma eval_sstate_stack_tl:
  forall init_st sst st v1 v2 l l' ops,
  get_stack_sst sst = v1 :: l ->
  get_stack_st st = v2 :: l' ->
  eval_sstate init_st sst ops = Some st ->
  eval_sstate init_st (set_stack_sst sst l) ops = Some (set_stack_st st l').
Proof.
  intros.
  unfold eval_sstate in H1.
  unfold eval_sstack in H1.
  unfold eval_sstack'  in H1.
  rewrite H in H1.

  destruct (length (get_stack_st init_st) =? get_instk_height_sst sst) eqn:E_len.
  2: {discriminate.}.

  destruct ( get_smap_sst sst ) as [maxid bs] eqn:E_smap.

  destruct (fold_right_option
           (fun sv : sstack_val =>
            eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st)
              (get_storage_st init_st) (get_context_st init_st) bs ops) 
           (v1 :: l)) as [stk|] eqn:E_fldr.
  2: {discriminate.}.

  destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st) 
              (get_storage_st init_st) (get_context_st init_st) sst ops) as [mem|] eqn:E_mem.
  2: {discriminate.}.

  destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st)
              (get_storage_st init_st) (get_context_st init_st) sst ops) as [srtg|] eqn:E_strg.
  2: {discriminate.}.

  unfold make_st in H1.
  apply fold_right_option_len in E_fldr as E_fldr_1.
  destruct stk.
  + discriminate.
  + apply fold_right_option_hd in E_fldr.
    destruct E_fldr.

    unfold eval_sstate.
    unfold eval_sstack.
    rewrite instk_height_preserved_when_updating_stack_sst.
    rewrite E_len.
    rewrite smap_preserved_when_updating_stack_sst.
    rewrite E_smap.
    unfold eval_sstack'.
    rewrite set_and_then_get_stack_sst. rewrite H3.
    rewrite <- eval_smemory_preserved_when_sstack_changed.
    rewrite E_mem.
    rewrite <- eval_sstorage_preserved_when_sstack_changed.
    rewrite E_strg.
    injection H1 as H1.
    rewrite <- H1.
    unfold make_st.
    simpl.
    rewrite <- H1 in H0.
    simpl in H0.
    injection H0. intros.
    rewrite H4.
    reflexivity.
Qed.

    


Lemma pop_snd:
  snd_state_transformer pop_c pop_s.       
Proof.
  unfold snd_state_transformer.
  intros sst sst' ops H_pop_s init_st st H_st_inst_sst. 
  unfold pop_s in H_pop_s.
  destruct (pop (get_stack_sst sst)) eqn:H_pop_sst.
  2: {discriminate.}.
  unfold pop_c.

  pose proof (pop_succ init_st st sst ops l  H_st_inst_sst H_pop_sst) as H_pop_succ.
  destruct H_pop_succ as [v1 [v2 [l' H_pop_succ]]].
  destruct H_pop_succ as [H_pop_succ_l H_pop_succ_r].
  rewrite H_pop_succ_r.
  simpl.
  exists (set_stack_st st l').
  split.
  + reflexivity.
  + injection  H_pop_s as  H_sst'.
    rewrite <- H_sst'.
    unfold st_is_instance_of_sst in H_st_inst_sst.
    destruct H_st_inst_sst as [st' [H_st_inst_sst_l H_st_inst_sst_r]].
    pose proof (eq_execution_states_ext st st'  H_st_inst_sst_r) as H_eq_st_st'.
    rewrite <- H_eq_st_st' in H_st_inst_sst_l.

    pose proof (eval_sstate_stack_tl init_st sst st v1 v2 l l' ops H_pop_succ_l H_pop_succ_r H_st_inst_sst_l).

    unfold st_is_instance_of_sst.
    exists (set_stack_st st l').
    split.
    ++ apply H.
    ++ apply eq_execution_states_refl.
Qed.


Lemma app_nil_result:
  forall A (l1 l2 : list A),
    l1++l2 = [] -> l1=[]/\l2=[].
Proof.
  intros.
  destruct l1.
  destruct l2.
  + split. reflexivity. reflexivity.
  + discriminate H.
  + discriminate H.
Qed.

Lemma eval_sstack'_app:
  forall (sstk sstk1 sstk2: sstack) (stk stk': stack) (mem: memory) (strg: storage) (ctx: context) (sb: sbindings) (ops: stack_op_instr_map),
    sstk = sstk1++sstk2 ->   
    eval_sstack' sstk stk mem strg ctx sb ops = Some stk' ->
    exists stk1' stk2',
      stk' = stk1'++stk2' /\
        eval_sstack' sstk1 stk mem strg ctx sb ops = Some stk1' /\
        eval_sstack' sstk2 stk mem strg ctx sb ops = Some stk2'.
Proof.
  induction sstk as [|sv sstk' IHsstk'].
  - simpl.
    intros.
    injection H0 as H1.
    symmetry in H. apply app_nil_result in H. destruct H.
    rewrite H. rewrite H0. rewrite <- H1.
    exists [], [].
    simpl.
    auto.
  - intros.
    destruct sstk1.
    + simpl.
      simpl in H.
      simpl in H0.
      destruct (eval_sstack_val sv stk mem strg ctx sb ops) eqn:E0.
      ++ destruct (eval_sstack' sstk' stk mem strg ctx sb ops) eqn:E1.
         +++ destruct sstk2.
             ++++ discriminate H.
             ++++ injection H. intros.
                  pose proof (IHsstk' [] sstk2 stk s mem strg ctx sb ops H1 E1).
                  destruct H3 as [stk1']. destruct H3 as [stk2'].
                  destruct H3. destruct H4.
                  exists []. exists stk'.
                  split. reflexivity. split. reflexivity.
                  simpl. rewrite <- H2. rewrite E0. rewrite <- H1. rewrite E1. apply H0.
         +++ discriminate.
      ++ discriminate.
    + simpl in H. injection H. intros.
      simpl in H0.
      destruct (eval_sstack_val sv stk mem strg ctx sb ops) eqn:E0.
      ++ destruct (eval_sstack' sstk' stk mem strg ctx sb ops) eqn:E1.
         +++ pose proof (IHsstk' sstk1 sstk2 stk s0 mem strg ctx sb ops H1 E1).
             destruct H3 as [stk1']. destruct H3 as [stk2'].
             injection H0. intros.
             exists (e::stk1'). exists stk2'.
             rewrite <- H4.
             destruct H3. destruct H5.
             split.
             ++++ simpl. rewrite <- H3. reflexivity.
             ++++ split.
                  +++++ simpl. rewrite <- H2. rewrite E0. rewrite H5. reflexivity.
                  +++++ apply H6.
         +++ discriminate.
      ++ discriminate.         
Qed.


Lemma nth_err_two_lists:
  forall A B (l1: list A) (l2: list B) (k:nat) (v: A),
    length l1 = length l2 ->
    nth_error l1 k = Some v ->
    exists v', nth_error l2 k = Some v'.
Proof.
  induction l1 as [|e l1' IHk'].
  - intros.
    destruct k.
    + simpl in H0. discriminate.
    + simpl in H0. discriminate.
  - intros.
    destruct k.
    + simpl in H0.
      destruct l2.
      ++ discriminate.
      ++ simpl. exists b. reflexivity.
    + simpl in H0.
      destruct l2.
      ++ discriminate.
      ++ simpl in H.
         injection H as H.
         pose proof (IHk' l2 k v H H0) as Hih.
         destruct Hih as [v'].
         simpl. rewrite H1. exists v'. reflexivity.
Qed.

Lemma dup_len_two_lists:
  forall (k: nat) (T1 T2: Type) (l1: list T1) (l2: list T2) (v: T1),
    length l1 = length l2 ->
    dup k l1 = Some (v::l1) ->
    exists v', dup k l2 = Some (v'::l2).
Proof.
  induction k as [|k' IHk'].
  - intros.
    unfold dup in H0.
    destruct ((0 =? 0) || (16 <? 0) || (StackSize <=? length l1)) eqn:E_k.
    + discriminate.
    + destruct (nth_error l1 (pred 0)) eqn:E_nth_err.
      ++ injection H0. intros.
         pose proof (nth_err_two_lists T1 T2 l1 l2 (pred 0) t H E_nth_err).
         destruct H2 as [v'].
         unfold dup. rewrite <- H. rewrite E_k. rewrite H2. exists v'. reflexivity.
      ++ discriminate.
  - intros.
    destruct l1.
    + unfold dup in H0. simpl in H0.
      destruct k'.
      ++ simpl in H0. discriminate.
      ++ simpl in H0.
         destruct ((16 <? S (S k')) || false).
         +++ discriminate.
         +++ discriminate.
    + unfold dup in H0.
      destruct (((S k' =? 0) || (16 <? S k') || (StackSize <=? length (t :: l1)))) eqn:E_len.
      ++ discriminate.
      ++ simpl nth_error in H0.
         destruct (nth_error (t :: l1) k') eqn:E_nth_err.
         +++ injection H0. intros.
             pose proof (nth_err_two_lists T1 T2 (t::l1) l2 k' t0 H E_nth_err).
             destruct H2 as [v'].
             unfold dup. rewrite <- H. rewrite E_len. simpl. rewrite H2. exists v'. reflexivity.
         +++ discriminate.
Qed.


Search ltb.

Lemma eval_sstack'_hd:
  forall (sstk: sstack) (stk stk': stack) (mem: memory) (strg: storage) (ctx: context) (sb: sbindings) (ops: stack_op_instr_map) (sv: sstack_val) (v : EVMWord),
    eval_sstack' (sv :: sstk) stk mem strg ctx sb ops = Some (v :: stk') ->
    eval_sstack' sstk stk mem strg ctx sb ops = Some stk'.
Proof.
  intros.
  unfold eval_sstack' in H.
  apply fold_right_option_hd in H.
  destruct H.
  unfold eval_sstack'.
  apply H0.
Qed.

Lemma dup_elem_snd:
  forall  (k: nat) (sstk: sstack) (stk stk': stack) (mem: memory) (strg: storage) (ctx: context) (sb: sbindings) (ops: stack_op_instr_map) (sv: sstack_val) (v : EVMWord),
    eval_sstack' sstk stk mem strg ctx sb ops = Some stk' ->
    nth_error sstk k = Some sv ->
    nth_error stk' k = Some v ->
        eval_sstack_val sv stk mem strg ctx sb ops = Some v.
Proof.
  induction k as [|k' IHk'].
  - intros.
    destruct sstk.
    + discriminate H0.
    + destruct stk'.
      ++ discriminate H1.
      ++ simpl in H0. injection H0 as H0.       
         simpl in H1. injection H1 as H1.
         unfold eval_sstack' in H.
         unfold fold_right_option in H.
         rewrite <- fold_right_option_ho in H.
         destruct (eval_sstack_val s stk mem strg ctx sb ops) eqn:E_eval_sstack_val.
         2: {discriminate.}.
         destruct (fold_right_option (fun elem : sstack_val => eval_sstack_val elem stk mem strg ctx sb ops) sstk) eqn:E_fldr.
         2: {discriminate.}.
         injection H. intros.
         rewrite H0 in E_eval_sstack_val.
         rewrite H3 in E_eval_sstack_val. rewrite H1 in E_eval_sstack_val.
         apply E_eval_sstack_val.
  - intros.
    destruct sstk.
    + discriminate.
    + destruct stk'.
      ++ discriminate.
      ++ simpl in H0.
         simpl in H1.
         apply eval_sstack'_hd in H.
         pose proof (IHk' sstk stk stk' mem strg ctx sb ops sv v H H0 H1).
         apply H2.
Qed.


Lemma dup_snd:
  forall k, snd_state_transformer (dup_c k) (dup_s k).       
Proof.
  unfold snd_state_transformer.
  intros k sst sst' ops H_dup_s init_st st H_st_inst_sst.
  pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as [H_st_sst_stk_len H_init_st_len_sst].
  unfold dup_s in H_dup_s.
  unfold dup in H_dup_s.
  destruct ((k =? 0) || (16 <? k) || (StackSize <=? length (get_stack_sst sst))) eqn:E_dup_s_k.
  + discriminate.
  + destruct (nth_error (get_stack_sst sst) (pred k)) as [sv|] eqn:E_sst_nth_err.
    2: {discriminate.}.
    unfold dup_c.
    unfold dup.
    rewrite <- H_st_sst_stk_len.
    rewrite E_dup_s_k.
    pose proof (nth_err_two_lists sstack_val EVMWord (get_stack_sst sst) (get_stack_st st) (pred k) sv H_st_sst_stk_len E_sst_nth_err) as H_st_nth_err.
    destruct H_st_nth_err as [v' H_st_nth_err].
    rewrite H_st_nth_err.
    exists (set_stack_st st (v' :: get_stack_st st)).
    split.
    ++ reflexivity.
    ++ injection H_dup_s as H_sst'.
       rewrite <- H_sst'.
       unfold st_is_instance_of_sst.
       exists (set_stack_st st (v' :: get_stack_st st)).
       split.
       +++ unfold st_is_instance_of_sst in H_st_inst_sst.
           destruct H_st_inst_sst as [st' H_st_inst_sst].
           destruct H_st_inst_sst as [H_st_inst_sst_l H_st_inst_sst_r].
           unfold eval_sstate in H_st_inst_sst_l.
           unfold eval_sstack in H_st_inst_sst_l.
           apply Nat.eqb_eq in H_init_st_len_sst as H_init_st_len_sst_eqb.
           rewrite H_init_st_len_sst_eqb in H_st_inst_sst_l.
           destruct (get_smap_sst sst) as [maxid bs] eqn:E_smap.

           destruct (eval_sstack' (get_stack_sst sst) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) bs ops) as [stk|] eqn:E_eval_sstack'.
           2: {discriminate.}.

           destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [mem|] eqn:E_eval_smemory.
           2: {discriminate.}.

           destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [strg|] eqn:E_eval_sstorage.
           2: {discriminate.}.

           unfold make_st in  H_st_inst_sst_l.
           injection H_st_inst_sst_l as H_st_inst_sst_l.
           apply eq_execution_states_ext in H_st_inst_sst_r as H_eq_st_st'.
           rewrite  H_eq_st_st' in   H_st_nth_err.
           rewrite <-   H_st_inst_sst_l in H_st_nth_err.
           simpl in H_st_nth_err.
           pose proof (dup_elem_snd (pred k) (get_stack_sst sst) (get_stack_st init_st) stk (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) bs ops sv v' E_eval_sstack'  E_sst_nth_err  H_st_nth_err) as H_eval_sstack_val.

           unfold eval_sstate.
           unfold eval_sstack.
           rewrite instk_height_preserved_when_updating_stack_sst.
           rewrite H_init_st_len_sst_eqb.
           rewrite smap_preserved_when_updating_stack_sst.
           rewrite E_smap.
           rewrite set_and_then_get_stack_sst.
           unfold eval_sstack'.
           unfold fold_right_option.
           rewrite <- fold_right_option_ho.
           rewrite H_eval_sstack_val.
           unfold eval_sstack' in  E_eval_sstack'.
           rewrite  E_eval_sstack'.
           rewrite <- eval_smemory_preserved_when_sstack_changed.
           rewrite <- eval_sstorage_preserved_when_sstack_changed.
           rewrite E_eval_smemory.
           rewrite E_eval_sstorage.
           unfold make_st.
           rewrite H_eq_st_st'.
           rewrite <- H_st_inst_sst_l.
           simpl.
           reflexivity.
       +++ apply eq_execution_states_refl.
Qed.
    
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
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply pushtag_snd.
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
  pose proof (gen_empty_sstate_eval_sstack'_snd n n stk mem strg ctx bindings ops).
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
          st_is_instance_of_sst st st' sst ops. (* st' is an instance of sst wrt the initial state st *)
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


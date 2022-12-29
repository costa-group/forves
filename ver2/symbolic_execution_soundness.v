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
    valid_sstate sst ->
    symtr sst ops = Some sst' ->
    valid_sstate sst' /\
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
forall (i:nat) (stk: stack) (mem: memory) (strg: storage) (ctx: context) (bs: sbindings) (ops: stack_op_instr_map),
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
  unfold map_option.
  rewrite eval_sstack_val_Val.
  rewrite <- map_option_ho.
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
  apply map_option_len in H_eval_sstack'.
  apply H_eval_sstack'.
Qed.

  
(* changing the symbolic stack does not affect eval_smemory *)
Lemma eval_smemory_preserved_when_sstack_changed:
  forall stk mem strg ctx sst ops sstk,
    eval_smemory stk mem strg ctx sst ops =
      eval_smemory stk mem strg ctx (set_stack_sst sst sstk) ops.
Proof.
  intros.
  destruct sst.
  reflexivity.
Qed.

(* changing the symbolic stack does not affect eval_sstorage *)
Lemma eval_sstorage_preserved_when_sstack_changed:
  forall stk mem strg ctx sst ops sstk,
    eval_sstorage stk mem strg ctx sst ops =
      eval_sstorage stk mem strg ctx (set_stack_sst sst sstk) ops.
Proof.
  intros.
  destruct sst.
  reflexivity.
Qed.

(* This is a challenging one! For now we assume it is correct *)
Lemma eval_sstack_val_FreshVar:
  forall i maxid sb v stk mem strg ctx ops,
    fresh_var_gt_map maxid sb ->
      eval_sstack_val (FreshVar i) stk mem strg ctx sb ops = Some v ->
      i < maxid.
Proof.
  intros i maxid sb v stk mem strg ctx ops H_fresh_var_gt.
  induction sb as [|p sb'].
  + discriminate.
  + intro H_eval_sstack_val.
    destruct p.
    unfold fresh_var_gt_map in H_fresh_var_gt.
    fold fresh_var_gt_map in H_fresh_var_gt.
    destruct H_fresh_var_gt as [H_fresh_var_gt_l H_fresh_var_gt_r].
    unfold eval_sstack_val in H_eval_sstack_val.
    fold eval_sstack_val in H_eval_sstack_val.
    destruct (n =? i) eqn:E_n_eqb_i.
    ++ apply Nat.eqb_eq in E_n_eqb_i as E_n_eq_i.
       rewrite <- E_n_eq_i.
       apply H_fresh_var_gt_l.
    ++ apply IHsb'.
       apply H_fresh_var_gt_r.
       apply H_eval_sstack_val.
Qed.
  
  
(* This is a challenging one! For now we assume it is correct *)
Lemma eval_sstack_val_preserved_when_smap_extended:
  forall sst maxid maxid' sb sb' v value sv stk mem strg ctx ops key',
  valid_sstate sst ->
  (get_smap_sst sst) = SymMap maxid sb ->
  (add_to_smap (get_smap_sst sst) value) = (key', SymMap maxid' sb') ->
  eval_sstack_val sv stk mem strg ctx sb ops = Some v ->
  eval_sstack_val sv stk mem strg ctx sb' ops = Some v.
Proof.
  intros sst maxid maxid' sb sb' v value sv stk mem strg ctx ops key' H_valid_sst H_get_smap H_add_to_map H_eval_sstack.
  rewrite H_get_smap in H_add_to_map.
  simpl in H_add_to_map.
  injection H_add_to_map as H_add_to_map_1  H_add_to_map_2  H_add_to_map_3.
  rewrite <-  H_add_to_map_3.
  destruct sv.
  + simpl.
    pose proof (eval_sstack_val_Val val stk mem strg ctx sb ops) as H_eval_sstack_val_Val.
    rewrite H_eval_sstack_val_Val in H_eval_sstack.
    apply H_eval_sstack.
    
  + simpl.
    pose proof (eval_sstack_val_InStackVar var stk mem strg ctx sb ops) as H_eval_sstack_val_InStackVar.
    rewrite H_eval_sstack_val_InStackVar in H_eval_sstack.
    rewrite H_eval_sstack.
    reflexivity.
  + unfold valid_sstate in H_valid_sst.
    rewrite H_get_smap in H_valid_sst.
    destruct H_valid_sst as [H_valid_sst_l H_valid_sst_r].
    pose proof (eval_sstack_val_FreshVar var maxid sb v stk mem strg ctx ops  H_valid_sst_l H_eval_sstack) as H_var_lt_maxid.
    unfold eval_sstack_val.
    fold eval_sstack_val.
    destruct (maxid =? var) eqn:E_maxid_eqb_var.
    ++ apply Nat.eqb_eq in E_maxid_eqb_var.
       intuition.
    ++ apply H_eval_sstack.
Qed.    

Lemma eval_sstack_mapo_preserved_when_smap_extended:
  forall sstk sst init_st maxid maxid' sb sb' value ops key' s,
  valid_sstate sst ->
  (get_smap_sst sst) = SymMap maxid sb ->
  (add_to_smap (get_smap_sst sst) value) = (key', SymMap maxid' sb') ->

  map_option
                    (fun sv : sstack_val =>
                     eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st)
                       (get_storage_st init_st) (get_context_st init_st) sb ops)
                    sstk = Some s
  ->
  map_option
                    (fun sv : sstack_val =>
                     eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st)
                       (get_storage_st init_st) (get_context_st init_st) sb' ops)
                    sstk  = Some s.
Proof.
  intro sstk.
  induction sstk as [| s0 s1 IHs1].
  - intros. apply H2. 
  - intros.
    destruct s.
    + apply map_option_len in H2. discriminate.
    + apply map_option_hd in H2.
      destruct H2.
      pose proof (eval_sstack_val_preserved_when_smap_extended sst maxid maxid' sb sb' e value s0 (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key' H H0 H1 H2).
      pose proof (IHs1 sst init_st maxid maxid' sb sb' value ops key' s H H0 H1 H3).
      unfold map_option.
      rewrite <- map_option_ho.
      rewrite H5.
      rewrite H4.
      reflexivity.
Qed.
    

Lemma eval_sstack_preserved_when_smap_extended:
  forall sst init_st m value ops key' stk,
  valid_sstate sst ->
  (add_to_smap (get_smap_sst sst) value) = (key', m) ->
  eval_sstack (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops = Some stk ->
  eval_sstack (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (set_smap_sst sst m) ops = Some stk.
Proof.
  intros.
  unfold eval_sstack in H1.
  destruct (length (get_stack_st init_st) =? get_instk_height_sst sst) eqn:E_len; try discriminate.
  destruct (get_smap_sst sst) eqn:E_smap.
  unfold eval_sstack' in H1.
  destruct m eqn:E_m.
  rewrite <- E_smap in H0.
  pose proof (eval_sstack_mapo_preserved_when_smap_extended (get_stack_sst sst) sst init_st maxid maxid0  bindings bindings0 value ops key' stk H E_smap H0 H1).
  unfold eval_sstack.
  rewrite instk_height_preserved_when_updating_smap_sst.
  rewrite E_len.
  rewrite set_and_then_get_smap_sst.
  rewrite sstack_preserved_when_updating_smap_sst.
  unfold eval_sstack'.
  apply H2.
Qed.

Lemma eval_smemory_mapo_preserved_when_smap_extended:
  forall sst init_st maxid maxid' sb sb' value ops key' l,
    valid_sstate sst ->
    (get_smap_sst sst) = SymMap maxid sb ->
    (add_to_smap (get_smap_sst sst) value) = (key', SymMap maxid' sb') ->
    map_option
      (eval_common.EvalCommon.instantiate_memory_update
         (fun sv : sstack_val =>
            eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st)
              (get_storage_st init_st) (get_context_st init_st) sb ops))
      (get_memory_sst sst) = Some l ->
    map_option
      (eval_common.EvalCommon.instantiate_memory_update
         (fun sv : sstack_val =>
            eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st)
              (get_storage_st init_st) (get_context_st init_st) sb' ops))
      (get_memory_sst sst) = Some l.
Proof.
  intro sst.
  induction (get_memory_sst sst) as [| u us IHus].
  - intros. simpl. simpl in H2. apply H2.
  - intros.
    destruct l.
    + apply map_option_len in H2. discriminate.
    + apply map_option_hd in H2.
      destruct H2.
      
      unfold eval_common.EvalCommon.instantiate_memory_update in H2.
      destruct u.
      ++ destruct (eval_sstack_val offset (get_stack_st init_st) (get_memory_st init_st)
                     (get_storage_st init_st) (get_context_st init_st) sb ops) eqn:E_eval_sstack_val_offset; try discriminate.
         
         pose proof (eval_sstack_val_preserved_when_smap_extended sst maxid maxid' sb sb' e value offset (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key' H H0 H1  E_eval_sstack_val_offset).

         destruct (eval_sstack_val value0 (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops) eqn:E_eval_sstack_val_value; try discriminate.

         pose proof (eval_sstack_val_preserved_when_smap_extended sst maxid maxid' sb sb' e0 value value0 (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key' H H0 H1  E_eval_sstack_val_value).

         unfold map_option.
         rewrite <- map_option_ho.
         simpl.
         rewrite H4.
         rewrite H5.

         pose proof (IHus init_st maxid maxid' sb sb' value ops key' l H H0 H1 H3).
         rewrite H6.
         injection H2 as H2.
         rewrite <- H2.
         reflexivity.

      (* dulicated from previous step, improve later *)
      ++ destruct (eval_sstack_val offset (get_stack_st init_st) (get_memory_st init_st)
                     (get_storage_st init_st) (get_context_st init_st) sb ops) eqn:E_eval_sstack_val_offset; try discriminate.

         pose proof (eval_sstack_val_preserved_when_smap_extended sst maxid maxid' sb sb' e value offset (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key' H H0 H1  E_eval_sstack_val_offset).

         destruct (eval_sstack_val value0 (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops) eqn:E_eval_sstack_val_value; try discriminate.

         pose proof (eval_sstack_val_preserved_when_smap_extended sst maxid maxid' sb sb' e0 value value0 (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key' H H0 H1  E_eval_sstack_val_value).

         unfold map_option.
         rewrite <- map_option_ho.
         simpl.
         rewrite H4.
         rewrite H5.

         pose proof (IHus init_st maxid maxid' sb sb' value ops key' l H H0 H1 H3).
         rewrite H6.
         injection H2 as H2.
         rewrite <- H2.
         reflexivity.
Qed.

    
Lemma eval_smemory_preserved_when_smap_extended:
  forall sst init_st m value ops key' mem,
  valid_sstate sst ->
  (add_to_smap (get_smap_sst sst) value) = (key', m) ->
    eval_smemory (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops = Some mem ->
  eval_smemory (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (set_smap_sst sst m) ops = Some mem.
Proof.
  intros.
  unfold eval_smemory in H1.
  destruct (get_smap_sst sst) eqn:E_smap.
  destruct (map_option
           (eval_common.EvalCommon.instantiate_memory_update
              (fun sv : sstack_val =>
               eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st)
                 (get_storage_st init_st) (get_context_st init_st) bindings ops))
           (get_memory_sst sst)) eqn:E_mapo; try discriminate.
  injection H1 as H1.
  destruct m eqn:E_m.
  rewrite <- E_smap in H0.
  pose proof (eval_smemory_mapo_preserved_when_smap_extended sst init_st maxid maxid0 bindings bindings0 value ops key' l H E_smap H0 E_mapo).
  unfold eval_smemory.
  rewrite set_and_then_get_smap_sst. 
  rewrite smemory_preserved_when_updating_smap_sst.
  rewrite H2.
  rewrite H1.
  reflexivity.
Qed.


Lemma eval_sstorage_mapo_preserved_when_smap_extended:
  forall sst init_st maxid maxid' sb sb' value ops key' l,
    valid_sstate sst ->
    (get_smap_sst sst) = SymMap maxid sb ->
    (add_to_smap (get_smap_sst sst) value) = (key', SymMap maxid' sb') ->
    map_option
      (eval_common.EvalCommon.instantiate_storage_update
         (fun sv : sstack_val =>
            eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st)
              (get_storage_st init_st) (get_context_st init_st) sb ops))
      (get_storage_sst sst) = Some l ->
    map_option
      (eval_common.EvalCommon.instantiate_storage_update
         (fun sv : sstack_val =>
            eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st)
              (get_storage_st init_st) (get_context_st init_st) sb' ops))
      (get_storage_sst sst) = Some l.
Proof.
  intro sst.
  induction (get_storage_sst sst) as [| u us IHus].
  - intros. simpl. simpl in H2. apply H2.
  - intros.
    destruct l.
    + apply map_option_len in H2. discriminate.
    + apply map_option_hd in H2.
      destruct H2.
      unfold eval_common.EvalCommon.instantiate_storage_update in H2.

      destruct u.

      destruct (eval_sstack_val key (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops) eqn:E_eval_sstack_val_key; try discriminate.

      pose proof (eval_sstack_val_preserved_when_smap_extended sst maxid maxid' sb sb' e value key (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key' H H0 H1  E_eval_sstack_val_key).

      destruct (eval_sstack_val value0 (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops) eqn:E_eval_sstack_val_value; try discriminate.

      pose proof (eval_sstack_val_preserved_when_smap_extended sst maxid maxid' sb sb' e0 value value0 (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key' H H0 H1  E_eval_sstack_val_value).
      
      unfold map_option.
      rewrite <- map_option_ho.
      simpl.
      rewrite H4.
      rewrite H5.

      pose proof (IHus init_st maxid maxid' sb sb' value ops key' l H H0 H1 H3).
      rewrite H6.
      injection H2 as H2.
      rewrite <- H2.
      reflexivity.
Qed.


Lemma eval_sstorage_preserved_when_smap_extended:
  forall sst init_st m value ops key' strg,
  valid_sstate sst ->
  (add_to_smap (get_smap_sst sst) value) = (key', m) ->
    eval_sstorage (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops = Some strg ->
  eval_sstorage (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (set_smap_sst sst m) ops = Some strg.
Proof.
  intros.
  unfold eval_sstorage in H1.
  destruct (get_smap_sst sst) eqn:E_smap.
  destruct (map_option
           (eval_common.EvalCommon.instantiate_storage_update
              (fun sv : sstack_val =>
               eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st)
                 (get_storage_st init_st) (get_context_st init_st) bindings ops))
           (get_storage_sst sst)) eqn:E_mapo; try discriminate.
  injection H1 as H1.
  destruct m eqn:E_m.
  rewrite <- E_smap in H0.
  pose proof (eval_sstorage_mapo_preserved_when_smap_extended sst init_st maxid maxid0 bindings bindings0 value ops key' l H E_smap H0 E_mapo). 
  unfold eval_sstorage.
  rewrite set_and_then_get_smap_sst. 
  rewrite sstorage_preserved_when_updating_smap_sst.
  rewrite H2.
  rewrite H1.
  reflexivity.
Qed.


(* changing the symbolic stack does not affect st_is_instance_of_sst *)
Lemma eval_st_inst_sst_sstack_preserved_when_smap_extended:
  forall (init_st st: state) (sst: sstate) (key maxid: nat) (value: smap_value) (m: smap) (ops: stack_op_instr_map),
    valid_sstate sst ->
    st_is_instance_of_sst init_st st sst ops ->
    (add_to_smap (get_smap_sst sst) value) = (key, m) ->
    st_is_instance_of_sst init_st st (set_smap_sst sst m) ops.
Proof.
  intros.
  unfold st_is_instance_of_sst.
  exists st.
  split; try apply eq_execution_states_refl.
  unfold st_is_instance_of_sst in H0.
  destruct H0 as [st'].
  destruct H0.
  apply eq_execution_states_ext in H2.
  unfold eval_sstate in H0.

  destruct (eval_sstack (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) eqn:E_eval_sstack; try discriminate.
  destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) eqn:E_eval_smemory; try discriminate.
  destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) eqn:E_eval_sstorage; try discriminate.

  pose proof (eval_sstack_preserved_when_smap_extended sst init_st m value ops key s H H1 E_eval_sstack).

  pose proof (eval_smemory_preserved_when_smap_extended sst init_st m value ops key m0 H H1 E_eval_smemory).

  pose proof (eval_sstorage_preserved_when_smap_extended sst init_st m value ops key s0 H H1 E_eval_sstorage).
  
  unfold eval_sstate.

  rewrite H3.
  rewrite H4.
  rewrite H5.

  injection H0 as H0.
  rewrite H2.
  rewrite <- H0.
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
  destruct (length (get_stack_st st) =? get_instk_height_sst sst) eqn:E_len; try discriminate.
  destruct (eval_sstack' (get_stack_sst sst) (get_stack_st st) (get_memory_st st) (get_storage_st st) (get_context_st st) sb ops) as [stk|] eqn:E_eval_sstack'; try discriminate.
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

  destruct (eval_smemory (get_stack_st st) (get_memory_st st) (get_storage_st st) (get_context_st st) sst ops); try discriminate.

  destruct (eval_sstorage (get_stack_st st) (get_memory_st st) (get_storage_st st) (get_context_st st) sst ops); try discriminate.

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
  destruct (length (get_stack_st init_st) =? get_instk_height_sst sst) eqn:E_len; try discriminate.
  destruct (get_smap_sst sst) as [maxid sb] eqn:E_smap.
  apply beq_nat_true in E_len.

  destruct (eval_sstack' (get_stack_sst sst) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) 
              (get_context_st init_st) sb ops) as [stk|] eqn:E_eval_sstack'; try discriminate.

  destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [mem|]  eqn:E_eval_smemory; try discriminate.

  destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [strg|]  eqn:E_eval_sstorage; try discriminate.
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

(* Valid states *)
Lemma push_valid_sst:
  forall sst sst' w ops,
    valid_sstate sst ->
    push_s w sst ops = Some sst' ->
    valid_sstate sst'.
Proof.
  intros sst sst' w ops H_valid_sst H_push_s.
  unfold push_s in H_push_s.
  destruct (push (Val w) (get_stack_sst sst)) eqn:E_push; try discriminate.
  injection H_push_s as H_push_s.
  destruct sst.
  destruct sst'.
  unfold valid_sstate in H_valid_sst.
  unfold valid_sstate.
  simpl in H_push_s.
  injection H_push_s as _ _ _ _ _ H_sm_sm0.
  rewrite <- H_sm_sm0.
  apply H_valid_sst.
Qed.

Lemma pushtag_valid_sst:
  forall sst sst' v ops,
    valid_sstate sst ->
    pushtag_s v sst ops = Some sst' ->
    valid_sstate sst'.
Proof.
  intros sst sst' v ops H_valid_sst H_pushtag_s.
  unfold pushtag_s in H_pushtag_s.
  destruct (add_to_smap (get_smap_sst sst) (SymPUSHTAG v)) as [key sm'] eqn:E_add_to_smap.
  symmetry in E_add_to_smap.
  pose proof (add_to_map_valid_sstate sst key sm' (SymPUSHTAG v) H_valid_sst E_add_to_smap) as H_valid_sst_add.
  destruct sst.
  destruct sst'. 
  simpl in H_pushtag_s.
  destruct (push (FreshVar key) sstk) as [sstk'|] eqn:E_sstk'; try discriminate.
  unfold set_smap_sst in H_valid_sst_add.
  injection H_pushtag_s. intros.
  rewrite <- H. rewrite <- H0. rewrite <- H1. rewrite <- H2. rewrite <- H3. rewrite <- H4.
  unfold valid_sstate in H_valid_sst_add.
  unfold valid_sstate.
  apply H_valid_sst_add.
Qed.

Lemma pop_valid_sst:
  forall sst sst' ops,
    valid_sstate sst ->
    pop_s sst ops = Some sst' ->
    valid_sstate sst'.
Proof.
  intros sst sst' ops H_valid_sst H_pop_s.
  unfold pop_s in H_pop_s.
  destruct (pop (get_stack_sst sst)) eqn:E_pop; try discriminate.
  injection H_pop_s as H_pop_s.
  destruct sst.
  destruct sst'.
  unfold valid_sstate in H_valid_sst.
  unfold valid_sstate.
  simpl in H_pop_s.
  injection H_pop_s as _ _ _ _ _ H_sm_sm0.
  rewrite <- H_sm_sm0.
  apply H_valid_sst.
Qed.

Lemma dup_valid_sst:
    forall sst sst' ops k,
    valid_sstate sst ->
    dup_s k sst ops = Some sst' ->
    valid_sstate sst'.
Proof.
  intros sst sst' ops k H_valid_sst H_dup_s.
  unfold dup_s in H_dup_s.
  destruct (dup k (get_stack_sst sst)) eqn:E_dup; try discriminate.
  injection H_dup_s as H_dup_s.
  destruct sst.
  destruct sst'.
  unfold valid_sstate in H_valid_sst.
  unfold valid_sstate.
  simpl in H_dup_s.
  injection H_dup_s as _ _ _ _ _ H_sm_sm0.
  rewrite <- H_sm_sm0.
  apply H_valid_sst.
Qed.

Lemma swap_valid_sst:
    forall sst sst' ops k,
    valid_sstate sst ->
    swap_s k sst ops = Some sst' ->
    valid_sstate sst'.
Proof.
  intros sst sst' ops k H_valid_sst H_swap_s.
  unfold swap_s in H_swap_s.
  destruct (swap k (get_stack_sst sst)) eqn:E_swap; try discriminate.
  injection H_swap_s as H_swap_s.
  destruct sst.
  destruct sst'.
  unfold valid_sstate in H_valid_sst.
  unfold valid_sstate.
  simpl in H_swap_s.
  injection H_swap_s as _ _ _ _ _ H_sm_sm0.
  rewrite <- H_sm_sm0.
  apply H_valid_sst.
Qed.


Lemma sload_valid_sst:
  forall sst sst' ops,
    valid_sstate sst ->
    sload_s sst ops = Some sst' ->
    valid_sstate sst'.
Proof.
  intros sst sst' ops H_valid_sst H_sload_s.
  unfold sload_s in H_sload_s.
  destruct (get_stack_sst sst) eqn:E_sstack; try discriminate.
  destruct (add_to_smap (get_smap_sst sst) (SymSLOAD s (get_storage_sst sst))) as [key sm'] eqn:E_add_to_smap.
  symmetry in E_add_to_smap.
  pose proof (add_to_map_valid_sstate sst key sm' (SymSLOAD s (get_storage_sst sst)) H_valid_sst E_add_to_smap) as H_valid_sst_add.
  destruct sst.
  destruct sst'. 
  simpl in H_sload_s.
  unfold set_smap_sst in H_valid_sst_add.
  injection H_sload_s. intros.
  rewrite <- H. rewrite <- H0. rewrite <- H1. rewrite <- H2. rewrite <- H3. rewrite <- H4.
  unfold valid_sstate in H_valid_sst_add.
  unfold valid_sstate.
  apply H_valid_sst_add.
Qed.

Lemma mload_valid_sst:
  forall sst sst' ops,
    valid_sstate sst ->
    mload_s sst ops = Some sst' ->
    valid_sstate sst'.
Proof.
  intros sst sst' ops H_valid_sst H_mload_s.
  unfold mload_s in H_mload_s.
  destruct (get_stack_sst sst) eqn:E_sstack; try discriminate.
  destruct (add_to_smap (get_smap_sst sst) (SymMLOAD s (get_memory_sst sst))) as [key sm'] eqn:E_add_to_smap.
  symmetry in E_add_to_smap.
  pose proof (add_to_map_valid_sstate sst key sm' (SymMLOAD s (get_memory_sst sst)) H_valid_sst E_add_to_smap) as H_valid_sst_add.
  destruct sst.
  destruct sst'. 
  simpl in H_mload_s.
  unfold set_smap_sst in H_valid_sst_add.
  injection H_mload_s. intros.
  rewrite <- H. rewrite <- H0. rewrite <- H1. rewrite <- H2. rewrite <- H3. rewrite <- H4.
  unfold valid_sstate in H_valid_sst_add.
  unfold valid_sstate.
  apply H_valid_sst_add.
Qed.

Lemma sha3_valid_sst:
  forall sst sst' ops,
    valid_sstate sst ->
    sha3_s sst ops = Some sst' ->
    valid_sstate sst'.
Proof.
  intros sst sst' ops H_valid_sst H_sha3_s.
  unfold sha3_s in H_sha3_s.
  destruct (get_stack_sst sst) eqn:E_sstack; try discriminate.
  destruct s0; try discriminate.
  destruct (add_to_smap (get_smap_sst sst) (SymSHA3 s s0 (get_memory_sst sst))) as [key sm'] eqn:E_add_to_smap.
  symmetry in E_add_to_smap.
  pose proof (add_to_map_valid_sstate sst key sm' (SymSHA3 s s0 (get_memory_sst sst)) H_valid_sst E_add_to_smap) as H_valid_sst_add.
  destruct sst.
  destruct sst'. 
  simpl in H_sha3_s.
  unfold set_smap_sst in H_valid_sst_add.
  injection H_sha3_s. intros.
  rewrite <- H. rewrite <- H0. rewrite <- H1. rewrite <- H2. rewrite <- H3. rewrite <- H4.
  unfold valid_sstate in H_valid_sst_add.
  unfold valid_sstate.
  apply H_valid_sst_add.
Qed.

Lemma sstore_valid_sst:
  forall sst sst' ops,
    valid_sstate sst ->
    sstore_s sst ops = Some sst' ->
    valid_sstate sst'.
Proof.
  intros sst sst' ops H_valid_sst H_sstore_s.
  unfold sstore_s in H_sstore_s.
  destruct (get_stack_sst sst) as [|key value] eqn:E_sstack; try discriminate.
  destruct value eqn:E_value; try discriminate.
  destruct sst.
  destruct sst'. 
  simpl in H_sstore_s.
  injection H_sstore_s. intros.
  rewrite <- H. rewrite <- H0. rewrite <- H1. rewrite <- H2. rewrite <- H3. rewrite <- H4.
  unfold valid_sstate in H_valid_sst.
  unfold valid_sstate.
  apply H_valid_sst.
Qed.

Lemma mstore_valid_sst:
  forall sst sst' ops,
    valid_sstate sst ->
    mstore_s sst ops = Some sst' ->
    valid_sstate sst'.
Proof.
  intros sst sst' ops H_valid_sst H_mstore_s.
  unfold mstore_s in H_mstore_s.
  destruct (get_stack_sst sst) as [|key value] eqn:E_sstack; try discriminate.
  destruct value eqn:E_value; try discriminate.
  destruct sst.
  destruct sst'. 
  simpl in H_mstore_s.
  injection H_mstore_s. intros.
  rewrite <- H. rewrite <- H0. rewrite <- H1. rewrite <- H2. rewrite <- H3. rewrite <- H4.
  unfold valid_sstate in H_valid_sst.
  unfold valid_sstate.
  apply H_valid_sst.
Qed.

Lemma mstore8_valid_sst:
  forall sst sst' ops,
    valid_sstate sst ->
    mstore8_s sst ops = Some sst' ->
    valid_sstate sst'.
Proof.
  intros sst sst' ops H_valid_sst H_mstore8_s.
  unfold mstore8_s in H_mstore8_s.
  destruct (get_stack_sst sst) as [|key value] eqn:E_sstack; try discriminate.
  destruct value eqn:E_value; try discriminate.
  destruct sst.
  destruct sst'. 
  simpl in H_mstore8_s.
  injection H_mstore8_s. intros.
  rewrite <- H. rewrite <- H0. rewrite <- H1. rewrite <- H2. rewrite <- H3. rewrite <- H4.
  unfold valid_sstate in H_valid_sst.
  unfold valid_sstate.
  apply H_valid_sst.
Qed.


Lemma exec_stack_op_intsr_valid_sst:
  forall sst sst' label ops,
    valid_sstate sst ->
    exec_stack_op_intsr_s label sst ops = Some sst' ->
    valid_sstate sst'.
Proof.
  intros sst sst' label ops H_valid_sst H_execop_s.
  unfold exec_stack_op_intsr_s in H_execop_s.
  destruct (ops label) eqn:E_ops_label.
  destruct (firstn_e n (get_stack_sst sst)) eqn:E_firstn; try discriminate.
  destruct (skipn_e n (get_stack_sst sst)) eqn:E_skipn; try discriminate.
  destruct (add_to_smap (get_smap_sst sst) (SymOp label l)) as [key sm'] eqn:E_add_to_smap.
  symmetry in E_add_to_smap.
  pose proof (add_to_map_valid_sstate sst key sm' (SymOp label l) H_valid_sst E_add_to_smap) as H_valid_sst_add.
  destruct sst.
  destruct sst'. 
  simpl in H_execop_s.
  unfold set_smap_sst in H_valid_sst_add.
  injection H_execop_s. intros.
  rewrite <- H. rewrite <- H0. rewrite <- H1. rewrite <- H2. rewrite <- H3. rewrite <- H4.
  unfold valid_sstate in H_valid_sst_add.
  unfold valid_sstate.
  apply H_valid_sst_add.
Qed.

(* push_s is a sound symbolic transformer *)
Lemma push_snd:
  forall w, snd_state_transformer (push_c w) (push_s w).
Proof.
  intro w.
  unfold snd_state_transformer.
  intros sst sst' ops H_valid_sst H_push_s.
  split.

  - pose proof (push_valid_sst sst sst' w ops H_valid_sst H_push_s) as H_valid_sst'. apply H_valid_sst'.
  - intros  init_st st H_st_inst_sst.
    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as H_inst_stk_len.
    destruct H_inst_stk_len as [H_inst_stk_len_l H_inst_stk_len_r].
    unfold push_s in H_push_s.
    unfold push in H_push_s.
    destruct (length (get_stack_sst sst) <? StackSize) eqn:E_stk_len; try discriminate.
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

  intro v.
  unfold snd_state_transformer.
  intros sst sst' ops H_valid_sst H_pushtag_s.
  split.
  - pose proof (pushtag_valid_sst sst sst' v ops H_valid_sst H_pushtag_s) as H_valid_sst'. apply H_valid_sst'.
  - intros init_st st H_st_inst_sst.
    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as H_inst_stk_len.
    destruct H_inst_stk_len as [H_inst_stk_len_l H_inst_stk_len_r].
    unfold pushtag_s in H_pushtag_s.
    destruct (add_to_smap (get_smap_sst sst) (SymPUSHTAG v)) as [key' sm'] eqn:E_add_to_smap.
    unfold push in H_pushtag_s.
    destruct (length (get_stack_sst sst) <? StackSize) eqn:E_stk_len; try discriminate.

    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as E_stack_len_st_eq_sst.
    destruct E_stack_len_st_eq_sst as [E_stack_len_st_eq_sst_l E_stack_len_st_eq_sst_r].

    unfold pushtag_c.
    unfold push.
    rewrite <- H_inst_stk_len_l.
    rewrite E_stk_len.

    exists (set_stack_st st (get_tags_ctx (get_context_st st) v :: get_stack_st st)).

    split.
    + reflexivity.
    + exists (set_stack_st st (get_tags_ctx (get_context_st st) v :: get_stack_st st)).
      split.
      2: apply eq_execution_states_refl.

      unfold eval_sstate.

      assert (H_st_inst_sst' := H_st_inst_sst).
      unfold st_is_instance_of_sst in H_st_inst_sst'.
      destruct H_st_inst_sst' as [st' H_st_inst_sst'].
      destruct H_st_inst_sst' as [H_st_inst_sst'_l H_st_inst_sst'_r].

      pose proof (eq_execution_states_ext st st' H_st_inst_sst'_r) as H_st_eq_st'.
    
      unfold eval_sstate in H_st_inst_sst'_l.
      
      destruct (eval_sstack (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [stk''|] eqn:E_eval_sstack; try discriminate.
      destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [mem|] eqn:E_mem; try discriminate.
      destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [strg|] eqn:E_strg; try discriminate.

      injection H_st_inst_sst'_l as H_st_inst_sst'_l.

      pose proof (valid_sstate_sstack_change sst (FreshVar key' :: get_stack_sst sst)  H_valid_sst) as H_valid_sst_with_fresh_var.

      pose proof (smap_preserved_when_updating_stack_sst sst (FreshVar key' :: get_stack_sst sst)) as E_get_smap_with_stk_fresh_var.
    
      assert(E_add_to_smap' := E_add_to_smap).
      rewrite <-  E_get_smap_with_stk_fresh_var in E_add_to_smap'.

      injection H_pushtag_s as H_pushtag_s.
      rewrite <- H_pushtag_s.
      
      (* equivalence of eval_smemory *)
      pose proof (eval_smemory_preserved_when_sstack_changed (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops (FreshVar key' :: get_stack_sst sst)) as E_eval_smemory_0.
      rewrite E_eval_smemory_0 in E_mem.
      
      pose proof (eval_smemory_preserved_when_smap_extended (set_stack_sst sst (FreshVar key' :: get_stack_sst sst)) init_st sm' (SymPUSHTAG v) ops key' mem H_valid_sst_with_fresh_var E_add_to_smap' E_mem) as E_eval_smemory_1.
      
      rewrite E_eval_smemory_1.

      (* equivalence of eval_sstorage *)
      pose proof (eval_sstorage_preserved_when_sstack_changed (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops (FreshVar key' :: get_stack_sst sst)) as E_eval_sstorage_0.

      rewrite E_eval_sstorage_0 in E_strg.

      pose proof (eval_sstorage_preserved_when_smap_extended (set_stack_sst sst (FreshVar key' :: get_stack_sst sst)) init_st sm' (SymPUSHTAG v) ops key' strg H_valid_sst_with_fresh_var E_add_to_smap' E_strg) as E_eval_sstorage_1.

      rewrite E_eval_sstorage_1.

      (* the case of eval_sstack *)
      unfold eval_sstack in E_eval_sstack.

      apply Nat.eqb_eq in E_stack_len_st_eq_sst_r as E_stack_len_st_eq_sst_r_eqb.
      apply Nat.eqb_eq in E_stack_len_st_eq_sst_l as E_stack_len_st_eq_sst_l_eqb.
      
      rewrite E_stack_len_st_eq_sst_r_eqb in E_eval_sstack.
      destruct (get_smap_sst sst) as [maxid sb] eqn:E_get_smap_sst.

      unfold eval_sstack' in E_eval_sstack.

      unfold eval_sstack.

      rewrite instk_height_preserved_when_updating_smap_sst.
      rewrite instk_height_preserved_when_updating_stack_sst.
      rewrite E_stack_len_st_eq_sst_r_eqb.
      rewrite set_and_then_get_smap_sst.

      destruct sm' as [maxid' sb'].

      rewrite sstack_preserved_when_updating_smap_sst.
      rewrite set_and_then_get_stack_sst.

      rewrite smap_preserved_when_updating_stack_sst in E_add_to_smap'.
      rewrite E_get_smap_sst in E_add_to_smap'.
      simpl in E_add_to_smap'.
      injection E_add_to_smap' as E_add_to_smap'_key E_add_to_smap'_maxid E_add_to_smap'_bs.

      unfold eval_sstack'. 
      unfold map_option.
      rewrite <- map_option_ho.
      
      rewrite <- E_get_smap_sst in E_add_to_smap.

      pose proof (eval_sstack_mapo_preserved_when_smap_extended (get_stack_sst sst) sst init_st maxid maxid' sb sb' (SymPUSHTAG v) ops key' stk'' H_valid_sst E_get_smap_sst E_add_to_smap  E_eval_sstack) as E_eval_sstack_1.

      rewrite E_eval_sstack_1.

      rewrite <- E_add_to_smap'_bs.
      unfold eval_sstack_val.
      fold eval_sstack_val.

      apply Nat.eqb_eq in E_add_to_smap'_key as E_add_to_smap'_key_eqb.
      rewrite E_add_to_smap'_key_eqb.

      rewrite H_st_eq_st'.
      rewrite <- H_st_inst_sst'_l.

      unfold make_st.
      simpl.
      reflexivity.
Qed.


Lemma pop_succ:
  forall init_st st sst ops l,
    st_is_instance_of_sst init_st st sst ops ->
    pop (get_stack_sst sst) = Some l ->
    exists v1 v2 l', (get_stack_sst sst)=v1::l /\ get_stack_st st = v2::l'.
Proof.
  intros.
  unfold pop in H0.
  destruct (get_stack_sst sst) eqn:E_stk_sst; try discriminate.
  injection H0. intros.
  rewrite H1.
  exists s.
  unfold st_is_instance_of_sst in H.
  destruct H as [st' H].
  destruct H.
  unfold eval_sstate in H.
  unfold eval_sstack in H.
  destruct (length (get_stack_st init_st) =? get_instk_height_sst sst) eqn:E_len; try discriminate.
  destruct (get_smap_sst sst) as [maxid map0] eqn:E_map.
  rewrite E_stk_sst in H.
  simpl in H.
  destruct (eval_sstack_val s (get_stack_st init_st) (get_memory_st init_st)
              (get_storage_st init_st) (get_context_st init_st) map0 ops) in H; try discriminate.
  destruct (eval_sstack' s0 (get_stack_st init_st) (get_memory_st init_st)
            (get_storage_st init_st) (get_context_st init_st) map0 ops) in H; try discriminate.
  destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st) 
              (get_storage_st init_st) (get_context_st init_st) sst ops) in H; try discriminate.
  destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st) 
              (get_storage_st init_st) (get_context_st init_st) sst ops) in H; try discriminate.
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

  destruct (length (get_stack_st init_st) =? get_instk_height_sst sst) eqn:E_len; try discriminate.

  destruct ( get_smap_sst sst ) as [maxid bs] eqn:E_smap.

  destruct (map_option
           (fun sv : sstack_val =>
            eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st)
              (get_storage_st init_st) (get_context_st init_st) bs ops) 
           (v1 :: l)) as [stk|] eqn:E_mapo; try discriminate.

  destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st) 
              (get_storage_st init_st) (get_context_st init_st) sst ops) as [mem|] eqn:E_mem; try discriminate.

  destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st)
              (get_storage_st init_st) (get_context_st init_st) sst ops) as [srtg|] eqn:E_strg; try discriminate.

  unfold make_st in H1.
  apply map_option_len in E_mapo as E_mapo_1.
  destruct stk; try discriminate.
  apply map_option_hd in E_mapo.
  destruct E_mapo.
  
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
  intros sst sst' ops H_valid_sst H_pop_s.
  split.
  - pose proof (pop_valid_sst sst sst' ops H_valid_sst H_pop_s) as H_valid_sst'. apply H_valid_sst'.
  - intros init_st st H_st_inst_sst. 
    unfold pop_s in H_pop_s.
    destruct (pop (get_stack_sst sst)) eqn:H_pop_sst; try discriminate.
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


Lemma eval_sstack'_hd:
  forall (sstk: sstack) (stk stk': stack) (mem: memory) (strg: storage) (ctx: context) (sb: sbindings) (ops: stack_op_instr_map) (sv: sstack_val) (v : EVMWord),
    eval_sstack' (sv :: sstk) stk mem strg ctx sb ops = Some (v :: stk') ->
    eval_sstack' sstk stk mem strg ctx sb ops = Some stk'.
Proof.
  intros.
  unfold eval_sstack' in H.
  apply map_option_hd in H.
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
    destruct sstk; destruct stk'; try discriminate.
    simpl in H0. injection H0 as H0.       
    simpl in H1. injection H1 as H1.
    unfold eval_sstack' in H.
    unfold map_option in H.
    rewrite <- map_option_ho in H.
    destruct (eval_sstack_val s stk mem strg ctx sb ops) eqn:E_eval_sstack_val; try discriminate.
    destruct (map_option (fun elem : sstack_val => eval_sstack_val elem stk mem strg ctx sb ops) sstk) eqn:E_mapo; try discriminate.
    injection H. intros.
    rewrite H0 in E_eval_sstack_val.
    rewrite H3 in E_eval_sstack_val. rewrite H1 in E_eval_sstack_val.
    apply E_eval_sstack_val.
  - intros.
    destruct sstk; destruct stk'; try discriminate.
    simpl in H0.
    simpl in H1.
    apply eval_sstack'_hd in H.
    pose proof (IHk' sstk stk stk' mem strg ctx sb ops sv v H H0 H1).
    apply H2.
Qed.


Lemma dup_snd:
  forall k, snd_state_transformer (dup_c k) (dup_s k).       
Proof.
  unfold snd_state_transformer.
  intros k sst sst' ops H_valid_sst H_dup_s.
  split.
  - pose proof (dup_valid_sst sst sst' ops k H_valid_sst H_dup_s) as H_valid_sst'. apply H_valid_sst'.
  - intros init_st st H_st_inst_sst.
    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as [H_st_sst_stk_len H_init_st_len_sst].
    unfold dup_s in H_dup_s.
    unfold dup in H_dup_s.
    destruct ((k =? 0) || (16 <? k) || (StackSize <=? length (get_stack_sst sst))) eqn:E_dup_s_k; try discriminate.
    destruct (nth_error (get_stack_sst sst) (pred k)) as [sv|] eqn:E_sst_nth_err; try discriminate.
    unfold dup_c.
    unfold dup.
    rewrite <- H_st_sst_stk_len.
    rewrite E_dup_s_k.
    pose proof (nth_err_two_lists sstack_val EVMWord (get_stack_sst sst) (get_stack_st st) (pred k) sv H_st_sst_stk_len E_sst_nth_err) as H_st_nth_err.
    destruct H_st_nth_err as [v' H_st_nth_err].
    rewrite H_st_nth_err.
    exists (set_stack_st st (v' :: get_stack_st st)).
    split; try reflexivity.
    injection H_dup_s as H_sst'.
    rewrite <- H_sst'.
    unfold st_is_instance_of_sst.
    exists (set_stack_st st (v' :: get_stack_st st)).
    split.
    + unfold st_is_instance_of_sst in H_st_inst_sst.
      destruct H_st_inst_sst as [st' H_st_inst_sst].
      destruct H_st_inst_sst as [H_st_inst_sst_l H_st_inst_sst_r].
      unfold eval_sstate in H_st_inst_sst_l.
      unfold eval_sstack in H_st_inst_sst_l.
      apply Nat.eqb_eq in H_init_st_len_sst as H_init_st_len_sst_eqb.
      rewrite H_init_st_len_sst_eqb in H_st_inst_sst_l.
      destruct (get_smap_sst sst) as [maxid bs] eqn:E_smap.
             
      destruct (eval_sstack' (get_stack_sst sst) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) bs ops) as [stk|] eqn:E_eval_sstack'; try discriminate.
      destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [mem|] eqn:E_eval_smemory; try discriminate.
      destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [strg|] eqn:E_eval_sstorage; try discriminate.
             
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
      unfold map_option.
      rewrite <- map_option_ho.
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
    + apply eq_execution_states_refl.
Qed.

Lemma swap_0:
  forall (A B: Type) (k: nat) (l1 : list A) (l2 : list B) (l : list A),
    length l1 = length l2 ->
    swap k l1 = Some l ->
    exists (l' : list B), swap k l2 = Some l'.   
Proof.
  intros.
  unfold swap in H0.
  destruct ((k =? 0) || (16 <? k)) eqn:E_k.
  discriminate.
  destruct (nth_error l1 k) eqn:E_nth_err.
  2: discriminate.
  destruct l1 eqn:E_l1.
  discriminate.
  injection H0. intro.
  unfold swap.
  rewrite E_k.
  pose proof (nth_err_two_lists A B (a0::l0) l2 k a H E_nth_err).
  destruct H2.
  rewrite H2.
  destruct l2.
  discriminate.
  exists ([x] ++ firstn (k - 1) l2 ++ [b] ++ skipn (k + 1) (b :: l2)).
  reflexivity.
Qed.
  
  
Lemma swap_1:
  forall init_st st sst ops k l,
    st_is_instance_of_sst init_st st sst ops ->
    swap k (get_stack_sst sst) = Some l ->
    exists l', swap k (get_stack_st st) = Some l'.   
Proof.
  intros.
  pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H).
  destruct H1.
  pose proof (swap_0 sstack_val EVMWord k (get_stack_sst sst) (get_stack_st st) l H1 H0).
  apply H3.
Qed.

Lemma firstn_skipn_two_lists:
  forall {T1 T2: Type} (n: nat) (l1: list T1) (l2: list T2),
    length l1 = length l2 ->
    length (skipn n l1) = length (skipn n l2) /\
    length (firstn n l1) = length (firstn n l2).
Proof.
  induction n as [|n' IHn'].
  - intros. simpl. auto.
  - intros.
    destruct l1 as [|a l1'].
    + destruct l2 as [|b l2'].
      ++ simpl. auto.
      ++ discriminate.
    + destruct l2 as [|b l2']; try discriminate.
      simpl.
      simpl in H. injection H as H.
      pose proof (IHn' l1' l2' H).
      intuition.
Qed.


Lemma eval_sstack'_swap:
  forall sstk sstk' stk mem strg ctx sb ops stk' k,
  eval_sstack' sstk stk mem strg ctx sb ops = Some stk' ->
  swap k sstk = Some sstk' ->
  eval_sstack' sstk' stk mem strg ctx sb ops = swap k stk'.
Proof.
  intros sstk sstk' stk mem strg ctx sb ops stk' k H_eval_sstack' H_swap_s.
  unfold swap in H_swap_s.
  destruct ((k =? 0) || (16 <? k)) eqn:E_k; try discriminate.
  destruct (nth_error sstk k) as [sv|] eqn:E_nth_err; try  discriminate.
  destruct sstk as [|e sstk'']; try discriminate.
  pose proof (eval_sstack'_len (e :: sstk'') stk stk' mem strg ctx sb ops H_eval_sstack') as H_sstk_stk'_len.
  pose proof (nth_err_two_lists sstack_val EVMWord (e::sstk'') stk' k sv H_sstk_stk'_len E_nth_err) as H_nth_err_stk'.
  destruct H_nth_err_stk' as [v' H_nth_err_stk'].
  unfold swap.
  rewrite E_k.
  rewrite  H_nth_err_stk'.
  destruct stk' as [|e' stk''] eqn:E_stk'; try discriminate.
  injection H_swap_s as H_swap_s.
  pose proof (skipn_nth sstack_val (e :: sstk'') k sv E_nth_err) as H_skipn_nth_1.
  pose proof (skipn_nth EVMWord (e' :: stk'') k v' H_nth_err_stk') as H_skipn_nth_2.
  rewrite H_skipn_nth_1 in H_eval_sstack'.
  rewrite H_skipn_nth_2 in H_eval_sstack'.
  destruct k as [|k'] eqn:E_k'; try discriminate.

  assert( H_Sk1: S k' + 1 = S (k' + 1)). reflexivity.
  assert(H_app_cons: forall A (e:A) (l: list A), e::l=[e]++l). reflexivity.

  repeat rewrite firstn_cons in H_eval_sstack'.
  repeat rewrite H_Sk1 in H_eval_sstack'. 
  repeat rewrite skipn_cons in H_eval_sstack'.
  rewrite H_app_cons  with (e:=e)(l:=firstn k' sstk'') in H_eval_sstack'.
  rewrite H_app_cons  with (e:=sv)(l:=skipn (k' + 1) sstk'') in H_eval_sstack'.
  rewrite H_app_cons  with (e:=e')(l:=firstn k' stk'') in H_eval_sstack'.
  rewrite H_app_cons  with (e:=v')(l:=skipn (k' + 1) stk'') in H_eval_sstack'.
  unfold eval_sstack' in  H_eval_sstack'.
  
  assert (H_len1: length [e] = length [e']). reflexivity.
  assert (H_len2: length (firstn k' sstk'')= length (firstn k' stk'')). repeat rewrite firstn_length. auto.
  assert (H_len3: length [sv] = length [v']). reflexivity.
  assert (H_len4: length (skipn (k' + 1) sstk'') = length (skipn (k' + 1) stk'')). repeat rewrite skipn_length. auto.

  repeat rewrite <- app_assoc in H_eval_sstack'.
  pose proof (map_option_swap sstack_val EVMWord (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx sb ops) [e] (firstn k' sstk'') [sv] (skipn (k' + 1) sstk'') [e'] (firstn k' stk'') [v'] (skipn (k' + 1) stk'') H_len1 H_len2 H_len3 H_len4 H_eval_sstack') as H_mapo_app2.

  rewrite <- H_swap_s.

  assert ( H_Skm1: S k' - 1 = k' ). intuition.
  rewrite H_Skm1.
  rewrite H_Sk1.
  repeat rewrite skipn_cons.
  unfold eval_sstack'.
  apply H_mapo_app2.
Qed.

Lemma swap_snd:
  forall k, snd_state_transformer (swap_c k) (swap_s k).
Proof.
  unfold snd_state_transformer.
  intros k sst sst' ops H_valid_sst H_swap_s.
  split.
  - pose proof (swap_valid_sst sst sst' ops k H_valid_sst H_swap_s) as H_valid_sst'. apply H_valid_sst'.
 
  - intros init_st st H_st_inst_sst.
    unfold swap_s in H_swap_s.
    destruct (swap k (get_stack_sst sst)) eqn:E_swap; try discriminate.
    unfold swap_c.
    pose proof (swap_1 init_st st sst ops k l H_st_inst_sst E_swap) as H_swap_1.
    destruct H_swap_1 as [l' H_swap_1].
    rewrite H_swap_1.
    exists (set_stack_st st l').
    split; try reflexivity.
    unfold st_is_instance_of_sst.
    exists (set_stack_st st l').
    split.
    2: apply eq_execution_states_refl.
    assert (H_st_inst_sst_0:=H_st_inst_sst).
    unfold st_is_instance_of_sst in H_st_inst_sst.
    destruct H_st_inst_sst as [st' H_st_inst_sst].
    destruct H_st_inst_sst as [H_st_inst_sst_1 H_st_inst_sst_2].
    unfold eval_sstate in   H_st_inst_sst_1.
    destruct (eval_sstack (get_stack_st init_st) (get_memory_st init_st)
                (get_storage_st init_st) (get_context_st init_st) sst ops) as [stk|] eqn:E_eval_sstack; try discriminate.
    destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st)
                (get_storage_st init_st) (get_context_st init_st) sst ops) as [mem|] eqn:E_eval_smem; try discriminate.
    destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st)
                (get_storage_st init_st) (get_context_st init_st) sst ops) as [strg|] eqn:E_eval_sstrg; try discriminate.
    injection H_st_inst_sst_1 as H_st_inst_sst_1.
    injection H_swap_s as H_swap_s.
    unfold eval_sstate.
    rewrite <- H_swap_s.
    rewrite <- eval_smemory_preserved_when_sstack_changed.
    rewrite E_eval_smem.
    rewrite <- eval_sstorage_preserved_when_sstack_changed.
    rewrite E_eval_sstrg.
    unfold eval_sstack.
    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst_0) as H_st_is_instance_of_sst_stk_len.
    destruct H_st_is_instance_of_sst_stk_len as [H_st_is_instance_of_sst_stk_len_0 H_st_is_instance_of_sst_stk_len_1].
    rewrite <- Nat.eqb_eq in H_st_is_instance_of_sst_stk_len_1.
    rewrite instk_height_preserved_when_updating_stack_sst.  
    rewrite H_st_is_instance_of_sst_stk_len_1.
    destruct (get_smap_sst (set_stack_sst sst l)) eqn:E_smap.
    unfold eval_sstack in E_eval_sstack.
    rewrite H_st_is_instance_of_sst_stk_len_1 in E_eval_sstack.
    rewrite smap_preserved_when_updating_stack_sst in E_smap.
    rewrite E_smap in E_eval_sstack.
    pose proof (eval_sstack'_swap (get_stack_sst sst) l (get_stack_st init_st)
                  (get_memory_st init_st) (get_storage_st init_st) 
                  (get_context_st init_st) bindings ops stk k E_eval_sstack E_swap) as H_eval_sstack'_swap.
    rewrite set_and_then_get_stack_sst.
    rewrite H_eval_sstack'_swap.
    pose proof (eq_execution_states_ext st st' H_st_inst_sst_2) as H_eq_st_st'.
    rewrite H_eq_st_st' in H_swap_1.
    rewrite <- H_st_inst_sst_1 in H_swap_1.
    simpl in H_swap_1.
    rewrite H_swap_1.
    rewrite H_eq_st_st'.
    rewrite <- H_st_inst_sst_1.
    reflexivity.
Qed.


Lemma sload_snd:
  snd_state_transformer sload_c sload_s.
Proof.
  unfold snd_state_transformer.
  intros sst sst' ops H_valid_sst H_sload_s.
  split.
  - pose proof (sload_valid_sst sst sst' ops H_valid_sst H_sload_s) as H_valid_sst'. apply H_valid_sst'.
  - intros init_st st H_st_inst_sst.
    unfold sload_s in H_sload_s.
    destruct (get_stack_sst sst) as [|skey sstk] eqn:E_sstk_sst; try discriminate.
    destruct (add_to_smap (get_smap_sst sst) (SymSLOAD skey (get_storage_sst sst))) as [key sm'] eqn:E_add_to_smap.

    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as E_stack_len_st_eq_sst.
    destruct E_stack_len_st_eq_sst as [E_stack_len_st_eq_sst_l E_stack_len_st_eq_sst_r].

    unfold sload_c.
    
    destruct (get_stack_st st) as [|ckey stk] eqn:E_stk_st.
    rewrite E_sstk_sst in E_stack_len_st_eq_sst_l.
    discriminate. (* case of [] *)

    exists (set_stack_st st (sload (get_storage_st st) ckey :: stk)).
    split.
    reflexivity. (* left side of conjunction *)

    unfold st_is_instance_of_sst.
    exists (set_stack_st st (sload (get_storage_st st) ckey :: stk)).
    split.
    2: apply eq_execution_states_refl.

    unfold eval_sstate.

    assert (H_st_inst_sst' := H_st_inst_sst).
    unfold st_is_instance_of_sst in H_st_inst_sst'.
    destruct H_st_inst_sst' as [st' H_st_inst_sst'].
    destruct H_st_inst_sst' as [H_st_inst_sst'_l H_st_inst_sst'_r].

    pose proof (eq_execution_states_ext st st' H_st_inst_sst'_r) as H_st_eq_st'.
    
    unfold eval_sstate in H_st_inst_sst'_l.

    destruct (eval_sstack (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [stk''|] eqn:E_eval_sstack; try discriminate.
    destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [mem|] eqn:E_mem; try discriminate.
    destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [strg|] eqn:E_strg; try discriminate.

    injection H_st_inst_sst'_l as H_st_inst_sst'_l.

    pose proof (valid_sstate_sstack_change sst (FreshVar key :: sstk)  H_valid_sst) as H_valid_sst_with_fresh_var.

    pose proof (smap_preserved_when_updating_stack_sst sst (FreshVar key :: sstk)) as E_get_smap_with_stk_fresh_var.
    
    assert(E_add_to_smap' := E_add_to_smap).
    rewrite <-  E_get_smap_with_stk_fresh_var in E_add_to_smap'.

    injection H_sload_s as H_sload_s.
    rewrite <- H_sload_s.

    (* equivalence of eval_smemory *)
    pose proof (eval_smemory_preserved_when_sstack_changed (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops (FreshVar key :: sstk)) as E_eval_smemory_0.
    rewrite E_eval_smemory_0 in E_mem.

    pose proof (eval_smemory_preserved_when_smap_extended (set_stack_sst sst (FreshVar key :: sstk)) init_st sm' (SymSLOAD skey (get_storage_sst sst)) ops key mem H_valid_sst_with_fresh_var E_add_to_smap' E_mem) as E_eval_smemory_1.

    rewrite E_eval_smemory_1.

    (* equivalence of eval_sstorage *)
    pose proof (eval_sstorage_preserved_when_sstack_changed (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops (FreshVar key :: sstk)) as E_eval_sstorage_0.

    rewrite E_eval_sstorage_0 in E_strg.

    pose proof (eval_sstorage_preserved_when_smap_extended (set_stack_sst sst (FreshVar key :: sstk)) init_st sm' (SymSLOAD skey (get_storage_sst sst)) ops key strg H_valid_sst_with_fresh_var E_add_to_smap' E_strg) as E_eval_sstorage_1.

    rewrite E_eval_sstorage_1.

    (* the case of eval_sstack *)
    unfold eval_sstack in E_eval_sstack.

    apply Nat.eqb_eq in E_stack_len_st_eq_sst_r as E_stack_len_st_eq_sst_r_eqb.
    apply Nat.eqb_eq in E_stack_len_st_eq_sst_l as E_stack_len_st_eq_sst_l_eqb.

    rewrite E_stack_len_st_eq_sst_r_eqb in E_eval_sstack.
    destruct (get_smap_sst sst) as [maxid sb] eqn:E_get_smap_sst.
    rewrite E_sstk_sst in E_eval_sstack.

    unfold eval_sstack' in E_eval_sstack.
    pose proof (map_option_len
                  sstack_val
                  EVMWord
                  (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)
                  (skey :: sstk)
                  stk''
                  E_eval_sstack) as H_stk''_len.
    destruct stk''  as [| ckey1 stk''']; try discriminate.

    pose proof (map_option_hd
                  sstack_val
                  EVMWord
                  (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)
                  sstk
                  stk'''
                  skey ckey1 E_eval_sstack) as [E_eval_sstack_1 E_eval_sstack_2].

    unfold eval_sstack.

    rewrite instk_height_preserved_when_updating_smap_sst.
    rewrite instk_height_preserved_when_updating_stack_sst.
    rewrite E_stack_len_st_eq_sst_r_eqb.
    rewrite set_and_then_get_smap_sst.

    destruct sm' as [maxid' sb'].

    rewrite sstack_preserved_when_updating_smap_sst.
    rewrite set_and_then_get_stack_sst.

    rewrite smap_preserved_when_updating_stack_sst in E_add_to_smap'.
    rewrite E_get_smap_sst in E_add_to_smap'.
    simpl in E_add_to_smap'.
    injection E_add_to_smap' as E_add_to_smap'_key E_add_to_smap'_maxid E_add_to_smap'_bs.

    unfold eval_sstack'. 
    unfold map_option.
    rewrite <- map_option_ho.

    rewrite <- E_get_smap_sst in E_add_to_smap.

    pose proof (eval_sstack_mapo_preserved_when_smap_extended sstk sst init_st maxid maxid' sb sb' (SymSLOAD skey (get_storage_sst sst)) ops key stk''' H_valid_sst E_get_smap_sst E_add_to_smap  E_eval_sstack_2) as E_eval_sstack_3.

    rewrite E_eval_sstack_3.

    rewrite <- E_add_to_smap'_bs.
    unfold eval_sstack_val.
    fold eval_sstack_val.

    apply Nat.eqb_eq in E_add_to_smap'_key as E_add_to_smap'_key_eqb.
    rewrite E_add_to_smap'_key_eqb.

    unfold eval_sstorage in E_strg.
    rewrite smap_preserved_when_updating_stack_sst in E_strg.
    rewrite E_get_smap_sst in E_strg.

    destruct (map_option
               (eval_common.EvalCommon.instantiate_storage_update
                  (fun sv : sstack_val =>
                   eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st)
                     (get_context_st init_st) sb ops))
               (get_storage_sst (set_stack_sst sst (FreshVar key :: sstk)))) as [updates|] eqn:E_strg_mapo; try discriminate.

    rewrite sstorage_preserved_when_updating_stack_sst in E_strg_mapo.
    rewrite E_strg_mapo.
    rewrite E_eval_sstack_1.

    unfold eq_execution_states in H_st_inst_sst'_r.
    rewrite H_st_eq_st'.
    rewrite <- H_st_inst_sst'_l.
    unfold make_st.
    simpl.
    injection E_strg as E_strg.
    rewrite E_strg.

    assert(E_stk_st' := E_stk_st).
    rewrite H_st_eq_st' in E_stk_st'.
    
    rewrite <- H_st_inst_sst'_l in E_stk_st'.
    simpl in E_stk_st'.
    injection E_stk_st' as E_stk_st'_ckey E_stk_st'_stk.
    rewrite E_stk_st'_ckey.
    rewrite E_stk_st'_stk.
    reflexivity.
Qed.

Lemma sstore_snd:
  snd_state_transformer sstore_c sstore_s.
Proof.
  unfold snd_state_transformer.
  intros sst sst' ops H_valid_sst H_sstore_s.
  split.
  - pose proof (sstore_valid_sst sst sst' ops H_valid_sst H_sstore_s) as H_valid_sst'. apply H_valid_sst'.
  - intros init_st st H_st_inst_sst.
    unfold sstore_s in H_sstore_s.
    destruct (get_stack_sst sst) as [|skey sstk] eqn:E_sstk_sst; try discriminate.
    destruct sstk as [|svalue sstk'] eqn:E_sstk'_sst; try discriminate.
    injection H_sstore_s as H_sstore_s.

    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as E_stack_len_st_eq_sst.
    destruct E_stack_len_st_eq_sst as [E_stack_len_st_eq_sst_l E_stack_len_st_eq_sst_r].

    unfold sstore_c.
 
    destruct (get_stack_st st) as [|ckey stk] eqn:E_stk_st.
    rewrite E_sstk_sst in E_stack_len_st_eq_sst_l. discriminate. (* case of [] *)
    destruct stk as [|cvalue stk'] eqn:E_stk'_st.
    rewrite E_sstk_sst in E_stack_len_st_eq_sst_l. discriminate. (* case of [] *)

    exists (set_stack_st (set_store_st st (sstore (get_storage_st st) ckey cvalue)) stk').
    split.
    reflexivity. (* left side of conjunction *)

    unfold st_is_instance_of_sst.
    exists (set_stack_st (set_store_st st (sstore (get_storage_st st) ckey cvalue)) stk').
    split.
    2: apply eq_execution_states_refl.

    unfold eval_sstate.

    assert (H_st_inst_sst' := H_st_inst_sst).
    unfold st_is_instance_of_sst in H_st_inst_sst'.
    destruct H_st_inst_sst' as [st' H_st_inst_sst'].
    destruct H_st_inst_sst' as [H_st_inst_sst'_l H_st_inst_sst'_r].

    pose proof (eq_execution_states_ext st st' H_st_inst_sst'_r) as H_st_eq_st'.

    unfold eval_sstate in H_st_inst_sst'_l.

    destruct (eval_sstack (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [stk''|] eqn:E_eval_sstack; try discriminate.
    destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [mem|] eqn:E_mem; try discriminate.
    destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [strg|] eqn:E_strg; try discriminate.

    injection H_st_inst_sst'_l as H_st_inst_sst'_l. 

    (* case of eval_sstack *)
    unfold eval_sstack in E_eval_sstack.
    destruct (length (get_stack_st init_st) =? get_instk_height_sst sst) eqn:E_stk_len; try discriminate.
    destruct (get_smap_sst sst) as [maxid sb] eqn:E_get_smap_sst.
    unfold eval_sstack' in E_eval_sstack.
    rewrite E_sstk_sst in E_eval_sstack.

    pose proof (map_option_len
                  sstack_val
                  EVMWord
                  (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)
                  (skey :: svalue :: sstk')
                  stk''
                  E_eval_sstack) as H_stk''_len.


    destruct stk''  as [| ckey1 stk''']; try discriminate.
    destruct stk''' as [| cvalue1 stk'''']; try discriminate.

    pose proof (map_option_hd
                  sstack_val
                  EVMWord
                  (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)
                  (svalue :: sstk')
                  (cvalue1 :: stk'''')
                  skey ckey1 E_eval_sstack) as [E_eval_sstack_1 E_eval_sstack_2].
    pose proof (map_option_hd
                  sstack_val
                  EVMWord
                  (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)
                  sstk'
                  stk''''
                  svalue cvalue1 E_eval_sstack_2) as [E_eval_sstack_3 E_eval_sstack_4].

    unfold eval_sstack.
    rewrite <- H_sstore_s.
    rewrite instk_height_preserved_when_updating_stack_sst.
    rewrite instk_height_preserved_when_updating_storage_sst.
    rewrite E_stk_len.
    rewrite smap_preserved_when_updating_stack_sst.
    rewrite smap_preserved_when_updating_storage_sst.
    rewrite E_get_smap_sst.
    rewrite set_and_then_get_stack_sst.

    unfold eval_sstack'.
    rewrite E_eval_sstack_4.
 
    (* The case of eval_smemory *)
    unfold eval_smemory in E_mem.
    rewrite E_get_smap_sst in E_mem.
    destruct (map_option
              (eval_common.EvalCommon.instantiate_memory_update
                 (fun sv : sstack_val =>
                    eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)) (get_memory_sst sst)) as [mem'|] eqn:E_mem_mapo; try discriminate.

    unfold eval_smemory.
    rewrite smap_preserved_when_updating_stack_sst.
    rewrite smap_preserved_when_updating_storage_sst.
    rewrite E_get_smap_sst.
    rewrite smemory_preserved_when_updating_stack_sst.
    rewrite smemory_preserved_when_updating_storage_sst.
    rewrite E_mem_mapo.

    (* The case of eval_sstorage *)
    unfold eval_sstorage.
    rewrite smap_preserved_when_updating_stack_sst.
    rewrite smap_preserved_when_updating_storage_sst.
    rewrite E_get_smap_sst.

    rewrite sstorage_preserved_when_updating_stack_sst.
    rewrite set_and_then_get_storage_sst.

    unfold eval_common.EvalCommon.instantiate_storage_update.
    unfold map_option.
    rewrite <- map_option_ho.
    rewrite E_eval_sstack_1.
    rewrite E_eval_sstack_3.

    unfold eval_sstorage in E_strg.
    rewrite E_get_smap_sst in E_strg.
    destruct (map_option
               (eval_common.EvalCommon.instantiate_storage_update
                  (fun sv : sstack_val =>
                     eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)) (get_storage_sst sst)) as [strg'|] eqn:E_strg_mapo; try discriminate.
    unfold eval_common.EvalCommon.instantiate_storage_update in E_strg_mapo.
    rewrite E_strg_mapo.
    rewrite H_st_eq_st'.
    rewrite <- H_st_inst_sst'_l.
    simpl.
    unfold make_st.
    injection E_mem as E_mem.
    rewrite E_mem.
    injection E_strg as E_strg.
    rewrite E_strg.

    assert(E_stk_st' := E_stk_st).
    rewrite H_st_eq_st' in E_stk_st'.
    
    rewrite <- H_st_inst_sst'_l in E_stk_st'.
    simpl in E_stk_st'.
    injection E_stk_st' as E_stk_st'_key E_stk_st'_value E_stk_st'_stk.
    rewrite E_stk_st'_key.
    rewrite E_stk_st'_value.
    rewrite E_stk_st'_stk.
    reflexivity.
Qed.

Lemma mload_snd:
  snd_state_transformer mload_c mload_s.
Proof.
  unfold snd_state_transformer.
  intros sst sst' ops H_valid_sst H_mload_s.
  split.
  - pose proof (mload_valid_sst sst sst' ops H_valid_sst H_mload_s) as H_valid_sst'. apply H_valid_sst'.
  - intros init_st st H_st_inst_sst.
    unfold mload_s in H_mload_s.
    destruct (get_stack_sst sst) as [|soffset sstk] eqn:E_sstk_sst; try discriminate.
    destruct (add_to_smap (get_smap_sst sst) (SymMLOAD soffset (get_memory_sst sst))) as [key sm'] eqn:E_add_to_smap.

    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as E_stack_len_st_eq_sst.
    destruct E_stack_len_st_eq_sst as [E_stack_len_st_eq_sst_l E_stack_len_st_eq_sst_r].

    unfold mload_c.
    
    destruct (get_stack_st st) as [|offset stk] eqn:E_stk_st.
    rewrite E_sstk_sst in E_stack_len_st_eq_sst_l. discriminate. (* case of [] *)

    exists (set_stack_st st (mload (get_memory_st st) offset :: stk)).
    split.
    reflexivity. (* left side of conjunction *)

    unfold st_is_instance_of_sst.
    exists (set_stack_st st (mload (get_memory_st st) offset :: stk)).
    split.
    2: apply eq_execution_states_refl.

    unfold eval_sstate.

    assert (H_st_inst_sst' := H_st_inst_sst).
    unfold st_is_instance_of_sst in H_st_inst_sst'.
    destruct H_st_inst_sst' as [st' H_st_inst_sst'].
    destruct H_st_inst_sst' as [H_st_inst_sst'_l H_st_inst_sst'_r].

    pose proof (eq_execution_states_ext st st' H_st_inst_sst'_r) as H_st_eq_st'.
    
    unfold eval_sstate in H_st_inst_sst'_l.

    destruct (eval_sstack (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [stk''|] eqn:E_eval_sstack; try discriminate.
    destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [mem|] eqn:E_mem; try discriminate.
    destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [strg|] eqn:E_strg; try discriminate.

    injection H_st_inst_sst'_l as H_st_inst_sst'_l.

    pose proof (valid_sstate_sstack_change sst (FreshVar key :: sstk)  H_valid_sst) as H_valid_sst_with_fresh_var.

    pose proof (smap_preserved_when_updating_stack_sst sst (FreshVar key :: sstk)) as E_get_smap_with_stk_fresh_var.
    
    assert(E_add_to_smap' := E_add_to_smap).
    rewrite <-  E_get_smap_with_stk_fresh_var in E_add_to_smap'.

    injection H_mload_s as H_mload_s.
    rewrite <- H_mload_s.

    (* equivalence of eval_smemory *)
    pose proof (eval_smemory_preserved_when_sstack_changed (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops (FreshVar key :: sstk)) as E_eval_smemory_0.
    rewrite E_eval_smemory_0 in E_mem.

    pose proof (eval_smemory_preserved_when_smap_extended (set_stack_sst sst (FreshVar key :: sstk)) init_st sm' (SymMLOAD soffset (get_memory_sst sst)) ops key mem H_valid_sst_with_fresh_var E_add_to_smap' E_mem) as E_eval_smemory_1.

    rewrite E_eval_smemory_1.

        (* equivalence of eval_sstorage *)
    pose proof (eval_sstorage_preserved_when_sstack_changed (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops (FreshVar key :: sstk)) as E_eval_sstorage_0.

    rewrite E_eval_sstorage_0 in E_strg.

    pose proof (eval_sstorage_preserved_when_smap_extended (set_stack_sst sst (FreshVar key :: sstk)) init_st sm' (SymMLOAD soffset (get_memory_sst sst)) ops key strg H_valid_sst_with_fresh_var E_add_to_smap' E_strg) as E_eval_sstorage_1.

    rewrite E_eval_sstorage_1.

    (* the case of eval_sstack *)
    unfold eval_sstack in E_eval_sstack.

    apply Nat.eqb_eq in E_stack_len_st_eq_sst_r as E_stack_len_st_eq_sst_r_eqb.
    apply Nat.eqb_eq in E_stack_len_st_eq_sst_l as E_stack_len_st_eq_sst_l_eqb.

    rewrite E_stack_len_st_eq_sst_r_eqb in E_eval_sstack.
    destruct (get_smap_sst sst) as [maxid sb] eqn:E_get_smap_sst.
    rewrite E_sstk_sst in E_eval_sstack.

    unfold eval_sstack' in E_eval_sstack.
    pose proof (map_option_len
                  sstack_val
                  EVMWord
                  (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)
                  (soffset :: sstk)
                  stk''
                  E_eval_sstack) as H_stk''_len.
    destruct stk''  as [| offset1 stk''']; try discriminate.

    pose proof (map_option_hd
                  sstack_val
                  EVMWord
                  (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)
                  sstk
                  stk'''
                  soffset offset1 E_eval_sstack) as [E_eval_sstack_1 E_eval_sstack_2].

    unfold eval_sstack.

    rewrite instk_height_preserved_when_updating_smap_sst.
    rewrite instk_height_preserved_when_updating_stack_sst.
    rewrite E_stack_len_st_eq_sst_r_eqb.
    rewrite set_and_then_get_smap_sst.

    destruct sm' as [maxid' sb'].

    rewrite sstack_preserved_when_updating_smap_sst.
    rewrite set_and_then_get_stack_sst.

    rewrite smap_preserved_when_updating_stack_sst in E_add_to_smap'.
    rewrite E_get_smap_sst in E_add_to_smap'.
    simpl in E_add_to_smap'.
    injection E_add_to_smap' as E_add_to_smap'_key E_add_to_smap'_maxid E_add_to_smap'_bs.

    unfold eval_sstack'. 
    unfold map_option.
    rewrite <- map_option_ho.

    rewrite <- E_get_smap_sst in E_add_to_smap.

    pose proof (eval_sstack_mapo_preserved_when_smap_extended sstk sst init_st maxid maxid' sb sb' (SymMLOAD soffset (get_memory_sst sst)) ops key stk''' H_valid_sst E_get_smap_sst E_add_to_smap  E_eval_sstack_2) as E_eval_sstack_3.

    rewrite E_eval_sstack_3.

    rewrite <- E_add_to_smap'_bs.
    unfold eval_sstack_val.
    fold eval_sstack_val.

    apply Nat.eqb_eq in E_add_to_smap'_key as E_add_to_smap'_key_eqb.
    rewrite E_add_to_smap'_key_eqb.

    unfold eval_smemory in E_mem.
    rewrite smap_preserved_when_updating_stack_sst in E_mem.
    rewrite E_get_smap_sst in E_mem.

    destruct (map_option
              (eval_common.EvalCommon.instantiate_memory_update
                 (fun sv : sstack_val =>
                  eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)) (get_memory_sst (set_stack_sst sst (FreshVar key :: sstk)))) as [updates|] eqn:E_mem_mapo; try discriminate.

    rewrite smemory_preserved_when_updating_stack_sst in E_mem_mapo.
    rewrite E_mem_mapo.
    rewrite E_eval_sstack_1.

    unfold eq_execution_states in H_st_inst_sst'_r.
    rewrite H_st_eq_st'.
    rewrite <- H_st_inst_sst'_l.
    unfold make_st.
    simpl.
    injection E_mem as E_mem. 
    rewrite E_mem.

    assert(E_stk_st' := E_stk_st).
    rewrite H_st_eq_st' in E_stk_st'.
    
    rewrite <- H_st_inst_sst'_l in E_stk_st'.
    simpl in E_stk_st'.
    injection E_stk_st' as E_stk_st'_offset E_stk_st'_stk.
    rewrite E_stk_st'_offset.
    rewrite E_stk_st'_stk.
    reflexivity.
Qed.

Lemma mstore8_snd:
  snd_state_transformer mstore8_c mstore8_s.
Proof.
  unfold snd_state_transformer.
  intros sst sst' ops H_valid_sst H_mstore8_s.
  split.
  - pose proof (mstore8_valid_sst sst sst' ops H_valid_sst H_mstore8_s) as H_valid_sst'. apply H_valid_sst'.
  - intros init_st st H_st_inst_sst.
    unfold mstore8_s in H_mstore8_s.
    destruct (get_stack_sst sst) as [|soffset sstk] eqn:E_sstk_sst; try discriminate.
    destruct sstk as [|svalue sstk'] eqn:E_sstk'_sst; try discriminate.
    injection H_mstore8_s as H_mstore8_s.
    
    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as E_stack_len_st_eq_sst.
    destruct E_stack_len_st_eq_sst as [E_stack_len_st_eq_sst_l E_stack_len_st_eq_sst_r].
    
    unfold mstore8_c.
     
    destruct (get_stack_st st) as [|coffset stk] eqn:E_stk_st.
    rewrite E_sstk_sst in E_stack_len_st_eq_sst_l. discriminate. (* case of [] *)
    destruct stk as [|cvalue stk'] eqn:E_stk'_st.
    rewrite E_sstk_sst in E_stack_len_st_eq_sst_l. discriminate. (* case of [] *)

    exists (set_stack_st (set_memory_st st (mstore (get_memory_st st) (split1_byte (cvalue:  word ((S (pred BytesInEVMWord))*8))) coffset)) stk').
    
    split.
    reflexivity. (* left side of conjunction *)

    unfold st_is_instance_of_sst.
    exists (set_stack_st (set_memory_st st (mstore (get_memory_st st) (split1_byte (cvalue:  word ((S (pred BytesInEVMWord))*8))) coffset)) stk').
    split.
    2: apply eq_execution_states_refl.

    unfold eval_sstate.

    assert (H_st_inst_sst' := H_st_inst_sst).
    unfold st_is_instance_of_sst in H_st_inst_sst'.
    destruct H_st_inst_sst' as [st' H_st_inst_sst'].
    destruct H_st_inst_sst' as [H_st_inst_sst'_l H_st_inst_sst'_r].

    pose proof (eq_execution_states_ext st st' H_st_inst_sst'_r) as H_st_eq_st'.

    unfold eval_sstate in H_st_inst_sst'_l.

    destruct (eval_sstack (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [stk''|] eqn:E_eval_sstack; try discriminate.
    destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [mem|] eqn:E_mem; try discriminate.
    destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [strg|] eqn:E_strg; try discriminate.

    injection H_st_inst_sst'_l as H_st_inst_sst'_l. 

    (* case of eval_sstack *)
    unfold eval_sstack in E_eval_sstack.
    destruct (length (get_stack_st init_st) =? get_instk_height_sst sst) eqn:E_stk_len; try discriminate.
    destruct (get_smap_sst sst) as [maxid sb] eqn:E_get_smap_sst.
    unfold eval_sstack' in E_eval_sstack.
    rewrite E_sstk_sst in E_eval_sstack.

    pose proof (map_option_len
                  sstack_val
                  EVMWord
                  (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)
                  (soffset :: svalue :: sstk')
                  stk''
                  E_eval_sstack) as H_stk''_len.

    destruct stk''  as [| coffset1 stk''']; try discriminate.
    destruct stk''' as [| cvalue1 stk'''']; try discriminate.

    pose proof (map_option_hd
                  sstack_val
                  EVMWord
                  (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)
                  (svalue :: sstk')
                  (cvalue1 :: stk'''')
                  soffset coffset1 E_eval_sstack) as [E_eval_sstack_1 E_eval_sstack_2].
    pose proof (map_option_hd
                  sstack_val
                  EVMWord
                  (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)
                  sstk'
                  stk''''
                  svalue cvalue1 E_eval_sstack_2) as [E_eval_sstack_3 E_eval_sstack_4].

    unfold eval_sstack.
    rewrite <- H_mstore8_s.
    rewrite instk_height_preserved_when_updating_stack_sst.
    rewrite instk_height_preserved_when_updating_memory_sst.
    rewrite E_stk_len.
    rewrite smap_preserved_when_updating_stack_sst.
    rewrite smap_preserved_when_updating_memory_sst.
    rewrite E_get_smap_sst.
    rewrite set_and_then_get_stack_sst.

    unfold eval_sstack'.
    rewrite E_eval_sstack_4.

    (* The case of eval_sstorage *)
    unfold eval_sstorage in E_strg.
    rewrite E_get_smap_sst in E_strg.
    destruct (map_option
               (eval_common.EvalCommon.instantiate_storage_update
                  (fun sv : sstack_val =>
                     eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)) (get_storage_sst sst)) as [strg'|] eqn:E_strg_mapo; try discriminate.

    unfold eval_sstorage.
    rewrite smap_preserved_when_updating_stack_sst.
    rewrite smap_preserved_when_updating_memory_sst.
    rewrite E_get_smap_sst.
    rewrite sstorage_preserved_when_updating_stack_sst.
    rewrite sstorage_preserved_when_updating_memory_sst.
    rewrite E_strg_mapo.

    (* thge case of eval_smemory *)

    unfold eval_smemory.
    rewrite smap_preserved_when_updating_stack_sst.
    rewrite smap_preserved_when_updating_memory_sst.
    rewrite E_get_smap_sst.

    rewrite smemory_preserved_when_updating_stack_sst.
    rewrite set_and_then_get_memory_sst.

    unfold eval_common.EvalCommon.instantiate_memory_update.
    unfold map_option.
    rewrite <- map_option_ho.
    rewrite E_eval_sstack_1.
    rewrite E_eval_sstack_3.

    unfold eval_smemory in E_mem.
    rewrite E_get_smap_sst in E_mem.
    destruct (map_option
              (eval_common.EvalCommon.instantiate_memory_update
                 (fun sv : sstack_val =>
                  eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)) (get_memory_sst sst)) as [mem'|] eqn:E_mem_mapo; try discriminate.
    unfold eval_common.EvalCommon.instantiate_memory_update in E_mem_mapo.
    rewrite E_mem_mapo. 

    rewrite H_st_eq_st'.
    rewrite <- H_st_inst_sst'_l.
    simpl.
    unfold make_st.
    injection E_mem as E_mem.
    rewrite E_mem.
    injection E_strg as E_strg.
    rewrite E_strg.

    assert(E_stk_st' := E_stk_st).
    rewrite H_st_eq_st' in E_stk_st'.
    
    rewrite <- H_st_inst_sst'_l in E_stk_st'.
    simpl in E_stk_st'.
    injection E_stk_st' as _ _ E_stk_st'_stk.
    rewrite E_stk_st'_stk.
    reflexivity.
Qed.

Lemma mstore_snd:
  snd_state_transformer mstore_c mstore_s.
Proof.
  unfold snd_state_transformer.
  intros sst sst' ops H_valid_sst H_mstore_s.
  split.
  - pose proof (mstore_valid_sst sst sst' ops H_valid_sst H_mstore_s) as H_valid_sst'. apply H_valid_sst'.
  - intros init_st st H_st_inst_sst.
    unfold mstore_s in H_mstore_s.
    destruct (get_stack_sst sst) as [|soffset sstk] eqn:E_sstk_sst; try discriminate.
    destruct sstk as [|svalue sstk'] eqn:E_sstk'_sst; try discriminate.
    injection H_mstore_s as H_mstore_s.
    
    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as E_stack_len_st_eq_sst.
    destruct E_stack_len_st_eq_sst as [E_stack_len_st_eq_sst_l E_stack_len_st_eq_sst_r].
    
    unfold mstore_c.
     
    destruct (get_stack_st st) as [|coffset stk] eqn:E_stk_st.
    rewrite E_sstk_sst in E_stack_len_st_eq_sst_l. discriminate. (* case of [] *)
    destruct stk as [|cvalue stk'] eqn:E_stk'_st.
    rewrite E_sstk_sst in E_stack_len_st_eq_sst_l. discriminate. (* case of [] *)

    exists (set_stack_st (set_memory_st st (mstore (get_memory_st st) cvalue coffset)) stk').
    
    split.
    reflexivity. (* left side of conjunction *)

    unfold st_is_instance_of_sst.
    exists (set_stack_st (set_memory_st st (mstore (get_memory_st st) cvalue coffset)) stk').
    split.
    2: apply eq_execution_states_refl.

    unfold eval_sstate.

    assert (H_st_inst_sst' := H_st_inst_sst).
    unfold st_is_instance_of_sst in H_st_inst_sst'.
    destruct H_st_inst_sst' as [st' H_st_inst_sst'].
    destruct H_st_inst_sst' as [H_st_inst_sst'_l H_st_inst_sst'_r].

    pose proof (eq_execution_states_ext st st' H_st_inst_sst'_r) as H_st_eq_st'.

    unfold eval_sstate in H_st_inst_sst'_l.

    destruct (eval_sstack (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [stk''|] eqn:E_eval_sstack; try discriminate.
    destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [mem|] eqn:E_mem; try discriminate.
    destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [strg|] eqn:E_strg; try discriminate.

    injection H_st_inst_sst'_l as H_st_inst_sst'_l. 

    (* case of eval_sstack *)
    unfold eval_sstack in E_eval_sstack.
    destruct (length (get_stack_st init_st) =? get_instk_height_sst sst) eqn:E_stk_len; try discriminate.
    destruct (get_smap_sst sst) as [maxid sb] eqn:E_get_smap_sst.
    unfold eval_sstack' in E_eval_sstack.
    rewrite E_sstk_sst in E_eval_sstack.

    pose proof (map_option_len
                  sstack_val
                  EVMWord
                  (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)
                  (soffset :: svalue :: sstk')
                  stk''
                  E_eval_sstack) as H_stk''_len.

    destruct stk''  as [| coffset1 stk''']; try discriminate.
    destruct stk''' as [| cvalue1 stk'''']; try discriminate.

    pose proof (map_option_hd
                  sstack_val
                  EVMWord
                  (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)
                  (svalue :: sstk')
                  (cvalue1 :: stk'''')
                  soffset coffset1 E_eval_sstack) as [E_eval_sstack_1 E_eval_sstack_2].
    pose proof (map_option_hd
                  sstack_val
                  EVMWord
                  (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)
                  sstk'
                  stk''''
                  svalue cvalue1 E_eval_sstack_2) as [E_eval_sstack_3 E_eval_sstack_4].

    unfold eval_sstack.
    rewrite <- H_mstore_s.
    rewrite instk_height_preserved_when_updating_stack_sst.
    rewrite instk_height_preserved_when_updating_memory_sst.
    rewrite E_stk_len.
    rewrite smap_preserved_when_updating_stack_sst.
    rewrite smap_preserved_when_updating_memory_sst.
    rewrite E_get_smap_sst.
    rewrite set_and_then_get_stack_sst.

    unfold eval_sstack'.
    rewrite E_eval_sstack_4.

    (* The case of eval_sstorage *)
    unfold eval_sstorage in E_strg.
    rewrite E_get_smap_sst in E_strg.
    destruct (map_option
               (eval_common.EvalCommon.instantiate_storage_update
                  (fun sv : sstack_val =>
                     eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)) (get_storage_sst sst)) as [strg'|] eqn:E_strg_mapo; try discriminate.

    unfold eval_sstorage.
    rewrite smap_preserved_when_updating_stack_sst.
    rewrite smap_preserved_when_updating_memory_sst.
    rewrite E_get_smap_sst.
    rewrite sstorage_preserved_when_updating_stack_sst.
    rewrite sstorage_preserved_when_updating_memory_sst.
    rewrite E_strg_mapo.

    (* thge case of eval_smemory *)

    unfold eval_smemory.
    rewrite smap_preserved_when_updating_stack_sst.
    rewrite smap_preserved_when_updating_memory_sst.
    rewrite E_get_smap_sst.

    rewrite smemory_preserved_when_updating_stack_sst.
    rewrite set_and_then_get_memory_sst.

    unfold eval_common.EvalCommon.instantiate_memory_update.
    unfold map_option.
    rewrite <- map_option_ho.
    rewrite E_eval_sstack_1.
    rewrite E_eval_sstack_3.

    unfold eval_smemory in E_mem.
    rewrite E_get_smap_sst in E_mem.
    destruct (map_option
              (eval_common.EvalCommon.instantiate_memory_update
                 (fun sv : sstack_val =>
                  eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)) (get_memory_sst sst)) as [mem'|] eqn:E_mem_mapo; try discriminate.
    unfold eval_common.EvalCommon.instantiate_memory_update in E_mem_mapo.
    rewrite E_mem_mapo. 

    rewrite H_st_eq_st'.
    rewrite <- H_st_inst_sst'_l.
    simpl.
    unfold make_st.
    injection E_mem as E_mem.
    rewrite E_mem.
    injection E_strg as E_strg.
    rewrite E_strg.

    assert(E_stk_st' := E_stk_st).
    rewrite H_st_eq_st' in E_stk_st'.
    
    rewrite <- H_st_inst_sst'_l in E_stk_st'.
    simpl in E_stk_st'.
    injection E_stk_st' as _ _ E_stk_st'_stk.
    rewrite E_stk_st'_stk.
    reflexivity.
Qed.


Lemma sha3_snd:
  snd_state_transformer sha3_c sha3_s.
Proof.
  unfold snd_state_transformer.
  intros sst sst' ops H_valid_sst H_sha3_s.
  split.
  - pose proof (sha3_valid_sst sst sst' ops H_valid_sst H_sha3_s) as H_valid_sst'. apply H_valid_sst'.
  - intros init_st st H_st_inst_sst.
    unfold sha3_s in H_sha3_s.
    destruct (get_stack_sst sst) as [|soffset sstk] eqn:E_sstk_sst; try discriminate.
    destruct sstk as [|ssize sstk'] eqn:E_sstk'_sst; try discriminate.
    destruct (add_to_smap (get_smap_sst sst) (SymSHA3 soffset ssize (get_memory_sst sst))) as [key sm'] eqn:E_add_to_smap.
    injection H_sha3_s as H_sha3_s.

    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as E_stack_len_st_eq_sst.
    destruct E_stack_len_st_eq_sst as [E_stack_len_st_eq_sst_l E_stack_len_st_eq_sst_r].

    unfold sha3_c.
    destruct (get_stack_st st) as [|offset stk] eqn:E_stk_st.
    rewrite E_sstk_sst in E_stack_len_st_eq_sst_l. discriminate. (* case of [] *)
    destruct stk as [|size stk'] eqn:E_stk'_st.
    rewrite E_sstk_sst in E_stack_len_st_eq_sst_l. discriminate. (* case of [] *)
    exists (set_stack_st st (get_keccak256_ctx (get_context_st st) (wordToNat size) (mload' (get_memory_st st) offset (wordToNat size)) :: stk')).
    split.
    reflexivity. (* left side of conjunction *)

    unfold st_is_instance_of_sst.
    exists (set_stack_st st (get_keccak256_ctx (get_context_st st) (wordToNat size) (mload' (get_memory_st st) offset (wordToNat size)) :: stk')).
    split.
    2: apply eq_execution_states_refl.
    unfold eval_sstate.

    assert (H_st_inst_sst' := H_st_inst_sst).
    unfold st_is_instance_of_sst in H_st_inst_sst'.
    destruct H_st_inst_sst' as [st' H_st_inst_sst'].
    destruct H_st_inst_sst' as [H_st_inst_sst'_l H_st_inst_sst'_r].

    pose proof (eq_execution_states_ext st st' H_st_inst_sst'_r) as H_st_eq_st'.

    unfold eval_sstate in H_st_inst_sst'_l.

    destruct (eval_sstack (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [stk''|] eqn:E_eval_sstack; try discriminate.
    destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [mem|] eqn:E_mem; try discriminate.
    destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [strg|] eqn:E_strg; try discriminate.

    injection H_st_inst_sst'_l as H_st_inst_sst'_l.

    pose proof (valid_sstate_sstack_change sst (FreshVar key :: sstk')  H_valid_sst) as H_valid_sst_with_fresh_var.

    pose proof (smap_preserved_when_updating_stack_sst sst (FreshVar key :: sstk')) as E_get_smap_with_stk_fresh_var.

    assert(E_add_to_smap' := E_add_to_smap).
    rewrite <-  E_get_smap_with_stk_fresh_var in E_add_to_smap'.

    rewrite <- H_sha3_s.

    (* equivalence of eval_smemory *)
    pose proof (eval_smemory_preserved_when_sstack_changed (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops (FreshVar key :: sstk')) as E_eval_smemory_0.
    rewrite E_eval_smemory_0 in E_mem.

    pose proof (eval_smemory_preserved_when_smap_extended (set_stack_sst sst (FreshVar key :: sstk')) init_st sm' (SymSHA3 soffset ssize (get_memory_sst sst)) ops key mem H_valid_sst_with_fresh_var E_add_to_smap' E_mem) as E_eval_smemory_1.

    rewrite E_eval_smemory_1.

    (* equivalence of eval_sstorage *)
    pose proof (eval_sstorage_preserved_when_sstack_changed (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops (FreshVar key :: sstk')) as E_eval_sstorage_0.

    rewrite E_eval_sstorage_0 in E_strg.

    pose proof (eval_sstorage_preserved_when_smap_extended (set_stack_sst sst (FreshVar key :: sstk')) init_st sm' (SymSHA3 soffset ssize (get_memory_sst sst)) ops key strg H_valid_sst_with_fresh_var E_add_to_smap' E_strg) as E_eval_sstorage_1.

    rewrite E_eval_sstorage_1.

    (* the case of eval_sstack *)
    unfold eval_sstack in E_eval_sstack.

    apply Nat.eqb_eq in E_stack_len_st_eq_sst_r as E_stack_len_st_eq_sst_r_eqb.
    apply Nat.eqb_eq in E_stack_len_st_eq_sst_l as E_stack_len_st_eq_sst_l_eqb.

    rewrite E_stack_len_st_eq_sst_r_eqb in E_eval_sstack.
    destruct (get_smap_sst sst) as [maxid sb] eqn:E_get_smap_sst.
    rewrite E_sstk_sst in E_eval_sstack.

    unfold eval_sstack' in E_eval_sstack.
    pose proof (map_option_len
                  sstack_val
                  EVMWord
                  (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)
                  (soffset :: ssize :: sstk')
                  stk''
                  E_eval_sstack) as H_stk''_len.
    destruct stk''  as [| offset1 stk''']; try discriminate.
    destruct stk''' as [| size1 stk'''']; try discriminate.

    pose proof (map_option_hd
                  sstack_val
                  EVMWord
                  (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)
                  (ssize :: sstk')
                  (size1 :: stk'''')
                  soffset offset1 E_eval_sstack) as [E_eval_sstack_1 E_eval_sstack_2].
    pose proof (map_option_hd
                  sstack_val
                  EVMWord
                  (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb ops)
                  sstk'
                  stk''''
                  ssize size1 E_eval_sstack_2) as [E_eval_sstack_3 E_eval_sstack_4].

    unfold eval_sstack.

    rewrite instk_height_preserved_when_updating_smap_sst.
    rewrite instk_height_preserved_when_updating_stack_sst.
    rewrite E_stack_len_st_eq_sst_r_eqb.
    rewrite set_and_then_get_smap_sst.

    destruct sm' as [maxid' sb'].
    
    rewrite sstack_preserved_when_updating_smap_sst.
    rewrite set_and_then_get_stack_sst.

    rewrite smap_preserved_when_updating_stack_sst in E_add_to_smap'.
    rewrite E_get_smap_sst in E_add_to_smap'.
    simpl in E_add_to_smap'.
    injection E_add_to_smap' as E_add_to_smap'_key E_add_to_smap'_maxid E_add_to_smap'_bs.

    unfold eval_sstack'. 
    unfold map_option.
    rewrite <- map_option_ho.

    rewrite <- E_get_smap_sst in E_add_to_smap.
    pose proof (eval_sstack_mapo_preserved_when_smap_extended sstk' sst init_st maxid maxid' sb sb' (SymSHA3 soffset ssize (get_memory_sst sst)) ops key stk'''' H_valid_sst E_get_smap_sst E_add_to_smap  E_eval_sstack_4) as E_eval_sstack_5.

    rewrite E_eval_sstack_5.

    rewrite <- E_add_to_smap'_bs.
    unfold eval_sstack_val.
    fold eval_sstack_val.

    apply Nat.eqb_eq in E_add_to_smap'_key as E_add_to_smap'_key_eqb.
    rewrite E_add_to_smap'_key_eqb.

    unfold eval_smemory in E_mem.
    rewrite smap_preserved_when_updating_stack_sst in E_mem.
    rewrite E_get_smap_sst in E_mem.

    destruct (map_option
              (eval_common.EvalCommon.instantiate_memory_update
                 (fun sv : sstack_val =>
                  eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st)
                    (get_context_st init_st) sb ops)) (get_memory_sst (set_stack_sst sst (FreshVar key :: sstk')))) as [updates|] eqn:E_mem_mapo; try discriminate.

    rewrite smemory_preserved_when_updating_stack_sst in E_mem_mapo.
    rewrite E_mem_mapo.
    rewrite E_eval_sstack_1.
    rewrite E_eval_sstack_3.

    unfold eq_execution_states in H_st_inst_sst'_r.
    rewrite H_st_eq_st'.
    rewrite <- H_st_inst_sst'_l.
    unfold make_st.
    simpl.
    injection E_mem as E_mem. 
    rewrite E_mem.

    assert(E_stk_st' := E_stk_st).
    rewrite H_st_eq_st' in E_stk_st'.
    
    rewrite <- H_st_inst_sst'_l in E_stk_st'.
    simpl in E_stk_st'.
    injection E_stk_st' as E_stk_st'_offset E_stk_st'_size E_stk_st'_stk.
    rewrite E_stk_st'_offset.
    rewrite E_stk_st'_size.
    rewrite E_stk_st'_stk.
    reflexivity.
Qed.

    
Lemma exec_stack_op_intsr_snd:
  forall label, snd_state_transformer (exec_stack_op_intsr_c label) (exec_stack_op_intsr_s label).
Proof.
  unfold snd_state_transformer.
  intros label sst sst' ops H_valid_sst H_execop_s. 
  split.
  - pose proof (exec_stack_op_intsr_valid_sst sst sst' label ops H_valid_sst H_execop_s) as H_valid_sst'. apply H_valid_sst'.
  - intros init_st st H_st_inst_sst.
    unfold exec_stack_op_intsr_s in H_execop_s.
    destruct (ops label) eqn:E_label.

    destruct (firstn_e n (get_stack_sst sst)) eqn:E_firstn_e_s; try discriminate.
    unfold firstn_e in E_firstn_e_s.
    destruct (n <=? length (get_stack_sst sst) ) eqn:E_n_lt_len_stk_sst; try discriminate.
    injection E_firstn_e_s as E_firstn_e_s.
    
    destruct (skipn_e n (get_stack_sst sst)) eqn:E_skipn_e_s; try discriminate.
    unfold skipn_e in E_skipn_e_s.
    rewrite E_n_lt_len_stk_sst in E_skipn_e_s.
    injection E_skipn_e_s as E_skipn_e_s.

    destruct (add_to_smap (get_smap_sst sst) (SymOp label l)) as [key m] eqn:E_add_to_smap.
    injection H_execop_s as H_execop_s.

    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as E_stack_len_st_eq_sst.
    destruct E_stack_len_st_eq_sst as [E_stack_len_st_eq_sst_l E_stack_len_st_eq_sst_r].

    assert(E_stack_len_st_eq_sst_l' := E_stack_len_st_eq_sst_l).
    rewrite <- Nat.eqb_eq in E_stack_len_st_eq_sst_l'.

    assert(E_stack_len_st_eq_sst_r' := E_stack_len_st_eq_sst_r).
    rewrite <- Nat.eqb_eq in E_stack_len_st_eq_sst_r'.

    unfold exec_stack_op_intsr_c.
    rewrite E_label.
    
    destruct (firstn_e n (get_stack_st st)) eqn:E_firstn_e.
    + destruct (skipn_e n (get_stack_st st)) eqn:E_skipn_e.
      ++ exists (set_stack_st st (f (get_context_st st) l1 :: l2)).
         split; try reflexivity.
         unfold st_is_instance_of_sst.
         exists (set_stack_st st (f (get_context_st st) l1 :: l2)).
         split.
         2: apply eq_execution_states_refl.
         unfold eval_sstate.

         assert (H_st_inst_sst' := H_st_inst_sst).
         unfold st_is_instance_of_sst in H_st_inst_sst'.
         destruct H_st_inst_sst' as [st' H_st_inst_sst'].
         destruct H_st_inst_sst' as [H_st_inst_sst'_l H_st_inst_sst'_r].
         
         pose proof (eq_execution_states_ext st st' H_st_inst_sst'_r) as H_st_eq_st'.

         unfold eval_sstate in H_st_inst_sst'_l.
          
         destruct (eval_sstack (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [stk|] eqn:E_eval_sstack; try discriminate.
         destruct (eval_smemory (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st)       (get_context_st init_st) sst ops) as [mem|] eqn:E_mem; try discriminate.
         destruct (eval_sstorage (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops) as [strg|] eqn:E_strg; try discriminate.

         injection H_st_inst_sst'_l as H_st_inst_sst'_l.
         
         pose proof (valid_sstate_sstack_change sst (FreshVar key :: l0)  H_valid_sst) as H_valid_sst_with_fresh_var.
       
         pose proof (smap_preserved_when_updating_stack_sst sst (FreshVar key :: l0)) as E_get_smap_with_stk_fresh_var.

         assert(E_add_to_smap' := E_add_to_smap).
         rewrite <-  E_get_smap_with_stk_fresh_var in E_add_to_smap'.

         rewrite <- H_execop_s.

         (* equivalence of eval_smemory *)
         pose proof (eval_smemory_preserved_when_sstack_changed (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops (FreshVar key :: l0)) as E_eval_smemory_0.

         rewrite E_eval_smemory_0 in E_mem.
         
         pose proof (eval_smemory_preserved_when_smap_extended (set_stack_sst sst (FreshVar key :: l0)) init_st m (SymOp label l) ops key mem H_valid_sst_with_fresh_var E_add_to_smap' E_mem) as E_eval_smemory_1.
         rewrite E_eval_smemory_1.
         
         (* equivalence of eval_sstorage *)
         pose proof (eval_sstorage_preserved_when_sstack_changed (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sst ops (FreshVar key :: l0)) as E_eval_sstorage_0.

         rewrite E_eval_sstorage_0 in E_strg.
         
         pose proof (eval_sstorage_preserved_when_smap_extended (set_stack_sst sst (FreshVar key :: l0)) init_st m (SymOp label l) ops key strg H_valid_sst_with_fresh_var E_add_to_smap' E_strg) as E_eval_sstorage_1.
         rewrite E_eval_sstorage_1.

         (* the case of eval_sstack *)
         unfold eval_sstack.

         rewrite instk_height_preserved_when_updating_smap_sst.
         rewrite instk_height_preserved_when_updating_stack_sst.

         rewrite E_stack_len_st_eq_sst_r'.
         rewrite set_and_then_get_smap_sst.
         destruct m as [maxid sb].

         rewrite sstack_preserved_when_updating_smap_sst.
         rewrite set_and_then_get_stack_sst.

         rewrite smap_preserved_when_updating_stack_sst in E_add_to_smap'.
         destruct (get_smap_sst sst) as [maxid' sb'].
         simpl in E_add_to_smap'.
         injection E_add_to_smap' as E_add_to_smap'_key E_add_to_smap'_maxid E_add_to_smap'_bs.
         rewrite <- E_add_to_smap'_bs.

         unfold eval_sstack in E_eval_sstack.
         rewrite   E_stack_len_st_eq_sst_r' in E_eval_sstack.
         rewrite <- smap_preserved_when_updating_stack_sst with (sst:=sst)(sstk:=(FreshVar key :: l0)) in E_eval_sstack.
         rewrite E_get_smap_with_stk_fresh_var in E_eval_sstack.

         pose proof (eval_sstack'_len (get_stack_sst sst) (get_stack_st init_st) stk (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) sb' ops E_eval_sstack) as H_eval_sstack'_len.
         assert(E_n_lt_len_stk_st := E_n_lt_len_stk_sst).
         rewrite E_stack_len_st_eq_sst_l in E_n_lt_len_stk_st.
         unfold firstn_e in E_firstn_e.
         rewrite E_n_lt_len_stk_st in E_firstn_e.
         injection E_firstn_e as E_firstn_e.
         unfold skipn_e in E_skipn_e.
         rewrite E_n_lt_len_stk_st in E_skipn_e.
         injection E_skipn_e as E_skipn_e.

         pose proof (firstn_skipn n (get_stack_sst sst)) as H_split_stack_sst.
         pose proof (firstn_skipn n stk) as H_split_stk.

         pose proof (firstn_skipn_two_lists n (get_stack_sst sst) stk H_eval_sstack'_len) as [H_skipn_len H_first_len].

         unfold eval_sstack' in E_eval_sstack.

         rewrite <- H_split_stack_sst in E_eval_sstack.
         rewrite <- H_split_stk in E_eval_sstack.
         
         pose proof (map_option_app2 sstack_val EVMWord (fun sv : sstack_val =>
                     eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) 
                       (get_storage_st init_st) (get_context_st init_st) sb' ops) (firstn n (get_stack_sst sst)) (skipn n (get_stack_sst sst)) (firstn n stk) (skipn n stk) H_first_len H_skipn_len E_eval_sstack) as [H_mapo_l H_mapo_r].
         
         unfold eval_sstack'.

         unfold map_option.
         rewrite <- map_option_ho.

         unfold eval_sstack_val at 1.
         fold eval_sstack_val.

         apply Nat.eqb_eq in E_add_to_smap'_key as E_add_to_smap'_key_eqb.
         rewrite E_add_to_smap'_key_eqb.
         rewrite E_label.

         apply Nat.leb_le in  E_n_lt_len_stk_sst as E_n_lt_len_stk_sst_0.
         pose proof (firstn_length_le (get_stack_sst sst) E_n_lt_len_stk_sst_0) as E_len_firstn_0.
         apply Nat.eqb_eq in E_len_firstn_0.
         rewrite E_firstn_e_s in E_len_firstn_0.
         rewrite E_len_firstn_0.
         rewrite <- E_firstn_e_s.
         rewrite H_mapo_l.
         rewrite <-  E_skipn_e_s.

         rewrite <- E_get_smap_with_stk_fresh_var in E_add_to_smap.
         rewrite <- E_firstn_e_s in E_add_to_smap.
         pose proof (eval_sstack_mapo_preserved_when_smap_extended (skipn n (get_stack_sst sst)) (set_stack_sst sst (FreshVar key :: l0)) init_st maxid' maxid sb' sb (SymOp label (firstn n (get_stack_sst sst))) ops key (skipn n stk) H_valid_sst_with_fresh_var E_get_smap_with_stk_fresh_var E_add_to_smap   H_mapo_r) as H_mapo_skipn.  

         rewrite E_firstn_e_s.
         rewrite E_add_to_smap'_bs.
         rewrite H_mapo_skipn.
         rewrite <- E_firstn_e.
         rewrite <- E_skipn_e.
         rewrite H_st_eq_st'.
         rewrite <- H_st_inst_sst'_l.
         simpl.
         reflexivity.
         
         (* equivalence of eval_sstack *)


      ++ unfold skipn_e in E_skipn_e.
         rewrite <- E_stack_len_st_eq_sst_l in E_skipn_e.
         rewrite  E_n_lt_len_stk_sst in E_skipn_e.
         discriminate.

    + unfold firstn_e in E_firstn_e.
      rewrite <- E_stack_len_st_eq_sst_l in E_firstn_e.
      rewrite  E_n_lt_len_stk_sst in E_firstn_e.
      discriminate.
Qed.

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
    intros sst sst' ops H_valid_sst H_sexec_nil.
    injection H_sexec_nil as H_sexec_nil.
    rewrite <- H_sexec_nil.
    split; try assumption.
    intros init_st st H_st_inst_sst.
    exists st. (* we use st since p=[], i.e., we don't execute anything *)
    split; try reflexivity. (* split the conjuction into two goals *)
    apply H_st_inst_sst. (* the goal is the assumption H_st_inst_sst *)

  - intros sst sst' ops H_valid_sst H_sexec_ip'.

    (* unfold the symbolic execution of i::p' and fold the recursive call *)
    unfold evm_exec_block_s in H_sexec_ip'. 
    fold evm_exec_block_s in H_sexec_ip'.

    (* we split on the result of symbolically executiing i: Some sst'' or None *)
    destruct (evm_exec_instr_s i sst ops) as [sst''|] eqn:E_evm_exec_instr_s; try discriminate.

    (* derive relation between execution and symbolic execution of i *)
    apply evm_exec_instr_snd with (i:=i) in E_evm_exec_instr_s as [H_eval_stt'' E_evm_exec_instr_s_0]; try apply H_valid_sst.
    split.
    + pose proof (IHp' sst'' sst' ops H_eval_stt'' H_sexec_ip') as [IHp'_aux _]. apply IHp'_aux.
    + intros init_st st H_st_inst_sst.
      pose proof (E_evm_exec_instr_s_0 init_st st H_st_inst_sst) as E_evm_exec_instr_c.

      (* choose a value for exists st' and split the resulting conjunction *)
      destruct E_evm_exec_instr_c as [st' E_evm_exec_instr_c_st']. 
      destruct E_evm_exec_instr_c_st' as [E_evm_exec_instr_c_st'_left E_evm_exec_instr_c_st'_right].
      
      (* apply the induction hypothesis for symbolically exexuting p'
      from sst'' (the result of executing i) to st'. Use H_sexec_ip'
      for the premise that symbolic execution of p' succeeds *)
      pose proof (IHp' sst'' sst' ops H_eval_stt'' H_sexec_ip') as IHp'_sst''_sst'.
      destruct IHp'_sst''_sst' as [_ IHp'_sst''_sst'].

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

Qed.



(* The instk_height of the symbolic state (gen_empty_sstate instk_height) is instk_height *)
Lemma instkh_gen_empty_instkh:
  forall instk_height,
    get_instk_height_sst (gen_empty_sstate instk_height) = instk_height.
Proof.
  intros. reflexivity.
Qed.

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
  unfold map_option.
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
  unfold map_option.
  unfold eval_common.EvalCommon.update_storage. reflexivity.
Qed.

(* An initial symbolic state is equivalent to any state, as long as
they refer to a stack with the same size *)
Lemma gen_empty_sstate_snd:
  forall (st: state) (instk_height: nat) (sst: sstate) (ops : stack_op_instr_map),
    length (get_stack_st st) = instk_height ->
    sst = gen_empty_sstate instk_height ->
    st_is_instance_of_sst st st sst ops /\ valid_sstate sst.
Proof.
  intros.
  split.
  - unfold st_is_instance_of_sst.
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
  - pose proof (valid_empty_sstate instk_height).
    rewrite H0.
    apply H1.
Qed.

Theorem symbolic_exec_snd:
  forall (p : block) (instk_height : nat) (sst : sstate) (ops : stack_op_instr_map),
    evm_sym_exec p instk_height ops = Some sst ->
    valid_sstate sst /\                                       
    forall (st : state), 
      length (get_stack_st st) = instk_height -> 
      exists (st': state),
        evm_exec_block_c p st ops = Some st' /\
          st_is_instance_of_sst st st' sst ops. (* st' is an instance of sst wrt the initial state st *)
Proof.
  intros p instk_height sst ops H_evm_sym_exec.
  unfold evm_sym_exec in H_evm_sym_exec.
  pose proof (evm_exec_block_snd p) as H_exec_blk_snd.
  unfold snd_state_transformer in H_exec_blk_snd.
  pose proof (valid_empty_sstate instk_height) as H_valid_empty_sstate.
  pose proof (H_exec_blk_snd (gen_empty_sstate instk_height) sst ops H_valid_empty_sstate H_evm_sym_exec) as [H_valid_sst H_exec_blk_snd_conc].
  split.
  + apply H_valid_sst.
  + intros st H_len.
    assert (gen_empty_sstate instk_height = gen_empty_sstate instk_height). reflexivity.
    pose proof (gen_empty_sstate_snd st instk_height (gen_empty_sstate instk_height) ops H_len H) as [H2 H3]. 
    pose proof (H_exec_blk_snd_conc st st H2).
    destruct H0 as [st'].
    exists st'.
    apply H0.
Qed.


End SymbolicExecutionSoundness.


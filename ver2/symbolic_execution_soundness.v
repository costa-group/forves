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

Require Import FORVES.symbolic_state_eval.
Import SymbolicStateEval.
 
Require Import FORVES.symbolic_state_eval_facts.
Import SymbolicStateEvalFacts.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import FORVES.memory_ops_solvers.
Import MemoryOpsSolvers.

Require Import FORVES.storage_ops_solvers.
Import StorageOpsSolvers.

Module SymbolicExecutionSoundness.



(* A state st is an instance of a symbolic state sst wrt. to an
initial state init_st, means that evaluating sst wrt. init_st we get
st' that is equivalent of st. *)

Definition st_is_instance_of_sst (init_st st: state) (sst: sstate) (ops: stack_op_instr_map) : Prop :=
  exists (st': state),
    eval_sstate init_st sst ops = Some st' /\
    eq_execution_states st st'.


(* A state transformer _tr_ and a symbolic state transformer _str_ are
equivalent, if when _str_ transforms _sst_ to _sst'_, then for any
initial state _init_st_ and a state _st_ such that _st_ is an instance
of _sst_ wrt _init_st_, _tr_ transformes from _st_ to _st'_ such that
_st'_ is an instance of _sst'_ wrt _init_st_. In addition, sst is
supposed to be valid, and sst' must be valid. *)

Definition snd_state_transformer ( tr : state -> stack_op_instr_map -> option state ) (symtr : sstate ->  stack_op_instr_map -> option sstate )  : Prop :=
  forall (sst sst': sstate) (ops : stack_op_instr_map),
    valid_sstate sst ops ->
    symtr sst ops = Some sst' ->
    valid_sstate sst' ops /\
      forall (init_st st: state),
        st_is_instance_of_sst init_st st sst ops ->
        exists (st': state),
          tr st ops = Some st' /\ st_is_instance_of_sst init_st st' sst' ops.



(* Abstract transformers in symbolic execution generate valid states when applied to valid states *)

(* push_s generated valid states *)
Lemma push_valid_sst:
  forall sst sst' w ops,
    valid_sstate sst ops ->
    push_s w sst ops = Some sst' ->
    valid_sstate sst' ops.
Proof.
  intros sst sst' w ops H_valid_sst H_push_s.
  unfold push_s in H_push_s.
  destruct (push (Val w) (get_stack_sst sst)) as [sstk'|] eqn:E_push; try discriminate.
  injection H_push_s as H_sst'.
  
  unfold valid_sstate in H_valid_sst.
  destruct H_valid_sst as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].

  unfold push in E_push.
  destruct (length (get_stack_sst sst) <? StackSize); try discriminate.
  injection E_push as H_sstk'.

  rewrite <- H_sst'.
  unfold valid_sstate.
  rewrite instk_height_preserved_when_updating_stack_sst.
  rewrite smemory_preserved_when_updating_stack_sst.
  rewrite sstorage_preserved_when_updating_stack_sst.
  rewrite smap_preserved_when_updating_stack_sst.
  rewrite set_and_then_get_stack_sst.
  split.
  - apply H_valid_sst_smap.
  - split.
    + rewrite <- H_sstk'.
      simpl.
      split. apply I. apply H_valid_sst_sstack.
    + split.
      * simpl. apply H_valid_sst_smemory.
      * simpl. apply H_valid_sst_sstorage.
Qed.

(* pushtag_s generates valid states *)
Lemma pushtag_valid_sst:
  forall sst sst' v ops,
    valid_sstate sst ops ->
    pushtag_s v sst ops = Some sst' ->
    valid_sstate sst' ops.
Proof.
  intros sst sst' v ops H_valid_sst H_pushtag_s.
  unfold pushtag_s in H_pushtag_s.
  destruct (add_to_smap (get_smap_sst sst) (SymPUSHTAG v)) as [key sm'] eqn:E_add_to_smap.
  destruct (push (FreshVar key) (get_stack_sst sst)) as [sstk'|] eqn:E_push; try discriminate.
  injection H_pushtag_s as H_stt'.

  unfold push in E_push.
  destruct (length (get_stack_sst sst) <? StackSize); try discriminate.
  injection E_push as E_sstk'.

  rewrite <- H_stt'.
  rewrite <- E_sstk'.

  unfold valid_sstate.
  rewrite instk_height_preserved_when_updating_smap_sst.
  rewrite instk_height_preserved_when_updating_stack_sst.
  rewrite smemory_preserved_when_updating_smap_sst.
  rewrite sstorage_preserved_when_updating_smap_sst.
  rewrite set_and_then_get_smap_sst.
  rewrite smemory_preserved_when_updating_stack_sst.
  rewrite sstorage_preserved_when_updating_stack_sst.
  rewrite sstack_preserved_when_updating_smap_sst.
  rewrite set_and_then_get_stack_sst.

  pose proof (pushtag_valid_smv (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) ops v) as H_valid_smv.
  symmetry in E_add_to_smap.
  pose proof (add_to_map_valid_sstate sst key sm' (SymPUSHTAG v) ops H_valid_sst H_valid_smv E_add_to_smap) as H_valid_sst_add.
  
  unfold valid_sstate in H_valid_sst_add.
  rewrite instk_height_preserved_when_updating_smap_sst in H_valid_sst_add.
  rewrite smemory_preserved_when_updating_smap_sst in H_valid_sst_add.
  rewrite sstorage_preserved_when_updating_smap_sst in H_valid_sst_add.
  rewrite set_and_then_get_smap_sst in H_valid_sst_add.
  rewrite sstack_preserved_when_updating_smap_sst in H_valid_sst_add.

  destruct H_valid_sst_add as [H_valid_sst_smap_add [H_valid_sst_sstack_add [H_valid_sst_smemory_add H_valid_sst_sstorage_add]]].

  unfold valid_sstate.
  split.
  - apply H_valid_sst_smap_add.
  - split.
    + simpl. 
      split.
      * pose proof (add_to_smap_key_lt_maxidx (get_smap_sst sst) sm' key (SymPUSHTAG v) E_add_to_smap) as H_key_lt_maxidx.
        apply H_key_lt_maxidx.
      * apply H_valid_sst_sstack_add.
    + split.
      * apply H_valid_sst_smemory_add.
      * apply H_valid_sst_sstorage_add.
Qed.

(* pop generates valid states *)
Lemma pop_valid_sst:
  forall sst sst' ops,
    valid_sstate sst ops ->
    pop_s sst ops = Some sst' ->
    valid_sstate sst' ops.
Proof.
  intros sst sst' ops H_valid_sst H_pop_s.
  unfold pop_s in H_pop_s.
  destruct (pop (get_stack_sst sst)) as [sstk|] eqn:E_pop; try discriminate.
  injection H_pop_s as H_sst'.
  unfold pop in E_pop.
  destruct (get_stack_sst sst) as [|sv sstk'] eqn:E_sstk'; try discriminate.
  injection E_pop as E_sstk.

  unfold valid_sstate in H_valid_sst.
  destruct H_valid_sst as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].

  rewrite E_sstk' in H_valid_sst_sstack.
  simpl in H_valid_sst_sstack.
  destruct H_valid_sst_sstack as [_ H_valid_sst_sstk'].

  rewrite <- H_sst'.
  rewrite <- E_sstk.

  unfold valid_sstate.
  rewrite instk_height_preserved_when_updating_stack_sst.
  rewrite smemory_preserved_when_updating_stack_sst.
  rewrite sstorage_preserved_when_updating_stack_sst.
  rewrite smap_preserved_when_updating_stack_sst.
  rewrite set_and_then_get_stack_sst.

  split.
  - apply H_valid_sst_smap.
  - split.
    + apply H_valid_sst_sstk'.
    + split.
      * simpl. apply H_valid_sst_smemory.
      * simpl. apply H_valid_sst_sstorage.
Qed.

(* pushtag_s generates valid states *)
Lemma dup_valid_sst:
    forall sst sst' ops k,
    valid_sstate sst ops ->
    dup_s k sst ops = Some sst' ->
    valid_sstate sst' ops.
Proof.
  intros sst sst' ops k H_valid_sst H_dup_s.
  unfold dup_s in H_dup_s.
  destruct (dup k (get_stack_sst sst)) as [sstk'|] eqn:E_dup; try discriminate.
  injection H_dup_s as H_dup_s.
  unfold dup in E_dup.
  destruct ((k =? 0) || (16 <? k) || (StackSize <=? length (get_stack_sst sst))); try discriminate.
  destruct (nth_error (get_stack_sst sst) (pred k)) as [sv|] eqn:E_nth_error; try discriminate.
  injection E_dup as H_sstk'.
  unfold valid_sstate in H_valid_sst.
  destruct H_valid_sst as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].
  
  pose proof (valid_sstack_nth (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_stack_sst sst) sv (pred k) H_valid_sst_sstack E_nth_error) as H_valid_sv.

  rewrite <- H_dup_s.
  unfold valid_sstate.
  rewrite instk_height_preserved_when_updating_stack_sst.
  rewrite smemory_preserved_when_updating_stack_sst.
  rewrite sstorage_preserved_when_updating_stack_sst.
  rewrite smap_preserved_when_updating_stack_sst.
  rewrite set_and_then_get_stack_sst.
  split.
  - apply H_valid_sst_smap.
  - split.
    + rewrite <- H_sstk'.
      simpl.
      split.
      * apply H_valid_sv.
      * apply H_valid_sst_sstack.
    + split.
      * apply H_valid_sst_smemory.
      * apply H_valid_sst_sstorage.
Qed.

(* pushtag_s generates valid states *)
Lemma swap_valid_sst:
    forall sst sst' ops k,
    valid_sstate sst ops ->
    swap_s k sst ops = Some sst' ->
    valid_sstate sst' ops.
Proof.
  intros sst sst' ops k H_valid_sst H_swap_s.
  unfold swap_s in H_swap_s.
  destruct (swap k (get_stack_sst sst)) as [sstk'|] eqn:E_swap; try discriminate.
  injection H_swap_s as H_swap_s.
  unfold swap in E_swap.
  destruct ((k =? 0) || (16 <? k)); try discriminate.
  destruct (nth_error (get_stack_sst sst) k) as [sv|] eqn:E_nth_error; try discriminate.
  destruct (get_stack_sst sst) as [|h t] eqn:E_sstk; try discriminate.
  rewrite <- E_sstk in E_nth_error.
  injection E_swap as H_sstk'.
  
  unfold valid_sstate in H_valid_sst.
  destruct H_valid_sst as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].
  
  rewrite <- H_swap_s.
  unfold valid_sstate.
  rewrite instk_height_preserved_when_updating_stack_sst.
  rewrite smemory_preserved_when_updating_stack_sst.
  rewrite sstorage_preserved_when_updating_stack_sst.
  rewrite smap_preserved_when_updating_stack_sst.
  rewrite set_and_then_get_stack_sst.
  split.
  - apply H_valid_sst_smap.
  - split.
    + pose proof (valid_sstack_nth (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_stack_sst sst) sv k H_valid_sst_sstack E_nth_error) as H_valid_sv.
      pose proof (valid_sstack_skipn (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_stack_sst sst) (k+1) H_valid_sst_sstack) as H_valid_skipn.
      rewrite E_sstk in H_valid_skipn.

      assert (H_valid_t := H_valid_sst_sstack).
      rewrite E_sstk in H_valid_t.
      simpl in H_valid_t.
      destruct H_valid_t as [H_valid_h H_valid_t].

      pose proof (valid_sstack_firstn (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) t (k-1) H_valid_t) as H_valid_firstn.

      pose proof (valid_sstack_cons (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) (skipn (k + 1) (h :: t)) h H_valid_skipn H_valid_h) as H_valid_h_skipn.

      pose proof (valid_sstack_app (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) (firstn (k - 1) t) (h :: skipn (k + 1) (h :: t)) H_valid_firstn H_valid_h_skipn) as H_valid_firstn_h_skipn.
      
      rewrite <- H_sstk'.
      simpl.
      split.
      * apply H_valid_sv.
      * apply H_valid_firstn_h_skipn.
    + split.
      * apply H_valid_sst_smemory.
      * apply H_valid_sst_sstorage.
Qed.

Lemma exec_stack_op_intsr_valid_sst:
  forall sst sst' label ops,
    valid_sstate sst ops ->
    exec_stack_op_intsr_s label sst ops = Some sst' ->
    valid_sstate sst' ops.
Proof.
  intros sst sst' label ops H_valid_sst H_exec_s.
  unfold exec_stack_op_intsr_s in H_exec_s.
  destruct (ops label) as [nargs f H_com H_coh] eqn:E_label.
  destruct (firstn_e nargs (get_stack_sst sst)) as [args|] eqn:E_firstn; try discriminate.
  destruct (skipn_e nargs (get_stack_sst sst)) as [sstk'|] eqn:E_skipn; try discriminate.
  destruct (add_to_smap (get_smap_sst sst) (SymOp label args)) as [key sm'] eqn:E_add_to_smap.
  injection H_exec_s as H_sst'.

  unfold firstn_e in E_firstn.
  destruct (nargs <=? length (get_stack_sst sst)) eqn:E_nargs_leb_len; try discriminate.
  injection E_firstn as E_args.
  
  unfold skipn_e in E_skipn.
  rewrite E_nargs_leb_len in E_skipn.
  injection E_skipn as E_sstk'.

  assert( H_valid_sst' := H_valid_sst).
  unfold valid_sstate in H_valid_sst'.
  destruct H_valid_sst' as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].

  pose proof (valid_sstack_firstn (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_stack_sst sst) nargs H_valid_sst_sstack) as H_valid_args.
  rewrite E_args in H_valid_args.
  pose proof (valid_sstack_skipn (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_stack_sst sst) nargs H_valid_sst_sstack) as H_valid_sstk'.
  rewrite E_sstk' in H_valid_sstk'.

  apply Nat.leb_le in E_nargs_leb_len as E_nargs_le_len.
  pose proof (firstn_length_le (get_stack_sst sst) E_nargs_le_len) as E_len_args.
  rewrite E_args in E_len_args.

  pose proof (op_instr_valid_smv (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) ops label nargs args f H_com H_coh H_valid_args E_label E_len_args) as H_valid_smv.

  symmetry in E_add_to_smap.
  pose proof (add_to_map_valid_sstate sst key sm' (SymOp label args) ops H_valid_sst H_valid_smv E_add_to_smap) as H_valid_sst_add.

  unfold valid_sstate in H_valid_sst_add.
  rewrite instk_height_preserved_when_updating_smap_sst in H_valid_sst_add.
  rewrite smemory_preserved_when_updating_smap_sst in H_valid_sst_add.
  rewrite sstorage_preserved_when_updating_smap_sst in H_valid_sst_add.
  rewrite set_and_then_get_smap_sst in H_valid_sst_add.
  rewrite sstack_preserved_when_updating_smap_sst in H_valid_sst_add.

  destruct H_valid_sst_add as [H_valid_sst_smap_add [H_valid_sst_sstack_add [H_valid_sst_smemory_add H_valid_sst_sstorage_add]]].

  rewrite <- H_sst'.
  unfold valid_sstate.
  rewrite instk_height_preserved_when_updating_smap_sst.
  rewrite instk_height_preserved_when_updating_stack_sst.
  rewrite smemory_preserved_when_updating_smap_sst.
  rewrite sstorage_preserved_when_updating_smap_sst.
  rewrite set_and_then_get_smap_sst.
  rewrite smemory_preserved_when_updating_stack_sst.
  rewrite sstorage_preserved_when_updating_stack_sst.
  rewrite sstack_preserved_when_updating_smap_sst.
  rewrite set_and_then_get_stack_sst.

  split.
  - apply H_valid_sst_smap_add.
  - split.
    + simpl. 
      split.
      * pose proof (add_to_smap_key_lt_maxidx (get_smap_sst sst) sm' key (SymOp label args) E_add_to_smap) as H_key_lt_maxidx.
        apply H_key_lt_maxidx.
      * destruct (get_smap_sst sst) as [maxidx sb] eqn:E_smap.
        simpl in E_add_to_smap.
        injection E_add_to_smap as H_maxidx H_sm'.
        rewrite H_sm'.
        simpl.
        apply valid_sstack_S_maxidx.
        simpl in H_valid_sstk'.
        apply H_valid_sstk'.
    + split.
      * apply H_valid_sst_smemory_add.
      * apply H_valid_sst_sstorage_add.
Qed.

(* mload generates valid states *)
Lemma mload_valid_sst:
  forall sst sst' ops mload_solver,
    valid_sstate sst ops ->
    mload_solver_snd mload_solver ->
    mload_s mload_solver sst ops = Some sst' ->
    valid_sstate sst' ops.
Proof.
  intros sst sst' ops mload_solver H_valid_sst H_valid_solver H_mload_s.
  
  unfold mload_s in H_mload_s.
  destruct (get_stack_sst sst) as [|soffset sstk'] eqn:E_sstk; try discriminate.
  remember (mload_solver soffset (get_memory_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) ops) as smv eqn:H_eqsmv.
  destruct (add_to_smap (get_smap_sst sst) smv) as [key sm'] eqn:E_add_to_smap.
  injection H_mload_s as H_sst'.
  rewrite <- H_sst'.

  unfold mload_solver_snd in H_valid_solver.
  destruct H_valid_solver as [H_valid_solver _].
  unfold mload_solver_valid_res in H_valid_solver.

  assert( H_valid_sst' := H_valid_sst ).
  unfold valid_sstate in H_valid_sst'.
  destruct H_valid_sst' as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].
  rewrite E_sstk in H_valid_sst_sstack.
  simpl in H_valid_sst_sstack.
  destruct H_valid_sst_sstack as [H_valid_sst_soffset H_valid_sst_sstk'].

  symmetry in H_eqsmv.
  
  pose proof (H_valid_solver (get_smap_sst sst) (get_memory_sst sst) soffset (get_instk_height_sst sst) smv ops H_valid_sst_smemory H_valid_sst_soffset H_eqsmv) as H_valid_smv.

  symmetry in E_add_to_smap.
  pose proof (add_to_map_valid_sstate sst key sm' smv ops H_valid_sst H_valid_smv E_add_to_smap) as H_valid_sst_smap_add.


  unfold valid_sstate in H_valid_sst_smap_add.
  rewrite instk_height_preserved_when_updating_smap_sst in H_valid_sst_smap_add.
  rewrite smemory_preserved_when_updating_smap_sst in H_valid_sst_smap_add.
  rewrite sstorage_preserved_when_updating_smap_sst in H_valid_sst_smap_add.
  rewrite set_and_then_get_smap_sst in H_valid_sst_smap_add.
  rewrite sstack_preserved_when_updating_smap_sst in H_valid_sst_smap_add.

  assert (H_valid_sst_smap_add' := H_valid_sst_smap_add).
  destruct H_valid_sst_smap_add' as [H_valid_sst_smap_add_smap [H_valid_sst_smap_add_sstack [H_valid_sst_smap_add_smemory H_valid_sst_smap_add_sstorage]]].

  unfold valid_sstate.
  rewrite instk_height_preserved_when_updating_smap_sst.
  rewrite instk_height_preserved_when_updating_stack_sst.
  rewrite smemory_preserved_when_updating_smap_sst.
  rewrite sstorage_preserved_when_updating_smap_sst.
  rewrite set_and_then_get_smap_sst.
  rewrite smemory_preserved_when_updating_stack_sst.
  rewrite sstorage_preserved_when_updating_stack_sst.
  rewrite sstack_preserved_when_updating_smap_sst.
  rewrite set_and_then_get_stack_sst.

  split.
  - apply H_valid_sst_smap_add.
  - split.
    + simpl. 
      split.
      * pose proof (add_to_smap_key_lt_maxidx (get_smap_sst sst) sm' key smv E_add_to_smap) as H_key_lt_maxidx.
        apply H_key_lt_maxidx.
      * destruct (get_smap_sst sst) as [maxidx sb] eqn:E_smap.
        simpl in E_add_to_smap.
        injection E_add_to_smap as H_maxidx H_sm'.
        rewrite H_sm'.
        simpl.
        apply valid_sstack_S_maxidx.
        simpl in H_valid_sst_sstk'.
        apply H_valid_sst_sstk'.
    + split.
      * apply H_valid_sst_smap_add_smemory.
      * apply H_valid_sst_smap_add_sstorage.
Qed.


(* sload generates valid states *)
Lemma sload_valid_sst:
  forall sst sst' ops sload_solver,
    valid_sstate sst ops ->
    sload_solver_snd sload_solver ->
    sload_s sload_solver sst ops = Some sst' ->
    valid_sstate sst' ops.
Proof.
  intros sst sst' ops sload_solver H_valid_sst H_valid_solver H_sload_s.
  
  unfold sload_s in H_sload_s.
  destruct (get_stack_sst sst) as [|skey sstk'] eqn:E_sstk; try discriminate.
  remember (sload_solver skey (get_storage_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) ops) as smv eqn:H_eqsmv.
  destruct (add_to_smap (get_smap_sst sst) smv) as [key sm'] eqn:E_add_to_smap.
  injection H_sload_s as H_sst'.
  rewrite <- H_sst'.

  unfold sload_solver_snd in H_valid_solver.
  destruct H_valid_solver as [H_valid_solver _].
  unfold sload_solver_valid_res in H_valid_solver.

  assert( H_valid_sst' := H_valid_sst ).
  unfold valid_sstate in H_valid_sst'.
  destruct H_valid_sst' as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].
  rewrite E_sstk in H_valid_sst_sstack.
  simpl in H_valid_sst_sstack.
  destruct H_valid_sst_sstack as [H_valid_sst_soffset H_valid_sst_sstk'].

  symmetry in H_eqsmv.
  
  pose proof (H_valid_solver (get_smap_sst sst) (get_storage_sst sst) skey (get_instk_height_sst sst) smv ops H_valid_sst_sstorage H_valid_sst_soffset H_eqsmv) as H_valid_smv.

  symmetry in E_add_to_smap.
  pose proof (add_to_map_valid_sstate sst key sm' smv ops H_valid_sst H_valid_smv E_add_to_smap) as H_valid_sst_smap_add.


  unfold valid_sstate in H_valid_sst_smap_add.
  rewrite instk_height_preserved_when_updating_smap_sst in H_valid_sst_smap_add.
  rewrite smemory_preserved_when_updating_smap_sst in H_valid_sst_smap_add.
  rewrite sstorage_preserved_when_updating_smap_sst in H_valid_sst_smap_add.
  rewrite set_and_then_get_smap_sst in H_valid_sst_smap_add.
  rewrite sstack_preserved_when_updating_smap_sst in H_valid_sst_smap_add.

  assert (H_valid_sst_smap_add' := H_valid_sst_smap_add).
  destruct H_valid_sst_smap_add' as [H_valid_sst_smap_add_smap [H_valid_sst_smap_add_sstack [H_valid_sst_smap_add_smemory H_valid_sst_smap_add_sstorage]]].

  unfold valid_sstate.
  rewrite instk_height_preserved_when_updating_smap_sst.
  rewrite instk_height_preserved_when_updating_stack_sst.
  rewrite smemory_preserved_when_updating_smap_sst.
  rewrite sstorage_preserved_when_updating_smap_sst.
  rewrite set_and_then_get_smap_sst.
  rewrite smemory_preserved_when_updating_stack_sst.
  rewrite sstorage_preserved_when_updating_stack_sst.
  rewrite sstack_preserved_when_updating_smap_sst.
  rewrite set_and_then_get_stack_sst.

  split.
  - apply H_valid_sst_smap_add.
  - split.
    + simpl. 
      split.
      * pose proof (add_to_smap_key_lt_maxidx (get_smap_sst sst) sm' key smv E_add_to_smap) as H_key_lt_maxidx.
        apply H_key_lt_maxidx.
      * destruct (get_smap_sst sst) as [maxidx sb] eqn:E_smap.
        simpl in E_add_to_smap.
        injection E_add_to_smap as H_maxidx H_sm'.
        rewrite H_sm'.
        simpl.
        apply valid_sstack_S_maxidx.
        simpl in H_valid_sst_sstk'.
        apply H_valid_sst_sstk'.
    + split.
      * apply H_valid_sst_smap_add_smemory.
      * apply H_valid_sst_smap_add_sstorage.
Qed.


(* mstore generates valid states *)
Lemma mstore_valid_sst:
  forall sst sst' ops smemory_updater,
    smemory_updater_snd smemory_updater ->
    valid_sstate sst ops ->
    mstore_s smemory_updater sst ops = Some sst' ->
    valid_sstate sst' ops.
Proof.
  intros sst sst' ops smemory_updater H_smemory_updater_snd H_valid_sst H_mstore_s.
  unfold mstore_s in H_mstore_s.
  destruct (get_stack_sst sst) as [|soffset sstk'] eqn:E_sstk; try discriminate.
  destruct sstk' as [|svalue sstk''] eqn:E_sstk'; try discriminate.
  injection H_mstore_s as H_sst'.
  remember (smemory_updater (U_MSTORE sstack_val soffset svalue) (get_memory_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) ops) as smem' eqn:E_smem'.
  rewrite <- H_sst'.

  assert ( H_valid_sst' := H_valid_sst ).
  unfold valid_sstate in H_valid_sst'.
  destruct H_valid_sst' as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].
  
  rewrite E_sstk in H_valid_sst_sstack.
  simpl in H_valid_sst_sstack.
  destruct H_valid_sst_sstack as [H_valid_soffset [H_valid_svalue H_valid_sstk']].

  pose proof (valid_smemory_update_ov (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) soffset svalue H_valid_soffset H_valid_svalue) as [H_valid_u _].

  unfold smemory_updater_snd in H_smemory_updater_snd.
  destruct H_smemory_updater_snd as [H_smemory_updater_valid _].
  unfold smemory_updater_valid_res in H_smemory_updater_valid.

  symmetry in E_smem'.
  pose proof (H_smemory_updater_valid (get_smap_sst sst) (get_memory_sst sst) smem' (U_MSTORE sstack_val soffset svalue) (get_instk_height_sst sst) ops H_valid_sst_smemory H_valid_u E_smem') as H_valid_smem'.

  unfold valid_sstate.
  rewrite instk_height_preserved_when_updating_stack_sst.
  rewrite instk_height_preserved_when_updating_memory_sst.
  rewrite smap_preserved_when_updating_stack_sst.
  rewrite smap_preserved_when_updating_memory_sst.
  rewrite set_and_then_get_stack_sst.
  rewrite smemory_preserved_when_updating_stack_sst.
  rewrite set_and_then_get_memory_sst.
  rewrite sstorage_preserved_when_updating_stack_sst.
  rewrite sstorage_preserved_when_updating_memory_sst.
  split.
  - apply H_valid_sst_smap.
  - split.
    + apply H_valid_sstk'.
    + split.
      * apply H_valid_smem'.
      * apply H_valid_sst_sstorage.
Qed.

(* mstore8 generates valid states *)
Lemma mstore8_valid_sst:
  forall sst sst' ops smemory_updater,
    smemory_updater_snd smemory_updater ->
    valid_sstate sst ops ->
    mstore8_s smemory_updater sst ops = Some sst' ->
    valid_sstate sst' ops.
Proof.
  intros sst sst' ops smemory_updater H_smemory_updater_snd H_valid_sst H_mstore_s.
  unfold mstore8_s in H_mstore_s.
  destruct (get_stack_sst sst) as [|soffset sstk'] eqn:E_sstk; try discriminate.
  destruct sstk' as [|svalue sstk''] eqn:E_sstk'; try discriminate.
  injection H_mstore_s as H_sst'.
  remember (smemory_updater (U_MSTORE8 sstack_val soffset svalue) (get_memory_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) ops) as smem' eqn:E_smem'.
  rewrite <- H_sst'.

  assert ( H_valid_sst' := H_valid_sst ).
  unfold valid_sstate in H_valid_sst'.
  destruct H_valid_sst' as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].
  
  rewrite E_sstk in H_valid_sst_sstack.
  simpl in H_valid_sst_sstack.
  destruct H_valid_sst_sstack as [H_valid_soffset [H_valid_svalue H_valid_sstk']].

  pose proof (valid_smemory_update_ov (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) soffset svalue H_valid_soffset H_valid_svalue) as [H_valid_u _].

  unfold smemory_updater_snd in H_smemory_updater_snd.
  destruct H_smemory_updater_snd as [H_smemory_updater_valid _].
  unfold smemory_updater_valid_res in H_smemory_updater_valid.

  symmetry in E_smem'.
  pose proof (H_smemory_updater_valid (get_smap_sst sst) (get_memory_sst sst) smem' (U_MSTORE8 sstack_val soffset svalue) (get_instk_height_sst sst) ops H_valid_sst_smemory H_valid_u E_smem') as H_valid_smem'.

  unfold valid_sstate.
  rewrite instk_height_preserved_when_updating_stack_sst.
  rewrite instk_height_preserved_when_updating_memory_sst.
  rewrite smap_preserved_when_updating_stack_sst.
  rewrite smap_preserved_when_updating_memory_sst.
  rewrite set_and_then_get_stack_sst.
  rewrite smemory_preserved_when_updating_stack_sst.
  rewrite set_and_then_get_memory_sst.
  rewrite sstorage_preserved_when_updating_stack_sst.
  rewrite sstorage_preserved_when_updating_memory_sst.
  split.
  - apply H_valid_sst_smap.
  - split.
    + apply H_valid_sstk'.
    + split.
      * apply H_valid_smem'.
      * apply H_valid_sst_sstorage.
Qed.

(* sstore generates valid states *)
Lemma sstore_valid_sst:
  forall sst sst' ops sstorage_updater,
    sstorage_updater_snd sstorage_updater ->
    valid_sstate sst ops ->
    sstore_s sstorage_updater sst ops = Some sst' ->
    valid_sstate sst' ops.
Proof.
  intros sst sst' ops sstorage_updater H_sstorage_updater_snd H_valid_sst H_sstore_s.
  unfold sstore_s in H_sstore_s.
  destruct (get_stack_sst sst) as [|skey sstk'] eqn:E_sstk; try discriminate.
  destruct sstk' as [|svalue sstk''] eqn:E_sstk'; try discriminate.
  injection H_sstore_s as H_sst'.
  remember (sstorage_updater (U_SSTORE sstack_val skey svalue) (get_storage_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) ops) as sstrg' eqn:E_sstrg'.
  rewrite <- H_sst'.

  assert ( H_valid_sst' := H_valid_sst ).
  unfold valid_sstate in H_valid_sst'.
  destruct H_valid_sst' as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].
  
  rewrite E_sstk in H_valid_sst_sstack.
  simpl in H_valid_sst_sstack.
  destruct H_valid_sst_sstack as [H_valid_soffset [H_valid_svalue H_valid_sstk']].

  pose proof (valid_sstorage_update_kv (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) skey svalue H_valid_soffset H_valid_svalue) as H_valid_u.

  unfold sstorage_updater_snd in H_sstorage_updater_snd.
  destruct H_sstorage_updater_snd as [H_sstorage_updater_valid _].
  unfold sstorage_updater_valid_res in H_sstorage_updater_valid.

  symmetry in E_sstrg'.
  pose proof (H_sstorage_updater_valid (get_smap_sst sst) (get_storage_sst sst) sstrg' (U_SSTORE sstack_val skey svalue) (get_instk_height_sst sst) ops H_valid_sst_sstorage H_valid_u E_sstrg') as H_valid_sstrg'.

  unfold valid_sstate.
  rewrite instk_height_preserved_when_updating_stack_sst.
  rewrite instk_height_preserved_when_updating_storage_sst.
  rewrite smap_preserved_when_updating_stack_sst.
  rewrite smap_preserved_when_updating_storage_sst.
  rewrite set_and_then_get_stack_sst.
  rewrite smemory_preserved_when_updating_stack_sst.
  rewrite smemory_preserved_when_updating_storage_sst.
  rewrite sstorage_preserved_when_updating_stack_sst.
  rewrite set_and_then_get_storage_sst.
  
  split.
  - apply H_valid_sst_smap.
  - split.
    + apply H_valid_sstk'.
    + split.
      * apply H_valid_sst_smemory.
      * apply H_valid_sstrg'.
Qed.

(* sha3 generates valid states *)
Lemma sha3_valid_sst:
  forall sst sst' ops,
    valid_sstate sst ops ->
    sha3_s sst ops = Some sst' ->
    valid_sstate sst' ops.
Proof.
  intros sst sst' ops H_valid_sst H_sha3_s.
  unfold sha3_s in H_sha3_s.
  destruct (get_stack_sst sst) as [|soffset sstk'] eqn:E_sstk; try discriminate.
  destruct sstk' as [|ssize sstk''] eqn:E_sstk'; try discriminate.

  destruct (add_to_smap (get_smap_sst sst) (SymSHA3 soffset ssize (get_memory_sst sst))) as [key sm'] eqn:E_add_to_smap.
  injection H_sha3_s as  H_sst'.

  assert ( H_valid_sst' := H_valid_sst ).
  unfold valid_sstate in H_valid_sst'.
  destruct H_valid_sst' as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].
  
  rewrite E_sstk in H_valid_sst_sstack.
  simpl in H_valid_sst_sstack.
  destruct H_valid_sst_sstack as [H_valid_soffset [H_valid_ssize H_valid_sstk'']].
  
  pose proof (sha3_smv (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) ops (get_memory_sst sst) soffset ssize H_valid_sst_smemory H_valid_soffset H_valid_ssize) as H_valid_smv.

  symmetry in E_add_to_smap.
  pose proof (add_to_map_valid_sstate sst key sm' (SymSHA3 soffset ssize (get_memory_sst sst)) ops H_valid_sst H_valid_smv E_add_to_smap) as H_valid_sst_smap_add.

  unfold valid_sstate in H_valid_sst_smap_add.
  rewrite instk_height_preserved_when_updating_smap_sst in H_valid_sst_smap_add.
  rewrite set_and_then_get_smap_sst in H_valid_sst_smap_add.
  rewrite sstack_preserved_when_updating_smap_sst in H_valid_sst_smap_add.
  rewrite sstorage_preserved_when_updating_smap_sst in H_valid_sst_smap_add.
  rewrite smemory_preserved_when_updating_smap_sst in H_valid_sst_smap_add.
  destruct H_valid_sst_smap_add as [H_valid_sst_smap_add_smap [H_valid_sst_smap_add_sstack [H_valid_sst_smap_add_smemory H_valid_sst_smap_add_sstorage]]].

  rewrite <- H_sst'.
  unfold valid_sstate.
  rewrite instk_height_preserved_when_updating_smap_sst.
  rewrite instk_height_preserved_when_updating_stack_sst.
  rewrite set_and_then_get_smap_sst.
  rewrite sstack_preserved_when_updating_smap_sst.
  rewrite set_and_then_get_stack_sst.
  rewrite smemory_preserved_when_updating_smap_sst.
  rewrite smemory_preserved_when_updating_stack_sst.
  rewrite sstorage_preserved_when_updating_smap_sst.
  rewrite sstorage_preserved_when_updating_stack_sst.
  
  split.
  (* there are many duplication of destructing (get_smap_sst sst) -- revise later *)
  - apply H_valid_sst_smap_add_smap.
  - split.
    + unfold valid_sstack. fold valid_sstack.
      split.
      * unfold valid_sstack_value.
        pose proof (add_to_smap_key_lt_maxidx (get_smap_sst sst) sm' key (SymSHA3 soffset ssize (get_memory_sst sst)) E_add_to_smap) as H_key_lt_maxidx.
        apply H_key_lt_maxidx.
      * destruct (get_smap_sst sst) as [maxidx sb] eqn:E_smap.
        simpl in E_add_to_smap.
        injection E_add_to_smap as H_maxidx H_sm'.
        rewrite H_sm'.
        simpl.
        apply valid_sstack_S_maxidx.
        simpl in H_valid_sstk''.
        apply H_valid_sstk''.
    + split.
      * destruct (get_smap_sst sst) as [maxidx sb] eqn:E_smap.
        simpl in E_add_to_smap.
        injection E_add_to_smap as H_maxidx H_sm'.
        rewrite H_sm'.
        simpl.
        simpl in H_valid_sst_smemory.
        apply valid_smemory_S_maxidx.
        apply H_valid_sst_smemory.
      * destruct (get_smap_sst sst) as [maxidx sb] eqn:E_smap.
        simpl in E_add_to_smap.
        injection E_add_to_smap as H_maxidx H_sm'.
        rewrite H_sm'.
        simpl.
        simpl in H_valid_sst_sstorage.
        apply valid_sstorage_S_maxidx.
        apply H_valid_sst_sstorage.
Qed.

(* Abstract transformers in symbolic execution are sound *)

(* Applying eval_sstack_val' on (Val w) returns Some w *)
Lemma eval_sstack_val'_Val:
forall (w: EVMWord) (stk: stack) (mem: memory) (strg: storage) (ctx: context) (maxidx: nat) (bs: sbindings) (ops: stack_op_instr_map),
    eval_sstack_val' (S maxidx) (Val w) stk mem strg ctx maxidx bs ops = Some w.
Proof.
  intros.
  destruct bs; reflexivity.
Qed.

(* Applying eval_sstack_val on (Val w) returns Some w *)
Lemma eval_sstack_val_Val:
forall (w: EVMWord) (stk: stack) (mem: memory) (strg: storage) (ctx: context) (maxidx: nat) (bs: sbindings) (ops: stack_op_instr_map),
    eval_sstack_val (Val w) stk mem strg ctx maxidx bs ops = Some w.
Proof.
  intros.
  unfold eval_sstack_val.
  apply eval_sstack_val'_Val.
Qed.

(* Applying eval_sstack_val' on (InStackVar i) returns (nth_error stk i) *)
Lemma eval_sstack_val'_InStackVar:
forall (i:nat) (stk: stack) (mem: memory) (strg: storage) (ctx: context) (maxidx: nat) (bs: sbindings) (ops: stack_op_instr_map),
    eval_sstack_val' (S maxidx) (InStackVar i) stk mem strg ctx maxidx bs ops = nth_error stk i.
Proof.
  intros.
  unfold eval_sstack_val'.
  destruct bs; unfold follow_in_smap; destruct (nth_error stk i); reflexivity.
Qed.

(* Applying eval_sstack_val on (InStackVar i) returns (nth_error stk i) *)
Lemma eval_sstack_val_InStackVar:
forall (i:nat) (stk: stack) (mem: memory) (strg: storage) (ctx: context) (maxidx: nat) (bs: sbindings) (ops: stack_op_instr_map),
    eval_sstack_val (InStackVar i) stk mem strg ctx maxidx bs ops = nth_error stk i.
Proof.
  intros.
  unfold eval_sstack_val.
  apply eval_sstack_val'_InStackVar.
Qed.

(* 
If applying eval_sstack on sstk return Some stk', then applying it on (Val w)::sstk returns Some (w::stk')
*)
Lemma eval_sstack_w:
  forall (w : EVMWord) (sstk: sstack) (stk stk': stack) (mem: memory) (strg: storage) (ctx: context) (maxidx: nat) (sb: sbindings) (ops: stack_op_instr_map),
    eval_sstack sstk maxidx sb stk mem strg ctx ops = Some stk' ->
    eval_sstack ((Val w)::sstk) maxidx sb stk mem strg ctx ops = Some (w::stk').
Proof.
  intros w sstk stk stk' mem strg ctx maxidx sb ops H_eval_sstack_stk.
  unfold eval_sstack.
  unfold map_option.
  rewrite <- map_option_ho.
  rewrite eval_sstack_val_Val.
  unfold eval_sstack in H_eval_sstack_stk.
  rewrite H_eval_sstack_stk.
  reflexivity.
Qed.

(* Like eval_sstack_w, but stated on states.  *)
Lemma eval_sstate_w:
  forall (w : EVMWord) (sst : sstate) (st st': state) (ops: stack_op_instr_map),
    eval_sstate st sst ops = Some st' ->
    eval_sstate st (set_stack_sst sst ((Val w)::(get_stack_sst sst))) ops = Some (set_stack_st st' (w::(get_stack_st st'))).
Proof.
  intros w sst st st' ops H_eval_sst.
  unfold eval_sstate in H_eval_sst.

  destruct (get_instk_height_sst sst =? length (get_stack_st st)) eqn:E_len; try discriminate.

  destruct (eval_sstack (get_stack_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st st) (get_memory_st st) (get_storage_st st) (get_context_st st) ops) as [stk|] eqn:E_eval_sstack; try discriminate.

  unfold eval_sstate.
  
  rewrite instk_height_preserved_when_updating_stack_sst.
  rewrite E_len.
  rewrite smap_preserved_when_updating_stack_sst.
  rewrite set_and_then_get_stack_sst.

  pose proof (eval_sstack_w w (get_stack_sst sst) (get_stack_st st) stk (get_memory_st st) (get_storage_st st) (get_context_st st) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) ops E_eval_sstack) as H_eval_sstack_w.
  rewrite H_eval_sstack_w.
  rewrite smemory_preserved_when_updating_stack_sst.
  rewrite sstorage_preserved_when_updating_stack_sst.

  destruct (eval_smemory (get_memory_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st st) (get_memory_st st) (get_storage_st st) (get_context_st st) ops); try discriminate.

  destruct (eval_sstorage (get_storage_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st st) (get_memory_st st) (get_storage_st st) (get_context_st st) ops); try discriminate.

  injection H_eval_sst as H_st'. (* get the value of st' *)
  rewrite <- H_st'. simpl.
  unfold make_st.

  reflexivity.
Qed.

(* eval_sstack generate a list of the smae length as the input *)
Lemma eval_sstack_len:
  forall (sstk: sstack) (stk stk': stack) (mem: memory) (strg: storage) (ctx: context) (maxidx: nat) (sb: sbindings) (ops: stack_op_instr_map),
    eval_sstack sstk maxidx sb stk mem strg ctx ops = Some stk' ->
    length sstk = length stk'.
Proof.
  intros sstl stk stk' mem strg ctx maxidx sb ops H_eval_sstack.
  unfold eval_sstack in H_eval_sstack.
  apply map_option_len in H_eval_sstack.
  apply H_eval_sstack.
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
  destruct (get_instk_height_sst sst =? length (get_stack_st init_st)) eqn:E_len; try discriminate.
  
  apply beq_nat_true in E_len.

  destruct (eval_sstack (get_stack_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [|] eqn:E_eval_sstack; try discriminate.

  destruct (eval_smemory (get_memory_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [mem|]  eqn:E_eval_smemory; try discriminate.

  destruct (eval_sstorage (get_storage_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [strg|]  eqn:E_eval_sstorage; try discriminate.
  
  split.
  + apply eval_sstack_len in E_eval_sstack.
    rewrite E_eval_sstack.
    apply eq_execution_states_stack_len in H_inst_r.
    rewrite  H_inst_r.
    injection H_inst_l as H_st'.
    rewrite <- H_st'.
    unfold make_st.
    simpl.
    reflexivity.
  + symmetry.
    apply E_len.
Qed.


(* Extending an smap with a new value, does not affect follow_in_smap. *)
Lemma follow_in_smap_preserved_when_smap_extended:
  forall instk_height m m' smv idx' idx x,
    valid_sstack_value instk_height (get_maxidx_smap m) (FreshVar idx) ->
    (add_to_smap m smv) = (idx', m') ->
    follow_in_smap (FreshVar idx) (get_maxidx_smap m) (get_bindings_smap m) = Some x ->
    follow_in_smap  (FreshVar idx) (get_maxidx_smap m') (get_bindings_smap m') = Some x.
Proof.
  intros instk_height m m' smv idx' idx x.
  intros H_valid_sstack_value H_add_to_smap H_follow_in_smap.
  destruct m.
  destruct m'.
  simpl in H_valid_sstack_value.
  simpl in H_add_to_smap.
  simpl in H_follow_in_smap.
  simpl.
  injection H_add_to_smap as H_maxid_idx' H_m' H_sb.
  rewrite <- H_sb.
  destruct bindings; try discriminate.
  simpl.
  apply Nat.lt_neq in H_valid_sstack_value as H_maxidx_idx.
  apply Nat.neq_sym in H_maxidx_idx.
  apply Nat.eqb_neq in H_maxidx_idx.
  rewrite H_maxidx_idx.
  simpl in H_follow_in_smap.
  apply H_follow_in_smap.
Qed.


(* Extending an smap with a new value, does not affect eval_sstack_val when applied to valid_sstack_value. *)
Lemma eval_sstack_val'_preserved_when_smap_extended:
  forall instk_height m m' sv smv v stk mem strg ctx ops idx',
    valid_sstack_value instk_height (get_maxidx_smap m)  sv ->
    (add_to_smap m smv) = (idx', m') ->
    eval_sstack_val' (S (get_maxidx_smap m)) sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops = Some v ->
    eval_sstack_val' (S (get_maxidx_smap m')) sv stk mem strg ctx (get_maxidx_smap m') (get_bindings_smap m') ops = Some v.
Proof.
  intros instk_height m m' sv smv v stk mem strg ctx ops idx' H_valid_sv H_add_to_smap H_eval_sstack.

  destruct sv as [val|n|idx] eqn:E_sv.
  
  + pose proof (eval_sstack_val'_Val val stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops) as H_eval_sstack_val'_Val.
    rewrite H_eval_sstack_val'_Val in H_eval_sstack.
    rewrite <- H_eval_sstack.
    pose proof (eval_sstack_val'_Val val stk mem strg ctx (get_maxidx_smap m') (get_bindings_smap m') ops) as H_eval_sstack_val'_Val_0.
    rewrite H_eval_sstack_val'_Val_0.
    reflexivity.

  + pose proof (eval_sstack_val'_InStackVar n stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops) as H_eval_sstack_val'_InStackVar.
    rewrite H_eval_sstack_val'_InStackVar in H_eval_sstack.
    rewrite <- H_eval_sstack.
    pose proof (eval_sstack_val'_InStackVar n stk mem strg ctx (get_maxidx_smap m') (get_bindings_smap m') ops) as H_eval_sstack_val'_InStackVar_0.
    rewrite H_eval_sstack_val'_InStackVar_0.
    reflexivity.

  + simpl in H_eval_sstack.
    destruct (follow_in_smap (FreshVar idx) (get_maxidx_smap m) (get_bindings_smap m)) as [smv'|] eqn:E_follow; try discriminate.
    pose proof (follow_in_smap_preserved_when_smap_extended instk_height m m' smv idx' idx smv' H_valid_sv H_add_to_smap E_follow) as E_follow_ext.

    destruct m as [maxidx sb].
    destruct m' as [maxidx' sb'].
    unfold get_bindings_smap.
    unfold get_maxidx_smap.

    unfold get_bindings_smap in H_eval_sstack.
    unfold get_maxidx_smap in H_eval_sstack.

    unfold get_bindings_smap in E_follow_ext.
    unfold get_maxidx_smap in E_follow_ext.

    assert (H_add_to_smap':=H_add_to_smap).
    simpl in H_add_to_smap'.
    injection H_add_to_smap' as H_idx' H_maxidx' H_sb'.
    simpl.
    rewrite E_follow_ext.
    rewrite <- H_maxidx'.
    
    destruct smv'; try discriminate.
    destruct smv0.
    * apply H_eval_sstack.
    * apply H_eval_sstack.
    * destruct (ops label) eqn:E_label; try discriminate.
      destruct (length args =? n) eqn:E_len; try discriminate.
      destruct (map_option (fun sv' : sstack_val => eval_sstack_val' maxidx sv' stk mem strg ctx key sb0 ops) args) eqn:E_mapo_args; try discriminate.

      assert(H_mapo:
              forall args d maxidx sb l,
                (map_option (fun sv' : sstack_val => eval_sstack_val' d sv' stk mem strg ctx maxidx sb ops) args) = Some l ->
                (map_option (fun sv' : sstack_val => eval_sstack_val' (S d) sv' stk mem strg ctx maxidx sb ops) args) = Some l).

    (* proof of assert *)
      ** induction args0 as [|a args0' IHargs0'].
         *** intuition.
         *** intros d maxidx0 sb1 l0 H_mapo.
             simpl in H_mapo.
             destruct (eval_sstack_val' d a stk mem strg ctx maxidx0 sb1 ops) eqn:E_eval_sstack_val'; try discriminate.
             destruct (map_option (fun sv' : sstack_val => eval_sstack_val' d sv' stk mem strg ctx maxidx0 sb1 ops) args0') eqn:E_mapo'; try discriminate.
        pose proof (IHargs0' d maxidx0 sb1 l1 E_mapo') as IHargs'_0.
        pose proof (eval_sstack_val'_preserved_when_depth_extended d maxidx0 sb1 a e stk mem strg ctx ops E_eval_sstack_val') as H_eval_sstack_val'_preserved_when_depth_extended_0.
        unfold map_option.
        rewrite <- map_option_ho.
        rewrite H_eval_sstack_val'_preserved_when_depth_extended_0.
        rewrite IHargs'_0.
        apply H_mapo.
    (* end proof of assert *)
      ** pose proof (H_mapo args maxidx key sb0 l E_mapo_args) as H_mapo.
         rewrite H_mapo.
         apply H_eval_sstack.

    * assert(H_mapo_mem :
              forall args d maxidx sb l,
                (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv' : sstack_val => eval_sstack_val' d sv' stk mem strg ctx maxidx sb ops)) args) = Some l ->
                (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv' : sstack_val => eval_sstack_val' (S d) sv' stk mem strg ctx maxidx sb ops)) args) = Some l).
      
                (* proof of assert *)
            ** induction args as [|a args' IHargs'].
               *** intuition.
               *** intros d maxidx0 sb1 l H_mapo_mem.
                   simpl in H_mapo_mem.
                   unfold eval_common.EvalCommon.instantiate_memory_update in H_mapo_mem at 1.
                   destruct a eqn:E_a.
                   **** destruct (eval_sstack_val' d offset0 stk mem strg ctx maxidx0 sb1 ops) eqn:E_offset0; try discriminate.
                        destruct (eval_sstack_val' d value stk mem strg ctx maxidx0 sb1 ops) eqn:E_value; try discriminate.
                        destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv' : sstack_val => eval_sstack_val' d sv' stk mem strg ctx maxidx0 sb1 ops)) args') eqn:E_mapo_args'; try discriminate.
                        pose proof (eval_sstack_val'_preserved_when_depth_extended d maxidx0 sb1 offset0 e stk mem strg ctx ops E_offset0) as H_eval_sstack_val'_preserved_when_depth_extended_0.
                        pose proof (eval_sstack_val'_preserved_when_depth_extended d maxidx0 sb1 value e0 stk mem strg ctx ops E_value) as H_eval_sstack_val'_preserved_when_depth_extended_1.
                        pose proof (IHargs' d maxidx0 sb1 l0 E_mapo_args') as IHargs'_0.
                        unfold map_option.
                        rewrite <- map_option_ho.
                        unfold eval_common.EvalCommon.instantiate_memory_update at 1.
                        rewrite H_eval_sstack_val'_preserved_when_depth_extended_0.
                        rewrite H_eval_sstack_val'_preserved_when_depth_extended_1.
                        rewrite IHargs'_0.
                        apply H_mapo_mem.
                   **** destruct (eval_sstack_val' d offset0 stk mem strg ctx maxidx0 sb1 ops) eqn:E_offset0; try discriminate.
                        destruct (eval_sstack_val' d value stk mem strg ctx maxidx0 sb1 ops) eqn:E_value; try discriminate.
                        destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv' : sstack_val => eval_sstack_val' d sv' stk mem strg ctx maxidx0 sb1 ops)) args') eqn:E_mapo_args'; try discriminate.
                        pose proof (eval_sstack_val'_preserved_when_depth_extended d maxidx0 sb1 offset0 e stk mem strg ctx ops E_offset0) as H_eval_sstack_val'_preserved_when_depth_extended_0.
                        pose proof (eval_sstack_val'_preserved_when_depth_extended d maxidx0 sb1 value e0 stk mem strg ctx ops E_value) as H_eval_sstack_val'_preserved_when_depth_extended_1.
                        pose proof (IHargs' d maxidx0 sb1 l0 E_mapo_args') as IHargs'_0.
                        unfold map_option.
                        rewrite <- map_option_ho.
                        unfold eval_common.EvalCommon.instantiate_memory_update at 1.
                        rewrite H_eval_sstack_val'_preserved_when_depth_extended_0.
                        rewrite H_eval_sstack_val'_preserved_when_depth_extended_1.
                        rewrite IHargs'_0.
                        apply H_mapo_mem.
                        (* end proof of assert *)

            ** destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' maxidx sv stk mem strg ctx key sb0 ops)) smem) eqn:E_mapo_smem; try discriminate.
               destruct (eval_sstack_val' maxidx offset stk mem strg ctx key sb0 ops) eqn:E_eval_offset; try discriminate.
               pose proof (H_mapo_mem smem maxidx key sb0 l E_mapo_smem) as H_mapo_smem_0.
               rewrite H_mapo_smem_0.
               pose proof (eval_sstack_val'_preserved_when_depth_extended maxidx key sb0 offset e stk mem strg ctx ops E_eval_offset) as H_eval_sstack_val'_preserved_when_depth_extended_0.
               rewrite H_eval_sstack_val'_preserved_when_depth_extended_0.
               apply H_eval_sstack.
               
    * assert(H_mapo_strg :
              forall args d maxidx sb l,
                (map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv' : sstack_val => eval_sstack_val' d sv' stk mem strg ctx maxidx sb ops)) args) = Some l ->
                (map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv' : sstack_val => eval_sstack_val' (S d) sv' stk mem strg ctx maxidx sb ops)) args) = Some l).
      
                (* proof of assert *)
            ** induction args as [|a args' IHargs'].
               *** intuition.
               *** intros d maxidx0 sb1 l H_mapo_strg.
                   simpl in H_mapo_strg.
                   destruct a as [skey svalue].
                   unfold eval_common.EvalCommon.instantiate_storage_update in H_mapo_strg at 1.
                   destruct (eval_sstack_val' d skey stk mem strg ctx maxidx0 sb1 ops) eqn:E_skey; try discriminate.
                   destruct (eval_sstack_val' d svalue stk mem strg ctx maxidx0 sb1 ops) eqn:E_svalue; try discriminate.
                   destruct (map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv' : sstack_val => eval_sstack_val' d sv' stk mem strg ctx maxidx0 sb1 ops)) args') eqn:E_mapo_args'; try discriminate.
                   pose proof (eval_sstack_val'_preserved_when_depth_extended d maxidx0 sb1 skey e stk mem strg ctx ops E_skey) as H_eval_sstack_val'_preserved_when_depth_extended_0.
                   pose proof (eval_sstack_val'_preserved_when_depth_extended d maxidx0 sb1 svalue e0 stk mem strg ctx ops E_svalue) as H_eval_sstack_val'_preserved_when_depth_extended_1.
                   pose proof (IHargs' d maxidx0 sb1 l0 E_mapo_args') as IHargs'_0.
                   unfold map_option.
                   rewrite <- map_option_ho.
                   unfold eval_common.EvalCommon.instantiate_storage_update at 1.
                   rewrite H_eval_sstack_val'_preserved_when_depth_extended_0.
                   rewrite H_eval_sstack_val'_preserved_when_depth_extended_1.
                   rewrite IHargs'_0.
                   apply H_mapo_strg.
            (* end proof of assert *)

            ** destruct (map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val' maxidx sv stk mem strg ctx key sb0 ops)) sstrg) eqn:E_mapo_sstrg; try discriminate.
               destruct (eval_sstack_val' maxidx key0 stk mem strg ctx key sb0 ops) eqn:E_eval_skey0; try discriminate.
               pose proof (H_mapo_strg sstrg maxidx key sb0 l E_mapo_sstrg) as H_mapo_sstrg_0.
               rewrite H_mapo_sstrg_0.
               pose proof (eval_sstack_val'_preserved_when_depth_extended maxidx key sb0 key0 e stk mem strg ctx ops E_eval_skey0) as H_eval_sstack_val'_preserved_when_depth_extended_0.
               rewrite H_eval_sstack_val'_preserved_when_depth_extended_0.
               apply H_eval_sstack.
               
    * assert(H_mapo_mem :
              forall args d maxidx sb l,
                (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv' : sstack_val => eval_sstack_val' d sv' stk mem strg ctx maxidx sb ops)) args) = Some l ->
                (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv' : sstack_val => eval_sstack_val' (S d) sv' stk mem strg ctx maxidx sb ops)) args) = Some l).
      
                (* proof of assert *)
            ** induction args as [|a args' IHargs'].
               *** intuition.
               *** intros d maxidx0 sb1 l H_mapo_mem.
                   simpl in H_mapo_mem.
                   unfold eval_common.EvalCommon.instantiate_memory_update in H_mapo_mem at 1.
                   destruct a eqn:E_a.
                   **** destruct (eval_sstack_val' d offset0 stk mem strg ctx maxidx0 sb1 ops) eqn:E_offset0; try discriminate.
                        destruct (eval_sstack_val' d value stk mem strg ctx maxidx0 sb1 ops) eqn:E_value; try discriminate.
                        destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv' : sstack_val => eval_sstack_val' d sv' stk mem strg ctx maxidx0 sb1 ops)) args') eqn:E_mapo_args'; try discriminate.
                        pose proof (eval_sstack_val'_preserved_when_depth_extended d maxidx0 sb1 offset0 e stk mem strg ctx ops E_offset0) as H_eval_sstack_val'_preserved_when_depth_extended_0.
                        pose proof (eval_sstack_val'_preserved_when_depth_extended d maxidx0 sb1 value e0 stk mem strg ctx ops E_value) as H_eval_sstack_val'_preserved_when_depth_extended_1.
                        pose proof (IHargs' d maxidx0 sb1 l0 E_mapo_args') as IHargs'_0.
                        unfold map_option.
                        rewrite <- map_option_ho.
                        unfold eval_common.EvalCommon.instantiate_memory_update at 1.
                        rewrite H_eval_sstack_val'_preserved_when_depth_extended_0.
                        rewrite H_eval_sstack_val'_preserved_when_depth_extended_1.
                        rewrite IHargs'_0.
                        apply H_mapo_mem.
                   **** destruct (eval_sstack_val' d offset0 stk mem strg ctx maxidx0 sb1 ops) eqn:E_offset0; try discriminate.
                        destruct (eval_sstack_val' d value stk mem strg ctx maxidx0 sb1 ops) eqn:E_value; try discriminate.
                        destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv' : sstack_val => eval_sstack_val' d sv' stk mem strg ctx maxidx0 sb1 ops)) args') eqn:E_mapo_args'; try discriminate.
                        pose proof (eval_sstack_val'_preserved_when_depth_extended d maxidx0 sb1 offset0 e stk mem strg ctx ops E_offset0) as H_eval_sstack_val'_preserved_when_depth_extended_0.
                        pose proof (eval_sstack_val'_preserved_when_depth_extended d maxidx0 sb1 value e0 stk mem strg ctx ops E_value) as H_eval_sstack_val'_preserved_when_depth_extended_1.
                        pose proof (IHargs' d maxidx0 sb1 l0 E_mapo_args') as IHargs'_0.
                        unfold map_option.
                        rewrite <- map_option_ho.
                        unfold eval_common.EvalCommon.instantiate_memory_update at 1.
                        rewrite H_eval_sstack_val'_preserved_when_depth_extended_0.
                        rewrite H_eval_sstack_val'_preserved_when_depth_extended_1.
                        rewrite IHargs'_0.
                        apply H_mapo_mem.
                        (* end proof of assert *)

            ** destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' maxidx sv stk mem strg ctx key sb0 ops)) smem) eqn:E_mapo_smem; try discriminate.
               destruct (eval_sstack_val' maxidx offset stk mem strg ctx key sb0 ops) eqn:E_eval_offset; try discriminate.
               destruct (eval_sstack_val' maxidx size stk mem strg ctx key sb0 ops) eqn:E_eval_size; try discriminate.
               pose proof (H_mapo_mem smem maxidx key sb0 l E_mapo_smem) as H_mapo_smem_0.
               rewrite H_mapo_smem_0.
               pose proof (eval_sstack_val'_preserved_when_depth_extended maxidx key sb0 offset e stk mem strg ctx ops E_eval_offset) as H_eval_sstack_val'_preserved_when_depth_extended_0.
               rewrite H_eval_sstack_val'_preserved_when_depth_extended_0.
               pose proof (eval_sstack_val'_preserved_when_depth_extended maxidx key sb0 size e0 stk mem strg ctx ops E_eval_size) as H_eval_sstack_val'_preserved_when_depth_extended_1.
               rewrite H_eval_sstack_val'_preserved_when_depth_extended_1.
               apply H_eval_sstack.
Qed.


(* Extending an smap with a new value, does not affect eval_sstack_val when applied to valid_sstack_value. *)
Lemma eval_sstack_val_preserved_when_smap_extended:
  forall instk_height m m' sv smv v stk mem strg ctx ops idx',
    valid_sstack_value instk_height (get_maxidx_smap m)  sv ->
    (add_to_smap m smv) = (idx', m') ->
    eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops = Some v ->
    eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m') (get_bindings_smap m') ops = Some v.
Proof.
  unfold eval_sstack_val.
  apply eval_sstack_val'_preserved_when_smap_extended.
Qed.

(* Extending an smap with a new value, does not affect map_option when applied to valid_sstack. *)
Lemma eval_sstack_mapo_preserved_when_smap_extended:
  forall sstk instk_height m m' smv stk' stk mem strg ctx ops idx',
    valid_sstack instk_height (get_maxidx_smap m) sstk ->
    (add_to_smap m smv) = (idx', m') ->
    map_option (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops) sstk = Some stk' ->
    map_option (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m') (get_bindings_smap m') ops) sstk = Some stk'.
Proof.
  
  induction sstk as [|sv sstk' IHsstk'].
  
  - intros instk_height m m' smv stk' stk mem strg ctx ops idx' H_valid_sstk H_add_to_smap H_mapo.
    simpl.
    simpl in H_mapo.
    rewrite <- H_mapo.
    reflexivity.
  - intros instk_height m m' smv stk' stk mem strg ctx ops idx' H_valid_sstk H_add_to_smap H_mapo.
    unfold map_option in H_mapo.
    rewrite <- map_option_ho in H_mapo.
    
    destruct (eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops) as [v|] eqn:E_eval_sstack_value_sv; try discriminate.

    simpl in H_valid_sstk.
    destruct H_valid_sstk as [H_valid_sv H_valid_sstk'].
    pose proof (eval_sstack_val_preserved_when_smap_extended instk_height m m' sv smv v stk mem strg ctx ops idx' H_valid_sv H_add_to_smap E_eval_sstack_value_sv) as H_eval_sv_preserved.

    destruct (map_option (fun elem : sstack_val => eval_sstack_val elem stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops) sstk') as [stk''|] eqn:E_mapo_sstk'; try discriminate.

    pose proof (IHsstk' instk_height m m' smv stk'' stk mem strg ctx ops idx' H_valid_sstk' H_add_to_smap E_mapo_sstk') as H_eval_sstk'_preserved.
    simpl.
    
    rewrite H_eval_sv_preserved.
    rewrite H_eval_sstk'_preserved.
    rewrite <- H_mapo.
    reflexivity.
Qed.

(* Extending an smap with a new value, does not affect eval_sstack when applied to valid_sstack. *)
Lemma eval_sstack_preserved_when_smap_extended:
  forall sstk instk_height m m' smv stk' stk mem strg ctx ops idx',
    valid_sstack instk_height (get_maxidx_smap m) sstk ->
    (add_to_smap m smv) = (idx', m') ->
    eval_sstack sstk (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx  ops = Some stk' ->
    eval_sstack sstk (get_maxidx_smap m') (get_bindings_smap m') stk mem strg ctx ops = Some stk'.
Proof.
  unfold eval_sstack.
  apply eval_sstack_mapo_preserved_when_smap_extended.
Qed.

(* Extending an smap with a new value, does not affect the evaluation of a valid memory update. *)
Lemma eval_smemory_update_preserved_when_smap_extended:
  forall u instk_height m m' uv smv stk mem strg ctx ops idx',
    valid_smemory_update instk_height (get_maxidx_smap m) u ->
    (add_to_smap m smv) = (idx', m') ->
    eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops) u = Some uv -> 
    eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m') (get_bindings_smap m') ops) u = Some uv.
Proof.
  intros u instk_height m m' uv smv stk mem strg ctx ops idx' H_valid_u H_add_to_smap H_eval_u.

  destruct u as [soffset svalue|soffset svalue] eqn:E_u.

  - simpl in H_eval_u.
    destruct (eval_sstack_val soffset stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops) as [offset|] eqn:E_eval_soffset; try discriminate.
    destruct (eval_sstack_val svalue stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops) as [value|] eqn:E_eval_svalue; try discriminate.

    simpl in H_valid_u.
    destruct H_valid_u as [H_valid_soffset H_valid_svalue].

    pose proof (eval_sstack_val_preserved_when_smap_extended instk_height m m' soffset smv offset stk mem strg ctx ops idx' H_valid_soffset H_add_to_smap E_eval_soffset) as H_eval_soffset_preserved.

    pose proof (eval_sstack_val_preserved_when_smap_extended instk_height m m' svalue smv value stk mem strg ctx ops idx' H_valid_svalue H_add_to_smap E_eval_svalue) as H_eval_svalue_preserved.

    simpl.
    rewrite H_eval_soffset_preserved.
    rewrite H_eval_svalue_preserved.
    apply H_eval_u.

    (* copy of previous point - revise later *)
  - simpl in H_eval_u.
    destruct (eval_sstack_val soffset stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops) as [offset|] eqn:E_eval_soffset; try discriminate.
    destruct (eval_sstack_val svalue stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops) as [value|] eqn:E_eval_svalue; try discriminate.

    simpl in H_valid_u.
    destruct H_valid_u as [H_valid_soffset H_valid_svalue].

    pose proof (eval_sstack_val_preserved_when_smap_extended instk_height m m' soffset smv offset stk mem strg ctx ops idx' H_valid_soffset H_add_to_smap E_eval_soffset) as H_eval_soffset_preserved.

    pose proof (eval_sstack_val_preserved_when_smap_extended instk_height m m' svalue smv value stk mem strg ctx ops idx' H_valid_svalue H_add_to_smap E_eval_svalue) as H_eval_svalue_preserved.

    simpl.
    rewrite H_eval_soffset_preserved.
    rewrite H_eval_svalue_preserved.
    apply H_eval_u.
Qed.

(* Extending an smap with a new value, does not affect the instantiation of a valid symbolic memory. *)
Lemma eval_smemory_mapo_preserved_when_smap_extended:
  forall smem instk_height m m' smv us stk mem strg ctx ops idx',
    valid_smemory instk_height (get_maxidx_smap m) smem ->
    (add_to_smap m smv) = (idx', m') ->
    map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) smem = Some us ->
    map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m') (get_bindings_smap m') ops)) smem = Some us.
Proof.
  
  induction smem as [|u smem' IHsmem'].

  - intros instk_height m m' smv us stk mem strg ctx ops idx' H_valid_smem H_add_to_smap H_mapo_smem.
    simpl.
    simpl in H_mapo_smem.
    rewrite H_mapo_smem.
    reflexivity.
  - intros instk_height m m' smv us stk mem strg ctx ops idx' H_valid_smem H_add_to_smap H_mapo_smem.

    unfold map_option in H_mapo_smem.
    rewrite <- map_option_ho in H_mapo_smem.
    
    destruct (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops) u) as [elem_val|] eqn:E_eval_u; try discriminate.

    simpl in H_valid_smem.
    destruct H_valid_smem as [H_valid_u H_valid_smem'].

    pose proof (eval_smemory_update_preserved_when_smap_extended u instk_height m m' elem_val smv stk mem strg ctx ops idx' H_valid_u H_add_to_smap E_eval_u) as H_eval_u_preserved.

    destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) smem') as [rs_val|] eqn:E_smem'; try discriminate.

    pose proof (IHsmem' instk_height m m' smv rs_val stk mem strg ctx ops idx'  H_valid_smem' H_add_to_smap E_smem') as H_eval_smem'_preserved.

    unfold map_option.
    rewrite <- map_option_ho.

    rewrite H_eval_u_preserved.
    rewrite H_eval_smem'_preserved.
    rewrite <- H_mapo_smem.
    reflexivity.
Qed.

(* Extending an smap with a new value, does not affect eval_smemory when the memory is valid. *)
Lemma eval_smemory_preserved_when_smap_extended:
  forall smem instk_height m m' smv mem' stk mem strg ctx ops idx',
    valid_smemory instk_height (get_maxidx_smap m) smem ->
    (add_to_smap m smv) = (idx', m') ->
    eval_smemory smem (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx  ops = Some mem' ->
    eval_smemory smem (get_maxidx_smap m') (get_bindings_smap m') stk mem strg ctx ops = Some mem'.
Proof.
  intros smem instk_height m m' smv mem' stk mem strg ctx ops idx' H_valid_smemory H_add_to_smap H_eval_smemory.

  unfold eval_smemory in H_eval_smemory.
  destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) smem) as [updates|] eqn:E_mapo_smem; try discriminate.

  pose proof (eval_smemory_mapo_preserved_when_smap_extended smem instk_height m m' smv updates stk mem strg ctx ops idx' H_valid_smemory H_add_to_smap E_mapo_smem) as H_mapo_smem_preserved.
  
  unfold eval_smemory.
  rewrite H_mapo_smem_preserved.
  apply H_eval_smemory.
Qed.

(* Extending an smap with a new value, does not affect the evaluation of a valid storage update. *)
Lemma eval_sstorage_update_preserved_when_smap_extended:
  forall u instk_height m m' uv smv stk mem strg ctx ops idx',
    valid_sstorage_update instk_height (get_maxidx_smap m) u ->
    (add_to_smap m smv) = (idx', m') ->
    eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops) u = Some uv -> 
    eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m') (get_bindings_smap m') ops) u = Some uv.
Proof.
  intros u instk_height m m' uv smv stk mem strg ctx ops idx' H_valid_u H_add_to_smap H_eval_u.

  destruct u as [skey svalue] eqn:E_u.

  simpl in H_eval_u.
  destruct (eval_sstack_val skey stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops) as [key|] eqn:E_eval_skey; try discriminate.
  destruct (eval_sstack_val svalue stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops) as [value|] eqn:E_eval_svalue; try discriminate.
  
  simpl in H_valid_u.
  destruct H_valid_u as [H_valid_skey H_valid_svalue].
  
  pose proof (eval_sstack_val_preserved_when_smap_extended instk_height m m' skey smv key stk mem strg ctx ops idx' H_valid_skey H_add_to_smap E_eval_skey) as H_eval_skey_preserved.
  
  pose proof (eval_sstack_val_preserved_when_smap_extended instk_height m m' svalue smv value stk mem strg ctx ops idx' H_valid_svalue H_add_to_smap E_eval_svalue) as H_eval_svalue_preserved.
  
  simpl.
  rewrite H_eval_skey_preserved.
  rewrite H_eval_svalue_preserved.
  apply H_eval_u.
  
Qed.

(* Extending an smap with a new value, does not affect the instantiation of a valid symbolic storage. *)
Lemma eval_sstorage_mapo_preserved_when_smap_extended:
  forall sstrg instk_height m m' smv us stk mem strg ctx ops idx',
    valid_sstorage instk_height (get_maxidx_smap m) sstrg ->
    (add_to_smap m smv) = (idx', m') ->
    map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) sstrg = Some us ->
    map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m') (get_bindings_smap m') ops)) sstrg = Some us.
Proof.
  
  induction sstrg as [|u sstrg' IHsstrg'].

  - intros instk_height m m' smv us stk mem strg ctx ops idx' H_valid_sstrg H_add_to_smap H_mapo_sstrg.
    simpl.
    simpl in H_mapo_sstrg.
    rewrite H_mapo_sstrg.
    reflexivity.
  - intros instk_height m m' smv us stk mem strg ctx ops idx' H_valid_sstrg H_add_to_smap H_mapo_sstrg.

    unfold map_option in H_mapo_sstrg.
    rewrite <- map_option_ho in H_mapo_sstrg.
    
    destruct (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops) u) as [elem_val|] eqn:E_eval_u; try discriminate.

    simpl in H_valid_sstrg.
    destruct H_valid_sstrg as [H_valid_u H_valid_sstrg'].

    pose proof (eval_sstorage_update_preserved_when_smap_extended u instk_height m m' elem_val smv stk mem strg ctx ops idx' H_valid_u H_add_to_smap E_eval_u) as H_eval_u_preserved.

    destruct (map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) sstrg') as [rs_val|] eqn:E_sstrg'; try discriminate.

    pose proof (IHsstrg' instk_height m m' smv rs_val stk mem strg ctx ops idx'  H_valid_sstrg' H_add_to_smap E_sstrg') as H_eval_sstrg'_preserved.

    unfold map_option.
    rewrite <- map_option_ho.

    rewrite H_eval_u_preserved.
    rewrite H_eval_sstrg'_preserved.
    rewrite <- H_mapo_sstrg.
    reflexivity.
Qed.

(* Extending an smap with a new value, does not affect eval_sstorage when the storage is valid. *)
Lemma eval_sstorage_preserved_when_smap_extended:
  forall sstrg instk_height m m' smv mem' stk mem strg ctx ops idx',
    valid_sstorage instk_height (get_maxidx_smap m) sstrg ->
    (add_to_smap m smv) = (idx', m') ->
    eval_sstorage sstrg (get_maxidx_smap m) (get_bindings_smap m) stk mem strg ctx  ops = Some mem' ->
    eval_sstorage sstrg (get_maxidx_smap m') (get_bindings_smap m') stk mem strg ctx ops = Some mem'.
Proof.
  intros sstrg instk_height m m' smv mem' stk mem strg ctx ops idx' H_valid_sstorage H_add_to_smap H_eval_sstorage.

  unfold eval_sstorage in H_eval_sstorage.
  destruct (map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx (get_maxidx_smap m) (get_bindings_smap m) ops)) sstrg) as [updates|] eqn:E_mapo_sstrg; try discriminate.

  pose proof (eval_sstorage_mapo_preserved_when_smap_extended sstrg instk_height m m' smv updates stk mem strg ctx ops idx' H_valid_sstorage H_add_to_smap E_mapo_sstrg) as H_mapo_sstrg_preserved.
  
  unfold eval_sstorage.
  rewrite H_mapo_sstrg_preserved.
  apply H_eval_sstorage.
Qed.

(* push_s is a sound symbolic transformer *)
Lemma push_snd:
  forall w, snd_state_transformer (push_c w) (push_s w).
Proof.
  intro w.
  unfold snd_state_transformer.
  intros sst sst' ops H_valid_sst H_push_s.
  split.

  (* Validity *)
  - pose proof (push_valid_sst sst sst' w ops H_valid_sst H_push_s) as H_valid_sst'. apply H_valid_sst'.

  (* Soundness *)
  - intros init_st st H_st_inst_sst.
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



(* pushtag_s is a sound symbolic transformer *)
Lemma pushtag_snd:
  forall v, snd_state_transformer (pushtag_c v) (pushtag_s v).
Proof.

  intro v.
  unfold snd_state_transformer.
  intros sst sst' ops H_valid_sst H_pushtag_s.
  split.

  (* Validity *)
  - pose proof (pushtag_valid_sst sst sst' v ops H_valid_sst H_pushtag_s) as H_valid_sst'. apply H_valid_sst'.

  (* Soundness *)
  - intros init_st st H_st_inst_sst.
    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as H_inst_stk_len.
    destruct H_inst_stk_len as [H_inst_stk_len_l H_inst_stk_len_r].
    unfold pushtag_s in H_pushtag_s.
    destruct (add_to_smap (get_smap_sst sst) (SymPUSHTAG v)) as [key' sm'] eqn:E_add_to_smap.
    unfold push in H_pushtag_s.
    destruct (length (get_stack_sst sst) <? StackSize) eqn:E_stk_len; try discriminate.

    unfold pushtag_c.
    unfold push.
    injection H_pushtag_s as H_sst'.

    rewrite <- H_inst_stk_len_l.
    rewrite E_stk_len.

    exists (set_stack_st st (get_tags_ctx (get_context_st st) v :: get_stack_st st)).
    split; try reflexivity.

    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as E_stack_len_st_eq_sst.
    destruct E_stack_len_st_eq_sst as [E_stack_len_st_eq_sst_l E_stack_len_st_eq_sst_r].

    unfold st_is_instance_of_sst.
    exists (set_stack_st st (get_tags_ctx (get_context_st st) v :: get_stack_st st)).
    split; try apply eq_execution_states_refl.

    rewrite <- H_sst'.
    unfold eval_sstate.

    rewrite set_and_then_get_smap_sst.
    rewrite instk_height_preserved_when_updating_smap_sst.
    rewrite instk_height_preserved_when_updating_stack_sst.
    rewrite sstack_preserved_when_updating_smap_sst.
    rewrite set_and_then_get_stack_sst.
    rewrite smemory_preserved_when_updating_smap_sst.
    rewrite smemory_preserved_when_updating_stack_sst.
    rewrite sstorage_preserved_when_updating_smap_sst.
    rewrite sstorage_preserved_when_updating_stack_sst.
    
    symmetry in H_inst_stk_len_r.
    apply Nat.eqb_eq in H_inst_stk_len_r as H_inst_stk_len_r_eqb.
    rewrite H_inst_stk_len_r_eqb.

    assert (H_st_inst_sst' := H_st_inst_sst).
    unfold st_is_instance_of_sst in H_st_inst_sst'.
    destruct H_st_inst_sst' as [st' H_st_inst_sst'].
    destruct H_st_inst_sst' as [H_st_inst_sst'_l H_st_inst_sst'_r].    
    pose proof (eq_execution_states_ext st st' H_st_inst_sst'_r) as H_st_eq_st'.
    
    unfold eval_sstate in H_st_inst_sst'_l.
    rewrite H_inst_stk_len_r_eqb in H_st_inst_sst'_l.
    
       
    destruct (eval_sstack (get_stack_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [stk''|] eqn:E_eval_sstack; try discriminate.

    destruct (eval_smemory (get_memory_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [mem|] eqn:E_eval_smemory; try discriminate.
    
    destruct (eval_sstorage (get_storage_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [strg|] eqn:E_eval_sstorage; try discriminate.

    injection H_st_inst_sst'_l as H_st_inst_sst'_l.

    unfold valid_sstate in H_valid_sst.
    destruct H_valid_sst as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].
    (* equivalence of eval_smemory *)
      
    pose proof (eval_smemory_preserved_when_smap_extended (get_memory_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) sm' (SymPUSHTAG v) mem (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key' H_valid_sst_smemory E_add_to_smap E_eval_smemory) as H_eval_smem_preserved.
    rewrite H_eval_smem_preserved.

    (* equivalence of eval_sstorage *)
    pose proof (eval_sstorage_preserved_when_smap_extended (get_storage_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) sm' (SymPUSHTAG v) strg (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key' H_valid_sst_sstorage E_add_to_smap E_eval_sstorage) as H_eval_sstrg_preserved.
    rewrite H_eval_sstrg_preserved.

    (* the case of eval_sstack *)
    
    apply Nat.eqb_eq in E_stack_len_st_eq_sst_r as E_stack_len_st_eq_sst_r_eqb.
    apply Nat.eqb_eq in E_stack_len_st_eq_sst_l as E_stack_len_st_eq_sst_l_eqb.
    
    destruct (get_smap_sst sst) as [maxid sb] eqn:E_get_smap_sst.
    destruct sm' as [maxid' sb'].
    assert (E_add_to_smap' := E_add_to_smap).
    simpl in E_add_to_smap'.
    injection E_add_to_smap' as H_maxid H_maxid' H_sb'.
    rewrite <- H_sb'.
    simpl.
    apply Nat.eqb_eq in H_maxid as H_maxid_eqb.
    unfold eval_sstack_val.
    unfold eval_sstack_val'. fold eval_sstack_val'.
    unfold follow_in_smap.
    rewrite H_maxid_eqb.
    simpl.
    
    pose proof (eval_sstack_preserved_when_smap_extended (get_stack_sst sst) (get_instk_height_sst sst) (SymMap maxid sb) (SymMap maxid' sb') (SymPUSHTAG v) stk'' (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key' H_valid_sst_sstack E_add_to_smap E_eval_sstack) as H_eval_sstack_preserved.
    rewrite <- H_sb' in H_eval_sstack_preserved.
    simpl in H_eval_sstack_preserved.
    rewrite H_eval_sstack_preserved.
    rewrite H_st_eq_st'.
    rewrite <-  H_st_inst_sst'_l.
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

  destruct (get_instk_height_sst sst =? length (get_stack_st init_st)) eqn:E_len; try discriminate.
  
  destruct (get_smap_sst sst) as [maxid map0] eqn:E_map.
  rewrite E_stk_sst in H.
  simpl in H.
  
  destruct (eval_sstack_val s (get_stack_st init_st) (get_memory_st init_st)
              (get_storage_st init_st) (get_context_st init_st) maxid map0 ops) in H; try discriminate.
  destruct (eval_sstack s0 maxid map0 (get_stack_st init_st) (get_memory_st init_st)
            (get_storage_st init_st) (get_context_st init_st)  ops) in H; try discriminate.
  destruct (eval_smemory (get_memory_sst sst) maxid map0 (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) in H; try discriminate.
  destruct (eval_sstorage (get_storage_sst sst) maxid map0 (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) in H; try discriminate.
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
  rewrite H in H1.

  destruct (get_instk_height_sst sst =? length (get_stack_st init_st)) eqn:E_len; try discriminate.

  destruct ( get_smap_sst sst ) as [maxidx bs] eqn:E_smap.
  unfold get_maxidx_smap in H1.
  unfold get_bindings_smap in H1.
  
  destruct (map_option
           (fun sv : sstack_val =>
            eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st)
              (get_storage_st init_st) (get_context_st init_st) maxidx bs ops) 
           (v1 :: l)) as [stk|] eqn:E_mapo; try discriminate.

  destruct (eval_smemory (get_memory_sst sst) maxidx bs (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [mem|] eqn:E_mem; try discriminate.

  destruct (eval_sstorage (get_storage_sst sst) maxidx bs (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [srtg|] eqn:E_strg; try discriminate.

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
  rewrite set_and_then_get_stack_sst.
  simpl.
  rewrite smemory_preserved_when_updating_stack_sst.
  rewrite E_mem.
  rewrite sstorage_preserved_when_updating_stack_sst.
  rewrite E_strg.
  injection H1 as H1.
  rewrite <- H1.
  unfold make_st.
  simpl.
  rewrite <- H1 in H0.
  simpl in H0.
  injection H0. intros.
  rewrite H3.
  rewrite H4.
  reflexivity.
Qed.


(* pop_s is a sound symbolic transformer  *)
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


Lemma eval_sstack_hd:
  forall (sstk: sstack) (stk stk': stack) (mem: memory) (strg: storage) (ctx: context) (maxidx: nat) (sb: sbindings) (ops: stack_op_instr_map) (sv: sstack_val) (v : EVMWord),
    eval_sstack (sv :: sstk) maxidx sb stk mem strg ctx ops = Some (v :: stk') ->
    eval_sstack sstk maxidx sb stk mem strg ctx ops = Some stk'.
Proof.
  intros.
  unfold eval_sstack in H.
  apply map_option_hd in H.
  destruct H.
  unfold eval_sstack.
  apply H0.
Qed.

Lemma dup_elem_snd:
  forall  (k: nat) (sstk: sstack) (stk stk': stack) (mem: memory) (strg: storage) (ctx: context) (maxidx: nat) (sb: sbindings) (ops: stack_op_instr_map) (sv: sstack_val) (v : EVMWord),
    eval_sstack sstk maxidx sb stk mem strg ctx ops = Some stk' ->
    nth_error sstk k = Some sv ->
    nth_error stk' k = Some v ->
        eval_sstack_val sv stk mem strg ctx maxidx sb ops = Some v.
Proof.
  induction k as [|k' IHk']. 
  - intros.
    destruct sstk; destruct stk'; try discriminate.
    simpl in H0. injection H0 as H0.       
    simpl in H1. injection H1 as H1.
    unfold eval_sstack in H.
    unfold map_option in H.
    rewrite <- map_option_ho in H.
    destruct (eval_sstack_val s stk mem strg ctx maxidx sb ops) eqn:E_eval_sstack_val; try discriminate.
    destruct (map_option (fun elem : sstack_val => eval_sstack_val elem stk mem strg ctx maxidx sb ops) sstk) eqn:E_mapo; try discriminate.
    injection H. intros.
    rewrite H0 in E_eval_sstack_val.
    rewrite H3 in E_eval_sstack_val. rewrite H1 in E_eval_sstack_val.
    apply E_eval_sstack_val.
  - intros.
    destruct sstk; destruct stk'; try discriminate.
    simpl in H0.
    simpl in H1.
    apply eval_sstack_hd in H.
    pose proof (IHk' sstk stk stk' mem strg ctx maxidx sb ops sv v H H0 H1).
    apply H2.
Qed.

(* dup_s is a sound symbolic transformer  *)
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
    split; try apply eq_execution_states_refl.
    
    unfold st_is_instance_of_sst in H_st_inst_sst.
    destruct H_st_inst_sst as [st' H_st_inst_sst].
    destruct H_st_inst_sst as [H_st_inst_sst_l H_st_inst_sst_r].
    unfold eval_sstate in H_st_inst_sst_l.
    symmetry in H_init_st_len_sst.
    apply Nat.eqb_eq in H_init_st_len_sst as H_init_st_len_sst_eqb.
    rewrite H_init_st_len_sst_eqb in H_st_inst_sst_l.
    destruct (get_smap_sst sst) as [maxidx bs] eqn:E_smap.

    unfold get_maxidx_smap in H_st_inst_sst_l.
    unfold get_bindings_smap in H_st_inst_sst_l.
    
    destruct (eval_sstack (get_stack_sst sst) maxidx bs (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [stk|] eqn:E_eval_sstack; try discriminate.

    destruct (eval_smemory (get_memory_sst sst) maxidx bs (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [mem|] eqn:E_eval_smemory; try discriminate.

    destruct (eval_sstorage (get_storage_sst sst) maxidx bs (get_stack_st init_st)  (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [strg|] eqn:E_eval_sstorage; try discriminate.
             
      unfold make_st in  H_st_inst_sst_l.
      injection H_st_inst_sst_l as H_st_inst_sst_l.
      apply eq_execution_states_ext in H_st_inst_sst_r as H_eq_st_st'.
      rewrite  H_eq_st_st' in   H_st_nth_err.
      rewrite <-   H_st_inst_sst_l in H_st_nth_err.
      simpl in H_st_nth_err.
      
      pose proof (dup_elem_snd (pred k) (get_stack_sst sst) (get_stack_st init_st) stk (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) maxidx bs ops sv v' E_eval_sstack  E_sst_nth_err  H_st_nth_err) as H_eval_sstack_val.
      
      unfold eval_sstate.
      unfold eval_sstack.
      rewrite instk_height_preserved_when_updating_stack_sst.
      rewrite H_init_st_len_sst_eqb.
      rewrite smap_preserved_when_updating_stack_sst.
      rewrite E_smap.
      rewrite set_and_then_get_stack_sst.
      simpl.
      unfold map_option.
      rewrite <- map_option_ho.
      rewrite H_eval_sstack_val.
      unfold eval_sstack in  E_eval_sstack.
      rewrite  E_eval_sstack.
      rewrite smemory_preserved_when_updating_stack_sst.
      rewrite sstorage_preserved_when_updating_stack_sst.
      rewrite E_eval_smemory.
      rewrite E_eval_sstorage.
      unfold make_st.
      rewrite H_eq_st_st'.
      rewrite <- H_st_inst_sst_l.
      simpl.
      reflexivity.
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


Lemma eval_sstack_swap:
  forall sstk sstk' stk mem strg ctx maxidx sb ops stk' k,
  eval_sstack sstk maxidx sb stk mem strg ctx ops = Some stk' ->
  swap k sstk = Some sstk' ->
  eval_sstack sstk' maxidx sb stk mem strg ctx ops = swap k stk'.
Proof.
  intros sstk sstk' stk mem strg ctx maxidx sb ops stk' k H_eval_sstack H_swap_s.
  unfold swap in H_swap_s.
  destruct ((k =? 0) || (16 <? k)) eqn:E_k; try discriminate.
  destruct (nth_error sstk k) as [sv|] eqn:E_nth_err; try  discriminate.
  destruct sstk as [|e sstk'']; try discriminate.
  pose proof (eval_sstack_len (e :: sstk'') stk stk' mem strg ctx maxidx sb ops H_eval_sstack) as H_sstk_stk'_len.
  pose proof (nth_err_two_lists sstack_val EVMWord (e::sstk'') stk' k sv H_sstk_stk'_len E_nth_err) as H_nth_err_stk'.
  destruct H_nth_err_stk' as [v' H_nth_err_stk'].
  unfold swap.
  rewrite E_k.
  rewrite  H_nth_err_stk'.
  destruct stk' as [|e' stk''] eqn:E_stk'; try discriminate.
  injection H_swap_s as H_swap_s.
  pose proof (skipn_nth sstack_val (e :: sstk'') k sv E_nth_err) as H_skipn_nth_1.
  pose proof (skipn_nth EVMWord (e' :: stk'') k v' H_nth_err_stk') as H_skipn_nth_2.
  rewrite H_skipn_nth_1 in H_eval_sstack.
  rewrite H_skipn_nth_2 in H_eval_sstack.
  destruct k as [|k'] eqn:E_k'; try discriminate.

  assert( H_Sk1: S k' + 1 = S (k' + 1)). reflexivity.
  assert(H_app_cons: forall A (e:A) (l: list A), e::l=[e]++l). reflexivity.

  repeat rewrite firstn_cons in H_eval_sstack.
  repeat rewrite H_Sk1 in H_eval_sstack. 
  repeat rewrite skipn_cons in H_eval_sstack.
  rewrite H_app_cons  with (e:=e)(l:=firstn k' sstk'') in H_eval_sstack.
  rewrite H_app_cons  with (e:=sv)(l:=skipn (k' + 1) sstk'') in H_eval_sstack.
  rewrite H_app_cons  with (e:=e')(l:=firstn k' stk'') in H_eval_sstack.
  rewrite H_app_cons  with (e:=v')(l:=skipn (k' + 1) stk'') in H_eval_sstack.
  unfold eval_sstack in  H_eval_sstack.
  
  assert (H_len1: length [e] = length [e']). reflexivity.
  assert (H_len2: length (firstn k' sstk'')= length (firstn k' stk'')). repeat rewrite firstn_length. auto.
  assert (H_len3: length [sv] = length [v']). reflexivity.
  assert (H_len4: length (skipn (k' + 1) sstk'') = length (skipn (k' + 1) stk'')). repeat rewrite skipn_length. auto.

  repeat rewrite <- app_assoc in H_eval_sstack'.
  pose proof (map_option_swap sstack_val EVMWord (fun sv : sstack_val => eval_sstack_val sv stk mem strg ctx maxidx sb ops) [e] (firstn k' sstk'') [sv] (skipn (k' + 1) sstk'') [e'] (firstn k' stk'') [v'] (skipn (k' + 1) stk'') H_len1 H_len2 H_len3 H_len4 H_eval_sstack) as H_mapo_app2.

  rewrite <- H_swap_s.

  assert ( H_Skm1: S k' - 1 = k' ). intuition.
  rewrite H_Skm1.
  rewrite H_Sk1.
  repeat rewrite skipn_cons.
  unfold eval_sstack.
  apply H_mapo_app2.
Qed.

(* swap_s is a sound symbolic transformer  *)
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

    destruct (get_instk_height_sst sst =? length (get_stack_st init_st)) eqn:E_len; try discriminate.
    
    destruct (eval_sstack (get_stack_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [stk|] eqn:E_eval_sstack; try discriminate.
    
    destruct (eval_smemory (get_memory_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops)  as [mem|] eqn:E_eval_smem; try discriminate.
    
    destruct (eval_sstorage (get_storage_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [strg|] eqn:E_eval_sstrg; try discriminate.
    
    injection H_st_inst_sst_1 as H_st_inst_sst_1.
    injection H_swap_s as H_swap_s.
    unfold eval_sstate.
    rewrite <- H_swap_s.
    rewrite smemory_preserved_when_updating_stack_sst.
    rewrite sstorage_preserved_when_updating_stack_sst.
    rewrite smap_preserved_when_updating_stack_sst.
    rewrite E_eval_smem.
    rewrite E_eval_sstrg.
    unfold eval_sstack.

    rewrite instk_height_preserved_when_updating_stack_sst.
    rewrite E_len.

    (*
    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst_0) as H_st_is_instance_of_sst_stk_len.
    destruct H_st_is_instance_of_sst_stk_len as [H_st_is_instance_of_sst_stk_len_0 H_st_is_instance_of_sst_stk_len_1].
    symmetry in H_st_is_instance_of_sst_stk_len_1.
    rewrite <- Nat.eqb_eq in H_st_is_instance_of_sst_stk_len_1.
    rewrite instk_height_preserved_when_updating_stack_sst.
    rewrite H_st_is_instance_of_sst_stk_len_1.
     *)
    
    destruct (get_smap_sst (set_stack_sst sst l)) as [maxidx sb] eqn:E_smap.
    unfold eval_sstack in E_eval_sstack.
    rewrite smap_preserved_when_updating_stack_sst in E_smap.
    rewrite E_smap in E_eval_sstack.
    pose proof (eval_sstack_swap (get_stack_sst sst) l (get_stack_st init_st)
                  (get_memory_st init_st) (get_storage_st init_st) 
                  (get_context_st init_st) maxidx sb ops stk k E_eval_sstack E_swap) as H_eval_sstack'_swap.
    rewrite set_and_then_get_stack_sst.
    unfold eval_sstack in H_eval_sstack'_swap.
    rewrite E_smap.
    simpl.
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

(* sload_s is a sound symbolic transformer when sload_sovler is sound *)
Lemma sload_snd:
  forall sload_solver,
    sload_solver_snd sload_solver ->
    snd_state_transformer sload_c (sload_s sload_solver).
Proof.
  intros sload_solver H_valid_sload_solver.
  unfold snd_state_transformer.
  intros sst sst' ops H_valid_sst H_sload_s.
  split.
  - pose proof (sload_valid_sst sst sst' ops sload_solver H_valid_sst H_valid_sload_solver H_sload_s) as H_valid_sst'. apply H_valid_sst'.
  - intros init_st st H_st_inst_sst.
    unfold sload_s in H_sload_s.
    destruct (get_stack_sst sst) as [|skey sstk] eqn:E_sstk_sst; try discriminate.

    remember (sload_solver skey (get_storage_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) ops) as smv eqn:E_smv.
    
    destruct (add_to_smap (get_smap_sst sst) smv) as [key sm'] eqn:E_add_to_smap.

    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as E_stack_len_st_eq_sst.
    destruct E_stack_len_st_eq_sst as [E_stack_len_st_eq_sst_l E_stack_len_st_eq_sst_r].
    unfold sload_c.
    
    destruct (get_stack_st st) as [|ckey stk] eqn:E_stk_st; try (rewrite E_sstk_sst in E_stack_len_st_eq_sst_l; discriminate). (* case of [] *)

    exists (set_stack_st st (sload (get_storage_st st) ckey :: stk)).
    split; try reflexivity. (* left side of conjunction *)

    unfold st_is_instance_of_sst.
    exists (set_stack_st st (sload (get_storage_st st) ckey :: stk)).
    split; try apply eq_execution_states_refl.

    unfold eval_sstate.

    assert (H_st_inst_sst' := H_st_inst_sst).
    unfold st_is_instance_of_sst in H_st_inst_sst'.
    destruct H_st_inst_sst' as [st' H_st_inst_sst'].
    destruct H_st_inst_sst' as [H_st_inst_sst'_l H_st_inst_sst'_r].

    pose proof (eq_execution_states_ext st st' H_st_inst_sst'_r) as H_st_eq_st'.
    
    unfold eval_sstate in H_st_inst_sst'_l.

    destruct (get_instk_height_sst sst =? length (get_stack_st init_st)) eqn:E_len; try discriminate.

    destruct (eval_sstack (get_stack_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [stk''|] eqn:E_eval_sstack; try discriminate.
    
    destruct (eval_smemory (get_memory_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [mem|] eqn:E_eval_memory; try discriminate.
    
    destruct (eval_sstorage (get_storage_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [strg|] eqn:E_eval_sstorage; try discriminate.

    injection H_st_inst_sst'_l as H_st_inst_sst'_l.

    injection H_sload_s as H_sst'.
    rewrite <- H_sst'.

    rewrite instk_height_preserved_when_updating_smap_sst.
    rewrite instk_height_preserved_when_updating_stack_sst.
    rewrite E_len.

    rewrite sstack_preserved_when_updating_smap_sst.
    rewrite set_and_then_get_stack_sst.
    rewrite set_and_then_get_smap_sst.
    rewrite smemory_preserved_when_updating_smap_sst.
    rewrite smemory_preserved_when_updating_stack_sst.
    rewrite sstorage_preserved_when_updating_smap_sst.
    rewrite sstorage_preserved_when_updating_stack_sst.
    
    unfold valid_sstate in H_valid_sst.
    destruct H_valid_sst as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].
    
    (* equivalence of eval_smemory *)
    pose proof (eval_smemory_preserved_when_smap_extended (get_memory_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) sm' smv mem (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key H_valid_sst_smemory E_add_to_smap E_eval_memory) as E_eval_smemory_preserved.

    rewrite E_eval_smemory_preserved.
    
    (* equivalence of eval_sstorage *)
    pose proof (eval_sstorage_preserved_when_smap_extended (get_storage_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) sm' smv strg (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key H_valid_sst_sstorage E_add_to_smap E_eval_sstorage) as E_eval_sstorage_preserved.

    rewrite E_eval_sstorage_preserved.

    (* the case of eval_sstack *)

    rewrite E_sstk_sst in H_valid_sst_sstack.
    rewrite E_sstk_sst in E_eval_sstack.

    unfold eval_sstack in E_eval_sstack.
    unfold map_option in E_eval_sstack.
    rewrite <- map_option_ho in E_eval_sstack.

    simpl in H_valid_sst_sstack.
    destruct H_valid_sst_sstack as [H_valid_skey H_valid_sstk].

    destruct (eval_sstack_val skey (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (get_maxidx_smap (get_smap_sst sst))(get_bindings_smap (get_smap_sst sst)) ops) as [elem_val|] eqn:E_eval_skey; try discriminate.

    destruct (map_option (fun elem : sstack_val => eval_sstack_val elem (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) ops) sstk) as [rs_val|] eqn:E_eval_sstk; try discriminate.

    pose proof (eval_sstack_val_preserved_when_smap_extended (get_instk_height_sst sst) (get_smap_sst sst) sm' skey smv elem_val (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key H_valid_skey E_add_to_smap E_eval_skey) as E_eval_skey_preserved.
    
    pose proof (eval_sstack_mapo_preserved_when_smap_extended sstk (get_instk_height_sst sst) (get_smap_sst sst) sm' smv rs_val (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key H_valid_sstk E_add_to_smap E_eval_sstk) as E_eval_sstk_preserved.

    unfold eval_sstack.
    unfold map_option.
    rewrite <- map_option_ho.
    rewrite E_eval_sstk_preserved.

    unfold sload_solver_snd in H_valid_sload_solver.
    destruct H_valid_sload_solver as [H_valid_sload_solver_valid H_valid_sload_solver_correct].
    unfold sload_solver_valid_res in H_valid_sload_solver_valid.
    unfold sload_solver_correct_res in H_valid_sload_solver_correct.

    symmetry in E_smv.
    pose proof (H_valid_sload_solver_valid (get_smap_sst sst) (get_storage_sst sst) skey (get_instk_height_sst sst) smv ops H_valid_sst_sstorage H_valid_skey E_smv) as H_valid_smv.

    pose proof (H_valid_sload_solver_correct (get_smap_sst sst) (get_storage_sst sst) skey (get_instk_height_sst sst) smv ops key sm' H_valid_sst_smap H_valid_sst_sstorage H_valid_skey E_smv E_add_to_smap) as H_correct_sload.

    destruct (get_smap_sst sst) as [maxidx sb] eqn:E_smap_sst.
    simpl in H_correct_sload.
    destruct H_correct_sload as [maxidx' [m2' H_correct_sload]].
    destruct H_correct_sload as [H_correct_sload_l H_correct_sload_r].
    injection H_correct_sload_l as H_maxidx' H_m2'.
    rewrite <- H_maxidx' in H_correct_sload_r.
    rewrite <- H_m2' in H_correct_sload_r.
    pose proof (H_correct_sload_r (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) E_stack_len_st_eq_sst_r) as H_correct_sload_r.
    destruct H_correct_sload_r as [v H_correct_sload_r].
    destruct H_correct_sload_r as [H_correct_sload_r_0 H_correct_sload_r_1].
    unfold get_maxidx_smap in H_correct_sload_r_1.
    unfold get_bindings_smap in H_correct_sload_r_1.

    rewrite H_correct_sload_r_0.

    injection E_eval_sstack  as H_stk''.
    
    unfold eq_execution_states in H_st_inst_sst'_r.
    destruct H_st_inst_sst'_r as [H_st_inst_sst'_r_stk_eq [H_st_inst_sst'_r_mem_eq [H_st_inst_sst'_r_strg_eq _]]].
    rewrite <- H_st_inst_sst'_l in H_st_inst_sst'_r_stk_eq.
    rewrite E_stk_st in H_st_inst_sst'_r_stk_eq.
    simpl in H_st_inst_sst'_r_stk_eq.
    unfold eq_stack in H_st_inst_sst'_r_stk_eq.
    rewrite <- H_stk'' in H_st_inst_sst'_r_stk_eq.
    injection H_st_inst_sst'_r_stk_eq as H_ckey_eq_elem_val H_stk_eq_rs_val.

    rewrite H_st_eq_st'.
    rewrite <- H_st_inst_sst'_l.
    rewrite H_stk_eq_rs_val.
    unfold make_st.
    simpl.

    simpl in H_correct_sload_r_1.

    assert (H_maxidx_eq_maxidx: maxidx = maxidx). reflexivity.
    apply Nat.eqb_eq in H_maxidx_eq_maxidx.
    
    unfold eval_sstack_val in H_correct_sload_r_1.
    remember (S maxidx) as d'. (* to avoid unfolding too much *)
    unfold eval_sstack_val' in H_correct_sload_r_1. fold eval_sstack_val' in H_correct_sload_r_1.
    unfold follow_in_smap in H_correct_sload_r_1.
    rewrite H_maxidx_eq_maxidx in H_correct_sload_r_1.
    simpl in H_correct_sload_r_1.

    unfold eval_sstorage in E_eval_sstorage.
    simpl in E_eval_sstorage.
    destruct (map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) maxidx sb ops)) (get_storage_sst sst)) as [updates|] eqn:E_eval_sstorage_mapo; try discriminate.
    unfold eval_sstack_val in E_eval_sstorage_mapo.
    rewrite Heqd' in H_correct_sload_r_1.
    rewrite E_eval_sstorage_mapo in H_correct_sload_r_1.
    
    simpl in E_eval_skey.
    unfold eval_sstack_val in E_eval_skey.

    rewrite E_eval_skey in H_correct_sload_r_1.
    injection H_correct_sload_r_1 as H_v.
    injection E_eval_sstorage as E_sstrg.
    rewrite H_ckey_eq_elem_val.
    rewrite E_sstrg in H_v.
    rewrite H_v.
    reflexivity.
Qed.

(* sstore_s is a sound symbolic transformer when sstorage_updater is sound *)
Lemma sstore_snd:
  forall sstorage_updater,
    sstorage_updater_snd sstorage_updater ->
    snd_state_transformer sstore_c (sstore_s sstorage_updater).
Proof.
  intros sstorage_updater H_sstorage_updater_snd.
  unfold snd_state_transformer.
  intros sst sst' ops H_valid_sst H_sstore_s.
  split.
  - pose proof (sstore_valid_sst sst sst' ops sstorage_updater H_sstorage_updater_snd H_valid_sst H_sstore_s) as H_valid_sst'. apply H_valid_sst'.
  - intros init_st st H_st_inst_sst.
    unfold sstore_s in H_sstore_s.
    destruct (get_stack_sst sst) as [|skey sstk] eqn:E_sstk_sst; try discriminate.
    destruct sstk as [|svalue sstk'] eqn:E_sstk'_sst; try discriminate.
    injection H_sstore_s as H_sst'.

    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as E_stack_len_st_eq_sst.
    destruct E_stack_len_st_eq_sst as [E_stack_len_st_eq_sst_l E_stack_len_st_eq_sst_r].

    unfold sstore_c.
 
    destruct (get_stack_st st) as [|ckey stk] eqn:E_stk_st; try (rewrite E_sstk_sst in E_stack_len_st_eq_sst_l; discriminate). (* case of [] *)

    destruct stk as [|cvalue stk'] eqn:E_stk'_st; try (rewrite E_sstk_sst in E_stack_len_st_eq_sst_l; discriminate). (* case of [] *)

    exists (set_stack_st (set_store_st st (sstore (get_storage_st st) ckey cvalue)) stk').
    
    split; try reflexivity.

    unfold st_is_instance_of_sst.
    exists (set_stack_st (set_store_st st (sstore (get_storage_st st) ckey cvalue)) stk').
    split; try apply eq_execution_states_refl.

    assert (H_st_inst_sst' := H_st_inst_sst).
    unfold st_is_instance_of_sst in H_st_inst_sst'.
    destruct H_st_inst_sst' as [st' H_st_inst_sst'].
    destruct H_st_inst_sst' as [H_st_inst_sst'_l H_st_inst_sst'_r].

    pose proof (eq_execution_states_ext st st' H_st_inst_sst'_r) as H_st_eq_st'.

    unfold eval_sstate in H_st_inst_sst'_l.

    destruct (get_instk_height_sst sst =? length (get_stack_st init_st)) eqn:E_len; try discriminate.
    
    destruct (eval_sstack (get_stack_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [stk''|] eqn:E_eval_sstack; try discriminate.
    
    destruct (eval_smemory (get_memory_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [mem|] eqn:E_eval_smemory; try discriminate.
    
    destruct (eval_sstorage (get_storage_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [strg|] eqn:E_eval_sstorage; try discriminate.

    injection H_st_inst_sst'_l as H_st_inst_sst'_l.

    rewrite E_sstk_sst in E_eval_sstack.
    simpl in E_eval_sstack.

    destruct (eval_sstack_val skey (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (get_maxidx_smap (get_smap_sst sst))(get_bindings_smap (get_smap_sst sst)) ops) as [ckey'|] eqn:E_eval_skey; try discriminate.
    
    destruct (eval_sstack_val svalue (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) ops) as [cvalue'|] eqn:E_eval_svalue; try discriminate.

    destruct (eval_sstack sstk' (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [rs_val|] eqn:E_eval_sstk'; try discriminate.

    unfold eval_sstate.

    rewrite <- H_sst'.

    rewrite instk_height_preserved_when_updating_stack_sst.
    rewrite instk_height_preserved_when_updating_storage_sst.
    rewrite E_len.
    rewrite set_and_then_get_stack_sst.
    rewrite smap_preserved_when_updating_stack_sst.
    rewrite smap_preserved_when_updating_storage_sst.

    rewrite smemory_preserved_when_updating_stack_sst.
    rewrite smemory_preserved_when_updating_storage_sst.

    rewrite sstorage_preserved_when_updating_stack_sst.
    rewrite set_and_then_get_storage_sst.
    
    (* case of eval_sstack *)
    rewrite E_eval_sstk'.

    (* case of memory *)
    rewrite E_eval_smemory.


    (* case of sstorage *)

    unfold valid_sstate in H_valid_sst.
    destruct H_valid_sst as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].

    rewrite E_sstk_sst in H_valid_sst_sstack.
    simpl in H_valid_sst_sstack.
    destruct H_valid_sst_sstack as [H_valid_skey [H_valid_svalue H_valid_sstk']].

    pose proof (valid_sstorage_update_kv (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) skey svalue H_valid_skey H_valid_svalue) as H_valid_u.

    remember  (sstorage_updater (U_SSTORE sstack_val skey svalue) (get_storage_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) ops) as sstrg' eqn:E_updater.
    symmetry in E_updater.

    remember (U_SSTORE sstack_val skey svalue) as u eqn:E_u.

    unfold sstorage_updater_snd in H_sstorage_updater_snd.
    destruct H_sstorage_updater_snd as [H_sstorage_updater_valid H_sstorage_updater_correct].

    unfold sstorage_updater_correct_res in H_sstorage_updater_correct.
    pose proof (H_sstorage_updater_correct (get_smap_sst sst) (get_storage_sst sst) sstrg' u (get_instk_height_sst sst) ops H_valid_sst_smap H_valid_sst_sstorage H_valid_u E_updater (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) E_stack_len_st_eq_sst_r) as H_correct_sstrg'.

    destruct  H_correct_sstrg' as [strg1 [strg2 [H_eval_u_strg_sst [H_eval_sstrg' H_eq_str1_strg2]]]].

    rewrite H_eval_sstrg'.

    unfold eq_storage in H_eq_str1_strg2.
    pose proof (functional_extensionality strg1 strg2 H_eq_str1_strg2) as H_eq_str1_strg2_eq.
    rewrite <- H_eq_str1_strg2_eq.

    rewrite H_st_eq_st'.
    rewrite <- H_st_inst_sst'_l.
    simpl.

    injection E_eval_sstack as E_stk''.

    unfold eq_execution_states in H_st_inst_sst'_r.
    destruct H_st_inst_sst'_r as [H_st_inst_sst'_stack _].
    unfold eq_stack in H_st_inst_sst'_stack.
    rewrite E_stk_st in H_st_inst_sst'_stack.
    rewrite <- H_st_inst_sst'_l in H_st_inst_sst'_stack.
    rewrite <- E_stk'' in H_st_inst_sst'_stack.
    simpl in H_st_inst_sst'_stack.
    injection H_st_inst_sst'_stack as H_ckey_eq_ckey' H_cvalue_eq_cvalue' H_stk'_eq_rsval.
    rewrite H_stk'_eq_rsval.

    unfold eval_sstorage in H_eval_u_strg_sst.
    destruct (map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) ops)) (u :: get_storage_sst sst)) as [updates|] eqn:E_mapo; try discriminate.
    injection H_eval_u_strg_sst as H_strg1.

    unfold map_option in E_mapo.
    rewrite <- map_option_ho in E_mapo.
    unfold eval_common.EvalCommon.instantiate_storage_update at 1 in E_mapo.
    rewrite E_u in E_mapo.
    rewrite E_eval_skey in E_mapo.
    rewrite E_eval_svalue in E_mapo.

    unfold eval_sstorage in E_eval_sstorage.
    destruct (map_option (eval_common.EvalCommon.instantiate_storage_update (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) ops)) (get_storage_sst sst)) as [us|]; try discriminate.

    injection E_mapo as E_updates.
    rewrite <- E_updates in H_strg1.
    simpl in H_strg1.

    injection E_eval_sstorage as H_strg.
    rewrite H_strg in H_strg1.
    rewrite <- H_ckey_eq_ckey' in H_strg1.
    rewrite <- H_cvalue_eq_cvalue' in H_strg1.
    rewrite H_strg1.
    reflexivity.
Qed.


(* this is almost identical to sload_snd *)
(* mload_s is a sound symbolic transformer when mload_solver is sound *)
Lemma mload_snd:
  forall mload_solver,
    mload_solver_snd mload_solver ->
    snd_state_transformer mload_c (mload_s mload_solver).
Proof.
  intros mload_solver H_valid_mload_solver.
  unfold snd_state_transformer.
  intros sst sst' ops H_valid_sst H_mload_s.
  split.
  - pose proof (mload_valid_sst sst sst' ops mload_solver H_valid_sst H_valid_mload_solver H_mload_s) as H_valid_sst'. apply H_valid_sst'.
  - intros init_st st H_st_inst_sst.
    unfold mload_s in H_mload_s.
    destruct (get_stack_sst sst) as [|soffset sstk] eqn:E_sstk_sst; try discriminate.

    remember (mload_solver soffset (get_memory_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) ops) as smv eqn:E_smv.
    
    destruct (add_to_smap (get_smap_sst sst) smv) as [key sm'] eqn:E_add_to_smap.

    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as E_stack_len_st_eq_sst.
    destruct E_stack_len_st_eq_sst as [E_stack_len_st_eq_sst_l E_stack_len_st_eq_sst_r].
    unfold mload_c.
    
    destruct (get_stack_st st) as [|coffset stk] eqn:E_stk_st; try (rewrite E_sstk_sst in E_stack_len_st_eq_sst_l; discriminate). (* case of [] *)

    exists (set_stack_st st (mload (get_memory_st st) coffset :: stk)).
    split; try reflexivity. (* left side of conjunction *)

    unfold st_is_instance_of_sst.
    exists (set_stack_st st (mload (get_memory_st st) coffset :: stk)).
    split; try apply eq_execution_states_refl.

    unfold eval_sstate.

    assert (H_st_inst_sst' := H_st_inst_sst).
    unfold st_is_instance_of_sst in H_st_inst_sst'.
    destruct H_st_inst_sst' as [st' H_st_inst_sst'].
    destruct H_st_inst_sst' as [H_st_inst_sst'_l H_st_inst_sst'_r].

    pose proof (eq_execution_states_ext st st' H_st_inst_sst'_r) as H_st_eq_st'.
    
    unfold eval_sstate in H_st_inst_sst'_l.

    destruct (get_instk_height_sst sst =? length (get_stack_st init_st)) eqn:E_len; try discriminate.

    destruct (eval_sstack (get_stack_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [stk''|] eqn:E_eval_sstack; try discriminate.
    
    destruct (eval_smemory (get_memory_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [mem|] eqn:E_eval_smemory; try discriminate.
    
    destruct (eval_sstorage (get_storage_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [strg|] eqn:E_eval_sstorage; try discriminate.

    injection H_st_inst_sst'_l as H_st_inst_sst'_l.

    injection H_mload_s as H_sst'.
    rewrite <- H_sst'.

    rewrite instk_height_preserved_when_updating_smap_sst.
    rewrite instk_height_preserved_when_updating_stack_sst.
    rewrite E_len.

    rewrite sstack_preserved_when_updating_smap_sst.
    rewrite set_and_then_get_stack_sst.
    rewrite set_and_then_get_smap_sst.
    rewrite smemory_preserved_when_updating_smap_sst.
    rewrite smemory_preserved_when_updating_stack_sst.
    rewrite sstorage_preserved_when_updating_smap_sst.
    rewrite sstorage_preserved_when_updating_stack_sst.
    
    unfold valid_sstate in H_valid_sst.
    destruct H_valid_sst as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].
    
    (* equivalence of eval_smemory *)
    pose proof (eval_smemory_preserved_when_smap_extended (get_memory_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) sm' smv mem (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key H_valid_sst_smemory E_add_to_smap E_eval_smemory) as E_eval_smemory_preserved.

    rewrite E_eval_smemory_preserved.
    
    (* equivalence of eval_sstorage *)
    pose proof (eval_sstorage_preserved_when_smap_extended (get_storage_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) sm' smv strg (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key H_valid_sst_sstorage E_add_to_smap E_eval_sstorage) as E_eval_sstorage_preserved.

    rewrite E_eval_sstorage_preserved.

    (* the case of eval_sstack *)

    rewrite E_sstk_sst in H_valid_sst_sstack.
    rewrite E_sstk_sst in E_eval_sstack.

    unfold eval_sstack in E_eval_sstack.
    unfold map_option in E_eval_sstack.
    rewrite <- map_option_ho in E_eval_sstack.

    simpl in H_valid_sst_sstack.
    destruct H_valid_sst_sstack as [H_valid_soffset H_valid_sstk].

    destruct (eval_sstack_val soffset (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (get_maxidx_smap (get_smap_sst sst))(get_bindings_smap (get_smap_sst sst)) ops) as [elem_val|] eqn:E_eval_soffset; try discriminate.

    destruct (map_option (fun elem : sstack_val => eval_sstack_val elem (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) ops) sstk) as [rs_val|] eqn:E_eval_sstk; try discriminate.
    
    pose proof (eval_sstack_val_preserved_when_smap_extended (get_instk_height_sst sst) (get_smap_sst sst) sm' soffset smv elem_val (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key H_valid_soffset E_add_to_smap E_eval_soffset) as E_eval_skey_preserved.
    
    pose proof (eval_sstack_mapo_preserved_when_smap_extended sstk (get_instk_height_sst sst) (get_smap_sst sst) sm' smv rs_val (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key H_valid_sstk E_add_to_smap E_eval_sstk) as E_eval_sstk_preserved.

    unfold eval_sstack.
    unfold map_option.
    rewrite <- map_option_ho.
    rewrite E_eval_sstk_preserved.

    unfold mload_solver_snd in H_valid_mload_solver.
    destruct H_valid_mload_solver as [H_valid_mload_solver_valid H_valid_mload_solver_correct].
    unfold mload_solver_valid_res in H_valid_mload_solver_valid.
    unfold mload_solver_correct_res in H_valid_mload_solver_correct.

    symmetry in E_smv.
    pose proof (H_valid_mload_solver_valid (get_smap_sst sst) (get_memory_sst sst) soffset (get_instk_height_sst sst) smv ops H_valid_sst_smemory H_valid_soffset E_smv) as H_valid_smv.

    pose proof (H_valid_mload_solver_correct (get_smap_sst sst) (get_memory_sst sst) soffset (get_instk_height_sst sst) smv ops key sm' H_valid_sst_smap H_valid_sst_smemory H_valid_soffset E_smv E_add_to_smap) as H_correct_mload.

    destruct (get_smap_sst sst) as [maxidx sb] eqn:E_smap_sst.
    simpl in H_correct_mload.
    destruct H_correct_mload as [maxidx' [m2' H_correct_mload]].
    destruct H_correct_mload as [H_correct_mload_l H_correct_mload_r].
    injection H_correct_mload_l as H_maxidx' H_m2'.
    rewrite <- H_maxidx' in H_correct_mload_r.
    rewrite <- H_m2' in H_correct_mload_r.
    pose proof (H_correct_mload_r (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) E_stack_len_st_eq_sst_r) as H_correct_mload_r.
    destruct H_correct_mload_r as [v H_correct_mload_r].
    destruct H_correct_mload_r as [H_correct_mload_r_0 H_correct_mload_r_1].
    unfold get_maxidx_smap in H_correct_mload_r_1.
    unfold get_bindings_smap in H_correct_mload_r_1.

    rewrite H_correct_mload_r_0.

    injection E_eval_sstack  as H_stk''.
    
    unfold eq_execution_states in H_st_inst_sst'_r.
    destruct H_st_inst_sst'_r as [H_st_inst_sst'_r_stk_eq [H_st_inst_sst'_r_mem_eq [H_st_inst_sst'_r_strg_eq _]]].
    rewrite <- H_st_inst_sst'_l in H_st_inst_sst'_r_stk_eq.
    rewrite E_stk_st in H_st_inst_sst'_r_stk_eq.
    simpl in H_st_inst_sst'_r_stk_eq.
    unfold eq_stack in H_st_inst_sst'_r_stk_eq.
    rewrite <- H_stk'' in H_st_inst_sst'_r_stk_eq.
    injection H_st_inst_sst'_r_stk_eq as H_coffset_eq_elem_val H_stk_eq_rs_val.

    rewrite H_st_eq_st'.
    rewrite <- H_st_inst_sst'_l.
    rewrite H_stk_eq_rs_val.
    unfold make_st.
    simpl.

    simpl in H_correct_mload_r_1.

    assert (H_maxidx_eq_maxidx: maxidx = maxidx). reflexivity.
    apply Nat.eqb_eq in H_maxidx_eq_maxidx.

    unfold eval_sstack_val in H_correct_mload_r_1.
    remember (S maxidx) as d'. (* to avoid unfolding too much *)

    unfold eval_sstack_val' in H_correct_mload_r_1. fold eval_sstack_val' in H_correct_mload_r_1.
    unfold follow_in_smap in H_correct_mload_r_1.
    rewrite H_maxidx_eq_maxidx in H_correct_mload_r_1.
    simpl in H_correct_mload_r_1.

    unfold eval_smemory in E_eval_smemory.
    simpl in E_eval_smemory.

    
    destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) maxidx sb ops)) (get_memory_sst sst)) as [updates|] eqn:E_eval_smemory_mapo; try discriminate.
    unfold eval_sstack_val in E_eval_smemory_mapo.
    rewrite Heqd' in H_correct_mload_r_1.
    rewrite E_eval_smemory_mapo in H_correct_mload_r_1.
    
    simpl in E_eval_soffset.
    unfold eval_sstack_val in E_eval_soffset.

    rewrite E_eval_soffset in H_correct_mload_r_1.
    injection H_correct_mload_r_1 as H_v.
    injection E_eval_smemory as E_smem.
    rewrite H_coffset_eq_elem_val.
    rewrite E_smem in H_v.
    rewrite H_v.
    reflexivity.
Qed.

(* almost identical to sstore_s *)
(* mstore8_s is a sound symbolic transformer when smemory_updater is sound *)
Lemma mstore8_snd:
  forall smemory_updater,
    smemory_updater_snd smemory_updater ->
    snd_state_transformer mstore8_c (mstore8_s smemory_updater).
Proof.
  intros smemory_updater H_smemory_updater_snd.
  unfold snd_state_transformer.
  intros sst sst' ops H_valid_sst H_mstore8_s.
  split.
  - pose proof (mstore8_valid_sst sst sst' ops smemory_updater H_smemory_updater_snd H_valid_sst H_mstore8_s) as H_valid_sst'. apply H_valid_sst'.
  - intros init_st st H_st_inst_sst.
    unfold mstore8_s in H_mstore8_s.
    destruct (get_stack_sst sst) as [|soffset sstk] eqn:E_sstk_sst; try discriminate.
    destruct sstk as [|svalue sstk'] eqn:E_sstk'_sst; try discriminate.
    injection H_mstore8_s as H_sst'.

    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as E_stack_len_st_eq_sst.
    destruct E_stack_len_st_eq_sst as [E_stack_len_st_eq_sst_l E_stack_len_st_eq_sst_r].

    unfold mstore8_c.
 
    destruct (get_stack_st st) as [|coffset stk] eqn:E_stk_st; try (rewrite E_sstk_sst in E_stack_len_st_eq_sst_l; discriminate). (* case of [] *)

    destruct stk as [|cvalue stk'] eqn:E_stk'_st; try (rewrite E_sstk_sst in E_stack_len_st_eq_sst_l; discriminate). (* case of [] *)

    exists (set_stack_st (set_memory_st st (mstore (get_memory_st st) (split1_byte  (cvalue : word (S (pred BytesInEVMWord) * 8))) coffset)) stk').
    
    split; try reflexivity.

    unfold st_is_instance_of_sst.
    exists (set_stack_st (set_memory_st st (mstore (get_memory_st st) (split1_byte (cvalue : word (S (pred BytesInEVMWord) * 8))) coffset)) stk').
    split; try apply eq_execution_states_refl.

    assert (H_st_inst_sst' := H_st_inst_sst).
    unfold st_is_instance_of_sst in H_st_inst_sst'.
    destruct H_st_inst_sst' as [st' H_st_inst_sst'].
    destruct H_st_inst_sst' as [H_st_inst_sst'_l H_st_inst_sst'_r].

    pose proof (eq_execution_states_ext st st' H_st_inst_sst'_r) as H_st_eq_st'.

    unfold eval_sstate in H_st_inst_sst'_l.

    destruct (get_instk_height_sst sst =? length (get_stack_st init_st)) eqn:E_len; try discriminate.
    
    destruct (eval_sstack (get_stack_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [stk''|] eqn:E_eval_sstack; try discriminate.
    
    destruct (eval_smemory (get_memory_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [mem|] eqn:E_eval_smemory; try discriminate.
    
    destruct (eval_sstorage (get_storage_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [strg|] eqn:E_eval_sstorage; try discriminate.

    injection H_st_inst_sst'_l as H_st_inst_sst'_l.

    rewrite E_sstk_sst in E_eval_sstack.
    simpl in E_eval_sstack.

    destruct (eval_sstack_val soffset (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (get_maxidx_smap (get_smap_sst sst))(get_bindings_smap (get_smap_sst sst)) ops) as [cofsset'|] eqn:E_eval_soffset; try discriminate.
    
    destruct (eval_sstack_val svalue (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) ops) as [cvalue'|] eqn:E_eval_svalue; try discriminate.

    destruct (eval_sstack sstk' (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [rs_val|] eqn:E_eval_sstk'; try discriminate.

    unfold eval_sstate.

    rewrite <- H_sst'.

    rewrite instk_height_preserved_when_updating_stack_sst.
    rewrite instk_height_preserved_when_updating_memory_sst.
    rewrite E_len.
    rewrite set_and_then_get_stack_sst.
    rewrite smap_preserved_when_updating_stack_sst.
    rewrite smap_preserved_when_updating_memory_sst.

    rewrite sstorage_preserved_when_updating_stack_sst.
    rewrite sstorage_preserved_when_updating_memory_sst.

    rewrite smemory_preserved_when_updating_stack_sst.
    rewrite set_and_then_get_memory_sst.
    
    (* case of eval_sstack *)
    rewrite E_eval_sstk'.

    (* case of sstorage *)
    rewrite E_eval_sstorage.


    (* case of sstorage *)

    unfold valid_sstate in H_valid_sst.
    destruct H_valid_sst as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].

    rewrite E_sstk_sst in H_valid_sst_sstack.
    simpl in H_valid_sst_sstack.
    destruct H_valid_sst_sstack as [H_valid_soffset [H_valid_svalue H_valid_sstk']].

    pose proof (valid_smemory_update_ov (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) soffset svalue H_valid_soffset H_valid_svalue) as [_ H_valid_u].

    remember (smemory_updater (U_MSTORE8 sstack_val soffset svalue) (get_memory_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) ops) as smem' eqn:E_updater.
    symmetry in E_updater.

    remember (U_MSTORE8 sstack_val soffset svalue) as u eqn:E_u.

    unfold smemory_updater_snd in H_smemory_updater_snd.
    destruct H_smemory_updater_snd as [H_smemory_updater_valid H_smemory_updater_correct].

    unfold smemory_updater_correct_res in H_smemory_updater_correct.
    pose proof (H_smemory_updater_correct (get_smap_sst sst) (get_memory_sst sst) smem' u (get_instk_height_sst sst) ops H_valid_sst_smap H_valid_sst_smemory H_valid_u E_updater (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) E_stack_len_st_eq_sst_r) as H_correct_smem'.

    destruct  H_correct_smem' as [mem1 [mem2 [H_eval_u_mem_sst [H_eval_smem' H_eq_mem1_mem2]]]].

    rewrite H_eval_smem'.

    unfold eq_memory in H_eq_mem1_mem2.
    pose proof (functional_extensionality mem1 mem2 H_eq_mem1_mem2) as H_eq_mem1_mem2_eq.
    rewrite <- H_eq_mem1_mem2_eq.

    rewrite H_st_eq_st'.
    rewrite <- H_st_inst_sst'_l.
    simpl.

    injection E_eval_sstack as E_stk''.

    unfold eq_execution_states in H_st_inst_sst'_r.
    destruct H_st_inst_sst'_r as [H_st_inst_sst'_stack _].
    unfold eq_stack in H_st_inst_sst'_stack.
    rewrite E_stk_st in H_st_inst_sst'_stack.
    rewrite <- H_st_inst_sst'_l in H_st_inst_sst'_stack.
    rewrite <- E_stk'' in H_st_inst_sst'_stack.
    simpl in H_st_inst_sst'_stack.
    injection H_st_inst_sst'_stack as H_ckey_eq_coffset' H_cvalue_eq_cvalue' H_stk'_eq_rsval.
    rewrite H_stk'_eq_rsval.

    unfold eval_smemory in H_eval_u_mem_sst.
    
    destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) ops)) (u :: get_memory_sst sst)) as [updates|] eqn:E_mapo; try discriminate.
    
    injection H_eval_u_mem_sst as H_mem1.

    unfold map_option in E_mapo.
    rewrite <- map_option_ho in E_mapo.
    unfold eval_common.EvalCommon.instantiate_memory_update at 1 in E_mapo.
    rewrite E_u in E_mapo.
    rewrite E_eval_soffset in E_mapo.
    rewrite E_eval_svalue in E_mapo.

    unfold eval_smemory in E_eval_smemory.
    destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) ops)) (get_memory_sst sst)) as [us|]; try discriminate.

    injection E_mapo as E_updates.
    rewrite <- E_updates in H_mem1.
    simpl in H_mem1.

    injection E_eval_smemory as H_mem.
    rewrite H_mem in H_mem1.
    rewrite <- H_ckey_eq_coffset' in H_mem1.
    rewrite <- H_cvalue_eq_cvalue' in H_mem1.
    rewrite H_mem1.
    reflexivity.
Qed.




(* almost identical to mstore8 *)
(* mstore_s is a sound symbolic transformer when smemory_updater is sound *)
Lemma mstore_snd:
  forall smemory_updater,
    smemory_updater_snd smemory_updater ->
    snd_state_transformer mstore_c (mstore_s smemory_updater).
Proof.
  intros smemory_updater H_smemory_updater_snd.
  unfold snd_state_transformer.
  intros sst sst' ops H_valid_sst H_mstore_s.
  split.
  - pose proof (mstore_valid_sst sst sst' ops smemory_updater H_smemory_updater_snd H_valid_sst H_mstore_s) as H_valid_sst'. apply H_valid_sst'.
  - intros init_st st H_st_inst_sst.
    unfold mstore_s in H_mstore_s.
    destruct (get_stack_sst sst) as [|soffset sstk] eqn:E_sstk_sst; try discriminate.
    destruct sstk as [|svalue sstk'] eqn:E_sstk'_sst; try discriminate.
    injection H_mstore_s as H_sst'.

    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as E_stack_len_st_eq_sst.
    destruct E_stack_len_st_eq_sst as [E_stack_len_st_eq_sst_l E_stack_len_st_eq_sst_r].

    unfold mstore_c.
 
    destruct (get_stack_st st) as [|coffset stk] eqn:E_stk_st; try (rewrite E_sstk_sst in E_stack_len_st_eq_sst_l; discriminate). (* case of [] *)

    destruct stk as [|cvalue stk'] eqn:E_stk'_st; try (rewrite E_sstk_sst in E_stack_len_st_eq_sst_l; discriminate). (* case of [] *)

    exists (set_stack_st (set_memory_st st (mstore (get_memory_st st) cvalue coffset)) stk').
    
    split; try reflexivity.

    unfold st_is_instance_of_sst.
    exists (set_stack_st (set_memory_st st (mstore (get_memory_st st) cvalue coffset)) stk').
    split; try apply eq_execution_states_refl.

    assert (H_st_inst_sst' := H_st_inst_sst).
    unfold st_is_instance_of_sst in H_st_inst_sst'.
    destruct H_st_inst_sst' as [st' H_st_inst_sst'].
    destruct H_st_inst_sst' as [H_st_inst_sst'_l H_st_inst_sst'_r].

    pose proof (eq_execution_states_ext st st' H_st_inst_sst'_r) as H_st_eq_st'.

    unfold eval_sstate in H_st_inst_sst'_l.

    destruct (get_instk_height_sst sst =? length (get_stack_st init_st)) eqn:E_len; try discriminate.
    
    destruct (eval_sstack (get_stack_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [stk''|] eqn:E_eval_sstack; try discriminate.
    
    destruct (eval_smemory (get_memory_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [mem|] eqn:E_eval_smemory; try discriminate.
    
    destruct (eval_sstorage (get_storage_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [strg|] eqn:E_eval_sstorage; try discriminate.

    injection H_st_inst_sst'_l as H_st_inst_sst'_l.

    rewrite E_sstk_sst in E_eval_sstack.
    simpl in E_eval_sstack.

    destruct (eval_sstack_val soffset (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (get_maxidx_smap (get_smap_sst sst))(get_bindings_smap (get_smap_sst sst)) ops) as [cofsset'|] eqn:E_eval_soffset; try discriminate.
    
    destruct (eval_sstack_val svalue (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) ops) as [cvalue'|] eqn:E_eval_svalue; try discriminate.

    destruct (eval_sstack sstk' (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [rs_val|] eqn:E_eval_sstk'; try discriminate.

    unfold eval_sstate.

    rewrite <- H_sst'.

    rewrite instk_height_preserved_when_updating_stack_sst.
    rewrite instk_height_preserved_when_updating_memory_sst.
    rewrite E_len.
    rewrite set_and_then_get_stack_sst.
    rewrite smap_preserved_when_updating_stack_sst.
    rewrite smap_preserved_when_updating_memory_sst.

    rewrite sstorage_preserved_when_updating_stack_sst.
    rewrite sstorage_preserved_when_updating_memory_sst.

    rewrite smemory_preserved_when_updating_stack_sst.
    rewrite set_and_then_get_memory_sst.
    
    (* case of eval_sstack *)
    rewrite E_eval_sstk'.

    (* case of sstorage *)
    rewrite E_eval_sstorage.


    (* case of sstorage *)

    unfold valid_sstate in H_valid_sst.
    destruct H_valid_sst as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].

    rewrite E_sstk_sst in H_valid_sst_sstack.
    simpl in H_valid_sst_sstack.
    destruct H_valid_sst_sstack as [H_valid_soffset [H_valid_svalue H_valid_sstk']].

    pose proof (valid_smemory_update_ov (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) soffset svalue H_valid_soffset H_valid_svalue) as [H_valid_u _].

    remember (smemory_updater (U_MSTORE sstack_val soffset svalue) (get_memory_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) ops) as smem' eqn:E_updater.
    symmetry in E_updater.

    remember (U_MSTORE sstack_val soffset svalue) as u eqn:E_u.

    unfold smemory_updater_snd in H_smemory_updater_snd.
    destruct H_smemory_updater_snd as [H_smemory_updater_valid H_smemory_updater_correct].

    unfold smemory_updater_correct_res in H_smemory_updater_correct.
    pose proof (H_smemory_updater_correct (get_smap_sst sst) (get_memory_sst sst) smem' u (get_instk_height_sst sst) ops H_valid_sst_smap H_valid_sst_smemory H_valid_u E_updater (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) E_stack_len_st_eq_sst_r) as H_correct_smem'.

    destruct  H_correct_smem' as [mem1 [mem2 [H_eval_u_mem_sst [H_eval_smem' H_eq_mem1_mem2]]]].

    rewrite H_eval_smem'.

    unfold eq_memory in H_eq_mem1_mem2.
    pose proof (functional_extensionality mem1 mem2 H_eq_mem1_mem2) as H_eq_mem1_mem2_eq.
    rewrite <- H_eq_mem1_mem2_eq.

    rewrite H_st_eq_st'.
    rewrite <- H_st_inst_sst'_l.
    simpl.

    injection E_eval_sstack as E_stk''.

    unfold eq_execution_states in H_st_inst_sst'_r.
    destruct H_st_inst_sst'_r as [H_st_inst_sst'_stack _].
    unfold eq_stack in H_st_inst_sst'_stack.
    rewrite E_stk_st in H_st_inst_sst'_stack.
    rewrite <- H_st_inst_sst'_l in H_st_inst_sst'_stack.
    rewrite <- E_stk'' in H_st_inst_sst'_stack.
    simpl in H_st_inst_sst'_stack.
    injection H_st_inst_sst'_stack as H_ckey_eq_coffset' H_cvalue_eq_cvalue' H_stk'_eq_rsval.
    rewrite H_stk'_eq_rsval.

    unfold eval_smemory in H_eval_u_mem_sst.
    
    destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) ops)) (u :: get_memory_sst sst)) as [updates|] eqn:E_mapo; try discriminate.
    
    injection H_eval_u_mem_sst as H_mem1.

    unfold map_option in E_mapo.
    rewrite <- map_option_ho in E_mapo.
    unfold eval_common.EvalCommon.instantiate_memory_update at 1 in E_mapo.
    rewrite E_u in E_mapo.
    rewrite E_eval_soffset in E_mapo.
    rewrite E_eval_svalue in E_mapo.

    unfold eval_smemory in E_eval_smemory.
    destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) ops)) (get_memory_sst sst)) as [us|]; try discriminate.

    injection E_mapo as E_updates.
    rewrite <- E_updates in H_mem1.
    simpl in H_mem1.

    injection E_eval_smemory as H_mem.
    rewrite H_mem in H_mem1.
    rewrite <- H_ckey_eq_coffset' in H_mem1.
    rewrite <- H_cvalue_eq_cvalue' in H_mem1.
    rewrite H_mem1.
    reflexivity.
Qed.

(* sha3_s is a sound symbolic transformer *)
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
    injection H_sha3_s as H_sst'.

    pose proof (st_is_instance_of_sst_stk_len init_st st sst ops H_st_inst_sst) as E_stack_len_st_eq_sst.
    destruct E_stack_len_st_eq_sst as [E_stack_len_st_eq_sst_l E_stack_len_st_eq_sst_r].

    assert (H_st_inst_sst' := H_st_inst_sst).
    unfold st_is_instance_of_sst in H_st_inst_sst'.
    destruct H_st_inst_sst' as [st' H_st_inst_sst'].
    destruct H_st_inst_sst' as [H_st_inst_sst'_l H_st_inst_sst'_r].

    pose proof (eq_execution_states_ext st st' H_st_inst_sst'_r) as H_st_eq_st'.

    unfold eval_sstate in H_st_inst_sst'_l.
    destruct (get_instk_height_sst sst =? length (get_stack_st init_st)) eqn:E_len; try discriminate.

    destruct (eval_sstack (get_stack_sst sst) (get_maxidx_smap (get_smap_sst sst))(get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st)(get_storage_st init_st) (get_context_st init_st) ops) as [stk'|] eqn:E_eval_sstack; try discriminate.

    destruct (eval_smemory (get_memory_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st)(get_storage_st init_st) (get_context_st init_st) ops) as [mem'|] eqn:E_eval_smemory; try discriminate.

    destruct (eval_sstorage (get_storage_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [strg'|] eqn:E_eval_sstorage; try discriminate.

    injection H_st_inst_sst'_l as H_st'.
    
    unfold sha3_c.
    
    destruct (get_stack_st st) as [|offset stk] eqn:E_stk_st; try (rewrite E_sstk_sst in E_stack_len_st_eq_sst_l; discriminate). (* case of [] *)
    
    destruct stk as [|size stk''] eqn:E_stk'_st; try (rewrite E_sstk_sst in E_stack_len_st_eq_sst_l; discriminate). (* case of [] *)
    
    exists (set_stack_st st (get_keccak256_ctx (get_context_st st) (wordToNat size) (mload' (get_memory_st st) offset (wordToNat size)) :: stk'')).

    split; try reflexivity.

    unfold st_is_instance_of_sst.
    exists (set_stack_st st (get_keccak256_ctx (get_context_st st) (wordToNat size) (mload' (get_memory_st st) offset (wordToNat size)) :: stk'')).
    
    split; try apply eq_execution_states_refl.
    
    unfold eval_sstate.
    rewrite <-  H_sst'.

    rewrite instk_height_preserved_when_updating_smap_sst.
    rewrite instk_height_preserved_when_updating_stack_sst.

    rewrite set_and_then_get_smap_sst.
    
    rewrite sstack_preserved_when_updating_smap_sst.
    rewrite set_and_then_get_stack_sst.
    
    rewrite smemory_preserved_when_updating_smap_sst.
    rewrite smemory_preserved_when_updating_stack_sst.
    rewrite sstorage_preserved_when_updating_smap_sst.
    rewrite sstorage_preserved_when_updating_stack_sst.
    
    rewrite E_len.

    unfold valid_sstate in H_valid_sst.
    destruct H_valid_sst as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].
    
    (* equivalence of eval_smemory *)

    pose proof (eval_smemory_preserved_when_smap_extended (get_memory_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) sm' (SymSHA3 soffset ssize (get_memory_sst sst)) mem' (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key H_valid_sst_smemory E_add_to_smap E_eval_smemory) as E_eval_smemory_preserved.
    rewrite E_eval_smemory_preserved.

    (* equivalence of eval_sstorage *)
    pose proof (eval_sstorage_preserved_when_smap_extended (get_storage_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) sm' (SymSHA3 soffset ssize (get_memory_sst sst)) strg' (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key H_valid_sst_sstorage E_add_to_smap E_eval_sstorage) as E_eval_sstorage_preserved.
    rewrite E_eval_sstorage_preserved.

    (* the case of eval_sstack *)
    rewrite E_sstk_sst in E_eval_sstack.
    simpl in E_eval_sstack.

    destruct (eval_sstack_val soffset (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) ops) as [coffset|] eqn:E_eval_soffset; try discriminate.

    destruct (eval_sstack_val ssize (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) ops) as [csize|] eqn:E_eval_ssize; try discriminate.

    destruct (eval_sstack sstk' (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [stk'''|] eqn:E_eval_sstk'; try discriminate.

    simpl.

    rewrite E_sstk_sst in H_valid_sst_sstack.
    simpl in H_valid_sst_sstack.
    destruct H_valid_sst_sstack as [_ [_ E_valid_sstk']].
      
    pose proof (eval_sstack_preserved_when_smap_extended sstk' (get_instk_height_sst sst) (get_smap_sst sst) sm' (SymSHA3 soffset ssize (get_memory_sst sst)) stk''' (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key E_valid_sstk' E_add_to_smap E_eval_sstk') as E_eval_sstk'_preserved.
    rewrite E_eval_sstk'_preserved.


    destruct (get_smap_sst sst) as [maxid sb] eqn:E_get_smap_sst.
    assert (E_add_to_smap' := E_add_to_smap).
    simpl in E_add_to_smap'.
    injection E_add_to_smap' as H_maxid H_sm'.
    
    rewrite <- H_sm'.
    simpl.

    unfold eval_sstack_val.
    apply Nat.eqb_eq in H_maxid as H_maxid_eqb.
    remember (S maxid) as d'. (* to avoid unfolding too much *)
    unfold eval_sstack_val'. fold eval_sstack_val'.
    unfold follow_in_smap.
    unfold is_fresh_var_smv.
    rewrite H_maxid_eqb.

    
    unfold eval_smemory in E_eval_smemory.
    simpl in E_eval_smemory.
    unfold eval_sstack_val in E_eval_smemory.
    rewrite Heqd'.
    destruct (map_option (eval_common.EvalCommon.instantiate_memory_update (fun sv : sstack_val => eval_sstack_val' (S maxid) sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) maxid sb ops)) (get_memory_sst sst)); try discriminate.

    simpl in E_eval_soffset.
    unfold eval_sstack_val in E_eval_soffset.
    rewrite E_eval_soffset.

    simpl in E_eval_ssize.
    unfold eval_sstack_val in E_eval_ssize.
    rewrite E_eval_ssize.

    unfold make_st.
    rewrite H_st_eq_st'.
    rewrite <- H_st'.
    simpl.

    unfold eq_execution_states in H_st_inst_sst'_r.
    destruct H_st_inst_sst'_r as [H_st_inst_sst'_r_eq_stk _].
    unfold eq_stack in H_st_inst_sst'_r_eq_stk.
    rewrite  E_stk_st in H_st_inst_sst'_r_eq_stk.
    rewrite <- H_st' in H_st_inst_sst'_r_eq_stk.
    injection E_eval_sstack as E_stk'.
    rewrite <- E_stk' in H_st_inst_sst'_r_eq_stk.
    simpl in H_st_inst_sst'_r_eq_stk.
    injection H_st_inst_sst'_r_eq_stk as H_coffset_eq_offset H_csize_eq_size H_stk''_eq_stk'''.
    rewrite H_coffset_eq_offset.
    rewrite H_csize_eq_size.
    rewrite H_stk''_eq_stk'''.

    injection E_eval_smemory as E_mem'.
    rewrite E_mem'.
    reflexivity.
Qed.

    
(* exec_stack_op_intsr_s is a sound symbolic transformer *)
Lemma exec_stack_op_intsr_snd:
  forall label, snd_state_transformer (exec_stack_op_intsr_c label) (exec_stack_op_intsr_s label).
Proof.
  intro label.
  unfold snd_state_transformer.
  intros sst sst' ops H_valid_sst H_execop_s. 
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

    destruct (add_to_smap (get_smap_sst sst) (SymOp label l)) as [key sm'] eqn:E_add_to_smap.
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

         destruct (get_instk_height_sst sst =? length (get_stack_st init_st)) eqn:E_len; try discriminate.
         
         destruct (eval_sstack (get_stack_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [stk|] eqn:E_eval_sstack; try discriminate.
         
         destruct (eval_smemory (get_memory_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [mem|] eqn:E_eval_smemory; try discriminate.
         
         destruct (eval_sstorage (get_storage_sst sst) (get_maxidx_smap (get_smap_sst sst)) (get_bindings_smap (get_smap_sst sst)) (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops) as [strg|] eqn:E_eval_sstorage; try discriminate.

         injection H_st_inst_sst'_l as H_st'.

         rewrite <- H_execop_s.

         rewrite set_and_then_get_smap_sst.

         rewrite instk_height_preserved_when_updating_smap_sst.
         rewrite instk_height_preserved_when_updating_stack_sst.
         rewrite E_len.
         
         rewrite sstack_preserved_when_updating_smap_sst.
         rewrite set_and_then_get_stack_sst.

         rewrite smemory_preserved_when_updating_smap_sst.
         rewrite smemory_preserved_when_updating_stack_sst.
         
         rewrite sstorage_preserved_when_updating_smap_sst.
         rewrite sstorage_preserved_when_updating_stack_sst.


         unfold valid_sstate in H_valid_sst.
         destruct H_valid_sst as [H_valid_sst_smap [H_valid_sst_sstack [H_valid_sst_smemory H_valid_sst_sstorage]]].

         (* equivalence of eval_smemory *)
         pose proof (eval_smemory_preserved_when_smap_extended (get_memory_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) sm' (SymOp label l) mem (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key H_valid_sst_smemory E_add_to_smap E_eval_smemory) as E_eval_smemory_preserved.
    rewrite E_eval_smemory_preserved.

         
         (* equivalence of eval_sstorage *)
         pose proof (eval_sstorage_preserved_when_smap_extended (get_storage_sst sst) (get_instk_height_sst sst) (get_smap_sst sst) sm' (SymOp label l) strg (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key H_valid_sst_sstorage E_add_to_smap E_eval_sstorage) as E_eval_sstorage_preserved.
         rewrite E_eval_sstorage_preserved.

         (* the case of eval_sstack *)
         destruct (get_smap_sst sst) as [maxidx sb] eqn:E_smap_sst.
         assert (E_add_to_smap' := E_add_to_smap).
         injection E_add_to_smap' as H_maxidx H_sm'.
         rewrite <- H_sm'.
         simpl.

         apply Nat.eqb_eq in H_maxidx as H_maxidx_eqb.
         unfold eval_sstack_val.
         remember (S maxidx) as d'. (* to avoid unfolding too much *)
         unfold eval_sstack_val'. fold eval_sstack_val'.
         unfold follow_in_smap.
         rewrite H_maxidx_eqb.
         unfold is_fresh_var_smv.

         rewrite E_label.

         apply Nat.leb_le in E_n_lt_len_stk_sst as E_n_lt_len_stk_sst_eq.

         unfold firstn_e in E_firstn_e.
         rewrite <- E_stack_len_st_eq_sst_l in E_firstn_e.
         rewrite E_n_lt_len_stk_sst in E_firstn_e.
         injection E_firstn_e as E_l1.

         unfold skipn_e in E_skipn_e.
         rewrite <- E_stack_len_st_eq_sst_l in E_skipn_e.
         rewrite E_n_lt_len_stk_sst in E_skipn_e.
         injection E_skipn_e as E_l2.

         
         pose proof (firstn_length_le (get_stack_sst sst) E_n_lt_len_stk_sst_eq) as E_len_firstn_0.
         rewrite E_firstn_e_s in E_len_firstn_0.
         apply Nat.eqb_eq in E_len_firstn_0 as E_len_l_eqb_n.
         rewrite E_len_l_eqb_n.

         pose proof (firstn_skipn n (get_stack_sst sst)) as H_sstk.
         rewrite E_firstn_e_s in H_sstk.
         rewrite E_skipn_e_s in H_sstk.

         pose proof (firstn_skipn n (get_stack_st st)) as H_stk.
         rewrite E_l1 in H_stk.
         rewrite E_l2 in H_stk.


         simpl in H_valid_sst_sstack.
         rewrite <- H_sstk in H_valid_sst_sstack.
         pose proof (valid_sstack_app1 (get_instk_height_sst sst) maxidx l l0 H_valid_sst_sstack) as [H_valid_l H_valid_l0].

         rewrite <- H_sstk in E_eval_sstack.

         simpl in E_eval_sstack.
         unfold eval_sstack in E_eval_sstack.
         
         pose proof (map_option_app1 sstack_val EVMWord (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) maxidx sb ops) l l0 stk E_eval_sstack) as H_eval_sstack_2.
         
         destruct H_eval_sstack_2 as [rl1 [rl2 [H_rl1_rl2_stk [H_len1 H_len2]]]].

         rewrite H_rl1_rl2_stk in E_eval_sstack.

         symmetry in H_len1.
         symmetry in H_len2.
         
         pose proof (map_option_app2 sstack_val EVMWord (fun sv : sstack_val => eval_sstack_val sv (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) maxidx sb ops) l l0 rl1 rl2 H_len1 H_len2 E_eval_sstack) as [E_eval_l E_eval_l0].

         rewrite Heqd'.
         unfold eval_sstack_val in E_eval_l.         
         rewrite E_eval_l.
         unfold eval_sstack.

         pose proof (eval_sstack_mapo_preserved_when_smap_extended l0 (get_instk_height_sst sst) (SymMap maxidx sb) sm' (SymOp label l) rl2 (get_stack_st init_st) (get_memory_st init_st) (get_storage_st init_st) (get_context_st init_st) ops key H_valid_l0 E_add_to_smap E_eval_l0) as E_eval_l0_preserved.

         rewrite <- H_sm' in E_eval_l0_preserved.
         unfold get_maxidx_smap in E_eval_l0_preserved.
         unfold get_bindings_smap in E_eval_l0_preserved.
         rewrite Heqd' in E_eval_l0_preserved.
         
         rewrite E_eval_l0_preserved.
         rewrite H_st_eq_st'.
         rewrite <- H_st'.
         simpl.

         unfold eq_execution_states in H_st_inst_sst'_r.
         destruct H_st_inst_sst'_r as [H_eq_stk _].
         unfold eq_stack in H_eq_stk.
         rewrite <- H_stk in H_eq_stk.
         rewrite <- H_st' in H_eq_stk.
         rewrite H_rl1_rl2_stk in H_eq_stk.
         simpl in H_eq_stk.

         assert (E_n_lt_len_stk_st := E_n_lt_len_stk_sst).
         rewrite E_stack_len_st_eq_sst_l in E_n_lt_len_stk_st.
         apply Nat.leb_le in E_n_lt_len_stk_st as E_n_lt_len_stk_st_eq.
         pose proof (firstn_length_le (get_stack_st st) E_n_lt_len_stk_st_eq) as E_len_l1.
         rewrite E_l1 in E_len_l1.
         rewrite E_len_firstn_0 in H_len1.
         rewrite <- E_len_l1 in H_len1.

         pose proof (skipn_same_len n (get_stack_sst sst) (get_stack_st st) E_stack_len_st_eq_sst_l) as H_len_l0_l2.
         rewrite E_skipn_e_s in H_len_l0_l2.
         rewrite E_l2 in H_len_l0_l2.
         rewrite H_len_l0_l2 in H_len2.
         Search skipn.
         
          (* H_eq_stk : l1 ++ l2 = rl1 ++ rl2 *)
                  
         pose proof (app_same_len l1 l2 rl1 rl2 H_len1 H_len2 H_eq_stk) as [H_eq_l1_rl1 H_eq_l2_rl2].

         rewrite H_eq_l1_rl1.
         rewrite H_eq_l2_rl2.
         reflexivity.
         
      ++ unfold skipn_e in E_skipn_e.
         rewrite <- E_stack_len_st_eq_sst_l in E_skipn_e.
         rewrite  E_n_lt_len_stk_sst in E_skipn_e.
         discriminate.

    + unfold firstn_e in E_firstn_e.
      rewrite <- E_stack_len_st_eq_sst_l in E_firstn_e.
      rewrite  E_n_lt_len_stk_sst in E_firstn_e.
      discriminate.
Qed.


(* exec_stack_op_intsr_s is a sound symbolic transformer *)

Lemma evm_exec_instr_snd:
  forall (smemory_updater: smemory_updater_type) (sstorage_updater: sstorage_updater_type) (mload_solver: mload_solver_type) (sload_solver: sload_solver_type) (i : instr),
    smemory_updater_snd smemory_updater ->
    sstorage_updater_snd sstorage_updater ->
    mload_solver_snd mload_solver ->
    sload_solver_snd sload_solver ->
    snd_state_transformer (evm_exec_instr_c i) (evm_exec_instr_s smemory_updater sstorage_updater mload_solver sload_solver i).
Proof.
  intros smemory_updater sstorage_updater mload_solver sload_solver i.
  intros H_smemory_updater_snd H_sstorage_updater_snd H_mload_solver_snd H_sload_solver_snd.
  destruct i.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply push_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply pushtag_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply pop_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply dup_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply swap_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. pose proof (mload_snd mload_solver H_mload_solver_snd) as H_mload_snd. apply H_mload_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. pose proof (mstore_snd smemory_updater H_smemory_updater_snd) as H_mstore_snd. apply H_mstore_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. pose proof (mstore8_snd smemory_updater H_smemory_updater_snd) as H_mstore8_snd. apply H_mstore8_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. pose proof (sload_snd sload_solver H_sload_solver_snd) as H_sload_snd. apply H_sload_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. pose proof (sstore_snd sstorage_updater H_sstorage_updater_snd) as H_sstore_snd. apply H_sstore_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply sha3_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply sha3_snd.
  - unfold evm_exec_instr_c. unfold evm_exec_instr_s. apply exec_stack_op_intsr_snd.
Qed.


(* evm_exec_block_s and evm_exec_block_c are sound transformers -- when applied to p *)
Lemma evm_exec_block_snd:
  forall (smemory_updater: smemory_updater_type) (sstorage_updater: sstorage_updater_type) (mload_solver: mload_solver_type) (sload_solver: sload_solver_type) (p : block) ,
    smemory_updater_snd smemory_updater ->
    sstorage_updater_snd sstorage_updater ->
    mload_solver_snd mload_solver ->
    sload_solver_snd sload_solver ->
    snd_state_transformer (evm_exec_block_c p) (evm_exec_block_s smemory_updater sstorage_updater mload_solver sload_solver p).
Proof.
  intros smemory_updater sstorage_updater mload_solver sload_solver p.
  intros H_smemory_updater_snd H_sstorage_updater_snd H_mload_solver_snd H_sload_solver_snd.
  unfold snd_state_transformer.
  revert p.
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
    destruct (evm_exec_instr_s smemory_updater sstorage_updater mload_solver sload_solver i sst ops) as [sst''|] eqn:E_evm_exec_instr_s; try discriminate.

    (* derive relation between execution and symbolic execution of i *)
    apply evm_exec_instr_snd with (i:=i) in E_evm_exec_instr_s as [H_eval_stt'' E_evm_exec_instr_s_0]; try (apply H_valid_sst || apply H_smemory_updater_snd || apply H_sstorage_updater_snd || apply H_mload_solver_snd || apply H_sload_solver_snd).

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

Lemma gen_empty_sstate_eval_sstack_snd:
  forall (i n : nat) (stk: stack) (mem: memory) (strg: storage) (ctx: context) (maxidx: nat) (sb: sbindings) (ops : stack_op_instr_map),
    length stk = n ->
    i <= n ->
    n >= 0 ->
    eval_sstack (List.map InStackVar (seq (n-i) i)) maxidx sb stk mem strg ctx ops = Some (skipn (n-i) stk).
Proof.
  intros.
  induction i as [|i' IHi'].
  - simpl. rewrite -> Nat.sub_0_r. rewrite <- H. rewrite -> skipn_all. reflexivity.
  - destruct sb.
    simpl.
    pose proof (gt_Sn_O i') as eq_Si_gt_0.
    pose proof (Nat.sub_lt n (S i') H0 eq_Si_gt_0) as eq_si_n.
    rewrite <- H in eq_si_n at 2.
    pose proof (@nth_error_ok' EVMWord stk (n - S i') eq_si_n) as eq_nth_error_value_ex.
    unfold eval_sstack_val.
    simpl.
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
    destruct eq_nth_error_value_ex.
    unfold eval_sstack_val.
    simpl.
    rewrite H2.
  pose proof (succ_minus_succ n i' H0) as eq_n_i_succ.
  rewrite eq_n_i_succ.
  pose proof (le_Sn_le i' n H0) as eq_i'_leq_n.
  apply IHi' in eq_i'_leq_n.
  rewrite eq_i'_leq_n.
  pose proof (skipn_nth EVMWord (n - (S i')) stk x H2) as eq_skipn_x.
  rewrite eq_skipn_x.
  rewrite eq_n_i_succ. reflexivity.
Qed.



(* An initial symbolic state is equivalent to any state, as long as
they refer to a stack with the same size *)
Lemma gen_empty_sstate_snd:
  forall (st: state) (instk_height: nat) (sst: sstate) (ops : stack_op_instr_map),
    length (get_stack_st st) = instk_height ->
    sst = gen_empty_sstate instk_height ->
    st_is_instance_of_sst st st sst ops /\ valid_sstate sst ops.
Proof.
  intros.
  split.
  - unfold st_is_instance_of_sst.
    exists st.
    split.
    + unfold eval_sstate.
      assert(H1:=H0).
      assert(H2:=H0).
      unfold gen_empty_sstate in H0.
      rewrite H0.
      simpl.

      assert(instk_height >= 0). intuition.
      
      
      pose proof (gen_empty_sstate_eval_sstack_snd instk_height instk_height (get_stack_st st) (get_memory_st st) (get_storage_st st) (get_context_st st) 0 [] ops H (le_n instk_height) H3).

      rewrite Nat.sub_diag in H4.
      rewrite H4.
      symmetry in H.
      apply Nat.eqb_eq in H.
      rewrite H.
      simpl.
      destruct st.
      simpl.
      reflexivity.
    + apply eq_execution_states_refl.
  - pose proof (valid_empty_sstate instk_height).
    rewrite H0.
    apply H1.
Qed.

Theorem symbolic_exec_snd:
  forall (smemory_updater: smemory_updater_type) (sstorage_updater: sstorage_updater_type) (mload_solver: mload_solver_type) (sload_solver: sload_solver_type) (p : block) (instk_height : nat) (sst : sstate) (ops : stack_op_instr_map),
    smemory_updater_snd smemory_updater ->
    sstorage_updater_snd sstorage_updater ->
    mload_solver_snd mload_solver ->
    sload_solver_snd sload_solver ->
    evm_sym_exec smemory_updater sstorage_updater mload_solver sload_solver p instk_height ops = Some sst ->
    valid_sstate sst ops /\                                       
    forall (st : state), 
      length (get_stack_st st) = instk_height -> 
      exists (st': state),
        evm_exec_block_c p st ops = Some st' /\
          st_is_instance_of_sst st st' sst ops. (* st' is an instance of sst wrt the initial state st *)
Proof.
  intros smemory_updater sstorage_updater mload_solver sload_solver p instk_height sst ops.
  intros H_smemory_updater_snd H_sstorage_updater_snd H_mload_solver_snd H_sload_solver_snd H_evm_sym_exec.
  unfold evm_sym_exec in H_evm_sym_exec.
  pose proof (evm_exec_block_snd smemory_updater sstorage_updater mload_solver sload_solver p H_smemory_updater_snd H_sstorage_updater_snd H_mload_solver_snd H_sload_solver_snd) as H_exec_blk_snd.
  unfold snd_state_transformer in H_exec_blk_snd.
  pose proof (valid_empty_sstate instk_height ops) as H_valid_empty_sstate.
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


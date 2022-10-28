Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import List.
Require Import Coq_EVM.optimizations.
Import Optimizations.
Require Import Coq_EVM.definitions.
Import EVM_Def Concrete Abstract Optimizations.
Require Import Coq_EVM.interpreter.
Import Interpreter SFS.
Import ListNotations.
Require Import Coq.NArith.NArith.

Module Checker.

Definition sem_eq_blocks (p1 p2: block) (k: nat) (ops: stack_op_map) : Prop :=
forall (in_st: state) (in_stk: stack),
get_stack_es in_st = in_stk ->
length in_stk = k ->
exists (out_st : state),
concr_interpreter p1 in_st ops = Some out_st /\
concr_interpreter p2 in_st ops = Some out_st.


Definition eq_block_chkr_snd (chkr : block -> block -> nat -> bool) : Prop :=
forall (p1 p2: block) (k: nat),
chkr p1 p2 k = true -> sem_eq_blocks p1 p2 k evm_stack_opm.


Definition evm_eq_block_chkr (p1 p2: block) (k: nat) : bool :=
match symbolic_exec p1 k evm_stack_opm with
| None => false
| Some sst1 => 
    match symbolic_exec p2 k evm_stack_opm with 
    | None => false
    | Some sst2 => eq_sstate_chkr sst1 sst2 evm_stack_opm
    end
end.


Definition evm_eq_block_chkr' (opt: optim) (opt_p p: block) (k: nat) 
  : bool :=
match symbolic_exec opt_p k evm_stack_opm with
| None => false
| Some sst1 => 
    match symbolic_exec p k evm_stack_opm with 
    | None => false
    | Some sst2 => let (sst2', _) := opt sst2 in 
                   eq_sstate_chkr sst1 sst2' evm_stack_opm
    end
end.

(* Pretty printing of symbolic states for debugging *)
Inductive hsstack_val : Type :=
  | HVal (val: N)
  | HInStackVar (var: nat)
  | HFreshVar (var: nat).
Inductive hsmap_val : Type :=
  | HSymBasicVal (val: hsstack_val)
  | HSymOp (opcode : stack_op_instr) (args : list hsstack_val).
Definition hsstack  := list hsstack_val.
Definition hsmap    := list (nat*hsmap_val).
Inductive hasfs : Type :=
  | HSymState (height maxid: nat) (s: hsstack) (m: hsmap).

Definition sstack_val_to_human (h: sstack_val) : hsstack_val :=
match h with
| Val v => HVal (wordToN v)
| InStackVar n => HInStackVar n
| FreshVar n => HFreshVar n
end.
Fixpoint s_to_human (s: sstack) : hsstack :=
match s with
| [] => []
| h::t => (sstack_val_to_human h)::(s_to_human t)
end.
Definition smap_val_to_human (v: smap_val) : hsmap_val :=
match v with
| SymBasicVal v => HSymBasicVal (sstack_val_to_human v)
| SymOp opcode args => HSymOp opcode 
    (List.map sstack_val_to_human args)
end.
Fixpoint map_to_human (m: smap) : hsmap :=
match m with
| [] => []
| (k,v)::t => (k,smap_val_to_human v)::(map_to_human t)
end.
Definition sstate_to_human (a: sstate) : hasfs :=
match a with
| SymState he mx s m => HSymState he mx (s_to_human s) (map_to_human m)
end.
(* Debugging version of chkr' *)
Definition evm_eq_block_chkr'_dbg (opt: optim) (opt_p p: block) 
  (height: nat) : hasfs*hasfs*bool :=
match symbolic_exec opt_p height evm_stack_opm with
| None => (sstate_to_human (empty_asfs height),
           sstate_to_human (empty_asfs height),
           false)
| Some sfs1 => 
    match symbolic_exec p height evm_stack_opm with 
    | None => (sstate_to_human sfs1,
               sstate_to_human (empty_asfs height),
               false)
    | Some sfs2 => let (sfs3, _) := opt sfs2 in 
                   (sstate_to_human sfs1, 
                    sstate_to_human sfs3,
                    eq_sstate_chkr sfs1 sfs3 evm_stack_opm)
    end
end.
(*************************************)


Definition evm_eq_block_chkr'' (opt: optim) (opt_p p: block) (k: nat) 
  : bool :=
match symbolic_exec opt_p k evm_stack_opm with
| None => false
| Some sst1 => 
    match symbolic_exec p k evm_stack_opm with 
    | None => false
    | Some sst2 => let (sst2', _) := opt sst2 in 
                   let (sst1', _) := opt sst1 in
                   eq_sstate_chkr sst1' sst2' evm_stack_opm
    end
end.


Lemma equiv_checker'_correct: forall (opt_p p: block) (height: nat) 
  (opt: optim) (in_es: state) 
  (in_stk: stack),
safe_optimization opt ->
evm_eq_block_chkr' opt opt_p p height = true ->
get_stack_es in_es = in_stk ->
length in_stk = height ->
exists (out_es_opt out_es_p: state),
(concr_interpreter opt_p in_es evm_stack_opm = Some out_es_opt /\
 concr_interpreter p in_es evm_stack_opm = Some out_es_p /\
 get_stack_es out_es_opt = get_stack_es out_es_p).
Proof.
intros.
unfold evm_eq_block_chkr' in H0.
destruct (symbolic_exec p height evm_stack_opm) as [sfs_p|] eqn: eq_symb_exec_p;
  try (destruct (symbolic_exec opt_p height evm_stack_opm); discriminate). 
destruct (symbolic_exec opt_p height evm_stack_opm) as [sfsopt_p|] eqn: eq_symb_exec_opt;
  try discriminate.
pose proof (correctness_symb_exec opt_p in_stk evm_stack_opm height in_es sfsopt_p H1
  H2 eq_symb_exec_opt evm_stack_opm_validity) 
  as [out_es1 [Hconcr_p1 eq_eval_sfs_opt]].
pose proof (correctness_symb_exec p in_stk evm_stack_opm height in_es sfs_p H1
  H2 eq_symb_exec_p evm_stack_opm_validity) 
  as [out_es2 [Hconcr_p2 eq_eval_sfs_p]].  
exists out_es1. exists out_es2.
split; try assumption. split; try assumption.
destruct (opt sfs_p) as [p_with_opt flag] eqn: eq_optimize_p.
pose proof (asfs_eq_correctness sfsopt_p p_with_opt evm_stack_opm H0 
  evm_stack_opm_validity in_stk).
unfold safe_optimization in H.
apply symb_exec_valid_sstate in eq_symb_exec_p as Hdecr_sfs_p.
pose proof (H in_stk (get_stack_es out_es2) sfs_p p_with_opt flag
  eq_eval_sfs_p eq_optimize_p Hdecr_sfs_p) as [eq_eval_p_with_opt _].
rewrite -> eq_eval_p_with_opt in H3.
rewrite -> eq_eval_sfs_opt in H3.
injection H3. trivial.
Qed.


Theorem evm_eq_block_chkr'_snd: forall (opt: optim), 
safe_optimization opt -> eq_block_chkr_snd (evm_eq_block_chkr' opt).
Proof.
intros. unfold eq_block_chkr_snd. intros. unfold sem_eq_blocks. intros.
pose proof (equiv_checker'_correct p1 p2 k opt in_st in_stk H H0 H1 H2)
  as [out_es_opt [out_es [Hconcr_p1 [Hconcr_p2 Heq_stacks]]]].
exists out_es.
destruct in_st as [stack mem storage] eqn: eq_in_st.
destruct out_es as [stack_o mem_o storage_o] eqn: eq_out_st.
destruct out_es_opt as [stack_op mem_op storage_op] eqn: eq_out_opt.
apply concr_mem_storage_eq in Hconcr_p1 as HH. simpl in HH.
apply concr_mem_storage_eq in Hconcr_p2 as HH'. simpl in HH'.
rewrite -> Hconcr_p1. rewrite -> Hconcr_p2.
destruct HH as [eq_mem_o eq_storage_o].
destruct HH' as [eq_mem_op eq_storage_op].
rewrite <- eq_mem_op. rewrite <- eq_mem_o. 
rewrite <- eq_storage_op. rewrite <- eq_storage_o.
simpl in Heq_stacks. rewrite -> Heq_stacks.
auto.
Qed.


Lemma eq_equiv_checker_optimize_ed:
evm_eq_block_chkr' optimize_id = evm_eq_block_chkr.
Proof.
auto.
Qed.


Theorem evm_eq_block_chkr_snd: eq_block_chkr_snd evm_eq_block_chkr.
Proof.
rewrite <- eq_equiv_checker_optimize_ed.
apply evm_eq_block_chkr'_snd.
apply optimize_id_safe.
Qed.


Lemma equiv_checker''_correct: forall (opt_p p: block) (height: nat) 
  (opt: optim) (in_es: state) 
  (in_stk: stack),
safe_optimization opt ->
evm_eq_block_chkr'' opt opt_p p height = true ->
get_stack_es in_es = in_stk ->
length in_stk = height ->
exists (out_es_opt out_es_p: state),
(concr_interpreter opt_p in_es evm_stack_opm = Some out_es_opt /\
 concr_interpreter p in_es evm_stack_opm = Some out_es_p /\
 get_stack_es out_es_opt = get_stack_es out_es_p).
Proof.
intros.
unfold evm_eq_block_chkr'' in H0.
destruct (symbolic_exec p height evm_stack_opm) as [sfs_p|] eqn: eq_symb_exec_p;
  try (destruct (symbolic_exec opt_p height evm_stack_opm); discriminate). 
destruct (symbolic_exec opt_p height evm_stack_opm) as [sfsopt_p|] eqn: eq_symb_exec_opt;
  try discriminate.
pose proof (correctness_symb_exec opt_p in_stk evm_stack_opm height in_es sfsopt_p H1
  H2 eq_symb_exec_opt evm_stack_opm_validity) 
  as [out_es1 [Hconcr_p1 eq_eval_sfs_opt]].
pose proof (correctness_symb_exec p in_stk evm_stack_opm height in_es sfs_p H1
  H2 eq_symb_exec_p evm_stack_opm_validity) 
  as [out_es2 [Hconcr_p2 eq_eval_sfs_p]].  
exists out_es1. exists out_es2.
split; try assumption. split; try assumption.
destruct (opt sfs_p) as [p_with_opt flag] eqn: eq_optimize_p.
destruct (opt sfsopt_p) as [opt_with_opt flagopt] eqn: eq_optimize_popt.
pose proof (asfs_eq_correctness opt_with_opt p_with_opt evm_stack_opm H0 
  evm_stack_opm_validity in_stk) as H3.
unfold safe_optimization in H.
apply symb_exec_valid_sstate in eq_symb_exec_p as Hdecr_sfs_p.
apply symb_exec_valid_sstate in eq_symb_exec_opt as Hdecr_sfs_opt.
pose proof (H in_stk (get_stack_es out_es2) sfs_p p_with_opt flag
  eq_eval_sfs_p eq_optimize_p Hdecr_sfs_p) as [eq_eval_p_with_opt _].
pose proof (H in_stk (get_stack_es out_es1) sfsopt_p opt_with_opt flagopt
  eq_eval_sfs_opt eq_optimize_popt Hdecr_sfs_opt) as [eq_eval_opt _].
rewrite -> eq_eval_p_with_opt in H3.
rewrite -> eq_eval_opt in H3.
injection H3. trivial.
Qed.


Theorem evm_eq_block_chkr''_snd: forall (opt: optim), 
safe_optimization opt -> eq_block_chkr_snd (evm_eq_block_chkr'' opt).
Proof.
intros. unfold eq_block_chkr_snd. intros. unfold sem_eq_blocks. intros.
pose proof (equiv_checker''_correct p1 p2 k opt in_st in_stk H H0 H1 H2)
  as [out_es_opt [out_es [Hconcr_p1 [Hconcr_p2 Heq_stacks]]]].
exists out_es.
destruct in_st as [stack mem storage] eqn: eq_in_st.
destruct out_es as [stack_o mem_o storage_o] eqn: eq_out_st.
destruct out_es_opt as [stack_op mem_op storage_op] eqn: eq_out_opt.
apply concr_mem_storage_eq in Hconcr_p1 as HH. simpl in HH.
apply concr_mem_storage_eq in Hconcr_p2 as HH'. simpl in HH'.
rewrite -> Hconcr_p1. rewrite -> Hconcr_p2.
destruct HH as [eq_mem_o eq_storage_o].
destruct HH' as [eq_mem_op eq_storage_op].
rewrite <- eq_mem_op. rewrite <- eq_mem_o. 
rewrite <- eq_storage_op. rewrite <- eq_storage_o.
simpl in Heq_stacks. rewrite -> Heq_stacks.
auto.
Qed.

(*
Print Assumptions evm_eq_block_chkr_snd.
Print Assumptions evm_eq_block_chkr'_snd.
Print Assumptions evm_eq_block_chkr''_snd.
Print Assumptions our_optimization_pipeline_snd.*)


End Checker.
Import Checker.

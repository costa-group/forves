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

Definition sem_eq_blocks (p1 p2: block) (k: nat) (ops: opm) : Prop :=
forall (in_st: execution_state) (in_stk: tstack),
get_stack_es in_st = in_stk ->
length in_stk = k ->
exists (out_st : execution_state),
concr_interpreter p1 in_st ops = Some out_st /\
concr_interpreter p2 in_st ops = Some out_st.


Definition eq_block_chkr_snd (chkr : block -> block -> nat -> bool) : Prop :=
forall (p1 p2: block) (k: nat),
chkr p1 p2 k = true -> sem_eq_blocks p1 p2 k opmap.


Definition evm_eq_block_chkr (opt_p p: block) (height: nat)
  : bool :=
match symbolic_exec opt_p height opmap with
| None => false
| Some sfs1 => 
    match symbolic_exec p height opmap with 
    | None => false
    | Some sfs2 => eq_sstate_chkr sfs1 sfs2 opmap
    end
end.


Definition evm_eq_block_chkr' (opt: optimization) (opt_p p: block) (height: nat) 
  : bool :=
match symbolic_exec opt_p height opmap with
| None => false
| Some sfs1 => 
    match symbolic_exec p height opmap with 
    | None => false
    | Some sfs2 => let (sfs3, _) := opt sfs2 in 
                   eq_sstate_chkr sfs1 sfs3 opmap
    end
end.

(* Pretty printing of symbolic states for debugging *)
Inductive hasfs_stack_val : Type :=
  | HVal (val: N)
  | HInStackVar (var: nat)
  | HFreshVar (var: nat).
Inductive hasfs_map_val : Type :=
  | HASFSBasicVal (val: hasfs_stack_val)
  | HASFSOp (opcode : oper_label) (args : list hasfs_stack_val).
Definition hasfs_stack  := list hasfs_stack_val.
Definition hasfs_map    := list (nat*hasfs_map_val).
Inductive hasfs : Type :=
  | HASFSc (height maxid: nat) (s: hasfs_stack) (m: hasfs_map).

Definition asfs_stack_val_to_human (h: asfs_stack_val) : hasfs_stack_val :=
match h with
| Val v => HVal (wordToN v)
| InStackVar n => HInStackVar n
| FreshVar n => HFreshVar n
end.
Fixpoint s_to_human (s: asfs_stack) : hasfs_stack :=
match s with
| [] => []
| h::t => (asfs_stack_val_to_human h)::(s_to_human t)
end.
Definition asfs_map_val_to_human (v: asfs_map_val) : hasfs_map_val :=
match v with
| ASFSBasicVal v => HASFSBasicVal (asfs_stack_val_to_human v)
| ASFSOp opcode args => HASFSOp opcode 
    (List.map asfs_stack_val_to_human args)
end.
Fixpoint map_to_human (m: asfs_map) : hasfs_map :=
match m with
| [] => []
| (k,v)::t => (k,asfs_map_val_to_human v)::(map_to_human t)
end.
Definition asfs_to_human (a: asfs) : hasfs :=
match a with
| ASFSc he mx s m => HASFSc he mx (s_to_human s) (map_to_human m)
end.
(* Debugging version of chkr' *)
Definition evm_eq_block_chkr'_dbg (opt: optimization) (opt_p p: block) 
  (height: nat) : hasfs*hasfs*bool :=
match symbolic_exec opt_p height opmap with
| None => (asfs_to_human (empty_asfs height),
           asfs_to_human (empty_asfs height),
           false)
| Some sfs1 => 
    match symbolic_exec p height opmap with 
    | None => (asfs_to_human sfs1,
               asfs_to_human (empty_asfs height),
               false)
    | Some sfs2 => let (sfs3, _) := opt sfs2 in 
                   (asfs_to_human sfs1, 
                    asfs_to_human sfs3,
                    eq_sstate_chkr sfs1 sfs3 opmap)
    end
end.
(*************************************)


Definition evm_eq_block_chkr'' (opt: optimization) (opt_p p: block) (height: nat) 
  : bool :=
match symbolic_exec opt_p height opmap with
| None => false
| Some sfs1 => 
    match symbolic_exec p height opmap with 
    | None => false
    | Some sfs2 => let (sfs3, _) := opt sfs2 in 
                   let (sfs4, _) := opt sfs1 in
                   eq_sstate_chkr sfs4 sfs3 opmap
    end
end.


Lemma equiv_checker'_correct: forall (opt_p p: block) (height: nat) 
  (opt: optimization) (in_es: execution_state) 
  (in_stk: tstack),
safe_optimization opt ->
evm_eq_block_chkr' opt opt_p p height = true ->
get_stack_es in_es = in_stk ->
length in_stk = height ->
exists (out_es_opt out_es_p: execution_state),
(concr_interpreter opt_p in_es opmap = Some out_es_opt /\
 concr_interpreter p in_es opmap = Some out_es_p /\
 get_stack_es out_es_opt = get_stack_es out_es_p).
Proof.
intros.
unfold evm_eq_block_chkr' in H0.
destruct (symbolic_exec p height opmap) as [sfs_p|] eqn: eq_symb_exec_p;
  try (destruct (symbolic_exec opt_p height opmap); discriminate). 
destruct (symbolic_exec opt_p height opmap) as [sfsopt_p|] eqn: eq_symb_exec_opt;
  try discriminate.
pose proof (correctness_symb_exec opt_p in_stk opmap height in_es sfsopt_p H1
  H2 eq_symb_exec_opt evm_stack_opm_validity) 
  as [out_es1 [Hconcr_p1 eq_eval_sfs_opt]].
pose proof (correctness_symb_exec p in_stk opmap height in_es sfs_p H1
  H2 eq_symb_exec_p evm_stack_opm_validity) 
  as [out_es2 [Hconcr_p2 eq_eval_sfs_p]].  
exists out_es1. exists out_es2.
split; try assumption. split; try assumption.
destruct (opt sfs_p) as [p_with_opt flag] eqn: eq_optimize_p.
pose proof (asfs_eq_correctness sfsopt_p p_with_opt opmap H0 
  evm_stack_opm_validity in_stk).
unfold safe_optimization in H.
apply symb_exec_valid_asfs in eq_symb_exec_p as Hdecr_sfs_p.
pose proof (H in_stk (get_stack_es out_es2) sfs_p p_with_opt flag
  eq_eval_sfs_p eq_optimize_p Hdecr_sfs_p) as [eq_eval_p_with_opt _].
rewrite -> eq_eval_p_with_opt in H3.
rewrite -> eq_eval_sfs_opt in H3.
injection H3. trivial.
Qed.


Theorem evm_eq_block_chkr'_snd: forall (opt: optimization), 
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
  (opt: optimization) (in_es: execution_state) 
  (in_stk: tstack),
safe_optimization opt ->
evm_eq_block_chkr'' opt opt_p p height = true ->
get_stack_es in_es = in_stk ->
length in_stk = height ->
exists (out_es_opt out_es_p: execution_state),
(concr_interpreter opt_p in_es opmap = Some out_es_opt /\
 concr_interpreter p in_es opmap = Some out_es_p /\
 get_stack_es out_es_opt = get_stack_es out_es_p).
Proof.
intros.
unfold evm_eq_block_chkr'' in H0.
destruct (symbolic_exec p height opmap) as [sfs_p|] eqn: eq_symb_exec_p;
  try (destruct (symbolic_exec opt_p height opmap); discriminate). 
destruct (symbolic_exec opt_p height opmap) as [sfsopt_p|] eqn: eq_symb_exec_opt;
  try discriminate.
pose proof (correctness_symb_exec opt_p in_stk opmap height in_es sfsopt_p H1
  H2 eq_symb_exec_opt evm_stack_opm_validity) 
  as [out_es1 [Hconcr_p1 eq_eval_sfs_opt]].
pose proof (correctness_symb_exec p in_stk opmap height in_es sfs_p H1
  H2 eq_symb_exec_p evm_stack_opm_validity) 
  as [out_es2 [Hconcr_p2 eq_eval_sfs_p]].  
exists out_es1. exists out_es2.
split; try assumption. split; try assumption.
destruct (opt sfs_p) as [p_with_opt flag] eqn: eq_optimize_p.
destruct (opt sfsopt_p) as [opt_with_opt flagopt] eqn: eq_optimize_popt.
pose proof (asfs_eq_correctness opt_with_opt p_with_opt opmap H0 
  evm_stack_opm_validity in_stk) as H3.
unfold safe_optimization in H.
apply symb_exec_valid_asfs in eq_symb_exec_p as Hdecr_sfs_p.
apply symb_exec_valid_asfs in eq_symb_exec_opt as Hdecr_sfs_opt.
pose proof (H in_stk (get_stack_es out_es2) sfs_p p_with_opt flag
  eq_eval_sfs_p eq_optimize_p Hdecr_sfs_p) as [eq_eval_p_with_opt _].
pose proof (H in_stk (get_stack_es out_es1) sfsopt_p opt_with_opt flagopt
  eq_eval_sfs_opt eq_optimize_popt Hdecr_sfs_opt) as [eq_eval_opt _].
rewrite -> eq_eval_p_with_opt in H3.
rewrite -> eq_eval_opt in H3.
injection H3. trivial.
Qed.


Theorem evm_eq_block_chkr''_snd: forall (opt: optimization), 
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

Print Assumptions our_optimization_pipeline_is_safe.


End Checker.
Import Checker.

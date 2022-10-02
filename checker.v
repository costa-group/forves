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


Theorem equiv_checker'_correct: forall (opt_p p: block) (height: nat) 
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


End Checker.
Import Checker.

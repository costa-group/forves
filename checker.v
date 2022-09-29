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


Definition equiv_checker (opt_p p: block) (height: nat) (opt: optimization) 
  : bool :=
match symbolic_exec opt_p height opmap with
| None => false
| Some sfs1 => 
    match symbolic_exec p height opmap with 
    | None => false
    | Some sfs2 => let (sfs3, _) := opt sfs2 in 
                   asfs_eq sfs1 sfs3 opmap
    end
end.


Theorem equiv_checker_correct: forall (opt_p p: block) (height: nat) 
  (opt: optimization) (in_es: execution_state) 
  (in_stk: tstack),
safe_optimization opt ->
equiv_checker opt_p p height opt = true ->
get_stack_es in_es = in_stk ->
length in_stk = height ->
exists (out_es_opt out_es_p: execution_state),
(concr_interpreter opt_p in_es opmap = Some out_es_opt /\
 concr_interpreter p in_es opmap = Some out_es_p /\
 get_stack_es out_es_opt = get_stack_es out_es_p).
Proof.
intros.
unfold equiv_checker in H0.
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
pose proof (asfs_eq_correctness sfsopt_p p_with_opt opmap H0 in_stk).
unfold safe_optimization in H.
apply symb_exec_valid_asfs in eq_symb_exec_p as Hdecr_sfs_p.
pose proof (H in_stk (get_stack_es out_es2) sfs_p p_with_opt flag
  eq_eval_sfs_p eq_optimize_p Hdecr_sfs_p) as [eq_eval_p_with_opt _].
rewrite -> eq_eval_p_with_opt in H3.
rewrite -> eq_eval_sfs_opt in H3.
injection H3. trivial.
Qed.

End Checker.
Import Checker.

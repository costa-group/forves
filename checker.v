Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import List.
Require Import Coq_EVM.optimizations.
Import Optimizations.
Require Import Coq_EVM.datatypes.
Import EVM_Def Concrete Abstract Optimizations.
Require Import Coq_EVM.interpreter.
Import Interpreter SFS.
Import ListNotations.

Module Checker.

Definition equiv_checker (p1 p2: prog) (height: nat) (opt: optimization) 
  : bool :=
match symbolic_exec p1 height opmap with
| None => false
| Some sfs1 => 
    match symbolic_exec p2 height opmap with 
    | None => false
    | Some sfs2 => let (sfs3, _) := opt sfs2 in 
                   asfs_eq sfs1 sfs3 opmap
    end
end.

Lemma symb_exec''_strictly_decreasing: forall (ins: instr) (a a': asfs) 
  (ops: opm),
strictly_decreasing_map_asfs a ->
symbolic_exec'' ins a ops = Some a' ->
strictly_decreasing_map_asfs a'.
Proof.
intros. destruct ins eqn: eq_ins.
- (*PUSH*)
  admit.
- (*POP*)
  admit.
- (*DUP*)
  admit.
- (*SWAP*)
  admit.
- (*Operation*)
  admit.
Admitted.

Lemma symb_exec'_strictly_decreasing: forall (p: prog) (a a': asfs) 
  (ops: opm),
strictly_decreasing_map_asfs a ->
symbolic_exec' p a ops = Some a' ->
strictly_decreasing_map_asfs a'.
Proof.
induction p as [| ins rp IH].
- intros. simpl in H0. injection H0 as eq_a_a'. 
  rewrite <- eq_a_a'. assumption.
- intros. simpl in H0. 
  destruct (symbolic_exec'' ins a ops) as [a''|] 
    eqn: eq_sym_exec''; try discriminate.
  apply symb_exec''_strictly_decreasing in eq_sym_exec''; try assumption.
  apply IH in H0; try assumption.
Qed.

Lemma decreasing_asfs_empty_asfs: forall (height: nat),
strictly_decreasing_map_asfs (empty_asfs height).
Proof.
intros. simpl. auto.
Qed.

Lemma symb_exec_strictly_decreasing: forall (p: prog) (height: nat) (ops: opm)
  (sfs: asfs),
symbolic_exec p height ops = Some sfs ->
strictly_decreasing_map_asfs sfs.
Proof.
intros.
unfold symbolic_exec in H.
apply symb_exec'_strictly_decreasing with (p:=p) (a:=empty_asfs height)
  (ops:=ops).
- apply decreasing_asfs_empty_asfs.
- assumption.
Qed.



Theorem equiv_checker_correct: forall (p1 p2: prog) (height: nat) 
  (opt: optimization) (in_es out_es1 out_es2: execution_state) 
  (in_stk: concrete_stack),
safe_optimization opt ->
equiv_checker p1 p2 height opt = true ->
get_stack_es in_es = in_stk ->
length in_stk = height ->
concr_interpreter p1 in_es opmap = Some out_es1 ->
concr_interpreter p2 in_es opmap = Some out_es2 ->
get_stack_es out_es1 = get_stack_es out_es2.
Proof.
intros.
unfold equiv_checker in H0.
destruct (symbolic_exec p1 height opmap) as [sfs1|] eqn: symb_exec_p1;
  try discriminate.
destruct (symbolic_exec p2 height opmap) as [sfs2|] eqn: symb_exec_p2;
  try discriminate.
destruct (opt sfs2) as [sfs3 flag] eqn: opt_sfs2.
destruct out_es1 as [out_stk1 mem1 storage1] eqn: eq_out_es1.
assert (get_stack_es out_es1 = out_stk1) as eq_get_stack_1;
  try (rewrite -> eq_out_es1; auto).
rewrite <- eq_out_es1 in H3.
destruct out_es2 as [out_stk2 mem2 storage2] eqn: eq_out_es2.
assert (get_stack_es out_es2 = out_stk2) as eq_get_stack_2;
  try (rewrite -> eq_out_es2; auto).
rewrite <- eq_out_es2 in H4.  
simpl.
pose proof (correctness_symb_exec p1 in_stk out_stk1 opmap height in_es
  out_es1 sfs1 H2 H1 H3 eq_get_stack_1 symb_exec_p1) as Heval_sfs1.
pose proof (correctness_symb_exec p2 in_stk out_stk2 opmap height in_es
  out_es2 sfs2 H2 H1 H4 eq_get_stack_2 symb_exec_p2) as Heval_sfs2.
pose proof (asfs_eq_correctness sfs1 sfs3 opmap in_stk H0) as eq_eval_sfs1_sfs3.
unfold safe_optimization in H.
apply symb_exec_strictly_decreasing in symb_exec_p2 as Hdecr_sfs2.
pose proof (H in_stk out_stk2 sfs2 sfs3 flag Heval_sfs2 opt_sfs2 Hdecr_sfs2)
 as [Heval_sfs3 _].
rewrite -> Heval_sfs1 in eq_eval_sfs1_sfs3.
rewrite -> Heval_sfs3 in eq_eval_sfs1_sfs3.
injection eq_eval_sfs1_sfs3. auto.
Qed.

End Checker.
Import Checker.

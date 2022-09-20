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


(** 
  JOSEBA:
  
    equiv_checker version where final execution stack are comapred.
*)


Fixpoint concrete_stack_eq (cs1 cs2: concrete_stack) : bool :=
  match cs1, cs2 with
  | [], [] => true
  | h1::cs1', h2::cs2' => (weqb h1 h2) && concrete_stack_eq cs1' cs2'
  | _, _ => false
  end.




Definition equiv_checker' (p1 p2: block) (es: execution_state) 
  (opt: optimization) : bool :=

  match concr_interpreter p1 es opmap with
  | None => false
  | Some es' =>
      let s  := get_stack_es es in
      let s1 := get_stack_es es' in
      let h  := length s in
      match symbolic_exec p2 h opmap with
      | None => false
      | Some a =>
          let (a', _) := opt a in
          match eval_asfs s a' opmap with
          | None => false
          | Some s2 => concrete_stack_eq s1 s2
          end
      end
  end.

     


(* Tests *)
(* Symbolic Execution Tests *)

Example es_0 := ExState [] empty_nmap empty_nmap.

Example cs_0 : concrete_stack := [ 
  natToWord WLen 8;
  natToWord WLen 2;
  natToWord WLen 3
  ].

Example p_0 : block := [
  PUSH 1 (natToWord WLen 1) 
].

Example p_1 : block := [
  PUSH 1 (natToWord WLen 1); 
  PUSH 1 (natToWord WLen 0); 
  Opcode ADD
].

Example p_2 : block := [
  PUSH 1 (natToWord WLen 2) 
].

Example a_0 := match symbolic_exec p_0 0 opmap with None => empty_asfs 0 | Some a' => a' end.
Compute get_stack_asfs a_0.
Compute get_map_asfs a_0. 

Example a_1 := match symbolic_exec p_1 0 opmap with None => empty_asfs 0 | Some a' => a' end.
Compute get_stack_asfs a_1.
Compute get_map_asfs a_1. 

Example a_1' := fst (optimize_add_zero a_1).
Example b_1 := snd (optimize_add_zero a_1).
Compute b_1.
Compute get_stack_asfs a_1'.
Compute get_map_asfs a_1'. 

Example eq_0 := equiv_checker p_0 p_1 0 optimize_add_zero.
Compute eq_0.

Example eq_1 := equiv_checker p_1 p_1 0 optimize_add_zero.
Compute eq_1.

Example s_0 := get_stack_asfs a_0.
Example s_1 := get_stack_asfs a_1.
Example s_1' := get_stack_asfs a_1'.

Example m_0  := get_map_asfs a_0.
Example m_1  := get_map_asfs a_1.
Example m_1' := get_map_asfs a_1'.

Compute s_0.
Compute s_1.
Compute s_1'.

Compute m_0.
Compute m_1.
Compute m_1'.

Compute eval_asfs [] a_0 opmap.
Compute eval_asfs [] a_1 opmap.
Compute eval_asfs [] a_1' opmap.

Compute asfs_eq a_1 a_1' opmap.

Compute equiv_checker' p_0 p_2 es_0 optimize_add_zero.



Example p_3 : block := [
  PUSH 1 (natToWord WLen 1) 
].



Definition get_asfs (p1 p2: block) (h: nat): option (asfs*asfs) :=
  let a1:= symbolic_exec p1 h opmap in
  let a2:= symbolic_exec p2 h opmap in
  match a1, a2 with
  | Some a1', Some a2' => Some (a1', a2')
  | _, _ => None
  end.

Definition get_stacks (a1 a2: asfs): (asfs_stack*asfs_stack) :=
  let s1 := get_stack_asfs a1 in
  let s2 := get_stack_asfs a2 in
  (s1,s2).



Compute (
  let p1 := [
    PUSH 1 (natToWord WLen 1);
    PUSH 1 (natToWord WLen 0);
    Opcode ADD] in

  let p2 := [
    PUSH 1 (natToWord WLen 1)] in

  let a := get_asfs p1 p2 0 in
  match a with
  | Some (a1, a2) => get_stacks a1 a2
  | None => ([], [])
  end
  (* equiv_checker p1 p2 0 optimize_add_zero *)
  
).





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

Lemma symb_exec'_strictly_decreasing: forall (p: block) (a a': asfs) 
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

Lemma symb_exec_strictly_decreasing: forall (p: block) (height: nat) (ops: opm)
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



Theorem equiv_checker_correct: forall (p1 p2: block) (height: nat) 
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

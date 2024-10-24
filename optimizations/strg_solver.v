Require Import bbv.Word.
Require Import Nat.
Require Import Coq.NArith.NArith.

Require Import Coq.Logic.FunctionalExtensionality.

Require Import FORVES.constants.
Import Constants.

Require Import FORVES.symbolic_state.
Import SymbolicState.

Require Import FORVES.symbolic_state_eval.
Import SymbolicStateEval.

Require Import FORVES.symbolic_state_cmp.
Import SymbolicStateCmp.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.execution_state.
Import ExecutionState.

Require Import FORVES.stack_operation_instructions.
Import StackOpInstrs.

Require Import FORVES.program.
Import Program.

Require Import FORVES.symbolic_state_cmp_impl.
Import SymbolicStateCmpImpl.

Require Import FORVES.symbolic_state_eval_facts.
Import SymbolicStateEvalFacts.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.misc.
Import Misc.

Require Import FORVES.eval_common.
Import EvalCommon.

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import FORVES.optimizations_def.
Import Optimizations_Def.

Require Import FORVES.optimizations_common.
Import Optimizations_Common.

Require Import FORVES.storage_ops_solvers.
Import StorageOpsSolvers.

Require Import FORVES.storage_ops_solvers_impl.
Import StorageOpsSolversImpl.

Require Import FORVES.storage_ops_solvers_impl_soundness.
Import StorageOpsSolversImplSoundness.

Require Import List.
Import ListNotations.


Module Opt_strg_solver.

Definition strg_solver_applied (val1 val2: smap_value) : bool :=
(* If sload_solver does not return SymSLOAD or the symbolic storages have 
   different lengths, then optimized *)
match val1, val2 with
| SymSLOAD skey sstrg, SymSLOAD skey' sstrg' => negb (length sstrg =? length sstrg')
| _, _ => true
end.

(* Storage solver 
  SymSLOAD skey sstrg --> smapv
     if basic_sload_solver (SymSLOAD skey sstrg) = smapv
*)
Definition optimize_strg_solver_sbinding : opt_smap_value_type :=
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymSLOAD skey sstrg => 
     let val' := (basic_sload_solver (fun _:nat => fcmp) skey sstrg instk_height 
                   (SymMap maxid sb) ops) in
     let flag := strg_solver_applied val val' in
     (val', flag)
| _ => (val, false)
end.
(* TODO:
- CHECK if is better to pass the whole smap ==> adapt 60 files
- CHECK if maxid is correctly computed
- CHECK if (fun _:nat => fcmp) is an appropiate value of sstack_val_cmp_ext_1_t
    (fcmp is already instantiated with the right maxid, so the lambda receives a
     dummy maxid and discards it)
*)


Lemma optimize_strg_solver_sbinding_smapv_valid:
opt_smapv_valid_snd optimize_strg_solver_sbinding.
Proof.
unfold opt_smapv_valid_snd.
intros instk_height n fcmp sb val val' flag.
intros Hsafe_sstack_val_cmp Hvalid_smapv_val Hvalid_sb Hoptm_sbinding.
unfold optimize_strg_solver_sbinding in Hoptm_sbinding.
destruct (val) as [basicv|pushtagv|label args|offset smem|skey sstrg|
  offset size smem] eqn: eq_val; try (
    injection Hoptm_sbinding as eq_val' _;
    rewrite <- eq_val';
    assumption).
(* SymSLOAD skey sstrg *)
pose proof (basic_sload_solver_snd (fun _ : nat => fcmp)
    (safe_fcm_ext_1 fcmp Hsafe_sstack_val_cmp)).
unfold sload_solver_snd in H.
destruct H as [Hsolver_valid _].
unfold sload_solver_valid_res in Hsolver_valid.
specialize Hsolver_valid with (m:=SymMap n sb)(sstrg:=sstrg)(skey:=skey)
  (instk_height:=instk_height)(smv:=val')(ops:=evm_stack_opm).
simpl in Hsolver_valid.
unfold valid_smap_value in Hvalid_smapv_val.
destruct Hvalid_smapv_val as [Hvalid_sstack_val Hvalid_sstorage].
injection Hoptm_sbinding as eq_basic_mload_solver _.
pose proof (Hsolver_valid Hvalid_sstorage Hvalid_sstack_val 
  eq_basic_mload_solver).
assumption.
Qed.


Lemma optimize_strg_solver_sbinding_snd:
opt_sbinding_snd optimize_strg_solver_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_sbinding.
split.
- (* valid_sbindings *)
  apply valid_bindings_snd_opt with (val:=val)(opt:=optimize_strg_solver_sbinding)
    (fcmp:=fcmp)(flag:=flag); try assumption.
  apply optimize_strg_solver_sbinding_smapv_valid. 

- (* evaluation is preserved *) 
  intros stk mem strg exts v Hlen Heval_orig.
  unfold optimize_strg_solver_sbinding in Hoptm_sbinding.
  destruct val as [vv|vv|label args|offset smem|skey sstrg|offset size smem]
    eqn: eq_val; try inject_rw Hoptm_sbinding eq_val'.
  (* SymSLOAD skey sstrg *)
  injection Hoptm_sbinding as eq_basic_solver eq_flag.
  pose proof (basic_sload_solver_snd (fun _ : nat => fcmp)
      (safe_fcm_ext_1 fcmp Hsafe_sstack_val_cmp)).
  unfold sload_solver_snd in H.
  destruct H as [Hsolver_valid Hsolver_correct].
  unfold sload_solver_correct_res in Hsolver_correct.
  specialize Hsolver_correct with (m := SymMap idx sb)(sstrg:=sstrg)
    (skey:=skey)(instk_height:=instk_height)(smv:=val')
    (ops:=evm_stack_opm)(idx1:=idx)(m1:=SymMap maxidx
    ((idx,val')::sb)).
  unfold valid_bindings in Hvalid.
  destruct Hvalid as [eq_maxidx_idx [eq_valid_smapv eq_valid_bindings]].
  fold valid_bindings in eq_valid_bindings.
  unfold valid_smap in Hsolver_correct.
  simpl in Hsolver_correct.

  pose proof (Hsolver_correct eq_valid_bindings) as Hsolver_correct.
  unfold valid_smap_value in eq_valid_smapv.
  destruct eq_valid_smapv as [eq_valid_offset eq_valid_smem].
  rewrite -> eq_maxidx_idx in Hsolver_correct.
  pose proof (Hsolver_correct eq_valid_smem eq_valid_offset eq_basic_solver) 
    as Hsolver_correct.
  assert ((idx, SymMap (S idx) ((idx, val') :: sb)) =
          (idx, SymMap (S idx) ((idx, val') :: sb))) as eq_smaps; 
      try reflexivity.
  pose proof (Hsolver_correct eq_smaps) as Hsolver_correct.
  destruct Hsolver_correct as [idx2 [m2 [eq_m2 HH]]].
  injection eq_m2 as eq_idx2 eq_m2.
  specialize HH with (stk:= stk)(mem:=mem)(strg:=strg)(exts:=exts).
  symmetry in Hlen.
  pose proof (HH Hlen) as HH.
  destruct HH as [vv [Heval1 Heval2]].
  rewrite <- eq_idx2 in Heval2.
  rewrite <- eq_m2 in Heval2.
  simpl in Heval2.
  rewrite <- eq_maxidx_idx in Heval2.
  rewrite -> Heval_orig in Heval2.
  rewrite -> Heval2.
  rewrite -> eq_maxidx_idx.
  assumption.
Qed.


End Opt_strg_solver.

Require Import FORVES.program.
Import Program.

Require Import FORVES.stack_operation_instructions.
Import StackOpInstrs.

Require Import FORVES.execution_state.
Import ExecutionState.

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import FORVES.optimizations_def.
Import Optimizations_Def.

Require Import FORVES.symbolic_execution.
Import SymbolicExecution.

Require Import FORVES.storage_ops_solvers.
Import StorageOpsSolvers.

Require Import FORVES.storage_ops_solvers_impl.
Import StorageOpsSolversImpl.

Require Import FORVES.memory_ops_solvers.
Import MemoryOpsSolvers.

Require Import FORVES.memory_ops_solvers_impl.
Import MemoryOpsSolversImpl.

Require Import FORVES.symbolic_state_cmp.
Import SymbolicStateCmp.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.symbolic_execution_soundness.
Import SymbolicExecutionSoundness.

Require Import FORVES.symbolic_state_eval.
Import SymbolicStateEval.

Require Import FORVES.symbolic_state.
Import Optimizations_Def.

Require Import FORVES.optimizations_def.
Import SymbolicState.

Require Import List.
Import ListNotations.

Module Checker.


Definition checker_type := block -> block -> nat -> bool.


Definition sem_eq_blocks (p1 p2: block) (k: nat) (ops: stack_op_instr_map) : Prop :=
forall (in_st: state) (in_stk: stack),
get_stack_st in_st = in_stk ->
length in_stk = k ->
exists (out_st : state),
evm_exec_block_c p1 in_st ops = Some out_st /\
evm_exec_block_c p2 in_st ops = Some out_st.


Definition eq_block_chkr_snd (chkr : checker_type) : Prop :=
forall (p1 p2: block) (k: nat),
chkr p1 p2 k = true -> sem_eq_blocks p1 p2 k evm_stack_opm.


Definition evm_eq_block_chkr'' (smem_updater: smemory_updater_type) 
  (sstrg_updater: sstorage_updater_type) (mload_solver: mload_solver_type) 
  (sload_solver: sload_solver_type) (fcmp: symbolic_state_cmp)
  (opt: optim) (opt_p p: block) (k: nat) 
  : bool :=
match evm_sym_exec smem_updater sstrg_updater mload_solver sload_solver 
      opt_p k evm_stack_opm with
| None => false
| Some sst_opt => 
    match evm_sym_exec smem_updater sstrg_updater mload_solver sload_solver 
            p k evm_stack_opm with 
    | None => false
    | Some sst_p => let (sst_opt', _) := opt sst_opt in 
                    let (sst_p',   _) := opt sst_p in
                    fcmp sst_p' sst_opt' evm_stack_opm
    end
end.


(****************************)
(* TODO: move to other file *)

Lemma empty_sstate_len: forall instk_height,
let sst := gen_empty_sstate instk_height in
get_instk_height_sst sst = instk_height.
Proof.
intuition.
Qed.


Lemma evm_sym_exec_instr_sst_height_preserv: forall smemory_updater 
  sstorage_updater mload_solver sload_solver instr ops sst sst',
evm_exec_instr_s smemory_updater sstorage_updater mload_solver sload_solver 
  instr sst ops = Some sst' ->
get_instk_height_sst sst = get_instk_height_sst sst'.
Proof.
intros smemory_updater sstorage_updater mload_solver sload_solver instr ops sst
  sst' Hsymb_exec_instr.
destruct sst as [instk_height sstk smem sstg sctx sm] eqn: eq_sst.
destruct instr eqn: eq_instr.
- simpl in Hsymb_exec_instr.
  unfold push_s in Hsymb_exec_instr.
  destruct (misc.Misc.push (Val (Word.NToWord constants.Constants.EVMWordSize v))
   (get_stack_sst (SymExState instk_height sstk smem sstg sctx sm)));
   try discriminate.
  simpl in Hsymb_exec_instr. injection Hsymb_exec_instr as eq_sst'.
  rewrite <- eq_sst'. simpl. reflexivity.
- simpl in Hsymb_exec_instr.
  unfold pushtag_s in Hsymb_exec_instr.
  destruct (add_to_smap (get_smap_sst (SymExState instk_height sstk smem sstg 
    sctx sm)) (SymPUSHTAG v)).
  destruct (misc.Misc.push (FreshVar n) (get_stack_sst (SymExState instk_height
    sstk smem sstg sctx sm))); try discriminate.
  injection Hsymb_exec_instr as eq_sst'. rewrite <- eq_sst'. simpl. reflexivity.
- 
  (*

  | POP => pop_s sst ops
  | DUP pos => dup_s pos sst ops
  | SWAP pos => swap_s pos sst ops
  | MLOAD => mload_s mload_solver sst ops
  | MSTORE8 => mstore8_s smem_updater sst ops
  | MSTORE => mstore_s smem_updater sst ops
  | SLOAD => sload_s sload_solver sst ops
  | SSTORE => sstore_s sstrg_updater sst ops
  | SHA3 => sha3_s sst ops
  | KECCAK256 => sha3_s sst ops
  | OpInstr label => exec_stack_op_intsr_s label sst ops 
  *)
Admitted.

Lemma evm_sym_exec_block_sst_height_preserv: forall smemory_updater 
  sstorage_updater mload_solver sload_solver p ops sst sst',
evm_exec_block_s smemory_updater sstorage_updater mload_solver sload_solver p
  sst ops = Some sst' ->
get_instk_height_sst sst = get_instk_height_sst sst'.
Proof.
intros smemory_updater sstorage_updater mload_solver sload_solver p.
revert smemory_updater sstorage_updater mload_solver sload_solver.
induction p as [|instr rp IH].
- intros smemory_updater sstorage_updater mload_solver sload_solver ops sst 
    sst' Hsymb_exec_block.
  simpl in Hsymb_exec_block.
  injection Hsymb_exec_block as eq_sst'. rewrite <- eq_sst'.
  reflexivity.
- intros smemory_updater sstorage_updater mload_solver sload_solver ops sst 
    sst' Hsymb_exec_block.
  simpl in Hsymb_exec_block.
  destruct (evm_exec_instr_s smemory_updater sstorage_updater mload_solver 
    sload_solver instr sst ops) as [sst1|] eqn: eq_exec_instr;
    try discriminate.
  apply IH in Hsymb_exec_block.
  apply evm_sym_exec_instr_sst_height_preserv in eq_exec_instr.
  rewrite <- eq_exec_instr in Hsymb_exec_block.
  assumption.
Qed.


Lemma evm_sym_exec_sst_height: forall smemory_updater sstorage_updater 
  mload_solver sload_solver p instk_height ops sst,
evm_sym_exec smemory_updater sstorage_updater mload_solver sload_solver p
    instk_height ops = Some sst ->
get_instk_height_sst sst = instk_height.
Proof.
intros smemory_updater sstorage_updater mload_solver sload_solver p 
  instk_height ops sst Hsymb_exec.
unfold evm_sym_exec in Hsymb_exec.
apply evm_sym_exec_block_sst_height_preserv in Hsymb_exec.
rewrite -> empty_sstate_len in Hsymb_exec.
symmetry.
assumption.
Qed.

(*************************)

Lemma add_to_smap_nofv: forall sm smv key sm',
add_to_smap sm smv = (key, sm') ->
bindings_no_freshvar (get_bindings_smap sm) ->
is_fresh_var_smv smv = None ->
bindings_no_freshvar (get_bindings_smap sm').
Proof.
intros sm smv key sm'.
intros Hadd_to_smap Hbindings_nofv His_fresh.
unfold add_to_smap in Hadd_to_smap.
destruct sm as [maxidx bindings].
injection Hadd_to_smap as _ eq_sm'.
simpl in Hbindings_nofv.
rewrite <- eq_sm'. simpl.
intuition.
Qed.



Definition mload_solver_nofv (solver: mload_solver_type) :=
forall soffset smem instk_height sm ops,
is_fresh_var_smv (solver soffset smem instk_height sm ops) = None.

Definition sload_solver_nofv (solver: sload_solver_type) :=
forall soffset smem instk_height sm ops,
is_fresh_var_smv (solver soffset smem instk_height sm ops) = None.



Lemma symbolic_exec_instr_bindings_nofv: forall instr smemory_updater 
  sstorage_updater mload_solver sload_solver sst ops sst',
evm_exec_instr_s smemory_updater sstorage_updater mload_solver sload_solver
instr sst ops = Some sst' ->
bindings_no_freshvar (get_bindings_smap (get_smap_sst sst)) ->
mload_solver_nofv mload_solver ->
sload_solver_nofv sload_solver ->
bindings_no_freshvar (get_bindings_smap (get_smap_sst sst')).
Proof.
intros instr smemory_updater sstorage_updater mload_solver sload_solver sst
  ops sst'.
intros Hsymb_exec Hbind_nofv_sst Hmsolver_nofv Hssolver_nofv.
destruct sst as [instk_height sstk smem sstg sctx sm] eqn: eq_sst.
destruct instr eqn: eq_instr.
- (* PUSH size v *)
  simpl in Hsymb_exec. unfold push_s in Hsymb_exec.
  destruct (misc.Misc.push
                 (Val (Word.NToWord constants.Constants.EVMWordSize v))
                 (get_stack_sst
                    (SymExState instk_height sstk smem sstg sctx sm)))
    as [sstk'|]; try discriminate.
  simpl in Hsymb_exec.
  injection Hsymb_exec as eq_sst'.
  rewrite <- eq_sst'. simpl. simpl in Hbind_nofv_sst.
  assumption.
- (* PUSHTAG v *)
  simpl in Hsymb_exec. unfold pushtag_s in Hsymb_exec.
  destruct (add_to_smap
                  (get_smap_sst
                     (SymExState instk_height sstk smem sstg sctx sm))
                  (SymPUSHTAG v)) eqn: eq_add_to_smap; try discriminate.
  destruct (misc.Misc.push (FreshVar n)
                 (get_stack_sst
                    (SymExState instk_height sstk smem sstg sctx sm)));
    try discriminate.
  simpl in Hsymb_exec.
  injection Hsymb_exec as eq_sst'.
  rewrite <- eq_sst'. simpl. simpl in Hbind_nofv_sst.
  apply add_to_smap_nofv with 
    (sm:=(get_smap_sst (SymExState instk_height sstk smem sstg sctx sm)))
    (smv:=SymPUSHTAG v)(key:=n); try assumption.
  intuition.
- (* POP *)
  simpl in Hsymb_exec. unfold pop_s in Hsymb_exec.
  destruct (misc.Misc.pop
                 (get_stack_sst
                    (SymExState instk_height sstk smem sstg sctx sm)))
    as [sstk'|]; try discriminate.
  simpl in Hsymb_exec.
  injection Hsymb_exec as eq_sst'.
  rewrite <- eq_sst'. simpl. simpl in Hbind_nofv_sst.
  assumption.
- (* DUP pos *)
  simpl in Hsymb_exec. unfold dup_s in Hsymb_exec.
  destruct (misc.Misc.dup pos
                 (get_stack_sst
                    (SymExState instk_height sstk smem sstg sctx sm)))
    as [sstk'|]; try discriminate.
  simpl in Hsymb_exec.
  injection Hsymb_exec as eq_sst'.
  rewrite <- eq_sst'. simpl. simpl in Hbind_nofv_sst.
  assumption.
- (* SWAP pos *)
  simpl in Hsymb_exec. unfold swap_s in Hsymb_exec.
  destruct (misc.Misc.swap pos
                 (get_stack_sst
                    (SymExState instk_height sstk smem sstg sctx sm)))
    as [sstk'|]; try discriminate.
  simpl in Hsymb_exec.
  injection Hsymb_exec as eq_sst'.
  rewrite <- eq_sst'. simpl. simpl in Hbind_nofv_sst.
  assumption.
- (* MLOAD *)
  simpl in Hsymb_exec. unfold mload_s in Hsymb_exec.
  destruct (get_stack_sst
                 (SymExState instk_height sstk smem sstg sctx sm));
    try discriminate.
  destruct (add_to_smap
                  (get_smap_sst
                     (SymExState instk_height sstk smem sstg sctx sm))
                  (mload_solver s
                     (get_memory_sst
                        (SymExState instk_height sstk smem sstg sctx sm))
                     (get_instk_height_sst
                        (SymExState instk_height sstk smem sstg sctx sm))
                     (get_smap_sst
                        (SymExState instk_height sstk smem sstg sctx sm))
                     ops)) eqn: eq_add_to_smap.
  simpl in Hsymb_exec.
  injection Hsymb_exec as eq_sst'.
  rewrite <- eq_sst'. simpl. simpl in Hbind_nofv_sst. 
  apply add_to_smap_nofv with 
    (sm:=(get_smap_sst (SymExState instk_height sstk smem sstg sctx sm)))
    (smv:=((mload_solver s
                      (get_memory_sst
                         (SymExState instk_height sstk smem sstg sctx sm))
                      (get_instk_height_sst
                         (SymExState instk_height sstk smem sstg sctx sm))
                      (get_smap_sst
                         (SymExState instk_height sstk smem sstg sctx sm))
                      ops)))(key:=n); try assumption.
  unfold mload_solver_nofv in Hmsolver_nofv.
  pose proof (Hmsolver_nofv s (get_memory_sst (SymExState instk_height sstk smem sstg sctx sm))
     (get_instk_height_sst (SymExState instk_height sstk smem sstg sctx sm))
     (get_smap_sst (SymExState instk_height sstk smem sstg sctx sm)) ops).
  assumption.
- (* MSTORE *)
  simpl in Hsymb_exec. unfold mstore_s in Hsymb_exec.
  destruct (get_stack_sst
                 (SymExState instk_height sstk smem sstg sctx sm)); 
    try discriminate.
  destruct s0; try discriminate.
  simpl in Hsymb_exec.
  injection Hsymb_exec as eq_sst'.
  rewrite <- eq_sst'. simpl. simpl in Hbind_nofv_sst.
  assumption.
- (* MSTORE8 *)
  simpl in Hsymb_exec. unfold mstore8_s in Hsymb_exec.
  destruct (get_stack_sst
                 (SymExState instk_height sstk smem sstg sctx sm)); 
    try discriminate.
  destruct s0; try discriminate.
  simpl in Hsymb_exec.
  injection Hsymb_exec as eq_sst'.
  rewrite <- eq_sst'. simpl. simpl in Hbind_nofv_sst.
  assumption.
- (* SLOAD *)
  simpl in Hsymb_exec. unfold sload_s in Hsymb_exec.
  destruct (get_stack_sst
                 (SymExState instk_height sstk smem sstg sctx sm));
    try discriminate.
  destruct (add_to_smap
                  (get_smap_sst
                     (SymExState instk_height sstk smem sstg sctx sm))
                  (sload_solver s
                     (get_storage_sst
                        (SymExState instk_height sstk smem sstg sctx sm))
                     (get_instk_height_sst
                        (SymExState instk_height sstk smem sstg sctx sm))
                     (get_smap_sst
                        (SymExState instk_height sstk smem sstg sctx sm))
                     ops)) eqn: eq_add_to_smap.
  simpl in Hsymb_exec.
  injection Hsymb_exec as eq_sst'.
  rewrite <- eq_sst'. simpl. simpl in Hbind_nofv_sst. 
  apply add_to_smap_nofv with 
    (sm:=(get_smap_sst (SymExState instk_height sstk smem sstg sctx sm)))
    (smv:=sload_solver s
                      (get_storage_sst
                         (SymExState instk_height sstk smem sstg sctx sm))
                      (get_instk_height_sst
                         (SymExState instk_height sstk smem sstg sctx sm))
                      (get_smap_sst
                         (SymExState instk_height sstk smem sstg sctx sm))
                      ops)(key:=n); try assumption.
  unfold sload_solver_nofv in Hssolver_nofv.
  pose proof (Hssolver_nofv s (get_storage_sst (SymExState instk_height sstk smem sstg sctx sm))
     (get_instk_height_sst (SymExState instk_height sstk smem sstg sctx sm))
     (get_smap_sst (SymExState instk_height sstk smem sstg sctx sm)) ops).
  assumption.
- (* SSTORE *)
  simpl in Hsymb_exec. unfold sstore_s in Hsymb_exec.
  destruct (get_stack_sst
                 (SymExState instk_height sstk smem sstg sctx sm)); 
    try discriminate.
  destruct s0; try discriminate.
  simpl in Hsymb_exec.
  injection Hsymb_exec as eq_sst'.
  rewrite <- eq_sst'. simpl. simpl in Hbind_nofv_sst.
  assumption.
- (* SHA3 *)
  simpl in Hsymb_exec. unfold sha3_s in Hsymb_exec.
  destruct (get_stack_sst
                 (SymExState instk_height sstk smem sstg sctx sm)); 
    try discriminate.
  destruct s0; try discriminate.
  destruct (add_to_smap
                  (get_smap_sst
                     (SymExState instk_height sstk smem sstg sctx sm))
                  (SymSHA3 s s0
                     (get_memory_sst
                        (SymExState instk_height sstk smem sstg sctx sm))))
    eqn: eq_add_to_smap.
  injection Hsymb_exec as eq_sst'.
  rewrite <- eq_sst'. simpl. simpl in Hbind_nofv_sst.
  apply add_to_smap_nofv with 
    (sm:=(get_smap_sst (SymExState instk_height sstk smem sstg sctx sm)))
    (smv:=(SymSHA3 s s0 (get_memory_sst (SymExState instk_height sstk smem 
      sstg sctx sm))))(key:=n); try assumption.
  intuition.
- (* KECCAK256 *)
  simpl in Hsymb_exec. unfold sha3_s in Hsymb_exec.
  destruct (get_stack_sst
                 (SymExState instk_height sstk smem sstg sctx sm)); 
    try discriminate.
  destruct s0; try discriminate.
  destruct (add_to_smap
                  (get_smap_sst
                     (SymExState instk_height sstk smem sstg sctx sm))
                  (SymSHA3 s s0
                     (get_memory_sst
                        (SymExState instk_height sstk smem sstg sctx sm))))
    eqn: eq_add_to_smap.
  injection Hsymb_exec as eq_sst'.
  rewrite <- eq_sst'. simpl. simpl in Hbind_nofv_sst.
  apply add_to_smap_nofv with 
    (sm:=(get_smap_sst (SymExState instk_height sstk smem sstg sctx sm)))
    (smv:=(SymSHA3 s s0 (get_memory_sst (SymExState instk_height sstk smem 
      sstg sctx sm))))(key:=n); try assumption.
  intuition.
- (* OpInstr label *)
  simpl in Hsymb_exec. unfold exec_stack_op_intsr_s in Hsymb_exec.
  destruct (ops label); try discriminate.
  destruct (misc.Misc.firstn_e n
                 (get_stack_sst
                    (SymExState instk_height sstk smem sstg sctx sm)));
    try discriminate.
  destruct (misc.Misc.skipn_e n
                 (get_stack_sst
                    (SymExState instk_height sstk smem sstg sctx sm)));
    try discriminate.
  destruct (add_to_smap
                  (get_smap_sst
                     (SymExState instk_height sstk smem sstg sctx sm))
                  (SymOp label l)) eqn: eq_add_to_smap.
  injection Hsymb_exec as eq_sst'.
  rewrite <- eq_sst'. simpl. simpl in Hbind_nofv_sst.
  apply add_to_smap_nofv with 
    (sm:=(get_smap_sst (SymExState instk_height sstk smem sstg sctx sm)))
    (smv:=SymOp label l)(key:=n0); try assumption.
  intuition.
Qed.


Lemma symbolic_exec_block_bindings_nofv: forall p smemory_updater 
  sstorage_updater mload_solver sload_solver sst ops sst',
evm_exec_block_s smemory_updater sstorage_updater mload_solver
               sload_solver p sst ops = Some sst' ->
bindings_no_freshvar (get_bindings_smap (get_smap_sst sst)) ->
mload_solver_nofv mload_solver ->
sload_solver_nofv sload_solver ->
bindings_no_freshvar (get_bindings_smap (get_smap_sst sst')).
Proof.
induction p as [| instr rp IH].
- intros smemory_updater sstorage_updater mload_solver sload_solver
    sst ops sst'.
  intros Hsymb_exec Hbind_nofv_sst Hmload_nofv Hsload_nofv.
  simpl in Hsymb_exec.
  injection Hsymb_exec as eq_sst.
  rewrite <- eq_sst.
  assumption.
- intros smemory_updater sstorage_updater mload_solver sload_solver
    sst ops sst'.
  intros Hsymb_exec Hbind_nofv_sst Hmload_nofv Hsload_nofv.
  simpl in Hsymb_exec.
  destruct (evm_exec_instr_s smemory_updater sstorage_updater
                 mload_solver sload_solver instr sst ops) 
    as [sst1|] eqn: eq_exec_instr; try discriminate.
  pose proof (symbolic_exec_instr_bindings_nofv instr smemory_updater 
    sstorage_updater mload_solver sload_solver sst ops sst1 eq_exec_instr
    Hbind_nofv_sst Hmload_nofv Hsload_nofv) as Hbind_nofv_sst1.
  pose proof (IH smemory_updater sstorage_updater mload_solver sload_solver
    sst1 ops sst' Hsymb_exec Hbind_nofv_sst1 Hmload_nofv Hsload_nofv).
  assumption.
Qed.


Lemma symbolic_exec_bindings_nofv: forall 
  (p: block)
  (smemory_updater : smemory_updater_type) 
  (sstorage_updater : sstorage_updater_type)
  (mload_solver : mload_solver_type) (sload_solver : sload_solver_type) 
  (instk_height h : nat) 
  sstk smem sstg sctx sm
  (ops : stack_op_instr_map),
evm_sym_exec smemory_updater sstorage_updater mload_solver sload_solver p 
  instk_height ops = Some (SymExState h sstk smem sstg sctx sm) -> 
mload_solver_nofv mload_solver ->
sload_solver_nofv sload_solver ->  
bindings_no_freshvar (get_bindings_smap sm).
Proof.
intros p smemory_updater sstorage_updater mload_solver sload_solver
    instk_height h sstk smem sstg sctx sm ops.
intros Hsymb_exec Hmload_nofv Hsload_nofv.
unfold evm_sym_exec in Hsymb_exec. 
assert (bindings_no_freshvar (get_bindings_smap (get_smap_sst 
  (gen_empty_sstate instk_height)))) as Hempty_no_fv.
- simpl. intuition.
- pose proof (symbolic_exec_block_bindings_nofv p smemory_updater
    sstorage_updater mload_solver sload_solver (gen_empty_sstate instk_height)
    ops (SymExState h sstk smem sstg sctx sm) Hsymb_exec Hempty_no_fv
    Hmload_nofv Hsload_nofv).
  simpl in H.
  assumption.
Qed.


Lemma symbolic_exec_valid_sstate_fv: 
forall (smemory_updater : smemory_updater_type) 
       (sstorage_updater : sstorage_updater_type)
       (mload_solver : mload_solver_type) (sload_solver : sload_solver_type) 
       (p : block) (instk_height : nat) (sst : sstate) 
       (ops : stack_op_instr_map),
smemory_updater_snd smemory_updater ->
sstorage_updater_snd sstorage_updater ->
mload_solver_snd mload_solver ->
sload_solver_snd sload_solver ->
evm_sym_exec smemory_updater sstorage_updater mload_solver sload_solver p 
  instk_height ops = Some sst ->
mload_solver_nofv mload_solver ->
sload_solver_nofv sload_solver ->  
valid_sstate_fv sst ops.
Proof.
intros smemory_updater sstorage_updater mload_solver sload_solver p 
  instk_height sst ops Hsmem_upd Hsstrg_upd Hmload Hsload Hsym_exec
  Hmload_nofv Hsload_nofv.
unfold valid_sstate_fv.
split.
- pose proof (symbolic_exec_snd smemory_updater sstorage_updater mload_solver
    sload_solver p instk_height sst ops Hsmem_upd Hsstrg_upd Hmload Hsload 
    Hsym_exec) as H.
  intuition.
- destruct sst as [h sstk smem sstg sctx smap] eqn: eq_sst. 
  simpl. 
  pose proof (symbolic_exec_bindings_nofv p smemory_updater sstorage_updater 
    mload_solver sload_solver instk_height h sstk smem sstg sctx smap ops
    Hsym_exec Hmload_nofv Hsload_nofv).
  assumption.
Qed.


Lemma equiv_checker''_correct: forall (opt_p p: block) 
  (smem_updater: smemory_updater_type) (sstrg_updater: sstorage_updater_type) 
  (mload_solver: mload_solver_type) (sload_solver: sload_solver_type)
  (fcmp: symbolic_state_cmp)
  (height: nat) (opt: optim) (in_es: state) (in_stk: stack),
optim_snd opt ->
smemory_updater_snd smem_updater ->
sstorage_updater_snd sstrg_updater ->
mload_solver_snd mload_solver ->
sload_solver_snd sload_solver ->
mload_solver_nofv mload_solver ->
sload_solver_nofv sload_solver ->
symbolic_state_cmp_snd fcmp ->
evm_eq_block_chkr'' smem_updater sstrg_updater mload_solver 
  sload_solver fcmp opt opt_p p height = true ->
get_stack_st in_es = in_stk ->
length in_stk = height ->
exists (out_es_opt out_es_p: state),
(evm_exec_block_c opt_p in_es evm_stack_opm = Some out_es_opt /\
 evm_exec_block_c p in_es evm_stack_opm = Some out_es_p /\
 get_stack_st out_es_opt = get_stack_st out_es_p /\
 get_memory_st out_es_opt = get_memory_st out_es_p /\
 get_storage_st out_es_opt = get_storage_st out_es_p /\ 
 get_context_st out_es_opt = get_context_st out_es_p) (*trivial, ctx doesn't change*).
Proof.
intros opt_p p smem_updater sstrg_updater mload_solver sload_solver fcmp
  height opt in_es in_stk Hopt_snd Hsmemory_upd Hstrg_upd Hmload_solver 
  Hsload_solver Hmload_nofv Hsload_nofv Hcmp
  Hchkr_true Hget_stk Hlen_stk.
unfold evm_eq_block_chkr'' in Hchkr_true.
destruct (evm_sym_exec smem_updater sstrg_updater mload_solver
          sload_solver opt_p height evm_stack_opm) 
            as [sst_opt|] eqn: eq_symb_exec_opt; try discriminate.
destruct (evm_sym_exec smem_updater sstrg_updater mload_solver
          sload_solver p height evm_stack_opm) 
            as [sst_p|] eqn: eq_symb_exec_p; try discriminate.

pose proof (symbolic_exec_snd smem_updater sstrg_updater mload_solver 
  sload_solver opt_p height sst_opt evm_stack_opm Hsmemory_upd Hstrg_upd 
  Hmload_solver Hsload_solver eq_symb_exec_opt) as [_ Hconcr_opt'].
pose proof (symbolic_exec_valid_sstate_fv smem_updater sstrg_updater mload_solver 
  sload_solver opt_p height sst_opt evm_stack_opm Hsmemory_upd Hstrg_upd 
  Hmload_solver Hsload_solver eq_symb_exec_opt Hmload_nofv Hsload_nofv) 
  as Hvalid_sst_opt.
  
rewrite <- Hget_stk in Hlen_stk.
pose proof (Hconcr_opt' in_es Hlen_stk) as [out_es_opt [Hconcr_opt Hinst_sst_opt]].

pose proof (symbolic_exec_snd smem_updater sstrg_updater mload_solver 
  sload_solver p height sst_p evm_stack_opm Hsmemory_upd Hstrg_upd 
  Hmload_solver Hsload_solver eq_symb_exec_p) as [_ Hconcr_p'].
pose proof (symbolic_exec_valid_sstate_fv smem_updater sstrg_updater mload_solver 
  sload_solver p height sst_p evm_stack_opm Hsmemory_upd Hstrg_upd 
  Hmload_solver Hsload_solver eq_symb_exec_p Hmload_nofv Hsload_nofv) 
  as Hvalid_sst.

pose proof (Hconcr_p' in_es Hlen_stk) as [out_es_p [Hconcr_p Hinst_sst]].
exists out_es_opt. exists out_es_p.
destruct (opt sst_p) as [sst_p' flag_p] eqn: eq_optimize_p.
destruct (opt sst_opt) as [sst_opt' flag_opt] eqn: eq_optimize_popt.
unfold st_is_instance_of_sst in Hinst_sst.
destruct Hinst_sst as [out_es_p' [Heval_sst_p Heq_out_es_p]].
apply eq_execution_states_ext in Heq_out_es_p.
rewrite <- Heq_out_es_p in Heval_sst_p.
unfold st_is_instance_of_sst in Hinst_sst_opt.
destruct Hinst_sst_opt as [out_es_opt' [Heval_sst_opt Heq_out_es_opt]].
apply eq_execution_states_ext in Heq_out_es_opt.
rewrite <- Heq_out_es_opt in Heval_sst_opt.
unfold optim_snd in Hopt_snd.
pose proof (Hopt_snd sst_p sst_p' flag_p Hvalid_sst eq_optimize_p) as 
  [Hvalid_sst_p' Hp].
destruct Hp as [Hinstk_height_sst_p Hp].
pose proof (Hp in_es out_es_p Heval_sst_p) as Hevalp.
pose proof (Hopt_snd sst_opt sst_opt' flag_opt Hvalid_sst_opt eq_optimize_popt)
  as [Hvalid_sst_opt' Hopt].
destruct Hopt as [Hinstk_height_sst_opt Hopt].
pose proof (Hopt in_es out_es_opt Heval_sst_opt) as Hevalopt.
unfold symbolic_state_cmp_snd in Hcmp.
apply evm_sym_exec_sst_height in eq_symb_exec_p as Hinstk_height.
rewrite <- Hinstk_height in Hlen_stk.
rewrite -> Hinstk_height_sst_p in Hlen_stk.
unfold valid_sstate_fv in Hvalid_sst_p'.
destruct Hvalid_sst_p' as [Hvalid_sst_p' _].
unfold valid_sstate_fv in Hvalid_sst_opt'.
destruct Hvalid_sst_opt' as [Hvalid_sst_opt' _].
pose proof (Hcmp sst_p' sst_opt' evm_stack_opm Hvalid_sst_p' Hvalid_sst_opt'
      Hchkr_true in_es Hlen_stk) as [st [Heq_eval_sst_p Heq_eval_sst_opt]].
rewrite -> Hevalopt in Heq_eval_sst_opt.
rewrite -> Hevalp in Heq_eval_sst_p.
injection Heq_eval_sst_p as eq_st_out_es_p.
injection Heq_eval_sst_opt as eq_st_out_es_opt.
rewrite <- eq_st_out_es_opt in eq_st_out_es_p.
rewrite <- eq_st_out_es_p.
rewrite <- eq_st_out_es_p in Hconcr_opt.
split; try split; try split; try split; try split; try intuition.
Qed.

Theorem evm_eq_block_chkr''_snd: forall (opt: optim) 
  (smem_updater: smemory_updater_type) (sstrg_updater: sstorage_updater_type) 
  (mload_solver: mload_solver_type) (sload_solver: sload_solver_type)
  (fcmp: symbolic_state_cmp), 
optim_snd opt -> 
smemory_updater_snd smem_updater ->
sstorage_updater_snd sstrg_updater ->
mload_solver_snd mload_solver ->
sload_solver_snd sload_solver ->
mload_solver_nofv mload_solver ->
sload_solver_nofv sload_solver ->
symbolic_state_cmp_snd fcmp ->
eq_block_chkr_snd (evm_eq_block_chkr'' smem_updater 
  sstrg_updater mload_solver sload_solver fcmp opt).
Proof.
intros opt smem_updater sstrg_updater mload_solver sload_solver fcmp Hopt_snd 
  Hsmemory_upd Hstrg_upd Hmload_solver Hsload_solver Hmload_nofv Hsload_nofv 
  Hcmp. 
unfold eq_block_chkr_snd. intros p1 p2 k Hchecker_true.
unfold sem_eq_blocks. intros in_st in_stk Hgetstk Hlenstk.
pose proof (equiv_checker''_correct p1 p2 smem_updater sstrg_updater 
  mload_solver sload_solver fcmp k opt in_st in_stk Hopt_snd
  Hsmemory_upd Hstrg_upd Hmload_solver Hsload_solver Hmload_nofv Hsload_nofv
  Hcmp
  Hchecker_true Hgetstk Hlenstk) 
  as [out_es_opt [out_es [Hconcr_p1 [Hconcr_p2 Heq_states]]]].
exists out_es.
destruct in_st as [stack mem storage ctx] eqn: eq_in_st.
destruct out_es as [stack_o mem_o storage_o ctx_o] eqn: eq_out_st.
destruct out_es_opt as [stack_op mem_op storage_op ctx_op] eqn: eq_out_opt.
simpl in Heq_states.
destruct Heq_states as [Heq_stk [Heq_mem [Heq_strg Heq_ctx]]].
rewrite -> Hconcr_p1. rewrite -> Hconcr_p2.
rewrite -> Heq_stk. rewrite -> Heq_mem. 
rewrite -> Heq_strg. rewrite -> Heq_ctx.
auto.
Qed.


End Checker.

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
Lemma evm_sym_exec_sst_height: forall smemory_updater sstorage_updater 
  mload_solver sload_solver p instk_height ops sst,
evm_sym_exec smemory_updater sstorage_updater mload_solver sload_solver p
    instk_height ops = Some sst ->
get_instk_height_sst sst = instk_height.
Proof.
intros smemory_updater sstorage_updater mload_solver sload_solver p 
  instk_height ops sst.
unfold evm_sym_exec.
(* Long but "simple" *)
Admitted.
(*************************)



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
  Hsload_solver Hcmp
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
  Hmload_solver Hsload_solver eq_symb_exec_opt) as [Hvalid_sst_opt Hconcr_opt'].
rewrite <- Hget_stk in Hlen_stk.
pose proof (Hconcr_opt' in_es Hlen_stk) as [out_es_opt [Hconcr_opt Hinst_sst_opt]].
pose proof (symbolic_exec_snd smem_updater sstrg_updater mload_solver 
  sload_solver p height sst_p evm_stack_opm Hsmemory_upd Hstrg_upd 
  Hmload_solver Hsload_solver eq_symb_exec_p) as [Hvalid_sst Hconcr_p']. 
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
symbolic_state_cmp_snd fcmp ->
eq_block_chkr_snd (evm_eq_block_chkr'' smem_updater 
  sstrg_updater mload_solver sload_solver fcmp opt).
Proof.
intros opt smem_updater sstrg_updater mload_solver sload_solver fcmp Hopt_snd 
  Hsmemory_upd Hstrg_upd Hmload_solver Hsload_solver Hcmp. 
unfold eq_block_chkr_snd. intros p1 p2 k Hchecker_true.
unfold sem_eq_blocks. intros in_st in_stk Hgetstk Hlenstk.
pose proof (equiv_checker''_correct p1 p2 smem_updater sstrg_updater 
  mload_solver sload_solver fcmp k opt in_st in_stk Hopt_snd
  Hsmemory_upd Hstrg_upd Hmload_solver Hsload_solver Hcmp
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

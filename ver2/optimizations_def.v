Require Import bbv.Word.
Require Import Nat. 
Require Import Coq.NArith.NArith.

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

Require Import List.
Import ListNotations.

Require Import symbolic_state_cmp_impl.
Import SymbolicStateCmpImpl.

Require Import symbolic_state_eval_facts.

Module Optimizations_Def.

Definition optim := sstate -> sstate*bool.

Definition optim_snd (opt: optim) : Prop := 
forall (sst: sstate) (sst': sstate) (b: bool),
valid_sstate sst evm_stack_opm ->
opt sst = (sst', b) ->
(valid_sstate sst' evm_stack_opm /\ 
 forall (st st': state), eval_sstate st sst  evm_stack_opm = Some st' ->
                         eval_sstate st sst' evm_stack_opm = Some st').

(* sb2 preserves all the successful evaluations of sstack_val in sb1 *)
Definition preserv_sbindings (sb1 sb2: sbindings) (maxidx: nat) 
  (ops: stack_op_instr_map) : 
Prop :=
forall (sv : sstack_val) (stk : stack) (mem: memory) (strg: storage) 
  (ctx: context) (v: EVMWord),
  eval_sstack_val sv stk mem strg ctx maxidx sb1 ops = Some v ->
  eval_sstack_val sv stk mem strg ctx maxidx sb2 ops = Some v.
  
(* sb2 preserves all the successful evaluations of sstack in sb1 *)  
Lemma preserv_sbindings_sstack: 
forall (sb1 sb2: sbindings) (maxidx: nat) (ops: stack_op_instr_map), 
preserv_sbindings sb1 sb2 maxidx ops -> 
  forall (sstk: sstack) (maxid: nat) (stk stk': stack) (mem: memory) 
    (strg: storage) (ctx: context),
  eval_sstack sstk maxid sb1 stk mem strg ctx ops = Some stk' ->
  eval_sstack sstk maxid sb2 stk mem strg ctx ops = Some stk'.
Proof.
Admitted.

Lemma preserv_sbindings_ext: forall (sb1 sb2: sbindings) 
  (maxidx: nat) (ops: stack_op_instr_map) (n: nat) (smapv: smap_value),
preserv_sbindings sb1 sb2 maxidx ops ->
preserv_sbindings ((n,smapv)::sb1) ((n,smapv)::sb2) maxidx ops.
Admitted.

(* sb2 preserves all the successful evaluations of smem in sb1 *)  
Lemma preserv_sbindings_smemory:
forall (sb1 sb2: sbindings) (maxidx: nat) (ops: stack_op_instr_map), 
preserv_sbindings sb1 sb2 maxidx ops -> 
  forall (smem: smemory) (stk: stack) (mem mem': memory) 
    (strg: storage) (ctx: context),
  eval_smemory smem maxidx sb1 stk mem strg ctx ops = Some mem' ->
  eval_smemory smem maxidx sb2 stk mem strg ctx ops = Some mem'.
Proof.
Admitted.

(* sb2 preserves all the successful evaluations of sstorage in sb1 *)  
Lemma preserv_sbindings_sstorage:
forall (sb1 sb2: sbindings) (maxidx: nat)
  (ops: stack_op_instr_map), 
preserv_sbindings sb1 sb2 maxidx ops -> 
  forall (stk: stack) (sstrg: sstorage) (mem: memory) (strg strg': storage) (ctx: context),
  eval_sstorage sstrg maxidx sb1 stk mem strg ctx ops = Some strg' ->
  eval_sstorage sstrg maxidx sb2 stk mem strg ctx ops = Some strg'.
Proof.
Admitted.


(* Changing a preseving sbinding in a sstate preserves successful evaluations *)
Lemma preserv_sbindings_sstate :
forall (sb1 sb2: sbindings) (maxidx: nat) 
  (ops: stack_op_instr_map), 
preserv_sbindings sb1 sb2 maxidx ops ->
  forall (st st': state) (instk_height: nat) (sstk: sstack) (smem: smemory) 
  (sstrg: sstorage) (sctx : scontext),
    eval_sstate st (SymExState instk_height sstk smem sstrg sctx 
      (SymMap maxidx sb1)) ops = Some st' -> 
    eval_sstate st (SymExState instk_height sstk smem sstrg sctx 
      (SymMap maxidx sb2)) ops = Some st'.
Proof.
intros sb1 sb2 maxidx ops Hpr_sbind st st' instk_height sstk smem sstrg sctx
 Heval_sstate_sb1.
unfold eval_sstate in Heval_sstate_sb1.
simpl in Heval_sstate_sb1.
unfold eval_sstate. simpl.
destruct (instk_height =? length (get_stack_st st)) eqn: eq_instk_height;
  try discriminate.
destruct (eval_sstack sstk maxidx sb1 (get_stack_st st) (get_memory_st st) 
  (get_storage_st st) (get_context_st st) ops) eqn: eq_eval_sstack; 
  try discriminate.
apply preserv_sbindings_sstack with (sb2:=sb2)(maxidx:=maxidx) in eq_eval_sstack; 
  try assumption.
rewrite -> eq_eval_sstack.
destruct (eval_smemory smem maxidx sb1 (get_stack_st st) (get_memory_st st)
  (get_storage_st st) (get_context_st st) ops) eqn: eq_eval_smemory;
  try discriminate.
apply preserv_sbindings_smemory with (sb2:=sb2) in eq_eval_smemory;
  try assumption.
rewrite -> eq_eval_smemory.
destruct (eval_sstorage sstrg maxidx sb1 (get_stack_st st) (get_memory_st st)
  (get_storage_st st) (get_context_st st) ops) eqn: eq_eval_sstorage;
  try discriminate.
apply preserv_sbindings_sstorage with (sb2:=sb2) in eq_eval_sstorage;
  try assumption.
rewrite -> eq_eval_sstorage.
intuition.
Qed.


(* Type of a function that optimizes a single smap_value *)
Definition opt_smap_value_type := smap_value -> sstack_val_cmp_t -> sbindings -> 
  nat -> nat -> stack_op_instr_map -> smap_value*bool.

 
(* 'opt' is sound if optimizing the head binding (idx,val) results in a list 
   of sbindings that preserves evaluations *)
Definition opt_sbinding_snd (opt: opt_smap_value_type) :=
forall (val val': smap_value) (fcmp: sstack_val_cmp_t) (sb: sbindings) 
  (maxidx: nat) (instk_height: nat) (ops: stack_op_instr_map) (flag: bool),
safe_sstack_val_cmp fcmp ->
opt val fcmp sb maxidx instk_height ops = (val', flag) ->
  forall idx stk mem strg ctx v,
  (*instk_height = length stk ->*)
  (*valid_sstack_value instk_height maxidx val ->*)
  (*valid_bindings instk_height maxidx ((idx,val)::sb) ops ->*)
  (
    (*valid_sstack_value instk_height maxidx val' /\*)
     eval_sstack_val (FreshVar idx) stk mem strg ctx maxidx ((idx,val)::sb) ops
       = Some v -> 
     eval_sstack_val (FreshVar idx) stk mem strg ctx maxidx ((idx,val')::sb) ops
       = Some v).
       
(* The flag is sound if when false then the original value is not changed *)
(* LESS USEFUL *)
(*
Definition opt_smap_value_flag_sound (fopt: opt_smap_value_type) :=
forall (val val': smap_value) (fcmp: sstack_val_cmp) 
  (sb: sbindings) (maxid: nat) (instk_height: nat) (ops: stack_op_instr_map),
fopt val fcmp sb maxid instk_height ops = (val', false) ->
val = val'.*)


(* Applies smap value optimization to the first suitable entry in sbindings *)
Fixpoint optimize_first_sbindings (opt_sbinding: opt_smap_value_type) 
  (fcmp: sstack_val_cmp_t) (sb: sbindings) (maxid instk_height: nat) 
  (ops: stack_op_instr_map): sbindings*bool :=
match sb with
| [] => (sb,false)
| (n,val)::rs => 
    match opt_sbinding val fcmp rs maxid instk_height ops with
    | (val', true) => ((n,val')::rs, true)
    | (val', false) => 
        match (optimize_first_sbindings opt_sbinding fcmp rs maxid instk_height ops) with 
        | (rs', flag) => ((n,val)::rs', flag)
        end
    end
end.


(* If opt is sound when optimizing the first entry in the bindings, then 
   the optimize_first_sbindings will preserve the bindings *)
Lemma opt_sbinding_preserves: 
forall (opt: opt_smap_value_type) (fcmp: sstack_val_cmp_t) (sb sb': sbindings) 
  (maxid instk_height: nat) (ops: stack_op_instr_map) (flag: bool),
safe_sstack_val_cmp fcmp ->
opt_sbinding_snd opt ->
optimize_first_sbindings opt fcmp sb maxid instk_height ops = (sb', flag) ->
preserv_sbindings sb sb' maxid ops.
Proof.
intros opt fcmp sb. revert opt fcmp.
induction sb as [|h rsb IH].
- intros opt fcmp sb' maxid instk_height ops flag Hfcmp_snd Hopt_sbinding_snd 
    Hoptimize_first_sbindings.
  simpl in Hoptimize_first_sbindings.
  injection Hoptimize_first_sbindings as eq_sb' _.
  rewrite <- eq_sb'.
  unfold preserv_sbindings. intuition.
- intros opt fcmp sb' maxid instk_height ops flag Hfcmp_snd Hopt_sbinding_snd 
    Hoptimize_first_sbindings.
  destruct h as [n smapv] eqn: eq_h.
  unfold optimize_first_sbindings in Hoptimize_first_sbindings.
  destruct (opt smapv fcmp rsb maxid instk_height ops) as [val' b] 
    eqn: eq_opt_val.
  destruct b eqn: eq_b.
  + (* Optimized first entry in sbindings *)
    injection Hoptimize_first_sbindings as eq_sb' eq_flag'.
    rewrite <- eq_sb'.
    unfold preserv_sbindings.
    intros sv stk mem strg ctx v Heval_sb.
    destruct sv as [val|var|fvar] eqn: eq_sv; try intuition.
    (* FreshVar fvar *)
    destruct (fvar =? n) eqn: eq_fvar_n.
    * rewrite -> PeanoNat.Nat.eqb_eq in eq_fvar_n.
      rewrite -> eq_fvar_n.
      rewrite -> eq_fvar_n in Heval_sb.
    unfold opt_sbinding_snd in Hopt_sbinding_snd.
    pose proof (Hopt_sbinding_snd smapv val' fcmp rsb maxid instk_height ops
      true Hfcmp_snd eq_opt_val n stk mem strg ctx v) as Hpres_fvar. 
    apply Hpres_fvar in Heval_sb.
    assumption.
    * rewrite -> eval_fvar_diff; try assumption.
      rewrite -> eval_fvar_diff in Heval_sb; try assumption.
  + (* Optimized the tail of the sbindings *)
    fold optimize_first_sbindings in Hoptimize_first_sbindings.
    destruct (optimize_first_sbindings opt fcmp rsb maxid instk_height ops) as
      [rs' flag'] eqn: eq_optimize_first_rs.
    injection Hoptimize_first_sbindings as eq_sb' eq_flag.
    rewrite <- eq_sb'.
    pose proof (IH opt fcmp rs' maxid instk_height ops flag' Hfcmp_snd
      Hopt_sbinding_snd eq_optimize_first_rs) as Hpreserv_rs.
    apply preserv_sbindings_ext.
    assumption.
Qed.



Definition optimize_first_sstate (opt: opt_smap_value_type) 
  (fcmp: sstack_val_cmp_t) (ops: stack_op_instr_map) (sst: sstate)
  : sstate*bool :=
match sst with 
| SymExState instk_height sstk smem sstg sctx (SymMap maxid bindings) =>
    match optimize_first_sbindings opt fcmp bindings maxid instk_height ops with
    | (bindings', flag) => 
        (SymExState instk_height sstk smem sstg sctx (SymMap maxid bindings'),
         flag)
    end
end.

Lemma optimize_first_sstate_valid: forall (opt: opt_smap_value_type) 
  (fcmp: sstack_val_cmp_t) (ops: stack_op_instr_map) (sst sst': sstate)
  (flag: bool),
valid_sstate sst ops ->  
optimize_first_sstate opt fcmp ops sst = (sst', flag) ->
valid_sstate sst' ops.
Proof.
(* optimize_first_sstate does not change maxidx or stack_height, and does not
   change any fresh variable in the bindings, only one smap_value *)
Admitted.





(* ADD(X,0) or ADD(0,X) = X *)
Definition optimize_add_0_sbinding : opt_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp ADD [arg1; arg2] => 
  if fcmp arg1 (Val WZero) maxid sb maxid sb instk_height ops then
    (SymBasicVal arg2, true)
  else if fcmp arg2 (Val WZero) maxid sb maxid sb instk_height ops then
    (SymBasicVal arg2, true)
  else
    (val, false)
| _ => (val, false)
end.

Lemma optimize_add_0_sbinding_snd:
opt_sbinding_snd optimize_add_0_sbinding.
Proof.
Admitted.

(* *)
Definition optimize_add_0 (fcmp: sstack_val_cmp_t) (sst: sstate):
  (sstate * bool) := 
optimize_first_sstate optimize_add_0_sbinding fcmp evm_stack_opm sst.
  
Theorem optimize_add_0_snd: forall (fcmp: sstack_val_cmp_t),
safe_sstack_val_cmp fcmp ->
optim_snd (optimize_add_0 fcmp).
Proof.
intros fcmp Hsafe_fcmp.
unfold optim_snd. intros sst sst' b Hvalid_sst Hoptim.
unfold optimize_add_0 in Hoptim.
split.
- apply optimize_first_sstate_valid with (opt:=optimize_add_0_sbinding)
    (fcmp:=fcmp)(sst:=sst)(flag:=b); try assumption.
- intros st st'.
  unfold optimize_first_sstate in Hoptim.
  destruct sst as [instk_height sstk smem sstg sctx smap].
  destruct smap as [maxid bindings].
  destruct (optimize_first_sbindings optimize_add_0_sbinding fcmp bindings
              maxid instk_height evm_stack_opm) 
    as [bindings' flag] eqn: eq_opt_first.
  injection Hoptim as eq_sst' eq_flag.
  rewrite <- eq_sst'.
  pose proof (opt_sbinding_preserves optimize_add_0_sbinding fcmp bindings
    bindings' maxid instk_height evm_stack_opm flag Hsafe_fcmp
    optimize_add_0_sbinding_snd eq_opt_first) as Hpreserves.
  pose proof (preserv_sbindings_sstate bindings bindings' maxid evm_stack_opm
    Hpreserves st st' instk_height sstk smem sstg sctx).
  intuition.
Qed.  


End Optimizations_Def.

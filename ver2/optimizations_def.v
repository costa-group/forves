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
Import SymbolicStateCmpImp.

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
Definition preserv_sbindings (sb1 sb2: sbindings) : Prop :=
forall (sv : sstack_val) (stk : stack) (mem: memory) (strg: storage) 
  (ctx: context) (maxidx: nat) (ops: stack_op_instr_map) (v: EVMWord),
  eval_sstack_val sv stk mem strg ctx maxidx sb1 ops = Some v ->
  eval_sstack_val sv stk mem strg ctx maxidx sb2 ops = Some v.
  
(* sb2 preserves all the successful evaluations of sstack in sb1 *)  
Lemma preserv_sbindings_sstack: 
forall (sb1 sb2: sbindings), preserv_sbindings sb1 sb2 -> 
  forall (sstk: sstack) (maxid: nat) (stk stk': stack) (mem: memory) 
    (strg: storage) (ctx: context) (ops: stack_op_instr_map),
  eval_sstack sstk maxid sb1 stk mem strg ctx ops = Some stk' ->
  eval_sstack sstk maxid sb2 stk mem strg ctx ops = Some stk'.
Proof.
Admitted.

(* sb2 preserves all the successful evaluations of smem in sb1 *)  
Lemma preserv_sbindings_smemory:
forall (sb1 sb2: sbindings), preserv_sbindings sb1 sb2 -> 
  forall (smem: smemory) (maxid: nat) (stk: stack) (mem mem': memory) 
    (strg: storage) (ctx: context) (ops: stack_op_instr_map),
  eval_smemory smem maxid sb1 stk mem strg ctx ops = Some mem' ->
  eval_smemory smem maxid sb2 stk mem strg ctx ops = Some mem'.
Proof.
Admitted.

(* sb2 preserves all the successful evaluations of sstorage in sb1 *)  
Lemma preserv_sbindings_sstorage:
forall (sb1 sb2: sbindings), preserv_sbindings sb1 sb2 -> 
  forall (sstrg: sstorage) (maxid: nat) (stk: stack) (mem: memory) 
    (strg strg': storage) (ctx: context) (ops: stack_op_instr_map),
  eval_sstorage sstrg maxid sb1 stk mem strg ctx ops = Some strg' ->
  eval_sstorage sstrg maxid sb2 stk mem strg ctx ops = Some strg'.
Proof.
Admitted.


(* Changing a preseving sbinding in a sstate preserves successful evaluations *)
Lemma preserv_sbindings_sstate :
forall (sb1 sb2: sbindings), preserv_sbindings sb1 sb2 ->
  forall (st st': state) (instk_height: nat) (sstk: sstack) (smem: smemory) 
  (sstrg: sstorage) (sctx : scontext) (ops: stack_op_instr_map) (maxid: nat),
    eval_sstate st (SymExState instk_height sstk smem sstrg sctx 
      (SymMap maxid sb1)) ops = Some st' -> 
    eval_sstate st (SymExState instk_height sstk smem sstrg sctx 
      (SymMap maxid sb2)) ops = Some st'.
Proof.
intros sb1 sb2 Hpr_sbind st st' instk_height sstk smem sstrg sctx ops maxid
 Heval_sstate_sb1.
unfold eval_sstate in Heval_sstate_sb1.
simpl in Heval_sstate_sb1.
unfold eval_sstate. simpl.
destruct (instk_height =? length (get_stack_st st)) eqn: eq_instk_height;
  try discriminate.
destruct (eval_sstack sstk maxid sb1 (get_stack_st st) (get_memory_st st) 
  (get_storage_st st) (get_context_st st) ops) eqn: eq_eval_sstack; 
  try discriminate.
apply preserv_sbindings_sstack with (sb2:=sb2) in eq_eval_sstack; 
  try assumption.
rewrite -> eq_eval_sstack.
destruct (eval_smemory smem maxid sb1 (get_stack_st st) (get_memory_st st)
  (get_storage_st st) (get_context_st st) ops) eqn: eq_eval_smemory;
  try discriminate.
apply preserv_sbindings_smemory with (sb2:=sb2) in eq_eval_smemory;
  try assumption.
rewrite -> eq_eval_smemory.
destruct (eval_sstorage sstrg maxid sb1 (get_stack_st st) (get_memory_st st)
  (get_storage_st st) (get_context_st st) ops) eqn: eq_eval_sstorage;
  try discriminate.
apply preserv_sbindings_sstorage with (sb2:=sb2) in eq_eval_sstorage;
  try assumption.
rewrite -> eq_eval_sstorage.
auto.
Qed.


(* Type of a function that optimizes a single smap_value *)
Definition opt_sbinding_type := sbinding -> sstack_val_cmp -> sbindings -> 
  nat -> nat -> stack_op_instr_map -> sbinding*bool.

 
(* 'opt' is sound if optimizing the head binding (idx,val) results in a list 
   of sbindings that preserves evaluations *)
Definition opt_sbinding_snd (opt: opt_sbinding_type) :=
forall (idx: nat) (val val': smap_value) (fcmp: sstack_val_cmp) (sb: sbindings) 
  (maxidx: nat) (instk_height: nat) (ops: stack_op_instr_map) (flag: bool),
sstack_val_cmp_snd fcmp ->
opt (idx,val) fcmp sb maxidx instk_height ops = ((idx,val'), flag) ->
  forall stk mem strg ctx v,
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
Fixpoint optimize_first_sbindings (opt_sbinding: opt_sbinding_type) 
  (fcmp: sstack_val_cmp) (sb: sbindings) (maxid instk_height: nat) 
  (ops: stack_op_instr_map): sbindings*bool :=
match sb with
| [] => (sb,false)
| (n,val)::rs => 
    match opt_sbinding (n,val) fcmp sb maxid instk_height ops with
    | (sbind, true) => (sbind::rs, true)
    | (sbind, false) => 
        match (optimize_first_sbindings opt_sbinding fcmp rs maxid instk_height ops) with 
        | (rs', flag) => (sbind::rs', flag)
        end
    end
end.

(* If opt is sound when optimizing the first entry in the bindings, then 
   the optimize_first_sbindings will preserve the bindings *)
Lemma opt_sbinding_preserves: 
forall (opt: opt_sbinding_type) (fcmp: sstack_val_cmp) (sb sb': sbindings) 
  (maxid instk_height: nat) (ops: stack_op_instr_map) (flag: bool),
opt_sbinding_snd opt ->
optimize_first_sbindings opt fcmp sb maxid instk_height ops = (sb', flag) ->
preserv_sbindings sb sb'.
Proof.
intros opt fcmp sb sb' maxid instk_height ops flag Hopt_sbinding_snd 
  Hoptimize_first_sbindings.
unfold preserv_sbindings. 
intros sv stk mem strg ctx maxid0 ops0 v Heval_sb.
destruct sv as [val|var|fvar] eqn: eq_sv.
- unfold eval_sstack_val in Heval_sb.
  unfold eval_sstack_val' in Heval_sb.
  destruct sb as [|h r] eqn: eq_sb.
  + simpl in Heval_sb.
    admit.
  + simpl in Heval_sb.
    admit.
- unfold eval_sstack_val in Heval_sb.
  unfold eval_sstack_val' in Heval_sb.
  destruct sb as [|h r] eqn: eq_sb.
  + simpl in Heval_sb.
    admit.
  + simpl in Heval_sb.
    admit.
- unfold eval_sstack_val in Heval_sb.
  unfold eval_sstack_val' in Heval_sb.
  destruct sb as [|h r] eqn: eq_sb.
  + simpl in Heval_sb. discriminate.
  + admit. (*simpl in Heval_sb. discriminate.*)
Admitted.


Definition optimize_first_sstate (opt: opt_sbinding_type) 
  (fcmp: sstack_val_cmp) (maxid instk_height: nat) 
  (ops: stack_op_instr_map) (sst: sstate): sstate*bool :=
match sst with 
| SymExState instk_height sstk smem sstg sctx (SymMap maxid bindings) =>
    match optimize_first_sbindings opt fcmp bindings maxid instk_height ops with
    | (bindings', flag) => 
        (SymExState instk_height sstk smem sstg sctx (SymMap maxid bindings'),
         flag)
    end
end.






(* ADD(X,0) or ADD(o,X) = X *)
Definition optimize_add_0_sbinding : opt_sbinding_type := 
fun (sbind: sbinding) =>
fun (fcmp: sstack_val_cmp) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match sbind with
| (idx, SymOp ADD [arg1; arg2]) => 
  if fcmp arg1 (Val WZero) maxid sb maxid sb instk_height ops then
    ((idx, SymBasicVal arg2), true)
  else if fcmp arg2 (Val WZero) maxid sb maxid sb instk_height ops then
    ((idx, SymBasicVal arg2), true)
  else
    (sbind, false)
| _ => (sbind, false)
end.

Lemma optimize_add_0_sbinding_snd:
opt_sbinding_snd optimize_add_0_sbinding.
Proof.
Admitted.

(* *)
Definition optimize_add_0 (fcmp: sstack_val_cmp) (sst: sstate) := 
let instk_height := get_instk_height_sst sst in
let maxid := get_maxidx_smap (get_smap_sst sst)
in optimize_first_sstate optimize_add_0_sbinding fcmp maxid instk_height
  evm_stack_opm.



(*
Lemma opt_add_0_flag_sound: 
opt_smap_value_flag_sound optimize_add_0_smap_value.
Proof.
unfold opt_smap_value_flag_sound.
intros val val' fcmp sb maxid instk_height ops Hopt.
unfold optimize_add_0_smap_value in Hopt.
destruct val eqn: HH; try (injection Hopt; auto).
destruct args as [| arg1 r1]; try (injection Hopt; auto).
destruct r1 as [| arg2 r2]; try (injection Hopt; auto).
destruct r2; try (injection Hopt; auto).
destruct (fcmp arg1 (Val WZero) maxid sb maxid sb instk_height ops); 
  try discriminate.
destruct (fcmp arg2 (Val WZero) maxid sb maxid sb instk_height ops);
  try discriminate.
injection Hopt. auto.
Qed.
*)


End Optimizations_Def.

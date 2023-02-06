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

Require Import FORVES.program.
Import Program.

Require Import List.
Import ListNotations.

Require Import symbolic_state_cmp_impl.
Import SymbolicStateCmpImpl.

Require Import symbolic_state_eval_facts.
Import SymbolicStateEvalFacts.

Module Optimizations_Def.

Search eval_sstack_val'.

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
  (maxidx: nat) (instk_height: nat) (flag: bool),
safe_sstack_val_cmp fcmp ->
opt val fcmp sb maxidx instk_height evm_stack_opm = (val', flag) ->
  forall idx stk mem strg ctx v,
  (*instk_height = length stk ->*)
  (*valid_sstack_value instk_height maxidx val ->*)
  (*valid_bindings instk_height maxidx ((idx,val)::sb) ops ->*)
  (
    (*valid_sstack_value instk_height maxidx val' /\*)
     eval_sstack_val (FreshVar idx) stk mem strg ctx maxidx ((idx,val)::sb) 
       evm_stack_opm = Some v -> 
     eval_sstack_val (FreshVar idx) stk mem strg ctx maxidx ((idx,val')::sb) 
       evm_stack_opm = Some v).
       
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
    : sbindings*bool :=
match sb with
| [] => (sb,false)
| (n,val)::rs => 
    match opt_sbinding val fcmp rs maxid instk_height evm_stack_opm with
    | (val', true) => ((n,val')::rs, true)
    | (val', false) => 
        match (optimize_first_sbindings opt_sbinding fcmp rs maxid 
            instk_height) with 
        | (rs', flag) => ((n,val)::rs', flag)
        end
    end
end.


(* If opt is sound when optimizing the first entry in the bindings, then 
   the optimize_first_sbindings will preserve the bindings *)
Lemma opt_sbinding_preserves: 
forall (opt: opt_smap_value_type) (fcmp: sstack_val_cmp_t) (sb sb': sbindings) 
  (maxid instk_height: nat) (flag: bool),
safe_sstack_val_cmp fcmp ->
opt_sbinding_snd opt ->
optimize_first_sbindings opt fcmp sb maxid instk_height = (sb', flag) ->
preserv_sbindings sb sb' maxid evm_stack_opm.
Proof.
intros opt fcmp sb. revert opt fcmp.
induction sb as [|h rsb IH].
- intros opt fcmp sb' maxid instk_height flag Hfcmp_snd Hopt_sbinding_snd 
    Hoptimize_first_sbindings.
  simpl in Hoptimize_first_sbindings.
  injection Hoptimize_first_sbindings as eq_sb' _.
  rewrite <- eq_sb'.
  unfold preserv_sbindings. intuition.
- intros opt fcmp sb' maxid instk_height flag Hfcmp_snd Hopt_sbinding_snd 
    Hoptimize_first_sbindings.
  destruct h as [n smapv] eqn: eq_h.
  unfold optimize_first_sbindings in Hoptimize_first_sbindings.
  destruct (opt smapv fcmp rsb maxid instk_height evm_stack_opm) as [val' b] 
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
    pose proof (Hopt_sbinding_snd smapv val' fcmp rsb maxid instk_height
      true Hfcmp_snd eq_opt_val n stk mem strg ctx v) as Hpres_fvar. 
    apply Hpres_fvar in Heval_sb.
    assumption.
    * rewrite -> eval_fvar_diff; try assumption.
      rewrite -> eval_fvar_diff in Heval_sb; try assumption.
  + (* Optimized the tail of the sbindings *)
    fold optimize_first_sbindings in Hoptimize_first_sbindings.
    destruct (optimize_first_sbindings opt fcmp rsb maxid instk_height) as
      [rs' flag'] eqn: eq_optimize_first_rs.
    injection Hoptimize_first_sbindings as eq_sb' eq_flag.
    rewrite <- eq_sb'.
    pose proof (IH opt fcmp rs' maxid instk_height flag' Hfcmp_snd
      Hopt_sbinding_snd eq_optimize_first_rs) as Hpreserv_rs.
    apply preserv_sbindings_ext.
    assumption.
Qed.



Definition optimize_first_sstate (opt: opt_smap_value_type) 
  (fcmp: sstack_val_cmp_t) (sst: sstate)
  : sstate*bool :=
match sst with 
| SymExState instk_height sstk smem sstg sctx (SymMap maxid bindings) =>
    match optimize_first_sbindings opt fcmp bindings maxid instk_height with
    | (bindings', flag) => 
        (SymExState instk_height sstk smem sstg sctx (SymMap maxid bindings'),
         flag)
    end
end.

Lemma optimize_first_sstate_valid: forall (opt: opt_smap_value_type) 
  (fcmp: sstack_val_cmp_t) (sst sst': sstate)
  (flag: bool),
valid_sstate sst evm_stack_opm ->  
optimize_first_sstate opt fcmp sst = (sst', flag) ->
valid_sstate sst' evm_stack_opm.
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
    (SymBasicVal arg1, true)
  else
    (val, false)
| _ => (val, false)
end.

(* Macro to reduce the next proof *)
Ltac inject_rw H eqname:= 
injection H as eqname _;
rewrite <- eqname;
assumption.



Lemma fake1: forall instk_height maxidx arg1,
valid_sstack_value instk_height maxidx arg1.
Admitted.
Lemma fake2: forall instk_height maxidx sb evm_stack_opm,
valid_bindings instk_height maxidx sb evm_stack_opm.
Admitted.
Lemma fake3: forall instk_height (stk: stack),
instk_height = length stk.
Admitted.


Lemma follow_in_smap_val: forall v maxidx sb,
follow_in_smap (Val v) maxidx sb = 
  Some (FollowSmapVal (SymBasicVal (Val v)) maxidx sb).
Proof.
intros v maxidx sb. 
destruct sb as [|h r]; try intuition.
Qed.

Lemma eval_sstack_val_const: forall v stk mem strg ctx maxidx sb ops,
eval_sstack_val (Val v) stk mem strg ctx maxidx sb ops = Some v.
Proof.
intros.
unfold eval_sstack_val.
unfold eval_sstack_val'.
rewrite -> follow_in_smap_val.
reflexivity.
Qed.

Compute (
let d := 3 in
let stk := empty_stack in
let mem := empty_memory in
let strg := empty_storage in 
let ctx := empty_context in
let maxidx := 0 in
let sb := [(3,SymOp ADD [Val WOne; FreshVar 2]);
           (2,SymOp ADD [Val WOne; FreshVar 1]);
           (1,SymBasicVal (Val WOne))
          ] in
let ops := evm_stack_opm in
eval_sstack_val' d (FreshVar 3) stk mem strg ctx maxidx sb ops).



Search eval_sstack_val'.
(* Remove: use eval_sstack_val'_preserved_when_depth_extended instead *)
Lemma eval_succesful_gt: forall d d' sval stk mem strg ctx idx sb ops v,
eval_sstack_val' d' sval stk mem strg ctx idx sb ops = Some v ->
d > d' ->
eval_sstack_val' d sval stk mem strg ctx idx sb ops = Some v.
Proof.
intros d d' sval stk mem strg ctx idx sb ips v Heval_d' Hd_gt.
destruct sval eqn: eq_sv.
- admit.
- admit.
Admitted.

Lemma  eval'_maxidx_indep: forall d sv stk mem strg ctx n m sb ops v,
eval_sstack_val' d sv stk mem strg ctx n sb ops = Some v ->
eval_sstack_val' d sv stk mem strg ctx m sb ops = Some v.
Proof.
Admitted.



Lemma evm_add_zero_l: forall ctx v,
evm_add ctx [WZero; v] = v.
Proof.
intros ctx v. simpl.
rewrite -> wplus_wzero_2.
reflexivity.
Qed.

Lemma evm_add_zero_r: forall ctx v,
evm_add ctx [v; WZero] = v.
Proof.
intros ctx v. simpl.
rewrite -> wplus_wzero_1.
reflexivity.
Qed.

Lemma eval_freshv_top: forall maxidx idx stk mem strg ctx arg2 sb ops,
eval_sstack_val' (S maxidx) (FreshVar idx) stk mem strg ctx maxidx
  ((idx, SymBasicVal arg2) :: sb) ops =
eval_sstack_val' maxidx arg2 stk mem strg ctx maxidx sb ops.
Proof.
Admitted.

Lemma optimize_add_0_sbinding_snd:
opt_sbinding_snd optimize_add_0_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height flag Hsafe_sstack_val_cmp
  Hoptm_add_0_sbinding idx stk mem strg ctx v Heval_orig.
unfold optimize_add_0_sbinding in Hoptm_add_0_sbinding.
destruct val as [vv|vv|label args|offset smem|key sstrg|offset seze smem]
  eqn: eq_val; try inject_rw Hoptm_add_0_sbinding eq_val'.
(* SymOp label args *)
destruct label; try inject_rw Hoptm_add_0_sbinding eq_val'.
destruct args as [|arg1 r1] eqn: eq_args; 
  try inject_rw Hoptm_add_0_sbinding eq_val'.
destruct r1 as [|arg2 r2] eqn: eq_r1; 
  try inject_rw Hoptm_add_0_sbinding eq_val'.
destruct r2 as [|arg3 r3] eqn: eq_r2; 
  try inject_rw Hoptm_add_0_sbinding eq_val'.
destruct (fcmp arg1 (Val WZero) maxidx sb maxidx sb instk_height) 
  eqn: fcmp_arg1_zero.
- (* arg1 ~ WZero *)
  injection Hoptm_add_0_sbinding as eq_val' _. 
  rewrite <- eq_val'.
  unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
  rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
  simpl in Heval_orig.
  destruct (eval_sstack_val' maxidx arg1 stk mem strg ctx idx sb evm_stack_opm)
    as [varg1|] eqn: eval_arg1; try discriminate.
  destruct (eval_sstack_val' maxidx arg2 stk mem strg ctx idx sb evm_stack_opm)
    as [varg2|] eqn: eval_arg2; try discriminate.
  unfold safe_sstack_val_cmp in Hsafe_sstack_val_cmp.
  (* fake lemmas for now, should be premises obtained somewhere *)
  pose proof (fake1 instk_height maxidx arg1) as cfake1.
  pose proof (fake1 instk_height maxidx (Val WZero)) as cfake2.
  pose proof (fake2 instk_height maxidx sb evm_stack_opm) as cfake3.
  pose proof (fake3 instk_height stk) as cfake4.
  (* *)
  pose proof (Hsafe_sstack_val_cmp arg1 (Val WZero) maxidx sb maxidx sb 
    instk_height evm_stack_opm cfake1 cfake2 cfake3 cfake3
    fcmp_arg1_zero stk mem strg ctx) as eq_eval_arg1.
  rewrite -> eval_sstack_val_const in eq_eval_arg1.
  unfold eval_sstack_val in eq_eval_arg1.
  pose proof (Gt.gt_Sn_n maxidx) as eq_gt_succ.
  pose proof (eval_sstack_val'_succ (S maxidx) instk_height arg1 stk mem
    strg ctx maxidx sb evm_stack_opm cfake4 cfake1 cfake3 eq_gt_succ) as
      [vv eq_eval'_arg1].
  pose proof (eval_succesful_gt (S maxidx) maxidx arg1 stk mem strg ctx idx
    sb evm_stack_opm varg1 eval_arg1 eq_gt_succ) as Heval'_arg1.
  apply eval'_maxidx_indep with (m:=maxidx) in Heval'_arg1.
  rewrite -> eq_eval'_arg1 in Heval'_arg1.
  rewrite -> eq_eval_arg1 in eq_eval'_arg1.
  injection eq_eval'_arg1 as eq_vv.
  injection Heval'_arg1 as eq_varg1.
  rewrite <- eq_vv in eq_varg1.
  rewrite <- eq_varg1 in Heval_orig.
  rewrite -> evm_add_zero_l in Heval_orig.
  injection Heval_orig as eq_v.
  rewrite <- eq_v.
  unfold eval_sstack_val.
  rewrite -> eval_freshv_top.
  rewrite -> eval'_maxidx_indep with (n:=idx)(v:=varg2); try intuition.
- destruct (fcmp arg2 (Val WZero) maxidx sb maxidx sb instk_height)
  eqn: fcmp_arg2_zero; try inject_rw Hoptm_add_0_sbinding eq_val'.
  (* arg2 ~ WZero *)
  injection Hoptm_add_0_sbinding as eq_val' _. 
  
  rewrite <- eq_val'.
  unfold eval_sstack_val in Heval_orig. simpl in Heval_orig.
  rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
  simpl in Heval_orig.
  destruct (eval_sstack_val' maxidx arg1 stk mem strg ctx idx sb evm_stack_opm)
    as [varg1|] eqn: eval_arg1; try discriminate.
  destruct (eval_sstack_val' maxidx arg2 stk mem strg ctx idx sb evm_stack_opm)
    as [varg2|] eqn: eval_arg2; try discriminate.
  unfold safe_sstack_val_cmp in Hsafe_sstack_val_cmp.
  (* fake lemmas for now, should be premises obtained somewhere *)
  pose proof (fake1 instk_height maxidx arg2) as cfake1.
  pose proof (fake1 instk_height maxidx (Val WZero)) as cfake2.
  pose proof (fake2 instk_height maxidx sb evm_stack_opm) as cfake3.
  pose proof (fake3 instk_height stk) as cfake4.
  (* *)
  pose proof (Hsafe_sstack_val_cmp arg2 (Val WZero) maxidx sb maxidx sb 
    instk_height evm_stack_opm cfake1 cfake2 cfake3 cfake3
    fcmp_arg2_zero stk mem strg ctx) as eq_eval_arg2.
  rewrite -> eval_sstack_val_const in eq_eval_arg2.
  unfold eval_sstack_val in eq_eval_arg2.
  pose proof (Gt.gt_Sn_n maxidx) as eq_gt_succ.
  pose proof (eval_sstack_val'_succ (S maxidx) instk_height arg2 stk mem
    strg ctx maxidx sb evm_stack_opm cfake4 cfake1 cfake3 eq_gt_succ) as
      [vv eq_eval'_arg2].
  pose proof (eval_succesful_gt (S maxidx) maxidx arg2 stk mem strg ctx idx
    sb evm_stack_opm varg2 eval_arg2 eq_gt_succ) as Heval'_arg2.
  apply eval'_maxidx_indep with (m:=maxidx) in Heval'_arg2.
  rewrite -> eq_eval'_arg2 in Heval'_arg2.
  rewrite -> eq_eval_arg2 in eq_eval'_arg2.
  injection eq_eval'_arg2 as eq_vv.
  injection Heval'_arg2 as eq_varg2.
  rewrite <- eq_vv in eq_varg2.
  rewrite <- eq_varg2 in Heval_orig.
  rewrite -> evm_add_zero_r in Heval_orig.
  injection Heval_orig as eq_v.
  rewrite <- eq_v.
  unfold eval_sstack_val.
  rewrite -> eval_freshv_top.
  rewrite -> eval'_maxidx_indep with (n:=idx)(v:=varg1); try intuition.
Qed.


(* *)
Definition optimize_add_0 (fcmp: sstack_val_cmp_t) (sst: sstate):
  (sstate * bool) := 
optimize_first_sstate optimize_add_0_sbinding fcmp sst.
  
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
              maxid instk_height) 
    as [bindings' flag] eqn: eq_opt_first.
  injection Hoptim as eq_sst' eq_flag.
  rewrite <- eq_sst'.
  pose proof (opt_sbinding_preserves optimize_add_0_sbinding fcmp bindings
    bindings' maxid instk_height flag Hsafe_fcmp
    optimize_add_0_sbinding_snd eq_opt_first) as Hpreserves.
  pose proof (preserv_sbindings_sstate bindings bindings' maxid evm_stack_opm
    Hpreserves st st' instk_height sstk smem sstg sctx).
  intuition.
Qed.  


End Optimizations_Def.

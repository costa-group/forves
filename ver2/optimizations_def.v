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

Require Import List.
Import ListNotations.


Module Optimizations_Def.

Search eval_sstack_val'.

Definition optim := sstate -> sstate*bool.

Definition optim_snd (opt: optim) : Prop := 
forall (sst: sstate) (sst': sstate) (b: bool),
valid_sstate sst evm_stack_opm ->
opt sst = (sst', b) ->
(valid_sstate sst' evm_stack_opm /\ 
 get_instk_height_sst sst = get_instk_height_sst sst' /\
 forall (st st': state), eval_sstate st sst  evm_stack_opm = Some st' ->
                         eval_sstate st sst' evm_stack_opm = Some st').
                         

Lemma optim_snd_same_height: forall sst sst' b opt,
valid_sstate sst evm_stack_opm ->
opt sst = (sst', b) ->
optim_snd opt ->
get_instk_height_sst sst = get_instk_height_sst sst'.
Proof.
intros sst sst' b opt Hvalid_sst Hopt Hopt_snd.
unfold optim_snd in Hopt_snd.
pose proof (Hopt_snd sst sst' b Hvalid_sst Hopt) as [_ Heval].
destruct sst. destruct sst'.
unfold eval_sstate in Heval.
simpl in Heval.
simpl.
Admitted.

                   


(* sb2 preserves all the successful evaluations of sstack_val in sb1 *)
Definition preserv_sbindings (sb1 sb2: sbindings) (maxidx: nat) 
  (ops: stack_op_instr_map) (instk_height: nat) : Prop :=
valid_bindings instk_height maxidx sb1 evm_stack_opm /\
valid_bindings instk_height maxidx sb2 evm_stack_opm /\
forall (sv : sstack_val) (stk : stack) (mem: memory) (strg: storage) 
  (ctx: context) (v: EVMWord),
  instk_height = length stk ->
  eval_sstack_val sv stk mem strg ctx maxidx sb1 ops = Some v ->
  eval_sstack_val sv stk mem strg ctx maxidx sb2 ops = Some v.


(* TODO: move to other file *)
Lemma eval_sstack_def: forall (sstk: sstack) (maxidx: nat) (sb: sbindings) 
  (stk: stack) (mem: memory) (strg: storage) (ctx: context) 
  (ops: stack_op_instr_map),
eval_sstack sstk maxidx sb stk mem strg ctx ops = 
map_option (fun sv => eval_sstack_val sv stk mem strg ctx maxidx sb ops) sstk.
Proof.
intuition.
Qed.


  
(* sb2 preserves all the successful evaluations of sstack in sb1 *)  
Lemma preserv_sbindings_sstack: 
forall (sb1 sb2: sbindings) (maxidx: nat) (ops: stack_op_instr_map) 
  (instk_height: nat), 
preserv_sbindings sb1 sb2 maxidx ops instk_height -> 
  forall (sstk: sstack) (stk stk': stack) (mem: memory) 
    (strg: storage) (ctx: context),
  instk_height = length stk ->
  eval_sstack sstk maxidx sb1 stk mem strg ctx ops = Some stk' ->
  eval_sstack sstk maxidx sb2 stk mem strg ctx ops = Some stk'.
Proof.
intros sb1 sb2 maxidx ops instk_height Hpreserv sstk.
revert sb1 sb2 maxidx ops instk_height Hpreserv.
induction sstk as [|sval r IH].
- intuition.
- intros sb1 sb2 maxid ops instk_height Hpreserv stk 
    stk' mem strg ctx Hlen Heval.
  unfold preserv_sbindings in Hpreserv.
  unfold eval_sstack in Heval.
  unfold map_option in Heval.
  destruct (eval_sstack_val sval stk mem strg ctx maxid sb1 ops) as
    [v|] eqn: eq_eval_sval; try discriminate.
  rewrite <- map_option_ho in Heval.
  assert (Hpreserv_copy := Hpreserv).
  destruct Hpreserv as [Hvalid_sb1 [Hvalid_sb2 Hpreserv]].
  pose proof (Hpreserv sval stk mem strg ctx v Hlen eq_eval_sval) 
    as Heval_sval_sb2.
  rewrite <- eval_sstack_def in Heval.
  destruct (eval_sstack r maxid sb1 stk mem strg ctx ops) as [rs_val|]
    eqn: eq_eval_rs; try discriminate.
  apply IH with (sb2:=sb2)(instk_height:=instk_height) in eq_eval_rs as 
    Heval_r_sb2; try assumption.
  unfold eval_sstack.
  unfold map_option.
  rewrite -> Heval_sval_sb2.
  rewrite <- map_option_ho.
  rewrite <- eval_sstack_def.
  rewrite -> Heval_r_sb2.
  assumption.
Qed.


Lemma valid_sbindings_rec: forall instk_height maxidx n smapv sb ops,
valid_bindings instk_height maxidx ((n, smapv) :: sb) ops ->
valid_bindings instk_height n sb ops.
Proof.
intros instk_height maxidx n smapv sb ops Hvalid.
unfold valid_bindings in Hvalid.
destruct Hvalid as [_ [_ Hvalid']].
fold valid_bindings in Hvalid'.
assumption.
Qed.


Lemma preserv_sbindings_ext: forall (sb1 sb2: sbindings) 
  (maxidx: nat) (ops: stack_op_instr_map) (n: nat) (smapv: smap_value)
  (instk_height: nat),
maxidx = S n ->
valid_smap_value instk_height maxidx ops smapv ->
preserv_sbindings sb1 sb2 n ops instk_height ->
preserv_sbindings ((n,smapv)::sb1) ((n,smapv)::sb2) maxidx ops instk_height.
Proof.
(*
intros sb1 sb2 maxidx ops n smapv instk_height Hmaxidx Hpreserv.
unfold preserv_sbindings. 
intros sv stk mem strg ctx v Hlen Hvalid_1 Hvalid_2 Heval.
destruct sv as [val|var|fvar] eqn: eq_sv; try intuition.
(* FreshVar case *)
(*unfold eval_sstack_val. unfold eval_sstack_val'.
unfold follow_in_smap.*)
destruct (fvar =? n) eqn: eq_n_fvar.
- (* Evaluate the same fvar in preserving sb1 and sb2 *)
  admit.
- rewrite -> eval_fvar_diff; try assumption.
  rewrite -> eval_fvar_diff in Heval; try assumption.
  unfold preserv_sbindings in Hpreserv.
  apply Hpreserv; try intuition.
  * apply valid_sbindings_rec with (maxidx:=maxidx)(smapv:=smapv).
    assumption.
  * apply valid_sbindings_rec with (maxidx:=maxidx)(smapv:=smapv).
    assumption.  
*)
Admitted.

(* sb2 preserves all the successful evaluations of smem in sb1 *)  
Lemma preserv_sbindings_smemory:
forall (sb1 sb2: sbindings) (maxidx: nat) (ops: stack_op_instr_map)
  (instk_height: nat), 
preserv_sbindings sb1 sb2 maxidx ops instk_height -> 
  forall (smem: smemory) (stk: stack) (mem mem': memory) 
    (strg: storage) (ctx: context),
  instk_height = length stk ->
  eval_smemory smem maxidx sb1 stk mem strg ctx ops = Some mem' ->
  eval_smemory smem maxidx sb2 stk mem strg ctx ops = Some mem'.
Proof.
intros sb1 sb2 maxidx ops instk_height Hpreserv smem.
revert sb1 sb2 maxidx ops instk_height Hpreserv.
induction smem as [|h r IH].
- intuition.
- intros sb1 sb2 maxidx ops instk_height Hpreserv stk mem mem' strg ctx 
    Hlen Heval_mem.
  unfold eval_smemory in Heval_mem.
  unfold map_option in Heval_mem.
  unfold instantiate_memory_update in Heval_mem.
  (* TODO *)
Admitted.

(* sb2 preserves all the successful evaluations of sstorage in sb1 *)  
Lemma preserv_sbindings_sstorage:
forall (sb1 sb2: sbindings) (maxidx: nat)
  (ops: stack_op_instr_map) (instk_height: nat), 
preserv_sbindings sb1 sb2 maxidx ops instk_height -> 
  forall (stk: stack) (sstrg: sstorage) (mem: memory) (strg strg': storage) (ctx: context),
  instk_height = length stk ->
  eval_sstorage sstrg maxidx sb1 stk mem strg ctx ops = Some strg' ->
  eval_sstorage sstrg maxidx sb2 stk mem strg ctx ops = Some strg'.
Proof.
Admitted.


(* Changing a preseving sbinding in a sstate preserves successful evaluations *)
Lemma preserv_sbindings_sstate :
forall (sb1 sb2: sbindings) (maxidx: nat) 
  (ops: stack_op_instr_map) (instk_height: nat), 
preserv_sbindings sb1 sb2 maxidx ops instk_height ->
valid_bindings instk_height maxidx sb1 evm_stack_opm ->
valid_bindings instk_height maxidx sb2 evm_stack_opm ->
  forall (st st': state) (sstk: sstack) (smem: smemory) 
  (sstrg: sstorage) (sctx : scontext),
    instk_height = length (get_stack_st st) ->
    eval_sstate st (SymExState instk_height sstk smem sstrg sctx 
      (SymMap maxidx sb1)) ops = Some st' -> 
    eval_sstate st (SymExState instk_height sstk smem sstrg sctx 
      (SymMap maxidx sb2)) ops = Some st'.
Proof.
intros sb1 sb2 maxidx ops instk_height Hpr_sbind Hvalid1 Hvalid2 st st' 
  sstk smem sstrg sctx Heval_sstate_sb1.
unfold eval_sstate in Heval_sstate_sb1.
simpl in Heval_sstate_sb1.
unfold eval_sstate. simpl.
destruct (instk_height =? length (get_stack_st st)) eqn: eq_instk_height;
  try discriminate.
destruct (eval_sstack sstk maxidx sb1 (get_stack_st st) (get_memory_st st) 
  (get_storage_st st) (get_context_st st) ops) eqn: eq_eval_sstack; 
  try discriminate.
apply preserv_sbindings_sstack with (sb2:=sb2)(instk_height:=instk_height) in 
  eq_eval_sstack; try assumption.
rewrite -> eq_eval_sstack.
destruct (eval_smemory smem maxidx sb1 (get_stack_st st) (get_memory_st st)
  (get_storage_st st) (get_context_st st) ops) eqn: eq_eval_smemory;
  try discriminate.
apply preserv_sbindings_smemory with (sb2:=sb2)(instk_height:=instk_height) in 
  eq_eval_smemory; try assumption.
rewrite -> eq_eval_smemory.
destruct (eval_sstorage sstrg maxidx sb1 (get_stack_st st) (get_memory_st st)
  (get_storage_st st) (get_context_st st) ops) eqn: eq_eval_sstorage;
  try discriminate.
apply preserv_sbindings_sstorage with (sb2:=sb2)(instk_height:=instk_height) in 
  eq_eval_sstorage; try assumption.
rewrite -> eq_eval_sstorage.
intuition.
Qed.


(* Type of a function that optimizes a single smap_value *)
Definition opt_smap_value_type := smap_value -> sstack_val_cmp_t -> sbindings -> 
  nat -> nat -> stack_op_instr_map -> smap_value*bool.


(* TODO: remove *)
Lemma test: 
valid_bindings 3 3 [(2,SymBasicVal (FreshVar 1));
                    (1,SymBasicVal (InStackVar 2));
                    (0,SymBasicVal (Val WZero))]
               evm_stack_opm.
Proof.
simpl.
intuition.
Qed.

(* 'opt' is sound if optimizing the head in a valid bindings (idx,val)::sb 
   results in a valid bindings (idx,val')::sb that preserves evaluations *)
Definition opt_sbinding_snd (opt: opt_smap_value_type) :=
forall (val val': smap_value) (fcmp: sstack_val_cmp_t) (sb: sbindings) 
  (maxidx: nat) (instk_height: nat) (idx: nat) (flag: bool),
safe_sstack_val_cmp fcmp ->
valid_bindings instk_height maxidx ((idx,val)::sb) evm_stack_opm ->
opt val fcmp sb idx instk_height evm_stack_opm = (val', flag) ->
  valid_bindings instk_height maxidx ((idx,val')::sb) evm_stack_opm /\
  forall stk mem strg ctx v,
    instk_height = length stk ->
    eval_sstack_val (FreshVar idx) stk mem strg ctx maxidx ((idx,val)::sb) 
       evm_stack_opm = Some v -> 
    eval_sstack_val (FreshVar idx) stk mem strg ctx maxidx ((idx,val')::sb) 
       evm_stack_opm = Some v.


(* Applies smap value optimization to the first suitable entry in sbindings *)
Fixpoint optimize_first_sbindings (opt_sbinding: opt_smap_value_type) 
  (fcmp: sstack_val_cmp_t) (sb: sbindings) (instk_height: nat) 
    : sbindings*bool :=
match sb with
| [] => (sb,false)
| (n,val)::rs => 
    match opt_sbinding val fcmp rs n instk_height evm_stack_opm with
    | (val', true) => ((n,val')::rs, true)
    | (val', false) => 
        match (optimize_first_sbindings opt_sbinding fcmp rs
            instk_height) with 
        | (rs', flag) => ((n,val)::rs', flag)
        end
    end
end.


Lemma optimize_first_valid: forall (opt: opt_smap_value_type) 
  (fcmp: sstack_val_cmp_t) (sb sb': sbindings) (maxid instk_height: nat) 
  (flag: bool),
safe_sstack_val_cmp fcmp ->
opt_sbinding_snd opt ->
valid_bindings instk_height maxid sb evm_stack_opm ->
optimize_first_sbindings opt fcmp sb instk_height = (sb', flag) ->
valid_bindings instk_height maxid sb' evm_stack_opm.
Proof.
Admitted.


Lemma valid_smap_value_succ: forall instk_height n ops smapv,
valid_smap_value instk_height n ops smapv ->
valid_smap_value instk_height (S n) ops smapv.
Proof.
Admitted.


(* If opt is sound when optimizing the first entry in the bindings, then 
   the optimize_first_sbindings will preserve the bindings *)
Lemma opt_sbinding_preserves: 
forall (opt: opt_smap_value_type) (fcmp: sstack_val_cmp_t) (sb sb': sbindings) 
  (maxid instk_height: nat) (flag: bool),
safe_sstack_val_cmp fcmp ->
opt_sbinding_snd opt ->
valid_bindings instk_height maxid sb evm_stack_opm ->
optimize_first_sbindings opt fcmp sb instk_height = (sb', flag) ->
preserv_sbindings sb sb' maxid evm_stack_opm instk_height.
Proof.
intros opt fcmp sb. revert opt fcmp.
induction sb as [|h rsb IH].
- intros opt fcmp sb' maxid instk_height flag Hfcmp_snd Hopt_sbinding_snd 
    Hvalid Hoptimize_first_sbindings.
  simpl in Hoptimize_first_sbindings.
  injection Hoptimize_first_sbindings as eq_sb' _.
  rewrite <- eq_sb'.
  unfold preserv_sbindings. intuition.
- intros opt fcmp sb' maxid instk_height flag Hfcmp_snd Hopt_sbinding_snd 
    Hvalid Hoptimize_first_sbindings.
  destruct h as [n smapv] eqn: eq_h.
  assert (Hoptimize_first_sbindings_copy := Hoptimize_first_sbindings).
  assert (Hvalid_copy := Hvalid).
  unfold optimize_first_sbindings in Hoptimize_first_sbindings.
  destruct (opt smapv fcmp rsb n instk_height evm_stack_opm) as [val' b] 
    eqn: eq_opt_val.
  unfold preserv_sbindings.
  split; try assumption.
  split.
  * (* valid_bindings instk_height maxid sb' evm_stack_opm *)
    admit.
  * destruct b eqn: eq_b.
    + (* Optimized first entry in sbindings *)
      injection Hoptimize_first_sbindings as eq_sb' eq_flag'.
      rewrite <- eq_sb'.
      unfold preserv_sbindings.
      
      intros sv stk mem strg ctx v Hlen Heval_sb.
      destruct sv as [val|var|fvar] eqn: eq_sv; try intuition.
      (* FreshVar fvar *)
      destruct (fvar =? n) eqn: eq_fvar_n.
      -- rewrite -> PeanoNat.Nat.eqb_eq in eq_fvar_n.
         rewrite -> eq_fvar_n.
         rewrite -> eq_fvar_n in Heval_sb.
         unfold opt_sbinding_snd in Hopt_sbinding_snd.
         pose proof (Hopt_sbinding_snd smapv val' fcmp rsb maxid instk_height n
           true Hfcmp_snd Hvalid eq_opt_val) as [Hvalid2 Heval_imp].
         pose proof (Heval_imp stk mem strg ctx v Hlen Heval_sb).
         assumption.
      -- rewrite -> eval_fvar_diff; try assumption.
         rewrite -> eval_fvar_diff in Heval_sb; try assumption.
    + (* Optimized the tail of the sbindings *)
      fold optimize_first_sbindings in Hoptimize_first_sbindings.
      destruct (optimize_first_sbindings opt fcmp rsb instk_height) as
        [rs' flag'] eqn: eq_optimize_first_rs.
      injection Hoptimize_first_sbindings as eq_sb' eq_flag.
      rewrite <- eq_sb'.
      unfold valid_bindings in Hvalid.
      destruct Hvalid as [eq_maxid_n [Hvalid_smap Hvalid_rsb]].
      fold valid_bindings in Hvalid_rsb.
      pose proof (IH opt fcmp rs' n instk_height flag' Hfcmp_snd
        Hopt_sbinding_snd Hvalid_rsb eq_optimize_first_rs) as Hpreserv_rs.
      apply preserv_sbindings_ext; try intuition.
      rewrite -> eq_maxid_n.
      apply valid_smap_value_succ; try assumption.
Admitted.



Definition optimize_first_sstate (opt: opt_smap_value_type) 
  (fcmp: sstack_val_cmp_t) (sst: sstate)
  : sstate*bool :=
match sst with 
| SymExState instk_height sstk smem sstg sctx (SymMap maxid bindings) =>
    match optimize_first_sbindings opt fcmp bindings instk_height with
    | (bindings', flag) => 
        (SymExState instk_height sstk smem sstg sctx (SymMap maxid bindings'),
         flag)
    end
end.

Lemma optimize_first_sstate_valid: forall (opt: opt_smap_value_type) 
  (fcmp: sstack_val_cmp_t) (sst sst': sstate)
  (flag: bool),
valid_sstate sst evm_stack_opm ->
opt_sbinding_snd opt ->
optimize_first_sstate opt fcmp sst = (sst', flag) ->
valid_sstate sst' evm_stack_opm.
Proof.
intros opt fcmp sst sst' flag Hvalid Hopt Hopt_first.
unfold valid_sstate in Hvalid.
destruct sst. destruct sm. simpl in Hvalid.
destruct Hvalid as [valid_smap [valid_sstack [valid_smemory valid_sstorage]]].
unfold optimize_first_sstate in Hopt_first.
destruct (optimize_first_sbindings opt fcmp bindings instk_height) as
  [bindings' flag'].
injection Hopt_first as eq_sst' eq_flag'.
rewrite <- eq_sst'.
unfold valid_sstate. simpl.




(* optimize_first_sstate does not change maxidx or stack_height, and does not
   change any fresh variable in the bindings, only one smap_value
   But I need some assumptions about the result of opt: it returns values
   that use smaller fresh variables or something like that *)
Admitted.

Lemma optimize_first_sstate_preserv: forall (opt: opt_smap_value_type) 
  (fcmp: sstack_val_cmp_t) (sst sst': sstate)
  (flag: bool),
valid_sstate sst evm_stack_opm ->
opt_sbinding_snd opt ->
optimize_first_sstate opt fcmp sst = (sst', flag) ->
 get_instk_height_sst sst = get_instk_height_sst sst' /\
 forall (st st': state), eval_sstate st sst  evm_stack_opm = Some st' ->
                         eval_sstate st sst' evm_stack_opm = Some st'.
Proof.
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

(*
Check (
optimize_add_0_sbinding 
  (SymOp ADD [(Val WZero); (Val WOne)])
  compare_sstack_val  
).
*)

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

Search (eval_sstack_val').

Lemma optimize_add_0_sbinding_snd:
opt_sbinding_snd optimize_add_0_sbinding.
Proof.
(*
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_add_0_sbinding.
split.
- (* valid_sbindings *)
  simpl. simpl in Hvalid.
  destruct Hvalid as [Hmaxidx [Hvalid_smap_value_val Hvalid_sb]].
  split; try split; try assumption.
  (* use general lemma for every "safe" optimization *)
  admit.
- (* evaluation is preserved *) 
  intros stk mem strg ctx v Hlen Heval_orig.
  assert (Hlen2 := Hlen).
  rewrite -> Hlen in Hlen2.
  rewrite <- Hlen in Hlen2 at 2.
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
  + (* arg1 ~ WZero *)
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
    (* TODO *) 
    unfold valid_bindings in Hvalid.
    destruct Hvalid as [eq_maxid [Hvalid_smap_value Hvalid_bindings_sb]].
    unfold valid_smap_value in Hvalid_smap_value.
    unfold valid_stack_op_instr in Hvalid_smap_value.
    simpl in Hvalid_smap_value.
    destruct (Hvalid_smap_value) as [_ [Hvalid_arg1 [Hvalid_arg2 _ ]]].
    fold valid_bindings in Hvalid_bindings_sb.
    
    pose proof (fake1 instk_height maxidx arg1) as cfake1.
    pose proof (fake1 instk_height maxidx (Val WZero)) as cfake2.
    pose proof (fake2 instk_height maxidx sb evm_stack_opm) as cfake3.
    (* TODO *) 
    pose proof (Hsafe_sstack_val_cmp arg1 arg2 idx sb idx sb 
      instk_height evm_stack_opm Hvalid_arg1 Hvalid_arg2 Hvalid_bindings_sb
      Hvalid_bindings_sb). cfake1 cfake2 cfake3 cfake3
      fcmp_arg1_zero stk mem strg ctx Hlen2) as eq_eval_arg1.
    pose proof (Hsafe_sstack_val_cmp arg1 (Val WZero) maxidx sb maxidx sb 
      instk_height evm_stack_opm cfake1 cfake2 cfake3 cfake3
      fcmp_arg1_zero stk mem strg ctx Hlen2) as eq_eval_arg1.
    destruct eq_eval_arg1 as [v1 [eq_eval_arg1 eq_eval_zero]].
    rewrite -> eval_sstack_val_const in eq_eval_zero.
    injection eq_eval_zero as eq_v1_zero.
    rewrite <- eq_v1_zero in eq_eval_arg1.
    unfold eval_sstack_val in eq_eval_arg1.
    pose proof (Gt.gt_Sn_n maxidx) as eq_gt_succ.
    pose proof (eval_sstack_val'_succ (S maxidx) instk_height arg1 stk mem
      strg ctx maxidx sb evm_stack_opm Hlen cfake1 cfake3 eq_gt_succ) as
        [vv eq_eval'_arg1].
    pose proof (eval_sstack_val'_preserved_when_depth_extended maxidx idx sb
      arg1 varg1 stk mem strg ctx evm_stack_opm eval_arg1) as Heval'_arg1.
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
    apply eval'_maxidx_indep with (n:=idx).
    assumption. 
  * admit.
    (*destruct (fcmp arg2 (Val WZero) maxidx sb maxidx sb instk_height)
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
    (****)
    pose proof (Hsafe_sstack_val_cmp arg2 (Val WZero) maxidx sb maxidx sb 
      instk_height evm_stack_opm cfake1 cfake2 cfake3 cfake3
      fcmp_arg2_zero stk mem strg ctx) as eq_eval_arg2.
    rewrite -> eval_sstack_val_const in eq_eval_arg2.
    unfold eval_sstack_val in eq_eval_arg2.
    pose proof (Gt.gt_Sn_n maxidx) as eq_gt_succ.
    pose proof (eval_sstack_val'_succ (S maxidx) instk_height arg2 stk mem
      strg ctx maxidx sb evm_stack_opm cfake4 cfake1 cfake3 eq_gt_succ) as
        [vv eq_eval'_arg2].
    pose proof (eval_sstack_val'_preserved_when_depth_extended maxidx idx sb
      arg2 varg2 stk mem strg ctx evm_stack_opm eval_arg2) as Heval'_arg2.
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
    rewrite -> eval'_maxidx_indep with (n:=idx)(v:=varg1); try intuition.*)
*)    
Admitted.


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
- pose proof (optimize_first_sstate_valid optimize_add_0_sbinding fcmp sst 
    sst' b Hvalid_sst optimize_add_0_sbinding_snd Hoptim).
  assumption.
- pose proof (optimize_first_sstate_preserv optimize_add_0_sbinding fcmp sst 
    sst' b Hvalid_sst optimize_add_0_sbinding_snd Hoptim) as [Hinstk Heval].
  split; try assumption.
(*
unfold optimize_add_0 in Hoptim. 
destruct sst as [instk_height sstk smem sstg sctx sm].
unfold optimize_first_sstate in Hoptim.
destruct sm as [maxid bindings].
destruct (optimize_first_sbindings optimize_add_0_sbinding fcmp bindings
  instk_height) as [bindings' flag].
injection Hoptim as eq_sst' eq_b.
rewrite <- eq_sst'. simpl.

split.
- (* valid_sstate sst' evm_stack_opm *)
  admit.
- split.
  + 
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
  intuition.*)
Qed.


End Optimizations_Def.

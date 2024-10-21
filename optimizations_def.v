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

Require Import FORVES.optimizations_common.
Import Optimizations_Common.

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import List.
Import ListNotations.

(* For debugging with print_id *)
From ReductionEffect Require Import PrintingEffect.


Module Optimizations_Def.

(* Definitions *)

Definition optim := sstate -> sstate*bool.
 
Definition optim_snd (opt: optim) : Prop := 
forall (sst: sstate) (sst': sstate) (b: bool),
valid_sstate sst evm_stack_opm ->
opt sst = (sst', b) ->
(valid_sstate sst' evm_stack_opm /\ 
 get_instk_height_sst sst = get_instk_height_sst sst' /\
 forall (st st': state), eval_sstate st sst  evm_stack_opm = Some st' ->
                         eval_sstate st sst' evm_stack_opm = Some st').

(* sb2 preserves all the successful evaluations of sstack_val in sb1 *)
Definition preserv_sbindings (sb1 sb2: sbindings) (maxidx: nat) 
  (ops: stack_op_instr_map) (instk_height: nat) : Prop :=
valid_bindings instk_height maxidx sb1 ops /\
valid_bindings instk_height maxidx sb2 ops /\
forall (sv : sstack_val) (stk : stack) (mem: memory) (strg: storage) 
  (exts: externals) (v: EVMWord),
  instk_height = length stk ->
  eval_sstack_val sv stk mem strg exts maxidx sb1 ops = Some v ->
  eval_sstack_val sv stk mem strg exts maxidx sb2 ops = Some v.

(* Type of a function that optimizes a single smap_value *)
Definition opt_smap_value_type := 
  smap_value ->            (* val *)
  sstack_val_cmp_t ->      (* fcmp *) 
  sbindings ->             (* sb *)
  nat ->                   (* maxid *) 
  nat ->                   (* instk_height *)
  stack_op_instr_map ->    (* ops *)
  smap_value*bool.         (* (val', flag) *)


Definition opt_smapv_valid_snd (opt: opt_smap_value_type) :=
forall (instk_height n: nat) (fcmp: sstack_val_cmp_t) (sb: sbindings) 
  (val val': smap_value) (flag: bool),
safe_sstack_val_cmp fcmp ->
valid_smap_value instk_height n evm_stack_opm val ->
valid_bindings instk_height n sb evm_stack_opm ->
opt val fcmp sb n instk_height evm_stack_opm = (val', flag) ->
valid_smap_value instk_height n evm_stack_opm val'.

(* 'opt' is sound if optimizing the head in a valid bindings (idx,val)::sb 
   results in a valid bindings (idx,val')::sb that preserves evaluations *)
Definition opt_sbinding_snd (opt: opt_smap_value_type) :=
forall (val val': smap_value) (fcmp: sstack_val_cmp_t) (sb: sbindings) 
  (maxidx: nat) (instk_height: nat) (idx: nat) (flag: bool),
safe_sstack_val_cmp fcmp ->
valid_bindings instk_height maxidx ((idx,val)::sb) evm_stack_opm ->
opt val fcmp sb idx instk_height evm_stack_opm = (val', flag) ->
  valid_bindings instk_height maxidx ((idx,val')::sb) evm_stack_opm /\
  forall stk mem strg exts v,
    instk_height = length stk ->
    eval_sstack_val (FreshVar idx) stk mem strg exts maxidx ((idx,val)::sb) 
       evm_stack_opm = Some v -> 
    eval_sstack_val (FreshVar idx) stk mem strg exts maxidx ((idx,val')::sb) 
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

Definition optimize_first_sstate (opt: opt_smap_value_type) 
  (fcmp: sstack_val_cmp_t) (sst: sstate)
  : sstate*bool :=
match sst with 
| SymExState instk_height sstk smem sstg sexts (SymMap maxid bindings) =>
    match optimize_first_sbindings opt fcmp bindings instk_height with
    | (bindings', flag) => 
        (SymExState instk_height sstk smem sstg sexts (SymMap maxid bindings'),
         flag)
    end
end.






(* Lemmas *)
 
(* sb2 preserves all the successful evaluations of sstack in sb1 *)  
Lemma preserv_sbindings_sstack: 
forall (sb1 sb2: sbindings) (maxidx: nat) (ops: stack_op_instr_map) 
  (instk_height: nat), 
preserv_sbindings sb1 sb2 maxidx ops instk_height -> 
  forall (sstk: sstack) (stk stk': stack) (mem: memory) 
    (strg: storage) (exts: externals),
  instk_height = length stk ->
  eval_sstack sstk maxidx sb1 stk mem strg exts ops = Some stk' ->
  eval_sstack sstk maxidx sb2 stk mem strg exts ops = Some stk'.
Proof.
intros sb1 sb2 maxidx ops instk_height Hpreserv sstk.
revert sb1 sb2 maxidx ops instk_height Hpreserv.
induction sstk as [|sval r IH].
- intuition.
- intros sb1 sb2 maxid ops instk_height Hpreserv stk 
    stk' mem strg exts Hlen Heval.
  unfold preserv_sbindings in Hpreserv.
  unfold eval_sstack in Heval.
  unfold map_option in Heval.
  destruct (eval_sstack_val sval stk mem strg exts maxid sb1 ops) as
    [v|] eqn: eq_eval_sval; try discriminate.
  rewrite <- map_option_ho in Heval.
  assert (Hpreserv_copy := Hpreserv).
  destruct Hpreserv as [Hvalid_sb1 [Hvalid_sb2 Hpreserv]].
  pose proof (Hpreserv sval stk mem strg exts v Hlen eq_eval_sval) 
    as Heval_sval_sb2.
  rewrite <- eval_sstack_def in Heval.
  destruct (eval_sstack r maxid sb1 stk mem strg exts ops) as [rs_val|]
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


Lemma preserv_sbindings_ext: forall (sb1 sb2: sbindings)
  (maxidx: nat) (ops: stack_op_instr_map) (n: nat) (smapv: smap_value)
  (instk_height: nat),
maxidx = S n ->
valid_smap_value instk_height n ops smapv ->
preserv_sbindings sb1 sb2 n ops instk_height ->
preserv_sbindings ((n,smapv)::sb1) ((n,smapv)::sb2) maxidx ops instk_height.
Proof.
intros sb1 sb2 maxidx ops n smapv instk_height Hmaxidx Hvalid Hpreserv.
unfold preserv_sbindings in Hpreserv.
destruct Hpreserv as [Hvalid_sb1 [Hvalid_sb2 Hpreserv]].
unfold preserv_sbindings.
split.
- simpl. intuition. 
- split. 
  + simpl. intuition.
  + unfold eval_sstack_val in Hpreserv. 
    unfold eval_sstack_val.
    intros sv stk mem strg exts v Hlen Heval.
    destruct sv as [val|var|fvar] eqn: eq_sv.
    * unfold eval_sstack_val. simpl.
      unfold eval_sstack_val in Heval. simpl in Heval.
      assumption.
    * unfold eval_sstack_val. simpl.
      unfold eval_sstack_val in Heval. simpl in Heval.
      assumption.
    * destruct (n =? fvar) eqn: eq_fvar_n.
      -- destruct smapv as [basicv|tagv|label args|offset smem|key sstrg|
           offset size smem] eqn: eq_smapv. 
         ++ (* SymBasicVal basicv *)
            destruct basicv as [val'|var'|fvar'] eqn: eq_basicv.
            ** simpl in Heval. rewrite -> eq_fvar_n in Heval.
               simpl. rewrite -> eq_fvar_n. 
               assumption.
            ** simpl in Heval. rewrite -> eq_fvar_n in Heval.
               simpl. rewrite -> eq_fvar_n. 
               assumption.
            ** rewrite -> PeanoNat.Nat.eqb_eq in eq_fvar_n.
               rewrite -> eq_fvar_n in Heval.
               rewrite <- eval_sstack_val'_freshvar in Heval.
               rewrite -> eq_fvar_n.
               rewrite <- eval_sstack_val'_freshvar.
               pose proof (eval'_then_valid_sstack_value maxidx 
                 (FreshVar fvar') stk mem strg exts maxidx sb1 ops v
                 instk_height n Heval Hvalid_sb1 Hlen) as Hvalid_stk_val_fv.
               assert (S n > n) as maxidx_gt_nm; try intuition.
               pose proof (eval_sstack_val'_succ (S n) instk_height
                 (FreshVar fvar') stk mem strg exts n sb1 ops Hlen
                 Hvalid_stk_val_fv Hvalid_sb1 maxidx_gt_nm) as eval'_fvar'.
               destruct eval'_fvar' as [v' eval'_fvar'].
               rewrite -> eval'_maxidx_indep_eq with (m:=n) in Heval.
               pose proof (eval_sstack_val'_preserved_when_depth_extended
                 (S n) n sb1 (FreshVar fvar') v' stk mem strg exts ops
                 eval'_fvar') as eval'_fvar'_succ.
               rewrite <- Hmaxidx in eval'_fvar'_succ.
               rewrite -> Heval in eval'_fvar'_succ.
               injection eval'_fvar'_succ as eq_v'.
               rewrite <- eq_v' in eval'_fvar'.
               pose proof (Hpreserv (FreshVar fvar') stk mem strg exts v Hlen
                 eval'_fvar') as eval'_fvar'_sb2.
               rewrite -> Hmaxidx.
               apply eval_sstack_val'_preserved_when_depth_extended.
               rewrite -> eval'_maxidx_indep_eq with (m:=S n) in eval'_fvar'_sb2.
               assumption.
         ++ (* SymPUSHTAG tagv *)
            simpl in Heval. rewrite -> eq_fvar_n in Heval.
            simpl. rewrite -> eq_fvar_n.
            assumption.
         ++ (* SymOp label args *)
            rewrite <- Hmaxidx in Hpreserv.
            simpl in Heval. rewrite -> eq_fvar_n in Heval.
            simpl. rewrite -> eq_fvar_n.
            destruct (ops label) as [nargs f H_comm H_exts_ind].
            destruct (length args =? nargs); try discriminate.
            destruct (map_option
              (fun sv' : sstack_val =>
                 eval_sstack_val' maxidx sv' stk mem strg exts n sb1 ops) args)
              as [vargs|] eqn: Hmapo; try discriminate.
            rewrite <- Heval.
            pose proof (map_option_sstack maxidx stk mem strg exts n sb1 sb2 
              ops instk_height args vargs Hmapo Hpreserv Hlen) as eq_mapo'.
            rewrite -> eq_mapo'.
            reflexivity.
         ++ (* SymMLOAD offset smem *)
            rewrite <- Hmaxidx in Hpreserv.
            simpl in Heval. rewrite -> eq_fvar_n in Heval.
            simpl. rewrite -> eq_fvar_n.
            destruct (map_option (instantiate_memory_update
              (fun sv : sstack_val =>
                 eval_sstack_val' maxidx sv stk mem strg exts n sb1 ops)) smem)
              as [mem_updates|] eqn: Hmapo; try discriminate.
            pose proof (map_option_inst_mem_update maxidx stk mem strg exts n 
              sb1 sb2 ops instk_height smem mem_updates Hmapo Hpreserv Hlen)
              as eq_mapo'.
            rewrite -> eq_mapo'.
            destruct (eval_sstack_val' maxidx offset stk mem strg exts n sb1 ops)
              as [offsetv|] eqn: eq_eval_offset; try discriminate.
            pose proof (Hpreserv offset stk mem strg exts offsetv Hlen
              eq_eval_offset) as eq_eval_offset'.
            rewrite ->  eq_eval_offset'.
            assumption.
         ++ (* SymSLOAD key sstrg *)
            rewrite <- Hmaxidx in Hpreserv.
            simpl in Heval. rewrite -> eq_fvar_n in Heval.
            simpl. rewrite -> eq_fvar_n.
            destruct (map_option (instantiate_storage_update
              (fun sv : sstack_val =>
                eval_sstack_val' maxidx sv stk mem strg exts n sb1 ops)) sstrg)
              as [strg_updates|] eqn: Hmapo; try discriminate.
            pose proof (map_option_inst_strg_update maxidx stk mem strg exts n 
              sb1 sb2 ops instk_height sstrg strg_updates Hmapo Hpreserv Hlen)
              as eq_mapo'.
            rewrite -> eq_mapo'.
            destruct (eval_sstack_val' maxidx key stk mem strg exts n sb1 ops)
              as [keyv|] eqn: eq_eval_key; try discriminate.
            pose proof (Hpreserv key stk mem strg exts keyv Hlen
              eq_eval_key) as eq_eval_key'.
            rewrite ->  eq_eval_key'.
            assumption.
         ++ (* SymSHA3 offset size smem *)
            rewrite <- Hmaxidx in Hpreserv.
            simpl in Heval. rewrite -> eq_fvar_n in Heval.
            simpl. rewrite -> eq_fvar_n.
            destruct (map_option (instantiate_memory_update
              (fun sv : sstack_val =>
                eval_sstack_val' maxidx sv stk mem strg exts n sb1 ops)) smem)
              as [mem_updates|] eqn: Hmapo; try discriminate.
            pose proof (map_option_inst_mem_update maxidx stk mem strg exts n 
              sb1 sb2 ops instk_height smem mem_updates Hmapo Hpreserv Hlen)
              as eq_mapo'.
            rewrite -> eq_mapo'.
            destruct (eval_sstack_val' maxidx offset stk mem strg exts n sb1 ops)
              as [offsetv|] eqn: eq_eval_offset; try discriminate.
            pose proof (Hpreserv offset stk mem strg exts offsetv Hlen
              eq_eval_offset) as eq_eval_offset'.
            rewrite ->  eq_eval_offset'.
            destruct (eval_sstack_val' maxidx size stk mem strg exts n sb1 ops)
              as [sizev|] eqn: eq_eval_size; try discriminate.
            pose proof (Hpreserv size stk mem strg exts sizev Hlen
              eq_eval_size) as eq_eval_size'.
            rewrite ->  eq_eval_size'.
            assumption.
      -- rewrite -> eval_sstack_val'_diff with (b:=n) in Heval; try assumption.
         rewrite -> eval_sstack_val'_diff with (b:=n); try assumption.
         pose proof (eval'_then_valid_sstack_value maxidx 
           (FreshVar fvar) stk mem strg exts n sb1 ops v
           instk_height n Heval Hvalid_sb1 Hlen) as Hvalid_stk_val_fv.
         assert (S n > n) as maxidx_gt_nm; try intuition.
         pose proof (eval_sstack_val'_succ (S n) instk_height
           (FreshVar fvar) stk mem strg exts n sb1 ops Hlen
           Hvalid_stk_val_fv Hvalid_sb1 maxidx_gt_nm) as eval'_fvar.
         destruct eval'_fvar as [v' eval'_fvar].
         pose proof (eval_sstack_val'_preserved_when_depth_extended
           (S n) n sb1 (FreshVar fvar) v' stk mem strg exts ops
           eval'_fvar) as eval'_fvar_succ.
         rewrite <- Hmaxidx in eval'_fvar_succ.
         rewrite -> Heval in eval'_fvar_succ.
         injection eval'_fvar_succ as eq_v'.
         rewrite <- eq_v' in eval'_fvar.
         pose proof (Hpreserv (FreshVar fvar) stk mem strg exts v Hlen
           eval'_fvar) as eval'_fvar_sb2.
         rewrite -> Hmaxidx.
         apply eval_sstack_val'_preserved_when_depth_extended.
         assumption.
Qed.


(* sb2 preserves all the successful evaluations of smem in sb1 *)  
Lemma preserv_sbindings_smemory:
forall (sb1 sb2: sbindings) (maxidx: nat) (ops: stack_op_instr_map)
  (instk_height: nat), 
preserv_sbindings sb1 sb2 maxidx ops instk_height -> 
  forall (smem: smemory) (stk: stack) (mem mem': memory) 
    (strg: storage) (exts: externals),
  instk_height = length stk ->
  eval_smemory smem maxidx sb1 stk mem strg exts ops = Some mem' ->
  eval_smemory smem maxidx sb2 stk mem strg exts ops = Some mem'.
Proof.
intros sb1 sb2 maxidx ops instk_height Hpreserv smem stk
  mem mem' strg exts Hlen Heval_mem.
unfold eval_smemory. unfold eval_smemory in Heval_mem.
unfold eval_sstack_val in Hpreserv.
unfold eval_sstack_val in Heval_mem.
unfold eval_sstack_val.
destruct (map_option
                (instantiate_memory_update
                   (fun sv : sstack_val =>
                    eval_sstack_val' (S maxidx) sv stk mem strg exts maxidx
                      sb1 ops)) smem) as [updates|] eqn: eq_mapo;
  try discriminate.
injection Heval_mem as eq_mem'.
rewrite <- eq_mem'.
destruct Hpreserv as [Hvalid_sb1 [Hvalid_sb2 Hpreserv]].
pose proof (map_option_inst_mem_update (S maxidx) stk mem strg exts maxidx
  sb1 sb2 ops instk_height smem updates eq_mapo Hpreserv Hlen) as eq_mapo2.
rewrite -> eq_mapo2.
reflexivity.
Qed.


(* sb2 preserves all the successful evaluations of sstorage in sb1 *)  
Lemma preserv_sbindings_sstorage:
forall (sb1 sb2: sbindings) (maxidx: nat)
  (ops: stack_op_instr_map) (instk_height: nat), 
preserv_sbindings sb1 sb2 maxidx ops instk_height -> 
  forall (stk: stack) (sstrg: sstorage) (mem: memory) (strg strg': storage) (exts: externals),
  instk_height = length stk ->
  eval_sstorage sstrg maxidx sb1 stk mem strg exts ops = Some strg' ->
  eval_sstorage sstrg maxidx sb2 stk mem strg exts ops = Some strg'.
Proof.
intros sb1 sb2 maxidx ops instk_height Hpreserv stk sstrg
  mem strg strg' exts Hlen Heval_sstrg.
unfold eval_sstorage. unfold eval_sstorage in Heval_sstrg.
unfold eval_sstack_val in Hpreserv.
unfold eval_sstack_val in Heval_sstrg.
unfold eval_sstack_val.
destruct (map_option
                  (instantiate_storage_update
                     (fun sv : sstack_val =>
                      eval_sstack_val' (S maxidx) sv stk mem strg exts
                        maxidx sb1 ops)) sstrg) as [updates|] eqn: eq_mapo;
  try discriminate.
injection Heval_sstrg as eq_strg'.
rewrite <- eq_strg'.
destruct Hpreserv as [Hvalid_sb1 [Hvalid_sb2 Hpreserv]].
pose proof (map_option_inst_strg_update (S maxidx) stk mem strg exts maxidx
  sb1 sb2 ops instk_height sstrg updates eq_mapo Hpreserv Hlen) as eq_mapo2.
rewrite -> eq_mapo2.
reflexivity.
Qed.


(* Changing a preseving sbinding in a sstate preserves successful 
   evaluations *)
Lemma preserv_sbindings_sstate :
forall (sb1 sb2: sbindings) (maxidx: nat) 
  (ops: stack_op_instr_map) (instk_height: nat), 
preserv_sbindings sb1 sb2 maxidx ops instk_height ->
valid_bindings instk_height maxidx sb1 evm_stack_opm ->
valid_bindings instk_height maxidx sb2 evm_stack_opm ->
  forall (st st': state) (sstk: sstack) (smem: smemory) 
  (sstrg: sstorage) (sexts : sexternals),
    instk_height = length (get_stack_st st) ->
    eval_sstate st (SymExState instk_height sstk smem sstrg sexts 
      (SymMap maxidx sb1)) ops = Some st' -> 
    eval_sstate st (SymExState instk_height sstk smem sstrg sexts 
      (SymMap maxidx sb2)) ops = Some st'.
Proof.
intros sb1 sb2 maxidx ops instk_height Hpr_sbind Hvalid1 Hvalid2 st st' 
  sstk smem sstrg sexts Heval_sstate_sb1.
unfold eval_sstate in Heval_sstate_sb1.
simpl in Heval_sstate_sb1.
unfold eval_sstate. simpl.
destruct (instk_height =? length (get_stack_st st)) eqn: eq_instk_height;
  try discriminate.
destruct (eval_sstack sstk maxidx sb1 (get_stack_st st) (get_memory_st st) 
  (get_storage_st st) (get_externals_st st) ops) eqn: eq_eval_sstack; 
  try discriminate.
apply preserv_sbindings_sstack with (sb2:=sb2)(instk_height:=instk_height) in 
  eq_eval_sstack; try assumption.
rewrite -> eq_eval_sstack.
destruct (eval_smemory smem maxidx sb1 (get_stack_st st) (get_memory_st st)
  (get_storage_st st) (get_externals_st st) ops) eqn: eq_eval_smemory;
  try discriminate.
apply preserv_sbindings_smemory with (sb2:=sb2)(instk_height:=instk_height) in 
  eq_eval_smemory; try assumption.
rewrite -> eq_eval_smemory.
destruct (eval_sstorage sstrg maxidx sb1 (get_stack_st st) (get_memory_st st)
  (get_storage_st st) (get_externals_st st) ops) eqn: eq_eval_sstorage;
  try discriminate.
apply preserv_sbindings_sstorage with (sb2:=sb2)(instk_height:=instk_height) in 
  eq_eval_sstorage; try assumption.
rewrite -> eq_eval_sstorage.
intuition.
Qed.


Lemma valid_smap_value_opt_sbinding_snd: forall opt val fcmp sb idx 
  instk_height val' flag maxidx,
opt val fcmp sb idx instk_height evm_stack_opm = (val', flag) ->
opt_sbinding_snd opt ->
safe_sstack_val_cmp fcmp ->
valid_bindings instk_height maxidx ((idx, val) :: sb) evm_stack_opm ->
valid_smap_value instk_height idx evm_stack_opm val'.
Proof.
intros opt val fcmp sb idx instk_height val' flag maxidx Hopt Hopt_snd 
  Hsafe_fcmp Hvalid.
unfold opt_sbinding_snd in Hopt_snd.
pose proof (Hopt_snd val val' fcmp sb maxidx instk_height idx flag 
  Hsafe_fcmp Hvalid Hopt) as Hopt'.
destruct Hopt' as [Hvalid' _].
unfold valid_bindings in Hvalid'.
destruct Hvalid' as [_ [Hvalid_smap _]].
assumption.
Qed.


Lemma optimize_first_valid: forall (opt: opt_smap_value_type) 
  (fcmp: sstack_val_cmp_t) (sb sb': sbindings) (maxid instk_height: nat) 
  (flag: bool),
safe_sstack_val_cmp fcmp ->
opt_sbinding_snd opt ->
valid_bindings instk_height maxid sb evm_stack_opm ->
optimize_first_sbindings opt fcmp sb instk_height = (sb', flag) ->
valid_bindings instk_height maxid sb' evm_stack_opm.
Proof.
intros opt fcmp sb. revert opt fcmp.
induction sb as [| h rsb IH].
- intros opt fcmp sb' maxid instk_height flag Hsafe_fcmp Hopt_snd Hvalid_sb
  Hoptimize_first.
  simpl in Hoptimize_first.
  injection Hoptimize_first as eq_sb' _.
  rewrite <- eq_sb'.
  intuition.
- intros opt fcmp sb' maxid instk_height flag Hsafe_fcmp Hopt_snd Hvalid_sb
  Hoptimize_first.
  assert (Hvalid_sb_copy := Hvalid_sb).
  unfold valid_bindings in Hvalid_sb.
  destruct h as [idx value] eqn: eq_h.
  destruct Hvalid_sb as [Hmaxid [Hvalid_smap_value Hvalid_bindings_rsb]].
  fold valid_bindings in Hvalid_bindings_rsb.
  simpl in Hoptimize_first.
  destruct (opt value fcmp rsb idx instk_height evm_stack_opm) as [val' b]
    eqn: eq_opt_value.
  destruct b eqn: eq_b.
  + injection Hoptimize_first as eq_sb' eq_flag.
    rewrite <- eq_sb'. simpl.
    split; try assumption.
    split.
    * unfold opt_sbinding_snd in Hopt_snd.
      pose proof (Hopt_snd value val' fcmp rsb maxid instk_height idx true
      Hsafe_fcmp Hvalid_sb_copy eq_opt_value) as Hsnd_value.
      destruct Hsnd_value as [Hvalid_value _].
      unfold valid_bindings in Hvalid_value.
      intuition.
    * unfold opt_sbinding_snd in Hopt_snd.
      pose proof (Hopt_snd value val' fcmp rsb maxid instk_height idx true
      Hsafe_fcmp Hvalid_sb_copy eq_opt_value) as Hsnd_value.
      destruct Hsnd_value as [Hvalid_value _].
      unfold valid_bindings in Hvalid_value.
      intuition.
  + destruct (optimize_first_sbindings opt fcmp rsb instk_height) 
      as [rs' flag'] eqn: eq_optimize_rsb.
    injection Hoptimize_first as eq_sb' eq_flag.
    rewrite <- eq_sb'. simpl.
    split; try assumption.
    split; try assumption.
    apply IH with (opt:=opt)(fcmp:=fcmp)(flag:=flag'); try assumption.
Qed.


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
    apply optimize_first_valid with (opt:=opt)(fcmp:=fcmp)
      (sb:=h::rsb)(flag:=flag); try intuition.
    + rewrite -> eq_h. assumption.
    + rewrite -> eq_h. assumption.
  * destruct b eqn: eq_b.
    + (* Optimized first entry in sbindings *)
      injection Hoptimize_first_sbindings as eq_sb' eq_flag'.
      rewrite <- eq_sb'.
      unfold preserv_sbindings.
      
      intros sv stk mem strg exts v Hlen Heval_sb.
      unfold opt_sbinding_snd in Hopt_sbinding_snd.
      destruct sv as [val|var|fvar] eqn: eq_sv; try intuition.
      unfold eval_sstack_val in Heval_sb.
      destruct (n =? fvar) eqn: eq_n_fvar.
      -- apply EqNat.beq_nat_true in eq_n_fvar.
         rewrite <- eq_n_fvar in Heval_sb.
         unfold eval_sstack_val in Hopt_sbinding_snd.
         pose proof (Hopt_sbinding_snd smapv val' fcmp rsb maxid instk_height 
           n true Hfcmp_snd Hvalid eq_opt_val) as Hopt_sbinding_snd'.
         destruct Hopt_sbinding_snd' as [_ Hpreserv_ext].
         pose proof (Hpreserv_ext stk mem strg exts v Hlen Heval_sb).
         unfold eval_sstack_val. rewrite <- eq_n_fvar.
         assumption.
      -- unfold eval_sstack_val. 
         rewrite -> eval_sstack_val'_diff with (b:=maxid); try assumption.
         rewrite -> eval_sstack_val'_diff with (b:=maxid) in Heval_sb; 
           try assumption.
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
        Hopt_sbinding_snd Hvalid_rsb eq_optimize_first_rs) 
        as Hpreserv_rs.
      apply preserv_sbindings_ext; try intuition.
Qed.


Lemma optimize_first_sstate_valid: forall (opt: opt_smap_value_type) 
  (fcmp: sstack_val_cmp_t) (sst sst': sstate)
  (flag: bool),
valid_sstate sst evm_stack_opm ->
opt_sbinding_snd opt ->
safe_sstack_val_cmp fcmp ->
optimize_first_sstate opt fcmp sst = (sst', flag) ->
valid_sstate sst' evm_stack_opm.
Proof.
intros opt fcmp sst sst' flag Hvalid Hopt Hsafe_cmp Hopt_first.
unfold valid_sstate in Hvalid.
destruct sst. destruct sm. simpl in Hvalid.
destruct Hvalid as [Hvalid_smap [Hvalid_sstack [Hvalid_smemory Hvalid_sstorage]]].
unfold optimize_first_sstate in Hopt_first.
destruct (optimize_first_sbindings opt fcmp bindings instk_height) as
  [bindings' flag'] eqn: eq_optim_first.
injection Hopt_first as eq_sst' eq_flag'.
rewrite <- eq_sst'.
unfold valid_sstate. simpl.
split.
- unfold valid_smap in Hvalid_smap.
  pose proof (optimize_first_valid opt fcmp bindings bindings' maxid 
    instk_height flag' Hsafe_cmp Hopt Hvalid_smap eq_optim_first).
  assumption.
- split; try split; try assumption.
Qed.


Lemma optimize_first_sstate_preserv: forall (opt: opt_smap_value_type) 
  (fcmp: sstack_val_cmp_t) (sst sst': sstate)
  (flag: bool),
valid_sstate sst evm_stack_opm ->
opt_sbinding_snd opt ->
safe_sstack_val_cmp fcmp ->
optimize_first_sstate opt fcmp sst = (sst', flag) ->
 get_instk_height_sst sst = get_instk_height_sst sst' /\
 forall (st st': state), eval_sstate st sst  evm_stack_opm = Some st' ->
                         eval_sstate st sst' evm_stack_opm = Some st'.
Proof.
intros opt fcmp sst sst' flag Hvalid Hopt Hsafe_cmp Hopt_first.
destruct sst. destruct sm. 
unfold optimize_first_sstate in Hopt_first.
destruct (optimize_first_sbindings opt fcmp bindings instk_height)
  as [bindings' flag'] eqn: eq_optim_first.
injection Hopt_first as eq_sst' eq_flag.
rewrite <- eq_sst'. simpl.
split; try reflexivity.
intros st st' Heval_sst.
unfold eval_sstate in Heval_sst.
simpl in Heval_sst.
destruct (instk_height =? length (get_stack_st st)) eqn: eq_instk;
  try discriminate.
destruct (eval_sstack sstk maxid bindings (get_stack_st st)
                (get_memory_st st) (get_storage_st st) 
                (get_externals_st st) evm_stack_opm)
  as [s|] eqn: eq_eval_sstack; try discriminate.
destruct (eval_smemory smem maxid bindings (get_stack_st st)
                (get_memory_st st) (get_storage_st st) 
                (get_externals_st st) evm_stack_opm)
  as [m|] eqn: eq_eval_smem; try discriminate.
destruct (eval_sstorage sstg maxid bindings (get_stack_st st)
                (get_memory_st st) (get_storage_st st) 
                (get_externals_st st) evm_stack_opm)
  as [strg|] eqn: eq_eval_strg; try discriminate.
unfold eval_sstate. simpl. rewrite -> eq_instk.
simpl in Hvalid.
unfold valid_sstate in Hvalid. simpl in Hvalid.
destruct Hvalid as [Hvalid_smap [Hvalid_sstack [Hvalid_smem Hvalid_strg]]].
unfold valid_smap in Hvalid_smap.
pose proof (opt_sbinding_preserves opt fcmp bindings bindings' maxid 
  instk_height flag' Hsafe_cmp Hopt Hvalid_smap eq_optim_first)
  as Hpreservs_bind_bind'.
apply PeanoNat.Nat.eqb_eq in eq_instk.
pose proof (preserv_sbindings_sstack bindings bindings' maxid evm_stack_opm
  instk_height Hpreservs_bind_bind' sstk (get_stack_st st) s 
  (get_memory_st st) (get_storage_st st) (get_externals_st st)
  eq_instk eq_eval_sstack) as eq_eval_sstack'.
rewrite -> eq_eval_sstack'.
pose proof (preserv_sbindings_smemory bindings bindings' maxid evm_stack_opm
  instk_height Hpreservs_bind_bind' smem (get_stack_st st) (get_memory_st st)
  m (get_storage_st st) (get_externals_st st) eq_instk eq_eval_smem)
  as eq_eval_smem'.
rewrite -> eq_eval_smem'.
pose proof (preserv_sbindings_sstorage bindings bindings' maxid evm_stack_opm
  instk_height Hpreservs_bind_bind' (get_stack_st st) sstg (get_memory_st st)
  (get_storage_st st) strg (get_externals_st st) eq_instk eq_eval_strg)
  as eq_eval_strg'.
rewrite -> eq_eval_strg'.
assumption.
Qed.


Lemma instk_height_optimize_sst: forall opt fcmp sst sst' flag,
optimize_first_sstate opt fcmp sst = (sst', flag) ->
get_instk_height_sst sst = get_instk_height_sst sst'.
Proof.
intros opt fcmp sst sst' flag Hoptim.
unfold optimize_first_sstate in Hoptim.
destruct sst eqn: eq_sst. destruct sm eqn: eq_sm.
destruct (optimize_first_sbindings opt fcmp bindings instk_height) 
  as [bindings' flag'] eqn: eq_optim_first.
injection Hoptim as eq_sst' eq_flag.
rewrite <- eq_sst'.
reflexivity.
Qed.


Lemma optimize_first_snd_opt_snd: forall opt fcmp,
safe_sstack_val_cmp fcmp ->
opt_sbinding_snd opt ->
optim_snd (optimize_first_sstate opt fcmp).
Proof.
intros opt fcmp Hsafe_fcmp Hopt_snd.
unfold optim_snd. intros sst sst' b Hvalid_sst Hoptim.
split. 
- apply optimize_first_sstate_valid with (opt:=opt)
  (fcmp:=fcmp)(sst:=sst)(flag:=b); try assumption.
- split.
  + apply instk_height_optimize_sst with (opt:=opt)
    (fcmp:=fcmp)(flag:=b). 
    assumption.
  + intros st st' Heval.
    pose proof (instk_height_optimize_sst opt fcmp sst 
      sst' b Hoptim) as Hinstk.
    pose proof (optimize_first_sstate_preserv opt fcmp sst sst' b Hvalid_sst
      Hopt_snd Hsafe_fcmp Hoptim) as Hpreserv.
    destruct Hpreserv as [_ Heval2_imp].
    apply Heval2_imp.
    assumption.
Qed.


Lemma valid_bindings_snd_opt: forall instk_height maxidx n val sb opt fcmp 
  val' flag,
valid_bindings instk_height maxidx ((n, val) :: sb) evm_stack_opm ->
opt_smapv_valid_snd opt ->
safe_sstack_val_cmp fcmp ->
opt val fcmp sb n instk_height evm_stack_opm = (val', flag) ->
valid_bindings instk_height maxidx ((n, val') :: sb) evm_stack_opm.
Proof.
intros instk_height maxidx n val sb opt fcmp val' flag.
intros Hvalid Hopt_smapv_snd Hfcmp Hopt.
unfold opt_smapv_valid_snd in Hopt_smapv_snd.
unfold valid_bindings in Hvalid.
unfold valid_bindings.
destruct Hvalid as [Hmaxidx [Hvalid_smapv_val Hvalid_sb]].
fold valid_bindings in Hvalid_sb.
pose proof (Hopt_smapv_snd instk_height n fcmp sb val val' flag
Hfcmp Hvalid_smapv_val Hvalid_sb Hopt) as Hvalid_smapv_val'.
split; try split; try assumption.
Qed.





(* Pipeline of sound optimizations *)

Inductive opt_entry :=
| OpEntry (opt: opt_smap_value_type) (H_snd: opt_sbinding_snd opt).

Definition opt_pipeline := list opt_entry.



(************************************************************************ 
   Optimization strategies using optimization pipelines opt_entries and
   optimizations pipelines
*************************************************************************)

(* Applies the optimization once in the first possible place inside
   the bindings
*)
Definition optimize_first_opt_entry_sbindings (opt_entry: opt_entry)
  (fcmp: sstack_val_cmp_t) (instk_height: nat) (sb: sbindings)
    : sbindings*bool :=
match opt_entry with
| OpEntry opt_sbinding Hopt_snd => 
    optimize_first_sbindings opt_sbinding fcmp sb instk_height
end.


(* Applies the optimization once in the first possible place inside
   the bindings __of the sstate__
*)
Definition optimize_first_opt_entry_sstate (opt_e: opt_entry) 
  (fcmp: sstack_val_cmp_t) (sst: sstate) : sstate*bool :=
match opt_e with
| OpEntry opt Hopt_snd =>
  optimize_first_sstate opt fcmp sst
end.


(* Applies the optimization at most n times in a sstate, stops as soon as it
   does not change the sstate *)
Fixpoint apply_opt_n_times (opt_e: opt_entry) (fcmp: sstack_val_cmp_t) 
  (n: nat) (sst: sstate) : sstate*bool :=
match n with
| 0 => (sst, false) 
| S n' => 
    match optimize_first_opt_entry_sstate opt_e fcmp sst with
    | (sst', true) => 
        match apply_opt_n_times opt_e fcmp n' sst' with
        | (sst'', b) => (sst'', true) 
        end
    | (sst', false) => (sst', false)
    end
end.
(* Improvement: extra parameter as flag accumulator for final recursion, 
     if needed for efficiency *)


(* Applies the pipeline in order in a sstate, applying n times each 
   optimization and continuing with the next one *)
Fixpoint apply_opt_n_times_pipeline_once (pipe: opt_pipeline) 
  (fcmp: sstack_val_cmp_t) (n: nat) (sst: sstate) : sstate*bool :=
match pipe with
| [] => (sst, false) 
| opt_e::rp => 
    match apply_opt_n_times opt_e fcmp n sst with
    | (sst', flag1) => 
        match apply_opt_n_times_pipeline_once rp fcmp n sst' with
        | (sst'', flag2) => (sst'', orb flag1 flag2)
        end
    end
end.


(* Applies (apply_opt_n_times_pipeline n) at most k times in a sstate, stops 
   as soon as it does not change the sstate *)
Fixpoint apply_opt_n_times_pipeline_k (pipe: opt_pipeline)
  (fcmp: sstack_val_cmp_t) 
  (n k: nat) (sst: sstate) : sstate*bool :=
match k with
| 0 => (sst, false) 
| S k' => 
    let _ := print_id [k] in
    match apply_opt_n_times_pipeline_once pipe fcmp n sst with
    | (sst', true) => 
        match apply_opt_n_times_pipeline_k pipe fcmp n k' sst'  with
        | (sst'', b) => (sst'', true) 
        end
    | (sst', false) => (sst', false)
    end
end.
(* Improvement: extra parameter as flag accumulator for final recursion, 
     if needed for efficiency *)



Lemma optimize_first_opt_entry_sstate_snd: forall opt_e fcmp,
safe_sstack_val_cmp fcmp ->
optim_snd (optimize_first_opt_entry_sstate opt_e fcmp).
Proof.
intros opt_e fcmp Hsafe_fcmp.
unfold optim_snd. intros sst sst' b Hvalid Hoptim_first.
unfold optimize_first_opt_entry_sstate in Hoptim_first.
destruct opt_e as [opt Hopt_snd] eqn: eq_opt_e.
split.
- pose proof (optimize_first_sstate_valid opt fcmp sst sst' b Hvalid
    Hopt_snd Hsafe_fcmp Hoptim_first).
  assumption.
- split.
  + unfold optimize_first_sstate in Hoptim_first. 
    destruct sst as [instk_height sstk smem sstg sexts smap] eqn: eq_sst.
    destruct smap as [maxid bindings] eqn: eq_smap.
    destruct (optimize_first_sbindings opt fcmp bindings instk_height).
    injection Hoptim_first as eq_sst' _. 
    rewrite <- eq_sst'. reflexivity. 
  + pose proof (optimize_first_sstate_preserv opt fcmp sst sst' b Hvalid
      Hopt_snd Hsafe_fcmp Hoptim_first) as H1.
    destruct H1 as [_ H2].
    assumption.
Qed.


Lemma apply_opt_n_times_snd: forall opt_e fcmp n,
safe_sstack_val_cmp fcmp ->
optim_snd (apply_opt_n_times opt_e fcmp n).
Proof.
intros opt_e fcmp n. revert opt_e fcmp.
induction n as [| n' IH].
- intros opt_e fcmp Hsafe_cmp.
  unfold optim_snd.
  intros sst sst' b Hvalid Happly.
  simpl in Happly. injection Happly as eq_sst' _.
  rewrite <- eq_sst'.
  split; try assumption.
  split.
  + reflexivity.
  + intuition.
- intros opt_e fcmp Hsafe_cmp.
  unfold optim_snd.
  intros sst sst' b Hvalid Happly.
  simpl in Happly. 
  destruct (optimize_first_opt_entry_sstate opt_e fcmp sst) 
    as [sst1 flag] eqn: eq_optim.
  destruct flag eqn: eq_flag.
  + destruct (apply_opt_n_times opt_e fcmp n' sst1) as [sst2 flag2] 
      eqn: eq_apply_n'.
    injection Happly as eq_sst' _.
    rewrite <- eq_sst'.
    pose proof (optimize_first_opt_entry_sstate_snd opt_e fcmp Hsafe_cmp)
      as Hoptim_snd.
    unfold optim_snd in Hoptim_snd.
    pose proof (Hoptim_snd sst sst1 true Hvalid eq_optim) as Hone.
    destruct Hone as [Hvalid1 [Hinstk Heval]].
    pose proof (IH opt_e fcmp Hsafe_cmp) as IHn'.
    unfold optim_snd in IHn'.
    pose proof (IHn' sst1 sst2 flag2 Hvalid1 eq_apply_n') as HIHn'.
    destruct HIHn' as [Hvalid' [Hinstk' Heval']].
    split; try assumption.
    split.
    * rewrite <- Hinstk in Hinstk'. assumption.
    * intros st st' Heval_st. 
      apply Heval'. apply Heval. assumption.
  + injection Happly as eq_sst' _.
    rewrite <- eq_sst'.
    pose proof (optimize_first_opt_entry_sstate_snd opt_e fcmp Hsafe_cmp)
      as Hoptim_snd.
    unfold optim_snd in Hoptim_snd.
    pose proof (Hoptim_snd sst sst1 false Hvalid eq_optim) as Hone.
    destruct Hone as [Hvalid1 [Hinstk Heval]].
    split; try assumption.
    split; try assumption.
Qed.


Lemma apply_opt_n_times_pipeline_once_snd: forall pipe fcmp n,
safe_sstack_val_cmp fcmp ->
optim_snd (apply_opt_n_times_pipeline_once pipe fcmp n).
Proof.
induction pipe as [| opt_e rp IH].
- intros fcmp n Hsafe_cmp.
  unfold optim_snd.
  intros sst sst' b Hvalid Happly.
  simpl in Happly. injection Happly as eq_sst' _.
  rewrite <- eq_sst'.
  split; try assumption.
  split.
  + reflexivity.
  + intuition.
- intros fcmp n Hsafe_cmp.
  unfold optim_snd.
  intros sst sst' b Hvalid Happly.
  simpl in Happly. 
  destruct (apply_opt_n_times opt_e fcmp n sst) 
    as [sst1 flag1] eqn: eq_optim_h.
  destruct (apply_opt_n_times_pipeline_once rp fcmp n sst1) as [sst2 flag2] 
    eqn: eq_optim_rp.
  injection Happly as eq_sst' _.
  rewrite <- eq_sst'.
  pose proof (apply_opt_n_times_snd opt_e fcmp n Hsafe_cmp) as Hoptim_snd_h.
  unfold optim_snd in Hoptim_snd_h.
  pose proof (Hoptim_snd_h sst sst1 flag1 Hvalid eq_optim_h) as Hoptim_snd_h.
  destruct Hoptim_snd_h as [Hvalid1 [Hinstk1 Heval1]].
  pose proof (IH fcmp n Hsafe_cmp) as IH.
  unfold optim_snd in IH.
  pose proof (IH sst1 sst2 flag2 Hvalid1 eq_optim_rp) as IH.
  destruct IH as [Hvalid2 [Hinstk2 Heval2]].
  split; try assumption.
  split.
  + rewrite <- Hinstk2. assumption.
  + intros st st' Heval_sst.
    apply Heval2. apply Heval1. assumption.
Qed.


Lemma apply_opt_n_times_pipeline_k_snd: forall pipe fcmp n k,
safe_sstack_val_cmp fcmp ->
optim_snd (apply_opt_n_times_pipeline_k pipe fcmp n k).
Proof.
intros pipe fcmp n k. revert pipe fcmp n.
induction k as [| k' IH].
- intros pipe fcmp Hsafe_cmp n.
  unfold optim_snd.
  intros sst sst' b Hvalid Happly.
  simpl in Happly. injection Happly as eq_sst' _.
  rewrite <- eq_sst'.
  split; try assumption.
  split.
  + reflexivity.
  + intuition.
- intros pipe fcmp n Hsafe_cmp.
  unfold optim_snd.
  intros sst sst' b Hvalid Happly.
  simpl in Happly. 
  destruct (apply_opt_n_times_pipeline_once pipe fcmp n sst) 
    as [sst1 flag1] eqn: eq_optim.
  destruct flag1 eqn: eq_flag1.
  + destruct (apply_opt_n_times_pipeline_k pipe fcmp n k' sst1) as [sst2 flag2] 
      eqn: eq_apply_n'.
    injection Happly as eq_sst' _.
    rewrite <- eq_sst'.
    pose proof (apply_opt_n_times_pipeline_once_snd pipe fcmp n Hsafe_cmp)
      as Hoptim_snd.
    unfold optim_snd in Hoptim_snd.
    pose proof (Hoptim_snd sst sst1 true Hvalid eq_optim) as Hone.
    destruct Hone as [Hvalid1 [Hinstk Heval1]].
    pose proof (IH pipe fcmp n Hsafe_cmp) as IH.
    unfold optim_snd in IH.
    pose proof (IH sst1 sst2 flag2 Hvalid1 eq_apply_n') as IH.
    destruct IH as [Hvalid' [Hinstk' Heval']].
    split; try assumption.
    split.
    * rewrite <- Hinstk in Hinstk'. assumption.
    * intros st st' Heval_st. 
      apply Heval'. apply Heval1. assumption.
  + injection Happly as eq_sst' _.
    rewrite <- eq_sst'.
    pose proof (apply_opt_n_times_pipeline_once_snd pipe fcmp n Hsafe_cmp)
      as Hoptim_snd.
    unfold optim_snd in Hoptim_snd.
    pose proof (Hoptim_snd sst sst1 false Hvalid eq_optim) as Hone.
    destruct Hone as [Hvalid1 [Hinstk Heval]].
    split; try assumption.
    split; try assumption.
Qed.




End Optimizations_Def.

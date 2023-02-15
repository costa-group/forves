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

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import List.
Import ListNotations.


Module Optimizations_Def.


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

Lemma eval_sstack_val'_one_step: forall d' sv stk mem strg ctx maxidx sb ops,
eval_sstack_val' (S d') sv stk mem strg ctx maxidx sb ops =
      match follow_in_smap sv maxidx sb with
      | None => None
      | Some (FollowSmapVal smv maxidx' sb') =>
          match smv with
          (* Concrere values are retuned *)
          | SymBasicVal (Val v) => Some v

          (* A stack element 'InStackVar n' takes its value from the n-th element of the concrete stack *)                  
          | SymBasicVal (InStackVar n) =>
              match nth_error stk n with
              | Some v => Some v
              | None => None
              end

          (* Not possible *)
          | SymBasicVal (FreshVar _) => None

          (* PUSHTAG *)
          | SymPUSHTAG v =>
              let tags := (get_tags_ctx ctx) in Some (tags v)

          (* stack operation instruction: we evaluate the argument
             recursively and then evaluate the corresponding operation *)
          | SymOp label args =>
              match ops label with
              | OpImp nargs f _ _ =>
                  (* first check that the number of argumets agree with what is declared in the map *)
                  if (List.length args =? nargs) then
                    let f_eval_list := fun (sv': sstack_val) => eval_sstack_val' d' sv' stk mem strg ctx maxidx' sb' ops in
                    match map_option f_eval_list args with
                    | None => None
                    | Some vargs => Some (f ctx vargs)
                    end
                  else None
              end
 
            (* memory read: 
                1. evaluate the updates, i.e., instantiate the symbolic arguments of the updates by concrete values
                2. evaluate the offset
                3. apply the updates to the memory of the concrete initial state 'st'
                4. look for the desired value in the memory 
             *)
            | SymMLOAD soffset smem =>
                let f_eval_mem_update := instantiate_memory_update (fun sv => eval_sstack_val' d' sv stk mem strg ctx maxidx' sb' ops) in
                match map_option f_eval_mem_update smem with (* Evaluate the arguments of the updates *)
                | None => None
                | Some mem_updates =>
                    match eval_sstack_val' d' soffset stk mem strg ctx maxidx' sb' ops with (* Evaluate the offset *)
                    | None => None
                    | Some offset =>
                        let mem := update_memory mem mem_updates in (* apply updates to the memory *)
                        Some (mload mem offset) (* lookup for the desired value in the memory *)
                    end
                end
                  
            (* storage read: 
             1. evaluate the updates, i.e., instantiate the symbolic arguments of the updates by concrete values
             2. evaluate the key
             3. apply the updates to the storage of the concrete initial state 'st'
                4. look for the desired value in the stroarge 
            *)
            | SymSLOAD skey sstrg =>
                let f_eval_strg_update := instantiate_storage_update (fun sv => eval_sstack_val' d' sv stk mem strg ctx maxidx' sb' ops) in
                match map_option f_eval_strg_update sstrg with (* Evaluate the arguments of the updates *)
                | None => None
                | Some strg_updates =>
                    match eval_sstack_val' d' skey stk mem strg ctx maxidx' sb' ops with (* Evaluate the key *)
                    | None => None
                    | Some key =>
                        let strg := update_storage strg strg_updates in (* apply updates to the storage *)
                        Some (sload strg key) (* lookup for the desired value in the storage *)
                    end
                end

            (* SHA3/KECCAK256: 
                1. evaluate the updates, i.e., instantiate the symbolic arguments of the updates by concrete values
                2. evaluate the offset/size
                3. apply the updates to the memeory of the concrete initial state 'st'
                4. apply the SHA3 function that is given in the context 
             *)
            | SymSHA3 soffset ssize smem =>
                let f_eval_mem_update := instantiate_memory_update (fun sv => eval_sstack_val' d' sv stk mem strg ctx maxidx' sb' ops) in
                match map_option f_eval_mem_update smem with (* Evaluate the arguments of the updates *)
                | None => None
                | Some mem_updates =>
                    match eval_sstack_val' d' soffset stk mem strg ctx maxidx' sb' ops with (* Evaluate the offset *)
                    | None => None
                    | Some offset =>
                        match eval_sstack_val' d' ssize stk mem strg ctx maxidx' sb' ops with (* Evaluate the size *)
                        | None => None
                        | Some size =>
                            let mem := update_memory mem mem_updates in (* apply updates to the memory *)
                            let f_sha3 := (get_keccak256_ctx ctx) in (* get the sha3 function from the context and ... *)
                            Some (f_sha3 (wordToNat size) (mload' mem offset (wordToNat size))) (* ... apply it to the corresponding data *)
                        end
                    end
                end
          end
      end.
Proof.
intuition.
Qed.


Lemma follow_in_smap_chain: forall n1 n2 sb,
follow_in_smap (FreshVar n1) n1 ((n1, SymBasicVal (FreshVar n2)) :: sb) =
follow_in_smap (FreshVar n2) n1 sb.
Proof.
intros n1 n2 sb.
unfold follow_in_smap.
rewrite -> PeanoNat.Nat.eqb_refl. simpl. fold follow_in_smap.
reflexivity.
Qed.

(* TODO can it be used for proving preserv_sbindings_ext??? *)
Lemma eval_stack_val_fvar_chain: forall n1 n2 stk mem strg ctx sb 
  ops,
eval_sstack_val (FreshVar n1) stk mem strg ctx n1
  ((n1, SymBasicVal (FreshVar n2)) :: sb) ops = 
eval_sstack_val (FreshVar n2) stk mem strg ctx n1 sb ops.
Proof.
intros n1 n2 stk mem strg ctx sb ops.
unfold eval_sstack_val.
rewrite -> eval_sstack_val'_one_step.
rewrite -> eval_sstack_val'_one_step.
rewrite -> follow_in_smap_chain.
reflexivity.
Qed.


(*
Search preserv_sbindings.

Lemma prserv_sbindings_succ: forall sb1 sb2 n ops instk_height,
preserv_sbindings sb1 sb2 n ops instk_height ->
preserv_sbindings sb1 sb2 (S n) ops instk_height.
Proof.
intros sb1 sb2 n ops instk_height Hpreserv.
unfold preserv_sbindings.
*)

(*
Lemma preserv_eval_imp_succ: forall sv sb1 sb2  stk mem strg ctx n ops v,
(eval_sstack_val sv stk mem strg ctx n sb1 ops = Some v ->
 eval_sstack_val sv stk mem strg ctx n sb2 ops = Some v) ->
(eval_sstack_val sv stk mem strg ctx (S n) sb1 ops = Some v ->
 eval_sstack_val sv stk mem strg ctx (S n) sb2 ops = Some v).
Proof.
intros sv sb1 sb2  stk mem strg ctx n ops v Himpl Heval.
intuition.
*)

(*Lemma preserv_sbindings_ext2: forall (sb1 sb2 p: sbindings) 
  (ops: stack_op_instr_map) (n m: nat) (instk_height: nat),
preserv_sbindings sb1 sb2 n ops instk_height ->
length p = m ->
valid_bindings instk_height (n+m) (p++sb1) ops ->
preserv_sbindings (p++sb1) (p++sb2) (n+m) ops instk_height.
Proof.
intros sb1 sb2 p. revert sb1 sb2.
induction p as [|h r IH].
- intros sb1 sb2 ops n m instk_height Hpreserv Hlen Hvalid.
  simpl. simpl in Hlen. rewrite <- Hlen. rewrite -> PeanoNat.Nat.add_0_r. 
  assumption.
- intros sb1 sb2 ops n m instk_height Hpreserv Hlen Hvalid.
  unfold preserv_sbindings.
  split; try split.
  + assumption.
  + admit.
  + intros sv stk mem strg ctx v Hinstk Heval. 
Admitted.*)

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
  + intros sv stk mem strg ctx v Hlen Heval.
    destruct sv as [val|var|fvar] eqn: eq_sv.
    * unfold eval_sstack_val. simpl.
      unfold eval_sstack_val in Heval. simpl in Heval.
      assumption.
    * unfold eval_sstack_val. simpl.
      unfold eval_sstack_val in Heval. simpl in Heval.
      assumption.
    * destruct (fvar =? n) eqn: eq_fvar_n.
      -- apply PeanoNat.Nat.eqb_eq in eq_fvar_n.
         rewrite -> eq_fvar_n. rewrite -> eq_fvar_n in Heval.
         destruct smapv eqn: eq_smapv.
         ++ (* SymBasicVal val *) 
            destruct val as [value|var|fvarv] eqn: eq_val.
            ** unfold eval_sstack_val. simpl.
               rewrite -> PeanoNat.Nat.eqb_refl. 
               unfold eval_sstack_val in Heval. simpl in Heval.
               rewrite -> PeanoNat.Nat.eqb_refl in Heval.
               assumption. 
            ** unfold eval_sstack_val. simpl.
               rewrite -> PeanoNat.Nat.eqb_refl. 
               unfold eval_sstack_val in Heval. simpl in Heval.
               rewrite -> PeanoNat.Nat.eqb_refl in Heval.
               assumption. 
            ** rewrite -> Hmaxidx in Heval. 
               admit.
               (*rewrite -> eval_stack_val_fvar_chain in Heval.
               rewrite -> Hmaxidx.
               rewrite -> eval_stack_val_fvar_chain.
               pose proof (Hpreserv (FreshVar fvarv) stk mem strg ctx v
                 Hlen Heval). 
               assumption.*)
         ++ unfold eval_sstack_val in Heval. simpl in Heval. 
            rewrite -> PeanoNat.Nat.eqb_refl in Heval.
            unfold eval_sstack_val. simpl. 
            rewrite -> PeanoNat.Nat.eqb_refl.
            assumption.
         ++ unfold eval_sstack_val in Heval. simpl in Heval. 
            rewrite -> PeanoNat.Nat.eqb_refl in Heval.
            unfold eval_sstack_val. simpl. 
            rewrite -> PeanoNat.Nat.eqb_refl.
            unfold eval_sstack_val in Hpreserv.
            rewrite <- Hmaxidx in Hpreserv.
            admit.
         ++ unfold eval_sstack_val in Heval. simpl in Heval. 
            rewrite -> PeanoNat.Nat.eqb_refl in Heval.
            unfold eval_sstack_val. simpl. 
            rewrite -> PeanoNat.Nat.eqb_refl.
            unfold eval_sstack_val in Hpreserv.
            rewrite <- Hmaxidx in Hpreserv.
            admit.
         ++ unfold eval_sstack_val in Heval. simpl in Heval. 
            rewrite -> PeanoNat.Nat.eqb_refl in Heval.
            unfold eval_sstack_val. simpl. 
            rewrite -> PeanoNat.Nat.eqb_refl.
            unfold eval_sstack_val in Hpreserv.
            rewrite <- Hmaxidx in Hpreserv.
            admit.
         ++ unfold eval_sstack_val in Heval. simpl in Heval. 
            rewrite -> PeanoNat.Nat.eqb_refl in Heval.
            unfold eval_sstack_val. simpl. 
            rewrite -> PeanoNat.Nat.eqb_refl.
            unfold eval_sstack_val in Hpreserv.
            rewrite <- Hmaxidx in Hpreserv.
            admit.
      -- rewrite -> eval_fvar_diff; try assumption.
         rewrite -> eval_fvar_diff in Heval; try assumption.
         apply Hpreserv in Heval; try assumption.
Admitted.

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
  unfold instantiate_memory_update in Heval_mem at 1.
  simpl.
  
  (*rewrite <- map_option_ho.
  destruct h eqn: eq_h.
  + (* U_MSTORE *)
    destruct (eval_sstack_val offset stk mem strg ctx maxidx sb1 ops) as
      [offsetv|] eqn: eq_eval_offset; try discriminate.
    destruct (eval_sstack_val value stk mem strg ctx maxidx sb1 ops) as
      [valuev|] eqn: eq_eval_value; try discriminate.
    fold eval_smemory in Heval_mem.
  + (* U_MSTORE8 *)
    admit.*)
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


(* Changing a preseving sbinding in a sstate preserves successful 
   evaluations *)
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
Definition opt_smap_value_type := 
  smap_value ->            (* val *)
  sstack_val_cmp_t ->      (* fcmp *) 
  sbindings ->             (* sb *)
  nat ->                   (* maxid *) 
  nat ->                   (* instk_height *)
  stack_op_instr_map ->    (* ops *)
  smap_value*bool.         (* (val', flag) *)


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


Lemma valid_sstack_value_succ: forall instk_height n sv,
valid_sstack_value instk_height n sv ->
valid_sstack_value instk_height (S n) sv.
Proof.
intros instk_height n sv Hvalid.
unfold valid_sstack_value in Hvalid.
destruct sv as [v|var|fvar].
- intuition.
- intuition.
- simpl. intuition.
Qed.

Lemma valid_sstack_succ: forall instk_height n sstk,
valid_sstack instk_height n sstk ->
valid_sstack instk_height (S n) sstk.
Proof.
intros instk_height n sstk. revert instk_height n. 
induction sstk as [| h r IH].
- intuition.
- intros instk_height n Hvalid.
  unfold valid_sstack in Hvalid.
  destruct Hvalid as [Hvalid_sstack_value Hvalid_sstack'].
  fold valid_sstack in Hvalid_sstack'.
  unfold valid_sstack.
  split.
  + apply valid_sstack_value_succ. assumption.
  + fold valid_sstack. apply IH. assumption.
Qed.

Lemma valid_smemory_update_succ: forall instk_height n mem_upd,
valid_smemory_update instk_height n mem_upd ->
valid_smemory_update instk_height (S n) mem_upd.
Proof.
intros instk_height n mem_upd Hvalid.
destruct mem_upd eqn: eq_mem_upd.
- simpl in Hvalid.
  destruct Hvalid as [Hvalid_offset Hvalid_value].
  simpl. split.
  + apply valid_sstack_value_succ. assumption.
  + apply valid_sstack_value_succ. assumption.
- simpl in Hvalid.
  destruct Hvalid as [Hvalid_offset Hvalid_value].
  simpl. split.
  + apply valid_sstack_value_succ. assumption.
  + apply valid_sstack_value_succ. assumption.
Qed.


Lemma valid_smemory_succ: forall instk_height n smem,
valid_smemory instk_height n smem ->
valid_smemory instk_height (S n) smem.
Proof.
intros instk_height n smem. revert instk_height n.
induction smem as [|mem_upd rmem IH]. 
- intuition.
- intros instk_height n Hvalid.
  unfold valid_smemory in Hvalid.
  destruct Hvalid as [Hvalid_mem_upd Hvalid_smem_r].
  fold valid_smemory in Hvalid_smem_r.
  simpl. split.
  + apply valid_smemory_update_succ. assumption.
  + apply IH. assumption.
Qed.


Lemma valid_sstorage_succ: forall instk_height n sstr,
valid_sstorage instk_height n sstr ->
valid_sstorage instk_height (S n) sstr.
Proof.
intros instk_height n sstr. revert instk_height n.
induction sstr as [|sstr_upd rsstr IH].
- intuition.
- intros instk_height n Hvalid.
  unfold valid_sstorage in Hvalid.
  destruct Hvalid as [Hvalid_sstr_upd Hvalid_rsstr].
  fold valid_sstorage in Hvalid_rsstr.
  simpl. split.
  + destruct (sstr_upd) eqn: eq_sstr_upd.
    unfold valid_sstorage_update in Hvalid_sstr_upd.
    destruct Hvalid_sstr_upd as [Hvalid_key Hvalid_value].
    simpl. split.
    * apply valid_sstack_value_succ. assumption.
    * apply valid_sstack_value_succ. assumption.
  + apply IH. assumption.
Qed.


Lemma valid_smap_value_succ: forall instk_height n ops smapv,
valid_smap_value instk_height n ops smapv ->
valid_smap_value instk_height (S n) ops smapv.
Proof.
intros instk_height n ops smapv Hvalid.
unfold valid_smap_value in Hvalid.
destruct smapv as [v|tag|label args|offset smem|key sstr|offset size mem]
  eqn: eq_smapv.
- simpl. apply valid_sstack_value_succ. assumption.
- intuition.
- unfold valid_stack_op_instr in Hvalid. 
  destruct (ops label) as [nargs f Hcomm Hctx] eqn: eq_ops_label.
  destruct Hvalid as [Hlen Hvalid2].
  simpl. unfold valid_stack_op_instr. rewrite -> eq_ops_label.
  split; try assumption.
  apply valid_sstack_succ. assumption.
- destruct Hvalid as [Hvalid_offset Hvalid_smem].
  unfold valid_smap_value.
  split. 
  + apply valid_sstack_value_succ. assumption.
  + apply valid_smemory_succ. assumption.
- destruct Hvalid as [Hvalid_key Hvalid_sstr].
  simpl. split.
  + apply valid_sstack_value_succ. assumption.
  + apply valid_sstorage_succ. assumption.
- destruct Hvalid as [Hvalid_offset [Hvalid_size Hvalid_smem]].
  simpl. split; try split.
  + apply valid_sstack_value_succ. assumption.
  + apply valid_sstack_value_succ. assumption.
  + apply valid_smemory_succ. assumption.
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
      (*rewrite -> eq_maxid_n.
      apply valid_smap_value_succ; try assumption.*)
Qed.



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
                (get_context_st st) evm_stack_opm)
  as [s|] eqn: eq_eval_sstack; try discriminate.
destruct (eval_smemory smem maxid bindings (get_stack_st st)
                (get_memory_st st) (get_storage_st st) 
                (get_context_st st) evm_stack_opm)
  as [m|] eqn: eq_eval_smem; try discriminate.
destruct (eval_sstorage sstg maxid bindings (get_stack_st st)
                (get_memory_st st) (get_storage_st st) 
                (get_context_st st) evm_stack_opm)
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
  (get_memory_st st) (get_storage_st st) (get_context_st st)
  eq_instk eq_eval_sstack) as eq_eval_sstack'.
rewrite -> eq_eval_sstack'.
pose proof (preserv_sbindings_smemory bindings bindings' maxid evm_stack_opm
  instk_height Hpreservs_bind_bind' smem (get_stack_st st) (get_memory_st st)
  m (get_storage_st st) (get_context_st st) eq_instk eq_eval_smem)
  as eq_eval_smem'.
rewrite -> eq_eval_smem'.
pose proof (preserv_sbindings_sstorage bindings bindings' maxid evm_stack_opm
  instk_height Hpreservs_bind_bind' (get_stack_st st) sstg (get_memory_st st)
  (get_storage_st st) strg (get_context_st st) eq_instk eq_eval_strg)
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

(*
Lemma eval_freshv_top: forall maxidx idx stk mem strg ctx arg2 sb ops,
eval_sstack_val' (S maxidx) (FreshVar idx) stk mem strg ctx maxidx
  ((idx, SymBasicVal arg2) :: sb) ops =
eval_sstack_val' maxidx arg2 stk mem strg ctx maxidx sb ops.
Proof.
Admitted.
*)

Lemma valid_sstack_value_const: forall instk_height idx v,
valid_sstack_value instk_height idx (Val v).
Proof.
intros. simpl. intuition.
Qed.


Lemma Hvalid_maxidx: forall instk_height maxidx idx val sb ops,
valid_bindings instk_height maxidx ((idx, val) :: sb) ops ->
S idx = maxidx.
Proof.
intros instk_height maxidx idx val sb ops Hvalid.
unfold valid_bindings in Hvalid.
intuition.
Qed.


Lemma follow_in_smap_head_op: forall idx maxidx label args sb,
follow_in_smap (FreshVar idx) maxidx ((idx, SymOp label args) :: sb) = 
Some (FollowSmapVal (SymOp label args) idx sb).
Proof.
intros. simpl. rewrite -> PeanoNat.Nat.eqb_refl.
reflexivity.
Qed.


Lemma is_fresh_var_smv_fvar: forall fvar,
is_fresh_var_smv (SymBasicVal (FreshVar fvar)) = Some fvar.
Proof.
intuition.
Qed.

Lemma follow_in_smap_head: forall idx m sv sb,
follow_in_smap (FreshVar idx) m ((idx, SymBasicVal sv) :: sb) =
follow_in_smap sv idx sb.
Proof.
intros idx m sv sb.
unfold follow_in_smap at 1.
rewrite -> PeanoNat.Nat.eqb_refl.
fold follow_in_smap.
destruct sv as [val|var|fvar] eqn: eq_sv.
- simpl. destruct sb; try reflexivity.
- simpl. destruct sb; try reflexivity.
- simpl. reflexivity.
Qed.

(* TODO: remove and use follow_in_smap_head instead *)
Lemma follow_in_smap_head_fvar_head: forall idx m fvar sb,
follow_in_smap (FreshVar idx) m ((idx, SymBasicVal (FreshVar fvar)) :: sb) =
follow_in_smap (FreshVar fvar) idx sb.
Proof.
intros. apply follow_in_smap_head.
Qed.


Lemma follow_in_smap_fvar_maxidx_indep_eq: forall fvar n m sb,
follow_in_smap (FreshVar fvar) n sb = 
follow_in_smap (FreshVar fvar) m sb.
Proof.
intros fvar n m sb.
destruct sb as [|h r].
- reflexivity. 
- unfold follow_in_smap.
  reflexivity.
Qed.

Lemma follow_in_smap_instackvar: forall var maxidx sb,
follow_in_smap (InStackVar var) maxidx sb = 
  Some (FollowSmapVal (SymBasicVal (InStackVar var)) maxidx sb).
Proof.
intros var maxidx sb. 
destruct sb as [|h r]; try intuition. 
Qed.



Lemma eval'_maxidx_indep: forall d sv stk mem strg ctx n m sb ops v,
eval_sstack_val' d sv stk mem strg ctx n sb ops = Some v ->
eval_sstack_val' d sv stk mem strg ctx m sb ops = Some v.
Proof.
intros d sv stk mem strg ctx n m sb ops v Heval.
destruct d as [|d']; try discriminate.
rewrite -> eval_sstack_val'_one_step.
rewrite -> eval_sstack_val'_one_step in Heval.
destruct sv as [val|var|fvar] eqn: eq_sv.
* rewrite -> follow_in_smap_val.
  rewrite -> follow_in_smap_val in Heval.
  assumption.
* rewrite -> follow_in_smap_instackvar.
  rewrite -> follow_in_smap_instackvar in Heval.
  assumption.
* rewrite -> follow_in_smap_fvar_maxidx_indep_eq with (m:=n).  
  assumption.
Qed.


Lemma eval_sstack_val'_freshvar: forall n sv stk mem strg ctx m sb ops idx, 
eval_sstack_val' n sv stk mem strg ctx m sb ops = 
eval_sstack_val' n (FreshVar idx) stk mem strg ctx m 
  ((idx, SymBasicVal sv) :: sb) ops.
Proof.
intros n sv stk mem strg ctx m sb ops idx.
destruct n as [|n'] eqn: eq_n.
- reflexivity. 
- rewrite -> eval_sstack_val'_one_step. 
  rewrite -> eval_sstack_val'_one_step.
  destruct sv as [val|var|fvar] eqn: eq_fvar.
  * rewrite -> follow_in_smap_val.
    simpl. rewrite -> PeanoNat.Nat.eqb_refl.
    reflexivity. 
  * rewrite -> follow_in_smap_instackvar.
    simpl. rewrite -> PeanoNat.Nat.eqb_refl.
    reflexivity.
  * rewrite -> follow_in_smap_head_fvar_head.
    rewrite -> follow_in_smap_fvar_maxidx_indep_eq with (m:=idx).
    reflexivity.
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


Lemma optimize_add_0_sbinding_snd:
opt_sbinding_snd optimize_add_0_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_add_0_sbinding.
split.
- (* valid_sbindings *)
  (* IDEA: use general lemma for every "safe" optimization *)
  unfold optimize_add_0_sbinding in Hoptm_add_0_sbinding.
  destruct (val) as [basicv|pushtagv|label args|offset smem|key sstrg|
    offset size smem] eqn: eq_val.
  + injection Hoptm_add_0_sbinding as eq_val' eq_flag.
    rewrite <- eq_val'.
    assumption.
  + injection Hoptm_add_0_sbinding as eq_val' eq_flag.
    rewrite <- eq_val'.
    assumption.
  + destruct label eqn: eq_label; try 
      (injection Hoptm_add_0_sbinding as eq_val' eq_flag;
      rewrite <- eq_val'; assumption).
    (* ADD *)
    destruct args as [|arg1 r1] eqn: eq_args; try 
      (injection Hoptm_add_0_sbinding as eq_val' eq_flag;
      rewrite <- eq_val'; assumption).
    destruct r1 as [|arg2 r2] eqn: eq_r1; try 
      (injection Hoptm_add_0_sbinding as eq_val' eq_flag;
      rewrite <- eq_val'; assumption).
    destruct r2 as [|arg3 r3] eqn: eq_r2; try 
      (injection Hoptm_add_0_sbinding as eq_val' eq_flag;
      rewrite <- eq_val'; assumption).
    destruct (fcmp arg1 (Val WZero) idx sb idx sb instk_height evm_stack_opm)
      eqn: eq_fcmp_arg1.
    * injection Hoptm_add_0_sbinding as eq_val' eq_flag.
      rewrite <- eq_val'.
      simpl in Hvalid. simpl.
      destruct Hvalid as [Hmaxidx [Hvalid_stack_op Hvalid_sb]].
      unfold valid_stack_op_instr in Hvalid_stack_op.
      simpl in Hvalid_stack_op.
      destruct Hvalid_stack_op as [_ [Hvalid_arg1 Hvalid_arg2]].
      intuition.
    * destruct (fcmp arg2 (Val WZero) idx sb idx sb instk_height 
        evm_stack_opm) eqn: eq_fcmp_arg2; try 
      (injection Hoptm_add_0_sbinding as eq_val' eq_flag;
      rewrite <- eq_val'; assumption).
      injection Hoptm_add_0_sbinding as eq_val' eq_flag.
      rewrite <- eq_val'.
      simpl in Hvalid. simpl.
      destruct Hvalid as [Hmaxidx [Hvalid_stack_op Hvalid_sb]].
      unfold valid_stack_op_instr in Hvalid_stack_op.
      simpl in Hvalid_stack_op.
      destruct Hvalid_stack_op as [_ [Hvalid_arg1 Hvalid_arg2]].
      intuition.
  + injection Hoptm_add_0_sbinding as eq_val' eq_flag.
    rewrite <- eq_val'.
    assumption.
  + injection Hoptm_add_0_sbinding as eq_val' eq_flag.
    rewrite <- eq_val'.
    assumption.
  + injection Hoptm_add_0_sbinding as eq_val' eq_flag.
    rewrite <- eq_val'.
    assumption.    
- (* evaluation is preserved *) 
  intros stk mem strg ctx v Hlen Heval_orig.
  assert (Hlen2 := Hlen).
  rewrite -> Hlen in Hlen2.
  rewrite <- Hlen in Hlen2 at 2.
  unfold optimize_add_0_sbinding in Hoptm_add_0_sbinding.
  pose proof (Hvalid_maxidx instk_height maxidx idx val sb evm_stack_opm
      Hvalid) as eq_maxidx_idx.
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
  destruct (fcmp arg1 (Val WZero) idx sb idx sb instk_height) 
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

    unfold valid_bindings in Hvalid.
    destruct Hvalid as [eq_maxid [Hvalid_smap_value Hvalid_bindings_sb]].
    unfold valid_smap_value in Hvalid_smap_value.
    unfold valid_stack_op_instr in Hvalid_smap_value.
    simpl in Hvalid_smap_value.
    destruct (Hvalid_smap_value) as [_ [Hvalid_arg1 [Hvalid_arg2 _ ]]].
    fold valid_bindings in Hvalid_bindings_sb.

    pose proof (valid_sstack_value_const instk_height idx v) as 
      Hvalid_zero.
    pose proof (Hsafe_sstack_val_cmp arg1 (Val WZero) idx sb idx sb 
      instk_height evm_stack_opm Hvalid_arg1 Hvalid_zero Hvalid_bindings_sb
      Hvalid_bindings_sb fcmp_arg1_zero stk mem strg ctx Hlen2)
      as [vzero [Heval_arg1 Heval_vzero]].
    assert (Heval_arg1_copy := Heval_arg1).
    unfold eval_sstack_val in Heval_arg1_copy.
    rewrite -> eval_sstack_val_const in Heval_vzero.
    rewrite <- Heval_vzero in Heval_arg1.
    
    unfold eval_sstack_val.
    rewrite -> eq_maxid in eval_arg1.
    rewrite -> Heval_arg1_copy in eval_arg1.
    injection eval_arg1 as eq_varg1.
    injection Heval_vzero as eq_vzero.
    rewrite <- eq_varg1 in Heval_orig.
    rewrite <- eq_vzero in Heval_orig.
    rewrite -> evm_add_zero_l in Heval_orig.
    rewrite <- Heval_orig.
    rewrite <- eval_sstack_val'_freshvar.
    apply eval_sstack_val'_preserved_when_depth_extended in eval_arg2.
    apply eval'_maxidx_indep with (n:=idx).
    assumption.
  + (* arg2 ~ WZero *)
    destruct (fcmp arg2 (Val WZero) idx sb idx sb instk_height evm_stack_opm)
      eqn: fcmp_arg2_zero.
    * injection Hoptm_add_0_sbinding as eq_val' _.
      rewrite <- eq_val'.
      unfold eval_sstack_val in Heval_orig.
      simpl in Heval_orig.
      rewrite -> PeanoNat.Nat.eqb_refl in Heval_orig.
      simpl in Heval_orig.
      destruct (eval_sstack_val' maxidx arg1 stk mem strg ctx idx sb 
        evm_stack_opm) as [varg1|] eqn: eval_arg1; try discriminate.
      destruct (eval_sstack_val' maxidx arg2 stk mem strg ctx idx sb 
        evm_stack_opm) as [varg2|] eqn: eval_arg2; try discriminate.
      unfold safe_sstack_val_cmp in Hsafe_sstack_val_cmp.
      
      unfold valid_bindings in Hvalid.
      destruct Hvalid as [eq_maxid [Hvalid_smap_value Hvalid_bindings_sb]].
      unfold valid_smap_value in Hvalid_smap_value.
      unfold valid_stack_op_instr in Hvalid_smap_value.
      simpl in Hvalid_smap_value.
      destruct (Hvalid_smap_value) as [_ [Hvalid_arg1 [Hvalid_arg2 _ ]]].
      fold valid_bindings in Hvalid_bindings_sb.
      
      pose proof (valid_sstack_value_const instk_height idx v) as 
        Hvalid_zero.
      pose proof (Hsafe_sstack_val_cmp arg2 (Val WZero) idx sb idx sb 
        instk_height evm_stack_opm Hvalid_arg2 Hvalid_zero Hvalid_bindings_sb
        Hvalid_bindings_sb fcmp_arg2_zero stk mem strg ctx Hlen2)
        as [vzero [Heval_arg2 Heval_vzero]].
      assert (Heval_arg2_copy := Heval_arg2).
      unfold eval_sstack_val in Heval_arg2_copy.
      rewrite -> eval_sstack_val_const in Heval_vzero.
      rewrite <- Heval_vzero in Heval_arg2.
    
      unfold eval_sstack_val.
      rewrite -> eq_maxid in eval_arg2.
      rewrite -> Heval_arg2_copy in eval_arg2.
      injection eval_arg2 as eq_varg2.
      injection Heval_vzero as eq_vzero.
      rewrite <- eq_varg2 in Heval_orig.
      rewrite <- eq_vzero in Heval_orig.
      rewrite -> evm_add_zero_r in Heval_orig.
      rewrite <- Heval_orig.
      rewrite <- eval_sstack_val'_freshvar.
      apply eval_sstack_val'_preserved_when_depth_extended in eval_arg1.
      apply eval'_maxidx_indep with (n:=idx).
      assumption.
    * injection Hoptm_add_0_sbinding as eq_val' _. 
      rewrite <- eq_val'.
      assumption.
Qed.


(* TODO: create a generic version for any optimization built with 
         optimize_first_sstate from a sound sval optimization *)
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
  apply optimize_add_0_sbinding_snd.
- split.
  + apply instk_height_optimize_sst with (opt:=optimize_add_0_sbinding)
    (fcmp:=fcmp)(flag:=b). 
    assumption.
  + intros st st' Heval.
    pose proof (instk_height_optimize_sst optimize_add_0_sbinding fcmp sst 
      sst' b Hoptim) as Hinstk.
    pose proof (optimize_first_sstate_preserv optimize_add_0_sbinding fcmp
      sst sst' b Hvalid_sst optimize_add_0_sbinding_snd Hsafe_fcmp Hoptim)
    as Hpreserv.
    destruct Hpreserv as [_ Heval2_imp].
    apply Heval2_imp.
    assumption.
Qed.

End Optimizations_Def.

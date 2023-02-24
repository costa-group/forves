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

Require Import List.
Import ListNotations.


Module Optimizations_Def.

(**************************************)
(* auxiliary results about evaluation *)
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

Lemma follow_in_smap_val: forall v maxidx sb,
follow_in_smap (Val v) maxidx sb = 
  Some (FollowSmapVal (SymBasicVal (Val v)) maxidx sb).
Proof.
intros v maxidx sb. 
destruct sb as [|h r]; try intuition.
Qed.



Lemma follow_in_smap_chain: forall n1 n2 m sb,
follow_in_smap (FreshVar n1) m ((n1, SymBasicVal (FreshVar n2)) :: sb) =
follow_in_smap (FreshVar n2) n1 sb.
Proof.
intros n1 n2 m sb.
unfold follow_in_smap.
rewrite -> PeanoNat.Nat.eqb_refl. simpl. fold follow_in_smap.
reflexivity.
Qed.

(* Used to unfold eval_sstack_val' without applying any further 
   simplification *)
Lemma eval_sstack_val'_one_step: forall d' sv stk mem strg ctx maxidx sb ops,
eval_sstack_val' (S d') sv stk mem strg ctx maxidx sb ops =
      match follow_in_smap sv maxidx sb with
      | None => None
      | Some (FollowSmapVal smv maxidx' sb') =>
          match smv with
          | SymBasicVal (Val v) => Some v

          | SymBasicVal (InStackVar n) =>
              match nth_error stk n with
              | Some v => Some v
              | None => None
              end

          | SymBasicVal (FreshVar _) => None

          | SymPUSHTAG v =>
              let tags := (get_tags_ctx ctx) in Some (tags v)

          | SymOp label args =>
              match ops label with
              | OpImp nargs f _ _ =>
                  if (List.length args =? nargs) then
                    let f_eval_list := fun (sv': sstack_val) => eval_sstack_val' d' sv' stk mem strg ctx maxidx' sb' ops in
                    match map_option f_eval_list args with
                    | None => None
                    | Some vargs => Some (f ctx vargs)
                    end
                  else None
              end
 
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


Lemma eval_sstack_def: forall (sstk: sstack) (maxidx: nat) (sb: sbindings) 
  (stk: stack) (mem: memory) (strg: storage) (ctx: context) 
  (ops: stack_op_instr_map),
eval_sstack sstk maxidx sb stk mem strg ctx ops = 
map_option (fun sv => eval_sstack_val sv stk mem strg ctx maxidx sb ops) sstk.
Proof.
intuition.
Qed.


Lemma eval'_maxidx_indep_eq:
  forall (d : nat) (sv : sstack_val) (stk : stack) 
    (mem : memory) (strg : storage) (ctx : context) 
    (n m : nat) (sb : sbindings) (ops : stack_op_instr_map),
  eval_sstack_val' d sv stk mem strg ctx n sb ops = 
  eval_sstack_val' d sv stk mem strg ctx m sb ops.
Proof.
intros d sv stk mem strg ctx n m sb ops.
destruct d as [|d']; try reflexivity.
rewrite -> eval_sstack_val'_one_step.
rewrite -> eval_sstack_val'_one_step.
destruct sv as [val|var|fvar] eqn: eq_sv.
* rewrite -> follow_in_smap_val.
  rewrite -> follow_in_smap_val.
  reflexivity.
* rewrite -> follow_in_smap_instackvar.
  rewrite -> follow_in_smap_instackvar.
  reflexivity.
* rewrite -> follow_in_smap_fvar_maxidx_indep_eq with (m:=m).  
  reflexivity.
Qed.





(********************)


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



Lemma map_option_preserv_functs: forall {A B : Type} (f g: A -> option B) (l: list A)
  (rl: list B),
map_option f l = Some rl ->
(forall x r, f x = Some r -> g x = Some r) ->
map_option g l = Some rl.
Proof.
intros A B f g l.
induction l as [|h t IH].
- intuition.
- intros rl Hmap_f Heq_f_g.
  simpl. simpl in Hmap_f.
  destruct (f h) as [eh|] eqn: eq_f_h; try discriminate.
  apply Heq_f_g in eq_f_h.
  rewrite -> eq_f_h.
  destruct (map_option f t) as [et|] eqn: eq_map_t; try discriminate.
  rewrite <- eq_map_t in IH.
  pose proof (IH et eq_map_t Heq_f_g) as eq_map_g_t. 
  rewrite -> eq_map_g_t. 
  assumption.
Qed.

Lemma eq_funs_len: forall maxidx stk mem strg ctx n sb1 sb2 ops instk_height,
(forall (sv : sstack_val) (stk : stack)
             (mem : memory) (strg : storage) (ctx : context) 
             (v : EVMWord),
           instk_height = length stk ->
           eval_sstack_val' maxidx sv stk mem strg ctx n sb1 ops = Some v ->
           eval_sstack_val' maxidx sv stk mem strg ctx n sb2 ops = Some v) ->
instk_height = length stk -> 
forall sv r, 
  (fun sv' : sstack_val =>
     eval_sstack_val' maxidx sv' stk mem strg ctx n sb1 ops) sv = Some r ->
  (fun sv' : sstack_val =>
     eval_sstack_val' maxidx sv' stk mem strg ctx n sb2 ops) sv = Some r.
Proof.
intros maxidx stk mem strg ctx n sb1 sb2 ops instk_height Hpreserv Hlen.
intros sv r Heval_f1.
simpl in Heval_f1.
simpl.
pose proof (Hpreserv sv stk mem strg ctx r Hlen Heval_f1).
assumption.
Qed.

Lemma map_option_fun_sstack: forall maxidx stk mem strg ctx n sb1 sb2 ops 
  instk_height,
(forall (sv : sstack_val) (stk : stack)
             (mem : memory) (strg : storage) (ctx : context) 
             (v : EVMWord),
           instk_height = length stk ->
           eval_sstack_val' maxidx sv stk mem strg ctx n sb1 ops = Some v ->
           eval_sstack_val' maxidx sv stk mem strg ctx n sb2 ops = Some v) ->
instk_height = length stk -> 
forall sv r, 
  (fun sv' : sstack_val =>
     eval_sstack_val' maxidx sv' stk mem strg ctx n sb1 ops) sv = Some r ->
  (fun sv' : sstack_val =>
     eval_sstack_val' maxidx sv' stk mem strg ctx n sb2 ops) sv = Some r.
Proof.
intros maxidx stk mem strg ctx n sb1 sb2 ops instk_height Hpreserv Hlen.
intros sv r Heval_f1.
simpl in Heval_f1.
simpl.
pose proof (Hpreserv sv stk mem strg ctx r Hlen Heval_f1).
assumption.
Qed.


Lemma map_option_sstack: forall maxidx stk mem strg ctx n sb1 sb2 ops 
  instk_height args vargs,
map_option (fun sv' : sstack_val =>
              eval_sstack_val' maxidx sv' stk mem strg ctx n sb1 ops)
              args = Some vargs ->
(forall (sv : sstack_val) (stk : stack)
             (mem : memory) (strg : storage) (ctx : context) 
             (v : EVMWord),
           instk_height = length stk ->
           eval_sstack_val' maxidx sv stk mem strg ctx n sb1 ops = Some v ->
           eval_sstack_val' maxidx sv stk mem strg ctx n sb2 ops = Some v) ->
instk_height = length stk ->           
map_option (fun sv' : sstack_val =>
              eval_sstack_val' maxidx sv' stk mem strg ctx n sb2 ops)
            args = Some vargs.
Proof.
intros maxidx stk mem strg ctx n sb1 sb2 ops instk_height args vargs Hmapo
  Hpreserv Hlen.
pose proof (map_option_fun_sstack maxidx stk mem strg ctx n sb1 sb2 ops 
  instk_height Hpreserv Hlen) as Hfunct_equiv.
pose proof (map_option_preserv_functs 
  ((fun sv' : sstack_val =>
                eval_sstack_val' maxidx sv' stk mem strg ctx n sb1 ops))
  (fun sv' : sstack_val =>
   eval_sstack_val' maxidx sv' stk mem strg ctx n sb2 ops) args vargs
  Hmapo Hfunct_equiv).
assumption.
Qed.


Lemma same_instantiate_memory_update: forall (f g: sstack_val -> option EVMWord),
(forall x (r: EVMWord), f x = Some r -> g x = Some r) ->
forall (mem_upd: memory_update sstack_val) v,
instantiate_memory_update f mem_upd = Some v ->
instantiate_memory_update g mem_upd = Some v.
Proof.
intros f g Hpreserv mem_upd v Heval.
destruct mem_upd as [offset val|offset val].
- unfold instantiate_memory_update in Heval. 
  destruct (f offset) as [offsetv|] eqn: eq_eval_offset; try discriminate.
  destruct (f val) as [valv|] eqn: eq_eval_val; try discriminate.
  apply Hpreserv in eq_eval_offset; try assumption.
  apply Hpreserv in eq_eval_val; try assumption.
  unfold instantiate_memory_update.
  rewrite -> eq_eval_offset.
  rewrite -> eq_eval_val.
  rewrite <- Heval. reflexivity.
- unfold instantiate_memory_update in Heval. 
  destruct (f offset) as [offsetv|] eqn: eq_eval_offset; try discriminate.
  destruct (f val) as [valv|] eqn: eq_eval_val; try discriminate.
  apply Hpreserv in eq_eval_offset; try assumption.
  apply Hpreserv in eq_eval_val; try assumption.
  unfold instantiate_memory_update.
  rewrite -> eq_eval_offset.
  rewrite -> eq_eval_val.
  rewrite <- Heval. reflexivity.
Qed.

Lemma same_instantiate_storage_update: forall 
  (f g: sstack_val -> option EVMWord),
(forall x (r: EVMWord), f x = Some r -> g x = Some r) ->
forall (strg_upd: storage_update sstack_val) v,
instantiate_storage_update f strg_upd = Some v ->
instantiate_storage_update g strg_upd = Some v.
Proof.
intros f g Hpreserv strg_upd v Heval.
destruct strg_upd as [key value].
unfold instantiate_storage_update in Heval. 
destruct (f key) as [keyv|] eqn: eq_eval_key; try discriminate.
destruct (f value) as [valv|] eqn: eq_eval_value; try discriminate.
apply Hpreserv in eq_eval_key; try assumption.
apply Hpreserv in eq_eval_value; try assumption.
unfold instantiate_storage_update.
rewrite -> eq_eval_key.
rewrite -> eq_eval_value.
rewrite <- Heval. reflexivity.
Qed.


Lemma map_option_inst_mem_update: forall maxidx stk mem strg ctx n sb1 sb2 ops 
  instk_height smem mem_updates, 
map_option (instantiate_memory_update
              (fun sv : sstack_val =>
                   eval_sstack_val' maxidx sv stk mem strg ctx n sb1 ops))
           smem = Some mem_updates ->
(forall (sv : sstack_val) (stk : stack)
             (mem : memory) (strg : storage) (ctx : context) 
             (v : EVMWord),
           instk_height = length stk ->
           eval_sstack_val' maxidx sv stk mem strg ctx n sb1 ops = Some v ->
           eval_sstack_val' maxidx sv stk mem strg ctx n sb2 ops = Some v) ->
instk_height = length stk ->
map_option (instantiate_memory_update
             (fun sv : sstack_val =>
                  eval_sstack_val' maxidx sv stk mem strg ctx n sb2 ops)) 
             smem = Some mem_updates.
Proof. 
intros maxidx stk mem strg ctx n sb1 sb2 ops instk_height smem mem_updates
  Hmapo Hpreserv Hlen.
pose proof (eq_funs_len maxidx stk mem strg ctx n sb1 sb2 ops 
  instk_height Hpreserv Hlen) as Hfunct_equiv.  
pose proof (same_instantiate_memory_update
  ((fun sv' : sstack_val =>
                eval_sstack_val' maxidx sv' stk mem strg ctx n sb1 ops))
  (fun sv' : sstack_val =>
                eval_sstack_val' maxidx sv' stk mem strg ctx n sb2 ops)                
  Hfunct_equiv) as Hinst_equiv.
pose proof (map_option_preserv_functs 
  (instantiate_memory_update
                (fun sv' : sstack_val =>
                 eval_sstack_val' maxidx sv' stk mem strg ctx n sb1 ops))
  (instantiate_memory_update
                (fun sv' : sstack_val =>
                 eval_sstack_val' maxidx sv' stk mem strg ctx n sb2 ops))
  smem mem_updates Hmapo Hinst_equiv) as Hmapo2.
rewrite -> Hmapo2.
reflexivity.
Qed.

Lemma map_option_inst_strg_update: forall maxidx stk mem strg ctx n sb1 sb2 ops 
  instk_height sstrg strg_updates, 
map_option (instantiate_storage_update
              (fun sv : sstack_val =>
                   eval_sstack_val' maxidx sv stk mem strg ctx n sb1 ops))
           sstrg = Some strg_updates ->
(forall (sv : sstack_val) (stk : stack)
             (mem : memory) (strg : storage) (ctx : context) 
             (v : EVMWord),
           instk_height = length stk ->
           eval_sstack_val' maxidx sv stk mem strg ctx n sb1 ops = Some v ->
           eval_sstack_val' maxidx sv stk mem strg ctx n sb2 ops = Some v) ->
instk_height = length stk ->
map_option (instantiate_storage_update
             (fun sv : sstack_val =>
                  eval_sstack_val' maxidx sv stk mem strg ctx n sb2 ops)) 
             sstrg = Some strg_updates.
Proof. 
intros maxidx stk mem strg ctx n sb1 sb2 ops instk_height sstrg strg_updates
  Hmapo Hpreserv Hlen.
pose proof (eq_funs_len maxidx stk mem strg ctx n sb1 sb2 ops 
  instk_height Hpreserv Hlen) as Hfunct_equiv.  
pose proof (same_instantiate_storage_update
  ((fun sv' : sstack_val =>
                eval_sstack_val' maxidx sv' stk mem strg ctx n sb1 ops))
  (fun sv' : sstack_val =>
                eval_sstack_val' maxidx sv' stk mem strg ctx n sb2 ops)                
  Hfunct_equiv) as Hinst_equiv.
pose proof (map_option_preserv_functs 
  (instantiate_storage_update
                (fun sv' : sstack_val =>
                 eval_sstack_val' maxidx sv' stk mem strg ctx n sb1 ops))
  (instantiate_storage_update
                (fun sv' : sstack_val =>
                 eval_sstack_val' maxidx sv' stk mem strg ctx n sb2 ops))
  sstrg strg_updates Hmapo Hinst_equiv) as Hmapo2.
rewrite -> Hmapo2.
reflexivity.
Qed.



Lemma some_is_not_none: forall {T: Type} (x: option T) (v: T),
x = Some v -> x <> None.
Proof.
intros T x v Hx.
rewrite -> Hx.
intuition.
discriminate.
Qed.


Lemma follow_then_fvar_lt: forall maxidx sb ops instk_height n fvar fsm,
valid_bindings instk_height n sb ops ->
follow_in_smap (FreshVar fvar) maxidx sb = Some fsm ->
fvar < n.
Proof.
intros maxidx sb. revert maxidx.
induction sb as [| h t IH].
- intros maxidx ops instk_height n fvar fsm. 
  intros Hvalid Hfollow.
  simpl in Hfollow. discriminate.
- intros maxidx ops instk_height n fvar fsm. 
  intros Hvalid Hfollow.
  destruct h as [k v].
  simpl in Hvalid.
  destruct Hvalid as [eq_n [_ Hvalid']].
  simpl in Hfollow.
  destruct (k =? fvar) eqn: eq_k_fvar.
  + rewrite -> PeanoNat.Nat.eqb_eq in eq_k_fvar.
    rewrite <- eq_k_fvar.
    intuition.
  + rewrite -> follow_in_smap_fvar_maxidx_indep_eq with (m:=maxidx) in Hfollow.
    pose proof (IH maxidx ops instk_height k fvar fsm Hvalid' Hfollow).
    intuition.
Qed.


Lemma eval'_then_valid_sstack_value: forall d sv stk mem strg ctx maxidx sb ops
  v instk_height n,
eval_sstack_val' (S d) sv stk mem strg ctx maxidx sb ops = Some v ->
valid_bindings instk_height n sb ops ->
instk_height = length stk ->
valid_sstack_value instk_height n sv.
Proof.
intros d sv stk mem strg ctx maxidx sb ops v instk_height n.
intros Heval Hvalid Hlen.
destruct sv as [val|var|fvar].
- simpl. intuition.
- simpl. simpl in Heval.
  rewrite -> follow_in_smap_instackvar in Heval.
  destruct (nth_error stk var) as [v'|] eqn: eq_nth_error; try discriminate.
  unfold follow_in_smap in Heval. unfold eval_sstack_val' in Heval.
  pose proof (some_is_not_none (nth_error stk var) v' eq_nth_error) 
    as eq_nth_not_none.
  pose proof (nth_error_Some stk var) as H.
  rewrite -> Hlen.
  rewrite <- H.
  assumption.
- simpl.
  simpl in Heval.
  destruct (follow_in_smap (FreshVar fvar) maxidx sb) as [fsm|] eqn: eq_follow;
    try discriminate.
  pose proof (follow_then_fvar_lt maxidx sb ops instk_height n fvar fsm
    Hvalid eq_follow).
  assumption.
Qed.


Lemma eval_sstack_val'_diff:
  forall (fvar idx : nat) (stk : stack) (mem : memory) 
    (strg : storage) (ctx : context) (d a b: nat) 
    (smapv : smap_value) (ops : stack_op_instr_map) 
    (sb : sbindings),
  (idx =? fvar) = false ->
  eval_sstack_val' (S d) (FreshVar fvar) stk mem strg ctx a 
    ((idx, smapv) :: sb) ops =
  eval_sstack_val' (S d) (FreshVar fvar) stk mem strg ctx b sb ops.
Proof.
intros fvar idx stk mem strg ctx d a b smapv ops sb.
intros Hfvar_idx.
simpl. rewrite -> Hfvar_idx.
rewrite -> follow_in_smap_fvar_maxidx_indep_eq with (m:=b).
reflexivity.
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
    intros sv stk mem strg ctx v Hlen Heval.
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
                 (FreshVar fvar') stk mem strg ctx maxidx sb1 ops v
                 instk_height n Heval Hvalid_sb1 Hlen) as Hvalid_stk_val_fv.
               assert (S n > n) as maxidx_gt_nm; try intuition.
               pose proof (eval_sstack_val'_succ (S n) instk_height
                 (FreshVar fvar') stk mem strg ctx n sb1 ops Hlen
                 Hvalid_stk_val_fv Hvalid_sb1 maxidx_gt_nm) as eval'_fvar'.
               destruct eval'_fvar' as [v' eval'_fvar'].
               rewrite -> eval'_maxidx_indep_eq with (m:=n) in Heval.
               pose proof (eval_sstack_val'_preserved_when_depth_extended
                 (S n) n sb1 (FreshVar fvar') v' stk mem strg ctx ops
                 eval'_fvar') as eval'_fvar'_succ.
               rewrite <- Hmaxidx in eval'_fvar'_succ.
               rewrite -> Heval in eval'_fvar'_succ.
               injection eval'_fvar'_succ as eq_v'.
               rewrite <- eq_v' in eval'_fvar'.
               pose proof (Hpreserv (FreshVar fvar') stk mem strg ctx v Hlen
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
            destruct (ops label) as [nargs f H_comm H_ctx_ind].
            destruct (length args =? nargs); try discriminate.
            destruct (map_option
              (fun sv' : sstack_val =>
                 eval_sstack_val' maxidx sv' stk mem strg ctx n sb1 ops) args)
              as [vargs|] eqn: Hmapo; try discriminate.
            rewrite <- Heval.
            pose proof (map_option_sstack maxidx stk mem strg ctx n sb1 sb2 
              ops instk_height args vargs Hmapo Hpreserv Hlen) as eq_mapo'.
            rewrite -> eq_mapo'.
            reflexivity.
         ++ (* SymMLOAD offset smem *)
            rewrite <- Hmaxidx in Hpreserv.
            simpl in Heval. rewrite -> eq_fvar_n in Heval.
            simpl. rewrite -> eq_fvar_n.
            destruct (map_option (instantiate_memory_update
              (fun sv : sstack_val =>
                 eval_sstack_val' maxidx sv stk mem strg ctx n sb1 ops)) smem)
              as [mem_updates|] eqn: Hmapo; try discriminate.
            pose proof (map_option_inst_mem_update maxidx stk mem strg ctx n 
              sb1 sb2 ops instk_height smem mem_updates Hmapo Hpreserv Hlen)
              as eq_mapo'.
            rewrite -> eq_mapo'.
            destruct (eval_sstack_val' maxidx offset stk mem strg ctx n sb1 ops)
              as [offsetv|] eqn: eq_eval_offset; try discriminate.
            pose proof (Hpreserv offset stk mem strg ctx offsetv Hlen
              eq_eval_offset) as eq_eval_offset'.
            rewrite ->  eq_eval_offset'.
            assumption.
         ++ (* SymSLOAD key sstrg *)
            rewrite <- Hmaxidx in Hpreserv.
            simpl in Heval. rewrite -> eq_fvar_n in Heval.
            simpl. rewrite -> eq_fvar_n.
            destruct (map_option (instantiate_storage_update
              (fun sv : sstack_val =>
                eval_sstack_val' maxidx sv stk mem strg ctx n sb1 ops)) sstrg)
              as [strg_updates|] eqn: Hmapo; try discriminate.
            pose proof (map_option_inst_strg_update maxidx stk mem strg ctx n 
              sb1 sb2 ops instk_height sstrg strg_updates Hmapo Hpreserv Hlen)
              as eq_mapo'.
            rewrite -> eq_mapo'.
            destruct (eval_sstack_val' maxidx key stk mem strg ctx n sb1 ops)
              as [keyv|] eqn: eq_eval_key; try discriminate.
            pose proof (Hpreserv key stk mem strg ctx keyv Hlen
              eq_eval_key) as eq_eval_key'.
            rewrite ->  eq_eval_key'.
            assumption.
         ++ (* SymSHA3 offset size smem *)
            rewrite <- Hmaxidx in Hpreserv.
            simpl in Heval. rewrite -> eq_fvar_n in Heval.
            simpl. rewrite -> eq_fvar_n.
            destruct (map_option (instantiate_memory_update
              (fun sv : sstack_val =>
                eval_sstack_val' maxidx sv stk mem strg ctx n sb1 ops)) smem)
              as [mem_updates|] eqn: Hmapo; try discriminate.
            pose proof (map_option_inst_mem_update maxidx stk mem strg ctx n 
              sb1 sb2 ops instk_height smem mem_updates Hmapo Hpreserv Hlen)
              as eq_mapo'.
            rewrite -> eq_mapo'.
            destruct (eval_sstack_val' maxidx offset stk mem strg ctx n sb1 ops)
              as [offsetv|] eqn: eq_eval_offset; try discriminate.
            pose proof (Hpreserv offset stk mem strg ctx offsetv Hlen
              eq_eval_offset) as eq_eval_offset'.
            rewrite ->  eq_eval_offset'.
            destruct (eval_sstack_val' maxidx size stk mem strg ctx n sb1 ops)
              as [sizev|] eqn: eq_eval_size; try discriminate.
            pose proof (Hpreserv size stk mem strg ctx sizev Hlen
              eq_eval_size) as eq_eval_size'.
            rewrite ->  eq_eval_size'.
            assumption.
      -- rewrite -> eval_sstack_val'_diff with (b:=n) in Heval; try assumption.
         rewrite -> eval_sstack_val'_diff with (b:=n); try assumption.
         pose proof (eval'_then_valid_sstack_value maxidx 
           (FreshVar fvar) stk mem strg ctx n sb1 ops v
           instk_height n Heval Hvalid_sb1 Hlen) as Hvalid_stk_val_fv.
         assert (S n > n) as maxidx_gt_nm; try intuition.
         pose proof (eval_sstack_val'_succ (S n) instk_height
           (FreshVar fvar) stk mem strg ctx n sb1 ops Hlen
           Hvalid_stk_val_fv Hvalid_sb1 maxidx_gt_nm) as eval'_fvar.
         destruct eval'_fvar as [v' eval'_fvar].
         pose proof (eval_sstack_val'_preserved_when_depth_extended
           (S n) n sb1 (FreshVar fvar) v' stk mem strg ctx ops
           eval'_fvar) as eval'_fvar_succ.
         rewrite <- Hmaxidx in eval'_fvar_succ.
         rewrite -> Heval in eval'_fvar_succ.
         injection eval'_fvar_succ as eq_v'.
         rewrite <- eq_v' in eval'_fvar.
         pose proof (Hpreserv (FreshVar fvar) stk mem strg ctx v Hlen
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
    (strg: storage) (ctx: context),
  instk_height = length stk ->
  eval_smemory smem maxidx sb1 stk mem strg ctx ops = Some mem' ->
  eval_smemory smem maxidx sb2 stk mem strg ctx ops = Some mem'.
Proof.
intros sb1 sb2 maxidx ops instk_height Hpreserv smem stk
  mem mem' strg ctx Hlen Heval_mem.
unfold eval_smemory. unfold eval_smemory in Heval_mem.
unfold eval_sstack_val in Hpreserv.
unfold eval_sstack_val in Heval_mem.
unfold eval_sstack_val.
destruct (map_option
                (instantiate_memory_update
                   (fun sv : sstack_val =>
                    eval_sstack_val' (S maxidx) sv stk mem strg ctx maxidx
                      sb1 ops)) smem) as [updates|] eqn: eq_mapo;
  try discriminate.
injection Heval_mem as eq_mem'.
rewrite <- eq_mem'.
destruct Hpreserv as [Hvalid_sb1 [Hvalid_sb2 Hpreserv]].
pose proof (map_option_inst_mem_update (S maxidx) stk mem strg ctx maxidx
  sb1 sb2 ops instk_height smem updates eq_mapo Hpreserv Hlen) as eq_mapo2.
rewrite -> eq_mapo2.
reflexivity.
Qed.








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
intros sb1 sb2 maxidx ops instk_height Hpreserv stk sstrg
  mem strg strg' ctx Hlen Heval_sstrg.
unfold eval_sstorage. unfold eval_sstorage in Heval_sstrg.
unfold eval_sstack_val in Hpreserv.
unfold eval_sstack_val in Heval_sstrg.
unfold eval_sstack_val.
destruct (map_option
                  (instantiate_storage_update
                     (fun sv : sstack_val =>
                      eval_sstack_val' (S maxidx) sv stk mem strg ctx
                        maxidx sb1 ops)) sstrg) as [updates|] eqn: eq_mapo;
  try discriminate.
injection Heval_sstrg as eq_strg'.
rewrite <- eq_strg'.
destruct Hpreserv as [Hvalid_sb1 [Hvalid_sb2 Hpreserv]].
pose proof (map_option_inst_strg_update (S maxidx) stk mem strg ctx maxidx
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
         pose proof (Hpreserv_ext stk mem strg ctx v Hlen Heval_sb).
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


(* Macro to reduce the next proof *)
Ltac inject_rw H eqname:= 
injection H as eqname _;
rewrite <- eqname;
assumption.


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


(* TODO move *)
Lemma eval_sstack_val'_const: forall n v stk mem strg ctx idx sb ops,
eval_sstack_val' (S n) (Val v) stk mem strg ctx idx sb ops = Some v.
Proof.
intros n v stk mem strg ctx idx sb ops.
simpl. rewrite -> follow_in_smap_val.
reflexivity.
Qed.

Lemma eval_sstack_val'_instackvar: forall n var stk mem strg ctx idx sb ops,
eval_sstack_val' (S n) (InStackVar var) stk mem strg ctx idx sb ops =   
  match nth_error stk var with
  | Some v => Some v
  | None => None
  end.
Proof.
intros n var stk mem strg ctx idx sb ops.
simpl. rewrite -> follow_in_smap_instackvar.
reflexivity.
Qed.


Lemma follow_in_smap_gt: forall fvar n1 n2 sb r instk_height ops,
follow_in_smap (FreshVar fvar) n1 sb = Some r ->
valid_bindings instk_height n2 sb ops ->
n2 > fvar.
Proof.
intros fvar n1 n2 sb. revert n1 n2.
induction sb as [| h t IH].
- intros n1 n2 r instk_height ops.
  intros Hfollow Hvalid.
  simpl in Hfollow. discriminate.
- intros n1 n2 r instk_height ops.
  intros Hfollow Hvalid.
  destruct h as [k v].
  simpl in Hfollow.
  simpl in Hvalid.
  destruct Hvalid as [eq_n2 [_ Hvalid_t]].
  destruct (k =? fvar) eqn: eq_k_fvar.
  + destruct (is_fresh_var_smv v) as [idx|].
    * rewrite -> PeanoNat.Nat.eqb_eq in eq_k_fvar.
      intuition.
    * rewrite -> PeanoNat.Nat.eqb_eq in eq_k_fvar.
      intuition.
  + pose proof (IH k k r instk_height ops Hfollow Hvalid_t).
    intuition.
Qed.


Lemma valid_bindings_unique_n: forall n1 n2 sb ops instk_height,
valid_bindings instk_height n1 sb ops ->
valid_bindings instk_height n2 sb ops ->
n1 = n2.
Proof.
intros n1 n2 sb ops instk_height.
intros Hvalid_n1 Hvalid_n2.
destruct sb as [| h t].
- simpl in Hvalid_n1.
  simpl in Hvalid_n2.
  intuition.
- destruct h as [k v].
  simpl in Hvalid_n1.
  destruct Hvalid_n1 as [eq_n1 [_ Hvalid_k]].
  destruct Hvalid_n2 as [eq_n2 [_ _]].
  intuition.
Qed.


Lemma valid_bindings_decr_head: forall n1 k1 k2 v1 v2 instk_height t ops,
valid_bindings instk_height n1 ((k1, v1) :: ((k2, v2) :: t)) ops ->
k1 > k2.
Proof.
intros n1 k1 k2 v1 v2 instk_height t ops.
intros Hvalid.
simpl in Hvalid.
intuition.
Qed.


Lemma valid_bindings_gte: forall instk_height n1 sb ops prefix sb',
valid_bindings instk_height n1 sb ops ->
sb = prefix ++ sb' ->
exists n2, valid_bindings instk_height n2 sb' ops /\
           forall k v, In (k,v) prefix -> k >= n2.
Proof.
intros instk_height n1 sb ops prefix.
revert instk_height n1 sb ops.
induction prefix as [|h t IH].
- intros instk_height n1 sb ops sb'.
  intros Hvalid Hprefix.
  simpl in Hprefix. rewrite <- Hprefix.
  exists n1. split.
  + assumption.
  + intros k v Hin. intuition.
- intros instk_height n1 sb ops sb'.
  intros Hvalid Hprefix.
  simpl in Hprefix. rewrite -> Hprefix in Hvalid.
  destruct h as [k1 v1] eqn: eq_h.
  assert (Hvalid_copy := Hvalid).
  simpl in Hvalid. destruct Hvalid as [eq_n1 [Hvalid_smap Hvalid_t_pref]].
  assert (t ++ sb' = t ++ sb') as eq_t_sb'; try reflexivity.
  pose proof (IH instk_height k1 (t ++ sb') ops sb' Hvalid_t_pref eq_t_sb') 
    as H.
  destruct H as [n2 [Hvalid' Hin_impl]].
  exists n2.
  split; try assumption.
  intros k v Hin.
  simpl in Hin. destruct Hin.
  + injection H as eq_k eq_v.
    rewrite <- eq_k.
    destruct t as [|h2 t2] eqn: eq_t.
    * simpl in Hvalid_t_pref.
      simpl in Hvalid_copy.
      destruct Hvalid_copy as [_ [_ Hvalid_t']].
      pose proof (valid_bindings_unique_n k1 n2 sb' ops instk_height
        Hvalid_t_pref Hvalid').
      intuition.
    * destruct h2 as [k2 v2] eqn: eq_h2.
      rewrite <- app_comm_cons in Hvalid_copy.
      pose proof (valid_bindings_decr_head n1 k1 k2 v1 v2 instk_height
        (t2 ++ sb') ops Hvalid_copy) as k1_gt_k2.
      assert (In (k2, v2) ((k2, v2) :: t2)) as Hin_k2; try intuition.
      pose proof (Hin_impl k2 v2 Hin_k2) as H.
      intuition.
  + apply Hin_impl with (v:=v); try assumption.
Qed.


Lemma follow_in_smap_prefix_gt: forall fvar n1 n2 sb' r instk_height sb 
  ops prefix,
follow_in_smap (FreshVar fvar) n1 sb' = Some r ->
valid_bindings instk_height n2 sb ops ->
sb = prefix ++ sb' ->
forall k v, In (k,v) prefix -> k > fvar.
Proof.
intros fvar n1 n2 sb' r instk_height sb ops prefix.
intros Hfollow Hvalid Hprefix.
intros k v Hin.
pose proof (valid_bindings_gte instk_height n2 sb ops prefix sb' Hvalid
  Hprefix) as Hvalid_gte.
destruct Hvalid_gte as [nn [Hvalid_sb' Hk_in_prefix]].
pose proof (Hk_in_prefix k v Hin) as k_gte_nn.
pose proof (follow_in_smap_gt fvar n1 nn sb' r instk_height ops Hfollow
  Hvalid_sb').
intuition.
Qed.


Lemma gt_neq: forall n m, n > m -> n =? m = false.
Proof.
intros n m. revert n.
induction m as [|m' IH].
- intros n Hgt.
  destruct n as [|n']; try intuition.
- intros n Hgt. 
  destruct n as [|n'].
  + intuition.
  + simpl. apply Gt.gt_S_n in Hgt.
    intuition.
Qed.


Lemma follow_in_smap_prefix_diff: forall fvar n1 n2 sb' r instk_height sb 
  ops prefix,
follow_in_smap (FreshVar fvar) n1 sb' = Some r ->
valid_bindings instk_height n2 sb ops ->
sb = prefix ++ sb' ->
forall k v, In (k,v) prefix -> k =? fvar = false.
Proof.
intros fvar n1 n2 sb' r instk_height sb ops prefix.
intros Hfollow Hvalid Hprefix.
intros k v Hin.
pose proof (follow_in_smap_prefix_gt fvar n1 n2 sb' r instk_height sb ops 
  prefix Hfollow Hvalid Hprefix k v Hin) as k_gte_n2.
apply gt_neq. assumption.
Qed.


Lemma follow_in_smap_prefix: forall fvar n1 n2 sb' r instk_height n3 sb ops
  prefix,
follow_in_smap (FreshVar fvar) n1 sb' = Some r ->
valid_bindings instk_height n2 sb ops ->
sb = prefix ++ sb' ->
follow_in_smap (FreshVar fvar) n3 (prefix ++ sb') = Some r.
Proof.
intros fvar n1 n2 sb' r instk_height n3 sb ops prefix.
revert fvar n1 n2 sb' r instk_height n3 sb ops.
induction prefix as [| h t IH].
- intros fvar n1 n2 sb' r instk_height n3 sb ops.
  intros Hfollow Hvalid Hprefix.
  simpl.
  rewrite -> follow_in_smap_fvar_maxidx_indep_eq with (m:=n1).
  assumption.
- intros fvar n1 n2 sb' r instk_height n3 sb ops.
  intros Hfollow Hvalid Hprefix.
  destruct h as [k v] eqn: eq_h.
  assert (In (k,v) ((k, v) :: t)) as Hin; try intuition.
  pose proof (follow_in_smap_prefix_diff fvar n1 n2 sb' r instk_height sb
    ops (((k, v) :: t)) Hfollow Hvalid Hprefix k v Hin) as Hk_fvar.
  simpl. rewrite -> Hk_fvar.
  rewrite Hprefix in Hvalid. simpl in Hvalid.
  destruct Hvalid as [_ [_ Hvalid_t]].
  assert (t ++ sb' = t ++ sb') as eq_t; try reflexivity.
  pose proof (IH fvar n1 k sb' r instk_height k (t ++ sb') ops Hfollow
    Hvalid_t eq_t).
  assumption.
Qed.


Lemma follow_no_fresh: forall sb sv idx sv' idx' sb',
follow_in_smap sv idx sb = Some (FollowSmapVal sv' idx' sb') ->
is_fresh_var_smv sv' = None.
Proof.
induction sb as [| h t IH].
- intros sv idx sv' idx' sb' Hfollow. simpl in Hfollow.
  destruct sv as [val|var|fvar].
  + injection Hfollow as eq_sv' _ _.
    rewrite <- eq_sv'. reflexivity.
  + injection Hfollow as eq_sv' _ _.
    rewrite <- eq_sv'. reflexivity.
  + discriminate.
- intros sv idx sv' idx' sb' Hfollow. simpl in Hfollow.
  destruct sv as [val|var|fvar].
  + injection Hfollow as eq_sv' _ _.
    rewrite <- eq_sv'. reflexivity.
  + injection Hfollow as eq_sv' _ _.
    rewrite <- eq_sv'. reflexivity.
  + destruct h as [key smv] eqn: eq_h.
    destruct (key =? fvar) eqn: eq_key_fvar.
    * destruct (is_fresh_var_smv smv) as [idx2|] eqn: eq_is_fresh.
      -- apply IH in Hfollow. assumption.
      -- injection Hfollow as eq_sv' _ _.
         rewrite <- eq_sv'. assumption.
    * apply IH in Hfollow. assumption.
Qed.


Lemma follow_suffix: forall sb sv idx sv' idx' sb',
follow_in_smap sv idx sb = Some (FollowSmapVal sv' idx' sb') ->
exists prefix, sb = prefix ++ sb'.
Proof. 
induction sb as [|h t IH].
- intros sv idx sv' idx' sb' Hfollow.
  destruct sv as [val|var|fvar].
  + simpl in Hfollow.
    injection Hfollow as eq_sv' eq_idx' eq_sb'.
    rewrite <- eq_sb'.
    exists []. reflexivity.
  + simpl in Hfollow.
    injection Hfollow as eq_sv' eq_idx' eq_sb'.
    rewrite <- eq_sb'.
    exists []. reflexivity.
  + simpl in Hfollow. discriminate.
- intros sv idx sv' idx' sb' Hfollow.
  destruct sv as [val|var|fvar].
  + simpl in Hfollow.
    injection Hfollow as eq_sv' eq_idx' eq_sb'.
    rewrite <- eq_sb'.
    exists []. reflexivity.
  + simpl in Hfollow.
    injection Hfollow as eq_sv' eq_idx' eq_sb'.
    rewrite <- eq_sb'.
    exists []. reflexivity.
  + simpl in Hfollow. 
    destruct h as [key value] eqn: eq_h. 
    destruct (key =? fvar) eqn: eq_key_fvar.
    * destruct (is_fresh_var_smv value) as [idx''|] eqn: eq_is_fresh.
      -- apply IH in Hfollow.
         destruct Hfollow as [prefix' eq_t].
         exists ((key, value)::prefix').
         rewrite -> eq_t.
         simpl.
         reflexivity.
      -- injection Hfollow as eq_sv' eq_idx' eq_sb'.
         rewrite -> eq_sb'.
         exists [(key, value)].
         simpl.
         reflexivity.
    * apply IH in Hfollow as [prefix' eq_t].
      exists ((key, value)::prefix').
      rewrite -> eq_t.
      reflexivity.
Qed.


Lemma eval_sstack_val'_extend_sb: forall instk_height n stk mem strg ctx 
  idx sb sb' ops prefix,
valid_bindings instk_height idx sb ops ->
sb = prefix ++ sb' ->
forall sv v,
eval_sstack_val' n sv stk mem strg ctx idx sb' ops = Some v ->
eval_sstack_val' n sv stk mem strg ctx idx sb ops = Some v.
Proof.
intros instk_height n stk mem strg ctx idx sb sb' ops prefix.
intros Hvalid Hprefix sv v Heval.
destruct n as [|n'] eqn: eq_n; try intuition.
destruct sv as [val|var|fvar] eqn: eq_sv.
- rewrite -> eval_sstack_val'_const.
  rewrite -> eval_sstack_val'_const in Heval.
  assumption.
- rewrite -> eval_sstack_val'_instackvar.
  rewrite -> eval_sstack_val'_instackvar in Heval.
  assumption.
- rewrite -> eval_sstack_val'_one_step in Heval. 
  destruct (follow_in_smap (FreshVar fvar) idx sb') as [follow_smap|] 
    eqn: Hfollow; try discriminate.
  rewrite -> eval_sstack_val'_one_step.
  pose proof (follow_in_smap_prefix fvar idx idx sb' follow_smap instk_height
    idx sb ops prefix Hfollow Hvalid Hprefix) as Hfollow'.
  rewrite <- Hprefix in Hfollow'.
  rewrite -> Hfollow'.
  assumption.
Qed.


Lemma eval_sstack_val'_extend_sb_indep: forall instk_height n d stk mem strg ctx 
  m1 m2 sb sb' ops prefix,
valid_bindings instk_height n sb ops ->
sb = prefix ++ sb' ->
forall sv v, 
eval_sstack_val' d sv stk mem strg ctx m1 sb' ops = Some v ->
eval_sstack_val' d sv stk mem strg ctx m2 sb ops = Some v.
Proof.
intros instk_height n d stk mem strg ctx m1 m2 sb sb' ops prefix.
intros Hvalid Hprefix sv v Heval.
rewrite -> eval'_maxidx_indep_eq with (m:=n) in Heval.
pose proof (eval_sstack_val'_extend_sb instk_height d stk mem strg ctx n
  sb sb' ops prefix Hvalid Hprefix sv v Heval) as Heval2.
rewrite -> eval'_maxidx_indep_eq with (m:=m2) in Heval2.
assumption.
Qed.


Lemma lambda_eval'_maxid_indep_eq: forall d stk mem strg ctx n m sb1 ops,
(fun sv : sstack_val =>
             eval_sstack_val' d sv stk mem strg ctx n sb1 ops) = 
(fun sv : sstack_val =>
             eval_sstack_val' d sv stk mem strg ctx m sb1 ops).
Proof.
intros.
apply functional_extensionality_dep.
intros x.
apply eval'_maxidx_indep_eq.
Qed.

Lemma lambda_eval'_eq: forall d stk mem strg ctx m1 m2 sb1 sb2 ops,
(forall (sv : sstack_val) (v : EVMWord),
    eval_sstack_val' d sv stk mem strg ctx m1 sb1 ops = Some v ->
    eval_sstack_val' d sv stk mem strg ctx m2 sb2 ops = Some v) ->
(forall sv v,
   (fun sv : sstack_val =>
      eval_sstack_val' d sv stk mem strg ctx m1 sb1 ops) sv = Some v ->
   (fun sv : sstack_val => 
      eval_sstack_val' d sv stk mem strg ctx m2 sb2 ops) sv = Some v).
Proof.
intuition.
Qed.



Lemma map_option_preserv_prefix: forall d stk mem strg ctx sb1 sb ops
  args vargs prefix instk_height n m1 m2,
map_option (fun sv : sstack_val =>
  eval_sstack_val' d sv stk mem strg ctx m1 sb1 ops) args = Some vargs ->
sb = prefix ++ sb1 ->
valid_bindings instk_height n sb ops ->
map_option (fun sv : sstack_val => 
  eval_sstack_val' d sv stk mem strg ctx m2 sb ops) args = Some vargs.
Proof.
intros d stk mem strg ctx sb1 sb ops args vargs prefix instk_height n m1 m2.
intros Hmapo Hprefix Hvalid.
pose proof (eval_sstack_val'_extend_sb_indep instk_height n d stk mem strg 
  ctx m1 m2 sb sb1 ops prefix Hvalid Hprefix) as Heq_evals.
pose proof (lambda_eval'_eq d stk mem strg ctx m1 m2 sb1 sb ops Heq_evals) as
  Hlambda_eq.
pose proof (map_option_preserv_functs
  (fun sv0 : sstack_val =>
     eval_sstack_val' d sv0 stk mem strg ctx m1 sb1 ops)
  (fun sv0 : sstack_val =>
     eval_sstack_val' d sv0 stk mem strg ctx m2 sb ops) 
  args vargs Hmapo Hlambda_eq) as eq_mapo2.
rewrite -> eq_mapo2.
reflexivity.  
Qed.


Lemma map_option_preserv_prefix_inst_mem: forall d stk mem strg ctx sb1 sb ops
  smem mem_updates prefix instk_height n m1 m2,
map_option (instantiate_memory_update (fun sv : sstack_val =>
  eval_sstack_val' d sv stk mem strg ctx m1 sb1 ops)) smem = 
    Some mem_updates ->
sb = prefix ++ sb1 ->
valid_bindings instk_height n sb ops ->
map_option (instantiate_memory_update (fun sv : sstack_val =>
  eval_sstack_val' d sv stk mem strg ctx m2 sb ops)) smem = 
    Some mem_updates.
Proof.
intros d stk mem strg ctx sb1 sb ops smem mem_updates prefix instk_height n 
  m1 m2 Hmapo Hprefix Hvalid.
pose proof (eval_sstack_val'_extend_sb_indep instk_height n d stk mem strg 
  ctx m1 m2 sb sb1 ops prefix Hvalid Hprefix) as Heq_evals.
pose proof (lambda_eval'_eq d stk mem strg ctx m1 m2 sb1 sb ops Heq_evals)
  as Heq_lambdas.
pose proof (same_instantiate_memory_update
  (fun sv0 : sstack_val =>
               eval_sstack_val' d sv0 stk mem strg ctx m1 sb1 ops)
  (fun sv0 : sstack_val =>
               eval_sstack_val' d sv0 stk mem strg ctx m2 sb ops)
  Heq_lambdas) as Heq_lambdas_inst_mem.  
pose proof (map_option_preserv_functs
  (instantiate_memory_update (fun sv0 : sstack_val =>
     eval_sstack_val' d sv0 stk mem strg ctx m1 sb1 ops))
  (instantiate_memory_update (fun sv0 : sstack_val => 
     eval_sstack_val' d sv0 stk mem strg ctx m2 sb ops))
  smem mem_updates Hmapo Heq_lambdas_inst_mem ) as eq_mapo2.
rewrite -> eq_mapo2.
reflexivity.
Qed.


Lemma map_option_preserv_prefix_inst_strg: forall d stk mem strg ctx sb1 sb ops
  sstrg strg_updates prefix instk_height n m1 m2,
map_option (instantiate_storage_update (fun sv : sstack_val =>
  eval_sstack_val' d sv stk mem strg ctx m1 sb1 ops)) sstrg 
    = Some strg_updates ->
sb = prefix ++ sb1 ->
valid_bindings instk_height n sb ops ->
map_option (instantiate_storage_update (fun sv : sstack_val =>
  eval_sstack_val' d sv stk mem strg ctx m2 sb ops)) sstrg 
    = Some strg_updates.
Proof.
intros d stk mem strg ctx sb1 sb ops sstrg strg_updates prefix instk_height n 
  m1 m2 Hmapo Hprefix Hvalid.
pose proof (eval_sstack_val'_extend_sb_indep instk_height n d stk mem strg 
  ctx m1 m2 sb sb1 ops prefix Hvalid Hprefix) as Heq_evals.
pose proof (lambda_eval'_eq d stk mem strg ctx m1 m2 sb1 sb ops Heq_evals)
  as Heq_lambdas.
pose proof (same_instantiate_storage_update
  (fun sv0 : sstack_val =>
               eval_sstack_val' d sv0 stk mem strg ctx m1 sb1 ops)
  (fun sv0 : sstack_val =>
               eval_sstack_val' d sv0 stk mem strg ctx m2 sb ops)
  Heq_lambdas) as Heq_lambdas_inst_strg.
pose proof (map_option_preserv_functs
  (instantiate_storage_update (fun sv : sstack_val =>
     eval_sstack_val' d sv stk mem strg ctx m1 sb1 ops))
  (instantiate_storage_update (fun sv : sstack_val =>
     eval_sstack_val' d sv stk mem strg ctx m2 sb ops)) 
  sstrg strg_updates Hmapo Heq_lambdas_inst_strg) as eq_mapo2.
rewrite -> eq_mapo2.
reflexivity.
Qed.


Lemma eval_sstack_val'_follow_in_smap: forall d sv stk mem strg ctx m
  sb ops v maxidx' sb' n sv_plain instk_height,
valid_bindings instk_height n sb ops ->  
eval_sstack_val' d sv stk mem strg ctx n sb ops 
  = Some v ->
follow_in_smap sv n sb = Some (FollowSmapVal sv_plain maxidx' sb') ->
eval_sstack_val' d (FreshVar n) stk mem strg ctx m 
  ((n, sv_plain) :: sb) ops = Some v.
Proof.
intros d sv stk mem strg ctx m sb ops v maxidx' sb' n sv_plain 
  instk_height Hvalid Heval Hfollow.
(* TODO: destruct sv, the current proof is valid for freshvars.
         for values and instackvars it should be straightforward
*)
destruct d as [|d'].
- simpl in Heval. discriminate.
- simpl in Heval. 
  destruct (follow_in_smap sv n sb) as [fsmap|] eqn: eq_follow_sv;
    try discriminate.
  destruct fsmap as [sv1 maxid1 sb1] eqn: eq_fsmap.
  pose proof (follow_suffix sb sv n sv1 maxid1 sb1 eq_follow_sv)
    as eq_follow_suff.
  destruct eq_follow_suff as [prefix eq_prefix].
  simpl. rewrite -> PeanoNat.Nat.eqb_refl.
  injection Hfollow as eq_sv_plain eq_maxidx' eq_sb'.
  apply follow_no_fresh in eq_follow_sv.
  rewrite <- eq_sv_plain.
  rewrite -> eq_follow_sv.
  case sv1 as [basicv|tag|op args|offset smem|key sstrg|offset size smem]
    eqn: eq_sv1.
  + (* SymBasicVal basicv *)
    destruct basicv as [val|var|fvar] eqn: eq_basicv; try assumption.
  + (* SymPUSHTAG tag *)
    assumption.
  + (* SymOp op args *)
    destruct (ops op) as [nargs f H_comm H_ctx_ind] eqn: eq_ops_op.
    destruct (length args =? nargs) eqn: eq_len; try discriminate.
    destruct (map_option
               (fun sv' : sstack_val =>
               eval_sstack_val' d' sv' stk mem strg ctx maxid1 sb1 ops) args)
      as [vargs|] eqn: eq_mapo; try discriminate.
    rewrite <- Heval.
    rewrite -> lambda_eval'_maxid_indep_eq with (m:=maxid1).
    pose proof (map_option_preserv_prefix d' stk mem strg ctx sb1 sb ops
      args vargs prefix instk_height n 
      maxid1 maxid1 eq_mapo eq_prefix Hvalid) as eq_mapo2.
    rewrite -> eq_mapo2.
    reflexivity.
  + (* SymMLOAD offset smem *)
    destruct (map_option
            (instantiate_memory_update
               (fun sv : sstack_val =>
                eval_sstack_val' d' sv stk mem strg ctx maxid1 sb1 ops))
            smem) as [mem_updates|] eqn: eq_mapo; try discriminate.
    destruct (eval_sstack_val' d' offset stk mem strg ctx maxid1 sb1 ops)  
      as [offsetv|] eqn: eq_eval_offset; try discriminate.
    rewrite <- Heval.
    pose proof (map_option_preserv_prefix_inst_mem d' stk mem strg ctx sb1
      sb ops smem mem_updates prefix
      instk_height n maxid1 n eq_mapo eq_prefix Hvalid) as eq_mapo2.
    rewrite -> eq_mapo2.
    pose proof (eval_sstack_val'_extend_sb_indep instk_height n d' stk mem 
      strg ctx maxid1 n sb sb1 ops prefix Hvalid eq_prefix
      offset offsetv eq_eval_offset) as eq_eval_offset2.
    rewrite -> eq_eval_offset2.
    reflexivity.
  + (* SymSLOAD key sstrg *)
    destruct (map_option
            (instantiate_storage_update
               (fun sv : sstack_val =>
                eval_sstack_val' d' sv stk mem strg ctx maxid1 sb1 ops))
            sstrg) as [strg_updates|] eqn: eq_mapo; try discriminate.
    destruct (eval_sstack_val' d' key stk mem strg ctx maxid1 sb1 ops)
      as [keyv|] eqn: eq_eval_key; try discriminate.
    rewrite <- Heval.
    pose proof (map_option_preserv_prefix_inst_strg d' stk mem strg ctx sb1
      sb ops sstrg strg_updates prefix
      instk_height n maxid1 n eq_mapo eq_prefix Hvalid) as eq_mapo2.
    rewrite -> eq_mapo2.
    pose proof (eval_sstack_val'_extend_sb_indep instk_height n d' stk mem 
      strg ctx maxid1 n sb sb1 ops prefix Hvalid eq_prefix
      key keyv eq_eval_key) as eq_eval_key2.
    rewrite -> eq_eval_key2.
    reflexivity.
  + (* SymSHA3 offset size smem *)
    destruct (map_option
            (instantiate_memory_update
               (fun sv : sstack_val =>
                eval_sstack_val' d' sv stk mem strg ctx maxid1 sb1 ops))
            smem) as [mem_updates|] eqn: eq_mapo; try discriminate.
    destruct (eval_sstack_val' d' offset stk mem strg ctx maxid1 sb1 ops)
      as [offsetv|] eqn: eq_eval_offset; try discriminate.
    destruct (eval_sstack_val' d' size stk mem strg ctx maxid1 sb1 ops)
      as [sizev|] eqn: eq_eval_size; try discriminate.
    rewrite <- Heval.
    pose proof (map_option_preserv_prefix_inst_mem d' stk mem strg ctx sb1
      sb ops smem mem_updates prefix
      instk_height n maxid1 n eq_mapo eq_prefix Hvalid) as eq_mapo2.
    rewrite -> eq_mapo2.
    pose proof (eval_sstack_val'_extend_sb_indep instk_height n d' stk mem 
      strg ctx maxid1 n sb sb1 ops prefix Hvalid eq_prefix offset offsetv 
      eq_eval_offset) as eq_eval_offset2.
    rewrite -> eq_eval_offset2.
    pose proof (eval_sstack_val'_extend_sb_indep instk_height n d' stk mem 
      strg ctx maxid1 n sb sb1 ops prefix Hvalid eq_prefix
      size sizev eq_eval_size) as eq_eval_size2.
    rewrite -> eq_eval_size2.
    reflexivity.
Qed.



(* Weak version of valid_bindings that do not require sb to be a 
   decreasing sequence (maxid, _);(maxid-1,_);...;(0,_) 
   Useful when you need to use only the information of the values being
   well-formed wrt. instk_height and maxid
*)
Fixpoint valid_bindings' (instk_height: nat) (maxid: nat) (sb: sbindings) (ops: stack_op_instr_map): Prop :=
  match sb with
  | [] => True
  | (idx,value)::sb' => valid_smap_value instk_height idx ops value /\ valid_bindings' instk_height maxid sb' ops
  end.
  
      
Lemma valid_bindings'_succ: forall sb instk_height k ops,
valid_bindings' instk_height k sb ops ->
valid_bindings' instk_height (S k) sb ops.
Proof.
induction sb as [| h t IH].
- intuition.
- intros instk_height k ops Hvalid_k.
  simpl in Hvalid_k. simpl.
  destruct h as [key smv] eqn: eq_h.
  intuition.
Qed.
  
Lemma valid_bindings_bindings': forall sb instk_height k ops,
valid_bindings instk_height k sb ops ->
valid_bindings' instk_height k sb ops.
Proof.
induction sb as [|h t IH].
- intros instk_height k ops Hvalid.
  simpl. intuition.
- intros instk_height k ops Hvalid.
  simpl in Hvalid. simpl.
  destruct h as [key smv] eqn: eq_h.
  destruct Hvalid as [eq_k [eq_valid_smap_value eq_valid_bindings]].
  split.
  + assumption.
  + pose proof (IH instk_height key ops eq_valid_bindings). 
    apply valid_bindings'_succ in H.
    rewrite -> eq_k.
    assumption.
Qed.


Lemma is_fresh_var_some: forall v idx,
is_fresh_var_smv v = Some idx ->
v = SymBasicVal (FreshVar idx).
Proof.
intros v idx His_fresh.
destruct v; try (simpl in His_fresh; discriminate).
simpl in His_fresh.
destruct val as [v|var|fvar]; try discriminate.
injection His_fresh as eq_fvar.
rewrite -> eq_fvar.
reflexivity.
Qed.


Lemma valid_bindings'_follow_valid_smap: forall sb instk_height idx ops smv
  sv n' sb',
valid_bindings' instk_height idx sb ops ->
valid_sstack_value instk_height idx sv ->
follow_in_smap sv idx sb = Some (FollowSmapVal smv n' sb') ->
valid_smap_value instk_height n' ops smv /\
n' <= idx.
Proof.
induction sb as [|h t IH].
- intros instk_height idx ops smv sv n' sb' Hvalid_sb Hvalid_sv Hfollow. 
  simpl in Hfollow. 
  destruct sv as [val|var|fvar] eqn: eq_sv.
  + injection Hfollow as eq_smv eq_n' eq_sb'.
    rewrite <- eq_smv. rewrite <- eq_n'.
    split; try intuition.
  + injection Hfollow as eq_smv eq_n' eq_sb'.
    rewrite <- eq_smv. rewrite <- eq_n'.
    split.
    * simpl. simpl in Hvalid_sv. assumption.
    * intuition.
  + discriminate.
- intros instk_height idx ops smv sv n' sb' Hvalid_sb Hvalid_sv Hfollow. 
  simpl in Hfollow. 
  destruct sv as [val|var|fvar] eqn: eq_sv.
  + injection Hfollow as eq_smv eq_n' eq_sb'.
    rewrite <- eq_smv. rewrite <- eq_n'.
    split; try intuition.
  + injection Hfollow as eq_smv eq_n' eq_sb'.
    rewrite <- eq_smv. rewrite <- eq_n'.
    split.
    * simpl. simpl in Hvalid_sv. assumption.
    * intuition.
  + destruct h as [k v] eqn: eq_h. 
    destruct (k =? fvar) eqn: eq_k_fvar.
    * simpl in Hvalid_sb.
      destruct Hvalid_sb as [eq_valid_k Hvalid_t].
      destruct (is_fresh_var_smv v) as [idx'|] eqn: eq_fresh_v.
      -- apply IH with (sv:=(FreshVar idx'))(sb':=sb');
           try assumption. 
         ++ apply is_fresh_var_some in eq_fresh_v.
            rewrite -> eq_fresh_v in eq_valid_k.
            simpl in eq_valid_k.
            simpl. simpl in Hvalid_sv.
            apply PeanoNat.Nat.eqb_eq in eq_k_fvar.
            intuition.
         ++ rewrite -> follow_in_smap_fvar_maxidx_indep_eq with (m:=idx) 
              in Hfollow. assumption.
      -- simpl in Hvalid_sv. pose proof (IH instk_height idx ops smv). 
         apply PeanoNat.Nat.eqb_eq in eq_k_fvar.
         injection Hfollow as eq_smv eq_k eq_t.
         rewrite <- eq_k_fvar in Hvalid_sv.
         rewrite <- eq_k.
         rewrite <- eq_smv.
         intuition.
    * simpl in Hvalid_sb.
      destruct Hvalid_sb as [eq_valid_k Hvalid_t].
      rewrite -> follow_in_smap_fvar_maxidx_indep_eq with (m:=idx) in Hfollow.
      apply IH with(sv:=(FreshVar fvar))(sb':=sb'); try assumption.
Qed.


Lemma valid_smap_value_incr: forall (m instk_height n : nat) 
  (ops : stack_op_instr_map) (smapv : smap_value),
valid_smap_value instk_height n ops smapv ->
valid_smap_value instk_height (n+m) ops smapv.
Proof.
induction m as [|m' IH].
- intuition. rewrite -> PeanoNat.Nat.add_0_r. assumption.
- intros instk_height n ops smap_value Hvalid_n.
  rewrite -> PeanoNat.Nat.add_succ_r.
  apply valid_smap_value_succ in Hvalid_n.
  apply IH in Hvalid_n.
  intuition.
Qed.  


Lemma leq_add: forall n m, 
n <= m -> exists k, n+k=m.
Proof.
intros n m. revert n.
induction m as [|m' IH].
- intros n Hleq. exists 0. intuition.
- intros n Hleq.
  destruct n as [|n'] eqn: eq_n.
  + exists (S m'). intuition.
  + apply Le.le_S_n in Hleq.
    apply IH in Hleq as [k' eq_n'_k'].
    exists k'. intuition.
Qed.


Lemma leq_diff_lt: forall n m,
n <= m -> n <> m -> n < m.
Proof.
intros n m Hleq Hdiff.
intuition.
Qed.


(* Calling follow_in_smap with valid bindings and a valid smap_value 
   cannot return None *)
Lemma valid_follow_not_none: forall instk_height idx sv sb ops,
valid_sstack_value instk_height idx sv ->
valid_bindings instk_height idx sb ops ->
follow_in_smap sv idx sb <> None.
Proof.
intros instk_height idx sv sb. revert instk_height idx sv.
induction sb as [| h t IH].
- intros instk_height idx sv ops Hvalid_sstack Hvalid_bindings.
  destruct sv as [val|var|fvar] eqn: eq_sv.
  + simpl. intuition. discriminate.
  + simpl. intuition. discriminate.
  + simpl. simpl in Hvalid_sstack. simpl in Hvalid_bindings. 
    intuition.
- intros instk_height idx sv ops Hvalid_sstack Hvalid_bindings.
  destruct sv as [val|var|fvar] eqn: eq_sv.
  + simpl. intuition. discriminate.
  + simpl. intuition. discriminate.
  + simpl. destruct h as [key smv] eqn: eq_h.
    destruct (key =? fvar) eqn: eq_key_fvar.
    * destruct (is_fresh_var_smv) eqn: eq_is_fresh.
      -- apply is_fresh_var_some in eq_is_fresh.
         rewrite eq_is_fresh in Hvalid_bindings.
         simpl in Hvalid_bindings.
         destruct Hvalid_bindings as [Hidx [Hn_key Hvalid_t]].
         apply IH with (instk_height:=instk_height)(ops:=ops); try assumption.
      -- intuition. discriminate. 
    * simpl in Hvalid_bindings.
      destruct Hvalid_bindings as [Hidx [Hvalid_smap Hvalid_t]].
      apply IH with (instk_height:=instk_height)(ops:=ops); try assumption.
      simpl. simpl in Hvalid_sstack.
      rewrite -> Hidx in Hvalid_sstack.
      apply Lt.lt_n_Sm_le in Hvalid_sstack.
      apply leq_diff_lt; try assumption.
      apply EqNat.beq_nat_false.
      rewrite PeanoNat.Nat.eqb_sym. assumption.
Qed.



Lemma follow_succ_no_fv: forall sb sb' smv idx a idx',
follow_in_smap smv idx sb = Some (FollowSmapVal a idx' sb') ->
is_fresh_var_smv a = None.
Proof.
induction sb as [| h t IH].
- intros sb' smv idx a idx' Hfollow.
  simpl in Hfollow. 
  destruct smv as [val|var|fvar]; 
    try (injection Hfollow as eq_a _ _;
         rewrite <- eq_a;
         reflexivity).
  discriminate.
- intros sb' smv idx a idx' Hfollow.
  destruct h as [key value].
  simpl in Hfollow.
  destruct smv as [val|var|fvar];
    try (injection Hfollow as eq_a _ _;
         rewrite <- eq_a;
         reflexivity).
  destruct (key =? fvar) eqn: eq_key_fvar.
  + destruct (is_fresh_var_smv value) eqn: eq_is_fresh.
    * apply IH in Hfollow. assumption. 
    * injection Hfollow as eq_a_value _ _.
      rewrite <- eq_a_value.
      assumption.
  + apply IH in Hfollow. assumption.
Qed.


Lemma optimize_add_0_sbinding_snd:
opt_sbinding_snd optimize_add_0_sbinding.
Proof.
unfold opt_sbinding_snd.
intros val val' fcmp sb maxidx instk_height idx flag Hsafe_sstack_val_cmp
  Hvalid Hoptm_add_0_sbinding.
split.
- (* valid_sbindings *)
  (* IDEA: use general lemma for every "safe" optimization, i.e., 
       if val is valid_smap_value wrt. n then val' is valid_smap_value 
       wrt. n
  *)
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
unfold optim_snd. intros sst sst' b Hvalid_sst_fv Hoptim.
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
      sst sst' b Hvalid_sst_fv optimize_add_0_sbinding_snd Hsafe_fcmp Hoptim)
    as Hpreserv.
    destruct Hpreserv as [_ Heval2_imp].
    apply Heval2_imp.
    assumption.
Qed.



End Optimizations_Def.

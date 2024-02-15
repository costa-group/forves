Require Import Arith. 
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import Coq.NArith.NArith.
Require Import List.
Import ListNotations.
Require Import Coq.Logic.FunctionalExtensionality.

Require Import FORVES.constants.
Import Constants.

Require Import FORVES.program.
Import Program.

Require Import FORVES.execution_state.
Import ExecutionState.

Require Import FORVES.stack_operation_instructions.
Import StackOpInstrs.

Require Import FORVES.misc.
Import Misc.

Require Import FORVES.symbolic_state.
Import SymbolicState.


Module ValidSymbolicState.


Definition valid_sstack_value (instk_height: nat) (maxidx: nat) (value : sstack_val) : Prop :=
  match value with
  | Val _ => True
  | InStackVar n => n < instk_height
  | FreshVar idx => idx < maxidx
  end.

(* All InStackVar in the sstack are smaller than instk_height and all the 
   FreshVar in the sstack are less than maxidx *)
Fixpoint valid_sstack (instk_height: nat) (maxidx: nat) (sstk : sstack) : Prop :=
  match sstk with
  | [] => True
  | sv::sstk' => valid_sstack_value instk_height maxidx sv /\ valid_sstack instk_height maxidx sstk'
  end.

Definition valid_smemory_update (instk_height: nat) (maxidx: nat) (u : memory_update sstack_val) : Prop :=
  match u with
  | U_MSTORE _ offset value | U_MSTORE8 _ offset value => valid_sstack_value instk_height maxidx offset /\ valid_sstack_value instk_height maxidx value
  end.

Fixpoint valid_smemory (instk_height: nat) (maxidx: nat) (smem : smemory) : Prop :=
  match smem with
  | [] => True
  | u::smem' => valid_smemory_update instk_height maxidx u /\ valid_smemory instk_height maxidx smem'
  end.

Definition valid_sstorage_update (instk_height: nat) (maxidx: nat) (u : storage_update sstack_val) : Prop :=
  match u with
  | U_SSTORE _ offset value => valid_sstack_value instk_height maxidx offset /\ valid_sstack_value instk_height maxidx value
  end.

Fixpoint valid_sstorage (instk_height: nat) (maxidx: nat) (sstrg : sstorage) : Prop :=
  match sstrg with
  | [] => True
  | u::sstrg' => valid_sstorage_update instk_height maxidx u /\ valid_sstorage instk_height maxidx sstrg'
  end.

Definition valid_stack_op_instr (instk_height: nat) (maxidx: nat) (ops: stack_op_instr_map) (label: stack_op_instr) (args: list sstack_val): Prop :=
  match (ops label) with
  | OpImp nargs _ _ _ => length args = nargs /\  valid_sstack instk_height maxidx args
  end.
               
Definition valid_smap_value (instk_height: nat) (maxidx: nat) (ops: stack_op_instr_map) (value: smap_value) : Prop :=
  match value with
  | SymBasicVal v => valid_sstack_value instk_height maxidx v
  | SymMETAPUSH _ _ => True
  | SymOp label args => valid_stack_op_instr instk_height maxidx ops label args 
  | SymMLOAD offset smem => valid_sstack_value instk_height maxidx offset /\ valid_smemory instk_height maxidx smem
  | SymSLOAD key sstrg => valid_sstack_value instk_height maxidx key /\ valid_sstorage instk_height maxidx sstrg
  | SymSHA3 offset size smem => valid_sstack_value instk_height maxidx offset /\ valid_sstack_value instk_height maxidx size /\ valid_smemory instk_height maxidx smem
  end.

(* all keys defined *)
Fixpoint valid_bindings (instk_height: nat) (maxid: nat) (sb: sbindings) (ops: stack_op_instr_map): Prop :=
  match sb with
  | [] => maxid = 0
  | (idx,value)::sb' => maxid = (S idx) /\ valid_smap_value instk_height idx ops value /\ valid_bindings instk_height idx sb' ops
  end.


(*
(* MaxIDX is > any fresh variable in the map *)
Fixpoint fresh_var_gt_map (idx: nat) (sb: sbindings) : Prop :=
match sb with 
| nil => True
| (k,v)::sb' => idx > k /\ fresh_var_gt_map idx sb'
end.

(* Fresh variables in a map are strictly decreasing *)
Fixpoint strictly_decreasing_map (sb: sbindings) : Prop :=
match sb with
| [] => True
| (var1, e1)::sb' => match sb' with 
                     | [] => True
                     | (var2, e2)::_ => var1 > var2 /\ strictly_decreasing_map sb'
                     end
end.*)

Definition valid_smap (instk_height: nat) (maxidx: nat) (sb: sbindings) (ops: stack_op_instr_map): Prop :=
    valid_bindings instk_height maxidx sb ops.


Definition valid_sstate (sst: sstate) (ops: stack_op_instr_map): Prop :=
  let instk_height := get_instk_height_sst sst in
  let sstk := get_stack_sst sst in
  let smem := get_memory_sst sst in
  let sstrg := get_storage_sst sst in
  let m := get_smap_sst sst in
  let maxidx := get_maxidx_smap m in
  let sb := get_bindings_smap m in
    valid_smap instk_height maxidx sb ops /\ 
    valid_sstack instk_height maxidx sstk /\
    valid_smemory instk_height maxidx smem /\
    valid_sstorage instk_height maxidx sstrg.


(*Lemma fresh_var_gt_map_maxidx_S:
  forall sb maxidx,
    fresh_var_gt_map maxidx sb ->
    fresh_var_gt_map (S maxidx) sb.
Proof.
  induction sb as [|v sb' IHsm'].
  - auto.
  - intros.
    unfold fresh_var_gt_map in H.
    fold fresh_var_gt_map in H.
    destruct v as [k kvalue].
    destruct H.
    unfold fresh_var_gt_map.
    fold fresh_var_gt_map.
    split.
    + auto.
    + apply IHsm'.
      apply H0.
Qed.*)


Lemma valid_sstack_app:
  forall instk_height maxidx l1 l2,
    valid_sstack instk_height maxidx l1 ->
    valid_sstack instk_height maxidx l2 ->
    valid_sstack instk_height maxidx (l1++l2).
Proof.
  intros instk_height maxidx.
  induction l1 as [|sv l1' IHl1'].
  - intros l2 H_l1 H_l2.
    simpl.
    apply H_l2.
  - intros l2 H_l1 H_l2.
    simpl in H_l1.
    destruct H_l1 as [H_l1_0 H_l1_1].
    simpl.
    split.
    + apply H_l1_0.
    + apply IHl1'.
      * apply H_l1_1.
      * apply H_l2.
Qed.

Lemma valid_sstack_app1:
  forall instk_height maxidx l1 l2,
    valid_sstack instk_height maxidx (l1++l2) ->
    valid_sstack instk_height maxidx l1 /\
    valid_sstack instk_height maxidx l2.
Proof.
  intros instk_height maxidx.
  induction l1 as [|sv l1' IHl1'].
  - intros l2 H_l1_l2.
    simpl.
    simpl in H_l1_l2.
    split.
    + apply I.
    + apply H_l1_l2.
  - intros l2 H_l1_l2.
    simpl in H_l1_l2.
    destruct H_l1_l2 as [H_sv H_l1'_l2].
    simpl.
    pose proof (IHl1' l2 H_l1'_l2) as [IHl1'_0 IHl1'_1].
    split.
    + split.
      * apply H_sv.
      * apply IHl1'_0.
    + apply IHl1'_1.
Qed.

Lemma valid_sstack_value_S_maxidx:
  forall instk_height maxidx sv,
    valid_sstack_value instk_height maxidx sv ->
    valid_sstack_value instk_height (S maxidx) sv.
Proof.
  intros instk_height maxidx sv H_valid_sv.
  destruct sv; simpl; try auto.
Qed.

Lemma valid_sstack_value_S_instk_height:
  forall instk_height maxidx sv,
    valid_sstack_value instk_height maxidx sv ->
    valid_sstack_value (S instk_height) maxidx sv.
Proof.
  intros instk_height maxidx sv H_valid_sv.
  destruct sv; simpl; try auto.
Qed.

Lemma valid_sstack_S_maxidx:
  forall instk_height maxidx l,
    valid_sstack instk_height maxidx l ->
    valid_sstack instk_height (S maxidx) l.
Proof.
  intros instk_height maxidx.
  induction l as [|sv l' IHl'].
  - intuition.
  - simpl.
    intros H_l.
    destruct H_l as [H_l_0 H_l_1].
    split.
    + apply valid_sstack_value_S_maxidx. apply H_l_0.
    + apply IHl'. apply H_l_1.
Qed.

Lemma valid_sstack_S_instk_height:
  forall instk_height maxidx l,
    valid_sstack instk_height maxidx l ->
    valid_sstack (S instk_height) maxidx l.
Proof.
  intros instk_height maxidx.
  induction l as [|sv l' IHl'].
  - intuition.
  - simpl.
    intros H_l.
    destruct H_l as [H_l_0 H_l_1].
    split.
    + apply valid_sstack_value_S_instk_height. apply H_l_0.
    + apply IHl'. apply H_l_1.
Qed.

Lemma valid_empty_sstate:
  forall k ops, valid_sstate (gen_empty_sstate k) ops.
Proof.
  intros k ops.
  unfold valid_sstate.
  split; split.
  
  (*+ unfold valid_smap.
    simpl.
    auto.
  + simpl.
    auto.*)
  + simpl.
    induction k as [|k' IHsk'].    
    * simpl.
      apply I.
    * rewrite seq_S.
      rewrite List.map_app. 
      apply valid_sstack_app.
      ** apply valid_sstack_S_instk_height.
         apply IHsk'.
      ** simpl. intuition.
  + simpl.
    intuition.
Qed.



Lemma add_to_smap_valid_smap:
  forall instk_height idx m m' smv ops,
    valid_smap instk_height (get_maxidx_smap m) (get_bindings_smap m) ops ->
    valid_smap_value instk_height (get_maxidx_smap m) ops smv ->
    add_to_smap m smv = (idx, m') ->
    valid_smap instk_height (get_maxidx_smap m') (get_bindings_smap m') ops.
Proof. 
  intros instk_height idx m m' smv ops H_valid_m H_valid_smv H_add.

  destruct m as [maxidx sb] eqn:E_m.
  destruct m' as [maxidx' sb'] eqn:E_m'.
  
  unfold valid_smap in H_valid_m.
  (*destruct H_valid_m as [H_valid_m_0 [H_valid_m_1 H_valid_m_2]].*)
  (*destruct H_valid_m as [H_valid_m_0 [H_valid_m_1 H_valid_m_2]].*)

  assert(H_add' :=  H_add).
  simpl in H_add'.
  injection H_add' as H_maxidx H_maxidx' H_sb'.  

  unfold valid_smap.

  rewrite <- H_sb'.
  simpl.
  split.

  * intuition.
  * simpl in H_valid_smv.
    split.
        
    ** apply H_valid_smv.
    ** simpl in H_valid_m.
       apply H_valid_m.
Qed. 

Lemma add_to_smap_valid_sstack:
  forall instk_height idx m m' smv sstk ops,
    valid_sstack instk_height (get_maxidx_smap m) sstk ->
    valid_smap_value instk_height (get_maxidx_smap m) ops smv ->
    add_to_smap m smv = (idx, m') ->
    valid_sstack instk_height (get_maxidx_smap m') sstk.
Proof.
  intros instk_height idx m m' smv sstk ops H_valid_sstk H_valid_smv H_add_to_map.
  destruct m as [maxid sb] eqn:E_m.
  destruct m' as [maxid' sb'] eqn:E_m'.
  assert (H_add_to_map' := H_add_to_map).
  unfold add_to_smap in H_add_to_map'.
  injection H_add_to_map' as H_maxid H_maxid' H_sb'.
  simpl.
  simpl in H_valid_sstk.
  simpl in H_valid_smv.
  rewrite <- H_maxid'.
  apply valid_sstack_S_maxidx.
  apply H_valid_sstk.
Qed.

Lemma add_to_smap_valid_sstack_value:
  forall instk_height idx m m' smv sv ops,
    valid_sstack_value instk_height (get_maxidx_smap m) sv ->
    valid_smap_value instk_height (get_maxidx_smap m) ops smv ->
    add_to_smap m smv = (idx, m') ->
    valid_sstack_value instk_height (get_maxidx_smap m') sv.
Proof.
  intros instk_height idx m m' smv sv ops H_valid_sv H_valid_smv H_add_to_smap.
  destruct m as [maxid sb] eqn:E_m.
  destruct m' as [maxid' sb'] eqn:E_m'.
  simpl.
  simpl in H_valid_sv. 
  simpl in H_valid_smv.
  simpl in H_add_to_smap.
  injection H_add_to_smap as H_maxidx H_maxidx' H_sb'.
  rewrite <-  H_maxidx'.
  apply valid_sstack_value_S_maxidx.
  apply H_valid_sv.
Qed.

(*
Lemma valid_sbinings_S_maxidx:
  forall instk_height maxidx ops u sb,
    valid_bindings instk_height maxidx (u::sb) ops ->
    valid_bindings instk_height (S maxidx) (u::sb) ops.
Proof.
  intros instk_height maxidx ops u.
  induction sb as [|x sb' IHsb'].
  - intros H_valid_bs.
    simpl.
    intros H_maxidx.
    destruct u.
    simpl in H_maxidx.
    destruct maxidx; try discriminate.
    simpl.
*)

Lemma valid_smemory_update_S_maxidx:
  forall instk_height maxidx u,
    valid_smemory_update instk_height maxidx u ->
    valid_smemory_update instk_height (S maxidx) u.
Proof.
  intros instk_height maxidx u H_valid_u.
  destruct u as [offset value|offset value].
  - simpl.
    simpl in H_valid_u.
    destruct H_valid_u as [H_valid_u_0 H_valid_u_1].
    split.
    + apply valid_sstack_value_S_maxidx.
      apply H_valid_u_0.
    + apply valid_sstack_value_S_maxidx.
      apply H_valid_u_1.
  - simpl.
    simpl in H_valid_u.
    destruct H_valid_u as [H_valid_u_0 H_valid_u_1].
    split.
    + apply valid_sstack_value_S_maxidx.
      apply H_valid_u_0.
    + apply valid_sstack_value_S_maxidx.
      apply H_valid_u_1.
Qed.

Lemma valid_smemory_S_maxidx:
  forall instk_height maxidx smem,
    valid_smemory instk_height maxidx smem ->
    valid_smemory instk_height (S maxidx) smem.
Proof.
  intros instk_height maxidx.
  induction smem as [|u smem' IHsmem'].
  - auto.
  - simpl.
    intro H_valid_smem.
    destruct H_valid_smem as [H_valid_smem_0 H_valid_smem_1].
    split.
    + apply valid_smemory_update_S_maxidx.
      apply H_valid_smem_0.
    + apply IHsmem'.
      apply H_valid_smem_1.
Qed.
    
Lemma valid_sstorage_update_S_maxidx:
  forall instk_height maxidx u,
    valid_sstorage_update instk_height maxidx u ->
    valid_sstorage_update instk_height (S maxidx) u.
Proof.
  intros instk_height maxidx u H_valid_u.
  destruct u as [offset value].
  simpl.
  simpl in H_valid_u.
  destruct H_valid_u as [H_valid_u_0 H_valid_u_1].
  split.
  + apply valid_sstack_value_S_maxidx.
    apply H_valid_u_0.
  + apply valid_sstack_value_S_maxidx.
    apply H_valid_u_1.
Qed.

Lemma valid_sstorage_S_maxidx:
  forall instk_height maxidx sstrg,
    valid_sstorage instk_height maxidx sstrg ->
    valid_sstorage instk_height (S maxidx) sstrg.
Proof.
  intros instk_height maxidx.
  induction sstrg as [|u sstrg' IHsstrg'].
  - auto.
  - simpl.
    intro H_valid_sstrg.
    destruct H_valid_sstrg as [H_valid_sstrg_0 H_valid_sstrg_1].
    split.
    + apply valid_sstorage_update_S_maxidx.
      apply H_valid_sstrg_0.
    + apply IHsstrg'.
      apply H_valid_sstrg_1.
Qed.

Lemma add_to_smap_valid_smemory:
  forall instk_height idx m m' smv smem ops,
    valid_smemory instk_height (get_maxidx_smap m) smem ->
    valid_smap_value instk_height (get_maxidx_smap m) ops smv ->
    add_to_smap m smv = (idx, m') ->
    valid_smemory instk_height (get_maxidx_smap m') smem.
Proof.
  intros instk_height idx m m' smv smem ops H_valid_smem H_valid_smv H_add_to_map.
  destruct m as [maxid sb] eqn:E_m.
  destruct m' as [maxid' sb'] eqn:E_m'.
  assert (H_add_to_map' := H_add_to_map).
  unfold add_to_smap in H_add_to_map'.
  injection H_add_to_map' as H_maxid H_maxid' H_sb'.
  rewrite <- H_sb'.
  simpl.
  rewrite <- H_maxid'.
  apply valid_smemory_S_maxidx.
  simpl in H_valid_smem.
  apply H_valid_smem.
Qed.

Lemma add_to_smap_valid_sstorage:
  forall instk_height idx m m' smv sstrg ops,
    valid_sstorage instk_height (get_maxidx_smap m) sstrg ->
    valid_smap_value instk_height (get_maxidx_smap m) ops smv ->
    add_to_smap m smv = (idx, m') ->
    valid_sstorage instk_height (get_maxidx_smap m') sstrg.
Proof.
  intros instk_height idx m m' smv sstrg ops H_valid_sstrg H_valid_smv H_add_to_map.
  destruct m as [maxid sb] eqn:E_m.
  destruct m' as [maxid' sb'] eqn:E_m'.
  assert (H_add_to_map' := H_add_to_map).
  unfold add_to_smap in H_add_to_map'.
  injection H_add_to_map' as H_maxid H_maxid' H_sb'.
  rewrite <- H_sb'.
  simpl.
  rewrite <- H_maxid'.
  apply valid_sstorage_S_maxidx.
  simpl in H_valid_sstrg.
  apply H_valid_sstrg.
Qed.

Lemma add_to_map_valid_sstate:
  forall sst idx m smv ops,
    valid_sstate sst ops ->
    valid_smap_value (get_instk_height_sst sst) (get_maxidx_smap (get_smap_sst sst)) ops smv ->
    (idx,m) = add_to_smap (get_smap_sst sst) smv ->
    valid_sstate (set_smap_sst sst m) ops.
Proof. 
  intros sst idx m smv ops.

  unfold valid_sstate.
  rewrite set_and_then_get_smap_sst.
  rewrite instk_height_preserved_when_updating_smap_sst.
  rewrite sstack_preserved_when_updating_smap_sst.
  rewrite smemory_preserved_when_updating_smap_sst.
  rewrite sstorage_preserved_when_updating_smap_sst.

  intros H_valid_sst H_valid_smap_value H_add_to_smap.
  destruct H_valid_sst as [H_valid_sst_0 [H_valid_sst_1 [H_valid_sst_2 H_valid_sst_3]]].
 
  split.

  (* The case of smap *)
  - symmetry in H_add_to_smap.
    pose proof (add_to_smap_valid_smap (get_instk_height_sst sst) idx (get_smap_sst sst) m smv ops H_valid_sst_0 H_valid_smap_value H_add_to_smap) as H_add_to_smap_valid_smap.
    apply H_add_to_smap_valid_smap.

  - split.

    (* The case of ssstack *)
    + symmetry in H_add_to_smap.
      pose proof (add_to_smap_valid_sstack (get_instk_height_sst sst) idx (get_smap_sst sst) m smv (get_stack_sst sst) ops H_valid_sst_1 H_valid_smap_value H_add_to_smap) as H_add_to_smap_valid_sstack.
      apply H_add_to_smap_valid_sstack.

    + split.

    (* The case of smemory *)
    * symmetry in H_add_to_smap.
      pose proof (add_to_smap_valid_smemory (get_instk_height_sst sst) idx (get_smap_sst sst) m smv (get_memory_sst sst) ops  H_valid_sst_2 H_valid_smap_value H_add_to_smap) as H_add_to_smap_valid_smemory.
      apply H_add_to_smap_valid_smemory.
        
    (* The case of sstorage *)
    * symmetry in H_add_to_smap.
      pose proof (add_to_smap_valid_sstorage (get_instk_height_sst sst) idx (get_smap_sst sst) m smv (get_storage_sst sst) ops H_valid_sst_3 H_valid_smap_value H_add_to_smap) as H_add_to_smap_valid_sstorage.
      apply H_add_to_smap_valid_sstorage.
Qed.


(* when adding a value of the map, it key is smaller that maxidx of th enew map *)
Lemma add_to_smap_key_lt_maxidx:
  forall m m' key smv,
    (key,m') = add_to_smap m smv ->
    key < get_maxidx_smap m'.
Proof.
  intros m m' key smv H_add_to_smap.
  destruct m as [maxid sb].
  simpl in H_add_to_smap.
  injection H_add_to_smap as H_maxid H_m'.
  rewrite H_m'.
  simpl.
  rewrite H_maxid.
  apply Nat.lt_succ_diag_r.
Qed.


Lemma valid_follow_in_smap:
  forall sb sv instk_height maxidx ops smv maxidx' sb',
    valid_sstack_value instk_height maxidx sv ->
    valid_bindings instk_height maxidx sb ops ->
    follow_in_smap sv maxidx sb = Some (FollowSmapVal smv maxidx' sb') ->
    valid_smap_value instk_height maxidx' ops smv /\
      valid_bindings instk_height maxidx' sb' ops /\
      (not_basic_value_smv smv = true -> maxidx > maxidx').
Proof.
  induction sb as [|p sb'' IHsb''].
  - intros sv instk_height maxidx ops smv maxidx' sb' H_valid_sv H_valid_sb H_follow.
    destruct sv eqn:E_sv.
    + simpl in H_valid_sv.
      simpl in H_valid_sb.
      simpl in H_follow.
      injection H_follow as H_smv H_maxidx' H_sb'.
      rewrite <- H_sb'.
      rewrite <- H_smv.
      rewrite <- H_maxidx'.
      simpl.
      split; try intuition.
      
    + simpl in H_valid_sv.
      simpl in H_valid_sb.
      simpl in H_follow.
      injection H_follow as H_smv H_maxidx' H_sb'.
      rewrite <- H_sb'.
      rewrite <- H_smv.
      rewrite <- H_maxidx'.
      simpl.
      split; try intuition.
    + discriminate.
  - intros sv instk_height maxidx ops smv maxidx' sb' H_valid_sv H_valid_sb H_follow.
    destruct sv eqn:E_sv.
    + simpl in H_valid_sv.
      simpl in H_valid_sb.
      simpl in H_follow.
      injection H_follow as H_smv H_maxidx' H_sb'.
      rewrite <- H_sb'.
      rewrite <- H_smv.
      rewrite <- H_maxidx'.
      simpl.
      split; try intuition.
    + simpl in H_valid_sv.
      simpl in H_valid_sb.
      simpl in H_follow.
      injection H_follow as H_smv H_maxidx' H_sb'.
      rewrite <- H_sb'.
      rewrite <- H_smv.
      rewrite <- H_maxidx'.
      simpl.
      split; try intuition.
    + destruct p as [idx value] eqn:E_p.
      simpl in H_valid_sv.
      simpl in H_valid_sb.
      simpl in H_follow.
      destruct H_valid_sb as [H_valid_sb_0 [H_valid_sb_1 H_valid_sb_2]].
      destruct (idx =? var) eqn:E_n_var.
      * destruct (is_fresh_var_smv value) as [idx'|] eqn:E_is_fresh_var_value.
        ** destruct value eqn:E_value; try discriminate.
           destruct val; try discriminate.
           simpl in E_is_fresh_var_value.
           injection E_is_fresh_var_value as E_is_fresh_var_value.
           simpl in H_valid_sb_1.
           rewrite E_is_fresh_var_value in H_valid_sb_1.

           assert(H_valid_sstack_value_FreshVar_idx': valid_sstack_value instk_height idx (FreshVar idx')). intuition.

           pose proof (IHsb'' (FreshVar idx') instk_height idx ops smv maxidx' sb' H_valid_sstack_value_FreshVar_idx' H_valid_sb_2 H_follow) as IHsb''_0.
           intuition.
           
        ** injection H_follow as  H_value H_idx H_sb''.
           rewrite <- H_idx.
           rewrite <- H_sb''.
           rewrite <- H_value.
           split.
           *** apply H_valid_sb_1.
           *** split.
               ***** apply H_valid_sb_2.
               ***** intro H_not_basic_value.
               destruct value; try intuition.
      * apply Nat.eqb_neq in E_n_var.
        assert(H_valid_sstack_value_FreshVar_idx': valid_sstack_value instk_height idx (FreshVar var)). simpl. intuition.
        pose proof (IHsb'' (FreshVar var) instk_height idx ops smv maxidx' sb' H_valid_sstack_value_FreshVar_idx' H_valid_sb_2 H_follow) as IHsb''_0.
        intuition.
Qed.

Lemma follow_in_smap_suc:
  forall sb sv instk_height maxidx ops,
    valid_sstack_value instk_height maxidx sv ->
    valid_bindings instk_height maxidx sb ops ->
    exists smv maxidx' sb',
      follow_in_smap sv maxidx sb = Some (FollowSmapVal smv maxidx' sb') /\
        is_fresh_var_smv smv = None.
Proof.
  induction sb as [| p sb' IHsb'].
  - intros sv instk_height maxidx ops H_valid_sv H_valid_bs.
    destruct sv eqn:E_sv.
    + simpl. exists (SymBasicVal (Val val)). exists maxidx. exists [].
      split; try reflexivity.
    + simpl. exists (SymBasicVal (InStackVar var)). exists maxidx. exists [].
      split; try reflexivity.
    + simpl in H_valid_bs.
      simpl in H_valid_sv.
      intuition.
  - intros sv instk_height maxidx ops H_valid_sv H_valid_bs.
    destruct sv eqn:E_sv.
    + simpl. exists (SymBasicVal (Val val)). exists maxidx. exists (p :: sb'). split; try reflexivity.
    + simpl. exists (SymBasicVal (InStackVar var)). exists maxidx. exists (p :: sb'). split; try reflexivity.
    + destruct p as [key value].      
      simpl in H_valid_bs.
      destruct H_valid_bs as [H_valid_bs_0 [H_valid_bs_1 H_valid_bs_2]].
      simpl in H_valid_sv.
      simpl.
      destruct (key =? var) eqn:E_key_var.
      * destruct (is_fresh_var_smv value) as [idx'|] eqn:E_is_fresh_var_smv_value.
        ** apply IHsb' with (instk_height:=instk_height)(ops:=ops).
           *** simpl.
               destruct value; try discriminate.
               simpl in E_is_fresh_var_smv_value.
               destruct val; try discriminate.
               injection E_is_fresh_var_smv_value as E_is_fresh_var_smv_value.
               simpl in H_valid_bs_1.
               intuition.
           *** apply H_valid_bs_2.
        ** exists value. exists key. exists sb'.
           split; try reflexivity.
           apply E_is_fresh_var_smv_value.
      * apply IHsb' with (instk_height:=instk_height)(ops:=ops).
        ** simpl.
           apply Nat.eqb_neq in E_key_var. intuition.
        ** apply H_valid_bs_2.
Qed.


(* Elements (using nth_error) of a valid sstack are also valid *)
Lemma valid_sstack_nth:
  forall instk_height maxidx sstk sv k,
    valid_sstack instk_height maxidx sstk ->
    nth_error sstk k = Some sv ->
      valid_sstack_value instk_height maxidx sv.
Proof.
  intros instk_height maxidx sstk sv.
  revert sstk.  
  induction sstk as [|a sstk' IHsstk'].
  - intros. destruct k; discriminate.
  - intros k H_valid_sstk H_nth.
    destruct k as [|k'].
    + simpl in H_nth.
      injection H_nth as H_nth.
      rewrite <- H_nth.
      simpl in H_valid_sstk.
      destruct H_valid_sstk as [H_valid_a _].
      apply H_valid_a.
    + simpl in H_nth.
      simpl in H_valid_sstk.
      destruct H_valid_sstk as [_ H_valid_sstk'].
      apply IHsstk' with (k:=k').
      apply H_valid_sstk'.
      apply H_nth.
Qed.

(* firstn of a valid sstack is valid *)
Lemma valid_sstack_firstn:
  forall instk_height maxidx sstk k,
    valid_sstack instk_height maxidx sstk ->
    valid_sstack instk_height maxidx (firstn k sstk).
Proof.
  intros instk_height maxidx.
  induction sstk as [|a sstk' IHsstk'].
  - intros; destruct k; reflexivity.
  - intros k H_valid_sstk.
    destruct k as [|k'].
    + reflexivity.
    + simpl in H_valid_sstk.
      destruct H_valid_sstk as [H_valid_a H_valid_sstk'].
      simpl.
      split.
      * apply H_valid_a.
      * apply IHsstk'.
        apply H_valid_sstk'.
Qed.

(* skipn of a valid sstack is valid *)
Lemma valid_sstack_skipn:
  forall instk_height maxidx sstk k,
    valid_sstack instk_height maxidx sstk ->
    valid_sstack instk_height maxidx (skipn k sstk).
Proof.
  intros instk_height maxidx.
  induction sstk as [|a sstk' IHsstk'].
  - intros; destruct k; reflexivity.
  - intros k H_valid_sstk.
    simpl in H_valid_sstk.
    destruct H_valid_sstk as [H_valid_a H_valid_sstk'].
    destruct k as [|k'].
    + simpl.
      split.
      * apply H_valid_a.
      * apply H_valid_sstk'.
    + simpl.
      apply IHsstk'.
      apply H_valid_sstk'.
Qed.

(* sv::sstk is valid when sv and sstk are valid *)
Lemma valid_sstack_cons:
  forall instk_height maxidx sstk sv,
    valid_sstack instk_height maxidx sstk ->
    valid_sstack_value instk_height maxidx sv ->
    valid_sstack instk_height maxidx (sv::sstk).
Proof.
  intros instk_height maxidx sskt sv H_valid_sstk H_valid_sv.
  simpl.
  split.
  - apply H_valid_sv.
  - apply H_valid_sstk.
Qed.

(* a memory update is valid when its ofsset and value are valid *)
Lemma valid_smemory_update_ov:
  forall instk_height maxidx soffset svalue,
    valid_sstack_value instk_height maxidx soffset ->
    valid_sstack_value instk_height maxidx svalue ->
    valid_smemory_update instk_height maxidx (U_MSTORE sstack_val soffset svalue) /\
      valid_smemory_update instk_height maxidx (U_MSTORE8 sstack_val soffset svalue).

Proof.
  intros instk_height maxidx soffset svalue H_valid_offset H_valid_value.
  unfold valid_smemory_update.
  intuition.
Qed.

(* a memory is still valid when extended with a valid update *)
Lemma valid_smemory_when_extended_with_valid_update:
  forall instk_height maxidx u smem,
    valid_smemory_update instk_height maxidx u ->
    valid_smemory instk_height maxidx smem ->
    valid_smemory instk_height maxidx (u::smem).
Proof.
  intros instk_height maxidx u smem H_valid_u H_valid_smem.
  simpl.
  intuition.
Qed.

(* a storage update is valid when its key and value are valid *)
Lemma valid_sstorage_update_kv:
  forall instk_height maxidx skey svalue,
    valid_sstack_value instk_height maxidx skey ->
    valid_sstack_value instk_height maxidx svalue ->
    valid_sstorage_update instk_height maxidx (U_SSTORE sstack_val skey svalue).

Proof.
  intros instk_height maxidx soffset svalue H_valid_skey H_valid_value.
  unfold valid_sstorage_update.
  intuition.
Qed.


(* a storage is still valid when extended with a valid update *)
Lemma valid_sstorage_when_extended_with_valid_update:
  forall instk_height maxidx u sstrg,
    valid_sstorage_update instk_height maxidx u ->
    valid_sstorage instk_height maxidx sstrg ->
    valid_sstorage instk_height maxidx (u::sstrg).
Proof.
  intros instk_height maxidx u sstrg H_valid_u H_valid_sstrg.
  simpl.
  intuition.
Qed.

(* FreshVar idx is valid when idx < maxidx *)
Lemma valid_sstack_val_freshvar:
  forall instk_height maxidx idx,
    idx < maxidx ->
    valid_sstack_value instk_height maxidx (FreshVar idx).
Proof.
  intros instk_height maxidx idx H_id_lt_maxid.
  simpl.
  apply H_id_lt_maxid.
Qed.




(* Lemmas about generation of valid smap values *)

Lemma metapush_valid_smv:
  forall instk_height maxidx ops cat v,
    valid_smap_value instk_height maxidx ops (SymMETAPUSH cat v).
Proof.
  intros.
  reflexivity.
Qed.

Lemma op_instr_valid_smv:
  forall instk_height maxidx ops label nargs args f H1 H2,
    valid_sstack instk_height maxidx args ->
    ops label = OpImp nargs f H1 H2 ->
    length args = nargs ->
    valid_smap_value instk_height maxidx ops (SymOp label args).
Proof.
  intros instk_height maxidx ops label nargs args f H1 H2 H_valid_args H_label H_len.
  simpl.
  unfold valid_stack_op_instr.
  rewrite H_label.
  split.
  - apply H_len.
  - apply H_valid_args.
Qed.
  

(* a memory update is valid when its key and value are valid *)
Lemma sha3_smv:
  forall instk_height maxidx ops smem soffset ssize,
    valid_smemory instk_height maxidx smem -> (* The memory is valid *)
    valid_sstack_value instk_height maxidx soffset ->
    valid_sstack_value instk_height maxidx ssize ->
    valid_smap_value instk_height maxidx ops (SymSHA3 soffset ssize smem).
Proof.
  intros instk_height maxidx ops smem soffset ssize H_valid_smem H_valid_soffset H_valid_ssize.
  unfold valid_smap_value.
  split.
  - apply H_valid_soffset.
  - split.
    + apply H_valid_ssize.
    + apply H_valid_smem.
Qed.

Lemma symsload_valid_smv:
  forall instk_height maxidx skey sstrg ops,
    valid_sstack_value instk_height maxidx skey ->
    valid_sstorage instk_height maxidx sstrg ->
    valid_smap_value instk_height maxidx ops (SymSLOAD skey sstrg).
Proof.
  intros instk_height maxidx skey sstrg ops H_valid_skey H_valid_sstrg.
  simpl.
  intuition.
Qed.

Lemma empty_sstrg_is_valid:
  forall instk_height maxidx,
    valid_sstorage instk_height maxidx empty_sstorage.
Proof.
  intros.
  simpl.
  apply I.
Qed.

Lemma valid_sstack_val_freshvar_Sn_n:
  forall instk_height idx,
    valid_sstack_value instk_height (S idx) (FreshVar idx).
Proof.
  intros instk_height idx.
  simpl.
  intuition.
Qed.

Lemma valid_sstack_val_lt_stklen:
  forall i instk_height maxidx,
    i < instk_height ->
    valid_sstack_value instk_height maxidx (InStackVar i).
Proof.
  intros i instk_height maxidz  H_i_lt_stkh.
  unfold valid_sstack_value.
  apply H_i_lt_stkh.
Qed.

End ValidSymbolicState.

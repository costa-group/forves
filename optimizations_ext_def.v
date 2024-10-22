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

Require Import FORVES.optimizations_def.
Import Optimizations_Def.

Require Import FORVES.symbolic_state_rename.
Import SymbolicStateRename.

Require Import List.
Import ListNotations.

(* For debugging with print_id *)
From ReductionEffect Require Import PrintingEffect.


Module Optimizations_Ext_Def.


(* Type of a function that optimizes a single smap_value and returns a new sbindings 
   to insert *)
Definition opt_ext_smap_value_type := 
  smap_value ->               (* val *)
  sstack_val_cmp_t ->         (* fcmp *) 
  sbindings ->                (* sb *)
  nat ->                      (* maxid *) 
  nat ->                      (* instk_height *)
  stack_op_instr_map ->       (* ops *)
  smap_value*sbindings*bool.  (* (val', nsb, flag) *)


(* Changes the binding (n,_) by (n,val) in sb *)
Fixpoint replace_binding (sb: sbindings) (n: nat) (val: smap_value) : sbindings :=
match sb with
| [] => []
| (n', val')::rs => if n =? n' 
                    then (n, val)::rs 
                    else (n', val')::(replace_binding rs n val)
end.

(* Changes the binding (n,_) by (n,val) in sb of the state *)
Definition replace_binding_sstate (sst: sstate) (n: nat) (val: smap_value) : sstate :=
    match sst with 
    | SymExState instk_height sstk smem sstg sexts (SymMap maxid bindings) =>
        SymExState instk_height sstk smem sstg sexts (SymMap maxid (replace_binding bindings n val))
    end.    


(* Applies smap value optimization to the first suitable entry in sbindings, extending
   the smap with possible new mappings. Returns:
   * New bindings to add
   * Optimized smap_value
   * Index of smap_value updated, which is also the position where you need
     to include the new bindings
   * Flag indicating whether the optimization was applied
*)
Fixpoint optimize_ext_first_sbindings (opt_ext_sbinding: opt_ext_smap_value_type) 
  (fcmp: sstack_val_cmp_t) (sb: sbindings) (instk_height: nat) 
    : sbindings*option smap_value*nat*bool :=
match sb with
| [] => ([], None, 0, false)
| (n,val)::rs => 
    match opt_ext_sbinding val fcmp rs n instk_height evm_stack_opm with
    | (val', nsb, true) => (nsb, Some val', n, true)
    | (_, _, false) => 
        optimize_ext_first_sbindings opt_ext_sbinding fcmp rs instk_height
     end
end.

Definition optimize_ext_first_sbindings_sstate' (opt_ext_sbinding: opt_ext_smap_value_type) 
  (fcmp: sstack_val_cmp_t) (sst: sstate)
    : sbindings*option smap_value*nat*bool :=
match sst with 
| SymExState instk_height sstk smem sstg sexts (SymMap maxid bindings) =>
    optimize_ext_first_sbindings opt_ext_sbinding fcmp bindings instk_height
end.

(*
Definition sstate_insert_bindings' (sst: sstate) (nbs: sbindings): sstate :=
  match sstate_insert_bindings sst nbs with
  | Some sst' => sst'
  | None => sst
end.
*)
  
Definition optimize_ext_first_sstate (opt_ext: opt_ext_smap_value_type) 
  (fcmp: sstack_val_cmp_t) (sst: sstate)
  : sstate*bool :=
match optimize_ext_first_sbindings_sstate' opt_ext fcmp sst with 
| (nsb, Some val', n, true) => 
    let shift := List.length nsb in
    match sstate_insert_bindings sst nsb with
    | Some sst1 => 
        (replace_binding_sstate sst1 (n+shift) val', true)
    | _ => (sst, false)
    end
| _ => (sst, false)
end.





Definition is_const (sv: sstack_val) (maxid: nat) (sb: sbindings) :=
match follow_in_smap sv maxid sb with 
| Some (FollowSmapVal (SymBasicVal (Val v)) idx' sb') => Some v
| _ => None
end.


(* ADD(ADD(Const, X), Y) = ADD(Const, ADD(X, Y)) *)
Definition optimize_add_const_add_sbinding : opt_ext_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp ADD [arg1;argy] => 
  match follow_in_smap arg1 maxid sb with
  | Some (FollowSmapVal (SymOp ADD [arg11; argx]) idx' sb') =>
    match is_const arg11 idx' sb' with
    | Some v11 => 
        (SymOp ADD [Val v11; FreshVar maxid], 
         [(maxid, SymOp ADD [argx; argy])],
         true)
    | _ => (val, [], false)
    end
  | _ => (val, [], false)
  end
| _ => (val, [], false)
end.



(* SHR(B, AND(X, A)) = AND(SHR(B, X), A >> B) with A, B constants 
https://github.com/ethereum/solidity/blob/abc46f309676637164076ca1a5b805cd90635bfa/libevmasm/RuleList.h#L558
*)
Definition optimize_shr_and_sbinding : opt_ext_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp SHR [b; arg] => 
  match is_const b maxid sb with
  | Some bval => 
    match follow_in_smap arg maxid sb with
    | Some (FollowSmapVal (SymOp AND [arg1; arg2]) idx' sb') =>
      match is_const arg1 idx' sb' with
      | Some aval => 
        let c := NToWord EVMWordSize (N.shiftr (wordToN aval) (wordToN bval)) in
        (SymOp AND [Val c; FreshVar maxid], 
         [(maxid, SymOp SHR [Val bval; arg2])],
         true)
      | _ => 
        match is_const arg2 idx' sb' with
        | Some aval => 
          let c := NToWord EVMWordSize (N.shiftr (wordToN aval) (wordToN bval)) in
          (SymOp AND [Val c; FreshVar maxid], 
           [(maxid, SymOp SHR [Val bval; arg1])],
           true)
        | None => (val, [], false)
        end 
      end
    | _ => (val, [], false)
    end
  | _ => (val, [], false)
  end
| _ => (val, [], false)
end.

Definition dummy : sstack_val_cmp_t :=
fun (sv1: sstack_val) =>
fun (sv2: sstack_val) =>
fun (n1: nat) =>
fun (sb1: sbindings) =>
fun (n2: nat) =>
fun (sb2: sbindings) =>
fun (n3 : nat) =>
fun (ops: stack_op_instr_map) =>
false.

(*
Compute 
  let sb := [(5, SymBasicVal (FreshVar 3)); (4, SymOp ADD [FreshVar 2; InStackVar 0]); 
             (3, SymBasicVal (InStackVar 5)); (2, SymOp ADD [Val WZero; InStackVar 1]); 
             (1, SymBasicVal (InStackVar 5)); (0, SymBasicVal (InStackVar 5))] in
  optimize_ext_first_sbindings optimize_add_const_add_sbinding dummy sb 6.             

Compute 
let sb := [(5, SymBasicVal (FreshVar 3)); (4, SymOp ADD [FreshVar 2; InStackVar 0]); 
           (3, SymBasicVal (InStackVar 5)); (2, SymOp ADD [Val WZero; InStackVar 1]); 
           (1, SymBasicVal (InStackVar 5)); (0, SymBasicVal (InStackVar 5))] in
let sst := SymExState 0 [] [] [] SymExts (SymMap 6 sb) in
optimize_ext_first_sstate optimize_add_const_add_sbinding dummy sst.
*)


Inductive opt_ext_entry :=
| OpExtEntry (opt: opt_ext_smap_value_type) 
             (*(H_snd: opt_sbinding_snd opt).*).

Definition opt_ext_pipeline := list opt_ext_entry.

Definition test_opt_ext_pipeline : opt_ext_pipeline :=
[OpExtEntry optimize_add_const_add_sbinding
;OpExtEntry optimize_shr_and_sbinding].

(*[].*)



(* Applies the optimization once in the first possible place inside
   the bindings __of the sstate__
*)
Definition optimize_first_opt_ext_entry_sstate (opt_e: opt_ext_entry) 
  (fcmp: sstack_val_cmp_t) (sst: sstate) : sstate*bool :=
match opt_e with
| OpExtEntry opt =>
  optimize_ext_first_sstate opt fcmp sst
end.

(* Applies the optimization at most n times in a sstate, stops as soon as it
   does not change the sstate *)
Fixpoint apply_opt_ext_n_times (opt_e: opt_ext_entry) (fcmp: sstack_val_cmp_t) 
  (n: nat) (sst: sstate) : sstate*bool :=
match n with
| 0 => (sst, false) 
| S n' => 
    match optimize_first_opt_ext_entry_sstate opt_e fcmp sst with
    | (sst', true) => 
        match apply_opt_ext_n_times opt_e fcmp n' sst' with
        | (sst'', b) => (sst'', true) 
        end
    | (sst', false) => (sst', false)
    end
end.

(* Applies the pipeline in order in a sstate, applying n times each 
   optimization and continuing with the next one *)
Fixpoint apply_opt_ext_n_times_pipeline_once (pipe: opt_ext_pipeline) 
  (fcmp: sstack_val_cmp_t) (n: nat) (sst: sstate) : sstate*bool :=
match pipe with
| [] => (sst, false) 
| opt_e::rp => 
    match apply_opt_ext_n_times opt_e fcmp n sst with
    | (sst', flag1) => 
        match apply_opt_ext_n_times_pipeline_once rp fcmp n sst' with
        | (sst'', flag2) => (sst'', orb flag1 flag2)
        end
    end
end.


(* Applies (apply_opt_n_times_pipeline n) at most k times in a sstate, stops 
   as soon as it does not change the sstate *)
Fixpoint apply_opt_ext_n_times_pipeline_k (pipe: opt_ext_pipeline)
  (fcmp: sstack_val_cmp_t) 
  (n k: nat) (sst: sstate) : sstate*bool :=
match k with
| 0 => (sst, false) 
| S k' => 
    match apply_opt_ext_n_times_pipeline_once pipe fcmp n sst with
    | (sst', true) => 
        match apply_opt_ext_n_times_pipeline_k pipe fcmp n k' sst'  with
        | (sst'', b) => (sst'', true) 
        end
    | (sst', false) => (sst', false)
    end
end.


(* Applies the pipeline pipe1 (standard optimizations) n times each stage, followed by pipe2 
(extended optimizations) n times each stage. Repeats this process at most k times.  *)
Fixpoint apply_opt_combined_n_times_pipeline_k (pipe1: opt_pipeline) (pipe2: opt_ext_pipeline)
   (fcmp: sstack_val_cmp_t) 
   (n k: nat) (sst: sstate) : sstate*bool :=
 match k with
 | 0 => (sst, false) 
 | S k' => 
     let (sst1, flag1) := apply_opt_n_times_pipeline_once pipe1 fcmp n sst in
     let (sst2, flag2) := apply_opt_ext_n_times_pipeline_once pipe2 fcmp n sst1 in
     if orb flag1 flag2 
     (* Some optimization has been applied, continue one more iteration *)
     then match apply_opt_combined_n_times_pipeline_k pipe1 pipe2 fcmp n k' sst2 with
          | (sst', b) => (sst', true) 
          end
     else (sst, false)
 end.


End Optimizations_Ext_Def.
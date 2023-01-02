
Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import Coq.NArith.NArith.
Require Import List.
Import ListNotations.

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

Require Import FORVES.flat_symbolic_state.
Import FlatSymbolicState.

Require Import FORVES.flat_symbolic_state_eval.
Import FlatSymbolicStateEval.


Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import FORVES.eval_common.
Import EvalCommon.

Module FlatSymbolicStateCmp.

  
Definition fold_right_two_lists {A B: Type} (f : A -> B -> bool) :=
  fix fold_right_fix (v : list A) : list B -> bool :=
    match v with
    | [] => fun w =>  match w with
                      | [] => true
                      | _ => false
                      end
    |vh::vt =>
       fun w => match w with
                | [] => false
                | wh::wt =>
                    if (f vh wh) then
                      (fold_right_fix vt wt)
                    else
                      false
                end
    end.


Definition mload_cmp_type := nat -> sexpr -> flat_smemory -> flat_smemory -> nat -> stack_op_instr_map -> bool.

Definition sload_cmp_type := nat -> sexpr -> flat_sstorage -> flat_sstorage -> nat -> stack_op_instr_map -> bool.
Definition sha3_cmp_type  := nat -> sexpr -> sexpr -> flat_smemory -> flat_smemory -> nat -> stack_op_instr_map -> bool.
Definition smemory_cmp_type := nat -> flat_smemory -> flat_smemory -> nat -> stack_op_instr_map -> bool.
Definition sstorage_cmp_type := nat -> flat_sstorage -> flat_sstorage -> nat -> stack_op_instr_map -> bool.

Definition sexpr_eval_type := nat -> flat_sstorage -> flat_sstorage -> nat -> stack_op_instr_map -> bool.

Definition mload_cmp_snd (mload_cmp: mload_cmp_type) :=
  forall d flat_offset flat_memory1 flat_memory2 instk_height ops,
    mload_cmp d flat_offset flat_memory1 flat_memory2 instk_height ops = true ->
    forall stk mem strg ctx offset,
      length stk = instk_height ->
      eval_sexpr flat_offset stk mem strg ctx ops = Some offset ->
      exists mem1 mem2 mem_updates1 mem_updates2,
               map_option (instantiate_memory_update (fun sv => eval_sexpr sv stk mem strg ctx ops)) flat_memory1 = Some mem_updates1 /\
               map_option (instantiate_memory_update (fun sv => eval_sexpr sv stk mem strg ctx ops)) flat_memory2 = Some mem_updates2 /\
               update_memory mem mem_updates1 = mem1 /\
               update_memory mem mem_updates2 = mem2 /\
               mload mem1 offset = mload mem2 offset.

Definition sload_cmp_snd (sload_cmp : sload_cmp_type) :=
  forall d flat_key flat_storage1 flat_storage2 instk_height ops,
    sload_cmp d flat_key flat_storage1 flat_storage2 instk_height ops = true ->
    forall stk mem strg ctx key,
      length stk = instk_height ->
      eval_sexpr flat_key stk mem strg ctx ops = Some key ->
      exists strg1 strg2 strg_updates1 strg_updates2,
               map_option (instantiate_storage_update (fun sv => eval_sexpr sv stk mem strg ctx ops)) flat_storage1 = Some strg_updates1 /\
               map_option (instantiate_storage_update (fun sv => eval_sexpr sv stk mem strg ctx ops)) flat_storage2 = Some strg_updates2 /\
               update_storage strg strg_updates1 = strg1 /\
               update_storage strg strg_updates2 = strg2 /\
               sload strg1 key = sload strg2 key.

Definition sha3_cmp_snd (sha3_cmp: sha3_cmp_type) :=
  forall d flat_offset flat_size flat_memory1 flat_memory2 instk_height ops,
    sha3_cmp d flat_offset flat_size flat_memory1 flat_memory2 instk_height ops = true ->
    forall stk mem strg ctx offset size,
      length stk = instk_height ->
      eval_sexpr flat_offset stk mem strg ctx ops = Some offset ->
        eval_sexpr flat_size stk mem strg ctx ops = Some size ->
      exists mem1 mem2 mem_updates1 mem_updates2,
               map_option (instantiate_memory_update (fun sv => eval_sexpr sv stk mem strg ctx ops)) flat_memory1 = Some mem_updates1 /\
               map_option (instantiate_memory_update (fun sv => eval_sexpr sv stk mem strg ctx ops)) flat_memory2 = Some mem_updates2 /\
               update_memory mem mem_updates1 = mem1 /\
               update_memory mem mem_updates2 = mem2 /\
               (get_keccak256_ctx ctx) (wordToNat size) (mload' mem1 offset (wordToNat size)) =
               (get_keccak256_ctx ctx) (wordToNat size) (mload' mem2 offset (wordToNat size)).

Definition smemory_cmp_snd (smem_cmp : smemory_cmp_type) :=
  forall d flat_memory1 flat_memory2 instk_height ops,
    smem_cmp d flat_memory1 flat_memory2 instk_height ops = true ->
    forall stk mem strg ctx f_eval_mem_update,
      length stk = instk_height ->
      f_eval_mem_update = instantiate_memory_update (fun sv => eval_sexpr sv stk mem strg ctx ops)  ->
      exists mem1 mem2 mem_updates1 mem_updates2,
          map_option f_eval_mem_update flat_memory1 = Some mem_updates1 /\
          map_option f_eval_mem_update flat_memory2 = Some mem_updates2 /\
          update_memory mem mem_updates1 = mem1 /\
          update_memory mem mem_updates2 = mem2 /\
          forall w, mem1 w = mem2 w.

Definition sstorage_cmp_snd (sstrg_cmp : sstorage_cmp_type) :=
  forall d flat_storage1 flat_storage2 instk_height ops,
    sstrg_cmp d flat_storage1 flat_storage2 instk_height ops = true ->
    forall stk mem strg ctx f_eval_strg_update,
      length stk = instk_height ->
      f_eval_strg_update = instantiate_storage_update (fun sv => eval_sexpr sv stk mem strg ctx ops)  ->
      exists strg1 strg2 strg_updates1 strg_updates2,
          map_option f_eval_strg_update flat_storage1 = Some strg_updates1 /\
          map_option f_eval_strg_update flat_storage2 = Some strg_updates2 /\
          update_storage strg strg_updates1 = strg1 /\
          update_storage strg strg_updates2 = strg2 /\
          forall w, strg1 w = strg2 w.



Fixpoint sexp_cmp (d :nat) (se1 se2: sexpr) (instk_height: nat) (ops: stack_op_instr_map) (mload_cmp: mload_cmp_type) (sload_cmp: sload_cmp_type) (sha3_cmp: sha3_cmp_type): bool :=
  match d with
  | 0 => false
  | S d' => 
      match se1, se2 with
      | SExpr_Val val1, SExpr_Val val2 => weqb val1 val2
      | SExpr_InStkVar var1, SExpr_InStkVar var2 => (andb (var1 =? var2) (andb (var1 <? instk_height) (var2 <? instk_height)))
      | SExpr_Op label1 args1, SExpr_Op label2 args2 =>
          if ( label1 =?i label2 ) then
            match ops label1 with
            | OpImp nargs f H_comm H_ctd_ind =>
                if (andb (length args1 =? nargs) (length args2 =? nargs) ) then
                  match (fold_right_two_lists (fun e1 e2 => sexp_cmp d' e1 e2 instk_height ops mload_cmp sload_cmp sha3_cmp) args1 args2) with
                  | true => true
                  | false => match H_comm with
                             | None => false
                             | Some Comm_Proof =>
                                 match args1, args2 with
                                 | [a1;a2], [b1;b2] => andb (sexp_cmp d' a1 b2 instk_height ops mload_cmp sload_cmp sha3_cmp) (sexp_cmp d' a2 b1 instk_height ops mload_cmp sload_cmp sha3_cmp)
                                 | _, _ => false
                                 end
                             end
                  end
            else
              false
            end
          else
            false
      | SExpr_PUSHTAG v1, SExpr_PUSHTAG v2 => (v1 =? v2)%N
      | SExpr_MLOAD offset1 smem1, SExpr_MLOAD offset2 smem2 =>
          if (sexp_cmp d' offset1 offset2 instk_height ops mload_cmp sload_cmp sha3_cmp) then
            mload_cmp d' offset1 smem1  smem2 instk_height ops
          else
            false
      | SExpr_SLOAD key1 sstrg1, SExpr_SLOAD key2 sstrg2 =>
          if (sexp_cmp d' key1 key2 instk_height ops mload_cmp sload_cmp sha3_cmp) then
            sload_cmp d' key1 sstrg1 sstrg2 instk_height ops
          else
            false
      | SExpr_SHA3 offset1 size1 smem1, SExpr_SHA3 offset2 size2 smem2 =>
          if (sexp_cmp d' offset1 offset2 instk_height ops mload_cmp sload_cmp sha3_cmp) then
            if (sexp_cmp d' size1 size2 instk_height ops mload_cmp sload_cmp sha3_cmp) then
              sha3_cmp d' offset1 size1 smem1 smem2 instk_height ops
            else
              false
          else
            false
      | _, _ => false
      end
  end.

Definition flat_sstack_cmp (d : nat) (fsst1 fsst2 : flat_sstate) (ops: stack_op_instr_map) (mload_cmp: mload_cmp_type) (sload_cmp: sload_cmp_type) (sha3_cmp: sha3_cmp_type) : bool :=
  let flat_sstk1 := get_stack_fsst fsst1 in
  let flat_sstk2 := get_stack_fsst fsst2 in
  let instk_height1 := get_instk_height_fsst fsst1 in
  let instk_height2 := get_instk_height_fsst fsst2 in
  if instk_height1 =? instk_height2 then
    fold_right_two_lists (fun a b => sexp_cmp d a b instk_height1 ops mload_cmp sload_cmp sha3_cmp) flat_sstk1 flat_sstk2
  else
    false.

Definition flat_smemory_cmp  (d : nat) (flat_smem1 flat_smem2 : flat_smemory) (instk_height1 instk_height2: nat) (ops: stack_op_instr_map) (smem_cmp: smemory_cmp_type) : bool :=
  if instk_height1 =? instk_height2 then
    smem_cmp d flat_smem1 flat_smem2 instk_height1 ops
  else
    false.

Definition flat_sstorage_cmp  (d : nat) (flat_sstrg1 flat_sstrg2 : flat_sstorage) (instk_height1 instk_height2: nat) (ops: stack_op_instr_map) (sstrg_cmp: sstorage_cmp_type) : bool :=
  if instk_height1 =? instk_height2 then
    sstrg_cmp d flat_sstrg1 flat_sstrg2 instk_height1 ops
  else
    false.

Definition flat_sstate_cmp (fsst1 fsst2 : flat_sstate) (ops: stack_op_instr_map) (mload_cmp: mload_cmp_type) (sload_cmp: sload_cmp_type) (sha3_cmp: sha3_cmp_type) (smem_cmp: smemory_cmp_type) (sstrg_cmp: sstorage_cmp_type) : bool :=
  let instk_height1 := get_instk_height_fsst fsst1 in
  let instk_height2 := get_instk_height_fsst fsst2 in
  let d := max (get_max_depth_fsst fsst1) (get_max_depth_fsst fsst2) in
  if flat_sstack_cmp d fsst1 fsst2 ops mload_cmp sload_cmp sha3_cmp then
    if flat_smemory_cmp d (get_memory_fsst fsst1) (get_memory_fsst fsst1) instk_height1 instk_height2 ops smem_cmp then
      if flat_sstorage_cmp d (get_storage_fsst fsst1) (get_storage_fsst fsst1) instk_height1 instk_height2 ops sstrg_cmp then
        true
      else
        false
    else
      false
  else
    false.

End FlatSymbolicStateCmp.

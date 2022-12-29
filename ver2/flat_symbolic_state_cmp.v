
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


Definition mload_cmp_type := sexpr -> flat_smemory -> sexpr -> flat_smemory  -> stack_op_instr_map -> bool.
Definition sload_cmp_type := sexpr -> flat_sstorage -> sexpr -> flat_sstorage -> stack_op_instr_map -> bool.
Definition sha3_cmp_type  := sexpr -> sexpr -> flat_smemory -> sexpr -> sexpr -> flat_smemory -> stack_op_instr_map -> bool.
Definition smemory_cmp_type := flat_smemory -> flat_smemory -> stack_op_instr_map -> bool.
Definition sstorage_cmp_type := flat_sstorage -> flat_sstorage -> stack_op_instr_map -> bool.

Fixpoint sexp_cmp (se1 se2: sexpr) (ops: stack_op_instr_map) (mload_cmp: mload_cmp_type) (sload_cmp: sload_cmp_type) (sha3_cmp: sha3_cmp_type): bool :=
  match se1, se2 with
  | SExpr_Val val1, SExpr_Val val2 => weqb val1 val2
  | SExpr_InStkVar var1, SExpr_InStkVar var2 => var1 =? var2
  | SExpr_Op label1 args1, SExpr_Op label2 args2 =>
      if ( label1 =?i label2 ) then
        match ops label1 with
        | OpImp nargs f H_comm H_ctd_ind =>
            if (andb (length args1 =? nargs) (length args2 =? nargs) ) then
              match (fold_right_two_lists (fun e1 e2 => sexp_cmp e1 e2 ops mload_cmp sload_cmp sha3_cmp) args1 args2) with
              | true => true
              | false => match H_comm with
                         | None => false
                         | Some Comm_Proof =>
                             match args1, args2 with
                             | [a1;a2], [b1;b2] => andb (sexp_cmp a1 b2 ops mload_cmp sload_cmp sha3_cmp) (sexp_cmp a2 b1 ops mload_cmp sload_cmp sha3_cmp)
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
  | SExpr_MLOAD offset1 smem1, SExpr_MLOAD offset2 smem2 => mload_cmp offset1 smem1 offset2 smem2 ops
  | SExpr_SLOAD key1 sstrg1, SExpr_SLOAD key2 sstrg2 => sload_cmp key1 sstrg1 key2 sstrg2 ops
  | SExpr_SHA3 offset1 size1 smem1, SExpr_SHA3 offset2 size2 smem2 => sha3_cmp offset1 size1 smem1 offset2 size2 smem2 ops
  | _, _ => false
  end.

Definition flat_sstack_cmp (flat_sstk1 flat_sstk2 : flat_sstack) (ops: stack_op_instr_map) (mload_cmp: mload_cmp_type) (sload_cmp: sload_cmp_type) (sha3_cmp: sha3_cmp_type) : bool :=
  fold_right_two_lists (fun a b => sexp_cmp a b ops mload_cmp sload_cmp sha3_cmp) flat_sstk1 flat_sstk2.

Definition flat_smemory_cmp (flat_smem1 flat_smem2 : flat_smemory) (ops: stack_op_instr_map) (smem_cmp: smemory_cmp_type) : bool :=
  smem_cmp flat_smem1 flat_smem2 ops.

Definition flat_sstorage_cmp (flat_sstrg1 flat_sstrg2 : flat_sstorage) (ops: stack_op_instr_map) (sstrg_cmp: sstorage_cmp_type) : bool :=
  sstrg_cmp flat_sstrg1 flat_sstrg2 ops.

Definition flat_sstate_cmp (fsst1 fsst2 : flat_sstate) (ops: stack_op_instr_map) (mload_cmp: mload_cmp_type) (sload_cmp: sload_cmp_type) (sha3_cmp: sha3_cmp_type) (smem_cmp: smemory_cmp_type) (sstrg_cmp: sstorage_cmp_type) : bool :=
  if get_instk_height_fsst fsst1 =? get_instk_height_fsst fsst2 then
    if flat_sstack_cmp (get_stack_fsst fsst1) (get_stack_fsst fsst1) ops mload_cmp sload_cmp sha3_cmp then
      if flat_smemory_cmp (get_memory_fsst fsst1) (get_memory_fsst fsst1) ops smem_cmp then
        if flat_sstorage_cmp (get_storage_fsst fsst1) (get_storage_fsst fsst1) ops sstrg_cmp then
          true
        else
          false
      else
        false
    else
      false
  else
    false.

    
  
End FlatSymbolicStateCmp.

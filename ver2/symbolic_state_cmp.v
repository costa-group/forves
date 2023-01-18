
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

Require Import FORVES.symbolic_state_eval.
Import SymbolicStateEval.


Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import FORVES.eval_common.
Import EvalCommon.

Module FlatSymbolicStateCmp.


Fixpoint smap_val_cmp (smem_cmp: smemory_cmp_type) (sstrg_cmp: sstorage_cmp_type) (sha3_cmp: sha3_cmp_type) (d :nat) (smv1 smv2: smap_value) (instk_height: nat) (sb1 sb2 : sbindings) (ops: stack_op_instr_map) : bool :=
  match d with
  | 0 => false
  | S d' =>
      match smv1, smv2 with
      | SymBasicVal (Val v1), SymBasicVal (Val v2) => weqb v1 v2
      | SymBasicVal (InStackVar n1), SymBasicVal (InStackVar n2) => (andb (n1 =? n2) (andb (n1 <? instk_height) (n2 <? instk_height)))
      | SymBasicVal (FreshVar n), _ => 
           match sb1 with
           | [] => false
           | (key,smv)::sb1' =>
               if key =? n then
                 smap_val_cmp smem_cmp sstrg_cmp sha3_cmp d' smv smv2 instk_height sb1' sb2 ops
               else
                 smap_val_cmp smem_cmp sstrg_cmp sha3_cmp d' smv1 smv2 instk_height sb1' sb2 ops
           end
      | _, SymBasicVal (FreshVar n) => 
           match sb2 with
           | [] => false
           | (key,smv)::sb2' =>
               if key =? n then
                 smap_val_cmp smem_cmp sstrg_cmp sha3_cmp d' smv1 smv instk_height sb1 sb2' ops
               else
                 smap_val_cmp smem_cmp sstrg_cmp sha3_cmp d' smv1 smv2 instk_height sb1 sb2' ops
           end
      | SymPUSHTAG v1, SymPUSHTAG v2 => (v1 =? v2)%N
      | SymOp label1 args1, SymOp label2 args2 =>
          if ( label1 =?i label2 ) then
            match ops label1 with
            | OpImp nargs f H_comm H_ctx_ind =>
                if (andb (length args1 =? nargs) (length args2 =? nargs) ) then
                  match (fold_right_two_lists (fun e1 e2 => smap_val_cmp smem_cmp sstrg_cmp sha3_cmp d' (SymBasicVal e1) (SymBasicVal e2) instk_height sb1 sb2 ops) args1 args2) with
                  | true => true
                  | false => match H_comm with
                             | None => false
                             | Some Comm_Proof =>
                                 match args1, args2 with
                                 | [a1;a2], [b1;b2] => andb (smap_val_cmp smem_cmp sstrg_cmp sha3_cmp d' (SymBasicVal a1) (SymBasicVal b2) instk_height sb1 sb2 ops)
                                                            (smap_val_cmp smem_cmp sstrg_cmp sha3_cmp d' (SymBasicVal a2) (SymBasicVal b1) instk_height sb1 sb2 ops) 
                                 | _, _ => false
                                 end
                             end
                  end
            else
              false
            end
          else
            false
      | SymMLOAD offset1 smem1, SymMLOAD offset2 smem2 =>
          if (smap_val_cmp smem_cmp sstrg_cmp sha3_cmp d' (SymBasicVal offset1) (SymBasicVal offset1) instk_height sb1 sb2 ops) then
            smem_cmp (fun a b => false) smem1 smem2
          else
            false               
      | SymSLOAD key1 sstrg1, SymSLOAD key2 sstrg2 => 
          if (smap_val_cmp smem_cmp sstrg_cmp sha3_cmp d' (SymBasicVal key1) (SymBasicVal key2) instk_height sb1 sb2 ops) then
            sstrg_cmp (fun a b => false) sstrg1 sstrg2
          else
            false
      | SymSHA3 offset1 size1 smem1, SymSHA3 offset2 size2 smem2 =>
          sha3_cmp (fun a b => false) offset1 size1 smem1 offset2 size2 smem2
      | _, _ => false
      end
  end.


End FlatSymbolicStateCmp.

  

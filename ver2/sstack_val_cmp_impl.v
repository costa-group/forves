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


Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.symbolic_state_cmp.
Import SymbolicStateCmp.

Require Import FORVES.eval_common.
Import EvalCommon.

Module SStackValCmpImp.


Fixpoint comapre_sstack_val (smemory_cmp: smemory_cmp_ext_t) (sstorage_cmp: sstorage_cmp_ext_t) (sha3_cmp: sha3_cmp_ext_t) (d: nat) (sv1 sv2: sstack_val) (maxidx1: nat) (sb1: sbindings) (maxidx2: nat) (sb2: sbindings) (instk_height: nat) (ops: stack_op_instr_map) : bool :=
  match d with
  | 0 => false
  | S d' =>
      let comapre_sstack_val_rec :=
        fun (sv1 sv2: sstack_val) (maxidx1: nat) (sb1: sbindings) (maxidx2: nat) (sb2: sbindings) (instk_height: nat) (ops: stack_op_instr_map) =>
          comapre_sstack_val smemory_cmp sstorage_cmp sha3_cmp d' sv1 sv2 maxidx1 sb1 maxidx2 sb2 instk_height ops in
      match follow_in_smap sv1 maxidx1 sb1, follow_in_smap sv2 maxidx2 sb2 with
      | Some (FollowSmapVal smv1 maxidx1' sb1'), Some (FollowSmapVal smv2 maxidx2' sb2') =>
          match smv1, smv2 with
          | SymBasicVal (Val w1), SymBasicVal (Val w2) => weqb w1 w2
          | SymBasicVal (InStackVar n1), SymBasicVal (InStackVar n2) => (andb (n1 =? n2) (andb (n1 <? instk_height) (n2 <? instk_height)))
          | SymPUSHTAG v1, SymPUSHTAG v2 => (v1 =? v2)%N
          | SymOp label1 args1, SymOp label2 args2 =>
              if label1 =?i label2 then
                match ops label1 with
                  OpImp _ _ H_Comm _ =>
                    match (fold_right_two_lists (fun e1 e2 => comapre_sstack_val_rec e1 e2 maxidx1' sb1' maxidx2' sb2' instk_height ops) args1 args2) with
                    | true => true
                    | false =>
                        match H_Comm with
                        | Some comm_proof =>
                            match args1, args2 with
                            | [a1;a2],[b1;b2] =>
                                if comapre_sstack_val_rec a1 b2 maxidx1' sb1' maxidx2' sb2' instk_height ops
                                then comapre_sstack_val_rec a2 b1 maxidx1' sb1' maxidx2' sb2' instk_height ops
                                else false
                            | _, _ => false
                            end
                        | None => false
                        end
                    end
                end
              else false
          | SymMLOAD soffset1 smem1, SymMLOAD soffset2 smem2 =>
              if comapre_sstack_val smemory_cmp sstorage_cmp sha3_cmp d' soffset1 soffset2 maxidx1' sb1' maxidx2' sb2' instk_height ops
              then smemory_cmp comapre_sstack_val_rec smem1 smem2 maxidx1' sb1' maxidx2' sb2' instk_height ops
              else false
          | SymSLOAD skey1 sstrg1, SymSLOAD skey2 sstrg2 => 
              if comapre_sstack_val smemory_cmp sstorage_cmp sha3_cmp d' skey1 skey2 maxidx1' sb1' maxidx2' sb2' instk_height ops
              then sstorage_cmp comapre_sstack_val_rec sstrg1 sstrg2 maxidx1' sb1' maxidx2' sb2' instk_height ops
              else false
          | SymSHA3 soffset1 ssize1 smem1, SymSHA3 soffset2 ssize2 smem2 =>
              (* the nested if is to avoid using band *)
              if (if comapre_sstack_val_rec soffset1 soffset2 maxidx1' sb1' maxidx2' sb2' instk_height ops then
                    if comapre_sstack_val_rec ssize1 ssize2 maxidx1' sb1' maxidx2' sb2' instk_height ops then
                      if smemory_cmp comapre_sstack_val_rec smem1 smem2 maxidx1' sb1' maxidx2' sb2' instk_height ops then
                        true
                      else
                        false
                    else
                      false
                  else
                    false)
              then true
              else sha3_cmp comapre_sstack_val_rec soffset1 ssize1 smem1 soffset2 ssize2 smem2 maxidx1' sb1' maxidx2' sb2' instk_height ops

          | _, _ => false
          end
      | _, _ => false
      end
  end.


End SStackValCmpImp.

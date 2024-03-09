Require Import bbv.Word.
Require Import Nat. 
Require Import Coq.NArith.NArith.
Require Import Arith.   

Require Import FORVES.constants.
Import Constants.

Require Import FORVES.program.
Import Program.

Require Import FORVES.stack_operation_instructions.
Import StackOpInstrs.

Require Import FORVES.symbolic_state.
Import SymbolicState.

Require Import List.
Import ListNotations.

Module SymbolicStateDec.


Notation "'Decide_left'" := (left _ _).
Notation "'Decide_right'" := (right _ _).
Notation "'Decide_with' x" :=
  (if x then Decide_left else Decide_right) (at level 42).



Definition sstack_val_eq_dec : forall (sv1 sv2 : sstack_val), { sv1 = sv2 } + { sv1 <> sv2 }.
Proof.
  refine (fun (sv1 sv2 : sstack_val) =>
            match sv1, sv2 with
            | Val w1, Val w2 => Decide_with (weq w1 w2)
            | InStackVar n1, InStackVar n2 => Decide_with (Nat.eq_dec n1 n2)
            | FreshVar n1, FreshVar n2 => Decide_with (Nat.eq_dec n1 n2)
            | _, _ => Decide_right
            end); try congruence.
Qed.

Definition sstack_eq_dec : forall (sstk1 sstk2 : sstack), { sstk1 = sstk2 } + { sstk1 <> sstk2 }.
Proof.
  refine (fix f (sstk1 sstk2 : sstack)  :=
            match sstk1, sstk2 with
            | [], [] => Decide_left
            | sv1::sstk1', sv2::sstk2' =>
                if (sstack_val_eq_dec sv1 sv2)
                then Decide_with (f sstk1' sstk2')
                else Decide_right
            | _, _ => Decide_right
            end); try congruence.
Qed.

Definition smemory_update_eq_dec : forall (u1 u2 : memory_update sstack_val), { u1 = u2 } + { u1 <> u2 }.
Proof.
  refine (fun (u1 u2 : memory_update sstack_val) =>
            match u1, u2 with
            | U_MSTORE _ soffset1 svalue1, U_MSTORE _ soffset2 svalue2 =>
                if (sstack_val_eq_dec soffset1 soffset2)
                then Decide_with (sstack_val_eq_dec svalue1 svalue2)
                else Decide_right
            | U_MSTORE8 _ soffset1 svalue1, U_MSTORE8 _ soffset2 svalue2 =>
                if (sstack_val_eq_dec soffset1 soffset2)
                then Decide_with (sstack_val_eq_dec svalue1 svalue2)
                else Decide_right
            | _, _ => Decide_right
            end); try congruence.
Qed.

Definition smemory_eq_dec : forall (smem1 smem2 : smemory), { smem1 = smem2 } + { smem1 <> smem2 }.
Proof.
  refine (fix f (smem1 smem2 : smemory) :=
            match smem1, smem2 with
            | [], [] => Decide_left
            | u1::smem1', u2::smem2' =>
                if (smemory_update_eq_dec u1 u2)
                then Decide_with (f smem1' smem2')
                else Decide_right
            | _, _ => Decide_right
            end); try congruence.
Qed.



Definition sstorage_update_eq_dec : forall (u1 u2 : storage_update sstack_val), { u1 = u2 } + { u1 <> u2 }.
Proof.
  refine (fun (u1 u2 : storage_update sstack_val) =>
            match u1, u2 with
            | U_SSTORE _ skey1 svalue1, U_SSTORE _ skey2 svalue2 =>
                if (sstack_val_eq_dec skey1 skey2)
                then Decide_with (sstack_val_eq_dec svalue1 svalue2)
                else Decide_right
            end); try congruence.
Qed.


Definition sstorage_eq_dec : forall (smem1 smem2 : sstorage), { smem1 = smem2 } + { smem1 <> smem2 }.
Proof.
  refine (fix f (smem1 smem2 : sstorage) :=
            match smem1, smem2 with
            | [], [] => Decide_left
            | u1::smem1', u2::smem2' =>
                if (sstorage_update_eq_dec u1 u2)
                then Decide_with (f smem1' smem2')
                else Decide_right
            | _, _ => Decide_right
            end); try congruence.
Qed.


Definition scontext_eq_dec : forall (ctx1 ctx2 : scontext), { ctx1 = ctx2 } + { ctx1 <> ctx2 }.
Proof.
decide equality.
Defined.


Definition smap_value_eq_dec : forall (smv1 smv2 : smap_value), { smv1 = smv2 } + { smv1 <> smv2 }.
Proof.
  refine (fun (smv1 smv2 : smap_value) =>
            match smv1, smv2 with
            | SymBasicVal val1, SymBasicVal val2 => Decide_with (sstack_val_eq_dec val1 val2)
            | SymMETAPUSH cat1 val1, SymMETAPUSH cat2 val2 =>
                if (N.eq_dec cat1 cat2)
                then Decide_with (N.eq_dec val1 val2)
                else Decide_right
            | SymOp label1 args1, SymOp label2 args2 =>
                if (stack_op_eq_dec label1 label2)
                then Decide_with (sstack_eq_dec args1 args2)
                else Decide_right
            | SymMLOAD soffset1 smem1, SymMLOAD soffset2 smem2 =>
                if (sstack_val_eq_dec soffset1 soffset2)
                then Decide_with (smemory_eq_dec smem1 smem2)
                else Decide_right
            | SymSLOAD skey1 sstrg1, SymSLOAD skey2 sstrg2 =>
                if (sstack_val_eq_dec skey1 skey2)
                then Decide_with (sstorage_eq_dec sstrg1 sstrg2)
                else Decide_right
            | SymSHA3 soffset1 ssize1 smem1,  SymSHA3 soffset2 ssize2 smem2 =>
                if (sstack_val_eq_dec soffset1 soffset2)
                then if (sstack_val_eq_dec ssize1 ssize2)
                     then Decide_with (smemory_eq_dec smem1 smem2)
                     else Decide_right
                else Decide_right

            | _, _ => Decide_right
            end); try congruence.
Qed.


Definition sbinding_eq_dec : forall (b1 b2 : sbinding), { b1 = b2 } + { b1 <> b2 }.
Proof.
  refine (fun (b1 b2 : sbinding) =>
            match b1, b2 with
            | (idx1,smv1),(idx2,smv2) =>
                if (Nat.eq_dec idx1 idx2)
                then Decide_with (smap_value_eq_dec smv1 smv2)
                else Decide_right
            end); try congruence.
Qed.

Definition sbindings_eq_dec : forall (bs1 bs2 : sbindings), { bs1 = bs2 } + { bs1 <> bs2 }.
Proof.
  refine (fix f (bs1 bs2 : sbindings) :=
            match bs1, bs2 with
            | [], [] => Decide_left
            | b1::bs1', b2::bs2' =>
                if (sbinding_eq_dec b1 b2)
                then Decide_with (f bs1' bs2')
                else Decide_right
            | _, _ => Decide_right
            end); try congruence.
Qed.

Definition smap_eq_dec : forall (m1 m2 : smap), { m1 = m2 } + { m1 <> m2 }.
Proof.
  refine (fun (m1 m2 : smap) =>
            match m1, m2 with
            | SymMap maxidx1 bs1, SymMap maxidx2 bs2 =>                
                if (Nat.eq_dec maxidx1 maxidx2)
                then Decide_with (sbindings_eq_dec bs1 bs2)
                else Decide_right
            end); try congruence.
Qed.

Definition sstae_eq_dec : forall (sst1 sst2 : sstate), { sst1 = sst2 } + { sst1 <> sst2 }.
  refine (fun (sst1 sst2 : sstate) =>
            match sst1, sst2 with
            | SymExState instk_height1 sstk1 smem1 sstrg1 sctx1 sm1,
              SymExState instk_height2 sstk2 smem2 sstrg2 sctx2 sm2 =>
                if (Nat.eq_dec instk_height1 instk_height2)
                then if (sstack_eq_dec sstk1 sstk2)
                     then if (smemory_eq_dec smem1 smem2)
                          then if (sstorage_eq_dec sstrg1 sstrg2)
                               then if (scontext_eq_dec sctx1 sctx2)
                                    then Decide_with (smap_eq_dec sm1 sm2)
                                    else Decide_right
                               else Decide_right
                          else Decide_right
                     else Decide_right
                else Decide_right
            end); try congruence.
Qed.

End SymbolicStateDec.
  

  

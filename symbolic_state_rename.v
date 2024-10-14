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

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import FORVES.eval_common.
Import EvalCommon.

Module SymbolicStateRename.

  Definition rename_ssatck_val (sv: sstack_val) (shift: nat) (start: nat) : sstack_val :=
    match sv with
    | FreshVar i =>
        if (start <=? i) then
          FreshVar (i + shift)
        else
          FreshVar i
    | _ => sv
    end.
  
Definition rename_smem_u (u: memory_update sstack_val) (shift: nat) (start: nat) : memory_update sstack_val :=
  match u with 
  | U_MSTORE _ o v => U_MSTORE sstack_val (rename_ssatck_val o shift start) (rename_ssatck_val v shift start) 
  | U_MSTORE8 _ o v => U_MSTORE8 sstack_val (rename_ssatck_val o shift start) (rename_ssatck_val v shift start)
  end.

Definition rename_sstrg_u (u: storage_update sstack_val) (shift: nat) (start: nat) : storage_update sstack_val :=
  match u with 
  | U_SSTORE _ k v => U_SSTORE sstack_val (rename_ssatck_val k shift start) (rename_ssatck_val v shift start) 
  end.

Fixpoint rename_smem (smem: smemory) (shift: nat) (start: nat) : smemory :=
  match smem with
  | [] => []
  | u::smem' => (rename_smem_u u shift start)::(rename_smem smem' shift start)
  end.

Fixpoint rename_sstrg (sstrg: sstorage) (shift: nat) (start: nat) : sstorage :=
  match sstrg with
  | [] => []
  | u::sstrg' => (rename_sstrg_u u shift start)::(rename_sstrg sstrg' shift start)
  end.

Fixpoint rename_sstk (sstk: sstack) (shift: nat) (start: nat) : sstack :=
  match sstk with
  | [] => []
  | sv::sstk' => (rename_ssatck_val sv shift start)::(rename_sstk sstk' shift start)
  end.

Definition rename_smv (smv: smap_value) (shift: nat) (start: nat) : smap_value :=
    match smv with
| SymBasicVal val => SymBasicVal (rename_ssatck_val val shift start)
| SymMETAPUSH cat val => SymMETAPUSH cat val
| SymOp label args => SymOp label (rename_sstk args shift start)
| SymMLOAD offset smem => SymMLOAD (rename_ssatck_val offset shift start) (rename_smem smem shift start)
| SymSLOAD key sstrg => SymSLOAD (rename_ssatck_val key shift start) (rename_sstrg sstrg shift start)
| SymSHA3 offset size smem => SymSHA3 (rename_ssatck_val offset shift start) (rename_ssatck_val size shift start) (rename_smem smem shift start)
end.

Definition rename_sbinding (sb: sbinding) (shift: nat) (start: nat) : sbinding :=
  match sb with
  | (i,smv) => (i+shift,rename_smv smv shift start)
  end.

Fixpoint rename_sbindings (bs: sbindings) (shift: nat) (start: nat) (nbs: sbindings): sbindings :=
  match bs with
  | [] => nbs
  | sb::bs' =>
      match sb with
      | (i,_) =>
          if (start <=? i)
          then (rename_sbinding sb shift start)::(rename_sbindings bs' shift start nbs)
          else app nbs bs
      end
  end.

Definition rename_smap (sm: smap) (shift: nat) (start: nat) (nbs: sbindings): smap :=
  match sm with
  | SymMap maxid bs => SymMap (maxid+shift) (rename_sbindings bs shift start nbs)
  end.

Definition sstate_insert_bindings (sst: sstate) (nbs: sbindings): option sstate :=
  match sst with
  | SymExState instk_height sstk smem sstrg sexts sm =>
      match nbs with
      | (idx,_)::_ =>
          let shift := length nbs in
          let start := idx in
          Some (SymExState instk_height (rename_sstk sstk shift start) (rename_smem smem shift start) (rename_sstrg sstrg shift start) sexts (rename_smap sm shift start nbs))
      | _ => None
      end
  end.

End SymbolicStateRename.



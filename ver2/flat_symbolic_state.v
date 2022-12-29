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

Module FlatSymbolicState.

Inductive sexpr : Type :=
| SExpr_Val (val: EVMWord)
| SExpr_InStkVar (var : nat)
| SExpr_Op (label : stack_op_instr) (args : list sexpr)
| SExpr_PUSHTAG (v: N)
| SExpr_MLOAD (offset: sexpr) (smem : memory_updates sexpr)
| SExpr_SLOAD (key: sexpr) (sstrg : storage_updates sexpr)
| SExpr_SHA3 (offset: sexpr) (size: sexpr) (smem : memory_updates sexpr).

Definition flat_sstack  : Type := list sexpr.
Definition flat_smemory : Type := memory_updates sexpr.
Definition flat_sstorage : Type := storage_updates sexpr.
Definition flat_sbindings : Type := list (nat*sexpr).

Inductive flat_scontext :=
  | FlatSymCtx. 

Inductive flat_sstate :=
  | FlatSymExState (instk_height: nat) (sstk: flat_sstack) (smem: flat_smemory) (sstg: flat_sstorage) (sctx: flat_scontext).

Definition make_flat_sst (instk_height: nat) (sstk: flat_sstack) (smem: flat_smemory) (sstrg: flat_sstorage) (sctx : flat_scontext) : flat_sstate :=
  FlatSymExState instk_height sstk smem sstrg sctx.

Definition get_instk_height_fsst (fsst: flat_sstate) : nat :=
  match fsst with
  | FlatSymExState instk_height _ _ _ _ => instk_height
  end.

Definition get_stack_fsst (fsst: flat_sstate) : flat_sstack :=
  match fsst with
  | FlatSymExState _ sstk _ _ _ => sstk
  end.

Definition get_memory_fsst (fsst: flat_sstate) : flat_smemory :=
  match fsst with
  | FlatSymExState _ _ smem _ _ => smem
  end.

Definition get_storage_fsst (fsst : flat_sstate) : flat_sstorage :=
  match fsst with
  | FlatSymExState _ _ _ sstrg _ => sstrg
  end.

Definition get_flat_context_sst (fsst : flat_sstate) : flat_scontext :=
  match fsst with
  | FlatSymExState _ _ _ _ sctx => sctx
  end.


Fixpoint sstack_val_to_sexpr (sv: sstack_val) (flat_sb:  flat_sbindings) : option sexpr :=
  match sv with
  | Val v => Some (SExpr_Val v)
  | InStackVar n => Some (SExpr_InStkVar n)
  | FreshVar idx =>
      match flat_sb with
      | [] => None
      | (key,sexpr)::flat_sb' =>
          if (key =? idx) then Some sexpr
          else sstack_val_to_sexpr sv flat_sb'
      end
  end.

Definition smap_value_to_sexpr (sv : smap_value) (flat_sb: flat_sbindings) : option sexpr :=
    match sv with
    | SymBasicVal sv' => sstack_val_to_sexpr sv' flat_sb
    | SymPUSHTAG v => Some (SExpr_PUSHTAG v)
    | SymOp label args =>
        let f_eval_list := fun (sv': sstack_val) => sstack_val_to_sexpr sv' flat_sb  in
        match map_option f_eval_list args with
        | None => None
        | Some sexpr_args => Some (SExpr_Op label sexpr_args)
        end
    | SymMLOAD soffset smem =>
        let f_eval_memupdate := instantiate_memory_update (fun sv => sstack_val_to_sexpr sv flat_sb) in
        match map_option f_eval_memupdate smem with
        | None => None
        | Some mem_updates =>
            match sstack_val_to_sexpr soffset flat_sb with
            | None => None
            | Some offset => Some (SExpr_MLOAD offset mem_updates)
            end
        end

    | SymSLOAD skey sstrg =>
        let f_eval_strgupdate := instantiate_storage_update (fun sv => sstack_val_to_sexpr sv flat_sb) in
        match map_option f_eval_strgupdate sstrg with
        | None => None
        | Some strg_updates =>
            match sstack_val_to_sexpr skey flat_sb with
            | None => None
            | Some key => Some (SExpr_SLOAD key strg_updates)
            end
        end
    | SymSHA3 soffset ssize smem =>
        let f_eval_memupdate := instantiate_memory_update (fun sv => sstack_val_to_sexpr sv flat_sb) in
        match map_option f_eval_memupdate smem with
        | None => None
        | Some mem_updates =>
            match sstack_val_to_sexpr soffset flat_sb with
            | None => None
            | Some offset =>
                match sstack_val_to_sexpr ssize flat_sb with
                | None => None
                | Some size => Some (SExpr_SHA3 offset size mem_updates)
                end
            end
        end
    end.


Fixpoint bindings_to_flat_bindings (sb: sbindings) : option flat_sbindings :=
  match sb with
  |  [] => Some []
  |  (key,sv)::sb' =>
       match bindings_to_flat_bindings sb' with
       | None => None
       | Some flat_sb' =>
           match smap_value_to_sexpr sv flat_sb' with
           | None => None
           | Some flat_sv =>
               Some ((key,flat_sv)::flat_sb')
           end
       end
  end.



Definition sstack_to_flat_sstack (sst: sstate) (flat_sb: flat_sbindings) : option flat_sstack :=
  let sstk := get_stack_sst sst in
  let f_eval_list := fun (sv': sstack_val) => sstack_val_to_sexpr sv' flat_sb  in
  map_option f_eval_list sstk.

Definition smemory_to_flat_smemory (sst: sstate) (flat_sb: flat_sbindings) : option flat_smemory :=
  let smem := get_memory_sst sst in
  let f_eval_memupdate := instantiate_memory_update (fun sv => sstack_val_to_sexpr sv flat_sb) in
  map_option f_eval_memupdate smem.

Definition sstorage_to_flat_sstorage (sst: sstate) (flat_sb: flat_sbindings) : option flat_sstorage :=
  let sstrg := get_storage_sst sst in
  let f_eval_strgupdate := instantiate_storage_update (fun sv => sstack_val_to_sexpr sv flat_sb) in
  map_option f_eval_strgupdate sstrg.


Definition sstate_to_flat_sstate (sst : sstate) : option flat_sstate :=
  match get_smap_sst sst with
    SymMap _ bs =>
      match bindings_to_flat_bindings bs with
      | None => None
      | Some flat_sb =>
          match sstack_to_flat_sstack sst flat_sb with
          | None => None
          | Some flat_sstk =>
              match smemory_to_flat_smemory sst flat_sb with
              | None => None
              | Some flat_smem =>
                  match sstorage_to_flat_sstorage sst flat_sb with
                  | None => None
                  | Some flat_sstrg => Some (make_flat_sst (get_instk_height_sst sst) flat_sstk flat_smem flat_sstrg FlatSymCtx)
                  end
              end
          end
      end
  end.










End FlatSymbolicState.

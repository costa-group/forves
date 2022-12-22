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

Module FlatSymbolicState.

Inductive sexpr : Type :=
| SExpr_Val (val: EVMWord)
| SExpr_InStkVar (var : nat)
| SExpr_Op (label : stack_op_instr) (args : list sexpr)
| SExpr_PUSHTAG (v: N)
| SExpr_MLOAD (offset: sexpr) (smem : memory_updates sexpr)
| SExpr_SLOAD (key: sexpr) (sstrg : storage_updates sexpr)
| SExpr_SHA3 (offset: sexpr) (size: sexpr) (smem : memory_updates sexpr).

Inductive flate_sstate :=
  | FlatSymExState (instk_height: nat) (sstk: list sexpr) (smem: memory_updates sexpr) (sstg: storage_updates sexpr).


Definition update_memory' (mem: memory) (update : memory_update EVMWord) :=
  match update with
  | U_MSTORE _ offset value => mstore mem offset value
  | U_MSTORE8 _ offset value => mstore mem (split1_byte (value: word ((S (pred BytesInEVMWord))*8))) offset
  end.

Fixpoint update_memory (mem: memory) (updates : memory_updates EVMWord) :=
  match updates with
  | [] => mem
  | u::us =>
      let mem' := update_memory' mem u in
      update_memory mem' us
  end.

Definition update_storage' (strg: storage) (update : storage_update EVMWord) :=
  match update with
  | U_SSTORE _ key value => sstore strg key value
  end.

Fixpoint update_storage (strg: storage) (updates : storage_updates EVMWord) :=
  match updates with
  | [] => strg
  | u::us =>
      let strg' := update_storage' strg u in
      update_storage strg' us
  end.


Fixpoint bindings_to_flat_bindings'' (sv: sstack_val) (flat_sb:  list (nat*sexpr)) : option sexpr :=
  match sv with
  | Val v => Some (SExpr_Val v)
  | InStackVar n => Some (SExpr_InStkVar n)
  | FreshVar idx =>
      match flat_sb with
      | [] => None
      | (key,sexpr)::flat_sb' =>
          if (key =? idx) then Some sexpr
          else bindings_to_flat_bindings'' sv flat_sb'
      end
  end.

Definition bindings_to_flat_bindings' (sv : smap_value) (flat_sb:  list (nat*sexpr)) : option sexpr :=
    match sv with
    | SymBasicVal sv' => bindings_to_flat_bindings'' sv' flat_sb
    | SymPUSHTAG v => Some (SExpr_PUSHTAG v)
    | SymOp label args =>
        let f_eval_list := fun (sv': sstack_val) => bindings_to_flat_bindings'' sv' flat_sb  in
        match fold_right_option f_eval_list args with
        | None => None
        | Some sexpr_args => Some (SExpr_Op label sexpr_args)
        end
    | SymMLOAD soffset smem =>
        let f_eval_memupdate := fun (update: memory_update sstack_val) =>
                                  match update with
                                  | U_MSTORE _ soffset svalue =>
                                      let ooffset := bindings_to_flat_bindings'' soffset flat_sb in
                                      let ovalue := bindings_to_flat_bindings'' svalue flat_sb in
                                      match ooffset, ovalue with
                                      | Some offset, Some value => Some (U_MSTORE sexpr offset value)
                                      | _, _ => None
                                      end
                                  | U_MSTORE8 _ soffset svalue =>
                                      let ooffset := bindings_to_flat_bindings'' soffset flat_sb in
                                      let ovalue := bindings_to_flat_bindings'' svalue flat_sb in
                                      match ooffset, ovalue with
                                      | Some offset, Some value => Some (U_MSTORE8 sexpr offset value)
                                      | _, _ => None
                                      end
                                  end
        in
        match fold_right_option f_eval_memupdate smem with
        | None => None
        | Some mem_updates =>
            match bindings_to_flat_bindings'' soffset flat_sb with
            | None => None
            | Some offset => Some (SExpr_MLOAD offset mem_updates)
            end
        end

    | SymSLOAD skey sstrg =>
        let f_eval_strgupdate := fun (update: storage_update sstack_val) =>
                                  match update with
                                  | U_SSTORE _ skey svalue =>
                                      let okey := bindings_to_flat_bindings'' skey flat_sb in
                                      let ovalue := bindings_to_flat_bindings'' svalue flat_sb in
                                      match okey, ovalue with
                                      | Some key, Some value => Some (U_SSTORE sexpr key value)
                                      | _, _ => None
                                      end
                                  end
        in
        match fold_right_option f_eval_strgupdate sstrg with
        | None => None
        | Some strg_updates =>
            match bindings_to_flat_bindings'' skey flat_sb with
            | None => None
            | Some key => Some (SExpr_SLOAD key strg_updates)
            end
        end
    | SymSHA3 soffset ssize smem =>
        let f_eval_memupdate := fun (update: memory_update sstack_val) =>
                                  match update with
                                  | U_MSTORE _ soffset svalue =>
                                      let ooffset := bindings_to_flat_bindings'' soffset flat_sb in
                                      let ovalue := bindings_to_flat_bindings'' svalue flat_sb in
                                      match ooffset, ovalue with
                                      | Some offset, Some value => Some (U_MSTORE sexpr offset value)
                                      | _, _ => None
                                      end
                                  | U_MSTORE8 _ soffset svalue =>
                                      let ooffset := bindings_to_flat_bindings'' soffset flat_sb in
                                      let ovalue := bindings_to_flat_bindings'' svalue flat_sb in
                                      match ooffset, ovalue with
                                      | Some offset, Some value => Some (U_MSTORE8 sexpr offset value)
                                      | _, _ => None
                                      end
                                  end
        in
        match fold_right_option f_eval_memupdate smem with
        | None => None
        | Some mem_updates =>
            match bindings_to_flat_bindings'' soffset flat_sb with
            | None => None
            | Some offset =>
                match bindings_to_flat_bindings'' ssize flat_sb with
                | None => None
                | Some size => Some (SExpr_SHA3 offset size mem_updates)
                end
            end
        end
    end.


Fixpoint bindings_to_flat_bindings (sb: sbindings) : option (list (nat*sexpr)) :=
  match sb with
  |  [] => Some []
  |  (key,sv)::sb' =>
       match bindings_to_flat_bindings sb' with
       | None => None
       | Some flat_sb' =>
           match bindings_to_flat_bindings' sv flat_sb' with
           | None => None
           | Some flat_sv =>
               Some ((key,flat_sv)::flat_sb')
           end
       end
  end.



             
Definition sstate_to_flat_sstate (sst : sstate) :=
  match get_smap_sst sst with
    SymMap _ bs =>
      match bindings_to_flat_bindings bs with
      | None => None
      | Some flat_sb =>
          let sstk := get_stack_sst sst in
          let f_eval_list := fun (sv': sstack_val) => bindings_to_flat_bindings'' sv' flat_sb  in
          match fold_right_option f_eval_list sstk with
          | None => None
          | Some flat_sstk =>
              let smem := get_memory_sst sst in
              let f_eval_memupdate := fun (update: memory_update sstack_val) =>
                                        match update with
                                        | U_MSTORE _ soffset svalue =>
                                            let ooffset := bindings_to_flat_bindings'' soffset flat_sb in
                                            let ovalue := bindings_to_flat_bindings'' svalue flat_sb in
                                            match ooffset, ovalue with
                                            | Some offset, Some value => Some (U_MSTORE sexpr offset value)
                                            | _, _ => None
                                            end
                                        | U_MSTORE8 _ soffset svalue =>
                                            let ooffset := bindings_to_flat_bindings'' soffset flat_sb in
                                            let ovalue := bindings_to_flat_bindings'' svalue flat_sb in
                                            match ooffset, ovalue with
                                            | Some offset, Some value => Some (U_MSTORE8 sexpr offset value)
                                            | _, _ => None
                                            end
                                        end
              in
              match fold_right_option f_eval_memupdate smem with
              | None => None
              | Some flat_smem =>
                  let sstrg := get_storage_sst sst in
                  let f_eval_strgupdate := fun (update: storage_update sstack_val) =>
                                             match update with
                                             | U_SSTORE _ skey svalue =>
                                                 let okey := bindings_to_flat_bindings'' skey flat_sb in
                                                 let ovalue := bindings_to_flat_bindings'' svalue flat_sb in
                                                 match okey, ovalue with
                                                 | Some key, Some value => Some (U_SSTORE sexpr key value)
                                                 | _, _ => None
                                                 end
                                             end
                  in
                  match fold_right_option f_eval_strgupdate sstrg with
                  | None => None
                  | Some flat_sstrg => Some (FlatSymExState 0 flat_sstk flat_smem flat_sstrg)
                  end
              end
          end
      end
  end.










End FlatSymbolicState.

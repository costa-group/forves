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

Module FlatExpression.

Inductive sexpr : Type :=
| SExpr_Val (val: EVMWord)
| SExpr_InStkVar (var : nat)
| SExpr_Op (label : stack_op_instr) (args : list sexpr)
| SExpr_MLOAD (offset: sexpr) (smem : memory_updates sexpr)
| SExpr_SLOAD (key: sexpr) (sstrg : storage_updates sexpr)
| SExpr_SHA3 (offset: sexpr) (size: sexpr) (smem : memory_updates sexpr).

Inductive flate_sstate :=
  | FlatSymExState (instk_height: nat) (sstk: list sexpr) (smem: memory_updates sexpr) (sstg: storage_updates sexpr).


Definition update_memory' (mem: memory) (update : memory_update EVMWord) :=
  match update with
  | U_MSTORE _ offset value => mstore mem offset value
  | U_MSTORE8 _ offset value => mstore8 mem offset (split1 8 (EVMWordSize-8) value)
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

Fixpoint apply_f_list_sstack_val {A B : Type} (f: A -> option B) (l: list A) :
  option (list B) :=
match l with 
| nil => Some []
| elem::rs => let elem_oval := f elem in
              let rs_oval := apply_f_list_sstack_val f rs in
              match (elem_oval, rs_oval) with 
              | (Some elem_val, Some rs_val) => Some (elem_val::rs_val)
              | _ => None
              end
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
    | SymOp label args =>
        let f_eval_list := fun (sv': sstack_val) => bindings_to_flat_bindings'' sv' flat_sb  in
        match apply_f_list_sstack_val f_eval_list args with
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
        match apply_f_list_sstack_val f_eval_memupdate smem with
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
        match apply_f_list_sstack_val f_eval_strgupdate sstrg with
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
        match apply_f_list_sstack_val f_eval_memupdate smem with
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
          match apply_f_list_sstack_val f_eval_list sstk with
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
              match apply_f_list_sstack_val f_eval_memupdate smem with
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
                  match apply_f_list_sstack_val f_eval_strgupdate sstrg with
                  | None => None
                  | Some flat_sstrg => Some (FlatSymExState 0 flat_sstk flat_smem flat_sstrg)
                  end
              end
          end
      end
  end.






             
Fixpoint eval_sstack_val (sv : sstack_val) (st: state) (sb: sbindings) (ops: stack_op_instr_map) : option EVMWord :=
  match sv with
  | Val v => Some v
  | InStackVar n =>
      let stk := get_stack_st st in
      match nth_error stk n with
      | Some v => Some v
      | None => None
      end
  | FreshVar idx =>
      match sb with
      | [] => None
      | (key,smv)::sb' =>
          if key =? idx then
            match smv with
            (* basic value *)
            | SymBasicVal v => eval_sstack_val v st sb' ops
            (* stack operation instruction *)
            | SymOp label args =>
                match ops label with
                | None => None
                | Some (OpImp nargs f _) => 
                    if (List.length args =? nargs) then
                      let f_eval_list := fun (sv': sstack_val) => eval_sstack_val sv' st sb' ops in
                      match apply_f_list_sstack_val f_eval_list args with
                      | None => None
                      | Some vargs => Some (f (get_context_st st) vargs)
                      end
                    else None
                end
            (* memory read *)
            | SymMLOAD soffset smem =>
                let f_eval_memupdate := fun (update: memory_update sstack_val) =>
                                          match update with
                                          | U_MSTORE _ soffset svalue =>
                                              let ooffset := eval_sstack_val soffset st sb' ops in
                                              let ovalue := eval_sstack_val svalue st sb' ops in
                                              match ooffset, ovalue with
                                              | Some offset, Some value => Some (U_MSTORE EVMWord offset value)
                                              | _, _ => None
                                              end
                                          | U_MSTORE8 _ soffset svalue =>
                                              let ooffset := eval_sstack_val soffset st sb' ops in
                                              let ovalue := eval_sstack_val svalue st sb' ops in
                                              match ooffset, ovalue with
                                              | Some offset, Some value => Some (U_MSTORE8 EVMWord offset value)
                                              | _, _ => None
                                              end
                                          end
                in
                match apply_f_list_sstack_val f_eval_memupdate smem with
                | None => None
                | Some mem_updates =>
                    match eval_sstack_val soffset st sb' ops with
                    | None => None
                    | Some offset =>
                        let mem := update_memory (get_memory_st st) mem_updates in
                        Some (mload mem offset)
                    end
                end
            (* storage read *)
            | SymSLOAD skey sstrg =>
                let f_eval_strgupdate := fun (update: storage_update sstack_val) =>
                                          match update with
                                          | U_SSTORE _ skey svalue =>
                                              let okey := eval_sstack_val skey st sb' ops in
                                              let ovalue := eval_sstack_val svalue st sb' ops in
                                              match okey, ovalue with
                                              | Some key, Some value => Some (U_SSTORE EVMWord key value)
                                              | _, _ => None
                                              end
                                          end
                in
                match apply_f_list_sstack_val f_eval_strgupdate sstrg with
                | None => None
                | Some strg_updates =>
                    match eval_sstack_val skey st sb' ops with
                    | None => None
                    | Some key =>
                        let strg := update_storage (get_storage_st st) strg_updates in
                        Some (sload strg key)
                    end
                end

            (* SHA3 and KECCAK256 *)
            | SymSHA3 soffset ssize smem =>
                                let f_eval_memupdate := fun (update: memory_update sstack_val) =>
                                          match update with
                                          | U_MSTORE _ soffset svalue =>
                                              let ooffset := eval_sstack_val soffset st sb' ops in
                                              let ovalue := eval_sstack_val svalue st sb' ops in
                                              match ooffset, ovalue with
                                              | Some offset, Some value => Some (U_MSTORE EVMWord offset value)
                                              | _, _ => None
                                              end
                                          | U_MSTORE8 _ soffset svalue =>
                                              let ooffset := eval_sstack_val soffset st sb' ops in
                                              let ovalue := eval_sstack_val svalue st sb' ops in
                                              match ooffset, ovalue with
                                              | Some offset, Some value => Some (U_MSTORE8 EVMWord offset value)
                                              | _, _ => None
                                              end
                                          end
                in
                match apply_f_list_sstack_val f_eval_memupdate smem with
                | None => None
                | Some mem_updates =>
                    match eval_sstack_val soffset st sb' ops with
                    | None => None
                    | Some offset =>
                        match eval_sstack_val ssize st sb' ops with
                        | None => None
                        | Some size =>
                            let mem := update_memory (get_memory_st st) mem_updates in
                            let f_sha3 := (get_keccak256_ctx (get_context_st st)) in
                            Some (f_sha3 mem offset size)
                        end
                    end
                end

            end
          else eval_sstack_val sv st sb' ops
      end
  end.






End FlatExpression.

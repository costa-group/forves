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

Module FlatSymbolicStateEval.

(*
Inductive sexpr : Type :=
| SExpr_Val (val: EVMWord)
| SExpr_InStkVar (var : nat)
| SExpr_Op (label : stack_op_instr) (args : list sexpr)
| SExpr_PUSHTAG (v: N)
| SExpr_MLOAD (offset: sexpr) (smem : memory_updates sexpr)
| SExpr_SLOAD (key: sexpr) (sstrg : storage_updates sexpr)
| SExpr_SHA3 (offset: sexpr) (size: sexpr) (smem : memory_updates sexpr).
 *)


Fixpoint eval_sexpr (fsv : sexpr) (stk: stack) (mem: memory) (strg: storage) (ctx: context) (ops : stack_op_instr_map) : option EVMWord :=
  match fsv with
  | SExpr_Val v1 => Some v1
  | SExpr_InStkVar n => 
      match nth_error stk n with
      | Some v => Some v
      | None => None
      end
  | SExpr_Op label args  =>
      match ops label with
      | OpImp nargs f _ _ =>
          (* first check that the number of argumets agree with what is declared in the map *)
          if (List.length args =? nargs) then
            let f_eval_list := fun (fsv': sexpr) => eval_sexpr fsv' stk mem strg ctx ops in
            match map_option f_eval_list args with
            | None => None
            | Some vargs => Some (f ctx vargs)
            end
          else None
      end
  | SExpr_PUSHTAG v =>
      let tags := (get_tags_ctx ctx) in Some (tags v)
  | SExpr_MLOAD offset smem =>
      let f_eval_mem_update := instantiate_memory_update (fun sv => eval_sexpr sv stk mem strg ctx ops) in
      match map_option f_eval_mem_update smem with (* Evaluate the arguments of the updates *)
      | None => None
      | Some mem_updates =>
          match eval_sexpr offset stk mem strg ctx ops with (* Evaluate the offset *)
          | None => None
          | Some offset =>
              let mem := update_memory mem mem_updates in (* apply updates to the memory *)
              Some (mload mem offset) (* lookup for the desired value in the memory *)
          end
      end
        
  | SExpr_SLOAD key sstrg => 
      let f_eval_strg_update := instantiate_storage_update (fun sv => eval_sexpr sv stk mem strg ctx ops) in
      match map_option f_eval_strg_update sstrg with (* Evaluate the arguments of the updates *)
      | None => None
      | Some strg_updates =>
          match eval_sexpr key stk mem strg ctx ops with (* Evaluate the key *)
          | None => None
          | Some key =>
              let strg := update_storage strg strg_updates in (* apply updates to the storage *)
              Some (sload strg key) (* lookup for the desired value in the storage *)
          end
      end
  | SExpr_SHA3 offset size smem => 
      let f_eval_mem_update := instantiate_memory_update (fun sv => eval_sexpr sv stk mem strg ctx ops) in
      match map_option f_eval_mem_update smem with (* Evaluate the arguments of the updates *)
      | None => None
      | Some mem_updates =>
          match eval_sexpr offset stk mem strg ctx ops with (* Evaluate the offset *)
          | None => None
          | Some offset =>
              match eval_sexpr size stk mem strg ctx ops with (* Evaluate the size *)
              | None => None
              | Some size =>
                  let mem := update_memory mem mem_updates in (* apply updates to the memory *)
                  let f_sha3 := (get_keccak256_ctx ctx) in (* get the sha3 function from the context and ... *)
                  Some (f_sha3 (wordToNat size) (mload' mem offset (wordToNat size))) (* ... apply it to the corresponding data *)
              end
          end
      end
  end.

Definition eval_flat_sstack (fsstk: flat_sstack) (stk: stack) (mem: memory) (strg: storage) (ctx: context) (ops: stack_op_instr_map) : option stack :=
  map_option (fun sv => eval_sexpr sv stk mem strg ctx ops) fsstk.

Definition eval_flat_smemory (fsmem: flat_smemory) (stk: stack) (mem: memory) (strg: storage) (ctx: context) (ops: stack_op_instr_map) : option memory :=
  let f_eval_mem_update := instantiate_memory_update (fun sv => eval_sexpr sv stk mem strg ctx ops) in
  match map_option f_eval_mem_update fsmem with
  | None => None
  | Some updates =>
      let mem' := update_memory mem updates in
      Some mem'
  end.

Definition eval_flat_sstorage (fsstrg: flat_sstorage) (stk: stack) (mem: memory) (strg: storage) (ctx: context) (ops: stack_op_instr_map) : option storage :=
  let f_eval_strg_update := instantiate_storage_update (fun sv => eval_sexpr sv stk mem strg ctx ops) in
  match map_option f_eval_strg_update fsstrg with
  | None => None
  | Some updates =>
      let strg' := update_storage strg updates in
      Some strg'
  end.

Definition eval_flat_sstate (st: state) (fsst: flat_sstate) (ops: stack_op_instr_map) : option state :=
  let stk := get_stack_st st in
  let mem := get_memory_st st in
  let strg := get_storage_st st in
  let ctx := get_context_st st in
  let instk_height := get_instk_height_fsst fsst in
  let fsstk := get_stack_fsst fsst in
  let fsmem := get_memory_fsst fsst in 
  let fsstrg := get_storage_fsst fsst in
  if instk_height =? length stk then
    match eval_flat_sstack fsstk stk mem strg ctx ops with
    | None => None
    | Some stk' =>
        match eval_flat_smemory fsmem stk mem strg ctx ops with
        | None => None
        | Some mem' =>
            match eval_flat_sstorage fsstrg stk mem strg ctx ops with
            | None => None
            | Some strg' =>
                let sst' := make_st stk' mem' strg' ctx in
                Some sst'
            end
        end
    end
  else
    None.

End FlatSymbolicStateEval.

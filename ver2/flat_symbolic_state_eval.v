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
| SExpr_MLOAD (offset: sexpr) (smem : memory_updates sexpr)
| SExpr_SLOAD (key: sexpr) (sstrg : storage_updates sexpr)
| SExpr_SHA3 (offset: sexpr) (size: sexpr) (smem : memory_updates sexpr).
 *)


Fixpoint eval_sexpr (fsv : sexpr) (st: state) (ops : stack_op_instr_map) : option EVMWord :=
  match fsv with
  | SExpr_Val v1 => Some v1
  | SExpr_InStkVar n => 
      let stk := get_stack_st st in
      match nth_error stk n with
      | Some v => Some v
      | None => None
      end
  | SExpr_Op label args  =>
      match ops label with
      | OpImp nargs f _ =>
          (* first check that the number of argumets agree with what is declared in the map *)
          if (List.length args =? nargs) then
            let f_eval_list := fun (fsv': sexpr) => eval_sexpr fsv' st ops in
            match fold_right_option f_eval_list args with
            | None => None
            | Some vargs => Some (f (get_context_st st) vargs)
            end
          else None
      end
  | SExpr_MLOAD offset smem =>
      let f_eval_mem_update := instantiate_memory_update (fun sv => eval_sexpr sv st ops) in
      match fold_right_option f_eval_mem_update smem with (* Evaluate the arguments of the updates *)
      | None => None
      | Some mem_updates =>
          match eval_sexpr offset st ops with (* Evaluate the offset *)
          | None => None
          | Some offset =>
              let mem := update_memory (get_memory_st st) mem_updates in (* apply updates to the memory *)
              Some (mload mem offset) (* lookup for the desired value in the memory *)
          end
      end
        
  | SExpr_SLOAD key sstrg => 
      let f_eval_strg_update := instantiate_storage_update (fun sv => eval_sexpr sv st ops) in
      match fold_right_option f_eval_strg_update sstrg with (* Evaluate the arguments of the updates *)
      | None => None
      | Some strg_updates =>
          match eval_sexpr key st ops with (* Evaluate the key *)
          | None => None
          | Some key =>
              let strg := update_storage (get_storage_st st) strg_updates in (* apply updates to the storage *)
              Some (sload strg key) (* lookup for the desired value in the storage *)
          end
      end
  | SExpr_SHA3 offset size smem => 
      let f_eval_mem_update := instantiate_memory_update (fun sv => eval_sexpr sv st ops) in
      match fold_right_option f_eval_mem_update smem with (* Evaluate the arguments of the updates *)
      | None => None
      | Some mem_updates =>
          match eval_sexpr offset st ops with (* Evaluate the offset *)
          | None => None
          | Some offset =>
              match eval_sexpr size st ops with (* Evaluate the size *)
              | None => None
              | Some size =>
                  let mem := update_memory (get_memory_st st) mem_updates in (* apply updates to the memory *)
                  let f_sha3 := (get_keccak256_ctx (get_context_st st)) in (* get the sha3 function from the context and ... *)
                  Some (f_sha3 mem offset size) (* ... apply it to the corresponding data *)
              end
          end
      end
  end.
 
End FlatSymbolicStateEval.

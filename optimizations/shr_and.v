Require Import bbv.Word.
Require Import Nat. 
Require Import Coq.NArith.NArith.
Require Import Coq.Bool.Bool.

Require Import Coq.Logic.FunctionalExtensionality.

Require Import FORVES.constants.
Import Constants.

Require Import FORVES.symbolic_state.
Import SymbolicState.

Require Import FORVES.symbolic_state_eval.
Import SymbolicStateEval.

Require Import FORVES.symbolic_state_cmp.
Import SymbolicStateCmp.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.execution_state.
Import ExecutionState.

Require Import FORVES.stack_operation_instructions.
Import StackOpInstrs.

Require Import FORVES.program.
Import Program.

Require Import FORVES.symbolic_state_cmp_impl.
Import SymbolicStateCmpImpl.

Require Import FORVES.symbolic_state_eval_facts.
Import SymbolicStateEvalFacts.

Require Import FORVES.valid_symbolic_state.
Import ValidSymbolicState.

Require Import FORVES.misc.
Import Misc.

Require Import FORVES.eval_common.
Import EvalCommon.

Require Import FORVES.concrete_interpreter.
Import ConcreteInterpreter.

Require Import FORVES.optimizations_def.
Import Optimizations_Def.

Require Import FORVES.optimizations_common.
Import Optimizations_Common.

Require Import List.
Import ListNotations.


Module Opt_shr_and.


(* EXTENDED OPTIMIZATION RULE *)

(* SHR(B, AND(X, A)) = AND(SHR(B, X), A >> B) with A, B constants 
https://github.com/ethereum/solidity/blob/abc46f309676637164076ca1a5b805cd90635bfa/libevmasm/RuleList.h#L558
*)
Definition optimize_shr_and_sbinding : opt_ext_smap_value_type := 
fun (val: smap_value) =>
fun (fcmp: sstack_val_cmp_t) =>
fun (sb: sbindings) =>
fun (maxid: nat) =>
fun (instk_height: nat) =>
fun (ops: stack_op_instr_map) => 
match val with
| SymOp SHR [b; arg] => 
  match follow_to_val b maxid sb with
  | Some bval => 
    match follow_in_smap arg maxid sb with
    | Some (FollowSmapVal (SymOp AND [arg1; arg2]) idx' sb') =>
      match follow_to_val arg1 idx' sb' with
      | Some aval => 
        let c := NToWord EVMWordSize (N.shiftr (wordToN aval) (wordToN bval)) in
        (SymOp AND [Val c; FreshVar maxid], 
         [(maxid, SymOp SHR [Val bval; arg2])],
         true)
      | _ => 
        match follow_to_val arg2 idx' sb' with
        | Some aval => 
          let c := NToWord EVMWordSize (N.shiftr (wordToN aval) (wordToN bval)) in
          (SymOp AND [Val c; FreshVar maxid], 
           [(maxid, SymOp SHR [Val bval; arg1])],
           true)
        | None => (val, [], false)
        end 
      end
    | _ => (val, [], false)
    end
  | _ => (val, [], false)
  end
| _ => (val, [], false)
end.


Lemma optimize_shr_and_sbinding_snd : opt_ext_sbinding_snd optimize_shr_and_sbinding.
Proof.
Admitted.


End Opt_shr_and.

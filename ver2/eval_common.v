Require Import bbv.Word.
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


Module EvalCommon.

(* Apply _concrete_ updates to a given memory. Note that they are applied in a
reverse order, the first in the list is the last update. *)
  
Definition update_memory' (mem: memory) (update : memory_update EVMWord) :=
  match update with
  | U_MSTORE _ offset value => mstore mem value offset
  | U_MSTORE8 _ offset value => mstore mem (split1_byte (value: word ((S (pred BytesInEVMWord))*8))) offset 
  end.

Fixpoint update_memory (mem: memory) (updates : memory_updates EVMWord) :=
  match updates with
  | [] => mem
  | u::us =>
      let mem' := update_memory mem us in
      update_memory' mem' u
  end.

(* Apply _concrete_ updates to a given storage. Note that they are
applied in a reverse order, the first in the list is the last
update. *)

Definition update_storage' (strg: storage) (update : storage_update EVMWord) :=
  match update with
  | U_SSTORE _ key value => sstore strg key value
  end.

Fixpoint update_storage (strg: storage) (updates : storage_updates EVMWord) :=
  match updates with
  | [] => strg
  | u::us =>
      let strg' := update_storage strg us in
      update_storage' strg' u
  end.



Definition instantiate_memory_update  {A B} (evaluator : A -> option B ) :=
  fun (update: memory_update A ) =>
    match update with
    | U_MSTORE _ soffset svalue =>
        let ooffset := evaluator soffset in
        let ovalue := evaluator  svalue in
        match ooffset, ovalue with
        | Some offset, Some value => Some (U_MSTORE B offset value)
        | _, _ => None
        end
    | U_MSTORE8 _ soffset svalue =>
        let ooffset := evaluator soffset in
        let ovalue := evaluator svalue  in
        match ooffset, ovalue with
        | Some offset, Some value => Some (U_MSTORE8 B offset value)
        | _, _ => None
        end
    end.


Definition instantiate_storage_update  {A B} (evaluator : A -> option B ) :=
  fun (update: storage_update A) =>
    match update with
    | U_SSTORE _ skey svalue =>
        let okey := evaluator skey  in
        let ovalue := evaluator svalue  in
        match okey, ovalue with
        | Some key, Some value => Some (U_SSTORE B key value)
        | _, _ => None
        end
    end.


End EvalCommon.

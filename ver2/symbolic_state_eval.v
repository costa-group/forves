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

Module SymbolicStateEval.



Fixpoint eval_sstack_val (sv : sstack_val) (stk : stack) (mem: memory) (strg: storage) (ctx: context) (sb: sbindings) (ops: stack_op_instr_map) : option EVMWord :=  
  match sv with
  (* Concrere values are retuned *)
  | Val v => Some v

  (* A stack element 'InStackVar n' takes its value from the n-th element of the concrete stack *)                  
  | InStackVar n =>
      match nth_error stk n with
      | Some v => Some v
      | None => None
      end

  (* This is the complex part. When finding a fresh variable we look
  for its value in the map. To convince COQ that this process
  terminates we pass the bindings as argument to eval_sstack_val *)

  | FreshVar idx =>
      match sb with
      | [] => None
      | (key,smv)::sb' =>          
          if key =? idx then  (* The fresh variable is the first in the binding *)
            match smv with

            (* basic value: we just evaluate 'v' recursively, it is a stack element *)
            | SymBasicVal v => eval_sstack_val v stk mem strg ctx sb' ops

            (* PUSHTAG *)
            | SymPUSHTAG v =>
                let tags := (get_tags_ctx ctx) in Some (tags v)

            (* stack operation instruction: we evaluate the argument
            recursively and then evaluate the corresponding operation *)
            | SymOp label args =>
                match ops label with
                | OpImp nargs f _ _ =>
                     (* first check that the number of argumets agree with what is declared in the map *)
                    if (List.length args =? nargs) then
                      let f_eval_list := fun (sv': sstack_val) => eval_sstack_val sv' stk mem strg ctx sb' ops in
                      match fold_right_option f_eval_list args with
                      | None => None
                      | Some vargs => Some (f ctx vargs)
                      end
                    else None
                end
                  
            (* memory read: 
                1. evaluate the updates, i.e., instantiate the symbolic arguments of the updates by concrete values
                2. evaluate the offset
                3. apply the updates to the memory of the concrete initial state 'st'
                4. look for the desired value in the memory 
             *)
            | SymMLOAD soffset smem =>
                let f_eval_mem_update := instantiate_memory_update (fun sv => eval_sstack_val sv stk mem strg ctx sb' ops) in
                match fold_right_option f_eval_mem_update smem with (* Evaluate the arguments of the updates *)
                | None => None
                | Some mem_updates =>
                    match eval_sstack_val soffset stk mem strg ctx sb' ops with (* Evaluate the offset *)
                    | None => None
                    | Some offset =>
                        let mem := update_memory mem mem_updates in (* apply updates to the memory *)
                        Some (mload mem offset) (* lookup for the desired value in the memory *)
                    end
                end
                  
            (* storage read: 
                1. evaluate the updates, i.e., instantiate the symbolic arguments of the updates by concrete values
                2. evaluate the key
                3. apply the updates to the storage of the concrete initial state 'st'
                4. look for the desired value in the stroarge 
             *)
            | SymSLOAD skey sstrg =>
                let f_eval_strg_update := instantiate_storage_update (fun sv => eval_sstack_val sv stk mem strg ctx sb' ops) in
                match fold_right_option f_eval_strg_update sstrg with (* Evaluate the arguments of the updates *)
                | None => None
                | Some strg_updates =>
                    match eval_sstack_val skey stk mem strg ctx sb' ops with (* Evaluate the key *)
                    | None => None
                    | Some key =>
                        let strg := update_storage strg strg_updates in (* apply updates to the storage *)
                        Some (sload strg key) (* lookup for the desired value in the storage *)
                    end
                end

            (* SHA3/KECCAK256: 
                1. evaluate the updates, i.e., instantiate the symbolic arguments of the updates by concrete values
                2. evaluate the offset/size
                3. apply the updates to the memeory of the concrete initial state 'st'
                4. apply the SHA3 function that is given in the context 
             *)
            | SymSHA3 soffset ssize smem =>
                let f_eval_mem_update := instantiate_memory_update (fun sv => eval_sstack_val sv stk mem strg ctx sb' ops) in
                match fold_right_option f_eval_mem_update smem with (* Evaluate the arguments of the updates *)
                | None => None
                | Some mem_updates =>
                    match eval_sstack_val soffset stk mem strg ctx sb' ops with (* Evaluate the offset *)
                    | None => None
                    | Some offset =>
                        match eval_sstack_val ssize stk mem strg ctx sb' ops with (* Evaluate the size *)
                        | None => None
                        | Some size =>
                            let mem := update_memory mem mem_updates in (* apply updates to the memory *)
                            let f_sha3 := (get_keccak256_ctx ctx) in (* get the sha3 function from the context and ... *)
                            Some (f_sha3 (wordToNat size) (mload' mem offset (wordToNat size))) (* ... apply it to the corresponding data *)
                        end
                    end
                end
            end
          else eval_sstack_val sv stk mem strg ctx sb' ops   (* The fresh variable is not the first in the binding so we continue recursively with the rest of bindings *)
      end
  end.
 


Definition eval_sstack' (sstk: sstack) (stk: stack) (mem: memory) (strg: storage) (ctx: context) (sb: sbindings) (ops: stack_op_instr_map) : option stack :=
  fold_right_option (fun sv => eval_sstack_val sv stk mem strg ctx sb ops) sstk.

Definition eval_sstack (stk: stack) (mem: memory) (strg: storage) (ctx: context) (sst: sstate) (ops: stack_op_instr_map) : option stack :=
  let instk_height := (get_instk_height_sst sst) in
  if (length stk) =? instk_height then
    let sstk := get_stack_sst sst in
    match (get_smap_sst sst) with
    | SymMap _ sb => eval_sstack' sstk stk mem strg ctx sb ops 
    end
  else
    None.



Definition eval_smemory (stk: stack) (mem: memory) (strg: storage) (ctx: context) (sst: sstate) (ops: stack_op_instr_map) : option memory :=
  match get_smap_sst sst with
  | SymMap _ sb =>
      let f_eval_mem_update := instantiate_memory_update (fun sv => eval_sstack_val sv stk mem strg ctx sb ops) in
      let smem := get_memory_sst sst in
      match fold_right_option f_eval_mem_update smem with
      | None => None
      | Some updates =>
          let mem' := update_memory mem updates in
          Some mem'
      end
  end.

Definition eval_sstorage (stk: stack) (mem: memory) (strg: storage) (ctx: context) (sst: sstate) (ops: stack_op_instr_map) : option storage :=
  match get_smap_sst sst with
  | SymMap _ sb =>
      let f_eval_strg_update := instantiate_storage_update (fun sv => eval_sstack_val sv stk mem strg ctx sb ops) in
      let sstrg := get_storage_sst sst in
      match fold_right_option f_eval_strg_update sstrg with
      | None => None
      | Some updates =>
          let strg' := update_storage strg updates in
          Some strg'
      end
  end.


Definition eval_sstate (st: state) (sst: sstate) (ops: stack_op_instr_map) : option state :=
  let stk := get_stack_st st in
  let mem := get_memory_st st in
  let strg := get_storage_st st in
  let ctx := get_context_st st in
  match eval_sstack stk mem strg ctx sst ops with
  | None => None
  | Some stk' =>
      match eval_smemory stk mem strg ctx sst ops with
      | None => None
      | Some mem' =>
          match eval_sstorage stk mem strg ctx sst ops with
          | None => None
          | Some strg' =>
              let sst' := make_st stk' mem' strg' ctx in
              Some sst'
          end
      end
  end.


End SymbolicStateEval.

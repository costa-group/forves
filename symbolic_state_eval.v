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



Fixpoint eval_sstack_val' (d : nat) (sv : sstack_val) (stk : stack) (mem: memory) (strg: storage) (exts: externals) (maxidx: nat) (sb: sbindings) (ops: stack_op_instr_map) : option EVMWord :=
  match d with
  | 0 => None
  | S d' =>
      match follow_in_smap sv maxidx sb with
      | None => None
      | Some (FollowSmapVal smv maxidx' sb') =>
          match smv with
          (* Concrere values are retuned *)
          | SymBasicVal (Val v) => Some v

          (* A stack element 'InStackVar n' takes its value from the n-th element of the concrete stack *)                  
          | SymBasicVal (InStackVar n) =>
              match nth_error stk n with
              | Some v => Some v
              | None => None
              end

          (* Not possible *)
          | SymBasicVal (FreshVar _) => None

          (* PUSHTAG *)
          | SymMETAPUSH cat v =>
              let tags := (get_tags_exts exts) in Some (tags cat v)

          (* stack operation instruction: we evaluate the argument
             recursively and then evaluate the corresponding operation *)
          | SymOp label args =>
              match ops label with
              | OpImp nargs f _ _ =>
                  (* first check that the number of argumets agree with what is declared in the map *)
                  if (List.length args =? nargs) then
                    let f_eval_list := fun (sv': sstack_val) => eval_sstack_val' d' sv' stk mem strg exts maxidx' sb' ops in
                    match map_option f_eval_list args with
                    | None => None
                    | Some vargs => Some (f exts vargs)
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
                let f_eval_mem_update := instantiate_memory_update (fun sv => eval_sstack_val' d' sv stk mem strg exts maxidx' sb' ops) in
                match map_option f_eval_mem_update smem with (* Evaluate the arguments of the updates *)
                | None => None
                | Some mem_updates =>
                    match eval_sstack_val' d' soffset stk mem strg exts maxidx' sb' ops with (* Evaluate the offset *)
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
                let f_eval_strg_update := instantiate_storage_update (fun sv => eval_sstack_val' d' sv stk mem strg exts maxidx' sb' ops) in
                match map_option f_eval_strg_update sstrg with (* Evaluate the arguments of the updates *)
                | None => None
                | Some strg_updates =>
                    match eval_sstack_val' d' skey stk mem strg exts maxidx' sb' ops with (* Evaluate the key *)
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
                4. apply the SHA3 function that is given in the externals 
             *)
            | SymSHA3 soffset ssize smem =>
                let f_eval_mem_update := instantiate_memory_update (fun sv => eval_sstack_val' d' sv stk mem strg exts maxidx' sb' ops) in
                match map_option f_eval_mem_update smem with (* Evaluate the arguments of the updates *)
                | None => None
                | Some mem_updates =>
                    match eval_sstack_val' d' soffset stk mem strg exts maxidx' sb' ops with (* Evaluate the offset *)
                    | None => None
                    | Some offset =>
                        match eval_sstack_val' d' ssize stk mem strg exts maxidx' sb' ops with (* Evaluate the size *)
                        | None => None
                        | Some size =>
                            let mem := update_memory mem mem_updates in (* apply updates to the memory *)
                            let f_sha3 := (get_keccak256_exts exts) in (* get the sha3 function from the externals and ... *)
                            Some (f_sha3 (wordToNat size) (mload' mem offset (wordToNat size))) (* ... apply it to the corresponding data *)
                        end
                    end
                end
          end
      end
  end.

Definition eval_sstack_val (sv : sstack_val) (stk : stack) (mem: memory) (strg: storage) (exts: externals) (maxidx: nat) (sb: sbindings) (ops: stack_op_instr_map) : option EVMWord :=  
  eval_sstack_val' (S maxidx) sv stk mem strg exts maxidx sb ops.


Definition eval_sstack (sstk: sstack) (maxidx: nat) (sb: sbindings) (stk: stack) (mem: memory) (strg: storage) (exts: externals) (ops: stack_op_instr_map): option stack :=
  map_option (fun sv => eval_sstack_val sv stk mem strg exts maxidx sb ops) sstk.


Definition eval_smemory (smem: smemory) (maxidx: nat) (sb: sbindings) (stk: stack) (mem: memory) (strg: storage) (exts: externals) (ops: stack_op_instr_map): option memory :=
  let f_eval_mem_update := instantiate_memory_update (fun sv => eval_sstack_val sv stk mem strg exts maxidx sb ops) in
  match map_option f_eval_mem_update smem with
  | None => None
  | Some updates =>
      let mem' := update_memory mem updates in
      Some mem'
  end.

Definition eval_sstorage (sstrg: sstorage) (maxidx: nat) (sb: sbindings) (stk: stack) (mem: memory) (strg: storage) (exts: externals) (ops: stack_op_instr_map): option storage :=
  let f_eval_strg_update := instantiate_storage_update (fun sv => eval_sstack_val sv stk mem strg exts maxidx sb ops) in
  match map_option f_eval_strg_update sstrg with
  | None => None
  | Some updates =>
      let strg' := update_storage strg updates in
      Some strg'
  end.

Definition eval_sstate (st: state) (sst: sstate) (ops: stack_op_instr_map) : option state :=
  let stk := get_stack_st st in
  let mem := get_memory_st st in
  let strg := get_storage_st st in
  let exts := get_externals_st st in
  let instk_height := get_instk_height_sst sst in
  let sstk := get_stack_sst sst in
  let smem := get_memory_sst sst in 
  let sstrg := get_storage_sst sst in
  let m := get_smap_sst sst in
  let maxidx := get_maxidx_smap m in
  let sb := get_bindings_smap m in
  if instk_height =? length stk then
    match eval_sstack sstk maxidx sb stk mem strg exts ops with
    | None => None
    | Some stk' =>
        match eval_smemory smem maxidx sb stk mem strg exts ops with
        | None => None
        | Some mem' =>
            match eval_sstorage sstrg maxidx sb stk mem strg exts ops with
            | None => None
            | Some strg' =>
                let sst' := make_st stk' mem' strg' exts in
                Some sst'
            end
        end
    end
  else
    None.
      


End SymbolicStateEval.

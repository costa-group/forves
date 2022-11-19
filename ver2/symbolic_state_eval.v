Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import Coq.NArith.NArith.
Require Import List.
Import ListNotations.

Require Import FORVES.constants.
Import FORVES_Constants.

Require Import FORVES.program.
Import FORVES_Program.

Require Import FORVES.execution_state.
Import FORVES_ExecutionState.

Require Import FORVES.stack_operation_instructions.
Import FORVES_StackOpInstrs.

Require Import FORVES.misc.
Import FORVES_Misc.

Require Import FORVES.symbolic_state.
Import FORVES_SymbolicState.

Require Import FORVES.concrete_interpreter.
Import FORVES_ConcreteInterpreter.

Module FORVES_SymbolicStateEval.



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




Fixpoint eval_sstack' (sstk: sstack) (st: state) (sb: sbindings) (ops: stack_op_instr_map) : option stack :=
  match sstk with
  | [] => Some []
  | sv::sstk' =>
      match eval_sstack_val sv st sb ops with
      | None => None
      | Some v =>
          match  eval_sstack' sstk' st sb ops with
          | None => None
          | Some vs => Some (v::vs)
          end
      end
  end.


Definition eval_sstack (st: state) (sst: sstate) (ops: stack_op_instr_map) : option stack :=
  let stk := get_stack_st st in
  let instk_height := (get_instk_height_sst sst) in
  if (length stk) =? instk_height then
    let sstk := get_stack_sst sst in
    match (get_smap_sst sst) with
    | SymMap _ sb => eval_sstack' sstk st sb ops
    end
  else
    None.


Definition eval_memory_update (update: memory_update sstack_val) (st: state) (sb: sbindings) (ops: stack_op_instr_map) : option (memory_update EVMWord) :=
  match update with
  | U_MSTORE _ soffset svalue =>
      let ooffset := eval_sstack_val soffset st sb ops in
      let ovalue := eval_sstack_val svalue st sb ops in
      match ooffset, ovalue with
      | Some offset, Some value => Some (U_MSTORE EVMWord offset value)
      | _, _ => None
      end
  | U_MSTORE8 _ soffset svalue =>
      let ooffset := eval_sstack_val soffset st sb ops in
      let ovalue := eval_sstack_val svalue st sb ops in
      match ooffset, ovalue with
      | Some offset, Some value => Some (U_MSTORE8 EVMWord offset value)
      | _, _ => None
      end
  end.

Fixpoint eval_memory_updates (smem : smemory) (st: state) (sb: sbindings) (ops: stack_op_instr_map) :=
  match smem with
  | [] => Some []
  | supdate::smem' =>
      match eval_memory_update supdate st sb ops with
      | None => None
      | Some update =>
          match eval_memory_updates smem' st sb ops with
          | None => None
          | Some updates => Some (update::updates)
          end
      end
  end.

Definition eval_smemory (st: state) (sst: sstate) (ops: stack_op_instr_map) : option memory :=
  match get_smap_sst sst with
  | SymMap _ sb =>
      let smem := get_memory_sst sst in
      match eval_memory_updates smem st sb ops with
      | None => None
      | Some updates =>
          let mem := (get_memory_st st) in
          let mem' := update_memory mem updates in
          Some mem'
      end
  end.



Definition eval_storage_update (update: storage_update sstack_val) (st: state) (sb: sbindings) (ops: stack_op_instr_map) : option (storage_update EVMWord) :=
  match update with
  | U_SSTORE _ skey svalue =>
      let okey := eval_sstack_val skey st sb ops in
      let ovalue := eval_sstack_val svalue st sb ops in
      match okey, ovalue with
      | Some key, Some value => Some (U_SSTORE EVMWord key value)
      | _, _ => None
      end
  end.

Fixpoint eval_storage_updates (strg : sstorage) (st: state) (sb: sbindings) (ops: stack_op_instr_map) :=
  match strg with
  | [] => Some []
  | supdate::sstrg' =>
      match eval_storage_update supdate st sb ops with
      | None => None
      | Some update =>
          match eval_storage_updates sstrg' st sb ops with
          | None => None
          | Some updates => Some (update::updates)
          end
      end
  end.

Definition eval_sstorage (st: state) (sst: sstate) (ops: stack_op_instr_map) : option storage :=
  match get_smap_sst sst with
  | SymMap _ sb =>
      let strg := get_storage_sst sst in
      match eval_storage_updates strg st sb ops with
      | None => None
      | Some updates =>
          let strg := (get_storage_st st) in
          let strg' := update_storage strg updates in
          Some strg'
      end
  end.


Definition eval_sstate (st: state) (sst: sstate) (ops: stack_op_instr_map) : option state :=
  match eval_sstack st sst ops with
  | None => None
  | Some stk =>
      match eval_smemory st sst ops with
      | None => None
      | Some mem =>
          match eval_sstorage st sst ops with
          | None => None
          | Some strg =>
              let ctx := get_context_st st in
              let sst' := make_st stk mem strg ctx in
              Some sst'
          end
      end
  end.


End FORVES_SymbolicStateEval.

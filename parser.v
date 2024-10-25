From Coq Require Import Numbers.DecimalString.
From Coq Require Import Numbers.HexadecimalNat.
From Coq Require Import Strings.String.
From Coq Require Import Strings.Ascii.
Require Import Hexadecimal HexadecimalFacts Arith.
Require Import Coq.NArith.NArith.
From Coq Require Import Lists.List. Import ListNotations.


Require Import bbv.Word.

Require Import FORVES.program.
Import Program.

Require Import FORVES.block_equiv_checker.
Import BlockEquivChecker.


Module Parser.

  
(* ################################################################# *)
(** * Internals *)

(* ================================================================= *)
(** ** Lexical Analysis *)

Definition isWhite (c : ascii) : bool :=
  let n := N_of_ascii c in
  orb (orb (N.eqb n 32%N)   (* space *)
           (N.eqb n 9%N))   (* tab *)
      (orb (N.eqb n 10%N)   (* linefeed *)
           (N.eqb n 13%N)). (* Carriage return. *)

Inductive chartype := white | other.

Definition classifyChar (c : ascii) : chartype :=
  if isWhite c then
    white
  else 
    other.


Fixpoint list_of_string (s : string) : list ascii :=
  match s with
  | EmptyString => []
  | String c s => c :: (list_of_string s)
  end.

Definition string_of_list (xs : list ascii) : string :=
  fold_right String EmptyString xs.

Definition token := string.


Fixpoint tokenize_helper (cls : chartype) (acc xs : list ascii)
                       : list (list ascii) :=
  let tk := match acc with [] => [] | _::_ => [rev acc] end in
  match xs with
  | [] => tk
  | (x::xs') =>
    match cls, classifyChar x, x with
    | _, white, _    =>
      tk ++ (tokenize_helper white [] xs')
    | other,other,x  =>
      tokenize_helper other (x::acc) xs'
    | _,tp,x         =>
      tk ++ (tokenize_helper tp [x] xs')
    end
  end %char.

Definition tokenize (s : string) : list string :=
  map string_of_list (tokenize_helper white [] (list_of_string s)).



Fixpoint uint_to_N (d:uint) : N :=
  match d with
  | Nil => 0x0
  | D0 d => 0x10 * uint_to_N d
  | D1 d => 0x1 + 0x10 * uint_to_N d
  | D2 d => 0x2 + 0x10 * uint_to_N d
  | D3 d => 0x3 + 0x10 * uint_to_N d
  | D4 d => 0x4 + 0x10 * uint_to_N d
  | D5 d => 0x5 + 0x10 * uint_to_N d
  | D6 d => 0x6 + 0x10 * uint_to_N d
  | D7 d => 0x7 + 0x10 * uint_to_N d
  | D8 d => 0x8 + 0x10 * uint_to_N d
  | D9 d => 0x9 + 0x10 * uint_to_N d
  | Da d => 0xa + 0x10 * uint_to_N d
  | Db d => 0xb + 0x10 * uint_to_N d
  | Dc d => 0xc + 0x10 * uint_to_N d
  | Dd d => 0xd + 0x10 * uint_to_N d
  | De d => 0xe + 0x10 * uint_to_N d
  | Df d => 0xf + 0x10 * uint_to_N d
  end.

Fixpoint parseHexNumber' (x : list ascii) (acc : uint) :=
  match x with
    | [] => Some acc
    | "0"%char::xs => parseHexNumber' xs (D0 acc)
    | "1"%char::xs => parseHexNumber' xs (D1 acc)
    | "2"%char::xs => parseHexNumber' xs (D2 acc)
    | "3"%char::xs => parseHexNumber' xs (D3 acc)
    | "4"%char::xs => parseHexNumber' xs (D4 acc)
    | "5"%char::xs => parseHexNumber' xs (D5 acc)
    | "6"%char::xs => parseHexNumber' xs (D6 acc)
    | "7"%char::xs => parseHexNumber' xs (D7 acc)
    | "8"%char::xs => parseHexNumber' xs (D8 acc)
    | "9"%char::xs => parseHexNumber' xs (D9 acc)
    | "a"%char::xs => parseHexNumber' xs (Da acc)
    | "A"%char::xs => parseHexNumber' xs (Da acc)
    | "b"%char::xs => parseHexNumber' xs (Db acc)
    | "B"%char::xs => parseHexNumber' xs (Db acc)
    | "c"%char::xs => parseHexNumber' xs (Dc acc)
    | "C"%char::xs => parseHexNumber' xs (Dc acc)
    | "d"%char::xs => parseHexNumber' xs (Dd acc)
    | "D"%char::xs => parseHexNumber' xs (Dd acc)
    | "e"%char::xs => parseHexNumber' xs (De acc)
    | "E"%char::xs => parseHexNumber' xs (De acc)
    | "f"%char::xs => parseHexNumber' xs (Df acc)
    | "F"%char::xs => parseHexNumber' xs (Df acc)
    | _ => None
  end.

Definition parseHexNumber (x : string) : option N :=
  let xl := (list_of_string x) in
  match xl with
  | "0"%char::"x"%char::xs =>
      match (parseHexNumber' xs Nil) with
      | None => None
      | Some n => Some (uint_to_N n)
      end
  | _ => None
  end.

Fixpoint parseDecNumber' (x : list ascii) (acc : nat) :=
  match x with
  | [] => Some acc
  | d::ds => let n := nat_of_ascii d in
             if (andb (Nat.leb 48 n) (Nat.leb n 57)) then
               parseDecNumber' ds (10*acc+(n-48))
             else None
  end.

Definition parseDecNumber (x : string) : option nat :=
  parseDecNumber' (list_of_string x) 0.

Definition is_push (s : string) : option nat :=
  match (list_of_string s) with
  | "P"%char::"U"%char::"S"%char::"H"%char::xs => match (parseDecNumber' xs 0) with
                                                  | None => None
                                                  | Some n => if (andb (Nat.leb 1 n) (Nat.leb n 32)) then Some n else None
                                                  end                                                 
  | _ => None
  end.

Definition is_metapush (s : string) : bool :=
  match s with
  | "METAPUSH"%string => true
  | _ => false
  end.

Definition is_dup (s : string) : option nat :=
  match (list_of_string s) with
  | "D"%char::"U"%char::"P"%char::xs => match (parseDecNumber' xs 0) with
                                        | None => None
                                        | Some n => if (andb (Nat.leb 1 n) (Nat.leb n 16)) then Some n else None
                                        end                                                 
  | _ => None
  end.

Definition is_swap (s : string) : option nat :=
  match (list_of_string s) with
  | "S"%char::"W"%char::"A"%char::"P"%char::xs => match (parseDecNumber' xs 0) with
                                                  | None => None
                                                  | Some n => if (andb (Nat.leb 1 n) (Nat.leb n 16)) then Some n else None
                                                  end                                                 
  | _ => None
  end.

Definition parse_non_push_instr (s : string) : option instr :=
  match (is_dup s) with
  | Some n => Some (DUP n)
  | None =>  match (is_swap s) with
             | Some n => Some (SWAP n)
             | None => match s with
                       | "ADD"%string => Some (OpInstr ADD)
                       | "MUL"%string => Some (OpInstr MUL)
                       | "SUB"%string => Some (OpInstr SUB)
                       | "DIV"%string => Some (OpInstr DIV)
                       | "SDIV"%string => Some (OpInstr SDIV)
                       | "MOD"%string => Some (OpInstr MOD)
                       | "SMOD"%string => Some (OpInstr SMOD)
                       | "ADDMOD"%string => Some (OpInstr ADDMOD)
                       | "MULMOD"%string => Some (OpInstr MULMOD)
                       | "EXP"%string => Some (OpInstr EXP)
                       | "SIGNEXTEND"%string => Some (OpInstr SIGNEXTEND)
                       | "LT"%string => Some (OpInstr LT)
                       | "GT"%string => Some (OpInstr GT)
                       | "SLT"%string => Some (OpInstr SLT)
                       | "SGT"%string => Some (OpInstr SGT)
                       | "EQ"%string => Some (OpInstr EQ)
                       | "ISZERO"%string => Some (OpInstr ISZERO)
                       | "AND"%string => Some (OpInstr AND)
                       | "OR"%string => Some (OpInstr OR)
                       | "XOR"%string => Some (OpInstr XOR)
                       | "NOT"%string => Some (OpInstr NOT)
                       | "BYTE"%string => Some (OpInstr BYTE)
                       | "SHL"%string => Some (OpInstr SHL)
                       | "SHR"%string => Some (OpInstr SHR)
                       | "SAR"%string => Some (OpInstr SAR)
                       | "ADDRESS"%string => Some (OpInstr ADDRESS)
                       | "BALANCE"%string => Some (OpInstr BALANCE)
                       | "ORIGIN"%string => Some (OpInstr ORIGIN)
                       | "CALLER"%string => Some (OpInstr CALLER)
                       | "CALLVALUE"%string => Some (OpInstr CALLVALUE)
                       | "CALLDATALOAD"%string => Some (OpInstr CALLDATALOAD)
                       | "CALLDATASIZE"%string => Some (OpInstr CALLDATASIZE)
                       | "CODESIZE"%string => Some (OpInstr CODESIZE)
                       | "GASPRICE"%string => Some (OpInstr GASPRICE)
                       | "EXTCODESIZE"%string => Some (OpInstr EXTCODESIZE)
                       | "RETURNDATASIZE"%string => Some (OpInstr RETURNDATASIZE)
                       | "EXTCODEHASH"%string => Some (OpInstr EXTCODEHASH)
                       | "BLOCKHASH"%string => Some (OpInstr BLOCKHASH)
                       | "COINBASE"%string => Some (OpInstr COINBASE)
                       | "TIMESTAMP"%string => Some (OpInstr TIMESTAMP)
                       | "NUMBER"%string => Some (OpInstr NUMBER)
                       | "DIFFICULTY"%string => Some (OpInstr DIFFICULTY)
                       | "GASLIMIT"%string => Some (OpInstr GASLIMIT)
                       | "CHAINID"%string => Some (OpInstr CHAINID)
                       | "SELFBALANCE"%string => Some (OpInstr SELFBALANCE)
                       | "BASEFEE"%string => Some (OpInstr BASEFEE)
                       | "GAS"%string => Some (OpInstr GAS)
                       | "JUMPI"%string => Some (OpInstr JUMPI)
                       | "PREVRANDAO"%string => Some (OpInstr PREVRANDAO)
                       | "POP"%string => Some POP
                       | "MLOAD"%string => Some MLOAD
                       | "MSTORE"%string => Some MSTORE
                       | "MSTORE8"%string => Some MSTORE8
                       | "SLOAD"%string => Some SLOAD
                       | "SSTORE"%string => Some SSTORE
                       | "SHA3"%string => Some SHA3
                       | "KECCAK256"%string => Some KECCAK256
                       | _ => None
                       end
             end
  end.

Fixpoint parse_block' (l : list string) : option block :=
  match l with
  | [] => Some []
  | x::xs => match (is_push x) with
             |  Some n =>
                  match xs with
                  | y::ys =>
                      match (parseHexNumber y) with
                      |  None => None
                      |  Some v =>
                           match (parse_block' ys) with
                           | None => None
                           | Some bs => Some ((PUSH n v)::bs)
                           end
                      end
                  | _ => None
                  end
             | None =>
                 match (is_metapush x) with
                 | true =>
                     match xs with
                     | z::y::ys =>
                         match (parseHexNumber y) with
                         |  None => None
                         |  Some v =>
                              match (parseDecNumber z) with
                              | None => None
                              | Some cat =>
                                  match (parse_block' ys) with
                                  | None => None
                                  | Some bs => Some ((METAPUSH (N.of_nat cat) v)::bs)
                                  end
                              end
                         end
                     | _ => None
                     end
                 | false =>
                           match (parse_non_push_instr x) with
                           | None => None
                           | Some i => match (parse_block' xs) with
                                       | None => None
                                       | Some bs => Some (i::bs)
                                       end
                           end
                       end
             end               
  end.

Definition parse_block (block_str : string) : option block :=
  parse_block' (tokenize block_str).


Definition str_to_opt (s : string) : option available_optimization_step :=
  match s with
  | "eval"%string => Some OPT_eval
  | "add_zero"%string => Some OPT_add_zero
  | "not_not"%string => Some OPT_not_not
  | "and_and"%string => Some OPT_and_and
  | "and_origin"%string => Some OPT_and_origin
  | "mul_shl"%string => Some OPT_mul_shl
  | "div_shl"%string => Some OPT_div_shl
  | "shr_zero_x"%string => Some OPT_shr_zero_x
  | "shr_x_zero"%string => Some OPT_shr_x_zero
  | "eq_zero"%string => Some OPT_eq_zero
  | "sub_x_x"%string => Some OPT_sub_x_x
  | "and_zero"%string => Some OPT_and_zero
  | "div_one"%string => Some OPT_div_one
  | "lt_x_one"%string => Some OPT_lt_x_one
  | "gt_one_x"%string => Some OPT_gt_one_x
  | "and_address"%string => Some OPT_and_address
  | "mul_one"%string => Some OPT_mul_one
  | "iszero_gt"%string => Some OPT_iszero_gt
  | "eq_iszero"%string => Some OPT_eq_iszero
  | "and_caller"%string => Some OPT_and_caller
  | "iszero3"%string => Some OPT_iszero3
  | "add_sub"%string => Some OPT_add_sub
  | "shl_zero_x"%string => Some OPT_shl_zero_x
  | "sub_zero"%string => Some OPT_sub_zero
  | "shl_x_zero"%string => Some OPT_shl_x_zero
  | "mul_zero"%string => Some OPT_mul_zero
  | "div_x_x"%string => Some OPT_div_x_x
  | "div_zero"%string => Some OPT_div_zero
  | "mod_one"%string => Some OPT_mod_one
  | "mod_zero"%string => Some OPT_mod_zero
  | "mod_x_x"%string => Some OPT_mod_x_x
  | "exp_x_zero"%string => Some OPT_exp_x_zero
  | "exp_x_one"%string => Some OPT_exp_x_one
  | "exp_one_x"%string => Some OPT_exp_one_x
  | "exp_zero_x"%string => Some OPT_exp_zero_x
  | "exp_two_x"%string => Some OPT_exp_two_x
  | "gt_zero_x"%string => Some OPT_gt_zero_x
  | "gt_x_x"%string => Some OPT_gt_x_x
  | "lt_x_zero"%string => Some OPT_lt_x_zero
  | "lt_x_x"%string => Some OPT_lt_x_x
  | "eq_x_x"%string => Some OPT_eq_x_x
  | "iszero_sub"%string => Some OPT_iszero_sub
  | "iszero_lt"%string => Some OPT_iszero_lt
  | "iszero_xor"%string => Some OPT_iszero_xor
  | "iszero2_gt"%string => Some OPT_iszero2_gt
  | "iszero2_lt"%string => Some OPT_iszero2_lt
  | "iszero2_eq"%string => Some OPT_iszero2_eq
  | "xor_x_x"%string => Some OPT_xor_x_x
  | "xor_zero"%string => Some OPT_xor_zero
  | "xor_xor"%string => Some OPT_xor_xor
  | "or_or"%string => Some OPT_or_or
  | "or_and"%string => Some OPT_or_and
  | "and_or"%string => Some OPT_and_or
  | "and_not"%string => Some OPT_and_not
  | "or_not"%string => Some OPT_or_not
  | "or_x_x"%string => Some OPT_or_x_x
  | "and_x_x"%string => Some OPT_and_x_x
  | "or_zero"%string => Some OPT_or_zero
  | "or_ffff"%string => Some OPT_or_ffff
  | "and_ffff"%string => Some OPT_and_ffff
  | "and_coinbase"%string => Some OPT_and_coinbase
  | "balance_address"%string => Some OPT_balance_address
  | "slt_x_x"%string => Some OPT_slt_x_x
  | "sgt_x_x"%string => Some OPT_sgt_x_x
  | "mem_solver"%string => Some OPT_mem_solver
  | "strg_solver"%string => Some OPT_strg_solver
  | "jumpi_eval"%string => Some OPT_jumpi_eval
  | "iszero2_slt"%string => Some OPT_iszero2_slt
  | "sub_const"%string => Some OPT_sub_const
  | "add_add_const"%string => Some OPT_add_add_const
  | "iszero2_lt_zero"%string => Some OPT_iszero2_lt_zero
  | "gt_x_zero_lt"%string => Some OPT_gt_x_zero_lt
  | "shl_shr"%string => Some OPT_shl_shr
  | "and_and_mask"%string => Some OPT_and_and_mask
  | "and_shr"%string => Some OPT_and_shr

  | "add_reshape"%string => Some OPT_add_reshape
  | "shr_and"%string => Some OPT_shr_and
  | _ => None
  end.


Fixpoint strs_to_opts (l : list string) : option list_opt_steps :=
  match l with
  | [] => Some []
  | x::xs => match (str_to_opt x) with
             | None => None
             | Some o => match (strs_to_opts xs) with
                         | None => None
                         | Some os => Some (o::os)
                         end
             end
  end.


Definition parse_opts_arg (opts_to_apply : list string) : option list_opt_steps :=
  match opts_to_apply with
  | ["none"%string] => Some []
  | ["gas"%string] => Some gas_pipeline
  | ["size"%string] => Some size_pipeline
  | ["solc"%string] => Some solc_pipeline
  | _ => strs_to_opts opts_to_apply
  end.

Definition parse_memory_updater (s: string) :=
  match s with
  | "trivial"%string => Some SMemUpdater_Trivial
  | "basic"%string => Some SMemUpdater_Basic
  | _ => None
  end.

Definition parse_storage_updater (s: string) :=
  match s with
  | "trivial"%string => Some SStrgUpdater_Trivial
  | "basic"%string => Some SStrgUpdater_Basic
  | _ => None
  end.

Definition parse_mload_solver (s: string) :=
  match s with
  | "trivial"%string => Some MLoadSolver_Trivial
  | "basic"%string => Some MLoadSolver_Basic
  | _ => None
  end.

Definition parse_sload_solver (s: string) :=
  match s with
  | "trivial"%string => Some SLoadSolver_Trivial
  | "basic"%string => Some SLoadSolver_Basic
  | _ => None
  end.

Definition parse_sstack_value_cmp (s: string) :=
  match s with
  | "trivial"%string => Some SStackValCmp_Trivial
  | "basic"%string => Some SStackValCmp_Basic
  | "basic_w_eq_chk"%string => Some SStackValCmp_Basic_w_eq_chk
  | _ => None
  end.

Definition parse_memory_cmp (s: string) :=
  match s with
  | "trivial"%string => Some SMemCmp_Trivial
  | "basic"%string => Some SMemCmp_Basic
  | "po"%string => Some SMemCmp_PO
  | _ => None
  end.

Definition parse_storage_cmp (s: string) :=
  match s with
  | "trivial"%string => Some SStrgCmp_Trivial
  | "basic"%string => Some SStrgCmp_Basic
  | "po"%string => Some SStrgCmp_PO
  | _ => None
  end.

Definition parse_sha3_cmp (s: string) :=
  match s with
  | "trivial"%string => Some SHA3Cmp_Trivial
  | "basic"%string => Some SHA3Cmp_Basic
  | _ => None
  end.

Definition block_eq (memory_updater storage_updater mload_solver sload_solver sstack_value_cmp memory_cmp storage_cmp sha3_cmp opt_step_rep opt_pipeline_rep: string) (opts_to_apply : list string) :
  option (string -> string -> string -> option bool) :=
  match (parse_memory_updater memory_updater) with
  | None => None
  | Some memory_updater_tag =>
      match (parse_storage_updater storage_updater) with
      | None => None
      | Some storage_updater_tag =>
          match (parse_mload_solver mload_solver) with
          | None => None
          | Some mload_solver_tag =>
              match (parse_sload_solver sload_solver) with
              | None => None
              | Some sload_solver_tag =>
                  match (parse_sstack_value_cmp sstack_value_cmp) with
                  | None => None
                  | Some sstack_value_cmp_tag =>
                      match (parse_memory_cmp memory_cmp) with
                      | None => None
                      | Some memory_cmp_tag =>
                          match (parse_storage_cmp storage_cmp) with
                          | None => None
                          | Some storage_cmp_tag =>
                              match (parse_sha3_cmp sha3_cmp) with
                              | None => None
                              | Some sha3_cmp_tag =>
                                  match (parseDecNumber opt_step_rep) with
                                  | None => None
                                  | Some opt_step_rep_nat =>
                                      match (parseDecNumber opt_pipeline_rep) with
                                      | None => None
                                      | Some opt_pipeline_rep_nat =>
                                          match (parse_opts_arg opts_to_apply) with
                                          | None => None
                                          | Some optimization_steps =>
                                              let chkr_lazy :=
                                                evm_eq_block_chkr_lazy memory_updater_tag storage_updater_tag mload_solver_tag sload_solver_tag sstack_value_cmp_tag memory_cmp_tag storage_cmp_tag sha3_cmp_tag optimization_steps opt_step_rep_nat opt_pipeline_rep_nat in
                                              Some (fun (p_opt p k : string) => 
                                                      match (parse_block p_opt) with
                                                      | None => None
                                                      | Some b1 => 
                                                          match (parse_block p) with
                                                          | None => None
                                                          | Some b2 =>
                                                              match (parseDecNumber k) with
                                                              | None => None
                                                              | Some k_nat =>
                                                                  Some (chkr_lazy b1 b2 k_nat)
                                                              end
                                                          end
                                                      end)
                                          end
                                      end
                                  end
                              end
                          end
                      end
                  end
              end
          end
      end
  end.


End Parser.
 

Require Import Coq_EVM.definitions.
Import Concrete.
Require Import Coq_EVM.optimizations.
Import Optimizations.
Require Import Coq_EVM.checker.
Import Checker.
From Coq Require Import Numbers.DecimalString.
From Coq Require Import Numbers.HexadecimalNat.
Require Import Hexadecimal HexadecimalFacts Arith.
From Coq Require Import Strings.String.
From Coq Require Import Strings.Ascii.
From Coq Require Import Lists.List. Import ListNotations.
Require Import Coq.NArith.NArith.
Require Import bbv.Word.


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

Compute parseHexNumber "0xffa".


Fixpoint parseDecNumber' (x : list ascii) (acc : nat) :=
  match x with
  | [] => Some acc
  | d::ds => let n := nat_of_ascii d in
             if (andb (leb 48 n) (leb n 57)) then
               parseDecNumber' ds (10*acc+(n-48))
             else None
  end.

Definition parseDecNumber (x : string) : option nat :=
  parseDecNumber' (list_of_string x) 0.


Definition is_push (s : string) : option nat :=
  match (list_of_string s) with
  | "P"%char::"U"%char::"S"%char::"H"%char::xs => match (parseDecNumber' xs 0) with
                                                  | None => None
                                                  | Some n => if (andb (leb 1 n) (leb n 32)) then Some n else None
                                                  end                                                 
  | _ => None
  end.

Definition is_dup (s : string) : option nat :=
  match (list_of_string s) with
  | "D"%char::"U"%char::"P"%char::xs => match (parseDecNumber' xs 0) with
                                        | None => None
                                        | Some n => if (andb (leb 1 n) (leb n 16)) then Some n else None
                                        end                                                 
  | _ => None
  end.

Definition is_swap (s : string) : option nat :=
  match (list_of_string s) with
  | "S"%char::"W"%char::"A"%char::"P"%char::xs => match (parseDecNumber' xs 0) with
                                                  | None => None
                                                  | Some n => if (andb (leb 1 n) (leb n 16)) then Some n else None
                                                  end                                                 
  | _ => None
  end.

Definition parse_non_push_instr (s : string) : option instr :=
  match (is_dup s) with
  | Some n => Some (DUP n)
  | None =>  match (is_swap s) with
             | Some n => Some (SWAP n)
             | None => match s with
                       | "POP"%string => Some POP
                       | "ADD"%string => Some (Opcode ADD)
                       | "MUL"%string => Some (Opcode MUL)
                       | "NOT"%string => Some (Opcode NOT)
                       | "SUB"%string => Some (Opcode SUB)
                       | "DIV"%string => Some (Opcode DIV)
                       | "SDIV"%string => Some (Opcode SDIV)
                       | "MOD"%string => Some (Opcode MOD)
                       | "SMOD"%string => Some (Opcode SMOD)
                       | "ADDMOD"%string => Some (Opcode ADDMOD)
                       | "MULMOD"%string => Some (Opcode MULMOD)
                       | "EXP"%string => Some (Opcode EXP)
                       | "SIGNEXTEND"%string => Some (Opcode SIGNEXTEND)
                       | "LT"%string => Some (Opcode LT)
                       | "GT"%string => Some (Opcode GT)
                       | "SLT"%string => Some (Opcode SLT)
                       | "SGT"%string => Some (Opcode SGT)
                       | "EQ"%string => Some (Opcode EQ)
                       | "ISZERO"%string => Some (Opcode ISZERO)
                       | "AND"%string => Some (Opcode AND)
                       | "OR"%string => Some (Opcode OR)
                       | "XOR"%string => Some (Opcode XOR)
                       | "BYTE"%string => Some (Opcode BYTE)
                       | "SHL"%string => Some (Opcode SHL)
                       | "SHR"%string => Some (Opcode SHR)
                       | "SAR"%string => Some (Opcode SAR)
                       | "SHA3"%string => Some (Opcode SHA3)
                       | "KECCAK256"%string => Some (Opcode KECCAK256)
                       | "ADDRESS"%string => Some (Opcode ADDRESS)
                       | "BALANCE"%string => Some (Opcode BALANCE)
                       | "ORIGIN"%string => Some (Opcode ORIGIN)
                       | "CALLER"%string => Some (Opcode CALLER)
                       | "CALLVALUE"%string => Some (Opcode CALLVALUE)
                       | "CALLDATALOAD"%string => Some (Opcode CALLDATALOAD)
                       | "CALLDATASIZE"%string => Some (Opcode CALLDATASIZE )
                       | "CODESIZE"%string => Some (Opcode CODESIZE)
                       | "GASPRICE"%string => Some (Opcode GASPRICE)
                       | "EXTCODESIZE"%string => Some (Opcode EXTCODESIZE)
                       | "RETURNDATASIZE"%string => Some (Opcode RETURNDATASIZE)
                       | "EXTCODEHASH"%string => Some (Opcode EXTCODEHASH)
                       | "BLOCKHASH"%string => Some (Opcode BLOCKHASH)
                       | "COINBASE"%string => Some (Opcode COINBASE)
                       | "TIMESTAMP"%string => Some (Opcode TIMESTAMP)
                       | "NUMBER"%string => Some (Opcode NUMBER)
                       | "DIFFICULTY"%string => Some (Opcode DIFFICULTY)
                       | "GASLIMIT"%string => Some (Opcode GASLIMIT)
                       | "CHAINID"%string => Some (Opcode CHAINID)
                       | "SELFBALANCE"%string => Some (Opcode SELFBALANCE)
                       | "BASEFEE"%string => Some (Opcode BASEFEE)
                       | "SLOAD"%string => Some (Opcode SLOAD)
                       | "MLOAD"%string => Some (Opcode MLOAD)
                       | "PC"%string => Some (Opcode PC)
                       | "MSIZE"%string => Some (Opcode MSIZE)
                       | "GAS"%string => Some (Opcode GAS)
                       | "CREATE"%string => Some (Opcode CREATE)
                       | "CREATE2"%string => Some (Opcode CREATE2)
                       | _ => None
                       end
             end
  end.

Fixpoint parse_block' (l : list string) : option (list instr) :=
  match l with
  | [] => Some []
  | x::xs => match (is_push x) with
             |  Some n => match xs with
                          | y::ys => match (parseHexNumber y) with
                                     |  None => None
                                     |  Some v => match (parse_block' ys) with
                                                  | None => None
                                                  | Some bs => Some ((PUSH n (NToWord 256 v))::bs)
                                                  end
                                     end
                          | _ => None
                          end
             | None => match (parse_non_push_instr x) with
                       | None => None
                       | Some i => match (parse_block' xs) with
                                   | None => None
                                   | Some bs => Some (i::bs)
                                   end
                       end
             end               
  end.

Definition parse_block (block : string) : option (list instr) :=
  parse_block' (tokenize block).

Definition block_eq_0 (p_opt p k : string) :=
  match (parse_block p_opt) with
  | None => None
  | Some b1 => match (parse_block p) with
               | None => None
               | Some b2 => match (parse_block p) with
                            | None => None
                            | Some b2 => match (parseDecNumber k) with
                                         | Some v => Some (evm_eq_block_chkr optimize_id b1 b2 v)
                                         | None => None
                                         end
                            end
               end
  end.

Definition opt := (apply_pipeline_n_times our_optimization_pipeline 50).


Definition block_eq_1 (p_opt p k : string) :=
  match (parse_block p_opt) with
  | None => None
  | Some b1 => match (parse_block p) with
               | None => None
               | Some b2 => match (parse_block p) with
                            | None => None
                            | Some b2 => match (parseDecNumber k) with
                                         | Some v => Some (evm_eq_block_chkr' opt b1 b2 v)
                                         | None => None
                                         end
                            end
               end
  end.

Definition block_eq_2 (p_opt p k : string) :=
  match (parse_block p_opt) with
  | None => None
  | Some b1 => match (parse_block p) with
               | None => None
               | Some b2 => match (parse_block p) with
                            | None => None
                            | Some b2 => match (parseDecNumber k) with
                                         | Some v => Some (evm_eq_block_chkr'' opt b1 b2 v)
                                         | None => None
                                         end
                            end
               end
  end.

End Parser.

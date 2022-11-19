Require Import Coq.NArith.NArith.

Module FORVES_Program.

(*

Stack operation instructions: they require only the context and the
stack as input, they compute a value (to be pushed to the stack) given
the input.

*)

Inductive stack_op_instr :=
| ADD
| MUL
| SUB
| DIV
| SDIV
| MOD
| SMOD
| ADDMOD
| MULMOD
| EXP
| SIGNEXTEND
| LT
| GT
| SLT
| SGT
| EQ
| ISZERO
| AND
| OR
| XOR
| NOT
| BYTE
| SHL
| SHR
| SAR
| ADDRESS
| BALANCE
| ORIGIN
| CALLER
| CALLVALUE
| CALLDATALOAD
| CALLDATASIZE
| CODESIZE
| GASPRICE
| EXTCODESIZE
| RETURNDATASIZE
| EXTCODEHASH
| BLOCKHASH
| COINBASE
| TIMESTAMP
| NUMBER
| DIFFICULTY
| GASLIMIT
| CHAINID
| SELFBALANCE
| BASEFEE.


Definition eqb_stack_op_instr (a b: stack_op_instr) : bool :=
  match a,b with
  | ADD,ADD => true
  | MUL,MUL => true
  | SUB,SUB => true
  | DIV,DIV => true
  | SDIV,SDIV => true
  | MOD,MOD => true
  | SMOD,SMOD => true
  | ADDMOD,ADDMOD => true
  | MULMOD,MULMOD => true
  | EXP,EXP => true
  | SIGNEXTEND,SIGNEXTEND => true
  | LT,LT => true
  | GT,GT => true
  | SLT,SLT => true
  | SGT,SGT => true
  | EQ,EQ => true
  | ISZERO,ISZERO => true
  | AND,AND => true
  | OR,OR => true
  | XOR,XOR => true
  | NOT,NOT => true
  | BYTE,BYTE => true
  | SHL,SHL => true
  | SHR,SHR => true
  | SAR,SAR => true
  | ADDRESS,ADDRESS => true
  | BALANCE,BALANCE => true
  | ORIGIN,ORIGIN => true
  | CALLER,CALLER => true
  | CALLVALUE,CALLVALUE => true
  | CALLDATALOAD,CALLDATALOAD => true
  | CALLDATASIZE,CALLDATASIZE => true
  | GASPRICE,GASPRICE => true
  | EXTCODESIZE,EXTCODESIZE => true
  | RETURNDATASIZE,RETURNDATASIZE => true
  | EXTCODEHASH,EXTCODEHASH => true
  | BLOCKHASH,BLOCKHASH => true
  | COINBASE,COINBASE => true
  | TIMESTAMP,TIMESTAMP => true
  | NUMBER,NUMBER => true
  | DIFFICULTY,DIFFICULTY => true
  | GASLIMIT,GASLIMIT => true
  | CHAINID,CHAINID => true
  | SELFBALANCE,SELFBALANCE => true
  | BASEFEE,BASEFEE => true
  | CODESIZE,CODESIZE => true
  | _,_ => false
  end.

Notation "m '=?i' n" := (eqb_stack_op_instr m n) (at level 100).


(*

Instructions: (1) the basic stack manipulation ones -- PUSH, POP, DUP
and SWAP; (2) instruction that operate on memory/store; and (3) the
stack operation instructions above.

*)

Inductive instr :=
| PUSH (size : nat) (v: N)
| POP
| DUP (pos: nat)
| SWAP (pos: nat)
| SLOAD
| SSTORE
| MLOAD
| MSTORE
| MSTORE8
| SHA3
| KECCAK256
| OpInstr (label: stack_op_instr).

(* A block is a list instructions *)
Definition block : Type := list instr.  

End FORVES_Program.

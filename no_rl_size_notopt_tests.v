Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import List.
Require Import Coq_EVM.optimizations.
Import Optimizations.
Require Import Coq_EVM.definitions.
Import EVM_Def Concrete Abstract Optimizations.
Require Import Coq_EVM.interpreter.
Import Interpreter SFS.
Require Import Coq_EVM.checker.
Import Checker.
Import ListNotations.
Require Import Coq.Arith.Arith Coq.Arith.Div2 Coq.NArith.NArith Coq.Bool.Bool Coq.ZArith.ZArith.
From Coq Require Export String.

Definition optimize_id (a: asfs) : asfs*bool := (a, false).

(*
 I: POP PUSH B SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 1 SWAP3 SWAP2 SWAP1 PUSH [tag] 2
 O: POP PUSH b DUP2 PUSH 20 ADD PUSH [tag] 1 SWAP3 MLOAD PUSH [tag] 2
*)
Compute ( "BottleCastle_initial_block_0_4"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0xb%N);DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);SWAP 3;Opcode MLOAD;PUSH 1 (NToWord WLen 0x2%N)] [POP;PUSH 1 (NToWord WLen 0xB%N);SWAP 1;DUP 1;Opcode MLOAD;SWAP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x1%N);SWAP 3;SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x2%N)] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH 10 PUSH 0 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1
 O: PUSH 0 DUP1 PUSH 100 EXP PUSH 10 SLOAD PUSH ff DUP4 ISZERO ISZERO DUP4 MUL SWAP3 MUL NOT AND OR PUSH 10
*)
Compute ( "BottleCastle_initial_block_1_3"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0xff%N);DUP 4;Opcode ISZERO;Opcode ISZERO;DUP 4;Opcode MUL;SWAP 3;Opcode MUL;Opcode NOT;Opcode AND;Opcode OR;PUSH 1 (NToWord WLen 0x10%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x10%N);PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 1 (NToWord WLen 0xFF%N);Opcode MUL;Opcode NOT;Opcode AND;SWAP 1;DUP 4;Opcode ISZERO;Opcode ISZERO;Opcode MUL;Opcode OR;SWAP 1] 0 optimize_id) ).

(*
 I: POP PUSH 0 PUSH 10 PUSH 1 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1
 O: POP PUSH 0 PUSH 1 PUSH 100 EXP DUP2 ISZERO ISZERO DUP2 MUL SWAP1 PUSH ff MUL NOT PUSH 10 SLOAD AND OR PUSH 10
*)
Compute ( "BottleCastle_initial_block_1_4"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;DUP 2;Opcode ISZERO;Opcode ISZERO;DUP 2;Opcode MUL;SWAP 1;PUSH 1 (NToWord WLen 0xff%N);Opcode MUL;Opcode NOT;PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;Opcode AND;Opcode OR;PUSH 1 (NToWord WLen 0x10%N)] [POP;PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x10%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 1 (NToWord WLen 0xFF%N);Opcode MUL;Opcode NOT;Opcode AND;SWAP 1;DUP 4;Opcode ISZERO;Opcode ISZERO;Opcode MUL;Opcode OR;SWAP 1] 1 optimize_id) ).

(*
 I: POP CALLVALUE DUP1 ISZERO PUSH [tag] 3
 O: POP CALLVALUE CALLVALUE ISZERO PUSH [tag] 3
*)
Compute ( "BottleCastle_initial_block_1_5"%string, (equiv_checker [POP;Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x3%N)] [POP;Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x3%N)] 1 optimize_id) ).

(*
 I: DUP2 DUP2 ADD PUSH 40
 O: DUP1 DUP3 ADD PUSH 40
*)
Compute ( "BottleCastle_initial_block_3_1"%string, (equiv_checker [DUP 1;DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 2;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 2 optimize_id) ).

(*
 I: DUP2 ADD SWAP1 PUSH [tag] 4 SWAP2 SWAP1 PUSH [tag] 5
 O: DUP2 ADD PUSH [tag] 4 SWAP2 PUSH [tag] 5
*)
Compute ( "BottleCastle_initial_block_3_2"%string, (equiv_checker [DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);SWAP 2;PUSH 1 (NToWord WLen 0x5%N)] [DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x4%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x5%N)] 2 optimize_id) ).

(*
 I: POP DUP2 PUSH 2 SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 11 SWAP3 SWAP2 SWAP1 PUSH [tag] 2
 O: POP PUSH [tag] 11 PUSH 2 DUP4 PUSH 20 ADD DUP5 MLOAD PUSH [tag] 2
*)
Compute ( "BottleCastle_initial_block_4_6"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0xb%N);PUSH 1 (NToWord WLen 0x2%N);DUP 4;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 5;Opcode MLOAD;PUSH 1 (NToWord WLen 0x2%N)] [POP;DUP 2;PUSH 1 (NToWord WLen 0x2%N);SWAP 1;DUP 1;Opcode MLOAD;SWAP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0xb%N);SWAP 3;SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x2%N)] 3 optimize_id) ).

(*
 I: POP DUP1 PUSH 3 SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 12 SWAP3 SWAP2 SWAP1 PUSH [tag] 2
 O: POP PUSH [tag] 12 PUSH 3 PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 2
*)
Compute ( "BottleCastle_initial_block_5_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0xc%N);PUSH 1 (NToWord WLen 0x3%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 1 (NToWord WLen 0x2%N)] [POP;DUP 1;PUSH 1 (NToWord WLen 0x3%N);SWAP 1;DUP 1;Opcode MLOAD;SWAP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0xc%N);SWAP 3;SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x2%N)] 2 optimize_id) ).

(*
 I: PUSH 0 DUP2 SWAP1
 O: DUP1 PUSH 0
*)
Compute ( "BottleCastle_initial_block_7_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 1 PUSH 9 DUP2 SWAP1
 O: PUSH 1 DUP1 PUSH 9
*)
Compute ( "BottleCastle_initial_block_9_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0x9%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x9%N);DUP 2;SWAP 1] 0 optimize_id) ).

(*
 I: PUSH 0 PUSH 1 SWAP1 POP SWAP1
 O: PUSH 1 SWAP1
*)
Compute ( "BottleCastle_initial_block_12_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x1%N);SWAP 1;POP;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 0 CALLER SWAP1 POP SWAP1
 O: CALLER SWAP1
*)
Compute ( "BottleCastle_initial_block_13_0"%string, (equiv_checker [Opcode CALLER;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);Opcode CALLER;SWAP 1;POP;SWAP 1] 1 optimize_id) ).

(*
 I: POP DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 8BE0079C531659141344CD1FD0A4F28419497F9722A3DAAFE3B4186F6B6457E0 PUSH 40 MLOAD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: POP PUSH 40 MLOAD DUP1 DUP1 SUB PUSH 8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP5 DUP2 AND SWAP3 SWAP1 DUP7 AND SWAP4
*)
Compute ( "BottleCastle_initial_block_14_1"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 1;Opcode SUB;PUSH 32 (NToWord WLen 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0%N);PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 5;DUP 2;Opcode AND;SWAP 3;SWAP 1;DUP 7;Opcode AND;SWAP 4] [POP;DUP 2;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 2;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 32 (NToWord WLen 0x8BE0079C531659141344CD1FD0A4F28419497F9722A3DAAFE3B4186F6B6457E0%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 3 optimize_id) ).

(*
 I: DUP1 PUSH A SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 34 SWAP3 SWAP2 SWAP1 PUSH [tag] 2
 O: PUSH [tag] 34 PUSH a PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 2
*)
Compute ( "BottleCastle_initial_block_16_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x22%N);PUSH 1 (NToWord WLen 0xa%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 1 (NToWord WLen 0x2%N)] [DUP 1;PUSH 1 (NToWord WLen 0xA%N);SWAP 1;DUP 1;Opcode MLOAD;SWAP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x22%N);SWAP 3;SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x2%N)] 1 optimize_id) ).

(*
 I: DUP1 PUSH C SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 38 SWAP3 SWAP2 SWAP1 PUSH [tag] 2
 O: PUSH [tag] 38 PUSH c PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 2
*)
Compute ( "BottleCastle_initial_block_19_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x26%N);PUSH 1 (NToWord WLen 0xc%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 1 (NToWord WLen 0x2%N)] [DUP 1;PUSH 1 (NToWord WLen 0xC%N);SWAP 1;DUP 1;Opcode MLOAD;SWAP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x26%N);SWAP 3;SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x2%N)] 1 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH [tag] 44 SWAP1 PUSH [tag] 45
 O: PUSH [tag] 44 SWAP1 PUSH 4 ADD PUSH [tag] 45
*)
Compute ( "BottleCastle_initial_block_24_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x2c%N);SWAP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x2d%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x2c%N);SWAP 1;PUSH 1 (NToWord WLen 0x2d%N)] 1 optimize_id) ).

(*
 I: PUSH 0 PUSH 8 PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1 POP SWAP1
 O: PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 PUSH 100 EXP PUSH 8 SLOAD DIV AND SWAP1
*)
Compute ( "BottleCastle_initial_block_27_0"%string, (equiv_checker [PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;PUSH 1 (NToWord WLen 0x8%N);Opcode SLOAD;Opcode DIV;Opcode AND;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x8%N);PUSH 1 (NToWord WLen 0x0%N);SWAP 1;Opcode SLOAD;SWAP 1;PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;SWAP 1;Opcode DIV;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;SWAP 1;POP;SWAP 1] 1 optimize_id) ).

(*
 I: DUP3 DUP1 SLOAD PUSH [tag] 47 SWAP1 PUSH [tag] 48
 O: DUP3 PUSH [tag] 47 DUP5 SLOAD PUSH [tag] 48
*)
Compute ( "BottleCastle_initial_block_28_0"%string, (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0x2f%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0x30%N)] [DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x2f%N);SWAP 1;PUSH 1 (NToWord WLen 0x30%N)] 3 optimize_id) ).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1 PUSH 1F ADD PUSH 20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 50
 O: PUSH 20 DUP1 PUSH 0 KECCAK256 SWAP2 PUSH 1f ADD DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 50
*)
Compute ( "BottleCastle_initial_block_29_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;SWAP 2;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode DIV;DUP 2;Opcode ADD;SWAP 3;DUP 3;PUSH 1 (NToWord WLen 0x32%N)] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;SWAP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);SWAP 1;Opcode DIV;DUP 2;Opcode ADD;SWAP 3;DUP 3;PUSH 1 (NToWord WLen 0x32%N)] 3 optimize_id) ).

(*
 I: DUP1 MLOAD PUSH FF NOT AND DUP4 DUP1 ADD OR DUP6
 O: DUP3 DUP1 ADD PUSH ff NOT DUP3 MLOAD AND OR DUP6
*)
Compute ( "BottleCastle_initial_block_32_0"%string, (equiv_checker [DUP 3;DUP 1;Opcode ADD;PUSH 1 (NToWord WLen 0xff%N);Opcode NOT;DUP 3;Opcode MLOAD;Opcode AND;Opcode OR;DUP 6] [DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0xFF%N);Opcode NOT;Opcode AND;DUP 4;DUP 1;Opcode ADD;Opcode OR;DUP 6] 5 optimize_id) ).

(*
 I: DUP3 DUP1 ADD PUSH 1 ADD DUP6
 O: DUP3 DUP4 ADD PUSH 1 ADD DUP6
*)
Compute ( "BottleCastle_initial_block_33_0"%string, (equiv_checker [DUP 3;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 6] [DUP 3;DUP 1;Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 6] 5 optimize_id) ).

(*
 I: SWAP2 DUP3 ADD
 O: DUP1 SWAP3 ADD
*)
Compute ( "BottleCastle_initial_block_34_0"%string, (equiv_checker [DUP 1;SWAP 3;Opcode ADD] [SWAP 2;DUP 3;Opcode ADD] 3 optimize_id) ).

(*
 I: POP SWAP1 POP PUSH [tag] 54 SWAP2 SWAP1 PUSH [tag] 55
 O: POP PUSH [tag] 54 SWAP3 SWAP2 POP PUSH [tag] 55
*)
Compute ( "BottleCastle_initial_block_38_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x36%N);SWAP 3;SWAP 2;POP;PUSH 1 (NToWord WLen 0x37%N)] [POP;SWAP 1;POP;PUSH 1 (NToWord WLen 0x36%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x37%N)] 4 optimize_id) ).

(*
 I: PUSH 0 DUP2 PUSH 0 SWAP1
 O: PUSH 0 DUP1 DUP3
*)
Compute ( "BottleCastle_initial_block_42_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 3] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 20 DUP2 ADD DUP5 DUP5 DUP5 ADD GT ISZERO PUSH [tag] 65
 O: DUP1 PUSH 20 ADD DUP5 DUP4 DUP6 ADD GT ISZERO PUSH [tag] 65
*)
Compute ( "BottleCastle_initial_block_46_1"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 5;DUP 4;DUP 6;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x41%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;DUP 5;DUP 5;DUP 5;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x41%N)] 4 optimize_id) ).

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 72
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 72
*)
Compute ( "BottleCastle_initial_block_51_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode SLT;PUSH 1 (NToWord WLen 0x48%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;Opcode SLT;PUSH 1 (NToWord WLen 0x48%N)] 2 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute ( "BottleCastle_initial_block_55_0"%string, (equiv_checker [SWAP 5;SWAP 4;POP;POP;POP;POP] [SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: PUSH 0 DUP4 ADD MLOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 80
 O: DUP3 PUSH 0 ADD MLOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 80
*)
Compute ( "BottleCastle_initial_block_59_0"%string, (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;Opcode MLOAD;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x50%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD;Opcode MLOAD;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x50%N)] 3 optimize_id) ).

(*
 I: SWAP3 POP POP PUSH 20 DUP4 ADD MLOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 84
 O: SWAP3 POP POP DUP3 PUSH 20 ADD MLOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 84
*)
Compute ( "BottleCastle_initial_block_63_0"%string, (equiv_checker [SWAP 3;POP;POP;DUP 3;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;Opcode MLOAD;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x54%N)] [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;Opcode MLOAD;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x54%N)] 5 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute ( "BottleCastle_initial_block_67_0"%string, (equiv_checker [SWAP 5;POP;POP;POP;SWAP 3;SWAP 1;POP] [SWAP 2;POP;POP;SWAP 3;POP;SWAP 3;SWAP 1;POP] 7 optimize_id) ).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Compute ( "BottleCastle_initial_block_70_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 3 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute ( "BottleCastle_initial_block_71_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] 1 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_initial_block_72_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH 40 MLOAD SWAP1 POP SWAP1
 O: PUSH 40 MLOAD SWAP1
*)
Compute ( "BottleCastle_initial_block_76_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1;POP;SWAP 1] 1 optimize_id) ).

(*
 I: SWAP1 POP PUSH 20 DUP2 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_initial_block_81_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP PUSH 20 SWAP2 POP ADD SWAP1
*)
Compute ( "BottleCastle_initial_block_82_1"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x20%N);SWAP 2;POP;Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 4 optimize_id) ).

(*
 I: DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD
 O: DUP2 DUP2 ADD MLOAD DUP4 DUP3 ADD
*)
Compute ( "BottleCastle_initial_block_85_0"%string, (equiv_checker [DUP 2;DUP 2;Opcode ADD;Opcode MLOAD;DUP 4;DUP 3;Opcode ADD] [DUP 1;DUP 3;Opcode ADD;Opcode MLOAD;DUP 2;DUP 5;Opcode ADD] 3 optimize_id) ).

(*
 I: PUSH 20 DUP2 ADD SWAP1 POP PUSH [tag] 109
 O: PUSH 20 ADD PUSH [tag] 109
*)
Compute ( "BottleCastle_initial_block_85_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x6d%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;SWAP 1;POP;PUSH 1 (NToWord WLen 0x6d%N)] 1 optimize_id) ).

(*
 I: PUSH 0 DUP5 DUP5 ADD
 O: PUSH 0 DUP4 DUP6 ADD
*)
Compute ( "BottleCastle_initial_block_87_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 6;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);DUP 5;DUP 5;Opcode ADD] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH 2 DUP3 DIV SWAP1 POP PUSH 1 DUP3 AND DUP1 PUSH [tag] 114
 O: PUSH 2 DUP2 DIV DUP2 PUSH 1 AND DUP1 PUSH [tag] 114
*)
Compute ( "BottleCastle_initial_block_89_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x2%N);DUP 2;Opcode DIV;DUP 2;PUSH 1 (NToWord WLen 0x1%N);Opcode AND;DUP 1;PUSH 1 (NToWord WLen 0x72%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x2%N);DUP 3;Opcode DIV;SWAP 1;POP;PUSH 1 (NToWord WLen 0x1%N);DUP 3;Opcode AND;DUP 1;PUSH 1 (NToWord WLen 0x72%N)] 1 optimize_id) ).

(*
 I: PUSH 7F DUP3 AND SWAP2 POP
 O: SWAP1 PUSH 7f AND SWAP1
*)
Compute ( "BottleCastle_initial_block_90_0"%string, (equiv_checker [SWAP 1;PUSH 1 (NToWord WLen 0x7f%N);Opcode AND;SWAP 1] [PUSH 1 (NToWord WLen 0x7F%N);DUP 3;Opcode AND;SWAP 2;POP] 2 optimize_id) ).

(*
 I: PUSH 20 DUP3 LT DUP2 EQ ISZERO PUSH [tag] 115
 O: DUP1 PUSH 20 DUP4 LT EQ ISZERO PUSH [tag] 115
*)
Compute ( "BottleCastle_initial_block_91_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode LT;Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0x73%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode LT;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0x73%N)] 2 optimize_id) ).

(*
 I: DUP2 ADD DUP2 DUP2 LT PUSH FFFFFFFFFFFFFFFF DUP3 GT OR ISZERO PUSH [tag] 120
 O: DUP2 ADD PUSH ffffffffffffffff DUP2 GT DUP3 DUP3 LT OR ISZERO PUSH [tag] 120
*)
Compute ( "BottleCastle_initial_block_96_0"%string, (equiv_checker [DUP 2;Opcode ADD;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);DUP 2;Opcode GT;DUP 3;DUP 3;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 1 (NToWord WLen 0x78%N)] [DUP 2;Opcode ADD;DUP 2;DUP 2;Opcode LT;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);DUP 3;Opcode GT;Opcode OR;Opcode ISZERO;PUSH 1 (NToWord WLen 0x78%N)] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH 1F NOT PUSH 1F DUP4 ADD AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 1f ADD PUSH 1f NOT AND SWAP1
*)
Compute ( "BottleCastle_initial_block_106_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;PUSH 1 (NToWord WLen 0x1f%N);Opcode NOT;Opcode AND;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;Opcode AND;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH 4F776E61626C653A2063616C6C6572206973206E6F7420746865206F776E6572 PUSH 0 DUP3 ADD
 O: PUSH 4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572 DUP2 PUSH 0 ADD
*)
Compute ( "BottleCastle_initial_block_107_0"%string, (equiv_checker [PUSH 32 (NToWord WLen 0x4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x4F776E61626C653A2063616C6C6572206973206E6F7420746865206F776E6572%N);PUSH 1 (NToWord WLen 0x0%N);DUP 3;Opcode ADD] 1 optimize_id) ).

(*
 I: PUSH #[$] 0000000000000000000000000000000000000000000000000000000000000000 DUP1 PUSH [$] 0000000000000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH #[$] 0 DUP1 PUSH [$] 0 PUSH 0
  ERROR OCCURRED

'PUSH #[$]' is not in list
*)

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 46
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 46
*)
Compute ( "BottleCastle_run_code_of_0_block_53_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x2e%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x2e%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 47 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 48 SWAP2 SWAP1 PUSH [tag] 49
 O: POP PUSH [tag] 47 PUSH [tag] 48 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 49
*)
Compute ( "BottleCastle_run_code_of_0_block_55_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x2f%N);PUSH 1 (NToWord WLen 0x30%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x31%N)] [POP;PUSH 1 (NToWord WLen 0x2f%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x30%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x31%N)] 1 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 51 SWAP2 SWAP1 PUSH [tag] 52
 O: PUSH [tag] 51 SWAP1 PUSH 40 MLOAD PUSH [tag] 52
*)
Compute ( "BottleCastle_run_code_of_0_block_57_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x33%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x34%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x33%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x34%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 53
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 53
*)
Compute ( "BottleCastle_run_code_of_0_block_59_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x35%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x35%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 54 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 55 SWAP2 SWAP1 PUSH [tag] 56
 O: POP PUSH [tag] 54 PUSH [tag] 55 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 56
*)
Compute ( "BottleCastle_run_code_of_0_block_61_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x37%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x38%N)] [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x37%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x38%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 58
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 58
*)
Compute ( "BottleCastle_run_code_of_0_block_64_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x3a%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x3a%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 61 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 61 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Compute ( "BottleCastle_run_code_of_0_block_67_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x3d%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x3e%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x3d%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x3e%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 63
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 63
*)
Compute ( "BottleCastle_run_code_of_0_block_69_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x3f%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x3f%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 64 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 65 SWAP2 SWAP1 PUSH [tag] 66
 O: POP PUSH [tag] 64 PUSH [tag] 65 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 66
*)
Compute ( "BottleCastle_run_code_of_0_block_71_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x40%N);PUSH 1 (NToWord WLen 0x41%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x42%N)] [POP;PUSH 1 (NToWord WLen 0x40%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x41%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x42%N)] 1 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 68 SWAP2 SWAP1 PUSH [tag] 69
 O: PUSH [tag] 68 SWAP1 PUSH 40 MLOAD PUSH [tag] 69
*)
Compute ( "BottleCastle_run_code_of_0_block_73_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x44%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x45%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x44%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x45%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 70
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 70
*)
Compute ( "BottleCastle_run_code_of_0_block_75_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x46%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x46%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 73 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 73 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Compute ( "BottleCastle_run_code_of_0_block_78_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x49%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x3e%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x49%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x3e%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 74
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 74
*)
Compute ( "BottleCastle_run_code_of_0_block_80_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4a%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4a%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 75 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 76 SWAP2 SWAP1 PUSH [tag] 77
 O: POP PUSH [tag] 75 PUSH [tag] 76 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 77
*)
Compute ( "BottleCastle_run_code_of_0_block_82_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x4b%N);PUSH 1 (NToWord WLen 0x4c%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x4d%N)] [POP;PUSH 1 (NToWord WLen 0x4b%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x4c%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x4d%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 79
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 79
*)
Compute ( "BottleCastle_run_code_of_0_block_85_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4f%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4f%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 82 SWAP2 SWAP1 PUSH [tag] 83
 O: PUSH [tag] 82 SWAP1 PUSH 40 MLOAD PUSH [tag] 83
*)
Compute ( "BottleCastle_run_code_of_0_block_88_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x52%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x53%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x52%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x53%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 84
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 84
*)
Compute ( "BottleCastle_run_code_of_0_block_90_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x54%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x54%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 87 SWAP2 SWAP1 PUSH [tag] 83
 O: PUSH [tag] 87 SWAP1 PUSH 40 MLOAD PUSH [tag] 83
*)
Compute ( "BottleCastle_run_code_of_0_block_93_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x57%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x53%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x57%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x53%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 88
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 88
*)
Compute ( "BottleCastle_run_code_of_0_block_95_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x58%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x58%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 89 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 90 SWAP2 SWAP1 PUSH [tag] 91
 O: POP PUSH [tag] 89 PUSH [tag] 90 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 91
*)
Compute ( "BottleCastle_run_code_of_0_block_97_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x59%N);PUSH 1 (NToWord WLen 0x5a%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x5b%N)] [POP;PUSH 1 (NToWord WLen 0x59%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x5a%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x5b%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 95
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 95
*)
Compute ( "BottleCastle_run_code_of_0_block_102_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x5f%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x5f%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 96 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 97 SWAP2 SWAP1 PUSH [tag] 91
 O: POP PUSH [tag] 96 PUSH [tag] 97 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 91
*)
Compute ( "BottleCastle_run_code_of_0_block_104_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x61%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x5b%N)] [POP;PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x61%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x5b%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 99
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 99
*)
Compute ( "BottleCastle_run_code_of_0_block_107_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x63%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x63%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 100 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 101 SWAP2 SWAP1 PUSH [tag] 66
 O: POP PUSH [tag] 100 PUSH [tag] 101 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 66
*)
Compute ( "BottleCastle_run_code_of_0_block_109_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x64%N);PUSH 1 (NToWord WLen 0x65%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x42%N)] [POP;PUSH 1 (NToWord WLen 0x64%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x65%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x42%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 103
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 103
*)
Compute ( "BottleCastle_run_code_of_0_block_112_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x67%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x67%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 106 SWAP2 SWAP1 PUSH [tag] 52
 O: PUSH [tag] 106 SWAP1 PUSH 40 MLOAD PUSH [tag] 52
*)
Compute ( "BottleCastle_run_code_of_0_block_115_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x6a%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x34%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x6a%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x34%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 107
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 107
*)
Compute ( "BottleCastle_run_code_of_0_block_117_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x6b%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x6b%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 108 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 109 SWAP2 SWAP1 PUSH [tag] 110
 O: POP PUSH [tag] 108 PUSH [tag] 109 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 110
*)
Compute ( "BottleCastle_run_code_of_0_block_119_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x6c%N);PUSH 1 (NToWord WLen 0x6d%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x6e%N)] [POP;PUSH 1 (NToWord WLen 0x6c%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x6d%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x6e%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 112
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 112
*)
Compute ( "BottleCastle_run_code_of_0_block_122_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x70%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x70%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 115 SWAP2 SWAP1 PUSH [tag] 52
 O: PUSH [tag] 115 SWAP1 PUSH 40 MLOAD PUSH [tag] 52
*)
Compute ( "BottleCastle_run_code_of_0_block_125_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x73%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x34%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x73%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x34%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 116
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 116
*)
Compute ( "BottleCastle_run_code_of_0_block_127_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x74%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x74%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 117 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 118 SWAP2 SWAP1 PUSH [tag] 66
 O: POP PUSH [tag] 117 PUSH [tag] 118 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 66
*)
Compute ( "BottleCastle_run_code_of_0_block_129_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x75%N);PUSH 1 (NToWord WLen 0x76%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x42%N)] [POP;PUSH 1 (NToWord WLen 0x75%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x76%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x42%N)] 1 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 120 SWAP2 SWAP1 PUSH [tag] 69
 O: PUSH [tag] 120 SWAP1 PUSH 40 MLOAD PUSH [tag] 69
*)
Compute ( "BottleCastle_run_code_of_0_block_131_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x78%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x45%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x78%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x45%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 121
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 121
*)
Compute ( "BottleCastle_run_code_of_0_block_133_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x79%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x79%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 124 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 124 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Compute ( "BottleCastle_run_code_of_0_block_136_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x7c%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x3e%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x7c%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x3e%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 125
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 125
*)
Compute ( "BottleCastle_run_code_of_0_block_138_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x7d%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x7d%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 126 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 127 SWAP2 SWAP1 PUSH [tag] 128
 O: POP PUSH [tag] 126 PUSH [tag] 127 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 128
*)
Compute ( "BottleCastle_run_code_of_0_block_140_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x7e%N);PUSH 1 (NToWord WLen 0x7f%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x80%N)] [POP;PUSH 1 (NToWord WLen 0x7e%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x7f%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x80%N)] 1 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 130 SWAP2 SWAP1 PUSH [tag] 83
 O: PUSH [tag] 130 SWAP1 PUSH 40 MLOAD PUSH [tag] 83
*)
Compute ( "BottleCastle_run_code_of_0_block_142_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x82%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x53%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x82%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x53%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 131
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 131
*)
Compute ( "BottleCastle_run_code_of_0_block_144_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x83%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x83%N)] 0 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 134
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 134
*)
Compute ( "BottleCastle_run_code_of_0_block_148_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x86%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x86%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 135 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 136 SWAP2 SWAP1 PUSH [tag] 128
 O: POP PUSH [tag] 135 PUSH [tag] 136 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 128
*)
Compute ( "BottleCastle_run_code_of_0_block_150_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x87%N);PUSH 1 (NToWord WLen 0x88%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x80%N)] [POP;PUSH 1 (NToWord WLen 0x87%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x88%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x80%N)] 1 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 138 SWAP2 SWAP1 PUSH [tag] 139
 O: PUSH [tag] 138 SWAP1 PUSH 40 MLOAD PUSH [tag] 139
*)
Compute ( "BottleCastle_run_code_of_0_block_152_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x8a%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x8b%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x8a%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x8b%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 140
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 140
*)
Compute ( "BottleCastle_run_code_of_0_block_154_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x8c%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x8c%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 143 SWAP2 SWAP1 PUSH [tag] 69
 O: PUSH [tag] 143 SWAP1 PUSH 40 MLOAD PUSH [tag] 69
*)
Compute ( "BottleCastle_run_code_of_0_block_157_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x8f%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x45%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x8f%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x45%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 144
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 144
*)
Compute ( "BottleCastle_run_code_of_0_block_159_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x90%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x90%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 145 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 146 SWAP2 SWAP1 PUSH [tag] 56
 O: POP PUSH [tag] 145 PUSH [tag] 146 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 56
*)
Compute ( "BottleCastle_run_code_of_0_block_161_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x91%N);PUSH 1 (NToWord WLen 0x92%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x38%N)] [POP;PUSH 1 (NToWord WLen 0x91%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x92%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x38%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 148
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 148
*)
Compute ( "BottleCastle_run_code_of_0_block_164_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x94%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x94%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 151 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 151 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Compute ( "BottleCastle_run_code_of_0_block_167_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x97%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x3e%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x97%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x3e%N)] 1 optimize_id) ).

(*
 I: PUSH [tag] 152 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 153 SWAP2 SWAP1 PUSH [tag] 66
 O: PUSH [tag] 152 PUSH [tag] 153 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 66
*)
Compute ( "BottleCastle_run_code_of_0_block_169_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x98%N);PUSH 1 (NToWord WLen 0x99%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x42%N)] [PUSH 1 (NToWord WLen 0x98%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x99%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x42%N)] 0 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 155
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 155
*)
Compute ( "BottleCastle_run_code_of_0_block_172_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x9b%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x9b%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 156 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 157 SWAP2 SWAP1 PUSH [tag] 158
 O: POP PUSH [tag] 156 PUSH [tag] 157 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 158
*)
Compute ( "BottleCastle_run_code_of_0_block_174_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x9c%N);PUSH 1 (NToWord WLen 0x9d%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x9e%N)] [POP;PUSH 1 (NToWord WLen 0x9c%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x9d%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x9e%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 160
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 160
*)
Compute ( "BottleCastle_run_code_of_0_block_177_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xa0%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xa0%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 161 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 162 SWAP2 SWAP1 PUSH [tag] 163
 O: POP PUSH [tag] 161 PUSH [tag] 162 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 163
*)
Compute ( "BottleCastle_run_code_of_0_block_179_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0xa1%N);PUSH 1 (NToWord WLen 0xa2%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0xa3%N)] [POP;PUSH 1 (NToWord WLen 0xa1%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0xa2%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0xa3%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 165
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 165
*)
Compute ( "BottleCastle_run_code_of_0_block_182_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xa5%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xa5%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 166 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 167 SWAP2 SWAP1 PUSH [tag] 168
 O: POP PUSH [tag] 166 PUSH [tag] 167 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 168
*)
Compute ( "BottleCastle_run_code_of_0_block_184_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0xa6%N);PUSH 1 (NToWord WLen 0xa7%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0xa8%N)] [POP;PUSH 1 (NToWord WLen 0xa6%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0xa7%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0xa8%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 170
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 170
*)
Compute ( "BottleCastle_run_code_of_0_block_187_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xaa%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xaa%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 173 SWAP2 SWAP1 PUSH [tag] 83
 O: PUSH [tag] 173 SWAP1 PUSH 40 MLOAD PUSH [tag] 83
*)
Compute ( "BottleCastle_run_code_of_0_block_190_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0xad%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x53%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0xad%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x53%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 174
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 174
*)
Compute ( "BottleCastle_run_code_of_0_block_192_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xae%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xae%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 177 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 177 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Compute ( "BottleCastle_run_code_of_0_block_195_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0xb1%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x3e%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0xb1%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x3e%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 178
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 178
*)
Compute ( "BottleCastle_run_code_of_0_block_197_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb2%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb2%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 179 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 180 SWAP2 SWAP1 PUSH [tag] 66
 O: POP PUSH [tag] 179 PUSH [tag] 180 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 66
*)
Compute ( "BottleCastle_run_code_of_0_block_199_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0xb3%N);PUSH 1 (NToWord WLen 0xb4%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x42%N)] [POP;PUSH 1 (NToWord WLen 0xb3%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0xb4%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x42%N)] 1 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 182 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 182 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Compute ( "BottleCastle_run_code_of_0_block_201_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0xb6%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x3e%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0xb6%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x3e%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 183
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 183
*)
Compute ( "BottleCastle_run_code_of_0_block_203_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb7%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb7%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 186 SWAP2 SWAP1 PUSH [tag] 83
 O: PUSH [tag] 186 SWAP1 PUSH 40 MLOAD PUSH [tag] 83
*)
Compute ( "BottleCastle_run_code_of_0_block_206_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0xba%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x53%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0xba%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x53%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 187
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 187
*)
Compute ( "BottleCastle_run_code_of_0_block_208_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xbb%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xbb%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 188 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 189 SWAP2 SWAP1 PUSH [tag] 110
 O: POP PUSH [tag] 188 PUSH [tag] 189 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 110
*)
Compute ( "BottleCastle_run_code_of_0_block_210_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0xbc%N);PUSH 1 (NToWord WLen 0xbd%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x6e%N)] [POP;PUSH 1 (NToWord WLen 0xbc%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0xbd%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x6e%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 191
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 191
*)
Compute ( "BottleCastle_run_code_of_0_block_213_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xbf%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xbf%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 192 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 193 SWAP2 SWAP1 PUSH [tag] 128
 O: POP PUSH [tag] 192 PUSH [tag] 193 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 128
*)
Compute ( "BottleCastle_run_code_of_0_block_215_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0xc0%N);PUSH 1 (NToWord WLen 0xc1%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x80%N)] [POP;PUSH 1 (NToWord WLen 0xc0%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0xc1%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x80%N)] 1 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 195 SWAP2 SWAP1 PUSH [tag] 83
 O: PUSH [tag] 195 SWAP1 PUSH 40 MLOAD PUSH [tag] 83
*)
Compute ( "BottleCastle_run_code_of_0_block_217_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0xc3%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x53%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0xc3%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x53%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 196
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 196
*)
Compute ( "BottleCastle_run_code_of_0_block_219_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc4%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc4%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 197 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 198 SWAP2 SWAP1 PUSH [tag] 66
 O: POP PUSH [tag] 197 PUSH [tag] 198 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 66
*)
Compute ( "BottleCastle_run_code_of_0_block_221_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0xc5%N);PUSH 1 (NToWord WLen 0xc6%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x42%N)] [POP;PUSH 1 (NToWord WLen 0xc5%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0xc6%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x42%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 200
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 200
*)
Compute ( "BottleCastle_run_code_of_0_block_224_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc8%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc8%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 201 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 202 SWAP2 SWAP1 PUSH [tag] 203
 O: POP PUSH [tag] 201 PUSH [tag] 202 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 203
*)
Compute ( "BottleCastle_run_code_of_0_block_226_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0xc9%N);PUSH 1 (NToWord WLen 0xca%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0xcb%N)] [POP;PUSH 1 (NToWord WLen 0xc9%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0xca%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0xcb%N)] 1 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 205 SWAP2 SWAP1 PUSH [tag] 52
 O: PUSH [tag] 205 SWAP1 PUSH 40 MLOAD PUSH [tag] 52
*)
Compute ( "BottleCastle_run_code_of_0_block_228_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0xcd%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x34%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0xcd%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x34%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 206
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 206
*)
Compute ( "BottleCastle_run_code_of_0_block_230_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xce%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xce%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 207 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 208 SWAP2 SWAP1 PUSH [tag] 110
 O: POP PUSH [tag] 207 PUSH [tag] 208 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 110
*)
Compute ( "BottleCastle_run_code_of_0_block_232_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0xcf%N);PUSH 1 (NToWord WLen 0xd0%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x6e%N)] [POP;PUSH 1 (NToWord WLen 0xcf%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0xd0%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x6e%N)] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 210
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 210
*)
Compute ( "BottleCastle_run_code_of_0_block_235_0"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xd2%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xd2%N)] 0 optimize_id) ).

(*
 I: POP PUSH [tag] 211 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 212 SWAP2 SWAP1 PUSH [tag] 128
 O: POP PUSH [tag] 211 PUSH [tag] 212 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 128
*)
Compute ( "BottleCastle_run_code_of_0_block_237_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0xd3%N);PUSH 1 (NToWord WLen 0xd4%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x80%N)] [POP;PUSH 1 (NToWord WLen 0xd3%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0xd4%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x80%N)] 1 optimize_id) ).

(*
 I: PUSH 0 PUSH 1FFC9A7 PUSH E0 SHL DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ DUP1 PUSH [tag] 215
 O: PUSH 0 PUSH 1ffc9a7 PUSH e0 SHL PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT DUP4 AND EQ DUP1 PUSH [tag] 215
*)
Compute ( "BottleCastle_run_code_of_0_block_240_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 4 (NToWord WLen 0x1ffc9a7%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 28 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff%N);Opcode NOT;DUP 4;Opcode AND;Opcode EQ;DUP 1;PUSH 1 (NToWord WLen 0xd7%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 4 (NToWord WLen 0x1FFC9A7%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;DUP 3;PUSH 28 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode NOT;Opcode AND;Opcode EQ;DUP 1;PUSH 1 (NToWord WLen 0xd7%N)] 1 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_244_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: DUP1 PUSH 10 PUSH 0 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1
 O: DUP1 PUSH 10 DUP2 ISZERO PUSH 0 PUSH 100 EXP PUSH ff DUP2 MUL NOT DUP4 SLOAD AND SWAP2 ISZERO MUL OR SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_246_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x10%N);DUP 2;Opcode ISZERO;PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;PUSH 1 (NToWord WLen 0xff%N);DUP 2;Opcode MUL;Opcode NOT;DUP 4;Opcode SLOAD;Opcode AND;SWAP 2;Opcode ISZERO;Opcode MUL;Opcode OR;SWAP 1] [DUP 1;PUSH 1 (NToWord WLen 0x10%N);PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 1 (NToWord WLen 0xFF%N);Opcode MUL;Opcode NOT;Opcode AND;SWAP 1;DUP 4;Opcode ISZERO;Opcode ISZERO;Opcode MUL;Opcode OR;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 60 PUSH 2 DUP1 SLOAD PUSH [tag] 222 SWAP1 PUSH [tag] 223
 O: PUSH 60 PUSH 2 PUSH [tag] 222 DUP2 SLOAD PUSH [tag] 223
*)
Compute ( "BottleCastle_run_code_of_0_block_247_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0xde%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x2%N);DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xde%N);SWAP 1;PUSH 1 (NToWord WLen 0xdf%N)] 0 optimize_id) ).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute ( "BottleCastle_run_code_of_0_block_248_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x1f%N);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;SWAP 2;Opcode DIV;Opcode MUL;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 1 optimize_id) ).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute ( "BottleCastle_run_code_of_0_block_248_1"%string, (equiv_checker [SWAP 2;SWAP 1;DUP 3;DUP 2;DUP 5] [DUP 1;SWAP 3;SWAP 2;SWAP 1;DUP 2;DUP 2] 3 optimize_id) ).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 224 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 224 DUP5 SLOAD PUSH [tag] 223
*)
Compute ( "BottleCastle_run_code_of_0_block_248_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;PUSH 1 (NToWord WLen 0xe0%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xe0%N);SWAP 1;PUSH 1 (NToWord WLen 0xdf%N)] 3 optimize_id) ).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute ( "BottleCastle_run_code_of_0_block_254_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);DUP 4;DUP 5;SWAP 3;Opcode SUB;Opcode AND;Opcode ADD;SWAP 2] [DUP 3;SWAP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x1F%N);Opcode AND;DUP 3;Opcode ADD;SWAP 2] 3 optimize_id) ).

(*
 I: POP POP POP POP POP SWAP1 POP SWAP1
 O: POP POP POP POP POP SWAP2 SWAP1 POP
*)
Compute ( "BottleCastle_run_code_of_0_block_255_0"%string, (equiv_checker [POP;POP;POP;POP;POP;SWAP 2;SWAP 1;POP] [POP;POP;POP;POP;POP;SWAP 1;POP;SWAP 1] 8 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_258_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 ADD PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 SWAP2 POP ADD PUSH 0 SWAP1 DUP2 DUP1 PUSH 100 EXP SWAP4 POP KECCAK256 ADD SLOAD DIV PUSH ffffffffffffffffffffffffffffffffffffffff AND SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_259_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);SWAP 2;POP;Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);SWAP 1;DUP 2;DUP 1;PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;SWAP 4;POP;Opcode KECCAK256;Opcode ADD;Opcode SLOAD;Opcode DIV;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);SWAP 1;Opcode SLOAD;SWAP 1;PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;SWAP 1;Opcode DIV;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH C DUP1 SLOAD PUSH [tag] 232 SWAP1 PUSH [tag] 223
 O: PUSH c PUSH [tag] 232 DUP2 SLOAD PUSH [tag] 223
*)
Compute ( "BottleCastle_run_code_of_0_block_260_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0xc%N);PUSH 1 (NToWord WLen 0xe8%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0xC%N);DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xe8%N);SWAP 1;PUSH 1 (NToWord WLen 0xdf%N)] 0 optimize_id) ).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute ( "BottleCastle_run_code_of_0_block_261_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x1f%N);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;SWAP 2;Opcode DIV;Opcode MUL;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 1 optimize_id) ).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute ( "BottleCastle_run_code_of_0_block_261_1"%string, (equiv_checker [SWAP 2;SWAP 1;DUP 3;DUP 2;DUP 5] [DUP 1;SWAP 3;SWAP 2;SWAP 1;DUP 2;DUP 2] 3 optimize_id) ).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 233 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 233 DUP5 SLOAD PUSH [tag] 223
*)
Compute ( "BottleCastle_run_code_of_0_block_261_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;PUSH 1 (NToWord WLen 0xe9%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xe9%N);SWAP 1;PUSH 1 (NToWord WLen 0xdf%N)] 3 optimize_id) ).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute ( "BottleCastle_run_code_of_0_block_267_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);DUP 4;DUP 5;SWAP 3;Opcode SUB;Opcode AND;Opcode ADD;SWAP 2] [DUP 3;SWAP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x1F%N);Opcode AND;DUP 3;Opcode ADD;SWAP 2] 3 optimize_id) ).

(*
 I: SWAP1 POP DUP1 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH [tag] 239 PUSH [tag] 240
 O: DUP1 SWAP2 POP PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH [tag] 239 PUSH [tag] 240
*)
Compute ( "BottleCastle_run_code_of_0_block_270_0"%string, (equiv_checker [DUP 1;SWAP 2;POP;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;PUSH 1 (NToWord WLen 0xef%N);PUSH 1 (NToWord WLen 0xf0%N)] [SWAP 1;POP;DUP 1;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 1 (NToWord WLen 0xef%N);PUSH 1 (NToWord WLen 0xf0%N)] 2 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_275_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 ADD PUSH 0 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF MUL NOT AND SWAP1 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND MUL OR SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 ADD PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 PUSH 100 EXP DUP3 SLOAD DUP2 DUP4 MUL NOT AND SWAP2 DUP5 AND MUL OR SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_277_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;DUP 3;Opcode SLOAD;DUP 2;DUP 4;Opcode MUL;Opcode NOT;Opcode AND;SWAP 2;DUP 5;Opcode AND;Opcode MUL;Opcode OR;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode MUL;Opcode NOT;Opcode AND;SWAP 1;DUP 4;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;Opcode MUL;Opcode OR;SWAP 1] 2 optimize_id) ).

(*
 I: POP DUP2 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B925 PUSH 40 MLOAD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: POP PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 40 MLOAD DUP5 DUP3 AND PUSH 8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925 DUP3 DUP1 SUB DUP6 DUP8 SWAP6 AND SWAP3 SWAP4
*)
Compute ( "BottleCastle_run_code_of_0_block_277_3"%string, (equiv_checker [POP;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 5;DUP 3;Opcode AND;PUSH 32 (NToWord WLen 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925%N);DUP 3;DUP 1;Opcode SUB;DUP 6;DUP 8;SWAP 6;Opcode AND;SWAP 3;SWAP 4] [POP;DUP 2;DUP 4;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 3;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 32 (NToWord WLen 0x8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B925%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 4 optimize_id) ).

(*
 I: PUSH 1 SLOAD PUSH 0 SLOAD SUB SUB SWAP1 POP SWAP1
 O: PUSH 1 SLOAD PUSH 0 SLOAD SUB SUB SWAP2 SWAP1 POP
*)
Compute ( "BottleCastle_run_code_of_0_block_280_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;Opcode SUB;Opcode SUB;SWAP 2;SWAP 1;POP] [PUSH 1 (NToWord WLen 0x1%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;Opcode SUB;Opcode SUB;SWAP 1;POP;SWAP 1] 3 optimize_id) ).

(*
 I: SWAP1 POP DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ PUSH [tag] 251
 O: SWAP1 POP DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 AND EQ PUSH [tag] 251
*)
Compute ( "BottleCastle_run_code_of_0_block_282_0"%string, (equiv_checker [SWAP 1;POP;DUP 4;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 3;Opcode AND;Opcode EQ;PUSH 1 (NToWord WLen 0xfb%N)] [SWAP 1;POP;DUP 4;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 2;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;Opcode EQ;PUSH 1 (NToWord WLen 0xfb%N)] 5 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_283_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_291_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 261
 O: PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 AND PUSH ffffffffffffffffffffffffffffffffffffffff DUP7 AND EQ ISZERO PUSH [tag] 261
*)
Compute ( "BottleCastle_run_code_of_0_block_293_0"%string, (equiv_checker [PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);PUSH 1 (NToWord WLen 0x0%N);Opcode AND;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 7;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x105%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 6;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x105%N)] 5 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_294_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 5 PUSH 0 DUP8 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 5 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP9 AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Compute ( "BottleCastle_run_code_of_0_block_298_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 9;Opcode AND;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x0%N);DUP 8;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 2] 6 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP2 SLOAD PUSH 1 SWAP1 SUB SWAP2 SWAP1 POP DUP2 SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 1 DUP2 SLOAD SUB DUP1 SWAP2
*)
Compute ( "BottleCastle_run_code_of_0_block_298_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x1%N);DUP 2;Opcode SLOAD;Opcode SUB;DUP 1;SWAP 2] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);SWAP 1;Opcode SUB;SWAP 2;SWAP 1;POP;DUP 2;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP2 SLOAD PUSH 1 ADD SWAP2 SWAP1 POP DUP2 SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 1 DUP2 SLOAD ADD DUP1 SWAP2
*)
Compute ( "BottleCastle_run_code_of_0_block_298_5"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x1%N);DUP 2;Opcode SLOAD;Opcode ADD;DUP 1;SWAP 2] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;SWAP 2;SWAP 1;POP;DUP 2;SWAP 1] 1 optimize_id) ).

(*
 I: POP PUSH [tag] 265 DUP6 PUSH [tag] 266 DUP9 DUP9 DUP8 PUSH [tag] 267
 O: POP PUSH [tag] 265 DUP6 PUSH [tag] 266 DUP9 DUP3 DUP8 PUSH [tag] 267
*)
Compute ( "BottleCastle_run_code_of_0_block_298_6"%string, (equiv_checker [POP;PUSH 2 (NToWord WLen 0x109%N);DUP 6;PUSH 2 (NToWord WLen 0x10a%N);DUP 9;DUP 3;DUP 8;PUSH 2 (NToWord WLen 0x10b%N)] [POP;PUSH 2 (NToWord WLen 0x109%N);DUP 6;PUSH 2 (NToWord WLen 0x10a%N);DUP 9;DUP 9;DUP 8;PUSH 2 (NToWord WLen 0x10b%N)] 7 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 DUP2 SWAP1
 O: DUP2 SWAP1 PUSH 20 ADD PUSH 0 KECCAK256
*)
Compute ( "BottleCastle_run_code_of_0_block_300_2"%string, (equiv_checker [DUP 2;SWAP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 2;SWAP 1] 2 optimize_id) ).

(*
 I: POP PUSH 0 PUSH 200000000000000000000000000000000000000000000000000000000 DUP5 AND EQ ISZERO PUSH [tag] 269
 O: POP PUSH 200000000000000000000000000000000000000000000000000000000 DUP4 AND PUSH 0 EQ ISZERO PUSH [tag] 269
*)
Compute ( "BottleCastle_run_code_of_0_block_300_3"%string, (equiv_checker [POP;PUSH 29 (NToWord WLen 0x200000000000000000000000000000000000000000000000000000000%N);DUP 4;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x10d%N)] [POP;PUSH 1 (NToWord WLen 0x0%N);PUSH 29 (NToWord WLen 0x200000000000000000000000000000000000000000000000000000000%N);DUP 5;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x10d%N)] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH 1 DUP6 ADD SWAP1 POP PUSH 0 PUSH 4 PUSH 0 DUP4 DUP2
 O: DUP4 PUSH 1 ADD PUSH 0 PUSH 4 DUP2 DUP4 DUP4
*)
Compute ( "BottleCastle_run_code_of_0_block_301_0"%string, (equiv_checker [DUP 4;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x4%N);DUP 2;DUP 4;DUP 4] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x1%N);DUP 6;Opcode ADD;SWAP 1;POP;PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 2] 4 optimize_id) ).

(*
 I: PUSH 0 SLOAD DUP2 EQ PUSH [tag] 271
 O: DUP1 PUSH 0 SLOAD EQ PUSH [tag] 271
*)
Compute ( "BottleCastle_run_code_of_0_block_302_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;Opcode EQ;PUSH 2 (NToWord WLen 0x10f%N)] [PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 2;Opcode EQ;PUSH 2 (NToWord WLen 0x10f%N)] 1 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 DUP2 SWAP1
 O: DUP2 SWAP1 PUSH 20 ADD PUSH 0 KECCAK256
*)
Compute ( "BottleCastle_run_code_of_0_block_303_2"%string, (equiv_checker [DUP 2;SWAP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 2;SWAP 1] 2 optimize_id) ).

(*
 I: DUP4 DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP8 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH DDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF PUSH 40 MLOAD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH ffffffffffffffffffffffffffffffffffffffff DUP1 DUP7 AND DUP8 PUSH 40 MLOAD SWAP3 AND PUSH ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef DUP4 DUP1 SUB DUP9 SWAP5
*)
Compute ( "BottleCastle_run_code_of_0_block_306_0"%string, (equiv_checker [PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 1;DUP 7;Opcode AND;DUP 8;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 3;Opcode AND;PUSH 32 (NToWord WLen 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef%N);DUP 4;DUP 1;Opcode SUB;DUP 9;SWAP 5] [DUP 4;DUP 6;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 8;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 32 (NToWord WLen 0xDDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 6 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH [tag] 278 SWAP1 PUSH [tag] 279
 O: PUSH [tag] 278 SWAP1 PUSH 4 ADD PUSH [tag] 279
*)
Compute ( "BottleCastle_run_code_of_0_block_310_1"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x116%N);SWAP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x117%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N);SWAP 1;PUSH 2 (NToWord WLen 0x117%N)] 1 optimize_id) ).

(*
 I: PUSH 2 PUSH 9 DUP2 SWAP1
 O: PUSH 2 DUP1 PUSH 9
*)
Compute ( "BottleCastle_run_code_of_0_block_312_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x2%N);DUP 1;PUSH 1 (NToWord WLen 0x9%N)] [PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0x9%N);DUP 2;SWAP 1] 0 optimize_id) ).

(*
 I: POP PUSH 0 SELFBALANCE SWAP1 POP PUSH [tag] 281 PUSH [tag] 240
 O: POP SELFBALANCE PUSH [tag] 281 PUSH [tag] 240
*)
Compute ( "BottleCastle_run_code_of_0_block_312_1"%string, (equiv_checker [POP;Opcode SELFBALANCE;PUSH 2 (NToWord WLen 0x119%N);PUSH 1 (NToWord WLen 0xf0%N)] [POP;PUSH 1 (NToWord WLen 0x0%N);Opcode SELFBALANCE;SWAP 1;POP;PUSH 2 (NToWord WLen 0x119%N);PUSH 1 (NToWord WLen 0xf0%N)] 1 optimize_id) ).

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 8FC DUP3 SWAP1 DUP2 ISZERO MUL SWAP1 PUSH 40 MLOAD PUSH 0 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 DUP6 DUP9 DUP9
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH 0 DUP3 DUP4 ISZERO PUSH 8fc PUSH 40 MLOAD SWAP2 MUL SWAP3 DUP2 DUP1 DUP4 SUB DUP4 DUP6 DUP9 DUP9
*)
Compute ( "BottleCastle_run_code_of_0_block_313_0"%string, (equiv_checker [PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 4;Opcode ISZERO;PUSH 2 (NToWord WLen 0x8fc%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 2;Opcode MUL;SWAP 3;DUP 2;DUP 1;DUP 4;Opcode SUB;DUP 4;DUP 6;DUP 9;DUP 9] [PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 2 (NToWord WLen 0x8FC%N);DUP 3;SWAP 1;DUP 2;Opcode ISZERO;Opcode MUL;SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;DUP 6;DUP 9;DUP 9] 2 optimize_id) ).

(*
 I: POP POP PUSH 1 PUSH 9 DUP2 SWAP1
 O: POP POP PUSH 1 DUP1 PUSH 9
*)
Compute ( "BottleCastle_run_code_of_0_block_315_0"%string, (equiv_checker [POP;POP;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0x9%N)] [POP;POP;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x9%N);DUP 2;SWAP 1] 2 optimize_id) ).

(*
 I: PUSH [tag] 285 DUP4 DUP4 DUP4 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH [tag] 285 DUP4 DUP4 DUP4 PUSH 40 MLOAD PUSH 20 DUP2 ADD PUSH 40
*)
Compute ( "BottleCastle_run_code_of_0_block_316_0"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x11d%N);DUP 4;DUP 4;DUP 4;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [PUSH 2 (NToWord WLen 0x11d%N);DUP 4;DUP 4;DUP 4;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 3 optimize_id) ).

(*
 I: DUP1 PUSH D DUP2 SWAP1
 O: DUP1 DUP1 PUSH d
*)
Compute ( "BottleCastle_run_code_of_0_block_319_0"%string, (equiv_checker [DUP 1;DUP 1;PUSH 1 (NToWord WLen 0xd%N)] [DUP 1;PUSH 1 (NToWord WLen 0xD%N);DUP 2;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 10 PUSH 1 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FF AND DUP2
 O: PUSH 1 PUSH 100 EXP PUSH 10 SLOAD DIV PUSH ff AND DUP2
*)
Compute ( "BottleCastle_run_code_of_0_block_320_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;Opcode DIV;PUSH 1 (NToWord WLen 0xff%N);Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x10%N);PUSH 1 (NToWord WLen 0x1%N);SWAP 1;Opcode SLOAD;SWAP 1;PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;SWAP 1;Opcode DIV;PUSH 1 (NToWord WLen 0xFF%N);Opcode AND;DUP 2] 1 optimize_id) ).

(*
 I: DUP1 PUSH A SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 292 SWAP3 SWAP2 SWAP1 PUSH [tag] 293
 O: PUSH [tag] 292 PUSH a PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 293
*)
Compute ( "BottleCastle_run_code_of_0_block_322_0"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x124%N);PUSH 1 (NToWord WLen 0xa%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 2 (NToWord WLen 0x125%N)] [DUP 1;PUSH 1 (NToWord WLen 0xA%N);SWAP 1;DUP 1;Opcode MLOAD;SWAP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1;PUSH 2 (NToWord WLen 0x124%N);SWAP 3;SWAP 2;SWAP 1;PUSH 2 (NToWord WLen 0x125%N)] 1 optimize_id) ).

(*
 I: PUSH 10 PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FF AND DUP2
 O: PUSH 0 PUSH 100 EXP PUSH 10 SLOAD DIV PUSH ff AND DUP2
*)
Compute ( "BottleCastle_run_code_of_0_block_324_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;Opcode DIV;PUSH 1 (NToWord WLen 0xff%N);Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x10%N);PUSH 1 (NToWord WLen 0x0%N);SWAP 1;Opcode SLOAD;SWAP 1;PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;SWAP 1;Opcode DIV;PUSH 1 (NToWord WLen 0xFF%N);Opcode AND;DUP 2] 1 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_326_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH A DUP1 SLOAD PUSH [tag] 296 SWAP1 PUSH [tag] 223
 O: PUSH a PUSH [tag] 296 DUP2 SLOAD PUSH [tag] 223
*)
Compute ( "BottleCastle_run_code_of_0_block_327_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0xa%N);PUSH 2 (NToWord WLen 0x128%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0xA%N);DUP 1;Opcode SLOAD;PUSH 2 (NToWord WLen 0x128%N);SWAP 1;PUSH 1 (NToWord WLen 0xdf%N)] 0 optimize_id) ).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute ( "BottleCastle_run_code_of_0_block_328_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x1f%N);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;SWAP 2;Opcode DIV;Opcode MUL;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 1 optimize_id) ).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute ( "BottleCastle_run_code_of_0_block_328_1"%string, (equiv_checker [SWAP 2;SWAP 1;DUP 3;DUP 2;DUP 5] [DUP 1;SWAP 3;SWAP 2;SWAP 1;DUP 2;DUP 2] 3 optimize_id) ).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 297 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 297 DUP5 SLOAD PUSH [tag] 223
*)
Compute ( "BottleCastle_run_code_of_0_block_328_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;PUSH 2 (NToWord WLen 0x129%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (NToWord WLen 0x129%N);SWAP 1;PUSH 1 (NToWord WLen 0xdf%N)] 3 optimize_id) ).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute ( "BottleCastle_run_code_of_0_block_334_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);DUP 4;DUP 5;SWAP 3;Opcode SUB;Opcode AND;Opcode ADD;SWAP 2] [DUP 3;SWAP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x1F%N);Opcode AND;DUP 3;Opcode ADD;SWAP 2] 3 optimize_id) ).

(*
 I: PUSH 0 DUP1 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 302
 O: PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 AND DUP2 PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ ISZERO PUSH [tag] 302
*)
Compute ( "BottleCastle_run_code_of_0_block_336_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 3;Opcode AND;DUP 2;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x12e%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 3;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x12e%N)] 1 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_337_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_338_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;Opcode SLOAD;Opcode AND;SWAP 2;POP;POP;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;Opcode SLOAD;Opcode AND;SWAP 1;POP;SWAP 2;SWAP 1;POP] 5 optimize_id) ).

(*
 I: PUSH 60 PUSH 0 DUP1 PUSH 0 PUSH [tag] 309 DUP6 PUSH [tag] 129
 O: PUSH 60 PUSH 0 DUP1 DUP1 PUSH [tag] 309 DUP6 PUSH [tag] 129
*)
Compute ( "BottleCastle_run_code_of_0_block_342_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 1;PUSH 2 (NToWord WLen 0x135%N);DUP 6;PUSH 1 (NToWord WLen 0x81%N)] [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x135%N);DUP 6;PUSH 1 (NToWord WLen 0x81%N)] 1 optimize_id) ).

(*
 I: PUSH 40 MLOAD SWAP1 DUP1 DUP3
 O: DUP1 PUSH 40 MLOAD SWAP2 DUP3
*)
Compute ( "BottleCastle_run_code_of_0_block_346_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 2;DUP 3] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1;DUP 1;DUP 3] 1 optimize_id) ).

(*
 I: DUP1 PUSH 20 MUL PUSH 20 ADD DUP3 ADD PUSH 40
 O: PUSH 20 DUP1 DUP3 MUL ADD DUP3 ADD PUSH 40
*)
Compute ( "BottleCastle_run_code_of_0_block_346_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 3;Opcode MUL;Opcode ADD;DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode MUL;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 2 optimize_id) ).

(*
 I: DUP2 PUSH 20 ADD PUSH 20 DUP3 MUL DUP1 CALLDATASIZE DUP4
 O: PUSH 20 DUP3 ADD DUP2 PUSH 20 MUL DUP1 CALLDATASIZE DUP4
*)
Compute ( "BottleCastle_run_code_of_0_block_347_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode MUL;DUP 1;Opcode CALLDATASIZE;DUP 4] [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode MUL;DUP 1;Opcode CALLDATASIZE;DUP 4] 2 optimize_id) ).

(*
 I: DUP1 DUP3 ADD SWAP2 POP POP SWAP1 POP
 O: ADD SWAP1 POP
*)
Compute ( "BottleCastle_run_code_of_0_block_347_1"%string, (equiv_checker [Opcode ADD;SWAP 1;POP] [DUP 1;DUP 3;Opcode ADD;SWAP 2;POP;POP;SWAP 1;POP] 3 optimize_id) ).

(*
 I: SWAP2 POP DUP2 PUSH 40 ADD MLOAD ISZERO PUSH [tag] 322
 O: SWAP2 POP PUSH 40 DUP3 ADD MLOAD ISZERO PUSH [tag] 322
*)
Compute ( "BottleCastle_run_code_of_0_block_353_0"%string, (equiv_checker [SWAP 2;POP;PUSH 1 (NToWord WLen 0x40%N);DUP 3;Opcode ADD;Opcode MLOAD;Opcode ISZERO;PUSH 2 (NToWord WLen 0x142%N)] [SWAP 2;POP;DUP 2;PUSH 1 (NToWord WLen 0x40%N);Opcode ADD;Opcode MLOAD;Opcode ISZERO;PUSH 2 (NToWord WLen 0x142%N)] 3 optimize_id) ).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH 0 ADD MLOAD PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ PUSH [tag] 323
 O: PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 PUSH 0 ADD MLOAD AND PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ PUSH [tag] 323
*)
Compute ( "BottleCastle_run_code_of_0_block_355_0"%string, (equiv_checker [PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 3;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;Opcode MLOAD;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;Opcode EQ;PUSH 2 (NToWord WLen 0x143%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 3;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;Opcode MLOAD;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;Opcode EQ;PUSH 2 (NToWord WLen 0x143%N)] 2 optimize_id) ).

(*
 I: DUP2 PUSH 0 ADD MLOAD SWAP5 POP
 O: PUSH 0 DUP3 ADD MLOAD SWAP5 POP
*)
Compute ( "BottleCastle_run_code_of_0_block_356_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;Opcode ADD;Opcode MLOAD;SWAP 5;POP] [DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;Opcode MLOAD;SWAP 5;POP] 5 optimize_id) ).

(*
 I: DUP8 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 324
 O: PUSH ffffffffffffffffffffffffffffffffffffffff DUP6 AND DUP9 PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ ISZERO PUSH [tag] 324
*)
Compute ( "BottleCastle_run_code_of_0_block_357_0"%string, (equiv_checker [PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 6;Opcode AND;DUP 9;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x144%N)] [DUP 8;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 6;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x144%N)] 8 optimize_id) ).

(*
 I: DUP1 DUP4 DUP8 DUP1 PUSH 1 ADD SWAP9 POP DUP2 MLOAD DUP2 LT PUSH [tag] 325
 O: DUP1 DUP4 PUSH 1 DUP9 ADD SWAP8 DUP2 MLOAD DUP2 LT PUSH [tag] 325
*)
Compute ( "BottleCastle_run_code_of_0_block_358_0"%string, (equiv_checker [DUP 1;DUP 4;PUSH 1 (NToWord WLen 0x1%N);DUP 9;Opcode ADD;SWAP 8;DUP 2;Opcode MLOAD;DUP 2;Opcode LT;PUSH 2 (NToWord WLen 0x145%N)] [DUP 1;DUP 4;DUP 8;DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;SWAP 9;POP;DUP 2;Opcode MLOAD;DUP 2;Opcode LT;PUSH 2 (NToWord WLen 0x145%N)] 6 optimize_id) ).

(*
 I: DUP1 PUSH 1 ADD SWAP1 POP PUSH [tag] 316
 O: PUSH 1 ADD PUSH [tag] 316
*)
Compute ( "BottleCastle_run_code_of_0_block_363_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 2 (NToWord WLen 0x13c%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x13c%N)] 1 optimize_id) ).

(*
 I: POP DUP2 SWAP6 POP POP POP POP POP POP SWAP2 SWAP1 POP
 O: POP POP SWAP5 POP POP POP POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_364_0"%string, (equiv_checker [POP;POP;SWAP 5;POP;POP;POP;POP;POP;SWAP 1] [POP;DUP 2;SWAP 6;POP;POP;POP;POP;POP;POP;SWAP 2;SWAP 1;POP] 9 optimize_id) ).

(*
 I: PUSH 0 PUSH 8 PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1 POP SWAP1
 O: PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 PUSH 100 EXP PUSH 8 SLOAD DIV AND SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_365_0"%string, (equiv_checker [PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;PUSH 1 (NToWord WLen 0x8%N);Opcode SLOAD;Opcode DIV;Opcode AND;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x8%N);PUSH 1 (NToWord WLen 0x0%N);SWAP 1;Opcode SLOAD;SWAP 1;PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;SWAP 1;Opcode DIV;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;SWAP 1;POP;SWAP 1] 1 optimize_id) ).

(*
 I: DUP1 PUSH 10 PUSH 1 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1
 O: DUP1 PUSH 10 DUP2 ISZERO PUSH 1 PUSH 100 EXP PUSH ff DUP2 MUL NOT DUP4 SLOAD AND SWAP2 ISZERO MUL OR SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_367_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x10%N);DUP 2;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;PUSH 1 (NToWord WLen 0xff%N);DUP 2;Opcode MUL;Opcode NOT;DUP 4;Opcode SLOAD;Opcode AND;SWAP 2;Opcode ISZERO;Opcode MUL;Opcode OR;SWAP 1] [DUP 1;PUSH 1 (NToWord WLen 0x10%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 1 (NToWord WLen 0xFF%N);Opcode MUL;Opcode NOT;Opcode AND;SWAP 1;DUP 4;Opcode ISZERO;Opcode ISZERO;Opcode MUL;Opcode OR;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 60 PUSH 3 DUP1 SLOAD PUSH [tag] 333 SWAP1 PUSH [tag] 223
 O: PUSH 60 PUSH 3 PUSH [tag] 333 DUP2 SLOAD PUSH [tag] 223
*)
Compute ( "BottleCastle_run_code_of_0_block_368_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x3%N);PUSH 2 (NToWord WLen 0x14d%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x3%N);DUP 1;Opcode SLOAD;PUSH 2 (NToWord WLen 0x14d%N);SWAP 1;PUSH 1 (NToWord WLen 0xdf%N)] 0 optimize_id) ).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute ( "BottleCastle_run_code_of_0_block_369_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x1f%N);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;SWAP 2;Opcode DIV;Opcode MUL;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 1 optimize_id) ).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute ( "BottleCastle_run_code_of_0_block_369_1"%string, (equiv_checker [SWAP 2;SWAP 1;DUP 3;DUP 2;DUP 5] [DUP 1;SWAP 3;SWAP 2;SWAP 1;DUP 2;DUP 2] 3 optimize_id) ).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 334 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 334 DUP5 SLOAD PUSH [tag] 223
*)
Compute ( "BottleCastle_run_code_of_0_block_369_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;PUSH 2 (NToWord WLen 0x14e%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (NToWord WLen 0x14e%N);SWAP 1;PUSH 1 (NToWord WLen 0xdf%N)] 3 optimize_id) ).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute ( "BottleCastle_run_code_of_0_block_375_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);DUP 4;DUP 5;SWAP 3;Opcode SUB;Opcode AND;Opcode ADD;SWAP 2] [DUP 3;SWAP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x1F%N);Opcode AND;DUP 3;Opcode ADD;SWAP 2] 3 optimize_id) ).

(*
 I: POP POP POP POP POP SWAP1 POP SWAP1
 O: POP POP POP POP POP SWAP2 SWAP1 POP
*)
Compute ( "BottleCastle_run_code_of_0_block_376_0"%string, (equiv_checker [POP;POP;POP;POP;POP;SWAP 2;SWAP 1;POP] [POP;POP;POP;POP;POP;SWAP 1;POP;SWAP 1] 8 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH [tag] 340 SWAP1 PUSH [tag] 279
 O: PUSH [tag] 340 SWAP1 PUSH 4 ADD PUSH [tag] 279
*)
Compute ( "BottleCastle_run_code_of_0_block_378_1"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x154%N);SWAP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x117%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x154%N);SWAP 1;PUSH 2 (NToWord WLen 0x117%N)] 1 optimize_id) ).

(*
 I: PUSH 2 PUSH 9 DUP2 SWAP1
 O: PUSH 2 DUP1 PUSH 9
*)
Compute ( "BottleCastle_run_code_of_0_block_380_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x2%N);DUP 1;PUSH 1 (NToWord WLen 0x9%N)] [PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0x9%N);DUP 2;SWAP 1] 0 optimize_id) ).

(*
 I: POP PUSH 10 PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FF AND ISZERO PUSH [tag] 342
 O: POP PUSH 0 PUSH 100 EXP PUSH 10 SLOAD DIV PUSH ff AND ISZERO PUSH [tag] 342
*)
Compute ( "BottleCastle_run_code_of_0_block_380_1"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;Opcode DIV;PUSH 1 (NToWord WLen 0xff%N);Opcode AND;Opcode ISZERO;PUSH 2 (NToWord WLen 0x156%N)] [POP;PUSH 1 (NToWord WLen 0x10%N);PUSH 1 (NToWord WLen 0x0%N);SWAP 1;Opcode SLOAD;SWAP 1;PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;SWAP 1;Opcode DIV;PUSH 1 (NToWord WLen 0xFF%N);Opcode AND;Opcode ISZERO;PUSH 2 (NToWord WLen 0x156%N)] 1 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH [tag] 343 SWAP1 PUSH [tag] 344
 O: PUSH [tag] 343 SWAP1 PUSH 4 ADD PUSH [tag] 344
*)
Compute ( "BottleCastle_run_code_of_0_block_381_1"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x157%N);SWAP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x158%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x157%N);SWAP 1;PUSH 2 (NToWord WLen 0x158%N)] 1 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH [tag] 346 SWAP1 PUSH [tag] 347
 O: PUSH [tag] 346 SWAP1 PUSH 4 ADD PUSH [tag] 347
*)
Compute ( "BottleCastle_run_code_of_0_block_384_1"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x15a%N);SWAP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x15b%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x15a%N);SWAP 1;PUSH 2 (NToWord WLen 0x15b%N)] 1 optimize_id) ).

(*
 I: PUSH [tag] 349 SWAP2 SWAP1 PUSH [tag] 350
 O: SWAP1 PUSH [tag] 349 SWAP2 PUSH [tag] 350
*)
Compute ( "BottleCastle_run_code_of_0_block_387_0"%string, (equiv_checker [SWAP 1;PUSH 2 (NToWord WLen 0x15d%N);SWAP 2;PUSH 2 (NToWord WLen 0x15e%N)] [PUSH 2 (NToWord WLen 0x15d%N);SWAP 2;SWAP 1;PUSH 2 (NToWord WLen 0x15e%N)] 2 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH [tag] 352 SWAP1 PUSH [tag] 353
 O: PUSH [tag] 352 SWAP1 PUSH 4 ADD PUSH [tag] 353
*)
Compute ( "BottleCastle_run_code_of_0_block_389_1"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x160%N);SWAP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x161%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x160%N);SWAP 1;PUSH 2 (NToWord WLen 0x161%N)] 1 optimize_id) ).

(*
 I: PUSH [tag] 357 SWAP2 SWAP1 PUSH [tag] 350
 O: SWAP1 PUSH [tag] 357 SWAP2 PUSH [tag] 350
*)
Compute ( "BottleCastle_run_code_of_0_block_393_0"%string, (equiv_checker [SWAP 1;PUSH 2 (NToWord WLen 0x165%N);SWAP 2;PUSH 2 (NToWord WLen 0x15e%N)] [PUSH 2 (NToWord WLen 0x165%N);SWAP 2;SWAP 1;PUSH 2 (NToWord WLen 0x15e%N)] 2 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH [tag] 359 SWAP1 PUSH [tag] 360
 O: PUSH [tag] 359 SWAP1 PUSH 4 ADD PUSH [tag] 360
*)
Compute ( "BottleCastle_run_code_of_0_block_395_1"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x167%N);SWAP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x168%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x167%N);SWAP 1;PUSH 2 (NToWord WLen 0x168%N)] 1 optimize_id) ).

(*
 I: DUP1 PUSH D SLOAD PUSH [tag] 361 SWAP2 SWAP1 PUSH [tag] 362
 O: PUSH [tag] 361 DUP2 PUSH d SLOAD PUSH [tag] 362
*)
Compute ( "BottleCastle_run_code_of_0_block_397_0"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x169%N);DUP 2;PUSH 1 (NToWord WLen 0xd%N);Opcode SLOAD;PUSH 2 (NToWord WLen 0x16a%N)] [DUP 1;PUSH 1 (NToWord WLen 0xD%N);Opcode SLOAD;PUSH 2 (NToWord WLen 0x169%N);SWAP 2;SWAP 1;PUSH 2 (NToWord WLen 0x16a%N)] 1 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH [tag] 364 SWAP1 PUSH [tag] 365
 O: PUSH [tag] 364 SWAP1 PUSH 4 ADD PUSH [tag] 365
*)
Compute ( "BottleCastle_run_code_of_0_block_399_1"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x16c%N);SWAP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x16d%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x16c%N);SWAP 1;PUSH 2 (NToWord WLen 0x16d%N)] 1 optimize_id) ).

(*
 I: PUSH 1 PUSH 9 DUP2 SWAP1
 O: PUSH 1 DUP1 PUSH 9
*)
Compute ( "BottleCastle_run_code_of_0_block_403_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0x9%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x9%N);DUP 2;SWAP 1] 0 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_406_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP5 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP1 DUP7 AND AND DUP2
*)
Compute ( "BottleCastle_run_code_of_0_block_408_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 1;DUP 7;Opcode AND;Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);DUP 5;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 2] 4 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH 100 EXP PUSH ff DUP2 DUP5 ISZERO ISZERO MUL SWAP2 MUL NOT DUP3 SLOAD AND OR SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_408_4"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;PUSH 1 (NToWord WLen 0xff%N);DUP 2;DUP 5;Opcode ISZERO;Opcode ISZERO;Opcode MUL;SWAP 2;Opcode MUL;Opcode NOT;DUP 3;Opcode SLOAD;Opcode AND;Opcode OR;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 1 (NToWord WLen 0xFF%N);Opcode MUL;Opcode NOT;Opcode AND;SWAP 1;DUP 4;Opcode ISZERO;Opcode ISZERO;Opcode MUL;Opcode OR;SWAP 1] 2 optimize_id) ).

(*
 I: POP DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH [tag] 373 PUSH [tag] 240
 O: POP PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 AND PUSH [tag] 373 PUSH [tag] 240
*)
Compute ( "BottleCastle_run_code_of_0_block_408_5"%string, (equiv_checker [POP;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 3;Opcode AND;PUSH 2 (NToWord WLen 0x175%N);PUSH 1 (NToWord WLen 0xf0%N)] [POP;DUP 2;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 2 (NToWord WLen 0x175%N);PUSH 1 (NToWord WLen 0xf0%N)] 3 optimize_id) ).

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C31 DUP4 PUSH 40 MLOAD PUSH [tag] 374 SWAP2 SWAP1 PUSH [tag] 52
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH 17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31 PUSH [tag] 374 DUP5 PUSH 40 MLOAD PUSH [tag] 52
*)
Compute ( "BottleCastle_run_code_of_0_block_409_0"%string, (equiv_checker [PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;PUSH 32 (NToWord WLen 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31%N);PUSH 2 (NToWord WLen 0x176%N);DUP 5;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x34%N)] [PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 32 (NToWord WLen 0x17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C31%N);DUP 4;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 2 (NToWord WLen 0x176%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x34%N)] 3 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_415_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH [tag] 385 SWAP1 PUSH [tag] 279
 O: PUSH [tag] 385 SWAP1 PUSH 4 ADD PUSH [tag] 279
*)
Compute ( "BottleCastle_run_code_of_0_block_420_1"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x181%N);SWAP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x117%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x181%N);SWAP 1;PUSH 2 (NToWord WLen 0x117%N)] 1 optimize_id) ).

(*
 I: PUSH 2 PUSH 9 DUP2 SWAP1
 O: PUSH 2 DUP1 PUSH 9
*)
Compute ( "BottleCastle_run_code_of_0_block_422_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x2%N);DUP 1;PUSH 1 (NToWord WLen 0x9%N)] [PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0x9%N);DUP 2;SWAP 1] 0 optimize_id) ).

(*
 I: PUSH [tag] 388 SWAP2 SWAP1 PUSH [tag] 350
 O: SWAP1 PUSH [tag] 388 SWAP2 PUSH [tag] 350
*)
Compute ( "BottleCastle_run_code_of_0_block_423_0"%string, (equiv_checker [SWAP 1;PUSH 2 (NToWord WLen 0x184%N);SWAP 2;PUSH 2 (NToWord WLen 0x15e%N)] [PUSH 2 (NToWord WLen 0x184%N);SWAP 2;SWAP 1;PUSH 2 (NToWord WLen 0x15e%N)] 2 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH [tag] 390 SWAP1 PUSH [tag] 391
 O: PUSH [tag] 390 SWAP1 PUSH 4 ADD PUSH [tag] 391
*)
Compute ( "BottleCastle_run_code_of_0_block_425_1"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x186%N);SWAP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x187%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x186%N);SWAP 1;PUSH 2 (NToWord WLen 0x187%N)] 1 optimize_id) ).

(*
 I: PUSH 1 PUSH 9 DUP2 SWAP1
 O: PUSH 1 DUP1 PUSH 9
*)
Compute ( "BottleCastle_run_code_of_0_block_428_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0x9%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x9%N);DUP 2;SWAP 1] 0 optimize_id) ).

(*
 I: PUSH B DUP1 SLOAD PUSH [tag] 393 SWAP1 PUSH [tag] 223
 O: PUSH b PUSH [tag] 393 DUP2 SLOAD PUSH [tag] 223
*)
Compute ( "BottleCastle_run_code_of_0_block_430_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0xb%N);PUSH 2 (NToWord WLen 0x189%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0xB%N);DUP 1;Opcode SLOAD;PUSH 2 (NToWord WLen 0x189%N);SWAP 1;PUSH 1 (NToWord WLen 0xdf%N)] 0 optimize_id) ).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute ( "BottleCastle_run_code_of_0_block_431_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x1f%N);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;SWAP 2;Opcode DIV;Opcode MUL;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 1 optimize_id) ).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute ( "BottleCastle_run_code_of_0_block_431_1"%string, (equiv_checker [SWAP 2;SWAP 1;DUP 3;DUP 2;DUP 5] [DUP 1;SWAP 3;SWAP 2;SWAP 1;DUP 2;DUP 2] 3 optimize_id) ).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 394 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 394 DUP5 SLOAD PUSH [tag] 223
*)
Compute ( "BottleCastle_run_code_of_0_block_431_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;PUSH 2 (NToWord WLen 0x18a%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (NToWord WLen 0x18a%N);SWAP 1;PUSH 1 (NToWord WLen 0xdf%N)] 3 optimize_id) ).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute ( "BottleCastle_run_code_of_0_block_437_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);DUP 4;DUP 5;SWAP 3;Opcode SUB;Opcode AND;Opcode ADD;SWAP 2] [DUP 3;SWAP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x1F%N);Opcode AND;DUP 3;Opcode ADD;SWAP 2] 3 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH [tag] 401 SWAP1 PUSH [tag] 402
 O: PUSH [tag] 401 SWAP1 PUSH 4 ADD PUSH [tag] 402
*)
Compute ( "BottleCastle_run_code_of_0_block_441_1"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x191%N);SWAP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x192%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x191%N);SWAP 1;PUSH 2 (NToWord WLen 0x192%N)] 1 optimize_id) ).

(*
 I: PUSH 0 ISZERO ISZERO PUSH 10 PUSH 1 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FF AND ISZERO ISZERO EQ ISZERO PUSH [tag] 403
 O: PUSH 1 PUSH 100 EXP PUSH 10 SLOAD DIV PUSH ff AND ISZERO ISZERO PUSH 0 ISZERO ISZERO EQ ISZERO PUSH [tag] 403
*)
Compute ( "BottleCastle_run_code_of_0_block_443_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;Opcode DIV;PUSH 1 (NToWord WLen 0xff%N);Opcode AND;Opcode ISZERO;Opcode ISZERO;PUSH 1 (NToWord WLen 0x0%N);Opcode ISZERO;Opcode ISZERO;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x193%N)] [PUSH 1 (NToWord WLen 0x0%N);Opcode ISZERO;Opcode ISZERO;PUSH 1 (NToWord WLen 0x10%N);PUSH 1 (NToWord WLen 0x1%N);SWAP 1;Opcode SLOAD;SWAP 1;PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;SWAP 1;Opcode DIV;PUSH 1 (NToWord WLen 0xFF%N);Opcode AND;Opcode ISZERO;Opcode ISZERO;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x193%N)] 0 optimize_id) ).

(*
 I: PUSH C DUP1 SLOAD PUSH [tag] 404 SWAP1 PUSH [tag] 223
 O: PUSH c PUSH [tag] 404 DUP2 SLOAD PUSH [tag] 223
*)
Compute ( "BottleCastle_run_code_of_0_block_444_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0xc%N);PUSH 2 (NToWord WLen 0x194%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0xC%N);DUP 1;Opcode SLOAD;PUSH 2 (NToWord WLen 0x194%N);SWAP 1;PUSH 1 (NToWord WLen 0xdf%N)] 0 optimize_id) ).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute ( "BottleCastle_run_code_of_0_block_445_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x1f%N);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;SWAP 2;Opcode DIV;Opcode MUL;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 1 optimize_id) ).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute ( "BottleCastle_run_code_of_0_block_445_1"%string, (equiv_checker [SWAP 2;SWAP 1;DUP 3;DUP 2;DUP 5] [DUP 1;SWAP 3;SWAP 2;SWAP 1;DUP 2;DUP 2] 3 optimize_id) ).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 405 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 405 DUP5 SLOAD PUSH [tag] 223
*)
Compute ( "BottleCastle_run_code_of_0_block_445_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;PUSH 2 (NToWord WLen 0x195%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (NToWord WLen 0x195%N);SWAP 1;PUSH 1 (NToWord WLen 0xdf%N)] 3 optimize_id) ).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute ( "BottleCastle_run_code_of_0_block_451_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);DUP 4;DUP 5;SWAP 3;Opcode SUB;Opcode AND;Opcode ADD;SWAP 2] [DUP 3;SWAP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x1F%N);Opcode AND;DUP 3;Opcode ADD;SWAP 2] 3 optimize_id) ).

(*
 I: PUSH B PUSH 40 MLOAD PUSH 20 ADD PUSH [tag] 415 SWAP4 SWAP3 SWAP2 SWAP1 PUSH [tag] 416
 O: PUSH [tag] 415 SWAP2 SWAP1 PUSH b PUSH 20 PUSH 40 MLOAD ADD PUSH [tag] 416
*)
Compute ( "BottleCastle_run_code_of_0_block_457_0"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x19f%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0xb%N);PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;Opcode ADD;PUSH 2 (NToWord WLen 0x1a0%N)] [PUSH 1 (NToWord WLen 0xB%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x19f%N);SWAP 4;SWAP 3;SWAP 2;SWAP 1;PUSH 2 (NToWord WLen 0x1a0%N)] 2 optimize_id) ).

(*
 I: DUP1 PUSH B SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 420 SWAP3 SWAP2 SWAP1 PUSH [tag] 293
 O: PUSH [tag] 420 PUSH b PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 293
*)
Compute ( "BottleCastle_run_code_of_0_block_463_0"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x1a4%N);PUSH 1 (NToWord WLen 0xb%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 2 (NToWord WLen 0x125%N)] [DUP 1;PUSH 1 (NToWord WLen 0xB%N);SWAP 1;DUP 1;Opcode MLOAD;SWAP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1;PUSH 2 (NToWord WLen 0x1a4%N);SWAP 3;SWAP 2;SWAP 1;PUSH 2 (NToWord WLen 0x125%N)] 1 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_466_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: DUP1 PUSH F DUP2 SWAP1
 O: DUP1 DUP1 PUSH f
*)
Compute ( "BottleCastle_run_code_of_0_block_468_0"%string, (equiv_checker [DUP 1;DUP 1;PUSH 1 (NToWord WLen 0xf%N)] [DUP 1;PUSH 1 (NToWord WLen 0xF%N);DUP 2;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 0 PUSH 7 PUSH 0 DUP5 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 0 PUSH 7 DUP2 DUP5 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Compute ( "BottleCastle_run_code_of_0_block_469_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x7%N);DUP 2;DUP 5;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x7%N);PUSH 1 (NToWord WLen 0x0%N);DUP 5;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 2] 2 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP5 DUP2 AND AND DUP2
*)
Compute ( "BottleCastle_run_code_of_0_block_469_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 5;DUP 2;Opcode AND;Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);DUP 4;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 2] 3 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FF AND SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP2 PUSH 0 SWAP4 POP POP POP PUSH 20 ADD DUP2 PUSH 100 EXP SWAP2 KECCAK256 SLOAD DIV PUSH ff AND SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_469_4"%string, (equiv_checker [SWAP 2;PUSH 1 (NToWord WLen 0x0%N);SWAP 4;POP;POP;POP;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;SWAP 2;Opcode KECCAK256;Opcode SLOAD;Opcode DIV;PUSH 1 (NToWord WLen 0xff%N);Opcode AND;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);SWAP 1;Opcode SLOAD;SWAP 1;PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;SWAP 1;Opcode DIV;PUSH 1 (NToWord WLen 0xFF%N);Opcode AND;SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 5 optimize_id) ).

(*
 I: DUP1 PUSH C SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 430 SWAP3 SWAP2 SWAP1 PUSH [tag] 293
 O: PUSH [tag] 430 PUSH c PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 293
*)
Compute ( "BottleCastle_run_code_of_0_block_471_0"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x1ae%N);PUSH 1 (NToWord WLen 0xc%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 2 (NToWord WLen 0x125%N)] [DUP 1;PUSH 1 (NToWord WLen 0xC%N);SWAP 1;DUP 1;Opcode MLOAD;SWAP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1;PUSH 2 (NToWord WLen 0x1ae%N);SWAP 3;SWAP 2;SWAP 1;PUSH 2 (NToWord WLen 0x125%N)] 1 optimize_id) ).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 434
 O: DUP1 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 AND EQ ISZERO PUSH [tag] 434
*)
Compute ( "BottleCastle_run_code_of_0_block_474_0"%string, (equiv_checker [DUP 1;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);PUSH 1 (NToWord WLen 0x0%N);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1b2%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 2;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1b2%N)] 1 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH [tag] 435 SWAP1 PUSH [tag] 436
 O: PUSH [tag] 435 SWAP1 PUSH 4 ADD PUSH [tag] 436
*)
Compute ( "BottleCastle_run_code_of_0_block_475_1"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x1b3%N);SWAP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x1b4%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x1b3%N);SWAP 1;PUSH 2 (NToWord WLen 0x1b4%N)] 1 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH [tag] 443 SWAP1 PUSH [tag] 444
 O: PUSH [tag] 443 SWAP1 PUSH 4 ADD PUSH [tag] 444
*)
Compute ( "BottleCastle_run_code_of_0_block_482_1"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x1bb%N);SWAP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x1bc%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x1bb%N);SWAP 1;PUSH 2 (NToWord WLen 0x1bc%N)] 1 optimize_id) ).

(*
 I: POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 PUSH 4 PUSH 0 DUP6 DUP2
 O: POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 PUSH 4 DUP3 DUP6 DUP2
*)
Compute ( "BottleCastle_run_code_of_0_block_489_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x0%N);PUSH 29 (NToWord WLen 0x100000000000000000000000000000000000000000000000000000000%N);PUSH 1 (NToWord WLen 0x4%N);DUP 3;DUP 6;DUP 2] [POP;PUSH 1 (NToWord WLen 0x0%N);PUSH 29 (NToWord WLen 0x100000000000000000000000000000000000000000000000000000000%N);PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x0%N);DUP 6;DUP 2] 3 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_490_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 CALLER SWAP1 POP SWAP1
 O: CALLER SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_491_0"%string, (equiv_checker [Opcode CALLER;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);Opcode CALLER;SWAP 1;POP;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 0 PUSH 1 SWAP1 POP SWAP1
 O: PUSH 1 SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_492_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x1%N);SWAP 1;POP;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 0 DUP1 DUP3 SWAP1 POP DUP1 PUSH [tag] 452 PUSH [tag] 247
 O: PUSH 0 DUP2 DUP1 PUSH [tag] 452 PUSH [tag] 247
*)
Compute ( "BottleCastle_run_code_of_0_block_493_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 1;PUSH 2 (NToWord WLen 0x1c4%N);PUSH 1 (NToWord WLen 0xf7%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 3;SWAP 1;POP;DUP 1;PUSH 2 (NToWord WLen 0x1c4%N);PUSH 1 (NToWord WLen 0xf7%N)] 1 optimize_id) ).

(*
 I: PUSH 0 PUSH 4 PUSH 0 DUP4 DUP2
 O: PUSH 0 PUSH 4 DUP2 DUP4 DUP2
*)
Compute ( "BottleCastle_run_code_of_0_block_496_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x4%N);DUP 2;DUP 4;DUP 2] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 2] 1 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD SWAP1 POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 DUP3 AND EQ ISZERO PUSH [tag] 455
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD PUSH 100000000000000000000000000000000000000000000000000000000 DUP2 SWAP3 POP AND PUSH 0 EQ ISZERO PUSH [tag] 455
*)
Compute ( "BottleCastle_run_code_of_0_block_496_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;Opcode SLOAD;PUSH 29 (NToWord WLen 0x100000000000000000000000000000000000000000000000000000000%N);DUP 2;SWAP 3;POP;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1c7%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;Opcode SLOAD;SWAP 1;POP;PUSH 1 (NToWord WLen 0x0%N);PUSH 29 (NToWord WLen 0x100000000000000000000000000000000000000000000000000000000%N);DUP 3;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1c7%N)] 2 optimize_id) ).

(*
 I: PUSH 0 DUP2 EQ ISZERO PUSH [tag] 457
 O: DUP1 PUSH 0 EQ ISZERO PUSH [tag] 457
*)
Compute ( "BottleCastle_run_code_of_0_block_497_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x0%N);Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1c9%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1c9%N)] 1 optimize_id) ).

(*
 I: PUSH 4 PUSH 0 DUP4 PUSH 1 SWAP1 SUB SWAP4 POP DUP4 DUP2
 O: PUSH 1 PUSH 4 SWAP3 SUB SWAP2 PUSH 0 DUP4 DUP2
*)
Compute ( "BottleCastle_run_code_of_0_block_498_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x4%N);SWAP 3;Opcode SUB;SWAP 2;PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 2] [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x0%N);DUP 4;PUSH 1 (NToWord WLen 0x1%N);SWAP 1;Opcode SUB;SWAP 4;POP;DUP 4;DUP 2] 2 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD SWAP1 POP PUSH [tag] 456
 O: SWAP1 POP PUSH 20 ADD PUSH 0 KECCAK256 SLOAD PUSH [tag] 456
*)
Compute ( "BottleCastle_run_code_of_0_block_498_2"%string, (equiv_checker [SWAP 1;POP;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;Opcode SLOAD;PUSH 2 (NToWord WLen 0x1c8%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;Opcode SLOAD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x1c8%N)] 2 optimize_id) ).

(*
 I: DUP1 SWAP3 POP POP POP PUSH [tag] 451
 O: SWAP2 POP POP PUSH [tag] 451
*)
Compute ( "BottleCastle_run_code_of_0_block_499_0"%string, (equiv_checker [SWAP 2;POP;POP;PUSH 2 (NToWord WLen 0x1c3%N)] [DUP 1;SWAP 3;POP;POP;POP;PUSH 2 (NToWord WLen 0x1c3%N)] 3 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_502_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 0 DUP1 PUSH 0 PUSH 6 PUSH 0 DUP6 DUP2
 O: PUSH 0 DUP1 DUP1 PUSH 6 DUP2 DUP6 DUP2
*)
Compute ( "BottleCastle_run_code_of_0_block_504_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 1;PUSH 1 (NToWord WLen 0x6%N);DUP 2;DUP 6;DUP 2] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x6%N);PUSH 1 (NToWord WLen 0x0%N);DUP 6;DUP 2] 1 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SWAP1 POP DUP1 SWAP3 POP DUP3 SLOAD SWAP2 POP POP SWAP2 POP SWAP2
 O: SWAP1 POP SWAP2 POP SWAP2 POP PUSH 20 ADD SWAP1 POP PUSH 0 KECCAK256 SWAP1 DUP2 SLOAD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_504_2"%string, (equiv_checker [SWAP 1;POP;SWAP 2;POP;SWAP 2;POP;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1;POP;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;SWAP 1;DUP 2;Opcode SLOAD;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;SWAP 1;POP;DUP 1;SWAP 3;POP;DUP 3;Opcode SLOAD;SWAP 2;POP;POP;SWAP 2;POP;SWAP 2] 6 optimize_id) ).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP4 AND SWAP3 POP PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP3 AND SWAP2 POP DUP4 DUP3 EQ DUP4 DUP4 EQ OR SWAP1 POP SWAP4 SWAP3 POP POP POP
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP1 DUP2 SWAP3 SWAP3 DUP5 EQ SWAP4 POP SWAP3 DUP5 SWAP3 PUSH ffffffffffffffffffffffffffffffffffffffff AND SWAP3 POP SWAP3 POP EQ OR SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_505_0"%string, (equiv_checker [PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;DUP 1;DUP 2;SWAP 3;SWAP 3;DUP 5;Opcode EQ;SWAP 4;POP;SWAP 3;DUP 5;SWAP 3;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;SWAP 3;POP;SWAP 3;POP;Opcode EQ;Opcode OR;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);DUP 4;Opcode AND;SWAP 3;POP;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);DUP 3;Opcode AND;SWAP 2;POP;DUP 4;DUP 3;Opcode EQ;DUP 4;DUP 4;Opcode EQ;Opcode OR;SWAP 1;POP;SWAP 4;SWAP 3;POP;POP;POP] 4 optimize_id) ).

(*
 I: PUSH 0 DUP1 PUSH E8 DUP4 SWAP1 SHR SWAP1 POP PUSH E8 PUSH [tag] 462 DUP7 DUP7 DUP5 PUSH [tag] 463
 O: PUSH 0 PUSH [tag] 463 PUSH e8 PUSH [tag] 462 DUP7 DUP7 DUP7 DUP5 SHR DUP1 SWAP6
*)
Compute ( "BottleCastle_run_code_of_0_block_507_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x1cf%N);PUSH 1 (NToWord WLen 0xe8%N);PUSH 2 (NToWord WLen 0x1ce%N);DUP 7;DUP 7;DUP 7;DUP 5;Opcode SHR;DUP 1;SWAP 6] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0xE8%N);DUP 4;SWAP 1;Opcode SHR;SWAP 1;POP;PUSH 1 (NToWord WLen 0xE8%N);PUSH 2 (NToWord WLen 0x1ce%N);DUP 7;DUP 7;DUP 5;PUSH 2 (NToWord WLen 0x1cf%N)] 3 optimize_id) ).

(*
 I: PUSH FFFFFF AND SWAP1 SHL SWAP2 POP POP SWAP4 SWAP3 POP POP POP
 O: PUSH ffffff AND SWAP6 POP SWAP4 POP POP POP POP SHL SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_508_0"%string, (equiv_checker [PUSH 3 (NToWord WLen 0xffffff%N);Opcode AND;SWAP 6;POP;SWAP 4;POP;POP;POP;POP;Opcode SHL;SWAP 1] [PUSH 3 (NToWord WLen 0xFFFFFF%N);Opcode AND;SWAP 1;Opcode SHL;SWAP 2;POP;POP;SWAP 4;SWAP 3;POP;POP;POP] 8 optimize_id) ).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP4 AND SWAP3 POP DUP2 TIMESTAMP PUSH A0 SHL OR DUP4 OR SWAP1 POP SWAP3 SWAP2 POP POP
 O: TIMESTAMP PUSH a0 SHL OR SWAP1 PUSH ffffffffffffffffffffffffffffffffffffffff AND OR SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_509_0"%string, (equiv_checker [Opcode TIMESTAMP;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode OR;SWAP 1;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;Opcode OR;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);DUP 4;Opcode AND;SWAP 3;POP;DUP 2;Opcode TIMESTAMP;PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode OR;DUP 4;Opcode OR;SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 3 optimize_id) ).

(*
 I: POP DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 8BE0079C531659141344CD1FD0A4F28419497F9722A3DAAFE3B4186F6B6457E0 PUSH 40 MLOAD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: POP PUSH 40 MLOAD DUP1 DUP1 SUB PUSH 8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP5 DUP2 AND SWAP3 SWAP1 DUP7 AND SWAP4
*)
Compute ( "BottleCastle_run_code_of_0_block_511_1"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 1;Opcode SUB;PUSH 32 (NToWord WLen 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0%N);PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 5;DUP 2;Opcode AND;SWAP 3;SWAP 1;DUP 7;Opcode AND;SWAP 4] [POP;DUP 2;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 2;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 32 (NToWord WLen 0x8BE0079C531659141344CD1FD0A4F28419497F9722A3DAAFE3B4186F6B6457E0%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 3 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_514_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFF PUSH 40 PUSH 5 PUSH 0 DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 0 PUSH ffffffffffffffff PUSH 40 PUSH 5 DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff DUP7 AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Compute ( "BottleCastle_run_code_of_0_block_515_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 8 (NToWord WLen 0xffffffffffffffff%N);PUSH 1 (NToWord WLen 0x40%N);PUSH 1 (NToWord WLen 0x5%N);DUP 4;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 7;Opcode AND;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x0%N);PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);PUSH 1 (NToWord WLen 0x40%N);PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x0%N);DUP 6;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 2] 1 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD SWAP1 SHR AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD SWAP1 SHR AND SWAP3 SWAP2 POP POP
*)
Compute ( "BottleCastle_run_code_of_0_block_515_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;Opcode SLOAD;SWAP 1;Opcode SHR;Opcode AND;SWAP 3;SWAP 2;POP;POP] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;Opcode SLOAD;SWAP 1;Opcode SHR;Opcode AND;SWAP 1;POP;SWAP 2;SWAP 1;POP] 6 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH [tag] 477 SWAP5 SWAP4 SWAP3 SWAP2 SWAP1 PUSH [tag] 478
 O: SWAP3 SWAP2 SWAP1 PUSH 4 PUSH [tag] 477 SWAP6 SWAP5 ADD PUSH [tag] 478
*)
Compute ( "BottleCastle_run_code_of_0_block_519_1"%string, (equiv_checker [SWAP 3;SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x4%N);PUSH 2 (NToWord WLen 0x1dd%N);SWAP 6;SWAP 5;Opcode ADD;PUSH 2 (NToWord WLen 0x1de%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x1dd%N);SWAP 5;SWAP 4;SWAP 3;SWAP 2;SWAP 1;PUSH 2 (NToWord WLen 0x1de%N)] 5 optimize_id) ).

(*
 I: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP1 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 479
 O: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP9 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 479
*)
Compute ( "BottleCastle_run_code_of_0_block_520_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (NToWord WLen 0x0%N);DUP 8;DUP 9;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1df%N)] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (NToWord WLen 0x0%N);DUP 8;DUP 1;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1df%N)] 3 optimize_id) ).

(*
 I: POP DUP2 ADD SWAP1 PUSH [tag] 481 SWAP2 SWAP1 PUSH [tag] 482
 O: POP DUP2 ADD PUSH [tag] 481 SWAP2 PUSH [tag] 482
*)
Compute ( "BottleCastle_run_code_of_0_block_523_1"%string, (equiv_checker [POP;DUP 2;Opcode ADD;PUSH 2 (NToWord WLen 0x1e1%N);SWAP 2;PUSH 2 (NToWord WLen 0x1e2%N)] [POP;DUP 2;Opcode ADD;SWAP 1;PUSH 2 (NToWord WLen 0x1e1%N);SWAP 2;SWAP 1;PUSH 2 (NToWord WLen 0x1e2%N)] 3 optimize_id) ).

(*
 I: RETURNDATASIZE DUP1 PUSH 0 DUP2 EQ PUSH [tag] 488
 O: RETURNDATASIZE DUP1 DUP2 PUSH 0 EQ PUSH [tag] 488
*)
Compute ( "BottleCastle_run_code_of_0_block_526_0"%string, (equiv_checker [Opcode RETURNDATASIZE;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode EQ;PUSH 2 (NToWord WLen 0x1e8%N)] [Opcode RETURNDATASIZE;DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode EQ;PUSH 2 (NToWord WLen 0x1e8%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD SWAP2 POP PUSH 1F NOT PUSH 3F RETURNDATASIZE ADD AND DUP3 ADD PUSH 40
 O: PUSH 1f PUSH 40 MLOAD SWAP3 POP NOT RETURNDATASIZE PUSH 3f ADD AND DUP3 ADD PUSH 40
*)
Compute ( "BottleCastle_run_code_of_0_block_527_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 3;POP;Opcode NOT;Opcode RETURNDATASIZE;PUSH 1 (NToWord WLen 0x3f%N);Opcode ADD;Opcode AND;DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 2;POP;PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;PUSH 1 (NToWord WLen 0x3F%N);Opcode RETURNDATASIZE;Opcode ADD;Opcode AND;DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 2 optimize_id) ).

(*
 I: POP PUSH 0 DUP2 MLOAD EQ ISZERO PUSH [tag] 489
 O: POP DUP1 MLOAD PUSH 0 EQ ISZERO PUSH [tag] 489
*)
Compute ( "BottleCastle_run_code_of_0_block_529_0"%string, (equiv_checker [POP;DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1e9%N)] [POP;PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode MLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1e9%N)] 2 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_530_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 150B7A02 PUSH E0 SHL PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ SWAP2 POP POP SWAP5 SWAP4 POP POP POP POP
 O: SWAP5 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT PUSH 150b7a02 PUSH e0 SHL SWAP2 SWAP8 SWAP7 DUP2 AND SWAP2 AND EQ SWAP6 POP POP POP POP POP
*)
Compute ( "BottleCastle_run_code_of_0_block_532_0"%string, (equiv_checker [SWAP 5;PUSH 28 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff%N);Opcode NOT;PUSH 4 (NToWord WLen 0x150b7a02%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;SWAP 2;SWAP 8;SWAP 7;DUP 2;Opcode AND;SWAP 2;Opcode AND;Opcode EQ;SWAP 6;POP;POP;POP;POP;POP] [PUSH 4 (NToWord WLen 0x150B7A02%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 28 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode NOT;Opcode AND;DUP 2;PUSH 28 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode NOT;Opcode AND;Opcode EQ;SWAP 2;POP;POP;SWAP 5;SWAP 4;POP;POP;POP;POP] 7 optimize_id) ).

(*
 I: PUSH 60 PUSH A DUP1 SLOAD PUSH [tag] 493 SWAP1 PUSH [tag] 223
 O: PUSH 60 PUSH a PUSH [tag] 493 DUP2 SLOAD PUSH [tag] 223
*)
Compute ( "BottleCastle_run_code_of_0_block_533_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0xa%N);PUSH 2 (NToWord WLen 0x1ed%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0xA%N);DUP 1;Opcode SLOAD;PUSH 2 (NToWord WLen 0x1ed%N);SWAP 1;PUSH 1 (NToWord WLen 0xdf%N)] 0 optimize_id) ).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute ( "BottleCastle_run_code_of_0_block_534_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x1f%N);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;SWAP 2;Opcode DIV;Opcode MUL;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 1 optimize_id) ).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute ( "BottleCastle_run_code_of_0_block_534_1"%string, (equiv_checker [SWAP 2;SWAP 1;DUP 3;DUP 2;DUP 5] [DUP 1;SWAP 3;SWAP 2;SWAP 1;DUP 2;DUP 2] 3 optimize_id) ).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 494 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 494 DUP5 SLOAD PUSH [tag] 223
*)
Compute ( "BottleCastle_run_code_of_0_block_534_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;PUSH 2 (NToWord WLen 0x1ee%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (NToWord WLen 0x1ee%N);SWAP 1;PUSH 1 (NToWord WLen 0xdf%N)] 3 optimize_id) ).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute ( "BottleCastle_run_code_of_0_block_540_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);DUP 4;DUP 5;SWAP 3;Opcode SUB;Opcode AND;Opcode ADD;SWAP 2] [DUP 3;SWAP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x1F%N);Opcode AND;DUP 3;Opcode ADD;SWAP 2] 3 optimize_id) ).

(*
 I: POP POP POP POP POP SWAP1 POP SWAP1
 O: POP POP POP POP POP SWAP2 SWAP1 POP
*)
Compute ( "BottleCastle_run_code_of_0_block_541_0"%string, (equiv_checker [POP;POP;POP;POP;POP;SWAP 2;SWAP 1;POP] [POP;POP;POP;POP;POP;SWAP 1;POP;SWAP 1] 8 optimize_id) ).

(*
 I: PUSH 60 PUSH 0 DUP3 EQ ISZERO PUSH [tag] 499
 O: PUSH 60 DUP2 PUSH 0 EQ ISZERO PUSH [tag] 499
*)
Compute ( "BottleCastle_run_code_of_0_block_542_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1f3%N)] [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x0%N);DUP 3;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1f3%N)] 1 optimize_id) ).

(*
 I: PUSH 0 DUP3 SWAP1 POP PUSH 0
 O: DUP2 PUSH 0
*)
Compute ( "BottleCastle_run_code_of_0_block_544_0"%string, (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;SWAP 1;POP;PUSH 1 (NToWord WLen 0x0%N)] 2 optimize_id) ).

(*
 I: PUSH 0 DUP3 EQ PUSH [tag] 501
 O: DUP2 PUSH 0 EQ PUSH [tag] 501
*)
Compute ( "BottleCastle_run_code_of_0_block_545_0"%string, (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode EQ;PUSH 2 (NToWord WLen 0x1f5%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;Opcode EQ;PUSH 2 (NToWord WLen 0x1f5%N)] 2 optimize_id) ).

(*
 I: DUP1 DUP1 PUSH [tag] 502 SWAP1 PUSH [tag] 503
 O: DUP1 PUSH [tag] 502 DUP3 PUSH [tag] 503
*)
Compute ( "BottleCastle_run_code_of_0_block_546_0"%string, (equiv_checker [DUP 1;PUSH 2 (NToWord WLen 0x1f6%N);DUP 3;PUSH 2 (NToWord WLen 0x1f7%N)] [DUP 1;DUP 1;PUSH 2 (NToWord WLen 0x1f6%N);SWAP 1;PUSH 2 (NToWord WLen 0x1f7%N)] 1 optimize_id) ).

(*
 I: SWAP2 POP POP PUSH A DUP3 PUSH [tag] 504 SWAP2 SWAP1 PUSH [tag] 505
 O: SWAP2 POP POP PUSH [tag] 504 PUSH a DUP4 PUSH [tag] 505
*)
Compute ( "BottleCastle_run_code_of_0_block_547_0"%string, (equiv_checker [SWAP 2;POP;POP;PUSH 2 (NToWord WLen 0x1f8%N);PUSH 1 (NToWord WLen 0xa%N);DUP 4;PUSH 2 (NToWord WLen 0x1f9%N)] [SWAP 2;POP;POP;PUSH 1 (NToWord WLen 0xA%N);DUP 3;PUSH 2 (NToWord WLen 0x1f8%N);SWAP 2;SWAP 1;PUSH 2 (NToWord WLen 0x1f9%N)] 4 optimize_id) ).

(*
 I: PUSH 40 MLOAD SWAP1 DUP1 DUP3
 O: DUP1 PUSH 40 MLOAD SWAP2 DUP3
*)
Compute ( "BottleCastle_run_code_of_0_block_552_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 2;DUP 3] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1;DUP 1;DUP 3] 1 optimize_id) ).

(*
 I: DUP1 PUSH 1F ADD PUSH 1F NOT AND PUSH 20 ADD DUP3 ADD PUSH 40
 O: DUP2 PUSH 20 PUSH 1f DUP4 ADD PUSH 1f NOT AND ADD ADD PUSH 40
*)
Compute ( "BottleCastle_run_code_of_0_block_552_1"%string, (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x1f%N);DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0x1f%N);Opcode NOT;Opcode AND;Opcode ADD;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;Opcode AND;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 2 optimize_id) ).

(*
 I: DUP1 DUP3 ADD SWAP2 POP POP SWAP1 POP
 O: ADD SWAP1 POP
*)
Compute ( "BottleCastle_run_code_of_0_block_553_1"%string, (equiv_checker [Opcode ADD;SWAP 1;POP] [DUP 1;DUP 3;Opcode ADD;SWAP 2;POP;POP;SWAP 1;POP] 3 optimize_id) ).

(*
 I: PUSH 0 DUP6 EQ PUSH [tag] 510
 O: DUP5 PUSH 0 EQ PUSH [tag] 510
*)
Compute ( "BottleCastle_run_code_of_0_block_555_0"%string, (equiv_checker [DUP 5;PUSH 1 (NToWord WLen 0x0%N);Opcode EQ;PUSH 2 (NToWord WLen 0x1fe%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 6;Opcode EQ;PUSH 2 (NToWord WLen 0x1fe%N)] 5 optimize_id) ).

(*
 I: PUSH 1 DUP3 PUSH [tag] 511 SWAP2 SWAP1 PUSH [tag] 512
 O: PUSH [tag] 511 PUSH 1 DUP4 PUSH [tag] 512
*)
Compute ( "BottleCastle_run_code_of_0_block_556_0"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x1ff%N);PUSH 1 (NToWord WLen 0x1%N);DUP 4;PUSH 2 (NToWord WLen 0x200%N)] [PUSH 1 (NToWord WLen 0x1%N);DUP 3;PUSH 2 (NToWord WLen 0x1ff%N);SWAP 2;SWAP 1;PUSH 2 (NToWord WLen 0x200%N)] 2 optimize_id) ).

(*
 I: SWAP2 POP PUSH A DUP6 PUSH [tag] 513 SWAP2 SWAP1 PUSH [tag] 514
 O: SWAP2 POP PUSH [tag] 513 PUSH a DUP7 PUSH [tag] 514
*)
Compute ( "BottleCastle_run_code_of_0_block_557_0"%string, (equiv_checker [SWAP 2;POP;PUSH 2 (NToWord WLen 0x201%N);PUSH 1 (NToWord WLen 0xa%N);DUP 7;PUSH 2 (NToWord WLen 0x202%N)] [SWAP 2;POP;PUSH 1 (NToWord WLen 0xA%N);DUP 6;PUSH 2 (NToWord WLen 0x201%N);SWAP 2;SWAP 1;PUSH 2 (NToWord WLen 0x202%N)] 6 optimize_id) ).

(*
 I: PUSH 30 PUSH [tag] 515 SWAP2 SWAP1 PUSH [tag] 350
 O: PUSH [tag] 515 SWAP1 PUSH 30 PUSH [tag] 350
*)
Compute ( "BottleCastle_run_code_of_0_block_558_0"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x203%N);SWAP 1;PUSH 1 (NToWord WLen 0x30%N);PUSH 2 (NToWord WLen 0x15e%N)] [PUSH 1 (NToWord WLen 0x30%N);PUSH 2 (NToWord WLen 0x203%N);SWAP 2;SWAP 1;PUSH 2 (NToWord WLen 0x15e%N)] 1 optimize_id) ).

(*
 I: PUSH F8 SHL DUP2 DUP4 DUP2 MLOAD DUP2 LT PUSH [tag] 516
 O: PUSH f8 SHL DUP2 DUP4 DUP4 MLOAD DUP6 LT PUSH [tag] 516
*)
Compute ( "BottleCastle_run_code_of_0_block_559_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0xf8%N);Opcode SHL;DUP 2;DUP 4;DUP 4;Opcode MLOAD;DUP 6;Opcode LT;PUSH 2 (NToWord WLen 0x204%N)] [PUSH 1 (NToWord WLen 0xF8%N);Opcode SHL;DUP 2;DUP 4;DUP 2;Opcode MLOAD;DUP 2;Opcode LT;PUSH 2 (NToWord WLen 0x204%N)] 3 optimize_id) ).

(*
 I: PUSH 20 ADD ADD SWAP1 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND SWAP1 DUP2 PUSH 0 BYTE SWAP1
 O: PUSH 20 ADD SWAP2 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT AND SWAP2 ADD DUP2 PUSH 0 BYTE SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_562_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 2;PUSH 31 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff%N);Opcode NOT;Opcode AND;SWAP 2;Opcode ADD;DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode BYTE;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;Opcode ADD;SWAP 1;PUSH 31 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode NOT;Opcode AND;SWAP 1;DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode BYTE;SWAP 1] 3 optimize_id) ).

(*
 I: POP PUSH A DUP6 PUSH [tag] 518 SWAP2 SWAP1 PUSH [tag] 505
 O: POP PUSH [tag] 518 PUSH a DUP7 PUSH [tag] 505
*)
Compute ( "BottleCastle_run_code_of_0_block_562_1"%string, (equiv_checker [POP;PUSH 2 (NToWord WLen 0x206%N);PUSH 1 (NToWord WLen 0xa%N);DUP 7;PUSH 2 (NToWord WLen 0x1f9%N)] [POP;PUSH 1 (NToWord WLen 0xA%N);DUP 6;PUSH 2 (NToWord WLen 0x206%N);SWAP 2;SWAP 1;PUSH 2 (NToWord WLen 0x1f9%N)] 6 optimize_id) ).

(*
 I: DUP1 SWAP4 POP POP POP POP
 O: SWAP3 POP POP POP
*)
Compute ( "BottleCastle_run_code_of_0_block_564_0"%string, (equiv_checker [SWAP 3;POP;POP;POP] [DUP 1;SWAP 4;POP;POP;POP;POP] 4 optimize_id) ).

(*
 I: PUSH 0 CALLER SWAP1 POP SWAP1
 O: CALLER SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_566_0"%string, (equiv_checker [Opcode CALLER;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);Opcode CALLER;SWAP 1;POP;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 0 SWAP4 SWAP3 POP POP POP
 O: POP POP POP PUSH 0 SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_567_0"%string, (equiv_checker [POP;POP;POP;PUSH 1 (NToWord WLen 0x0%N);SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);SWAP 4;SWAP 3;POP;POP;POP] 4 optimize_id) ).

(*
 I: DUP2 DUP2 PUSH 0 ADD SWAP1 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1 DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH ffffffffffffffffffffffffffffffffffffffff DUP2 PUSH 0 ADD DUP4 DUP3 AND DUP1 SWAP3 AND DUP2
*)
Compute ( "BottleCastle_run_code_of_0_block_569_0"%string, (equiv_checker [PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;DUP 4;DUP 3;Opcode AND;DUP 1;SWAP 3;Opcode AND;DUP 2] [DUP 2;DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;SWAP 1;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;SWAP 1;DUP 2;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 2] 2 optimize_id) ).

(*
 I: POP POP PUSH A0 DUP3 SWAP1 SHR DUP2 PUSH 20 ADD SWAP1 PUSH FFFFFFFFFFFFFFFF AND SWAP1 DUP2 PUSH FFFFFFFFFFFFFFFF AND DUP2
 O: POP DUP2 PUSH 20 ADD PUSH ffffffffffffffff DUP5 DUP2 SWAP4 POP SWAP5 PUSH a0 SHR AND SWAP2 DUP3 AND DUP2
*)
Compute ( "BottleCastle_run_code_of_0_block_569_1"%string, (equiv_checker [POP;DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);DUP 5;DUP 2;SWAP 4;POP;SWAP 5;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHR;Opcode AND;SWAP 2;DUP 3;Opcode AND;DUP 2] [POP;POP;PUSH 1 (NToWord WLen 0xA0%N);DUP 3;SWAP 1;Opcode SHR;DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);Opcode AND;SWAP 1;DUP 2;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 2] 4 optimize_id) ).

(*
 I: POP POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 DUP4 AND EQ ISZERO DUP2 PUSH 40 ADD SWAP1 ISZERO ISZERO SWAP1 DUP2 ISZERO ISZERO DUP2
 O: POP PUSH 40 DUP4 PUSH 100000000000000000000000000000000000000000000000000000000 AND PUSH 0 EQ ISZERO ISZERO ISZERO SWAP2 POP DUP3 ADD DUP2 ISZERO ISZERO DUP2
*)
Compute ( "BottleCastle_run_code_of_0_block_569_2"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x40%N);DUP 4;PUSH 29 (NToWord WLen 0x100000000000000000000000000000000000000000000000000000000%N);Opcode AND;PUSH 1 (NToWord WLen 0x0%N);Opcode EQ;Opcode ISZERO;Opcode ISZERO;Opcode ISZERO;SWAP 2;POP;DUP 3;Opcode ADD;DUP 2;Opcode ISZERO;Opcode ISZERO;DUP 2] [POP;POP;PUSH 1 (NToWord WLen 0x0%N);PUSH 29 (NToWord WLen 0x100000000000000000000000000000000000000000000000000000000%N);DUP 4;Opcode AND;Opcode EQ;Opcode ISZERO;DUP 2;PUSH 1 (NToWord WLen 0x40%N);Opcode ADD;SWAP 1;Opcode ISZERO;Opcode ISZERO;SWAP 1;DUP 2;Opcode ISZERO;Opcode ISZERO;DUP 2] 4 optimize_id) ).

(*
 I: POP POP PUSH E8 DUP3 SWAP1 SHR DUP2 PUSH 60 ADD SWAP1 PUSH FFFFFF AND SWAP1 DUP2 PUSH FFFFFF AND DUP2
 O: POP PUSH ffffff DUP1 DUP5 PUSH e8 SHR AND DUP4 PUSH 60 ADD SWAP2 DUP2 SWAP4 POP AND DUP2
*)
Compute ( "BottleCastle_run_code_of_0_block_569_3"%string, (equiv_checker [POP;PUSH 3 (NToWord WLen 0xffffff%N);DUP 1;DUP 5;PUSH 1 (NToWord WLen 0xe8%N);Opcode SHR;Opcode AND;DUP 4;PUSH 1 (NToWord WLen 0x60%N);Opcode ADD;SWAP 2;DUP 2;SWAP 4;POP;Opcode AND;DUP 2] [POP;POP;PUSH 1 (NToWord WLen 0xE8%N);DUP 3;SWAP 1;Opcode SHR;DUP 2;PUSH 1 (NToWord WLen 0x60%N);Opcode ADD;SWAP 1;PUSH 3 (NToWord WLen 0xFFFFFF%N);Opcode AND;SWAP 1;DUP 2;PUSH 3 (NToWord WLen 0xFFFFFF%N);Opcode AND;DUP 2] 4 optimize_id) ).

(*
 I: PUSH 0 DUP1 SLOAD SWAP1 POP PUSH 0 DUP4 DUP3 SUB SWAP1 POP
 O: PUSH 0 SLOAD DUP3 DUP2 SUB
*)
Compute ( "BottleCastle_run_code_of_0_block_572_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 3;DUP 2;Opcode SUB] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;Opcode SLOAD;SWAP 1;POP;PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 3;Opcode SUB;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH [tag] 530 PUSH 0 DUP7 DUP4 DUP1 PUSH 1 ADD SWAP5 POP DUP7 PUSH [tag] 379
 O: PUSH [tag] 530 PUSH 0 DUP7 PUSH 1 DUP5 ADD SWAP4 DUP7 PUSH [tag] 379
*)
Compute ( "BottleCastle_run_code_of_0_block_573_0"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x212%N);PUSH 1 (NToWord WLen 0x0%N);DUP 7;PUSH 1 (NToWord WLen 0x1%N);DUP 5;Opcode ADD;SWAP 4;DUP 7;PUSH 2 (NToWord WLen 0x17b%N)] [PUSH 2 (NToWord WLen 0x212%N);PUSH 1 (NToWord WLen 0x0%N);DUP 7;DUP 4;DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;SWAP 5;POP;DUP 7;PUSH 2 (NToWord WLen 0x17b%N)] 5 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_575_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 0 DUP1 SLOAD SWAP1 POP PUSH 0 DUP3 EQ ISZERO PUSH [tag] 534
 O: PUSH 0 DUP2 DUP2 SLOAD SWAP2 EQ ISZERO PUSH [tag] 534
*)
Compute ( "BottleCastle_run_code_of_0_block_581_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2;Opcode SLOAD;SWAP 2;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x216%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;Opcode SLOAD;SWAP 1;POP;PUSH 1 (NToWord WLen 0x0%N);DUP 3;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x216%N)] 1 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_582_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 1 PUSH 40 PUSH 1 SWAP1 SHL OR DUP3 MUL PUSH 5 PUSH 0 DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 1 DUP1 PUSH 40 SHL OR DUP3 MUL PUSH ffffffffffffffffffffffffffffffffffffffff DUP1 DUP6 AND AND PUSH 0 PUSH 5 SWAP2 DUP2
*)
Compute ( "BottleCastle_run_code_of_0_block_584_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode SHL;Opcode OR;DUP 3;Opcode MUL;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 1;DUP 6;Opcode AND;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x5%N);SWAP 2;DUP 2] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x40%N);PUSH 1 (NToWord WLen 0x1%N);SWAP 1;Opcode SHL;Opcode OR;DUP 3;Opcode MUL;PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x0%N);DUP 6;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 2] 3 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP3 DUP3 SLOAD ADD SWAP3 POP POP DUP2 SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 SWAP1 DUP2 SLOAD ADD DUP1 SWAP2
*)
Compute ( "BottleCastle_run_code_of_0_block_584_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;SWAP 1;DUP 2;Opcode SLOAD;Opcode ADD;DUP 1;SWAP 2] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 3;Opcode SLOAD;Opcode ADD;SWAP 3;POP;POP;DUP 2;SWAP 1] 2 optimize_id) ).

(*
 I: POP PUSH [tag] 536 DUP4 PUSH [tag] 537 PUSH 0 DUP7 PUSH 0 PUSH [tag] 267
 O: POP PUSH [tag] 536 DUP4 PUSH [tag] 537 PUSH 0 DUP3 DUP2 PUSH [tag] 267
*)
Compute ( "BottleCastle_run_code_of_0_block_584_3"%string, (equiv_checker [POP;PUSH 2 (NToWord WLen 0x218%N);DUP 4;PUSH 2 (NToWord WLen 0x219%N);PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 2;PUSH 2 (NToWord WLen 0x10b%N)] [POP;PUSH 2 (NToWord WLen 0x218%N);DUP 4;PUSH 2 (NToWord WLen 0x219%N);PUSH 1 (NToWord WLen 0x0%N);DUP 7;PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x10b%N)] 4 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 DUP2 SWAP1
 O: DUP2 SWAP1 PUSH 20 ADD PUSH 0 KECCAK256
*)
Compute ( "BottleCastle_run_code_of_0_block_587_2"%string, (equiv_checker [DUP 2;SWAP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 2;SWAP 1] 2 optimize_id) ).

(*
 I: POP PUSH 0 DUP1 DUP4 DUP4 ADD SWAP1 POP PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP6 AND SWAP2 POP DUP3 DUP3 PUSH 0 PUSH DDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF PUSH 0 DUP1
 O: PUSH 0 DUP3 DUP6 PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP3 DUP2 SWAP5 DUP5 SWAP7 DUP9 SWAP2 POP ADD SWAP4 DUP4 SWAP7 PUSH ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef SWAP2
*)
Compute ( "BottleCastle_run_code_of_0_block_587_3"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 6;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;DUP 3;DUP 2;SWAP 5;DUP 5;SWAP 7;DUP 9;SWAP 2;POP;Opcode ADD;SWAP 4;DUP 4;SWAP 7;PUSH 32 (NToWord WLen 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef%N);SWAP 2] [POP;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 4;DUP 4;Opcode ADD;SWAP 1;POP;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);DUP 6;Opcode AND;SWAP 2;POP;DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x0%N);PUSH 32 (NToWord WLen 0xDDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF%N);PUSH 1 (NToWord WLen 0x0%N);DUP 1] 4 optimize_id) ).

(*
 I: PUSH 1 DUP4 ADD
 O: DUP3 PUSH 1 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_587_4"%string, (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x1%N);DUP 4;Opcode ADD] 3 optimize_id) ).

(*
 I: DUP2 DUP2 EQ PUSH [tag] 542
 O: DUP1 DUP3 EQ PUSH [tag] 542
*)
Compute ( "BottleCastle_run_code_of_0_block_588_0"%string, (equiv_checker [DUP 1;DUP 3;Opcode EQ;PUSH 2 (NToWord WLen 0x21e%N)] [DUP 2;DUP 2;Opcode EQ;PUSH 2 (NToWord WLen 0x21e%N)] 2 optimize_id) ).

(*
 I: DUP1 DUP4 PUSH 0 PUSH DDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF PUSH 0 DUP1
 O: DUP1 DUP4 PUSH 0 PUSH ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef DUP2 DUP1
*)
Compute ( "BottleCastle_run_code_of_0_block_589_0"%string, (equiv_checker [DUP 1;DUP 4;PUSH 1 (NToWord WLen 0x0%N);PUSH 32 (NToWord WLen 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef%N);DUP 2;DUP 1] [DUP 1;DUP 4;PUSH 1 (NToWord WLen 0x0%N);PUSH 32 (NToWord WLen 0xDDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF%N);PUSH 1 (NToWord WLen 0x0%N);DUP 1] 3 optimize_id) ).

(*
 I: PUSH 1 DUP2 ADD SWAP1 POP PUSH [tag] 540
 O: PUSH 1 ADD PUSH [tag] 540
*)
Compute ( "BottleCastle_run_code_of_0_block_589_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 2 (NToWord WLen 0x21c%N)] [PUSH 1 (NToWord WLen 0x1%N);DUP 2;Opcode ADD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x21c%N)] 1 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_591_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: DUP1 PUSH 0 DUP2 SWAP1
 O: DUP1 DUP1 PUSH 0
*)
Compute ( "BottleCastle_run_code_of_0_block_592_0"%string, (equiv_checker [DUP 1;DUP 1;PUSH 1 (NToWord WLen 0x0%N)] [DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 2;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 0 PUSH 1 DUP3 EQ PUSH E1 SHL SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 1 EQ PUSH e1 SHL SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_594_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);Opcode EQ;PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x1%N);DUP 3;Opcode EQ;PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: DUP3 DUP1 SLOAD PUSH [tag] 546 SWAP1 PUSH [tag] 223
 O: DUP3 PUSH [tag] 546 DUP5 SLOAD PUSH [tag] 223
*)
Compute ( "BottleCastle_run_code_of_0_block_595_0"%string, (equiv_checker [DUP 3;PUSH 2 (NToWord WLen 0x222%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (NToWord WLen 0x222%N);SWAP 1;PUSH 1 (NToWord WLen 0xdf%N)] 3 optimize_id) ).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1 PUSH 1F ADD PUSH 20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 548
 O: PUSH 20 DUP1 PUSH 0 KECCAK256 SWAP2 PUSH 1f ADD DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 548
*)
Compute ( "BottleCastle_run_code_of_0_block_596_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;SWAP 2;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode DIV;DUP 2;Opcode ADD;SWAP 3;DUP 3;PUSH 2 (NToWord WLen 0x224%N)] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;SWAP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);SWAP 1;Opcode DIV;DUP 2;Opcode ADD;SWAP 3;DUP 3;PUSH 2 (NToWord WLen 0x224%N)] 3 optimize_id) ).

(*
 I: DUP1 MLOAD PUSH FF NOT AND DUP4 DUP1 ADD OR DUP6
 O: DUP3 DUP1 ADD PUSH ff NOT DUP3 MLOAD AND OR DUP6
*)
Compute ( "BottleCastle_run_code_of_0_block_599_0"%string, (equiv_checker [DUP 3;DUP 1;Opcode ADD;PUSH 1 (NToWord WLen 0xff%N);Opcode NOT;DUP 3;Opcode MLOAD;Opcode AND;Opcode OR;DUP 6] [DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0xFF%N);Opcode NOT;Opcode AND;DUP 4;DUP 1;Opcode ADD;Opcode OR;DUP 6] 5 optimize_id) ).

(*
 I: DUP3 DUP1 ADD PUSH 1 ADD DUP6
 O: DUP3 DUP4 ADD PUSH 1 ADD DUP6
*)
Compute ( "BottleCastle_run_code_of_0_block_600_0"%string, (equiv_checker [DUP 3;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 6] [DUP 3;DUP 1;Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 6] 5 optimize_id) ).

(*
 I: SWAP2 DUP3 ADD
 O: DUP1 SWAP3 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_601_0"%string, (equiv_checker [DUP 1;SWAP 3;Opcode ADD] [SWAP 2;DUP 3;Opcode ADD] 3 optimize_id) ).

(*
 I: POP SWAP1 POP PUSH [tag] 552 SWAP2 SWAP1 PUSH [tag] 553
 O: POP PUSH [tag] 552 SWAP3 SWAP2 POP PUSH [tag] 553
*)
Compute ( "BottleCastle_run_code_of_0_block_605_0"%string, (equiv_checker [POP;PUSH 2 (NToWord WLen 0x228%N);SWAP 3;SWAP 2;POP;PUSH 2 (NToWord WLen 0x229%N)] [POP;SWAP 1;POP;PUSH 2 (NToWord WLen 0x228%N);SWAP 2;SWAP 1;PUSH 2 (NToWord WLen 0x229%N)] 4 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 PUSH FFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 20 ADD PUSH ffffffffffffffff PUSH 0 AND DUP2
*)
Compute ( "BottleCastle_run_code_of_0_block_607_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);PUSH 1 (NToWord WLen 0x0%N);Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 2] 1 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 PUSH FFFFFF AND DUP2
 O: PUSH 20 ADD PUSH ffffff PUSH 0 AND DUP2
*)
Compute ( "BottleCastle_run_code_of_0_block_607_4"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 3 (NToWord WLen 0xffffff%N);PUSH 1 (NToWord WLen 0x0%N);Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);PUSH 3 (NToWord WLen 0xFFFFFF%N);Opcode AND;DUP 2] 1 optimize_id) ).

(*
 I: PUSH 0 DUP2 PUSH 0 SWAP1
 O: PUSH 0 DUP1 DUP3
*)
Compute ( "BottleCastle_run_code_of_0_block_610_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 3] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 20 DUP2 ADD DUP5 DUP5 DUP5 ADD GT ISZERO PUSH [tag] 563
 O: DUP1 PUSH 20 ADD DUP5 DUP4 DUP6 ADD GT ISZERO PUSH [tag] 563
*)
Compute ( "BottleCastle_run_code_of_0_block_614_1"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 5;DUP 4;DUP 6;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x233%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;DUP 5;DUP 5;DUP 5;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x233%N)] 4 optimize_id) ).

(*
 I: PUSH 20 DUP2 ADD DUP5 DUP5 DUP5 ADD GT ISZERO PUSH [tag] 573
 O: DUP1 PUSH 20 ADD DUP5 DUP4 DUP6 ADD GT ISZERO PUSH [tag] 573
*)
Compute ( "BottleCastle_run_code_of_0_block_621_1"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 5;DUP 4;DUP 6;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x23d%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;DUP 5;DUP 5;DUP 5;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x23d%N)] 4 optimize_id) ).

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 578 DUP2 PUSH [tag] 579
 O: DUP1 CALLDATALOAD PUSH [tag] 578 DUP2 PUSH [tag] 579
*)
Compute ( "BottleCastle_run_code_of_0_block_626_0"%string, (equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 2 (NToWord WLen 0x242%N);DUP 2;PUSH 2 (NToWord WLen 0x243%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode CALLDATALOAD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x242%N);DUP 2;PUSH 2 (NToWord WLen 0x243%N)] 1 optimize_id) ).

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 582 DUP2 PUSH [tag] 583
 O: DUP1 CALLDATALOAD PUSH [tag] 582 DUP2 PUSH [tag] 583
*)
Compute ( "BottleCastle_run_code_of_0_block_628_0"%string, (equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 2 (NToWord WLen 0x246%N);DUP 2;PUSH 2 (NToWord WLen 0x247%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode CALLDATALOAD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x246%N);DUP 2;PUSH 2 (NToWord WLen 0x247%N)] 1 optimize_id) ).

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 586 DUP2 PUSH [tag] 587
 O: DUP1 CALLDATALOAD PUSH [tag] 586 DUP2 PUSH [tag] 587
*)
Compute ( "BottleCastle_run_code_of_0_block_630_0"%string, (equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 2 (NToWord WLen 0x24a%N);DUP 2;PUSH 2 (NToWord WLen 0x24b%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode CALLDATALOAD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x24a%N);DUP 2;PUSH 2 (NToWord WLen 0x24b%N)] 1 optimize_id) ).

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP PUSH [tag] 590 DUP2 PUSH [tag] 587
 O: DUP1 MLOAD PUSH [tag] 590 DUP2 PUSH [tag] 587
*)
Compute ( "BottleCastle_run_code_of_0_block_632_0"%string, (equiv_checker [DUP 1;Opcode MLOAD;PUSH 2 (NToWord WLen 0x24e%N);DUP 2;PUSH 2 (NToWord WLen 0x24b%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode MLOAD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x24e%N);DUP 2;PUSH 2 (NToWord WLen 0x24b%N)] 1 optimize_id) ).

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 593
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 593
*)
Compute ( "BottleCastle_run_code_of_0_block_634_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode SLT;PUSH 2 (NToWord WLen 0x251%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;Opcode SLT;PUSH 2 (NToWord WLen 0x251%N)] 2 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute ( "BottleCastle_run_code_of_0_block_638_0"%string, (equiv_checker [SWAP 5;SWAP 4;POP;POP;POP;POP] [SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 599
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 599
*)
Compute ( "BottleCastle_run_code_of_0_block_639_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode SLT;PUSH 2 (NToWord WLen 0x257%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;Opcode SLT;PUSH 2 (NToWord WLen 0x257%N)] 2 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute ( "BottleCastle_run_code_of_0_block_643_0"%string, (equiv_checker [SWAP 5;SWAP 4;POP;POP;POP;POP] [SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 604 DUP2 PUSH [tag] 605
 O: DUP1 CALLDATALOAD PUSH [tag] 604 DUP2 PUSH [tag] 605
*)
Compute ( "BottleCastle_run_code_of_0_block_644_0"%string, (equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 2 (NToWord WLen 0x25c%N);DUP 2;PUSH 2 (NToWord WLen 0x25d%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode CALLDATALOAD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x25c%N);DUP 2;PUSH 2 (NToWord WLen 0x25d%N)] 1 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 610 DUP5 DUP3 DUP6 ADD PUSH [tag] 576
 O: PUSH 0 PUSH [tag] 610 DUP5 DUP5 DUP4 ADD PUSH [tag] 576
*)
Compute ( "BottleCastle_run_code_of_0_block_649_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x262%N);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x262%N);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] 3 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute ( "BottleCastle_run_code_of_0_block_650_0"%string, (equiv_checker [SWAP 5;SWAP 4;POP;POP;POP;POP] [SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 614 DUP6 DUP3 DUP7 ADD PUSH [tag] 576
 O: PUSH 0 PUSH [tag] 614 DUP6 DUP6 DUP4 ADD PUSH [tag] 576
*)
Compute ( "BottleCastle_run_code_of_0_block_654_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x266%N);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x266%N);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] 4 optimize_id) ).

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 615 DUP6 DUP3 DUP7 ADD PUSH [tag] 576
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 615 DUP6 DUP6 DUP4 ADD PUSH [tag] 576
*)
Compute ( "BottleCastle_run_code_of_0_block_655_0"%string, (equiv_checker [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x267%N);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x267%N);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] 6 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute ( "BottleCastle_run_code_of_0_block_656_0"%string, (equiv_checker [SWAP 5;POP;POP;POP;SWAP 3;SWAP 1;POP] [SWAP 2;POP;POP;SWAP 3;POP;SWAP 3;SWAP 1;POP] 7 optimize_id) ).

(*
 I: PUSH 0 DUP1 PUSH 0 PUSH 60 DUP5 DUP7 SUB SLT ISZERO PUSH [tag] 617
 O: PUSH 0 DUP1 DUP2 PUSH 60 DUP5 DUP7 SUB SLT ISZERO PUSH [tag] 617
*)
Compute ( "BottleCastle_run_code_of_0_block_657_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x60%N);DUP 5;DUP 7;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x269%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x60%N);DUP 5;DUP 7;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x269%N)] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 619 DUP7 DUP3 DUP8 ADD PUSH [tag] 576
 O: PUSH 0 PUSH [tag] 619 DUP7 DUP7 DUP4 ADD PUSH [tag] 576
*)
Compute ( "BottleCastle_run_code_of_0_block_660_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x26b%N);DUP 7;DUP 7;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x26b%N);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] 5 optimize_id) ).

(*
 I: SWAP4 POP POP PUSH 20 PUSH [tag] 620 DUP7 DUP3 DUP8 ADD PUSH [tag] 576
 O: SWAP4 POP POP PUSH 20 PUSH [tag] 620 DUP7 DUP7 DUP4 ADD PUSH [tag] 576
*)
Compute ( "BottleCastle_run_code_of_0_block_661_0"%string, (equiv_checker [SWAP 4;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x26c%N);DUP 7;DUP 7;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] [SWAP 4;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x26c%N);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] 7 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 POP SWAP3
 O: SWAP5 POP POP POP SWAP3 POP SWAP3
*)
Compute ( "BottleCastle_run_code_of_0_block_663_0"%string, (equiv_checker [SWAP 5;POP;POP;POP;SWAP 3;POP;SWAP 3] [SWAP 2;POP;POP;SWAP 3;POP;SWAP 3;POP;SWAP 3] 8 optimize_id) ).

(*
 I: PUSH 0 DUP1 PUSH 0 DUP1 PUSH 80 DUP6 DUP8 SUB SLT ISZERO PUSH [tag] 623
 O: PUSH 0 DUP1 DUP1 DUP3 PUSH 80 DUP6 DUP8 SUB SLT ISZERO PUSH [tag] 623
*)
Compute ( "BottleCastle_run_code_of_0_block_664_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 1;DUP 3;PUSH 1 (NToWord WLen 0x80%N);DUP 6;DUP 8;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x26f%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x80%N);DUP 6;DUP 8;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x26f%N)] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 625 DUP8 DUP3 DUP9 ADD PUSH [tag] 576
 O: PUSH 0 PUSH [tag] 625 DUP8 DUP8 DUP4 ADD PUSH [tag] 576
*)
Compute ( "BottleCastle_run_code_of_0_block_667_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x271%N);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x271%N);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] 6 optimize_id) ).

(*
 I: SWAP5 POP POP PUSH 20 PUSH [tag] 626 DUP8 DUP3 DUP9 ADD PUSH [tag] 576
 O: SWAP5 POP POP PUSH 20 PUSH [tag] 626 DUP8 DUP8 DUP4 ADD PUSH [tag] 576
*)
Compute ( "BottleCastle_run_code_of_0_block_668_0"%string, (equiv_checker [SWAP 5;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x272%N);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] [SWAP 5;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x272%N);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] 8 optimize_id) ).

(*
 I: SWAP4 POP POP PUSH 40 PUSH [tag] 627 DUP8 DUP3 DUP9 ADD PUSH [tag] 602
 O: SWAP4 POP POP PUSH 40 PUSH [tag] 627 DUP8 DUP8 DUP4 ADD PUSH [tag] 602
*)
Compute ( "BottleCastle_run_code_of_0_block_669_0"%string, (equiv_checker [SWAP 4;POP;POP;PUSH 1 (NToWord WLen 0x40%N);PUSH 2 (NToWord WLen 0x273%N);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x25a%N)] [SWAP 4;POP;POP;PUSH 1 (NToWord WLen 0x40%N);PUSH 2 (NToWord WLen 0x273%N);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 2 (NToWord WLen 0x25a%N)] 8 optimize_id) ).

(*
 I: SWAP3 POP POP PUSH 60 DUP6 ADD CALLDATALOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 628
 O: SWAP3 POP POP DUP5 PUSH 60 ADD CALLDATALOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 628
*)
Compute ( "BottleCastle_run_code_of_0_block_670_0"%string, (equiv_checker [SWAP 3;POP;POP;DUP 5;PUSH 1 (NToWord WLen 0x60%N);Opcode ADD;Opcode CALLDATALOAD;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x274%N)] [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x60%N);DUP 6;Opcode ADD;Opcode CALLDATALOAD;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x274%N)] 7 optimize_id) ).

(*
 I: PUSH [tag] 631 DUP8 DUP3 DUP9 ADD PUSH [tag] 591
 O: PUSH [tag] 631 DUP8 DUP8 DUP4 ADD PUSH [tag] 591
*)
Compute ( "BottleCastle_run_code_of_0_block_673_0"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x277%N);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x24f%N)] [PUSH 2 (NToWord WLen 0x277%N);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 2 (NToWord WLen 0x24f%N)] 7 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 SWAP6 SWAP2 SWAP5 POP SWAP3 POP
 O: SWAP5 SWAP8 SWAP4 SWAP7 POP POP POP SWAP3 POP
*)
Compute ( "BottleCastle_run_code_of_0_block_674_0"%string, (equiv_checker [SWAP 5;SWAP 8;SWAP 4;SWAP 7;POP;POP;POP;SWAP 3;POP] [SWAP 2;POP;POP;SWAP 3;SWAP 6;SWAP 2;SWAP 5;POP;SWAP 3;POP] 9 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 635 DUP6 DUP3 DUP7 ADD PUSH [tag] 576
 O: PUSH 0 PUSH [tag] 635 DUP6 DUP6 DUP4 ADD PUSH [tag] 576
*)
Compute ( "BottleCastle_run_code_of_0_block_678_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x27b%N);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x27b%N);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] 4 optimize_id) ).

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 636 DUP6 DUP3 DUP7 ADD PUSH [tag] 580
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 636 DUP6 DUP6 DUP4 ADD PUSH [tag] 580
*)
Compute ( "BottleCastle_run_code_of_0_block_679_0"%string, (equiv_checker [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x27c%N);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x244%N)] [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x27c%N);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (NToWord WLen 0x244%N)] 6 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute ( "BottleCastle_run_code_of_0_block_680_0"%string, (equiv_checker [SWAP 5;POP;POP;POP;SWAP 3;SWAP 1;POP] [SWAP 2;POP;POP;SWAP 3;POP;SWAP 3;SWAP 1;POP] 7 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 640 DUP6 DUP3 DUP7 ADD PUSH [tag] 576
 O: PUSH 0 PUSH [tag] 640 DUP6 DUP6 DUP4 ADD PUSH [tag] 576
*)
Compute ( "BottleCastle_run_code_of_0_block_684_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x280%N);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x280%N);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] 4 optimize_id) ).

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 641 DUP6 DUP3 DUP7 ADD PUSH [tag] 602
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 641 DUP6 DUP6 DUP4 ADD PUSH [tag] 602
*)
Compute ( "BottleCastle_run_code_of_0_block_685_0"%string, (equiv_checker [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x281%N);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x25a%N)] [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x281%N);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (NToWord WLen 0x25a%N)] 6 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute ( "BottleCastle_run_code_of_0_block_686_0"%string, (equiv_checker [SWAP 5;POP;POP;POP;SWAP 3;SWAP 1;POP] [SWAP 2;POP;POP;SWAP 3;POP;SWAP 3;SWAP 1;POP] 7 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 645 DUP5 DUP3 DUP6 ADD PUSH [tag] 580
 O: PUSH 0 PUSH [tag] 645 DUP5 DUP5 DUP4 ADD PUSH [tag] 580
*)
Compute ( "BottleCastle_run_code_of_0_block_690_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x285%N);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x244%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x285%N);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 2 (NToWord WLen 0x244%N)] 3 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute ( "BottleCastle_run_code_of_0_block_691_0"%string, (equiv_checker [SWAP 5;SWAP 4;POP;POP;POP;POP] [SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 649 DUP5 DUP3 DUP6 ADD PUSH [tag] 584
 O: PUSH 0 PUSH [tag] 649 DUP5 DUP5 DUP4 ADD PUSH [tag] 584
*)
Compute ( "BottleCastle_run_code_of_0_block_695_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x289%N);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x248%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x289%N);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 2 (NToWord WLen 0x248%N)] 3 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute ( "BottleCastle_run_code_of_0_block_696_0"%string, (equiv_checker [SWAP 5;SWAP 4;POP;POP;POP;POP] [SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 653 DUP5 DUP3 DUP6 ADD PUSH [tag] 588
 O: PUSH 0 PUSH [tag] 653 DUP5 DUP5 DUP4 ADD PUSH [tag] 588
*)
Compute ( "BottleCastle_run_code_of_0_block_700_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x28d%N);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x24c%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x28d%N);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 2 (NToWord WLen 0x24c%N)] 3 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute ( "BottleCastle_run_code_of_0_block_701_0"%string, (equiv_checker [SWAP 5;SWAP 4;POP;POP;POP;POP] [SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: PUSH 0 DUP3 ADD CALLDATALOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 657
 O: DUP2 PUSH 0 ADD CALLDATALOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 657
*)
Compute ( "BottleCastle_run_code_of_0_block_705_0"%string, (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;Opcode CALLDATALOAD;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x291%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;Opcode ADD;Opcode CALLDATALOAD;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x291%N)] 2 optimize_id) ).

(*
 I: PUSH [tag] 659 DUP5 DUP3 DUP6 ADD PUSH [tag] 597
 O: PUSH [tag] 659 DUP5 DUP5 DUP4 ADD PUSH [tag] 597
*)
Compute ( "BottleCastle_run_code_of_0_block_708_0"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x293%N);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x255%N)] [PUSH 2 (NToWord WLen 0x293%N);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 2 (NToWord WLen 0x255%N)] 4 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute ( "BottleCastle_run_code_of_0_block_709_0"%string, (equiv_checker [SWAP 5;SWAP 4;POP;POP;POP;POP] [SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 663 DUP5 DUP3 DUP6 ADD PUSH [tag] 602
 O: PUSH 0 PUSH [tag] 663 DUP5 DUP5 DUP4 ADD PUSH [tag] 602
*)
Compute ( "BottleCastle_run_code_of_0_block_713_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x297%N);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x25a%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x297%N);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 2 (NToWord WLen 0x25a%N)] 3 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute ( "BottleCastle_run_code_of_0_block_714_0"%string, (equiv_checker [SWAP 5;SWAP 4;POP;POP;POP;POP] [SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 667 DUP6 DUP3 DUP7 ADD PUSH [tag] 602
 O: PUSH 0 PUSH [tag] 667 DUP6 DUP6 DUP4 ADD PUSH [tag] 602
*)
Compute ( "BottleCastle_run_code_of_0_block_718_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x29b%N);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x25a%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x29b%N);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (NToWord WLen 0x25a%N)] 4 optimize_id) ).

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 668 DUP6 DUP3 DUP7 ADD PUSH [tag] 576
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 668 DUP6 DUP6 DUP4 ADD PUSH [tag] 576
*)
Compute ( "BottleCastle_run_code_of_0_block_719_0"%string, (equiv_checker [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x29c%N);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x29c%N);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (NToWord WLen 0x240%N)] 6 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute ( "BottleCastle_run_code_of_0_block_720_0"%string, (equiv_checker [SWAP 5;POP;POP;POP;SWAP 3;SWAP 1;POP] [SWAP 2;POP;POP;SWAP 3;POP;SWAP 3;SWAP 1;POP] 7 optimize_id) ).

(*
 I: PUSH 20 DUP4 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP POP PUSH 20 ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_722_0"%string, (equiv_checker [POP;POP;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 4 optimize_id) ).

(*
 I: SWAP3 POP POP PUSH 1 DUP2 ADD SWAP1 POP PUSH [tag] 685
 O: SWAP3 POP POP PUSH 1 ADD PUSH [tag] 685
*)
Compute ( "BottleCastle_run_code_of_0_block_732_0"%string, (equiv_checker [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 2 (NToWord WLen 0x2ad%N)] [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x1%N);DUP 2;Opcode ADD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x2ad%N)] 4 optimize_id) ).

(*
 I: POP DUP6 SWAP4 POP POP POP POP SWAP3 SWAP2 POP POP
 O: POP POP POP POP POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_733_0"%string, (equiv_checker [POP;POP;POP;POP;POP;POP;SWAP 1] [POP;DUP 6;SWAP 4;POP;POP;POP;POP;SWAP 3;SWAP 2;POP;POP] 8 optimize_id) ).

(*
 I: SWAP4 POP PUSH [tag] 701 DUP2 DUP6 PUSH 20 DUP7 ADD PUSH [tag] 702
 O: SWAP4 POP PUSH [tag] 701 DUP2 DUP6 DUP6 PUSH 20 ADD PUSH [tag] 702
*)
Compute ( "BottleCastle_run_code_of_0_block_738_0"%string, (equiv_checker [SWAP 4;POP;PUSH 2 (NToWord WLen 0x2bd%N);DUP 2;DUP 6;DUP 6;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x2be%N)] [SWAP 4;POP;PUSH 2 (NToWord WLen 0x2bd%N);DUP 2;DUP 6;PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;PUSH 2 (NToWord WLen 0x2be%N)] 5 optimize_id) ).

(*
 I: DUP5 ADD SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP3 POP POP POP ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_740_0"%string, (equiv_checker [SWAP 3;POP;POP;POP;Opcode ADD;SWAP 1] [DUP 5;Opcode ADD;SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: SWAP4 POP PUSH [tag] 711 DUP2 DUP6 PUSH 20 DUP7 ADD PUSH [tag] 702
 O: SWAP4 POP PUSH [tag] 711 DUP2 DUP6 DUP6 PUSH 20 ADD PUSH [tag] 702
*)
Compute ( "BottleCastle_run_code_of_0_block_743_0"%string, (equiv_checker [SWAP 4;POP;PUSH 2 (NToWord WLen 0x2c7%N);DUP 2;DUP 6;DUP 6;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x2be%N)] [SWAP 4;POP;PUSH 2 (NToWord WLen 0x2c7%N);DUP 2;DUP 6;PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;PUSH 2 (NToWord WLen 0x2be%N)] 5 optimize_id) ).

(*
 I: DUP5 ADD SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP3 POP POP POP ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_745_0"%string, (equiv_checker [SWAP 3;POP;POP;POP;Opcode ADD;SWAP 1] [DUP 5;Opcode ADD;SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: SWAP4 POP PUSH [tag] 718 DUP2 DUP6 PUSH 20 DUP7 ADD PUSH [tag] 702
 O: SWAP4 POP PUSH [tag] 718 DUP2 DUP6 DUP6 PUSH 20 ADD PUSH [tag] 702
*)
Compute ( "BottleCastle_run_code_of_0_block_748_0"%string, (equiv_checker [SWAP 4;POP;PUSH 2 (NToWord WLen 0x2ce%N);DUP 2;DUP 6;DUP 6;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x2be%N)] [SWAP 4;POP;PUSH 2 (NToWord WLen 0x2ce%N);DUP 2;DUP 6;PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;PUSH 2 (NToWord WLen 0x2be%N)] 5 optimize_id) ).

(*
 I: DUP1 DUP5 ADD SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP2 POP POP ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_749_0"%string, (equiv_checker [SWAP 2;POP;POP;Opcode ADD;SWAP 1] [DUP 1;DUP 5;Opcode ADD;SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 5 optimize_id) ).

(*
 I: SWAP5 POP PUSH 1 DUP3 AND PUSH 0 DUP2 EQ PUSH [tag] 724
 O: SWAP5 POP DUP2 PUSH 1 AND PUSH 0 DUP2 EQ PUSH [tag] 724
*)
Compute ( "BottleCastle_run_code_of_0_block_752_0"%string, (equiv_checker [SWAP 5;POP;DUP 2;PUSH 1 (NToWord WLen 0x1%N);Opcode AND;PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode EQ;PUSH 2 (NToWord WLen 0x2d4%N)] [SWAP 5;POP;PUSH 1 (NToWord WLen 0x1%N);DUP 3;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode EQ;PUSH 2 (NToWord WLen 0x2d4%N)] 6 optimize_id) ).

(*
 I: PUSH 1 DUP2 EQ PUSH [tag] 725
 O: DUP1 PUSH 1 EQ PUSH [tag] 725
*)
Compute ( "BottleCastle_run_code_of_0_block_753_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode EQ;PUSH 2 (NToWord WLen 0x2d5%N)] [PUSH 1 (NToWord WLen 0x1%N);DUP 2;Opcode EQ;PUSH 2 (NToWord WLen 0x2d5%N)] 1 optimize_id) ).

(*
 I: DUP2 SLOAD DUP2 DUP10 ADD
 O: DUP2 SLOAD DUP9 DUP3 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_759_0"%string, (equiv_checker [DUP 2;Opcode SLOAD;DUP 9;DUP 3;Opcode ADD] [DUP 2;Opcode SLOAD;DUP 2;DUP 10;Opcode ADD] 8 optimize_id) ).

(*
 I: PUSH 1 DUP3 ADD SWAP2 POP PUSH 20 DUP2 ADD SWAP1 POP PUSH [tag] 728
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD PUSH [tag] 728
*)
Compute ( "BottleCastle_run_code_of_0_block_759_1"%string, (equiv_checker [SWAP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x2d8%N)] [PUSH 1 (NToWord WLen 0x1%N);DUP 3;Opcode ADD;SWAP 2;POP;PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x2d8%N)] 2 optimize_id) ).

(*
 I: DUP4 DUP9 ADD SWAP6 POP POP POP
 O: POP DUP7 DUP4 ADD SWAP5 POP POP
*)
Compute ( "BottleCastle_run_code_of_0_block_760_0"%string, (equiv_checker [POP;DUP 7;DUP 4;Opcode ADD;SWAP 5;POP;POP] [DUP 4;DUP 9;Opcode ADD;SWAP 6;POP;POP;POP] 8 optimize_id) ).

(*
 I: PUSH 40 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 40 ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_764_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x40%N);Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x40%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 3 optimize_id) ).

(*
 I: PUSH 40 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 40 ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_767_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x40%N);Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x40%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 3 optimize_id) ).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_770_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 3 optimize_id) ).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_773_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 3 optimize_id) ).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_776_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 3 optimize_id) ).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_779_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 3 optimize_id) ).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_782_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 3 optimize_id) ).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_785_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 3 optimize_id) ).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_788_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 3 optimize_id) ).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_791_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 3 optimize_id) ).

(*
 I: SWAP2 POP DUP2 SWAP1 POP SWAP5 SWAP4 POP POP POP POP
 O: SWAP5 POP POP POP POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_799_0"%string, (equiv_checker [SWAP 5;POP;POP;POP;POP;POP;SWAP 1] [SWAP 2;POP;DUP 2;SWAP 1;POP;SWAP 5;SWAP 4;POP;POP;POP;POP] 7 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP PUSH [tag] 792 PUSH 0 DUP4 ADD DUP5 PUSH [tag] 673
 O: PUSH 20 DUP2 ADD PUSH [tag] 792 DUP3 PUSH 0 ADD DUP5 PUSH [tag] 673
*)
Compute ( "BottleCastle_run_code_of_0_block_800_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;PUSH 2 (NToWord WLen 0x318%N);DUP 3;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x2a1%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x318%N);PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x2a1%N)] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH 80 DUP3 ADD SWAP1 POP PUSH [tag] 794 PUSH 0 DUP4 ADD DUP8 PUSH [tag] 673
 O: PUSH 80 DUP2 ADD PUSH [tag] 794 DUP3 PUSH 0 ADD DUP8 PUSH [tag] 673
*)
Compute ( "BottleCastle_run_code_of_0_block_802_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x80%N);DUP 2;Opcode ADD;PUSH 2 (NToWord WLen 0x31a%N);DUP 3;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;DUP 8;PUSH 2 (NToWord WLen 0x2a1%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x80%N);DUP 3;Opcode ADD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x31a%N);PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD;DUP 8;PUSH 2 (NToWord WLen 0x2a1%N)] 5 optimize_id) ).

(*
 I: PUSH [tag] 795 PUSH 20 DUP4 ADD DUP7 PUSH [tag] 673
 O: PUSH [tag] 795 DUP3 PUSH 20 ADD DUP7 PUSH [tag] 673
*)
Compute ( "BottleCastle_run_code_of_0_block_803_0"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x31b%N);DUP 3;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 7;PUSH 2 (NToWord WLen 0x2a1%N)] [PUSH 2 (NToWord WLen 0x31b%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 7;PUSH 2 (NToWord WLen 0x2a1%N)] 5 optimize_id) ).

(*
 I: SWAP1 POP SWAP6 SWAP5 POP POP POP POP POP
 O: SWAP7 SWAP6 POP POP POP POP POP POP
*)
Compute ( "BottleCastle_run_code_of_0_block_806_0"%string, (equiv_checker [SWAP 7;SWAP 6;POP;POP;POP;POP;POP;POP] [SWAP 1;POP;SWAP 6;SWAP 5;POP;POP;POP;POP;POP] 8 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_807_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] 1 optimize_id) ).

(*
 I: SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP4 SWAP3 POP POP POP
*)
Compute ( "BottleCastle_run_code_of_0_block_808_0"%string, (equiv_checker [SWAP 4;SWAP 3;POP;POP;POP] [SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 5 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP PUSH [tag] 801 PUSH 0 DUP4 ADD DUP5 PUSH [tag] 691
 O: PUSH 20 DUP2 ADD PUSH [tag] 801 DUP3 PUSH 0 ADD DUP5 PUSH [tag] 691
*)
Compute ( "BottleCastle_run_code_of_0_block_809_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;PUSH 2 (NToWord WLen 0x321%N);DUP 3;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x2b3%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x321%N);PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x2b3%N)] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_811_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] 1 optimize_id) ).

(*
 I: SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP4 SWAP3 POP POP POP
*)
Compute ( "BottleCastle_run_code_of_0_block_812_0"%string, (equiv_checker [SWAP 4;SWAP 3;POP;POP;POP] [SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 5 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_813_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] 1 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_814_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_815_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] 1 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_816_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_817_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] 1 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_818_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_819_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] 1 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_820_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_821_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] 1 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_822_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_823_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] 1 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_824_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_825_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] 1 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_826_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_827_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] 1 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_828_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_829_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] 1 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_830_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_831_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] 1 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_832_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP PUSH [tag] 825 PUSH 0 DUP4 ADD DUP5 PUSH [tag] 784
 O: PUSH 20 DUP2 ADD PUSH [tag] 825 DUP3 PUSH 0 ADD DUP5 PUSH [tag] 784
*)
Compute ( "BottleCastle_run_code_of_0_block_833_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;PUSH 2 (NToWord WLen 0x339%N);DUP 3;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x310%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x339%N);PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x310%N)] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH 40 MLOAD SWAP1 POP SWAP1
 O: PUSH 40 MLOAD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_838_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1;POP;SWAP 1] 1 optimize_id) ).

(*
 I: SWAP1 POP PUSH 20 DUP2 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_843_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: SWAP1 POP PUSH 20 DUP2 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_848_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 DUP2 SWAP1 POP PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_849_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;SWAP 1;POP;PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH 0 DUP2 SWAP1 POP DUP2 PUSH 0
 O: DUP1 DUP2 PUSH 0
*)
Compute ( "BottleCastle_run_code_of_0_block_850_0"%string, (equiv_checker [DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;SWAP 1;POP;DUP 2;PUSH 1 (NToWord WLen 0x0%N)] 1 optimize_id) ).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1 POP SWAP2 SWAP1 POP
 O: POP POP PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_850_1"%string, (equiv_checker [POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;SWAP 1;POP;SWAP 2;SWAP 1;POP] 3 optimize_id) ).

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP SWAP2 SWAP1 POP
 O: MLOAD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_851_0"%string, (equiv_checker [Opcode MLOAD;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode MLOAD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP SWAP2 SWAP1 POP
 O: MLOAD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_852_0"%string, (equiv_checker [Opcode MLOAD;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode MLOAD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP SWAP2 SWAP1 POP
 O: MLOAD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_853_0"%string, (equiv_checker [Opcode MLOAD;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode MLOAD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_854_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP PUSH 20 SWAP2 POP ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_855_1"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x20%N);SWAP 2;POP;Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 4 optimize_id) ).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP PUSH 20 SWAP2 POP ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_856_1"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x20%N);SWAP 2;POP;Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 4 optimize_id) ).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP PUSH 20 SWAP2 POP ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_857_1"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x20%N);SWAP 2;POP;Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 4 optimize_id) ).

(*
 I: PUSH 0 DUP2 SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP2 SWAP1 POP
*)
Compute ( "BottleCastle_run_code_of_0_block_858_0"%string, (equiv_checker [SWAP 2;SWAP 1;POP] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 3 optimize_id) ).

(*
 I: SWAP3 POP DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF SUB DUP3 GT ISZERO PUSH [tag] 853
 O: DUP1 SWAP4 POP PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff SUB DUP3 GT ISZERO PUSH [tag] 853
*)
Compute ( "BottleCastle_run_code_of_0_block_861_0"%string, (equiv_checker [DUP 1;SWAP 4;POP;PUSH 32 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff%N);Opcode SUB;DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x355%N)] [SWAP 3;POP;DUP 3;PUSH 32 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode SUB;DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x355%N)] 4 optimize_id) ).

(*
 I: DUP3 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_864_0"%string, (equiv_checker [POP;Opcode ADD;SWAP 1] [DUP 3;DUP 3;Opcode ADD;SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 4 optimize_id) ).

(*
 I: DUP3 DUP3 DIV SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP DIV SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_870_0"%string, (equiv_checker [POP;Opcode DIV;SWAP 1] [DUP 3;DUP 3;Opcode DIV;SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 4 optimize_id) ).

(*
 I: SWAP3 POP DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DIV DUP4 GT DUP3 ISZERO ISZERO AND ISZERO PUSH [tag] 865
 O: SWAP3 POP DUP2 ISZERO ISZERO DUP3 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff DIV DUP5 GT AND ISZERO PUSH [tag] 865
*)
Compute ( "BottleCastle_run_code_of_0_block_873_0"%string, (equiv_checker [SWAP 3;POP;DUP 2;Opcode ISZERO;Opcode ISZERO;DUP 3;PUSH 32 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff%N);Opcode DIV;DUP 5;Opcode GT;Opcode AND;Opcode ISZERO;PUSH 2 (NToWord WLen 0x361%N)] [SWAP 3;POP;DUP 2;PUSH 32 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode DIV;DUP 4;Opcode GT;DUP 3;Opcode ISZERO;Opcode ISZERO;Opcode AND;Opcode ISZERO;PUSH 2 (NToWord WLen 0x361%N)] 4 optimize_id) ).

(*
 I: DUP3 DUP3 MUL SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP MUL SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_876_0"%string, (equiv_checker [POP;Opcode MUL;SWAP 1] [DUP 3;DUP 3;Opcode MUL;SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 4 optimize_id) ).

(*
 I: SWAP3 POP DUP3 DUP3 LT ISZERO PUSH [tag] 870
 O: DUP1 SWAP4 POP DUP3 LT ISZERO PUSH [tag] 870
*)
Compute ( "BottleCastle_run_code_of_0_block_879_0"%string, (equiv_checker [DUP 1;SWAP 4;POP;DUP 3;Opcode LT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x366%N)] [SWAP 3;POP;DUP 3;DUP 3;Opcode LT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x366%N)] 4 optimize_id) ).

(*
 I: DUP3 DUP3 SUB SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP SUB SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_882_0"%string, (equiv_checker [POP;Opcode SUB;SWAP 1] [DUP 3;DUP 3;Opcode SUB;SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 4 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_884_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 DUP2 ISZERO ISZERO SWAP1 POP SWAP2 SWAP1 POP
 O: ISZERO ISZERO SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_885_0"%string, (equiv_checker [Opcode ISZERO;Opcode ISZERO;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode ISZERO;Opcode ISZERO;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH FFFFFFFF00000000000000000000000000000000000000000000000000000000 DUP3 AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH ffffffff00000000000000000000000000000000000000000000000000000000 AND SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_886_0"%string, (equiv_checker [PUSH 32 (NToWord WLen 0xffffffff00000000000000000000000000000000000000000000000000000000%N);Opcode AND;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 32 (NToWord WLen 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000%N);DUP 3;Opcode AND;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP3 AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_887_0"%string, (equiv_checker [PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);DUP 3;Opcode AND;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH 0 DUP2 SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_888_0"%string, (equiv_checker [SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH 0 DUP4 DUP4 ADD
 O: PUSH 0 DUP3 DUP5 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_889_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 5;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 4;Opcode ADD] 3 optimize_id) ).

(*
 I: DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD
 O: DUP2 DUP2 ADD MLOAD DUP4 DUP3 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_892_0"%string, (equiv_checker [DUP 2;DUP 2;Opcode ADD;Opcode MLOAD;DUP 4;DUP 3;Opcode ADD] [DUP 1;DUP 3;Opcode ADD;Opcode MLOAD;DUP 2;DUP 5;Opcode ADD] 3 optimize_id) ).

(*
 I: PUSH 20 DUP2 ADD SWAP1 POP PUSH [tag] 882
 O: PUSH 20 ADD PUSH [tag] 882
*)
Compute ( "BottleCastle_run_code_of_0_block_892_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x372%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x372%N)] 1 optimize_id) ).

(*
 I: PUSH 0 DUP5 DUP5 ADD
 O: PUSH 0 DUP4 DUP6 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_894_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 6;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);DUP 5;DUP 5;Opcode ADD] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH 2 DUP3 DIV SWAP1 POP PUSH 1 DUP3 AND DUP1 PUSH [tag] 887
 O: PUSH 2 DUP2 DIV DUP2 PUSH 1 AND DUP1 PUSH [tag] 887
*)
Compute ( "BottleCastle_run_code_of_0_block_896_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x2%N);DUP 2;Opcode DIV;DUP 2;PUSH 1 (NToWord WLen 0x1%N);Opcode AND;DUP 1;PUSH 2 (NToWord WLen 0x377%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x2%N);DUP 3;Opcode DIV;SWAP 1;POP;PUSH 1 (NToWord WLen 0x1%N);DUP 3;Opcode AND;DUP 1;PUSH 2 (NToWord WLen 0x377%N)] 1 optimize_id) ).

(*
 I: PUSH 7F DUP3 AND SWAP2 POP
 O: SWAP1 PUSH 7f AND SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_897_0"%string, (equiv_checker [SWAP 1;PUSH 1 (NToWord WLen 0x7f%N);Opcode AND;SWAP 1] [PUSH 1 (NToWord WLen 0x7F%N);DUP 3;Opcode AND;SWAP 2;POP] 2 optimize_id) ).

(*
 I: PUSH 20 DUP3 LT DUP2 EQ ISZERO PUSH [tag] 888
 O: DUP1 PUSH 20 DUP4 LT EQ ISZERO PUSH [tag] 888
*)
Compute ( "BottleCastle_run_code_of_0_block_898_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode LT;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x378%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode LT;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x378%N)] 2 optimize_id) ).

(*
 I: DUP2 ADD DUP2 DUP2 LT PUSH FFFFFFFFFFFFFFFF DUP3 GT OR ISZERO PUSH [tag] 893
 O: DUP2 ADD PUSH ffffffffffffffff DUP2 GT DUP3 DUP3 LT OR ISZERO PUSH [tag] 893
*)
Compute ( "BottleCastle_run_code_of_0_block_903_0"%string, (equiv_checker [DUP 2;Opcode ADD;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);DUP 2;Opcode GT;DUP 3;DUP 3;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 2 (NToWord WLen 0x37d%N)] [DUP 2;Opcode ADD;DUP 2;DUP 2;Opcode LT;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);DUP 3;Opcode GT;Opcode OR;Opcode ISZERO;PUSH 2 (NToWord WLen 0x37d%N)] 2 optimize_id) ).

(*
 I: PUSH 1 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 1 ADD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_911_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x1%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 3 optimize_id) ).

(*
 I: DUP3 DUP3 MOD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP MOD SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_917_0"%string, (equiv_checker [POP;Opcode MOD;SWAP 1] [DUP 3;DUP 3;Opcode MOD;SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH 1F NOT PUSH 1F DUP4 ADD AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 1f ADD PUSH 1f NOT AND SWAP1
*)
Compute ( "BottleCastle_run_code_of_0_block_927_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;PUSH 1 (NToWord WLen 0x1f%N);Opcode NOT;Opcode AND;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;Opcode AND;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH 455243373231414D657461646174613A2055524920717565727920666F72206E PUSH 0 DUP3 ADD
 O: PUSH 455243373231414d657461646174613a2055524920717565727920666f72206e DUP2 PUSH 0 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_928_0"%string, (equiv_checker [PUSH 32 (NToWord WLen 0x455243373231414d657461646174613a2055524920717565727920666f72206e%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x455243373231414D657461646174613A2055524920717565727920666F72206E%N);PUSH 1 (NToWord WLen 0x0%N);DUP 3;Opcode ADD] 1 optimize_id) ).

(*
 I: PUSH 6F6E6578697374656E7420746F6B656E00000000000000000000000000000000 PUSH 20 DUP3 ADD
 O: PUSH 6f6e6578697374656e7420746f6b656e00000000000000000000000000000000 DUP2 PUSH 20 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_928_1"%string, (equiv_checker [PUSH 32 (NToWord WLen 0x6f6e6578697374656e7420746f6b656e00000000000000000000000000000000%N);DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x6F6E6578697374656E7420746F6B656E00000000000000000000000000000000%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD] 1 optimize_id) ).

(*
 I: PUSH 4F776E61626C653A206E6577206F776E657220697320746865207A65726F2061 PUSH 0 DUP3 ADD
 O: PUSH 4f776e61626c653a206e6577206f776e657220697320746865207a65726f2061 DUP2 PUSH 0 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_929_0"%string, (equiv_checker [PUSH 32 (NToWord WLen 0x4f776e61626c653a206e6577206f776e657220697320746865207a65726f2061%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x4F776E61626C653A206E6577206F776E657220697320746865207A65726F2061%N);PUSH 1 (NToWord WLen 0x0%N);DUP 3;Opcode ADD] 1 optimize_id) ).

(*
 I: PUSH 6464726573730000000000000000000000000000000000000000000000000000 PUSH 20 DUP3 ADD
 O: PUSH 6464726573730000000000000000000000000000000000000000000000000000 DUP2 PUSH 20 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_929_1"%string, (equiv_checker [PUSH 32 (NToWord WLen 0x6464726573730000000000000000000000000000000000000000000000000000%N);DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x6464726573730000000000000000000000000000000000000000000000000000%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD] 1 optimize_id) ).

(*
 I: PUSH 576520536F6C646F757400000000000000000000000000000000000000000000 PUSH 0 DUP3 ADD
 O: PUSH 576520536f6c646f757400000000000000000000000000000000000000000000 DUP2 PUSH 0 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_930_0"%string, (equiv_checker [PUSH 32 (NToWord WLen 0x576520536f6c646f757400000000000000000000000000000000000000000000%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x576520536F6C646F757400000000000000000000000000000000000000000000%N);PUSH 1 (NToWord WLen 0x0%N);DUP 3;Opcode ADD] 1 optimize_id) ).

(*
 I: PUSH 6F6F707320636F6E747261637420697320706175736564000000000000000000 PUSH 0 DUP3 ADD
 O: PUSH 6f6f707320636f6e747261637420697320706175736564000000000000000000 DUP2 PUSH 0 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_931_0"%string, (equiv_checker [PUSH 32 (NToWord WLen 0x6f6f707320636f6e747261637420697320706175736564000000000000000000%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x6F6F707320636F6E747261637420697320706175736564000000000000000000%N);PUSH 1 (NToWord WLen 0x0%N);DUP 3;Opcode ADD] 1 optimize_id) ).

(*
 I: PUSH 6D6178204E4654206C696D697420657863656564656400000000000000000000 PUSH 0 DUP3 ADD
 O: PUSH 6d6178204e4654206c696d697420657863656564656400000000000000000000 DUP2 PUSH 0 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_932_0"%string, (equiv_checker [PUSH 32 (NToWord WLen 0x6d6178204e4654206c696d697420657863656564656400000000000000000000%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x6D6178204E4654206C696D697420657863656564656400000000000000000000%N);PUSH 1 (NToWord WLen 0x0%N);DUP 3;Opcode ADD] 1 optimize_id) ).

(*
 I: PUSH 4F776E61626C653A2063616C6C6572206973206E6F7420746865206F776E6572 PUSH 0 DUP3 ADD
 O: PUSH 4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572 DUP2 PUSH 0 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_933_0"%string, (equiv_checker [PUSH 32 (NToWord WLen 0x4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x4F776E61626C653A2063616C6C6572206973206E6F7420746865206F776E6572%N);PUSH 1 (NToWord WLen 0x0%N);DUP 3;Opcode ADD] 1 optimize_id) ).

(*
 I: PUSH 696E73756666696369656E742066756E64730000000000000000000000000000 PUSH 0 DUP3 ADD
 O: PUSH 696e73756666696369656e742066756e64730000000000000000000000000000 DUP2 PUSH 0 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_934_0"%string, (equiv_checker [PUSH 32 (NToWord WLen 0x696e73756666696369656e742066756e64730000000000000000000000000000%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x696E73756666696369656E742066756E64730000000000000000000000000000%N);PUSH 1 (NToWord WLen 0x0%N);DUP 3;Opcode ADD] 1 optimize_id) ).

(*
 I: PUSH 4D6178204E4654205065722057616C6C65742065786365656465640000000000 PUSH 0 DUP3 ADD
 O: PUSH 4d6178204e4654205065722057616c6c65742065786365656465640000000000 DUP2 PUSH 0 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_935_0"%string, (equiv_checker [PUSH 32 (NToWord WLen 0x4d6178204e4654205065722057616c6c65742065786365656465640000000000%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x4D6178204E4654205065722057616C6C65742065786365656465640000000000%N);PUSH 1 (NToWord WLen 0x0%N);DUP 3;Opcode ADD] 1 optimize_id) ).

(*
 I: PUSH 5265656E7472616E637947756172643A207265656E7472616E742063616C6C00 PUSH 0 DUP3 ADD
 O: PUSH 5265656e7472616e637947756172643a207265656e7472616e742063616c6c00 DUP2 PUSH 0 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_936_0"%string, (equiv_checker [PUSH 32 (NToWord WLen 0x5265656e7472616e637947756172643a207265656e7472616e742063616c6c00%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x5265656E7472616E637947756172643A207265656E7472616E742063616C6C00%N);PUSH 1 (NToWord WLen 0x0%N);DUP 3;Opcode ADD] 1 optimize_id) ).

(*
 I: PUSH 6D6178206D696E7420616D6F756E742070657220747820657863656564656400 PUSH 0 DUP3 ADD
 O: PUSH 6d6178206d696e7420616d6f756e742070657220747820657863656564656400 DUP2 PUSH 0 ADD
*)
Compute ( "BottleCastle_run_code_of_0_block_937_0"%string, (equiv_checker [PUSH 32 (NToWord WLen 0x6d6178206d696e7420616d6f756e742070657220747820657863656564656400%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x6D6178206D696E7420616D6F756E742070657220747820657863656564656400%N);PUSH 1 (NToWord WLen 0x0%N);DUP 3;Opcode ADD] 1 optimize_id) ).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 1
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 1
*)
Compute ( "ERC721A_initial_block_0_1"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1%N)] 0 optimize_id) ).

(*
 I: DUP2 DUP2 ADD PUSH 40
 O: DUP1 DUP3 ADD PUSH 40
*)
Compute ( "ERC721A_initial_block_2_1"%string, (equiv_checker [DUP 1;DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 2;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 2 optimize_id) ).

(*
 I: DUP2 ADD SWAP1 PUSH [tag] 2 SWAP2 SWAP1 PUSH [tag] 3
 O: DUP2 ADD PUSH [tag] 2 SWAP2 PUSH [tag] 3
*)
Compute ( "ERC721A_initial_block_2_2"%string, (equiv_checker [DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x2%N);SWAP 2;PUSH 1 (NToWord WLen 0x3%N)] [DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x2%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x3%N)] 2 optimize_id) ).

(*
 I: DUP2 PUSH 2 SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 6 SWAP3 SWAP2 SWAP1 PUSH [tag] 7
 O: PUSH [tag] 6 PUSH 2 DUP4 PUSH 20 ADD DUP5 MLOAD PUSH [tag] 7
*)
Compute ( "ERC721A_initial_block_3_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x6%N);PUSH 1 (NToWord WLen 0x2%N);DUP 4;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 5;Opcode MLOAD;PUSH 1 (NToWord WLen 0x7%N)] [DUP 2;PUSH 1 (NToWord WLen 0x2%N);SWAP 1;DUP 1;Opcode MLOAD;SWAP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x6%N);SWAP 3;SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x7%N)] 2 optimize_id) ).

(*
 I: POP DUP1 PUSH 3 SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 8 SWAP3 SWAP2 SWAP1 PUSH [tag] 7
 O: POP PUSH [tag] 8 PUSH 3 PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 7
*)
Compute ( "ERC721A_initial_block_4_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x8%N);PUSH 1 (NToWord WLen 0x3%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 1 (NToWord WLen 0x7%N)] [POP;DUP 1;PUSH 1 (NToWord WLen 0x3%N);SWAP 1;DUP 1;Opcode MLOAD;SWAP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x8%N);SWAP 3;SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x7%N)] 2 optimize_id) ).

(*
 I: PUSH 0 DUP2 SWAP1
 O: DUP1 PUSH 0
*)
Compute ( "ERC721A_initial_block_6_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;SWAP 1] 1 optimize_id) ).

(*
 I: DUP3 DUP1 SLOAD PUSH [tag] 13 SWAP1 PUSH [tag] 14
 O: DUP3 PUSH [tag] 13 DUP5 SLOAD PUSH [tag] 14
*)
Compute ( "ERC721A_initial_block_8_0"%string, (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0xd%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0xe%N)] [DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xd%N);SWAP 1;PUSH 1 (NToWord WLen 0xe%N)] 3 optimize_id) ).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1 PUSH 1F ADD PUSH 20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 16
 O: PUSH 20 DUP1 PUSH 0 KECCAK256 SWAP2 PUSH 1f ADD DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 16
*)
Compute ( "ERC721A_initial_block_9_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;SWAP 2;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode DIV;DUP 2;Opcode ADD;SWAP 3;DUP 3;PUSH 1 (NToWord WLen 0x10%N)] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;SWAP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);SWAP 1;Opcode DIV;DUP 2;Opcode ADD;SWAP 3;DUP 3;PUSH 1 (NToWord WLen 0x10%N)] 3 optimize_id) ).

(*
 I: DUP1 MLOAD PUSH FF NOT AND DUP4 DUP1 ADD OR DUP6
 O: DUP3 DUP1 ADD PUSH ff NOT DUP3 MLOAD AND OR DUP6
*)
Compute ( "ERC721A_initial_block_12_0"%string, (equiv_checker [DUP 3;DUP 1;Opcode ADD;PUSH 1 (NToWord WLen 0xff%N);Opcode NOT;DUP 3;Opcode MLOAD;Opcode AND;Opcode OR;DUP 6] [DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0xFF%N);Opcode NOT;Opcode AND;DUP 4;DUP 1;Opcode ADD;Opcode OR;DUP 6] 5 optimize_id) ).

(*
 I: DUP3 DUP1 ADD PUSH 1 ADD DUP6
 O: DUP3 DUP4 ADD PUSH 1 ADD DUP6
*)
Compute ( "ERC721A_initial_block_13_0"%string, (equiv_checker [DUP 3;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 6] [DUP 3;DUP 1;Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 6] 5 optimize_id) ).

(*
 I: SWAP2 DUP3 ADD
 O: DUP1 SWAP3 ADD
*)
Compute ( "ERC721A_initial_block_14_0"%string, (equiv_checker [DUP 1;SWAP 3;Opcode ADD] [SWAP 2;DUP 3;Opcode ADD] 3 optimize_id) ).

(*
 I: POP SWAP1 POP PUSH [tag] 20 SWAP2 SWAP1 PUSH [tag] 21
 O: POP PUSH [tag] 20 SWAP3 SWAP2 POP PUSH [tag] 21
*)
Compute ( "ERC721A_initial_block_18_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x14%N);SWAP 3;SWAP 2;POP;PUSH 1 (NToWord WLen 0x15%N)] [POP;SWAP 1;POP;PUSH 1 (NToWord WLen 0x14%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x15%N)] 4 optimize_id) ).

(*
 I: PUSH 0 DUP2 PUSH 0 SWAP1
 O: PUSH 0 DUP1 DUP3
*)
Compute ( "ERC721A_initial_block_22_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 3] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 20 DUP2 ADD DUP5 DUP5 DUP5 ADD GT ISZERO PUSH [tag] 31
 O: DUP1 PUSH 20 ADD DUP5 DUP4 DUP6 ADD GT ISZERO PUSH [tag] 31
*)
Compute ( "ERC721A_initial_block_26_1"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 5;DUP 4;DUP 6;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1f%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;DUP 5;DUP 5;DUP 5;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1f%N)] 4 optimize_id) ).

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 38
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 38
*)
Compute ( "ERC721A_initial_block_31_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode SLT;PUSH 1 (NToWord WLen 0x26%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;Opcode SLT;PUSH 1 (NToWord WLen 0x26%N)] 2 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute ( "ERC721A_initial_block_35_0"%string, (equiv_checker [SWAP 5;SWAP 4;POP;POP;POP;POP] [SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: PUSH 0 DUP4 ADD MLOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 46
 O: DUP3 PUSH 0 ADD MLOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 46
*)
Compute ( "ERC721A_initial_block_39_0"%string, (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;Opcode MLOAD;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x2e%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD;Opcode MLOAD;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x2e%N)] 3 optimize_id) ).

(*
 I: SWAP3 POP POP PUSH 20 DUP4 ADD MLOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 50
 O: SWAP3 POP POP DUP3 PUSH 20 ADD MLOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 50
*)
Compute ( "ERC721A_initial_block_43_0"%string, (equiv_checker [SWAP 3;POP;POP;DUP 3;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;Opcode MLOAD;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x32%N)] [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;Opcode MLOAD;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x32%N)] 5 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute ( "ERC721A_initial_block_47_0"%string, (equiv_checker [SWAP 5;POP;POP;POP;SWAP 3;SWAP 1;POP] [SWAP 2;POP;POP;SWAP 3;POP;SWAP 3;SWAP 1;POP] 7 optimize_id) ).

(*
 I: PUSH 0 PUSH 40 MLOAD SWAP1 POP SWAP1
 O: PUSH 40 MLOAD SWAP1
*)
Compute ( "ERC721A_initial_block_51_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1;POP;SWAP 1] 1 optimize_id) ).

(*
 I: SWAP1 POP PUSH 20 DUP2 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP2 POP POP SWAP1
*)
Compute ( "ERC721A_initial_block_56_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD
 O: DUP2 DUP2 ADD MLOAD DUP4 DUP3 ADD
*)
Compute ( "ERC721A_initial_block_59_0"%string, (equiv_checker [DUP 2;DUP 2;Opcode ADD;Opcode MLOAD;DUP 4;DUP 3;Opcode ADD] [DUP 1;DUP 3;Opcode ADD;Opcode MLOAD;DUP 2;DUP 5;Opcode ADD] 3 optimize_id) ).

(*
 I: PUSH 20 DUP2 ADD SWAP1 POP PUSH [tag] 66
 O: PUSH 20 ADD PUSH [tag] 66
*)
Compute ( "ERC721A_initial_block_59_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x42%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;SWAP 1;POP;PUSH 1 (NToWord WLen 0x42%N)] 1 optimize_id) ).

(*
 I: PUSH 0 DUP5 DUP5 ADD
 O: PUSH 0 DUP4 DUP6 ADD
*)
Compute ( "ERC721A_initial_block_61_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 6;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);DUP 5;DUP 5;Opcode ADD] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH 2 DUP3 DIV SWAP1 POP PUSH 1 DUP3 AND DUP1 PUSH [tag] 71
 O: PUSH 2 DUP2 DIV DUP2 PUSH 1 AND DUP1 PUSH [tag] 71
*)
Compute ( "ERC721A_initial_block_63_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x2%N);DUP 2;Opcode DIV;DUP 2;PUSH 1 (NToWord WLen 0x1%N);Opcode AND;DUP 1;PUSH 1 (NToWord WLen 0x47%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x2%N);DUP 3;Opcode DIV;SWAP 1;POP;PUSH 1 (NToWord WLen 0x1%N);DUP 3;Opcode AND;DUP 1;PUSH 1 (NToWord WLen 0x47%N)] 1 optimize_id) ).

(*
 I: PUSH 7F DUP3 AND SWAP2 POP
 O: SWAP1 PUSH 7f AND SWAP1
*)
Compute ( "ERC721A_initial_block_64_0"%string, (equiv_checker [SWAP 1;PUSH 1 (NToWord WLen 0x7f%N);Opcode AND;SWAP 1] [PUSH 1 (NToWord WLen 0x7F%N);DUP 3;Opcode AND;SWAP 2;POP] 2 optimize_id) ).

(*
 I: PUSH 20 DUP3 LT DUP2 EQ ISZERO PUSH [tag] 72
 O: DUP1 PUSH 20 DUP4 LT EQ ISZERO PUSH [tag] 72
*)
Compute ( "ERC721A_initial_block_65_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode LT;Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0x48%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode LT;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0x48%N)] 2 optimize_id) ).

(*
 I: DUP2 ADD DUP2 DUP2 LT PUSH FFFFFFFFFFFFFFFF DUP3 GT OR ISZERO PUSH [tag] 77
 O: DUP2 ADD PUSH ffffffffffffffff DUP2 GT DUP3 DUP3 LT OR ISZERO PUSH [tag] 77
*)
Compute ( "ERC721A_initial_block_70_0"%string, (equiv_checker [DUP 2;Opcode ADD;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);DUP 2;Opcode GT;DUP 3;DUP 3;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4d%N)] [DUP 2;Opcode ADD;DUP 2;DUP 2;Opcode LT;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);DUP 3;Opcode GT;Opcode OR;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4d%N)] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH 1F NOT PUSH 1F DUP4 ADD AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 1f ADD PUSH 1f NOT AND SWAP1
*)
Compute ( "ERC721A_initial_block_80_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;PUSH 1 (NToWord WLen 0x1f%N);Opcode NOT;Opcode AND;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;Opcode AND;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH #[$] 0000000000000000000000000000000000000000000000000000000000000000 DUP1 PUSH [$] 0000000000000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH #[$] 0 DUP1 PUSH [$] 0 PUSH 0
  ERROR OCCURRED

'PUSH #[$]' is not in list
*)

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 1
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 1
*)
Compute ( "ERC721A_run_code_of_0_block_0_1"%string, (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1%N)] 0 optimize_id) ).

(*
 I: PUSH [tag] 20 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 21 SWAP2 SWAP1 PUSH [tag] 22
 O: PUSH [tag] 20 PUSH [tag] 21 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 22
*)
Compute ( "ERC721A_run_code_of_0_block_24_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x14%N);PUSH 1 (NToWord WLen 0x15%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x16%N)] [PUSH 1 (NToWord WLen 0x14%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x15%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x16%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 24 SWAP2 SWAP1 PUSH [tag] 25
 O: PUSH [tag] 24 SWAP1 PUSH 40 MLOAD PUSH [tag] 25
*)
Compute ( "ERC721A_run_code_of_0_block_26_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x18%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x19%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x18%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x19%N)] 1 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 28 SWAP2 SWAP1 PUSH [tag] 29
 O: PUSH [tag] 28 SWAP1 PUSH 40 MLOAD PUSH [tag] 29
*)
Compute ( "ERC721A_run_code_of_0_block_29_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1c%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x1d%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x1c%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x1d%N)] 1 optimize_id) ).

(*
 I: PUSH [tag] 30 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 31 SWAP2 SWAP1 PUSH [tag] 32
 O: PUSH [tag] 30 PUSH [tag] 31 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 32
*)
Compute ( "ERC721A_run_code_of_0_block_31_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1e%N);PUSH 1 (NToWord WLen 0x1f%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x1e%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x1f%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 34 SWAP2 SWAP1 PUSH [tag] 35
 O: PUSH [tag] 34 SWAP1 PUSH 40 MLOAD PUSH [tag] 35
*)
Compute ( "ERC721A_run_code_of_0_block_33_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x22%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x23%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x22%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x23%N)] 1 optimize_id) ).

(*
 I: PUSH [tag] 36 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 37 SWAP2 SWAP1 PUSH [tag] 38
 O: PUSH [tag] 36 PUSH [tag] 37 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 38
*)
Compute ( "ERC721A_run_code_of_0_block_35_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x25%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x26%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x25%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x26%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 42 SWAP2 SWAP1 PUSH [tag] 43
 O: PUSH [tag] 42 SWAP1 PUSH 40 MLOAD PUSH [tag] 43
*)
Compute ( "ERC721A_run_code_of_0_block_39_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x2a%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x2b%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x2a%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x2b%N)] 1 optimize_id) ).

(*
 I: PUSH [tag] 44 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 45 SWAP2 SWAP1 PUSH [tag] 46
 O: PUSH [tag] 44 PUSH [tag] 45 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 46
*)
Compute ( "ERC721A_run_code_of_0_block_41_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x2c%N);PUSH 1 (NToWord WLen 0x2d%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x2e%N)] [PUSH 1 (NToWord WLen 0x2c%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x2d%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x2e%N)] 0 optimize_id) ).

(*
 I: PUSH [tag] 48 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 49 SWAP2 SWAP1 PUSH [tag] 46
 O: PUSH [tag] 48 PUSH [tag] 49 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 46
*)
Compute ( "ERC721A_run_code_of_0_block_44_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x30%N);PUSH 1 (NToWord WLen 0x31%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x2e%N)] [PUSH 1 (NToWord WLen 0x30%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x31%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x2e%N)] 0 optimize_id) ).

(*
 I: PUSH [tag] 51 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 52 SWAP2 SWAP1 PUSH [tag] 32
 O: PUSH [tag] 51 PUSH [tag] 52 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 32
*)
Compute ( "ERC721A_run_code_of_0_block_47_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x33%N);PUSH 1 (NToWord WLen 0x34%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x33%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x34%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 54 SWAP2 SWAP1 PUSH [tag] 35
 O: PUSH [tag] 54 SWAP1 PUSH 40 MLOAD PUSH [tag] 35
*)
Compute ( "ERC721A_run_code_of_0_block_49_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x36%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x23%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x36%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x23%N)] 1 optimize_id) ).

(*
 I: PUSH [tag] 55 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 56 SWAP2 SWAP1 PUSH [tag] 57
 O: PUSH [tag] 55 PUSH [tag] 56 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 57
*)
Compute ( "ERC721A_run_code_of_0_block_51_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x37%N);PUSH 1 (NToWord WLen 0x38%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x39%N)] [PUSH 1 (NToWord WLen 0x37%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x38%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x39%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 59 SWAP2 SWAP1 PUSH [tag] 43
 O: PUSH [tag] 59 SWAP1 PUSH 40 MLOAD PUSH [tag] 43
*)
Compute ( "ERC721A_run_code_of_0_block_53_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x3b%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x2b%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x3b%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x2b%N)] 1 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 62 SWAP2 SWAP1 PUSH [tag] 29
 O: PUSH [tag] 62 SWAP1 PUSH 40 MLOAD PUSH [tag] 29
*)
Compute ( "ERC721A_run_code_of_0_block_56_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x3e%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x1d%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x3e%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x1d%N)] 1 optimize_id) ).

(*
 I: PUSH [tag] 63 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 64 SWAP2 SWAP1 PUSH [tag] 65
 O: PUSH [tag] 63 PUSH [tag] 64 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 65
*)
Compute ( "ERC721A_run_code_of_0_block_58_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x3f%N);PUSH 1 (NToWord WLen 0x40%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x41%N)] [PUSH 1 (NToWord WLen 0x3f%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x40%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x41%N)] 0 optimize_id) ).

(*
 I: PUSH [tag] 67 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 68 SWAP2 SWAP1 PUSH [tag] 69
 O: PUSH [tag] 67 PUSH [tag] 68 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 69
*)
Compute ( "ERC721A_run_code_of_0_block_61_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x43%N);PUSH 1 (NToWord WLen 0x44%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x45%N)] [PUSH 1 (NToWord WLen 0x43%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x44%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x45%N)] 0 optimize_id) ).

(*
 I: PUSH [tag] 71 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 72 SWAP2 SWAP1 PUSH [tag] 32
 O: PUSH [tag] 71 PUSH [tag] 72 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 32
*)
Compute ( "ERC721A_run_code_of_0_block_64_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x47%N);PUSH 1 (NToWord WLen 0x48%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x47%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x48%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 74 SWAP2 SWAP1 PUSH [tag] 29
 O: PUSH [tag] 74 SWAP1 PUSH 40 MLOAD PUSH [tag] 29
*)
Compute ( "ERC721A_run_code_of_0_block_66_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x4a%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x1d%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x4a%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x1d%N)] 1 optimize_id) ).

(*
 I: PUSH [tag] 75 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 76 SWAP2 SWAP1 PUSH [tag] 77
 O: PUSH [tag] 75 PUSH [tag] 76 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 77
*)
Compute ( "ERC721A_run_code_of_0_block_68_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x4b%N);PUSH 1 (NToWord WLen 0x4c%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x4d%N)] [PUSH 1 (NToWord WLen 0x4b%N);PUSH 1 (NToWord WLen 0x4%N);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0x4c%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x4d%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH [tag] 79 SWAP2 SWAP1 PUSH [tag] 25
 O: PUSH [tag] 79 SWAP1 PUSH 40 MLOAD PUSH [tag] 25
*)
Compute ( "ERC721A_run_code_of_0_block_70_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x4f%N);SWAP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x19%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x4f%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x19%N)] 1 optimize_id) ).

(*
 I: PUSH 0 PUSH 1FFC9A7 PUSH E0 SHL DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ DUP1 PUSH [tag] 81
 O: PUSH 0 PUSH 1ffc9a7 PUSH e0 SHL PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT DUP4 AND EQ DUP1 PUSH [tag] 81
*)
Compute ( "ERC721A_run_code_of_0_block_72_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 4 (NToWord WLen 0x1ffc9a7%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 28 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff%N);Opcode NOT;DUP 4;Opcode AND;Opcode EQ;DUP 1;PUSH 1 (NToWord WLen 0x51%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 4 (NToWord WLen 0x1FFC9A7%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;DUP 3;PUSH 28 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode NOT;Opcode AND;Opcode EQ;DUP 1;PUSH 1 (NToWord WLen 0x51%N)] 1 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_76_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 60 PUSH 2 DUP1 SLOAD PUSH [tag] 84 SWAP1 PUSH [tag] 85
 O: PUSH 60 PUSH 2 PUSH [tag] 84 DUP2 SLOAD PUSH [tag] 85
*)
Compute ( "ERC721A_run_code_of_0_block_77_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0x54%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0x55%N)] [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x2%N);DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x54%N);SWAP 1;PUSH 1 (NToWord WLen 0x55%N)] 0 optimize_id) ).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute ( "ERC721A_run_code_of_0_block_78_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x1f%N);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;SWAP 2;Opcode DIV;Opcode MUL;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 1 optimize_id) ).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute ( "ERC721A_run_code_of_0_block_78_1"%string, (equiv_checker [SWAP 2;SWAP 1;DUP 3;DUP 2;DUP 5] [DUP 1;SWAP 3;SWAP 2;SWAP 1;DUP 2;DUP 2] 3 optimize_id) ).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 86 SWAP1 PUSH [tag] 85
 O: PUSH 20 ADD DUP3 PUSH [tag] 86 DUP5 SLOAD PUSH [tag] 85
*)
Compute ( "ERC721A_run_code_of_0_block_78_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;PUSH 1 (NToWord WLen 0x56%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0x55%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x56%N);SWAP 1;PUSH 1 (NToWord WLen 0x55%N)] 3 optimize_id) ).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute ( "ERC721A_run_code_of_0_block_84_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);DUP 4;DUP 5;SWAP 3;Opcode SUB;Opcode AND;Opcode ADD;SWAP 2] [DUP 3;SWAP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x1F%N);Opcode AND;DUP 3;Opcode ADD;SWAP 2] 3 optimize_id) ).

(*
 I: POP POP POP POP POP SWAP1 POP SWAP1
 O: POP POP POP POP POP SWAP2 SWAP1 POP
*)
Compute ( "ERC721A_run_code_of_0_block_85_0"%string, (equiv_checker [POP;POP;POP;POP;POP;SWAP 2;SWAP 1;POP] [POP;POP;POP;POP;POP;SWAP 1;POP;SWAP 1] 8 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_88_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 ADD PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 SWAP2 POP ADD PUSH 0 SWAP1 DUP2 DUP1 PUSH 100 EXP SWAP4 POP KECCAK256 ADD SLOAD DIV PUSH ffffffffffffffffffffffffffffffffffffffff AND SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_89_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);SWAP 2;POP;Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);SWAP 1;DUP 2;DUP 1;PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;SWAP 4;POP;Opcode KECCAK256;Opcode ADD;Opcode SLOAD;Opcode DIV;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);SWAP 1;Opcode SLOAD;SWAP 1;PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;SWAP 1;Opcode DIV;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: SWAP1 POP DUP1 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH [tag] 96 PUSH [tag] 97
 O: DUP1 SWAP2 POP PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH [tag] 96 PUSH [tag] 97
*)
Compute ( "ERC721A_run_code_of_0_block_91_0"%string, (equiv_checker [DUP 1;SWAP 2;POP;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x61%N)] [SWAP 1;POP;DUP 1;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x61%N)] 2 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_96_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 ADD PUSH 0 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF MUL NOT AND SWAP1 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND MUL OR SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 ADD PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 PUSH 100 EXP DUP3 SLOAD DUP2 DUP4 MUL NOT AND SWAP2 DUP5 AND MUL OR SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_98_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;DUP 3;Opcode SLOAD;DUP 2;DUP 4;Opcode MUL;Opcode NOT;Opcode AND;SWAP 2;DUP 5;Opcode AND;Opcode MUL;Opcode OR;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode MUL;Opcode NOT;Opcode AND;SWAP 1;DUP 4;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;Opcode MUL;Opcode OR;SWAP 1] 2 optimize_id) ).

(*
 I: POP DUP2 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B925 PUSH 40 MLOAD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: POP PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 40 MLOAD DUP5 DUP3 AND PUSH 8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925 DUP3 DUP1 SUB DUP6 DUP8 SWAP6 AND SWAP3 SWAP4
*)
Compute ( "ERC721A_run_code_of_0_block_98_3"%string, (equiv_checker [POP;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 5;DUP 3;Opcode AND;PUSH 32 (NToWord WLen 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925%N);DUP 3;DUP 1;Opcode SUB;DUP 6;DUP 8;SWAP 6;Opcode AND;SWAP 3;SWAP 4] [POP;DUP 2;DUP 4;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 3;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 32 (NToWord WLen 0x8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B925%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 4 optimize_id) ).

(*
 I: PUSH 1 SLOAD PUSH 0 SLOAD SUB SUB SWAP1 POP SWAP1
 O: PUSH 1 SLOAD PUSH 0 SLOAD SUB SUB SWAP2 SWAP1 POP
*)
Compute ( "ERC721A_run_code_of_0_block_100_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;Opcode SUB;Opcode SUB;SWAP 2;SWAP 1;POP] [PUSH 1 (NToWord WLen 0x1%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;Opcode SUB;Opcode SUB;SWAP 1;POP;SWAP 1] 3 optimize_id) ).

(*
 I: SWAP1 POP DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ PUSH [tag] 108
 O: SWAP1 POP DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 AND EQ PUSH [tag] 108
*)
Compute ( "ERC721A_run_code_of_0_block_102_0"%string, (equiv_checker [SWAP 1;POP;DUP 4;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 3;Opcode AND;Opcode EQ;PUSH 1 (NToWord WLen 0x6c%N)] [SWAP 1;POP;DUP 4;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 2;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;Opcode EQ;PUSH 1 (NToWord WLen 0x6c%N)] 5 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_103_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_111_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 118
 O: PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 AND PUSH ffffffffffffffffffffffffffffffffffffffff DUP7 AND EQ ISZERO PUSH [tag] 118
*)
Compute ( "ERC721A_run_code_of_0_block_113_0"%string, (equiv_checker [PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);PUSH 1 (NToWord WLen 0x0%N);Opcode AND;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 7;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0x76%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 6;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0x76%N)] 5 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_114_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 5 PUSH 0 DUP8 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 5 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP9 AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Compute ( "ERC721A_run_code_of_0_block_118_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 9;Opcode AND;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x0%N);DUP 8;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 2] 6 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP2 SLOAD PUSH 1 SWAP1 SUB SWAP2 SWAP1 POP DUP2 SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 1 DUP2 SLOAD SUB DUP1 SWAP2
*)
Compute ( "ERC721A_run_code_of_0_block_118_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x1%N);DUP 2;Opcode SLOAD;Opcode SUB;DUP 1;SWAP 2] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);SWAP 1;Opcode SUB;SWAP 2;SWAP 1;POP;DUP 2;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP2 SLOAD PUSH 1 ADD SWAP2 SWAP1 POP DUP2 SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 1 DUP2 SLOAD ADD DUP1 SWAP2
*)
Compute ( "ERC721A_run_code_of_0_block_118_5"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x1%N);DUP 2;Opcode SLOAD;Opcode ADD;DUP 1;SWAP 2] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;SWAP 2;SWAP 1;POP;DUP 2;SWAP 1] 1 optimize_id) ).

(*
 I: POP PUSH [tag] 122 DUP6 PUSH [tag] 123 DUP9 DUP9 DUP8 PUSH [tag] 124
 O: POP PUSH [tag] 122 DUP6 PUSH [tag] 123 DUP9 DUP3 DUP8 PUSH [tag] 124
*)
Compute ( "ERC721A_run_code_of_0_block_118_6"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x7a%N);DUP 6;PUSH 1 (NToWord WLen 0x7b%N);DUP 9;DUP 3;DUP 8;PUSH 1 (NToWord WLen 0x7c%N)] [POP;PUSH 1 (NToWord WLen 0x7a%N);DUP 6;PUSH 1 (NToWord WLen 0x7b%N);DUP 9;DUP 9;DUP 8;PUSH 1 (NToWord WLen 0x7c%N)] 7 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 DUP2 SWAP1
 O: DUP2 SWAP1 PUSH 20 ADD PUSH 0 KECCAK256
*)
Compute ( "ERC721A_run_code_of_0_block_120_2"%string, (equiv_checker [DUP 2;SWAP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 2;SWAP 1] 2 optimize_id) ).

(*
 I: POP PUSH 0 PUSH 200000000000000000000000000000000000000000000000000000000 DUP5 AND EQ ISZERO PUSH [tag] 126
 O: POP PUSH 200000000000000000000000000000000000000000000000000000000 DUP4 AND PUSH 0 EQ ISZERO PUSH [tag] 126
*)
Compute ( "ERC721A_run_code_of_0_block_120_3"%string, (equiv_checker [POP;PUSH 29 (NToWord WLen 0x200000000000000000000000000000000000000000000000000000000%N);DUP 4;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0x7e%N)] [POP;PUSH 1 (NToWord WLen 0x0%N);PUSH 29 (NToWord WLen 0x200000000000000000000000000000000000000000000000000000000%N);DUP 5;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0x7e%N)] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH 1 DUP6 ADD SWAP1 POP PUSH 0 PUSH 4 PUSH 0 DUP4 DUP2
 O: DUP4 PUSH 1 ADD PUSH 0 PUSH 4 DUP2 DUP4 DUP4
*)
Compute ( "ERC721A_run_code_of_0_block_121_0"%string, (equiv_checker [DUP 4;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x4%N);DUP 2;DUP 4;DUP 4] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x1%N);DUP 6;Opcode ADD;SWAP 1;POP;PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 2] 4 optimize_id) ).

(*
 I: PUSH 0 SLOAD DUP2 EQ PUSH [tag] 128
 O: DUP1 PUSH 0 SLOAD EQ PUSH [tag] 128
*)
Compute ( "ERC721A_run_code_of_0_block_122_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;Opcode EQ;PUSH 1 (NToWord WLen 0x80%N)] [PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 2;Opcode EQ;PUSH 1 (NToWord WLen 0x80%N)] 1 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 DUP2 SWAP1
 O: DUP2 SWAP1 PUSH 20 ADD PUSH 0 KECCAK256
*)
Compute ( "ERC721A_run_code_of_0_block_123_2"%string, (equiv_checker [DUP 2;SWAP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 2;SWAP 1] 2 optimize_id) ).

(*
 I: DUP4 DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP8 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH DDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF PUSH 40 MLOAD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH ffffffffffffffffffffffffffffffffffffffff DUP1 DUP7 AND DUP8 PUSH 40 MLOAD SWAP3 AND PUSH ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef DUP4 DUP1 SUB DUP9 SWAP5
*)
Compute ( "ERC721A_run_code_of_0_block_126_0"%string, (equiv_checker [PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 1;DUP 7;Opcode AND;DUP 8;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 3;Opcode AND;PUSH 32 (NToWord WLen 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef%N);DUP 4;DUP 1;Opcode SUB;DUP 9;SWAP 5] [DUP 4;DUP 6;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 8;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 32 (NToWord WLen 0xDDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 6 optimize_id) ).

(*
 I: PUSH [tag] 132 DUP4 DUP4 DUP4 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH [tag] 132 DUP4 DUP4 DUP4 PUSH 40 MLOAD PUSH 20 DUP2 ADD PUSH 40
*)
Compute ( "ERC721A_run_code_of_0_block_128_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x84%N);DUP 4;DUP 4;DUP 4;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [PUSH 1 (NToWord WLen 0x84%N);DUP 4;DUP 4;DUP 4;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 3 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_131_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 DUP1 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 136
 O: PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 AND DUP2 PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ ISZERO PUSH [tag] 136
*)
Compute ( "ERC721A_run_code_of_0_block_132_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 3;Opcode AND;DUP 2;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0x88%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 3;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0x88%N)] 1 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_133_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND SWAP2 POP POP SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_134_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;Opcode SLOAD;Opcode AND;SWAP 2;POP;POP;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;Opcode SLOAD;Opcode AND;SWAP 1;POP;SWAP 2;SWAP 1;POP] 5 optimize_id) ).

(*
 I: PUSH 60 PUSH 3 DUP1 SLOAD PUSH [tag] 138 SWAP1 PUSH [tag] 85
 O: PUSH 60 PUSH 3 PUSH [tag] 138 DUP2 SLOAD PUSH [tag] 85
*)
Compute ( "ERC721A_run_code_of_0_block_135_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x3%N);PUSH 1 (NToWord WLen 0x8a%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0x55%N)] [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x3%N);DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x8a%N);SWAP 1;PUSH 1 (NToWord WLen 0x55%N)] 0 optimize_id) ).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute ( "ERC721A_run_code_of_0_block_136_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x1f%N);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;SWAP 2;Opcode DIV;Opcode MUL;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 1 optimize_id) ).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute ( "ERC721A_run_code_of_0_block_136_1"%string, (equiv_checker [SWAP 2;SWAP 1;DUP 3;DUP 2;DUP 5] [DUP 1;SWAP 3;SWAP 2;SWAP 1;DUP 2;DUP 2] 3 optimize_id) ).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 139 SWAP1 PUSH [tag] 85
 O: PUSH 20 ADD DUP3 PUSH [tag] 139 DUP5 SLOAD PUSH [tag] 85
*)
Compute ( "ERC721A_run_code_of_0_block_136_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;PUSH 1 (NToWord WLen 0x8b%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0x55%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x8b%N);SWAP 1;PUSH 1 (NToWord WLen 0x55%N)] 3 optimize_id) ).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute ( "ERC721A_run_code_of_0_block_142_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);DUP 4;DUP 5;SWAP 3;Opcode SUB;Opcode AND;Opcode ADD;SWAP 2] [DUP 3;SWAP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x1F%N);Opcode AND;DUP 3;Opcode ADD;SWAP 2] 3 optimize_id) ).

(*
 I: POP POP POP POP POP SWAP1 POP SWAP1
 O: POP POP POP POP POP SWAP2 SWAP1 POP
*)
Compute ( "ERC721A_run_code_of_0_block_143_0"%string, (equiv_checker [POP;POP;POP;POP;POP;SWAP 2;SWAP 1;POP] [POP;POP;POP;POP;POP;SWAP 1;POP;SWAP 1] 8 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_146_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP5 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP1 DUP7 AND AND DUP2
*)
Compute ( "ERC721A_run_code_of_0_block_148_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 1;DUP 7;Opcode AND;Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);DUP 5;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 2] 4 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH 100 EXP PUSH ff DUP2 DUP5 ISZERO ISZERO MUL SWAP2 MUL NOT DUP3 SLOAD AND OR SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_148_4"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;PUSH 1 (NToWord WLen 0xff%N);DUP 2;DUP 5;Opcode ISZERO;Opcode ISZERO;Opcode MUL;SWAP 2;Opcode MUL;Opcode NOT;DUP 3;Opcode SLOAD;Opcode AND;Opcode OR;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 1 (NToWord WLen 0xFF%N);Opcode MUL;Opcode NOT;Opcode AND;SWAP 1;DUP 4;Opcode ISZERO;Opcode ISZERO;Opcode MUL;Opcode OR;SWAP 1] 2 optimize_id) ).

(*
 I: POP DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH [tag] 147 PUSH [tag] 97
 O: POP PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 AND PUSH [tag] 147 PUSH [tag] 97
*)
Compute ( "ERC721A_run_code_of_0_block_148_5"%string, (equiv_checker [POP;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 3;Opcode AND;PUSH 1 (NToWord WLen 0x93%N);PUSH 1 (NToWord WLen 0x61%N)] [POP;DUP 2;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 1 (NToWord WLen 0x93%N);PUSH 1 (NToWord WLen 0x61%N)] 3 optimize_id) ).

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C31 DUP4 PUSH 40 MLOAD PUSH [tag] 148 SWAP2 SWAP1 PUSH [tag] 25
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH 17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31 PUSH [tag] 148 DUP5 PUSH 40 MLOAD PUSH [tag] 25
*)
Compute ( "ERC721A_run_code_of_0_block_149_0"%string, (equiv_checker [PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;PUSH 32 (NToWord WLen 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31%N);PUSH 1 (NToWord WLen 0x94%N);DUP 5;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x19%N)] [PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 32 (NToWord WLen 0x17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C31%N);DUP 4;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x94%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x19%N)] 3 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_155_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_160_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 40 MLOAD PUSH 20 ADD PUSH [tag] 164 SWAP3 SWAP2 SWAP1 PUSH [tag] 165
 O: PUSH [tag] 164 SWAP2 SWAP1 PUSH 20 PUSH 40 MLOAD ADD PUSH [tag] 165
*)
Compute ( "ERC721A_run_code_of_0_block_165_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0xa4%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;Opcode ADD;PUSH 1 (NToWord WLen 0xa5%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0xa4%N);SWAP 3;SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0xa5%N)] 2 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP2 SWAP1 POP
 O: SWAP4 SWAP3 POP POP POP
*)
Compute ( "ERC721A_run_code_of_0_block_167_0"%string, (equiv_checker [SWAP 4;SWAP 3;POP;POP;POP] [SWAP 2;POP;POP;SWAP 2;SWAP 1;POP] 5 optimize_id) ).

(*
 I: PUSH 0 PUSH 7 PUSH 0 DUP5 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 0 PUSH 7 DUP2 DUP5 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Compute ( "ERC721A_run_code_of_0_block_168_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x7%N);DUP 2;DUP 5;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x7%N);PUSH 1 (NToWord WLen 0x0%N);DUP 5;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 2] 2 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP5 DUP2 AND AND DUP2
*)
Compute ( "ERC721A_run_code_of_0_block_168_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);DUP 5;DUP 2;Opcode AND;Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);DUP 4;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 2] 3 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FF AND SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP2 PUSH 0 SWAP4 POP POP POP PUSH 20 ADD DUP2 PUSH 100 EXP SWAP2 KECCAK256 SLOAD DIV PUSH ff AND SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_168_4"%string, (equiv_checker [SWAP 2;PUSH 1 (NToWord WLen 0x0%N);SWAP 4;POP;POP;POP;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;SWAP 2;Opcode KECCAK256;Opcode SLOAD;Opcode DIV;PUSH 1 (NToWord WLen 0xff%N);Opcode AND;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N);SWAP 1;Opcode SLOAD;SWAP 1;PUSH 2 (NToWord WLen 0x100%N);Opcode EXP;SWAP 1;Opcode DIV;PUSH 1 (NToWord WLen 0xFF%N);Opcode AND;SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 5 optimize_id) ).

(*
 I: POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 PUSH 4 PUSH 0 DUP6 DUP2
 O: POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 PUSH 4 DUP3 DUP6 DUP2
*)
Compute ( "ERC721A_run_code_of_0_block_173_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x0%N);PUSH 29 (NToWord WLen 0x100000000000000000000000000000000000000000000000000000000%N);PUSH 1 (NToWord WLen 0x4%N);DUP 3;DUP 6;DUP 2] [POP;PUSH 1 (NToWord WLen 0x0%N);PUSH 29 (NToWord WLen 0x100000000000000000000000000000000000000000000000000000000%N);PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x0%N);DUP 6;DUP 2] 3 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_174_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 CALLER SWAP1 POP SWAP1
 O: CALLER SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_175_0"%string, (equiv_checker [Opcode CALLER;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);Opcode CALLER;SWAP 1;POP;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 0 DUP1 DUP3 SWAP1 POP DUP1 PUSH [tag] 174 PUSH [tag] 104
 O: PUSH 0 DUP2 DUP1 PUSH [tag] 174 PUSH [tag] 104
*)
Compute ( "ERC721A_run_code_of_0_block_177_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 1;PUSH 1 (NToWord WLen 0xae%N);PUSH 1 (NToWord WLen 0x68%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 3;SWAP 1;POP;DUP 1;PUSH 1 (NToWord WLen 0xae%N);PUSH 1 (NToWord WLen 0x68%N)] 1 optimize_id) ).

(*
 I: PUSH 0 PUSH 4 PUSH 0 DUP4 DUP2
 O: PUSH 0 PUSH 4 DUP2 DUP4 DUP2
*)
Compute ( "ERC721A_run_code_of_0_block_180_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x4%N);DUP 2;DUP 4;DUP 2] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 2] 1 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD SWAP1 POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 DUP3 AND EQ ISZERO PUSH [tag] 177
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD PUSH 100000000000000000000000000000000000000000000000000000000 DUP2 SWAP3 POP AND PUSH 0 EQ ISZERO PUSH [tag] 177
*)
Compute ( "ERC721A_run_code_of_0_block_180_2"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;Opcode SLOAD;PUSH 29 (NToWord WLen 0x100000000000000000000000000000000000000000000000000000000%N);DUP 2;SWAP 3;POP;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb1%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;Opcode SLOAD;SWAP 1;POP;PUSH 1 (NToWord WLen 0x0%N);PUSH 29 (NToWord WLen 0x100000000000000000000000000000000000000000000000000000000%N);DUP 3;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb1%N)] 2 optimize_id) ).

(*
 I: PUSH 0 DUP2 EQ ISZERO PUSH [tag] 179
 O: DUP1 PUSH 0 EQ ISZERO PUSH [tag] 179
*)
Compute ( "ERC721A_run_code_of_0_block_181_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x0%N);Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb3%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb3%N)] 1 optimize_id) ).

(*
 I: PUSH 4 PUSH 0 DUP4 PUSH 1 SWAP1 SUB SWAP4 POP DUP4 DUP2
 O: PUSH 1 PUSH 4 SWAP3 SUB SWAP2 PUSH 0 DUP4 DUP2
*)
Compute ( "ERC721A_run_code_of_0_block_182_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x4%N);SWAP 3;Opcode SUB;SWAP 2;PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 2] [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x0%N);DUP 4;PUSH 1 (NToWord WLen 0x1%N);SWAP 1;Opcode SUB;SWAP 4;POP;DUP 4;DUP 2] 2 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD SWAP1 POP PUSH [tag] 178
 O: SWAP1 POP PUSH 20 ADD PUSH 0 KECCAK256 SLOAD PUSH [tag] 178
*)
Compute ( "ERC721A_run_code_of_0_block_182_2"%string, (equiv_checker [SWAP 1;POP;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0xb2%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;Opcode SLOAD;SWAP 1;POP;PUSH 1 (NToWord WLen 0xb2%N)] 2 optimize_id) ).

(*
 I: DUP1 SWAP3 POP POP POP PUSH [tag] 173
 O: SWAP2 POP POP PUSH [tag] 173
*)
Compute ( "ERC721A_run_code_of_0_block_183_0"%string, (equiv_checker [SWAP 2;POP;POP;PUSH 1 (NToWord WLen 0xad%N)] [DUP 1;SWAP 3;POP;POP;POP;PUSH 1 (NToWord WLen 0xad%N)] 3 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_186_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 0 DUP1 PUSH 0 PUSH 6 PUSH 0 DUP6 DUP2
 O: PUSH 0 DUP1 DUP1 PUSH 6 DUP2 DUP6 DUP2
*)
Compute ( "ERC721A_run_code_of_0_block_188_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 1;PUSH 1 (NToWord WLen 0x6%N);DUP 2;DUP 6;DUP 2] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x6%N);PUSH 1 (NToWord WLen 0x0%N);DUP 6;DUP 2] 1 optimize_id) ).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SWAP1 POP DUP1 SWAP3 POP DUP3 SLOAD SWAP2 POP POP SWAP2 POP SWAP2
 O: SWAP1 POP SWAP2 POP SWAP2 POP PUSH 20 ADD SWAP1 POP PUSH 0 KECCAK256 SWAP1 DUP2 SLOAD SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_188_2"%string, (equiv_checker [SWAP 1;POP;SWAP 2;POP;SWAP 2;POP;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 1;POP;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;SWAP 1;DUP 2;Opcode SLOAD;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;SWAP 1;POP;DUP 1;SWAP 3;POP;DUP 3;Opcode SLOAD;SWAP 2;POP;POP;SWAP 2;POP;SWAP 2] 6 optimize_id) ).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP4 AND SWAP3 POP PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP3 AND SWAP2 POP DUP4 DUP3 EQ DUP4 DUP4 EQ OR SWAP1 POP SWAP4 SWAP3 POP POP POP
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP1 DUP2 SWAP3 SWAP3 DUP5 EQ SWAP4 POP SWAP3 DUP5 SWAP3 PUSH ffffffffffffffffffffffffffffffffffffffff AND SWAP3 POP SWAP3 POP EQ OR SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_189_0"%string, (equiv_checker [PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;DUP 1;DUP 2;SWAP 3;SWAP 3;DUP 5;Opcode EQ;SWAP 4;POP;SWAP 3;DUP 5;SWAP 3;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;SWAP 3;POP;SWAP 3;POP;Opcode EQ;Opcode OR;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);DUP 4;Opcode AND;SWAP 3;POP;PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);DUP 3;Opcode AND;SWAP 2;POP;DUP 4;DUP 3;Opcode EQ;DUP 4;DUP 4;Opcode EQ;Opcode OR;SWAP 1;POP;SWAP 4;SWAP 3;POP;POP;POP] 4 optimize_id) ).

(*
 I: PUSH 0 DUP1 PUSH E8 DUP4 SWAP1 SHR SWAP1 POP PUSH E8 PUSH [tag] 184 DUP7 DUP7 DUP5 PUSH [tag] 185
 O: PUSH 0 PUSH [tag] 185 PUSH e8 PUSH [tag] 184 DUP7 DUP7 DUP7 DUP5 SHR DUP1 SWAP6
*)
Compute ( "ERC721A_run_code_of_0_block_191_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0xb9%N);PUSH 1 (NToWord WLen 0xe8%N);PUSH 1 (NToWord WLen 0xb8%N);DUP 7;DUP 7;DUP 7;DUP 5;Opcode SHR;DUP 1;SWAP 6] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0xE8%N);DUP 4;SWAP 1;Opcode SHR;SWAP 1;POP;PUSH 1 (NToWord WLen 0xE8%N);PUSH 1 (NToWord WLen 0xb8%N);DUP 7;DUP 7;DUP 5;PUSH 1 (NToWord WLen 0xb9%N)] 3 optimize_id) ).

(*
 I: PUSH FFFFFF AND SWAP1 SHL SWAP2 POP POP SWAP4 SWAP3 POP POP POP
 O: PUSH ffffff AND SWAP6 POP SWAP4 POP POP POP POP SHL SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_192_0"%string, (equiv_checker [PUSH 3 (NToWord WLen 0xffffff%N);Opcode AND;SWAP 6;POP;SWAP 4;POP;POP;POP;POP;Opcode SHL;SWAP 1] [PUSH 3 (NToWord WLen 0xFFFFFF%N);Opcode AND;SWAP 1;Opcode SHL;SWAP 2;POP;POP;SWAP 4;SWAP 3;POP;POP;POP] 8 optimize_id) ).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP4 AND SWAP3 POP DUP2 TIMESTAMP PUSH A0 SHL OR DUP4 OR SWAP1 POP SWAP3 SWAP2 POP POP
 O: TIMESTAMP PUSH a0 SHL OR SWAP1 PUSH ffffffffffffffffffffffffffffffffffffffff AND OR SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_193_0"%string, (equiv_checker [Opcode TIMESTAMP;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode OR;SWAP 1;PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;Opcode OR;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);DUP 4;Opcode AND;SWAP 3;POP;DUP 2;Opcode TIMESTAMP;PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode OR;DUP 4;Opcode OR;SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 3 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH [tag] 190 SWAP5 SWAP4 SWAP3 SWAP2 SWAP1 PUSH [tag] 191
 O: SWAP3 SWAP2 SWAP1 PUSH 4 PUSH [tag] 190 SWAP6 SWAP5 ADD PUSH [tag] 191
*)
Compute ( "ERC721A_run_code_of_0_block_196_1"%string, (equiv_checker [SWAP 3;SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0xbe%N);SWAP 6;SWAP 5;Opcode ADD;PUSH 1 (NToWord WLen 0xbf%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0xbe%N);SWAP 5;SWAP 4;SWAP 3;SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0xbf%N)] 5 optimize_id) ).

(*
 I: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP1 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 192
 O: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP9 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 192
*)
Compute ( "ERC721A_run_code_of_0_block_197_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (NToWord WLen 0x0%N);DUP 8;DUP 9;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc0%N)] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (NToWord WLen 0x0%N);DUP 8;DUP 1;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc0%N)] 3 optimize_id) ).

(*
 I: POP DUP2 ADD SWAP1 PUSH [tag] 194 SWAP2 SWAP1 PUSH [tag] 195
 O: POP DUP2 ADD PUSH [tag] 194 SWAP2 PUSH [tag] 195
*)
Compute ( "ERC721A_run_code_of_0_block_200_1"%string, (equiv_checker [POP;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0xc2%N);SWAP 2;PUSH 1 (NToWord WLen 0xc3%N)] [POP;DUP 2;Opcode ADD;SWAP 1;PUSH 1 (NToWord WLen 0xc2%N);SWAP 2;SWAP 1;PUSH 1 (NToWord WLen 0xc3%N)] 3 optimize_id) ).

(*
 I: RETURNDATASIZE DUP1 PUSH 0 DUP2 EQ PUSH [tag] 201
 O: RETURNDATASIZE DUP1 DUP2 PUSH 0 EQ PUSH [tag] 201
*)
Compute ( "ERC721A_run_code_of_0_block_203_0"%string, (equiv_checker [Opcode RETURNDATASIZE;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode EQ;PUSH 1 (NToWord WLen 0xc9%N)] [Opcode RETURNDATASIZE;DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode EQ;PUSH 1 (NToWord WLen 0xc9%N)] 0 optimize_id) ).

(*
 I: PUSH 40 MLOAD SWAP2 POP PUSH 1F NOT PUSH 3F RETURNDATASIZE ADD AND DUP3 ADD PUSH 40
 O: PUSH 1f PUSH 40 MLOAD SWAP3 POP NOT RETURNDATASIZE PUSH 3f ADD AND DUP3 ADD PUSH 40
*)
Compute ( "ERC721A_run_code_of_0_block_204_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 3;POP;Opcode NOT;Opcode RETURNDATASIZE;PUSH 1 (NToWord WLen 0x3f%N);Opcode ADD;Opcode AND;DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 2;POP;PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;PUSH 1 (NToWord WLen 0x3F%N);Opcode RETURNDATASIZE;Opcode ADD;Opcode AND;DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 2 optimize_id) ).

(*
 I: POP PUSH 0 DUP2 MLOAD EQ ISZERO PUSH [tag] 202
 O: POP DUP1 MLOAD PUSH 0 EQ ISZERO PUSH [tag] 202
*)
Compute ( "ERC721A_run_code_of_0_block_206_0"%string, (equiv_checker [POP;DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0xca%N)] [POP;PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode MLOAD;Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0xca%N)] 2 optimize_id) ).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_207_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;SWAP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;SWAP 2;Opcode SUB;SWAP 1] 1 optimize_id) ).

(*
 I: PUSH 150B7A02 PUSH E0 SHL PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ SWAP2 POP POP SWAP5 SWAP4 POP POP POP POP
 O: SWAP5 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT PUSH 150b7a02 PUSH e0 SHL SWAP2 SWAP8 SWAP7 DUP2 AND SWAP2 AND EQ SWAP6 POP POP POP POP POP
*)
Compute ( "ERC721A_run_code_of_0_block_209_0"%string, (equiv_checker [SWAP 5;PUSH 28 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff%N);Opcode NOT;PUSH 4 (NToWord WLen 0x150b7a02%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;SWAP 2;SWAP 8;SWAP 7;DUP 2;Opcode AND;SWAP 2;Opcode AND;Opcode EQ;SWAP 6;POP;POP;POP;POP;POP] [PUSH 4 (NToWord WLen 0x150B7A02%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 28 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode NOT;Opcode AND;DUP 2;PUSH 28 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);Opcode NOT;Opcode AND;Opcode EQ;SWAP 2;POP;POP;SWAP 5;SWAP 4;POP;POP;POP;POP] 7 optimize_id) ).

(*
 I: POP SWAP1 POP SWAP1
 O: POP SWAP2 SWAP1 POP
*)
Compute ( "ERC721A_run_code_of_0_block_210_2"%string, (equiv_checker [POP;SWAP 2;SWAP 1;POP] [POP;SWAP 1;POP;SWAP 1] 4 optimize_id) ).

(*
 I: PUSH 60 PUSH 80 PUSH 40 MLOAD ADD SWAP1 POP DUP1 PUSH 40
 O: PUSH 80 PUSH 40 MLOAD ADD DUP1 PUSH 40
*)
Compute ( "ERC721A_run_code_of_0_block_211_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x80%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x40%N)] [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x80%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;Opcode ADD;SWAP 1;POP;DUP 1;PUSH 1 (NToWord WLen 0x40%N)] 0 optimize_id) ).

(*
 I: PUSH 1 DUP4 SUB SWAP3 POP PUSH A DUP2 MOD PUSH 30 ADD DUP4
 O: PUSH 1 PUSH 30 SWAP4 SUB SWAP3 PUSH a DUP3 MOD ADD DUP4
*)
Compute ( "ERC721A_run_code_of_0_block_213_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x30%N);SWAP 4;Opcode SUB;SWAP 3;PUSH 1 (NToWord WLen 0xa%N);DUP 3;Opcode MOD;Opcode ADD;DUP 4] [PUSH 1 (NToWord WLen 0x1%N);DUP 4;Opcode SUB;SWAP 3;POP;PUSH 1 (NToWord WLen 0xA%N);DUP 2;Opcode MOD;PUSH 1 (NToWord WLen 0x30%N);Opcode ADD;DUP 4] 3 optimize_id) ).

(*
 I: PUSH A DUP2 DIV SWAP1 POP DUP1 PUSH [tag] 210
 O: PUSH a SWAP1 DIV DUP1 PUSH [tag] 210
*)
Compute ( "ERC721A_run_code_of_0_block_213_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0xa%N);SWAP 1;Opcode DIV;DUP 1;PUSH 1 (NToWord WLen 0xd2%N)] [PUSH 1 (NToWord WLen 0xA%N);DUP 2;Opcode DIV;SWAP 1;POP;DUP 1;PUSH 1 (NToWord WLen 0xd2%N)] 1 optimize_id) ).

(*
 I: POP DUP2 DUP2 SUB PUSH 20 DUP4 SUB SWAP3 POP DUP1 DUP4
 O: POP PUSH 20 DUP3 SUB SWAP2 DUP2 SUB DUP1 DUP4
*)
Compute ( "ERC721A_run_code_of_0_block_216_0"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode SUB;SWAP 2;DUP 2;Opcode SUB;DUP 1;DUP 4] [POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode SUB;SWAP 3;POP;DUP 1;DUP 4] 3 optimize_id) ).

(*
 I: PUSH 0 SWAP4 SWAP3 POP POP POP
 O: POP POP POP PUSH 0 SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_217_0"%string, (equiv_checker [POP;POP;POP;PUSH 1 (NToWord WLen 0x0%N);SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);SWAP 4;SWAP 3;POP;POP;POP] 4 optimize_id) ).

(*
 I: PUSH 20 DUP2 ADD DUP5 DUP5 DUP5 ADD GT ISZERO PUSH [tag] 219
 O: DUP1 PUSH 20 ADD DUP5 DUP4 DUP6 ADD GT ISZERO PUSH [tag] 219
*)
Compute ( "ERC721A_run_code_of_0_block_220_1"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 5;DUP 4;DUP 6;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xdb%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;DUP 5;DUP 5;DUP 5;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xdb%N)] 4 optimize_id) ).

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 226 DUP2 PUSH [tag] 227
 O: DUP1 CALLDATALOAD PUSH [tag] 226 DUP2 PUSH [tag] 227
*)
Compute ( "ERC721A_run_code_of_0_block_225_0"%string, (equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 1 (NToWord WLen 0xe2%N);DUP 2;PUSH 1 (NToWord WLen 0xe3%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode CALLDATALOAD;SWAP 1;POP;PUSH 1 (NToWord WLen 0xe2%N);DUP 2;PUSH 1 (NToWord WLen 0xe3%N)] 1 optimize_id) ).

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 230 DUP2 PUSH [tag] 231
 O: DUP1 CALLDATALOAD PUSH [tag] 230 DUP2 PUSH [tag] 231
*)
Compute ( "ERC721A_run_code_of_0_block_227_0"%string, (equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 1 (NToWord WLen 0xe6%N);DUP 2;PUSH 1 (NToWord WLen 0xe7%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode CALLDATALOAD;SWAP 1;POP;PUSH 1 (NToWord WLen 0xe6%N);DUP 2;PUSH 1 (NToWord WLen 0xe7%N)] 1 optimize_id) ).

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 234 DUP2 PUSH [tag] 235
 O: DUP1 CALLDATALOAD PUSH [tag] 234 DUP2 PUSH [tag] 235
*)
Compute ( "ERC721A_run_code_of_0_block_229_0"%string, (equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 1 (NToWord WLen 0xea%N);DUP 2;PUSH 1 (NToWord WLen 0xeb%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode CALLDATALOAD;SWAP 1;POP;PUSH 1 (NToWord WLen 0xea%N);DUP 2;PUSH 1 (NToWord WLen 0xeb%N)] 1 optimize_id) ).

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP PUSH [tag] 238 DUP2 PUSH [tag] 235
 O: DUP1 MLOAD PUSH [tag] 238 DUP2 PUSH [tag] 235
*)
Compute ( "ERC721A_run_code_of_0_block_231_0"%string, (equiv_checker [DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0xee%N);DUP 2;PUSH 1 (NToWord WLen 0xeb%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode MLOAD;SWAP 1;POP;PUSH 1 (NToWord WLen 0xee%N);DUP 2;PUSH 1 (NToWord WLen 0xeb%N)] 1 optimize_id) ).

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 241
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 241
*)
Compute ( "ERC721A_run_code_of_0_block_233_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode SLT;PUSH 1 (NToWord WLen 0xf1%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;Opcode SLT;PUSH 1 (NToWord WLen 0xf1%N)] 2 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute ( "ERC721A_run_code_of_0_block_237_0"%string, (equiv_checker [SWAP 5;SWAP 4;POP;POP;POP;POP] [SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 247 DUP2 PUSH [tag] 248
 O: DUP1 CALLDATALOAD PUSH [tag] 247 DUP2 PUSH [tag] 248
*)
Compute ( "ERC721A_run_code_of_0_block_238_0"%string, (equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 1 (NToWord WLen 0xf7%N);DUP 2;PUSH 1 (NToWord WLen 0xf8%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode CALLDATALOAD;SWAP 1;POP;PUSH 1 (NToWord WLen 0xf7%N);DUP 2;PUSH 1 (NToWord WLen 0xf8%N)] 1 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 253 DUP5 DUP3 DUP6 ADD PUSH [tag] 224
 O: PUSH 0 PUSH [tag] 253 DUP5 DUP5 DUP4 ADD PUSH [tag] 224
*)
Compute ( "ERC721A_run_code_of_0_block_243_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0xfd%N);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0xe0%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0xfd%N);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 1 (NToWord WLen 0xe0%N)] 3 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute ( "ERC721A_run_code_of_0_block_244_0"%string, (equiv_checker [SWAP 5;SWAP 4;POP;POP;POP;POP] [SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 257 DUP6 DUP3 DUP7 ADD PUSH [tag] 224
 O: PUSH 0 PUSH [tag] 257 DUP6 DUP6 DUP4 ADD PUSH [tag] 224
*)
Compute ( "ERC721A_run_code_of_0_block_248_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x101%N);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0xe0%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x101%N);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (NToWord WLen 0xe0%N)] 4 optimize_id) ).

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 258 DUP6 DUP3 DUP7 ADD PUSH [tag] 224
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 258 DUP6 DUP6 DUP4 ADD PUSH [tag] 224
*)
Compute ( "ERC721A_run_code_of_0_block_249_0"%string, (equiv_checker [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x102%N);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0xe0%N)] [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x102%N);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (NToWord WLen 0xe0%N)] 6 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute ( "ERC721A_run_code_of_0_block_250_0"%string, (equiv_checker [SWAP 5;POP;POP;POP;SWAP 3;SWAP 1;POP] [SWAP 2;POP;POP;SWAP 3;POP;SWAP 3;SWAP 1;POP] 7 optimize_id) ).

(*
 I: PUSH 0 DUP1 PUSH 0 PUSH 60 DUP5 DUP7 SUB SLT ISZERO PUSH [tag] 260
 O: PUSH 0 DUP1 DUP2 PUSH 60 DUP5 DUP7 SUB SLT ISZERO PUSH [tag] 260
*)
Compute ( "ERC721A_run_code_of_0_block_251_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x60%N);DUP 5;DUP 7;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x104%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x60%N);DUP 5;DUP 7;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x104%N)] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 262 DUP7 DUP3 DUP8 ADD PUSH [tag] 224
 O: PUSH 0 PUSH [tag] 262 DUP7 DUP7 DUP4 ADD PUSH [tag] 224
*)
Compute ( "ERC721A_run_code_of_0_block_254_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x106%N);DUP 7;DUP 7;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0xe0%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x106%N);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 1 (NToWord WLen 0xe0%N)] 5 optimize_id) ).

(*
 I: SWAP4 POP POP PUSH 20 PUSH [tag] 263 DUP7 DUP3 DUP8 ADD PUSH [tag] 224
 O: SWAP4 POP POP PUSH 20 PUSH [tag] 263 DUP7 DUP7 DUP4 ADD PUSH [tag] 224
*)
Compute ( "ERC721A_run_code_of_0_block_255_0"%string, (equiv_checker [SWAP 4;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x107%N);DUP 7;DUP 7;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0xe0%N)] [SWAP 4;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x107%N);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 1 (NToWord WLen 0xe0%N)] 7 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 POP SWAP3
 O: SWAP5 POP POP POP SWAP3 POP SWAP3
*)
Compute ( "ERC721A_run_code_of_0_block_257_0"%string, (equiv_checker [SWAP 5;POP;POP;POP;SWAP 3;POP;SWAP 3] [SWAP 2;POP;POP;SWAP 3;POP;SWAP 3;POP;SWAP 3] 8 optimize_id) ).

(*
 I: PUSH 0 DUP1 PUSH 0 DUP1 PUSH 80 DUP6 DUP8 SUB SLT ISZERO PUSH [tag] 266
 O: PUSH 0 DUP1 DUP1 DUP3 PUSH 80 DUP6 DUP8 SUB SLT ISZERO PUSH [tag] 266
*)
Compute ( "ERC721A_run_code_of_0_block_258_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 1;DUP 3;PUSH 1 (NToWord WLen 0x80%N);DUP 6;DUP 8;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x10a%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x80%N);DUP 6;DUP 8;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x10a%N)] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 268 DUP8 DUP3 DUP9 ADD PUSH [tag] 224
 O: PUSH 0 PUSH [tag] 268 DUP8 DUP8 DUP4 ADD PUSH [tag] 224
*)
Compute ( "ERC721A_run_code_of_0_block_261_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x10c%N);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0xe0%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x10c%N);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 1 (NToWord WLen 0xe0%N)] 6 optimize_id) ).

(*
 I: SWAP5 POP POP PUSH 20 PUSH [tag] 269 DUP8 DUP3 DUP9 ADD PUSH [tag] 224
 O: SWAP5 POP POP PUSH 20 PUSH [tag] 269 DUP8 DUP8 DUP4 ADD PUSH [tag] 224
*)
Compute ( "ERC721A_run_code_of_0_block_262_0"%string, (equiv_checker [SWAP 5;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x10d%N);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0xe0%N)] [SWAP 5;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x10d%N);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 1 (NToWord WLen 0xe0%N)] 8 optimize_id) ).

(*
 I: SWAP4 POP POP PUSH 40 PUSH [tag] 270 DUP8 DUP3 DUP9 ADD PUSH [tag] 245
 O: SWAP4 POP POP PUSH 40 PUSH [tag] 270 DUP8 DUP8 DUP4 ADD PUSH [tag] 245
*)
Compute ( "ERC721A_run_code_of_0_block_263_0"%string, (equiv_checker [SWAP 4;POP;POP;PUSH 1 (NToWord WLen 0x40%N);PUSH 2 (NToWord WLen 0x10e%N);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0xf5%N)] [SWAP 4;POP;POP;PUSH 1 (NToWord WLen 0x40%N);PUSH 2 (NToWord WLen 0x10e%N);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 1 (NToWord WLen 0xf5%N)] 8 optimize_id) ).

(*
 I: SWAP3 POP POP PUSH 60 DUP6 ADD CALLDATALOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 271
 O: SWAP3 POP POP DUP5 PUSH 60 ADD CALLDATALOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 271
*)
Compute ( "ERC721A_run_code_of_0_block_264_0"%string, (equiv_checker [SWAP 3;POP;POP;DUP 5;PUSH 1 (NToWord WLen 0x60%N);Opcode ADD;Opcode CALLDATALOAD;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x10f%N)] [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x60%N);DUP 6;Opcode ADD;Opcode CALLDATALOAD;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x10f%N)] 7 optimize_id) ).

(*
 I: PUSH [tag] 274 DUP8 DUP3 DUP9 ADD PUSH [tag] 239
 O: PUSH [tag] 274 DUP8 DUP8 DUP4 ADD PUSH [tag] 239
*)
Compute ( "ERC721A_run_code_of_0_block_267_0"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x112%N);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0xef%N)] [PUSH 2 (NToWord WLen 0x112%N);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 1 (NToWord WLen 0xef%N)] 7 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 SWAP6 SWAP2 SWAP5 POP SWAP3 POP
 O: SWAP5 SWAP8 SWAP4 SWAP7 POP POP POP SWAP3 POP
*)
Compute ( "ERC721A_run_code_of_0_block_268_0"%string, (equiv_checker [SWAP 5;SWAP 8;SWAP 4;SWAP 7;POP;POP;POP;SWAP 3;POP] [SWAP 2;POP;POP;SWAP 3;SWAP 6;SWAP 2;SWAP 5;POP;SWAP 3;POP] 9 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 278 DUP6 DUP3 DUP7 ADD PUSH [tag] 224
 O: PUSH 0 PUSH [tag] 278 DUP6 DUP6 DUP4 ADD PUSH [tag] 224
*)
Compute ( "ERC721A_run_code_of_0_block_272_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x116%N);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0xe0%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x116%N);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (NToWord WLen 0xe0%N)] 4 optimize_id) ).

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 279 DUP6 DUP3 DUP7 ADD PUSH [tag] 228
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 279 DUP6 DUP6 DUP4 ADD PUSH [tag] 228
*)
Compute ( "ERC721A_run_code_of_0_block_273_0"%string, (equiv_checker [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x117%N);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0xe4%N)] [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x117%N);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (NToWord WLen 0xe4%N)] 6 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute ( "ERC721A_run_code_of_0_block_274_0"%string, (equiv_checker [SWAP 5;POP;POP;POP;SWAP 3;SWAP 1;POP] [SWAP 2;POP;POP;SWAP 3;POP;SWAP 3;SWAP 1;POP] 7 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 283 DUP6 DUP3 DUP7 ADD PUSH [tag] 224
 O: PUSH 0 PUSH [tag] 283 DUP6 DUP6 DUP4 ADD PUSH [tag] 224
*)
Compute ( "ERC721A_run_code_of_0_block_278_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x11b%N);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0xe0%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x11b%N);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (NToWord WLen 0xe0%N)] 4 optimize_id) ).

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 284 DUP6 DUP3 DUP7 ADD PUSH [tag] 245
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 284 DUP6 DUP6 DUP4 ADD PUSH [tag] 245
*)
Compute ( "ERC721A_run_code_of_0_block_279_0"%string, (equiv_checker [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x11c%N);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0xf5%N)] [SWAP 3;POP;POP;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x11c%N);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (NToWord WLen 0xf5%N)] 6 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute ( "ERC721A_run_code_of_0_block_280_0"%string, (equiv_checker [SWAP 5;POP;POP;POP;SWAP 3;SWAP 1;POP] [SWAP 2;POP;POP;SWAP 3;POP;SWAP 3;SWAP 1;POP] 7 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 288 DUP5 DUP3 DUP6 ADD PUSH [tag] 232
 O: PUSH 0 PUSH [tag] 288 DUP5 DUP5 DUP4 ADD PUSH [tag] 232
*)
Compute ( "ERC721A_run_code_of_0_block_284_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x120%N);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0xe8%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x120%N);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 1 (NToWord WLen 0xe8%N)] 3 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute ( "ERC721A_run_code_of_0_block_285_0"%string, (equiv_checker [SWAP 5;SWAP 4;POP;POP;POP;POP] [SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 292 DUP5 DUP3 DUP6 ADD PUSH [tag] 236
 O: PUSH 0 PUSH [tag] 292 DUP5 DUP5 DUP4 ADD PUSH [tag] 236
*)
Compute ( "ERC721A_run_code_of_0_block_289_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x124%N);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0xec%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x124%N);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 1 (NToWord WLen 0xec%N)] 3 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute ( "ERC721A_run_code_of_0_block_290_0"%string, (equiv_checker [SWAP 5;SWAP 4;POP;POP;POP;POP] [SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: PUSH 0 PUSH [tag] 296 DUP5 DUP3 DUP6 ADD PUSH [tag] 245
 O: PUSH 0 PUSH [tag] 296 DUP5 DUP5 DUP4 ADD PUSH [tag] 245
*)
Compute ( "ERC721A_run_code_of_0_block_294_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x128%N);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0xf5%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x128%N);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 1 (NToWord WLen 0xf5%N)] 3 optimize_id) ).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute ( "ERC721A_run_code_of_0_block_295_0"%string, (equiv_checker [SWAP 5;SWAP 4;POP;POP;POP;POP] [SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: SWAP4 POP PUSH [tag] 311 DUP2 DUP6 PUSH 20 DUP7 ADD PUSH [tag] 312
 O: SWAP4 POP PUSH [tag] 311 DUP2 DUP6 DUP6 PUSH 20 ADD PUSH [tag] 312
*)
Compute ( "ERC721A_run_code_of_0_block_302_0"%string, (equiv_checker [SWAP 4;POP;PUSH 2 (NToWord WLen 0x137%N);DUP 2;DUP 6;DUP 6;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x138%N)] [SWAP 4;POP;PUSH 2 (NToWord WLen 0x137%N);DUP 2;DUP 6;PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;PUSH 2 (NToWord WLen 0x138%N)] 5 optimize_id) ).

(*
 I: DUP5 ADD SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP3 POP POP POP ADD SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_304_0"%string, (equiv_checker [SWAP 3;POP;POP;POP;Opcode ADD;SWAP 1] [DUP 5;Opcode ADD;SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: SWAP4 POP PUSH [tag] 321 DUP2 DUP6 PUSH 20 DUP7 ADD PUSH [tag] 312
 O: SWAP4 POP PUSH [tag] 321 DUP2 DUP6 DUP6 PUSH 20 ADD PUSH [tag] 312
*)
Compute ( "ERC721A_run_code_of_0_block_307_0"%string, (equiv_checker [SWAP 4;POP;PUSH 2 (NToWord WLen 0x141%N);DUP 2;DUP 6;DUP 6;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x138%N)] [SWAP 4;POP;PUSH 2 (NToWord WLen 0x141%N);DUP 2;DUP 6;PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;PUSH 2 (NToWord WLen 0x138%N)] 5 optimize_id) ).

(*
 I: DUP5 ADD SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP3 POP POP POP ADD SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_309_0"%string, (equiv_checker [SWAP 3;POP;POP;POP;Opcode ADD;SWAP 1] [DUP 5;Opcode ADD;SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 6 optimize_id) ).

(*
 I: SWAP4 POP PUSH [tag] 328 DUP2 DUP6 PUSH 20 DUP7 ADD PUSH [tag] 312
 O: SWAP4 POP PUSH [tag] 328 DUP2 DUP6 DUP6 PUSH 20 ADD PUSH [tag] 312
*)
Compute ( "ERC721A_run_code_of_0_block_312_0"%string, (equiv_checker [SWAP 4;POP;PUSH 2 (NToWord WLen 0x148%N);DUP 2;DUP 6;DUP 6;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x138%N)] [SWAP 4;POP;PUSH 2 (NToWord WLen 0x148%N);DUP 2;DUP 6;PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;PUSH 2 (NToWord WLen 0x138%N)] 5 optimize_id) ).

(*
 I: DUP1 DUP5 ADD SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP2 POP POP ADD SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_313_0"%string, (equiv_checker [SWAP 2;POP;POP;Opcode ADD;SWAP 1] [DUP 1;DUP 5;Opcode ADD;SWAP 2;POP;POP;SWAP 3;SWAP 2;POP;POP] 5 optimize_id) ).

(*
 I: SWAP2 POP DUP2 SWAP1 POP SWAP4 SWAP3 POP POP POP
 O: SWAP4 POP POP POP POP SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_318_0"%string, (equiv_checker [SWAP 4;POP;POP;POP;POP;SWAP 1] [SWAP 2;POP;DUP 2;SWAP 1;POP;SWAP 4;SWAP 3;POP;POP;POP] 6 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP PUSH [tag] 337 PUSH 0 DUP4 ADD DUP5 PUSH [tag] 297
 O: PUSH 20 DUP2 ADD PUSH [tag] 337 DUP3 PUSH 0 ADD DUP5 PUSH [tag] 297
*)
Compute ( "ERC721A_run_code_of_0_block_319_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;PUSH 2 (NToWord WLen 0x151%N);DUP 3;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x129%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x151%N);PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x129%N)] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH 80 DUP3 ADD SWAP1 POP PUSH [tag] 339 PUSH 0 DUP4 ADD DUP8 PUSH [tag] 297
 O: PUSH 80 DUP2 ADD PUSH [tag] 339 DUP3 PUSH 0 ADD DUP8 PUSH [tag] 297
*)
Compute ( "ERC721A_run_code_of_0_block_321_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x80%N);DUP 2;Opcode ADD;PUSH 2 (NToWord WLen 0x153%N);DUP 3;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;DUP 8;PUSH 2 (NToWord WLen 0x129%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x80%N);DUP 3;Opcode ADD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x153%N);PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD;DUP 8;PUSH 2 (NToWord WLen 0x129%N)] 5 optimize_id) ).

(*
 I: PUSH [tag] 340 PUSH 20 DUP4 ADD DUP7 PUSH [tag] 297
 O: PUSH [tag] 340 DUP3 PUSH 20 ADD DUP7 PUSH [tag] 297
*)
Compute ( "ERC721A_run_code_of_0_block_322_0"%string, (equiv_checker [PUSH 2 (NToWord WLen 0x154%N);DUP 3;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 7;PUSH 2 (NToWord WLen 0x129%N)] [PUSH 2 (NToWord WLen 0x154%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 7;PUSH 2 (NToWord WLen 0x129%N)] 5 optimize_id) ).

(*
 I: SWAP1 POP SWAP6 SWAP5 POP POP POP POP POP
 O: SWAP7 SWAP6 POP POP POP POP POP POP
*)
Compute ( "ERC721A_run_code_of_0_block_325_0"%string, (equiv_checker [SWAP 7;SWAP 6;POP;POP;POP;POP;POP;POP] [SWAP 1;POP;SWAP 6;SWAP 5;POP;POP;POP;POP;POP] 8 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP PUSH [tag] 344 PUSH 0 DUP4 ADD DUP5 PUSH [tag] 301
 O: PUSH 20 DUP2 ADD PUSH [tag] 344 DUP3 PUSH 0 ADD DUP5 PUSH [tag] 301
*)
Compute ( "ERC721A_run_code_of_0_block_326_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;PUSH 2 (NToWord WLen 0x158%N);DUP 3;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x12d%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x158%N);PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x12d%N)] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute ( "ERC721A_run_code_of_0_block_328_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD] 1 optimize_id) ).

(*
 I: SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP4 SWAP3 POP POP POP
*)
Compute ( "ERC721A_run_code_of_0_block_329_0"%string, (equiv_checker [SWAP 4;SWAP 3;POP;POP;POP] [SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 5 optimize_id) ).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP PUSH [tag] 348 PUSH 0 DUP4 ADD DUP5 PUSH [tag] 329
 O: PUSH 20 DUP2 ADD PUSH [tag] 348 DUP3 PUSH 0 ADD DUP5 PUSH [tag] 329
*)
Compute ( "ERC721A_run_code_of_0_block_330_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;PUSH 2 (NToWord WLen 0x15c%N);DUP 3;PUSH 1 (NToWord WLen 0x0%N);Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x149%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x15c%N);PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x149%N)] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH 40 MLOAD SWAP1 POP SWAP1
 O: PUSH 40 MLOAD SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_335_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;SWAP 1;POP;SWAP 1] 1 optimize_id) ).

(*
 I: SWAP1 POP PUSH 20 DUP2 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP2 POP POP SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_340_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP SWAP2 SWAP1 POP
 O: MLOAD SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_341_0"%string, (equiv_checker [Opcode MLOAD;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode MLOAD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP SWAP2 SWAP1 POP
 O: MLOAD SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_342_0"%string, (equiv_checker [Opcode MLOAD;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode MLOAD;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP PUSH 20 SWAP2 POP ADD SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_343_1"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x20%N);SWAP 2;POP;Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 4 optimize_id) ).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP PUSH 20 SWAP2 POP ADD SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_344_1"%string, (equiv_checker [POP;PUSH 1 (NToWord WLen 0x20%N);SWAP 2;POP;Opcode ADD;SWAP 1] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 4 optimize_id) ).

(*
 I: PUSH 0 DUP2 SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP2 SWAP1 POP
*)
Compute ( "ERC721A_run_code_of_0_block_345_0"%string, (equiv_checker [SWAP 2;SWAP 1;POP] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;SWAP 1;POP;SWAP 3;SWAP 2;POP;POP] 3 optimize_id) ).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_347_0"%string, (equiv_checker [SWAP 2;POP;POP;SWAP 1] [SWAP 1;POP;SWAP 2;SWAP 1;POP] 4 optimize_id) ).

(*
 I: PUSH 0 DUP2 ISZERO ISZERO SWAP1 POP SWAP2 SWAP1 POP
 O: ISZERO ISZERO SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_348_0"%string, (equiv_checker [Opcode ISZERO;Opcode ISZERO;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode ISZERO;Opcode ISZERO;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH FFFFFFFF00000000000000000000000000000000000000000000000000000000 DUP3 AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH ffffffff00000000000000000000000000000000000000000000000000000000 AND SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_349_0"%string, (equiv_checker [PUSH 32 (NToWord WLen 0xffffffff00000000000000000000000000000000000000000000000000000000%N);Opcode AND;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 32 (NToWord WLen 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000%N);DUP 3;Opcode AND;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP3 AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_350_0"%string, (equiv_checker [PUSH 20 (NToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%N);Opcode AND;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 20 (NToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%N);DUP 3;Opcode AND;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH 0 DUP2 SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_351_0"%string, (equiv_checker [SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH 0 DUP4 DUP4 ADD
 O: PUSH 0 DUP3 DUP5 ADD
*)
Compute ( "ERC721A_run_code_of_0_block_352_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 5;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 4;Opcode ADD] 3 optimize_id) ).

(*
 I: DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD
 O: DUP2 DUP2 ADD MLOAD DUP4 DUP3 ADD
*)
Compute ( "ERC721A_run_code_of_0_block_355_0"%string, (equiv_checker [DUP 2;DUP 2;Opcode ADD;Opcode MLOAD;DUP 4;DUP 3;Opcode ADD] [DUP 1;DUP 3;Opcode ADD;Opcode MLOAD;DUP 2;DUP 5;Opcode ADD] 3 optimize_id) ).

(*
 I: PUSH 20 DUP2 ADD SWAP1 POP PUSH [tag] 375
 O: PUSH 20 ADD PUSH [tag] 375
*)
Compute ( "ERC721A_run_code_of_0_block_355_1"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x177%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;SWAP 1;POP;PUSH 2 (NToWord WLen 0x177%N)] 1 optimize_id) ).

(*
 I: PUSH 0 DUP5 DUP5 ADD
 O: PUSH 0 DUP4 DUP6 ADD
*)
Compute ( "ERC721A_run_code_of_0_block_357_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 6;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);DUP 5;DUP 5;Opcode ADD] 4 optimize_id) ).

(*
 I: PUSH 0 PUSH 2 DUP3 DIV SWAP1 POP PUSH 1 DUP3 AND DUP1 PUSH [tag] 380
 O: PUSH 2 DUP2 DIV DUP2 PUSH 1 AND DUP1 PUSH [tag] 380
*)
Compute ( "ERC721A_run_code_of_0_block_359_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x2%N);DUP 2;Opcode DIV;DUP 2;PUSH 1 (NToWord WLen 0x1%N);Opcode AND;DUP 1;PUSH 2 (NToWord WLen 0x17c%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x2%N);DUP 3;Opcode DIV;SWAP 1;POP;PUSH 1 (NToWord WLen 0x1%N);DUP 3;Opcode AND;DUP 1;PUSH 2 (NToWord WLen 0x17c%N)] 1 optimize_id) ).

(*
 I: PUSH 7F DUP3 AND SWAP2 POP
 O: SWAP1 PUSH 7f AND SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_360_0"%string, (equiv_checker [SWAP 1;PUSH 1 (NToWord WLen 0x7f%N);Opcode AND;SWAP 1] [PUSH 1 (NToWord WLen 0x7F%N);DUP 3;Opcode AND;SWAP 2;POP] 2 optimize_id) ).

(*
 I: PUSH 20 DUP3 LT DUP2 EQ ISZERO PUSH [tag] 381
 O: DUP1 PUSH 20 DUP4 LT EQ ISZERO PUSH [tag] 381
*)
Compute ( "ERC721A_run_code_of_0_block_361_0"%string, (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode LT;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x17d%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode LT;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x17d%N)] 2 optimize_id) ).

(*
 I: DUP2 ADD DUP2 DUP2 LT PUSH FFFFFFFFFFFFFFFF DUP3 GT OR ISZERO PUSH [tag] 386
 O: DUP2 ADD PUSH ffffffffffffffff DUP2 GT DUP3 DUP3 LT OR ISZERO PUSH [tag] 386
*)
Compute ( "ERC721A_run_code_of_0_block_366_0"%string, (equiv_checker [DUP 2;Opcode ADD;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);DUP 2;Opcode GT;DUP 3;DUP 3;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 2 (NToWord WLen 0x182%N)] [DUP 2;Opcode ADD;DUP 2;DUP 2;Opcode LT;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);DUP 3;Opcode GT;Opcode OR;Opcode ISZERO;PUSH 2 (NToWord WLen 0x182%N)] 2 optimize_id) ).

(*
 I: PUSH 0 PUSH 1F NOT PUSH 1F DUP4 ADD AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 1f ADD PUSH 1f NOT AND SWAP1
*)
Compute ( "ERC721A_run_code_of_0_block_376_0"%string, (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;PUSH 1 (NToWord WLen 0x1f%N);Opcode NOT;Opcode AND;SWAP 1] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;Opcode AND;SWAP 1;POP;SWAP 2;SWAP 1;POP] 2 optimize_id) ).

(*
 I: PUSH #[$] 0000000000000000000000000000000000000000000000000000000000000000 PUSH [$] 0000000000000000000000000000000000000000000000000000000000000000 PUSH B DUP3 DUP3 DUP3
 O: PUSH #[$] 0 PUSH [$] 0 PUSH b DUP3 DUP3 DUP3
  ERROR OCCURRED

'PUSH #[$]' is not in list
*)

(*
 I: PUSHDEPLOYADDRESS ADDRESS EQ PUSH 80 PUSH 40
 O: ADDRESS PUSHDEPLOYADDRESS EQ PUSH 80 PUSH 40
  ERROR OCCURRED

'PUSHDEPLOYADDRESS' is not in list
*)


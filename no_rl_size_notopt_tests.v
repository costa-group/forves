(*
 I: PUSH 80 PUSH 40
 O: PUSH 80 PUSH 40
*)
Compute pair "BottleCastle_initial_block_0_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x80%positive);PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 1 (posToWord WLen 0x80%positive);PUSH 1 (posToWord WLen 0x40%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 PUSH 40 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 40 ADD PUSH 40
*)
Compute pair "BottleCastle_initial_block_0_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 5 DUP2
 O: DUP1 PUSH 5 DUP2
*)
Compute pair "BottleCastle_initial_block_0_2"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x5%positive);DUP 2] [DUP 1;PUSH 1 (posToWord WLen 0x5%positive);DUP 2] 1 optimize_id).

(*
 I: PUSH 20 ADD PUSH 2E6A736F6E000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 20 ADD PUSH 2e6a736f6e000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_initial_block_0_3"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 32 (posToWord WLen 0x2e6a736f6e000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 32 (posToWord WLen 0x2E6A736F6E000000000000000000000000000000000000000000000000000000%positive);DUP 2] 1 optimize_id).

(*
 I: POP PUSH B SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 1 SWAP3 SWAP2 SWAP1 PUSH [tag] 2
 O: POP PUSH b DUP2 PUSH 20 ADD PUSH [tag] 1 SWAP3 MLOAD PUSH [tag] 2
*)
Compute pair "BottleCastle_initial_block_0_4"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xb%positive);DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x1%positive);DUP 3;Opcode MLOAD;PUSH 1 (posToWord WLen 0x2%positive)] [POP;PUSH 1 (posToWord WLen 0xB%positive);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x1%positive);DUP 3;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x2%positive)] 2 optimize_id).

(*
 I: POP PUSH 38D7EA4C68000 PUSH D
 O: POP PUSH 38d7ea4c68000 PUSH d
*)
Compute pair "BottleCastle_initial_block_1_0"%string (equiv_checker [POP;PUSH 7 (posToWord WLen 0x38d7ea4c68000%positive);PUSH 1 (posToWord WLen 0xd%positive)] [POP;PUSH 7 (posToWord WLen 0x38D7EA4C68000%positive);PUSH 1 (posToWord WLen 0xD%positive)] 1 optimize_id).

(*
 I: PUSH 3E7 PUSH E
 O: PUSH 3e7 PUSH e
*)
Compute pair "BottleCastle_initial_block_1_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x3e7%positive);PUSH 1 (posToWord WLen 0xe%positive)] [PUSH 2 (posToWord WLen 0x3E7%positive);PUSH 1 (posToWord WLen 0xE%positive)] 0 optimize_id).

(*
 I: PUSH A PUSH F
 O: PUSH a PUSH f
*)
Compute pair "BottleCastle_initial_block_1_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0xa%positive);PUSH 1 (posToWord WLen 0xf%positive)] [PUSH 1 (posToWord WLen 0xA%positive);PUSH 1 (posToWord WLen 0xF%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH 10 PUSH 0 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1
 O: PUSH 0 DUP1 PUSH 100 EXP PUSH 10 SLOAD PUSH ff DUP4 ISZERO ISZERO DUP4 MUL SWAP3 MUL NOT AND OR PUSH 10
*)
Compute pair "BottleCastle_initial_block_1_3"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;PUSH 1 (posToWord WLen 0x10%positive);Opcode SLOAD;PUSH 1 (posToWord WLen 0xff%positive);DUP 4;Opcode ISZERO;Opcode ISZERO;DUP 4;Opcode MUL;DUP 3;Opcode MUL;Opcode NOT;Opcode AND;Opcode OR;PUSH 1 (posToWord WLen 0x10%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x10%positive);PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 1 (posToWord WLen 0xFF%positive);Opcode MUL;Opcode NOT;Opcode AND;DUP 1;DUP 4;Opcode ISZERO;Opcode ISZERO;Opcode MUL;Opcode OR;DUP 1] 0 optimize_id).

(*
 I: POP PUSH 0 PUSH 10 PUSH 1 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1
 O: POP PUSH 0 PUSH 1 PUSH 100 EXP DUP2 ISZERO ISZERO DUP2 MUL SWAP1 PUSH ff MUL NOT PUSH 10 SLOAD AND OR PUSH 10
*)
Compute pair "BottleCastle_initial_block_1_4"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x1%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 2;Opcode ISZERO;Opcode ISZERO;DUP 2;Opcode MUL;DUP 1;PUSH 1 (posToWord WLen 0xff%positive);Opcode MUL;Opcode NOT;PUSH 1 (posToWord WLen 0x10%positive);Opcode SLOAD;Opcode AND;Opcode OR;PUSH 1 (posToWord WLen 0x10%positive)] [POP;PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x10%positive);PUSH 1 (posToWord WLen 0x1%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 1 (posToWord WLen 0xFF%positive);Opcode MUL;Opcode NOT;Opcode AND;DUP 1;DUP 4;Opcode ISZERO;Opcode ISZERO;Opcode MUL;Opcode OR;DUP 1] 1 optimize_id).

(*
 I: POP CALLVALUE DUP1 ISZERO PUSH [tag] 3
 O: POP CALLVALUE CALLVALUE ISZERO PUSH [tag] 3
*)
Compute pair "BottleCastle_initial_block_1_5"%string (equiv_checker [POP;Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x3%positive)] [POP;Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x3%positive)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_initial_block_2_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH 40 MLOAD PUSHSIZE CODESIZE SUB DUP1 PUSHSIZE DUP4
 O: POP PUSH 40 MLOAD PUSHSIZE CODESIZE SUB DUP1 PUSHSIZE DUP4
  ERROR OCCURRED

'PUSHSIZE' is not in list
*)

(*
 I: DUP2 DUP2 ADD PUSH 40
 O: DUP1 DUP3 ADD PUSH 40
*)
Compute pair "BottleCastle_initial_block_3_1"%string (equiv_checker [DUP 1;DUP 3;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 2;DUP 2;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 2 optimize_id).

(*
 I: DUP2 ADD SWAP1 PUSH [tag] 4 SWAP2 SWAP1 PUSH [tag] 5
 O: DUP2 ADD PUSH [tag] 4 SWAP2 PUSH [tag] 5
*)
Compute pair "BottleCastle_initial_block_3_2"%string (equiv_checker [DUP 2;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);DUP 2;PUSH 1 (posToWord WLen 0x5%positive)] [DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x4%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x5%positive)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 PUSH 40 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 40 ADD PUSH 40
*)
Compute pair "BottleCastle_initial_block_4_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH D DUP2
 O: DUP1 PUSH d DUP2
*)
Compute pair "BottleCastle_initial_block_4_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0xd%positive);DUP 2] [DUP 1;PUSH 1 (posToWord WLen 0xD%positive);DUP 2] 1 optimize_id).

(*
 I: PUSH 20 ADD PUSH 426F74746C6520436173746C6500000000000000000000000000000000000000 DUP2
 O: PUSH 20 ADD PUSH 426f74746c6520436173746c6500000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_initial_block_4_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 32 (posToWord WLen 0x426f74746c6520436173746c6500000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 32 (posToWord WLen 0x426F74746C6520436173746C6500000000000000000000000000000000000000%positive);DUP 2] 1 optimize_id).

(*
 I: POP PUSH 40 MLOAD DUP1 PUSH 40 ADD PUSH 40
 O: POP PUSH 40 MLOAD DUP1 PUSH 40 ADD PUSH 40
*)
Compute pair "BottleCastle_initial_block_4_3"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [POP;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 6 DUP2
 O: DUP1 PUSH 6 DUP2
*)
Compute pair "BottleCastle_initial_block_4_4"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x6%positive);DUP 2] [DUP 1;PUSH 1 (posToWord WLen 0x6%positive);DUP 2] 1 optimize_id).

(*
 I: PUSH 20 ADD PUSH 426F74746C650000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 20 ADD PUSH 426f74746c650000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_initial_block_4_5"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 32 (posToWord WLen 0x426f74746c650000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 32 (posToWord WLen 0x426F74746C650000000000000000000000000000000000000000000000000000%positive);DUP 2] 1 optimize_id).

(*
 I: POP DUP2 PUSH 2 SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 11 SWAP3 SWAP2 SWAP1 PUSH [tag] 2
 O: POP PUSH [tag] 11 PUSH 2 DUP4 PUSH 20 ADD DUP5 MLOAD PUSH [tag] 2
*)
Compute pair "BottleCastle_initial_block_4_6"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xb%positive);PUSH 1 (posToWord WLen 0x2%positive);DUP 4;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 5;Opcode MLOAD;PUSH 1 (posToWord WLen 0x2%positive)] [POP;DUP 2;PUSH 1 (posToWord WLen 0x2%positive);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0xb%positive);DUP 3;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x2%positive)] 3 optimize_id).

(*
 I: POP DUP1 PUSH 3 SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 12 SWAP3 SWAP2 SWAP1 PUSH [tag] 2
 O: POP PUSH [tag] 12 PUSH 3 PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 2
*)
Compute pair "BottleCastle_initial_block_5_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xc%positive);PUSH 1 (posToWord WLen 0x3%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 1 (posToWord WLen 0x2%positive)] [POP;DUP 1;PUSH 1 (posToWord WLen 0x3%positive);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0xc%positive);DUP 3;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x2%positive)] 2 optimize_id).

(*
 I: POP PUSH [tag] 13 PUSH [tag] 14 PUSH 20 SHL PUSH 20 SHR
 O: POP PUSH [tag] 13 PUSH [tag] 14 PUSH 20 SHL PUSH 20 SHR
*)
Compute pair "BottleCastle_initial_block_6_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xd%positive);PUSH 1 (posToWord WLen 0xe%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] [POP;PUSH 1 (posToWord WLen 0xd%positive);PUSH 1 (posToWord WLen 0xe%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] 1 optimize_id).

(*
 I: PUSH 0 DUP2 SWAP1
 O: DUP1 PUSH 0
*)
Compute pair "BottleCastle_initial_block_7_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;DUP 1] 1 optimize_id).

(*
 I: POP POP POP PUSH [tag] 16 PUSH [tag] 17 PUSH [tag] 18 PUSH 20 SHL PUSH 20 SHR
 O: POP POP POP PUSH [tag] 16 PUSH [tag] 17 PUSH [tag] 18 PUSH 20 SHL PUSH 20 SHR
*)
Compute pair "BottleCastle_initial_block_7_1"%string (equiv_checker [POP;POP;POP;PUSH 1 (posToWord WLen 0x10%positive);PUSH 1 (posToWord WLen 0x11%positive);PUSH 1 (posToWord WLen 0x12%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] [POP;POP;POP;PUSH 1 (posToWord WLen 0x10%positive);PUSH 1 (posToWord WLen 0x11%positive);PUSH 1 (posToWord WLen 0x12%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] 3 optimize_id).

(*
 I: PUSH [tag] 19 PUSH 20 SHL PUSH 20 SHR
 O: PUSH [tag] 19 PUSH 20 SHL PUSH 20 SHR
*)
Compute pair "BottleCastle_initial_block_8_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x13%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] [PUSH 1 (posToWord WLen 0x13%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] 0 optimize_id).

(*
 I: PUSH 1 PUSH 9 DUP2 SWAP1
 O: PUSH 1 DUP1 PUSH 9
*)
Compute pair "BottleCastle_initial_block_9_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive);DUP 1;PUSH 1 (posToWord WLen 0x9%positive)] [PUSH 1 (posToWord WLen 0x1%positive);PUSH 1 (posToWord WLen 0x9%positive);DUP 2;DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 22 DUP3 PUSH [tag] 23 PUSH 20 SHL PUSH 20 SHR
 O: POP PUSH [tag] 22 DUP3 PUSH [tag] 23 PUSH 20 SHL PUSH 20 SHR
*)
Compute pair "BottleCastle_initial_block_9_1"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x16%positive);DUP 3;PUSH 1 (posToWord WLen 0x17%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] [POP;PUSH 1 (posToWord WLen 0x16%positive);DUP 3;PUSH 1 (posToWord WLen 0x17%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] 3 optimize_id).

(*
 I: PUSH [tag] 24 DUP2 PUSH [tag] 25 PUSH 20 SHL PUSH 20 SHR
 O: PUSH [tag] 24 DUP2 PUSH [tag] 25 PUSH 20 SHL PUSH 20 SHR
*)
Compute pair "BottleCastle_initial_block_10_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x18%positive);DUP 2;PUSH 1 (posToWord WLen 0x19%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] [PUSH 1 (posToWord WLen 0x18%positive);DUP 2;PUSH 1 (posToWord WLen 0x19%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] 1 optimize_id).

(*
 I: POP POP PUSH [tag] 26
 O: POP POP PUSH [tag] 26
*)
Compute pair "BottleCastle_initial_block_11_0"%string (equiv_checker [POP;POP;PUSH 1 (posToWord WLen 0x1a%positive)] [POP;POP;PUSH 1 (posToWord WLen 0x1a%positive)] 2 optimize_id).

(*
 I: PUSH 0 PUSH 1 SWAP1 POP SWAP1
 O: PUSH 1 SWAP1
*)
Compute pair "BottleCastle_initial_block_12_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x1%positive);DUP 1;POP;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 CALLER SWAP1 POP SWAP1
 O: CALLER SWAP1
*)
Compute pair "BottleCastle_initial_block_13_0"%string (equiv_checker [Opcode CALLER;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);Opcode CALLER;DUP 1;POP;DUP 1] 1 optimize_id).

(*
 I: POP DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 8BE0079C531659141344CD1FD0A4F28419497F9722A3DAAFE3B4186F6B6457E0 PUSH 40 MLOAD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: POP PUSH 40 MLOAD DUP1 DUP1 SUB PUSH 8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP5 DUP2 AND SWAP3 SWAP1 DUP7 AND SWAP4
*)
Compute pair "BottleCastle_initial_block_14_1"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 1;Opcode SUB;PUSH 32 (posToWord WLen 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0%positive);PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 5;DUP 2;Opcode AND;DUP 3;DUP 1;DUP 7;Opcode AND;DUP 4] [POP;DUP 2;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 32 (posToWord WLen 0x8BE0079C531659141344CD1FD0A4F28419497F9722A3DAAFE3B4186F6B6457E0%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 3 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_initial_block_14_2"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH [tag] 31 PUSH [tag] 32 PUSH 20 SHL PUSH 20 SHR
 O: PUSH [tag] 31 PUSH [tag] 32 PUSH 20 SHL PUSH 20 SHR
*)
Compute pair "BottleCastle_initial_block_15_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1f%positive);PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] [PUSH 1 (posToWord WLen 0x1f%positive);PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] 0 optimize_id).

(*
 I: DUP1 PUSH A SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 34 SWAP3 SWAP2 SWAP1 PUSH [tag] 2
 O: PUSH [tag] 34 PUSH a PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 2
*)
Compute pair "BottleCastle_initial_block_16_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x22%positive);PUSH 1 (posToWord WLen 0xa%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 1 (posToWord WLen 0x2%positive)] [DUP 1;PUSH 1 (posToWord WLen 0xA%positive);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x22%positive);DUP 3;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x2%positive)] 1 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_initial_block_17_0"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH [tag] 36 PUSH [tag] 32 PUSH 20 SHL PUSH 20 SHR
 O: PUSH [tag] 36 PUSH [tag] 32 PUSH 20 SHL PUSH 20 SHR
*)
Compute pair "BottleCastle_initial_block_18_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] 0 optimize_id).

(*
 I: DUP1 PUSH C SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 38 SWAP3 SWAP2 SWAP1 PUSH [tag] 2
 O: PUSH [tag] 38 PUSH c PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 2
*)
Compute pair "BottleCastle_initial_block_19_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x26%positive);PUSH 1 (posToWord WLen 0xc%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 1 (posToWord WLen 0x2%positive)] [DUP 1;PUSH 1 (posToWord WLen 0xC%positive);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x26%positive);DUP 3;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x2%positive)] 1 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_initial_block_20_0"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH [tag] 40 PUSH [tag] 18 PUSH 20 SHL PUSH 20 SHR
 O: PUSH [tag] 40 PUSH [tag] 18 PUSH 20 SHL PUSH 20 SHR
*)
Compute pair "BottleCastle_initial_block_21_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x28%positive);PUSH 1 (posToWord WLen 0x12%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] [PUSH 1 (posToWord WLen 0x28%positive);PUSH 1 (posToWord WLen 0x12%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] 0 optimize_id).

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH [tag] 41 PUSH [tag] 42 PUSH 20 SHL PUSH 20 SHR
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH [tag] 41 PUSH [tag] 42 PUSH 20 SHL PUSH 20 SHR
*)
Compute pair "BottleCastle_initial_block_22_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 1 (posToWord WLen 0x29%positive);PUSH 1 (posToWord WLen 0x2a%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] [PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 1 (posToWord WLen 0x29%positive);PUSH 1 (posToWord WLen 0x2a%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] 1 optimize_id).

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ PUSH [tag] 43
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ PUSH [tag] 43
*)
Compute pair "BottleCastle_initial_block_23_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;Opcode EQ;PUSH 1 (posToWord WLen 0x2b%positive)] [PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode EQ;PUSH 1 (posToWord WLen 0x2b%positive)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_initial_block_24_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8c379a000000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8C379A000000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 44 SWAP1 PUSH [tag] 45
 O: PUSH [tag] 44 SWAP1 PUSH 4 ADD PUSH [tag] 45
*)
Compute pair "BottleCastle_initial_block_24_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2c%positive);DUP 1;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x2d%positive)] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x2c%positive);DUP 1;PUSH 1 (posToWord WLen 0x2d%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_initial_block_25_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 PUSH 8 PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1 POP SWAP1
 O: PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 PUSH 100 EXP PUSH 8 SLOAD DIV AND SWAP1
*)
Compute pair "BottleCastle_initial_block_27_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;PUSH 1 (posToWord WLen 0x8%positive);Opcode SLOAD;Opcode DIV;Opcode AND;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x8%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 1;Opcode DIV;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 1;POP;DUP 1] 1 optimize_id).

(*
 I: DUP3 DUP1 SLOAD PUSH [tag] 47 SWAP1 PUSH [tag] 48
 O: DUP3 PUSH [tag] 47 DUP5 SLOAD PUSH [tag] 48
*)
Compute pair "BottleCastle_initial_block_28_0"%string (equiv_checker [DUP 3;PUSH 1 (posToWord WLen 0x2f%positive);DUP 5;Opcode SLOAD;PUSH 1 (posToWord WLen 0x30%positive)] [DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (posToWord WLen 0x2f%positive);DUP 1;PUSH 1 (posToWord WLen 0x30%positive)] 3 optimize_id).

(*
 I: SWAP1 PUSH 0
 O: SWAP1 PUSH 0
*)
Compute pair "BottleCastle_initial_block_29_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] 2 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1 PUSH 1F ADD PUSH 20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 50
 O: PUSH 20 DUP1 PUSH 0 KECCAK256 SWAP2 PUSH 1f ADD DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 50
*)
Compute pair "BottleCastle_initial_block_29_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);DUP 1;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 2;PUSH 1 (posToWord WLen 0x1f%positive);Opcode ADD;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 1 (posToWord WLen 0x32%positive)] [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 1 (posToWord WLen 0x32%positive)] 3 optimize_id).

(*
 I: PUSH 0 DUP6
 O: PUSH 0 DUP6
*)
Compute pair "BottleCastle_initial_block_30_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 6] [PUSH 1 (posToWord WLen 0x0%positive);DUP 6] 5 optimize_id).

(*
 I: PUSH [tag] 49
 O: PUSH [tag] 49
*)
Compute pair "BottleCastle_initial_block_30_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x31%positive)] [PUSH 1 (posToWord WLen 0x31%positive)] 0 optimize_id).

(*
 I: DUP3 PUSH 1F LT PUSH [tag] 51
 O: DUP3 PUSH 1f LT PUSH [tag] 51
*)
Compute pair "BottleCastle_initial_block_31_0"%string (equiv_checker [DUP 3;PUSH 1 (posToWord WLen 0x1f%positive);Opcode LT;PUSH 1 (posToWord WLen 0x33%positive)] [DUP 3;PUSH 1 (posToWord WLen 0x1F%positive);Opcode LT;PUSH 1 (posToWord WLen 0x33%positive)] 3 optimize_id).

(*
 I: DUP1 MLOAD PUSH FF NOT AND DUP4 DUP1 ADD OR DUP6
 O: DUP3 DUP1 ADD PUSH ff NOT DUP3 MLOAD AND OR DUP6
*)
Compute pair "BottleCastle_initial_block_32_0"%string (equiv_checker [DUP 3;DUP 1;Opcode ADD;PUSH 1 (posToWord WLen 0xff%positive);Opcode NOT;DUP 3;Opcode MLOAD;Opcode AND;Opcode OR;DUP 6] [DUP 1;Opcode MLOAD;PUSH 1 (posToWord WLen 0xFF%positive);Opcode NOT;Opcode AND;DUP 4;DUP 1;Opcode ADD;Opcode OR;DUP 6] 5 optimize_id).

(*
 I: PUSH [tag] 49
 O: PUSH [tag] 49
*)
Compute pair "BottleCastle_initial_block_32_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x31%positive)] [PUSH 1 (posToWord WLen 0x31%positive)] 0 optimize_id).

(*
 I: DUP3 DUP1 ADD PUSH 1 ADD DUP6
 O: DUP3 DUP4 ADD PUSH 1 ADD DUP6
*)
Compute pair "BottleCastle_initial_block_33_0"%string (equiv_checker [DUP 3;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 6] [DUP 3;DUP 1;Opcode ADD;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 6] 5 optimize_id).

(*
 I: DUP3 ISZERO PUSH [tag] 49
 O: DUP3 ISZERO PUSH [tag] 49
*)
Compute pair "BottleCastle_initial_block_33_1"%string (equiv_checker [DUP 3;Opcode ISZERO;PUSH 1 (posToWord WLen 0x31%positive)] [DUP 3;Opcode ISZERO;PUSH 1 (posToWord WLen 0x31%positive)] 3 optimize_id).

(*
 I: SWAP2 DUP3 ADD
 O: DUP1 SWAP3 ADD
*)
Compute pair "BottleCastle_initial_block_34_0"%string (equiv_checker [DUP 1;DUP 3;Opcode ADD] [DUP 2;DUP 3;Opcode ADD] 3 optimize_id).

(*
 I: DUP3 DUP2 GT ISZERO PUSH [tag] 53
 O: DUP3 DUP2 GT ISZERO PUSH [tag] 53
*)
Compute pair "BottleCastle_initial_block_35_0"%string (equiv_checker [DUP 3;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x35%positive)] [DUP 3;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x35%positive)] 3 optimize_id).

(*
 I: DUP3 MLOAD DUP3
 O: DUP3 MLOAD DUP3
*)
Compute pair "BottleCastle_initial_block_36_0"%string (equiv_checker [DUP 3;Opcode MLOAD;DUP 3] [DUP 3;Opcode MLOAD;DUP 3] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 SWAP1 PUSH 1 ADD SWAP1 PUSH [tag] 52
 O: SWAP2 PUSH 20 ADD SWAP2 SWAP1 PUSH 1 ADD SWAP1 PUSH [tag] 52
*)
Compute pair "BottleCastle_initial_block_36_1"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x34%positive)] [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x34%positive)] 3 optimize_id).

(*
 I: POP SWAP1 POP PUSH [tag] 54 SWAP2 SWAP1 PUSH [tag] 55
 O: POP PUSH [tag] 54 SWAP3 SWAP2 POP PUSH [tag] 55
*)
Compute pair "BottleCastle_initial_block_38_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x36%positive);DUP 3;DUP 2;POP;PUSH 1 (posToWord WLen 0x37%positive)] [POP;DUP 1;POP;PUSH 1 (posToWord WLen 0x36%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x37%positive)] 4 optimize_id).

(*
 I: POP SWAP1
 O: POP SWAP1
*)
Compute pair "BottleCastle_initial_block_39_0"%string (equiv_checker [POP;DUP 1] [POP;DUP 1] 3 optimize_id).

(*
 I: DUP1 DUP3 GT ISZERO PUSH [tag] 57
 O: DUP1 DUP3 GT ISZERO PUSH [tag] 57
*)
Compute pair "BottleCastle_initial_block_41_0"%string (equiv_checker [DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x39%positive)] [DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x39%positive)] 2 optimize_id).

(*
 I: PUSH 0 DUP2 PUSH 0 SWAP1
 O: PUSH 0 DUP1 DUP3
*)
Compute pair "BottleCastle_initial_block_42_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;DUP 3] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 1 optimize_id).

(*
 I: POP PUSH 1 ADD PUSH [tag] 56
 O: POP PUSH 1 ADD PUSH [tag] 56
*)
Compute pair "BottleCastle_initial_block_42_1"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x38%positive)] [POP;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x38%positive)] 2 optimize_id).

(*
 I: POP SWAP1
 O: POP SWAP1
*)
Compute pair "BottleCastle_initial_block_43_0"%string (equiv_checker [POP;DUP 1] [POP;DUP 1] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 61 PUSH [tag] 62 DUP5 PUSH [tag] 63
 O: PUSH 0 PUSH [tag] 61 PUSH [tag] 62 DUP5 PUSH [tag] 63
*)
Compute pair "BottleCastle_initial_block_44_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x3d%positive);PUSH 1 (posToWord WLen 0x3e%positive);DUP 5;PUSH 1 (posToWord WLen 0x3f%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x3d%positive);PUSH 1 (posToWord WLen 0x3e%positive);DUP 5;PUSH 1 (posToWord WLen 0x3f%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 64
 O: PUSH [tag] 64
*)
Compute pair "BottleCastle_initial_block_45_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 1 (posToWord WLen 0x40%positive)] 0 optimize_id).

(*
 I: SWAP1 POP DUP3 DUP2
 O: SWAP1 POP DUP3 DUP2
*)
Compute pair "BottleCastle_initial_block_46_0"%string (equiv_checker [DUP 1;POP;DUP 3;DUP 2] [DUP 1;POP;DUP 3;DUP 2] 4 optimize_id).

(*
 I: PUSH 20 DUP2 ADD DUP5 DUP5 DUP5 ADD GT ISZERO PUSH [tag] 65
 O: DUP1 PUSH 20 ADD DUP5 DUP4 DUP6 ADD GT ISZERO PUSH [tag] 65
*)
Compute pair "BottleCastle_initial_block_46_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 5;DUP 4;DUP 6;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x41%positive)] [PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;DUP 5;DUP 5;DUP 5;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x41%positive)] 4 optimize_id).

(*
 I: PUSH [tag] 66 PUSH [tag] 67
 O: PUSH [tag] 66 PUSH [tag] 67
*)
Compute pair "BottleCastle_initial_block_47_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x42%positive);PUSH 1 (posToWord WLen 0x43%positive)] [PUSH 1 (posToWord WLen 0x42%positive);PUSH 1 (posToWord WLen 0x43%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 68 DUP5 DUP3 DUP6 PUSH [tag] 69
 O: PUSH [tag] 68 DUP5 DUP3 DUP6 PUSH [tag] 69
*)
Compute pair "BottleCastle_initial_block_49_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x44%positive);DUP 5;DUP 3;DUP 6;PUSH 1 (posToWord WLen 0x45%positive)] [PUSH 1 (posToWord WLen 0x44%positive);DUP 5;DUP 3;DUP 6;PUSH 1 (posToWord WLen 0x45%positive)] 4 optimize_id).

(*
 I: POP SWAP4 SWAP3 POP POP POP
 O: POP SWAP4 SWAP3 POP POP POP
*)
Compute pair "BottleCastle_initial_block_50_0"%string (equiv_checker [POP;DUP 4;DUP 3;POP;POP;POP] [POP;DUP 4;DUP 3;POP;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 72
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 72
*)
Compute pair "BottleCastle_initial_block_51_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 3;PUSH 1 (posToWord WLen 0x1f%positive);Opcode ADD;Opcode SLT;PUSH 1 (posToWord WLen 0x48%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;PUSH 1 (posToWord WLen 0x1F%positive);DUP 4;Opcode ADD;Opcode SLT;PUSH 1 (posToWord WLen 0x48%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 73 PUSH [tag] 74
 O: PUSH [tag] 73 PUSH [tag] 74
*)
Compute pair "BottleCastle_initial_block_52_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x49%positive);PUSH 1 (posToWord WLen 0x4a%positive)] [PUSH 1 (posToWord WLen 0x49%positive);PUSH 1 (posToWord WLen 0x4a%positive)] 0 optimize_id).

(*
 I: DUP2 MLOAD PUSH [tag] 75 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 59
 O: DUP2 MLOAD PUSH [tag] 75 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 59
*)
Compute pair "BottleCastle_initial_block_54_0"%string (equiv_checker [DUP 2;Opcode MLOAD;PUSH 1 (posToWord WLen 0x4b%positive);DUP 5;DUP 3;PUSH 1 (posToWord WLen 0x20%positive);DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0x3b%positive)] [DUP 2;Opcode MLOAD;PUSH 1 (posToWord WLen 0x4b%positive);DUP 5;DUP 3;PUSH 1 (posToWord WLen 0x20%positive);DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0x3b%positive)] 3 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute pair "BottleCastle_initial_block_55_0"%string (equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 77
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 77
*)
Compute pair "BottleCastle_initial_block_56_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x4d%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x4d%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 78 PUSH [tag] 79
 O: PUSH [tag] 78 PUSH [tag] 79
*)
Compute pair "BottleCastle_initial_block_57_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x4e%positive);PUSH 1 (posToWord WLen 0x4f%positive)] [PUSH 1 (posToWord WLen 0x4e%positive);PUSH 1 (posToWord WLen 0x4f%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP4 ADD MLOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 80
 O: DUP3 PUSH 0 ADD MLOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 80
*)
Compute pair "BottleCastle_initial_block_59_0"%string (equiv_checker [DUP 3;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;Opcode MLOAD;PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x50%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD;Opcode MLOAD;PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x50%positive)] 3 optimize_id).

(*
 I: PUSH [tag] 81 PUSH [tag] 82
 O: PUSH [tag] 81 PUSH [tag] 82
*)
Compute pair "BottleCastle_initial_block_60_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x51%positive);PUSH 1 (posToWord WLen 0x52%positive)] [PUSH 1 (posToWord WLen 0x51%positive);PUSH 1 (posToWord WLen 0x52%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 83 DUP6 DUP3 DUP7 ADD PUSH [tag] 70
 O: PUSH [tag] 83 DUP6 DUP3 DUP7 ADD PUSH [tag] 70
*)
Compute pair "BottleCastle_initial_block_62_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x53%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0x46%positive)] [PUSH 1 (posToWord WLen 0x53%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0x46%positive)] 5 optimize_id).

(*
 I: SWAP3 POP POP PUSH 20 DUP4 ADD MLOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 84
 O: SWAP3 POP POP DUP3 PUSH 20 ADD MLOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 84
*)
Compute pair "BottleCastle_initial_block_63_0"%string (equiv_checker [DUP 3;POP;POP;DUP 3;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;Opcode MLOAD;PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x54%positive)] [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);DUP 4;Opcode ADD;Opcode MLOAD;PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x54%positive)] 5 optimize_id).

(*
 I: PUSH [tag] 85 PUSH [tag] 82
 O: PUSH [tag] 85 PUSH [tag] 82
*)
Compute pair "BottleCastle_initial_block_64_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x55%positive);PUSH 1 (posToWord WLen 0x52%positive)] [PUSH 1 (posToWord WLen 0x55%positive);PUSH 1 (posToWord WLen 0x52%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 86 DUP6 DUP3 DUP7 ADD PUSH [tag] 70
 O: PUSH [tag] 86 DUP6 DUP3 DUP7 ADD PUSH [tag] 70
*)
Compute pair "BottleCastle_initial_block_66_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x56%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0x46%positive)] [PUSH 1 (posToWord WLen 0x56%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0x46%positive)] 5 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute pair "BottleCastle_initial_block_67_0"%string (equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 89 PUSH 20 DUP4 PUSH [tag] 90
 O: PUSH 0 PUSH [tag] 89 PUSH 20 DUP4 PUSH [tag] 90
*)
Compute pair "BottleCastle_initial_block_68_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x59%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 4;PUSH 1 (posToWord WLen 0x5a%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x59%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 4;PUSH 1 (posToWord WLen 0x5a%positive)] 1 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 91 DUP3 PUSH [tag] 92
 O: SWAP2 POP PUSH [tag] 91 DUP3 PUSH [tag] 92
*)
Compute pair "BottleCastle_initial_block_69_0"%string (equiv_checker [DUP 2;POP;PUSH 1 (posToWord WLen 0x5b%positive);DUP 3;PUSH 1 (posToWord WLen 0x5c%positive)] [DUP 2;POP;PUSH 1 (posToWord WLen 0x5b%positive);DUP 3;PUSH 1 (posToWord WLen 0x5c%positive)] 3 optimize_id).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Compute pair "BottleCastle_initial_block_70_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute pair "BottleCastle_initial_block_71_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] 1 optimize_id).

(*
 I: PUSH [tag] 94 DUP2 PUSH [tag] 87
 O: PUSH [tag] 94 DUP2 PUSH [tag] 87
*)
Compute pair "BottleCastle_initial_block_71_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x5e%positive);DUP 2;PUSH 1 (posToWord WLen 0x57%positive)] [PUSH 1 (posToWord WLen 0x5e%positive);DUP 2;PUSH 1 (posToWord WLen 0x57%positive)] 1 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_initial_block_72_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 96 PUSH [tag] 97
 O: PUSH 0 PUSH [tag] 96 PUSH [tag] 97
*)
Compute pair "BottleCastle_initial_block_73_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x61%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x61%positive)] 0 optimize_id).

(*
 I: SWAP1 POP PUSH [tag] 98 DUP3 DUP3 PUSH [tag] 99
 O: SWAP1 POP PUSH [tag] 98 DUP3 DUP3 PUSH [tag] 99
*)
Compute pair "BottleCastle_initial_block_74_0"%string (equiv_checker [DUP 1;POP;PUSH 1 (posToWord WLen 0x62%positive);DUP 3;DUP 3;PUSH 1 (posToWord WLen 0x63%positive)] [DUP 1;POP;PUSH 1 (posToWord WLen 0x62%positive);DUP 3;DUP 3;PUSH 1 (posToWord WLen 0x63%positive)] 3 optimize_id).

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Compute pair "BottleCastle_initial_block_75_0"%string (equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH 40 MLOAD SWAP1 POP SWAP1
 O: PUSH 40 MLOAD SWAP1
*)
Compute pair "BottleCastle_initial_block_76_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;POP;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFF DUP3 GT ISZERO PUSH [tag] 102
 O: PUSH 0 PUSH ffffffffffffffff DUP3 GT ISZERO PUSH [tag] 102
*)
Compute pair "BottleCastle_initial_block_77_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x66%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x66%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 103 PUSH [tag] 104
 O: PUSH [tag] 103 PUSH [tag] 104
*)
Compute pair "BottleCastle_initial_block_78_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x67%positive);PUSH 1 (posToWord WLen 0x68%positive)] [PUSH 1 (posToWord WLen 0x67%positive);PUSH 1 (posToWord WLen 0x68%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 105 DUP3 PUSH [tag] 106
 O: PUSH [tag] 105 DUP3 PUSH [tag] 106
*)
Compute pair "BottleCastle_initial_block_80_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x69%positive);DUP 3;PUSH 1 (posToWord WLen 0x6a%positive)] [PUSH 1 (posToWord WLen 0x69%positive);DUP 3;PUSH 1 (posToWord WLen 0x6a%positive)] 2 optimize_id).

(*
 I: SWAP1 POP PUSH 20 DUP2 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_initial_block_81_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;POP;POP;DUP 1] [DUP 1;POP;PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP3 DUP3
 O: PUSH 0 DUP3 DUP3
*)
Compute pair "BottleCastle_initial_block_82_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 3] [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 3] 2 optimize_id).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP PUSH 20 SWAP2 POP ADD SWAP1
*)
Compute pair "BottleCastle_initial_block_82_1"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x20%positive);DUP 2;POP;Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0
 O: PUSH 0
*)
Compute pair "BottleCastle_initial_block_83_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: DUP4 DUP2 LT ISZERO PUSH [tag] 111
 O: DUP4 DUP2 LT ISZERO PUSH [tag] 111
*)
Compute pair "BottleCastle_initial_block_84_0"%string (equiv_checker [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x6f%positive)] [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x6f%positive)] 4 optimize_id).

(*
 I: DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD
 O: DUP2 DUP2 ADD MLOAD DUP4 DUP3 ADD
*)
Compute pair "BottleCastle_initial_block_85_0"%string (equiv_checker [DUP 2;DUP 2;Opcode ADD;Opcode MLOAD;DUP 4;DUP 3;Opcode ADD] [DUP 1;DUP 3;Opcode ADD;Opcode MLOAD;DUP 2;DUP 5;Opcode ADD] 3 optimize_id).

(*
 I: PUSH 20 DUP2 ADD SWAP1 POP PUSH [tag] 109
 O: PUSH 20 ADD PUSH [tag] 109
*)
Compute pair "BottleCastle_initial_block_85_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x6d%positive)] [PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;DUP 1;POP;PUSH 1 (posToWord WLen 0x6d%positive)] 1 optimize_id).

(*
 I: DUP4 DUP2 GT ISZERO PUSH [tag] 112
 O: DUP4 DUP2 GT ISZERO PUSH [tag] 112
*)
Compute pair "BottleCastle_initial_block_86_0"%string (equiv_checker [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x70%positive)] [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x70%positive)] 4 optimize_id).

(*
 I: PUSH 0 DUP5 DUP5 ADD
 O: PUSH 0 DUP4 DUP6 ADD
*)
Compute pair "BottleCastle_initial_block_87_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 6;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);DUP 5;DUP 5;Opcode ADD] 4 optimize_id).

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Compute pair "BottleCastle_initial_block_88_0"%string (equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 2 DUP3 DIV SWAP1 POP PUSH 1 DUP3 AND DUP1 PUSH [tag] 114
 O: PUSH 2 DUP2 DIV DUP2 PUSH 1 AND DUP1 PUSH [tag] 114
*)
Compute pair "BottleCastle_initial_block_89_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2%positive);DUP 2;Opcode DIV;DUP 2;PUSH 1 (posToWord WLen 0x1%positive);Opcode AND;DUP 1;PUSH 1 (posToWord WLen 0x72%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x2%positive);DUP 3;Opcode DIV;DUP 1;POP;PUSH 1 (posToWord WLen 0x1%positive);DUP 3;Opcode AND;DUP 1;PUSH 1 (posToWord WLen 0x72%positive)] 1 optimize_id).

(*
 I: PUSH 7F DUP3 AND SWAP2 POP
 O: SWAP1 PUSH 7f AND SWAP1
*)
Compute pair "BottleCastle_initial_block_90_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x7f%positive);Opcode AND;DUP 1] [PUSH 1 (posToWord WLen 0x7F%positive);DUP 3;Opcode AND;DUP 2;POP] 2 optimize_id).

(*
 I: PUSH 20 DUP3 LT DUP2 EQ ISZERO PUSH [tag] 115
 O: DUP1 PUSH 20 DUP4 LT EQ ISZERO PUSH [tag] 115
*)
Compute pair "BottleCastle_initial_block_91_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);DUP 4;Opcode LT;Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0x73%positive)] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode LT;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0x73%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 116 PUSH [tag] 117
 O: PUSH [tag] 116 PUSH [tag] 117
*)
Compute pair "BottleCastle_initial_block_92_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x74%positive);PUSH 1 (posToWord WLen 0x75%positive)] [PUSH 1 (posToWord WLen 0x74%positive);PUSH 1 (posToWord WLen 0x75%positive)] 0 optimize_id).

(*
 I: POP SWAP2 SWAP1 POP
 O: POP SWAP2 SWAP1 POP
*)
Compute pair "BottleCastle_initial_block_94_0"%string (equiv_checker [POP;DUP 2;DUP 1;POP] [POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH [tag] 119 DUP3 PUSH [tag] 106
 O: PUSH [tag] 119 DUP3 PUSH [tag] 106
*)
Compute pair "BottleCastle_initial_block_95_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x77%positive);DUP 3;PUSH 1 (posToWord WLen 0x6a%positive)] [PUSH 1 (posToWord WLen 0x77%positive);DUP 3;PUSH 1 (posToWord WLen 0x6a%positive)] 2 optimize_id).

(*
 I: DUP2 ADD DUP2 DUP2 LT PUSH FFFFFFFFFFFFFFFF DUP3 GT OR ISZERO PUSH [tag] 120
 O: DUP2 ADD PUSH ffffffffffffffff DUP2 GT DUP3 DUP3 LT OR ISZERO PUSH [tag] 120
*)
Compute pair "BottleCastle_initial_block_96_0"%string (equiv_checker [DUP 2;Opcode ADD;PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 2;Opcode GT;DUP 3;DUP 3;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 1 (posToWord WLen 0x78%positive)] [DUP 2;Opcode ADD;DUP 2;DUP 2;Opcode LT;PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);DUP 3;Opcode GT;Opcode OR;Opcode ISZERO;PUSH 1 (posToWord WLen 0x78%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 121 PUSH [tag] 104
 O: PUSH [tag] 121 PUSH [tag] 104
*)
Compute pair "BottleCastle_initial_block_97_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x79%positive);PUSH 1 (posToWord WLen 0x68%positive)] [PUSH 1 (posToWord WLen 0x79%positive);PUSH 1 (posToWord WLen 0x68%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 40
 O: DUP1 PUSH 40
*)
Compute pair "BottleCastle_initial_block_99_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x40%positive)] 1 optimize_id).

(*
 I: POP POP POP
 O: POP POP POP
*)
Compute pair "BottleCastle_initial_block_99_1"%string (equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id).

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Compute pair "BottleCastle_initial_block_100_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x4e487b7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 32 (posToWord WLen 0x4E487B7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 22 PUSH 4
 O: PUSH 22 PUSH 4
*)
Compute pair "BottleCastle_initial_block_100_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x22%positive);PUSH 1 (posToWord WLen 0x4%positive)] [PUSH 1 (posToWord WLen 0x22%positive);PUSH 1 (posToWord WLen 0x4%positive)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "BottleCastle_initial_block_100_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Compute pair "BottleCastle_initial_block_101_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x4e487b7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 32 (posToWord WLen 0x4E487B7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 41 PUSH 4
 O: PUSH 41 PUSH 4
*)
Compute pair "BottleCastle_initial_block_101_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x41%positive);PUSH 1 (posToWord WLen 0x4%positive)] [PUSH 1 (posToWord WLen 0x41%positive);PUSH 1 (posToWord WLen 0x4%positive)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "BottleCastle_initial_block_101_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_initial_block_102_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_initial_block_103_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_initial_block_104_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_initial_block_105_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 PUSH 1F NOT PUSH 1F DUP4 ADD AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 1f ADD PUSH 1f NOT AND SWAP1
*)
Compute pair "BottleCastle_initial_block_106_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1f%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x1f%positive);Opcode NOT;Opcode AND;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x1F%positive);Opcode NOT;PUSH 1 (posToWord WLen 0x1F%positive);DUP 4;Opcode ADD;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH 4F776E61626C653A2063616C6C6572206973206E6F7420746865206F776E6572 PUSH 0 DUP3 ADD
 O: PUSH 4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572 DUP2 PUSH 0 ADD
*)
Compute pair "BottleCastle_initial_block_107_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572%positive);DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD] [PUSH 32 (posToWord WLen 0x4F776E61626C653A2063616C6C6572206973206E6F7420746865206F776E6572%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_initial_block_107_1"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH #[$] 0000000000000000000000000000000000000000000000000000000000000000 DUP1 PUSH [$] 0000000000000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH #[$] 0 DUP1 PUSH [$] 0 PUSH 0
  ERROR OCCURRED

'PUSH #[$]' is not in list
*)

(*
 I: PUSH 0
 O: PUSH 0
*)
Compute pair "BottleCastle_initial_block_108_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 80 PUSH 40
 O: PUSH 80 PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_0_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x80%positive);PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 1 (posToWord WLen 0x80%positive);PUSH 1 (posToWord WLen 0x40%positive)] 0 optimize_id).

(*
 I: PUSH 4 CALLDATASIZE LT PUSH [tag] 1
 O: PUSH 4 CALLDATASIZE LT PUSH [tag] 1
*)
Compute pair "BottleCastle_run_code_of_0_block_0_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x4%positive);Opcode CALLDATASIZE;Opcode LT;PUSH 1 (posToWord WLen 0x1%positive)] [PUSH 1 (posToWord WLen 0x4%positive);Opcode CALLDATASIZE;Opcode LT;PUSH 1 (posToWord WLen 0x1%positive)] 0 optimize_id).

(*
 I: PUSH 0 CALLDATALOAD PUSH E0 SHR DUP1 PUSH 715018A6 GT PUSH [tag] 39
 O: PUSH 0 CALLDATALOAD PUSH e0 SHR DUP1 PUSH 715018a6 GT PUSH [tag] 39
*)
Compute pair "BottleCastle_run_code_of_0_block_1_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);Opcode CALLDATALOAD;PUSH 1 (posToWord WLen 0xe0%positive);Opcode SHR;DUP 1;PUSH 4 (posToWord WLen 0x715018a6%positive);Opcode GT;PUSH 1 (posToWord WLen 0x27%positive)] [PUSH 1 (posToWord WLen 0x0%positive);Opcode CALLDATALOAD;PUSH 1 (posToWord WLen 0xE0%positive);Opcode SHR;DUP 1;PUSH 4 (posToWord WLen 0x715018A6%positive);Opcode GT;PUSH 1 (posToWord WLen 0x27%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH BD7A1998 GT PUSH [tag] 40
 O: DUP1 PUSH bd7a1998 GT PUSH [tag] 40
*)
Compute pair "BottleCastle_run_code_of_0_block_2_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xbd7a1998%positive);Opcode GT;PUSH 1 (posToWord WLen 0x28%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xBD7A1998%positive);Opcode GT;PUSH 1 (posToWord WLen 0x28%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH DC33E681 GT PUSH [tag] 41
 O: DUP1 PUSH dc33e681 GT PUSH [tag] 41
*)
Compute pair "BottleCastle_run_code_of_0_block_3_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xdc33e681%positive);Opcode GT;PUSH 1 (posToWord WLen 0x29%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xDC33E681%positive);Opcode GT;PUSH 1 (posToWord WLen 0x29%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH DC33E681 EQ PUSH [tag] 34
 O: DUP1 PUSH dc33e681 EQ PUSH [tag] 34
*)
Compute pair "BottleCastle_run_code_of_0_block_4_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xdc33e681%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x22%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xDC33E681%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x22%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH E268E4D3 EQ PUSH [tag] 35
 O: DUP1 PUSH e268e4d3 EQ PUSH [tag] 35
*)
Compute pair "BottleCastle_run_code_of_0_block_5_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xe268e4d3%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x23%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xE268E4D3%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x23%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH E985E9C5 EQ PUSH [tag] 36
 O: DUP1 PUSH e985e9c5 EQ PUSH [tag] 36
*)
Compute pair "BottleCastle_run_code_of_0_block_6_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xe985e9c5%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x24%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xE985E9C5%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x24%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH F2C4CE1E EQ PUSH [tag] 37
 O: DUP1 PUSH f2c4ce1e EQ PUSH [tag] 37
*)
Compute pair "BottleCastle_run_code_of_0_block_7_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xf2c4ce1e%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x25%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xF2C4CE1E%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x25%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH F2FDE38B EQ PUSH [tag] 38
 O: DUP1 PUSH f2fde38b EQ PUSH [tag] 38
*)
Compute pair "BottleCastle_run_code_of_0_block_8_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xf2fde38b%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x26%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xF2FDE38B%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x26%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 1
 O: PUSH [tag] 1
*)
Compute pair "BottleCastle_run_code_of_0_block_9_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive)] [PUSH 1 (posToWord WLen 0x1%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH BD7A1998 EQ PUSH [tag] 29
 O: DUP1 PUSH bd7a1998 EQ PUSH [tag] 29
*)
Compute pair "BottleCastle_run_code_of_0_block_10_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xbd7a1998%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x1d%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xBD7A1998%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x1d%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH C6682862 EQ PUSH [tag] 30
 O: DUP1 PUSH c6682862 EQ PUSH [tag] 30
*)
Compute pair "BottleCastle_run_code_of_0_block_11_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xc6682862%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x1e%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xC6682862%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x1e%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH C87B56DD EQ PUSH [tag] 31
 O: DUP1 PUSH c87b56dd EQ PUSH [tag] 31
*)
Compute pair "BottleCastle_run_code_of_0_block_12_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xc87b56dd%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x1f%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xC87B56DD%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x1f%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH D5ABEB01 EQ PUSH [tag] 32
 O: DUP1 PUSH d5abeb01 EQ PUSH [tag] 32
*)
Compute pair "BottleCastle_run_code_of_0_block_13_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xd5abeb01%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x20%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xD5ABEB01%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x20%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH DA3EF23F EQ PUSH [tag] 33
 O: DUP1 PUSH da3ef23f EQ PUSH [tag] 33
*)
Compute pair "BottleCastle_run_code_of_0_block_14_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xda3ef23f%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x21%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xDA3EF23F%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x21%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 1
 O: PUSH [tag] 1
*)
Compute pair "BottleCastle_run_code_of_0_block_15_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive)] [PUSH 1 (posToWord WLen 0x1%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 95D89B41 GT PUSH [tag] 42
 O: DUP1 PUSH 95d89b41 GT PUSH [tag] 42
*)
Compute pair "BottleCastle_run_code_of_0_block_16_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x95d89b41%positive);Opcode GT;PUSH 1 (posToWord WLen 0x2a%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x95D89B41%positive);Opcode GT;PUSH 1 (posToWord WLen 0x2a%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 95D89B41 EQ PUSH [tag] 24
 O: DUP1 PUSH 95d89b41 EQ PUSH [tag] 24
*)
Compute pair "BottleCastle_run_code_of_0_block_17_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x95d89b41%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x18%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x95D89B41%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x18%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH A0712D68 EQ PUSH [tag] 25
 O: DUP1 PUSH a0712d68 EQ PUSH [tag] 25
*)
Compute pair "BottleCastle_run_code_of_0_block_18_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xa0712d68%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x19%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xA0712D68%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x19%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH A22CB465 EQ PUSH [tag] 26
 O: DUP1 PUSH a22cb465 EQ PUSH [tag] 26
*)
Compute pair "BottleCastle_run_code_of_0_block_19_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xa22cb465%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x1a%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xA22CB465%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x1a%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH B88D4FDE EQ PUSH [tag] 27
 O: DUP1 PUSH b88d4fde EQ PUSH [tag] 27
*)
Compute pair "BottleCastle_run_code_of_0_block_20_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xb88d4fde%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x1b%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xB88D4FDE%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x1b%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH BC63F02E EQ PUSH [tag] 28
 O: DUP1 PUSH bc63f02e EQ PUSH [tag] 28
*)
Compute pair "BottleCastle_run_code_of_0_block_21_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xbc63f02e%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x1c%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xBC63F02E%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x1c%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 1
 O: PUSH [tag] 1
*)
Compute pair "BottleCastle_run_code_of_0_block_22_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive)] [PUSH 1 (posToWord WLen 0x1%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 715018A6 EQ PUSH [tag] 20
 O: DUP1 PUSH 715018a6 EQ PUSH [tag] 20
*)
Compute pair "BottleCastle_run_code_of_0_block_23_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x715018a6%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x14%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x715018A6%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x14%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 8462151C EQ PUSH [tag] 21
 O: DUP1 PUSH 8462151c EQ PUSH [tag] 21
*)
Compute pair "BottleCastle_run_code_of_0_block_24_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x8462151c%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x15%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x8462151C%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x15%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 8DA5CB5B EQ PUSH [tag] 22
 O: DUP1 PUSH 8da5cb5b EQ PUSH [tag] 22
*)
Compute pair "BottleCastle_run_code_of_0_block_25_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x8da5cb5b%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x16%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x8DA5CB5B%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x16%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 940CD05B EQ PUSH [tag] 23
 O: DUP1 PUSH 940cd05b EQ PUSH [tag] 23
*)
Compute pair "BottleCastle_run_code_of_0_block_26_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x940cd05b%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x17%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x940CD05B%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x17%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 1
 O: PUSH [tag] 1
*)
Compute pair "BottleCastle_run_code_of_0_block_27_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive)] [PUSH 1 (posToWord WLen 0x1%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 3CCFD60B GT PUSH [tag] 43
 O: DUP1 PUSH 3ccfd60b GT PUSH [tag] 43
*)
Compute pair "BottleCastle_run_code_of_0_block_28_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x3ccfd60b%positive);Opcode GT;PUSH 1 (posToWord WLen 0x2b%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x3CCFD60B%positive);Opcode GT;PUSH 1 (posToWord WLen 0x2b%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 55F804B3 GT PUSH [tag] 44
 O: DUP1 PUSH 55f804b3 GT PUSH [tag] 44
*)
Compute pair "BottleCastle_run_code_of_0_block_29_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x55f804b3%positive);Opcode GT;PUSH 1 (posToWord WLen 0x2c%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x55F804B3%positive);Opcode GT;PUSH 1 (posToWord WLen 0x2c%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 55F804B3 EQ PUSH [tag] 15
 O: DUP1 PUSH 55f804b3 EQ PUSH [tag] 15
*)
Compute pair "BottleCastle_run_code_of_0_block_30_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x55f804b3%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xf%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x55F804B3%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xf%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 5C975ABB EQ PUSH [tag] 16
 O: DUP1 PUSH 5c975abb EQ PUSH [tag] 16
*)
Compute pair "BottleCastle_run_code_of_0_block_31_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x5c975abb%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x10%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x5C975ABB%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x10%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 6352211E EQ PUSH [tag] 17
 O: DUP1 PUSH 6352211e EQ PUSH [tag] 17
*)
Compute pair "BottleCastle_run_code_of_0_block_32_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x6352211e%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x11%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x6352211E%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x11%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 6C0360EB EQ PUSH [tag] 18
 O: DUP1 PUSH 6c0360eb EQ PUSH [tag] 18
*)
Compute pair "BottleCastle_run_code_of_0_block_33_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x6c0360eb%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x12%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x6C0360EB%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x12%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 70A08231 EQ PUSH [tag] 19
 O: DUP1 PUSH 70a08231 EQ PUSH [tag] 19
*)
Compute pair "BottleCastle_run_code_of_0_block_34_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x70a08231%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x13%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x70A08231%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x13%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 1
 O: PUSH [tag] 1
*)
Compute pair "BottleCastle_run_code_of_0_block_35_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive)] [PUSH 1 (posToWord WLen 0x1%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 3CCFD60B EQ PUSH [tag] 11
 O: DUP1 PUSH 3ccfd60b EQ PUSH [tag] 11
*)
Compute pair "BottleCastle_run_code_of_0_block_36_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x3ccfd60b%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xb%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x3CCFD60B%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xb%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 42842E0E EQ PUSH [tag] 12
 O: DUP1 PUSH 42842e0e EQ PUSH [tag] 12
*)
Compute pair "BottleCastle_run_code_of_0_block_37_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x42842e0e%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xc%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x42842E0E%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xc%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 44A0D68A EQ PUSH [tag] 13
 O: DUP1 PUSH 44a0d68a EQ PUSH [tag] 13
*)
Compute pair "BottleCastle_run_code_of_0_block_38_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x44a0d68a%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xd%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x44A0D68A%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xd%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 51830227 EQ PUSH [tag] 14
 O: DUP1 PUSH 51830227 EQ PUSH [tag] 14
*)
Compute pair "BottleCastle_run_code_of_0_block_39_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x51830227%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xe%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x51830227%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xe%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 1
 O: PUSH [tag] 1
*)
Compute pair "BottleCastle_run_code_of_0_block_40_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive)] [PUSH 1 (posToWord WLen 0x1%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 81C8C44 GT PUSH [tag] 45
 O: DUP1 PUSH 81c8c44 GT PUSH [tag] 45
*)
Compute pair "BottleCastle_run_code_of_0_block_41_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x81c8c44%positive);Opcode GT;PUSH 1 (posToWord WLen 0x2d%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x81C8C44%positive);Opcode GT;PUSH 1 (posToWord WLen 0x2d%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 81C8C44 EQ PUSH [tag] 6
 O: DUP1 PUSH 81c8c44 EQ PUSH [tag] 6
*)
Compute pair "BottleCastle_run_code_of_0_block_42_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x81c8c44%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x6%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x81C8C44%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x6%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 95EA7B3 EQ PUSH [tag] 7
 O: DUP1 PUSH 95ea7b3 EQ PUSH [tag] 7
*)
Compute pair "BottleCastle_run_code_of_0_block_43_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x95ea7b3%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x7%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x95EA7B3%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x7%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 13FAEDE6 EQ PUSH [tag] 8
 O: DUP1 PUSH 13faede6 EQ PUSH [tag] 8
*)
Compute pair "BottleCastle_run_code_of_0_block_44_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x13faede6%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x8%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x13FAEDE6%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x8%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 18160DDD EQ PUSH [tag] 9
 O: DUP1 PUSH 18160ddd EQ PUSH [tag] 9
*)
Compute pair "BottleCastle_run_code_of_0_block_45_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x18160ddd%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x9%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x18160DDD%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x9%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 23B872DD EQ PUSH [tag] 10
 O: DUP1 PUSH 23b872dd EQ PUSH [tag] 10
*)
Compute pair "BottleCastle_run_code_of_0_block_46_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x23b872dd%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xa%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x23B872DD%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xa%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 1
 O: PUSH [tag] 1
*)
Compute pair "BottleCastle_run_code_of_0_block_47_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive)] [PUSH 1 (posToWord WLen 0x1%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 1FFC9A7 EQ PUSH [tag] 2
 O: DUP1 PUSH 1ffc9a7 EQ PUSH [tag] 2
*)
Compute pair "BottleCastle_run_code_of_0_block_48_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x1ffc9a7%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x2%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x1FFC9A7%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x2%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 2329A29 EQ PUSH [tag] 3
 O: DUP1 PUSH 2329a29 EQ PUSH [tag] 3
*)
Compute pair "BottleCastle_run_code_of_0_block_49_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x2329a29%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x3%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x2329A29%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x3%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 6FDDE03 EQ PUSH [tag] 4
 O: DUP1 PUSH 6fdde03 EQ PUSH [tag] 4
*)
Compute pair "BottleCastle_run_code_of_0_block_50_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x6fdde03%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x4%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x6FDDE03%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x4%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 81812FC EQ PUSH [tag] 5
 O: DUP1 PUSH 81812fc EQ PUSH [tag] 5
*)
Compute pair "BottleCastle_run_code_of_0_block_51_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x81812fc%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x5%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x81812FC%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x5%positive)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_52_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 46
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 46
*)
Compute pair "BottleCastle_run_code_of_0_block_53_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x2e%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x2e%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_54_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 47 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 48 SWAP2 SWAP1 PUSH [tag] 49
 O: POP PUSH [tag] 47 PUSH [tag] 48 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 49
*)
Compute pair "BottleCastle_run_code_of_0_block_55_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x2f%positive);PUSH 1 (posToWord WLen 0x30%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x31%positive)] [POP;PUSH 1 (posToWord WLen 0x2f%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x30%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x31%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 50
 O: PUSH [tag] 50
*)
Compute pair "BottleCastle_run_code_of_0_block_56_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x32%positive)] [PUSH 1 (posToWord WLen 0x32%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 51 SWAP2 SWAP1 PUSH [tag] 52
 O: PUSH [tag] 51 SWAP1 PUSH 40 MLOAD PUSH [tag] 52
*)
Compute pair "BottleCastle_run_code_of_0_block_57_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x33%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x34%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x33%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x34%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_58_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 53
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 53
*)
Compute pair "BottleCastle_run_code_of_0_block_59_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x35%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x35%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_60_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 54 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 55 SWAP2 SWAP1 PUSH [tag] 56
 O: POP PUSH [tag] 54 PUSH [tag] 55 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 56
*)
Compute pair "BottleCastle_run_code_of_0_block_61_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x36%positive);PUSH 1 (posToWord WLen 0x37%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x38%positive)] [POP;PUSH 1 (posToWord WLen 0x36%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x37%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x38%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 57
 O: PUSH [tag] 57
*)
Compute pair "BottleCastle_run_code_of_0_block_62_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x39%positive)] [PUSH 1 (posToWord WLen 0x39%positive)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 58
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 58
*)
Compute pair "BottleCastle_run_code_of_0_block_64_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x3a%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x3a%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_65_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 59 PUSH [tag] 60
 O: POP PUSH [tag] 59 PUSH [tag] 60
*)
Compute pair "BottleCastle_run_code_of_0_block_66_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x3b%positive);PUSH 1 (posToWord WLen 0x3c%positive)] [POP;PUSH 1 (posToWord WLen 0x3b%positive);PUSH 1 (posToWord WLen 0x3c%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 61 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 61 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Compute pair "BottleCastle_run_code_of_0_block_67_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x3d%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x3e%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x3d%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x3e%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_68_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 63
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 63
*)
Compute pair "BottleCastle_run_code_of_0_block_69_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x3f%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x3f%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_70_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 64 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 65 SWAP2 SWAP1 PUSH [tag] 66
 O: POP PUSH [tag] 64 PUSH [tag] 65 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 66
*)
Compute pair "BottleCastle_run_code_of_0_block_71_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x40%positive);PUSH 1 (posToWord WLen 0x41%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x42%positive)] [POP;PUSH 1 (posToWord WLen 0x40%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x41%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x42%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 67
 O: PUSH [tag] 67
*)
Compute pair "BottleCastle_run_code_of_0_block_72_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x43%positive)] [PUSH 1 (posToWord WLen 0x43%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 68 SWAP2 SWAP1 PUSH [tag] 69
 O: PUSH [tag] 68 SWAP1 PUSH 40 MLOAD PUSH [tag] 69
*)
Compute pair "BottleCastle_run_code_of_0_block_73_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x44%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x45%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x44%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x45%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_74_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 70
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 70
*)
Compute pair "BottleCastle_run_code_of_0_block_75_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x46%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x46%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_76_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 71 PUSH [tag] 72
 O: POP PUSH [tag] 71 PUSH [tag] 72
*)
Compute pair "BottleCastle_run_code_of_0_block_77_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x47%positive);PUSH 1 (posToWord WLen 0x48%positive)] [POP;PUSH 1 (posToWord WLen 0x47%positive);PUSH 1 (posToWord WLen 0x48%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 73 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 73 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Compute pair "BottleCastle_run_code_of_0_block_78_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x49%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x3e%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x49%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x3e%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_79_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 74
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 74
*)
Compute pair "BottleCastle_run_code_of_0_block_80_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x4a%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x4a%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_81_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 75 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 76 SWAP2 SWAP1 PUSH [tag] 77
 O: POP PUSH [tag] 75 PUSH [tag] 76 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 77
*)
Compute pair "BottleCastle_run_code_of_0_block_82_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x4b%positive);PUSH 1 (posToWord WLen 0x4c%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x4d%positive)] [POP;PUSH 1 (posToWord WLen 0x4b%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x4c%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x4d%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 78
 O: PUSH [tag] 78
*)
Compute pair "BottleCastle_run_code_of_0_block_83_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x4e%positive)] [PUSH 1 (posToWord WLen 0x4e%positive)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 79
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 79
*)
Compute pair "BottleCastle_run_code_of_0_block_85_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x4f%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x4f%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_86_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 80 PUSH [tag] 81
 O: POP PUSH [tag] 80 PUSH [tag] 81
*)
Compute pair "BottleCastle_run_code_of_0_block_87_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x50%positive);PUSH 1 (posToWord WLen 0x51%positive)] [POP;PUSH 1 (posToWord WLen 0x50%positive);PUSH 1 (posToWord WLen 0x51%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 82 SWAP2 SWAP1 PUSH [tag] 83
 O: PUSH [tag] 82 SWAP1 PUSH 40 MLOAD PUSH [tag] 83
*)
Compute pair "BottleCastle_run_code_of_0_block_88_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x52%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x53%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x52%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x53%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_89_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 84
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 84
*)
Compute pair "BottleCastle_run_code_of_0_block_90_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x54%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x54%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_91_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 85 PUSH [tag] 86
 O: POP PUSH [tag] 85 PUSH [tag] 86
*)
Compute pair "BottleCastle_run_code_of_0_block_92_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x55%positive);PUSH 1 (posToWord WLen 0x56%positive)] [POP;PUSH 1 (posToWord WLen 0x55%positive);PUSH 1 (posToWord WLen 0x56%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 87 SWAP2 SWAP1 PUSH [tag] 83
 O: PUSH [tag] 87 SWAP1 PUSH 40 MLOAD PUSH [tag] 83
*)
Compute pair "BottleCastle_run_code_of_0_block_93_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x57%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x53%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x57%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x53%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_94_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 88
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 88
*)
Compute pair "BottleCastle_run_code_of_0_block_95_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x58%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x58%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_96_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 89 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 90 SWAP2 SWAP1 PUSH [tag] 91
 O: POP PUSH [tag] 89 PUSH [tag] 90 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 91
*)
Compute pair "BottleCastle_run_code_of_0_block_97_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x59%positive);PUSH 1 (posToWord WLen 0x5a%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x5b%positive)] [POP;PUSH 1 (posToWord WLen 0x59%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x5a%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x5b%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 92
 O: PUSH [tag] 92
*)
Compute pair "BottleCastle_run_code_of_0_block_98_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x5c%positive)] [PUSH 1 (posToWord WLen 0x5c%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 93 PUSH [tag] 94
 O: PUSH [tag] 93 PUSH [tag] 94
*)
Compute pair "BottleCastle_run_code_of_0_block_100_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x5d%positive);PUSH 1 (posToWord WLen 0x5e%positive)] [PUSH 1 (posToWord WLen 0x5d%positive);PUSH 1 (posToWord WLen 0x5e%positive)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 95
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 95
*)
Compute pair "BottleCastle_run_code_of_0_block_102_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x5f%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x5f%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_103_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 96 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 97 SWAP2 SWAP1 PUSH [tag] 91
 O: POP PUSH [tag] 96 PUSH [tag] 97 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 91
*)
Compute pair "BottleCastle_run_code_of_0_block_104_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x61%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x5b%positive)] [POP;PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x61%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x5b%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 98
 O: PUSH [tag] 98
*)
Compute pair "BottleCastle_run_code_of_0_block_105_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x62%positive)] [PUSH 1 (posToWord WLen 0x62%positive)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 99
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 99
*)
Compute pair "BottleCastle_run_code_of_0_block_107_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x63%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x63%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_108_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 100 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 101 SWAP2 SWAP1 PUSH [tag] 66
 O: POP PUSH [tag] 100 PUSH [tag] 101 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 66
*)
Compute pair "BottleCastle_run_code_of_0_block_109_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x64%positive);PUSH 1 (posToWord WLen 0x65%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x42%positive)] [POP;PUSH 1 (posToWord WLen 0x64%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x65%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x42%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 102
 O: PUSH [tag] 102
*)
Compute pair "BottleCastle_run_code_of_0_block_110_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x66%positive)] [PUSH 1 (posToWord WLen 0x66%positive)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 103
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 103
*)
Compute pair "BottleCastle_run_code_of_0_block_112_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x67%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x67%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_113_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 104 PUSH [tag] 105
 O: POP PUSH [tag] 104 PUSH [tag] 105
*)
Compute pair "BottleCastle_run_code_of_0_block_114_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x68%positive);PUSH 1 (posToWord WLen 0x69%positive)] [POP;PUSH 1 (posToWord WLen 0x68%positive);PUSH 1 (posToWord WLen 0x69%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 106 SWAP2 SWAP1 PUSH [tag] 52
 O: PUSH [tag] 106 SWAP1 PUSH 40 MLOAD PUSH [tag] 52
*)
Compute pair "BottleCastle_run_code_of_0_block_115_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x6a%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x34%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x6a%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x34%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_116_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 107
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 107
*)
Compute pair "BottleCastle_run_code_of_0_block_117_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x6b%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x6b%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_118_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 108 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 109 SWAP2 SWAP1 PUSH [tag] 110
 O: POP PUSH [tag] 108 PUSH [tag] 109 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 110
*)
Compute pair "BottleCastle_run_code_of_0_block_119_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x6c%positive);PUSH 1 (posToWord WLen 0x6d%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x6e%positive)] [POP;PUSH 1 (posToWord WLen 0x6c%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x6d%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x6e%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 111
 O: PUSH [tag] 111
*)
Compute pair "BottleCastle_run_code_of_0_block_120_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x6f%positive)] [PUSH 1 (posToWord WLen 0x6f%positive)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 112
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 112
*)
Compute pair "BottleCastle_run_code_of_0_block_122_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x70%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x70%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_123_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 113 PUSH [tag] 114
 O: POP PUSH [tag] 113 PUSH [tag] 114
*)
Compute pair "BottleCastle_run_code_of_0_block_124_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x71%positive);PUSH 1 (posToWord WLen 0x72%positive)] [POP;PUSH 1 (posToWord WLen 0x71%positive);PUSH 1 (posToWord WLen 0x72%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 115 SWAP2 SWAP1 PUSH [tag] 52
 O: PUSH [tag] 115 SWAP1 PUSH 40 MLOAD PUSH [tag] 52
*)
Compute pair "BottleCastle_run_code_of_0_block_125_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x73%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x34%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x73%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x34%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_126_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 116
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 116
*)
Compute pair "BottleCastle_run_code_of_0_block_127_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x74%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x74%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_128_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 117 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 118 SWAP2 SWAP1 PUSH [tag] 66
 O: POP PUSH [tag] 117 PUSH [tag] 118 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 66
*)
Compute pair "BottleCastle_run_code_of_0_block_129_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x75%positive);PUSH 1 (posToWord WLen 0x76%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x42%positive)] [POP;PUSH 1 (posToWord WLen 0x75%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x76%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x42%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 119
 O: PUSH [tag] 119
*)
Compute pair "BottleCastle_run_code_of_0_block_130_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x77%positive)] [PUSH 1 (posToWord WLen 0x77%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 120 SWAP2 SWAP1 PUSH [tag] 69
 O: PUSH [tag] 120 SWAP1 PUSH 40 MLOAD PUSH [tag] 69
*)
Compute pair "BottleCastle_run_code_of_0_block_131_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x78%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x45%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x78%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x45%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_132_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 121
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 121
*)
Compute pair "BottleCastle_run_code_of_0_block_133_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x79%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x79%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_134_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 122 PUSH [tag] 123
 O: POP PUSH [tag] 122 PUSH [tag] 123
*)
Compute pair "BottleCastle_run_code_of_0_block_135_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x7a%positive);PUSH 1 (posToWord WLen 0x7b%positive)] [POP;PUSH 1 (posToWord WLen 0x7a%positive);PUSH 1 (posToWord WLen 0x7b%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 124 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 124 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Compute pair "BottleCastle_run_code_of_0_block_136_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x7c%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x3e%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x7c%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x3e%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_137_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 125
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 125
*)
Compute pair "BottleCastle_run_code_of_0_block_138_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x7d%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x7d%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_139_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 126 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 127 SWAP2 SWAP1 PUSH [tag] 128
 O: POP PUSH [tag] 126 PUSH [tag] 127 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 128
*)
Compute pair "BottleCastle_run_code_of_0_block_140_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x7e%positive);PUSH 1 (posToWord WLen 0x7f%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x80%positive)] [POP;PUSH 1 (posToWord WLen 0x7e%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x7f%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x80%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 129
 O: PUSH [tag] 129
*)
Compute pair "BottleCastle_run_code_of_0_block_141_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x81%positive)] [PUSH 1 (posToWord WLen 0x81%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 130 SWAP2 SWAP1 PUSH [tag] 83
 O: PUSH [tag] 130 SWAP1 PUSH 40 MLOAD PUSH [tag] 83
*)
Compute pair "BottleCastle_run_code_of_0_block_142_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x82%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x53%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x82%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x53%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_143_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 131
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 131
*)
Compute pair "BottleCastle_run_code_of_0_block_144_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x83%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x83%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_145_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 132 PUSH [tag] 133
 O: POP PUSH [tag] 132 PUSH [tag] 133
*)
Compute pair "BottleCastle_run_code_of_0_block_146_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x84%positive);PUSH 1 (posToWord WLen 0x85%positive)] [POP;PUSH 1 (posToWord WLen 0x84%positive);PUSH 1 (posToWord WLen 0x85%positive)] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 134
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 134
*)
Compute pair "BottleCastle_run_code_of_0_block_148_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x86%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x86%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_149_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 135 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 136 SWAP2 SWAP1 PUSH [tag] 128
 O: POP PUSH [tag] 135 PUSH [tag] 136 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 128
*)
Compute pair "BottleCastle_run_code_of_0_block_150_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x87%positive);PUSH 1 (posToWord WLen 0x88%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x80%positive)] [POP;PUSH 1 (posToWord WLen 0x87%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x88%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x80%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 137
 O: PUSH [tag] 137
*)
Compute pair "BottleCastle_run_code_of_0_block_151_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x89%positive)] [PUSH 1 (posToWord WLen 0x89%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 138 SWAP2 SWAP1 PUSH [tag] 139
 O: PUSH [tag] 138 SWAP1 PUSH 40 MLOAD PUSH [tag] 139
*)
Compute pair "BottleCastle_run_code_of_0_block_152_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x8a%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x8b%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x8a%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x8b%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_153_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 140
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 140
*)
Compute pair "BottleCastle_run_code_of_0_block_154_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x8c%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x8c%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_155_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 141 PUSH [tag] 142
 O: POP PUSH [tag] 141 PUSH [tag] 142
*)
Compute pair "BottleCastle_run_code_of_0_block_156_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x8d%positive);PUSH 1 (posToWord WLen 0x8e%positive)] [POP;PUSH 1 (posToWord WLen 0x8d%positive);PUSH 1 (posToWord WLen 0x8e%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 143 SWAP2 SWAP1 PUSH [tag] 69
 O: PUSH [tag] 143 SWAP1 PUSH 40 MLOAD PUSH [tag] 69
*)
Compute pair "BottleCastle_run_code_of_0_block_157_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x8f%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x45%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x8f%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x45%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_158_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 144
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 144
*)
Compute pair "BottleCastle_run_code_of_0_block_159_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x90%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x90%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_160_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 145 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 146 SWAP2 SWAP1 PUSH [tag] 56
 O: POP PUSH [tag] 145 PUSH [tag] 146 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 56
*)
Compute pair "BottleCastle_run_code_of_0_block_161_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x91%positive);PUSH 1 (posToWord WLen 0x92%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x38%positive)] [POP;PUSH 1 (posToWord WLen 0x91%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x92%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x38%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 147
 O: PUSH [tag] 147
*)
Compute pair "BottleCastle_run_code_of_0_block_162_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x93%positive)] [PUSH 1 (posToWord WLen 0x93%positive)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 148
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 148
*)
Compute pair "BottleCastle_run_code_of_0_block_164_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x94%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x94%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_165_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 149 PUSH [tag] 150
 O: POP PUSH [tag] 149 PUSH [tag] 150
*)
Compute pair "BottleCastle_run_code_of_0_block_166_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x95%positive);PUSH 1 (posToWord WLen 0x96%positive)] [POP;PUSH 1 (posToWord WLen 0x95%positive);PUSH 1 (posToWord WLen 0x96%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 151 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 151 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Compute pair "BottleCastle_run_code_of_0_block_167_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x97%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x3e%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x97%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x3e%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_168_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH [tag] 152 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 153 SWAP2 SWAP1 PUSH [tag] 66
 O: PUSH [tag] 152 PUSH [tag] 153 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 66
*)
Compute pair "BottleCastle_run_code_of_0_block_169_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x98%positive);PUSH 1 (posToWord WLen 0x99%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x42%positive)] [PUSH 1 (posToWord WLen 0x98%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x99%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x42%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 154
 O: PUSH [tag] 154
*)
Compute pair "BottleCastle_run_code_of_0_block_170_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x9a%positive)] [PUSH 1 (posToWord WLen 0x9a%positive)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 155
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 155
*)
Compute pair "BottleCastle_run_code_of_0_block_172_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x9b%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x9b%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_173_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 156 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 157 SWAP2 SWAP1 PUSH [tag] 158
 O: POP PUSH [tag] 156 PUSH [tag] 157 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 158
*)
Compute pair "BottleCastle_run_code_of_0_block_174_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x9c%positive);PUSH 1 (posToWord WLen 0x9d%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x9e%positive)] [POP;PUSH 1 (posToWord WLen 0x9c%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x9d%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x9e%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 159
 O: PUSH [tag] 159
*)
Compute pair "BottleCastle_run_code_of_0_block_175_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x9f%positive)] [PUSH 1 (posToWord WLen 0x9f%positive)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 160
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 160
*)
Compute pair "BottleCastle_run_code_of_0_block_177_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0xa0%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xa0%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_178_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 161 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 162 SWAP2 SWAP1 PUSH [tag] 163
 O: POP PUSH [tag] 161 PUSH [tag] 162 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 163
*)
Compute pair "BottleCastle_run_code_of_0_block_179_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xa1%positive);PUSH 1 (posToWord WLen 0xa2%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0xa3%positive)] [POP;PUSH 1 (posToWord WLen 0xa1%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0xa2%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0xa3%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 164
 O: PUSH [tag] 164
*)
Compute pair "BottleCastle_run_code_of_0_block_180_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xa4%positive)] [PUSH 1 (posToWord WLen 0xa4%positive)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 165
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 165
*)
Compute pair "BottleCastle_run_code_of_0_block_182_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0xa5%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xa5%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_183_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 166 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 167 SWAP2 SWAP1 PUSH [tag] 168
 O: POP PUSH [tag] 166 PUSH [tag] 167 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 168
*)
Compute pair "BottleCastle_run_code_of_0_block_184_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xa6%positive);PUSH 1 (posToWord WLen 0xa7%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0xa8%positive)] [POP;PUSH 1 (posToWord WLen 0xa6%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0xa7%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0xa8%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 169
 O: PUSH [tag] 169
*)
Compute pair "BottleCastle_run_code_of_0_block_185_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xa9%positive)] [PUSH 1 (posToWord WLen 0xa9%positive)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 170
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 170
*)
Compute pair "BottleCastle_run_code_of_0_block_187_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0xaa%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xaa%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_188_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 171 PUSH [tag] 172
 O: POP PUSH [tag] 171 PUSH [tag] 172
*)
Compute pair "BottleCastle_run_code_of_0_block_189_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xab%positive);PUSH 1 (posToWord WLen 0xac%positive)] [POP;PUSH 1 (posToWord WLen 0xab%positive);PUSH 1 (posToWord WLen 0xac%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 173 SWAP2 SWAP1 PUSH [tag] 83
 O: PUSH [tag] 173 SWAP1 PUSH 40 MLOAD PUSH [tag] 83
*)
Compute pair "BottleCastle_run_code_of_0_block_190_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xad%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x53%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0xad%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x53%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_191_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 174
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 174
*)
Compute pair "BottleCastle_run_code_of_0_block_192_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0xae%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xae%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_193_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 175 PUSH [tag] 176
 O: POP PUSH [tag] 175 PUSH [tag] 176
*)
Compute pair "BottleCastle_run_code_of_0_block_194_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xaf%positive);PUSH 1 (posToWord WLen 0xb0%positive)] [POP;PUSH 1 (posToWord WLen 0xaf%positive);PUSH 1 (posToWord WLen 0xb0%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 177 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 177 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Compute pair "BottleCastle_run_code_of_0_block_195_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xb1%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x3e%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0xb1%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x3e%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_196_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 178
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 178
*)
Compute pair "BottleCastle_run_code_of_0_block_197_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0xb2%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xb2%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_198_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 179 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 180 SWAP2 SWAP1 PUSH [tag] 66
 O: POP PUSH [tag] 179 PUSH [tag] 180 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 66
*)
Compute pair "BottleCastle_run_code_of_0_block_199_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xb3%positive);PUSH 1 (posToWord WLen 0xb4%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x42%positive)] [POP;PUSH 1 (posToWord WLen 0xb3%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0xb4%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x42%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 181
 O: PUSH [tag] 181
*)
Compute pair "BottleCastle_run_code_of_0_block_200_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xb5%positive)] [PUSH 1 (posToWord WLen 0xb5%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 182 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 182 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Compute pair "BottleCastle_run_code_of_0_block_201_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xb6%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x3e%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0xb6%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x3e%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_202_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 183
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 183
*)
Compute pair "BottleCastle_run_code_of_0_block_203_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0xb7%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xb7%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_204_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 184 PUSH [tag] 185
 O: POP PUSH [tag] 184 PUSH [tag] 185
*)
Compute pair "BottleCastle_run_code_of_0_block_205_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xb8%positive);PUSH 1 (posToWord WLen 0xb9%positive)] [POP;PUSH 1 (posToWord WLen 0xb8%positive);PUSH 1 (posToWord WLen 0xb9%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 186 SWAP2 SWAP1 PUSH [tag] 83
 O: PUSH [tag] 186 SWAP1 PUSH 40 MLOAD PUSH [tag] 83
*)
Compute pair "BottleCastle_run_code_of_0_block_206_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xba%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x53%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0xba%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x53%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_207_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 187
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 187
*)
Compute pair "BottleCastle_run_code_of_0_block_208_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0xbb%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xbb%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_209_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 188 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 189 SWAP2 SWAP1 PUSH [tag] 110
 O: POP PUSH [tag] 188 PUSH [tag] 189 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 110
*)
Compute pair "BottleCastle_run_code_of_0_block_210_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xbc%positive);PUSH 1 (posToWord WLen 0xbd%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x6e%positive)] [POP;PUSH 1 (posToWord WLen 0xbc%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0xbd%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x6e%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 190
 O: PUSH [tag] 190
*)
Compute pair "BottleCastle_run_code_of_0_block_211_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xbe%positive)] [PUSH 1 (posToWord WLen 0xbe%positive)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 191
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 191
*)
Compute pair "BottleCastle_run_code_of_0_block_213_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0xbf%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xbf%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_214_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 192 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 193 SWAP2 SWAP1 PUSH [tag] 128
 O: POP PUSH [tag] 192 PUSH [tag] 193 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 128
*)
Compute pair "BottleCastle_run_code_of_0_block_215_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xc0%positive);PUSH 1 (posToWord WLen 0xc1%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x80%positive)] [POP;PUSH 1 (posToWord WLen 0xc0%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0xc1%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x80%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 194
 O: PUSH [tag] 194
*)
Compute pair "BottleCastle_run_code_of_0_block_216_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xc2%positive)] [PUSH 1 (posToWord WLen 0xc2%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 195 SWAP2 SWAP1 PUSH [tag] 83
 O: PUSH [tag] 195 SWAP1 PUSH 40 MLOAD PUSH [tag] 83
*)
Compute pair "BottleCastle_run_code_of_0_block_217_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xc3%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x53%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0xc3%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x53%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_218_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 196
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 196
*)
Compute pair "BottleCastle_run_code_of_0_block_219_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0xc4%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xc4%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_220_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 197 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 198 SWAP2 SWAP1 PUSH [tag] 66
 O: POP PUSH [tag] 197 PUSH [tag] 198 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 66
*)
Compute pair "BottleCastle_run_code_of_0_block_221_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xc5%positive);PUSH 1 (posToWord WLen 0xc6%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x42%positive)] [POP;PUSH 1 (posToWord WLen 0xc5%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0xc6%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x42%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 199
 O: PUSH [tag] 199
*)
Compute pair "BottleCastle_run_code_of_0_block_222_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xc7%positive)] [PUSH 1 (posToWord WLen 0xc7%positive)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 200
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 200
*)
Compute pair "BottleCastle_run_code_of_0_block_224_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0xc8%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xc8%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_225_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 201 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 202 SWAP2 SWAP1 PUSH [tag] 203
 O: POP PUSH [tag] 201 PUSH [tag] 202 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 203
*)
Compute pair "BottleCastle_run_code_of_0_block_226_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xc9%positive);PUSH 1 (posToWord WLen 0xca%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0xcb%positive)] [POP;PUSH 1 (posToWord WLen 0xc9%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0xca%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0xcb%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 204
 O: PUSH [tag] 204
*)
Compute pair "BottleCastle_run_code_of_0_block_227_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xcc%positive)] [PUSH 1 (posToWord WLen 0xcc%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 205 SWAP2 SWAP1 PUSH [tag] 52
 O: PUSH [tag] 205 SWAP1 PUSH 40 MLOAD PUSH [tag] 52
*)
Compute pair "BottleCastle_run_code_of_0_block_228_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xcd%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x34%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0xcd%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x34%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_229_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 206
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 206
*)
Compute pair "BottleCastle_run_code_of_0_block_230_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0xce%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xce%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_231_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 207 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 208 SWAP2 SWAP1 PUSH [tag] 110
 O: POP PUSH [tag] 207 PUSH [tag] 208 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 110
*)
Compute pair "BottleCastle_run_code_of_0_block_232_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xcf%positive);PUSH 1 (posToWord WLen 0xd0%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x6e%positive)] [POP;PUSH 1 (posToWord WLen 0xcf%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0xd0%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x6e%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 209
 O: PUSH [tag] 209
*)
Compute pair "BottleCastle_run_code_of_0_block_233_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xd1%positive)] [PUSH 1 (posToWord WLen 0xd1%positive)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 210
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 210
*)
Compute pair "BottleCastle_run_code_of_0_block_235_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0xd2%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xd2%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_236_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 211 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 212 SWAP2 SWAP1 PUSH [tag] 128
 O: POP PUSH [tag] 211 PUSH [tag] 212 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 128
*)
Compute pair "BottleCastle_run_code_of_0_block_237_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xd3%positive);PUSH 1 (posToWord WLen 0xd4%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x80%positive)] [POP;PUSH 1 (posToWord WLen 0xd3%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0xd4%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x80%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 213
 O: PUSH [tag] 213
*)
Compute pair "BottleCastle_run_code_of_0_block_238_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xd5%positive)] [PUSH 1 (posToWord WLen 0xd5%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH 1FFC9A7 PUSH E0 SHL DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ DUP1 PUSH [tag] 215
 O: PUSH 0 PUSH 1ffc9a7 PUSH e0 SHL PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT DUP4 AND EQ DUP1 PUSH [tag] 215
*)
Compute pair "BottleCastle_run_code_of_0_block_240_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 4 (posToWord WLen 0x1ffc9a7%positive);PUSH 1 (posToWord WLen 0xe0%positive);Opcode SHL;PUSH 28 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff%positive);Opcode NOT;DUP 4;Opcode AND;Opcode EQ;DUP 1;PUSH 1 (posToWord WLen 0xd7%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 4 (posToWord WLen 0x1FFC9A7%positive);PUSH 1 (posToWord WLen 0xE0%positive);Opcode SHL;DUP 3;PUSH 28 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode NOT;Opcode AND;Opcode EQ;DUP 1;PUSH 1 (posToWord WLen 0xd7%positive)] 1 optimize_id).

(*
 I: POP PUSH 80AC58CD PUSH E0 SHL DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ
 O: POP PUSH 80ac58cd PUSH e0 SHL DUP3 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT AND EQ
*)
Compute pair "BottleCastle_run_code_of_0_block_241_0"%string (equiv_checker [POP;PUSH 4 (posToWord WLen 0x80ac58cd%positive);PUSH 1 (posToWord WLen 0xe0%positive);Opcode SHL;DUP 3;PUSH 28 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff%positive);Opcode NOT;Opcode AND;Opcode EQ] [POP;PUSH 4 (posToWord WLen 0x80AC58CD%positive);PUSH 1 (posToWord WLen 0xE0%positive);Opcode SHL;DUP 3;PUSH 28 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode NOT;Opcode AND;Opcode EQ] 3 optimize_id).

(*
 I: DUP1 PUSH [tag] 216
 O: DUP1 PUSH [tag] 216
*)
Compute pair "BottleCastle_run_code_of_0_block_242_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0xd8%positive)] [DUP 1;PUSH 1 (posToWord WLen 0xd8%positive)] 1 optimize_id).

(*
 I: POP PUSH 5B5E139F PUSH E0 SHL DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ
 O: POP PUSH 5b5e139f PUSH e0 SHL DUP3 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT AND EQ
*)
Compute pair "BottleCastle_run_code_of_0_block_243_0"%string (equiv_checker [POP;PUSH 4 (posToWord WLen 0x5b5e139f%positive);PUSH 1 (posToWord WLen 0xe0%positive);Opcode SHL;DUP 3;PUSH 28 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff%positive);Opcode NOT;Opcode AND;Opcode EQ] [POP;PUSH 4 (posToWord WLen 0x5B5E139F%positive);PUSH 1 (posToWord WLen 0xE0%positive);Opcode SHL;DUP 3;PUSH 28 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode NOT;Opcode AND;Opcode EQ] 3 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_244_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH [tag] 218 PUSH [tag] 219
 O: PUSH [tag] 218 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_245_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xda%positive);PUSH 1 (posToWord WLen 0xdb%positive)] [PUSH 1 (posToWord WLen 0xda%positive);PUSH 1 (posToWord WLen 0xdb%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 10 PUSH 0 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1
 O: DUP1 PUSH 10 DUP2 ISZERO PUSH 0 PUSH 100 EXP PUSH ff DUP2 MUL NOT DUP4 SLOAD AND SWAP2 ISZERO MUL OR SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_246_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x10%positive);DUP 2;Opcode ISZERO;PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;PUSH 1 (posToWord WLen 0xff%positive);DUP 2;Opcode MUL;Opcode NOT;DUP 4;Opcode SLOAD;Opcode AND;DUP 2;Opcode ISZERO;Opcode MUL;Opcode OR;DUP 1] [DUP 1;PUSH 1 (posToWord WLen 0x10%positive);PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 1 (posToWord WLen 0xFF%positive);Opcode MUL;Opcode NOT;Opcode AND;DUP 1;DUP 4;Opcode ISZERO;Opcode ISZERO;Opcode MUL;Opcode OR;DUP 1] 1 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_246_1"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH 60 PUSH 2 DUP1 SLOAD PUSH [tag] 222 SWAP1 PUSH [tag] 223
 O: PUSH 60 PUSH 2 PUSH [tag] 222 DUP2 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_247_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x2%positive);PUSH 1 (posToWord WLen 0xde%positive);DUP 2;Opcode SLOAD;PUSH 1 (posToWord WLen 0xdf%positive)] [PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x2%positive);DUP 1;Opcode SLOAD;PUSH 1 (posToWord WLen 0xde%positive);DUP 1;PUSH 1 (posToWord WLen 0xdf%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_248_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 1 optimize_id).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute pair "BottleCastle_run_code_of_0_block_248_1"%string (equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 224 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 224 DUP5 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_248_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;PUSH 1 (posToWord WLen 0xe0%positive);DUP 5;Opcode SLOAD;PUSH 1 (posToWord WLen 0xdf%positive)] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (posToWord WLen 0xe0%positive);DUP 1;PUSH 1 (posToWord WLen 0xdf%positive)] 3 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 225
 O: DUP1 ISZERO PUSH [tag] 225
*)
Compute pair "BottleCastle_run_code_of_0_block_249_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xe1%positive)] [DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xe1%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 226
 O: DUP1 PUSH 1f LT PUSH [tag] 226
*)
Compute pair "BottleCastle_run_code_of_0_block_250_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);Opcode LT;PUSH 1 (posToWord WLen 0xe2%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode LT;PUSH 1 (posToWord WLen 0xe2%positive)] 1 optimize_id).

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_251_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x100%positive);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (posToWord WLen 0x100%positive);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 225
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 225
*)
Compute pair "BottleCastle_run_code_of_0_block_251_1"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 1 (posToWord WLen 0xe1%positive)] [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 1 (posToWord WLen 0xe1%positive)] 3 optimize_id).

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_252_0"%string (equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] 3 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_252_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] 1 optimize_id).

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_253_0"%string (equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id).

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 227
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 227
*)
Compute pair "BottleCastle_run_code_of_0_block_253_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (posToWord WLen 0xe3%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (posToWord WLen 0xe3%positive)] 3 optimize_id).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_254_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1f%positive);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (posToWord WLen 0x1F%positive);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id).

(*
 I: POP POP POP POP POP SWAP1 POP SWAP1
 O: POP POP POP POP POP SWAP2 SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_255_0"%string (equiv_checker [POP;POP;POP;POP;POP;DUP 2;DUP 1;POP] [POP;POP;POP;POP;POP;DUP 1;POP;DUP 1] 8 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 229 DUP3 PUSH [tag] 230
 O: PUSH 0 PUSH [tag] 229 DUP3 PUSH [tag] 230
*)
Compute pair "BottleCastle_run_code_of_0_block_256_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0xe5%positive);DUP 3;PUSH 1 (posToWord WLen 0xe6%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0xe5%positive);DUP 3;PUSH 1 (posToWord WLen 0xe6%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 231
 O: PUSH [tag] 231
*)
Compute pair "BottleCastle_run_code_of_0_block_257_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xe7%positive)] [PUSH 1 (posToWord WLen 0xe7%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH CF4700E400000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH cf4700e400000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_258_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xcf4700e400000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xCF4700E400000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_258_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 6 PUSH 0 DUP4 DUP2
 O: PUSH 6 PUSH 0 DUP4 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_259_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x6%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 2] [PUSH 1 (posToWord WLen 0x6%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_259_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 ADD PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 SWAP2 POP ADD PUSH 0 SWAP1 DUP2 DUP1 PUSH 100 EXP SWAP4 POP KECCAK256 ADD SLOAD DIV PUSH ffffffffffffffffffffffffffffffffffffffff AND SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_259_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);DUP 2;POP;Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);DUP 1;DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 4;POP;Opcode KECCAK256;Opcode ADD;Opcode SLOAD;Opcode DIV;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 1;Opcode DIV;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH C DUP1 SLOAD PUSH [tag] 232 SWAP1 PUSH [tag] 223
 O: PUSH c PUSH [tag] 232 DUP2 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_260_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xc%positive);PUSH 1 (posToWord WLen 0xe8%positive);DUP 2;Opcode SLOAD;PUSH 1 (posToWord WLen 0xdf%positive)] [PUSH 1 (posToWord WLen 0xC%positive);DUP 1;Opcode SLOAD;PUSH 1 (posToWord WLen 0xe8%positive);DUP 1;PUSH 1 (posToWord WLen 0xdf%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_261_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 1 optimize_id).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute pair "BottleCastle_run_code_of_0_block_261_1"%string (equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 233 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 233 DUP5 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_261_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;PUSH 1 (posToWord WLen 0xe9%positive);DUP 5;Opcode SLOAD;PUSH 1 (posToWord WLen 0xdf%positive)] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (posToWord WLen 0xe9%positive);DUP 1;PUSH 1 (posToWord WLen 0xdf%positive)] 3 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 234
 O: DUP1 ISZERO PUSH [tag] 234
*)
Compute pair "BottleCastle_run_code_of_0_block_262_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xea%positive)] [DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xea%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 235
 O: DUP1 PUSH 1f LT PUSH [tag] 235
*)
Compute pair "BottleCastle_run_code_of_0_block_263_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);Opcode LT;PUSH 1 (posToWord WLen 0xeb%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode LT;PUSH 1 (posToWord WLen 0xeb%positive)] 1 optimize_id).

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_264_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x100%positive);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (posToWord WLen 0x100%positive);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 234
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 234
*)
Compute pair "BottleCastle_run_code_of_0_block_264_1"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 1 (posToWord WLen 0xea%positive)] [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 1 (posToWord WLen 0xea%positive)] 3 optimize_id).

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_265_0"%string (equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] 3 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_265_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] 1 optimize_id).

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_266_0"%string (equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id).

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 236
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 236
*)
Compute pair "BottleCastle_run_code_of_0_block_266_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (posToWord WLen 0xec%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (posToWord WLen 0xec%positive)] 3 optimize_id).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_267_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1f%positive);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (posToWord WLen 0x1F%positive);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id).

(*
 I: POP POP POP POP POP DUP2
 O: POP POP POP POP POP DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_268_0"%string (equiv_checker [POP;POP;POP;POP;POP;DUP 2] [POP;POP;POP;POP;POP;DUP 2] 7 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 238 DUP3 PUSH [tag] 119
 O: PUSH 0 PUSH [tag] 238 DUP3 PUSH [tag] 119
*)
Compute pair "BottleCastle_run_code_of_0_block_269_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0xee%positive);DUP 3;PUSH 1 (posToWord WLen 0x77%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0xee%positive);DUP 3;PUSH 1 (posToWord WLen 0x77%positive)] 1 optimize_id).

(*
 I: SWAP1 POP DUP1 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH [tag] 239 PUSH [tag] 240
 O: DUP1 SWAP2 POP PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH [tag] 239 PUSH [tag] 240
*)
Compute pair "BottleCastle_run_code_of_0_block_270_0"%string (equiv_checker [DUP 1;DUP 2;POP;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 1 (posToWord WLen 0xef%positive);PUSH 1 (posToWord WLen 0xf0%positive)] [DUP 1;POP;DUP 1;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 1 (posToWord WLen 0xef%positive);PUSH 1 (posToWord WLen 0xf0%positive)] 2 optimize_id).

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ PUSH [tag] 241
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ PUSH [tag] 241
*)
Compute pair "BottleCastle_run_code_of_0_block_271_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;Opcode EQ;PUSH 1 (posToWord WLen 0xf1%positive)] [PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode EQ;PUSH 1 (posToWord WLen 0xf1%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 242 DUP2 PUSH [tag] 243 PUSH [tag] 240
 O: PUSH [tag] 242 DUP2 PUSH [tag] 243 PUSH [tag] 240
*)
Compute pair "BottleCastle_run_code_of_0_block_272_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xf2%positive);DUP 2;PUSH 1 (posToWord WLen 0xf3%positive);PUSH 1 (posToWord WLen 0xf0%positive)] [PUSH 1 (posToWord WLen 0xf2%positive);DUP 2;PUSH 1 (posToWord WLen 0xf3%positive);PUSH 1 (posToWord WLen 0xf0%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 204
 O: PUSH [tag] 204
*)
Compute pair "BottleCastle_run_code_of_0_block_273_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xcc%positive)] [PUSH 1 (posToWord WLen 0xcc%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 244
 O: PUSH [tag] 244
*)
Compute pair "BottleCastle_run_code_of_0_block_274_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xf4%positive)] [PUSH 1 (posToWord WLen 0xf4%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH CFB3B94200000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH cfb3b94200000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_275_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xcfb3b94200000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xCFB3B94200000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_275_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: DUP3 PUSH 6 PUSH 0 DUP5 DUP2
 O: DUP3 PUSH 6 PUSH 0 DUP5 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_277_0"%string (equiv_checker [DUP 3;PUSH 1 (posToWord WLen 0x6%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 5;DUP 2] [DUP 3;PUSH 1 (posToWord WLen 0x6%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 5;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_277_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 ADD PUSH 0 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF MUL NOT AND SWAP1 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND MUL OR SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 ADD PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 PUSH 100 EXP DUP3 SLOAD DUP2 DUP4 MUL NOT AND SWAP2 DUP5 AND MUL OR SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_277_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 3;Opcode SLOAD;DUP 2;DUP 4;Opcode MUL;Opcode NOT;Opcode AND;DUP 2;DUP 5;Opcode AND;Opcode MUL;Opcode OR;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode MUL;Opcode NOT;Opcode AND;DUP 1;DUP 4;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode MUL;Opcode OR;DUP 1] 2 optimize_id).

(*
 I: POP DUP2 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B925 PUSH 40 MLOAD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: POP PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 40 MLOAD DUP5 DUP3 AND PUSH 8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925 DUP3 DUP1 SUB DUP6 DUP8 SWAP6 AND SWAP3 SWAP4
*)
Compute pair "BottleCastle_run_code_of_0_block_277_3"%string (equiv_checker [POP;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 5;DUP 3;Opcode AND;PUSH 32 (posToWord WLen 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925%positive);DUP 3;DUP 1;Opcode SUB;DUP 6;DUP 8;DUP 6;Opcode AND;DUP 3;DUP 4] [POP;DUP 2;DUP 4;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 3;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 32 (posToWord WLen 0x8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B925%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 4 optimize_id).

(*
 I: POP POP POP
 O: POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_277_4"%string (equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id).

(*
 I: PUSH D SLOAD DUP2
 O: PUSH d SLOAD DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_278_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xd%positive);Opcode SLOAD;DUP 2] [PUSH 1 (posToWord WLen 0xD%positive);Opcode SLOAD;DUP 2] 1 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 246 PUSH [tag] 247
 O: PUSH 0 PUSH [tag] 246 PUSH [tag] 247
*)
Compute pair "BottleCastle_run_code_of_0_block_279_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0xf6%positive);PUSH 1 (posToWord WLen 0xf7%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0xf6%positive);PUSH 1 (posToWord WLen 0xf7%positive)] 0 optimize_id).

(*
 I: PUSH 1 SLOAD PUSH 0 SLOAD SUB SUB SWAP1 POP SWAP1
 O: PUSH 1 SLOAD PUSH 0 SLOAD SUB SUB SWAP2 SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_280_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive);Opcode SLOAD;PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;Opcode SUB;Opcode SUB;DUP 2;DUP 1;POP] [PUSH 1 (posToWord WLen 0x1%positive);Opcode SLOAD;PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;Opcode SUB;Opcode SUB;DUP 1;POP;DUP 1] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 249 DUP3 PUSH [tag] 250
 O: PUSH 0 PUSH [tag] 249 DUP3 PUSH [tag] 250
*)
Compute pair "BottleCastle_run_code_of_0_block_281_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0xf9%positive);DUP 3;PUSH 1 (posToWord WLen 0xfa%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0xf9%positive);DUP 3;PUSH 1 (posToWord WLen 0xfa%positive)] 1 optimize_id).

(*
 I: SWAP1 POP DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ PUSH [tag] 251
 O: SWAP1 POP DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 AND EQ PUSH [tag] 251
*)
Compute pair "BottleCastle_run_code_of_0_block_282_0"%string (equiv_checker [DUP 1;POP;DUP 4;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 3;Opcode AND;Opcode EQ;PUSH 1 (posToWord WLen 0xfb%positive)] [DUP 1;POP;DUP 4;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode EQ;PUSH 1 (posToWord WLen 0xfb%positive)] 5 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH A114810000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH a114810000000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_283_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xa114810000000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xA114810000000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_283_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH [tag] 252 DUP5 PUSH [tag] 253
 O: PUSH 0 DUP1 PUSH [tag] 252 DUP5 PUSH [tag] 253
*)
Compute pair "BottleCastle_run_code_of_0_block_284_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0xfc%positive);DUP 5;PUSH 1 (posToWord WLen 0xfd%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0xfc%positive);DUP 5;PUSH 1 (posToWord WLen 0xfd%positive)] 2 optimize_id).

(*
 I: SWAP2 POP SWAP2 POP PUSH [tag] 254 DUP2 DUP8 PUSH [tag] 255 PUSH [tag] 240
 O: SWAP2 POP SWAP2 POP PUSH [tag] 254 DUP2 DUP8 PUSH [tag] 255 PUSH [tag] 240
*)
Compute pair "BottleCastle_run_code_of_0_block_285_0"%string (equiv_checker [DUP 2;POP;DUP 2;POP;PUSH 1 (posToWord WLen 0xfe%positive);DUP 2;DUP 8;PUSH 1 (posToWord WLen 0xff%positive);PUSH 1 (posToWord WLen 0xf0%positive)] [DUP 2;POP;DUP 2;POP;PUSH 1 (posToWord WLen 0xfe%positive);DUP 2;DUP 8;PUSH 1 (posToWord WLen 0xff%positive);PUSH 1 (posToWord WLen 0xf0%positive)] 8 optimize_id).

(*
 I: PUSH [tag] 256
 O: PUSH [tag] 256
*)
Compute pair "BottleCastle_run_code_of_0_block_286_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x100%positive)] [PUSH 2 (posToWord WLen 0x100%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 257
 O: PUSH [tag] 257
*)
Compute pair "BottleCastle_run_code_of_0_block_287_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x101%positive)] [PUSH 2 (posToWord WLen 0x101%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 258 DUP7 PUSH [tag] 259 PUSH [tag] 240
 O: PUSH [tag] 258 DUP7 PUSH [tag] 259 PUSH [tag] 240
*)
Compute pair "BottleCastle_run_code_of_0_block_288_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x102%positive);DUP 7;PUSH 2 (posToWord WLen 0x103%positive);PUSH 1 (posToWord WLen 0xf0%positive)] [PUSH 2 (posToWord WLen 0x102%positive);DUP 7;PUSH 2 (posToWord WLen 0x103%positive);PUSH 1 (posToWord WLen 0xf0%positive)] 6 optimize_id).

(*
 I: PUSH [tag] 204
 O: PUSH [tag] 204
*)
Compute pair "BottleCastle_run_code_of_0_block_289_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xcc%positive)] [PUSH 1 (posToWord WLen 0xcc%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 260
 O: PUSH [tag] 260
*)
Compute pair "BottleCastle_run_code_of_0_block_290_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x104%positive)] [PUSH 2 (posToWord WLen 0x104%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 59C896BE00000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 59c896be00000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_291_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x59c896be00000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x59C896BE00000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_291_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 261
 O: PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 AND PUSH ffffffffffffffffffffffffffffffffffffffff DUP7 AND EQ ISZERO PUSH [tag] 261
*)
Compute pair "BottleCastle_run_code_of_0_block_293_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode AND;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 7;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x105%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 6;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x105%positive)] 5 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH EA553B3400000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH ea553b3400000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_294_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xea553b3400000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xEA553B3400000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_294_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH [tag] 262 DUP7 DUP7 DUP7 PUSH 1 PUSH [tag] 263
 O: PUSH [tag] 262 DUP7 DUP7 DUP7 PUSH 1 PUSH [tag] 263
*)
Compute pair "BottleCastle_run_code_of_0_block_295_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x106%positive);DUP 7;DUP 7;DUP 7;PUSH 1 (posToWord WLen 0x1%positive);PUSH 2 (posToWord WLen 0x107%positive)] [PUSH 2 (posToWord WLen 0x106%positive);DUP 7;DUP 7;DUP 7;PUSH 1 (posToWord WLen 0x1%positive);PUSH 2 (posToWord WLen 0x107%positive)] 6 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 264
 O: DUP1 ISZERO PUSH [tag] 264
*)
Compute pair "BottleCastle_run_code_of_0_block_296_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x108%positive)] [DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x108%positive)] 1 optimize_id).

(*
 I: PUSH 0 DUP3
 O: PUSH 0 DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_297_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 3] [PUSH 1 (posToWord WLen 0x0%positive);DUP 3] 2 optimize_id).

(*
 I: PUSH 5 PUSH 0 DUP8 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 5 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP9 AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_298_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x5%positive);PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 9;Opcode AND;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 2] [PUSH 1 (posToWord WLen 0x5%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 8;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 6 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_298_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP2 SLOAD PUSH 1 SWAP1 SUB SWAP2 SWAP1 POP DUP2 SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 1 DUP2 SLOAD SUB DUP1 SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_298_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x1%positive);DUP 2;Opcode SLOAD;Opcode SUB;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode SLOAD;PUSH 1 (posToWord WLen 0x1%positive);DUP 1;Opcode SUB;DUP 2;DUP 1;POP;DUP 2;DUP 1] 1 optimize_id).

(*
 I: POP PUSH 5 PUSH 0 DUP7 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: POP PUSH 5 PUSH 0 DUP7 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_298_3"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x5%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 7;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 2] [POP;PUSH 1 (posToWord WLen 0x5%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 7;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 6 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_298_4"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP2 SLOAD PUSH 1 ADD SWAP2 SWAP1 POP DUP2 SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 1 DUP2 SLOAD ADD DUP1 SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_298_5"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x1%positive);DUP 2;Opcode SLOAD;Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode SLOAD;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 2;DUP 1;POP;DUP 2;DUP 1] 1 optimize_id).

(*
 I: POP PUSH [tag] 265 DUP6 PUSH [tag] 266 DUP9 DUP9 DUP8 PUSH [tag] 267
 O: POP PUSH [tag] 265 DUP6 PUSH [tag] 266 DUP9 DUP3 DUP8 PUSH [tag] 267
*)
Compute pair "BottleCastle_run_code_of_0_block_298_6"%string (equiv_checker [POP;PUSH 2 (posToWord WLen 0x109%positive);DUP 6;PUSH 2 (posToWord WLen 0x10a%positive);DUP 9;DUP 3;DUP 8;PUSH 2 (posToWord WLen 0x10b%positive)] [POP;PUSH 2 (posToWord WLen 0x109%positive);DUP 6;PUSH 2 (posToWord WLen 0x10a%positive);DUP 9;DUP 9;DUP 8;PUSH 2 (posToWord WLen 0x10b%positive)] 7 optimize_id).

(*
 I: PUSH 200000000000000000000000000000000000000000000000000000000 OR PUSH [tag] 268
 O: PUSH 200000000000000000000000000000000000000000000000000000000 OR PUSH [tag] 268
*)
Compute pair "BottleCastle_run_code_of_0_block_299_0"%string (equiv_checker [PUSH 29 (posToWord WLen 0x200000000000000000000000000000000000000000000000000000000%positive);Opcode OR;PUSH 2 (posToWord WLen 0x10c%positive)] [PUSH 29 (posToWord WLen 0x200000000000000000000000000000000000000000000000000000000%positive);Opcode OR;PUSH 2 (posToWord WLen 0x10c%positive)] 1 optimize_id).

(*
 I: PUSH 4 PUSH 0 DUP7 DUP2
 O: PUSH 4 PUSH 0 DUP7 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_300_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 7;DUP 2] [PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 7;DUP 2] 5 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_300_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 DUP2 SWAP1
 O: DUP2 SWAP1 PUSH 20 ADD PUSH 0 KECCAK256
*)
Compute pair "BottleCastle_run_code_of_0_block_300_2"%string (equiv_checker [DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 2;DUP 1] 2 optimize_id).

(*
 I: POP PUSH 0 PUSH 200000000000000000000000000000000000000000000000000000000 DUP5 AND EQ ISZERO PUSH [tag] 269
 O: POP PUSH 200000000000000000000000000000000000000000000000000000000 DUP4 AND PUSH 0 EQ ISZERO PUSH [tag] 269
*)
Compute pair "BottleCastle_run_code_of_0_block_300_3"%string (equiv_checker [POP;PUSH 29 (posToWord WLen 0x200000000000000000000000000000000000000000000000000000000%positive);DUP 4;Opcode AND;PUSH 1 (posToWord WLen 0x0%positive);Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x10d%positive)] [POP;PUSH 1 (posToWord WLen 0x0%positive);PUSH 29 (posToWord WLen 0x200000000000000000000000000000000000000000000000000000000%positive);DUP 5;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x10d%positive)] 4 optimize_id).

(*
 I: PUSH 0 PUSH 1 DUP6 ADD SWAP1 POP PUSH 0 PUSH 4 PUSH 0 DUP4 DUP2
 O: DUP4 PUSH 1 ADD PUSH 0 PUSH 4 DUP2 DUP4 DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_301_0"%string (equiv_checker [DUP 4;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 2;DUP 4;DUP 4] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x1%positive);DUP 6;Opcode ADD;DUP 1;POP;PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 2] 4 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_301_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD EQ ISZERO PUSH [tag] 270
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD EQ ISZERO PUSH [tag] 270
*)
Compute pair "BottleCastle_run_code_of_0_block_301_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x10e%positive)] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x10e%positive)] 2 optimize_id).

(*
 I: PUSH 0 SLOAD DUP2 EQ PUSH [tag] 271
 O: DUP1 PUSH 0 SLOAD EQ PUSH [tag] 271
*)
Compute pair "BottleCastle_run_code_of_0_block_302_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;Opcode EQ;PUSH 2 (posToWord WLen 0x10f%positive)] [PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x10f%positive)] 1 optimize_id).

(*
 I: DUP4 PUSH 4 PUSH 0 DUP4 DUP2
 O: DUP4 PUSH 4 PUSH 0 DUP4 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_303_0"%string (equiv_checker [DUP 4;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 2] [DUP 4;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 2] 4 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_303_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 DUP2 SWAP1
 O: DUP2 SWAP1 PUSH 20 ADD PUSH 0 KECCAK256
*)
Compute pair "BottleCastle_run_code_of_0_block_303_2"%string (equiv_checker [DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 2;DUP 1] 2 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_303_3"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_305_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: DUP4 DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP8 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH DDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF PUSH 40 MLOAD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH ffffffffffffffffffffffffffffffffffffffff DUP1 DUP7 AND DUP8 PUSH 40 MLOAD SWAP3 AND PUSH ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef DUP4 DUP1 SUB DUP9 SWAP5
*)
Compute pair "BottleCastle_run_code_of_0_block_306_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 1;DUP 7;Opcode AND;DUP 8;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 3;Opcode AND;PUSH 32 (posToWord WLen 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef%positive);DUP 4;DUP 1;Opcode SUB;DUP 9;DUP 5] [DUP 4;DUP 6;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 8;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 32 (posToWord WLen 0xDDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 6 optimize_id).

(*
 I: PUSH [tag] 272 DUP7 DUP7 DUP7 PUSH 1 PUSH [tag] 273
 O: PUSH [tag] 272 DUP7 DUP7 DUP7 PUSH 1 PUSH [tag] 273
*)
Compute pair "BottleCastle_run_code_of_0_block_306_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x110%positive);DUP 7;DUP 7;DUP 7;PUSH 1 (posToWord WLen 0x1%positive);PUSH 2 (posToWord WLen 0x111%positive)] [PUSH 2 (posToWord WLen 0x110%positive);DUP 7;DUP 7;DUP 7;PUSH 1 (posToWord WLen 0x1%positive);PUSH 2 (posToWord WLen 0x111%positive)] 6 optimize_id).

(*
 I: POP POP POP POP POP POP
 O: POP POP POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_307_0"%string (equiv_checker [POP;POP;POP;POP;POP;POP] [POP;POP;POP;POP;POP;POP] 6 optimize_id).

(*
 I: PUSH [tag] 275 PUSH [tag] 219
 O: PUSH [tag] 275 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_308_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x113%positive);PUSH 1 (posToWord WLen 0xdb%positive)] [PUSH 2 (posToWord WLen 0x113%positive);PUSH 1 (posToWord WLen 0xdb%positive)] 0 optimize_id).

(*
 I: PUSH 2 PUSH 9 SLOAD EQ ISZERO PUSH [tag] 277
 O: PUSH 2 PUSH 9 SLOAD EQ ISZERO PUSH [tag] 277
*)
Compute pair "BottleCastle_run_code_of_0_block_309_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2%positive);PUSH 1 (posToWord WLen 0x9%positive);Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x115%positive)] [PUSH 1 (posToWord WLen 0x2%positive);PUSH 1 (posToWord WLen 0x9%positive);Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x115%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_310_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8c379a000000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8C379A000000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 278 SWAP1 PUSH [tag] 279
 O: PUSH [tag] 278 SWAP1 PUSH 4 ADD PUSH [tag] 279
*)
Compute pair "BottleCastle_run_code_of_0_block_310_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x116%positive);DUP 1;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x117%positive)] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x116%positive);DUP 1;PUSH 2 (posToWord WLen 0x117%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_311_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 2 PUSH 9 DUP2 SWAP1
 O: PUSH 2 DUP1 PUSH 9
*)
Compute pair "BottleCastle_run_code_of_0_block_312_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2%positive);DUP 1;PUSH 1 (posToWord WLen 0x9%positive)] [PUSH 1 (posToWord WLen 0x2%positive);PUSH 1 (posToWord WLen 0x9%positive);DUP 2;DUP 1] 0 optimize_id).

(*
 I: POP PUSH 0 SELFBALANCE SWAP1 POP PUSH [tag] 281 PUSH [tag] 240
 O: POP SELFBALANCE PUSH [tag] 281 PUSH [tag] 240
*)
Compute pair "BottleCastle_run_code_of_0_block_312_1"%string (equiv_checker [POP;Opcode SELFBALANCE;PUSH 2 (posToWord WLen 0x119%positive);PUSH 1 (posToWord WLen 0xf0%positive)] [POP;PUSH 1 (posToWord WLen 0x0%positive);Opcode SELFBALANCE;DUP 1;POP;PUSH 2 (posToWord WLen 0x119%positive);PUSH 1 (posToWord WLen 0xf0%positive)] 1 optimize_id).

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 8FC DUP3 SWAP1 DUP2 ISZERO MUL SWAP1 PUSH 40 MLOAD PUSH 0 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 DUP6 DUP9 DUP9
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH 0 DUP3 DUP4 ISZERO PUSH 8fc PUSH 40 MLOAD SWAP2 MUL SWAP3 DUP2 DUP1 DUP4 SUB DUP4 DUP6 DUP9 DUP9
*)
Compute pair "BottleCastle_run_code_of_0_block_313_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 4;Opcode ISZERO;PUSH 2 (posToWord WLen 0x8fc%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 2;Opcode MUL;DUP 3;DUP 2;DUP 1;DUP 4;Opcode SUB;DUP 4;DUP 6;DUP 9;DUP 9] [PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 2 (posToWord WLen 0x8FC%positive);DUP 3;DUP 1;DUP 2;Opcode ISZERO;Opcode MUL;DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;DUP 6;DUP 9;DUP 9] 2 optimize_id).

(*
 I: SWAP4 POP POP POP POP ISZERO DUP1 ISZERO PUSH [tag] 283
 O: SWAP4 POP POP POP POP ISZERO DUP1 ISZERO PUSH [tag] 283
*)
Compute pair "BottleCastle_run_code_of_0_block_313_1"%string (equiv_checker [DUP 4;POP;POP;POP;POP;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x11b%positive)] [DUP 4;POP;POP;POP;POP;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x11b%positive)] 5 optimize_id).

(*
 I: RETURNDATASIZE PUSH 0 DUP1
 O: RETURNDATASIZE PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_314_0"%string (equiv_checker [Opcode RETURNDATASIZE;PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [Opcode RETURNDATASIZE;PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: RETURNDATASIZE PUSH 0
 O: RETURNDATASIZE PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_314_1"%string (equiv_checker [Opcode RETURNDATASIZE;PUSH 1 (posToWord WLen 0x0%positive)] [Opcode RETURNDATASIZE;PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: POP POP PUSH 1 PUSH 9 DUP2 SWAP1
 O: POP POP PUSH 1 DUP1 PUSH 9
*)
Compute pair "BottleCastle_run_code_of_0_block_315_0"%string (equiv_checker [POP;POP;PUSH 1 (posToWord WLen 0x1%positive);DUP 1;PUSH 1 (posToWord WLen 0x9%positive)] [POP;POP;PUSH 1 (posToWord WLen 0x1%positive);PUSH 1 (posToWord WLen 0x9%positive);DUP 2;DUP 1] 2 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_315_1"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH [tag] 285 DUP4 DUP4 DUP4 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH [tag] 285 DUP4 DUP4 DUP4 PUSH 40 MLOAD PUSH 20 DUP2 ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_316_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x11d%positive);DUP 4;DUP 4;DUP 4;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 2 (posToWord WLen 0x11d%positive);DUP 4;DUP 4;DUP 4;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 3 optimize_id).

(*
 I: DUP1 PUSH 0 DUP2
 O: DUP1 PUSH 0 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_316_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);DUP 2] [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);DUP 2] 1 optimize_id).

(*
 I: POP PUSH [tag] 164
 O: POP PUSH [tag] 164
*)
Compute pair "BottleCastle_run_code_of_0_block_316_2"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xa4%positive)] [POP;PUSH 1 (posToWord WLen 0xa4%positive)] 1 optimize_id).

(*
 I: POP POP POP
 O: POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_317_0"%string (equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id).

(*
 I: PUSH [tag] 287 PUSH [tag] 219
 O: PUSH [tag] 287 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_318_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x11f%positive);PUSH 1 (posToWord WLen 0xdb%positive)] [PUSH 2 (posToWord WLen 0x11f%positive);PUSH 1 (posToWord WLen 0xdb%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH D DUP2 SWAP1
 O: DUP1 DUP1 PUSH d
*)
Compute pair "BottleCastle_run_code_of_0_block_319_0"%string (equiv_checker [DUP 1;DUP 1;PUSH 1 (posToWord WLen 0xd%positive)] [DUP 1;PUSH 1 (posToWord WLen 0xD%positive);DUP 2;DUP 1] 1 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_319_1"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH 10 PUSH 1 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FF AND DUP2
 O: PUSH 1 PUSH 100 EXP PUSH 10 SLOAD DIV PUSH ff AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_320_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;PUSH 1 (posToWord WLen 0x10%positive);Opcode SLOAD;Opcode DIV;PUSH 1 (posToWord WLen 0xff%positive);Opcode AND;DUP 2] [PUSH 1 (posToWord WLen 0x10%positive);PUSH 1 (posToWord WLen 0x1%positive);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 1;Opcode DIV;PUSH 1 (posToWord WLen 0xFF%positive);Opcode AND;DUP 2] 1 optimize_id).

(*
 I: PUSH [tag] 290 PUSH [tag] 219
 O: PUSH [tag] 290 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_321_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x122%positive);PUSH 1 (posToWord WLen 0xdb%positive)] [PUSH 2 (posToWord WLen 0x122%positive);PUSH 1 (posToWord WLen 0xdb%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH A SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 292 SWAP3 SWAP2 SWAP1 PUSH [tag] 293
 O: PUSH [tag] 292 PUSH a PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 293
*)
Compute pair "BottleCastle_run_code_of_0_block_322_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x124%positive);PUSH 1 (posToWord WLen 0xa%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 2 (posToWord WLen 0x125%positive)] [DUP 1;PUSH 1 (posToWord WLen 0xA%positive);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;PUSH 2 (posToWord WLen 0x124%positive);DUP 3;DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x125%positive)] 1 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_323_0"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH 10 PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FF AND DUP2
 O: PUSH 0 PUSH 100 EXP PUSH 10 SLOAD DIV PUSH ff AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_324_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;PUSH 1 (posToWord WLen 0x10%positive);Opcode SLOAD;Opcode DIV;PUSH 1 (posToWord WLen 0xff%positive);Opcode AND;DUP 2] [PUSH 1 (posToWord WLen 0x10%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 1;Opcode DIV;PUSH 1 (posToWord WLen 0xFF%positive);Opcode AND;DUP 2] 1 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 295 DUP3 PUSH [tag] 250
 O: PUSH 0 PUSH [tag] 295 DUP3 PUSH [tag] 250
*)
Compute pair "BottleCastle_run_code_of_0_block_325_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x127%positive);DUP 3;PUSH 1 (posToWord WLen 0xfa%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x127%positive);DUP 3;PUSH 1 (posToWord WLen 0xfa%positive)] 1 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_326_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH A DUP1 SLOAD PUSH [tag] 296 SWAP1 PUSH [tag] 223
 O: PUSH a PUSH [tag] 296 DUP2 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_327_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xa%positive);PUSH 2 (posToWord WLen 0x128%positive);DUP 2;Opcode SLOAD;PUSH 1 (posToWord WLen 0xdf%positive)] [PUSH 1 (posToWord WLen 0xA%positive);DUP 1;Opcode SLOAD;PUSH 2 (posToWord WLen 0x128%positive);DUP 1;PUSH 1 (posToWord WLen 0xdf%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_328_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 1 optimize_id).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute pair "BottleCastle_run_code_of_0_block_328_1"%string (equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 297 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 297 DUP5 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_328_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;PUSH 2 (posToWord WLen 0x129%positive);DUP 5;Opcode SLOAD;PUSH 1 (posToWord WLen 0xdf%positive)] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (posToWord WLen 0x129%positive);DUP 1;PUSH 1 (posToWord WLen 0xdf%positive)] 3 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 298
 O: DUP1 ISZERO PUSH [tag] 298
*)
Compute pair "BottleCastle_run_code_of_0_block_329_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x12a%positive)] [DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x12a%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 299
 O: DUP1 PUSH 1f LT PUSH [tag] 299
*)
Compute pair "BottleCastle_run_code_of_0_block_330_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);Opcode LT;PUSH 2 (posToWord WLen 0x12b%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode LT;PUSH 2 (posToWord WLen 0x12b%positive)] 1 optimize_id).

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_331_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x100%positive);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (posToWord WLen 0x100%positive);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 298
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 298
*)
Compute pair "BottleCastle_run_code_of_0_block_331_1"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 2 (posToWord WLen 0x12a%positive)] [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 2 (posToWord WLen 0x12a%positive)] 3 optimize_id).

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_332_0"%string (equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] 3 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_332_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] 1 optimize_id).

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_333_0"%string (equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id).

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 300
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 300
*)
Compute pair "BottleCastle_run_code_of_0_block_333_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (posToWord WLen 0x12c%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (posToWord WLen 0x12c%positive)] 3 optimize_id).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_334_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1f%positive);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (posToWord WLen 0x1F%positive);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id).

(*
 I: POP POP POP POP POP DUP2
 O: POP POP POP POP POP DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_335_0"%string (equiv_checker [POP;POP;POP;POP;POP;DUP 2] [POP;POP;POP;POP;POP;DUP 2] 7 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 302
 O: PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 AND DUP2 PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ ISZERO PUSH [tag] 302
*)
Compute pair "BottleCastle_run_code_of_0_block_336_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 3;Opcode AND;DUP 2;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x12e%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 3;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x12e%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 8F4EB60400000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8f4eb60400000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_337_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8f4eb60400000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8F4EB60400000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_337_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH FFFFFFFFFFFFFFFF PUSH 5 PUSH 0 DUP5 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH ffffffffffffffff PUSH 5 PUSH 0 DUP5 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_338_0"%string (equiv_checker [PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);PUSH 1 (posToWord WLen 0x5%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 5;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 2] [PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);PUSH 1 (posToWord WLen 0x5%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 5;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_338_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_338_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;Opcode AND;DUP 2;POP;POP;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 5 optimize_id).

(*
 I: PUSH [tag] 304 PUSH [tag] 219
 O: PUSH [tag] 304 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_339_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x130%positive);PUSH 1 (posToWord WLen 0xdb%positive)] [PUSH 2 (posToWord WLen 0x130%positive);PUSH 1 (posToWord WLen 0xdb%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 306 PUSH 0 PUSH [tag] 307
 O: PUSH [tag] 306 PUSH 0 PUSH [tag] 307
*)
Compute pair "BottleCastle_run_code_of_0_block_340_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x132%positive);PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x133%positive)] [PUSH 2 (posToWord WLen 0x132%positive);PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x133%positive)] 0 optimize_id).

(*
 I: PUSH 60 PUSH 0 DUP1 PUSH 0 PUSH [tag] 309 DUP6 PUSH [tag] 129
 O: PUSH 60 PUSH 0 DUP1 DUP1 PUSH [tag] 309 DUP6 PUSH [tag] 129
*)
Compute pair "BottleCastle_run_code_of_0_block_342_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 1;DUP 1;PUSH 2 (posToWord WLen 0x135%positive);DUP 6;PUSH 1 (posToWord WLen 0x81%positive)] [PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x135%positive);DUP 6;PUSH 1 (posToWord WLen 0x81%positive)] 1 optimize_id).

(*
 I: SWAP1 POP PUSH 0 DUP2 PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 310
 O: SWAP1 POP PUSH 0 DUP2 PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 310
*)
Compute pair "BottleCastle_run_code_of_0_block_343_0"%string (equiv_checker [DUP 1;POP;PUSH 1 (posToWord WLen 0x0%positive);DUP 2;PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x136%positive)] [DUP 1;POP;PUSH 1 (posToWord WLen 0x0%positive);DUP 2;PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x136%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 311 PUSH [tag] 312
 O: PUSH [tag] 311 PUSH [tag] 312
*)
Compute pair "BottleCastle_run_code_of_0_block_344_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x137%positive);PUSH 2 (posToWord WLen 0x138%positive)] [PUSH 2 (posToWord WLen 0x137%positive);PUSH 2 (posToWord WLen 0x138%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD SWAP1 DUP1 DUP3
 O: DUP1 PUSH 40 MLOAD SWAP2 DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_346_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 2;DUP 3] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 1;DUP 3] 1 optimize_id).

(*
 I: DUP1 PUSH 20 MUL PUSH 20 ADD DUP3 ADD PUSH 40
 O: PUSH 20 DUP1 DUP3 MUL ADD DUP3 ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_346_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);DUP 1;DUP 3;Opcode MUL;Opcode ADD;DUP 3;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode MUL;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 2 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 313
 O: DUP1 ISZERO PUSH [tag] 313
*)
Compute pair "BottleCastle_run_code_of_0_block_346_2"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x139%positive)] [DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x139%positive)] 1 optimize_id).

(*
 I: DUP2 PUSH 20 ADD PUSH 20 DUP3 MUL DUP1 CALLDATASIZE DUP4
 O: PUSH 20 DUP3 ADD DUP2 PUSH 20 MUL DUP1 CALLDATASIZE DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_347_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode MUL;DUP 1;Opcode CALLDATASIZE;DUP 4] [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode MUL;DUP 1;Opcode CALLDATASIZE;DUP 4] 2 optimize_id).

(*
 I: DUP1 DUP3 ADD SWAP2 POP POP SWAP1 POP
 O: ADD SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_347_1"%string (equiv_checker [Opcode ADD;DUP 1;POP] [DUP 1;DUP 3;Opcode ADD;DUP 2;POP;POP;DUP 1;POP] 3 optimize_id).

(*
 I: POP SWAP1 POP PUSH [tag] 314 PUSH [tag] 315
 O: POP SWAP1 POP PUSH [tag] 314 PUSH [tag] 315
*)
Compute pair "BottleCastle_run_code_of_0_block_348_0"%string (equiv_checker [POP;DUP 1;POP;PUSH 2 (posToWord WLen 0x13a%positive);PUSH 2 (posToWord WLen 0x13b%positive)] [POP;DUP 1;POP;PUSH 2 (posToWord WLen 0x13a%positive);PUSH 2 (posToWord WLen 0x13b%positive)] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 319 PUSH [tag] 247
 O: PUSH 0 PUSH [tag] 319 PUSH [tag] 247
*)
Compute pair "BottleCastle_run_code_of_0_block_349_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x13f%positive);PUSH 1 (posToWord WLen 0xf7%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x13f%positive);PUSH 1 (posToWord WLen 0xf7%positive)] 0 optimize_id).

(*
 I: SWAP1 POP
 O: SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_350_0"%string (equiv_checker [DUP 1;POP] [DUP 1;POP] 2 optimize_id).

(*
 I: DUP4 DUP7 EQ PUSH [tag] 317
 O: DUP4 DUP7 EQ PUSH [tag] 317
*)
Compute pair "BottleCastle_run_code_of_0_block_351_0"%string (equiv_checker [DUP 4;DUP 7;Opcode EQ;PUSH 2 (posToWord WLen 0x13d%positive)] [DUP 4;DUP 7;Opcode EQ;PUSH 2 (posToWord WLen 0x13d%positive)] 6 optimize_id).

(*
 I: PUSH [tag] 320 DUP2 PUSH [tag] 321
 O: PUSH [tag] 320 DUP2 PUSH [tag] 321
*)
Compute pair "BottleCastle_run_code_of_0_block_352_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x140%positive);DUP 2;PUSH 2 (posToWord WLen 0x141%positive)] [PUSH 2 (posToWord WLen 0x140%positive);DUP 2;PUSH 2 (posToWord WLen 0x141%positive)] 1 optimize_id).

(*
 I: SWAP2 POP DUP2 PUSH 40 ADD MLOAD ISZERO PUSH [tag] 322
 O: SWAP2 POP PUSH 40 DUP3 ADD MLOAD ISZERO PUSH [tag] 322
*)
Compute pair "BottleCastle_run_code_of_0_block_353_0"%string (equiv_checker [DUP 2;POP;PUSH 1 (posToWord WLen 0x40%positive);DUP 3;Opcode ADD;Opcode MLOAD;Opcode ISZERO;PUSH 2 (posToWord WLen 0x142%positive)] [DUP 2;POP;DUP 2;PUSH 1 (posToWord WLen 0x40%positive);Opcode ADD;Opcode MLOAD;Opcode ISZERO;PUSH 2 (posToWord WLen 0x142%positive)] 3 optimize_id).

(*
 I: PUSH [tag] 318
 O: PUSH [tag] 318
*)
Compute pair "BottleCastle_run_code_of_0_block_354_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x13e%positive)] [PUSH 2 (posToWord WLen 0x13e%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH 0 ADD MLOAD PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ PUSH [tag] 323
 O: PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 PUSH 0 ADD MLOAD AND PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ PUSH [tag] 323
*)
Compute pair "BottleCastle_run_code_of_0_block_355_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 3;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;Opcode MLOAD;Opcode AND;PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;Opcode EQ;PUSH 2 (posToWord WLen 0x143%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 3;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;Opcode MLOAD;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode EQ;PUSH 2 (posToWord WLen 0x143%positive)] 2 optimize_id).

(*
 I: DUP2 PUSH 0 ADD MLOAD SWAP5 POP
 O: PUSH 0 DUP3 ADD MLOAD SWAP5 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_356_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;Opcode ADD;Opcode MLOAD;DUP 5;POP] [DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;Opcode MLOAD;DUP 5;POP] 5 optimize_id).

(*
 I: DUP8 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 324
 O: PUSH ffffffffffffffffffffffffffffffffffffffff DUP6 AND DUP9 PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ ISZERO PUSH [tag] 324
*)
Compute pair "BottleCastle_run_code_of_0_block_357_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 6;Opcode AND;DUP 9;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x144%positive)] [DUP 8;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 6;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x144%positive)] 8 optimize_id).

(*
 I: DUP1 DUP4 DUP8 DUP1 PUSH 1 ADD SWAP9 POP DUP2 MLOAD DUP2 LT PUSH [tag] 325
 O: DUP1 DUP4 PUSH 1 DUP9 ADD SWAP8 DUP2 MLOAD DUP2 LT PUSH [tag] 325
*)
Compute pair "BottleCastle_run_code_of_0_block_358_0"%string (equiv_checker [DUP 1;DUP 4;PUSH 1 (posToWord WLen 0x1%positive);DUP 9;Opcode ADD;DUP 8;DUP 2;Opcode MLOAD;DUP 2;Opcode LT;PUSH 2 (posToWord WLen 0x145%positive)] [DUP 1;DUP 4;DUP 8;DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 9;POP;DUP 2;Opcode MLOAD;DUP 2;Opcode LT;PUSH 2 (posToWord WLen 0x145%positive)] 6 optimize_id).

(*
 I: PUSH [tag] 326 PUSH [tag] 327
 O: PUSH [tag] 326 PUSH [tag] 327
*)
Compute pair "BottleCastle_run_code_of_0_block_359_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x146%positive);PUSH 2 (posToWord WLen 0x147%positive)] [PUSH 2 (posToWord WLen 0x146%positive);PUSH 2 (posToWord WLen 0x147%positive)] 0 optimize_id).

(*
 I: PUSH 20 MUL PUSH 20 ADD ADD DUP2 DUP2
 O: PUSH 20 MUL PUSH 20 ADD ADD DUP2 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_361_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode MUL;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;Opcode ADD;DUP 2;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode MUL;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;Opcode ADD;DUP 2;DUP 2] 3 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_361_1"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: DUP1 PUSH 1 ADD SWAP1 POP PUSH [tag] 316
 O: PUSH 1 ADD PUSH [tag] 316
*)
Compute pair "BottleCastle_run_code_of_0_block_363_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x13c%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;POP;PUSH 2 (posToWord WLen 0x13c%positive)] 1 optimize_id).

(*
 I: POP DUP2 SWAP6 POP POP POP POP POP POP SWAP2 SWAP1 POP
 O: POP POP SWAP5 POP POP POP POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_364_0"%string (equiv_checker [POP;POP;DUP 5;POP;POP;POP;POP;POP;DUP 1] [POP;DUP 2;DUP 6;POP;POP;POP;POP;POP;POP;DUP 2;DUP 1;POP] 9 optimize_id).

(*
 I: PUSH 0 PUSH 8 PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1 POP SWAP1
 O: PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 PUSH 100 EXP PUSH 8 SLOAD DIV AND SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_365_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;PUSH 1 (posToWord WLen 0x8%positive);Opcode SLOAD;Opcode DIV;Opcode AND;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x8%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 1;Opcode DIV;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 1;POP;DUP 1] 1 optimize_id).

(*
 I: PUSH [tag] 330 PUSH [tag] 219
 O: PUSH [tag] 330 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_366_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x14a%positive);PUSH 1 (posToWord WLen 0xdb%positive)] [PUSH 2 (posToWord WLen 0x14a%positive);PUSH 1 (posToWord WLen 0xdb%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 10 PUSH 1 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1
 O: DUP1 PUSH 10 DUP2 ISZERO PUSH 1 PUSH 100 EXP PUSH ff DUP2 MUL NOT DUP4 SLOAD AND SWAP2 ISZERO MUL OR SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_367_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x10%positive);DUP 2;Opcode ISZERO;PUSH 1 (posToWord WLen 0x1%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;PUSH 1 (posToWord WLen 0xff%positive);DUP 2;Opcode MUL;Opcode NOT;DUP 4;Opcode SLOAD;Opcode AND;DUP 2;Opcode ISZERO;Opcode MUL;Opcode OR;DUP 1] [DUP 1;PUSH 1 (posToWord WLen 0x10%positive);PUSH 1 (posToWord WLen 0x1%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 1 (posToWord WLen 0xFF%positive);Opcode MUL;Opcode NOT;Opcode AND;DUP 1;DUP 4;Opcode ISZERO;Opcode ISZERO;Opcode MUL;Opcode OR;DUP 1] 1 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_367_1"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH 60 PUSH 3 DUP1 SLOAD PUSH [tag] 333 SWAP1 PUSH [tag] 223
 O: PUSH 60 PUSH 3 PUSH [tag] 333 DUP2 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_368_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x3%positive);PUSH 2 (posToWord WLen 0x14d%positive);DUP 2;Opcode SLOAD;PUSH 1 (posToWord WLen 0xdf%positive)] [PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x3%positive);DUP 1;Opcode SLOAD;PUSH 2 (posToWord WLen 0x14d%positive);DUP 1;PUSH 1 (posToWord WLen 0xdf%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_369_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 1 optimize_id).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute pair "BottleCastle_run_code_of_0_block_369_1"%string (equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 334 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 334 DUP5 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_369_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;PUSH 2 (posToWord WLen 0x14e%positive);DUP 5;Opcode SLOAD;PUSH 1 (posToWord WLen 0xdf%positive)] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (posToWord WLen 0x14e%positive);DUP 1;PUSH 1 (posToWord WLen 0xdf%positive)] 3 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 335
 O: DUP1 ISZERO PUSH [tag] 335
*)
Compute pair "BottleCastle_run_code_of_0_block_370_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x14f%positive)] [DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x14f%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 336
 O: DUP1 PUSH 1f LT PUSH [tag] 336
*)
Compute pair "BottleCastle_run_code_of_0_block_371_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);Opcode LT;PUSH 2 (posToWord WLen 0x150%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode LT;PUSH 2 (posToWord WLen 0x150%positive)] 1 optimize_id).

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_372_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x100%positive);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (posToWord WLen 0x100%positive);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 335
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 335
*)
Compute pair "BottleCastle_run_code_of_0_block_372_1"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 2 (posToWord WLen 0x14f%positive)] [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 2 (posToWord WLen 0x14f%positive)] 3 optimize_id).

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_373_0"%string (equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] 3 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_373_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] 1 optimize_id).

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_374_0"%string (equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id).

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 337
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 337
*)
Compute pair "BottleCastle_run_code_of_0_block_374_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (posToWord WLen 0x151%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (posToWord WLen 0x151%positive)] 3 optimize_id).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_375_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1f%positive);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (posToWord WLen 0x1F%positive);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id).

(*
 I: POP POP POP POP POP SWAP1 POP SWAP1
 O: POP POP POP POP POP SWAP2 SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_376_0"%string (equiv_checker [POP;POP;POP;POP;POP;DUP 2;DUP 1;POP] [POP;POP;POP;POP;POP;DUP 1;POP;DUP 1] 8 optimize_id).

(*
 I: PUSH 2 PUSH 9 SLOAD EQ ISZERO PUSH [tag] 339
 O: PUSH 2 PUSH 9 SLOAD EQ ISZERO PUSH [tag] 339
*)
Compute pair "BottleCastle_run_code_of_0_block_377_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2%positive);PUSH 1 (posToWord WLen 0x9%positive);Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x153%positive)] [PUSH 1 (posToWord WLen 0x2%positive);PUSH 1 (posToWord WLen 0x9%positive);Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x153%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_378_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8c379a000000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8C379A000000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 340 SWAP1 PUSH [tag] 279
 O: PUSH [tag] 340 SWAP1 PUSH 4 ADD PUSH [tag] 279
*)
Compute pair "BottleCastle_run_code_of_0_block_378_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x154%positive);DUP 1;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x117%positive)] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x154%positive);DUP 1;PUSH 2 (posToWord WLen 0x117%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_379_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 2 PUSH 9 DUP2 SWAP1
 O: PUSH 2 DUP1 PUSH 9
*)
Compute pair "BottleCastle_run_code_of_0_block_380_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2%positive);DUP 1;PUSH 1 (posToWord WLen 0x9%positive)] [PUSH 1 (posToWord WLen 0x2%positive);PUSH 1 (posToWord WLen 0x9%positive);DUP 2;DUP 1] 0 optimize_id).

(*
 I: POP PUSH 10 PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FF AND ISZERO PUSH [tag] 342
 O: POP PUSH 0 PUSH 100 EXP PUSH 10 SLOAD DIV PUSH ff AND ISZERO PUSH [tag] 342
*)
Compute pair "BottleCastle_run_code_of_0_block_380_1"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;PUSH 1 (posToWord WLen 0x10%positive);Opcode SLOAD;Opcode DIV;PUSH 1 (posToWord WLen 0xff%positive);Opcode AND;Opcode ISZERO;PUSH 2 (posToWord WLen 0x156%positive)] [POP;PUSH 1 (posToWord WLen 0x10%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 1;Opcode DIV;PUSH 1 (posToWord WLen 0xFF%positive);Opcode AND;Opcode ISZERO;PUSH 2 (posToWord WLen 0x156%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_381_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8c379a000000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8C379A000000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 343 SWAP1 PUSH [tag] 344
 O: PUSH [tag] 343 SWAP1 PUSH 4 ADD PUSH [tag] 344
*)
Compute pair "BottleCastle_run_code_of_0_block_381_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x157%positive);DUP 1;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x158%positive)] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x157%positive);DUP 1;PUSH 2 (posToWord WLen 0x158%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_382_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH F SLOAD DUP2 GT ISZERO PUSH [tag] 345
 O: PUSH f SLOAD DUP2 GT ISZERO PUSH [tag] 345
*)
Compute pair "BottleCastle_run_code_of_0_block_383_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xf%positive);Opcode SLOAD;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x159%positive)] [PUSH 1 (posToWord WLen 0xF%positive);Opcode SLOAD;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x159%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_384_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8c379a000000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8C379A000000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 346 SWAP1 PUSH [tag] 347
 O: PUSH [tag] 346 SWAP1 PUSH 4 ADD PUSH [tag] 347
*)
Compute pair "BottleCastle_run_code_of_0_block_384_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x15a%positive);DUP 1;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x15b%positive)] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x15a%positive);DUP 1;PUSH 2 (posToWord WLen 0x15b%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_385_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH E SLOAD DUP2 PUSH [tag] 348 PUSH [tag] 86
 O: PUSH e SLOAD DUP2 PUSH [tag] 348 PUSH [tag] 86
*)
Compute pair "BottleCastle_run_code_of_0_block_386_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xe%positive);Opcode SLOAD;DUP 2;PUSH 2 (posToWord WLen 0x15c%positive);PUSH 1 (posToWord WLen 0x56%positive)] [PUSH 1 (posToWord WLen 0xE%positive);Opcode SLOAD;DUP 2;PUSH 2 (posToWord WLen 0x15c%positive);PUSH 1 (posToWord WLen 0x56%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 349 SWAP2 SWAP1 PUSH [tag] 350
 O: SWAP1 PUSH [tag] 349 SWAP2 PUSH [tag] 350
*)
Compute pair "BottleCastle_run_code_of_0_block_387_0"%string (equiv_checker [DUP 1;PUSH 2 (posToWord WLen 0x15d%positive);DUP 2;PUSH 2 (posToWord WLen 0x15e%positive)] [PUSH 2 (posToWord WLen 0x15d%positive);DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x15e%positive)] 2 optimize_id).

(*
 I: GT ISZERO PUSH [tag] 351
 O: GT ISZERO PUSH [tag] 351
*)
Compute pair "BottleCastle_run_code_of_0_block_388_0"%string (equiv_checker [Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x15f%positive)] [Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x15f%positive)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_389_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8c379a000000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8C379A000000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 352 SWAP1 PUSH [tag] 353
 O: PUSH [tag] 352 SWAP1 PUSH 4 ADD PUSH [tag] 353
*)
Compute pair "BottleCastle_run_code_of_0_block_389_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x160%positive);DUP 1;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x161%positive)] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x160%positive);DUP 1;PUSH 2 (posToWord WLen 0x161%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_390_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH F SLOAD DUP2 PUSH [tag] 354 PUSH [tag] 355 PUSH [tag] 240
 O: PUSH f SLOAD DUP2 PUSH [tag] 354 PUSH [tag] 355 PUSH [tag] 240
*)
Compute pair "BottleCastle_run_code_of_0_block_391_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xf%positive);Opcode SLOAD;DUP 2;PUSH 2 (posToWord WLen 0x162%positive);PUSH 2 (posToWord WLen 0x163%positive);PUSH 1 (posToWord WLen 0xf0%positive)] [PUSH 1 (posToWord WLen 0xF%positive);Opcode SLOAD;DUP 2;PUSH 2 (posToWord WLen 0x162%positive);PUSH 2 (posToWord WLen 0x163%positive);PUSH 1 (posToWord WLen 0xf0%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 356
 O: PUSH [tag] 356
*)
Compute pair "BottleCastle_run_code_of_0_block_392_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x164%positive)] [PUSH 2 (posToWord WLen 0x164%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 357 SWAP2 SWAP1 PUSH [tag] 350
 O: SWAP1 PUSH [tag] 357 SWAP2 PUSH [tag] 350
*)
Compute pair "BottleCastle_run_code_of_0_block_393_0"%string (equiv_checker [DUP 1;PUSH 2 (posToWord WLen 0x165%positive);DUP 2;PUSH 2 (posToWord WLen 0x15e%positive)] [PUSH 2 (posToWord WLen 0x165%positive);DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x15e%positive)] 2 optimize_id).

(*
 I: GT ISZERO PUSH [tag] 358
 O: GT ISZERO PUSH [tag] 358
*)
Compute pair "BottleCastle_run_code_of_0_block_394_0"%string (equiv_checker [Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x166%positive)] [Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x166%positive)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_395_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8c379a000000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8C379A000000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 359 SWAP1 PUSH [tag] 360
 O: PUSH [tag] 359 SWAP1 PUSH 4 ADD PUSH [tag] 360
*)
Compute pair "BottleCastle_run_code_of_0_block_395_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x167%positive);DUP 1;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x168%positive)] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x167%positive);DUP 1;PUSH 2 (posToWord WLen 0x168%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_396_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: DUP1 PUSH D SLOAD PUSH [tag] 361 SWAP2 SWAP1 PUSH [tag] 362
 O: PUSH [tag] 361 DUP2 PUSH d SLOAD PUSH [tag] 362
*)
Compute pair "BottleCastle_run_code_of_0_block_397_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x169%positive);DUP 2;PUSH 1 (posToWord WLen 0xd%positive);Opcode SLOAD;PUSH 2 (posToWord WLen 0x16a%positive)] [DUP 1;PUSH 1 (posToWord WLen 0xD%positive);Opcode SLOAD;PUSH 2 (posToWord WLen 0x169%positive);DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x16a%positive)] 1 optimize_id).

(*
 I: CALLVALUE LT ISZERO PUSH [tag] 363
 O: CALLVALUE LT ISZERO PUSH [tag] 363
*)
Compute pair "BottleCastle_run_code_of_0_block_398_0"%string (equiv_checker [Opcode CALLVALUE;Opcode LT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x16b%positive)] [Opcode CALLVALUE;Opcode LT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x16b%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_399_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8c379a000000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8C379A000000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 364 SWAP1 PUSH [tag] 365
 O: PUSH [tag] 364 SWAP1 PUSH 4 ADD PUSH [tag] 365
*)
Compute pair "BottleCastle_run_code_of_0_block_399_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x16c%positive);DUP 1;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x16d%positive)] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x16c%positive);DUP 1;PUSH 2 (posToWord WLen 0x16d%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_400_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH [tag] 366 PUSH [tag] 367 PUSH [tag] 240
 O: PUSH [tag] 366 PUSH [tag] 367 PUSH [tag] 240
*)
Compute pair "BottleCastle_run_code_of_0_block_401_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x16e%positive);PUSH 2 (posToWord WLen 0x16f%positive);PUSH 1 (posToWord WLen 0xf0%positive)] [PUSH 2 (posToWord WLen 0x16e%positive);PUSH 2 (posToWord WLen 0x16f%positive);PUSH 1 (posToWord WLen 0xf0%positive)] 0 optimize_id).

(*
 I: DUP3 PUSH [tag] 368
 O: DUP3 PUSH [tag] 368
*)
Compute pair "BottleCastle_run_code_of_0_block_402_0"%string (equiv_checker [DUP 3;PUSH 2 (posToWord WLen 0x170%positive)] [DUP 3;PUSH 2 (posToWord WLen 0x170%positive)] 3 optimize_id).

(*
 I: PUSH 1 PUSH 9 DUP2 SWAP1
 O: PUSH 1 DUP1 PUSH 9
*)
Compute pair "BottleCastle_run_code_of_0_block_403_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive);DUP 1;PUSH 1 (posToWord WLen 0x9%positive)] [PUSH 1 (posToWord WLen 0x1%positive);PUSH 1 (posToWord WLen 0x9%positive);DUP 2;DUP 1] 0 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_403_1"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH [tag] 370 PUSH [tag] 240
 O: PUSH [tag] 370 PUSH [tag] 240
*)
Compute pair "BottleCastle_run_code_of_0_block_404_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x172%positive);PUSH 1 (posToWord WLen 0xf0%positive)] [PUSH 2 (posToWord WLen 0x172%positive);PUSH 1 (posToWord WLen 0xf0%positive)] 0 optimize_id).

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 371
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP3 PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ ISZERO PUSH [tag] 371
*)
Compute pair "BottleCastle_run_code_of_0_block_405_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 3;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x173%positive)] [PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 3;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x173%positive)] 3 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH B06307DB00000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH b06307db00000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_406_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xb06307db00000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xB06307DB00000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_406_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: DUP1 PUSH 7 PUSH 0 PUSH [tag] 372 PUSH [tag] 240
 O: DUP1 PUSH 7 PUSH 0 PUSH [tag] 372 PUSH [tag] 240
*)
Compute pair "BottleCastle_run_code_of_0_block_407_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x7%positive);PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x174%positive);PUSH 1 (posToWord WLen 0xf0%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x7%positive);PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x174%positive);PUSH 1 (posToWord WLen 0xf0%positive)] 1 optimize_id).

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_408_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 2] [PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_408_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP5 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP1 DUP7 AND AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_408_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 1;DUP 7;Opcode AND;Opcode AND;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);DUP 5;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 4 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_408_3"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH 100 EXP PUSH ff DUP2 DUP5 ISZERO ISZERO MUL SWAP2 MUL NOT DUP3 SLOAD AND OR SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_408_4"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;PUSH 1 (posToWord WLen 0xff%positive);DUP 2;DUP 5;Opcode ISZERO;Opcode ISZERO;Opcode MUL;DUP 2;Opcode MUL;Opcode NOT;DUP 3;Opcode SLOAD;Opcode AND;Opcode OR;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 1 (posToWord WLen 0xFF%positive);Opcode MUL;Opcode NOT;Opcode AND;DUP 1;DUP 4;Opcode ISZERO;Opcode ISZERO;Opcode MUL;Opcode OR;DUP 1] 2 optimize_id).

(*
 I: POP DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH [tag] 373 PUSH [tag] 240
 O: POP PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 AND PUSH [tag] 373 PUSH [tag] 240
*)
Compute pair "BottleCastle_run_code_of_0_block_408_5"%string (equiv_checker [POP;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 3;Opcode AND;PUSH 2 (posToWord WLen 0x175%positive);PUSH 1 (posToWord WLen 0xf0%positive)] [POP;DUP 2;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 2 (posToWord WLen 0x175%positive);PUSH 1 (posToWord WLen 0xf0%positive)] 3 optimize_id).

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C31 DUP4 PUSH 40 MLOAD PUSH [tag] 374 SWAP2 SWAP1 PUSH [tag] 52
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH 17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31 PUSH [tag] 374 DUP5 PUSH 40 MLOAD PUSH [tag] 52
*)
Compute pair "BottleCastle_run_code_of_0_block_409_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 32 (posToWord WLen 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31%positive);PUSH 2 (posToWord WLen 0x176%positive);DUP 5;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x34%positive)] [PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 32 (posToWord WLen 0x17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C31%positive);DUP 4;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 2 (posToWord WLen 0x176%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x34%positive)] 3 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_410_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_410_1"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH [tag] 376 DUP5 DUP5 DUP5 PUSH [tag] 92
 O: PUSH [tag] 376 DUP5 DUP5 DUP5 PUSH [tag] 92
*)
Compute pair "BottleCastle_run_code_of_0_block_411_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x178%positive);DUP 5;DUP 5;DUP 5;PUSH 1 (posToWord WLen 0x5c%positive)] [PUSH 2 (posToWord WLen 0x178%positive);DUP 5;DUP 5;DUP 5;PUSH 1 (posToWord WLen 0x5c%positive)] 4 optimize_id).

(*
 I: PUSH 0 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EXTCODESIZE EQ PUSH [tag] 377
 O: PUSH 0 DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff AND EXTCODESIZE EQ PUSH [tag] 377
*)
Compute pair "BottleCastle_run_code_of_0_block_412_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;Opcode EXTCODESIZE;Opcode EQ;PUSH 2 (posToWord WLen 0x179%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode EXTCODESIZE;Opcode EQ;PUSH 2 (posToWord WLen 0x179%positive)] 3 optimize_id).

(*
 I: PUSH [tag] 378 DUP5 DUP5 DUP5 DUP5 PUSH [tag] 379
 O: PUSH [tag] 378 DUP5 DUP5 DUP5 DUP5 PUSH [tag] 379
*)
Compute pair "BottleCastle_run_code_of_0_block_413_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x17a%positive);DUP 5;DUP 5;DUP 5;DUP 5;PUSH 2 (posToWord WLen 0x17b%positive)] [PUSH 2 (posToWord WLen 0x17a%positive);DUP 5;DUP 5;DUP 5;DUP 5;PUSH 2 (posToWord WLen 0x17b%positive)] 4 optimize_id).

(*
 I: PUSH [tag] 380
 O: PUSH [tag] 380
*)
Compute pair "BottleCastle_run_code_of_0_block_414_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x17c%positive)] [PUSH 2 (posToWord WLen 0x17c%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH D1A57ED600000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH d1a57ed600000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_415_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xd1a57ed600000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xD1A57ED600000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_415_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_417_0"%string (equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id).

(*
 I: PUSH [tag] 382 PUSH [tag] 219
 O: PUSH [tag] 382 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_418_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x17e%positive);PUSH 1 (posToWord WLen 0xdb%positive)] [PUSH 2 (posToWord WLen 0x17e%positive);PUSH 1 (posToWord WLen 0xdb%positive)] 0 optimize_id).

(*
 I: PUSH 2 PUSH 9 SLOAD EQ ISZERO PUSH [tag] 384
 O: PUSH 2 PUSH 9 SLOAD EQ ISZERO PUSH [tag] 384
*)
Compute pair "BottleCastle_run_code_of_0_block_419_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2%positive);PUSH 1 (posToWord WLen 0x9%positive);Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x180%positive)] [PUSH 1 (posToWord WLen 0x2%positive);PUSH 1 (posToWord WLen 0x9%positive);Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x180%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_420_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8c379a000000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8C379A000000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 385 SWAP1 PUSH [tag] 279
 O: PUSH [tag] 385 SWAP1 PUSH 4 ADD PUSH [tag] 279
*)
Compute pair "BottleCastle_run_code_of_0_block_420_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x181%positive);DUP 1;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x117%positive)] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x181%positive);DUP 1;PUSH 2 (posToWord WLen 0x117%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_421_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 2 PUSH 9 DUP2 SWAP1
 O: PUSH 2 DUP1 PUSH 9
*)
Compute pair "BottleCastle_run_code_of_0_block_422_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2%positive);DUP 1;PUSH 1 (posToWord WLen 0x9%positive)] [PUSH 1 (posToWord WLen 0x2%positive);PUSH 1 (posToWord WLen 0x9%positive);DUP 2;DUP 1] 0 optimize_id).

(*
 I: POP PUSH E SLOAD DUP3 PUSH [tag] 387 PUSH [tag] 86
 O: POP PUSH e SLOAD DUP3 PUSH [tag] 387 PUSH [tag] 86
*)
Compute pair "BottleCastle_run_code_of_0_block_422_1"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xe%positive);Opcode SLOAD;DUP 3;PUSH 2 (posToWord WLen 0x183%positive);PUSH 1 (posToWord WLen 0x56%positive)] [POP;PUSH 1 (posToWord WLen 0xE%positive);Opcode SLOAD;DUP 3;PUSH 2 (posToWord WLen 0x183%positive);PUSH 1 (posToWord WLen 0x56%positive)] 3 optimize_id).

(*
 I: PUSH [tag] 388 SWAP2 SWAP1 PUSH [tag] 350
 O: SWAP1 PUSH [tag] 388 SWAP2 PUSH [tag] 350
*)
Compute pair "BottleCastle_run_code_of_0_block_423_0"%string (equiv_checker [DUP 1;PUSH 2 (posToWord WLen 0x184%positive);DUP 2;PUSH 2 (posToWord WLen 0x15e%positive)] [PUSH 2 (posToWord WLen 0x184%positive);DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x15e%positive)] 2 optimize_id).

(*
 I: GT ISZERO PUSH [tag] 389
 O: GT ISZERO PUSH [tag] 389
*)
Compute pair "BottleCastle_run_code_of_0_block_424_0"%string (equiv_checker [Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x185%positive)] [Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x185%positive)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_425_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8c379a000000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8C379A000000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 390 SWAP1 PUSH [tag] 391
 O: PUSH [tag] 390 SWAP1 PUSH 4 ADD PUSH [tag] 391
*)
Compute pair "BottleCastle_run_code_of_0_block_425_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x186%positive);DUP 1;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x187%positive)] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x186%positive);DUP 1;PUSH 2 (posToWord WLen 0x187%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_426_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH [tag] 392 DUP2 DUP4 PUSH [tag] 368
 O: PUSH [tag] 392 DUP2 DUP4 PUSH [tag] 368
*)
Compute pair "BottleCastle_run_code_of_0_block_427_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x188%positive);DUP 2;DUP 4;PUSH 2 (posToWord WLen 0x170%positive)] [PUSH 2 (posToWord WLen 0x188%positive);DUP 2;DUP 4;PUSH 2 (posToWord WLen 0x170%positive)] 2 optimize_id).

(*
 I: PUSH 1 PUSH 9 DUP2 SWAP1
 O: PUSH 1 DUP1 PUSH 9
*)
Compute pair "BottleCastle_run_code_of_0_block_428_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive);DUP 1;PUSH 1 (posToWord WLen 0x9%positive)] [PUSH 1 (posToWord WLen 0x1%positive);PUSH 1 (posToWord WLen 0x9%positive);DUP 2;DUP 1] 0 optimize_id).

(*
 I: POP POP POP
 O: POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_428_1"%string (equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id).

(*
 I: PUSH F SLOAD DUP2
 O: PUSH f SLOAD DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_429_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xf%positive);Opcode SLOAD;DUP 2] [PUSH 1 (posToWord WLen 0xF%positive);Opcode SLOAD;DUP 2] 1 optimize_id).

(*
 I: PUSH B DUP1 SLOAD PUSH [tag] 393 SWAP1 PUSH [tag] 223
 O: PUSH b PUSH [tag] 393 DUP2 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_430_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xb%positive);PUSH 2 (posToWord WLen 0x189%positive);DUP 2;Opcode SLOAD;PUSH 1 (posToWord WLen 0xdf%positive)] [PUSH 1 (posToWord WLen 0xB%positive);DUP 1;Opcode SLOAD;PUSH 2 (posToWord WLen 0x189%positive);DUP 1;PUSH 1 (posToWord WLen 0xdf%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_431_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 1 optimize_id).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute pair "BottleCastle_run_code_of_0_block_431_1"%string (equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 394 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 394 DUP5 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_431_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;PUSH 2 (posToWord WLen 0x18a%positive);DUP 5;Opcode SLOAD;PUSH 1 (posToWord WLen 0xdf%positive)] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (posToWord WLen 0x18a%positive);DUP 1;PUSH 1 (posToWord WLen 0xdf%positive)] 3 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 395
 O: DUP1 ISZERO PUSH [tag] 395
*)
Compute pair "BottleCastle_run_code_of_0_block_432_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x18b%positive)] [DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x18b%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 396
 O: DUP1 PUSH 1f LT PUSH [tag] 396
*)
Compute pair "BottleCastle_run_code_of_0_block_433_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);Opcode LT;PUSH 2 (posToWord WLen 0x18c%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode LT;PUSH 2 (posToWord WLen 0x18c%positive)] 1 optimize_id).

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_434_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x100%positive);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (posToWord WLen 0x100%positive);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 395
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 395
*)
Compute pair "BottleCastle_run_code_of_0_block_434_1"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 2 (posToWord WLen 0x18b%positive)] [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 2 (posToWord WLen 0x18b%positive)] 3 optimize_id).

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_435_0"%string (equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] 3 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_435_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] 1 optimize_id).

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_436_0"%string (equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id).

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 397
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 397
*)
Compute pair "BottleCastle_run_code_of_0_block_436_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (posToWord WLen 0x18d%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (posToWord WLen 0x18d%positive)] 3 optimize_id).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_437_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1f%positive);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (posToWord WLen 0x1F%positive);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id).

(*
 I: POP POP POP POP POP DUP2
 O: POP POP POP POP POP DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_438_0"%string (equiv_checker [POP;POP;POP;POP;POP;DUP 2] [POP;POP;POP;POP;POP;DUP 2] 7 optimize_id).

(*
 I: PUSH 60 PUSH [tag] 399 DUP3 PUSH [tag] 230
 O: PUSH 60 PUSH [tag] 399 DUP3 PUSH [tag] 230
*)
Compute pair "BottleCastle_run_code_of_0_block_439_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x60%positive);PUSH 2 (posToWord WLen 0x18f%positive);DUP 3;PUSH 1 (posToWord WLen 0xe6%positive)] [PUSH 1 (posToWord WLen 0x60%positive);PUSH 2 (posToWord WLen 0x18f%positive);DUP 3;PUSH 1 (posToWord WLen 0xe6%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 400
 O: PUSH [tag] 400
*)
Compute pair "BottleCastle_run_code_of_0_block_440_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x190%positive)] [PUSH 2 (posToWord WLen 0x190%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_441_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8c379a000000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8C379A000000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 401 SWAP1 PUSH [tag] 402
 O: PUSH [tag] 401 SWAP1 PUSH 4 ADD PUSH [tag] 402
*)
Compute pair "BottleCastle_run_code_of_0_block_441_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x191%positive);DUP 1;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x192%positive)] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x191%positive);DUP 1;PUSH 2 (posToWord WLen 0x192%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_442_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 ISZERO ISZERO PUSH 10 PUSH 1 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FF AND ISZERO ISZERO EQ ISZERO PUSH [tag] 403
 O: PUSH 1 PUSH 100 EXP PUSH 10 SLOAD DIV PUSH ff AND ISZERO ISZERO PUSH 0 ISZERO ISZERO EQ ISZERO PUSH [tag] 403
*)
Compute pair "BottleCastle_run_code_of_0_block_443_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;PUSH 1 (posToWord WLen 0x10%positive);Opcode SLOAD;Opcode DIV;PUSH 1 (posToWord WLen 0xff%positive);Opcode AND;Opcode ISZERO;Opcode ISZERO;PUSH 1 (posToWord WLen 0x0%positive);Opcode ISZERO;Opcode ISZERO;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x193%positive)] [PUSH 1 (posToWord WLen 0x0%positive);Opcode ISZERO;Opcode ISZERO;PUSH 1 (posToWord WLen 0x10%positive);PUSH 1 (posToWord WLen 0x1%positive);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 1;Opcode DIV;PUSH 1 (posToWord WLen 0xFF%positive);Opcode AND;Opcode ISZERO;Opcode ISZERO;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x193%positive)] 0 optimize_id).

(*
 I: PUSH C DUP1 SLOAD PUSH [tag] 404 SWAP1 PUSH [tag] 223
 O: PUSH c PUSH [tag] 404 DUP2 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_444_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xc%positive);PUSH 2 (posToWord WLen 0x194%positive);DUP 2;Opcode SLOAD;PUSH 1 (posToWord WLen 0xdf%positive)] [PUSH 1 (posToWord WLen 0xC%positive);DUP 1;Opcode SLOAD;PUSH 2 (posToWord WLen 0x194%positive);DUP 1;PUSH 1 (posToWord WLen 0xdf%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_445_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 1 optimize_id).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute pair "BottleCastle_run_code_of_0_block_445_1"%string (equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 405 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 405 DUP5 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_445_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;PUSH 2 (posToWord WLen 0x195%positive);DUP 5;Opcode SLOAD;PUSH 1 (posToWord WLen 0xdf%positive)] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (posToWord WLen 0x195%positive);DUP 1;PUSH 1 (posToWord WLen 0xdf%positive)] 3 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 406
 O: DUP1 ISZERO PUSH [tag] 406
*)
Compute pair "BottleCastle_run_code_of_0_block_446_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x196%positive)] [DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x196%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 407
 O: DUP1 PUSH 1f LT PUSH [tag] 407
*)
Compute pair "BottleCastle_run_code_of_0_block_447_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);Opcode LT;PUSH 2 (posToWord WLen 0x197%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode LT;PUSH 2 (posToWord WLen 0x197%positive)] 1 optimize_id).

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_448_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x100%positive);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (posToWord WLen 0x100%positive);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 406
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 406
*)
Compute pair "BottleCastle_run_code_of_0_block_448_1"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 2 (posToWord WLen 0x196%positive)] [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 2 (posToWord WLen 0x196%positive)] 3 optimize_id).

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_449_0"%string (equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] 3 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_449_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] 1 optimize_id).

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_450_0"%string (equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id).

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 408
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 408
*)
Compute pair "BottleCastle_run_code_of_0_block_450_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (posToWord WLen 0x198%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (posToWord WLen 0x198%positive)] 3 optimize_id).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_451_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1f%positive);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (posToWord WLen 0x1F%positive);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id).

(*
 I: POP POP POP POP POP SWAP1 POP PUSH [tag] 398
 O: POP POP POP POP POP SWAP1 POP PUSH [tag] 398
*)
Compute pair "BottleCastle_run_code_of_0_block_452_0"%string (equiv_checker [POP;POP;POP;POP;POP;DUP 1;POP;PUSH 2 (posToWord WLen 0x18e%positive)] [POP;POP;POP;POP;POP;DUP 1;POP;PUSH 2 (posToWord WLen 0x18e%positive)] 7 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 409 PUSH [tag] 410
 O: PUSH 0 PUSH [tag] 409 PUSH [tag] 410
*)
Compute pair "BottleCastle_run_code_of_0_block_453_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x199%positive);PUSH 2 (posToWord WLen 0x19a%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x199%positive);PUSH 2 (posToWord WLen 0x19a%positive)] 0 optimize_id).

(*
 I: SWAP1 POP PUSH 0 DUP2 MLOAD GT PUSH [tag] 411
 O: SWAP1 POP PUSH 0 DUP2 MLOAD GT PUSH [tag] 411
*)
Compute pair "BottleCastle_run_code_of_0_block_454_0"%string (equiv_checker [DUP 1;POP;PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode MLOAD;Opcode GT;PUSH 2 (posToWord WLen 0x19b%positive)] [DUP 1;POP;PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode MLOAD;Opcode GT;PUSH 2 (posToWord WLen 0x19b%positive)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_455_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 0 DUP2
 O: DUP1 PUSH 0 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_455_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);DUP 2] [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);DUP 2] 1 optimize_id).

(*
 I: POP PUSH [tag] 412
 O: POP PUSH [tag] 412
*)
Compute pair "BottleCastle_run_code_of_0_block_455_2"%string (equiv_checker [POP;PUSH 2 (posToWord WLen 0x19c%positive)] [POP;PUSH 2 (posToWord WLen 0x19c%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH [tag] 413 DUP5 PUSH [tag] 414
 O: DUP1 PUSH [tag] 413 DUP5 PUSH [tag] 414
*)
Compute pair "BottleCastle_run_code_of_0_block_456_0"%string (equiv_checker [DUP 1;PUSH 2 (posToWord WLen 0x19d%positive);DUP 5;PUSH 2 (posToWord WLen 0x19e%positive)] [DUP 1;PUSH 2 (posToWord WLen 0x19d%positive);DUP 5;PUSH 2 (posToWord WLen 0x19e%positive)] 3 optimize_id).

(*
 I: PUSH B PUSH 40 MLOAD PUSH 20 ADD PUSH [tag] 415 SWAP4 SWAP3 SWAP2 SWAP1 PUSH [tag] 416
 O: PUSH [tag] 415 SWAP2 SWAP1 PUSH b PUSH 20 PUSH 40 MLOAD ADD PUSH [tag] 416
*)
Compute pair "BottleCastle_run_code_of_0_block_457_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x19f%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0xb%positive);PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;Opcode ADD;PUSH 2 (posToWord WLen 0x1a0%positive)] [PUSH 1 (posToWord WLen 0xB%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x19f%positive);DUP 4;DUP 3;DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x1a0%positive)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 20 DUP2 DUP4 SUB SUB DUP2
 O: PUSH 40 MLOAD PUSH 20 DUP2 DUP4 SUB SUB DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_458_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x20%positive);DUP 2;DUP 4;Opcode SUB;Opcode SUB;DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x20%positive);DUP 2;DUP 4;Opcode SUB;Opcode SUB;DUP 2] 1 optimize_id).

(*
 I: SWAP1 PUSH 40
 O: SWAP1 PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_458_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x40%positive)] 2 optimize_id).

(*
 I: SWAP2 POP POP
 O: SWAP2 POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_459_0"%string (equiv_checker [DUP 2;POP;POP] [DUP 2;POP;POP] 3 optimize_id).

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_460_0"%string (equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH E SLOAD DUP2
 O: PUSH e SLOAD DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_461_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xe%positive);Opcode SLOAD;DUP 2] [PUSH 1 (posToWord WLen 0xE%positive);Opcode SLOAD;DUP 2] 1 optimize_id).

(*
 I: PUSH [tag] 418 PUSH [tag] 219
 O: PUSH [tag] 418 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_462_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x1a2%positive);PUSH 1 (posToWord WLen 0xdb%positive)] [PUSH 2 (posToWord WLen 0x1a2%positive);PUSH 1 (posToWord WLen 0xdb%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH B SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 420 SWAP3 SWAP2 SWAP1 PUSH [tag] 293
 O: PUSH [tag] 420 PUSH b PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 293
*)
Compute pair "BottleCastle_run_code_of_0_block_463_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x1a4%positive);PUSH 1 (posToWord WLen 0xb%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 2 (posToWord WLen 0x125%positive)] [DUP 1;PUSH 1 (posToWord WLen 0xB%positive);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;PUSH 2 (posToWord WLen 0x1a4%positive);DUP 3;DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x125%positive)] 1 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_464_0"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 422 DUP3 PUSH [tag] 356
 O: PUSH 0 PUSH [tag] 422 DUP3 PUSH [tag] 356
*)
Compute pair "BottleCastle_run_code_of_0_block_465_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x1a6%positive);DUP 3;PUSH 2 (posToWord WLen 0x164%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x1a6%positive);DUP 3;PUSH 2 (posToWord WLen 0x164%positive)] 1 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_466_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH [tag] 424 PUSH [tag] 219
 O: PUSH [tag] 424 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_467_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x1a8%positive);PUSH 1 (posToWord WLen 0xdb%positive)] [PUSH 2 (posToWord WLen 0x1a8%positive);PUSH 1 (posToWord WLen 0xdb%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH F DUP2 SWAP1
 O: DUP1 DUP1 PUSH f
*)
Compute pair "BottleCastle_run_code_of_0_block_468_0"%string (equiv_checker [DUP 1;DUP 1;PUSH 1 (posToWord WLen 0xf%positive)] [DUP 1;PUSH 1 (posToWord WLen 0xF%positive);DUP 2;DUP 1] 1 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_468_1"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH 0 PUSH 7 PUSH 0 DUP5 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 0 PUSH 7 DUP2 DUP5 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_469_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x7%positive);DUP 2;DUP 5;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 2] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x7%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 5;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_469_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP5 DUP2 AND AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_469_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 5;DUP 2;Opcode AND;Opcode AND;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_469_3"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FF AND SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP2 PUSH 0 SWAP4 POP POP POP PUSH 20 ADD DUP2 PUSH 100 EXP SWAP2 KECCAK256 SLOAD DIV PUSH ff AND SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_469_4"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;POP;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 2;Opcode KECCAK256;Opcode SLOAD;Opcode DIV;PUSH 1 (posToWord WLen 0xff%positive);Opcode AND;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 1;Opcode DIV;PUSH 1 (posToWord WLen 0xFF%positive);Opcode AND;DUP 1;POP;DUP 3;DUP 2;POP;POP] 5 optimize_id).

(*
 I: PUSH [tag] 428 PUSH [tag] 219
 O: PUSH [tag] 428 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_470_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x1ac%positive);PUSH 1 (posToWord WLen 0xdb%positive)] [PUSH 2 (posToWord WLen 0x1ac%positive);PUSH 1 (posToWord WLen 0xdb%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH C SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 430 SWAP3 SWAP2 SWAP1 PUSH [tag] 293
 O: PUSH [tag] 430 PUSH c PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 293
*)
Compute pair "BottleCastle_run_code_of_0_block_471_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x1ae%positive);PUSH 1 (posToWord WLen 0xc%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 2 (posToWord WLen 0x125%positive)] [DUP 1;PUSH 1 (posToWord WLen 0xC%positive);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;PUSH 2 (posToWord WLen 0x1ae%positive);DUP 3;DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x125%positive)] 1 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_472_0"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH [tag] 432 PUSH [tag] 219
 O: PUSH [tag] 432 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_473_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x1b0%positive);PUSH 1 (posToWord WLen 0xdb%positive)] [PUSH 2 (posToWord WLen 0x1b0%positive);PUSH 1 (posToWord WLen 0xdb%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 434
 O: DUP1 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 AND EQ ISZERO PUSH [tag] 434
*)
Compute pair "BottleCastle_run_code_of_0_block_474_0"%string (equiv_checker [DUP 1;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1b2%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1b2%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_475_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8c379a000000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8C379A000000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 435 SWAP1 PUSH [tag] 436
 O: PUSH [tag] 435 SWAP1 PUSH 4 ADD PUSH [tag] 436
*)
Compute pair "BottleCastle_run_code_of_0_block_475_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x1b3%positive);DUP 1;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x1b4%positive)] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x1b3%positive);DUP 1;PUSH 2 (posToWord WLen 0x1b4%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_476_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH [tag] 437 DUP2 PUSH [tag] 307
 O: PUSH [tag] 437 DUP2 PUSH [tag] 307
*)
Compute pair "BottleCastle_run_code_of_0_block_477_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x1b5%positive);DUP 2;PUSH 2 (posToWord WLen 0x133%positive)] [PUSH 2 (posToWord WLen 0x1b5%positive);DUP 2;PUSH 2 (posToWord WLen 0x133%positive)] 1 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_478_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH [tag] 439 PUSH [tag] 440
 O: PUSH [tag] 439 PUSH [tag] 440
*)
Compute pair "BottleCastle_run_code_of_0_block_479_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x1b7%positive);PUSH 2 (posToWord WLen 0x1b8%positive)] [PUSH 2 (posToWord WLen 0x1b7%positive);PUSH 2 (posToWord WLen 0x1b8%positive)] 0 optimize_id).

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH [tag] 441 PUSH [tag] 142
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH [tag] 441 PUSH [tag] 142
*)
Compute pair "BottleCastle_run_code_of_0_block_480_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 2 (posToWord WLen 0x1b9%positive);PUSH 1 (posToWord WLen 0x8e%positive)] [PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 2 (posToWord WLen 0x1b9%positive);PUSH 1 (posToWord WLen 0x8e%positive)] 1 optimize_id).

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ PUSH [tag] 442
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ PUSH [tag] 442
*)
Compute pair "BottleCastle_run_code_of_0_block_481_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;Opcode EQ;PUSH 2 (posToWord WLen 0x1ba%positive)] [PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode EQ;PUSH 2 (posToWord WLen 0x1ba%positive)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_482_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8c379a000000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8C379A000000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 443 SWAP1 PUSH [tag] 444
 O: PUSH [tag] 443 SWAP1 PUSH 4 ADD PUSH [tag] 444
*)
Compute pair "BottleCastle_run_code_of_0_block_482_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x1bb%positive);DUP 1;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x1bc%positive)] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x1bb%positive);DUP 1;PUSH 2 (posToWord WLen 0x1bc%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_483_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 DUP2 PUSH [tag] 446 PUSH [tag] 247
 O: PUSH 0 DUP2 PUSH [tag] 446 PUSH [tag] 247
*)
Compute pair "BottleCastle_run_code_of_0_block_485_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;PUSH 2 (posToWord WLen 0x1be%positive);PUSH 1 (posToWord WLen 0xf7%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;PUSH 2 (posToWord WLen 0x1be%positive);PUSH 1 (posToWord WLen 0xf7%positive)] 1 optimize_id).

(*
 I: GT ISZERO DUP1 ISZERO PUSH [tag] 447
 O: GT ISZERO DUP1 ISZERO PUSH [tag] 447
*)
Compute pair "BottleCastle_run_code_of_0_block_486_0"%string (equiv_checker [Opcode GT;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1bf%positive)] [Opcode GT;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1bf%positive)] 2 optimize_id).

(*
 I: POP PUSH 0 SLOAD DUP3 LT
 O: POP PUSH 0 SLOAD DUP3 LT
*)
Compute pair "BottleCastle_run_code_of_0_block_487_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;DUP 3;Opcode LT] [POP;PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;DUP 3;Opcode LT] 3 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 448
 O: DUP1 ISZERO PUSH [tag] 448
*)
Compute pair "BottleCastle_run_code_of_0_block_488_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1c0%positive)] [DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1c0%positive)] 1 optimize_id).

(*
 I: POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 PUSH 4 PUSH 0 DUP6 DUP2
 O: POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 PUSH 4 DUP3 DUP6 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_489_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x0%positive);PUSH 29 (posToWord WLen 0x100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 3;DUP 6;DUP 2] [POP;PUSH 1 (posToWord WLen 0x0%positive);PUSH 29 (posToWord WLen 0x100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 6;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_489_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND EQ
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND EQ
*)
Compute pair "BottleCastle_run_code_of_0_block_489_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;Opcode AND;Opcode EQ] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;Opcode AND;Opcode EQ] 3 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_490_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 CALLER SWAP1 POP SWAP1
 O: CALLER SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_491_0"%string (equiv_checker [Opcode CALLER;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);Opcode CALLER;DUP 1;POP;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 PUSH 1 SWAP1 POP SWAP1
 O: PUSH 1 SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_492_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x1%positive);DUP 1;POP;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 DUP1 DUP3 SWAP1 POP DUP1 PUSH [tag] 452 PUSH [tag] 247
 O: PUSH 0 DUP2 DUP1 PUSH [tag] 452 PUSH [tag] 247
*)
Compute pair "BottleCastle_run_code_of_0_block_493_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x1c4%positive);PUSH 1 (posToWord WLen 0xf7%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;DUP 3;DUP 1;POP;DUP 1;PUSH 2 (posToWord WLen 0x1c4%positive);PUSH 1 (posToWord WLen 0xf7%positive)] 1 optimize_id).

(*
 I: GT PUSH [tag] 453
 O: GT PUSH [tag] 453
*)
Compute pair "BottleCastle_run_code_of_0_block_494_0"%string (equiv_checker [Opcode GT;PUSH 2 (posToWord WLen 0x1c5%positive)] [Opcode GT;PUSH 2 (posToWord WLen 0x1c5%positive)] 2 optimize_id).

(*
 I: PUSH 0 SLOAD DUP2 LT ISZERO PUSH [tag] 454
 O: PUSH 0 SLOAD DUP2 LT ISZERO PUSH [tag] 454
*)
Compute pair "BottleCastle_run_code_of_0_block_495_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1c6%positive)] [PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1c6%positive)] 1 optimize_id).

(*
 I: PUSH 0 PUSH 4 PUSH 0 DUP4 DUP2
 O: PUSH 0 PUSH 4 DUP2 DUP4 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_496_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 2;DUP 4;DUP 2] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 2] 1 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_496_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD SWAP1 POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 DUP3 AND EQ ISZERO PUSH [tag] 455
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD PUSH 100000000000000000000000000000000000000000000000000000000 DUP2 SWAP3 POP AND PUSH 0 EQ ISZERO PUSH [tag] 455
*)
Compute pair "BottleCastle_run_code_of_0_block_496_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;PUSH 29 (posToWord WLen 0x100000000000000000000000000000000000000000000000000000000%positive);DUP 2;DUP 3;POP;Opcode AND;PUSH 1 (posToWord WLen 0x0%positive);Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1c7%positive)] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;DUP 1;POP;PUSH 1 (posToWord WLen 0x0%positive);PUSH 29 (posToWord WLen 0x100000000000000000000000000000000000000000000000000000000%positive);DUP 3;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1c7%positive)] 2 optimize_id).

(*
 I: PUSH 0 DUP2 EQ ISZERO PUSH [tag] 457
 O: DUP1 PUSH 0 EQ ISZERO PUSH [tag] 457
*)
Compute pair "BottleCastle_run_code_of_0_block_497_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1c9%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1c9%positive)] 1 optimize_id).

(*
 I: PUSH 4 PUSH 0 DUP4 PUSH 1 SWAP1 SUB SWAP4 POP DUP4 DUP2
 O: PUSH 1 PUSH 4 SWAP3 SUB SWAP2 PUSH 0 DUP4 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_498_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 3;Opcode SUB;DUP 2;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 2] [PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;PUSH 1 (posToWord WLen 0x1%positive);DUP 1;Opcode SUB;DUP 4;POP;DUP 4;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_498_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD SWAP1 POP PUSH [tag] 456
 O: SWAP1 POP PUSH 20 ADD PUSH 0 KECCAK256 SLOAD PUSH [tag] 456
*)
Compute pair "BottleCastle_run_code_of_0_block_498_2"%string (equiv_checker [DUP 1;POP;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;PUSH 2 (posToWord WLen 0x1c8%positive)] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;DUP 1;POP;PUSH 2 (posToWord WLen 0x1c8%positive)] 2 optimize_id).

(*
 I: DUP1 SWAP3 POP POP POP PUSH [tag] 451
 O: SWAP2 POP POP PUSH [tag] 451
*)
Compute pair "BottleCastle_run_code_of_0_block_499_0"%string (equiv_checker [DUP 2;POP;POP;PUSH 2 (posToWord WLen 0x1c3%positive)] [DUP 1;DUP 3;POP;POP;POP;PUSH 2 (posToWord WLen 0x1c3%positive)] 3 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_500_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH DF2D9B4200000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH df2d9b4200000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_502_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xdf2d9b4200000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xDF2D9B4200000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_502_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_503_0"%string (equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 0 PUSH 6 PUSH 0 DUP6 DUP2
 O: PUSH 0 DUP1 DUP1 PUSH 6 DUP2 DUP6 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_504_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;DUP 1;PUSH 1 (posToWord WLen 0x6%positive);DUP 2;DUP 6;DUP 2] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x6%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 6;DUP 2] 1 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_504_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SWAP1 POP DUP1 SWAP3 POP DUP3 SLOAD SWAP2 POP POP SWAP2 POP SWAP2
 O: SWAP1 POP SWAP2 POP SWAP2 POP PUSH 20 ADD SWAP1 POP PUSH 0 KECCAK256 SWAP1 DUP2 SLOAD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_504_2"%string (equiv_checker [DUP 1;POP;DUP 2;POP;DUP 2;POP;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;POP;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1;DUP 2;Opcode SLOAD;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1;POP;DUP 1;DUP 3;POP;DUP 3;Opcode SLOAD;DUP 2;POP;POP;DUP 2;POP;DUP 2] 6 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP4 AND SWAP3 POP PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP3 AND SWAP2 POP DUP4 DUP3 EQ DUP4 DUP4 EQ OR SWAP1 POP SWAP4 SWAP3 POP POP POP
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP1 DUP2 SWAP3 SWAP3 DUP5 EQ SWAP4 POP SWAP3 DUP5 SWAP3 PUSH ffffffffffffffffffffffffffffffffffffffff AND SWAP3 POP SWAP3 POP EQ OR SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_505_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 1;DUP 2;DUP 3;DUP 3;DUP 5;Opcode EQ;DUP 4;POP;DUP 3;DUP 5;DUP 3;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 3;POP;DUP 3;POP;Opcode EQ;Opcode OR;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);DUP 4;Opcode AND;DUP 3;POP;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);DUP 3;Opcode AND;DUP 2;POP;DUP 4;DUP 3;Opcode EQ;DUP 4;DUP 4;Opcode EQ;Opcode OR;DUP 1;POP;DUP 4;DUP 3;POP;POP;POP] 4 optimize_id).

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_506_0"%string (equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH E8 DUP4 SWAP1 SHR SWAP1 POP PUSH E8 PUSH [tag] 462 DUP7 DUP7 DUP5 PUSH [tag] 463
 O: PUSH 0 PUSH [tag] 463 PUSH e8 PUSH [tag] 462 DUP7 DUP7 DUP7 DUP5 SHR DUP1 SWAP6
*)
Compute pair "BottleCastle_run_code_of_0_block_507_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x1cf%positive);PUSH 1 (posToWord WLen 0xe8%positive);PUSH 2 (posToWord WLen 0x1ce%positive);DUP 7;DUP 7;DUP 7;DUP 5;Opcode SHR;DUP 1;DUP 6] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0xE8%positive);DUP 4;DUP 1;Opcode SHR;DUP 1;POP;PUSH 1 (posToWord WLen 0xE8%positive);PUSH 2 (posToWord WLen 0x1ce%positive);DUP 7;DUP 7;DUP 5;PUSH 2 (posToWord WLen 0x1cf%positive)] 3 optimize_id).

(*
 I: PUSH FFFFFF AND SWAP1 SHL SWAP2 POP POP SWAP4 SWAP3 POP POP POP
 O: PUSH ffffff AND SWAP6 POP SWAP4 POP POP POP POP SHL SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_508_0"%string (equiv_checker [PUSH 3 (posToWord WLen 0xffffff%positive);Opcode AND;DUP 6;POP;DUP 4;POP;POP;POP;POP;Opcode SHL;DUP 1] [PUSH 3 (posToWord WLen 0xFFFFFF%positive);Opcode AND;DUP 1;Opcode SHL;DUP 2;POP;POP;DUP 4;DUP 3;POP;POP;POP] 8 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP4 AND SWAP3 POP DUP2 TIMESTAMP PUSH A0 SHL OR DUP4 OR SWAP1 POP SWAP3 SWAP2 POP POP
 O: TIMESTAMP PUSH a0 SHL OR SWAP1 PUSH ffffffffffffffffffffffffffffffffffffffff AND OR SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_509_0"%string (equiv_checker [Opcode TIMESTAMP;PUSH 1 (posToWord WLen 0xa0%positive);Opcode SHL;Opcode OR;DUP 1;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;Opcode OR;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);DUP 4;Opcode AND;DUP 3;POP;DUP 2;Opcode TIMESTAMP;PUSH 1 (posToWord WLen 0xA0%positive);Opcode SHL;Opcode OR;DUP 4;Opcode OR;DUP 1;POP;DUP 3;DUP 2;POP;POP] 3 optimize_id).

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_510_0"%string (equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id).

(*
 I: POP DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 8BE0079C531659141344CD1FD0A4F28419497F9722A3DAAFE3B4186F6B6457E0 PUSH 40 MLOAD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: POP PUSH 40 MLOAD DUP1 DUP1 SUB PUSH 8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP5 DUP2 AND SWAP3 SWAP1 DUP7 AND SWAP4
*)
Compute pair "BottleCastle_run_code_of_0_block_511_1"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 1;Opcode SUB;PUSH 32 (posToWord WLen 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0%positive);PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 5;DUP 2;Opcode AND;DUP 3;DUP 1;DUP 7;Opcode AND;DUP 4] [POP;DUP 2;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 32 (posToWord WLen 0x8BE0079C531659141344CD1FD0A4F28419497F9722A3DAAFE3B4186F6B6457E0%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 3 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_511_2"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH [tag] 467 PUSH [tag] 315
 O: PUSH [tag] 467 PUSH [tag] 315
*)
Compute pair "BottleCastle_run_code_of_0_block_512_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x1d3%positive);PUSH 2 (posToWord WLen 0x13b%positive)] [PUSH 2 (posToWord WLen 0x1d3%positive);PUSH 2 (posToWord WLen 0x13b%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 469 PUSH 4 PUSH 0 DUP5 DUP2
 O: PUSH [tag] 469 PUSH 4 PUSH 0 DUP5 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_513_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x1d5%positive);PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 5;DUP 2] [PUSH 2 (posToWord WLen 0x1d5%positive);PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 5;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_513_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD PUSH [tag] 470
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD PUSH [tag] 470
*)
Compute pair "BottleCastle_run_code_of_0_block_513_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;PUSH 2 (posToWord WLen 0x1d6%positive)] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;PUSH 2 (posToWord WLen 0x1d6%positive)] 1 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_514_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFF PUSH 40 PUSH 5 PUSH 0 DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 0 PUSH ffffffffffffffff PUSH 40 PUSH 5 DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff DUP7 AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_515_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);PUSH 1 (posToWord WLen 0x40%positive);PUSH 1 (posToWord WLen 0x5%positive);DUP 4;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 7;Opcode AND;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 2] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);PUSH 1 (posToWord WLen 0x40%positive);PUSH 1 (posToWord WLen 0x5%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 6;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 1 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_515_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD SWAP1 SHR AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD SWAP1 SHR AND SWAP3 SWAP2 POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_515_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;DUP 1;Opcode SHR;Opcode AND;DUP 3;DUP 2;POP;POP] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;DUP 1;Opcode SHR;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 6 optimize_id).

(*
 I: PUSH [tag] 473 DUP3 DUP3 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH [tag] 473 DUP3 DUP3 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_516_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x1d9%positive);DUP 3;DUP 3;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 2 (posToWord WLen 0x1d9%positive);DUP 3;DUP 3;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 2 optimize_id).

(*
 I: DUP1 PUSH 0 DUP2
 O: DUP1 PUSH 0 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_516_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);DUP 2] [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);DUP 2] 1 optimize_id).

(*
 I: POP PUSH [tag] 474
 O: POP PUSH [tag] 474
*)
Compute pair "BottleCastle_run_code_of_0_block_516_2"%string (equiv_checker [POP;PUSH 2 (posToWord WLen 0x1da%positive)] [POP;PUSH 2 (posToWord WLen 0x1da%positive)] 1 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_517_0"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH 0 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 150B7A02 PUSH [tag] 476 PUSH [tag] 240
 O: PUSH 0 DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH 150b7a02 PUSH [tag] 476 PUSH [tag] 240
*)
Compute pair "BottleCastle_run_code_of_0_block_518_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 4 (posToWord WLen 0x150b7a02%positive);PUSH 2 (posToWord WLen 0x1dc%positive);PUSH 1 (posToWord WLen 0xf0%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 4 (posToWord WLen 0x150B7A02%positive);PUSH 2 (posToWord WLen 0x1dc%positive);PUSH 1 (posToWord WLen 0xf0%positive)] 3 optimize_id).

(*
 I: DUP8 DUP7 DUP7 PUSH 40 MLOAD DUP6 PUSH FFFFFFFF AND PUSH E0 SHL DUP2
 O: DUP8 DUP7 DUP7 PUSH 40 MLOAD DUP6 PUSH ffffffff AND PUSH e0 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_519_0"%string (equiv_checker [DUP 8;DUP 7;DUP 7;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 6;PUSH 4 (posToWord WLen 0xffffffff%positive);Opcode AND;PUSH 1 (posToWord WLen 0xe0%positive);Opcode SHL;DUP 2] [DUP 8;DUP 7;DUP 7;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 6;PUSH 4 (posToWord WLen 0xFFFFFFFF%positive);Opcode AND;PUSH 1 (posToWord WLen 0xE0%positive);Opcode SHL;DUP 2] 8 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 477 SWAP5 SWAP4 SWAP3 SWAP2 SWAP1 PUSH [tag] 478
 O: SWAP3 SWAP2 SWAP1 PUSH 4 PUSH [tag] 477 SWAP6 SWAP5 ADD PUSH [tag] 478
*)
Compute pair "BottleCastle_run_code_of_0_block_519_1"%string (equiv_checker [DUP 3;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x4%positive);PUSH 2 (posToWord WLen 0x1dd%positive);DUP 6;DUP 5;Opcode ADD;PUSH 2 (posToWord WLen 0x1de%positive)] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x1dd%positive);DUP 5;DUP 4;DUP 3;DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x1de%positive)] 5 optimize_id).

(*
 I: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP1 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 479
 O: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP9 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 479
*)
Compute pair "BottleCastle_run_code_of_0_block_520_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (posToWord WLen 0x0%positive);DUP 8;DUP 9;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1df%positive)] [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (posToWord WLen 0x0%positive);DUP 8;DUP 1;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1df%positive)] 3 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_521_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP GAS
 O: POP GAS
*)
Compute pair "BottleCastle_run_code_of_0_block_522_0"%string (equiv_checker [POP;Opcode GAS] [POP;Opcode GAS] 1 optimize_id).

(*
 I: SWAP3 POP POP POP DUP1 ISZERO PUSH [tag] 480
 O: SWAP3 POP POP POP DUP1 ISZERO PUSH [tag] 480
*)
Compute pair "BottleCastle_run_code_of_0_block_522_1"%string (equiv_checker [DUP 3;POP;POP;POP;DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1e0%positive)] [DUP 3;POP;POP;POP;DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1e0%positive)] 4 optimize_id).

(*
 I: POP PUSH 40 MLOAD RETURNDATASIZE PUSH 1F NOT PUSH 1F DUP3 ADD AND DUP3 ADD DUP1 PUSH 40
 O: POP PUSH 40 MLOAD RETURNDATASIZE PUSH 1f NOT PUSH 1f DUP3 ADD AND DUP3 ADD DUP1 PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_523_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;Opcode RETURNDATASIZE;PUSH 1 (posToWord WLen 0x1f%positive);Opcode NOT;PUSH 1 (posToWord WLen 0x1f%positive);DUP 3;Opcode ADD;Opcode AND;DUP 3;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x40%positive)] [POP;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;Opcode RETURNDATASIZE;PUSH 1 (posToWord WLen 0x1F%positive);Opcode NOT;PUSH 1 (posToWord WLen 0x1F%positive);DUP 3;Opcode ADD;Opcode AND;DUP 3;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x40%positive)] 1 optimize_id).

(*
 I: POP DUP2 ADD SWAP1 PUSH [tag] 481 SWAP2 SWAP1 PUSH [tag] 482
 O: POP DUP2 ADD PUSH [tag] 481 SWAP2 PUSH [tag] 482
*)
Compute pair "BottleCastle_run_code_of_0_block_523_1"%string (equiv_checker [POP;DUP 2;Opcode ADD;PUSH 2 (posToWord WLen 0x1e1%positive);DUP 2;PUSH 2 (posToWord WLen 0x1e2%positive)] [POP;DUP 2;Opcode ADD;DUP 1;PUSH 2 (posToWord WLen 0x1e1%positive);DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x1e2%positive)] 3 optimize_id).

(*
 I: PUSH 1
 O: PUSH 1
*)
Compute pair "BottleCastle_run_code_of_0_block_524_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive)] [PUSH 1 (posToWord WLen 0x1%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 483
 O: PUSH [tag] 483
*)
Compute pair "BottleCastle_run_code_of_0_block_525_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x1e3%positive)] [PUSH 2 (posToWord WLen 0x1e3%positive)] 0 optimize_id).

(*
 I: RETURNDATASIZE DUP1 PUSH 0 DUP2 EQ PUSH [tag] 488
 O: RETURNDATASIZE DUP1 DUP2 PUSH 0 EQ PUSH [tag] 488
*)
Compute pair "BottleCastle_run_code_of_0_block_526_0"%string (equiv_checker [Opcode RETURNDATASIZE;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode EQ;PUSH 2 (posToWord WLen 0x1e8%positive)] [Opcode RETURNDATASIZE;DUP 1;PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x1e8%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD SWAP2 POP PUSH 1F NOT PUSH 3F RETURNDATASIZE ADD AND DUP3 ADD PUSH 40
 O: PUSH 1f PUSH 40 MLOAD SWAP3 POP NOT RETURNDATASIZE PUSH 3f ADD AND DUP3 ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_527_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1f%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 3;POP;Opcode NOT;Opcode RETURNDATASIZE;PUSH 1 (posToWord WLen 0x3f%positive);Opcode ADD;Opcode AND;DUP 3;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 2;POP;PUSH 1 (posToWord WLen 0x1F%positive);Opcode NOT;PUSH 1 (posToWord WLen 0x3F%positive);Opcode RETURNDATASIZE;Opcode ADD;Opcode AND;DUP 3;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 2 optimize_id).

(*
 I: RETURNDATASIZE DUP3
 O: RETURNDATASIZE DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_527_1"%string (equiv_checker [Opcode RETURNDATASIZE;DUP 3] [Opcode RETURNDATASIZE;DUP 3] 2 optimize_id).

(*
 I: RETURNDATASIZE PUSH 0 PUSH 20 DUP5 ADD
 O: RETURNDATASIZE PUSH 0 PUSH 20 DUP5 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_527_2"%string (equiv_checker [Opcode RETURNDATASIZE;PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 5;Opcode ADD] [Opcode RETURNDATASIZE;PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 5;Opcode ADD] 2 optimize_id).

(*
 I: PUSH [tag] 487
 O: PUSH [tag] 487
*)
Compute pair "BottleCastle_run_code_of_0_block_527_3"%string (equiv_checker [PUSH 2 (posToWord WLen 0x1e7%positive)] [PUSH 2 (posToWord WLen 0x1e7%positive)] 0 optimize_id).

(*
 I: PUSH 60 SWAP2 POP
 O: PUSH 60 SWAP2 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_528_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x60%positive);DUP 2;POP] [PUSH 1 (posToWord WLen 0x60%positive);DUP 2;POP] 2 optimize_id).

(*
 I: POP PUSH 0 DUP2 MLOAD EQ ISZERO PUSH [tag] 489
 O: POP DUP1 MLOAD PUSH 0 EQ ISZERO PUSH [tag] 489
*)
Compute pair "BottleCastle_run_code_of_0_block_529_0"%string (equiv_checker [POP;DUP 1;Opcode MLOAD;PUSH 1 (posToWord WLen 0x0%positive);Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1e9%positive)] [POP;PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode MLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1e9%positive)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH D1A57ED600000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH d1a57ed600000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_530_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xd1a57ed600000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xD1A57ED600000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_530_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: DUP1 MLOAD DUP2 PUSH 20 ADD
 O: DUP1 MLOAD DUP2 PUSH 20 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_531_0"%string (equiv_checker [DUP 1;Opcode MLOAD;DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD] [DUP 1;Opcode MLOAD;DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD] 1 optimize_id).

(*
 I: PUSH 150B7A02 PUSH E0 SHL PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ SWAP2 POP POP SWAP5 SWAP4 POP POP POP POP
 O: SWAP5 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT PUSH 150b7a02 PUSH e0 SHL SWAP2 SWAP8 SWAP7 DUP2 AND SWAP2 AND EQ SWAP6 POP POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_532_0"%string (equiv_checker [DUP 5;PUSH 28 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff%positive);Opcode NOT;PUSH 4 (posToWord WLen 0x150b7a02%positive);PUSH 1 (posToWord WLen 0xe0%positive);Opcode SHL;DUP 2;DUP 8;DUP 7;DUP 2;Opcode AND;DUP 2;Opcode AND;Opcode EQ;DUP 6;POP;POP;POP;POP;POP] [PUSH 4 (posToWord WLen 0x150B7A02%positive);PUSH 1 (posToWord WLen 0xE0%positive);Opcode SHL;PUSH 28 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode NOT;Opcode AND;DUP 2;PUSH 28 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode NOT;Opcode AND;Opcode EQ;DUP 2;POP;POP;DUP 5;DUP 4;POP;POP;POP;POP] 7 optimize_id).

(*
 I: PUSH 60 PUSH A DUP1 SLOAD PUSH [tag] 493 SWAP1 PUSH [tag] 223
 O: PUSH 60 PUSH a PUSH [tag] 493 DUP2 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_533_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0xa%positive);PUSH 2 (posToWord WLen 0x1ed%positive);DUP 2;Opcode SLOAD;PUSH 1 (posToWord WLen 0xdf%positive)] [PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0xA%positive);DUP 1;Opcode SLOAD;PUSH 2 (posToWord WLen 0x1ed%positive);DUP 1;PUSH 1 (posToWord WLen 0xdf%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_534_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 1 optimize_id).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute pair "BottleCastle_run_code_of_0_block_534_1"%string (equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 494 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 494 DUP5 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_534_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;PUSH 2 (posToWord WLen 0x1ee%positive);DUP 5;Opcode SLOAD;PUSH 1 (posToWord WLen 0xdf%positive)] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (posToWord WLen 0x1ee%positive);DUP 1;PUSH 1 (posToWord WLen 0xdf%positive)] 3 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 495
 O: DUP1 ISZERO PUSH [tag] 495
*)
Compute pair "BottleCastle_run_code_of_0_block_535_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1ef%positive)] [DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1ef%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 496
 O: DUP1 PUSH 1f LT PUSH [tag] 496
*)
Compute pair "BottleCastle_run_code_of_0_block_536_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);Opcode LT;PUSH 2 (posToWord WLen 0x1f0%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode LT;PUSH 2 (posToWord WLen 0x1f0%positive)] 1 optimize_id).

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_537_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x100%positive);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (posToWord WLen 0x100%positive);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 495
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 495
*)
Compute pair "BottleCastle_run_code_of_0_block_537_1"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 2 (posToWord WLen 0x1ef%positive)] [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 2 (posToWord WLen 0x1ef%positive)] 3 optimize_id).

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_538_0"%string (equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] 3 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_538_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] 1 optimize_id).

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_539_0"%string (equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id).

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 497
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 497
*)
Compute pair "BottleCastle_run_code_of_0_block_539_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (posToWord WLen 0x1f1%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (posToWord WLen 0x1f1%positive)] 3 optimize_id).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_540_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1f%positive);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (posToWord WLen 0x1F%positive);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id).

(*
 I: POP POP POP POP POP SWAP1 POP SWAP1
 O: POP POP POP POP POP SWAP2 SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_541_0"%string (equiv_checker [POP;POP;POP;POP;POP;DUP 2;DUP 1;POP] [POP;POP;POP;POP;POP;DUP 1;POP;DUP 1] 8 optimize_id).

(*
 I: PUSH 60 PUSH 0 DUP3 EQ ISZERO PUSH [tag] 499
 O: PUSH 60 DUP2 PUSH 0 EQ ISZERO PUSH [tag] 499
*)
Compute pair "BottleCastle_run_code_of_0_block_542_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x60%positive);DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1f3%positive)] [PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 3;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1f3%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 PUSH 40 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 40 ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_543_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 1 DUP2
 O: DUP1 PUSH 1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_543_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);DUP 2] [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);DUP 2] 1 optimize_id).

(*
 I: PUSH 20 ADD PUSH 3000000000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 20 ADD PUSH 3000000000000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_543_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 32 (posToWord WLen 0x3000000000000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 32 (posToWord WLen 0x3000000000000000000000000000000000000000000000000000000000000000%positive);DUP 2] 1 optimize_id).

(*
 I: POP SWAP1 POP PUSH [tag] 498
 O: POP SWAP1 POP PUSH [tag] 498
*)
Compute pair "BottleCastle_run_code_of_0_block_543_3"%string (equiv_checker [POP;DUP 1;POP;PUSH 2 (posToWord WLen 0x1f2%positive)] [POP;DUP 1;POP;PUSH 2 (posToWord WLen 0x1f2%positive)] 3 optimize_id).

(*
 I: PUSH 0 DUP3 SWAP1 POP PUSH 0
 O: DUP2 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_544_0"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 1;POP;PUSH 1 (posToWord WLen 0x0%positive)] 2 optimize_id).

(*
 I: PUSH 0 DUP3 EQ PUSH [tag] 501
 O: DUP2 PUSH 0 EQ PUSH [tag] 501
*)
Compute pair "BottleCastle_run_code_of_0_block_545_0"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode EQ;PUSH 2 (posToWord WLen 0x1f5%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;Opcode EQ;PUSH 2 (posToWord WLen 0x1f5%positive)] 2 optimize_id).

(*
 I: DUP1 DUP1 PUSH [tag] 502 SWAP1 PUSH [tag] 503
 O: DUP1 PUSH [tag] 502 DUP3 PUSH [tag] 503
*)
Compute pair "BottleCastle_run_code_of_0_block_546_0"%string (equiv_checker [DUP 1;PUSH 2 (posToWord WLen 0x1f6%positive);DUP 3;PUSH 2 (posToWord WLen 0x1f7%positive)] [DUP 1;DUP 1;PUSH 2 (posToWord WLen 0x1f6%positive);DUP 1;PUSH 2 (posToWord WLen 0x1f7%positive)] 1 optimize_id).

(*
 I: SWAP2 POP POP PUSH A DUP3 PUSH [tag] 504 SWAP2 SWAP1 PUSH [tag] 505
 O: SWAP2 POP POP PUSH [tag] 504 PUSH a DUP4 PUSH [tag] 505
*)
Compute pair "BottleCastle_run_code_of_0_block_547_0"%string (equiv_checker [DUP 2;POP;POP;PUSH 2 (posToWord WLen 0x1f8%positive);PUSH 1 (posToWord WLen 0xa%positive);DUP 4;PUSH 2 (posToWord WLen 0x1f9%positive)] [DUP 2;POP;POP;PUSH 1 (posToWord WLen 0xA%positive);DUP 3;PUSH 2 (posToWord WLen 0x1f8%positive);DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x1f9%positive)] 4 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 500
 O: SWAP2 POP PUSH [tag] 500
*)
Compute pair "BottleCastle_run_code_of_0_block_548_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x1f4%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x1f4%positive)] 3 optimize_id).

(*
 I: PUSH 0 DUP2 PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 506
 O: PUSH 0 DUP2 PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 506
*)
Compute pair "BottleCastle_run_code_of_0_block_549_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1fa%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1fa%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 507 PUSH [tag] 312
 O: PUSH [tag] 507 PUSH [tag] 312
*)
Compute pair "BottleCastle_run_code_of_0_block_550_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x1fb%positive);PUSH 2 (posToWord WLen 0x138%positive)] [PUSH 2 (posToWord WLen 0x1fb%positive);PUSH 2 (posToWord WLen 0x138%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD SWAP1 DUP1 DUP3
 O: DUP1 PUSH 40 MLOAD SWAP2 DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_552_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 2;DUP 3] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 1;DUP 3] 1 optimize_id).

(*
 I: DUP1 PUSH 1F ADD PUSH 1F NOT AND PUSH 20 ADD DUP3 ADD PUSH 40
 O: DUP2 PUSH 20 PUSH 1f DUP4 ADD PUSH 1f NOT AND ADD ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_552_1"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x1f%positive);DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0x1f%positive);Opcode NOT;Opcode AND;Opcode ADD;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x1F%positive);Opcode NOT;Opcode AND;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 2 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 508
 O: DUP1 ISZERO PUSH [tag] 508
*)
Compute pair "BottleCastle_run_code_of_0_block_552_2"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1fc%positive)] [DUP 1;Opcode ISZERO;PUSH 2 (posToWord WLen 0x1fc%positive)] 1 optimize_id).

(*
 I: DUP2 PUSH 20 ADD PUSH 1 DUP3 MUL DUP1 CALLDATASIZE DUP4
 O: DUP2 PUSH 20 ADD PUSH 1 DUP3 MUL DUP1 CALLDATASIZE DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_553_0"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x1%positive);DUP 3;Opcode MUL;DUP 1;Opcode CALLDATASIZE;DUP 4] [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x1%positive);DUP 3;Opcode MUL;DUP 1;Opcode CALLDATASIZE;DUP 4] 2 optimize_id).

(*
 I: DUP1 DUP3 ADD SWAP2 POP POP SWAP1 POP
 O: ADD SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_553_1"%string (equiv_checker [Opcode ADD;DUP 1;POP] [DUP 1;DUP 3;Opcode ADD;DUP 2;POP;POP;DUP 1;POP] 3 optimize_id).

(*
 I: POP SWAP1 POP
 O: POP SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_554_0"%string (equiv_checker [POP;DUP 1;POP] [POP;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 DUP6 EQ PUSH [tag] 510
 O: DUP5 PUSH 0 EQ PUSH [tag] 510
*)
Compute pair "BottleCastle_run_code_of_0_block_555_0"%string (equiv_checker [DUP 5;PUSH 1 (posToWord WLen 0x0%positive);Opcode EQ;PUSH 2 (posToWord WLen 0x1fe%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 6;Opcode EQ;PUSH 2 (posToWord WLen 0x1fe%positive)] 5 optimize_id).

(*
 I: PUSH 1 DUP3 PUSH [tag] 511 SWAP2 SWAP1 PUSH [tag] 512
 O: PUSH [tag] 511 PUSH 1 DUP4 PUSH [tag] 512
*)
Compute pair "BottleCastle_run_code_of_0_block_556_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x1ff%positive);PUSH 1 (posToWord WLen 0x1%positive);DUP 4;PUSH 2 (posToWord WLen 0x200%positive)] [PUSH 1 (posToWord WLen 0x1%positive);DUP 3;PUSH 2 (posToWord WLen 0x1ff%positive);DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x200%positive)] 2 optimize_id).

(*
 I: SWAP2 POP PUSH A DUP6 PUSH [tag] 513 SWAP2 SWAP1 PUSH [tag] 514
 O: SWAP2 POP PUSH [tag] 513 PUSH a DUP7 PUSH [tag] 514
*)
Compute pair "BottleCastle_run_code_of_0_block_557_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x201%positive);PUSH 1 (posToWord WLen 0xa%positive);DUP 7;PUSH 2 (posToWord WLen 0x202%positive)] [DUP 2;POP;PUSH 1 (posToWord WLen 0xA%positive);DUP 6;PUSH 2 (posToWord WLen 0x201%positive);DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x202%positive)] 6 optimize_id).

(*
 I: PUSH 30 PUSH [tag] 515 SWAP2 SWAP1 PUSH [tag] 350
 O: PUSH [tag] 515 SWAP1 PUSH 30 PUSH [tag] 350
*)
Compute pair "BottleCastle_run_code_of_0_block_558_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x203%positive);DUP 1;PUSH 1 (posToWord WLen 0x30%positive);PUSH 2 (posToWord WLen 0x15e%positive)] [PUSH 1 (posToWord WLen 0x30%positive);PUSH 2 (posToWord WLen 0x203%positive);DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x15e%positive)] 1 optimize_id).

(*
 I: PUSH F8 SHL DUP2 DUP4 DUP2 MLOAD DUP2 LT PUSH [tag] 516
 O: PUSH f8 SHL DUP2 DUP4 DUP4 MLOAD DUP6 LT PUSH [tag] 516
*)
Compute pair "BottleCastle_run_code_of_0_block_559_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xf8%positive);Opcode SHL;DUP 2;DUP 4;DUP 4;Opcode MLOAD;DUP 6;Opcode LT;PUSH 2 (posToWord WLen 0x204%positive)] [PUSH 1 (posToWord WLen 0xF8%positive);Opcode SHL;DUP 2;DUP 4;DUP 2;Opcode MLOAD;DUP 2;Opcode LT;PUSH 2 (posToWord WLen 0x204%positive)] 3 optimize_id).

(*
 I: PUSH [tag] 517 PUSH [tag] 327
 O: PUSH [tag] 517 PUSH [tag] 327
*)
Compute pair "BottleCastle_run_code_of_0_block_560_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x205%positive);PUSH 2 (posToWord WLen 0x147%positive)] [PUSH 2 (posToWord WLen 0x205%positive);PUSH 2 (posToWord WLen 0x147%positive)] 0 optimize_id).

(*
 I: PUSH 20 ADD ADD SWAP1 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND SWAP1 DUP2 PUSH 0 BYTE SWAP1
 O: PUSH 20 ADD SWAP2 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT AND SWAP2 ADD DUP2 PUSH 0 BYTE SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_562_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 31 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff%positive);Opcode NOT;Opcode AND;DUP 2;Opcode ADD;DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode BYTE;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;Opcode ADD;DUP 1;PUSH 31 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode NOT;Opcode AND;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode BYTE;DUP 1] 3 optimize_id).

(*
 I: POP PUSH A DUP6 PUSH [tag] 518 SWAP2 SWAP1 PUSH [tag] 505
 O: POP PUSH [tag] 518 PUSH a DUP7 PUSH [tag] 505
*)
Compute pair "BottleCastle_run_code_of_0_block_562_1"%string (equiv_checker [POP;PUSH 2 (posToWord WLen 0x206%positive);PUSH 1 (posToWord WLen 0xa%positive);DUP 7;PUSH 2 (posToWord WLen 0x1f9%positive)] [POP;PUSH 1 (posToWord WLen 0xA%positive);DUP 6;PUSH 2 (posToWord WLen 0x206%positive);DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x1f9%positive)] 6 optimize_id).

(*
 I: SWAP5 POP PUSH [tag] 509
 O: SWAP5 POP PUSH [tag] 509
*)
Compute pair "BottleCastle_run_code_of_0_block_563_0"%string (equiv_checker [DUP 5;POP;PUSH 2 (posToWord WLen 0x1fd%positive)] [DUP 5;POP;PUSH 2 (posToWord WLen 0x1fd%positive)] 6 optimize_id).

(*
 I: DUP1 SWAP4 POP POP POP POP
 O: SWAP3 POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_564_0"%string (equiv_checker [DUP 3;POP;POP;POP] [DUP 1;DUP 4;POP;POP;POP;POP] 4 optimize_id).

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_565_0"%string (equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 CALLER SWAP1 POP SWAP1
 O: CALLER SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_566_0"%string (equiv_checker [Opcode CALLER;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);Opcode CALLER;DUP 1;POP;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 SWAP4 SWAP3 POP POP POP
 O: POP POP POP PUSH 0 SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_567_0"%string (equiv_checker [POP;POP;POP;PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 3;POP;POP;POP] 4 optimize_id).

(*
 I: PUSH [tag] 521 PUSH [tag] 315
 O: PUSH [tag] 521 PUSH [tag] 315
*)
Compute pair "BottleCastle_run_code_of_0_block_568_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x209%positive);PUSH 2 (posToWord WLen 0x13b%positive)] [PUSH 2 (posToWord WLen 0x209%positive);PUSH 2 (posToWord WLen 0x13b%positive)] 0 optimize_id).

(*
 I: DUP2 DUP2 PUSH 0 ADD SWAP1 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1 DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH ffffffffffffffffffffffffffffffffffffffff DUP2 PUSH 0 ADD DUP4 DUP3 AND DUP1 SWAP3 AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_569_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;DUP 4;DUP 3;Opcode AND;DUP 1;DUP 3;Opcode AND;DUP 2] [DUP 2;DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;DUP 1;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 1;DUP 2;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 2 optimize_id).

(*
 I: POP POP PUSH A0 DUP3 SWAP1 SHR DUP2 PUSH 20 ADD SWAP1 PUSH FFFFFFFFFFFFFFFF AND SWAP1 DUP2 PUSH FFFFFFFFFFFFFFFF AND DUP2
 O: POP DUP2 PUSH 20 ADD PUSH ffffffffffffffff DUP5 DUP2 SWAP4 POP SWAP5 PUSH a0 SHR AND SWAP2 DUP3 AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_569_1"%string (equiv_checker [POP;DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 5;DUP 2;DUP 4;POP;DUP 5;PUSH 1 (posToWord WLen 0xa0%positive);Opcode SHR;Opcode AND;DUP 2;DUP 3;Opcode AND;DUP 2] [POP;POP;PUSH 1 (posToWord WLen 0xA0%positive);DUP 3;DUP 1;Opcode SHR;DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 1;DUP 2;PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 4 optimize_id).

(*
 I: POP POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 DUP4 AND EQ ISZERO DUP2 PUSH 40 ADD SWAP1 ISZERO ISZERO SWAP1 DUP2 ISZERO ISZERO DUP2
 O: POP PUSH 40 DUP4 PUSH 100000000000000000000000000000000000000000000000000000000 AND PUSH 0 EQ ISZERO ISZERO ISZERO SWAP2 POP DUP3 ADD DUP2 ISZERO ISZERO DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_569_2"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;PUSH 29 (posToWord WLen 0x100000000000000000000000000000000000000000000000000000000%positive);Opcode AND;PUSH 1 (posToWord WLen 0x0%positive);Opcode EQ;Opcode ISZERO;Opcode ISZERO;Opcode ISZERO;DUP 2;POP;DUP 3;Opcode ADD;DUP 2;Opcode ISZERO;Opcode ISZERO;DUP 2] [POP;POP;PUSH 1 (posToWord WLen 0x0%positive);PUSH 29 (posToWord WLen 0x100000000000000000000000000000000000000000000000000000000%positive);DUP 4;Opcode AND;Opcode EQ;Opcode ISZERO;DUP 2;PUSH 1 (posToWord WLen 0x40%positive);Opcode ADD;DUP 1;Opcode ISZERO;Opcode ISZERO;DUP 1;DUP 2;Opcode ISZERO;Opcode ISZERO;DUP 2] 4 optimize_id).

(*
 I: POP POP PUSH E8 DUP3 SWAP1 SHR DUP2 PUSH 60 ADD SWAP1 PUSH FFFFFF AND SWAP1 DUP2 PUSH FFFFFF AND DUP2
 O: POP PUSH ffffff DUP1 DUP5 PUSH e8 SHR AND DUP4 PUSH 60 ADD SWAP2 DUP2 SWAP4 POP AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_569_3"%string (equiv_checker [POP;PUSH 3 (posToWord WLen 0xffffff%positive);DUP 1;DUP 5;PUSH 1 (posToWord WLen 0xe8%positive);Opcode SHR;Opcode AND;DUP 4;PUSH 1 (posToWord WLen 0x60%positive);Opcode ADD;DUP 2;DUP 2;DUP 4;POP;Opcode AND;DUP 2] [POP;POP;PUSH 1 (posToWord WLen 0xE8%positive);DUP 3;DUP 1;Opcode SHR;DUP 2;PUSH 1 (posToWord WLen 0x60%positive);Opcode ADD;DUP 1;PUSH 3 (posToWord WLen 0xFFFFFF%positive);Opcode AND;DUP 1;DUP 2;PUSH 3 (posToWord WLen 0xFFFFFF%positive);Opcode AND;DUP 2] 4 optimize_id).

(*
 I: POP POP SWAP2 SWAP1 POP
 O: POP POP SWAP2 SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_569_4"%string (equiv_checker [POP;POP;DUP 2;DUP 1;POP] [POP;POP;DUP 2;DUP 1;POP] 5 optimize_id).

(*
 I: PUSH [tag] 524 DUP4 DUP4 PUSH [tag] 525
 O: PUSH [tag] 524 DUP4 DUP4 PUSH [tag] 525
*)
Compute pair "BottleCastle_run_code_of_0_block_570_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x20c%positive);DUP 4;DUP 4;PUSH 2 (posToWord WLen 0x20d%positive)] [PUSH 2 (posToWord WLen 0x20c%positive);DUP 4;DUP 4;PUSH 2 (posToWord WLen 0x20d%positive)] 3 optimize_id).

(*
 I: PUSH 0 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EXTCODESIZE EQ PUSH [tag] 526
 O: PUSH 0 DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff AND EXTCODESIZE EQ PUSH [tag] 526
*)
Compute pair "BottleCastle_run_code_of_0_block_571_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;Opcode EXTCODESIZE;Opcode EQ;PUSH 2 (posToWord WLen 0x20e%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode EXTCODESIZE;Opcode EQ;PUSH 2 (posToWord WLen 0x20e%positive)] 3 optimize_id).

(*
 I: PUSH 0 DUP1 SLOAD SWAP1 POP PUSH 0 DUP4 DUP3 SUB SWAP1 POP
 O: PUSH 0 SLOAD DUP3 DUP2 SUB
*)
Compute pair "BottleCastle_run_code_of_0_block_572_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;DUP 3;DUP 2;Opcode SUB] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;Opcode SLOAD;DUP 1;POP;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 3;Opcode SUB;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH [tag] 530 PUSH 0 DUP7 DUP4 DUP1 PUSH 1 ADD SWAP5 POP DUP7 PUSH [tag] 379
 O: PUSH [tag] 530 PUSH 0 DUP7 PUSH 1 DUP5 ADD SWAP4 DUP7 PUSH [tag] 379
*)
Compute pair "BottleCastle_run_code_of_0_block_573_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x212%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 7;PUSH 1 (posToWord WLen 0x1%positive);DUP 5;Opcode ADD;DUP 4;DUP 7;PUSH 2 (posToWord WLen 0x17b%positive)] [PUSH 2 (posToWord WLen 0x212%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 7;DUP 4;DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 5;POP;DUP 7;PUSH 2 (posToWord WLen 0x17b%positive)] 5 optimize_id).

(*
 I: PUSH [tag] 531
 O: PUSH [tag] 531
*)
Compute pair "BottleCastle_run_code_of_0_block_574_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x213%positive)] [PUSH 2 (posToWord WLen 0x213%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH D1A57ED600000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH d1a57ed600000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_575_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xd1a57ed600000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xD1A57ED600000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_575_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: DUP2 DUP2 LT PUSH [tag] 527
 O: DUP2 DUP2 LT PUSH [tag] 527
*)
Compute pair "BottleCastle_run_code_of_0_block_576_0"%string (equiv_checker [DUP 2;DUP 2;Opcode LT;PUSH 2 (posToWord WLen 0x20f%positive)] [DUP 2;DUP 2;Opcode LT;PUSH 2 (posToWord WLen 0x20f%positive)] 2 optimize_id).

(*
 I: DUP2 PUSH 0 SLOAD EQ PUSH [tag] 532
 O: DUP2 PUSH 0 SLOAD EQ PUSH [tag] 532
*)
Compute pair "BottleCastle_run_code_of_0_block_577_0"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;Opcode EQ;PUSH 2 (posToWord WLen 0x214%positive)] [DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;Opcode EQ;PUSH 2 (posToWord WLen 0x214%positive)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_578_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_579_0"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: POP POP POP
 O: POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_580_0"%string (equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id).

(*
 I: PUSH 0 DUP1 SLOAD SWAP1 POP PUSH 0 DUP3 EQ ISZERO PUSH [tag] 534
 O: PUSH 0 DUP2 DUP2 SLOAD SWAP2 EQ ISZERO PUSH [tag] 534
*)
Compute pair "BottleCastle_run_code_of_0_block_581_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;DUP 2;Opcode SLOAD;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x216%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;Opcode SLOAD;DUP 1;POP;PUSH 1 (posToWord WLen 0x0%positive);DUP 3;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x216%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH B562E8DD00000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH b562e8dd00000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_582_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xb562e8dd00000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xB562E8DD00000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_582_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH [tag] 535 PUSH 0 DUP5 DUP4 DUP6 PUSH [tag] 263
 O: PUSH [tag] 535 PUSH 0 DUP5 DUP4 DUP6 PUSH [tag] 263
*)
Compute pair "BottleCastle_run_code_of_0_block_583_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x217%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 5;DUP 4;DUP 6;PUSH 2 (posToWord WLen 0x107%positive)] [PUSH 2 (posToWord WLen 0x217%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 5;DUP 4;DUP 6;PUSH 2 (posToWord WLen 0x107%positive)] 3 optimize_id).

(*
 I: PUSH 1 PUSH 40 PUSH 1 SWAP1 SHL OR DUP3 MUL PUSH 5 PUSH 0 DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 1 DUP1 PUSH 40 SHL OR DUP3 MUL PUSH ffffffffffffffffffffffffffffffffffffffff DUP1 DUP6 AND AND PUSH 0 PUSH 5 SWAP2 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_584_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode SHL;Opcode OR;DUP 3;Opcode MUL;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 1;DUP 6;Opcode AND;Opcode AND;PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x5%positive);DUP 2;DUP 2] [PUSH 1 (posToWord WLen 0x1%positive);PUSH 1 (posToWord WLen 0x40%positive);PUSH 1 (posToWord WLen 0x1%positive);DUP 1;Opcode SHL;Opcode OR;DUP 3;Opcode MUL;PUSH 1 (posToWord WLen 0x5%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 6;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_584_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP3 DUP3 SLOAD ADD SWAP3 POP POP DUP2 SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 SWAP1 DUP2 SLOAD ADD DUP1 SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_584_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1;DUP 2;Opcode SLOAD;Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 3;Opcode SLOAD;Opcode ADD;DUP 3;POP;POP;DUP 2;DUP 1] 2 optimize_id).

(*
 I: POP PUSH [tag] 536 DUP4 PUSH [tag] 537 PUSH 0 DUP7 PUSH 0 PUSH [tag] 267
 O: POP PUSH [tag] 536 DUP4 PUSH [tag] 537 PUSH 0 DUP3 DUP2 PUSH [tag] 267
*)
Compute pair "BottleCastle_run_code_of_0_block_584_3"%string (equiv_checker [POP;PUSH 2 (posToWord WLen 0x218%positive);DUP 4;PUSH 2 (posToWord WLen 0x219%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 2;PUSH 2 (posToWord WLen 0x10b%positive)] [POP;PUSH 2 (posToWord WLen 0x218%positive);DUP 4;PUSH 2 (posToWord WLen 0x219%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 7;PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x10b%positive)] 4 optimize_id).

(*
 I: PUSH [tag] 538 DUP6 PUSH [tag] 539
 O: PUSH [tag] 538 DUP6 PUSH [tag] 539
*)
Compute pair "BottleCastle_run_code_of_0_block_585_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x21a%positive);DUP 6;PUSH 2 (posToWord WLen 0x21b%positive)] [PUSH 2 (posToWord WLen 0x21a%positive);DUP 6;PUSH 2 (posToWord WLen 0x21b%positive)] 5 optimize_id).

(*
 I: OR PUSH [tag] 268
 O: OR PUSH [tag] 268
*)
Compute pair "BottleCastle_run_code_of_0_block_586_0"%string (equiv_checker [Opcode OR;PUSH 2 (posToWord WLen 0x10c%positive)] [Opcode OR;PUSH 2 (posToWord WLen 0x10c%positive)] 2 optimize_id).

(*
 I: PUSH 4 PUSH 0 DUP4 DUP2
 O: PUSH 4 PUSH 0 DUP4 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_587_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 2] [PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_587_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 DUP2 SWAP1
 O: DUP2 SWAP1 PUSH 20 ADD PUSH 0 KECCAK256
*)
Compute pair "BottleCastle_run_code_of_0_block_587_2"%string (equiv_checker [DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 2;DUP 1] 2 optimize_id).

(*
 I: POP PUSH 0 DUP1 DUP4 DUP4 ADD SWAP1 POP PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP6 AND SWAP2 POP DUP3 DUP3 PUSH 0 PUSH DDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF PUSH 0 DUP1
 O: PUSH 0 DUP3 DUP6 PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP3 DUP2 SWAP5 DUP5 SWAP7 DUP9 SWAP2 POP ADD SWAP4 DUP4 SWAP7 PUSH ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_587_3"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 6;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 3;DUP 2;DUP 5;DUP 5;DUP 7;DUP 9;DUP 2;POP;Opcode ADD;DUP 4;DUP 4;DUP 7;PUSH 32 (posToWord WLen 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef%positive);DUP 2] [POP;PUSH 1 (posToWord WLen 0x0%positive);DUP 1;DUP 4;DUP 4;Opcode ADD;DUP 1;POP;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);DUP 6;Opcode AND;DUP 2;POP;DUP 3;DUP 3;PUSH 1 (posToWord WLen 0x0%positive);PUSH 32 (posToWord WLen 0xDDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 4 optimize_id).

(*
 I: PUSH 1 DUP4 ADD
 O: DUP3 PUSH 1 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_587_4"%string (equiv_checker [DUP 3;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD] [PUSH 1 (posToWord WLen 0x1%positive);DUP 4;Opcode ADD] 3 optimize_id).

(*
 I: DUP2 DUP2 EQ PUSH [tag] 542
 O: DUP1 DUP3 EQ PUSH [tag] 542
*)
Compute pair "BottleCastle_run_code_of_0_block_588_0"%string (equiv_checker [DUP 1;DUP 3;Opcode EQ;PUSH 2 (posToWord WLen 0x21e%positive)] [DUP 2;DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x21e%positive)] 2 optimize_id).

(*
 I: DUP1 DUP4 PUSH 0 PUSH DDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF PUSH 0 DUP1
 O: DUP1 DUP4 PUSH 0 PUSH ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef DUP2 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_589_0"%string (equiv_checker [DUP 1;DUP 4;PUSH 1 (posToWord WLen 0x0%positive);PUSH 32 (posToWord WLen 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef%positive);DUP 2;DUP 1] [DUP 1;DUP 4;PUSH 1 (posToWord WLen 0x0%positive);PUSH 32 (posToWord WLen 0xDDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 3 optimize_id).

(*
 I: PUSH 1 DUP2 ADD SWAP1 POP PUSH [tag] 540
 O: PUSH 1 ADD PUSH [tag] 540
*)
Compute pair "BottleCastle_run_code_of_0_block_589_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x21c%positive)] [PUSH 1 (posToWord WLen 0x1%positive);DUP 2;Opcode ADD;DUP 1;POP;PUSH 2 (posToWord WLen 0x21c%positive)] 1 optimize_id).

(*
 I: POP PUSH 0 DUP3 EQ ISZERO PUSH [tag] 543
 O: POP PUSH 0 DUP3 EQ ISZERO PUSH [tag] 543
*)
Compute pair "BottleCastle_run_code_of_0_block_590_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x0%positive);DUP 3;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x21f%positive)] [POP;PUSH 1 (posToWord WLen 0x0%positive);DUP 3;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x21f%positive)] 3 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 2E07630000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 2e07630000000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_591_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x2e07630000000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x2E07630000000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_591_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: DUP1 PUSH 0 DUP2 SWAP1
 O: DUP1 DUP1 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_592_0"%string (equiv_checker [DUP 1;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);DUP 2;DUP 1] 1 optimize_id).

(*
 I: POP POP POP PUSH [tag] 544 PUSH 0 DUP5 DUP4 DUP6 PUSH [tag] 273
 O: POP POP POP PUSH [tag] 544 PUSH 0 DUP5 DUP4 DUP6 PUSH [tag] 273
*)
Compute pair "BottleCastle_run_code_of_0_block_592_1"%string (equiv_checker [POP;POP;POP;PUSH 2 (posToWord WLen 0x220%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 5;DUP 4;DUP 6;PUSH 2 (posToWord WLen 0x111%positive)] [POP;POP;POP;PUSH 2 (posToWord WLen 0x220%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 5;DUP 4;DUP 6;PUSH 2 (posToWord WLen 0x111%positive)] 6 optimize_id).

(*
 I: POP POP POP
 O: POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_593_0"%string (equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH 1 DUP3 EQ PUSH E1 SHL SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 1 EQ PUSH e1 SHL SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_594_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xe1%positive);Opcode SHL;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x1%positive);DUP 3;Opcode EQ;PUSH 1 (posToWord WLen 0xE1%positive);Opcode SHL;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: DUP3 DUP1 SLOAD PUSH [tag] 546 SWAP1 PUSH [tag] 223
 O: DUP3 PUSH [tag] 546 DUP5 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_595_0"%string (equiv_checker [DUP 3;PUSH 2 (posToWord WLen 0x222%positive);DUP 5;Opcode SLOAD;PUSH 1 (posToWord WLen 0xdf%positive)] [DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (posToWord WLen 0x222%positive);DUP 1;PUSH 1 (posToWord WLen 0xdf%positive)] 3 optimize_id).

(*
 I: SWAP1 PUSH 0
 O: SWAP1 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_596_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] 2 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1 PUSH 1F ADD PUSH 20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 548
 O: PUSH 20 DUP1 PUSH 0 KECCAK256 SWAP2 PUSH 1f ADD DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 548
*)
Compute pair "BottleCastle_run_code_of_0_block_596_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);DUP 1;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 2;PUSH 1 (posToWord WLen 0x1f%positive);Opcode ADD;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 2 (posToWord WLen 0x224%positive)] [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 2 (posToWord WLen 0x224%positive)] 3 optimize_id).

(*
 I: PUSH 0 DUP6
 O: PUSH 0 DUP6
*)
Compute pair "BottleCastle_run_code_of_0_block_597_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 6] [PUSH 1 (posToWord WLen 0x0%positive);DUP 6] 5 optimize_id).

(*
 I: PUSH [tag] 547
 O: PUSH [tag] 547
*)
Compute pair "BottleCastle_run_code_of_0_block_597_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x223%positive)] [PUSH 2 (posToWord WLen 0x223%positive)] 0 optimize_id).

(*
 I: DUP3 PUSH 1F LT PUSH [tag] 549
 O: DUP3 PUSH 1f LT PUSH [tag] 549
*)
Compute pair "BottleCastle_run_code_of_0_block_598_0"%string (equiv_checker [DUP 3;PUSH 1 (posToWord WLen 0x1f%positive);Opcode LT;PUSH 2 (posToWord WLen 0x225%positive)] [DUP 3;PUSH 1 (posToWord WLen 0x1F%positive);Opcode LT;PUSH 2 (posToWord WLen 0x225%positive)] 3 optimize_id).

(*
 I: DUP1 MLOAD PUSH FF NOT AND DUP4 DUP1 ADD OR DUP6
 O: DUP3 DUP1 ADD PUSH ff NOT DUP3 MLOAD AND OR DUP6
*)
Compute pair "BottleCastle_run_code_of_0_block_599_0"%string (equiv_checker [DUP 3;DUP 1;Opcode ADD;PUSH 1 (posToWord WLen 0xff%positive);Opcode NOT;DUP 3;Opcode MLOAD;Opcode AND;Opcode OR;DUP 6] [DUP 1;Opcode MLOAD;PUSH 1 (posToWord WLen 0xFF%positive);Opcode NOT;Opcode AND;DUP 4;DUP 1;Opcode ADD;Opcode OR;DUP 6] 5 optimize_id).

(*
 I: PUSH [tag] 547
 O: PUSH [tag] 547
*)
Compute pair "BottleCastle_run_code_of_0_block_599_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x223%positive)] [PUSH 2 (posToWord WLen 0x223%positive)] 0 optimize_id).

(*
 I: DUP3 DUP1 ADD PUSH 1 ADD DUP6
 O: DUP3 DUP4 ADD PUSH 1 ADD DUP6
*)
Compute pair "BottleCastle_run_code_of_0_block_600_0"%string (equiv_checker [DUP 3;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 6] [DUP 3;DUP 1;Opcode ADD;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 6] 5 optimize_id).

(*
 I: DUP3 ISZERO PUSH [tag] 547
 O: DUP3 ISZERO PUSH [tag] 547
*)
Compute pair "BottleCastle_run_code_of_0_block_600_1"%string (equiv_checker [DUP 3;Opcode ISZERO;PUSH 2 (posToWord WLen 0x223%positive)] [DUP 3;Opcode ISZERO;PUSH 2 (posToWord WLen 0x223%positive)] 3 optimize_id).

(*
 I: SWAP2 DUP3 ADD
 O: DUP1 SWAP3 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_601_0"%string (equiv_checker [DUP 1;DUP 3;Opcode ADD] [DUP 2;DUP 3;Opcode ADD] 3 optimize_id).

(*
 I: DUP3 DUP2 GT ISZERO PUSH [tag] 551
 O: DUP3 DUP2 GT ISZERO PUSH [tag] 551
*)
Compute pair "BottleCastle_run_code_of_0_block_602_0"%string (equiv_checker [DUP 3;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x227%positive)] [DUP 3;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x227%positive)] 3 optimize_id).

(*
 I: DUP3 MLOAD DUP3
 O: DUP3 MLOAD DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_603_0"%string (equiv_checker [DUP 3;Opcode MLOAD;DUP 3] [DUP 3;Opcode MLOAD;DUP 3] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 SWAP1 PUSH 1 ADD SWAP1 PUSH [tag] 550
 O: SWAP2 PUSH 20 ADD SWAP2 SWAP1 PUSH 1 ADD SWAP1 PUSH [tag] 550
*)
Compute pair "BottleCastle_run_code_of_0_block_603_1"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 2 (posToWord WLen 0x226%positive)] [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 2 (posToWord WLen 0x226%positive)] 3 optimize_id).

(*
 I: POP SWAP1 POP PUSH [tag] 552 SWAP2 SWAP1 PUSH [tag] 553
 O: POP PUSH [tag] 552 SWAP3 SWAP2 POP PUSH [tag] 553
*)
Compute pair "BottleCastle_run_code_of_0_block_605_0"%string (equiv_checker [POP;PUSH 2 (posToWord WLen 0x228%positive);DUP 3;DUP 2;POP;PUSH 2 (posToWord WLen 0x229%positive)] [POP;DUP 1;POP;PUSH 2 (posToWord WLen 0x228%positive);DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x229%positive)] 4 optimize_id).

(*
 I: POP SWAP1
 O: POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_606_0"%string (equiv_checker [POP;DUP 1] [POP;DUP 1] 3 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 PUSH 80 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 80 ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_607_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x80%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x80%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: DUP1 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_607_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 2] [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 1 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 PUSH FFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 20 ADD PUSH ffffffffffffffff PUSH 0 AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_607_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode AND;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 1 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 ISZERO ISZERO DUP2
 O: PUSH 20 ADD PUSH 0 ISZERO ISZERO DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_607_3"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode ISZERO;Opcode ISZERO;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode ISZERO;Opcode ISZERO;DUP 2] 1 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 PUSH FFFFFF AND DUP2
 O: PUSH 20 ADD PUSH ffffff PUSH 0 AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_607_4"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 3 (posToWord WLen 0xffffff%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode AND;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);PUSH 3 (posToWord WLen 0xFFFFFF%positive);Opcode AND;DUP 2] 1 optimize_id).

(*
 I: POP SWAP1
 O: POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_607_5"%string (equiv_checker [POP;DUP 1] [POP;DUP 1] 3 optimize_id).

(*
 I: DUP1 DUP3 GT ISZERO PUSH [tag] 555
 O: DUP1 DUP3 GT ISZERO PUSH [tag] 555
*)
Compute pair "BottleCastle_run_code_of_0_block_609_0"%string (equiv_checker [DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x22b%positive)] [DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x22b%positive)] 2 optimize_id).

(*
 I: PUSH 0 DUP2 PUSH 0 SWAP1
 O: PUSH 0 DUP1 DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_610_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;DUP 3] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 1 optimize_id).

(*
 I: POP PUSH 1 ADD PUSH [tag] 554
 O: POP PUSH 1 ADD PUSH [tag] 554
*)
Compute pair "BottleCastle_run_code_of_0_block_610_1"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x22a%positive)] [POP;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x22a%positive)] 2 optimize_id).

(*
 I: POP SWAP1
 O: POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_611_0"%string (equiv_checker [POP;DUP 1] [POP;DUP 1] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 559 PUSH [tag] 560 DUP5 PUSH [tag] 561
 O: PUSH 0 PUSH [tag] 559 PUSH [tag] 560 DUP5 PUSH [tag] 561
*)
Compute pair "BottleCastle_run_code_of_0_block_612_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x22f%positive);PUSH 2 (posToWord WLen 0x230%positive);DUP 5;PUSH 2 (posToWord WLen 0x231%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x22f%positive);PUSH 2 (posToWord WLen 0x230%positive);DUP 5;PUSH 2 (posToWord WLen 0x231%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 562
 O: PUSH [tag] 562
*)
Compute pair "BottleCastle_run_code_of_0_block_613_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x232%positive)] [PUSH 2 (posToWord WLen 0x232%positive)] 0 optimize_id).

(*
 I: SWAP1 POP DUP3 DUP2
 O: SWAP1 POP DUP3 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_614_0"%string (equiv_checker [DUP 1;POP;DUP 3;DUP 2] [DUP 1;POP;DUP 3;DUP 2] 4 optimize_id).

(*
 I: PUSH 20 DUP2 ADD DUP5 DUP5 DUP5 ADD GT ISZERO PUSH [tag] 563
 O: DUP1 PUSH 20 ADD DUP5 DUP4 DUP6 ADD GT ISZERO PUSH [tag] 563
*)
Compute pair "BottleCastle_run_code_of_0_block_614_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 5;DUP 4;DUP 6;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x233%positive)] [PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;DUP 5;DUP 5;DUP 5;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x233%positive)] 4 optimize_id).

(*
 I: PUSH [tag] 564 PUSH [tag] 565
 O: PUSH [tag] 564 PUSH [tag] 565
*)
Compute pair "BottleCastle_run_code_of_0_block_615_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x234%positive);PUSH 2 (posToWord WLen 0x235%positive)] [PUSH 2 (posToWord WLen 0x234%positive);PUSH 2 (posToWord WLen 0x235%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 566 DUP5 DUP3 DUP6 PUSH [tag] 567
 O: PUSH [tag] 566 DUP5 DUP3 DUP6 PUSH [tag] 567
*)
Compute pair "BottleCastle_run_code_of_0_block_617_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x236%positive);DUP 5;DUP 3;DUP 6;PUSH 2 (posToWord WLen 0x237%positive)] [PUSH 2 (posToWord WLen 0x236%positive);DUP 5;DUP 3;DUP 6;PUSH 2 (posToWord WLen 0x237%positive)] 4 optimize_id).

(*
 I: POP SWAP4 SWAP3 POP POP POP
 O: POP SWAP4 SWAP3 POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_618_0"%string (equiv_checker [POP;DUP 4;DUP 3;POP;POP;POP] [POP;DUP 4;DUP 3;POP;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 570 PUSH [tag] 571 DUP5 PUSH [tag] 572
 O: PUSH 0 PUSH [tag] 570 PUSH [tag] 571 DUP5 PUSH [tag] 572
*)
Compute pair "BottleCastle_run_code_of_0_block_619_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x23a%positive);PUSH 2 (posToWord WLen 0x23b%positive);DUP 5;PUSH 2 (posToWord WLen 0x23c%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x23a%positive);PUSH 2 (posToWord WLen 0x23b%positive);DUP 5;PUSH 2 (posToWord WLen 0x23c%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 562
 O: PUSH [tag] 562
*)
Compute pair "BottleCastle_run_code_of_0_block_620_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x232%positive)] [PUSH 2 (posToWord WLen 0x232%positive)] 0 optimize_id).

(*
 I: SWAP1 POP DUP3 DUP2
 O: SWAP1 POP DUP3 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_621_0"%string (equiv_checker [DUP 1;POP;DUP 3;DUP 2] [DUP 1;POP;DUP 3;DUP 2] 4 optimize_id).

(*
 I: PUSH 20 DUP2 ADD DUP5 DUP5 DUP5 ADD GT ISZERO PUSH [tag] 573
 O: DUP1 PUSH 20 ADD DUP5 DUP4 DUP6 ADD GT ISZERO PUSH [tag] 573
*)
Compute pair "BottleCastle_run_code_of_0_block_621_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 5;DUP 4;DUP 6;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x23d%positive)] [PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;DUP 5;DUP 5;DUP 5;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x23d%positive)] 4 optimize_id).

(*
 I: PUSH [tag] 574 PUSH [tag] 565
 O: PUSH [tag] 574 PUSH [tag] 565
*)
Compute pair "BottleCastle_run_code_of_0_block_622_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x23e%positive);PUSH 2 (posToWord WLen 0x235%positive)] [PUSH 2 (posToWord WLen 0x23e%positive);PUSH 2 (posToWord WLen 0x235%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 575 DUP5 DUP3 DUP6 PUSH [tag] 567
 O: PUSH [tag] 575 DUP5 DUP3 DUP6 PUSH [tag] 567
*)
Compute pair "BottleCastle_run_code_of_0_block_624_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x23f%positive);DUP 5;DUP 3;DUP 6;PUSH 2 (posToWord WLen 0x237%positive)] [PUSH 2 (posToWord WLen 0x23f%positive);DUP 5;DUP 3;DUP 6;PUSH 2 (posToWord WLen 0x237%positive)] 4 optimize_id).

(*
 I: POP SWAP4 SWAP3 POP POP POP
 O: POP SWAP4 SWAP3 POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_625_0"%string (equiv_checker [POP;DUP 4;DUP 3;POP;POP;POP] [POP;DUP 4;DUP 3;POP;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 578 DUP2 PUSH [tag] 579
 O: DUP1 CALLDATALOAD PUSH [tag] 578 DUP2 PUSH [tag] 579
*)
Compute pair "BottleCastle_run_code_of_0_block_626_0"%string (equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 2 (posToWord WLen 0x242%positive);DUP 2;PUSH 2 (posToWord WLen 0x243%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode CALLDATALOAD;DUP 1;POP;PUSH 2 (posToWord WLen 0x242%positive);DUP 2;PUSH 2 (posToWord WLen 0x243%positive)] 1 optimize_id).

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_627_0"%string (equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 582 DUP2 PUSH [tag] 583
 O: DUP1 CALLDATALOAD PUSH [tag] 582 DUP2 PUSH [tag] 583
*)
Compute pair "BottleCastle_run_code_of_0_block_628_0"%string (equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 2 (posToWord WLen 0x246%positive);DUP 2;PUSH 2 (posToWord WLen 0x247%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode CALLDATALOAD;DUP 1;POP;PUSH 2 (posToWord WLen 0x246%positive);DUP 2;PUSH 2 (posToWord WLen 0x247%positive)] 1 optimize_id).

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_629_0"%string (equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 586 DUP2 PUSH [tag] 587
 O: DUP1 CALLDATALOAD PUSH [tag] 586 DUP2 PUSH [tag] 587
*)
Compute pair "BottleCastle_run_code_of_0_block_630_0"%string (equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 2 (posToWord WLen 0x24a%positive);DUP 2;PUSH 2 (posToWord WLen 0x24b%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode CALLDATALOAD;DUP 1;POP;PUSH 2 (posToWord WLen 0x24a%positive);DUP 2;PUSH 2 (posToWord WLen 0x24b%positive)] 1 optimize_id).

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_631_0"%string (equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP PUSH [tag] 590 DUP2 PUSH [tag] 587
 O: DUP1 MLOAD PUSH [tag] 590 DUP2 PUSH [tag] 587
*)
Compute pair "BottleCastle_run_code_of_0_block_632_0"%string (equiv_checker [DUP 1;Opcode MLOAD;PUSH 2 (posToWord WLen 0x24e%positive);DUP 2;PUSH 2 (posToWord WLen 0x24b%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode MLOAD;DUP 1;POP;PUSH 2 (posToWord WLen 0x24e%positive);DUP 2;PUSH 2 (posToWord WLen 0x24b%positive)] 1 optimize_id).

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_633_0"%string (equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 593
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 593
*)
Compute pair "BottleCastle_run_code_of_0_block_634_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 3;PUSH 1 (posToWord WLen 0x1f%positive);Opcode ADD;Opcode SLT;PUSH 2 (posToWord WLen 0x251%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;PUSH 1 (posToWord WLen 0x1F%positive);DUP 4;Opcode ADD;Opcode SLT;PUSH 2 (posToWord WLen 0x251%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 594 PUSH [tag] 595
 O: PUSH [tag] 594 PUSH [tag] 595
*)
Compute pair "BottleCastle_run_code_of_0_block_635_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x252%positive);PUSH 2 (posToWord WLen 0x253%positive)] [PUSH 2 (posToWord WLen 0x252%positive);PUSH 2 (posToWord WLen 0x253%positive)] 0 optimize_id).

(*
 I: DUP2 CALLDATALOAD PUSH [tag] 596 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 557
 O: DUP2 CALLDATALOAD PUSH [tag] 596 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 557
*)
Compute pair "BottleCastle_run_code_of_0_block_637_0"%string (equiv_checker [DUP 2;Opcode CALLDATALOAD;PUSH 2 (posToWord WLen 0x254%positive);DUP 5;DUP 3;PUSH 1 (posToWord WLen 0x20%positive);DUP 7;Opcode ADD;PUSH 2 (posToWord WLen 0x22d%positive)] [DUP 2;Opcode CALLDATALOAD;PUSH 2 (posToWord WLen 0x254%positive);DUP 5;DUP 3;PUSH 1 (posToWord WLen 0x20%positive);DUP 7;Opcode ADD;PUSH 2 (posToWord WLen 0x22d%positive)] 3 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_638_0"%string (equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 599
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 599
*)
Compute pair "BottleCastle_run_code_of_0_block_639_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 3;PUSH 1 (posToWord WLen 0x1f%positive);Opcode ADD;Opcode SLT;PUSH 2 (posToWord WLen 0x257%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;PUSH 1 (posToWord WLen 0x1F%positive);DUP 4;Opcode ADD;Opcode SLT;PUSH 2 (posToWord WLen 0x257%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 600 PUSH [tag] 595
 O: PUSH [tag] 600 PUSH [tag] 595
*)
Compute pair "BottleCastle_run_code_of_0_block_640_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x258%positive);PUSH 2 (posToWord WLen 0x253%positive)] [PUSH 2 (posToWord WLen 0x258%positive);PUSH 2 (posToWord WLen 0x253%positive)] 0 optimize_id).

(*
 I: DUP2 CALLDATALOAD PUSH [tag] 601 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 568
 O: DUP2 CALLDATALOAD PUSH [tag] 601 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 568
*)
Compute pair "BottleCastle_run_code_of_0_block_642_0"%string (equiv_checker [DUP 2;Opcode CALLDATALOAD;PUSH 2 (posToWord WLen 0x259%positive);DUP 5;DUP 3;PUSH 1 (posToWord WLen 0x20%positive);DUP 7;Opcode ADD;PUSH 2 (posToWord WLen 0x238%positive)] [DUP 2;Opcode CALLDATALOAD;PUSH 2 (posToWord WLen 0x259%positive);DUP 5;DUP 3;PUSH 1 (posToWord WLen 0x20%positive);DUP 7;Opcode ADD;PUSH 2 (posToWord WLen 0x238%positive)] 3 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_643_0"%string (equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 604 DUP2 PUSH [tag] 605
 O: DUP1 CALLDATALOAD PUSH [tag] 604 DUP2 PUSH [tag] 605
*)
Compute pair "BottleCastle_run_code_of_0_block_644_0"%string (equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 2 (posToWord WLen 0x25c%positive);DUP 2;PUSH 2 (posToWord WLen 0x25d%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode CALLDATALOAD;DUP 1;POP;PUSH 2 (posToWord WLen 0x25c%positive);DUP 2;PUSH 2 (posToWord WLen 0x25d%positive)] 1 optimize_id).

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_645_0"%string (equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 607
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 607
*)
Compute pair "BottleCastle_run_code_of_0_block_646_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x25f%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x25f%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 608 PUSH [tag] 609
 O: PUSH [tag] 608 PUSH [tag] 609
*)
Compute pair "BottleCastle_run_code_of_0_block_647_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x260%positive);PUSH 2 (posToWord WLen 0x261%positive)] [PUSH 2 (posToWord WLen 0x260%positive);PUSH 2 (posToWord WLen 0x261%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 610 DUP5 DUP3 DUP6 ADD PUSH [tag] 576
 O: PUSH 0 PUSH [tag] 610 DUP5 DUP5 DUP4 ADD PUSH [tag] 576
*)
Compute pair "BottleCastle_run_code_of_0_block_649_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x262%positive);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x262%positive);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] 3 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_650_0"%string (equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 612
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 612
*)
Compute pair "BottleCastle_run_code_of_0_block_651_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x264%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x264%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 613 PUSH [tag] 609
 O: PUSH [tag] 613 PUSH [tag] 609
*)
Compute pair "BottleCastle_run_code_of_0_block_652_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x265%positive);PUSH 2 (posToWord WLen 0x261%positive)] [PUSH 2 (posToWord WLen 0x265%positive);PUSH 2 (posToWord WLen 0x261%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 614 DUP6 DUP3 DUP7 ADD PUSH [tag] 576
 O: PUSH 0 PUSH [tag] 614 DUP6 DUP6 DUP4 ADD PUSH [tag] 576
*)
Compute pair "BottleCastle_run_code_of_0_block_654_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x266%positive);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x266%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] 4 optimize_id).

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 615 DUP6 DUP3 DUP7 ADD PUSH [tag] 576
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 615 DUP6 DUP6 DUP4 ADD PUSH [tag] 576
*)
Compute pair "BottleCastle_run_code_of_0_block_655_0"%string (equiv_checker [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x267%positive);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x267%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] 6 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_656_0"%string (equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 0 PUSH 60 DUP5 DUP7 SUB SLT ISZERO PUSH [tag] 617
 O: PUSH 0 DUP1 DUP2 PUSH 60 DUP5 DUP7 SUB SLT ISZERO PUSH [tag] 617
*)
Compute pair "BottleCastle_run_code_of_0_block_657_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x60%positive);DUP 5;DUP 7;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x269%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x60%positive);DUP 5;DUP 7;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x269%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 618 PUSH [tag] 609
 O: PUSH [tag] 618 PUSH [tag] 609
*)
Compute pair "BottleCastle_run_code_of_0_block_658_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x26a%positive);PUSH 2 (posToWord WLen 0x261%positive)] [PUSH 2 (posToWord WLen 0x26a%positive);PUSH 2 (posToWord WLen 0x261%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 619 DUP7 DUP3 DUP8 ADD PUSH [tag] 576
 O: PUSH 0 PUSH [tag] 619 DUP7 DUP7 DUP4 ADD PUSH [tag] 576
*)
Compute pair "BottleCastle_run_code_of_0_block_660_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x26b%positive);DUP 7;DUP 7;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x26b%positive);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] 5 optimize_id).

(*
 I: SWAP4 POP POP PUSH 20 PUSH [tag] 620 DUP7 DUP3 DUP8 ADD PUSH [tag] 576
 O: SWAP4 POP POP PUSH 20 PUSH [tag] 620 DUP7 DUP7 DUP4 ADD PUSH [tag] 576
*)
Compute pair "BottleCastle_run_code_of_0_block_661_0"%string (equiv_checker [DUP 4;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x26c%positive);DUP 7;DUP 7;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] [DUP 4;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x26c%positive);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] 7 optimize_id).

(*
 I: SWAP3 POP POP PUSH 40 PUSH [tag] 621 DUP7 DUP3 DUP8 ADD PUSH [tag] 602
 O: SWAP3 POP POP PUSH 40 PUSH [tag] 621 DUP7 DUP3 DUP8 ADD PUSH [tag] 602
*)
Compute pair "BottleCastle_run_code_of_0_block_662_0"%string (equiv_checker [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x40%positive);PUSH 2 (posToWord WLen 0x26d%positive);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 2 (posToWord WLen 0x25a%positive)] [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x40%positive);PUSH 2 (posToWord WLen 0x26d%positive);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 2 (posToWord WLen 0x25a%positive)] 7 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 POP SWAP3
 O: SWAP5 POP POP POP SWAP3 POP SWAP3
*)
Compute pair "BottleCastle_run_code_of_0_block_663_0"%string (equiv_checker [DUP 5;POP;POP;POP;DUP 3;POP;DUP 3] [DUP 2;POP;POP;DUP 3;POP;DUP 3;POP;DUP 3] 8 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 0 DUP1 PUSH 80 DUP6 DUP8 SUB SLT ISZERO PUSH [tag] 623
 O: PUSH 0 DUP1 DUP1 DUP3 PUSH 80 DUP6 DUP8 SUB SLT ISZERO PUSH [tag] 623
*)
Compute pair "BottleCastle_run_code_of_0_block_664_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;DUP 1;DUP 3;PUSH 1 (posToWord WLen 0x80%positive);DUP 6;DUP 8;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x26f%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x80%positive);DUP 6;DUP 8;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x26f%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 624 PUSH [tag] 609
 O: PUSH [tag] 624 PUSH [tag] 609
*)
Compute pair "BottleCastle_run_code_of_0_block_665_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x270%positive);PUSH 2 (posToWord WLen 0x261%positive)] [PUSH 2 (posToWord WLen 0x270%positive);PUSH 2 (posToWord WLen 0x261%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 625 DUP8 DUP3 DUP9 ADD PUSH [tag] 576
 O: PUSH 0 PUSH [tag] 625 DUP8 DUP8 DUP4 ADD PUSH [tag] 576
*)
Compute pair "BottleCastle_run_code_of_0_block_667_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x271%positive);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x271%positive);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] 6 optimize_id).

(*
 I: SWAP5 POP POP PUSH 20 PUSH [tag] 626 DUP8 DUP3 DUP9 ADD PUSH [tag] 576
 O: SWAP5 POP POP PUSH 20 PUSH [tag] 626 DUP8 DUP8 DUP4 ADD PUSH [tag] 576
*)
Compute pair "BottleCastle_run_code_of_0_block_668_0"%string (equiv_checker [DUP 5;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x272%positive);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] [DUP 5;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x272%positive);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] 8 optimize_id).

(*
 I: SWAP4 POP POP PUSH 40 PUSH [tag] 627 DUP8 DUP3 DUP9 ADD PUSH [tag] 602
 O: SWAP4 POP POP PUSH 40 PUSH [tag] 627 DUP8 DUP8 DUP4 ADD PUSH [tag] 602
*)
Compute pair "BottleCastle_run_code_of_0_block_669_0"%string (equiv_checker [DUP 4;POP;POP;PUSH 1 (posToWord WLen 0x40%positive);PUSH 2 (posToWord WLen 0x273%positive);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x25a%positive)] [DUP 4;POP;POP;PUSH 1 (posToWord WLen 0x40%positive);PUSH 2 (posToWord WLen 0x273%positive);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 2 (posToWord WLen 0x25a%positive)] 8 optimize_id).

(*
 I: SWAP3 POP POP PUSH 60 DUP6 ADD CALLDATALOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 628
 O: SWAP3 POP POP DUP5 PUSH 60 ADD CALLDATALOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 628
*)
Compute pair "BottleCastle_run_code_of_0_block_670_0"%string (equiv_checker [DUP 3;POP;POP;DUP 5;PUSH 1 (posToWord WLen 0x60%positive);Opcode ADD;Opcode CALLDATALOAD;PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x274%positive)] [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x60%positive);DUP 6;Opcode ADD;Opcode CALLDATALOAD;PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x274%positive)] 7 optimize_id).

(*
 I: PUSH [tag] 629 PUSH [tag] 630
 O: PUSH [tag] 629 PUSH [tag] 630
*)
Compute pair "BottleCastle_run_code_of_0_block_671_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x275%positive);PUSH 2 (posToWord WLen 0x276%positive)] [PUSH 2 (posToWord WLen 0x275%positive);PUSH 2 (posToWord WLen 0x276%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 631 DUP8 DUP3 DUP9 ADD PUSH [tag] 591
 O: PUSH [tag] 631 DUP8 DUP8 DUP4 ADD PUSH [tag] 591
*)
Compute pair "BottleCastle_run_code_of_0_block_673_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x277%positive);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x24f%positive)] [PUSH 2 (posToWord WLen 0x277%positive);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 2 (posToWord WLen 0x24f%positive)] 7 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP6 SWAP2 SWAP5 POP SWAP3 POP
 O: SWAP5 SWAP8 SWAP4 SWAP7 POP POP POP SWAP3 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_674_0"%string (equiv_checker [DUP 5;DUP 8;DUP 4;DUP 7;POP;POP;POP;DUP 3;POP] [DUP 2;POP;POP;DUP 3;DUP 6;DUP 2;DUP 5;POP;DUP 3;POP] 9 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 633
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 633
*)
Compute pair "BottleCastle_run_code_of_0_block_675_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x279%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x279%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 634 PUSH [tag] 609
 O: PUSH [tag] 634 PUSH [tag] 609
*)
Compute pair "BottleCastle_run_code_of_0_block_676_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x27a%positive);PUSH 2 (posToWord WLen 0x261%positive)] [PUSH 2 (posToWord WLen 0x27a%positive);PUSH 2 (posToWord WLen 0x261%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 635 DUP6 DUP3 DUP7 ADD PUSH [tag] 576
 O: PUSH 0 PUSH [tag] 635 DUP6 DUP6 DUP4 ADD PUSH [tag] 576
*)
Compute pair "BottleCastle_run_code_of_0_block_678_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x27b%positive);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x27b%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] 4 optimize_id).

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 636 DUP6 DUP3 DUP7 ADD PUSH [tag] 580
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 636 DUP6 DUP6 DUP4 ADD PUSH [tag] 580
*)
Compute pair "BottleCastle_run_code_of_0_block_679_0"%string (equiv_checker [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x27c%positive);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x244%positive)] [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x27c%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (posToWord WLen 0x244%positive)] 6 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_680_0"%string (equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 638
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 638
*)
Compute pair "BottleCastle_run_code_of_0_block_681_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x27e%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x27e%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 639 PUSH [tag] 609
 O: PUSH [tag] 639 PUSH [tag] 609
*)
Compute pair "BottleCastle_run_code_of_0_block_682_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x27f%positive);PUSH 2 (posToWord WLen 0x261%positive)] [PUSH 2 (posToWord WLen 0x27f%positive);PUSH 2 (posToWord WLen 0x261%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 640 DUP6 DUP3 DUP7 ADD PUSH [tag] 576
 O: PUSH 0 PUSH [tag] 640 DUP6 DUP6 DUP4 ADD PUSH [tag] 576
*)
Compute pair "BottleCastle_run_code_of_0_block_684_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x280%positive);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x280%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] 4 optimize_id).

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 641 DUP6 DUP3 DUP7 ADD PUSH [tag] 602
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 641 DUP6 DUP6 DUP4 ADD PUSH [tag] 602
*)
Compute pair "BottleCastle_run_code_of_0_block_685_0"%string (equiv_checker [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x281%positive);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x25a%positive)] [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x281%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (posToWord WLen 0x25a%positive)] 6 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_686_0"%string (equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 643
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 643
*)
Compute pair "BottleCastle_run_code_of_0_block_687_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x283%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x283%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 644 PUSH [tag] 609
 O: PUSH [tag] 644 PUSH [tag] 609
*)
Compute pair "BottleCastle_run_code_of_0_block_688_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x284%positive);PUSH 2 (posToWord WLen 0x261%positive)] [PUSH 2 (posToWord WLen 0x284%positive);PUSH 2 (posToWord WLen 0x261%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 645 DUP5 DUP3 DUP6 ADD PUSH [tag] 580
 O: PUSH 0 PUSH [tag] 645 DUP5 DUP5 DUP4 ADD PUSH [tag] 580
*)
Compute pair "BottleCastle_run_code_of_0_block_690_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x285%positive);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x244%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x285%positive);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 2 (posToWord WLen 0x244%positive)] 3 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_691_0"%string (equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 647
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 647
*)
Compute pair "BottleCastle_run_code_of_0_block_692_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x287%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x287%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 648 PUSH [tag] 609
 O: PUSH [tag] 648 PUSH [tag] 609
*)
Compute pair "BottleCastle_run_code_of_0_block_693_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x288%positive);PUSH 2 (posToWord WLen 0x261%positive)] [PUSH 2 (posToWord WLen 0x288%positive);PUSH 2 (posToWord WLen 0x261%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 649 DUP5 DUP3 DUP6 ADD PUSH [tag] 584
 O: PUSH 0 PUSH [tag] 649 DUP5 DUP5 DUP4 ADD PUSH [tag] 584
*)
Compute pair "BottleCastle_run_code_of_0_block_695_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x289%positive);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x248%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x289%positive);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 2 (posToWord WLen 0x248%positive)] 3 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_696_0"%string (equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 651
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 651
*)
Compute pair "BottleCastle_run_code_of_0_block_697_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x28b%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x28b%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 652 PUSH [tag] 609
 O: PUSH [tag] 652 PUSH [tag] 609
*)
Compute pair "BottleCastle_run_code_of_0_block_698_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x28c%positive);PUSH 2 (posToWord WLen 0x261%positive)] [PUSH 2 (posToWord WLen 0x28c%positive);PUSH 2 (posToWord WLen 0x261%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 653 DUP5 DUP3 DUP6 ADD PUSH [tag] 588
 O: PUSH 0 PUSH [tag] 653 DUP5 DUP5 DUP4 ADD PUSH [tag] 588
*)
Compute pair "BottleCastle_run_code_of_0_block_700_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x28d%positive);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x24c%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x28d%positive);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 2 (posToWord WLen 0x24c%positive)] 3 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_701_0"%string (equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 655
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 655
*)
Compute pair "BottleCastle_run_code_of_0_block_702_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x28f%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x28f%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 656 PUSH [tag] 609
 O: PUSH [tag] 656 PUSH [tag] 609
*)
Compute pair "BottleCastle_run_code_of_0_block_703_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x290%positive);PUSH 2 (posToWord WLen 0x261%positive)] [PUSH 2 (posToWord WLen 0x290%positive);PUSH 2 (posToWord WLen 0x261%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP3 ADD CALLDATALOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 657
 O: DUP2 PUSH 0 ADD CALLDATALOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 657
*)
Compute pair "BottleCastle_run_code_of_0_block_705_0"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;Opcode CALLDATALOAD;PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x291%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;Opcode ADD;Opcode CALLDATALOAD;PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x291%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 658 PUSH [tag] 630
 O: PUSH [tag] 658 PUSH [tag] 630
*)
Compute pair "BottleCastle_run_code_of_0_block_706_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x292%positive);PUSH 2 (posToWord WLen 0x276%positive)] [PUSH 2 (posToWord WLen 0x292%positive);PUSH 2 (posToWord WLen 0x276%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 659 DUP5 DUP3 DUP6 ADD PUSH [tag] 597
 O: PUSH [tag] 659 DUP5 DUP5 DUP4 ADD PUSH [tag] 597
*)
Compute pair "BottleCastle_run_code_of_0_block_708_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x293%positive);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x255%positive)] [PUSH 2 (posToWord WLen 0x293%positive);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 2 (posToWord WLen 0x255%positive)] 4 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_709_0"%string (equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 661
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 661
*)
Compute pair "BottleCastle_run_code_of_0_block_710_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x295%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x295%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 662 PUSH [tag] 609
 O: PUSH [tag] 662 PUSH [tag] 609
*)
Compute pair "BottleCastle_run_code_of_0_block_711_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x296%positive);PUSH 2 (posToWord WLen 0x261%positive)] [PUSH 2 (posToWord WLen 0x296%positive);PUSH 2 (posToWord WLen 0x261%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 663 DUP5 DUP3 DUP6 ADD PUSH [tag] 602
 O: PUSH 0 PUSH [tag] 663 DUP5 DUP5 DUP4 ADD PUSH [tag] 602
*)
Compute pair "BottleCastle_run_code_of_0_block_713_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x297%positive);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x25a%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x297%positive);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 2 (posToWord WLen 0x25a%positive)] 3 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_714_0"%string (equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 665
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 665
*)
Compute pair "BottleCastle_run_code_of_0_block_715_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x299%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x299%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 666 PUSH [tag] 609
 O: PUSH [tag] 666 PUSH [tag] 609
*)
Compute pair "BottleCastle_run_code_of_0_block_716_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x29a%positive);PUSH 2 (posToWord WLen 0x261%positive)] [PUSH 2 (posToWord WLen 0x29a%positive);PUSH 2 (posToWord WLen 0x261%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 667 DUP6 DUP3 DUP7 ADD PUSH [tag] 602
 O: PUSH 0 PUSH [tag] 667 DUP6 DUP6 DUP4 ADD PUSH [tag] 602
*)
Compute pair "BottleCastle_run_code_of_0_block_718_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x29b%positive);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x25a%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x29b%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (posToWord WLen 0x25a%positive)] 4 optimize_id).

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 668 DUP6 DUP3 DUP7 ADD PUSH [tag] 576
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 668 DUP6 DUP6 DUP4 ADD PUSH [tag] 576
*)
Compute pair "BottleCastle_run_code_of_0_block_719_0"%string (equiv_checker [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x29c%positive);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x29c%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (posToWord WLen 0x240%positive)] 6 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_720_0"%string (equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 671 DUP4 DUP4 PUSH [tag] 672
 O: PUSH 0 PUSH [tag] 671 DUP4 DUP4 PUSH [tag] 672
*)
Compute pair "BottleCastle_run_code_of_0_block_721_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x29f%positive);DUP 4;DUP 4;PUSH 2 (posToWord WLen 0x2a0%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x29f%positive);DUP 4;DUP 4;PUSH 2 (posToWord WLen 0x2a0%positive)] 2 optimize_id).

(*
 I: PUSH 20 DUP4 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP POP PUSH 20 ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_722_0"%string (equiv_checker [POP;POP;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);DUP 4;Opcode ADD;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH [tag] 675 DUP2 PUSH [tag] 676
 O: PUSH [tag] 675 DUP2 PUSH [tag] 676
*)
Compute pair "BottleCastle_run_code_of_0_block_723_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x2a3%positive);DUP 2;PUSH 2 (posToWord WLen 0x2a4%positive)] [PUSH 2 (posToWord WLen 0x2a3%positive);DUP 2;PUSH 2 (posToWord WLen 0x2a4%positive)] 1 optimize_id).

(*
 I: DUP3
 O: DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_724_0"%string (equiv_checker [DUP 3] [DUP 3] 3 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_724_1"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 679 DUP3 PUSH [tag] 680
 O: PUSH 0 PUSH [tag] 679 DUP3 PUSH [tag] 680
*)
Compute pair "BottleCastle_run_code_of_0_block_725_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2a7%positive);DUP 3;PUSH 2 (posToWord WLen 0x2a8%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2a7%positive);DUP 3;PUSH 2 (posToWord WLen 0x2a8%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 681 DUP2 DUP6 PUSH [tag] 682
 O: PUSH [tag] 681 DUP2 DUP6 PUSH [tag] 682
*)
Compute pair "BottleCastle_run_code_of_0_block_726_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x2a9%positive);DUP 2;DUP 6;PUSH 2 (posToWord WLen 0x2aa%positive)] [PUSH 2 (posToWord WLen 0x2a9%positive);DUP 2;DUP 6;PUSH 2 (posToWord WLen 0x2aa%positive)] 4 optimize_id).

(*
 I: SWAP4 POP PUSH [tag] 683 DUP4 PUSH [tag] 684
 O: SWAP4 POP PUSH [tag] 683 DUP4 PUSH [tag] 684
*)
Compute pair "BottleCastle_run_code_of_0_block_727_0"%string (equiv_checker [DUP 4;POP;PUSH 2 (posToWord WLen 0x2ab%positive);DUP 4;PUSH 2 (posToWord WLen 0x2ac%positive)] [DUP 4;POP;PUSH 2 (posToWord WLen 0x2ab%positive);DUP 4;PUSH 2 (posToWord WLen 0x2ac%positive)] 5 optimize_id).

(*
 I: DUP1 PUSH 0
 O: DUP1 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_728_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] 1 optimize_id).

(*
 I: DUP4 DUP2 LT ISZERO PUSH [tag] 687
 O: DUP4 DUP2 LT ISZERO PUSH [tag] 687
*)
Compute pair "BottleCastle_run_code_of_0_block_729_0"%string (equiv_checker [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x2af%positive)] [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x2af%positive)] 4 optimize_id).

(*
 I: DUP2 MLOAD PUSH [tag] 688 DUP9 DUP3 PUSH [tag] 669
 O: DUP2 MLOAD PUSH [tag] 688 DUP9 DUP3 PUSH [tag] 669
*)
Compute pair "BottleCastle_run_code_of_0_block_730_0"%string (equiv_checker [DUP 2;Opcode MLOAD;PUSH 2 (posToWord WLen 0x2b0%positive);DUP 9;DUP 3;PUSH 2 (posToWord WLen 0x29d%positive)] [DUP 2;Opcode MLOAD;PUSH 2 (posToWord WLen 0x2b0%positive);DUP 9;DUP 3;PUSH 2 (posToWord WLen 0x29d%positive)] 7 optimize_id).

(*
 I: SWAP8 POP PUSH [tag] 689 DUP4 PUSH [tag] 690
 O: SWAP8 POP PUSH [tag] 689 DUP4 PUSH [tag] 690
*)
Compute pair "BottleCastle_run_code_of_0_block_731_0"%string (equiv_checker [DUP 8;POP;PUSH 2 (posToWord WLen 0x2b1%positive);DUP 4;PUSH 2 (posToWord WLen 0x2b2%positive)] [DUP 8;POP;PUSH 2 (posToWord WLen 0x2b1%positive);DUP 4;PUSH 2 (posToWord WLen 0x2b2%positive)] 9 optimize_id).

(*
 I: SWAP3 POP POP PUSH 1 DUP2 ADD SWAP1 POP PUSH [tag] 685
 O: SWAP3 POP POP PUSH 1 ADD PUSH [tag] 685
*)
Compute pair "BottleCastle_run_code_of_0_block_732_0"%string (equiv_checker [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x2ad%positive)] [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x1%positive);DUP 2;Opcode ADD;DUP 1;POP;PUSH 2 (posToWord WLen 0x2ad%positive)] 4 optimize_id).

(*
 I: POP DUP6 SWAP4 POP POP POP POP SWAP3 SWAP2 POP POP
 O: POP POP POP POP POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_733_0"%string (equiv_checker [POP;POP;POP;POP;POP;POP;DUP 1] [POP;DUP 6;DUP 4;POP;POP;POP;POP;DUP 3;DUP 2;POP;POP] 8 optimize_id).

(*
 I: PUSH [tag] 693 DUP2 PUSH [tag] 694
 O: PUSH [tag] 693 DUP2 PUSH [tag] 694
*)
Compute pair "BottleCastle_run_code_of_0_block_734_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x2b5%positive);DUP 2;PUSH 2 (posToWord WLen 0x2b6%positive)] [PUSH 2 (posToWord WLen 0x2b5%positive);DUP 2;PUSH 2 (posToWord WLen 0x2b6%positive)] 1 optimize_id).

(*
 I: DUP3
 O: DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_735_0"%string (equiv_checker [DUP 3] [DUP 3] 3 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_735_1"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 697 DUP3 PUSH [tag] 698
 O: PUSH 0 PUSH [tag] 697 DUP3 PUSH [tag] 698
*)
Compute pair "BottleCastle_run_code_of_0_block_736_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2b9%positive);DUP 3;PUSH 2 (posToWord WLen 0x2ba%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2b9%positive);DUP 3;PUSH 2 (posToWord WLen 0x2ba%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 699 DUP2 DUP6 PUSH [tag] 700
 O: PUSH [tag] 699 DUP2 DUP6 PUSH [tag] 700
*)
Compute pair "BottleCastle_run_code_of_0_block_737_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x2bb%positive);DUP 2;DUP 6;PUSH 2 (posToWord WLen 0x2bc%positive)] [PUSH 2 (posToWord WLen 0x2bb%positive);DUP 2;DUP 6;PUSH 2 (posToWord WLen 0x2bc%positive)] 4 optimize_id).

(*
 I: SWAP4 POP PUSH [tag] 701 DUP2 DUP6 PUSH 20 DUP7 ADD PUSH [tag] 702
 O: SWAP4 POP PUSH [tag] 701 DUP2 DUP6 DUP6 PUSH 20 ADD PUSH [tag] 702
*)
Compute pair "BottleCastle_run_code_of_0_block_738_0"%string (equiv_checker [DUP 4;POP;PUSH 2 (posToWord WLen 0x2bd%positive);DUP 2;DUP 6;DUP 6;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x2be%positive)] [DUP 4;POP;PUSH 2 (posToWord WLen 0x2bd%positive);DUP 2;DUP 6;PUSH 1 (posToWord WLen 0x20%positive);DUP 7;Opcode ADD;PUSH 2 (posToWord WLen 0x2be%positive)] 5 optimize_id).

(*
 I: PUSH [tag] 703 DUP2 PUSH [tag] 704
 O: PUSH [tag] 703 DUP2 PUSH [tag] 704
*)
Compute pair "BottleCastle_run_code_of_0_block_739_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x2bf%positive);DUP 2;PUSH 2 (posToWord WLen 0x2c0%positive)] [PUSH 2 (posToWord WLen 0x2bf%positive);DUP 2;PUSH 2 (posToWord WLen 0x2c0%positive)] 1 optimize_id).

(*
 I: DUP5 ADD SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP3 POP POP POP ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_740_0"%string (equiv_checker [DUP 3;POP;POP;POP;Opcode ADD;DUP 1] [DUP 5;Opcode ADD;DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 707 DUP3 PUSH [tag] 708
 O: PUSH 0 PUSH [tag] 707 DUP3 PUSH [tag] 708
*)
Compute pair "BottleCastle_run_code_of_0_block_741_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2c3%positive);DUP 3;PUSH 2 (posToWord WLen 0x2c4%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2c3%positive);DUP 3;PUSH 2 (posToWord WLen 0x2c4%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 709 DUP2 DUP6 PUSH [tag] 710
 O: PUSH [tag] 709 DUP2 DUP6 PUSH [tag] 710
*)
Compute pair "BottleCastle_run_code_of_0_block_742_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x2c5%positive);DUP 2;DUP 6;PUSH 2 (posToWord WLen 0x2c6%positive)] [PUSH 2 (posToWord WLen 0x2c5%positive);DUP 2;DUP 6;PUSH 2 (posToWord WLen 0x2c6%positive)] 4 optimize_id).

(*
 I: SWAP4 POP PUSH [tag] 711 DUP2 DUP6 PUSH 20 DUP7 ADD PUSH [tag] 702
 O: SWAP4 POP PUSH [tag] 711 DUP2 DUP6 DUP6 PUSH 20 ADD PUSH [tag] 702
*)
Compute pair "BottleCastle_run_code_of_0_block_743_0"%string (equiv_checker [DUP 4;POP;PUSH 2 (posToWord WLen 0x2c7%positive);DUP 2;DUP 6;DUP 6;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x2be%positive)] [DUP 4;POP;PUSH 2 (posToWord WLen 0x2c7%positive);DUP 2;DUP 6;PUSH 1 (posToWord WLen 0x20%positive);DUP 7;Opcode ADD;PUSH 2 (posToWord WLen 0x2be%positive)] 5 optimize_id).

(*
 I: PUSH [tag] 712 DUP2 PUSH [tag] 704
 O: PUSH [tag] 712 DUP2 PUSH [tag] 704
*)
Compute pair "BottleCastle_run_code_of_0_block_744_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x2c8%positive);DUP 2;PUSH 2 (posToWord WLen 0x2c0%positive)] [PUSH 2 (posToWord WLen 0x2c8%positive);DUP 2;PUSH 2 (posToWord WLen 0x2c0%positive)] 1 optimize_id).

(*
 I: DUP5 ADD SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP3 POP POP POP ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_745_0"%string (equiv_checker [DUP 3;POP;POP;POP;Opcode ADD;DUP 1] [DUP 5;Opcode ADD;DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 715 DUP3 PUSH [tag] 708
 O: PUSH 0 PUSH [tag] 715 DUP3 PUSH [tag] 708
*)
Compute pair "BottleCastle_run_code_of_0_block_746_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2cb%positive);DUP 3;PUSH 2 (posToWord WLen 0x2c4%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2cb%positive);DUP 3;PUSH 2 (posToWord WLen 0x2c4%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 716 DUP2 DUP6 PUSH [tag] 717
 O: PUSH [tag] 716 DUP2 DUP6 PUSH [tag] 717
*)
Compute pair "BottleCastle_run_code_of_0_block_747_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x2cc%positive);DUP 2;DUP 6;PUSH 2 (posToWord WLen 0x2cd%positive)] [PUSH 2 (posToWord WLen 0x2cc%positive);DUP 2;DUP 6;PUSH 2 (posToWord WLen 0x2cd%positive)] 4 optimize_id).

(*
 I: SWAP4 POP PUSH [tag] 718 DUP2 DUP6 PUSH 20 DUP7 ADD PUSH [tag] 702
 O: SWAP4 POP PUSH [tag] 718 DUP2 DUP6 DUP6 PUSH 20 ADD PUSH [tag] 702
*)
Compute pair "BottleCastle_run_code_of_0_block_748_0"%string (equiv_checker [DUP 4;POP;PUSH 2 (posToWord WLen 0x2ce%positive);DUP 2;DUP 6;DUP 6;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x2be%positive)] [DUP 4;POP;PUSH 2 (posToWord WLen 0x2ce%positive);DUP 2;DUP 6;PUSH 1 (posToWord WLen 0x20%positive);DUP 7;Opcode ADD;PUSH 2 (posToWord WLen 0x2be%positive)] 5 optimize_id).

(*
 I: DUP1 DUP5 ADD SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP2 POP POP ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_749_0"%string (equiv_checker [DUP 2;POP;POP;Opcode ADD;DUP 1] [DUP 1;DUP 5;Opcode ADD;DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 5 optimize_id).

(*
 I: PUSH 0 DUP2 SLOAD PUSH [tag] 721 DUP2 PUSH [tag] 223
 O: PUSH 0 DUP2 SLOAD PUSH [tag] 721 DUP2 PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_750_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode SLOAD;PUSH 2 (posToWord WLen 0x2d1%positive);DUP 2;PUSH 1 (posToWord WLen 0xdf%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode SLOAD;PUSH 2 (posToWord WLen 0x2d1%positive);DUP 2;PUSH 1 (posToWord WLen 0xdf%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 722 DUP2 DUP7 PUSH [tag] 717
 O: PUSH [tag] 722 DUP2 DUP7 PUSH [tag] 717
*)
Compute pair "BottleCastle_run_code_of_0_block_751_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x2d2%positive);DUP 2;DUP 7;PUSH 2 (posToWord WLen 0x2cd%positive)] [PUSH 2 (posToWord WLen 0x2d2%positive);DUP 2;DUP 7;PUSH 2 (posToWord WLen 0x2cd%positive)] 5 optimize_id).

(*
 I: SWAP5 POP PUSH 1 DUP3 AND PUSH 0 DUP2 EQ PUSH [tag] 724
 O: SWAP5 POP DUP2 PUSH 1 AND PUSH 0 DUP2 EQ PUSH [tag] 724
*)
Compute pair "BottleCastle_run_code_of_0_block_752_0"%string (equiv_checker [DUP 5;POP;DUP 2;PUSH 1 (posToWord WLen 0x1%positive);Opcode AND;PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x2d4%positive)] [DUP 5;POP;PUSH 1 (posToWord WLen 0x1%positive);DUP 3;Opcode AND;PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x2d4%positive)] 6 optimize_id).

(*
 I: PUSH 1 DUP2 EQ PUSH [tag] 725
 O: DUP1 PUSH 1 EQ PUSH [tag] 725
*)
Compute pair "BottleCastle_run_code_of_0_block_753_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode EQ;PUSH 2 (posToWord WLen 0x2d5%positive)] [PUSH 1 (posToWord WLen 0x1%positive);DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x2d5%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 723
 O: PUSH [tag] 723
*)
Compute pair "BottleCastle_run_code_of_0_block_754_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x2d3%positive)] [PUSH 2 (posToWord WLen 0x2d3%positive)] 0 optimize_id).

(*
 I: PUSH FF NOT DUP4 AND DUP7
 O: PUSH ff NOT DUP4 AND DUP7
*)
Compute pair "BottleCastle_run_code_of_0_block_755_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xff%positive);Opcode NOT;DUP 4;Opcode AND;DUP 7] [PUSH 1 (posToWord WLen 0xFF%positive);Opcode NOT;DUP 4;Opcode AND;DUP 7] 6 optimize_id).

(*
 I: DUP2 DUP7 ADD SWAP4 POP PUSH [tag] 723
 O: DUP2 DUP7 ADD SWAP4 POP PUSH [tag] 723
*)
Compute pair "BottleCastle_run_code_of_0_block_755_1"%string (equiv_checker [DUP 2;DUP 7;Opcode ADD;DUP 4;POP;PUSH 2 (posToWord WLen 0x2d3%positive)] [DUP 2;DUP 7;Opcode ADD;DUP 4;POP;PUSH 2 (posToWord WLen 0x2d3%positive)] 6 optimize_id).

(*
 I: PUSH [tag] 726 DUP6 PUSH [tag] 727
 O: PUSH [tag] 726 DUP6 PUSH [tag] 727
*)
Compute pair "BottleCastle_run_code_of_0_block_756_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x2d6%positive);DUP 6;PUSH 2 (posToWord WLen 0x2d7%positive)] [PUSH 2 (posToWord WLen 0x2d6%positive);DUP 6;PUSH 2 (posToWord WLen 0x2d7%positive)] 5 optimize_id).

(*
 I: PUSH 0
 O: PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_757_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: DUP4 DUP2 LT ISZERO PUSH [tag] 730
 O: DUP4 DUP2 LT ISZERO PUSH [tag] 730
*)
Compute pair "BottleCastle_run_code_of_0_block_758_0"%string (equiv_checker [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x2da%positive)] [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x2da%positive)] 4 optimize_id).

(*
 I: DUP2 SLOAD DUP2 DUP10 ADD
 O: DUP2 SLOAD DUP9 DUP3 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_759_0"%string (equiv_checker [DUP 2;Opcode SLOAD;DUP 9;DUP 3;Opcode ADD] [DUP 2;Opcode SLOAD;DUP 2;DUP 10;Opcode ADD] 8 optimize_id).

(*
 I: PUSH 1 DUP3 ADD SWAP2 POP PUSH 20 DUP2 ADD SWAP1 POP PUSH [tag] 728
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD PUSH [tag] 728
*)
Compute pair "BottleCastle_run_code_of_0_block_759_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x2d8%positive)] [PUSH 1 (posToWord WLen 0x1%positive);DUP 3;Opcode ADD;DUP 2;POP;PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;DUP 1;POP;PUSH 2 (posToWord WLen 0x2d8%positive)] 2 optimize_id).

(*
 I: DUP4 DUP9 ADD SWAP6 POP POP POP
 O: POP DUP7 DUP4 ADD SWAP5 POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_760_0"%string (equiv_checker [POP;DUP 7;DUP 4;Opcode ADD;DUP 5;POP;POP] [DUP 4;DUP 9;Opcode ADD;DUP 6;POP;POP;POP] 8 optimize_id).

(*
 I: POP POP POP SWAP3 SWAP2 POP POP
 O: POP POP POP SWAP3 SWAP2 POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_761_0"%string (equiv_checker [POP;POP;POP;DUP 3;DUP 2;POP;POP] [POP;POP;POP;DUP 3;DUP 2;POP;POP] 7 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 733 PUSH 30 DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 733 PUSH 30 DUP4 PUSH [tag] 710
*)
Compute pair "BottleCastle_run_code_of_0_block_762_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2dd%positive);PUSH 1 (posToWord WLen 0x30%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2dd%positive);PUSH 1 (posToWord WLen 0x30%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] 1 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 734 DUP3 PUSH [tag] 735
 O: SWAP2 POP PUSH [tag] 734 DUP3 PUSH [tag] 735
*)
Compute pair "BottleCastle_run_code_of_0_block_763_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x2de%positive);DUP 3;PUSH 2 (posToWord WLen 0x2df%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x2de%positive);DUP 3;PUSH 2 (posToWord WLen 0x2df%positive)] 3 optimize_id).

(*
 I: PUSH 40 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 40 ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_764_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x40%positive);Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 738 PUSH 26 DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 738 PUSH 26 DUP4 PUSH [tag] 710
*)
Compute pair "BottleCastle_run_code_of_0_block_765_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2e2%positive);PUSH 1 (posToWord WLen 0x26%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2e2%positive);PUSH 1 (posToWord WLen 0x26%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] 1 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 739 DUP3 PUSH [tag] 740
 O: SWAP2 POP PUSH [tag] 739 DUP3 PUSH [tag] 740
*)
Compute pair "BottleCastle_run_code_of_0_block_766_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x2e3%positive);DUP 3;PUSH 2 (posToWord WLen 0x2e4%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x2e3%positive);DUP 3;PUSH 2 (posToWord WLen 0x2e4%positive)] 3 optimize_id).

(*
 I: PUSH 40 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 40 ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_767_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x40%positive);Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 743 PUSH A DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 743 PUSH a DUP4 PUSH [tag] 710
*)
Compute pair "BottleCastle_run_code_of_0_block_768_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2e7%positive);PUSH 1 (posToWord WLen 0xa%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2e7%positive);PUSH 1 (posToWord WLen 0xA%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] 1 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 744 DUP3 PUSH [tag] 745
 O: SWAP2 POP PUSH [tag] 744 DUP3 PUSH [tag] 745
*)
Compute pair "BottleCastle_run_code_of_0_block_769_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x2e8%positive);DUP 3;PUSH 2 (posToWord WLen 0x2e9%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x2e8%positive);DUP 3;PUSH 2 (posToWord WLen 0x2e9%positive)] 3 optimize_id).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_770_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 748 PUSH 17 DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 748 PUSH 17 DUP4 PUSH [tag] 710
*)
Compute pair "BottleCastle_run_code_of_0_block_771_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2ec%positive);PUSH 1 (posToWord WLen 0x17%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2ec%positive);PUSH 1 (posToWord WLen 0x17%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] 1 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 749 DUP3 PUSH [tag] 750
 O: SWAP2 POP PUSH [tag] 749 DUP3 PUSH [tag] 750
*)
Compute pair "BottleCastle_run_code_of_0_block_772_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x2ed%positive);DUP 3;PUSH 2 (posToWord WLen 0x2ee%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x2ed%positive);DUP 3;PUSH 2 (posToWord WLen 0x2ee%positive)] 3 optimize_id).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_773_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 753 PUSH 16 DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 753 PUSH 16 DUP4 PUSH [tag] 710
*)
Compute pair "BottleCastle_run_code_of_0_block_774_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2f1%positive);PUSH 1 (posToWord WLen 0x16%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2f1%positive);PUSH 1 (posToWord WLen 0x16%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] 1 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 754 DUP3 PUSH [tag] 755
 O: SWAP2 POP PUSH [tag] 754 DUP3 PUSH [tag] 755
*)
Compute pair "BottleCastle_run_code_of_0_block_775_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x2f2%positive);DUP 3;PUSH 2 (posToWord WLen 0x2f3%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x2f2%positive);DUP 3;PUSH 2 (posToWord WLen 0x2f3%positive)] 3 optimize_id).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_776_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 758 PUSH 20 DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 758 PUSH 20 DUP4 PUSH [tag] 710
*)
Compute pair "BottleCastle_run_code_of_0_block_777_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2f6%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2f6%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] 1 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 759 DUP3 PUSH [tag] 760
 O: SWAP2 POP PUSH [tag] 759 DUP3 PUSH [tag] 760
*)
Compute pair "BottleCastle_run_code_of_0_block_778_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x2f7%positive);DUP 3;PUSH 2 (posToWord WLen 0x2f8%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x2f7%positive);DUP 3;PUSH 2 (posToWord WLen 0x2f8%positive)] 3 optimize_id).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_779_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 763 PUSH 12 DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 763 PUSH 12 DUP4 PUSH [tag] 710
*)
Compute pair "BottleCastle_run_code_of_0_block_780_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2fb%positive);PUSH 1 (posToWord WLen 0x12%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x2fb%positive);PUSH 1 (posToWord WLen 0x12%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] 1 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 764 DUP3 PUSH [tag] 765
 O: SWAP2 POP PUSH [tag] 764 DUP3 PUSH [tag] 765
*)
Compute pair "BottleCastle_run_code_of_0_block_781_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x2fc%positive);DUP 3;PUSH 2 (posToWord WLen 0x2fd%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x2fc%positive);DUP 3;PUSH 2 (posToWord WLen 0x2fd%positive)] 3 optimize_id).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_782_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 768 PUSH 1B DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 768 PUSH 1b DUP4 PUSH [tag] 710
*)
Compute pair "BottleCastle_run_code_of_0_block_783_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x300%positive);PUSH 1 (posToWord WLen 0x1b%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x300%positive);PUSH 1 (posToWord WLen 0x1B%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] 1 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 769 DUP3 PUSH [tag] 770
 O: SWAP2 POP PUSH [tag] 769 DUP3 PUSH [tag] 770
*)
Compute pair "BottleCastle_run_code_of_0_block_784_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x301%positive);DUP 3;PUSH 2 (posToWord WLen 0x302%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x301%positive);DUP 3;PUSH 2 (posToWord WLen 0x302%positive)] 3 optimize_id).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_785_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 773 PUSH 1F DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 773 PUSH 1f DUP4 PUSH [tag] 710
*)
Compute pair "BottleCastle_run_code_of_0_block_786_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x305%positive);PUSH 1 (posToWord WLen 0x1f%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x305%positive);PUSH 1 (posToWord WLen 0x1F%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] 1 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 774 DUP3 PUSH [tag] 775
 O: SWAP2 POP PUSH [tag] 774 DUP3 PUSH [tag] 775
*)
Compute pair "BottleCastle_run_code_of_0_block_787_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x306%positive);DUP 3;PUSH 2 (posToWord WLen 0x307%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x306%positive);DUP 3;PUSH 2 (posToWord WLen 0x307%positive)] 3 optimize_id).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_788_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 778 PUSH 1F DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 778 PUSH 1f DUP4 PUSH [tag] 710
*)
Compute pair "BottleCastle_run_code_of_0_block_789_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x30a%positive);PUSH 1 (posToWord WLen 0x1f%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x30a%positive);PUSH 1 (posToWord WLen 0x1F%positive);DUP 4;PUSH 2 (posToWord WLen 0x2c6%positive)] 1 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 779 DUP3 PUSH [tag] 780
 O: SWAP2 POP PUSH [tag] 779 DUP3 PUSH [tag] 780
*)
Compute pair "BottleCastle_run_code_of_0_block_790_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x30b%positive);DUP 3;PUSH 2 (posToWord WLen 0x30c%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x30b%positive);DUP 3;PUSH 2 (posToWord WLen 0x30c%positive)] 3 optimize_id).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_791_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH [tag] 782 DUP2 PUSH [tag] 783
 O: PUSH [tag] 782 DUP2 PUSH [tag] 783
*)
Compute pair "BottleCastle_run_code_of_0_block_792_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x30e%positive);DUP 2;PUSH 2 (posToWord WLen 0x30f%positive)] [PUSH 2 (posToWord WLen 0x30e%positive);DUP 2;PUSH 2 (posToWord WLen 0x30f%positive)] 1 optimize_id).

(*
 I: DUP3
 O: DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_793_0"%string (equiv_checker [DUP 3] [DUP 3] 3 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_793_1"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH [tag] 786 DUP2 PUSH [tag] 783
 O: PUSH [tag] 786 DUP2 PUSH [tag] 783
*)
Compute pair "BottleCastle_run_code_of_0_block_794_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x312%positive);DUP 2;PUSH 2 (posToWord WLen 0x30f%positive)] [PUSH 2 (posToWord WLen 0x312%positive);DUP 2;PUSH 2 (posToWord WLen 0x30f%positive)] 1 optimize_id).

(*
 I: DUP3
 O: DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_795_0"%string (equiv_checker [DUP 3] [DUP 3] 3 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_795_1"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 788 DUP3 DUP7 PUSH [tag] 713
 O: PUSH 0 PUSH [tag] 788 DUP3 DUP7 PUSH [tag] 713
*)
Compute pair "BottleCastle_run_code_of_0_block_796_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x314%positive);DUP 3;DUP 7;PUSH 2 (posToWord WLen 0x2c9%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x314%positive);DUP 3;DUP 7;PUSH 2 (posToWord WLen 0x2c9%positive)] 4 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 789 DUP3 DUP6 PUSH [tag] 713
 O: SWAP2 POP PUSH [tag] 789 DUP3 DUP6 PUSH [tag] 713
*)
Compute pair "BottleCastle_run_code_of_0_block_797_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x315%positive);DUP 3;DUP 6;PUSH 2 (posToWord WLen 0x2c9%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x315%positive);DUP 3;DUP 6;PUSH 2 (posToWord WLen 0x2c9%positive)] 5 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 790 DUP3 DUP5 PUSH [tag] 719
 O: SWAP2 POP PUSH [tag] 790 DUP3 DUP5 PUSH [tag] 719
*)
Compute pair "BottleCastle_run_code_of_0_block_798_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x316%positive);DUP 3;DUP 5;PUSH 2 (posToWord WLen 0x2cf%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x316%positive);DUP 3;DUP 5;PUSH 2 (posToWord WLen 0x2cf%positive)] 4 optimize_id).

(*
 I: SWAP2 POP DUP2 SWAP1 POP SWAP5 SWAP4 POP POP POP POP
 O: SWAP5 POP POP POP POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_799_0"%string (equiv_checker [DUP 5;POP;POP;POP;POP;POP;DUP 1] [DUP 2;POP;DUP 2;DUP 1;POP;DUP 5;DUP 4;POP;POP;POP;POP] 7 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP PUSH [tag] 792 PUSH 0 DUP4 ADD DUP5 PUSH [tag] 673
 O: PUSH 20 DUP2 ADD PUSH [tag] 792 DUP3 PUSH 0 ADD DUP5 PUSH [tag] 673
*)
Compute pair "BottleCastle_run_code_of_0_block_800_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;PUSH 2 (posToWord WLen 0x318%positive);DUP 3;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;DUP 5;PUSH 2 (posToWord WLen 0x2a1%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;PUSH 2 (posToWord WLen 0x318%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD;DUP 5;PUSH 2 (posToWord WLen 0x2a1%positive)] 2 optimize_id).

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_801_0"%string (equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 80 DUP3 ADD SWAP1 POP PUSH [tag] 794 PUSH 0 DUP4 ADD DUP8 PUSH [tag] 673
 O: PUSH 80 DUP2 ADD PUSH [tag] 794 DUP3 PUSH 0 ADD DUP8 PUSH [tag] 673
*)
Compute pair "BottleCastle_run_code_of_0_block_802_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x80%positive);DUP 2;Opcode ADD;PUSH 2 (posToWord WLen 0x31a%positive);DUP 3;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;DUP 8;PUSH 2 (posToWord WLen 0x2a1%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x80%positive);DUP 3;Opcode ADD;DUP 1;POP;PUSH 2 (posToWord WLen 0x31a%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD;DUP 8;PUSH 2 (posToWord WLen 0x2a1%positive)] 5 optimize_id).

(*
 I: PUSH [tag] 795 PUSH 20 DUP4 ADD DUP7 PUSH [tag] 673
 O: PUSH [tag] 795 DUP3 PUSH 20 ADD DUP7 PUSH [tag] 673
*)
Compute pair "BottleCastle_run_code_of_0_block_803_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x31b%positive);DUP 3;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 7;PUSH 2 (posToWord WLen 0x2a1%positive)] [PUSH 2 (posToWord WLen 0x31b%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 4;Opcode ADD;DUP 7;PUSH 2 (posToWord WLen 0x2a1%positive)] 5 optimize_id).

(*
 I: PUSH [tag] 796 PUSH 40 DUP4 ADD DUP6 PUSH [tag] 784
 O: PUSH [tag] 796 PUSH 40 DUP4 ADD DUP6 PUSH [tag] 784
*)
Compute pair "BottleCastle_run_code_of_0_block_804_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x31c%positive);PUSH 1 (posToWord WLen 0x40%positive);DUP 4;Opcode ADD;DUP 6;PUSH 2 (posToWord WLen 0x310%positive)] [PUSH 2 (posToWord WLen 0x31c%positive);PUSH 1 (posToWord WLen 0x40%positive);DUP 4;Opcode ADD;DUP 6;PUSH 2 (posToWord WLen 0x310%positive)] 4 optimize_id).

(*
 I: DUP2 DUP2 SUB PUSH 60 DUP4 ADD
 O: DUP2 DUP2 SUB PUSH 60 DUP4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_805_0"%string (equiv_checker [DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x60%positive);DUP 4;Opcode ADD] [DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x60%positive);DUP 4;Opcode ADD] 2 optimize_id).

(*
 I: PUSH [tag] 797 DUP2 DUP5 PUSH [tag] 695
 O: PUSH [tag] 797 DUP2 DUP5 PUSH [tag] 695
*)
Compute pair "BottleCastle_run_code_of_0_block_805_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x31d%positive);DUP 2;DUP 5;PUSH 2 (posToWord WLen 0x2b7%positive)] [PUSH 2 (posToWord WLen 0x31d%positive);DUP 2;DUP 5;PUSH 2 (posToWord WLen 0x2b7%positive)] 3 optimize_id).

(*
 I: SWAP1 POP SWAP6 SWAP5 POP POP POP POP POP
 O: SWAP7 SWAP6 POP POP POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_806_0"%string (equiv_checker [DUP 7;DUP 6;POP;POP;POP;POP;POP;POP] [DUP 1;POP;DUP 6;DUP 5;POP;POP;POP;POP;POP] 8 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_807_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] 1 optimize_id).

(*
 I: PUSH [tag] 799 DUP2 DUP5 PUSH [tag] 677
 O: PUSH [tag] 799 DUP2 DUP5 PUSH [tag] 677
*)
Compute pair "BottleCastle_run_code_of_0_block_807_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x31f%positive);DUP 2;DUP 5;PUSH 2 (posToWord WLen 0x2a5%positive)] [PUSH 2 (posToWord WLen 0x31f%positive);DUP 2;DUP 5;PUSH 2 (posToWord WLen 0x2a5%positive)] 3 optimize_id).

(*
 I: SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP4 SWAP3 POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_808_0"%string (equiv_checker [DUP 4;DUP 3;POP;POP;POP] [DUP 1;POP;DUP 3;DUP 2;POP;POP] 5 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP PUSH [tag] 801 PUSH 0 DUP4 ADD DUP5 PUSH [tag] 691
 O: PUSH 20 DUP2 ADD PUSH [tag] 801 DUP3 PUSH 0 ADD DUP5 PUSH [tag] 691
*)
Compute pair "BottleCastle_run_code_of_0_block_809_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;PUSH 2 (posToWord WLen 0x321%positive);DUP 3;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;DUP 5;PUSH 2 (posToWord WLen 0x2b3%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;PUSH 2 (posToWord WLen 0x321%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD;DUP 5;PUSH 2 (posToWord WLen 0x2b3%positive)] 2 optimize_id).

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_810_0"%string (equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_811_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] 1 optimize_id).

(*
 I: PUSH [tag] 803 DUP2 DUP5 PUSH [tag] 705
 O: PUSH [tag] 803 DUP2 DUP5 PUSH [tag] 705
*)
Compute pair "BottleCastle_run_code_of_0_block_811_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x323%positive);DUP 2;DUP 5;PUSH 2 (posToWord WLen 0x2c1%positive)] [PUSH 2 (posToWord WLen 0x323%positive);DUP 2;DUP 5;PUSH 2 (posToWord WLen 0x2c1%positive)] 3 optimize_id).

(*
 I: SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP4 SWAP3 POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_812_0"%string (equiv_checker [DUP 4;DUP 3;POP;POP;POP] [DUP 1;POP;DUP 3;DUP 2;POP;POP] 5 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_813_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] 1 optimize_id).

(*
 I: PUSH [tag] 805 DUP2 PUSH [tag] 731
 O: PUSH [tag] 805 DUP2 PUSH [tag] 731
*)
Compute pair "BottleCastle_run_code_of_0_block_813_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x325%positive);DUP 2;PUSH 2 (posToWord WLen 0x2db%positive)] [PUSH 2 (posToWord WLen 0x325%positive);DUP 2;PUSH 2 (posToWord WLen 0x2db%positive)] 1 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_814_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_815_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] 1 optimize_id).

(*
 I: PUSH [tag] 807 DUP2 PUSH [tag] 736
 O: PUSH [tag] 807 DUP2 PUSH [tag] 736
*)
Compute pair "BottleCastle_run_code_of_0_block_815_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x327%positive);DUP 2;PUSH 2 (posToWord WLen 0x2e0%positive)] [PUSH 2 (posToWord WLen 0x327%positive);DUP 2;PUSH 2 (posToWord WLen 0x2e0%positive)] 1 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_816_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_817_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] 1 optimize_id).

(*
 I: PUSH [tag] 809 DUP2 PUSH [tag] 741
 O: PUSH [tag] 809 DUP2 PUSH [tag] 741
*)
Compute pair "BottleCastle_run_code_of_0_block_817_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x329%positive);DUP 2;PUSH 2 (posToWord WLen 0x2e5%positive)] [PUSH 2 (posToWord WLen 0x329%positive);DUP 2;PUSH 2 (posToWord WLen 0x2e5%positive)] 1 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_818_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_819_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] 1 optimize_id).

(*
 I: PUSH [tag] 811 DUP2 PUSH [tag] 746
 O: PUSH [tag] 811 DUP2 PUSH [tag] 746
*)
Compute pair "BottleCastle_run_code_of_0_block_819_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x32b%positive);DUP 2;PUSH 2 (posToWord WLen 0x2ea%positive)] [PUSH 2 (posToWord WLen 0x32b%positive);DUP 2;PUSH 2 (posToWord WLen 0x2ea%positive)] 1 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_820_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_821_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] 1 optimize_id).

(*
 I: PUSH [tag] 813 DUP2 PUSH [tag] 751
 O: PUSH [tag] 813 DUP2 PUSH [tag] 751
*)
Compute pair "BottleCastle_run_code_of_0_block_821_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x32d%positive);DUP 2;PUSH 2 (posToWord WLen 0x2ef%positive)] [PUSH 2 (posToWord WLen 0x32d%positive);DUP 2;PUSH 2 (posToWord WLen 0x2ef%positive)] 1 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_822_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_823_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] 1 optimize_id).

(*
 I: PUSH [tag] 815 DUP2 PUSH [tag] 756
 O: PUSH [tag] 815 DUP2 PUSH [tag] 756
*)
Compute pair "BottleCastle_run_code_of_0_block_823_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x32f%positive);DUP 2;PUSH 2 (posToWord WLen 0x2f4%positive)] [PUSH 2 (posToWord WLen 0x32f%positive);DUP 2;PUSH 2 (posToWord WLen 0x2f4%positive)] 1 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_824_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_825_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] 1 optimize_id).

(*
 I: PUSH [tag] 817 DUP2 PUSH [tag] 761
 O: PUSH [tag] 817 DUP2 PUSH [tag] 761
*)
Compute pair "BottleCastle_run_code_of_0_block_825_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x331%positive);DUP 2;PUSH 2 (posToWord WLen 0x2f9%positive)] [PUSH 2 (posToWord WLen 0x331%positive);DUP 2;PUSH 2 (posToWord WLen 0x2f9%positive)] 1 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_826_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_827_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] 1 optimize_id).

(*
 I: PUSH [tag] 819 DUP2 PUSH [tag] 766
 O: PUSH [tag] 819 DUP2 PUSH [tag] 766
*)
Compute pair "BottleCastle_run_code_of_0_block_827_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x333%positive);DUP 2;PUSH 2 (posToWord WLen 0x2fe%positive)] [PUSH 2 (posToWord WLen 0x333%positive);DUP 2;PUSH 2 (posToWord WLen 0x2fe%positive)] 1 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_828_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_829_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] 1 optimize_id).

(*
 I: PUSH [tag] 821 DUP2 PUSH [tag] 771
 O: PUSH [tag] 821 DUP2 PUSH [tag] 771
*)
Compute pair "BottleCastle_run_code_of_0_block_829_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x335%positive);DUP 2;PUSH 2 (posToWord WLen 0x303%positive)] [PUSH 2 (posToWord WLen 0x335%positive);DUP 2;PUSH 2 (posToWord WLen 0x303%positive)] 1 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_830_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_831_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] 1 optimize_id).

(*
 I: PUSH [tag] 823 DUP2 PUSH [tag] 776
 O: PUSH [tag] 823 DUP2 PUSH [tag] 776
*)
Compute pair "BottleCastle_run_code_of_0_block_831_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x337%positive);DUP 2;PUSH 2 (posToWord WLen 0x308%positive)] [PUSH 2 (posToWord WLen 0x337%positive);DUP 2;PUSH 2 (posToWord WLen 0x308%positive)] 1 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_832_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP PUSH [tag] 825 PUSH 0 DUP4 ADD DUP5 PUSH [tag] 784
 O: PUSH 20 DUP2 ADD PUSH [tag] 825 DUP3 PUSH 0 ADD DUP5 PUSH [tag] 784
*)
Compute pair "BottleCastle_run_code_of_0_block_833_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;PUSH 2 (posToWord WLen 0x339%positive);DUP 3;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;DUP 5;PUSH 2 (posToWord WLen 0x310%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;PUSH 2 (posToWord WLen 0x339%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD;DUP 5;PUSH 2 (posToWord WLen 0x310%positive)] 2 optimize_id).

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_834_0"%string (equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 827 PUSH [tag] 828
 O: PUSH 0 PUSH [tag] 827 PUSH [tag] 828
*)
Compute pair "BottleCastle_run_code_of_0_block_835_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x33b%positive);PUSH 2 (posToWord WLen 0x33c%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x33b%positive);PUSH 2 (posToWord WLen 0x33c%positive)] 0 optimize_id).

(*
 I: SWAP1 POP PUSH [tag] 829 DUP3 DUP3 PUSH [tag] 830
 O: SWAP1 POP PUSH [tag] 829 DUP3 DUP3 PUSH [tag] 830
*)
Compute pair "BottleCastle_run_code_of_0_block_836_0"%string (equiv_checker [DUP 1;POP;PUSH 2 (posToWord WLen 0x33d%positive);DUP 3;DUP 3;PUSH 2 (posToWord WLen 0x33e%positive)] [DUP 1;POP;PUSH 2 (posToWord WLen 0x33d%positive);DUP 3;DUP 3;PUSH 2 (posToWord WLen 0x33e%positive)] 3 optimize_id).

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_837_0"%string (equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH 40 MLOAD SWAP1 POP SWAP1
 O: PUSH 40 MLOAD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_838_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;POP;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFF DUP3 GT ISZERO PUSH [tag] 833
 O: PUSH 0 PUSH ffffffffffffffff DUP3 GT ISZERO PUSH [tag] 833
*)
Compute pair "BottleCastle_run_code_of_0_block_839_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x341%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x341%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 834 PUSH [tag] 312
 O: PUSH [tag] 834 PUSH [tag] 312
*)
Compute pair "BottleCastle_run_code_of_0_block_840_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x342%positive);PUSH 2 (posToWord WLen 0x138%positive)] [PUSH 2 (posToWord WLen 0x342%positive);PUSH 2 (posToWord WLen 0x138%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 835 DUP3 PUSH [tag] 704
 O: PUSH [tag] 835 DUP3 PUSH [tag] 704
*)
Compute pair "BottleCastle_run_code_of_0_block_842_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x343%positive);DUP 3;PUSH 2 (posToWord WLen 0x2c0%positive)] [PUSH 2 (posToWord WLen 0x343%positive);DUP 3;PUSH 2 (posToWord WLen 0x2c0%positive)] 2 optimize_id).

(*
 I: SWAP1 POP PUSH 20 DUP2 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_843_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;POP;POP;DUP 1] [DUP 1;POP;PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFF DUP3 GT ISZERO PUSH [tag] 837
 O: PUSH 0 PUSH ffffffffffffffff DUP3 GT ISZERO PUSH [tag] 837
*)
Compute pair "BottleCastle_run_code_of_0_block_844_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x345%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x345%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 838 PUSH [tag] 312
 O: PUSH [tag] 838 PUSH [tag] 312
*)
Compute pair "BottleCastle_run_code_of_0_block_845_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x346%positive);PUSH 2 (posToWord WLen 0x138%positive)] [PUSH 2 (posToWord WLen 0x346%positive);PUSH 2 (posToWord WLen 0x138%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 839 DUP3 PUSH [tag] 704
 O: PUSH [tag] 839 DUP3 PUSH [tag] 704
*)
Compute pair "BottleCastle_run_code_of_0_block_847_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x347%positive);DUP 3;PUSH 2 (posToWord WLen 0x2c0%positive)] [PUSH 2 (posToWord WLen 0x347%positive);DUP 3;PUSH 2 (posToWord WLen 0x2c0%positive)] 2 optimize_id).

(*
 I: SWAP1 POP PUSH 20 DUP2 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_848_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;POP;POP;DUP 1] [DUP 1;POP;PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP2 SWAP1 POP PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_849_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;DUP 1;POP;PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH 0 DUP2 SWAP1 POP DUP2 PUSH 0
 O: DUP1 DUP2 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_850_0"%string (equiv_checker [DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;DUP 1;POP;DUP 2;PUSH 1 (posToWord WLen 0x0%positive)] 1 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1 POP SWAP2 SWAP1 POP
 O: POP POP PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_850_1"%string (equiv_checker [POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP SWAP2 SWAP1 POP
 O: MLOAD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_851_0"%string (equiv_checker [Opcode MLOAD;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode MLOAD;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP SWAP2 SWAP1 POP
 O: MLOAD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_852_0"%string (equiv_checker [Opcode MLOAD;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode MLOAD;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP SWAP2 SWAP1 POP
 O: MLOAD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_853_0"%string (equiv_checker [Opcode MLOAD;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode MLOAD;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_854_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH 0 DUP3 DUP3
 O: PUSH 0 DUP3 DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_855_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 3] [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 3] 2 optimize_id).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP PUSH 20 SWAP2 POP ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_855_1"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x20%positive);DUP 2;POP;Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP3 DUP3
 O: PUSH 0 DUP3 DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_856_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 3] [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 3] 2 optimize_id).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP PUSH 20 SWAP2 POP ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_856_1"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x20%positive);DUP 2;POP;Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP3 DUP3
 O: PUSH 0 DUP3 DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_857_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 3] [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 3] 2 optimize_id).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP PUSH 20 SWAP2 POP ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_857_1"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x20%positive);DUP 2;POP;Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP2 SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP2 SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_858_0"%string (equiv_checker [DUP 2;DUP 1;POP] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;DUP 1;POP;DUP 3;DUP 2;POP;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 851 DUP3 PUSH [tag] 783
 O: PUSH 0 PUSH [tag] 851 DUP3 PUSH [tag] 783
*)
Compute pair "BottleCastle_run_code_of_0_block_859_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x353%positive);DUP 3;PUSH 2 (posToWord WLen 0x30f%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x353%positive);DUP 3;PUSH 2 (posToWord WLen 0x30f%positive)] 1 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 852 DUP4 PUSH [tag] 783
 O: SWAP2 POP PUSH [tag] 852 DUP4 PUSH [tag] 783
*)
Compute pair "BottleCastle_run_code_of_0_block_860_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x354%positive);DUP 4;PUSH 2 (posToWord WLen 0x30f%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x354%positive);DUP 4;PUSH 2 (posToWord WLen 0x30f%positive)] 4 optimize_id).

(*
 I: SWAP3 POP DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF SUB DUP3 GT ISZERO PUSH [tag] 853
 O: DUP1 SWAP4 POP PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff SUB DUP3 GT ISZERO PUSH [tag] 853
*)
Compute pair "BottleCastle_run_code_of_0_block_861_0"%string (equiv_checker [DUP 1;DUP 4;POP;PUSH 32 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff%positive);Opcode SUB;DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x355%positive)] [DUP 3;POP;DUP 3;PUSH 32 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode SUB;DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x355%positive)] 4 optimize_id).

(*
 I: PUSH [tag] 854 PUSH [tag] 855
 O: PUSH [tag] 854 PUSH [tag] 855
*)
Compute pair "BottleCastle_run_code_of_0_block_862_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x356%positive);PUSH 2 (posToWord WLen 0x357%positive)] [PUSH 2 (posToWord WLen 0x356%positive);PUSH 2 (posToWord WLen 0x357%positive)] 0 optimize_id).

(*
 I: DUP3 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_864_0"%string (equiv_checker [POP;Opcode ADD;DUP 1] [DUP 3;DUP 3;Opcode ADD;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 857 DUP3 PUSH [tag] 783
 O: PUSH 0 PUSH [tag] 857 DUP3 PUSH [tag] 783
*)
Compute pair "BottleCastle_run_code_of_0_block_865_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x359%positive);DUP 3;PUSH 2 (posToWord WLen 0x30f%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x359%positive);DUP 3;PUSH 2 (posToWord WLen 0x30f%positive)] 1 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 858 DUP4 PUSH [tag] 783
 O: SWAP2 POP PUSH [tag] 858 DUP4 PUSH [tag] 783
*)
Compute pair "BottleCastle_run_code_of_0_block_866_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x35a%positive);DUP 4;PUSH 2 (posToWord WLen 0x30f%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x35a%positive);DUP 4;PUSH 2 (posToWord WLen 0x30f%positive)] 4 optimize_id).

(*
 I: SWAP3 POP DUP3 PUSH [tag] 859
 O: SWAP3 POP DUP3 PUSH [tag] 859
*)
Compute pair "BottleCastle_run_code_of_0_block_867_0"%string (equiv_checker [DUP 3;POP;DUP 3;PUSH 2 (posToWord WLen 0x35b%positive)] [DUP 3;POP;DUP 3;PUSH 2 (posToWord WLen 0x35b%positive)] 4 optimize_id).

(*
 I: PUSH [tag] 860 PUSH [tag] 861
 O: PUSH [tag] 860 PUSH [tag] 861
*)
Compute pair "BottleCastle_run_code_of_0_block_868_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x35c%positive);PUSH 2 (posToWord WLen 0x35d%positive)] [PUSH 2 (posToWord WLen 0x35c%positive);PUSH 2 (posToWord WLen 0x35d%positive)] 0 optimize_id).

(*
 I: DUP3 DUP3 DIV SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP DIV SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_870_0"%string (equiv_checker [POP;Opcode DIV;DUP 1] [DUP 3;DUP 3;Opcode DIV;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 863 DUP3 PUSH [tag] 783
 O: PUSH 0 PUSH [tag] 863 DUP3 PUSH [tag] 783
*)
Compute pair "BottleCastle_run_code_of_0_block_871_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x35f%positive);DUP 3;PUSH 2 (posToWord WLen 0x30f%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x35f%positive);DUP 3;PUSH 2 (posToWord WLen 0x30f%positive)] 1 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 864 DUP4 PUSH [tag] 783
 O: SWAP2 POP PUSH [tag] 864 DUP4 PUSH [tag] 783
*)
Compute pair "BottleCastle_run_code_of_0_block_872_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x360%positive);DUP 4;PUSH 2 (posToWord WLen 0x30f%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x360%positive);DUP 4;PUSH 2 (posToWord WLen 0x30f%positive)] 4 optimize_id).

(*
 I: SWAP3 POP DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DIV DUP4 GT DUP3 ISZERO ISZERO AND ISZERO PUSH [tag] 865
 O: SWAP3 POP DUP2 ISZERO ISZERO DUP3 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff DIV DUP5 GT AND ISZERO PUSH [tag] 865
*)
Compute pair "BottleCastle_run_code_of_0_block_873_0"%string (equiv_checker [DUP 3;POP;DUP 2;Opcode ISZERO;Opcode ISZERO;DUP 3;PUSH 32 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff%positive);Opcode DIV;DUP 5;Opcode GT;Opcode AND;Opcode ISZERO;PUSH 2 (posToWord WLen 0x361%positive)] [DUP 3;POP;DUP 2;PUSH 32 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode DIV;DUP 4;Opcode GT;DUP 3;Opcode ISZERO;Opcode ISZERO;Opcode AND;Opcode ISZERO;PUSH 2 (posToWord WLen 0x361%positive)] 4 optimize_id).

(*
 I: PUSH [tag] 866 PUSH [tag] 855
 O: PUSH [tag] 866 PUSH [tag] 855
*)
Compute pair "BottleCastle_run_code_of_0_block_874_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x362%positive);PUSH 2 (posToWord WLen 0x357%positive)] [PUSH 2 (posToWord WLen 0x362%positive);PUSH 2 (posToWord WLen 0x357%positive)] 0 optimize_id).

(*
 I: DUP3 DUP3 MUL SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP MUL SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_876_0"%string (equiv_checker [POP;Opcode MUL;DUP 1] [DUP 3;DUP 3;Opcode MUL;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 868 DUP3 PUSH [tag] 783
 O: PUSH 0 PUSH [tag] 868 DUP3 PUSH [tag] 783
*)
Compute pair "BottleCastle_run_code_of_0_block_877_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x364%positive);DUP 3;PUSH 2 (posToWord WLen 0x30f%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x364%positive);DUP 3;PUSH 2 (posToWord WLen 0x30f%positive)] 1 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 869 DUP4 PUSH [tag] 783
 O: SWAP2 POP PUSH [tag] 869 DUP4 PUSH [tag] 783
*)
Compute pair "BottleCastle_run_code_of_0_block_878_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x365%positive);DUP 4;PUSH 2 (posToWord WLen 0x30f%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x365%positive);DUP 4;PUSH 2 (posToWord WLen 0x30f%positive)] 4 optimize_id).

(*
 I: SWAP3 POP DUP3 DUP3 LT ISZERO PUSH [tag] 870
 O: DUP1 SWAP4 POP DUP3 LT ISZERO PUSH [tag] 870
*)
Compute pair "BottleCastle_run_code_of_0_block_879_0"%string (equiv_checker [DUP 1;DUP 4;POP;DUP 3;Opcode LT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x366%positive)] [DUP 3;POP;DUP 3;DUP 3;Opcode LT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x366%positive)] 4 optimize_id).

(*
 I: PUSH [tag] 871 PUSH [tag] 855
 O: PUSH [tag] 871 PUSH [tag] 855
*)
Compute pair "BottleCastle_run_code_of_0_block_880_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x367%positive);PUSH 2 (posToWord WLen 0x357%positive)] [PUSH 2 (posToWord WLen 0x367%positive);PUSH 2 (posToWord WLen 0x357%positive)] 0 optimize_id).

(*
 I: DUP3 DUP3 SUB SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_882_0"%string (equiv_checker [POP;Opcode SUB;DUP 1] [DUP 3;DUP 3;Opcode SUB;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 873 DUP3 PUSH [tag] 874
 O: PUSH 0 PUSH [tag] 873 DUP3 PUSH [tag] 874
*)
Compute pair "BottleCastle_run_code_of_0_block_883_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x369%positive);DUP 3;PUSH 2 (posToWord WLen 0x36a%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x369%positive);DUP 3;PUSH 2 (posToWord WLen 0x36a%positive)] 1 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_884_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP2 ISZERO ISZERO SWAP1 POP SWAP2 SWAP1 POP
 O: ISZERO ISZERO SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_885_0"%string (equiv_checker [Opcode ISZERO;Opcode ISZERO;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode ISZERO;Opcode ISZERO;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFF00000000000000000000000000000000000000000000000000000000 DUP3 AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH ffffffff00000000000000000000000000000000000000000000000000000000 AND SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_886_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0xffffffff00000000000000000000000000000000000000000000000000000000%positive);Opcode AND;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 32 (posToWord WLen 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000%positive);DUP 3;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP3 AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_887_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);DUP 3;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH 0 DUP2 SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_888_0"%string (equiv_checker [DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: DUP3 DUP2 DUP4
 O: DUP3 DUP2 DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_889_0"%string (equiv_checker [DUP 3;DUP 2;DUP 4] [DUP 3;DUP 2;DUP 4] 3 optimize_id).

(*
 I: PUSH 0 DUP4 DUP4 ADD
 O: PUSH 0 DUP3 DUP5 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_889_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 5;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 4;Opcode ADD] 3 optimize_id).

(*
 I: POP POP POP
 O: POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_889_2"%string (equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id).

(*
 I: PUSH 0
 O: PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_890_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: DUP4 DUP2 LT ISZERO PUSH [tag] 884
 O: DUP4 DUP2 LT ISZERO PUSH [tag] 884
*)
Compute pair "BottleCastle_run_code_of_0_block_891_0"%string (equiv_checker [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x374%positive)] [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x374%positive)] 4 optimize_id).

(*
 I: DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD
 O: DUP2 DUP2 ADD MLOAD DUP4 DUP3 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_892_0"%string (equiv_checker [DUP 2;DUP 2;Opcode ADD;Opcode MLOAD;DUP 4;DUP 3;Opcode ADD] [DUP 1;DUP 3;Opcode ADD;Opcode MLOAD;DUP 2;DUP 5;Opcode ADD] 3 optimize_id).

(*
 I: PUSH 20 DUP2 ADD SWAP1 POP PUSH [tag] 882
 O: PUSH 20 ADD PUSH [tag] 882
*)
Compute pair "BottleCastle_run_code_of_0_block_892_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x372%positive)] [PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;DUP 1;POP;PUSH 2 (posToWord WLen 0x372%positive)] 1 optimize_id).

(*
 I: DUP4 DUP2 GT ISZERO PUSH [tag] 885
 O: DUP4 DUP2 GT ISZERO PUSH [tag] 885
*)
Compute pair "BottleCastle_run_code_of_0_block_893_0"%string (equiv_checker [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x375%positive)] [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x375%positive)] 4 optimize_id).

(*
 I: PUSH 0 DUP5 DUP5 ADD
 O: PUSH 0 DUP4 DUP6 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_894_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 6;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);DUP 5;DUP 5;Opcode ADD] 4 optimize_id).

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_895_0"%string (equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 2 DUP3 DIV SWAP1 POP PUSH 1 DUP3 AND DUP1 PUSH [tag] 887
 O: PUSH 2 DUP2 DIV DUP2 PUSH 1 AND DUP1 PUSH [tag] 887
*)
Compute pair "BottleCastle_run_code_of_0_block_896_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2%positive);DUP 2;Opcode DIV;DUP 2;PUSH 1 (posToWord WLen 0x1%positive);Opcode AND;DUP 1;PUSH 2 (posToWord WLen 0x377%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x2%positive);DUP 3;Opcode DIV;DUP 1;POP;PUSH 1 (posToWord WLen 0x1%positive);DUP 3;Opcode AND;DUP 1;PUSH 2 (posToWord WLen 0x377%positive)] 1 optimize_id).

(*
 I: PUSH 7F DUP3 AND SWAP2 POP
 O: SWAP1 PUSH 7f AND SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_897_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x7f%positive);Opcode AND;DUP 1] [PUSH 1 (posToWord WLen 0x7F%positive);DUP 3;Opcode AND;DUP 2;POP] 2 optimize_id).

(*
 I: PUSH 20 DUP3 LT DUP2 EQ ISZERO PUSH [tag] 888
 O: DUP1 PUSH 20 DUP4 LT EQ ISZERO PUSH [tag] 888
*)
Compute pair "BottleCastle_run_code_of_0_block_898_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);DUP 4;Opcode LT;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x378%positive)] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode LT;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x378%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 889 PUSH [tag] 890
 O: PUSH [tag] 889 PUSH [tag] 890
*)
Compute pair "BottleCastle_run_code_of_0_block_899_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x379%positive);PUSH 2 (posToWord WLen 0x37a%positive)] [PUSH 2 (posToWord WLen 0x379%positive);PUSH 2 (posToWord WLen 0x37a%positive)] 0 optimize_id).

(*
 I: POP SWAP2 SWAP1 POP
 O: POP SWAP2 SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_901_0"%string (equiv_checker [POP;DUP 2;DUP 1;POP] [POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH [tag] 892 DUP3 PUSH [tag] 704
 O: PUSH [tag] 892 DUP3 PUSH [tag] 704
*)
Compute pair "BottleCastle_run_code_of_0_block_902_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x37c%positive);DUP 3;PUSH 2 (posToWord WLen 0x2c0%positive)] [PUSH 2 (posToWord WLen 0x37c%positive);DUP 3;PUSH 2 (posToWord WLen 0x2c0%positive)] 2 optimize_id).

(*
 I: DUP2 ADD DUP2 DUP2 LT PUSH FFFFFFFFFFFFFFFF DUP3 GT OR ISZERO PUSH [tag] 893
 O: DUP2 ADD PUSH ffffffffffffffff DUP2 GT DUP3 DUP3 LT OR ISZERO PUSH [tag] 893
*)
Compute pair "BottleCastle_run_code_of_0_block_903_0"%string (equiv_checker [DUP 2;Opcode ADD;PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 2;Opcode GT;DUP 3;DUP 3;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 2 (posToWord WLen 0x37d%positive)] [DUP 2;Opcode ADD;DUP 2;DUP 2;Opcode LT;PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);DUP 3;Opcode GT;Opcode OR;Opcode ISZERO;PUSH 2 (posToWord WLen 0x37d%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 894 PUSH [tag] 312
 O: PUSH [tag] 894 PUSH [tag] 312
*)
Compute pair "BottleCastle_run_code_of_0_block_904_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x37e%positive);PUSH 2 (posToWord WLen 0x138%positive)] [PUSH 2 (posToWord WLen 0x37e%positive);PUSH 2 (posToWord WLen 0x138%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 40
 O: DUP1 PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_906_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x40%positive)] 1 optimize_id).

(*
 I: POP POP POP
 O: POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_906_1"%string (equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 896 DUP3 PUSH [tag] 783
 O: PUSH 0 PUSH [tag] 896 DUP3 PUSH [tag] 783
*)
Compute pair "BottleCastle_run_code_of_0_block_907_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x380%positive);DUP 3;PUSH 2 (posToWord WLen 0x30f%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x380%positive);DUP 3;PUSH 2 (posToWord WLen 0x30f%positive)] 1 optimize_id).

(*
 I: SWAP2 POP PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP3 EQ ISZERO PUSH [tag] 897
 O: SWAP2 POP PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff DUP3 EQ ISZERO PUSH [tag] 897
*)
Compute pair "BottleCastle_run_code_of_0_block_908_0"%string (equiv_checker [DUP 2;POP;PUSH 32 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff%positive);DUP 3;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x381%positive)] [DUP 2;POP;PUSH 32 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);DUP 3;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x381%positive)] 3 optimize_id).

(*
 I: PUSH [tag] 898 PUSH [tag] 855
 O: PUSH [tag] 898 PUSH [tag] 855
*)
Compute pair "BottleCastle_run_code_of_0_block_909_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x382%positive);PUSH 2 (posToWord WLen 0x357%positive)] [PUSH 2 (posToWord WLen 0x382%positive);PUSH 2 (posToWord WLen 0x357%positive)] 0 optimize_id).

(*
 I: PUSH 1 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 1 ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_911_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x1%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 900 DUP3 PUSH [tag] 783
 O: PUSH 0 PUSH [tag] 900 DUP3 PUSH [tag] 783
*)
Compute pair "BottleCastle_run_code_of_0_block_912_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x384%positive);DUP 3;PUSH 2 (posToWord WLen 0x30f%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x384%positive);DUP 3;PUSH 2 (posToWord WLen 0x30f%positive)] 1 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 901 DUP4 PUSH [tag] 783
 O: SWAP2 POP PUSH [tag] 901 DUP4 PUSH [tag] 783
*)
Compute pair "BottleCastle_run_code_of_0_block_913_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x385%positive);DUP 4;PUSH 2 (posToWord WLen 0x30f%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x385%positive);DUP 4;PUSH 2 (posToWord WLen 0x30f%positive)] 4 optimize_id).

(*
 I: SWAP3 POP DUP3 PUSH [tag] 902
 O: SWAP3 POP DUP3 PUSH [tag] 902
*)
Compute pair "BottleCastle_run_code_of_0_block_914_0"%string (equiv_checker [DUP 3;POP;DUP 3;PUSH 2 (posToWord WLen 0x386%positive)] [DUP 3;POP;DUP 3;PUSH 2 (posToWord WLen 0x386%positive)] 4 optimize_id).

(*
 I: PUSH [tag] 903 PUSH [tag] 861
 O: PUSH [tag] 903 PUSH [tag] 861
*)
Compute pair "BottleCastle_run_code_of_0_block_915_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x387%positive);PUSH 2 (posToWord WLen 0x35d%positive)] [PUSH 2 (posToWord WLen 0x387%positive);PUSH 2 (posToWord WLen 0x35d%positive)] 0 optimize_id).

(*
 I: DUP3 DUP3 MOD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP MOD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_917_0"%string (equiv_checker [POP;Opcode MOD;DUP 1] [DUP 3;DUP 3;Opcode MOD;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_918_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x4e487b7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 32 (posToWord WLen 0x4E487B7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 11 PUSH 4
 O: PUSH 11 PUSH 4
*)
Compute pair "BottleCastle_run_code_of_0_block_918_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x11%positive);PUSH 1 (posToWord WLen 0x4%positive)] [PUSH 1 (posToWord WLen 0x11%positive);PUSH 1 (posToWord WLen 0x4%positive)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_918_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_919_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x4e487b7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 32 (posToWord WLen 0x4E487B7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 12 PUSH 4
 O: PUSH 12 PUSH 4
*)
Compute pair "BottleCastle_run_code_of_0_block_919_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x12%positive);PUSH 1 (posToWord WLen 0x4%positive)] [PUSH 1 (posToWord WLen 0x12%positive);PUSH 1 (posToWord WLen 0x4%positive)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_919_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_920_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x4e487b7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 32 (posToWord WLen 0x4E487B7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 22 PUSH 4
 O: PUSH 22 PUSH 4
*)
Compute pair "BottleCastle_run_code_of_0_block_920_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x22%positive);PUSH 1 (posToWord WLen 0x4%positive)] [PUSH 1 (posToWord WLen 0x22%positive);PUSH 1 (posToWord WLen 0x4%positive)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_920_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_921_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x4e487b7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 32 (posToWord WLen 0x4E487B7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 32 PUSH 4
 O: PUSH 32 PUSH 4
*)
Compute pair "BottleCastle_run_code_of_0_block_921_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x32%positive);PUSH 1 (posToWord WLen 0x4%positive)] [PUSH 1 (posToWord WLen 0x32%positive);PUSH 1 (posToWord WLen 0x4%positive)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_921_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_922_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x4e487b7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 32 (posToWord WLen 0x4E487B7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 41 PUSH 4
 O: PUSH 41 PUSH 4
*)
Compute pair "BottleCastle_run_code_of_0_block_922_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x41%positive);PUSH 1 (posToWord WLen 0x4%positive)] [PUSH 1 (posToWord WLen 0x41%positive);PUSH 1 (posToWord WLen 0x4%positive)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_922_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_923_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_924_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_925_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_926_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 PUSH 1F NOT PUSH 1F DUP4 ADD AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 1f ADD PUSH 1f NOT AND SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_927_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1f%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x1f%positive);Opcode NOT;Opcode AND;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x1F%positive);Opcode NOT;PUSH 1 (posToWord WLen 0x1F%positive);DUP 4;Opcode ADD;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH 455243373231414D657461646174613A2055524920717565727920666F72206E PUSH 0 DUP3 ADD
 O: PUSH 455243373231414d657461646174613a2055524920717565727920666f72206e DUP2 PUSH 0 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_928_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x455243373231414d657461646174613a2055524920717565727920666f72206e%positive);DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD] [PUSH 32 (posToWord WLen 0x455243373231414D657461646174613A2055524920717565727920666F72206E%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 6F6E6578697374656E7420746F6B656E00000000000000000000000000000000 PUSH 20 DUP3 ADD
 O: PUSH 6f6e6578697374656e7420746f6b656e00000000000000000000000000000000 DUP2 PUSH 20 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_928_1"%string (equiv_checker [PUSH 32 (posToWord WLen 0x6f6e6578697374656e7420746f6b656e00000000000000000000000000000000%positive);DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD] [PUSH 32 (posToWord WLen 0x6F6E6578697374656E7420746F6B656E00000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_928_2"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH 4F776E61626C653A206E6577206F776E657220697320746865207A65726F2061 PUSH 0 DUP3 ADD
 O: PUSH 4f776e61626c653a206e6577206f776e657220697320746865207a65726f2061 DUP2 PUSH 0 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_929_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x4f776e61626c653a206e6577206f776e657220697320746865207a65726f2061%positive);DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD] [PUSH 32 (posToWord WLen 0x4F776E61626C653A206E6577206F776E657220697320746865207A65726F2061%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 6464726573730000000000000000000000000000000000000000000000000000 PUSH 20 DUP3 ADD
 O: PUSH 6464726573730000000000000000000000000000000000000000000000000000 DUP2 PUSH 20 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_929_1"%string (equiv_checker [PUSH 32 (posToWord WLen 0x6464726573730000000000000000000000000000000000000000000000000000%positive);DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD] [PUSH 32 (posToWord WLen 0x6464726573730000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_929_2"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH 576520536F6C646F757400000000000000000000000000000000000000000000 PUSH 0 DUP3 ADD
 O: PUSH 576520536f6c646f757400000000000000000000000000000000000000000000 DUP2 PUSH 0 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_930_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x576520536f6c646f757400000000000000000000000000000000000000000000%positive);DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD] [PUSH 32 (posToWord WLen 0x576520536F6C646F757400000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_930_1"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH 6F6F707320636F6E747261637420697320706175736564000000000000000000 PUSH 0 DUP3 ADD
 O: PUSH 6f6f707320636f6e747261637420697320706175736564000000000000000000 DUP2 PUSH 0 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_931_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x6f6f707320636f6e747261637420697320706175736564000000000000000000%positive);DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD] [PUSH 32 (posToWord WLen 0x6F6F707320636F6E747261637420697320706175736564000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_931_1"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH 6D6178204E4654206C696D697420657863656564656400000000000000000000 PUSH 0 DUP3 ADD
 O: PUSH 6d6178204e4654206c696d697420657863656564656400000000000000000000 DUP2 PUSH 0 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_932_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x6d6178204e4654206c696d697420657863656564656400000000000000000000%positive);DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD] [PUSH 32 (posToWord WLen 0x6D6178204E4654206C696D697420657863656564656400000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_932_1"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH 4F776E61626C653A2063616C6C6572206973206E6F7420746865206F776E6572 PUSH 0 DUP3 ADD
 O: PUSH 4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572 DUP2 PUSH 0 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_933_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572%positive);DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD] [PUSH 32 (posToWord WLen 0x4F776E61626C653A2063616C6C6572206973206E6F7420746865206F776E6572%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_933_1"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH 696E73756666696369656E742066756E64730000000000000000000000000000 PUSH 0 DUP3 ADD
 O: PUSH 696e73756666696369656e742066756e64730000000000000000000000000000 DUP2 PUSH 0 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_934_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x696e73756666696369656e742066756e64730000000000000000000000000000%positive);DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD] [PUSH 32 (posToWord WLen 0x696E73756666696369656E742066756E64730000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_934_1"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH 4D6178204E4654205065722057616C6C65742065786365656465640000000000 PUSH 0 DUP3 ADD
 O: PUSH 4d6178204e4654205065722057616c6c65742065786365656465640000000000 DUP2 PUSH 0 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_935_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x4d6178204e4654205065722057616c6c65742065786365656465640000000000%positive);DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD] [PUSH 32 (posToWord WLen 0x4D6178204E4654205065722057616C6C65742065786365656465640000000000%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_935_1"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH 5265656E7472616E637947756172643A207265656E7472616E742063616C6C00 PUSH 0 DUP3 ADD
 O: PUSH 5265656e7472616e637947756172643a207265656e7472616e742063616c6c00 DUP2 PUSH 0 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_936_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x5265656e7472616e637947756172643a207265656e7472616e742063616c6c00%positive);DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD] [PUSH 32 (posToWord WLen 0x5265656E7472616E637947756172643A207265656E7472616E742063616C6C00%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_936_1"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH 6D6178206D696E7420616D6F756E742070657220747820657863656564656400 PUSH 0 DUP3 ADD
 O: PUSH 6d6178206d696e7420616d6f756e742070657220747820657863656564656400 DUP2 PUSH 0 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_937_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x6d6178206d696e7420616d6f756e742070657220747820657863656564656400%positive);DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD] [PUSH 32 (posToWord WLen 0x6D6178206D696E7420616D6F756E742070657220747820657863656564656400%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_937_1"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH [tag] 925 DUP2 PUSH [tag] 676
 O: PUSH [tag] 925 DUP2 PUSH [tag] 676
*)
Compute pair "BottleCastle_run_code_of_0_block_938_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x39d%positive);DUP 2;PUSH 2 (posToWord WLen 0x2a4%positive)] [PUSH 2 (posToWord WLen 0x39d%positive);DUP 2;PUSH 2 (posToWord WLen 0x2a4%positive)] 1 optimize_id).

(*
 I: DUP2 EQ PUSH [tag] 926
 O: DUP2 EQ PUSH [tag] 926
*)
Compute pair "BottleCastle_run_code_of_0_block_939_0"%string (equiv_checker [DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x39e%positive)] [DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x39e%positive)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_940_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_941_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH [tag] 928 DUP2 PUSH [tag] 694
 O: PUSH [tag] 928 DUP2 PUSH [tag] 694
*)
Compute pair "BottleCastle_run_code_of_0_block_942_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x3a0%positive);DUP 2;PUSH 2 (posToWord WLen 0x2b6%positive)] [PUSH 2 (posToWord WLen 0x3a0%positive);DUP 2;PUSH 2 (posToWord WLen 0x2b6%positive)] 1 optimize_id).

(*
 I: DUP2 EQ PUSH [tag] 929
 O: DUP2 EQ PUSH [tag] 929
*)
Compute pair "BottleCastle_run_code_of_0_block_943_0"%string (equiv_checker [DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x3a1%positive)] [DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x3a1%positive)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_944_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_945_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH [tag] 931 DUP2 PUSH [tag] 876
 O: PUSH [tag] 931 DUP2 PUSH [tag] 876
*)
Compute pair "BottleCastle_run_code_of_0_block_946_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x3a3%positive);DUP 2;PUSH 2 (posToWord WLen 0x36c%positive)] [PUSH 2 (posToWord WLen 0x3a3%positive);DUP 2;PUSH 2 (posToWord WLen 0x36c%positive)] 1 optimize_id).

(*
 I: DUP2 EQ PUSH [tag] 932
 O: DUP2 EQ PUSH [tag] 932
*)
Compute pair "BottleCastle_run_code_of_0_block_947_0"%string (equiv_checker [DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x3a4%positive)] [DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x3a4%positive)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_948_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_949_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH [tag] 934 DUP2 PUSH [tag] 783
 O: PUSH [tag] 934 DUP2 PUSH [tag] 783
*)
Compute pair "BottleCastle_run_code_of_0_block_950_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x3a6%positive);DUP 2;PUSH 2 (posToWord WLen 0x30f%positive)] [PUSH 2 (posToWord WLen 0x3a6%positive);DUP 2;PUSH 2 (posToWord WLen 0x30f%positive)] 1 optimize_id).

(*
 I: DUP2 EQ PUSH [tag] 935
 O: DUP2 EQ PUSH [tag] 935
*)
Compute pair "BottleCastle_run_code_of_0_block_951_0"%string (equiv_checker [DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x3a7%positive)] [DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x3a7%positive)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_952_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_953_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH 80 PUSH 40
 O: PUSH 80 PUSH 40
*)
Compute pair "ERC721A_initial_block_0_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x80%positive);PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 1 (posToWord WLen 0x80%positive);PUSH 1 (posToWord WLen 0x40%positive)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 1
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 1
*)
Compute pair "ERC721A_initial_block_0_1"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x1%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x1%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_initial_block_1_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH 40 MLOAD PUSHSIZE CODESIZE SUB DUP1 PUSHSIZE DUP4
 O: POP PUSH 40 MLOAD PUSHSIZE CODESIZE SUB DUP1 PUSHSIZE DUP4
  ERROR OCCURRED

'PUSHSIZE' is not in list
*)

(*
 I: DUP2 DUP2 ADD PUSH 40
 O: DUP1 DUP3 ADD PUSH 40
*)
Compute pair "ERC721A_initial_block_2_1"%string (equiv_checker [DUP 1;DUP 3;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 2;DUP 2;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 2 optimize_id).

(*
 I: DUP2 ADD SWAP1 PUSH [tag] 2 SWAP2 SWAP1 PUSH [tag] 3
 O: DUP2 ADD PUSH [tag] 2 SWAP2 PUSH [tag] 3
*)
Compute pair "ERC721A_initial_block_2_2"%string (equiv_checker [DUP 2;Opcode ADD;PUSH 1 (posToWord WLen 0x2%positive);DUP 2;PUSH 1 (posToWord WLen 0x3%positive)] [DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x2%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x3%positive)] 2 optimize_id).

(*
 I: DUP2 PUSH 2 SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 6 SWAP3 SWAP2 SWAP1 PUSH [tag] 7
 O: PUSH [tag] 6 PUSH 2 DUP4 PUSH 20 ADD DUP5 MLOAD PUSH [tag] 7
*)
Compute pair "ERC721A_initial_block_3_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x6%positive);PUSH 1 (posToWord WLen 0x2%positive);DUP 4;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 5;Opcode MLOAD;PUSH 1 (posToWord WLen 0x7%positive)] [DUP 2;PUSH 1 (posToWord WLen 0x2%positive);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x6%positive);DUP 3;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x7%positive)] 2 optimize_id).

(*
 I: POP DUP1 PUSH 3 SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 8 SWAP3 SWAP2 SWAP1 PUSH [tag] 7
 O: POP PUSH [tag] 8 PUSH 3 PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 7
*)
Compute pair "ERC721A_initial_block_4_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x8%positive);PUSH 1 (posToWord WLen 0x3%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 1 (posToWord WLen 0x7%positive)] [POP;DUP 1;PUSH 1 (posToWord WLen 0x3%positive);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x8%positive);DUP 3;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x7%positive)] 2 optimize_id).

(*
 I: POP PUSH [tag] 9 PUSH [tag] 10 PUSH 20 SHL PUSH 20 SHR
 O: POP PUSH [tag] 9 PUSH [tag] 10 PUSH 20 SHL PUSH 20 SHR
*)
Compute pair "ERC721A_initial_block_5_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x9%positive);PUSH 1 (posToWord WLen 0xa%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] [POP;PUSH 1 (posToWord WLen 0x9%positive);PUSH 1 (posToWord WLen 0xa%positive);PUSH 1 (posToWord WLen 0x20%positive);Opcode SHL;PUSH 1 (posToWord WLen 0x20%positive);Opcode SHR] 1 optimize_id).

(*
 I: PUSH 0 DUP2 SWAP1
 O: DUP1 PUSH 0
*)
Compute pair "ERC721A_initial_block_6_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;DUP 1] 1 optimize_id).

(*
 I: POP POP POP PUSH [tag] 11
 O: POP POP POP PUSH [tag] 11
*)
Compute pair "ERC721A_initial_block_6_1"%string (equiv_checker [POP;POP;POP;PUSH 1 (posToWord WLen 0xb%positive)] [POP;POP;POP;PUSH 1 (posToWord WLen 0xb%positive)] 3 optimize_id).

(*
 I: PUSH 0 SWAP1
 O: PUSH 0 SWAP1
*)
Compute pair "ERC721A_initial_block_7_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 1 optimize_id).

(*
 I: DUP3 DUP1 SLOAD PUSH [tag] 13 SWAP1 PUSH [tag] 14
 O: DUP3 PUSH [tag] 13 DUP5 SLOAD PUSH [tag] 14
*)
Compute pair "ERC721A_initial_block_8_0"%string (equiv_checker [DUP 3;PUSH 1 (posToWord WLen 0xd%positive);DUP 5;Opcode SLOAD;PUSH 1 (posToWord WLen 0xe%positive)] [DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (posToWord WLen 0xd%positive);DUP 1;PUSH 1 (posToWord WLen 0xe%positive)] 3 optimize_id).

(*
 I: SWAP1 PUSH 0
 O: SWAP1 PUSH 0
*)
Compute pair "ERC721A_initial_block_9_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] 2 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1 PUSH 1F ADD PUSH 20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 16
 O: PUSH 20 DUP1 PUSH 0 KECCAK256 SWAP2 PUSH 1f ADD DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 16
*)
Compute pair "ERC721A_initial_block_9_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);DUP 1;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 2;PUSH 1 (posToWord WLen 0x1f%positive);Opcode ADD;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 1 (posToWord WLen 0x10%positive)] [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 1 (posToWord WLen 0x10%positive)] 3 optimize_id).

(*
 I: PUSH 0 DUP6
 O: PUSH 0 DUP6
*)
Compute pair "ERC721A_initial_block_10_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 6] [PUSH 1 (posToWord WLen 0x0%positive);DUP 6] 5 optimize_id).

(*
 I: PUSH [tag] 15
 O: PUSH [tag] 15
*)
Compute pair "ERC721A_initial_block_10_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0xf%positive)] [PUSH 1 (posToWord WLen 0xf%positive)] 0 optimize_id).

(*
 I: DUP3 PUSH 1F LT PUSH [tag] 17
 O: DUP3 PUSH 1f LT PUSH [tag] 17
*)
Compute pair "ERC721A_initial_block_11_0"%string (equiv_checker [DUP 3;PUSH 1 (posToWord WLen 0x1f%positive);Opcode LT;PUSH 1 (posToWord WLen 0x11%positive)] [DUP 3;PUSH 1 (posToWord WLen 0x1F%positive);Opcode LT;PUSH 1 (posToWord WLen 0x11%positive)] 3 optimize_id).

(*
 I: DUP1 MLOAD PUSH FF NOT AND DUP4 DUP1 ADD OR DUP6
 O: DUP3 DUP1 ADD PUSH ff NOT DUP3 MLOAD AND OR DUP6
*)
Compute pair "ERC721A_initial_block_12_0"%string (equiv_checker [DUP 3;DUP 1;Opcode ADD;PUSH 1 (posToWord WLen 0xff%positive);Opcode NOT;DUP 3;Opcode MLOAD;Opcode AND;Opcode OR;DUP 6] [DUP 1;Opcode MLOAD;PUSH 1 (posToWord WLen 0xFF%positive);Opcode NOT;Opcode AND;DUP 4;DUP 1;Opcode ADD;Opcode OR;DUP 6] 5 optimize_id).

(*
 I: PUSH [tag] 15
 O: PUSH [tag] 15
*)
Compute pair "ERC721A_initial_block_12_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0xf%positive)] [PUSH 1 (posToWord WLen 0xf%positive)] 0 optimize_id).

(*
 I: DUP3 DUP1 ADD PUSH 1 ADD DUP6
 O: DUP3 DUP4 ADD PUSH 1 ADD DUP6
*)
Compute pair "ERC721A_initial_block_13_0"%string (equiv_checker [DUP 3;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 6] [DUP 3;DUP 1;Opcode ADD;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 6] 5 optimize_id).

(*
 I: DUP3 ISZERO PUSH [tag] 15
 O: DUP3 ISZERO PUSH [tag] 15
*)
Compute pair "ERC721A_initial_block_13_1"%string (equiv_checker [DUP 3;Opcode ISZERO;PUSH 1 (posToWord WLen 0xf%positive)] [DUP 3;Opcode ISZERO;PUSH 1 (posToWord WLen 0xf%positive)] 3 optimize_id).

(*
 I: SWAP2 DUP3 ADD
 O: DUP1 SWAP3 ADD
*)
Compute pair "ERC721A_initial_block_14_0"%string (equiv_checker [DUP 1;DUP 3;Opcode ADD] [DUP 2;DUP 3;Opcode ADD] 3 optimize_id).

(*
 I: DUP3 DUP2 GT ISZERO PUSH [tag] 19
 O: DUP3 DUP2 GT ISZERO PUSH [tag] 19
*)
Compute pair "ERC721A_initial_block_15_0"%string (equiv_checker [DUP 3;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x13%positive)] [DUP 3;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x13%positive)] 3 optimize_id).

(*
 I: DUP3 MLOAD DUP3
 O: DUP3 MLOAD DUP3
*)
Compute pair "ERC721A_initial_block_16_0"%string (equiv_checker [DUP 3;Opcode MLOAD;DUP 3] [DUP 3;Opcode MLOAD;DUP 3] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 SWAP1 PUSH 1 ADD SWAP1 PUSH [tag] 18
 O: SWAP2 PUSH 20 ADD SWAP2 SWAP1 PUSH 1 ADD SWAP1 PUSH [tag] 18
*)
Compute pair "ERC721A_initial_block_16_1"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x12%positive)] [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x12%positive)] 3 optimize_id).

(*
 I: POP SWAP1 POP PUSH [tag] 20 SWAP2 SWAP1 PUSH [tag] 21
 O: POP PUSH [tag] 20 SWAP3 SWAP2 POP PUSH [tag] 21
*)
Compute pair "ERC721A_initial_block_18_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x14%positive);DUP 3;DUP 2;POP;PUSH 1 (posToWord WLen 0x15%positive)] [POP;DUP 1;POP;PUSH 1 (posToWord WLen 0x14%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x15%positive)] 4 optimize_id).

(*
 I: POP SWAP1
 O: POP SWAP1
*)
Compute pair "ERC721A_initial_block_19_0"%string (equiv_checker [POP;DUP 1] [POP;DUP 1] 3 optimize_id).

(*
 I: DUP1 DUP3 GT ISZERO PUSH [tag] 23
 O: DUP1 DUP3 GT ISZERO PUSH [tag] 23
*)
Compute pair "ERC721A_initial_block_21_0"%string (equiv_checker [DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x17%positive)] [DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x17%positive)] 2 optimize_id).

(*
 I: PUSH 0 DUP2 PUSH 0 SWAP1
 O: PUSH 0 DUP1 DUP3
*)
Compute pair "ERC721A_initial_block_22_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;DUP 3] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 1 optimize_id).

(*
 I: POP PUSH 1 ADD PUSH [tag] 22
 O: POP PUSH 1 ADD PUSH [tag] 22
*)
Compute pair "ERC721A_initial_block_22_1"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x16%positive)] [POP;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x16%positive)] 2 optimize_id).

(*
 I: POP SWAP1
 O: POP SWAP1
*)
Compute pair "ERC721A_initial_block_23_0"%string (equiv_checker [POP;DUP 1] [POP;DUP 1] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 27 PUSH [tag] 28 DUP5 PUSH [tag] 29
 O: PUSH 0 PUSH [tag] 27 PUSH [tag] 28 DUP5 PUSH [tag] 29
*)
Compute pair "ERC721A_initial_block_24_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x1b%positive);PUSH 1 (posToWord WLen 0x1c%positive);DUP 5;PUSH 1 (posToWord WLen 0x1d%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x1b%positive);PUSH 1 (posToWord WLen 0x1c%positive);DUP 5;PUSH 1 (posToWord WLen 0x1d%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 30
 O: PUSH [tag] 30
*)
Compute pair "ERC721A_initial_block_25_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1e%positive)] [PUSH 1 (posToWord WLen 0x1e%positive)] 0 optimize_id).

(*
 I: SWAP1 POP DUP3 DUP2
 O: SWAP1 POP DUP3 DUP2
*)
Compute pair "ERC721A_initial_block_26_0"%string (equiv_checker [DUP 1;POP;DUP 3;DUP 2] [DUP 1;POP;DUP 3;DUP 2] 4 optimize_id).

(*
 I: PUSH 20 DUP2 ADD DUP5 DUP5 DUP5 ADD GT ISZERO PUSH [tag] 31
 O: DUP1 PUSH 20 ADD DUP5 DUP4 DUP6 ADD GT ISZERO PUSH [tag] 31
*)
Compute pair "ERC721A_initial_block_26_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 5;DUP 4;DUP 6;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x1f%positive)] [PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;DUP 5;DUP 5;DUP 5;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x1f%positive)] 4 optimize_id).

(*
 I: PUSH [tag] 32 PUSH [tag] 33
 O: PUSH [tag] 32 PUSH [tag] 33
*)
Compute pair "ERC721A_initial_block_27_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x21%positive)] [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x21%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 34 DUP5 DUP3 DUP6 PUSH [tag] 35
 O: PUSH [tag] 34 DUP5 DUP3 DUP6 PUSH [tag] 35
*)
Compute pair "ERC721A_initial_block_29_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x22%positive);DUP 5;DUP 3;DUP 6;PUSH 1 (posToWord WLen 0x23%positive)] [PUSH 1 (posToWord WLen 0x22%positive);DUP 5;DUP 3;DUP 6;PUSH 1 (posToWord WLen 0x23%positive)] 4 optimize_id).

(*
 I: POP SWAP4 SWAP3 POP POP POP
 O: POP SWAP4 SWAP3 POP POP POP
*)
Compute pair "ERC721A_initial_block_30_0"%string (equiv_checker [POP;DUP 4;DUP 3;POP;POP;POP] [POP;DUP 4;DUP 3;POP;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 38
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 38
*)
Compute pair "ERC721A_initial_block_31_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 3;PUSH 1 (posToWord WLen 0x1f%positive);Opcode ADD;Opcode SLT;PUSH 1 (posToWord WLen 0x26%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;PUSH 1 (posToWord WLen 0x1F%positive);DUP 4;Opcode ADD;Opcode SLT;PUSH 1 (posToWord WLen 0x26%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 39 PUSH [tag] 40
 O: PUSH [tag] 39 PUSH [tag] 40
*)
Compute pair "ERC721A_initial_block_32_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x27%positive);PUSH 1 (posToWord WLen 0x28%positive)] [PUSH 1 (posToWord WLen 0x27%positive);PUSH 1 (posToWord WLen 0x28%positive)] 0 optimize_id).

(*
 I: DUP2 MLOAD PUSH [tag] 41 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 25
 O: DUP2 MLOAD PUSH [tag] 41 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 25
*)
Compute pair "ERC721A_initial_block_34_0"%string (equiv_checker [DUP 2;Opcode MLOAD;PUSH 1 (posToWord WLen 0x29%positive);DUP 5;DUP 3;PUSH 1 (posToWord WLen 0x20%positive);DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0x19%positive)] [DUP 2;Opcode MLOAD;PUSH 1 (posToWord WLen 0x29%positive);DUP 5;DUP 3;PUSH 1 (posToWord WLen 0x20%positive);DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0x19%positive)] 3 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute pair "ERC721A_initial_block_35_0"%string (equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 43
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 43
*)
Compute pair "ERC721A_initial_block_36_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x2b%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x2b%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 44 PUSH [tag] 45
 O: PUSH [tag] 44 PUSH [tag] 45
*)
Compute pair "ERC721A_initial_block_37_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2c%positive);PUSH 1 (posToWord WLen 0x2d%positive)] [PUSH 1 (posToWord WLen 0x2c%positive);PUSH 1 (posToWord WLen 0x2d%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP4 ADD MLOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 46
 O: DUP3 PUSH 0 ADD MLOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 46
*)
Compute pair "ERC721A_initial_block_39_0"%string (equiv_checker [DUP 3;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;Opcode MLOAD;PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x2e%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD;Opcode MLOAD;PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x2e%positive)] 3 optimize_id).

(*
 I: PUSH [tag] 47 PUSH [tag] 48
 O: PUSH [tag] 47 PUSH [tag] 48
*)
Compute pair "ERC721A_initial_block_40_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2f%positive);PUSH 1 (posToWord WLen 0x30%positive)] [PUSH 1 (posToWord WLen 0x2f%positive);PUSH 1 (posToWord WLen 0x30%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 49 DUP6 DUP3 DUP7 ADD PUSH [tag] 36
 O: PUSH [tag] 49 DUP6 DUP3 DUP7 ADD PUSH [tag] 36
*)
Compute pair "ERC721A_initial_block_42_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x31%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0x24%positive)] [PUSH 1 (posToWord WLen 0x31%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0x24%positive)] 5 optimize_id).

(*
 I: SWAP3 POP POP PUSH 20 DUP4 ADD MLOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 50
 O: SWAP3 POP POP DUP3 PUSH 20 ADD MLOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 50
*)
Compute pair "ERC721A_initial_block_43_0"%string (equiv_checker [DUP 3;POP;POP;DUP 3;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;Opcode MLOAD;PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x32%positive)] [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);DUP 4;Opcode ADD;Opcode MLOAD;PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x32%positive)] 5 optimize_id).

(*
 I: PUSH [tag] 51 PUSH [tag] 48
 O: PUSH [tag] 51 PUSH [tag] 48
*)
Compute pair "ERC721A_initial_block_44_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x33%positive);PUSH 1 (posToWord WLen 0x30%positive)] [PUSH 1 (posToWord WLen 0x33%positive);PUSH 1 (posToWord WLen 0x30%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 52 DUP6 DUP3 DUP7 ADD PUSH [tag] 36
 O: PUSH [tag] 52 DUP6 DUP3 DUP7 ADD PUSH [tag] 36
*)
Compute pair "ERC721A_initial_block_46_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x34%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0x24%positive)] [PUSH 1 (posToWord WLen 0x34%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0x24%positive)] 5 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute pair "ERC721A_initial_block_47_0"%string (equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 54 PUSH [tag] 55
 O: PUSH 0 PUSH [tag] 54 PUSH [tag] 55
*)
Compute pair "ERC721A_initial_block_48_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x36%positive);PUSH 1 (posToWord WLen 0x37%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x36%positive);PUSH 1 (posToWord WLen 0x37%positive)] 0 optimize_id).

(*
 I: SWAP1 POP PUSH [tag] 56 DUP3 DUP3 PUSH [tag] 57
 O: SWAP1 POP PUSH [tag] 56 DUP3 DUP3 PUSH [tag] 57
*)
Compute pair "ERC721A_initial_block_49_0"%string (equiv_checker [DUP 1;POP;PUSH 1 (posToWord WLen 0x38%positive);DUP 3;DUP 3;PUSH 1 (posToWord WLen 0x39%positive)] [DUP 1;POP;PUSH 1 (posToWord WLen 0x38%positive);DUP 3;DUP 3;PUSH 1 (posToWord WLen 0x39%positive)] 3 optimize_id).

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Compute pair "ERC721A_initial_block_50_0"%string (equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH 40 MLOAD SWAP1 POP SWAP1
 O: PUSH 40 MLOAD SWAP1
*)
Compute pair "ERC721A_initial_block_51_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;POP;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFF DUP3 GT ISZERO PUSH [tag] 60
 O: PUSH 0 PUSH ffffffffffffffff DUP3 GT ISZERO PUSH [tag] 60
*)
Compute pair "ERC721A_initial_block_52_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x3c%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x3c%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 61 PUSH [tag] 62
 O: PUSH [tag] 61 PUSH [tag] 62
*)
Compute pair "ERC721A_initial_block_53_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x3d%positive);PUSH 1 (posToWord WLen 0x3e%positive)] [PUSH 1 (posToWord WLen 0x3d%positive);PUSH 1 (posToWord WLen 0x3e%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 63 DUP3 PUSH [tag] 64
 O: PUSH [tag] 63 DUP3 PUSH [tag] 64
*)
Compute pair "ERC721A_initial_block_55_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x3f%positive);DUP 3;PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 1 (posToWord WLen 0x3f%positive);DUP 3;PUSH 1 (posToWord WLen 0x40%positive)] 2 optimize_id).

(*
 I: SWAP1 POP PUSH 20 DUP2 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP2 POP POP SWAP1
*)
Compute pair "ERC721A_initial_block_56_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;POP;POP;DUP 1] [DUP 1;POP;PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0
 O: PUSH 0
*)
Compute pair "ERC721A_initial_block_57_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: DUP4 DUP2 LT ISZERO PUSH [tag] 68
 O: DUP4 DUP2 LT ISZERO PUSH [tag] 68
*)
Compute pair "ERC721A_initial_block_58_0"%string (equiv_checker [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x44%positive)] [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x44%positive)] 4 optimize_id).

(*
 I: DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD
 O: DUP2 DUP2 ADD MLOAD DUP4 DUP3 ADD
*)
Compute pair "ERC721A_initial_block_59_0"%string (equiv_checker [DUP 2;DUP 2;Opcode ADD;Opcode MLOAD;DUP 4;DUP 3;Opcode ADD] [DUP 1;DUP 3;Opcode ADD;Opcode MLOAD;DUP 2;DUP 5;Opcode ADD] 3 optimize_id).

(*
 I: PUSH 20 DUP2 ADD SWAP1 POP PUSH [tag] 66
 O: PUSH 20 ADD PUSH [tag] 66
*)
Compute pair "ERC721A_initial_block_59_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x42%positive)] [PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;DUP 1;POP;PUSH 1 (posToWord WLen 0x42%positive)] 1 optimize_id).

(*
 I: DUP4 DUP2 GT ISZERO PUSH [tag] 69
 O: DUP4 DUP2 GT ISZERO PUSH [tag] 69
*)
Compute pair "ERC721A_initial_block_60_0"%string (equiv_checker [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x45%positive)] [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0x45%positive)] 4 optimize_id).

(*
 I: PUSH 0 DUP5 DUP5 ADD
 O: PUSH 0 DUP4 DUP6 ADD
*)
Compute pair "ERC721A_initial_block_61_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 6;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);DUP 5;DUP 5;Opcode ADD] 4 optimize_id).

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Compute pair "ERC721A_initial_block_62_0"%string (equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 2 DUP3 DIV SWAP1 POP PUSH 1 DUP3 AND DUP1 PUSH [tag] 71
 O: PUSH 2 DUP2 DIV DUP2 PUSH 1 AND DUP1 PUSH [tag] 71
*)
Compute pair "ERC721A_initial_block_63_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2%positive);DUP 2;Opcode DIV;DUP 2;PUSH 1 (posToWord WLen 0x1%positive);Opcode AND;DUP 1;PUSH 1 (posToWord WLen 0x47%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x2%positive);DUP 3;Opcode DIV;DUP 1;POP;PUSH 1 (posToWord WLen 0x1%positive);DUP 3;Opcode AND;DUP 1;PUSH 1 (posToWord WLen 0x47%positive)] 1 optimize_id).

(*
 I: PUSH 7F DUP3 AND SWAP2 POP
 O: SWAP1 PUSH 7f AND SWAP1
*)
Compute pair "ERC721A_initial_block_64_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x7f%positive);Opcode AND;DUP 1] [PUSH 1 (posToWord WLen 0x7F%positive);DUP 3;Opcode AND;DUP 2;POP] 2 optimize_id).

(*
 I: PUSH 20 DUP3 LT DUP2 EQ ISZERO PUSH [tag] 72
 O: DUP1 PUSH 20 DUP4 LT EQ ISZERO PUSH [tag] 72
*)
Compute pair "ERC721A_initial_block_65_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);DUP 4;Opcode LT;Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0x48%positive)] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode LT;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0x48%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 73 PUSH [tag] 74
 O: PUSH [tag] 73 PUSH [tag] 74
*)
Compute pair "ERC721A_initial_block_66_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x49%positive);PUSH 1 (posToWord WLen 0x4a%positive)] [PUSH 1 (posToWord WLen 0x49%positive);PUSH 1 (posToWord WLen 0x4a%positive)] 0 optimize_id).

(*
 I: POP SWAP2 SWAP1 POP
 O: POP SWAP2 SWAP1 POP
*)
Compute pair "ERC721A_initial_block_68_0"%string (equiv_checker [POP;DUP 2;DUP 1;POP] [POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH [tag] 76 DUP3 PUSH [tag] 64
 O: PUSH [tag] 76 DUP3 PUSH [tag] 64
*)
Compute pair "ERC721A_initial_block_69_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x4c%positive);DUP 3;PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 1 (posToWord WLen 0x4c%positive);DUP 3;PUSH 1 (posToWord WLen 0x40%positive)] 2 optimize_id).

(*
 I: DUP2 ADD DUP2 DUP2 LT PUSH FFFFFFFFFFFFFFFF DUP3 GT OR ISZERO PUSH [tag] 77
 O: DUP2 ADD PUSH ffffffffffffffff DUP2 GT DUP3 DUP3 LT OR ISZERO PUSH [tag] 77
*)
Compute pair "ERC721A_initial_block_70_0"%string (equiv_checker [DUP 2;Opcode ADD;PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 2;Opcode GT;DUP 3;DUP 3;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 1 (posToWord WLen 0x4d%positive)] [DUP 2;Opcode ADD;DUP 2;DUP 2;Opcode LT;PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);DUP 3;Opcode GT;Opcode OR;Opcode ISZERO;PUSH 1 (posToWord WLen 0x4d%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 78 PUSH [tag] 62
 O: PUSH [tag] 78 PUSH [tag] 62
*)
Compute pair "ERC721A_initial_block_71_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x4e%positive);PUSH 1 (posToWord WLen 0x3e%positive)] [PUSH 1 (posToWord WLen 0x4e%positive);PUSH 1 (posToWord WLen 0x3e%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 40
 O: DUP1 PUSH 40
*)
Compute pair "ERC721A_initial_block_73_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x40%positive)] 1 optimize_id).

(*
 I: POP POP POP
 O: POP POP POP
*)
Compute pair "ERC721A_initial_block_73_1"%string (equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id).

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Compute pair "ERC721A_initial_block_74_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x4e487b7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 32 (posToWord WLen 0x4E487B7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 22 PUSH 4
 O: PUSH 22 PUSH 4
*)
Compute pair "ERC721A_initial_block_74_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x22%positive);PUSH 1 (posToWord WLen 0x4%positive)] [PUSH 1 (posToWord WLen 0x22%positive);PUSH 1 (posToWord WLen 0x4%positive)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "ERC721A_initial_block_74_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Compute pair "ERC721A_initial_block_75_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x4e487b7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 32 (posToWord WLen 0x4E487B7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 41 PUSH 4
 O: PUSH 41 PUSH 4
*)
Compute pair "ERC721A_initial_block_75_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x41%positive);PUSH 1 (posToWord WLen 0x4%positive)] [PUSH 1 (posToWord WLen 0x41%positive);PUSH 1 (posToWord WLen 0x4%positive)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "ERC721A_initial_block_75_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_initial_block_76_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_initial_block_77_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_initial_block_78_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_initial_block_79_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 PUSH 1F NOT PUSH 1F DUP4 ADD AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 1f ADD PUSH 1f NOT AND SWAP1
*)
Compute pair "ERC721A_initial_block_80_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1f%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x1f%positive);Opcode NOT;Opcode AND;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x1F%positive);Opcode NOT;PUSH 1 (posToWord WLen 0x1F%positive);DUP 4;Opcode ADD;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH #[$] 0000000000000000000000000000000000000000000000000000000000000000 DUP1 PUSH [$] 0000000000000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH #[$] 0 DUP1 PUSH [$] 0 PUSH 0
  ERROR OCCURRED

'PUSH #[$]' is not in list
*)

(*
 I: PUSH 0
 O: PUSH 0
*)
Compute pair "ERC721A_initial_block_81_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 80 PUSH 40
 O: PUSH 80 PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_0_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x80%positive);PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 1 (posToWord WLen 0x80%positive);PUSH 1 (posToWord WLen 0x40%positive)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 1
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 1
*)
Compute pair "ERC721A_run_code_of_0_block_0_1"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (posToWord WLen 0x1%positive)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x1%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_1_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP PUSH 4 CALLDATASIZE LT PUSH [tag] 2
 O: POP PUSH 4 CALLDATASIZE LT PUSH [tag] 2
*)
Compute pair "ERC721A_run_code_of_0_block_2_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x4%positive);Opcode CALLDATASIZE;Opcode LT;PUSH 1 (posToWord WLen 0x2%positive)] [POP;PUSH 1 (posToWord WLen 0x4%positive);Opcode CALLDATASIZE;Opcode LT;PUSH 1 (posToWord WLen 0x2%positive)] 1 optimize_id).

(*
 I: PUSH 0 CALLDATALOAD PUSH E0 SHR DUP1 PUSH 6352211E GT PUSH [tag] 17
 O: PUSH 0 CALLDATALOAD PUSH e0 SHR DUP1 PUSH 6352211e GT PUSH [tag] 17
*)
Compute pair "ERC721A_run_code_of_0_block_3_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);Opcode CALLDATALOAD;PUSH 1 (posToWord WLen 0xe0%positive);Opcode SHR;DUP 1;PUSH 4 (posToWord WLen 0x6352211e%positive);Opcode GT;PUSH 1 (posToWord WLen 0x11%positive)] [PUSH 1 (posToWord WLen 0x0%positive);Opcode CALLDATALOAD;PUSH 1 (posToWord WLen 0xE0%positive);Opcode SHR;DUP 1;PUSH 4 (posToWord WLen 0x6352211E%positive);Opcode GT;PUSH 1 (posToWord WLen 0x11%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH A22CB465 GT PUSH [tag] 18
 O: DUP1 PUSH a22cb465 GT PUSH [tag] 18
*)
Compute pair "ERC721A_run_code_of_0_block_4_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xa22cb465%positive);Opcode GT;PUSH 1 (posToWord WLen 0x12%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xA22CB465%positive);Opcode GT;PUSH 1 (posToWord WLen 0x12%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH A22CB465 EQ PUSH [tag] 13
 O: DUP1 PUSH a22cb465 EQ PUSH [tag] 13
*)
Compute pair "ERC721A_run_code_of_0_block_5_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xa22cb465%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xd%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xA22CB465%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xd%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH B88D4FDE EQ PUSH [tag] 14
 O: DUP1 PUSH b88d4fde EQ PUSH [tag] 14
*)
Compute pair "ERC721A_run_code_of_0_block_6_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xb88d4fde%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xe%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xB88D4FDE%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xe%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH C87B56DD EQ PUSH [tag] 15
 O: DUP1 PUSH c87b56dd EQ PUSH [tag] 15
*)
Compute pair "ERC721A_run_code_of_0_block_7_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xc87b56dd%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xf%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xC87B56DD%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xf%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH E985E9C5 EQ PUSH [tag] 16
 O: DUP1 PUSH e985e9c5 EQ PUSH [tag] 16
*)
Compute pair "ERC721A_run_code_of_0_block_8_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0xe985e9c5%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x10%positive)] [DUP 1;PUSH 4 (posToWord WLen 0xE985E9C5%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x10%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 2
 O: PUSH [tag] 2
*)
Compute pair "ERC721A_run_code_of_0_block_9_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2%positive)] [PUSH 1 (posToWord WLen 0x2%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 6352211E EQ PUSH [tag] 10
 O: DUP1 PUSH 6352211e EQ PUSH [tag] 10
*)
Compute pair "ERC721A_run_code_of_0_block_10_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x6352211e%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xa%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x6352211E%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xa%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 70A08231 EQ PUSH [tag] 11
 O: DUP1 PUSH 70a08231 EQ PUSH [tag] 11
*)
Compute pair "ERC721A_run_code_of_0_block_11_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x70a08231%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xb%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x70A08231%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xb%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 95D89B41 EQ PUSH [tag] 12
 O: DUP1 PUSH 95d89b41 EQ PUSH [tag] 12
*)
Compute pair "ERC721A_run_code_of_0_block_12_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x95d89b41%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xc%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x95D89B41%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xc%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 2
 O: PUSH [tag] 2
*)
Compute pair "ERC721A_run_code_of_0_block_13_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2%positive)] [PUSH 1 (posToWord WLen 0x2%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 95EA7B3 GT PUSH [tag] 19
 O: DUP1 PUSH 95ea7b3 GT PUSH [tag] 19
*)
Compute pair "ERC721A_run_code_of_0_block_14_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x95ea7b3%positive);Opcode GT;PUSH 1 (posToWord WLen 0x13%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x95EA7B3%positive);Opcode GT;PUSH 1 (posToWord WLen 0x13%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 95EA7B3 EQ PUSH [tag] 6
 O: DUP1 PUSH 95ea7b3 EQ PUSH [tag] 6
*)
Compute pair "ERC721A_run_code_of_0_block_15_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x95ea7b3%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x6%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x95EA7B3%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x6%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 18160DDD EQ PUSH [tag] 7
 O: DUP1 PUSH 18160ddd EQ PUSH [tag] 7
*)
Compute pair "ERC721A_run_code_of_0_block_16_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x18160ddd%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x7%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x18160DDD%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x7%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 23B872DD EQ PUSH [tag] 8
 O: DUP1 PUSH 23b872dd EQ PUSH [tag] 8
*)
Compute pair "ERC721A_run_code_of_0_block_17_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x23b872dd%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x8%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x23B872DD%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x8%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 42842E0E EQ PUSH [tag] 9
 O: DUP1 PUSH 42842e0e EQ PUSH [tag] 9
*)
Compute pair "ERC721A_run_code_of_0_block_18_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x42842e0e%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x9%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x42842E0E%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x9%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 2
 O: PUSH [tag] 2
*)
Compute pair "ERC721A_run_code_of_0_block_19_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2%positive)] [PUSH 1 (posToWord WLen 0x2%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 1FFC9A7 EQ PUSH [tag] 3
 O: DUP1 PUSH 1ffc9a7 EQ PUSH [tag] 3
*)
Compute pair "ERC721A_run_code_of_0_block_20_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x1ffc9a7%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x3%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x1FFC9A7%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x3%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 6FDDE03 EQ PUSH [tag] 4
 O: DUP1 PUSH 6fdde03 EQ PUSH [tag] 4
*)
Compute pair "ERC721A_run_code_of_0_block_21_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x6fdde03%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x4%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x6FDDE03%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x4%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 81812FC EQ PUSH [tag] 5
 O: DUP1 PUSH 81812fc EQ PUSH [tag] 5
*)
Compute pair "ERC721A_run_code_of_0_block_22_0"%string (equiv_checker [DUP 1;PUSH 4 (posToWord WLen 0x81812fc%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x5%positive)] [DUP 1;PUSH 4 (posToWord WLen 0x81812FC%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x5%positive)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_23_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 20 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 21 SWAP2 SWAP1 PUSH [tag] 22
 O: PUSH [tag] 20 PUSH [tag] 21 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 22
*)
Compute pair "ERC721A_run_code_of_0_block_24_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x14%positive);PUSH 1 (posToWord WLen 0x15%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x16%positive)] [PUSH 1 (posToWord WLen 0x14%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x15%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x16%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 23
 O: PUSH [tag] 23
*)
Compute pair "ERC721A_run_code_of_0_block_25_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x17%positive)] [PUSH 1 (posToWord WLen 0x17%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 24 SWAP2 SWAP1 PUSH [tag] 25
 O: PUSH [tag] 24 SWAP1 PUSH 40 MLOAD PUSH [tag] 25
*)
Compute pair "ERC721A_run_code_of_0_block_26_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x18%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x19%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x18%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x19%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_27_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH [tag] 26 PUSH [tag] 27
 O: PUSH [tag] 26 PUSH [tag] 27
*)
Compute pair "ERC721A_run_code_of_0_block_28_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1a%positive);PUSH 1 (posToWord WLen 0x1b%positive)] [PUSH 1 (posToWord WLen 0x1a%positive);PUSH 1 (posToWord WLen 0x1b%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 28 SWAP2 SWAP1 PUSH [tag] 29
 O: PUSH [tag] 28 SWAP1 PUSH 40 MLOAD PUSH [tag] 29
*)
Compute pair "ERC721A_run_code_of_0_block_29_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1c%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x1d%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x1c%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x1d%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_30_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH [tag] 30 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 31 SWAP2 SWAP1 PUSH [tag] 32
 O: PUSH [tag] 30 PUSH [tag] 31 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 32
*)
Compute pair "ERC721A_run_code_of_0_block_31_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1e%positive);PUSH 1 (posToWord WLen 0x1f%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x20%positive)] [PUSH 1 (posToWord WLen 0x1e%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x20%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 33
 O: PUSH [tag] 33
*)
Compute pair "ERC721A_run_code_of_0_block_32_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x21%positive)] [PUSH 1 (posToWord WLen 0x21%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 34 SWAP2 SWAP1 PUSH [tag] 35
 O: PUSH [tag] 34 SWAP1 PUSH 40 MLOAD PUSH [tag] 35
*)
Compute pair "ERC721A_run_code_of_0_block_33_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x22%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x23%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x22%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x23%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_34_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH [tag] 36 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 37 SWAP2 SWAP1 PUSH [tag] 38
 O: PUSH [tag] 36 PUSH [tag] 37 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 38
*)
Compute pair "ERC721A_run_code_of_0_block_35_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x25%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x26%positive)] [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x25%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x26%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 39
 O: PUSH [tag] 39
*)
Compute pair "ERC721A_run_code_of_0_block_36_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x27%positive)] [PUSH 1 (posToWord WLen 0x27%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 40 PUSH [tag] 41
 O: PUSH [tag] 40 PUSH [tag] 41
*)
Compute pair "ERC721A_run_code_of_0_block_38_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x28%positive);PUSH 1 (posToWord WLen 0x29%positive)] [PUSH 1 (posToWord WLen 0x28%positive);PUSH 1 (posToWord WLen 0x29%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 42 SWAP2 SWAP1 PUSH [tag] 43
 O: PUSH [tag] 42 SWAP1 PUSH 40 MLOAD PUSH [tag] 43
*)
Compute pair "ERC721A_run_code_of_0_block_39_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2a%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x2b%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x2a%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x2b%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_40_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH [tag] 44 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 45 SWAP2 SWAP1 PUSH [tag] 46
 O: PUSH [tag] 44 PUSH [tag] 45 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 46
*)
Compute pair "ERC721A_run_code_of_0_block_41_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2c%positive);PUSH 1 (posToWord WLen 0x2d%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x2e%positive)] [PUSH 1 (posToWord WLen 0x2c%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x2d%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x2e%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 47
 O: PUSH [tag] 47
*)
Compute pair "ERC721A_run_code_of_0_block_42_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2f%positive)] [PUSH 1 (posToWord WLen 0x2f%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 48 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 49 SWAP2 SWAP1 PUSH [tag] 46
 O: PUSH [tag] 48 PUSH [tag] 49 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 46
*)
Compute pair "ERC721A_run_code_of_0_block_44_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x30%positive);PUSH 1 (posToWord WLen 0x31%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x2e%positive)] [PUSH 1 (posToWord WLen 0x30%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x31%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x2e%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 50
 O: PUSH [tag] 50
*)
Compute pair "ERC721A_run_code_of_0_block_45_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x32%positive)] [PUSH 1 (posToWord WLen 0x32%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 51 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 52 SWAP2 SWAP1 PUSH [tag] 32
 O: PUSH [tag] 51 PUSH [tag] 52 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 32
*)
Compute pair "ERC721A_run_code_of_0_block_47_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x33%positive);PUSH 1 (posToWord WLen 0x34%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x20%positive)] [PUSH 1 (posToWord WLen 0x33%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x34%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x20%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 53
 O: PUSH [tag] 53
*)
Compute pair "ERC721A_run_code_of_0_block_48_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x35%positive)] [PUSH 1 (posToWord WLen 0x35%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 54 SWAP2 SWAP1 PUSH [tag] 35
 O: PUSH [tag] 54 SWAP1 PUSH 40 MLOAD PUSH [tag] 35
*)
Compute pair "ERC721A_run_code_of_0_block_49_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x36%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x23%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x36%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x23%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_50_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH [tag] 55 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 56 SWAP2 SWAP1 PUSH [tag] 57
 O: PUSH [tag] 55 PUSH [tag] 56 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 57
*)
Compute pair "ERC721A_run_code_of_0_block_51_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x37%positive);PUSH 1 (posToWord WLen 0x38%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x39%positive)] [PUSH 1 (posToWord WLen 0x37%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x38%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x39%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 58
 O: PUSH [tag] 58
*)
Compute pair "ERC721A_run_code_of_0_block_52_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x3a%positive)] [PUSH 1 (posToWord WLen 0x3a%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 59 SWAP2 SWAP1 PUSH [tag] 43
 O: PUSH [tag] 59 SWAP1 PUSH 40 MLOAD PUSH [tag] 43
*)
Compute pair "ERC721A_run_code_of_0_block_53_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x3b%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x2b%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x3b%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x2b%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_54_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH [tag] 60 PUSH [tag] 61
 O: PUSH [tag] 60 PUSH [tag] 61
*)
Compute pair "ERC721A_run_code_of_0_block_55_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x3c%positive);PUSH 1 (posToWord WLen 0x3d%positive)] [PUSH 1 (posToWord WLen 0x3c%positive);PUSH 1 (posToWord WLen 0x3d%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 62 SWAP2 SWAP1 PUSH [tag] 29
 O: PUSH [tag] 62 SWAP1 PUSH 40 MLOAD PUSH [tag] 29
*)
Compute pair "ERC721A_run_code_of_0_block_56_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x3e%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x1d%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x3e%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x1d%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_57_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH [tag] 63 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 64 SWAP2 SWAP1 PUSH [tag] 65
 O: PUSH [tag] 63 PUSH [tag] 64 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 65
*)
Compute pair "ERC721A_run_code_of_0_block_58_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x3f%positive);PUSH 1 (posToWord WLen 0x40%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x41%positive)] [PUSH 1 (posToWord WLen 0x3f%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x41%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 66
 O: PUSH [tag] 66
*)
Compute pair "ERC721A_run_code_of_0_block_59_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x42%positive)] [PUSH 1 (posToWord WLen 0x42%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 67 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 68 SWAP2 SWAP1 PUSH [tag] 69
 O: PUSH [tag] 67 PUSH [tag] 68 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 69
*)
Compute pair "ERC721A_run_code_of_0_block_61_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x43%positive);PUSH 1 (posToWord WLen 0x44%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x45%positive)] [PUSH 1 (posToWord WLen 0x43%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x44%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x45%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 70
 O: PUSH [tag] 70
*)
Compute pair "ERC721A_run_code_of_0_block_62_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x46%positive)] [PUSH 1 (posToWord WLen 0x46%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 71 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 72 SWAP2 SWAP1 PUSH [tag] 32
 O: PUSH [tag] 71 PUSH [tag] 72 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 32
*)
Compute pair "ERC721A_run_code_of_0_block_64_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x47%positive);PUSH 1 (posToWord WLen 0x48%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x20%positive)] [PUSH 1 (posToWord WLen 0x47%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x48%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x20%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 73
 O: PUSH [tag] 73
*)
Compute pair "ERC721A_run_code_of_0_block_65_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x49%positive)] [PUSH 1 (posToWord WLen 0x49%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 74 SWAP2 SWAP1 PUSH [tag] 29
 O: PUSH [tag] 74 SWAP1 PUSH 40 MLOAD PUSH [tag] 29
*)
Compute pair "ERC721A_run_code_of_0_block_66_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x4a%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x1d%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x4a%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x1d%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_67_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH [tag] 75 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 76 SWAP2 SWAP1 PUSH [tag] 77
 O: PUSH [tag] 75 PUSH [tag] 76 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 77
*)
Compute pair "ERC721A_run_code_of_0_block_68_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x4b%positive);PUSH 1 (posToWord WLen 0x4c%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x4d%positive)] [PUSH 1 (posToWord WLen 0x4b%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x4c%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x4d%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 78
 O: PUSH [tag] 78
*)
Compute pair "ERC721A_run_code_of_0_block_69_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x4e%positive)] [PUSH 1 (posToWord WLen 0x4e%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 79 SWAP2 SWAP1 PUSH [tag] 25
 O: PUSH [tag] 79 SWAP1 PUSH 40 MLOAD PUSH [tag] 25
*)
Compute pair "ERC721A_run_code_of_0_block_70_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x4f%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x19%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x4f%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x19%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_71_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 PUSH 1FFC9A7 PUSH E0 SHL DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ DUP1 PUSH [tag] 81
 O: PUSH 0 PUSH 1ffc9a7 PUSH e0 SHL PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT DUP4 AND EQ DUP1 PUSH [tag] 81
*)
Compute pair "ERC721A_run_code_of_0_block_72_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 4 (posToWord WLen 0x1ffc9a7%positive);PUSH 1 (posToWord WLen 0xe0%positive);Opcode SHL;PUSH 28 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff%positive);Opcode NOT;DUP 4;Opcode AND;Opcode EQ;DUP 1;PUSH 1 (posToWord WLen 0x51%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 4 (posToWord WLen 0x1FFC9A7%positive);PUSH 1 (posToWord WLen 0xE0%positive);Opcode SHL;DUP 3;PUSH 28 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode NOT;Opcode AND;Opcode EQ;DUP 1;PUSH 1 (posToWord WLen 0x51%positive)] 1 optimize_id).

(*
 I: POP PUSH 80AC58CD PUSH E0 SHL DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ
 O: POP PUSH 80ac58cd PUSH e0 SHL DUP3 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT AND EQ
*)
Compute pair "ERC721A_run_code_of_0_block_73_0"%string (equiv_checker [POP;PUSH 4 (posToWord WLen 0x80ac58cd%positive);PUSH 1 (posToWord WLen 0xe0%positive);Opcode SHL;DUP 3;PUSH 28 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff%positive);Opcode NOT;Opcode AND;Opcode EQ] [POP;PUSH 4 (posToWord WLen 0x80AC58CD%positive);PUSH 1 (posToWord WLen 0xE0%positive);Opcode SHL;DUP 3;PUSH 28 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode NOT;Opcode AND;Opcode EQ] 3 optimize_id).

(*
 I: DUP1 PUSH [tag] 82
 O: DUP1 PUSH [tag] 82
*)
Compute pair "ERC721A_run_code_of_0_block_74_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x52%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x52%positive)] 1 optimize_id).

(*
 I: POP PUSH 5B5E139F PUSH E0 SHL DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ
 O: POP PUSH 5b5e139f PUSH e0 SHL DUP3 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT AND EQ
*)
Compute pair "ERC721A_run_code_of_0_block_75_0"%string (equiv_checker [POP;PUSH 4 (posToWord WLen 0x5b5e139f%positive);PUSH 1 (posToWord WLen 0xe0%positive);Opcode SHL;DUP 3;PUSH 28 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff%positive);Opcode NOT;Opcode AND;Opcode EQ] [POP;PUSH 4 (posToWord WLen 0x5B5E139F%positive);PUSH 1 (posToWord WLen 0xE0%positive);Opcode SHL;DUP 3;PUSH 28 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode NOT;Opcode AND;Opcode EQ] 3 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_76_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 60 PUSH 2 DUP1 SLOAD PUSH [tag] 84 SWAP1 PUSH [tag] 85
 O: PUSH 60 PUSH 2 PUSH [tag] 84 DUP2 SLOAD PUSH [tag] 85
*)
Compute pair "ERC721A_run_code_of_0_block_77_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x2%positive);PUSH 1 (posToWord WLen 0x54%positive);DUP 2;Opcode SLOAD;PUSH 1 (posToWord WLen 0x55%positive)] [PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x2%positive);DUP 1;Opcode SLOAD;PUSH 1 (posToWord WLen 0x54%positive);DUP 1;PUSH 1 (posToWord WLen 0x55%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_78_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 1 optimize_id).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute pair "ERC721A_run_code_of_0_block_78_1"%string (equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 86 SWAP1 PUSH [tag] 85
 O: PUSH 20 ADD DUP3 PUSH [tag] 86 DUP5 SLOAD PUSH [tag] 85
*)
Compute pair "ERC721A_run_code_of_0_block_78_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;PUSH 1 (posToWord WLen 0x56%positive);DUP 5;Opcode SLOAD;PUSH 1 (posToWord WLen 0x55%positive)] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (posToWord WLen 0x56%positive);DUP 1;PUSH 1 (posToWord WLen 0x55%positive)] 3 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 87
 O: DUP1 ISZERO PUSH [tag] 87
*)
Compute pair "ERC721A_run_code_of_0_block_79_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x57%positive)] [DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x57%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 88
 O: DUP1 PUSH 1f LT PUSH [tag] 88
*)
Compute pair "ERC721A_run_code_of_0_block_80_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);Opcode LT;PUSH 1 (posToWord WLen 0x58%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode LT;PUSH 1 (posToWord WLen 0x58%positive)] 1 optimize_id).

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Compute pair "ERC721A_run_code_of_0_block_81_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x100%positive);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (posToWord WLen 0x100%positive);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 87
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 87
*)
Compute pair "ERC721A_run_code_of_0_block_81_1"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 1 (posToWord WLen 0x57%positive)] [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 1 (posToWord WLen 0x57%positive)] 3 optimize_id).

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Compute pair "ERC721A_run_code_of_0_block_82_0"%string (equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] 3 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_82_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] 1 optimize_id).

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_83_0"%string (equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id).

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 89
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 89
*)
Compute pair "ERC721A_run_code_of_0_block_83_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (posToWord WLen 0x59%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (posToWord WLen 0x59%positive)] 3 optimize_id).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute pair "ERC721A_run_code_of_0_block_84_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1f%positive);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (posToWord WLen 0x1F%positive);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id).

(*
 I: POP POP POP POP POP SWAP1 POP SWAP1
 O: POP POP POP POP POP SWAP2 SWAP1 POP
*)
Compute pair "ERC721A_run_code_of_0_block_85_0"%string (equiv_checker [POP;POP;POP;POP;POP;DUP 2;DUP 1;POP] [POP;POP;POP;POP;POP;DUP 1;POP;DUP 1] 8 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 91 DUP3 PUSH [tag] 92
 O: PUSH 0 PUSH [tag] 91 DUP3 PUSH [tag] 92
*)
Compute pair "ERC721A_run_code_of_0_block_86_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x5b%positive);DUP 3;PUSH 1 (posToWord WLen 0x5c%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x5b%positive);DUP 3;PUSH 1 (posToWord WLen 0x5c%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 93
 O: PUSH [tag] 93
*)
Compute pair "ERC721A_run_code_of_0_block_87_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x5d%positive)] [PUSH 1 (posToWord WLen 0x5d%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH CF4700E400000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH cf4700e400000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_88_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xcf4700e400000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xCF4700E400000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_88_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 6 PUSH 0 DUP4 DUP2
 O: PUSH 6 PUSH 0 DUP4 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_89_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x6%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 2] [PUSH 1 (posToWord WLen 0x6%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_89_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 ADD PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 SWAP2 POP ADD PUSH 0 SWAP1 DUP2 DUP1 PUSH 100 EXP SWAP4 POP KECCAK256 ADD SLOAD DIV PUSH ffffffffffffffffffffffffffffffffffffffff AND SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_89_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);DUP 2;POP;Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);DUP 1;DUP 2;DUP 1;PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 4;POP;Opcode KECCAK256;Opcode ADD;Opcode SLOAD;Opcode DIV;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 1;Opcode DIV;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 95 DUP3 PUSH [tag] 53
 O: PUSH 0 PUSH [tag] 95 DUP3 PUSH [tag] 53
*)
Compute pair "ERC721A_run_code_of_0_block_90_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x5f%positive);DUP 3;PUSH 1 (posToWord WLen 0x35%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x5f%positive);DUP 3;PUSH 1 (posToWord WLen 0x35%positive)] 1 optimize_id).

(*
 I: SWAP1 POP DUP1 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH [tag] 96 PUSH [tag] 97
 O: DUP1 SWAP2 POP PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH [tag] 96 PUSH [tag] 97
*)
Compute pair "ERC721A_run_code_of_0_block_91_0"%string (equiv_checker [DUP 1;DUP 2;POP;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x61%positive)] [DUP 1;POP;DUP 1;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x61%positive)] 2 optimize_id).

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ PUSH [tag] 98
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ PUSH [tag] 98
*)
Compute pair "ERC721A_run_code_of_0_block_92_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;Opcode EQ;PUSH 1 (posToWord WLen 0x62%positive)] [PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode EQ;PUSH 1 (posToWord WLen 0x62%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 99 DUP2 PUSH [tag] 100 PUSH [tag] 97
 O: PUSH [tag] 99 DUP2 PUSH [tag] 100 PUSH [tag] 97
*)
Compute pair "ERC721A_run_code_of_0_block_93_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x63%positive);DUP 2;PUSH 1 (posToWord WLen 0x64%positive);PUSH 1 (posToWord WLen 0x61%positive)] [PUSH 1 (posToWord WLen 0x63%positive);DUP 2;PUSH 1 (posToWord WLen 0x64%positive);PUSH 1 (posToWord WLen 0x61%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 78
 O: PUSH [tag] 78
*)
Compute pair "ERC721A_run_code_of_0_block_94_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x4e%positive)] [PUSH 1 (posToWord WLen 0x4e%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 101
 O: PUSH [tag] 101
*)
Compute pair "ERC721A_run_code_of_0_block_95_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x65%positive)] [PUSH 1 (posToWord WLen 0x65%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH CFB3B94200000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH cfb3b94200000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_96_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xcfb3b94200000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xCFB3B94200000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_96_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: DUP3 PUSH 6 PUSH 0 DUP5 DUP2
 O: DUP3 PUSH 6 PUSH 0 DUP5 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_98_0"%string (equiv_checker [DUP 3;PUSH 1 (posToWord WLen 0x6%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 5;DUP 2] [DUP 3;PUSH 1 (posToWord WLen 0x6%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 5;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_98_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 ADD PUSH 0 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF MUL NOT AND SWAP1 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND MUL OR SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 ADD PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 PUSH 100 EXP DUP3 SLOAD DUP2 DUP4 MUL NOT AND SWAP2 DUP5 AND MUL OR SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_98_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 3;Opcode SLOAD;DUP 2;DUP 4;Opcode MUL;Opcode NOT;Opcode AND;DUP 2;DUP 5;Opcode AND;Opcode MUL;Opcode OR;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode MUL;Opcode NOT;Opcode AND;DUP 1;DUP 4;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode MUL;Opcode OR;DUP 1] 2 optimize_id).

(*
 I: POP DUP2 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B925 PUSH 40 MLOAD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: POP PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 40 MLOAD DUP5 DUP3 AND PUSH 8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925 DUP3 DUP1 SUB DUP6 DUP8 SWAP6 AND SWAP3 SWAP4
*)
Compute pair "ERC721A_run_code_of_0_block_98_3"%string (equiv_checker [POP;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 5;DUP 3;Opcode AND;PUSH 32 (posToWord WLen 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925%positive);DUP 3;DUP 1;Opcode SUB;DUP 6;DUP 8;DUP 6;Opcode AND;DUP 3;DUP 4] [POP;DUP 2;DUP 4;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 3;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 32 (posToWord WLen 0x8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B925%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 4 optimize_id).

(*
 I: POP POP POP
 O: POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_98_4"%string (equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 103 PUSH [tag] 104
 O: PUSH 0 PUSH [tag] 103 PUSH [tag] 104
*)
Compute pair "ERC721A_run_code_of_0_block_99_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x67%positive);PUSH 1 (posToWord WLen 0x68%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x67%positive);PUSH 1 (posToWord WLen 0x68%positive)] 0 optimize_id).

(*
 I: PUSH 1 SLOAD PUSH 0 SLOAD SUB SUB SWAP1 POP SWAP1
 O: PUSH 1 SLOAD PUSH 0 SLOAD SUB SUB SWAP2 SWAP1 POP
*)
Compute pair "ERC721A_run_code_of_0_block_100_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive);Opcode SLOAD;PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;Opcode SUB;Opcode SUB;DUP 2;DUP 1;POP] [PUSH 1 (posToWord WLen 0x1%positive);Opcode SLOAD;PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;Opcode SUB;Opcode SUB;DUP 1;POP;DUP 1] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 106 DUP3 PUSH [tag] 107
 O: PUSH 0 PUSH [tag] 106 DUP3 PUSH [tag] 107
*)
Compute pair "ERC721A_run_code_of_0_block_101_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x6a%positive);DUP 3;PUSH 1 (posToWord WLen 0x6b%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x6a%positive);DUP 3;PUSH 1 (posToWord WLen 0x6b%positive)] 1 optimize_id).

(*
 I: SWAP1 POP DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ PUSH [tag] 108
 O: SWAP1 POP DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 AND EQ PUSH [tag] 108
*)
Compute pair "ERC721A_run_code_of_0_block_102_0"%string (equiv_checker [DUP 1;POP;DUP 4;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 3;Opcode AND;Opcode EQ;PUSH 1 (posToWord WLen 0x6c%positive)] [DUP 1;POP;DUP 4;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode EQ;PUSH 1 (posToWord WLen 0x6c%positive)] 5 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH A114810000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH a114810000000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_103_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xa114810000000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xA114810000000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_103_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH [tag] 109 DUP5 PUSH [tag] 110
 O: PUSH 0 DUP1 PUSH [tag] 109 DUP5 PUSH [tag] 110
*)
Compute pair "ERC721A_run_code_of_0_block_104_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x6d%positive);DUP 5;PUSH 1 (posToWord WLen 0x6e%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x6d%positive);DUP 5;PUSH 1 (posToWord WLen 0x6e%positive)] 2 optimize_id).

(*
 I: SWAP2 POP SWAP2 POP PUSH [tag] 111 DUP2 DUP8 PUSH [tag] 112 PUSH [tag] 97
 O: SWAP2 POP SWAP2 POP PUSH [tag] 111 DUP2 DUP8 PUSH [tag] 112 PUSH [tag] 97
*)
Compute pair "ERC721A_run_code_of_0_block_105_0"%string (equiv_checker [DUP 2;POP;DUP 2;POP;PUSH 1 (posToWord WLen 0x6f%positive);DUP 2;DUP 8;PUSH 1 (posToWord WLen 0x70%positive);PUSH 1 (posToWord WLen 0x61%positive)] [DUP 2;POP;DUP 2;POP;PUSH 1 (posToWord WLen 0x6f%positive);DUP 2;DUP 8;PUSH 1 (posToWord WLen 0x70%positive);PUSH 1 (posToWord WLen 0x61%positive)] 8 optimize_id).

(*
 I: PUSH [tag] 113
 O: PUSH [tag] 113
*)
Compute pair "ERC721A_run_code_of_0_block_106_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x71%positive)] [PUSH 1 (posToWord WLen 0x71%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 114
 O: PUSH [tag] 114
*)
Compute pair "ERC721A_run_code_of_0_block_107_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x72%positive)] [PUSH 1 (posToWord WLen 0x72%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 115 DUP7 PUSH [tag] 116 PUSH [tag] 97
 O: PUSH [tag] 115 DUP7 PUSH [tag] 116 PUSH [tag] 97
*)
Compute pair "ERC721A_run_code_of_0_block_108_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x73%positive);DUP 7;PUSH 1 (posToWord WLen 0x74%positive);PUSH 1 (posToWord WLen 0x61%positive)] [PUSH 1 (posToWord WLen 0x73%positive);DUP 7;PUSH 1 (posToWord WLen 0x74%positive);PUSH 1 (posToWord WLen 0x61%positive)] 6 optimize_id).

(*
 I: PUSH [tag] 78
 O: PUSH [tag] 78
*)
Compute pair "ERC721A_run_code_of_0_block_109_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x4e%positive)] [PUSH 1 (posToWord WLen 0x4e%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 117
 O: PUSH [tag] 117
*)
Compute pair "ERC721A_run_code_of_0_block_110_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x75%positive)] [PUSH 1 (posToWord WLen 0x75%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 59C896BE00000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 59c896be00000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_111_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x59c896be00000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x59C896BE00000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_111_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 118
 O: PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 AND PUSH ffffffffffffffffffffffffffffffffffffffff DUP7 AND EQ ISZERO PUSH [tag] 118
*)
Compute pair "ERC721A_run_code_of_0_block_113_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode AND;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 7;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0x76%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 6;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0x76%positive)] 5 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH EA553B3400000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH ea553b3400000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_114_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xea553b3400000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xEA553B3400000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_114_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH [tag] 119 DUP7 DUP7 DUP7 PUSH 1 PUSH [tag] 120
 O: PUSH [tag] 119 DUP7 DUP7 DUP7 PUSH 1 PUSH [tag] 120
*)
Compute pair "ERC721A_run_code_of_0_block_115_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x77%positive);DUP 7;DUP 7;DUP 7;PUSH 1 (posToWord WLen 0x1%positive);PUSH 1 (posToWord WLen 0x78%positive)] [PUSH 1 (posToWord WLen 0x77%positive);DUP 7;DUP 7;DUP 7;PUSH 1 (posToWord WLen 0x1%positive);PUSH 1 (posToWord WLen 0x78%positive)] 6 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 121
 O: DUP1 ISZERO PUSH [tag] 121
*)
Compute pair "ERC721A_run_code_of_0_block_116_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x79%positive)] [DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x79%positive)] 1 optimize_id).

(*
 I: PUSH 0 DUP3
 O: PUSH 0 DUP3
*)
Compute pair "ERC721A_run_code_of_0_block_117_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 3] [PUSH 1 (posToWord WLen 0x0%positive);DUP 3] 2 optimize_id).

(*
 I: PUSH 5 PUSH 0 DUP8 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 5 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP9 AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_118_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x5%positive);PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 9;Opcode AND;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 2] [PUSH 1 (posToWord WLen 0x5%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 8;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 6 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_118_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP2 SLOAD PUSH 1 SWAP1 SUB SWAP2 SWAP1 POP DUP2 SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 1 DUP2 SLOAD SUB DUP1 SWAP2
*)
Compute pair "ERC721A_run_code_of_0_block_118_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x1%positive);DUP 2;Opcode SLOAD;Opcode SUB;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode SLOAD;PUSH 1 (posToWord WLen 0x1%positive);DUP 1;Opcode SUB;DUP 2;DUP 1;POP;DUP 2;DUP 1] 1 optimize_id).

(*
 I: POP PUSH 5 PUSH 0 DUP7 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: POP PUSH 5 PUSH 0 DUP7 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_118_3"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x5%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 7;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 2] [POP;PUSH 1 (posToWord WLen 0x5%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 7;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 6 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_118_4"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP2 SLOAD PUSH 1 ADD SWAP2 SWAP1 POP DUP2 SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 1 DUP2 SLOAD ADD DUP1 SWAP2
*)
Compute pair "ERC721A_run_code_of_0_block_118_5"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x1%positive);DUP 2;Opcode SLOAD;Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode SLOAD;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 2;DUP 1;POP;DUP 2;DUP 1] 1 optimize_id).

(*
 I: POP PUSH [tag] 122 DUP6 PUSH [tag] 123 DUP9 DUP9 DUP8 PUSH [tag] 124
 O: POP PUSH [tag] 122 DUP6 PUSH [tag] 123 DUP9 DUP3 DUP8 PUSH [tag] 124
*)
Compute pair "ERC721A_run_code_of_0_block_118_6"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x7a%positive);DUP 6;PUSH 1 (posToWord WLen 0x7b%positive);DUP 9;DUP 3;DUP 8;PUSH 1 (posToWord WLen 0x7c%positive)] [POP;PUSH 1 (posToWord WLen 0x7a%positive);DUP 6;PUSH 1 (posToWord WLen 0x7b%positive);DUP 9;DUP 9;DUP 8;PUSH 1 (posToWord WLen 0x7c%positive)] 7 optimize_id).

(*
 I: PUSH 200000000000000000000000000000000000000000000000000000000 OR PUSH [tag] 125
 O: PUSH 200000000000000000000000000000000000000000000000000000000 OR PUSH [tag] 125
*)
Compute pair "ERC721A_run_code_of_0_block_119_0"%string (equiv_checker [PUSH 29 (posToWord WLen 0x200000000000000000000000000000000000000000000000000000000%positive);Opcode OR;PUSH 1 (posToWord WLen 0x7d%positive)] [PUSH 29 (posToWord WLen 0x200000000000000000000000000000000000000000000000000000000%positive);Opcode OR;PUSH 1 (posToWord WLen 0x7d%positive)] 1 optimize_id).

(*
 I: PUSH 4 PUSH 0 DUP7 DUP2
 O: PUSH 4 PUSH 0 DUP7 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_120_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 7;DUP 2] [PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 7;DUP 2] 5 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_120_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 DUP2 SWAP1
 O: DUP2 SWAP1 PUSH 20 ADD PUSH 0 KECCAK256
*)
Compute pair "ERC721A_run_code_of_0_block_120_2"%string (equiv_checker [DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 2;DUP 1] 2 optimize_id).

(*
 I: POP PUSH 0 PUSH 200000000000000000000000000000000000000000000000000000000 DUP5 AND EQ ISZERO PUSH [tag] 126
 O: POP PUSH 200000000000000000000000000000000000000000000000000000000 DUP4 AND PUSH 0 EQ ISZERO PUSH [tag] 126
*)
Compute pair "ERC721A_run_code_of_0_block_120_3"%string (equiv_checker [POP;PUSH 29 (posToWord WLen 0x200000000000000000000000000000000000000000000000000000000%positive);DUP 4;Opcode AND;PUSH 1 (posToWord WLen 0x0%positive);Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0x7e%positive)] [POP;PUSH 1 (posToWord WLen 0x0%positive);PUSH 29 (posToWord WLen 0x200000000000000000000000000000000000000000000000000000000%positive);DUP 5;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0x7e%positive)] 4 optimize_id).

(*
 I: PUSH 0 PUSH 1 DUP6 ADD SWAP1 POP PUSH 0 PUSH 4 PUSH 0 DUP4 DUP2
 O: DUP4 PUSH 1 ADD PUSH 0 PUSH 4 DUP2 DUP4 DUP4
*)
Compute pair "ERC721A_run_code_of_0_block_121_0"%string (equiv_checker [DUP 4;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 2;DUP 4;DUP 4] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x1%positive);DUP 6;Opcode ADD;DUP 1;POP;PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 2] 4 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_121_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD EQ ISZERO PUSH [tag] 127
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD EQ ISZERO PUSH [tag] 127
*)
Compute pair "ERC721A_run_code_of_0_block_121_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0x7f%positive)] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0x7f%positive)] 2 optimize_id).

(*
 I: PUSH 0 SLOAD DUP2 EQ PUSH [tag] 128
 O: DUP1 PUSH 0 SLOAD EQ PUSH [tag] 128
*)
Compute pair "ERC721A_run_code_of_0_block_122_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;Opcode EQ;PUSH 1 (posToWord WLen 0x80%positive)] [PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;DUP 2;Opcode EQ;PUSH 1 (posToWord WLen 0x80%positive)] 1 optimize_id).

(*
 I: DUP4 PUSH 4 PUSH 0 DUP4 DUP2
 O: DUP4 PUSH 4 PUSH 0 DUP4 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_123_0"%string (equiv_checker [DUP 4;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 2] [DUP 4;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 2] 4 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_123_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 DUP2 SWAP1
 O: DUP2 SWAP1 PUSH 20 ADD PUSH 0 KECCAK256
*)
Compute pair "ERC721A_run_code_of_0_block_123_2"%string (equiv_checker [DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 2;DUP 1] 2 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "ERC721A_run_code_of_0_block_123_3"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "ERC721A_run_code_of_0_block_125_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: DUP4 DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP8 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH DDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF PUSH 40 MLOAD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH ffffffffffffffffffffffffffffffffffffffff DUP1 DUP7 AND DUP8 PUSH 40 MLOAD SWAP3 AND PUSH ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef DUP4 DUP1 SUB DUP9 SWAP5
*)
Compute pair "ERC721A_run_code_of_0_block_126_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 1;DUP 7;Opcode AND;DUP 8;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 3;Opcode AND;PUSH 32 (posToWord WLen 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef%positive);DUP 4;DUP 1;Opcode SUB;DUP 9;DUP 5] [DUP 4;DUP 6;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 8;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 32 (posToWord WLen 0xDDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 6 optimize_id).

(*
 I: PUSH [tag] 129 DUP7 DUP7 DUP7 PUSH 1 PUSH [tag] 130
 O: PUSH [tag] 129 DUP7 DUP7 DUP7 PUSH 1 PUSH [tag] 130
*)
Compute pair "ERC721A_run_code_of_0_block_126_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x81%positive);DUP 7;DUP 7;DUP 7;PUSH 1 (posToWord WLen 0x1%positive);PUSH 1 (posToWord WLen 0x82%positive)] [PUSH 1 (posToWord WLen 0x81%positive);DUP 7;DUP 7;DUP 7;PUSH 1 (posToWord WLen 0x1%positive);PUSH 1 (posToWord WLen 0x82%positive)] 6 optimize_id).

(*
 I: POP POP POP POP POP POP
 O: POP POP POP POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_127_0"%string (equiv_checker [POP;POP;POP;POP;POP;POP] [POP;POP;POP;POP;POP;POP] 6 optimize_id).

(*
 I: PUSH [tag] 132 DUP4 DUP4 DUP4 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH [tag] 132 DUP4 DUP4 DUP4 PUSH 40 MLOAD PUSH 20 DUP2 ADD PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_128_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x84%positive);DUP 4;DUP 4;DUP 4;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 1 (posToWord WLen 0x84%positive);DUP 4;DUP 4;DUP 4;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 3 optimize_id).

(*
 I: DUP1 PUSH 0 DUP2
 O: DUP1 PUSH 0 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_128_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);DUP 2] [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);DUP 2] 1 optimize_id).

(*
 I: POP PUSH [tag] 70
 O: POP PUSH [tag] 70
*)
Compute pair "ERC721A_run_code_of_0_block_128_2"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x46%positive)] [POP;PUSH 1 (posToWord WLen 0x46%positive)] 1 optimize_id).

(*
 I: POP POP POP
 O: POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_129_0"%string (equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 134 DUP3 PUSH [tag] 107
 O: PUSH 0 PUSH [tag] 134 DUP3 PUSH [tag] 107
*)
Compute pair "ERC721A_run_code_of_0_block_130_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x86%positive);DUP 3;PUSH 1 (posToWord WLen 0x6b%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x86%positive);DUP 3;PUSH 1 (posToWord WLen 0x6b%positive)] 1 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_131_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 136
 O: PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 AND DUP2 PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ ISZERO PUSH [tag] 136
*)
Compute pair "ERC721A_run_code_of_0_block_132_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 3;Opcode AND;DUP 2;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0x88%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 3;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0x88%positive)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 8F4EB60400000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8f4eb60400000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_133_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8f4eb60400000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0x8F4EB60400000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_133_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH FFFFFFFFFFFFFFFF PUSH 5 PUSH 0 DUP5 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH ffffffffffffffff PUSH 5 PUSH 0 DUP5 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_134_0"%string (equiv_checker [PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);PUSH 1 (posToWord WLen 0x5%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 5;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 2] [PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);PUSH 1 (posToWord WLen 0x5%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 5;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_134_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND SWAP2 POP POP SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_134_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;Opcode AND;DUP 2;POP;POP;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 5 optimize_id).

(*
 I: PUSH 60 PUSH 3 DUP1 SLOAD PUSH [tag] 138 SWAP1 PUSH [tag] 85
 O: PUSH 60 PUSH 3 PUSH [tag] 138 DUP2 SLOAD PUSH [tag] 85
*)
Compute pair "ERC721A_run_code_of_0_block_135_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x3%positive);PUSH 1 (posToWord WLen 0x8a%positive);DUP 2;Opcode SLOAD;PUSH 1 (posToWord WLen 0x55%positive)] [PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x3%positive);DUP 1;Opcode SLOAD;PUSH 1 (posToWord WLen 0x8a%positive);DUP 1;PUSH 1 (posToWord WLen 0x55%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_136_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x20%positive);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 1 optimize_id).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute pair "ERC721A_run_code_of_0_block_136_1"%string (equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 139 SWAP1 PUSH [tag] 85
 O: PUSH 20 ADD DUP3 PUSH [tag] 139 DUP5 SLOAD PUSH [tag] 85
*)
Compute pair "ERC721A_run_code_of_0_block_136_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;PUSH 1 (posToWord WLen 0x8b%positive);DUP 5;Opcode SLOAD;PUSH 1 (posToWord WLen 0x55%positive)] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (posToWord WLen 0x8b%positive);DUP 1;PUSH 1 (posToWord WLen 0x55%positive)] 3 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 140
 O: DUP1 ISZERO PUSH [tag] 140
*)
Compute pair "ERC721A_run_code_of_0_block_137_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x8c%positive)] [DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0x8c%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 141
 O: DUP1 PUSH 1f LT PUSH [tag] 141
*)
Compute pair "ERC721A_run_code_of_0_block_138_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1f%positive);Opcode LT;PUSH 1 (posToWord WLen 0x8d%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1F%positive);Opcode LT;PUSH 1 (posToWord WLen 0x8d%positive)] 1 optimize_id).

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Compute pair "ERC721A_run_code_of_0_block_139_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x100%positive);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (posToWord WLen 0x100%positive);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 140
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 140
*)
Compute pair "ERC721A_run_code_of_0_block_139_1"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 1 (posToWord WLen 0x8c%positive)] [DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 1 (posToWord WLen 0x8c%positive)] 3 optimize_id).

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Compute pair "ERC721A_run_code_of_0_block_140_0"%string (equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x0%positive)] 3 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_140_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1] 1 optimize_id).

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_141_0"%string (equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id).

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 142
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 142
*)
Compute pair "ERC721A_run_code_of_0_block_141_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (posToWord WLen 0x8e%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x1%positive);Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (posToWord WLen 0x8e%positive)] 3 optimize_id).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute pair "ERC721A_run_code_of_0_block_142_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1f%positive);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (posToWord WLen 0x1F%positive);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id).

(*
 I: POP POP POP POP POP SWAP1 POP SWAP1
 O: POP POP POP POP POP SWAP2 SWAP1 POP
*)
Compute pair "ERC721A_run_code_of_0_block_143_0"%string (equiv_checker [POP;POP;POP;POP;POP;DUP 2;DUP 1;POP] [POP;POP;POP;POP;POP;DUP 1;POP;DUP 1] 8 optimize_id).

(*
 I: PUSH [tag] 144 PUSH [tag] 97
 O: PUSH [tag] 144 PUSH [tag] 97
*)
Compute pair "ERC721A_run_code_of_0_block_144_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x90%positive);PUSH 1 (posToWord WLen 0x61%positive)] [PUSH 1 (posToWord WLen 0x90%positive);PUSH 1 (posToWord WLen 0x61%positive)] 0 optimize_id).

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 145
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP3 PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ ISZERO PUSH [tag] 145
*)
Compute pair "ERC721A_run_code_of_0_block_145_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 3;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0x91%positive)] [PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 3;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0x91%positive)] 3 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH B06307DB00000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH b06307db00000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_146_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xb06307db00000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xB06307DB00000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_146_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: DUP1 PUSH 7 PUSH 0 PUSH [tag] 146 PUSH [tag] 97
 O: DUP1 PUSH 7 PUSH 0 PUSH [tag] 146 PUSH [tag] 97
*)
Compute pair "ERC721A_run_code_of_0_block_147_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x7%positive);PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x92%positive);PUSH 1 (posToWord WLen 0x61%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x7%positive);PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x92%positive);PUSH 1 (posToWord WLen 0x61%positive)] 1 optimize_id).

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_148_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 2] [PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_148_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP5 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP1 DUP7 AND AND DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_148_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 1;DUP 7;Opcode AND;Opcode AND;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);DUP 5;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 4 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_148_3"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH 100 EXP PUSH ff DUP2 DUP5 ISZERO ISZERO MUL SWAP2 MUL NOT DUP3 SLOAD AND OR SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_148_4"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;PUSH 1 (posToWord WLen 0xff%positive);DUP 2;DUP 5;Opcode ISZERO;Opcode ISZERO;Opcode MUL;DUP 2;Opcode MUL;Opcode NOT;DUP 3;Opcode SLOAD;Opcode AND;Opcode OR;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 1 (posToWord WLen 0xFF%positive);Opcode MUL;Opcode NOT;Opcode AND;DUP 1;DUP 4;Opcode ISZERO;Opcode ISZERO;Opcode MUL;Opcode OR;DUP 1] 2 optimize_id).

(*
 I: POP DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH [tag] 147 PUSH [tag] 97
 O: POP PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 AND PUSH [tag] 147 PUSH [tag] 97
*)
Compute pair "ERC721A_run_code_of_0_block_148_5"%string (equiv_checker [POP;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 3;Opcode AND;PUSH 1 (posToWord WLen 0x93%positive);PUSH 1 (posToWord WLen 0x61%positive)] [POP;DUP 2;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 1 (posToWord WLen 0x93%positive);PUSH 1 (posToWord WLen 0x61%positive)] 3 optimize_id).

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C31 DUP4 PUSH 40 MLOAD PUSH [tag] 148 SWAP2 SWAP1 PUSH [tag] 25
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH 17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31 PUSH [tag] 148 DUP5 PUSH 40 MLOAD PUSH [tag] 25
*)
Compute pair "ERC721A_run_code_of_0_block_149_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 32 (posToWord WLen 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31%positive);PUSH 1 (posToWord WLen 0x94%positive);DUP 5;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x19%positive)] [PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 32 (posToWord WLen 0x17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C31%positive);DUP 4;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x94%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x19%positive)] 3 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_150_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_150_1"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH [tag] 150 DUP5 DUP5 DUP5 PUSH [tag] 47
 O: PUSH [tag] 150 DUP5 DUP5 DUP5 PUSH [tag] 47
*)
Compute pair "ERC721A_run_code_of_0_block_151_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x96%positive);DUP 5;DUP 5;DUP 5;PUSH 1 (posToWord WLen 0x2f%positive)] [PUSH 1 (posToWord WLen 0x96%positive);DUP 5;DUP 5;DUP 5;PUSH 1 (posToWord WLen 0x2f%positive)] 4 optimize_id).

(*
 I: PUSH 0 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EXTCODESIZE EQ PUSH [tag] 151
 O: PUSH 0 DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff AND EXTCODESIZE EQ PUSH [tag] 151
*)
Compute pair "ERC721A_run_code_of_0_block_152_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;Opcode EXTCODESIZE;Opcode EQ;PUSH 1 (posToWord WLen 0x97%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;Opcode EXTCODESIZE;Opcode EQ;PUSH 1 (posToWord WLen 0x97%positive)] 3 optimize_id).

(*
 I: PUSH [tag] 152 DUP5 DUP5 DUP5 DUP5 PUSH [tag] 153
 O: PUSH [tag] 152 DUP5 DUP5 DUP5 DUP5 PUSH [tag] 153
*)
Compute pair "ERC721A_run_code_of_0_block_153_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x98%positive);DUP 5;DUP 5;DUP 5;DUP 5;PUSH 1 (posToWord WLen 0x99%positive)] [PUSH 1 (posToWord WLen 0x98%positive);DUP 5;DUP 5;DUP 5;DUP 5;PUSH 1 (posToWord WLen 0x99%positive)] 4 optimize_id).

(*
 I: PUSH [tag] 154
 O: PUSH [tag] 154
*)
Compute pair "ERC721A_run_code_of_0_block_154_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x9a%positive)] [PUSH 1 (posToWord WLen 0x9a%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH D1A57ED600000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH d1a57ed600000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_155_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xd1a57ed600000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xD1A57ED600000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_155_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_157_0"%string (equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id).

(*
 I: PUSH 60 PUSH [tag] 156 DUP3 PUSH [tag] 92
 O: PUSH 60 PUSH [tag] 156 DUP3 PUSH [tag] 92
*)
Compute pair "ERC721A_run_code_of_0_block_158_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x9c%positive);DUP 3;PUSH 1 (posToWord WLen 0x5c%positive)] [PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x9c%positive);DUP 3;PUSH 1 (posToWord WLen 0x5c%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 157
 O: PUSH [tag] 157
*)
Compute pair "ERC721A_run_code_of_0_block_159_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x9d%positive)] [PUSH 1 (posToWord WLen 0x9d%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH A14C4B5000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH a14c4b5000000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_160_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xa14c4b5000000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xA14C4B5000000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_160_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 158 PUSH [tag] 159
 O: PUSH 0 PUSH [tag] 158 PUSH [tag] 159
*)
Compute pair "ERC721A_run_code_of_0_block_161_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x9e%positive);PUSH 1 (posToWord WLen 0x9f%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x9e%positive);PUSH 1 (posToWord WLen 0x9f%positive)] 0 optimize_id).

(*
 I: SWAP1 POP PUSH 0 DUP2 MLOAD EQ ISZERO PUSH [tag] 160
 O: SWAP1 POP PUSH 0 DUP2 MLOAD EQ ISZERO PUSH [tag] 160
*)
Compute pair "ERC721A_run_code_of_0_block_162_0"%string (equiv_checker [DUP 1;POP;PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode MLOAD;Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0xa0%positive)] [DUP 1;POP;PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode MLOAD;Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0xa0%positive)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_163_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 0 DUP2
 O: DUP1 PUSH 0 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_163_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);DUP 2] [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);DUP 2] 1 optimize_id).

(*
 I: POP PUSH [tag] 161
 O: POP PUSH [tag] 161
*)
Compute pair "ERC721A_run_code_of_0_block_163_2"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0xa1%positive)] [POP;PUSH 1 (posToWord WLen 0xa1%positive)] 1 optimize_id).

(*
 I: DUP1 PUSH [tag] 162 DUP5 PUSH [tag] 163
 O: DUP1 PUSH [tag] 162 DUP5 PUSH [tag] 163
*)
Compute pair "ERC721A_run_code_of_0_block_164_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0xa2%positive);DUP 5;PUSH 1 (posToWord WLen 0xa3%positive)] [DUP 1;PUSH 1 (posToWord WLen 0xa2%positive);DUP 5;PUSH 1 (posToWord WLen 0xa3%positive)] 3 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 20 ADD PUSH [tag] 164 SWAP3 SWAP2 SWAP1 PUSH [tag] 165
 O: PUSH [tag] 164 SWAP2 SWAP1 PUSH 20 PUSH 40 MLOAD ADD PUSH [tag] 165
*)
Compute pair "ERC721A_run_code_of_0_block_165_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xa4%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;Opcode ADD;PUSH 1 (posToWord WLen 0xa5%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0xa4%positive);DUP 3;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0xa5%positive)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 20 DUP2 DUP4 SUB SUB DUP2
 O: PUSH 40 MLOAD PUSH 20 DUP2 DUP4 SUB SUB DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_166_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x20%positive);DUP 2;DUP 4;Opcode SUB;Opcode SUB;DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 1 (posToWord WLen 0x20%positive);DUP 2;DUP 4;Opcode SUB;Opcode SUB;DUP 2] 1 optimize_id).

(*
 I: SWAP1 PUSH 40
 O: SWAP1 PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_166_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x40%positive)] 2 optimize_id).

(*
 I: SWAP2 POP POP SWAP2 SWAP1 POP
 O: SWAP4 SWAP3 POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_167_0"%string (equiv_checker [DUP 4;DUP 3;POP;POP;POP] [DUP 2;POP;POP;DUP 2;DUP 1;POP] 5 optimize_id).

(*
 I: PUSH 0 PUSH 7 PUSH 0 DUP5 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 0 PUSH 7 DUP2 DUP5 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_168_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x7%positive);DUP 2;DUP 5;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 2] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x7%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 5;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_168_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP5 DUP2 AND AND DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_168_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);DUP 5;DUP 2;Opcode AND;Opcode AND;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_168_3"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FF AND SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP2 PUSH 0 SWAP4 POP POP POP PUSH 20 ADD DUP2 PUSH 100 EXP SWAP2 KECCAK256 SLOAD DIV PUSH ff AND SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_168_4"%string (equiv_checker [DUP 2;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;POP;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 2;Opcode KECCAK256;Opcode SLOAD;Opcode DIV;PUSH 1 (posToWord WLen 0xff%positive);Opcode AND;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;PUSH 1 (posToWord WLen 0x0%positive);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (posToWord WLen 0x100%positive);Opcode EXP;DUP 1;Opcode DIV;PUSH 1 (posToWord WLen 0xFF%positive);Opcode AND;DUP 1;POP;DUP 3;DUP 2;POP;POP] 5 optimize_id).

(*
 I: PUSH 0 DUP2 PUSH [tag] 168 PUSH [tag] 104
 O: PUSH 0 DUP2 PUSH [tag] 168 PUSH [tag] 104
*)
Compute pair "ERC721A_run_code_of_0_block_169_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;PUSH 1 (posToWord WLen 0xa8%positive);PUSH 1 (posToWord WLen 0x68%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;PUSH 1 (posToWord WLen 0xa8%positive);PUSH 1 (posToWord WLen 0x68%positive)] 1 optimize_id).

(*
 I: GT ISZERO DUP1 ISZERO PUSH [tag] 169
 O: GT ISZERO DUP1 ISZERO PUSH [tag] 169
*)
Compute pair "ERC721A_run_code_of_0_block_170_0"%string (equiv_checker [Opcode GT;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xa9%positive)] [Opcode GT;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xa9%positive)] 2 optimize_id).

(*
 I: POP PUSH 0 SLOAD DUP3 LT
 O: POP PUSH 0 SLOAD DUP3 LT
*)
Compute pair "ERC721A_run_code_of_0_block_171_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;DUP 3;Opcode LT] [POP;PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;DUP 3;Opcode LT] 3 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 170
 O: DUP1 ISZERO PUSH [tag] 170
*)
Compute pair "ERC721A_run_code_of_0_block_172_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xaa%positive)] [DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xaa%positive)] 1 optimize_id).

(*
 I: POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 PUSH 4 PUSH 0 DUP6 DUP2
 O: POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 PUSH 4 DUP3 DUP6 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_173_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x0%positive);PUSH 29 (posToWord WLen 0x100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 3;DUP 6;DUP 2] [POP;PUSH 1 (posToWord WLen 0x0%positive);PUSH 29 (posToWord WLen 0x100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 6;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_173_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND EQ
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND EQ
*)
Compute pair "ERC721A_run_code_of_0_block_173_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;Opcode AND;Opcode EQ] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;Opcode AND;Opcode EQ] 3 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_174_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 CALLER SWAP1 POP SWAP1
 O: CALLER SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_175_0"%string (equiv_checker [Opcode CALLER;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);Opcode CALLER;DUP 1;POP;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 SWAP1
 O: PUSH 0 SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_176_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 1 optimize_id).

(*
 I: PUSH 0 DUP1 DUP3 SWAP1 POP DUP1 PUSH [tag] 174 PUSH [tag] 104
 O: PUSH 0 DUP2 DUP1 PUSH [tag] 174 PUSH [tag] 104
*)
Compute pair "ERC721A_run_code_of_0_block_177_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0xae%positive);PUSH 1 (posToWord WLen 0x68%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;DUP 3;DUP 1;POP;DUP 1;PUSH 1 (posToWord WLen 0xae%positive);PUSH 1 (posToWord WLen 0x68%positive)] 1 optimize_id).

(*
 I: GT PUSH [tag] 175
 O: GT PUSH [tag] 175
*)
Compute pair "ERC721A_run_code_of_0_block_178_0"%string (equiv_checker [Opcode GT;PUSH 1 (posToWord WLen 0xaf%positive)] [Opcode GT;PUSH 1 (posToWord WLen 0xaf%positive)] 2 optimize_id).

(*
 I: PUSH 0 SLOAD DUP2 LT ISZERO PUSH [tag] 176
 O: PUSH 0 SLOAD DUP2 LT ISZERO PUSH [tag] 176
*)
Compute pair "ERC721A_run_code_of_0_block_179_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;DUP 2;Opcode LT;Opcode ISZERO;PUSH 1 (posToWord WLen 0xb0%positive)] [PUSH 1 (posToWord WLen 0x0%positive);Opcode SLOAD;DUP 2;Opcode LT;Opcode ISZERO;PUSH 1 (posToWord WLen 0xb0%positive)] 1 optimize_id).

(*
 I: PUSH 0 PUSH 4 PUSH 0 DUP4 DUP2
 O: PUSH 0 PUSH 4 DUP2 DUP4 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_180_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 2;DUP 4;DUP 2] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 2] 1 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_180_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD SWAP1 POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 DUP3 AND EQ ISZERO PUSH [tag] 177
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD PUSH 100000000000000000000000000000000000000000000000000000000 DUP2 SWAP3 POP AND PUSH 0 EQ ISZERO PUSH [tag] 177
*)
Compute pair "ERC721A_run_code_of_0_block_180_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;PUSH 29 (posToWord WLen 0x100000000000000000000000000000000000000000000000000000000%positive);DUP 2;DUP 3;POP;Opcode AND;PUSH 1 (posToWord WLen 0x0%positive);Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0xb1%positive)] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;DUP 1;POP;PUSH 1 (posToWord WLen 0x0%positive);PUSH 29 (posToWord WLen 0x100000000000000000000000000000000000000000000000000000000%positive);DUP 3;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0xb1%positive)] 2 optimize_id).

(*
 I: PUSH 0 DUP2 EQ ISZERO PUSH [tag] 179
 O: DUP1 PUSH 0 EQ ISZERO PUSH [tag] 179
*)
Compute pair "ERC721A_run_code_of_0_block_181_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0xb3%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0xb3%positive)] 1 optimize_id).

(*
 I: PUSH 4 PUSH 0 DUP4 PUSH 1 SWAP1 SUB SWAP4 POP DUP4 DUP2
 O: PUSH 1 PUSH 4 SWAP3 SUB SWAP2 PUSH 0 DUP4 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_182_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive);PUSH 1 (posToWord WLen 0x4%positive);DUP 3;Opcode SUB;DUP 2;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 2] [PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;PUSH 1 (posToWord WLen 0x1%positive);DUP 1;Opcode SUB;DUP 4;POP;DUP 4;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_182_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD SWAP1 POP PUSH [tag] 178
 O: SWAP1 POP PUSH 20 ADD PUSH 0 KECCAK256 SLOAD PUSH [tag] 178
*)
Compute pair "ERC721A_run_code_of_0_block_182_2"%string (equiv_checker [DUP 1;POP;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;PUSH 1 (posToWord WLen 0xb2%positive)] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;Opcode SLOAD;DUP 1;POP;PUSH 1 (posToWord WLen 0xb2%positive)] 2 optimize_id).

(*
 I: DUP1 SWAP3 POP POP POP PUSH [tag] 173
 O: SWAP2 POP POP PUSH [tag] 173
*)
Compute pair "ERC721A_run_code_of_0_block_183_0"%string (equiv_checker [DUP 2;POP;POP;PUSH 1 (posToWord WLen 0xad%positive)] [DUP 1;DUP 3;POP;POP;POP;PUSH 1 (posToWord WLen 0xad%positive)] 3 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "ERC721A_run_code_of_0_block_184_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH DF2D9B4200000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH df2d9b4200000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_186_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xdf2d9b4200000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xDF2D9B4200000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_186_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Compute pair "ERC721A_run_code_of_0_block_187_0"%string (equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 0 PUSH 6 PUSH 0 DUP6 DUP2
 O: PUSH 0 DUP1 DUP1 PUSH 6 DUP2 DUP6 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_188_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;DUP 1;PUSH 1 (posToWord WLen 0x6%positive);DUP 2;DUP 6;DUP 2] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x6%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 6;DUP 2] 1 optimize_id).

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_188_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SWAP1 POP DUP1 SWAP3 POP DUP3 SLOAD SWAP2 POP POP SWAP2 POP SWAP2
 O: SWAP1 POP SWAP2 POP SWAP2 POP PUSH 20 ADD SWAP1 POP PUSH 0 KECCAK256 SWAP1 DUP2 SLOAD SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_188_2"%string (equiv_checker [DUP 1;POP;DUP 2;POP;DUP 2;POP;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 1;POP;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1;DUP 2;Opcode SLOAD;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x0%positive);Opcode KECCAK256;DUP 1;POP;DUP 1;DUP 3;POP;DUP 3;Opcode SLOAD;DUP 2;POP;POP;DUP 2;POP;DUP 2] 6 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP4 AND SWAP3 POP PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP3 AND SWAP2 POP DUP4 DUP3 EQ DUP4 DUP4 EQ OR SWAP1 POP SWAP4 SWAP3 POP POP POP
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP1 DUP2 SWAP3 SWAP3 DUP5 EQ SWAP4 POP SWAP3 DUP5 SWAP3 PUSH ffffffffffffffffffffffffffffffffffffffff AND SWAP3 POP SWAP3 POP EQ OR SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_189_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 1;DUP 2;DUP 3;DUP 3;DUP 5;Opcode EQ;DUP 4;POP;DUP 3;DUP 5;DUP 3;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 3;POP;DUP 3;POP;Opcode EQ;Opcode OR;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);DUP 4;Opcode AND;DUP 3;POP;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);DUP 3;Opcode AND;DUP 2;POP;DUP 4;DUP 3;Opcode EQ;DUP 4;DUP 4;Opcode EQ;Opcode OR;DUP 1;POP;DUP 4;DUP 3;POP;POP;POP] 4 optimize_id).

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_190_0"%string (equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH E8 DUP4 SWAP1 SHR SWAP1 POP PUSH E8 PUSH [tag] 184 DUP7 DUP7 DUP5 PUSH [tag] 185
 O: PUSH 0 PUSH [tag] 185 PUSH e8 PUSH [tag] 184 DUP7 DUP7 DUP7 DUP5 SHR DUP1 SWAP6
*)
Compute pair "ERC721A_run_code_of_0_block_191_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0xb9%positive);PUSH 1 (posToWord WLen 0xe8%positive);PUSH 1 (posToWord WLen 0xb8%positive);DUP 7;DUP 7;DUP 7;DUP 5;Opcode SHR;DUP 1;DUP 6] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0xE8%positive);DUP 4;DUP 1;Opcode SHR;DUP 1;POP;PUSH 1 (posToWord WLen 0xE8%positive);PUSH 1 (posToWord WLen 0xb8%positive);DUP 7;DUP 7;DUP 5;PUSH 1 (posToWord WLen 0xb9%positive)] 3 optimize_id).

(*
 I: PUSH FFFFFF AND SWAP1 SHL SWAP2 POP POP SWAP4 SWAP3 POP POP POP
 O: PUSH ffffff AND SWAP6 POP SWAP4 POP POP POP POP SHL SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_192_0"%string (equiv_checker [PUSH 3 (posToWord WLen 0xffffff%positive);Opcode AND;DUP 6;POP;DUP 4;POP;POP;POP;POP;Opcode SHL;DUP 1] [PUSH 3 (posToWord WLen 0xFFFFFF%positive);Opcode AND;DUP 1;Opcode SHL;DUP 2;POP;POP;DUP 4;DUP 3;POP;POP;POP] 8 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP4 AND SWAP3 POP DUP2 TIMESTAMP PUSH A0 SHL OR DUP4 OR SWAP1 POP SWAP3 SWAP2 POP POP
 O: TIMESTAMP PUSH a0 SHL OR SWAP1 PUSH ffffffffffffffffffffffffffffffffffffffff AND OR SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_193_0"%string (equiv_checker [Opcode TIMESTAMP;PUSH 1 (posToWord WLen 0xa0%positive);Opcode SHL;Opcode OR;DUP 1;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;Opcode OR;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);DUP 4;Opcode AND;DUP 3;POP;DUP 2;Opcode TIMESTAMP;PUSH 1 (posToWord WLen 0xA0%positive);Opcode SHL;Opcode OR;DUP 4;Opcode OR;DUP 1;POP;DUP 3;DUP 2;POP;POP] 3 optimize_id).

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_194_0"%string (equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 150B7A02 PUSH [tag] 189 PUSH [tag] 97
 O: PUSH 0 DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH 150b7a02 PUSH [tag] 189 PUSH [tag] 97
*)
Compute pair "ERC721A_run_code_of_0_block_195_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;PUSH 4 (posToWord WLen 0x150b7a02%positive);PUSH 1 (posToWord WLen 0xbd%positive);PUSH 1 (posToWord WLen 0x61%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode AND;PUSH 4 (posToWord WLen 0x150B7A02%positive);PUSH 1 (posToWord WLen 0xbd%positive);PUSH 1 (posToWord WLen 0x61%positive)] 3 optimize_id).

(*
 I: DUP8 DUP7 DUP7 PUSH 40 MLOAD DUP6 PUSH FFFFFFFF AND PUSH E0 SHL DUP2
 O: DUP8 DUP7 DUP7 PUSH 40 MLOAD DUP6 PUSH ffffffff AND PUSH e0 SHL DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_196_0"%string (equiv_checker [DUP 8;DUP 7;DUP 7;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 6;PUSH 4 (posToWord WLen 0xffffffff%positive);Opcode AND;PUSH 1 (posToWord WLen 0xe0%positive);Opcode SHL;DUP 2] [DUP 8;DUP 7;DUP 7;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 6;PUSH 4 (posToWord WLen 0xFFFFFFFF%positive);Opcode AND;PUSH 1 (posToWord WLen 0xE0%positive);Opcode SHL;DUP 2] 8 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 190 SWAP5 SWAP4 SWAP3 SWAP2 SWAP1 PUSH [tag] 191
 O: SWAP3 SWAP2 SWAP1 PUSH 4 PUSH [tag] 190 SWAP6 SWAP5 ADD PUSH [tag] 191
*)
Compute pair "ERC721A_run_code_of_0_block_196_1"%string (equiv_checker [DUP 3;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0x4%positive);PUSH 1 (posToWord WLen 0xbe%positive);DUP 6;DUP 5;Opcode ADD;PUSH 1 (posToWord WLen 0xbf%positive)] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0xbe%positive);DUP 5;DUP 4;DUP 3;DUP 2;DUP 1;PUSH 1 (posToWord WLen 0xbf%positive)] 5 optimize_id).

(*
 I: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP1 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 192
 O: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP9 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 192
*)
Compute pair "ERC721A_run_code_of_0_block_197_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (posToWord WLen 0x0%positive);DUP 8;DUP 9;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xc0%positive)] [PUSH 1 (posToWord WLen 0x20%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (posToWord WLen 0x0%positive);DUP 8;DUP 1;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xc0%positive)] 3 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_198_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP GAS
 O: POP GAS
*)
Compute pair "ERC721A_run_code_of_0_block_199_0"%string (equiv_checker [POP;Opcode GAS] [POP;Opcode GAS] 1 optimize_id).

(*
 I: SWAP3 POP POP POP DUP1 ISZERO PUSH [tag] 193
 O: SWAP3 POP POP POP DUP1 ISZERO PUSH [tag] 193
*)
Compute pair "ERC721A_run_code_of_0_block_199_1"%string (equiv_checker [DUP 3;POP;POP;POP;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xc1%positive)] [DUP 3;POP;POP;POP;DUP 1;Opcode ISZERO;PUSH 1 (posToWord WLen 0xc1%positive)] 4 optimize_id).

(*
 I: POP PUSH 40 MLOAD RETURNDATASIZE PUSH 1F NOT PUSH 1F DUP3 ADD AND DUP3 ADD DUP1 PUSH 40
 O: POP PUSH 40 MLOAD RETURNDATASIZE PUSH 1f NOT PUSH 1f DUP3 ADD AND DUP3 ADD DUP1 PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_200_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;Opcode RETURNDATASIZE;PUSH 1 (posToWord WLen 0x1f%positive);Opcode NOT;PUSH 1 (posToWord WLen 0x1f%positive);DUP 3;Opcode ADD;Opcode AND;DUP 3;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x40%positive)] [POP;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;Opcode RETURNDATASIZE;PUSH 1 (posToWord WLen 0x1F%positive);Opcode NOT;PUSH 1 (posToWord WLen 0x1F%positive);DUP 3;Opcode ADD;Opcode AND;DUP 3;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x40%positive)] 1 optimize_id).

(*
 I: POP DUP2 ADD SWAP1 PUSH [tag] 194 SWAP2 SWAP1 PUSH [tag] 195
 O: POP DUP2 ADD PUSH [tag] 194 SWAP2 PUSH [tag] 195
*)
Compute pair "ERC721A_run_code_of_0_block_200_1"%string (equiv_checker [POP;DUP 2;Opcode ADD;PUSH 1 (posToWord WLen 0xc2%positive);DUP 2;PUSH 1 (posToWord WLen 0xc3%positive)] [POP;DUP 2;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0xc2%positive);DUP 2;DUP 1;PUSH 1 (posToWord WLen 0xc3%positive)] 3 optimize_id).

(*
 I: PUSH 1
 O: PUSH 1
*)
Compute pair "ERC721A_run_code_of_0_block_201_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive)] [PUSH 1 (posToWord WLen 0x1%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 196
 O: PUSH [tag] 196
*)
Compute pair "ERC721A_run_code_of_0_block_202_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xc4%positive)] [PUSH 1 (posToWord WLen 0xc4%positive)] 0 optimize_id).

(*
 I: RETURNDATASIZE DUP1 PUSH 0 DUP2 EQ PUSH [tag] 201
 O: RETURNDATASIZE DUP1 DUP2 PUSH 0 EQ PUSH [tag] 201
*)
Compute pair "ERC721A_run_code_of_0_block_203_0"%string (equiv_checker [Opcode RETURNDATASIZE;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x0%positive);Opcode EQ;PUSH 1 (posToWord WLen 0xc9%positive)] [Opcode RETURNDATASIZE;DUP 1;PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode EQ;PUSH 1 (posToWord WLen 0xc9%positive)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD SWAP2 POP PUSH 1F NOT PUSH 3F RETURNDATASIZE ADD AND DUP3 ADD PUSH 40
 O: PUSH 1f PUSH 40 MLOAD SWAP3 POP NOT RETURNDATASIZE PUSH 3f ADD AND DUP3 ADD PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_204_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1f%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 3;POP;Opcode NOT;Opcode RETURNDATASIZE;PUSH 1 (posToWord WLen 0x3f%positive);Opcode ADD;Opcode AND;DUP 3;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 2;POP;PUSH 1 (posToWord WLen 0x1F%positive);Opcode NOT;PUSH 1 (posToWord WLen 0x3F%positive);Opcode RETURNDATASIZE;Opcode ADD;Opcode AND;DUP 3;Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 2 optimize_id).

(*
 I: RETURNDATASIZE DUP3
 O: RETURNDATASIZE DUP3
*)
Compute pair "ERC721A_run_code_of_0_block_204_1"%string (equiv_checker [Opcode RETURNDATASIZE;DUP 3] [Opcode RETURNDATASIZE;DUP 3] 2 optimize_id).

(*
 I: RETURNDATASIZE PUSH 0 PUSH 20 DUP5 ADD
 O: RETURNDATASIZE PUSH 0 PUSH 20 DUP5 ADD
*)
Compute pair "ERC721A_run_code_of_0_block_204_2"%string (equiv_checker [Opcode RETURNDATASIZE;PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 5;Opcode ADD] [Opcode RETURNDATASIZE;PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 5;Opcode ADD] 2 optimize_id).

(*
 I: PUSH [tag] 200
 O: PUSH [tag] 200
*)
Compute pair "ERC721A_run_code_of_0_block_204_3"%string (equiv_checker [PUSH 1 (posToWord WLen 0xc8%positive)] [PUSH 1 (posToWord WLen 0xc8%positive)] 0 optimize_id).

(*
 I: PUSH 60 SWAP2 POP
 O: PUSH 60 SWAP2 POP
*)
Compute pair "ERC721A_run_code_of_0_block_205_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x60%positive);DUP 2;POP] [PUSH 1 (posToWord WLen 0x60%positive);DUP 2;POP] 2 optimize_id).

(*
 I: POP PUSH 0 DUP2 MLOAD EQ ISZERO PUSH [tag] 202
 O: POP DUP1 MLOAD PUSH 0 EQ ISZERO PUSH [tag] 202
*)
Compute pair "ERC721A_run_code_of_0_block_206_0"%string (equiv_checker [POP;DUP 1;Opcode MLOAD;PUSH 1 (posToWord WLen 0x0%positive);Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0xca%positive)] [POP;PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode MLOAD;Opcode EQ;Opcode ISZERO;PUSH 1 (posToWord WLen 0xca%positive)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH D1A57ED600000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH d1a57ed600000000000000000000000000000000000000000000000000000000 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_207_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xd1a57ed600000000000000000000000000000000000000000000000000000000%positive);DUP 2] [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;PUSH 32 (posToWord WLen 0xD1A57ED600000000000000000000000000000000000000000000000000000000%positive);DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_207_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (posToWord WLen 0x4%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: DUP1 MLOAD DUP2 PUSH 20 ADD
 O: DUP1 MLOAD DUP2 PUSH 20 ADD
*)
Compute pair "ERC721A_run_code_of_0_block_208_0"%string (equiv_checker [DUP 1;Opcode MLOAD;DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD] [DUP 1;Opcode MLOAD;DUP 2;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD] 1 optimize_id).

(*
 I: PUSH 150B7A02 PUSH E0 SHL PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ SWAP2 POP POP SWAP5 SWAP4 POP POP POP POP
 O: SWAP5 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT PUSH 150b7a02 PUSH e0 SHL SWAP2 SWAP8 SWAP7 DUP2 AND SWAP2 AND EQ SWAP6 POP POP POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_209_0"%string (equiv_checker [DUP 5;PUSH 28 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff%positive);Opcode NOT;PUSH 4 (posToWord WLen 0x150b7a02%positive);PUSH 1 (posToWord WLen 0xe0%positive);Opcode SHL;DUP 2;DUP 8;DUP 7;DUP 2;Opcode AND;DUP 2;Opcode AND;Opcode EQ;DUP 6;POP;POP;POP;POP;POP] [PUSH 4 (posToWord WLen 0x150B7A02%positive);PUSH 1 (posToWord WLen 0xE0%positive);Opcode SHL;PUSH 28 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode NOT;Opcode AND;DUP 2;PUSH 28 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);Opcode NOT;Opcode AND;Opcode EQ;DUP 2;POP;POP;DUP 5;DUP 4;POP;POP;POP;POP] 7 optimize_id).

(*
 I: PUSH 60 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH 60 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_210_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x40%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 0 DUP2
 O: DUP1 PUSH 0 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_210_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);DUP 2] [DUP 1;PUSH 1 (posToWord WLen 0x0%positive);DUP 2] 1 optimize_id).

(*
 I: POP SWAP1 POP SWAP1
 O: POP SWAP2 SWAP1 POP
*)
Compute pair "ERC721A_run_code_of_0_block_210_2"%string (equiv_checker [POP;DUP 2;DUP 1;POP] [POP;DUP 1;POP;DUP 1] 4 optimize_id).

(*
 I: PUSH 60 PUSH 80 PUSH 40 MLOAD ADD SWAP1 POP DUP1 PUSH 40
 O: PUSH 80 PUSH 40 MLOAD ADD DUP1 PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_211_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x80%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;Opcode ADD;DUP 1;PUSH 1 (posToWord WLen 0x40%positive)] [PUSH 1 (posToWord WLen 0x60%positive);PUSH 1 (posToWord WLen 0x80%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;Opcode ADD;DUP 1;POP;DUP 1;PUSH 1 (posToWord WLen 0x40%positive)] 0 optimize_id).

(*
 I: DUP1 DUP3
 O: DUP1 DUP3
*)
Compute pair "ERC721A_run_code_of_0_block_211_1"%string (equiv_checker [DUP 1;DUP 3] [DUP 1;DUP 3] 2 optimize_id).

(*
 I: PUSH 1 ISZERO PUSH [tag] 209
 O: PUSH 1 ISZERO PUSH [tag] 209
*)
Compute pair "ERC721A_run_code_of_0_block_212_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive);Opcode ISZERO;PUSH 1 (posToWord WLen 0xd1%positive)] [PUSH 1 (posToWord WLen 0x1%positive);Opcode ISZERO;PUSH 1 (posToWord WLen 0xd1%positive)] 0 optimize_id).

(*
 I: PUSH 1 DUP4 SUB SWAP3 POP PUSH A DUP2 MOD PUSH 30 ADD DUP4
 O: PUSH 1 PUSH 30 SWAP4 SUB SWAP3 PUSH a DUP3 MOD ADD DUP4
*)
Compute pair "ERC721A_run_code_of_0_block_213_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1%positive);PUSH 1 (posToWord WLen 0x30%positive);DUP 4;Opcode SUB;DUP 3;PUSH 1 (posToWord WLen 0xa%positive);DUP 3;Opcode MOD;Opcode ADD;DUP 4] [PUSH 1 (posToWord WLen 0x1%positive);DUP 4;Opcode SUB;DUP 3;POP;PUSH 1 (posToWord WLen 0xA%positive);DUP 2;Opcode MOD;PUSH 1 (posToWord WLen 0x30%positive);Opcode ADD;DUP 4] 3 optimize_id).

(*
 I: PUSH A DUP2 DIV SWAP1 POP DUP1 PUSH [tag] 210
 O: PUSH a SWAP1 DIV DUP1 PUSH [tag] 210
*)
Compute pair "ERC721A_run_code_of_0_block_213_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0xa%positive);DUP 1;Opcode DIV;DUP 1;PUSH 1 (posToWord WLen 0xd2%positive)] [PUSH 1 (posToWord WLen 0xA%positive);DUP 2;Opcode DIV;DUP 1;POP;DUP 1;PUSH 1 (posToWord WLen 0xd2%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 209
 O: PUSH [tag] 209
*)
Compute pair "ERC721A_run_code_of_0_block_214_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xd1%positive)] [PUSH 1 (posToWord WLen 0xd1%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 207
 O: PUSH [tag] 207
*)
Compute pair "ERC721A_run_code_of_0_block_215_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xcf%positive)] [PUSH 1 (posToWord WLen 0xcf%positive)] 0 optimize_id).

(*
 I: POP DUP2 DUP2 SUB PUSH 20 DUP4 SUB SWAP3 POP DUP1 DUP4
 O: POP PUSH 20 DUP3 SUB SWAP2 DUP2 SUB DUP1 DUP4
*)
Compute pair "ERC721A_run_code_of_0_block_216_0"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode SUB;DUP 2;DUP 2;Opcode SUB;DUP 1;DUP 4] [POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x20%positive);DUP 4;Opcode SUB;DUP 3;POP;DUP 1;DUP 4] 3 optimize_id).

(*
 I: POP POP SWAP2 SWAP1 POP
 O: POP POP SWAP2 SWAP1 POP
*)
Compute pair "ERC721A_run_code_of_0_block_216_1"%string (equiv_checker [POP;POP;DUP 2;DUP 1;POP] [POP;POP;DUP 2;DUP 1;POP] 5 optimize_id).

(*
 I: PUSH 0 SWAP4 SWAP3 POP POP POP
 O: POP POP POP PUSH 0 SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_217_0"%string (equiv_checker [POP;POP;POP;PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 3;POP;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 215 PUSH [tag] 216 DUP5 PUSH [tag] 217
 O: PUSH 0 PUSH [tag] 215 PUSH [tag] 216 DUP5 PUSH [tag] 217
*)
Compute pair "ERC721A_run_code_of_0_block_218_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0xd7%positive);PUSH 1 (posToWord WLen 0xd8%positive);DUP 5;PUSH 1 (posToWord WLen 0xd9%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0xd7%positive);PUSH 1 (posToWord WLen 0xd8%positive);DUP 5;PUSH 1 (posToWord WLen 0xd9%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 218
 O: PUSH [tag] 218
*)
Compute pair "ERC721A_run_code_of_0_block_219_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xda%positive)] [PUSH 1 (posToWord WLen 0xda%positive)] 0 optimize_id).

(*
 I: SWAP1 POP DUP3 DUP2
 O: SWAP1 POP DUP3 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_220_0"%string (equiv_checker [DUP 1;POP;DUP 3;DUP 2] [DUP 1;POP;DUP 3;DUP 2] 4 optimize_id).

(*
 I: PUSH 20 DUP2 ADD DUP5 DUP5 DUP5 ADD GT ISZERO PUSH [tag] 219
 O: DUP1 PUSH 20 ADD DUP5 DUP4 DUP6 ADD GT ISZERO PUSH [tag] 219
*)
Compute pair "ERC721A_run_code_of_0_block_220_1"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 5;DUP 4;DUP 6;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0xdb%positive)] [PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;DUP 5;DUP 5;DUP 5;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (posToWord WLen 0xdb%positive)] 4 optimize_id).

(*
 I: PUSH [tag] 220 PUSH [tag] 221
 O: PUSH [tag] 220 PUSH [tag] 221
*)
Compute pair "ERC721A_run_code_of_0_block_221_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xdc%positive);PUSH 1 (posToWord WLen 0xdd%positive)] [PUSH 1 (posToWord WLen 0xdc%positive);PUSH 1 (posToWord WLen 0xdd%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 222 DUP5 DUP3 DUP6 PUSH [tag] 223
 O: PUSH [tag] 222 DUP5 DUP3 DUP6 PUSH [tag] 223
*)
Compute pair "ERC721A_run_code_of_0_block_223_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xde%positive);DUP 5;DUP 3;DUP 6;PUSH 1 (posToWord WLen 0xdf%positive)] [PUSH 1 (posToWord WLen 0xde%positive);DUP 5;DUP 3;DUP 6;PUSH 1 (posToWord WLen 0xdf%positive)] 4 optimize_id).

(*
 I: POP SWAP4 SWAP3 POP POP POP
 O: POP SWAP4 SWAP3 POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_224_0"%string (equiv_checker [POP;DUP 4;DUP 3;POP;POP;POP] [POP;DUP 4;DUP 3;POP;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 226 DUP2 PUSH [tag] 227
 O: DUP1 CALLDATALOAD PUSH [tag] 226 DUP2 PUSH [tag] 227
*)
Compute pair "ERC721A_run_code_of_0_block_225_0"%string (equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 1 (posToWord WLen 0xe2%positive);DUP 2;PUSH 1 (posToWord WLen 0xe3%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode CALLDATALOAD;DUP 1;POP;PUSH 1 (posToWord WLen 0xe2%positive);DUP 2;PUSH 1 (posToWord WLen 0xe3%positive)] 1 optimize_id).

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_226_0"%string (equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 230 DUP2 PUSH [tag] 231
 O: DUP1 CALLDATALOAD PUSH [tag] 230 DUP2 PUSH [tag] 231
*)
Compute pair "ERC721A_run_code_of_0_block_227_0"%string (equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 1 (posToWord WLen 0xe6%positive);DUP 2;PUSH 1 (posToWord WLen 0xe7%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode CALLDATALOAD;DUP 1;POP;PUSH 1 (posToWord WLen 0xe6%positive);DUP 2;PUSH 1 (posToWord WLen 0xe7%positive)] 1 optimize_id).

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_228_0"%string (equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 234 DUP2 PUSH [tag] 235
 O: DUP1 CALLDATALOAD PUSH [tag] 234 DUP2 PUSH [tag] 235
*)
Compute pair "ERC721A_run_code_of_0_block_229_0"%string (equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 1 (posToWord WLen 0xea%positive);DUP 2;PUSH 1 (posToWord WLen 0xeb%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode CALLDATALOAD;DUP 1;POP;PUSH 1 (posToWord WLen 0xea%positive);DUP 2;PUSH 1 (posToWord WLen 0xeb%positive)] 1 optimize_id).

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_230_0"%string (equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP PUSH [tag] 238 DUP2 PUSH [tag] 235
 O: DUP1 MLOAD PUSH [tag] 238 DUP2 PUSH [tag] 235
*)
Compute pair "ERC721A_run_code_of_0_block_231_0"%string (equiv_checker [DUP 1;Opcode MLOAD;PUSH 1 (posToWord WLen 0xee%positive);DUP 2;PUSH 1 (posToWord WLen 0xeb%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode MLOAD;DUP 1;POP;PUSH 1 (posToWord WLen 0xee%positive);DUP 2;PUSH 1 (posToWord WLen 0xeb%positive)] 1 optimize_id).

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_232_0"%string (equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 241
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 241
*)
Compute pair "ERC721A_run_code_of_0_block_233_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 3;PUSH 1 (posToWord WLen 0x1f%positive);Opcode ADD;Opcode SLT;PUSH 1 (posToWord WLen 0xf1%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;PUSH 1 (posToWord WLen 0x1F%positive);DUP 4;Opcode ADD;Opcode SLT;PUSH 1 (posToWord WLen 0xf1%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 242 PUSH [tag] 243
 O: PUSH [tag] 242 PUSH [tag] 243
*)
Compute pair "ERC721A_run_code_of_0_block_234_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xf2%positive);PUSH 1 (posToWord WLen 0xf3%positive)] [PUSH 1 (posToWord WLen 0xf2%positive);PUSH 1 (posToWord WLen 0xf3%positive)] 0 optimize_id).

(*
 I: DUP2 CALLDATALOAD PUSH [tag] 244 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 213
 O: DUP2 CALLDATALOAD PUSH [tag] 244 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 213
*)
Compute pair "ERC721A_run_code_of_0_block_236_0"%string (equiv_checker [DUP 2;Opcode CALLDATALOAD;PUSH 1 (posToWord WLen 0xf4%positive);DUP 5;DUP 3;PUSH 1 (posToWord WLen 0x20%positive);DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0xd5%positive)] [DUP 2;Opcode CALLDATALOAD;PUSH 1 (posToWord WLen 0xf4%positive);DUP 5;DUP 3;PUSH 1 (posToWord WLen 0x20%positive);DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0xd5%positive)] 3 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_237_0"%string (equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 247 DUP2 PUSH [tag] 248
 O: DUP1 CALLDATALOAD PUSH [tag] 247 DUP2 PUSH [tag] 248
*)
Compute pair "ERC721A_run_code_of_0_block_238_0"%string (equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 1 (posToWord WLen 0xf7%positive);DUP 2;PUSH 1 (posToWord WLen 0xf8%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode CALLDATALOAD;DUP 1;POP;PUSH 1 (posToWord WLen 0xf7%positive);DUP 2;PUSH 1 (posToWord WLen 0xf8%positive)] 1 optimize_id).

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_239_0"%string (equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 250
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 250
*)
Compute pair "ERC721A_run_code_of_0_block_240_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (posToWord WLen 0xfa%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (posToWord WLen 0xfa%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 251 PUSH [tag] 252
 O: PUSH [tag] 251 PUSH [tag] 252
*)
Compute pair "ERC721A_run_code_of_0_block_241_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0xfb%positive);PUSH 1 (posToWord WLen 0xfc%positive)] [PUSH 1 (posToWord WLen 0xfb%positive);PUSH 1 (posToWord WLen 0xfc%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 253 DUP5 DUP3 DUP6 ADD PUSH [tag] 224
 O: PUSH 0 PUSH [tag] 253 DUP5 DUP5 DUP4 ADD PUSH [tag] 224
*)
Compute pair "ERC721A_run_code_of_0_block_243_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0xfd%positive);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0xe0%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0xfd%positive);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 1 (posToWord WLen 0xe0%positive)] 3 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_244_0"%string (equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 255
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 255
*)
Compute pair "ERC721A_run_code_of_0_block_245_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (posToWord WLen 0xff%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (posToWord WLen 0xff%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 256 PUSH [tag] 252
 O: PUSH [tag] 256 PUSH [tag] 252
*)
Compute pair "ERC721A_run_code_of_0_block_246_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x100%positive);PUSH 1 (posToWord WLen 0xfc%positive)] [PUSH 2 (posToWord WLen 0x100%positive);PUSH 1 (posToWord WLen 0xfc%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 257 DUP6 DUP3 DUP7 ADD PUSH [tag] 224
 O: PUSH 0 PUSH [tag] 257 DUP6 DUP6 DUP4 ADD PUSH [tag] 224
*)
Compute pair "ERC721A_run_code_of_0_block_248_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x101%positive);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0xe0%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x101%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0xe0%positive)] 4 optimize_id).

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 258 DUP6 DUP3 DUP7 ADD PUSH [tag] 224
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 258 DUP6 DUP6 DUP4 ADD PUSH [tag] 224
*)
Compute pair "ERC721A_run_code_of_0_block_249_0"%string (equiv_checker [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x102%positive);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0xe0%positive)] [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x102%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0xe0%positive)] 6 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute pair "ERC721A_run_code_of_0_block_250_0"%string (equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 0 PUSH 60 DUP5 DUP7 SUB SLT ISZERO PUSH [tag] 260
 O: PUSH 0 DUP1 DUP2 PUSH 60 DUP5 DUP7 SUB SLT ISZERO PUSH [tag] 260
*)
Compute pair "ERC721A_run_code_of_0_block_251_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;DUP 2;PUSH 1 (posToWord WLen 0x60%positive);DUP 5;DUP 7;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x104%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x60%positive);DUP 5;DUP 7;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x104%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 261 PUSH [tag] 252
 O: PUSH [tag] 261 PUSH [tag] 252
*)
Compute pair "ERC721A_run_code_of_0_block_252_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x105%positive);PUSH 1 (posToWord WLen 0xfc%positive)] [PUSH 2 (posToWord WLen 0x105%positive);PUSH 1 (posToWord WLen 0xfc%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 262 DUP7 DUP3 DUP8 ADD PUSH [tag] 224
 O: PUSH 0 PUSH [tag] 262 DUP7 DUP7 DUP4 ADD PUSH [tag] 224
*)
Compute pair "ERC721A_run_code_of_0_block_254_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x106%positive);DUP 7;DUP 7;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0xe0%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x106%positive);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 1 (posToWord WLen 0xe0%positive)] 5 optimize_id).

(*
 I: SWAP4 POP POP PUSH 20 PUSH [tag] 263 DUP7 DUP3 DUP8 ADD PUSH [tag] 224
 O: SWAP4 POP POP PUSH 20 PUSH [tag] 263 DUP7 DUP7 DUP4 ADD PUSH [tag] 224
*)
Compute pair "ERC721A_run_code_of_0_block_255_0"%string (equiv_checker [DUP 4;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x107%positive);DUP 7;DUP 7;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0xe0%positive)] [DUP 4;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x107%positive);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 1 (posToWord WLen 0xe0%positive)] 7 optimize_id).

(*
 I: SWAP3 POP POP PUSH 40 PUSH [tag] 264 DUP7 DUP3 DUP8 ADD PUSH [tag] 245
 O: SWAP3 POP POP PUSH 40 PUSH [tag] 264 DUP7 DUP3 DUP8 ADD PUSH [tag] 245
*)
Compute pair "ERC721A_run_code_of_0_block_256_0"%string (equiv_checker [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x40%positive);PUSH 2 (posToWord WLen 0x108%positive);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 1 (posToWord WLen 0xf5%positive)] [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x40%positive);PUSH 2 (posToWord WLen 0x108%positive);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 1 (posToWord WLen 0xf5%positive)] 7 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 POP SWAP3
 O: SWAP5 POP POP POP SWAP3 POP SWAP3
*)
Compute pair "ERC721A_run_code_of_0_block_257_0"%string (equiv_checker [DUP 5;POP;POP;POP;DUP 3;POP;DUP 3] [DUP 2;POP;POP;DUP 3;POP;DUP 3;POP;DUP 3] 8 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 0 DUP1 PUSH 80 DUP6 DUP8 SUB SLT ISZERO PUSH [tag] 266
 O: PUSH 0 DUP1 DUP1 DUP3 PUSH 80 DUP6 DUP8 SUB SLT ISZERO PUSH [tag] 266
*)
Compute pair "ERC721A_run_code_of_0_block_258_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;DUP 1;DUP 3;PUSH 1 (posToWord WLen 0x80%positive);DUP 6;DUP 8;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x10a%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x80%positive);DUP 6;DUP 8;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x10a%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 267 PUSH [tag] 252
 O: PUSH [tag] 267 PUSH [tag] 252
*)
Compute pair "ERC721A_run_code_of_0_block_259_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x10b%positive);PUSH 1 (posToWord WLen 0xfc%positive)] [PUSH 2 (posToWord WLen 0x10b%positive);PUSH 1 (posToWord WLen 0xfc%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 268 DUP8 DUP3 DUP9 ADD PUSH [tag] 224
 O: PUSH 0 PUSH [tag] 268 DUP8 DUP8 DUP4 ADD PUSH [tag] 224
*)
Compute pair "ERC721A_run_code_of_0_block_261_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x10c%positive);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0xe0%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x10c%positive);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 1 (posToWord WLen 0xe0%positive)] 6 optimize_id).

(*
 I: SWAP5 POP POP PUSH 20 PUSH [tag] 269 DUP8 DUP3 DUP9 ADD PUSH [tag] 224
 O: SWAP5 POP POP PUSH 20 PUSH [tag] 269 DUP8 DUP8 DUP4 ADD PUSH [tag] 224
*)
Compute pair "ERC721A_run_code_of_0_block_262_0"%string (equiv_checker [DUP 5;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x10d%positive);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0xe0%positive)] [DUP 5;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x10d%positive);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 1 (posToWord WLen 0xe0%positive)] 8 optimize_id).

(*
 I: SWAP4 POP POP PUSH 40 PUSH [tag] 270 DUP8 DUP3 DUP9 ADD PUSH [tag] 245
 O: SWAP4 POP POP PUSH 40 PUSH [tag] 270 DUP8 DUP8 DUP4 ADD PUSH [tag] 245
*)
Compute pair "ERC721A_run_code_of_0_block_263_0"%string (equiv_checker [DUP 4;POP;POP;PUSH 1 (posToWord WLen 0x40%positive);PUSH 2 (posToWord WLen 0x10e%positive);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0xf5%positive)] [DUP 4;POP;POP;PUSH 1 (posToWord WLen 0x40%positive);PUSH 2 (posToWord WLen 0x10e%positive);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 1 (posToWord WLen 0xf5%positive)] 8 optimize_id).

(*
 I: SWAP3 POP POP PUSH 60 DUP6 ADD CALLDATALOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 271
 O: SWAP3 POP POP DUP5 PUSH 60 ADD CALLDATALOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 271
*)
Compute pair "ERC721A_run_code_of_0_block_264_0"%string (equiv_checker [DUP 3;POP;POP;DUP 5;PUSH 1 (posToWord WLen 0x60%positive);Opcode ADD;Opcode CALLDATALOAD;PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x10f%positive)] [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x60%positive);DUP 6;Opcode ADD;Opcode CALLDATALOAD;PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x10f%positive)] 7 optimize_id).

(*
 I: PUSH [tag] 272 PUSH [tag] 273
 O: PUSH [tag] 272 PUSH [tag] 273
*)
Compute pair "ERC721A_run_code_of_0_block_265_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x110%positive);PUSH 2 (posToWord WLen 0x111%positive)] [PUSH 2 (posToWord WLen 0x110%positive);PUSH 2 (posToWord WLen 0x111%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 274 DUP8 DUP3 DUP9 ADD PUSH [tag] 239
 O: PUSH [tag] 274 DUP8 DUP8 DUP4 ADD PUSH [tag] 239
*)
Compute pair "ERC721A_run_code_of_0_block_267_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x112%positive);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0xef%positive)] [PUSH 2 (posToWord WLen 0x112%positive);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 1 (posToWord WLen 0xef%positive)] 7 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP6 SWAP2 SWAP5 POP SWAP3 POP
 O: SWAP5 SWAP8 SWAP4 SWAP7 POP POP POP SWAP3 POP
*)
Compute pair "ERC721A_run_code_of_0_block_268_0"%string (equiv_checker [DUP 5;DUP 8;DUP 4;DUP 7;POP;POP;POP;DUP 3;POP] [DUP 2;POP;POP;DUP 3;DUP 6;DUP 2;DUP 5;POP;DUP 3;POP] 9 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 276
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 276
*)
Compute pair "ERC721A_run_code_of_0_block_269_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x114%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x114%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 277 PUSH [tag] 252
 O: PUSH [tag] 277 PUSH [tag] 252
*)
Compute pair "ERC721A_run_code_of_0_block_270_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x115%positive);PUSH 1 (posToWord WLen 0xfc%positive)] [PUSH 2 (posToWord WLen 0x115%positive);PUSH 1 (posToWord WLen 0xfc%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 278 DUP6 DUP3 DUP7 ADD PUSH [tag] 224
 O: PUSH 0 PUSH [tag] 278 DUP6 DUP6 DUP4 ADD PUSH [tag] 224
*)
Compute pair "ERC721A_run_code_of_0_block_272_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x116%positive);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0xe0%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x116%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0xe0%positive)] 4 optimize_id).

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 279 DUP6 DUP3 DUP7 ADD PUSH [tag] 228
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 279 DUP6 DUP6 DUP4 ADD PUSH [tag] 228
*)
Compute pair "ERC721A_run_code_of_0_block_273_0"%string (equiv_checker [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x117%positive);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0xe4%positive)] [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x117%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0xe4%positive)] 6 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute pair "ERC721A_run_code_of_0_block_274_0"%string (equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 281
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 281
*)
Compute pair "ERC721A_run_code_of_0_block_275_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x119%positive)] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1;PUSH 1 (posToWord WLen 0x40%positive);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x119%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 282 PUSH [tag] 252
 O: PUSH [tag] 282 PUSH [tag] 252
*)
Compute pair "ERC721A_run_code_of_0_block_276_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x11a%positive);PUSH 1 (posToWord WLen 0xfc%positive)] [PUSH 2 (posToWord WLen 0x11a%positive);PUSH 1 (posToWord WLen 0xfc%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 283 DUP6 DUP3 DUP7 ADD PUSH [tag] 224
 O: PUSH 0 PUSH [tag] 283 DUP6 DUP6 DUP4 ADD PUSH [tag] 224
*)
Compute pair "ERC721A_run_code_of_0_block_278_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x11b%positive);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0xe0%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x11b%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0xe0%positive)] 4 optimize_id).

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 284 DUP6 DUP3 DUP7 ADD PUSH [tag] 245
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 284 DUP6 DUP6 DUP4 ADD PUSH [tag] 245
*)
Compute pair "ERC721A_run_code_of_0_block_279_0"%string (equiv_checker [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x11c%positive);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0xf5%positive)] [DUP 3;POP;POP;PUSH 1 (posToWord WLen 0x20%positive);PUSH 2 (posToWord WLen 0x11c%positive);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (posToWord WLen 0xf5%positive)] 6 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute pair "ERC721A_run_code_of_0_block_280_0"%string (equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 286
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 286
*)
Compute pair "ERC721A_run_code_of_0_block_281_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x11e%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x11e%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 287 PUSH [tag] 252
 O: PUSH [tag] 287 PUSH [tag] 252
*)
Compute pair "ERC721A_run_code_of_0_block_282_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x11f%positive);PUSH 1 (posToWord WLen 0xfc%positive)] [PUSH 2 (posToWord WLen 0x11f%positive);PUSH 1 (posToWord WLen 0xfc%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 288 DUP5 DUP3 DUP6 ADD PUSH [tag] 232
 O: PUSH 0 PUSH [tag] 288 DUP5 DUP5 DUP4 ADD PUSH [tag] 232
*)
Compute pair "ERC721A_run_code_of_0_block_284_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x120%positive);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0xe8%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x120%positive);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 1 (posToWord WLen 0xe8%positive)] 3 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_285_0"%string (equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 290
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 290
*)
Compute pair "ERC721A_run_code_of_0_block_286_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x122%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x122%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 291 PUSH [tag] 252
 O: PUSH [tag] 291 PUSH [tag] 252
*)
Compute pair "ERC721A_run_code_of_0_block_287_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x123%positive);PUSH 1 (posToWord WLen 0xfc%positive)] [PUSH 2 (posToWord WLen 0x123%positive);PUSH 1 (posToWord WLen 0xfc%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 292 DUP5 DUP3 DUP6 ADD PUSH [tag] 236
 O: PUSH 0 PUSH [tag] 292 DUP5 DUP5 DUP4 ADD PUSH [tag] 236
*)
Compute pair "ERC721A_run_code_of_0_block_289_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x124%positive);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0xec%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x124%positive);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 1 (posToWord WLen 0xec%positive)] 3 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_290_0"%string (equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 294
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 294
*)
Compute pair "ERC721A_run_code_of_0_block_291_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x126%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x126%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 295 PUSH [tag] 252
 O: PUSH [tag] 295 PUSH [tag] 252
*)
Compute pair "ERC721A_run_code_of_0_block_292_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x127%positive);PUSH 1 (posToWord WLen 0xfc%positive)] [PUSH 2 (posToWord WLen 0x127%positive);PUSH 1 (posToWord WLen 0xfc%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 296 DUP5 DUP3 DUP6 ADD PUSH [tag] 245
 O: PUSH 0 PUSH [tag] 296 DUP5 DUP5 DUP4 ADD PUSH [tag] 245
*)
Compute pair "ERC721A_run_code_of_0_block_294_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x128%positive);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 1 (posToWord WLen 0xf5%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x128%positive);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 1 (posToWord WLen 0xf5%positive)] 3 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_295_0"%string (equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH [tag] 299 DUP2 PUSH [tag] 300
 O: PUSH [tag] 299 DUP2 PUSH [tag] 300
*)
Compute pair "ERC721A_run_code_of_0_block_296_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x12b%positive);DUP 2;PUSH 2 (posToWord WLen 0x12c%positive)] [PUSH 2 (posToWord WLen 0x12b%positive);DUP 2;PUSH 2 (posToWord WLen 0x12c%positive)] 1 optimize_id).

(*
 I: DUP3
 O: DUP3
*)
Compute pair "ERC721A_run_code_of_0_block_297_0"%string (equiv_checker [DUP 3] [DUP 3] 3 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_297_1"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH [tag] 303 DUP2 PUSH [tag] 304
 O: PUSH [tag] 303 DUP2 PUSH [tag] 304
*)
Compute pair "ERC721A_run_code_of_0_block_298_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x12f%positive);DUP 2;PUSH 2 (posToWord WLen 0x130%positive)] [PUSH 2 (posToWord WLen 0x12f%positive);DUP 2;PUSH 2 (posToWord WLen 0x130%positive)] 1 optimize_id).

(*
 I: DUP3
 O: DUP3
*)
Compute pair "ERC721A_run_code_of_0_block_299_0"%string (equiv_checker [DUP 3] [DUP 3] 3 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_299_1"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 307 DUP3 PUSH [tag] 308
 O: PUSH 0 PUSH [tag] 307 DUP3 PUSH [tag] 308
*)
Compute pair "ERC721A_run_code_of_0_block_300_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x133%positive);DUP 3;PUSH 2 (posToWord WLen 0x134%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x133%positive);DUP 3;PUSH 2 (posToWord WLen 0x134%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 309 DUP2 DUP6 PUSH [tag] 310
 O: PUSH [tag] 309 DUP2 DUP6 PUSH [tag] 310
*)
Compute pair "ERC721A_run_code_of_0_block_301_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x135%positive);DUP 2;DUP 6;PUSH 2 (posToWord WLen 0x136%positive)] [PUSH 2 (posToWord WLen 0x135%positive);DUP 2;DUP 6;PUSH 2 (posToWord WLen 0x136%positive)] 4 optimize_id).

(*
 I: SWAP4 POP PUSH [tag] 311 DUP2 DUP6 PUSH 20 DUP7 ADD PUSH [tag] 312
 O: SWAP4 POP PUSH [tag] 311 DUP2 DUP6 DUP6 PUSH 20 ADD PUSH [tag] 312
*)
Compute pair "ERC721A_run_code_of_0_block_302_0"%string (equiv_checker [DUP 4;POP;PUSH 2 (posToWord WLen 0x137%positive);DUP 2;DUP 6;DUP 6;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x138%positive)] [DUP 4;POP;PUSH 2 (posToWord WLen 0x137%positive);DUP 2;DUP 6;PUSH 1 (posToWord WLen 0x20%positive);DUP 7;Opcode ADD;PUSH 2 (posToWord WLen 0x138%positive)] 5 optimize_id).

(*
 I: PUSH [tag] 313 DUP2 PUSH [tag] 314
 O: PUSH [tag] 313 DUP2 PUSH [tag] 314
*)
Compute pair "ERC721A_run_code_of_0_block_303_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x139%positive);DUP 2;PUSH 2 (posToWord WLen 0x13a%positive)] [PUSH 2 (posToWord WLen 0x139%positive);DUP 2;PUSH 2 (posToWord WLen 0x13a%positive)] 1 optimize_id).

(*
 I: DUP5 ADD SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP3 POP POP POP ADD SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_304_0"%string (equiv_checker [DUP 3;POP;POP;POP;Opcode ADD;DUP 1] [DUP 5;Opcode ADD;DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 317 DUP3 PUSH [tag] 318
 O: PUSH 0 PUSH [tag] 317 DUP3 PUSH [tag] 318
*)
Compute pair "ERC721A_run_code_of_0_block_305_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x13d%positive);DUP 3;PUSH 2 (posToWord WLen 0x13e%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x13d%positive);DUP 3;PUSH 2 (posToWord WLen 0x13e%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 319 DUP2 DUP6 PUSH [tag] 320
 O: PUSH [tag] 319 DUP2 DUP6 PUSH [tag] 320
*)
Compute pair "ERC721A_run_code_of_0_block_306_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x13f%positive);DUP 2;DUP 6;PUSH 2 (posToWord WLen 0x140%positive)] [PUSH 2 (posToWord WLen 0x13f%positive);DUP 2;DUP 6;PUSH 2 (posToWord WLen 0x140%positive)] 4 optimize_id).

(*
 I: SWAP4 POP PUSH [tag] 321 DUP2 DUP6 PUSH 20 DUP7 ADD PUSH [tag] 312
 O: SWAP4 POP PUSH [tag] 321 DUP2 DUP6 DUP6 PUSH 20 ADD PUSH [tag] 312
*)
Compute pair "ERC721A_run_code_of_0_block_307_0"%string (equiv_checker [DUP 4;POP;PUSH 2 (posToWord WLen 0x141%positive);DUP 2;DUP 6;DUP 6;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x138%positive)] [DUP 4;POP;PUSH 2 (posToWord WLen 0x141%positive);DUP 2;DUP 6;PUSH 1 (posToWord WLen 0x20%positive);DUP 7;Opcode ADD;PUSH 2 (posToWord WLen 0x138%positive)] 5 optimize_id).

(*
 I: PUSH [tag] 322 DUP2 PUSH [tag] 314
 O: PUSH [tag] 322 DUP2 PUSH [tag] 314
*)
Compute pair "ERC721A_run_code_of_0_block_308_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x142%positive);DUP 2;PUSH 2 (posToWord WLen 0x13a%positive)] [PUSH 2 (posToWord WLen 0x142%positive);DUP 2;PUSH 2 (posToWord WLen 0x13a%positive)] 1 optimize_id).

(*
 I: DUP5 ADD SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP3 POP POP POP ADD SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_309_0"%string (equiv_checker [DUP 3;POP;POP;POP;Opcode ADD;DUP 1] [DUP 5;Opcode ADD;DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 325 DUP3 PUSH [tag] 318
 O: PUSH 0 PUSH [tag] 325 DUP3 PUSH [tag] 318
*)
Compute pair "ERC721A_run_code_of_0_block_310_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x145%positive);DUP 3;PUSH 2 (posToWord WLen 0x13e%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x145%positive);DUP 3;PUSH 2 (posToWord WLen 0x13e%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 326 DUP2 DUP6 PUSH [tag] 327
 O: PUSH [tag] 326 DUP2 DUP6 PUSH [tag] 327
*)
Compute pair "ERC721A_run_code_of_0_block_311_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x146%positive);DUP 2;DUP 6;PUSH 2 (posToWord WLen 0x147%positive)] [PUSH 2 (posToWord WLen 0x146%positive);DUP 2;DUP 6;PUSH 2 (posToWord WLen 0x147%positive)] 4 optimize_id).

(*
 I: SWAP4 POP PUSH [tag] 328 DUP2 DUP6 PUSH 20 DUP7 ADD PUSH [tag] 312
 O: SWAP4 POP PUSH [tag] 328 DUP2 DUP6 DUP6 PUSH 20 ADD PUSH [tag] 312
*)
Compute pair "ERC721A_run_code_of_0_block_312_0"%string (equiv_checker [DUP 4;POP;PUSH 2 (posToWord WLen 0x148%positive);DUP 2;DUP 6;DUP 6;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x138%positive)] [DUP 4;POP;PUSH 2 (posToWord WLen 0x148%positive);DUP 2;DUP 6;PUSH 1 (posToWord WLen 0x20%positive);DUP 7;Opcode ADD;PUSH 2 (posToWord WLen 0x138%positive)] 5 optimize_id).

(*
 I: DUP1 DUP5 ADD SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP2 POP POP ADD SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_313_0"%string (equiv_checker [DUP 2;POP;POP;Opcode ADD;DUP 1] [DUP 1;DUP 5;Opcode ADD;DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 5 optimize_id).

(*
 I: PUSH [tag] 331 DUP2 PUSH [tag] 332
 O: PUSH [tag] 331 DUP2 PUSH [tag] 332
*)
Compute pair "ERC721A_run_code_of_0_block_314_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x14b%positive);DUP 2;PUSH 2 (posToWord WLen 0x14c%positive)] [PUSH 2 (posToWord WLen 0x14b%positive);DUP 2;PUSH 2 (posToWord WLen 0x14c%positive)] 1 optimize_id).

(*
 I: DUP3
 O: DUP3
*)
Compute pair "ERC721A_run_code_of_0_block_315_0"%string (equiv_checker [DUP 3] [DUP 3] 3 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_315_1"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 334 DUP3 DUP6 PUSH [tag] 323
 O: PUSH 0 PUSH [tag] 334 DUP3 DUP6 PUSH [tag] 323
*)
Compute pair "ERC721A_run_code_of_0_block_316_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x14e%positive);DUP 3;DUP 6;PUSH 2 (posToWord WLen 0x143%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x14e%positive);DUP 3;DUP 6;PUSH 2 (posToWord WLen 0x143%positive)] 3 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 335 DUP3 DUP5 PUSH [tag] 323
 O: SWAP2 POP PUSH [tag] 335 DUP3 DUP5 PUSH [tag] 323
*)
Compute pair "ERC721A_run_code_of_0_block_317_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (posToWord WLen 0x14f%positive);DUP 3;DUP 5;PUSH 2 (posToWord WLen 0x143%positive)] [DUP 2;POP;PUSH 2 (posToWord WLen 0x14f%positive);DUP 3;DUP 5;PUSH 2 (posToWord WLen 0x143%positive)] 4 optimize_id).

(*
 I: SWAP2 POP DUP2 SWAP1 POP SWAP4 SWAP3 POP POP POP
 O: SWAP4 POP POP POP POP SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_318_0"%string (equiv_checker [DUP 4;POP;POP;POP;POP;DUP 1] [DUP 2;POP;DUP 2;DUP 1;POP;DUP 4;DUP 3;POP;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP PUSH [tag] 337 PUSH 0 DUP4 ADD DUP5 PUSH [tag] 297
 O: PUSH 20 DUP2 ADD PUSH [tag] 337 DUP3 PUSH 0 ADD DUP5 PUSH [tag] 297
*)
Compute pair "ERC721A_run_code_of_0_block_319_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;PUSH 2 (posToWord WLen 0x151%positive);DUP 3;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;DUP 5;PUSH 2 (posToWord WLen 0x129%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;PUSH 2 (posToWord WLen 0x151%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD;DUP 5;PUSH 2 (posToWord WLen 0x129%positive)] 2 optimize_id).

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_320_0"%string (equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 80 DUP3 ADD SWAP1 POP PUSH [tag] 339 PUSH 0 DUP4 ADD DUP8 PUSH [tag] 297
 O: PUSH 80 DUP2 ADD PUSH [tag] 339 DUP3 PUSH 0 ADD DUP8 PUSH [tag] 297
*)
Compute pair "ERC721A_run_code_of_0_block_321_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x80%positive);DUP 2;Opcode ADD;PUSH 2 (posToWord WLen 0x153%positive);DUP 3;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;DUP 8;PUSH 2 (posToWord WLen 0x129%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x80%positive);DUP 3;Opcode ADD;DUP 1;POP;PUSH 2 (posToWord WLen 0x153%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD;DUP 8;PUSH 2 (posToWord WLen 0x129%positive)] 5 optimize_id).

(*
 I: PUSH [tag] 340 PUSH 20 DUP4 ADD DUP7 PUSH [tag] 297
 O: PUSH [tag] 340 DUP3 PUSH 20 ADD DUP7 PUSH [tag] 297
*)
Compute pair "ERC721A_run_code_of_0_block_322_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x154%positive);DUP 3;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 7;PUSH 2 (posToWord WLen 0x129%positive)] [PUSH 2 (posToWord WLen 0x154%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 4;Opcode ADD;DUP 7;PUSH 2 (posToWord WLen 0x129%positive)] 5 optimize_id).

(*
 I: PUSH [tag] 341 PUSH 40 DUP4 ADD DUP6 PUSH [tag] 329
 O: PUSH [tag] 341 PUSH 40 DUP4 ADD DUP6 PUSH [tag] 329
*)
Compute pair "ERC721A_run_code_of_0_block_323_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x155%positive);PUSH 1 (posToWord WLen 0x40%positive);DUP 4;Opcode ADD;DUP 6;PUSH 2 (posToWord WLen 0x149%positive)] [PUSH 2 (posToWord WLen 0x155%positive);PUSH 1 (posToWord WLen 0x40%positive);DUP 4;Opcode ADD;DUP 6;PUSH 2 (posToWord WLen 0x149%positive)] 4 optimize_id).

(*
 I: DUP2 DUP2 SUB PUSH 60 DUP4 ADD
 O: DUP2 DUP2 SUB PUSH 60 DUP4 ADD
*)
Compute pair "ERC721A_run_code_of_0_block_324_0"%string (equiv_checker [DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x60%positive);DUP 4;Opcode ADD] [DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x60%positive);DUP 4;Opcode ADD] 2 optimize_id).

(*
 I: PUSH [tag] 342 DUP2 DUP5 PUSH [tag] 305
 O: PUSH [tag] 342 DUP2 DUP5 PUSH [tag] 305
*)
Compute pair "ERC721A_run_code_of_0_block_324_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x156%positive);DUP 2;DUP 5;PUSH 2 (posToWord WLen 0x131%positive)] [PUSH 2 (posToWord WLen 0x156%positive);DUP 2;DUP 5;PUSH 2 (posToWord WLen 0x131%positive)] 3 optimize_id).

(*
 I: SWAP1 POP SWAP6 SWAP5 POP POP POP POP POP
 O: SWAP7 SWAP6 POP POP POP POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_325_0"%string (equiv_checker [DUP 7;DUP 6;POP;POP;POP;POP;POP;POP] [DUP 1;POP;DUP 6;DUP 5;POP;POP;POP;POP;POP] 8 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP PUSH [tag] 344 PUSH 0 DUP4 ADD DUP5 PUSH [tag] 301
 O: PUSH 20 DUP2 ADD PUSH [tag] 344 DUP3 PUSH 0 ADD DUP5 PUSH [tag] 301
*)
Compute pair "ERC721A_run_code_of_0_block_326_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;PUSH 2 (posToWord WLen 0x158%positive);DUP 3;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;DUP 5;PUSH 2 (posToWord WLen 0x12d%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;PUSH 2 (posToWord WLen 0x158%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD;DUP 5;PUSH 2 (posToWord WLen 0x12d%positive)] 2 optimize_id).

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_327_0"%string (equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Compute pair "ERC721A_run_code_of_0_block_328_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD] 1 optimize_id).

(*
 I: PUSH [tag] 346 DUP2 DUP5 PUSH [tag] 315
 O: PUSH [tag] 346 DUP2 DUP5 PUSH [tag] 315
*)
Compute pair "ERC721A_run_code_of_0_block_328_1"%string (equiv_checker [PUSH 2 (posToWord WLen 0x15a%positive);DUP 2;DUP 5;PUSH 2 (posToWord WLen 0x13b%positive)] [PUSH 2 (posToWord WLen 0x15a%positive);DUP 2;DUP 5;PUSH 2 (posToWord WLen 0x13b%positive)] 3 optimize_id).

(*
 I: SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP4 SWAP3 POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_329_0"%string (equiv_checker [DUP 4;DUP 3;POP;POP;POP] [DUP 1;POP;DUP 3;DUP 2;POP;POP] 5 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP PUSH [tag] 348 PUSH 0 DUP4 ADD DUP5 PUSH [tag] 329
 O: PUSH 20 DUP2 ADD PUSH [tag] 348 DUP3 PUSH 0 ADD DUP5 PUSH [tag] 329
*)
Compute pair "ERC721A_run_code_of_0_block_330_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;PUSH 2 (posToWord WLen 0x15c%positive);DUP 3;PUSH 1 (posToWord WLen 0x0%positive);Opcode ADD;DUP 5;PUSH 2 (posToWord WLen 0x149%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;PUSH 2 (posToWord WLen 0x15c%positive);PUSH 1 (posToWord WLen 0x0%positive);DUP 4;Opcode ADD;DUP 5;PUSH 2 (posToWord WLen 0x149%positive)] 2 optimize_id).

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_331_0"%string (equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 350 PUSH [tag] 351
 O: PUSH 0 PUSH [tag] 350 PUSH [tag] 351
*)
Compute pair "ERC721A_run_code_of_0_block_332_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x15e%positive);PUSH 2 (posToWord WLen 0x15f%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x15e%positive);PUSH 2 (posToWord WLen 0x15f%positive)] 0 optimize_id).

(*
 I: SWAP1 POP PUSH [tag] 352 DUP3 DUP3 PUSH [tag] 353
 O: SWAP1 POP PUSH [tag] 352 DUP3 DUP3 PUSH [tag] 353
*)
Compute pair "ERC721A_run_code_of_0_block_333_0"%string (equiv_checker [DUP 1;POP;PUSH 2 (posToWord WLen 0x160%positive);DUP 3;DUP 3;PUSH 2 (posToWord WLen 0x161%positive)] [DUP 1;POP;PUSH 2 (posToWord WLen 0x160%positive);DUP 3;DUP 3;PUSH 2 (posToWord WLen 0x161%positive)] 3 optimize_id).

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Compute pair "ERC721A_run_code_of_0_block_334_0"%string (equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH 40 MLOAD SWAP1 POP SWAP1
 O: PUSH 40 MLOAD SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_335_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x40%positive);Opcode MLOAD;DUP 1;POP;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFF DUP3 GT ISZERO PUSH [tag] 356
 O: PUSH 0 PUSH ffffffffffffffff DUP3 GT ISZERO PUSH [tag] 356
*)
Compute pair "ERC721A_run_code_of_0_block_336_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x164%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x164%positive)] 1 optimize_id).

(*
 I: PUSH [tag] 357 PUSH [tag] 358
 O: PUSH [tag] 357 PUSH [tag] 358
*)
Compute pair "ERC721A_run_code_of_0_block_337_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x165%positive);PUSH 2 (posToWord WLen 0x166%positive)] [PUSH 2 (posToWord WLen 0x165%positive);PUSH 2 (posToWord WLen 0x166%positive)] 0 optimize_id).

(*
 I: PUSH [tag] 359 DUP3 PUSH [tag] 314
 O: PUSH [tag] 359 DUP3 PUSH [tag] 314
*)
Compute pair "ERC721A_run_code_of_0_block_339_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x167%positive);DUP 3;PUSH 2 (posToWord WLen 0x13a%positive)] [PUSH 2 (posToWord WLen 0x167%positive);DUP 3;PUSH 2 (posToWord WLen 0x13a%positive)] 2 optimize_id).

(*
 I: SWAP1 POP PUSH 20 DUP2 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP2 POP POP SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_340_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;DUP 2;POP;POP;DUP 1] [DUP 1;POP;PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP SWAP2 SWAP1 POP
 O: MLOAD SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_341_0"%string (equiv_checker [Opcode MLOAD;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode MLOAD;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP SWAP2 SWAP1 POP
 O: MLOAD SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_342_0"%string (equiv_checker [Opcode MLOAD;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode MLOAD;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH 0 DUP3 DUP3
 O: PUSH 0 DUP3 DUP3
*)
Compute pair "ERC721A_run_code_of_0_block_343_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 3] [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 3] 2 optimize_id).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP PUSH 20 SWAP2 POP ADD SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_343_1"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x20%positive);DUP 2;POP;Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP3 DUP3
 O: PUSH 0 DUP3 DUP3
*)
Compute pair "ERC721A_run_code_of_0_block_344_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 3] [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 3] 2 optimize_id).

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP PUSH 20 SWAP2 POP ADD SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_344_1"%string (equiv_checker [POP;PUSH 1 (posToWord WLen 0x20%positive);DUP 2;POP;Opcode ADD;DUP 1] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode ADD;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP2 SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP2 SWAP1 POP
*)
Compute pair "ERC721A_run_code_of_0_block_345_0"%string (equiv_checker [DUP 2;DUP 1;POP] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;DUP 1;POP;DUP 3;DUP 2;POP;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 366 DUP3 PUSH [tag] 367
 O: PUSH 0 PUSH [tag] 366 DUP3 PUSH [tag] 367
*)
Compute pair "ERC721A_run_code_of_0_block_346_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x16e%positive);DUP 3;PUSH 2 (posToWord WLen 0x16f%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 2 (posToWord WLen 0x16e%positive);DUP 3;PUSH 2 (posToWord WLen 0x16f%positive)] 1 optimize_id).

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_347_0"%string (equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP2 ISZERO ISZERO SWAP1 POP SWAP2 SWAP1 POP
 O: ISZERO ISZERO SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_348_0"%string (equiv_checker [Opcode ISZERO;Opcode ISZERO;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;Opcode ISZERO;Opcode ISZERO;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFF00000000000000000000000000000000000000000000000000000000 DUP3 AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH ffffffff00000000000000000000000000000000000000000000000000000000 AND SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_349_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0xffffffff00000000000000000000000000000000000000000000000000000000%positive);Opcode AND;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 32 (posToWord WLen 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000%positive);DUP 3;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP3 AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_350_0"%string (equiv_checker [PUSH 20 (posToWord WLen 0xffffffffffffffffffffffffffffffffffffffff%positive);Opcode AND;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 20 (posToWord WLen 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%positive);DUP 3;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH 0 DUP2 SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_351_0"%string (equiv_checker [DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 2;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: DUP3 DUP2 DUP4
 O: DUP3 DUP2 DUP4
*)
Compute pair "ERC721A_run_code_of_0_block_352_0"%string (equiv_checker [DUP 3;DUP 2;DUP 4] [DUP 3;DUP 2;DUP 4] 3 optimize_id).

(*
 I: PUSH 0 DUP4 DUP4 ADD
 O: PUSH 0 DUP3 DUP5 ADD
*)
Compute pair "ERC721A_run_code_of_0_block_352_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 3;DUP 5;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 4;Opcode ADD] 3 optimize_id).

(*
 I: POP POP POP
 O: POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_352_2"%string (equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id).

(*
 I: PUSH 0
 O: PUSH 0
*)
Compute pair "ERC721A_run_code_of_0_block_353_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: DUP4 DUP2 LT ISZERO PUSH [tag] 377
 O: DUP4 DUP2 LT ISZERO PUSH [tag] 377
*)
Compute pair "ERC721A_run_code_of_0_block_354_0"%string (equiv_checker [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x179%positive)] [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x179%positive)] 4 optimize_id).

(*
 I: DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD
 O: DUP2 DUP2 ADD MLOAD DUP4 DUP3 ADD
*)
Compute pair "ERC721A_run_code_of_0_block_355_0"%string (equiv_checker [DUP 2;DUP 2;Opcode ADD;Opcode MLOAD;DUP 4;DUP 3;Opcode ADD] [DUP 1;DUP 3;Opcode ADD;Opcode MLOAD;DUP 2;DUP 5;Opcode ADD] 3 optimize_id).

(*
 I: PUSH 20 DUP2 ADD SWAP1 POP PUSH [tag] 375
 O: PUSH 20 ADD PUSH [tag] 375
*)
Compute pair "ERC721A_run_code_of_0_block_355_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x20%positive);Opcode ADD;PUSH 2 (posToWord WLen 0x177%positive)] [PUSH 1 (posToWord WLen 0x20%positive);DUP 2;Opcode ADD;DUP 1;POP;PUSH 2 (posToWord WLen 0x177%positive)] 1 optimize_id).

(*
 I: DUP4 DUP2 GT ISZERO PUSH [tag] 378
 O: DUP4 DUP2 GT ISZERO PUSH [tag] 378
*)
Compute pair "ERC721A_run_code_of_0_block_356_0"%string (equiv_checker [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x17a%positive)] [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (posToWord WLen 0x17a%positive)] 4 optimize_id).

(*
 I: PUSH 0 DUP5 DUP5 ADD
 O: PUSH 0 DUP4 DUP6 ADD
*)
Compute pair "ERC721A_run_code_of_0_block_357_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 4;DUP 6;Opcode ADD] [PUSH 1 (posToWord WLen 0x0%positive);DUP 5;DUP 5;Opcode ADD] 4 optimize_id).

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_358_0"%string (equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 2 DUP3 DIV SWAP1 POP PUSH 1 DUP3 AND DUP1 PUSH [tag] 380
 O: PUSH 2 DUP2 DIV DUP2 PUSH 1 AND DUP1 PUSH [tag] 380
*)
Compute pair "ERC721A_run_code_of_0_block_359_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x2%positive);DUP 2;Opcode DIV;DUP 2;PUSH 1 (posToWord WLen 0x1%positive);Opcode AND;DUP 1;PUSH 2 (posToWord WLen 0x17c%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x2%positive);DUP 3;Opcode DIV;DUP 1;POP;PUSH 1 (posToWord WLen 0x1%positive);DUP 3;Opcode AND;DUP 1;PUSH 2 (posToWord WLen 0x17c%positive)] 1 optimize_id).

(*
 I: PUSH 7F DUP3 AND SWAP2 POP
 O: SWAP1 PUSH 7f AND SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_360_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x7f%positive);Opcode AND;DUP 1] [PUSH 1 (posToWord WLen 0x7F%positive);DUP 3;Opcode AND;DUP 2;POP] 2 optimize_id).

(*
 I: PUSH 20 DUP3 LT DUP2 EQ ISZERO PUSH [tag] 381
 O: DUP1 PUSH 20 DUP4 LT EQ ISZERO PUSH [tag] 381
*)
Compute pair "ERC721A_run_code_of_0_block_361_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x20%positive);DUP 4;Opcode LT;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x17d%positive)] [PUSH 1 (posToWord WLen 0x20%positive);DUP 3;Opcode LT;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 2 (posToWord WLen 0x17d%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 382 PUSH [tag] 383
 O: PUSH [tag] 382 PUSH [tag] 383
*)
Compute pair "ERC721A_run_code_of_0_block_362_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x17e%positive);PUSH 2 (posToWord WLen 0x17f%positive)] [PUSH 2 (posToWord WLen 0x17e%positive);PUSH 2 (posToWord WLen 0x17f%positive)] 0 optimize_id).

(*
 I: POP SWAP2 SWAP1 POP
 O: POP SWAP2 SWAP1 POP
*)
Compute pair "ERC721A_run_code_of_0_block_364_0"%string (equiv_checker [POP;DUP 2;DUP 1;POP] [POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH [tag] 385 DUP3 PUSH [tag] 314
 O: PUSH [tag] 385 DUP3 PUSH [tag] 314
*)
Compute pair "ERC721A_run_code_of_0_block_365_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x181%positive);DUP 3;PUSH 2 (posToWord WLen 0x13a%positive)] [PUSH 2 (posToWord WLen 0x181%positive);DUP 3;PUSH 2 (posToWord WLen 0x13a%positive)] 2 optimize_id).

(*
 I: DUP2 ADD DUP2 DUP2 LT PUSH FFFFFFFFFFFFFFFF DUP3 GT OR ISZERO PUSH [tag] 386
 O: DUP2 ADD PUSH ffffffffffffffff DUP2 GT DUP3 DUP3 LT OR ISZERO PUSH [tag] 386
*)
Compute pair "ERC721A_run_code_of_0_block_366_0"%string (equiv_checker [DUP 2;Opcode ADD;PUSH 8 (posToWord WLen 0xffffffffffffffff%positive);DUP 2;Opcode GT;DUP 3;DUP 3;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 2 (posToWord WLen 0x182%positive)] [DUP 2;Opcode ADD;DUP 2;DUP 2;Opcode LT;PUSH 8 (posToWord WLen 0xFFFFFFFFFFFFFFFF%positive);DUP 3;Opcode GT;Opcode OR;Opcode ISZERO;PUSH 2 (posToWord WLen 0x182%positive)] 2 optimize_id).

(*
 I: PUSH [tag] 387 PUSH [tag] 358
 O: PUSH [tag] 387 PUSH [tag] 358
*)
Compute pair "ERC721A_run_code_of_0_block_367_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x183%positive);PUSH 2 (posToWord WLen 0x166%positive)] [PUSH 2 (posToWord WLen 0x183%positive);PUSH 2 (posToWord WLen 0x166%positive)] 0 optimize_id).

(*
 I: DUP1 PUSH 40
 O: DUP1 PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_369_0"%string (equiv_checker [DUP 1;PUSH 1 (posToWord WLen 0x40%positive)] [DUP 1;PUSH 1 (posToWord WLen 0x40%positive)] 1 optimize_id).

(*
 I: POP POP POP
 O: POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_369_1"%string (equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id).

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Compute pair "ERC721A_run_code_of_0_block_370_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x4e487b7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 32 (posToWord WLen 0x4E487B7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 22 PUSH 4
 O: PUSH 22 PUSH 4
*)
Compute pair "ERC721A_run_code_of_0_block_370_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x22%positive);PUSH 1 (posToWord WLen 0x4%positive)] [PUSH 1 (posToWord WLen 0x22%positive);PUSH 1 (posToWord WLen 0x4%positive)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "ERC721A_run_code_of_0_block_370_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Compute pair "ERC721A_run_code_of_0_block_371_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x4e487b7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 32 (posToWord WLen 0x4E487B7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 41 PUSH 4
 O: PUSH 41 PUSH 4
*)
Compute pair "ERC721A_run_code_of_0_block_371_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x41%positive);PUSH 1 (posToWord WLen 0x4%positive)] [PUSH 1 (posToWord WLen 0x41%positive);PUSH 1 (posToWord WLen 0x4%positive)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "ERC721A_run_code_of_0_block_371_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_372_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_373_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_374_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_375_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 PUSH 1F NOT PUSH 1F DUP4 ADD AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 1f ADD PUSH 1f NOT AND SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_376_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x1f%positive);Opcode ADD;PUSH 1 (posToWord WLen 0x1f%positive);Opcode NOT;Opcode AND;DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x1F%positive);Opcode NOT;PUSH 1 (posToWord WLen 0x1F%positive);DUP 4;Opcode ADD;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH [tag] 396 DUP2 PUSH [tag] 300
 O: PUSH [tag] 396 DUP2 PUSH [tag] 300
*)
Compute pair "ERC721A_run_code_of_0_block_377_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x18c%positive);DUP 2;PUSH 2 (posToWord WLen 0x12c%positive)] [PUSH 2 (posToWord WLen 0x18c%positive);DUP 2;PUSH 2 (posToWord WLen 0x12c%positive)] 1 optimize_id).

(*
 I: DUP2 EQ PUSH [tag] 397
 O: DUP2 EQ PUSH [tag] 397
*)
Compute pair "ERC721A_run_code_of_0_block_378_0"%string (equiv_checker [DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x18d%positive)] [DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x18d%positive)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_379_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "ERC721A_run_code_of_0_block_380_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH [tag] 399 DUP2 PUSH [tag] 304
 O: PUSH [tag] 399 DUP2 PUSH [tag] 304
*)
Compute pair "ERC721A_run_code_of_0_block_381_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x18f%positive);DUP 2;PUSH 2 (posToWord WLen 0x130%positive)] [PUSH 2 (posToWord WLen 0x18f%positive);DUP 2;PUSH 2 (posToWord WLen 0x130%positive)] 1 optimize_id).

(*
 I: DUP2 EQ PUSH [tag] 400
 O: DUP2 EQ PUSH [tag] 400
*)
Compute pair "ERC721A_run_code_of_0_block_382_0"%string (equiv_checker [DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x190%positive)] [DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x190%positive)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_383_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "ERC721A_run_code_of_0_block_384_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH [tag] 402 DUP2 PUSH [tag] 369
 O: PUSH [tag] 402 DUP2 PUSH [tag] 369
*)
Compute pair "ERC721A_run_code_of_0_block_385_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x192%positive);DUP 2;PUSH 2 (posToWord WLen 0x171%positive)] [PUSH 2 (posToWord WLen 0x192%positive);DUP 2;PUSH 2 (posToWord WLen 0x171%positive)] 1 optimize_id).

(*
 I: DUP2 EQ PUSH [tag] 403
 O: DUP2 EQ PUSH [tag] 403
*)
Compute pair "ERC721A_run_code_of_0_block_386_0"%string (equiv_checker [DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x193%positive)] [DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x193%positive)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_387_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "ERC721A_run_code_of_0_block_388_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH [tag] 405 DUP2 PUSH [tag] 332
 O: PUSH [tag] 405 DUP2 PUSH [tag] 332
*)
Compute pair "ERC721A_run_code_of_0_block_389_0"%string (equiv_checker [PUSH 2 (posToWord WLen 0x195%positive);DUP 2;PUSH 2 (posToWord WLen 0x14c%positive)] [PUSH 2 (posToWord WLen 0x195%positive);DUP 2;PUSH 2 (posToWord WLen 0x14c%positive)] 1 optimize_id).

(*
 I: DUP2 EQ PUSH [tag] 406
 O: DUP2 EQ PUSH [tag] 406
*)
Compute pair "ERC721A_run_code_of_0_block_390_0"%string (equiv_checker [DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x196%positive)] [DUP 2;Opcode EQ;PUSH 2 (posToWord WLen 0x196%positive)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_391_0"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "ERC721A_run_code_of_0_block_392_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH #[$] 0000000000000000000000000000000000000000000000000000000000000000 PUSH [$] 0000000000000000000000000000000000000000000000000000000000000000 PUSH B DUP3 DUP3 DUP3
 O: PUSH #[$] 0 PUSH [$] 0 PUSH b DUP3 DUP3 DUP3
  ERROR OCCURRED

'PUSH #[$]' is not in list
*)

(*
 I: DUP1 MLOAD PUSH 0 BYTE PUSH 73 EQ PUSH [tag] 1
 O: DUP1 MLOAD PUSH 0 BYTE PUSH 73 EQ PUSH [tag] 1
*)
Compute pair "Strings_initial_block_0_1"%string (equiv_checker [DUP 1;Opcode MLOAD;PUSH 1 (posToWord WLen 0x0%positive);Opcode BYTE;PUSH 1 (posToWord WLen 0x73%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x1%positive)] [DUP 1;Opcode MLOAD;PUSH 1 (posToWord WLen 0x0%positive);Opcode BYTE;PUSH 1 (posToWord WLen 0x73%positive);Opcode EQ;PUSH 1 (posToWord WLen 0x1%positive)] 1 optimize_id).

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Compute pair "Strings_initial_block_1_0"%string (equiv_checker [PUSH 32 (posToWord WLen 0x4e487b7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 32 (posToWord WLen 0x4E487B7100000000000000000000000000000000000000000000000000000000%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 0 PUSH 4
 O: PUSH 0 PUSH 4
*)
Compute pair "Strings_initial_block_1_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x4%positive)] [PUSH 1 (posToWord WLen 0x0%positive);PUSH 1 (posToWord WLen 0x4%positive)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "Strings_initial_block_1_2"%string (equiv_checker [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] [PUSH 1 (posToWord WLen 0x24%positive);PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: ADDRESS PUSH 0
 O: ADDRESS PUSH 0
*)
Compute pair "Strings_initial_block_2_0"%string (equiv_checker [Opcode ADDRESS;PUSH 1 (posToWord WLen 0x0%positive)] [Opcode ADDRESS;PUSH 1 (posToWord WLen 0x0%positive)] 0 optimize_id).

(*
 I: PUSH 73 DUP2
 O: PUSH 73 DUP2
*)
Compute pair "Strings_initial_block_2_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x73%positive);DUP 2] [PUSH 1 (posToWord WLen 0x73%positive);DUP 2] 1 optimize_id).

(*
 I: DUP3 DUP2
 O: DUP3 DUP2
*)
Compute pair "Strings_initial_block_2_2"%string (equiv_checker [DUP 3;DUP 2] [DUP 3;DUP 2] 3 optimize_id).

(*
 I: PUSHDEPLOYADDRESS ADDRESS EQ PUSH 80 PUSH 40
 O: ADDRESS PUSHDEPLOYADDRESS EQ PUSH 80 PUSH 40
  ERROR OCCURRED

'PUSHDEPLOYADDRESS' is not in list
*)

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "Strings_run_code_of_0_block_0_1"%string (equiv_checker [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] [PUSH 1 (posToWord WLen 0x0%positive);DUP 1] 0 optimize_id).


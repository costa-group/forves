(*
 I: PUSH C0 PUSH 40
 O: PUSH c0 PUSH 40
*)
Compute pair "BottleCastle_initial_block_0_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xc0%N);PUSH 1 (NToWord WLen 0x40%N)] [PUSH 1 (NToWord WLen 0xC0%N);PUSH 1 (NToWord WLen 0x40%N)] 0 optimize_id).

(*
 I: PUSH 5 PUSH 80 DUP2 SWAP1
 O: PUSH 5 DUP1 PUSH 80
*)
Compute pair "BottleCastle_initial_block_0_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x5%N);DUP 1;PUSH 1 (NToWord WLen 0x80%N)] [PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x80%N);DUP 2;DUP 1] 0 optimize_id).

(*
 I: PUSH 173539B7B7 PUSH D9 SHL PUSH A0 SWAP1 DUP2
 O: PUSH a0 PUSH 173539b7b7 PUSH d9 SHL DUP2
*)
Compute pair "BottleCastle_initial_block_0_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0xa0%N);PUSH 5 (NToWord WLen 0x173539b7b7%N);PUSH 1 (NToWord WLen 0xd9%N);Opcode SHL;DUP 2] [PUSH 5 (NToWord WLen 0x173539B7B7%N);PUSH 1 (NToWord WLen 0xD9%N);Opcode SHL;PUSH 1 (NToWord WLen 0xA0%N);DUP 1;DUP 2] 0 optimize_id).

(*
 I: PUSH [tag] 1 SWAP2 PUSH B SWAP2 SWAP1 PUSH [tag] 2
 O: PUSH b SWAP1 PUSH [tag] 1 SWAP3 PUSH [tag] 2
*)
Compute pair "BottleCastle_initial_block_0_3"%string (equiv_checker [PUSH 1 (NToWord WLen 0xb%N);DUP 1;PUSH 1 (NToWord WLen 0x1%N);DUP 3;PUSH 1 (NToWord WLen 0x2%N)] [PUSH 1 (NToWord WLen 0x1%N);DUP 2;PUSH 1 (NToWord WLen 0xB%N);DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x2%N)] 2 optimize_id).

(*
 I: POP PUSH 38D7EA4C68000 PUSH D
 O: POP PUSH 38d7ea4c68000 PUSH d
*)
Compute pair "BottleCastle_initial_block_1_0"%string (equiv_checker [POP;PUSH 7 (NToWord WLen 0x38d7ea4c68000%N);PUSH 1 (NToWord WLen 0xd%N)] [POP;PUSH 7 (NToWord WLen 0x38D7EA4C68000%N);PUSH 1 (NToWord WLen 0xD%N)] 1 optimize_id).

(*
 I: PUSH 3E7 PUSH E
 O: PUSH 3e7 PUSH e
*)
Compute pair "BottleCastle_initial_block_1_1"%string (equiv_checker [PUSH 2 (NToWord WLen 0x3e7%N);PUSH 1 (NToWord WLen 0xe%N)] [PUSH 2 (NToWord WLen 0x3E7%N);PUSH 1 (NToWord WLen 0xE%N)] 0 optimize_id).

(*
 I: PUSH A PUSH F
 O: PUSH a PUSH f
*)
Compute pair "BottleCastle_initial_block_1_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0xa%N);PUSH 1 (NToWord WLen 0xf%N)] [PUSH 1 (NToWord WLen 0xA%N);PUSH 1 (NToWord WLen 0xF%N)] 0 optimize_id).

(*
 I: PUSH 10 DUP1 SLOAD PUSH FFFF NOT AND SWAP1
 O: PUSH 10 SLOAD PUSH ffff NOT AND PUSH 10
*)
Compute pair "BottleCastle_initial_block_1_3"%string (equiv_checker [PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;PUSH 2 (NToWord WLen 0xffff%N);Opcode NOT;Opcode AND;PUSH 1 (NToWord WLen 0x10%N)] [PUSH 1 (NToWord WLen 0x10%N);DUP 1;Opcode SLOAD;PUSH 2 (NToWord WLen 0xFFFF%N);Opcode NOT;Opcode AND;DUP 1] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 3
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 3
*)
Compute pair "BottleCastle_initial_block_1_4"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x3%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x3%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_initial_block_2_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH 40 MLOAD PUSHSIZE CODESIZE SUB DUP1 PUSHSIZE DUP4
 O: POP PUSH 40 MLOAD PUSHSIZE CODESIZE SUB DUP1 PUSHSIZE DUP4
  ERROR OCCURRED

'PUSHSIZE' is not in list
*)

(*
 I: DUP2 ADD PUSH 40 DUP2 SWAP1
 O: DUP2 ADD DUP1 PUSH 40
*)
Compute pair "BottleCastle_initial_block_3_1"%string (equiv_checker [DUP 2;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x40%N)] [DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);DUP 2;DUP 1] 2 optimize_id).

(*
 I: PUSH [tag] 4 SWAP2 PUSH [tag] 5
 O: PUSH [tag] 4 SWAP2 PUSH [tag] 5
*)
Compute pair "BottleCastle_initial_block_3_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x4%N);DUP 2;PUSH 1 (NToWord WLen 0x5%N)] [PUSH 1 (NToWord WLen 0x4%N);DUP 2;PUSH 1 (NToWord WLen 0x5%N)] 2 optimize_id).

(*
 I: PUSH 40 DUP1 MLOAD DUP1 DUP3 ADD DUP3
 O: PUSH 40 DUP1 MLOAD DUP2 DUP2 ADD DUP3
*)
Compute pair "BottleCastle_initial_block_4_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode MLOAD;DUP 2;DUP 2;Opcode ADD;DUP 3] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode MLOAD;DUP 1;DUP 3;Opcode ADD;DUP 3] 0 optimize_id).

(*
 I: PUSH D DUP2
 O: PUSH d DUP2
*)
Compute pair "BottleCastle_initial_block_4_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0xd%N);DUP 2] [PUSH 1 (NToWord WLen 0xD%N);DUP 2] 1 optimize_id).

(*
 I: PUSH 426F74746C6520436173746C65 PUSH 98 SHL PUSH 20 DUP1 DUP4 ADD SWAP2 DUP3
 O: PUSH 426f74746c6520436173746c65 PUSH 98 SHL PUSH 20 DUP3 DUP2 ADD SWAP2 DUP3
*)
Compute pair "BottleCastle_initial_block_4_2"%string (equiv_checker [PUSH 13 (NToWord WLen 0x426f74746c6520436173746c65%N);PUSH 1 (NToWord WLen 0x98%N);Opcode SHL;PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 2;Opcode ADD;DUP 2;DUP 3] [PUSH 13 (NToWord WLen 0x426F74746C6520436173746C65%N);PUSH 1 (NToWord WLen 0x98%N);Opcode SHL;PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 4;Opcode ADD;DUP 2;DUP 3] 1 optimize_id).

(*
 I: DUP4 MLOAD DUP1 DUP6 ADD SWAP1 SWAP5
 O: DUP4 MLOAD SWAP4 DUP5 DUP2 ADD SWAP1
*)
Compute pair "BottleCastle_initial_block_4_3"%string (equiv_checker [DUP 4;Opcode MLOAD;DUP 4;DUP 5;DUP 2;Opcode ADD;DUP 1] [DUP 4;Opcode MLOAD;DUP 1;DUP 6;Opcode ADD;DUP 1;DUP 5] 4 optimize_id).

(*
 I: PUSH 6 DUP5
 O: PUSH 6 DUP5
*)
Compute pair "BottleCastle_initial_block_4_4"%string (equiv_checker [PUSH 1 (NToWord WLen 0x6%N);DUP 5] [PUSH 1 (NToWord WLen 0x6%N);DUP 5] 4 optimize_id).

(*
 I: PUSH 426F74746C65 PUSH D0 SHL SWAP1 DUP5 ADD
 O: DUP4 ADD PUSH 426f74746c65 PUSH d0 SHL SWAP1
*)
Compute pair "BottleCastle_initial_block_4_5"%string (equiv_checker [DUP 4;Opcode ADD;PUSH 6 (NToWord WLen 0x426f74746c65%N);PUSH 1 (NToWord WLen 0xd0%N);Opcode SHL;DUP 1] [PUSH 6 (NToWord WLen 0x426F74746C65%N);PUSH 1 (NToWord WLen 0xD0%N);Opcode SHL;DUP 1;DUP 5;Opcode ADD] 4 optimize_id).

(*
 I: DUP2 MLOAD SWAP2 SWAP3 SWAP2 PUSH [tag] 11 SWAP2 PUSH 2 SWAP2 PUSH [tag] 2
 O: PUSH 2 PUSH [tag] 11 SWAP2 DUP4 SWAP5 SWAP4 MLOAD PUSH [tag] 2
*)
Compute pair "BottleCastle_initial_block_4_6"%string (equiv_checker [PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0xb%N);DUP 2;DUP 4;DUP 5;DUP 4;Opcode MLOAD;PUSH 1 (NToWord WLen 0x2%N)] [DUP 2;Opcode MLOAD;DUP 2;DUP 3;DUP 2;PUSH 1 (NToWord WLen 0xb%N);DUP 2;PUSH 1 (NToWord WLen 0x2%N);DUP 2;PUSH 1 (NToWord WLen 0x2%N)] 3 optimize_id).

(*
 I: POP DUP1 MLOAD PUSH [tag] 12 SWAP1 PUSH 3 SWAP1 PUSH 20 DUP5 ADD SWAP1 PUSH [tag] 2
 O: POP PUSH [tag] 12 PUSH 3 DUP3 PUSH 20 ADD DUP4 MLOAD PUSH [tag] 2
*)
Compute pair "BottleCastle_initial_block_5_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0xc%N);PUSH 1 (NToWord WLen 0x3%N);DUP 3;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 4;Opcode MLOAD;PUSH 1 (NToWord WLen 0x2%N)] [POP;DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0xc%N);DUP 1;PUSH 1 (NToWord WLen 0x3%N);DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x2%N)] 2 optimize_id).

(*
 I: POP POP PUSH 1 PUSH 0
 O: POP POP PUSH 1 PUSH 0
*)
Compute pair "BottleCastle_initial_block_6_0"%string (equiv_checker [POP;POP;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x0%N)] [POP;POP;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x0%N)] 2 optimize_id).

(*
 I: POP PUSH [tag] 16 CALLER PUSH [tag] 19
 O: POP PUSH [tag] 16 CALLER PUSH [tag] 19
*)
Compute pair "BottleCastle_initial_block_6_1"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x10%N);Opcode CALLER;PUSH 1 (NToWord WLen 0x13%N)] [POP;PUSH 1 (NToWord WLen 0x10%N);Opcode CALLER;PUSH 1 (NToWord WLen 0x13%N)] 1 optimize_id).

(*
 I: PUSH 1 PUSH 9
 O: PUSH 1 PUSH 9
*)
Compute pair "BottleCastle_initial_block_7_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x9%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x9%N)] 0 optimize_id).

(*
 I: PUSH [tag] 22 DUP3 PUSH [tag] 23
 O: PUSH [tag] 22 DUP3 PUSH [tag] 23
*)
Compute pair "BottleCastle_initial_block_7_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x16%N);DUP 3;PUSH 1 (NToWord WLen 0x17%N)] [PUSH 1 (NToWord WLen 0x16%N);DUP 3;PUSH 1 (NToWord WLen 0x17%N)] 2 optimize_id).

(*
 I: PUSH [tag] 24 DUP2 PUSH [tag] 25
 O: PUSH [tag] 24 DUP2 PUSH [tag] 25
*)
Compute pair "BottleCastle_initial_block_8_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x18%N);DUP 2;PUSH 1 (NToWord WLen 0x19%N)] [PUSH 1 (NToWord WLen 0x18%N);DUP 2;PUSH 1 (NToWord WLen 0x19%N)] 1 optimize_id).

(*
 I: POP POP PUSH [tag] 58
 O: POP POP PUSH [tag] 58
*)
Compute pair "BottleCastle_initial_block_9_0"%string (equiv_checker [POP;POP;PUSH 1 (NToWord WLen 0x3a%N)] [POP;POP;PUSH 1 (NToWord WLen 0x3a%N)] 2 optimize_id).

(*
 I: PUSH 8 DUP1 SLOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP4 DUP2 AND PUSH 1 PUSH 1 PUSH A0 SHL SUB NOT DUP4 AND DUP2 OR SWAP1 SWAP4
 O: PUSH 8 PUSH a0 PUSH 1 DUP1 DUP4 SLOAD SWAP3 SHL SUB DUP1 NOT DUP2 DUP6 AND SWAP4 SWAP1 DUP4 AND DUP5 OR SWAP1
*)
Compute pair "BottleCastle_initial_block_10_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x8%N);PUSH 1 (NToWord WLen 0xa0%N);PUSH 1 (NToWord WLen 0x1%N);DUP 1;DUP 4;Opcode SLOAD;DUP 3;Opcode SHL;Opcode SUB;DUP 1;Opcode NOT;DUP 2;DUP 6;Opcode AND;DUP 4;DUP 1;DUP 4;Opcode AND;DUP 5;Opcode OR;DUP 1] [PUSH 1 (NToWord WLen 0x8%N);DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 4;DUP 2;Opcode AND;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 4;Opcode AND;DUP 2;Opcode OR;DUP 1;DUP 4] 1 optimize_id).

(*
 I: PUSH 40 MLOAD SWAP2 AND SWAP2 SWAP1 DUP3 SWAP1 PUSH 8BE0079C531659141344CD1FD0A4F28419497F9722A3DAAFE3B4186F6B6457E0 SWAP1 PUSH 0 SWAP1
 O: AND SWAP1 DUP2 PUSH 8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0 PUSH 0 PUSH 40 MLOAD
*)
Compute pair "BottleCastle_initial_block_10_1"%string (equiv_checker [Opcode AND;DUP 1;DUP 2;PUSH 32 (NToWord WLen 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0%N);PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 2;Opcode AND;DUP 2;DUP 1;DUP 3;DUP 1;PUSH 32 (NToWord WLen 0x8BE0079C531659141344CD1FD0A4F28419497F9722A3DAAFE3B4186F6B6457E0%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 1] 3 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_initial_block_10_2"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH [tag] 31 PUSH [tag] 32
 O: PUSH [tag] 31 PUSH [tag] 32
*)
Compute pair "BottleCastle_initial_block_11_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x1f%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: DUP1 MLOAD PUSH [tag] 34 SWAP1 PUSH A SWAP1 PUSH 20 DUP5 ADD SWAP1 PUSH [tag] 2
 O: PUSH [tag] 34 PUSH a PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 2
*)
Compute pair "BottleCastle_initial_block_12_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x22%N);PUSH 1 (NToWord WLen 0xa%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 1 (NToWord WLen 0x2%N)] [DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x22%N);DUP 1;PUSH 1 (NToWord WLen 0xA%N);DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x2%N)] 1 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_initial_block_13_0"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH [tag] 36 PUSH [tag] 32
 O: PUSH [tag] 36 PUSH [tag] 32
*)
Compute pair "BottleCastle_initial_block_14_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: DUP1 MLOAD PUSH [tag] 34 SWAP1 PUSH C SWAP1 PUSH 20 DUP5 ADD SWAP1 PUSH [tag] 2
 O: PUSH [tag] 34 PUSH c PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 2
*)
Compute pair "BottleCastle_initial_block_15_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x22%N);PUSH 1 (NToWord WLen 0xc%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 1 (NToWord WLen 0x2%N)] [DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x22%N);DUP 1;PUSH 1 (NToWord WLen 0xC%N);DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x2%N)] 1 optimize_id).

(*
 I: PUSH 8 SLOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB AND CALLER EQ PUSH [tag] 43
 O: PUSH 1 DUP1 PUSH a0 SHL SUB PUSH 8 SLOAD AND CALLER EQ PUSH [tag] 43
*)
Compute pair "BottleCastle_initial_block_16_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;PUSH 1 (NToWord WLen 0x8%N);Opcode SLOAD;Opcode AND;Opcode CALLER;Opcode EQ;PUSH 1 (NToWord WLen 0x2b%N)] [PUSH 1 (NToWord WLen 0x8%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode CALLER;Opcode EQ;PUSH 1 (NToWord WLen 0x2b%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 461BCD PUSH E5 SHL DUP2
 O: PUSH 40 MLOAD PUSH 461bcd PUSH e5 SHL DUP2
*)
Compute pair "BottleCastle_initial_block_17_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461bcd%N);PUSH 1 (NToWord WLen 0xe5%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461BCD%N);PUSH 1 (NToWord WLen 0xE5%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 20 PUSH 4 DUP3 ADD DUP2 SWAP1
 O: PUSH 20 DUP1 DUP3 PUSH 4 ADD
*)
Compute pair "BottleCastle_initial_block_17_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 3;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x4%N);DUP 3;Opcode ADD;DUP 2;DUP 1] 1 optimize_id).

(*
 I: PUSH 24 DUP3 ADD
 O: DUP2 PUSH 24 ADD
*)
Compute pair "BottleCastle_initial_block_17_2"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x24%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x24%N);DUP 3;Opcode ADD] 2 optimize_id).

(*
 I: PUSH 4F776E61626C653A2063616C6C6572206973206E6F7420746865206F776E6572 PUSH 44 DUP3 ADD
 O: PUSH 4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572 DUP2 PUSH 44 ADD
*)
Compute pair "BottleCastle_initial_block_17_3"%string (equiv_checker [PUSH 32 (NToWord WLen 0x4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572%N);DUP 2;PUSH 1 (NToWord WLen 0x44%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x4F776E61626C653A2063616C6C6572206973206E6F7420746865206F776E6572%N);PUSH 1 (NToWord WLen 0x44%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 64 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 64 ADD SUB SWAP1
*)
Compute pair "BottleCastle_initial_block_17_4"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x64%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x64%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: DUP3 DUP1 SLOAD PUSH [tag] 47 SWAP1 PUSH [tag] 48
 O: DUP3 PUSH [tag] 47 DUP5 SLOAD PUSH [tag] 48
*)
Compute pair "BottleCastle_initial_block_19_0"%string (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0x2f%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0x30%N)] [DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x2f%N);DUP 1;PUSH 1 (NToWord WLen 0x30%N)] 3 optimize_id).

(*
 I: SWAP1 PUSH 0
 O: SWAP1 PUSH 0
*)
Compute pair "BottleCastle_initial_block_20_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x0%N)] [DUP 1;PUSH 1 (NToWord WLen 0x0%N)] 2 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1 PUSH 1F ADD PUSH 20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 50
 O: PUSH 20 DUP1 PUSH 0 KECCAK256 SWAP2 PUSH 1f ADD DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 50
*)
Compute pair "BottleCastle_initial_block_20_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 2;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x32%N)] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x32%N)] 3 optimize_id).

(*
 I: PUSH 0 DUP6
 O: PUSH 0 DUP6
*)
Compute pair "BottleCastle_initial_block_21_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 6] [PUSH 1 (NToWord WLen 0x0%N);DUP 6] 5 optimize_id).

(*
 I: PUSH [tag] 53
 O: PUSH [tag] 53
*)
Compute pair "BottleCastle_initial_block_21_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x35%N)] [PUSH 1 (NToWord WLen 0x35%N)] 0 optimize_id).

(*
 I: DUP3 PUSH 1F LT PUSH [tag] 51
 O: DUP3 PUSH 1f LT PUSH [tag] 51
*)
Compute pair "BottleCastle_initial_block_22_0"%string (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0x1f%N);Opcode LT;PUSH 1 (NToWord WLen 0x33%N)] [DUP 3;PUSH 1 (NToWord WLen 0x1F%N);Opcode LT;PUSH 1 (NToWord WLen 0x33%N)] 3 optimize_id).

(*
 I: DUP1 MLOAD PUSH FF NOT AND DUP4 DUP1 ADD OR DUP6
 O: DUP3 DUP1 ADD PUSH ff NOT DUP3 MLOAD AND OR DUP6
*)
Compute pair "BottleCastle_initial_block_23_0"%string (equiv_checker [DUP 3;DUP 1;Opcode ADD;PUSH 1 (NToWord WLen 0xff%N);Opcode NOT;DUP 3;Opcode MLOAD;Opcode AND;Opcode OR;DUP 6] [DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0xFF%N);Opcode NOT;Opcode AND;DUP 4;DUP 1;Opcode ADD;Opcode OR;DUP 6] 5 optimize_id).

(*
 I: PUSH [tag] 53
 O: PUSH [tag] 53
*)
Compute pair "BottleCastle_initial_block_23_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x35%N)] [PUSH 1 (NToWord WLen 0x35%N)] 0 optimize_id).

(*
 I: DUP3 DUP1 ADD PUSH 1 ADD DUP6
 O: DUP3 DUP4 ADD PUSH 1 ADD DUP6
*)
Compute pair "BottleCastle_initial_block_24_0"%string (equiv_checker [DUP 3;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 6] [DUP 3;DUP 1;Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 6] 5 optimize_id).

(*
 I: DUP3 ISZERO PUSH [tag] 53
 O: DUP3 ISZERO PUSH [tag] 53
*)
Compute pair "BottleCastle_initial_block_24_1"%string (equiv_checker [DUP 3;Opcode ISZERO;PUSH 1 (NToWord WLen 0x35%N)] [DUP 3;Opcode ISZERO;PUSH 1 (NToWord WLen 0x35%N)] 3 optimize_id).

(*
 I: SWAP2 DUP3 ADD
 O: DUP1 SWAP3 ADD
*)
Compute pair "BottleCastle_initial_block_25_0"%string (equiv_checker [DUP 1;DUP 3;Opcode ADD] [DUP 2;DUP 3;Opcode ADD] 3 optimize_id).

(*
 I: DUP3 DUP2 GT ISZERO PUSH [tag] 53
 O: DUP3 DUP2 GT ISZERO PUSH [tag] 53
*)
Compute pair "BottleCastle_initial_block_26_0"%string (equiv_checker [DUP 3;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x35%N)] [DUP 3;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x35%N)] 3 optimize_id).

(*
 I: DUP3 MLOAD DUP3
 O: DUP3 MLOAD DUP3
*)
Compute pair "BottleCastle_initial_block_27_0"%string (equiv_checker [DUP 3;Opcode MLOAD;DUP 3] [DUP 3;Opcode MLOAD;DUP 3] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 SWAP1 PUSH 1 ADD SWAP1 PUSH [tag] 52
 O: SWAP2 PUSH 20 ADD SWAP2 SWAP1 PUSH 1 ADD SWAP1 PUSH [tag] 52
*)
Compute pair "BottleCastle_initial_block_27_1"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x34%N)] [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x34%N)] 3 optimize_id).

(*
 I: POP PUSH [tag] 54 SWAP3 SWAP2 POP PUSH [tag] 55
 O: POP PUSH [tag] 55 PUSH [tag] 54 SWAP4 SWAP3 POP
*)
Compute pair "BottleCastle_initial_block_28_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x37%N);PUSH 1 (NToWord WLen 0x36%N);DUP 4;DUP 3;POP] [POP;PUSH 1 (NToWord WLen 0x36%N);DUP 3;DUP 2;POP;PUSH 1 (NToWord WLen 0x37%N)] 4 optimize_id).

(*
 I: POP SWAP1
 O: POP SWAP1
*)
Compute pair "BottleCastle_initial_block_29_0"%string (equiv_checker [POP;DUP 1] [POP;DUP 1] 3 optimize_id).

(*
 I: DUP1 DUP3 GT ISZERO PUSH [tag] 54
 O: DUP1 DUP3 GT ISZERO PUSH [tag] 54
*)
Compute pair "BottleCastle_initial_block_31_0"%string (equiv_checker [DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x36%N)] [DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x36%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP2
 O: PUSH 0 DUP2
*)
Compute pair "BottleCastle_initial_block_32_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2] [PUSH 1 (NToWord WLen 0x0%N);DUP 2] 1 optimize_id).

(*
 I: PUSH 1 ADD PUSH [tag] 56
 O: PUSH 1 ADD PUSH [tag] 56
*)
Compute pair "BottleCastle_initial_block_32_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 1 (NToWord WLen 0x38%N)] [PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 1 (NToWord WLen 0x38%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 61
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 61
*)
Compute pair "BottleCastle_initial_block_33_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode SLT;PUSH 1 (NToWord WLen 0x3d%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;Opcode SLT;PUSH 1 (NToWord WLen 0x3d%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_initial_block_34_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP2 MLOAD PUSH 1 PUSH 1 PUSH 40 SHL SUB DUP1 DUP3 GT ISZERO PUSH [tag] 63
 O: DUP2 MLOAD PUSH 1 DUP1 PUSH 40 SHL SUB DUP1 DUP3 GT ISZERO PUSH [tag] 63
*)
Compute pair "BottleCastle_initial_block_35_0"%string (equiv_checker [DUP 2;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode SHL;Opcode SUB;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x3f%N)] [DUP 2;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x40%N);Opcode SHL;Opcode SUB;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x3f%N)] 2 optimize_id).

(*
 I: PUSH [tag] 63 PUSH [tag] 64
 O: PUSH [tag] 63 PUSH [tag] 64
*)
Compute pair "BottleCastle_initial_block_36_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x3f%N);PUSH 1 (NToWord WLen 0x40%N)] [PUSH 1 (NToWord WLen 0x3f%N);PUSH 1 (NToWord WLen 0x40%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 1F DUP4 ADD PUSH 1F NOT SWAP1 DUP2 AND PUSH 3F ADD AND DUP2 ADD SWAP1 DUP3 DUP3 GT DUP2 DUP4 LT OR ISZERO PUSH [tag] 66
 O: PUSH 40 MLOAD PUSH 1f NOT PUSH 3f DUP2 DUP6 PUSH 1f ADD AND ADD AND ADD PUSH 40 MLOAD DUP3 DUP3 GT DUP2 DUP4 LT OR ISZERO PUSH [tag] 66
*)
Compute pair "BottleCastle_initial_block_37_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x1f%N);Opcode NOT;PUSH 1 (NToWord WLen 0x3f%N);DUP 2;DUP 6;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode AND;Opcode ADD;Opcode AND;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 3;DUP 3;Opcode GT;DUP 2;DUP 4;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 1 (NToWord WLen 0x42%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;DUP 1;DUP 2;Opcode AND;PUSH 1 (NToWord WLen 0x3F%N);Opcode ADD;Opcode AND;DUP 2;Opcode ADD;DUP 1;DUP 3;DUP 3;Opcode GT;DUP 2;DUP 4;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 1 (NToWord WLen 0x42%N)] 2 optimize_id).

(*
 I: PUSH [tag] 66 PUSH [tag] 64
 O: PUSH [tag] 66 PUSH [tag] 64
*)
Compute pair "BottleCastle_initial_block_38_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x42%N);PUSH 1 (NToWord WLen 0x40%N)] [PUSH 1 (NToWord WLen 0x42%N);PUSH 1 (NToWord WLen 0x40%N)] 0 optimize_id).

(*
 I: DUP2 PUSH 40
 O: DUP2 PUSH 40
*)
Compute pair "BottleCastle_initial_block_39_0"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x40%N)] [DUP 2;PUSH 1 (NToWord WLen 0x40%N)] 2 optimize_id).

(*
 I: DUP4 DUP2
 O: DUP4 DUP2
*)
Compute pair "BottleCastle_initial_block_39_1"%string (equiv_checker [DUP 4;DUP 2] [DUP 4;DUP 2] 4 optimize_id).

(*
 I: PUSH 20 SWAP3 POP DUP7 DUP4 DUP6 DUP9 ADD ADD GT ISZERO PUSH [tag] 67
 O: DUP7 DUP7 DUP6 ADD PUSH 20 DUP1 SWAP6 POP ADD GT ISZERO PUSH [tag] 67
*)
Compute pair "BottleCastle_initial_block_39_2"%string (equiv_checker [DUP 7;DUP 7;DUP 6;Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 6;POP;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x43%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;POP;DUP 7;DUP 4;DUP 6;DUP 9;Opcode ADD;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x43%N)] 7 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_initial_block_40_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 SWAP2 POP
 O: PUSH 0 SWAP2 POP
*)
Compute pair "BottleCastle_initial_block_41_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;POP] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;POP] 2 optimize_id).

(*
 I: DUP4 DUP3 LT ISZERO PUSH [tag] 70
 O: DUP4 DUP3 LT ISZERO PUSH [tag] 70
*)
Compute pair "BottleCastle_initial_block_42_0"%string (equiv_checker [DUP 4;DUP 3;Opcode LT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x46%N)] [DUP 4;DUP 3;Opcode LT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x46%N)] 4 optimize_id).

(*
 I: DUP6 DUP3 ADD DUP4 ADD MLOAD DUP2 DUP4 ADD DUP5 ADD
 O: DUP3 DUP3 DUP8 ADD ADD MLOAD DUP4 DUP4 DUP4 ADD ADD
*)
Compute pair "BottleCastle_initial_block_43_0"%string (equiv_checker [DUP 3;DUP 3;DUP 8;Opcode ADD;Opcode ADD;Opcode MLOAD;DUP 4;DUP 4;DUP 4;Opcode ADD;Opcode ADD] [DUP 6;DUP 3;Opcode ADD;DUP 4;Opcode ADD;Opcode MLOAD;DUP 2;DUP 4;Opcode ADD;DUP 5;Opcode ADD] 6 optimize_id).

(*
 I: SWAP1 DUP3 ADD SWAP1 PUSH [tag] 68
 O: PUSH [tag] 68 SWAP2 DUP4 ADD SWAP2
*)
Compute pair "BottleCastle_initial_block_43_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x44%N);DUP 2;DUP 4;Opcode ADD;DUP 2] [DUP 1;DUP 3;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x44%N)] 3 optimize_id).

(*
 I: DUP4 DUP3 GT ISZERO PUSH [tag] 71
 O: DUP4 DUP3 GT ISZERO PUSH [tag] 71
*)
Compute pair "BottleCastle_initial_block_44_0"%string (equiv_checker [DUP 4;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x47%N)] [DUP 4;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x47%N)] 4 optimize_id).

(*
 I: PUSH 0 DUP4 DUP6 DUP4 ADD ADD
 O: PUSH 0 DUP5 DUP3 ADD DUP5 ADD
*)
Compute pair "BottleCastle_initial_block_45_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 5;DUP 3;Opcode ADD;DUP 5;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 6;DUP 4;Opcode ADD;Opcode ADD] 4 optimize_id).

(*
 I: SWAP7 SWAP6 POP POP POP POP POP POP
 O: SWAP7 SWAP6 POP POP POP POP POP POP
*)
Compute pair "BottleCastle_initial_block_46_0"%string (equiv_checker [DUP 7;DUP 6;POP;POP;POP;POP;POP;POP] [DUP 7;DUP 6;POP;POP;POP;POP;POP;POP] 8 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 73
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 73
*)
Compute pair "BottleCastle_initial_block_47_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x49%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x49%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_initial_block_48_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP3 MLOAD PUSH 1 PUSH 1 PUSH 40 SHL SUB DUP1 DUP3 GT ISZERO PUSH [tag] 74
 O: DUP3 MLOAD PUSH 1 DUP1 PUSH 40 SHL SUB DUP1 DUP3 GT ISZERO PUSH [tag] 74
*)
Compute pair "BottleCastle_initial_block_49_0"%string (equiv_checker [DUP 3;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode SHL;Opcode SUB;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4a%N)] [DUP 3;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x40%N);Opcode SHL;Opcode SUB;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4a%N)] 3 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_initial_block_50_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 75 DUP7 DUP4 DUP8 ADD PUSH [tag] 59
 O: PUSH [tag] 75 DUP7 DUP4 DUP8 ADD PUSH [tag] 59
*)
Compute pair "BottleCastle_initial_block_51_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x4b%N);DUP 7;DUP 4;DUP 8;Opcode ADD;PUSH 1 (NToWord WLen 0x3b%N)] [PUSH 1 (NToWord WLen 0x4b%N);DUP 7;DUP 4;DUP 8;Opcode ADD;PUSH 1 (NToWord WLen 0x3b%N)] 6 optimize_id).

(*
 I: SWAP4 POP PUSH 20 DUP6 ADD MLOAD SWAP2 POP DUP1 DUP3 GT ISZERO PUSH [tag] 76
 O: SWAP4 POP DUP1 PUSH 20 DUP7 ADD MLOAD DUP1 SWAP4 POP GT ISZERO PUSH [tag] 76
*)
Compute pair "BottleCastle_initial_block_52_0"%string (equiv_checker [DUP 4;POP;DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;Opcode MLOAD;DUP 1;DUP 4;POP;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4c%N)] [DUP 4;POP;PUSH 1 (NToWord WLen 0x20%N);DUP 6;Opcode ADD;Opcode MLOAD;DUP 2;POP;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4c%N)] 6 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_initial_block_53_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 77 DUP6 DUP3 DUP7 ADD PUSH [tag] 59
 O: POP PUSH [tag] 77 DUP6 DUP6 DUP4 ADD PUSH [tag] 59
*)
Compute pair "BottleCastle_initial_block_54_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x4d%N);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0x3b%N)] [POP;PUSH 1 (NToWord WLen 0x4d%N);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (NToWord WLen 0x3b%N)] 6 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute pair "BottleCastle_initial_block_55_0"%string (equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id).

(*
 I: PUSH 1 DUP2 DUP2 SHR SWAP1 DUP3 AND DUP1 PUSH [tag] 80
 O: DUP1 PUSH 1 SHR DUP2 PUSH 1 AND DUP1 PUSH [tag] 80
*)
Compute pair "BottleCastle_initial_block_56_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode SHR;DUP 2;PUSH 1 (NToWord WLen 0x1%N);Opcode AND;DUP 1;PUSH 1 (NToWord WLen 0x50%N)] [PUSH 1 (NToWord WLen 0x1%N);DUP 2;DUP 2;Opcode SHR;DUP 1;DUP 3;Opcode AND;DUP 1;PUSH 1 (NToWord WLen 0x50%N)] 1 optimize_id).

(*
 I: PUSH 7F DUP3 AND SWAP2 POP
 O: SWAP1 PUSH 7f AND SWAP1
*)
Compute pair "BottleCastle_initial_block_57_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x7f%N);Opcode AND;DUP 1] [PUSH 1 (NToWord WLen 0x7F%N);DUP 3;Opcode AND;DUP 2;POP] 2 optimize_id).

(*
 I: PUSH 20 DUP3 LT DUP2 EQ ISZERO PUSH [tag] 81
 O: DUP1 PUSH 20 DUP4 LT EQ ISZERO PUSH [tag] 81
*)
Compute pair "BottleCastle_initial_block_58_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode LT;Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0x51%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode LT;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0x51%N)] 2 optimize_id).

(*
 I: PUSH 4E487B71 PUSH E0 SHL PUSH 0
 O: PUSH 4e487b71 PUSH e0 SHL PUSH 0
*)
Compute pair "BottleCastle_initial_block_59_0"%string (equiv_checker [PUSH 4 (NToWord WLen 0x4e487b71%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] [PUSH 4 (NToWord WLen 0x4E487B71%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 22 PUSH 4
 O: PUSH 22 PUSH 4
*)
Compute pair "BottleCastle_initial_block_59_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x22%N);PUSH 1 (NToWord WLen 0x4%N)] [PUSH 1 (NToWord WLen 0x22%N);PUSH 1 (NToWord WLen 0x4%N)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "BottleCastle_initial_block_59_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: POP SWAP2 SWAP1 POP
 O: POP SWAP2 SWAP1 POP
*)
Compute pair "BottleCastle_initial_block_60_0"%string (equiv_checker [POP;DUP 2;DUP 1;POP] [POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 4E487B71 PUSH E0 SHL PUSH 0
 O: PUSH 4e487b71 PUSH e0 SHL PUSH 0
*)
Compute pair "BottleCastle_initial_block_61_0"%string (equiv_checker [PUSH 4 (NToWord WLen 0x4e487b71%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] [PUSH 4 (NToWord WLen 0x4E487B71%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 41 PUSH 4
 O: PUSH 41 PUSH 4
*)
Compute pair "BottleCastle_initial_block_61_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x41%N);PUSH 1 (NToWord WLen 0x4%N)] [PUSH 1 (NToWord WLen 0x41%N);PUSH 1 (NToWord WLen 0x4%N)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "BottleCastle_initial_block_61_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

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
Compute pair "BottleCastle_initial_block_62_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 80 PUSH 40
 O: PUSH 80 PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_0_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x80%N);PUSH 1 (NToWord WLen 0x40%N)] [PUSH 1 (NToWord WLen 0x80%N);PUSH 1 (NToWord WLen 0x40%N)] 0 optimize_id).

(*
 I: PUSH 4 CALLDATASIZE LT PUSH [tag] 1
 O: PUSH 4 CALLDATASIZE LT PUSH [tag] 1
*)
Compute pair "BottleCastle_run_code_of_0_block_0_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x4%N);Opcode CALLDATASIZE;Opcode LT;PUSH 1 (NToWord WLen 0x1%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode CALLDATASIZE;Opcode LT;PUSH 1 (NToWord WLen 0x1%N)] 0 optimize_id).

(*
 I: PUSH 0 CALLDATALOAD PUSH E0 SHR DUP1 PUSH 715018A6 GT PUSH [tag] 39
 O: PUSH 0 CALLDATALOAD PUSH e0 SHR DUP1 PUSH 715018a6 GT PUSH [tag] 39
*)
Compute pair "BottleCastle_run_code_of_0_block_1_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);Opcode CALLDATALOAD;PUSH 1 (NToWord WLen 0xe0%N);Opcode SHR;DUP 1;PUSH 4 (NToWord WLen 0x715018a6%N);Opcode GT;PUSH 1 (NToWord WLen 0x27%N)] [PUSH 1 (NToWord WLen 0x0%N);Opcode CALLDATALOAD;PUSH 1 (NToWord WLen 0xE0%N);Opcode SHR;DUP 1;PUSH 4 (NToWord WLen 0x715018A6%N);Opcode GT;PUSH 1 (NToWord WLen 0x27%N)] 0 optimize_id).

(*
 I: DUP1 PUSH BD7A1998 GT PUSH [tag] 40
 O: DUP1 PUSH bd7a1998 GT PUSH [tag] 40
*)
Compute pair "BottleCastle_run_code_of_0_block_2_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xbd7a1998%N);Opcode GT;PUSH 1 (NToWord WLen 0x28%N)] [DUP 1;PUSH 4 (NToWord WLen 0xBD7A1998%N);Opcode GT;PUSH 1 (NToWord WLen 0x28%N)] 1 optimize_id).

(*
 I: DUP1 PUSH DC33E681 GT PUSH [tag] 41
 O: DUP1 PUSH dc33e681 GT PUSH [tag] 41
*)
Compute pair "BottleCastle_run_code_of_0_block_3_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xdc33e681%N);Opcode GT;PUSH 1 (NToWord WLen 0x29%N)] [DUP 1;PUSH 4 (NToWord WLen 0xDC33E681%N);Opcode GT;PUSH 1 (NToWord WLen 0x29%N)] 1 optimize_id).

(*
 I: DUP1 PUSH DC33E681 EQ PUSH [tag] 34
 O: DUP1 PUSH dc33e681 EQ PUSH [tag] 34
*)
Compute pair "BottleCastle_run_code_of_0_block_4_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xdc33e681%N);Opcode EQ;PUSH 1 (NToWord WLen 0x22%N)] [DUP 1;PUSH 4 (NToWord WLen 0xDC33E681%N);Opcode EQ;PUSH 1 (NToWord WLen 0x22%N)] 1 optimize_id).

(*
 I: DUP1 PUSH E268E4D3 EQ PUSH [tag] 35
 O: DUP1 PUSH e268e4d3 EQ PUSH [tag] 35
*)
Compute pair "BottleCastle_run_code_of_0_block_5_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xe268e4d3%N);Opcode EQ;PUSH 1 (NToWord WLen 0x23%N)] [DUP 1;PUSH 4 (NToWord WLen 0xE268E4D3%N);Opcode EQ;PUSH 1 (NToWord WLen 0x23%N)] 1 optimize_id).

(*
 I: DUP1 PUSH E985E9C5 EQ PUSH [tag] 36
 O: DUP1 PUSH e985e9c5 EQ PUSH [tag] 36
*)
Compute pair "BottleCastle_run_code_of_0_block_6_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xe985e9c5%N);Opcode EQ;PUSH 1 (NToWord WLen 0x24%N)] [DUP 1;PUSH 4 (NToWord WLen 0xE985E9C5%N);Opcode EQ;PUSH 1 (NToWord WLen 0x24%N)] 1 optimize_id).

(*
 I: DUP1 PUSH F2C4CE1E EQ PUSH [tag] 37
 O: DUP1 PUSH f2c4ce1e EQ PUSH [tag] 37
*)
Compute pair "BottleCastle_run_code_of_0_block_7_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xf2c4ce1e%N);Opcode EQ;PUSH 1 (NToWord WLen 0x25%N)] [DUP 1;PUSH 4 (NToWord WLen 0xF2C4CE1E%N);Opcode EQ;PUSH 1 (NToWord WLen 0x25%N)] 1 optimize_id).

(*
 I: DUP1 PUSH F2FDE38B EQ PUSH [tag] 38
 O: DUP1 PUSH f2fde38b EQ PUSH [tag] 38
*)
Compute pair "BottleCastle_run_code_of_0_block_8_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xf2fde38b%N);Opcode EQ;PUSH 1 (NToWord WLen 0x26%N)] [DUP 1;PUSH 4 (NToWord WLen 0xF2FDE38B%N);Opcode EQ;PUSH 1 (NToWord WLen 0x26%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_9_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP1 PUSH BD7A1998 EQ PUSH [tag] 29
 O: DUP1 PUSH bd7a1998 EQ PUSH [tag] 29
*)
Compute pair "BottleCastle_run_code_of_0_block_10_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xbd7a1998%N);Opcode EQ;PUSH 1 (NToWord WLen 0x1d%N)] [DUP 1;PUSH 4 (NToWord WLen 0xBD7A1998%N);Opcode EQ;PUSH 1 (NToWord WLen 0x1d%N)] 1 optimize_id).

(*
 I: DUP1 PUSH C6682862 EQ PUSH [tag] 30
 O: DUP1 PUSH c6682862 EQ PUSH [tag] 30
*)
Compute pair "BottleCastle_run_code_of_0_block_11_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xc6682862%N);Opcode EQ;PUSH 1 (NToWord WLen 0x1e%N)] [DUP 1;PUSH 4 (NToWord WLen 0xC6682862%N);Opcode EQ;PUSH 1 (NToWord WLen 0x1e%N)] 1 optimize_id).

(*
 I: DUP1 PUSH C87B56DD EQ PUSH [tag] 31
 O: DUP1 PUSH c87b56dd EQ PUSH [tag] 31
*)
Compute pair "BottleCastle_run_code_of_0_block_12_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xc87b56dd%N);Opcode EQ;PUSH 1 (NToWord WLen 0x1f%N)] [DUP 1;PUSH 4 (NToWord WLen 0xC87B56DD%N);Opcode EQ;PUSH 1 (NToWord WLen 0x1f%N)] 1 optimize_id).

(*
 I: DUP1 PUSH D5ABEB01 EQ PUSH [tag] 32
 O: DUP1 PUSH d5abeb01 EQ PUSH [tag] 32
*)
Compute pair "BottleCastle_run_code_of_0_block_13_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xd5abeb01%N);Opcode EQ;PUSH 1 (NToWord WLen 0x20%N)] [DUP 1;PUSH 4 (NToWord WLen 0xD5ABEB01%N);Opcode EQ;PUSH 1 (NToWord WLen 0x20%N)] 1 optimize_id).

(*
 I: DUP1 PUSH DA3EF23F EQ PUSH [tag] 33
 O: DUP1 PUSH da3ef23f EQ PUSH [tag] 33
*)
Compute pair "BottleCastle_run_code_of_0_block_14_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xda3ef23f%N);Opcode EQ;PUSH 1 (NToWord WLen 0x21%N)] [DUP 1;PUSH 4 (NToWord WLen 0xDA3EF23F%N);Opcode EQ;PUSH 1 (NToWord WLen 0x21%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_15_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP1 PUSH 95D89B41 GT PUSH [tag] 42
 O: DUP1 PUSH 95d89b41 GT PUSH [tag] 42
*)
Compute pair "BottleCastle_run_code_of_0_block_16_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x95d89b41%N);Opcode GT;PUSH 1 (NToWord WLen 0x2a%N)] [DUP 1;PUSH 4 (NToWord WLen 0x95D89B41%N);Opcode GT;PUSH 1 (NToWord WLen 0x2a%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 95D89B41 EQ PUSH [tag] 24
 O: DUP1 PUSH 95d89b41 EQ PUSH [tag] 24
*)
Compute pair "BottleCastle_run_code_of_0_block_17_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x95d89b41%N);Opcode EQ;PUSH 1 (NToWord WLen 0x18%N)] [DUP 1;PUSH 4 (NToWord WLen 0x95D89B41%N);Opcode EQ;PUSH 1 (NToWord WLen 0x18%N)] 1 optimize_id).

(*
 I: DUP1 PUSH A0712D68 EQ PUSH [tag] 25
 O: DUP1 PUSH a0712d68 EQ PUSH [tag] 25
*)
Compute pair "BottleCastle_run_code_of_0_block_18_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xa0712d68%N);Opcode EQ;PUSH 1 (NToWord WLen 0x19%N)] [DUP 1;PUSH 4 (NToWord WLen 0xA0712D68%N);Opcode EQ;PUSH 1 (NToWord WLen 0x19%N)] 1 optimize_id).

(*
 I: DUP1 PUSH A22CB465 EQ PUSH [tag] 26
 O: DUP1 PUSH a22cb465 EQ PUSH [tag] 26
*)
Compute pair "BottleCastle_run_code_of_0_block_19_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xa22cb465%N);Opcode EQ;PUSH 1 (NToWord WLen 0x1a%N)] [DUP 1;PUSH 4 (NToWord WLen 0xA22CB465%N);Opcode EQ;PUSH 1 (NToWord WLen 0x1a%N)] 1 optimize_id).

(*
 I: DUP1 PUSH B88D4FDE EQ PUSH [tag] 27
 O: DUP1 PUSH b88d4fde EQ PUSH [tag] 27
*)
Compute pair "BottleCastle_run_code_of_0_block_20_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xb88d4fde%N);Opcode EQ;PUSH 1 (NToWord WLen 0x1b%N)] [DUP 1;PUSH 4 (NToWord WLen 0xB88D4FDE%N);Opcode EQ;PUSH 1 (NToWord WLen 0x1b%N)] 1 optimize_id).

(*
 I: DUP1 PUSH BC63F02E EQ PUSH [tag] 28
 O: DUP1 PUSH bc63f02e EQ PUSH [tag] 28
*)
Compute pair "BottleCastle_run_code_of_0_block_21_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xbc63f02e%N);Opcode EQ;PUSH 1 (NToWord WLen 0x1c%N)] [DUP 1;PUSH 4 (NToWord WLen 0xBC63F02E%N);Opcode EQ;PUSH 1 (NToWord WLen 0x1c%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_22_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP1 PUSH 715018A6 EQ PUSH [tag] 20
 O: DUP1 PUSH 715018a6 EQ PUSH [tag] 20
*)
Compute pair "BottleCastle_run_code_of_0_block_23_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x715018a6%N);Opcode EQ;PUSH 1 (NToWord WLen 0x14%N)] [DUP 1;PUSH 4 (NToWord WLen 0x715018A6%N);Opcode EQ;PUSH 1 (NToWord WLen 0x14%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 8462151C EQ PUSH [tag] 21
 O: DUP1 PUSH 8462151c EQ PUSH [tag] 21
*)
Compute pair "BottleCastle_run_code_of_0_block_24_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x8462151c%N);Opcode EQ;PUSH 1 (NToWord WLen 0x15%N)] [DUP 1;PUSH 4 (NToWord WLen 0x8462151C%N);Opcode EQ;PUSH 1 (NToWord WLen 0x15%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 8DA5CB5B EQ PUSH [tag] 22
 O: DUP1 PUSH 8da5cb5b EQ PUSH [tag] 22
*)
Compute pair "BottleCastle_run_code_of_0_block_25_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x8da5cb5b%N);Opcode EQ;PUSH 1 (NToWord WLen 0x16%N)] [DUP 1;PUSH 4 (NToWord WLen 0x8DA5CB5B%N);Opcode EQ;PUSH 1 (NToWord WLen 0x16%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 940CD05B EQ PUSH [tag] 23
 O: DUP1 PUSH 940cd05b EQ PUSH [tag] 23
*)
Compute pair "BottleCastle_run_code_of_0_block_26_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x940cd05b%N);Opcode EQ;PUSH 1 (NToWord WLen 0x17%N)] [DUP 1;PUSH 4 (NToWord WLen 0x940CD05B%N);Opcode EQ;PUSH 1 (NToWord WLen 0x17%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_27_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP1 PUSH 3CCFD60B GT PUSH [tag] 43
 O: DUP1 PUSH 3ccfd60b GT PUSH [tag] 43
*)
Compute pair "BottleCastle_run_code_of_0_block_28_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x3ccfd60b%N);Opcode GT;PUSH 1 (NToWord WLen 0x2b%N)] [DUP 1;PUSH 4 (NToWord WLen 0x3CCFD60B%N);Opcode GT;PUSH 1 (NToWord WLen 0x2b%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 55F804B3 GT PUSH [tag] 44
 O: DUP1 PUSH 55f804b3 GT PUSH [tag] 44
*)
Compute pair "BottleCastle_run_code_of_0_block_29_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x55f804b3%N);Opcode GT;PUSH 1 (NToWord WLen 0x2c%N)] [DUP 1;PUSH 4 (NToWord WLen 0x55F804B3%N);Opcode GT;PUSH 1 (NToWord WLen 0x2c%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 55F804B3 EQ PUSH [tag] 15
 O: DUP1 PUSH 55f804b3 EQ PUSH [tag] 15
*)
Compute pair "BottleCastle_run_code_of_0_block_30_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x55f804b3%N);Opcode EQ;PUSH 1 (NToWord WLen 0xf%N)] [DUP 1;PUSH 4 (NToWord WLen 0x55F804B3%N);Opcode EQ;PUSH 1 (NToWord WLen 0xf%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 5C975ABB EQ PUSH [tag] 16
 O: DUP1 PUSH 5c975abb EQ PUSH [tag] 16
*)
Compute pair "BottleCastle_run_code_of_0_block_31_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x5c975abb%N);Opcode EQ;PUSH 1 (NToWord WLen 0x10%N)] [DUP 1;PUSH 4 (NToWord WLen 0x5C975ABB%N);Opcode EQ;PUSH 1 (NToWord WLen 0x10%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 6352211E EQ PUSH [tag] 17
 O: DUP1 PUSH 6352211e EQ PUSH [tag] 17
*)
Compute pair "BottleCastle_run_code_of_0_block_32_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x6352211e%N);Opcode EQ;PUSH 1 (NToWord WLen 0x11%N)] [DUP 1;PUSH 4 (NToWord WLen 0x6352211E%N);Opcode EQ;PUSH 1 (NToWord WLen 0x11%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 6C0360EB EQ PUSH [tag] 18
 O: DUP1 PUSH 6c0360eb EQ PUSH [tag] 18
*)
Compute pair "BottleCastle_run_code_of_0_block_33_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x6c0360eb%N);Opcode EQ;PUSH 1 (NToWord WLen 0x12%N)] [DUP 1;PUSH 4 (NToWord WLen 0x6C0360EB%N);Opcode EQ;PUSH 1 (NToWord WLen 0x12%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 70A08231 EQ PUSH [tag] 19
 O: DUP1 PUSH 70a08231 EQ PUSH [tag] 19
*)
Compute pair "BottleCastle_run_code_of_0_block_34_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x70a08231%N);Opcode EQ;PUSH 1 (NToWord WLen 0x13%N)] [DUP 1;PUSH 4 (NToWord WLen 0x70A08231%N);Opcode EQ;PUSH 1 (NToWord WLen 0x13%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_35_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP1 PUSH 3CCFD60B EQ PUSH [tag] 11
 O: DUP1 PUSH 3ccfd60b EQ PUSH [tag] 11
*)
Compute pair "BottleCastle_run_code_of_0_block_36_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x3ccfd60b%N);Opcode EQ;PUSH 1 (NToWord WLen 0xb%N)] [DUP 1;PUSH 4 (NToWord WLen 0x3CCFD60B%N);Opcode EQ;PUSH 1 (NToWord WLen 0xb%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 42842E0E EQ PUSH [tag] 12
 O: DUP1 PUSH 42842e0e EQ PUSH [tag] 12
*)
Compute pair "BottleCastle_run_code_of_0_block_37_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x42842e0e%N);Opcode EQ;PUSH 1 (NToWord WLen 0xc%N)] [DUP 1;PUSH 4 (NToWord WLen 0x42842E0E%N);Opcode EQ;PUSH 1 (NToWord WLen 0xc%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 44A0D68A EQ PUSH [tag] 13
 O: DUP1 PUSH 44a0d68a EQ PUSH [tag] 13
*)
Compute pair "BottleCastle_run_code_of_0_block_38_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x44a0d68a%N);Opcode EQ;PUSH 1 (NToWord WLen 0xd%N)] [DUP 1;PUSH 4 (NToWord WLen 0x44A0D68A%N);Opcode EQ;PUSH 1 (NToWord WLen 0xd%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 51830227 EQ PUSH [tag] 14
 O: DUP1 PUSH 51830227 EQ PUSH [tag] 14
*)
Compute pair "BottleCastle_run_code_of_0_block_39_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x51830227%N);Opcode EQ;PUSH 1 (NToWord WLen 0xe%N)] [DUP 1;PUSH 4 (NToWord WLen 0x51830227%N);Opcode EQ;PUSH 1 (NToWord WLen 0xe%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_40_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP1 PUSH 81C8C44 GT PUSH [tag] 45
 O: DUP1 PUSH 81c8c44 GT PUSH [tag] 45
*)
Compute pair "BottleCastle_run_code_of_0_block_41_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x81c8c44%N);Opcode GT;PUSH 1 (NToWord WLen 0x2d%N)] [DUP 1;PUSH 4 (NToWord WLen 0x81C8C44%N);Opcode GT;PUSH 1 (NToWord WLen 0x2d%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 81C8C44 EQ PUSH [tag] 6
 O: DUP1 PUSH 81c8c44 EQ PUSH [tag] 6
*)
Compute pair "BottleCastle_run_code_of_0_block_42_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x81c8c44%N);Opcode EQ;PUSH 1 (NToWord WLen 0x6%N)] [DUP 1;PUSH 4 (NToWord WLen 0x81C8C44%N);Opcode EQ;PUSH 1 (NToWord WLen 0x6%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 95EA7B3 EQ PUSH [tag] 7
 O: DUP1 PUSH 95ea7b3 EQ PUSH [tag] 7
*)
Compute pair "BottleCastle_run_code_of_0_block_43_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x95ea7b3%N);Opcode EQ;PUSH 1 (NToWord WLen 0x7%N)] [DUP 1;PUSH 4 (NToWord WLen 0x95EA7B3%N);Opcode EQ;PUSH 1 (NToWord WLen 0x7%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 13FAEDE6 EQ PUSH [tag] 8
 O: DUP1 PUSH 13faede6 EQ PUSH [tag] 8
*)
Compute pair "BottleCastle_run_code_of_0_block_44_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x13faede6%N);Opcode EQ;PUSH 1 (NToWord WLen 0x8%N)] [DUP 1;PUSH 4 (NToWord WLen 0x13FAEDE6%N);Opcode EQ;PUSH 1 (NToWord WLen 0x8%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 18160DDD EQ PUSH [tag] 9
 O: DUP1 PUSH 18160ddd EQ PUSH [tag] 9
*)
Compute pair "BottleCastle_run_code_of_0_block_45_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x18160ddd%N);Opcode EQ;PUSH 1 (NToWord WLen 0x9%N)] [DUP 1;PUSH 4 (NToWord WLen 0x18160DDD%N);Opcode EQ;PUSH 1 (NToWord WLen 0x9%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 23B872DD EQ PUSH [tag] 10
 O: DUP1 PUSH 23b872dd EQ PUSH [tag] 10
*)
Compute pair "BottleCastle_run_code_of_0_block_46_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x23b872dd%N);Opcode EQ;PUSH 1 (NToWord WLen 0xa%N)] [DUP 1;PUSH 4 (NToWord WLen 0x23B872DD%N);Opcode EQ;PUSH 1 (NToWord WLen 0xa%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_47_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP1 PUSH 1FFC9A7 EQ PUSH [tag] 2
 O: DUP1 PUSH 1ffc9a7 EQ PUSH [tag] 2
*)
Compute pair "BottleCastle_run_code_of_0_block_48_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x1ffc9a7%N);Opcode EQ;PUSH 1 (NToWord WLen 0x2%N)] [DUP 1;PUSH 4 (NToWord WLen 0x1FFC9A7%N);Opcode EQ;PUSH 1 (NToWord WLen 0x2%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 2329A29 EQ PUSH [tag] 3
 O: DUP1 PUSH 2329a29 EQ PUSH [tag] 3
*)
Compute pair "BottleCastle_run_code_of_0_block_49_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x2329a29%N);Opcode EQ;PUSH 1 (NToWord WLen 0x3%N)] [DUP 1;PUSH 4 (NToWord WLen 0x2329A29%N);Opcode EQ;PUSH 1 (NToWord WLen 0x3%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 6FDDE03 EQ PUSH [tag] 4
 O: DUP1 PUSH 6fdde03 EQ PUSH [tag] 4
*)
Compute pair "BottleCastle_run_code_of_0_block_50_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x6fdde03%N);Opcode EQ;PUSH 1 (NToWord WLen 0x4%N)] [DUP 1;PUSH 4 (NToWord WLen 0x6FDDE03%N);Opcode EQ;PUSH 1 (NToWord WLen 0x4%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 81812FC EQ PUSH [tag] 5
 O: DUP1 PUSH 81812fc EQ PUSH [tag] 5
*)
Compute pair "BottleCastle_run_code_of_0_block_51_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x81812fc%N);Opcode EQ;PUSH 1 (NToWord WLen 0x5%N)] [DUP 1;PUSH 4 (NToWord WLen 0x81812FC%N);Opcode EQ;PUSH 1 (NToWord WLen 0x5%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_52_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 46
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 46
*)
Compute pair "BottleCastle_run_code_of_0_block_53_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x2e%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x2e%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_54_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 47 PUSH [tag] 48 CALLDATASIZE PUSH 4 PUSH [tag] 49
 O: POP PUSH [tag] 47 PUSH [tag] 48 CALLDATASIZE PUSH 4 PUSH [tag] 49
*)
Compute pair "BottleCastle_run_code_of_0_block_55_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x2f%N);PUSH 1 (NToWord WLen 0x30%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x31%N)] [POP;PUSH 1 (NToWord WLen 0x2f%N);PUSH 1 (NToWord WLen 0x30%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x31%N)] 1 optimize_id).

(*
 I: PUSH [tag] 50
 O: PUSH [tag] 50
*)
Compute pair "BottleCastle_run_code_of_0_block_56_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x32%N)] [PUSH 1 (NToWord WLen 0x32%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD SWAP1 ISZERO ISZERO DUP2
 O: ISZERO PUSH 40 MLOAD SWAP1 ISZERO DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_57_0"%string (equiv_checker [Opcode ISZERO;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;Opcode ISZERO;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;Opcode ISZERO;Opcode ISZERO;DUP 2] 1 optimize_id).

(*
 I: PUSH 20 ADD
 O: PUSH 20 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_57_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_58_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 53
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 53
*)
Compute pair "BottleCastle_run_code_of_0_block_59_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x35%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x35%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_60_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 54 PUSH [tag] 55 CALLDATASIZE PUSH 4 PUSH [tag] 56
 O: POP PUSH [tag] 54 PUSH [tag] 55 CALLDATASIZE PUSH 4 PUSH [tag] 56
*)
Compute pair "BottleCastle_run_code_of_0_block_61_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x37%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x38%N)] [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x37%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x38%N)] 1 optimize_id).

(*
 I: PUSH [tag] 57
 O: PUSH [tag] 57
*)
Compute pair "BottleCastle_run_code_of_0_block_62_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x39%N)] [PUSH 1 (NToWord WLen 0x39%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 58
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 58
*)
Compute pair "BottleCastle_run_code_of_0_block_64_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x3a%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x3a%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_65_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 59 PUSH [tag] 60
 O: POP PUSH [tag] 59 PUSH [tag] 60
*)
Compute pair "BottleCastle_run_code_of_0_block_66_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x3b%N);PUSH 1 (NToWord WLen 0x3c%N)] [POP;PUSH 1 (NToWord WLen 0x3b%N);PUSH 1 (NToWord WLen 0x3c%N)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 51 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 51 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Compute pair "BottleCastle_run_code_of_0_block_67_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x33%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x3e%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x33%N);DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x3e%N)] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 63
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 63
*)
Compute pair "BottleCastle_run_code_of_0_block_68_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x3f%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x3f%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_69_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 64 PUSH [tag] 65 CALLDATASIZE PUSH 4 PUSH [tag] 66
 O: POP PUSH [tag] 64 PUSH [tag] 65 CALLDATASIZE PUSH 4 PUSH [tag] 66
*)
Compute pair "BottleCastle_run_code_of_0_block_70_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x40%N);PUSH 1 (NToWord WLen 0x41%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x42%N)] [POP;PUSH 1 (NToWord WLen 0x40%N);PUSH 1 (NToWord WLen 0x41%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x42%N)] 1 optimize_id).

(*
 I: PUSH [tag] 67
 O: PUSH [tag] 67
*)
Compute pair "BottleCastle_run_code_of_0_block_71_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x43%N)] [PUSH 1 (NToWord WLen 0x43%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB SWAP1 SWAP2 AND DUP2
 O: PUSH 40 MLOAD SWAP1 PUSH 1 DUP1 PUSH a0 SHL SUB AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_72_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 1;DUP 2;Opcode AND;DUP 2] 1 optimize_id).

(*
 I: PUSH 20 ADD PUSH [tag] 51
 O: PUSH 20 ADD PUSH [tag] 51
*)
Compute pair "BottleCastle_run_code_of_0_block_72_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x33%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x33%N)] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 70
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 70
*)
Compute pair "BottleCastle_run_code_of_0_block_73_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x46%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x46%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_74_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 59 PUSH [tag] 72
 O: POP PUSH [tag] 59 PUSH [tag] 72
*)
Compute pair "BottleCastle_run_code_of_0_block_75_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x3b%N);PUSH 1 (NToWord WLen 0x48%N)] [POP;PUSH 1 (NToWord WLen 0x3b%N);PUSH 1 (NToWord WLen 0x48%N)] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 74
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 74
*)
Compute pair "BottleCastle_run_code_of_0_block_76_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4a%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4a%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_77_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 54 PUSH [tag] 76 CALLDATASIZE PUSH 4 PUSH [tag] 77
 O: POP PUSH [tag] 54 PUSH [tag] 76 CALLDATASIZE PUSH 4 PUSH [tag] 77
*)
Compute pair "BottleCastle_run_code_of_0_block_78_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x4c%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x4d%N)] [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x4c%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x4d%N)] 1 optimize_id).

(*
 I: PUSH [tag] 78
 O: PUSH [tag] 78
*)
Compute pair "BottleCastle_run_code_of_0_block_79_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x4e%N)] [PUSH 1 (NToWord WLen 0x4e%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 79
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 79
*)
Compute pair "BottleCastle_run_code_of_0_block_80_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4f%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4f%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_81_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 80 PUSH D SLOAD DUP2
 O: POP PUSH [tag] 80 PUSH d SLOAD DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_82_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x50%N);PUSH 1 (NToWord WLen 0xd%N);Opcode SLOAD;DUP 2] [POP;PUSH 1 (NToWord WLen 0x50%N);PUSH 1 (NToWord WLen 0xD%N);Opcode SLOAD;DUP 2] 1 optimize_id).

(*
 I: PUSH 40 MLOAD SWAP1 DUP2
 O: PUSH 40 MLOAD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_83_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2] 1 optimize_id).

(*
 I: PUSH 20 ADD PUSH [tag] 51
 O: PUSH 20 ADD PUSH [tag] 51
*)
Compute pair "BottleCastle_run_code_of_0_block_83_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x33%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x33%N)] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 84
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 84
*)
Compute pair "BottleCastle_run_code_of_0_block_84_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x54%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x54%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_85_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH 1 SLOAD PUSH 0 SLOAD SUB PUSH 0 NOT ADD PUSH [tag] 80
 O: POP PUSH 0 NOT PUSH 1 SLOAD PUSH 0 SLOAD SUB ADD PUSH [tag] 80
*)
Compute pair "BottleCastle_run_code_of_0_block_86_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;PUSH 1 (NToWord WLen 0x1%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;Opcode SUB;Opcode ADD;PUSH 1 (NToWord WLen 0x50%N)] [POP;PUSH 1 (NToWord WLen 0x1%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;Opcode ADD;PUSH 1 (NToWord WLen 0x50%N)] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 88
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 88
*)
Compute pair "BottleCastle_run_code_of_0_block_87_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x58%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x58%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_88_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 54 PUSH [tag] 90 CALLDATASIZE PUSH 4 PUSH [tag] 91
 O: POP PUSH [tag] 54 PUSH [tag] 90 CALLDATASIZE PUSH 4 PUSH [tag] 91
*)
Compute pair "BottleCastle_run_code_of_0_block_89_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x5a%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x5b%N)] [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x5a%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x5b%N)] 1 optimize_id).

(*
 I: PUSH [tag] 92
 O: PUSH [tag] 92
*)
Compute pair "BottleCastle_run_code_of_0_block_90_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x5c%N)] [PUSH 1 (NToWord WLen 0x5c%N)] 0 optimize_id).

(*
 I: PUSH [tag] 54 PUSH [tag] 94
 O: PUSH [tag] 54 PUSH [tag] 94
*)
Compute pair "BottleCastle_run_code_of_0_block_91_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x5e%N)] [PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x5e%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 95
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 95
*)
Compute pair "BottleCastle_run_code_of_0_block_92_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x5f%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x5f%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_93_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 54 PUSH [tag] 97 CALLDATASIZE PUSH 4 PUSH [tag] 91
 O: POP PUSH [tag] 54 PUSH [tag] 97 CALLDATASIZE PUSH 4 PUSH [tag] 91
*)
Compute pair "BottleCastle_run_code_of_0_block_94_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x61%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x5b%N)] [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x61%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x5b%N)] 1 optimize_id).

(*
 I: PUSH [tag] 98
 O: PUSH [tag] 98
*)
Compute pair "BottleCastle_run_code_of_0_block_95_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x62%N)] [PUSH 1 (NToWord WLen 0x62%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 99
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 99
*)
Compute pair "BottleCastle_run_code_of_0_block_96_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x63%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x63%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_97_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 54 PUSH [tag] 101 CALLDATASIZE PUSH 4 PUSH [tag] 66
 O: POP PUSH [tag] 54 PUSH [tag] 101 CALLDATASIZE PUSH 4 PUSH [tag] 66
*)
Compute pair "BottleCastle_run_code_of_0_block_98_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x65%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x42%N)] [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x65%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x42%N)] 1 optimize_id).

(*
 I: PUSH [tag] 102
 O: PUSH [tag] 102
*)
Compute pair "BottleCastle_run_code_of_0_block_99_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x66%N)] [PUSH 1 (NToWord WLen 0x66%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 103
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 103
*)
Compute pair "BottleCastle_run_code_of_0_block_100_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x67%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x67%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_101_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH 10 SLOAD PUSH [tag] 47 SWAP1 PUSH 100 SWAP1 DIV PUSH FF AND DUP2
 O: POP PUSH [tag] 47 PUSH 100 PUSH 10 SLOAD DIV PUSH ff AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_102_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x2f%N);PUSH 2 (NToWord WLen 0x100%N);PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;Opcode DIV;PUSH 1 (NToWord WLen 0xff%N);Opcode AND;DUP 2] [POP;PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x2f%N);DUP 1;PUSH 2 (NToWord WLen 0x100%N);DUP 1;Opcode DIV;PUSH 1 (NToWord WLen 0xFF%N);Opcode AND;DUP 2] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 107
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 107
*)
Compute pair "BottleCastle_run_code_of_0_block_103_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x6b%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x6b%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_104_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 54 PUSH [tag] 109 CALLDATASIZE PUSH 4 PUSH [tag] 110
 O: POP PUSH [tag] 54 PUSH [tag] 109 CALLDATASIZE PUSH 4 PUSH [tag] 110
*)
Compute pair "BottleCastle_run_code_of_0_block_105_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x6d%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x6e%N)] [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x6d%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x6e%N)] 1 optimize_id).

(*
 I: PUSH [tag] 111
 O: PUSH [tag] 111
*)
Compute pair "BottleCastle_run_code_of_0_block_106_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x6f%N)] [PUSH 1 (NToWord WLen 0x6f%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 112
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 112
*)
Compute pair "BottleCastle_run_code_of_0_block_107_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x70%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x70%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_108_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH 10 SLOAD PUSH [tag] 47 SWAP1 PUSH FF AND DUP2
 O: POP PUSH [tag] 47 PUSH ff PUSH 10 SLOAD AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_109_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x2f%N);PUSH 1 (NToWord WLen 0xff%N);PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;Opcode AND;DUP 2] [POP;PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x2f%N);DUP 1;PUSH 1 (NToWord WLen 0xFF%N);Opcode AND;DUP 2] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 116
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 116
*)
Compute pair "BottleCastle_run_code_of_0_block_110_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x74%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x74%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_111_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 64 PUSH [tag] 118 CALLDATASIZE PUSH 4 PUSH [tag] 66
 O: POP PUSH [tag] 64 PUSH [tag] 118 CALLDATASIZE PUSH 4 PUSH [tag] 66
*)
Compute pair "BottleCastle_run_code_of_0_block_112_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x40%N);PUSH 1 (NToWord WLen 0x76%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x42%N)] [POP;PUSH 1 (NToWord WLen 0x40%N);PUSH 1 (NToWord WLen 0x76%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x42%N)] 1 optimize_id).

(*
 I: PUSH [tag] 119
 O: PUSH [tag] 119
*)
Compute pair "BottleCastle_run_code_of_0_block_113_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x77%N)] [PUSH 1 (NToWord WLen 0x77%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 121
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 121
*)
Compute pair "BottleCastle_run_code_of_0_block_114_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x79%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x79%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_115_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 59 PUSH [tag] 123
 O: POP PUSH [tag] 59 PUSH [tag] 123
*)
Compute pair "BottleCastle_run_code_of_0_block_116_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x3b%N);PUSH 1 (NToWord WLen 0x7b%N)] [POP;PUSH 1 (NToWord WLen 0x3b%N);PUSH 1 (NToWord WLen 0x7b%N)] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 125
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 125
*)
Compute pair "BottleCastle_run_code_of_0_block_117_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x7d%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x7d%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_118_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 80 PUSH [tag] 127 CALLDATASIZE PUSH 4 PUSH [tag] 128
 O: POP PUSH [tag] 80 PUSH [tag] 127 CALLDATASIZE PUSH 4 PUSH [tag] 128
*)
Compute pair "BottleCastle_run_code_of_0_block_119_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x50%N);PUSH 1 (NToWord WLen 0x7f%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x80%N)] [POP;PUSH 1 (NToWord WLen 0x50%N);PUSH 1 (NToWord WLen 0x7f%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x80%N)] 1 optimize_id).

(*
 I: PUSH [tag] 129
 O: PUSH [tag] 129
*)
Compute pair "BottleCastle_run_code_of_0_block_120_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x81%N)] [PUSH 1 (NToWord WLen 0x81%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 131
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 131
*)
Compute pair "BottleCastle_run_code_of_0_block_121_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x83%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x83%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_122_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 54 PUSH [tag] 133
 O: POP PUSH [tag] 54 PUSH [tag] 133
*)
Compute pair "BottleCastle_run_code_of_0_block_123_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x85%N)] [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x85%N)] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 134
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 134
*)
Compute pair "BottleCastle_run_code_of_0_block_124_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x86%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x86%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_125_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 135 PUSH [tag] 136 CALLDATASIZE PUSH 4 PUSH [tag] 128
 O: POP PUSH [tag] 135 PUSH [tag] 136 CALLDATASIZE PUSH 4 PUSH [tag] 128
*)
Compute pair "BottleCastle_run_code_of_0_block_126_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x87%N);PUSH 1 (NToWord WLen 0x88%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x80%N)] [POP;PUSH 1 (NToWord WLen 0x87%N);PUSH 1 (NToWord WLen 0x88%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x80%N)] 1 optimize_id).

(*
 I: PUSH [tag] 137
 O: PUSH [tag] 137
*)
Compute pair "BottleCastle_run_code_of_0_block_127_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x89%N)] [PUSH 1 (NToWord WLen 0x89%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 51 SWAP2 SWAP1 PUSH [tag] 139
 O: PUSH [tag] 51 SWAP1 PUSH 40 MLOAD PUSH [tag] 139
*)
Compute pair "BottleCastle_run_code_of_0_block_128_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x33%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x8b%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x33%N);DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x8b%N)] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 140
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 140
*)
Compute pair "BottleCastle_run_code_of_0_block_129_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x8c%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x8c%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_130_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH 8 SLOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB AND PUSH [tag] 64
 O: POP PUSH 1 DUP1 PUSH a0 SHL SUB PUSH 8 SLOAD AND PUSH [tag] 64
*)
Compute pair "BottleCastle_run_code_of_0_block_131_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;PUSH 1 (NToWord WLen 0x8%N);Opcode SLOAD;Opcode AND;PUSH 1 (NToWord WLen 0x40%N)] [POP;PUSH 1 (NToWord WLen 0x8%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;PUSH 1 (NToWord WLen 0x40%N)] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 144
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 144
*)
Compute pair "BottleCastle_run_code_of_0_block_132_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x90%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x90%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_133_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 54 PUSH [tag] 146 CALLDATASIZE PUSH 4 PUSH [tag] 56
 O: POP PUSH [tag] 54 PUSH [tag] 146 CALLDATASIZE PUSH 4 PUSH [tag] 56
*)
Compute pair "BottleCastle_run_code_of_0_block_134_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x92%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x38%N)] [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x92%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x38%N)] 1 optimize_id).

(*
 I: PUSH [tag] 147
 O: PUSH [tag] 147
*)
Compute pair "BottleCastle_run_code_of_0_block_135_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x93%N)] [PUSH 1 (NToWord WLen 0x93%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 148
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 148
*)
Compute pair "BottleCastle_run_code_of_0_block_136_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x94%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x94%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_137_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 59 PUSH [tag] 150
 O: POP PUSH [tag] 59 PUSH [tag] 150
*)
Compute pair "BottleCastle_run_code_of_0_block_138_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x3b%N);PUSH 1 (NToWord WLen 0x96%N)] [POP;PUSH 1 (NToWord WLen 0x3b%N);PUSH 1 (NToWord WLen 0x96%N)] 1 optimize_id).

(*
 I: PUSH [tag] 54 PUSH [tag] 153 CALLDATASIZE PUSH 4 PUSH [tag] 66
 O: PUSH [tag] 54 PUSH [tag] 153 CALLDATASIZE PUSH 4 PUSH [tag] 66
*)
Compute pair "BottleCastle_run_code_of_0_block_139_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x99%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x42%N)] [PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x99%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x42%N)] 0 optimize_id).

(*
 I: PUSH [tag] 154
 O: PUSH [tag] 154
*)
Compute pair "BottleCastle_run_code_of_0_block_140_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x9a%N)] [PUSH 1 (NToWord WLen 0x9a%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 155
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 155
*)
Compute pair "BottleCastle_run_code_of_0_block_141_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x9b%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x9b%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_142_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 54 PUSH [tag] 157 CALLDATASIZE PUSH 4 PUSH [tag] 158
 O: POP PUSH [tag] 54 PUSH [tag] 157 CALLDATASIZE PUSH 4 PUSH [tag] 158
*)
Compute pair "BottleCastle_run_code_of_0_block_143_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x9d%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x9e%N)] [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0x9d%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x9e%N)] 1 optimize_id).

(*
 I: PUSH [tag] 159
 O: PUSH [tag] 159
*)
Compute pair "BottleCastle_run_code_of_0_block_144_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x9f%N)] [PUSH 1 (NToWord WLen 0x9f%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 160
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 160
*)
Compute pair "BottleCastle_run_code_of_0_block_145_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xa0%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xa0%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_146_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 54 PUSH [tag] 162 CALLDATASIZE PUSH 4 PUSH [tag] 163
 O: POP PUSH [tag] 54 PUSH [tag] 162 CALLDATASIZE PUSH 4 PUSH [tag] 163
*)
Compute pair "BottleCastle_run_code_of_0_block_147_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0xa2%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0xa3%N)] [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0xa2%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0xa3%N)] 1 optimize_id).

(*
 I: PUSH [tag] 164
 O: PUSH [tag] 164
*)
Compute pair "BottleCastle_run_code_of_0_block_148_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xa4%N)] [PUSH 1 (NToWord WLen 0xa4%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 165
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 165
*)
Compute pair "BottleCastle_run_code_of_0_block_149_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xa5%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xa5%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_150_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 54 PUSH [tag] 167 CALLDATASIZE PUSH 4 PUSH [tag] 168
 O: POP PUSH [tag] 54 PUSH [tag] 167 CALLDATASIZE PUSH 4 PUSH [tag] 168
*)
Compute pair "BottleCastle_run_code_of_0_block_151_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0xa7%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0xa8%N)] [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0xa7%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0xa8%N)] 1 optimize_id).

(*
 I: PUSH [tag] 169
 O: PUSH [tag] 169
*)
Compute pair "BottleCastle_run_code_of_0_block_152_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xa9%N)] [PUSH 1 (NToWord WLen 0xa9%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 170
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 170
*)
Compute pair "BottleCastle_run_code_of_0_block_153_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xaa%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xaa%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_154_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 80 PUSH F SLOAD DUP2
 O: POP PUSH [tag] 80 PUSH f SLOAD DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_155_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x50%N);PUSH 1 (NToWord WLen 0xf%N);Opcode SLOAD;DUP 2] [POP;PUSH 1 (NToWord WLen 0x50%N);PUSH 1 (NToWord WLen 0xF%N);Opcode SLOAD;DUP 2] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 174
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 174
*)
Compute pair "BottleCastle_run_code_of_0_block_156_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xae%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xae%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_157_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 59 PUSH [tag] 176
 O: POP PUSH [tag] 59 PUSH [tag] 176
*)
Compute pair "BottleCastle_run_code_of_0_block_158_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x3b%N);PUSH 1 (NToWord WLen 0xb0%N)] [POP;PUSH 1 (NToWord WLen 0x3b%N);PUSH 1 (NToWord WLen 0xb0%N)] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 178
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 178
*)
Compute pair "BottleCastle_run_code_of_0_block_159_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb2%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb2%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_160_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 59 PUSH [tag] 180 CALLDATASIZE PUSH 4 PUSH [tag] 66
 O: POP PUSH [tag] 59 PUSH [tag] 180 CALLDATASIZE PUSH 4 PUSH [tag] 66
*)
Compute pair "BottleCastle_run_code_of_0_block_161_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x3b%N);PUSH 1 (NToWord WLen 0xb4%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x42%N)] [POP;PUSH 1 (NToWord WLen 0x3b%N);PUSH 1 (NToWord WLen 0xb4%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x42%N)] 1 optimize_id).

(*
 I: PUSH [tag] 181
 O: PUSH [tag] 181
*)
Compute pair "BottleCastle_run_code_of_0_block_162_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xb5%N)] [PUSH 1 (NToWord WLen 0xb5%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 183
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 183
*)
Compute pair "BottleCastle_run_code_of_0_block_163_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb7%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb7%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_164_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 80 PUSH E SLOAD DUP2
 O: POP PUSH [tag] 80 PUSH e SLOAD DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_165_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x50%N);PUSH 1 (NToWord WLen 0xe%N);Opcode SLOAD;DUP 2] [POP;PUSH 1 (NToWord WLen 0x50%N);PUSH 1 (NToWord WLen 0xE%N);Opcode SLOAD;DUP 2] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 187
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 187
*)
Compute pair "BottleCastle_run_code_of_0_block_166_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xbb%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xbb%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_167_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 54 PUSH [tag] 189 CALLDATASIZE PUSH 4 PUSH [tag] 110
 O: POP PUSH [tag] 54 PUSH [tag] 189 CALLDATASIZE PUSH 4 PUSH [tag] 110
*)
Compute pair "BottleCastle_run_code_of_0_block_168_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0xbd%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x6e%N)] [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0xbd%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x6e%N)] 1 optimize_id).

(*
 I: PUSH [tag] 190
 O: PUSH [tag] 190
*)
Compute pair "BottleCastle_run_code_of_0_block_169_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xbe%N)] [PUSH 1 (NToWord WLen 0xbe%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 191
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 191
*)
Compute pair "BottleCastle_run_code_of_0_block_170_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xbf%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xbf%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_171_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 80 PUSH [tag] 193 CALLDATASIZE PUSH 4 PUSH [tag] 128
 O: POP PUSH [tag] 80 PUSH [tag] 193 CALLDATASIZE PUSH 4 PUSH [tag] 128
*)
Compute pair "BottleCastle_run_code_of_0_block_172_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x50%N);PUSH 1 (NToWord WLen 0xc1%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x80%N)] [POP;PUSH 1 (NToWord WLen 0x50%N);PUSH 1 (NToWord WLen 0xc1%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x80%N)] 1 optimize_id).

(*
 I: PUSH [tag] 194
 O: PUSH [tag] 194
*)
Compute pair "BottleCastle_run_code_of_0_block_173_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xc2%N)] [PUSH 1 (NToWord WLen 0xc2%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 196
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 196
*)
Compute pair "BottleCastle_run_code_of_0_block_174_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc4%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc4%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_175_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 54 PUSH [tag] 198 CALLDATASIZE PUSH 4 PUSH [tag] 66
 O: POP PUSH [tag] 54 PUSH [tag] 198 CALLDATASIZE PUSH 4 PUSH [tag] 66
*)
Compute pair "BottleCastle_run_code_of_0_block_176_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0xc6%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x42%N)] [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0xc6%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x42%N)] 1 optimize_id).

(*
 I: PUSH [tag] 199
 O: PUSH [tag] 199
*)
Compute pair "BottleCastle_run_code_of_0_block_177_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xc7%N)] [PUSH 1 (NToWord WLen 0xc7%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 200
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 200
*)
Compute pair "BottleCastle_run_code_of_0_block_178_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc8%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc8%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_179_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 47 PUSH [tag] 202 CALLDATASIZE PUSH 4 PUSH [tag] 203
 O: POP PUSH [tag] 47 PUSH [tag] 202 CALLDATASIZE PUSH 4 PUSH [tag] 203
*)
Compute pair "BottleCastle_run_code_of_0_block_180_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x2f%N);PUSH 1 (NToWord WLen 0xca%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0xcb%N)] [POP;PUSH 1 (NToWord WLen 0x2f%N);PUSH 1 (NToWord WLen 0xca%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0xcb%N)] 1 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB SWAP2 DUP3 AND PUSH 0 SWAP1 DUP2
 O: PUSH 1 DUP1 PUSH a0 SHL SUB DUP1 SWAP3 AND PUSH 0 SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_181_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 1;DUP 3;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 2;DUP 3;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 7 PUSH 20 SWAP1 DUP2
 O: PUSH 20 PUSH 7 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_181_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x7%N);DUP 2] [PUSH 1 (NToWord WLen 0x7%N);PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 2] 0 optimize_id).

(*
 I: PUSH 40 DUP1 DUP4 KECCAK256 SWAP4 SWAP1 SWAP5 AND DUP3
 O: PUSH 40 SWAP4 DUP5 DUP4 KECCAK256 SWAP4 AND DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_181_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 5;DUP 4;Opcode KECCAK256;DUP 4;Opcode AND;DUP 3] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;DUP 4;Opcode KECCAK256;DUP 4;DUP 1;DUP 5;Opcode AND;DUP 3] 4 optimize_id).

(*
 I: SWAP2 SWAP1 SWAP2
 O: SWAP1 SWAP2 SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_181_3"%string (equiv_checker [DUP 1;DUP 2;DUP 1] [DUP 2;DUP 1;DUP 2] 3 optimize_id).

(*
 I: KECCAK256 SLOAD PUSH FF AND SWAP1
 O: KECCAK256 SLOAD PUSH ff AND SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_181_4"%string (equiv_checker [Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0xff%N);Opcode AND;DUP 1] [Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0xFF%N);Opcode AND;DUP 1] 3 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 206
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 206
*)
Compute pair "BottleCastle_run_code_of_0_block_182_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xce%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xce%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_183_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 54 PUSH [tag] 208 CALLDATASIZE PUSH 4 PUSH [tag] 110
 O: POP PUSH [tag] 54 PUSH [tag] 208 CALLDATASIZE PUSH 4 PUSH [tag] 110
*)
Compute pair "BottleCastle_run_code_of_0_block_184_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0xd0%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x6e%N)] [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0xd0%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x6e%N)] 1 optimize_id).

(*
 I: PUSH [tag] 209
 O: PUSH [tag] 209
*)
Compute pair "BottleCastle_run_code_of_0_block_185_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xd1%N)] [PUSH 1 (NToWord WLen 0xd1%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 210
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 210
*)
Compute pair "BottleCastle_run_code_of_0_block_186_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xd2%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xd2%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_187_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 54 PUSH [tag] 212 CALLDATASIZE PUSH 4 PUSH [tag] 128
 O: POP PUSH [tag] 54 PUSH [tag] 212 CALLDATASIZE PUSH 4 PUSH [tag] 128
*)
Compute pair "BottleCastle_run_code_of_0_block_188_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0xd4%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x80%N)] [POP;PUSH 1 (NToWord WLen 0x36%N);PUSH 1 (NToWord WLen 0xd4%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x80%N)] 1 optimize_id).

(*
 I: PUSH [tag] 213
 O: PUSH [tag] 213
*)
Compute pair "BottleCastle_run_code_of_0_block_189_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xd5%N)] [PUSH 1 (NToWord WLen 0xd5%N)] 0 optimize_id).

(*
 I: PUSH 0 PUSH 1FFC9A7 PUSH E0 SHL PUSH 1 PUSH 1 PUSH E0 SHL SUB NOT DUP4 AND EQ DUP1 PUSH [tag] 215
 O: PUSH 0 PUSH 1 DUP1 PUSH e0 SHL SUB NOT DUP3 AND PUSH 1ffc9a7 PUSH e0 SHL EQ DUP1 PUSH [tag] 215
*)
Compute pair "BottleCastle_run_code_of_0_block_190_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 3;Opcode AND;PUSH 4 (NToWord WLen 0x1ffc9a7%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode EQ;DUP 1;PUSH 1 (NToWord WLen 0xd7%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 4 (NToWord WLen 0x1FFC9A7%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 4;Opcode AND;Opcode EQ;DUP 1;PUSH 1 (NToWord WLen 0xd7%N)] 1 optimize_id).

(*
 I: POP PUSH 80AC58CD PUSH E0 SHL PUSH 1 PUSH 1 PUSH E0 SHL SUB NOT DUP4 AND EQ
 O: POP PUSH 80ac58cd PUSH e0 SHL PUSH 1 DUP1 PUSH e0 SHL SUB NOT DUP4 AND EQ
*)
Compute pair "BottleCastle_run_code_of_0_block_191_0"%string (equiv_checker [POP;PUSH 4 (NToWord WLen 0x80ac58cd%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 4;Opcode AND;Opcode EQ] [POP;PUSH 4 (NToWord WLen 0x80AC58CD%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 4;Opcode AND;Opcode EQ] 3 optimize_id).

(*
 I: DUP1 PUSH [tag] 216
 O: DUP1 PUSH [tag] 216
*)
Compute pair "BottleCastle_run_code_of_0_block_192_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0xd8%N)] [DUP 1;PUSH 1 (NToWord WLen 0xd8%N)] 1 optimize_id).

(*
 I: POP PUSH 5B5E139F PUSH E0 SHL PUSH 1 PUSH 1 PUSH E0 SHL SUB NOT DUP4 AND EQ
 O: POP PUSH 5b5e139f PUSH e0 SHL PUSH 1 DUP1 PUSH e0 SHL SUB NOT DUP4 AND EQ
*)
Compute pair "BottleCastle_run_code_of_0_block_193_0"%string (equiv_checker [POP;PUSH 4 (NToWord WLen 0x5b5e139f%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 4;Opcode AND;Opcode EQ] [POP;PUSH 4 (NToWord WLen 0x5B5E139F%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 4;Opcode AND;Opcode EQ] 3 optimize_id).

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_194_0"%string (equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH [tag] 218 PUSH [tag] 219
 O: PUSH [tag] 218 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_195_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xda%N);PUSH 1 (NToWord WLen 0xdb%N)] [PUSH 1 (NToWord WLen 0xda%N);PUSH 1 (NToWord WLen 0xdb%N)] 0 optimize_id).

(*
 I: PUSH 10 DUP1 SLOAD PUSH FF NOT AND SWAP2 ISZERO ISZERO SWAP2 SWAP1 SWAP2 OR SWAP1
 O: ISZERO ISZERO PUSH 10 SLOAD PUSH ff NOT AND OR PUSH 10
*)
Compute pair "BottleCastle_run_code_of_0_block_196_0"%string (equiv_checker [Opcode ISZERO;Opcode ISZERO;PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0xff%N);Opcode NOT;Opcode AND;Opcode OR;PUSH 1 (NToWord WLen 0x10%N)] [PUSH 1 (NToWord WLen 0x10%N);DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xFF%N);Opcode NOT;Opcode AND;DUP 2;Opcode ISZERO;Opcode ISZERO;DUP 2;DUP 1;DUP 2;Opcode OR;DUP 1] 1 optimize_id).

(*
 I: PUSH 60 PUSH 2 DUP1 SLOAD PUSH [tag] 222 SWAP1 PUSH [tag] 223
 O: PUSH 60 PUSH 2 PUSH [tag] 222 DUP2 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_197_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0xde%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x2%N);DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xde%N);DUP 1;PUSH 1 (NToWord WLen 0xdf%N)] 0 optimize_id).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_198_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x1f%N);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 1 optimize_id).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute pair "BottleCastle_run_code_of_0_block_198_1"%string (equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 224 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 224 DUP5 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_198_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;PUSH 1 (NToWord WLen 0xe0%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xe0%N);DUP 1;PUSH 1 (NToWord WLen 0xdf%N)] 3 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 225
 O: DUP1 ISZERO PUSH [tag] 225
*)
Compute pair "BottleCastle_run_code_of_0_block_199_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xe1%N)] [DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xe1%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 226
 O: DUP1 PUSH 1f LT PUSH [tag] 226
*)
Compute pair "BottleCastle_run_code_of_0_block_200_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x1f%N);Opcode LT;PUSH 1 (NToWord WLen 0xe2%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode LT;PUSH 1 (NToWord WLen 0xe2%N)] 1 optimize_id).

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_201_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x100%N);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (NToWord WLen 0x100%N);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 225
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 225
*)
Compute pair "BottleCastle_run_code_of_0_block_201_1"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;PUSH 1 (NToWord WLen 0xe1%N)] [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;PUSH 1 (NToWord WLen 0xe1%N)] 3 optimize_id).

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_202_0"%string (equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x0%N)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x0%N)] 3 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_202_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 1] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 1] 1 optimize_id).

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_203_0"%string (equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id).

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 227
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 227
*)
Compute pair "BottleCastle_run_code_of_0_block_203_1"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (NToWord WLen 0xe3%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (NToWord WLen 0xe3%N)] 3 optimize_id).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_204_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x1F%N);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id).

(*
 I: POP POP POP POP POP SWAP1 POP SWAP1
 O: POP POP POP POP POP SWAP2 SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_205_0"%string (equiv_checker [POP;POP;POP;POP;POP;DUP 2;DUP 1;POP] [POP;POP;POP;POP;POP;DUP 1;POP;DUP 1] 8 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 229 DUP3 PUSH [tag] 230
 O: PUSH 0 PUSH [tag] 229 DUP3 PUSH [tag] 230
*)
Compute pair "BottleCastle_run_code_of_0_block_206_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0xe5%N);DUP 3;PUSH 1 (NToWord WLen 0xe6%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0xe5%N);DUP 3;PUSH 1 (NToWord WLen 0xe6%N)] 1 optimize_id).

(*
 I: PUSH [tag] 231
 O: PUSH [tag] 231
*)
Compute pair "BottleCastle_run_code_of_0_block_207_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xe7%N)] [PUSH 1 (NToWord WLen 0xe7%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 33D1C039 PUSH E2 SHL DUP2
 O: PUSH 40 MLOAD PUSH 33d1c039 PUSH e2 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_208_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x33d1c039%N);PUSH 1 (NToWord WLen 0xe2%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x33D1C039%N);PUSH 1 (NToWord WLen 0xE2%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_208_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: POP PUSH 0 SWAP1 DUP2
 O: POP PUSH 0 SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_209_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] [POP;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 6 PUSH 20
 O: PUSH 6 PUSH 20
*)
Compute pair "BottleCastle_run_code_of_0_block_209_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x6%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x6%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB AND SWAP1
 O: PUSH 40 PUSH 1 DUP1 PUSH a0 SHL SUB SWAP2 KECCAK256 SLOAD AND SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_209_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 2;Opcode KECCAK256;Opcode SLOAD;Opcode AND;DUP 1] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;DUP 1] 2 optimize_id).

(*
 I: PUSH C DUP1 SLOAD PUSH [tag] 232 SWAP1 PUSH [tag] 223
 O: PUSH c PUSH [tag] 232 DUP2 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_210_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xc%N);PUSH 1 (NToWord WLen 0xe8%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0xC%N);DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xe8%N);DUP 1;PUSH 1 (NToWord WLen 0xdf%N)] 0 optimize_id).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_211_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x1f%N);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 1 optimize_id).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute pair "BottleCastle_run_code_of_0_block_211_1"%string (equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 233 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 233 DUP5 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_211_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;PUSH 1 (NToWord WLen 0xe9%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xe9%N);DUP 1;PUSH 1 (NToWord WLen 0xdf%N)] 3 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 234
 O: DUP1 ISZERO PUSH [tag] 234
*)
Compute pair "BottleCastle_run_code_of_0_block_212_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xea%N)] [DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xea%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 235
 O: DUP1 PUSH 1f LT PUSH [tag] 235
*)
Compute pair "BottleCastle_run_code_of_0_block_213_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x1f%N);Opcode LT;PUSH 1 (NToWord WLen 0xeb%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode LT;PUSH 1 (NToWord WLen 0xeb%N)] 1 optimize_id).

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_214_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x100%N);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (NToWord WLen 0x100%N);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 234
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 234
*)
Compute pair "BottleCastle_run_code_of_0_block_214_1"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;PUSH 1 (NToWord WLen 0xea%N)] [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;PUSH 1 (NToWord WLen 0xea%N)] 3 optimize_id).

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_215_0"%string (equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x0%N)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x0%N)] 3 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_215_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 1] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 1] 1 optimize_id).

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_216_0"%string (equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id).

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 236
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 236
*)
Compute pair "BottleCastle_run_code_of_0_block_216_1"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (NToWord WLen 0xec%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (NToWord WLen 0xec%N)] 3 optimize_id).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_217_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x1F%N);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id).

(*
 I: POP POP POP POP POP DUP2
 O: POP POP POP POP POP DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_218_0"%string (equiv_checker [POP;POP;POP;POP;POP;DUP 2] [POP;POP;POP;POP;POP;DUP 2] 7 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 238 DUP3 PUSH [tag] 119
 O: PUSH 0 PUSH [tag] 238 DUP3 PUSH [tag] 119
*)
Compute pair "BottleCastle_run_code_of_0_block_219_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0xee%N);DUP 3;PUSH 1 (NToWord WLen 0x77%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0xee%N);DUP 3;PUSH 1 (NToWord WLen 0x77%N)] 1 optimize_id).

(*
 I: SWAP1 POP CALLER PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP3 AND EQ PUSH [tag] 244
 O: PUSH 1 DUP1 DUP3 SWAP4 POP PUSH a0 SHL SUB AND CALLER EQ PUSH [tag] 244
*)
Compute pair "BottleCastle_run_code_of_0_block_220_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;DUP 3;DUP 4;POP;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode CALLER;Opcode EQ;PUSH 1 (NToWord WLen 0xf4%N)] [DUP 1;POP;Opcode CALLER;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 3;Opcode AND;Opcode EQ;PUSH 1 (NToWord WLen 0xf4%N)] 2 optimize_id).

(*
 I: PUSH [tag] 242 DUP2 CALLER PUSH [tag] 202
 O: PUSH [tag] 242 DUP2 CALLER PUSH [tag] 202
*)
Compute pair "BottleCastle_run_code_of_0_block_221_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xf2%N);DUP 2;Opcode CALLER;PUSH 1 (NToWord WLen 0xca%N)] [PUSH 1 (NToWord WLen 0xf2%N);DUP 2;Opcode CALLER;PUSH 1 (NToWord WLen 0xca%N)] 1 optimize_id).

(*
 I: PUSH [tag] 244
 O: PUSH [tag] 244
*)
Compute pair "BottleCastle_run_code_of_0_block_222_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xf4%N)] [PUSH 1 (NToWord WLen 0xf4%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 67D9DCA1 PUSH E1 SHL DUP2
 O: PUSH 40 MLOAD PUSH 67d9dca1 PUSH e1 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_223_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x67d9dca1%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x67D9DCA1%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_223_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 DUP3 DUP2
 O: PUSH 0 DUP3 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_224_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 2] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 2] 2 optimize_id).

(*
 I: PUSH 6 PUSH 20
 O: PUSH 6 PUSH 20
*)
Compute pair "BottleCastle_run_code_of_0_block_224_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x6%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x6%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: SWAP2 MLOAD DUP6 SWAP4 SWAP2 DUP6 AND SWAP2 PUSH 8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B925 SWAP2
 O: SWAP2 SWAP1 DUP6 SWAP4 PUSH 8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925 SWAP2 DUP7 AND SWAP3 MLOAD
*)
Compute pair "BottleCastle_run_code_of_0_block_224_3"%string (equiv_checker [DUP 2;DUP 1;DUP 6;DUP 4;PUSH 32 (NToWord WLen 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925%N);DUP 2;DUP 7;Opcode AND;DUP 3;Opcode MLOAD] [DUP 2;Opcode MLOAD;DUP 6;DUP 4;DUP 2;DUP 6;Opcode AND;DUP 2;PUSH 32 (NToWord WLen 0x8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B925%N);DUP 2] 6 optimize_id).

(*
 I: POP POP POP
 O: POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_224_4"%string (equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 249 DUP3 PUSH [tag] 250
 O: PUSH 0 PUSH [tag] 249 DUP3 PUSH [tag] 250
*)
Compute pair "BottleCastle_run_code_of_0_block_225_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0xf9%N);DUP 3;PUSH 1 (NToWord WLen 0xfa%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0xf9%N);DUP 3;PUSH 1 (NToWord WLen 0xfa%N)] 1 optimize_id).

(*
 I: SWAP1 POP DUP4 PUSH 1 PUSH 1 PUSH A0 SHL SUB AND DUP2 PUSH 1 PUSH 1 PUSH A0 SHL SUB AND EQ PUSH [tag] 251
 O: DUP1 SWAP2 POP PUSH 1 DUP1 PUSH a0 SHL SUB DUP6 DUP2 AND SWAP2 AND EQ PUSH [tag] 251
*)
Compute pair "BottleCastle_run_code_of_0_block_226_0"%string (equiv_checker [DUP 1;DUP 2;POP;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 6;DUP 2;Opcode AND;DUP 2;Opcode AND;Opcode EQ;PUSH 1 (NToWord WLen 0xfb%N)] [DUP 1;POP;DUP 4;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;DUP 2;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode EQ;PUSH 1 (NToWord WLen 0xfb%N)] 5 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH A11481 PUSH E8 SHL DUP2
 O: PUSH 40 MLOAD PUSH a11481 PUSH e8 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_227_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0xa11481%N);PUSH 1 (NToWord WLen 0xe8%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0xA11481%N);PUSH 1 (NToWord WLen 0xE8%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_227_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 DUP3 DUP2
 O: PUSH 0 DUP3 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_228_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 2] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 2] 2 optimize_id).

(*
 I: PUSH 6 PUSH 20
 O: PUSH 6 PUSH 20
*)
Compute pair "BottleCastle_run_code_of_0_block_228_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x6%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x6%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 DUP1 SLOAD CALLER DUP1 DUP3 EQ PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP9 AND SWAP1 SWAP2 EQ OR PUSH [tag] 260
 O: PUSH 40 SWAP1 KECCAK256 DUP5 PUSH 1 DUP1 PUSH a0 SHL SUB AND CALLER EQ DUP2 SLOAD SWAP1 CALLER DUP3 EQ OR PUSH [tag] 260
*)
Compute pair "BottleCastle_run_code_of_0_block_228_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;DUP 5;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode CALLER;Opcode EQ;DUP 2;Opcode SLOAD;DUP 1;Opcode CALLER;DUP 3;Opcode EQ;Opcode OR;PUSH 2 (NToWord WLen 0x104%N)] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;DUP 1;Opcode SLOAD;Opcode CALLER;DUP 1;DUP 3;Opcode EQ;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 9;Opcode AND;DUP 1;DUP 2;Opcode EQ;Opcode OR;PUSH 2 (NToWord WLen 0x104%N)] 5 optimize_id).

(*
 I: PUSH [tag] 258 DUP7 CALLER PUSH [tag] 202
 O: PUSH [tag] 258 DUP7 CALLER PUSH [tag] 202
*)
Compute pair "BottleCastle_run_code_of_0_block_229_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x102%N);DUP 7;Opcode CALLER;PUSH 1 (NToWord WLen 0xca%N)] [PUSH 2 (NToWord WLen 0x102%N);DUP 7;Opcode CALLER;PUSH 1 (NToWord WLen 0xca%N)] 6 optimize_id).

(*
 I: PUSH [tag] 260
 O: PUSH [tag] 260
*)
Compute pair "BottleCastle_run_code_of_0_block_230_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x104%N)] [PUSH 2 (NToWord WLen 0x104%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 2CE44B5F PUSH E1 SHL DUP2
 O: PUSH 40 MLOAD PUSH 2ce44b5f PUSH e1 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_231_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x2ce44b5f%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x2CE44B5F%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_231_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP6 AND PUSH [tag] 261
 O: PUSH 1 DUP1 PUSH a0 SHL SUB DUP6 AND PUSH [tag] 261
*)
Compute pair "BottleCastle_run_code_of_0_block_232_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 6;Opcode AND;PUSH 2 (NToWord WLen 0x105%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 6;Opcode AND;PUSH 2 (NToWord WLen 0x105%N)] 5 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 3A954ECD PUSH E2 SHL DUP2
 O: PUSH 40 MLOAD PUSH 3a954ecd PUSH e2 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_233_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x3a954ecd%N);PUSH 1 (NToWord WLen 0xe2%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x3A954ECD%N);PUSH 1 (NToWord WLen 0xE2%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_233_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 264
 O: DUP1 ISZERO PUSH [tag] 264
*)
Compute pair "BottleCastle_run_code_of_0_block_234_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x108%N)] [DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x108%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP3
 O: PUSH 0 DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_235_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3] [PUSH 1 (NToWord WLen 0x0%N);DUP 3] 2 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP7 DUP2 AND PUSH 0 SWAP1 DUP2
 O: PUSH 1 DUP1 PUSH a0 SHL SUB PUSH 0 DUP8 DUP3 AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_236_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 8;DUP 3;Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 7;DUP 2;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] 6 optimize_id).

(*
 I: PUSH 5 PUSH 20
 O: PUSH 5 PUSH 20
*)
Compute pair "BottleCastle_run_code_of_0_block_236_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 DUP1 DUP3 KECCAK256 DUP1 SLOAD PUSH 0 NOT ADD SWAP1
 O: PUSH 40 DUP1 DUP3 KECCAK256 DUP1 SLOAD PUSH 0 NOT ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_236_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;DUP 3;Opcode KECCAK256;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;Opcode ADD;DUP 1] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;DUP 3;Opcode KECCAK256;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;Opcode ADD;DUP 1] 1 optimize_id).

(*
 I: SWAP2 DUP8 AND DUP1 DUP3
 O: SWAP2 DUP8 AND DUP1 DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_236_3"%string (equiv_checker [DUP 2;DUP 8;Opcode AND;DUP 1;DUP 3] [DUP 2;DUP 8;Opcode AND;DUP 1;DUP 3] 8 optimize_id).

(*
 I: SWAP2 SWAP1 KECCAK256 DUP1 SLOAD PUSH 1 ADD SWAP1
 O: SWAP2 SWAP1 KECCAK256 DUP1 SLOAD PUSH 1 ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_236_4"%string (equiv_checker [DUP 2;DUP 1;Opcode KECCAK256;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1] [DUP 2;DUP 1;Opcode KECCAK256;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1] 3 optimize_id).

(*
 I: TIMESTAMP PUSH A0 SHL OR PUSH 1 PUSH E1 SHL OR PUSH 0 DUP6 DUP2
 O: TIMESTAMP PUSH a0 SHL OR PUSH 1 PUSH e1 SHL OR PUSH 0 DUP6 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_236_5"%string (equiv_checker [Opcode TIMESTAMP;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode OR;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;Opcode OR;PUSH 1 (NToWord WLen 0x0%N);DUP 6;DUP 2] [Opcode TIMESTAMP;PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode OR;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;Opcode OR;PUSH 1 (NToWord WLen 0x0%N);DUP 6;DUP 2] 5 optimize_id).

(*
 I: PUSH 4 PUSH 20
 O: PUSH 4 PUSH 20
*)
Compute pair "BottleCastle_run_code_of_0_block_236_6"%string (equiv_checker [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256
 O: PUSH 40 SWAP1 KECCAK256
*)
Compute pair "BottleCastle_run_code_of_0_block_236_7"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256] 1 optimize_id).

(*
 I: PUSH 1 PUSH E1 SHL DUP4 AND PUSH [tag] 269
 O: DUP3 PUSH 1 PUSH e1 SHL AND PUSH [tag] 269
*)
Compute pair "BottleCastle_run_code_of_0_block_236_8"%string (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;Opcode AND;PUSH 2 (NToWord WLen 0x10d%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;DUP 4;Opcode AND;PUSH 2 (NToWord WLen 0x10d%N)] 3 optimize_id).

(*
 I: PUSH 1 DUP5 ADD PUSH 0 DUP2 DUP2
 O: DUP4 PUSH 1 ADD PUSH 0 DUP2 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_237_0"%string (equiv_checker [DUP 4;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] [PUSH 1 (NToWord WLen 0x1%N);DUP 5;Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] 4 optimize_id).

(*
 I: PUSH 4 PUSH 20
 O: PUSH 4 PUSH 20
*)
Compute pair "BottleCastle_run_code_of_0_block_237_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH [tag] 271
 O: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH [tag] 271
*)
Compute pair "BottleCastle_run_code_of_0_block_237_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 2 (NToWord WLen 0x10f%N)] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 2 (NToWord WLen 0x10f%N)] 1 optimize_id).

(*
 I: PUSH 0 SLOAD DUP2 EQ PUSH [tag] 271
 O: DUP1 PUSH 0 SLOAD EQ PUSH [tag] 271
*)
Compute pair "BottleCastle_run_code_of_0_block_238_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;Opcode EQ;PUSH 2 (NToWord WLen 0x10f%N)] [PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 2;Opcode EQ;PUSH 2 (NToWord WLen 0x10f%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP2 DUP2
 O: PUSH 0 DUP2 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_239_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] 1 optimize_id).

(*
 I: PUSH 4 PUSH 20
 O: PUSH 4 PUSH 20
*)
Compute pair "BottleCastle_run_code_of_0_block_239_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 DUP5 SWAP1
 O: PUSH 40 DUP6 SWAP2 KECCAK256
*)
Compute pair "BottleCastle_run_code_of_0_block_239_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 6;DUP 2;Opcode KECCAK256] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;DUP 5;DUP 1] 5 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_240_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: POP POP POP POP POP POP
 O: POP POP POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_241_1"%string (equiv_checker [POP;POP;POP;POP;POP;POP] [POP;POP;POP;POP;POP;POP] 6 optimize_id).

(*
 I: PUSH [tag] 275 PUSH [tag] 219
 O: PUSH [tag] 275 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_242_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x113%N);PUSH 1 (NToWord WLen 0xdb%N)] [PUSH 2 (NToWord WLen 0x113%N);PUSH 1 (NToWord WLen 0xdb%N)] 0 optimize_id).

(*
 I: PUSH 2 PUSH 9 SLOAD EQ ISZERO PUSH [tag] 277
 O: PUSH 2 PUSH 9 SLOAD EQ ISZERO PUSH [tag] 277
*)
Compute pair "BottleCastle_run_code_of_0_block_243_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0x9%N);Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x115%N)] [PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0x9%N);Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x115%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 461BCD PUSH E5 SHL DUP2
 O: PUSH 40 MLOAD PUSH 461bcd PUSH e5 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_244_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461bcd%N);PUSH 1 (NToWord WLen 0xe5%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461BCD%N);PUSH 1 (NToWord WLen 0xE5%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 278 SWAP1 PUSH [tag] 279
 O: PUSH [tag] 278 SWAP1 PUSH 4 ADD PUSH [tag] 279
*)
Compute pair "BottleCastle_run_code_of_0_block_244_1"%string (equiv_checker [PUSH 2 (NToWord WLen 0x116%N);DUP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x117%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N);DUP 1;PUSH 2 (NToWord WLen 0x117%N)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_245_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 2 PUSH 9
 O: PUSH 2 PUSH 9
*)
Compute pair "BottleCastle_run_code_of_0_block_246_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0x9%N)] [PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0x9%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD SELFBALANCE SWAP1 CALLER SWAP1 DUP3 ISZERO PUSH 8FC MUL SWAP1 DUP4 SWAP1 PUSH 0 DUP2 DUP2 DUP2 DUP6 DUP9 DUP9
 O: SELFBALANCE CALLER SELFBALANCE ISZERO PUSH 8fc MUL DUP3 PUSH 40 MLOAD PUSH 0 DUP2 DUP2 DUP4 DUP9 DUP9 DUP9
*)
Compute pair "BottleCastle_run_code_of_0_block_246_1"%string (equiv_checker [Opcode SELFBALANCE;Opcode CALLER;Opcode SELFBALANCE;Opcode ISZERO;PUSH 2 (NToWord WLen 0x8fc%N);Opcode MUL;DUP 3;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2;DUP 4;DUP 9;DUP 9;DUP 9] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;Opcode SELFBALANCE;DUP 1;Opcode CALLER;DUP 1;DUP 3;Opcode ISZERO;PUSH 2 (NToWord WLen 0x8FC%N);Opcode MUL;DUP 1;DUP 4;DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2;DUP 2;DUP 6;DUP 9;DUP 9] 0 optimize_id).

(*
 I: SWAP4 POP POP POP POP ISZERO DUP1 ISZERO PUSH [tag] 283
 O: SWAP4 POP POP POP POP ISZERO DUP1 ISZERO PUSH [tag] 283
*)
Compute pair "BottleCastle_run_code_of_0_block_246_2"%string (equiv_checker [DUP 4;POP;POP;POP;POP;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x11b%N)] [DUP 4;POP;POP;POP;POP;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x11b%N)] 5 optimize_id).

(*
 I: RETURNDATASIZE PUSH 0 DUP1
 O: RETURNDATASIZE PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_247_0"%string (equiv_checker [Opcode RETURNDATASIZE;PUSH 1 (NToWord WLen 0x0%N);DUP 1] [Opcode RETURNDATASIZE;PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: RETURNDATASIZE PUSH 0
 O: RETURNDATASIZE PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_247_1"%string (equiv_checker [Opcode RETURNDATASIZE;PUSH 1 (NToWord WLen 0x0%N)] [Opcode RETURNDATASIZE;PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: POP POP PUSH 1 PUSH 9
 O: POP POP PUSH 1 PUSH 9
*)
Compute pair "BottleCastle_run_code_of_0_block_248_0"%string (equiv_checker [POP;POP;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x9%N)] [POP;POP;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x9%N)] 2 optimize_id).

(*
 I: PUSH [tag] 285 DUP4 DUP4 DUP4 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH [tag] 285 DUP4 DUP4 DUP4 PUSH 40 MLOAD PUSH 20 DUP2 ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_249_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x11d%N);DUP 4;DUP 4;DUP 4;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [PUSH 2 (NToWord WLen 0x11d%N);DUP 4;DUP 4;DUP 4;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 3 optimize_id).

(*
 I: DUP1 PUSH 0 DUP2
 O: DUP1 PUSH 0 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_249_1"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 2] [DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 2] 1 optimize_id).

(*
 I: POP PUSH [tag] 164
 O: POP PUSH [tag] 164
*)
Compute pair "BottleCastle_run_code_of_0_block_249_2"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0xa4%N)] [POP;PUSH 1 (NToWord WLen 0xa4%N)] 1 optimize_id).

(*
 I: POP POP POP
 O: POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_250_0"%string (equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id).

(*
 I: PUSH [tag] 287 PUSH [tag] 219
 O: PUSH [tag] 287 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_251_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x11f%N);PUSH 1 (NToWord WLen 0xdb%N)] [PUSH 2 (NToWord WLen 0x11f%N);PUSH 1 (NToWord WLen 0xdb%N)] 0 optimize_id).

(*
 I: PUSH D
 O: PUSH d
*)
Compute pair "BottleCastle_run_code_of_0_block_252_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xd%N)] [PUSH 1 (NToWord WLen 0xD%N)] 0 optimize_id).

(*
 I: PUSH [tag] 290 PUSH [tag] 219
 O: PUSH [tag] 290 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_253_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x122%N);PUSH 1 (NToWord WLen 0xdb%N)] [PUSH 2 (NToWord WLen 0x122%N);PUSH 1 (NToWord WLen 0xdb%N)] 0 optimize_id).

(*
 I: DUP1 MLOAD PUSH [tag] 292 SWAP1 PUSH A SWAP1 PUSH 20 DUP5 ADD SWAP1 PUSH [tag] 293
 O: PUSH [tag] 292 PUSH a PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 293
*)
Compute pair "BottleCastle_run_code_of_0_block_254_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x124%N);PUSH 1 (NToWord WLen 0xa%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 2 (NToWord WLen 0x125%N)] [DUP 1;Opcode MLOAD;PUSH 2 (NToWord WLen 0x124%N);DUP 1;PUSH 1 (NToWord WLen 0xA%N);DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;DUP 1;PUSH 2 (NToWord WLen 0x125%N)] 1 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_255_0"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 216 DUP3 PUSH [tag] 250
 O: PUSH 0 PUSH [tag] 216 DUP3 PUSH [tag] 250
*)
Compute pair "BottleCastle_run_code_of_0_block_256_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0xd8%N);DUP 3;PUSH 1 (NToWord WLen 0xfa%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0xd8%N);DUP 3;PUSH 1 (NToWord WLen 0xfa%N)] 1 optimize_id).

(*
 I: PUSH A DUP1 SLOAD PUSH [tag] 232 SWAP1 PUSH [tag] 223
 O: PUSH a PUSH [tag] 232 DUP2 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_257_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xa%N);PUSH 1 (NToWord WLen 0xe8%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0xA%N);DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xe8%N);DUP 1;PUSH 1 (NToWord WLen 0xdf%N)] 0 optimize_id).

(*
 I: PUSH 0 PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP3 AND PUSH [tag] 302
 O: PUSH 0 PUSH 1 DUP1 PUSH a0 SHL SUB DUP3 AND PUSH [tag] 302
*)
Compute pair "BottleCastle_run_code_of_0_block_258_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 3;Opcode AND;PUSH 2 (NToWord WLen 0x12e%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 3;Opcode AND;PUSH 2 (NToWord WLen 0x12e%N)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 23D3AD81 PUSH E2 SHL DUP2
 O: PUSH 40 MLOAD PUSH 23d3ad81 PUSH e2 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_259_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x23d3ad81%N);PUSH 1 (NToWord WLen 0xe2%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x23D3AD81%N);PUSH 1 (NToWord WLen 0xE2%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_259_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: POP PUSH 1 PUSH 1 PUSH A0 SHL SUB AND PUSH 0 SWAP1 DUP2
 O: POP PUSH 1 DUP1 PUSH a0 SHL SUB PUSH 0 SWAP2 AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_260_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode AND;DUP 2] [POP;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 5 PUSH 20
 O: PUSH 5 PUSH 20
*)
Compute pair "BottleCastle_run_code_of_0_block_260_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH FFFFFFFFFFFFFFFF AND SWAP1
 O: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH ffffffffffffffff AND SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_260_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);Opcode AND;DUP 1] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 1] 2 optimize_id).

(*
 I: PUSH [tag] 304 PUSH [tag] 219
 O: PUSH [tag] 304 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_261_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x130%N);PUSH 1 (NToWord WLen 0xdb%N)] [PUSH 2 (NToWord WLen 0x130%N);PUSH 1 (NToWord WLen 0xdb%N)] 0 optimize_id).

(*
 I: PUSH [tag] 306 PUSH 0 PUSH [tag] 307
 O: PUSH [tag] 306 PUSH 0 PUSH [tag] 307
*)
Compute pair "BottleCastle_run_code_of_0_block_262_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x132%N);PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x133%N)] [PUSH 2 (NToWord WLen 0x132%N);PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x133%N)] 0 optimize_id).

(*
 I: PUSH 60 PUSH 0 DUP1 PUSH 0 PUSH [tag] 309 DUP6 PUSH [tag] 129
 O: PUSH 60 PUSH 0 DUP1 DUP1 PUSH [tag] 309 DUP6 PUSH [tag] 129
*)
Compute pair "BottleCastle_run_code_of_0_block_264_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 1;PUSH 2 (NToWord WLen 0x135%N);DUP 6;PUSH 1 (NToWord WLen 0x81%N)] [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x135%N);DUP 6;PUSH 1 (NToWord WLen 0x81%N)] 1 optimize_id).

(*
 I: SWAP1 POP PUSH 0 DUP2 PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 311
 O: SWAP1 POP PUSH 0 DUP2 PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 311
*)
Compute pair "BottleCastle_run_code_of_0_block_265_0"%string (equiv_checker [DUP 1;POP;PUSH 1 (NToWord WLen 0x0%N);DUP 2;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x137%N)] [DUP 1;POP;PUSH 1 (NToWord WLen 0x0%N);DUP 2;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x137%N)] 2 optimize_id).

(*
 I: PUSH [tag] 311 PUSH [tag] 312
 O: PUSH [tag] 311 PUSH [tag] 312
*)
Compute pair "BottleCastle_run_code_of_0_block_266_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x137%N);PUSH 2 (NToWord WLen 0x138%N)] [PUSH 2 (NToWord WLen 0x137%N);PUSH 2 (NToWord WLen 0x138%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD SWAP1 DUP1 DUP3
 O: DUP1 PUSH 40 MLOAD SWAP2 DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_267_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 2;DUP 3] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 1;DUP 3] 1 optimize_id).

(*
 I: DUP1 PUSH 20 MUL PUSH 20 ADD DUP3 ADD PUSH 40
 O: PUSH 20 DUP1 DUP3 MUL ADD DUP3 ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_267_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 3;Opcode MUL;Opcode ADD;DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode MUL;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 2 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 313
 O: DUP1 ISZERO PUSH [tag] 313
*)
Compute pair "BottleCastle_run_code_of_0_block_267_2"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x139%N)] [DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x139%N)] 1 optimize_id).

(*
 I: DUP2 PUSH 20 ADD PUSH 20 DUP3 MUL DUP1 CALLDATASIZE DUP4
 O: PUSH 20 DUP3 ADD DUP2 PUSH 20 MUL DUP1 CALLDATASIZE DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_268_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode MUL;DUP 1;Opcode CALLDATASIZE;DUP 4] [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode MUL;DUP 1;Opcode CALLDATASIZE;DUP 4] 2 optimize_id).

(*
 I: ADD SWAP1 POP
 O: ADD SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_268_1"%string (equiv_checker [Opcode ADD;DUP 1;POP] [Opcode ADD;DUP 1;POP] 3 optimize_id).

(*
 I: POP SWAP1 POP PUSH [tag] 314 PUSH 40 DUP1 MLOAD PUSH 80 DUP2 ADD DUP3
 O: POP SWAP1 POP PUSH [tag] 314 PUSH 40 DUP1 MLOAD PUSH 80 DUP2 ADD DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_269_0"%string (equiv_checker [POP;DUP 1;POP;PUSH 2 (NToWord WLen 0x13a%N);PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x80%N);DUP 2;Opcode ADD;DUP 3] [POP;DUP 1;POP;PUSH 2 (NToWord WLen 0x13a%N);PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x80%N);DUP 2;Opcode ADD;DUP 3] 3 optimize_id).

(*
 I: PUSH 0 DUP1 DUP3
 O: PUSH 0 DUP1 DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_269_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 3] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 3] 1 optimize_id).

(*
 I: PUSH 20 DUP3 ADD DUP2 SWAP1
 O: DUP1 PUSH 20 DUP4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_269_2"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;DUP 2;DUP 1] 2 optimize_id).

(*
 I: SWAP2 DUP2 ADD DUP3 SWAP1
 O: DUP1 SWAP3 DUP3 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_269_3"%string (equiv_checker [DUP 1;DUP 3;DUP 3;Opcode ADD] [DUP 2;DUP 2;Opcode ADD;DUP 3;DUP 1] 3 optimize_id).

(*
 I: PUSH 60 DUP2 ADD SWAP2 SWAP1 SWAP2
 O: SWAP1 DUP2 PUSH 60 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_269_4"%string (equiv_checker [DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x60%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x60%N);DUP 2;Opcode ADD;DUP 2;DUP 1;DUP 2] 2 optimize_id).

(*
 I: SWAP1
 O: SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_269_5"%string (equiv_checker [DUP 1] [DUP 1] 2 optimize_id).

(*
 I: PUSH 1
 O: PUSH 1
*)
Compute pair "BottleCastle_run_code_of_0_block_270_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N)] [PUSH 1 (NToWord WLen 0x1%N)] 0 optimize_id).

(*
 I: DUP4 DUP7 EQ PUSH [tag] 317
 O: DUP4 DUP7 EQ PUSH [tag] 317
*)
Compute pair "BottleCastle_run_code_of_0_block_271_0"%string (equiv_checker [DUP 4;DUP 7;Opcode EQ;PUSH 2 (NToWord WLen 0x13d%N)] [DUP 4;DUP 7;Opcode EQ;PUSH 2 (NToWord WLen 0x13d%N)] 6 optimize_id).

(*
 I: PUSH [tag] 320 DUP2 PUSH [tag] 321
 O: PUSH [tag] 320 DUP2 PUSH [tag] 321
*)
Compute pair "BottleCastle_run_code_of_0_block_272_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x140%N);DUP 2;PUSH 2 (NToWord WLen 0x141%N)] [PUSH 2 (NToWord WLen 0x140%N);DUP 2;PUSH 2 (NToWord WLen 0x141%N)] 1 optimize_id).

(*
 I: SWAP2 POP DUP2 PUSH 40 ADD MLOAD ISZERO PUSH [tag] 322
 O: SWAP2 POP PUSH 40 DUP3 ADD MLOAD ISZERO PUSH [tag] 322
*)
Compute pair "BottleCastle_run_code_of_0_block_273_0"%string (equiv_checker [DUP 2;POP;PUSH 1 (NToWord WLen 0x40%N);DUP 3;Opcode ADD;Opcode MLOAD;Opcode ISZERO;PUSH 2 (NToWord WLen 0x142%N)] [DUP 2;POP;DUP 2;PUSH 1 (NToWord WLen 0x40%N);Opcode ADD;Opcode MLOAD;Opcode ISZERO;PUSH 2 (NToWord WLen 0x142%N)] 3 optimize_id).

(*
 I: PUSH [tag] 324
 O: PUSH [tag] 324
*)
Compute pair "BottleCastle_run_code_of_0_block_274_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x144%N)] [PUSH 2 (NToWord WLen 0x144%N)] 0 optimize_id).

(*
 I: DUP2 MLOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB AND ISZERO PUSH [tag] 323
 O: DUP2 MLOAD PUSH 1 DUP1 PUSH a0 SHL SUB AND ISZERO PUSH [tag] 323
*)
Compute pair "BottleCastle_run_code_of_0_block_275_0"%string (equiv_checker [DUP 2;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode ISZERO;PUSH 2 (NToWord WLen 0x143%N)] [DUP 2;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode ISZERO;PUSH 2 (NToWord WLen 0x143%N)] 2 optimize_id).

(*
 I: DUP2 MLOAD SWAP5 POP
 O: DUP2 MLOAD SWAP5 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_276_0"%string (equiv_checker [DUP 2;Opcode MLOAD;DUP 5;POP] [DUP 2;Opcode MLOAD;DUP 5;POP] 5 optimize_id).

(*
 I: DUP8 PUSH 1 PUSH 1 PUSH A0 SHL SUB AND DUP6 PUSH 1 PUSH 1 PUSH A0 SHL SUB AND EQ ISZERO PUSH [tag] 324
 O: DUP8 PUSH 1 DUP1 PUSH a0 SHL SUB DUP1 DUP8 AND SWAP2 AND EQ ISZERO PUSH [tag] 324
*)
Compute pair "BottleCastle_run_code_of_0_block_277_0"%string (equiv_checker [DUP 8;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 1;DUP 8;Opcode AND;DUP 2;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x144%N)] [DUP 8;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;DUP 6;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x144%N)] 8 optimize_id).

(*
 I: DUP1 DUP4 DUP8 DUP1 PUSH 1 ADD SWAP9 POP DUP2 MLOAD DUP2 LT PUSH [tag] 326
 O: DUP1 DUP4 PUSH 1 DUP9 ADD SWAP8 DUP2 MLOAD DUP2 LT PUSH [tag] 326
*)
Compute pair "BottleCastle_run_code_of_0_block_278_0"%string (equiv_checker [DUP 1;DUP 4;PUSH 1 (NToWord WLen 0x1%N);DUP 9;Opcode ADD;DUP 8;DUP 2;Opcode MLOAD;DUP 2;Opcode LT;PUSH 2 (NToWord WLen 0x146%N)] [DUP 1;DUP 4;DUP 8;DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 9;POP;DUP 2;Opcode MLOAD;DUP 2;Opcode LT;PUSH 2 (NToWord WLen 0x146%N)] 6 optimize_id).

(*
 I: PUSH [tag] 326 PUSH [tag] 327
 O: PUSH [tag] 326 PUSH [tag] 327
*)
Compute pair "BottleCastle_run_code_of_0_block_279_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x146%N);PUSH 2 (NToWord WLen 0x147%N)] [PUSH 2 (NToWord WLen 0x146%N);PUSH 2 (NToWord WLen 0x147%N)] 0 optimize_id).

(*
 I: PUSH 20 MUL PUSH 20 ADD ADD DUP2 DUP2
 O: PUSH 20 MUL PUSH 20 ADD ADD DUP2 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_280_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode MUL;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;Opcode ADD;DUP 2;DUP 2] [PUSH 1 (NToWord WLen 0x20%N);Opcode MUL;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;Opcode ADD;DUP 2;DUP 2] 3 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_280_1"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH 1 ADD PUSH [tag] 316
 O: PUSH 1 ADD PUSH [tag] 316
*)
Compute pair "BottleCastle_run_code_of_0_block_281_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 2 (NToWord WLen 0x13c%N)] [PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 2 (NToWord WLen 0x13c%N)] 1 optimize_id).

(*
 I: POP SWAP1 SWAP7 SWAP6 POP POP POP POP POP POP
 O: POP POP SWAP6 SWAP5 POP POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_282_0"%string (equiv_checker [POP;POP;DUP 6;DUP 5;POP;POP;POP;POP;POP] [POP;DUP 1;DUP 7;DUP 6;POP;POP;POP;POP;POP;POP] 9 optimize_id).

(*
 I: PUSH [tag] 330 PUSH [tag] 219
 O: PUSH [tag] 330 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_283_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x14a%N);PUSH 1 (NToWord WLen 0xdb%N)] [PUSH 2 (NToWord WLen 0x14a%N);PUSH 1 (NToWord WLen 0xdb%N)] 0 optimize_id).

(*
 I: PUSH 10 DUP1 SLOAD SWAP2 ISZERO ISZERO PUSH 100 MUL PUSH FF00 NOT SWAP1 SWAP3 AND SWAP2 SWAP1 SWAP2 OR SWAP1
 O: ISZERO ISZERO PUSH 100 MUL PUSH ff00 NOT PUSH 10 SLOAD AND OR PUSH 10
*)
Compute pair "BottleCastle_run_code_of_0_block_284_0"%string (equiv_checker [Opcode ISZERO;Opcode ISZERO;PUSH 2 (NToWord WLen 0x100%N);Opcode MUL;PUSH 2 (NToWord WLen 0xff00%N);Opcode NOT;PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;Opcode AND;Opcode OR;PUSH 1 (NToWord WLen 0x10%N)] [PUSH 1 (NToWord WLen 0x10%N);DUP 1;Opcode SLOAD;DUP 2;Opcode ISZERO;Opcode ISZERO;PUSH 2 (NToWord WLen 0x100%N);Opcode MUL;PUSH 2 (NToWord WLen 0xFF00%N);Opcode NOT;DUP 1;DUP 3;Opcode AND;DUP 2;DUP 1;DUP 2;Opcode OR;DUP 1] 1 optimize_id).

(*
 I: PUSH 60 PUSH 3 DUP1 SLOAD PUSH [tag] 222 SWAP1 PUSH [tag] 223
 O: PUSH 60 PUSH 3 PUSH [tag] 222 DUP2 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_285_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x3%N);PUSH 1 (NToWord WLen 0xde%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x3%N);DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xde%N);DUP 1;PUSH 1 (NToWord WLen 0xdf%N)] 0 optimize_id).

(*
 I: PUSH 2 PUSH 9 SLOAD EQ ISZERO PUSH [tag] 339
 O: PUSH 2 PUSH 9 SLOAD EQ ISZERO PUSH [tag] 339
*)
Compute pair "BottleCastle_run_code_of_0_block_286_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0x9%N);Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x153%N)] [PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0x9%N);Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x153%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 461BCD PUSH E5 SHL DUP2
 O: PUSH 40 MLOAD PUSH 461bcd PUSH e5 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_287_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461bcd%N);PUSH 1 (NToWord WLen 0xe5%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461BCD%N);PUSH 1 (NToWord WLen 0xE5%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 278 SWAP1 PUSH [tag] 279
 O: PUSH [tag] 278 SWAP1 PUSH 4 ADD PUSH [tag] 279
*)
Compute pair "BottleCastle_run_code_of_0_block_287_1"%string (equiv_checker [PUSH 2 (NToWord WLen 0x116%N);DUP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x117%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N);DUP 1;PUSH 2 (NToWord WLen 0x117%N)] 1 optimize_id).

(*
 I: PUSH 2 PUSH 9
 O: PUSH 2 PUSH 9
*)
Compute pair "BottleCastle_run_code_of_0_block_288_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0x9%N)] [PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0x9%N)] 0 optimize_id).

(*
 I: PUSH 10 SLOAD PUSH FF AND ISZERO PUSH [tag] 342
 O: PUSH ff PUSH 10 SLOAD AND ISZERO PUSH [tag] 342
*)
Compute pair "BottleCastle_run_code_of_0_block_288_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0xff%N);PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;Opcode AND;Opcode ISZERO;PUSH 2 (NToWord WLen 0x156%N)] [PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0xFF%N);Opcode AND;Opcode ISZERO;PUSH 2 (NToWord WLen 0x156%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 461BCD PUSH E5 SHL DUP2
 O: PUSH 40 MLOAD PUSH 461bcd PUSH e5 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_289_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461bcd%N);PUSH 1 (NToWord WLen 0xe5%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461BCD%N);PUSH 1 (NToWord WLen 0xE5%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 20 PUSH 4 DUP3 ADD
 O: PUSH 20 DUP2 PUSH 4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_289_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x4%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 17 PUSH 24 DUP3 ADD
 O: PUSH 17 DUP2 PUSH 24 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_289_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x17%N);DUP 2;PUSH 1 (NToWord WLen 0x24%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x17%N);PUSH 1 (NToWord WLen 0x24%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 6F6F707320636F6E747261637420697320706175736564000000000000000000 PUSH 44 DUP3 ADD
 O: PUSH 6f6f707320636f6e747261637420697320706175736564000000000000000000 DUP2 PUSH 44 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_289_3"%string (equiv_checker [PUSH 32 (NToWord WLen 0x6f6f707320636f6e747261637420697320706175736564000000000000000000%N);DUP 2;PUSH 1 (NToWord WLen 0x44%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x6F6F707320636F6E747261637420697320706175736564000000000000000000%N);PUSH 1 (NToWord WLen 0x44%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 64 ADD PUSH [tag] 278
 O: PUSH 64 ADD PUSH [tag] 278
*)
Compute pair "BottleCastle_run_code_of_0_block_289_4"%string (equiv_checker [PUSH 1 (NToWord WLen 0x64%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N)] [PUSH 1 (NToWord WLen 0x64%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N)] 1 optimize_id).

(*
 I: PUSH F SLOAD DUP2 GT ISZERO PUSH [tag] 345
 O: PUSH f SLOAD DUP2 GT ISZERO PUSH [tag] 345
*)
Compute pair "BottleCastle_run_code_of_0_block_290_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xf%N);Opcode SLOAD;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x159%N)] [PUSH 1 (NToWord WLen 0xF%N);Opcode SLOAD;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x159%N)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 461BCD PUSH E5 SHL DUP2
 O: PUSH 40 MLOAD PUSH 461bcd PUSH e5 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_291_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461bcd%N);PUSH 1 (NToWord WLen 0xe5%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461BCD%N);PUSH 1 (NToWord WLen 0xE5%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 20 PUSH 4 DUP3 ADD
 O: PUSH 20 DUP2 PUSH 4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_291_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x4%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 1F PUSH 24 DUP3 ADD
 O: PUSH 1f DUP2 PUSH 24 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_291_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);DUP 2;PUSH 1 (NToWord WLen 0x24%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x1F%N);PUSH 1 (NToWord WLen 0x24%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 6D6178206D696E7420616D6F756E742070657220747820657863656564656400 PUSH 44 DUP3 ADD
 O: PUSH 6d6178206d696e7420616d6f756e742070657220747820657863656564656400 DUP2 PUSH 44 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_291_3"%string (equiv_checker [PUSH 32 (NToWord WLen 0x6d6178206d696e7420616d6f756e742070657220747820657863656564656400%N);DUP 2;PUSH 1 (NToWord WLen 0x44%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x6D6178206D696E7420616D6F756E742070657220747820657863656564656400%N);PUSH 1 (NToWord WLen 0x44%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 64 ADD PUSH [tag] 278
 O: PUSH 64 ADD PUSH [tag] 278
*)
Compute pair "BottleCastle_run_code_of_0_block_291_4"%string (equiv_checker [PUSH 1 (NToWord WLen 0x64%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N)] [PUSH 1 (NToWord WLen 0x64%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N)] 1 optimize_id).

(*
 I: PUSH E SLOAD PUSH 1 SLOAD PUSH 0 SLOAD DUP4 SWAP2 SWAP1 SUB PUSH 0 NOT ADD PUSH [tag] 349 SWAP2 SWAP1 PUSH [tag] 350
 O: PUSH 0 PUSH [tag] 349 DUP3 PUSH 1 SLOAD DUP4 SLOAD SUB PUSH e SLOAD SWAP4 NOT ADD PUSH [tag] 350
*)
Compute pair "BottleCastle_run_code_of_0_block_292_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x15d%N);DUP 3;PUSH 1 (NToWord WLen 0x1%N);Opcode SLOAD;DUP 4;Opcode SLOAD;Opcode SUB;PUSH 1 (NToWord WLen 0xe%N);Opcode SLOAD;DUP 4;Opcode NOT;Opcode ADD;PUSH 2 (NToWord WLen 0x15e%N)] [PUSH 1 (NToWord WLen 0xE%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 4;DUP 2;DUP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;Opcode ADD;PUSH 2 (NToWord WLen 0x15d%N);DUP 2;DUP 1;PUSH 2 (NToWord WLen 0x15e%N)] 1 optimize_id).

(*
 I: GT ISZERO PUSH [tag] 351
 O: GT ISZERO PUSH [tag] 351
*)
Compute pair "BottleCastle_run_code_of_0_block_293_0"%string (equiv_checker [Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x15f%N)] [Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x15f%N)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 461BCD PUSH E5 SHL DUP2
 O: PUSH 40 MLOAD PUSH 461bcd PUSH e5 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_294_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461bcd%N);PUSH 1 (NToWord WLen 0xe5%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461BCD%N);PUSH 1 (NToWord WLen 0xE5%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 20 PUSH 4 DUP3 ADD
 O: PUSH 20 DUP2 PUSH 4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_294_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x4%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH A PUSH 24 DUP3 ADD
 O: PUSH a DUP2 PUSH 24 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_294_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0xa%N);DUP 2;PUSH 1 (NToWord WLen 0x24%N);Opcode ADD] [PUSH 1 (NToWord WLen 0xA%N);PUSH 1 (NToWord WLen 0x24%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 15D94814DBDB191BDD5D PUSH B2 SHL PUSH 44 DUP3 ADD
 O: PUSH 15d94814dbdb191bdd5d PUSH b2 SHL PUSH 44 DUP3 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_294_3"%string (equiv_checker [PUSH 10 (NToWord WLen 0x15d94814dbdb191bdd5d%N);PUSH 1 (NToWord WLen 0xb2%N);Opcode SHL;PUSH 1 (NToWord WLen 0x44%N);DUP 3;Opcode ADD] [PUSH 10 (NToWord WLen 0x15D94814DBDB191BDD5D%N);PUSH 1 (NToWord WLen 0xB2%N);Opcode SHL;PUSH 1 (NToWord WLen 0x44%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 64 ADD PUSH [tag] 278
 O: PUSH 64 ADD PUSH [tag] 278
*)
Compute pair "BottleCastle_run_code_of_0_block_294_4"%string (equiv_checker [PUSH 1 (NToWord WLen 0x64%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N)] [PUSH 1 (NToWord WLen 0x64%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N)] 1 optimize_id).

(*
 I: PUSH F SLOAD CALLER PUSH 0 SWAP1 DUP2
 O: PUSH f SLOAD PUSH 0 CALLER DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_295_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xf%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode CALLER;DUP 2] [PUSH 1 (NToWord WLen 0xF%N);Opcode SLOAD;Opcode CALLER;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] 0 optimize_id).

(*
 I: PUSH 5 PUSH 20
 O: PUSH 5 PUSH 20
*)
Compute pair "BottleCastle_run_code_of_0_block_295_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 DUP2 SWAP1 KECCAK256 SLOAD DUP4 SWAP2 SHR PUSH FFFFFFFFFFFFFFFF AND PUSH [tag] 357 SWAP2 SWAP1 PUSH [tag] 350
 O: PUSH 40 DUP1 PUSH [tag] 357 SWAP3 KECCAK256 SLOAD DUP5 SWAP2 SHR PUSH ffffffffffffffff AND PUSH [tag] 350
*)
Compute pair "BottleCastle_run_code_of_0_block_295_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;PUSH 2 (NToWord WLen 0x165%N);DUP 3;Opcode KECCAK256;Opcode SLOAD;DUP 5;DUP 2;Opcode SHR;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);Opcode AND;PUSH 2 (NToWord WLen 0x15e%N)] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;DUP 2;DUP 1;Opcode KECCAK256;Opcode SLOAD;DUP 4;DUP 2;Opcode SHR;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 2 (NToWord WLen 0x165%N);DUP 2;DUP 1;PUSH 2 (NToWord WLen 0x15e%N)] 3 optimize_id).

(*
 I: GT ISZERO PUSH [tag] 358
 O: GT ISZERO PUSH [tag] 358
*)
Compute pair "BottleCastle_run_code_of_0_block_296_0"%string (equiv_checker [Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x166%N)] [Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x166%N)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 461BCD PUSH E5 SHL DUP2
 O: PUSH 40 MLOAD PUSH 461bcd PUSH e5 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_297_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461bcd%N);PUSH 1 (NToWord WLen 0xe5%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461BCD%N);PUSH 1 (NToWord WLen 0xE5%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 20 PUSH 4 DUP3 ADD
 O: PUSH 20 DUP2 PUSH 4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_297_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x4%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 1B PUSH 24 DUP3 ADD
 O: PUSH 1b DUP2 PUSH 24 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_297_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1b%N);DUP 2;PUSH 1 (NToWord WLen 0x24%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x1B%N);PUSH 1 (NToWord WLen 0x24%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 4D6178204E4654205065722057616C6C65742065786365656465640000000000 PUSH 44 DUP3 ADD
 O: PUSH 4d6178204e4654205065722057616c6c65742065786365656465640000000000 DUP2 PUSH 44 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_297_3"%string (equiv_checker [PUSH 32 (NToWord WLen 0x4d6178204e4654205065722057616c6c65742065786365656465640000000000%N);DUP 2;PUSH 1 (NToWord WLen 0x44%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x4D6178204E4654205065722057616C6C65742065786365656465640000000000%N);PUSH 1 (NToWord WLen 0x44%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 64 ADD PUSH [tag] 278
 O: PUSH 64 ADD PUSH [tag] 278
*)
Compute pair "BottleCastle_run_code_of_0_block_297_4"%string (equiv_checker [PUSH 1 (NToWord WLen 0x64%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N)] [PUSH 1 (NToWord WLen 0x64%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N)] 1 optimize_id).

(*
 I: DUP1 PUSH D SLOAD PUSH [tag] 361 SWAP2 SWAP1 PUSH [tag] 362
 O: PUSH [tag] 361 DUP2 PUSH d SLOAD PUSH [tag] 362
*)
Compute pair "BottleCastle_run_code_of_0_block_298_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x169%N);DUP 2;PUSH 1 (NToWord WLen 0xd%N);Opcode SLOAD;PUSH 2 (NToWord WLen 0x16a%N)] [DUP 1;PUSH 1 (NToWord WLen 0xD%N);Opcode SLOAD;PUSH 2 (NToWord WLen 0x169%N);DUP 2;DUP 1;PUSH 2 (NToWord WLen 0x16a%N)] 1 optimize_id).

(*
 I: CALLVALUE LT ISZERO PUSH [tag] 363
 O: CALLVALUE LT ISZERO PUSH [tag] 363
*)
Compute pair "BottleCastle_run_code_of_0_block_299_0"%string (equiv_checker [Opcode CALLVALUE;Opcode LT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x16b%N)] [Opcode CALLVALUE;Opcode LT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x16b%N)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 461BCD PUSH E5 SHL DUP2
 O: PUSH 40 MLOAD PUSH 461bcd PUSH e5 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_300_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461bcd%N);PUSH 1 (NToWord WLen 0xe5%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461BCD%N);PUSH 1 (NToWord WLen 0xE5%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 20 PUSH 4 DUP3 ADD
 O: PUSH 20 DUP2 PUSH 4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_300_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x4%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 12 PUSH 24 DUP3 ADD
 O: PUSH 12 DUP2 PUSH 24 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_300_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x12%N);DUP 2;PUSH 1 (NToWord WLen 0x24%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x12%N);PUSH 1 (NToWord WLen 0x24%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 696E73756666696369656E742066756E6473 PUSH 70 SHL PUSH 44 DUP3 ADD
 O: PUSH 696e73756666696369656e742066756e6473 PUSH 70 SHL PUSH 44 DUP3 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_300_3"%string (equiv_checker [PUSH 18 (NToWord WLen 0x696e73756666696369656e742066756e6473%N);PUSH 1 (NToWord WLen 0x70%N);Opcode SHL;PUSH 1 (NToWord WLen 0x44%N);DUP 3;Opcode ADD] [PUSH 18 (NToWord WLen 0x696E73756666696369656E742066756E6473%N);PUSH 1 (NToWord WLen 0x70%N);Opcode SHL;PUSH 1 (NToWord WLen 0x44%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 64 ADD PUSH [tag] 278
 O: PUSH 64 ADD PUSH [tag] 278
*)
Compute pair "BottleCastle_run_code_of_0_block_300_4"%string (equiv_checker [PUSH 1 (NToWord WLen 0x64%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N)] [PUSH 1 (NToWord WLen 0x64%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N)] 1 optimize_id).

(*
 I: PUSH [tag] 366 CALLER DUP3 PUSH [tag] 368
 O: PUSH [tag] 366 CALLER DUP3 PUSH [tag] 368
*)
Compute pair "BottleCastle_run_code_of_0_block_301_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x16e%N);Opcode CALLER;DUP 3;PUSH 2 (NToWord WLen 0x170%N)] [PUSH 2 (NToWord WLen 0x16e%N);Opcode CALLER;DUP 3;PUSH 2 (NToWord WLen 0x170%N)] 1 optimize_id).

(*
 I: POP PUSH 1 PUSH 9
 O: POP PUSH 1 PUSH 9
*)
Compute pair "BottleCastle_run_code_of_0_block_302_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x9%N)] [POP;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x9%N)] 1 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP3 AND CALLER EQ ISZERO PUSH [tag] 371
 O: DUP2 PUSH 1 DUP1 PUSH a0 SHL SUB AND CALLER EQ ISZERO PUSH [tag] 371
*)
Compute pair "BottleCastle_run_code_of_0_block_303_0"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode CALLER;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x173%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 3;Opcode AND;Opcode CALLER;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x173%N)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH B06307DB PUSH E0 SHL DUP2
 O: PUSH 40 MLOAD PUSH b06307db PUSH e0 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_304_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0xb06307db%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0xB06307DB%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_304_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLER PUSH 0 DUP2 DUP2
 O: CALLER PUSH 0 DUP2 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_305_0"%string (equiv_checker [Opcode CALLER;PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] [Opcode CALLER;PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] 0 optimize_id).

(*
 I: PUSH 7 PUSH 20 SWAP1 DUP2
 O: PUSH 20 PUSH 7 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_305_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x7%N);DUP 2] [PUSH 1 (NToWord WLen 0x7%N);PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 2] 0 optimize_id).

(*
 I: PUSH 40 DUP1 DUP4 KECCAK256 PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP8 AND DUP1 DUP6
 O: PUSH 40 DUP1 DUP4 KECCAK256 PUSH 1 DUP1 PUSH a0 SHL SUB DUP8 AND DUP1 DUP6
*)
Compute pair "BottleCastle_run_code_of_0_block_305_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;DUP 4;Opcode KECCAK256;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 8;Opcode AND;DUP 1;DUP 6] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;DUP 4;Opcode KECCAK256;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 8;Opcode AND;DUP 1;DUP 6] 5 optimize_id).

(*
 I: SWAP1 DUP4
 O: SWAP1 DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_305_3"%string (equiv_checker [DUP 1;DUP 4] [DUP 1;DUP 4] 4 optimize_id).

(*
 I: SWAP3 DUP2 SWAP1 KECCAK256 DUP1 SLOAD PUSH FF NOT AND DUP7 ISZERO ISZERO SWAP1 DUP2 OR SWAP1 SWAP2
 O: DUP2 DUP7 ISZERO ISZERO SWAP2 SWAP5 KECCAK256 DUP2 PUSH ff NOT DUP3 SLOAD AND OR SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_305_4"%string (equiv_checker [DUP 2;DUP 7;Opcode ISZERO;Opcode ISZERO;DUP 2;DUP 5;Opcode KECCAK256;DUP 2;PUSH 1 (NToWord WLen 0xff%N);Opcode NOT;DUP 3;Opcode SLOAD;Opcode AND;Opcode OR;DUP 1] [DUP 3;DUP 2;DUP 1;Opcode KECCAK256;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xFF%N);Opcode NOT;Opcode AND;DUP 7;Opcode ISZERO;Opcode ISZERO;DUP 1;DUP 2;Opcode OR;DUP 1;DUP 2] 6 optimize_id).

(*
 I: SWAP1 MLOAD SWAP1 DUP2
 O: SWAP1 MLOAD SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_305_5"%string (equiv_checker [DUP 1;Opcode MLOAD;DUP 1;DUP 2] [DUP 1;Opcode MLOAD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: SWAP2 SWAP3 SWAP2 PUSH 17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C31 SWAP2 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: ADD PUSH 40 MLOAD DUP1 SWAP4 SWAP3 SWAP4 SWAP2 SUB PUSH 17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31 SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_305_6"%string (equiv_checker [Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 4;DUP 3;DUP 4;DUP 2;Opcode SUB;PUSH 32 (NToWord WLen 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31%N);DUP 2] [DUP 2;DUP 3;DUP 2;PUSH 32 (NToWord WLen 0x17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C31%N);DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 4 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_305_7"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH [tag] 376 DUP5 DUP5 DUP5 PUSH [tag] 92
 O: PUSH [tag] 376 DUP5 DUP5 DUP5 PUSH [tag] 92
*)
Compute pair "BottleCastle_run_code_of_0_block_306_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x178%N);DUP 5;DUP 5;DUP 5;PUSH 1 (NToWord WLen 0x5c%N)] [PUSH 2 (NToWord WLen 0x178%N);DUP 5;DUP 5;DUP 5;PUSH 1 (NToWord WLen 0x5c%N)] 4 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP4 AND EXTCODESIZE ISZERO PUSH [tag] 380
 O: DUP3 PUSH 1 DUP1 PUSH a0 SHL SUB AND EXTCODESIZE ISZERO PUSH [tag] 380
*)
Compute pair "BottleCastle_run_code_of_0_block_307_0"%string (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode EXTCODESIZE;Opcode ISZERO;PUSH 2 (NToWord WLen 0x17c%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 4;Opcode AND;Opcode EXTCODESIZE;Opcode ISZERO;PUSH 2 (NToWord WLen 0x17c%N)] 3 optimize_id).

(*
 I: PUSH [tag] 378 DUP5 DUP5 DUP5 DUP5 PUSH [tag] 379
 O: PUSH [tag] 378 DUP5 DUP5 DUP5 DUP5 PUSH [tag] 379
*)
Compute pair "BottleCastle_run_code_of_0_block_308_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x17a%N);DUP 5;DUP 5;DUP 5;DUP 5;PUSH 2 (NToWord WLen 0x17b%N)] [PUSH 2 (NToWord WLen 0x17a%N);DUP 5;DUP 5;DUP 5;DUP 5;PUSH 2 (NToWord WLen 0x17b%N)] 4 optimize_id).

(*
 I: PUSH [tag] 380
 O: PUSH [tag] 380
*)
Compute pair "BottleCastle_run_code_of_0_block_309_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x17c%N)] [PUSH 2 (NToWord WLen 0x17c%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 68D2BF6B PUSH E1 SHL DUP2
 O: PUSH 40 MLOAD PUSH 68d2bf6b PUSH e1 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_310_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x68d2bf6b%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x68D2BF6B%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_310_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_311_0"%string (equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id).

(*
 I: PUSH [tag] 382 PUSH [tag] 219
 O: PUSH [tag] 382 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_312_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x17e%N);PUSH 1 (NToWord WLen 0xdb%N)] [PUSH 2 (NToWord WLen 0x17e%N);PUSH 1 (NToWord WLen 0xdb%N)] 0 optimize_id).

(*
 I: PUSH 2 PUSH 9 SLOAD EQ ISZERO PUSH [tag] 384
 O: PUSH 2 PUSH 9 SLOAD EQ ISZERO PUSH [tag] 384
*)
Compute pair "BottleCastle_run_code_of_0_block_313_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0x9%N);Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x180%N)] [PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0x9%N);Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x180%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 461BCD PUSH E5 SHL DUP2
 O: PUSH 40 MLOAD PUSH 461bcd PUSH e5 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_314_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461bcd%N);PUSH 1 (NToWord WLen 0xe5%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461BCD%N);PUSH 1 (NToWord WLen 0xE5%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 278 SWAP1 PUSH [tag] 279
 O: PUSH [tag] 278 SWAP1 PUSH 4 ADD PUSH [tag] 279
*)
Compute pair "BottleCastle_run_code_of_0_block_314_1"%string (equiv_checker [PUSH 2 (NToWord WLen 0x116%N);DUP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x117%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N);DUP 1;PUSH 2 (NToWord WLen 0x117%N)] 1 optimize_id).

(*
 I: PUSH 2 PUSH 9
 O: PUSH 2 PUSH 9
*)
Compute pair "BottleCastle_run_code_of_0_block_315_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0x9%N)] [PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0x9%N)] 0 optimize_id).

(*
 I: PUSH E SLOAD PUSH 1 SLOAD PUSH 0 SLOAD DUP5 SWAP2 SWAP1 SUB PUSH 0 NOT ADD PUSH [tag] 388 SWAP2 SWAP1 PUSH [tag] 350
 O: PUSH e SLOAD PUSH [tag] 388 DUP4 PUSH 1 SLOAD PUSH 0 SLOAD SUB PUSH 0 NOT ADD PUSH [tag] 350
*)
Compute pair "BottleCastle_run_code_of_0_block_315_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0xe%N);Opcode SLOAD;PUSH 2 (NToWord WLen 0x184%N);DUP 4;PUSH 1 (NToWord WLen 0x1%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;Opcode ADD;PUSH 2 (NToWord WLen 0x15e%N)] [PUSH 1 (NToWord WLen 0xE%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 5;DUP 2;DUP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;Opcode ADD;PUSH 2 (NToWord WLen 0x184%N);DUP 2;DUP 1;PUSH 2 (NToWord WLen 0x15e%N)] 2 optimize_id).

(*
 I: GT ISZERO PUSH [tag] 389
 O: GT ISZERO PUSH [tag] 389
*)
Compute pair "BottleCastle_run_code_of_0_block_316_0"%string (equiv_checker [Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x185%N)] [Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x185%N)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 461BCD PUSH E5 SHL DUP2
 O: PUSH 40 MLOAD PUSH 461bcd PUSH e5 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_317_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461bcd%N);PUSH 1 (NToWord WLen 0xe5%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461BCD%N);PUSH 1 (NToWord WLen 0xE5%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 20 PUSH 4 DUP3 ADD
 O: PUSH 20 DUP2 PUSH 4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_317_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x4%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 16 PUSH 24 DUP3 ADD
 O: PUSH 16 DUP2 PUSH 24 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_317_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x16%N);DUP 2;PUSH 1 (NToWord WLen 0x24%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x16%N);PUSH 1 (NToWord WLen 0x24%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 1B585E08139195081B1A5B5A5D08195E18D959591959 PUSH 52 SHL PUSH 44 DUP3 ADD
 O: PUSH 1b585e08139195081b1a5b5a5d08195e18d959591959 PUSH 52 SHL PUSH 44 DUP3 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_317_3"%string (equiv_checker [PUSH 22 (NToWord WLen 0x1b585e08139195081b1a5b5a5d08195e18d959591959%N);PUSH 1 (NToWord WLen 0x52%N);Opcode SHL;PUSH 1 (NToWord WLen 0x44%N);DUP 3;Opcode ADD] [PUSH 22 (NToWord WLen 0x1B585E08139195081B1A5B5A5D08195E18D959591959%N);PUSH 1 (NToWord WLen 0x52%N);Opcode SHL;PUSH 1 (NToWord WLen 0x44%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 64 ADD PUSH [tag] 278
 O: PUSH 64 ADD PUSH [tag] 278
*)
Compute pair "BottleCastle_run_code_of_0_block_317_4"%string (equiv_checker [PUSH 1 (NToWord WLen 0x64%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N)] [PUSH 1 (NToWord WLen 0x64%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N)] 1 optimize_id).

(*
 I: PUSH [tag] 283 DUP2 DUP4 PUSH [tag] 368
 O: PUSH [tag] 283 DUP2 DUP4 PUSH [tag] 368
*)
Compute pair "BottleCastle_run_code_of_0_block_318_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x11b%N);DUP 2;DUP 4;PUSH 2 (NToWord WLen 0x170%N)] [PUSH 2 (NToWord WLen 0x11b%N);DUP 2;DUP 4;PUSH 2 (NToWord WLen 0x170%N)] 2 optimize_id).

(*
 I: PUSH B DUP1 SLOAD PUSH [tag] 232 SWAP1 PUSH [tag] 223
 O: PUSH b PUSH [tag] 232 DUP2 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_319_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xb%N);PUSH 1 (NToWord WLen 0xe8%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0xB%N);DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xe8%N);DUP 1;PUSH 1 (NToWord WLen 0xdf%N)] 0 optimize_id).

(*
 I: PUSH 60 PUSH [tag] 399 DUP3 PUSH [tag] 230
 O: PUSH 60 PUSH [tag] 399 DUP3 PUSH [tag] 230
*)
Compute pair "BottleCastle_run_code_of_0_block_320_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);PUSH 2 (NToWord WLen 0x18f%N);DUP 3;PUSH 1 (NToWord WLen 0xe6%N)] [PUSH 1 (NToWord WLen 0x60%N);PUSH 2 (NToWord WLen 0x18f%N);DUP 3;PUSH 1 (NToWord WLen 0xe6%N)] 1 optimize_id).

(*
 I: PUSH [tag] 400
 O: PUSH [tag] 400
*)
Compute pair "BottleCastle_run_code_of_0_block_321_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x190%N)] [PUSH 2 (NToWord WLen 0x190%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 461BCD PUSH E5 SHL DUP2
 O: PUSH 40 MLOAD PUSH 461bcd PUSH e5 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_322_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461bcd%N);PUSH 1 (NToWord WLen 0xe5%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461BCD%N);PUSH 1 (NToWord WLen 0xE5%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 20 PUSH 4 DUP3 ADD
 O: PUSH 20 DUP2 PUSH 4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_322_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x4%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 30 PUSH 24 DUP3 ADD
 O: PUSH 30 DUP2 PUSH 24 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_322_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x30%N);DUP 2;PUSH 1 (NToWord WLen 0x24%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x30%N);PUSH 1 (NToWord WLen 0x24%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 455243373231414D657461646174613A2055524920717565727920666F72206E PUSH 44 DUP3 ADD
 O: PUSH 455243373231414d657461646174613a2055524920717565727920666f72206e DUP2 PUSH 44 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_322_3"%string (equiv_checker [PUSH 32 (NToWord WLen 0x455243373231414d657461646174613a2055524920717565727920666f72206e%N);DUP 2;PUSH 1 (NToWord WLen 0x44%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x455243373231414D657461646174613A2055524920717565727920666F72206E%N);PUSH 1 (NToWord WLen 0x44%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 37B732BC34B9BA32B73A103A37B5B2B7 PUSH 81 SHL PUSH 64 DUP3 ADD
 O: PUSH 37b732bc34b9ba32b73a103a37b5b2b7 PUSH 81 SHL PUSH 64 DUP3 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_322_4"%string (equiv_checker [PUSH 16 (NToWord WLen 0x37b732bc34b9ba32b73a103a37b5b2b7%N);PUSH 1 (NToWord WLen 0x81%N);Opcode SHL;PUSH 1 (NToWord WLen 0x64%N);DUP 3;Opcode ADD] [PUSH 16 (NToWord WLen 0x37B732BC34B9BA32B73A103A37B5B2B7%N);PUSH 1 (NToWord WLen 0x81%N);Opcode SHL;PUSH 1 (NToWord WLen 0x64%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 84 ADD PUSH [tag] 278
 O: PUSH 84 ADD PUSH [tag] 278
*)
Compute pair "BottleCastle_run_code_of_0_block_322_5"%string (equiv_checker [PUSH 1 (NToWord WLen 0x84%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N)] [PUSH 1 (NToWord WLen 0x84%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N)] 1 optimize_id).

(*
 I: PUSH 10 SLOAD PUSH 100 SWAP1 DIV PUSH FF AND PUSH [tag] 403
 O: PUSH ff PUSH 100 PUSH 10 SLOAD DIV AND PUSH [tag] 403
*)
Compute pair "BottleCastle_run_code_of_0_block_323_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xff%N);PUSH 2 (NToWord WLen 0x100%N);PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;Opcode DIV;Opcode AND;PUSH 2 (NToWord WLen 0x193%N)] [PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;PUSH 2 (NToWord WLen 0x100%N);DUP 1;Opcode DIV;PUSH 1 (NToWord WLen 0xFF%N);Opcode AND;PUSH 2 (NToWord WLen 0x193%N)] 0 optimize_id).

(*
 I: PUSH C DUP1 SLOAD PUSH [tag] 404 SWAP1 PUSH [tag] 223
 O: PUSH c PUSH [tag] 404 DUP2 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_324_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xc%N);PUSH 2 (NToWord WLen 0x194%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0xC%N);DUP 1;Opcode SLOAD;PUSH 2 (NToWord WLen 0x194%N);DUP 1;PUSH 1 (NToWord WLen 0xdf%N)] 0 optimize_id).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_325_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x1f%N);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 1 optimize_id).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute pair "BottleCastle_run_code_of_0_block_325_1"%string (equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 405 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 405 DUP5 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_325_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;PUSH 2 (NToWord WLen 0x195%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (NToWord WLen 0x195%N);DUP 1;PUSH 1 (NToWord WLen 0xdf%N)] 3 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 406
 O: DUP1 ISZERO PUSH [tag] 406
*)
Compute pair "BottleCastle_run_code_of_0_block_326_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x196%N)] [DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x196%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 407
 O: DUP1 PUSH 1f LT PUSH [tag] 407
*)
Compute pair "BottleCastle_run_code_of_0_block_327_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x1f%N);Opcode LT;PUSH 2 (NToWord WLen 0x197%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode LT;PUSH 2 (NToWord WLen 0x197%N)] 1 optimize_id).

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_328_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x100%N);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (NToWord WLen 0x100%N);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 406
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 406
*)
Compute pair "BottleCastle_run_code_of_0_block_328_1"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;PUSH 2 (NToWord WLen 0x196%N)] [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;PUSH 2 (NToWord WLen 0x196%N)] 3 optimize_id).

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_329_0"%string (equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x0%N)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x0%N)] 3 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_329_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 1] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 1] 1 optimize_id).

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_330_0"%string (equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id).

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 408
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 408
*)
Compute pair "BottleCastle_run_code_of_0_block_330_1"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (NToWord WLen 0x198%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (NToWord WLen 0x198%N)] 3 optimize_id).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_331_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x1F%N);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id).

(*
 I: POP POP POP POP POP SWAP1 POP SWAP2 SWAP1 POP
 O: POP POP POP POP POP SWAP2 POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_332_0"%string (equiv_checker [POP;POP;POP;POP;POP;DUP 2;POP;POP;DUP 1] [POP;POP;POP;POP;POP;DUP 1;POP;DUP 2;DUP 1;POP] 9 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 409 PUSH [tag] 410
 O: PUSH 0 PUSH [tag] 409 PUSH [tag] 410
*)
Compute pair "BottleCastle_run_code_of_0_block_333_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x199%N);PUSH 2 (NToWord WLen 0x19a%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x199%N);PUSH 2 (NToWord WLen 0x19a%N)] 0 optimize_id).

(*
 I: SWAP1 POP PUSH 0 DUP2 MLOAD GT PUSH [tag] 411
 O: SWAP1 POP PUSH 0 DUP2 MLOAD GT PUSH [tag] 411
*)
Compute pair "BottleCastle_run_code_of_0_block_334_0"%string (equiv_checker [DUP 1;POP;PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode MLOAD;Opcode GT;PUSH 2 (NToWord WLen 0x19b%N)] [DUP 1;POP;PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode MLOAD;Opcode GT;PUSH 2 (NToWord WLen 0x19b%N)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_335_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 0 optimize_id).

(*
 I: DUP1 PUSH 0 DUP2
 O: DUP1 PUSH 0 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_335_1"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 2] [DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 2] 1 optimize_id).

(*
 I: POP PUSH [tag] 412
 O: POP PUSH [tag] 412
*)
Compute pair "BottleCastle_run_code_of_0_block_335_2"%string (equiv_checker [POP;PUSH 2 (NToWord WLen 0x19c%N)] [POP;PUSH 2 (NToWord WLen 0x19c%N)] 1 optimize_id).

(*
 I: DUP1 PUSH [tag] 413 DUP5 PUSH [tag] 414
 O: DUP1 PUSH [tag] 413 DUP5 PUSH [tag] 414
*)
Compute pair "BottleCastle_run_code_of_0_block_336_0"%string (equiv_checker [DUP 1;PUSH 2 (NToWord WLen 0x19d%N);DUP 5;PUSH 2 (NToWord WLen 0x19e%N)] [DUP 1;PUSH 2 (NToWord WLen 0x19d%N);DUP 5;PUSH 2 (NToWord WLen 0x19e%N)] 3 optimize_id).

(*
 I: PUSH B PUSH 40 MLOAD PUSH 20 ADD PUSH [tag] 415 SWAP4 SWAP3 SWAP2 SWAP1 PUSH [tag] 416
 O: PUSH [tag] 415 SWAP2 SWAP1 PUSH b PUSH 20 PUSH 40 MLOAD ADD PUSH [tag] 416
*)
Compute pair "BottleCastle_run_code_of_0_block_337_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x19f%N);DUP 2;DUP 1;PUSH 1 (NToWord WLen 0xb%N);PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;Opcode ADD;PUSH 2 (NToWord WLen 0x1a0%N)] [PUSH 1 (NToWord WLen 0xB%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x19f%N);DUP 4;DUP 3;DUP 2;DUP 1;PUSH 2 (NToWord WLen 0x1a0%N)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 20 DUP2 DUP4 SUB SUB DUP2
 O: PUSH 40 MLOAD PUSH 20 DUP2 DUP4 SUB SUB DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_338_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);DUP 2;DUP 4;Opcode SUB;Opcode SUB;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);DUP 2;DUP 4;Opcode SUB;Opcode SUB;DUP 2] 1 optimize_id).

(*
 I: SWAP1 PUSH 40
 O: SWAP1 PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_338_1"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x40%N)] 2 optimize_id).

(*
 I: SWAP4 SWAP3 POP POP POP
 O: SWAP4 SWAP3 POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_339_0"%string (equiv_checker [DUP 4;DUP 3;POP;POP;POP] [DUP 4;DUP 3;POP;POP;POP] 5 optimize_id).

(*
 I: PUSH [tag] 418 PUSH [tag] 219
 O: PUSH [tag] 418 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_340_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x1a2%N);PUSH 1 (NToWord WLen 0xdb%N)] [PUSH 2 (NToWord WLen 0x1a2%N);PUSH 1 (NToWord WLen 0xdb%N)] 0 optimize_id).

(*
 I: DUP1 MLOAD PUSH [tag] 292 SWAP1 PUSH B SWAP1 PUSH 20 DUP5 ADD SWAP1 PUSH [tag] 293
 O: PUSH [tag] 292 PUSH b PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 293
*)
Compute pair "BottleCastle_run_code_of_0_block_341_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x124%N);PUSH 1 (NToWord WLen 0xb%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 2 (NToWord WLen 0x125%N)] [DUP 1;Opcode MLOAD;PUSH 2 (NToWord WLen 0x124%N);DUP 1;PUSH 1 (NToWord WLen 0xB%N);DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;DUP 1;PUSH 2 (NToWord WLen 0x125%N)] 1 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP2 AND PUSH 0 SWAP1 DUP2
 O: PUSH 1 DUP1 PUSH a0 SHL SUB DUP2 AND PUSH 0 SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_342_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 2;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 2;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] 1 optimize_id).

(*
 I: PUSH 5 PUSH 20
 O: PUSH 5 PUSH 20
*)
Compute pair "BottleCastle_run_code_of_0_block_342_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 DUP1 DUP3 KECCAK256 SLOAD PUSH FFFFFFFFFFFFFFFF SWAP2 SHR AND PUSH [tag] 216
 O: PUSH ffffffffffffffff PUSH 40 DUP1 DUP4 KECCAK256 SLOAD SWAP1 SHR AND PUSH [tag] 216
*)
Compute pair "BottleCastle_run_code_of_0_block_342_2"%string (equiv_checker [PUSH 8 (NToWord WLen 0xffffffffffffffff%N);PUSH 1 (NToWord WLen 0x40%N);DUP 1;DUP 4;Opcode KECCAK256;Opcode SLOAD;DUP 1;Opcode SHR;Opcode AND;PUSH 1 (NToWord WLen 0xd8%N)] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;DUP 3;Opcode KECCAK256;Opcode SLOAD;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);DUP 2;Opcode SHR;Opcode AND;PUSH 1 (NToWord WLen 0xd8%N)] 1 optimize_id).

(*
 I: PUSH [tag] 424 PUSH [tag] 219
 O: PUSH [tag] 424 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_343_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x1a8%N);PUSH 1 (NToWord WLen 0xdb%N)] [PUSH 2 (NToWord WLen 0x1a8%N);PUSH 1 (NToWord WLen 0xdb%N)] 0 optimize_id).

(*
 I: PUSH F
 O: PUSH f
*)
Compute pair "BottleCastle_run_code_of_0_block_344_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xf%N)] [PUSH 1 (NToWord WLen 0xF%N)] 0 optimize_id).

(*
 I: PUSH [tag] 428 PUSH [tag] 219
 O: PUSH [tag] 428 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_345_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x1ac%N);PUSH 1 (NToWord WLen 0xdb%N)] [PUSH 2 (NToWord WLen 0x1ac%N);PUSH 1 (NToWord WLen 0xdb%N)] 0 optimize_id).

(*
 I: DUP1 MLOAD PUSH [tag] 292 SWAP1 PUSH C SWAP1 PUSH 20 DUP5 ADD SWAP1 PUSH [tag] 293
 O: PUSH [tag] 292 PUSH c PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 293
*)
Compute pair "BottleCastle_run_code_of_0_block_346_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x124%N);PUSH 1 (NToWord WLen 0xc%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 2 (NToWord WLen 0x125%N)] [DUP 1;Opcode MLOAD;PUSH 2 (NToWord WLen 0x124%N);DUP 1;PUSH 1 (NToWord WLen 0xC%N);DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;DUP 1;PUSH 2 (NToWord WLen 0x125%N)] 1 optimize_id).

(*
 I: PUSH [tag] 432 PUSH [tag] 219
 O: PUSH [tag] 432 PUSH [tag] 219
*)
Compute pair "BottleCastle_run_code_of_0_block_347_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x1b0%N);PUSH 1 (NToWord WLen 0xdb%N)] [PUSH 2 (NToWord WLen 0x1b0%N);PUSH 1 (NToWord WLen 0xdb%N)] 0 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP2 AND PUSH [tag] 434
 O: PUSH 1 DUP1 PUSH a0 SHL SUB DUP2 AND PUSH [tag] 434
*)
Compute pair "BottleCastle_run_code_of_0_block_348_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 2;Opcode AND;PUSH 2 (NToWord WLen 0x1b2%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 2;Opcode AND;PUSH 2 (NToWord WLen 0x1b2%N)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 461BCD PUSH E5 SHL DUP2
 O: PUSH 40 MLOAD PUSH 461bcd PUSH e5 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_349_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461bcd%N);PUSH 1 (NToWord WLen 0xe5%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461BCD%N);PUSH 1 (NToWord WLen 0xE5%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 20 PUSH 4 DUP3 ADD
 O: PUSH 20 DUP2 PUSH 4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_349_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x4%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 26 PUSH 24 DUP3 ADD
 O: PUSH 26 DUP2 PUSH 24 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_349_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x26%N);DUP 2;PUSH 1 (NToWord WLen 0x24%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x26%N);PUSH 1 (NToWord WLen 0x24%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 4F776E61626C653A206E6577206F776E657220697320746865207A65726F2061 PUSH 44 DUP3 ADD
 O: PUSH 4f776e61626c653a206e6577206f776e657220697320746865207a65726f2061 DUP2 PUSH 44 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_349_3"%string (equiv_checker [PUSH 32 (NToWord WLen 0x4f776e61626c653a206e6577206f776e657220697320746865207a65726f2061%N);DUP 2;PUSH 1 (NToWord WLen 0x44%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x4F776E61626C653A206E6577206F776E657220697320746865207A65726F2061%N);PUSH 1 (NToWord WLen 0x44%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 646472657373 PUSH D0 SHL PUSH 64 DUP3 ADD
 O: PUSH 646472657373 PUSH d0 SHL PUSH 64 DUP3 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_349_4"%string (equiv_checker [PUSH 6 (NToWord WLen 0x646472657373%N);PUSH 1 (NToWord WLen 0xd0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x64%N);DUP 3;Opcode ADD] [PUSH 6 (NToWord WLen 0x646472657373%N);PUSH 1 (NToWord WLen 0xD0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x64%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 84 ADD PUSH [tag] 278
 O: PUSH 84 ADD PUSH [tag] 278
*)
Compute pair "BottleCastle_run_code_of_0_block_349_5"%string (equiv_checker [PUSH 1 (NToWord WLen 0x84%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N)] [PUSH 1 (NToWord WLen 0x84%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N)] 1 optimize_id).

(*
 I: PUSH [tag] 437 DUP2 PUSH [tag] 307
 O: PUSH [tag] 437 DUP2 PUSH [tag] 307
*)
Compute pair "BottleCastle_run_code_of_0_block_350_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x1b5%N);DUP 2;PUSH 2 (NToWord WLen 0x133%N)] [PUSH 2 (NToWord WLen 0x1b5%N);DUP 2;PUSH 2 (NToWord WLen 0x133%N)] 1 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_351_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH 8 SLOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB AND CALLER EQ PUSH [tag] 306
 O: PUSH 1 DUP1 PUSH a0 SHL SUB PUSH 8 SLOAD AND CALLER EQ PUSH [tag] 306
*)
Compute pair "BottleCastle_run_code_of_0_block_352_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;PUSH 1 (NToWord WLen 0x8%N);Opcode SLOAD;Opcode AND;Opcode CALLER;Opcode EQ;PUSH 2 (NToWord WLen 0x132%N)] [PUSH 1 (NToWord WLen 0x8%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode CALLER;Opcode EQ;PUSH 2 (NToWord WLen 0x132%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 461BCD PUSH E5 SHL DUP2
 O: PUSH 40 MLOAD PUSH 461bcd PUSH e5 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_353_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461bcd%N);PUSH 1 (NToWord WLen 0xe5%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x461BCD%N);PUSH 1 (NToWord WLen 0xE5%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 20 PUSH 4 DUP3 ADD DUP2 SWAP1
 O: PUSH 20 DUP1 DUP3 PUSH 4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_353_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 3;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x4%N);DUP 3;Opcode ADD;DUP 2;DUP 1] 1 optimize_id).

(*
 I: PUSH 24 DUP3 ADD
 O: DUP2 PUSH 24 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_353_2"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x24%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x24%N);DUP 3;Opcode ADD] 2 optimize_id).

(*
 I: PUSH 4F776E61626C653A2063616C6C6572206973206E6F7420746865206F776E6572 PUSH 44 DUP3 ADD
 O: PUSH 4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572 DUP2 PUSH 44 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_353_3"%string (equiv_checker [PUSH 32 (NToWord WLen 0x4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572%N);DUP 2;PUSH 1 (NToWord WLen 0x44%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x4F776E61626C653A2063616C6C6572206973206E6F7420746865206F776E6572%N);PUSH 1 (NToWord WLen 0x44%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 64 ADD PUSH [tag] 278
 O: PUSH 64 ADD PUSH [tag] 278
*)
Compute pair "BottleCastle_run_code_of_0_block_353_4"%string (equiv_checker [PUSH 1 (NToWord WLen 0x64%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N)] [PUSH 1 (NToWord WLen 0x64%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP2 PUSH 1 GT ISZERO DUP1 ISZERO PUSH [tag] 447
 O: PUSH 0 DUP2 PUSH 1 GT ISZERO DUP1 ISZERO PUSH [tag] 447
*)
Compute pair "BottleCastle_run_code_of_0_block_354_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;PUSH 1 (NToWord WLen 0x1%N);Opcode GT;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1bf%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;PUSH 1 (NToWord WLen 0x1%N);Opcode GT;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1bf%N)] 1 optimize_id).

(*
 I: POP PUSH 0 SLOAD DUP3 LT
 O: POP PUSH 0 SLOAD DUP3 LT
*)
Compute pair "BottleCastle_run_code_of_0_block_355_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 3;Opcode LT] [POP;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 3;Opcode LT] 3 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 216
 O: DUP1 ISZERO PUSH [tag] 216
*)
Compute pair "BottleCastle_run_code_of_0_block_356_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xd8%N)] [DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xd8%N)] 1 optimize_id).

(*
 I: POP POP PUSH 0 SWAP1 DUP2
 O: POP POP PUSH 0 SWAP1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_357_0"%string (equiv_checker [POP;POP;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] [POP;POP;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] 3 optimize_id).

(*
 I: PUSH 4 PUSH 20
 O: PUSH 4 PUSH 20
*)
Compute pair "BottleCastle_run_code_of_0_block_357_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH 1 PUSH E0 SHL AND ISZERO SWAP1
 O: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH 1 PUSH e0 SHL AND ISZERO SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_357_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode AND;Opcode ISZERO;DUP 1] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;Opcode AND;Opcode ISZERO;DUP 1] 2 optimize_id).

(*
 I: PUSH 0 DUP2 DUP1 PUSH 1 GT PUSH [tag] 454
 O: PUSH 0 DUP2 DUP3 PUSH 1 GT PUSH [tag] 454
*)
Compute pair "BottleCastle_run_code_of_0_block_358_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 3;PUSH 1 (NToWord WLen 0x1%N);Opcode GT;PUSH 2 (NToWord WLen 0x1c6%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode GT;PUSH 2 (NToWord WLen 0x1c6%N)] 1 optimize_id).

(*
 I: PUSH 0 SLOAD DUP2 LT ISZERO PUSH [tag] 454
 O: PUSH 0 SLOAD DUP2 LT ISZERO PUSH [tag] 454
*)
Compute pair "BottleCastle_run_code_of_0_block_359_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1c6%N)] [PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1c6%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP2 DUP2
 O: PUSH 0 DUP2 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_360_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] 1 optimize_id).

(*
 I: PUSH 4 PUSH 20
 O: PUSH 4 PUSH 20
*)
Compute pair "BottleCastle_run_code_of_0_block_360_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH 1 PUSH E0 SHL DUP2 AND PUSH [tag] 455
 O: PUSH 40 SWAP1 KECCAK256 SLOAD DUP1 PUSH 1 PUSH e0 SHL AND PUSH [tag] 455
*)
Compute pair "BottleCastle_run_code_of_0_block_360_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;DUP 1;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode AND;PUSH 2 (NToWord WLen 0x1c7%N)] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;DUP 2;Opcode AND;PUSH 2 (NToWord WLen 0x1c7%N)] 1 optimize_id).

(*
 I: DUP1 PUSH [tag] 412
 O: DUP1 PUSH [tag] 412
*)
Compute pair "BottleCastle_run_code_of_0_block_361_0"%string (equiv_checker [DUP 1;PUSH 2 (NToWord WLen 0x19c%N)] [DUP 1;PUSH 2 (NToWord WLen 0x19c%N)] 1 optimize_id).

(*
 I: POP PUSH 0 NOT ADD PUSH 0 DUP2 DUP2
 O: POP PUSH 0 NOT ADD PUSH 0 DUP2 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_362_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] [POP;PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] 2 optimize_id).

(*
 I: PUSH 4 PUSH 20
 O: PUSH 4 PUSH 20
*)
Compute pair "BottleCastle_run_code_of_0_block_362_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH [tag] 456
 O: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH [tag] 456
*)
Compute pair "BottleCastle_run_code_of_0_block_362_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 2 (NToWord WLen 0x1c8%N)] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 2 (NToWord WLen 0x1c8%N)] 1 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "BottleCastle_run_code_of_0_block_363_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 6F96CDA1 PUSH E1 SHL DUP2
 O: PUSH 40 MLOAD PUSH 6f96cda1 PUSH e1 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_364_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x6f96cda1%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x6F96CDA1%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_364_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 8 DUP1 SLOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP4 DUP2 AND PUSH 1 PUSH 1 PUSH A0 SHL SUB NOT DUP4 AND DUP2 OR SWAP1 SWAP4
 O: PUSH 8 PUSH a0 PUSH 1 DUP1 DUP4 SLOAD SWAP3 SHL SUB DUP1 NOT DUP2 DUP6 AND SWAP4 SWAP1 DUP4 AND DUP5 OR SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_365_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x8%N);PUSH 1 (NToWord WLen 0xa0%N);PUSH 1 (NToWord WLen 0x1%N);DUP 1;DUP 4;Opcode SLOAD;DUP 3;Opcode SHL;Opcode SUB;DUP 1;Opcode NOT;DUP 2;DUP 6;Opcode AND;DUP 4;DUP 1;DUP 4;Opcode AND;DUP 5;Opcode OR;DUP 1] [PUSH 1 (NToWord WLen 0x8%N);DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 4;DUP 2;Opcode AND;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 4;Opcode AND;DUP 2;Opcode OR;DUP 1;DUP 4] 1 optimize_id).

(*
 I: PUSH 40 MLOAD SWAP2 AND SWAP2 SWAP1 DUP3 SWAP1 PUSH 8BE0079C531659141344CD1FD0A4F28419497F9722A3DAAFE3B4186F6B6457E0 SWAP1 PUSH 0 SWAP1
 O: AND SWAP1 DUP2 PUSH 8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0 PUSH 0 PUSH 40 MLOAD
*)
Compute pair "BottleCastle_run_code_of_0_block_365_1"%string (equiv_checker [Opcode AND;DUP 1;DUP 2;PUSH 32 (NToWord WLen 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0%N);PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 2;Opcode AND;DUP 2;DUP 1;DUP 3;DUP 1;PUSH 32 (NToWord WLen 0x8BE0079C531659141344CD1FD0A4F28419497F9722A3DAAFE3B4186F6B6457E0%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 1] 3 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_365_2"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH 40 DUP1 MLOAD PUSH 80 DUP2 ADD DUP3
 O: PUSH 40 DUP1 MLOAD PUSH 80 DUP2 ADD DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_366_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x80%N);DUP 2;Opcode ADD;DUP 3] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x80%N);DUP 2;Opcode ADD;DUP 3] 0 optimize_id).

(*
 I: PUSH 0 DUP1 DUP3
 O: PUSH 0 DUP1 DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_366_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 3] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 3] 1 optimize_id).

(*
 I: PUSH 20 DUP3 ADD DUP2 SWAP1
 O: DUP1 PUSH 20 DUP4 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_366_2"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;DUP 2;DUP 1] 2 optimize_id).

(*
 I: SWAP2 DUP2 ADD DUP3 SWAP1
 O: DUP1 SWAP3 DUP3 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_366_3"%string (equiv_checker [DUP 1;DUP 3;DUP 3;Opcode ADD] [DUP 2;DUP 2;Opcode ADD;DUP 3;DUP 1] 3 optimize_id).

(*
 I: PUSH 60 DUP2 ADD SWAP2 SWAP1 SWAP2
 O: SWAP1 DUP2 PUSH 60 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_366_4"%string (equiv_checker [DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x60%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x60%N);DUP 2;Opcode ADD;DUP 2;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 0 DUP3 DUP2
 O: PUSH 0 DUP3 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_366_5"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 2] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 2] 2 optimize_id).

(*
 I: PUSH 4 PUSH 20
 O: PUSH 4 PUSH 20
*)
Compute pair "BottleCastle_run_code_of_0_block_366_6"%string (equiv_checker [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH [tag] 216 SWAP1 PUSH 40 DUP1 MLOAD PUSH 80 DUP2 ADD DUP3
 O: PUSH 40 PUSH [tag] 216 SWAP2 KECCAK256 SLOAD PUSH 40 DUP1 MLOAD PUSH 80 DUP2 ADD DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_366_7"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);PUSH 1 (NToWord WLen 0xd8%N);DUP 2;Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x80%N);DUP 2;Opcode ADD;DUP 3] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0xd8%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x80%N);DUP 2;Opcode ADD;DUP 3] 1 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP4 AND DUP2
 O: PUSH 1 DUP1 PUSH a0 SHL SUB DUP4 AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_366_8"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 4;Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 4;Opcode AND;DUP 2] 3 optimize_id).

(*
 I: PUSH A0 DUP4 SWAP1 SHR PUSH FFFFFFFFFFFFFFFF AND PUSH 20 DUP3 ADD
 O: PUSH ffffffffffffffff DUP4 PUSH a0 SHR AND DUP2 PUSH 20 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_366_9"%string (equiv_checker [PUSH 8 (NToWord WLen 0xffffffffffffffff%N);DUP 4;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHR;Opcode AND;DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD] [PUSH 1 (NToWord WLen 0xA0%N);DUP 4;DUP 1;Opcode SHR;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD] 3 optimize_id).

(*
 I: PUSH 1 PUSH E0 SHL DUP4 AND ISZERO ISZERO SWAP2 DUP2 ADD SWAP2 SWAP1 SWAP2
 O: DUP1 SWAP2 ADD DUP3 PUSH 1 PUSH e0 SHL AND ISZERO ISZERO SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_366_10"%string (equiv_checker [DUP 1;DUP 2;Opcode ADD;DUP 3;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode AND;Opcode ISZERO;Opcode ISZERO;DUP 1] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;DUP 4;Opcode AND;Opcode ISZERO;Opcode ISZERO;DUP 2;DUP 2;Opcode ADD;DUP 2;DUP 1;DUP 2] 3 optimize_id).

(*
 I: PUSH E8 SWAP2 SWAP1 SWAP2 SHR PUSH 60 DUP3 ADD
 O: SWAP1 PUSH e8 SHR DUP2 PUSH 60 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_366_11"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0xe8%N);Opcode SHR;DUP 2;PUSH 1 (NToWord WLen 0x60%N);Opcode ADD] [PUSH 1 (NToWord WLen 0xE8%N);DUP 2;DUP 1;DUP 2;Opcode SHR;PUSH 1 (NToWord WLen 0x60%N);DUP 3;Opcode ADD] 2 optimize_id).

(*
 I: SWAP1
 O: SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_366_12"%string (equiv_checker [DUP 1] [DUP 1] 2 optimize_id).

(*
 I: PUSH [tag] 292 DUP3 DUP3 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH [tag] 292 DUP3 DUP3 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_367_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x124%N);DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [PUSH 2 (NToWord WLen 0x124%N);DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 2 optimize_id).

(*
 I: DUP1 PUSH 0 DUP2
 O: DUP1 PUSH 0 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_367_1"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 2] [DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 2] 1 optimize_id).

(*
 I: POP PUSH [tag] 474
 O: POP PUSH [tag] 474
*)
Compute pair "BottleCastle_run_code_of_0_block_367_2"%string (equiv_checker [POP;PUSH 2 (NToWord WLen 0x1da%N)] [POP;PUSH 2 (NToWord WLen 0x1da%N)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH A85BD01 PUSH E1 SHL DUP2
 O: PUSH 40 MLOAD PUSH a85bd01 PUSH e1 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_368_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0xa85bd01%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0xA85BD01%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP1 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 479
 O: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP9 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 479
*)
Compute pair "BottleCastle_run_code_of_0_block_369_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (NToWord WLen 0x0%N);DUP 8;DUP 9;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1df%N)] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (NToWord WLen 0x0%N);DUP 8;DUP 1;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1df%N)] 3 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_370_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP GAS
 O: POP GAS
*)
Compute pair "BottleCastle_run_code_of_0_block_371_0"%string (equiv_checker [POP;Opcode GAS] [POP;Opcode GAS] 1 optimize_id).

(*
 I: SWAP3 POP POP POP DUP1 ISZERO PUSH [tag] 480
 O: SWAP3 POP POP POP DUP1 ISZERO PUSH [tag] 480
*)
Compute pair "BottleCastle_run_code_of_0_block_371_1"%string (equiv_checker [DUP 3;POP;POP;POP;DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1e0%N)] [DUP 3;POP;POP;POP;DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1e0%N)] 4 optimize_id).

(*
 I: POP PUSH 40 DUP1 MLOAD PUSH 1F RETURNDATASIZE SWAP1 DUP2 ADD PUSH 1F NOT AND DUP3 ADD SWAP1 SWAP3
 O: POP RETURNDATASIZE PUSH 40 MLOAD DUP1 DUP3 PUSH 1f DUP1 NOT SWAP2 ADD AND ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_372_0"%string (equiv_checker [POP;Opcode RETURNDATASIZE;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 3;PUSH 1 (NToWord WLen 0x1f%N);DUP 1;Opcode NOT;DUP 2;Opcode ADD;Opcode AND;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [POP;PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1F%N);Opcode RETURNDATASIZE;DUP 1;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;Opcode AND;DUP 3;Opcode ADD;DUP 1;DUP 3] 1 optimize_id).

(*
 I: PUSH [tag] 481 SWAP2 DUP2 ADD SWAP1 PUSH [tag] 482
 O: PUSH [tag] 481 SWAP2 DUP2 ADD SWAP1 PUSH [tag] 482
*)
Compute pair "BottleCastle_run_code_of_0_block_372_1"%string (equiv_checker [PUSH 2 (NToWord WLen 0x1e1%N);DUP 2;DUP 2;Opcode ADD;DUP 1;PUSH 2 (NToWord WLen 0x1e2%N)] [PUSH 2 (NToWord WLen 0x1e1%N);DUP 2;DUP 2;Opcode ADD;DUP 1;PUSH 2 (NToWord WLen 0x1e2%N)] 2 optimize_id).

(*
 I: PUSH 1
 O: PUSH 1
*)
Compute pair "BottleCastle_run_code_of_0_block_373_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N)] [PUSH 1 (NToWord WLen 0x1%N)] 0 optimize_id).

(*
 I: PUSH [tag] 483
 O: PUSH [tag] 483
*)
Compute pair "BottleCastle_run_code_of_0_block_374_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x1e3%N)] [PUSH 2 (NToWord WLen 0x1e3%N)] 0 optimize_id).

(*
 I: RETURNDATASIZE DUP1 DUP1 ISZERO PUSH [tag] 488
 O: RETURNDATASIZE DUP1 RETURNDATASIZE ISZERO PUSH [tag] 488
*)
Compute pair "BottleCastle_run_code_of_0_block_375_0"%string (equiv_checker [Opcode RETURNDATASIZE;DUP 1;Opcode RETURNDATASIZE;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1e8%N)] [Opcode RETURNDATASIZE;DUP 1;DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1e8%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD SWAP2 POP PUSH 1F NOT PUSH 3F RETURNDATASIZE ADD AND DUP3 ADD PUSH 40
 O: PUSH 1f PUSH 40 MLOAD SWAP3 POP NOT RETURNDATASIZE PUSH 3f ADD AND DUP3 ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_376_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 3;POP;Opcode NOT;Opcode RETURNDATASIZE;PUSH 1 (NToWord WLen 0x3f%N);Opcode ADD;Opcode AND;DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 2;POP;PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;PUSH 1 (NToWord WLen 0x3F%N);Opcode RETURNDATASIZE;Opcode ADD;Opcode AND;DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 2 optimize_id).

(*
 I: RETURNDATASIZE DUP3
 O: RETURNDATASIZE DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_376_1"%string (equiv_checker [Opcode RETURNDATASIZE;DUP 3] [Opcode RETURNDATASIZE;DUP 3] 2 optimize_id).

(*
 I: RETURNDATASIZE PUSH 0 PUSH 20 DUP5 ADD
 O: RETURNDATASIZE PUSH 0 PUSH 20 DUP5 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_376_2"%string (equiv_checker [Opcode RETURNDATASIZE;PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD] [Opcode RETURNDATASIZE;PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD] 2 optimize_id).

(*
 I: PUSH [tag] 487
 O: PUSH [tag] 487
*)
Compute pair "BottleCastle_run_code_of_0_block_376_3"%string (equiv_checker [PUSH 2 (NToWord WLen 0x1e7%N)] [PUSH 2 (NToWord WLen 0x1e7%N)] 0 optimize_id).

(*
 I: PUSH 60 SWAP2 POP
 O: PUSH 60 SWAP2 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_377_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);DUP 2;POP] [PUSH 1 (NToWord WLen 0x60%N);DUP 2;POP] 2 optimize_id).

(*
 I: POP DUP1 MLOAD PUSH [tag] 489
 O: POP DUP1 MLOAD PUSH [tag] 489
*)
Compute pair "BottleCastle_run_code_of_0_block_378_0"%string (equiv_checker [POP;DUP 1;Opcode MLOAD;PUSH 2 (NToWord WLen 0x1e9%N)] [POP;DUP 1;Opcode MLOAD;PUSH 2 (NToWord WLen 0x1e9%N)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 68D2BF6B PUSH E1 SHL DUP2
 O: PUSH 40 MLOAD PUSH 68d2bf6b PUSH e1 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_379_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x68d2bf6b%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x68D2BF6B%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_379_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: DUP1 MLOAD DUP2 PUSH 20 ADD
 O: DUP1 MLOAD DUP2 PUSH 20 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_380_0"%string (equiv_checker [DUP 1;Opcode MLOAD;DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD] [DUP 1;Opcode MLOAD;DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD] 1 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH E0 SHL SUB NOT AND PUSH A85BD01 PUSH E1 SHL EQ SWAP1 POP
 O: PUSH a85bd01 PUSH e1 SHL SWAP2 POP PUSH 1 DUP1 PUSH e0 SHL SUB NOT AND EQ
*)
Compute pair "BottleCastle_run_code_of_0_block_381_0"%string (equiv_checker [PUSH 4 (NToWord WLen 0xa85bd01%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;DUP 2;POP;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode SUB;Opcode NOT;Opcode AND;Opcode EQ] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;Opcode SUB;Opcode NOT;Opcode AND;PUSH 4 (NToWord WLen 0xA85BD01%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;Opcode EQ;DUP 1;POP] 2 optimize_id).

(*
 I: SWAP5 SWAP4 POP POP POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_382_0"%string (equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 5;DUP 4;POP;POP;POP;POP] 6 optimize_id).

(*
 I: PUSH 60 PUSH A DUP1 SLOAD PUSH [tag] 222 SWAP1 PUSH [tag] 223
 O: PUSH 60 PUSH a PUSH [tag] 222 DUP2 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_383_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0xa%N);PUSH 1 (NToWord WLen 0xde%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0xA%N);DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xde%N);DUP 1;PUSH 1 (NToWord WLen 0xdf%N)] 0 optimize_id).

(*
 I: PUSH 60 DUP2 PUSH [tag] 499
 O: PUSH 60 DUP2 PUSH [tag] 499
*)
Compute pair "BottleCastle_run_code_of_0_block_384_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);DUP 2;PUSH 2 (NToWord WLen 0x1f3%N)] [PUSH 1 (NToWord WLen 0x60%N);DUP 2;PUSH 2 (NToWord WLen 0x1f3%N)] 1 optimize_id).

(*
 I: POP POP PUSH 40 DUP1 MLOAD DUP1 DUP3 ADD SWAP1 SWAP2
 O: POP POP PUSH 40 MLOAD DUP1 PUSH 40 ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_385_0"%string (equiv_checker [POP;POP;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [POP;POP;PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode MLOAD;DUP 1;DUP 3;Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 1 DUP2
 O: PUSH 1 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_385_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 2] [PUSH 1 (NToWord WLen 0x1%N);DUP 2] 1 optimize_id).

(*
 I: PUSH 3 PUSH FC SHL PUSH 20 DUP3 ADD
 O: PUSH 3 PUSH fc SHL PUSH 20 DUP3 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_385_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x3%N);PUSH 1 (NToWord WLen 0xfc%N);Opcode SHL;PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD] [PUSH 1 (NToWord WLen 0x3%N);PUSH 1 (NToWord WLen 0xFC%N);Opcode SHL;PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: SWAP1
 O: SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_385_3"%string (equiv_checker [DUP 1] [DUP 1] 2 optimize_id).

(*
 I: DUP2 PUSH 0
 O: DUP2 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_386_0"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x0%N)] [DUP 2;PUSH 1 (NToWord WLen 0x0%N)] 2 optimize_id).

(*
 I: DUP2 ISZERO PUSH [tag] 501
 O: DUP2 ISZERO PUSH [tag] 501
*)
Compute pair "BottleCastle_run_code_of_0_block_387_0"%string (equiv_checker [DUP 2;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1f5%N)] [DUP 2;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1f5%N)] 2 optimize_id).

(*
 I: DUP1 PUSH [tag] 502 DUP2 PUSH [tag] 503
 O: DUP1 PUSH [tag] 502 DUP2 PUSH [tag] 503
*)
Compute pair "BottleCastle_run_code_of_0_block_388_0"%string (equiv_checker [DUP 1;PUSH 2 (NToWord WLen 0x1f6%N);DUP 2;PUSH 2 (NToWord WLen 0x1f7%N)] [DUP 1;PUSH 2 (NToWord WLen 0x1f6%N);DUP 2;PUSH 2 (NToWord WLen 0x1f7%N)] 1 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 504 SWAP1 POP PUSH A DUP4 PUSH [tag] 505
 O: SWAP2 POP POP PUSH [tag] 504 PUSH a DUP4 PUSH [tag] 505
*)
Compute pair "BottleCastle_run_code_of_0_block_389_0"%string (equiv_checker [DUP 2;POP;POP;PUSH 2 (NToWord WLen 0x1f8%N);PUSH 1 (NToWord WLen 0xa%N);DUP 4;PUSH 2 (NToWord WLen 0x1f9%N)] [DUP 2;POP;PUSH 2 (NToWord WLen 0x1f8%N);DUP 1;POP;PUSH 1 (NToWord WLen 0xA%N);DUP 4;PUSH 2 (NToWord WLen 0x1f9%N)] 4 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 500
 O: SWAP2 POP PUSH [tag] 500
*)
Compute pair "BottleCastle_run_code_of_0_block_390_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (NToWord WLen 0x1f4%N)] [DUP 2;POP;PUSH 2 (NToWord WLen 0x1f4%N)] 3 optimize_id).

(*
 I: PUSH 0 DUP2 PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 507
 O: PUSH 0 DUP2 PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 507
*)
Compute pair "BottleCastle_run_code_of_0_block_391_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1fb%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1fb%N)] 1 optimize_id).

(*
 I: PUSH [tag] 507 PUSH [tag] 312
 O: PUSH [tag] 507 PUSH [tag] 312
*)
Compute pair "BottleCastle_run_code_of_0_block_392_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x1fb%N);PUSH 2 (NToWord WLen 0x138%N)] [PUSH 2 (NToWord WLen 0x1fb%N);PUSH 2 (NToWord WLen 0x138%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD SWAP1 DUP1 DUP3
 O: DUP1 PUSH 40 MLOAD SWAP2 DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_393_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 2;DUP 3] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 1;DUP 3] 1 optimize_id).

(*
 I: DUP1 PUSH 1F ADD PUSH 1F NOT AND PUSH 20 ADD DUP3 ADD PUSH 40
 O: DUP2 PUSH 20 PUSH 1f DUP4 ADD PUSH 1f NOT AND ADD ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_393_1"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x1f%N);DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0x1f%N);Opcode NOT;Opcode AND;Opcode ADD;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;Opcode AND;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 2 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 508
 O: DUP1 ISZERO PUSH [tag] 508
*)
Compute pair "BottleCastle_run_code_of_0_block_393_2"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1fc%N)] [DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1fc%N)] 1 optimize_id).

(*
 I: PUSH 20 DUP3 ADD DUP2 DUP1 CALLDATASIZE DUP4
 O: DUP2 PUSH 20 ADD DUP2 DUP3 CALLDATASIZE DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_394_0"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 3;Opcode CALLDATASIZE;DUP 4] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;DUP 2;DUP 1;Opcode CALLDATASIZE;DUP 4] 2 optimize_id).

(*
 I: ADD SWAP1 POP
 O: ADD SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_394_1"%string (equiv_checker [Opcode ADD;DUP 1;POP] [Opcode ADD;DUP 1;POP] 3 optimize_id).

(*
 I: POP SWAP1 POP
 O: POP SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_395_0"%string (equiv_checker [POP;DUP 1;POP] [POP;DUP 1;POP] 3 optimize_id).

(*
 I: DUP5 ISZERO PUSH [tag] 491
 O: DUP5 ISZERO PUSH [tag] 491
*)
Compute pair "BottleCastle_run_code_of_0_block_396_0"%string (equiv_checker [DUP 5;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1eb%N)] [DUP 5;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1eb%N)] 5 optimize_id).

(*
 I: PUSH [tag] 511 PUSH 1 DUP4 PUSH [tag] 512
 O: PUSH [tag] 511 PUSH 1 DUP4 PUSH [tag] 512
*)
Compute pair "BottleCastle_run_code_of_0_block_397_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x1ff%N);PUSH 1 (NToWord WLen 0x1%N);DUP 4;PUSH 2 (NToWord WLen 0x200%N)] [PUSH 2 (NToWord WLen 0x1ff%N);PUSH 1 (NToWord WLen 0x1%N);DUP 4;PUSH 2 (NToWord WLen 0x200%N)] 2 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 513 PUSH A DUP7 PUSH [tag] 514
 O: SWAP2 POP PUSH [tag] 513 PUSH a DUP7 PUSH [tag] 514
*)
Compute pair "BottleCastle_run_code_of_0_block_398_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (NToWord WLen 0x201%N);PUSH 1 (NToWord WLen 0xa%N);DUP 7;PUSH 2 (NToWord WLen 0x202%N)] [DUP 2;POP;PUSH 2 (NToWord WLen 0x201%N);PUSH 1 (NToWord WLen 0xA%N);DUP 7;PUSH 2 (NToWord WLen 0x202%N)] 6 optimize_id).

(*
 I: PUSH [tag] 515 SWAP1 PUSH 30 PUSH [tag] 350
 O: PUSH [tag] 515 SWAP1 PUSH 30 PUSH [tag] 350
*)
Compute pair "BottleCastle_run_code_of_0_block_399_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x203%N);DUP 1;PUSH 1 (NToWord WLen 0x30%N);PUSH 2 (NToWord WLen 0x15e%N)] [PUSH 2 (NToWord WLen 0x203%N);DUP 1;PUSH 1 (NToWord WLen 0x30%N);PUSH 2 (NToWord WLen 0x15e%N)] 1 optimize_id).

(*
 I: PUSH F8 SHL DUP2 DUP4 DUP2 MLOAD DUP2 LT PUSH [tag] 517
 O: PUSH f8 SHL DUP2 DUP4 DUP4 MLOAD DUP6 LT PUSH [tag] 517
*)
Compute pair "BottleCastle_run_code_of_0_block_400_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xf8%N);Opcode SHL;DUP 2;DUP 4;DUP 4;Opcode MLOAD;DUP 6;Opcode LT;PUSH 2 (NToWord WLen 0x205%N)] [PUSH 1 (NToWord WLen 0xF8%N);Opcode SHL;DUP 2;DUP 4;DUP 2;Opcode MLOAD;DUP 2;Opcode LT;PUSH 2 (NToWord WLen 0x205%N)] 3 optimize_id).

(*
 I: PUSH [tag] 517 PUSH [tag] 327
 O: PUSH [tag] 517 PUSH [tag] 327
*)
Compute pair "BottleCastle_run_code_of_0_block_401_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x205%N);PUSH 2 (NToWord WLen 0x147%N)] [PUSH 2 (NToWord WLen 0x205%N);PUSH 2 (NToWord WLen 0x147%N)] 0 optimize_id).

(*
 I: PUSH 20 ADD ADD SWAP1 PUSH 1 PUSH 1 PUSH F8 SHL SUB NOT AND SWAP1 DUP2 PUSH 0 BYTE SWAP1
 O: SWAP2 PUSH 1 DUP1 PUSH f8 SHL SUB NOT AND SWAP2 PUSH 20 ADD ADD DUP2 PUSH 0 BYTE SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_402_0"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xf8%N);Opcode SHL;Opcode SUB;Opcode NOT;Opcode AND;DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;Opcode ADD;DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode BYTE;DUP 1] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xF8%N);Opcode SHL;Opcode SUB;Opcode NOT;Opcode AND;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode BYTE;DUP 1] 3 optimize_id).

(*
 I: POP PUSH [tag] 518 PUSH A DUP7 PUSH [tag] 505
 O: POP PUSH [tag] 518 PUSH a DUP7 PUSH [tag] 505
*)
Compute pair "BottleCastle_run_code_of_0_block_402_1"%string (equiv_checker [POP;PUSH 2 (NToWord WLen 0x206%N);PUSH 1 (NToWord WLen 0xa%N);DUP 7;PUSH 2 (NToWord WLen 0x1f9%N)] [POP;PUSH 2 (NToWord WLen 0x206%N);PUSH 1 (NToWord WLen 0xA%N);DUP 7;PUSH 2 (NToWord WLen 0x1f9%N)] 6 optimize_id).

(*
 I: SWAP5 POP PUSH [tag] 509
 O: SWAP5 POP PUSH [tag] 509
*)
Compute pair "BottleCastle_run_code_of_0_block_403_0"%string (equiv_checker [DUP 5;POP;PUSH 2 (NToWord WLen 0x1fd%N)] [DUP 5;POP;PUSH 2 (NToWord WLen 0x1fd%N)] 6 optimize_id).

(*
 I: PUSH [tag] 524 DUP4 DUP4 PUSH [tag] 525
 O: PUSH [tag] 524 DUP4 DUP4 PUSH [tag] 525
*)
Compute pair "BottleCastle_run_code_of_0_block_404_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x20c%N);DUP 4;DUP 4;PUSH 2 (NToWord WLen 0x20d%N)] [PUSH 2 (NToWord WLen 0x20c%N);DUP 4;DUP 4;PUSH 2 (NToWord WLen 0x20d%N)] 3 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP4 AND EXTCODESIZE ISZERO PUSH [tag] 285
 O: DUP3 PUSH 1 DUP1 PUSH a0 SHL SUB AND EXTCODESIZE ISZERO PUSH [tag] 285
*)
Compute pair "BottleCastle_run_code_of_0_block_405_0"%string (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode EXTCODESIZE;Opcode ISZERO;PUSH 2 (NToWord WLen 0x11d%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 4;Opcode AND;Opcode EXTCODESIZE;Opcode ISZERO;PUSH 2 (NToWord WLen 0x11d%N)] 3 optimize_id).

(*
 I: PUSH 0 SLOAD DUP3 DUP2 SUB
 O: PUSH 0 SLOAD DUP3 DUP2 SUB
*)
Compute pair "BottleCastle_run_code_of_0_block_406_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 3;DUP 2;Opcode SUB] [PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 3;DUP 2;Opcode SUB] 2 optimize_id).

(*
 I: PUSH [tag] 530 PUSH 0 DUP7 DUP4 DUP1 PUSH 1 ADD SWAP5 POP DUP7 PUSH [tag] 379
 O: PUSH [tag] 530 PUSH 0 DUP7 PUSH 1 DUP5 ADD SWAP4 DUP7 PUSH [tag] 379
*)
Compute pair "BottleCastle_run_code_of_0_block_407_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x212%N);PUSH 1 (NToWord WLen 0x0%N);DUP 7;PUSH 1 (NToWord WLen 0x1%N);DUP 5;Opcode ADD;DUP 4;DUP 7;PUSH 2 (NToWord WLen 0x17b%N)] [PUSH 2 (NToWord WLen 0x212%N);PUSH 1 (NToWord WLen 0x0%N);DUP 7;DUP 4;DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 5;POP;DUP 7;PUSH 2 (NToWord WLen 0x17b%N)] 5 optimize_id).

(*
 I: PUSH [tag] 531
 O: PUSH [tag] 531
*)
Compute pair "BottleCastle_run_code_of_0_block_408_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x213%N)] [PUSH 2 (NToWord WLen 0x213%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 68D2BF6B PUSH E1 SHL DUP2
 O: PUSH 40 MLOAD PUSH 68d2bf6b PUSH e1 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_409_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x68d2bf6b%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x68D2BF6B%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_409_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: DUP2 DUP2 LT PUSH [tag] 527
 O: DUP2 DUP2 LT PUSH [tag] 527
*)
Compute pair "BottleCastle_run_code_of_0_block_410_0"%string (equiv_checker [DUP 2;DUP 2;Opcode LT;PUSH 2 (NToWord WLen 0x20f%N)] [DUP 2;DUP 2;Opcode LT;PUSH 2 (NToWord WLen 0x20f%N)] 2 optimize_id).

(*
 I: DUP2 PUSH 0 SLOAD EQ PUSH [tag] 532
 O: DUP2 PUSH 0 SLOAD EQ PUSH [tag] 532
*)
Compute pair "BottleCastle_run_code_of_0_block_411_0"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;Opcode EQ;PUSH 2 (NToWord WLen 0x214%N)] [DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;Opcode EQ;PUSH 2 (NToWord WLen 0x214%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_412_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP POP POP POP POP
 O: POP POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_413_0"%string (equiv_checker [POP;POP;POP;POP;POP] [POP;POP;POP;POP;POP] 5 optimize_id).

(*
 I: PUSH 0 SLOAD DUP2 PUSH [tag] 534
 O: PUSH 0 SLOAD DUP2 PUSH [tag] 534
*)
Compute pair "BottleCastle_run_code_of_0_block_414_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 2;PUSH 2 (NToWord WLen 0x216%N)] [PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 2;PUSH 2 (NToWord WLen 0x216%N)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH B562E8DD PUSH E0 SHL DUP2
 O: PUSH 40 MLOAD PUSH b562e8dd PUSH e0 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_415_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0xb562e8dd%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0xB562E8DD%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_415_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP4 AND PUSH 0 DUP2 DUP2
 O: DUP3 PUSH 1 DUP1 PUSH a0 SHL SUB AND PUSH 0 DUP2 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_416_0"%string (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 4;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] 3 optimize_id).

(*
 I: PUSH 5 PUSH 20 SWAP1 DUP2
 O: PUSH 20 PUSH 5 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_416_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x5%N);DUP 2] [PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 2] 0 optimize_id).

(*
 I: PUSH 40 DUP1 DUP4 KECCAK256 DUP1 SLOAD PUSH 10000000000000001 DUP9 MUL ADD SWAP1
 O: PUSH 40 DUP1 DUP4 KECCAK256 DUP7 PUSH 10000000000000001 MUL DUP2 SLOAD ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_416_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;DUP 4;Opcode KECCAK256;DUP 7;PUSH 9 (NToWord WLen 0x10000000000000001%N);Opcode MUL;DUP 2;Opcode SLOAD;Opcode ADD;DUP 1] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;DUP 4;Opcode KECCAK256;DUP 1;Opcode SLOAD;PUSH 9 (NToWord WLen 0x10000000000000001%N);DUP 9;Opcode MUL;Opcode ADD;DUP 1] 5 optimize_id).

(*
 I: DUP5 DUP4
 O: DUP5 DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_416_3"%string (equiv_checker [DUP 5;DUP 4] [DUP 5;DUP 4] 5 optimize_id).

(*
 I: PUSH 4 SWAP1 SWAP2
 O: SWAP1 PUSH 4 SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_416_4"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x4%N);DUP 1] [PUSH 1 (NToWord WLen 0x4%N);DUP 1;DUP 2] 2 optimize_id).

(*
 I: DUP2 KECCAK256 PUSH 1 DUP6 EQ PUSH E1 SHL TIMESTAMP PUSH A0 SHL OR DUP4 OR SWAP1
 O: DUP2 KECCAK256 TIMESTAMP PUSH a0 SHL DUP6 PUSH 1 EQ PUSH e1 SHL OR DUP4 OR SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_416_5"%string (equiv_checker [DUP 2;Opcode KECCAK256;Opcode TIMESTAMP;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;DUP 6;PUSH 1 (NToWord WLen 0x1%N);Opcode EQ;PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;Opcode OR;DUP 4;Opcode OR;DUP 1] [DUP 2;Opcode KECCAK256;PUSH 1 (NToWord WLen 0x1%N);DUP 6;Opcode EQ;PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;Opcode TIMESTAMP;PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode OR;DUP 4;Opcode OR;DUP 1] 5 optimize_id).

(*
 I: DUP3 DUP5 ADD SWAP1 DUP4 SWAP1 DUP4 SWAP1 PUSH DDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF DUP2 DUP1
 O: DUP3 DUP3 DUP6 DUP3 ADD SWAP3 PUSH ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef DUP2 DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_416_6"%string (equiv_checker [DUP 3;DUP 3;DUP 6;DUP 3;Opcode ADD;DUP 3;PUSH 32 (NToWord WLen 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef%N);DUP 2;DUP 3] [DUP 3;DUP 5;Opcode ADD;DUP 1;DUP 4;DUP 1;DUP 4;DUP 1;PUSH 32 (NToWord WLen 0xDDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF%N);DUP 2;DUP 1] 4 optimize_id).

(*
 I: PUSH 1 DUP4 ADD
 O: DUP3 PUSH 1 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_416_7"%string (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x1%N);DUP 4;Opcode ADD] 3 optimize_id).

(*
 I: DUP2 DUP2 EQ PUSH [tag] 542
 O: DUP1 DUP3 EQ PUSH [tag] 542
*)
Compute pair "BottleCastle_run_code_of_0_block_417_0"%string (equiv_checker [DUP 1;DUP 3;Opcode EQ;PUSH 2 (NToWord WLen 0x21e%N)] [DUP 2;DUP 2;Opcode EQ;PUSH 2 (NToWord WLen 0x21e%N)] 2 optimize_id).

(*
 I: DUP1 DUP4 PUSH 0 PUSH DDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF PUSH 0 DUP1
 O: DUP1 DUP4 PUSH 0 PUSH ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef DUP2 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_418_0"%string (equiv_checker [DUP 1;DUP 4;PUSH 1 (NToWord WLen 0x0%N);PUSH 32 (NToWord WLen 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef%N);DUP 2;DUP 1] [DUP 1;DUP 4;PUSH 1 (NToWord WLen 0x0%N);PUSH 32 (NToWord WLen 0xDDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF%N);PUSH 1 (NToWord WLen 0x0%N);DUP 1] 3 optimize_id).

(*
 I: PUSH 1 ADD PUSH [tag] 540
 O: PUSH 1 ADD PUSH [tag] 540
*)
Compute pair "BottleCastle_run_code_of_0_block_418_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 2 (NToWord WLen 0x21c%N)] [PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 2 (NToWord WLen 0x21c%N)] 1 optimize_id).

(*
 I: POP DUP2 PUSH [tag] 543
 O: POP DUP2 PUSH [tag] 543
*)
Compute pair "BottleCastle_run_code_of_0_block_419_0"%string (equiv_checker [POP;DUP 2;PUSH 2 (NToWord WLen 0x21f%N)] [POP;DUP 2;PUSH 2 (NToWord WLen 0x21f%N)] 3 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 2E0763 PUSH E8 SHL DUP2
 O: PUSH 40 MLOAD PUSH 2e0763 PUSH e8 SHL DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_420_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x2e0763%N);PUSH 1 (NToWord WLen 0xe8%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0x2E0763%N);PUSH 1 (NToWord WLen 0xE8%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_420_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 0
 O: PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_421_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_421_1"%string (equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id).

(*
 I: DUP3 DUP1 SLOAD PUSH [tag] 546 SWAP1 PUSH [tag] 223
 O: DUP3 PUSH [tag] 546 DUP5 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_422_0"%string (equiv_checker [DUP 3;PUSH 2 (NToWord WLen 0x222%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (NToWord WLen 0x222%N);DUP 1;PUSH 1 (NToWord WLen 0xdf%N)] 3 optimize_id).

(*
 I: SWAP1 PUSH 0
 O: SWAP1 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_423_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x0%N)] [DUP 1;PUSH 1 (NToWord WLen 0x0%N)] 2 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1 PUSH 1F ADD PUSH 20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 548
 O: PUSH 20 DUP1 PUSH 0 KECCAK256 SWAP2 PUSH 1f ADD DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 548
*)
Compute pair "BottleCastle_run_code_of_0_block_423_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 2;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 2 (NToWord WLen 0x224%N)] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 2 (NToWord WLen 0x224%N)] 3 optimize_id).

(*
 I: PUSH 0 DUP6
 O: PUSH 0 DUP6
*)
Compute pair "BottleCastle_run_code_of_0_block_424_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 6] [PUSH 1 (NToWord WLen 0x0%N);DUP 6] 5 optimize_id).

(*
 I: PUSH [tag] 551
 O: PUSH [tag] 551
*)
Compute pair "BottleCastle_run_code_of_0_block_424_1"%string (equiv_checker [PUSH 2 (NToWord WLen 0x227%N)] [PUSH 2 (NToWord WLen 0x227%N)] 0 optimize_id).

(*
 I: DUP3 PUSH 1F LT PUSH [tag] 549
 O: DUP3 PUSH 1f LT PUSH [tag] 549
*)
Compute pair "BottleCastle_run_code_of_0_block_425_0"%string (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0x1f%N);Opcode LT;PUSH 2 (NToWord WLen 0x225%N)] [DUP 3;PUSH 1 (NToWord WLen 0x1F%N);Opcode LT;PUSH 2 (NToWord WLen 0x225%N)] 3 optimize_id).

(*
 I: DUP1 MLOAD PUSH FF NOT AND DUP4 DUP1 ADD OR DUP6
 O: DUP3 DUP1 ADD PUSH ff NOT DUP3 MLOAD AND OR DUP6
*)
Compute pair "BottleCastle_run_code_of_0_block_426_0"%string (equiv_checker [DUP 3;DUP 1;Opcode ADD;PUSH 1 (NToWord WLen 0xff%N);Opcode NOT;DUP 3;Opcode MLOAD;Opcode AND;Opcode OR;DUP 6] [DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0xFF%N);Opcode NOT;Opcode AND;DUP 4;DUP 1;Opcode ADD;Opcode OR;DUP 6] 5 optimize_id).

(*
 I: PUSH [tag] 551
 O: PUSH [tag] 551
*)
Compute pair "BottleCastle_run_code_of_0_block_426_1"%string (equiv_checker [PUSH 2 (NToWord WLen 0x227%N)] [PUSH 2 (NToWord WLen 0x227%N)] 0 optimize_id).

(*
 I: DUP3 DUP1 ADD PUSH 1 ADD DUP6
 O: DUP3 DUP4 ADD PUSH 1 ADD DUP6
*)
Compute pair "BottleCastle_run_code_of_0_block_427_0"%string (equiv_checker [DUP 3;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 6] [DUP 3;DUP 1;Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 6] 5 optimize_id).

(*
 I: DUP3 ISZERO PUSH [tag] 551
 O: DUP3 ISZERO PUSH [tag] 551
*)
Compute pair "BottleCastle_run_code_of_0_block_427_1"%string (equiv_checker [DUP 3;Opcode ISZERO;PUSH 2 (NToWord WLen 0x227%N)] [DUP 3;Opcode ISZERO;PUSH 2 (NToWord WLen 0x227%N)] 3 optimize_id).

(*
 I: SWAP2 DUP3 ADD
 O: DUP1 SWAP3 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_428_0"%string (equiv_checker [DUP 1;DUP 3;Opcode ADD] [DUP 2;DUP 3;Opcode ADD] 3 optimize_id).

(*
 I: DUP3 DUP2 GT ISZERO PUSH [tag] 551
 O: DUP3 DUP2 GT ISZERO PUSH [tag] 551
*)
Compute pair "BottleCastle_run_code_of_0_block_429_0"%string (equiv_checker [DUP 3;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x227%N)] [DUP 3;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x227%N)] 3 optimize_id).

(*
 I: DUP3 MLOAD DUP3
 O: DUP3 MLOAD DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_430_0"%string (equiv_checker [DUP 3;Opcode MLOAD;DUP 3] [DUP 3;Opcode MLOAD;DUP 3] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 SWAP1 PUSH 1 ADD SWAP1 PUSH [tag] 550
 O: SWAP2 PUSH 20 ADD SWAP2 SWAP1 PUSH 1 ADD SWAP1 PUSH [tag] 550
*)
Compute pair "BottleCastle_run_code_of_0_block_430_1"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1;PUSH 2 (NToWord WLen 0x226%N)] [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1;PUSH 2 (NToWord WLen 0x226%N)] 3 optimize_id).

(*
 I: POP PUSH [tag] 552 SWAP3 SWAP2 POP PUSH [tag] 553
 O: POP PUSH [tag] 553 PUSH [tag] 552 SWAP4 SWAP3 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_431_0"%string (equiv_checker [POP;PUSH 2 (NToWord WLen 0x229%N);PUSH 2 (NToWord WLen 0x228%N);DUP 4;DUP 3;POP] [POP;PUSH 2 (NToWord WLen 0x228%N);DUP 3;DUP 2;POP;PUSH 2 (NToWord WLen 0x229%N)] 4 optimize_id).

(*
 I: POP SWAP1
 O: POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_432_0"%string (equiv_checker [POP;DUP 1] [POP;DUP 1] 3 optimize_id).

(*
 I: DUP1 DUP3 GT ISZERO PUSH [tag] 552
 O: DUP1 DUP3 GT ISZERO PUSH [tag] 552
*)
Compute pair "BottleCastle_run_code_of_0_block_434_0"%string (equiv_checker [DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x228%N)] [DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x228%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP2
 O: PUSH 0 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_435_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2] [PUSH 1 (NToWord WLen 0x0%N);DUP 2] 1 optimize_id).

(*
 I: PUSH 1 ADD PUSH [tag] 554
 O: PUSH 1 ADD PUSH [tag] 554
*)
Compute pair "BottleCastle_run_code_of_0_block_435_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 2 (NToWord WLen 0x22a%N)] [PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 2 (NToWord WLen 0x22a%N)] 1 optimize_id).

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFF DUP1 DUP5 GT ISZERO PUSH [tag] 560
 O: PUSH 0 PUSH ffffffffffffffff DUP1 DUP5 GT ISZERO PUSH [tag] 560
*)
Compute pair "BottleCastle_run_code_of_0_block_436_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 8 (NToWord WLen 0xffffffffffffffff%N);DUP 1;DUP 5;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x230%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);DUP 1;DUP 5;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x230%N)] 2 optimize_id).

(*
 I: PUSH [tag] 560 PUSH [tag] 312
 O: PUSH [tag] 560 PUSH [tag] 312
*)
Compute pair "BottleCastle_run_code_of_0_block_437_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x230%N);PUSH 2 (NToWord WLen 0x138%N)] [PUSH 2 (NToWord WLen 0x230%N);PUSH 2 (NToWord WLen 0x138%N)] 0 optimize_id).

(*
 I: PUSH [tag] 562 PUSH [tag] 312
 O: PUSH [tag] 562 PUSH [tag] 312
*)
Compute pair "BottleCastle_run_code_of_0_block_439_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x232%N);PUSH 2 (NToWord WLen 0x138%N)] [PUSH 2 (NToWord WLen 0x232%N);PUSH 2 (NToWord WLen 0x138%N)] 0 optimize_id).

(*
 I: DUP2 PUSH 40
 O: DUP2 PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_440_0"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x40%N)] [DUP 2;PUSH 1 (NToWord WLen 0x40%N)] 2 optimize_id).

(*
 I: DUP1 SWAP4 POP DUP6 DUP2
 O: SWAP3 POP DUP3 DUP6 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_440_1"%string (equiv_checker [DUP 3;POP;DUP 3;DUP 6;DUP 2] [DUP 1;DUP 4;POP;DUP 6;DUP 2] 6 optimize_id).

(*
 I: DUP7 DUP7 DUP7 ADD GT ISZERO PUSH [tag] 563
 O: DUP7 DUP6 DUP8 ADD GT ISZERO PUSH [tag] 563
*)
Compute pair "BottleCastle_run_code_of_0_block_440_2"%string (equiv_checker [DUP 7;DUP 6;DUP 8;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x233%N)] [DUP 7;DUP 7;DUP 7;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x233%N)] 7 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_441_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP6 DUP6 PUSH 20 DUP4 ADD
 O: DUP6 DUP6 DUP3 PUSH 20 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_442_0"%string (equiv_checker [DUP 6;DUP 6;DUP 3;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD] [DUP 6;DUP 6;PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD] 6 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP8 DUP4 ADD ADD
 O: PUSH 0 PUSH 20 DUP3 DUP9 ADD ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_442_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 9;Opcode ADD;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 8;DUP 4;Opcode ADD;Opcode ADD] 6 optimize_id).

(*
 I: POP POP POP SWAP4 SWAP3 POP POP POP
 O: POP POP POP SWAP4 SWAP3 POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_442_2"%string (equiv_checker [POP;POP;POP;DUP 4;DUP 3;POP;POP;POP] [POP;POP;POP;DUP 4;DUP 3;POP;POP;POP] 8 optimize_id).

(*
 I: DUP1 CALLDATALOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP2 AND DUP2 EQ PUSH [tag] 566
 O: DUP1 CALLDATALOAD DUP1 PUSH 1 DUP1 PUSH a0 SHL SUB DUP2 AND EQ PUSH [tag] 566
*)
Compute pair "BottleCastle_run_code_of_0_block_443_0"%string (equiv_checker [DUP 1;Opcode CALLDATALOAD;DUP 1;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 2;Opcode AND;Opcode EQ;PUSH 2 (NToWord WLen 0x236%N)] [DUP 1;Opcode CALLDATALOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 2;Opcode AND;DUP 2;Opcode EQ;PUSH 2 (NToWord WLen 0x236%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_444_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_445_0"%string (equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: DUP1 CALLDATALOAD DUP1 ISZERO ISZERO DUP2 EQ PUSH [tag] 566
 O: DUP1 CALLDATALOAD DUP1 ISZERO ISZERO DUP2 EQ PUSH [tag] 566
*)
Compute pair "BottleCastle_run_code_of_0_block_446_0"%string (equiv_checker [DUP 1;Opcode CALLDATALOAD;DUP 1;Opcode ISZERO;Opcode ISZERO;DUP 2;Opcode EQ;PUSH 2 (NToWord WLen 0x236%N)] [DUP 1;Opcode CALLDATALOAD;DUP 1;Opcode ISZERO;Opcode ISZERO;DUP 2;Opcode EQ;PUSH 2 (NToWord WLen 0x236%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_447_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 571
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 571
*)
Compute pair "BottleCastle_run_code_of_0_block_448_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x23b%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x23b%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_449_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 412 DUP3 PUSH [tag] 564
 O: PUSH [tag] 412 DUP3 PUSH [tag] 564
*)
Compute pair "BottleCastle_run_code_of_0_block_450_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x19c%N);DUP 3;PUSH 2 (NToWord WLen 0x234%N)] [PUSH 2 (NToWord WLen 0x19c%N);DUP 3;PUSH 2 (NToWord WLen 0x234%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 574
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 574
*)
Compute pair "BottleCastle_run_code_of_0_block_451_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x23e%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x23e%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_452_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 575 DUP4 PUSH [tag] 564
 O: PUSH [tag] 575 DUP4 PUSH [tag] 564
*)
Compute pair "BottleCastle_run_code_of_0_block_453_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x23f%N);DUP 4;PUSH 2 (NToWord WLen 0x234%N)] [PUSH 2 (NToWord WLen 0x23f%N);DUP 4;PUSH 2 (NToWord WLen 0x234%N)] 3 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 576 PUSH 20 DUP5 ADD PUSH [tag] 564
 O: SWAP2 POP PUSH [tag] 576 PUSH 20 DUP5 ADD PUSH [tag] 564
*)
Compute pair "BottleCastle_run_code_of_0_block_454_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (NToWord WLen 0x240%N);PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;PUSH 2 (NToWord WLen 0x234%N)] [DUP 2;POP;PUSH 2 (NToWord WLen 0x240%N);PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;PUSH 2 (NToWord WLen 0x234%N)] 4 optimize_id).

(*
 I: SWAP1 POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP4 POP POP SWAP1 POP SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_455_0"%string (equiv_checker [DUP 4;POP;POP;DUP 1;POP;DUP 2] [DUP 1;POP;DUP 3;POP;DUP 3;DUP 1;POP] 6 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 0 PUSH 60 DUP5 DUP7 SUB SLT ISZERO PUSH [tag] 578
 O: PUSH 0 DUP1 DUP2 PUSH 60 DUP5 DUP7 SUB SLT ISZERO PUSH [tag] 578
*)
Compute pair "BottleCastle_run_code_of_0_block_456_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x60%N);DUP 5;DUP 7;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x242%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x60%N);DUP 5;DUP 7;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x242%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_457_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 579 DUP5 PUSH [tag] 564
 O: PUSH [tag] 579 DUP5 PUSH [tag] 564
*)
Compute pair "BottleCastle_run_code_of_0_block_458_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x243%N);DUP 5;PUSH 2 (NToWord WLen 0x234%N)] [PUSH 2 (NToWord WLen 0x243%N);DUP 5;PUSH 2 (NToWord WLen 0x234%N)] 4 optimize_id).

(*
 I: SWAP3 POP PUSH [tag] 580 PUSH 20 DUP6 ADD PUSH [tag] 564
 O: SWAP3 POP PUSH [tag] 580 DUP5 PUSH 20 ADD PUSH [tag] 564
*)
Compute pair "BottleCastle_run_code_of_0_block_459_0"%string (equiv_checker [DUP 3;POP;PUSH 2 (NToWord WLen 0x244%N);DUP 5;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x234%N)] [DUP 3;POP;PUSH 2 (NToWord WLen 0x244%N);PUSH 1 (NToWord WLen 0x20%N);DUP 6;Opcode ADD;PUSH 2 (NToWord WLen 0x234%N)] 5 optimize_id).

(*
 I: SWAP2 POP PUSH 40 DUP5 ADD CALLDATALOAD SWAP1 POP SWAP3 POP SWAP3 POP SWAP3
 O: SWAP4 PUSH 40 ADD CALLDATALOAD SWAP4 SWAP5 POP POP POP SWAP3
*)
Compute pair "BottleCastle_run_code_of_0_block_460_0"%string (equiv_checker [DUP 4;PUSH 1 (NToWord WLen 0x40%N);Opcode ADD;Opcode CALLDATALOAD;DUP 4;DUP 5;POP;POP;POP;DUP 3] [DUP 2;POP;PUSH 1 (NToWord WLen 0x40%N);DUP 5;Opcode ADD;Opcode CALLDATALOAD;DUP 1;POP;DUP 3;POP;DUP 3;POP;DUP 3] 7 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 0 DUP1 PUSH 80 DUP6 DUP8 SUB SLT ISZERO PUSH [tag] 582
 O: PUSH 0 DUP1 DUP1 DUP3 PUSH 80 DUP6 DUP8 SUB SLT ISZERO PUSH [tag] 582
*)
Compute pair "BottleCastle_run_code_of_0_block_461_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 1;DUP 3;PUSH 1 (NToWord WLen 0x80%N);DUP 6;DUP 8;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x246%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x80%N);DUP 6;DUP 8;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x246%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_462_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 583 DUP6 PUSH [tag] 564
 O: PUSH [tag] 583 DUP6 PUSH [tag] 564
*)
Compute pair "BottleCastle_run_code_of_0_block_463_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x247%N);DUP 6;PUSH 2 (NToWord WLen 0x234%N)] [PUSH 2 (NToWord WLen 0x247%N);DUP 6;PUSH 2 (NToWord WLen 0x234%N)] 5 optimize_id).

(*
 I: SWAP4 POP PUSH [tag] 584 PUSH 20 DUP7 ADD PUSH [tag] 564
 O: SWAP4 POP PUSH [tag] 584 PUSH 20 DUP7 ADD PUSH [tag] 564
*)
Compute pair "BottleCastle_run_code_of_0_block_464_0"%string (equiv_checker [DUP 4;POP;PUSH 2 (NToWord WLen 0x248%N);PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;PUSH 2 (NToWord WLen 0x234%N)] [DUP 4;POP;PUSH 2 (NToWord WLen 0x248%N);PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;PUSH 2 (NToWord WLen 0x234%N)] 6 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_466_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP6 ADD PUSH 1F DUP2 ADD DUP8 SGT PUSH [tag] 586
 O: DUP6 ADD DUP1 PUSH 1f ADD DUP8 GT PUSH [tag] 586
*)
Compute pair "BottleCastle_run_code_of_0_block_467_0"%string (equiv_checker [DUP 6;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;DUP 8;Opcode GT;PUSH 2 (NToWord WLen 0x24a%N)] [DUP 6;Opcode ADD;PUSH 1 (NToWord WLen 0x1F%N);DUP 2;Opcode ADD;DUP 8;Opcode SGT;PUSH 2 (NToWord WLen 0x24a%N)] 7 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_468_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 587 DUP8 DUP3 CALLDATALOAD PUSH 20 DUP5 ADD PUSH [tag] 557
 O: PUSH [tag] 587 DUP8 DUP3 CALLDATALOAD PUSH 20 DUP5 ADD PUSH [tag] 557
*)
Compute pair "BottleCastle_run_code_of_0_block_469_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x24b%N);DUP 8;DUP 3;Opcode CALLDATALOAD;PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;PUSH 2 (NToWord WLen 0x22d%N)] [PUSH 2 (NToWord WLen 0x24b%N);DUP 8;DUP 3;Opcode CALLDATALOAD;PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;PUSH 2 (NToWord WLen 0x22d%N)] 7 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP6 SWAP2 SWAP5 POP SWAP3 POP
 O: SWAP5 SWAP8 SWAP4 SWAP7 POP POP POP SWAP3 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_470_0"%string (equiv_checker [DUP 5;DUP 8;DUP 4;DUP 7;POP;POP;POP;DUP 3;POP] [DUP 2;POP;POP;DUP 3;DUP 6;DUP 2;DUP 5;POP;DUP 3;POP] 9 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 589
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 589
*)
Compute pair "BottleCastle_run_code_of_0_block_471_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x24d%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x24d%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_472_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 590 DUP4 PUSH [tag] 564
 O: PUSH [tag] 590 DUP4 PUSH [tag] 564
*)
Compute pair "BottleCastle_run_code_of_0_block_473_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x24e%N);DUP 4;PUSH 2 (NToWord WLen 0x234%N)] [PUSH 2 (NToWord WLen 0x24e%N);DUP 4;PUSH 2 (NToWord WLen 0x234%N)] 3 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 576 PUSH 20 DUP5 ADD PUSH [tag] 567
 O: SWAP2 POP PUSH [tag] 576 PUSH 20 DUP5 ADD PUSH [tag] 567
*)
Compute pair "BottleCastle_run_code_of_0_block_474_0"%string (equiv_checker [DUP 2;POP;PUSH 2 (NToWord WLen 0x240%N);PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;PUSH 2 (NToWord WLen 0x237%N)] [DUP 2;POP;PUSH 2 (NToWord WLen 0x240%N);PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;PUSH 2 (NToWord WLen 0x237%N)] 4 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 593
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 593
*)
Compute pair "BottleCastle_run_code_of_0_block_475_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x251%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x251%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_476_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 594 DUP4 PUSH [tag] 564
 O: PUSH [tag] 594 DUP4 PUSH [tag] 564
*)
Compute pair "BottleCastle_run_code_of_0_block_477_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x252%N);DUP 4;PUSH 2 (NToWord WLen 0x234%N)] [PUSH 2 (NToWord WLen 0x252%N);DUP 4;PUSH 2 (NToWord WLen 0x234%N)] 3 optimize_id).

(*
 I: SWAP5 PUSH 20 SWAP4 SWAP1 SWAP4 ADD CALLDATALOAD SWAP4 POP POP POP
 O: SWAP5 SWAP3 PUSH 20 ADD CALLDATALOAD SWAP4 POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_478_0"%string (equiv_checker [DUP 5;DUP 3;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;Opcode CALLDATALOAD;DUP 4;POP;POP;POP] [DUP 5;PUSH 1 (NToWord WLen 0x20%N);DUP 4;DUP 1;DUP 4;Opcode ADD;Opcode CALLDATALOAD;DUP 4;POP;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 596
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 596
*)
Compute pair "BottleCastle_run_code_of_0_block_479_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x254%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x254%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_480_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 412 DUP3 PUSH [tag] 567
 O: PUSH [tag] 412 DUP3 PUSH [tag] 567
*)
Compute pair "BottleCastle_run_code_of_0_block_481_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x19c%N);DUP 3;PUSH 2 (NToWord WLen 0x237%N)] [PUSH 2 (NToWord WLen 0x19c%N);DUP 3;PUSH 2 (NToWord WLen 0x237%N)] 2 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 599
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 599
*)
Compute pair "BottleCastle_run_code_of_0_block_482_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x257%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x257%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_483_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP2 CALLDATALOAD PUSH [tag] 412 DUP2 PUSH [tag] 601
 O: DUP2 CALLDATALOAD PUSH [tag] 412 DUP2 PUSH [tag] 601
*)
Compute pair "BottleCastle_run_code_of_0_block_484_0"%string (equiv_checker [DUP 2;Opcode CALLDATALOAD;PUSH 2 (NToWord WLen 0x19c%N);DUP 2;PUSH 2 (NToWord WLen 0x259%N)] [DUP 2;Opcode CALLDATALOAD;PUSH 2 (NToWord WLen 0x19c%N);DUP 2;PUSH 2 (NToWord WLen 0x259%N)] 2 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 603
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 603
*)
Compute pair "BottleCastle_run_code_of_0_block_485_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x25b%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x25b%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_486_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP2 MLOAD PUSH [tag] 412 DUP2 PUSH [tag] 601
 O: DUP2 MLOAD PUSH [tag] 412 DUP2 PUSH [tag] 601
*)
Compute pair "BottleCastle_run_code_of_0_block_487_0"%string (equiv_checker [DUP 2;Opcode MLOAD;PUSH 2 (NToWord WLen 0x19c%N);DUP 2;PUSH 2 (NToWord WLen 0x259%N)] [DUP 2;Opcode MLOAD;PUSH 2 (NToWord WLen 0x19c%N);DUP 2;PUSH 2 (NToWord WLen 0x259%N)] 2 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 606
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 606
*)
Compute pair "BottleCastle_run_code_of_0_block_488_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x25e%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x25e%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_489_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP2 CALLDATALOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 607
 O: DUP2 CALLDATALOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 607
*)
Compute pair "BottleCastle_run_code_of_0_block_490_0"%string (equiv_checker [DUP 2;Opcode CALLDATALOAD;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x25f%N)] [DUP 2;Opcode CALLDATALOAD;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x25f%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_491_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP3 ADD PUSH 1F DUP2 ADD DUP5 SGT PUSH [tag] 608
 O: DUP3 ADD DUP1 PUSH 1f ADD DUP5 GT PUSH [tag] 608
*)
Compute pair "BottleCastle_run_code_of_0_block_492_0"%string (equiv_checker [DUP 3;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;DUP 5;Opcode GT;PUSH 2 (NToWord WLen 0x260%N)] [DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x1F%N);DUP 2;Opcode ADD;DUP 5;Opcode SGT;PUSH 2 (NToWord WLen 0x260%N)] 4 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_493_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 491 DUP5 DUP3 CALLDATALOAD PUSH 20 DUP5 ADD PUSH [tag] 557
 O: PUSH [tag] 491 DUP5 DUP3 CALLDATALOAD DUP4 PUSH 20 ADD PUSH [tag] 557
*)
Compute pair "BottleCastle_run_code_of_0_block_494_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x1eb%N);DUP 5;DUP 3;Opcode CALLDATALOAD;DUP 4;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x22d%N)] [PUSH 2 (NToWord WLen 0x1eb%N);DUP 5;DUP 3;Opcode CALLDATALOAD;PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;PUSH 2 (NToWord WLen 0x22d%N)] 4 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 611
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 611
*)
Compute pair "BottleCastle_run_code_of_0_block_495_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x263%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x263%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_496_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP CALLDATALOAD SWAP2 SWAP1 POP
 O: POP SWAP1 POP CALLDATALOAD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_497_0"%string (equiv_checker [POP;DUP 1;POP;Opcode CALLDATALOAD;DUP 1] [POP;Opcode CALLDATALOAD;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 613
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 613
*)
Compute pair "BottleCastle_run_code_of_0_block_498_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x265%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x265%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_499_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP3 CALLDATALOAD SWAP2 POP PUSH [tag] 576 PUSH 20 DUP5 ADD PUSH [tag] 564
 O: PUSH [tag] 576 PUSH 20 DUP5 DUP1 CALLDATALOAD SWAP5 POP ADD PUSH [tag] 564
*)
Compute pair "BottleCastle_run_code_of_0_block_500_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x240%N);PUSH 1 (NToWord WLen 0x20%N);DUP 5;DUP 1;Opcode CALLDATALOAD;DUP 5;POP;Opcode ADD;PUSH 2 (NToWord WLen 0x234%N)] [DUP 3;Opcode CALLDATALOAD;DUP 2;POP;PUSH 2 (NToWord WLen 0x240%N);PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;PUSH 2 (NToWord WLen 0x234%N)] 3 optimize_id).

(*
 I: PUSH 0 DUP2 MLOAD DUP1 DUP5
 O: PUSH 0 DUP2 MLOAD DUP1 DUP5
*)
Compute pair "BottleCastle_run_code_of_0_block_501_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode MLOAD;DUP 1;DUP 5] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode MLOAD;DUP 1;DUP 5] 2 optimize_id).

(*
 I: PUSH [tag] 617 DUP2 PUSH 20 DUP7 ADD PUSH 20 DUP7 ADD PUSH [tag] 618
 O: PUSH [tag] 617 DUP2 PUSH 20 DUP7 ADD DUP6 PUSH 20 ADD PUSH [tag] 618
*)
Compute pair "BottleCastle_run_code_of_0_block_501_1"%string (equiv_checker [PUSH 2 (NToWord WLen 0x269%N);DUP 2;PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;DUP 6;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x26a%N)] [PUSH 2 (NToWord WLen 0x269%N);DUP 2;PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;PUSH 2 (NToWord WLen 0x26a%N)] 4 optimize_id).

(*
 I: PUSH 1F ADD PUSH 1F NOT AND SWAP3 SWAP1 SWAP3 ADD PUSH 20 ADD SWAP3 SWAP2 POP POP
 O: PUSH 1f ADD SWAP2 POP POP PUSH 1f NOT AND ADD PUSH 20 ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_502_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;DUP 2;POP;POP;PUSH 1 (NToWord WLen 0x1f%N);Opcode NOT;Opcode AND;Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 1] [PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;Opcode AND;DUP 3;DUP 1;DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;DUP 2;POP;POP] 5 optimize_id).

(*
 I: PUSH 0 DUP5 MLOAD PUSH 20 PUSH [tag] 620 DUP3 DUP6 DUP4 DUP11 ADD PUSH [tag] 618
 O: PUSH 0 DUP5 MLOAD PUSH 20 PUSH [tag] 620 DUP3 DUP6 DUP4 DUP11 ADD PUSH [tag] 618
*)
Compute pair "BottleCastle_run_code_of_0_block_503_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 5;Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x26c%N);DUP 3;DUP 6;DUP 4;DUP 11;Opcode ADD;PUSH 2 (NToWord WLen 0x26a%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 5;Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);PUSH 2 (NToWord WLen 0x26c%N);DUP 3;DUP 6;DUP 4;DUP 11;Opcode ADD;PUSH 2 (NToWord WLen 0x26a%N)] 4 optimize_id).

(*
 I: DUP6 MLOAD SWAP2 DUP5 ADD SWAP2 PUSH [tag] 621 DUP2 DUP5 DUP5 DUP11 ADD PUSH [tag] 618
 O: DUP6 MLOAD PUSH [tag] 621 DUP2 DUP4 DUP10 ADD SWAP5 DUP8 ADD DUP1 SWAP6 PUSH [tag] 618
*)
Compute pair "BottleCastle_run_code_of_0_block_504_0"%string (equiv_checker [DUP 6;Opcode MLOAD;PUSH 2 (NToWord WLen 0x26d%N);DUP 2;DUP 4;DUP 10;Opcode ADD;DUP 5;DUP 8;Opcode ADD;DUP 1;DUP 6;PUSH 2 (NToWord WLen 0x26a%N)] [DUP 6;Opcode MLOAD;DUP 2;DUP 5;Opcode ADD;DUP 2;PUSH 2 (NToWord WLen 0x26d%N);DUP 2;DUP 5;DUP 5;DUP 11;Opcode ADD;PUSH 2 (NToWord WLen 0x26a%N)] 6 optimize_id).

(*
 I: DUP6 SLOAD SWAP3 ADD SWAP2 PUSH 0 SWAP1 PUSH 1 DUP2 DUP2 SHR SWAP1 DUP1 DUP4 AND DUP1 PUSH [tag] 622
 O: PUSH 1 SWAP3 ADD DUP6 SLOAD DUP1 DUP5 SHR DUP5 DUP3 AND PUSH 0 SWAP4 SWAP6 SWAP1 DUP1 PUSH [tag] 622
*)
Compute pair "BottleCastle_run_code_of_0_block_505_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 3;Opcode ADD;DUP 6;Opcode SLOAD;DUP 1;DUP 5;Opcode SHR;DUP 5;DUP 3;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 6;DUP 1;DUP 1;PUSH 2 (NToWord WLen 0x26e%N)] [DUP 6;Opcode SLOAD;DUP 3;Opcode ADD;DUP 2;PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x1%N);DUP 2;DUP 2;Opcode SHR;DUP 1;DUP 1;DUP 4;Opcode AND;DUP 1;PUSH 2 (NToWord WLen 0x26e%N)] 6 optimize_id).

(*
 I: PUSH 7F DUP4 AND SWAP3 POP
 O: SWAP2 PUSH 7f AND SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_506_0"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x7f%N);Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x7F%N);DUP 4;Opcode AND;DUP 3;POP] 3 optimize_id).

(*
 I: DUP6 DUP4 LT DUP2 EQ ISZERO PUSH [tag] 623
 O: DUP6 DUP4 LT DUP2 EQ ISZERO PUSH [tag] 623
*)
Compute pair "BottleCastle_run_code_of_0_block_507_0"%string (equiv_checker [DUP 6;DUP 4;Opcode LT;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x26f%N)] [DUP 6;DUP 4;Opcode LT;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x26f%N)] 6 optimize_id).

(*
 I: PUSH 4E487B71 PUSH E0 SHL DUP6
 O: PUSH 4e487b71 PUSH e0 SHL DUP6
*)
Compute pair "BottleCastle_run_code_of_0_block_508_0"%string (equiv_checker [PUSH 4 (NToWord WLen 0x4e487b71%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;DUP 6] [PUSH 4 (NToWord WLen 0x4E487B71%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;DUP 6] 5 optimize_id).

(*
 I: PUSH 22 PUSH 4
 O: PUSH 22 PUSH 4
*)
Compute pair "BottleCastle_run_code_of_0_block_508_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x22%N);PUSH 1 (NToWord WLen 0x4%N)] [PUSH 1 (NToWord WLen 0x22%N);PUSH 1 (NToWord WLen 0x4%N)] 0 optimize_id).

(*
 I: PUSH 24 DUP6
 O: PUSH 24 DUP6
*)
Compute pair "BottleCastle_run_code_of_0_block_508_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);DUP 6] [PUSH 1 (NToWord WLen 0x24%N);DUP 6] 5 optimize_id).

(*
 I: DUP1 DUP1 ISZERO PUSH [tag] 625
 O: DUP1 DUP2 ISZERO PUSH [tag] 625
*)
Compute pair "BottleCastle_run_code_of_0_block_509_0"%string (equiv_checker [DUP 1;DUP 2;Opcode ISZERO;PUSH 2 (NToWord WLen 0x271%N)] [DUP 1;DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x271%N)] 1 optimize_id).

(*
 I: PUSH 1 DUP2 EQ PUSH [tag] 626
 O: DUP1 PUSH 1 EQ PUSH [tag] 626
*)
Compute pair "BottleCastle_run_code_of_0_block_510_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode EQ;PUSH 2 (NToWord WLen 0x272%N)] [PUSH 1 (NToWord WLen 0x1%N);DUP 2;Opcode EQ;PUSH 2 (NToWord WLen 0x272%N)] 1 optimize_id).

(*
 I: PUSH [tag] 624
 O: PUSH [tag] 624
*)
Compute pair "BottleCastle_run_code_of_0_block_511_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x270%N)] [PUSH 2 (NToWord WLen 0x270%N)] 0 optimize_id).

(*
 I: PUSH FF NOT DUP6 AND DUP9
 O: PUSH ff NOT DUP6 AND DUP9
*)
Compute pair "BottleCastle_run_code_of_0_block_512_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xff%N);Opcode NOT;DUP 6;Opcode AND;DUP 9] [PUSH 1 (NToWord WLen 0xFF%N);Opcode NOT;DUP 6;Opcode AND;DUP 9] 8 optimize_id).

(*
 I: DUP4 DUP9 ADD SWAP6 POP PUSH [tag] 624
 O: DUP8 DUP5 ADD SWAP6 POP PUSH [tag] 624
*)
Compute pair "BottleCastle_run_code_of_0_block_512_1"%string (equiv_checker [DUP 8;DUP 5;Opcode ADD;DUP 6;POP;PUSH 2 (NToWord WLen 0x270%N)] [DUP 4;DUP 9;Opcode ADD;DUP 6;POP;PUSH 2 (NToWord WLen 0x270%N)] 8 optimize_id).

(*
 I: PUSH 0 DUP12 DUP2
 O: PUSH 0 DUP12 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_513_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 12;DUP 2] [PUSH 1 (NToWord WLen 0x0%N);DUP 12;DUP 2] 11 optimize_id).

(*
 I: PUSH 20 SWAP1 KECCAK256 PUSH 0
 O: PUSH 20 SWAP1 KECCAK256 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_513_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 1;Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 1;Opcode KECCAK256;PUSH 1 (NToWord WLen 0x0%N)] 1 optimize_id).

(*
 I: DUP6 DUP2 LT ISZERO PUSH [tag] 631
 O: DUP6 DUP2 LT ISZERO PUSH [tag] 631
*)
Compute pair "BottleCastle_run_code_of_0_block_514_0"%string (equiv_checker [DUP 6;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x277%N)] [DUP 6;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x277%N)] 6 optimize_id).

(*
 I: DUP2 SLOAD DUP11 DUP3 ADD
 O: DUP2 SLOAD DUP2 DUP12 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_515_0"%string (equiv_checker [DUP 2;Opcode SLOAD;DUP 2;DUP 12;Opcode ADD] [DUP 2;Opcode SLOAD;DUP 11;DUP 3;Opcode ADD] 10 optimize_id).

(*
 I: SWAP1 DUP5 ADD SWAP1 DUP9 ADD PUSH [tag] 629
 O: DUP9 ADD PUSH [tag] 629 SWAP2 DUP6 ADD SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_515_1"%string (equiv_checker [DUP 9;Opcode ADD;PUSH 2 (NToWord WLen 0x275%N);DUP 2;DUP 6;Opcode ADD;DUP 2] [DUP 1;DUP 5;Opcode ADD;DUP 1;DUP 9;Opcode ADD;PUSH 2 (NToWord WLen 0x275%N)] 9 optimize_id).

(*
 I: POP POP DUP4 DUP9 ADD SWAP6 POP
 O: POP POP DUP4 DUP9 ADD SWAP6 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_516_0"%string (equiv_checker [POP;POP;DUP 4;DUP 9;Opcode ADD;DUP 6;POP] [POP;POP;DUP 4;DUP 9;Opcode ADD;DUP 6;POP] 10 optimize_id).

(*
 I: POP SWAP4 SWAP12 SWAP11 POP POP POP POP POP POP POP POP POP POP POP
 O: POP POP POP POP POP SWAP7 POP POP POP POP POP POP POP SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_517_0"%string (equiv_checker [POP;POP;POP;POP;POP;DUP 7;POP;POP;POP;POP;POP;POP;POP;DUP 1] [POP;DUP 4;DUP 12;DUP 11;POP;POP;POP;POP;POP;POP;POP;POP;POP;POP;POP] 14 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP6 DUP2 AND DUP3
 O: PUSH 1 DUP1 PUSH a0 SHL SUB DUP1 DUP7 AND DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_518_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 1;DUP 7;Opcode AND;DUP 3] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 6;DUP 2;Opcode AND;DUP 3] 5 optimize_id).

(*
 I: DUP5 AND PUSH 20 DUP3 ADD
 O: DUP5 AND PUSH 20 DUP3 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_518_1"%string (equiv_checker [DUP 5;Opcode AND;PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD] [DUP 5;Opcode AND;PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD] 5 optimize_id).

(*
 I: PUSH 40 DUP2 ADD DUP4 SWAP1
 O: DUP3 DUP2 PUSH 40 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_518_2"%string (equiv_checker [DUP 3;DUP 2;PUSH 1 (NToWord WLen 0x40%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x40%N);DUP 2;Opcode ADD;DUP 4;DUP 1] 3 optimize_id).

(*
 I: PUSH 80 PUSH 60 DUP3 ADD DUP2 SWAP1
 O: PUSH 80 DUP1 DUP3 PUSH 60 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_518_3"%string (equiv_checker [PUSH 1 (NToWord WLen 0x80%N);DUP 1;DUP 3;PUSH 1 (NToWord WLen 0x60%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x80%N);PUSH 1 (NToWord WLen 0x60%N);DUP 3;Opcode ADD;DUP 2;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 SWAP1 PUSH [tag] 634 SWAP1 DUP4 ADD DUP5 PUSH [tag] 615
 O: PUSH [tag] 634 PUSH 0 SWAP2 DUP4 ADD DUP5 PUSH [tag] 615
*)
Compute pair "BottleCastle_run_code_of_0_block_518_4"%string (equiv_checker [PUSH 2 (NToWord WLen 0x27a%N);PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 4;Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x267%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 2 (NToWord WLen 0x27a%N);DUP 1;DUP 4;Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x267%N)] 3 optimize_id).

(*
 I: SWAP7 SWAP6 POP POP POP POP POP POP
 O: SWAP7 SWAP6 POP POP POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_519_0"%string (equiv_checker [DUP 7;DUP 6;POP;POP;POP;POP;POP;POP] [DUP 7;DUP 6;POP;POP;POP;POP;POP;POP] 8 optimize_id).

(*
 I: PUSH 20 DUP1 DUP3
 O: PUSH 20 DUP1 DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_520_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 3] [PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 3] 1 optimize_id).

(*
 I: DUP3 MLOAD DUP3 DUP3 ADD DUP2 SWAP1
 O: DUP3 MLOAD DUP1 DUP3 DUP5 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_520_1"%string (equiv_checker [DUP 3;Opcode MLOAD;DUP 1;DUP 3;DUP 5;Opcode ADD] [DUP 3;Opcode MLOAD;DUP 3;DUP 3;Opcode ADD;DUP 2;DUP 1] 3 optimize_id).

(*
 I: PUSH 0 SWAP2 SWAP1 DUP5 DUP3 ADD SWAP1 PUSH 40 DUP6 ADD SWAP1 DUP5
 O: SWAP1 DUP1 DUP5 ADD PUSH 40 DUP5 ADD PUSH 0 SWAP4 DUP5
*)
Compute pair "BottleCastle_run_code_of_0_block_520_2"%string (equiv_checker [DUP 1;DUP 1;DUP 5;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);DUP 5;Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 5] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 1;DUP 5;DUP 3;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 6;Opcode ADD;DUP 1;DUP 5] 4 optimize_id).

(*
 I: DUP2 DUP2 LT ISZERO PUSH [tag] 317
 O: DUP2 DUP2 LT ISZERO PUSH [tag] 317
*)
Compute pair "BottleCastle_run_code_of_0_block_521_0"%string (equiv_checker [DUP 2;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x13d%N)] [DUP 2;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x13d%N)] 2 optimize_id).

(*
 I: DUP4 MLOAD DUP4
 O: DUP4 MLOAD DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_522_0"%string (equiv_checker [DUP 4;Opcode MLOAD;DUP 4] [DUP 4;Opcode MLOAD;DUP 4] 4 optimize_id).

(*
 I: SWAP3 DUP5 ADD SWAP3 SWAP2 DUP5 ADD SWAP2 PUSH 1 ADD PUSH [tag] 636
 O: PUSH 1 ADD DUP5 PUSH [tag] 636 SWAP5 ADD SWAP4 SWAP3 DUP6 ADD SWAP3
*)
Compute pair "BottleCastle_run_code_of_0_block_522_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x27c%N);DUP 5;Opcode ADD;DUP 4;DUP 3;DUP 6;Opcode ADD;DUP 3] [DUP 3;DUP 5;Opcode ADD;DUP 3;DUP 2;DUP 5;Opcode ADD;DUP 2;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 2 (NToWord WLen 0x27c%N)] 5 optimize_id).

(*
 I: PUSH 20 DUP2
 O: PUSH 20 DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_523_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 2] [PUSH 1 (NToWord WLen 0x20%N);DUP 2] 1 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 412 PUSH 20 DUP4 ADD DUP5 PUSH [tag] 615
 O: PUSH 0 PUSH [tag] 412 DUP3 PUSH 20 ADD DUP5 PUSH [tag] 615
*)
Compute pair "BottleCastle_run_code_of_0_block_523_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x19c%N);DUP 3;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x267%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x19c%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x267%N)] 2 optimize_id).

(*
 I: PUSH 20 DUP1 DUP3
 O: PUSH 20 DUP1 DUP3
*)
Compute pair "BottleCastle_run_code_of_0_block_524_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 3] [PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 3] 1 optimize_id).

(*
 I: PUSH 1F SWAP1 DUP3 ADD
 O: DUP2 PUSH 1f SWAP2 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_524_1"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x1f%N);DUP 2;Opcode ADD] [PUSH 1 (NToWord WLen 0x1F%N);DUP 1;DUP 3;Opcode ADD] 2 optimize_id).

(*
 I: PUSH 5265656E7472616E637947756172643A207265656E7472616E742063616C6C00 PUSH 40 DUP3 ADD
 O: PUSH 5265656e7472616e637947756172643a207265656e7472616e742063616c6c00 DUP2 PUSH 40 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_524_2"%string (equiv_checker [PUSH 32 (NToWord WLen 0x5265656e7472616e637947756172643a207265656e7472616e742063616c6c00%N);DUP 2;PUSH 1 (NToWord WLen 0x40%N);Opcode ADD] [PUSH 32 (NToWord WLen 0x5265656E7472616E637947756172643A207265656E7472616E742063616C6C00%N);PUSH 1 (NToWord WLen 0x40%N);DUP 3;Opcode ADD] 1 optimize_id).

(*
 I: PUSH 60 ADD SWAP1
 O: PUSH 60 ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_524_3"%string (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);Opcode ADD;DUP 1] [PUSH 1 (NToWord WLen 0x60%N);Opcode ADD;DUP 1] 2 optimize_id).

(*
 I: PUSH 0 DUP3 NOT DUP3 GT ISZERO PUSH [tag] 656
 O: PUSH 0 DUP3 NOT DUP3 GT ISZERO PUSH [tag] 656
*)
Compute pair "BottleCastle_run_code_of_0_block_525_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;Opcode NOT;DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x290%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;Opcode NOT;DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x290%N)] 2 optimize_id).

(*
 I: PUSH [tag] 656 PUSH [tag] 657
 O: PUSH [tag] 656 PUSH [tag] 657
*)
Compute pair "BottleCastle_run_code_of_0_block_526_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x290%N);PUSH 2 (NToWord WLen 0x291%N)] [PUSH 2 (NToWord WLen 0x290%N);PUSH 2 (NToWord WLen 0x291%N)] 0 optimize_id).

(*
 I: POP ADD SWAP1
 O: POP ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_527_0"%string (equiv_checker [POP;Opcode ADD;DUP 1] [POP;Opcode ADD;DUP 1] 4 optimize_id).

(*
 I: PUSH 0 DUP3 PUSH [tag] 660
 O: PUSH 0 DUP3 PUSH [tag] 660
*)
Compute pair "BottleCastle_run_code_of_0_block_528_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;PUSH 2 (NToWord WLen 0x294%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;PUSH 2 (NToWord WLen 0x294%N)] 2 optimize_id).

(*
 I: PUSH [tag] 660 PUSH [tag] 661
 O: PUSH [tag] 660 PUSH [tag] 661
*)
Compute pair "BottleCastle_run_code_of_0_block_529_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x294%N);PUSH 2 (NToWord WLen 0x295%N)] [PUSH 2 (NToWord WLen 0x294%N);PUSH 2 (NToWord WLen 0x295%N)] 0 optimize_id).

(*
 I: POP DIV SWAP1
 O: POP DIV SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_530_0"%string (equiv_checker [POP;Opcode DIV;DUP 1] [POP;Opcode DIV;DUP 1] 4 optimize_id).

(*
 I: PUSH 0 DUP2 PUSH 0 NOT DIV DUP4 GT DUP3 ISZERO ISZERO AND ISZERO PUSH [tag] 664
 O: PUSH 0 DUP2 DUP2 NOT DIV DUP4 GT DUP3 ISZERO ISZERO AND ISZERO PUSH [tag] 664
*)
Compute pair "BottleCastle_run_code_of_0_block_531_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2;Opcode NOT;Opcode DIV;DUP 4;Opcode GT;DUP 3;Opcode ISZERO;Opcode ISZERO;Opcode AND;Opcode ISZERO;PUSH 2 (NToWord WLen 0x298%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;Opcode DIV;DUP 4;Opcode GT;DUP 3;Opcode ISZERO;Opcode ISZERO;Opcode AND;Opcode ISZERO;PUSH 2 (NToWord WLen 0x298%N)] 2 optimize_id).

(*
 I: PUSH [tag] 664 PUSH [tag] 657
 O: PUSH [tag] 664 PUSH [tag] 657
*)
Compute pair "BottleCastle_run_code_of_0_block_532_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x298%N);PUSH 2 (NToWord WLen 0x291%N)] [PUSH 2 (NToWord WLen 0x298%N);PUSH 2 (NToWord WLen 0x291%N)] 0 optimize_id).

(*
 I: POP MUL SWAP1
 O: POP MUL SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_533_0"%string (equiv_checker [POP;Opcode MUL;DUP 1] [POP;Opcode MUL;DUP 1] 4 optimize_id).

(*
 I: PUSH 0 DUP3 DUP3 LT ISZERO PUSH [tag] 667
 O: PUSH 0 DUP3 DUP3 LT ISZERO PUSH [tag] 667
*)
Compute pair "BottleCastle_run_code_of_0_block_534_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 3;Opcode LT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x29b%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 3;Opcode LT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x29b%N)] 2 optimize_id).

(*
 I: PUSH [tag] 667 PUSH [tag] 657
 O: PUSH [tag] 667 PUSH [tag] 657
*)
Compute pair "BottleCastle_run_code_of_0_block_535_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x29b%N);PUSH 2 (NToWord WLen 0x291%N)] [PUSH 2 (NToWord WLen 0x29b%N);PUSH 2 (NToWord WLen 0x291%N)] 0 optimize_id).

(*
 I: POP SUB SWAP1
 O: POP SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_536_0"%string (equiv_checker [POP;Opcode SUB;DUP 1] [POP;Opcode SUB;DUP 1] 4 optimize_id).

(*
 I: PUSH 0
 O: PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_537_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: DUP4 DUP2 LT ISZERO PUSH [tag] 671
 O: DUP4 DUP2 LT ISZERO PUSH [tag] 671
*)
Compute pair "BottleCastle_run_code_of_0_block_538_0"%string (equiv_checker [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x29f%N)] [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x29f%N)] 4 optimize_id).

(*
 I: DUP2 DUP2 ADD MLOAD DUP4 DUP3 ADD
 O: DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_539_0"%string (equiv_checker [DUP 1;DUP 3;Opcode ADD;Opcode MLOAD;DUP 2;DUP 5;Opcode ADD] [DUP 2;DUP 2;Opcode ADD;Opcode MLOAD;DUP 4;DUP 3;Opcode ADD] 3 optimize_id).

(*
 I: PUSH 20 ADD PUSH [tag] 669
 O: PUSH 20 ADD PUSH [tag] 669
*)
Compute pair "BottleCastle_run_code_of_0_block_539_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x29d%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x29d%N)] 1 optimize_id).

(*
 I: DUP4 DUP2 GT ISZERO PUSH [tag] 380
 O: DUP4 DUP2 GT ISZERO PUSH [tag] 380
*)
Compute pair "BottleCastle_run_code_of_0_block_540_0"%string (equiv_checker [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x17c%N)] [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x17c%N)] 4 optimize_id).

(*
 I: POP POP PUSH 0 SWAP2 ADD
 O: POP POP ADD PUSH 0 SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_541_0"%string (equiv_checker [POP;POP;Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);DUP 1] [POP;POP;PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode ADD] 4 optimize_id).

(*
 I: PUSH 1 DUP2 DUP2 SHR SWAP1 DUP3 AND DUP1 PUSH [tag] 674
 O: DUP1 PUSH 1 SHR DUP2 PUSH 1 AND DUP1 PUSH [tag] 674
*)
Compute pair "BottleCastle_run_code_of_0_block_542_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode SHR;DUP 2;PUSH 1 (NToWord WLen 0x1%N);Opcode AND;DUP 1;PUSH 2 (NToWord WLen 0x2a2%N)] [PUSH 1 (NToWord WLen 0x1%N);DUP 2;DUP 2;Opcode SHR;DUP 1;DUP 3;Opcode AND;DUP 1;PUSH 2 (NToWord WLen 0x2a2%N)] 1 optimize_id).

(*
 I: PUSH 7F DUP3 AND SWAP2 POP
 O: SWAP1 PUSH 7f AND SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_543_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x7f%N);Opcode AND;DUP 1] [PUSH 1 (NToWord WLen 0x7F%N);DUP 3;Opcode AND;DUP 2;POP] 2 optimize_id).

(*
 I: PUSH 20 DUP3 LT DUP2 EQ ISZERO PUSH [tag] 675
 O: DUP1 PUSH 20 DUP4 LT EQ ISZERO PUSH [tag] 675
*)
Compute pair "BottleCastle_run_code_of_0_block_544_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode LT;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x2a3%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode LT;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x2a3%N)] 2 optimize_id).

(*
 I: PUSH 4E487B71 PUSH E0 SHL PUSH 0
 O: PUSH 4e487b71 PUSH e0 SHL PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_545_0"%string (equiv_checker [PUSH 4 (NToWord WLen 0x4e487b71%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] [PUSH 4 (NToWord WLen 0x4E487B71%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 22 PUSH 4
 O: PUSH 22 PUSH 4
*)
Compute pair "BottleCastle_run_code_of_0_block_545_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x22%N);PUSH 1 (NToWord WLen 0x4%N)] [PUSH 1 (NToWord WLen 0x22%N);PUSH 1 (NToWord WLen 0x4%N)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_545_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: POP SWAP2 SWAP1 POP
 O: POP SWAP2 SWAP1 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_546_0"%string (equiv_checker [POP;DUP 2;DUP 1;POP] [POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 PUSH 0 NOT DUP3 EQ ISZERO PUSH [tag] 678
 O: PUSH 0 DUP2 DUP2 NOT EQ ISZERO PUSH [tag] 678
*)
Compute pair "BottleCastle_run_code_of_0_block_547_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2;Opcode NOT;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x2a6%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;DUP 3;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x2a6%N)] 1 optimize_id).

(*
 I: PUSH [tag] 678 PUSH [tag] 657
 O: PUSH [tag] 678 PUSH [tag] 657
*)
Compute pair "BottleCastle_run_code_of_0_block_548_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x2a6%N);PUSH 2 (NToWord WLen 0x291%N)] [PUSH 2 (NToWord WLen 0x2a6%N);PUSH 2 (NToWord WLen 0x291%N)] 0 optimize_id).

(*
 I: POP PUSH 1 ADD SWAP1
 O: POP PUSH 1 ADD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_549_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1] [POP;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1] 3 optimize_id).

(*
 I: PUSH 0 DUP3 PUSH [tag] 681
 O: PUSH 0 DUP3 PUSH [tag] 681
*)
Compute pair "BottleCastle_run_code_of_0_block_550_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;PUSH 2 (NToWord WLen 0x2a9%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;PUSH 2 (NToWord WLen 0x2a9%N)] 2 optimize_id).

(*
 I: PUSH [tag] 681 PUSH [tag] 661
 O: PUSH [tag] 681 PUSH [tag] 661
*)
Compute pair "BottleCastle_run_code_of_0_block_551_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x2a9%N);PUSH 2 (NToWord WLen 0x295%N)] [PUSH 2 (NToWord WLen 0x2a9%N);PUSH 2 (NToWord WLen 0x295%N)] 0 optimize_id).

(*
 I: POP MOD SWAP1
 O: POP MOD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_552_0"%string (equiv_checker [POP;Opcode MOD;DUP 1] [POP;Opcode MOD;DUP 1] 4 optimize_id).

(*
 I: PUSH 4E487B71 PUSH E0 SHL PUSH 0
 O: PUSH 4e487b71 PUSH e0 SHL PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_553_0"%string (equiv_checker [PUSH 4 (NToWord WLen 0x4e487b71%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] [PUSH 4 (NToWord WLen 0x4E487B71%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 11 PUSH 4
 O: PUSH 11 PUSH 4
*)
Compute pair "BottleCastle_run_code_of_0_block_553_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x11%N);PUSH 1 (NToWord WLen 0x4%N)] [PUSH 1 (NToWord WLen 0x11%N);PUSH 1 (NToWord WLen 0x4%N)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_553_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 4E487B71 PUSH E0 SHL PUSH 0
 O: PUSH 4e487b71 PUSH e0 SHL PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_554_0"%string (equiv_checker [PUSH 4 (NToWord WLen 0x4e487b71%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] [PUSH 4 (NToWord WLen 0x4E487B71%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 12 PUSH 4
 O: PUSH 12 PUSH 4
*)
Compute pair "BottleCastle_run_code_of_0_block_554_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x12%N);PUSH 1 (NToWord WLen 0x4%N)] [PUSH 1 (NToWord WLen 0x12%N);PUSH 1 (NToWord WLen 0x4%N)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_554_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 4E487B71 PUSH E0 SHL PUSH 0
 O: PUSH 4e487b71 PUSH e0 SHL PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_555_0"%string (equiv_checker [PUSH 4 (NToWord WLen 0x4e487b71%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] [PUSH 4 (NToWord WLen 0x4E487B71%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 32 PUSH 4
 O: PUSH 32 PUSH 4
*)
Compute pair "BottleCastle_run_code_of_0_block_555_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x32%N);PUSH 1 (NToWord WLen 0x4%N)] [PUSH 1 (NToWord WLen 0x32%N);PUSH 1 (NToWord WLen 0x4%N)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_555_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 4E487B71 PUSH E0 SHL PUSH 0
 O: PUSH 4e487b71 PUSH e0 SHL PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_556_0"%string (equiv_checker [PUSH 4 (NToWord WLen 0x4e487b71%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] [PUSH 4 (NToWord WLen 0x4E487B71%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 41 PUSH 4
 O: PUSH 41 PUSH 4
*)
Compute pair "BottleCastle_run_code_of_0_block_556_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x41%N);PUSH 1 (NToWord WLen 0x4%N)] [PUSH 1 (NToWord WLen 0x41%N);PUSH 1 (NToWord WLen 0x4%N)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "BottleCastle_run_code_of_0_block_556_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH E0 SHL SUB NOT DUP2 AND DUP2 EQ PUSH [tag] 437
 O: DUP1 DUP2 PUSH 1 DUP1 PUSH e0 SHL SUB NOT AND EQ PUSH [tag] 437
*)
Compute pair "BottleCastle_run_code_of_0_block_557_0"%string (equiv_checker [DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode SUB;Opcode NOT;Opcode AND;Opcode EQ;PUSH 2 (NToWord WLen 0x1b5%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 2;Opcode AND;DUP 2;Opcode EQ;PUSH 2 (NToWord WLen 0x1b5%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "BottleCastle_run_code_of_0_block_558_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH 80 PUSH 40
 O: PUSH 80 PUSH 40
*)
Compute pair "ERC721A_initial_block_0_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x80%N);PUSH 1 (NToWord WLen 0x40%N)] [PUSH 1 (NToWord WLen 0x80%N);PUSH 1 (NToWord WLen 0x40%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 1
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 1
*)
Compute pair "ERC721A_initial_block_0_1"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_initial_block_1_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH 40 MLOAD PUSHSIZE CODESIZE SUB DUP1 PUSHSIZE DUP4
 O: POP PUSH 40 MLOAD PUSHSIZE CODESIZE SUB DUP1 PUSHSIZE DUP4
  ERROR OCCURRED

'PUSHSIZE' is not in list
*)

(*
 I: DUP2 ADD PUSH 40 DUP2 SWAP1
 O: DUP2 ADD DUP1 PUSH 40
*)
Compute pair "ERC721A_initial_block_2_1"%string (equiv_checker [DUP 2;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x40%N)] [DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);DUP 2;DUP 1] 2 optimize_id).

(*
 I: PUSH [tag] 2 SWAP2 PUSH [tag] 3
 O: PUSH [tag] 2 SWAP2 PUSH [tag] 3
*)
Compute pair "ERC721A_initial_block_2_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x2%N);DUP 2;PUSH 1 (NToWord WLen 0x3%N)] [PUSH 1 (NToWord WLen 0x2%N);DUP 2;PUSH 1 (NToWord WLen 0x3%N)] 2 optimize_id).

(*
 I: DUP2 MLOAD PUSH [tag] 6 SWAP1 PUSH 2 SWAP1 PUSH 20 DUP6 ADD SWAP1 PUSH [tag] 7
 O: PUSH [tag] 6 PUSH 2 PUSH 20 DUP5 ADD DUP5 MLOAD PUSH [tag] 7
*)
Compute pair "ERC721A_initial_block_3_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x6%N);PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;DUP 5;Opcode MLOAD;PUSH 1 (NToWord WLen 0x7%N)] [DUP 2;Opcode MLOAD;PUSH 1 (NToWord WLen 0x6%N);DUP 1;PUSH 1 (NToWord WLen 0x2%N);DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 6;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x7%N)] 2 optimize_id).

(*
 I: POP DUP1 MLOAD PUSH [tag] 8 SWAP1 PUSH 3 SWAP1 PUSH 20 DUP5 ADD SWAP1 PUSH [tag] 7
 O: POP PUSH [tag] 8 PUSH 3 DUP3 PUSH 20 ADD DUP4 MLOAD PUSH [tag] 7
*)
Compute pair "ERC721A_initial_block_4_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x8%N);PUSH 1 (NToWord WLen 0x3%N);DUP 3;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 4;Opcode MLOAD;PUSH 1 (NToWord WLen 0x7%N)] [POP;DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x8%N);DUP 1;PUSH 1 (NToWord WLen 0x3%N);DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x7%N)] 2 optimize_id).

(*
 I: POP POP PUSH 0 DUP1
 O: POP POP PUSH 0 DUP1
*)
Compute pair "ERC721A_initial_block_5_0"%string (equiv_checker [POP;POP;PUSH 1 (NToWord WLen 0x0%N);DUP 1] [POP;POP;PUSH 1 (NToWord WLen 0x0%N);DUP 1] 2 optimize_id).

(*
 I: POP PUSH [tag] 24
 O: POP PUSH [tag] 24
*)
Compute pair "ERC721A_initial_block_5_1"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x18%N)] [POP;PUSH 1 (NToWord WLen 0x18%N)] 1 optimize_id).

(*
 I: DUP3 DUP1 SLOAD PUSH [tag] 13 SWAP1 PUSH [tag] 14
 O: DUP3 PUSH [tag] 13 DUP5 SLOAD PUSH [tag] 14
*)
Compute pair "ERC721A_initial_block_6_0"%string (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0xd%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0xe%N)] [DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xd%N);DUP 1;PUSH 1 (NToWord WLen 0xe%N)] 3 optimize_id).

(*
 I: SWAP1 PUSH 0
 O: SWAP1 PUSH 0
*)
Compute pair "ERC721A_initial_block_7_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x0%N)] [DUP 1;PUSH 1 (NToWord WLen 0x0%N)] 2 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1 PUSH 1F ADD PUSH 20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 16
 O: PUSH 20 DUP1 PUSH 0 KECCAK256 SWAP2 PUSH 1f ADD DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 16
*)
Compute pair "ERC721A_initial_block_7_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 2;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x10%N)] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x10%N)] 3 optimize_id).

(*
 I: PUSH 0 DUP6
 O: PUSH 0 DUP6
*)
Compute pair "ERC721A_initial_block_8_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 6] [PUSH 1 (NToWord WLen 0x0%N);DUP 6] 5 optimize_id).

(*
 I: PUSH [tag] 19
 O: PUSH [tag] 19
*)
Compute pair "ERC721A_initial_block_8_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x13%N)] [PUSH 1 (NToWord WLen 0x13%N)] 0 optimize_id).

(*
 I: DUP3 PUSH 1F LT PUSH [tag] 17
 O: DUP3 PUSH 1f LT PUSH [tag] 17
*)
Compute pair "ERC721A_initial_block_9_0"%string (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0x1f%N);Opcode LT;PUSH 1 (NToWord WLen 0x11%N)] [DUP 3;PUSH 1 (NToWord WLen 0x1F%N);Opcode LT;PUSH 1 (NToWord WLen 0x11%N)] 3 optimize_id).

(*
 I: DUP1 MLOAD PUSH FF NOT AND DUP4 DUP1 ADD OR DUP6
 O: DUP3 DUP1 ADD PUSH ff NOT DUP3 MLOAD AND OR DUP6
*)
Compute pair "ERC721A_initial_block_10_0"%string (equiv_checker [DUP 3;DUP 1;Opcode ADD;PUSH 1 (NToWord WLen 0xff%N);Opcode NOT;DUP 3;Opcode MLOAD;Opcode AND;Opcode OR;DUP 6] [DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0xFF%N);Opcode NOT;Opcode AND;DUP 4;DUP 1;Opcode ADD;Opcode OR;DUP 6] 5 optimize_id).

(*
 I: PUSH [tag] 19
 O: PUSH [tag] 19
*)
Compute pair "ERC721A_initial_block_10_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x13%N)] [PUSH 1 (NToWord WLen 0x13%N)] 0 optimize_id).

(*
 I: DUP3 DUP1 ADD PUSH 1 ADD DUP6
 O: DUP3 DUP4 ADD PUSH 1 ADD DUP6
*)
Compute pair "ERC721A_initial_block_11_0"%string (equiv_checker [DUP 3;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 6] [DUP 3;DUP 1;Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 6] 5 optimize_id).

(*
 I: DUP3 ISZERO PUSH [tag] 19
 O: DUP3 ISZERO PUSH [tag] 19
*)
Compute pair "ERC721A_initial_block_11_1"%string (equiv_checker [DUP 3;Opcode ISZERO;PUSH 1 (NToWord WLen 0x13%N)] [DUP 3;Opcode ISZERO;PUSH 1 (NToWord WLen 0x13%N)] 3 optimize_id).

(*
 I: SWAP2 DUP3 ADD
 O: DUP1 SWAP3 ADD
*)
Compute pair "ERC721A_initial_block_12_0"%string (equiv_checker [DUP 1;DUP 3;Opcode ADD] [DUP 2;DUP 3;Opcode ADD] 3 optimize_id).

(*
 I: DUP3 DUP2 GT ISZERO PUSH [tag] 19
 O: DUP3 DUP2 GT ISZERO PUSH [tag] 19
*)
Compute pair "ERC721A_initial_block_13_0"%string (equiv_checker [DUP 3;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x13%N)] [DUP 3;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x13%N)] 3 optimize_id).

(*
 I: DUP3 MLOAD DUP3
 O: DUP3 MLOAD DUP3
*)
Compute pair "ERC721A_initial_block_14_0"%string (equiv_checker [DUP 3;Opcode MLOAD;DUP 3] [DUP 3;Opcode MLOAD;DUP 3] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 SWAP1 PUSH 1 ADD SWAP1 PUSH [tag] 18
 O: SWAP2 PUSH 20 ADD SWAP2 SWAP1 PUSH 1 ADD SWAP1 PUSH [tag] 18
*)
Compute pair "ERC721A_initial_block_14_1"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x12%N)] [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x12%N)] 3 optimize_id).

(*
 I: POP PUSH [tag] 20 SWAP3 SWAP2 POP PUSH [tag] 21
 O: POP PUSH [tag] 21 PUSH [tag] 20 SWAP4 SWAP3 POP
*)
Compute pair "ERC721A_initial_block_15_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x15%N);PUSH 1 (NToWord WLen 0x14%N);DUP 4;DUP 3;POP] [POP;PUSH 1 (NToWord WLen 0x14%N);DUP 3;DUP 2;POP;PUSH 1 (NToWord WLen 0x15%N)] 4 optimize_id).

(*
 I: POP SWAP1
 O: POP SWAP1
*)
Compute pair "ERC721A_initial_block_16_0"%string (equiv_checker [POP;DUP 1] [POP;DUP 1] 3 optimize_id).

(*
 I: DUP1 DUP3 GT ISZERO PUSH [tag] 20
 O: DUP1 DUP3 GT ISZERO PUSH [tag] 20
*)
Compute pair "ERC721A_initial_block_18_0"%string (equiv_checker [DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x14%N)] [DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x14%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP2
 O: PUSH 0 DUP2
*)
Compute pair "ERC721A_initial_block_19_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2] [PUSH 1 (NToWord WLen 0x0%N);DUP 2] 1 optimize_id).

(*
 I: PUSH 1 ADD PUSH [tag] 22
 O: PUSH 1 ADD PUSH [tag] 22
*)
Compute pair "ERC721A_initial_block_19_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 1 (NToWord WLen 0x16%N)] [PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 1 (NToWord WLen 0x16%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 27
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 27
*)
Compute pair "ERC721A_initial_block_20_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode SLT;PUSH 1 (NToWord WLen 0x1b%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;Opcode SLT;PUSH 1 (NToWord WLen 0x1b%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_initial_block_21_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP2 MLOAD PUSH 1 PUSH 1 PUSH 40 SHL SUB DUP1 DUP3 GT ISZERO PUSH [tag] 29
 O: DUP2 MLOAD PUSH 1 DUP1 PUSH 40 SHL SUB DUP1 DUP3 GT ISZERO PUSH [tag] 29
*)
Compute pair "ERC721A_initial_block_22_0"%string (equiv_checker [DUP 2;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode SHL;Opcode SUB;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1d%N)] [DUP 2;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x40%N);Opcode SHL;Opcode SUB;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1d%N)] 2 optimize_id).

(*
 I: PUSH [tag] 29 PUSH [tag] 30
 O: PUSH [tag] 29 PUSH [tag] 30
*)
Compute pair "ERC721A_initial_block_23_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1d%N);PUSH 1 (NToWord WLen 0x1e%N)] [PUSH 1 (NToWord WLen 0x1d%N);PUSH 1 (NToWord WLen 0x1e%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 1F DUP4 ADD PUSH 1F NOT SWAP1 DUP2 AND PUSH 3F ADD AND DUP2 ADD SWAP1 DUP3 DUP3 GT DUP2 DUP4 LT OR ISZERO PUSH [tag] 32
 O: PUSH 40 MLOAD PUSH 1f NOT PUSH 3f DUP2 DUP6 PUSH 1f ADD AND ADD AND ADD PUSH 40 MLOAD DUP3 DUP3 GT DUP2 DUP4 LT OR ISZERO PUSH [tag] 32
*)
Compute pair "ERC721A_initial_block_24_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x1f%N);Opcode NOT;PUSH 1 (NToWord WLen 0x3f%N);DUP 2;DUP 6;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode AND;Opcode ADD;Opcode AND;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 3;DUP 3;Opcode GT;DUP 2;DUP 4;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;DUP 1;DUP 2;Opcode AND;PUSH 1 (NToWord WLen 0x3F%N);Opcode ADD;Opcode AND;DUP 2;Opcode ADD;DUP 1;DUP 3;DUP 3;Opcode GT;DUP 2;DUP 4;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 1 (NToWord WLen 0x20%N)] 2 optimize_id).

(*
 I: PUSH [tag] 32 PUSH [tag] 30
 O: PUSH [tag] 32 PUSH [tag] 30
*)
Compute pair "ERC721A_initial_block_25_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x1e%N)] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x1e%N)] 0 optimize_id).

(*
 I: DUP2 PUSH 40
 O: DUP2 PUSH 40
*)
Compute pair "ERC721A_initial_block_26_0"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x40%N)] [DUP 2;PUSH 1 (NToWord WLen 0x40%N)] 2 optimize_id).

(*
 I: DUP4 DUP2
 O: DUP4 DUP2
*)
Compute pair "ERC721A_initial_block_26_1"%string (equiv_checker [DUP 4;DUP 2] [DUP 4;DUP 2] 4 optimize_id).

(*
 I: PUSH 20 SWAP3 POP DUP7 DUP4 DUP6 DUP9 ADD ADD GT ISZERO PUSH [tag] 33
 O: DUP7 DUP7 DUP6 ADD PUSH 20 DUP1 SWAP6 POP ADD GT ISZERO PUSH [tag] 33
*)
Compute pair "ERC721A_initial_block_26_2"%string (equiv_checker [DUP 7;DUP 7;DUP 6;Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 6;POP;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x21%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;POP;DUP 7;DUP 4;DUP 6;DUP 9;Opcode ADD;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x21%N)] 7 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_initial_block_27_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH 0 SWAP2 POP
 O: PUSH 0 SWAP2 POP
*)
Compute pair "ERC721A_initial_block_28_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;POP] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;POP] 2 optimize_id).

(*
 I: DUP4 DUP3 LT ISZERO PUSH [tag] 36
 O: DUP4 DUP3 LT ISZERO PUSH [tag] 36
*)
Compute pair "ERC721A_initial_block_29_0"%string (equiv_checker [DUP 4;DUP 3;Opcode LT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x24%N)] [DUP 4;DUP 3;Opcode LT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x24%N)] 4 optimize_id).

(*
 I: DUP6 DUP3 ADD DUP4 ADD MLOAD DUP2 DUP4 ADD DUP5 ADD
 O: DUP3 DUP3 DUP8 ADD ADD MLOAD DUP4 DUP4 DUP4 ADD ADD
*)
Compute pair "ERC721A_initial_block_30_0"%string (equiv_checker [DUP 3;DUP 3;DUP 8;Opcode ADD;Opcode ADD;Opcode MLOAD;DUP 4;DUP 4;DUP 4;Opcode ADD;Opcode ADD] [DUP 6;DUP 3;Opcode ADD;DUP 4;Opcode ADD;Opcode MLOAD;DUP 2;DUP 4;Opcode ADD;DUP 5;Opcode ADD] 6 optimize_id).

(*
 I: SWAP1 DUP3 ADD SWAP1 PUSH [tag] 34
 O: PUSH [tag] 34 SWAP2 DUP4 ADD SWAP2
*)
Compute pair "ERC721A_initial_block_30_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x22%N);DUP 2;DUP 4;Opcode ADD;DUP 2] [DUP 1;DUP 3;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x22%N)] 3 optimize_id).

(*
 I: DUP4 DUP3 GT ISZERO PUSH [tag] 37
 O: DUP4 DUP3 GT ISZERO PUSH [tag] 37
*)
Compute pair "ERC721A_initial_block_31_0"%string (equiv_checker [DUP 4;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x25%N)] [DUP 4;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x25%N)] 4 optimize_id).

(*
 I: PUSH 0 DUP4 DUP6 DUP4 ADD ADD
 O: PUSH 0 DUP5 DUP3 ADD DUP5 ADD
*)
Compute pair "ERC721A_initial_block_32_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 5;DUP 3;Opcode ADD;DUP 5;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 6;DUP 4;Opcode ADD;Opcode ADD] 4 optimize_id).

(*
 I: SWAP7 SWAP6 POP POP POP POP POP POP
 O: SWAP7 SWAP6 POP POP POP POP POP POP
*)
Compute pair "ERC721A_initial_block_33_0"%string (equiv_checker [DUP 7;DUP 6;POP;POP;POP;POP;POP;POP] [DUP 7;DUP 6;POP;POP;POP;POP;POP;POP] 8 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 39
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 39
*)
Compute pair "ERC721A_initial_block_34_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x27%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x27%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_initial_block_35_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP3 MLOAD PUSH 1 PUSH 1 PUSH 40 SHL SUB DUP1 DUP3 GT ISZERO PUSH [tag] 40
 O: DUP3 MLOAD PUSH 1 DUP1 PUSH 40 SHL SUB DUP1 DUP3 GT ISZERO PUSH [tag] 40
*)
Compute pair "ERC721A_initial_block_36_0"%string (equiv_checker [DUP 3;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode SHL;Opcode SUB;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x28%N)] [DUP 3;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x40%N);Opcode SHL;Opcode SUB;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x28%N)] 3 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_initial_block_37_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 41 DUP7 DUP4 DUP8 ADD PUSH [tag] 25
 O: PUSH [tag] 41 DUP7 DUP4 DUP8 ADD PUSH [tag] 25
*)
Compute pair "ERC721A_initial_block_38_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x29%N);DUP 7;DUP 4;DUP 8;Opcode ADD;PUSH 1 (NToWord WLen 0x19%N)] [PUSH 1 (NToWord WLen 0x29%N);DUP 7;DUP 4;DUP 8;Opcode ADD;PUSH 1 (NToWord WLen 0x19%N)] 6 optimize_id).

(*
 I: SWAP4 POP PUSH 20 DUP6 ADD MLOAD SWAP2 POP DUP1 DUP3 GT ISZERO PUSH [tag] 42
 O: SWAP4 POP DUP1 PUSH 20 DUP7 ADD MLOAD DUP1 SWAP4 POP GT ISZERO PUSH [tag] 42
*)
Compute pair "ERC721A_initial_block_39_0"%string (equiv_checker [DUP 4;POP;DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;Opcode MLOAD;DUP 1;DUP 4;POP;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x2a%N)] [DUP 4;POP;PUSH 1 (NToWord WLen 0x20%N);DUP 6;Opcode ADD;Opcode MLOAD;DUP 2;POP;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x2a%N)] 6 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_initial_block_40_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH [tag] 43 DUP6 DUP3 DUP7 ADD PUSH [tag] 25
 O: POP PUSH [tag] 43 DUP6 DUP6 DUP4 ADD PUSH [tag] 25
*)
Compute pair "ERC721A_initial_block_41_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x2b%N);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0x19%N)] [POP;PUSH 1 (NToWord WLen 0x2b%N);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (NToWord WLen 0x19%N)] 6 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Compute pair "ERC721A_initial_block_42_0"%string (equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id).

(*
 I: PUSH 1 DUP2 DUP2 SHR SWAP1 DUP3 AND DUP1 PUSH [tag] 45
 O: DUP1 PUSH 1 SHR DUP2 PUSH 1 AND DUP1 PUSH [tag] 45
*)
Compute pair "ERC721A_initial_block_43_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode SHR;DUP 2;PUSH 1 (NToWord WLen 0x1%N);Opcode AND;DUP 1;PUSH 1 (NToWord WLen 0x2d%N)] [PUSH 1 (NToWord WLen 0x1%N);DUP 2;DUP 2;Opcode SHR;DUP 1;DUP 3;Opcode AND;DUP 1;PUSH 1 (NToWord WLen 0x2d%N)] 1 optimize_id).

(*
 I: PUSH 7F DUP3 AND SWAP2 POP
 O: SWAP1 PUSH 7f AND SWAP1
*)
Compute pair "ERC721A_initial_block_44_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x7f%N);Opcode AND;DUP 1] [PUSH 1 (NToWord WLen 0x7F%N);DUP 3;Opcode AND;DUP 2;POP] 2 optimize_id).

(*
 I: PUSH 20 DUP3 LT DUP2 EQ ISZERO PUSH [tag] 46
 O: DUP1 PUSH 20 DUP4 LT EQ ISZERO PUSH [tag] 46
*)
Compute pair "ERC721A_initial_block_45_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode LT;Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0x2e%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode LT;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0x2e%N)] 2 optimize_id).

(*
 I: PUSH 4E487B71 PUSH E0 SHL PUSH 0
 O: PUSH 4e487b71 PUSH e0 SHL PUSH 0
*)
Compute pair "ERC721A_initial_block_46_0"%string (equiv_checker [PUSH 4 (NToWord WLen 0x4e487b71%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] [PUSH 4 (NToWord WLen 0x4E487B71%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 22 PUSH 4
 O: PUSH 22 PUSH 4
*)
Compute pair "ERC721A_initial_block_46_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x22%N);PUSH 1 (NToWord WLen 0x4%N)] [PUSH 1 (NToWord WLen 0x22%N);PUSH 1 (NToWord WLen 0x4%N)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "ERC721A_initial_block_46_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: POP SWAP2 SWAP1 POP
 O: POP SWAP2 SWAP1 POP
*)
Compute pair "ERC721A_initial_block_47_0"%string (equiv_checker [POP;DUP 2;DUP 1;POP] [POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 4E487B71 PUSH E0 SHL PUSH 0
 O: PUSH 4e487b71 PUSH e0 SHL PUSH 0
*)
Compute pair "ERC721A_initial_block_48_0"%string (equiv_checker [PUSH 4 (NToWord WLen 0x4e487b71%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] [PUSH 4 (NToWord WLen 0x4E487B71%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 41 PUSH 4
 O: PUSH 41 PUSH 4
*)
Compute pair "ERC721A_initial_block_48_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x41%N);PUSH 1 (NToWord WLen 0x4%N)] [PUSH 1 (NToWord WLen 0x41%N);PUSH 1 (NToWord WLen 0x4%N)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "ERC721A_initial_block_48_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

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
Compute pair "ERC721A_initial_block_49_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 80 PUSH 40
 O: PUSH 80 PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_0_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x80%N);PUSH 1 (NToWord WLen 0x40%N)] [PUSH 1 (NToWord WLen 0x80%N);PUSH 1 (NToWord WLen 0x40%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 1
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 1
*)
Compute pair "ERC721A_run_code_of_0_block_0_1"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1%N)] 0 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_1_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP PUSH 4 CALLDATASIZE LT PUSH [tag] 2
 O: POP PUSH 4 CALLDATASIZE LT PUSH [tag] 2
*)
Compute pair "ERC721A_run_code_of_0_block_2_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x4%N);Opcode CALLDATASIZE;Opcode LT;PUSH 1 (NToWord WLen 0x2%N)] [POP;PUSH 1 (NToWord WLen 0x4%N);Opcode CALLDATASIZE;Opcode LT;PUSH 1 (NToWord WLen 0x2%N)] 1 optimize_id).

(*
 I: PUSH 0 CALLDATALOAD PUSH E0 SHR DUP1 PUSH 6352211E GT PUSH [tag] 17
 O: PUSH 0 CALLDATALOAD PUSH e0 SHR DUP1 PUSH 6352211e GT PUSH [tag] 17
*)
Compute pair "ERC721A_run_code_of_0_block_3_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);Opcode CALLDATALOAD;PUSH 1 (NToWord WLen 0xe0%N);Opcode SHR;DUP 1;PUSH 4 (NToWord WLen 0x6352211e%N);Opcode GT;PUSH 1 (NToWord WLen 0x11%N)] [PUSH 1 (NToWord WLen 0x0%N);Opcode CALLDATALOAD;PUSH 1 (NToWord WLen 0xE0%N);Opcode SHR;DUP 1;PUSH 4 (NToWord WLen 0x6352211E%N);Opcode GT;PUSH 1 (NToWord WLen 0x11%N)] 0 optimize_id).

(*
 I: DUP1 PUSH A22CB465 GT PUSH [tag] 18
 O: DUP1 PUSH a22cb465 GT PUSH [tag] 18
*)
Compute pair "ERC721A_run_code_of_0_block_4_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xa22cb465%N);Opcode GT;PUSH 1 (NToWord WLen 0x12%N)] [DUP 1;PUSH 4 (NToWord WLen 0xA22CB465%N);Opcode GT;PUSH 1 (NToWord WLen 0x12%N)] 1 optimize_id).

(*
 I: DUP1 PUSH A22CB465 EQ PUSH [tag] 13
 O: DUP1 PUSH a22cb465 EQ PUSH [tag] 13
*)
Compute pair "ERC721A_run_code_of_0_block_5_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xa22cb465%N);Opcode EQ;PUSH 1 (NToWord WLen 0xd%N)] [DUP 1;PUSH 4 (NToWord WLen 0xA22CB465%N);Opcode EQ;PUSH 1 (NToWord WLen 0xd%N)] 1 optimize_id).

(*
 I: DUP1 PUSH B88D4FDE EQ PUSH [tag] 14
 O: DUP1 PUSH b88d4fde EQ PUSH [tag] 14
*)
Compute pair "ERC721A_run_code_of_0_block_6_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xb88d4fde%N);Opcode EQ;PUSH 1 (NToWord WLen 0xe%N)] [DUP 1;PUSH 4 (NToWord WLen 0xB88D4FDE%N);Opcode EQ;PUSH 1 (NToWord WLen 0xe%N)] 1 optimize_id).

(*
 I: DUP1 PUSH C87B56DD EQ PUSH [tag] 15
 O: DUP1 PUSH c87b56dd EQ PUSH [tag] 15
*)
Compute pair "ERC721A_run_code_of_0_block_7_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xc87b56dd%N);Opcode EQ;PUSH 1 (NToWord WLen 0xf%N)] [DUP 1;PUSH 4 (NToWord WLen 0xC87B56DD%N);Opcode EQ;PUSH 1 (NToWord WLen 0xf%N)] 1 optimize_id).

(*
 I: DUP1 PUSH E985E9C5 EQ PUSH [tag] 16
 O: DUP1 PUSH e985e9c5 EQ PUSH [tag] 16
*)
Compute pair "ERC721A_run_code_of_0_block_8_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0xe985e9c5%N);Opcode EQ;PUSH 1 (NToWord WLen 0x10%N)] [DUP 1;PUSH 4 (NToWord WLen 0xE985E9C5%N);Opcode EQ;PUSH 1 (NToWord WLen 0x10%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_9_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP1 PUSH 6352211E EQ PUSH [tag] 10
 O: DUP1 PUSH 6352211e EQ PUSH [tag] 10
*)
Compute pair "ERC721A_run_code_of_0_block_10_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x6352211e%N);Opcode EQ;PUSH 1 (NToWord WLen 0xa%N)] [DUP 1;PUSH 4 (NToWord WLen 0x6352211E%N);Opcode EQ;PUSH 1 (NToWord WLen 0xa%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 70A08231 EQ PUSH [tag] 11
 O: DUP1 PUSH 70a08231 EQ PUSH [tag] 11
*)
Compute pair "ERC721A_run_code_of_0_block_11_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x70a08231%N);Opcode EQ;PUSH 1 (NToWord WLen 0xb%N)] [DUP 1;PUSH 4 (NToWord WLen 0x70A08231%N);Opcode EQ;PUSH 1 (NToWord WLen 0xb%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 95D89B41 EQ PUSH [tag] 12
 O: DUP1 PUSH 95d89b41 EQ PUSH [tag] 12
*)
Compute pair "ERC721A_run_code_of_0_block_12_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x95d89b41%N);Opcode EQ;PUSH 1 (NToWord WLen 0xc%N)] [DUP 1;PUSH 4 (NToWord WLen 0x95D89B41%N);Opcode EQ;PUSH 1 (NToWord WLen 0xc%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_13_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP1 PUSH 95EA7B3 GT PUSH [tag] 19
 O: DUP1 PUSH 95ea7b3 GT PUSH [tag] 19
*)
Compute pair "ERC721A_run_code_of_0_block_14_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x95ea7b3%N);Opcode GT;PUSH 1 (NToWord WLen 0x13%N)] [DUP 1;PUSH 4 (NToWord WLen 0x95EA7B3%N);Opcode GT;PUSH 1 (NToWord WLen 0x13%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 95EA7B3 EQ PUSH [tag] 6
 O: DUP1 PUSH 95ea7b3 EQ PUSH [tag] 6
*)
Compute pair "ERC721A_run_code_of_0_block_15_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x95ea7b3%N);Opcode EQ;PUSH 1 (NToWord WLen 0x6%N)] [DUP 1;PUSH 4 (NToWord WLen 0x95EA7B3%N);Opcode EQ;PUSH 1 (NToWord WLen 0x6%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 18160DDD EQ PUSH [tag] 7
 O: DUP1 PUSH 18160ddd EQ PUSH [tag] 7
*)
Compute pair "ERC721A_run_code_of_0_block_16_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x18160ddd%N);Opcode EQ;PUSH 1 (NToWord WLen 0x7%N)] [DUP 1;PUSH 4 (NToWord WLen 0x18160DDD%N);Opcode EQ;PUSH 1 (NToWord WLen 0x7%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 23B872DD EQ PUSH [tag] 8
 O: DUP1 PUSH 23b872dd EQ PUSH [tag] 8
*)
Compute pair "ERC721A_run_code_of_0_block_17_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x23b872dd%N);Opcode EQ;PUSH 1 (NToWord WLen 0x8%N)] [DUP 1;PUSH 4 (NToWord WLen 0x23B872DD%N);Opcode EQ;PUSH 1 (NToWord WLen 0x8%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 42842E0E EQ PUSH [tag] 9
 O: DUP1 PUSH 42842e0e EQ PUSH [tag] 9
*)
Compute pair "ERC721A_run_code_of_0_block_18_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x42842e0e%N);Opcode EQ;PUSH 1 (NToWord WLen 0x9%N)] [DUP 1;PUSH 4 (NToWord WLen 0x42842E0E%N);Opcode EQ;PUSH 1 (NToWord WLen 0x9%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_19_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP1 PUSH 1FFC9A7 EQ PUSH [tag] 3
 O: DUP1 PUSH 1ffc9a7 EQ PUSH [tag] 3
*)
Compute pair "ERC721A_run_code_of_0_block_20_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x1ffc9a7%N);Opcode EQ;PUSH 1 (NToWord WLen 0x3%N)] [DUP 1;PUSH 4 (NToWord WLen 0x1FFC9A7%N);Opcode EQ;PUSH 1 (NToWord WLen 0x3%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 6FDDE03 EQ PUSH [tag] 4
 O: DUP1 PUSH 6fdde03 EQ PUSH [tag] 4
*)
Compute pair "ERC721A_run_code_of_0_block_21_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x6fdde03%N);Opcode EQ;PUSH 1 (NToWord WLen 0x4%N)] [DUP 1;PUSH 4 (NToWord WLen 0x6FDDE03%N);Opcode EQ;PUSH 1 (NToWord WLen 0x4%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 81812FC EQ PUSH [tag] 5
 O: DUP1 PUSH 81812fc EQ PUSH [tag] 5
*)
Compute pair "ERC721A_run_code_of_0_block_22_0"%string (equiv_checker [DUP 1;PUSH 4 (NToWord WLen 0x81812fc%N);Opcode EQ;PUSH 1 (NToWord WLen 0x5%N)] [DUP 1;PUSH 4 (NToWord WLen 0x81812FC%N);Opcode EQ;PUSH 1 (NToWord WLen 0x5%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_23_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 20 PUSH [tag] 21 CALLDATASIZE PUSH 4 PUSH [tag] 22
 O: PUSH [tag] 20 PUSH [tag] 21 CALLDATASIZE PUSH 4 PUSH [tag] 22
*)
Compute pair "ERC721A_run_code_of_0_block_24_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x14%N);PUSH 1 (NToWord WLen 0x15%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x16%N)] [PUSH 1 (NToWord WLen 0x14%N);PUSH 1 (NToWord WLen 0x15%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x16%N)] 0 optimize_id).

(*
 I: PUSH [tag] 23
 O: PUSH [tag] 23
*)
Compute pair "ERC721A_run_code_of_0_block_25_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x17%N)] [PUSH 1 (NToWord WLen 0x17%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD SWAP1 ISZERO ISZERO DUP2
 O: ISZERO PUSH 40 MLOAD SWAP1 ISZERO DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_26_0"%string (equiv_checker [Opcode ISZERO;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;Opcode ISZERO;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;Opcode ISZERO;Opcode ISZERO;DUP 2] 1 optimize_id).

(*
 I: PUSH 20 ADD
 O: PUSH 20 ADD
*)
Compute pair "ERC721A_run_code_of_0_block_26_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD] 1 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_27_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH [tag] 26 PUSH [tag] 27
 O: PUSH [tag] 26 PUSH [tag] 27
*)
Compute pair "ERC721A_run_code_of_0_block_28_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1a%N);PUSH 1 (NToWord WLen 0x1b%N)] [PUSH 1 (NToWord WLen 0x1a%N);PUSH 1 (NToWord WLen 0x1b%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 24 SWAP2 SWAP1 PUSH [tag] 29
 O: PUSH [tag] 24 SWAP1 PUSH 40 MLOAD PUSH [tag] 29
*)
Compute pair "ERC721A_run_code_of_0_block_29_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x18%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x1d%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x18%N);DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x1d%N)] 1 optimize_id).

(*
 I: PUSH [tag] 30 PUSH [tag] 31 CALLDATASIZE PUSH 4 PUSH [tag] 32
 O: PUSH [tag] 30 PUSH [tag] 31 CALLDATASIZE PUSH 4 PUSH [tag] 32
*)
Compute pair "ERC721A_run_code_of_0_block_30_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1e%N);PUSH 1 (NToWord WLen 0x1f%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x1e%N);PUSH 1 (NToWord WLen 0x1f%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH [tag] 33
 O: PUSH [tag] 33
*)
Compute pair "ERC721A_run_code_of_0_block_31_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x21%N)] [PUSH 1 (NToWord WLen 0x21%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB SWAP1 SWAP2 AND DUP2
 O: PUSH 40 MLOAD SWAP1 PUSH 1 DUP1 PUSH a0 SHL SUB AND DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_32_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 1;DUP 2;Opcode AND;DUP 2] 1 optimize_id).

(*
 I: PUSH 20 ADD PUSH [tag] 24
 O: PUSH 20 ADD PUSH [tag] 24
*)
Compute pair "ERC721A_run_code_of_0_block_32_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x18%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x18%N)] 1 optimize_id).

(*
 I: PUSH [tag] 36 PUSH [tag] 37 CALLDATASIZE PUSH 4 PUSH [tag] 38
 O: PUSH [tag] 36 PUSH [tag] 37 CALLDATASIZE PUSH 4 PUSH [tag] 38
*)
Compute pair "ERC721A_run_code_of_0_block_33_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x25%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x26%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x25%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x26%N)] 0 optimize_id).

(*
 I: PUSH [tag] 39
 O: PUSH [tag] 39
*)
Compute pair "ERC721A_run_code_of_0_block_34_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x27%N)] [PUSH 1 (NToWord WLen 0x27%N)] 0 optimize_id).

(*
 I: PUSH 1 SLOAD PUSH 0 SLOAD SUB
 O: PUSH 1 SLOAD PUSH 0 SLOAD SUB
*)
Compute pair "ERC721A_run_code_of_0_block_36_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;Opcode SUB] [PUSH 1 (NToWord WLen 0x1%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;Opcode SUB] 0 optimize_id).

(*
 I: PUSH 40 MLOAD SWAP1 DUP2
 O: PUSH 40 MLOAD SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_37_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2] 1 optimize_id).

(*
 I: PUSH 20 ADD PUSH [tag] 24
 O: PUSH 20 ADD PUSH [tag] 24
*)
Compute pair "ERC721A_run_code_of_0_block_37_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x18%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x18%N)] 1 optimize_id).

(*
 I: PUSH [tag] 36 PUSH [tag] 45 CALLDATASIZE PUSH 4 PUSH [tag] 46
 O: PUSH [tag] 36 PUSH [tag] 45 CALLDATASIZE PUSH 4 PUSH [tag] 46
*)
Compute pair "ERC721A_run_code_of_0_block_38_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x2d%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x2e%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x2d%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x2e%N)] 0 optimize_id).

(*
 I: PUSH [tag] 47
 O: PUSH [tag] 47
*)
Compute pair "ERC721A_run_code_of_0_block_39_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x2f%N)] [PUSH 1 (NToWord WLen 0x2f%N)] 0 optimize_id).

(*
 I: PUSH [tag] 36 PUSH [tag] 49 CALLDATASIZE PUSH 4 PUSH [tag] 46
 O: PUSH [tag] 36 PUSH [tag] 49 CALLDATASIZE PUSH 4 PUSH [tag] 46
*)
Compute pair "ERC721A_run_code_of_0_block_40_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x31%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x2e%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x31%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x2e%N)] 0 optimize_id).

(*
 I: PUSH [tag] 50
 O: PUSH [tag] 50
*)
Compute pair "ERC721A_run_code_of_0_block_41_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x32%N)] [PUSH 1 (NToWord WLen 0x32%N)] 0 optimize_id).

(*
 I: PUSH [tag] 30 PUSH [tag] 52 CALLDATASIZE PUSH 4 PUSH [tag] 32
 O: PUSH [tag] 30 PUSH [tag] 52 CALLDATASIZE PUSH 4 PUSH [tag] 32
*)
Compute pair "ERC721A_run_code_of_0_block_42_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1e%N);PUSH 1 (NToWord WLen 0x34%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x1e%N);PUSH 1 (NToWord WLen 0x34%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH [tag] 53
 O: PUSH [tag] 53
*)
Compute pair "ERC721A_run_code_of_0_block_43_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x35%N)] [PUSH 1 (NToWord WLen 0x35%N)] 0 optimize_id).

(*
 I: PUSH [tag] 40 PUSH [tag] 56 CALLDATASIZE PUSH 4 PUSH [tag] 57
 O: PUSH [tag] 40 PUSH [tag] 56 CALLDATASIZE PUSH 4 PUSH [tag] 57
*)
Compute pair "ERC721A_run_code_of_0_block_44_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x28%N);PUSH 1 (NToWord WLen 0x38%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x39%N)] [PUSH 1 (NToWord WLen 0x28%N);PUSH 1 (NToWord WLen 0x38%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x39%N)] 0 optimize_id).

(*
 I: PUSH [tag] 58
 O: PUSH [tag] 58
*)
Compute pair "ERC721A_run_code_of_0_block_45_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x3a%N)] [PUSH 1 (NToWord WLen 0x3a%N)] 0 optimize_id).

(*
 I: PUSH [tag] 26 PUSH [tag] 61
 O: PUSH [tag] 26 PUSH [tag] 61
*)
Compute pair "ERC721A_run_code_of_0_block_46_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1a%N);PUSH 1 (NToWord WLen 0x3d%N)] [PUSH 1 (NToWord WLen 0x1a%N);PUSH 1 (NToWord WLen 0x3d%N)] 0 optimize_id).

(*
 I: PUSH [tag] 36 PUSH [tag] 64 CALLDATASIZE PUSH 4 PUSH [tag] 65
 O: PUSH [tag] 36 PUSH [tag] 64 CALLDATASIZE PUSH 4 PUSH [tag] 65
*)
Compute pair "ERC721A_run_code_of_0_block_47_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x40%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x41%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x40%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x41%N)] 0 optimize_id).

(*
 I: PUSH [tag] 66
 O: PUSH [tag] 66
*)
Compute pair "ERC721A_run_code_of_0_block_48_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x42%N)] [PUSH 1 (NToWord WLen 0x42%N)] 0 optimize_id).

(*
 I: PUSH [tag] 36 PUSH [tag] 68 CALLDATASIZE PUSH 4 PUSH [tag] 69
 O: PUSH [tag] 36 PUSH [tag] 68 CALLDATASIZE PUSH 4 PUSH [tag] 69
*)
Compute pair "ERC721A_run_code_of_0_block_49_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x44%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x45%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x44%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x45%N)] 0 optimize_id).

(*
 I: PUSH [tag] 70
 O: PUSH [tag] 70
*)
Compute pair "ERC721A_run_code_of_0_block_50_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x46%N)] [PUSH 1 (NToWord WLen 0x46%N)] 0 optimize_id).

(*
 I: PUSH [tag] 26 PUSH [tag] 72 CALLDATASIZE PUSH 4 PUSH [tag] 32
 O: PUSH [tag] 26 PUSH [tag] 72 CALLDATASIZE PUSH 4 PUSH [tag] 32
*)
Compute pair "ERC721A_run_code_of_0_block_51_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1a%N);PUSH 1 (NToWord WLen 0x48%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x1a%N);PUSH 1 (NToWord WLen 0x48%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH [tag] 73
 O: PUSH [tag] 73
*)
Compute pair "ERC721A_run_code_of_0_block_52_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x49%N)] [PUSH 1 (NToWord WLen 0x49%N)] 0 optimize_id).

(*
 I: PUSH [tag] 20 PUSH [tag] 76 CALLDATASIZE PUSH 4 PUSH [tag] 77
 O: PUSH [tag] 20 PUSH [tag] 76 CALLDATASIZE PUSH 4 PUSH [tag] 77
*)
Compute pair "ERC721A_run_code_of_0_block_53_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x14%N);PUSH 1 (NToWord WLen 0x4c%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x4d%N)] [PUSH 1 (NToWord WLen 0x14%N);PUSH 1 (NToWord WLen 0x4c%N);Opcode CALLDATASIZE;PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x4d%N)] 0 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB SWAP2 DUP3 AND PUSH 0 SWAP1 DUP2
 O: PUSH 1 DUP1 PUSH a0 SHL SUB DUP1 SWAP3 AND PUSH 0 SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_54_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 1;DUP 3;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 2;DUP 3;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 7 PUSH 20 SWAP1 DUP2
 O: PUSH 20 PUSH 7 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_54_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x7%N);DUP 2] [PUSH 1 (NToWord WLen 0x7%N);PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 2] 0 optimize_id).

(*
 I: PUSH 40 DUP1 DUP4 KECCAK256 SWAP4 SWAP1 SWAP5 AND DUP3
 O: PUSH 40 SWAP4 DUP5 DUP4 KECCAK256 SWAP4 AND DUP3
*)
Compute pair "ERC721A_run_code_of_0_block_54_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 5;DUP 4;Opcode KECCAK256;DUP 4;Opcode AND;DUP 3] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;DUP 4;Opcode KECCAK256;DUP 4;DUP 1;DUP 5;Opcode AND;DUP 3] 4 optimize_id).

(*
 I: SWAP2 SWAP1 SWAP2
 O: SWAP1 SWAP2 SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_54_3"%string (equiv_checker [DUP 1;DUP 2;DUP 1] [DUP 2;DUP 1;DUP 2] 3 optimize_id).

(*
 I: KECCAK256 SLOAD PUSH FF AND SWAP1
 O: KECCAK256 SLOAD PUSH ff AND SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_54_4"%string (equiv_checker [Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0xff%N);Opcode AND;DUP 1] [Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0xFF%N);Opcode AND;DUP 1] 3 optimize_id).

(*
 I: PUSH 0 PUSH 1FFC9A7 PUSH E0 SHL PUSH 1 PUSH 1 PUSH E0 SHL SUB NOT DUP4 AND EQ DUP1 PUSH [tag] 81
 O: PUSH 0 PUSH 1 DUP1 PUSH e0 SHL SUB NOT DUP3 AND PUSH 1ffc9a7 PUSH e0 SHL EQ DUP1 PUSH [tag] 81
*)
Compute pair "ERC721A_run_code_of_0_block_55_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 3;Opcode AND;PUSH 4 (NToWord WLen 0x1ffc9a7%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode EQ;DUP 1;PUSH 1 (NToWord WLen 0x51%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 4 (NToWord WLen 0x1FFC9A7%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 4;Opcode AND;Opcode EQ;DUP 1;PUSH 1 (NToWord WLen 0x51%N)] 1 optimize_id).

(*
 I: POP PUSH 80AC58CD PUSH E0 SHL PUSH 1 PUSH 1 PUSH E0 SHL SUB NOT DUP4 AND EQ
 O: POP PUSH 80ac58cd PUSH e0 SHL PUSH 1 DUP1 PUSH e0 SHL SUB NOT DUP4 AND EQ
*)
Compute pair "ERC721A_run_code_of_0_block_56_0"%string (equiv_checker [POP;PUSH 4 (NToWord WLen 0x80ac58cd%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 4;Opcode AND;Opcode EQ] [POP;PUSH 4 (NToWord WLen 0x80AC58CD%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 4;Opcode AND;Opcode EQ] 3 optimize_id).

(*
 I: DUP1 PUSH [tag] 82
 O: DUP1 PUSH [tag] 82
*)
Compute pair "ERC721A_run_code_of_0_block_57_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x52%N)] [DUP 1;PUSH 1 (NToWord WLen 0x52%N)] 1 optimize_id).

(*
 I: POP PUSH 5B5E139F PUSH E0 SHL PUSH 1 PUSH 1 PUSH E0 SHL SUB NOT DUP4 AND EQ
 O: POP PUSH 5b5e139f PUSH e0 SHL PUSH 1 DUP1 PUSH e0 SHL SUB NOT DUP4 AND EQ
*)
Compute pair "ERC721A_run_code_of_0_block_58_0"%string (equiv_checker [POP;PUSH 4 (NToWord WLen 0x5b5e139f%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 4;Opcode AND;Opcode EQ] [POP;PUSH 4 (NToWord WLen 0x5B5E139F%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 4;Opcode AND;Opcode EQ] 3 optimize_id).

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_59_0"%string (equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id).

(*
 I: PUSH 60 PUSH 2 DUP1 SLOAD PUSH [tag] 84 SWAP1 PUSH [tag] 85
 O: PUSH 60 PUSH 2 PUSH [tag] 84 DUP2 SLOAD PUSH [tag] 85
*)
Compute pair "ERC721A_run_code_of_0_block_60_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x2%N);PUSH 1 (NToWord WLen 0x54%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0x55%N)] [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x2%N);DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x54%N);DUP 1;PUSH 1 (NToWord WLen 0x55%N)] 0 optimize_id).

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_61_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x1f%N);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 1 optimize_id).

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Compute pair "ERC721A_run_code_of_0_block_61_1"%string (equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id).

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 86 SWAP1 PUSH [tag] 85
 O: PUSH 20 ADD DUP3 PUSH [tag] 86 DUP5 SLOAD PUSH [tag] 85
*)
Compute pair "ERC721A_run_code_of_0_block_61_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;PUSH 1 (NToWord WLen 0x56%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0x55%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x56%N);DUP 1;PUSH 1 (NToWord WLen 0x55%N)] 3 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 87
 O: DUP1 ISZERO PUSH [tag] 87
*)
Compute pair "ERC721A_run_code_of_0_block_62_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x57%N)] [DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x57%N)] 1 optimize_id).

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 88
 O: DUP1 PUSH 1f LT PUSH [tag] 88
*)
Compute pair "ERC721A_run_code_of_0_block_63_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x1f%N);Opcode LT;PUSH 1 (NToWord WLen 0x58%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode LT;PUSH 1 (NToWord WLen 0x58%N)] 1 optimize_id).

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Compute pair "ERC721A_run_code_of_0_block_64_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x100%N);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (NToWord WLen 0x100%N);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id).

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 87
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 87
*)
Compute pair "ERC721A_run_code_of_0_block_64_1"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;PUSH 1 (NToWord WLen 0x57%N)] [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;PUSH 1 (NToWord WLen 0x57%N)] 3 optimize_id).

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Compute pair "ERC721A_run_code_of_0_block_65_0"%string (equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x0%N)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x0%N)] 3 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_65_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 1] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 1] 1 optimize_id).

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_66_0"%string (equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id).

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 89
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 89
*)
Compute pair "ERC721A_run_code_of_0_block_66_1"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (NToWord WLen 0x59%N)] [DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (NToWord WLen 0x59%N)] 3 optimize_id).

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute pair "ERC721A_run_code_of_0_block_67_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x1F%N);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id).

(*
 I: POP POP POP POP POP SWAP1 POP SWAP1
 O: POP POP POP POP POP SWAP2 SWAP1 POP
*)
Compute pair "ERC721A_run_code_of_0_block_68_0"%string (equiv_checker [POP;POP;POP;POP;POP;DUP 2;DUP 1;POP] [POP;POP;POP;POP;POP;DUP 1;POP;DUP 1] 8 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 91 DUP3 PUSH [tag] 92
 O: PUSH 0 PUSH [tag] 91 DUP3 PUSH [tag] 92
*)
Compute pair "ERC721A_run_code_of_0_block_69_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x5b%N);DUP 3;PUSH 1 (NToWord WLen 0x5c%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x5b%N);DUP 3;PUSH 1 (NToWord WLen 0x5c%N)] 1 optimize_id).

(*
 I: PUSH [tag] 93
 O: PUSH [tag] 93
*)
Compute pair "ERC721A_run_code_of_0_block_70_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x5d%N)] [PUSH 1 (NToWord WLen 0x5d%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 33D1C039 PUSH E2 SHL DUP2
 O: PUSH 40 MLOAD PUSH 33d1c039 PUSH e2 SHL DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_71_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x33d1c039%N);PUSH 1 (NToWord WLen 0xe2%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x33D1C039%N);PUSH 1 (NToWord WLen 0xE2%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_71_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: POP PUSH 0 SWAP1 DUP2
 O: POP PUSH 0 SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_72_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] [POP;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 6 PUSH 20
 O: PUSH 6 PUSH 20
*)
Compute pair "ERC721A_run_code_of_0_block_72_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x6%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x6%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB AND SWAP1
 O: PUSH 40 PUSH 1 DUP1 PUSH a0 SHL SUB SWAP2 KECCAK256 SLOAD AND SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_72_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 2;Opcode KECCAK256;Opcode SLOAD;Opcode AND;DUP 1] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;DUP 1] 2 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 95 DUP3 PUSH [tag] 53
 O: PUSH 0 PUSH [tag] 95 DUP3 PUSH [tag] 53
*)
Compute pair "ERC721A_run_code_of_0_block_73_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x5f%N);DUP 3;PUSH 1 (NToWord WLen 0x35%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x5f%N);DUP 3;PUSH 1 (NToWord WLen 0x35%N)] 1 optimize_id).

(*
 I: SWAP1 POP CALLER PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP3 AND EQ PUSH [tag] 101
 O: PUSH 1 DUP1 DUP3 SWAP4 POP PUSH a0 SHL SUB AND CALLER EQ PUSH [tag] 101
*)
Compute pair "ERC721A_run_code_of_0_block_74_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;DUP 3;DUP 4;POP;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode CALLER;Opcode EQ;PUSH 1 (NToWord WLen 0x65%N)] [DUP 1;POP;Opcode CALLER;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 3;Opcode AND;Opcode EQ;PUSH 1 (NToWord WLen 0x65%N)] 2 optimize_id).

(*
 I: PUSH [tag] 99 DUP2 CALLER PUSH [tag] 76
 O: PUSH [tag] 99 DUP2 CALLER PUSH [tag] 76
*)
Compute pair "ERC721A_run_code_of_0_block_75_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x63%N);DUP 2;Opcode CALLER;PUSH 1 (NToWord WLen 0x4c%N)] [PUSH 1 (NToWord WLen 0x63%N);DUP 2;Opcode CALLER;PUSH 1 (NToWord WLen 0x4c%N)] 1 optimize_id).

(*
 I: PUSH [tag] 101
 O: PUSH [tag] 101
*)
Compute pair "ERC721A_run_code_of_0_block_76_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x65%N)] [PUSH 1 (NToWord WLen 0x65%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 67D9DCA1 PUSH E1 SHL DUP2
 O: PUSH 40 MLOAD PUSH 67d9dca1 PUSH e1 SHL DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_77_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x67d9dca1%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x67D9DCA1%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_77_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 DUP3 DUP2
 O: PUSH 0 DUP3 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_78_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 2] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 2] 2 optimize_id).

(*
 I: PUSH 6 PUSH 20
 O: PUSH 6 PUSH 20
*)
Compute pair "ERC721A_run_code_of_0_block_78_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x6%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x6%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: SWAP2 MLOAD DUP6 SWAP4 SWAP2 DUP6 AND SWAP2 PUSH 8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B925 SWAP2
 O: SWAP2 SWAP1 DUP6 SWAP4 PUSH 8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925 SWAP2 DUP7 AND SWAP3 MLOAD
*)
Compute pair "ERC721A_run_code_of_0_block_78_3"%string (equiv_checker [DUP 2;DUP 1;DUP 6;DUP 4;PUSH 32 (NToWord WLen 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925%N);DUP 2;DUP 7;Opcode AND;DUP 3;Opcode MLOAD] [DUP 2;Opcode MLOAD;DUP 6;DUP 4;DUP 2;DUP 6;Opcode AND;DUP 2;PUSH 32 (NToWord WLen 0x8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B925%N);DUP 2] 6 optimize_id).

(*
 I: POP POP POP
 O: POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_78_4"%string (equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 106 DUP3 PUSH [tag] 107
 O: PUSH 0 PUSH [tag] 106 DUP3 PUSH [tag] 107
*)
Compute pair "ERC721A_run_code_of_0_block_79_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x6a%N);DUP 3;PUSH 1 (NToWord WLen 0x6b%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x6a%N);DUP 3;PUSH 1 (NToWord WLen 0x6b%N)] 1 optimize_id).

(*
 I: SWAP1 POP DUP4 PUSH 1 PUSH 1 PUSH A0 SHL SUB AND DUP2 PUSH 1 PUSH 1 PUSH A0 SHL SUB AND EQ PUSH [tag] 108
 O: DUP1 SWAP2 POP PUSH 1 DUP1 PUSH a0 SHL SUB DUP6 DUP2 AND SWAP2 AND EQ PUSH [tag] 108
*)
Compute pair "ERC721A_run_code_of_0_block_80_0"%string (equiv_checker [DUP 1;DUP 2;POP;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 6;DUP 2;Opcode AND;DUP 2;Opcode AND;Opcode EQ;PUSH 1 (NToWord WLen 0x6c%N)] [DUP 1;POP;DUP 4;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;DUP 2;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode EQ;PUSH 1 (NToWord WLen 0x6c%N)] 5 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH A11481 PUSH E8 SHL DUP2
 O: PUSH 40 MLOAD PUSH a11481 PUSH e8 SHL DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_81_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0xa11481%N);PUSH 1 (NToWord WLen 0xe8%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 3 (NToWord WLen 0xA11481%N);PUSH 1 (NToWord WLen 0xE8%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_81_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 DUP3 DUP2
 O: PUSH 0 DUP3 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_82_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 2] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 2] 2 optimize_id).

(*
 I: PUSH 6 PUSH 20
 O: PUSH 6 PUSH 20
*)
Compute pair "ERC721A_run_code_of_0_block_82_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x6%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x6%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 DUP1 SLOAD CALLER DUP1 DUP3 EQ PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP9 AND SWAP1 SWAP2 EQ OR PUSH [tag] 117
 O: PUSH 40 SWAP1 KECCAK256 DUP5 PUSH 1 DUP1 PUSH a0 SHL SUB AND CALLER EQ DUP2 SLOAD SWAP1 CALLER DUP3 EQ OR PUSH [tag] 117
*)
Compute pair "ERC721A_run_code_of_0_block_82_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;DUP 5;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode CALLER;Opcode EQ;DUP 2;Opcode SLOAD;DUP 1;Opcode CALLER;DUP 3;Opcode EQ;Opcode OR;PUSH 1 (NToWord WLen 0x75%N)] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;DUP 1;Opcode SLOAD;Opcode CALLER;DUP 1;DUP 3;Opcode EQ;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 9;Opcode AND;DUP 1;DUP 2;Opcode EQ;Opcode OR;PUSH 1 (NToWord WLen 0x75%N)] 5 optimize_id).

(*
 I: PUSH [tag] 115 DUP7 CALLER PUSH [tag] 76
 O: PUSH [tag] 115 DUP7 CALLER PUSH [tag] 76
*)
Compute pair "ERC721A_run_code_of_0_block_83_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x73%N);DUP 7;Opcode CALLER;PUSH 1 (NToWord WLen 0x4c%N)] [PUSH 1 (NToWord WLen 0x73%N);DUP 7;Opcode CALLER;PUSH 1 (NToWord WLen 0x4c%N)] 6 optimize_id).

(*
 I: PUSH [tag] 117
 O: PUSH [tag] 117
*)
Compute pair "ERC721A_run_code_of_0_block_84_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x75%N)] [PUSH 1 (NToWord WLen 0x75%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 2CE44B5F PUSH E1 SHL DUP2
 O: PUSH 40 MLOAD PUSH 2ce44b5f PUSH e1 SHL DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_85_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x2ce44b5f%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x2CE44B5F%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_85_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP6 AND PUSH [tag] 118
 O: PUSH 1 DUP1 PUSH a0 SHL SUB DUP6 AND PUSH [tag] 118
*)
Compute pair "ERC721A_run_code_of_0_block_86_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 6;Opcode AND;PUSH 1 (NToWord WLen 0x76%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 6;Opcode AND;PUSH 1 (NToWord WLen 0x76%N)] 5 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 3A954ECD PUSH E2 SHL DUP2
 O: PUSH 40 MLOAD PUSH 3a954ecd PUSH e2 SHL DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_87_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x3a954ecd%N);PUSH 1 (NToWord WLen 0xe2%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x3A954ECD%N);PUSH 1 (NToWord WLen 0xE2%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_87_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: DUP1 ISZERO PUSH [tag] 121
 O: DUP1 ISZERO PUSH [tag] 121
*)
Compute pair "ERC721A_run_code_of_0_block_88_0"%string (equiv_checker [DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x79%N)] [DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x79%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP3
 O: PUSH 0 DUP3
*)
Compute pair "ERC721A_run_code_of_0_block_89_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3] [PUSH 1 (NToWord WLen 0x0%N);DUP 3] 2 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP7 DUP2 AND PUSH 0 SWAP1 DUP2
 O: PUSH 1 DUP1 PUSH a0 SHL SUB PUSH 0 DUP8 DUP3 AND DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_90_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 8;DUP 3;Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 7;DUP 2;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] 6 optimize_id).

(*
 I: PUSH 5 PUSH 20
 O: PUSH 5 PUSH 20
*)
Compute pair "ERC721A_run_code_of_0_block_90_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 DUP1 DUP3 KECCAK256 DUP1 SLOAD PUSH 0 NOT ADD SWAP1
 O: PUSH 40 DUP1 DUP3 KECCAK256 DUP1 SLOAD PUSH 0 NOT ADD SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_90_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;DUP 3;Opcode KECCAK256;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;Opcode ADD;DUP 1] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;DUP 3;Opcode KECCAK256;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;Opcode ADD;DUP 1] 1 optimize_id).

(*
 I: SWAP2 DUP8 AND DUP1 DUP3
 O: SWAP2 DUP8 AND DUP1 DUP3
*)
Compute pair "ERC721A_run_code_of_0_block_90_3"%string (equiv_checker [DUP 2;DUP 8;Opcode AND;DUP 1;DUP 3] [DUP 2;DUP 8;Opcode AND;DUP 1;DUP 3] 8 optimize_id).

(*
 I: SWAP2 SWAP1 KECCAK256 DUP1 SLOAD PUSH 1 ADD SWAP1
 O: SWAP2 SWAP1 KECCAK256 DUP1 SLOAD PUSH 1 ADD SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_90_4"%string (equiv_checker [DUP 2;DUP 1;Opcode KECCAK256;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1] [DUP 2;DUP 1;Opcode KECCAK256;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 1] 3 optimize_id).

(*
 I: TIMESTAMP PUSH A0 SHL OR PUSH 1 PUSH E1 SHL OR PUSH 0 DUP6 DUP2
 O: TIMESTAMP PUSH a0 SHL OR PUSH 1 PUSH e1 SHL OR PUSH 0 DUP6 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_90_5"%string (equiv_checker [Opcode TIMESTAMP;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode OR;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;Opcode OR;PUSH 1 (NToWord WLen 0x0%N);DUP 6;DUP 2] [Opcode TIMESTAMP;PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode OR;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;Opcode OR;PUSH 1 (NToWord WLen 0x0%N);DUP 6;DUP 2] 5 optimize_id).

(*
 I: PUSH 4 PUSH 20
 O: PUSH 4 PUSH 20
*)
Compute pair "ERC721A_run_code_of_0_block_90_6"%string (equiv_checker [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256
 O: PUSH 40 SWAP1 KECCAK256
*)
Compute pair "ERC721A_run_code_of_0_block_90_7"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256] 1 optimize_id).

(*
 I: PUSH 1 PUSH E1 SHL DUP4 AND PUSH [tag] 126
 O: DUP3 PUSH 1 PUSH e1 SHL AND PUSH [tag] 126
*)
Compute pair "ERC721A_run_code_of_0_block_90_8"%string (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;Opcode AND;PUSH 1 (NToWord WLen 0x7e%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;DUP 4;Opcode AND;PUSH 1 (NToWord WLen 0x7e%N)] 3 optimize_id).

(*
 I: PUSH 1 DUP5 ADD PUSH 0 DUP2 DUP2
 O: DUP4 PUSH 1 ADD PUSH 0 DUP2 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_91_0"%string (equiv_checker [DUP 4;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] [PUSH 1 (NToWord WLen 0x1%N);DUP 5;Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] 4 optimize_id).

(*
 I: PUSH 4 PUSH 20
 O: PUSH 4 PUSH 20
*)
Compute pair "ERC721A_run_code_of_0_block_91_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH [tag] 128
 O: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH [tag] 128
*)
Compute pair "ERC721A_run_code_of_0_block_91_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0x80%N)] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0x80%N)] 1 optimize_id).

(*
 I: PUSH 0 SLOAD DUP2 EQ PUSH [tag] 128
 O: DUP1 PUSH 0 SLOAD EQ PUSH [tag] 128
*)
Compute pair "ERC721A_run_code_of_0_block_92_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;Opcode EQ;PUSH 1 (NToWord WLen 0x80%N)] [PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 2;Opcode EQ;PUSH 1 (NToWord WLen 0x80%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP2 DUP2
 O: PUSH 0 DUP2 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_93_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] 1 optimize_id).

(*
 I: PUSH 4 PUSH 20
 O: PUSH 4 PUSH 20
*)
Compute pair "ERC721A_run_code_of_0_block_93_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 DUP5 SWAP1
 O: PUSH 40 DUP6 SWAP2 KECCAK256
*)
Compute pair "ERC721A_run_code_of_0_block_93_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 6;DUP 2;Opcode KECCAK256] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;DUP 5;DUP 1] 5 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "ERC721A_run_code_of_0_block_94_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: POP POP POP POP POP POP
 O: POP POP POP POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_95_1"%string (equiv_checker [POP;POP;POP;POP;POP;POP] [POP;POP;POP;POP;POP;POP] 6 optimize_id).

(*
 I: PUSH [tag] 132 DUP4 DUP4 DUP4 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH [tag] 132 DUP4 DUP4 DUP4 PUSH 40 MLOAD PUSH 20 DUP2 ADD PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_96_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x84%N);DUP 4;DUP 4;DUP 4;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [PUSH 1 (NToWord WLen 0x84%N);DUP 4;DUP 4;DUP 4;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 3 optimize_id).

(*
 I: DUP1 PUSH 0 DUP2
 O: DUP1 PUSH 0 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_96_1"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 2] [DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 2] 1 optimize_id).

(*
 I: POP PUSH [tag] 70
 O: POP PUSH [tag] 70
*)
Compute pair "ERC721A_run_code_of_0_block_96_2"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x46%N)] [POP;PUSH 1 (NToWord WLen 0x46%N)] 1 optimize_id).

(*
 I: POP POP POP
 O: POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_97_0"%string (equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 82 DUP3 PUSH [tag] 107
 O: PUSH 0 PUSH [tag] 82 DUP3 PUSH [tag] 107
*)
Compute pair "ERC721A_run_code_of_0_block_98_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x52%N);DUP 3;PUSH 1 (NToWord WLen 0x6b%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x52%N);DUP 3;PUSH 1 (NToWord WLen 0x6b%N)] 1 optimize_id).

(*
 I: PUSH 0 PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP3 AND PUSH [tag] 136
 O: PUSH 0 PUSH 1 DUP1 PUSH a0 SHL SUB DUP3 AND PUSH [tag] 136
*)
Compute pair "ERC721A_run_code_of_0_block_99_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 3;Opcode AND;PUSH 1 (NToWord WLen 0x88%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 3;Opcode AND;PUSH 1 (NToWord WLen 0x88%N)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 23D3AD81 PUSH E2 SHL DUP2
 O: PUSH 40 MLOAD PUSH 23d3ad81 PUSH e2 SHL DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_100_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x23d3ad81%N);PUSH 1 (NToWord WLen 0xe2%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x23D3AD81%N);PUSH 1 (NToWord WLen 0xE2%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_100_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: POP PUSH 1 PUSH 1 PUSH A0 SHL SUB AND PUSH 0 SWAP1 DUP2
 O: POP PUSH 1 DUP1 PUSH a0 SHL SUB PUSH 0 SWAP2 AND DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_101_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode AND;DUP 2] [POP;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] 2 optimize_id).

(*
 I: PUSH 5 PUSH 20
 O: PUSH 5 PUSH 20
*)
Compute pair "ERC721A_run_code_of_0_block_101_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x5%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH FFFFFFFFFFFFFFFF AND SWAP1
 O: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH ffffffffffffffff AND SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_101_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);Opcode AND;DUP 1] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);Opcode AND;DUP 1] 2 optimize_id).

(*
 I: PUSH 60 PUSH 3 DUP1 SLOAD PUSH [tag] 84 SWAP1 PUSH [tag] 85
 O: PUSH 60 PUSH 3 PUSH [tag] 84 DUP2 SLOAD PUSH [tag] 85
*)
Compute pair "ERC721A_run_code_of_0_block_102_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x3%N);PUSH 1 (NToWord WLen 0x54%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0x55%N)] [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x3%N);DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0x54%N);DUP 1;PUSH 1 (NToWord WLen 0x55%N)] 0 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP3 AND CALLER EQ ISZERO PUSH [tag] 145
 O: DUP2 PUSH 1 DUP1 PUSH a0 SHL SUB AND CALLER EQ ISZERO PUSH [tag] 145
*)
Compute pair "ERC721A_run_code_of_0_block_103_0"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode CALLER;Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0x91%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 3;Opcode AND;Opcode CALLER;Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0x91%N)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH B06307DB PUSH E0 SHL DUP2
 O: PUSH 40 MLOAD PUSH b06307db PUSH e0 SHL DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_104_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0xb06307db%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0xB06307DB%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_104_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: CALLER PUSH 0 DUP2 DUP2
 O: CALLER PUSH 0 DUP2 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_105_0"%string (equiv_checker [Opcode CALLER;PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] [Opcode CALLER;PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] 0 optimize_id).

(*
 I: PUSH 7 PUSH 20 SWAP1 DUP2
 O: PUSH 20 PUSH 7 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_105_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x7%N);DUP 2] [PUSH 1 (NToWord WLen 0x7%N);PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 2] 0 optimize_id).

(*
 I: PUSH 40 DUP1 DUP4 KECCAK256 PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP8 AND DUP1 DUP6
 O: PUSH 40 DUP1 DUP4 KECCAK256 PUSH 1 DUP1 PUSH a0 SHL SUB DUP8 AND DUP1 DUP6
*)
Compute pair "ERC721A_run_code_of_0_block_105_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;DUP 4;Opcode KECCAK256;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 8;Opcode AND;DUP 1;DUP 6] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;DUP 4;Opcode KECCAK256;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 8;Opcode AND;DUP 1;DUP 6] 5 optimize_id).

(*
 I: SWAP1 DUP4
 O: SWAP1 DUP4
*)
Compute pair "ERC721A_run_code_of_0_block_105_3"%string (equiv_checker [DUP 1;DUP 4] [DUP 1;DUP 4] 4 optimize_id).

(*
 I: SWAP3 DUP2 SWAP1 KECCAK256 DUP1 SLOAD PUSH FF NOT AND DUP7 ISZERO ISZERO SWAP1 DUP2 OR SWAP1 SWAP2
 O: DUP2 DUP7 ISZERO ISZERO SWAP2 SWAP5 KECCAK256 DUP2 PUSH ff NOT DUP3 SLOAD AND OR SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_105_4"%string (equiv_checker [DUP 2;DUP 7;Opcode ISZERO;Opcode ISZERO;DUP 2;DUP 5;Opcode KECCAK256;DUP 2;PUSH 1 (NToWord WLen 0xff%N);Opcode NOT;DUP 3;Opcode SLOAD;Opcode AND;Opcode OR;DUP 1] [DUP 3;DUP 2;DUP 1;Opcode KECCAK256;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xFF%N);Opcode NOT;Opcode AND;DUP 7;Opcode ISZERO;Opcode ISZERO;DUP 1;DUP 2;Opcode OR;DUP 1;DUP 2] 6 optimize_id).

(*
 I: SWAP1 MLOAD SWAP1 DUP2
 O: SWAP1 MLOAD SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_105_5"%string (equiv_checker [DUP 1;Opcode MLOAD;DUP 1;DUP 2] [DUP 1;Opcode MLOAD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: SWAP2 SWAP3 SWAP2 PUSH 17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C31 SWAP2 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: ADD PUSH 40 MLOAD DUP1 SWAP4 SWAP3 SWAP4 SWAP2 SUB PUSH 17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31 SWAP2
*)
Compute pair "ERC721A_run_code_of_0_block_105_6"%string (equiv_checker [Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 4;DUP 3;DUP 4;DUP 2;Opcode SUB;PUSH 32 (NToWord WLen 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31%N);DUP 2] [DUP 2;DUP 3;DUP 2;PUSH 32 (NToWord WLen 0x17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C31%N);DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 4 optimize_id).

(*
 I: POP POP
 O: POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_105_7"%string (equiv_checker [POP;POP] [POP;POP] 2 optimize_id).

(*
 I: PUSH [tag] 150 DUP5 DUP5 DUP5 PUSH [tag] 47
 O: PUSH [tag] 150 DUP5 DUP5 DUP5 PUSH [tag] 47
*)
Compute pair "ERC721A_run_code_of_0_block_106_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x96%N);DUP 5;DUP 5;DUP 5;PUSH 1 (NToWord WLen 0x2f%N)] [PUSH 1 (NToWord WLen 0x96%N);DUP 5;DUP 5;DUP 5;PUSH 1 (NToWord WLen 0x2f%N)] 4 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP4 AND EXTCODESIZE ISZERO PUSH [tag] 154
 O: DUP3 PUSH 1 DUP1 PUSH a0 SHL SUB AND EXTCODESIZE ISZERO PUSH [tag] 154
*)
Compute pair "ERC721A_run_code_of_0_block_107_0"%string (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode EXTCODESIZE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x9a%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 4;Opcode AND;Opcode EXTCODESIZE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x9a%N)] 3 optimize_id).

(*
 I: PUSH [tag] 152 DUP5 DUP5 DUP5 DUP5 PUSH [tag] 153
 O: PUSH [tag] 152 DUP5 DUP5 DUP5 DUP5 PUSH [tag] 153
*)
Compute pair "ERC721A_run_code_of_0_block_108_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x98%N);DUP 5;DUP 5;DUP 5;DUP 5;PUSH 1 (NToWord WLen 0x99%N)] [PUSH 1 (NToWord WLen 0x98%N);DUP 5;DUP 5;DUP 5;DUP 5;PUSH 1 (NToWord WLen 0x99%N)] 4 optimize_id).

(*
 I: PUSH [tag] 154
 O: PUSH [tag] 154
*)
Compute pair "ERC721A_run_code_of_0_block_109_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x9a%N)] [PUSH 1 (NToWord WLen 0x9a%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 68D2BF6B PUSH E1 SHL DUP2
 O: PUSH 40 MLOAD PUSH 68d2bf6b PUSH e1 SHL DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_110_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x68d2bf6b%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x68D2BF6B%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_110_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_111_0"%string (equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id).

(*
 I: PUSH 60 PUSH [tag] 156 DUP3 PUSH [tag] 92
 O: PUSH 60 PUSH [tag] 156 DUP3 PUSH [tag] 92
*)
Compute pair "ERC721A_run_code_of_0_block_112_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x9c%N);DUP 3;PUSH 1 (NToWord WLen 0x5c%N)] [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x9c%N);DUP 3;PUSH 1 (NToWord WLen 0x5c%N)] 1 optimize_id).

(*
 I: PUSH [tag] 157
 O: PUSH [tag] 157
*)
Compute pair "ERC721A_run_code_of_0_block_113_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x9d%N)] [PUSH 1 (NToWord WLen 0x9d%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH A14C4B5 PUSH E4 SHL DUP2
 O: PUSH 40 MLOAD PUSH a14c4b5 PUSH e4 SHL DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_114_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0xa14c4b5%N);PUSH 1 (NToWord WLen 0xe4%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0xA14C4B5%N);PUSH 1 (NToWord WLen 0xE4%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_114_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 158 PUSH 40 DUP1 MLOAD PUSH 20 DUP2 ADD SWAP1 SWAP2
 O: PUSH 0 PUSH [tag] 158 PUSH 40 MLOAD PUSH 20 DUP2 ADD PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_115_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x9e%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x9e%N);PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;DUP 1;DUP 2] 0 optimize_id).

(*
 I: PUSH 0 DUP2
 O: PUSH 0 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_115_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2] [PUSH 1 (NToWord WLen 0x0%N);DUP 2] 1 optimize_id).

(*
 I: SWAP1
 O: SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_115_2"%string (equiv_checker [DUP 1] [DUP 1] 2 optimize_id).

(*
 I: SWAP1 POP DUP1 MLOAD PUSH 0 EQ ISZERO PUSH [tag] 160
 O: DUP1 SWAP2 POP MLOAD PUSH 0 EQ ISZERO PUSH [tag] 160
*)
Compute pair "ERC721A_run_code_of_0_block_116_0"%string (equiv_checker [DUP 1;DUP 2;POP;Opcode MLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0xa0%N)] [DUP 1;POP;DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0xa0%N)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_117_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 0 optimize_id).

(*
 I: DUP1 PUSH 0 DUP2
 O: DUP1 PUSH 0 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_117_1"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 2] [DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 2] 1 optimize_id).

(*
 I: POP PUSH [tag] 161
 O: POP PUSH [tag] 161
*)
Compute pair "ERC721A_run_code_of_0_block_117_2"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0xa1%N)] [POP;PUSH 1 (NToWord WLen 0xa1%N)] 1 optimize_id).

(*
 I: DUP1 PUSH [tag] 162 DUP5 PUSH [tag] 163
 O: DUP1 PUSH [tag] 162 DUP5 PUSH [tag] 163
*)
Compute pair "ERC721A_run_code_of_0_block_118_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0xa2%N);DUP 5;PUSH 1 (NToWord WLen 0xa3%N)] [DUP 1;PUSH 1 (NToWord WLen 0xa2%N);DUP 5;PUSH 1 (NToWord WLen 0xa3%N)] 3 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 20 ADD PUSH [tag] 164 SWAP3 SWAP2 SWAP1 PUSH [tag] 165
 O: PUSH [tag] 164 SWAP2 SWAP1 PUSH 20 PUSH 40 MLOAD ADD PUSH [tag] 165
*)
Compute pair "ERC721A_run_code_of_0_block_119_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xa4%N);DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;Opcode ADD;PUSH 1 (NToWord WLen 0xa5%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0xa4%N);DUP 3;DUP 2;DUP 1;PUSH 1 (NToWord WLen 0xa5%N)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 20 DUP2 DUP4 SUB SUB DUP2
 O: PUSH 40 MLOAD PUSH 20 DUP2 DUP4 SUB SUB DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_120_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);DUP 2;DUP 4;Opcode SUB;Opcode SUB;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);DUP 2;DUP 4;Opcode SUB;Opcode SUB;DUP 2] 1 optimize_id).

(*
 I: SWAP1 PUSH 40
 O: SWAP1 PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_120_1"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x40%N)] [DUP 1;PUSH 1 (NToWord WLen 0x40%N)] 2 optimize_id).

(*
 I: SWAP4 SWAP3 POP POP POP
 O: SWAP4 SWAP3 POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_121_0"%string (equiv_checker [DUP 4;DUP 3;POP;POP;POP] [DUP 4;DUP 3;POP;POP;POP] 5 optimize_id).

(*
 I: PUSH 0 DUP1 SLOAD DUP3 LT DUP1 ISZERO PUSH [tag] 82
 O: PUSH 0 DUP1 SLOAD DUP3 LT DUP1 ISZERO PUSH [tag] 82
*)
Compute pair "ERC721A_run_code_of_0_block_122_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;Opcode SLOAD;DUP 3;Opcode LT;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x52%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;Opcode SLOAD;DUP 3;Opcode LT;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x52%N)] 1 optimize_id).

(*
 I: POP POP PUSH 0 SWAP1 DUP2
 O: POP POP PUSH 0 SWAP1 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_123_0"%string (equiv_checker [POP;POP;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] [POP;POP;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] 3 optimize_id).

(*
 I: PUSH 4 PUSH 20
 O: PUSH 4 PUSH 20
*)
Compute pair "ERC721A_run_code_of_0_block_123_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH 1 PUSH E0 SHL AND ISZERO SWAP1
 O: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH 1 PUSH e0 SHL AND ISZERO SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_123_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode AND;Opcode ISZERO;DUP 1] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;Opcode AND;Opcode ISZERO;DUP 1] 2 optimize_id).

(*
 I: PUSH 0 DUP2 PUSH 0 SLOAD DUP2 LT ISZERO PUSH [tag] 176
 O: PUSH 0 DUP2 DUP2 SLOAD DUP2 LT ISZERO PUSH [tag] 176
*)
Compute pair "ERC721A_run_code_of_0_block_124_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2;Opcode SLOAD;DUP 2;Opcode LT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb0%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 2;Opcode LT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb0%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP2 DUP2
 O: PUSH 0 DUP2 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_125_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] 1 optimize_id).

(*
 I: PUSH 4 PUSH 20
 O: PUSH 4 PUSH 20
*)
Compute pair "ERC721A_run_code_of_0_block_125_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH 1 PUSH E0 SHL DUP2 AND PUSH [tag] 177
 O: PUSH 40 SWAP1 KECCAK256 SLOAD DUP1 PUSH 1 PUSH e0 SHL AND PUSH [tag] 177
*)
Compute pair "ERC721A_run_code_of_0_block_125_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;DUP 1;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode AND;PUSH 1 (NToWord WLen 0xb1%N)] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;DUP 2;Opcode AND;PUSH 1 (NToWord WLen 0xb1%N)] 1 optimize_id).

(*
 I: DUP1 PUSH [tag] 161
 O: DUP1 PUSH [tag] 161
*)
Compute pair "ERC721A_run_code_of_0_block_126_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0xa1%N)] [DUP 1;PUSH 1 (NToWord WLen 0xa1%N)] 1 optimize_id).

(*
 I: POP PUSH 0 NOT ADD PUSH 0 DUP2 DUP2
 O: POP PUSH 0 NOT ADD PUSH 0 DUP2 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_127_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] [POP;PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2] 2 optimize_id).

(*
 I: PUSH 4 PUSH 20
 O: PUSH 4 PUSH 20
*)
Compute pair "ERC721A_run_code_of_0_block_127_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x4%N);PUSH 1 (NToWord WLen 0x20%N)] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH [tag] 178
 O: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH [tag] 178
*)
Compute pair "ERC721A_run_code_of_0_block_127_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0xb2%N)] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0xb2%N)] 1 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "ERC721A_run_code_of_0_block_128_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 6F96CDA1 PUSH E1 SHL DUP2
 O: PUSH 40 MLOAD PUSH 6f96cda1 PUSH e1 SHL DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_129_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x6f96cda1%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x6F96CDA1%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_129_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH A85BD01 PUSH E1 SHL DUP2
 O: PUSH 40 MLOAD PUSH a85bd01 PUSH e1 SHL DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_130_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0xa85bd01%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0xA85BD01%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP1 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 192
 O: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP9 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 192
*)
Compute pair "ERC721A_run_code_of_0_block_131_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (NToWord WLen 0x0%N);DUP 8;DUP 9;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc0%N)] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (NToWord WLen 0x0%N);DUP 8;DUP 1;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc0%N)] 3 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_132_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP GAS
 O: POP GAS
*)
Compute pair "ERC721A_run_code_of_0_block_133_0"%string (equiv_checker [POP;Opcode GAS] [POP;Opcode GAS] 1 optimize_id).

(*
 I: SWAP3 POP POP POP DUP1 ISZERO PUSH [tag] 193
 O: SWAP3 POP POP POP DUP1 ISZERO PUSH [tag] 193
*)
Compute pair "ERC721A_run_code_of_0_block_133_1"%string (equiv_checker [DUP 3;POP;POP;POP;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc1%N)] [DUP 3;POP;POP;POP;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc1%N)] 4 optimize_id).

(*
 I: POP PUSH 40 DUP1 MLOAD PUSH 1F RETURNDATASIZE SWAP1 DUP2 ADD PUSH 1F NOT AND DUP3 ADD SWAP1 SWAP3
 O: POP RETURNDATASIZE PUSH 40 MLOAD DUP1 DUP3 PUSH 1f DUP1 NOT SWAP2 ADD AND ADD PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_134_0"%string (equiv_checker [POP;Opcode RETURNDATASIZE;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 3;PUSH 1 (NToWord WLen 0x1f%N);DUP 1;Opcode NOT;DUP 2;Opcode ADD;Opcode AND;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [POP;PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1F%N);Opcode RETURNDATASIZE;DUP 1;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;Opcode AND;DUP 3;Opcode ADD;DUP 1;DUP 3] 1 optimize_id).

(*
 I: PUSH [tag] 194 SWAP2 DUP2 ADD SWAP1 PUSH [tag] 195
 O: PUSH [tag] 194 SWAP2 DUP2 ADD SWAP1 PUSH [tag] 195
*)
Compute pair "ERC721A_run_code_of_0_block_134_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0xc2%N);DUP 2;DUP 2;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0xc3%N)] [PUSH 1 (NToWord WLen 0xc2%N);DUP 2;DUP 2;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0xc3%N)] 2 optimize_id).

(*
 I: PUSH 1
 O: PUSH 1
*)
Compute pair "ERC721A_run_code_of_0_block_135_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N)] [PUSH 1 (NToWord WLen 0x1%N)] 0 optimize_id).

(*
 I: PUSH [tag] 196
 O: PUSH [tag] 196
*)
Compute pair "ERC721A_run_code_of_0_block_136_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xc4%N)] [PUSH 1 (NToWord WLen 0xc4%N)] 0 optimize_id).

(*
 I: RETURNDATASIZE DUP1 DUP1 ISZERO PUSH [tag] 201
 O: RETURNDATASIZE DUP1 RETURNDATASIZE ISZERO PUSH [tag] 201
*)
Compute pair "ERC721A_run_code_of_0_block_137_0"%string (equiv_checker [Opcode RETURNDATASIZE;DUP 1;Opcode RETURNDATASIZE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc9%N)] [Opcode RETURNDATASIZE;DUP 1;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc9%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD SWAP2 POP PUSH 1F NOT PUSH 3F RETURNDATASIZE ADD AND DUP3 ADD PUSH 40
 O: PUSH 1f PUSH 40 MLOAD SWAP3 POP NOT RETURNDATASIZE PUSH 3f ADD AND DUP3 ADD PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_138_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 3;POP;Opcode NOT;Opcode RETURNDATASIZE;PUSH 1 (NToWord WLen 0x3f%N);Opcode ADD;Opcode AND;DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 2;POP;PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;PUSH 1 (NToWord WLen 0x3F%N);Opcode RETURNDATASIZE;Opcode ADD;Opcode AND;DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 2 optimize_id).

(*
 I: RETURNDATASIZE DUP3
 O: RETURNDATASIZE DUP3
*)
Compute pair "ERC721A_run_code_of_0_block_138_1"%string (equiv_checker [Opcode RETURNDATASIZE;DUP 3] [Opcode RETURNDATASIZE;DUP 3] 2 optimize_id).

(*
 I: RETURNDATASIZE PUSH 0 PUSH 20 DUP5 ADD
 O: RETURNDATASIZE PUSH 0 PUSH 20 DUP5 ADD
*)
Compute pair "ERC721A_run_code_of_0_block_138_2"%string (equiv_checker [Opcode RETURNDATASIZE;PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD] [Opcode RETURNDATASIZE;PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD] 2 optimize_id).

(*
 I: PUSH [tag] 200
 O: PUSH [tag] 200
*)
Compute pair "ERC721A_run_code_of_0_block_138_3"%string (equiv_checker [PUSH 1 (NToWord WLen 0xc8%N)] [PUSH 1 (NToWord WLen 0xc8%N)] 0 optimize_id).

(*
 I: PUSH 60 SWAP2 POP
 O: PUSH 60 SWAP2 POP
*)
Compute pair "ERC721A_run_code_of_0_block_139_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);DUP 2;POP] [PUSH 1 (NToWord WLen 0x60%N);DUP 2;POP] 2 optimize_id).

(*
 I: POP DUP1 MLOAD PUSH [tag] 202
 O: POP DUP1 MLOAD PUSH [tag] 202
*)
Compute pair "ERC721A_run_code_of_0_block_140_0"%string (equiv_checker [POP;DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0xca%N)] [POP;DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0xca%N)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 68D2BF6B PUSH E1 SHL DUP2
 O: PUSH 40 MLOAD PUSH 68d2bf6b PUSH e1 SHL DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_141_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x68d2bf6b%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 4 (NToWord WLen 0x68D2BF6B%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;DUP 2] 0 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_141_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: DUP1 MLOAD DUP2 PUSH 20 ADD
 O: DUP1 MLOAD DUP2 PUSH 20 ADD
*)
Compute pair "ERC721A_run_code_of_0_block_142_0"%string (equiv_checker [DUP 1;Opcode MLOAD;DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD] [DUP 1;Opcode MLOAD;DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD] 1 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH E0 SHL SUB NOT AND PUSH A85BD01 PUSH E1 SHL EQ SWAP1 POP SWAP5 SWAP4 POP POP POP POP
 O: PUSH 1 DUP1 PUSH e0 SHL SUB NOT AND SWAP5 POP POP PUSH a85bd01 SWAP3 POP POP POP PUSH e1 SHL EQ SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_143_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode SUB;Opcode NOT;Opcode AND;DUP 5;POP;POP;PUSH 4 (NToWord WLen 0xa85bd01%N);DUP 3;POP;POP;POP;PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;Opcode EQ;DUP 1] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;Opcode SUB;Opcode NOT;Opcode AND;PUSH 4 (NToWord WLen 0xA85BD01%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;Opcode EQ;DUP 1;POP;DUP 5;DUP 4;POP;POP;POP;POP] 7 optimize_id).

(*
 I: PUSH 40 DUP1 MLOAD PUSH 80 ADD SWAP1 DUP2 SWAP1
 O: PUSH 40 MLOAD PUSH 80 ADD DUP1 PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_144_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x80%N);Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x40%N)] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x80%N);Opcode ADD;DUP 1;DUP 2;DUP 1] 0 optimize_id).

(*
 I: DUP1 DUP3
 O: DUP1 DUP3
*)
Compute pair "ERC721A_run_code_of_0_block_144_1"%string (equiv_checker [DUP 1;DUP 3] [DUP 1;DUP 3] 2 optimize_id).

(*
 I: PUSH 1 DUP4 SUB SWAP3 POP PUSH A DUP2 MOD PUSH 30 ADD DUP4
 O: PUSH 1 PUSH 30 SWAP4 SUB SWAP3 PUSH a DUP3 MOD ADD DUP4
*)
Compute pair "ERC721A_run_code_of_0_block_145_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x30%N);DUP 4;Opcode SUB;DUP 3;PUSH 1 (NToWord WLen 0xa%N);DUP 3;Opcode MOD;Opcode ADD;DUP 4] [PUSH 1 (NToWord WLen 0x1%N);DUP 4;Opcode SUB;DUP 3;POP;PUSH 1 (NToWord WLen 0xA%N);DUP 2;Opcode MOD;PUSH 1 (NToWord WLen 0x30%N);Opcode ADD;DUP 4] 3 optimize_id).

(*
 I: PUSH A SWAP1 DIV DUP1 PUSH [tag] 210
 O: PUSH a SWAP1 DIV DUP1 PUSH [tag] 210
*)
Compute pair "ERC721A_run_code_of_0_block_145_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0xa%N);DUP 1;Opcode DIV;DUP 1;PUSH 1 (NToWord WLen 0xd2%N)] [PUSH 1 (NToWord WLen 0xA%N);DUP 1;Opcode DIV;DUP 1;PUSH 1 (NToWord WLen 0xd2%N)] 1 optimize_id).

(*
 I: PUSH [tag] 209
 O: PUSH [tag] 209
*)
Compute pair "ERC721A_run_code_of_0_block_146_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xd1%N)] [PUSH 1 (NToWord WLen 0xd1%N)] 0 optimize_id).

(*
 I: PUSH [tag] 207
 O: PUSH [tag] 207
*)
Compute pair "ERC721A_run_code_of_0_block_147_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xcf%N)] [PUSH 1 (NToWord WLen 0xcf%N)] 0 optimize_id).

(*
 I: POP DUP2 SWAP1 SUB PUSH 1F NOT SWAP1 SWAP2 ADD SWAP1 DUP2
 O: POP DUP2 PUSH 1f NOT ADD SWAP2 SWAP1 SUB DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_148_0"%string (equiv_checker [POP;DUP 2;PUSH 1 (NToWord WLen 0x1f%N);Opcode NOT;Opcode ADD;DUP 2;DUP 1;Opcode SUB;DUP 2] [POP;DUP 2;DUP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;DUP 1;DUP 2;Opcode ADD;DUP 1;DUP 2] 3 optimize_id).

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Compute pair "ERC721A_run_code_of_0_block_148_1"%string (equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: DUP1 CALLDATALOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP2 AND DUP2 EQ PUSH [tag] 215
 O: DUP1 CALLDATALOAD DUP1 PUSH 1 DUP1 PUSH a0 SHL SUB DUP2 AND EQ PUSH [tag] 215
*)
Compute pair "ERC721A_run_code_of_0_block_149_0"%string (equiv_checker [DUP 1;Opcode CALLDATALOAD;DUP 1;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 2;Opcode AND;Opcode EQ;PUSH 1 (NToWord WLen 0xd7%N)] [DUP 1;Opcode CALLDATALOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 2;Opcode AND;DUP 2;Opcode EQ;PUSH 1 (NToWord WLen 0xd7%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_150_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Compute pair "ERC721A_run_code_of_0_block_151_0"%string (equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 217
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 217
*)
Compute pair "ERC721A_run_code_of_0_block_152_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xd9%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xd9%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_153_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 161 DUP3 PUSH [tag] 213
 O: PUSH [tag] 161 DUP3 PUSH [tag] 213
*)
Compute pair "ERC721A_run_code_of_0_block_154_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xa1%N);DUP 3;PUSH 1 (NToWord WLen 0xd5%N)] [PUSH 1 (NToWord WLen 0xa1%N);DUP 3;PUSH 1 (NToWord WLen 0xd5%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 220
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 220
*)
Compute pair "ERC721A_run_code_of_0_block_155_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xdc%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xdc%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_156_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 221 DUP4 PUSH [tag] 213
 O: PUSH [tag] 221 DUP4 PUSH [tag] 213
*)
Compute pair "ERC721A_run_code_of_0_block_157_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xdd%N);DUP 4;PUSH 1 (NToWord WLen 0xd5%N)] [PUSH 1 (NToWord WLen 0xdd%N);DUP 4;PUSH 1 (NToWord WLen 0xd5%N)] 3 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 222 PUSH 20 DUP5 ADD PUSH [tag] 213
 O: SWAP2 POP PUSH [tag] 222 PUSH 20 DUP5 ADD PUSH [tag] 213
*)
Compute pair "ERC721A_run_code_of_0_block_158_0"%string (equiv_checker [DUP 2;POP;PUSH 1 (NToWord WLen 0xde%N);PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;PUSH 1 (NToWord WLen 0xd5%N)] [DUP 2;POP;PUSH 1 (NToWord WLen 0xde%N);PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;PUSH 1 (NToWord WLen 0xd5%N)] 4 optimize_id).

(*
 I: SWAP1 POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP4 POP POP SWAP1 POP SWAP2
*)
Compute pair "ERC721A_run_code_of_0_block_159_0"%string (equiv_checker [DUP 4;POP;POP;DUP 1;POP;DUP 2] [DUP 1;POP;DUP 3;POP;DUP 3;DUP 1;POP] 6 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 0 PUSH 60 DUP5 DUP7 SUB SLT ISZERO PUSH [tag] 224
 O: PUSH 0 DUP1 DUP2 PUSH 60 DUP5 DUP7 SUB SLT ISZERO PUSH [tag] 224
*)
Compute pair "ERC721A_run_code_of_0_block_160_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x60%N);DUP 5;DUP 7;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xe0%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x60%N);DUP 5;DUP 7;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xe0%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_161_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 225 DUP5 PUSH [tag] 213
 O: PUSH [tag] 225 DUP5 PUSH [tag] 213
*)
Compute pair "ERC721A_run_code_of_0_block_162_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xe1%N);DUP 5;PUSH 1 (NToWord WLen 0xd5%N)] [PUSH 1 (NToWord WLen 0xe1%N);DUP 5;PUSH 1 (NToWord WLen 0xd5%N)] 4 optimize_id).

(*
 I: SWAP3 POP PUSH [tag] 226 PUSH 20 DUP6 ADD PUSH [tag] 213
 O: SWAP3 POP PUSH [tag] 226 DUP5 PUSH 20 ADD PUSH [tag] 213
*)
Compute pair "ERC721A_run_code_of_0_block_163_0"%string (equiv_checker [DUP 3;POP;PUSH 1 (NToWord WLen 0xe2%N);DUP 5;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0xd5%N)] [DUP 3;POP;PUSH 1 (NToWord WLen 0xe2%N);PUSH 1 (NToWord WLen 0x20%N);DUP 6;Opcode ADD;PUSH 1 (NToWord WLen 0xd5%N)] 5 optimize_id).

(*
 I: SWAP2 POP PUSH 40 DUP5 ADD CALLDATALOAD SWAP1 POP SWAP3 POP SWAP3 POP SWAP3
 O: SWAP4 PUSH 40 ADD CALLDATALOAD SWAP4 SWAP5 POP POP POP SWAP3
*)
Compute pair "ERC721A_run_code_of_0_block_164_0"%string (equiv_checker [DUP 4;PUSH 1 (NToWord WLen 0x40%N);Opcode ADD;Opcode CALLDATALOAD;DUP 4;DUP 5;POP;POP;POP;DUP 3] [DUP 2;POP;PUSH 1 (NToWord WLen 0x40%N);DUP 5;Opcode ADD;Opcode CALLDATALOAD;DUP 1;POP;DUP 3;POP;DUP 3;POP;DUP 3] 7 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 0 DUP1 PUSH 80 DUP6 DUP8 SUB SLT ISZERO PUSH [tag] 228
 O: PUSH 0 DUP1 DUP1 DUP3 PUSH 80 DUP6 DUP8 SUB SLT ISZERO PUSH [tag] 228
*)
Compute pair "ERC721A_run_code_of_0_block_165_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 1;DUP 3;PUSH 1 (NToWord WLen 0x80%N);DUP 6;DUP 8;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xe4%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x80%N);DUP 6;DUP 8;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xe4%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_166_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 229 DUP6 PUSH [tag] 213
 O: PUSH [tag] 229 DUP6 PUSH [tag] 213
*)
Compute pair "ERC721A_run_code_of_0_block_167_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xe5%N);DUP 6;PUSH 1 (NToWord WLen 0xd5%N)] [PUSH 1 (NToWord WLen 0xe5%N);DUP 6;PUSH 1 (NToWord WLen 0xd5%N)] 5 optimize_id).

(*
 I: SWAP4 POP PUSH [tag] 230 PUSH 20 DUP7 ADD PUSH [tag] 213
 O: SWAP4 POP PUSH [tag] 230 PUSH 20 DUP7 ADD PUSH [tag] 213
*)
Compute pair "ERC721A_run_code_of_0_block_168_0"%string (equiv_checker [DUP 4;POP;PUSH 1 (NToWord WLen 0xe6%N);PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;PUSH 1 (NToWord WLen 0xd5%N)] [DUP 4;POP;PUSH 1 (NToWord WLen 0xe6%N);PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;PUSH 1 (NToWord WLen 0xd5%N)] 6 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_170_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP2 DUP8 ADD SWAP2 POP DUP8 PUSH 1F DUP4 ADD SLT PUSH [tag] 232
 O: DUP8 SWAP2 DUP8 ADD SWAP2 PUSH 1f DUP4 ADD SLT PUSH [tag] 232
*)
Compute pair "ERC721A_run_code_of_0_block_171_0"%string (equiv_checker [DUP 8;DUP 2;DUP 8;Opcode ADD;DUP 2;PUSH 1 (NToWord WLen 0x1f%N);DUP 4;Opcode ADD;Opcode SLT;PUSH 1 (NToWord WLen 0xe8%N)] [DUP 2;DUP 8;Opcode ADD;DUP 2;POP;DUP 8;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;Opcode SLT;PUSH 1 (NToWord WLen 0xe8%N)] 8 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_172_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP2 CALLDATALOAD DUP2 DUP2 GT ISZERO PUSH [tag] 234
 O: DUP2 CALLDATALOAD DUP2 DUP2 GT ISZERO PUSH [tag] 234
*)
Compute pair "ERC721A_run_code_of_0_block_173_0"%string (equiv_checker [DUP 2;Opcode CALLDATALOAD;DUP 2;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xea%N)] [DUP 2;Opcode CALLDATALOAD;DUP 2;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xea%N)] 2 optimize_id).

(*
 I: PUSH [tag] 234 PUSH [tag] 235
 O: PUSH [tag] 234 PUSH [tag] 235
*)
Compute pair "ERC721A_run_code_of_0_block_174_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xea%N);PUSH 1 (NToWord WLen 0xeb%N)] [PUSH 1 (NToWord WLen 0xea%N);PUSH 1 (NToWord WLen 0xeb%N)] 0 optimize_id).

(*
 I: PUSH [tag] 237 PUSH [tag] 235
 O: PUSH [tag] 237 PUSH [tag] 235
*)
Compute pair "ERC721A_run_code_of_0_block_176_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xed%N);PUSH 1 (NToWord WLen 0xeb%N)] [PUSH 1 (NToWord WLen 0xed%N);PUSH 1 (NToWord WLen 0xeb%N)] 0 optimize_id).

(*
 I: DUP2 PUSH 40
 O: DUP2 PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_177_0"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x40%N)] [DUP 2;PUSH 1 (NToWord WLen 0x40%N)] 2 optimize_id).

(*
 I: DUP3 DUP2
 O: DUP3 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_177_1"%string (equiv_checker [DUP 3;DUP 2] [DUP 3;DUP 2] 3 optimize_id).

(*
 I: DUP11 PUSH 20 DUP5 DUP8 ADD ADD GT ISZERO PUSH [tag] 238
 O: DUP11 DUP4 DUP7 ADD PUSH 20 ADD GT ISZERO PUSH [tag] 238
*)
Compute pair "ERC721A_run_code_of_0_block_177_2"%string (equiv_checker [DUP 11;DUP 4;DUP 7;Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xee%N)] [DUP 11;PUSH 1 (NToWord WLen 0x20%N);DUP 5;DUP 8;Opcode ADD;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xee%N)] 11 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_178_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP3 PUSH 20 DUP7 ADD PUSH 20 DUP4 ADD
 O: DUP3 DUP6 PUSH 20 ADD PUSH 20 DUP4 ADD
*)
Compute pair "ERC721A_run_code_of_0_block_179_0"%string (equiv_checker [DUP 3;DUP 6;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD] [DUP 3;PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD] 5 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP5 DUP4 ADD ADD
 O: PUSH 0 PUSH 20 DUP3 DUP6 ADD ADD
*)
Compute pair "ERC721A_run_code_of_0_block_179_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 6;Opcode ADD;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 5;DUP 4;Opcode ADD;Opcode ADD] 3 optimize_id).

(*
 I: DUP1 SWAP6 POP POP POP POP POP POP SWAP3 SWAP6 SWAP2 SWAP5 POP SWAP3 POP
 O: SWAP8 SWAP11 SWAP7 SWAP10 POP POP POP POP POP POP SWAP3 POP
*)
Compute pair "ERC721A_run_code_of_0_block_179_2"%string (equiv_checker [DUP 8;DUP 11;DUP 7;DUP 10;POP;POP;POP;POP;POP;POP;DUP 3;POP] [DUP 1;DUP 6;POP;POP;POP;POP;POP;POP;DUP 3;DUP 6;DUP 2;DUP 5;POP;DUP 3;POP] 12 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 240
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 240
*)
Compute pair "ERC721A_run_code_of_0_block_180_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xf0%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xf0%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_181_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 241 DUP4 PUSH [tag] 213
 O: PUSH [tag] 241 DUP4 PUSH [tag] 213
*)
Compute pair "ERC721A_run_code_of_0_block_182_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xf1%N);DUP 4;PUSH 1 (NToWord WLen 0xd5%N)] [PUSH 1 (NToWord WLen 0xf1%N);DUP 4;PUSH 1 (NToWord WLen 0xd5%N)] 3 optimize_id).

(*
 I: SWAP2 POP PUSH 20 DUP4 ADD CALLDATALOAD DUP1 ISZERO ISZERO DUP2 EQ PUSH [tag] 242
 O: SWAP2 POP PUSH 20 DUP4 ADD CALLDATALOAD DUP1 ISZERO ISZERO DUP2 EQ PUSH [tag] 242
*)
Compute pair "ERC721A_run_code_of_0_block_183_0"%string (equiv_checker [DUP 2;POP;PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;Opcode CALLDATALOAD;DUP 1;Opcode ISZERO;Opcode ISZERO;DUP 2;Opcode EQ;PUSH 1 (NToWord WLen 0xf2%N)] [DUP 2;POP;PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;Opcode CALLDATALOAD;DUP 1;Opcode ISZERO;Opcode ISZERO;DUP 2;Opcode EQ;PUSH 1 (NToWord WLen 0xf2%N)] 4 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_184_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP1 SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP4 POP POP SWAP1 POP SWAP2
*)
Compute pair "ERC721A_run_code_of_0_block_185_0"%string (equiv_checker [DUP 4;POP;POP;DUP 1;POP;DUP 2] [DUP 1;DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 6 optimize_id).

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 244
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 244
*)
Compute pair "ERC721A_run_code_of_0_block_186_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xf4%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xf4%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_187_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: PUSH [tag] 245 DUP4 PUSH [tag] 213
 O: PUSH [tag] 245 DUP4 PUSH [tag] 213
*)
Compute pair "ERC721A_run_code_of_0_block_188_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xf5%N);DUP 4;PUSH 1 (NToWord WLen 0xd5%N)] [PUSH 1 (NToWord WLen 0xf5%N);DUP 4;PUSH 1 (NToWord WLen 0xd5%N)] 3 optimize_id).

(*
 I: SWAP5 PUSH 20 SWAP4 SWAP1 SWAP4 ADD CALLDATALOAD SWAP4 POP POP POP
 O: SWAP5 SWAP3 PUSH 20 ADD CALLDATALOAD SWAP4 POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_189_0"%string (equiv_checker [DUP 5;DUP 3;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;Opcode CALLDATALOAD;DUP 4;POP;POP;POP] [DUP 5;PUSH 1 (NToWord WLen 0x20%N);DUP 4;DUP 1;DUP 4;Opcode ADD;Opcode CALLDATALOAD;DUP 4;POP;POP;POP] 6 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 247
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 247
*)
Compute pair "ERC721A_run_code_of_0_block_190_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xf7%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xf7%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_191_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP2 CALLDATALOAD PUSH [tag] 161 DUP2 PUSH [tag] 249
 O: DUP2 CALLDATALOAD PUSH [tag] 161 DUP2 PUSH [tag] 249
*)
Compute pair "ERC721A_run_code_of_0_block_192_0"%string (equiv_checker [DUP 2;Opcode CALLDATALOAD;PUSH 1 (NToWord WLen 0xa1%N);DUP 2;PUSH 1 (NToWord WLen 0xf9%N)] [DUP 2;Opcode CALLDATALOAD;PUSH 1 (NToWord WLen 0xa1%N);DUP 2;PUSH 1 (NToWord WLen 0xf9%N)] 2 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 251
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 251
*)
Compute pair "ERC721A_run_code_of_0_block_193_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xfb%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xfb%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_194_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: DUP2 MLOAD PUSH [tag] 161 DUP2 PUSH [tag] 249
 O: DUP2 MLOAD PUSH [tag] 161 DUP2 PUSH [tag] 249
*)
Compute pair "ERC721A_run_code_of_0_block_195_0"%string (equiv_checker [DUP 2;Opcode MLOAD;PUSH 1 (NToWord WLen 0xa1%N);DUP 2;PUSH 1 (NToWord WLen 0xf9%N)] [DUP 2;Opcode MLOAD;PUSH 1 (NToWord WLen 0xa1%N);DUP 2;PUSH 1 (NToWord WLen 0xf9%N)] 2 optimize_id).

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 254
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 254
*)
Compute pair "ERC721A_run_code_of_0_block_196_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xfe%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x20%N);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xfe%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_197_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP CALLDATALOAD SWAP2 SWAP1 POP
 O: POP SWAP1 POP CALLDATALOAD SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_198_0"%string (equiv_checker [POP;DUP 1;POP;Opcode CALLDATALOAD;DUP 1] [POP;Opcode CALLDATALOAD;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 0 DUP2 MLOAD DUP1 DUP5
 O: PUSH 0 DUP2 MLOAD DUP1 DUP5
*)
Compute pair "ERC721A_run_code_of_0_block_199_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode MLOAD;DUP 1;DUP 5] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode MLOAD;DUP 1;DUP 5] 2 optimize_id).

(*
 I: PUSH [tag] 257 DUP2 PUSH 20 DUP7 ADD PUSH 20 DUP7 ADD PUSH [tag] 258
 O: PUSH [tag] 257 DUP2 PUSH 20 DUP7 ADD DUP6 PUSH 20 ADD PUSH [tag] 258
*)
Compute pair "ERC721A_run_code_of_0_block_199_1"%string (equiv_checker [PUSH 2 (NToWord WLen 0x101%N);DUP 2;PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;DUP 6;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x102%N)] [PUSH 2 (NToWord WLen 0x101%N);DUP 2;PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;PUSH 2 (NToWord WLen 0x102%N)] 4 optimize_id).

(*
 I: PUSH 1F ADD PUSH 1F NOT AND SWAP3 SWAP1 SWAP3 ADD PUSH 20 ADD SWAP3 SWAP2 POP POP
 O: PUSH 1f ADD SWAP2 POP POP PUSH 1f NOT AND ADD PUSH 20 ADD SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_200_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;DUP 2;POP;POP;PUSH 1 (NToWord WLen 0x1f%N);Opcode NOT;Opcode AND;Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 1] [PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;Opcode AND;DUP 3;DUP 1;DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 3;DUP 2;POP;POP] 5 optimize_id).

(*
 I: PUSH 0 DUP4 MLOAD PUSH [tag] 260 DUP2 DUP5 PUSH 20 DUP9 ADD PUSH [tag] 258
 O: PUSH 0 DUP4 MLOAD PUSH [tag] 260 DUP2 DUP5 DUP8 PUSH 20 ADD PUSH [tag] 258
*)
Compute pair "ERC721A_run_code_of_0_block_201_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode MLOAD;PUSH 2 (NToWord WLen 0x104%N);DUP 2;DUP 5;DUP 8;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x102%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 4;Opcode MLOAD;PUSH 2 (NToWord WLen 0x104%N);DUP 2;DUP 5;PUSH 1 (NToWord WLen 0x20%N);DUP 9;Opcode ADD;PUSH 2 (NToWord WLen 0x102%N)] 3 optimize_id).

(*
 I: DUP4 MLOAD SWAP1 DUP4 ADD SWAP1 PUSH [tag] 261 DUP2 DUP4 PUSH 20 DUP9 ADD PUSH [tag] 258
 O: DUP3 ADD DUP4 MLOAD PUSH [tag] 261 DUP2 DUP4 PUSH 20 DUP9 ADD PUSH [tag] 258
*)
Compute pair "ERC721A_run_code_of_0_block_202_0"%string (equiv_checker [DUP 3;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 2 (NToWord WLen 0x105%N);DUP 2;DUP 4;PUSH 1 (NToWord WLen 0x20%N);DUP 9;Opcode ADD;PUSH 2 (NToWord WLen 0x102%N)] [DUP 4;Opcode MLOAD;DUP 1;DUP 4;Opcode ADD;DUP 1;PUSH 2 (NToWord WLen 0x105%N);DUP 2;DUP 4;PUSH 1 (NToWord WLen 0x20%N);DUP 9;Opcode ADD;PUSH 2 (NToWord WLen 0x102%N)] 4 optimize_id).

(*
 I: ADD SWAP5 SWAP4 POP POP POP POP
 O: ADD SWAP5 SWAP4 POP POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_203_0"%string (equiv_checker [Opcode ADD;DUP 5;DUP 4;POP;POP;POP;POP] [Opcode ADD;DUP 5;DUP 4;POP;POP;POP;POP] 7 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP6 DUP2 AND DUP3
 O: PUSH 1 DUP1 PUSH a0 SHL SUB DUP1 DUP7 AND DUP3
*)
Compute pair "ERC721A_run_code_of_0_block_204_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 1;DUP 7;Opcode AND;DUP 3] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 6;DUP 2;Opcode AND;DUP 3] 5 optimize_id).

(*
 I: DUP5 AND PUSH 20 DUP3 ADD
 O: DUP5 AND PUSH 20 DUP3 ADD
*)
Compute pair "ERC721A_run_code_of_0_block_204_1"%string (equiv_checker [DUP 5;Opcode AND;PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD] [DUP 5;Opcode AND;PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD] 5 optimize_id).

(*
 I: PUSH 40 DUP2 ADD DUP4 SWAP1
 O: DUP3 DUP2 PUSH 40 ADD
*)
Compute pair "ERC721A_run_code_of_0_block_204_2"%string (equiv_checker [DUP 3;DUP 2;PUSH 1 (NToWord WLen 0x40%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x40%N);DUP 2;Opcode ADD;DUP 4;DUP 1] 3 optimize_id).

(*
 I: PUSH 80 PUSH 60 DUP3 ADD DUP2 SWAP1
 O: PUSH 80 DUP1 DUP3 PUSH 60 ADD
*)
Compute pair "ERC721A_run_code_of_0_block_204_3"%string (equiv_checker [PUSH 1 (NToWord WLen 0x80%N);DUP 1;DUP 3;PUSH 1 (NToWord WLen 0x60%N);Opcode ADD] [PUSH 1 (NToWord WLen 0x80%N);PUSH 1 (NToWord WLen 0x60%N);DUP 3;Opcode ADD;DUP 2;DUP 1] 1 optimize_id).

(*
 I: PUSH 0 SWAP1 PUSH [tag] 264 SWAP1 DUP4 ADD DUP5 PUSH [tag] 255
 O: PUSH [tag] 264 PUSH 0 SWAP2 DUP4 ADD DUP5 PUSH [tag] 255
*)
Compute pair "ERC721A_run_code_of_0_block_204_4"%string (equiv_checker [PUSH 2 (NToWord WLen 0x108%N);PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 4;Opcode ADD;DUP 5;PUSH 1 (NToWord WLen 0xff%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 2 (NToWord WLen 0x108%N);DUP 1;DUP 4;Opcode ADD;DUP 5;PUSH 1 (NToWord WLen 0xff%N)] 3 optimize_id).

(*
 I: SWAP7 SWAP6 POP POP POP POP POP POP
 O: SWAP7 SWAP6 POP POP POP POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_205_0"%string (equiv_checker [DUP 7;DUP 6;POP;POP;POP;POP;POP;POP] [DUP 7;DUP 6;POP;POP;POP;POP;POP;POP] 8 optimize_id).

(*
 I: PUSH 20 DUP2
 O: PUSH 20 DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_206_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 2] [PUSH 1 (NToWord WLen 0x20%N);DUP 2] 1 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 161 PUSH 20 DUP4 ADD DUP5 PUSH [tag] 255
 O: PUSH 0 PUSH [tag] 161 DUP3 PUSH 20 ADD DUP5 PUSH [tag] 255
*)
Compute pair "ERC721A_run_code_of_0_block_206_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0xa1%N);DUP 3;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 5;PUSH 1 (NToWord WLen 0xff%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0xa1%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 5;PUSH 1 (NToWord WLen 0xff%N)] 2 optimize_id).

(*
 I: PUSH 0
 O: PUSH 0
*)
Compute pair "ERC721A_run_code_of_0_block_207_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: DUP4 DUP2 LT ISZERO PUSH [tag] 272
 O: DUP4 DUP2 LT ISZERO PUSH [tag] 272
*)
Compute pair "ERC721A_run_code_of_0_block_208_0"%string (equiv_checker [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x110%N)] [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (NToWord WLen 0x110%N)] 4 optimize_id).

(*
 I: DUP2 DUP2 ADD MLOAD DUP4 DUP3 ADD
 O: DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD
*)
Compute pair "ERC721A_run_code_of_0_block_209_0"%string (equiv_checker [DUP 1;DUP 3;Opcode ADD;Opcode MLOAD;DUP 2;DUP 5;Opcode ADD] [DUP 2;DUP 2;Opcode ADD;Opcode MLOAD;DUP 4;DUP 3;Opcode ADD] 3 optimize_id).

(*
 I: PUSH 20 ADD PUSH [tag] 270
 O: PUSH 20 ADD PUSH [tag] 270
*)
Compute pair "ERC721A_run_code_of_0_block_209_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x10e%N)] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x10e%N)] 1 optimize_id).

(*
 I: DUP4 DUP2 GT ISZERO PUSH [tag] 154
 O: DUP4 DUP2 GT ISZERO PUSH [tag] 154
*)
Compute pair "ERC721A_run_code_of_0_block_210_0"%string (equiv_checker [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x9a%N)] [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x9a%N)] 4 optimize_id).

(*
 I: POP POP PUSH 0 SWAP2 ADD
 O: POP POP ADD PUSH 0 SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_211_0"%string (equiv_checker [POP;POP;Opcode ADD;PUSH 1 (NToWord WLen 0x0%N);DUP 1] [POP;POP;PUSH 1 (NToWord WLen 0x0%N);DUP 2;Opcode ADD] 4 optimize_id).

(*
 I: PUSH 1 DUP2 DUP2 SHR SWAP1 DUP3 AND DUP1 PUSH [tag] 275
 O: DUP1 PUSH 1 SHR DUP2 PUSH 1 AND DUP1 PUSH [tag] 275
*)
Compute pair "ERC721A_run_code_of_0_block_212_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode SHR;DUP 2;PUSH 1 (NToWord WLen 0x1%N);Opcode AND;DUP 1;PUSH 2 (NToWord WLen 0x113%N)] [PUSH 1 (NToWord WLen 0x1%N);DUP 2;DUP 2;Opcode SHR;DUP 1;DUP 3;Opcode AND;DUP 1;PUSH 2 (NToWord WLen 0x113%N)] 1 optimize_id).

(*
 I: PUSH 7F DUP3 AND SWAP2 POP
 O: SWAP1 PUSH 7f AND SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_213_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x7f%N);Opcode AND;DUP 1] [PUSH 1 (NToWord WLen 0x7F%N);DUP 3;Opcode AND;DUP 2;POP] 2 optimize_id).

(*
 I: PUSH 20 DUP3 LT DUP2 EQ ISZERO PUSH [tag] 276
 O: DUP1 PUSH 20 DUP4 LT EQ ISZERO PUSH [tag] 276
*)
Compute pair "ERC721A_run_code_of_0_block_214_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode LT;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x114%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode LT;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x114%N)] 2 optimize_id).

(*
 I: PUSH 4E487B71 PUSH E0 SHL PUSH 0
 O: PUSH 4e487b71 PUSH e0 SHL PUSH 0
*)
Compute pair "ERC721A_run_code_of_0_block_215_0"%string (equiv_checker [PUSH 4 (NToWord WLen 0x4e487b71%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] [PUSH 4 (NToWord WLen 0x4E487B71%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 22 PUSH 4
 O: PUSH 22 PUSH 4
*)
Compute pair "ERC721A_run_code_of_0_block_215_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x22%N);PUSH 1 (NToWord WLen 0x4%N)] [PUSH 1 (NToWord WLen 0x22%N);PUSH 1 (NToWord WLen 0x4%N)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "ERC721A_run_code_of_0_block_215_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: POP SWAP2 SWAP1 POP
 O: POP SWAP2 SWAP1 POP
*)
Compute pair "ERC721A_run_code_of_0_block_216_0"%string (equiv_checker [POP;DUP 2;DUP 1;POP] [POP;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: PUSH 4E487B71 PUSH E0 SHL PUSH 0
 O: PUSH 4e487b71 PUSH e0 SHL PUSH 0
*)
Compute pair "ERC721A_run_code_of_0_block_217_0"%string (equiv_checker [PUSH 4 (NToWord WLen 0x4e487b71%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] [PUSH 4 (NToWord WLen 0x4E487B71%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 41 PUSH 4
 O: PUSH 41 PUSH 4
*)
Compute pair "ERC721A_run_code_of_0_block_217_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x41%N);PUSH 1 (NToWord WLen 0x4%N)] [PUSH 1 (NToWord WLen 0x41%N);PUSH 1 (NToWord WLen 0x4%N)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "ERC721A_run_code_of_0_block_217_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH E0 SHL SUB NOT DUP2 AND DUP2 EQ PUSH [tag] 279
 O: DUP1 DUP2 PUSH 1 DUP1 PUSH e0 SHL SUB NOT AND EQ PUSH [tag] 279
*)
Compute pair "ERC721A_run_code_of_0_block_218_0"%string (equiv_checker [DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode SUB;Opcode NOT;Opcode AND;Opcode EQ;PUSH 2 (NToWord WLen 0x117%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 2;Opcode AND;DUP 2;Opcode EQ;PUSH 2 (NToWord WLen 0x117%N)] 1 optimize_id).

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Compute pair "ERC721A_run_code_of_0_block_219_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).

(*
 I: POP
 O: POP
*)
Compute pair "ERC721A_run_code_of_0_block_220_0"%string (equiv_checker [POP] [POP] 1 optimize_id).

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
Compute pair "Strings_initial_block_0_1"%string (equiv_checker [DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode BYTE;PUSH 1 (NToWord WLen 0x73%N);Opcode EQ;PUSH 1 (NToWord WLen 0x1%N)] [DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode BYTE;PUSH 1 (NToWord WLen 0x73%N);Opcode EQ;PUSH 1 (NToWord WLen 0x1%N)] 1 optimize_id).

(*
 I: PUSH 4E487B71 PUSH E0 SHL PUSH 0
 O: PUSH 4e487b71 PUSH e0 SHL PUSH 0
*)
Compute pair "Strings_initial_block_1_0"%string (equiv_checker [PUSH 4 (NToWord WLen 0x4e487b71%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] [PUSH 4 (NToWord WLen 0x4E487B71%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 0 PUSH 4
 O: PUSH 0 PUSH 4
*)
Compute pair "Strings_initial_block_1_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x4%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x4%N)] 0 optimize_id).

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Compute pair "Strings_initial_block_1_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] [PUSH 1 (NToWord WLen 0x24%N);PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: ADDRESS PUSH 0
 O: ADDRESS PUSH 0
*)
Compute pair "Strings_initial_block_2_0"%string (equiv_checker [Opcode ADDRESS;PUSH 1 (NToWord WLen 0x0%N)] [Opcode ADDRESS;PUSH 1 (NToWord WLen 0x0%N)] 0 optimize_id).

(*
 I: PUSH 73 DUP2
 O: PUSH 73 DUP2
*)
Compute pair "Strings_initial_block_2_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x73%N);DUP 2] [PUSH 1 (NToWord WLen 0x73%N);DUP 2] 1 optimize_id).

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
Compute pair "Strings_run_code_of_0_block_0_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 1] [PUSH 1 (NToWord WLen 0x0%N);DUP 1] 0 optimize_id).


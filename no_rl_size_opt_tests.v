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
 I: DUP2 ADD PUSH 40 DUP2 SWAP1
 O: DUP2 ADD DUP1 PUSH 40
*)
Compute pair "BottleCastle_initial_block_3_1"%string (equiv_checker [DUP 2;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x40%N)] [DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);DUP 2;DUP 1] 2 optimize_id).

(*
 I: PUSH 40 DUP1 MLOAD DUP1 DUP3 ADD DUP3
 O: PUSH 40 DUP1 MLOAD DUP2 DUP2 ADD DUP3
*)
Compute pair "BottleCastle_initial_block_4_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode MLOAD;DUP 2;DUP 2;Opcode ADD;DUP 3] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode MLOAD;DUP 1;DUP 3;Opcode ADD;DUP 3] 0 optimize_id).

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
 I: DUP1 MLOAD PUSH [tag] 34 SWAP1 PUSH A SWAP1 PUSH 20 DUP5 ADD SWAP1 PUSH [tag] 2
 O: PUSH [tag] 34 PUSH a PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 2
*)
Compute pair "BottleCastle_initial_block_12_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x22%N);PUSH 1 (NToWord WLen 0xa%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 1 (NToWord WLen 0x2%N)] [DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x22%N);DUP 1;PUSH 1 (NToWord WLen 0xA%N);DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x2%N)] 1 optimize_id).

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
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1 PUSH 1F ADD PUSH 20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 50
 O: PUSH 20 DUP1 PUSH 0 KECCAK256 SWAP2 PUSH 1f ADD DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 50
*)
Compute pair "BottleCastle_initial_block_20_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 2;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x32%N)] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x32%N)] 3 optimize_id).

(*
 I: DUP1 MLOAD PUSH FF NOT AND DUP4 DUP1 ADD OR DUP6
 O: DUP3 DUP1 ADD PUSH ff NOT DUP3 MLOAD AND OR DUP6
*)
Compute pair "BottleCastle_initial_block_23_0"%string (equiv_checker [DUP 3;DUP 1;Opcode ADD;PUSH 1 (NToWord WLen 0xff%N);Opcode NOT;DUP 3;Opcode MLOAD;Opcode AND;Opcode OR;DUP 6] [DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0xFF%N);Opcode NOT;Opcode AND;DUP 4;DUP 1;Opcode ADD;Opcode OR;DUP 6] 5 optimize_id).

(*
 I: DUP3 DUP1 ADD PUSH 1 ADD DUP6
 O: DUP3 DUP4 ADD PUSH 1 ADD DUP6
*)
Compute pair "BottleCastle_initial_block_24_0"%string (equiv_checker [DUP 3;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 6] [DUP 3;DUP 1;Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 6] 5 optimize_id).

(*
 I: SWAP2 DUP3 ADD
 O: DUP1 SWAP3 ADD
*)
Compute pair "BottleCastle_initial_block_25_0"%string (equiv_checker [DUP 1;DUP 3;Opcode ADD] [DUP 2;DUP 3;Opcode ADD] 3 optimize_id).

(*
 I: POP PUSH [tag] 54 SWAP3 SWAP2 POP PUSH [tag] 55
 O: POP PUSH [tag] 55 PUSH [tag] 54 SWAP4 SWAP3 POP
*)
Compute pair "BottleCastle_initial_block_28_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x37%N);PUSH 1 (NToWord WLen 0x36%N);DUP 4;DUP 3;POP] [POP;PUSH 1 (NToWord WLen 0x36%N);DUP 3;DUP 2;POP;PUSH 1 (NToWord WLen 0x37%N)] 4 optimize_id).

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 61
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 61
*)
Compute pair "BottleCastle_initial_block_33_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode SLT;PUSH 1 (NToWord WLen 0x3d%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;Opcode SLT;PUSH 1 (NToWord WLen 0x3d%N)] 2 optimize_id).

(*
 I: DUP2 MLOAD PUSH 1 PUSH 1 PUSH 40 SHL SUB DUP1 DUP3 GT ISZERO PUSH [tag] 63
 O: DUP2 MLOAD PUSH 1 DUP1 PUSH 40 SHL SUB DUP1 DUP3 GT ISZERO PUSH [tag] 63
*)
Compute pair "BottleCastle_initial_block_35_0"%string (equiv_checker [DUP 2;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode SHL;Opcode SUB;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x3f%N)] [DUP 2;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x40%N);Opcode SHL;Opcode SUB;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x3f%N)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 1F DUP4 ADD PUSH 1F NOT SWAP1 DUP2 AND PUSH 3F ADD AND DUP2 ADD SWAP1 DUP3 DUP3 GT DUP2 DUP4 LT OR ISZERO PUSH [tag] 66
 O: PUSH 40 MLOAD PUSH 1f NOT PUSH 3f DUP2 DUP6 PUSH 1f ADD AND ADD AND ADD PUSH 40 MLOAD DUP3 DUP3 GT DUP2 DUP4 LT OR ISZERO PUSH [tag] 66
*)
Compute pair "BottleCastle_initial_block_37_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x1f%N);Opcode NOT;PUSH 1 (NToWord WLen 0x3f%N);DUP 2;DUP 6;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode AND;Opcode ADD;Opcode AND;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 3;DUP 3;Opcode GT;DUP 2;DUP 4;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 1 (NToWord WLen 0x42%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;DUP 1;DUP 2;Opcode AND;PUSH 1 (NToWord WLen 0x3F%N);Opcode ADD;Opcode AND;DUP 2;Opcode ADD;DUP 1;DUP 3;DUP 3;Opcode GT;DUP 2;DUP 4;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 1 (NToWord WLen 0x42%N)] 2 optimize_id).

(*
 I: PUSH 20 SWAP3 POP DUP7 DUP4 DUP6 DUP9 ADD ADD GT ISZERO PUSH [tag] 67
 O: DUP7 DUP7 DUP6 ADD PUSH 20 DUP1 SWAP6 POP ADD GT ISZERO PUSH [tag] 67
*)
Compute pair "BottleCastle_initial_block_39_2"%string (equiv_checker [DUP 7;DUP 7;DUP 6;Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 6;POP;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x43%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;POP;DUP 7;DUP 4;DUP 6;DUP 9;Opcode ADD;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x43%N)] 7 optimize_id).

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
 I: PUSH 0 DUP4 DUP6 DUP4 ADD ADD
 O: PUSH 0 DUP5 DUP3 ADD DUP5 ADD
*)
Compute pair "BottleCastle_initial_block_45_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 5;DUP 3;Opcode ADD;DUP 5;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 6;DUP 4;Opcode ADD;Opcode ADD] 4 optimize_id).

(*
 I: DUP3 MLOAD PUSH 1 PUSH 1 PUSH 40 SHL SUB DUP1 DUP3 GT ISZERO PUSH [tag] 74
 O: DUP3 MLOAD PUSH 1 DUP1 PUSH 40 SHL SUB DUP1 DUP3 GT ISZERO PUSH [tag] 74
*)
Compute pair "BottleCastle_initial_block_49_0"%string (equiv_checker [DUP 3;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode SHL;Opcode SUB;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4a%N)] [DUP 3;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x40%N);Opcode SHL;Opcode SUB;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4a%N)] 3 optimize_id).

(*
 I: SWAP4 POP PUSH 20 DUP6 ADD MLOAD SWAP2 POP DUP1 DUP3 GT ISZERO PUSH [tag] 76
 O: SWAP4 POP DUP1 PUSH 20 DUP7 ADD MLOAD DUP1 SWAP4 POP GT ISZERO PUSH [tag] 76
*)
Compute pair "BottleCastle_initial_block_52_0"%string (equiv_checker [DUP 4;POP;DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;Opcode MLOAD;DUP 1;DUP 4;POP;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4c%N)] [DUP 4;POP;PUSH 1 (NToWord WLen 0x20%N);DUP 6;Opcode ADD;Opcode MLOAD;DUP 2;POP;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4c%N)] 6 optimize_id).

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
 I: PUSH #[$] 0000000000000000000000000000000000000000000000000000000000000000 DUP1 PUSH [$] 0000000000000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH #[$] 0 DUP1 PUSH [$] 0 PUSH 0
  ERROR OCCURRED

'PUSH #[$]' is not in list
*)

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 46
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 46
*)
Compute pair "BottleCastle_run_code_of_0_block_53_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x2e%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x2e%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD SWAP1 ISZERO ISZERO DUP2
 O: ISZERO PUSH 40 MLOAD SWAP1 ISZERO DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_57_0"%string (equiv_checker [Opcode ISZERO;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;Opcode ISZERO;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;Opcode ISZERO;Opcode ISZERO;DUP 2] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 53
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 53
*)
Compute pair "BottleCastle_run_code_of_0_block_59_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x35%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x35%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 58
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 58
*)
Compute pair "BottleCastle_run_code_of_0_block_64_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x3a%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x3a%N)] 0 optimize_id).

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
 I: PUSH 40 MLOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB SWAP1 SWAP2 AND DUP2
 O: PUSH 40 MLOAD SWAP1 PUSH 1 DUP1 PUSH a0 SHL SUB AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_72_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 1;DUP 2;Opcode AND;DUP 2] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 70
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 70
*)
Compute pair "BottleCastle_run_code_of_0_block_73_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x46%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x46%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 74
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 74
*)
Compute pair "BottleCastle_run_code_of_0_block_76_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4a%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4a%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 79
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 79
*)
Compute pair "BottleCastle_run_code_of_0_block_80_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4f%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x4f%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 84
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 84
*)
Compute pair "BottleCastle_run_code_of_0_block_84_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x54%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x54%N)] 0 optimize_id).

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
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 95
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 95
*)
Compute pair "BottleCastle_run_code_of_0_block_92_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x5f%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x5f%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 99
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 99
*)
Compute pair "BottleCastle_run_code_of_0_block_96_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x63%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x63%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 103
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 103
*)
Compute pair "BottleCastle_run_code_of_0_block_100_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x67%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x67%N)] 0 optimize_id).

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
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 112
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 112
*)
Compute pair "BottleCastle_run_code_of_0_block_107_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x70%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x70%N)] 0 optimize_id).

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
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 121
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 121
*)
Compute pair "BottleCastle_run_code_of_0_block_114_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x79%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x79%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 125
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 125
*)
Compute pair "BottleCastle_run_code_of_0_block_117_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x7d%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x7d%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 131
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 131
*)
Compute pair "BottleCastle_run_code_of_0_block_121_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x83%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x83%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 134
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 134
*)
Compute pair "BottleCastle_run_code_of_0_block_124_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x86%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x86%N)] 0 optimize_id).

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
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 148
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 148
*)
Compute pair "BottleCastle_run_code_of_0_block_136_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x94%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x94%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 155
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 155
*)
Compute pair "BottleCastle_run_code_of_0_block_141_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x9b%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x9b%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 160
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 160
*)
Compute pair "BottleCastle_run_code_of_0_block_145_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xa0%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xa0%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 165
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 165
*)
Compute pair "BottleCastle_run_code_of_0_block_149_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xa5%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xa5%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 170
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 170
*)
Compute pair "BottleCastle_run_code_of_0_block_153_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xaa%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xaa%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 174
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 174
*)
Compute pair "BottleCastle_run_code_of_0_block_156_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xae%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xae%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 178
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 178
*)
Compute pair "BottleCastle_run_code_of_0_block_159_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb2%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb2%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 183
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 183
*)
Compute pair "BottleCastle_run_code_of_0_block_163_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb7%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb7%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 187
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 187
*)
Compute pair "BottleCastle_run_code_of_0_block_166_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xbb%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xbb%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 191
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 191
*)
Compute pair "BottleCastle_run_code_of_0_block_170_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xbf%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xbf%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 196
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 196
*)
Compute pair "BottleCastle_run_code_of_0_block_174_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc4%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc4%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 200
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 200
*)
Compute pair "BottleCastle_run_code_of_0_block_178_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc8%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc8%N)] 0 optimize_id).

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
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 206
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 206
*)
Compute pair "BottleCastle_run_code_of_0_block_182_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xce%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xce%N)] 0 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 210
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 210
*)
Compute pair "BottleCastle_run_code_of_0_block_186_0"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0xd2%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xd2%N)] 0 optimize_id).

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
 I: POP PUSH 5B5E139F PUSH E0 SHL PUSH 1 PUSH 1 PUSH E0 SHL SUB NOT DUP4 AND EQ
 O: POP PUSH 5b5e139f PUSH e0 SHL PUSH 1 DUP1 PUSH e0 SHL SUB NOT DUP4 AND EQ
*)
Compute pair "BottleCastle_run_code_of_0_block_193_0"%string (equiv_checker [POP;PUSH 4 (NToWord WLen 0x5b5e139f%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 4;Opcode AND;Opcode EQ] [POP;PUSH 4 (NToWord WLen 0x5B5E139F%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 4;Opcode AND;Opcode EQ] 3 optimize_id).

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
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_208_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

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
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_217_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1f%N);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x1F%N);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id).

(*
 I: SWAP1 POP CALLER PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP3 AND EQ PUSH [tag] 244
 O: PUSH 1 DUP1 DUP3 SWAP4 POP PUSH a0 SHL SUB AND CALLER EQ PUSH [tag] 244
*)
Compute pair "BottleCastle_run_code_of_0_block_220_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;DUP 3;DUP 4;POP;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode CALLER;Opcode EQ;PUSH 1 (NToWord WLen 0xf4%N)] [DUP 1;POP;Opcode CALLER;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 3;Opcode AND;Opcode EQ;PUSH 1 (NToWord WLen 0xf4%N)] 2 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_223_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: SWAP2 MLOAD DUP6 SWAP4 SWAP2 DUP6 AND SWAP2 PUSH 8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B925 SWAP2
 O: SWAP2 SWAP1 DUP6 SWAP4 PUSH 8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925 SWAP2 DUP7 AND SWAP3 MLOAD
*)
Compute pair "BottleCastle_run_code_of_0_block_224_3"%string (equiv_checker [DUP 2;DUP 1;DUP 6;DUP 4;PUSH 32 (NToWord WLen 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925%N);DUP 2;DUP 7;Opcode AND;DUP 3;Opcode MLOAD] [DUP 2;Opcode MLOAD;DUP 6;DUP 4;DUP 2;DUP 6;Opcode AND;DUP 2;PUSH 32 (NToWord WLen 0x8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B925%N);DUP 2] 6 optimize_id).

(*
 I: SWAP1 POP DUP4 PUSH 1 PUSH 1 PUSH A0 SHL SUB AND DUP2 PUSH 1 PUSH 1 PUSH A0 SHL SUB AND EQ PUSH [tag] 251
 O: DUP1 SWAP2 POP PUSH 1 DUP1 PUSH a0 SHL SUB DUP6 DUP2 AND SWAP2 AND EQ PUSH [tag] 251
*)
Compute pair "BottleCastle_run_code_of_0_block_226_0"%string (equiv_checker [DUP 1;DUP 2;POP;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 6;DUP 2;Opcode AND;DUP 2;Opcode AND;Opcode EQ;PUSH 1 (NToWord WLen 0xfb%N)] [DUP 1;POP;DUP 4;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;DUP 2;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode EQ;PUSH 1 (NToWord WLen 0xfb%N)] 5 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_227_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 DUP1 SLOAD CALLER DUP1 DUP3 EQ PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP9 AND SWAP1 SWAP2 EQ OR PUSH [tag] 260
 O: PUSH 40 SWAP1 KECCAK256 DUP5 PUSH 1 DUP1 PUSH a0 SHL SUB AND CALLER EQ DUP2 SLOAD SWAP1 CALLER DUP3 EQ OR PUSH [tag] 260
*)
Compute pair "BottleCastle_run_code_of_0_block_228_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;DUP 5;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode CALLER;Opcode EQ;DUP 2;Opcode SLOAD;DUP 1;Opcode CALLER;DUP 3;Opcode EQ;Opcode OR;PUSH 2 (NToWord WLen 0x104%N)] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;DUP 1;Opcode SLOAD;Opcode CALLER;DUP 1;DUP 3;Opcode EQ;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 9;Opcode AND;DUP 1;DUP 2;Opcode EQ;Opcode OR;PUSH 2 (NToWord WLen 0x104%N)] 5 optimize_id).

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
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_233_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP7 DUP2 AND PUSH 0 SWAP1 DUP2
 O: PUSH 1 DUP1 PUSH a0 SHL SUB PUSH 0 DUP8 DUP3 AND DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_236_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 8;DUP 3;Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 7;DUP 2;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] 6 optimize_id).

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
 I: PUSH 0 SLOAD DUP2 EQ PUSH [tag] 271
 O: DUP1 PUSH 0 SLOAD EQ PUSH [tag] 271
*)
Compute pair "BottleCastle_run_code_of_0_block_238_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;Opcode EQ;PUSH 2 (NToWord WLen 0x10f%N)] [PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 2;Opcode EQ;PUSH 2 (NToWord WLen 0x10f%N)] 1 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 DUP5 SWAP1
 O: PUSH 40 DUP6 SWAP2 KECCAK256
*)
Compute pair "BottleCastle_run_code_of_0_block_239_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 6;DUP 2;Opcode KECCAK256] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;DUP 5;DUP 1] 5 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 278 SWAP1 PUSH [tag] 279
 O: PUSH [tag] 278 SWAP1 PUSH 4 ADD PUSH [tag] 279
*)
Compute pair "BottleCastle_run_code_of_0_block_244_1"%string (equiv_checker [PUSH 2 (NToWord WLen 0x116%N);DUP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x117%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N);DUP 1;PUSH 2 (NToWord WLen 0x117%N)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD SELFBALANCE SWAP1 CALLER SWAP1 DUP3 ISZERO PUSH 8FC MUL SWAP1 DUP4 SWAP1 PUSH 0 DUP2 DUP2 DUP2 DUP6 DUP9 DUP9
 O: SELFBALANCE CALLER SELFBALANCE ISZERO PUSH 8fc MUL DUP3 PUSH 40 MLOAD PUSH 0 DUP2 DUP2 DUP4 DUP9 DUP9 DUP9
*)
Compute pair "BottleCastle_run_code_of_0_block_246_1"%string (equiv_checker [Opcode SELFBALANCE;Opcode CALLER;Opcode SELFBALANCE;Opcode ISZERO;PUSH 2 (NToWord WLen 0x8fc%N);Opcode MUL;DUP 3;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2;DUP 4;DUP 9;DUP 9;DUP 9] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;Opcode SELFBALANCE;DUP 1;Opcode CALLER;DUP 1;DUP 3;Opcode ISZERO;PUSH 2 (NToWord WLen 0x8FC%N);Opcode MUL;DUP 1;DUP 4;DUP 1;PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2;DUP 2;DUP 6;DUP 9;DUP 9] 0 optimize_id).

(*
 I: PUSH [tag] 285 DUP4 DUP4 DUP4 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH [tag] 285 DUP4 DUP4 DUP4 PUSH 40 MLOAD PUSH 20 DUP2 ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_249_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x11d%N);DUP 4;DUP 4;DUP 4;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [PUSH 2 (NToWord WLen 0x11d%N);DUP 4;DUP 4;DUP 4;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 3 optimize_id).

(*
 I: DUP1 MLOAD PUSH [tag] 292 SWAP1 PUSH A SWAP1 PUSH 20 DUP5 ADD SWAP1 PUSH [tag] 293
 O: PUSH [tag] 292 PUSH a PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 293
*)
Compute pair "BottleCastle_run_code_of_0_block_254_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x124%N);PUSH 1 (NToWord WLen 0xa%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 2 (NToWord WLen 0x125%N)] [DUP 1;Opcode MLOAD;PUSH 2 (NToWord WLen 0x124%N);DUP 1;PUSH 1 (NToWord WLen 0xA%N);DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;DUP 1;PUSH 2 (NToWord WLen 0x125%N)] 1 optimize_id).

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
 I: PUSH 60 PUSH 0 DUP1 PUSH 0 PUSH [tag] 309 DUP6 PUSH [tag] 129
 O: PUSH 60 PUSH 0 DUP1 DUP1 PUSH [tag] 309 DUP6 PUSH [tag] 129
*)
Compute pair "BottleCastle_run_code_of_0_block_264_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 1;PUSH 2 (NToWord WLen 0x135%N);DUP 6;PUSH 1 (NToWord WLen 0x81%N)] [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0x0%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x135%N);DUP 6;PUSH 1 (NToWord WLen 0x81%N)] 1 optimize_id).

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
 I: DUP2 PUSH 20 ADD PUSH 20 DUP3 MUL DUP1 CALLDATASIZE DUP4
 O: PUSH 20 DUP3 ADD DUP2 PUSH 20 MUL DUP1 CALLDATASIZE DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_268_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode MUL;DUP 1;Opcode CALLDATASIZE;DUP 4] [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode MUL;DUP 1;Opcode CALLDATASIZE;DUP 4] 2 optimize_id).

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
 I: SWAP2 POP DUP2 PUSH 40 ADD MLOAD ISZERO PUSH [tag] 322
 O: SWAP2 POP PUSH 40 DUP3 ADD MLOAD ISZERO PUSH [tag] 322
*)
Compute pair "BottleCastle_run_code_of_0_block_273_0"%string (equiv_checker [DUP 2;POP;PUSH 1 (NToWord WLen 0x40%N);DUP 3;Opcode ADD;Opcode MLOAD;Opcode ISZERO;PUSH 2 (NToWord WLen 0x142%N)] [DUP 2;POP;DUP 2;PUSH 1 (NToWord WLen 0x40%N);Opcode ADD;Opcode MLOAD;Opcode ISZERO;PUSH 2 (NToWord WLen 0x142%N)] 3 optimize_id).

(*
 I: DUP2 MLOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB AND ISZERO PUSH [tag] 323
 O: DUP2 MLOAD PUSH 1 DUP1 PUSH a0 SHL SUB AND ISZERO PUSH [tag] 323
*)
Compute pair "BottleCastle_run_code_of_0_block_275_0"%string (equiv_checker [DUP 2;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode ISZERO;PUSH 2 (NToWord WLen 0x143%N)] [DUP 2;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode ISZERO;PUSH 2 (NToWord WLen 0x143%N)] 2 optimize_id).

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
 I: POP SWAP1 SWAP7 SWAP6 POP POP POP POP POP POP
 O: POP POP SWAP6 SWAP5 POP POP POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_282_0"%string (equiv_checker [POP;POP;DUP 6;DUP 5;POP;POP;POP;POP;POP] [POP;DUP 1;DUP 7;DUP 6;POP;POP;POP;POP;POP;POP] 9 optimize_id).

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
 I: PUSH 4 ADD PUSH [tag] 278 SWAP1 PUSH [tag] 279
 O: PUSH [tag] 278 SWAP1 PUSH 4 ADD PUSH [tag] 279
*)
Compute pair "BottleCastle_run_code_of_0_block_287_1"%string (equiv_checker [PUSH 2 (NToWord WLen 0x116%N);DUP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x117%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N);DUP 1;PUSH 2 (NToWord WLen 0x117%N)] 1 optimize_id).

(*
 I: PUSH 10 SLOAD PUSH FF AND ISZERO PUSH [tag] 342
 O: PUSH ff PUSH 10 SLOAD AND ISZERO PUSH [tag] 342
*)
Compute pair "BottleCastle_run_code_of_0_block_288_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0xff%N);PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;Opcode AND;Opcode ISZERO;PUSH 2 (NToWord WLen 0x156%N)] [PUSH 1 (NToWord WLen 0x10%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0xFF%N);Opcode AND;Opcode ISZERO;PUSH 2 (NToWord WLen 0x156%N)] 0 optimize_id).

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
 I: PUSH E SLOAD PUSH 1 SLOAD PUSH 0 SLOAD DUP4 SWAP2 SWAP1 SUB PUSH 0 NOT ADD PUSH [tag] 349 SWAP2 SWAP1 PUSH [tag] 350
 O: PUSH 0 PUSH [tag] 349 DUP3 PUSH 1 SLOAD DUP4 SLOAD SUB PUSH e SLOAD SWAP4 NOT ADD PUSH [tag] 350
*)
Compute pair "BottleCastle_run_code_of_0_block_292_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x15d%N);DUP 3;PUSH 1 (NToWord WLen 0x1%N);Opcode SLOAD;DUP 4;Opcode SLOAD;Opcode SUB;PUSH 1 (NToWord WLen 0xe%N);Opcode SLOAD;DUP 4;Opcode NOT;Opcode ADD;PUSH 2 (NToWord WLen 0x15e%N)] [PUSH 1 (NToWord WLen 0xE%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 4;DUP 2;DUP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;Opcode ADD;PUSH 2 (NToWord WLen 0x15d%N);DUP 2;DUP 1;PUSH 2 (NToWord WLen 0x15e%N)] 1 optimize_id).

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
 I: PUSH F SLOAD CALLER PUSH 0 SWAP1 DUP2
 O: PUSH f SLOAD PUSH 0 CALLER DUP2
*)
Compute pair "BottleCastle_run_code_of_0_block_295_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xf%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode CALLER;DUP 2] [PUSH 1 (NToWord WLen 0xF%N);Opcode SLOAD;Opcode CALLER;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] 0 optimize_id).

(*
 I: PUSH 40 SWAP1 DUP2 SWAP1 KECCAK256 SLOAD DUP4 SWAP2 SHR PUSH FFFFFFFFFFFFFFFF AND PUSH [tag] 357 SWAP2 SWAP1 PUSH [tag] 350
 O: PUSH 40 DUP1 PUSH [tag] 357 SWAP3 KECCAK256 SLOAD DUP5 SWAP2 SHR PUSH ffffffffffffffff AND PUSH [tag] 350
*)
Compute pair "BottleCastle_run_code_of_0_block_295_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;PUSH 2 (NToWord WLen 0x165%N);DUP 3;Opcode KECCAK256;Opcode SLOAD;DUP 5;DUP 2;Opcode SHR;PUSH 8 (NToWord WLen 0xffffffffffffffff%N);Opcode AND;PUSH 2 (NToWord WLen 0x15e%N)] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;DUP 2;DUP 1;Opcode KECCAK256;Opcode SLOAD;DUP 4;DUP 2;Opcode SHR;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);Opcode AND;PUSH 2 (NToWord WLen 0x165%N);DUP 2;DUP 1;PUSH 2 (NToWord WLen 0x15e%N)] 3 optimize_id).

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
 I: DUP1 PUSH D SLOAD PUSH [tag] 361 SWAP2 SWAP1 PUSH [tag] 362
 O: PUSH [tag] 361 DUP2 PUSH d SLOAD PUSH [tag] 362
*)
Compute pair "BottleCastle_run_code_of_0_block_298_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x169%N);DUP 2;PUSH 1 (NToWord WLen 0xd%N);Opcode SLOAD;PUSH 2 (NToWord WLen 0x16a%N)] [DUP 1;PUSH 1 (NToWord WLen 0xD%N);Opcode SLOAD;PUSH 2 (NToWord WLen 0x169%N);DUP 2;DUP 1;PUSH 2 (NToWord WLen 0x16a%N)] 1 optimize_id).

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
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP3 AND CALLER EQ ISZERO PUSH [tag] 371
 O: DUP2 PUSH 1 DUP1 PUSH a0 SHL SUB AND CALLER EQ ISZERO PUSH [tag] 371
*)
Compute pair "BottleCastle_run_code_of_0_block_303_0"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode CALLER;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x173%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 3;Opcode AND;Opcode CALLER;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x173%N)] 2 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_304_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

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
 I: SWAP3 DUP2 SWAP1 KECCAK256 DUP1 SLOAD PUSH FF NOT AND DUP7 ISZERO ISZERO SWAP1 DUP2 OR SWAP1 SWAP2
 O: DUP2 DUP7 ISZERO ISZERO SWAP2 SWAP5 KECCAK256 DUP2 PUSH ff NOT DUP3 SLOAD AND OR SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_305_4"%string (equiv_checker [DUP 2;DUP 7;Opcode ISZERO;Opcode ISZERO;DUP 2;DUP 5;Opcode KECCAK256;DUP 2;PUSH 1 (NToWord WLen 0xff%N);Opcode NOT;DUP 3;Opcode SLOAD;Opcode AND;Opcode OR;DUP 1] [DUP 3;DUP 2;DUP 1;Opcode KECCAK256;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xFF%N);Opcode NOT;Opcode AND;DUP 7;Opcode ISZERO;Opcode ISZERO;DUP 1;DUP 2;Opcode OR;DUP 1;DUP 2] 6 optimize_id).

(*
 I: SWAP2 SWAP3 SWAP2 PUSH 17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C31 SWAP2 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: ADD PUSH 40 MLOAD DUP1 SWAP4 SWAP3 SWAP4 SWAP2 SUB PUSH 17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31 SWAP2
*)
Compute pair "BottleCastle_run_code_of_0_block_305_6"%string (equiv_checker [Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 4;DUP 3;DUP 4;DUP 2;Opcode SUB;PUSH 32 (NToWord WLen 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31%N);DUP 2] [DUP 2;DUP 3;DUP 2;PUSH 32 (NToWord WLen 0x17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C31%N);DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 4 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP4 AND EXTCODESIZE ISZERO PUSH [tag] 380
 O: DUP3 PUSH 1 DUP1 PUSH a0 SHL SUB AND EXTCODESIZE ISZERO PUSH [tag] 380
*)
Compute pair "BottleCastle_run_code_of_0_block_307_0"%string (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode EXTCODESIZE;Opcode ISZERO;PUSH 2 (NToWord WLen 0x17c%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 4;Opcode AND;Opcode EXTCODESIZE;Opcode ISZERO;PUSH 2 (NToWord WLen 0x17c%N)] 3 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_310_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 4 ADD PUSH [tag] 278 SWAP1 PUSH [tag] 279
 O: PUSH [tag] 278 SWAP1 PUSH 4 ADD PUSH [tag] 279
*)
Compute pair "BottleCastle_run_code_of_0_block_314_1"%string (equiv_checker [PUSH 2 (NToWord WLen 0x116%N);DUP 1;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x117%N)] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 2 (NToWord WLen 0x116%N);DUP 1;PUSH 2 (NToWord WLen 0x117%N)] 1 optimize_id).

(*
 I: PUSH E SLOAD PUSH 1 SLOAD PUSH 0 SLOAD DUP5 SWAP2 SWAP1 SUB PUSH 0 NOT ADD PUSH [tag] 388 SWAP2 SWAP1 PUSH [tag] 350
 O: PUSH e SLOAD PUSH [tag] 388 DUP4 PUSH 1 SLOAD PUSH 0 SLOAD SUB PUSH 0 NOT ADD PUSH [tag] 350
*)
Compute pair "BottleCastle_run_code_of_0_block_315_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0xe%N);Opcode SLOAD;PUSH 2 (NToWord WLen 0x184%N);DUP 4;PUSH 1 (NToWord WLen 0x1%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;Opcode ADD;PUSH 2 (NToWord WLen 0x15e%N)] [PUSH 1 (NToWord WLen 0xE%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 5;DUP 2;DUP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;Opcode ADD;PUSH 2 (NToWord WLen 0x184%N);DUP 2;DUP 1;PUSH 2 (NToWord WLen 0x15e%N)] 2 optimize_id).

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
 I: PUSH B DUP1 SLOAD PUSH [tag] 232 SWAP1 PUSH [tag] 223
 O: PUSH b PUSH [tag] 232 DUP2 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_319_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xb%N);PUSH 1 (NToWord WLen 0xe8%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0xB%N);DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xe8%N);DUP 1;PUSH 1 (NToWord WLen 0xdf%N)] 0 optimize_id).

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
 I: PUSH B PUSH 40 MLOAD PUSH 20 ADD PUSH [tag] 415 SWAP4 SWAP3 SWAP2 SWAP1 PUSH [tag] 416
 O: PUSH [tag] 415 SWAP2 SWAP1 PUSH b PUSH 20 PUSH 40 MLOAD ADD PUSH [tag] 416
*)
Compute pair "BottleCastle_run_code_of_0_block_337_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x19f%N);DUP 2;DUP 1;PUSH 1 (NToWord WLen 0xb%N);PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;Opcode ADD;PUSH 2 (NToWord WLen 0x1a0%N)] [PUSH 1 (NToWord WLen 0xB%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x19f%N);DUP 4;DUP 3;DUP 2;DUP 1;PUSH 2 (NToWord WLen 0x1a0%N)] 2 optimize_id).

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
 I: PUSH 40 DUP1 DUP3 KECCAK256 SLOAD PUSH FFFFFFFFFFFFFFFF SWAP2 SHR AND PUSH [tag] 216
 O: PUSH ffffffffffffffff PUSH 40 DUP1 DUP4 KECCAK256 SLOAD SWAP1 SHR AND PUSH [tag] 216
*)
Compute pair "BottleCastle_run_code_of_0_block_342_2"%string (equiv_checker [PUSH 8 (NToWord WLen 0xffffffffffffffff%N);PUSH 1 (NToWord WLen 0x40%N);DUP 1;DUP 4;Opcode KECCAK256;Opcode SLOAD;DUP 1;Opcode SHR;Opcode AND;PUSH 1 (NToWord WLen 0xd8%N)] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;DUP 3;Opcode KECCAK256;Opcode SLOAD;PUSH 8 (NToWord WLen 0xFFFFFFFFFFFFFFFF%N);DUP 2;Opcode SHR;Opcode AND;PUSH 1 (NToWord WLen 0xd8%N)] 1 optimize_id).

(*
 I: DUP1 MLOAD PUSH [tag] 292 SWAP1 PUSH C SWAP1 PUSH 20 DUP5 ADD SWAP1 PUSH [tag] 293
 O: PUSH [tag] 292 PUSH c PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 293
*)
Compute pair "BottleCastle_run_code_of_0_block_346_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x124%N);PUSH 1 (NToWord WLen 0xc%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 2 (NToWord WLen 0x125%N)] [DUP 1;Opcode MLOAD;PUSH 2 (NToWord WLen 0x124%N);DUP 1;PUSH 1 (NToWord WLen 0xC%N);DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;DUP 1;PUSH 2 (NToWord WLen 0x125%N)] 1 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP2 AND PUSH [tag] 434
 O: PUSH 1 DUP1 PUSH a0 SHL SUB DUP2 AND PUSH [tag] 434
*)
Compute pair "BottleCastle_run_code_of_0_block_348_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 2;Opcode AND;PUSH 2 (NToWord WLen 0x1b2%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 2;Opcode AND;PUSH 2 (NToWord WLen 0x1b2%N)] 1 optimize_id).

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
 I: PUSH 8 SLOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB AND CALLER EQ PUSH [tag] 306
 O: PUSH 1 DUP1 PUSH a0 SHL SUB PUSH 8 SLOAD AND CALLER EQ PUSH [tag] 306
*)
Compute pair "BottleCastle_run_code_of_0_block_352_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;PUSH 1 (NToWord WLen 0x8%N);Opcode SLOAD;Opcode AND;Opcode CALLER;Opcode EQ;PUSH 2 (NToWord WLen 0x132%N)] [PUSH 1 (NToWord WLen 0x8%N);Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode CALLER;Opcode EQ;PUSH 2 (NToWord WLen 0x132%N)] 0 optimize_id).

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
 I: PUSH 0 DUP2 DUP1 PUSH 1 GT PUSH [tag] 454
 O: PUSH 0 DUP2 DUP3 PUSH 1 GT PUSH [tag] 454
*)
Compute pair "BottleCastle_run_code_of_0_block_358_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 3;PUSH 1 (NToWord WLen 0x1%N);Opcode GT;PUSH 2 (NToWord WLen 0x1c6%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode GT;PUSH 2 (NToWord WLen 0x1c6%N)] 1 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH 1 PUSH E0 SHL DUP2 AND PUSH [tag] 455
 O: PUSH 40 SWAP1 KECCAK256 SLOAD DUP1 PUSH 1 PUSH e0 SHL AND PUSH [tag] 455
*)
Compute pair "BottleCastle_run_code_of_0_block_360_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;DUP 1;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode AND;PUSH 2 (NToWord WLen 0x1c7%N)] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;DUP 2;Opcode AND;PUSH 2 (NToWord WLen 0x1c7%N)] 1 optimize_id).

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
 I: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP1 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 479
 O: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP9 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 479
*)
Compute pair "BottleCastle_run_code_of_0_block_369_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (NToWord WLen 0x0%N);DUP 8;DUP 9;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1df%N)] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (NToWord WLen 0x0%N);DUP 8;DUP 1;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (NToWord WLen 0x1df%N)] 3 optimize_id).

(*
 I: POP PUSH 40 DUP1 MLOAD PUSH 1F RETURNDATASIZE SWAP1 DUP2 ADD PUSH 1F NOT AND DUP3 ADD SWAP1 SWAP3
 O: POP RETURNDATASIZE PUSH 40 MLOAD DUP1 DUP3 PUSH 1f DUP1 NOT SWAP2 ADD AND ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_372_0"%string (equiv_checker [POP;Opcode RETURNDATASIZE;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 3;PUSH 1 (NToWord WLen 0x1f%N);DUP 1;Opcode NOT;DUP 2;Opcode ADD;Opcode AND;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [POP;PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1F%N);Opcode RETURNDATASIZE;DUP 1;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;Opcode AND;DUP 3;Opcode ADD;DUP 1;DUP 3] 1 optimize_id).

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
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_379_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH E0 SHL SUB NOT AND PUSH A85BD01 PUSH E1 SHL EQ SWAP1 POP
 O: PUSH a85bd01 PUSH e1 SHL SWAP2 POP PUSH 1 DUP1 PUSH e0 SHL SUB NOT AND EQ
*)
Compute pair "BottleCastle_run_code_of_0_block_381_0"%string (equiv_checker [PUSH 4 (NToWord WLen 0xa85bd01%N);PUSH 1 (NToWord WLen 0xe1%N);Opcode SHL;DUP 2;POP;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode SUB;Opcode NOT;Opcode AND;Opcode EQ] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;Opcode SUB;Opcode NOT;Opcode AND;PUSH 4 (NToWord WLen 0xA85BD01%N);PUSH 1 (NToWord WLen 0xE1%N);Opcode SHL;Opcode EQ;DUP 1;POP] 2 optimize_id).

(*
 I: PUSH 60 PUSH A DUP1 SLOAD PUSH [tag] 222 SWAP1 PUSH [tag] 223
 O: PUSH 60 PUSH a PUSH [tag] 222 DUP2 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_383_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0xa%N);PUSH 1 (NToWord WLen 0xde%N);DUP 2;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [PUSH 1 (NToWord WLen 0x60%N);PUSH 1 (NToWord WLen 0xA%N);DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xde%N);DUP 1;PUSH 1 (NToWord WLen 0xdf%N)] 0 optimize_id).

(*
 I: POP POP PUSH 40 DUP1 MLOAD DUP1 DUP3 ADD SWAP1 SWAP2
 O: POP POP PUSH 40 MLOAD DUP1 PUSH 40 ADD PUSH 40
*)
Compute pair "BottleCastle_run_code_of_0_block_385_0"%string (equiv_checker [POP;POP;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [POP;POP;PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode MLOAD;DUP 1;DUP 3;Opcode ADD;DUP 1;DUP 2] 2 optimize_id).

(*
 I: SWAP2 POP PUSH [tag] 504 SWAP1 POP PUSH A DUP4 PUSH [tag] 505
 O: SWAP2 POP POP PUSH [tag] 504 PUSH a DUP4 PUSH [tag] 505
*)
Compute pair "BottleCastle_run_code_of_0_block_389_0"%string (equiv_checker [DUP 2;POP;POP;PUSH 2 (NToWord WLen 0x1f8%N);PUSH 1 (NToWord WLen 0xa%N);DUP 4;PUSH 2 (NToWord WLen 0x1f9%N)] [DUP 2;POP;PUSH 2 (NToWord WLen 0x1f8%N);DUP 1;POP;PUSH 1 (NToWord WLen 0xA%N);DUP 4;PUSH 2 (NToWord WLen 0x1f9%N)] 4 optimize_id).

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
 I: PUSH 20 DUP3 ADD DUP2 DUP1 CALLDATASIZE DUP4
 O: DUP2 PUSH 20 ADD DUP2 DUP3 CALLDATASIZE DUP4
*)
Compute pair "BottleCastle_run_code_of_0_block_394_0"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 2;DUP 3;Opcode CALLDATASIZE;DUP 4] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;Opcode ADD;DUP 2;DUP 1;Opcode CALLDATASIZE;DUP 4] 2 optimize_id).

(*
 I: PUSH F8 SHL DUP2 DUP4 DUP2 MLOAD DUP2 LT PUSH [tag] 517
 O: PUSH f8 SHL DUP2 DUP4 DUP4 MLOAD DUP6 LT PUSH [tag] 517
*)
Compute pair "BottleCastle_run_code_of_0_block_400_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xf8%N);Opcode SHL;DUP 2;DUP 4;DUP 4;Opcode MLOAD;DUP 6;Opcode LT;PUSH 2 (NToWord WLen 0x205%N)] [PUSH 1 (NToWord WLen 0xF8%N);Opcode SHL;DUP 2;DUP 4;DUP 2;Opcode MLOAD;DUP 2;Opcode LT;PUSH 2 (NToWord WLen 0x205%N)] 3 optimize_id).

(*
 I: PUSH 20 ADD ADD SWAP1 PUSH 1 PUSH 1 PUSH F8 SHL SUB NOT AND SWAP1 DUP2 PUSH 0 BYTE SWAP1
 O: SWAP2 PUSH 1 DUP1 PUSH f8 SHL SUB NOT AND SWAP2 PUSH 20 ADD ADD DUP2 PUSH 0 BYTE SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_402_0"%string (equiv_checker [DUP 2;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xf8%N);Opcode SHL;Opcode SUB;Opcode NOT;Opcode AND;DUP 2;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;Opcode ADD;DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode BYTE;DUP 1] [PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xF8%N);Opcode SHL;Opcode SUB;Opcode NOT;Opcode AND;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode BYTE;DUP 1] 3 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP4 AND EXTCODESIZE ISZERO PUSH [tag] 285
 O: DUP3 PUSH 1 DUP1 PUSH a0 SHL SUB AND EXTCODESIZE ISZERO PUSH [tag] 285
*)
Compute pair "BottleCastle_run_code_of_0_block_405_0"%string (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode EXTCODESIZE;Opcode ISZERO;PUSH 2 (NToWord WLen 0x11d%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 4;Opcode AND;Opcode EXTCODESIZE;Opcode ISZERO;PUSH 2 (NToWord WLen 0x11d%N)] 3 optimize_id).

(*
 I: PUSH [tag] 530 PUSH 0 DUP7 DUP4 DUP1 PUSH 1 ADD SWAP5 POP DUP7 PUSH [tag] 379
 O: PUSH [tag] 530 PUSH 0 DUP7 PUSH 1 DUP5 ADD SWAP4 DUP7 PUSH [tag] 379
*)
Compute pair "BottleCastle_run_code_of_0_block_407_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x212%N);PUSH 1 (NToWord WLen 0x0%N);DUP 7;PUSH 1 (NToWord WLen 0x1%N);DUP 5;Opcode ADD;DUP 4;DUP 7;PUSH 2 (NToWord WLen 0x17b%N)] [PUSH 2 (NToWord WLen 0x212%N);PUSH 1 (NToWord WLen 0x0%N);DUP 7;DUP 4;DUP 1;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 5;POP;DUP 7;PUSH 2 (NToWord WLen 0x17b%N)] 5 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_409_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

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
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_420_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: DUP3 DUP1 SLOAD PUSH [tag] 546 SWAP1 PUSH [tag] 223
 O: DUP3 PUSH [tag] 546 DUP5 SLOAD PUSH [tag] 223
*)
Compute pair "BottleCastle_run_code_of_0_block_422_0"%string (equiv_checker [DUP 3;PUSH 2 (NToWord WLen 0x222%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0xdf%N)] [DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (NToWord WLen 0x222%N);DUP 1;PUSH 1 (NToWord WLen 0xdf%N)] 3 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1 PUSH 1F ADD PUSH 20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 548
 O: PUSH 20 DUP1 PUSH 0 KECCAK256 SWAP2 PUSH 1f ADD DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 548
*)
Compute pair "BottleCastle_run_code_of_0_block_423_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 2;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 2 (NToWord WLen 0x224%N)] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 2 (NToWord WLen 0x224%N)] 3 optimize_id).

(*
 I: DUP1 MLOAD PUSH FF NOT AND DUP4 DUP1 ADD OR DUP6
 O: DUP3 DUP1 ADD PUSH ff NOT DUP3 MLOAD AND OR DUP6
*)
Compute pair "BottleCastle_run_code_of_0_block_426_0"%string (equiv_checker [DUP 3;DUP 1;Opcode ADD;PUSH 1 (NToWord WLen 0xff%N);Opcode NOT;DUP 3;Opcode MLOAD;Opcode AND;Opcode OR;DUP 6] [DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0xFF%N);Opcode NOT;Opcode AND;DUP 4;DUP 1;Opcode ADD;Opcode OR;DUP 6] 5 optimize_id).

(*
 I: DUP3 DUP1 ADD PUSH 1 ADD DUP6
 O: DUP3 DUP4 ADD PUSH 1 ADD DUP6
*)
Compute pair "BottleCastle_run_code_of_0_block_427_0"%string (equiv_checker [DUP 3;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 6] [DUP 3;DUP 1;Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 6] 5 optimize_id).

(*
 I: SWAP2 DUP3 ADD
 O: DUP1 SWAP3 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_428_0"%string (equiv_checker [DUP 1;DUP 3;Opcode ADD] [DUP 2;DUP 3;Opcode ADD] 3 optimize_id).

(*
 I: POP PUSH [tag] 552 SWAP3 SWAP2 POP PUSH [tag] 553
 O: POP PUSH [tag] 553 PUSH [tag] 552 SWAP4 SWAP3 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_431_0"%string (equiv_checker [POP;PUSH 2 (NToWord WLen 0x229%N);PUSH 2 (NToWord WLen 0x228%N);DUP 4;DUP 3;POP] [POP;PUSH 2 (NToWord WLen 0x228%N);DUP 3;DUP 2;POP;PUSH 2 (NToWord WLen 0x229%N)] 4 optimize_id).

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
 I: DUP1 CALLDATALOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP2 AND DUP2 EQ PUSH [tag] 566
 O: DUP1 CALLDATALOAD DUP1 PUSH 1 DUP1 PUSH a0 SHL SUB DUP2 AND EQ PUSH [tag] 566
*)
Compute pair "BottleCastle_run_code_of_0_block_443_0"%string (equiv_checker [DUP 1;Opcode CALLDATALOAD;DUP 1;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 2;Opcode AND;Opcode EQ;PUSH 2 (NToWord WLen 0x236%N)] [DUP 1;Opcode CALLDATALOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 2;Opcode AND;DUP 2;Opcode EQ;PUSH 2 (NToWord WLen 0x236%N)] 1 optimize_id).

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
 I: DUP6 ADD PUSH 1F DUP2 ADD DUP8 SGT PUSH [tag] 586
 O: DUP6 ADD DUP1 PUSH 1f ADD DUP8 GT PUSH [tag] 586
*)
Compute pair "BottleCastle_run_code_of_0_block_467_0"%string (equiv_checker [DUP 6;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;DUP 8;Opcode GT;PUSH 2 (NToWord WLen 0x24a%N)] [DUP 6;Opcode ADD;PUSH 1 (NToWord WLen 0x1F%N);DUP 2;Opcode ADD;DUP 8;Opcode SGT;PUSH 2 (NToWord WLen 0x24a%N)] 7 optimize_id).

(*
 I: SWAP2 POP POP SWAP3 SWAP6 SWAP2 SWAP5 POP SWAP3 POP
 O: SWAP5 SWAP8 SWAP4 SWAP7 POP POP POP SWAP3 POP
*)
Compute pair "BottleCastle_run_code_of_0_block_470_0"%string (equiv_checker [DUP 5;DUP 8;DUP 4;DUP 7;POP;POP;POP;DUP 3;POP] [DUP 2;POP;POP;DUP 3;DUP 6;DUP 2;DUP 5;POP;DUP 3;POP] 9 optimize_id).

(*
 I: SWAP5 PUSH 20 SWAP4 SWAP1 SWAP4 ADD CALLDATALOAD SWAP4 POP POP POP
 O: SWAP5 SWAP3 PUSH 20 ADD CALLDATALOAD SWAP4 POP POP POP
*)
Compute pair "BottleCastle_run_code_of_0_block_478_0"%string (equiv_checker [DUP 5;DUP 3;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;Opcode CALLDATALOAD;DUP 4;POP;POP;POP] [DUP 5;PUSH 1 (NToWord WLen 0x20%N);DUP 4;DUP 1;DUP 4;Opcode ADD;Opcode CALLDATALOAD;DUP 4;POP;POP;POP] 6 optimize_id).

(*
 I: DUP3 ADD PUSH 1F DUP2 ADD DUP5 SGT PUSH [tag] 608
 O: DUP3 ADD DUP1 PUSH 1f ADD DUP5 GT PUSH [tag] 608
*)
Compute pair "BottleCastle_run_code_of_0_block_492_0"%string (equiv_checker [DUP 3;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;DUP 5;Opcode GT;PUSH 2 (NToWord WLen 0x260%N)] [DUP 3;Opcode ADD;PUSH 1 (NToWord WLen 0x1F%N);DUP 2;Opcode ADD;DUP 5;Opcode SGT;PUSH 2 (NToWord WLen 0x260%N)] 4 optimize_id).

(*
 I: PUSH [tag] 491 DUP5 DUP3 CALLDATALOAD PUSH 20 DUP5 ADD PUSH [tag] 557
 O: PUSH [tag] 491 DUP5 DUP3 CALLDATALOAD DUP4 PUSH 20 ADD PUSH [tag] 557
*)
Compute pair "BottleCastle_run_code_of_0_block_494_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x1eb%N);DUP 5;DUP 3;Opcode CALLDATALOAD;DUP 4;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 2 (NToWord WLen 0x22d%N)] [PUSH 2 (NToWord WLen 0x1eb%N);DUP 5;DUP 3;Opcode CALLDATALOAD;PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;PUSH 2 (NToWord WLen 0x22d%N)] 4 optimize_id).

(*
 I: POP CALLDATALOAD SWAP2 SWAP1 POP
 O: POP SWAP1 POP CALLDATALOAD SWAP1
*)
Compute pair "BottleCastle_run_code_of_0_block_497_0"%string (equiv_checker [POP;DUP 1;POP;Opcode CALLDATALOAD;DUP 1] [POP;Opcode CALLDATALOAD;DUP 2;DUP 1;POP] 4 optimize_id).

(*
 I: DUP3 CALLDATALOAD SWAP2 POP PUSH [tag] 576 PUSH 20 DUP5 ADD PUSH [tag] 564
 O: PUSH [tag] 576 PUSH 20 DUP5 DUP1 CALLDATALOAD SWAP5 POP ADD PUSH [tag] 564
*)
Compute pair "BottleCastle_run_code_of_0_block_500_0"%string (equiv_checker [PUSH 2 (NToWord WLen 0x240%N);PUSH 1 (NToWord WLen 0x20%N);DUP 5;DUP 1;Opcode CALLDATALOAD;DUP 5;POP;Opcode ADD;PUSH 2 (NToWord WLen 0x234%N)] [DUP 3;Opcode CALLDATALOAD;DUP 2;POP;PUSH 2 (NToWord WLen 0x240%N);PUSH 1 (NToWord WLen 0x20%N);DUP 5;Opcode ADD;PUSH 2 (NToWord WLen 0x234%N)] 3 optimize_id).

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
 I: DUP4 DUP9 ADD SWAP6 POP PUSH [tag] 624
 O: DUP8 DUP5 ADD SWAP6 POP PUSH [tag] 624
*)
Compute pair "BottleCastle_run_code_of_0_block_512_1"%string (equiv_checker [DUP 8;DUP 5;Opcode ADD;DUP 6;POP;PUSH 2 (NToWord WLen 0x270%N)] [DUP 4;DUP 9;Opcode ADD;DUP 6;POP;PUSH 2 (NToWord WLen 0x270%N)] 8 optimize_id).

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
 I: SWAP3 DUP5 ADD SWAP3 SWAP2 DUP5 ADD SWAP2 PUSH 1 ADD PUSH [tag] 636
 O: PUSH 1 ADD DUP5 PUSH [tag] 636 SWAP5 ADD SWAP4 SWAP3 DUP6 ADD SWAP3
*)
Compute pair "BottleCastle_run_code_of_0_block_522_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x27c%N);DUP 5;Opcode ADD;DUP 4;DUP 3;DUP 6;Opcode ADD;DUP 3] [DUP 3;DUP 5;Opcode ADD;DUP 3;DUP 2;DUP 5;Opcode ADD;DUP 2;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;PUSH 2 (NToWord WLen 0x27c%N)] 5 optimize_id).

(*
 I: PUSH 0 PUSH [tag] 412 PUSH 20 DUP4 ADD DUP5 PUSH [tag] 615
 O: PUSH 0 PUSH [tag] 412 DUP3 PUSH 20 ADD DUP5 PUSH [tag] 615
*)
Compute pair "BottleCastle_run_code_of_0_block_523_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x19c%N);DUP 3;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x267%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 2 (NToWord WLen 0x19c%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 5;PUSH 2 (NToWord WLen 0x267%N)] 2 optimize_id).

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
 I: PUSH 0 DUP2 PUSH 0 NOT DIV DUP4 GT DUP3 ISZERO ISZERO AND ISZERO PUSH [tag] 664
 O: PUSH 0 DUP2 DUP2 NOT DIV DUP4 GT DUP3 ISZERO ISZERO AND ISZERO PUSH [tag] 664
*)
Compute pair "BottleCastle_run_code_of_0_block_531_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2;Opcode NOT;Opcode DIV;DUP 4;Opcode GT;DUP 3;Opcode ISZERO;Opcode ISZERO;Opcode AND;Opcode ISZERO;PUSH 2 (NToWord WLen 0x298%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;Opcode DIV;DUP 4;Opcode GT;DUP 3;Opcode ISZERO;Opcode ISZERO;Opcode AND;Opcode ISZERO;PUSH 2 (NToWord WLen 0x298%N)] 2 optimize_id).

(*
 I: DUP2 DUP2 ADD MLOAD DUP4 DUP3 ADD
 O: DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD
*)
Compute pair "BottleCastle_run_code_of_0_block_539_0"%string (equiv_checker [DUP 1;DUP 3;Opcode ADD;Opcode MLOAD;DUP 2;DUP 5;Opcode ADD] [DUP 2;DUP 2;Opcode ADD;Opcode MLOAD;DUP 4;DUP 3;Opcode ADD] 3 optimize_id).

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
 I: PUSH 0 PUSH 0 NOT DUP3 EQ ISZERO PUSH [tag] 678
 O: PUSH 0 DUP2 DUP2 NOT EQ ISZERO PUSH [tag] 678
*)
Compute pair "BottleCastle_run_code_of_0_block_547_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2;Opcode NOT;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x2a6%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x0%N);Opcode NOT;DUP 3;Opcode EQ;Opcode ISZERO;PUSH 2 (NToWord WLen 0x2a6%N)] 1 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH E0 SHL SUB NOT DUP2 AND DUP2 EQ PUSH [tag] 437
 O: DUP1 DUP2 PUSH 1 DUP1 PUSH e0 SHL SUB NOT AND EQ PUSH [tag] 437
*)
Compute pair "BottleCastle_run_code_of_0_block_557_0"%string (equiv_checker [DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode SUB;Opcode NOT;Opcode AND;Opcode EQ;PUSH 2 (NToWord WLen 0x1b5%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 2;Opcode AND;DUP 2;Opcode EQ;PUSH 2 (NToWord WLen 0x1b5%N)] 1 optimize_id).

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 1
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 1
*)
Compute pair "ERC721A_initial_block_0_1"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1%N)] 0 optimize_id).

(*
 I: DUP2 ADD PUSH 40 DUP2 SWAP1
 O: DUP2 ADD DUP1 PUSH 40
*)
Compute pair "ERC721A_initial_block_2_1"%string (equiv_checker [DUP 2;Opcode ADD;DUP 1;PUSH 1 (NToWord WLen 0x40%N)] [DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);DUP 2;DUP 1] 2 optimize_id).

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
 I: DUP3 DUP1 SLOAD PUSH [tag] 13 SWAP1 PUSH [tag] 14
 O: DUP3 PUSH [tag] 13 DUP5 SLOAD PUSH [tag] 14
*)
Compute pair "ERC721A_initial_block_6_0"%string (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0xd%N);DUP 5;Opcode SLOAD;PUSH 1 (NToWord WLen 0xe%N)] [DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xd%N);DUP 1;PUSH 1 (NToWord WLen 0xe%N)] 3 optimize_id).

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1 PUSH 1F ADD PUSH 20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 16
 O: PUSH 20 DUP1 PUSH 0 KECCAK256 SWAP2 PUSH 1f ADD DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 16
*)
Compute pair "ERC721A_initial_block_7_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);DUP 1;PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 2;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x10%N)] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x0%N);Opcode KECCAK256;DUP 1;PUSH 1 (NToWord WLen 0x1F%N);Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x10%N)] 3 optimize_id).

(*
 I: DUP1 MLOAD PUSH FF NOT AND DUP4 DUP1 ADD OR DUP6
 O: DUP3 DUP1 ADD PUSH ff NOT DUP3 MLOAD AND OR DUP6
*)
Compute pair "ERC721A_initial_block_10_0"%string (equiv_checker [DUP 3;DUP 1;Opcode ADD;PUSH 1 (NToWord WLen 0xff%N);Opcode NOT;DUP 3;Opcode MLOAD;Opcode AND;Opcode OR;DUP 6] [DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0xFF%N);Opcode NOT;Opcode AND;DUP 4;DUP 1;Opcode ADD;Opcode OR;DUP 6] 5 optimize_id).

(*
 I: DUP3 DUP1 ADD PUSH 1 ADD DUP6
 O: DUP3 DUP4 ADD PUSH 1 ADD DUP6
*)
Compute pair "ERC721A_initial_block_11_0"%string (equiv_checker [DUP 3;DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 6] [DUP 3;DUP 1;Opcode ADD;PUSH 1 (NToWord WLen 0x1%N);Opcode ADD;DUP 6] 5 optimize_id).

(*
 I: SWAP2 DUP3 ADD
 O: DUP1 SWAP3 ADD
*)
Compute pair "ERC721A_initial_block_12_0"%string (equiv_checker [DUP 1;DUP 3;Opcode ADD] [DUP 2;DUP 3;Opcode ADD] 3 optimize_id).

(*
 I: POP PUSH [tag] 20 SWAP3 SWAP2 POP PUSH [tag] 21
 O: POP PUSH [tag] 21 PUSH [tag] 20 SWAP4 SWAP3 POP
*)
Compute pair "ERC721A_initial_block_15_0"%string (equiv_checker [POP;PUSH 1 (NToWord WLen 0x15%N);PUSH 1 (NToWord WLen 0x14%N);DUP 4;DUP 3;POP] [POP;PUSH 1 (NToWord WLen 0x14%N);DUP 3;DUP 2;POP;PUSH 1 (NToWord WLen 0x15%N)] 4 optimize_id).

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 27
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 27
*)
Compute pair "ERC721A_initial_block_20_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 3;DUP 3;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode SLT;PUSH 1 (NToWord WLen 0x1b%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 3;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;Opcode SLT;PUSH 1 (NToWord WLen 0x1b%N)] 2 optimize_id).

(*
 I: DUP2 MLOAD PUSH 1 PUSH 1 PUSH 40 SHL SUB DUP1 DUP3 GT ISZERO PUSH [tag] 29
 O: DUP2 MLOAD PUSH 1 DUP1 PUSH 40 SHL SUB DUP1 DUP3 GT ISZERO PUSH [tag] 29
*)
Compute pair "ERC721A_initial_block_22_0"%string (equiv_checker [DUP 2;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode SHL;Opcode SUB;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1d%N)] [DUP 2;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x40%N);Opcode SHL;Opcode SUB;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1d%N)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 1F DUP4 ADD PUSH 1F NOT SWAP1 DUP2 AND PUSH 3F ADD AND DUP2 ADD SWAP1 DUP3 DUP3 GT DUP2 DUP4 LT OR ISZERO PUSH [tag] 32
 O: PUSH 40 MLOAD PUSH 1f NOT PUSH 3f DUP2 DUP6 PUSH 1f ADD AND ADD AND ADD PUSH 40 MLOAD DUP3 DUP3 GT DUP2 DUP4 LT OR ISZERO PUSH [tag] 32
*)
Compute pair "ERC721A_initial_block_24_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x1f%N);Opcode NOT;PUSH 1 (NToWord WLen 0x3f%N);DUP 2;DUP 6;PUSH 1 (NToWord WLen 0x1f%N);Opcode ADD;Opcode AND;Opcode ADD;Opcode AND;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 3;DUP 3;Opcode GT;DUP 2;DUP 4;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 1 (NToWord WLen 0x20%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;DUP 1;DUP 2;Opcode AND;PUSH 1 (NToWord WLen 0x3F%N);Opcode ADD;Opcode AND;DUP 2;Opcode ADD;DUP 1;DUP 3;DUP 3;Opcode GT;DUP 2;DUP 4;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 1 (NToWord WLen 0x20%N)] 2 optimize_id).

(*
 I: PUSH 20 SWAP3 POP DUP7 DUP4 DUP6 DUP9 ADD ADD GT ISZERO PUSH [tag] 33
 O: DUP7 DUP7 DUP6 ADD PUSH 20 DUP1 SWAP6 POP ADD GT ISZERO PUSH [tag] 33
*)
Compute pair "ERC721A_initial_block_26_2"%string (equiv_checker [DUP 7;DUP 7;DUP 6;Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);DUP 1;DUP 6;POP;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x21%N)] [PUSH 1 (NToWord WLen 0x20%N);DUP 3;POP;DUP 7;DUP 4;DUP 6;DUP 9;Opcode ADD;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x21%N)] 7 optimize_id).

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
 I: PUSH 0 DUP4 DUP6 DUP4 ADD ADD
 O: PUSH 0 DUP5 DUP3 ADD DUP5 ADD
*)
Compute pair "ERC721A_initial_block_32_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 5;DUP 3;Opcode ADD;DUP 5;Opcode ADD] [PUSH 1 (NToWord WLen 0x0%N);DUP 4;DUP 6;DUP 4;Opcode ADD;Opcode ADD] 4 optimize_id).

(*
 I: DUP3 MLOAD PUSH 1 PUSH 1 PUSH 40 SHL SUB DUP1 DUP3 GT ISZERO PUSH [tag] 40
 O: DUP3 MLOAD PUSH 1 DUP1 PUSH 40 SHL SUB DUP1 DUP3 GT ISZERO PUSH [tag] 40
*)
Compute pair "ERC721A_initial_block_36_0"%string (equiv_checker [DUP 3;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode SHL;Opcode SUB;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x28%N)] [DUP 3;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x40%N);Opcode SHL;Opcode SUB;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x28%N)] 3 optimize_id).

(*
 I: SWAP4 POP PUSH 20 DUP6 ADD MLOAD SWAP2 POP DUP1 DUP3 GT ISZERO PUSH [tag] 42
 O: SWAP4 POP DUP1 PUSH 20 DUP7 ADD MLOAD DUP1 SWAP4 POP GT ISZERO PUSH [tag] 42
*)
Compute pair "ERC721A_initial_block_39_0"%string (equiv_checker [DUP 4;POP;DUP 1;PUSH 1 (NToWord WLen 0x20%N);DUP 7;Opcode ADD;Opcode MLOAD;DUP 1;DUP 4;POP;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x2a%N)] [DUP 4;POP;PUSH 1 (NToWord WLen 0x20%N);DUP 6;Opcode ADD;Opcode MLOAD;DUP 2;POP;DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0x2a%N)] 6 optimize_id).

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
 I: PUSH #[$] 0000000000000000000000000000000000000000000000000000000000000000 DUP1 PUSH [$] 0000000000000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH #[$] 0 DUP1 PUSH [$] 0 PUSH 0
  ERROR OCCURRED

'PUSH #[$]' is not in list
*)

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 1
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 1
*)
Compute pair "ERC721A_run_code_of_0_block_0_1"%string (equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1%N)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0x1%N)] 0 optimize_id).

(*
 I: PUSH 40 MLOAD SWAP1 ISZERO ISZERO DUP2
 O: ISZERO PUSH 40 MLOAD SWAP1 ISZERO DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_26_0"%string (equiv_checker [Opcode ISZERO;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;Opcode ISZERO;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;Opcode ISZERO;Opcode ISZERO;DUP 2] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH [tag] 24 SWAP2 SWAP1 PUSH [tag] 29
 O: PUSH [tag] 24 SWAP1 PUSH 40 MLOAD PUSH [tag] 29
*)
Compute pair "ERC721A_run_code_of_0_block_29_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x18%N);DUP 1;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x1d%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x18%N);DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x1d%N)] 1 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB SWAP1 SWAP2 AND DUP2
 O: PUSH 40 MLOAD SWAP1 PUSH 1 DUP1 PUSH a0 SHL SUB AND DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_32_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 1;DUP 2;Opcode AND;DUP 2] 1 optimize_id).

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
 I: POP PUSH 5B5E139F PUSH E0 SHL PUSH 1 PUSH 1 PUSH E0 SHL SUB NOT DUP4 AND EQ
 O: POP PUSH 5b5e139f PUSH e0 SHL PUSH 1 DUP1 PUSH e0 SHL SUB NOT DUP4 AND EQ
*)
Compute pair "ERC721A_run_code_of_0_block_58_0"%string (equiv_checker [POP;PUSH 4 (NToWord WLen 0x5b5e139f%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 4;Opcode AND;Opcode EQ] [POP;PUSH 4 (NToWord WLen 0x5B5E139F%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 4;Opcode AND;Opcode EQ] 3 optimize_id).

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
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_71_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB AND SWAP1
 O: PUSH 40 PUSH 1 DUP1 PUSH a0 SHL SUB SWAP2 KECCAK256 SLOAD AND SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_72_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 2;Opcode KECCAK256;Opcode SLOAD;Opcode AND;DUP 1] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;DUP 1] 2 optimize_id).

(*
 I: SWAP1 POP CALLER PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP3 AND EQ PUSH [tag] 101
 O: PUSH 1 DUP1 DUP3 SWAP4 POP PUSH a0 SHL SUB AND CALLER EQ PUSH [tag] 101
*)
Compute pair "ERC721A_run_code_of_0_block_74_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;DUP 3;DUP 4;POP;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode CALLER;Opcode EQ;PUSH 1 (NToWord WLen 0x65%N)] [DUP 1;POP;Opcode CALLER;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 3;Opcode AND;Opcode EQ;PUSH 1 (NToWord WLen 0x65%N)] 2 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_77_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: SWAP2 MLOAD DUP6 SWAP4 SWAP2 DUP6 AND SWAP2 PUSH 8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B925 SWAP2
 O: SWAP2 SWAP1 DUP6 SWAP4 PUSH 8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925 SWAP2 DUP7 AND SWAP3 MLOAD
*)
Compute pair "ERC721A_run_code_of_0_block_78_3"%string (equiv_checker [DUP 2;DUP 1;DUP 6;DUP 4;PUSH 32 (NToWord WLen 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925%N);DUP 2;DUP 7;Opcode AND;DUP 3;Opcode MLOAD] [DUP 2;Opcode MLOAD;DUP 6;DUP 4;DUP 2;DUP 6;Opcode AND;DUP 2;PUSH 32 (NToWord WLen 0x8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B925%N);DUP 2] 6 optimize_id).

(*
 I: SWAP1 POP DUP4 PUSH 1 PUSH 1 PUSH A0 SHL SUB AND DUP2 PUSH 1 PUSH 1 PUSH A0 SHL SUB AND EQ PUSH [tag] 108
 O: DUP1 SWAP2 POP PUSH 1 DUP1 PUSH a0 SHL SUB DUP6 DUP2 AND SWAP2 AND EQ PUSH [tag] 108
*)
Compute pair "ERC721A_run_code_of_0_block_80_0"%string (equiv_checker [DUP 1;DUP 2;POP;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 6;DUP 2;Opcode AND;DUP 2;Opcode AND;Opcode EQ;PUSH 1 (NToWord WLen 0x6c%N)] [DUP 1;POP;DUP 4;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;DUP 2;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode EQ;PUSH 1 (NToWord WLen 0x6c%N)] 5 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_81_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 DUP1 SLOAD CALLER DUP1 DUP3 EQ PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP9 AND SWAP1 SWAP2 EQ OR PUSH [tag] 117
 O: PUSH 40 SWAP1 KECCAK256 DUP5 PUSH 1 DUP1 PUSH a0 SHL SUB AND CALLER EQ DUP2 SLOAD SWAP1 CALLER DUP3 EQ OR PUSH [tag] 117
*)
Compute pair "ERC721A_run_code_of_0_block_82_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;DUP 5;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode CALLER;Opcode EQ;DUP 2;Opcode SLOAD;DUP 1;Opcode CALLER;DUP 3;Opcode EQ;Opcode OR;PUSH 1 (NToWord WLen 0x75%N)] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;DUP 1;Opcode SLOAD;Opcode CALLER;DUP 1;DUP 3;Opcode EQ;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 9;Opcode AND;DUP 1;DUP 2;Opcode EQ;Opcode OR;PUSH 1 (NToWord WLen 0x75%N)] 5 optimize_id).

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
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_87_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP7 DUP2 AND PUSH 0 SWAP1 DUP2
 O: PUSH 1 DUP1 PUSH a0 SHL SUB PUSH 0 DUP8 DUP3 AND DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_90_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;PUSH 1 (NToWord WLen 0x0%N);DUP 8;DUP 3;Opcode AND;DUP 2] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 7;DUP 2;Opcode AND;PUSH 1 (NToWord WLen 0x0%N);DUP 1;DUP 2] 6 optimize_id).

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
 I: PUSH 0 SLOAD DUP2 EQ PUSH [tag] 128
 O: DUP1 PUSH 0 SLOAD EQ PUSH [tag] 128
*)
Compute pair "ERC721A_run_code_of_0_block_92_0"%string (equiv_checker [DUP 1;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;Opcode EQ;PUSH 1 (NToWord WLen 0x80%N)] [PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 2;Opcode EQ;PUSH 1 (NToWord WLen 0x80%N)] 1 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 DUP5 SWAP1
 O: PUSH 40 DUP6 SWAP2 KECCAK256
*)
Compute pair "ERC721A_run_code_of_0_block_93_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 6;DUP 2;Opcode KECCAK256] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;DUP 5;DUP 1] 5 optimize_id).

(*
 I: PUSH [tag] 132 DUP4 DUP4 DUP4 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH [tag] 132 DUP4 DUP4 DUP4 PUSH 40 MLOAD PUSH 20 DUP2 ADD PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_96_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x84%N);DUP 4;DUP 4;DUP 4;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [PUSH 1 (NToWord WLen 0x84%N);DUP 4;DUP 4;DUP 4;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] 3 optimize_id).

(*
 I: PUSH 0 PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP3 AND PUSH [tag] 136
 O: PUSH 0 PUSH 1 DUP1 PUSH a0 SHL SUB DUP3 AND PUSH [tag] 136
*)
Compute pair "ERC721A_run_code_of_0_block_99_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 3;Opcode AND;PUSH 1 (NToWord WLen 0x88%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 3;Opcode AND;PUSH 1 (NToWord WLen 0x88%N)] 1 optimize_id).

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
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_104_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

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
 I: SWAP3 DUP2 SWAP1 KECCAK256 DUP1 SLOAD PUSH FF NOT AND DUP7 ISZERO ISZERO SWAP1 DUP2 OR SWAP1 SWAP2
 O: DUP2 DUP7 ISZERO ISZERO SWAP2 SWAP5 KECCAK256 DUP2 PUSH ff NOT DUP3 SLOAD AND OR SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_105_4"%string (equiv_checker [DUP 2;DUP 7;Opcode ISZERO;Opcode ISZERO;DUP 2;DUP 5;Opcode KECCAK256;DUP 2;PUSH 1 (NToWord WLen 0xff%N);Opcode NOT;DUP 3;Opcode SLOAD;Opcode AND;Opcode OR;DUP 1] [DUP 3;DUP 2;DUP 1;Opcode KECCAK256;DUP 1;Opcode SLOAD;PUSH 1 (NToWord WLen 0xFF%N);Opcode NOT;Opcode AND;DUP 7;Opcode ISZERO;Opcode ISZERO;DUP 1;DUP 2;Opcode OR;DUP 1;DUP 2] 6 optimize_id).

(*
 I: SWAP2 SWAP3 SWAP2 PUSH 17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C31 SWAP2 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: ADD PUSH 40 MLOAD DUP1 SWAP4 SWAP3 SWAP4 SWAP2 SUB PUSH 17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31 SWAP2
*)
Compute pair "ERC721A_run_code_of_0_block_105_6"%string (equiv_checker [Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 4;DUP 3;DUP 4;DUP 2;Opcode SUB;PUSH 32 (NToWord WLen 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31%N);DUP 2] [DUP 2;DUP 3;DUP 2;PUSH 32 (NToWord WLen 0x17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C31%N);DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 4 optimize_id).

(*
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP4 AND EXTCODESIZE ISZERO PUSH [tag] 154
 O: DUP3 PUSH 1 DUP1 PUSH a0 SHL SUB AND EXTCODESIZE ISZERO PUSH [tag] 154
*)
Compute pair "ERC721A_run_code_of_0_block_107_0"%string (equiv_checker [DUP 3;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;Opcode AND;Opcode EXTCODESIZE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x9a%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 4;Opcode AND;Opcode EXTCODESIZE;Opcode ISZERO;PUSH 1 (NToWord WLen 0x9a%N)] 3 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_110_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

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
 I: SWAP1 POP DUP1 MLOAD PUSH 0 EQ ISZERO PUSH [tag] 160
 O: DUP1 SWAP2 POP MLOAD PUSH 0 EQ ISZERO PUSH [tag] 160
*)
Compute pair "ERC721A_run_code_of_0_block_116_0"%string (equiv_checker [DUP 1;DUP 2;POP;Opcode MLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0xa0%N)] [DUP 1;POP;DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x0%N);Opcode EQ;Opcode ISZERO;PUSH 1 (NToWord WLen 0xa0%N)] 2 optimize_id).

(*
 I: PUSH 40 MLOAD PUSH 20 ADD PUSH [tag] 164 SWAP3 SWAP2 SWAP1 PUSH [tag] 165
 O: PUSH [tag] 164 SWAP2 SWAP1 PUSH 20 PUSH 40 MLOAD ADD PUSH [tag] 165
*)
Compute pair "ERC721A_run_code_of_0_block_119_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0xa4%N);DUP 2;DUP 1;PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;Opcode ADD;PUSH 1 (NToWord WLen 0xa5%N)] [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;PUSH 1 (NToWord WLen 0xa4%N);DUP 3;DUP 2;DUP 1;PUSH 1 (NToWord WLen 0xa5%N)] 2 optimize_id).

(*
 I: PUSH 0 DUP2 PUSH 0 SLOAD DUP2 LT ISZERO PUSH [tag] 176
 O: PUSH 0 DUP2 DUP2 SLOAD DUP2 LT ISZERO PUSH [tag] 176
*)
Compute pair "ERC721A_run_code_of_0_block_124_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);DUP 2;DUP 2;Opcode SLOAD;DUP 2;Opcode LT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb0%N)] [PUSH 1 (NToWord WLen 0x0%N);DUP 2;PUSH 1 (NToWord WLen 0x0%N);Opcode SLOAD;DUP 2;Opcode LT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xb0%N)] 1 optimize_id).

(*
 I: PUSH 40 SWAP1 KECCAK256 SLOAD PUSH 1 PUSH E0 SHL DUP2 AND PUSH [tag] 177
 O: PUSH 40 SWAP1 KECCAK256 SLOAD DUP1 PUSH 1 PUSH e0 SHL AND PUSH [tag] 177
*)
Compute pair "ERC721A_run_code_of_0_block_125_2"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;DUP 1;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode AND;PUSH 1 (NToWord WLen 0xb1%N)] [PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode KECCAK256;Opcode SLOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;DUP 2;Opcode AND;PUSH 1 (NToWord WLen 0xb1%N)] 1 optimize_id).

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_129_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

(*
 I: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP1 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 192
 O: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP9 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 192
*)
Compute pair "ERC721A_run_code_of_0_block_131_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (NToWord WLen 0x0%N);DUP 8;DUP 9;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc0%N)] [PUSH 1 (NToWord WLen 0x20%N);PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (NToWord WLen 0x0%N);DUP 8;DUP 1;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 1 (NToWord WLen 0xc0%N)] 3 optimize_id).

(*
 I: POP PUSH 40 DUP1 MLOAD PUSH 1F RETURNDATASIZE SWAP1 DUP2 ADD PUSH 1F NOT AND DUP3 ADD SWAP1 SWAP3
 O: POP RETURNDATASIZE PUSH 40 MLOAD DUP1 DUP3 PUSH 1f DUP1 NOT SWAP2 ADD AND ADD PUSH 40
*)
Compute pair "ERC721A_run_code_of_0_block_134_0"%string (equiv_checker [POP;Opcode RETURNDATASIZE;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 3;PUSH 1 (NToWord WLen 0x1f%N);DUP 1;Opcode NOT;DUP 2;Opcode ADD;Opcode AND;Opcode ADD;PUSH 1 (NToWord WLen 0x40%N)] [POP;PUSH 1 (NToWord WLen 0x40%N);DUP 1;Opcode MLOAD;PUSH 1 (NToWord WLen 0x1F%N);Opcode RETURNDATASIZE;DUP 1;DUP 2;Opcode ADD;PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;Opcode AND;DUP 3;Opcode ADD;DUP 1;DUP 3] 1 optimize_id).

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
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_141_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (NToWord WLen 0x4%N);Opcode ADD;PUSH 1 (NToWord WLen 0x40%N);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id).

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
 I: PUSH 1 DUP4 SUB SWAP3 POP PUSH A DUP2 MOD PUSH 30 ADD DUP4
 O: PUSH 1 PUSH 30 SWAP4 SUB SWAP3 PUSH a DUP3 MOD ADD DUP4
*)
Compute pair "ERC721A_run_code_of_0_block_145_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x30%N);DUP 4;Opcode SUB;DUP 3;PUSH 1 (NToWord WLen 0xa%N);DUP 3;Opcode MOD;Opcode ADD;DUP 4] [PUSH 1 (NToWord WLen 0x1%N);DUP 4;Opcode SUB;DUP 3;POP;PUSH 1 (NToWord WLen 0xA%N);DUP 2;Opcode MOD;PUSH 1 (NToWord WLen 0x30%N);Opcode ADD;DUP 4] 3 optimize_id).

(*
 I: POP DUP2 SWAP1 SUB PUSH 1F NOT SWAP1 SWAP2 ADD SWAP1 DUP2
 O: POP DUP2 PUSH 1f NOT ADD SWAP2 SWAP1 SUB DUP2
*)
Compute pair "ERC721A_run_code_of_0_block_148_0"%string (equiv_checker [POP;DUP 2;PUSH 1 (NToWord WLen 0x1f%N);Opcode NOT;Opcode ADD;DUP 2;DUP 1;Opcode SUB;DUP 2] [POP;DUP 2;DUP 1;Opcode SUB;PUSH 1 (NToWord WLen 0x1F%N);Opcode NOT;DUP 1;DUP 2;Opcode ADD;DUP 1;DUP 2] 3 optimize_id).

(*
 I: DUP1 CALLDATALOAD PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP2 AND DUP2 EQ PUSH [tag] 215
 O: DUP1 CALLDATALOAD DUP1 PUSH 1 DUP1 PUSH a0 SHL SUB DUP2 AND EQ PUSH [tag] 215
*)
Compute pair "ERC721A_run_code_of_0_block_149_0"%string (equiv_checker [DUP 1;Opcode CALLDATALOAD;DUP 1;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 2;Opcode AND;Opcode EQ;PUSH 1 (NToWord WLen 0xd7%N)] [DUP 1;Opcode CALLDATALOAD;PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 2;Opcode AND;DUP 2;Opcode EQ;PUSH 1 (NToWord WLen 0xd7%N)] 1 optimize_id).

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
 I: DUP2 DUP8 ADD SWAP2 POP DUP8 PUSH 1F DUP4 ADD SLT PUSH [tag] 232
 O: DUP8 SWAP2 DUP8 ADD SWAP2 PUSH 1f DUP4 ADD SLT PUSH [tag] 232
*)
Compute pair "ERC721A_run_code_of_0_block_171_0"%string (equiv_checker [DUP 8;DUP 2;DUP 8;Opcode ADD;DUP 2;PUSH 1 (NToWord WLen 0x1f%N);DUP 4;Opcode ADD;Opcode SLT;PUSH 1 (NToWord WLen 0xe8%N)] [DUP 2;DUP 8;Opcode ADD;DUP 2;POP;DUP 8;PUSH 1 (NToWord WLen 0x1F%N);DUP 4;Opcode ADD;Opcode SLT;PUSH 1 (NToWord WLen 0xe8%N)] 8 optimize_id).

(*
 I: DUP11 PUSH 20 DUP5 DUP8 ADD ADD GT ISZERO PUSH [tag] 238
 O: DUP11 DUP4 DUP7 ADD PUSH 20 ADD GT ISZERO PUSH [tag] 238
*)
Compute pair "ERC721A_run_code_of_0_block_177_2"%string (equiv_checker [DUP 11;DUP 4;DUP 7;Opcode ADD;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xee%N)] [DUP 11;PUSH 1 (NToWord WLen 0x20%N);DUP 5;DUP 8;Opcode ADD;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (NToWord WLen 0xee%N)] 11 optimize_id).

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
 I: DUP1 SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP4 POP POP SWAP1 POP SWAP2
*)
Compute pair "ERC721A_run_code_of_0_block_185_0"%string (equiv_checker [DUP 4;POP;POP;DUP 1;POP;DUP 2] [DUP 1;DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 6 optimize_id).

(*
 I: SWAP5 PUSH 20 SWAP4 SWAP1 SWAP4 ADD CALLDATALOAD SWAP4 POP POP POP
 O: SWAP5 SWAP3 PUSH 20 ADD CALLDATALOAD SWAP4 POP POP POP
*)
Compute pair "ERC721A_run_code_of_0_block_189_0"%string (equiv_checker [DUP 5;DUP 3;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;Opcode CALLDATALOAD;DUP 4;POP;POP;POP] [DUP 5;PUSH 1 (NToWord WLen 0x20%N);DUP 4;DUP 1;DUP 4;Opcode ADD;Opcode CALLDATALOAD;DUP 4;POP;POP;POP] 6 optimize_id).

(*
 I: POP CALLDATALOAD SWAP2 SWAP1 POP
 O: POP SWAP1 POP CALLDATALOAD SWAP1
*)
Compute pair "ERC721A_run_code_of_0_block_198_0"%string (equiv_checker [POP;DUP 1;POP;Opcode CALLDATALOAD;DUP 1] [POP;Opcode CALLDATALOAD;DUP 2;DUP 1;POP] 4 optimize_id).

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
 I: PUSH 1 PUSH 1 PUSH A0 SHL SUB DUP6 DUP2 AND DUP3
 O: PUSH 1 DUP1 PUSH a0 SHL SUB DUP1 DUP7 AND DUP3
*)
Compute pair "ERC721A_run_code_of_0_block_204_0"%string (equiv_checker [PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xa0%N);Opcode SHL;Opcode SUB;DUP 1;DUP 7;Opcode AND;DUP 3] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xA0%N);Opcode SHL;Opcode SUB;DUP 6;DUP 2;Opcode AND;DUP 3] 5 optimize_id).

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
 I: PUSH 0 PUSH [tag] 161 PUSH 20 DUP4 ADD DUP5 PUSH [tag] 255
 O: PUSH 0 PUSH [tag] 161 DUP3 PUSH 20 ADD DUP5 PUSH [tag] 255
*)
Compute pair "ERC721A_run_code_of_0_block_206_1"%string (equiv_checker [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0xa1%N);DUP 3;PUSH 1 (NToWord WLen 0x20%N);Opcode ADD;DUP 5;PUSH 1 (NToWord WLen 0xff%N)] [PUSH 1 (NToWord WLen 0x0%N);PUSH 1 (NToWord WLen 0xa1%N);PUSH 1 (NToWord WLen 0x20%N);DUP 4;Opcode ADD;DUP 5;PUSH 1 (NToWord WLen 0xff%N)] 2 optimize_id).

(*
 I: DUP2 DUP2 ADD MLOAD DUP4 DUP3 ADD
 O: DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD
*)
Compute pair "ERC721A_run_code_of_0_block_209_0"%string (equiv_checker [DUP 1;DUP 3;Opcode ADD;Opcode MLOAD;DUP 2;DUP 5;Opcode ADD] [DUP 2;DUP 2;Opcode ADD;Opcode MLOAD;DUP 4;DUP 3;Opcode ADD] 3 optimize_id).

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
 I: PUSH 1 PUSH 1 PUSH E0 SHL SUB NOT DUP2 AND DUP2 EQ PUSH [tag] 279
 O: DUP1 DUP2 PUSH 1 DUP1 PUSH e0 SHL SUB NOT AND EQ PUSH [tag] 279
*)
Compute pair "ERC721A_run_code_of_0_block_218_0"%string (equiv_checker [DUP 1;DUP 2;PUSH 1 (NToWord WLen 0x1%N);DUP 1;PUSH 1 (NToWord WLen 0xe0%N);Opcode SHL;Opcode SUB;Opcode NOT;Opcode AND;Opcode EQ;PUSH 2 (NToWord WLen 0x117%N)] [PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0x1%N);PUSH 1 (NToWord WLen 0xE0%N);Opcode SHL;Opcode SUB;Opcode NOT;DUP 2;Opcode AND;DUP 2;Opcode EQ;PUSH 2 (NToWord WLen 0x117%N)] 1 optimize_id).

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


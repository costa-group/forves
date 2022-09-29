(*
 I: PUSH 80 PUSH 40
 O: PUSH 80 PUSH 40
*)
Example BottleCastle_initial_block_0_0: equiv_checker [PUSH 1 (natToWord WLen 128);PUSH 1 (natToWord WLen 64)] [PUSH 1 (natToWord WLen 128);PUSH 1 (natToWord WLen 64)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 PUSH 40 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 40 ADD PUSH 40
*)
Example BottleCastle_initial_block_0_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 64);Opcode ADD;PUSH 1 (natToWord WLen 64)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 64);Opcode ADD;PUSH 1 (natToWord WLen 64)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 5 DUP2
 O: DUP1 PUSH 5 DUP2
*)
Example BottleCastle_initial_block_0_2: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 5);DUP 2] [DUP 1;PUSH 1 (natToWord WLen 5);DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 2E6A736F6E000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 20 ADD PUSH 2e6a736f6e000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_initial_block_0_3: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 32 (natToWord WLen 20994473528665075656206603645561177367371947869009395450918716214519590289408);DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 32 (natToWord WLen 20994473528665075656206603645561177367371947869009395450918716214519590289408);DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH B SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 1 SWAP3 SWAP2 SWAP1 PUSH [tag] 2
 O: POP PUSH b DUP2 PUSH 20 ADD PUSH [tag] 1 SWAP3 MLOAD PUSH [tag] 2
*)
Example BottleCastle_initial_block_0_4: equiv_checker [POP;PUSH 1 (natToWord WLen 11);DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 1);DUP 3;Opcode MLOAD;PUSH 1 (natToWord WLen 2)] [POP;PUSH 1 (natToWord WLen 11);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 1);DUP 3;DUP 2;DUP 1;PUSH 1 (natToWord WLen 2)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 38D7EA4C68000 PUSH D
 O: POP PUSH 38d7ea4c68000 PUSH d
*)
Example BottleCastle_initial_block_1_0: equiv_checker [POP;PUSH 7 (natToWord WLen 1000000000000000);PUSH 1 (natToWord WLen 13)] [POP;PUSH 7 (natToWord WLen 1000000000000000);PUSH 1 (natToWord WLen 13)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 3E7 PUSH E
 O: PUSH 3e7 PUSH e
*)
Example BottleCastle_initial_block_1_1: equiv_checker [PUSH 2 (natToWord WLen 999);PUSH 1 (natToWord WLen 14)] [PUSH 2 (natToWord WLen 999);PUSH 1 (natToWord WLen 14)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH A PUSH F
 O: PUSH a PUSH f
*)
Example BottleCastle_initial_block_1_2: equiv_checker [PUSH 1 (natToWord WLen 10);PUSH 1 (natToWord WLen 15)] [PUSH 1 (natToWord WLen 10);PUSH 1 (natToWord WLen 15)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 10 PUSH 0 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1
 O: PUSH 0 DUP1 PUSH 100 EXP PUSH 10 SLOAD PUSH ff DUP4 ISZERO ISZERO DUP4 MUL SWAP3 MUL NOT AND OR PUSH 10
*)
Example BottleCastle_initial_block_1_3: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 2 (natToWord WLen 256);Opcode EXP;PUSH 1 (natToWord WLen 16);Opcode SLOAD;PUSH 1 (natToWord WLen 255);DUP 4;Opcode ISZERO;Opcode ISZERO;DUP 4;Opcode MUL;DUP 3;Opcode MUL;Opcode NOT;Opcode AND;Opcode OR;PUSH 1 (natToWord WLen 16)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 16);PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 1 (natToWord WLen 255);Opcode MUL;Opcode NOT;Opcode AND;DUP 1;DUP 4;Opcode ISZERO;Opcode ISZERO;Opcode MUL;Opcode OR;DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 0 PUSH 10 PUSH 1 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1
 O: POP PUSH 0 PUSH 1 PUSH 100 EXP DUP2 ISZERO ISZERO DUP2 MUL SWAP1 PUSH ff MUL NOT PUSH 10 SLOAD AND OR PUSH 10
*)
Example BottleCastle_initial_block_1_4: equiv_checker [POP;PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 1);PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 2;Opcode ISZERO;Opcode ISZERO;DUP 2;Opcode MUL;DUP 1;PUSH 1 (natToWord WLen 255);Opcode MUL;Opcode NOT;PUSH 1 (natToWord WLen 16);Opcode SLOAD;Opcode AND;Opcode OR;PUSH 1 (natToWord WLen 16)] [POP;PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 16);PUSH 1 (natToWord WLen 1);PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 1 (natToWord WLen 255);Opcode MUL;Opcode NOT;Opcode AND;DUP 1;DUP 4;Opcode ISZERO;Opcode ISZERO;Opcode MUL;Opcode OR;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP CALLVALUE DUP1 ISZERO PUSH [tag] 3
 O: POP CALLVALUE CALLVALUE ISZERO PUSH [tag] 3
*)
Example BottleCastle_initial_block_1_5: equiv_checker [POP;Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 3)] [POP;Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 3)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_initial_block_2_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

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
Example BottleCastle_initial_block_3_1: equiv_checker [DUP 1;DUP 3;Opcode ADD;PUSH 1 (natToWord WLen 64)] [DUP 2;DUP 2;Opcode ADD;PUSH 1 (natToWord WLen 64)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 ADD SWAP1 PUSH [tag] 4 SWAP2 SWAP1 PUSH [tag] 5
 O: DUP2 ADD PUSH [tag] 4 SWAP2 PUSH [tag] 5
*)
Example BottleCastle_initial_block_3_2: equiv_checker [DUP 2;Opcode ADD;PUSH 1 (natToWord WLen 4);DUP 2;PUSH 1 (natToWord WLen 5)] [DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 4);DUP 2;DUP 1;PUSH 1 (natToWord WLen 5)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 PUSH 40 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 40 ADD PUSH 40
*)
Example BottleCastle_initial_block_4_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 64);Opcode ADD;PUSH 1 (natToWord WLen 64)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 64);Opcode ADD;PUSH 1 (natToWord WLen 64)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH D DUP2
 O: DUP1 PUSH d DUP2
*)
Example BottleCastle_initial_block_4_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 13);DUP 2] [DUP 1;PUSH 1 (natToWord WLen 13);DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 426F74746C6520436173746C6500000000000000000000000000000000000000 DUP2
 O: PUSH 20 ADD PUSH 426f74746c6520436173746c6500000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_initial_block_4_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 32 (natToWord WLen 30049571772031351723345959833019818071813874307486815881531387727270299828224);DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 32 (natToWord WLen 30049571772031351723345959833019818071813874307486815881531387727270299828224);DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 40 MLOAD DUP1 PUSH 40 ADD PUSH 40
 O: POP PUSH 40 MLOAD DUP1 PUSH 40 ADD PUSH 40
*)
Example BottleCastle_initial_block_4_3: equiv_checker [POP;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 64);Opcode ADD;PUSH 1 (natToWord WLen 64)] [POP;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 64);Opcode ADD;PUSH 1 (natToWord WLen 64)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 6 DUP2
 O: DUP1 PUSH 6 DUP2
*)
Example BottleCastle_initial_block_4_4: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 6);DUP 2] [DUP 1;PUSH 1 (natToWord WLen 6);DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 426F74746C650000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 20 ADD PUSH 426f74746c650000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_initial_block_4_5: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 32 (natToWord WLen 30049571772031299878373235824128149389603640895404660784187515233227472109568);DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 32 (natToWord WLen 30049571772031299878373235824128149389603640895404660784187515233227472109568);DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP DUP2 PUSH 2 SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 11 SWAP3 SWAP2 SWAP1 PUSH [tag] 2
 O: POP PUSH [tag] 11 PUSH 2 DUP4 PUSH 20 ADD DUP5 MLOAD PUSH [tag] 2
*)
Example BottleCastle_initial_block_4_6: equiv_checker [POP;PUSH 1 (natToWord WLen 11);PUSH 1 (natToWord WLen 2);DUP 4;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 5;Opcode MLOAD;PUSH 1 (natToWord WLen 2)] [POP;DUP 2;PUSH 1 (natToWord WLen 2);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 11);DUP 3;DUP 2;DUP 1;PUSH 1 (natToWord WLen 2)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP DUP1 PUSH 3 SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 12 SWAP3 SWAP2 SWAP1 PUSH [tag] 2
 O: POP PUSH [tag] 12 PUSH 3 PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 2
*)
Example BottleCastle_initial_block_5_0: equiv_checker [POP;PUSH 1 (natToWord WLen 12);PUSH 1 (natToWord WLen 3);PUSH 1 (natToWord WLen 32);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 1 (natToWord WLen 2)] [POP;DUP 1;PUSH 1 (natToWord WLen 3);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 12);DUP 3;DUP 2;DUP 1;PUSH 1 (natToWord WLen 2)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 13 PUSH [tag] 14 PUSH 20 SHL PUSH 20 SHR
 O: POP PUSH [tag] 13 PUSH [tag] 14 PUSH 20 SHL PUSH 20 SHR
*)
Example BottleCastle_initial_block_6_0: equiv_checker [POP;PUSH 1 (natToWord WLen 13);PUSH 1 (natToWord WLen 14);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] [POP;PUSH 1 (natToWord WLen 13);PUSH 1 (natToWord WLen 14);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 SWAP1
 O: DUP1 PUSH 0
*)
Example BottleCastle_initial_block_7_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 0);DUP 2;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP PUSH [tag] 16 PUSH [tag] 17 PUSH [tag] 18 PUSH 20 SHL PUSH 20 SHR
 O: POP POP POP PUSH [tag] 16 PUSH [tag] 17 PUSH [tag] 18 PUSH 20 SHL PUSH 20 SHR
*)
Example BottleCastle_initial_block_7_1: equiv_checker [POP;POP;POP;PUSH 1 (natToWord WLen 16);PUSH 1 (natToWord WLen 17);PUSH 1 (natToWord WLen 18);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] [POP;POP;POP;PUSH 1 (natToWord WLen 16);PUSH 1 (natToWord WLen 17);PUSH 1 (natToWord WLen 18);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 19 PUSH 20 SHL PUSH 20 SHR
 O: PUSH [tag] 19 PUSH 20 SHL PUSH 20 SHR
*)
Example BottleCastle_initial_block_8_0: equiv_checker [PUSH 1 (natToWord WLen 19);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] [PUSH 1 (natToWord WLen 19);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 1 PUSH 9 DUP2 SWAP1
 O: PUSH 1 DUP1 PUSH 9
*)
Example BottleCastle_initial_block_9_0: equiv_checker [PUSH 1 (natToWord WLen 1);DUP 1;PUSH 1 (natToWord WLen 9)] [PUSH 1 (natToWord WLen 1);PUSH 1 (natToWord WLen 9);DUP 2;DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 22 DUP3 PUSH [tag] 23 PUSH 20 SHL PUSH 20 SHR
 O: POP PUSH [tag] 22 DUP3 PUSH [tag] 23 PUSH 20 SHL PUSH 20 SHR
*)
Example BottleCastle_initial_block_9_1: equiv_checker [POP;PUSH 1 (natToWord WLen 22);DUP 3;PUSH 1 (natToWord WLen 23);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] [POP;PUSH 1 (natToWord WLen 22);DUP 3;PUSH 1 (natToWord WLen 23);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 24 DUP2 PUSH [tag] 25 PUSH 20 SHL PUSH 20 SHR
 O: PUSH [tag] 24 DUP2 PUSH [tag] 25 PUSH 20 SHL PUSH 20 SHR
*)
Example BottleCastle_initial_block_10_0: equiv_checker [PUSH 1 (natToWord WLen 24);DUP 2;PUSH 1 (natToWord WLen 25);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] [PUSH 1 (natToWord WLen 24);DUP 2;PUSH 1 (natToWord WLen 25);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP PUSH [tag] 26
 O: POP POP PUSH [tag] 26
*)
Example BottleCastle_initial_block_11_0: equiv_checker [POP;POP;PUSH 1 (natToWord WLen 26)] [POP;POP;PUSH 1 (natToWord WLen 26)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 1 SWAP1 POP SWAP1
 O: PUSH 1 SWAP1
*)
Example BottleCastle_initial_block_12_0: equiv_checker [PUSH 1 (natToWord WLen 1);DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 1);DUP 1;POP;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 CALLER SWAP1 POP SWAP1
 O: CALLER SWAP1
*)
Example BottleCastle_initial_block_13_0: equiv_checker [Opcode CALLER;DUP 1] [PUSH 1 (natToWord WLen 0);Opcode CALLER;DUP 1;POP;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 8BE0079C531659141344CD1FD0A4F28419497F9722A3DAAFE3B4186F6B6457E0 PUSH 40 MLOAD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: POP PUSH 40 MLOAD DUP1 DUP1 SUB PUSH 8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP5 DUP2 AND SWAP3 SWAP1 DUP7 AND SWAP4
*)
Example BottleCastle_initial_block_14_1: equiv_checker [POP;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 1;Opcode SUB;PUSH 32 (natToWord WLen 63267312222310607310220992301550539520881909915348243260808268974908359596000);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 5;DUP 2;Opcode AND;DUP 3;DUP 1;DUP 7;Opcode AND;DUP 4] [POP;DUP 2;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 32 (natToWord WLen 63267312222310607310220992301550539520881909915348243260808268974908359596000);PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_initial_block_14_2: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 31 PUSH [tag] 32 PUSH 20 SHL PUSH 20 SHR
 O: PUSH [tag] 31 PUSH [tag] 32 PUSH 20 SHL PUSH 20 SHR
*)
Example BottleCastle_initial_block_15_0: equiv_checker [PUSH 1 (natToWord WLen 31);PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] [PUSH 1 (natToWord WLen 31);PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH A SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 34 SWAP3 SWAP2 SWAP1 PUSH [tag] 2
 O: PUSH [tag] 34 PUSH a PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 2
*)
Example BottleCastle_initial_block_16_0: equiv_checker [PUSH 1 (natToWord WLen 34);PUSH 1 (natToWord WLen 10);PUSH 1 (natToWord WLen 32);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 1 (natToWord WLen 2)] [DUP 1;PUSH 1 (natToWord WLen 10);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 34);DUP 3;DUP 2;DUP 1;PUSH 1 (natToWord WLen 2)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_initial_block_17_0: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 36 PUSH [tag] 32 PUSH 20 SHL PUSH 20 SHR
 O: PUSH [tag] 36 PUSH [tag] 32 PUSH 20 SHL PUSH 20 SHR
*)
Example BottleCastle_initial_block_18_0: equiv_checker [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH C SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 38 SWAP3 SWAP2 SWAP1 PUSH [tag] 2
 O: PUSH [tag] 38 PUSH c PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 2
*)
Example BottleCastle_initial_block_19_0: equiv_checker [PUSH 1 (natToWord WLen 38);PUSH 1 (natToWord WLen 12);PUSH 1 (natToWord WLen 32);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 1 (natToWord WLen 2)] [DUP 1;PUSH 1 (natToWord WLen 12);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 38);DUP 3;DUP 2;DUP 1;PUSH 1 (natToWord WLen 2)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_initial_block_20_0: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 40 PUSH [tag] 18 PUSH 20 SHL PUSH 20 SHR
 O: PUSH [tag] 40 PUSH [tag] 18 PUSH 20 SHL PUSH 20 SHR
*)
Example BottleCastle_initial_block_21_0: equiv_checker [PUSH 1 (natToWord WLen 40);PUSH 1 (natToWord WLen 18);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] [PUSH 1 (natToWord WLen 40);PUSH 1 (natToWord WLen 18);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH [tag] 41 PUSH [tag] 42 PUSH 20 SHL PUSH 20 SHR
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH [tag] 41 PUSH [tag] 42 PUSH 20 SHL PUSH 20 SHR
*)
Example BottleCastle_initial_block_22_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 1 (natToWord WLen 41);PUSH 1 (natToWord WLen 42);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 1 (natToWord WLen 41);PUSH 1 (natToWord WLen 42);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ PUSH [tag] 43
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ PUSH [tag] 43
*)
Example BottleCastle_initial_block_23_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;PUSH 1 (natToWord WLen 43)] [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;PUSH 1 (natToWord WLen 43)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_initial_block_24_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH [tag] 44 SWAP1 PUSH [tag] 45
 O: PUSH [tag] 44 SWAP1 PUSH 4 ADD PUSH [tag] 45
*)
Example BottleCastle_initial_block_24_1: equiv_checker [PUSH 1 (natToWord WLen 44);DUP 1;PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 45)] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 44);DUP 1;PUSH 1 (natToWord WLen 45)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_initial_block_25_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 8 PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1 POP SWAP1
 O: PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 PUSH 100 EXP PUSH 8 SLOAD DIV AND SWAP1
*)
Example BottleCastle_initial_block_27_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 256);Opcode EXP;PUSH 1 (natToWord WLen 8);Opcode SLOAD;Opcode DIV;Opcode AND;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 8);PUSH 1 (natToWord WLen 0);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 1;Opcode DIV;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 1;POP;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 DUP1 SLOAD PUSH [tag] 47 SWAP1 PUSH [tag] 48
 O: DUP3 PUSH [tag] 47 DUP5 SLOAD PUSH [tag] 48
*)
Example BottleCastle_initial_block_28_0: equiv_checker [DUP 3;PUSH 1 (natToWord WLen 47);DUP 5;Opcode SLOAD;PUSH 1 (natToWord WLen 48)] [DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (natToWord WLen 47);DUP 1;PUSH 1 (natToWord WLen 48)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 PUSH 0
 O: SWAP1 PUSH 0
*)
Example BottleCastle_initial_block_29_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 0)] [DUP 1;PUSH 1 (natToWord WLen 0)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1 PUSH 1F ADD PUSH 20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 50
 O: PUSH 20 DUP1 PUSH 0 KECCAK256 SWAP2 PUSH 1f ADD DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 50
*)
Example BottleCastle_initial_block_29_1: equiv_checker [PUSH 1 (natToWord WLen 32);DUP 1;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 2;PUSH 1 (natToWord WLen 31);Opcode ADD;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 1 (natToWord WLen 50)] [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1;PUSH 1 (natToWord WLen 31);Opcode ADD;PUSH 1 (natToWord WLen 32);DUP 1;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 1 (natToWord WLen 50)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP6
 O: PUSH 0 DUP6
*)
Example BottleCastle_initial_block_30_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 6] [PUSH 1 (natToWord WLen 0);DUP 6] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 49
 O: PUSH [tag] 49
*)
Example BottleCastle_initial_block_30_1: equiv_checker [PUSH 1 (natToWord WLen 49)] [PUSH 1 (natToWord WLen 49)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 PUSH 1F LT PUSH [tag] 51
 O: DUP3 PUSH 1f LT PUSH [tag] 51
*)
Example BottleCastle_initial_block_31_0: equiv_checker [DUP 3;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 1 (natToWord WLen 51)] [DUP 3;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 1 (natToWord WLen 51)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 MLOAD PUSH FF NOT AND DUP4 DUP1 ADD OR DUP6
 O: DUP3 DUP1 ADD PUSH ff NOT DUP3 MLOAD AND OR DUP6
*)
Example BottleCastle_initial_block_32_0: equiv_checker [DUP 3;DUP 1;Opcode ADD;PUSH 1 (natToWord WLen 255);Opcode NOT;DUP 3;Opcode MLOAD;Opcode AND;Opcode OR;DUP 6] [DUP 1;Opcode MLOAD;PUSH 1 (natToWord WLen 255);Opcode NOT;Opcode AND;DUP 4;DUP 1;Opcode ADD;Opcode OR;DUP 6] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 49
 O: PUSH [tag] 49
*)
Example BottleCastle_initial_block_32_1: equiv_checker [PUSH 1 (natToWord WLen 49)] [PUSH 1 (natToWord WLen 49)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 DUP1 ADD PUSH 1 ADD DUP6
 O: DUP3 DUP4 ADD PUSH 1 ADD DUP6
*)
Example BottleCastle_initial_block_33_0: equiv_checker [DUP 3;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 6] [DUP 3;DUP 1;Opcode ADD;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 6] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 ISZERO PUSH [tag] 49
 O: DUP3 ISZERO PUSH [tag] 49
*)
Example BottleCastle_initial_block_33_1: equiv_checker [DUP 3;Opcode ISZERO;PUSH 1 (natToWord WLen 49)] [DUP 3;Opcode ISZERO;PUSH 1 (natToWord WLen 49)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 DUP3 ADD
 O: DUP1 SWAP3 ADD
*)
Example BottleCastle_initial_block_34_0: equiv_checker [DUP 1;DUP 3;Opcode ADD] [DUP 2;DUP 3;Opcode ADD] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 DUP2 GT ISZERO PUSH [tag] 53
 O: DUP3 DUP2 GT ISZERO PUSH [tag] 53
*)
Example BottleCastle_initial_block_35_0: equiv_checker [DUP 3;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 53)] [DUP 3;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 53)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 MLOAD DUP3
 O: DUP3 MLOAD DUP3
*)
Example BottleCastle_initial_block_36_0: equiv_checker [DUP 3;Opcode MLOAD;DUP 3] [DUP 3;Opcode MLOAD;DUP 3] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 PUSH 20 ADD SWAP2 SWAP1 PUSH 1 ADD SWAP1 PUSH [tag] 52
 O: SWAP2 PUSH 20 ADD SWAP2 SWAP1 PUSH 1 ADD SWAP1 PUSH [tag] 52
*)
Example BottleCastle_initial_block_36_1: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 52)] [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 52)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP1 POP PUSH [tag] 54 SWAP2 SWAP1 PUSH [tag] 55
 O: POP PUSH [tag] 54 SWAP3 SWAP2 POP PUSH [tag] 55
*)
Example BottleCastle_initial_block_38_0: equiv_checker [POP;PUSH 1 (natToWord WLen 54);DUP 3;DUP 2;POP;PUSH 1 (natToWord WLen 55)] [POP;DUP 1;POP;PUSH 1 (natToWord WLen 54);DUP 2;DUP 1;PUSH 1 (natToWord WLen 55)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP1
 O: POP SWAP1
*)
Example BottleCastle_initial_block_39_0: equiv_checker [POP;DUP 1] [POP;DUP 1] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 DUP3 GT ISZERO PUSH [tag] 57
 O: DUP1 DUP3 GT ISZERO PUSH [tag] 57
*)
Example BottleCastle_initial_block_41_0: equiv_checker [DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 57)] [DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 57)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 PUSH 0 SWAP1
 O: PUSH 0 DUP1 DUP3
*)
Example BottleCastle_initial_block_42_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;DUP 3] [PUSH 1 (natToWord WLen 0);DUP 2;PUSH 1 (natToWord WLen 0);DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 1 ADD PUSH [tag] 56
 O: POP PUSH 1 ADD PUSH [tag] 56
*)
Example BottleCastle_initial_block_42_1: equiv_checker [POP;PUSH 1 (natToWord WLen 1);Opcode ADD;PUSH 1 (natToWord WLen 56)] [POP;PUSH 1 (natToWord WLen 1);Opcode ADD;PUSH 1 (natToWord WLen 56)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP1
 O: POP SWAP1
*)
Example BottleCastle_initial_block_43_0: equiv_checker [POP;DUP 1] [POP;DUP 1] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 61 PUSH [tag] 62 DUP5 PUSH [tag] 63
 O: PUSH 0 PUSH [tag] 61 PUSH [tag] 62 DUP5 PUSH [tag] 63
*)
Example BottleCastle_initial_block_44_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 61);PUSH 1 (natToWord WLen 62);DUP 5;PUSH 1 (natToWord WLen 63)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 61);PUSH 1 (natToWord WLen 62);DUP 5;PUSH 1 (natToWord WLen 63)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 64
 O: PUSH [tag] 64
*)
Example BottleCastle_initial_block_45_0: equiv_checker [PUSH 1 (natToWord WLen 64)] [PUSH 1 (natToWord WLen 64)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP DUP3 DUP2
 O: SWAP1 POP DUP3 DUP2
*)
Example BottleCastle_initial_block_46_0: equiv_checker [DUP 1;POP;DUP 3;DUP 2] [DUP 1;POP;DUP 3;DUP 2] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP2 ADD DUP5 DUP5 DUP5 ADD GT ISZERO PUSH [tag] 65
 O: DUP1 PUSH 20 ADD DUP5 DUP4 DUP6 ADD GT ISZERO PUSH [tag] 65
*)
Example BottleCastle_initial_block_46_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 5;DUP 4;DUP 6;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 65)] [PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;DUP 5;DUP 5;DUP 5;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 65)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 66 PUSH [tag] 67
 O: PUSH [tag] 66 PUSH [tag] 67
*)
Example BottleCastle_initial_block_47_0: equiv_checker [PUSH 1 (natToWord WLen 66);PUSH 1 (natToWord WLen 67)] [PUSH 1 (natToWord WLen 66);PUSH 1 (natToWord WLen 67)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 68 DUP5 DUP3 DUP6 PUSH [tag] 69
 O: PUSH [tag] 68 DUP5 DUP3 DUP6 PUSH [tag] 69
*)
Example BottleCastle_initial_block_49_0: equiv_checker [PUSH 1 (natToWord WLen 68);DUP 5;DUP 3;DUP 6;PUSH 1 (natToWord WLen 69)] [PUSH 1 (natToWord WLen 68);DUP 5;DUP 3;DUP 6;PUSH 1 (natToWord WLen 69)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP4 SWAP3 POP POP POP
 O: POP SWAP4 SWAP3 POP POP POP
*)
Example BottleCastle_initial_block_50_0: equiv_checker [POP;DUP 4;DUP 3;POP;POP;POP] [POP;DUP 4;DUP 3;POP;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 72
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 72
*)
Example BottleCastle_initial_block_51_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 3;DUP 3;PUSH 1 (natToWord WLen 31);Opcode ADD;Opcode SLT;PUSH 1 (natToWord WLen 72)] [PUSH 1 (natToWord WLen 0);DUP 3;PUSH 1 (natToWord WLen 31);DUP 4;Opcode ADD;Opcode SLT;PUSH 1 (natToWord WLen 72)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 73 PUSH [tag] 74
 O: PUSH [tag] 73 PUSH [tag] 74
*)
Example BottleCastle_initial_block_52_0: equiv_checker [PUSH 1 (natToWord WLen 73);PUSH 1 (natToWord WLen 74)] [PUSH 1 (natToWord WLen 73);PUSH 1 (natToWord WLen 74)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 MLOAD PUSH [tag] 75 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 59
 O: DUP2 MLOAD PUSH [tag] 75 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 59
*)
Example BottleCastle_initial_block_54_0: equiv_checker [DUP 2;Opcode MLOAD;PUSH 1 (natToWord WLen 75);DUP 5;DUP 3;PUSH 1 (natToWord WLen 32);DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 59)] [DUP 2;Opcode MLOAD;PUSH 1 (natToWord WLen 75);DUP 5;DUP 3;PUSH 1 (natToWord WLen 32);DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 59)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Example BottleCastle_initial_block_55_0: equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 77
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 77
*)
Example BottleCastle_initial_block_56_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 64);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (natToWord WLen 77)] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 64);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (natToWord WLen 77)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 78 PUSH [tag] 79
 O: PUSH [tag] 78 PUSH [tag] 79
*)
Example BottleCastle_initial_block_57_0: equiv_checker [PUSH 1 (natToWord WLen 78);PUSH 1 (natToWord WLen 79)] [PUSH 1 (natToWord WLen 78);PUSH 1 (natToWord WLen 79)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP4 ADD MLOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 80
 O: DUP3 PUSH 0 ADD MLOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 80
*)
Example BottleCastle_initial_block_59_0: equiv_checker [DUP 3;PUSH 1 (natToWord WLen 0);Opcode ADD;Opcode MLOAD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 80)] [PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD;Opcode MLOAD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 80)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 81 PUSH [tag] 82
 O: PUSH [tag] 81 PUSH [tag] 82
*)
Example BottleCastle_initial_block_60_0: equiv_checker [PUSH 1 (natToWord WLen 81);PUSH 1 (natToWord WLen 82)] [PUSH 1 (natToWord WLen 81);PUSH 1 (natToWord WLen 82)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 83 DUP6 DUP3 DUP7 ADD PUSH [tag] 70
 O: PUSH [tag] 83 DUP6 DUP3 DUP7 ADD PUSH [tag] 70
*)
Example BottleCastle_initial_block_62_0: equiv_checker [PUSH 1 (natToWord WLen 83);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 70)] [PUSH 1 (natToWord WLen 83);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 70)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP POP PUSH 20 DUP4 ADD MLOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 84
 O: SWAP3 POP POP DUP3 PUSH 20 ADD MLOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 84
*)
Example BottleCastle_initial_block_63_0: equiv_checker [DUP 3;POP;POP;DUP 3;PUSH 1 (natToWord WLen 32);Opcode ADD;Opcode MLOAD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 84)] [DUP 3;POP;POP;PUSH 1 (natToWord WLen 32);DUP 4;Opcode ADD;Opcode MLOAD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 84)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 85 PUSH [tag] 82
 O: PUSH [tag] 85 PUSH [tag] 82
*)
Example BottleCastle_initial_block_64_0: equiv_checker [PUSH 1 (natToWord WLen 85);PUSH 1 (natToWord WLen 82)] [PUSH 1 (natToWord WLen 85);PUSH 1 (natToWord WLen 82)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 86 DUP6 DUP3 DUP7 ADD PUSH [tag] 70
 O: PUSH [tag] 86 DUP6 DUP3 DUP7 ADD PUSH [tag] 70
*)
Example BottleCastle_initial_block_66_0: equiv_checker [PUSH 1 (natToWord WLen 86);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 70)] [PUSH 1 (natToWord WLen 86);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 70)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Example BottleCastle_initial_block_67_0: equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 89 PUSH 20 DUP4 PUSH [tag] 90
 O: PUSH 0 PUSH [tag] 89 PUSH 20 DUP4 PUSH [tag] 90
*)
Example BottleCastle_initial_block_68_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 89);PUSH 1 (natToWord WLen 32);DUP 4;PUSH 1 (natToWord WLen 90)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 89);PUSH 1 (natToWord WLen 32);DUP 4;PUSH 1 (natToWord WLen 90)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 91 DUP3 PUSH [tag] 92
 O: SWAP2 POP PUSH [tag] 91 DUP3 PUSH [tag] 92
*)
Example BottleCastle_initial_block_69_0: equiv_checker [DUP 2;POP;PUSH 1 (natToWord WLen 91);DUP 3;PUSH 1 (natToWord WLen 92)] [DUP 2;POP;PUSH 1 (natToWord WLen 91);DUP 3;PUSH 1 (natToWord WLen 92)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Example BottleCastle_initial_block_70_0: equiv_checker [POP;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Example BottleCastle_initial_block_71_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 94 DUP2 PUSH [tag] 87
 O: PUSH [tag] 94 DUP2 PUSH [tag] 87
*)
Example BottleCastle_initial_block_71_1: equiv_checker [PUSH 1 (natToWord WLen 94);DUP 2;PUSH 1 (natToWord WLen 87)] [PUSH 1 (natToWord WLen 94);DUP 2;PUSH 1 (natToWord WLen 87)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example BottleCastle_initial_block_72_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 96 PUSH [tag] 97
 O: PUSH 0 PUSH [tag] 96 PUSH [tag] 97
*)
Example BottleCastle_initial_block_73_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 97)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 97)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP PUSH [tag] 98 DUP3 DUP3 PUSH [tag] 99
 O: SWAP1 POP PUSH [tag] 98 DUP3 DUP3 PUSH [tag] 99
*)
Example BottleCastle_initial_block_74_0: equiv_checker [DUP 1;POP;PUSH 1 (natToWord WLen 98);DUP 3;DUP 3;PUSH 1 (natToWord WLen 99)] [DUP 1;POP;PUSH 1 (natToWord WLen 98);DUP 3;DUP 3;PUSH 1 (natToWord WLen 99)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Example BottleCastle_initial_block_75_0: equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 40 MLOAD SWAP1 POP SWAP1
 O: PUSH 40 MLOAD SWAP1
*)
Example BottleCastle_initial_block_76_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;POP;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFF DUP3 GT ISZERO PUSH [tag] 102
 O: PUSH 0 PUSH ffffffffffffffff DUP3 GT ISZERO PUSH [tag] 102
*)
Example BottleCastle_initial_block_77_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 8 (natToWord WLen 18446744073709551615);DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 102)] [PUSH 1 (natToWord WLen 0);PUSH 8 (natToWord WLen 18446744073709551615);DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 102)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 103 PUSH [tag] 104
 O: PUSH [tag] 103 PUSH [tag] 104
*)
Example BottleCastle_initial_block_78_0: equiv_checker [PUSH 1 (natToWord WLen 103);PUSH 1 (natToWord WLen 104)] [PUSH 1 (natToWord WLen 103);PUSH 1 (natToWord WLen 104)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 105 DUP3 PUSH [tag] 106
 O: PUSH [tag] 105 DUP3 PUSH [tag] 106
*)
Example BottleCastle_initial_block_80_0: equiv_checker [PUSH 1 (natToWord WLen 105);DUP 3;PUSH 1 (natToWord WLen 106)] [PUSH 1 (natToWord WLen 105);DUP 3;PUSH 1 (natToWord WLen 106)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP PUSH 20 DUP2 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP2 POP POP SWAP1
*)
Example BottleCastle_initial_block_81_0: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;POP;POP;DUP 1] [DUP 1;POP;PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP3 DUP3
 O: PUSH 0 DUP3 DUP3
*)
Example BottleCastle_initial_block_82_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 3;DUP 3] [PUSH 1 (natToWord WLen 0);DUP 3;DUP 3] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP PUSH 20 SWAP2 POP ADD SWAP1
*)
Example BottleCastle_initial_block_82_1: equiv_checker [POP;PUSH 1 (natToWord WLen 32);DUP 2;POP;Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0
 O: PUSH 0
*)
Example BottleCastle_initial_block_83_0: equiv_checker [PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP4 DUP2 LT ISZERO PUSH [tag] 111
 O: DUP4 DUP2 LT ISZERO PUSH [tag] 111
*)
Example BottleCastle_initial_block_84_0: equiv_checker [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 1 (natToWord WLen 111)] [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 1 (natToWord WLen 111)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD
 O: DUP2 DUP2 ADD MLOAD DUP4 DUP3 ADD
*)
Example BottleCastle_initial_block_85_0: equiv_checker [DUP 2;DUP 2;Opcode ADD;Opcode MLOAD;DUP 4;DUP 3;Opcode ADD] [DUP 1;DUP 3;Opcode ADD;Opcode MLOAD;DUP 2;DUP 5;Opcode ADD] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP2 ADD SWAP1 POP PUSH [tag] 109
 O: PUSH 20 ADD PUSH [tag] 109
*)
Example BottleCastle_initial_block_85_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 109)] [PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;DUP 1;POP;PUSH 1 (natToWord WLen 109)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP4 DUP2 GT ISZERO PUSH [tag] 112
 O: DUP4 DUP2 GT ISZERO PUSH [tag] 112
*)
Example BottleCastle_initial_block_86_0: equiv_checker [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 112)] [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 112)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP5 DUP5 ADD
 O: PUSH 0 DUP4 DUP6 ADD
*)
Example BottleCastle_initial_block_87_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 4;DUP 6;Opcode ADD] [PUSH 1 (natToWord WLen 0);DUP 5;DUP 5;Opcode ADD] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Example BottleCastle_initial_block_88_0: equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 2 DUP3 DIV SWAP1 POP PUSH 1 DUP3 AND DUP1 PUSH [tag] 114
 O: PUSH 2 DUP2 DIV DUP2 PUSH 1 AND DUP1 PUSH [tag] 114
*)
Example BottleCastle_initial_block_89_0: equiv_checker [PUSH 1 (natToWord WLen 2);DUP 2;Opcode DIV;DUP 2;PUSH 1 (natToWord WLen 1);Opcode AND;DUP 1;PUSH 1 (natToWord WLen 114)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 2);DUP 3;Opcode DIV;DUP 1;POP;PUSH 1 (natToWord WLen 1);DUP 3;Opcode AND;DUP 1;PUSH 1 (natToWord WLen 114)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 7F DUP3 AND SWAP2 POP
 O: SWAP1 PUSH 7f AND SWAP1
*)
Example BottleCastle_initial_block_90_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 127);Opcode AND;DUP 1] [PUSH 1 (natToWord WLen 127);DUP 3;Opcode AND;DUP 2;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 LT DUP2 EQ ISZERO PUSH [tag] 115
 O: DUP1 PUSH 20 DUP4 LT EQ ISZERO PUSH [tag] 115
*)
Example BottleCastle_initial_block_91_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);DUP 4;Opcode LT;Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 115)] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode LT;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 115)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 116 PUSH [tag] 117
 O: PUSH [tag] 116 PUSH [tag] 117
*)
Example BottleCastle_initial_block_92_0: equiv_checker [PUSH 1 (natToWord WLen 116);PUSH 1 (natToWord WLen 117)] [PUSH 1 (natToWord WLen 116);PUSH 1 (natToWord WLen 117)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP2 SWAP1 POP
 O: POP SWAP2 SWAP1 POP
*)
Example BottleCastle_initial_block_94_0: equiv_checker [POP;DUP 2;DUP 1;POP] [POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 119 DUP3 PUSH [tag] 106
 O: PUSH [tag] 119 DUP3 PUSH [tag] 106
*)
Example BottleCastle_initial_block_95_0: equiv_checker [PUSH 1 (natToWord WLen 119);DUP 3;PUSH 1 (natToWord WLen 106)] [PUSH 1 (natToWord WLen 119);DUP 3;PUSH 1 (natToWord WLen 106)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 ADD DUP2 DUP2 LT PUSH FFFFFFFFFFFFFFFF DUP3 GT OR ISZERO PUSH [tag] 120
 O: DUP2 ADD PUSH ffffffffffffffff DUP2 GT DUP3 DUP3 LT OR ISZERO PUSH [tag] 120
*)
Example BottleCastle_initial_block_96_0: equiv_checker [DUP 2;Opcode ADD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;DUP 3;DUP 3;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 1 (natToWord WLen 120)] [DUP 2;Opcode ADD;DUP 2;DUP 2;Opcode LT;PUSH 8 (natToWord WLen 18446744073709551615);DUP 3;Opcode GT;Opcode OR;Opcode ISZERO;PUSH 1 (natToWord WLen 120)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 121 PUSH [tag] 104
 O: PUSH [tag] 121 PUSH [tag] 104
*)
Example BottleCastle_initial_block_97_0: equiv_checker [PUSH 1 (natToWord WLen 121);PUSH 1 (natToWord WLen 104)] [PUSH 1 (natToWord WLen 121);PUSH 1 (natToWord WLen 104)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 40
 O: DUP1 PUSH 40
*)
Example BottleCastle_initial_block_99_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 64)] [DUP 1;PUSH 1 (natToWord WLen 64)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP
 O: POP POP POP
*)
Example BottleCastle_initial_block_99_1: equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Example BottleCastle_initial_block_100_0: equiv_checker [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 22 PUSH 4
 O: PUSH 22 PUSH 4
*)
Example BottleCastle_initial_block_100_1: equiv_checker [PUSH 1 (natToWord WLen 34);PUSH 1 (natToWord WLen 4)] [PUSH 1 (natToWord WLen 34);PUSH 1 (natToWord WLen 4)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Example BottleCastle_initial_block_100_2: equiv_checker [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Example BottleCastle_initial_block_101_0: equiv_checker [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 41 PUSH 4
 O: PUSH 41 PUSH 4
*)
Example BottleCastle_initial_block_101_1: equiv_checker [PUSH 1 (natToWord WLen 65);PUSH 1 (natToWord WLen 4)] [PUSH 1 (natToWord WLen 65);PUSH 1 (natToWord WLen 4)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Example BottleCastle_initial_block_101_2: equiv_checker [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_initial_block_102_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_initial_block_103_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_initial_block_104_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_initial_block_105_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 1F NOT PUSH 1F DUP4 ADD AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 1f ADD PUSH 1f NOT AND SWAP1
*)
Example BottleCastle_initial_block_106_0: equiv_checker [PUSH 1 (natToWord WLen 31);Opcode ADD;PUSH 1 (natToWord WLen 31);Opcode NOT;Opcode AND;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 31);Opcode NOT;PUSH 1 (natToWord WLen 31);DUP 4;Opcode ADD;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4F776E61626C653A2063616C6C6572206973206E6F7420746865206F776E6572 PUSH 0 DUP3 ADD
 O: PUSH 4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572 DUP2 PUSH 0 ADD
*)
Example BottleCastle_initial_block_107_0: equiv_checker [PUSH 32 (natToWord WLen 35943731656364841964516503116990081338611484598491072354577564874054038349170);DUP 2;PUSH 1 (natToWord WLen 0);Opcode ADD] [PUSH 32 (natToWord WLen 35943731656364841964516503116990081338611484598491072354577564874054038349170);PUSH 1 (natToWord WLen 0);DUP 3;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_initial_block_107_1: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

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
Example BottleCastle_initial_block_108_1: equiv_checker [PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 80 PUSH 40
 O: PUSH 80 PUSH 40
*)
Example BottleCastle_run_code_of_0_block_0_0: equiv_checker [PUSH 1 (natToWord WLen 128);PUSH 1 (natToWord WLen 64)] [PUSH 1 (natToWord WLen 128);PUSH 1 (natToWord WLen 64)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 CALLDATASIZE LT PUSH [tag] 1
 O: PUSH 4 CALLDATASIZE LT PUSH [tag] 1
*)
Example BottleCastle_run_code_of_0_block_0_1: equiv_checker [PUSH 1 (natToWord WLen 4);Opcode CALLDATASIZE;Opcode LT;PUSH 1 (natToWord WLen 1)] [PUSH 1 (natToWord WLen 4);Opcode CALLDATASIZE;Opcode LT;PUSH 1 (natToWord WLen 1)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 CALLDATALOAD PUSH E0 SHR DUP1 PUSH 715018A6 GT PUSH [tag] 39
 O: PUSH 0 CALLDATALOAD PUSH e0 SHR DUP1 PUSH 715018a6 GT PUSH [tag] 39
*)
Example BottleCastle_run_code_of_0_block_1_0: equiv_checker [PUSH 1 (natToWord WLen 0);Opcode CALLDATALOAD;PUSH 1 (natToWord WLen 224);Opcode SHR;DUP 1;PUSH 4 (natToWord WLen 1901074598);Opcode GT;PUSH 1 (natToWord WLen 39)] [PUSH 1 (natToWord WLen 0);Opcode CALLDATALOAD;PUSH 1 (natToWord WLen 224);Opcode SHR;DUP 1;PUSH 4 (natToWord WLen 1901074598);Opcode GT;PUSH 1 (natToWord WLen 39)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH BD7A1998 GT PUSH [tag] 40
 O: DUP1 PUSH bd7a1998 GT PUSH [tag] 40
*)
Example BottleCastle_run_code_of_0_block_2_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 3178895768);Opcode GT;PUSH 1 (natToWord WLen 40)] [DUP 1;PUSH 4 (natToWord WLen 3178895768);Opcode GT;PUSH 1 (natToWord WLen 40)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH DC33E681 GT PUSH [tag] 41
 O: DUP1 PUSH dc33e681 GT PUSH [tag] 41
*)
Example BottleCastle_run_code_of_0_block_3_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 3694388865);Opcode GT;PUSH 1 (natToWord WLen 41)] [DUP 1;PUSH 4 (natToWord WLen 3694388865);Opcode GT;PUSH 1 (natToWord WLen 41)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH DC33E681 EQ PUSH [tag] 34
 O: DUP1 PUSH dc33e681 EQ PUSH [tag] 34
*)
Example BottleCastle_run_code_of_0_block_4_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 3694388865);Opcode EQ;PUSH 1 (natToWord WLen 34)] [DUP 1;PUSH 4 (natToWord WLen 3694388865);Opcode EQ;PUSH 1 (natToWord WLen 34)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH E268E4D3 EQ PUSH [tag] 35
 O: DUP1 PUSH e268e4d3 EQ PUSH [tag] 35
*)
Example BottleCastle_run_code_of_0_block_5_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 3798525139);Opcode EQ;PUSH 1 (natToWord WLen 35)] [DUP 1;PUSH 4 (natToWord WLen 3798525139);Opcode EQ;PUSH 1 (natToWord WLen 35)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH E985E9C5 EQ PUSH [tag] 36
 O: DUP1 PUSH e985e9c5 EQ PUSH [tag] 36
*)
Example BottleCastle_run_code_of_0_block_6_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 3917867461);Opcode EQ;PUSH 1 (natToWord WLen 36)] [DUP 1;PUSH 4 (natToWord WLen 3917867461);Opcode EQ;PUSH 1 (natToWord WLen 36)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH F2C4CE1E EQ PUSH [tag] 37
 O: DUP1 PUSH f2c4ce1e EQ PUSH [tag] 37
*)
Example BottleCastle_run_code_of_0_block_7_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 4072984094);Opcode EQ;PUSH 1 (natToWord WLen 37)] [DUP 1;PUSH 4 (natToWord WLen 4072984094);Opcode EQ;PUSH 1 (natToWord WLen 37)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH F2FDE38B EQ PUSH [tag] 38
 O: DUP1 PUSH f2fde38b EQ PUSH [tag] 38
*)
Example BottleCastle_run_code_of_0_block_8_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 4076725131);Opcode EQ;PUSH 1 (natToWord WLen 38)] [DUP 1;PUSH 4 (natToWord WLen 4076725131);Opcode EQ;PUSH 1 (natToWord WLen 38)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 1
 O: PUSH [tag] 1
*)
Example BottleCastle_run_code_of_0_block_9_0: equiv_checker [PUSH 1 (natToWord WLen 1)] [PUSH 1 (natToWord WLen 1)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH BD7A1998 EQ PUSH [tag] 29
 O: DUP1 PUSH bd7a1998 EQ PUSH [tag] 29
*)
Example BottleCastle_run_code_of_0_block_10_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 3178895768);Opcode EQ;PUSH 1 (natToWord WLen 29)] [DUP 1;PUSH 4 (natToWord WLen 3178895768);Opcode EQ;PUSH 1 (natToWord WLen 29)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH C6682862 EQ PUSH [tag] 30
 O: DUP1 PUSH c6682862 EQ PUSH [tag] 30
*)
Example BottleCastle_run_code_of_0_block_11_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 3328714850);Opcode EQ;PUSH 1 (natToWord WLen 30)] [DUP 1;PUSH 4 (natToWord WLen 3328714850);Opcode EQ;PUSH 1 (natToWord WLen 30)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH C87B56DD EQ PUSH [tag] 31
 O: DUP1 PUSH c87b56dd EQ PUSH [tag] 31
*)
Example BottleCastle_run_code_of_0_block_12_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 3363526365);Opcode EQ;PUSH 1 (natToWord WLen 31)] [DUP 1;PUSH 4 (natToWord WLen 3363526365);Opcode EQ;PUSH 1 (natToWord WLen 31)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH D5ABEB01 EQ PUSH [tag] 32
 O: DUP1 PUSH d5abeb01 EQ PUSH [tag] 32
*)
Example BottleCastle_run_code_of_0_block_13_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 3584813825);Opcode EQ;PUSH 1 (natToWord WLen 32)] [DUP 1;PUSH 4 (natToWord WLen 3584813825);Opcode EQ;PUSH 1 (natToWord WLen 32)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH DA3EF23F EQ PUSH [tag] 33
 O: DUP1 PUSH da3ef23f EQ PUSH [tag] 33
*)
Example BottleCastle_run_code_of_0_block_14_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 3661558335);Opcode EQ;PUSH 1 (natToWord WLen 33)] [DUP 1;PUSH 4 (natToWord WLen 3661558335);Opcode EQ;PUSH 1 (natToWord WLen 33)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 1
 O: PUSH [tag] 1
*)
Example BottleCastle_run_code_of_0_block_15_0: equiv_checker [PUSH 1 (natToWord WLen 1)] [PUSH 1 (natToWord WLen 1)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 95D89B41 GT PUSH [tag] 42
 O: DUP1 PUSH 95d89b41 GT PUSH [tag] 42
*)
Example BottleCastle_run_code_of_0_block_16_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 2514000705);Opcode GT;PUSH 1 (natToWord WLen 42)] [DUP 1;PUSH 4 (natToWord WLen 2514000705);Opcode GT;PUSH 1 (natToWord WLen 42)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 95D89B41 EQ PUSH [tag] 24
 O: DUP1 PUSH 95d89b41 EQ PUSH [tag] 24
*)
Example BottleCastle_run_code_of_0_block_17_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 2514000705);Opcode EQ;PUSH 1 (natToWord WLen 24)] [DUP 1;PUSH 4 (natToWord WLen 2514000705);Opcode EQ;PUSH 1 (natToWord WLen 24)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH A0712D68 EQ PUSH [tag] 25
 O: DUP1 PUSH a0712d68 EQ PUSH [tag] 25
*)
Example BottleCastle_run_code_of_0_block_18_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 2691771752);Opcode EQ;PUSH 1 (natToWord WLen 25)] [DUP 1;PUSH 4 (natToWord WLen 2691771752);Opcode EQ;PUSH 1 (natToWord WLen 25)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH A22CB465 EQ PUSH [tag] 26
 O: DUP1 PUSH a22cb465 EQ PUSH [tag] 26
*)
Example BottleCastle_run_code_of_0_block_19_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 2720838757);Opcode EQ;PUSH 1 (natToWord WLen 26)] [DUP 1;PUSH 4 (natToWord WLen 2720838757);Opcode EQ;PUSH 1 (natToWord WLen 26)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH B88D4FDE EQ PUSH [tag] 27
 O: DUP1 PUSH b88d4fde EQ PUSH [tag] 27
*)
Example BottleCastle_run_code_of_0_block_20_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 3096268766);Opcode EQ;PUSH 1 (natToWord WLen 27)] [DUP 1;PUSH 4 (natToWord WLen 3096268766);Opcode EQ;PUSH 1 (natToWord WLen 27)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH BC63F02E EQ PUSH [tag] 28
 O: DUP1 PUSH bc63f02e EQ PUSH [tag] 28
*)
Example BottleCastle_run_code_of_0_block_21_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 3160666158);Opcode EQ;PUSH 1 (natToWord WLen 28)] [DUP 1;PUSH 4 (natToWord WLen 3160666158);Opcode EQ;PUSH 1 (natToWord WLen 28)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 1
 O: PUSH [tag] 1
*)
Example BottleCastle_run_code_of_0_block_22_0: equiv_checker [PUSH 1 (natToWord WLen 1)] [PUSH 1 (natToWord WLen 1)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 715018A6 EQ PUSH [tag] 20
 O: DUP1 PUSH 715018a6 EQ PUSH [tag] 20
*)
Example BottleCastle_run_code_of_0_block_23_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 1901074598);Opcode EQ;PUSH 1 (natToWord WLen 20)] [DUP 1;PUSH 4 (natToWord WLen 1901074598);Opcode EQ;PUSH 1 (natToWord WLen 20)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 8462151C EQ PUSH [tag] 21
 O: DUP1 PUSH 8462151c EQ PUSH [tag] 21
*)
Example BottleCastle_run_code_of_0_block_24_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 2221020444);Opcode EQ;PUSH 1 (natToWord WLen 21)] [DUP 1;PUSH 4 (natToWord WLen 2221020444);Opcode EQ;PUSH 1 (natToWord WLen 21)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 8DA5CB5B EQ PUSH [tag] 22
 O: DUP1 PUSH 8da5cb5b EQ PUSH [tag] 22
*)
Example BottleCastle_run_code_of_0_block_25_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 2376452955);Opcode EQ;PUSH 1 (natToWord WLen 22)] [DUP 1;PUSH 4 (natToWord WLen 2376452955);Opcode EQ;PUSH 1 (natToWord WLen 22)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 940CD05B EQ PUSH [tag] 23
 O: DUP1 PUSH 940cd05b EQ PUSH [tag] 23
*)
Example BottleCastle_run_code_of_0_block_26_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 2483867739);Opcode EQ;PUSH 1 (natToWord WLen 23)] [DUP 1;PUSH 4 (natToWord WLen 2483867739);Opcode EQ;PUSH 1 (natToWord WLen 23)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 1
 O: PUSH [tag] 1
*)
Example BottleCastle_run_code_of_0_block_27_0: equiv_checker [PUSH 1 (natToWord WLen 1)] [PUSH 1 (natToWord WLen 1)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 3CCFD60B GT PUSH [tag] 43
 O: DUP1 PUSH 3ccfd60b GT PUSH [tag] 43
*)
Example BottleCastle_run_code_of_0_block_28_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 1020253707);Opcode GT;PUSH 1 (natToWord WLen 43)] [DUP 1;PUSH 4 (natToWord WLen 1020253707);Opcode GT;PUSH 1 (natToWord WLen 43)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 55F804B3 GT PUSH [tag] 44
 O: DUP1 PUSH 55f804b3 GT PUSH [tag] 44
*)
Example BottleCastle_run_code_of_0_block_29_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 1442317491);Opcode GT;PUSH 1 (natToWord WLen 44)] [DUP 1;PUSH 4 (natToWord WLen 1442317491);Opcode GT;PUSH 1 (natToWord WLen 44)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 55F804B3 EQ PUSH [tag] 15
 O: DUP1 PUSH 55f804b3 EQ PUSH [tag] 15
*)
Example BottleCastle_run_code_of_0_block_30_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 1442317491);Opcode EQ;PUSH 1 (natToWord WLen 15)] [DUP 1;PUSH 4 (natToWord WLen 1442317491);Opcode EQ;PUSH 1 (natToWord WLen 15)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 5C975ABB EQ PUSH [tag] 16
 O: DUP1 PUSH 5c975abb EQ PUSH [tag] 16
*)
Example BottleCastle_run_code_of_0_block_31_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 1553423035);Opcode EQ;PUSH 1 (natToWord WLen 16)] [DUP 1;PUSH 4 (natToWord WLen 1553423035);Opcode EQ;PUSH 1 (natToWord WLen 16)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 6352211E EQ PUSH [tag] 17
 O: DUP1 PUSH 6352211e EQ PUSH [tag] 17
*)
Example BottleCastle_run_code_of_0_block_32_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 1666326814);Opcode EQ;PUSH 1 (natToWord WLen 17)] [DUP 1;PUSH 4 (natToWord WLen 1666326814);Opcode EQ;PUSH 1 (natToWord WLen 17)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 6C0360EB EQ PUSH [tag] 18
 O: DUP1 PUSH 6c0360eb EQ PUSH [tag] 18
*)
Example BottleCastle_run_code_of_0_block_33_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 1812160747);Opcode EQ;PUSH 1 (natToWord WLen 18)] [DUP 1;PUSH 4 (natToWord WLen 1812160747);Opcode EQ;PUSH 1 (natToWord WLen 18)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 70A08231 EQ PUSH [tag] 19
 O: DUP1 PUSH 70a08231 EQ PUSH [tag] 19
*)
Example BottleCastle_run_code_of_0_block_34_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 1889567281);Opcode EQ;PUSH 1 (natToWord WLen 19)] [DUP 1;PUSH 4 (natToWord WLen 1889567281);Opcode EQ;PUSH 1 (natToWord WLen 19)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 1
 O: PUSH [tag] 1
*)
Example BottleCastle_run_code_of_0_block_35_0: equiv_checker [PUSH 1 (natToWord WLen 1)] [PUSH 1 (natToWord WLen 1)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 3CCFD60B EQ PUSH [tag] 11
 O: DUP1 PUSH 3ccfd60b EQ PUSH [tag] 11
*)
Example BottleCastle_run_code_of_0_block_36_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 1020253707);Opcode EQ;PUSH 1 (natToWord WLen 11)] [DUP 1;PUSH 4 (natToWord WLen 1020253707);Opcode EQ;PUSH 1 (natToWord WLen 11)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 42842E0E EQ PUSH [tag] 12
 O: DUP1 PUSH 42842e0e EQ PUSH [tag] 12
*)
Example BottleCastle_run_code_of_0_block_37_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 1115958798);Opcode EQ;PUSH 1 (natToWord WLen 12)] [DUP 1;PUSH 4 (natToWord WLen 1115958798);Opcode EQ;PUSH 1 (natToWord WLen 12)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 44A0D68A EQ PUSH [tag] 13
 O: DUP1 PUSH 44a0d68a EQ PUSH [tag] 13
*)
Example BottleCastle_run_code_of_0_block_38_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 1151391370);Opcode EQ;PUSH 1 (natToWord WLen 13)] [DUP 1;PUSH 4 (natToWord WLen 1151391370);Opcode EQ;PUSH 1 (natToWord WLen 13)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 51830227 EQ PUSH [tag] 14
 O: DUP1 PUSH 51830227 EQ PUSH [tag] 14
*)
Example BottleCastle_run_code_of_0_block_39_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 1367540263);Opcode EQ;PUSH 1 (natToWord WLen 14)] [DUP 1;PUSH 4 (natToWord WLen 1367540263);Opcode EQ;PUSH 1 (natToWord WLen 14)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 1
 O: PUSH [tag] 1
*)
Example BottleCastle_run_code_of_0_block_40_0: equiv_checker [PUSH 1 (natToWord WLen 1)] [PUSH 1 (natToWord WLen 1)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 81C8C44 GT PUSH [tag] 45
 O: DUP1 PUSH 81c8c44 GT PUSH [tag] 45
*)
Example BottleCastle_run_code_of_0_block_41_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 136088644);Opcode GT;PUSH 1 (natToWord WLen 45)] [DUP 1;PUSH 4 (natToWord WLen 136088644);Opcode GT;PUSH 1 (natToWord WLen 45)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 81C8C44 EQ PUSH [tag] 6
 O: DUP1 PUSH 81c8c44 EQ PUSH [tag] 6
*)
Example BottleCastle_run_code_of_0_block_42_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 136088644);Opcode EQ;PUSH 1 (natToWord WLen 6)] [DUP 1;PUSH 4 (natToWord WLen 136088644);Opcode EQ;PUSH 1 (natToWord WLen 6)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 95EA7B3 EQ PUSH [tag] 7
 O: DUP1 PUSH 95ea7b3 EQ PUSH [tag] 7
*)
Example BottleCastle_run_code_of_0_block_43_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 157198259);Opcode EQ;PUSH 1 (natToWord WLen 7)] [DUP 1;PUSH 4 (natToWord WLen 157198259);Opcode EQ;PUSH 1 (natToWord WLen 7)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 13FAEDE6 EQ PUSH [tag] 8
 O: DUP1 PUSH 13faede6 EQ PUSH [tag] 8
*)
Example BottleCastle_run_code_of_0_block_44_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 335212006);Opcode EQ;PUSH 1 (natToWord WLen 8)] [DUP 1;PUSH 4 (natToWord WLen 335212006);Opcode EQ;PUSH 1 (natToWord WLen 8)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 18160DDD EQ PUSH [tag] 9
 O: DUP1 PUSH 18160ddd EQ PUSH [tag] 9
*)
Example BottleCastle_run_code_of_0_block_45_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 404098525);Opcode EQ;PUSH 1 (natToWord WLen 9)] [DUP 1;PUSH 4 (natToWord WLen 404098525);Opcode EQ;PUSH 1 (natToWord WLen 9)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 23B872DD EQ PUSH [tag] 10
 O: DUP1 PUSH 23b872dd EQ PUSH [tag] 10
*)
Example BottleCastle_run_code_of_0_block_46_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 599290589);Opcode EQ;PUSH 1 (natToWord WLen 10)] [DUP 1;PUSH 4 (natToWord WLen 599290589);Opcode EQ;PUSH 1 (natToWord WLen 10)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 1
 O: PUSH [tag] 1
*)
Example BottleCastle_run_code_of_0_block_47_0: equiv_checker [PUSH 1 (natToWord WLen 1)] [PUSH 1 (natToWord WLen 1)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1FFC9A7 EQ PUSH [tag] 2
 O: DUP1 PUSH 1ffc9a7 EQ PUSH [tag] 2
*)
Example BottleCastle_run_code_of_0_block_48_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 33540519);Opcode EQ;PUSH 1 (natToWord WLen 2)] [DUP 1;PUSH 4 (natToWord WLen 33540519);Opcode EQ;PUSH 1 (natToWord WLen 2)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 2329A29 EQ PUSH [tag] 3
 O: DUP1 PUSH 2329a29 EQ PUSH [tag] 3
*)
Example BottleCastle_run_code_of_0_block_49_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 36870697);Opcode EQ;PUSH 1 (natToWord WLen 3)] [DUP 1;PUSH 4 (natToWord WLen 36870697);Opcode EQ;PUSH 1 (natToWord WLen 3)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 6FDDE03 EQ PUSH [tag] 4
 O: DUP1 PUSH 6fdde03 EQ PUSH [tag] 4
*)
Example BottleCastle_run_code_of_0_block_50_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 117300739);Opcode EQ;PUSH 1 (natToWord WLen 4)] [DUP 1;PUSH 4 (natToWord WLen 117300739);Opcode EQ;PUSH 1 (natToWord WLen 4)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 81812FC EQ PUSH [tag] 5
 O: DUP1 PUSH 81812fc EQ PUSH [tag] 5
*)
Example BottleCastle_run_code_of_0_block_51_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 135795452);Opcode EQ;PUSH 1 (natToWord WLen 5)] [DUP 1;PUSH 4 (natToWord WLen 135795452);Opcode EQ;PUSH 1 (natToWord WLen 5)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_52_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 46
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 46
*)
Example BottleCastle_run_code_of_0_block_53_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 46)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 46)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_54_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 47 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 48 SWAP2 SWAP1 PUSH [tag] 49
 O: POP PUSH [tag] 47 PUSH [tag] 48 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 49
*)
Example BottleCastle_run_code_of_0_block_55_0: equiv_checker [POP;PUSH 1 (natToWord WLen 47);PUSH 1 (natToWord WLen 48);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 49)] [POP;PUSH 1 (natToWord WLen 47);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 48);DUP 2;DUP 1;PUSH 1 (natToWord WLen 49)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 50
 O: PUSH [tag] 50
*)
Example BottleCastle_run_code_of_0_block_56_0: equiv_checker [PUSH 1 (natToWord WLen 50)] [PUSH 1 (natToWord WLen 50)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 51 SWAP2 SWAP1 PUSH [tag] 52
 O: PUSH [tag] 51 SWAP1 PUSH 40 MLOAD PUSH [tag] 52
*)
Example BottleCastle_run_code_of_0_block_57_0: equiv_checker [PUSH 1 (natToWord WLen 51);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 52)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 51);DUP 2;DUP 1;PUSH 1 (natToWord WLen 52)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_58_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 53
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 53
*)
Example BottleCastle_run_code_of_0_block_59_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 53)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 53)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_60_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 54 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 55 SWAP2 SWAP1 PUSH [tag] 56
 O: POP PUSH [tag] 54 PUSH [tag] 55 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 56
*)
Example BottleCastle_run_code_of_0_block_61_0: equiv_checker [POP;PUSH 1 (natToWord WLen 54);PUSH 1 (natToWord WLen 55);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 56)] [POP;PUSH 1 (natToWord WLen 54);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 55);DUP 2;DUP 1;PUSH 1 (natToWord WLen 56)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 57
 O: PUSH [tag] 57
*)
Example BottleCastle_run_code_of_0_block_62_0: equiv_checker [PUSH 1 (natToWord WLen 57)] [PUSH 1 (natToWord WLen 57)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 58
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 58
*)
Example BottleCastle_run_code_of_0_block_64_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 58)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 58)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_65_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 59 PUSH [tag] 60
 O: POP PUSH [tag] 59 PUSH [tag] 60
*)
Example BottleCastle_run_code_of_0_block_66_0: equiv_checker [POP;PUSH 1 (natToWord WLen 59);PUSH 1 (natToWord WLen 60)] [POP;PUSH 1 (natToWord WLen 59);PUSH 1 (natToWord WLen 60)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 61 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 61 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Example BottleCastle_run_code_of_0_block_67_0: equiv_checker [PUSH 1 (natToWord WLen 61);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 62)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 61);DUP 2;DUP 1;PUSH 1 (natToWord WLen 62)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_68_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 63
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 63
*)
Example BottleCastle_run_code_of_0_block_69_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 63)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 63)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_70_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 64 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 65 SWAP2 SWAP1 PUSH [tag] 66
 O: POP PUSH [tag] 64 PUSH [tag] 65 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 66
*)
Example BottleCastle_run_code_of_0_block_71_0: equiv_checker [POP;PUSH 1 (natToWord WLen 64);PUSH 1 (natToWord WLen 65);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 66)] [POP;PUSH 1 (natToWord WLen 64);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 65);DUP 2;DUP 1;PUSH 1 (natToWord WLen 66)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 67
 O: PUSH [tag] 67
*)
Example BottleCastle_run_code_of_0_block_72_0: equiv_checker [PUSH 1 (natToWord WLen 67)] [PUSH 1 (natToWord WLen 67)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 68 SWAP2 SWAP1 PUSH [tag] 69
 O: PUSH [tag] 68 SWAP1 PUSH 40 MLOAD PUSH [tag] 69
*)
Example BottleCastle_run_code_of_0_block_73_0: equiv_checker [PUSH 1 (natToWord WLen 68);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 69)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 68);DUP 2;DUP 1;PUSH 1 (natToWord WLen 69)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_74_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 70
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 70
*)
Example BottleCastle_run_code_of_0_block_75_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 70)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 70)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_76_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 71 PUSH [tag] 72
 O: POP PUSH [tag] 71 PUSH [tag] 72
*)
Example BottleCastle_run_code_of_0_block_77_0: equiv_checker [POP;PUSH 1 (natToWord WLen 71);PUSH 1 (natToWord WLen 72)] [POP;PUSH 1 (natToWord WLen 71);PUSH 1 (natToWord WLen 72)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 73 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 73 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Example BottleCastle_run_code_of_0_block_78_0: equiv_checker [PUSH 1 (natToWord WLen 73);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 62)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 73);DUP 2;DUP 1;PUSH 1 (natToWord WLen 62)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_79_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 74
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 74
*)
Example BottleCastle_run_code_of_0_block_80_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 74)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 74)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_81_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 75 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 76 SWAP2 SWAP1 PUSH [tag] 77
 O: POP PUSH [tag] 75 PUSH [tag] 76 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 77
*)
Example BottleCastle_run_code_of_0_block_82_0: equiv_checker [POP;PUSH 1 (natToWord WLen 75);PUSH 1 (natToWord WLen 76);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 77)] [POP;PUSH 1 (natToWord WLen 75);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 76);DUP 2;DUP 1;PUSH 1 (natToWord WLen 77)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 78
 O: PUSH [tag] 78
*)
Example BottleCastle_run_code_of_0_block_83_0: equiv_checker [PUSH 1 (natToWord WLen 78)] [PUSH 1 (natToWord WLen 78)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 79
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 79
*)
Example BottleCastle_run_code_of_0_block_85_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 79)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 79)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_86_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 80 PUSH [tag] 81
 O: POP PUSH [tag] 80 PUSH [tag] 81
*)
Example BottleCastle_run_code_of_0_block_87_0: equiv_checker [POP;PUSH 1 (natToWord WLen 80);PUSH 1 (natToWord WLen 81)] [POP;PUSH 1 (natToWord WLen 80);PUSH 1 (natToWord WLen 81)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 82 SWAP2 SWAP1 PUSH [tag] 83
 O: PUSH [tag] 82 SWAP1 PUSH 40 MLOAD PUSH [tag] 83
*)
Example BottleCastle_run_code_of_0_block_88_0: equiv_checker [PUSH 1 (natToWord WLen 82);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 83)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 82);DUP 2;DUP 1;PUSH 1 (natToWord WLen 83)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_89_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 84
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 84
*)
Example BottleCastle_run_code_of_0_block_90_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 84)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 84)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_91_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 85 PUSH [tag] 86
 O: POP PUSH [tag] 85 PUSH [tag] 86
*)
Example BottleCastle_run_code_of_0_block_92_0: equiv_checker [POP;PUSH 1 (natToWord WLen 85);PUSH 1 (natToWord WLen 86)] [POP;PUSH 1 (natToWord WLen 85);PUSH 1 (natToWord WLen 86)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 87 SWAP2 SWAP1 PUSH [tag] 83
 O: PUSH [tag] 87 SWAP1 PUSH 40 MLOAD PUSH [tag] 83
*)
Example BottleCastle_run_code_of_0_block_93_0: equiv_checker [PUSH 1 (natToWord WLen 87);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 83)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 87);DUP 2;DUP 1;PUSH 1 (natToWord WLen 83)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_94_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 88
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 88
*)
Example BottleCastle_run_code_of_0_block_95_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 88)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 88)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_96_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 89 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 90 SWAP2 SWAP1 PUSH [tag] 91
 O: POP PUSH [tag] 89 PUSH [tag] 90 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 91
*)
Example BottleCastle_run_code_of_0_block_97_0: equiv_checker [POP;PUSH 1 (natToWord WLen 89);PUSH 1 (natToWord WLen 90);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 91)] [POP;PUSH 1 (natToWord WLen 89);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 90);DUP 2;DUP 1;PUSH 1 (natToWord WLen 91)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 92
 O: PUSH [tag] 92
*)
Example BottleCastle_run_code_of_0_block_98_0: equiv_checker [PUSH 1 (natToWord WLen 92)] [PUSH 1 (natToWord WLen 92)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 93 PUSH [tag] 94
 O: PUSH [tag] 93 PUSH [tag] 94
*)
Example BottleCastle_run_code_of_0_block_100_0: equiv_checker [PUSH 1 (natToWord WLen 93);PUSH 1 (natToWord WLen 94)] [PUSH 1 (natToWord WLen 93);PUSH 1 (natToWord WLen 94)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 95
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 95
*)
Example BottleCastle_run_code_of_0_block_102_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 95)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 95)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_103_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 96 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 97 SWAP2 SWAP1 PUSH [tag] 91
 O: POP PUSH [tag] 96 PUSH [tag] 97 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 91
*)
Example BottleCastle_run_code_of_0_block_104_0: equiv_checker [POP;PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 97);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 91)] [POP;PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 97);DUP 2;DUP 1;PUSH 1 (natToWord WLen 91)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 98
 O: PUSH [tag] 98
*)
Example BottleCastle_run_code_of_0_block_105_0: equiv_checker [PUSH 1 (natToWord WLen 98)] [PUSH 1 (natToWord WLen 98)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 99
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 99
*)
Example BottleCastle_run_code_of_0_block_107_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 99)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 99)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_108_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 100 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 101 SWAP2 SWAP1 PUSH [tag] 66
 O: POP PUSH [tag] 100 PUSH [tag] 101 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 66
*)
Example BottleCastle_run_code_of_0_block_109_0: equiv_checker [POP;PUSH 1 (natToWord WLen 100);PUSH 1 (natToWord WLen 101);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 66)] [POP;PUSH 1 (natToWord WLen 100);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 101);DUP 2;DUP 1;PUSH 1 (natToWord WLen 66)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 102
 O: PUSH [tag] 102
*)
Example BottleCastle_run_code_of_0_block_110_0: equiv_checker [PUSH 1 (natToWord WLen 102)] [PUSH 1 (natToWord WLen 102)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 103
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 103
*)
Example BottleCastle_run_code_of_0_block_112_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 103)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 103)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_113_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 104 PUSH [tag] 105
 O: POP PUSH [tag] 104 PUSH [tag] 105
*)
Example BottleCastle_run_code_of_0_block_114_0: equiv_checker [POP;PUSH 1 (natToWord WLen 104);PUSH 1 (natToWord WLen 105)] [POP;PUSH 1 (natToWord WLen 104);PUSH 1 (natToWord WLen 105)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 106 SWAP2 SWAP1 PUSH [tag] 52
 O: PUSH [tag] 106 SWAP1 PUSH 40 MLOAD PUSH [tag] 52
*)
Example BottleCastle_run_code_of_0_block_115_0: equiv_checker [PUSH 1 (natToWord WLen 106);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 52)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 106);DUP 2;DUP 1;PUSH 1 (natToWord WLen 52)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_116_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 107
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 107
*)
Example BottleCastle_run_code_of_0_block_117_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 107)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 107)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_118_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 108 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 109 SWAP2 SWAP1 PUSH [tag] 110
 O: POP PUSH [tag] 108 PUSH [tag] 109 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 110
*)
Example BottleCastle_run_code_of_0_block_119_0: equiv_checker [POP;PUSH 1 (natToWord WLen 108);PUSH 1 (natToWord WLen 109);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 110)] [POP;PUSH 1 (natToWord WLen 108);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 109);DUP 2;DUP 1;PUSH 1 (natToWord WLen 110)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 111
 O: PUSH [tag] 111
*)
Example BottleCastle_run_code_of_0_block_120_0: equiv_checker [PUSH 1 (natToWord WLen 111)] [PUSH 1 (natToWord WLen 111)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 112
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 112
*)
Example BottleCastle_run_code_of_0_block_122_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 112)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 112)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_123_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 113 PUSH [tag] 114
 O: POP PUSH [tag] 113 PUSH [tag] 114
*)
Example BottleCastle_run_code_of_0_block_124_0: equiv_checker [POP;PUSH 1 (natToWord WLen 113);PUSH 1 (natToWord WLen 114)] [POP;PUSH 1 (natToWord WLen 113);PUSH 1 (natToWord WLen 114)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 115 SWAP2 SWAP1 PUSH [tag] 52
 O: PUSH [tag] 115 SWAP1 PUSH 40 MLOAD PUSH [tag] 52
*)
Example BottleCastle_run_code_of_0_block_125_0: equiv_checker [PUSH 1 (natToWord WLen 115);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 52)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 115);DUP 2;DUP 1;PUSH 1 (natToWord WLen 52)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_126_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 116
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 116
*)
Example BottleCastle_run_code_of_0_block_127_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 116)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 116)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_128_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 117 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 118 SWAP2 SWAP1 PUSH [tag] 66
 O: POP PUSH [tag] 117 PUSH [tag] 118 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 66
*)
Example BottleCastle_run_code_of_0_block_129_0: equiv_checker [POP;PUSH 1 (natToWord WLen 117);PUSH 1 (natToWord WLen 118);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 66)] [POP;PUSH 1 (natToWord WLen 117);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 118);DUP 2;DUP 1;PUSH 1 (natToWord WLen 66)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 119
 O: PUSH [tag] 119
*)
Example BottleCastle_run_code_of_0_block_130_0: equiv_checker [PUSH 1 (natToWord WLen 119)] [PUSH 1 (natToWord WLen 119)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 120 SWAP2 SWAP1 PUSH [tag] 69
 O: PUSH [tag] 120 SWAP1 PUSH 40 MLOAD PUSH [tag] 69
*)
Example BottleCastle_run_code_of_0_block_131_0: equiv_checker [PUSH 1 (natToWord WLen 120);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 69)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 120);DUP 2;DUP 1;PUSH 1 (natToWord WLen 69)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_132_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 121
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 121
*)
Example BottleCastle_run_code_of_0_block_133_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 121)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 121)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_134_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 122 PUSH [tag] 123
 O: POP PUSH [tag] 122 PUSH [tag] 123
*)
Example BottleCastle_run_code_of_0_block_135_0: equiv_checker [POP;PUSH 1 (natToWord WLen 122);PUSH 1 (natToWord WLen 123)] [POP;PUSH 1 (natToWord WLen 122);PUSH 1 (natToWord WLen 123)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 124 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 124 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Example BottleCastle_run_code_of_0_block_136_0: equiv_checker [PUSH 1 (natToWord WLen 124);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 62)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 124);DUP 2;DUP 1;PUSH 1 (natToWord WLen 62)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_137_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 125
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 125
*)
Example BottleCastle_run_code_of_0_block_138_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 125)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 125)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_139_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 126 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 127 SWAP2 SWAP1 PUSH [tag] 128
 O: POP PUSH [tag] 126 PUSH [tag] 127 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 128
*)
Example BottleCastle_run_code_of_0_block_140_0: equiv_checker [POP;PUSH 1 (natToWord WLen 126);PUSH 1 (natToWord WLen 127);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 128)] [POP;PUSH 1 (natToWord WLen 126);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 127);DUP 2;DUP 1;PUSH 1 (natToWord WLen 128)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 129
 O: PUSH [tag] 129
*)
Example BottleCastle_run_code_of_0_block_141_0: equiv_checker [PUSH 1 (natToWord WLen 129)] [PUSH 1 (natToWord WLen 129)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 130 SWAP2 SWAP1 PUSH [tag] 83
 O: PUSH [tag] 130 SWAP1 PUSH 40 MLOAD PUSH [tag] 83
*)
Example BottleCastle_run_code_of_0_block_142_0: equiv_checker [PUSH 1 (natToWord WLen 130);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 83)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 130);DUP 2;DUP 1;PUSH 1 (natToWord WLen 83)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_143_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 131
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 131
*)
Example BottleCastle_run_code_of_0_block_144_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 131)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 131)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_145_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 132 PUSH [tag] 133
 O: POP PUSH [tag] 132 PUSH [tag] 133
*)
Example BottleCastle_run_code_of_0_block_146_0: equiv_checker [POP;PUSH 1 (natToWord WLen 132);PUSH 1 (natToWord WLen 133)] [POP;PUSH 1 (natToWord WLen 132);PUSH 1 (natToWord WLen 133)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 134
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 134
*)
Example BottleCastle_run_code_of_0_block_148_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 134)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 134)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_149_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 135 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 136 SWAP2 SWAP1 PUSH [tag] 128
 O: POP PUSH [tag] 135 PUSH [tag] 136 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 128
*)
Example BottleCastle_run_code_of_0_block_150_0: equiv_checker [POP;PUSH 1 (natToWord WLen 135);PUSH 1 (natToWord WLen 136);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 128)] [POP;PUSH 1 (natToWord WLen 135);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 136);DUP 2;DUP 1;PUSH 1 (natToWord WLen 128)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 137
 O: PUSH [tag] 137
*)
Example BottleCastle_run_code_of_0_block_151_0: equiv_checker [PUSH 1 (natToWord WLen 137)] [PUSH 1 (natToWord WLen 137)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 138 SWAP2 SWAP1 PUSH [tag] 139
 O: PUSH [tag] 138 SWAP1 PUSH 40 MLOAD PUSH [tag] 139
*)
Example BottleCastle_run_code_of_0_block_152_0: equiv_checker [PUSH 1 (natToWord WLen 138);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 139)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 138);DUP 2;DUP 1;PUSH 1 (natToWord WLen 139)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_153_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 140
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 140
*)
Example BottleCastle_run_code_of_0_block_154_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 140)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 140)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_155_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 141 PUSH [tag] 142
 O: POP PUSH [tag] 141 PUSH [tag] 142
*)
Example BottleCastle_run_code_of_0_block_156_0: equiv_checker [POP;PUSH 1 (natToWord WLen 141);PUSH 1 (natToWord WLen 142)] [POP;PUSH 1 (natToWord WLen 141);PUSH 1 (natToWord WLen 142)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 143 SWAP2 SWAP1 PUSH [tag] 69
 O: PUSH [tag] 143 SWAP1 PUSH 40 MLOAD PUSH [tag] 69
*)
Example BottleCastle_run_code_of_0_block_157_0: equiv_checker [PUSH 1 (natToWord WLen 143);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 69)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 143);DUP 2;DUP 1;PUSH 1 (natToWord WLen 69)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_158_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 144
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 144
*)
Example BottleCastle_run_code_of_0_block_159_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 144)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 144)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_160_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 145 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 146 SWAP2 SWAP1 PUSH [tag] 56
 O: POP PUSH [tag] 145 PUSH [tag] 146 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 56
*)
Example BottleCastle_run_code_of_0_block_161_0: equiv_checker [POP;PUSH 1 (natToWord WLen 145);PUSH 1 (natToWord WLen 146);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 56)] [POP;PUSH 1 (natToWord WLen 145);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 146);DUP 2;DUP 1;PUSH 1 (natToWord WLen 56)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 147
 O: PUSH [tag] 147
*)
Example BottleCastle_run_code_of_0_block_162_0: equiv_checker [PUSH 1 (natToWord WLen 147)] [PUSH 1 (natToWord WLen 147)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 148
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 148
*)
Example BottleCastle_run_code_of_0_block_164_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 148)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 148)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_165_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 149 PUSH [tag] 150
 O: POP PUSH [tag] 149 PUSH [tag] 150
*)
Example BottleCastle_run_code_of_0_block_166_0: equiv_checker [POP;PUSH 1 (natToWord WLen 149);PUSH 1 (natToWord WLen 150)] [POP;PUSH 1 (natToWord WLen 149);PUSH 1 (natToWord WLen 150)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 151 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 151 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Example BottleCastle_run_code_of_0_block_167_0: equiv_checker [PUSH 1 (natToWord WLen 151);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 62)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 151);DUP 2;DUP 1;PUSH 1 (natToWord WLen 62)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_168_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 152 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 153 SWAP2 SWAP1 PUSH [tag] 66
 O: PUSH [tag] 152 PUSH [tag] 153 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 66
*)
Example BottleCastle_run_code_of_0_block_169_0: equiv_checker [PUSH 1 (natToWord WLen 152);PUSH 1 (natToWord WLen 153);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 66)] [PUSH 1 (natToWord WLen 152);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 153);DUP 2;DUP 1;PUSH 1 (natToWord WLen 66)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 154
 O: PUSH [tag] 154
*)
Example BottleCastle_run_code_of_0_block_170_0: equiv_checker [PUSH 1 (natToWord WLen 154)] [PUSH 1 (natToWord WLen 154)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 155
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 155
*)
Example BottleCastle_run_code_of_0_block_172_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 155)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 155)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_173_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 156 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 157 SWAP2 SWAP1 PUSH [tag] 158
 O: POP PUSH [tag] 156 PUSH [tag] 157 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 158
*)
Example BottleCastle_run_code_of_0_block_174_0: equiv_checker [POP;PUSH 1 (natToWord WLen 156);PUSH 1 (natToWord WLen 157);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 158)] [POP;PUSH 1 (natToWord WLen 156);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 157);DUP 2;DUP 1;PUSH 1 (natToWord WLen 158)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 159
 O: PUSH [tag] 159
*)
Example BottleCastle_run_code_of_0_block_175_0: equiv_checker [PUSH 1 (natToWord WLen 159)] [PUSH 1 (natToWord WLen 159)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 160
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 160
*)
Example BottleCastle_run_code_of_0_block_177_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 160)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 160)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_178_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 161 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 162 SWAP2 SWAP1 PUSH [tag] 163
 O: POP PUSH [tag] 161 PUSH [tag] 162 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 163
*)
Example BottleCastle_run_code_of_0_block_179_0: equiv_checker [POP;PUSH 1 (natToWord WLen 161);PUSH 1 (natToWord WLen 162);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 163)] [POP;PUSH 1 (natToWord WLen 161);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 162);DUP 2;DUP 1;PUSH 1 (natToWord WLen 163)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 164
 O: PUSH [tag] 164
*)
Example BottleCastle_run_code_of_0_block_180_0: equiv_checker [PUSH 1 (natToWord WLen 164)] [PUSH 1 (natToWord WLen 164)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 165
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 165
*)
Example BottleCastle_run_code_of_0_block_182_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 165)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 165)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_183_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 166 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 167 SWAP2 SWAP1 PUSH [tag] 168
 O: POP PUSH [tag] 166 PUSH [tag] 167 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 168
*)
Example BottleCastle_run_code_of_0_block_184_0: equiv_checker [POP;PUSH 1 (natToWord WLen 166);PUSH 1 (natToWord WLen 167);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 168)] [POP;PUSH 1 (natToWord WLen 166);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 167);DUP 2;DUP 1;PUSH 1 (natToWord WLen 168)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 169
 O: PUSH [tag] 169
*)
Example BottleCastle_run_code_of_0_block_185_0: equiv_checker [PUSH 1 (natToWord WLen 169)] [PUSH 1 (natToWord WLen 169)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 170
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 170
*)
Example BottleCastle_run_code_of_0_block_187_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 170)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 170)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_188_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 171 PUSH [tag] 172
 O: POP PUSH [tag] 171 PUSH [tag] 172
*)
Example BottleCastle_run_code_of_0_block_189_0: equiv_checker [POP;PUSH 1 (natToWord WLen 171);PUSH 1 (natToWord WLen 172)] [POP;PUSH 1 (natToWord WLen 171);PUSH 1 (natToWord WLen 172)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 173 SWAP2 SWAP1 PUSH [tag] 83
 O: PUSH [tag] 173 SWAP1 PUSH 40 MLOAD PUSH [tag] 83
*)
Example BottleCastle_run_code_of_0_block_190_0: equiv_checker [PUSH 1 (natToWord WLen 173);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 83)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 173);DUP 2;DUP 1;PUSH 1 (natToWord WLen 83)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_191_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 174
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 174
*)
Example BottleCastle_run_code_of_0_block_192_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 174)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 174)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_193_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 175 PUSH [tag] 176
 O: POP PUSH [tag] 175 PUSH [tag] 176
*)
Example BottleCastle_run_code_of_0_block_194_0: equiv_checker [POP;PUSH 1 (natToWord WLen 175);PUSH 1 (natToWord WLen 176)] [POP;PUSH 1 (natToWord WLen 175);PUSH 1 (natToWord WLen 176)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 177 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 177 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Example BottleCastle_run_code_of_0_block_195_0: equiv_checker [PUSH 1 (natToWord WLen 177);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 62)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 177);DUP 2;DUP 1;PUSH 1 (natToWord WLen 62)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_196_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 178
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 178
*)
Example BottleCastle_run_code_of_0_block_197_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 178)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 178)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_198_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 179 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 180 SWAP2 SWAP1 PUSH [tag] 66
 O: POP PUSH [tag] 179 PUSH [tag] 180 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 66
*)
Example BottleCastle_run_code_of_0_block_199_0: equiv_checker [POP;PUSH 1 (natToWord WLen 179);PUSH 1 (natToWord WLen 180);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 66)] [POP;PUSH 1 (natToWord WLen 179);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 180);DUP 2;DUP 1;PUSH 1 (natToWord WLen 66)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 181
 O: PUSH [tag] 181
*)
Example BottleCastle_run_code_of_0_block_200_0: equiv_checker [PUSH 1 (natToWord WLen 181)] [PUSH 1 (natToWord WLen 181)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 182 SWAP2 SWAP1 PUSH [tag] 62
 O: PUSH [tag] 182 SWAP1 PUSH 40 MLOAD PUSH [tag] 62
*)
Example BottleCastle_run_code_of_0_block_201_0: equiv_checker [PUSH 1 (natToWord WLen 182);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 62)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 182);DUP 2;DUP 1;PUSH 1 (natToWord WLen 62)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_202_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 183
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 183
*)
Example BottleCastle_run_code_of_0_block_203_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 183)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 183)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_204_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 184 PUSH [tag] 185
 O: POP PUSH [tag] 184 PUSH [tag] 185
*)
Example BottleCastle_run_code_of_0_block_205_0: equiv_checker [POP;PUSH 1 (natToWord WLen 184);PUSH 1 (natToWord WLen 185)] [POP;PUSH 1 (natToWord WLen 184);PUSH 1 (natToWord WLen 185)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 186 SWAP2 SWAP1 PUSH [tag] 83
 O: PUSH [tag] 186 SWAP1 PUSH 40 MLOAD PUSH [tag] 83
*)
Example BottleCastle_run_code_of_0_block_206_0: equiv_checker [PUSH 1 (natToWord WLen 186);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 83)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 186);DUP 2;DUP 1;PUSH 1 (natToWord WLen 83)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_207_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 187
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 187
*)
Example BottleCastle_run_code_of_0_block_208_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 187)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 187)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_209_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 188 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 189 SWAP2 SWAP1 PUSH [tag] 110
 O: POP PUSH [tag] 188 PUSH [tag] 189 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 110
*)
Example BottleCastle_run_code_of_0_block_210_0: equiv_checker [POP;PUSH 1 (natToWord WLen 188);PUSH 1 (natToWord WLen 189);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 110)] [POP;PUSH 1 (natToWord WLen 188);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 189);DUP 2;DUP 1;PUSH 1 (natToWord WLen 110)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 190
 O: PUSH [tag] 190
*)
Example BottleCastle_run_code_of_0_block_211_0: equiv_checker [PUSH 1 (natToWord WLen 190)] [PUSH 1 (natToWord WLen 190)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 191
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 191
*)
Example BottleCastle_run_code_of_0_block_213_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 191)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 191)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_214_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 192 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 193 SWAP2 SWAP1 PUSH [tag] 128
 O: POP PUSH [tag] 192 PUSH [tag] 193 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 128
*)
Example BottleCastle_run_code_of_0_block_215_0: equiv_checker [POP;PUSH 1 (natToWord WLen 192);PUSH 1 (natToWord WLen 193);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 128)] [POP;PUSH 1 (natToWord WLen 192);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 193);DUP 2;DUP 1;PUSH 1 (natToWord WLen 128)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 194
 O: PUSH [tag] 194
*)
Example BottleCastle_run_code_of_0_block_216_0: equiv_checker [PUSH 1 (natToWord WLen 194)] [PUSH 1 (natToWord WLen 194)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 195 SWAP2 SWAP1 PUSH [tag] 83
 O: PUSH [tag] 195 SWAP1 PUSH 40 MLOAD PUSH [tag] 83
*)
Example BottleCastle_run_code_of_0_block_217_0: equiv_checker [PUSH 1 (natToWord WLen 195);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 83)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 195);DUP 2;DUP 1;PUSH 1 (natToWord WLen 83)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_218_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 196
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 196
*)
Example BottleCastle_run_code_of_0_block_219_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 196)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 196)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_220_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 197 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 198 SWAP2 SWAP1 PUSH [tag] 66
 O: POP PUSH [tag] 197 PUSH [tag] 198 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 66
*)
Example BottleCastle_run_code_of_0_block_221_0: equiv_checker [POP;PUSH 1 (natToWord WLen 197);PUSH 1 (natToWord WLen 198);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 66)] [POP;PUSH 1 (natToWord WLen 197);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 198);DUP 2;DUP 1;PUSH 1 (natToWord WLen 66)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 199
 O: PUSH [tag] 199
*)
Example BottleCastle_run_code_of_0_block_222_0: equiv_checker [PUSH 1 (natToWord WLen 199)] [PUSH 1 (natToWord WLen 199)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 200
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 200
*)
Example BottleCastle_run_code_of_0_block_224_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 200)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 200)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_225_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 201 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 202 SWAP2 SWAP1 PUSH [tag] 203
 O: POP PUSH [tag] 201 PUSH [tag] 202 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 203
*)
Example BottleCastle_run_code_of_0_block_226_0: equiv_checker [POP;PUSH 1 (natToWord WLen 201);PUSH 1 (natToWord WLen 202);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 203)] [POP;PUSH 1 (natToWord WLen 201);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 202);DUP 2;DUP 1;PUSH 1 (natToWord WLen 203)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 204
 O: PUSH [tag] 204
*)
Example BottleCastle_run_code_of_0_block_227_0: equiv_checker [PUSH 1 (natToWord WLen 204)] [PUSH 1 (natToWord WLen 204)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 205 SWAP2 SWAP1 PUSH [tag] 52
 O: PUSH [tag] 205 SWAP1 PUSH 40 MLOAD PUSH [tag] 52
*)
Example BottleCastle_run_code_of_0_block_228_0: equiv_checker [PUSH 1 (natToWord WLen 205);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 52)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 205);DUP 2;DUP 1;PUSH 1 (natToWord WLen 52)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_229_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 206
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 206
*)
Example BottleCastle_run_code_of_0_block_230_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 206)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 206)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_231_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 207 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 208 SWAP2 SWAP1 PUSH [tag] 110
 O: POP PUSH [tag] 207 PUSH [tag] 208 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 110
*)
Example BottleCastle_run_code_of_0_block_232_0: equiv_checker [POP;PUSH 1 (natToWord WLen 207);PUSH 1 (natToWord WLen 208);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 110)] [POP;PUSH 1 (natToWord WLen 207);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 208);DUP 2;DUP 1;PUSH 1 (natToWord WLen 110)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 209
 O: PUSH [tag] 209
*)
Example BottleCastle_run_code_of_0_block_233_0: equiv_checker [PUSH 1 (natToWord WLen 209)] [PUSH 1 (natToWord WLen 209)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 210
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 210
*)
Example BottleCastle_run_code_of_0_block_235_0: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 210)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 210)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_236_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 211 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 212 SWAP2 SWAP1 PUSH [tag] 128
 O: POP PUSH [tag] 211 PUSH [tag] 212 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 128
*)
Example BottleCastle_run_code_of_0_block_237_0: equiv_checker [POP;PUSH 1 (natToWord WLen 211);PUSH 1 (natToWord WLen 212);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 128)] [POP;PUSH 1 (natToWord WLen 211);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 212);DUP 2;DUP 1;PUSH 1 (natToWord WLen 128)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 213
 O: PUSH [tag] 213
*)
Example BottleCastle_run_code_of_0_block_238_0: equiv_checker [PUSH 1 (natToWord WLen 213)] [PUSH 1 (natToWord WLen 213)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 1FFC9A7 PUSH E0 SHL DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ DUP1 PUSH [tag] 215
 O: PUSH 0 PUSH 1ffc9a7 PUSH e0 SHL PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT DUP4 AND EQ DUP1 PUSH [tag] 215
*)
Example BottleCastle_run_code_of_0_block_240_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 4 (natToWord WLen 33540519);PUSH 1 (natToWord WLen 224);Opcode SHL;PUSH 28 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249215);Opcode NOT;DUP 4;Opcode AND;Opcode EQ;DUP 1;PUSH 1 (natToWord WLen 215)] [PUSH 1 (natToWord WLen 0);PUSH 4 (natToWord WLen 33540519);PUSH 1 (natToWord WLen 224);Opcode SHL;DUP 3;PUSH 28 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249215);Opcode NOT;Opcode AND;Opcode EQ;DUP 1;PUSH 1 (natToWord WLen 215)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 80AC58CD PUSH E0 SHL DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ
 O: POP PUSH 80ac58cd PUSH e0 SHL DUP3 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT AND EQ
*)
Example BottleCastle_run_code_of_0_block_241_0: equiv_checker [POP;PUSH 4 (natToWord WLen 2158778573);PUSH 1 (natToWord WLen 224);Opcode SHL;DUP 3;PUSH 28 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249215);Opcode NOT;Opcode AND;Opcode EQ] [POP;PUSH 4 (natToWord WLen 2158778573);PUSH 1 (natToWord WLen 224);Opcode SHL;DUP 3;PUSH 28 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249215);Opcode NOT;Opcode AND;Opcode EQ] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH [tag] 216
 O: DUP1 PUSH [tag] 216
*)
Example BottleCastle_run_code_of_0_block_242_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 216)] [DUP 1;PUSH 1 (natToWord WLen 216)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 5B5E139F PUSH E0 SHL DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ
 O: POP PUSH 5b5e139f PUSH e0 SHL DUP3 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT AND EQ
*)
Example BottleCastle_run_code_of_0_block_243_0: equiv_checker [POP;PUSH 4 (natToWord WLen 1532892063);PUSH 1 (natToWord WLen 224);Opcode SHL;DUP 3;PUSH 28 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249215);Opcode NOT;Opcode AND;Opcode EQ] [POP;PUSH 4 (natToWord WLen 1532892063);PUSH 1 (natToWord WLen 224);Opcode SHL;DUP 3;PUSH 28 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249215);Opcode NOT;Opcode AND;Opcode EQ] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_244_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 218 PUSH [tag] 219
 O: PUSH [tag] 218 PUSH [tag] 219
*)
Example BottleCastle_run_code_of_0_block_245_0: equiv_checker [PUSH 1 (natToWord WLen 218);PUSH 1 (natToWord WLen 219)] [PUSH 1 (natToWord WLen 218);PUSH 1 (natToWord WLen 219)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 10 PUSH 0 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1
 O: DUP1 PUSH 10 DUP2 ISZERO PUSH 0 PUSH 100 EXP PUSH ff DUP2 MUL NOT DUP4 SLOAD AND SWAP2 ISZERO MUL OR SWAP1
*)
Example BottleCastle_run_code_of_0_block_246_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 16);DUP 2;Opcode ISZERO;PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 256);Opcode EXP;PUSH 1 (natToWord WLen 255);DUP 2;Opcode MUL;Opcode NOT;DUP 4;Opcode SLOAD;Opcode AND;DUP 2;Opcode ISZERO;Opcode MUL;Opcode OR;DUP 1] [DUP 1;PUSH 1 (natToWord WLen 16);PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 1 (natToWord WLen 255);Opcode MUL;Opcode NOT;Opcode AND;DUP 1;DUP 4;Opcode ISZERO;Opcode ISZERO;Opcode MUL;Opcode OR;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_run_code_of_0_block_246_1: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 60 PUSH 2 DUP1 SLOAD PUSH [tag] 222 SWAP1 PUSH [tag] 223
 O: PUSH 60 PUSH 2 PUSH [tag] 222 DUP2 SLOAD PUSH [tag] 223
*)
Example BottleCastle_run_code_of_0_block_247_0: equiv_checker [PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 2);PUSH 1 (natToWord WLen 222);DUP 2;Opcode SLOAD;PUSH 1 (natToWord WLen 223)] [PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 2);DUP 1;Opcode SLOAD;PUSH 1 (natToWord WLen 222);DUP 1;PUSH 1 (natToWord WLen 223)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Example BottleCastle_run_code_of_0_block_248_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);DUP 1;PUSH 1 (natToWord WLen 31);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (natToWord WLen 64)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode ADD;PUSH 1 (natToWord WLen 32);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (natToWord WLen 64)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Example BottleCastle_run_code_of_0_block_248_1: equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 224 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 224 DUP5 SLOAD PUSH [tag] 223
*)
Example BottleCastle_run_code_of_0_block_248_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;PUSH 1 (natToWord WLen 224);DUP 5;Opcode SLOAD;PUSH 1 (natToWord WLen 223)] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (natToWord WLen 224);DUP 1;PUSH 1 (natToWord WLen 223)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 ISZERO PUSH [tag] 225
 O: DUP1 ISZERO PUSH [tag] 225
*)
Example BottleCastle_run_code_of_0_block_249_0: equiv_checker [DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 225)] [DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 225)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 226
 O: DUP1 PUSH 1f LT PUSH [tag] 226
*)
Example BottleCastle_run_code_of_0_block_250_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 1 (natToWord WLen 226)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 1 (natToWord WLen 226)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Example BottleCastle_run_code_of_0_block_251_0: equiv_checker [PUSH 2 (natToWord WLen 256);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (natToWord WLen 256);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 225
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 225
*)
Example BottleCastle_run_code_of_0_block_251_1: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 1 (natToWord WLen 225)] [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 1 (natToWord WLen 225)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_252_0: equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 0)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 0)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Example BottleCastle_run_code_of_0_block_252_1: equiv_checker [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Example BottleCastle_run_code_of_0_block_253_0: equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 227
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 227
*)
Example BottleCastle_run_code_of_0_block_253_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (natToWord WLen 227)] [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (natToWord WLen 227)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Example BottleCastle_run_code_of_0_block_254_0: equiv_checker [PUSH 1 (natToWord WLen 31);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (natToWord WLen 31);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP POP SWAP1 POP SWAP1
 O: POP POP POP POP POP SWAP2 SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_255_0: equiv_checker [POP;POP;POP;POP;POP;DUP 2;DUP 1;POP] [POP;POP;POP;POP;POP;DUP 1;POP;DUP 1] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 229 DUP3 PUSH [tag] 230
 O: PUSH 0 PUSH [tag] 229 DUP3 PUSH [tag] 230
*)
Example BottleCastle_run_code_of_0_block_256_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 229);DUP 3;PUSH 1 (natToWord WLen 230)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 229);DUP 3;PUSH 1 (natToWord WLen 230)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 231
 O: PUSH [tag] 231
*)
Example BottleCastle_run_code_of_0_block_257_0: equiv_checker [PUSH 1 (natToWord WLen 231)] [PUSH 1 (natToWord WLen 231)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH CF4700E400000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH cf4700e400000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_258_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 93754211945203247791024388466000925045829571609179897114057315550813419995136);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 93754211945203247791024388466000925045829571609179897114057315550813419995136);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_258_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 6 PUSH 0 DUP4 DUP2
 O: PUSH 6 PUSH 0 DUP4 DUP2
*)
Example BottleCastle_run_code_of_0_block_259_0: equiv_checker [PUSH 1 (natToWord WLen 6);PUSH 1 (natToWord WLen 0);DUP 4;DUP 2] [PUSH 1 (natToWord WLen 6);PUSH 1 (natToWord WLen 0);DUP 4;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_259_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 ADD PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 SWAP2 POP ADD PUSH 0 SWAP1 DUP2 DUP1 PUSH 100 EXP SWAP4 POP KECCAK256 ADD SLOAD DIV PUSH ffffffffffffffffffffffffffffffffffffffff AND SWAP1
*)
Example BottleCastle_run_code_of_0_block_259_2: equiv_checker [PUSH 1 (natToWord WLen 32);DUP 2;POP;Opcode ADD;PUSH 1 (natToWord WLen 0);DUP 1;DUP 2;DUP 1;PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 4;POP;Opcode KECCAK256;Opcode ADD;Opcode SLOAD;Opcode DIV;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 1] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);Opcode ADD;PUSH 1 (natToWord WLen 0);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 1;Opcode DIV;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH C DUP1 SLOAD PUSH [tag] 232 SWAP1 PUSH [tag] 223
 O: PUSH c PUSH [tag] 232 DUP2 SLOAD PUSH [tag] 223
*)
Example BottleCastle_run_code_of_0_block_260_0: equiv_checker [PUSH 1 (natToWord WLen 12);PUSH 1 (natToWord WLen 232);DUP 2;Opcode SLOAD;PUSH 1 (natToWord WLen 223)] [PUSH 1 (natToWord WLen 12);DUP 1;Opcode SLOAD;PUSH 1 (natToWord WLen 232);DUP 1;PUSH 1 (natToWord WLen 223)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Example BottleCastle_run_code_of_0_block_261_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);DUP 1;PUSH 1 (natToWord WLen 31);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (natToWord WLen 64)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode ADD;PUSH 1 (natToWord WLen 32);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (natToWord WLen 64)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Example BottleCastle_run_code_of_0_block_261_1: equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 233 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 233 DUP5 SLOAD PUSH [tag] 223
*)
Example BottleCastle_run_code_of_0_block_261_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;PUSH 1 (natToWord WLen 233);DUP 5;Opcode SLOAD;PUSH 1 (natToWord WLen 223)] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (natToWord WLen 233);DUP 1;PUSH 1 (natToWord WLen 223)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 ISZERO PUSH [tag] 234
 O: DUP1 ISZERO PUSH [tag] 234
*)
Example BottleCastle_run_code_of_0_block_262_0: equiv_checker [DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 234)] [DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 234)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 235
 O: DUP1 PUSH 1f LT PUSH [tag] 235
*)
Example BottleCastle_run_code_of_0_block_263_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 1 (natToWord WLen 235)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 1 (natToWord WLen 235)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Example BottleCastle_run_code_of_0_block_264_0: equiv_checker [PUSH 2 (natToWord WLen 256);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (natToWord WLen 256);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 234
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 234
*)
Example BottleCastle_run_code_of_0_block_264_1: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 1 (natToWord WLen 234)] [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 1 (natToWord WLen 234)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_265_0: equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 0)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 0)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Example BottleCastle_run_code_of_0_block_265_1: equiv_checker [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Example BottleCastle_run_code_of_0_block_266_0: equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 236
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 236
*)
Example BottleCastle_run_code_of_0_block_266_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (natToWord WLen 236)] [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (natToWord WLen 236)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Example BottleCastle_run_code_of_0_block_267_0: equiv_checker [PUSH 1 (natToWord WLen 31);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (natToWord WLen 31);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP POP DUP2
 O: POP POP POP POP POP DUP2
*)
Example BottleCastle_run_code_of_0_block_268_0: equiv_checker [POP;POP;POP;POP;POP;DUP 2] [POP;POP;POP;POP;POP;DUP 2] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 238 DUP3 PUSH [tag] 119
 O: PUSH 0 PUSH [tag] 238 DUP3 PUSH [tag] 119
*)
Example BottleCastle_run_code_of_0_block_269_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 238);DUP 3;PUSH 1 (natToWord WLen 119)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 238);DUP 3;PUSH 1 (natToWord WLen 119)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP DUP1 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH [tag] 239 PUSH [tag] 240
 O: DUP1 SWAP2 POP PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH [tag] 239 PUSH [tag] 240
*)
Example BottleCastle_run_code_of_0_block_270_0: equiv_checker [DUP 1;DUP 2;POP;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 1 (natToWord WLen 239);PUSH 1 (natToWord WLen 240)] [DUP 1;POP;DUP 1;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 1 (natToWord WLen 239);PUSH 1 (natToWord WLen 240)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ PUSH [tag] 241
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ PUSH [tag] 241
*)
Example BottleCastle_run_code_of_0_block_271_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;PUSH 1 (natToWord WLen 241)] [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;PUSH 1 (natToWord WLen 241)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 242 DUP2 PUSH [tag] 243 PUSH [tag] 240
 O: PUSH [tag] 242 DUP2 PUSH [tag] 243 PUSH [tag] 240
*)
Example BottleCastle_run_code_of_0_block_272_0: equiv_checker [PUSH 1 (natToWord WLen 242);DUP 2;PUSH 1 (natToWord WLen 243);PUSH 1 (natToWord WLen 240)] [PUSH 1 (natToWord WLen 242);DUP 2;PUSH 1 (natToWord WLen 243);PUSH 1 (natToWord WLen 240)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 204
 O: PUSH [tag] 204
*)
Example BottleCastle_run_code_of_0_block_273_0: equiv_checker [PUSH 1 (natToWord WLen 204)] [PUSH 1 (natToWord WLen 204)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 244
 O: PUSH [tag] 244
*)
Example BottleCastle_run_code_of_0_block_274_0: equiv_checker [PUSH 1 (natToWord WLen 244)] [PUSH 1 (natToWord WLen 244)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH CFB3B94200000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH cfb3b94200000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_275_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 93946303883762109474516413289859237398067474195984919031474412148749565427712);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 93946303883762109474516413289859237398067474195984919031474412148749565427712);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_275_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 PUSH 6 PUSH 0 DUP5 DUP2
 O: DUP3 PUSH 6 PUSH 0 DUP5 DUP2
*)
Example BottleCastle_run_code_of_0_block_277_0: equiv_checker [DUP 3;PUSH 1 (natToWord WLen 6);PUSH 1 (natToWord WLen 0);DUP 5;DUP 2] [DUP 3;PUSH 1 (natToWord WLen 6);PUSH 1 (natToWord WLen 0);DUP 5;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_277_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 ADD PUSH 0 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF MUL NOT AND SWAP1 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND MUL OR SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 ADD PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 PUSH 100 EXP DUP3 SLOAD DUP2 DUP4 MUL NOT AND SWAP2 DUP5 AND MUL OR SWAP1
*)
Example BottleCastle_run_code_of_0_block_277_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);Opcode ADD;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 3;Opcode SLOAD;DUP 2;DUP 4;Opcode MUL;Opcode NOT;Opcode AND;DUP 2;DUP 5;Opcode AND;Opcode MUL;Opcode OR;DUP 1] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);Opcode ADD;PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode MUL;Opcode NOT;Opcode AND;DUP 1;DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode MUL;Opcode OR;DUP 1] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP DUP2 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B925 PUSH 40 MLOAD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: POP PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 40 MLOAD DUP5 DUP3 AND PUSH 8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925 DUP3 DUP1 SUB DUP6 DUP8 SWAP6 AND SWAP3 SWAP4
*)
Example BottleCastle_run_code_of_0_block_277_3: equiv_checker [POP;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 5;DUP 3;Opcode AND;PUSH 32 (natToWord WLen 63486140976153616755203102783360879283472101686154884697241723088393386309925);DUP 3;DUP 1;Opcode SUB;DUP 6;DUP 8;DUP 6;Opcode AND;DUP 3;DUP 4] [POP;DUP 2;DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 3;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 32 (natToWord WLen 63486140976153616755203102783360879283472101686154884697241723088393386309925);PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP
 O: POP POP POP
*)
Example BottleCastle_run_code_of_0_block_277_4: equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH D SLOAD DUP2
 O: PUSH d SLOAD DUP2
*)
Example BottleCastle_run_code_of_0_block_278_0: equiv_checker [PUSH 1 (natToWord WLen 13);Opcode SLOAD;DUP 2] [PUSH 1 (natToWord WLen 13);Opcode SLOAD;DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 246 PUSH [tag] 247
 O: PUSH 0 PUSH [tag] 246 PUSH [tag] 247
*)
Example BottleCastle_run_code_of_0_block_279_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 246);PUSH 1 (natToWord WLen 247)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 246);PUSH 1 (natToWord WLen 247)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 1 SLOAD PUSH 0 SLOAD SUB SUB SWAP1 POP SWAP1
 O: PUSH 1 SLOAD PUSH 0 SLOAD SUB SUB SWAP2 SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_280_0: equiv_checker [PUSH 1 (natToWord WLen 1);Opcode SLOAD;PUSH 1 (natToWord WLen 0);Opcode SLOAD;Opcode SUB;Opcode SUB;DUP 2;DUP 1;POP] [PUSH 1 (natToWord WLen 1);Opcode SLOAD;PUSH 1 (natToWord WLen 0);Opcode SLOAD;Opcode SUB;Opcode SUB;DUP 1;POP;DUP 1] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 249 DUP3 PUSH [tag] 250
 O: PUSH 0 PUSH [tag] 249 DUP3 PUSH [tag] 250
*)
Example BottleCastle_run_code_of_0_block_281_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 249);DUP 3;PUSH 1 (natToWord WLen 250)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 249);DUP 3;PUSH 1 (natToWord WLen 250)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ PUSH [tag] 251
 O: SWAP1 POP DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 AND EQ PUSH [tag] 251
*)
Example BottleCastle_run_code_of_0_block_282_0: equiv_checker [DUP 1;POP;DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 3;Opcode AND;Opcode EQ;PUSH 1 (natToWord WLen 251)] [DUP 1;POP;DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;PUSH 1 (natToWord WLen 251)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH A114810000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH a114810000000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_283_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 72858595888480192197425434824141221654945492164620433336968169282127339192320);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 72858595888480192197425434824141221654945492164620433336968169282127339192320);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_283_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH [tag] 252 DUP5 PUSH [tag] 253
 O: PUSH 0 DUP1 PUSH [tag] 252 DUP5 PUSH [tag] 253
*)
Example BottleCastle_run_code_of_0_block_284_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 252);DUP 5;PUSH 1 (natToWord WLen 253)] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 252);DUP 5;PUSH 1 (natToWord WLen 253)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP SWAP2 POP PUSH [tag] 254 DUP2 DUP8 PUSH [tag] 255 PUSH [tag] 240
 O: SWAP2 POP SWAP2 POP PUSH [tag] 254 DUP2 DUP8 PUSH [tag] 255 PUSH [tag] 240
*)
Example BottleCastle_run_code_of_0_block_285_0: equiv_checker [DUP 2;POP;DUP 2;POP;PUSH 1 (natToWord WLen 254);DUP 2;DUP 8;PUSH 1 (natToWord WLen 255);PUSH 1 (natToWord WLen 240)] [DUP 2;POP;DUP 2;POP;PUSH 1 (natToWord WLen 254);DUP 2;DUP 8;PUSH 1 (natToWord WLen 255);PUSH 1 (natToWord WLen 240)] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 256
 O: PUSH [tag] 256
*)
Example BottleCastle_run_code_of_0_block_286_0: equiv_checker [PUSH 2 (natToWord WLen 256)] [PUSH 2 (natToWord WLen 256)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 257
 O: PUSH [tag] 257
*)
Example BottleCastle_run_code_of_0_block_287_0: equiv_checker [PUSH 2 (natToWord WLen 257)] [PUSH 2 (natToWord WLen 257)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 258 DUP7 PUSH [tag] 259 PUSH [tag] 240
 O: PUSH [tag] 258 DUP7 PUSH [tag] 259 PUSH [tag] 240
*)
Example BottleCastle_run_code_of_0_block_288_0: equiv_checker [PUSH 2 (natToWord WLen 258);DUP 7;PUSH 2 (natToWord WLen 259);PUSH 1 (natToWord WLen 240)] [PUSH 2 (natToWord WLen 258);DUP 7;PUSH 2 (natToWord WLen 259);PUSH 1 (natToWord WLen 240)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 204
 O: PUSH [tag] 204
*)
Example BottleCastle_run_code_of_0_block_289_0: equiv_checker [PUSH 1 (natToWord WLen 204)] [PUSH 1 (natToWord WLen 204)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 260
 O: PUSH [tag] 260
*)
Example BottleCastle_run_code_of_0_block_290_0: equiv_checker [PUSH 2 (natToWord WLen 260)] [PUSH 2 (natToWord WLen 260)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 59C896BE00000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 59c896be00000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_291_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 40610253321208270774332185957187447255326585543192491974159042718829090177024);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 40610253321208270774332185957187447255326585543192491974159042718829090177024);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_291_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 261
 O: PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 AND PUSH ffffffffffffffffffffffffffffffffffffffff DUP7 AND EQ ISZERO PUSH [tag] 261
*)
Example BottleCastle_run_code_of_0_block_293_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);PUSH 1 (natToWord WLen 0);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 7;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 261)] [PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 6;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 261)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH EA553B3400000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH ea553b3400000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_294_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 105991797173942184882469161745347597715497421134232373703673558015659904860160);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 105991797173942184882469161745347597715497421134232373703673558015659904860160);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_294_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 262 DUP7 DUP7 DUP7 PUSH 1 PUSH [tag] 263
 O: PUSH [tag] 262 DUP7 DUP7 DUP7 PUSH 1 PUSH [tag] 263
*)
Example BottleCastle_run_code_of_0_block_295_0: equiv_checker [PUSH 2 (natToWord WLen 262);DUP 7;DUP 7;DUP 7;PUSH 1 (natToWord WLen 1);PUSH 2 (natToWord WLen 263)] [PUSH 2 (natToWord WLen 262);DUP 7;DUP 7;DUP 7;PUSH 1 (natToWord WLen 1);PUSH 2 (natToWord WLen 263)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 ISZERO PUSH [tag] 264
 O: DUP1 ISZERO PUSH [tag] 264
*)
Example BottleCastle_run_code_of_0_block_296_0: equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 264)] [DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 264)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP3
 O: PUSH 0 DUP3
*)
Example BottleCastle_run_code_of_0_block_297_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 3] [PUSH 1 (natToWord WLen 0);DUP 3] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 5 PUSH 0 DUP8 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 5 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP9 AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Example BottleCastle_run_code_of_0_block_298_0: equiv_checker [PUSH 1 (natToWord WLen 5);PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 9;Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] [PUSH 1 (natToWord WLen 5);PUSH 1 (natToWord WLen 0);DUP 8;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_298_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP2 SLOAD PUSH 1 SWAP1 SUB SWAP2 SWAP1 POP DUP2 SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 1 DUP2 SLOAD SUB DUP1 SWAP2
*)
Example BottleCastle_run_code_of_0_block_298_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 1);DUP 2;Opcode SLOAD;Opcode SUB;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);DUP 2;Opcode SLOAD;PUSH 1 (natToWord WLen 1);DUP 1;Opcode SUB;DUP 2;DUP 1;POP;DUP 2;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 5 PUSH 0 DUP7 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: POP PUSH 5 PUSH 0 DUP7 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Example BottleCastle_run_code_of_0_block_298_3: equiv_checker [POP;PUSH 1 (natToWord WLen 5);PUSH 1 (natToWord WLen 0);DUP 7;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] [POP;PUSH 1 (natToWord WLen 5);PUSH 1 (natToWord WLen 0);DUP 7;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_298_4: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP2 SLOAD PUSH 1 ADD SWAP2 SWAP1 POP DUP2 SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 1 DUP2 SLOAD ADD DUP1 SWAP2
*)
Example BottleCastle_run_code_of_0_block_298_5: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 1);DUP 2;Opcode SLOAD;Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);DUP 2;Opcode SLOAD;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 2;DUP 1;POP;DUP 2;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 265 DUP6 PUSH [tag] 266 DUP9 DUP9 DUP8 PUSH [tag] 267
 O: POP PUSH [tag] 265 DUP6 PUSH [tag] 266 DUP9 DUP3 DUP8 PUSH [tag] 267
*)
Example BottleCastle_run_code_of_0_block_298_6: equiv_checker [POP;PUSH 2 (natToWord WLen 265);DUP 6;PUSH 2 (natToWord WLen 266);DUP 9;DUP 3;DUP 8;PUSH 2 (natToWord WLen 267)] [POP;PUSH 2 (natToWord WLen 265);DUP 6;PUSH 2 (natToWord WLen 266);DUP 9;DUP 9;DUP 8;PUSH 2 (natToWord WLen 267)] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 200000000000000000000000000000000000000000000000000000000 OR PUSH [tag] 268
 O: PUSH 200000000000000000000000000000000000000000000000000000000 OR PUSH [tag] 268
*)
Example BottleCastle_run_code_of_0_block_299_0: equiv_checker [PUSH 29 (natToWord WLen 53919893334301279589334030174039261347274288845081144962207220498432);Opcode OR;PUSH 2 (natToWord WLen 268)] [PUSH 29 (natToWord WLen 53919893334301279589334030174039261347274288845081144962207220498432);Opcode OR;PUSH 2 (natToWord WLen 268)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 PUSH 0 DUP7 DUP2
 O: PUSH 4 PUSH 0 DUP7 DUP2
*)
Example BottleCastle_run_code_of_0_block_300_0: equiv_checker [PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 7;DUP 2] [PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 7;DUP 2] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_300_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 DUP2 SWAP1
 O: DUP2 SWAP1 PUSH 20 ADD PUSH 0 KECCAK256
*)
Example BottleCastle_run_code_of_0_block_300_2: equiv_checker [DUP 2;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 2;DUP 1] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 0 PUSH 200000000000000000000000000000000000000000000000000000000 DUP5 AND EQ ISZERO PUSH [tag] 269
 O: POP PUSH 200000000000000000000000000000000000000000000000000000000 DUP4 AND PUSH 0 EQ ISZERO PUSH [tag] 269
*)
Example BottleCastle_run_code_of_0_block_300_3: equiv_checker [POP;PUSH 29 (natToWord WLen 53919893334301279589334030174039261347274288845081144962207220498432);DUP 4;Opcode AND;PUSH 1 (natToWord WLen 0);Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 269)] [POP;PUSH 1 (natToWord WLen 0);PUSH 29 (natToWord WLen 53919893334301279589334030174039261347274288845081144962207220498432);DUP 5;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 269)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 1 DUP6 ADD SWAP1 POP PUSH 0 PUSH 4 PUSH 0 DUP4 DUP2
 O: DUP4 PUSH 1 ADD PUSH 0 PUSH 4 DUP2 DUP4 DUP4
*)
Example BottleCastle_run_code_of_0_block_301_0: equiv_checker [DUP 4;PUSH 1 (natToWord WLen 1);Opcode ADD;PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 4);DUP 2;DUP 4;DUP 4] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 1);DUP 6;Opcode ADD;DUP 1;POP;PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 4;DUP 2] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_301_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD EQ ISZERO PUSH [tag] 270
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD EQ ISZERO PUSH [tag] 270
*)
Example BottleCastle_run_code_of_0_block_301_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 270)] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 270)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 SLOAD DUP2 EQ PUSH [tag] 271
 O: DUP1 PUSH 0 SLOAD EQ PUSH [tag] 271
*)
Example BottleCastle_run_code_of_0_block_302_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 0);Opcode SLOAD;Opcode EQ;PUSH 2 (natToWord WLen 271)] [PUSH 1 (natToWord WLen 0);Opcode SLOAD;DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 271)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP4 PUSH 4 PUSH 0 DUP4 DUP2
 O: DUP4 PUSH 4 PUSH 0 DUP4 DUP2
*)
Example BottleCastle_run_code_of_0_block_303_0: equiv_checker [DUP 4;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 4;DUP 2] [DUP 4;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 4;DUP 2] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_303_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 DUP2 SWAP1
 O: DUP2 SWAP1 PUSH 20 ADD PUSH 0 KECCAK256
*)
Example BottleCastle_run_code_of_0_block_303_2: equiv_checker [DUP 2;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 2;DUP 1] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_303_3: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_305_0: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP4 DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP8 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH DDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF PUSH 40 MLOAD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH ffffffffffffffffffffffffffffffffffffffff DUP1 DUP7 AND DUP8 PUSH 40 MLOAD SWAP3 AND PUSH ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef DUP4 DUP1 SUB DUP9 SWAP5
*)
Example BottleCastle_run_code_of_0_block_306_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 1;DUP 7;Opcode AND;DUP 8;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 3;Opcode AND;PUSH 32 (natToWord WLen 100389287136786176327247604509743168900146139575972864366142685224231313322991);DUP 4;DUP 1;Opcode SUB;DUP 9;DUP 5] [DUP 4;DUP 6;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 8;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 32 (natToWord WLen 100389287136786176327247604509743168900146139575972864366142685224231313322991);PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 272 DUP7 DUP7 DUP7 PUSH 1 PUSH [tag] 273
 O: PUSH [tag] 272 DUP7 DUP7 DUP7 PUSH 1 PUSH [tag] 273
*)
Example BottleCastle_run_code_of_0_block_306_1: equiv_checker [PUSH 2 (natToWord WLen 272);DUP 7;DUP 7;DUP 7;PUSH 1 (natToWord WLen 1);PUSH 2 (natToWord WLen 273)] [PUSH 2 (natToWord WLen 272);DUP 7;DUP 7;DUP 7;PUSH 1 (natToWord WLen 1);PUSH 2 (natToWord WLen 273)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP POP POP
 O: POP POP POP POP POP POP
*)
Example BottleCastle_run_code_of_0_block_307_0: equiv_checker [POP;POP;POP;POP;POP;POP] [POP;POP;POP;POP;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 275 PUSH [tag] 219
 O: PUSH [tag] 275 PUSH [tag] 219
*)
Example BottleCastle_run_code_of_0_block_308_0: equiv_checker [PUSH 2 (natToWord WLen 275);PUSH 1 (natToWord WLen 219)] [PUSH 2 (natToWord WLen 275);PUSH 1 (natToWord WLen 219)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 2 PUSH 9 SLOAD EQ ISZERO PUSH [tag] 277
 O: PUSH 2 PUSH 9 SLOAD EQ ISZERO PUSH [tag] 277
*)
Example BottleCastle_run_code_of_0_block_309_0: equiv_checker [PUSH 1 (natToWord WLen 2);PUSH 1 (natToWord WLen 9);Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 277)] [PUSH 1 (natToWord WLen 2);PUSH 1 (natToWord WLen 9);Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 277)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_310_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH [tag] 278 SWAP1 PUSH [tag] 279
 O: PUSH [tag] 278 SWAP1 PUSH 4 ADD PUSH [tag] 279
*)
Example BottleCastle_run_code_of_0_block_310_1: equiv_checker [PUSH 2 (natToWord WLen 278);DUP 1;PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 279)] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 278);DUP 1;PUSH 2 (natToWord WLen 279)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_311_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 2 PUSH 9 DUP2 SWAP1
 O: PUSH 2 DUP1 PUSH 9
*)
Example BottleCastle_run_code_of_0_block_312_0: equiv_checker [PUSH 1 (natToWord WLen 2);DUP 1;PUSH 1 (natToWord WLen 9)] [PUSH 1 (natToWord WLen 2);PUSH 1 (natToWord WLen 9);DUP 2;DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 0 SELFBALANCE SWAP1 POP PUSH [tag] 281 PUSH [tag] 240
 O: POP SELFBALANCE PUSH [tag] 281 PUSH [tag] 240
*)
Example BottleCastle_run_code_of_0_block_312_1: equiv_checker [POP;Opcode SELFBALANCE;PUSH 2 (natToWord WLen 281);PUSH 1 (natToWord WLen 240)] [POP;PUSH 1 (natToWord WLen 0);Opcode SELFBALANCE;DUP 1;POP;PUSH 2 (natToWord WLen 281);PUSH 1 (natToWord WLen 240)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 8FC DUP3 SWAP1 DUP2 ISZERO MUL SWAP1 PUSH 40 MLOAD PUSH 0 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 DUP6 DUP9 DUP9
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH 0 DUP3 DUP4 ISZERO PUSH 8fc PUSH 40 MLOAD SWAP2 MUL SWAP3 DUP2 DUP1 DUP4 SUB DUP4 DUP6 DUP9 DUP9
*)
Example BottleCastle_run_code_of_0_block_313_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 1 (natToWord WLen 0);DUP 3;DUP 4;Opcode ISZERO;PUSH 2 (natToWord WLen 2300);PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 2;Opcode MUL;DUP 3;DUP 2;DUP 1;DUP 4;Opcode SUB;DUP 4;DUP 6;DUP 9;DUP 9] [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 2 (natToWord WLen 2300);DUP 3;DUP 1;DUP 2;Opcode ISZERO;Opcode MUL;DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;DUP 6;DUP 9;DUP 9] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP4 POP POP POP POP ISZERO DUP1 ISZERO PUSH [tag] 283
 O: SWAP4 POP POP POP POP ISZERO DUP1 ISZERO PUSH [tag] 283
*)
Example BottleCastle_run_code_of_0_block_313_1: equiv_checker [DUP 4;POP;POP;POP;POP;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 283)] [DUP 4;POP;POP;POP;POP;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 283)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: RETURNDATASIZE PUSH 0 DUP1
 O: RETURNDATASIZE PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_314_0: equiv_checker [Opcode RETURNDATASIZE;PUSH 1 (natToWord WLen 0);DUP 1] [Opcode RETURNDATASIZE;PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: RETURNDATASIZE PUSH 0
 O: RETURNDATASIZE PUSH 0
*)
Example BottleCastle_run_code_of_0_block_314_1: equiv_checker [Opcode RETURNDATASIZE;PUSH 1 (natToWord WLen 0)] [Opcode RETURNDATASIZE;PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP PUSH 1 PUSH 9 DUP2 SWAP1
 O: POP POP PUSH 1 DUP1 PUSH 9
*)
Example BottleCastle_run_code_of_0_block_315_0: equiv_checker [POP;POP;PUSH 1 (natToWord WLen 1);DUP 1;PUSH 1 (natToWord WLen 9)] [POP;POP;PUSH 1 (natToWord WLen 1);PUSH 1 (natToWord WLen 9);DUP 2;DUP 1] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_315_1: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 285 DUP4 DUP4 DUP4 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH [tag] 285 DUP4 DUP4 DUP4 PUSH 40 MLOAD PUSH 20 DUP2 ADD PUSH 40
*)
Example BottleCastle_run_code_of_0_block_316_0: equiv_checker [PUSH 2 (natToWord WLen 285);DUP 4;DUP 4;DUP 4;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;PUSH 1 (natToWord WLen 64)] [PUSH 2 (natToWord WLen 285);DUP 4;DUP 4;DUP 4;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 0 DUP2
 O: DUP1 PUSH 0 DUP2
*)
Example BottleCastle_run_code_of_0_block_316_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 0);DUP 2] [DUP 1;PUSH 1 (natToWord WLen 0);DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 164
 O: POP PUSH [tag] 164
*)
Example BottleCastle_run_code_of_0_block_316_2: equiv_checker [POP;PUSH 1 (natToWord WLen 164)] [POP;PUSH 1 (natToWord WLen 164)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP
 O: POP POP POP
*)
Example BottleCastle_run_code_of_0_block_317_0: equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 287 PUSH [tag] 219
 O: PUSH [tag] 287 PUSH [tag] 219
*)
Example BottleCastle_run_code_of_0_block_318_0: equiv_checker [PUSH 2 (natToWord WLen 287);PUSH 1 (natToWord WLen 219)] [PUSH 2 (natToWord WLen 287);PUSH 1 (natToWord WLen 219)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH D DUP2 SWAP1
 O: DUP1 DUP1 PUSH d
*)
Example BottleCastle_run_code_of_0_block_319_0: equiv_checker [DUP 1;DUP 1;PUSH 1 (natToWord WLen 13)] [DUP 1;PUSH 1 (natToWord WLen 13);DUP 2;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_run_code_of_0_block_319_1: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 10 PUSH 1 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FF AND DUP2
 O: PUSH 1 PUSH 100 EXP PUSH 10 SLOAD DIV PUSH ff AND DUP2
*)
Example BottleCastle_run_code_of_0_block_320_0: equiv_checker [PUSH 1 (natToWord WLen 1);PUSH 2 (natToWord WLen 256);Opcode EXP;PUSH 1 (natToWord WLen 16);Opcode SLOAD;Opcode DIV;PUSH 1 (natToWord WLen 255);Opcode AND;DUP 2] [PUSH 1 (natToWord WLen 16);PUSH 1 (natToWord WLen 1);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 1;Opcode DIV;PUSH 1 (natToWord WLen 255);Opcode AND;DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 290 PUSH [tag] 219
 O: PUSH [tag] 290 PUSH [tag] 219
*)
Example BottleCastle_run_code_of_0_block_321_0: equiv_checker [PUSH 2 (natToWord WLen 290);PUSH 1 (natToWord WLen 219)] [PUSH 2 (natToWord WLen 290);PUSH 1 (natToWord WLen 219)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH A SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 292 SWAP3 SWAP2 SWAP1 PUSH [tag] 293
 O: PUSH [tag] 292 PUSH a PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 293
*)
Example BottleCastle_run_code_of_0_block_322_0: equiv_checker [PUSH 2 (natToWord WLen 292);PUSH 1 (natToWord WLen 10);PUSH 1 (natToWord WLen 32);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 2 (natToWord WLen 293)] [DUP 1;PUSH 1 (natToWord WLen 10);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;PUSH 2 (natToWord WLen 292);DUP 3;DUP 2;DUP 1;PUSH 2 (natToWord WLen 293)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_run_code_of_0_block_323_0: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 10 PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FF AND DUP2
 O: PUSH 0 PUSH 100 EXP PUSH 10 SLOAD DIV PUSH ff AND DUP2
*)
Example BottleCastle_run_code_of_0_block_324_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 256);Opcode EXP;PUSH 1 (natToWord WLen 16);Opcode SLOAD;Opcode DIV;PUSH 1 (natToWord WLen 255);Opcode AND;DUP 2] [PUSH 1 (natToWord WLen 16);PUSH 1 (natToWord WLen 0);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 1;Opcode DIV;PUSH 1 (natToWord WLen 255);Opcode AND;DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 295 DUP3 PUSH [tag] 250
 O: PUSH 0 PUSH [tag] 295 DUP3 PUSH [tag] 250
*)
Example BottleCastle_run_code_of_0_block_325_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 295);DUP 3;PUSH 1 (natToWord WLen 250)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 295);DUP 3;PUSH 1 (natToWord WLen 250)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_326_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH A DUP1 SLOAD PUSH [tag] 296 SWAP1 PUSH [tag] 223
 O: PUSH a PUSH [tag] 296 DUP2 SLOAD PUSH [tag] 223
*)
Example BottleCastle_run_code_of_0_block_327_0: equiv_checker [PUSH 1 (natToWord WLen 10);PUSH 2 (natToWord WLen 296);DUP 2;Opcode SLOAD;PUSH 1 (natToWord WLen 223)] [PUSH 1 (natToWord WLen 10);DUP 1;Opcode SLOAD;PUSH 2 (natToWord WLen 296);DUP 1;PUSH 1 (natToWord WLen 223)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Example BottleCastle_run_code_of_0_block_328_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);DUP 1;PUSH 1 (natToWord WLen 31);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (natToWord WLen 64)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode ADD;PUSH 1 (natToWord WLen 32);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (natToWord WLen 64)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Example BottleCastle_run_code_of_0_block_328_1: equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 297 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 297 DUP5 SLOAD PUSH [tag] 223
*)
Example BottleCastle_run_code_of_0_block_328_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;PUSH 2 (natToWord WLen 297);DUP 5;Opcode SLOAD;PUSH 1 (natToWord WLen 223)] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (natToWord WLen 297);DUP 1;PUSH 1 (natToWord WLen 223)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 ISZERO PUSH [tag] 298
 O: DUP1 ISZERO PUSH [tag] 298
*)
Example BottleCastle_run_code_of_0_block_329_0: equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 298)] [DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 298)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 299
 O: DUP1 PUSH 1f LT PUSH [tag] 299
*)
Example BottleCastle_run_code_of_0_block_330_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 2 (natToWord WLen 299)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 2 (natToWord WLen 299)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Example BottleCastle_run_code_of_0_block_331_0: equiv_checker [PUSH 2 (natToWord WLen 256);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (natToWord WLen 256);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 298
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 298
*)
Example BottleCastle_run_code_of_0_block_331_1: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 2 (natToWord WLen 298)] [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 2 (natToWord WLen 298)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_332_0: equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 0)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 0)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Example BottleCastle_run_code_of_0_block_332_1: equiv_checker [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Example BottleCastle_run_code_of_0_block_333_0: equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 300
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 300
*)
Example BottleCastle_run_code_of_0_block_333_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (natToWord WLen 300)] [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (natToWord WLen 300)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Example BottleCastle_run_code_of_0_block_334_0: equiv_checker [PUSH 1 (natToWord WLen 31);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (natToWord WLen 31);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP POP DUP2
 O: POP POP POP POP POP DUP2
*)
Example BottleCastle_run_code_of_0_block_335_0: equiv_checker [POP;POP;POP;POP;POP;DUP 2] [POP;POP;POP;POP;POP;DUP 2] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 302
 O: PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 AND DUP2 PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ ISZERO PUSH [tag] 302
*)
Example BottleCastle_run_code_of_0_block_336_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 3;Opcode AND;DUP 2;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 302)] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 3;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 302)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 8F4EB60400000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8f4eb60400000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_337_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 64819807644134710066304724416489703438357943037160469798164574604444221571072);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 64819807644134710066304724416489703438357943037160469798164574604444221571072);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_337_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH FFFFFFFFFFFFFFFF PUSH 5 PUSH 0 DUP5 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH ffffffffffffffff PUSH 5 PUSH 0 DUP5 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Example BottleCastle_run_code_of_0_block_338_0: equiv_checker [PUSH 8 (natToWord WLen 18446744073709551615);PUSH 1 (natToWord WLen 5);PUSH 1 (natToWord WLen 0);DUP 5;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] [PUSH 8 (natToWord WLen 18446744073709551615);PUSH 1 (natToWord WLen 5);PUSH 1 (natToWord WLen 0);DUP 5;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_338_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_338_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;Opcode AND;DUP 2;POP;POP;DUP 1] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 304 PUSH [tag] 219
 O: PUSH [tag] 304 PUSH [tag] 219
*)
Example BottleCastle_run_code_of_0_block_339_0: equiv_checker [PUSH 2 (natToWord WLen 304);PUSH 1 (natToWord WLen 219)] [PUSH 2 (natToWord WLen 304);PUSH 1 (natToWord WLen 219)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 306 PUSH 0 PUSH [tag] 307
 O: PUSH [tag] 306 PUSH 0 PUSH [tag] 307
*)
Example BottleCastle_run_code_of_0_block_340_0: equiv_checker [PUSH 2 (natToWord WLen 306);PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 307)] [PUSH 2 (natToWord WLen 306);PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 307)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 60 PUSH 0 DUP1 PUSH 0 PUSH [tag] 309 DUP6 PUSH [tag] 129
 O: PUSH 60 PUSH 0 DUP1 DUP1 PUSH [tag] 309 DUP6 PUSH [tag] 129
*)
Example BottleCastle_run_code_of_0_block_342_0: equiv_checker [PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 0);DUP 1;DUP 1;PUSH 2 (natToWord WLen 309);DUP 6;PUSH 1 (natToWord WLen 129)] [PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 309);DUP 6;PUSH 1 (natToWord WLen 129)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP PUSH 0 DUP2 PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 310
 O: SWAP1 POP PUSH 0 DUP2 PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 310
*)
Example BottleCastle_run_code_of_0_block_343_0: equiv_checker [DUP 1;POP;PUSH 1 (natToWord WLen 0);DUP 2;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 310)] [DUP 1;POP;PUSH 1 (natToWord WLen 0);DUP 2;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 310)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 311 PUSH [tag] 312
 O: PUSH [tag] 311 PUSH [tag] 312
*)
Example BottleCastle_run_code_of_0_block_344_0: equiv_checker [PUSH 2 (natToWord WLen 311);PUSH 2 (natToWord WLen 312)] [PUSH 2 (natToWord WLen 311);PUSH 2 (natToWord WLen 312)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD SWAP1 DUP1 DUP3
 O: DUP1 PUSH 40 MLOAD SWAP2 DUP3
*)
Example BottleCastle_run_code_of_0_block_346_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 2;DUP 3] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 1;DUP 3] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 20 MUL PUSH 20 ADD DUP3 ADD PUSH 40
 O: PUSH 20 DUP1 DUP3 MUL ADD DUP3 ADD PUSH 40
*)
Example BottleCastle_run_code_of_0_block_346_1: equiv_checker [PUSH 1 (natToWord WLen 32);DUP 1;DUP 3;Opcode MUL;Opcode ADD;DUP 3;Opcode ADD;PUSH 1 (natToWord WLen 64)] [DUP 1;PUSH 1 (natToWord WLen 32);Opcode MUL;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;Opcode ADD;PUSH 1 (natToWord WLen 64)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 ISZERO PUSH [tag] 313
 O: DUP1 ISZERO PUSH [tag] 313
*)
Example BottleCastle_run_code_of_0_block_346_2: equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 313)] [DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 313)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 PUSH 20 ADD PUSH 20 DUP3 MUL DUP1 CALLDATASIZE DUP4
 O: PUSH 20 DUP3 ADD DUP2 PUSH 20 MUL DUP1 CALLDATASIZE DUP4
*)
Example BottleCastle_run_code_of_0_block_347_0: equiv_checker [PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 2;PUSH 1 (natToWord WLen 32);Opcode MUL;DUP 1;Opcode CALLDATASIZE;DUP 4] [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 32);DUP 3;Opcode MUL;DUP 1;Opcode CALLDATASIZE;DUP 4] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 DUP3 ADD SWAP2 POP POP SWAP1 POP
 O: ADD SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_347_1: equiv_checker [Opcode ADD;DUP 1;POP] [DUP 1;DUP 3;Opcode ADD;DUP 2;POP;POP;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP1 POP PUSH [tag] 314 PUSH [tag] 315
 O: POP SWAP1 POP PUSH [tag] 314 PUSH [tag] 315
*)
Example BottleCastle_run_code_of_0_block_348_0: equiv_checker [POP;DUP 1;POP;PUSH 2 (natToWord WLen 314);PUSH 2 (natToWord WLen 315)] [POP;DUP 1;POP;PUSH 2 (natToWord WLen 314);PUSH 2 (natToWord WLen 315)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 319 PUSH [tag] 247
 O: PUSH 0 PUSH [tag] 319 PUSH [tag] 247
*)
Example BottleCastle_run_code_of_0_block_349_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 319);PUSH 1 (natToWord WLen 247)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 319);PUSH 1 (natToWord WLen 247)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP
 O: SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_350_0: equiv_checker [DUP 1;POP] [DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP4 DUP7 EQ PUSH [tag] 317
 O: DUP4 DUP7 EQ PUSH [tag] 317
*)
Example BottleCastle_run_code_of_0_block_351_0: equiv_checker [DUP 4;DUP 7;Opcode EQ;PUSH 2 (natToWord WLen 317)] [DUP 4;DUP 7;Opcode EQ;PUSH 2 (natToWord WLen 317)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 320 DUP2 PUSH [tag] 321
 O: PUSH [tag] 320 DUP2 PUSH [tag] 321
*)
Example BottleCastle_run_code_of_0_block_352_0: equiv_checker [PUSH 2 (natToWord WLen 320);DUP 2;PUSH 2 (natToWord WLen 321)] [PUSH 2 (natToWord WLen 320);DUP 2;PUSH 2 (natToWord WLen 321)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP DUP2 PUSH 40 ADD MLOAD ISZERO PUSH [tag] 322
 O: SWAP2 POP PUSH 40 DUP3 ADD MLOAD ISZERO PUSH [tag] 322
*)
Example BottleCastle_run_code_of_0_block_353_0: equiv_checker [DUP 2;POP;PUSH 1 (natToWord WLen 64);DUP 3;Opcode ADD;Opcode MLOAD;Opcode ISZERO;PUSH 2 (natToWord WLen 322)] [DUP 2;POP;DUP 2;PUSH 1 (natToWord WLen 64);Opcode ADD;Opcode MLOAD;Opcode ISZERO;PUSH 2 (natToWord WLen 322)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 318
 O: PUSH [tag] 318
*)
Example BottleCastle_run_code_of_0_block_354_0: equiv_checker [PUSH 2 (natToWord WLen 318)] [PUSH 2 (natToWord WLen 318)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH 0 ADD MLOAD PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ PUSH [tag] 323
 O: PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 PUSH 0 ADD MLOAD AND PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ PUSH [tag] 323
*)
Example BottleCastle_run_code_of_0_block_355_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 3;PUSH 1 (natToWord WLen 0);Opcode ADD;Opcode MLOAD;Opcode AND;PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;PUSH 2 (natToWord WLen 323)] [PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 3;PUSH 1 (natToWord WLen 0);Opcode ADD;Opcode MLOAD;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;PUSH 2 (natToWord WLen 323)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 PUSH 0 ADD MLOAD SWAP5 POP
 O: PUSH 0 DUP3 ADD MLOAD SWAP5 POP
*)
Example BottleCastle_run_code_of_0_block_356_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 3;Opcode ADD;Opcode MLOAD;DUP 5;POP] [DUP 2;PUSH 1 (natToWord WLen 0);Opcode ADD;Opcode MLOAD;DUP 5;POP] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP8 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 324
 O: PUSH ffffffffffffffffffffffffffffffffffffffff DUP6 AND DUP9 PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ ISZERO PUSH [tag] 324
*)
Example BottleCastle_run_code_of_0_block_357_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 6;Opcode AND;DUP 9;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 324)] [DUP 8;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 6;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 324)] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 DUP4 DUP8 DUP1 PUSH 1 ADD SWAP9 POP DUP2 MLOAD DUP2 LT PUSH [tag] 325
 O: DUP1 DUP4 PUSH 1 DUP9 ADD SWAP8 DUP2 MLOAD DUP2 LT PUSH [tag] 325
*)
Example BottleCastle_run_code_of_0_block_358_0: equiv_checker [DUP 1;DUP 4;PUSH 1 (natToWord WLen 1);DUP 9;Opcode ADD;DUP 8;DUP 2;Opcode MLOAD;DUP 2;Opcode LT;PUSH 2 (natToWord WLen 325)] [DUP 1;DUP 4;DUP 8;DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 9;POP;DUP 2;Opcode MLOAD;DUP 2;Opcode LT;PUSH 2 (natToWord WLen 325)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 326 PUSH [tag] 327
 O: PUSH [tag] 326 PUSH [tag] 327
*)
Example BottleCastle_run_code_of_0_block_359_0: equiv_checker [PUSH 2 (natToWord WLen 326);PUSH 2 (natToWord WLen 327)] [PUSH 2 (natToWord WLen 326);PUSH 2 (natToWord WLen 327)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 MUL PUSH 20 ADD ADD DUP2 DUP2
 O: PUSH 20 MUL PUSH 20 ADD ADD DUP2 DUP2
*)
Example BottleCastle_run_code_of_0_block_361_0: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode MUL;PUSH 1 (natToWord WLen 32);Opcode ADD;Opcode ADD;DUP 2;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode MUL;PUSH 1 (natToWord WLen 32);Opcode ADD;Opcode ADD;DUP 2;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_run_code_of_0_block_361_1: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1 ADD SWAP1 POP PUSH [tag] 316
 O: PUSH 1 ADD PUSH [tag] 316
*)
Example BottleCastle_run_code_of_0_block_363_0: equiv_checker [PUSH 1 (natToWord WLen 1);Opcode ADD;PUSH 2 (natToWord WLen 316)] [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;POP;PUSH 2 (natToWord WLen 316)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP DUP2 SWAP6 POP POP POP POP POP POP SWAP2 SWAP1 POP
 O: POP POP SWAP5 POP POP POP POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_364_0: equiv_checker [POP;POP;DUP 5;POP;POP;POP;POP;POP;DUP 1] [POP;DUP 2;DUP 6;POP;POP;POP;POP;POP;POP;DUP 2;DUP 1;POP] 9 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 8 PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1 POP SWAP1
 O: PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 PUSH 100 EXP PUSH 8 SLOAD DIV AND SWAP1
*)
Example BottleCastle_run_code_of_0_block_365_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 256);Opcode EXP;PUSH 1 (natToWord WLen 8);Opcode SLOAD;Opcode DIV;Opcode AND;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 8);PUSH 1 (natToWord WLen 0);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 1;Opcode DIV;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 1;POP;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 330 PUSH [tag] 219
 O: PUSH [tag] 330 PUSH [tag] 219
*)
Example BottleCastle_run_code_of_0_block_366_0: equiv_checker [PUSH 2 (natToWord WLen 330);PUSH 1 (natToWord WLen 219)] [PUSH 2 (natToWord WLen 330);PUSH 1 (natToWord WLen 219)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 10 PUSH 1 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1
 O: DUP1 PUSH 10 DUP2 ISZERO PUSH 1 PUSH 100 EXP PUSH ff DUP2 MUL NOT DUP4 SLOAD AND SWAP2 ISZERO MUL OR SWAP1
*)
Example BottleCastle_run_code_of_0_block_367_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 16);DUP 2;Opcode ISZERO;PUSH 1 (natToWord WLen 1);PUSH 2 (natToWord WLen 256);Opcode EXP;PUSH 1 (natToWord WLen 255);DUP 2;Opcode MUL;Opcode NOT;DUP 4;Opcode SLOAD;Opcode AND;DUP 2;Opcode ISZERO;Opcode MUL;Opcode OR;DUP 1] [DUP 1;PUSH 1 (natToWord WLen 16);PUSH 1 (natToWord WLen 1);PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 1 (natToWord WLen 255);Opcode MUL;Opcode NOT;Opcode AND;DUP 1;DUP 4;Opcode ISZERO;Opcode ISZERO;Opcode MUL;Opcode OR;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_run_code_of_0_block_367_1: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 60 PUSH 3 DUP1 SLOAD PUSH [tag] 333 SWAP1 PUSH [tag] 223
 O: PUSH 60 PUSH 3 PUSH [tag] 333 DUP2 SLOAD PUSH [tag] 223
*)
Example BottleCastle_run_code_of_0_block_368_0: equiv_checker [PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 3);PUSH 2 (natToWord WLen 333);DUP 2;Opcode SLOAD;PUSH 1 (natToWord WLen 223)] [PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 3);DUP 1;Opcode SLOAD;PUSH 2 (natToWord WLen 333);DUP 1;PUSH 1 (natToWord WLen 223)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Example BottleCastle_run_code_of_0_block_369_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);DUP 1;PUSH 1 (natToWord WLen 31);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (natToWord WLen 64)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode ADD;PUSH 1 (natToWord WLen 32);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (natToWord WLen 64)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Example BottleCastle_run_code_of_0_block_369_1: equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 334 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 334 DUP5 SLOAD PUSH [tag] 223
*)
Example BottleCastle_run_code_of_0_block_369_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;PUSH 2 (natToWord WLen 334);DUP 5;Opcode SLOAD;PUSH 1 (natToWord WLen 223)] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (natToWord WLen 334);DUP 1;PUSH 1 (natToWord WLen 223)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 ISZERO PUSH [tag] 335
 O: DUP1 ISZERO PUSH [tag] 335
*)
Example BottleCastle_run_code_of_0_block_370_0: equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 335)] [DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 335)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 336
 O: DUP1 PUSH 1f LT PUSH [tag] 336
*)
Example BottleCastle_run_code_of_0_block_371_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 2 (natToWord WLen 336)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 2 (natToWord WLen 336)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Example BottleCastle_run_code_of_0_block_372_0: equiv_checker [PUSH 2 (natToWord WLen 256);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (natToWord WLen 256);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 335
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 335
*)
Example BottleCastle_run_code_of_0_block_372_1: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 2 (natToWord WLen 335)] [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 2 (natToWord WLen 335)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_373_0: equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 0)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 0)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Example BottleCastle_run_code_of_0_block_373_1: equiv_checker [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Example BottleCastle_run_code_of_0_block_374_0: equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 337
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 337
*)
Example BottleCastle_run_code_of_0_block_374_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (natToWord WLen 337)] [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (natToWord WLen 337)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Example BottleCastle_run_code_of_0_block_375_0: equiv_checker [PUSH 1 (natToWord WLen 31);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (natToWord WLen 31);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP POP SWAP1 POP SWAP1
 O: POP POP POP POP POP SWAP2 SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_376_0: equiv_checker [POP;POP;POP;POP;POP;DUP 2;DUP 1;POP] [POP;POP;POP;POP;POP;DUP 1;POP;DUP 1] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 2 PUSH 9 SLOAD EQ ISZERO PUSH [tag] 339
 O: PUSH 2 PUSH 9 SLOAD EQ ISZERO PUSH [tag] 339
*)
Example BottleCastle_run_code_of_0_block_377_0: equiv_checker [PUSH 1 (natToWord WLen 2);PUSH 1 (natToWord WLen 9);Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 339)] [PUSH 1 (natToWord WLen 2);PUSH 1 (natToWord WLen 9);Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 339)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_378_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH [tag] 340 SWAP1 PUSH [tag] 279
 O: PUSH [tag] 340 SWAP1 PUSH 4 ADD PUSH [tag] 279
*)
Example BottleCastle_run_code_of_0_block_378_1: equiv_checker [PUSH 2 (natToWord WLen 340);DUP 1;PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 279)] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 340);DUP 1;PUSH 2 (natToWord WLen 279)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_379_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 2 PUSH 9 DUP2 SWAP1
 O: PUSH 2 DUP1 PUSH 9
*)
Example BottleCastle_run_code_of_0_block_380_0: equiv_checker [PUSH 1 (natToWord WLen 2);DUP 1;PUSH 1 (natToWord WLen 9)] [PUSH 1 (natToWord WLen 2);PUSH 1 (natToWord WLen 9);DUP 2;DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 10 PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FF AND ISZERO PUSH [tag] 342
 O: POP PUSH 0 PUSH 100 EXP PUSH 10 SLOAD DIV PUSH ff AND ISZERO PUSH [tag] 342
*)
Example BottleCastle_run_code_of_0_block_380_1: equiv_checker [POP;PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 256);Opcode EXP;PUSH 1 (natToWord WLen 16);Opcode SLOAD;Opcode DIV;PUSH 1 (natToWord WLen 255);Opcode AND;Opcode ISZERO;PUSH 2 (natToWord WLen 342)] [POP;PUSH 1 (natToWord WLen 16);PUSH 1 (natToWord WLen 0);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 1;Opcode DIV;PUSH 1 (natToWord WLen 255);Opcode AND;Opcode ISZERO;PUSH 2 (natToWord WLen 342)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_381_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH [tag] 343 SWAP1 PUSH [tag] 344
 O: PUSH [tag] 343 SWAP1 PUSH 4 ADD PUSH [tag] 344
*)
Example BottleCastle_run_code_of_0_block_381_1: equiv_checker [PUSH 2 (natToWord WLen 343);DUP 1;PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 344)] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 343);DUP 1;PUSH 2 (natToWord WLen 344)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_382_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH F SLOAD DUP2 GT ISZERO PUSH [tag] 345
 O: PUSH f SLOAD DUP2 GT ISZERO PUSH [tag] 345
*)
Example BottleCastle_run_code_of_0_block_383_0: equiv_checker [PUSH 1 (natToWord WLen 15);Opcode SLOAD;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 345)] [PUSH 1 (natToWord WLen 15);Opcode SLOAD;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 345)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_384_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH [tag] 346 SWAP1 PUSH [tag] 347
 O: PUSH [tag] 346 SWAP1 PUSH 4 ADD PUSH [tag] 347
*)
Example BottleCastle_run_code_of_0_block_384_1: equiv_checker [PUSH 2 (natToWord WLen 346);DUP 1;PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 347)] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 346);DUP 1;PUSH 2 (natToWord WLen 347)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_385_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH E SLOAD DUP2 PUSH [tag] 348 PUSH [tag] 86
 O: PUSH e SLOAD DUP2 PUSH [tag] 348 PUSH [tag] 86
*)
Example BottleCastle_run_code_of_0_block_386_0: equiv_checker [PUSH 1 (natToWord WLen 14);Opcode SLOAD;DUP 2;PUSH 2 (natToWord WLen 348);PUSH 1 (natToWord WLen 86)] [PUSH 1 (natToWord WLen 14);Opcode SLOAD;DUP 2;PUSH 2 (natToWord WLen 348);PUSH 1 (natToWord WLen 86)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 349 SWAP2 SWAP1 PUSH [tag] 350
 O: SWAP1 PUSH [tag] 349 SWAP2 PUSH [tag] 350
*)
Example BottleCastle_run_code_of_0_block_387_0: equiv_checker [DUP 1;PUSH 2 (natToWord WLen 349);DUP 2;PUSH 2 (natToWord WLen 350)] [PUSH 2 (natToWord WLen 349);DUP 2;DUP 1;PUSH 2 (natToWord WLen 350)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: GT ISZERO PUSH [tag] 351
 O: GT ISZERO PUSH [tag] 351
*)
Example BottleCastle_run_code_of_0_block_388_0: equiv_checker [Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 351)] [Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 351)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_389_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH [tag] 352 SWAP1 PUSH [tag] 353
 O: PUSH [tag] 352 SWAP1 PUSH 4 ADD PUSH [tag] 353
*)
Example BottleCastle_run_code_of_0_block_389_1: equiv_checker [PUSH 2 (natToWord WLen 352);DUP 1;PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 353)] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 352);DUP 1;PUSH 2 (natToWord WLen 353)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_390_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH F SLOAD DUP2 PUSH [tag] 354 PUSH [tag] 355 PUSH [tag] 240
 O: PUSH f SLOAD DUP2 PUSH [tag] 354 PUSH [tag] 355 PUSH [tag] 240
*)
Example BottleCastle_run_code_of_0_block_391_0: equiv_checker [PUSH 1 (natToWord WLen 15);Opcode SLOAD;DUP 2;PUSH 2 (natToWord WLen 354);PUSH 2 (natToWord WLen 355);PUSH 1 (natToWord WLen 240)] [PUSH 1 (natToWord WLen 15);Opcode SLOAD;DUP 2;PUSH 2 (natToWord WLen 354);PUSH 2 (natToWord WLen 355);PUSH 1 (natToWord WLen 240)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 356
 O: PUSH [tag] 356
*)
Example BottleCastle_run_code_of_0_block_392_0: equiv_checker [PUSH 2 (natToWord WLen 356)] [PUSH 2 (natToWord WLen 356)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 357 SWAP2 SWAP1 PUSH [tag] 350
 O: SWAP1 PUSH [tag] 357 SWAP2 PUSH [tag] 350
*)
Example BottleCastle_run_code_of_0_block_393_0: equiv_checker [DUP 1;PUSH 2 (natToWord WLen 357);DUP 2;PUSH 2 (natToWord WLen 350)] [PUSH 2 (natToWord WLen 357);DUP 2;DUP 1;PUSH 2 (natToWord WLen 350)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: GT ISZERO PUSH [tag] 358
 O: GT ISZERO PUSH [tag] 358
*)
Example BottleCastle_run_code_of_0_block_394_0: equiv_checker [Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 358)] [Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 358)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_395_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH [tag] 359 SWAP1 PUSH [tag] 360
 O: PUSH [tag] 359 SWAP1 PUSH 4 ADD PUSH [tag] 360
*)
Example BottleCastle_run_code_of_0_block_395_1: equiv_checker [PUSH 2 (natToWord WLen 359);DUP 1;PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 360)] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 359);DUP 1;PUSH 2 (natToWord WLen 360)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_396_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH D SLOAD PUSH [tag] 361 SWAP2 SWAP1 PUSH [tag] 362
 O: PUSH [tag] 361 DUP2 PUSH d SLOAD PUSH [tag] 362
*)
Example BottleCastle_run_code_of_0_block_397_0: equiv_checker [PUSH 2 (natToWord WLen 361);DUP 2;PUSH 1 (natToWord WLen 13);Opcode SLOAD;PUSH 2 (natToWord WLen 362)] [DUP 1;PUSH 1 (natToWord WLen 13);Opcode SLOAD;PUSH 2 (natToWord WLen 361);DUP 2;DUP 1;PUSH 2 (natToWord WLen 362)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE LT ISZERO PUSH [tag] 363
 O: CALLVALUE LT ISZERO PUSH [tag] 363
*)
Example BottleCastle_run_code_of_0_block_398_0: equiv_checker [Opcode CALLVALUE;Opcode LT;Opcode ISZERO;PUSH 2 (natToWord WLen 363)] [Opcode CALLVALUE;Opcode LT;Opcode ISZERO;PUSH 2 (natToWord WLen 363)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_399_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH [tag] 364 SWAP1 PUSH [tag] 365
 O: PUSH [tag] 364 SWAP1 PUSH 4 ADD PUSH [tag] 365
*)
Example BottleCastle_run_code_of_0_block_399_1: equiv_checker [PUSH 2 (natToWord WLen 364);DUP 1;PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 365)] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 364);DUP 1;PUSH 2 (natToWord WLen 365)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_400_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 366 PUSH [tag] 367 PUSH [tag] 240
 O: PUSH [tag] 366 PUSH [tag] 367 PUSH [tag] 240
*)
Example BottleCastle_run_code_of_0_block_401_0: equiv_checker [PUSH 2 (natToWord WLen 366);PUSH 2 (natToWord WLen 367);PUSH 1 (natToWord WLen 240)] [PUSH 2 (natToWord WLen 366);PUSH 2 (natToWord WLen 367);PUSH 1 (natToWord WLen 240)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 PUSH [tag] 368
 O: DUP3 PUSH [tag] 368
*)
Example BottleCastle_run_code_of_0_block_402_0: equiv_checker [DUP 3;PUSH 2 (natToWord WLen 368)] [DUP 3;PUSH 2 (natToWord WLen 368)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 1 PUSH 9 DUP2 SWAP1
 O: PUSH 1 DUP1 PUSH 9
*)
Example BottleCastle_run_code_of_0_block_403_0: equiv_checker [PUSH 1 (natToWord WLen 1);DUP 1;PUSH 1 (natToWord WLen 9)] [PUSH 1 (natToWord WLen 1);PUSH 1 (natToWord WLen 9);DUP 2;DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_run_code_of_0_block_403_1: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 370 PUSH [tag] 240
 O: PUSH [tag] 370 PUSH [tag] 240
*)
Example BottleCastle_run_code_of_0_block_404_0: equiv_checker [PUSH 2 (natToWord WLen 370);PUSH 1 (natToWord WLen 240)] [PUSH 2 (natToWord WLen 370);PUSH 1 (natToWord WLen 240)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 371
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP3 PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ ISZERO PUSH [tag] 371
*)
Example BottleCastle_run_code_of_0_block_405_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 3;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 371)] [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 3;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 371)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH B06307DB00000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH b06307db00000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_406_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 79782033426520692042270425721413825578667320047716007783072387518728457158656);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 79782033426520692042270425721413825578667320047716007783072387518728457158656);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_406_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 7 PUSH 0 PUSH [tag] 372 PUSH [tag] 240
 O: DUP1 PUSH 7 PUSH 0 PUSH [tag] 372 PUSH [tag] 240
*)
Example BottleCastle_run_code_of_0_block_407_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 7);PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 372);PUSH 1 (natToWord WLen 240)] [DUP 1;PUSH 1 (natToWord WLen 7);PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 372);PUSH 1 (natToWord WLen 240)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Example BottleCastle_run_code_of_0_block_408_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_408_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP5 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP1 DUP7 AND AND DUP2
*)
Example BottleCastle_run_code_of_0_block_408_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 1;DUP 7;Opcode AND;Opcode AND;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);DUP 5;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_408_3: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH 100 EXP PUSH ff DUP2 DUP5 ISZERO ISZERO MUL SWAP2 MUL NOT DUP3 SLOAD AND OR SWAP1
*)
Example BottleCastle_run_code_of_0_block_408_4: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 256);Opcode EXP;PUSH 1 (natToWord WLen 255);DUP 2;DUP 5;Opcode ISZERO;Opcode ISZERO;Opcode MUL;DUP 2;Opcode MUL;Opcode NOT;DUP 3;Opcode SLOAD;Opcode AND;Opcode OR;DUP 1] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 1 (natToWord WLen 255);Opcode MUL;Opcode NOT;Opcode AND;DUP 1;DUP 4;Opcode ISZERO;Opcode ISZERO;Opcode MUL;Opcode OR;DUP 1] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH [tag] 373 PUSH [tag] 240
 O: POP PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 AND PUSH [tag] 373 PUSH [tag] 240
*)
Example BottleCastle_run_code_of_0_block_408_5: equiv_checker [POP;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 3;Opcode AND;PUSH 2 (natToWord WLen 373);PUSH 1 (natToWord WLen 240)] [POP;DUP 2;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 2 (natToWord WLen 373);PUSH 1 (natToWord WLen 240)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C31 DUP4 PUSH 40 MLOAD PUSH [tag] 374 SWAP2 SWAP1 PUSH [tag] 52
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH 17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31 PUSH [tag] 374 DUP5 PUSH 40 MLOAD PUSH [tag] 52
*)
Example BottleCastle_run_code_of_0_block_409_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 32 (natToWord WLen 10488878412788366941768124514102328501031624832915735463117339209566108871729);PUSH 2 (natToWord WLen 374);DUP 5;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 52)] [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 32 (natToWord WLen 10488878412788366941768124514102328501031624832915735463117339209566108871729);DUP 4;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 2 (natToWord WLen 374);DUP 2;DUP 1;PUSH 1 (natToWord WLen 52)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_410_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_run_code_of_0_block_410_1: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 376 DUP5 DUP5 DUP5 PUSH [tag] 92
 O: PUSH [tag] 376 DUP5 DUP5 DUP5 PUSH [tag] 92
*)
Example BottleCastle_run_code_of_0_block_411_0: equiv_checker [PUSH 2 (natToWord WLen 376);DUP 5;DUP 5;DUP 5;PUSH 1 (natToWord WLen 92)] [PUSH 2 (natToWord WLen 376);DUP 5;DUP 5;DUP 5;PUSH 1 (natToWord WLen 92)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EXTCODESIZE EQ PUSH [tag] 377
 O: PUSH 0 DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff AND EXTCODESIZE EQ PUSH [tag] 377
*)
Example BottleCastle_run_code_of_0_block_412_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EXTCODESIZE;Opcode EQ;PUSH 2 (natToWord WLen 377)] [PUSH 1 (natToWord WLen 0);DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EXTCODESIZE;Opcode EQ;PUSH 2 (natToWord WLen 377)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 378 DUP5 DUP5 DUP5 DUP5 PUSH [tag] 379
 O: PUSH [tag] 378 DUP5 DUP5 DUP5 DUP5 PUSH [tag] 379
*)
Example BottleCastle_run_code_of_0_block_413_0: equiv_checker [PUSH 2 (natToWord WLen 378);DUP 5;DUP 5;DUP 5;DUP 5;PUSH 2 (natToWord WLen 379)] [PUSH 2 (natToWord WLen 378);DUP 5;DUP 5;DUP 5;DUP 5;PUSH 2 (natToWord WLen 379)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 380
 O: PUSH [tag] 380
*)
Example BottleCastle_run_code_of_0_block_414_0: equiv_checker [PUSH 2 (natToWord WLen 380)] [PUSH 2 (natToWord WLen 380)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH D1A57ED600000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH d1a57ed600000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_415_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 94825790509059390965680126405351569353353206259496993755816944651398402801664);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 94825790509059390965680126405351569353353206259496993755816944651398402801664);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_415_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Example BottleCastle_run_code_of_0_block_417_0: equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 382 PUSH [tag] 219
 O: PUSH [tag] 382 PUSH [tag] 219
*)
Example BottleCastle_run_code_of_0_block_418_0: equiv_checker [PUSH 2 (natToWord WLen 382);PUSH 1 (natToWord WLen 219)] [PUSH 2 (natToWord WLen 382);PUSH 1 (natToWord WLen 219)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 2 PUSH 9 SLOAD EQ ISZERO PUSH [tag] 384
 O: PUSH 2 PUSH 9 SLOAD EQ ISZERO PUSH [tag] 384
*)
Example BottleCastle_run_code_of_0_block_419_0: equiv_checker [PUSH 1 (natToWord WLen 2);PUSH 1 (natToWord WLen 9);Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 384)] [PUSH 1 (natToWord WLen 2);PUSH 1 (natToWord WLen 9);Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 384)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_420_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH [tag] 385 SWAP1 PUSH [tag] 279
 O: PUSH [tag] 385 SWAP1 PUSH 4 ADD PUSH [tag] 279
*)
Example BottleCastle_run_code_of_0_block_420_1: equiv_checker [PUSH 2 (natToWord WLen 385);DUP 1;PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 279)] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 385);DUP 1;PUSH 2 (natToWord WLen 279)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_421_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 2 PUSH 9 DUP2 SWAP1
 O: PUSH 2 DUP1 PUSH 9
*)
Example BottleCastle_run_code_of_0_block_422_0: equiv_checker [PUSH 1 (natToWord WLen 2);DUP 1;PUSH 1 (natToWord WLen 9)] [PUSH 1 (natToWord WLen 2);PUSH 1 (natToWord WLen 9);DUP 2;DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH E SLOAD DUP3 PUSH [tag] 387 PUSH [tag] 86
 O: POP PUSH e SLOAD DUP3 PUSH [tag] 387 PUSH [tag] 86
*)
Example BottleCastle_run_code_of_0_block_422_1: equiv_checker [POP;PUSH 1 (natToWord WLen 14);Opcode SLOAD;DUP 3;PUSH 2 (natToWord WLen 387);PUSH 1 (natToWord WLen 86)] [POP;PUSH 1 (natToWord WLen 14);Opcode SLOAD;DUP 3;PUSH 2 (natToWord WLen 387);PUSH 1 (natToWord WLen 86)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 388 SWAP2 SWAP1 PUSH [tag] 350
 O: SWAP1 PUSH [tag] 388 SWAP2 PUSH [tag] 350
*)
Example BottleCastle_run_code_of_0_block_423_0: equiv_checker [DUP 1;PUSH 2 (natToWord WLen 388);DUP 2;PUSH 2 (natToWord WLen 350)] [PUSH 2 (natToWord WLen 388);DUP 2;DUP 1;PUSH 2 (natToWord WLen 350)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: GT ISZERO PUSH [tag] 389
 O: GT ISZERO PUSH [tag] 389
*)
Example BottleCastle_run_code_of_0_block_424_0: equiv_checker [Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 389)] [Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 389)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_425_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH [tag] 390 SWAP1 PUSH [tag] 391
 O: PUSH [tag] 390 SWAP1 PUSH 4 ADD PUSH [tag] 391
*)
Example BottleCastle_run_code_of_0_block_425_1: equiv_checker [PUSH 2 (natToWord WLen 390);DUP 1;PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 391)] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 390);DUP 1;PUSH 2 (natToWord WLen 391)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_426_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 392 DUP2 DUP4 PUSH [tag] 368
 O: PUSH [tag] 392 DUP2 DUP4 PUSH [tag] 368
*)
Example BottleCastle_run_code_of_0_block_427_0: equiv_checker [PUSH 2 (natToWord WLen 392);DUP 2;DUP 4;PUSH 2 (natToWord WLen 368)] [PUSH 2 (natToWord WLen 392);DUP 2;DUP 4;PUSH 2 (natToWord WLen 368)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 1 PUSH 9 DUP2 SWAP1
 O: PUSH 1 DUP1 PUSH 9
*)
Example BottleCastle_run_code_of_0_block_428_0: equiv_checker [PUSH 1 (natToWord WLen 1);DUP 1;PUSH 1 (natToWord WLen 9)] [PUSH 1 (natToWord WLen 1);PUSH 1 (natToWord WLen 9);DUP 2;DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP
 O: POP POP POP
*)
Example BottleCastle_run_code_of_0_block_428_1: equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH F SLOAD DUP2
 O: PUSH f SLOAD DUP2
*)
Example BottleCastle_run_code_of_0_block_429_0: equiv_checker [PUSH 1 (natToWord WLen 15);Opcode SLOAD;DUP 2] [PUSH 1 (natToWord WLen 15);Opcode SLOAD;DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH B DUP1 SLOAD PUSH [tag] 393 SWAP1 PUSH [tag] 223
 O: PUSH b PUSH [tag] 393 DUP2 SLOAD PUSH [tag] 223
*)
Example BottleCastle_run_code_of_0_block_430_0: equiv_checker [PUSH 1 (natToWord WLen 11);PUSH 2 (natToWord WLen 393);DUP 2;Opcode SLOAD;PUSH 1 (natToWord WLen 223)] [PUSH 1 (natToWord WLen 11);DUP 1;Opcode SLOAD;PUSH 2 (natToWord WLen 393);DUP 1;PUSH 1 (natToWord WLen 223)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Example BottleCastle_run_code_of_0_block_431_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);DUP 1;PUSH 1 (natToWord WLen 31);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (natToWord WLen 64)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode ADD;PUSH 1 (natToWord WLen 32);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (natToWord WLen 64)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Example BottleCastle_run_code_of_0_block_431_1: equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 394 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 394 DUP5 SLOAD PUSH [tag] 223
*)
Example BottleCastle_run_code_of_0_block_431_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;PUSH 2 (natToWord WLen 394);DUP 5;Opcode SLOAD;PUSH 1 (natToWord WLen 223)] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (natToWord WLen 394);DUP 1;PUSH 1 (natToWord WLen 223)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 ISZERO PUSH [tag] 395
 O: DUP1 ISZERO PUSH [tag] 395
*)
Example BottleCastle_run_code_of_0_block_432_0: equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 395)] [DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 395)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 396
 O: DUP1 PUSH 1f LT PUSH [tag] 396
*)
Example BottleCastle_run_code_of_0_block_433_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 2 (natToWord WLen 396)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 2 (natToWord WLen 396)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Example BottleCastle_run_code_of_0_block_434_0: equiv_checker [PUSH 2 (natToWord WLen 256);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (natToWord WLen 256);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 395
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 395
*)
Example BottleCastle_run_code_of_0_block_434_1: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 2 (natToWord WLen 395)] [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 2 (natToWord WLen 395)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_435_0: equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 0)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 0)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Example BottleCastle_run_code_of_0_block_435_1: equiv_checker [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Example BottleCastle_run_code_of_0_block_436_0: equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 397
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 397
*)
Example BottleCastle_run_code_of_0_block_436_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (natToWord WLen 397)] [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (natToWord WLen 397)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Example BottleCastle_run_code_of_0_block_437_0: equiv_checker [PUSH 1 (natToWord WLen 31);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (natToWord WLen 31);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP POP DUP2
 O: POP POP POP POP POP DUP2
*)
Example BottleCastle_run_code_of_0_block_438_0: equiv_checker [POP;POP;POP;POP;POP;DUP 2] [POP;POP;POP;POP;POP;DUP 2] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 60 PUSH [tag] 399 DUP3 PUSH [tag] 230
 O: PUSH 60 PUSH [tag] 399 DUP3 PUSH [tag] 230
*)
Example BottleCastle_run_code_of_0_block_439_0: equiv_checker [PUSH 1 (natToWord WLen 96);PUSH 2 (natToWord WLen 399);DUP 3;PUSH 1 (natToWord WLen 230)] [PUSH 1 (natToWord WLen 96);PUSH 2 (natToWord WLen 399);DUP 3;PUSH 1 (natToWord WLen 230)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 400
 O: PUSH [tag] 400
*)
Example BottleCastle_run_code_of_0_block_440_0: equiv_checker [PUSH 2 (natToWord WLen 400)] [PUSH 2 (natToWord WLen 400)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_441_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH [tag] 401 SWAP1 PUSH [tag] 402
 O: PUSH [tag] 401 SWAP1 PUSH 4 ADD PUSH [tag] 402
*)
Example BottleCastle_run_code_of_0_block_441_1: equiv_checker [PUSH 2 (natToWord WLen 401);DUP 1;PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 402)] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 401);DUP 1;PUSH 2 (natToWord WLen 402)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_442_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 ISZERO ISZERO PUSH 10 PUSH 1 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FF AND ISZERO ISZERO EQ ISZERO PUSH [tag] 403
 O: PUSH 1 PUSH 100 EXP PUSH 10 SLOAD DIV PUSH ff AND ISZERO ISZERO PUSH 0 ISZERO ISZERO EQ ISZERO PUSH [tag] 403
*)
Example BottleCastle_run_code_of_0_block_443_0: equiv_checker [PUSH 1 (natToWord WLen 1);PUSH 2 (natToWord WLen 256);Opcode EXP;PUSH 1 (natToWord WLen 16);Opcode SLOAD;Opcode DIV;PUSH 1 (natToWord WLen 255);Opcode AND;Opcode ISZERO;Opcode ISZERO;PUSH 1 (natToWord WLen 0);Opcode ISZERO;Opcode ISZERO;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 403)] [PUSH 1 (natToWord WLen 0);Opcode ISZERO;Opcode ISZERO;PUSH 1 (natToWord WLen 16);PUSH 1 (natToWord WLen 1);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 1;Opcode DIV;PUSH 1 (natToWord WLen 255);Opcode AND;Opcode ISZERO;Opcode ISZERO;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 403)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH C DUP1 SLOAD PUSH [tag] 404 SWAP1 PUSH [tag] 223
 O: PUSH c PUSH [tag] 404 DUP2 SLOAD PUSH [tag] 223
*)
Example BottleCastle_run_code_of_0_block_444_0: equiv_checker [PUSH 1 (natToWord WLen 12);PUSH 2 (natToWord WLen 404);DUP 2;Opcode SLOAD;PUSH 1 (natToWord WLen 223)] [PUSH 1 (natToWord WLen 12);DUP 1;Opcode SLOAD;PUSH 2 (natToWord WLen 404);DUP 1;PUSH 1 (natToWord WLen 223)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Example BottleCastle_run_code_of_0_block_445_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);DUP 1;PUSH 1 (natToWord WLen 31);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (natToWord WLen 64)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode ADD;PUSH 1 (natToWord WLen 32);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (natToWord WLen 64)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Example BottleCastle_run_code_of_0_block_445_1: equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 405 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 405 DUP5 SLOAD PUSH [tag] 223
*)
Example BottleCastle_run_code_of_0_block_445_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;PUSH 2 (natToWord WLen 405);DUP 5;Opcode SLOAD;PUSH 1 (natToWord WLen 223)] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (natToWord WLen 405);DUP 1;PUSH 1 (natToWord WLen 223)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 ISZERO PUSH [tag] 406
 O: DUP1 ISZERO PUSH [tag] 406
*)
Example BottleCastle_run_code_of_0_block_446_0: equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 406)] [DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 406)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 407
 O: DUP1 PUSH 1f LT PUSH [tag] 407
*)
Example BottleCastle_run_code_of_0_block_447_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 2 (natToWord WLen 407)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 2 (natToWord WLen 407)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Example BottleCastle_run_code_of_0_block_448_0: equiv_checker [PUSH 2 (natToWord WLen 256);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (natToWord WLen 256);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 406
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 406
*)
Example BottleCastle_run_code_of_0_block_448_1: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 2 (natToWord WLen 406)] [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 2 (natToWord WLen 406)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_449_0: equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 0)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 0)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Example BottleCastle_run_code_of_0_block_449_1: equiv_checker [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Example BottleCastle_run_code_of_0_block_450_0: equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 408
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 408
*)
Example BottleCastle_run_code_of_0_block_450_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (natToWord WLen 408)] [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (natToWord WLen 408)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Example BottleCastle_run_code_of_0_block_451_0: equiv_checker [PUSH 1 (natToWord WLen 31);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (natToWord WLen 31);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP POP SWAP1 POP PUSH [tag] 398
 O: POP POP POP POP POP SWAP1 POP PUSH [tag] 398
*)
Example BottleCastle_run_code_of_0_block_452_0: equiv_checker [POP;POP;POP;POP;POP;DUP 1;POP;PUSH 2 (natToWord WLen 398)] [POP;POP;POP;POP;POP;DUP 1;POP;PUSH 2 (natToWord WLen 398)] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 409 PUSH [tag] 410
 O: PUSH 0 PUSH [tag] 409 PUSH [tag] 410
*)
Example BottleCastle_run_code_of_0_block_453_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 409);PUSH 2 (natToWord WLen 410)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 409);PUSH 2 (natToWord WLen 410)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP PUSH 0 DUP2 MLOAD GT PUSH [tag] 411
 O: SWAP1 POP PUSH 0 DUP2 MLOAD GT PUSH [tag] 411
*)
Example BottleCastle_run_code_of_0_block_454_0: equiv_checker [DUP 1;POP;PUSH 1 (natToWord WLen 0);DUP 2;Opcode MLOAD;Opcode GT;PUSH 2 (natToWord WLen 411)] [DUP 1;POP;PUSH 1 (natToWord WLen 0);DUP 2;Opcode MLOAD;Opcode GT;PUSH 2 (natToWord WLen 411)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
*)
Example BottleCastle_run_code_of_0_block_455_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 0 DUP2
 O: DUP1 PUSH 0 DUP2
*)
Example BottleCastle_run_code_of_0_block_455_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 0);DUP 2] [DUP 1;PUSH 1 (natToWord WLen 0);DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 412
 O: POP PUSH [tag] 412
*)
Example BottleCastle_run_code_of_0_block_455_2: equiv_checker [POP;PUSH 2 (natToWord WLen 412)] [POP;PUSH 2 (natToWord WLen 412)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH [tag] 413 DUP5 PUSH [tag] 414
 O: DUP1 PUSH [tag] 413 DUP5 PUSH [tag] 414
*)
Example BottleCastle_run_code_of_0_block_456_0: equiv_checker [DUP 1;PUSH 2 (natToWord WLen 413);DUP 5;PUSH 2 (natToWord WLen 414)] [DUP 1;PUSH 2 (natToWord WLen 413);DUP 5;PUSH 2 (natToWord WLen 414)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH B PUSH 40 MLOAD PUSH 20 ADD PUSH [tag] 415 SWAP4 SWAP3 SWAP2 SWAP1 PUSH [tag] 416
 O: PUSH [tag] 415 SWAP2 SWAP1 PUSH b PUSH 20 PUSH 40 MLOAD ADD PUSH [tag] 416
*)
Example BottleCastle_run_code_of_0_block_457_0: equiv_checker [PUSH 2 (natToWord WLen 415);DUP 2;DUP 1;PUSH 1 (natToWord WLen 11);PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 64);Opcode MLOAD;Opcode ADD;PUSH 2 (natToWord WLen 416)] [PUSH 1 (natToWord WLen 11);PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 2 (natToWord WLen 415);DUP 4;DUP 3;DUP 2;DUP 1;PUSH 2 (natToWord WLen 416)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 20 DUP2 DUP4 SUB SUB DUP2
 O: PUSH 40 MLOAD PUSH 20 DUP2 DUP4 SUB SUB DUP2
*)
Example BottleCastle_run_code_of_0_block_458_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 32);DUP 2;DUP 4;Opcode SUB;Opcode SUB;DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 32);DUP 2;DUP 4;Opcode SUB;Opcode SUB;DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 PUSH 40
 O: SWAP1 PUSH 40
*)
Example BottleCastle_run_code_of_0_block_458_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 64)] [DUP 1;PUSH 1 (natToWord WLen 64)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP
 O: SWAP2 POP POP
*)
Example BottleCastle_run_code_of_0_block_459_0: equiv_checker [DUP 2;POP;POP] [DUP 2;POP;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_460_0: equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH E SLOAD DUP2
 O: PUSH e SLOAD DUP2
*)
Example BottleCastle_run_code_of_0_block_461_0: equiv_checker [PUSH 1 (natToWord WLen 14);Opcode SLOAD;DUP 2] [PUSH 1 (natToWord WLen 14);Opcode SLOAD;DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 418 PUSH [tag] 219
 O: PUSH [tag] 418 PUSH [tag] 219
*)
Example BottleCastle_run_code_of_0_block_462_0: equiv_checker [PUSH 2 (natToWord WLen 418);PUSH 1 (natToWord WLen 219)] [PUSH 2 (natToWord WLen 418);PUSH 1 (natToWord WLen 219)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH B SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 420 SWAP3 SWAP2 SWAP1 PUSH [tag] 293
 O: PUSH [tag] 420 PUSH b PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 293
*)
Example BottleCastle_run_code_of_0_block_463_0: equiv_checker [PUSH 2 (natToWord WLen 420);PUSH 1 (natToWord WLen 11);PUSH 1 (natToWord WLen 32);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 2 (natToWord WLen 293)] [DUP 1;PUSH 1 (natToWord WLen 11);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;PUSH 2 (natToWord WLen 420);DUP 3;DUP 2;DUP 1;PUSH 2 (natToWord WLen 293)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_run_code_of_0_block_464_0: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 422 DUP3 PUSH [tag] 356
 O: PUSH 0 PUSH [tag] 422 DUP3 PUSH [tag] 356
*)
Example BottleCastle_run_code_of_0_block_465_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 422);DUP 3;PUSH 2 (natToWord WLen 356)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 422);DUP 3;PUSH 2 (natToWord WLen 356)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_466_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 424 PUSH [tag] 219
 O: PUSH [tag] 424 PUSH [tag] 219
*)
Example BottleCastle_run_code_of_0_block_467_0: equiv_checker [PUSH 2 (natToWord WLen 424);PUSH 1 (natToWord WLen 219)] [PUSH 2 (natToWord WLen 424);PUSH 1 (natToWord WLen 219)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH F DUP2 SWAP1
 O: DUP1 DUP1 PUSH f
*)
Example BottleCastle_run_code_of_0_block_468_0: equiv_checker [DUP 1;DUP 1;PUSH 1 (natToWord WLen 15)] [DUP 1;PUSH 1 (natToWord WLen 15);DUP 2;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_run_code_of_0_block_468_1: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 7 PUSH 0 DUP5 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 0 PUSH 7 DUP2 DUP5 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Example BottleCastle_run_code_of_0_block_469_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 7);DUP 2;DUP 5;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 7);PUSH 1 (natToWord WLen 0);DUP 5;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_469_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP5 DUP2 AND AND DUP2
*)
Example BottleCastle_run_code_of_0_block_469_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 5;DUP 2;Opcode AND;Opcode AND;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_469_3: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FF AND SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP2 PUSH 0 SWAP4 POP POP POP PUSH 20 ADD DUP2 PUSH 100 EXP SWAP2 KECCAK256 SLOAD DIV PUSH ff AND SWAP1
*)
Example BottleCastle_run_code_of_0_block_469_4: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 0);DUP 4;POP;POP;POP;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 2;Opcode KECCAK256;Opcode SLOAD;Opcode DIV;PUSH 1 (natToWord WLen 255);Opcode AND;DUP 1] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 1;Opcode DIV;PUSH 1 (natToWord WLen 255);Opcode AND;DUP 1;POP;DUP 3;DUP 2;POP;POP] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 428 PUSH [tag] 219
 O: PUSH [tag] 428 PUSH [tag] 219
*)
Example BottleCastle_run_code_of_0_block_470_0: equiv_checker [PUSH 2 (natToWord WLen 428);PUSH 1 (natToWord WLen 219)] [PUSH 2 (natToWord WLen 428);PUSH 1 (natToWord WLen 219)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH C SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 430 SWAP3 SWAP2 SWAP1 PUSH [tag] 293
 O: PUSH [tag] 430 PUSH c PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 293
*)
Example BottleCastle_run_code_of_0_block_471_0: equiv_checker [PUSH 2 (natToWord WLen 430);PUSH 1 (natToWord WLen 12);PUSH 1 (natToWord WLen 32);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 2 (natToWord WLen 293)] [DUP 1;PUSH 1 (natToWord WLen 12);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;PUSH 2 (natToWord WLen 430);DUP 3;DUP 2;DUP 1;PUSH 2 (natToWord WLen 293)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_run_code_of_0_block_472_0: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 432 PUSH [tag] 219
 O: PUSH [tag] 432 PUSH [tag] 219
*)
Example BottleCastle_run_code_of_0_block_473_0: equiv_checker [PUSH 2 (natToWord WLen 432);PUSH 1 (natToWord WLen 219)] [PUSH 2 (natToWord WLen 432);PUSH 1 (natToWord WLen 219)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 434
 O: DUP1 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 AND EQ ISZERO PUSH [tag] 434
*)
Example BottleCastle_run_code_of_0_block_474_0: equiv_checker [DUP 1;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);PUSH 1 (natToWord WLen 0);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 434)] [PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 434)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_475_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH [tag] 435 SWAP1 PUSH [tag] 436
 O: PUSH [tag] 435 SWAP1 PUSH 4 ADD PUSH [tag] 436
*)
Example BottleCastle_run_code_of_0_block_475_1: equiv_checker [PUSH 2 (natToWord WLen 435);DUP 1;PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 436)] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 435);DUP 1;PUSH 2 (natToWord WLen 436)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_476_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 437 DUP2 PUSH [tag] 307
 O: PUSH [tag] 437 DUP2 PUSH [tag] 307
*)
Example BottleCastle_run_code_of_0_block_477_0: equiv_checker [PUSH 2 (natToWord WLen 437);DUP 2;PUSH 2 (natToWord WLen 307)] [PUSH 2 (natToWord WLen 437);DUP 2;PUSH 2 (natToWord WLen 307)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_478_0: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 439 PUSH [tag] 440
 O: PUSH [tag] 439 PUSH [tag] 440
*)
Example BottleCastle_run_code_of_0_block_479_0: equiv_checker [PUSH 2 (natToWord WLen 439);PUSH 2 (natToWord WLen 440)] [PUSH 2 (natToWord WLen 439);PUSH 2 (natToWord WLen 440)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH [tag] 441 PUSH [tag] 142
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH [tag] 441 PUSH [tag] 142
*)
Example BottleCastle_run_code_of_0_block_480_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 2 (natToWord WLen 441);PUSH 1 (natToWord WLen 142)] [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 2 (natToWord WLen 441);PUSH 1 (natToWord WLen 142)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ PUSH [tag] 442
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ PUSH [tag] 442
*)
Example BottleCastle_run_code_of_0_block_481_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;PUSH 2 (natToWord WLen 442)] [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;PUSH 2 (natToWord WLen 442)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 8C379A000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8c379a000000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_482_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 3963877391197344453575983046348115674221700746820753546331534351508065746944);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH [tag] 443 SWAP1 PUSH [tag] 444
 O: PUSH [tag] 443 SWAP1 PUSH 4 ADD PUSH [tag] 444
*)
Example BottleCastle_run_code_of_0_block_482_1: equiv_checker [PUSH 2 (natToWord WLen 443);DUP 1;PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 444)] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 443);DUP 1;PUSH 2 (natToWord WLen 444)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_483_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 PUSH [tag] 446 PUSH [tag] 247
 O: PUSH 0 DUP2 PUSH [tag] 446 PUSH [tag] 247
*)
Example BottleCastle_run_code_of_0_block_485_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 2;PUSH 2 (natToWord WLen 446);PUSH 1 (natToWord WLen 247)] [PUSH 1 (natToWord WLen 0);DUP 2;PUSH 2 (natToWord WLen 446);PUSH 1 (natToWord WLen 247)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: GT ISZERO DUP1 ISZERO PUSH [tag] 447
 O: GT ISZERO DUP1 ISZERO PUSH [tag] 447
*)
Example BottleCastle_run_code_of_0_block_486_0: equiv_checker [Opcode GT;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 447)] [Opcode GT;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 447)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 0 SLOAD DUP3 LT
 O: POP PUSH 0 SLOAD DUP3 LT
*)
Example BottleCastle_run_code_of_0_block_487_0: equiv_checker [POP;PUSH 1 (natToWord WLen 0);Opcode SLOAD;DUP 3;Opcode LT] [POP;PUSH 1 (natToWord WLen 0);Opcode SLOAD;DUP 3;Opcode LT] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 ISZERO PUSH [tag] 448
 O: DUP1 ISZERO PUSH [tag] 448
*)
Example BottleCastle_run_code_of_0_block_488_0: equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 448)] [DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 448)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 PUSH 4 PUSH 0 DUP6 DUP2
 O: POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 PUSH 4 DUP3 DUP6 DUP2
*)
Example BottleCastle_run_code_of_0_block_489_0: equiv_checker [POP;PUSH 1 (natToWord WLen 0);PUSH 29 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249216);PUSH 1 (natToWord WLen 4);DUP 3;DUP 6;DUP 2] [POP;PUSH 1 (natToWord WLen 0);PUSH 29 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249216);PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 6;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_489_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND EQ
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND EQ
*)
Example BottleCastle_run_code_of_0_block_489_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;Opcode AND;Opcode EQ] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;Opcode AND;Opcode EQ] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_490_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 CALLER SWAP1 POP SWAP1
 O: CALLER SWAP1
*)
Example BottleCastle_run_code_of_0_block_491_0: equiv_checker [Opcode CALLER;DUP 1] [PUSH 1 (natToWord WLen 0);Opcode CALLER;DUP 1;POP;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 1 SWAP1 POP SWAP1
 O: PUSH 1 SWAP1
*)
Example BottleCastle_run_code_of_0_block_492_0: equiv_checker [PUSH 1 (natToWord WLen 1);DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 1);DUP 1;POP;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 DUP3 SWAP1 POP DUP1 PUSH [tag] 452 PUSH [tag] 247
 O: PUSH 0 DUP2 DUP1 PUSH [tag] 452 PUSH [tag] 247
*)
Example BottleCastle_run_code_of_0_block_493_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 2;DUP 1;PUSH 2 (natToWord WLen 452);PUSH 1 (natToWord WLen 247)] [PUSH 1 (natToWord WLen 0);DUP 1;DUP 3;DUP 1;POP;DUP 1;PUSH 2 (natToWord WLen 452);PUSH 1 (natToWord WLen 247)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: GT PUSH [tag] 453
 O: GT PUSH [tag] 453
*)
Example BottleCastle_run_code_of_0_block_494_0: equiv_checker [Opcode GT;PUSH 2 (natToWord WLen 453)] [Opcode GT;PUSH 2 (natToWord WLen 453)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 SLOAD DUP2 LT ISZERO PUSH [tag] 454
 O: PUSH 0 SLOAD DUP2 LT ISZERO PUSH [tag] 454
*)
Example BottleCastle_run_code_of_0_block_495_0: equiv_checker [PUSH 1 (natToWord WLen 0);Opcode SLOAD;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (natToWord WLen 454)] [PUSH 1 (natToWord WLen 0);Opcode SLOAD;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (natToWord WLen 454)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 4 PUSH 0 DUP4 DUP2
 O: PUSH 0 PUSH 4 DUP2 DUP4 DUP2
*)
Example BottleCastle_run_code_of_0_block_496_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 4);DUP 2;DUP 4;DUP 2] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 4;DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_496_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD SWAP1 POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 DUP3 AND EQ ISZERO PUSH [tag] 455
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD PUSH 100000000000000000000000000000000000000000000000000000000 DUP2 SWAP3 POP AND PUSH 0 EQ ISZERO PUSH [tag] 455
*)
Example BottleCastle_run_code_of_0_block_496_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;PUSH 29 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249216);DUP 2;DUP 3;POP;Opcode AND;PUSH 1 (natToWord WLen 0);Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 455)] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;DUP 1;POP;PUSH 1 (natToWord WLen 0);PUSH 29 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249216);DUP 3;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 455)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 EQ ISZERO PUSH [tag] 457
 O: DUP1 PUSH 0 EQ ISZERO PUSH [tag] 457
*)
Example BottleCastle_run_code_of_0_block_497_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 0);Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 457)] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 457)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 PUSH 0 DUP4 PUSH 1 SWAP1 SUB SWAP4 POP DUP4 DUP2
 O: PUSH 1 PUSH 4 SWAP3 SUB SWAP2 PUSH 0 DUP4 DUP2
*)
Example BottleCastle_run_code_of_0_block_498_0: equiv_checker [PUSH 1 (natToWord WLen 1);PUSH 1 (natToWord WLen 4);DUP 3;Opcode SUB;DUP 2;PUSH 1 (natToWord WLen 0);DUP 4;DUP 2] [PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 4;PUSH 1 (natToWord WLen 1);DUP 1;Opcode SUB;DUP 4;POP;DUP 4;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_498_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD SWAP1 POP PUSH [tag] 456
 O: SWAP1 POP PUSH 20 ADD PUSH 0 KECCAK256 SLOAD PUSH [tag] 456
*)
Example BottleCastle_run_code_of_0_block_498_2: equiv_checker [DUP 1;POP;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;PUSH 2 (natToWord WLen 456)] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;DUP 1;POP;PUSH 2 (natToWord WLen 456)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 SWAP3 POP POP POP PUSH [tag] 451
 O: SWAP2 POP POP PUSH [tag] 451
*)
Example BottleCastle_run_code_of_0_block_499_0: equiv_checker [DUP 2;POP;POP;PUSH 2 (natToWord WLen 451)] [DUP 1;DUP 3;POP;POP;POP;PUSH 2 (natToWord WLen 451)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_500_0: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH DF2D9B4200000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH df2d9b4200000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_502_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 100946344902023664471411814945126812247012391862136956231955561042544211001344);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 100946344902023664471411814945126812247012391862136956231955561042544211001344);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_502_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_503_0: equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH 0 PUSH 6 PUSH 0 DUP6 DUP2
 O: PUSH 0 DUP1 DUP1 PUSH 6 DUP2 DUP6 DUP2
*)
Example BottleCastle_run_code_of_0_block_504_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;DUP 1;PUSH 1 (natToWord WLen 6);DUP 2;DUP 6;DUP 2] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 6);PUSH 1 (natToWord WLen 0);DUP 6;DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_504_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SWAP1 POP DUP1 SWAP3 POP DUP3 SLOAD SWAP2 POP POP SWAP2 POP SWAP2
 O: SWAP1 POP SWAP2 POP SWAP2 POP PUSH 20 ADD SWAP1 POP PUSH 0 KECCAK256 SWAP1 DUP2 SLOAD SWAP1
*)
Example BottleCastle_run_code_of_0_block_504_2: equiv_checker [DUP 1;POP;DUP 2;POP;DUP 2;POP;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;POP;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1;DUP 2;Opcode SLOAD;DUP 1] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1;POP;DUP 1;DUP 3;POP;DUP 3;Opcode SLOAD;DUP 2;POP;POP;DUP 2;POP;DUP 2] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP4 AND SWAP3 POP PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP3 AND SWAP2 POP DUP4 DUP3 EQ DUP4 DUP4 EQ OR SWAP1 POP SWAP4 SWAP3 POP POP POP
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP1 DUP2 SWAP3 SWAP3 DUP5 EQ SWAP4 POP SWAP3 DUP5 SWAP3 PUSH ffffffffffffffffffffffffffffffffffffffff AND SWAP3 POP SWAP3 POP EQ OR SWAP1
*)
Example BottleCastle_run_code_of_0_block_505_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 1;DUP 2;DUP 3;DUP 3;DUP 5;Opcode EQ;DUP 4;POP;DUP 3;DUP 5;DUP 3;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 3;POP;DUP 3;POP;Opcode EQ;Opcode OR;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 4;Opcode AND;DUP 3;POP;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 3;Opcode AND;DUP 2;POP;DUP 4;DUP 3;Opcode EQ;DUP 4;DUP 4;Opcode EQ;Opcode OR;DUP 1;POP;DUP 4;DUP 3;POP;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Example BottleCastle_run_code_of_0_block_506_0: equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH E8 DUP4 SWAP1 SHR SWAP1 POP PUSH E8 PUSH [tag] 462 DUP7 DUP7 DUP5 PUSH [tag] 463
 O: PUSH 0 PUSH [tag] 463 PUSH e8 PUSH [tag] 462 DUP7 DUP7 DUP7 DUP5 SHR DUP1 SWAP6
*)
Example BottleCastle_run_code_of_0_block_507_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 463);PUSH 1 (natToWord WLen 232);PUSH 2 (natToWord WLen 462);DUP 7;DUP 7;DUP 7;DUP 5;Opcode SHR;DUP 1;DUP 6] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 232);DUP 4;DUP 1;Opcode SHR;DUP 1;POP;PUSH 1 (natToWord WLen 232);PUSH 2 (natToWord WLen 462);DUP 7;DUP 7;DUP 5;PUSH 2 (natToWord WLen 463)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH FFFFFF AND SWAP1 SHL SWAP2 POP POP SWAP4 SWAP3 POP POP POP
 O: PUSH ffffff AND SWAP6 POP SWAP4 POP POP POP POP SHL SWAP1
*)
Example BottleCastle_run_code_of_0_block_508_0: equiv_checker [PUSH 3 (natToWord WLen 16777215);Opcode AND;DUP 6;POP;DUP 4;POP;POP;POP;POP;Opcode SHL;DUP 1] [PUSH 3 (natToWord WLen 16777215);Opcode AND;DUP 1;Opcode SHL;DUP 2;POP;POP;DUP 4;DUP 3;POP;POP;POP] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP4 AND SWAP3 POP DUP2 TIMESTAMP PUSH A0 SHL OR DUP4 OR SWAP1 POP SWAP3 SWAP2 POP POP
 O: TIMESTAMP PUSH a0 SHL OR SWAP1 PUSH ffffffffffffffffffffffffffffffffffffffff AND OR SWAP1
*)
Example BottleCastle_run_code_of_0_block_509_0: equiv_checker [Opcode TIMESTAMP;PUSH 1 (natToWord WLen 160);Opcode SHL;Opcode OR;DUP 1;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode OR;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 4;Opcode AND;DUP 3;POP;DUP 2;Opcode TIMESTAMP;PUSH 1 (natToWord WLen 160);Opcode SHL;Opcode OR;DUP 4;Opcode OR;DUP 1;POP;DUP 3;DUP 2;POP;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Example BottleCastle_run_code_of_0_block_510_0: equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 8BE0079C531659141344CD1FD0A4F28419497F9722A3DAAFE3B4186F6B6457E0 PUSH 40 MLOAD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: POP PUSH 40 MLOAD DUP1 DUP1 SUB PUSH 8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP5 DUP2 AND SWAP3 SWAP1 DUP7 AND SWAP4
*)
Example BottleCastle_run_code_of_0_block_511_1: equiv_checker [POP;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 1;Opcode SUB;PUSH 32 (natToWord WLen 63267312222310607310220992301550539520881909915348243260808268974908359596000);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 5;DUP 2;Opcode AND;DUP 3;DUP 1;DUP 7;Opcode AND;DUP 4] [POP;DUP 2;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 32 (natToWord WLen 63267312222310607310220992301550539520881909915348243260808268974908359596000);PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_run_code_of_0_block_511_2: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 467 PUSH [tag] 315
 O: PUSH [tag] 467 PUSH [tag] 315
*)
Example BottleCastle_run_code_of_0_block_512_0: equiv_checker [PUSH 2 (natToWord WLen 467);PUSH 2 (natToWord WLen 315)] [PUSH 2 (natToWord WLen 467);PUSH 2 (natToWord WLen 315)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 469 PUSH 4 PUSH 0 DUP5 DUP2
 O: PUSH [tag] 469 PUSH 4 PUSH 0 DUP5 DUP2
*)
Example BottleCastle_run_code_of_0_block_513_0: equiv_checker [PUSH 2 (natToWord WLen 469);PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 5;DUP 2] [PUSH 2 (natToWord WLen 469);PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 5;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_513_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD PUSH [tag] 470
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD PUSH [tag] 470
*)
Example BottleCastle_run_code_of_0_block_513_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;PUSH 2 (natToWord WLen 470)] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;PUSH 2 (natToWord WLen 470)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_514_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFF PUSH 40 PUSH 5 PUSH 0 DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 0 PUSH ffffffffffffffff PUSH 40 PUSH 5 DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff DUP7 AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Example BottleCastle_run_code_of_0_block_515_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 8 (natToWord WLen 18446744073709551615);PUSH 1 (natToWord WLen 64);PUSH 1 (natToWord WLen 5);DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 7;Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] [PUSH 1 (natToWord WLen 0);PUSH 8 (natToWord WLen 18446744073709551615);PUSH 1 (natToWord WLen 64);PUSH 1 (natToWord WLen 5);PUSH 1 (natToWord WLen 0);DUP 6;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_515_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD SWAP1 SHR AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD SWAP1 SHR AND SWAP3 SWAP2 POP POP
*)
Example BottleCastle_run_code_of_0_block_515_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;DUP 1;Opcode SHR;Opcode AND;DUP 3;DUP 2;POP;POP] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;DUP 1;Opcode SHR;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 473 DUP3 DUP3 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH [tag] 473 DUP3 DUP3 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
*)
Example BottleCastle_run_code_of_0_block_516_0: equiv_checker [PUSH 2 (natToWord WLen 473);DUP 3;DUP 3;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64)] [PUSH 2 (natToWord WLen 473);DUP 3;DUP 3;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 0 DUP2
 O: DUP1 PUSH 0 DUP2
*)
Example BottleCastle_run_code_of_0_block_516_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 0);DUP 2] [DUP 1;PUSH 1 (natToWord WLen 0);DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 474
 O: POP PUSH [tag] 474
*)
Example BottleCastle_run_code_of_0_block_516_2: equiv_checker [POP;PUSH 2 (natToWord WLen 474)] [POP;PUSH 2 (natToWord WLen 474)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_run_code_of_0_block_517_0: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 150B7A02 PUSH [tag] 476 PUSH [tag] 240
 O: PUSH 0 DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH 150b7a02 PUSH [tag] 476 PUSH [tag] 240
*)
Example BottleCastle_run_code_of_0_block_518_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 4 (natToWord WLen 353073666);PUSH 2 (natToWord WLen 476);PUSH 1 (natToWord WLen 240)] [PUSH 1 (natToWord WLen 0);DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 4 (natToWord WLen 353073666);PUSH 2 (natToWord WLen 476);PUSH 1 (natToWord WLen 240)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP8 DUP7 DUP7 PUSH 40 MLOAD DUP6 PUSH FFFFFFFF AND PUSH E0 SHL DUP2
 O: DUP8 DUP7 DUP7 PUSH 40 MLOAD DUP6 PUSH ffffffff AND PUSH e0 SHL DUP2
*)
Example BottleCastle_run_code_of_0_block_519_0: equiv_checker [DUP 8;DUP 7;DUP 7;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 6;PUSH 4 (natToWord WLen 4294967295);Opcode AND;PUSH 1 (natToWord WLen 224);Opcode SHL;DUP 2] [DUP 8;DUP 7;DUP 7;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 6;PUSH 4 (natToWord WLen 4294967295);Opcode AND;PUSH 1 (natToWord WLen 224);Opcode SHL;DUP 2] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH [tag] 477 SWAP5 SWAP4 SWAP3 SWAP2 SWAP1 PUSH [tag] 478
 O: SWAP3 SWAP2 SWAP1 PUSH 4 PUSH [tag] 477 SWAP6 SWAP5 ADD PUSH [tag] 478
*)
Example BottleCastle_run_code_of_0_block_519_1: equiv_checker [DUP 3;DUP 2;DUP 1;PUSH 1 (natToWord WLen 4);PUSH 2 (natToWord WLen 477);DUP 6;DUP 5;Opcode ADD;PUSH 2 (natToWord WLen 478)] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 2 (natToWord WLen 477);DUP 5;DUP 4;DUP 3;DUP 2;DUP 1;PUSH 2 (natToWord WLen 478)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP1 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 479
 O: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP9 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 479
*)
Example BottleCastle_run_code_of_0_block_520_0: equiv_checker [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (natToWord WLen 0);DUP 8;DUP 9;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 479)] [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (natToWord WLen 0);DUP 8;DUP 1;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 479)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_521_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP GAS
 O: POP GAS
*)
Example BottleCastle_run_code_of_0_block_522_0: equiv_checker [POP;Opcode GAS] [POP;Opcode GAS] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP POP POP DUP1 ISZERO PUSH [tag] 480
 O: SWAP3 POP POP POP DUP1 ISZERO PUSH [tag] 480
*)
Example BottleCastle_run_code_of_0_block_522_1: equiv_checker [DUP 3;POP;POP;POP;DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 480)] [DUP 3;POP;POP;POP;DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 480)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 40 MLOAD RETURNDATASIZE PUSH 1F NOT PUSH 1F DUP3 ADD AND DUP3 ADD DUP1 PUSH 40
 O: POP PUSH 40 MLOAD RETURNDATASIZE PUSH 1f NOT PUSH 1f DUP3 ADD AND DUP3 ADD DUP1 PUSH 40
*)
Example BottleCastle_run_code_of_0_block_523_0: equiv_checker [POP;PUSH 1 (natToWord WLen 64);Opcode MLOAD;Opcode RETURNDATASIZE;PUSH 1 (natToWord WLen 31);Opcode NOT;PUSH 1 (natToWord WLen 31);DUP 3;Opcode ADD;Opcode AND;DUP 3;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 64)] [POP;PUSH 1 (natToWord WLen 64);Opcode MLOAD;Opcode RETURNDATASIZE;PUSH 1 (natToWord WLen 31);Opcode NOT;PUSH 1 (natToWord WLen 31);DUP 3;Opcode ADD;Opcode AND;DUP 3;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 64)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP DUP2 ADD SWAP1 PUSH [tag] 481 SWAP2 SWAP1 PUSH [tag] 482
 O: POP DUP2 ADD PUSH [tag] 481 SWAP2 PUSH [tag] 482
*)
Example BottleCastle_run_code_of_0_block_523_1: equiv_checker [POP;DUP 2;Opcode ADD;PUSH 2 (natToWord WLen 481);DUP 2;PUSH 2 (natToWord WLen 482)] [POP;DUP 2;Opcode ADD;DUP 1;PUSH 2 (natToWord WLen 481);DUP 2;DUP 1;PUSH 2 (natToWord WLen 482)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 1
 O: PUSH 1
*)
Example BottleCastle_run_code_of_0_block_524_0: equiv_checker [PUSH 1 (natToWord WLen 1)] [PUSH 1 (natToWord WLen 1)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 483
 O: PUSH [tag] 483
*)
Example BottleCastle_run_code_of_0_block_525_0: equiv_checker [PUSH 2 (natToWord WLen 483)] [PUSH 2 (natToWord WLen 483)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: RETURNDATASIZE DUP1 PUSH 0 DUP2 EQ PUSH [tag] 488
 O: RETURNDATASIZE DUP1 DUP2 PUSH 0 EQ PUSH [tag] 488
*)
Example BottleCastle_run_code_of_0_block_526_0: equiv_checker [Opcode RETURNDATASIZE;DUP 1;DUP 2;PUSH 1 (natToWord WLen 0);Opcode EQ;PUSH 2 (natToWord WLen 488)] [Opcode RETURNDATASIZE;DUP 1;PUSH 1 (natToWord WLen 0);DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 488)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD SWAP2 POP PUSH 1F NOT PUSH 3F RETURNDATASIZE ADD AND DUP3 ADD PUSH 40
 O: PUSH 1f PUSH 40 MLOAD SWAP3 POP NOT RETURNDATASIZE PUSH 3f ADD AND DUP3 ADD PUSH 40
*)
Example BottleCastle_run_code_of_0_block_527_0: equiv_checker [PUSH 1 (natToWord WLen 31);PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 3;POP;Opcode NOT;Opcode RETURNDATASIZE;PUSH 1 (natToWord WLen 63);Opcode ADD;Opcode AND;DUP 3;Opcode ADD;PUSH 1 (natToWord WLen 64)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 2;POP;PUSH 1 (natToWord WLen 31);Opcode NOT;PUSH 1 (natToWord WLen 63);Opcode RETURNDATASIZE;Opcode ADD;Opcode AND;DUP 3;Opcode ADD;PUSH 1 (natToWord WLen 64)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: RETURNDATASIZE DUP3
 O: RETURNDATASIZE DUP3
*)
Example BottleCastle_run_code_of_0_block_527_1: equiv_checker [Opcode RETURNDATASIZE;DUP 3] [Opcode RETURNDATASIZE;DUP 3] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: RETURNDATASIZE PUSH 0 PUSH 20 DUP5 ADD
 O: RETURNDATASIZE PUSH 0 PUSH 20 DUP5 ADD
*)
Example BottleCastle_run_code_of_0_block_527_2: equiv_checker [Opcode RETURNDATASIZE;PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 5;Opcode ADD] [Opcode RETURNDATASIZE;PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 5;Opcode ADD] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 487
 O: PUSH [tag] 487
*)
Example BottleCastle_run_code_of_0_block_527_3: equiv_checker [PUSH 2 (natToWord WLen 487)] [PUSH 2 (natToWord WLen 487)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 60 SWAP2 POP
 O: PUSH 60 SWAP2 POP
*)
Example BottleCastle_run_code_of_0_block_528_0: equiv_checker [PUSH 1 (natToWord WLen 96);DUP 2;POP] [PUSH 1 (natToWord WLen 96);DUP 2;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 0 DUP2 MLOAD EQ ISZERO PUSH [tag] 489
 O: POP DUP1 MLOAD PUSH 0 EQ ISZERO PUSH [tag] 489
*)
Example BottleCastle_run_code_of_0_block_529_0: equiv_checker [POP;DUP 1;Opcode MLOAD;PUSH 1 (natToWord WLen 0);Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 489)] [POP;PUSH 1 (natToWord WLen 0);DUP 2;Opcode MLOAD;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 489)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH D1A57ED600000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH d1a57ed600000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_530_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 94825790509059390965680126405351569353353206259496993755816944651398402801664);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 94825790509059390965680126405351569353353206259496993755816944651398402801664);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_530_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 MLOAD DUP2 PUSH 20 ADD
 O: DUP1 MLOAD DUP2 PUSH 20 ADD
*)
Example BottleCastle_run_code_of_0_block_531_0: equiv_checker [DUP 1;Opcode MLOAD;DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD] [DUP 1;Opcode MLOAD;DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 150B7A02 PUSH E0 SHL PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ SWAP2 POP POP SWAP5 SWAP4 POP POP POP POP
 O: SWAP5 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT PUSH 150b7a02 PUSH e0 SHL SWAP2 SWAP8 SWAP7 DUP2 AND SWAP2 AND EQ SWAP6 POP POP POP POP POP
*)
Example BottleCastle_run_code_of_0_block_532_0: equiv_checker [DUP 5;PUSH 28 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249215);Opcode NOT;PUSH 4 (natToWord WLen 353073666);PUSH 1 (natToWord WLen 224);Opcode SHL;DUP 2;DUP 8;DUP 7;DUP 2;Opcode AND;DUP 2;Opcode AND;Opcode EQ;DUP 6;POP;POP;POP;POP;POP] [PUSH 4 (natToWord WLen 353073666);PUSH 1 (natToWord WLen 224);Opcode SHL;PUSH 28 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249215);Opcode NOT;Opcode AND;DUP 2;PUSH 28 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249215);Opcode NOT;Opcode AND;Opcode EQ;DUP 2;POP;POP;DUP 5;DUP 4;POP;POP;POP;POP] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 60 PUSH A DUP1 SLOAD PUSH [tag] 493 SWAP1 PUSH [tag] 223
 O: PUSH 60 PUSH a PUSH [tag] 493 DUP2 SLOAD PUSH [tag] 223
*)
Example BottleCastle_run_code_of_0_block_533_0: equiv_checker [PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 10);PUSH 2 (natToWord WLen 493);DUP 2;Opcode SLOAD;PUSH 1 (natToWord WLen 223)] [PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 10);DUP 1;Opcode SLOAD;PUSH 2 (natToWord WLen 493);DUP 1;PUSH 1 (natToWord WLen 223)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Example BottleCastle_run_code_of_0_block_534_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);DUP 1;PUSH 1 (natToWord WLen 31);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (natToWord WLen 64)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode ADD;PUSH 1 (natToWord WLen 32);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (natToWord WLen 64)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Example BottleCastle_run_code_of_0_block_534_1: equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 494 SWAP1 PUSH [tag] 223
 O: PUSH 20 ADD DUP3 PUSH [tag] 494 DUP5 SLOAD PUSH [tag] 223
*)
Example BottleCastle_run_code_of_0_block_534_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;PUSH 2 (natToWord WLen 494);DUP 5;Opcode SLOAD;PUSH 1 (natToWord WLen 223)] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (natToWord WLen 494);DUP 1;PUSH 1 (natToWord WLen 223)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 ISZERO PUSH [tag] 495
 O: DUP1 ISZERO PUSH [tag] 495
*)
Example BottleCastle_run_code_of_0_block_535_0: equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 495)] [DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 495)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 496
 O: DUP1 PUSH 1f LT PUSH [tag] 496
*)
Example BottleCastle_run_code_of_0_block_536_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 2 (natToWord WLen 496)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 2 (natToWord WLen 496)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Example BottleCastle_run_code_of_0_block_537_0: equiv_checker [PUSH 2 (natToWord WLen 256);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (natToWord WLen 256);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 495
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 495
*)
Example BottleCastle_run_code_of_0_block_537_1: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 2 (natToWord WLen 495)] [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 2 (natToWord WLen 495)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_538_0: equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 0)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 0)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Example BottleCastle_run_code_of_0_block_538_1: equiv_checker [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Example BottleCastle_run_code_of_0_block_539_0: equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 497
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 497
*)
Example BottleCastle_run_code_of_0_block_539_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (natToWord WLen 497)] [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 2 (natToWord WLen 497)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Example BottleCastle_run_code_of_0_block_540_0: equiv_checker [PUSH 1 (natToWord WLen 31);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (natToWord WLen 31);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP POP SWAP1 POP SWAP1
 O: POP POP POP POP POP SWAP2 SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_541_0: equiv_checker [POP;POP;POP;POP;POP;DUP 2;DUP 1;POP] [POP;POP;POP;POP;POP;DUP 1;POP;DUP 1] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 60 PUSH 0 DUP3 EQ ISZERO PUSH [tag] 499
 O: PUSH 60 DUP2 PUSH 0 EQ ISZERO PUSH [tag] 499
*)
Example BottleCastle_run_code_of_0_block_542_0: equiv_checker [PUSH 1 (natToWord WLen 96);DUP 2;PUSH 1 (natToWord WLen 0);Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 499)] [PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 0);DUP 3;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 499)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 PUSH 40 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 40 ADD PUSH 40
*)
Example BottleCastle_run_code_of_0_block_543_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 64);Opcode ADD;PUSH 1 (natToWord WLen 64)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 64);Opcode ADD;PUSH 1 (natToWord WLen 64)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1 DUP2
 O: DUP1 PUSH 1 DUP2
*)
Example BottleCastle_run_code_of_0_block_543_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 1);DUP 2] [DUP 1;PUSH 1 (natToWord WLen 1);DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 3000000000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 20 ADD PUSH 3000000000000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_543_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 32 (natToWord WLen 21711016731996786641919559689128982722488122124807605757398297001483711807488);DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 32 (natToWord WLen 21711016731996786641919559689128982722488122124807605757398297001483711807488);DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP1 POP PUSH [tag] 498
 O: POP SWAP1 POP PUSH [tag] 498
*)
Example BottleCastle_run_code_of_0_block_543_3: equiv_checker [POP;DUP 1;POP;PUSH 2 (natToWord WLen 498)] [POP;DUP 1;POP;PUSH 2 (natToWord WLen 498)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP3 SWAP1 POP PUSH 0
 O: DUP2 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_544_0: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 0);DUP 3;DUP 1;POP;PUSH 1 (natToWord WLen 0)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP3 EQ PUSH [tag] 501
 O: DUP2 PUSH 0 EQ PUSH [tag] 501
*)
Example BottleCastle_run_code_of_0_block_545_0: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 0);Opcode EQ;PUSH 2 (natToWord WLen 501)] [PUSH 1 (natToWord WLen 0);DUP 3;Opcode EQ;PUSH 2 (natToWord WLen 501)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 DUP1 PUSH [tag] 502 SWAP1 PUSH [tag] 503
 O: DUP1 PUSH [tag] 502 DUP3 PUSH [tag] 503
*)
Example BottleCastle_run_code_of_0_block_546_0: equiv_checker [DUP 1;PUSH 2 (natToWord WLen 502);DUP 3;PUSH 2 (natToWord WLen 503)] [DUP 1;DUP 1;PUSH 2 (natToWord WLen 502);DUP 1;PUSH 2 (natToWord WLen 503)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP PUSH A DUP3 PUSH [tag] 504 SWAP2 SWAP1 PUSH [tag] 505
 O: SWAP2 POP POP PUSH [tag] 504 PUSH a DUP4 PUSH [tag] 505
*)
Example BottleCastle_run_code_of_0_block_547_0: equiv_checker [DUP 2;POP;POP;PUSH 2 (natToWord WLen 504);PUSH 1 (natToWord WLen 10);DUP 4;PUSH 2 (natToWord WLen 505)] [DUP 2;POP;POP;PUSH 1 (natToWord WLen 10);DUP 3;PUSH 2 (natToWord WLen 504);DUP 2;DUP 1;PUSH 2 (natToWord WLen 505)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 500
 O: SWAP2 POP PUSH [tag] 500
*)
Example BottleCastle_run_code_of_0_block_548_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 500)] [DUP 2;POP;PUSH 2 (natToWord WLen 500)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 506
 O: PUSH 0 DUP2 PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 506
*)
Example BottleCastle_run_code_of_0_block_549_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 2;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 506)] [PUSH 1 (natToWord WLen 0);DUP 2;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 506)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 507 PUSH [tag] 312
 O: PUSH [tag] 507 PUSH [tag] 312
*)
Example BottleCastle_run_code_of_0_block_550_0: equiv_checker [PUSH 2 (natToWord WLen 507);PUSH 2 (natToWord WLen 312)] [PUSH 2 (natToWord WLen 507);PUSH 2 (natToWord WLen 312)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD SWAP1 DUP1 DUP3
 O: DUP1 PUSH 40 MLOAD SWAP2 DUP3
*)
Example BottleCastle_run_code_of_0_block_552_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 2;DUP 3] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 1;DUP 3] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F ADD PUSH 1F NOT AND PUSH 20 ADD DUP3 ADD PUSH 40
 O: DUP2 PUSH 20 PUSH 1f DUP4 ADD PUSH 1f NOT AND ADD ADD PUSH 40
*)
Example BottleCastle_run_code_of_0_block_552_1: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 31);DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 31);Opcode NOT;Opcode AND;Opcode ADD;Opcode ADD;PUSH 1 (natToWord WLen 64)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode ADD;PUSH 1 (natToWord WLen 31);Opcode NOT;Opcode AND;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;Opcode ADD;PUSH 1 (natToWord WLen 64)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 ISZERO PUSH [tag] 508
 O: DUP1 ISZERO PUSH [tag] 508
*)
Example BottleCastle_run_code_of_0_block_552_2: equiv_checker [DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 508)] [DUP 1;Opcode ISZERO;PUSH 2 (natToWord WLen 508)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 PUSH 20 ADD PUSH 1 DUP3 MUL DUP1 CALLDATASIZE DUP4
 O: DUP2 PUSH 20 ADD PUSH 1 DUP3 MUL DUP1 CALLDATASIZE DUP4
*)
Example BottleCastle_run_code_of_0_block_553_0: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 1);DUP 3;Opcode MUL;DUP 1;Opcode CALLDATASIZE;DUP 4] [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 1);DUP 3;Opcode MUL;DUP 1;Opcode CALLDATASIZE;DUP 4] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 DUP3 ADD SWAP2 POP POP SWAP1 POP
 O: ADD SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_553_1: equiv_checker [Opcode ADD;DUP 1;POP] [DUP 1;DUP 3;Opcode ADD;DUP 2;POP;POP;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP1 POP
 O: POP SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_554_0: equiv_checker [POP;DUP 1;POP] [POP;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP6 EQ PUSH [tag] 510
 O: DUP5 PUSH 0 EQ PUSH [tag] 510
*)
Example BottleCastle_run_code_of_0_block_555_0: equiv_checker [DUP 5;PUSH 1 (natToWord WLen 0);Opcode EQ;PUSH 2 (natToWord WLen 510)] [PUSH 1 (natToWord WLen 0);DUP 6;Opcode EQ;PUSH 2 (natToWord WLen 510)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 1 DUP3 PUSH [tag] 511 SWAP2 SWAP1 PUSH [tag] 512
 O: PUSH [tag] 511 PUSH 1 DUP4 PUSH [tag] 512
*)
Example BottleCastle_run_code_of_0_block_556_0: equiv_checker [PUSH 2 (natToWord WLen 511);PUSH 1 (natToWord WLen 1);DUP 4;PUSH 2 (natToWord WLen 512)] [PUSH 1 (natToWord WLen 1);DUP 3;PUSH 2 (natToWord WLen 511);DUP 2;DUP 1;PUSH 2 (natToWord WLen 512)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH A DUP6 PUSH [tag] 513 SWAP2 SWAP1 PUSH [tag] 514
 O: SWAP2 POP PUSH [tag] 513 PUSH a DUP7 PUSH [tag] 514
*)
Example BottleCastle_run_code_of_0_block_557_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 513);PUSH 1 (natToWord WLen 10);DUP 7;PUSH 2 (natToWord WLen 514)] [DUP 2;POP;PUSH 1 (natToWord WLen 10);DUP 6;PUSH 2 (natToWord WLen 513);DUP 2;DUP 1;PUSH 2 (natToWord WLen 514)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 30 PUSH [tag] 515 SWAP2 SWAP1 PUSH [tag] 350
 O: PUSH [tag] 515 SWAP1 PUSH 30 PUSH [tag] 350
*)
Example BottleCastle_run_code_of_0_block_558_0: equiv_checker [PUSH 2 (natToWord WLen 515);DUP 1;PUSH 1 (natToWord WLen 48);PUSH 2 (natToWord WLen 350)] [PUSH 1 (natToWord WLen 48);PUSH 2 (natToWord WLen 515);DUP 2;DUP 1;PUSH 2 (natToWord WLen 350)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH F8 SHL DUP2 DUP4 DUP2 MLOAD DUP2 LT PUSH [tag] 516
 O: PUSH f8 SHL DUP2 DUP4 DUP4 MLOAD DUP6 LT PUSH [tag] 516
*)
Example BottleCastle_run_code_of_0_block_559_0: equiv_checker [PUSH 1 (natToWord WLen 248);Opcode SHL;DUP 2;DUP 4;DUP 4;Opcode MLOAD;DUP 6;Opcode LT;PUSH 2 (natToWord WLen 516)] [PUSH 1 (natToWord WLen 248);Opcode SHL;DUP 2;DUP 4;DUP 2;Opcode MLOAD;DUP 2;Opcode LT;PUSH 2 (natToWord WLen 516)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 517 PUSH [tag] 327
 O: PUSH [tag] 517 PUSH [tag] 327
*)
Example BottleCastle_run_code_of_0_block_560_0: equiv_checker [PUSH 2 (natToWord WLen 517);PUSH 2 (natToWord WLen 327)] [PUSH 2 (natToWord WLen 517);PUSH 2 (natToWord WLen 327)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD ADD SWAP1 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND SWAP1 DUP2 PUSH 0 BYTE SWAP1
 O: PUSH 20 ADD SWAP2 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT AND SWAP2 ADD DUP2 PUSH 0 BYTE SWAP1
*)
Example BottleCastle_run_code_of_0_block_562_0: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 31 (natToWord WLen 452312848583266388373324160190187140051835877600158453279131187530910662655);Opcode NOT;Opcode AND;DUP 2;Opcode ADD;DUP 2;PUSH 1 (natToWord WLen 0);Opcode BYTE;DUP 1] [PUSH 1 (natToWord WLen 32);Opcode ADD;Opcode ADD;DUP 1;PUSH 31 (natToWord WLen 452312848583266388373324160190187140051835877600158453279131187530910662655);Opcode NOT;Opcode AND;DUP 1;DUP 2;PUSH 1 (natToWord WLen 0);Opcode BYTE;DUP 1] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH A DUP6 PUSH [tag] 518 SWAP2 SWAP1 PUSH [tag] 505
 O: POP PUSH [tag] 518 PUSH a DUP7 PUSH [tag] 505
*)
Example BottleCastle_run_code_of_0_block_562_1: equiv_checker [POP;PUSH 2 (natToWord WLen 518);PUSH 1 (natToWord WLen 10);DUP 7;PUSH 2 (natToWord WLen 505)] [POP;PUSH 1 (natToWord WLen 10);DUP 6;PUSH 2 (natToWord WLen 518);DUP 2;DUP 1;PUSH 2 (natToWord WLen 505)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP5 POP PUSH [tag] 509
 O: SWAP5 POP PUSH [tag] 509
*)
Example BottleCastle_run_code_of_0_block_563_0: equiv_checker [DUP 5;POP;PUSH 2 (natToWord WLen 509)] [DUP 5;POP;PUSH 2 (natToWord WLen 509)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 SWAP4 POP POP POP POP
 O: SWAP3 POP POP POP
*)
Example BottleCastle_run_code_of_0_block_564_0: equiv_checker [DUP 3;POP;POP;POP] [DUP 1;DUP 4;POP;POP;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_565_0: equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 CALLER SWAP1 POP SWAP1
 O: CALLER SWAP1
*)
Example BottleCastle_run_code_of_0_block_566_0: equiv_checker [Opcode CALLER;DUP 1] [PUSH 1 (natToWord WLen 0);Opcode CALLER;DUP 1;POP;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 SWAP4 SWAP3 POP POP POP
 O: POP POP POP PUSH 0 SWAP1
*)
Example BottleCastle_run_code_of_0_block_567_0: equiv_checker [POP;POP;POP;PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 4;DUP 3;POP;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 521 PUSH [tag] 315
 O: PUSH [tag] 521 PUSH [tag] 315
*)
Example BottleCastle_run_code_of_0_block_568_0: equiv_checker [PUSH 2 (natToWord WLen 521);PUSH 2 (natToWord WLen 315)] [PUSH 2 (natToWord WLen 521);PUSH 2 (natToWord WLen 315)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 DUP2 PUSH 0 ADD SWAP1 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1 DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH ffffffffffffffffffffffffffffffffffffffff DUP2 PUSH 0 ADD DUP4 DUP3 AND DUP1 SWAP3 AND DUP2
*)
Example BottleCastle_run_code_of_0_block_569_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 2;PUSH 1 (natToWord WLen 0);Opcode ADD;DUP 4;DUP 3;Opcode AND;DUP 1;DUP 3;Opcode AND;DUP 2] [DUP 2;DUP 2;PUSH 1 (natToWord WLen 0);Opcode ADD;DUP 1;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 1;DUP 2;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP PUSH A0 DUP3 SWAP1 SHR DUP2 PUSH 20 ADD SWAP1 PUSH FFFFFFFFFFFFFFFF AND SWAP1 DUP2 PUSH FFFFFFFFFFFFFFFF AND DUP2
 O: POP DUP2 PUSH 20 ADD PUSH ffffffffffffffff DUP5 DUP2 SWAP4 POP SWAP5 PUSH a0 SHR AND SWAP2 DUP3 AND DUP2
*)
Example BottleCastle_run_code_of_0_block_569_1: equiv_checker [POP;DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 5;DUP 2;DUP 4;POP;DUP 5;PUSH 1 (natToWord WLen 160);Opcode SHR;Opcode AND;DUP 2;DUP 3;Opcode AND;DUP 2] [POP;POP;PUSH 1 (natToWord WLen 160);DUP 3;DUP 1;Opcode SHR;DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;PUSH 8 (natToWord WLen 18446744073709551615);Opcode AND;DUP 1;DUP 2;PUSH 8 (natToWord WLen 18446744073709551615);Opcode AND;DUP 2] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 DUP4 AND EQ ISZERO DUP2 PUSH 40 ADD SWAP1 ISZERO ISZERO SWAP1 DUP2 ISZERO ISZERO DUP2
 O: POP PUSH 40 DUP4 PUSH 100000000000000000000000000000000000000000000000000000000 AND PUSH 0 EQ ISZERO ISZERO ISZERO SWAP2 POP DUP3 ADD DUP2 ISZERO ISZERO DUP2
*)
Example BottleCastle_run_code_of_0_block_569_2: equiv_checker [POP;PUSH 1 (natToWord WLen 64);DUP 4;PUSH 29 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249216);Opcode AND;PUSH 1 (natToWord WLen 0);Opcode EQ;Opcode ISZERO;Opcode ISZERO;Opcode ISZERO;DUP 2;POP;DUP 3;Opcode ADD;DUP 2;Opcode ISZERO;Opcode ISZERO;DUP 2] [POP;POP;PUSH 1 (natToWord WLen 0);PUSH 29 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249216);DUP 4;Opcode AND;Opcode EQ;Opcode ISZERO;DUP 2;PUSH 1 (natToWord WLen 64);Opcode ADD;DUP 1;Opcode ISZERO;Opcode ISZERO;DUP 1;DUP 2;Opcode ISZERO;Opcode ISZERO;DUP 2] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP PUSH E8 DUP3 SWAP1 SHR DUP2 PUSH 60 ADD SWAP1 PUSH FFFFFF AND SWAP1 DUP2 PUSH FFFFFF AND DUP2
 O: POP PUSH ffffff DUP1 DUP5 PUSH e8 SHR AND DUP4 PUSH 60 ADD SWAP2 DUP2 SWAP4 POP AND DUP2
*)
Example BottleCastle_run_code_of_0_block_569_3: equiv_checker [POP;PUSH 3 (natToWord WLen 16777215);DUP 1;DUP 5;PUSH 1 (natToWord WLen 232);Opcode SHR;Opcode AND;DUP 4;PUSH 1 (natToWord WLen 96);Opcode ADD;DUP 2;DUP 2;DUP 4;POP;Opcode AND;DUP 2] [POP;POP;PUSH 1 (natToWord WLen 232);DUP 3;DUP 1;Opcode SHR;DUP 2;PUSH 1 (natToWord WLen 96);Opcode ADD;DUP 1;PUSH 3 (natToWord WLen 16777215);Opcode AND;DUP 1;DUP 2;PUSH 3 (natToWord WLen 16777215);Opcode AND;DUP 2] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP SWAP2 SWAP1 POP
 O: POP POP SWAP2 SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_569_4: equiv_checker [POP;POP;DUP 2;DUP 1;POP] [POP;POP;DUP 2;DUP 1;POP] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 524 DUP4 DUP4 PUSH [tag] 525
 O: PUSH [tag] 524 DUP4 DUP4 PUSH [tag] 525
*)
Example BottleCastle_run_code_of_0_block_570_0: equiv_checker [PUSH 2 (natToWord WLen 524);DUP 4;DUP 4;PUSH 2 (natToWord WLen 525)] [PUSH 2 (natToWord WLen 524);DUP 4;DUP 4;PUSH 2 (natToWord WLen 525)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EXTCODESIZE EQ PUSH [tag] 526
 O: PUSH 0 DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff AND EXTCODESIZE EQ PUSH [tag] 526
*)
Example BottleCastle_run_code_of_0_block_571_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EXTCODESIZE;Opcode EQ;PUSH 2 (natToWord WLen 526)] [PUSH 1 (natToWord WLen 0);DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EXTCODESIZE;Opcode EQ;PUSH 2 (natToWord WLen 526)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 SLOAD SWAP1 POP PUSH 0 DUP4 DUP3 SUB SWAP1 POP
 O: PUSH 0 SLOAD DUP3 DUP2 SUB
*)
Example BottleCastle_run_code_of_0_block_572_0: equiv_checker [PUSH 1 (natToWord WLen 0);Opcode SLOAD;DUP 3;DUP 2;Opcode SUB] [PUSH 1 (natToWord WLen 0);DUP 1;Opcode SLOAD;DUP 1;POP;PUSH 1 (natToWord WLen 0);DUP 4;DUP 3;Opcode SUB;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 530 PUSH 0 DUP7 DUP4 DUP1 PUSH 1 ADD SWAP5 POP DUP7 PUSH [tag] 379
 O: PUSH [tag] 530 PUSH 0 DUP7 PUSH 1 DUP5 ADD SWAP4 DUP7 PUSH [tag] 379
*)
Example BottleCastle_run_code_of_0_block_573_0: equiv_checker [PUSH 2 (natToWord WLen 530);PUSH 1 (natToWord WLen 0);DUP 7;PUSH 1 (natToWord WLen 1);DUP 5;Opcode ADD;DUP 4;DUP 7;PUSH 2 (natToWord WLen 379)] [PUSH 2 (natToWord WLen 530);PUSH 1 (natToWord WLen 0);DUP 7;DUP 4;DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 5;POP;DUP 7;PUSH 2 (natToWord WLen 379)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 531
 O: PUSH [tag] 531
*)
Example BottleCastle_run_code_of_0_block_574_0: equiv_checker [PUSH 2 (natToWord WLen 531)] [PUSH 2 (natToWord WLen 531)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH D1A57ED600000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH d1a57ed600000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_575_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 94825790509059390965680126405351569353353206259496993755816944651398402801664);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 94825790509059390965680126405351569353353206259496993755816944651398402801664);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_575_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 DUP2 LT PUSH [tag] 527
 O: DUP2 DUP2 LT PUSH [tag] 527
*)
Example BottleCastle_run_code_of_0_block_576_0: equiv_checker [DUP 2;DUP 2;Opcode LT;PUSH 2 (natToWord WLen 527)] [DUP 2;DUP 2;Opcode LT;PUSH 2 (natToWord WLen 527)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 PUSH 0 SLOAD EQ PUSH [tag] 532
 O: DUP2 PUSH 0 SLOAD EQ PUSH [tag] 532
*)
Example BottleCastle_run_code_of_0_block_577_0: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 0);Opcode SLOAD;Opcode EQ;PUSH 2 (natToWord WLen 532)] [DUP 2;PUSH 1 (natToWord WLen 0);Opcode SLOAD;Opcode EQ;PUSH 2 (natToWord WLen 532)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_578_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_run_code_of_0_block_579_0: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP
 O: POP POP POP
*)
Example BottleCastle_run_code_of_0_block_580_0: equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 SLOAD SWAP1 POP PUSH 0 DUP3 EQ ISZERO PUSH [tag] 534
 O: PUSH 0 DUP2 DUP2 SLOAD SWAP2 EQ ISZERO PUSH [tag] 534
*)
Example BottleCastle_run_code_of_0_block_581_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 2;DUP 2;Opcode SLOAD;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 534)] [PUSH 1 (natToWord WLen 0);DUP 1;Opcode SLOAD;DUP 1;POP;PUSH 1 (natToWord WLen 0);DUP 3;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 534)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH B562E8DD00000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH b562e8dd00000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_582_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 82043383769220166810960915634267060865176734798612951612565978380339293192192);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 82043383769220166810960915634267060865176734798612951612565978380339293192192);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_582_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 535 PUSH 0 DUP5 DUP4 DUP6 PUSH [tag] 263
 O: PUSH [tag] 535 PUSH 0 DUP5 DUP4 DUP6 PUSH [tag] 263
*)
Example BottleCastle_run_code_of_0_block_583_0: equiv_checker [PUSH 2 (natToWord WLen 535);PUSH 1 (natToWord WLen 0);DUP 5;DUP 4;DUP 6;PUSH 2 (natToWord WLen 263)] [PUSH 2 (natToWord WLen 535);PUSH 1 (natToWord WLen 0);DUP 5;DUP 4;DUP 6;PUSH 2 (natToWord WLen 263)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 1 PUSH 40 PUSH 1 SWAP1 SHL OR DUP3 MUL PUSH 5 PUSH 0 DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 1 DUP1 PUSH 40 SHL OR DUP3 MUL PUSH ffffffffffffffffffffffffffffffffffffffff DUP1 DUP6 AND AND PUSH 0 PUSH 5 SWAP2 DUP2
*)
Example BottleCastle_run_code_of_0_block_584_0: equiv_checker [PUSH 1 (natToWord WLen 1);DUP 1;PUSH 1 (natToWord WLen 64);Opcode SHL;Opcode OR;DUP 3;Opcode MUL;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 1;DUP 6;Opcode AND;Opcode AND;PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 5);DUP 2;DUP 2] [PUSH 1 (natToWord WLen 1);PUSH 1 (natToWord WLen 64);PUSH 1 (natToWord WLen 1);DUP 1;Opcode SHL;Opcode OR;DUP 3;Opcode MUL;PUSH 1 (natToWord WLen 5);PUSH 1 (natToWord WLen 0);DUP 6;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_584_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP3 DUP3 SLOAD ADD SWAP3 POP POP DUP2 SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 SWAP1 DUP2 SLOAD ADD DUP1 SWAP2
*)
Example BottleCastle_run_code_of_0_block_584_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1;DUP 2;Opcode SLOAD;Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);DUP 3;DUP 3;Opcode SLOAD;Opcode ADD;DUP 3;POP;POP;DUP 2;DUP 1] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 536 DUP4 PUSH [tag] 537 PUSH 0 DUP7 PUSH 0 PUSH [tag] 267
 O: POP PUSH [tag] 536 DUP4 PUSH [tag] 537 PUSH 0 DUP3 DUP2 PUSH [tag] 267
*)
Example BottleCastle_run_code_of_0_block_584_3: equiv_checker [POP;PUSH 2 (natToWord WLen 536);DUP 4;PUSH 2 (natToWord WLen 537);PUSH 1 (natToWord WLen 0);DUP 3;DUP 2;PUSH 2 (natToWord WLen 267)] [POP;PUSH 2 (natToWord WLen 536);DUP 4;PUSH 2 (natToWord WLen 537);PUSH 1 (natToWord WLen 0);DUP 7;PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 267)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 538 DUP6 PUSH [tag] 539
 O: PUSH [tag] 538 DUP6 PUSH [tag] 539
*)
Example BottleCastle_run_code_of_0_block_585_0: equiv_checker [PUSH 2 (natToWord WLen 538);DUP 6;PUSH 2 (natToWord WLen 539)] [PUSH 2 (natToWord WLen 538);DUP 6;PUSH 2 (natToWord WLen 539)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: OR PUSH [tag] 268
 O: OR PUSH [tag] 268
*)
Example BottleCastle_run_code_of_0_block_586_0: equiv_checker [Opcode OR;PUSH 2 (natToWord WLen 268)] [Opcode OR;PUSH 2 (natToWord WLen 268)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 PUSH 0 DUP4 DUP2
 O: PUSH 4 PUSH 0 DUP4 DUP2
*)
Example BottleCastle_run_code_of_0_block_587_0: equiv_checker [PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 4;DUP 2] [PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 4;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example BottleCastle_run_code_of_0_block_587_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 DUP2 SWAP1
 O: DUP2 SWAP1 PUSH 20 ADD PUSH 0 KECCAK256
*)
Example BottleCastle_run_code_of_0_block_587_2: equiv_checker [DUP 2;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 2;DUP 1] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 0 DUP1 DUP4 DUP4 ADD SWAP1 POP PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP6 AND SWAP2 POP DUP3 DUP3 PUSH 0 PUSH DDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF PUSH 0 DUP1
 O: PUSH 0 DUP3 DUP6 PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP3 DUP2 SWAP5 DUP5 SWAP7 DUP9 SWAP2 POP ADD SWAP4 DUP4 SWAP7 PUSH ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef SWAP2
*)
Example BottleCastle_run_code_of_0_block_587_3: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 3;DUP 6;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 3;DUP 2;DUP 5;DUP 5;DUP 7;DUP 9;DUP 2;POP;Opcode ADD;DUP 4;DUP 4;DUP 7;PUSH 32 (natToWord WLen 100389287136786176327247604509743168900146139575972864366142685224231313322991);DUP 2] [POP;PUSH 1 (natToWord WLen 0);DUP 1;DUP 4;DUP 4;Opcode ADD;DUP 1;POP;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 6;Opcode AND;DUP 2;POP;DUP 3;DUP 3;PUSH 1 (natToWord WLen 0);PUSH 32 (natToWord WLen 100389287136786176327247604509743168900146139575972864366142685224231313322991);PUSH 1 (natToWord WLen 0);DUP 1] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 1 DUP4 ADD
 O: DUP3 PUSH 1 ADD
*)
Example BottleCastle_run_code_of_0_block_587_4: equiv_checker [DUP 3;PUSH 1 (natToWord WLen 1);Opcode ADD] [PUSH 1 (natToWord WLen 1);DUP 4;Opcode ADD] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 DUP2 EQ PUSH [tag] 542
 O: DUP1 DUP3 EQ PUSH [tag] 542
*)
Example BottleCastle_run_code_of_0_block_588_0: equiv_checker [DUP 1;DUP 3;Opcode EQ;PUSH 2 (natToWord WLen 542)] [DUP 2;DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 542)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 DUP4 PUSH 0 PUSH DDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF PUSH 0 DUP1
 O: DUP1 DUP4 PUSH 0 PUSH ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef DUP2 DUP1
*)
Example BottleCastle_run_code_of_0_block_589_0: equiv_checker [DUP 1;DUP 4;PUSH 1 (natToWord WLen 0);PUSH 32 (natToWord WLen 100389287136786176327247604509743168900146139575972864366142685224231313322991);DUP 2;DUP 1] [DUP 1;DUP 4;PUSH 1 (natToWord WLen 0);PUSH 32 (natToWord WLen 100389287136786176327247604509743168900146139575972864366142685224231313322991);PUSH 1 (natToWord WLen 0);DUP 1] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 1 DUP2 ADD SWAP1 POP PUSH [tag] 540
 O: PUSH 1 ADD PUSH [tag] 540
*)
Example BottleCastle_run_code_of_0_block_589_1: equiv_checker [PUSH 1 (natToWord WLen 1);Opcode ADD;PUSH 2 (natToWord WLen 540)] [PUSH 1 (natToWord WLen 1);DUP 2;Opcode ADD;DUP 1;POP;PUSH 2 (natToWord WLen 540)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 0 DUP3 EQ ISZERO PUSH [tag] 543
 O: POP PUSH 0 DUP3 EQ ISZERO PUSH [tag] 543
*)
Example BottleCastle_run_code_of_0_block_590_0: equiv_checker [POP;PUSH 1 (natToWord WLen 0);DUP 3;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 543)] [POP;PUSH 1 (natToWord WLen 0);DUP 3;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 543)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 2E07630000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 2e07630000000000000000000000000000000000000000000000000000000000 DUP2
*)
Example BottleCastle_run_code_of_0_block_591_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 20819442237172034821294950492084174297515035416673663051815846959729094950912);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 20819442237172034821294950492084174297515035416673663051815846959729094950912);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_591_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 0 DUP2 SWAP1
 O: DUP1 DUP1 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_592_0: equiv_checker [DUP 1;DUP 1;PUSH 1 (natToWord WLen 0)] [DUP 1;PUSH 1 (natToWord WLen 0);DUP 2;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP PUSH [tag] 544 PUSH 0 DUP5 DUP4 DUP6 PUSH [tag] 273
 O: POP POP POP PUSH [tag] 544 PUSH 0 DUP5 DUP4 DUP6 PUSH [tag] 273
*)
Example BottleCastle_run_code_of_0_block_592_1: equiv_checker [POP;POP;POP;PUSH 2 (natToWord WLen 544);PUSH 1 (natToWord WLen 0);DUP 5;DUP 4;DUP 6;PUSH 2 (natToWord WLen 273)] [POP;POP;POP;PUSH 2 (natToWord WLen 544);PUSH 1 (natToWord WLen 0);DUP 5;DUP 4;DUP 6;PUSH 2 (natToWord WLen 273)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP
 O: POP POP POP
*)
Example BottleCastle_run_code_of_0_block_593_0: equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 1 DUP3 EQ PUSH E1 SHL SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 1 EQ PUSH e1 SHL SWAP1
*)
Example BottleCastle_run_code_of_0_block_594_0: equiv_checker [PUSH 1 (natToWord WLen 1);Opcode EQ;PUSH 1 (natToWord WLen 225);Opcode SHL;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 1);DUP 3;Opcode EQ;PUSH 1 (natToWord WLen 225);Opcode SHL;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 DUP1 SLOAD PUSH [tag] 546 SWAP1 PUSH [tag] 223
 O: DUP3 PUSH [tag] 546 DUP5 SLOAD PUSH [tag] 223
*)
Example BottleCastle_run_code_of_0_block_595_0: equiv_checker [DUP 3;PUSH 2 (natToWord WLen 546);DUP 5;Opcode SLOAD;PUSH 1 (natToWord WLen 223)] [DUP 3;DUP 1;Opcode SLOAD;PUSH 2 (natToWord WLen 546);DUP 1;PUSH 1 (natToWord WLen 223)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 PUSH 0
 O: SWAP1 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_596_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 0)] [DUP 1;PUSH 1 (natToWord WLen 0)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1 PUSH 1F ADD PUSH 20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 548
 O: PUSH 20 DUP1 PUSH 0 KECCAK256 SWAP2 PUSH 1f ADD DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 548
*)
Example BottleCastle_run_code_of_0_block_596_1: equiv_checker [PUSH 1 (natToWord WLen 32);DUP 1;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 2;PUSH 1 (natToWord WLen 31);Opcode ADD;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 2 (natToWord WLen 548)] [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1;PUSH 1 (natToWord WLen 31);Opcode ADD;PUSH 1 (natToWord WLen 32);DUP 1;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 2 (natToWord WLen 548)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP6
 O: PUSH 0 DUP6
*)
Example BottleCastle_run_code_of_0_block_597_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 6] [PUSH 1 (natToWord WLen 0);DUP 6] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 547
 O: PUSH [tag] 547
*)
Example BottleCastle_run_code_of_0_block_597_1: equiv_checker [PUSH 2 (natToWord WLen 547)] [PUSH 2 (natToWord WLen 547)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 PUSH 1F LT PUSH [tag] 549
 O: DUP3 PUSH 1f LT PUSH [tag] 549
*)
Example BottleCastle_run_code_of_0_block_598_0: equiv_checker [DUP 3;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 2 (natToWord WLen 549)] [DUP 3;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 2 (natToWord WLen 549)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 MLOAD PUSH FF NOT AND DUP4 DUP1 ADD OR DUP6
 O: DUP3 DUP1 ADD PUSH ff NOT DUP3 MLOAD AND OR DUP6
*)
Example BottleCastle_run_code_of_0_block_599_0: equiv_checker [DUP 3;DUP 1;Opcode ADD;PUSH 1 (natToWord WLen 255);Opcode NOT;DUP 3;Opcode MLOAD;Opcode AND;Opcode OR;DUP 6] [DUP 1;Opcode MLOAD;PUSH 1 (natToWord WLen 255);Opcode NOT;Opcode AND;DUP 4;DUP 1;Opcode ADD;Opcode OR;DUP 6] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 547
 O: PUSH [tag] 547
*)
Example BottleCastle_run_code_of_0_block_599_1: equiv_checker [PUSH 2 (natToWord WLen 547)] [PUSH 2 (natToWord WLen 547)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 DUP1 ADD PUSH 1 ADD DUP6
 O: DUP3 DUP4 ADD PUSH 1 ADD DUP6
*)
Example BottleCastle_run_code_of_0_block_600_0: equiv_checker [DUP 3;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 6] [DUP 3;DUP 1;Opcode ADD;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 6] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 ISZERO PUSH [tag] 547
 O: DUP3 ISZERO PUSH [tag] 547
*)
Example BottleCastle_run_code_of_0_block_600_1: equiv_checker [DUP 3;Opcode ISZERO;PUSH 2 (natToWord WLen 547)] [DUP 3;Opcode ISZERO;PUSH 2 (natToWord WLen 547)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 DUP3 ADD
 O: DUP1 SWAP3 ADD
*)
Example BottleCastle_run_code_of_0_block_601_0: equiv_checker [DUP 1;DUP 3;Opcode ADD] [DUP 2;DUP 3;Opcode ADD] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 DUP2 GT ISZERO PUSH [tag] 551
 O: DUP3 DUP2 GT ISZERO PUSH [tag] 551
*)
Example BottleCastle_run_code_of_0_block_602_0: equiv_checker [DUP 3;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 551)] [DUP 3;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 551)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 MLOAD DUP3
 O: DUP3 MLOAD DUP3
*)
Example BottleCastle_run_code_of_0_block_603_0: equiv_checker [DUP 3;Opcode MLOAD;DUP 3] [DUP 3;Opcode MLOAD;DUP 3] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 PUSH 20 ADD SWAP2 SWAP1 PUSH 1 ADD SWAP1 PUSH [tag] 550
 O: SWAP2 PUSH 20 ADD SWAP2 SWAP1 PUSH 1 ADD SWAP1 PUSH [tag] 550
*)
Example BottleCastle_run_code_of_0_block_603_1: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 2 (natToWord WLen 550)] [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 2 (natToWord WLen 550)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP1 POP PUSH [tag] 552 SWAP2 SWAP1 PUSH [tag] 553
 O: POP PUSH [tag] 552 SWAP3 SWAP2 POP PUSH [tag] 553
*)
Example BottleCastle_run_code_of_0_block_605_0: equiv_checker [POP;PUSH 2 (natToWord WLen 552);DUP 3;DUP 2;POP;PUSH 2 (natToWord WLen 553)] [POP;DUP 1;POP;PUSH 2 (natToWord WLen 552);DUP 2;DUP 1;PUSH 2 (natToWord WLen 553)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP1
 O: POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_606_0: equiv_checker [POP;DUP 1] [POP;DUP 1] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 PUSH 80 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 80 ADD PUSH 40
*)
Example BottleCastle_run_code_of_0_block_607_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 128);Opcode ADD;PUSH 1 (natToWord WLen 64)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 128);Opcode ADD;PUSH 1 (natToWord WLen 64)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: DUP1 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Example BottleCastle_run_code_of_0_block_607_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] [DUP 1;PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 PUSH FFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 20 ADD PUSH ffffffffffffffff PUSH 0 AND DUP2
*)
Example BottleCastle_run_code_of_0_block_607_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 8 (natToWord WLen 18446744073709551615);PUSH 1 (natToWord WLen 0);Opcode AND;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);PUSH 8 (natToWord WLen 18446744073709551615);Opcode AND;DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 ISZERO ISZERO DUP2
 O: PUSH 20 ADD PUSH 0 ISZERO ISZERO DUP2
*)
Example BottleCastle_run_code_of_0_block_607_3: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode ISZERO;Opcode ISZERO;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode ISZERO;Opcode ISZERO;DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 PUSH FFFFFF AND DUP2
 O: PUSH 20 ADD PUSH ffffff PUSH 0 AND DUP2
*)
Example BottleCastle_run_code_of_0_block_607_4: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 3 (natToWord WLen 16777215);PUSH 1 (natToWord WLen 0);Opcode AND;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);PUSH 3 (natToWord WLen 16777215);Opcode AND;DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP1
 O: POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_607_5: equiv_checker [POP;DUP 1] [POP;DUP 1] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 DUP3 GT ISZERO PUSH [tag] 555
 O: DUP1 DUP3 GT ISZERO PUSH [tag] 555
*)
Example BottleCastle_run_code_of_0_block_609_0: equiv_checker [DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 555)] [DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 555)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 PUSH 0 SWAP1
 O: PUSH 0 DUP1 DUP3
*)
Example BottleCastle_run_code_of_0_block_610_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;DUP 3] [PUSH 1 (natToWord WLen 0);DUP 2;PUSH 1 (natToWord WLen 0);DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 1 ADD PUSH [tag] 554
 O: POP PUSH 1 ADD PUSH [tag] 554
*)
Example BottleCastle_run_code_of_0_block_610_1: equiv_checker [POP;PUSH 1 (natToWord WLen 1);Opcode ADD;PUSH 2 (natToWord WLen 554)] [POP;PUSH 1 (natToWord WLen 1);Opcode ADD;PUSH 2 (natToWord WLen 554)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP1
 O: POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_611_0: equiv_checker [POP;DUP 1] [POP;DUP 1] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 559 PUSH [tag] 560 DUP5 PUSH [tag] 561
 O: PUSH 0 PUSH [tag] 559 PUSH [tag] 560 DUP5 PUSH [tag] 561
*)
Example BottleCastle_run_code_of_0_block_612_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 559);PUSH 2 (natToWord WLen 560);DUP 5;PUSH 2 (natToWord WLen 561)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 559);PUSH 2 (natToWord WLen 560);DUP 5;PUSH 2 (natToWord WLen 561)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 562
 O: PUSH [tag] 562
*)
Example BottleCastle_run_code_of_0_block_613_0: equiv_checker [PUSH 2 (natToWord WLen 562)] [PUSH 2 (natToWord WLen 562)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP DUP3 DUP2
 O: SWAP1 POP DUP3 DUP2
*)
Example BottleCastle_run_code_of_0_block_614_0: equiv_checker [DUP 1;POP;DUP 3;DUP 2] [DUP 1;POP;DUP 3;DUP 2] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP2 ADD DUP5 DUP5 DUP5 ADD GT ISZERO PUSH [tag] 563
 O: DUP1 PUSH 20 ADD DUP5 DUP4 DUP6 ADD GT ISZERO PUSH [tag] 563
*)
Example BottleCastle_run_code_of_0_block_614_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 5;DUP 4;DUP 6;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 563)] [PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;DUP 5;DUP 5;DUP 5;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 563)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 564 PUSH [tag] 565
 O: PUSH [tag] 564 PUSH [tag] 565
*)
Example BottleCastle_run_code_of_0_block_615_0: equiv_checker [PUSH 2 (natToWord WLen 564);PUSH 2 (natToWord WLen 565)] [PUSH 2 (natToWord WLen 564);PUSH 2 (natToWord WLen 565)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 566 DUP5 DUP3 DUP6 PUSH [tag] 567
 O: PUSH [tag] 566 DUP5 DUP3 DUP6 PUSH [tag] 567
*)
Example BottleCastle_run_code_of_0_block_617_0: equiv_checker [PUSH 2 (natToWord WLen 566);DUP 5;DUP 3;DUP 6;PUSH 2 (natToWord WLen 567)] [PUSH 2 (natToWord WLen 566);DUP 5;DUP 3;DUP 6;PUSH 2 (natToWord WLen 567)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP4 SWAP3 POP POP POP
 O: POP SWAP4 SWAP3 POP POP POP
*)
Example BottleCastle_run_code_of_0_block_618_0: equiv_checker [POP;DUP 4;DUP 3;POP;POP;POP] [POP;DUP 4;DUP 3;POP;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 570 PUSH [tag] 571 DUP5 PUSH [tag] 572
 O: PUSH 0 PUSH [tag] 570 PUSH [tag] 571 DUP5 PUSH [tag] 572
*)
Example BottleCastle_run_code_of_0_block_619_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 570);PUSH 2 (natToWord WLen 571);DUP 5;PUSH 2 (natToWord WLen 572)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 570);PUSH 2 (natToWord WLen 571);DUP 5;PUSH 2 (natToWord WLen 572)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 562
 O: PUSH [tag] 562
*)
Example BottleCastle_run_code_of_0_block_620_0: equiv_checker [PUSH 2 (natToWord WLen 562)] [PUSH 2 (natToWord WLen 562)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP DUP3 DUP2
 O: SWAP1 POP DUP3 DUP2
*)
Example BottleCastle_run_code_of_0_block_621_0: equiv_checker [DUP 1;POP;DUP 3;DUP 2] [DUP 1;POP;DUP 3;DUP 2] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP2 ADD DUP5 DUP5 DUP5 ADD GT ISZERO PUSH [tag] 573
 O: DUP1 PUSH 20 ADD DUP5 DUP4 DUP6 ADD GT ISZERO PUSH [tag] 573
*)
Example BottleCastle_run_code_of_0_block_621_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 5;DUP 4;DUP 6;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 573)] [PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;DUP 5;DUP 5;DUP 5;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 573)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 574 PUSH [tag] 565
 O: PUSH [tag] 574 PUSH [tag] 565
*)
Example BottleCastle_run_code_of_0_block_622_0: equiv_checker [PUSH 2 (natToWord WLen 574);PUSH 2 (natToWord WLen 565)] [PUSH 2 (natToWord WLen 574);PUSH 2 (natToWord WLen 565)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 575 DUP5 DUP3 DUP6 PUSH [tag] 567
 O: PUSH [tag] 575 DUP5 DUP3 DUP6 PUSH [tag] 567
*)
Example BottleCastle_run_code_of_0_block_624_0: equiv_checker [PUSH 2 (natToWord WLen 575);DUP 5;DUP 3;DUP 6;PUSH 2 (natToWord WLen 567)] [PUSH 2 (natToWord WLen 575);DUP 5;DUP 3;DUP 6;PUSH 2 (natToWord WLen 567)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP4 SWAP3 POP POP POP
 O: POP SWAP4 SWAP3 POP POP POP
*)
Example BottleCastle_run_code_of_0_block_625_0: equiv_checker [POP;DUP 4;DUP 3;POP;POP;POP] [POP;DUP 4;DUP 3;POP;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 578 DUP2 PUSH [tag] 579
 O: DUP1 CALLDATALOAD PUSH [tag] 578 DUP2 PUSH [tag] 579
*)
Example BottleCastle_run_code_of_0_block_626_0: equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 2 (natToWord WLen 578);DUP 2;PUSH 2 (natToWord WLen 579)] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode CALLDATALOAD;DUP 1;POP;PUSH 2 (natToWord WLen 578);DUP 2;PUSH 2 (natToWord WLen 579)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Example BottleCastle_run_code_of_0_block_627_0: equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 582 DUP2 PUSH [tag] 583
 O: DUP1 CALLDATALOAD PUSH [tag] 582 DUP2 PUSH [tag] 583
*)
Example BottleCastle_run_code_of_0_block_628_0: equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 2 (natToWord WLen 582);DUP 2;PUSH 2 (natToWord WLen 583)] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode CALLDATALOAD;DUP 1;POP;PUSH 2 (natToWord WLen 582);DUP 2;PUSH 2 (natToWord WLen 583)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Example BottleCastle_run_code_of_0_block_629_0: equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 586 DUP2 PUSH [tag] 587
 O: DUP1 CALLDATALOAD PUSH [tag] 586 DUP2 PUSH [tag] 587
*)
Example BottleCastle_run_code_of_0_block_630_0: equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 2 (natToWord WLen 586);DUP 2;PUSH 2 (natToWord WLen 587)] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode CALLDATALOAD;DUP 1;POP;PUSH 2 (natToWord WLen 586);DUP 2;PUSH 2 (natToWord WLen 587)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Example BottleCastle_run_code_of_0_block_631_0: equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP PUSH [tag] 590 DUP2 PUSH [tag] 587
 O: DUP1 MLOAD PUSH [tag] 590 DUP2 PUSH [tag] 587
*)
Example BottleCastle_run_code_of_0_block_632_0: equiv_checker [DUP 1;Opcode MLOAD;PUSH 2 (natToWord WLen 590);DUP 2;PUSH 2 (natToWord WLen 587)] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode MLOAD;DUP 1;POP;PUSH 2 (natToWord WLen 590);DUP 2;PUSH 2 (natToWord WLen 587)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Example BottleCastle_run_code_of_0_block_633_0: equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 593
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 593
*)
Example BottleCastle_run_code_of_0_block_634_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 3;DUP 3;PUSH 1 (natToWord WLen 31);Opcode ADD;Opcode SLT;PUSH 2 (natToWord WLen 593)] [PUSH 1 (natToWord WLen 0);DUP 3;PUSH 1 (natToWord WLen 31);DUP 4;Opcode ADD;Opcode SLT;PUSH 2 (natToWord WLen 593)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 594 PUSH [tag] 595
 O: PUSH [tag] 594 PUSH [tag] 595
*)
Example BottleCastle_run_code_of_0_block_635_0: equiv_checker [PUSH 2 (natToWord WLen 594);PUSH 2 (natToWord WLen 595)] [PUSH 2 (natToWord WLen 594);PUSH 2 (natToWord WLen 595)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 CALLDATALOAD PUSH [tag] 596 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 557
 O: DUP2 CALLDATALOAD PUSH [tag] 596 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 557
*)
Example BottleCastle_run_code_of_0_block_637_0: equiv_checker [DUP 2;Opcode CALLDATALOAD;PUSH 2 (natToWord WLen 596);DUP 5;DUP 3;PUSH 1 (natToWord WLen 32);DUP 7;Opcode ADD;PUSH 2 (natToWord WLen 557)] [DUP 2;Opcode CALLDATALOAD;PUSH 2 (natToWord WLen 596);DUP 5;DUP 3;PUSH 1 (natToWord WLen 32);DUP 7;Opcode ADD;PUSH 2 (natToWord WLen 557)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Example BottleCastle_run_code_of_0_block_638_0: equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 599
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 599
*)
Example BottleCastle_run_code_of_0_block_639_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 3;DUP 3;PUSH 1 (natToWord WLen 31);Opcode ADD;Opcode SLT;PUSH 2 (natToWord WLen 599)] [PUSH 1 (natToWord WLen 0);DUP 3;PUSH 1 (natToWord WLen 31);DUP 4;Opcode ADD;Opcode SLT;PUSH 2 (natToWord WLen 599)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 600 PUSH [tag] 595
 O: PUSH [tag] 600 PUSH [tag] 595
*)
Example BottleCastle_run_code_of_0_block_640_0: equiv_checker [PUSH 2 (natToWord WLen 600);PUSH 2 (natToWord WLen 595)] [PUSH 2 (natToWord WLen 600);PUSH 2 (natToWord WLen 595)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 CALLDATALOAD PUSH [tag] 601 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 568
 O: DUP2 CALLDATALOAD PUSH [tag] 601 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 568
*)
Example BottleCastle_run_code_of_0_block_642_0: equiv_checker [DUP 2;Opcode CALLDATALOAD;PUSH 2 (natToWord WLen 601);DUP 5;DUP 3;PUSH 1 (natToWord WLen 32);DUP 7;Opcode ADD;PUSH 2 (natToWord WLen 568)] [DUP 2;Opcode CALLDATALOAD;PUSH 2 (natToWord WLen 601);DUP 5;DUP 3;PUSH 1 (natToWord WLen 32);DUP 7;Opcode ADD;PUSH 2 (natToWord WLen 568)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Example BottleCastle_run_code_of_0_block_643_0: equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 604 DUP2 PUSH [tag] 605
 O: DUP1 CALLDATALOAD PUSH [tag] 604 DUP2 PUSH [tag] 605
*)
Example BottleCastle_run_code_of_0_block_644_0: equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 2 (natToWord WLen 604);DUP 2;PUSH 2 (natToWord WLen 605)] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode CALLDATALOAD;DUP 1;POP;PUSH 2 (natToWord WLen 604);DUP 2;PUSH 2 (natToWord WLen 605)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Example BottleCastle_run_code_of_0_block_645_0: equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 607
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 607
*)
Example BottleCastle_run_code_of_0_block_646_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 607)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 607)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 608 PUSH [tag] 609
 O: PUSH [tag] 608 PUSH [tag] 609
*)
Example BottleCastle_run_code_of_0_block_647_0: equiv_checker [PUSH 2 (natToWord WLen 608);PUSH 2 (natToWord WLen 609)] [PUSH 2 (natToWord WLen 608);PUSH 2 (natToWord WLen 609)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 610 DUP5 DUP3 DUP6 ADD PUSH [tag] 576
 O: PUSH 0 PUSH [tag] 610 DUP5 DUP5 DUP4 ADD PUSH [tag] 576
*)
Example BottleCastle_run_code_of_0_block_649_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 610);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 576)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 610);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 2 (natToWord WLen 576)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Example BottleCastle_run_code_of_0_block_650_0: equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 612
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 612
*)
Example BottleCastle_run_code_of_0_block_651_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 64);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 612)] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 64);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 612)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 613 PUSH [tag] 609
 O: PUSH [tag] 613 PUSH [tag] 609
*)
Example BottleCastle_run_code_of_0_block_652_0: equiv_checker [PUSH 2 (natToWord WLen 613);PUSH 2 (natToWord WLen 609)] [PUSH 2 (natToWord WLen 613);PUSH 2 (natToWord WLen 609)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 614 DUP6 DUP3 DUP7 ADD PUSH [tag] 576
 O: PUSH 0 PUSH [tag] 614 DUP6 DUP6 DUP4 ADD PUSH [tag] 576
*)
Example BottleCastle_run_code_of_0_block_654_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 614);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 576)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 614);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (natToWord WLen 576)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 615 DUP6 DUP3 DUP7 ADD PUSH [tag] 576
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 615 DUP6 DUP6 DUP4 ADD PUSH [tag] 576
*)
Example BottleCastle_run_code_of_0_block_655_0: equiv_checker [DUP 3;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 615);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 576)] [DUP 3;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 615);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (natToWord WLen 576)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_656_0: equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH 0 PUSH 60 DUP5 DUP7 SUB SLT ISZERO PUSH [tag] 617
 O: PUSH 0 DUP1 DUP2 PUSH 60 DUP5 DUP7 SUB SLT ISZERO PUSH [tag] 617
*)
Example BottleCastle_run_code_of_0_block_657_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;DUP 2;PUSH 1 (natToWord WLen 96);DUP 5;DUP 7;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 617)] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 96);DUP 5;DUP 7;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 617)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 618 PUSH [tag] 609
 O: PUSH [tag] 618 PUSH [tag] 609
*)
Example BottleCastle_run_code_of_0_block_658_0: equiv_checker [PUSH 2 (natToWord WLen 618);PUSH 2 (natToWord WLen 609)] [PUSH 2 (natToWord WLen 618);PUSH 2 (natToWord WLen 609)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 619 DUP7 DUP3 DUP8 ADD PUSH [tag] 576
 O: PUSH 0 PUSH [tag] 619 DUP7 DUP7 DUP4 ADD PUSH [tag] 576
*)
Example BottleCastle_run_code_of_0_block_660_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 619);DUP 7;DUP 7;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 576)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 619);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 2 (natToWord WLen 576)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP4 POP POP PUSH 20 PUSH [tag] 620 DUP7 DUP3 DUP8 ADD PUSH [tag] 576
 O: SWAP4 POP POP PUSH 20 PUSH [tag] 620 DUP7 DUP7 DUP4 ADD PUSH [tag] 576
*)
Example BottleCastle_run_code_of_0_block_661_0: equiv_checker [DUP 4;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 620);DUP 7;DUP 7;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 576)] [DUP 4;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 620);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 2 (natToWord WLen 576)] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP POP PUSH 40 PUSH [tag] 621 DUP7 DUP3 DUP8 ADD PUSH [tag] 602
 O: SWAP3 POP POP PUSH 40 PUSH [tag] 621 DUP7 DUP3 DUP8 ADD PUSH [tag] 602
*)
Example BottleCastle_run_code_of_0_block_662_0: equiv_checker [DUP 3;POP;POP;PUSH 1 (natToWord WLen 64);PUSH 2 (natToWord WLen 621);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 2 (natToWord WLen 602)] [DUP 3;POP;POP;PUSH 1 (natToWord WLen 64);PUSH 2 (natToWord WLen 621);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 2 (natToWord WLen 602)] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 POP SWAP3
 O: SWAP5 POP POP POP SWAP3 POP SWAP3
*)
Example BottleCastle_run_code_of_0_block_663_0: equiv_checker [DUP 5;POP;POP;POP;DUP 3;POP;DUP 3] [DUP 2;POP;POP;DUP 3;POP;DUP 3;POP;DUP 3] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH 0 DUP1 PUSH 80 DUP6 DUP8 SUB SLT ISZERO PUSH [tag] 623
 O: PUSH 0 DUP1 DUP1 DUP3 PUSH 80 DUP6 DUP8 SUB SLT ISZERO PUSH [tag] 623
*)
Example BottleCastle_run_code_of_0_block_664_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;DUP 1;DUP 3;PUSH 1 (natToWord WLen 128);DUP 6;DUP 8;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 623)] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 128);DUP 6;DUP 8;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 623)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 624 PUSH [tag] 609
 O: PUSH [tag] 624 PUSH [tag] 609
*)
Example BottleCastle_run_code_of_0_block_665_0: equiv_checker [PUSH 2 (natToWord WLen 624);PUSH 2 (natToWord WLen 609)] [PUSH 2 (natToWord WLen 624);PUSH 2 (natToWord WLen 609)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 625 DUP8 DUP3 DUP9 ADD PUSH [tag] 576
 O: PUSH 0 PUSH [tag] 625 DUP8 DUP8 DUP4 ADD PUSH [tag] 576
*)
Example BottleCastle_run_code_of_0_block_667_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 625);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 576)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 625);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 2 (natToWord WLen 576)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP5 POP POP PUSH 20 PUSH [tag] 626 DUP8 DUP3 DUP9 ADD PUSH [tag] 576
 O: SWAP5 POP POP PUSH 20 PUSH [tag] 626 DUP8 DUP8 DUP4 ADD PUSH [tag] 576
*)
Example BottleCastle_run_code_of_0_block_668_0: equiv_checker [DUP 5;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 626);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 576)] [DUP 5;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 626);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 2 (natToWord WLen 576)] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP4 POP POP PUSH 40 PUSH [tag] 627 DUP8 DUP3 DUP9 ADD PUSH [tag] 602
 O: SWAP4 POP POP PUSH 40 PUSH [tag] 627 DUP8 DUP8 DUP4 ADD PUSH [tag] 602
*)
Example BottleCastle_run_code_of_0_block_669_0: equiv_checker [DUP 4;POP;POP;PUSH 1 (natToWord WLen 64);PUSH 2 (natToWord WLen 627);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 602)] [DUP 4;POP;POP;PUSH 1 (natToWord WLen 64);PUSH 2 (natToWord WLen 627);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 2 (natToWord WLen 602)] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP POP PUSH 60 DUP6 ADD CALLDATALOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 628
 O: SWAP3 POP POP DUP5 PUSH 60 ADD CALLDATALOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 628
*)
Example BottleCastle_run_code_of_0_block_670_0: equiv_checker [DUP 3;POP;POP;DUP 5;PUSH 1 (natToWord WLen 96);Opcode ADD;Opcode CALLDATALOAD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 628)] [DUP 3;POP;POP;PUSH 1 (natToWord WLen 96);DUP 6;Opcode ADD;Opcode CALLDATALOAD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 628)] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 629 PUSH [tag] 630
 O: PUSH [tag] 629 PUSH [tag] 630
*)
Example BottleCastle_run_code_of_0_block_671_0: equiv_checker [PUSH 2 (natToWord WLen 629);PUSH 2 (natToWord WLen 630)] [PUSH 2 (natToWord WLen 629);PUSH 2 (natToWord WLen 630)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 631 DUP8 DUP3 DUP9 ADD PUSH [tag] 591
 O: PUSH [tag] 631 DUP8 DUP8 DUP4 ADD PUSH [tag] 591
*)
Example BottleCastle_run_code_of_0_block_673_0: equiv_checker [PUSH 2 (natToWord WLen 631);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 591)] [PUSH 2 (natToWord WLen 631);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 2 (natToWord WLen 591)] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 SWAP6 SWAP2 SWAP5 POP SWAP3 POP
 O: SWAP5 SWAP8 SWAP4 SWAP7 POP POP POP SWAP3 POP
*)
Example BottleCastle_run_code_of_0_block_674_0: equiv_checker [DUP 5;DUP 8;DUP 4;DUP 7;POP;POP;POP;DUP 3;POP] [DUP 2;POP;POP;DUP 3;DUP 6;DUP 2;DUP 5;POP;DUP 3;POP] 9 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 633
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 633
*)
Example BottleCastle_run_code_of_0_block_675_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 64);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 633)] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 64);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 633)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 634 PUSH [tag] 609
 O: PUSH [tag] 634 PUSH [tag] 609
*)
Example BottleCastle_run_code_of_0_block_676_0: equiv_checker [PUSH 2 (natToWord WLen 634);PUSH 2 (natToWord WLen 609)] [PUSH 2 (natToWord WLen 634);PUSH 2 (natToWord WLen 609)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 635 DUP6 DUP3 DUP7 ADD PUSH [tag] 576
 O: PUSH 0 PUSH [tag] 635 DUP6 DUP6 DUP4 ADD PUSH [tag] 576
*)
Example BottleCastle_run_code_of_0_block_678_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 635);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 576)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 635);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (natToWord WLen 576)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 636 DUP6 DUP3 DUP7 ADD PUSH [tag] 580
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 636 DUP6 DUP6 DUP4 ADD PUSH [tag] 580
*)
Example BottleCastle_run_code_of_0_block_679_0: equiv_checker [DUP 3;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 636);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 580)] [DUP 3;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 636);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (natToWord WLen 580)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_680_0: equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 638
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 638
*)
Example BottleCastle_run_code_of_0_block_681_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 64);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 638)] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 64);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 638)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 639 PUSH [tag] 609
 O: PUSH [tag] 639 PUSH [tag] 609
*)
Example BottleCastle_run_code_of_0_block_682_0: equiv_checker [PUSH 2 (natToWord WLen 639);PUSH 2 (natToWord WLen 609)] [PUSH 2 (natToWord WLen 639);PUSH 2 (natToWord WLen 609)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 640 DUP6 DUP3 DUP7 ADD PUSH [tag] 576
 O: PUSH 0 PUSH [tag] 640 DUP6 DUP6 DUP4 ADD PUSH [tag] 576
*)
Example BottleCastle_run_code_of_0_block_684_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 640);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 576)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 640);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (natToWord WLen 576)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 641 DUP6 DUP3 DUP7 ADD PUSH [tag] 602
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 641 DUP6 DUP6 DUP4 ADD PUSH [tag] 602
*)
Example BottleCastle_run_code_of_0_block_685_0: equiv_checker [DUP 3;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 641);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 602)] [DUP 3;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 641);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (natToWord WLen 602)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_686_0: equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 643
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 643
*)
Example BottleCastle_run_code_of_0_block_687_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 643)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 643)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 644 PUSH [tag] 609
 O: PUSH [tag] 644 PUSH [tag] 609
*)
Example BottleCastle_run_code_of_0_block_688_0: equiv_checker [PUSH 2 (natToWord WLen 644);PUSH 2 (natToWord WLen 609)] [PUSH 2 (natToWord WLen 644);PUSH 2 (natToWord WLen 609)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 645 DUP5 DUP3 DUP6 ADD PUSH [tag] 580
 O: PUSH 0 PUSH [tag] 645 DUP5 DUP5 DUP4 ADD PUSH [tag] 580
*)
Example BottleCastle_run_code_of_0_block_690_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 645);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 580)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 645);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 2 (natToWord WLen 580)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Example BottleCastle_run_code_of_0_block_691_0: equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 647
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 647
*)
Example BottleCastle_run_code_of_0_block_692_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 647)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 647)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 648 PUSH [tag] 609
 O: PUSH [tag] 648 PUSH [tag] 609
*)
Example BottleCastle_run_code_of_0_block_693_0: equiv_checker [PUSH 2 (natToWord WLen 648);PUSH 2 (natToWord WLen 609)] [PUSH 2 (natToWord WLen 648);PUSH 2 (natToWord WLen 609)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 649 DUP5 DUP3 DUP6 ADD PUSH [tag] 584
 O: PUSH 0 PUSH [tag] 649 DUP5 DUP5 DUP4 ADD PUSH [tag] 584
*)
Example BottleCastle_run_code_of_0_block_695_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 649);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 584)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 649);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 2 (natToWord WLen 584)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Example BottleCastle_run_code_of_0_block_696_0: equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 651
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 651
*)
Example BottleCastle_run_code_of_0_block_697_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 651)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 651)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 652 PUSH [tag] 609
 O: PUSH [tag] 652 PUSH [tag] 609
*)
Example BottleCastle_run_code_of_0_block_698_0: equiv_checker [PUSH 2 (natToWord WLen 652);PUSH 2 (natToWord WLen 609)] [PUSH 2 (natToWord WLen 652);PUSH 2 (natToWord WLen 609)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 653 DUP5 DUP3 DUP6 ADD PUSH [tag] 588
 O: PUSH 0 PUSH [tag] 653 DUP5 DUP5 DUP4 ADD PUSH [tag] 588
*)
Example BottleCastle_run_code_of_0_block_700_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 653);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 588)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 653);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 2 (natToWord WLen 588)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Example BottleCastle_run_code_of_0_block_701_0: equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 655
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 655
*)
Example BottleCastle_run_code_of_0_block_702_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 655)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 655)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 656 PUSH [tag] 609
 O: PUSH [tag] 656 PUSH [tag] 609
*)
Example BottleCastle_run_code_of_0_block_703_0: equiv_checker [PUSH 2 (natToWord WLen 656);PUSH 2 (natToWord WLen 609)] [PUSH 2 (natToWord WLen 656);PUSH 2 (natToWord WLen 609)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP3 ADD CALLDATALOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 657
 O: DUP2 PUSH 0 ADD CALLDATALOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 657
*)
Example BottleCastle_run_code_of_0_block_705_0: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 0);Opcode ADD;Opcode CALLDATALOAD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 657)] [PUSH 1 (natToWord WLen 0);DUP 3;Opcode ADD;Opcode CALLDATALOAD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 657)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 658 PUSH [tag] 630
 O: PUSH [tag] 658 PUSH [tag] 630
*)
Example BottleCastle_run_code_of_0_block_706_0: equiv_checker [PUSH 2 (natToWord WLen 658);PUSH 2 (natToWord WLen 630)] [PUSH 2 (natToWord WLen 658);PUSH 2 (natToWord WLen 630)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 659 DUP5 DUP3 DUP6 ADD PUSH [tag] 597
 O: PUSH [tag] 659 DUP5 DUP5 DUP4 ADD PUSH [tag] 597
*)
Example BottleCastle_run_code_of_0_block_708_0: equiv_checker [PUSH 2 (natToWord WLen 659);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 597)] [PUSH 2 (natToWord WLen 659);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 2 (natToWord WLen 597)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Example BottleCastle_run_code_of_0_block_709_0: equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 661
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 661
*)
Example BottleCastle_run_code_of_0_block_710_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 661)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 661)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 662 PUSH [tag] 609
 O: PUSH [tag] 662 PUSH [tag] 609
*)
Example BottleCastle_run_code_of_0_block_711_0: equiv_checker [PUSH 2 (natToWord WLen 662);PUSH 2 (natToWord WLen 609)] [PUSH 2 (natToWord WLen 662);PUSH 2 (natToWord WLen 609)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 663 DUP5 DUP3 DUP6 ADD PUSH [tag] 602
 O: PUSH 0 PUSH [tag] 663 DUP5 DUP5 DUP4 ADD PUSH [tag] 602
*)
Example BottleCastle_run_code_of_0_block_713_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 663);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 602)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 663);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 2 (natToWord WLen 602)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Example BottleCastle_run_code_of_0_block_714_0: equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 665
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 665
*)
Example BottleCastle_run_code_of_0_block_715_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 64);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 665)] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 64);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 665)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 666 PUSH [tag] 609
 O: PUSH [tag] 666 PUSH [tag] 609
*)
Example BottleCastle_run_code_of_0_block_716_0: equiv_checker [PUSH 2 (natToWord WLen 666);PUSH 2 (natToWord WLen 609)] [PUSH 2 (natToWord WLen 666);PUSH 2 (natToWord WLen 609)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 667 DUP6 DUP3 DUP7 ADD PUSH [tag] 602
 O: PUSH 0 PUSH [tag] 667 DUP6 DUP6 DUP4 ADD PUSH [tag] 602
*)
Example BottleCastle_run_code_of_0_block_718_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 667);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 602)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 667);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (natToWord WLen 602)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 668 DUP6 DUP3 DUP7 ADD PUSH [tag] 576
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 668 DUP6 DUP6 DUP4 ADD PUSH [tag] 576
*)
Example BottleCastle_run_code_of_0_block_719_0: equiv_checker [DUP 3;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 668);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 2 (natToWord WLen 576)] [DUP 3;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 668);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 2 (natToWord WLen 576)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_720_0: equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 671 DUP4 DUP4 PUSH [tag] 672
 O: PUSH 0 PUSH [tag] 671 DUP4 DUP4 PUSH [tag] 672
*)
Example BottleCastle_run_code_of_0_block_721_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 671);DUP 4;DUP 4;PUSH 2 (natToWord WLen 672)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 671);DUP 4;DUP 4;PUSH 2 (natToWord WLen 672)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP4 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP POP PUSH 20 ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_722_0: equiv_checker [POP;POP;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 32);DUP 4;Opcode ADD;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 675 DUP2 PUSH [tag] 676
 O: PUSH [tag] 675 DUP2 PUSH [tag] 676
*)
Example BottleCastle_run_code_of_0_block_723_0: equiv_checker [PUSH 2 (natToWord WLen 675);DUP 2;PUSH 2 (natToWord WLen 676)] [PUSH 2 (natToWord WLen 675);DUP 2;PUSH 2 (natToWord WLen 676)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3
 O: DUP3
*)
Example BottleCastle_run_code_of_0_block_724_0: equiv_checker [DUP 3] [DUP 3] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_run_code_of_0_block_724_1: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 679 DUP3 PUSH [tag] 680
 O: PUSH 0 PUSH [tag] 679 DUP3 PUSH [tag] 680
*)
Example BottleCastle_run_code_of_0_block_725_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 679);DUP 3;PUSH 2 (natToWord WLen 680)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 679);DUP 3;PUSH 2 (natToWord WLen 680)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 681 DUP2 DUP6 PUSH [tag] 682
 O: PUSH [tag] 681 DUP2 DUP6 PUSH [tag] 682
*)
Example BottleCastle_run_code_of_0_block_726_0: equiv_checker [PUSH 2 (natToWord WLen 681);DUP 2;DUP 6;PUSH 2 (natToWord WLen 682)] [PUSH 2 (natToWord WLen 681);DUP 2;DUP 6;PUSH 2 (natToWord WLen 682)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP4 POP PUSH [tag] 683 DUP4 PUSH [tag] 684
 O: SWAP4 POP PUSH [tag] 683 DUP4 PUSH [tag] 684
*)
Example BottleCastle_run_code_of_0_block_727_0: equiv_checker [DUP 4;POP;PUSH 2 (natToWord WLen 683);DUP 4;PUSH 2 (natToWord WLen 684)] [DUP 4;POP;PUSH 2 (natToWord WLen 683);DUP 4;PUSH 2 (natToWord WLen 684)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 0
 O: DUP1 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_728_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 0)] [DUP 1;PUSH 1 (natToWord WLen 0)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP4 DUP2 LT ISZERO PUSH [tag] 687
 O: DUP4 DUP2 LT ISZERO PUSH [tag] 687
*)
Example BottleCastle_run_code_of_0_block_729_0: equiv_checker [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (natToWord WLen 687)] [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (natToWord WLen 687)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 MLOAD PUSH [tag] 688 DUP9 DUP3 PUSH [tag] 669
 O: DUP2 MLOAD PUSH [tag] 688 DUP9 DUP3 PUSH [tag] 669
*)
Example BottleCastle_run_code_of_0_block_730_0: equiv_checker [DUP 2;Opcode MLOAD;PUSH 2 (natToWord WLen 688);DUP 9;DUP 3;PUSH 2 (natToWord WLen 669)] [DUP 2;Opcode MLOAD;PUSH 2 (natToWord WLen 688);DUP 9;DUP 3;PUSH 2 (natToWord WLen 669)] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP8 POP PUSH [tag] 689 DUP4 PUSH [tag] 690
 O: SWAP8 POP PUSH [tag] 689 DUP4 PUSH [tag] 690
*)
Example BottleCastle_run_code_of_0_block_731_0: equiv_checker [DUP 8;POP;PUSH 2 (natToWord WLen 689);DUP 4;PUSH 2 (natToWord WLen 690)] [DUP 8;POP;PUSH 2 (natToWord WLen 689);DUP 4;PUSH 2 (natToWord WLen 690)] 9 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP POP PUSH 1 DUP2 ADD SWAP1 POP PUSH [tag] 685
 O: SWAP3 POP POP PUSH 1 ADD PUSH [tag] 685
*)
Example BottleCastle_run_code_of_0_block_732_0: equiv_checker [DUP 3;POP;POP;PUSH 1 (natToWord WLen 1);Opcode ADD;PUSH 2 (natToWord WLen 685)] [DUP 3;POP;POP;PUSH 1 (natToWord WLen 1);DUP 2;Opcode ADD;DUP 1;POP;PUSH 2 (natToWord WLen 685)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP DUP6 SWAP4 POP POP POP POP SWAP3 SWAP2 POP POP
 O: POP POP POP POP POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_733_0: equiv_checker [POP;POP;POP;POP;POP;POP;DUP 1] [POP;DUP 6;DUP 4;POP;POP;POP;POP;DUP 3;DUP 2;POP;POP] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 693 DUP2 PUSH [tag] 694
 O: PUSH [tag] 693 DUP2 PUSH [tag] 694
*)
Example BottleCastle_run_code_of_0_block_734_0: equiv_checker [PUSH 2 (natToWord WLen 693);DUP 2;PUSH 2 (natToWord WLen 694)] [PUSH 2 (natToWord WLen 693);DUP 2;PUSH 2 (natToWord WLen 694)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3
 O: DUP3
*)
Example BottleCastle_run_code_of_0_block_735_0: equiv_checker [DUP 3] [DUP 3] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_run_code_of_0_block_735_1: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 697 DUP3 PUSH [tag] 698
 O: PUSH 0 PUSH [tag] 697 DUP3 PUSH [tag] 698
*)
Example BottleCastle_run_code_of_0_block_736_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 697);DUP 3;PUSH 2 (natToWord WLen 698)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 697);DUP 3;PUSH 2 (natToWord WLen 698)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 699 DUP2 DUP6 PUSH [tag] 700
 O: PUSH [tag] 699 DUP2 DUP6 PUSH [tag] 700
*)
Example BottleCastle_run_code_of_0_block_737_0: equiv_checker [PUSH 2 (natToWord WLen 699);DUP 2;DUP 6;PUSH 2 (natToWord WLen 700)] [PUSH 2 (natToWord WLen 699);DUP 2;DUP 6;PUSH 2 (natToWord WLen 700)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP4 POP PUSH [tag] 701 DUP2 DUP6 PUSH 20 DUP7 ADD PUSH [tag] 702
 O: SWAP4 POP PUSH [tag] 701 DUP2 DUP6 DUP6 PUSH 20 ADD PUSH [tag] 702
*)
Example BottleCastle_run_code_of_0_block_738_0: equiv_checker [DUP 4;POP;PUSH 2 (natToWord WLen 701);DUP 2;DUP 6;DUP 6;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 2 (natToWord WLen 702)] [DUP 4;POP;PUSH 2 (natToWord WLen 701);DUP 2;DUP 6;PUSH 1 (natToWord WLen 32);DUP 7;Opcode ADD;PUSH 2 (natToWord WLen 702)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 703 DUP2 PUSH [tag] 704
 O: PUSH [tag] 703 DUP2 PUSH [tag] 704
*)
Example BottleCastle_run_code_of_0_block_739_0: equiv_checker [PUSH 2 (natToWord WLen 703);DUP 2;PUSH 2 (natToWord WLen 704)] [PUSH 2 (natToWord WLen 703);DUP 2;PUSH 2 (natToWord WLen 704)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP5 ADD SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP3 POP POP POP ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_740_0: equiv_checker [DUP 3;POP;POP;POP;Opcode ADD;DUP 1] [DUP 5;Opcode ADD;DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 707 DUP3 PUSH [tag] 708
 O: PUSH 0 PUSH [tag] 707 DUP3 PUSH [tag] 708
*)
Example BottleCastle_run_code_of_0_block_741_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 707);DUP 3;PUSH 2 (natToWord WLen 708)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 707);DUP 3;PUSH 2 (natToWord WLen 708)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 709 DUP2 DUP6 PUSH [tag] 710
 O: PUSH [tag] 709 DUP2 DUP6 PUSH [tag] 710
*)
Example BottleCastle_run_code_of_0_block_742_0: equiv_checker [PUSH 2 (natToWord WLen 709);DUP 2;DUP 6;PUSH 2 (natToWord WLen 710)] [PUSH 2 (natToWord WLen 709);DUP 2;DUP 6;PUSH 2 (natToWord WLen 710)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP4 POP PUSH [tag] 711 DUP2 DUP6 PUSH 20 DUP7 ADD PUSH [tag] 702
 O: SWAP4 POP PUSH [tag] 711 DUP2 DUP6 DUP6 PUSH 20 ADD PUSH [tag] 702
*)
Example BottleCastle_run_code_of_0_block_743_0: equiv_checker [DUP 4;POP;PUSH 2 (natToWord WLen 711);DUP 2;DUP 6;DUP 6;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 2 (natToWord WLen 702)] [DUP 4;POP;PUSH 2 (natToWord WLen 711);DUP 2;DUP 6;PUSH 1 (natToWord WLen 32);DUP 7;Opcode ADD;PUSH 2 (natToWord WLen 702)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 712 DUP2 PUSH [tag] 704
 O: PUSH [tag] 712 DUP2 PUSH [tag] 704
*)
Example BottleCastle_run_code_of_0_block_744_0: equiv_checker [PUSH 2 (natToWord WLen 712);DUP 2;PUSH 2 (natToWord WLen 704)] [PUSH 2 (natToWord WLen 712);DUP 2;PUSH 2 (natToWord WLen 704)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP5 ADD SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP3 POP POP POP ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_745_0: equiv_checker [DUP 3;POP;POP;POP;Opcode ADD;DUP 1] [DUP 5;Opcode ADD;DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 715 DUP3 PUSH [tag] 708
 O: PUSH 0 PUSH [tag] 715 DUP3 PUSH [tag] 708
*)
Example BottleCastle_run_code_of_0_block_746_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 715);DUP 3;PUSH 2 (natToWord WLen 708)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 715);DUP 3;PUSH 2 (natToWord WLen 708)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 716 DUP2 DUP6 PUSH [tag] 717
 O: PUSH [tag] 716 DUP2 DUP6 PUSH [tag] 717
*)
Example BottleCastle_run_code_of_0_block_747_0: equiv_checker [PUSH 2 (natToWord WLen 716);DUP 2;DUP 6;PUSH 2 (natToWord WLen 717)] [PUSH 2 (natToWord WLen 716);DUP 2;DUP 6;PUSH 2 (natToWord WLen 717)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP4 POP PUSH [tag] 718 DUP2 DUP6 PUSH 20 DUP7 ADD PUSH [tag] 702
 O: SWAP4 POP PUSH [tag] 718 DUP2 DUP6 DUP6 PUSH 20 ADD PUSH [tag] 702
*)
Example BottleCastle_run_code_of_0_block_748_0: equiv_checker [DUP 4;POP;PUSH 2 (natToWord WLen 718);DUP 2;DUP 6;DUP 6;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 2 (natToWord WLen 702)] [DUP 4;POP;PUSH 2 (natToWord WLen 718);DUP 2;DUP 6;PUSH 1 (natToWord WLen 32);DUP 7;Opcode ADD;PUSH 2 (natToWord WLen 702)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 DUP5 ADD SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP2 POP POP ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_749_0: equiv_checker [DUP 2;POP;POP;Opcode ADD;DUP 1] [DUP 1;DUP 5;Opcode ADD;DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 SLOAD PUSH [tag] 721 DUP2 PUSH [tag] 223
 O: PUSH 0 DUP2 SLOAD PUSH [tag] 721 DUP2 PUSH [tag] 223
*)
Example BottleCastle_run_code_of_0_block_750_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 2;Opcode SLOAD;PUSH 2 (natToWord WLen 721);DUP 2;PUSH 1 (natToWord WLen 223)] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode SLOAD;PUSH 2 (natToWord WLen 721);DUP 2;PUSH 1 (natToWord WLen 223)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 722 DUP2 DUP7 PUSH [tag] 717
 O: PUSH [tag] 722 DUP2 DUP7 PUSH [tag] 717
*)
Example BottleCastle_run_code_of_0_block_751_0: equiv_checker [PUSH 2 (natToWord WLen 722);DUP 2;DUP 7;PUSH 2 (natToWord WLen 717)] [PUSH 2 (natToWord WLen 722);DUP 2;DUP 7;PUSH 2 (natToWord WLen 717)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP5 POP PUSH 1 DUP3 AND PUSH 0 DUP2 EQ PUSH [tag] 724
 O: SWAP5 POP DUP2 PUSH 1 AND PUSH 0 DUP2 EQ PUSH [tag] 724
*)
Example BottleCastle_run_code_of_0_block_752_0: equiv_checker [DUP 5;POP;DUP 2;PUSH 1 (natToWord WLen 1);Opcode AND;PUSH 1 (natToWord WLen 0);DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 724)] [DUP 5;POP;PUSH 1 (natToWord WLen 1);DUP 3;Opcode AND;PUSH 1 (natToWord WLen 0);DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 724)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 1 DUP2 EQ PUSH [tag] 725
 O: DUP1 PUSH 1 EQ PUSH [tag] 725
*)
Example BottleCastle_run_code_of_0_block_753_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 1);Opcode EQ;PUSH 2 (natToWord WLen 725)] [PUSH 1 (natToWord WLen 1);DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 725)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 723
 O: PUSH [tag] 723
*)
Example BottleCastle_run_code_of_0_block_754_0: equiv_checker [PUSH 2 (natToWord WLen 723)] [PUSH 2 (natToWord WLen 723)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH FF NOT DUP4 AND DUP7
 O: PUSH ff NOT DUP4 AND DUP7
*)
Example BottleCastle_run_code_of_0_block_755_0: equiv_checker [PUSH 1 (natToWord WLen 255);Opcode NOT;DUP 4;Opcode AND;DUP 7] [PUSH 1 (natToWord WLen 255);Opcode NOT;DUP 4;Opcode AND;DUP 7] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 DUP7 ADD SWAP4 POP PUSH [tag] 723
 O: DUP2 DUP7 ADD SWAP4 POP PUSH [tag] 723
*)
Example BottleCastle_run_code_of_0_block_755_1: equiv_checker [DUP 2;DUP 7;Opcode ADD;DUP 4;POP;PUSH 2 (natToWord WLen 723)] [DUP 2;DUP 7;Opcode ADD;DUP 4;POP;PUSH 2 (natToWord WLen 723)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 726 DUP6 PUSH [tag] 727
 O: PUSH [tag] 726 DUP6 PUSH [tag] 727
*)
Example BottleCastle_run_code_of_0_block_756_0: equiv_checker [PUSH 2 (natToWord WLen 726);DUP 6;PUSH 2 (natToWord WLen 727)] [PUSH 2 (natToWord WLen 726);DUP 6;PUSH 2 (natToWord WLen 727)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0
 O: PUSH 0
*)
Example BottleCastle_run_code_of_0_block_757_0: equiv_checker [PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP4 DUP2 LT ISZERO PUSH [tag] 730
 O: DUP4 DUP2 LT ISZERO PUSH [tag] 730
*)
Example BottleCastle_run_code_of_0_block_758_0: equiv_checker [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (natToWord WLen 730)] [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (natToWord WLen 730)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 SLOAD DUP2 DUP10 ADD
 O: DUP2 SLOAD DUP9 DUP3 ADD
*)
Example BottleCastle_run_code_of_0_block_759_0: equiv_checker [DUP 2;Opcode SLOAD;DUP 9;DUP 3;Opcode ADD] [DUP 2;Opcode SLOAD;DUP 2;DUP 10;Opcode ADD] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 1 DUP3 ADD SWAP2 POP PUSH 20 DUP2 ADD SWAP1 POP PUSH [tag] 728
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD PUSH [tag] 728
*)
Example BottleCastle_run_code_of_0_block_759_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 2 (natToWord WLen 728)] [PUSH 1 (natToWord WLen 1);DUP 3;Opcode ADD;DUP 2;POP;PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;DUP 1;POP;PUSH 2 (natToWord WLen 728)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP4 DUP9 ADD SWAP6 POP POP POP
 O: POP DUP7 DUP4 ADD SWAP5 POP POP
*)
Example BottleCastle_run_code_of_0_block_760_0: equiv_checker [POP;DUP 7;DUP 4;Opcode ADD;DUP 5;POP;POP] [DUP 4;DUP 9;Opcode ADD;DUP 6;POP;POP;POP] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP SWAP3 SWAP2 POP POP
 O: POP POP POP SWAP3 SWAP2 POP POP
*)
Example BottleCastle_run_code_of_0_block_761_0: equiv_checker [POP;POP;POP;DUP 3;DUP 2;POP;POP] [POP;POP;POP;DUP 3;DUP 2;POP;POP] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 733 PUSH 30 DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 733 PUSH 30 DUP4 PUSH [tag] 710
*)
Example BottleCastle_run_code_of_0_block_762_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 733);PUSH 1 (natToWord WLen 48);DUP 4;PUSH 2 (natToWord WLen 710)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 733);PUSH 1 (natToWord WLen 48);DUP 4;PUSH 2 (natToWord WLen 710)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 734 DUP3 PUSH [tag] 735
 O: SWAP2 POP PUSH [tag] 734 DUP3 PUSH [tag] 735
*)
Example BottleCastle_run_code_of_0_block_763_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 734);DUP 3;PUSH 2 (natToWord WLen 735)] [DUP 2;POP;PUSH 2 (natToWord WLen 734);DUP 3;PUSH 2 (natToWord WLen 735)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 40 ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_764_0: equiv_checker [POP;PUSH 1 (natToWord WLen 64);Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 64);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 738 PUSH 26 DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 738 PUSH 26 DUP4 PUSH [tag] 710
*)
Example BottleCastle_run_code_of_0_block_765_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 738);PUSH 1 (natToWord WLen 38);DUP 4;PUSH 2 (natToWord WLen 710)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 738);PUSH 1 (natToWord WLen 38);DUP 4;PUSH 2 (natToWord WLen 710)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 739 DUP3 PUSH [tag] 740
 O: SWAP2 POP PUSH [tag] 739 DUP3 PUSH [tag] 740
*)
Example BottleCastle_run_code_of_0_block_766_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 739);DUP 3;PUSH 2 (natToWord WLen 740)] [DUP 2;POP;PUSH 2 (natToWord WLen 739);DUP 3;PUSH 2 (natToWord WLen 740)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 40 ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_767_0: equiv_checker [POP;PUSH 1 (natToWord WLen 64);Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 64);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 743 PUSH A DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 743 PUSH a DUP4 PUSH [tag] 710
*)
Example BottleCastle_run_code_of_0_block_768_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 743);PUSH 1 (natToWord WLen 10);DUP 4;PUSH 2 (natToWord WLen 710)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 743);PUSH 1 (natToWord WLen 10);DUP 4;PUSH 2 (natToWord WLen 710)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 744 DUP3 PUSH [tag] 745
 O: SWAP2 POP PUSH [tag] 744 DUP3 PUSH [tag] 745
*)
Example BottleCastle_run_code_of_0_block_769_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 744);DUP 3;PUSH 2 (natToWord WLen 745)] [DUP 2;POP;PUSH 2 (natToWord WLen 744);DUP 3;PUSH 2 (natToWord WLen 745)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_770_0: equiv_checker [POP;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 748 PUSH 17 DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 748 PUSH 17 DUP4 PUSH [tag] 710
*)
Example BottleCastle_run_code_of_0_block_771_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 748);PUSH 1 (natToWord WLen 23);DUP 4;PUSH 2 (natToWord WLen 710)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 748);PUSH 1 (natToWord WLen 23);DUP 4;PUSH 2 (natToWord WLen 710)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 749 DUP3 PUSH [tag] 750
 O: SWAP2 POP PUSH [tag] 749 DUP3 PUSH [tag] 750
*)
Example BottleCastle_run_code_of_0_block_772_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 749);DUP 3;PUSH 2 (natToWord WLen 750)] [DUP 2;POP;PUSH 2 (natToWord WLen 749);DUP 3;PUSH 2 (natToWord WLen 750)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_773_0: equiv_checker [POP;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 753 PUSH 16 DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 753 PUSH 16 DUP4 PUSH [tag] 710
*)
Example BottleCastle_run_code_of_0_block_774_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 753);PUSH 1 (natToWord WLen 22);DUP 4;PUSH 2 (natToWord WLen 710)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 753);PUSH 1 (natToWord WLen 22);DUP 4;PUSH 2 (natToWord WLen 710)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 754 DUP3 PUSH [tag] 755
 O: SWAP2 POP PUSH [tag] 754 DUP3 PUSH [tag] 755
*)
Example BottleCastle_run_code_of_0_block_775_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 754);DUP 3;PUSH 2 (natToWord WLen 755)] [DUP 2;POP;PUSH 2 (natToWord WLen 754);DUP 3;PUSH 2 (natToWord WLen 755)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_776_0: equiv_checker [POP;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 758 PUSH 20 DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 758 PUSH 20 DUP4 PUSH [tag] 710
*)
Example BottleCastle_run_code_of_0_block_777_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 758);PUSH 1 (natToWord WLen 32);DUP 4;PUSH 2 (natToWord WLen 710)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 758);PUSH 1 (natToWord WLen 32);DUP 4;PUSH 2 (natToWord WLen 710)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 759 DUP3 PUSH [tag] 760
 O: SWAP2 POP PUSH [tag] 759 DUP3 PUSH [tag] 760
*)
Example BottleCastle_run_code_of_0_block_778_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 759);DUP 3;PUSH 2 (natToWord WLen 760)] [DUP 2;POP;PUSH 2 (natToWord WLen 759);DUP 3;PUSH 2 (natToWord WLen 760)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_779_0: equiv_checker [POP;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 763 PUSH 12 DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 763 PUSH 12 DUP4 PUSH [tag] 710
*)
Example BottleCastle_run_code_of_0_block_780_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 763);PUSH 1 (natToWord WLen 18);DUP 4;PUSH 2 (natToWord WLen 710)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 763);PUSH 1 (natToWord WLen 18);DUP 4;PUSH 2 (natToWord WLen 710)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 764 DUP3 PUSH [tag] 765
 O: SWAP2 POP PUSH [tag] 764 DUP3 PUSH [tag] 765
*)
Example BottleCastle_run_code_of_0_block_781_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 764);DUP 3;PUSH 2 (natToWord WLen 765)] [DUP 2;POP;PUSH 2 (natToWord WLen 764);DUP 3;PUSH 2 (natToWord WLen 765)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_782_0: equiv_checker [POP;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 768 PUSH 1B DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 768 PUSH 1b DUP4 PUSH [tag] 710
*)
Example BottleCastle_run_code_of_0_block_783_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 768);PUSH 1 (natToWord WLen 27);DUP 4;PUSH 2 (natToWord WLen 710)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 768);PUSH 1 (natToWord WLen 27);DUP 4;PUSH 2 (natToWord WLen 710)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 769 DUP3 PUSH [tag] 770
 O: SWAP2 POP PUSH [tag] 769 DUP3 PUSH [tag] 770
*)
Example BottleCastle_run_code_of_0_block_784_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 769);DUP 3;PUSH 2 (natToWord WLen 770)] [DUP 2;POP;PUSH 2 (natToWord WLen 769);DUP 3;PUSH 2 (natToWord WLen 770)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_785_0: equiv_checker [POP;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 773 PUSH 1F DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 773 PUSH 1f DUP4 PUSH [tag] 710
*)
Example BottleCastle_run_code_of_0_block_786_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 773);PUSH 1 (natToWord WLen 31);DUP 4;PUSH 2 (natToWord WLen 710)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 773);PUSH 1 (natToWord WLen 31);DUP 4;PUSH 2 (natToWord WLen 710)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 774 DUP3 PUSH [tag] 775
 O: SWAP2 POP PUSH [tag] 774 DUP3 PUSH [tag] 775
*)
Example BottleCastle_run_code_of_0_block_787_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 774);DUP 3;PUSH 2 (natToWord WLen 775)] [DUP 2;POP;PUSH 2 (natToWord WLen 774);DUP 3;PUSH 2 (natToWord WLen 775)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_788_0: equiv_checker [POP;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 778 PUSH 1F DUP4 PUSH [tag] 710
 O: PUSH 0 PUSH [tag] 778 PUSH 1f DUP4 PUSH [tag] 710
*)
Example BottleCastle_run_code_of_0_block_789_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 778);PUSH 1 (natToWord WLen 31);DUP 4;PUSH 2 (natToWord WLen 710)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 778);PUSH 1 (natToWord WLen 31);DUP 4;PUSH 2 (natToWord WLen 710)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 779 DUP3 PUSH [tag] 780
 O: SWAP2 POP PUSH [tag] 779 DUP3 PUSH [tag] 780
*)
Example BottleCastle_run_code_of_0_block_790_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 779);DUP 3;PUSH 2 (natToWord WLen 780)] [DUP 2;POP;PUSH 2 (natToWord WLen 779);DUP 3;PUSH 2 (natToWord WLen 780)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 20 ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_791_0: equiv_checker [POP;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 782 DUP2 PUSH [tag] 783
 O: PUSH [tag] 782 DUP2 PUSH [tag] 783
*)
Example BottleCastle_run_code_of_0_block_792_0: equiv_checker [PUSH 2 (natToWord WLen 782);DUP 2;PUSH 2 (natToWord WLen 783)] [PUSH 2 (natToWord WLen 782);DUP 2;PUSH 2 (natToWord WLen 783)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3
 O: DUP3
*)
Example BottleCastle_run_code_of_0_block_793_0: equiv_checker [DUP 3] [DUP 3] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_run_code_of_0_block_793_1: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 786 DUP2 PUSH [tag] 783
 O: PUSH [tag] 786 DUP2 PUSH [tag] 783
*)
Example BottleCastle_run_code_of_0_block_794_0: equiv_checker [PUSH 2 (natToWord WLen 786);DUP 2;PUSH 2 (natToWord WLen 783)] [PUSH 2 (natToWord WLen 786);DUP 2;PUSH 2 (natToWord WLen 783)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3
 O: DUP3
*)
Example BottleCastle_run_code_of_0_block_795_0: equiv_checker [DUP 3] [DUP 3] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example BottleCastle_run_code_of_0_block_795_1: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 788 DUP3 DUP7 PUSH [tag] 713
 O: PUSH 0 PUSH [tag] 788 DUP3 DUP7 PUSH [tag] 713
*)
Example BottleCastle_run_code_of_0_block_796_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 788);DUP 3;DUP 7;PUSH 2 (natToWord WLen 713)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 788);DUP 3;DUP 7;PUSH 2 (natToWord WLen 713)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 789 DUP3 DUP6 PUSH [tag] 713
 O: SWAP2 POP PUSH [tag] 789 DUP3 DUP6 PUSH [tag] 713
*)
Example BottleCastle_run_code_of_0_block_797_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 789);DUP 3;DUP 6;PUSH 2 (natToWord WLen 713)] [DUP 2;POP;PUSH 2 (natToWord WLen 789);DUP 3;DUP 6;PUSH 2 (natToWord WLen 713)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 790 DUP3 DUP5 PUSH [tag] 719
 O: SWAP2 POP PUSH [tag] 790 DUP3 DUP5 PUSH [tag] 719
*)
Example BottleCastle_run_code_of_0_block_798_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 790);DUP 3;DUP 5;PUSH 2 (natToWord WLen 719)] [DUP 2;POP;PUSH 2 (natToWord WLen 790);DUP 3;DUP 5;PUSH 2 (natToWord WLen 719)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP DUP2 SWAP1 POP SWAP5 SWAP4 POP POP POP POP
 O: SWAP5 POP POP POP POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_799_0: equiv_checker [DUP 5;POP;POP;POP;POP;POP;DUP 1] [DUP 2;POP;DUP 2;DUP 1;POP;DUP 5;DUP 4;POP;POP;POP;POP] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP PUSH [tag] 792 PUSH 0 DUP4 ADD DUP5 PUSH [tag] 673
 O: PUSH 20 DUP2 ADD PUSH [tag] 792 DUP3 PUSH 0 ADD DUP5 PUSH [tag] 673
*)
Example BottleCastle_run_code_of_0_block_800_0: equiv_checker [PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;PUSH 2 (natToWord WLen 792);DUP 3;PUSH 1 (natToWord WLen 0);Opcode ADD;DUP 5;PUSH 2 (natToWord WLen 673)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;PUSH 2 (natToWord WLen 792);PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD;DUP 5;PUSH 2 (natToWord WLen 673)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Example BottleCastle_run_code_of_0_block_801_0: equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 80 DUP3 ADD SWAP1 POP PUSH [tag] 794 PUSH 0 DUP4 ADD DUP8 PUSH [tag] 673
 O: PUSH 80 DUP2 ADD PUSH [tag] 794 DUP3 PUSH 0 ADD DUP8 PUSH [tag] 673
*)
Example BottleCastle_run_code_of_0_block_802_0: equiv_checker [PUSH 1 (natToWord WLen 128);DUP 2;Opcode ADD;PUSH 2 (natToWord WLen 794);DUP 3;PUSH 1 (natToWord WLen 0);Opcode ADD;DUP 8;PUSH 2 (natToWord WLen 673)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 128);DUP 3;Opcode ADD;DUP 1;POP;PUSH 2 (natToWord WLen 794);PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD;DUP 8;PUSH 2 (natToWord WLen 673)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 795 PUSH 20 DUP4 ADD DUP7 PUSH [tag] 673
 O: PUSH [tag] 795 DUP3 PUSH 20 ADD DUP7 PUSH [tag] 673
*)
Example BottleCastle_run_code_of_0_block_803_0: equiv_checker [PUSH 2 (natToWord WLen 795);DUP 3;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 7;PUSH 2 (natToWord WLen 673)] [PUSH 2 (natToWord WLen 795);PUSH 1 (natToWord WLen 32);DUP 4;Opcode ADD;DUP 7;PUSH 2 (natToWord WLen 673)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 796 PUSH 40 DUP4 ADD DUP6 PUSH [tag] 784
 O: PUSH [tag] 796 PUSH 40 DUP4 ADD DUP6 PUSH [tag] 784
*)
Example BottleCastle_run_code_of_0_block_804_0: equiv_checker [PUSH 2 (natToWord WLen 796);PUSH 1 (natToWord WLen 64);DUP 4;Opcode ADD;DUP 6;PUSH 2 (natToWord WLen 784)] [PUSH 2 (natToWord WLen 796);PUSH 1 (natToWord WLen 64);DUP 4;Opcode ADD;DUP 6;PUSH 2 (natToWord WLen 784)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 DUP2 SUB PUSH 60 DUP4 ADD
 O: DUP2 DUP2 SUB PUSH 60 DUP4 ADD
*)
Example BottleCastle_run_code_of_0_block_805_0: equiv_checker [DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 96);DUP 4;Opcode ADD] [DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 96);DUP 4;Opcode ADD] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 797 DUP2 DUP5 PUSH [tag] 695
 O: PUSH [tag] 797 DUP2 DUP5 PUSH [tag] 695
*)
Example BottleCastle_run_code_of_0_block_805_1: equiv_checker [PUSH 2 (natToWord WLen 797);DUP 2;DUP 5;PUSH 2 (natToWord WLen 695)] [PUSH 2 (natToWord WLen 797);DUP 2;DUP 5;PUSH 2 (natToWord WLen 695)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP6 SWAP5 POP POP POP POP POP
 O: SWAP7 SWAP6 POP POP POP POP POP POP
*)
Example BottleCastle_run_code_of_0_block_806_0: equiv_checker [DUP 7;DUP 6;POP;POP;POP;POP;POP;POP] [DUP 1;POP;DUP 6;DUP 5;POP;POP;POP;POP;POP] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Example BottleCastle_run_code_of_0_block_807_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 799 DUP2 DUP5 PUSH [tag] 677
 O: PUSH [tag] 799 DUP2 DUP5 PUSH [tag] 677
*)
Example BottleCastle_run_code_of_0_block_807_1: equiv_checker [PUSH 2 (natToWord WLen 799);DUP 2;DUP 5;PUSH 2 (natToWord WLen 677)] [PUSH 2 (natToWord WLen 799);DUP 2;DUP 5;PUSH 2 (natToWord WLen 677)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP4 SWAP3 POP POP POP
*)
Example BottleCastle_run_code_of_0_block_808_0: equiv_checker [DUP 4;DUP 3;POP;POP;POP] [DUP 1;POP;DUP 3;DUP 2;POP;POP] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP PUSH [tag] 801 PUSH 0 DUP4 ADD DUP5 PUSH [tag] 691
 O: PUSH 20 DUP2 ADD PUSH [tag] 801 DUP3 PUSH 0 ADD DUP5 PUSH [tag] 691
*)
Example BottleCastle_run_code_of_0_block_809_0: equiv_checker [PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;PUSH 2 (natToWord WLen 801);DUP 3;PUSH 1 (natToWord WLen 0);Opcode ADD;DUP 5;PUSH 2 (natToWord WLen 691)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;PUSH 2 (natToWord WLen 801);PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD;DUP 5;PUSH 2 (natToWord WLen 691)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Example BottleCastle_run_code_of_0_block_810_0: equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Example BottleCastle_run_code_of_0_block_811_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 803 DUP2 DUP5 PUSH [tag] 705
 O: PUSH [tag] 803 DUP2 DUP5 PUSH [tag] 705
*)
Example BottleCastle_run_code_of_0_block_811_1: equiv_checker [PUSH 2 (natToWord WLen 803);DUP 2;DUP 5;PUSH 2 (natToWord WLen 705)] [PUSH 2 (natToWord WLen 803);DUP 2;DUP 5;PUSH 2 (natToWord WLen 705)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP4 SWAP3 POP POP POP
*)
Example BottleCastle_run_code_of_0_block_812_0: equiv_checker [DUP 4;DUP 3;POP;POP;POP] [DUP 1;POP;DUP 3;DUP 2;POP;POP] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Example BottleCastle_run_code_of_0_block_813_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 805 DUP2 PUSH [tag] 731
 O: PUSH [tag] 805 DUP2 PUSH [tag] 731
*)
Example BottleCastle_run_code_of_0_block_813_1: equiv_checker [PUSH 2 (natToWord WLen 805);DUP 2;PUSH 2 (natToWord WLen 731)] [PUSH 2 (natToWord WLen 805);DUP 2;PUSH 2 (natToWord WLen 731)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_814_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Example BottleCastle_run_code_of_0_block_815_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 807 DUP2 PUSH [tag] 736
 O: PUSH [tag] 807 DUP2 PUSH [tag] 736
*)
Example BottleCastle_run_code_of_0_block_815_1: equiv_checker [PUSH 2 (natToWord WLen 807);DUP 2;PUSH 2 (natToWord WLen 736)] [PUSH 2 (natToWord WLen 807);DUP 2;PUSH 2 (natToWord WLen 736)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_816_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Example BottleCastle_run_code_of_0_block_817_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 809 DUP2 PUSH [tag] 741
 O: PUSH [tag] 809 DUP2 PUSH [tag] 741
*)
Example BottleCastle_run_code_of_0_block_817_1: equiv_checker [PUSH 2 (natToWord WLen 809);DUP 2;PUSH 2 (natToWord WLen 741)] [PUSH 2 (natToWord WLen 809);DUP 2;PUSH 2 (natToWord WLen 741)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_818_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Example BottleCastle_run_code_of_0_block_819_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 811 DUP2 PUSH [tag] 746
 O: PUSH [tag] 811 DUP2 PUSH [tag] 746
*)
Example BottleCastle_run_code_of_0_block_819_1: equiv_checker [PUSH 2 (natToWord WLen 811);DUP 2;PUSH 2 (natToWord WLen 746)] [PUSH 2 (natToWord WLen 811);DUP 2;PUSH 2 (natToWord WLen 746)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_820_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Example BottleCastle_run_code_of_0_block_821_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 813 DUP2 PUSH [tag] 751
 O: PUSH [tag] 813 DUP2 PUSH [tag] 751
*)
Example BottleCastle_run_code_of_0_block_821_1: equiv_checker [PUSH 2 (natToWord WLen 813);DUP 2;PUSH 2 (natToWord WLen 751)] [PUSH 2 (natToWord WLen 813);DUP 2;PUSH 2 (natToWord WLen 751)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_822_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Example BottleCastle_run_code_of_0_block_823_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 815 DUP2 PUSH [tag] 756
 O: PUSH [tag] 815 DUP2 PUSH [tag] 756
*)
Example BottleCastle_run_code_of_0_block_823_1: equiv_checker [PUSH 2 (natToWord WLen 815);DUP 2;PUSH 2 (natToWord WLen 756)] [PUSH 2 (natToWord WLen 815);DUP 2;PUSH 2 (natToWord WLen 756)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_824_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Example BottleCastle_run_code_of_0_block_825_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 817 DUP2 PUSH [tag] 761
 O: PUSH [tag] 817 DUP2 PUSH [tag] 761
*)
Example BottleCastle_run_code_of_0_block_825_1: equiv_checker [PUSH 2 (natToWord WLen 817);DUP 2;PUSH 2 (natToWord WLen 761)] [PUSH 2 (natToWord WLen 817);DUP 2;PUSH 2 (natToWord WLen 761)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_826_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Example BottleCastle_run_code_of_0_block_827_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 819 DUP2 PUSH [tag] 766
 O: PUSH [tag] 819 DUP2 PUSH [tag] 766
*)
Example BottleCastle_run_code_of_0_block_827_1: equiv_checker [PUSH 2 (natToWord WLen 819);DUP 2;PUSH 2 (natToWord WLen 766)] [PUSH 2 (natToWord WLen 819);DUP 2;PUSH 2 (natToWord WLen 766)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_828_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Example BottleCastle_run_code_of_0_block_829_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 821 DUP2 PUSH [tag] 771
 O: PUSH [tag] 821 DUP2 PUSH [tag] 771
*)
Example BottleCastle_run_code_of_0_block_829_1: equiv_checker [PUSH 2 (natToWord WLen 821);DUP 2;PUSH 2 (natToWord WLen 771)] [PUSH 2 (natToWord WLen 821);DUP 2;PUSH 2 (natToWord WLen 771)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_830_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Example BottleCastle_run_code_of_0_block_831_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 823 DUP2 PUSH [tag] 776
 O: PUSH [tag] 823 DUP2 PUSH [tag] 776
*)
Example BottleCastle_run_code_of_0_block_831_1: equiv_checker [PUSH 2 (natToWord WLen 823);DUP 2;PUSH 2 (natToWord WLen 776)] [PUSH 2 (natToWord WLen 823);DUP 2;PUSH 2 (natToWord WLen 776)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_832_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP PUSH [tag] 825 PUSH 0 DUP4 ADD DUP5 PUSH [tag] 784
 O: PUSH 20 DUP2 ADD PUSH [tag] 825 DUP3 PUSH 0 ADD DUP5 PUSH [tag] 784
*)
Example BottleCastle_run_code_of_0_block_833_0: equiv_checker [PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;PUSH 2 (natToWord WLen 825);DUP 3;PUSH 1 (natToWord WLen 0);Opcode ADD;DUP 5;PUSH 2 (natToWord WLen 784)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;PUSH 2 (natToWord WLen 825);PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD;DUP 5;PUSH 2 (natToWord WLen 784)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Example BottleCastle_run_code_of_0_block_834_0: equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 827 PUSH [tag] 828
 O: PUSH 0 PUSH [tag] 827 PUSH [tag] 828
*)
Example BottleCastle_run_code_of_0_block_835_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 827);PUSH 2 (natToWord WLen 828)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 827);PUSH 2 (natToWord WLen 828)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP PUSH [tag] 829 DUP3 DUP3 PUSH [tag] 830
 O: SWAP1 POP PUSH [tag] 829 DUP3 DUP3 PUSH [tag] 830
*)
Example BottleCastle_run_code_of_0_block_836_0: equiv_checker [DUP 1;POP;PUSH 2 (natToWord WLen 829);DUP 3;DUP 3;PUSH 2 (natToWord WLen 830)] [DUP 1;POP;PUSH 2 (natToWord WLen 829);DUP 3;DUP 3;PUSH 2 (natToWord WLen 830)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_837_0: equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 40 MLOAD SWAP1 POP SWAP1
 O: PUSH 40 MLOAD SWAP1
*)
Example BottleCastle_run_code_of_0_block_838_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;POP;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFF DUP3 GT ISZERO PUSH [tag] 833
 O: PUSH 0 PUSH ffffffffffffffff DUP3 GT ISZERO PUSH [tag] 833
*)
Example BottleCastle_run_code_of_0_block_839_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 8 (natToWord WLen 18446744073709551615);DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 833)] [PUSH 1 (natToWord WLen 0);PUSH 8 (natToWord WLen 18446744073709551615);DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 833)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 834 PUSH [tag] 312
 O: PUSH [tag] 834 PUSH [tag] 312
*)
Example BottleCastle_run_code_of_0_block_840_0: equiv_checker [PUSH 2 (natToWord WLen 834);PUSH 2 (natToWord WLen 312)] [PUSH 2 (natToWord WLen 834);PUSH 2 (natToWord WLen 312)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 835 DUP3 PUSH [tag] 704
 O: PUSH [tag] 835 DUP3 PUSH [tag] 704
*)
Example BottleCastle_run_code_of_0_block_842_0: equiv_checker [PUSH 2 (natToWord WLen 835);DUP 3;PUSH 2 (natToWord WLen 704)] [PUSH 2 (natToWord WLen 835);DUP 3;PUSH 2 (natToWord WLen 704)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP PUSH 20 DUP2 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_843_0: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;POP;POP;DUP 1] [DUP 1;POP;PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFF DUP3 GT ISZERO PUSH [tag] 837
 O: PUSH 0 PUSH ffffffffffffffff DUP3 GT ISZERO PUSH [tag] 837
*)
Example BottleCastle_run_code_of_0_block_844_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 8 (natToWord WLen 18446744073709551615);DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 837)] [PUSH 1 (natToWord WLen 0);PUSH 8 (natToWord WLen 18446744073709551615);DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 837)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 838 PUSH [tag] 312
 O: PUSH [tag] 838 PUSH [tag] 312
*)
Example BottleCastle_run_code_of_0_block_845_0: equiv_checker [PUSH 2 (natToWord WLen 838);PUSH 2 (natToWord WLen 312)] [PUSH 2 (natToWord WLen 838);PUSH 2 (natToWord WLen 312)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 839 DUP3 PUSH [tag] 704
 O: PUSH [tag] 839 DUP3 PUSH [tag] 704
*)
Example BottleCastle_run_code_of_0_block_847_0: equiv_checker [PUSH 2 (natToWord WLen 839);DUP 3;PUSH 2 (natToWord WLen 704)] [PUSH 2 (natToWord WLen 839);DUP 3;PUSH 2 (natToWord WLen 704)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP PUSH 20 DUP2 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_848_0: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;POP;POP;DUP 1] [DUP 1;POP;PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 SWAP1 POP PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_849_0: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 0);DUP 2;DUP 1;POP;PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 SWAP1 POP DUP2 PUSH 0
 O: DUP1 DUP2 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_850_0: equiv_checker [DUP 1;DUP 2;PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 0);DUP 2;DUP 1;POP;DUP 2;PUSH 1 (natToWord WLen 0)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1 POP SWAP2 SWAP1 POP
 O: POP POP PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Example BottleCastle_run_code_of_0_block_850_1: equiv_checker [POP;POP;PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP SWAP2 SWAP1 POP
 O: MLOAD SWAP1
*)
Example BottleCastle_run_code_of_0_block_851_0: equiv_checker [Opcode MLOAD;DUP 1] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode MLOAD;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP SWAP2 SWAP1 POP
 O: MLOAD SWAP1
*)
Example BottleCastle_run_code_of_0_block_852_0: equiv_checker [Opcode MLOAD;DUP 1] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode MLOAD;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP SWAP2 SWAP1 POP
 O: MLOAD SWAP1
*)
Example BottleCastle_run_code_of_0_block_853_0: equiv_checker [Opcode MLOAD;DUP 1] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode MLOAD;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_854_0: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP3 DUP3
 O: PUSH 0 DUP3 DUP3
*)
Example BottleCastle_run_code_of_0_block_855_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 3;DUP 3] [PUSH 1 (natToWord WLen 0);DUP 3;DUP 3] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP PUSH 20 SWAP2 POP ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_855_1: equiv_checker [POP;PUSH 1 (natToWord WLen 32);DUP 2;POP;Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP3 DUP3
 O: PUSH 0 DUP3 DUP3
*)
Example BottleCastle_run_code_of_0_block_856_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 3;DUP 3] [PUSH 1 (natToWord WLen 0);DUP 3;DUP 3] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP PUSH 20 SWAP2 POP ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_856_1: equiv_checker [POP;PUSH 1 (natToWord WLen 32);DUP 2;POP;Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP3 DUP3
 O: PUSH 0 DUP3 DUP3
*)
Example BottleCastle_run_code_of_0_block_857_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 3;DUP 3] [PUSH 1 (natToWord WLen 0);DUP 3;DUP 3] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP PUSH 20 SWAP2 POP ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_857_1: equiv_checker [POP;PUSH 1 (natToWord WLen 32);DUP 2;POP;Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP2 SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_858_0: equiv_checker [DUP 2;DUP 1;POP] [PUSH 1 (natToWord WLen 0);DUP 2;DUP 1;POP;DUP 3;DUP 2;POP;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 851 DUP3 PUSH [tag] 783
 O: PUSH 0 PUSH [tag] 851 DUP3 PUSH [tag] 783
*)
Example BottleCastle_run_code_of_0_block_859_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 851);DUP 3;PUSH 2 (natToWord WLen 783)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 851);DUP 3;PUSH 2 (natToWord WLen 783)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 852 DUP4 PUSH [tag] 783
 O: SWAP2 POP PUSH [tag] 852 DUP4 PUSH [tag] 783
*)
Example BottleCastle_run_code_of_0_block_860_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 852);DUP 4;PUSH 2 (natToWord WLen 783)] [DUP 2;POP;PUSH 2 (natToWord WLen 852);DUP 4;PUSH 2 (natToWord WLen 783)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF SUB DUP3 GT ISZERO PUSH [tag] 853
 O: DUP1 SWAP4 POP PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff SUB DUP3 GT ISZERO PUSH [tag] 853
*)
Example BottleCastle_run_code_of_0_block_861_0: equiv_checker [DUP 1;DUP 4;POP;PUSH 32 (natToWord WLen 115792089237316195423570985008687907853269984665640564039457584007913129639935);Opcode SUB;DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 853)] [DUP 3;POP;DUP 3;PUSH 32 (natToWord WLen 115792089237316195423570985008687907853269984665640564039457584007913129639935);Opcode SUB;DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 853)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 854 PUSH [tag] 855
 O: PUSH [tag] 854 PUSH [tag] 855
*)
Example BottleCastle_run_code_of_0_block_862_0: equiv_checker [PUSH 2 (natToWord WLen 854);PUSH 2 (natToWord WLen 855)] [PUSH 2 (natToWord WLen 854);PUSH 2 (natToWord WLen 855)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_864_0: equiv_checker [POP;Opcode ADD;DUP 1] [DUP 3;DUP 3;Opcode ADD;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 857 DUP3 PUSH [tag] 783
 O: PUSH 0 PUSH [tag] 857 DUP3 PUSH [tag] 783
*)
Example BottleCastle_run_code_of_0_block_865_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 857);DUP 3;PUSH 2 (natToWord WLen 783)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 857);DUP 3;PUSH 2 (natToWord WLen 783)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 858 DUP4 PUSH [tag] 783
 O: SWAP2 POP PUSH [tag] 858 DUP4 PUSH [tag] 783
*)
Example BottleCastle_run_code_of_0_block_866_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 858);DUP 4;PUSH 2 (natToWord WLen 783)] [DUP 2;POP;PUSH 2 (natToWord WLen 858);DUP 4;PUSH 2 (natToWord WLen 783)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP DUP3 PUSH [tag] 859
 O: SWAP3 POP DUP3 PUSH [tag] 859
*)
Example BottleCastle_run_code_of_0_block_867_0: equiv_checker [DUP 3;POP;DUP 3;PUSH 2 (natToWord WLen 859)] [DUP 3;POP;DUP 3;PUSH 2 (natToWord WLen 859)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 860 PUSH [tag] 861
 O: PUSH [tag] 860 PUSH [tag] 861
*)
Example BottleCastle_run_code_of_0_block_868_0: equiv_checker [PUSH 2 (natToWord WLen 860);PUSH 2 (natToWord WLen 861)] [PUSH 2 (natToWord WLen 860);PUSH 2 (natToWord WLen 861)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 DUP3 DIV SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP DIV SWAP1
*)
Example BottleCastle_run_code_of_0_block_870_0: equiv_checker [POP;Opcode DIV;DUP 1] [DUP 3;DUP 3;Opcode DIV;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 863 DUP3 PUSH [tag] 783
 O: PUSH 0 PUSH [tag] 863 DUP3 PUSH [tag] 783
*)
Example BottleCastle_run_code_of_0_block_871_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 863);DUP 3;PUSH 2 (natToWord WLen 783)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 863);DUP 3;PUSH 2 (natToWord WLen 783)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 864 DUP4 PUSH [tag] 783
 O: SWAP2 POP PUSH [tag] 864 DUP4 PUSH [tag] 783
*)
Example BottleCastle_run_code_of_0_block_872_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 864);DUP 4;PUSH 2 (natToWord WLen 783)] [DUP 2;POP;PUSH 2 (natToWord WLen 864);DUP 4;PUSH 2 (natToWord WLen 783)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DIV DUP4 GT DUP3 ISZERO ISZERO AND ISZERO PUSH [tag] 865
 O: SWAP3 POP DUP2 ISZERO ISZERO DUP3 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff DIV DUP5 GT AND ISZERO PUSH [tag] 865
*)
Example BottleCastle_run_code_of_0_block_873_0: equiv_checker [DUP 3;POP;DUP 2;Opcode ISZERO;Opcode ISZERO;DUP 3;PUSH 32 (natToWord WLen 115792089237316195423570985008687907853269984665640564039457584007913129639935);Opcode DIV;DUP 5;Opcode GT;Opcode AND;Opcode ISZERO;PUSH 2 (natToWord WLen 865)] [DUP 3;POP;DUP 2;PUSH 32 (natToWord WLen 115792089237316195423570985008687907853269984665640564039457584007913129639935);Opcode DIV;DUP 4;Opcode GT;DUP 3;Opcode ISZERO;Opcode ISZERO;Opcode AND;Opcode ISZERO;PUSH 2 (natToWord WLen 865)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 866 PUSH [tag] 855
 O: PUSH [tag] 866 PUSH [tag] 855
*)
Example BottleCastle_run_code_of_0_block_874_0: equiv_checker [PUSH 2 (natToWord WLen 866);PUSH 2 (natToWord WLen 855)] [PUSH 2 (natToWord WLen 866);PUSH 2 (natToWord WLen 855)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 DUP3 MUL SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP MUL SWAP1
*)
Example BottleCastle_run_code_of_0_block_876_0: equiv_checker [POP;Opcode MUL;DUP 1] [DUP 3;DUP 3;Opcode MUL;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 868 DUP3 PUSH [tag] 783
 O: PUSH 0 PUSH [tag] 868 DUP3 PUSH [tag] 783
*)
Example BottleCastle_run_code_of_0_block_877_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 868);DUP 3;PUSH 2 (natToWord WLen 783)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 868);DUP 3;PUSH 2 (natToWord WLen 783)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 869 DUP4 PUSH [tag] 783
 O: SWAP2 POP PUSH [tag] 869 DUP4 PUSH [tag] 783
*)
Example BottleCastle_run_code_of_0_block_878_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 869);DUP 4;PUSH 2 (natToWord WLen 783)] [DUP 2;POP;PUSH 2 (natToWord WLen 869);DUP 4;PUSH 2 (natToWord WLen 783)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP DUP3 DUP3 LT ISZERO PUSH [tag] 870
 O: DUP1 SWAP4 POP DUP3 LT ISZERO PUSH [tag] 870
*)
Example BottleCastle_run_code_of_0_block_879_0: equiv_checker [DUP 1;DUP 4;POP;DUP 3;Opcode LT;Opcode ISZERO;PUSH 2 (natToWord WLen 870)] [DUP 3;POP;DUP 3;DUP 3;Opcode LT;Opcode ISZERO;PUSH 2 (natToWord WLen 870)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 871 PUSH [tag] 855
 O: PUSH [tag] 871 PUSH [tag] 855
*)
Example BottleCastle_run_code_of_0_block_880_0: equiv_checker [PUSH 2 (natToWord WLen 871);PUSH 2 (natToWord WLen 855)] [PUSH 2 (natToWord WLen 871);PUSH 2 (natToWord WLen 855)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 DUP3 SUB SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP SUB SWAP1
*)
Example BottleCastle_run_code_of_0_block_882_0: equiv_checker [POP;Opcode SUB;DUP 1] [DUP 3;DUP 3;Opcode SUB;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 873 DUP3 PUSH [tag] 874
 O: PUSH 0 PUSH [tag] 873 DUP3 PUSH [tag] 874
*)
Example BottleCastle_run_code_of_0_block_883_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 873);DUP 3;PUSH 2 (natToWord WLen 874)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 873);DUP 3;PUSH 2 (natToWord WLen 874)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example BottleCastle_run_code_of_0_block_884_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 ISZERO ISZERO SWAP1 POP SWAP2 SWAP1 POP
 O: ISZERO ISZERO SWAP1
*)
Example BottleCastle_run_code_of_0_block_885_0: equiv_checker [Opcode ISZERO;Opcode ISZERO;DUP 1] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode ISZERO;Opcode ISZERO;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH FFFFFFFF00000000000000000000000000000000000000000000000000000000 DUP3 AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH ffffffff00000000000000000000000000000000000000000000000000000000 AND SWAP1
*)
Example BottleCastle_run_code_of_0_block_886_0: equiv_checker [PUSH 32 (natToWord WLen 115792089210356248756420345214020892766250353992003419616917011526809519390720);Opcode AND;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 32 (natToWord WLen 115792089210356248756420345214020892766250353992003419616917011526809519390720);DUP 3;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP3 AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND SWAP1
*)
Example BottleCastle_run_code_of_0_block_887_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 3;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP1
*)
Example BottleCastle_run_code_of_0_block_888_0: equiv_checker [DUP 1] [PUSH 1 (natToWord WLen 0);DUP 2;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 DUP2 DUP4
 O: DUP3 DUP2 DUP4
*)
Example BottleCastle_run_code_of_0_block_889_0: equiv_checker [DUP 3;DUP 2;DUP 4] [DUP 3;DUP 2;DUP 4] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP4 DUP4 ADD
 O: PUSH 0 DUP3 DUP5 ADD
*)
Example BottleCastle_run_code_of_0_block_889_1: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 3;DUP 5;Opcode ADD] [PUSH 1 (natToWord WLen 0);DUP 4;DUP 4;Opcode ADD] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP
 O: POP POP POP
*)
Example BottleCastle_run_code_of_0_block_889_2: equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0
 O: PUSH 0
*)
Example BottleCastle_run_code_of_0_block_890_0: equiv_checker [PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP4 DUP2 LT ISZERO PUSH [tag] 884
 O: DUP4 DUP2 LT ISZERO PUSH [tag] 884
*)
Example BottleCastle_run_code_of_0_block_891_0: equiv_checker [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (natToWord WLen 884)] [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (natToWord WLen 884)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD
 O: DUP2 DUP2 ADD MLOAD DUP4 DUP3 ADD
*)
Example BottleCastle_run_code_of_0_block_892_0: equiv_checker [DUP 2;DUP 2;Opcode ADD;Opcode MLOAD;DUP 4;DUP 3;Opcode ADD] [DUP 1;DUP 3;Opcode ADD;Opcode MLOAD;DUP 2;DUP 5;Opcode ADD] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP2 ADD SWAP1 POP PUSH [tag] 882
 O: PUSH 20 ADD PUSH [tag] 882
*)
Example BottleCastle_run_code_of_0_block_892_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 2 (natToWord WLen 882)] [PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;DUP 1;POP;PUSH 2 (natToWord WLen 882)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP4 DUP2 GT ISZERO PUSH [tag] 885
 O: DUP4 DUP2 GT ISZERO PUSH [tag] 885
*)
Example BottleCastle_run_code_of_0_block_893_0: equiv_checker [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 885)] [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 885)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP5 DUP5 ADD
 O: PUSH 0 DUP4 DUP6 ADD
*)
Example BottleCastle_run_code_of_0_block_894_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 4;DUP 6;Opcode ADD] [PUSH 1 (natToWord WLen 0);DUP 5;DUP 5;Opcode ADD] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Example BottleCastle_run_code_of_0_block_895_0: equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 2 DUP3 DIV SWAP1 POP PUSH 1 DUP3 AND DUP1 PUSH [tag] 887
 O: PUSH 2 DUP2 DIV DUP2 PUSH 1 AND DUP1 PUSH [tag] 887
*)
Example BottleCastle_run_code_of_0_block_896_0: equiv_checker [PUSH 1 (natToWord WLen 2);DUP 2;Opcode DIV;DUP 2;PUSH 1 (natToWord WLen 1);Opcode AND;DUP 1;PUSH 2 (natToWord WLen 887)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 2);DUP 3;Opcode DIV;DUP 1;POP;PUSH 1 (natToWord WLen 1);DUP 3;Opcode AND;DUP 1;PUSH 2 (natToWord WLen 887)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 7F DUP3 AND SWAP2 POP
 O: SWAP1 PUSH 7f AND SWAP1
*)
Example BottleCastle_run_code_of_0_block_897_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 127);Opcode AND;DUP 1] [PUSH 1 (natToWord WLen 127);DUP 3;Opcode AND;DUP 2;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 LT DUP2 EQ ISZERO PUSH [tag] 888
 O: DUP1 PUSH 20 DUP4 LT EQ ISZERO PUSH [tag] 888
*)
Example BottleCastle_run_code_of_0_block_898_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);DUP 4;Opcode LT;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 888)] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode LT;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 888)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 889 PUSH [tag] 890
 O: PUSH [tag] 889 PUSH [tag] 890
*)
Example BottleCastle_run_code_of_0_block_899_0: equiv_checker [PUSH 2 (natToWord WLen 889);PUSH 2 (natToWord WLen 890)] [PUSH 2 (natToWord WLen 889);PUSH 2 (natToWord WLen 890)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP2 SWAP1 POP
 O: POP SWAP2 SWAP1 POP
*)
Example BottleCastle_run_code_of_0_block_901_0: equiv_checker [POP;DUP 2;DUP 1;POP] [POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 892 DUP3 PUSH [tag] 704
 O: PUSH [tag] 892 DUP3 PUSH [tag] 704
*)
Example BottleCastle_run_code_of_0_block_902_0: equiv_checker [PUSH 2 (natToWord WLen 892);DUP 3;PUSH 2 (natToWord WLen 704)] [PUSH 2 (natToWord WLen 892);DUP 3;PUSH 2 (natToWord WLen 704)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 ADD DUP2 DUP2 LT PUSH FFFFFFFFFFFFFFFF DUP3 GT OR ISZERO PUSH [tag] 893
 O: DUP2 ADD PUSH ffffffffffffffff DUP2 GT DUP3 DUP3 LT OR ISZERO PUSH [tag] 893
*)
Example BottleCastle_run_code_of_0_block_903_0: equiv_checker [DUP 2;Opcode ADD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;DUP 3;DUP 3;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 2 (natToWord WLen 893)] [DUP 2;Opcode ADD;DUP 2;DUP 2;Opcode LT;PUSH 8 (natToWord WLen 18446744073709551615);DUP 3;Opcode GT;Opcode OR;Opcode ISZERO;PUSH 2 (natToWord WLen 893)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 894 PUSH [tag] 312
 O: PUSH [tag] 894 PUSH [tag] 312
*)
Example BottleCastle_run_code_of_0_block_904_0: equiv_checker [PUSH 2 (natToWord WLen 894);PUSH 2 (natToWord WLen 312)] [PUSH 2 (natToWord WLen 894);PUSH 2 (natToWord WLen 312)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 40
 O: DUP1 PUSH 40
*)
Example BottleCastle_run_code_of_0_block_906_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 64)] [DUP 1;PUSH 1 (natToWord WLen 64)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP
 O: POP POP POP
*)
Example BottleCastle_run_code_of_0_block_906_1: equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 896 DUP3 PUSH [tag] 783
 O: PUSH 0 PUSH [tag] 896 DUP3 PUSH [tag] 783
*)
Example BottleCastle_run_code_of_0_block_907_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 896);DUP 3;PUSH 2 (natToWord WLen 783)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 896);DUP 3;PUSH 2 (natToWord WLen 783)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP3 EQ ISZERO PUSH [tag] 897
 O: SWAP2 POP PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff DUP3 EQ ISZERO PUSH [tag] 897
*)
Example BottleCastle_run_code_of_0_block_908_0: equiv_checker [DUP 2;POP;PUSH 32 (natToWord WLen 115792089237316195423570985008687907853269984665640564039457584007913129639935);DUP 3;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 897)] [DUP 2;POP;PUSH 32 (natToWord WLen 115792089237316195423570985008687907853269984665640564039457584007913129639935);DUP 3;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 897)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 898 PUSH [tag] 855
 O: PUSH [tag] 898 PUSH [tag] 855
*)
Example BottleCastle_run_code_of_0_block_909_0: equiv_checker [PUSH 2 (natToWord WLen 898);PUSH 2 (natToWord WLen 855)] [PUSH 2 (natToWord WLen 898);PUSH 2 (natToWord WLen 855)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 1 DUP3 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: POP PUSH 1 ADD SWAP1
*)
Example BottleCastle_run_code_of_0_block_911_0: equiv_checker [POP;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 1);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 900 DUP3 PUSH [tag] 783
 O: PUSH 0 PUSH [tag] 900 DUP3 PUSH [tag] 783
*)
Example BottleCastle_run_code_of_0_block_912_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 900);DUP 3;PUSH 2 (natToWord WLen 783)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 900);DUP 3;PUSH 2 (natToWord WLen 783)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 901 DUP4 PUSH [tag] 783
 O: SWAP2 POP PUSH [tag] 901 DUP4 PUSH [tag] 783
*)
Example BottleCastle_run_code_of_0_block_913_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 901);DUP 4;PUSH 2 (natToWord WLen 783)] [DUP 2;POP;PUSH 2 (natToWord WLen 901);DUP 4;PUSH 2 (natToWord WLen 783)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP DUP3 PUSH [tag] 902
 O: SWAP3 POP DUP3 PUSH [tag] 902
*)
Example BottleCastle_run_code_of_0_block_914_0: equiv_checker [DUP 3;POP;DUP 3;PUSH 2 (natToWord WLen 902)] [DUP 3;POP;DUP 3;PUSH 2 (natToWord WLen 902)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 903 PUSH [tag] 861
 O: PUSH [tag] 903 PUSH [tag] 861
*)
Example BottleCastle_run_code_of_0_block_915_0: equiv_checker [PUSH 2 (natToWord WLen 903);PUSH 2 (natToWord WLen 861)] [PUSH 2 (natToWord WLen 903);PUSH 2 (natToWord WLen 861)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 DUP3 MOD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP MOD SWAP1
*)
Example BottleCastle_run_code_of_0_block_917_0: equiv_checker [POP;Opcode MOD;DUP 1] [DUP 3;DUP 3;Opcode MOD;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_918_0: equiv_checker [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 11 PUSH 4
 O: PUSH 11 PUSH 4
*)
Example BottleCastle_run_code_of_0_block_918_1: equiv_checker [PUSH 1 (natToWord WLen 17);PUSH 1 (natToWord WLen 4)] [PUSH 1 (natToWord WLen 17);PUSH 1 (natToWord WLen 4)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_918_2: equiv_checker [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_919_0: equiv_checker [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 12 PUSH 4
 O: PUSH 12 PUSH 4
*)
Example BottleCastle_run_code_of_0_block_919_1: equiv_checker [PUSH 1 (natToWord WLen 18);PUSH 1 (natToWord WLen 4)] [PUSH 1 (natToWord WLen 18);PUSH 1 (natToWord WLen 4)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_919_2: equiv_checker [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_920_0: equiv_checker [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 22 PUSH 4
 O: PUSH 22 PUSH 4
*)
Example BottleCastle_run_code_of_0_block_920_1: equiv_checker [PUSH 1 (natToWord WLen 34);PUSH 1 (natToWord WLen 4)] [PUSH 1 (natToWord WLen 34);PUSH 1 (natToWord WLen 4)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_920_2: equiv_checker [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_921_0: equiv_checker [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 32 PUSH 4
 O: PUSH 32 PUSH 4
*)
Example BottleCastle_run_code_of_0_block_921_1: equiv_checker [PUSH 1 (natToWord WLen 50);PUSH 1 (natToWord WLen 4)] [PUSH 1 (natToWord WLen 50);PUSH 1 (natToWord WLen 4)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_921_2: equiv_checker [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_922_0: equiv_checker [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 41 PUSH 4
 O: PUSH 41 PUSH 4
*)
Example BottleCastle_run_code_of_0_block_922_1: equiv_checker [PUSH 1 (natToWord WLen 65);PUSH 1 (natToWord WLen 4)] [PUSH 1 (natToWord WLen 65);PUSH 1 (natToWord WLen 4)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Example BottleCastle_run_code_of_0_block_922_2: equiv_checker [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_923_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_924_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_925_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_926_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 1F NOT PUSH 1F DUP4 ADD AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 1f ADD PUSH 1f NOT AND SWAP1
*)
Example BottleCastle_run_code_of_0_block_927_0: equiv_checker [PUSH 1 (natToWord WLen 31);Opcode ADD;PUSH 1 (natToWord WLen 31);Opcode NOT;Opcode AND;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 31);Opcode NOT;PUSH 1 (natToWord WLen 31);DUP 4;Opcode ADD;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 455243373231414D657461646174613A2055524920717565727920666F72206E PUSH 0 DUP3 ADD
 O: PUSH 455243373231414d657461646174613a2055524920717565727920666f72206e DUP2 PUSH 0 ADD
*)
Example BottleCastle_run_code_of_0_block_928_0: equiv_checker [PUSH 32 (natToWord WLen 31354931916645386924896558676992806612506943854923838136031278789049778839662);DUP 2;PUSH 1 (natToWord WLen 0);Opcode ADD] [PUSH 32 (natToWord WLen 31354931916645386924896558676992806612506943854923838136031278789049778839662);PUSH 1 (natToWord WLen 0);DUP 3;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 6F6E6578697374656E7420746F6B656E00000000000000000000000000000000 PUSH 20 DUP3 ADD
 O: PUSH 6f6e6578697374656e7420746f6b656e00000000000000000000000000000000 DUP2 PUSH 20 ADD
*)
Example BottleCastle_run_code_of_0_block_928_1: equiv_checker [PUSH 32 (natToWord WLen 50401779692548103213442664257883400311367408232975005282272858246758407340032);DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD] [PUSH 32 (natToWord WLen 50401779692548103213442664257883400311367408232975005282272858246758407340032);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_928_2: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4F776E61626C653A206E6577206F776E657220697320746865207A65726F2061 PUSH 0 DUP3 ADD
 O: PUSH 4f776e61626c653a206e6577206f776e657220697320746865207a65726f2061 DUP2 PUSH 0 ADD
*)
Example BottleCastle_run_code_of_0_block_929_0: equiv_checker [PUSH 32 (natToWord WLen 35943731656364841964517558219894961445653631979235167635064085396828900499553);DUP 2;PUSH 1 (natToWord WLen 0);Opcode ADD] [PUSH 32 (natToWord WLen 35943731656364841964517558219894961445653631979235167635064085396828900499553);PUSH 1 (natToWord WLen 0);DUP 3;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 6464726573730000000000000000000000000000000000000000000000000000 PUSH 20 DUP3 ADD
 O: PUSH 6464726573730000000000000000000000000000000000000000000000000000 DUP2 PUSH 20 ADD
*)
Example BottleCastle_run_code_of_0_block_929_1: equiv_checker [PUSH 32 (natToWord WLen 45408759099000846574684193736602357774271237157169010951590501707763511459840);DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD] [PUSH 32 (natToWord WLen 45408759099000846574684193736602357774271237157169010951590501707763511459840);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_929_2: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 576520536F6C646F757400000000000000000000000000000000000000000000 PUSH 0 DUP3 ADD
 O: PUSH 576520536f6c646f757400000000000000000000000000000000000000000000 DUP2 PUSH 0 ADD
*)
Example BottleCastle_run_code_of_0_block_930_0: equiv_checker [PUSH 32 (natToWord WLen 39529892485579717669011596912399586901920371766283651872101382789588420919296);DUP 2;PUSH 1 (natToWord WLen 0);Opcode ADD] [PUSH 32 (natToWord WLen 39529892485579717669011596912399586901920371766283651872101382789588420919296);PUSH 1 (natToWord WLen 0);DUP 3;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_930_1: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 6F6F707320636F6E747261637420697320706175736564000000000000000000 PUSH 0 DUP3 ADD
 O: PUSH 6f6f707320636f6e747261637420697320706175736564000000000000000000 DUP2 PUSH 0 ADD
*)
Example BottleCastle_run_code_of_0_block_931_0: equiv_checker [PUSH 32 (natToWord WLen 50403622316328575670137397539324773303190751046066217595949089467472736681984);DUP 2;PUSH 1 (natToWord WLen 0);Opcode ADD] [PUSH 32 (natToWord WLen 50403622316328575670137397539324773303190751046066217595949089467472736681984);PUSH 1 (natToWord WLen 0);DUP 3;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_931_1: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 6D6178204E4654206C696D697420657863656564656400000000000000000000 PUSH 0 DUP3 ADD
 O: PUSH 6d6178204e4654206c696d697420657863656564656400000000000000000000 DUP2 PUSH 0 ADD
*)
Example BottleCastle_run_code_of_0_block_932_0: equiv_checker [PUSH 32 (natToWord WLen 49474313741382738095358684106548179213654755676276413182203196675589647892480);DUP 2;PUSH 1 (natToWord WLen 0);Opcode ADD] [PUSH 32 (natToWord WLen 49474313741382738095358684106548179213654755676276413182203196675589647892480);PUSH 1 (natToWord WLen 0);DUP 3;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_932_1: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4F776E61626C653A2063616C6C6572206973206E6F7420746865206F776E6572 PUSH 0 DUP3 ADD
 O: PUSH 4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572 DUP2 PUSH 0 ADD
*)
Example BottleCastle_run_code_of_0_block_933_0: equiv_checker [PUSH 32 (natToWord WLen 35943731656364841964516503116990081338611484598491072354577564874054038349170);DUP 2;PUSH 1 (natToWord WLen 0);Opcode ADD] [PUSH 32 (natToWord WLen 35943731656364841964516503116990081338611484598491072354577564874054038349170);PUSH 1 (natToWord WLen 0);DUP 3;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_933_1: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 696E73756666696369656E742066756E64730000000000000000000000000000 PUSH 0 DUP3 ADD
 O: PUSH 696e73756666696369656e742066756e64730000000000000000000000000000 DUP2 PUSH 0 ADD
*)
Example BottleCastle_run_code_of_0_block_934_0: equiv_checker [PUSH 32 (natToWord WLen 47687999144296217495830161024900894829510028801706196848888371826316466454528);DUP 2;PUSH 1 (natToWord WLen 0);Opcode ADD] [PUSH 32 (natToWord WLen 47687999144296217495830161024900894829510028801706196848888371826316466454528);PUSH 1 (natToWord WLen 0);DUP 3;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_934_1: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4D6178204E4654205065722057616C6C65742065786365656465640000000000 PUSH 0 DUP3 ADD
 O: PUSH 4d6178204e4654205065722057616c6c65742065786365656465640000000000 DUP2 PUSH 0 ADD
*)
Example BottleCastle_run_code_of_0_block_935_0: equiv_checker [PUSH 32 (natToWord WLen 35000302586718213666725371618137421731426062014614006138105282342098927878144);DUP 2;PUSH 1 (natToWord WLen 0);Opcode ADD] [PUSH 32 (natToWord WLen 35000302586718213666725371618137421731426062014614006138105282342098927878144);PUSH 1 (natToWord WLen 0);DUP 3;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_935_1: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 5265656E7472616E637947756172643A207265656E7472616E742063616C6C00 PUSH 0 DUP3 ADD
 O: PUSH 5265656e7472616e637947756172643a207265656e7472616e742063616c6c00 DUP2 PUSH 0 ADD
*)
Example BottleCastle_run_code_of_0_block_936_0: equiv_checker [PUSH 32 (natToWord WLen 37268805191608899176760263720700790282416321829889089033725955971341467020288);DUP 2;PUSH 1 (natToWord WLen 0);Opcode ADD] [PUSH 32 (natToWord WLen 37268805191608899176760263720700790282416321829889089033725955971341467020288);PUSH 1 (natToWord WLen 0);DUP 3;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_936_1: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 6D6178206D696E7420616D6F756E742070657220747820657863656564656400 PUSH 0 DUP3 ADD
 O: PUSH 6d6178206d696e7420616d6f756e742070657220747820657863656564656400 DUP2 PUSH 0 ADD
*)
Example BottleCastle_run_code_of_0_block_937_0: equiv_checker [PUSH 32 (natToWord WLen 49474313744661859607761933136593948058862146803170230636731028255824771638272);DUP 2;PUSH 1 (natToWord WLen 0);Opcode ADD] [PUSH 32 (natToWord WLen 49474313744661859607761933136593948058862146803170230636731028255824771638272);PUSH 1 (natToWord WLen 0);DUP 3;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_937_1: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 925 DUP2 PUSH [tag] 676
 O: PUSH [tag] 925 DUP2 PUSH [tag] 676
*)
Example BottleCastle_run_code_of_0_block_938_0: equiv_checker [PUSH 2 (natToWord WLen 925);DUP 2;PUSH 2 (natToWord WLen 676)] [PUSH 2 (natToWord WLen 925);DUP 2;PUSH 2 (natToWord WLen 676)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 EQ PUSH [tag] 926
 O: DUP2 EQ PUSH [tag] 926
*)
Example BottleCastle_run_code_of_0_block_939_0: equiv_checker [DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 926)] [DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 926)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_940_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_941_0: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 928 DUP2 PUSH [tag] 694
 O: PUSH [tag] 928 DUP2 PUSH [tag] 694
*)
Example BottleCastle_run_code_of_0_block_942_0: equiv_checker [PUSH 2 (natToWord WLen 928);DUP 2;PUSH 2 (natToWord WLen 694)] [PUSH 2 (natToWord WLen 928);DUP 2;PUSH 2 (natToWord WLen 694)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 EQ PUSH [tag] 929
 O: DUP2 EQ PUSH [tag] 929
*)
Example BottleCastle_run_code_of_0_block_943_0: equiv_checker [DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 929)] [DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 929)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_944_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_945_0: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 931 DUP2 PUSH [tag] 876
 O: PUSH [tag] 931 DUP2 PUSH [tag] 876
*)
Example BottleCastle_run_code_of_0_block_946_0: equiv_checker [PUSH 2 (natToWord WLen 931);DUP 2;PUSH 2 (natToWord WLen 876)] [PUSH 2 (natToWord WLen 931);DUP 2;PUSH 2 (natToWord WLen 876)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 EQ PUSH [tag] 932
 O: DUP2 EQ PUSH [tag] 932
*)
Example BottleCastle_run_code_of_0_block_947_0: equiv_checker [DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 932)] [DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 932)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_948_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_949_0: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 934 DUP2 PUSH [tag] 783
 O: PUSH [tag] 934 DUP2 PUSH [tag] 783
*)
Example BottleCastle_run_code_of_0_block_950_0: equiv_checker [PUSH 2 (natToWord WLen 934);DUP 2;PUSH 2 (natToWord WLen 783)] [PUSH 2 (natToWord WLen 934);DUP 2;PUSH 2 (natToWord WLen 783)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 EQ PUSH [tag] 935
 O: DUP2 EQ PUSH [tag] 935
*)
Example BottleCastle_run_code_of_0_block_951_0: equiv_checker [DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 935)] [DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 935)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example BottleCastle_run_code_of_0_block_952_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example BottleCastle_run_code_of_0_block_953_0: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 80 PUSH 40
 O: PUSH 80 PUSH 40
*)
Example ERC721A_initial_block_0_0: equiv_checker [PUSH 1 (natToWord WLen 128);PUSH 1 (natToWord WLen 64)] [PUSH 1 (natToWord WLen 128);PUSH 1 (natToWord WLen 64)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 1
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 1
*)
Example ERC721A_initial_block_0_1: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 1)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 1)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example ERC721A_initial_block_1_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

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
Example ERC721A_initial_block_2_1: equiv_checker [DUP 1;DUP 3;Opcode ADD;PUSH 1 (natToWord WLen 64)] [DUP 2;DUP 2;Opcode ADD;PUSH 1 (natToWord WLen 64)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 ADD SWAP1 PUSH [tag] 2 SWAP2 SWAP1 PUSH [tag] 3
 O: DUP2 ADD PUSH [tag] 2 SWAP2 PUSH [tag] 3
*)
Example ERC721A_initial_block_2_2: equiv_checker [DUP 2;Opcode ADD;PUSH 1 (natToWord WLen 2);DUP 2;PUSH 1 (natToWord WLen 3)] [DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 2);DUP 2;DUP 1;PUSH 1 (natToWord WLen 3)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 PUSH 2 SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 6 SWAP3 SWAP2 SWAP1 PUSH [tag] 7
 O: PUSH [tag] 6 PUSH 2 DUP4 PUSH 20 ADD DUP5 MLOAD PUSH [tag] 7
*)
Example ERC721A_initial_block_3_0: equiv_checker [PUSH 1 (natToWord WLen 6);PUSH 1 (natToWord WLen 2);DUP 4;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 5;Opcode MLOAD;PUSH 1 (natToWord WLen 7)] [DUP 2;PUSH 1 (natToWord WLen 2);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 6);DUP 3;DUP 2;DUP 1;PUSH 1 (natToWord WLen 7)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP DUP1 PUSH 3 SWAP1 DUP1 MLOAD SWAP1 PUSH 20 ADD SWAP1 PUSH [tag] 8 SWAP3 SWAP2 SWAP1 PUSH [tag] 7
 O: POP PUSH [tag] 8 PUSH 3 PUSH 20 DUP4 ADD DUP4 MLOAD PUSH [tag] 7
*)
Example ERC721A_initial_block_4_0: equiv_checker [POP;PUSH 1 (natToWord WLen 8);PUSH 1 (natToWord WLen 3);PUSH 1 (natToWord WLen 32);DUP 4;Opcode ADD;DUP 4;Opcode MLOAD;PUSH 1 (natToWord WLen 7)] [POP;DUP 1;PUSH 1 (natToWord WLen 3);DUP 1;DUP 1;Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 8);DUP 3;DUP 2;DUP 1;PUSH 1 (natToWord WLen 7)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 9 PUSH [tag] 10 PUSH 20 SHL PUSH 20 SHR
 O: POP PUSH [tag] 9 PUSH [tag] 10 PUSH 20 SHL PUSH 20 SHR
*)
Example ERC721A_initial_block_5_0: equiv_checker [POP;PUSH 1 (natToWord WLen 9);PUSH 1 (natToWord WLen 10);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] [POP;PUSH 1 (natToWord WLen 9);PUSH 1 (natToWord WLen 10);PUSH 1 (natToWord WLen 32);Opcode SHL;PUSH 1 (natToWord WLen 32);Opcode SHR] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 SWAP1
 O: DUP1 PUSH 0
*)
Example ERC721A_initial_block_6_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 0);DUP 2;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP PUSH [tag] 11
 O: POP POP POP PUSH [tag] 11
*)
Example ERC721A_initial_block_6_1: equiv_checker [POP;POP;POP;PUSH 1 (natToWord WLen 11)] [POP;POP;POP;PUSH 1 (natToWord WLen 11)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 SWAP1
 O: PUSH 0 SWAP1
*)
Example ERC721A_initial_block_7_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 DUP1 SLOAD PUSH [tag] 13 SWAP1 PUSH [tag] 14
 O: DUP3 PUSH [tag] 13 DUP5 SLOAD PUSH [tag] 14
*)
Example ERC721A_initial_block_8_0: equiv_checker [DUP 3;PUSH 1 (natToWord WLen 13);DUP 5;Opcode SLOAD;PUSH 1 (natToWord WLen 14)] [DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (natToWord WLen 13);DUP 1;PUSH 1 (natToWord WLen 14)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 PUSH 0
 O: SWAP1 PUSH 0
*)
Example ERC721A_initial_block_9_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 0)] [DUP 1;PUSH 1 (natToWord WLen 0)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1 PUSH 1F ADD PUSH 20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 16
 O: PUSH 20 DUP1 PUSH 0 KECCAK256 SWAP2 PUSH 1f ADD DIV DUP2 ADD SWAP3 DUP3 PUSH [tag] 16
*)
Example ERC721A_initial_block_9_1: equiv_checker [PUSH 1 (natToWord WLen 32);DUP 1;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 2;PUSH 1 (natToWord WLen 31);Opcode ADD;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 1 (natToWord WLen 16)] [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1;PUSH 1 (natToWord WLen 31);Opcode ADD;PUSH 1 (natToWord WLen 32);DUP 1;Opcode DIV;DUP 2;Opcode ADD;DUP 3;DUP 3;PUSH 1 (natToWord WLen 16)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP6
 O: PUSH 0 DUP6
*)
Example ERC721A_initial_block_10_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 6] [PUSH 1 (natToWord WLen 0);DUP 6] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 15
 O: PUSH [tag] 15
*)
Example ERC721A_initial_block_10_1: equiv_checker [PUSH 1 (natToWord WLen 15)] [PUSH 1 (natToWord WLen 15)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 PUSH 1F LT PUSH [tag] 17
 O: DUP3 PUSH 1f LT PUSH [tag] 17
*)
Example ERC721A_initial_block_11_0: equiv_checker [DUP 3;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 1 (natToWord WLen 17)] [DUP 3;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 1 (natToWord WLen 17)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 MLOAD PUSH FF NOT AND DUP4 DUP1 ADD OR DUP6
 O: DUP3 DUP1 ADD PUSH ff NOT DUP3 MLOAD AND OR DUP6
*)
Example ERC721A_initial_block_12_0: equiv_checker [DUP 3;DUP 1;Opcode ADD;PUSH 1 (natToWord WLen 255);Opcode NOT;DUP 3;Opcode MLOAD;Opcode AND;Opcode OR;DUP 6] [DUP 1;Opcode MLOAD;PUSH 1 (natToWord WLen 255);Opcode NOT;Opcode AND;DUP 4;DUP 1;Opcode ADD;Opcode OR;DUP 6] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 15
 O: PUSH [tag] 15
*)
Example ERC721A_initial_block_12_1: equiv_checker [PUSH 1 (natToWord WLen 15)] [PUSH 1 (natToWord WLen 15)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 DUP1 ADD PUSH 1 ADD DUP6
 O: DUP3 DUP4 ADD PUSH 1 ADD DUP6
*)
Example ERC721A_initial_block_13_0: equiv_checker [DUP 3;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 6] [DUP 3;DUP 1;Opcode ADD;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 6] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 ISZERO PUSH [tag] 15
 O: DUP3 ISZERO PUSH [tag] 15
*)
Example ERC721A_initial_block_13_1: equiv_checker [DUP 3;Opcode ISZERO;PUSH 1 (natToWord WLen 15)] [DUP 3;Opcode ISZERO;PUSH 1 (natToWord WLen 15)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 DUP3 ADD
 O: DUP1 SWAP3 ADD
*)
Example ERC721A_initial_block_14_0: equiv_checker [DUP 1;DUP 3;Opcode ADD] [DUP 2;DUP 3;Opcode ADD] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 DUP2 GT ISZERO PUSH [tag] 19
 O: DUP3 DUP2 GT ISZERO PUSH [tag] 19
*)
Example ERC721A_initial_block_15_0: equiv_checker [DUP 3;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 19)] [DUP 3;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 19)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 MLOAD DUP3
 O: DUP3 MLOAD DUP3
*)
Example ERC721A_initial_block_16_0: equiv_checker [DUP 3;Opcode MLOAD;DUP 3] [DUP 3;Opcode MLOAD;DUP 3] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 PUSH 20 ADD SWAP2 SWAP1 PUSH 1 ADD SWAP1 PUSH [tag] 18
 O: SWAP2 PUSH 20 ADD SWAP2 SWAP1 PUSH 1 ADD SWAP1 PUSH [tag] 18
*)
Example ERC721A_initial_block_16_1: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 18)] [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 18)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP1 POP PUSH [tag] 20 SWAP2 SWAP1 PUSH [tag] 21
 O: POP PUSH [tag] 20 SWAP3 SWAP2 POP PUSH [tag] 21
*)
Example ERC721A_initial_block_18_0: equiv_checker [POP;PUSH 1 (natToWord WLen 20);DUP 3;DUP 2;POP;PUSH 1 (natToWord WLen 21)] [POP;DUP 1;POP;PUSH 1 (natToWord WLen 20);DUP 2;DUP 1;PUSH 1 (natToWord WLen 21)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP1
 O: POP SWAP1
*)
Example ERC721A_initial_block_19_0: equiv_checker [POP;DUP 1] [POP;DUP 1] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 DUP3 GT ISZERO PUSH [tag] 23
 O: DUP1 DUP3 GT ISZERO PUSH [tag] 23
*)
Example ERC721A_initial_block_21_0: equiv_checker [DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 23)] [DUP 1;DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 23)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 PUSH 0 SWAP1
 O: PUSH 0 DUP1 DUP3
*)
Example ERC721A_initial_block_22_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;DUP 3] [PUSH 1 (natToWord WLen 0);DUP 2;PUSH 1 (natToWord WLen 0);DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 1 ADD PUSH [tag] 22
 O: POP PUSH 1 ADD PUSH [tag] 22
*)
Example ERC721A_initial_block_22_1: equiv_checker [POP;PUSH 1 (natToWord WLen 1);Opcode ADD;PUSH 1 (natToWord WLen 22)] [POP;PUSH 1 (natToWord WLen 1);Opcode ADD;PUSH 1 (natToWord WLen 22)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP1
 O: POP SWAP1
*)
Example ERC721A_initial_block_23_0: equiv_checker [POP;DUP 1] [POP;DUP 1] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 27 PUSH [tag] 28 DUP5 PUSH [tag] 29
 O: PUSH 0 PUSH [tag] 27 PUSH [tag] 28 DUP5 PUSH [tag] 29
*)
Example ERC721A_initial_block_24_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 27);PUSH 1 (natToWord WLen 28);DUP 5;PUSH 1 (natToWord WLen 29)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 27);PUSH 1 (natToWord WLen 28);DUP 5;PUSH 1 (natToWord WLen 29)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 30
 O: PUSH [tag] 30
*)
Example ERC721A_initial_block_25_0: equiv_checker [PUSH 1 (natToWord WLen 30)] [PUSH 1 (natToWord WLen 30)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP DUP3 DUP2
 O: SWAP1 POP DUP3 DUP2
*)
Example ERC721A_initial_block_26_0: equiv_checker [DUP 1;POP;DUP 3;DUP 2] [DUP 1;POP;DUP 3;DUP 2] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP2 ADD DUP5 DUP5 DUP5 ADD GT ISZERO PUSH [tag] 31
 O: DUP1 PUSH 20 ADD DUP5 DUP4 DUP6 ADD GT ISZERO PUSH [tag] 31
*)
Example ERC721A_initial_block_26_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 5;DUP 4;DUP 6;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 31)] [PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;DUP 5;DUP 5;DUP 5;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 31)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 32 PUSH [tag] 33
 O: PUSH [tag] 32 PUSH [tag] 33
*)
Example ERC721A_initial_block_27_0: equiv_checker [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 33)] [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 33)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 34 DUP5 DUP3 DUP6 PUSH [tag] 35
 O: PUSH [tag] 34 DUP5 DUP3 DUP6 PUSH [tag] 35
*)
Example ERC721A_initial_block_29_0: equiv_checker [PUSH 1 (natToWord WLen 34);DUP 5;DUP 3;DUP 6;PUSH 1 (natToWord WLen 35)] [PUSH 1 (natToWord WLen 34);DUP 5;DUP 3;DUP 6;PUSH 1 (natToWord WLen 35)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP4 SWAP3 POP POP POP
 O: POP SWAP4 SWAP3 POP POP POP
*)
Example ERC721A_initial_block_30_0: equiv_checker [POP;DUP 4;DUP 3;POP;POP;POP] [POP;DUP 4;DUP 3;POP;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 38
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 38
*)
Example ERC721A_initial_block_31_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 3;DUP 3;PUSH 1 (natToWord WLen 31);Opcode ADD;Opcode SLT;PUSH 1 (natToWord WLen 38)] [PUSH 1 (natToWord WLen 0);DUP 3;PUSH 1 (natToWord WLen 31);DUP 4;Opcode ADD;Opcode SLT;PUSH 1 (natToWord WLen 38)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 39 PUSH [tag] 40
 O: PUSH [tag] 39 PUSH [tag] 40
*)
Example ERC721A_initial_block_32_0: equiv_checker [PUSH 1 (natToWord WLen 39);PUSH 1 (natToWord WLen 40)] [PUSH 1 (natToWord WLen 39);PUSH 1 (natToWord WLen 40)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 MLOAD PUSH [tag] 41 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 25
 O: DUP2 MLOAD PUSH [tag] 41 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 25
*)
Example ERC721A_initial_block_34_0: equiv_checker [DUP 2;Opcode MLOAD;PUSH 1 (natToWord WLen 41);DUP 5;DUP 3;PUSH 1 (natToWord WLen 32);DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 25)] [DUP 2;Opcode MLOAD;PUSH 1 (natToWord WLen 41);DUP 5;DUP 3;PUSH 1 (natToWord WLen 32);DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 25)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Example ERC721A_initial_block_35_0: equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 43
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 43
*)
Example ERC721A_initial_block_36_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 64);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (natToWord WLen 43)] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 64);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (natToWord WLen 43)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 44 PUSH [tag] 45
 O: PUSH [tag] 44 PUSH [tag] 45
*)
Example ERC721A_initial_block_37_0: equiv_checker [PUSH 1 (natToWord WLen 44);PUSH 1 (natToWord WLen 45)] [PUSH 1 (natToWord WLen 44);PUSH 1 (natToWord WLen 45)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP4 ADD MLOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 46
 O: DUP3 PUSH 0 ADD MLOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 46
*)
Example ERC721A_initial_block_39_0: equiv_checker [DUP 3;PUSH 1 (natToWord WLen 0);Opcode ADD;Opcode MLOAD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 46)] [PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD;Opcode MLOAD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 46)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 47 PUSH [tag] 48
 O: PUSH [tag] 47 PUSH [tag] 48
*)
Example ERC721A_initial_block_40_0: equiv_checker [PUSH 1 (natToWord WLen 47);PUSH 1 (natToWord WLen 48)] [PUSH 1 (natToWord WLen 47);PUSH 1 (natToWord WLen 48)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 49 DUP6 DUP3 DUP7 ADD PUSH [tag] 36
 O: PUSH [tag] 49 DUP6 DUP3 DUP7 ADD PUSH [tag] 36
*)
Example ERC721A_initial_block_42_0: equiv_checker [PUSH 1 (natToWord WLen 49);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 36)] [PUSH 1 (natToWord WLen 49);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 36)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP POP PUSH 20 DUP4 ADD MLOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 50
 O: SWAP3 POP POP DUP3 PUSH 20 ADD MLOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 50
*)
Example ERC721A_initial_block_43_0: equiv_checker [DUP 3;POP;POP;DUP 3;PUSH 1 (natToWord WLen 32);Opcode ADD;Opcode MLOAD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 50)] [DUP 3;POP;POP;PUSH 1 (natToWord WLen 32);DUP 4;Opcode ADD;Opcode MLOAD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 50)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 51 PUSH [tag] 48
 O: PUSH [tag] 51 PUSH [tag] 48
*)
Example ERC721A_initial_block_44_0: equiv_checker [PUSH 1 (natToWord WLen 51);PUSH 1 (natToWord WLen 48)] [PUSH 1 (natToWord WLen 51);PUSH 1 (natToWord WLen 48)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 52 DUP6 DUP3 DUP7 ADD PUSH [tag] 36
 O: PUSH [tag] 52 DUP6 DUP3 DUP7 ADD PUSH [tag] 36
*)
Example ERC721A_initial_block_46_0: equiv_checker [PUSH 1 (natToWord WLen 52);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 36)] [PUSH 1 (natToWord WLen 52);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 36)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Example ERC721A_initial_block_47_0: equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 54 PUSH [tag] 55
 O: PUSH 0 PUSH [tag] 54 PUSH [tag] 55
*)
Example ERC721A_initial_block_48_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 54);PUSH 1 (natToWord WLen 55)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 54);PUSH 1 (natToWord WLen 55)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP PUSH [tag] 56 DUP3 DUP3 PUSH [tag] 57
 O: SWAP1 POP PUSH [tag] 56 DUP3 DUP3 PUSH [tag] 57
*)
Example ERC721A_initial_block_49_0: equiv_checker [DUP 1;POP;PUSH 1 (natToWord WLen 56);DUP 3;DUP 3;PUSH 1 (natToWord WLen 57)] [DUP 1;POP;PUSH 1 (natToWord WLen 56);DUP 3;DUP 3;PUSH 1 (natToWord WLen 57)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Example ERC721A_initial_block_50_0: equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 40 MLOAD SWAP1 POP SWAP1
 O: PUSH 40 MLOAD SWAP1
*)
Example ERC721A_initial_block_51_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;POP;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFF DUP3 GT ISZERO PUSH [tag] 60
 O: PUSH 0 PUSH ffffffffffffffff DUP3 GT ISZERO PUSH [tag] 60
*)
Example ERC721A_initial_block_52_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 8 (natToWord WLen 18446744073709551615);DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 60)] [PUSH 1 (natToWord WLen 0);PUSH 8 (natToWord WLen 18446744073709551615);DUP 3;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 60)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 61 PUSH [tag] 62
 O: PUSH [tag] 61 PUSH [tag] 62
*)
Example ERC721A_initial_block_53_0: equiv_checker [PUSH 1 (natToWord WLen 61);PUSH 1 (natToWord WLen 62)] [PUSH 1 (natToWord WLen 61);PUSH 1 (natToWord WLen 62)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 63 DUP3 PUSH [tag] 64
 O: PUSH [tag] 63 DUP3 PUSH [tag] 64
*)
Example ERC721A_initial_block_55_0: equiv_checker [PUSH 1 (natToWord WLen 63);DUP 3;PUSH 1 (natToWord WLen 64)] [PUSH 1 (natToWord WLen 63);DUP 3;PUSH 1 (natToWord WLen 64)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP PUSH 20 DUP2 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP2 POP POP SWAP1
*)
Example ERC721A_initial_block_56_0: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;POP;POP;DUP 1] [DUP 1;POP;PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0
 O: PUSH 0
*)
Example ERC721A_initial_block_57_0: equiv_checker [PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP4 DUP2 LT ISZERO PUSH [tag] 68
 O: DUP4 DUP2 LT ISZERO PUSH [tag] 68
*)
Example ERC721A_initial_block_58_0: equiv_checker [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 1 (natToWord WLen 68)] [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 1 (natToWord WLen 68)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD
 O: DUP2 DUP2 ADD MLOAD DUP4 DUP3 ADD
*)
Example ERC721A_initial_block_59_0: equiv_checker [DUP 2;DUP 2;Opcode ADD;Opcode MLOAD;DUP 4;DUP 3;Opcode ADD] [DUP 1;DUP 3;Opcode ADD;Opcode MLOAD;DUP 2;DUP 5;Opcode ADD] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP2 ADD SWAP1 POP PUSH [tag] 66
 O: PUSH 20 ADD PUSH [tag] 66
*)
Example ERC721A_initial_block_59_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 66)] [PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;DUP 1;POP;PUSH 1 (natToWord WLen 66)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP4 DUP2 GT ISZERO PUSH [tag] 69
 O: DUP4 DUP2 GT ISZERO PUSH [tag] 69
*)
Example ERC721A_initial_block_60_0: equiv_checker [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 69)] [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 69)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP5 DUP5 ADD
 O: PUSH 0 DUP4 DUP6 ADD
*)
Example ERC721A_initial_block_61_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 4;DUP 6;Opcode ADD] [PUSH 1 (natToWord WLen 0);DUP 5;DUP 5;Opcode ADD] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Example ERC721A_initial_block_62_0: equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 2 DUP3 DIV SWAP1 POP PUSH 1 DUP3 AND DUP1 PUSH [tag] 71
 O: PUSH 2 DUP2 DIV DUP2 PUSH 1 AND DUP1 PUSH [tag] 71
*)
Example ERC721A_initial_block_63_0: equiv_checker [PUSH 1 (natToWord WLen 2);DUP 2;Opcode DIV;DUP 2;PUSH 1 (natToWord WLen 1);Opcode AND;DUP 1;PUSH 1 (natToWord WLen 71)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 2);DUP 3;Opcode DIV;DUP 1;POP;PUSH 1 (natToWord WLen 1);DUP 3;Opcode AND;DUP 1;PUSH 1 (natToWord WLen 71)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 7F DUP3 AND SWAP2 POP
 O: SWAP1 PUSH 7f AND SWAP1
*)
Example ERC721A_initial_block_64_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 127);Opcode AND;DUP 1] [PUSH 1 (natToWord WLen 127);DUP 3;Opcode AND;DUP 2;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 LT DUP2 EQ ISZERO PUSH [tag] 72
 O: DUP1 PUSH 20 DUP4 LT EQ ISZERO PUSH [tag] 72
*)
Example ERC721A_initial_block_65_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);DUP 4;Opcode LT;Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 72)] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode LT;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 72)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 73 PUSH [tag] 74
 O: PUSH [tag] 73 PUSH [tag] 74
*)
Example ERC721A_initial_block_66_0: equiv_checker [PUSH 1 (natToWord WLen 73);PUSH 1 (natToWord WLen 74)] [PUSH 1 (natToWord WLen 73);PUSH 1 (natToWord WLen 74)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP2 SWAP1 POP
 O: POP SWAP2 SWAP1 POP
*)
Example ERC721A_initial_block_68_0: equiv_checker [POP;DUP 2;DUP 1;POP] [POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 76 DUP3 PUSH [tag] 64
 O: PUSH [tag] 76 DUP3 PUSH [tag] 64
*)
Example ERC721A_initial_block_69_0: equiv_checker [PUSH 1 (natToWord WLen 76);DUP 3;PUSH 1 (natToWord WLen 64)] [PUSH 1 (natToWord WLen 76);DUP 3;PUSH 1 (natToWord WLen 64)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 ADD DUP2 DUP2 LT PUSH FFFFFFFFFFFFFFFF DUP3 GT OR ISZERO PUSH [tag] 77
 O: DUP2 ADD PUSH ffffffffffffffff DUP2 GT DUP3 DUP3 LT OR ISZERO PUSH [tag] 77
*)
Example ERC721A_initial_block_70_0: equiv_checker [DUP 2;Opcode ADD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;DUP 3;DUP 3;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 1 (natToWord WLen 77)] [DUP 2;Opcode ADD;DUP 2;DUP 2;Opcode LT;PUSH 8 (natToWord WLen 18446744073709551615);DUP 3;Opcode GT;Opcode OR;Opcode ISZERO;PUSH 1 (natToWord WLen 77)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 78 PUSH [tag] 62
 O: PUSH [tag] 78 PUSH [tag] 62
*)
Example ERC721A_initial_block_71_0: equiv_checker [PUSH 1 (natToWord WLen 78);PUSH 1 (natToWord WLen 62)] [PUSH 1 (natToWord WLen 78);PUSH 1 (natToWord WLen 62)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 40
 O: DUP1 PUSH 40
*)
Example ERC721A_initial_block_73_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 64)] [DUP 1;PUSH 1 (natToWord WLen 64)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP
 O: POP POP POP
*)
Example ERC721A_initial_block_73_1: equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Example ERC721A_initial_block_74_0: equiv_checker [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 22 PUSH 4
 O: PUSH 22 PUSH 4
*)
Example ERC721A_initial_block_74_1: equiv_checker [PUSH 1 (natToWord WLen 34);PUSH 1 (natToWord WLen 4)] [PUSH 1 (natToWord WLen 34);PUSH 1 (natToWord WLen 4)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Example ERC721A_initial_block_74_2: equiv_checker [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Example ERC721A_initial_block_75_0: equiv_checker [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 41 PUSH 4
 O: PUSH 41 PUSH 4
*)
Example ERC721A_initial_block_75_1: equiv_checker [PUSH 1 (natToWord WLen 65);PUSH 1 (natToWord WLen 4)] [PUSH 1 (natToWord WLen 65);PUSH 1 (natToWord WLen 4)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Example ERC721A_initial_block_75_2: equiv_checker [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example ERC721A_initial_block_76_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example ERC721A_initial_block_77_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example ERC721A_initial_block_78_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example ERC721A_initial_block_79_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 1F NOT PUSH 1F DUP4 ADD AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 1f ADD PUSH 1f NOT AND SWAP1
*)
Example ERC721A_initial_block_80_0: equiv_checker [PUSH 1 (natToWord WLen 31);Opcode ADD;PUSH 1 (natToWord WLen 31);Opcode NOT;Opcode AND;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 31);Opcode NOT;PUSH 1 (natToWord WLen 31);DUP 4;Opcode ADD;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

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
Example ERC721A_initial_block_81_1: equiv_checker [PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 80 PUSH 40
 O: PUSH 80 PUSH 40
*)
Example ERC721A_run_code_of_0_block_0_0: equiv_checker [PUSH 1 (natToWord WLen 128);PUSH 1 (natToWord WLen 64)] [PUSH 1 (natToWord WLen 128);PUSH 1 (natToWord WLen 64)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: CALLVALUE DUP1 ISZERO PUSH [tag] 1
 O: CALLVALUE CALLVALUE ISZERO PUSH [tag] 1
*)
Example ERC721A_run_code_of_0_block_0_1: equiv_checker [Opcode CALLVALUE;Opcode CALLVALUE;Opcode ISZERO;PUSH 1 (natToWord WLen 1)] [Opcode CALLVALUE;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 1)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example ERC721A_run_code_of_0_block_1_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 4 CALLDATASIZE LT PUSH [tag] 2
 O: POP PUSH 4 CALLDATASIZE LT PUSH [tag] 2
*)
Example ERC721A_run_code_of_0_block_2_0: equiv_checker [POP;PUSH 1 (natToWord WLen 4);Opcode CALLDATASIZE;Opcode LT;PUSH 1 (natToWord WLen 2)] [POP;PUSH 1 (natToWord WLen 4);Opcode CALLDATASIZE;Opcode LT;PUSH 1 (natToWord WLen 2)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 CALLDATALOAD PUSH E0 SHR DUP1 PUSH 6352211E GT PUSH [tag] 17
 O: PUSH 0 CALLDATALOAD PUSH e0 SHR DUP1 PUSH 6352211e GT PUSH [tag] 17
*)
Example ERC721A_run_code_of_0_block_3_0: equiv_checker [PUSH 1 (natToWord WLen 0);Opcode CALLDATALOAD;PUSH 1 (natToWord WLen 224);Opcode SHR;DUP 1;PUSH 4 (natToWord WLen 1666326814);Opcode GT;PUSH 1 (natToWord WLen 17)] [PUSH 1 (natToWord WLen 0);Opcode CALLDATALOAD;PUSH 1 (natToWord WLen 224);Opcode SHR;DUP 1;PUSH 4 (natToWord WLen 1666326814);Opcode GT;PUSH 1 (natToWord WLen 17)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH A22CB465 GT PUSH [tag] 18
 O: DUP1 PUSH a22cb465 GT PUSH [tag] 18
*)
Example ERC721A_run_code_of_0_block_4_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 2720838757);Opcode GT;PUSH 1 (natToWord WLen 18)] [DUP 1;PUSH 4 (natToWord WLen 2720838757);Opcode GT;PUSH 1 (natToWord WLen 18)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH A22CB465 EQ PUSH [tag] 13
 O: DUP1 PUSH a22cb465 EQ PUSH [tag] 13
*)
Example ERC721A_run_code_of_0_block_5_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 2720838757);Opcode EQ;PUSH 1 (natToWord WLen 13)] [DUP 1;PUSH 4 (natToWord WLen 2720838757);Opcode EQ;PUSH 1 (natToWord WLen 13)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH B88D4FDE EQ PUSH [tag] 14
 O: DUP1 PUSH b88d4fde EQ PUSH [tag] 14
*)
Example ERC721A_run_code_of_0_block_6_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 3096268766);Opcode EQ;PUSH 1 (natToWord WLen 14)] [DUP 1;PUSH 4 (natToWord WLen 3096268766);Opcode EQ;PUSH 1 (natToWord WLen 14)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH C87B56DD EQ PUSH [tag] 15
 O: DUP1 PUSH c87b56dd EQ PUSH [tag] 15
*)
Example ERC721A_run_code_of_0_block_7_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 3363526365);Opcode EQ;PUSH 1 (natToWord WLen 15)] [DUP 1;PUSH 4 (natToWord WLen 3363526365);Opcode EQ;PUSH 1 (natToWord WLen 15)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH E985E9C5 EQ PUSH [tag] 16
 O: DUP1 PUSH e985e9c5 EQ PUSH [tag] 16
*)
Example ERC721A_run_code_of_0_block_8_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 3917867461);Opcode EQ;PUSH 1 (natToWord WLen 16)] [DUP 1;PUSH 4 (natToWord WLen 3917867461);Opcode EQ;PUSH 1 (natToWord WLen 16)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 2
 O: PUSH [tag] 2
*)
Example ERC721A_run_code_of_0_block_9_0: equiv_checker [PUSH 1 (natToWord WLen 2)] [PUSH 1 (natToWord WLen 2)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 6352211E EQ PUSH [tag] 10
 O: DUP1 PUSH 6352211e EQ PUSH [tag] 10
*)
Example ERC721A_run_code_of_0_block_10_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 1666326814);Opcode EQ;PUSH 1 (natToWord WLen 10)] [DUP 1;PUSH 4 (natToWord WLen 1666326814);Opcode EQ;PUSH 1 (natToWord WLen 10)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 70A08231 EQ PUSH [tag] 11
 O: DUP1 PUSH 70a08231 EQ PUSH [tag] 11
*)
Example ERC721A_run_code_of_0_block_11_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 1889567281);Opcode EQ;PUSH 1 (natToWord WLen 11)] [DUP 1;PUSH 4 (natToWord WLen 1889567281);Opcode EQ;PUSH 1 (natToWord WLen 11)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 95D89B41 EQ PUSH [tag] 12
 O: DUP1 PUSH 95d89b41 EQ PUSH [tag] 12
*)
Example ERC721A_run_code_of_0_block_12_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 2514000705);Opcode EQ;PUSH 1 (natToWord WLen 12)] [DUP 1;PUSH 4 (natToWord WLen 2514000705);Opcode EQ;PUSH 1 (natToWord WLen 12)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 2
 O: PUSH [tag] 2
*)
Example ERC721A_run_code_of_0_block_13_0: equiv_checker [PUSH 1 (natToWord WLen 2)] [PUSH 1 (natToWord WLen 2)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 95EA7B3 GT PUSH [tag] 19
 O: DUP1 PUSH 95ea7b3 GT PUSH [tag] 19
*)
Example ERC721A_run_code_of_0_block_14_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 157198259);Opcode GT;PUSH 1 (natToWord WLen 19)] [DUP 1;PUSH 4 (natToWord WLen 157198259);Opcode GT;PUSH 1 (natToWord WLen 19)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 95EA7B3 EQ PUSH [tag] 6
 O: DUP1 PUSH 95ea7b3 EQ PUSH [tag] 6
*)
Example ERC721A_run_code_of_0_block_15_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 157198259);Opcode EQ;PUSH 1 (natToWord WLen 6)] [DUP 1;PUSH 4 (natToWord WLen 157198259);Opcode EQ;PUSH 1 (natToWord WLen 6)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 18160DDD EQ PUSH [tag] 7
 O: DUP1 PUSH 18160ddd EQ PUSH [tag] 7
*)
Example ERC721A_run_code_of_0_block_16_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 404098525);Opcode EQ;PUSH 1 (natToWord WLen 7)] [DUP 1;PUSH 4 (natToWord WLen 404098525);Opcode EQ;PUSH 1 (natToWord WLen 7)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 23B872DD EQ PUSH [tag] 8
 O: DUP1 PUSH 23b872dd EQ PUSH [tag] 8
*)
Example ERC721A_run_code_of_0_block_17_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 599290589);Opcode EQ;PUSH 1 (natToWord WLen 8)] [DUP 1;PUSH 4 (natToWord WLen 599290589);Opcode EQ;PUSH 1 (natToWord WLen 8)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 42842E0E EQ PUSH [tag] 9
 O: DUP1 PUSH 42842e0e EQ PUSH [tag] 9
*)
Example ERC721A_run_code_of_0_block_18_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 1115958798);Opcode EQ;PUSH 1 (natToWord WLen 9)] [DUP 1;PUSH 4 (natToWord WLen 1115958798);Opcode EQ;PUSH 1 (natToWord WLen 9)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 2
 O: PUSH [tag] 2
*)
Example ERC721A_run_code_of_0_block_19_0: equiv_checker [PUSH 1 (natToWord WLen 2)] [PUSH 1 (natToWord WLen 2)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1FFC9A7 EQ PUSH [tag] 3
 O: DUP1 PUSH 1ffc9a7 EQ PUSH [tag] 3
*)
Example ERC721A_run_code_of_0_block_20_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 33540519);Opcode EQ;PUSH 1 (natToWord WLen 3)] [DUP 1;PUSH 4 (natToWord WLen 33540519);Opcode EQ;PUSH 1 (natToWord WLen 3)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 6FDDE03 EQ PUSH [tag] 4
 O: DUP1 PUSH 6fdde03 EQ PUSH [tag] 4
*)
Example ERC721A_run_code_of_0_block_21_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 117300739);Opcode EQ;PUSH 1 (natToWord WLen 4)] [DUP 1;PUSH 4 (natToWord WLen 117300739);Opcode EQ;PUSH 1 (natToWord WLen 4)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 81812FC EQ PUSH [tag] 5
 O: DUP1 PUSH 81812fc EQ PUSH [tag] 5
*)
Example ERC721A_run_code_of_0_block_22_0: equiv_checker [DUP 1;PUSH 4 (natToWord WLen 135795452);Opcode EQ;PUSH 1 (natToWord WLen 5)] [DUP 1;PUSH 4 (natToWord WLen 135795452);Opcode EQ;PUSH 1 (natToWord WLen 5)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example ERC721A_run_code_of_0_block_23_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 20 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 21 SWAP2 SWAP1 PUSH [tag] 22
 O: PUSH [tag] 20 PUSH [tag] 21 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 22
*)
Example ERC721A_run_code_of_0_block_24_0: equiv_checker [PUSH 1 (natToWord WLen 20);PUSH 1 (natToWord WLen 21);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 22)] [PUSH 1 (natToWord WLen 20);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 21);DUP 2;DUP 1;PUSH 1 (natToWord WLen 22)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 23
 O: PUSH [tag] 23
*)
Example ERC721A_run_code_of_0_block_25_0: equiv_checker [PUSH 1 (natToWord WLen 23)] [PUSH 1 (natToWord WLen 23)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 24 SWAP2 SWAP1 PUSH [tag] 25
 O: PUSH [tag] 24 SWAP1 PUSH 40 MLOAD PUSH [tag] 25
*)
Example ERC721A_run_code_of_0_block_26_0: equiv_checker [PUSH 1 (natToWord WLen 24);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 25)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 24);DUP 2;DUP 1;PUSH 1 (natToWord WLen 25)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_27_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 26 PUSH [tag] 27
 O: PUSH [tag] 26 PUSH [tag] 27
*)
Example ERC721A_run_code_of_0_block_28_0: equiv_checker [PUSH 1 (natToWord WLen 26);PUSH 1 (natToWord WLen 27)] [PUSH 1 (natToWord WLen 26);PUSH 1 (natToWord WLen 27)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 28 SWAP2 SWAP1 PUSH [tag] 29
 O: PUSH [tag] 28 SWAP1 PUSH 40 MLOAD PUSH [tag] 29
*)
Example ERC721A_run_code_of_0_block_29_0: equiv_checker [PUSH 1 (natToWord WLen 28);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 29)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 28);DUP 2;DUP 1;PUSH 1 (natToWord WLen 29)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_30_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 30 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 31 SWAP2 SWAP1 PUSH [tag] 32
 O: PUSH [tag] 30 PUSH [tag] 31 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 32
*)
Example ERC721A_run_code_of_0_block_31_0: equiv_checker [PUSH 1 (natToWord WLen 30);PUSH 1 (natToWord WLen 31);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 32)] [PUSH 1 (natToWord WLen 30);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 31);DUP 2;DUP 1;PUSH 1 (natToWord WLen 32)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 33
 O: PUSH [tag] 33
*)
Example ERC721A_run_code_of_0_block_32_0: equiv_checker [PUSH 1 (natToWord WLen 33)] [PUSH 1 (natToWord WLen 33)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 34 SWAP2 SWAP1 PUSH [tag] 35
 O: PUSH [tag] 34 SWAP1 PUSH 40 MLOAD PUSH [tag] 35
*)
Example ERC721A_run_code_of_0_block_33_0: equiv_checker [PUSH 1 (natToWord WLen 34);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 35)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 34);DUP 2;DUP 1;PUSH 1 (natToWord WLen 35)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_34_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 36 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 37 SWAP2 SWAP1 PUSH [tag] 38
 O: PUSH [tag] 36 PUSH [tag] 37 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 38
*)
Example ERC721A_run_code_of_0_block_35_0: equiv_checker [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 37);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 38)] [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 37);DUP 2;DUP 1;PUSH 1 (natToWord WLen 38)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 39
 O: PUSH [tag] 39
*)
Example ERC721A_run_code_of_0_block_36_0: equiv_checker [PUSH 1 (natToWord WLen 39)] [PUSH 1 (natToWord WLen 39)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 40 PUSH [tag] 41
 O: PUSH [tag] 40 PUSH [tag] 41
*)
Example ERC721A_run_code_of_0_block_38_0: equiv_checker [PUSH 1 (natToWord WLen 40);PUSH 1 (natToWord WLen 41)] [PUSH 1 (natToWord WLen 40);PUSH 1 (natToWord WLen 41)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 42 SWAP2 SWAP1 PUSH [tag] 43
 O: PUSH [tag] 42 SWAP1 PUSH 40 MLOAD PUSH [tag] 43
*)
Example ERC721A_run_code_of_0_block_39_0: equiv_checker [PUSH 1 (natToWord WLen 42);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 43)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 42);DUP 2;DUP 1;PUSH 1 (natToWord WLen 43)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_40_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 44 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 45 SWAP2 SWAP1 PUSH [tag] 46
 O: PUSH [tag] 44 PUSH [tag] 45 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 46
*)
Example ERC721A_run_code_of_0_block_41_0: equiv_checker [PUSH 1 (natToWord WLen 44);PUSH 1 (natToWord WLen 45);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 46)] [PUSH 1 (natToWord WLen 44);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 45);DUP 2;DUP 1;PUSH 1 (natToWord WLen 46)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 47
 O: PUSH [tag] 47
*)
Example ERC721A_run_code_of_0_block_42_0: equiv_checker [PUSH 1 (natToWord WLen 47)] [PUSH 1 (natToWord WLen 47)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 48 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 49 SWAP2 SWAP1 PUSH [tag] 46
 O: PUSH [tag] 48 PUSH [tag] 49 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 46
*)
Example ERC721A_run_code_of_0_block_44_0: equiv_checker [PUSH 1 (natToWord WLen 48);PUSH 1 (natToWord WLen 49);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 46)] [PUSH 1 (natToWord WLen 48);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 49);DUP 2;DUP 1;PUSH 1 (natToWord WLen 46)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 50
 O: PUSH [tag] 50
*)
Example ERC721A_run_code_of_0_block_45_0: equiv_checker [PUSH 1 (natToWord WLen 50)] [PUSH 1 (natToWord WLen 50)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 51 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 52 SWAP2 SWAP1 PUSH [tag] 32
 O: PUSH [tag] 51 PUSH [tag] 52 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 32
*)
Example ERC721A_run_code_of_0_block_47_0: equiv_checker [PUSH 1 (natToWord WLen 51);PUSH 1 (natToWord WLen 52);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 32)] [PUSH 1 (natToWord WLen 51);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 52);DUP 2;DUP 1;PUSH 1 (natToWord WLen 32)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 53
 O: PUSH [tag] 53
*)
Example ERC721A_run_code_of_0_block_48_0: equiv_checker [PUSH 1 (natToWord WLen 53)] [PUSH 1 (natToWord WLen 53)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 54 SWAP2 SWAP1 PUSH [tag] 35
 O: PUSH [tag] 54 SWAP1 PUSH 40 MLOAD PUSH [tag] 35
*)
Example ERC721A_run_code_of_0_block_49_0: equiv_checker [PUSH 1 (natToWord WLen 54);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 35)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 54);DUP 2;DUP 1;PUSH 1 (natToWord WLen 35)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_50_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 55 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 56 SWAP2 SWAP1 PUSH [tag] 57
 O: PUSH [tag] 55 PUSH [tag] 56 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 57
*)
Example ERC721A_run_code_of_0_block_51_0: equiv_checker [PUSH 1 (natToWord WLen 55);PUSH 1 (natToWord WLen 56);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 57)] [PUSH 1 (natToWord WLen 55);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 56);DUP 2;DUP 1;PUSH 1 (natToWord WLen 57)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 58
 O: PUSH [tag] 58
*)
Example ERC721A_run_code_of_0_block_52_0: equiv_checker [PUSH 1 (natToWord WLen 58)] [PUSH 1 (natToWord WLen 58)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 59 SWAP2 SWAP1 PUSH [tag] 43
 O: PUSH [tag] 59 SWAP1 PUSH 40 MLOAD PUSH [tag] 43
*)
Example ERC721A_run_code_of_0_block_53_0: equiv_checker [PUSH 1 (natToWord WLen 59);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 43)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 59);DUP 2;DUP 1;PUSH 1 (natToWord WLen 43)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_54_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 60 PUSH [tag] 61
 O: PUSH [tag] 60 PUSH [tag] 61
*)
Example ERC721A_run_code_of_0_block_55_0: equiv_checker [PUSH 1 (natToWord WLen 60);PUSH 1 (natToWord WLen 61)] [PUSH 1 (natToWord WLen 60);PUSH 1 (natToWord WLen 61)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 62 SWAP2 SWAP1 PUSH [tag] 29
 O: PUSH [tag] 62 SWAP1 PUSH 40 MLOAD PUSH [tag] 29
*)
Example ERC721A_run_code_of_0_block_56_0: equiv_checker [PUSH 1 (natToWord WLen 62);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 29)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 62);DUP 2;DUP 1;PUSH 1 (natToWord WLen 29)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_57_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 63 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 64 SWAP2 SWAP1 PUSH [tag] 65
 O: PUSH [tag] 63 PUSH [tag] 64 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 65
*)
Example ERC721A_run_code_of_0_block_58_0: equiv_checker [PUSH 1 (natToWord WLen 63);PUSH 1 (natToWord WLen 64);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 65)] [PUSH 1 (natToWord WLen 63);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 64);DUP 2;DUP 1;PUSH 1 (natToWord WLen 65)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 66
 O: PUSH [tag] 66
*)
Example ERC721A_run_code_of_0_block_59_0: equiv_checker [PUSH 1 (natToWord WLen 66)] [PUSH 1 (natToWord WLen 66)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 67 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 68 SWAP2 SWAP1 PUSH [tag] 69
 O: PUSH [tag] 67 PUSH [tag] 68 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 69
*)
Example ERC721A_run_code_of_0_block_61_0: equiv_checker [PUSH 1 (natToWord WLen 67);PUSH 1 (natToWord WLen 68);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 69)] [PUSH 1 (natToWord WLen 67);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 68);DUP 2;DUP 1;PUSH 1 (natToWord WLen 69)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 70
 O: PUSH [tag] 70
*)
Example ERC721A_run_code_of_0_block_62_0: equiv_checker [PUSH 1 (natToWord WLen 70)] [PUSH 1 (natToWord WLen 70)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 71 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 72 SWAP2 SWAP1 PUSH [tag] 32
 O: PUSH [tag] 71 PUSH [tag] 72 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 32
*)
Example ERC721A_run_code_of_0_block_64_0: equiv_checker [PUSH 1 (natToWord WLen 71);PUSH 1 (natToWord WLen 72);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 32)] [PUSH 1 (natToWord WLen 71);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 72);DUP 2;DUP 1;PUSH 1 (natToWord WLen 32)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 73
 O: PUSH [tag] 73
*)
Example ERC721A_run_code_of_0_block_65_0: equiv_checker [PUSH 1 (natToWord WLen 73)] [PUSH 1 (natToWord WLen 73)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 74 SWAP2 SWAP1 PUSH [tag] 29
 O: PUSH [tag] 74 SWAP1 PUSH 40 MLOAD PUSH [tag] 29
*)
Example ERC721A_run_code_of_0_block_66_0: equiv_checker [PUSH 1 (natToWord WLen 74);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 29)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 74);DUP 2;DUP 1;PUSH 1 (natToWord WLen 29)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_67_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 75 PUSH 4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 PUSH [tag] 76 SWAP2 SWAP1 PUSH [tag] 77
 O: PUSH [tag] 75 PUSH [tag] 76 PUSH 4 DUP1 CALLDATASIZE SUB ADD PUSH 4 PUSH [tag] 77
*)
Example ERC721A_run_code_of_0_block_68_0: equiv_checker [PUSH 1 (natToWord WLen 75);PUSH 1 (natToWord WLen 76);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;Opcode ADD;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 77)] [PUSH 1 (natToWord WLen 75);PUSH 1 (natToWord WLen 4);DUP 1;Opcode CALLDATASIZE;Opcode SUB;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 76);DUP 2;DUP 1;PUSH 1 (natToWord WLen 77)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 78
 O: PUSH [tag] 78
*)
Example ERC721A_run_code_of_0_block_69_0: equiv_checker [PUSH 1 (natToWord WLen 78)] [PUSH 1 (natToWord WLen 78)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH [tag] 79 SWAP2 SWAP1 PUSH [tag] 25
 O: PUSH [tag] 79 SWAP1 PUSH 40 MLOAD PUSH [tag] 25
*)
Example ERC721A_run_code_of_0_block_70_0: equiv_checker [PUSH 1 (natToWord WLen 79);DUP 1;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 25)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 79);DUP 2;DUP 1;PUSH 1 (natToWord WLen 25)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_71_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 1FFC9A7 PUSH E0 SHL DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ DUP1 PUSH [tag] 81
 O: PUSH 0 PUSH 1ffc9a7 PUSH e0 SHL PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT DUP4 AND EQ DUP1 PUSH [tag] 81
*)
Example ERC721A_run_code_of_0_block_72_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 4 (natToWord WLen 33540519);PUSH 1 (natToWord WLen 224);Opcode SHL;PUSH 28 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249215);Opcode NOT;DUP 4;Opcode AND;Opcode EQ;DUP 1;PUSH 1 (natToWord WLen 81)] [PUSH 1 (natToWord WLen 0);PUSH 4 (natToWord WLen 33540519);PUSH 1 (natToWord WLen 224);Opcode SHL;DUP 3;PUSH 28 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249215);Opcode NOT;Opcode AND;Opcode EQ;DUP 1;PUSH 1 (natToWord WLen 81)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 80AC58CD PUSH E0 SHL DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ
 O: POP PUSH 80ac58cd PUSH e0 SHL DUP3 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT AND EQ
*)
Example ERC721A_run_code_of_0_block_73_0: equiv_checker [POP;PUSH 4 (natToWord WLen 2158778573);PUSH 1 (natToWord WLen 224);Opcode SHL;DUP 3;PUSH 28 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249215);Opcode NOT;Opcode AND;Opcode EQ] [POP;PUSH 4 (natToWord WLen 2158778573);PUSH 1 (natToWord WLen 224);Opcode SHL;DUP 3;PUSH 28 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249215);Opcode NOT;Opcode AND;Opcode EQ] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH [tag] 82
 O: DUP1 PUSH [tag] 82
*)
Example ERC721A_run_code_of_0_block_74_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 82)] [DUP 1;PUSH 1 (natToWord WLen 82)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 5B5E139F PUSH E0 SHL DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ
 O: POP PUSH 5b5e139f PUSH e0 SHL DUP3 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT AND EQ
*)
Example ERC721A_run_code_of_0_block_75_0: equiv_checker [POP;PUSH 4 (natToWord WLen 1532892063);PUSH 1 (natToWord WLen 224);Opcode SHL;DUP 3;PUSH 28 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249215);Opcode NOT;Opcode AND;Opcode EQ] [POP;PUSH 4 (natToWord WLen 1532892063);PUSH 1 (natToWord WLen 224);Opcode SHL;DUP 3;PUSH 28 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249215);Opcode NOT;Opcode AND;Opcode EQ] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example ERC721A_run_code_of_0_block_76_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 60 PUSH 2 DUP1 SLOAD PUSH [tag] 84 SWAP1 PUSH [tag] 85
 O: PUSH 60 PUSH 2 PUSH [tag] 84 DUP2 SLOAD PUSH [tag] 85
*)
Example ERC721A_run_code_of_0_block_77_0: equiv_checker [PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 2);PUSH 1 (natToWord WLen 84);DUP 2;Opcode SLOAD;PUSH 1 (natToWord WLen 85)] [PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 2);DUP 1;Opcode SLOAD;PUSH 1 (natToWord WLen 84);DUP 1;PUSH 1 (natToWord WLen 85)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Example ERC721A_run_code_of_0_block_78_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);DUP 1;PUSH 1 (natToWord WLen 31);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (natToWord WLen 64)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode ADD;PUSH 1 (natToWord WLen 32);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (natToWord WLen 64)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Example ERC721A_run_code_of_0_block_78_1: equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 86 SWAP1 PUSH [tag] 85
 O: PUSH 20 ADD DUP3 PUSH [tag] 86 DUP5 SLOAD PUSH [tag] 85
*)
Example ERC721A_run_code_of_0_block_78_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;PUSH 1 (natToWord WLen 86);DUP 5;Opcode SLOAD;PUSH 1 (natToWord WLen 85)] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (natToWord WLen 86);DUP 1;PUSH 1 (natToWord WLen 85)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 ISZERO PUSH [tag] 87
 O: DUP1 ISZERO PUSH [tag] 87
*)
Example ERC721A_run_code_of_0_block_79_0: equiv_checker [DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 87)] [DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 87)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 88
 O: DUP1 PUSH 1f LT PUSH [tag] 88
*)
Example ERC721A_run_code_of_0_block_80_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 1 (natToWord WLen 88)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 1 (natToWord WLen 88)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Example ERC721A_run_code_of_0_block_81_0: equiv_checker [PUSH 2 (natToWord WLen 256);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (natToWord WLen 256);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 87
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 87
*)
Example ERC721A_run_code_of_0_block_81_1: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 1 (natToWord WLen 87)] [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 1 (natToWord WLen 87)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Example ERC721A_run_code_of_0_block_82_0: equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 0)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 0)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Example ERC721A_run_code_of_0_block_82_1: equiv_checker [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Example ERC721A_run_code_of_0_block_83_0: equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 89
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 89
*)
Example ERC721A_run_code_of_0_block_83_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (natToWord WLen 89)] [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (natToWord WLen 89)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Example ERC721A_run_code_of_0_block_84_0: equiv_checker [PUSH 1 (natToWord WLen 31);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (natToWord WLen 31);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP POP SWAP1 POP SWAP1
 O: POP POP POP POP POP SWAP2 SWAP1 POP
*)
Example ERC721A_run_code_of_0_block_85_0: equiv_checker [POP;POP;POP;POP;POP;DUP 2;DUP 1;POP] [POP;POP;POP;POP;POP;DUP 1;POP;DUP 1] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 91 DUP3 PUSH [tag] 92
 O: PUSH 0 PUSH [tag] 91 DUP3 PUSH [tag] 92
*)
Example ERC721A_run_code_of_0_block_86_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 91);DUP 3;PUSH 1 (natToWord WLen 92)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 91);DUP 3;PUSH 1 (natToWord WLen 92)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 93
 O: PUSH [tag] 93
*)
Example ERC721A_run_code_of_0_block_87_0: equiv_checker [PUSH 1 (natToWord WLen 93)] [PUSH 1 (natToWord WLen 93)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH CF4700E400000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH cf4700e400000000000000000000000000000000000000000000000000000000 DUP2
*)
Example ERC721A_run_code_of_0_block_88_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 93754211945203247791024388466000925045829571609179897114057315550813419995136);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 93754211945203247791024388466000925045829571609179897114057315550813419995136);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_88_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 6 PUSH 0 DUP4 DUP2
 O: PUSH 6 PUSH 0 DUP4 DUP2
*)
Example ERC721A_run_code_of_0_block_89_0: equiv_checker [PUSH 1 (natToWord WLen 6);PUSH 1 (natToWord WLen 0);DUP 4;DUP 2] [PUSH 1 (natToWord WLen 6);PUSH 1 (natToWord WLen 0);DUP 4;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example ERC721A_run_code_of_0_block_89_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 ADD PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 SWAP2 POP ADD PUSH 0 SWAP1 DUP2 DUP1 PUSH 100 EXP SWAP4 POP KECCAK256 ADD SLOAD DIV PUSH ffffffffffffffffffffffffffffffffffffffff AND SWAP1
*)
Example ERC721A_run_code_of_0_block_89_2: equiv_checker [PUSH 1 (natToWord WLen 32);DUP 2;POP;Opcode ADD;PUSH 1 (natToWord WLen 0);DUP 1;DUP 2;DUP 1;PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 4;POP;Opcode KECCAK256;Opcode ADD;Opcode SLOAD;Opcode DIV;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 1] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);Opcode ADD;PUSH 1 (natToWord WLen 0);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 1;Opcode DIV;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 95 DUP3 PUSH [tag] 53
 O: PUSH 0 PUSH [tag] 95 DUP3 PUSH [tag] 53
*)
Example ERC721A_run_code_of_0_block_90_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 95);DUP 3;PUSH 1 (natToWord WLen 53)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 95);DUP 3;PUSH 1 (natToWord WLen 53)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP DUP1 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH [tag] 96 PUSH [tag] 97
 O: DUP1 SWAP2 POP PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH [tag] 96 PUSH [tag] 97
*)
Example ERC721A_run_code_of_0_block_91_0: equiv_checker [DUP 1;DUP 2;POP;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 97)] [DUP 1;POP;DUP 1;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 97)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ PUSH [tag] 98
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ PUSH [tag] 98
*)
Example ERC721A_run_code_of_0_block_92_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;PUSH 1 (natToWord WLen 98)] [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;PUSH 1 (natToWord WLen 98)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 99 DUP2 PUSH [tag] 100 PUSH [tag] 97
 O: PUSH [tag] 99 DUP2 PUSH [tag] 100 PUSH [tag] 97
*)
Example ERC721A_run_code_of_0_block_93_0: equiv_checker [PUSH 1 (natToWord WLen 99);DUP 2;PUSH 1 (natToWord WLen 100);PUSH 1 (natToWord WLen 97)] [PUSH 1 (natToWord WLen 99);DUP 2;PUSH 1 (natToWord WLen 100);PUSH 1 (natToWord WLen 97)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 78
 O: PUSH [tag] 78
*)
Example ERC721A_run_code_of_0_block_94_0: equiv_checker [PUSH 1 (natToWord WLen 78)] [PUSH 1 (natToWord WLen 78)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 101
 O: PUSH [tag] 101
*)
Example ERC721A_run_code_of_0_block_95_0: equiv_checker [PUSH 1 (natToWord WLen 101)] [PUSH 1 (natToWord WLen 101)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH CFB3B94200000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH cfb3b94200000000000000000000000000000000000000000000000000000000 DUP2
*)
Example ERC721A_run_code_of_0_block_96_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 93946303883762109474516413289859237398067474195984919031474412148749565427712);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 93946303883762109474516413289859237398067474195984919031474412148749565427712);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_96_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 PUSH 6 PUSH 0 DUP5 DUP2
 O: DUP3 PUSH 6 PUSH 0 DUP5 DUP2
*)
Example ERC721A_run_code_of_0_block_98_0: equiv_checker [DUP 3;PUSH 1 (natToWord WLen 6);PUSH 1 (natToWord WLen 0);DUP 5;DUP 2] [DUP 3;PUSH 1 (natToWord WLen 6);PUSH 1 (natToWord WLen 0);DUP 5;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example ERC721A_run_code_of_0_block_98_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 ADD PUSH 0 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF MUL NOT AND SWAP1 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND MUL OR SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 ADD PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 PUSH 100 EXP DUP3 SLOAD DUP2 DUP4 MUL NOT AND SWAP2 DUP5 AND MUL OR SWAP1
*)
Example ERC721A_run_code_of_0_block_98_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);Opcode ADD;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 3;Opcode SLOAD;DUP 2;DUP 4;Opcode MUL;Opcode NOT;Opcode AND;DUP 2;DUP 5;Opcode AND;Opcode MUL;Opcode OR;DUP 1] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);Opcode ADD;PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode MUL;Opcode NOT;Opcode AND;DUP 1;DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode MUL;Opcode OR;DUP 1] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP DUP2 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 8C5BE1E5EBEC7D5BD14F71427D1E84F3DD0314C0F7B2291E5B200AC8C7C3B925 PUSH 40 MLOAD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: POP PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 40 MLOAD DUP5 DUP3 AND PUSH 8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925 DUP3 DUP1 SUB DUP6 DUP8 SWAP6 AND SWAP3 SWAP4
*)
Example ERC721A_run_code_of_0_block_98_3: equiv_checker [POP;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 5;DUP 3;Opcode AND;PUSH 32 (natToWord WLen 63486140976153616755203102783360879283472101686154884697241723088393386309925);DUP 3;DUP 1;Opcode SUB;DUP 6;DUP 8;DUP 6;Opcode AND;DUP 3;DUP 4] [POP;DUP 2;DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 3;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 32 (natToWord WLen 63486140976153616755203102783360879283472101686154884697241723088393386309925);PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP
 O: POP POP POP
*)
Example ERC721A_run_code_of_0_block_98_4: equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 103 PUSH [tag] 104
 O: PUSH 0 PUSH [tag] 103 PUSH [tag] 104
*)
Example ERC721A_run_code_of_0_block_99_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 103);PUSH 1 (natToWord WLen 104)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 103);PUSH 1 (natToWord WLen 104)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 1 SLOAD PUSH 0 SLOAD SUB SUB SWAP1 POP SWAP1
 O: PUSH 1 SLOAD PUSH 0 SLOAD SUB SUB SWAP2 SWAP1 POP
*)
Example ERC721A_run_code_of_0_block_100_0: equiv_checker [PUSH 1 (natToWord WLen 1);Opcode SLOAD;PUSH 1 (natToWord WLen 0);Opcode SLOAD;Opcode SUB;Opcode SUB;DUP 2;DUP 1;POP] [PUSH 1 (natToWord WLen 1);Opcode SLOAD;PUSH 1 (natToWord WLen 0);Opcode SLOAD;Opcode SUB;Opcode SUB;DUP 1;POP;DUP 1] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 106 DUP3 PUSH [tag] 107
 O: PUSH 0 PUSH [tag] 106 DUP3 PUSH [tag] 107
*)
Example ERC721A_run_code_of_0_block_101_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 106);DUP 3;PUSH 1 (natToWord WLen 107)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 106);DUP 3;PUSH 1 (natToWord WLen 107)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ PUSH [tag] 108
 O: SWAP1 POP DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 AND EQ PUSH [tag] 108
*)
Example ERC721A_run_code_of_0_block_102_0: equiv_checker [DUP 1;POP;DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 3;Opcode AND;Opcode EQ;PUSH 1 (natToWord WLen 108)] [DUP 1;POP;DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;PUSH 1 (natToWord WLen 108)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH A114810000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH a114810000000000000000000000000000000000000000000000000000000000 DUP2
*)
Example ERC721A_run_code_of_0_block_103_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 72858595888480192197425434824141221654945492164620433336968169282127339192320);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 72858595888480192197425434824141221654945492164620433336968169282127339192320);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_103_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH [tag] 109 DUP5 PUSH [tag] 110
 O: PUSH 0 DUP1 PUSH [tag] 109 DUP5 PUSH [tag] 110
*)
Example ERC721A_run_code_of_0_block_104_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 109);DUP 5;PUSH 1 (natToWord WLen 110)] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 109);DUP 5;PUSH 1 (natToWord WLen 110)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP SWAP2 POP PUSH [tag] 111 DUP2 DUP8 PUSH [tag] 112 PUSH [tag] 97
 O: SWAP2 POP SWAP2 POP PUSH [tag] 111 DUP2 DUP8 PUSH [tag] 112 PUSH [tag] 97
*)
Example ERC721A_run_code_of_0_block_105_0: equiv_checker [DUP 2;POP;DUP 2;POP;PUSH 1 (natToWord WLen 111);DUP 2;DUP 8;PUSH 1 (natToWord WLen 112);PUSH 1 (natToWord WLen 97)] [DUP 2;POP;DUP 2;POP;PUSH 1 (natToWord WLen 111);DUP 2;DUP 8;PUSH 1 (natToWord WLen 112);PUSH 1 (natToWord WLen 97)] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 113
 O: PUSH [tag] 113
*)
Example ERC721A_run_code_of_0_block_106_0: equiv_checker [PUSH 1 (natToWord WLen 113)] [PUSH 1 (natToWord WLen 113)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 114
 O: PUSH [tag] 114
*)
Example ERC721A_run_code_of_0_block_107_0: equiv_checker [PUSH 1 (natToWord WLen 114)] [PUSH 1 (natToWord WLen 114)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 115 DUP7 PUSH [tag] 116 PUSH [tag] 97
 O: PUSH [tag] 115 DUP7 PUSH [tag] 116 PUSH [tag] 97
*)
Example ERC721A_run_code_of_0_block_108_0: equiv_checker [PUSH 1 (natToWord WLen 115);DUP 7;PUSH 1 (natToWord WLen 116);PUSH 1 (natToWord WLen 97)] [PUSH 1 (natToWord WLen 115);DUP 7;PUSH 1 (natToWord WLen 116);PUSH 1 (natToWord WLen 97)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 78
 O: PUSH [tag] 78
*)
Example ERC721A_run_code_of_0_block_109_0: equiv_checker [PUSH 1 (natToWord WLen 78)] [PUSH 1 (natToWord WLen 78)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 117
 O: PUSH [tag] 117
*)
Example ERC721A_run_code_of_0_block_110_0: equiv_checker [PUSH 1 (natToWord WLen 117)] [PUSH 1 (natToWord WLen 117)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 59C896BE00000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 59c896be00000000000000000000000000000000000000000000000000000000 DUP2
*)
Example ERC721A_run_code_of_0_block_111_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 40610253321208270774332185957187447255326585543192491974159042718829090177024);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 40610253321208270774332185957187447255326585543192491974159042718829090177024);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_111_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 118
 O: PUSH ffffffffffffffffffffffffffffffffffffffff PUSH 0 AND PUSH ffffffffffffffffffffffffffffffffffffffff DUP7 AND EQ ISZERO PUSH [tag] 118
*)
Example ERC721A_run_code_of_0_block_113_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);PUSH 1 (natToWord WLen 0);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 7;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 118)] [PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 6;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 118)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH EA553B3400000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH ea553b3400000000000000000000000000000000000000000000000000000000 DUP2
*)
Example ERC721A_run_code_of_0_block_114_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 105991797173942184882469161745347597715497421134232373703673558015659904860160);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 105991797173942184882469161745347597715497421134232373703673558015659904860160);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_114_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 119 DUP7 DUP7 DUP7 PUSH 1 PUSH [tag] 120
 O: PUSH [tag] 119 DUP7 DUP7 DUP7 PUSH 1 PUSH [tag] 120
*)
Example ERC721A_run_code_of_0_block_115_0: equiv_checker [PUSH 1 (natToWord WLen 119);DUP 7;DUP 7;DUP 7;PUSH 1 (natToWord WLen 1);PUSH 1 (natToWord WLen 120)] [PUSH 1 (natToWord WLen 119);DUP 7;DUP 7;DUP 7;PUSH 1 (natToWord WLen 1);PUSH 1 (natToWord WLen 120)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 ISZERO PUSH [tag] 121
 O: DUP1 ISZERO PUSH [tag] 121
*)
Example ERC721A_run_code_of_0_block_116_0: equiv_checker [DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 121)] [DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 121)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP3
 O: PUSH 0 DUP3
*)
Example ERC721A_run_code_of_0_block_117_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 3] [PUSH 1 (natToWord WLen 0);DUP 3] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 5 PUSH 0 DUP8 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 5 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP9 AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Example ERC721A_run_code_of_0_block_118_0: equiv_checker [PUSH 1 (natToWord WLen 5);PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 9;Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] [PUSH 1 (natToWord WLen 5);PUSH 1 (natToWord WLen 0);DUP 8;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example ERC721A_run_code_of_0_block_118_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP2 SLOAD PUSH 1 SWAP1 SUB SWAP2 SWAP1 POP DUP2 SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 1 DUP2 SLOAD SUB DUP1 SWAP2
*)
Example ERC721A_run_code_of_0_block_118_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 1);DUP 2;Opcode SLOAD;Opcode SUB;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);DUP 2;Opcode SLOAD;PUSH 1 (natToWord WLen 1);DUP 1;Opcode SUB;DUP 2;DUP 1;POP;DUP 2;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 5 PUSH 0 DUP7 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: POP PUSH 5 PUSH 0 DUP7 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Example ERC721A_run_code_of_0_block_118_3: equiv_checker [POP;PUSH 1 (natToWord WLen 5);PUSH 1 (natToWord WLen 0);DUP 7;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] [POP;PUSH 1 (natToWord WLen 5);PUSH 1 (natToWord WLen 0);DUP 7;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example ERC721A_run_code_of_0_block_118_4: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP2 SLOAD PUSH 1 ADD SWAP2 SWAP1 POP DUP2 SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 1 DUP2 SLOAD ADD DUP1 SWAP2
*)
Example ERC721A_run_code_of_0_block_118_5: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 1);DUP 2;Opcode SLOAD;Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);DUP 2;Opcode SLOAD;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 2;DUP 1;POP;DUP 2;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 122 DUP6 PUSH [tag] 123 DUP9 DUP9 DUP8 PUSH [tag] 124
 O: POP PUSH [tag] 122 DUP6 PUSH [tag] 123 DUP9 DUP3 DUP8 PUSH [tag] 124
*)
Example ERC721A_run_code_of_0_block_118_6: equiv_checker [POP;PUSH 1 (natToWord WLen 122);DUP 6;PUSH 1 (natToWord WLen 123);DUP 9;DUP 3;DUP 8;PUSH 1 (natToWord WLen 124)] [POP;PUSH 1 (natToWord WLen 122);DUP 6;PUSH 1 (natToWord WLen 123);DUP 9;DUP 9;DUP 8;PUSH 1 (natToWord WLen 124)] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 200000000000000000000000000000000000000000000000000000000 OR PUSH [tag] 125
 O: PUSH 200000000000000000000000000000000000000000000000000000000 OR PUSH [tag] 125
*)
Example ERC721A_run_code_of_0_block_119_0: equiv_checker [PUSH 29 (natToWord WLen 53919893334301279589334030174039261347274288845081144962207220498432);Opcode OR;PUSH 1 (natToWord WLen 125)] [PUSH 29 (natToWord WLen 53919893334301279589334030174039261347274288845081144962207220498432);Opcode OR;PUSH 1 (natToWord WLen 125)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 PUSH 0 DUP7 DUP2
 O: PUSH 4 PUSH 0 DUP7 DUP2
*)
Example ERC721A_run_code_of_0_block_120_0: equiv_checker [PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 7;DUP 2] [PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 7;DUP 2] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example ERC721A_run_code_of_0_block_120_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 DUP2 SWAP1
 O: DUP2 SWAP1 PUSH 20 ADD PUSH 0 KECCAK256
*)
Example ERC721A_run_code_of_0_block_120_2: equiv_checker [DUP 2;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 2;DUP 1] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 0 PUSH 200000000000000000000000000000000000000000000000000000000 DUP5 AND EQ ISZERO PUSH [tag] 126
 O: POP PUSH 200000000000000000000000000000000000000000000000000000000 DUP4 AND PUSH 0 EQ ISZERO PUSH [tag] 126
*)
Example ERC721A_run_code_of_0_block_120_3: equiv_checker [POP;PUSH 29 (natToWord WLen 53919893334301279589334030174039261347274288845081144962207220498432);DUP 4;Opcode AND;PUSH 1 (natToWord WLen 0);Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 126)] [POP;PUSH 1 (natToWord WLen 0);PUSH 29 (natToWord WLen 53919893334301279589334030174039261347274288845081144962207220498432);DUP 5;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 126)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 1 DUP6 ADD SWAP1 POP PUSH 0 PUSH 4 PUSH 0 DUP4 DUP2
 O: DUP4 PUSH 1 ADD PUSH 0 PUSH 4 DUP2 DUP4 DUP4
*)
Example ERC721A_run_code_of_0_block_121_0: equiv_checker [DUP 4;PUSH 1 (natToWord WLen 1);Opcode ADD;PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 4);DUP 2;DUP 4;DUP 4] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 1);DUP 6;Opcode ADD;DUP 1;POP;PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 4;DUP 2] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example ERC721A_run_code_of_0_block_121_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD EQ ISZERO PUSH [tag] 127
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD EQ ISZERO PUSH [tag] 127
*)
Example ERC721A_run_code_of_0_block_121_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 127)] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 127)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 SLOAD DUP2 EQ PUSH [tag] 128
 O: DUP1 PUSH 0 SLOAD EQ PUSH [tag] 128
*)
Example ERC721A_run_code_of_0_block_122_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 0);Opcode SLOAD;Opcode EQ;PUSH 1 (natToWord WLen 128)] [PUSH 1 (natToWord WLen 0);Opcode SLOAD;DUP 2;Opcode EQ;PUSH 1 (natToWord WLen 128)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP4 PUSH 4 PUSH 0 DUP4 DUP2
 O: DUP4 PUSH 4 PUSH 0 DUP4 DUP2
*)
Example ERC721A_run_code_of_0_block_123_0: equiv_checker [DUP 4;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 4;DUP 2] [DUP 4;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 4;DUP 2] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example ERC721A_run_code_of_0_block_123_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 DUP2 SWAP1
 O: DUP2 SWAP1 PUSH 20 ADD PUSH 0 KECCAK256
*)
Example ERC721A_run_code_of_0_block_123_2: equiv_checker [DUP 2;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 2;DUP 1] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example ERC721A_run_code_of_0_block_123_3: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example ERC721A_run_code_of_0_block_125_0: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP4 DUP6 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP8 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH DDF252AD1BE2C89B69C2B068FC378DAA952BA7F163C4A11628F55A4DF523B3EF PUSH 40 MLOAD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH ffffffffffffffffffffffffffffffffffffffff DUP1 DUP7 AND DUP8 PUSH 40 MLOAD SWAP3 AND PUSH ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef DUP4 DUP1 SUB DUP9 SWAP5
*)
Example ERC721A_run_code_of_0_block_126_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 1;DUP 7;Opcode AND;DUP 8;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 3;Opcode AND;PUSH 32 (natToWord WLen 100389287136786176327247604509743168900146139575972864366142685224231313322991);DUP 4;DUP 1;Opcode SUB;DUP 9;DUP 5] [DUP 4;DUP 6;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 8;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 32 (natToWord WLen 100389287136786176327247604509743168900146139575972864366142685224231313322991);PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 129 DUP7 DUP7 DUP7 PUSH 1 PUSH [tag] 130
 O: PUSH [tag] 129 DUP7 DUP7 DUP7 PUSH 1 PUSH [tag] 130
*)
Example ERC721A_run_code_of_0_block_126_1: equiv_checker [PUSH 1 (natToWord WLen 129);DUP 7;DUP 7;DUP 7;PUSH 1 (natToWord WLen 1);PUSH 1 (natToWord WLen 130)] [PUSH 1 (natToWord WLen 129);DUP 7;DUP 7;DUP 7;PUSH 1 (natToWord WLen 1);PUSH 1 (natToWord WLen 130)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP POP POP
 O: POP POP POP POP POP POP
*)
Example ERC721A_run_code_of_0_block_127_0: equiv_checker [POP;POP;POP;POP;POP;POP] [POP;POP;POP;POP;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 132 DUP4 DUP4 DUP4 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH [tag] 132 DUP4 DUP4 DUP4 PUSH 40 MLOAD PUSH 20 DUP2 ADD PUSH 40
*)
Example ERC721A_run_code_of_0_block_128_0: equiv_checker [PUSH 1 (natToWord WLen 132);DUP 4;DUP 4;DUP 4;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;PUSH 1 (natToWord WLen 64)] [PUSH 1 (natToWord WLen 132);DUP 4;DUP 4;DUP 4;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 0 DUP2
 O: DUP1 PUSH 0 DUP2
*)
Example ERC721A_run_code_of_0_block_128_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 0);DUP 2] [DUP 1;PUSH 1 (natToWord WLen 0);DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 70
 O: POP PUSH [tag] 70
*)
Example ERC721A_run_code_of_0_block_128_2: equiv_checker [POP;PUSH 1 (natToWord WLen 70)] [POP;PUSH 1 (natToWord WLen 70)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP
 O: POP POP POP
*)
Example ERC721A_run_code_of_0_block_129_0: equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 134 DUP3 PUSH [tag] 107
 O: PUSH 0 PUSH [tag] 134 DUP3 PUSH [tag] 107
*)
Example ERC721A_run_code_of_0_block_130_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 134);DUP 3;PUSH 1 (natToWord WLen 107)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 134);DUP 3;PUSH 1 (natToWord WLen 107)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example ERC721A_run_code_of_0_block_131_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 136
 O: PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 AND DUP2 PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ ISZERO PUSH [tag] 136
*)
Example ERC721A_run_code_of_0_block_132_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 3;Opcode AND;DUP 2;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 136)] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 3;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 136)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 8F4EB60400000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH 8f4eb60400000000000000000000000000000000000000000000000000000000 DUP2
*)
Example ERC721A_run_code_of_0_block_133_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 64819807644134710066304724416489703438357943037160469798164574604444221571072);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 64819807644134710066304724416489703438357943037160469798164574604444221571072);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_133_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH FFFFFFFFFFFFFFFF PUSH 5 PUSH 0 DUP5 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH ffffffffffffffff PUSH 5 PUSH 0 DUP5 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Example ERC721A_run_code_of_0_block_134_0: equiv_checker [PUSH 8 (natToWord WLen 18446744073709551615);PUSH 1 (natToWord WLen 5);PUSH 1 (natToWord WLen 0);DUP 5;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] [PUSH 8 (natToWord WLen 18446744073709551615);PUSH 1 (natToWord WLen 5);PUSH 1 (natToWord WLen 0);DUP 5;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example ERC721A_run_code_of_0_block_134_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND SWAP2 POP POP SWAP1
*)
Example ERC721A_run_code_of_0_block_134_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;Opcode AND;DUP 2;POP;POP;DUP 1] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 60 PUSH 3 DUP1 SLOAD PUSH [tag] 138 SWAP1 PUSH [tag] 85
 O: PUSH 60 PUSH 3 PUSH [tag] 138 DUP2 SLOAD PUSH [tag] 85
*)
Example ERC721A_run_code_of_0_block_135_0: equiv_checker [PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 3);PUSH 1 (natToWord WLen 138);DUP 2;Opcode SLOAD;PUSH 1 (natToWord WLen 85)] [PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 3);DUP 1;Opcode SLOAD;PUSH 1 (natToWord WLen 138);DUP 1;PUSH 1 (natToWord WLen 85)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F ADD PUSH 20 DUP1 SWAP2 DIV MUL PUSH 20 ADD PUSH 40 MLOAD SWAP1 DUP2 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 DUP1 PUSH 1f DUP6 ADD DIV DUP2 MUL ADD ADD PUSH 40
*)
Example ERC721A_run_code_of_0_block_136_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);DUP 1;PUSH 1 (natToWord WLen 31);DUP 6;Opcode ADD;Opcode DIV;DUP 2;Opcode MUL;Opcode ADD;Opcode ADD;PUSH 1 (natToWord WLen 64)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode ADD;PUSH 1 (natToWord WLen 32);DUP 1;DUP 2;Opcode DIV;Opcode MUL;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode ADD;PUSH 1 (natToWord WLen 64)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2
 O: SWAP2 SWAP1 DUP3 DUP2 DUP5
*)
Example ERC721A_run_code_of_0_block_136_1: equiv_checker [DUP 2;DUP 1;DUP 3;DUP 2;DUP 5] [DUP 1;DUP 3;DUP 2;DUP 1;DUP 2;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD DUP3 DUP1 SLOAD PUSH [tag] 139 SWAP1 PUSH [tag] 85
 O: PUSH 20 ADD DUP3 PUSH [tag] 139 DUP5 SLOAD PUSH [tag] 85
*)
Example ERC721A_run_code_of_0_block_136_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;PUSH 1 (natToWord WLen 139);DUP 5;Opcode SLOAD;PUSH 1 (natToWord WLen 85)] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 3;DUP 1;Opcode SLOAD;PUSH 1 (natToWord WLen 139);DUP 1;PUSH 1 (natToWord WLen 85)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 ISZERO PUSH [tag] 140
 O: DUP1 ISZERO PUSH [tag] 140
*)
Example ERC721A_run_code_of_0_block_137_0: equiv_checker [DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 140)] [DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 140)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 1F LT PUSH [tag] 141
 O: DUP1 PUSH 1f LT PUSH [tag] 141
*)
Example ERC721A_run_code_of_0_block_138_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 1 (natToWord WLen 141)] [DUP 1;PUSH 1 (natToWord WLen 31);Opcode LT;PUSH 1 (natToWord WLen 141)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
 O: PUSH 100 DUP1 DUP4 SLOAD DIV MUL DUP4
*)
Example ERC721A_run_code_of_0_block_139_0: equiv_checker [PUSH 2 (natToWord WLen 256);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] [PUSH 2 (natToWord WLen 256);DUP 1;DUP 4;Opcode SLOAD;Opcode DIV;Opcode MUL;DUP 4] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 140
 O: SWAP2 PUSH 20 ADD SWAP2 PUSH [tag] 140
*)
Example ERC721A_run_code_of_0_block_139_1: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 1 (natToWord WLen 140)] [DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 1 (natToWord WLen 140)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 ADD SWAP2 SWAP1 PUSH 0
 O: DUP3 ADD SWAP2 SWAP1 PUSH 0
*)
Example ERC721A_run_code_of_0_block_140_0: equiv_checker [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 0)] [DUP 3;Opcode ADD;DUP 2;DUP 1;PUSH 1 (natToWord WLen 0)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 PUSH 0 KECCAK256 SWAP1
 O: PUSH 20 PUSH 0 KECCAK256 SWAP1
*)
Example ERC721A_run_code_of_0_block_140_1: equiv_checker [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 SLOAD DUP2
 O: DUP2 SLOAD DUP2
*)
Example ERC721A_run_code_of_0_block_141_0: equiv_checker [DUP 2;Opcode SLOAD;DUP 2] [DUP 2;Opcode SLOAD;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 142
 O: SWAP1 PUSH 1 ADD SWAP1 PUSH 20 ADD DUP1 DUP4 GT PUSH [tag] 142
*)
Example ERC721A_run_code_of_0_block_141_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (natToWord WLen 142)] [DUP 1;PUSH 1 (natToWord WLen 1);Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 4;Opcode GT;PUSH 1 (natToWord WLen 142)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 SWAP1 SUB PUSH 1F AND DUP3 ADD SWAP2
 O: PUSH 1f DUP4 DUP5 SWAP3 SUB AND ADD SWAP2
*)
Example ERC721A_run_code_of_0_block_142_0: equiv_checker [PUSH 1 (natToWord WLen 31);DUP 4;DUP 5;DUP 3;Opcode SUB;Opcode AND;Opcode ADD;DUP 2] [DUP 3;DUP 1;Opcode SUB;PUSH 1 (natToWord WLen 31);Opcode AND;DUP 3;Opcode ADD;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP POP SWAP1 POP SWAP1
 O: POP POP POP POP POP SWAP2 SWAP1 POP
*)
Example ERC721A_run_code_of_0_block_143_0: equiv_checker [POP;POP;POP;POP;POP;DUP 2;DUP 1;POP] [POP;POP;POP;POP;POP;DUP 1;POP;DUP 1] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 144 PUSH [tag] 97
 O: PUSH [tag] 144 PUSH [tag] 97
*)
Example ERC721A_run_code_of_0_block_144_0: equiv_checker [PUSH 1 (natToWord WLen 144);PUSH 1 (natToWord WLen 97)] [PUSH 1 (natToWord WLen 144);PUSH 1 (natToWord WLen 97)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP3 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EQ ISZERO PUSH [tag] 145
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP3 PUSH ffffffffffffffffffffffffffffffffffffffff AND EQ ISZERO PUSH [tag] 145
*)
Example ERC721A_run_code_of_0_block_145_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 3;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 145)] [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 3;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 145)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH B06307DB00000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH b06307db00000000000000000000000000000000000000000000000000000000 DUP2
*)
Example ERC721A_run_code_of_0_block_146_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 79782033426520692042270425721413825578667320047716007783072387518728457158656);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 79782033426520692042270425721413825578667320047716007783072387518728457158656);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_146_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 7 PUSH 0 PUSH [tag] 146 PUSH [tag] 97
 O: DUP1 PUSH 7 PUSH 0 PUSH [tag] 146 PUSH [tag] 97
*)
Example ERC721A_run_code_of_0_block_147_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 7);PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 146);PUSH 1 (natToWord WLen 97)] [DUP 1;PUSH 1 (natToWord WLen 7);PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 146);PUSH 1 (natToWord WLen 97)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Example ERC721A_run_code_of_0_block_148_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example ERC721A_run_code_of_0_block_148_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP5 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP1 DUP7 AND AND DUP2
*)
Example ERC721A_run_code_of_0_block_148_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 1;DUP 7;Opcode AND;Opcode AND;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);DUP 5;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example ERC721A_run_code_of_0_block_148_3: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH 100 EXP DUP2 SLOAD DUP2 PUSH FF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH 100 EXP PUSH ff DUP2 DUP5 ISZERO ISZERO MUL SWAP2 MUL NOT DUP3 SLOAD AND OR SWAP1
*)
Example ERC721A_run_code_of_0_block_148_4: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 256);Opcode EXP;PUSH 1 (natToWord WLen 255);DUP 2;DUP 5;Opcode ISZERO;Opcode ISZERO;Opcode MUL;DUP 2;Opcode MUL;Opcode NOT;DUP 3;Opcode SLOAD;Opcode AND;Opcode OR;DUP 1] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 2;Opcode SLOAD;DUP 2;PUSH 1 (natToWord WLen 255);Opcode MUL;Opcode NOT;Opcode AND;DUP 1;DUP 4;Opcode ISZERO;Opcode ISZERO;Opcode MUL;Opcode OR;DUP 1] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH [tag] 147 PUSH [tag] 97
 O: POP PUSH ffffffffffffffffffffffffffffffffffffffff DUP3 AND PUSH [tag] 147 PUSH [tag] 97
*)
Example ERC721A_run_code_of_0_block_148_5: equiv_checker [POP;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 3;Opcode AND;PUSH 1 (natToWord WLen 147);PUSH 1 (natToWord WLen 97)] [POP;DUP 2;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 1 (natToWord WLen 147);PUSH 1 (natToWord WLen 97)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 17307EAB39AB6107E8899845AD3D59BD9653F200F220920489CA2B5937696C31 DUP4 PUSH 40 MLOAD PUSH [tag] 148 SWAP2 SWAP1 PUSH [tag] 25
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH 17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31 PUSH [tag] 148 DUP5 PUSH 40 MLOAD PUSH [tag] 25
*)
Example ERC721A_run_code_of_0_block_149_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 32 (natToWord WLen 10488878412788366941768124514102328501031624832915735463117339209566108871729);PUSH 1 (natToWord WLen 148);DUP 5;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 25)] [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 32 (natToWord WLen 10488878412788366941768124514102328501031624832915735463117339209566108871729);DUP 4;PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 148);DUP 2;DUP 1;PUSH 1 (natToWord WLen 25)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_150_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example ERC721A_run_code_of_0_block_150_1: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 150 DUP5 DUP5 DUP5 PUSH [tag] 47
 O: PUSH [tag] 150 DUP5 DUP5 DUP5 PUSH [tag] 47
*)
Example ERC721A_run_code_of_0_block_151_0: equiv_checker [PUSH 1 (natToWord WLen 150);DUP 5;DUP 5;DUP 5;PUSH 1 (natToWord WLen 47)] [PUSH 1 (natToWord WLen 150);DUP 5;DUP 5;DUP 5;PUSH 1 (natToWord WLen 47)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND EXTCODESIZE EQ PUSH [tag] 151
 O: PUSH 0 DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff AND EXTCODESIZE EQ PUSH [tag] 151
*)
Example ERC721A_run_code_of_0_block_152_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EXTCODESIZE;Opcode EQ;PUSH 1 (natToWord WLen 151)] [PUSH 1 (natToWord WLen 0);DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode EXTCODESIZE;Opcode EQ;PUSH 1 (natToWord WLen 151)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 152 DUP5 DUP5 DUP5 DUP5 PUSH [tag] 153
 O: PUSH [tag] 152 DUP5 DUP5 DUP5 DUP5 PUSH [tag] 153
*)
Example ERC721A_run_code_of_0_block_153_0: equiv_checker [PUSH 1 (natToWord WLen 152);DUP 5;DUP 5;DUP 5;DUP 5;PUSH 1 (natToWord WLen 153)] [PUSH 1 (natToWord WLen 152);DUP 5;DUP 5;DUP 5;DUP 5;PUSH 1 (natToWord WLen 153)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 154
 O: PUSH [tag] 154
*)
Example ERC721A_run_code_of_0_block_154_0: equiv_checker [PUSH 1 (natToWord WLen 154)] [PUSH 1 (natToWord WLen 154)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH D1A57ED600000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH d1a57ed600000000000000000000000000000000000000000000000000000000 DUP2
*)
Example ERC721A_run_code_of_0_block_155_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 94825790509059390965680126405351569353353206259496993755816944651398402801664);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 94825790509059390965680126405351569353353206259496993755816944651398402801664);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_155_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Example ERC721A_run_code_of_0_block_157_0: equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 60 PUSH [tag] 156 DUP3 PUSH [tag] 92
 O: PUSH 60 PUSH [tag] 156 DUP3 PUSH [tag] 92
*)
Example ERC721A_run_code_of_0_block_158_0: equiv_checker [PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 156);DUP 3;PUSH 1 (natToWord WLen 92)] [PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 156);DUP 3;PUSH 1 (natToWord WLen 92)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 157
 O: PUSH [tag] 157
*)
Example ERC721A_run_code_of_0_block_159_0: equiv_checker [PUSH 1 (natToWord WLen 157)] [PUSH 1 (natToWord WLen 157)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH A14C4B5000000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH a14c4b5000000000000000000000000000000000000000000000000000000000 DUP2
*)
Example ERC721A_run_code_of_0_block_160_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 72957168786600788401488761580727469094027852793932524600994798941380460675072);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 72957168786600788401488761580727469094027852793932524600994798941380460675072);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_160_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 158 PUSH [tag] 159
 O: PUSH 0 PUSH [tag] 158 PUSH [tag] 159
*)
Example ERC721A_run_code_of_0_block_161_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 158);PUSH 1 (natToWord WLen 159)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 158);PUSH 1 (natToWord WLen 159)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP PUSH 0 DUP2 MLOAD EQ ISZERO PUSH [tag] 160
 O: SWAP1 POP PUSH 0 DUP2 MLOAD EQ ISZERO PUSH [tag] 160
*)
Example ERC721A_run_code_of_0_block_162_0: equiv_checker [DUP 1;POP;PUSH 1 (natToWord WLen 0);DUP 2;Opcode MLOAD;Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 160)] [DUP 1;POP;PUSH 1 (natToWord WLen 0);DUP 2;Opcode MLOAD;Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 160)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
*)
Example ERC721A_run_code_of_0_block_163_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 0 DUP2
 O: DUP1 PUSH 0 DUP2
*)
Example ERC721A_run_code_of_0_block_163_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 0);DUP 2] [DUP 1;PUSH 1 (natToWord WLen 0);DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH [tag] 161
 O: POP PUSH [tag] 161
*)
Example ERC721A_run_code_of_0_block_163_2: equiv_checker [POP;PUSH 1 (natToWord WLen 161)] [POP;PUSH 1 (natToWord WLen 161)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH [tag] 162 DUP5 PUSH [tag] 163
 O: DUP1 PUSH [tag] 162 DUP5 PUSH [tag] 163
*)
Example ERC721A_run_code_of_0_block_164_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 162);DUP 5;PUSH 1 (natToWord WLen 163)] [DUP 1;PUSH 1 (natToWord WLen 162);DUP 5;PUSH 1 (natToWord WLen 163)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 20 ADD PUSH [tag] 164 SWAP3 SWAP2 SWAP1 PUSH [tag] 165
 O: PUSH [tag] 164 SWAP2 SWAP1 PUSH 20 PUSH 40 MLOAD ADD PUSH [tag] 165
*)
Example ERC721A_run_code_of_0_block_165_0: equiv_checker [PUSH 1 (natToWord WLen 164);DUP 2;DUP 1;PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 64);Opcode MLOAD;Opcode ADD;PUSH 1 (natToWord WLen 165)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 164);DUP 3;DUP 2;DUP 1;PUSH 1 (natToWord WLen 165)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH 20 DUP2 DUP4 SUB SUB DUP2
 O: PUSH 40 MLOAD PUSH 20 DUP2 DUP4 SUB SUB DUP2
*)
Example ERC721A_run_code_of_0_block_166_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 32);DUP 2;DUP 4;Opcode SUB;Opcode SUB;DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 1 (natToWord WLen 32);DUP 2;DUP 4;Opcode SUB;Opcode SUB;DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 PUSH 40
 O: SWAP1 PUSH 40
*)
Example ERC721A_run_code_of_0_block_166_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 64)] [DUP 1;PUSH 1 (natToWord WLen 64)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP2 SWAP1 POP
 O: SWAP4 SWAP3 POP POP POP
*)
Example ERC721A_run_code_of_0_block_167_0: equiv_checker [DUP 4;DUP 3;POP;POP;POP] [DUP 2;POP;POP;DUP 2;DUP 1;POP] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 7 PUSH 0 DUP5 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 0 PUSH 7 DUP2 DUP5 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP2
*)
Example ERC721A_run_code_of_0_block_168_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 7);DUP 2;DUP 5;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 7);PUSH 1 (natToWord WLen 0);DUP 5;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example ERC721A_run_code_of_0_block_168_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND DUP2
 O: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 PUSH ffffffffffffffffffffffffffffffffffffffff DUP5 DUP2 AND AND DUP2
*)
Example ERC721A_run_code_of_0_block_168_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 5;DUP 2;Opcode AND;Opcode AND;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example ERC721A_run_code_of_0_block_168_3: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 PUSH 0 SWAP1 SLOAD SWAP1 PUSH 100 EXP SWAP1 DIV PUSH FF AND SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP2 PUSH 0 SWAP4 POP POP POP PUSH 20 ADD DUP2 PUSH 100 EXP SWAP2 KECCAK256 SLOAD DIV PUSH ff AND SWAP1
*)
Example ERC721A_run_code_of_0_block_168_4: equiv_checker [DUP 2;PUSH 1 (natToWord WLen 0);DUP 4;POP;POP;POP;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 2;Opcode KECCAK256;Opcode SLOAD;Opcode DIV;PUSH 1 (natToWord WLen 255);Opcode AND;DUP 1] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;PUSH 1 (natToWord WLen 0);DUP 1;Opcode SLOAD;DUP 1;PUSH 2 (natToWord WLen 256);Opcode EXP;DUP 1;Opcode DIV;PUSH 1 (natToWord WLen 255);Opcode AND;DUP 1;POP;DUP 3;DUP 2;POP;POP] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 PUSH [tag] 168 PUSH [tag] 104
 O: PUSH 0 DUP2 PUSH [tag] 168 PUSH [tag] 104
*)
Example ERC721A_run_code_of_0_block_169_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 2;PUSH 1 (natToWord WLen 168);PUSH 1 (natToWord WLen 104)] [PUSH 1 (natToWord WLen 0);DUP 2;PUSH 1 (natToWord WLen 168);PUSH 1 (natToWord WLen 104)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: GT ISZERO DUP1 ISZERO PUSH [tag] 169
 O: GT ISZERO DUP1 ISZERO PUSH [tag] 169
*)
Example ERC721A_run_code_of_0_block_170_0: equiv_checker [Opcode GT;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 169)] [Opcode GT;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 169)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 0 SLOAD DUP3 LT
 O: POP PUSH 0 SLOAD DUP3 LT
*)
Example ERC721A_run_code_of_0_block_171_0: equiv_checker [POP;PUSH 1 (natToWord WLen 0);Opcode SLOAD;DUP 3;Opcode LT] [POP;PUSH 1 (natToWord WLen 0);Opcode SLOAD;DUP 3;Opcode LT] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 ISZERO PUSH [tag] 170
 O: DUP1 ISZERO PUSH [tag] 170
*)
Example ERC721A_run_code_of_0_block_172_0: equiv_checker [DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 170)] [DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 170)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 PUSH 4 PUSH 0 DUP6 DUP2
 O: POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 PUSH 4 DUP3 DUP6 DUP2
*)
Example ERC721A_run_code_of_0_block_173_0: equiv_checker [POP;PUSH 1 (natToWord WLen 0);PUSH 29 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249216);PUSH 1 (natToWord WLen 4);DUP 3;DUP 6;DUP 2] [POP;PUSH 1 (natToWord WLen 0);PUSH 29 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249216);PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 6;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example ERC721A_run_code_of_0_block_173_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND EQ
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD AND EQ
*)
Example ERC721A_run_code_of_0_block_173_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;Opcode AND;Opcode EQ] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;Opcode AND;Opcode EQ] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example ERC721A_run_code_of_0_block_174_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 CALLER SWAP1 POP SWAP1
 O: CALLER SWAP1
*)
Example ERC721A_run_code_of_0_block_175_0: equiv_checker [Opcode CALLER;DUP 1] [PUSH 1 (natToWord WLen 0);Opcode CALLER;DUP 1;POP;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 SWAP1
 O: PUSH 0 SWAP1
*)
Example ERC721A_run_code_of_0_block_176_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 DUP3 SWAP1 POP DUP1 PUSH [tag] 174 PUSH [tag] 104
 O: PUSH 0 DUP2 DUP1 PUSH [tag] 174 PUSH [tag] 104
*)
Example ERC721A_run_code_of_0_block_177_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 2;DUP 1;PUSH 1 (natToWord WLen 174);PUSH 1 (natToWord WLen 104)] [PUSH 1 (natToWord WLen 0);DUP 1;DUP 3;DUP 1;POP;DUP 1;PUSH 1 (natToWord WLen 174);PUSH 1 (natToWord WLen 104)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: GT PUSH [tag] 175
 O: GT PUSH [tag] 175
*)
Example ERC721A_run_code_of_0_block_178_0: equiv_checker [Opcode GT;PUSH 1 (natToWord WLen 175)] [Opcode GT;PUSH 1 (natToWord WLen 175)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 SLOAD DUP2 LT ISZERO PUSH [tag] 176
 O: PUSH 0 SLOAD DUP2 LT ISZERO PUSH [tag] 176
*)
Example ERC721A_run_code_of_0_block_179_0: equiv_checker [PUSH 1 (natToWord WLen 0);Opcode SLOAD;DUP 2;Opcode LT;Opcode ISZERO;PUSH 1 (natToWord WLen 176)] [PUSH 1 (natToWord WLen 0);Opcode SLOAD;DUP 2;Opcode LT;Opcode ISZERO;PUSH 1 (natToWord WLen 176)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 4 PUSH 0 DUP4 DUP2
 O: PUSH 0 PUSH 4 DUP2 DUP4 DUP2
*)
Example ERC721A_run_code_of_0_block_180_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 4);DUP 2;DUP 4;DUP 2] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 4;DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example ERC721A_run_code_of_0_block_180_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD SWAP1 POP PUSH 0 PUSH 100000000000000000000000000000000000000000000000000000000 DUP3 AND EQ ISZERO PUSH [tag] 177
 O: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD PUSH 100000000000000000000000000000000000000000000000000000000 DUP2 SWAP3 POP AND PUSH 0 EQ ISZERO PUSH [tag] 177
*)
Example ERC721A_run_code_of_0_block_180_2: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;PUSH 29 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249216);DUP 2;DUP 3;POP;Opcode AND;PUSH 1 (natToWord WLen 0);Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 177)] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;DUP 1;POP;PUSH 1 (natToWord WLen 0);PUSH 29 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249216);DUP 3;Opcode AND;Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 177)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 EQ ISZERO PUSH [tag] 179
 O: DUP1 PUSH 0 EQ ISZERO PUSH [tag] 179
*)
Example ERC721A_run_code_of_0_block_181_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 0);Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 179)] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 179)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 PUSH 0 DUP4 PUSH 1 SWAP1 SUB SWAP4 POP DUP4 DUP2
 O: PUSH 1 PUSH 4 SWAP3 SUB SWAP2 PUSH 0 DUP4 DUP2
*)
Example ERC721A_run_code_of_0_block_182_0: equiv_checker [PUSH 1 (natToWord WLen 1);PUSH 1 (natToWord WLen 4);DUP 3;Opcode SUB;DUP 2;PUSH 1 (natToWord WLen 0);DUP 4;DUP 2] [PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 0);DUP 4;PUSH 1 (natToWord WLen 1);DUP 1;Opcode SUB;DUP 4;POP;DUP 4;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example ERC721A_run_code_of_0_block_182_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SLOAD SWAP1 POP PUSH [tag] 178
 O: SWAP1 POP PUSH 20 ADD PUSH 0 KECCAK256 SLOAD PUSH [tag] 178
*)
Example ERC721A_run_code_of_0_block_182_2: equiv_checker [DUP 1;POP;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;PUSH 1 (natToWord WLen 178)] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;Opcode SLOAD;DUP 1;POP;PUSH 1 (natToWord WLen 178)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 SWAP3 POP POP POP PUSH [tag] 173
 O: SWAP2 POP POP PUSH [tag] 173
*)
Example ERC721A_run_code_of_0_block_183_0: equiv_checker [DUP 2;POP;POP;PUSH 1 (natToWord WLen 173)] [DUP 1;DUP 3;POP;POP;POP;PUSH 1 (natToWord WLen 173)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example ERC721A_run_code_of_0_block_184_0: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH DF2D9B4200000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH df2d9b4200000000000000000000000000000000000000000000000000000000 DUP2
*)
Example ERC721A_run_code_of_0_block_186_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 100946344902023664471411814945126812247012391862136956231955561042544211001344);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 100946344902023664471411814945126812247012391862136956231955561042544211001344);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_186_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Example ERC721A_run_code_of_0_block_187_0: equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH 0 PUSH 6 PUSH 0 DUP6 DUP2
 O: PUSH 0 DUP1 DUP1 PUSH 6 DUP2 DUP6 DUP2
*)
Example ERC721A_run_code_of_0_block_188_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;DUP 1;PUSH 1 (natToWord WLen 6);DUP 2;DUP 6;DUP 2] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 6);PUSH 1 (natToWord WLen 0);DUP 6;DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD SWAP1 DUP2
 O: PUSH 20 ADD SWAP1 DUP2
*)
Example ERC721A_run_code_of_0_block_188_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;DUP 2] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 ADD PUSH 0 KECCAK256 SWAP1 POP DUP1 SWAP3 POP DUP3 SLOAD SWAP2 POP POP SWAP2 POP SWAP2
 O: SWAP1 POP SWAP2 POP SWAP2 POP PUSH 20 ADD SWAP1 POP PUSH 0 KECCAK256 SWAP1 DUP2 SLOAD SWAP1
*)
Example ERC721A_run_code_of_0_block_188_2: equiv_checker [DUP 1;POP;DUP 2;POP;DUP 2;POP;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 1;POP;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1;DUP 2;Opcode SLOAD;DUP 1] [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 0);Opcode KECCAK256;DUP 1;POP;DUP 1;DUP 3;POP;DUP 3;Opcode SLOAD;DUP 2;POP;POP;DUP 2;POP;DUP 2] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP4 AND SWAP3 POP PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP3 AND SWAP2 POP DUP4 DUP3 EQ DUP4 DUP4 EQ OR SWAP1 POP SWAP4 SWAP3 POP POP POP
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND DUP1 DUP2 SWAP3 SWAP3 DUP5 EQ SWAP4 POP SWAP3 DUP5 SWAP3 PUSH ffffffffffffffffffffffffffffffffffffffff AND SWAP3 POP SWAP3 POP EQ OR SWAP1
*)
Example ERC721A_run_code_of_0_block_189_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 1;DUP 2;DUP 3;DUP 3;DUP 5;Opcode EQ;DUP 4;POP;DUP 3;DUP 5;DUP 3;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 3;POP;DUP 3;POP;Opcode EQ;Opcode OR;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 4;Opcode AND;DUP 3;POP;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 3;Opcode AND;DUP 2;POP;DUP 4;DUP 3;Opcode EQ;DUP 4;DUP 4;Opcode EQ;Opcode OR;DUP 1;POP;DUP 4;DUP 3;POP;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Example ERC721A_run_code_of_0_block_190_0: equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH E8 DUP4 SWAP1 SHR SWAP1 POP PUSH E8 PUSH [tag] 184 DUP7 DUP7 DUP5 PUSH [tag] 185
 O: PUSH 0 PUSH [tag] 185 PUSH e8 PUSH [tag] 184 DUP7 DUP7 DUP7 DUP5 SHR DUP1 SWAP6
*)
Example ERC721A_run_code_of_0_block_191_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 185);PUSH 1 (natToWord WLen 232);PUSH 1 (natToWord WLen 184);DUP 7;DUP 7;DUP 7;DUP 5;Opcode SHR;DUP 1;DUP 6] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 232);DUP 4;DUP 1;Opcode SHR;DUP 1;POP;PUSH 1 (natToWord WLen 232);PUSH 1 (natToWord WLen 184);DUP 7;DUP 7;DUP 5;PUSH 1 (natToWord WLen 185)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH FFFFFF AND SWAP1 SHL SWAP2 POP POP SWAP4 SWAP3 POP POP POP
 O: PUSH ffffff AND SWAP6 POP SWAP4 POP POP POP POP SHL SWAP1
*)
Example ERC721A_run_code_of_0_block_192_0: equiv_checker [PUSH 3 (natToWord WLen 16777215);Opcode AND;DUP 6;POP;DUP 4;POP;POP;POP;POP;Opcode SHL;DUP 1] [PUSH 3 (natToWord WLen 16777215);Opcode AND;DUP 1;Opcode SHL;DUP 2;POP;POP;DUP 4;DUP 3;POP;POP;POP] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP4 AND SWAP3 POP DUP2 TIMESTAMP PUSH A0 SHL OR DUP4 OR SWAP1 POP SWAP3 SWAP2 POP POP
 O: TIMESTAMP PUSH a0 SHL OR SWAP1 PUSH ffffffffffffffffffffffffffffffffffffffff AND OR SWAP1
*)
Example ERC721A_run_code_of_0_block_193_0: equiv_checker [Opcode TIMESTAMP;PUSH 1 (natToWord WLen 160);Opcode SHL;Opcode OR;DUP 1;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;Opcode OR;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 4;Opcode AND;DUP 3;POP;DUP 2;Opcode TIMESTAMP;PUSH 1 (natToWord WLen 160);Opcode SHL;Opcode OR;DUP 4;Opcode OR;DUP 1;POP;DUP 3;DUP 2;POP;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Example ERC721A_run_code_of_0_block_194_0: equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP4 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH 150B7A02 PUSH [tag] 189 PUSH [tag] 97
 O: PUSH 0 DUP4 PUSH ffffffffffffffffffffffffffffffffffffffff AND PUSH 150b7a02 PUSH [tag] 189 PUSH [tag] 97
*)
Example ERC721A_run_code_of_0_block_195_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 4 (natToWord WLen 353073666);PUSH 1 (natToWord WLen 189);PUSH 1 (natToWord WLen 97)] [PUSH 1 (natToWord WLen 0);DUP 4;PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;PUSH 4 (natToWord WLen 353073666);PUSH 1 (natToWord WLen 189);PUSH 1 (natToWord WLen 97)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP8 DUP7 DUP7 PUSH 40 MLOAD DUP6 PUSH FFFFFFFF AND PUSH E0 SHL DUP2
 O: DUP8 DUP7 DUP7 PUSH 40 MLOAD DUP6 PUSH ffffffff AND PUSH e0 SHL DUP2
*)
Example ERC721A_run_code_of_0_block_196_0: equiv_checker [DUP 8;DUP 7;DUP 7;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 6;PUSH 4 (natToWord WLen 4294967295);Opcode AND;PUSH 1 (natToWord WLen 224);Opcode SHL;DUP 2] [DUP 8;DUP 7;DUP 7;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 6;PUSH 4 (natToWord WLen 4294967295);Opcode AND;PUSH 1 (natToWord WLen 224);Opcode SHL;DUP 2] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH [tag] 190 SWAP5 SWAP4 SWAP3 SWAP2 SWAP1 PUSH [tag] 191
 O: SWAP3 SWAP2 SWAP1 PUSH 4 PUSH [tag] 190 SWAP6 SWAP5 ADD PUSH [tag] 191
*)
Example ERC721A_run_code_of_0_block_196_1: equiv_checker [DUP 3;DUP 2;DUP 1;PUSH 1 (natToWord WLen 4);PUSH 1 (natToWord WLen 190);DUP 6;DUP 5;Opcode ADD;PUSH 1 (natToWord WLen 191)] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 190);DUP 5;DUP 4;DUP 3;DUP 2;DUP 1;PUSH 1 (natToWord WLen 191)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP1 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 192
 O: PUSH 20 PUSH 40 MLOAD DUP1 DUP4 SUB DUP2 PUSH 0 DUP8 DUP9 EXTCODESIZE ISZERO DUP1 ISZERO PUSH [tag] 192
*)
Example ERC721A_run_code_of_0_block_197_0: equiv_checker [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (natToWord WLen 0);DUP 8;DUP 9;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 192)] [PUSH 1 (natToWord WLen 32);PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 4;Opcode SUB;DUP 2;PUSH 1 (natToWord WLen 0);DUP 8;DUP 1;Opcode EXTCODESIZE;Opcode ISZERO;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 192)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example ERC721A_run_code_of_0_block_198_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP GAS
 O: POP GAS
*)
Example ERC721A_run_code_of_0_block_199_0: equiv_checker [POP;Opcode GAS] [POP;Opcode GAS] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP POP POP DUP1 ISZERO PUSH [tag] 193
 O: SWAP3 POP POP POP DUP1 ISZERO PUSH [tag] 193
*)
Example ERC721A_run_code_of_0_block_199_1: equiv_checker [DUP 3;POP;POP;POP;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 193)] [DUP 3;POP;POP;POP;DUP 1;Opcode ISZERO;PUSH 1 (natToWord WLen 193)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 40 MLOAD RETURNDATASIZE PUSH 1F NOT PUSH 1F DUP3 ADD AND DUP3 ADD DUP1 PUSH 40
 O: POP PUSH 40 MLOAD RETURNDATASIZE PUSH 1f NOT PUSH 1f DUP3 ADD AND DUP3 ADD DUP1 PUSH 40
*)
Example ERC721A_run_code_of_0_block_200_0: equiv_checker [POP;PUSH 1 (natToWord WLen 64);Opcode MLOAD;Opcode RETURNDATASIZE;PUSH 1 (natToWord WLen 31);Opcode NOT;PUSH 1 (natToWord WLen 31);DUP 3;Opcode ADD;Opcode AND;DUP 3;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 64)] [POP;PUSH 1 (natToWord WLen 64);Opcode MLOAD;Opcode RETURNDATASIZE;PUSH 1 (natToWord WLen 31);Opcode NOT;PUSH 1 (natToWord WLen 31);DUP 3;Opcode ADD;Opcode AND;DUP 3;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 64)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP DUP2 ADD SWAP1 PUSH [tag] 194 SWAP2 SWAP1 PUSH [tag] 195
 O: POP DUP2 ADD PUSH [tag] 194 SWAP2 PUSH [tag] 195
*)
Example ERC721A_run_code_of_0_block_200_1: equiv_checker [POP;DUP 2;Opcode ADD;PUSH 1 (natToWord WLen 194);DUP 2;PUSH 1 (natToWord WLen 195)] [POP;DUP 2;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 194);DUP 2;DUP 1;PUSH 1 (natToWord WLen 195)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 1
 O: PUSH 1
*)
Example ERC721A_run_code_of_0_block_201_0: equiv_checker [PUSH 1 (natToWord WLen 1)] [PUSH 1 (natToWord WLen 1)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 196
 O: PUSH [tag] 196
*)
Example ERC721A_run_code_of_0_block_202_0: equiv_checker [PUSH 1 (natToWord WLen 196)] [PUSH 1 (natToWord WLen 196)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: RETURNDATASIZE DUP1 PUSH 0 DUP2 EQ PUSH [tag] 201
 O: RETURNDATASIZE DUP1 DUP2 PUSH 0 EQ PUSH [tag] 201
*)
Example ERC721A_run_code_of_0_block_203_0: equiv_checker [Opcode RETURNDATASIZE;DUP 1;DUP 2;PUSH 1 (natToWord WLen 0);Opcode EQ;PUSH 1 (natToWord WLen 201)] [Opcode RETURNDATASIZE;DUP 1;PUSH 1 (natToWord WLen 0);DUP 2;Opcode EQ;PUSH 1 (natToWord WLen 201)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD SWAP2 POP PUSH 1F NOT PUSH 3F RETURNDATASIZE ADD AND DUP3 ADD PUSH 40
 O: PUSH 1f PUSH 40 MLOAD SWAP3 POP NOT RETURNDATASIZE PUSH 3f ADD AND DUP3 ADD PUSH 40
*)
Example ERC721A_run_code_of_0_block_204_0: equiv_checker [PUSH 1 (natToWord WLen 31);PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 3;POP;Opcode NOT;Opcode RETURNDATASIZE;PUSH 1 (natToWord WLen 63);Opcode ADD;Opcode AND;DUP 3;Opcode ADD;PUSH 1 (natToWord WLen 64)] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 2;POP;PUSH 1 (natToWord WLen 31);Opcode NOT;PUSH 1 (natToWord WLen 63);Opcode RETURNDATASIZE;Opcode ADD;Opcode AND;DUP 3;Opcode ADD;PUSH 1 (natToWord WLen 64)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: RETURNDATASIZE DUP3
 O: RETURNDATASIZE DUP3
*)
Example ERC721A_run_code_of_0_block_204_1: equiv_checker [Opcode RETURNDATASIZE;DUP 3] [Opcode RETURNDATASIZE;DUP 3] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: RETURNDATASIZE PUSH 0 PUSH 20 DUP5 ADD
 O: RETURNDATASIZE PUSH 0 PUSH 20 DUP5 ADD
*)
Example ERC721A_run_code_of_0_block_204_2: equiv_checker [Opcode RETURNDATASIZE;PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 5;Opcode ADD] [Opcode RETURNDATASIZE;PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 5;Opcode ADD] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 200
 O: PUSH [tag] 200
*)
Example ERC721A_run_code_of_0_block_204_3: equiv_checker [PUSH 1 (natToWord WLen 200)] [PUSH 1 (natToWord WLen 200)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 60 SWAP2 POP
 O: PUSH 60 SWAP2 POP
*)
Example ERC721A_run_code_of_0_block_205_0: equiv_checker [PUSH 1 (natToWord WLen 96);DUP 2;POP] [PUSH 1 (natToWord WLen 96);DUP 2;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP PUSH 0 DUP2 MLOAD EQ ISZERO PUSH [tag] 202
 O: POP DUP1 MLOAD PUSH 0 EQ ISZERO PUSH [tag] 202
*)
Example ERC721A_run_code_of_0_block_206_0: equiv_checker [POP;DUP 1;Opcode MLOAD;PUSH 1 (natToWord WLen 0);Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 202)] [POP;PUSH 1 (natToWord WLen 0);DUP 2;Opcode MLOAD;Opcode EQ;Opcode ISZERO;PUSH 1 (natToWord WLen 202)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 40 MLOAD PUSH D1A57ED600000000000000000000000000000000000000000000000000000000 DUP2
 O: PUSH 40 MLOAD PUSH d1a57ed600000000000000000000000000000000000000000000000000000000 DUP2
*)
Example ERC721A_run_code_of_0_block_207_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 94825790509059390965680126405351569353353206259496993755816944651398402801664);DUP 2] [PUSH 1 (natToWord WLen 64);Opcode MLOAD;PUSH 32 (natToWord WLen 94825790509059390965680126405351569353353206259496993755816944651398402801664);DUP 2] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4 ADD PUSH 40 MLOAD DUP1 SWAP2 SUB SWAP1
 O: PUSH 40 MLOAD DUP1 SWAP2 PUSH 4 ADD SUB SWAP1
*)
Example ERC721A_run_code_of_0_block_207_1: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;PUSH 1 (natToWord WLen 4);Opcode ADD;Opcode SUB;DUP 1] [PUSH 1 (natToWord WLen 4);Opcode ADD;PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;DUP 2;Opcode SUB;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 MLOAD DUP2 PUSH 20 ADD
 O: DUP1 MLOAD DUP2 PUSH 20 ADD
*)
Example ERC721A_run_code_of_0_block_208_0: equiv_checker [DUP 1;Opcode MLOAD;DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD] [DUP 1;Opcode MLOAD;DUP 2;PUSH 1 (natToWord WLen 32);Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 150B7A02 PUSH E0 SHL PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND DUP2 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND EQ SWAP2 POP POP SWAP5 SWAP4 POP POP POP POP
 O: SWAP5 PUSH ffffffffffffffffffffffffffffffffffffffffffffffffffffffff NOT PUSH 150b7a02 PUSH e0 SHL SWAP2 SWAP8 SWAP7 DUP2 AND SWAP2 AND EQ SWAP6 POP POP POP POP POP
*)
Example ERC721A_run_code_of_0_block_209_0: equiv_checker [DUP 5;PUSH 28 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249215);Opcode NOT;PUSH 4 (natToWord WLen 353073666);PUSH 1 (natToWord WLen 224);Opcode SHL;DUP 2;DUP 8;DUP 7;DUP 2;Opcode AND;DUP 2;Opcode AND;Opcode EQ;DUP 6;POP;POP;POP;POP;POP] [PUSH 4 (natToWord WLen 353073666);PUSH 1 (natToWord WLen 224);Opcode SHL;PUSH 28 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249215);Opcode NOT;Opcode AND;DUP 2;PUSH 28 (natToWord WLen 26959946667150639794667015087019630673637144422540572481103610249215);Opcode NOT;Opcode AND;Opcode EQ;DUP 2;POP;POP;DUP 5;DUP 4;POP;POP;POP;POP] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 60 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
 O: PUSH 60 PUSH 40 MLOAD DUP1 PUSH 20 ADD PUSH 40
*)
Example ERC721A_run_code_of_0_block_210_0: equiv_checker [PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64)] [PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 1 (natToWord WLen 64)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 0 DUP2
 O: DUP1 PUSH 0 DUP2
*)
Example ERC721A_run_code_of_0_block_210_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 0);DUP 2] [DUP 1;PUSH 1 (natToWord WLen 0);DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP1 POP SWAP1
 O: POP SWAP2 SWAP1 POP
*)
Example ERC721A_run_code_of_0_block_210_2: equiv_checker [POP;DUP 2;DUP 1;POP] [POP;DUP 1;POP;DUP 1] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 60 PUSH 80 PUSH 40 MLOAD ADD SWAP1 POP DUP1 PUSH 40
 O: PUSH 80 PUSH 40 MLOAD ADD DUP1 PUSH 40
*)
Example ERC721A_run_code_of_0_block_211_0: equiv_checker [PUSH 1 (natToWord WLen 128);PUSH 1 (natToWord WLen 64);Opcode MLOAD;Opcode ADD;DUP 1;PUSH 1 (natToWord WLen 64)] [PUSH 1 (natToWord WLen 96);PUSH 1 (natToWord WLen 128);PUSH 1 (natToWord WLen 64);Opcode MLOAD;Opcode ADD;DUP 1;POP;DUP 1;PUSH 1 (natToWord WLen 64)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 DUP3
 O: DUP1 DUP3
*)
Example ERC721A_run_code_of_0_block_211_1: equiv_checker [DUP 1;DUP 3] [DUP 1;DUP 3] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 1 ISZERO PUSH [tag] 209
 O: PUSH 1 ISZERO PUSH [tag] 209
*)
Example ERC721A_run_code_of_0_block_212_0: equiv_checker [PUSH 1 (natToWord WLen 1);Opcode ISZERO;PUSH 1 (natToWord WLen 209)] [PUSH 1 (natToWord WLen 1);Opcode ISZERO;PUSH 1 (natToWord WLen 209)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 1 DUP4 SUB SWAP3 POP PUSH A DUP2 MOD PUSH 30 ADD DUP4
 O: PUSH 1 PUSH 30 SWAP4 SUB SWAP3 PUSH a DUP3 MOD ADD DUP4
*)
Example ERC721A_run_code_of_0_block_213_0: equiv_checker [PUSH 1 (natToWord WLen 1);PUSH 1 (natToWord WLen 48);DUP 4;Opcode SUB;DUP 3;PUSH 1 (natToWord WLen 10);DUP 3;Opcode MOD;Opcode ADD;DUP 4] [PUSH 1 (natToWord WLen 1);DUP 4;Opcode SUB;DUP 3;POP;PUSH 1 (natToWord WLen 10);DUP 2;Opcode MOD;PUSH 1 (natToWord WLen 48);Opcode ADD;DUP 4] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH A DUP2 DIV SWAP1 POP DUP1 PUSH [tag] 210
 O: PUSH a SWAP1 DIV DUP1 PUSH [tag] 210
*)
Example ERC721A_run_code_of_0_block_213_1: equiv_checker [PUSH 1 (natToWord WLen 10);DUP 1;Opcode DIV;DUP 1;PUSH 1 (natToWord WLen 210)] [PUSH 1 (natToWord WLen 10);DUP 2;Opcode DIV;DUP 1;POP;DUP 1;PUSH 1 (natToWord WLen 210)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 209
 O: PUSH [tag] 209
*)
Example ERC721A_run_code_of_0_block_214_0: equiv_checker [PUSH 1 (natToWord WLen 209)] [PUSH 1 (natToWord WLen 209)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 207
 O: PUSH [tag] 207
*)
Example ERC721A_run_code_of_0_block_215_0: equiv_checker [PUSH 1 (natToWord WLen 207)] [PUSH 1 (natToWord WLen 207)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP DUP2 DUP2 SUB PUSH 20 DUP4 SUB SWAP3 POP DUP1 DUP4
 O: POP PUSH 20 DUP3 SUB SWAP2 DUP2 SUB DUP1 DUP4
*)
Example ERC721A_run_code_of_0_block_216_0: equiv_checker [POP;PUSH 1 (natToWord WLen 32);DUP 3;Opcode SUB;DUP 2;DUP 2;Opcode SUB;DUP 1;DUP 4] [POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 32);DUP 4;Opcode SUB;DUP 3;POP;DUP 1;DUP 4] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP SWAP2 SWAP1 POP
 O: POP POP SWAP2 SWAP1 POP
*)
Example ERC721A_run_code_of_0_block_216_1: equiv_checker [POP;POP;DUP 2;DUP 1;POP] [POP;POP;DUP 2;DUP 1;POP] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 SWAP4 SWAP3 POP POP POP
 O: POP POP POP PUSH 0 SWAP1
*)
Example ERC721A_run_code_of_0_block_217_0: equiv_checker [POP;POP;POP;PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 4;DUP 3;POP;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 215 PUSH [tag] 216 DUP5 PUSH [tag] 217
 O: PUSH 0 PUSH [tag] 215 PUSH [tag] 216 DUP5 PUSH [tag] 217
*)
Example ERC721A_run_code_of_0_block_218_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 215);PUSH 1 (natToWord WLen 216);DUP 5;PUSH 1 (natToWord WLen 217)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 215);PUSH 1 (natToWord WLen 216);DUP 5;PUSH 1 (natToWord WLen 217)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 218
 O: PUSH [tag] 218
*)
Example ERC721A_run_code_of_0_block_219_0: equiv_checker [PUSH 1 (natToWord WLen 218)] [PUSH 1 (natToWord WLen 218)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP DUP3 DUP2
 O: SWAP1 POP DUP3 DUP2
*)
Example ERC721A_run_code_of_0_block_220_0: equiv_checker [DUP 1;POP;DUP 3;DUP 2] [DUP 1;POP;DUP 3;DUP 2] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP2 ADD DUP5 DUP5 DUP5 ADD GT ISZERO PUSH [tag] 219
 O: DUP1 PUSH 20 ADD DUP5 DUP4 DUP6 ADD GT ISZERO PUSH [tag] 219
*)
Example ERC721A_run_code_of_0_block_220_1: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 5;DUP 4;DUP 6;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 219)] [PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;DUP 5;DUP 5;DUP 5;Opcode ADD;Opcode GT;Opcode ISZERO;PUSH 1 (natToWord WLen 219)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 220 PUSH [tag] 221
 O: PUSH [tag] 220 PUSH [tag] 221
*)
Example ERC721A_run_code_of_0_block_221_0: equiv_checker [PUSH 1 (natToWord WLen 220);PUSH 1 (natToWord WLen 221)] [PUSH 1 (natToWord WLen 220);PUSH 1 (natToWord WLen 221)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 222 DUP5 DUP3 DUP6 PUSH [tag] 223
 O: PUSH [tag] 222 DUP5 DUP3 DUP6 PUSH [tag] 223
*)
Example ERC721A_run_code_of_0_block_223_0: equiv_checker [PUSH 1 (natToWord WLen 222);DUP 5;DUP 3;DUP 6;PUSH 1 (natToWord WLen 223)] [PUSH 1 (natToWord WLen 222);DUP 5;DUP 3;DUP 6;PUSH 1 (natToWord WLen 223)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP4 SWAP3 POP POP POP
 O: POP SWAP4 SWAP3 POP POP POP
*)
Example ERC721A_run_code_of_0_block_224_0: equiv_checker [POP;DUP 4;DUP 3;POP;POP;POP] [POP;DUP 4;DUP 3;POP;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 226 DUP2 PUSH [tag] 227
 O: DUP1 CALLDATALOAD PUSH [tag] 226 DUP2 PUSH [tag] 227
*)
Example ERC721A_run_code_of_0_block_225_0: equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 1 (natToWord WLen 226);DUP 2;PUSH 1 (natToWord WLen 227)] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode CALLDATALOAD;DUP 1;POP;PUSH 1 (natToWord WLen 226);DUP 2;PUSH 1 (natToWord WLen 227)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Example ERC721A_run_code_of_0_block_226_0: equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 230 DUP2 PUSH [tag] 231
 O: DUP1 CALLDATALOAD PUSH [tag] 230 DUP2 PUSH [tag] 231
*)
Example ERC721A_run_code_of_0_block_227_0: equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 1 (natToWord WLen 230);DUP 2;PUSH 1 (natToWord WLen 231)] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode CALLDATALOAD;DUP 1;POP;PUSH 1 (natToWord WLen 230);DUP 2;PUSH 1 (natToWord WLen 231)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Example ERC721A_run_code_of_0_block_228_0: equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 234 DUP2 PUSH [tag] 235
 O: DUP1 CALLDATALOAD PUSH [tag] 234 DUP2 PUSH [tag] 235
*)
Example ERC721A_run_code_of_0_block_229_0: equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 1 (natToWord WLen 234);DUP 2;PUSH 1 (natToWord WLen 235)] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode CALLDATALOAD;DUP 1;POP;PUSH 1 (natToWord WLen 234);DUP 2;PUSH 1 (natToWord WLen 235)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Example ERC721A_run_code_of_0_block_230_0: equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP PUSH [tag] 238 DUP2 PUSH [tag] 235
 O: DUP1 MLOAD PUSH [tag] 238 DUP2 PUSH [tag] 235
*)
Example ERC721A_run_code_of_0_block_231_0: equiv_checker [DUP 1;Opcode MLOAD;PUSH 1 (natToWord WLen 238);DUP 2;PUSH 1 (natToWord WLen 235)] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode MLOAD;DUP 1;POP;PUSH 1 (natToWord WLen 238);DUP 2;PUSH 1 (natToWord WLen 235)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Example ERC721A_run_code_of_0_block_232_0: equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP3 PUSH 1F DUP4 ADD SLT PUSH [tag] 241
 O: PUSH 0 DUP3 DUP3 PUSH 1f ADD SLT PUSH [tag] 241
*)
Example ERC721A_run_code_of_0_block_233_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 3;DUP 3;PUSH 1 (natToWord WLen 31);Opcode ADD;Opcode SLT;PUSH 1 (natToWord WLen 241)] [PUSH 1 (natToWord WLen 0);DUP 3;PUSH 1 (natToWord WLen 31);DUP 4;Opcode ADD;Opcode SLT;PUSH 1 (natToWord WLen 241)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 242 PUSH [tag] 243
 O: PUSH [tag] 242 PUSH [tag] 243
*)
Example ERC721A_run_code_of_0_block_234_0: equiv_checker [PUSH 1 (natToWord WLen 242);PUSH 1 (natToWord WLen 243)] [PUSH 1 (natToWord WLen 242);PUSH 1 (natToWord WLen 243)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 CALLDATALOAD PUSH [tag] 244 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 213
 O: DUP2 CALLDATALOAD PUSH [tag] 244 DUP5 DUP3 PUSH 20 DUP7 ADD PUSH [tag] 213
*)
Example ERC721A_run_code_of_0_block_236_0: equiv_checker [DUP 2;Opcode CALLDATALOAD;PUSH 1 (natToWord WLen 244);DUP 5;DUP 3;PUSH 1 (natToWord WLen 32);DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 213)] [DUP 2;Opcode CALLDATALOAD;PUSH 1 (natToWord WLen 244);DUP 5;DUP 3;PUSH 1 (natToWord WLen 32);DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 213)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Example ERC721A_run_code_of_0_block_237_0: equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 CALLDATALOAD SWAP1 POP PUSH [tag] 247 DUP2 PUSH [tag] 248
 O: DUP1 CALLDATALOAD PUSH [tag] 247 DUP2 PUSH [tag] 248
*)
Example ERC721A_run_code_of_0_block_238_0: equiv_checker [DUP 1;Opcode CALLDATALOAD;PUSH 1 (natToWord WLen 247);DUP 2;PUSH 1 (natToWord WLen 248)] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode CALLDATALOAD;DUP 1;POP;PUSH 1 (natToWord WLen 247);DUP 2;PUSH 1 (natToWord WLen 248)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Example ERC721A_run_code_of_0_block_239_0: equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 250
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 250
*)
Example ERC721A_run_code_of_0_block_240_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (natToWord WLen 250)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (natToWord WLen 250)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 251 PUSH [tag] 252
 O: PUSH [tag] 251 PUSH [tag] 252
*)
Example ERC721A_run_code_of_0_block_241_0: equiv_checker [PUSH 1 (natToWord WLen 251);PUSH 1 (natToWord WLen 252)] [PUSH 1 (natToWord WLen 251);PUSH 1 (natToWord WLen 252)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 253 DUP5 DUP3 DUP6 ADD PUSH [tag] 224
 O: PUSH 0 PUSH [tag] 253 DUP5 DUP5 DUP4 ADD PUSH [tag] 224
*)
Example ERC721A_run_code_of_0_block_243_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 253);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 224)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 253);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 1 (natToWord WLen 224)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Example ERC721A_run_code_of_0_block_244_0: equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 255
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 255
*)
Example ERC721A_run_code_of_0_block_245_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 64);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (natToWord WLen 255)] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 64);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 1 (natToWord WLen 255)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 256 PUSH [tag] 252
 O: PUSH [tag] 256 PUSH [tag] 252
*)
Example ERC721A_run_code_of_0_block_246_0: equiv_checker [PUSH 2 (natToWord WLen 256);PUSH 1 (natToWord WLen 252)] [PUSH 2 (natToWord WLen 256);PUSH 1 (natToWord WLen 252)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 257 DUP6 DUP3 DUP7 ADD PUSH [tag] 224
 O: PUSH 0 PUSH [tag] 257 DUP6 DUP6 DUP4 ADD PUSH [tag] 224
*)
Example ERC721A_run_code_of_0_block_248_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 257);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 224)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 257);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 224)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 258 DUP6 DUP3 DUP7 ADD PUSH [tag] 224
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 258 DUP6 DUP6 DUP4 ADD PUSH [tag] 224
*)
Example ERC721A_run_code_of_0_block_249_0: equiv_checker [DUP 3;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 258);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 224)] [DUP 3;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 258);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 224)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Example ERC721A_run_code_of_0_block_250_0: equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH 0 PUSH 60 DUP5 DUP7 SUB SLT ISZERO PUSH [tag] 260
 O: PUSH 0 DUP1 DUP2 PUSH 60 DUP5 DUP7 SUB SLT ISZERO PUSH [tag] 260
*)
Example ERC721A_run_code_of_0_block_251_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;DUP 2;PUSH 1 (natToWord WLen 96);DUP 5;DUP 7;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 260)] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 96);DUP 5;DUP 7;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 260)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 261 PUSH [tag] 252
 O: PUSH [tag] 261 PUSH [tag] 252
*)
Example ERC721A_run_code_of_0_block_252_0: equiv_checker [PUSH 2 (natToWord WLen 261);PUSH 1 (natToWord WLen 252)] [PUSH 2 (natToWord WLen 261);PUSH 1 (natToWord WLen 252)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 262 DUP7 DUP3 DUP8 ADD PUSH [tag] 224
 O: PUSH 0 PUSH [tag] 262 DUP7 DUP7 DUP4 ADD PUSH [tag] 224
*)
Example ERC721A_run_code_of_0_block_254_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 262);DUP 7;DUP 7;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 224)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 262);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 1 (natToWord WLen 224)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP4 POP POP PUSH 20 PUSH [tag] 263 DUP7 DUP3 DUP8 ADD PUSH [tag] 224
 O: SWAP4 POP POP PUSH 20 PUSH [tag] 263 DUP7 DUP7 DUP4 ADD PUSH [tag] 224
*)
Example ERC721A_run_code_of_0_block_255_0: equiv_checker [DUP 4;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 263);DUP 7;DUP 7;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 224)] [DUP 4;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 263);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 1 (natToWord WLen 224)] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP POP PUSH 40 PUSH [tag] 264 DUP7 DUP3 DUP8 ADD PUSH [tag] 245
 O: SWAP3 POP POP PUSH 40 PUSH [tag] 264 DUP7 DUP3 DUP8 ADD PUSH [tag] 245
*)
Example ERC721A_run_code_of_0_block_256_0: equiv_checker [DUP 3;POP;POP;PUSH 1 (natToWord WLen 64);PUSH 2 (natToWord WLen 264);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 1 (natToWord WLen 245)] [DUP 3;POP;POP;PUSH 1 (natToWord WLen 64);PUSH 2 (natToWord WLen 264);DUP 7;DUP 3;DUP 8;Opcode ADD;PUSH 1 (natToWord WLen 245)] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 POP SWAP3
 O: SWAP5 POP POP POP SWAP3 POP SWAP3
*)
Example ERC721A_run_code_of_0_block_257_0: equiv_checker [DUP 5;POP;POP;POP;DUP 3;POP;DUP 3] [DUP 2;POP;POP;DUP 3;POP;DUP 3;POP;DUP 3] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH 0 DUP1 PUSH 80 DUP6 DUP8 SUB SLT ISZERO PUSH [tag] 266
 O: PUSH 0 DUP1 DUP1 DUP3 PUSH 80 DUP6 DUP8 SUB SLT ISZERO PUSH [tag] 266
*)
Example ERC721A_run_code_of_0_block_258_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;DUP 1;DUP 3;PUSH 1 (natToWord WLen 128);DUP 6;DUP 8;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 266)] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 128);DUP 6;DUP 8;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 266)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 267 PUSH [tag] 252
 O: PUSH [tag] 267 PUSH [tag] 252
*)
Example ERC721A_run_code_of_0_block_259_0: equiv_checker [PUSH 2 (natToWord WLen 267);PUSH 1 (natToWord WLen 252)] [PUSH 2 (natToWord WLen 267);PUSH 1 (natToWord WLen 252)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 268 DUP8 DUP3 DUP9 ADD PUSH [tag] 224
 O: PUSH 0 PUSH [tag] 268 DUP8 DUP8 DUP4 ADD PUSH [tag] 224
*)
Example ERC721A_run_code_of_0_block_261_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 268);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 224)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 268);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 1 (natToWord WLen 224)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP5 POP POP PUSH 20 PUSH [tag] 269 DUP8 DUP3 DUP9 ADD PUSH [tag] 224
 O: SWAP5 POP POP PUSH 20 PUSH [tag] 269 DUP8 DUP8 DUP4 ADD PUSH [tag] 224
*)
Example ERC721A_run_code_of_0_block_262_0: equiv_checker [DUP 5;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 269);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 224)] [DUP 5;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 269);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 1 (natToWord WLen 224)] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP4 POP POP PUSH 40 PUSH [tag] 270 DUP8 DUP3 DUP9 ADD PUSH [tag] 245
 O: SWAP4 POP POP PUSH 40 PUSH [tag] 270 DUP8 DUP8 DUP4 ADD PUSH [tag] 245
*)
Example ERC721A_run_code_of_0_block_263_0: equiv_checker [DUP 4;POP;POP;PUSH 1 (natToWord WLen 64);PUSH 2 (natToWord WLen 270);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 245)] [DUP 4;POP;POP;PUSH 1 (natToWord WLen 64);PUSH 2 (natToWord WLen 270);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 1 (natToWord WLen 245)] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP POP PUSH 60 DUP6 ADD CALLDATALOAD PUSH FFFFFFFFFFFFFFFF DUP2 GT ISZERO PUSH [tag] 271
 O: SWAP3 POP POP DUP5 PUSH 60 ADD CALLDATALOAD PUSH ffffffffffffffff DUP2 GT ISZERO PUSH [tag] 271
*)
Example ERC721A_run_code_of_0_block_264_0: equiv_checker [DUP 3;POP;POP;DUP 5;PUSH 1 (natToWord WLen 96);Opcode ADD;Opcode CALLDATALOAD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 271)] [DUP 3;POP;POP;PUSH 1 (natToWord WLen 96);DUP 6;Opcode ADD;Opcode CALLDATALOAD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 271)] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 272 PUSH [tag] 273
 O: PUSH [tag] 272 PUSH [tag] 273
*)
Example ERC721A_run_code_of_0_block_265_0: equiv_checker [PUSH 2 (natToWord WLen 272);PUSH 2 (natToWord WLen 273)] [PUSH 2 (natToWord WLen 272);PUSH 2 (natToWord WLen 273)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 274 DUP8 DUP3 DUP9 ADD PUSH [tag] 239
 O: PUSH [tag] 274 DUP8 DUP8 DUP4 ADD PUSH [tag] 239
*)
Example ERC721A_run_code_of_0_block_267_0: equiv_checker [PUSH 2 (natToWord WLen 274);DUP 8;DUP 8;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 239)] [PUSH 2 (natToWord WLen 274);DUP 8;DUP 3;DUP 9;Opcode ADD;PUSH 1 (natToWord WLen 239)] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 SWAP6 SWAP2 SWAP5 POP SWAP3 POP
 O: SWAP5 SWAP8 SWAP4 SWAP7 POP POP POP SWAP3 POP
*)
Example ERC721A_run_code_of_0_block_268_0: equiv_checker [DUP 5;DUP 8;DUP 4;DUP 7;POP;POP;POP;DUP 3;POP] [DUP 2;POP;POP;DUP 3;DUP 6;DUP 2;DUP 5;POP;DUP 3;POP] 9 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 276
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 276
*)
Example ERC721A_run_code_of_0_block_269_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 64);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 276)] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 64);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 276)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 277 PUSH [tag] 252
 O: PUSH [tag] 277 PUSH [tag] 252
*)
Example ERC721A_run_code_of_0_block_270_0: equiv_checker [PUSH 2 (natToWord WLen 277);PUSH 1 (natToWord WLen 252)] [PUSH 2 (natToWord WLen 277);PUSH 1 (natToWord WLen 252)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 278 DUP6 DUP3 DUP7 ADD PUSH [tag] 224
 O: PUSH 0 PUSH [tag] 278 DUP6 DUP6 DUP4 ADD PUSH [tag] 224
*)
Example ERC721A_run_code_of_0_block_272_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 278);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 224)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 278);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 224)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 279 DUP6 DUP3 DUP7 ADD PUSH [tag] 228
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 279 DUP6 DUP6 DUP4 ADD PUSH [tag] 228
*)
Example ERC721A_run_code_of_0_block_273_0: equiv_checker [DUP 3;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 279);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 228)] [DUP 3;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 279);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 228)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Example ERC721A_run_code_of_0_block_274_0: equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 281
 O: PUSH 0 DUP1 PUSH 40 DUP4 DUP6 SUB SLT ISZERO PUSH [tag] 281
*)
Example ERC721A_run_code_of_0_block_275_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 64);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 281)] [PUSH 1 (natToWord WLen 0);DUP 1;PUSH 1 (natToWord WLen 64);DUP 4;DUP 6;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 281)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 282 PUSH [tag] 252
 O: PUSH [tag] 282 PUSH [tag] 252
*)
Example ERC721A_run_code_of_0_block_276_0: equiv_checker [PUSH 2 (natToWord WLen 282);PUSH 1 (natToWord WLen 252)] [PUSH 2 (natToWord WLen 282);PUSH 1 (natToWord WLen 252)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 283 DUP6 DUP3 DUP7 ADD PUSH [tag] 224
 O: PUSH 0 PUSH [tag] 283 DUP6 DUP6 DUP4 ADD PUSH [tag] 224
*)
Example ERC721A_run_code_of_0_block_278_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 283);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 224)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 283);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 224)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 POP POP PUSH 20 PUSH [tag] 284 DUP6 DUP3 DUP7 ADD PUSH [tag] 245
 O: SWAP3 POP POP PUSH 20 PUSH [tag] 284 DUP6 DUP6 DUP4 ADD PUSH [tag] 245
*)
Example ERC721A_run_code_of_0_block_279_0: equiv_checker [DUP 3;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 284);DUP 6;DUP 6;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 245)] [DUP 3;POP;POP;PUSH 1 (natToWord WLen 32);PUSH 2 (natToWord WLen 284);DUP 6;DUP 3;DUP 7;Opcode ADD;PUSH 1 (natToWord WLen 245)] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 POP SWAP3 SWAP1 POP
 O: SWAP5 POP POP POP SWAP3 SWAP1 POP
*)
Example ERC721A_run_code_of_0_block_280_0: equiv_checker [DUP 5;POP;POP;POP;DUP 3;DUP 1;POP] [DUP 2;POP;POP;DUP 3;POP;DUP 3;DUP 1;POP] 7 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 286
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 286
*)
Example ERC721A_run_code_of_0_block_281_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 286)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 286)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 287 PUSH [tag] 252
 O: PUSH [tag] 287 PUSH [tag] 252
*)
Example ERC721A_run_code_of_0_block_282_0: equiv_checker [PUSH 2 (natToWord WLen 287);PUSH 1 (natToWord WLen 252)] [PUSH 2 (natToWord WLen 287);PUSH 1 (natToWord WLen 252)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 288 DUP5 DUP3 DUP6 ADD PUSH [tag] 232
 O: PUSH 0 PUSH [tag] 288 DUP5 DUP5 DUP4 ADD PUSH [tag] 232
*)
Example ERC721A_run_code_of_0_block_284_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 288);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 232)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 288);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 1 (natToWord WLen 232)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Example ERC721A_run_code_of_0_block_285_0: equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 290
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 290
*)
Example ERC721A_run_code_of_0_block_286_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 290)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 290)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 291 PUSH [tag] 252
 O: PUSH [tag] 291 PUSH [tag] 252
*)
Example ERC721A_run_code_of_0_block_287_0: equiv_checker [PUSH 2 (natToWord WLen 291);PUSH 1 (natToWord WLen 252)] [PUSH 2 (natToWord WLen 291);PUSH 1 (natToWord WLen 252)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 292 DUP5 DUP3 DUP6 ADD PUSH [tag] 236
 O: PUSH 0 PUSH [tag] 292 DUP5 DUP5 DUP4 ADD PUSH [tag] 236
*)
Example ERC721A_run_code_of_0_block_289_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 292);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 236)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 292);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 1 (natToWord WLen 236)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Example ERC721A_run_code_of_0_block_290_0: equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 294
 O: PUSH 0 PUSH 20 DUP3 DUP5 SUB SLT ISZERO PUSH [tag] 294
*)
Example ERC721A_run_code_of_0_block_291_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 294)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;DUP 5;Opcode SUB;Opcode SLT;Opcode ISZERO;PUSH 2 (natToWord WLen 294)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 295 PUSH [tag] 252
 O: PUSH [tag] 295 PUSH [tag] 252
*)
Example ERC721A_run_code_of_0_block_292_0: equiv_checker [PUSH 2 (natToWord WLen 295);PUSH 1 (natToWord WLen 252)] [PUSH 2 (natToWord WLen 295);PUSH 1 (natToWord WLen 252)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 296 DUP5 DUP3 DUP6 ADD PUSH [tag] 245
 O: PUSH 0 PUSH [tag] 296 DUP5 DUP5 DUP4 ADD PUSH [tag] 245
*)
Example ERC721A_run_code_of_0_block_294_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 296);DUP 5;DUP 5;DUP 4;Opcode ADD;PUSH 1 (natToWord WLen 245)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 296);DUP 5;DUP 3;DUP 6;Opcode ADD;PUSH 1 (natToWord WLen 245)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP5 SWAP4 POP POP POP POP
*)
Example ERC721A_run_code_of_0_block_295_0: equiv_checker [DUP 5;DUP 4;POP;POP;POP;POP] [DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 299 DUP2 PUSH [tag] 300
 O: PUSH [tag] 299 DUP2 PUSH [tag] 300
*)
Example ERC721A_run_code_of_0_block_296_0: equiv_checker [PUSH 2 (natToWord WLen 299);DUP 2;PUSH 2 (natToWord WLen 300)] [PUSH 2 (natToWord WLen 299);DUP 2;PUSH 2 (natToWord WLen 300)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3
 O: DUP3
*)
Example ERC721A_run_code_of_0_block_297_0: equiv_checker [DUP 3] [DUP 3] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example ERC721A_run_code_of_0_block_297_1: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 303 DUP2 PUSH [tag] 304
 O: PUSH [tag] 303 DUP2 PUSH [tag] 304
*)
Example ERC721A_run_code_of_0_block_298_0: equiv_checker [PUSH 2 (natToWord WLen 303);DUP 2;PUSH 2 (natToWord WLen 304)] [PUSH 2 (natToWord WLen 303);DUP 2;PUSH 2 (natToWord WLen 304)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3
 O: DUP3
*)
Example ERC721A_run_code_of_0_block_299_0: equiv_checker [DUP 3] [DUP 3] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example ERC721A_run_code_of_0_block_299_1: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 307 DUP3 PUSH [tag] 308
 O: PUSH 0 PUSH [tag] 307 DUP3 PUSH [tag] 308
*)
Example ERC721A_run_code_of_0_block_300_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 307);DUP 3;PUSH 2 (natToWord WLen 308)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 307);DUP 3;PUSH 2 (natToWord WLen 308)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 309 DUP2 DUP6 PUSH [tag] 310
 O: PUSH [tag] 309 DUP2 DUP6 PUSH [tag] 310
*)
Example ERC721A_run_code_of_0_block_301_0: equiv_checker [PUSH 2 (natToWord WLen 309);DUP 2;DUP 6;PUSH 2 (natToWord WLen 310)] [PUSH 2 (natToWord WLen 309);DUP 2;DUP 6;PUSH 2 (natToWord WLen 310)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP4 POP PUSH [tag] 311 DUP2 DUP6 PUSH 20 DUP7 ADD PUSH [tag] 312
 O: SWAP4 POP PUSH [tag] 311 DUP2 DUP6 DUP6 PUSH 20 ADD PUSH [tag] 312
*)
Example ERC721A_run_code_of_0_block_302_0: equiv_checker [DUP 4;POP;PUSH 2 (natToWord WLen 311);DUP 2;DUP 6;DUP 6;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 2 (natToWord WLen 312)] [DUP 4;POP;PUSH 2 (natToWord WLen 311);DUP 2;DUP 6;PUSH 1 (natToWord WLen 32);DUP 7;Opcode ADD;PUSH 2 (natToWord WLen 312)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 313 DUP2 PUSH [tag] 314
 O: PUSH [tag] 313 DUP2 PUSH [tag] 314
*)
Example ERC721A_run_code_of_0_block_303_0: equiv_checker [PUSH 2 (natToWord WLen 313);DUP 2;PUSH 2 (natToWord WLen 314)] [PUSH 2 (natToWord WLen 313);DUP 2;PUSH 2 (natToWord WLen 314)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP5 ADD SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP3 POP POP POP ADD SWAP1
*)
Example ERC721A_run_code_of_0_block_304_0: equiv_checker [DUP 3;POP;POP;POP;Opcode ADD;DUP 1] [DUP 5;Opcode ADD;DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 317 DUP3 PUSH [tag] 318
 O: PUSH 0 PUSH [tag] 317 DUP3 PUSH [tag] 318
*)
Example ERC721A_run_code_of_0_block_305_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 317);DUP 3;PUSH 2 (natToWord WLen 318)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 317);DUP 3;PUSH 2 (natToWord WLen 318)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 319 DUP2 DUP6 PUSH [tag] 320
 O: PUSH [tag] 319 DUP2 DUP6 PUSH [tag] 320
*)
Example ERC721A_run_code_of_0_block_306_0: equiv_checker [PUSH 2 (natToWord WLen 319);DUP 2;DUP 6;PUSH 2 (natToWord WLen 320)] [PUSH 2 (natToWord WLen 319);DUP 2;DUP 6;PUSH 2 (natToWord WLen 320)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP4 POP PUSH [tag] 321 DUP2 DUP6 PUSH 20 DUP7 ADD PUSH [tag] 312
 O: SWAP4 POP PUSH [tag] 321 DUP2 DUP6 DUP6 PUSH 20 ADD PUSH [tag] 312
*)
Example ERC721A_run_code_of_0_block_307_0: equiv_checker [DUP 4;POP;PUSH 2 (natToWord WLen 321);DUP 2;DUP 6;DUP 6;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 2 (natToWord WLen 312)] [DUP 4;POP;PUSH 2 (natToWord WLen 321);DUP 2;DUP 6;PUSH 1 (natToWord WLen 32);DUP 7;Opcode ADD;PUSH 2 (natToWord WLen 312)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 322 DUP2 PUSH [tag] 314
 O: PUSH [tag] 322 DUP2 PUSH [tag] 314
*)
Example ERC721A_run_code_of_0_block_308_0: equiv_checker [PUSH 2 (natToWord WLen 322);DUP 2;PUSH 2 (natToWord WLen 314)] [PUSH 2 (natToWord WLen 322);DUP 2;PUSH 2 (natToWord WLen 314)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP5 ADD SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP3 POP POP POP ADD SWAP1
*)
Example ERC721A_run_code_of_0_block_309_0: equiv_checker [DUP 3;POP;POP;POP;Opcode ADD;DUP 1] [DUP 5;Opcode ADD;DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 325 DUP3 PUSH [tag] 318
 O: PUSH 0 PUSH [tag] 325 DUP3 PUSH [tag] 318
*)
Example ERC721A_run_code_of_0_block_310_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 325);DUP 3;PUSH 2 (natToWord WLen 318)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 325);DUP 3;PUSH 2 (natToWord WLen 318)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 326 DUP2 DUP6 PUSH [tag] 327
 O: PUSH [tag] 326 DUP2 DUP6 PUSH [tag] 327
*)
Example ERC721A_run_code_of_0_block_311_0: equiv_checker [PUSH 2 (natToWord WLen 326);DUP 2;DUP 6;PUSH 2 (natToWord WLen 327)] [PUSH 2 (natToWord WLen 326);DUP 2;DUP 6;PUSH 2 (natToWord WLen 327)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP4 POP PUSH [tag] 328 DUP2 DUP6 PUSH 20 DUP7 ADD PUSH [tag] 312
 O: SWAP4 POP PUSH [tag] 328 DUP2 DUP6 DUP6 PUSH 20 ADD PUSH [tag] 312
*)
Example ERC721A_run_code_of_0_block_312_0: equiv_checker [DUP 4;POP;PUSH 2 (natToWord WLen 328);DUP 2;DUP 6;DUP 6;PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 2 (natToWord WLen 312)] [DUP 4;POP;PUSH 2 (natToWord WLen 328);DUP 2;DUP 6;PUSH 1 (natToWord WLen 32);DUP 7;Opcode ADD;PUSH 2 (natToWord WLen 312)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 DUP5 ADD SWAP2 POP POP SWAP3 SWAP2 POP POP
 O: SWAP2 POP POP ADD SWAP1
*)
Example ERC721A_run_code_of_0_block_313_0: equiv_checker [DUP 2;POP;POP;Opcode ADD;DUP 1] [DUP 1;DUP 5;Opcode ADD;DUP 2;POP;POP;DUP 3;DUP 2;POP;POP] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 331 DUP2 PUSH [tag] 332
 O: PUSH [tag] 331 DUP2 PUSH [tag] 332
*)
Example ERC721A_run_code_of_0_block_314_0: equiv_checker [PUSH 2 (natToWord WLen 331);DUP 2;PUSH 2 (natToWord WLen 332)] [PUSH 2 (natToWord WLen 331);DUP 2;PUSH 2 (natToWord WLen 332)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3
 O: DUP3
*)
Example ERC721A_run_code_of_0_block_315_0: equiv_checker [DUP 3] [DUP 3] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP
 O: POP POP
*)
Example ERC721A_run_code_of_0_block_315_1: equiv_checker [POP;POP] [POP;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 334 DUP3 DUP6 PUSH [tag] 323
 O: PUSH 0 PUSH [tag] 334 DUP3 DUP6 PUSH [tag] 323
*)
Example ERC721A_run_code_of_0_block_316_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 334);DUP 3;DUP 6;PUSH 2 (natToWord WLen 323)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 334);DUP 3;DUP 6;PUSH 2 (natToWord WLen 323)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP PUSH [tag] 335 DUP3 DUP5 PUSH [tag] 323
 O: SWAP2 POP PUSH [tag] 335 DUP3 DUP5 PUSH [tag] 323
*)
Example ERC721A_run_code_of_0_block_317_0: equiv_checker [DUP 2;POP;PUSH 2 (natToWord WLen 335);DUP 3;DUP 5;PUSH 2 (natToWord WLen 323)] [DUP 2;POP;PUSH 2 (natToWord WLen 335);DUP 3;DUP 5;PUSH 2 (natToWord WLen 323)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 POP DUP2 SWAP1 POP SWAP4 SWAP3 POP POP POP
 O: SWAP4 POP POP POP POP SWAP1
*)
Example ERC721A_run_code_of_0_block_318_0: equiv_checker [DUP 4;POP;POP;POP;POP;DUP 1] [DUP 2;POP;DUP 2;DUP 1;POP;DUP 4;DUP 3;POP;POP;POP] 6 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP PUSH [tag] 337 PUSH 0 DUP4 ADD DUP5 PUSH [tag] 297
 O: PUSH 20 DUP2 ADD PUSH [tag] 337 DUP3 PUSH 0 ADD DUP5 PUSH [tag] 297
*)
Example ERC721A_run_code_of_0_block_319_0: equiv_checker [PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;PUSH 2 (natToWord WLen 337);DUP 3;PUSH 1 (natToWord WLen 0);Opcode ADD;DUP 5;PUSH 2 (natToWord WLen 297)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;PUSH 2 (natToWord WLen 337);PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD;DUP 5;PUSH 2 (natToWord WLen 297)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Example ERC721A_run_code_of_0_block_320_0: equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 80 DUP3 ADD SWAP1 POP PUSH [tag] 339 PUSH 0 DUP4 ADD DUP8 PUSH [tag] 297
 O: PUSH 80 DUP2 ADD PUSH [tag] 339 DUP3 PUSH 0 ADD DUP8 PUSH [tag] 297
*)
Example ERC721A_run_code_of_0_block_321_0: equiv_checker [PUSH 1 (natToWord WLen 128);DUP 2;Opcode ADD;PUSH 2 (natToWord WLen 339);DUP 3;PUSH 1 (natToWord WLen 0);Opcode ADD;DUP 8;PUSH 2 (natToWord WLen 297)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 128);DUP 3;Opcode ADD;DUP 1;POP;PUSH 2 (natToWord WLen 339);PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD;DUP 8;PUSH 2 (natToWord WLen 297)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 340 PUSH 20 DUP4 ADD DUP7 PUSH [tag] 297
 O: PUSH [tag] 340 DUP3 PUSH 20 ADD DUP7 PUSH [tag] 297
*)
Example ERC721A_run_code_of_0_block_322_0: equiv_checker [PUSH 2 (natToWord WLen 340);DUP 3;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 7;PUSH 2 (natToWord WLen 297)] [PUSH 2 (natToWord WLen 340);PUSH 1 (natToWord WLen 32);DUP 4;Opcode ADD;DUP 7;PUSH 2 (natToWord WLen 297)] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 341 PUSH 40 DUP4 ADD DUP6 PUSH [tag] 329
 O: PUSH [tag] 341 PUSH 40 DUP4 ADD DUP6 PUSH [tag] 329
*)
Example ERC721A_run_code_of_0_block_323_0: equiv_checker [PUSH 2 (natToWord WLen 341);PUSH 1 (natToWord WLen 64);DUP 4;Opcode ADD;DUP 6;PUSH 2 (natToWord WLen 329)] [PUSH 2 (natToWord WLen 341);PUSH 1 (natToWord WLen 64);DUP 4;Opcode ADD;DUP 6;PUSH 2 (natToWord WLen 329)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 DUP2 SUB PUSH 60 DUP4 ADD
 O: DUP2 DUP2 SUB PUSH 60 DUP4 ADD
*)
Example ERC721A_run_code_of_0_block_324_0: equiv_checker [DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 96);DUP 4;Opcode ADD] [DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 96);DUP 4;Opcode ADD] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 342 DUP2 DUP5 PUSH [tag] 305
 O: PUSH [tag] 342 DUP2 DUP5 PUSH [tag] 305
*)
Example ERC721A_run_code_of_0_block_324_1: equiv_checker [PUSH 2 (natToWord WLen 342);DUP 2;DUP 5;PUSH 2 (natToWord WLen 305)] [PUSH 2 (natToWord WLen 342);DUP 2;DUP 5;PUSH 2 (natToWord WLen 305)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP6 SWAP5 POP POP POP POP POP
 O: SWAP7 SWAP6 POP POP POP POP POP POP
*)
Example ERC721A_run_code_of_0_block_325_0: equiv_checker [DUP 7;DUP 6;POP;POP;POP;POP;POP;POP] [DUP 1;POP;DUP 6;DUP 5;POP;POP;POP;POP;POP] 8 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP PUSH [tag] 344 PUSH 0 DUP4 ADD DUP5 PUSH [tag] 301
 O: PUSH 20 DUP2 ADD PUSH [tag] 344 DUP3 PUSH 0 ADD DUP5 PUSH [tag] 301
*)
Example ERC721A_run_code_of_0_block_326_0: equiv_checker [PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;PUSH 2 (natToWord WLen 344);DUP 3;PUSH 1 (natToWord WLen 0);Opcode ADD;DUP 5;PUSH 2 (natToWord WLen 301)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;PUSH 2 (natToWord WLen 344);PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD;DUP 5;PUSH 2 (natToWord WLen 301)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Example ERC721A_run_code_of_0_block_327_0: equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP DUP2 DUP2 SUB PUSH 0 DUP4 ADD
 O: DUP1 PUSH 20 ADD DUP2 DUP2 SUB PUSH 0 DUP4 ADD
*)
Example ERC721A_run_code_of_0_block_328_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 2;DUP 2;Opcode SUB;PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 346 DUP2 DUP5 PUSH [tag] 315
 O: PUSH [tag] 346 DUP2 DUP5 PUSH [tag] 315
*)
Example ERC721A_run_code_of_0_block_328_1: equiv_checker [PUSH 2 (natToWord WLen 346);DUP 2;DUP 5;PUSH 2 (natToWord WLen 315)] [PUSH 2 (natToWord WLen 346);DUP 2;DUP 5;PUSH 2 (natToWord WLen 315)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP4 SWAP3 POP POP POP
*)
Example ERC721A_run_code_of_0_block_329_0: equiv_checker [DUP 4;DUP 3;POP;POP;POP] [DUP 1;POP;DUP 3;DUP 2;POP;POP] 5 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 20 DUP3 ADD SWAP1 POP PUSH [tag] 348 PUSH 0 DUP4 ADD DUP5 PUSH [tag] 329
 O: PUSH 20 DUP2 ADD PUSH [tag] 348 DUP3 PUSH 0 ADD DUP5 PUSH [tag] 329
*)
Example ERC721A_run_code_of_0_block_330_0: equiv_checker [PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;PUSH 2 (natToWord WLen 348);DUP 3;PUSH 1 (natToWord WLen 0);Opcode ADD;DUP 5;PUSH 2 (natToWord WLen 329)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;PUSH 2 (natToWord WLen 348);PUSH 1 (natToWord WLen 0);DUP 4;Opcode ADD;DUP 5;PUSH 2 (natToWord WLen 329)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP3 SWAP2 POP POP
 O: SWAP3 SWAP2 POP POP
*)
Example ERC721A_run_code_of_0_block_331_0: equiv_checker [DUP 3;DUP 2;POP;POP] [DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 350 PUSH [tag] 351
 O: PUSH 0 PUSH [tag] 350 PUSH [tag] 351
*)
Example ERC721A_run_code_of_0_block_332_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 350);PUSH 2 (natToWord WLen 351)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 350);PUSH 2 (natToWord WLen 351)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP PUSH [tag] 352 DUP3 DUP3 PUSH [tag] 353
 O: SWAP1 POP PUSH [tag] 352 DUP3 DUP3 PUSH [tag] 353
*)
Example ERC721A_run_code_of_0_block_333_0: equiv_checker [DUP 1;POP;PUSH 2 (natToWord WLen 352);DUP 3;DUP 3;PUSH 2 (natToWord WLen 353)] [DUP 1;POP;PUSH 2 (natToWord WLen 352);DUP 3;DUP 3;PUSH 2 (natToWord WLen 353)] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP2 SWAP1 POP
 O: SWAP2 SWAP1 POP
*)
Example ERC721A_run_code_of_0_block_334_0: equiv_checker [DUP 2;DUP 1;POP] [DUP 2;DUP 1;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 40 MLOAD SWAP1 POP SWAP1
 O: PUSH 40 MLOAD SWAP1
*)
Example ERC721A_run_code_of_0_block_335_0: equiv_checker [PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 64);Opcode MLOAD;DUP 1;POP;DUP 1] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFF DUP3 GT ISZERO PUSH [tag] 356
 O: PUSH 0 PUSH ffffffffffffffff DUP3 GT ISZERO PUSH [tag] 356
*)
Example ERC721A_run_code_of_0_block_336_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 8 (natToWord WLen 18446744073709551615);DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 356)] [PUSH 1 (natToWord WLen 0);PUSH 8 (natToWord WLen 18446744073709551615);DUP 3;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 356)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 357 PUSH [tag] 358
 O: PUSH [tag] 357 PUSH [tag] 358
*)
Example ERC721A_run_code_of_0_block_337_0: equiv_checker [PUSH 2 (natToWord WLen 357);PUSH 2 (natToWord WLen 358)] [PUSH 2 (natToWord WLen 357);PUSH 2 (natToWord WLen 358)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 359 DUP3 PUSH [tag] 314
 O: PUSH [tag] 359 DUP3 PUSH [tag] 314
*)
Example ERC721A_run_code_of_0_block_339_0: equiv_checker [PUSH 2 (natToWord WLen 359);DUP 3;PUSH 2 (natToWord WLen 314)] [PUSH 2 (natToWord WLen 359);DUP 3;PUSH 2 (natToWord WLen 314)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP PUSH 20 DUP2 ADD SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 20 ADD SWAP2 POP POP SWAP1
*)
Example ERC721A_run_code_of_0_block_340_0: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;DUP 2;POP;POP;DUP 1] [DUP 1;POP;PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP SWAP2 SWAP1 POP
 O: MLOAD SWAP1
*)
Example ERC721A_run_code_of_0_block_341_0: equiv_checker [Opcode MLOAD;DUP 1] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode MLOAD;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 MLOAD SWAP1 POP SWAP2 SWAP1 POP
 O: MLOAD SWAP1
*)
Example ERC721A_run_code_of_0_block_342_0: equiv_checker [Opcode MLOAD;DUP 1] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode MLOAD;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP3 DUP3
 O: PUSH 0 DUP3 DUP3
*)
Example ERC721A_run_code_of_0_block_343_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 3;DUP 3] [PUSH 1 (natToWord WLen 0);DUP 3;DUP 3] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP PUSH 20 SWAP2 POP ADD SWAP1
*)
Example ERC721A_run_code_of_0_block_343_1: equiv_checker [POP;PUSH 1 (natToWord WLen 32);DUP 2;POP;Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP3 DUP3
 O: PUSH 0 DUP3 DUP3
*)
Example ERC721A_run_code_of_0_block_344_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 3;DUP 3] [PUSH 1 (natToWord WLen 0);DUP 3;DUP 3] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 ADD SWAP1 POP SWAP3 SWAP2 POP POP
 O: POP PUSH 20 SWAP2 POP ADD SWAP1
*)
Example ERC721A_run_code_of_0_block_344_1: equiv_checker [POP;PUSH 1 (natToWord WLen 32);DUP 2;POP;Opcode ADD;DUP 1] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode ADD;DUP 1;POP;DUP 3;DUP 2;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 SWAP1 POP SWAP3 SWAP2 POP POP
 O: SWAP2 SWAP1 POP
*)
Example ERC721A_run_code_of_0_block_345_0: equiv_checker [DUP 2;DUP 1;POP] [PUSH 1 (natToWord WLen 0);DUP 2;DUP 1;POP;DUP 3;DUP 2;POP;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH [tag] 366 DUP3 PUSH [tag] 367
 O: PUSH 0 PUSH [tag] 366 DUP3 PUSH [tag] 367
*)
Example ERC721A_run_code_of_0_block_346_0: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 366);DUP 3;PUSH 2 (natToWord WLen 367)] [PUSH 1 (natToWord WLen 0);PUSH 2 (natToWord WLen 366);DUP 3;PUSH 2 (natToWord WLen 367)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP2 POP POP SWAP1
*)
Example ERC721A_run_code_of_0_block_347_0: equiv_checker [DUP 2;POP;POP;DUP 1] [DUP 1;POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 ISZERO ISZERO SWAP1 POP SWAP2 SWAP1 POP
 O: ISZERO ISZERO SWAP1
*)
Example ERC721A_run_code_of_0_block_348_0: equiv_checker [Opcode ISZERO;Opcode ISZERO;DUP 1] [PUSH 1 (natToWord WLen 0);DUP 2;Opcode ISZERO;Opcode ISZERO;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH FFFFFFFF00000000000000000000000000000000000000000000000000000000 DUP3 AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH ffffffff00000000000000000000000000000000000000000000000000000000 AND SWAP1
*)
Example ERC721A_run_code_of_0_block_349_0: equiv_checker [PUSH 32 (natToWord WLen 115792089210356248756420345214020892766250353992003419616917011526809519390720);Opcode AND;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 32 (natToWord WLen 115792089210356248756420345214020892766250353992003419616917011526809519390720);DUP 3;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF DUP3 AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH ffffffffffffffffffffffffffffffffffffffff AND SWAP1
*)
Example ERC721A_run_code_of_0_block_350_0: equiv_checker [PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);Opcode AND;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 20 (natToWord WLen 1461501637330902918203684832716283019655932542975);DUP 3;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP2 SWAP1 POP SWAP2 SWAP1 POP
 O: SWAP1
*)
Example ERC721A_run_code_of_0_block_351_0: equiv_checker [DUP 1] [PUSH 1 (natToWord WLen 0);DUP 2;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 DUP2 DUP4
 O: DUP3 DUP2 DUP4
*)
Example ERC721A_run_code_of_0_block_352_0: equiv_checker [DUP 3;DUP 2;DUP 4] [DUP 3;DUP 2;DUP 4] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP4 DUP4 ADD
 O: PUSH 0 DUP3 DUP5 ADD
*)
Example ERC721A_run_code_of_0_block_352_1: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 3;DUP 5;Opcode ADD] [PUSH 1 (natToWord WLen 0);DUP 4;DUP 4;Opcode ADD] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP
 O: POP POP POP
*)
Example ERC721A_run_code_of_0_block_352_2: equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0
 O: PUSH 0
*)
Example ERC721A_run_code_of_0_block_353_0: equiv_checker [PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP4 DUP2 LT ISZERO PUSH [tag] 377
 O: DUP4 DUP2 LT ISZERO PUSH [tag] 377
*)
Example ERC721A_run_code_of_0_block_354_0: equiv_checker [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (natToWord WLen 377)] [DUP 4;DUP 2;Opcode LT;Opcode ISZERO;PUSH 2 (natToWord WLen 377)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD
 O: DUP2 DUP2 ADD MLOAD DUP4 DUP3 ADD
*)
Example ERC721A_run_code_of_0_block_355_0: equiv_checker [DUP 2;DUP 2;Opcode ADD;Opcode MLOAD;DUP 4;DUP 3;Opcode ADD] [DUP 1;DUP 3;Opcode ADD;Opcode MLOAD;DUP 2;DUP 5;Opcode ADD] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP2 ADD SWAP1 POP PUSH [tag] 375
 O: PUSH 20 ADD PUSH [tag] 375
*)
Example ERC721A_run_code_of_0_block_355_1: equiv_checker [PUSH 1 (natToWord WLen 32);Opcode ADD;PUSH 2 (natToWord WLen 375)] [PUSH 1 (natToWord WLen 32);DUP 2;Opcode ADD;DUP 1;POP;PUSH 2 (natToWord WLen 375)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP4 DUP2 GT ISZERO PUSH [tag] 378
 O: DUP4 DUP2 GT ISZERO PUSH [tag] 378
*)
Example ERC721A_run_code_of_0_block_356_0: equiv_checker [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 378)] [DUP 4;DUP 2;Opcode GT;Opcode ISZERO;PUSH 2 (natToWord WLen 378)] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP5 DUP5 ADD
 O: PUSH 0 DUP4 DUP6 ADD
*)
Example ERC721A_run_code_of_0_block_357_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 4;DUP 6;Opcode ADD] [PUSH 1 (natToWord WLen 0);DUP 5;DUP 5;Opcode ADD] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP POP
 O: POP POP POP POP
*)
Example ERC721A_run_code_of_0_block_358_0: equiv_checker [POP;POP;POP;POP] [POP;POP;POP;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 2 DUP3 DIV SWAP1 POP PUSH 1 DUP3 AND DUP1 PUSH [tag] 380
 O: PUSH 2 DUP2 DIV DUP2 PUSH 1 AND DUP1 PUSH [tag] 380
*)
Example ERC721A_run_code_of_0_block_359_0: equiv_checker [PUSH 1 (natToWord WLen 2);DUP 2;Opcode DIV;DUP 2;PUSH 1 (natToWord WLen 1);Opcode AND;DUP 1;PUSH 2 (natToWord WLen 380)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 2);DUP 3;Opcode DIV;DUP 1;POP;PUSH 1 (natToWord WLen 1);DUP 3;Opcode AND;DUP 1;PUSH 2 (natToWord WLen 380)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 7F DUP3 AND SWAP2 POP
 O: SWAP1 PUSH 7f AND SWAP1
*)
Example ERC721A_run_code_of_0_block_360_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 127);Opcode AND;DUP 1] [PUSH 1 (natToWord WLen 127);DUP 3;Opcode AND;DUP 2;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 20 DUP3 LT DUP2 EQ ISZERO PUSH [tag] 381
 O: DUP1 PUSH 20 DUP4 LT EQ ISZERO PUSH [tag] 381
*)
Example ERC721A_run_code_of_0_block_361_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 32);DUP 4;Opcode LT;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 381)] [PUSH 1 (natToWord WLen 32);DUP 3;Opcode LT;DUP 2;Opcode EQ;Opcode ISZERO;PUSH 2 (natToWord WLen 381)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 382 PUSH [tag] 383
 O: PUSH [tag] 382 PUSH [tag] 383
*)
Example ERC721A_run_code_of_0_block_362_0: equiv_checker [PUSH 2 (natToWord WLen 382);PUSH 2 (natToWord WLen 383)] [PUSH 2 (natToWord WLen 382);PUSH 2 (natToWord WLen 383)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP SWAP2 SWAP1 POP
 O: POP SWAP2 SWAP1 POP
*)
Example ERC721A_run_code_of_0_block_364_0: equiv_checker [POP;DUP 2;DUP 1;POP] [POP;DUP 2;DUP 1;POP] 4 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 385 DUP3 PUSH [tag] 314
 O: PUSH [tag] 385 DUP3 PUSH [tag] 314
*)
Example ERC721A_run_code_of_0_block_365_0: equiv_checker [PUSH 2 (natToWord WLen 385);DUP 3;PUSH 2 (natToWord WLen 314)] [PUSH 2 (natToWord WLen 385);DUP 3;PUSH 2 (natToWord WLen 314)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 ADD DUP2 DUP2 LT PUSH FFFFFFFFFFFFFFFF DUP3 GT OR ISZERO PUSH [tag] 386
 O: DUP2 ADD PUSH ffffffffffffffff DUP2 GT DUP3 DUP3 LT OR ISZERO PUSH [tag] 386
*)
Example ERC721A_run_code_of_0_block_366_0: equiv_checker [DUP 2;Opcode ADD;PUSH 8 (natToWord WLen 18446744073709551615);DUP 2;Opcode GT;DUP 3;DUP 3;Opcode LT;Opcode OR;Opcode ISZERO;PUSH 2 (natToWord WLen 386)] [DUP 2;Opcode ADD;DUP 2;DUP 2;Opcode LT;PUSH 8 (natToWord WLen 18446744073709551615);DUP 3;Opcode GT;Opcode OR;Opcode ISZERO;PUSH 2 (natToWord WLen 386)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 387 PUSH [tag] 358
 O: PUSH [tag] 387 PUSH [tag] 358
*)
Example ERC721A_run_code_of_0_block_367_0: equiv_checker [PUSH 2 (natToWord WLen 387);PUSH 2 (natToWord WLen 358)] [PUSH 2 (natToWord WLen 387);PUSH 2 (natToWord WLen 358)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP1 PUSH 40
 O: DUP1 PUSH 40
*)
Example ERC721A_run_code_of_0_block_369_0: equiv_checker [DUP 1;PUSH 1 (natToWord WLen 64)] [DUP 1;PUSH 1 (natToWord WLen 64)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP POP POP
 O: POP POP POP
*)
Example ERC721A_run_code_of_0_block_369_1: equiv_checker [POP;POP;POP] [POP;POP;POP] 3 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Example ERC721A_run_code_of_0_block_370_0: equiv_checker [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 22 PUSH 4
 O: PUSH 22 PUSH 4
*)
Example ERC721A_run_code_of_0_block_370_1: equiv_checker [PUSH 1 (natToWord WLen 34);PUSH 1 (natToWord WLen 4)] [PUSH 1 (natToWord WLen 34);PUSH 1 (natToWord WLen 4)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Example ERC721A_run_code_of_0_block_370_2: equiv_checker [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Example ERC721A_run_code_of_0_block_371_0: equiv_checker [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 41 PUSH 4
 O: PUSH 41 PUSH 4
*)
Example ERC721A_run_code_of_0_block_371_1: equiv_checker [PUSH 1 (natToWord WLen 65);PUSH 1 (natToWord WLen 4)] [PUSH 1 (natToWord WLen 65);PUSH 1 (natToWord WLen 4)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Example ERC721A_run_code_of_0_block_371_2: equiv_checker [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example ERC721A_run_code_of_0_block_372_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example ERC721A_run_code_of_0_block_373_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example ERC721A_run_code_of_0_block_374_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example ERC721A_run_code_of_0_block_375_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 1F NOT PUSH 1F DUP4 ADD AND SWAP1 POP SWAP2 SWAP1 POP
 O: PUSH 1f ADD PUSH 1f NOT AND SWAP1
*)
Example ERC721A_run_code_of_0_block_376_0: equiv_checker [PUSH 1 (natToWord WLen 31);Opcode ADD;PUSH 1 (natToWord WLen 31);Opcode NOT;Opcode AND;DUP 1] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 31);Opcode NOT;PUSH 1 (natToWord WLen 31);DUP 4;Opcode ADD;Opcode AND;DUP 1;POP;DUP 2;DUP 1;POP] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 396 DUP2 PUSH [tag] 300
 O: PUSH [tag] 396 DUP2 PUSH [tag] 300
*)
Example ERC721A_run_code_of_0_block_377_0: equiv_checker [PUSH 2 (natToWord WLen 396);DUP 2;PUSH 2 (natToWord WLen 300)] [PUSH 2 (natToWord WLen 396);DUP 2;PUSH 2 (natToWord WLen 300)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 EQ PUSH [tag] 397
 O: DUP2 EQ PUSH [tag] 397
*)
Example ERC721A_run_code_of_0_block_378_0: equiv_checker [DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 397)] [DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 397)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example ERC721A_run_code_of_0_block_379_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example ERC721A_run_code_of_0_block_380_0: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 399 DUP2 PUSH [tag] 304
 O: PUSH [tag] 399 DUP2 PUSH [tag] 304
*)
Example ERC721A_run_code_of_0_block_381_0: equiv_checker [PUSH 2 (natToWord WLen 399);DUP 2;PUSH 2 (natToWord WLen 304)] [PUSH 2 (natToWord WLen 399);DUP 2;PUSH 2 (natToWord WLen 304)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 EQ PUSH [tag] 400
 O: DUP2 EQ PUSH [tag] 400
*)
Example ERC721A_run_code_of_0_block_382_0: equiv_checker [DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 400)] [DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 400)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example ERC721A_run_code_of_0_block_383_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example ERC721A_run_code_of_0_block_384_0: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 402 DUP2 PUSH [tag] 369
 O: PUSH [tag] 402 DUP2 PUSH [tag] 369
*)
Example ERC721A_run_code_of_0_block_385_0: equiv_checker [PUSH 2 (natToWord WLen 402);DUP 2;PUSH 2 (natToWord WLen 369)] [PUSH 2 (natToWord WLen 402);DUP 2;PUSH 2 (natToWord WLen 369)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 EQ PUSH [tag] 403
 O: DUP2 EQ PUSH [tag] 403
*)
Example ERC721A_run_code_of_0_block_386_0: equiv_checker [DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 403)] [DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 403)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example ERC721A_run_code_of_0_block_387_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example ERC721A_run_code_of_0_block_388_0: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH [tag] 405 DUP2 PUSH [tag] 332
 O: PUSH [tag] 405 DUP2 PUSH [tag] 332
*)
Example ERC721A_run_code_of_0_block_389_0: equiv_checker [PUSH 2 (natToWord WLen 405);DUP 2;PUSH 2 (natToWord WLen 332)] [PUSH 2 (natToWord WLen 405);DUP 2;PUSH 2 (natToWord WLen 332)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP2 EQ PUSH [tag] 406
 O: DUP2 EQ PUSH [tag] 406
*)
Example ERC721A_run_code_of_0_block_390_0: equiv_checker [DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 406)] [DUP 2;Opcode EQ;PUSH 2 (natToWord WLen 406)] 2 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 DUP1
 O: PUSH 0 DUP1
*)
Example ERC721A_run_code_of_0_block_391_0: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: POP
 O: POP
*)
Example ERC721A_run_code_of_0_block_392_0: equiv_checker [POP] [POP] 1 optimize_id = true.
Proof.  reflexivity. Qed.

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
Example Strings_initial_block_0_1: equiv_checker [DUP 1;Opcode MLOAD;PUSH 1 (natToWord WLen 0);Opcode BYTE;PUSH 1 (natToWord WLen 115);Opcode EQ;PUSH 1 (natToWord WLen 1)] [DUP 1;Opcode MLOAD;PUSH 1 (natToWord WLen 0);Opcode BYTE;PUSH 1 (natToWord WLen 115);Opcode EQ;PUSH 1 (natToWord WLen 1)] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 4E487B7100000000000000000000000000000000000000000000000000000000 PUSH 0
 O: PUSH 4e487b7100000000000000000000000000000000000000000000000000000000 PUSH 0
*)
Example Strings_initial_block_1_0: equiv_checker [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] [PUSH 32 (natToWord WLen 35408467139433450592217433187231851964531694900788300625387963629091585785856);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 0 PUSH 4
 O: PUSH 0 PUSH 4
*)
Example Strings_initial_block_1_1: equiv_checker [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 4)] [PUSH 1 (natToWord WLen 0);PUSH 1 (natToWord WLen 4)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 24 PUSH 0
 O: PUSH 24 PUSH 0
*)
Example Strings_initial_block_1_2: equiv_checker [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] [PUSH 1 (natToWord WLen 36);PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: ADDRESS PUSH 0
 O: ADDRESS PUSH 0
*)
Example Strings_initial_block_2_0: equiv_checker [Opcode ADDRESS;PUSH 1 (natToWord WLen 0)] [Opcode ADDRESS;PUSH 1 (natToWord WLen 0)] 0 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: PUSH 73 DUP2
 O: PUSH 73 DUP2
*)
Example Strings_initial_block_2_1: equiv_checker [PUSH 1 (natToWord WLen 115);DUP 2] [PUSH 1 (natToWord WLen 115);DUP 2] 1 optimize_id = true.
Proof.  reflexivity. Qed.

(*
 I: DUP3 DUP2
 O: DUP3 DUP2
*)
Example Strings_initial_block_2_2: equiv_checker [DUP 3;DUP 2] [DUP 3;DUP 2] 3 optimize_id = true.
Proof.  reflexivity. Qed.

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
Example Strings_run_code_of_0_block_0_1: equiv_checker [PUSH 1 (natToWord WLen 0);DUP 1] [PUSH 1 (natToWord WLen 0);DUP 1] 0 optimize_id = true.
Proof.  reflexivity. Qed.


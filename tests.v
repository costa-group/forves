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


Module Tests_definitions.

Example ex_shl1:
evm_shl [(natToWord WLen 1); (natToWord WLen 3)] = Some (natToWord WLen 6).
Proof. reflexivity. Qed.

Example ex_shl2:
evm_shl [(natToWord WLen 3); (natToWord WLen 1)] = Some (natToWord WLen 8).
Proof. reflexivity. Qed.

Example ex_shr1:
evm_shr [(natToWord WLen 1); (natToWord WLen 7)] = Some (natToWord WLen 3).
Proof. reflexivity. Qed.

Example ex_shr2:
evm_shr [(natToWord WLen 2); (natToWord WLen 16)] = Some (natToWord WLen 4).
Proof. reflexivity. Qed.

Example ex_sub1:
evm_sub [(natToWord WLen 5); (natToWord WLen 2)] = Some (natToWord WLen 3).
Proof. reflexivity. Qed.

Example ex_sub2:
evm_sub [(natToWord WLen 2); (natToWord WLen 2)] = Some WZero.
Proof. reflexivity. Qed.

Example ex_sub3:
(* 2 - 3 (mod 2^256) = 2^256 - 1*)
evm_sub [(natToWord WLen 2); (natToWord WLen 3)] = Some (wnot WZero).
Proof. reflexivity. Qed.

Example ex_exp1:
evm_exp [(natToWord WLen 2); (natToWord WLen 4)] = Some (natToWord WLen 16).
Proof. reflexivity. Qed.

Example ex_exp2:
(* 2 ^ 256 = 0 *)
evm_exp [(natToWord WLen 2); (natToWord WLen 256)] = Some (WZero).
Proof. reflexivity. Qed.

Example ex_exp3:
evm_exp [(natToWord WLen 3); (natToWord WLen 2)] = Some (natToWord WLen 9).
Proof. reflexivity. Qed.

End Tests_definitions.



Module Tests_interpreter.
Example swap_1: 
(* Exchanges first and second stack elements *)
swap 1 [1;2;3;4] = Some [2;1;3;4].
Proof. reflexivity. Qed.
Example swap_2: 
(* Exchanges first and third stack elements *)
swap 2 [1;2;3;4] = Some [3;2;1;4].
Proof. reflexivity. Qed.
(* Exchanges first and fourth stack elements *)
Example swap_3: 
swap 3 [1;2;3;4] = Some [4;2;3;1].
Proof. reflexivity. Qed.
Example swap_4: 
(* Must fail, no 5th element *) 
swap 4 [1;2;3;4] = None.
Proof. reflexivity. Qed.
Example swap_16: 
(* Exchanges first and 17th stack elements *)
swap 16 [1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17] = 
   Some [17;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;1].
Proof. reflexivity. Qed.
Example swap_17: 
(* Exchanges first and 17th stack elements *)
swap 17 [1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20] = None.
Proof. reflexivity. Qed.

Example dup_1:
dup 1 [1;2;3;4] = Some [1;1;2;3;4].
Proof. reflexivity. Qed.
Example dup_2:
dup 2 [1;2;3;4] = Some [2;1;2;3;4].
Proof. reflexivity. Qed.
Example dup_0:
dup 0 [1;2;3;4] = None.
Proof. reflexivity. Qed.
Example dup_16:
dup 16 [1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17] = 
  Some [16;1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17].
Proof. reflexivity. Qed.
Example dup_17: 
dup 17 [1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20] = None.
Proof. reflexivity. Qed.



Example test_swap0:
let state0 := ExState [(natToWord WLen 1);(natToWord WLen 2);(natToWord WLen 3)] empty_nmap empty_nmap in
swap_c 0 state0 = None.
Proof. 
reflexivity.
Qed.

Example test_swap1:
let state0 := ExState [(natToWord WLen 1);(natToWord WLen 2);(natToWord WLen 3)] empty_nmap empty_nmap in
let state1 := ExState [(natToWord WLen 2);(natToWord WLen 1);(natToWord WLen 3)] empty_nmap empty_nmap in 
swap_c 1 state0 = Some state1.
Proof. 
reflexivity.
Qed.

Example test_swap2:
let state0 := ExState [(natToWord WLen 1);(natToWord WLen 2);(natToWord WLen 3)] empty_nmap empty_nmap in
let state1 := ExState [(natToWord WLen 3);(natToWord WLen 2);(natToWord WLen 1)] empty_nmap empty_nmap in 
swap_c 2 state0 = Some state1.
Proof. 
reflexivity.
Qed.

Example test_swap_longer:
let state0 := ExState [(natToWord WLen 1);(natToWord WLen 2);(natToWord WLen 3)] empty_nmap empty_nmap in
swap_c 3 state0 = None.
Proof. 
reflexivity.
Qed.

Example test_swap_17:
let state0 := ExState [(natToWord WLen 1);(natToWord WLen 2);(natToWord WLen 3)] empty_nmap empty_nmap in
swap_c 17 state0 = None.
Proof. 
reflexivity.
Qed.

Example test_swap_16:
let state0 := ExState [(natToWord WLen 1);
                       (natToWord WLen 2);
                       (natToWord WLen 3);
                       (natToWord WLen 4);
                       (natToWord WLen 5);
                       (natToWord WLen 6);
                       (natToWord WLen 7);
                       (natToWord WLen 8);
                       (natToWord WLen 9);
                       (natToWord WLen 10);
                       (natToWord WLen 11);
                       (natToWord WLen 12);
                       (natToWord WLen 13);
                       (natToWord WLen 14);
                       (natToWord WLen 15);
                       (natToWord WLen 16);
                       (natToWord WLen 17)] empty_nmap empty_nmap in
let state1 := ExState [(natToWord WLen 17);
                       (natToWord WLen 2);
                       (natToWord WLen 3);
                       (natToWord WLen 4);
                       (natToWord WLen 5);
                       (natToWord WLen 6);
                       (natToWord WLen 7);
                       (natToWord WLen 8);
                       (natToWord WLen 9);
                       (natToWord WLen 10);
                       (natToWord WLen 11);
                       (natToWord WLen 12);
                       (natToWord WLen 13);
                       (natToWord WLen 14);
                       (natToWord WLen 15);
                       (natToWord WLen 16);
                       (natToWord WLen 1)] empty_nmap empty_nmap in
swap_c 16 state0 = Some state1.
Proof. reflexivity. Qed.


Example test_eval_asfs_1:
let asfs := SymState 2 2 [FreshVar 2] 
            [(2, SymOp NOT [FreshVar 1]);
             (1, SymOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, SymOp ADD [InStackVar 0; InStackVar 1])] in
let stack := [(natToWord WLen 5); (natToWord WLen 7)] in
eval_asfs stack asfs evm_stack_opm = Some [wnot (natToWord WLen 12)].
Proof.
reflexivity. Qed.
Example test_eval_asfs_2:
let asfs := SymState 2 2 [FreshVar 2] 
            [(2, SymOp NOT [FreshVar 1]);
             (1, SymOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, SymOp ADD [InStackVar 0; InStackVar 1])] in
let stack := [(natToWord WLen 8); (natToWord WLen 3)] in
eval_asfs stack asfs evm_stack_opm = Some [wnot (natToWord WLen 11)].
Proof.
reflexivity. Qed.
Example test_eval_asfs_3:
let asfs := SymState 2 2 [FreshVar 2] 
            [(2, SymOp NOT [FreshVar 1]);
             (1, SymOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, SymOp ADD [InStackVar 0; InStackVar 1])] in
let stack := [(natToWord WLen 2); (natToWord WLen 0)] in
eval_asfs stack asfs evm_stack_opm = Some [wnot (natToWord WLen 2)].
Proof.
reflexivity. Qed.
Example test_eval_asfs_4:
let asfs := SymState 2 2 [FreshVar 2] 
            [(2, SymOp NOT [FreshVar 1]);
             (1, SymOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, SymOp ADD [InStackVar 0; InStackVar 1])] in
let stack := [(natToWord WLen 0); (natToWord WLen 7)] in
eval_asfs stack asfs evm_stack_opm = Some [wnot (natToWord WLen 7)].
Proof. reflexivity. Qed.


Example test_eval_asfs_eq_1:
let asfs := SymState 2 2 [FreshVar 2] 
            [(2, SymOp NOT [FreshVar 1]);
             (1, SymOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, SymOp ADD [InStackVar 0; InStackVar 1])] in
eq_sstate_chkr asfs asfs evm_stack_opm = true.
Proof.
reflexivity. Qed.

Example test_eval_asfs_eq_2:
let asfs1 := SymState 2 2 [FreshVar 2] 
            [(2, SymOp NOT [FreshVar 1]);
             (1, SymOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, SymOp ADD [InStackVar 0; InStackVar 1])] in
let asfs2 := SymState 3 2 [FreshVar 2] 
            [(2, SymOp NOT [FreshVar 1]);
             (1, SymOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, SymOp ADD [InStackVar 0; InStackVar 1])] in
eq_sstate_chkr asfs1 asfs2 evm_stack_opm = false.
Proof.
reflexivity. Qed.
Example test_eval_asfs_eq_3:
let asfs1 := SymState 2 2 [FreshVar 2] 
            [(2, SymOp NOT [FreshVar 1]);
             (1, SymOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, SymOp ADD [InStackVar 0; InStackVar 1])] in
let asfs2 := SymState 2 2 [FreshVar 2] 
            [(2, SymOp NOT [FreshVar 1]);
             (1, SymOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, SymOp ADD [InStackVar 1; InStackVar 0])] in
eq_sstate_chkr asfs1 asfs2 evm_stack_opm = true.
Proof.
reflexivity. Qed.

End Tests_interpreter.


Module Tests_optimizations.


Example add_0_X_0:
let map: smap := [(100, SymOp ADD [Val WZero; FreshVar 50]); 
                      (60,  SymBasicVal (Val WZero));
                      (50,  SymBasicVal (InStackVar 8))] in
let expected_map : smap := [(100, SymBasicVal (FreshVar 50)); 
                                (60,  SymBasicVal (Val WZero));
                                (50,  SymBasicVal (InStackVar 8))] in
optimize_map_add_zero 100 map = Some (expected_map).
Proof.
reflexivity.
Qed.

Example add_0_X_0comm:
let map: smap := [(100, SymOp ADD [FreshVar 50; Val WZero]); 
                      (60,  SymBasicVal (Val WZero));
                      (50,  SymBasicVal (InStackVar 8))] in
let expected_map : smap := [(100, SymBasicVal (FreshVar 50)); 
                                (60,  SymBasicVal (Val WZero));
                                (50,  SymBasicVal (InStackVar 8))] in
optimize_map_add_zero 100 map = Some (expected_map).
Proof.
reflexivity.
Qed.

Example add_0_X_1:
let map: smap := [(100, SymOp ADD [FreshVar 75; FreshVar 50]); 
                      (75,  SymBasicVal (FreshVar 60));
                      (60,  SymBasicVal (Val WZero));
                      (50,  SymBasicVal (InStackVar 8))] in
let expected_map : smap := [(100, SymBasicVal (FreshVar 50)); 
                                (75,  SymBasicVal (FreshVar 60));
                                (60,  SymBasicVal (Val WZero));
                                (50,  SymBasicVal (InStackVar 8))] in
optimize_map_add_zero 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example add_0_X_1comm:
let map: smap := [(100, SymOp ADD [FreshVar 50;FreshVar 75]); 
                      (75,  SymBasicVal (FreshVar 60));
                      (60,  SymBasicVal (Val WZero));
                      (50,  SymBasicVal (InStackVar 8))] in
let expected_map : smap := [(100, SymBasicVal (FreshVar 50)); 
                                (75,  SymBasicVal (FreshVar 60));
                                (60,  SymBasicVal (Val WZero));
                                (50,  SymBasicVal (InStackVar 8))] in
optimize_map_add_zero 100 map = Some (expected_map).
Proof. reflexivity. Qed.


Example mul_1_X_0:
let map: smap := [(100, SymOp MUL [Val WOne; FreshVar 50]); 
                      (50,  SymBasicVal (InStackVar 8))] in
let expected_map : smap := [(100, SymBasicVal (FreshVar 50)); 
                                (50,  SymBasicVal (InStackVar 8))] in
optimize_map_mul_one 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example mul_1_X_0comm:
let map: smap := [(100, SymOp MUL [FreshVar 50; Val WOne]); 
                      (50,  SymBasicVal (InStackVar 8))] in
let expected_map : smap := [(100, SymBasicVal (FreshVar 50)); 
                                (50,  SymBasicVal (InStackVar 8))] in
optimize_map_mul_one 100 map = Some (expected_map).
Proof.
reflexivity.
Qed.

Example mul_1_X_1:
let map: smap := [(100, SymOp MUL [FreshVar 75; FreshVar 50]); 
                      (75,  SymBasicVal (FreshVar 60));
                      (60,  SymBasicVal (Val WOne));
                      (50,  SymBasicVal (InStackVar 8))] in
let expected_map : smap := [(100, SymBasicVal (FreshVar 50)); 
                                (75,  SymBasicVal (FreshVar 60));
                                (60,  SymBasicVal (Val WOne));
                                (50,  SymBasicVal (InStackVar 8))] in
optimize_map_mul_one 100 map = Some (expected_map).
Proof. reflexivity. Qed.


Example mul_1_X_1comm:
let map: smap := [(100, SymOp MUL [FreshVar 50; FreshVar 75]); 
                      (75,  SymBasicVal (FreshVar 60));
                      (60,  SymBasicVal (Val WOne));
                      (50,  SymBasicVal (InStackVar 8))] in
let expected_map : smap := [(100, SymBasicVal (FreshVar 50)); 
                                (75,  SymBasicVal (FreshVar 60));
                                (60,  SymBasicVal (Val WOne));
                                (50,  SymBasicVal (InStackVar 8))] in
optimize_map_mul_one 100 map = Some (expected_map).
Proof. reflexivity. Qed.



Example mul_0_X_0:
let map: smap := [(100, SymOp MUL [Val WZero; FreshVar 50]); 
                      (50,  SymBasicVal (InStackVar 8))] in
let expected_map : smap := [(100, SymBasicVal (Val WZero)); 
                                (50,  SymBasicVal (InStackVar 8))] in
optimize_map_mul_zero 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example mul_0_X_0comm:
let map: smap := [(100, SymOp MUL [FreshVar 50; Val WZero]); 
                      (50,  SymBasicVal (InStackVar 8))] in
let expected_map : smap := [(100, SymBasicVal (Val WZero)); 
                                (50,  SymBasicVal (InStackVar 8))] in
optimize_map_mul_zero 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example mul_0_X_1:
let map: smap := [(100, SymOp MUL [FreshVar 75; FreshVar 50]); 
                      (75,  SymBasicVal (FreshVar 60));
                      (60,  SymBasicVal (Val WZero));
                      (50,  SymBasicVal (InStackVar 8))] in
let expected_map : smap := [(100, SymBasicVal (Val WZero)); 
                                (75,  SymBasicVal (FreshVar 60));
                                (60,  SymBasicVal (Val WZero));
                                (50,  SymBasicVal (InStackVar 8))] in
optimize_map_mul_zero 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example mul_0_X_1comm:
let map: smap := [(100, SymOp MUL [FreshVar 50; FreshVar 75]); 
                      (75,  SymBasicVal (FreshVar 60));
                      (60,  SymBasicVal (Val WZero));
                      (50,  SymBasicVal (InStackVar 8))] in
let expected_map : smap := [(100, SymBasicVal (Val WZero)); 
                                (75,  SymBasicVal (FreshVar 60));
                                (60,  SymBasicVal (Val WZero));
                                (50,  SymBasicVal (InStackVar 8))] in
optimize_map_mul_zero 100 map = Some (expected_map).
Proof. reflexivity. Qed.


Example notnot_0:
let map: smap := [(100, SymOp NOT [FreshVar 75]); 
                      (75,  SymOp NOT [FreshVar 50]);
                      (50,  SymBasicVal (InStackVar 8))] in
let expected_map: smap := [(100, SymBasicVal (FreshVar 50)); 
                               (75,  SymOp NOT [FreshVar 50]);
                               (50,  SymBasicVal (InStackVar 8))] in
optimize_map_not_not 100 map = Some (expected_map).
Proof. simpl. reflexivity. Qed.

Example notnot_1:
let map: smap := [(100, SymOp NOT [FreshVar 75]); 
                      (75,  SymOp NOT [InStackVar 19]);
                      (50,  SymBasicVal (InStackVar 8))] in
let expected_map: smap := [(100, SymBasicVal (InStackVar 19)); 
                               (75,  SymOp NOT [InStackVar 19]);
                               (50,  SymBasicVal (InStackVar 8))] in
optimize_map_not_not 100 map = Some (expected_map).
Proof. simpl. reflexivity. Qed.


Example eval_0:
let map: smap := 
  [(100, SymOp MUL [Val (natToWord WLen 10); Val (natToWord WLen 10)])] in
let expected_map : smap := 
  [(100, SymBasicVal (Val (natToWord WLen 100)))] in
optimize_map_eval evm_stack_opm 100 map = Some (expected_map).
Proof. simpl. reflexivity. Qed.

Example eval_1:
let map: smap := 
  [(100, SymOp MUL [FreshVar 75; Val (natToWord WLen 10)]);
   (75, SymBasicVal (Val (natToWord WLen 2)))] in
let expected_map : smap := 
  [(100, SymBasicVal (Val (natToWord WLen 20)));
   (75, SymBasicVal (Val (natToWord WLen 2)))] in
optimize_map_eval evm_stack_opm 100 map = Some (expected_map).
Proof. simpl. reflexivity. Qed.

Example eval_2:
let map: smap := 
  [(100, SymOp ADD [FreshVar 75; FreshVar 50]);
   (75, SymBasicVal (Val (natToWord WLen 2)));
   (50, SymBasicVal (Val (natToWord WLen 7)))
  ] in
let expected_map : smap := 
  [(100, SymBasicVal (Val (natToWord WLen 9)));
   (75, SymBasicVal (Val (natToWord WLen 2)));
   (50, SymBasicVal (Val (natToWord WLen 7)))
  ] in
optimize_map_eval evm_stack_opm 100 map = Some (expected_map).
Proof. simpl. reflexivity. Qed.

Example eval_3:
let map: smap := 
  [(100, SymOp ADD [FreshVar 75; FreshVar 50]);
   (75, SymBasicVal (Val (natToWord WLen 2)));
   (50, SymBasicVal (FreshVar 25));
   (25, SymBasicVal (Val (natToWord WLen 15)))
  ] in
let expected_map : smap := 
  [(100, SymBasicVal (Val (natToWord WLen 17)));
   (75, SymBasicVal (Val (natToWord WLen 2)));
   (50, SymBasicVal (FreshVar 25));
   (25, SymBasicVal (Val (natToWord WLen 15)))
  ] in
optimize_map_eval evm_stack_opm 100 map = Some (expected_map).
Proof. simpl. reflexivity. Qed.

Example eval_4:
let map: smap := 
  [(100, SymOp SUB [Val (natToWord WLen 6); Val WOne])] in
let expected_map : smap := 
  [(100, SymBasicVal (Val (natToWord WLen 5)))] in
optimize_map_eval evm_stack_opm 100 map = Some (expected_map).
Proof. simpl. reflexivity. Qed.

Example eval_4':
let map: smap := 
  [(100, SymOp DIV [Val (natToWord WLen 6); Val WOne])] in
let expected_map : smap := 
  [(100, SymBasicVal (Val (natToWord WLen 6)))] in
optimize_map_eval evm_stack_opm 100 map = Some (expected_map).
Proof. simpl. reflexivity. Qed.


Example div1_0:
let map: smap := 
  [(100, SymOp DIV [InStackVar 5; Val WOne])] in
let expected_map : smap := 
  [(100, SymBasicVal (InStackVar 5))] in
optimize_map_div_one 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example eq0_0:
let map: smap := 
  [(100, SymOp EQ [InStackVar 5; Val WZero])] in
let expected_map : smap := 
  [(100, SymOp ISZERO [InStackVar 5])] in
optimize_map_eq_zero 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example gt1_0:
let map: smap := 
  [(100, SymOp GT [Val WOne; InStackVar 5])] in
let expected_map : smap := 
  [(100, SymOp ISZERO [InStackVar 5])] in
optimize_map_gt_one 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example or0_0:
let map: smap := 
  [(100, SymOp OR [Val WZero; InStackVar 5])] in
let expected_map : smap := 
  [(100, SymBasicVal (InStackVar 5))] in
optimize_map_or_zero 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example or0_0':
let map: smap := 
  [(100, SymOp OR [InStackVar 5; Val WZero])] in
let expected_map : smap := 
  [(100, SymBasicVal (InStackVar 5))] in
optimize_map_or_zero 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example or0_1:
let map: smap := 
  [(100, SymOp OR [InStackVar 5; FreshVar 75]);
   (75, SymBasicVal (FreshVar 50));
   (50, SymBasicVal (Val WZero))] in
let expected_map : smap := 
  [(100, SymBasicVal (InStackVar 5));
   (75, SymBasicVal (FreshVar 50));
   (50, SymBasicVal (Val WZero))] in
optimize_map_or_zero 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example subxx_0:
let map: smap := 
  [(100, SymOp SUB [InStackVar 5; InStackVar 5])] in
let expected_map : smap := 
  [(100, SymBasicVal (Val WZero))] in
optimize_map_sub_x_x 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example subxx_1:
let map: smap := 
  [(100, SymOp SUB [Val WOne; Val WOne])] in
let expected_map : smap := 
  [(100, SymBasicVal (Val WZero))] in
optimize_map_sub_x_x 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example subxx_2:
let map: smap := 
  [(100, SymOp SUB [FreshVar 75; Val WOne]);
   (75, SymBasicVal (Val WOne))] in
let expected_map : smap := 
  [(100, SymBasicVal (Val WZero));
   (75, SymBasicVal (Val WOne))] in
optimize_map_sub_x_x 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example subxx_2':
let map: smap := 
  [(100, SymOp SUB [Val WOne; FreshVar 75]);
   (75, SymBasicVal (Val WOne))] in
let expected_map : smap := 
  [(100, SymBasicVal (Val WZero));
   (75, SymBasicVal (Val WOne))] in
optimize_map_sub_x_x 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example subxx_3:
let map: smap := 
  [(100, SymOp SUB [FreshVar 75; FreshVar 50]);
   (75, SymOp ADD [Val WOne; Val WZero]);
   (50, SymOp ADD [Val WZero; Val WOne])] in
let expected_map : smap := 
  [(100, SymBasicVal (Val WZero));
   (75, SymOp ADD [Val WOne; Val WZero]);
   (50, SymOp ADD [Val WZero; Val WOne])] in
optimize_map_sub_x_x 100 map = Some (expected_map).
Proof. reflexivity. Qed.



Example iszero3_1:
let map: smap := 
  [(100, SymOp ISZERO [FreshVar 75]);
   (75, SymOp ISZERO [FreshVar 50]);
   (50, SymOp ISZERO [InStackVar 0])] in
let expected_map : smap := 
  [(100, SymOp ISZERO [InStackVar 0]);
   (75, SymOp ISZERO [FreshVar 50]);
   (50, SymOp ISZERO [InStackVar 0])] in
optimize_map_iszero3 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example iszero3_2:
let map: smap := 
  [(100, SymOp ISZERO [FreshVar 75]);
   (75, SymBasicVal (FreshVar 60));
   (60, SymOp ISZERO [FreshVar 50]);
   (50, SymOp ISZERO [InStackVar 0])] in
let expected_map : smap := 
  [(100, SymOp ISZERO [InStackVar 0]);
   (75, SymBasicVal (FreshVar 60));
   (60, SymOp ISZERO [FreshVar 50]);
   (50, SymOp ISZERO [InStackVar 0])] in
optimize_map_iszero3 100 map = Some (expected_map).
Proof. simpl. reflexivity. Qed.

Example iszero3_3:
let map: smap := 
  [(100, SymOp ISZERO [FreshVar 75]);
   (75, SymBasicVal (FreshVar 60));
   (60, SymOp ISZERO [FreshVar 50]);
   (50, SymBasicVal (FreshVar 25));
   (25, SymOp ISZERO [InStackVar 9])] in
let expected_map : smap := 
  [(100, SymOp ISZERO [InStackVar 9]);
   (75, SymBasicVal (FreshVar 60));
   (60, SymOp ISZERO [FreshVar 50]);
   (50, SymBasicVal (FreshVar 25));
   (25, SymOp ISZERO [InStackVar 9])] in
optimize_map_iszero3 100 map = Some (expected_map).
Proof. simpl. reflexivity. Qed.



Example and_and_l_1:
let map: smap := 
  [(100, SymOp AND [FreshVar 75;InStackVar 8]);
   (75, SymOp AND [Val WOne;InStackVar 8])] in
let expected_map : smap := 
  [(100, SymOp AND [Val WOne;InStackVar 8]);
   (75, SymOp AND [Val WOne;InStackVar 8])] in
optimize_map_and_and_l 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example and_and_l_2:
let map: smap := 
  [(100, SymOp AND [FreshVar 75;InStackVar 8]);
   (75, SymOp AND [InStackVar 8;Val WOne])] in
let expected_map : smap := 
  [(100, SymOp AND [InStackVar 8;Val WOne]);
   (75, SymOp AND [InStackVar 8;Val WOne])] in
optimize_map_and_and_l 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example and_and_l_3:
let map: smap := 
  [(100, SymOp AND [FreshVar 75;InStackVar 8]);
   (75, SymOp AND [InStackVar 19;FreshVar 50]);
   (50, SymBasicVal (InStackVar 8))] in
let expected_map : smap := 
  [(100, SymOp AND [InStackVar 19;FreshVar 50]);
   (75, SymOp AND [InStackVar 19;FreshVar 50]);
   (50, SymBasicVal (InStackVar 8))] in
optimize_map_and_and_l 100 map = Some (expected_map).
Proof. reflexivity. Qed.




Example and_and_r_1:
let map: smap := 
  [(100, SymOp AND [InStackVar 8; FreshVar 75]);
   (75, SymOp AND [Val WOne;InStackVar 8])] in
let expected_map : smap := 
  [(100, SymOp AND [Val WOne;InStackVar 8]);
   (75, SymOp AND [Val WOne;InStackVar 8])] in
optimize_map_and_and_r 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example and_and_r_2:
let map: smap := 
  [(100, SymOp AND [InStackVar 8;FreshVar 75]);
   (75, SymOp AND [InStackVar 8;Val WOne])] in
let expected_map : smap := 
  [(100, SymOp AND [InStackVar 8;Val WOne]);
   (75, SymOp AND [InStackVar 8;Val WOne])] in
optimize_map_and_and_r 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example and_and_r_3:
let map: smap := 
  [(100, SymOp AND [InStackVar 8;FreshVar 75]);
   (75, SymOp AND [InStackVar 19;FreshVar 50]);
   (50, SymBasicVal (InStackVar 8))] in
let expected_map : smap := 
  [(100, SymOp AND [InStackVar 19;FreshVar 50]);
   (75, SymOp AND [InStackVar 19;FreshVar 50]);
   (50, SymBasicVal (InStackVar 8))] in
optimize_map_and_and_r 100 map = Some (expected_map).
Proof. reflexivity. Qed.


Example lt1_0:
let map: smap := 
  [(100, SymOp LT [InStackVar 5;Val WOne])] in
let expected_map : smap := 
  [(100, SymOp ISZERO [InStackVar 5])] in
optimize_map_lt_one 100 map = Some (expected_map).
Proof. reflexivity. Qed.

Example lt1_1:
let map: smap := 
  [(100, SymOp LT [InStackVar 5;FreshVar 4]);
   (4, SymBasicVal (Val WOne))] in
let expected_map : smap := 
  [(100, SymOp ISZERO [InStackVar 5]);
   (4, SymBasicVal (Val WOne))] in
optimize_map_lt_one 100 map = Some (expected_map).
Proof. reflexivity. Qed.



(* Counterexample for the NOT_NOT optimization with an arbitrary map with
   repetitions *)
Example counterexample_notnot_any_ASFS:
let map: smap := [(100, SymOp NOT [FreshVar 75]); 
                      (50,  SymBasicVal (Val WZero));
                      (75,  SymOp NOT [FreshVar 50]);
                      (50,  SymBasicVal (Val WOne))] in
let opt_map: smap := [(100, SymBasicVal (FreshVar 50)); 
                          (50,  SymBasicVal (Val WZero));
                          (75,  SymOp NOT [FreshVar 50]);
                          (50,  SymBasicVal (Val WOne))] in
let some_map2 := optimize_map_not_not 100 map in
eval_asfs2_elem [] (FreshVar 100) map evm_stack_opm = Some WOne /\
some_map2 = Some opt_map /\
eval_asfs2_elem [] (FreshVar 100) opt_map evm_stack_opm = Some WZero.
Proof.
split; try (split; reflexivity).
Qed.


End Tests_optimizations.


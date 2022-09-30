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
let asfs := ASFSc 2 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 0; InStackVar 1])] in
let stack := [(natToWord WLen 5); (natToWord WLen 7)] in
eval_asfs stack asfs opmap = Some [wnot (natToWord WLen 12)].
Proof.
reflexivity. Qed.
Example test_eval_asfs_2:
let asfs := ASFSc 2 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 0; InStackVar 1])] in
let stack := [(natToWord WLen 8); (natToWord WLen 3)] in
eval_asfs stack asfs opmap = Some [wnot (natToWord WLen 11)].
Proof.
reflexivity. Qed.
Example test_eval_asfs_3:
let asfs := ASFSc 2 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 0; InStackVar 1])] in
let stack := [(natToWord WLen 2); (natToWord WLen 0)] in
eval_asfs stack asfs opmap = Some [wnot (natToWord WLen 2)].
Proof.
reflexivity. Qed.
Example test_eval_asfs_4:
let asfs := ASFSc 2 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 0; InStackVar 1])] in
let stack := [(natToWord WLen 0); (natToWord WLen 7)] in
eval_asfs stack asfs opmap = Some [wnot (natToWord WLen 7)].
Proof. reflexivity. Qed.


Example test_eval_asfs_eq_1:
let asfs := ASFSc 2 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 0; InStackVar 1])] in
asfs_eq asfs asfs opmap = true.
Proof.
reflexivity. Qed.

Example test_eval_asfs_eq_2:
let asfs1 := ASFSc 2 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 0; InStackVar 1])] in
let asfs2 := ASFSc 3 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 0; InStackVar 1])] in
asfs_eq asfs1 asfs2 opmap = false.
Proof.
reflexivity. Qed.
Example test_eval_asfs_eq_3:
let asfs1 := ASFSc 2 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 0; InStackVar 1])] in
let asfs2 := ASFSc 2 2 [FreshVar 2] 
            [(2, ASFSOp NOT [FreshVar 1]);
             (1, ASFSOp ADD [Val (natToWord WLen 0); FreshVar 0]);
             (0, ASFSOp ADD [InStackVar 1; InStackVar 0])] in
asfs_eq asfs1 asfs2 opmap = true.
Proof.
reflexivity. Qed.

End Tests_interpreter.


Module Tests_optimizations.


(* Counterexample for the NOT_NOT optimization with an arbitrary map with
   repetitions *)
Example counterexample_notnot_any_ASFS:
let map: asfs_map := [(100, ASFSOp NOT [FreshVar 75]); 
                      (50,  ASFSBasicVal (Val WZero));
                      (75,  ASFSOp NOT [FreshVar 50]);
                      (50,  ASFSBasicVal (Val WOne))] in
let opt_map: asfs_map := [(100, ASFSBasicVal (FreshVar 50)); 
                          (50,  ASFSBasicVal (Val WZero));
                          (75,  ASFSOp NOT [FreshVar 50]);
                          (50,  ASFSBasicVal (Val WOne))] in
let some_map2 := optimize_map_not_not 100 map in
eval_asfs2_elem [] (FreshVar 100) map opmap = Some WOne /\
some_map2 = Some opt_map /\
eval_asfs2_elem [] (FreshVar 100) opt_map opmap = Some WZero.
Proof.
split; try (split; reflexivity).
Qed.


End Tests_optimizations.


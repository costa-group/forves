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



Module Examples.
(* CONCRETE EXECUTION *)
Definition W0  := natToWord WLen 0.
Definition W1  := natToWord WLen 1.
Definition W2  := natToWord WLen 2.
Definition W3  := natToWord WLen 3.
Definition W4  := natToWord WLen 4.
Definition W5  := natToWord WLen 5.
Definition W6  := natToWord WLen 6.
Definition W7  := natToWord WLen 7.
Definition W8  := natToWord WLen 8.
Definition W9  := natToWord WLen 9.
Definition W10 := natToWord WLen 10.


Compute (
let es := ExState [] empty_nmap empty_nmap
in let block := [PUSH 32 W0;
                PUSH 32 W5;
                Opcode ADD]
in concr_interpreter block es evm_stack_opm
).


Compute (
let es := ExState [] empty_nmap empty_nmap
in let block := [PUSH 32 W5;
                PUSH 32 W0;
                Opcode ADD;
                PUSH 32 W1;
                Opcode MUL]
in concr_interpreter block es evm_stack_opm
).


Compute (
let es := ExState [W7; W7] empty_nmap empty_nmap
in let block := [PUSH 32 W0;
                Opcode ADD;
                PUSH 32 W2;
                Opcode MUL]
in concr_interpreter block es evm_stack_opm
).


Compute (
let es := ExState [W5; W1; W2] empty_nmap empty_nmap
in let block := [Opcode ADD;
                Opcode MUL]
in concr_interpreter block es evm_stack_opm
).




(* SYMBOLIC EXECUTION *)
Compute (
let block := [PUSH 32 W0;
             PUSH 32 W5;
             Opcode ADD]
in symbolic_exec block 0 evm_stack_opm
).


Compute (
let block := [PUSH 32 W5;
             PUSH 32 W0;
             Opcode ADD;
             PUSH 32 W1;
             Opcode MUL]
in symbolic_exec block 0 evm_stack_opm
).


Compute (
let block := [PUSH 32 W0;
             Opcode ADD;
             PUSH 32 W2;
             Opcode MUL]
in symbolic_exec block 2 evm_stack_opm
).
(*
 [FreshVar 1; InStackVar 1]
 +
 MAP: [FreshVar 1 |-> MUL 2 (FreshVar 0) 
       FreshVar 0 |-> ADD 0 (InStackVar 0)
      ]
*)


Compute (
let block := [Opcode ADD;
             Opcode MUL]
in symbolic_exec block 3 evm_stack_opm
).



(* OPTIMIZATIONS ON ASFS *)
Compute (
let a := SymState 1 1 [FreshVar 0] [(0, SymOp ADD [Val W0; InStackVar 0])] in
optimize_add_zero a
).

Compute (
let a := SymState 1 1 [FreshVar 0] [(0, SymOp MUL [Val W0; InStackVar 0])] in
optimize_add_zero a
).


Compute (
let a := SymState 1 1 [FreshVar 0] [(0, SymOp MUL [InStackVar 0; Val W0])] in
optimize_mul_zero a
).

Compute (
let a := SymState 1 1 [FreshVar 0] [(0, SymOp MUL [InStackVar 0; Val W1])] in
optimize_mul_one a
).

Compute (
let a := SymState 1 2 [FreshVar 1] [(1, SymOp NOT [FreshVar 0]);
                                 (0, SymOp NOT [InStackVar 0])] in
optimize_not_not a
).



(* CHECKER *)
Example checker_ex1:
let optimized_p := [PUSH 32 W5] in
let p := [PUSH 32 W5] in
let stack_size := 10 in
let opt := apply_pipeline_n_times our_optimization_pipeline 20 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. auto. Qed.

Example checker_ex2:
let optimized_p := [PUSH 32 W6] in
let p := [PUSH 32 W5] in
let stack_size := 10 in
let opt := apply_pipeline_n_times our_optimization_pipeline 20 in
evm_eq_block_chkr' opt optimized_p p stack_size = false.
Proof. auto. Qed.

Example checker_ex3:
let optimized_p := [PUSH 32 W5] in
let p := [PUSH 32 W5;
          PUSH 32 W6;
          POP] in
let stack_size := 10 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. auto. Qed.

Example checker_ex3_comm:
let optimized_p := [PUSH 32 W6;
                    PUSH 32 W5;
                    Opcode ADD] in
let p := [PUSH 32 W5;
          PUSH 32 W6;
          Opcode ADD] in
let stack_size := 10 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr optimized_p p stack_size = true.
Proof. auto. Qed.


Example checker_ex3_comm_eval:
let p := [PUSH 32 W6; PUSH 32 W5; Opcode ADD] in
let optimized_p := [PUSH 32 (natToWord WLen 11)] in
let stack_size := 10 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_eval1:
let p := [PUSH 32 W5; PUSH 32 W5; Opcode ADD;
          PUSH 32 W2; Opcode MUL] in
let optimized_p := [PUSH 32 (natToWord WLen 20)] in
let stack_size := 3 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_eval1':
let p := [PUSH 32 W4; PUSH 32 W5; Opcode ADD;
          PUSH 32 W2; DUP 1; Opcode MUL] in
let optimized_p := [PUSH 32 W9; PUSH 32 W4] in
let stack_size := 4 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. reflexivity. Qed.


Example checker_ex4:
let optimized_p := [PUSH 32 W5] in
let p := [PUSH 32 W0;
          PUSH 32 W5;
          Opcode ADD] in
let stack_size := 0 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. auto. Qed.

Example checker_ex4b:
let optimized_p := [PUSH 32 W5; Opcode ADD] in
let p := [PUSH 32 W0;
          Opcode ADD;
          PUSH 32 W5;
          Opcode ADD] in
let stack_size := 1 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. auto. Qed.

Example checker_ex5:
let optimized_p := [PUSH 32 W5] in
let p := [PUSH 32 W5;
          PUSH 32 W0;
          Opcode ADD;
          PUSH 32 W1;
          Opcode MUL] in
let stack_size := 0 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. auto. Qed.

Example checker_ex6:
let optimized_p := [PUSH 32 W5] in
let p := [PUSH 32 W1;
          PUSH 32 W5;
          PUSH 32 W0;
          Opcode ADD;
          Opcode MUL] in
let stack_size := 0 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. auto. Qed.

Example checker_ex_div1:
let optimized_p := [PUSH 32 W6] in
let p := [PUSH 32 W1;
          PUSH 32 W6;
          Opcode DIV] in
let stack_size := 1 in
evm_eq_block_chkr' optimize_div_one optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_div2:
let optimized_p := [] in
let p := [PUSH 32 W1; SWAP 1; Opcode DIV] in
let stack_size := 1 in
evm_eq_block_chkr' optimize_div_one optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_div2':
let optimized_p := [] in
let p := [PUSH 32 W1; SWAP 1; Opcode DIV] in
let stack_size := 1 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. reflexivity. Qed.


Example checker_ex_eq0_1:
let p := [PUSH 32 W0; PUSH 32 W5; Opcode EQ] in
let optimized_p := [PUSH 32 W5; Opcode ISZERO] in
let stack_size := 0 in
evm_eq_block_chkr' optimize_eq_zero optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_eq0_2:
let p := [PUSH 32 W5; PUSH 32 W0; Opcode EQ] in
let optimized_p := [PUSH 32 W5; Opcode ISZERO] in
let stack_size := 0 in
evm_eq_block_chkr' optimize_eq_zero optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_eq0_3:
let p := [PUSH 32 W0; Opcode EQ] in
let optimized_p := [Opcode ISZERO] in
let stack_size := 2 in
evm_eq_block_chkr' optimize_eq_zero optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_eq0_4:
let p := [PUSH 32 W0; Opcode MUL; Opcode EQ] in
let optimized_p := [POP; Opcode ISZERO] in
let stack_size := 2 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. reflexivity. Qed.


Example checker_ex_gt1_1:
let p := [PUSH 32 W5; PUSH 32 W1; Opcode GT] in
let optimized_p := [PUSH 32 W5; Opcode ISZERO] in
let stack_size := 0 in
evm_eq_block_chkr' optimize_gt_one optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_gt1_2:
let p := [PUSH 32 W1; Opcode GT] in
let optimized_p := [Opcode ISZERO] in
let stack_size := 2 in
evm_eq_block_chkr' optimize_gt_one optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_gt1_3:
let p := [PUSH 32 W1; PUSH 32 W0; Opcode ADD; Opcode GT] in
let optimized_p := [Opcode ISZERO] in
let stack_size := 2 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. reflexivity. Qed.




Example checker_ex_lt1_1:
let p := [PUSH 32 W1; PUSH 32 W5; Opcode LT] in
let optimized_p := [PUSH 32 W5; Opcode ISZERO] in
let stack_size := 0 in
evm_eq_block_chkr' optimize_lt_one optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_lt1_2:
let p := [PUSH 32 W1; SWAP 1; Opcode LT] in
let optimized_p := [Opcode ISZERO] in
let stack_size := 2 in
evm_eq_block_chkr' optimize_lt_one optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_lt1_3:
let p := [PUSH 32 W1; PUSH 32 W0; Opcode ADD; SWAP 1; Opcode LT] in
let optimized_p := [Opcode ISZERO] in
let stack_size := 2 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. reflexivity. Qed.






Example checker_ex_or0_1:
let p := [PUSH 32 W0; PUSH 32 W5; Opcode OR] in
let optimized_p := [PUSH 32 W5] in
let stack_size := 0 in
evm_eq_block_chkr' optimize_or_zero optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_or0_1':
let p := [PUSH 32 W5; PUSH 32 W0; Opcode OR] in
let optimized_p := [PUSH 32 W5] in
let stack_size := 0 in
evm_eq_block_chkr' optimize_or_zero optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_or0_2:
let p := [PUSH 32 W0; Opcode OR] in
let optimized_p := [] in
let stack_size := 5 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_or0_3:
let p := [PUSH 32 W0; Opcode MUL; Opcode OR] in
let optimized_p := [POP] in
let stack_size := 5 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. reflexivity. Qed.


Example checker_ex_subxx_0:
let p := [PUSH 32 W5; PUSH 32 W5; Opcode SUB] in
let optimized_p := [PUSH 32 W0] in
let stack_size := 0 in
evm_eq_block_chkr' optimize_sub_x_x optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_subxx_1:
let p := [PUSH 32 W3; PUSH 32 W2; Opcode ADD;
          PUSH 32 W2; PUSH 32 W3; Opcode ADD;
          Opcode SUB] in
let optimized_p := [PUSH 32 W0] in
let stack_size := 0 in
evm_eq_block_chkr' optimize_sub_x_x optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_subxx_2:
let p := [PUSH 32 W3; PUSH 32 W2; Opcode ADD;
          PUSH 32 W5; PUSH 32 W1; Opcode MUL;
          Opcode SUB] in
let optimized_p := [PUSH 32 W0] in
let stack_size := 0 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. reflexivity. Qed.



Example checker_ex_iszero3_0:
let p := [Opcode ISZERO; Opcode ISZERO; Opcode ISZERO] in
let optimized_p := [Opcode ISZERO] in
let stack_size := 7 in
evm_eq_block_chkr' optimize_iszero3 optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_iszero3_1:
let p := [PUSH 32 WZero; Opcode ISZERO; Opcode ISZERO; Opcode ISZERO] in
let optimized_p := [PUSH 32 WOne] in
let stack_size := 3 in
let opt := apply_pipeline_n_times our_optimization_pipeline 20 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. simpl. reflexivity. Qed.

Example checker_counterex_iszero3_2:
(* REASON: optimized_p is optimized applying "iszero3" but it does not apply the
   last possible "eval" optimization *)
let p := [PUSH 32 WZero; Opcode ISZERO; Opcode ISZERO; Opcode ISZERO] in
let optimized_p := [PUSH 32 WZero; Opcode ISZERO] in
let stack_size := 3 in
let opt := apply_pipeline_n_times our_optimization_pipeline 20 in
evm_eq_block_chkr' opt optimized_p p stack_size = false.
Proof. simpl. reflexivity. Qed.



Example checker_ex_and_and_l_0:
let p := [DUP 2; Opcode AND; Opcode AND] in
let optimized_p := [Opcode AND] in
let stack_size := 2 in
evm_eq_block_chkr' optimize_and_and_l optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_and_and_l_1:
let p := [PUSH 32 W5; PUSH 32 W1; PUSH 32 W5; Opcode AND; Opcode AND] in
let optimized_p := [PUSH 32 W1; PUSH 32 W5; Opcode AND] in
let stack_size := 0 in
evm_eq_block_chkr' optimize_and_and_l optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_and_and_l_2:
let p := [PUSH 32 W5; PUSH 32 W1; PUSH 32 W5; Opcode AND; Opcode AND] in
let optimized_p := [PUSH 32 W1] in
let stack_size := 0 in
let opt := apply_pipeline_n_times our_optimization_pipeline 20 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_and_and_l_3:
let p := [DUP 2; PUSH 32 W1; Opcode MUL; Opcode AND; Opcode AND] in
let optimized_p := [Opcode AND] in
let stack_size := 2 in
let opt := apply_pipeline_n_times our_optimization_pipeline 20 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. reflexivity. Qed.



Example checker_ex_and_and_r_0:
let p := [DUP 2; Opcode AND; SWAP 1; Opcode AND] in
let optimized_p := [Opcode AND] in
let stack_size := 2 in
evm_eq_block_chkr' optimize_and_and_r optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_and_and_r_1:
let p := [PUSH 32 W5; PUSH 32 W1; Opcode AND; PUSH 32 W5; Opcode AND] in
let optimized_p := [PUSH 32 W5; PUSH 32 W1; Opcode AND] in
let stack_size := 0 in
evm_eq_block_chkr' optimize_and_and_r optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_and_and_r_2:
let p := [PUSH 32 W5; PUSH 32 W1; Opcode AND; PUSH 32 W5; Opcode AND] in
let optimized_p := [PUSH 32 W1] in
let stack_size := 0 in
let opt := apply_pipeline_n_times our_optimization_pipeline 20 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. reflexivity. Qed.

Example checker_ex_and_and_r_3:
let p := [DUP 2; PUSH 32 W1; Opcode MUL; Opcode AND; SWAP 1; Opcode AND] in
let optimized_p := [Opcode AND] in
let stack_size := 2 in
let opt := apply_pipeline_n_times our_optimization_pipeline 20 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. reflexivity. Qed.






Example checker_ex_real:
(* BottleCastle_initial_block_3_2*)
let p := [DUP 2; Opcode ADD; SWAP 1; PUSH 32 W4; SWAP 2; SWAP 1; PUSH 32 W5] in
let optimized_p := [DUP 2; Opcode ADD; PUSH 32 W4; SWAP 2; PUSH 32 W5] in
let stack_size := 5 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size = true.
Proof. auto. Qed.


(*  Bool returning expression versions of Previous Tests, 
    in order to be extracted and
    tested in Ocaml 
*)

Example checker_ex1_bool :=
let optimized_p := [PUSH 32 W5] in
let p := [PUSH 32 W5] in
let stack_size := 10 in
let opt := apply_pipeline_n_times our_optimization_pipeline 20 in
evm_eq_block_chkr' opt optimized_p p stack_size.

Example checker_ex2_bool :=
let optimized_p := [PUSH 32 W6] in
let p := [PUSH 32 W5] in
let stack_size := 10 in
let opt := apply_pipeline_n_times our_optimization_pipeline 20 in
evm_eq_block_chkr' opt optimized_p p stack_size.

Example checker_ex3_bool :=
let optimized_p := [PUSH 32 W5] in
let p := [PUSH 32 W5;
          PUSH 32 W6;
          POP] in
let stack_size := 10 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size.

Example checker_ex3_comm_bool :=
let optimized_p := [PUSH 32 W6;
                    PUSH 32 W5;
                    Opcode ADD] in
let p := [PUSH 32 W5;
          PUSH 32 W6;
          Opcode ADD] in
let stack_size := 10 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size.

Example checker_ex4_bool :=
let optimized_p := [PUSH 32 W5] in
let p := [PUSH 32 W0;
          PUSH 32 W5;
          Opcode ADD] in
let stack_size := 0 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size.

Example checker_ex4b_bool :=
let optimized_p := [PUSH 32 W5; Opcode ADD] in
let p := [PUSH 32 W0;
          Opcode ADD;
          PUSH 32 W5;
          Opcode ADD] in
let stack_size := 1 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size.

Example checker_ex5_bool :=
let optimized_p := [PUSH 32 W5] in
let p := [PUSH 32 W5;
          PUSH 32 W0;
          Opcode ADD;
          PUSH 32 W1;
          Opcode MUL] in
let stack_size := 0 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size.

Example checker_ex6_bool :=
let optimized_p := [PUSH 32 W5] in
let p := [PUSH 32 W1;
          PUSH 32 W5;
          PUSH 32 W0;
          Opcode ADD;
          Opcode MUL] in
let stack_size := 0 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size.

Example checker_ex_real_bool :=
(* BottleCastle_initial_block_3_2*)
let p := [DUP 2; Opcode ADD; SWAP 1; PUSH 32 W4; SWAP 2; SWAP 1; PUSH 32 W5] in
let optimized_p := [DUP 2; Opcode ADD; PUSH 32 W4; SWAP 2; PUSH 32 W5] in
let stack_size := 5 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
evm_eq_block_chkr' opt optimized_p p stack_size.

End Examples.

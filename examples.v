Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import List.
Require Import Coq_EVM.optimizations.
Import Optimizations.
Require Import Coq_EVM.datatypes.
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
in concr_interpreter block es opmap
).


Compute (
let es := ExState [] empty_nmap empty_nmap
in let block := [PUSH 32 W5;
                PUSH 32 W0;
                Opcode ADD;
                PUSH 32 W1;
                Opcode MUL]
in concr_interpreter block es opmap
).


Compute (
let es := ExState [W7; W7] empty_nmap empty_nmap
in let block := [PUSH 32 W0;
                Opcode ADD;
                PUSH 32 W2;
                Opcode MUL]
in concr_interpreter block es opmap
).


Compute (
let es := ExState [W5; W1; W2] empty_nmap empty_nmap
in let block := [Opcode ADD;
                Opcode MUL]
in concr_interpreter block es opmap
).




(* SYMBOLIC EXECUTION *)
Compute (
let block := [PUSH 32 W0;
             PUSH 32 W5;
             Opcode ADD]
in symbolic_exec block 0 opmap
).


Compute (
let block := [PUSH 32 W5;
             PUSH 32 W0;
             Opcode ADD;
             PUSH 32 W1;
             Opcode MUL]
in symbolic_exec block 0 opmap
).


Compute (
let block := [PUSH 32 W0;
             Opcode ADD;
             PUSH 32 W2;
             Opcode MUL]
in symbolic_exec block 2 opmap
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
in symbolic_exec block 3 opmap
).



(* OPTIMIZATIONS ON ASFS *)
Compute (
let a := ASFSc 1 1 [FreshVar 0] [(0, ASFSOp ADD [Val W0; InStackVar 0])] in
optimize_add_zero a
).

Compute (
let a := ASFSc 1 1 [FreshVar 0] [(0, ASFSOp MUL [Val W0; InStackVar 0])] in
optimize_add_zero a
).


Compute (
let a := ASFSc 1 1 [FreshVar 0] [(0, ASFSOp MUL [InStackVar 0; Val W0])] in
optimize_mul_zero a
).

Compute (
let a := ASFSc 1 1 [FreshVar 0] [(0, ASFSOp MUL [InStackVar 0; Val W1])] in
optimize_mul_one a
).

Compute (
let a := ASFSc 1 2 [FreshVar 1] [(1, ASFSOp NOT [FreshVar 0]);
                                 (0, ASFSOp NOT [InStackVar 0])] in
optimize_not_not a
).



(* CHECKER *)
Example checker_ex1:
let optimized_p := [PUSH 32 W5] in
let p := [PUSH 32 W5] in
let stack_size := 10 in
let opt := apply_pipeline_n_times our_optimization_pipeline 20 in
equiv_checker optimized_p p stack_size opt = true.
Proof. auto. Qed.

Example checker_ex2:
let optimized_p := [PUSH 32 W6] in
let p := [PUSH 32 W5] in
let stack_size := 10 in
let opt := apply_pipeline_n_times our_optimization_pipeline 20 in
equiv_checker optimized_p p stack_size opt = false.
Proof. auto. Qed.

Example checker_ex3:
let optimized_p := [PUSH 32 W5] in
let p := [PUSH 32 W5;
          PUSH 32 W6;
          POP] in
let stack_size := 10 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
equiv_checker optimized_p p stack_size opt = true.
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
equiv_checker optimized_p p stack_size opt = true.
Proof. auto. Qed.

Example checker_ex4:
let optimized_p := [PUSH 32 W5] in
let p := [PUSH 32 W0;
          PUSH 32 W5;
          Opcode ADD] in
let stack_size := 0 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
equiv_checker optimized_p p stack_size opt = true.
Proof. auto. Qed.

Example checker_ex4b:
let optimized_p := [PUSH 32 W5; Opcode ADD] in
let p := [PUSH 32 W0;
          Opcode ADD;
          PUSH 32 W5;
          Opcode ADD] in
let stack_size := 1 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
equiv_checker optimized_p p stack_size opt = true.
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
equiv_checker optimized_p p stack_size opt = true.
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
equiv_checker optimized_p p stack_size opt = true.
Proof. auto. Qed.






Example checker_ex_real:
(* BottleCastle_initial_block_3_2*)
let p := [DUP 2; Opcode ADD; SWAP 1; PUSH 32 W4; SWAP 2; SWAP 1; PUSH 32 W5] in
let opt_p := [DUP 2; Opcode ADD; PUSH 32 W4; SWAP 2; PUSH 32 W5] in
let stack_size := 5 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
equiv_checker opt_p p stack_size opt = true.
Proof. auto. Qed.

End Examples.

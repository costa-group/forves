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

(* CHECKER *)
Example checker_ex1:
let optimized_p := [PUSH 32 (natToWord WLen 5)] in
let p := [PUSH 32 (natToWord WLen 5)] in
let stack_size := 10 in
let opt := apply_pipeline_n_times our_optimization_pipeline 20 in
equiv_checker optimized_p p stack_size opt = true.
Proof. auto. Qed.

Example checker_ex2:
let optimized_p := [PUSH 32 (natToWord WLen 6)] in
let p := [PUSH 32 (natToWord WLen 5)] in
let stack_size := 10 in
let opt := apply_pipeline_n_times our_optimization_pipeline 20 in
equiv_checker optimized_p p stack_size opt = false.
Proof. auto. Qed.

Example checker_ex3:
let optimized_p := [PUSH 32 (natToWord WLen 5)] in
let p := [PUSH 32 (natToWord WLen 5);
          PUSH 32 (natToWord WLen 6);
          POP] in
let stack_size := 10 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
equiv_checker optimized_p p stack_size opt = true.
Proof. auto. Qed.

Example checker_ex4:
let optimized_p := [PUSH 32 (natToWord WLen 5)] in
let p := [PUSH 32 (natToWord WLen 0);
          PUSH 32 (natToWord WLen 5);
          Opcode ADD] in
let stack_size := 0 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
equiv_checker optimized_p p stack_size opt = true.
Proof. auto. Qed.

Example checker_ex5:
let optimized_p := [PUSH 32 (natToWord WLen 5)] in
let p := [PUSH 32 (natToWord WLen 5);
          PUSH 32 (natToWord WLen 0);
          Opcode ADD;
          PUSH 32 WOne;
          Opcode MUL] in
let stack_size := 0 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
equiv_checker optimized_p p stack_size opt = true.
Proof. auto. Qed.

Example checker_ex6:
let optimized_p := [PUSH 32 (natToWord WLen 5)] in
let p := [PUSH 32 WOne;
          PUSH 32 (natToWord WLen 5);
          PUSH 32 (natToWord WLen 0);
          Opcode ADD;
          Opcode MUL] in
let stack_size := 0 in
let opt := apply_pipeline_n_times our_optimization_pipeline 10 in
equiv_checker optimized_p p stack_size opt = true.
Proof. auto. Qed.




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
in let prog := [PUSH 32 W0;
                PUSH 32 W5;
                Opcode ADD]
in concr_interpreter prog es opmap
).


Compute (
let es := ExState [] empty_nmap empty_nmap
in let prog := [PUSH 32 W5;
                PUSH 32 W0;
                Opcode ADD;
                PUSH 32 W1;
                Opcode MUL]
in concr_interpreter prog es opmap
).


Compute (
let es := ExState [W7; W7] empty_nmap empty_nmap
in let prog := [PUSH 32 W0;
                Opcode ADD;
                PUSH 32 W2;
                Opcode MUL]
in concr_interpreter prog es opmap
).


Compute (
let es := ExState [W5; W1; W2] empty_nmap empty_nmap
in let prog := [Opcode ADD;
                Opcode MUL]
in concr_interpreter prog es opmap
).




(* SYMBOLIC EXECUTION *)
Compute (
let prog := [PUSH 32 W0;
             PUSH 32 W5;
             Opcode ADD]
in symbolic_exec prog 0 opmap
).


Compute (
let prog := [PUSH 32 W5;
             PUSH 32 W0;
             Opcode ADD;
             PUSH 32 W1;
             Opcode MUL]
in symbolic_exec prog 0 opmap
).


Compute (
let prog := [PUSH 32 W0;
             Opcode ADD;
             PUSH 32 W2;
             Opcode MUL]
in symbolic_exec prog 2 opmap
).


Compute (
let prog := [Opcode ADD;
             Opcode MUL]
in symbolic_exec prog 3 opmap
).




End Examples.
Import Examples.
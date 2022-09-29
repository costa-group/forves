(** NOTES:

  Some problems related to type extraction:
   
   - Types like bool, list and prod have straight forward representations
   in Ocaml. nat by other hand, is extracted and represented in a naive
   way, that might not be efficient for certain applications.
   Also, if we extract it as an ocaml int, we would lose consistency
   with w.r.t. to the proven theorems.
   
   Ways of addressing this problem are avaiable here:
   https://softwarefoundations.cis.upenn.edu/vfa-current/Extract.html
   
   Currently, no fancy nat extraction might be enough.
 

    TODO:

    - Extract option
    - Extract nat into an efficient type.
    - Extract bbv library Word into an efficient type. *)


(* Standar Library *)
Require Import List.
Import ListNotations.

(* Our Modules *)
Require Import Coq_EVM.definitions. 
Import EVM_Def Concrete Abstract Optimizations.
Require Import Coq_EVM.interpreter.
Import Interpreter SFS.
Require Import Coq_EVM.optimizations.
Import Optimizations. (* JOSEBA: Change module names to avoid naming collision*)
Require Import Coq_EVM.checker.
Import Checker. 
Require Import Coq_EVM.examples.
Import Examples.

(* Program Extraction: OCaml as default *) 
Import Extraction.


(** Type Extractions **)
Extract Inductive bool => "bool" [ "true" "false" ].
Extract Inductive list => "list" [ "[]" "(::)" ].
Extract Inductive prod => "( * )" [ "( , )" ].

(** Program Extractions **)
(*  Examples from example.v are extracted and directly tested.
    After running the next line, use "make run" in order to compile and
    run the test_examples.ml file. *)
Extraction Examples.
Extraction "extraction/examples.ml" Examples. 

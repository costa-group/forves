


(* Our ModuleS *)
Require Import Coq_EVM.datatypes. 
Import EVM_Def Concrete Abstract Optimizations.

Require Import Coq_EVM.interpreter.
Import Interpreter SFS.

Require Import Coq_EVM.optimizations.
Import Optimizations. (* JOSEBA: Change module names to avoid naming collision*)

Require Import Coq_EVM.checker.
Import Checker. 


(* Program Extraction: OCaml as default *) 
Import Extraction.


(** JOSEBA:

  Some problems related to type extraction:
   Types like bool, list and prod have straight forward representations
   in Ocaml, that are consistent by default with Coq.
    
   Is not the case for the type nat. This task can be tricky. This is currently
   archieved using recommendations from:
   https://softwarefoundations.cis.upenn.edu/vfa-current/Extract.html
  

 *)





(* OCaml's dafault type definitions *)
Extract Inductive bool => "bool" [ "true" "false" ].
Extract Inductive list => "list" [ "[]" "(::)" ].
Extract Inductive prod => "( * )" [ "( , )" ].
(* Coq nat default extraction is not efficient, so we should consider *)
(* another representation. *)



Recursive Extraction asfs.
Extraction "extraction/equiv.ml" equiv_checker.






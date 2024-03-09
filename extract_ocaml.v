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
  
From Coq Require Import Strings.String.
Require Import List.
Import ListNotations.
Require Import FORVES.parser.
Import Parser.
From Coq Require Import extraction.ExtrOcamlString.
Import ExtrOcamlString.

(** Type Extractions **)
Extract Inductive bool => "bool" [ "true" "false" ].
Extract Inductive list => "list" [ "[]" "(::)" ].
Extract Inductive prod => "( * )" [ "( , )" ].
Extract Inductive sumbool => "bool" ["true" "false"].

(*
Extract Inductive nat => int [ "0" "Stdlib.Int.succ" ]
 "(fun fO fS n -> if n=0 then fO () else fS (n-1))".


Extract Constant plus => "(+)".
Extract Constant pred => "fun n -> Stdlib.max 0 (n-1)".
Extract Constant minus => "fun n m -> Stdlib.max 0 (n-m)".
Extract Constant mult => "( * )".
Extract Inlined Constant max => "Stdlib.max".
Extract Inlined Constant min => "Stdlib.min".
Extract Inlined Constant Nat.eqb => "(=)".
Extract Inlined Constant EqNat.eq_nat_decide => "(=)".

Extract Inlined Constant Peano_dec.eq_nat_dec => "(=)".

Extract Constant Nat.compare =>
 "fun n m -> if n=m then Eq else if n<m then Lt else Gt".
Extract Inlined Constant Compare_dec.leb => "(<=)".
Extract Inlined Constant Compare_dec.le_lt_dec => "(<=)".
Extract Inlined Constant Compare_dec.lt_dec => "(<)".
Extract Constant Compare_dec.lt_eq_lt_dec =>
 "fun n m -> if n>m then None else Some (n<m)".

*)

(** Program Extractions **)
(*  Examples from example.v are extracted and directly tested.
    After running the next line, use "make run" in order to compile and
    run the test_examples.ml file. *)
Extraction Parser.
Extraction "ocaml_interface/checker.ml" Parser. 

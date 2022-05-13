(* Enrique Martin - Univ. Complutense de Madrid
   Licensed under the GNU GENERAL PUBLIC LICENSE 3.0.

   You may obtain a copy of the License at
   https://www.gnu.org/licenses/gpl-3.0.txt
*)

Require Import Coq.Lists.List.
Require Import bbv.Word.
Require Import Coq.Init.Nat. (* for <? *)

Require Export Coq.Strings.Ascii.
Require Export Coq.Strings.String.
Open Scope string_scope.


Require Import Coq_EVM.lib.evmModel.
Require Import Coq_EVM.string_map.









(**********
  SFS 
 **********)

Definition abstract_stack := list string.

Inductive sfs_val : Type :=
  | SFSconst (v: EVMWord)
  | SFSname (name: string)
  | SFSbinop (op: OpCode) (name1 name2: string).
  (* SFSuop & SFSterop for unary and ternary operations, if needed *)
  
Definition sfs_map := map sfs_val.

Inductive sfs : Type := 
  SFS (absi: abstract_stack) (abso: abstract_stack) (sfsmap: sfs_map).

(* Initial stack and SFS map contains disjoint symbols *)
Definition disjoint_stack_sfs (stack: map EVMWord) (csfs: sfs) : Prop :=
match csfs with 
  | SFS absi abso sfsmap => disjoint (domain stack) (domain sfsmap)
end.



(* Syntactic equality of Opcode (instructions) 
   TODO: extend to all possible instructions and prove equivalence with =:
         - (EVMoper_eqb i1 i2) = true <-> i1 = i2
         - (EVMoper_eqb i1 i2) = false <-> i1 <> i2
   *)
Definition EVMoper_eqb (i1 i2: OpCode) : bool :=
match (i1, i2) with
 | (STOP, STOP) => true
 | (RETURN, RETURN) => true
 | (ComplexPriceOpcodeMk op1, ComplexPriceOpcodeMk op2) => false (* Not supported *)
 | (SimplePriceOpcodeMk op1, SimplePriceOpcodeMk op2) => match (op1, op2) with
                                                          | (ADD, ADD) => true
                                                          | (MUL, MUL) => true
                                                          | (SUB, SUB) => true
                                                          | (PUSH arg1 w1, PUSH arg2 w2) => andb (weqb arg1 arg2) (weqb w1 w2)
                                                          | (POP, POP) => true
                                                          | _ => false
                                                         end
 | _ => false
end.

Compute (EVMoper_eqb (SimplePriceOpcodeMk (PUSH (natToWord 5 7) (natToWord WLen 200))) 
                     (SimplePriceOpcodeMk POP)
).

(* Recursive function for syntactic equality *)
Definition sfsval_eqb (sfs1 sfs2: sfs_val) : bool :=
match (sfs1, sfs2) with
 | (SFSconst v1, SFSconst v2) => weqb v1 v2
 | (SFSname name1, SFSname name2) => name1 =? name2
 | (SFSbinop op1 arg11 arg12, SFSbinop op2 arg21 arg22) => 
      andb (EVMoper_eqb op1 op2) 
           (andb (arg11 =? arg21) (arg12 =? arg22))
 | _ => false
end.



(**********
 Generation of abstract stack names 
 **********)

Definition nat_to_ascii_digit (n: nat) : string := 
  let num := modulo n 10 in
  string_of_list_ascii ((ascii_of_nat ((nat_of_ascii "0") + n))::nil).

(* 'depth' is the fake argument for strong normalization *)
Fixpoint nat_to_string_aux (n: nat) (depth:nat): string :=
match depth with
 | 0 => ""
 | S m => if n <? 10 then (nat_to_ascii_digit n) 
          else
            let last_digit := modulo n 10 in
            let rest_num := div n 10 in
            append (nat_to_string_aux rest_num m) (nat_to_ascii_digit last_digit)
end.

(* String of the last 50 digits in 'n' *)
Definition nat_to_string (n: nat) : string :=
nat_to_string_aux n 50.


Fixpoint create_abs_stack_name_rev (n: nat) (prefix: string): list string :=
match n with
 | 0 => (append prefix (nat_to_string 0))::nil
 | S m => ((append prefix (nat_to_string (S m)))::(create_abs_stack_name_rev m prefix)) 
end.

Definition create_abs_stack_name (n: nat) (prefix: string): list string :=
rev (create_abs_stack_name_rev (n-1) prefix).

Compute (create_abs_stack_name 10 "s").


(*****************
 Generation of SFS from EVM bytecode
 Get a parameter of fresh abstract stack names to be used
 *****************)

(* arg is a word of length 5 that represents the argument of the PUSH: PUSH 1 = PUSH 00000, PUSH 2 = PUSH 00001, etc. *)
Definition abs_eval_push (arg: word 5) (word: EVMWord) (curr_sfs: sfs) (fresh_stack_names: list string)
  : option (sfs * list string) :=
match fresh_stack_names with
 | nil => None
 | next_stack_name::rest_stack_names => match curr_sfs with
                                         | SFS absi abso sfs_map => let value := pushWordPass word (wordToNat arg + 1) in
                                                                    Some (SFS absi (next_stack_name::abso) 
                                                                              (update sfs_map next_stack_name (SFSconst value)), 
                                                                          rest_stack_names)
                                         end
end.

Definition abs_eval_pop (curr_sfs: sfs) (fresh_stack_names: list string)
  : option (sfs * list string) :=
match curr_sfs with
 | SFS absi abso sfs_map => match abso with
                             | top::r => Some ((SFS absi r sfs_map), fresh_stack_names)
                             | nil => None
                            end
end.

(* General code for every simple binary operation in the stack *)
Definition abs_eval_binary (oper: OpCode) (curr_sfs: sfs) (fresh_stack_names: list string)
  : option (sfs * list string) :=
match fresh_stack_names with
 | nil => None
 | next_stack_name::rest_stack_names =>
     match curr_sfs with
      | SFS absi abso sfs_map =>
          match abso with
           | s0::s1::rstack => Some (SFS absi (next_stack_name::rstack) 
                                         (update sfs_map next_stack_name (SFSbinop oper s0 s1)),
                                     rest_stack_names)
           | _ => None
          end
     end
end.

Compute abs_eval_binary (SimplePriceOpcodeMk ADD) (SFS ("s0"::"s1"::nil) ("s0"::"s1"::nil) empty_map) ("nueva pos"::"otra mas"::nil).
Compute abs_eval_binary (SimplePriceOpcodeMk SUB) (SFS ("s0"::"s1"::"s2"::nil) ("s0"::"s1"::"s2"::nil) empty_map) ("nueva pos"::"name2"::nil).


(* Function to evaluate an operation in a SFS *)
Definition abs_eval_op (oper: OpCode) (curr_sfs: sfs) (fresh_stack_names: list string)
  : option (sfs * list string) :=
match oper with
  | SimplePriceOpcodeMk ADD => abs_eval_binary (SimplePriceOpcodeMk ADD) curr_sfs fresh_stack_names
  | SimplePriceOpcodeMk MUL => abs_eval_binary (SimplePriceOpcodeMk MUL) curr_sfs fresh_stack_names
  | SimplePriceOpcodeMk SUB => abs_eval_binary oper curr_sfs fresh_stack_names
  | SimplePriceOpcodeMk (PUSH arg word) => abs_eval_push arg word curr_sfs fresh_stack_names
  | SimplePriceOpcodeMk POP => abs_eval_pop curr_sfs fresh_stack_names
 (* All binary instructions are evaluated the same
  | DIV	          => 5
  | SDIV	        => 5
  | MOD	          => 5
  | SMOD	        => 5
  | ADDMOD	      => 8
  | MULMOD	      => 8
  ----
  *)
  | _ => None
end.

Check (abs_eval_op).
Compute abs_eval_op (SimplePriceOpcodeMk ADD) (SFS ("s0"::"s1"::nil) ("s0"::"s1"::nil) empty_map) ("nueva pos"::"otra mas"::nil).
Compute abs_eval_op (SimplePriceOpcodeMk SUB) (SFS ("s0"::"s1"::nil) ("s0"::"s1"::nil) empty_map) ("nueva pos"::"otra mas"::nil).


Fixpoint abstract_eval_aux (program: list OpCode) (curr_sfs: sfs) (fresh_stack_names: list string)
  : option (sfs * list string) :=
match program with 
  | nil => Some (curr_sfs, fresh_stack_names)
  | oper::rprog => match abs_eval_op oper curr_sfs fresh_stack_names with
                    | None => None
                    | Some (new_sfs, new_stack_names) => abstract_eval_aux rprog new_sfs new_stack_names
                   end
end.

Definition abstract_eval (program: list OpCode)
  : option sfs :=
let ins := create_abs_stack_name 10 "s" in (* The 10 is fixed... *)
let outs := create_abs_stack_name StackLen "e" in (* generates 'StackLen' names*)
match abstract_eval_aux program (SFS ins ins empty_map) outs with
 | None => None
 | Some (final_sfs, _) => Some final_sfs
end.


Check abstract_eval (SimplePriceOpcodeMk ADD::nil).
Compute (abstract_eval (SimplePriceOpcodeMk ADD::nil)).
Compute (abstract_eval (SimplePriceOpcodeMk ADD::SimplePriceOpcodeMk MUL::nil)).
Compute (abstract_eval (SimplePriceOpcodeMk ADD::SimplePriceOpcodeMk POP::nil)).
Compute (abstract_eval (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 10))::SimplePriceOpcodeMk POP::nil)).


(*
(****************
 SFS equivalence [not used]
*****************)
Definition sfs_eq_symbol (d: nat) (symb1 symb2 : string) (map1 map2 : sfs_map) : bool :=
match (resolve_sfs_expr d (SFSname symb1) map1, resolve_sfs_expr d (SFSname symb2) map2) with
 | (None, _) => false
 | (_, None) => false
 | (Some sfs1, Some sfs2) => sfsval_eqb sfs1 sfs2
end.

Fixpoint sfs_eq_list (d: nat) (in1 in2 : abstract_stack) (map1 map2 : sfs_map) : bool :=
match in1 with 
 | nil => match in2 with
           | nil => true
           | _::_ => false
          end
 | v1::r1 => match in2 with
              | nil => false
              | v2::r2 => andb (sfs_eq_symbol d v1 v2 map1 map2) (sfs_eq_list d r1 r2 map1 map2)
             end
end.

Definition sfs_eqb (d: nat) (sfs1 sfs2 : sfs) : bool :=
match (sfs1, sfs2) with
 | (SFS in1 map1, SFS in2 map2) => sfs_eq_list d in1 in2 map1 map2
end.


(* Test: equivalent SFS *)
Compute (abstract_eval (SimplePriceOpcodeMk ADD::SimplePriceOpcodeMk POP::nil)).
Compute (abstract_eval (SimplePriceOpcodeMk POP::SimplePriceOpcodeMk POP::nil)).
Compute (
let prog1 := abstract_eval (SimplePriceOpcodeMk ADD::SimplePriceOpcodeMk POP::nil) in 
let prog2 := abstract_eval (SimplePriceOpcodeMk POP::SimplePriceOpcodeMk POP::nil) in 
match (prog1, prog2) with
 | (Some sfs1, Some sfs2) => Some (sfs_eqb 1024 sfs1 sfs2)
 | _ => None
end).

Compute (
let sfs1 := SFS ("s2"::"s3"::nil) (("e0",SFSbinop (SimplePriceOpcodeMk ADD) (SFSname "s0") (SFSname "s1"))::nil) in
let sfs2 := SFS ("e0"::"s3"::"s4"::nil) (("e0",SFSbinop (SimplePriceOpcodeMk SUB) (SFSname "s1")(SFSname "s2"))::nil) in
sfs_eqb 1024 sfs1 sfs2
).

(* Test: not equivalent SFS *)
Compute (abstract_eval (SimplePriceOpcodeMk ADD::SimplePriceOpcodeMk POP::nil)).
Compute (abstract_eval (SimplePriceOpcodeMk POP::SimplePriceOpcodeMk SUB::nil)).
Compute (
let prog1 := abstract_eval (SimplePriceOpcodeMk ADD::SimplePriceOpcodeMk POP::nil) in 
let prog2 := abstract_eval (SimplePriceOpcodeMk POP::SimplePriceOpcodeMk SUB::nil) in 
match (prog1, prog2) with
 | (Some sfs1, Some sfs2) => Some (sfs_eqb 1024 sfs1 sfs2)
 | _ => None
end).
*)



(*************
 Evaluation of a final stack position from concrete initial stack and a SFS 
**************) 

Definition empty_execution_state (stack: list (EVMWord)) : ExecutionState :=
  ExecutionStateMk stack 
                   (M.empty EVMWord)
                   (M.empty EVMWord)
                   (M.empty (list (word 8)))
                   0
                   nil.

Definition empty_callinfo : CallInfo := 
CallInfoMk nil 
           (natToWord WLen 0)
           (natToWord WLen 0)
           (natToWord WLen 0)
           (natToWord WLen 0)
           (natToWord WLen 0)
           nil
           (natToWord WLen 0)
           (natToWord WLen 0)
           (natToWord WLen 0)
           (natToWord WLen 0)
           (natToWord WLen 0)
           (natToWord WLen 0)
           (natToWord WLen 0)
           (M.empty EVMWord).


Definition evaluate_concrete_element (oper: OpCode) (args: list EVMWord) 
  : option EVMWord :=
(* relies on actOpcode, the EVM model function for evaluating programs. Here I construct an 
   ad-hoc program and stack and execute it inside an empty execution state and empty callinfo *)
match (actOpcode 1000 0 (empty_execution_state args) (oper::STOP::nil) empty_callinfo) with
 | inr (SuccessfulExecutionResultMk (ExecutionStateMk (e::_) _memory _storage _pc _contracts _)) => Some e
 | _ => None
end.


(* Dummy natural variable "d" for decreasingness *)
Fixpoint evaluate_sfs_from_map (d: nat) (concrete_stack: map EVMWord) (spec: sfs) (symbol: string)
  : option EVMWord :=
match d with
 | 0 => None
 | S d' => match lookup concrete_stack symbol with
            | Some value => Some value
            | None => match spec with 
                       | SFS _ _ sfsm => match lookup sfsm symbol with
                                        | Some (SFSconst v) => Some v
                                        | Some (SFSbinop oper name1 name2) => 
                                            match (evaluate_sfs_from_map d' concrete_stack spec name1,
                                                   evaluate_sfs_from_map d' concrete_stack spec name2) with
                                             | (Some v1, Some v2) => evaluate_concrete_element oper (v1::v2::nil)
                                             | _ => None
                                            end
                                        | Some (SFSname name) => evaluate_sfs_from_map d' concrete_stack spec name
                                        | None => None
                                       end
                      end
           end
end.


Lemma eval_more_steps: forall (d: nat) (stack: map EVMWord) (absi abso: abstract_stack) 
(sfs_map: sfs_map) (symbol: string) (val: EVMWord),
evaluate_sfs_from_map d stack (SFS absi abso sfs_map) symbol = Some val
-> evaluate_sfs_from_map (S d) stack (SFS absi abso sfs_map) symbol = Some val.
Proof.
intro d. induction d as [ | d' IH].
 - intros stack absi abso sfs_map symbol val.
   unfold evaluate_sfs_from_map. intro Hnonesome. discriminate.
 - intros stack absi abso sfs_map symbol val.
   remember (S d') as succdp eqn: Heqsuccdp. (* Defines succdp = S d', useful for unfolding *)
   rewrite -> Heqsuccdp at 1.
   unfold evaluate_sfs_from_map.
   destruct (lookup stack symbol) as [v | ] eqn: eqlookupstackvalue; try trivial.
   destruct (lookup sfs_map symbol) as [v | ] eqn: eqlookupmapvalue; try trivial.
   destruct v as [value|name|op name1 name2] eqn: Hv.
   + trivial.
   + fold evaluate_sfs_from_map.
     rewrite -> Heqsuccdp.
     pose proof (IH stack absi abso sfs_map name val) as IHspec.
     rewrite -> Heqsuccdp in IHspec.
     assumption.
   + fold evaluate_sfs_from_map.
     destruct (evaluate_sfs_from_map d' stack (SFS absi abso sfs_map) name1) 
       as [v1|] eqn: Hevalname1.
     * destruct (evaluate_sfs_from_map d' stack (SFS absi abso sfs_map) name2) 
          as [v2|] eqn: Hevalname2.
       -- pose proof (IH stack absi abso sfs_map name1 v1) as IHspecname1.
          apply IHspecname1 in Hevalname1.
          rewrite -> Hevalname1.
          pose proof (IH stack absi abso sfs_map name2 v2) as IHspecname2.
          apply IHspecname2 in Hevalname2.
          rewrite -> Hevalname2.
          trivial.
       -- intro Hfalse. discriminate.
     * intro Hfalse. discriminate.
Qed.



Example push_4_3:
match abstract_eval (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 4))::
                     SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 3))::
                     SimplePriceOpcodeMk ADD::
                     nil) with
 | Some csfs => (*Some csfs*)
                (evaluate_sfs_from_map 1024 empty_map csfs "e0",
                 evaluate_sfs_from_map 1024 empty_map csfs "e1",
                 evaluate_sfs_from_map 1024 empty_map csfs "e2",
                 evaluate_sfs_from_map 1024 empty_map csfs "s0",
                 evaluate_sfs_from_map 1024 empty_map csfs "e3")
 | _ => (None, None, None, None, None)
end = (Some (natToWord WLen 4), 
       Some (natToWord WLen 3),
       Some (natToWord WLen 7),
       None,
       None).
Proof.
 reflexivity. Qed.


Definition safeWordToNat (w: option EVMWord) : option nat :=
match w with
 | None => None
 | Some w => Some (wordToNat w)
end.


Compute (let init_map := ("s0", natToWord WLen 6)::("s1", (natToWord WLen 5))::nil in 
         let spec := SFS nil nil (("e0", SFSbinop (SimplePriceOpcodeMk ADD) "s0" "s1")::nil) in 
         safeWordToNat (evaluate_sfs_from_map StackLen init_map spec "s1")).
Compute (let init_map := ("s0", natToWord WLen 6)::("s1", (natToWord WLen 5))::nil in 
         let spec := SFS nil nil (("e0", SFSbinop (SimplePriceOpcodeMk ADD) "s0" "s1")::nil) in 
         safeWordToNat (evaluate_sfs_from_map StackLen init_map spec "e0")).
Compute (let init_map := ("s0", natToWord WLen 6)::("s1", (natToWord WLen 5))::("s2", (natToWord WLen 2))::nil in 
         let spec := SFS nil nil (("e0", SFSbinop (SimplePriceOpcodeMk ADD) "s0" "s1")::
                              ("e1", SFSbinop (SimplePriceOpcodeMk MUL) "e0" "s2")::nil) in 
         safeWordToNat (evaluate_sfs_from_map StackLen init_map spec "e1")).
Compute (let init_map := ("s0", natToWord WLen 6)::("s1", (natToWord WLen 5))::
                         ("s2", (natToWord WLen 2))::("s3", (natToWord WLen 2))::nil in 
         let spec := SFS nil nil (("e0", SFSbinop (SimplePriceOpcodeMk ADD) ("s0") ("s1"))::
                              ("e1", SFSbinop (SimplePriceOpcodeMk MUL) ("e0") ("s2"))::
                              ("e2", SFSbinop (SimplePriceOpcodeMk SUB) ("e1") ("s3"))::nil) in 
         safeWordToNat (evaluate_sfs_from_map StackLen init_map spec "e2")).


(* Combining the abstract evaluation of a program and the concrete evaluation of a final stack position *)
Example ex1: 
let program := (SimplePriceOpcodeMk ADD::SimplePriceOpcodeMk MUL::nil) in
let stack   := (("s0", natToWord WLen 2)::("s1", natToWord WLen 5)::("s2", natToWord WLen 3)::
                ("s3", natToWord WLen 6)::nil) in
let sfso := abstract_eval program in
match sfso with
 | None => None
 | Some sfs => match (safeWordToNat (evaluate_sfs_from_map StackLen stack sfs "e1")) with
                | None => None
                | Some v => Some v
               end
end = Some 21.
Proof.
reflexivity. Qed.

(* Two SFS specifications are the same if given a concrete stack, they evaluate their
   abstract symbols to the same EVM values (EVMWord) *)
Fixpoint sfs_equiv_concrete_values_aux (concrete_stack: map EVMWord) 
  (absi1 absi2 abso1 abso2: abstract_stack) (sfsmap1 sfsmap2: sfs_map) : bool :=
match (abso1, abso2) with
  | (nil, nil) => true  
  | (symb1::r1, symb2::r2) => 
      let v1 := evaluate_sfs_from_map 1024 concrete_stack (SFS absi1 abso1 sfsmap1) symb1 in
      let v2 := evaluate_sfs_from_map 1024 concrete_stack (SFS absi2 abso2 sfsmap2) symb2 in
      match (v1, v2) with
       | (Some w1, Some w2) => andb (weqb w1 w2) (sfs_equiv_concrete_values_aux concrete_stack absi1 r1 absi2 r2 sfsmap1 sfsmap2)
       | _ => false
      end
  | _ => false
end.


(* Two SFS are equivalent for a concrete stack if both have the same length and each SFS maps every
   stack position to the same concrete value (wrt. the concrete stack) *)
Definition sfs_equiv_concrete_values (concrete_stack: map EVMWord) (spec1 spec2: sfs) : bool :=
match (spec1, spec2) with
 | (SFS absi1 abso1 sfsmap1, SFS absi2 abso2 sfsmap2) => sfs_equiv_concrete_values_aux concrete_stack absi1 absi2 abso1 abso2 sfsmap1 sfsmap2
end.
Check sfs_equiv_concrete_values.


(* Generates an empty list of the same EVMWord *)
Fixpoint empty_concrete_stack (n: nat) : list EVMWord :=
match n with
 | 0 => nil
 | S n' => WZero :: (empty_concrete_stack n')
end.

(* Generates a full stack (mapping) from s_n to WZero *)
Definition full_emtpy_stack : map EVMWord :=
 let len := StackLen in
 List.combine (create_abs_stack_name len "s") (empty_concrete_stack len).
 

Compute (
let init_stack := full_emtpy_stack in
let osfs1 := abstract_eval ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 15)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 0)))::
                           SimplePriceOpcodeMk ADD::
                           nil) in
let osfs2 := abstract_eval ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 15)))::
                           nil) in
match (osfs1, osfs2) with
 | (Some sfs1, Some sfs2) => Some (sfs_equiv_concrete_values init_stack sfs1 sfs2)
 | _ => None
end
).

Compute (
let init_stack := full_emtpy_stack in
let osfs1 := abstract_eval ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 10)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 5)))::
                           SimplePriceOpcodeMk ADD::
                           nil) in
let osfs2 := abstract_eval ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 5)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 5)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 5)))::
                           SimplePriceOpcodeMk ADD::
                           SimplePriceOpcodeMk ADD::
                           nil) in
match (osfs1, osfs2) with
 | (Some sfs1, Some sfs2) => Some (sfs_equiv_concrete_values init_stack sfs1 sfs2)
 | _ => None
end
).

Compute (
let init_stack := full_emtpy_stack in
let osfs1 := abstract_eval ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 10)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 5)))::
                           SimplePriceOpcodeMk ADD::
                           nil) in
let osfs2 := abstract_eval ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 15)))::
                           nil) in
match (osfs1, osfs2) with
 | (Some sfs1, Some sfs2) => Some (sfs_equiv_concrete_values init_stack sfs1 sfs2)
 | _ => None
end
).

Compute (
let init_stack := full_emtpy_stack in
let osfs1 := abstract_eval ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 10)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 4)))::
                           SimplePriceOpcodeMk ADD::
                           nil) in
let osfs2 := abstract_eval ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 15)))::
                           nil) in
match (osfs1, osfs2) with
 | (Some sfs1, Some sfs2) => Some (sfs_equiv_concrete_values init_stack sfs1 sfs2)
 | _ => None
end
).




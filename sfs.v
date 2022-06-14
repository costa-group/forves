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


(***********
  CONCRETE EVALUATION OF A PROGRAM WRT. A STACK
 ***********)
Definition infinite_gas : nat := 2048.

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


(* Evaluation of a program given a concrete stack.
   Add a STOP instruction at the end of the program so that evmModel does no generate a jump exception *) 
Definition concrete_eval (gas: nat) (program: list OpCode) (stack: list (EVMWord)) : option (list EVMWord) :=
match actOpcode gas 0 (empty_execution_state stack) (app program (STOP::nil)) empty_callinfo with
| inr (SuccessfulExecutionResultMk execStat) => Some (getStack_ES execStat)
| inr (SuccessfulExecutionResultMkWithData execStat data) => None
  (* SuccessfulExecutionResultMkWithData should not be returned in our EVM blocks because it is
     generated with LOG, CREATE, CALL and CALLCODE instructions *)
| inl _ => None
end.

Example concrete_eval_ex1:
concrete_eval infinite_gas
              (SimplePriceOpcodeMk ADD::nil) 
              ((natToWord WLen 2)::(natToWord WLen 3)::(natToWord WLen 8)::nil)
= Some (((natToWord WLen 5)::(natToWord WLen 8)::nil)).
Proof. reflexivity. Qed.

Example concrete_eval_ex2:
concrete_eval infinite_gas 
              (SimplePriceOpcodeMk ADD::nil) 
              ((natToWord WLen 2)::nil)
= None (* stack underflow*).
Proof. reflexivity. Qed.

Example concrete_eval_ex3:
concrete_eval infinite_gas
              (SimplePriceOpcodeMk (PUSH (natToWord 5 0) WZero)::nil) 
              (repeat WZero StackLen)
= None (* stack overflow *).
Proof. reflexivity. Qed.


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



(****
 SFS syntactic equivalence [TODO: no renamings for now] 
 ***)
Definition sfsval_eqb (sfs1 sfs2: sfs_val) : bool :=
match (sfs1, sfs2) with
 | (SFSconst v1, SFSconst v2) => weqb v1 v2
 | (SFSname name1, SFSname name2) => name1 =? name2
 | (SFSbinop op1 arg11 arg12, SFSbinop op2 arg21 arg22) => 
      (EVMoper_eqb op1 op2) && (arg11 =? arg21) && (arg12 =? arg22)
 | _ => false
end.

Fixpoint str_list_eq (a b: list string) : bool :=
match (a,b) with
| (nil, nil) => true
| (h1::t1, h2::t2) => (h1 =? h2) && (str_list_eq t1 t2)
| _ => false
end.

Definition eq_lookup_key (key: string) (a b: sfs_map) : bool :=
match (lookup a key, lookup b key) with
| (None, None) => true (* looking for an sN symbol *)
| (Some sfsv1, Some sfsv2) => sfsval_eqb sfsv1 sfsv2
| _  => false
end.

Fixpoint sfs_map_eq (abs_stack: list string) (a b: sfs_map) : bool :=
match abs_stack with
| nil => true
| (k::t) => (eq_lookup_key k a b) && (sfs_map_eq t a b)
end.

(* Two SFS are syntactically equivalent if both have exactly the same input and output abstract stacks 
   and for every sumbol in their output abstract stacks, their mapping map them to the same SFS value
   (or None, for sN symbols) *)
Definition sfs_syn_eqb (sfs1 sfs2 : sfs) : bool :=
match (sfs1, sfs2) with
 | (SFS in1 out1 map1, SFS in2 out2 map2) => 
      (str_list_eq in1 in2) && (str_list_eq out1 out2) && (sfs_map_eq out1 map1 map2)
end.

(* Tests *)
Example sfs_syn_eqb_ex1:
let sfs1 := SFS ("s0"::nil) ("e0"::"s0"::nil) (("e0",SFSconst WZero)::nil) in
sfs_syn_eqb sfs1 sfs1 = true.
Proof. reflexivity. Qed.
Example sfs_syn_eqb_ex2:
let sfs1 := SFS ("s0"::nil) ("e0"::"s0"::nil) (("e0",SFSconst WZero)::nil) in
let sfs2 := SFS ("s0"::nil) ("e1"::"s0"::nil) (("e1",SFSconst WZero)::nil) in
sfs_syn_eqb sfs1 sfs2 = false.
Proof. reflexivity. Qed.
Example sfs_syn_eqb_ex3:
let sfs1 := SFS ("s0"::nil) ("e0"::"s0"::nil) (("e0",SFSconst WZero)::nil) in
let sfs2 := SFS ("s0"::nil) ("e0"::"s0"::nil) (("e0",SFSconst WZero)::("e0",SFSname "s0")::nil) in
            (* old mappings do not care *)
sfs_syn_eqb sfs1 sfs2 = true.
Proof. reflexivity. Qed.
Example sfs_syn_eqb_ex4:
let sfs1 := SFS ("s0"::nil) ("e0"::"s0"::nil) (("e0",SFSconst WZero)::nil) in
let sfs2 := SFS ("s0"::nil) ("e0"::nil) (("e0",SFSconst WZero)::nil) in
            (* difference in out *)
sfs_syn_eqb sfs1 sfs2 = false.
Proof. reflexivity. Qed.
Example sfs_syn_eqb_ex5:
let sfs1 := SFS ("s0"::nil) ("e0"::nil) (("e0",SFSconst WZero)::nil) in
let sfs2 := SFS ("s1"::nil) ("e0"::nil) (("e0",SFSconst WZero)::nil) in
            (* difference in 'in' *)
sfs_syn_eqb sfs1 sfs2 = false.
Proof. reflexivity. Qed.
Example sfs_syn_eqb_ex6:
let sfs1 := SFS ("s0"::nil) ("e0"::"s0"::nil) (("e0",SFSconst WZero)::nil) in
let sfs2 := SFS ("s0"::nil) ("e0"::"s0"::nil) (("e0",SFSname "s0")::nil) in
            (* difference in mapping e0 *)
sfs_syn_eqb sfs1 sfs2 = false.
Proof. reflexivity. Qed.


(***********************************
 EVALUATION OF AN SFS FROM A CONCRETE STACK 
 **********************************)
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



Fixpoint evaluate_sfs_aux (d: nat) (abs: abstract_stack) (stack: map EVMWord) (sfsm: sfs_map): 
                          option (list EVMWord) := 
match abs with
| nil => Some nil
| symb::r => match (evaluate_sfs_from_map d stack (SFS nil nil sfsm) symb,
                    evaluate_sfs_aux d r stack sfsm) with
             | (Some vs, Some rr) => Some (vs::rr)
             | _ => None
             end
end.

(* Evaluation of an SFS given a concrete stack and a depth 'd' to follow SFS mapping 
   TODO: could we replace 'd' by a big enough constant? *)
Definition evaluate_sfs (d: nat) (csfs: sfs) (stack: list EVMWord) : option (list EVMWord) := 
match csfs with
| SFS absi abso smap => let stack := combine absi stack in
                        evaluate_sfs_aux d abso stack smap
end.

Definition infinite_eval_steps : nat := 5000. (* This should be enough in SFS obtained in our blocks *)

Compute (let csfs := SFS ("s0"::"s1"::"s2"::"s3"::nil) ("e1"::"s3"::nil) 
                         (("e0", SFSbinop (SimplePriceOpcodeMk MUL) "s0" "s1")::
                         (("e1", SFSbinop (SimplePriceOpcodeMk ADD) "e0" "s2")::nil))
         in evaluate_sfs infinite_eval_steps csfs 
           ((natToWord WLen 2)::(natToWord WLen 3)::(natToWord WLen 5)::(natToWord WLen 7)::nil)).


(********
 General SFS equivalence [TODO: I don't know if what I'm doing with the number of steps 'd' is correct]
 ********)
Definition sfs_eq (sfs1 sfs2: sfs): Prop := 
forall (d:nat) (ini_stack stack1 stack2: list EVMWord), 
evaluate_sfs d sfs1 ini_stack = Some stack1 ->
evaluate_sfs d sfs2 ini_stack = Some stack2 ->
stack1 = stack2.



(* Syntactic equivalence implies equality under evaluation *)
Lemma sfs_syn_eq_then_eq: forall (sfs1 sfs2: sfs),
sfs_syn_eqb sfs1 sfs2 = true -> sfs_eq sfs1 sfs2.
Proof.
Admitted.




(**********
 Generation of abstract stacks of a given size
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
 | 0 => nil
 | S m => ((append prefix (nat_to_string m))::(create_abs_stack_name_rev m prefix)) 
end.

(* Creates an abstract stack of 'n' symbols with the given prefix *)
Definition create_abs_stack_name (n: nat) (prefix: string): list string :=
rev (create_abs_stack_name_rev n prefix).

Compute (create_abs_stack_name 10 "s").





(*****************
 Abstract evaluation: generation of SFS from EVM bytecode
 Receive the size and use always sN for initial stack elements and eN for generated ones
*****************)

Definition prefix_abstract_stack : string := "s".
Definition prefix_abstract_stack_eval : string := "e".
 

(* arg is a word of length 5 that represents the argument of the PUSH: PUSH1 = PUSH 00000, PUSH2 = PUSH 00001, etc. *)
Definition abs_eval_push (arg: word 5) (word: EVMWord) (curr_sfs: sfs) (fresh_stack_id: nat)
  : option (sfs * nat) :=
match curr_sfs with
 | SFS absi abso sfs_map => let value := pushWordPass word (wordToNat arg + 1) in
                            let stack_pos_name := append prefix_abstract_stack_eval (nat_to_string fresh_stack_id) in
                            Some (SFS absi 
                                      (stack_pos_name::abso) 
                                      (update sfs_map stack_pos_name (SFSconst value)), 
                                 fresh_stack_id + 1)
end.


Definition abs_eval_pop (curr_sfs: sfs) (fresh_stack_id: nat)
  : option (sfs * nat) :=
match curr_sfs with
 | SFS absi abso sfs_map => match abso with
                             | top::r => Some ((SFS absi r sfs_map), fresh_stack_id)
                             | nil => None
                            end
end.

(* General code for every simple binary operation in the stack *)
Definition abs_eval_binary (oper: OpCode) (curr_sfs: sfs) (fresh_stack_id: nat)
  : option (sfs * nat) :=
match curr_sfs with
| SFS absi abso sfs_map => match abso with
                           | s0::s1::rstack => 
                               let stack_pos_name := append "e" (nat_to_string fresh_stack_id) in 
                               Some (SFS absi 
                                         (stack_pos_name::rstack) 
                                         (update sfs_map stack_pos_name (SFSbinop oper s0 s1)),
                                     fresh_stack_id + 1)
                           | _ => None
                           end
end.

Compute abs_eval_binary (SimplePriceOpcodeMk ADD) (SFS ("s0"::"s1"::nil) ("s0"::"s1"::nil) empty_map) 0.
Compute abs_eval_binary (SimplePriceOpcodeMk SUB) (SFS ("s0"::"s1"::"s2"::nil) ("s0"::"s1"::"s2"::nil) empty_map) 3.


(* Function to evaluate an operation in a SFS *)
Definition abs_eval_op (oper: OpCode) (curr_sfs: sfs) (fresh_stack_id: nat)
  : option (sfs * nat) :=
match oper with
  | STOP => Some (curr_sfs, fresh_stack_id)
  | SimplePriceOpcodeMk ADD => abs_eval_binary (SimplePriceOpcodeMk ADD) curr_sfs fresh_stack_id
  | SimplePriceOpcodeMk MUL => abs_eval_binary (SimplePriceOpcodeMk MUL) curr_sfs fresh_stack_id
  | SimplePriceOpcodeMk SUB => abs_eval_binary oper curr_sfs fresh_stack_id
  | SimplePriceOpcodeMk (PUSH arg word) => abs_eval_push arg word curr_sfs fresh_stack_id
  | SimplePriceOpcodeMk POP => abs_eval_pop curr_sfs fresh_stack_id
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
Compute abs_eval_op (SimplePriceOpcodeMk ADD) (SFS ("s0"::"s1"::nil) ("s0"::"s1"::nil) empty_map) 5.
Compute abs_eval_op (SimplePriceOpcodeMk SUB) (SFS ("s0"::"s1"::nil) ("s0"::"s1"::nil) empty_map) 0.


Fixpoint abstract_eval_aux (program: list OpCode) (curr_sfs: sfs) (fresh_stack_id: nat)
  : option (sfs * nat) :=
match program with 
  | nil => Some (curr_sfs, fresh_stack_id)
  | oper::rprog => match abs_eval_op oper curr_sfs fresh_stack_id with
                    | None => None
                    | Some (new_sfs, new_fresh_stack_id) => abstract_eval_aux rprog new_sfs new_fresh_stack_id
                   end
end.

(* Abstract evaluation:
   From a stack size and a program generates an SFS *)
Definition abstract_eval (stack_size: nat) (program: list OpCode)
  : option sfs :=
let ins := create_abs_stack_name stack_size prefix_abstract_stack in
match abstract_eval_aux program (SFS ins ins empty_map) 0 with (* fresh stack positions starting from 0 *)
 | None => None
 | Some (final_sfs, _) => Some final_sfs
end.


Check abstract_eval 3 (SimplePriceOpcodeMk ADD::nil).
Compute (abstract_eval 3 (SimplePriceOpcodeMk ADD::nil)).
Compute (abstract_eval 5 (SimplePriceOpcodeMk ADD::SimplePriceOpcodeMk MUL::nil)).
Compute (abstract_eval 2 (SimplePriceOpcodeMk ADD::SimplePriceOpcodeMk POP::nil)).
Compute (abstract_eval 1 (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 10))::SimplePriceOpcodeMk POP::nil)).



Example push_4_3:
match abstract_eval 1 (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 4))::
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


Example map_s1:
         (let init_map := ("s0", natToWord WLen 6)::("s1", (natToWord WLen 5))::nil in 
         let spec := SFS nil nil (("e0", SFSbinop (SimplePriceOpcodeMk ADD) "s0" "s1")::nil) in 
         safeWordToNat (evaluate_sfs_from_map StackLen init_map spec "s1")) = Some 5.
Proof. reflexivity. Qed.

Example map_e0:
         (let init_map := ("s0", natToWord WLen 6)::("s1", (natToWord WLen 5))::nil in 
         let spec := SFS nil nil (("e0", SFSbinop (SimplePriceOpcodeMk ADD) "s0" "s1")::nil) in 
         safeWordToNat (evaluate_sfs_from_map StackLen init_map spec "e0")) = Some 11.
Proof. reflexivity. Qed.

Example map_e1:
         (let init_map := ("s0", natToWord WLen 6)::("s1", (natToWord WLen 5))::("s2", (natToWord WLen 2))::nil in 
         let spec := SFS nil nil (("e0", SFSbinop (SimplePriceOpcodeMk ADD) "s0" "s1")::
                              ("e1", SFSbinop (SimplePriceOpcodeMk MUL) "e0" "s2")::nil) in 
         safeWordToNat (evaluate_sfs_from_map StackLen init_map spec "e1")) = Some 22.
Proof. reflexivity. Qed.

Example map_e2:
         (let init_map := ("s0", natToWord WLen 6)::("s1", (natToWord WLen 5))::
                         ("s2", (natToWord WLen 2))::("s3", (natToWord WLen 2))::nil in 
         let spec := SFS nil nil (("e0", SFSbinop (SimplePriceOpcodeMk ADD) ("s0") ("s1"))::
                              ("e1", SFSbinop (SimplePriceOpcodeMk MUL) ("e0") ("s2"))::
                              ("e2", SFSbinop (SimplePriceOpcodeMk SUB) ("e1") ("s3"))::nil) in 
         safeWordToNat (evaluate_sfs_from_map StackLen init_map spec "e2")) = Some 20.
Proof. reflexivity. Qed.


(* Combining the abstract evaluation of a program and the concrete evaluation of a final stack position *)
Example ex1: 
let program := (SimplePriceOpcodeMk ADD::SimplePriceOpcodeMk MUL::nil) in
let stack   := (natToWord WLen 2)::(natToWord WLen 5)::(natToWord WLen 3)::(natToWord WLen 6)::nil in
let sfso := abstract_eval 3 program in
let stack_map := combine (create_abs_stack_name 4 "s") stack in
match sfso with
 | None => None
 | Some sfs => match (safeWordToNat (evaluate_sfs_from_map StackLen stack_map sfs "e1")) with
                | None => None
                | Some v => Some v
               end
end = Some 21.
Proof. reflexivity. Qed.

(* Two SFS specifications are the same if given a concrete stack, they evaluate their final abstract
   stacks to the same EVM values (EVMWord)
   I need to split the 3 arguments of SFS so that Coq detects the decreasing one
*)
Fixpoint sfs_equiv_concrete_values_aux (stack_map1 stack_map2: map EVMWord) 
  (absi1 absi2 abso1 abso2: abstract_stack) (sfsmap1 sfsmap2: sfs_map) : bool :=
match (abso1, abso2) with
  | (nil, nil) => true  
  | (symb1::r1, symb2::r2) => 
      let v1 := evaluate_sfs_from_map 1024 stack_map1 (SFS absi1 abso1 sfsmap1) symb1 in
      let v2 := evaluate_sfs_from_map 1024 stack_map2 (SFS absi2 abso2 sfsmap2) symb2 in
      match (v1, v2) with
       | (Some w1, Some w2) => (weqb w1 w2) && 
                               (sfs_equiv_concrete_values_aux stack_map1 stack_map2 absi1 absi2 r1 r2 sfsmap1 sfsmap2)
       | _ => false
      end
  | _ => false
end.

Locate eqb.

(* Two SFS are equivalent for a concrete stack if both have the same length and each SFS maps every
   stack position to the same concrete value (wrt. the concrete stack) *)
Definition sfs_equiv_concrete_values (concrete_stack: list EVMWord) (spec1 spec2: sfs) : bool :=
match (spec1, spec2) with
 | (SFS absi1 abso1 sfsmap1, SFS absi2 abso2 sfsmap2) => 
      let stack_map1 := combine absi1 concrete_stack in
      let stack_map2 := combine absi2 concrete_stack in
      andb (Nat.eqb (List.length concrete_stack) (List.length absi1))
           (andb ((Nat.eqb (List.length concrete_stack) (List.length absi2)) )
           (sfs_equiv_concrete_values_aux stack_map1 stack_map2 absi1 absi2 abso1 abso2 sfsmap1 sfsmap2))
end.
Check sfs_equiv_concrete_values.


(* Generates an empty list of the same EVMWord *)
Fixpoint empty_concrete_stack (n: nat) : list EVMWord :=
match n with
 | 0 => nil
 | S n' => WZero :: (empty_concrete_stack n')
end.

(* Generates a full stack (mapping) from s_n to WZero *)
Definition full_empty_stack_map : map EVMWord :=
 let len := StackLen in
 List.combine (create_abs_stack_name len prefix_abstract_stack) (empty_concrete_stack len).
 

(* TODO: fix definitions, this should return Some true*)
Example push_add:
let init_stack := empty_concrete_stack 0 in
let osfs1 := abstract_eval 0 ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 15)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 0)))::
                           SimplePriceOpcodeMk ADD::
                           nil) in
let osfs2 := abstract_eval 0 ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 15)))::
                           nil) in
match (osfs1, osfs2) with
 | (Some sfs1, Some sfs2) => Some (sfs_equiv_concrete_values init_stack sfs1 sfs2)
 | _ => None
end = Some true.
Proof. reflexivity. Qed.

Example stack_0: create_abs_stack_name 0 prefix_abstract_stack = nil.
Proof. reflexivity. Qed.


Example push_equiv:
let init_stack := nil in
let osfs1 := abstract_eval 0 ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 10)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 5)))::
                           SimplePriceOpcodeMk ADD::
                           nil) in
let osfs2 := abstract_eval 0 ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 5)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 5)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 5)))::
                           SimplePriceOpcodeMk ADD::
                           SimplePriceOpcodeMk ADD::
                           nil) in
match (osfs1, osfs2) with
 | (Some sfs1, Some sfs2) => Some (sfs_equiv_concrete_values init_stack sfs1 sfs2)
 | _ => None
end = Some true.
Proof. reflexivity. Qed.

Example push_equiv2:
let init_stack := nil in
let osfs1 := abstract_eval 0 ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 10)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 5)))::
                           SimplePriceOpcodeMk ADD::
                           nil) in
let osfs2 := abstract_eval 0 ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 15)))::
                           nil) in
match (osfs1, osfs2) with
 | (Some sfs1, Some sfs2) => Some (sfs_equiv_concrete_values init_stack sfs1 sfs2)
 | _ => None
end = Some true.
Proof. reflexivity. Qed.

Example push_equiv_false:
let init_stack := nil in
let osfs1 := abstract_eval 0 ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 10)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 4)))::
                           SimplePriceOpcodeMk ADD::
                           nil) in
let osfs2 := abstract_eval 0 ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 15)))::
                           nil) in
match (osfs1, osfs2) with
 | (Some sfs1, Some sfs2) => Some (sfs_equiv_concrete_values init_stack sfs1 sfs2)
 | _ => None
end = Some false.
Proof. reflexivity. Qed.


Compute (abstract_eval 2 ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 2)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 8)))::
                           SimplePriceOpcodeMk MUL::
                           nil)).
Compute (abstract_eval 2 ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 16)))::
                           nil)).


Compute (List.length (natToWord WLen 7 :: natToWord WLen 19 :: nil)). 
Compute ((Datatypes.length (create_abs_stack_name 2 prefix_abstract_stack))).


Example push_equiv3:
let init_stack := (natToWord WLen 7)::(natToWord WLen 19)::nil in
let osfs1 := abstract_eval 2 ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 2)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 8)))::
                           SimplePriceOpcodeMk MUL::
                           nil) in
let osfs2 := abstract_eval 2 ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 16)))::
                           nil) in
match (osfs1, osfs2) with
 | (Some sfs1, Some sfs2) => Some (sfs_equiv_concrete_values init_stack sfs1 sfs2)
 | _ => None
end = Some true.
Proof. reflexivity. 
Qed.

Example push_equiv_false2:
let init_stack := (natToWord WLen 7)::(natToWord WLen 19)::nil in
let osfs1 := abstract_eval 2 ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 2)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 8)))::
                           SimplePriceOpcodeMk MUL::
                           nil) in
let osfs2 := abstract_eval 2 ((SimplePriceOpcodeMk POP)::(SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 16)))::
                           nil) in
match (osfs1, osfs2) with
 | (Some sfs1, Some sfs2) => Some (sfs_equiv_concrete_values init_stack sfs1 sfs2)
 | _ => None
end = Some false.
Proof. reflexivity. Qed.

Example push_equiv4:
let init_stack := (natToWord WLen 7)::(natToWord WLen 19)::nil in
let osfs1 := abstract_eval 2 ((SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 3)))::
                           (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 4)))::
                           SimplePriceOpcodeMk MUL::
                           nil) in
let osfs2 := abstract_eval 2 ((SimplePriceOpcodeMk POP)::
                              (SimplePriceOpcodeMk POP)::
                              (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 19)))::
                              (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 7)))::
                              (SimplePriceOpcodeMk (PUSH (natToWord 5 0) (natToWord WLen 12)))::
                              nil) in
match (osfs1, osfs2) with
 | (Some sfs1, Some sfs2) => Some (sfs_equiv_concrete_values init_stack sfs1 sfs2)
 | _ => None
end = Some true.
Proof. reflexivity. Qed.


Lemma evaluate_sfs_new_symbol: forall (d: nat) (absi: abstract_stack) 
      (stack_ini: list EVMWord) (smap: sfs_map) (symb nsymb: string) (val: EVMWord)
      (sfs_value: sfs_val),
evaluate_sfs_from_map d (combine absi stack_ini) (SFS nil nil smap) symb = Some val ->
symb <> nsymb ->
~ In nsymb absi ->
~ In nsymb (domain smap) ->
evaluate_sfs_from_map d (combine absi stack_ini)
  (SFS nil nil (update smap nsymb sfs_value)) symb = Some val.
Proof.
Admitted.


Lemma evaluate_sfs_stack_new_symbol: forall (d: nat) (abss absi: abstract_stack) 
      (stack_ini: list EVMWord) (smap: sfs_map) (cstack: list EVMWord) 
      (nsymb: string) (sfsv: sfs_val),
evaluate_sfs_aux d abss (combine absi stack_ini) smap = Some cstack ->
~ In nsymb abss -> (* This implies nsymb is different from every symbol in abss *)
~ In nsymb absi ->
~ In nsymb (domain smap) ->
evaluate_sfs_aux d abss (combine absi stack_ini) (update smap nsymb sfsv) = Some cstack.
Proof.
intros d abss. revert d.
induction abss as [ | symb rstack IH].
- intros d absi stack_ini smap cstack nsymb sfsv. simpl.
  intro Hnil. intros Htrue Hnotinabsi Hnotindomain. assumption.
- intros d absi stack_ini smap cstack nsymb sfsv. unfold evaluate_sfs_aux at 1.
  destruct (evaluate_sfs_from_map d (combine absi stack_ini) (SFS nil nil smap) symb)
    as [vs|] eqn: eq_evalsymb.
  + fold evaluate_sfs_aux.
    destruct (evaluate_sfs_aux d rstack (combine absi stack_ini) smap) 
      as [rr|] eqn: eq_evalsfsaux.
    * intros Hcstack Hsymbnotinstack Hnotinabsi Hsymbnotinmap.
      pose proof (evaluate_sfs_new_symbol d absi stack_ini smap symb nsymb vs
        sfsv eq_evalsymb).
      (* TODO: complete proof, the first steps are ok *)
Admitted.


Lemma evaluate_sfs_more_step: forall (d: nat) (abss: abstract_stack) 
      (inistackmap: map EVMWord) (smap: sfs_map) (cstack: list EVMWord),
evaluate_sfs_aux d abss inistackmap smap = Some cstack ->
evaluate_sfs_aux (S d) abss inistackmap smap = Some cstack.
Proof.
intros d abss. revert d. 
induction abss as [ | symb rstack IH].
- intros d initstackmap smap cstack. simpl. intros Hnil. assumption.
- intros d initstackmap smap cstack. unfold evaluate_sfs_aux at 1. 
  destruct (evaluate_sfs_from_map d initstackmap (SFS nil nil smap) symb) as [val|]
    eqn: eq_eval_symb.
  + destruct (evaluate_sfs_aux d rstack initstackmap smap) as [crstack|] 
      eqn: eq_eval_rstack.
    * fold evaluate_sfs_aux. rewrite -> eq_eval_rstack.   
      intro Hcstack. (*injection Hcstack. intro Hcrstack.*)
      unfold evaluate_sfs_aux.
      pose proof (eval_more_steps d initstackmap nil nil smap symb 
        val eq_eval_symb) as Heval_symb_sd.
      rewrite -> Heval_symb_sd.
      fold evaluate_sfs_aux.
      pose proof (IH d initstackmap smap crstack eq_eval_rstack) as IHspec.
      rewrite -> IHspec.
      assumption.
    * fold evaluate_sfs_aux. rewrite -> eq_eval_rstack.
      intro Hnonesome. discriminate.
  + intro Hnonesome. discriminate.
Qed.


(* The change produced by ADD instruction in the abstract evaluator *)
(* TODO: generalize to any arithmetic binary operator *)
Lemma abs_eval_add: forall (absi abso absi' abso': abstract_stack) 
     (smap smap': sfs_map) (idx idx': nat),
abs_eval_op (SimplePriceOpcodeMk ADD) (SFS absi abso smap) idx = Some ((SFS absi' abso' smap'), idx') ->
exists (symb1 symb2 nsymb: string) (rstack: list string), 
  absi = absi' /\
  abso = symb1::symb2::rstack /\
  abso' = nsymb::rstack /\
  smap' = update smap nsymb (SFSbinop (SimplePriceOpcodeMk ADD) symb1 symb2) /\
  ~ In nsymb absi /\
  ~ In nsymb abso /\
  ~ In nsymb (domain smap).
Proof.
intros absi abso absi' abso' smap smap' idx idx'.
simpl. destruct abso as [ | symb1 t1] eqn: eq_abso.
- intros Hnonesome. discriminate.
- destruct t1 as [ | symb2 rstack] eqn: eq_t1.
  + intros Hnonesome. discriminate.
  + intro Habs_eval. injection Habs_eval.
    intros Hidx Hsmap Habso Habsi.
    exists symb1.
    exists symb2.
    exists (String "e" (nat_to_string idx)).
    exists rstack.
    Admitted. (* abs_eval_op must fail if the new symbol is not disjoint! *)
    (*auto.*) (* All the conjunction components are assumptions *)
    (*Qed.*)


(* TODO: could it be generalized to any arithmetic operation? We'll need some way
   to relate ADD--wplus and so on *)
(* TODO: the "S d" is required because the new symbol added need one step more than its operands *)   
Lemma eval_sfs_add: forall (d: nat) (absi absi' abso abso': abstract_stack) (smap smap': sfs_map)
      (stack_ini rstack: list EVMWord)
      (v1 v2: EVMWord) (idx idx': nat),
evaluate_sfs d (SFS absi abso smap) stack_ini = Some (v1::v2::rstack) ->
abs_eval_op (SimplePriceOpcodeMk ADD) (SFS absi abso smap) idx = 
   Some ((SFS absi' abso' smap'), idx') ->
evaluate_sfs (S d) (SFS absi' abso' smap') stack_ini = Some (wplus v1 v2::rstack).
Proof.
intros d absi absi' abso abso' smap smap' stack_ini rstack v1 v2 idx idx'.
unfold evaluate_sfs at 1. 
unfold evaluate_sfs_aux. destruct abso as [ | s1 r1] eqn: eq_abso.
- intros HSome. injection HSome. intros Hnilvalue. discriminate.
- destruct (evaluate_sfs_from_map d (combine absi stack_ini) (SFS nil nil smap) s1) as
    [val1 | ] eqn: eq_eval_s1;
    (try (intro Hnonesome; discriminate)).
  + destruct r1 as [ | s2 r2] eqn: eq_r1.
    * intros HSome. injection HSome. intros Hnilvalue. discriminate.
    * destruct (evaluate_sfs_from_map d (combine absi stack_ini) 
      (SFS nil nil smap) s2) as [val2 | ] eqn: eq_eval_s2;
      (try (intro Hnonesome; discriminate)).
      -- fold evaluate_sfs_aux. 
         destruct (evaluate_sfs_aux d r2 (combine absi stack_ini) smap) as [r3 | ] eqn: eq_r3;
         (try (intro Hnonesome; discriminate)).
         ++ intros Hsomestack. injection Hsomestack. intros Hrstack Hv2 Hv1.
            intros Habsealadd.
            pose proof (abs_eval_add absi (s1 :: s2 :: r2) absi' abso' smap smap' idx idx'
            Habsealadd) as lemma_absealadd.
            destruct lemma_absealadd as [symb1 lemma_absealadd2].
            destruct lemma_absealadd2 as [symb2 lemma_absealadd3].
            destruct lemma_absealadd3 as [nsymb lemma_absealadd4].
            destruct lemma_absealadd4 as [r2' lemma_absealadd5].
            destruct lemma_absealadd5 as [Habsi [Habso [Habso' [Hsmap [Hnsymbabsi [Hnsymbabso Hnsymsmap]]]]]].
            rewrite -> Habso'. rewrite -> Hsmap. rewrite <- Habsi.
            injection Habso. intros Hr2' Hsymb2 Hsymb1.
            rewrite <- Hr2'. rewrite <- Hsymb2. rewrite <- Hsymb1.
            unfold evaluate_sfs. unfold evaluate_sfs_aux.
            unfold evaluate_sfs_from_map.
            pose proof (@not_in_domain_then_combine EVMWord nsymb absi stack_ini
              Hnsymbabsi) as Hlookupcombine.
            rewrite -> Hlookupcombine.
            pose proof (@update_lookup sfs_val smap nsymb
              (SFSbinop (SimplePriceOpcodeMk ADD) s1 s2)) as Hlookupupdt.
            rewrite -> Hlookupupdt.
            fold evaluate_sfs_from_map.
            pose proof (not_in_cons_twice nsymb s1 s2 r2) as Hnotinextiff.
            destruct Hnotinextiff as [Hnotinext _].
            apply Hnotinext in Hnsymbabso as HHnsymbabso2.
            destruct HHnsymbabso2 as [Hnsymbdiffs1 [Hnsymbdiffs2 Hnsymnotinr2]].
            apply str_diff_sym in Hnsymbdiffs1 as Hnsymbdiffs1_rev.
            pose proof (evaluate_sfs_new_symbol d absi stack_ini smap s1 nsymb val1
             (SFSbinop (SimplePriceOpcodeMk ADD) s1 s2) eq_eval_s1 Hnsymbdiffs1_rev
             Hnsymbabsi Hnsymsmap) as Hevals1updt.
            rewrite -> Hevals1updt.
            apply str_diff_sym in Hnsymbdiffs2 as Hnsymbdiffs2_rev.
            pose proof (evaluate_sfs_new_symbol d absi stack_ini smap s2 nsymb val2
             (SFSbinop (SimplePriceOpcodeMk ADD) s1 s2) eq_eval_s2 Hnsymbdiffs2_rev
             Hnsymbabsi Hnsymsmap) as Hevals2updt.
             rewrite -> Hevals2updt.
             simpl.
             fold evaluate_sfs_aux.
             pose proof (not_in_cons_twice nsymb s1 s2 r2) as Hnotinabso.
             destruct Hnotinabso as [Hnotinabso _].
             apply Hnotinabso in Hnsymbabso.
             pose proof (evaluate_sfs_stack_new_symbol d r2 absi stack_ini smap 
               r3 nsymb (SFSbinop (SimplePriceOpcodeMk ADD) s1 s2) eq_r3
               Hnsymnotinr2 Hnsymbabsi Hnsymsmap) as Hevalsfsext.
             apply evaluate_sfs_more_step in Hevalsfsext.
             rewrite -> Hevalsfsext.
             rewrite -> Hrstack. rewrite -> Hv1. rewrite -> Hv2.
             reflexivity.
Qed.


Lemma opcodeProgramStateChange_add_success: forall (stack_0: list EVMWord) 
      (es : ExecutionState),
opcodeProgramStateChange ADD (empty_execution_state stack_0) empty_callinfo 0 0 nil = inr es ->
exists (w1 w2: EVMWord) (tail: list EVMWord), 
  stack_0 = w1 :: w2 :: tail /\
  getStack_ES es = wplus w1 w2 :: tail.
Proof.
(* This should a be simple corollary from addActionPureSuccess*)
Admitted.


Lemma ADD_concrete_abs: forall (gas n d idx idx': nat) 
      (stack_ini stack_0 stack_1c stack_1a: list EVMWord) 
      (es: ExecutionState) (sfs_0 sfs_1: sfs),
opcodeProgramStateChange ADD (empty_execution_state stack_0) empty_callinfo 0 0 nil = inr es ->
getStack_ES es = stack_1c ->
evaluate_sfs d sfs_0 stack_ini = Some stack_0 ->
abs_eval_op (SimplePriceOpcodeMk ADD) sfs_0 idx = Some (sfs_1, idx') ->
evaluate_sfs (S d) sfs_1 stack_ini = Some stack_1a ->
stack_1c = stack_1a.
Proof.
intros gas n d idx idx' stack_ini stack_0 stack_1c stack_1a es sfs_0 sfs_1 Hopcodestatechange.
destruct sfs_0 as [absi abso smap].
destruct sfs_1 as [absi' abso' smap'].
pose proof (opcodeProgramStateChange_add_success stack_0 es Hopcodestatechange)
 as HstatechangeADD.
destruct HstatechangeADD as [w1 HstatechangeADD2].
destruct HstatechangeADD2 as [w2 HstatechangeADD3].
destruct HstatechangeADD3 as [rstack [Hinistack Hfinalstack]].
intros HgetStack Hevalsfspre HabsAdd Hevalsfspost.
rewrite <- HgetStack. rewrite -> Hfinalstack.
rewrite -> Hinistack in Hevalsfspre.
pose proof (eval_sfs_add d absi absi' abso abso' smap smap' stack_ini rstack w1 w2
  idx idx' Hevalsfspre HabsAdd) as HevalsfsADD.
rewrite -> Hevalsfspost in HevalsfsADD.
injection HevalsfsADD. intros eqstack1a. symmetry. assumption.
Qed.


Lemma abstract_eval_correct: forall (gas n d: nat) (prog: list OpCode) (stacki stackco stackao: list EVMWord)
      (absi abso: abstract_stack) (sfsm: sfs_map),
abstract_eval n prog = Some (SFS absi abso sfsm) ->
List.length stacki = n ->
concrete_eval gas prog stacki = Some stackco ->
evaluate_sfs d (SFS absi abso sfsm) stacki = Some stackao ->
stackco = stackao.
(* We cannot have the general result "concrete_eval prog stacki = evaluate_sfs d (SFS absi abso sfsm) stacki"
   because the concrete evaluation depends on the gas, whereas evaluating an SFS depends only on the depth 'd'
*)
Proof.
Admitted.
(* TODO Enrique: insert a value of 'd' such that guarantees evaluation of SFS inside the SFS. 
   (as it has no cycles, the length of the mapping should be one valid value for that)
*)




(******* 
 Equality of programs
*********)

(* The block has the supported instructions *)
Fixpoint valid_block (prog: list OpCode) : bool :=
match prog with
| nil => true
| (ins::t) => match ins with 
              | STOP => valid_block t
              | SimplePriceOpcodeMk ADD => valid_block t
              | SimplePriceOpcodeMk MUL => valid_block t
              | SimplePriceOpcodeMk SUB => valid_block t
              | SimplePriceOpcodeMk (PUSH _ _) => valid_block t
              | SimplePriceOpcodeMk POP => valid_block t
              | _ => false
              end
end.


(* TODO: apply all the optimizations passed as a list argument 
   How can we define a list of functions SFS -> SFS such that they are sound (preserve the evaluation
   of every symbol)?
*)
Definition eqblock (n: nat) (prog1 prog2: list OpCode) : bool :=
match (valid_block prog1, valid_block prog2) with
| (true, true) => match (abstract_eval n prog1, abstract_eval n prog2) with
                  | (Some sfs1, Some sfs2 ) => sfs_syn_eqb sfs1 sfs2
                  | _ => false
                  end
| _ => false
end.
(* TODO: add an extra argument for the list of optimization
         optimization = SFS -> SFS
         apply_optimization(SFS, list_of_optimization)
         optimization generates an SFS that is equivalent
         lemma: if you apply a list of optimization and all of them preserves the evaluation, then the final 
                SFS is equivalent
*)

Theorem eqblock_then_eq_eval: forall (gas1 gas2 n: nat) (prog1 prog2: list OpCode) (stack stack1 stack2: list EVMWord),
eqblock n prog1 prog2 = true ->
List.length stack = n ->
concrete_eval gas1 prog1 stack = Some stack1 ->
concrete_eval gas2 prog2 stack = Some stack2 ->
stack1 = stack2.
Proof.
Admitted.
(* We cannot have the general result "concrete_eval gas prog1 stack = concrete_eval gas prog2 stack"
   because both programs can have a different minimum gas, so one can return None (out-of-gas) and the
   other program can terminate sucessfuly. *)


Print Assumptions eqblock_then_eq_eval.




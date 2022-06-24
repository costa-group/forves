Require Import Arith.
Require Import Nat.
Require Import Bool.
Require Import bbv.Word.
Require Import List.
Require Import Coq_EVM.lib.evmModel.
Import ListNotations.


Module Interpreter.

Definition WLen: nat := 1024. 
Definition EVMWord:= word WLen.
Definition StackLen := 1024.

(* General opcodes that operate on stack elements and return one value on top of stack*)
Inductive gen_instr :=
  | ADD
  | MUL
  | NOT.
  
Definition eq_gen_instr (a b: gen_instr) : bool :=
match (a, b) with
 | (ADD, ADD) => true
 | (MUL, MUL) => true
 | (NOT, NOT) => true 
 | _ => false
end.
Notation "m '=?i' n" := (eq_gen_instr m n) (at level 100).

(* PUSH, POP, DUP and SWAP are hardcoded, and the other opcodes are operators *)
Inductive instr :=
  | PUSH (size: nat) (w: EVMWord)
  | POP 
  | DUP (pos: nat)
  | SWAP (pos: nat)
  | Opcode (label: gen_instr).

(* function that evaluates a list of EVMWord, they are related to gen_instr *)
Inductive operator :=
  | Op (comm: bool) (nb_args : nat) (func : list EVMWord -> option EVMWord).
  
Definition add (args: list EVMWord) : option EVMWord :=
match args with
 | [a; b] => Some (wplus a b)
 | _ => None
 end.
 
Definition mul (args: list EVMWord) : option EVMWord :=
match args with
 | [a; b] => Some (wmult a b)
 | _ => None
 end.
 
Definition not (args: list EVMWord) : option EVMWord :=
match args with
 | [a] => Some (wnot a)
 | _ => None
 end.


(* Definition of maps *)
(* The maps here link an opcode (gen_instr) to an operator *)

Definition map (K V : Type) : Type := K -> option V.

Definition empty_imap {A : Type} : map gen_instr A := (fun _ => None).
Definition updatei {A : Type} (m : map gen_instr A) (x : gen_instr) (v : A) :=
  fun x' => if x =?i x' then Some v else m x'.
Notation "x '|->i' v ';' m" := (updatei m x v)
  (at level 100, v at next level, right associativity).
Notation "x '|->i' v" := (updatei empty_imap x v)
  (at level 100).
  
Example opmap : map gen_instr operator :=
ADD |->i Op true 2 add;
MUL |->i Op true 2 mul;
NOT |->i Op false 1 not.

Definition empty_nmap {A : Type} : map nat A := (fun _ => None).
Definition updaten {A : Type} (m : map nat A) (x : nat) (v : A) :=
  fun x' => if x =? x' then Some v else m x'.
Notation "x '|->n' v ';' m" := (updaten m x v)
  (at level 100, v at next level, right associativity).
Notation "x '|->n' v" := (updaten empty_nmap x v)
  (at level 100).
  

Compute (
3 |->n ADD;
4 |->n MUL;
5 |->n NOT).


(* Execution states *)
Definition tstack := list EVMWord.
Definition tmemory := map nat EVMWord.
Definition tstorage := map nat EVMWord.

Inductive execution_state :=
 | ExState (stack: tstack) (memory: tmemory) (storage: tstorage).
 
Definition get_stack_es (es: execution_state) : tstack :=
match es with
| ExState stack _ _ => stack
end.

Definition set_stack_es (es: execution_state) (stack: tstack) : execution_state :=
match es with
| ExState _ memory storage => ExState stack memory storage
end.

Definition get_memory_es (es: execution_state) : tmemory :=
match es with
| ExState _ memory _ => memory
end.

Definition set_memory_es (es: execution_state) (memory: tmemory) : execution_state :=
match es with
| ExState stack _ storage => ExState stack memory storage
end.

Definition get_storage_es (es: execution_state) : tstorage :=
match es with
| ExState _ _ storage => storage
end.

Definition set_storage_es (es: execution_state) (storage: tstorage) : execution_state :=
match es with
| ExState stack memory _ => ExState stack memory storage
end.

(* stack manipulation operators *)

(* Polymorphic versions for manipulating the stack *)
Definition push {T : Type} (v : T) (sk : list T) : option (list T) :=
if List.length(sk) <? StackLen then Some (v :: sk) else None.

Definition pop {T : Type} (sk: list T): option (list T) :=
match sk with
 | x::sk' => Some sk'
 | _ => None
end.

Definition dup {T: Type} (k : nat) (sk: list T) : option (list T) :=
if ((k =? 0) || (16 <? k) || (StackLen <=? List.length(sk))) then None
else match nth_error sk k with
  | None => None
  | Some x => Some (x::sk)
  end.

Definition swap {T: Type} (k : nat) (sk: list T) : option (list T) :=
if ((k =? 0) || (16 <? k)) then None
else match (nth_error sk k, sk) with
     | (Some v, h::t) => Some ([v] ++ ((firstn (k-1) t)) ++ [h] ++ (skipn (k+1) sk))
     | _  => None
     end.

(* version operating on execution states *)
Definition push_c (v : EVMWord) (es : execution_state) : option execution_state :=
let sk := get_stack_es es in
match push v sk with
| None => None
| Some sk' => Some (set_stack_es es sk')
end.

Definition pop_c (es : execution_state): option execution_state :=
let sk := get_stack_es es in
match pop sk with
 | None => None
 | Some sk' => Some (set_stack_es es sk')
end.

Definition dup_c (k : nat) (es : execution_state) : option execution_state  :=
let sk := get_stack_es es in
match dup k sk with
 | None => None
 | Some sk' => Some (set_stack_es es sk')
end.

Definition swap_c (k : nat) (es : execution_state) : option execution_state :=
let sk := get_stack_es es in
match swap k sk with
 | None => None
 | Some sk' => Some (set_stack_es es sk')
end.


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
Proof. 
reflexivity.
Qed.


Definition build_es_opt_stack (es: execution_state) (h: option EVMWord) (sk: tstack) : option execution_state :=
match h with
| None => None
| Some v => Some (set_stack_es es (v :: sk))
end.


(* Concrete interpreter *)
Definition concr_intpreter_instr (inst : instr) (es: execution_state)
  (ops : map gen_instr operator) : option execution_state :=
match inst with
  | PUSH size v => push_c v es
  | POP => pop_c es
  | DUP k => dup_c k es
  | SWAP k => swap_c k es
  | Opcode label =>
      let insk := get_stack_es es in
      match (ops label) with
      | Some (Op comm nb_args func) => build_es_opt_stack es (func (firstn nb_args insk)) (skipn nb_args insk)
      | None => None
      end
  end.

Fixpoint concr_interpreter (insts : list instr) (es : execution_state)
  (ops : map gen_instr operator) : option execution_state :=
  match insts with
  | [] => Some es
  | inst::insts' =>
    match (concr_intpreter_instr inst es ops) with
    | None => None
    | Some insk' => concr_interpreter insts' insk' ops
    end
  end.

Compute (concr_interpreter 
        [PUSH 1 (natToWord WLen 7); Opcode ADD] 
        (ExState [(natToWord WLen 8);(natToWord WLen 2);(natToWord WLen 3)] empty_nmap empty_nmap)
        opmap).

End Interpreter.  



Module SFS.
Include Interpreter.

Inductive Param :=
 | pinStk (var: nat)
 | tmpVar (id: nat)
 | value (val : EVMWord).
Definition AbsStk := list Param.

Inductive SFSval :=
 | val (val : EVMWord)
 | inStk (var : nat)
 | oper (opcode: gen_instr) (args: list SFSval).

Definition SymStk := list SFSval.

Inductive Entry :=
 | Pair (key :nat) (val : SFSval).
Definition SFSMap := list Entry.  
 
Inductive SFS := 
 | SFSc (maxid : nat) (instk_size : nat) (currstk: AbsStk) (map: SFSMap).
 

Fixpoint gen_initial_stack_inv {T: Type} (size: nat) (f: nat -> T): list T :=
match size with
 | 0 => nil
 | S n => (f n)::(gen_initial_stack_inv n f)
end.
Definition gen_initial_stack {T: Type} (size: nat) (f: nat -> T): list T :=
rev (gen_initial_stack_inv size f).

 
Definition empty_sfs (size: nat) : SFS :=
let curr_stack := gen_initial_stack size pinStk in
SFSc 0 size curr_stack nil.

Compute empty_sfs 5.


(* Getters/Setters for SFS *)
Definition get_maxid_sfs (sfs: SFS) : nat :=
match sfs with
 | SFSc maxid is cs map => maxid
end.
Definition set_maxid_sfs (sfs: SFS) (idx: nat): SFS :=
match sfs with
 | SFSc maxid is cs map => SFSc idx is cs map
end.

Definition get_instk_size_sfs (sfs: SFS) : nat :=
match sfs with
 | SFSc maxid is cs map => is
end.
Definition set_instk_size_sfs (sfs: SFS) (instk_size: nat): SFS :=
match sfs with
 | SFSc maxid is cs map => SFSc maxid instk_size cs map
end.

Definition get_currstk_sfs (sfs: SFS) : AbsStk :=
match sfs with
 | SFSc maxid is cs map => cs
end.
Definition set_currstk_sfs (sfs: SFS) (currstk: AbsStk): SFS :=
match sfs with
 | SFSc maxid is cs map => SFSc maxid is currstk map
end.

Definition get_map_sfs (sfs: SFS) : SFSMap :=
match sfs with
 | SFSc maxid is cs map => map
end.
Definition set_map_sfs (sfs: SFS) (newmap: SFSMap): SFS :=
match sfs with
 | SFSc maxid is cs map => SFSc maxid is cs newmap
end.



(** [symbolic_exec_aux] takes:
   
      - s: [SymStk]: A [list SFSval] representing the initial stack
        containing only symbolic references

      - prog: [list instrs]: EVM program.

      - ops: map gen_insts operator: A map telling us info about 
        how to compute arithmetic operations.

    and returns [option SymStk]*)

(* ENRIQUE's COMMENTS:
   - the SymStk is not flattened, that's why you don't need the map in the SFS or the idx to create
     fresh variables
   - I think that handling OpCode should fail (return None) in 'firstn' if there are not enough values
     in the stack. 'firstn' simply takes 'n' elements or the whole list if the size is smaller *)    
Fixpoint symbolic_exec' (s: SymStk) (prog: list instr) 
  (ops: map gen_instr operator): option SymStk :=
  match prog with
  | nil => Some s
  | instr::prog' => 
      match instr with
      | PUSH size w => 
          match push (val w) s with
          | None => None
          | Some s' => symbolic_exec' s' prog' ops
          end
      | POP => 
          match pop s with
          | None => None
          | Some s' => symbolic_exec' s' prog' ops
          end
      | DUP pos =>
          match dup pos s with
          | None => None
          | Some s' => symbolic_exec' s' prog' ops
          end
      | SWAP pos =>
          match swap pos s with
          | None => None
          | Some s' => symbolic_exec' s' prog' ops
          end
      | Opcode label =>
          match (ops label) with
          | None => None
          | Some (Op comm nb_args f) => 
              symbolic_exec' ((oper label (firstn nb_args s))::(skipn nb_args s)) prog' ops
          end
      end
  end.

Definition symbolic_exec (n: nat) (prog: list instr)
  (ops: map gen_instr operator): option SymStk :=
  let s  := gen_initial_stack n inStk in
  symbolic_exec' s prog ops.



(* Symbolic Execution Tests *)

Example prog_00  := [
  PUSH 1 (natToWord WLen 5); 
  PUSH 1 (natToWord WLen 7); 
  PUSH 1 (natToWord WLen 7); 
  Opcode ADD;
  POP
].

Example stack_00 := [(natToWord WLen 8);(natToWord WLen 2);(natToWord WLen 3)].
Example opmap_00 : map gen_instr operator :=
(* ENRIQUE: is not the same as the opmap before? *)
ADD |->i Op true 2 add;
MUL |->i Op true 2 mul;
NOT |->i Op false 1 not. 


Compute let s := symbolic_exec 1 prog_00 opmap_00 in
      match s with
      | None => nil
      | Some s' => s'
      end.

(** [eval_sfs']
    Takes an [SFSval] and converts it to an [EVMWord]
    [oper] cases are unfolded recursively and
    [inStk] cases are checked using a concrete stack [list EVMWord]

*)
Fixpoint eval_sfs' (s: list EVMWord) (e: SFSval) 
  (ops: map gen_instr operator) : option EVMWord :=
  (* SFSval matching *)
  match e with
  | val v => Some v
  | inStk id => nth_error (rev s) id
  | oper opcode args => 
      match ops opcode with
      | None => None
      | Some  (Op comm nb_args f) =>
          (* We consider operations of 1 and 2 parameters *)
          (* ENRIQUE: we could define a mutually recursive function for SFSval and [SFSval] and avoid
             deplicity of code for 1 and 2 parameters, but it can make proving harder in the sense you'll
             see a bigger Fixpoint term *)
          match args with
          | nil => None
          | a::nil => 
              let v := eval_sfs' s a ops in
              match v with
              | Some v' => f [v']
              | None => None
              end
          | a1::a2::nil => 
              let v1 := eval_sfs' s a1 ops in
              let v2 := eval_sfs' s a2 ops in
              match v1, v2 with
              | Some v1', Some v2' => f [v1'; v2']
              | _, _ => None
              end
          | _ => None
          end
      end
  end.

(*ENRIQUE: the SymStk can be generated from a stack of 'n' elements and eval_sfs will succeed for 
  stacks bigger than 'n'. Similarly, it can succeed even for smaller stacks if the initial values
  are not used. Having the complete SFS we can check the size is exactly the same or fail otherwise *)
Fixpoint eval_sfs (s: list EVMWord) (args: SymStk) 
(ops: map gen_instr operator) : option (list EVMWord) :=
match args with
| nil => Some nil
| arg::args' => 
    match (eval_sfs' s arg ops), (eval_sfs s args' ops) with
    | Some a, Some ans => Some (a::ans)
    | _, _ => None
    end
end.
               

Fixpoint evm_to_nat (l: list EVMWord) : list nat :=
  match l with
  | nil => nil
  | h::t => (wordToNat h)::(evm_to_nat t)
  end.


(* Eval SFS Tests *)

Example sfs_00 := [oper ADD [val (natToWord WLen 1); val (natToWord WLen 2)]].
Example sfs_01 := [oper MUL [val (natToWord WLen 2); val (natToWord WLen 1)]].
Example sfs_02 := [val (natToWord WLen 2); val (natToWord WLen 1)].
Example sfs_03 := [
  oper ADD [
    oper ADD [
      val (natToWord WLen 1); 
      val (natToWord WLen 2)
      ];
    val (natToWord WLen 1) 
    ];
  val (natToWord WLen 2);
  val (natToWord WLen 2); 
  val (natToWord WLen 1)
].
Example eval_sfs_00 := match (eval_sfs stack_00 sfs_03 opmap_00) with
                          | None => nil
                          | Some s => s
                          end.
Compute evm_to_nat eval_sfs_00.


Example prog_01  := [
  PUSH 1 (natToWord WLen 5);
  PUSH 1 (natToWord WLen 5);
  Opcode ADD
].

Example stack_01 := [(natToWord WLen 8);(natToWord WLen 2);(natToWord WLen 3)].

Example sym_exe_01 := match symbolic_exec 1 prog_01 opmap_00 with
                      | None => nil
                      | Some s => s
                      end.
Example eval_sfs_01 := match eval_sfs stack_01 sym_exe_01 opmap_00 with
                       | None => nil
                       | Some s => s
                       end.
Compute sym_exe_01.
Compute evm_to_nat eval_sfs_01. (* ENRIQUE: the SymStk considered only one element in the initial stack,
                                   but the evaluation provides 3. I'd prefer if evaluation only succeeds
                                   if provided a concrete stack of the same size *)


End SFS.






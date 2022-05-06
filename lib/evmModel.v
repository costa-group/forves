Require Import bbv.Word.
Require Import Coq.Lists.List.
Require Import Coq.Arith.EqNat.
Require Import Coq.Arith.Lt.
Require Import Coq.ZArith.ZArith.
Require Import Coq.Arith.Compare_dec.
Require Import Coq.NArith.NArith.
Require Import Coq.Structures.OrderedType.
Require Import Coq.Numbers.NatInt.NZLog.
Require Import Coq.ZArith.Wf_Z.
Require Export FMapAVL.
Require Export Coq.Structures.OrderedTypeEx.
Require Import Lia.
Module M := FMapAVL.Make(N_as_OT).


(* All EVM notation is inside the scope EVM_scope *)
Declare Scope EVM_scope.
Open Scope EVM_scope.

(* Compute (wordToNat (wplus (natToWord 32 10) (natToWord 32 20))). *)
Definition WLen: nat := 256. 
Definition bigNum: N := wordToN (wlshift' (natToWord 257 1) 256).
Definition EVMWord:= word WLen.
Definition ByteLen: nat := 8.
Definition Byte := word ByteLen.
Definition StackLen := 1024.
Definition WZero: EVMWord  := natToWord WLen 0.
Definition WTrue: EVMWord  := natToWord WLen 1. 
Definition WFalse: EVMWord := natToWord WLen 0. 
Definition ZeroBit: word _ := natToWord 1 0. 
Definition W0xFF: EVMWord := natToWord WLen 255.
Definition boolToWord(b: bool): EVMWord := 
  match b with 
  | true  => WTrue 
  | false => WFalse
  end.

(* Compute W0xFF. *)
Definition wgtbWorToUZ{sz: nat}(w: word sz): Z := wordToZ(bbv.Word.combine w ZeroBit).
Definition wugtb{sz: nat}(l r: word sz): bool := Z.gtb (wgtbWorToUZ l) (wgtbWorToUZ r).
Definition wultb{sz: nat}(l r: word sz): bool := Z.ltb (wgtbWorToUZ l) (wgtbWorToUZ r).
Definition wsgtb{sz: nat}(l r: word sz): bool := Z.gtb (wordToZ l) (wordToZ r).
Definition wsltb{sz: nat}(l r: word sz): bool := Z.ltb (wordToZ l) (wordToZ r).
Definition withbyte(w: EVMWord)(i: nat): EVMWord := wand (wrshift' w (248%nat - (i * 8))) W0xFF.
Definition Wones: EVMWord := wones WLen.
Definition pushMask(bytes: nat): EVMWord := wnot (wlshift' Wones (bytes * 8)).
Definition pushWordPass(w: EVMWord)(bytes: nat): EVMWord := wand (pushMask bytes) w.
(* Compute whd W0xFF. *)
Definition sextWordBytes(w: EVMWord)(bytes: nat): EVMWord := 
  match whd (wlshift' w (256 - (bytes * 8))) with 
  | true  => wor (wlshift' Wones (bytes * 8)) (pushMask bytes)
  | false => pushMask bytes
  end. 

Definition bytetoEWMword(w: word 8): EVMWord. Proof.
apply (Word.combine w (wzero' 248)).
Defined.
Compute wordToN (bytetoEWMword (natToWord 8 1)).
Definition wordSubModulus(a b: EVMWord): EVMWord := 
  if N.ltb (wordToN a) (wordToN b) 
  then NToWord WLen (bigNum - ((wordToN b) - (wordToN a)))
  else wminus a b
.
Definition map_n_evmword := M.t EVMWord.
Definition find {V: Type}(k: EVMWord)(m: M.t V) := M.find (wordToN k) m.
Definition update (p: EVMWord * EVMWord) (m: map_n_evmword) :=
  M.add (wordToN (fst p)) (snd p) m.
Definition mapLength {V: Type}(m: M.t V): nat :=
  length (M.elements m).
Fixpoint wordmsb {sz: nat}(bitnum aux: nat)(w: word sz): nat :=
  match w with 
  | WO => aux
  | WS b w1 => 
    match b with 
    | true  => wordmsb (S bitnum) bitnum w1
    | false => wordmsb (S bitnum) aux w1
    end 
  end.

Definition log2Orzero {sz} (w: word sz): nat := wordmsb 0 0 w.
(* aux parameter required to ensure termnation checker, for words we will have at most 256 iterations *)
Fixpoint effExpAux(a b: N)(aux: nat){struct aux}: N  := 
  match aux with 
  | O => 0 
  | S p =>
    match N.eqb b 0 with
    | true  => 1
    | false => 
      match N.eqb (N.modulo b 2) 1 with
      | true  => a * (effExpAux a (b - 1) p)
      | false => (effExpAux a (b / 2) p ) * (effExpAux a (b / 2) p)
      end
    end
  end. 

Fixpoint expmodAux (a b m: N)(aux: nat): N:=
  match N.eqb m 1 with 
  | true  => 0 
  | false =>
    match aux with 
    | 0 => 0
    | S p => 
      match N.eqb b 0 with 
      | true  => 1
      | false => 
        match N.eqb (N.modulo b 2) 1 with
        | true  => N.modulo (a * (effExpAux a (b - 1) p)) m
        | false =>  let presq := (effExpAux a (b / 2) p ) in N.modulo (presq * presq) m
        end
      end
    end
  end.

Definition effExp(a b: N): N := effExpAux a b 512%nat.
Definition expmod(a b m: N): N := expmodAux a b m 512%nat.
(* Compute let maxword := (effExp 2 256) in let mwm1 
:= N.sub maxword 1 in effExp mwm1 mwm1. *)
Definition wordModulus := effExp 2 256.

Notation "k |-> v" := (pair k v) (at level 60) : EVM_scope.
Notation "[ ]" := (M.empty nat) : EVM_scope.
Notation "[ p1 , .. , pn ]" := (update p1 .. (update pn (M.empty nat)) .. ) : EVM_scope.

Compute pushWordPass Wones 32.

Compute NToWord 8 1.

Definition combine {A B C: Type}(f: A -> B)(g: B -> C): A -> C := 
fun a => g (f a).

Notation "f1 * f2" := (combine f1 f2) : EVM_scope.

Definition map{L R R1: Type}(s: L + R)(f: R -> R1): L + R1 := 
  match s with 
  | inl l => inl l
  | inr r => inr (f r)
  end.

Definition flatMap{L R R1: Type}(s: L + R)(f: R -> L + R1): L + R1 := 
  match s with 
  | inl l => inl l
  | inr r => f r
  end.


Definition flatMapT(L R R1: Type)(s: L + R)(f: R -> L + R1): L + R1 := 
  match s with 
  | inl l => inl l
  | inr r => f r
  end.

Definition leftMap{L1 L2 R: Type}(s: L1+R)(f: L1 -> L2): L2 + R := 
  match s with 
  | inl l => inl (f l)
  | inr r => inr r
  end.

(* end straightforward either impl*)

(* very util functions*) 

Fixpoint compareNatsAndAct{T: Set}(a b: nat)(ifAgreaterOrEqualToB ifBgreater: T): T:= 
  match (a, b) with 
   | (O, O)            => ifAgreaterOrEqualToB 
   | (S _, O)          => ifAgreaterOrEqualToB
   | (O, S _)          => ifBgreater
   | (S predA,S predB) => compareNatsAndAct predA predB ifAgreaterOrEqualToB ifBgreater
  end.

Fixpoint gtb(a b: nat): bool := 
  match (a,b) with 
  | (O, O) => false
  | (S _, O) => true
  | (O, S _) => false
  | (S predA, S predB) => gtb predA predB
  end.
Definition mapO{A B: Type}(o: option A)(f: A -> B): option B := 
  match o with 
  | Some a => Some (f a)
  | None   => None
  end. 
Definition flatMapO{A B: Type}(o: option A)(f: A -> option B): option B := 
  match o with 
  | Some a => f a
  | None   => None
  end. 
(* Compute let pos := 4 in let l := 1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: nil in skipn 1 (firstn (pos - 1) l).
Compute let pos := 4 in let l := 1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: nil in skipn pos l. *)
(* TODO: proofs  
 *)
Definition listSwapWithHead{A: Set}(l: list A)(pos: nat): option (list A) := 
  flatMapO
  (hd_error l) 
  (fun head => 
    flatMapO 
    (nth_error l pos)
    (fun item => 
      let middle := skipn 1 (firstn (pos) l) in
      let rest   := skipn (pos + 1) l in
      Some ((item :: middle) ++ (head :: rest))
    )
  ).

Definition getSliceFromList{T: Type}(l: list T)(offset length: nat): option (list T) := 
  match Nat.ltb (offset+ length) (List.length l) with
  | true  => Some (firstn length (skipn offset l))
  | false => None
  end.

Compute let offset := 35 in let length := 3 in let l := 0 :: 1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: nil in getSliceFromList l offset length.

Compute let pos := 4 in let l := 0 :: 1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: nil in listSwapWithHead l pos.
(* end very util functions *) 
(* execution 'monad' and error codes*)
Inductive Log: Type := 
| Log0: list EVMWord -> Log
| Log1: EVMWord -> list EVMWord -> Log
| Log2: EVMWord -> EVMWord -> list EVMWord -> Log
| Log3: EVMWord -> EVMWord -> EVMWord -> list EVMWord -> Log
| Log4: EVMWord -> EVMWord -> EVMWord -> EVMWord -> list EVMWord -> Log.

Inductive ExecutionState: Type := 
| ExecutionStateMk: list (EVMWord) -> map_n_evmword -> map_n_evmword -> (M.t (list (word 8))) -> nat -> (list Log) -> ExecutionState. (* pc stack memory storage contracts logs*)

Definition getLog_ES es := 
match es with 
| ExecutionStateMk _ _ _ _ _ logs => logs
end.

Definition setLog_ES es logs := 
match es with 
| ExecutionStateMk stack memory storage contractMap pc _ => ExecutionStateMk stack memory storage contractMap pc logs
end.

Definition getPc_ES es := 
match es with
| ExecutionStateMk _ _ _ _ pc _ => pc
end.

Definition setPc_ES es pc := 
match es with
| ExecutionStateMk stack memory storage contractMap _ logs => ExecutionStateMk stack memory storage contractMap pc logs
end.

Definition getStack_ES es := 
match es with
| ExecutionStateMk stack _ _ _ _ _ => stack
end.

Definition getMemory_ES es := 
match es with
| ExecutionStateMk _ memory _ _ _ _ => memory
end.

Definition setStack_ES es stack := 
match es with
| ExecutionStateMk _ memory storage contractMap pc logs => ExecutionStateMk stack memory storage contractMap pc logs 
end.

Definition setMemory_ES es memory := 
match es with
| ExecutionStateMk stack _ storage contractMap pc logs => ExecutionStateMk stack memory storage contractMap pc logs
end.

Definition getStorage_ES es := 
match es with
| ExecutionStateMk _ _ storage _ _ _ => storage
end.

Definition setStorage_ES es storage := 
match es with
| ExecutionStateMk stack memory _ contractMap pc logs => ExecutionStateMk stack memory storage contractMap pc logs
end.

Definition getContractMap_ES es := 
match es with
| ExecutionStateMk _ _ _ contractMap _ _ => contractMap
end.

Definition setContractMap_ES es contractMap := 
match es with
| ExecutionStateMk stack memory storage _ pc logs => ExecutionStateMk stack memory storage contractMap pc logs
end.

Inductive SuccessfulExecutionResult: Type := 
| SuccessfulExecutionResultMk: ExecutionState -> SuccessfulExecutionResult
| SuccessfulExecutionResultMkWithData: ExecutionState -> list EVMWord -> SuccessfulExecutionResult
.

Inductive ErrorCode: Set := 
| OutOfGas: ErrorCode
| InvalidOpcode: ErrorCode
| InvalidJumpDest: ErrorCode
| StackUnderflow: ErrorCode
| StackOverflow: ErrorCode
| BadWordAsByte: ErrorCode
| BadSigExtendWord: ErrorCode
| BadByteArgI: ErrorCode
| BadShlArgI: ErrorCode
| BadShrArgI: ErrorCode
| BadCallDataLoadArgI: ErrorCode
| BadPeekArg: ErrorCode
| NonexistentAddress: ErrorCode
| NonexistentContract: ErrorCode
| NonexistentMemoryCell: ErrorCode
| NonexistentStorageCell: ErrorCode
| NonexistentCallDataCell : ErrorCode
| NotImplemented : ErrorCode
.

Inductive ErrorneousExecutionResult: Type := 
| ErrorneousExecutionResultMk: ErrorCode -> ExecutionState -> ErrorneousExecutionResult.

Definition ExecutionResult: Type := ErrorneousExecutionResult + SuccessfulExecutionResult.

Definition OpcodeApplicationResult: Type := ExecutionResult + ExecutionState.

Definition ExecutionResultOr T : Type := ExecutionResult + T.

(* end execution 'monad' and error codes*)
(* handy constructors *) 

Definition stopExecutionWithSuccess(es: ExecutionState): OpcodeApplicationResult := 
  inl (inr (SuccessfulExecutionResultMk es)).

Definition failWithErrorCode{T: Type}(es: ExecutionState)(errorCode: ErrorCode): ExecutionResultOr T :=
  inl ( inl (ErrorneousExecutionResultMk errorCode es)). 

(* Definition runningExecutionWithState es: OpcodeApplicationResult := inr es. *)

Definition runningExecutionWithState {T: Type}(t: T): ExecutionResultOr T := inr t.
(* end handy constructors *) 
(* program counter operations *)

Definition setProgramCounter(es: ExecutionState)(programLength newPc: nat): OpcodeApplicationResult := 
    match Nat.leb programLength newPc with
    | true  => runningExecutionWithState es
    | false => failWithErrorCode es InvalidJumpDest
    end.
(* end program counter opertaions*)

Definition attach{T: Type}(o: OpcodeApplicationResult)(t: T): ExecutionResultOr (ExecutionState *T) := 
  map 
  o 
  (fun es => (es,t)).

(* stack operations *)
Definition pushItemToExecutionStateStack es item: OpcodeApplicationResult :=
  if(length (getStack_ES es) <? 1024)
  then runningExecutionWithState (setStack_ES es (item :: (getStack_ES es)))
  else failWithErrorCode es StackOverflow.

Definition removeAndDropFromStackOneItem es := 
  let stack := getStack_ES es in 
    match stack with 
      | head :: tail => runningExecutionWithState (setStack_ES es tail)
      | nil => failWithErrorCode es StackUnderflow
    end.

Definition removeAndReturnFromStackOneItem es: (ExecutionResultOr (ExecutionState * EVMWord)) := 
  let stack := getStack_ES es in  
    match stack with 
      | head1 :: tail => 
          runningExecutionWithState ((setStack_ES es tail), head1)
      | nil => failWithErrorCode es StackUnderflow
    end.

Definition removeAndReturnFromStackTwoItems es: (ExecutionResultOr (ExecutionState * EVMWord * EVMWord)) := 
  let stack := getStack_ES es in 
    match stack with 
      | head1 :: head2 :: tail => 
          runningExecutionWithState
            ((setStack_ES es tail), head1, head2)
      | nil | _ :: nil => failWithErrorCode es StackUnderflow
    end.

Definition removeAndReturnFromStackTwoItemsEnder es: (ErrorneousExecutionResult + (ExecutionState * EVMWord * EVMWord)) := 
  let stack := getStack_ES es in 
    match stack with 
      | head1 :: head2 :: tail => 
          inr ((setStack_ES es tail), head1, head2)
      | nil | _ :: nil => inl (ErrorneousExecutionResultMk StackUnderflow es)
    end.

Definition removeAndReturnFromStackThreeItems es: (ExecutionResultOr (ExecutionState * EVMWord * EVMWord * EVMWord)) := 
  let stack := getStack_ES es in 
    match stack with 
      | head1 :: head2 :: head3:: tail => 
          runningExecutionWithState
            ((setStack_ES es tail), head1, head2, head3)
      | nil | _ :: nil | _ :: _ :: nil => failWithErrorCode es StackUnderflow
    end.

Definition removeAndReturnFromStackFourItems es: (ExecutionResultOr (ExecutionState * EVMWord * EVMWord * EVMWord * EVMWord)) := 
  let stack := getStack_ES es in 
    match stack with 
      | head1 :: head2 :: head3 :: head4 :: tail => 
          runningExecutionWithState
            ((setStack_ES es tail), head1, head2, head3, head4)
      | nil | _ :: nil | _ :: _ :: nil | _ :: _ :: _ :: nil=> failWithErrorCode es StackUnderflow
    end.

Definition removeAndReturnFromStackFiveItems es: (ExecutionResultOr (ExecutionState * EVMWord * EVMWord * EVMWord * EVMWord * EVMWord)) := 
  let stack := getStack_ES es in 
    match stack with 
      | head1 :: head2 :: head3 :: head4 :: head5 :: tail => 
          runningExecutionWithState
            ((setStack_ES es tail), head1, head2, head3, head4, head5)
      | nil | _ :: nil | _ :: _ :: nil | _ :: _ :: _ :: nil | _ :: _ :: _ :: _ :: nil => failWithErrorCode es StackUnderflow
    end.

Definition removeAndReturnFromStackSixItems es: (ExecutionResultOr (ExecutionState * EVMWord * EVMWord * EVMWord * EVMWord * EVMWord * EVMWord)) := 
  let stack := getStack_ES es in 
    match stack with 
      | head1 :: head2 :: head3 :: head4 :: head5 :: head6 :: tail => 
          runningExecutionWithState
            ((setStack_ES es tail), head1, head2, head3, head4, head5, head6)
      | nil | _ :: nil | _ :: _ :: nil | _ :: _ :: _ :: nil | _ :: _ :: _ :: _ :: nil | _ :: _ :: _ :: _ :: _ :: nil => failWithErrorCode es StackUnderflow
    end.

Definition peekNthItemFromStack es (n: nat): (ExecutionResultOr EVMWord):= 
  let stack := getStack_ES es in
    match nth_error stack n with 
      | Some item => runningExecutionWithState item
      | None      => failWithErrorCode es BadPeekArg
    end.
(* end stack operations *)

Fixpoint insertItemsIntoMemoryAux(es: ExecutionState)(acc offset: nat)(words: list EVMWord){struct words} : ExecutionState :=
  match words with 
  | nil        => es
  | w :: words' =>
    let mem := getMemory_ES es in 
    let updatedMemory := update (natToWord WLen (acc + offset), w) mem in 
    let new_es := setMemory_ES es updatedMemory in 
    insertItemsIntoMemoryAux new_es (S acc) offset words'
  end.

Definition insertItemsIntoMemory(es: ExecutionState)(offset: nat)(words: list EVMWord): ExecutionState :=
  insertItemsIntoMemoryAux es 0 offset words.

Definition zipBytesToWord(l: list (word 8)):= 
  fold_left (fun acc => fun b => wor (wlshift' acc 8) (bytetoEWMword b)) l WZero.
(* 
Lemma 
Compute let w0 := natToWord 8 1 in let w1 := natToWord 8 1 in let w2 := natToWord 8 1 in let res := zipBytesToWord (w1 :: w1 :: w1 :: w1 :: nil) in wordToN res.
 *)

Fixpoint zipListOfBytesIntoListOfWordsAux(l: list (word 8))(crutch: nat): list EVMWord :=
  match crutch with 
  | O => match l with | nil => nil | _ :: __ => (zipBytesToWord l) :: nil end
  | S p => zipListOfBytesIntoListOfWordsAux (skipn 32 l) (p) ++ (zipBytesToWord (firstn 32 l) :: nil) 
  end.

Definition zipListOfBytesIntoListOfWords(l: list (word 8)): list EVMWord := 
  zipListOfBytesIntoListOfWordsAux l ( ((length l) / 32) + 1).

(* WordUtil *)
Definition extractByteAsNat(w: EVMWord): ErrorCode + nat := 
  match weqb (wlshift' w 8%nat) WZero with 
  | true  => inr (wordToNat w)
  | false => inl BadWordAsByte
  end.

(* WordUtil *)
Inductive SimplePriceOpcode: Set :=
| ADD	          : SimplePriceOpcode
| MUL	          : SimplePriceOpcode
| SUB	          : SimplePriceOpcode
| DIV	          : SimplePriceOpcode
| SDIV	        : SimplePriceOpcode
| MOD	          : SimplePriceOpcode
| SMOD	        : SimplePriceOpcode
| ADDMOD	      : SimplePriceOpcode
| MULMOD	      : SimplePriceOpcode
| SIGNEXTEND	  : SimplePriceOpcode
| LT	          : SimplePriceOpcode
| GT	          : SimplePriceOpcode
| SLT	          : SimplePriceOpcode
| SGT	          : SimplePriceOpcode
| EQ	          : SimplePriceOpcode
| ISZERO	      : SimplePriceOpcode
| AND	          : SimplePriceOpcode
| OR	          : SimplePriceOpcode
| XOR	          : SimplePriceOpcode
| NOT	          : SimplePriceOpcode
| BYTE          : SimplePriceOpcode
| ADDRESS	      : SimplePriceOpcode
| BALANCE	      : SimplePriceOpcode
| ORIGIN	      : SimplePriceOpcode
| CALLER	      : SimplePriceOpcode
| CALLVALUE	    : SimplePriceOpcode
| CALLDATALOAD	: SimplePriceOpcode
| CALLDATASIZE	: SimplePriceOpcode
| CODESIZE	    : SimplePriceOpcode
| GASPRICE	    : SimplePriceOpcode
| EXTCODESIZE	  : SimplePriceOpcode
| BLOCKHASH	    : SimplePriceOpcode
| COINBASE	    : SimplePriceOpcode
| TIMESTAMP	    : SimplePriceOpcode
| NUMBER	      : SimplePriceOpcode
| DIFFICULTY  	: SimplePriceOpcode
| GASLIMIT	    : SimplePriceOpcode
| POP	          : SimplePriceOpcode
| MLOAD	        : SimplePriceOpcode
| MSTORE	      : SimplePriceOpcode
| MSTORE8	      : SimplePriceOpcode
| SLOAD	        : SimplePriceOpcode
| PC	          : SimplePriceOpcode
| MSIZE	        : SimplePriceOpcode
| GAS	          : SimplePriceOpcode
| JUMPDEST	    : SimplePriceOpcode
| PUSH	        : word 5 -> EVMWord -> SimplePriceOpcode
| DUP	          : word 4 -> SimplePriceOpcode
| SWAP	        : word 4 -> SimplePriceOpcode
| CREATE	      : SimplePriceOpcode
| JUMP          : SimplePriceOpcode
| JUMPI         : SimplePriceOpcode
.

Definition simplePriceOpcodePrice(o: SimplePriceOpcode): nat :=
  match o with
  | ADD	          => 3
  | MUL	          => 5
  | SUB	          => 3
  | DIV	          => 5
  | SDIV	        => 5
  | MOD	          => 5
  | SMOD	        => 5
  | ADDMOD	      => 8
  | MULMOD	      => 8
  | SIGNEXTEND	  => 5
  | LT	          => 3
  | GT	          => 3
  | SLT	          => 3
  | SGT	          => 3
  | EQ	          => 3
  | ISZERO	      => 3
  | AND	          => 3
  | OR	          => 3
  | XOR	          => 3
  | NOT	          => 3
  | BYTE          => 3
  | ADDRESS	      => 2
  | BALANCE	      => 400
  | ORIGIN	      => 2
  | CALLER	      => 2
  | CALLVALUE	    => 2
  | CALLDATALOAD	=> 3
  | CALLDATASIZE	=> 2
  | CODESIZE	    => 2
  | GASPRICE	    => 2
  | EXTCODESIZE	  => 700
  | BLOCKHASH	    => 20
  | COINBASE	    => 2
  | TIMESTAMP	    => 2
  | NUMBER	      => 2
  | DIFFICULTY  	=> 2
  | GASLIMIT	    => 2
  | POP	          => 2
  | MLOAD	        => 3
  | MSTORE	      => 3
  | MSTORE8	      => 3
  | SLOAD	        => 200
  | PC	          => 2
  | MSIZE	        => 2
  | GAS	          => 2
  | JUMPDEST	    => 1
  | PUSH _ _	    => 3
  | DUP _	        => 3
  | SWAP	_       => 3
  | CREATE	      => 32000
  | JUMP          => 8
  | JUMPI         => 10
  end.

Inductive ComplexPriceOpcode: Set :=
|	EXP                : ComplexPriceOpcode
|	SHA3	             : ComplexPriceOpcode
|	CALLDATACOPY	     : ComplexPriceOpcode
|	CODECOPY	         : ComplexPriceOpcode
|	EXTCODECOPY	       : ComplexPriceOpcode
|	SSTORE	           : ComplexPriceOpcode
|	LOG0	             : ComplexPriceOpcode
|	LOG1	             : ComplexPriceOpcode
|	LOG2	             : ComplexPriceOpcode
|	LOG3	             : ComplexPriceOpcode
|	LOG4	             : ComplexPriceOpcode
|	CALL	             : ComplexPriceOpcode
|	CALLCODE	         : ComplexPriceOpcode
|	DELEGATECALL	     : ComplexPriceOpcode
|	SELFDESTRUCT	     : ComplexPriceOpcode
.


Inductive OpCode: Set :=
|	STOP	              : OpCode
|	RETURN	            : OpCode
| ComplexPriceOpcodeMk: ComplexPriceOpcode -> OpCode
| SimplePriceOpcodeMk : SimplePriceOpcode  -> OpCode
.

Inductive CallInfo: Type := 
| CallInfoMk: 
  list (EVMWord)(*calldata*) ->
  EVMWord(*this contract address*) ->
  EVMWord(*caller balance*) ->
  EVMWord(*transaction hash*) ->
  EVMWord(*caller address*) ->
  EVMWord(*call eth value*) ->
  list Byte(*this contract code*) ->
  EVMWord(*tx gas price*) ->
  EVMWord(*block hash*) ->
  EVMWord(*block number*) ->
  EVMWord(*block dificulty*) ->
  EVMWord(*block timestamp*) ->
  EVMWord(*gas block limit*) ->
  EVMWord(*miner's address*) ->
  map_n_evmword(*account balances *) -> 
  CallInfo.

(* 
  match _ with 
  | CallInfoMk calldata thisContractAddress callerBalance transactionHash callerAddress callEthValue thisContractCode txGasPrice blockHash blockNumber blockDificulty blockTimestamp gasLimit miner accountBalances=> 
  end
 *)
Definition get_calldata(ci: CallInfo): list EVMWord := 
  match ci with 
  | CallInfoMk calldata thisContractAddress callerBalance transactionHash callerAddress callEthValue thisContractCode txGasPrice blockHash blockNumber blockDificulty blockTimestamp gasLimit miner accountBalances=> 
    calldata
  end.

Definition get_thisContractAddress(ci: CallInfo): EVMWord := 
  match ci with 
  | CallInfoMk calldata thisContractAddress callerBalance transactionHash callerAddress callEthValue thisContractCode txGasPrice blockHash blockNumber blockDificulty blockTimestamp gasLimit miner accountBalances=> 
    thisContractAddress
  end.

Definition get_callerBalance(ci: CallInfo): EVMWord := 
  match ci with 
  | CallInfoMk calldata thisContractAddress callerBalance transactionHash callerAddress callEthValue thisContractCode txGasPrice blockHash blockNumber blockDificulty blockTimestamp gasLimit miner accountBalances=> 
    callerBalance
  end.

Definition get_transactionHash(ci: CallInfo): EVMWord := 
  match ci with 
  | CallInfoMk calldata thisContractAddress callerBalance transactionHash callerAddress callEthValue thisContractCode txGasPrice blockHash blockNumber blockDificulty blockTimestamp gasLimit miner accountBalances=> 
    transactionHash
  end.

Definition get_callerAddress(ci: CallInfo): EVMWord := 
  match ci with 
  | CallInfoMk calldata thisContractAddress callerBalance transactionHash callerAddress callEthValue thisContractCode txGasPrice blockHash blockNumber blockDificulty blockTimestamp gasLimit miner accountBalances=> 
    callerAddress
  end.

Definition get_callEthValue(ci: CallInfo): EVMWord := 
  match ci with 
  | CallInfoMk calldata thisContractAddress callerBalance transactionHash callerAddress callEthValue thisContractCode txGasPrice blockHash blockNumber blockDificulty blockTimestamp gasLimit miner accountBalances=> 
    callEthValue
  end.

Definition get_thisContractCode(ci: CallInfo): list (word ByteLen) := 
  match ci with 
  | CallInfoMk calldata thisContractAddress callerBalance transactionHash callerAddress callEthValue thisContractCode txGasPrice blockHash blockNumber blockDificulty blockTimestamp gasLimit miner accountBalances=> 
    thisContractCode
  end.

Definition get_txGasPrice(ci: CallInfo): EVMWord := 
  match ci with 
  | CallInfoMk calldata thisContractAddress callerBalance transactionHash callerAddress callEthValue thisContractCode txGasPrice blockHash blockNumber blockDificulty blockTimestamp gasLimit miner accountBalances=> 
    txGasPrice
  end.

Definition get_blockHash(ci: CallInfo):EVMWord := 
  match ci with 
  | CallInfoMk calldata thisContractAddress callerBalance transactionHash callerAddress callEthValue thisContractCode txGasPrice blockHash blockNumber blockDificulty blockTimestamp gasLimit miner accountBalances=> 
    blockHash
  end.

Definition get_blockNumber(ci: CallInfo): EVMWord := 
  match ci with 
  | CallInfoMk calldata thisContractAddress callerBalance transactionHash callerAddress callEthValue thisContractCode txGasPrice blockHash blockNumber blockDificulty blockTimestamp gasLimit miner accountBalances=> 
    blockNumber
  end.

Definition get_blockDificulty(ci: CallInfo): EVMWord := 
  match ci with 
  | CallInfoMk calldata thisContractAddress callerBalance transactionHash callerAddress callEthValue thisContractCode txGasPrice blockHash blockNumber blockDificulty blockTimestamp gasLimit miner accountBalances=> 
    blockDificulty
  end.

Definition get_gasLimit(ci: CallInfo): EVMWord := 
  match ci with 
  | CallInfoMk calldata thisContractAddress callerBalance transactionHash callerAddress callEthValue thisContractCode txGasPrice blockHash blockNumber blockDificulty blockTimestamp gasLimit miner accountBalances=> 
    blockDificulty
  end.

Definition get_miner(ci: CallInfo): EVMWord := 
  match ci with 
  | CallInfoMk calldata thisContractAddress callerBalance transactionHash callerAddress callEthValue thisContractCode txGasPrice blockHash blockNumber blockDificulty blockTimestamp gasLimit miner accountBalances=> 
    miner
  end.

Definition get_blockTimestamp(ci: CallInfo): EVMWord := 
  match ci with 
  | CallInfoMk calldata thisContractAddress callerBalance transactionHash callerAddress callEthValue thisContractCode txGasPrice blockHash blockNumber blockDificulty blockTimestamp gasLimit miner accountBalances=> 
    blockTimestamp
  end.

Definition get_accountBalances(ci: CallInfo): map_n_evmword := 
  match ci with 
  | CallInfoMk calldata thisContractAddress callerBalance transactionHash callerAddress callEthValue thisContractCode txGasPrice blockHash blockNumber blockDificulty blockTimestamp gasLimit miner accountBalances=> 
    accountBalances
  end.

Fixpoint getSliceFromMapAux{V: Type}(m: M.t V)(offset: EVMWord)(length : nat)(acc: list V){struct length}: ErrorCode + (list V) := 
  match length with 
  | O      => 
    match find offset m with
    | Some v => inr (acc ++ (v :: nil))
    | None   => inl NonexistentMemoryCell
    end
  | S pred => 
    match find offset m  with
    | Some v => getSliceFromMapAux m (wplus offset WTrue) pred (acc ++ (v :: nil))
    | None   => inl NonexistentMemoryCell
    end
  end.

Definition getSliceFromMap{V: Type}(m: M.t V)(offset: EVMWord)(length : nat): ErrorCode + (list V) := 
  getSliceFromMapAux m offset length nil.

Definition stopAction(state: ExecutionState): OpcodeApplicationResult := 
  stopExecutionWithSuccess (state).

Definition addActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackTwoItems state)
    ( fun tup3 => 
      match tup3 with 
      | (es, a, b) => (pushItemToExecutionStateStack es (wplus a b))  
      end
    ).

Definition mulActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, a, b) => 
        pushItemToExecutionStateStack es (wmult a b)
      end
    ).

Definition subActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, a, b) => pushItemToExecutionStateStack es (wordSubModulus a b)
      end
    ).

Definition divActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, a, b) => (pushItemToExecutionStateStack es (wdiv a b))  
      end
    ).

Definition sdivActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, a, b) => (pushItemToExecutionStateStack es (wdivZ a b))  
      end
    ).

Definition modActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, a, b) => (pushItemToExecutionStateStack es (wmod a b))  
      end
    ).

Definition smodActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap 
    (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, a, b) => (pushItemToExecutionStateStack es (ZToWord WLen (Z.rem (wordToZ a) (wordToZ b))))  
      end
    ).

Definition addmodActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap 
    (removeAndReturnFromStackThreeItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, a, b, N) => 
      let za := wordToZ a in let zb := wordToZ b in let zN := Z.of_N (wordToN N) in 
      let zres := Z.rem (za + zb) zN in
      (pushItemToExecutionStateStack es (ZToWord WLen zres))  
      end
    ).

Definition mulmodActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap 
    (removeAndReturnFromStackThreeItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, a, b, N) => 
      let za := wordToZ a in let zb := wordToZ b in let zN := Z.of_N (wordToN N) in 
      let zres := Z.rem (za * zb) zN in
      (pushItemToExecutionStateStack es (ZToWord WLen zres))  
      end
    ).

Definition signextendActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap 
    (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, a, b) => 
        match extractByteAsNat b with 
        | inl err => failWithErrorCode es err
        | inr n   => (pushItemToExecutionStateStack es (sextWordBytes a n))
        end
      end
    ).

Definition ltActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, a, b) => (pushItemToExecutionStateStack es (boolToWord (wultb a b)))  
      end
    ).

Definition gtActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, a, b) => (pushItemToExecutionStateStack es (boolToWord (wugtb a b)))  
      end
    ).


Definition sltActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, a, b) => (pushItemToExecutionStateStack es (boolToWord (wsltb a b)))  
      end
    ).

Definition sgtActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, a, b) => (pushItemToExecutionStateStack es (boolToWord (wsgtb a b)))  
      end
    ).


Definition eqActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, a, b) => (pushItemToExecutionStateStack es (boolToWord (weqb a b)))  
      end
    ).

Definition iszeroActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackOneItem state)
    (fun tup2 => 
      match tup2 with 
      | (es, a) => (pushItemToExecutionStateStack es (boolToWord (weqb a WZero)))  
      end
    ).

Definition andActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, a, b) => (pushItemToExecutionStateStack es (wand a b))  
      end
    ).

Definition orActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, a, b) => (pushItemToExecutionStateStack es (wor a b))  
      end
    ).

Definition xorActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, a, b) => (pushItemToExecutionStateStack es (wxor a b))  
      end
    ).

Definition notActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackOneItem state)
    (fun tup2 => 
      match tup2 with 
      | (es, a) => (pushItemToExecutionStateStack es (wnot a))  
      end
    ).

Definition byteActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, i, x) => 
        match extractByteAsNat i with 
        | inr inat    => 
            match Nat.ltb inat 32 with 
            | true  => (pushItemToExecutionStateStack es (withbyte x inat)) 
            | false => failWithErrorCode es BadShlArgI
            end
        | inl errCode => failWithErrorCode es errCode
        end
      end
    ).

Definition shlActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, i, x) => 
        match extractByteAsNat i with 
        | inr inat    => 
            match Nat.ltb inat 257 with 
            | true  => (pushItemToExecutionStateStack es (wlshift' x inat)) 
            | false => failWithErrorCode es BadShrArgI
            end
        | inl errCode => failWithErrorCode es errCode
        end
      end
    ).

Definition shrActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, i, x) => 
        match extractByteAsNat i with 
        | inr inat    => 
            match Nat.ltb inat 257 with 
            | true  => (pushItemToExecutionStateStack es (wrshift' x inat)) 
            | false => failWithErrorCode es BadByteArgI
            end
        | inl errCode => failWithErrorCode es errCode
        end
      end
    ).

(*SHA3*)
Definition addressActionPure(state: ExecutionState)(ci: CallInfo): OpcodeApplicationResult := 
  (pushItemToExecutionStateStack state (get_thisContractAddress ci)).

Definition balanceActionPure(state: ExecutionState)(ci: CallInfo): OpcodeApplicationResult :=
  flatMap 
  (removeAndReturnFromStackOneItem state)
  (fun tup2 => 
      match tup2 with 
      | (es, a) => 
        match find a (get_accountBalances ci) with
        | Some balance => (pushItemToExecutionStateStack es balance)  
        | None => failWithErrorCode es NonexistentAddress
        end
      end
    ).
  
Definition originActionPure(state: ExecutionState)(ci: CallInfo): OpcodeApplicationResult := 
  (pushItemToExecutionStateStack state (get_callerAddress ci)).

(*  becasue currently implemnted state of EVM does not support nested contract calls, callser = origin *)
Definition callerActionPure(state: ExecutionState)(ci: CallInfo): OpcodeApplicationResult := 
  (pushItemToExecutionStateStack state (get_callerAddress ci)).

Definition callvalueActionPure(state: ExecutionState)(ci: CallInfo): OpcodeApplicationResult := 
  (pushItemToExecutionStateStack state (get_callEthValue ci)).

Definition calldataloadActionPure(state: ExecutionState)(ci: CallInfo): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackOneItem state)
    (fun tup2 => 
      match tup2 with (* todo complete*)
      | (es, idxWord) => 
        let i := wordToNat idxWord in 
          match nth_error (get_calldata ci) i with 
          | Some dataCell => (pushItemToExecutionStateStack es dataCell)  
          | None          => failWithErrorCode es BadCallDataLoadArgI
          end
      end
    ).

Definition calldatasizeActionPure(state: ExecutionState)(ci: CallInfo): OpcodeApplicationResult := 
    (pushItemToExecutionStateStack state (natToWord WLen (length (get_calldata ci)))).

(*Calldatacopy*)

Definition codesizeActionPure(state: ExecutionState)(ci: CallInfo): OpcodeApplicationResult := 
    (pushItemToExecutionStateStack state (natToWord WLen (length (get_thisContractCode ci)))).
(* codecopy *)

Definition gaspriceActionPure(state: ExecutionState)(ci: CallInfo): OpcodeApplicationResult := 
    (pushItemToExecutionStateStack state (get_txGasPrice ci)).

Definition exctcodesizeActionPure(state: ExecutionState)(ci: CallInfo): OpcodeApplicationResult := 
  flatMap 
  (removeAndReturnFromStackOneItem state)
    (fun tup2 => 
      match tup2 with 
      | (es, address) => 
        match find address (getContractMap_ES es) with
        | Some contract => (pushItemToExecutionStateStack state (natToWord WLen (length contract)))
        | None          => failWithErrorCode es NonexistentMemoryCell
        end
      end
    ).
(* extcodecopy *)

Definition blockhashActionPure(state: ExecutionState)(ci: CallInfo): OpcodeApplicationResult := 
    (pushItemToExecutionStateStack state (get_blockHash ci)).

Definition coinbaseActionPure(state: ExecutionState)(ci: CallInfo): OpcodeApplicationResult := 
    (pushItemToExecutionStateStack state (get_miner ci)).

Definition timestampActionPure(state: ExecutionState)(ci: CallInfo): OpcodeApplicationResult := 
    (pushItemToExecutionStateStack state (get_blockTimestamp ci)).

Definition numberActionPure(state: ExecutionState)(ci: CallInfo): OpcodeApplicationResult := 
    (pushItemToExecutionStateStack state (get_blockNumber ci)).

Definition dificultyActionPure(state: ExecutionState)(ci: CallInfo): OpcodeApplicationResult := 
    (pushItemToExecutionStateStack state (get_blockDificulty ci)).

Definition gaslimitActionPure(state: ExecutionState)(ci: CallInfo): OpcodeApplicationResult := 
    (pushItemToExecutionStateStack state (get_gasLimit ci)).

Definition popActionPure(state: ExecutionState): OpcodeApplicationResult := 
    flatMap
    (removeAndReturnFromStackOneItem state)
    (fun tup2 => 
      runningExecutionWithState (fst tup2)
    ).

Definition mloadActionPure(state: ExecutionState): OpcodeApplicationResult := 
  flatMap 
  (removeAndReturnFromStackOneItem state)
    (fun tup2 => 
      match tup2 with 
      | (es, key) => 
        match find key (getMemory_ES es) with
        | Some wrd => (pushItemToExecutionStateStack state wrd)
        | None     => failWithErrorCode es NonexistentMemoryCell
        end
      end
    ).

Definition mstoreActionPure(state: ExecutionState): OpcodeApplicationResult := 
  flatMap 
  (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, key, value) => runningExecutionWithState (setMemory_ES es (update (key, value) (getMemory_ES es)) )
      end
    ).

Definition mstore8ActionPure(state: ExecutionState): OpcodeApplicationResult := 
  flatMap 
  (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, key, value) => runningExecutionWithState (setMemory_ES es (update (key, wand value W0xFF) (getMemory_ES es)) )
      end
    ).


Definition sloadActionPure(state: ExecutionState): OpcodeApplicationResult := 
  flatMap 
  (removeAndReturnFromStackOneItem state)
    (fun tup2 => 
      match tup2 with 
      | (es, key) => 
        match find key (getStorage_ES es) with
        | Some wrd => (pushItemToExecutionStateStack state wrd)
        | None     => failWithErrorCode es NonexistentMemoryCell
        end
      end
    ).

Definition sstoreActionPure(state: ExecutionState): ExecutionResultOr (ExecutionState * nat) := 
  flatMap
  (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with 
      | (es, key, value) => 
        let storage := getStorage_ES es in
        let updatedStorageES := setStorage_ES es (update (key, value) storage) in
        match find key storage with 
         | Some w => 
          match (weqb w WZero, weqb value WZero)  with 
          | (true, true)  => runningExecutionWithState (es, 5000)
          | (true, false) => runningExecutionWithState (updatedStorageES, 20000)
          | (false, _) => runningExecutionWithState (setStorage_ES es (update (key, value) (getStorage_ES es)), 5000)
          end
         | None => runningExecutionWithState (updatedStorageES, 20000)
        end
      end
    ).

Definition pcActionPure(state: ExecutionState)(programCounter: nat): OpcodeApplicationResult := 
  (pushItemToExecutionStateStack state (natToWord  WLen programCounter)).

Definition msizeActionPure(state: ExecutionState): OpcodeApplicationResult := 
  (pushItemToExecutionStateStack state (natToWord WLen (mapLength (getMemory_ES state)))).

Definition gasActionPure(state: ExecutionState)(gas: nat): OpcodeApplicationResult := 
  (pushItemToExecutionStateStack state (natToWord WLen gas)).

Definition pushActionPure(bytes: word 5)(w: EVMWord)(state: ExecutionState): OpcodeApplicationResult :=
  let checkedWord := pushWordPass w (wordToNat bytes + 1) in 
  (pushItemToExecutionStateStack state checkedWord).

Definition dupActionPure(bytes: word 4)(state: ExecutionState):OpcodeApplicationResult := 
  flatMap
  (peekNthItemFromStack state (wordToNat bytes)) 
  (fun item => 
    (pushItemToExecutionStateStack state item)
  ).

Definition swapActionPure(bytes: word 4)(state: ExecutionState): OpcodeApplicationResult := 
   let stack := getStack_ES state in 
   match listSwapWithHead(stack)((wordToNat bytes) + 1)  with 
   | Some swappedStack => runningExecutionWithState (setStack_ES state swappedStack)
   | None              => failWithErrorCode state BadPeekArg
   end.


(* LOG*) 
(* CREATE *)
(* CALL *)
(* CALLCODE*)
Definition returnActionPure(state: ExecutionState): ExecutionResult := 
    flatMap
    (removeAndReturnFromStackTwoItemsEnder state)
    (fun tup3 => 
      match tup3 with (* todo complete*)
      | (es, offset, length) => 
        match getSliceFromMap (getMemory_ES es) offset (wordToNat length) with 
        | inl error => inl (ErrorneousExecutionResultMk error es)
        | inr returndata  => inr (SuccessfulExecutionResultMkWithData es returndata)
        end
      end
    ).

Definition jumpActionPure(state: ExecutionState)(program: list OpCode): OpcodeApplicationResult:= 
  flatMap
  (removeAndReturnFromStackOneItem state)
  (fun tup2 => 
    match tup2 with  
    | (es, pos) => 
      if N.ltb (wordToN pos) (N.of_nat (length program)) 
      then 
        let posNat := wordToNat pos in
        match nth_error program posNat with
        | Some(SimplePriceOpcodeMk JUMPDEST) => runningExecutionWithState (setPc_ES es posNat)
        | _ => failWithErrorCode es InvalidJumpDest
        end
      else failWithErrorCode es InvalidJumpDest
    end
  ).

Definition jumpiActionPure(state: ExecutionState)(program: list OpCode): OpcodeApplicationResult:= 
  flatMap
  (removeAndReturnFromStackTwoItems state)
  (fun tup3 => 
    match tup3 with  
    | (es, pos, cond) => 
      if weqb cond WZero 
      then runningExecutionWithState es  
      else if N.ltb (wordToN pos) (N.of_nat (length program)) 
           then
             let posNat := wordToNat pos in
             match nth_error program posNat with
             | Some(SimplePriceOpcodeMk JUMPDEST) => runningExecutionWithState (setPc_ES es posNat)
             | _ => failWithErrorCode es InvalidJumpDest
             end
           else failWithErrorCode es InvalidJumpDest
    end
  ).

Definition calldatacopyActionPure(state: ExecutionState)(ci: CallInfo): ExecutionResultOr (ExecutionState * nat) := 
  flatMap
  (removeAndReturnFromStackThreeItems state) 
  (fun tup4 => 
    match tup4 with 
    | (es, destOffset, offset, length) => 
      match getSliceFromList (get_calldata ci) (wordToNat offset) (wordToNat length) with 
      | Some words => runningExecutionWithState ((insertItemsIntoMemory es (wordToNat destOffset) words), 2 + (List.length words) * 3)
      | None       => failWithErrorCode es NonexistentCallDataCell
      end
    end)
.

Definition codecopyActionPure(state: ExecutionState)(ci: CallInfo): ExecutionResultOr (ExecutionState * nat):= 
  flatMap
  (removeAndReturnFromStackThreeItems state) 
  (fun tup4 => 
    match tup4 with 
    | (es, destOffset, offset, length) => 
      match getSliceFromList (get_thisContractCode ci) (wordToNat offset) (wordToNat length) with 
      | Some words => runningExecutionWithState ((insertItemsIntoMemory es (wordToNat destOffset) (zipListOfBytesIntoListOfWords words)), 2 + (List.length words) * 3)
      | None       => failWithErrorCode es NonexistentCallDataCell
      end
    end)
.

Definition extcodecopyActionPure(state: ExecutionState)(ci: CallInfo): ExecutionResultOr (ExecutionState * nat) := 
  flatMap
  (removeAndReturnFromStackFourItems state) 
  (fun tup5 => 
    match tup5 with 
    | (es, addr, destOffset, offset, length) => 
      match find addr (getContractMap_ES es) with 
      | Some contract => 
        match getSliceFromList (contract) (wordToNat offset) (wordToNat length) with 
        | Some words => runningExecutionWithState ((insertItemsIntoMemory es (wordToNat destOffset) (zipListOfBytesIntoListOfWords words)), 700 + (List.length words) * 3)
        | None       => failWithErrorCode es NonexistentCallDataCell
        end
      | None => failWithErrorCode es NonexistentContract
      end
    end)
.

Definition log0ActionPure(state: ExecutionState): ExecutionResultOr (ExecutionState * nat) := 
  flatMap 
  (removeAndReturnFromStackTwoItems state) 
  (fun tup3 => 
    match tup3 with
    | (es, offset, length) => 
      match getSliceFromMap (getMemory_ES es) offset (wordToNat length) with 
        | inl error => failWithErrorCode es error 
        | inr logData  => 
          let log := Log0 logData in 
          let logs := getLog_ES es in 
          let es2 := setLog_ES es logs in
            runningExecutionWithState (es2, 375 + (List.length logData * 8 * 32))
        end
      end
    ).

Definition log1ActionPure(state: ExecutionState): ExecutionResultOr (ExecutionState * nat) := 
  flatMap 
  (removeAndReturnFromStackThreeItems state) 
  (fun tup4 => 
    match tup4 with
    | (es, offset, length, topic0) => 
      match getSliceFromMap (getMemory_ES es) offset (wordToNat length) with 
        | inl error => failWithErrorCode es error 
        | inr logData  => 
          let log := Log1 topic0 logData  in 
          let logs := getLog_ES es in 
          let es2 := setLog_ES es logs in
            runningExecutionWithState (es2, 2 * 375 + (List.length logData * 8 * 32))
        end
      end
    ).

Definition log2ActionPure(state: ExecutionState): ExecutionResultOr (ExecutionState * nat) := 
  flatMap 
  (removeAndReturnFromStackFourItems state) 
  (fun tup5 => 
    match tup5 with
    | (es, offset, length, topic0, topic1) => 
      match getSliceFromMap (getMemory_ES es) offset (wordToNat length) with 
        | inl error => failWithErrorCode es error 
        | inr logData  => 
          let log := Log2 topic0 topic1 logData  in 
          let logs := getLog_ES es in 
          let es2 := setLog_ES es logs in
            runningExecutionWithState (es2, 3 * 375  + (List.length logData * 8 * 32))
        end
      end
    ).

Definition log3ActionPure(state: ExecutionState): ExecutionResultOr (ExecutionState * nat) := 
  flatMap 
  (removeAndReturnFromStackFiveItems state) 
  (fun tup6 => 
    match tup6 with
    | (es, offset, length, topic0, topic1, topic2) => 
      match getSliceFromMap (getMemory_ES es) offset (wordToNat length) with 
        | inl error => failWithErrorCode es error 
        | inr logData  => 
          let log := Log3 topic0 topic1 topic2 logData  in 
          let logs := getLog_ES es in 
          let es2 := setLog_ES es logs in
            runningExecutionWithState  (es2, 4 * 375  + (List.length logData * 8 * 32))
        end
      end
    ).

Definition log4ActionPure(state: ExecutionState): ExecutionResultOr (ExecutionState * nat)  := 
  flatMap 
  (removeAndReturnFromStackSixItems state) 
  (fun tup6 => 
    match tup6 with
    | (es, offset, length, topic0, topic1, topic2, topic3) => 
      match getSliceFromMap (getMemory_ES es) offset (wordToNat length) with 
        | inl error => failWithErrorCode es error 
        | inr logData  => 
          let log := Log4 topic0 topic1 topic2 topic3 logData  in 
          let logs := getLog_ES es in 
          let es2 := setLog_ES es logs in
            runningExecutionWithState  (es2, 5 * 375  + (List.length logData * 8 * 32))
        end
      end
    ).

(*DELEGATECALL*)
(*SELFDESTRUCT*)
Definition expCost(pow: word WLen): nat := 
  if weqb pow WZero 
  then 10%nat
  else 10%nat + 10%nat * (1%nat + ((log2Orzero pow)/ 8%nat)).

Definition expActionPure(state: ExecutionState): ExecutionResultOr (ExecutionState * nat)  :=
  flatMap 
  (removeAndReturnFromStackTwoItems state)
    (fun tup3 => 
      match tup3 with  
      | (es, a, pow) => 
        let resN := expmod (wordToN a) (wordToN pow) (wordModulus) in 
        let res := NToWord WLen resN in
        attach (pushItemToExecutionStateStack es res) (expCost pow)
      end
    ).

Definition opcodeProgramStateChange(opc: SimplePriceOpcode)(state: ExecutionState)(ci: CallInfo)(gas pc: nat)(program: list OpCode): OpcodeApplicationResult := 
  match opc with 
  | ADD	          => addActionPure state
  | MUL	          => mulActionPure state
  | SUB	          => subActionPure state
  | DIV	          => divActionPure state
  | SDIV	        => sdivActionPure state
  | MOD	          => modActionPure state
  | SMOD	        => smodActionPure state 
  | ADDMOD	      => addmodActionPure state 
  | MULMOD	      => mulmodActionPure state
  | SIGNEXTEND	  => signextendActionPure state
  | LT	          => ltActionPure state
  | GT	          => gtActionPure state
  | SLT	          => sltActionPure state
  | SGT	          => sgtActionPure state
  | EQ	          => eqActionPure state
  | ISZERO	      => iszeroActionPure state
  | AND	          => andActionPure state
  | OR	          => orActionPure state
  | XOR	          => xorActionPure state
  | NOT	          => notActionPure state
  | BYTE          => byteActionPure state
  | ADDRESS	      => addressActionPure state ci
  | BALANCE	      => balanceActionPure state ci
  | ORIGIN	      => originActionPure state ci
  | CALLER	      => callerActionPure state ci
  | CALLVALUE	    => callvalueActionPure state ci
  | CALLDATALOAD	=> calldataloadActionPure state ci
  | CALLDATASIZE	=> calldatasizeActionPure state ci
  | CODESIZE	    => codesizeActionPure state ci
  | GASPRICE	    => gaspriceActionPure state ci
  | EXTCODESIZE	  => exctcodesizeActionPure state ci
  | BLOCKHASH	    => blockhashActionPure state ci
  | COINBASE	    => coinbaseActionPure state ci
  | TIMESTAMP	    => timestampActionPure state ci
  | NUMBER	      => numberActionPure state ci
  | DIFFICULTY  	=> dificultyActionPure state ci
  | GASLIMIT	    => gaslimitActionPure state ci
  | POP	          => popActionPure state
  | MLOAD	        => mloadActionPure state
  | MSTORE	      => mstoreActionPure state
  | MSTORE8	      => mstore8ActionPure state
  | SLOAD	        => sloadActionPure state
  | PC	          => pcActionPure state pc 
  | MSIZE	        => msizeActionPure state
  | GAS	          => gasActionPure state gas 
  | JUMPDEST	    => runningExecutionWithState state
  | PUSH arg word	=> pushActionPure arg word state
  | DUP arg	      => dupActionPure arg state
  | SWAP	arg     => swapActionPure arg state
  | CREATE	      => failWithErrorCode state NotImplemented
  | JUMP          => jumpActionPure state program
  | JUMPI         => jumpiActionPure state program
(*   | _   => stopExecutionWithSuccess (state) *)
  end.


Definition opcodeProgramStateChangeComplex(opc: ComplexPriceOpcode)(state: ExecutionState)(ci: CallInfo)(gas pc: nat)(program: list OpCode): ExecutionResultOr (ExecutionState* nat) := 
  match opc with 
  |	EXP           => expActionPure state
  |	SHA3          => failWithErrorCode state NotImplemented
  |	CALLDATACOPY  => calldatacopyActionPure state ci
  |	CODECOPY      => codecopyActionPure state ci
  |	EXTCODECOPY   => extcodecopyActionPure state ci
  |	SSTORE        => sstoreActionPure state 
  |	LOG0          => log0ActionPure state 
  |	LOG1          => log1ActionPure state 
  |	LOG2          => log2ActionPure state 
  |	LOG3          => log3ActionPure state 
  |	LOG4          => log4ActionPure state 
  |	CALL          => failWithErrorCode state NotImplemented
  |	CALLCODE      => failWithErrorCode state NotImplemented
  |	DELEGATECALL  => failWithErrorCode state NotImplemented
  |	SELFDESTRUCT  => failWithErrorCode state NotImplemented
  end.




(* Super ugly but i don't wan to bother with well-founded stuff.*)
(* Check Nat.eqb.
Check bool. *)

Fixpoint actOpcode(gas programCounter: nat)(ec: ExecutionState)(program: list OpCode)(callInfo: CallInfo){struct gas}: ExecutionResult :=
    match gas with 
    | S predGas => 
      match (nth_error program programCounter) with 
      | Some opc => 
        match opc with 
        | STOP                        => inr (SuccessfulExecutionResultMk ec)
        |	RETURN	                    => returnActionPure ec
        | ComplexPriceOpcodeMk opcode => 
          match opcodeProgramStateChangeComplex opcode ec callInfo gas programCounter program with
          | inl result => inr (SuccessfulExecutionResultMk ec)
          | inr (updatedState, reducedGas) => 
            actOpcode (predGas - (reducedGas) - 1) (S programCounter) updatedState program callInfo
          end
        | SimplePriceOpcodeMk opcode  => 
          match opcodeProgramStateChange opcode ec callInfo gas programCounter program with 
          | inl result       => result
          | inr updatedState => (* reduce gas and go on*)(* gas - gasCost = (gas - 1) - (gasCost - 1)*)
            actOpcode (predGas - ((simplePriceOpcodePrice opcode) -1)) (S programCounter) updatedState program callInfo
          end
        end
      | None     => inl (ErrorneousExecutionResultMk InvalidJumpDest ec)
      end
    | O         => 
      match (Nat.eqb programCounter (S(length program))) with 
      | true  => inr (SuccessfulExecutionResultMk ec)
      | false => inl (ErrorneousExecutionResultMk  OutOfGas ec)
      end
    end.

Fixpoint actOpcodeWithInstructionsLimitation(maxinstructions gas programCounter: nat)(ec: ExecutionState)(program: list OpCode)(callInfo: CallInfo){struct maxinstructions}: ExecutionResult :=
    match maxinstructions with 
    | S instructionsLeft => 
      match (nth_error program programCounter) with 
      | Some opc => 
        match opc with 
        | STOP                        => inr (SuccessfulExecutionResultMk ec)
        |	RETURN	                    => returnActionPure ec
        | ComplexPriceOpcodeMk opcode => inr (SuccessfulExecutionResultMk ec) (* TODO change to the opcodes implementation*)
        | SimplePriceOpcodeMk opcode  => 
          match opcodeProgramStateChange opcode ec callInfo gas programCounter program with 
          | inl result       => result
          | inr updatedState => (* reduce gas and go on*)(* gas - gasCost = (gas - 1) - (gasCost - 1)*)
            let gasLeft := gas - (simplePriceOpcodePrice opcode) in
            let gasPositive := Nat.ltb (simplePriceOpcodePrice opcode) gas in 
            let gasZero := Nat.eqb gas (simplePriceOpcodePrice opcode) in 
            let over := Nat.eqb programCounter (S(length program)) in 
              match (gasPositive, gasZero, over) with 
              | (true, _, _)     => actOpcodeWithInstructionsLimitation (instructionsLeft)(gasLeft)(S programCounter) updatedState program callInfo
              | (_, true, true)  => inr (SuccessfulExecutionResultMk ec)
              | (false, _, _)    => inl (ErrorneousExecutionResultMk  OutOfGas ec)
              end
            
          end
        end
      | None     => inl (ErrorneousExecutionResultMk InvalidJumpDest ec)
      end
    | O         => 
      match (Nat.eqb programCounter (S(length program))) with 
      | true  => inr (SuccessfulExecutionResultMk ec)
      | false => inl (ErrorneousExecutionResultMk  OutOfGas ec)
      end
    end. 
(* Facts about opcodes *)

Definition rightProj{A B: Type}(s: A+B): option B := 
match s with
| inr b => Some b
| inl _ => None
end.

Lemma liftedSome{T: Type}: forall t1 t2: T, t1 = t2 <-> Some t1 = Some t2. Proof.
intros.
split.
intros.
rewrite H.
trivial.
intros.
injection H as H.
apply H. 
Defined.

Lemma liftSome{T: Type}: forall t1 t2: T, t1 = t2 -> Some t1 = Some t2. Proof.
apply liftedSome.
Defined.

Lemma unliftSome{T: Type}: forall t1 t2: T, Some t1 = Some t2 -> t1 =t2. Proof.
apply liftedSome.
Defined.

Lemma listsEqualHeads{T: Type}: forall t1 t2: T, forall tail: list T, t1 :: tail = t2 :: tail <-> t1 = t2. Proof.
intros.
split. 
intros.
injection H as H.
rewrite H.
trivial.
intros.
rewrite H.
trivial.
Defined.

Lemma listLengthApp{T: Type}: forall h: T, forall l t: list T, h :: t = l -> length l = S (length t). Proof.
intros. 
intros.
rewrite <- H.
(* cut (forall T: Type, forall t: T, forall tail: list T, (t :: nil) ++ tail = t :: tail). *)
cut (h :: t = (h :: nil) ++ t). intros. rewrite H0. rewrite app_length.
cut (length (h :: nil) = 1). intros. rewrite H1.
trivial. 
unfold length.
trivial.
unfold app.
trivial.
Defined.

Lemma natLtbPlusOne: forall n m: nat, n <? m = true -> S n <? S m = true.
Proof.
intros.
tauto.
Qed.

Lemma listAppLength{T: Type}: forall n: nat, forall h t l: list T, length l < n -> l = h ++ t -> length (t) < n. Proof.
intros.
rewrite H0 in H.
rewrite app_length in H.
lia.
Qed.

Lemma rightCrossover: forall n m: nat, n < m -> n <? m = true. Proof.
Admitted. 

Lemma leftCrossover: forall n m: nat, n <? m = true -> n < m. Proof.
Admitted.
Ltac unfoldUtilDefinitions := 
unfold 
mapO, rightProj,attach, "*",
getStack_ES, removeAndReturnFromStackOneItem, removeAndReturnFromStackTwoItems, removeAndReturnFromStackThreeItems, pushItemToExecutionStateStack, 
getStack_ES, failWithErrorCode, runningExecutionWithState, setStack_ES, flatMap.

Ltac unfoldUtilDefinitionsIn H := 
unfold 
mapO, rightProj, attach, "*",
getStack_ES, removeAndReturnFromStackOneItem, removeAndReturnFromStackTwoItems, removeAndReturnFromStackThreeItems, pushItemToExecutionStateStack, failWithErrorCode, runningExecutionWithState, setStack_ES, flatMap in H.

Ltac cutRewrite bla hname:=  
cut(bla); only 1 : intro hname; only 1 :rewrite hname.

Ltac cutRewriteInL bla hname hnameTarg:=  
cut(bla); only 1 : intro hname; only 1 : rewrite <- hname in hnameTarg.

Ltac cutRewriteInR bla hname hnameTarg:=  
cut(bla); only 1 : intro hname; only 1 : rewrite -> hname in hnameTarg.


Theorem addActionPureSuccess:
forall es: ExecutionState, 
forall w1 w2: EVMWord,
forall tail: list EVMWord,
let preStack := getStack_ES es in
let post := addActionPure es in
let postStack := mapO (rightProj post) (getStack_ES) in
length preStack < 1024 -> preStack = w1 :: w2 :: tail ->
postStack = Some(wplus w1 w2 :: tail).
Proof.
intros es w1 w2 tail preStack post postStack H H0.
destruct es.
subst preStack. subst postStack. subst post.
unfold addActionPure.
unfoldUtilDefinitions.
unfoldUtilDefinitionsIn H.
unfoldUtilDefinitionsIn H0.
rewrite H0. 
cutRewrite (length tail <? 1024 = true) H1.
rewrite <- liftedSome.
rewrite listsEqualHeads.
trivial.
cutRewriteInL ((w1 :: w2 :: nil) ++ tail = w1 :: w2 :: tail) H1 H0. rewrite H0 in H.
rewrite rightCrossover. trivial.
apply (listAppLength 1024 (w1 :: w2 :: nil) tail l).
rewrite <- H0 in H.
apply H.
assumption.
unfold "++".
trivial.
Qed.


Theorem mulActionPureSuccess: 
forall es: ExecutionState, 
forall w1 w2: EVMWord,
forall tail: list EVMWord,
let preStack := getStack_ES es in
let post := mulActionPure es in
let postStack := mapO (rightProj post) (getStack_ES) in
length preStack < 1024 -> preStack = w1 :: w2 :: tail ->
postStack = Some(wmult w1 w2 :: tail). Proof.
intros es w1 w2 tail preStack post postStack H H0.
destruct es.
subst preStack. subst postStack. subst post.
unfold mulActionPure.
unfoldUtilDefinitions.
unfoldUtilDefinitionsIn H.
unfoldUtilDefinitionsIn H0.
rewrite H0. 
cutRewrite (length tail <? 1024 = true) H1.
rewrite <- liftedSome.
rewrite listsEqualHeads.
trivial.
cutRewriteInL ((w1 :: w2 :: nil) ++ tail = w1 :: w2 :: tail) H1 H0. rewrite H0 in H.
rewrite rightCrossover. trivial.
apply (listAppLength 1024 (w1 :: w2 :: nil) tail l).
rewrite <- H0 in H.
apply H.
assumption.
unfold "++".
trivial.
Qed.

Theorem subActionPureSuccess: 
forall es: ExecutionState, 
forall w1 w2: EVMWord,
forall tail: list EVMWord,
let preStack := getStack_ES es in
let post := subActionPure es in
let postStack := mapO (rightProj post) (getStack_ES) in
length preStack < 1024 -> preStack = w1 :: w2 :: tail ->
postStack = Some(wordSubModulus w1 w2 :: tail). Proof.
intros es w1 w2 tail preStack post postStack H H0.
destruct es.
subst preStack. subst postStack. subst post.
unfold subActionPure.
unfoldUtilDefinitions.
unfoldUtilDefinitionsIn H.
unfoldUtilDefinitionsIn H0.
rewrite H0. 
cutRewrite (length tail <? 1024 = true) H1.
rewrite <- liftedSome.
rewrite listsEqualHeads.
trivial.
cutRewriteInL ((w1 :: w2 :: nil) ++ tail = w1 :: w2 :: tail) H1 H0. rewrite H0 in H.
rewrite rightCrossover. trivial.
apply (listAppLength 1024 (w1 :: w2 :: nil) tail l).
rewrite <- H0 in H.
apply H.
assumption.
unfold "++".
trivial.
Qed.

Theorem divActionPureSuccess: 
forall es: ExecutionState, 
forall w1 w2: EVMWord,
forall tail: list EVMWord,
let preStack := getStack_ES es in
let post := divActionPure es in
let postStack := mapO (rightProj post) (getStack_ES) in
length preStack < 1024 -> preStack = w1 :: w2 :: tail ->
postStack = Some(wdiv w1 w2 :: tail). Proof.
intros es w1 w2 tail preStack post postStack H H0.
destruct es.
subst preStack. subst postStack. subst post.
unfold divActionPure.
unfoldUtilDefinitions.
unfoldUtilDefinitionsIn H.
unfoldUtilDefinitionsIn H0.
rewrite H0. 
cutRewrite (length tail <? 1024 = true) H1.
rewrite <- liftedSome.
rewrite listsEqualHeads.
trivial.
cutRewriteInL ((w1 :: w2 :: nil) ++ tail = w1 :: w2 :: tail) H1 H0. rewrite H0 in H.
rewrite rightCrossover. trivial.
apply (listAppLength 1024 (w1 :: w2 :: nil) tail l).
rewrite <- H0 in H.
apply H.
assumption.
unfold "++".
trivial.
Qed.

Theorem sdivActionPureSuccess: 
forall es: ExecutionState, 
forall w1 w2: EVMWord,
forall tail: list EVMWord,
let preStack := getStack_ES es in
let post := sdivActionPure es in
let postStack := mapO (rightProj post) (getStack_ES) in
length preStack < 1024 -> preStack = w1 :: w2 :: tail ->
postStack = Some(wdivZ w1 w2 :: tail). Proof.
intros es w1 w2 tail preStack post postStack H H0.
destruct es.
subst preStack. subst postStack. subst post.
unfold sdivActionPure.
unfoldUtilDefinitions.
unfoldUtilDefinitionsIn H.
unfoldUtilDefinitionsIn H0.
rewrite H0. 
cutRewrite (length tail <? 1024 = true) H1.
rewrite <- liftedSome.
rewrite listsEqualHeads.
trivial.
cutRewriteInL ((w1 :: w2 :: nil) ++ tail = w1 :: w2 :: tail) H1 H0. rewrite H0 in H.
rewrite rightCrossover. trivial.
apply (listAppLength 1024 (w1 :: w2 :: nil) tail l).
rewrite <- H0 in H.
apply H.
assumption.
unfold "++".
trivial.
Qed.

Theorem modActionPureSuccess: 
forall es: ExecutionState, 
forall w1 w2: EVMWord,
forall tail: list EVMWord,
let preStack := getStack_ES es in
let post := modActionPure es in
let postStack := mapO (rightProj post) (getStack_ES) in
length preStack < 1024 -> preStack = w1 :: w2 :: tail ->
postStack = Some(wmod w1 w2 :: tail). Proof.
intros es w1 w2 tail preStack post postStack H H0.
destruct es.
subst preStack. subst postStack. subst post.
unfold modActionPure.
unfoldUtilDefinitions.
unfoldUtilDefinitionsIn H.
unfoldUtilDefinitionsIn H0.
rewrite H0. 
cutRewrite (length tail <? 1024 = true) H1.
rewrite <- liftedSome.
rewrite listsEqualHeads.
trivial.
cutRewriteInL ((w1 :: w2 :: nil) ++ tail = w1 :: w2 :: tail) H1 H0. rewrite H0 in H.
rewrite rightCrossover. trivial.
apply (listAppLength 1024 (w1 :: w2 :: nil) tail l).
rewrite <- H0 in H.
apply H.
assumption.
unfold "++".
trivial.
Qed.

Theorem smodActionPureSuccess: 
forall es: ExecutionState, 
forall w1 w2: EVMWord,
forall tail: list EVMWord,
let preStack := getStack_ES es in
let post := smodActionPure es in
let postStack := mapO (rightProj post) (getStack_ES) in
let res := ZToWord WLen (Z.rem (wordToZ w1) (wordToZ w2)) in
length preStack < 1024 -> preStack = w1 :: w2 :: tail ->
postStack = Some(res :: tail). Proof.
intros es w1 w2 tail preStack post postStack res H H0.
destruct es.
subst preStack. subst postStack. subst post. subst res.
unfold smodActionPure.
unfoldUtilDefinitions.
unfoldUtilDefinitionsIn H.
unfoldUtilDefinitionsIn H0.
rewrite H0. 
cutRewrite (length tail <? 1024 = true) H1.
rewrite <- liftedSome.
rewrite listsEqualHeads.
trivial.
cutRewriteInL ((w1 :: w2 :: nil) ++ tail = w1 :: w2 :: tail) H1 H0. rewrite H0 in H.
rewrite rightCrossover. trivial.
apply (listAppLength 1024 (w1 :: w2 :: nil) tail l).
rewrite <- H0 in H.
apply H.
assumption.
unfold "++".
trivial.
Qed.

Theorem addmodActionPureSuccess: 
forall es: ExecutionState, 
forall w1 w2 w3: EVMWord,
forall tail: list EVMWord,
let preStack := getStack_ES es in
let post := addmodActionPure es in
let postStack := mapO (rightProj post) (getStack_ES) in
let res := ZToWord WLen (Z.rem ((wordToZ w1) + (wordToZ w2)) (Z.of_N (wordToN w3))) in
length preStack < 1024 -> preStack = w1 :: w2 :: w3 :: tail ->
postStack = Some(res  :: tail). Proof.
intros es w1 w2 w3 tail preStack post postStack res H H0.
destruct es.
subst preStack. subst postStack. subst post. subst res.
unfold addmodActionPure.
unfoldUtilDefinitions.
unfoldUtilDefinitionsIn H.
unfoldUtilDefinitionsIn H0.
rewrite H0. 
cutRewrite (length tail <? 1024 = true) H1.
rewrite <- liftedSome.
rewrite listsEqualHeads.
trivial.
cutRewriteInL ((w1 :: w2 :: w3 :: nil) ++ tail = w1 :: w2 :: w3 :: tail) H1 H0. rewrite H0 in H.
rewrite rightCrossover. trivial.
apply (listAppLength 1024 (w1 :: w2 :: w3 :: nil) tail l).
rewrite <- H0 in H.
apply H.
assumption.
unfold "++".
trivial.
Qed.

Theorem mulmodActionPureSuccess: 
forall es: ExecutionState, 
forall w1 w2 w3: EVMWord,
forall tail: list EVMWord,
let preStack := getStack_ES es in
let post := mulmodActionPure es in
let postStack := mapO (rightProj post) (getStack_ES) in
let res := ZToWord WLen (Z.rem ((wordToZ w1) * (wordToZ w2)) (Z.of_N (wordToN w3))) in
length preStack < 1024 -> preStack = w1 :: w2 :: w3 :: tail ->
postStack = Some(res  :: tail). Proof.
intros es w1 w2 w3 tail preStack post postStack res H H0.
destruct es.
subst preStack. subst postStack. subst post. subst res.
unfold mulmodActionPure.
unfoldUtilDefinitions.
unfoldUtilDefinitionsIn H.
unfoldUtilDefinitionsIn H0.
rewrite H0. 
cutRewrite (length tail <? 1024 = true) H1.
rewrite <- liftedSome.
rewrite listsEqualHeads.
trivial.
cutRewriteInL ((w1 :: w2 :: w3 :: nil) ++ tail = w1 :: w2 :: w3 :: tail) H1 H0. rewrite H0 in H.
rewrite rightCrossover. trivial.
apply (listAppLength 1024 (w1 :: w2 :: w3 :: nil) tail l).
rewrite <- H0 in H.
apply H.
assumption.
unfold "++".
trivial.
Qed.


Theorem expActionPureSuccess: 
forall es: ExecutionState, 
forall w1 w2: EVMWord,
forall tail: list EVMWord,
let preStack := getStack_ES es in
let post := expActionPure es in
let postStack := mapO (rightProj post) (fst * getStack_ES) in
let res := NToWord WLen (expmod (wordToN w1) (wordToN w2) (wordModulus)) in
length preStack < 1024 -> preStack = w1 :: w2 :: tail ->
postStack = Some(res :: tail). Proof.
intros es w1 w2 tail preStack post postStack res H H0.
destruct es.
subst preStack. subst postStack. subst post. subst res.
unfold expActionPure.
unfoldUtilDefinitions.
unfoldUtilDefinitionsIn H.
unfoldUtilDefinitionsIn H0.
rewrite H0.
unfold "*" .
unfold fst.
cutRewrite (length tail <? 1024 = true) H1.
unfold map.
rewrite <- liftedSome.
rewrite listsEqualHeads.
trivial.
cutRewriteInL ((w1 :: w2 :: nil) ++ tail = w1 :: w2 :: tail) H1 H0. rewrite H0 in H.
rewrite rightCrossover. trivial.
apply (listAppLength 1024 (w1 :: w2 :: nil) tail l).
rewrite <- H0 in H.
apply H.
assumption.
unfold "++".
trivial.
Qed.


Theorem signextendActionPureSuccess: 
forall es: ExecutionState, 
forall w1 w2: EVMWord,
forall tail: list EVMWord,
let preStack := getStack_ES es in
let b := rightProj (extractByteAsNat w2) in
let res := mapO b (fun bb => sextWordBytes w1 bb) in
let post := signextendActionPure es in
let postStack := mapO (rightProj post) (getStack_ES) in
length preStack < 1024 -> weqb (wlshift' w2 8%nat) WZero = true -> preStack = w1 :: w2 :: tail ->
postStack = mapO res (fun h => h :: tail). Proof.
intros es w1 w2 tail preStack b res post postStack H H1 H0.
destruct es.
subst preStack. subst postStack. subst post. subst res. subst b. 
unfold signextendActionPure. 
unfoldUtilDefinitions.
unfoldUtilDefinitionsIn H.
unfoldUtilDefinitionsIn H0.
rewrite H0.
unfold extractByteAsNat.
rewrite H1.
cutRewrite (length tail <? 1024 = true) H2.
rewrite <- liftedSome.
rewrite listsEqualHeads.
trivial.
cutRewriteInL ((w1 :: w2 :: nil) ++ tail = w1 :: w2 :: tail) H2 H0. rewrite H0 in H.
rewrite rightCrossover. trivial.
apply (listAppLength 1024 (w1 :: w2 :: nil) tail l).
rewrite <- H0 in H.
apply H.
assumption.
unfold "++".
trivial.
Qed.


Close Scope EVM_scope.

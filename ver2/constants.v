Require Import bbv.Word.

Module FORVES_Constants.


(* Byte *)
Definition EVMByteSize: nat := 8. 
Definition EVMByte := word EVMByteSize. 

(* Word *)
Definition BytesInEVMWord: nat := 32. 
Definition EVMWordSize: nat := BytesInEVMWord*EVMByteSize. 
Definition EVMWord:= word EVMWordSize.

(* Address *)
Definition ByteInEVMAddr : nat := 20. 
Definition EVMAddrSize : nat := ByteInEVMAddr*EVMByteSize.
Definition EVMAddr := word EVMAddrSize.

(* Predefined constants *)
Definition BZero: EVMByte  := natToWord EVMByteSize 0.
Definition BOne : EVMByte  := natToWord EVMByteSize 1.

Definition WZero: EVMWord  := natToWord EVMWordSize 0.
Definition WOne : EVMWord  := natToWord EVMWordSize 1.

Definition AZero: EVMAddr  := natToWord EVMAddrSize 0.
Definition AOne : EVMAddr  := natToWord EVMAddrSize 1.

(* Maximum size of the stack *)
Definition StackSize := 1024.

End FORVES_Constants.

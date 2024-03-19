
let rec wordToInt w =
  match w with
  | WO -> 0;
  | WS (b, _, w') -> if b then 1 + ((wordToInt w') * 2) else (wordToInt w')*2

module I = Z


let rec binToDigit b1 b2 b3 b4 =
  match b1,b2,b3,b4 with
  | false,false,false,false -> "0"
  | true ,false,false,false -> "1"
  | false,true ,false,false -> "2"
  | true ,true ,false,false -> "3"
  | false,false,true ,false -> "4"
  | true ,false,true ,false -> "5"
  | false,true ,true ,false -> "6"
  | true ,true ,true ,false -> "7"
  | false,false,false,true  -> "8"
  | true ,false,false,true  -> "9"
  | false,true ,false,true  -> "a"
  | true ,true ,false,true  -> "b"
  | false,false,true ,true  -> "c"
  | true ,false,true ,true  -> "d"
  | false,true ,true ,true  -> "e"
  | true ,true ,true ,true  -> "f"


let rec wordToStr' w =
  match w with
  | WS (b1, _, WS (b2, _, WS (b3, _, WS (b4, _, w')))) ->
     let rest = (wordToStr' w') in
     let digit = (binToDigit b1 b2 b3 b4) in     
     if  ( (String.length rest == 0) && (String.compare digit "0" == 0) ) then
       ""
     else
       String.concat "" [rest;digit];
  | WO -> ""
  | _ -> "..."

let rec wordToStr w =
  let ws = wordToStr' w in
  if (String.length ws == 0)
  then "0x0"
  else String.concat "" ["0x"; wordToStr' w]

  let rec nat_to_int n =
    match n with
    | O -> 0;
    | S n' -> Stdlib.Int.succ (nat_to_int n')

  let  svalue_to_str v =
    match v with
     | SymbolicState.Val n -> wordToStr n;
     | SymbolicState.InStackVar n ->  String.concat "" ["s"; string_of_int (nat_to_int n)];
     | SymbolicState.FreshVar n -> String.concat "" ["e";string_of_int (nat_to_int n)]

  
  let  print_update u =
      match u with
       | SymbolicState.U_MSTORE (soffset, svalue) -> String.concat "" ["MSTORE(";svalue_to_str soffset;",";svalue_to_str svalue;")"];
       | SymbolicState.U_MSTORE8 (soffset, svalue) -> String.concat "" ["MSTORE(";svalue_to_str soffset;",";svalue_to_str svalue;")"]

    
  let rec print_smemory' smem =
      match smem with
      | [] -> ();
      | [u1] -> Printf.fprintf stdout "%s" (print_update u1); 
      | u1::u2::smem' -> Printf.fprintf stdout "%s, " (print_update u1); print_smemory' (u2::smem')

  let print_smemory smem =
    Printf.fprintf stdout "[";
    print_smemory' smem;
    Printf.fprintf stdout "]%!"


    let rec print_list_of_svalues' svs =
      match svs with
      | [] -> ();
      | [u1] -> Printf.fprintf stdout "%s" (svalue_to_str u1); 
      | u1::u2::svs' -> Printf.fprintf stdout "%s, " (svalue_to_str u1); print_list_of_svalues' (u2::svs')

  let print_list_of_svalues svs =
    Printf.fprintf stdout "[";
    print_list_of_svalues' svs;
    Printf.fprintf stdout "]%!"


  let op_to_str op =
    match op with
    | Program.ADD -> "ADD";
    | MUL -> "MUL";
    | SUB -> "SUB";
    | DIV -> "DIV";
    | SDIV -> "SDIV";
    | MOD -> "MOD";
    | SMOD -> "SMOD";
    | ADDMOD -> "ADDMOD";
    | MULMOD -> "MULMOD";
    | EXP -> "EXP";
    | SIGNEXTEND -> "SIGNEXTEND";
    | LT -> "LT";
    | GT -> "GT";
    | SLT -> "SLT";
    | SGT -> "SGT";
    | EQ -> "EQ";
    | ISZERO -> "ISZERO";
    | AND -> "AND";
    | OR -> "OR";
    | XOR -> "XOR";
    | NOT -> "NOT";
    | BYTE -> "BYTE";
    | SHL -> "SHL";
    | SHR -> "SHR";
    | SAR -> "SAR";
    | ADDRESS -> "ADDRESS";
    | BALANCE -> "BALANCE";
    | ORIGIN -> "ORIGIN";
    | CALLER -> "CALLER";
    | CALLVALUE -> "CALLVALUE";
    | CALLDATALOAD -> "CALLDATALOAD";
    | CALLDATASIZE -> "CALLDATASIZE";
    | CODESIZE -> "CODESIZE";
    | GASPRICE -> "GASPRICE";
    | EXTCODESIZE -> "EXTCODESIZE";
    | RETURNDATASIZE -> "RETURNDATASIZE";
    | EXTCODEHASH -> "EXTCODEHASH";
    | BLOCKHASH -> "BLOCKHASH";
    | COINBASE -> "COINBASE";
    | TIMESTAMP -> "TIMESTAMP";
    | NUMBER -> "NUMBER";
    | DIFFICULTY -> "DIFFICULTY";
    | GASLIMIT -> "GASLIMIT";
    | CHAINID -> "CHAINID";
    | SELFBALANCE -> "SELFBALANCE";
    | BASEFEE -> "BASEFEE";
    | GAS -> "GAS";
    | JUMPI -> "JUMPI"

  
  let print_smv smv =
    match smv with
    | SymbolicState.SymBasicVal sv -> Printf.fprintf stdout "SymBasicVal %s" (svalue_to_str sv);
    | SymbolicState.SymMETAPUSH (cat,value) -> Printf.fprintf stdout "SymMETAPUSH";
    | SymMLOAD (sv,smem) ->
       Printf.fprintf stdout "SymMLOAD %s" (svalue_to_str sv);
       print_smemory smem;
    | SymOp (op, svs) ->
       Printf.fprintf stdout "SymOp %s " (op_to_str op);
       print_list_of_svalues svs;
    | SymSLOAD (sv,sstg) -> Printf.fprintf stdout "SymSLOAD";
    | SymSHA3  (soffset,ssize,smem) -> Printf.fprintf stdout "SymSLOAD"

  let print_binding b =
    match b with
    | (idx,smv) ->
       Printf.fprintf stdout "%d |-> " (nat_to_int idx);
       print_smv smv

  let rec print_bindings' bs =
      match bs with
      | [] -> ();
      | [b1] -> print_binding b1; 
      | b1::b2::smem' -> print_binding b1; Printf.fprintf stdout ", "; print_bindings' (b2::smem')

  let print_bindings bs =
    Printf.fprintf stdout "[";
    print_bindings' bs;
    Printf.fprintf stdout "]%!"
  

  let print_smap m =
    match m with
    | SymbolicState.SymMap (maxidx, bs) ->
       Printf.fprintf stdout "SymMap %d " (nat_to_int maxidx);
         print_bindings bs


(* Command line arguments *)
let alg = ref Checker.Parser.block_eq_2
let usage_msg = "checker [options] < filename"

let anon_fun filename = raise (Arg.Bad "invalid anonymous argument") (* input_files := filename :: !input_files *)

let process_alg n =
  if n == 0 then
    alg := Checker.Parser.block_eq_0
  else if n == 1  then
    alg := Checker.Parser.block_eq_1
  else if n == 2 then
    alg := Checker.Parser.block_eq_2
  else
    raise (Arg.Bad "invalid value for -alg")
let speclist =
  [
    ("-alg", Arg.Int process_alg, "0 for evm_eq_block_chkr, 1 for evm_eq_block_chkr', and 2 for evm_eq_block_chkr'' (default: 2)")
  ]


(* Used to convert ocaml string to list of chars that are used by Coq *)
let charlist_of_string s =
  let rec trav l i =
    if i = l then [] else s.[i]::trav l (i+1)
  in
  trav (String.length s) 0;;


let main () =
  let i = ref 0 in
  try
    while true do
      i := !i+1;
      let p_opt = input_line stdin in (* read the optimized block *)
      let p = input_line stdin in     (* read the original block *)
      let k = input_line stdin in     (* read input statck size *)
      (* call the checker -- converting ocaml strings to corresponding lists of chars *)
      let r = !alg (charlist_of_string p_opt) (charlist_of_string p) (charlist_of_string k) in
      (* print the result *)
      match r with
      | None -> Printf.printf "Example %d: parsing error\n\n  %s\n  %s\n  %s\n\n" !i p_opt p k;
      | Some b -> Printf.printf "Example %d: %B\n" !i b;
    done
  with
  | End_of_file -> ();
  | e -> raise e;;



let _ = Arg.parse speclist anon_fun usage_msg; main ();;

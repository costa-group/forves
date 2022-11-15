
(* Command line arguments *)
let alg = ref Checker.Parser.block_eq_2
let usage_msg = "checker [options] < filename"
let opts_list = ref []

let anon_fun filename = raise (Arg.Bad "invalid anonymous argument") (* input_files := filename :: !input_files *)
let parse_opts s = opts_list := Str.split (Str.regexp "[,]+") s

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
    ("-alg", Arg.Int process_alg, "The algorithm to apply, use 0 for evm_eq_block_chkr, 1 for evm_eq_block_chkr', and 2 for evm_eq_block_chkr'' (default: 2)");
    ("-opt", Arg.String parse_opts, "A list of comma-separated optimizations (without white spaces) to be applied iteratively. Available optimizations are: add_zero mul_one mul_zero not_not div_one eq_zero gt_one lt_one or_zero sub_x_x iszero3 and_and_l and_and_r. By default all optimizations are applied. Example: add_zero,not_not,gt_one")
  ]


(* Used to convert ocaml string to list of chars that are used by Coq *)
let charlist_of_string s =
  let rec trav l i =
    if i = l then [] else s.[i]::trav l (i+1)
  in
  trav (String.length s) 0;;

let read_line () =
  let quit_loop = ref false in
  let line = ref " " in
  while not !quit_loop do
    line := input_line stdin;
    if not (String.length !line == 0 || String.get !line 0 == '#') then quit_loop := true;
  done;
  !line;;

let main () =
  let opts = Checker.Parser.parse_opts (List.map charlist_of_string !opts_list) in
  match opts with 
  | None -> Printf.printf "Invalid list of optimizations\n";
  | Some opt_func ->
      let i = ref 0 in
      try
        while true do
          i := !i+1;
          let p_opt = read_line() in (* read the optimized block *)
          let p = read_line() in     (* read the original block *)
          let k = read_line() in     (* read input statck size *)
          (* call the checker -- converting ocaml strings to corresponding lists of chars *)
          let r = !alg (charlist_of_string p_opt) (charlist_of_string p) (charlist_of_string k) opt_func in
          (* print the result *)
          match r with
          | None -> Printf.printf "Example %d: parsing error\n\n  %s\n  %s\n  %s\n\n" !i p_opt p k;
          | Some b -> Printf.printf "Example %d: %B\n" !i b;
        done
      with
      | End_of_file -> ();
      | e -> raise e;;



let _ = Arg.parse speclist anon_fun usage_msg;
        main ();;



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


(* Command line arguments *)
let opts_to_apply = ref [ (charlist_of_string "all") ]
let memory_updater = ref "trivial"
let storage_updater = ref "trivial"
let mload_solver = ref "trivial"
let sload_solver = ref "trivial"
let sstack_value_cmp = ref "basic"
let memory_cmp = ref "trivial"
let storage_cmp = ref "trivial"
let sha3_cmp = ref "trivial"
let opt_step_rep = ref "1"
let opt_pipeline_rep = ref "1"

let usage_msg = "checker [options] < filename"


let anon_fun filename = raise (Arg.Bad "invalid anonymous argument")
let process_opts s = opts_to_apply := List.map charlist_of_string (Str.split (Str.regexp "[,]+") s)
let process_memory_updater s = memory_updater := s
let process_storage_updater s = storage_updater := s
let process_mload_solver s = mload_solver := s
let process_sload_solver s = sload_solver := s
let process_sstack_value_cmp s = sstack_value_cmp := s
let process_memory_cmp s = memory_cmp := s
let process_storage_cmp s = storage_cmp := s
let process_sha3_cmp s = sha3_cmp := s
let process_opt_step_rep s = opt_step_rep := s
let process_opt_pipeline_rep s = opt_pipeline_rep := s

let speclist =
  [
    ("-opt", Arg.String process_opts, "A list of comma-separated optimizations (without white spaces) to be applied iteratively. Available optimizations are: ...");
    ("-mu", Arg.String process_memory_updater, "memory updater");
    ("-ms", Arg.String process_mload_solver, "mload solver");
    ("-su", Arg.String process_sload_solver, "sload solver");
    ("-ssv_c", Arg.String process_sstack_value_cmp, "sstack_value comparator");
    ("-mem_c", Arg.String process_memory_cmp, "memory comparator");
    ("-strg_c", Arg.String process_storage_cmp, "storage comparator");
    ("-sha3_c",  Arg.String process_sha3_cmp, "sha3 comparator");
    ("-opt_rep",  Arg.String process_opt_step_rep, "repetitions of each optimization");
    ("-pipeline_rep",  Arg.String process_opt_pipeline_rep, "optimization pipeline repetitions")
  ]



let main () =

  let chkr_lazy = Checker.Parser.block_eq (charlist_of_string !memory_updater) (charlist_of_string !storage_updater) (charlist_of_string !mload_solver) (charlist_of_string !sload_solver) (charlist_of_string !sstack_value_cmp) (charlist_of_string !memory_cmp) (charlist_of_string !storage_cmp) (charlist_of_string !sha3_cmp) (charlist_of_string !opt_step_rep) (charlist_of_string !opt_pipeline_rep) !opts_to_apply in
  match chkr_lazy with 
  | None -> Printf.printf "Invalid configuration\n";
  | Some chkr ->
      let i = ref 0 in
      try
        while true do
          i := !i+1;
          let p_opt = read_line() in (* read the optimized block *)
          let p = read_line() in     (* read the original block *)
          let k = read_line() in     (* read input statck size *)
          (* call the checker -- converting ocaml strings to corresponding lists of chars *)
          let r = chkr (charlist_of_string p_opt) (charlist_of_string p) (charlist_of_string k) in
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


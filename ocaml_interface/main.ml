
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
  
let read_line_from_in_channel ic () =
  let quit_loop = ref false in
  let line = ref " " in
  while not !quit_loop do
    line := input_line ic;
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
let in_filename_rep= ref ""
let out_filename_rep= ref ""

let usage_msg = Printf.sprintf "\nUsage:\n%s [options] < filename\n or\n%s -i filename [options]\n" Sys.argv.(0) Sys.argv.(0)

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
let process_in_filename s = in_filename_rep := s
let process_out_filename s = out_filename_rep := s

let speclist =
  [
    ("-opt", Arg.String process_opts, "Rule-based optimizations to be applied iteratively. Possible values:
    * none: disable optimizations
    * all: use all optimizations starting with 'eval'
    * all_size: use all optimizations starting with 'div_shl' and 'mul_shl' (useful for size)
    * A list of comma-separated optimizations (without white spaces). Available optimizations are: 
        eval,add_zero,not_not,and_and,and_origin,mul_shl,div_shl,shr_zero_x,shr_x_zero,eq_zero,sub_x_x,
        and_zero,div_one,lt_x_one,gt_one_x,and_address,mul_one,iszero_gt,eq_iszero,and_caller,iszero3,
        add_sub,shl_zero_x,sub_zero,shl_x_zero,mul_zero,div_x_x,div_zero,mod_one,mod_zero,mod_x_x,
        exp_x_zero,exp_x_one,exp_one_x,exp_zero_x,exp_two_x,gt_zero_x,gt_x_x,lt_x_zero,lt_x_x,eq_x_x,
        iszero_sub,iszero_lt,iszero_xor,iszero2_gt,iszero2_lt,iszero2_eq,xor_x_x,xor_zero,xor_xor,       
        or_or,or_and,and_or,and_not,or_not,or_x_x,and_x_x,or_zero,or_ffff,and_ffff,and_coinbase,
        balance_address");
    ("-mu", Arg.String process_memory_updater, "memory updater");
    ("-su", Arg.String process_storage_updater, "storage updater");
    ("-ms", Arg.String process_mload_solver, "mload solver");
    ("-ss", Arg.String process_sload_solver, "sload solver");
    ("-ssv_c", Arg.String process_sstack_value_cmp, "sstack_value comparator");
    ("-mem_c", Arg.String process_memory_cmp, "memory comparator");
    ("-strg_c", Arg.String process_storage_cmp, "storage comparator");
    ("-sha3_c",  Arg.String process_sha3_cmp, "sha3 comparator");
    ("-opt_rep",  Arg.String process_opt_step_rep, "repetitions of each optimization");
    ("-pipeline_rep",  Arg.String process_opt_pipeline_rep, "optimization pipeline repetitions");
    ("-i", Arg.String process_in_filename, "Input file (standard input if not provided)");
    ("-o", Arg.String process_out_filename, "Output file (standard output if not provided)")
  ]



let main () =

  let chkr_lazy = Checker.Parser.block_eq (charlist_of_string !memory_updater) (charlist_of_string !storage_updater) (charlist_of_string !mload_solver) (charlist_of_string !sload_solver) (charlist_of_string !sstack_value_cmp) (charlist_of_string !memory_cmp) (charlist_of_string !storage_cmp) (charlist_of_string !sha3_cmp) (charlist_of_string !opt_step_rep) (charlist_of_string !opt_pipeline_rep) !opts_to_apply in
  match chkr_lazy with 
  | None -> Printf.printf "Invalid configuration\n";
  | Some chkr ->
      let i = ref 0 in
      let ic = if (String.length !in_filename_rep == 0)  then stdin  else open_in  !in_filename_rep  in
      let oc = if (String.length !out_filename_rep == 0) then stdout else open_out !out_filename_rep in
      try
        while true do
          let p_opt = read_line_from_in_channel ic () in (* read the optimized block *)
          let p = read_line_from_in_channel ic () in     (* read the original block *)
          let k = read_line_from_in_channel ic () in     (* read input statck size *)
          (*
          print_endline p_opt;
          print_endline p;
          print_endline k;
          *)
          (* call the checker -- converting ocaml strings to corresponding lists of chars *)
          let r = chkr (charlist_of_string p_opt) (charlist_of_string p) (charlist_of_string k) in
          (* print the result *)
          match r with
          | None -> Printf.fprintf oc "Example %d: parsing error\n\n  %s\n  %s\n  %s\n\n%!" !i p_opt p k;
                    i := !i+1;
          | Some b -> Printf.fprintf oc "Example %d: %B\n%!" !i b;
                    i := !i+1;
        done;
        close_out oc; (* Flushes write operations and closes out file *)
      with
      | End_of_file -> ();
      | e -> raise e;;



let _ = Arg.parse speclist anon_fun usage_msg;
        main ();;


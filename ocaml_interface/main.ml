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
      let r = Checker.Parser.block_eq_2 (charlist_of_string p_opt) (charlist_of_string p) (charlist_of_string k) in
      (* print the result *)
      match r with
      | None -> Printf.printf "Example %d: parsing error\n\n  %s\n  %s\n  %s\n\n" !i p_opt p k;
      | Some b -> Printf.printf "Example %d: %B\n" !i b;
    done
  with
  | End_of_file -> ();
  | e -> raise e;;

let _ = main ();;

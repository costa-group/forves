let charlist_of_string s =
  let rec trav l i =
    if i = l then [] else s.[i]::trav l (i+1)
  in
  trav (String.length s) 0;;

  
let main () =
      try
        while true do
          let p_opt = input_line stdin in (* read the optimized block *)
            let p = input_line stdin in     (* read the original block *)
              let k = input_line stdin in     (* read input statck size *)
                (* call the checker -- convering strings to corresponding lists of chars *)
                let r = Checker.Parser.block_eq (charlist_of_string p_opt) (charlist_of_string p) (charlist_of_string k) in
                  (* print the result *)
                  match r with
                    | None -> print_endline "--"; print_endline "Something went wrong while checking the following instance:"; print_endline ""; print_endline p_opt; print_endline p; print_endline k; print_endline "--";
                    | Some b -> print_endline (string_of_bool b)
        done              
     with
        | End_of_file -> ();
        | e -> raise e
                                               
let _ = main ()

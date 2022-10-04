let charlist_of_string s =
  let rec trav l i =
    if i = l then [] else s.[i]::trav l (i+1)
  in
  trav (String.length s) 0;;

  
let main () =
      try
        while true do
          let p_opt = input_line stdin in
          let p = input_line stdin in
          let k = input_line stdin in
          let r = Checker.Parser.block_eq (charlist_of_string p_opt) (charlist_of_string p) (charlist_of_string k) in
          match r with
          | None -> print_endline "something went wrong"; print_endline p_opt; print_endline p; print_endline k;
          | Some b -> print_endline (string_of_bool b)
          done
     with
        | End_of_file -> print_endline "bye"
        | e -> raise e
                                               
let _ = main ()

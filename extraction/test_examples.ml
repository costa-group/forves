let main () =

    print_endline "Running test_examples.ml";
    print_endline "Tests:";
    
    print_string "checker_ex1_bool:\texpected: true\tans:";
    print_endline (string_of_bool Examples.checker_ex1_bool);
    
    print_string "checker_ex2_bool:\texpected: false\tans:";
    print_endline (string_of_bool Examples.checker_ex2_bool);
    
    print_string "checker_ex3_bool:\texpected: true\tans:";
    print_endline (string_of_bool Examples.checker_ex3_bool);
    
    print_string "checker_ex3_comm_bool:\texpected: true\tans:";
    print_endline (string_of_bool Examples.checker_ex3_comm_bool);

    print_string "checker_ex4_bool:\texpected: true\tans:";
    print_endline (string_of_bool Examples.checker_ex4_bool);
   
    print_string "checker_ex4b_bool:\texpected: true\tans:";
    print_endline (string_of_bool Examples.checker_ex4b_bool);
    
    print_string "checker_ex5_bool:\texpected: true\tans:";
    print_endline (string_of_bool Examples.checker_ex5_bool);

    print_string "checker_ex6_bool:\texpected: true\tans:";
    print_endline (string_of_bool Examples.checker_ex6_bool);
    
    print_string "checker_ex_real_bool:\texpected: true\tans:";
    print_endline (string_of_bool Examples.checker_ex_real_bool)

let _ = main ()

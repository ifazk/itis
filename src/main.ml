open Parse;;
open Types;;

let rec errors_of_file = function
  | Word _ :: [] | [] -> ()
  | Word _ :: Itis p :: l | Itis p :: l ->
    Printf.eprintf "%s: it's should be it is\n" (Position.to_string p);
    errors_of_file l
  | Word (s1, p1) :: ((Word (s2, p2) :: l) as l') ->
    if s1 = s2 then
      ( Printf.eprintf "%s: Duplicate Word\n" (Position.to_string p1)
      ; Printf.eprintf "%s: Duplicate Word\n" (Position.to_string p2)
      ; errors_of_file l
      )
    else
      errors_of_file l'


let test_file f =
  let lexbuf = Parse.Lexer.lexbuf_of_file f in
  let f = Parser.file Lexer.read lexbuf in
  errors_of_file f

let parse_files files =
  List.iter test_file files

let main () =
  let files = Array.to_list Sys.argv |> List.tl in
  parse_files files

let () =
  main ()

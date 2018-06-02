open Base;;
open Sexp;;
open Lexing;;

type t = Lexing.position

let t_of_sexp = function
  | List
      [ List [(Atom "pos_fname"); (Atom fname)]
      ; List [(Atom "pos_lnum"); (Atom lnum)]
      ; List [(Atom "pos_bol"); (Atom bol)]
      ; List [(Atom "pos_cnum"); (Atom cnum)]
      ] ->
    { pos_fname = fname
    ; pos_lnum = Int.of_string lnum
    ; pos_bol = Int.of_string bol
    ; pos_cnum = Int.of_string cnum
    }
  | _ -> assert false

let sexp_of_t = function
  | { pos_fname = fname
    ; pos_lnum = lnum
    ; pos_bol = bol
    ; pos_cnum = cnum
    } ->
    List
      [ [%sexp_of: string * string] ("pos_fname", fname)
      ; [%sexp_of: string * int] ("pos_lnum",  lnum)
      ; [%sexp_of: string * int] ("pos_bol", bol)
      ; [%sexp_of: string * int] ("pos_cnum", cnum)
      ]

let pp ppf pos =
  let file ppf = function
    | "" -> Fmt.nop ppf ()
    | f -> Fmt.pf ppf "%s:" f
  in
  Fmt.pf ppf "%a%d:%d"
    file pos.pos_fname
    pos.pos_lnum
    (pos.pos_cnum - pos.pos_bol)

let pp_no_file ppf pos =
  Fmt.pf ppf "%d:%d"
    pos.pos_lnum
    (pos.pos_cnum - pos.pos_bol)

let to_string : t -> String.t =
  Fmt.to_to_string pp

open Base;;

type word_t =
  | Itis of Position.t
  | Word of string * Position.t
[@@deriving sexp]

type words = word_t list

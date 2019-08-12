{
open Lexing;;
open Parser;;
open Types;;

let next_line lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <-
    { pos with pos_bol = pos.pos_cnum;
               pos_lnum = pos.pos_lnum + 1
    }

let tok_of_word pos =
    function
    | "it's" -> WORD (Itis pos)
    | "It's" -> WORD (Itis pos)
    | s -> WORD (Word (s, pos))

let lexbuf_of_file f =
    let ic = Stdlib.open_in f in
    let lexbuf = Lexing.from_channel ic in
    ( lexbuf.lex_curr_p <-
        { lexbuf.lex_curr_p with pos_fname = f }
    ; lexbuf.lex_curr_p <-
        { lexbuf.lex_start_p with pos_fname = f }
    ; lexbuf
    )

let unexpected_character prefix pos lexeme =
    let err_msg =
      Printf.sprintf
        "%s: %s\nError at: %s." prefix lexeme (Position.to_string pos)
    in
    failwith err_msg
}

let word = [^ '\r' '\n' ' ' '\t' '%']+
let newline = '\r' | '\n' | "\r\n"
let whitespace = [' ' '\t']+
let comment_start = "%"
let comment_middle = [^ '\r' '\n']*

rule read =
     parse
     | word { tok_of_word (lexeme_start_p lexbuf) (lexeme lexbuf) }
     | newline { next_line lexbuf; read lexbuf }
     | whitespace { read lexbuf }
     | comment_start comment_middle { read lexbuf }
     | eof { EOF }
     | _ { failwith (unexpected_character
                       "Unexpected character"
                       (Lexing.lexeme_start_p lexbuf)
                       (Lexing.lexeme lexbuf)
                    ) }

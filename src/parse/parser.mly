%{
%}
%token <Types.word_t> WORD
%token EOF

%start <Types.words> file

%%

file:
    | ws = list(WORD); EOF { ws }
    ;

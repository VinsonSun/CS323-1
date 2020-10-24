%{
    #include"lex.yy.c"
    void yyerror(const char*);
%}

%token LC RC LB RB COLON COMMA
%token STRING NUMBER
%token TRUE FALSE VNULL
%%

Json:
      Value
    ;
Value:
      Object
    | Array
    | STRING
    | NUMBER
    | TRUE
    | FALSE
    | VNULL
    ;
Object:
      LC RC
    | LC Members RC
    | LC Members COMMA RC error {puts("extra comma");}
    | LC Members RC Value error {puts("misplaced value,recovered");}
    | LC Members RC COMMA error {puts("comma after close,recovered");}
    ;
Members:
      Member
    | Member COMMA error{puts("extra comma, recovered");}
    | Member COMMA Members
    ;
Member:
      STRING COLON Value
    | STRING COLON COLON Value error{puts("double colon,recovered");}
    | STRING COMMA Value error {puts("comma instead of colon, recovered");}
    | STRING Value error {puts("missing colon, recovered");}
    | COLON Value error{puts("unquetoed key, recovered");}
    ;
Array:
      LB Values error {puts("Unclosed array, recovered");}
    | LB RB
    | LB Values RB COMMA error{puts("comma after close, recovered");}
    | LB RB RB error{puts("extra close,recovered");}
    | LB Values RB
    | LB Values RB RB error{puts("extra close,recovered");}
    | LB Values RC error { puts("unmatched right bracket, recovered"); }
    ;
Values:
      Value
    | Value COMMA error{puts("extra comma,recovered");}
    | Value COMMA COMMA error {puts("extra comma,recovered");}
    | Value COMMA Values
    | COMMA Values error{puts("miss value,recovered");}
    ;
%%

void yyerror(const char *s){
    printf("syntax error: ");
}

int main(int argc, char **argv){
    if(argc != 2) {
        fprintf(stderr, "Usage: %s <file_path>\n", argv[0]);
        exit(-1);
    }
    else if(!(yyin = fopen(argv[1], "r"))) {
        perror(argv[1]);
        exit(-1);
    }
    yyparse();
    return 0;
}

%{
    #include <stdlib.h>
    #include <string.h>
    #include <stdio.h>
    #include <math.h>
    #include "tree.h"
    #include "syntax.tab.h"
    int yycolumn = 1;
    extern int error_num;
    #define YY_USER_ACTION \
        yylloc.first_line = yylloc.last_line = yylineno; \
        yylloc.first_column = yycolumn; \
        yylloc.last_column = yycolumn + yyleng - 1; \
        yycolumn += yyleng;

%}

digit [0-9]
hex_head "0x"|"0X"
hex_char [0-9a-fA-F]
not_hex_char [g-zG-Z]
letter [_a-zA-Z]
%option yylineno

%%

"struct" {
    yylval.node = new_node(yylineno, "STRUCT", STRUCT, NULL);
    return STRUCT;
}
"return" {
    yylval.node = new_node(yylineno, "RETURN", RETURN, NULL);
    return RETURN;
}
"if" {
    yylval.node = new_node(yylineno, "IF", IF, NULL);
    return IF;
}
"else" {
    yylval.node = new_node(yylineno, "ELSE", ELSE, NULL);
    return ELSE;
}
"while" {
    yylval.node = new_node(yylineno, "WHILE", WHILE, NULL);
    return WHILE;
}
"int"|"float"|"char" {
    char *s = malloc(strlen(yytext) + 1);
    strcpy(s, yytext);
    yylval.node = new_node(yylineno, "TYPE", TYPE, s);
    return TYPE;
}
0|[1-9]{digit}* {
    unsigned int val = atol(yytext);
    yylval.node = new_node(yylineno, "INT", INT, &val);
    return INT;
}
{digit}*\.{digit}*[eE][\+\-]?{digit}+ {
    float val = strtof(yytext, NULL);
    yylval.node = new_node(yylineno, "FLOAT", FLOAT, &val);
    return FLOAT;
}
{digit}+\.{digit}+ {
    float val = strtof(yytext, NULL);
    yylval.node = new_node(yylineno, "FLOAT", FLOAT, &val);
    return FLOAT;
}
{hex_head}[0-9a-zA-Z]*{not_hex_char}+[0-9a-zA-Z]* {
    printf("Error type A at Line %d: unknown lexeme %s\n", yylineno, yytext);
    error_num++;
    int val = 0;
    yylval.node = new_node(yylineno, "INT", INT, &val);
    return INT;
}
{hex_head}{hex_char}+ {
    unsigned int val = 0;
    sscanf(yytext, "%x", &val);
    yylval.node = new_node(yylineno, "INT", INT, &val);
    return INT;
}
{letter}({digit}|{letter})* {
    char *s = malloc(strlen(yytext) + 1);
    strcpy(s, yytext);
    yylval.node = new_node(yylineno, "ID", ID, s);
    return ID;
}
{digit}({digit}|{letter})* {
    error_num++;
    printf("Error type A at Line %d: unknown lexeme %s\n", yylineno, yytext);
    return LEX_ERROR;
}
\'{letter}\'|\'\\[xX][0-9a-fA-F]{1,2}\'|\'{digit}\' {
    char *s = malloc(strlen(yytext) + 1);
    strcpy(s, yytext);
    yylval.node = new_node(yylineno, "CHAR", CHAR, s);
    return CHAR;
}
\'.+\' {
    error_num++;
    printf("Error type A at Line %d: unknown lexeme %s\n", yylineno, yytext);
    return LEX_ERROR;
}
";" {
    yylval.node = new_node(yylineno, "SEMI", SEMI, NULL);
    return SEMI;
}
"," {
    yylval.node = new_node(yylineno, "COMMA", COMMA, NULL);
    return COMMA;
}
"=" {
    yylval.node = new_node(yylineno, "ASSIGN", ASSIGN, NULL);
    return ASSIGN;
}
">" {
    char s[3] = "";
    strcpy(s, yytext);
    yylval.node = new_node(yylineno, "GT", GT, s);
    return GT;
}
"<" {
    char s[3] = "";
    strcpy(s, yytext);
    yylval.node = new_node(yylineno, "LT", LT, s);
    return LT;
}
">=" {
    char s[3] = "";
    strcpy(s, yytext);
    yylval.node = new_node(yylineno, "GE", GE, s);
    return GE;
}
"<=" {
    char s[3] = "";
    strcpy(s, yytext);
    yylval.node = new_node(yylineno, "LE", LE, s);
    return LE;
}
"==" {
    char s[3] = "";
    strcpy(s, yytext);
    yylval.node = new_node(yylineno, "EQ", EQ, s);
    return EQ;
}
"!=" {
    char s[3] = "";
    strcpy(s, yytext);
    yylval.node = new_node(yylineno, "NE", NE, s);
    return NE;
}

\+ {
    yylval.node = new_node(yylineno, "PLUS", PLUS, NULL);
    return PLUS;
}
"-" {
    yylval.node = new_node(yylineno, "MINUS", MINUS, NULL);
    return MINUS;
}
\* {
    yylval.node = new_node(yylineno, "MUL", MUL, NULL);
    return MUL;
}
\/ {
    yylval.node = new_node(yylineno, "DIV", DIV, NULL);
    return DIV;
}
"&&" {
    yylval.node = new_node(yylineno, "AND", AND, NULL);
    return AND;
}
"||" {
    yylval.node = new_node(yylineno, "OR", OR, NULL);
    return OR;
}
\. {
    yylval.node = new_node(yylineno, "DOT", DOT, NULL);
    return DOT;
}
"!" {
    yylval.node = new_node(yylineno, "NOT", NOT, NULL);
    return NOT;
}
\( {
    yylval.node = new_node(yylineno, "LP", LP, NULL);
    return LP;
}
\) {
    yylval.node = new_node(yylineno, "RP", RP, NULL);
    return RP;
}
\[ {
    yylval.node = new_node(yylineno, "LB", LB, NULL);
    return LB;
}
\] {
    yylval.node = new_node(yylineno, "RB", RB, NULL);
    return RB;
}
\{ {
    yylval.node = new_node(yylineno, "LC", LC, NULL);
    return LC;
}
\} {
    yylval.node = new_node(yylineno, "RC", RC, NULL);
    return RC;
}
\| {
     error_num++;
     printf("Error type A at Line %d: unknown lexeme %s\n", yylineno, yytext);
     return LEX_ERROR;
}
\n {yycolumn = 1;}
[" "|\r|\t] {}
. {
    error_num++;
    printf("Error type A at Line %d: unknown lexeme %s\n", yylineno, yytext);
    return LEX_ERROR;
}

%%



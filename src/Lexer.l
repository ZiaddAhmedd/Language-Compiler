
%{
    #include "Parser.tab.h"
    #include <stdlib.h>
    #include <stdio.h>
    #include<string.h>
    // int yylval;
    int yyerror(char *s); 
    extern int yylineno;
	int yylex();
%}
%%

    /* keywords */
"if"                        {return IF;}
"else"                      {return ELSE;}

"while"                     {return WHILE;}
"for"                       {return FOR;}
"repeat"                    {return REPEAT;}
"until"                     {return UNTIL;}

"switch"                    {return SWITCH;}
"case"                      {return CASE;}
"default"                   {return DEFAULT;}

"break"                     {return BREAK;}


"return"                    {return RETURN;}


"enum"                      {return ENUM;}

    /* data types */
"int"                       {return INT;}
"float"                     {return FLOAT;}
"char"                      {return CHAR;}
"string"                    {return STRING;}
"bool"                      {return BOOL;}
"const"                     {return CONST;}
"void"                      {return VOID;}

    /* boolean constants */
"true"                      {return BOOL_TRUE;}         /* might want to return a value as well (0 for false, 1 for true) */
"false"                     {return BOOL_FALSE;}

    /* operators */
    /* Logical Operators and comparators */
"&&"                        {return AND;}
"||"                        {return OR;}
"!"                         {return NOT;}
"=="                        {return EQ;}
"!="                        {return NEQ;}
"<"                         {return LT;}
">"                         {return GT;}
"<="                        {return LEQ;}
">="                        {return GEQ;}

    /* Arithmetic Operators */

"="                         {return ASSIGN;}
"+"                         {return ADD;}
"-"                         {return SUB;}
"*"                         {return MUL;}
"/"                         {return DIV;}
"%"                         {return MOD;}
"++"                        {return INC;}
"--"                        {return DEC;}

    /* Semi Colon and colon */
[:;,]                         {return yytext[0];}


    /* punctuators (brackets and stuff like that) */
[(){}\[\]]                    {return yytext[0];}      /* \ is used as escape character for [ and ] */

    /* Identifiers */

[_a-zA-Z][_a-zA-Z0-9]*       {yylval.ID=strdup(yytext);return ID;}               /* returns variable name as well */

    /* Numbers */
(0|[1-9][0-9]*)                       {yylval.IntegerValue = atoi(yytext); return INTEGER_NUMBER;}             /* Don't accept leading zeros */

(0|[1-9][0-9]*)\.[0-9]+               {yylval.FloatValue = atof(yytext); return FLOATING_POINT_NUMBER;}      

    /* String Literals */
\"[_!\.@%&#$?^~'a-zA-Z0-9 ]*\"                       {yylval.StringValue=strdup(yytext); return STRING_LITERAL;}    /* strdup: duplicates the string and returns pointer to it */
    
    /* Character Literals */
\'[a-zA-Z0-9]\'                       {yylval.CharValue=strdup(yytext); return CHAR_LITERAL;}        


    /* Comments - Might add later if needed to handle comments */ 
\/\/[^\n]*                            {;}                  /* for single line comment do nothing */
\/\*([^*]|\*[^\/])*\*\/               {;}                  /* for multi line comment do nothing */

    /* Whitespaces */
[ \t]+                                 {;}                  /* for space or tab do nothing */

    /* Newline */
(\n)                                  {yylineno = yylineno+1;}          /* for newline we increment number of line*/

    /* other stuff */ 
.                                      {yyerror("Unknown character");}  /* for any other thing return error*/



%%
int yywrap()
{
    return 1;                                // when finished return 1;
}
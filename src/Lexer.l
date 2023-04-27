
%{
#include "Parser.tab.h"
#include <stdio.h>
// int yylval;
%}
%%

    /* keywords */
"if"                        {return IF;}
"else"                      {return ELSE;}

"while"                     {return WHILE;}
"for"                       {return FOR;}
"do"                        {return DO;}

"switch"                    {return SWITCH;}
"case"                      {return CASE;}
"default"                   {return DEFAULT;}

"break"                     {return BREAK;}
"continue"                  {return CONTINUE;}

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



    /* punctuators (brackets and stuff like that) */
[(){}\[\]]                    {return yytext[0];}      /* \ is used as escape character for [ and ] */

    /* Identifiers */

[_a-zA-Z][_a-zA-Z0-9]*       {return ID;}               /* might need to return the variable name itself */

    /* Numbers */
(0|[1-9][0-9]+)                       {return INTEGER;}             /* might need to return the number itself
                                                                    Don't accept leading zeros */

(0|[1-9][0-9]*)\.[0-9]+               {return FLOATING_POINT;}      /* might need to return the number itself */

    /* String Literals */
\"[a-zA-Z0-9]\"                       {return STRING_LITERAL;}      /* might need to return the string itself */
    
    /* Character Literals */
\'[a-zA-Z0-9]\'                       {return CHAR_LITERAL;}        /* might need to return the character itself */


    /* Comments - Might add later if needed to handle comments */ 

    /* Whitespaces */
[ \t]+                                 {;}                  /* for space or tab do nothing */

    /* Newline */
(\n)+                                  {;}          /* for newline we will increment number of line (in later phase)*/

    /* other stuff */ 
.                                      {yyerror("Unknown character");}  /* for any other thing return error*/



%%
int yywrap()
{
    return 1;                                // when finished return 1;
}
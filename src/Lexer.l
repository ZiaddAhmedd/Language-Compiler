
%{
//#include "y.tab.h"
#include <stdio.h>
#include "constants.h"
int yylval;
%}
%%

"int"[ ]+ {return KEY;}                     // [ ]+ to take any number of spaces
"float"[ ]+ {return KEY;}
"double"[ ]+ {return KEY;}
"short"[ ]+ {return KEY;}
"char"[ ]+ {return KEY;}
"string"[ ]+ {return KEY;}
"bool"[ ]+ {return KEY;} 
"const"[ ]+ {return KEY;}
"if"[ ]+ {return KEY;}
"else"[ ]+ {return KEY;}
"while"[ ]+ {return KEY;}
"for"[ ]+ {return KEY;}
"do"[ ]+ {return KEY;}
"switch"[ ]+ {return KEY;}
"case"[ ]+ {return KEY;}
"break"[ ]+ {return KEY;}
"continue"[ ]+ {return KEY;}
"return"[ ]+ {return KEY;}
"true"[ ]+ {return KEY;}
"false"[ ]+ {return KEY;}
"void"[ ]+ {return KEY;}
"enum"[ ]+ {return KEY;}
[-+*/%=<>!{}():,] {printf("%c", yytext[0]);}
"&&" {return AND;}
"||" {return OR;}
"==" {return EQ;}
"!=" {return NEQ;}
"<=" {return LEQ;}
">=" {return GEQ;}
[_a-zA-Z][_a-zA-Z0-9]* {return ID;}          //Identifiers
-?[0-9]+ {return NUM;}                       //Numbers
[ \t] ;                                      // for space or tab do nothing
[;] {return SEMICOLON;}
\n {return 0;}                               // for newline return 0
. {return yytext[0];}                        // for any other thing return it to the yacc program
%%
int main()
{
    yylex();
}
int yywrap()
{
    return 1;                                // when finished return 1;
}
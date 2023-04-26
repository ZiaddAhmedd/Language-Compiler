
%{
//#include "y.tab.h"
#include <stdio.h>
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

[a-zA-Z][a-zA-Z][0-9] {return ID;}
[0-9]+ {return NUM;}
[ \t] ;                                     // for space or tab do nothing
[;] {return COLON;}
\n {return 0;}                              // for newline return 0
. {return yytext[0];}                       // for any other thing return it to the yacc program
%%
int yywrap()
{
    return 1;                               // when finished return 1;
}
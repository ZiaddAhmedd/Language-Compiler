%{

%}
%union{
    int num;
    char sym;
}

// Keywords
%token IF ELSE WHILE FOR DO SWITCH CASE DEFAULT BREAK CONTINUE RETURN ENUM

// Data types
%token INT FLOAT CHAR STRING BOOL CONST VOID

// boolean constants
%token BOOL_TRUE BOOL_FALSE

// Logical operators
%token AND OR NOT

// Comparators
%token EQ NEQ LT GT LEQ GEQ

// Arithmetic operators
%token ASSIGN ADD SUB MUL DIV MOD

// punctuators (parentheses, brackets ,and braces) -----> These are handled as characters directly. e.g IF '(' exp ')' '{' exp '}'

// Identifiers
%token ID

// Numbers
%token INTEGER  FLOATING_POINT

// Strings
%token STRING_LITERAL

// Character
%token CHAR_LITERAL



%%
/* 
input:
|   line input
;

line:
    exp EOL {printf("%d\n", $1);}
|   EOL;
exp: 
    NUMBER {$$ = $1;}
|   exp PLUS exp {$$ = $1 + $3;}
|   exp MINUS exp {$$ = $1 - $3;}
|   exp MULTIPLY exp {$$ = $1 * $3;}

;    */
program:;

%%

int main() {
    yyparse();

    return 0;
}

yyerror(char *s) {
    printf("ERROR %s\n", s);

    return 0;
}
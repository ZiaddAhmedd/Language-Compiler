# Language-Compiler

## Variables and Constants declaration.
```
TYPE ID; --> EX: int x;
CONST TYPE ID ASSIGN EXPRESSION; --> EX: const int x = 5;
```
## Mathematical and logical expressions.
```
ID ASSIGN STMT ADD STMT; --> EX: int z = x + y;
ID ASSIGN STMT SUB STMT; --> EX: int z = x - y;
ID ASSIGN STMT MUL STMT; --> EX: int z = x * y;
ID ASSIGN STMT DIV STMT; --> EX: int z = x / y;
ID ASSIGN STMT MOD STMT; --> EX: int z = x % y;
ID INC; --> EX: x++;
ID DEC; --> EX: x--;
ID ASSIGN ( STMT ) --> EX: int z = (x + y);
```
## Assignment statement.
```
TYPE ID ASSIGN EXPRESSION; --> EX: int x = 5;
ID ASSIGN EXPRESSION; --> EX: x = 5;
```
## If-then-else statement, while loops, repeat-until loops, for loops, switch statement.

### IF ELSE statement.
```
IF ( EXPRESSION ) {many statements} EX: if (x == 5) {x = 6; y = 7;}
IF ( EXPRESSION ) {many statements} ELSE {many statements} EX: if (x == 5) {x = 6; y = 7;} else {x = 7; y = 8;}
```
### WHILE statement.
```
WHILE ( EXPRESSION ) {many statements} EX: while (x == 5) {x = 6; y = 7;}
```
### REPEAT UNTIL statement.
```
REPEAT {many statements} UNTIL ( EXPRESSION ) EX: repeat {x = 6; y = 7;} until (x == 5);
```
### FOR statement.
```
FOR ( INT ID ASSIGN INTEGER ; EXPRESSION ; UNARY EXPRESSION ) {many statements} EX: for (int x = 0; x < 5; x++) {y = 7;}
```
### SWITCH statement.
```
SWITCH ( ID ) {many statements} EX: switch (x) {case 1: y = 1; break; case 2: y = 2; break; default: y = 3;}
NOTE: Do NOT place a break in the default
```
## Enums
```
ENUM ID {ENUM SCOPE} EX: enum x {a = 0, b = 2, c = 4};
ENUM SCOPE: ID ASSIGN INTEGER, ENUM SCOPE 
          | ID ASSIGN INTEGER
```
## Functions
### Function declaration.

```
TYPE ID (ARGLIST) {many statements RETURN EXPRESSION} 
EX: int Func (int y, int z) {int sum = y + z; return sum;}
EX: int Func () {int sum = y + z; return sum;}
NOTE: function has to have at least 1 statement

VOID ID (ARGLIST) {many statements RETURNCASE}
EX: void Func (int y, int z) {y = 5; z = 6; return;}
EX: void Func (int y, int z) {y = 5;}
EX: void Func () {y = 5; z = 6; return;}

ARGLIST: TYPE ID, ARGLIST | TYPE ID |
RETURNCASE: RETURN; | 
```
### Function call.
```
NOTE: you cannot pass variables by value. Func(4,5) is not allowed for example.
ID (CALL LIST); EX: func (a, b);
ID ASSIGN ID (CALL LIST); EX: x = FUNC(a, b);
TYPE ID ASSIGN ID (CALL LIST); EX: int x = FUNC(a, b);
                               EX: int x = FUNC();

CALL LIST: ID , CALL LIST | ID |
```
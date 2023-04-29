%{
    int yylineno;
    int yylex(void);
    int yyerror(char *s); 
%}
%union{
    int num;
    char sym;
}

// Keywords
%token IF ELSE WHILE FOR REPEAT UNTIL SWITCH CASE DEFAULT BREAK RETURN ENUM

// Data types
%token INT FLOAT CHAR STRING BOOL CONST VOID

// boolean constants
%token BOOL_TRUE BOOL_FALSE

// Logical operators
%token AND OR NOT

// Comparators
%token EQ NEQ LT GT LEQ GEQ

// Arithmetic operators
%token ASSIGN ADD SUB MUL DIV MOD INC DEC

// punctuators (parentheses, brackets ,and braces) -----> These are handled as characters directly. e.g IF '(' exp ')' '{' exp '}'

// Identifiers
%token ID

// Numbers
%token INTEGER_NUMBER  FLOATING_POINT_NUMBER

// Strings
%token STRING_LITERAL

// Character
%token CHAR_LITERAL

// Associativity
%left ASSIGN
%left GT LT
%left GEQ LEQ
%left EQ NEQ
%left AND OR NOT
%left ADD SUB 
%left MUL DIV MOD



%%
StartProgram :                  {printf("==========\nEmpty program\n");}    // Check if this works
    | manyStatements
    ;

stmt: type ID ';'                                   {printf("==========\nDeclaration\n");}
    
    | ID ASSIGN expression ';'                      {printf("==========\nAssignment\n");}
    
    | type ID ASSIGN expression ';'                 {printf("==========\nDeclaration and Assignment\n");}
    
    | CONST type ID ASSIGN expression ';'           {printf("==========\nConstant Declaration and Assignment\n");}

    | WHILE '(' expression ')' blockScope           {printf("==========\nWhile loop\n");}       // whileQuad

    | REPEAT blockScope UNTIL '(' expression ')'  ';'    {printf("==========\nRepeat Until\n");}           // close repeat with a ; at the end // DowhileQuad

    | FOR '(' INT create ';' expression ';' unaryExpression ')' blockScope      {printf("==========\nFor loop\n");}   // forQuad

    | IF '(' expression ')' blockScope                  {printf("==========\nIf statement\n");}

    | IF '(' expression ')' blockScope ELSE elseQuad        {printf("==========\nIf else statement\n");}

    | SWITCH '(' ID ')' switchScope         {printf("==========\nSwitch statement\n");}

    | ENUM ID '{' ENUMscope '}' ';'         {printf("==========\nEnum statement\n");}
    
    | function                              {printf("==========\nFunction\n");}

    | callFunction                          {printf("==========\nFunction call\n");}

    | ID ASSIGN callFunction                {printf("==========\nFunction call with assignment\n");}

    | type ID ASSIGN callFunction           {printf("==========\nFunction call with assignment and type\n");}
    
    | blockScope                            {printf("==========\nNew block\n");}

    | unaryExpression ';'                   {printf("==========\nUnary expression\n");}
    
    | ';'                                   {printf("==========\nEmpty statement\n");}
    ;

create : ID ASSIGN INTEGER_NUMBER	{};     // creates a variable and assigns a value to it

function :  type ID '(' argList ')' '{' manyStatements RETURN  expression  ';'   '}'    {
                                                                                            printf("==========\nfunction body\n");	
                                                                                        }

    |       VOID ID '(' argList ')' '{' manyStatements RETURN  ';'   '}'            {
                                                                                            printf("==========\nvoid function body\n");	
                                                                                        }
    ;


callFunction: ID '(' callList ')' ';'		{
                                                // printf("==========\nCalling %s within scope\n",$1);
                                                printf("==========\nCalling function within scope\n");
                                            };

																								

callList:   ID ',' callList {}
	      |  ID   {}
		  | 
	;	

argList:  type ID ',' argList {}
	      | type ID 		    {}
		  |                              
	;

blockScope:	 
            '{' manyStatements '}' 			{
                                                printf("==========\nblockScope type 1: many statements\n");
                                            }
    |       '{' '}'                 		{
                                                printf("==========\nblockScope type 2: empty braces\n");
                                            }
    ;

ENUMscope:
            ID ASSIGN INTEGER_NUMBER ',' ENUMscope 		{
                                                printf("==========\nENUMscope type 1: has comma\n");
                                            }
    |       ID ASSIGN INTEGER_NUMBER        {
                                                printf("==========\nENUMscope type 2: last element (no comma)\n");
                                            }
    ;

switchScope:  '{' caseExpression '}'			{
                                                    printf("==========\nSwitch Case block\n");
                                                }
    ;


manyStatements: 
            stmt {}
    
    |       manyStatements stmt {}
    ;

type:   INT {}
	| FLOAT {}
	| CHAR  {}
	| STRING{}
	| BOOL	{}
	;

/* funcType:   type
    |       VOID    {}
    ; */

equalStmt:   FLOATING_POINT_NUMBER                     {
												printf("==========\nfloat number\n");
											   }
		| INTEGER_NUMBER		                       {
												printf("==========\nint number\n");
											   }
		| ID                           {
												printf("==========\nidentifier\n");}
		| equalStmt ADD	equalStmt        {
												printf("==========\naddition\n");
											   }
		| equalStmt SUB equalStmt        {
												printf("==========\nsubtraction\n");
											   }
		| equalStmt MUL equalStmt     {
												printf("==========\nmultiplication\n");             // Test precedence
											   }
		| equalStmt  DIV	equalStmt    {
												printf("==========\ndivision\n");
											   }
		| equalStmt  MOD	equalStmt        {
												printf("==========\nremainder\n");
											   }
		| ID INC                       {printf("==========\nincrement\n");}

		| ID DEC                       {printf("==========\ndecrement\n");}

		| '(' equalStmt ')'      {
												printf("==========\nWith brackets 1\n");	
											   }
		;

unaryExpression : ID INC         {}   // i++ or i-- for example
    |           ID DEC         {}
    ;


booleanExpression: expression AND expression        {
														printf("==========\nand expression\n");
													}
															
			| expression OR expression             	{
														printf("==========\nor expression\n");
													}

			| NOT expression                        {
														printf("==========\nnot expression\n");
													}

			| DataValues GT DataValues       {
														printf("==========\ngreater than\n");
													}

			| DataValues LT DataValues          {
														printf("==========\nless than\n");
													}

			| DataValues GEQ DataValues  	{
															printf("==========\ngreater than or equal\n");
														}
			| DataValues LEQ DataValues   {
														printf("==========\nless than or equal\n");
													}
			| DataValues NEQ DataValues      {
													printf("==========\nnot equal\n");
												}

			| DataValues EQ DataValues          {
													printf("==========\nequal\n");
												}
			| '(' booleanExpression ')'         {
														printf("==========\nWith brackets 2\n");	
                                                }
			;

DataValues:
            equalStmt{}
		| CHAR_LITERAL 					{
											printf("==========\ncharcter\n");
										}
		| BOOL_FALSE 					{
												printf("==========\nfalse\n");
										}
	    | BOOL_TRUE						{
												printf("==========\ntrue\n");
										}
		| STRING_LITERAL 				{
												printf("==========\ntext\n");
										}
		;

expression:	DataValues{}
		| booleanExpression{};

caseExpression:	
            DEFAULT ':' manyStatements BREAK ';'    		     {printf("==========\nDefault case Statment\n");}	 	                   
    |       CASE INTEGER_NUMBER ':' manyStatements BREAK ';' caseExpression 	 {printf("==========\nNon-default case Statment\n");}	 
		      ;




elseQuad:{}blockScope           // either empty or a blockScope








/* 
input:
|   line input
;

line:
    exp EOL {printf("==========\n%d\n", $1);}
|   EOL;
exp: 
    NUMBER {$$ = $1;}
|   exp PLUS exp {$$ = $1 + $3;}
|   exp MINUS exp {$$ = $1 - $3;}
|   exp MULTIPLY exp {$$ = $1 * $3;}

;    */

%%

int main() {
    yyparse();

    return 0;
}

int yyerror(char *s) {
    printf("\nERROR: %s\n", s);

    return 0;
}
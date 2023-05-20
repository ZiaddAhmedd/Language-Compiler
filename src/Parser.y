%{
    #include <stdio.h>
	#include <stdlib.h>
	#include <stdarg.h>
	#include <string.h>	
	#include "TableQuad.h"

	int yyerror(char *);
	int yylex(void);
	int yylineno;
	int IDCount=0;
	int QuadCount=0;
	int SCOPE_Number=0;
	int labelCounter=0;
	int elseIfNumber=0;
	int caseCounter=1;
	int switchNumber=0;
	int enumNumber=0;
	int whileNumber=0;
	int repeatUntilNumber=0;
	int forLoopNumber=0;
	int funcLabelCounter=1;
	FILE * outputFile;
	FILE * symbolFile;
	FILE * quadsFile;
	FILE * assemblyFile;
	char * functionName;
	char * finalPath1;
	char * finalPath2;
	char * finalPath3;
	char * finalPath4;
	char * finalPath5;
	void ThrowError(char *Message, char *rVar);							//--  A Function to Terminate the Program and Report an Semantic Error
	void CreateID(int type , char*rName,int rID,int ScopeNum, char* Value, int LineNum);			// -- Create a Symbol given its type and Name 
	void  getIDENTIFIER(char*rName,int ScopeNum);						//--  set Symbol Value to be Initilized. 
	void usedIDENTIFIER(char*rName,int ScopeNum );					    //--  set that Symbol is Used as a RHS in any operation 
	char * concatenateStr(char* str1,char*str2);							//--  a function to conctante two strings 
	bool checktypeIDENTIFER(int LeftType,int RightType);	//--  Check Left and Right hand side in Assigment operation;
	char* idtypeString[10] = { "Integer", "Float", "Char", "String", "Bool", "ConstIntger", "ConstFloat", "ConstChar", "ConstString", "ConstBool" };
	int FuncArgTypes[10];												//Assuming Max 10 arguments 
	int ArgCounter=0;													//Argument Counter
	void CreateFunction(int type , char*rName,int rID,int ScopeNum,int rArgCounter,int *ArrOfTypes); // Create a Symbol For a Function
	bool TempIsUsed=false;
	int TempCounter=0;
	char* SwitchValue;
	char*TempArr[16]={"Temp1","Temp2","Temp3","Temp4","TEMP5","TEMP6","TEMP7","TEMP8","TEMP9","TEMP10","TEMP11","TEMP12","TEMP13","TEMP14","TEMP15","TEMP16"};	
%}
%union{
	int IntegerValue;               /* integer value */
	float FloatValue;               /* float Value */
    char * StringValue;             /* string value */
	char * CharValue;               /* character value */
	char * ID ;                    	/* IDENTIFIER Value */

	int * dum;
	struct TypeAndValue * T_V;

    // int num;
    // char sym;
}



// Keywords
%token IF ELSE WHILE FOR REPEAT UNTIL SWITCH CASE DEFAULT BREAK RETURN ENUM EXIT

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





// Associativity
%left ASSIGN
%left GT LT
%left GEQ LEQ
%left EQ NEQ
%left AND OR NOT
%left ADD SUB 
%left MUL DIV MOD

// Numbers
%token <IntegerValue> INTEGER_NUMBER
%token <FloatValue> FLOATING_POINT_NUMBER 
// Strings
%token <StringValue> STRING_LITERAL 
// Character
%token <CharValue> CHAR_LITERAL 
// Identifiers
%token <ID>     ID

%type <IntegerValue> type   
%type  <dum> stmt unaryExpression function caseExpression caseDefault blockScope manyStatements scopeOpen scopeClose elseIf
%type  <T_V> equalStmt expression DataValues booleanExpression callFunction
// T_V : Type_Value


%%
StartProgram :                  {printf("==========\nEmpty program\n");}    // Check if this works
    | manyStatements
    ;

stmt: type ID ';'     /* %prec IFX  (m7tageen?)*/                           {
																				$$=NULL;
																				CreateID($1,$2,IDCount++,SCOPE_Number, 0, yylineno+1);
																				printf("==========\nDeclaration\n");
																				setQuad(0," "," ",$2,QuadCount++);
																			}
    
    | ID ASSIGN expression ';'                      {
														$$=NULL;
														if(getSymbolType($1)==$3->Type || (getSymbolType($1)-5)==$3->Type)		// -5 is the number of constant types (difference between int and const int is 5)
														{
															getIDENTIFIER($1,SCOPE_Number);
															printf("==========\nAssignment\n");
															if(TempIsUsed)
															{
																setQuad(1,TempArr[TempCounter-1]," ",$1,QuadCount++);	
															}
															
															else
															{
																setQuad(1,$3->Value," ",$1,QuadCount++);
															} 
															TempCounter=0;
															TempIsUsed=false;
														}
														// char* idtypeString[10] = { "Integer", "Float", "Char", "String", "Bool", "ConstIntger", "ConstFloat", "ConstChar", "ConstString", "ConstBool" };
														else if((getSymbolType($1) == 0 && $3->Type == 1))
														{
															getIDENTIFIER($1,SCOPE_Number);
															printf("==========\nAssignment\n");
															if(TempIsUsed)
															{
																setQuad(1,TempArr[TempCounter-1]," ",$1,QuadCount++);	
															}
															
															else
															{
																// converting float to int
																int x = atoi($3->Value);
																char* str = (char*)malloc(sizeof(char)*10);
																sprintf(str, "%d", x);
																setQuad(1,str," ",$1,QuadCount++);
																// setQuad(1,$3->Value," ",$1,QuadCount++);
															} 
															TempCounter=0;
															TempIsUsed=false;
														}
														else if((getSymbolType($1) == 1 && $3->Type == 0))
														{
															getIDENTIFIER($1,SCOPE_Number);
															printf("==========\nAssignment\n");
															if(TempIsUsed)
															{
																setQuad(1,TempArr[TempCounter-1]," ",$1,QuadCount++);	
															}
															
															else
															{
																// convert int to float
																float x = atof($3->Value);
																char* str = (char*)malloc(sizeof(char)*10);
																sprintf(str, "%f", x);
																setQuad(1,str," ",$1,QuadCount++);
																// setQuad(1,$3->Value," ",$1,QuadCount++);
															} 
															TempCounter=0;
															TempIsUsed=false;
														}
														else 
														{
															if(getSymbolType($1)==-1)
															{
															char* str1=concatenateStr($1," Has No Declread Type ");
															ThrowError("",str1);
															}
															char* str1=concatenateStr($1," of Type");
															char* str2=concatenateStr(str1,idtypeString[getSymbolType($1)]);
															ThrowError("Error: incompatible types ",str2);
														}
													}
    
    | type ID ASSIGN expression ';'                 
													{
														$$=NULL;
														CreateID($1,$2,IDCount++,SCOPE_Number, $4->Value, yylineno+1);
														if(checktypeIDENTIFER(getSymbolType($2),$4->Type))
														{
															getIDENTIFIER($2,SCOPE_Number);
															setQuad(0," "," ",$2,QuadCount++);
															if(TempIsUsed)
															{
																setQuad(1,TempArr[TempCounter-1]," ",$2,QuadCount++);			 
															}		
															else
															{
																setQuad(1,$4->Value," ",$2,QuadCount++);
															} 
															printf("==========\nDeclaration and Assignment\n");
															TempCounter=0;
															TempIsUsed=false;
														}
														else if((getSymbolType($2) == 0 && $4->Type == 1))
														{
															getIDENTIFIER($2,SCOPE_Number);
															setQuad(0," "," ",$2,QuadCount++);
															if(TempIsUsed)
															{
																setQuad(1,TempArr[TempCounter-1]," ",$2,QuadCount++);			 
															}		
															else
															{
																// converting float to int
																int x = atoi($4->Value);
																char* str = (char*)malloc(sizeof(char)*10);	
																sprintf(str, "%d", x);
																setQuad(1,str," ",$2,QuadCount++);
																// setQuad(1,$4->Value," ",$2,QuadCount++);
															} 
															printf("==========\nDeclaration and Assignment\n");
															TempCounter=0;
															TempIsUsed=false;
														}
														else if((getSymbolType($2) == 1 && $4->Type == 0))
														{
															getIDENTIFIER($2,SCOPE_Number);
															setQuad(0," "," ",$2,QuadCount++);
															if(TempIsUsed)
															{
																setQuad(1,TempArr[TempCounter-1]," ",$2,QuadCount++);			 
															}		
															else
															{
																// converting int to float
																float x = atof($4->Value);
																char* str = (char*)malloc(sizeof(char)*10);
																sprintf(str, "%f", x);
																setQuad(1,str," ",$2,QuadCount++);
																// setQuad(1,$4->Value," ",$2,QuadCount++);
															} 
															printf("==========\nDeclaration and Assignment\n");
															TempCounter=0;
															TempIsUsed=false;
														}
														else
														{
															char* str1=concatenateStr($2," of Type ");
															char* str2=concatenateStr(str1,idtypeString[getSymbolType($2)]);
															ThrowError("Error: incompatible types ",str2);
														}
													}
    
    | CONST type ID ASSIGN expression ';'         	{
														$$=NULL;
														CreateID($2+5,$3,IDCount++,SCOPE_Number, $5->Value, yylineno+1);				// +5 to make it constant
														if(checktypeIDENTIFER(getSymbolType($3),$5->Type))
														{
															setQuad(0," "," ",$3,QuadCount++);
															if(TempIsUsed)
															{
																printf("TempArr[TempCounter-1]: %s\n",TempArr[TempCounter-1]);
																setQuad(1,TempArr[TempCounter-1]," ",$3,QuadCount++);
															}	
															else
															{
																printf("$5 value: %s\n",$5->Value);
																setQuad(1,$5->Value," ",$3,QuadCount++);
															} 
															printf("==========\nConstant Declaration and Assignment\n");
															TempCounter=0;
															TempIsUsed=false;
														}
														else
														{
															char* str1=concatenateStr($3," of Type ");
															char* str2=concatenateStr(str1,idtypeString[getSymbolType($3)]);
															ThrowError("Error: incompatible types ",str2);
														}
													}

    | WHILE '(' whileQuadruple ')' blockScope           
														{
															$$=NULL;
															char c[3] = {};
															itoa(whileNumber,c,10);
															char m[3]={""};
															char* val=concatenateStr(m,c);
															setQuad(90,val,"","CloseWhile",QuadCount++);		// 90 3ndna hteb2a 3la 7asab el while b kam 3ndna
															printf("==========\nWhile loop\n");
															whileNumber++;
														}   

    | REPEAT repeatQuadruple blockScope UNTIL '(' inRepeatUntil ')'  ';'            
																			{
																				// close repeat with a ; at the end 
																				$$=NULL;
																				printf("==========\nRepeat Until\n");
																				char c[3] = {};
																				itoa(repeatUntilNumber,c,10);
																				char m[3]={""};
																				char* val=concatenateStr(m,c);
																				setQuad(91,val,"","CloseRepeatUntil",QuadCount++);
																				repeatUntilNumber++;
																			}

    | FOR '(' INT create ';' forQuadruple ';' unaryExpression ')' blockScope
																					{
																						$$=NULL;
																						printf("==========\nFor loop\n");
																						char c[3] = {};
																						itoa(forLoopNumber,c,10);
																						char m[3]={""};
																						char* val=concatenateStr(m,c);
																						setQuad(92,val,"","CloseForLoop",QuadCount++);
																						forLoopNumber++;
																					}

    | IF '(' ifQuadruple ')' blockScope  /* %prec IFX (m7tageen?)*/
																		{
																			$$=NULL;
																			printf("==========\nIf statement\n");
																			char c[3] = {};
																			itoa(labelCounter,c,10);
																			char m[3]={""};
																			char* val=concatenateStr(m,c);
																			setQuad(60,"IF","CloseIf",val,QuadCount++);
																			labelCounter++;
																		}

    | IF '(' ifQuadruple ')' blockScope elseIf        
																{
																	$$=NULL;
																	char c[3] = {};
																	itoa(elseIfNumber,c,10);
																	char m[3]={""};
																	char* val=concatenateStr(m,c);
																	printf("==========\nIf else statement\n");
																	setQuad(81,val,"CloseElse","",QuadCount++);
																	elseIfNumber++;
																}

    | SWITCH '(' switchQuadruple ')' switchScope
														{
															$$=NULL;
															char c[3] = {};
															itoa(switchNumber,c,10);
															char m[3]={""};
															char* val=concatenateStr(m,c);
															printf("==========\nSwitch statement\n");
															setQuad(72,val,"ENDSWITCH","",QuadCount++);
															switchNumber++;
														}

    | ENUM ID enumQuadruple '{'  ENUMscope '}' ';'      {
															printf("==========\nEnum statement\n");
															$$=NULL;
															char c[3] = {};
															itoa(enumNumber,c,10);
															char m[3]={""};
															char* val=concatenateStr(m,c);
															setQuad(73,val,"ENDENUM","",QuadCount++);
															enumNumber++;
														}		// hte7tag quadruple
    
    | function
											{
												$$=NULL;
												char c[3] = {};
												itoa(funcLabelCounter,c,10);
												char m[3]={""};
												char* val=concatenateStr(m,c);
												printf("==========\nFunction\n");
												setQuad(101,"ret",val,"",QuadCount++);
												funcLabelCounter++;
											}

    | callFunction                          {
												$$=NULL;
												setQuad(63,"",$1->Value,"FunctionCall",QuadCount++);
												printf("==========\nFunction Call\n");
											}

    | ID ASSIGN callFunction                
											{
												$$=NULL;
												if(checktypeIDENTIFER(getSymbolType($1),$3->Type))
												{
													getIDENTIFIER($1,SCOPE_Number);
													setQuad(63,"",$3->Value,"FunctionCall",QuadCount++);
													printf("==========\nFunction call with assignment\n");}
												else 
												{
													char* str1=concatenateStr($1," of Type");
													char* str2=concatenateStr(str1,idtypeString[getSymbolType($1)]);
													ThrowError("Error: incompatible types ",str2);
												}
											}

    | type ID ASSIGN callFunction           
											{	
												$$=NULL;
												CreateID($1,$2,IDCount++,SCOPE_Number, $4->Value, yylineno+1);
												if(checktypeIDENTIFER(getSymbolType($2),$4->Type))
												{
													getIDENTIFIER($2,SCOPE_Number);
													setQuad(63,"",$4->Value,"FunctionCall",QuadCount++); 
													printf("==========\nFunction call with assignment and type\n");
												}
												else
												{
													char* str1=concatenateStr($2," of Type ");
													char* str2=concatenateStr(str1,idtypeString[getSymbolType($2)]);
													ThrowError("Error: incompatible types ",str2);
												}
											}
    
    | blockScope                            
											{
												$$=NULL;
												printf("==========\nNew block\n");
											}

    | unaryExpression ';'                   {$$=NULL; printf("==========\nUnary expression\n");}
    
	| EXIT	                              	{$$=NULL; printf("==========\nExit\n"); return 0;}

    | ';'                                   {printf("==========\nEmpty statement\n");}
    ;

create : ID ASSIGN expression	{
										// creates a variable and assigns a value to it
										CreateID(0,$1 ,IDCount++,SCOPE_Number+1, $3->Value, yylineno+1);
										getIDENTIFIER($1,SCOPE_Number);
										char c[3] = {};
										sprintf(c,"%d",$3);
										setQuad(1,strdup(c)," ",$1,QuadCount++);
									};     

function :  type ID '(' resetCounter argList ')' '{' scopeOpen {functionName= $2;} funcQuadruple manyStatements RETURN  expression  ';'   '}'  scopeClose  {
                                                                                            
																							$$=NULL;
																							if($1 !=$13->Type) 
																							{
																								ThrowError("Error: incompatible return types of Function ",$2);
																							}
																							else
																							{
																								CreateFunction($1,$2,IDCount++,SCOPE_Number,ArgCounter,FuncArgTypes);
																								printf("==========\nfunction body\n");
																							}
																						}
	| type ID '(' resetCounter argList ')' '{' scopeOpen {functionName= $2;} funcQuadruple RETURN  expression  ';'   '}'  scopeClose  	{
																																			$$=NULL;
																																			if($1 !=$12->Type) 
																																			{
																																				ThrowError("Error: incompatible return types of Function ",$2);
																																			}
																																			else
																																			{
																																				CreateFunction($1,$2,IDCount++,SCOPE_Number,ArgCounter,FuncArgTypes);
																																				printf("function\n");
																																			}
																																		}


    |       VOID ID '(' resetCounter argList ')' '{'  scopeOpen {functionName= $2;} funcQuadruple manyStatements returnCase '}' scopeClose          {
																																						$$=NULL;
																																						CreateFunction(10,$2,IDCount++,SCOPE_Number,ArgCounter,FuncArgTypes);
																																					}
	|       VOID ID '(' resetCounter argList ')' '{'  scopeOpen {functionName= $2;} funcQuadruple returnCase '}' scopeClose							{
																																						$$=NULL;
																																						CreateFunction(10,$2,IDCount++,SCOPE_Number,ArgCounter,FuncArgTypes);
																																					}
    ;


returnCase:
        RETURN ';'    		                    {printf("==========\nempty return\n");}	 
    |                                           {printf("==========\nNo return\n");}	 
    ;
;


callFunction: ID '(' resetCounter callList ')' ';'		{
															printf("==========\nCalling function within scope\n");
															int num =checkArgType(ArgCounter,FuncArgTypes,$1,SCOPE_Number);
															if(num == -404)
															{
																ThrowError("Error: undefined Function With Name ",$1);
															}
															else if(num == 0)
															{
																ThrowError("Error: mismatch argument number of function ",$1);
															}
															else if(num == -1)
															{
																ThrowError("Error: incompatible types of Function ",$1);
															}
															char c[3] = {};
															sprintf(c,"%s",$1);
															$$->Type=getSymbolType($1);
															$$->Value=strdup(c);
														}
		;

																								

callList:   expression ',' callList {
										FuncArgTypes[ArgCounter++]=$1->Type;
										TempCounter=0;
										TempIsUsed=false;//to prevent assignning a temp to a variable
									}
	      |  expression   	{
								FuncArgTypes[ArgCounter++]=$1->Type;
								TempCounter=0;
								TempIsUsed=false;//to prevent assignning a temp to a variable
							}		// the last parameter
		  | 		// in case it doesn't take parameters
	;	

resetCounter: 	{
					ArgCounter=0;
				}
	;

argList:  type ID ',' argList {
											CreateID($1,$2,IDCount++,SCOPE_Number+1, 0, yylineno+1);
											setQuad(0," "," ",$2,QuadCount++);
											FuncArgTypes[ArgCounter++]=$1;// bec the scope is not incremeneted yet
										}
	      | type ID 		    {
											CreateID($1,$2,IDCount++,SCOPE_Number+1, 0, yylineno+1);
											setQuad(0," "," ",$2,QuadCount++);
											FuncArgTypes[ArgCounter++]=$1;// bec the scope is not incremeneted yet
										}
		  |                              
	;

blockScope:	 
            '{' scopeOpen manyStatements '}'  scopeClose			{
																		$$=NULL;
																		printf("==========\nblockScope type 1: many statements\n");
                                            						}
    |       '{' scopeOpen '}'  scopeClose                			{
																		$$=NULL;		
																		printf("==========\nblockScope type 2: empty braces\n");
                                            						}
    ;

ENUMscope:				// hne7tag n3adel fyha 7aga
            ID ASSIGN expression ',' ENUMscope 		{
														// | type ID ASSIGN expression ';'   
														CreateID(5,$1,IDCount++,SCOPE_Number, $3->Value, yylineno+1);		// 5 for const integer
														if(checktypeIDENTIFER(getSymbolType($1),5))
														{
															// getIDENTIFIER($1,SCOPE_Number);
															setQuad(0," "," ",$1,QuadCount++);
															if(TempIsUsed)
															{
																// printf("==========\nTESTING TEMP IS USED\n");
																setQuad(1,TempArr[TempCounter-1]," ",$1,QuadCount++);			 
															}		
															else
															{
																// convert $3 to char *
																
																// printf("test = %d\n", $3);
																// char str1[10];
																// sprintf(str1, "%d", $3);
																// printf("myString = %s\n", str1);

																setQuad(1,$3->Value," ",$1,QuadCount++);
															} 
															// printf("==========\nDeclaration and Assignment\n");
															TempCounter=0;
															TempIsUsed=false;
														}
														else
														{
															char* str1=concatenateStr($1," of Type ");
															char* str2=concatenateStr(str1,idtypeString[getSymbolType($1)]);
															ThrowError("Error: incompatible types ",str2);
														}
												
                                                printf("==========\nENUMscope type 1: has comma\n");
                                            }
    |       ID ASSIGN expression        {
														CreateID(5,$1,IDCount++,SCOPE_Number, $3->Value, yylineno+1);		// 5 for const integer
														if(checktypeIDENTIFER(getSymbolType($1),5))
														{
															// getIDENTIFIER($1,SCOPE_Number);
															setQuad(0," "," ",$1,QuadCount++);
															if(TempIsUsed)
															{
																// printf("==========\nTESTING TEMP IS USED\n");
																setQuad(1,TempArr[TempCounter-1]," ",$1,QuadCount++);			 
															}		
															else
															{
																// convert $3 to char *
																
																// printf("test = %d\n", $3);
																// char str1[10];
																// sprintf(str1, "%d", $3);
																// printf("myString = %s\n", str1);

																setQuad(1,$3->Value," ",$1,QuadCount++);
															} 
															// printf("==========\nDeclaration and Assignment\n");
															TempCounter=0;
															TempIsUsed=false;
														}
														else
														{
															char* str1=concatenateStr($1," of Type ");
															char* str2=concatenateStr(str1,idtypeString[getSymbolType($1)]);
															ThrowError("Error: incompatible types ",str2);
														}
                                                printf("==========\nENUMscope type 2: last element (no comma)\n");
                                            }
    ;

switchScope:  '{' scopeOpen caseExpression '}'	scopeClose		{
                                                    printf("==========\nSwitch Case block\n");
                                                }
    ;

scopeOpen :	{
				$$=NULL;
				SCOPE_Number++;
			}

scopeClose :{
				$$=NULL;
				DeadSymbols(SCOPE_Number);		// lazy delete
				SCOPE_Number--;
			}		

manyStatements: 
            stmt {$$=$1;}
    
    |       manyStatements stmt {$$=NULL;}
    ;

type:   INT {$$=0;}
	| FLOAT {$$=1;}
	| CHAR  {$$=2;}
	| STRING{$$=3;}
	| BOOL	{$$=4;}
	;

/* funcType:   type
    |       VOID    {}
    ; */

equalStmt:   FLOATING_POINT_NUMBER                  {
														$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
														$$->Type=1;				
														char c[3] = {};
														sprintf(c,"%f",$1);
														$$->Value=strdup(c);	
														
											   		}
		| INTEGER_NUMBER		                    {
														$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
														$$->Type=0;					
														char c[3] = {}; 
														sprintf(c,"%d",$1);
														$$->Value=strdup(c);
														
											   		}
		| ID                           				{
														$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
														$$->Type=getSymbolType($1);
														$$->Value=$1;
														usedIDENTIFIER($1,SCOPE_Number);
														
											   		}
		| equalStmt ADD	equalStmt        			{
														if($1->Type==$3->Type)
														{
															$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
															$$->Type=$1->Type; 
															$$->Value=TempArr[TempCounter];
															setQuad(10,$1->Value,$3->Value,TempArr[TempCounter++],QuadCount++);
															TempIsUsed=true;
														}
														else 
														{
															ThrowError("Conflict dataTypes in Addition \n "," ");			
														}
														
													}
		| equalStmt SUB equalStmt        		{
														if($1->Type==$3->Type)
														{
															$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
															$$->Type=$1->Type;
															$$->Value=TempArr[TempCounter];
															setQuad(11,$1->Value,$3->Value,TempArr[TempCounter++],QuadCount++); 
															TempIsUsed=true;
														
														}
														else
														{
															ThrowError("Conflict dataTypes in Subtraction \n "," ");
														}			
													}
		| equalStmt MUL equalStmt     		{
														if($1->Type==$3->Type)
														{
															$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
															$$->Type=$1->Type;
															$$->Value=TempArr[TempCounter];
															setQuad(12,$1->Value,$3->Value,TempArr[TempCounter++],QuadCount++);
															TempIsUsed=true;
														
														}
														else
														{
															ThrowError("Conflict dataTypes in Multiply \n "," ");
														}			
													}
		| equalStmt  DIV	equalStmt    		{
														if($1->Type==$3->Type)
														{
															if(!($3->Value))ThrowError("Error Dividing by Zero  \n "," ");
															$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
															$$->Type=$1->Type;
															$$->Value=TempArr[TempCounter];
															setQuad(13,$1->Value,$3->Value,TempArr[TempCounter++],QuadCount++);
															TempIsUsed=true;
														}
														else
														{
															ThrowError("Conflict dataTypes in Multiply \n "," ");
														} 						
													}
		| equalStmt  MOD	equalStmt       		{
															if($1->Type==$3->Type)
														{
															$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
															$$->Type=$1->Type;
															$$->Value=TempArr[TempCounter];
															setQuad(14,$1->Value,$3->Value,TempArr[TempCounter++],QuadCount++);
															TempIsUsed=true;
														
														}
														else
														{
															ThrowError("Conflict dataTypes in Reminder \n "," ");
														} 						
													}
		
		| ID INC                       	{
											usedIDENTIFIER($1,SCOPE_Number);
											setQuad(15,"INC","INC",$1,QuadCount++);
											$$->Type=getSymbolType($1);
											$$->Value=$1;
										}

		| ID DEC                       	{
											usedIDENTIFIER($1,SCOPE_Number);
											setQuad(16,"DEC","DEC",$1,QuadCount++);
											$$->Type=getSymbolType($1);
											$$->Value=$1;
										}

		| '(' equalStmt ')'      		{
											$$=$2;
										}
		;

unaryExpression : ID INC        {
									$$=NULL;
									usedIDENTIFIER($1,SCOPE_Number);
									setQuad(15,"INC","INC",$1,QuadCount++);
								}   // i++ or i-- for example
    |           ID DEC          {
									$$=NULL;
									usedIDENTIFIER($1,SCOPE_Number);
									setQuad(16,"DEC","DEC",$1,QuadCount++);
								}
    ;


booleanExpression: expression AND expression          	{
															$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
															$$->Type=$1->Type; 
															$$->Value=TempArr[TempCounter];
															setQuad(25,$1->Value,$3->Value,TempArr[TempCounter++],QuadCount++); 
															TempIsUsed=true;
														}
															
			| expression OR expression             		{
													
															$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
															$$->Type=$1->Type;
															$$->Value=TempArr[TempCounter]; 
															setQuad(26,$1->Value,$3->Value,TempArr[TempCounter++],QuadCount++);
															TempIsUsed=true;

														} 
			| NOT expression                        	{
															$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
															$$->Type=$2->Type;
															$$->Value=TempArr[TempCounter]; 
															setQuad(27,$2->Value," ",TempArr[TempCounter++],QuadCount++); 
															TempIsUsed=true; 
														}

			| DataValues GT DataValues         	{
															if(!checktypeIDENTIFER($1->Type, $3->Type)) 
															{
																ThrowError("Conflict Data types in GREATERTHAN Operation \n "," ");
															}
															else	
															{
																// char* idtypeString[10] = { "Integer", "Float", "Char", "String", "Bool", "ConstIntger", "ConstFloat", "ConstChar", "ConstString", "ConstBool" };|
																// printf("Type1 : %d Type2 : %d \n", $1->Type, $3->Type);
																// printf("Value1: %s Value2: %s \n", $1->Value, $3->Value);
																// printf("1: %d, 2: %d \n", $1, $3);
																// printf("atoi($1->Value) : %d, atoi($3->Value) : %d \n", atoi($1->Value), atoi($3->Value));
																if (atoi($1->Value)<=atoi($3->Value) &&  $1->Type < 5 && $3->Type < 5 && atoi($1->Value) != 0 && atoi($3->Value) != 0)
																{
																	printf("Warning : Condition is always false.\n");
																}
																
																$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
																$$->Type=$1->Type;
																$$->Value=TempArr[TempCounter];
																setQuad(28,$1->Value,$3->Value,TempArr[TempCounter++],QuadCount++); 
																TempIsUsed=true;
															}
														}
			| DataValues LT DataValues            	{
															if(!checktypeIDENTIFER($1->Type, $3->Type)) 
															{
																ThrowError("Conflict Data types in LESSTHAN Operation \n "," ");
															}
															else	 
															{
																if (atoi($1->Value)>=atoi($3->Value) &&  $1->Type < 5 && $3->Type < 5 && atoi($1->Value) != 0 && atoi($3->Value) != 0)
																{
																	printf("Warning : Condition is always false.\n");
																}
																$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
																$$->Type=$1->Type;
																$$->Value=TempArr[TempCounter];
																setQuad(29,$1->Value,$3->Value,TempArr[TempCounter++],QuadCount++);
																TempIsUsed=true;
															}
														}
			| DataValues GEQ DataValues  	{
															if(!checktypeIDENTIFER($1->Type, $3->Type)) 
															{
																ThrowError("Conflict Data types in GREATERTHANOREQUAL Operation \n "," "); 
															}
															else	
															{
																if (atoi($1->Value)<atoi($3->Value) &&  $1->Type < 5 && $3->Type < 5 && atoi($1->Value) != 0 && atoi($3->Value) != 0)
																{
																	printf("Warning : Condition is always false.\n");
																}
																$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
																$$->Type=$1->Type;
																$$->Value=TempArr[TempCounter]; 
																setQuad(30,$1->Value,$3->Value,TempArr[TempCounter++],QuadCount++); 
																TempIsUsed=true;
															}
														}
			| DataValues LEQ DataValues     	{
															if(!checktypeIDENTIFER($1->Type, $3->Type)) 
															{
																ThrowError("Conflict Data types in LESSTHANOREQUAL Operation \n "," ");
															}
															else	 
															{
																if (atoi($1->Value)>atoi($3->Value) &&  $1->Type < 5 && $3->Type < 5 && atoi($1->Value) != 0 && atoi($3->Value) != 0)
																{
																	printf("Warning : Condition is always false.\n");
																}
																$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
																$$->Type=$1->Type; 
																$$->Value=TempArr[TempCounter];
																setQuad(31,$1->Value,$3->Value,TempArr[TempCounter++],QuadCount++); 
																TempIsUsed=true;
															}
														}
			| DataValues NEQ DataValues              {
															if(!checktypeIDENTIFER($1->Type, $3->Type)) 
															{
																ThrowError("Conflict Data types in NOTEQUAL Operation \n "," ");
															}
															else	 
															{
																if (strcmp($1->Value, $3->Value) == 0 &&  $1->Type < 5 && $3->Type < 5 && atoi($1->Value) != 0 && atoi($3->Value) != 0)
																{
																	printf("Warning : Condition is always false.\n");
																}

																$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
																$$->Type=$1->Type;
																$$->Value=TempArr[TempCounter]; 
																setQuad(32,$1->Value,$3->Value,TempArr[TempCounter++],QuadCount++);
																TempIsUsed=true;
															}
														}
			| DataValues EQ DataValues            {
															if(!checktypeIDENTIFER($1->Type, $3->Type)) 
															{
																ThrowError("Conflict Data types in EQUALEQUAL Operation \n "," ");
															}
															else	 
															{
																if (strcmp($1->Value, $3->Value) != 0 &&  $1->Type < 5 && $3->Type < 5 && atoi($1->Value) != 0 && atoi($3->Value) != 0)
																{
																	printf("Warning : Condition is always false.\n");
																}
															
																$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
																$$->Type=$1->Type; 
																$$->Value=TempArr[TempCounter];
																setQuad(33,$1->Value,$3->Value,TempArr[TempCounter++],QuadCount++);
																TempIsUsed=true;
															}
														}
			| '(' booleanExpression ')'         {
														$$=$2;
                                                }
			;

DataValues:
            equalStmt					{$$=$1;}
		| CHAR_LITERAL 					{
											$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
											$$->Type=2;					
											$$->Value=strdup($1);
										}
		| BOOL_FALSE 					{
											$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
											$$->Type=4;					
											$$->Value=strdup("FALSE");
										}
	    | BOOL_TRUE						{
											$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
											$$->Type=4;					
											$$->Value=strdup("TRUE");
										}
		| STRING_LITERAL 				{
											$$=(struct TypeAndValue*) malloc(sizeof(struct TypeAndValue));
											$$->Type=3;					
											$$->Value=strdup($1);
										}
		;

expression:	DataValues{$$=$1;}
		| booleanExpression{$$=$1;}
		;

caseExpression:	
            caseDefault 	                   
    |       CASE INTEGER_NUMBER ':'		{char c[3] = {}; sprintf(c,"%d",$2); setQuad(70,strdup(c),"",SwitchValue,QuadCount++);} {char c2[3] = {}; itoa(caseCounter,c2,10); char m[3]={""}; char* val=concatenateStr(m,c2);setQuad(70,"caseSecondTime",val,SwitchValue,QuadCount++);}
	 		manyStatements BREAK ';' 	{char c[3] = {}; itoa(switchNumber,c,10); char m[3]={""}; char* val=concatenateStr(m,c);char c2[3] = {}; itoa(caseCounter,c2,10); char m2[3]={""}; char* val2=concatenateStr(m2,c2);setQuad(70,"caseThirdTime",val2,val,QuadCount++);caseCounter++;}
			caseExpression  			{$$=NULL; printf("==========\nCase Statment\n");}
		      ;


caseDefault:
            DEFAULT ':'     		     {char c[3] = {}; itoa(switchNumber,c,10); char m[3]={""}; char* val=concatenateStr(m,c); setQuad(71,val,"","DefaultCase",QuadCount++);}
			manyStatements 				{$$=NULL;printf("Default case statment\n");}

    |                                                            {printf("==========\nNon-default case Statment\n");}	 
              ;
    ;

whileQuadruple: {char c[3] = {};sprintf(c,"%d",SCOPE_Number); char c2[3] = {}; itoa(whileNumber,c,10); char m[3]={""}; char* val=concatenateStr(m,c); setQuad(20,strdup(c),val,"OpenWhile1",QuadCount++);} 
		expression {char c[3] = {};sprintf(c,"%d",SCOPE_Number); char c2[3] = {}; itoa(whileNumber,c,10); char m[3]={""}; char* val=concatenateStr(m,c); setQuad(20,strdup(c),val,"OpenWhile2",QuadCount++);TempCounter=0;TempIsUsed=false;}//to prevent assignning a temp to a variable
		;

repeatQuadruple: {char c[3] = {};sprintf(c,"%d",SCOPE_Number); char c2[3] = {}; itoa(repeatUntilNumber,c,10); char m[3]={""}; char* val=concatenateStr(m,c); setQuad(22,strdup(c),val,"OpenrepeatUntil",QuadCount++);}
		;

inRepeatUntil: expression {TempCounter=0;TempIsUsed=false;}//to prevent assignning a temp to a variable
		;

enumQuadruple: {char c[3] = {};sprintf(c,"%d",SCOPE_Number); char c2[3] = {}; itoa(enumNumber,c,10); char m[3]={""}; char* val=concatenateStr(m,c); setQuad(23,strdup(c),val,"OpenEnum",QuadCount++);}
		;

forQuadruple: {char c[3] = {};sprintf(c,"%d",SCOPE_Number); char c2[3] = {}; itoa(forLoopNumber,c2,10); char m[3]={""}; char* val=concatenateStr(m,c2); setQuad(21,strdup(c),val,"OpenForLoop1",QuadCount++);} expression {char c[3] = {};sprintf(c,"%d",SCOPE_Number);char c2[3] = {}; itoa(forLoopNumber,c2,10); char m[3]={""}; char* val=concatenateStr(m,c2); setQuad(21,strdup(c),val,"OpenForLoop2",QuadCount++);TempCounter=0;TempIsUsed=false;}//to prevent assignning a temp to a variable
		;

funcQuadruple: {char c[3] = {};sprintf(c,"%d",SCOPE_Number);char c2[3] = {}; itoa(funcLabelCounter,c2,10); char m[3]={""}; char* val=concatenateStr(m,c2);setQuad(100,strdup(c),val,functionName,QuadCount++);}
		;

switchQuadruple: ID {SwitchValue=strdup($1);setQuad(61,"SwitchStart","",$1,QuadCount++);usedIDENTIFIER($1,SCOPE_Number);}
		;

ifQuadruple: expression {
							char c[3] = {};
							itoa(labelCounter,c,10);
							char m[3]={""};
							char* val=concatenateStr(m,c);
							setQuad(60,"IF ","OpenIf",val,QuadCount++);
							TempCounter=0;
							TempIsUsed=false;		//to prevent assignning a temp to a variable
						}		
		;

elseIfQuadruple: {char c[3] = {}; itoa(labelCounter,c,10); char m[3]={""}; char* val=concatenateStr(m,c); char c2[3] = {}; itoa(elseIfNumber,c2,10); char m2[3]={""}; char* val2=concatenateStr(m2,c2); setQuad(60,val2,"OpenElseIf1",val,QuadCount++);} expression {labelCounter++;char c[3] = {}; itoa(labelCounter,c,10); char m[3]={""}; char* val=concatenateStr(m,c); setQuad(60,"IF ","OpenElseIf2",val,QuadCount++);TempCounter=0;TempIsUsed=false;}//to prevent assignning a temp to a variable
			;
elseQuadruple: {char c[3] = {}; itoa(labelCounter,c,10); char m[3]={""}; char* val=concatenateStr(m,c); char c2[3] = {}; itoa(elseIfNumber,c2,10); char m2[3]={""}; char* val2=concatenateStr(m2,c2); setQuad(80,"else",val2,val,QuadCount++);labelCounter++;} blockScope
			;
elseIf: ELSE IF '(' elseIfQuadruple ')' blockScope elseIf	{$$=NULL;}
			| ELSE  elseQuadruple	{$$=NULL;}
			;
		   

%%

void CreateID(int type , char*rName,int rID,int ScopeNum, char* Value, int LineNum)
{
	if(CheckIDENTIFYER(rName, ScopeNum))
	{
		ThrowError("Already Declared IDENTIFIER with Name ",rName);
	}
	else
	{
		bool isConstant=(type>4)?true:false;
		SymbolData* rSymbol=setSymbol(type,0,false,rName,!isConstant,ScopeNum, Value, LineNum);
		/* printf("int type is %d \n",type);
		printf("char* rName is %s \n",rName);
		printf("int rID is %d \n",rID);
		printf("int ScopeNum is %d \n",ScopeNum); */
		
		if(isConstant)
		{
			rSymbol->Initilzation=true;
			pushSymbol(rID,rSymbol);
			printf("Constant Symbol is created with Name %s \n",rName);	
		}
		else 
		{
			pushSymbol(rID,rSymbol);
			printf("Symbol is created with Name %s \n",rName);
		}
	}
}
void CreateFunction(int type , char*rName,int rID,int ScopeNum,int rArgCounter,int *ArrOfTypes)
{
	if(CheckIDENTIFYER(rName, ScopeNum))
	{
		ThrowError("Already Declared IDENTIFIER with Name ",rName);
	}
	else
	{
		if(type==10)
		{
			SymbolData* rSymbol=setSymbol(type,0,false,rName,true,ScopeNum, 0, yylineno+1);
			setFuncArg(rArgCounter,ArrOfTypes,rSymbol);
			pushSymbol(rID,rSymbol);
			printf("Symbol Function is created with Name %s \n",rName);
		}
		else
		{
			bool isConstant=(type>4)?true:false;// There is something called a constant function
			SymbolData* rSymbol=setSymbol(type,0,false,rName,!isConstant,ScopeNum, 0, yylineno+1);
			if(isConstant)
			{
				rSymbol->Initilzation=true;
				setFuncArg(rArgCounter,ArrOfTypes,rSymbol);
				pushSymbol(rID,rSymbol);
				printf("Constant Symbol Function is created with Name %s \n",rName);	
			}
			else 
			{
				setFuncArg(rArgCounter,ArrOfTypes,rSymbol);
				pushSymbol(rID,rSymbol);
				printf("Symbol Function is created with Name %s \n",rName);
			}
		}
	}
}
void getIDENTIFIER(char*rName,int ScopeNum)
{
	SymbolNode * rSymbol=getID(rName, ScopeNum);
	if(!rSymbol)
	{
		ThrowError("Not Declared in This Scope Identifier with Name \n ",rName);
	}
	else
	{
		if(!rSymbol->DATA->Modifiable)
		{
			ThrowError("Can't Modify a Constant Identifier with Name \n ",rName);
		}
			
		else
		{
			rSymbol->DATA->Initilzation=true;
		}		
	}
}
void usedIDENTIFIER(char*rName,int ScopeNum)
{
	SymbolNode * rSymbol=getID(rName, ScopeNum);
	if(!rSymbol)
	{
		ThrowError("Not Declared in This Scope Identifier with Name \n ",rName);
	}
	else
	{
		printf("IDENTIFIER with Name %s is Used \n",rName);
		if(!rSymbol->DATA->Initilzation)
		{
			printf("Warning :IDENTIFIER with Name %s is not Initialized and is being used.  \n",rName);// don't quit, just a warning
		}
		rSymbol->DATA->Used=true;
	}
}
bool checktypeIDENTIFER(int LeftType,int RightType)
{
	return ((LeftType==RightType) || (LeftType-5 ==RightType) || (LeftType == RightType-5))?true:false; // Checking both constants types and types 
	

}
void ThrowError(char *Message, char *rVar)
{
	fprintf(outputFile, "Error, could not parse quadruples\n");
 	fprintf(outputFile, "line number: %d, %s : %s\n", yylineno+1,Message,rVar);
	printf("line number: %d, %s : %s\n", yylineno+1,Message,rVar);
	fprintf(symbolFile, "Table was emptied as the program has compilation errors\n");
 	fprintf(symbolFile, "line number: %d, %s : %s\n", yylineno+1,Message,rVar);
 	exit(0);
}




int yyerror(char *s) {
	fprintf(stderr, "line number : %d, %s\n", yylineno+1, s);
    /* printf("\nerror in line: %d, ERROR: %s\n", yylineno+1, s); */

    return 0;
}

char * concatenateStr(char* str1,char*str2)
{  
	char * str3 = (char *) malloc(1 + strlen(str1)+ strlen(str2) );
	strcpy(str3, str1);	  
	strcat(str3, str2);
	return str3;
}

int main(int argc, char *argv[]) {
	char *path = argv[1];
	/* printf("path: %s\n",path); */
	char* finalPath1 = concatenateStr(path,".\\Outputs\\output.txt");
	char* finalPath2 = concatenateStr(path,".\\Outputs\\Quadruples.txt");
	/* char* finalPath3 = concatenateStr(path,".\\Outputs\\Assembly.txt"); */
	char* finalPath4 = concatenateStr(path,".\\Outputs\\Symbol.txt");
	outputFile=fopen(finalPath1,"w");
	quadsFile=fopen(finalPath2,"w");
	/* assemblyFile=fopen(finalPath3,"w"); */
	symbolFile=fopen(finalPath4,"w");
	if(!yyparse()) 
	{
		printf("\nParsing complete\n");
		WriteSymbolTable(symbolFile);
		DestroySymbolsList();
		WriteQuads(quadsFile);
		QuadNode*R=getTOP();
		/* AssemblyGenerator(R,assemblyFile); */
		fprintf(outputFile,"No errors occurred");
		DestroyQuadsList();
		fclose(outputFile);
		fclose(quadsFile);
		/* fclose(assemblyFile); */
		fclose(symbolFile);
		return 0;
	}
	else 
	{
		fclose(outputFile);
		fclose(quadsFile);
		/* fclose(assemblyFile); */
		fclose(symbolFile);
		printf("\nParsing failed, error in line number:  %d\n",yylineno+1);
		return 0;
	}
    return 0;
}
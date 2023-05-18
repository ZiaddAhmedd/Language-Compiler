#include"TableQuad.h"


char* idtype[11] = { "Integer", "Float", "Char", "String", "Bool", "ConstIntger", "ConstFloat", "ConstChar", "ConstString", "ConstBool","void" };
struct SymbolNode * ListTop = NULL;
struct SymbolData* setSymbol(int rType, int rValue, bool rUsed,char* Identifier,bool rModifiable,int ScopeNum)
{
    // basically a constructor
	struct SymbolData *data = (struct SymbolData*) malloc(sizeof(struct SymbolData));
	data->Type = rType;                         // type of the variable from our defines
	data->Initilzation = rValue;                // initial value
	data->Used = rUsed;                         // used or not
	data->IdentifierName = Identifier;          // name of the variable
	data->Modifiable=rModifiable;               // constant = not modifiable, otherwise modifiable
	data->BracesScope = ScopeNum;               // The scope to which it belongs (where it is declared)
	data->IsFunctionSymbol = false;             // initially assume nothing is a function (can be modified later in another function (setFuncArg))
	
	return data;
}

void pushSymbol(int index, struct SymbolData *data) {
	// Insert from Begining in the linked list
    // This makes checking the variable faster, as we start from the innermost scope
	struct SymbolNode *mySymbolNode = (struct SymbolNode*) malloc(sizeof(struct SymbolNode));
	mySymbolNode->ID = index;
	mySymbolNode->DATA = data;
	mySymbolNode->Next = ListTop;
	ListTop = mySymbolNode;
}


// SymbolData * getSymbol(int rID)
// {
//     // rID: the identifier name
//     // returns the closest (last defined) variable's data
// 	int mCount = 0;
// 	SymbolNode * Walker = ListTop;
// 	while (Walker)
// 	{
// 		if (Walker->ID == rID)
// 		{
// 			return Walker->DATA;
// 		}
// 	}
// 	return NULL;
// }


SymbolNode *  getID(char * Identifiyer, int rBraceSCope)
{
    // identifiyer: act as the variable (x from int x for example)
    // rBraceScope: the scope number where it is declared
    // returns the node itself (the node contains the data)
	SymbolNode * Walker = ListTop;
	//start from the beginning

	while (Walker)
	{
		if ((strcmp(Identifiyer, Walker->DATA->IdentifierName)==0 ) && (Walker->DATA->BracesScope !=-1 ) )//means dead symbol 
		{
			return Walker;
		}

		Walker = Walker->Next;
	}

	return NULL;
}

bool CheckIDENTIFYER(char * ID)
{
    // Checks that no two identifiers have the same name, in the same scope
	SymbolNode * Walker = ListTop;

    // Test_Check: {int x; {int y; int x;}} el mfrood mydeesh error, bs hal hyedy? 
	//start from the beginning
	while (Walker)
	{
		if ((strcmp(ID, Walker->DATA->IdentifierName) == 0) && !(Walker->DATA->BracesScope==-1))
		{
            // BracesScope is placed = -1 when closing a scope (lazy delete)
            // so if not = -1, then we are still in the same scope
			return true;        // invalid
		}

		Walker = Walker->Next;
	}

	return false;       // valid

}

void WriteSymbolTable(FILE*F)
{
	WriteUsed(F);
	WriteNotUsed(F);
	WriteInitilized(F);
	WriteNotInit(F);
}

int getSymbolType(char * rID)
{
    // return type of identifier
	SymbolNode * Walker = ListTop;
	while (Walker)
	{
		if (strcmp(rID, Walker->DATA->IdentifierName) == 0)
		{
			return Walker->DATA->Type;
		}

		Walker = Walker->Next;
	}
	return -1;

}

void setFuncArg(int ArgCount, int * ArgTypes, SymbolData * rD)
{
    // ArgCount: count of arguments
    // ArgTypes: array containing argument types
	rD->ArrTypes = (int *)malloc(sizeof(int)*ArgCount);
	int i;
	for (i = 0; i < ArgCount; i++)
	{
		rD->ArrTypes[i] = ArgTypes[i];
	}
	rD->IsFunctionSymbol = true;
	rD->ArgNum = ArgCount;

}

int checkArgType(int ArgCount, int * ArgTypes, char * rString,int Scope)
{
    // rstring: name of the function
    
    // check each type is valid
	SymbolNode * rD = getID(rString,Scope);
	if (rD == NULL) return -404;     // no Decleared Function with this Name

	if (rD->DATA->ArgNum!= ArgCount)
		return 0;   //error indicates misArgumentsCount
	
    int i;
	for (i = 0; i < ArgCount; i++)
	{
		if (rD->DATA->ArrTypes[i] != ArgTypes[i])
			return -1;      // MisMatchArg
	}
	
    return 1;       //Accepted		
}

void DeadSymbols(int Brace)
{
	SymbolNode * Walker = ListTop;
	while (Walker)
	{
		if  (Walker->DATA->BracesScope == Brace)
		{
			Walker->DATA->BracesScope = -1;
		}

		Walker = Walker->Next;
	}
}

void DestroySymbolsList()
{
    // for memory optimization
	SymbolNode * Walker = ListTop;

	while (Walker)
	{
		SymbolNode *rD = Walker;
		Walker = Walker->Next;
		free (rD);

	}
}

void WriteUsed(FILE *f)
{
	SymbolNode * Walker = ListTop;
	fprintf(f, "Used Identifiers :- \n");
	while (Walker)
	{
		if (Walker->DATA->Used)
		{
			fprintf(f, "%s of type %s\n", Walker->DATA->IdentifierName, idtype[Walker->DATA->Type]);
		}
		Walker = Walker->Next;
	}

	fprintf(f, "\n");
}

void WriteNotUsed(FILE *f)
{
	SymbolNode * Walker = ListTop;
	fprintf(f, "UnUsed Identifiers :- \n");
	while (Walker)
	{
		if (!(Walker->DATA->Used))
		{
			fprintf(f, "%s of type %s\n", Walker->DATA->IdentifierName, idtype[Walker->DATA->Type]);
		}
		Walker = Walker->Next;
	}

	fprintf(f, "\n");
}

void WriteInitilized(FILE *f)
{
	SymbolNode * Walker = ListTop;
	fprintf(f, "Initilized Identifiers :- \n");
	while (Walker)
	{
		if (Walker->DATA->Initilzation)
		{
			fprintf(f, "%s of type %s\n", Walker->DATA->IdentifierName, idtype[Walker->DATA->Type]);
		}
		Walker = Walker->Next;
	}

	fprintf(f, "\n");
}

void WriteNotInit(FILE *f)
{
	SymbolNode * Walker = ListTop;
	fprintf(f, "UnInitilized Identifiers :- \n");
	while (Walker)
	{
		if (!(Walker->DATA->Initilzation))
		{
			fprintf(f, "%s of type %s\n", Walker->DATA->IdentifierName, idtype[Walker->DATA->Type]);
		}
		Walker = Walker->Next;
	}

	fprintf(f, "\n");
}

//---------------------------------------Quadruples------------------------
QuadNode*TopPtr = NULL;

void setQuad(int Op, char* Arg1, char* Arg2,char*Result,int rID)
{
	struct QuadData *data = (struct QuadData*) malloc(sizeof(struct QuadData));
	data->OpCode = Op;
	data->Arg1 = Arg1;
	data->Arg2 = Arg2;
	data->Result = Result;
	InsertQuadruple(data, rID); 
	return ;
}

void InsertQuadruple(QuadData*rD, int ID)
{
	if (!TopPtr)
	{
	struct QuadNode *myQuadlNode = (struct QuadNode*) malloc(sizeof(struct QuadNode));
	TopPtr = myQuadlNode;
	myQuadlNode->ID = ID;
	myQuadlNode->DATA = rD;
	TopPtr->Next = NULL;
	return;
	}
	struct QuadNode *Walker = TopPtr;
	while (Walker->Next)
		Walker = Walker->Next;// get the last node
	struct QuadNode *myQuadlNode = (struct QuadNode*) malloc(sizeof(struct QuadNode));
	myQuadlNode->ID = ID;
	myQuadlNode->DATA = rD;
	myQuadlNode->Next = NULL;
	Walker->Next = myQuadlNode; // insert ath the end
}

void WriteQuads(FILE * f)
{
	struct QuadNode *Walker = TopPtr;
	while (Walker)
	{
		fprintf(f, " OpCode: %d  Arg1: %s  Arg2: %s Result: %s \n", Walker->DATA->OpCode, Walker->DATA->Arg1, Walker->DATA->Arg2, Walker->DATA->Result);
		Walker = Walker->Next;
	}
}

QuadNode*getTOP()
{
	return TopPtr;
}

Reg CheckReg();
void SetReg(Reg x);
void ResetReg();
Reg reg[7];

void AssemblyGenerator(QuadNode* head,FILE *f)
{
	QuadNode*ptr = head;
	ResetReg();
	Reg free;
	Reg Aux;

	while (ptr != NULL)
	{
		switch (ptr->DATA->OpCode)
		{
		case DECLARE_:
			free = CheckReg();
			if (ptr->DATA->Arg1 == " " && ptr->DATA->Arg2 == " ")
			{
				fprintf(f, "MOV %s , %s \n", free.reg,"NULL");
				fprintf(f, "MOV %s , %s \n", ptr->DATA->Result,free.reg);
			}
			else if (ptr->DATA->Arg1 != " ") 
			{
				fprintf(f, "MOV %s , %s \n", free.reg,ptr->DATA->Arg1);
				fprintf(f, "MOV %s , %s \n", ptr->DATA->Result, free.reg);
			}
			else if (ptr->DATA->Arg2 != " ") 
			{
				fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Arg2);
				fprintf(f, "MOV %s , %s \n", ptr->DATA->Result, free.reg);
			}
			free.used++;
			free.var = ptr->DATA->Result;
			SetReg(free);
			ptr = ptr->Next;
			break;
		case ASSIGN_:
			free = CheckReg();
			if (ptr->DATA->Arg1 != " ") {
				fprintf(f, "MOV %s , %s \n", free.reg,ptr->DATA->Arg1);
				fprintf(f, "MOV %s , %s \n", ptr->DATA->Result, free.reg);
			}
			else if (ptr->DATA->Arg2 != " ") {
				fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Arg2);
				fprintf(f, "MOV %s , %s \n", ptr->DATA->Result, free.reg);
			}
			free.used++;
			free.var = ptr->DATA->Result;
			SetReg(free);
			ptr = ptr->Next;
			break;
		case ADD_:
			free = CheckReg();
			Aux = free;
			fprintf(f, "MOV %s , %s \n", Aux.reg, ptr->DATA->Arg1);
			Aux.used++;
			Aux.var = ptr->DATA->Arg1;
			SetReg(Aux);
			free = CheckReg();
			fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Arg2);
			free.used++;
			free.var = ptr->DATA->Arg2;
			SetReg(free);
			fprintf(f, "ADD %s , %s , %s\n", ptr->DATA->Result,Aux.reg, free.reg);
			ptr = ptr->Next;
			break;
		case MINUS_:
			free = CheckReg();
			Aux = free;
			fprintf(f, "MOV %s , %s \n", Aux.reg, ptr->DATA->Arg1);
			Aux.used++;
			Aux.var = ptr->DATA->Arg1;
			SetReg(Aux);
			free = CheckReg();
			fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Arg2);
			free.used++;
			free.var = ptr->DATA->Arg2;
			SetReg(free);
			fprintf(f, "SUB %s , %s , %s\n", ptr->DATA->Result,Aux.reg, free.reg);
			ptr = ptr->Next;
			break;
		case MULTIPLY_:
			free = CheckReg();
			Aux = free;
			fprintf(f, "MOV %s , %s \n", Aux.reg, ptr->DATA->Arg1);
			Aux.used++;
			Aux.var = ptr->DATA->Arg1;
			SetReg(Aux);
			free = CheckReg();
			fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Arg2);
			free.used++;
			free.var = ptr->DATA->Arg2;
			SetReg(free);
			fprintf(f, "IMUL %s , %s , %s\n", ptr->DATA->Result,Aux.reg, free.reg);
			ptr = ptr->Next;
			break;
		case DIVIDE_:
			free = CheckReg();
			Aux = free;
			fprintf(f, "MOV %s , %s \n", Aux.reg, ptr->DATA->Arg1);
			Aux.used++;
			Aux.var = ptr->DATA->Arg1;
			SetReg(Aux);
			free = CheckReg();
			fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Arg2);
			free.used++;
			free.var = ptr->DATA->Arg2;
			SetReg(free);
			fprintf(f, "DIV %s , %s , %s\n", ptr->DATA->Result,Aux.reg, free.reg);
			ptr = ptr->Next;
			break;
		case REM_:
			free = CheckReg();
			Aux = free;
			fprintf(f, "MOV %s , %s \n", Aux.reg, ptr->DATA->Arg1);
			Aux.used++;
			Aux.var = ptr->DATA->Arg1;
			SetReg(Aux);
			free = CheckReg();
			fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Arg2);
			free.used++;
			free.var = ptr->DATA->Arg2;
			SetReg(free);
			fprintf(f, "REM %s , %s , %s\n", ptr->DATA->Result,Aux.reg, free.reg);
			ptr = ptr->Next;
			break;
		case INC_:
			free = CheckReg();
			fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Result);
			fprintf(f, "INC %s \n", free.reg);
			fprintf(f, "MOV %s , %s \n", ptr->DATA->Result,free.reg);
			free.used++;
			free.var = ptr->DATA->Arg2;
			SetReg(free);
			ptr = ptr->Next;
			break;
		case DEC_:
			free = CheckReg();
			fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Result);
			fprintf(f, "DEC %s \n", free.reg);
			fprintf(f, "MOV %s , %s \n", ptr->DATA->Result,free.reg);
			free.used++;
			free.var = ptr->DATA->Arg2;
			SetReg(free);
			ptr = ptr->Next;
			break;
		case SWITCH_:
			free = CheckReg();
			fprintf(f, "OpenSwitch \n");
			ptr = ptr->Next;
			break;
		case CASE_:
			if(strcmp(ptr->DATA->Arg1,"caseSecondTime")==0)
			{
				fprintf(f, "JNZ Label%s \n",ptr->DATA->Arg2);
			}
			else if(strcmp(ptr->DATA->Arg1,"caseThirdTime")==0)
			{
				fprintf(f, "JMP CloseSwitchLabel%s \n",ptr->DATA->Result);
				fprintf(f, "Label%s: \n",ptr->DATA->Arg2);
			}
			else
			{
				free = CheckReg();
				fprintf(f, "Case%s: \n",ptr->DATA->Arg1);
				fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Result);
				fprintf(f, "CMP %s , %s \n", free.reg, ptr->DATA->Arg1);
				free.used++;
				free.var = ptr->DATA->Arg2;
				SetReg(free);
			}
			ptr = ptr->Next;
			break;
		case SWITCHDEFAULT_:
			fprintf(f, "DefaultCase%s: \n",ptr->DATA->Arg1);
			ptr = ptr->Next;
			break;
		case CLOSESWITCH_:
			fprintf(f, "CloseSwitch \n");
			fprintf(f, "CloseSwitchLabel%s: \n",ptr->DATA->Arg1);
			ptr = ptr->Next;
			break;
		case WHILE_:
			if(strcmp(ptr->DATA->Result,"OpenWhile1")==0)
			{
				fprintf(f, "OpenWhileLabel%s: \n",ptr->DATA->Arg2);
			}
			else if(strcmp(ptr->DATA->Result,"OpenWhile2")==0)
			{
				fprintf(f, "JF CloseWhileLabel%s \n",ptr->DATA->Arg2);
				fprintf(f, "OpenWhile \n");
			}
			ptr = ptr->Next;
			break;
		case CLOSEWHILE_:
			fprintf(f, "JMP OpenWhileLabel%s\n",ptr->DATA->Arg1);
			fprintf(f, "%s \n",ptr->DATA->Result);
			fprintf(f, "CloseWhileLabel%s: \n",ptr->DATA->Arg1);
			ptr = ptr->Next;
			break;
		case FOR_:
			if(strcmp(ptr->DATA->Result,"OpenForLoop1")==0)
			{
				fprintf(f, "OpenForLoopLabel%s: \n",ptr->DATA->Arg2);
			}
			else if(strcmp(ptr->DATA->Result,"OpenForLoop2")==0)
			{
				fprintf(f, "JF CloseForLoopLabel%s \n",ptr->DATA->Arg2);
				fprintf(f, "OpenForLoop \n");
			}
			ptr = ptr->Next;
			break;
		case CLOSEFORLOOP_:
			fprintf(f, "JMP OpenForLoopLabel%s \n",ptr->DATA->Arg1);
			fprintf(f, "%s \n",ptr->DATA->Result);
			fprintf(f, "CloseForLoopLabel%s: \n",ptr->DATA->Arg1);
			ptr = ptr->Next;
			break;
		case IF_:
			if(strcmp(ptr->DATA->Arg2,"OpenIf")==0)
			{
				fprintf(f, "JF Label%s \n", ptr->DATA->Result);
				fprintf(f, "%s \n", ptr->DATA->Arg2);
				ptr = ptr->Next;
			}
			else if(strcmp(ptr->DATA->Arg2,"CloseIf")==0)
			{
				fprintf(f, "%s \n", ptr->DATA->Arg2);
				fprintf(f, "Label%s: \n", ptr->DATA->Result);
				ptr = ptr->Next;
			}
			else if(strcmp(ptr->DATA->Arg2,"OpenElseIf1")==0)
			{
				fprintf(f, "%s \n", "CloseIf");
				fprintf(f, "JMP endIfLabel%s \n", ptr->DATA->Arg1);
				fprintf(f, "Label%s: \n", ptr->DATA->Result);
				ptr = ptr->Next;
			}
			else if(strcmp(ptr->DATA->Arg2,"OpenElseIf2")==0)
			{
				fprintf(f, "JF Label%s \n", ptr->DATA->Result);
				fprintf(f, "%s \n", "OpenIf");
				ptr = ptr->Next;
			}
			break;
		case ELSE_:
			fprintf(f, "%s \n", "CloseIf");
			fprintf(f, "JMP endIfLabel%s \n", ptr->DATA->Arg2);
			fprintf(f, "Label%s: \n", ptr->DATA->Result);
			fprintf(f, "%s \n", "OpenElse");
			ptr = ptr->Next;
			break;
		case CLOSEELSE_:
			fprintf(f, "%s \n", "CloseElse");
			fprintf(f, "endIfLabel%s: \n", ptr->DATA->Arg1);
			ptr = ptr->Next;
			break;
		case REPEATUNTIL_:
			fprintf(f, "OpenRepeatUntil%s: \n", ptr->DATA->Arg2);
			ptr = ptr->Next;
			break;
		case CLOSEREPEATUNTIL_:
			fprintf(f, "JF OpenRepeatUntil%s \n", ptr->DATA->Arg1);     // 8albn hn5leeha JF bs xD (DONE)
			ptr = ptr->Next;
			break;
		case LESSTHAN_:
			free = CheckReg();
			fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Arg1);
			free.used++;
			free.var = ptr->DATA->Arg1;
			SetReg(free);
			Aux = CheckReg();
			fprintf(f, "MOV %s , %s \n", Aux.reg, ptr->DATA->Arg2);
			Aux.used++;
			Aux.var = ptr->DATA->Arg1;
			SetReg(Aux);
			fprintf(f, "CMPL %s, %s , %s \n", ptr->DATA->Result, Aux.reg, free.reg);
			ptr = ptr->Next;
			break;
		case GREATERTHAN_:
			free = CheckReg();
			fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Arg1);
			free.used++;
			free.var = ptr->DATA->Arg1;
			SetReg(free);
			Aux = CheckReg();
			fprintf(f, "MOV %s , %s \n", Aux.reg, ptr->DATA->Arg2);
			Aux.used++;
			Aux.var = ptr->DATA->Arg1;
			SetReg(Aux);
			fprintf(f, "CMPG %s, %s , %s \n", ptr->DATA->Result, Aux.reg, free.reg);
			ptr = ptr->Next;
			break;
		case LESSTHANOREQUAL_:
			free = CheckReg();
			fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Arg1);
			free.used++;
			free.var = ptr->DATA->Arg1;
			SetReg(free);
			Aux = CheckReg();
			fprintf(f, "MOV %s , %s \n", Aux.reg, ptr->DATA->Arg2);
			Aux.used++;
			Aux.var = ptr->DATA->Arg1;
			SetReg(Aux);
			fprintf(f, "CMPLEQ %s, %s , %s \n", ptr->DATA->Result, Aux.reg, free.reg);
			ptr = ptr->Next;
			break;
		case GREATERTHANOREQUAL_:
			free = CheckReg();
			fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Arg1);
			free.used++;
			free.var = ptr->DATA->Arg1;
			SetReg(free);
			Aux = CheckReg();
			fprintf(f, "MOV %s , %s \n", Aux.reg, ptr->DATA->Arg2);
			Aux.used++;
			Aux.var = ptr->DATA->Arg1;
			SetReg(Aux);
			fprintf(f, "CMPGEQ %s, %s , %s \n", ptr->DATA->Result, Aux.reg, free.reg);
			ptr = ptr->Next;
			break;
		case EQUALEQUAL_:
			free = CheckReg();
			fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Arg1);
			free.used++;
			free.var = ptr->DATA->Arg1;
			SetReg(free);
			Aux = CheckReg();
			fprintf(f, "MOV %s , %s \n", Aux.reg, ptr->DATA->Arg2);
			Aux.used++;
			Aux.var = ptr->DATA->Arg1;
			SetReg(Aux);
			fprintf(f, "CMPEQ %s, %s , %s \n", ptr->DATA->Result, Aux.reg, free.reg);
			ptr = ptr->Next;
			break;
		case NOTEQUAL_:
			free = CheckReg();
			fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Arg1);
			free.used++;
			free.var = ptr->DATA->Arg1;
			SetReg(free);
			Aux = CheckReg();
			fprintf(f, "MOV %s , %s \n", Aux.reg, ptr->DATA->Arg2);
			Aux.used++;
			Aux.var = ptr->DATA->Arg1;
			SetReg(Aux);
			fprintf(f, "CMPNEQ %s, %s , %s \n", ptr->DATA->Result, Aux.reg, free.reg);
			ptr = ptr->Next;
			break;
		case AND_:
			free = CheckReg();
			fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Arg1);
			free.used++;
			free.var = ptr->DATA->Arg1;
			SetReg(free);
			Aux = CheckReg();
			fprintf(f, "MOV %s , %s \n", Aux.reg, ptr->DATA->Arg2);
			Aux.used++;
			Aux.var = ptr->DATA->Arg1;
			SetReg(Aux);
			fprintf(f, "AND %s, %s , %s \n", ptr->DATA->Result, Aux.reg, free.reg);
			ptr = ptr->Next;
			break;
		case OR_:
			free = CheckReg();
			fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Arg1);
			free.used++;
			free.var = ptr->DATA->Arg1;
			SetReg(free);
			Aux = CheckReg();
			fprintf(f, "MOV %s , %s \n", Aux.reg, ptr->DATA->Arg2);
			Aux.used++;
			Aux.var = ptr->DATA->Arg1;
			SetReg(Aux);
			fprintf(f, "OR %s, %s , %s \n", ptr->DATA->Result, Aux.reg, free.reg);
			ptr = ptr->Next;
			break;
		case NOT_:
			free = CheckReg();
			fprintf(f, "MOV %s , %s \n", free.reg, ptr->DATA->Arg1);
			fprintf(f, "NOT %s \n", free.reg);
			fprintf(f, "MOV %s , %s \n", ptr->DATA->Result, free.reg);
			free.used++;
			free.var = ptr->DATA->Arg2;
			ptr = ptr->Next;
			SetReg(free);
			break;
		case PRINT_:
			//free = CheckReg();
			//fprintf(f, "PRINT %s \n", free.reg);
			fprintf(f, "PRINT %s \n", ptr->DATA->Result);
			// free.used++;
			// free.var = ptr->DATA->Arg2;
			// SetReg(free);
			ptr = ptr->Next;
			break;
		case OPENFUNC_:
			if(strcmp(ptr->DATA->Result,"main")==0)
			{
				fprintf(f, "Openmain \n");
			}
			else
			{
				fprintf(f, "JMP EndLabel%s \n",ptr->DATA->Arg2);
				fprintf(f, "%s: \n",ptr->DATA->Result);
				fprintf(f, "Open%s \n",ptr->DATA->Result);
			}
			ptr = ptr->Next;
			break;
		case CLOSEFUNC_:
			fprintf(f, "%s \n",ptr->DATA->Arg1);
			fprintf(f, "EndLabel%s: \n",ptr->DATA->Arg2);
			ptr = ptr->Next;
			break;
		case CALLFUNC_:
			fprintf(f, "call %s \n",ptr->DATA->Arg2);
			ptr = ptr->Next;
			break;
		default:
			break;
		}
	}
}
void ResetReg()
{
	int i;// for c
	for ( i = 0; i<7; i++)
	{
		Reg x;
		x.var = "0";
		x.used = 0;
		reg[i].used=x.used;
		reg[i].var=x.var;
	}
	reg[0].reg="R0";
	reg[1].reg="R1";
	reg[2].reg="R2";
	reg[3].reg="R3";
	reg[4].reg="R4";
	reg[5].reg="R5";
	reg[6].reg="R6";
}
void SetReg(Reg x)
{
	int i;
	for ( i = 0; i<7; i++)
	{
		if (reg[i].reg == x.reg)
		{
			reg[i].used = x.used;
			reg[i].var = x.var;
		}
	}
}
Reg CheckReg()
{
	Reg min = reg[0];
	if (min.var == "0")
	{
		return min;
	}
	else
	{
		int i;
		for ( i = 0; i<7; i++)
		{
			if (reg[i].var == "0")
			{
				return reg[i];
			}
			else if (reg[i].used < min.used)
			{
				min = reg[i];
			}
		}
		return min;
	}
}

void DestroyQuadsList()
{
	QuadNode *Walker = TopPtr;
	while (Walker)
	{
		QuadNode *rD = Walker;
		Walker = Walker->Next;
		free(rD);
	}
}
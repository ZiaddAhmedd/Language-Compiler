#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>
#include<string.h> 
#pragma warning (disable : 4996)			// disables warning for deprecated functions
//QUADRABLES

#define ADD_ 10
#define AND_ 25
#define OR_ 26
#define ASSIGN_ 1
#define DECLARE_ 0
#define DEC_ 16
#define DIVIDE_ 13
#define REPEATUNTIL_ 22
#define ENUM_ 23
#define EQUALEQUAL_ 33
#define NOTEQUAL_ 32
#define FOR_ 21
#define NOT_ 27
#define GREATERTHANOREQUAL_ 30
#define LESSTHANOREQUAL_ 31
#define GREATERTHAN_ 28
#define LESSTHAN_ 29
#define IF_ 60
#define INC_ 15
#define MINUS_ 11
#define MULTIPLY_ 12
#define PRINT_ 62
#define REM_ 14
#define SWITCHDEFAULT_ 71
#define CLOSESWITCH_ 72
#define CLOSEENUM_ 73
#define SWITCH_ 61
#define CASE_ 70
#define WHILE_ 20
#define ELSE_ 80
#define CLOSEELSE_ 81
#define CLOSEWHILE_ 90
#define CLOSEREPEATUNTIL_ 91
#define CLOSEFORLOOP_ 92
#define OPENFUNC_ 100
#define CLOSEFUNC_ 101
#define CALLFUNC_ 63


typedef struct TypeAndValue {
	int Type;
	char*  Value;
} TypeAndValue;

typedef struct SymbolData
{
	int Type;	                    // representing the type of the token or Function
	bool Initilzation;              // indicate the symbol Initilzed a value or not 
	bool Used;                      // indicate used or not as it needed in output 
	int BracesScope;                // representing the scope number that the variable is decleared
	char* Value;                    // representing the value of assigned token
	char* IdentifierName;           // The name of Varible
	bool Modifiable;                // represent var constant or not 
	bool IsFunctionSymbol;          // representing Function Symbol 
	int ArgNum;                     // representing Function Arguments Number 
	int* ArrTypes;                  // representing Function Arguments Types 

}SymbolData;

//-------------------------------------------------Linked List Node -------------------------------
typedef struct SymbolNode {
	struct SymbolData * DATA;
	int ID;// representing the ID of the Symbol 
	struct SymbolNode *Next;
} SymbolNode;


//---------------------------------------- Needed Functions with the Linked List------------------

struct SymbolData* setSymbol(int type, int init, bool used, char * name,bool Modifiable, int ScopeNum);// Get a Symbol Entity
void pushSymbol(int ID, struct SymbolData* data);// to Insert a node in list


// struct SymbolData* getSymbol(int rID);// Return a Symbol Entity given his ID in LIST

SymbolNode * getID(char * Identifiyer, int rBraceSCope);// given Variable NAME AND SCOPE return ID
bool CheckIDENTIFYER(char * ID, int scopeNum);//check weather identifuer is defined before or not

int getSymbolType(char*rID);
void setFuncArg(int ArgCount, int*ArgTypes, SymbolData *rD);
int checkArgType(int ArgCount, int*ArgTypes, char *rD, int Scope);
void DeadSymbols(int Brace);


// ----------------------------------------------PRINTING FUNCTIONS------------------------
void WriteUsed(FILE *f);
void WriteNotUsed(FILE *f);
void WriteInitilized(FILE *f);
void WriteNotInit(FILE *f);
void WriteSymbolTable(FILE*F);

//----------------------------------------------------------------------------------------------
void DestroySymbolsList();


//---------------------------------------QUADRABLES------------------------

typedef struct Reg
{
	char* reg;
	char* var;		// the varible that is stored in the register
	int used;		// 0 if not used
}Reg;


typedef struct QuadData
{
	int OpCode;	//					representing the type of the token or Function
	char*Arg1;
	char*Arg2;
	char*Result;

}QuadData;

typedef struct QuadNode 
{
	struct QuadData * DATA;
	int ID;// representing the ID of the Symbol 
	struct QuadNode *Next;
} QuadNode;


void InsertQuadruple(QuadData*rD, int ID);
void setQuad(int Op, char* Arg1, char* Arg2, char*Result, int rID);// i only need to call this in  yacc
void AssemblyGenerator(QuadNode* head,FILE *f);
void WriteQuads(FILE * f);
QuadNode*getTOP();
void DestroyQuadsList();
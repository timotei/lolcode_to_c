%{
#include "lolcode.h"

%}

%token EOL

%token WIN FAIL

%token HAI KTHXBYE VISIBLE GIMMEH VAR_DECL ITZ VAR_ASSIGN AN HAS_STDIO YR EXCLAMATION
%token OP_SUM OP_DIFF OP_PROD OP_DIV OP_MOD OP_MIN OP_MAX OP_SAME OP_NOTSAME OP_AND OP_OR OP_XOR OP_NOT
%token FOR_END FOR_START FOR_UPPIN FOR_NERFIN FOR_TIL FOR_WILE
%token IF_START IF_YES IF_NOT IF_MAYBE COND_END SW_START SW_CASE SW_DEFAULT SW_BREAK

%token String Number Variable

%start Program
%%
Program:
	Program_start
	Program_body
	Program_end
	;

Program_start:
	HAI Number EOL 		{ gen_programStart(); }
	| HAI EOL			{ gen_programStart(); }
	;

Program_end:
	KTHXBYE EOL 	{ gen_programEnd(); }
	| KTHXBYE 		{ gen_programEnd(); }
	;

Program_body:
	/* nothing */
	| Program_body EOL
	| Program_body Statement EOL
	;

Statement:
	| ConsoleOutput
	| ConsoleInput
	| VariableDeclaration
	| VariableAssignment
	| HAS_STDIO
	| ForConstruct
	| IfStatement
	| SwitchStatement
	;

StatementList:
	/* nothing */
	| StatementList Statement EOL
	;

SwitchStatement:
	NumericalExpression EOL
	SW_START EOL { gen_swStart($1); }
		SwitchCases
	COND_END { gen_condEnd(); }
	;

SwitchStatementList:
	/* nothing */
	| SwitchStatementList Statement EOL
	| SwitchStatementList SW_BREAK EOL { gen_break(); }
	;

SwitchCases:
	/* nothing */
	| SwitchCases SW_CASE String EOL { gen_swCaseStart($3); } SwitchStatementList { gen_swCaseEnd(); }
	| SwitchCases SW_DEFAULT EOL { gen_swDefaultStart(); } SwitchStatementList { gen_swCaseEnd(); }
	;

IfStatement:
	NumericalExpression EOL
	IF_START EOL
		IF_YES EOL { gen_ifStart($1); } StatementList
		IfContents
	COND_END { gen_condEnd(); }
	;

IfContents:
	/* nothing */
	| IfContents IF_NOT EOL { gen_ifElse(); } StatementList
	| IfContents IF_MAYBE NumericalExpression { gen_ifElseIf($3); } StatementList
	;

ForConstruct:
	FOR_START Variable ForOperation YR Variable ForCondition EOL { gen_forStart($5, $6, $3); }
		StatementList
	FOR_END Variable { gen_forEnd(); }
	;

ForOperation: 
	FOR_UPPIN { $$ = $1; } 
	| FOR_NERFIN { $$ = $1; }
	;

ForCondition:
	FOR_TIL Operation { $$ = "!" + $2; }
	| FOR_WILE Operation { $$ = $2; }
	;

Expression:
	NumericalExpression
	| String
	;

NumericalExpression:
	Operation
	| Number
	| Variable
	;

Operation:
	OP_SUM NumericalExpression AN NumericalExpression { $$ = gen_op("+", $2, $4); }
	| OP_DIFF NumericalExpression AN NumericalExpression { $$ = gen_op("-", $2, $4); }
	| OP_PROD NumericalExpression AN NumericalExpression { $$ = gen_op("*", $2, $4); }
	| OP_DIV NumericalExpression AN NumericalExpression { $$ = gen_op("/", $2, $4); }
	| OP_MOD NumericalExpression AN NumericalExpression { $$ = gen_op("%", $2, $4); }
	| OP_MAX NumericalExpression AN NumericalExpression { $$ = gen_func("max", $2, $4); }
	| OP_MIN NumericalExpression AN NumericalExpression { $$ = gen_func("min", $2, $4); }
	| OP_SAME Expression AN Expression { $$ = gen_op("==", $2, $4); }
	| OP_NOTSAME Expression AN Expression { $$ = gen_op("!=", $2, $4); }
	| OP_AND NumericalExpression AN NumericalExpression { $$ = gen_op("&&", $2, $4); }
	| OP_OR NumericalExpression AN NumericalExpression { $$ = gen_op("||", $2, $4); }
	| OP_XOR NumericalExpression AN NumericalExpression { $$ = gen_op("!=", $2, $4); }
	| OP_NOT NumericalExpression { $$ = gen_op("!", "", $2); }
	;

VariableAssignment:
	Variable VAR_ASSIGN NumericalExpression { gen_assignVar($1, $3, INT); }
	| Variable VAR_ASSIGN String { gen_assignVar($1, $3, STRING); }
	;

VariableDeclaration:
	VAR_DECL Variable  { gen_declareVar($2, "", NONE); }
	| VAR_DECL Variable ITZ Number { gen_declareVar($2, $4, INT); }
	| VAR_DECL Variable ITZ String { gen_declareVar($2, $4, STRING); }
	;

ConsoleInput:
	GIMMEH Variable { gen_input($2); }

ConsoleOutput:
	VISIBLE VisibleStatementArgs { gen_print("\"\\n\""); }
	| VISIBLE VisibleStatementArgs EXCLAMATION	
	;

VisibleStatementArgs:
	NumericalExpression { gen_print($1); }
	| String { gen_print($1); }
	| VisibleStatementArgs NumericalExpression { gen_print($2); }
	| VisibleStatementArgs String { gen_print($2); }
	;

%%
int main()
{
	yyparse();
	return 0;
}
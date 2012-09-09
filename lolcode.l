%option noyywrap
%{
#include "lolcode.h"
#include "y.tab.h"

#define save_str_and_token(tok) yylval = std::string(yytext); return tok
#define save_str() yylval = std::string(yytext);

%}

%%

BTW[^\r\n]*\r?\n { }
OBTW(.|\r|\n)*TLDR\r?\n {}

"HAI" 			{ return HAI; }
"KTHXBYE" 		{ return KTHXBYE; }
"VISIBLE"		{ return VISIBLE; }
"GIMMEH"		{ return GIMMEH; }
"I HAS A" 		{ return VAR_DECL; }
"ITZ" 			{ return ITZ; }
"R"				{ return VAR_ASSIGN; }
"SUM OF"		{ return OP_SUM; }
"DIFF OF"		{ return OP_DIFF; }
"PRODUKT OF"	{ return OP_PROD; }
"QUOSHUNT OF"	{ return OP_DIV; }
"MOD OF"		{ return OP_MOD; }
"BIGGR OF"		{ return OP_MAX; }
"SMALLR OF"		{ return OP_MIN; }
"BOTH SAEM" 	{ return OP_SAME; }
"DIFFRNT"		{ return OP_NOTSAME; }
"AN"			{ return AN; }
"CAN HAS STDIO?" { return HAS_STDIO; }
"IM OUTTA YR"	{ return FOR_END; }
"IM IN YR" 		{ return FOR_START; }
"YR"			{ return YR; }
"UPPIN"			{ save_str_and_token(FOR_UPPIN); }
"NERFIN"		{ save_str_and_token(FOR_NERFIN); }
"TIL"			{ save_str_and_token(FOR_TIL); }
"WILE"			{ save_str_and_token(FOR_WILE); }
"WIN"			{ return WIN; }
"FAIL"			{ return FAIL; }
"BOTH OF"		{ return OP_AND; }
"EITHER OF"		{ return OP_OR; }
"WON OF"		{ return OP_XOR; }
"NOT"			{ return OP_NOT; }
"O RLY?"		{ return IF_START; }
"YA RLY"		{ return IF_YES; }
"NO WAI"		{ return IF_NOT; }
"MEBBE"			{ return IF_MAYBE; }
"WTF?"			{ return SW_START; }
"OMG"			{ return SW_CASE; }
"OMGWTF"		{ return SW_DEFAULT; }
"GTFO"			{ return SW_BREAK; }

"OIC"			{ return COND_END; }

[a-zA-Z][a-zA-Z0-9_]* { save_str_and_token(Variable); }

('-'|'+')?[0-9]+(.[0-9]+)?	{ save_str_and_token(Number); }

\"[^\r\n\"]*\"	{ save_str_and_token(String); }

!				{ save_str_and_token(EXCLAMATION); }

\r?\n 			{ return EOL; }
,				{ return EOL; }
[ \t] 			;

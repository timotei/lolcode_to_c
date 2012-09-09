#ifndef _LOLCODE_H_
#define _LOLCODE_H_

#include <iostream>
#include <string>
#include <string.h>

enum VariableType {
	NONE,
	INT,
	STRING
};

enum FormatOptions {
	FORMAT_NONE = 0x0,
	FORMAT_EOL = 0x1,
	FORMAT_INDENT = 0x2
};

int yyerror(const char *s);
int yylex();

void gen_programStart();
void gen_programEnd();

void gen_print(const std::string& s);
void gen_input(const std::string& variable);

void gen_declareVar(const std::string& name, const std::string& value, VariableType type, int opt = FORMAT_EOL | FORMAT_INDENT);
void gen_assignVar(const std::string& name, const std::string& value, VariableType type);

std::string gen_op(const std::string& op, const std::string& a, const std::string& b);
std::string gen_func(const std::string& funcName, const std::string& a, const std::string& b);

void gen_forStart(const std::string& variable, const std::string& condition, const std::string& mode);
void gen_forEnd();

void gen_break();

void gen_ifStart(const std::string& cond);
void gen_ifElse();
void gen_ifElseIf(const std::string& cond);

void gen_condEnd();

void gen_swStart(const std::string& cond);
void gen_swCaseStart(const std::string& option);
void gen_swDefaultStart();
void gen_swCaseEnd();

#define YYSTYPE_IS_DECLARED 1
typedef std::string YYSTYPE;

extern int _indent;

#endif

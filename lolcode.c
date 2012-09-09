#include "lolcode.h"

#include <iostream>
#include <utility>
#include <stdio.h>
#include <map>

int _indent = 1; 

struct Variable {
	VariableType type;
	std::string value;
};

typedef std::map<std::string, Variable> VariablesMap;
VariablesMap _variables;

int yyerror(const char *s) {
	std::cout << "ERR> " << s << "\n";
}

void dumpVars()
{
	for(VariablesMap::const_iterator itor = _variables.begin(); itor != _variables.end(); ++ itor){
		std::cout << (*itor).first << " - (value: " << (*itor).second.value << ") | type: " << (*itor).second.type << "\n";
	}
}

void gen_programStart() {
	std::cout 	<< "#include <iostream>\n"
				<< "#include <string>\n"
				<< "using namespace std;\n"
				<< "int main() {\n";
}

std::string indent()
{
	std::string res;
	for(int i = 0; i < _indent; ++i) {
		res += "\t";
	}

	return res;
}

void gen_programEnd() {
	std::cout << indent() << "return 0;" << "\n}\n";
}

void gen_print(const std::string& s) {
	std::cout << indent() << "cout << " << s << ";\n";
}

void gen_input(const std::string& variable) {
	VariablesMap::iterator itor = _variables.find(std::string(variable));
	if (itor == _variables.end()) {
		std::cerr << "Trying to assign an undeclared variable: " << variable << " !!\n";
		return;
	}
	
	Variable &var = (*itor).second;
	if (var.type == NONE){
		std::cout << indent() << "string " << variable << ";\n";
		var.type = STRING;
	}

	std::cout << indent() << "cin >> " << variable << ";\n";
}

void gen_declareVar(const std::string& name, const std::string& value, VariableType type, int opt) {
	VariablesMap::iterator itor = _variables.find(std::string(name));
	if (itor != _variables.end()) {
		if ((*itor).second.type != NONE && (*itor).second.type != type) {
			std::cerr << "Variable " << name << " is already defined using another type!\n";
		}
		return;
	}

	Variable var;
	var.type = type;
	var.value = value;

	_variables.insert(make_pair(std::string(name), var));

	// declare the variable
	if (type != NONE) {
		if ((opt & FORMAT_INDENT) == FORMAT_INDENT) {
			std::cout << indent();
		}

		if (type == INT) {
			std::cout << "int ";
		}
		else if (type == STRING) {
			std::cout << "string ";
		}
		std::cout << name << " = " << value;

		if ((opt & FORMAT_EOL) == FORMAT_EOL) {
			std::cout << ";\n";
		}
	}
}

void gen_assignVar(const std::string& name, const std::string& value, VariableType type) {
	VariablesMap::iterator itor = _variables.find(std::string(name));
	if (itor == _variables.end()) {
		std::cerr << "Trying to assign an undeclared variable: " << name << " !!\n";
		return;
	}
	
	Variable &var = (*itor).second;

	if (var.type != NONE && var.type != type){
		std::cerr << "Trying to assign a value to an invalid type\n";
		return;
	}

	// need to declare it
	if (var.type == NONE) {
		std::cout << indent();

		if (type == STRING) {
			std::cout << "string ";
		}
		else if (type == INT) {
			std::cout << "int ";
		}

		std::cout << name << " = " << value << ";\n";
	}
	else {
		std::cout << indent() << name << " = " << value << ";\n";
	}

	var.type = type;
	var.value = value;
}

std::string gen_op(const std::string& op, const std::string& a, const std::string& b) {
	return "(" + a + " " + op + " " + b + ")";
}

std::string gen_func(const std::string& funcName, const std::string& a, const std::string& b) {
	return "(" + funcName + "(" + a + ", " + b + "))";
}

void gen_forStart(const std::string& variable, const std::string& condition, const std::string& mode) {
	std::cout << indent() << "for (";
	gen_declareVar(variable, "0", INT, FORMAT_NONE);
	std::cout << "; " << condition << "; " << ( mode == "UPPIN" ? "++ " : "--") << variable << ")\n" << indent() << "{\n";
	++ _indent;
}

void gen_forEnd()
{
	-- _indent;
	std::cout << indent() << "}\n";
}

void gen_ifStart(const std::string& cond) {
	std::cout << indent() << "if (" << cond << ") {\n";
	++ _indent;
}
void gen_ifElse() {
	-- _indent;
	std::cout << indent() << "} else {\n";
	++ _indent;
}
void gen_condEnd() {
	-- _indent;
	std::cout << indent() << "}\n";
}

void gen_ifElseIf(const std::string& cond) {
	-- _indent;
	std::cout << indent() << "} else if (" << cond << ") {\n";
	++ _indent;
}

std::string _swCond;
bool swFirst = true;

void gen_swStart(const std::string& cond) {
	_swCond = cond;
	std::cout << indent() << "{\n";
	++ _indent;

	swFirst = true;
}

void gen_swCaseStart(const std::string& option) {
	std::cout << indent(); 

	if (!swFirst){
		std::cout << "else ";
	}

	std::cout << "if (" << _swCond  << " == " << option << ") {\n";
	++ _indent;
	swFirst = false;
}

void gen_swDefaultStart() {
	std::cout << indent() << "else {\n";
	++ _indent;
}

void gen_break() {
	//std::cout << indent() << "break;\n";
}
void gen_swCaseEnd() {
	std::cout << indent() << "}\n";
	-- _indent;
}
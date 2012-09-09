#!/bin/bash
echo ">>>>>>>>FLEX"
flex lolcode.l
if [[ $? != 0 ]]
then
	exit
fi

echo ">>>>>>>>YACC"
yacc -v -d lolcode.y
if [[ $? != 0 ]]
then
	exit
fi

echo ">>>>>>>>G++"
g++ -o lolcode lolcode.c lex.yy.c y.tab.c
#echo Launching...
#./$1
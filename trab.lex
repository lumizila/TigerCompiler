%option noyywrap

INTEIRO   [0-9]+
IDENTIFICADOR       [a-zA-Z][a-zA-Z0-9]*

%{
#include "heading.h"
#include "tok.h"
#include <string.h>
#include <iostream>
int yyerror(char *s);

%}

%%
{INTEIRO}  {
	return INTEGER; 
}

var return VAR; 
function return FUNCTION;
if return IF;
then return THEN;
else return ELSE;
while return WHILE;
do return DO;
let return LET;
in return IN;
end return END;
int return TIPOINT;


"\"".*"\"" {}

{IDENTIFICADOR} {
	return ID;
}

":=" return ATT;
";" return ';';
"," return ',';
"(" return '(';
")" return ')';
"+" return '+';
"-" return '-';
"*" return '*';
"/" return '/';
"=" return '=';
"<>" return DIF;
">" return '>';
"<" return '<';
">=" return GE;
"<=" return LE;
"&" return '&';
"|" return '|';

"/*".*"*/" {
	
}

[ \t]*		{}
[\n]		{ yylineno++;}

.		{std::cerr << "SCANNER "; yyerror(""); exit(1);}

%%


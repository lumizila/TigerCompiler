%option noyywrap

INTEIRO   [0-9]+
IDENTIFICADOR       [a-zA-Z][a-zA-Z0-9]*

%{
#include "heading.h"
#include "tok.h"
#include <string.h>
/*#include <iostream>
*/
#include <stdio.h>
int yyerror(char *s);

%}

%%

{INTEIRO} return INTEGER; 
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


"\"".*"\"" return STRING;

{IDENTIFICADOR} return ID;

":=" return ATT;
";" return PVIR;
"," return VIR;
"(" return AP;
")" return FP;
"+" return MAIS;
"-" return MENOS;
"*" return VEZES;
"/" return DIV;
"=" return EQ;
"<>" return DIF;
">" return GT;
"<" return LT;
">=" return GE;
"<=" return LE;
"&" return AND;
"|" return OR;
":" return DP;

"/*"([^*]|\*+[^*/])*\*+"/" 

[ \t]*		{}
[\n]		{yylineno++;}

.		{
		fprintf(stderr, "Scanner - Erro linha: %d\n",yylineno);
		yyerror("");
		exit(1);
}

%%


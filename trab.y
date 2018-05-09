/* Mini Calculator */
/* calc.y */

%{
#include "heading.h"
#include <string.h>
int yyerror(char *s);
int yylex(void);
%}

%start	expr 

%token	INTEGER VAR FUNCTION ID
%token  IF THEN ELSE WHILE DO LET IN END 
%token  ATT DIF GE LE
%token  TIPOINT

/*precedencia de operadores*/
%precedence '*' '/' '+' '-' '=' '>' '<' '&' '|'
%nonassoc ATT DIF GE LE
%precedence ELSE THEN
%precedence DO

%%

expr:		intconstant
		| nil
		| lvalue
		| expr binoperator expr
		| lvalue ATT expr
		| ID '(' exprlist  ')'
		| '(' exprseq ')'
		| IF expr THEN expr
		| IF expr THEN expr ELSE expr
		| WHILE expr DO expr
		| LET declist IN exprseq END
		| '-' intconstant
		;

exprseq:	expr
		| exprseq ';' expr
		;

exprlist:	expr
		| exprlist ',' expr
		;

lvalue:		ID
		;

declist:	dec
		| declist dec
		;

dec:		variabledec
		| functiondec
		;

variabledec:	VAR ID ATT expr
		;

intconstant:	INTEGER
		;

typefields:	typefield
		| typefields ',' typefield
		;

typefield:	ID ':' typeid
		;

typeid:		TIPOINT
		;
functiondec:	FUNCTION ID '(' typefields ')' '=' expr
		;

/*a partir daqui são descrições de tipos, e nao regras*/

binoperator:	ATT 
		| DIF
		| GE
		| LE
		| '+' | '-' | '*' | '/' | '=' | '>' | '<' | '&' | '|'
		;
	
nil:	%empty	;

/*
exp:		
		| expr	{ cout << "Hello world!"<< endl; }
		;
*/

%%

int yyerror(string s)
{
  extern int yylineno;	// defined and maintained in lex.c
  extern char *yytext;	// defined and maintained in lex.c
  
  cerr << "ERROR: " << s << " at symbol \"" << yytext;
  cerr << "\" on line " << yylineno << endl;
  exit(1);
}

int yyerror(char *s)
{
  return yyerror(string(s));
}



/* Mini Calculator */
/* calc.y */

%{
#include "heading.h"
#include <string.h>
int yyerror(char *s);
int yylex(void);
%}

%start	input 

%token	INTEGER VAR FUNCTION IF THEN ELSE WHILE DO LET IN END ID ATT DIF GE LE

%%


expr:		integer-constant
		| nil
		| lvalue
		| expr binary-operator expr
		| lvalue ':=' expr
		| id '(' exprlist  ')'
		| '(' exprseq ')'
		| if expr then expr
		| if expr then expr else expr
		| while expr do expr
		| let declarationlist in exprseq end
		| '-' integer-constant
		;

input:		
		| expr	{ cout << "Hello world!"<< endl; }
		;

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



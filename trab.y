/* Mini Calculator */
/* calc.y */

%{
#include "heading.h"
#include <string.h>
int yyerror(char *s);
int yylex(void);
%}

%start	prog

%token	STRING INTEGER VAR FUNCTION ID
%token  IF THEN ELSE WHILE DO LET IN END 
%token  ATT DIF GE LE EQ GT LT
%token  TIPOINT
%token  MAIS MENOS VEZES DIV AND OR
%token 	AP FP PVIR VIR
%token  DP


%left  MAIS MENOS
%left  VEZES DIV 
%nonassoc  ATT DIF GE LE EQ GT AND OR LT

%precedence  HTO UMENOS
%right  ELSE LTE
%%

prog:		expr
		;

expr:		intconstant
		| stringconstant
/*		| nil
*/		| lvalue
/*		| expr ATT expr
*/		| expr DIF expr
		| expr GE expr
		| expr LE expr
		| expr EQ expr
		| expr GT expr
		| expr AND expr
		| expr OR expr
		| expr LT expr
		| expr VEZES expr
		| expr DIV expr
		| expr MAIS expr
		| expr MENOS expr
		| lvalue ATT expr
		| ID AP exprlist FP
		| AP exprseq FP
		| IF expr THEN expr %prec LTE
		| IF expr THEN expr ELSE expr
		| WHILE expr DO expr %prec HTO
		| LET declist IN exprseq END
		| MENOS expr %prec UMENOS
		;

exprseq:	 exprseq PVIR expr
		| expr
		| %empty
		;

exprlist:	 exprlist VIR expr
		| expr
		| %empty
		;

lvalue:		ID
		;

declist:	%empty	
		| declist dec
		;

dec:		variabledec
		| functiondec
		;

variabledec:	VAR ID ATT expr
		;

intconstant:	INTEGER
		;

stringconstant:	STRING
		;

typefields:	ID
		| typefields VIR ID
		;


/*
typefield:	ID DP typeid
		;

typeid:		TIPOINT
		;
*/
functiondec:	FUNCTION ID AP typefields FP ATT expr
		;

/*a partir daqui são descrições de tipos, e nao regras*/
/*
binoperator:	ATT 
		| DIF
		| GE
		| LE
		| MAIS | MENOS | VEZES | DIV | EQ | GT | LT | AND | OR
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



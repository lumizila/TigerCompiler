%{
#include "heading.h"
#include <string.h>
int yyerror(char *s);
int yylex(void);
%}

/*prog eh o primeiro comando na raiz da arvore */
%start	prog

/*declarando os nomes dos tokens*/
%token	STRING INTEGER VAR FUNCTION ID
%token  IF THEN ELSE WHILE DO LET IN END 
%token  ATT DIF GE LE EQ GT LT 
%token  TIPOINT
%token  MAIS MENOS VEZES DIV AND OR
%token 	AP FP PVIR VIR
%token  DP

/*declarando as precedencias*/
%left  MAIS MENOS
%left  VEZES DIV 
%nonassoc  ATT DIF GE LE EQ GT LT
%left AND OR
%precedence  HTO UMENOS HTOO
%right  ELSE LTE
%%

/*inicio das definicoes das regras*/
prog:		expr
		;

expr:		intconstant
		| stringconstant
		| lvalue
		| expr DIF expr
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
		| WHILE expr DO %prec HTOO
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

functiondec:	FUNCTION ID AP typefields FP ATT expr
		| FUNCTION ID AP FP ATT expr
		| FUNCTION ID AP typefields FP ATT 
		| FUNCTION ID AP FP ATT 
		;

%%

/*funcao executada quando houve algum erro*/
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



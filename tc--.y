%{
#include "heading.h"
#include <string.h>
#define YYSTYPE char *
extern char *yytext;
int yyerror(const char *s);
int yylex(void);
%}

<<<<<<< HEAD:trab.y
%error-verbose
%start	prog
%expect 27
=======
/*prog eh o primeiro comando na raiz da arvore */
%start	prog

/*declarando os nomes dos tokens*/
>>>>>>> 8f9bb63b090938b58db047fba6e3c11445e91305:tc--.y
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
<<<<<<< HEAD:trab.y
/*		| nil
*/		| lvalue {printf("%s",$1);}
/*		| expr ATT expr
*/		| expr DIF expr
=======
		| lvalue
		| expr DIF expr
>>>>>>> 8f9bb63b090938b58db047fba6e3c11445e91305:tc--.y
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
<<<<<<< HEAD:trab.y
		| let declist in exprseq end {printf("%s %s %s",$1, $3, $5);}
		| MENOS expr %prec UMENOS
=======
		| WHILE expr DO %prec HTOO
		| LET declist IN exprseq END
		| MENOS expr %prec UMENOS 
		;

exprseq:	 exprseq PVIR expr
		| expr
>>>>>>> 8f9bb63b090938b58db047fba6e3c11445e91305:tc--.y
		| %empty
		;
let:		LET{ $$ = strdup(yytext);};
in:		IN{ $$ = strdup(yytext);};
end:		END{ $$ = strdup(yytext);};
 
exprseq:	 exprseq PVIR expr  
		| expr  
/*		| %empty 
*/		;

exprlist:	 exprlist VIR expr
		| expr
/*		| %empty
*/		;

lvalue:		ID { $$ = strdup(yytext);}
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

<<<<<<< HEAD:trab.y


=======
/*funcao executada quando houve algum erro*/
>>>>>>> 8f9bb63b090938b58db047fba6e3c11445e91305:tc--.y
int yyerror(string s)
{
  extern int yylineno;	// defined and maintained in lex.c
  extern char *yytext;	// defined and maintained in lex.c
  
  cerr << "ERRO: " << s << " no simbolo \"" << yytext;
  cerr << "\" na linha " << yylineno << endl;
  exit(1);
}

int yyerror(const char *s)
{
  return yyerror(string(s));
}



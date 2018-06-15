/* Mini Calculator */
/* calc.y */

%{
#include "heading.h"
#include <malloc.h>
extern char *yytext;
int yyerror(char *s);
int yylex(void);
struct node{
	int numfilhos;
	char * conteudo; 
	struct node **filhos;
	struct node *pai;
};
typedef struct node no;
no* criaNo(char * conteudo, no* filho){
	no* novo = (no*) malloc(sizeof(no));
	if (filho) 
		novo->numfilhos=1;
	else
		novo->numfilhos=0;
	novo->filhos = (no**) malloc(10*sizeof(no*));
	novo->filhos[0] = filho;
	novo->pai=NULL;
	novo->conteudo = conteudo;
	return novo;
}
no* addFilho(no* pai, no* filho){
	if (pai->numfilhos==10){
		printf("ERRO, numero de nos filhos excedeu o limite: 10\n");
		exit(-1);
	}
	pai->filhos[pai->numfilhos] = filho;
	pai->numfilhos++;
	return pai;
}
void imprimeArvore(no* nodo, int nivel){
	for (int j=0; j<nivel; j++) printf("#");
	printf("(%s) ",nodo->conteudo);
	for (int j=0; j<nivel+1; j++) printf("#");
	for (int i=0; i<nodo->numfilhos; i++){
		printf(" %s ",nodo->filhos[i]->conteudo);
	}
	printf("\n");
	for (int i=0; i<nodo->numfilhos; i++){
		imprimeArvore(nodo->filhos[i], nivel+1);
	}
}

#define YYSTYPE no*

%}

%start	prog
/*espera-se 27 conflitos S/R graças ao %empty em expr*/
%expect 27

%token	STRING INTEGER VAR FUNCTION ID
%token  IF THEN ELSE WHILE DO LET IN END 
%token  ATT DIF GE LE EQ GT LT
%token  TIPOINT
%token  MAIS MENOS VEZES DIV AND OR
%token 	AP FP PVIR VIR
%token  DP

%left  MAIS MENOS
%left  VEZES DIV 
%nonassoc  ATT DIF GE LE EQ GT LT
%left AND OR
%precedence HTO UMENOS
%right ELSE LTE
%%

prog:		expr {imprimeArvore($1,0);/*printf(" pai: %s filho: %s filhodofilho1: %s filhodofilho2: %s \n",$1->conteudo,$1->filhos[0]->conteudo,$1->filhos[0]->filhos[0]->conteudo,$1->filhos[0]->filhos[1]->conteudo);*/}
		;

expr:		intconstant 
		| stringconstant 
		| lvalue 
		| expr DIF expr { $$=addFilho(criaNo((char*)"<>",$1),$3);} 
		| expr GE expr{ $$=addFilho(criaNo((char*)">=",$1),$3);} 
		| expr LE expr{ $$=addFilho(criaNo((char*)"<=",$1),$3);} 
		| expr EQ expr{ $$=addFilho(criaNo((char*)"=",$1),$3);} 
		| expr GT expr{ $$=addFilho(criaNo((char*)">",$1),$3);} 
		| expr AND expr { $$=addFilho(criaNo((char*)"&",$1),$3);}
		| expr OR expr{ $$=addFilho(criaNo((char*)"|",$1),$3);} 
		| expr LT expr{ $$=addFilho(criaNo((char*)"<",$1),$3);} 
		| expr VEZES expr{ $$=addFilho(criaNo((char*)"*",$1),$3);} 
		| expr DIV expr{ $$=addFilho(criaNo((char*)"/",$1),$3);} 
		| expr MAIS expr{ $$=addFilho(criaNo((char*)"+",$1),$3);} 
		| expr MENOS expr{ $$=addFilho(criaNo((char*)"-",$1),$3);} 
		| lvalue ATT expr { $$=addFilho(criaNo((char*)":=",$1),$3);}		
		| ID AP exprlist FP 
		| AP exprseq FP 
		| IF expr THEN expr %prec LTE 
		| IF expr THEN expr ELSE expr 
		| WHILE expr DO expr %prec HTO 
		| LET declist IN exprseq END { $$= criaNo("in",$4);/* a->lotacao++;a->filhos[0]=$4;$$=a;*/}
		| MENOS expr %prec UMENOS 
		| %empty 
		;

exprseq:	 exprseq PVIR expr
		| expr {$$=$1;}
		;

exprlist:	 exprlist VIR expr
		| expr
		;

lvalue:		ID 
/*lvalue:		ID { $$ = criaNo(strdup(yytext));}
*/		;

declist:	%empty	
		| declist dec
		;

dec:		variabledec
		| functiondec
		;

variabledec:	VAR ID ATT expr
		;

intconstant:	INTEGER{ $$ = criaNo(strdup(yytext),NULL);} 
		;

stringconstant:	STRING{ $$ = criaNo(strdup(yytext),NULL);}  
		;

typefields:	ID
		| typefields VIR ID
		;


functiondec:	FUNCTION ID AP typefields FP ATT expr
		;

%%

int yyerror(char* s)
{
  extern int yylineno;	
  extern char *yytext;	

  fprintf(stderr, "Erro: %s no simbolo %s na linha %d.\n",s, yytext, yylineno);
/*  cerr << "ERROR: " << s << " at symbol \"" << yytext;
  cerr << "\" on line " << yylineno << endl;
*/  exit(1);
}
/*
int yyerror(char *s)
{
  return yyerror(s);
}
*/


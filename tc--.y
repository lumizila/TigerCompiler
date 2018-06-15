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
	struct node *irmao;
};
typedef struct node no;
no* criaNo(char * conteudo){
	no* novo = (no*) malloc(sizeof(no));
	novo->filhos = (no**) malloc(10*sizeof(no*));
	novo->irmao = NULL;
	novo->conteudo = conteudo;
	return novo;
}
no* addFilho(no* pai, no* filho){
	if (!filho) return pai;
	if (pai->numfilhos==10){
		printf("ERRO, numero de nos filhos excedeu o limite: 10\n");
		exit(-1);
	}
	no* aux = filho->irmao;
	pai->filhos[pai->numfilhos] = filho;
	pai->numfilhos++;
	while (aux){
		pai->filhos[pai->numfilhos] = aux;
		pai->numfilhos++;
		aux = aux->irmao;
	}
	return pai;
}
no* addIrmao(no* nodo, no* irmao){
	nodo->irmao=irmao;
	return nodo;
}
void imprimeArvore(no* nodo, int nivel){
	for (int j=0; j<nivel; j++) printf("#");
	printf("<%s> ",nodo->conteudo);
	printf("\n");
	if (nivel==0){
	for (no* i=nodo->irmao; i!=NULL; i=i->irmao){
		imprimeArvore(i, nivel);
	}
	}
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

prog:		expr {imprimeArvore(addFilho(criaNo((char*)"expr"),$1),0);}
		;

expr:		intconstant 
		| stringconstant 
		| lvalue 
		| expr DIF expr { $$=addFilho(addFilho(criaNo((char*)"<>"),$1),$3);} 
		| expr GE expr{ $$=addFilho(addFilho(criaNo((char*)">="),$1),$3);} 
		| expr LE expr{ $$=addFilho(addFilho(criaNo((char*)"<="),$1),$3);} 
		| expr EQ expr{ $$=addFilho(addFilho(criaNo((char*)"="),$1),$3);} 
		| expr GT expr{ $$=addFilho(addFilho(criaNo((char*)">"),$1),$3);} 
		| expr AND expr { $$=addFilho(addFilho(criaNo((char*)"&"),$1),$3);}
		| expr OR expr{ $$=addFilho(addFilho(criaNo((char*)"|"),$1),$3);} 
		| expr LT expr{ $$=addFilho(addFilho(criaNo((char*)"<"),$1),$3);} 
		| expr VEZES expr{ $$=addFilho(addFilho(criaNo((char*)"*"),$1),$3);} 
		| expr DIV expr{ $$=addFilho(addFilho(criaNo((char*)"/"),$1),$3);} 
		| expr MAIS expr{ $$=addFilho(addFilho(criaNo((char*)"+"),$1),$3);} 
		| expr MENOS expr{ $$=addFilho(addFilho(criaNo((char*)"-"),$1),$3);} 
		| lvalue ATT expr { $$=addFilho(addFilho(criaNo((char*)":="),$1),$3);}		
		| ID AP exprlist FP 
		| AP exprseq FP 
		| IF expr THEN expr %prec LTE 
		| IF expr THEN expr ELSE expr 
		| WHILE expr DO expr %prec HTO 
		| LET declist IN exprseq END {$$=addIrmao(criaNo((char*)"let"),addIrmao(addFilho(criaNo((char*)"declist"),$2),addIrmao(criaNo((char*)"in"),addIrmao(addFilho(criaNo((char*)"exprseq"),$4),criaNo((char*)"end"))))); }
		| MENOS expr %prec UMENOS 
		| %empty { $$=NULL;} 
		;

exprseq:	 exprseq PVIR expr
		| expr
		;

exprlist:	 exprlist VIR expr
		| expr
		;

lvalue:		ID{ $$ = criaNo(strdup(yytext));}   
		;

declist:	%empty{ $$=NULL;}	
		| declist dec {$$=addIrmao(criaNo((char*)"var"),addFilho(criaNo((char*)"dec"),$2));}
		;

dec:		variabledec {$$=addFilho(criaNo((char*)"variabledec"),$1);}
		| functiondec
		;

variabledec:	VAR id ATT expr {$$=addIrmao(criaNo((char*)"var"),addIrmao(addFilho(criaNo((char*)"id"),$2),addIrmao(criaNo((char*)":="),addFilho(criaNo((char*)"expr"),$4))));}
		;

id:		ID{ $$ = criaNo(strdup(yytext));}   
		;

intconstant:	INTEGER{ $$ = criaNo(strdup(yytext));} 
		;

stringconstant:	STRING{ $$ = criaNo(strdup(yytext));}  
		;

typefields:	ID { $$ = criaNo(strdup(yytext));}   
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


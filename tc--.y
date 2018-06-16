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
//	for (int j=0; j<nivel; j++) printf("#");
//	printf("< %s >\n",nodo->conteudo);
	for (int j=0; j<nivel+1; j++) printf("#");
	for (int i=0; i<nodo->numfilhos; i++){
		printf("< %s > ",nodo->filhos[i]->conteudo);
	}
	if (nivel==0){
		for (no* i=nodo->irmao; i!=NULL; i=i->irmao){
			imprimeArvore(i, nivel+1);
		}
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

prog:		expr {imprimeArvore(addFilho(criaNo((char*)"expr"),$1),0);}
		;

expr:		intconstant { $$= addFilho(criaNo((char*)"intconstant"),$1);} 
		| stringconstant { $$= addFilho(criaNo((char*)"stringconstant"), $1);} 
		| id { $$= addFilho(criaNo((char*)"id"), $1);} 
		| expr DIF expr { $$=  addIrmao(addFilho(criaNo((char*)"expr"),$1),addIrmao(criaNo((char*)"<>"),addFilho(criaNo((char*)"expr"),$3)));} 
		| expr GE expr{ $$=  addIrmao(addFilho(criaNo((char*)"expr"),$1),addIrmao(criaNo((char*)">="),addFilho(criaNo((char*)"expr"),$3)));} 
		| expr LE expr{ $$=  addIrmao(addFilho(criaNo((char*)"expr"),$1),addIrmao(criaNo((char*)"<="),addFilho(criaNo((char*)"expr"),$3)));} 
		| expr EQ expr{ $$=  addIrmao(addFilho(criaNo((char*)"expr"),$1),addIrmao(criaNo((char*)"="),addFilho(criaNo((char*)"expr"),$3)));} 
		| expr GT expr{ $$=  addIrmao(addFilho(criaNo((char*)"expr"),$1),addIrmao(criaNo((char*)">"),addFilho(criaNo((char*)"expr"),$3)));} 
		| expr AND expr { $$=  addIrmao(addFilho(criaNo((char*)"expr"),$1),addIrmao(criaNo((char*)"&"),addFilho(criaNo((char*)"expr"),$3)));} 
		| expr OR expr{ $$=  addIrmao(addFilho(criaNo((char*)"expr"),$1),addIrmao(criaNo((char*)"|"),addFilho(criaNo((char*)"expr"),$3)));} 
		| expr LT expr{ $$=  addIrmao(addFilho(criaNo((char*)"expr"),$1),addIrmao(criaNo((char*)"<"),addFilho(criaNo((char*)"expr"),$3)));} 
		| expr VEZES expr{ $$=  addIrmao(addFilho(criaNo((char*)"expr"),$1),addIrmao(criaNo((char*)"*"),addFilho(criaNo((char*)"expr"),$3)));} 
		| expr DIV expr{ $$=  addIrmao(addFilho(criaNo((char*)"expr"),$1),addIrmao(criaNo((char*)"/"),addFilho(criaNo((char*)"expr"),$3)));} 
		| expr MAIS expr{ $$=  addIrmao(addFilho(criaNo((char*)"expr"),$1),addIrmao(criaNo((char*)"+"),addFilho(criaNo((char*)"expr"),$3)));} 
		| expr MENOS expr{ $$=  addIrmao(addFilho(criaNo((char*)"expr"),$1),addIrmao(criaNo((char*)"-"),addFilho(criaNo((char*)"expr"),$3)));} 
		| id ATT expr { $$=  addIrmao(addFilho(criaNo((char*)"id"),$1),addIrmao(criaNo((char*)":="),addFilho(criaNo((char*)"expr"),$3)));} 
		| id AP exprlist FP { $$=  addIrmao(addFilho(criaNo((char*)"id"),$1),addIrmao(criaNo((char*)"("),addIrmao(addFilho(criaNo((char*)"exprlist"),$3), criaNo((char*)")"))));}  
		| AP exprseq FP { $$= addIrmao(criaNo((char*)"("), addIrmao(addFilho(criaNo((char*)"exprseq"), $1), criaNo((char*)")")));}
		| IF expr THEN expr %prec LTE { $$= addIrmao(criaNo((char*)"if"), addIrmao(addFilho(criaNo((char*)"expr"), $1), addIrmao(criaNo((char*)"then"), addFilho(criaNo((char*)"expr"),$2))));}
		| IF expr THEN expr ELSE expr { $$= addIrmao(criaNo((char*)"if"), addIrmao(addFilho(criaNo((char*)"expr"), $1), addIrmao(criaNo((char*)"then"), addIrmao(addFilho(criaNo((char*)"expr"),$2),addIrmao(criaNo((char*)"else"),addFilho(criaNo((char*)"expr"),$3))))));}
		| WHILE expr DO expr %prec HTO { $$= addIrmao(criaNo((char*)"while"), addIrmao(addFilho(criaNo((char*)"expr"), $1),addIrmao(criaNo((char*)"do"),addFilho(criaNo((char*)"expr"),$2))));} 
		| LET declist IN exprseq END {$$=addIrmao(criaNo((char*)"let"),addIrmao(addFilho(criaNo((char*)"declist"),$2),addIrmao(criaNo((char*)"in"),addIrmao(addFilho(criaNo((char*)"exprseq"),$4),criaNo((char*)"end"))))); }
		| MENOS expr %prec UMENOS{ $$= addIrmao(criaNo((char*)"-"),addFilho(criaNo((char*)"expr"),$1));} 
		| %empty { $$=criaNo((char*)"NULL");} 
		;

exprseq:	 exprseq PVIR expr
		| expr
		;

exprlist:	 exprlist VIR expr
		| expr
		;

declist:	%empty{ $$=criaNo("NULL");}	 
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

typefields:	id { $$ = criaNo(strdup(yytext));}   
		| typefields VIR id
		;


functiondec:	FUNCTION id AP typefields FP ATT expr{ $$= addIrmao(criaNo((char*)"function"), addIrmao(addFilho(criaNo((char*)"id"), $1), addIrmao(criaNo((char*)"("),addIrmao(addFilho(criaNo((char*)"typefields"),$2),addIrmao(criaNo((char*)")"),addIrmao(criaNo((char*)":="),addFilho(criaNo((char*)"expr"),$3)))))));}
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


# Makefile

OBJS	= bison.o lex.o main.o

CC	= g++-7
CFLAGS	= -g -Wall -ansi -pedantic

trab:		$(OBJS)
		$(CC) $(CFLAGS) $(OBJS) -o trab -lfl

lex.o:		lex.c
		$(CC) $(CFLAGS) -c lex.c -o lex.o

lex.c:		trab.lex 
		flex trab.lex
		cp lex.yy.c lex.c

bison.o:	bison.c
		$(CC) $(CFLAGS) -c bison.c -o bison.o

bison.c:	trab.y
		bison -d -v --warnings trab.y
		cp trab.tab.c bison.c
		cmp -s trab.tab.h tok.h || cp trab.tab.h tok.h

main.o:		main.cc
		$(CC) $(CFLAGS) -c main.cc -o main.o

lex.o yac.o main.o	: heading.h
lex.o main.o		: tok.h

clean:
	rm -f *.o *~ lex.c lex.yy.c bison.c tok.h trab.tab.c trab.tab.h trab.output trab


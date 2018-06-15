# Makefile

OBJS	= bison.o lex.o main.o

CC	= g++
CFLAGS	= -g -Wall -ansi -pedantic 

tc--:		$(OBJS)
		$(CC) $(CFLAGS) $(OBJS) -o tc-- -lfl  

lex.o:		lex.c
		$(CC) $(CFLAGS) -c lex.c -o lex.o

lex.c:		tc--.lex 
		flex tc--.lex
		cp lex.yy.c lex.c

bison.o:	bison.c
		$(CC) $(CFLAGS) -c bison.c -o bison.o

bison.c:	tc--.y
		bison -v -d --warnings tc--.y
		cp tc--.tab.c bison.c
		cmp -s tc--.tab.h tok.h || cp tc--.tab.h tok.h

main.o:		main.cc
		$(CC) $(CFLAGS) -c main.c -o main.o

lex.o yac.o main.o	: heading.h
lex.o main.o		: tok.h

clean:
	rm -f *.o *~ lex.c lex.yy.c bison.c tok.h tc--.tab.c tc--.tab.h tc--.output tc--


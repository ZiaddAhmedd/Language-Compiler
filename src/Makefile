all:
	flex Lexer.l
	bison -d -t Parser.y
	gcc lex.yy.c parser.tab.c
	a.exe

clean:
	rm -f lex.yy.c lexer
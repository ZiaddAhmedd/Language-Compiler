all:
	flex Lexer.l
	bison -d -t Parser.y
	gcc lex.yy.c parser.tab.c TableQuad.c -o compiler.exe
	compiler.exe  ../src
clean:
	rm -f lex.yy.c lexer
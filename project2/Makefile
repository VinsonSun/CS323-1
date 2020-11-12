splc:
	@rm -rf bin/
	@rm -rf lex.yy.* syntax.tab.*
	@mkdir bin
	@touch bin/splc
	@chmod +x bin/splc
	@flex lex.l && bison -t -d syntax.y && gcc main.c tree.c syntax.tab.c -lfl -ly -o ./bin/splc
clean:
	@rm -rf bin/
	@rm -rf lex.yy.* syntax.tab.*
.PHONY: splc

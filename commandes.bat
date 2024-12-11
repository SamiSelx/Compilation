flex lexical.l
bison -d syntaxique.y
gcc lex.yy.c  syntaxique.tab.c -lfl -ly -o compil_isil.exe
compil_isil.exe<langage.txt

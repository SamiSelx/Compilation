%{
#include "syntaxique.tab.h"   
#include "TS.h"
int nb_ligne = 1;
extern YYSTYPE yylval;
%}
lettre [a-zA-Z]
chiffre [0-9]
IDF [A-Z]({lettre}|{chiffre}|[_]({lettre}|{chiffre}))*
cst (\+|\-)?{chiffre}+
reel (\+|\-)?{chiffre}+"."+{chiffre}+
string ["][^\n^\"]*["]
commentOneLine (\/\/)[^\n]* 
commentOneLine2 (#)[^\n]* 
CommentMultiLine (\/\*)([^*]|\*+[^\/])*(\*+\/)

%%
import  {
    inserer(yytext,"mot cle","","",2);
    return mc_import;
}
ISIL.math {
     inserer(yytext,"mot cle","","",2);
     return mc_Math;
}
ISIL.lang {
     inserer(yytext,"mot cle","","",2);
     return mc_lang;
}
ISIL.io {
    inserer(yytext,"mot cle","","",2);     
    return mc_io;
}
Programme {
     inserer(yytext,"mot cle","","",2); 
     return mc_prog;
}
PDec {
     inserer(yytext,"mot cle","","",2);
     return mc_dec;
}
Integer {
     inserer(yytext,"mot cle","","",2);
     return mc_integer;
}
Float {
    inserer(yytext,"mot cle","","",2);
    return mc_float;
}
InDebut {
    inserer(yytext,"mot cle","","",2);
    return mc_debut;
}
InFin {
    inserer(yytext,"mot cle","","",2);
    return mc_fin;
}
final {
    inserer(yytext,"mot cle","","",2);
    return mc_const;
}
Input {
    inserer(yytext,"mot cle","","",2);
    return mc_input;
}
Write {
     inserer(yytext,"mot cle","","",2);
     return mc_write;
}
for {
    inserer(yytext,"mot cle","","",2);
    return mc_for;
}
endfor {
     inserer(yytext,"mot cle","","",2);
     return mc_endfor;
}
do {
   inserer(yytext,"mot cle","","",2);
   return mc_do;
}
if {
   inserer(yytext,"mot cle","","",2);
   return mc_if;
}
else {
    inserer(yytext,"mot cle","","",2);
    return mc_else;
}
endif {
    inserer(yytext,"mot cle","","",2);
    return mc_endif;
}
; return pvg;
"++" return inc;
"--" return dec;
"<--" return affectation;
\>= return sup_ou_egal;
\<= return inf_ou_egal;
"==" return egal;
\!= return diff;
\&\& return mc_et;
"||" return mc_ou;
[\[\]\,\|\+\-\*\/\(\)\<\>\=\!] {
          inserer(yytext,"Separateur","","",3);
          return yytext[0];
}
{cst} {
    int number = atoi(yytext);
        if(!(atoi(yytext) >= -32768 && atoi(yytext) <= 32767)){
            printf("Erreur: '%d' doit etre entre -32768 et 32767\n",number);
        }else{
            yylval.entier=atoi(yytext);
            return cst;
        }
}
{reel} {
          yylval.numvrg=atof(yytext);
          return reel;
}
{string} return string;
{IDF} {
if (yyleng > 18) {
printf("Erreur:'%s' depasser 18 caracteres a la ligne %d\n", yytext, nb_ligne);
} else {
    yylval.str = strdup(yytext);
    inserer(yytext,"idf","","",1);
return idf;
}
}
{commentOneLine} 
{commentOneLine2}
{CommentMultiLine} {
    int i;
    for (i = 0; yytext[i] != '\0'; i++) {
        if (yytext[i] == '\n') nb_ligne++;
    }
}
[ \t]
\n {nb_ligne++;}

. printf("erreur lexicale dans la ligne %d \n",nb_ligne);
%%
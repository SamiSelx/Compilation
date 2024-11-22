%{
#include "syntaxique.tab.h"   
int nb_ligne = 1;
%}
lettre [a-zA-Z]
chiffre [0-9]
IDF [A-Z]({lettre}|{chiffre}|[_]({lettre}|{chiffre}))*
cst {chiffre}+
cstSigne (\+|\-){chiffre}+
reel {chiffre}+"."+{chiffre}+
%%
import return mc_import;
ISIL.math return mc_Math;
ISIL.lang return mc_lang;
ISIL.io return mc_io;
Programme return mc_prog;
PDec return mc_dec;
Integer return mc_integer;
Float return mc_float;
InDebut return mc_debut;
InFin return mc_fin;
final return mc_const;
Input return mc_input;
Write return mc_write;
\/\/[^\n]* return mc_cmnt_one_line;
\#[^\n]* return mc_cmnt_one_line2;
\/\*([^*]|\*+[^\/])*\*\/ return mc_cmnt_multi;
"=" return aff;
; return pvg;
[\[\]\,\|\-\+\*\/()] return yytext[0];
{cst} return cst;
{cstSigne} return cstSigne;
{reel} return reel;
["][^\n^\"]*["] return string;
{IDF} {
if (yyleng > 18) {
printf("Erreur:'%s' depasser 18 caracteres a la ligne %d\n", yytext, nb_ligne);
} else {
return idf;
}
}
[ \t]
\n {nb_ligne++;}

. printf("erreur lexicale dans la ligne %d \n",nb_ligne);
%%
%{
extern int nb_ligne;
extern int col;
#include "syntaxique.tab.h"   
#include "TS.h"
// int nb_ligne = 1;
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
    col= col + strlen(yytext);
    inserer(yytext,"mot cle","","",2);
    return mc_import;
}
ISIL.lang {
     inserer(yytext,"mot cle","","",2);
     col= col + strlen(yytext);
     return mc_lang;
}
ISIL.io {
    inserer(yytext,"mot cle","","",2);

    col= col + strlen(yytext);    
    return mc_io;
}
Programme {
     inserer(yytext,"mot cle","","",2);

     col= col + strlen(yytext); 
     return mc_prog;
}
PDec {
     inserer(yytext,"mot cle","","",2);

     col= col + strlen(yytext);
     return mc_dec;
}
Integer {
    yylval.str=strdup(yytext);
     inserer(yytext,"mot cle","","",2);

     col= col + strlen(yytext);
     return mc_integer;
}
Float {
    yylval.str=strdup(yytext);
    inserer(yytext,"mot cle","","",2);
    col= col + strlen(yytext);
    return mc_float;
}
InDebut {
    inserer(yytext,"mot cle","","",2);

    col= col + strlen(yytext);
    return mc_debut;
}
InFin {
    inserer(yytext,"mot cle","","",2);
    col= col + strlen(yytext);
    return mc_fin;
}
final {
    inserer(yytext,"mot cle","","",2);
    col= col + strlen(yytext);
    return mc_const;
}
Input {
    inserer(yytext,"mot cle","","",2);

    col= col + strlen(yytext);
    return mc_input;
}
Write {
     inserer(yytext,"mot cle","","",2);

     col= col + strlen(yytext);
     return mc_write;
}
For {
    inserer(yytext,"mot cle","","",2);
    col= col + strlen(yytext);
    return mc_for;
}
ENDFOR {
    inserer(yytext,"mot cle","","",2);

     col= col + strlen(yytext);
     return mc_endfor;
}
DO {
   inserer(yytext,"mot cle","","",2);
   col= col + strlen(yytext);
   return mc_do;
}
IF {
   inserer(yytext,"mot cle","","",2);
   col= col + strlen(yytext);
   return mc_if;
}
ELSE {
    inserer(yytext,"mot cle","","",2);
    col= col + strlen(yytext);
    return mc_else;
}
ENDIF {
    inserer(yytext,"mot cle","","",2);
    col= col + strlen(yytext);
    return mc_endif;
}
; { col= col + strlen(yytext); inserer(yytext,"Separateur","","",3); return pvg;}
"++" { col= col + strlen(yytext); inserer(yytext,"Separateur","","",3); return inc;}
"--" {col= col + strlen(yytext); inserer(yytext,"Separateur","","",3); return dec;}
"<--" {col= col + strlen(yytext); inserer(yytext,"Separateur","","",3); return affectation;}
\>= {col= col + strlen(yytext); inserer(yytext,"Separateur","","",3); return sup_ou_egal;}
\<= {col= col + strlen(yytext); inserer(yytext,"Separateur","","",3); return inf_ou_egal;}
"==" {col= col + strlen(yytext); inserer(yytext,"Separateur","","",3); return egal;}
\!= {col= col + strlen(yytext); inserer(yytext,"Separateur","","",3); return diff;}
\&\& {col= col + strlen(yytext); inserer(yytext,"Separateur","","",3); return mc_et;}
"||" {col= col + strlen(yytext); inserer(yytext,"Separateur","","",3); return mc_ou;}
[\[\]\,\|\+\-\*\/\(\)\<\>\=\!] {
          inserer(yytext,"Separateur","","",3);
          yylval.str = strdup(yytext);
          col= col+1;
          return yytext[0];
}
{cst} {
    yylval.entier = atoi(yytext);
    col= col + strlen(yytext);
        if(!(yylval.entier >= -32768 && yylval.entier <= 32767)){
            printf("Erreur: '%d' doit etre entre -32768 et 32767\n",yylval.entier);
        }else{
            
            return cst;
        }
}
{reel} {
         col= col + strlen(yytext);
          yylval.numvrg=atof(yytext);
          return reel;
}
{string} {col= col + strlen(yytext); yylval.str = strdup(yytext); return string;}
{IDF} {
col= col + strlen(yytext);
if (yyleng > 18) {
printf("Erreur:'%s' depasser 18 caracteres a la ligne %d\n", yytext, nb_ligne);
} else {
    yylval.str = strdup(yytext);
    inserer(yytext,"idf","","",1);
return idf;
}
}
{commentOneLine} {col= col + strlen(yytext);}
{commentOneLine2} {col= col + strlen(yytext);}
{CommentMultiLine} {
    int i;
    for (i = 0; yytext[i] != '\0'; i++) {
        if (yytext[i] == '\n') 
        {col=1; nb_ligne++;}
    }
}
[ \t]  {col= col + strlen(yytext);}
\n     {col=1; nb_ligne++;} 

. printf("Erreur lexicale : la ligne %d  colonne %d \n",nb_ligne, col);
%%
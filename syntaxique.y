%{
    int nb_ligne=1; 
    int col=1;
    char sauvType[20];
    char sauvIdf2[20];
    int sauvconst;
    float sauvfloat;
    char sauvOp[1];
%}

%union{
    int entier;
    char* str;
    float numvrg;
}


%token  mc_import mc_Math  mc_io mc_lang pvg mc_prog mc_dec  mc_const  mc_debut mc_fin mc_input mc_write  string mc_for mc_endfor mc_do inc  affectation mc_if mc_endif mc_else  sup_ou_egal inf_ou_egal egal diff mc_ou mc_et dec
%token <str>idf <entier>cst <numvrg>reel <str> mc_integer <str>mc_float  <str> '/'
%left mc_ou
%left mc_et
%left '!'
%left  '>' '<' sup_ou_egal inf_ou_egal egal diff
%right '='
%left '+''-'
%left '*''/'

%start S
%%
S: List_import Programme {printf("syntaxe correcte");
                YYACCEPT;};
List_import: mc_import Lib pvg List_import | ;              
Lib: mc_Math | mc_lang |mc_io;

Programme: mc_prog idf Dec Corps;
Dec: mc_dec List_dec;
List_dec:  Type_dec List_dec |;

Type_dec:Type List_idf
|mc_const Type idf '=' Constant pvg 
{ 
if (NonDeclaration($3) != 0){ 
    updateConst($3,"oui");
    updateType($3,sauvType);
}else{
    printf("Erreur Semantique: double declation de %s, a la ligne %d , colonne %d\n", $3, nb_ligne,col);
}
} 
|mc_const Type idf pvg 
{
if (NonDeclaration($3)!=0){ 
    updateConst($3,"oui");
    updateType($3,sauvType);
}else{
    printf("Erreur Semantique: double declation de %s, a la ligne %d , colonne %d\n", $3, nb_ligne,col);
}
};

List_idf: Var '|' List_idf |Var pvg;
Var :
idf 
{
if (NonDeclaration($1)!=0){ 
    updateConst($1,"non"); 
    updateType($1,sauvType); 
}else{
    printf("Erreur Semantique: double declation de %s, a la ligne %d , colonne %d\n", $1, nb_ligne,col);
}
 }
| idf '[' cst ']'
 {

if (NonDeclaration($1)!=0) {updateConst($1,"non"); updateType($1,sauvType); }
else 
{    printf("Erreur Semantique: double declation de %s, a la ligne %d , colonne %d\n", $1, nb_ligne,col);
}
 }; 

Type:mc_integer {strcpy(sauvType,$1)}|mc_float {strcpy(sauvType,$1)};


Corps: mc_debut List_inst mc_fin;

List_inst: Inst_aff List_inst | Inst_lecture List_inst| Inst_write List_inst | Inst_for List_inst |Inst_if List_inst | ;
Inst_lecture: mc_input '(' string ')' pvg | mc_input '(' string ',' List_idf_io')' pvg;
Inst_write: mc_write '(' string ')' pvg | mc_write '(' string ',' List_idf_io ')' pvg;
List_idf_io: idf ',' List_idf_io | idf;
Inst_aff: idf affectation Operation pvg 
{
if(NonDeclaration($1)== -1){updateConst($1,""); printf("Erreur Semantique: Entite %s non declarer ligne:%d colonne:%d \n",$1,nb_ligne,col);  }
else if(verifierAffectation($1,sauvIdf2) == -1){
    printf("Erreur Semantique: Incompatibilite de types entre %s et %s.\n",$1, sauvIdf2);
}
}
| idf '[' cst ']' affectation Operation pvg 
{
if(NonDeclaration($1)== -1) {updateConst($1,""); printf("Erreur Semantique: Entite %s non declarer ligne:%d colonne:%d \n",$1,nb_ligne,col);  }
else if(verifierAffectation($1,sauvIdf2) == -1){
    printf("Erreur Semantique: Incompatibilite de types entre %s et %s.\n",$1, sauvIdf2);
}
};



Operation: Value Op_arithmetiques Operation 
{    
    if(strcmp(sauvOp,"/")==0 && (sauvconst==0 || sauvfloat==0)){printf("Erreur Semantique : division pas zero ligne %d colonne %d\n",nb_ligne,col); sauvconst = -1; sauvfloat=-1;}  
    
}
| Value {if(strcmp(sauvOp,"/")==0 && sauvconst==0){printf("Erreur Semantique : division pas zero ligne %d colonne %d\n",nb_ligne,col); sauvconst = -1; sauvfloat=-1;}  
};



Value: idf 
{
strcpy(sauvIdf2,$1);
if(NonDeclaration($1) == -1) {updateConst($1,""); printf("Entite %s non declarer ligne:%d colonne:%d \n",$1,nb_ligne,col);  }

} 
| idf'[' cst ']'
{strcpy(sauvIdf2,$1);
if(NonDeclaration($1)== -1) {updateConst($1,""); printf("Entite %s non declarer ligne:%d colonne:%d \n",$1,nb_ligne,col);  }

}
|Constant| '(' Operation ')' ;

// Second Method:
/* Operation: Operation '+' Exp | Operation '-' Exp | Exp;
Exp: Value '*' Exp | Value '/' Exp | Value;
Value: idf | Constant | '(' Operation ')' ; */

/* Comment: Comment_one_line | mc_cmnt_multi;
Comment_one_line: mc_cmnt_one_line | mc_cmnt_one_line2; */
Constant : cst {sauvconst=$1;}| reel {sauvfloat=$1;};


Inst_for: mc_for '(' Declaration pvg List_Condition pvg Compteur ')' mc_do List_inst mc_endfor ;
Declaration:idf affectation Value
{if(NonDeclaration($1)== -1){printf("Entite %s non declarer ligne:%d colonne:%d \n",$1,nb_ligne,col);}  
else{ verifierAffectation($1,sauvIdf2);}
};
Compteur:idf inc| idf dec;


Inst_if: mc_if '(' List_Condition ')' mc_do List_inst mc_endif|Inst_if_else;
Inst_if_else: mc_if '(' List_Condition ')' mc_do List_inst mc_else List_inst mc_endif;
List_Condition: Condition| Condition Op_logiques List_Condition ;
Condition:Value Op_comparaison Value;


Op_comparaison:'>' |'<' |sup_ou_egal |inf_ou_egal |egal |diff;
Op_logiques:mc_ou |mc_et |'!'  ;
Op_arithmetiques: '-' | '+' | '*' | '/'{strcpy(sauvOp,$1);};
%%
main(){
    yyparse();
    affiche();
}
yywrap(){}
int yyerror ( char*  msg )  
{
    printf ("Erreur Syntaxique : a ligne %d a colonne %d \n", nb_ligne, col);
}
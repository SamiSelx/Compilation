%{
    typedef struct
    {
        int i_val;
        float f_val;
        int is_i_val;
    } ValueType;
    int nb_ligne=1; 
    int col=1;
    char sauvType[20];
    // int sauvValueInt;
    // float sauvValueFloat;
    // int isInt;
    ValueType val;
    int io_lib = 0;
    int lang_lib = 0;
    int indexIdf = 0;
    char formatTable[50];
    char idfTable[50][50];

%}

%union{
    int entier;
    char* str;
    float numvrg;
   
}


%token  mc_import  mc_io mc_lang pvg mc_prog mc_dec  mc_const  mc_debut mc_fin mc_input mc_write  mc_for mc_endfor mc_do inc  affectation mc_if mc_endif mc_else  sup_ou_egal inf_ou_egal egal diff mc_ou mc_et dec
%token <str>idf string <entier>cst <numvrg>reel <str> mc_integer <str>mc_float
%type <str>List_idf_io
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
Lib:  mc_lang {lang_lib = 1;} |mc_io {io_lib = 1};

Programme: mc_prog idf Dec Corps;
Dec: mc_dec List_dec;
List_dec:  Type_dec List_dec |;

Type_dec:
    Type List_idf 
    |mc_const Type idf '=' Constant pvg {updateType($3,sauvType); updateConst($3,"oui"); updateValue($3,val)} 
    |mc_const Type idf pvg {updateType($3,sauvType);updateConst($3,"oui");};
    |mc_const Type idf '[' cst ']' '=' Constant pvg 
    {
        // updateType($3,sauvType);  updateValue($3,val);sauvegarderTailleTable($3,$5);
        updateConst($3,"oui");
        if($5 <= 0){
            printf("Erreur semantique: la taille de tableau %s doit etre superieure a 0, a la ligne %d a la colonne %d\n",$3,nb_ligne,col);
        }else {
            updateType($3,sauvType); 
            updateValue($3,val);
            sauvegarderTailleTable($3,$5);
        }
    } 
    |mc_const Type idf '[' cst ']' pvg {
        updateConst($3,"oui");
    if($5 <= 0){
        printf("Erreur semantique: la taille de tableau %s doit etre strictement superieure a 0, a la ligne %d a la colonne %d\n",$3,nb_ligne,col);
    }else {
        updateType($3,sauvType); 
        sauvegarderTailleTable($3,$5);
    }
    };
List_idf: Var '|' List_idf |Var pvg;
Var :
idf 
{updateType($1,sauvType);
 updateConst($1,"non");}
| idf '[' cst ']'
 {
    updateConst($1,"non");
    if($3 <= 0){
        printf("Erreur semantique: la taille de tableau %s doit etre superieure a 0, a la ligne %d a la colonne %d\n",$1,nb_ligne,col);
    }else {
        updateType($1,sauvType); 
        sauvegarderTailleTable($1,$3);
    }
 }; 

Type:mc_integer {strcpy(sauvType,$1)}|mc_float {strcpy(sauvType,$1)};



Corps: mc_debut List_inst mc_fin;
List_inst: Inst_aff {if(lang_lib == 0) printf("Erreur semantique: bibliotheque ISIL.lang n'est pas declarer, a la ligne %d a la colonne %d\n",nb_ligne,col)}  List_inst 
        | Inst_lecture {if(io_lib == 0) printf("Erreur semantique: bibliotheque ISIL.io n'est pas declarer, a la ligne %d a la colonne %d\n",nb_ligne,col)} List_inst
        | Inst_write {if(io_lib == 0) printf("Erreur semantique: bibliotheque ISIL.io n'est pas declarer, a la ligne %d a la colonne %d\n",nb_ligne,col)}  List_inst 
        | Inst_for List_inst 
        |Inst_if List_inst | ;
Inst_lecture: mc_input '(' string ')' pvg 
            | mc_input '(' string ',' {indexIdf = 0;} List_idf_io')' pvg
            {   
                if(checkNumberVariable($3,indexIdf,formatTable) == -1){
                    printf("Erreur semantique: incompatible nombre variable declare, a la ligne %d a la colonne %d\n",nb_ligne,col);
                }else{
                    if(checkTypeFormat(formatTable,idfTable,indexIdf) == -1){
                        printf("Erreur semantique: incompatible de type des variables declare, a la ligne %d a la colonne %d\n",nb_ligne,col);
                    }
                }
            }; 
Inst_write: mc_write '(' string ')' pvg 
    | mc_write '(' string ',' {indexIdf = 0;} List_idf_io ')' pvg 
    {if(checkNumberVariable($3,indexIdf,formatTable) == -1){
        printf("Erreur semantique: incompatible nombre variable declare, a la ligne %d a la colonne %d\n",nb_ligne,col);
    }else{
        if(checkTypeFormat(formatTable,idfTable,indexIdf) == -1){
            printf("Erreur semantique: incompatible de type des variables declare, a la ligne %d a la colonne %d\n",nb_ligne,col);
        }
    }
    }; 
List_idf_io: idf ',' List_idf_io 
        {   
            // printf("after idf %s %c",$1,formatTabel[0]);
            strcpy(idfTable[indexIdf],$1);
            indexIdf++;
        }
        | idf {
            strcpy(idfTable[indexIdf],$1);
            indexIdf++
            };
Inst_aff: idf affectation Operation pvg 
{if(checkConstValue($1) == 0) 
    {printf("Erreur semantique: modification de la valeur d'une constante a la ligne %d a la colonne %d \n",nb_ligne,col);}
    else {
        updateValue($1,val);
    }
    }
    | idf '[' cst ']' affectation Operation pvg
    {if(checkConstValue($1) == 0) 
    {printf("Erreur semantique: modification de la valeur d'une constante a la ligne %d a la colonne %d \n",nb_ligne,col);}
    else {
        updateValue($1,val);
    }
    }
    ;
Operation: Value Op_arithmetiques Operation | Value ;
Value: Var | Constant | '(' Operation ')' ;
Constant : cst { val.i_val = $1; val.is_i_val = 1;}| reel { val.f_val = $1; val.is_i_val = 0;};

// Second Method:
/* Operation: Operation '+' Exp | Operation '-' Exp | Exp;
Exp: Value '*' Exp | Value '/' Exp | Value;
Value: idf | Constant | '(' Operation ')' ; */

/* Comment: Comment_one_line | mc_cmnt_multi;
Comment_one_line: mc_cmnt_one_line | mc_cmnt_one_line2; */


Inst_for: mc_for '(' Declaration pvg List_Condition pvg Compteur ')' mc_do List_inst mc_endfor ;
Declaration:idf affectation Value;
Compteur:idf inc| idf dec;

Inst_if: mc_if '(' List_Condition ')' mc_do List_inst mc_endif|Inst_if_else;
Inst_if_else: mc_if '(' List_Condition ')' mc_do List_inst mc_else List_inst mc_endif;
List_Condition: Condition| Condition Op_logiques List_Condition ;
Condition:Value Op_comparaison Value;


Op_comparaison: '>' | '<' | sup_ou_egal | inf_ou_egal | egal | diff;
Op_logiques:mc_ou | mc_et |'!'  ;
Op_arithmetiques: '-' | '+' | '*' | '/';
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
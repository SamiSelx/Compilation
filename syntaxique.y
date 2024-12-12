%{
    typedef struct
    {
        int i_val;
        float f_val;
        int is_i_val;
    } ValueType;
    typedef struct
    {
        int i_val;
        float f_val;
        char s_val[20];
        int type_val;    //0:int  1:float  2:string
    } Type_table;

    Type_table T[50];
    char V[50][1];
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
    int index_Op_Arith = 0;
    int index_Op = 0;
    char formatTable[50];
    char idfTable[50][50];
    char sauvIdf2[20];


    int sauvconst=-1;
    float sauvfloat=-1;
    char sauvOp[1];
    char type[20];

%}

%union{
    int entier;
    char* str;
    float numvrg;
}


%token  mc_import  mc_io mc_lang pvg mc_prog mc_dec  mc_const  mc_debut mc_fin mc_input mc_write  mc_for mc_endfor mc_do inc  affectation mc_if mc_endif mc_else  sup_ou_egal inf_ou_egal egal diff mc_ou mc_et dec
%token <str>idf string <entier>cst <numvrg>reel <str> mc_integer <str>mc_float  <str> '/' '+' '-' '*'
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
    |mc_const Type idf '=' Constant pvg {
    if (NonDeclaration($3) != 0){ 
    updateConst($3,"oui");
    updateType($3,sauvType);
    updateValue($3,val);
  }else{
      printf("Erreur Semantique: double declation de %s, a la ligne %d , colonne %d\n", $3, nb_ligne,col);
  }
  
    } 
    |mc_const Type idf pvg {
  
      if (NonDeclaration($3)!=0){ 
          updateConst($3,"oui");
          updateType($3,sauvType);
      }else{
          printf("Erreur Semantique: double declation de %s, a la ligne %d , colonne %d\n", $3, nb_ligne,col);
      }
    };
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
if (NonDeclaration($1)!=0) {
  if($3 <= 0){
        printf("Erreur semantique: la taille de tableau %s doit etre superieure a 0, a la ligne %d a la colonne %d\n",$1,nb_ligne,col);
    }else {
        updateType($1,sauvType); 
        sauvegarderTailleTable($1,$3);
    }
  updateConst($1,"non"); updateType($1,sauvType);
}
else 
{    printf("Erreur Semantique: double declation de %s, a la ligne %d , colonne %d\n", $1, nb_ligne,col);
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
Inst_aff: idf affectation {index_Op_Arith=0; index_Op=0;}Operation  pvg 
{

if(verifierDiv(T,V,index_Op) == -1){
    printf("Erreur Semantique: Division par zero, a la ligne:%d colonne:%d \n",$1,nb_ligne,col);
}
if(NonDeclaration($1)== -1){updateConst($1,""); printf("Erreur Semantique: Entite %s non declarer ligne:%d colonne:%d \n",$1,nb_ligne,col);  }
else if(checkConstValue($1) == 0) 
    {printf("Erreur semantique: modification de la valeur d'une constante a la ligne %d a la colonne %d \n",nb_ligne,col);}
    else  {
        char type1[20];
        char type2[20];
        searchTypeIdf($1,type1);
        if(val.is_i_val==1){strcpy(type2,"Integer");}
        if(val.is_i_val==0){strcpy(type2,"Float");}
        if(val.is_i_val==-1){
           searchTypeIdf(sauvIdf2,type2);
            }

//LE CAS: IDF<--- UN SEULE ARGUMENT 
       if(isCompatible(type1,type2) == -1 && index_Op==1){
        printf("Erreur Semantique (one arg passed): Incompatibilite de types  ligne %d colonne %d\n",nb_ligne,col);
        }else {
            updateValue($1,val);
         }
         
//LE CAS : IDF <-- LIST _AFFECT
        if(strcmp(type1,"Integer")==0 && index_Op>1){
        // on verifie type1='integer'?  ---> le float accept tout affect (int or float ) on a pas le cas string pour le verifier
       if (checkListCompatible(T,type1,index_Op)==-1 ){
        printf("Erreur Semantique (list passed): Incompatibilite de types ligne: %d colonne: %d.\n",nb_ligne,col);
       }
       }


       } 

      


}
    | idf '[' cst ']' affectation  Operation pvg
    {   
    if(NonDeclaration($1)== -1){updateConst($1,""); printf("Erreur Semantique: Entite %s non declarer ligne:%d colonne:%d \n",$1,nb_ligne,col);  }
    else if(checkConstValue($1) == 0) 
    {printf("Erreur semantique: modification de la valeur d'une constante a la ligne %d a la colonne %d \n",nb_ligne,col);}
    else {
        char type1[20];
        char type2[20];
        searchTypeIdf($1,type1);
        if(val.is_i_val==1){strcpy(type2,"Integer");}
        if(val.is_i_val==0){strcpy(type2,"Float");}
        if(val.is_i_val==-1){
           searchTypeIdf(sauvIdf2,type2);
            }
      //LE CAS: IDF<--- UN SEULE ARGUMENT 
       if(isCompatible(type1,type2) == -1 && index_Op==1){
        printf("Erreur Semantique (one arg passed): Incompatibilite de types  ligne %d colonne %d\n",nb_ligne,col);
        }else {
            updateValue($1,val);
         }
         
//LE CAS : IDF <-- LIST _AFFECT
        if(strcmp(type1,"Integer")==0 && index_Op>1){
        // on verifie type1='integer'?  ---> le float accept tout affect (int or float ) on a pas le cas string pour le verifier
       if (checkListCompatible(T,type1,index_Op)==-1 ){
        printf("Erreur Semantique (list passed): Incompatibilite de types ligne: %d colonne: %d.\n",nb_ligne,col);
       }
       }

       } 
    }
    ;
    
Operation: Value Op_arithmetiques Operation | Value ;

Value: idf 
{
strcpy(sauvIdf2,$1);

strcpy(T[index_Op].s_val,$1);
T[index_Op].type_val=2;    //
index_Op++;
val.is_i_val=-1;
if(NonDeclaration($1) == -1) {updateConst($1,""); printf("Entite %s non declarer ligne:%d colonne:%d \n",$1,nb_ligne,col);  }
else {getvalue($1,&sauvconst,&sauvfloat);}

} 
| idf'[' cst ']'
{//div par zero : for Array
    strcpy(sauvIdf2,$1);
val.is_i_val=-1;
if(NonDeclaration($1)== -1) {updateConst($1,""); printf("Entite %s non declarer ligne:%d colonne:%d \n",$1,nb_ligne,col);  }

}
|Constant
| '(' Operation ')' ;

Constant :
     cst {
        sauvconst=$1; val.i_val = $1; val.is_i_val = 1; T[index_Op].i_val=$1;
        T[index_Op].type_val=0;    //
        index_Op++;}
     | reel {
        sauvfloat=$1; val.f_val = $1; val.is_i_val = 0; T[index_Op].f_val=$1;
        T[index_Op].type_val=1;    //
        index_Op++;};

// Second Method:
/* Operation: Operation '+' Exp | Operation '-' Exp | Exp;
Exp: Value '*' Exp | Value '/' Exp | Value;
Value: idf | Constant | '(' Operation ')' ; */

/* Comment: Comment_one_line | mc_cmnt_multi;
Comment_one_line: mc_cmnt_one_line | mc_cmnt_one_line2; */


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
Op_arithmetiques: 
                '-' {strcpy(sauvOp,$1); strcpy(V[index_Op_Arith],sauvOp); index_Op_Arith++;}
                | '+' {strcpy(sauvOp,$1); strcpy(V[index_Op_Arith],sauvOp); index_Op_Arith++;}
                | '*' {strcpy(sauvOp,$1);  strcpy(V[index_Op_Arith],sauvOp); index_Op_Arith++;}
                | '/'{strcpy(sauvOp,$1);  strcpy(V[index_Op_Arith],sauvOp); index_Op_Arith++;};
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
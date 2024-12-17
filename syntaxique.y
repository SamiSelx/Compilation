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
        int type_val;    //0:int  1:float  2:idf
    } Type_table;

    ValueType sauvArr[20];
    int indexArray = 0;
    Type_table T[50];
    char V[50][1];
    int nb_ligne=1; 
    int col=1;
    char sauvType[20];
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


%token  mc_import  mc_io mc_lang pvg mc_prog mc_dec  mc_const  mc_debut mc_fin mc_input mc_write mc_for mc_endfor
        mc_do inc  affectation mc_if mc_endif mc_else  sup_ou_egal inf_ou_egal egal diff mc_ou mc_et dec
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
//-------La partie declaration  Bibliotheque-----------
S: List_import Programme {printf("syntaxe correcte");
                YYACCEPT;};
List_import: mc_import Lib pvg List_import | ;              
Lib:  mc_lang {lang_lib = 1;} |mc_io {io_lib = 1};

//-----------La partie PROGRAMME ----------------------
Programme: mc_prog idf Dec Corps;
Dec: mc_dec List_dec;
List_dec:  Type_dec List_dec |;

//----------La partie_Type Declaration ----------------
Type_dec:
    Type List_idf 
    |mc_const Type idf '=' Constant pvg {
        char typeConst[20];
        if(val.is_i_val == 1) strcpy(typeConst,"Integer");
        if(val.is_i_val == 0) strcpy(typeConst,"Float");
        updateConst($3," ");
        // Double declaration: entite declarer => double decalaration
        if (NonDeclaration($3) == 0){ 
            printf("Erreur Semantique: double declation de %s, a la ligne %d , colonne %d\n", $3, nb_ligne,col);
        }else if(isCompatible(sauvType,typeConst) == -1){
            printf("Erreur Semantique : Incompatibilite de types  ligne %d colonne %d\n",nb_ligne,col);
        }else{
            updateConst($3,"oui");
            updateType($3,sauvType);
            updateValue($3,val);
        }
    } 
    |mc_const Type idf pvg {
        updateConst($3," ");
        // Double declaration: entite declarer => double decalaration
        if (NonDeclaration($3)!=0){ 
          updateConst($3,"oui");
          updateType($3,sauvType);
        }else{
            printf("Erreur Semantique: double declation de %s, a la ligne %d , colonne %d\n", $3, nb_ligne,col);
        }
    };
    |mc_const Type idf '[' cst ']' '=' '[' List_Const ']' pvg 
    {
        Type_table arrayType[20];
        convertArrayType(sauvArr,&arrayType,indexArray);
        updateConst($3," ");
        if (NonDeclaration($3)==0) {
            printf("Erreur Semantique: double declation de %s, a la ligne %d , colonne %d\n", $3, nb_ligne,col);
        }else{
            if($5 <= 0){
                printf("Erreur semantique: la taille de tableau %s doit etre superieure a 0, a la ligne %d a la colonne %d\n",$3,nb_ligne,col);
            }if($5 < indexArray) printf("Erreur Semantique :  Depassement de la taille d un tableau ligne %d  colonne %d .\n",nb_ligne,col);
            else  if (checkListCompatible(arrayType,sauvType,indexArray) ==-1 ){
                    printf("Erreur Semantique (list passed): Incompatibilite de types ligne: %d colonne: %d.\n",nb_ligne,col);
                }
                else {
                    int i  = 0;   
                    updateConst($3,"oui");         
                    updateType($3,sauvType); 
                    sauvegarderTailleTable($3,$5);
                    allouerArray($3,$5);
                    while(i<indexArray){
                        updateValueArray($3,sauvArr[i],i);
                        i++;
                    }
            }
        }
            
    } 
    |mc_const Type idf '[' cst ']' pvg {
        updateConst($3," ");
    if (NonDeclaration($3)==0) {
            printf("Erreur Semantique: double declation de %s, a la ligne %d , colonne %d\n", $3, nb_ligne,col);
        }else {
            if($5 <= 0){
             printf("Erreur semantique: la taille de tableau %s doit etre strictement superieure a 0, a la ligne %d a la colonne %d\n",$3,nb_ligne,col);
            }else {
                updateConst($3,"oui");
                updateType($3,sauvType); 
                sauvegarderTailleTable($3,$5);
                allouerArray($3,$5);
            }
    }
    };

List_Const: Constant {sauvArr[indexArray] = val;indexArray++;} ',' List_Const | Constant{sauvArr[indexArray] = val;indexArray++;} ;

List_idf: Var '|' List_idf |Var pvg;
Var :
idf 
{
    updateConst($1," "); 
if (NonDeclaration($1)!=0){ 
    updateConst($1,"non"); 
    updateType($1,sauvType); 
}else{
    printf("Erreur Semantique: double declation de %s, a la ligne %d , colonne %d\n", $1, nb_ligne,col);
}
 }
| idf '[' cst ']'
 {
    updateConst($1," "); 
if (NonDeclaration($1)!=0) {
    updateConst($1," ");
  if($3 <= 0){
        printf("Erreur semantique: la taille de tableau %s doit etre superieure a 0, a la ligne %d a la colonne %d\n",$1,nb_ligne,col);
    }else {
        allouerArray($1,$3);
        updateType($1,sauvType); 
        sauvegarderTailleTable($1,$3);
        updateConst($1,"non");
    }
}
else 
{    printf("Erreur Semantique: double declation de %s, a la ligne %d , colonne %d\n", $1, nb_ligne,col);
}
 }; 

Type:mc_integer {strcpy(sauvType,$1)}|mc_float {strcpy(sauvType,$1)};



//------------------Partie Corps de Programme ----------------------
Corps: mc_debut List_inst mc_fin;

List_inst: Inst_aff {
            if(lang_lib == 0) printf("Erreur semantique: bibliotheque ISIL.lang n'est pas declarer, a la ligne %d a la colonne %d\n",nb_ligne,col);
        }  List_inst 
        | Inst_lecture {
            if(io_lib == 0) printf("Erreur semantique: bibliotheque ISIL.io n'est pas declarer, a la ligne %d a la colonne %d\n",nb_ligne,col);
            } List_inst
        | Inst_write {
            if(io_lib == 0) printf("Erreur semantique: bibliotheque ISIL.io n'est pas declarer, a la ligne %d a la colonne %d\n",nb_ligne,col);
            }  List_inst 
        | Inst_for List_inst 
        | Inst_if List_inst | ;

//-------------------------------------------------------------------
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

//-------------------------------------------------------------------
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

//--------------------------------------------------------------------
List_idf_io: idf ',' List_idf_io 
        { 
            if(NonDeclaration($1)== -1){
                updateConst($1,"");
                printf("Erreur Semantique: Entite %s non declarer ligne:%d colonne:%d \n",$1,nb_ligne,col);  
            }
            strcpy(idfTable[indexIdf],$1);
            indexIdf++;
        }
        | idf {
            if(NonDeclaration($1)== -1){
                updateConst($1,"");
                printf("Erreur Semantique: Entite %s non declarer ligne:%d colonne:%d \n",$1,nb_ligne,col);  
            }
            strcpy(idfTable[indexIdf],$1);
            indexIdf++
         };

//---------------------------------------------------------------------
Inst_aff: idf affectation {index_Op_Arith=0; index_Op=0;}Operation  pvg 
{
    strcpy(sauvOp,"");
    if(NonDeclaration($1)== -1){
        updateConst($1,"");
        printf("Erreur Semantique: Entite %s non declarer ligne:%d colonne:%d \n",$1,nb_ligne,col);  
    }
    else if(checkConstValue($1) == 0) 
        {
            printf("Erreur semantique: modification de la valeur d'une constante %s a la ligne %d a la colonne %d \n",$1,nb_ligne,col);
        }
        else if(isTable($1) != 0) printf("Erreur Semantique: Entite %s n'est pas une variable simple (mais une table), a la ligne:%d colonne:%d \n",$1,nb_ligne,col);
        else {
            char type1[20];
            char type2[20];
            searchTypeIdf($1,type1);
            if(val.is_i_val==1) strcpy(type2,"Integer");
            if(val.is_i_val==0) strcpy(type2,"Float");
            if(val.is_i_val==-1) searchTypeIdf(sauvIdf2,type2);

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
    if(NonDeclaration($1)== -1){
        updateConst($1,"");
        printf("Erreur Semantique: Entite %s non declarer ligne:%d colonne:%d \n",$1,nb_ligne,col);  
    }
    else if(checkConstValue($1) == 0) 
        {printf("Erreur semantique: modification de la valeur d'une constante a la ligne %d a la colonne %d \n",nb_ligne,col);}
    else if(isTable($1) == 0) printf("Erreur Semantique: Entite %s  n'est pas table(array), a la ligne:%d colonne:%d \n",$1,nb_ligne,col);
    //LE CAS : T[10] <-- UNE VAL  MAIS LA TABLE ET DE T[3]  3<10
     else if(getTailleTable($1) < $3){
            printf("Erreur Semantique :  Depassement de la taille d un tableau ligne %d  colonne %d .\n",nb_ligne,col);
        }
    //Tout les verifications de type avec l'expression 
    else {
        char type1[20];
        char type2[20];
        searchTypeIdf($1,type1);
        if(val.is_i_val==1) strcpy(type2,"Integer");
        if(val.is_i_val==0) strcpy(type2,"Float");
        if(val.is_i_val==-1) searchTypeIdf(sauvIdf2,type2);

        //LE CAS: T[cst]<--- UN SEULE ARGUMENT 
       if(isCompatible(type1,type2) == -1 && index_Op==1){
            printf("Erreur Semantique: (one arg passed): Incompatibilite de types  ligne %d colonne %d\n",nb_ligne,col);
        }else updateValueArray($1,val,$3);

         
        //LE CAS : T[cst] <-- LIST _AFFECT
        if(strcmp(type1,"Integer")==0 && index_Op>1){
            // on verifie type1='integer'?  ---> le float accept tout affect (int or float ) on a pas le cas string pour le verifier
            if (checkListCompatible(T,type1,index_Op)==-1 ){
                printf("Erreur Semantique: (list passed): Incompatibilite de types ligne: %d colonne: %d.\n",nb_ligne,col);
            }
        }
} 

};
    
//--------------------------------------------------------------------------------   
Operation: Value { 
    // Division par Zero
    if(strcmp(sauvOp,"/")==0 && (sauvconst==0 || sauvfloat==0)){
        printf("Erreur Semantique: Division par zero, a la ligne:%d colonne:%d \n",nb_ligne,col);
        sauvconst = -1; sauvfloat=-1;  
    } 
    } Op_arithmetiques Operation 

 | Value
    {    
        if(strcmp(sauvOp,"/")==0 && (sauvconst==0 || sauvfloat==0)){
            printf("Erreur Semantique: Division par zero, a la ligne:%d colonne:%d \n",nb_ligne,col);
            sauvconst = -1; sauvfloat=-1;
        }  
    } ;


//--------------------------------------------------------------------------------
Value: idf 
{
strcpy(sauvIdf2,$1);

strcpy(T[index_Op].s_val,$1);
    T[index_Op].type_val=2; 
    index_Op++;
    val.is_i_val=-1;
    if(NonDeclaration($1) == -1) {
        updateConst($1,"");
        printf("Erreur Semantique: Entite %s non declarer ligne:%d colonne:%d \n",$1,nb_ligne,col);  
    } if(isTable($1) != 0) printf("Erreur Semantique: Entite %s n'est pas une variable simple (mais une table), a la ligne:%d colonne:%d \n",$1,nb_ligne,col);
    else {
        char typeIdf[20];
        getvalue($1,&sauvconst,&sauvfloat);
        searchTypeIdf($1,typeIdf);
        if(strcmp(typeIdf,"Integer") == 0){
            val.is_i_val = 1;
            val.i_val = sauvconst;
        }
        if(strcmp(typeIdf,"Float") == 0){
            val.is_i_val = 0;
            val.f_val = sauvfloat;
        }
    }

} 
| idf'[' cst ']'
{
    strcpy(sauvIdf2,$1);
    val.is_i_val=-1;
    if(NonDeclaration($1)== -1) {
        updateConst($1,"");
        printf("Erreur Semantique: Entite %s non declarer ligne:%d colonne:%d \n",$1,nb_ligne,col);  
    }else if(isTable($1) == 0) printf("Erreur Semantique: Entite %s n'est pas table(array), a la ligne:%d colonne:%d \n",$1,nb_ligne,col);
  else if(getTailleTable($1) < $3){
          printf("Erreur Semantique :  Depassement de la taille d un tableau ligne %d  colonne %d .\n",nb_ligne,col);
       }
    else{
        getvalueArray($1,$3,&val);
        if(val.is_i_val == 1){
            sauvconst = val.i_val;
            sauvfloat = -1;
        }else{
            sauvfloat=  val.f_val ;
            sauvconst = -1;
        }
    }

}
|Constant
| '(' Operation ')' ;


//-------------------------------------------------------------
Constant :
     cst {
        sauvconst=$1; val.i_val = $1; val.is_i_val = 1; T[index_Op].i_val=$1;
        T[index_Op].type_val=0;    //int
        index_Op++;}
     | reel {
        sauvfloat=$1; val.f_val = $1; val.is_i_val = 0; T[index_Op].f_val=$1;
        T[index_Op].type_val=1;    //float
        index_Op++;
        
        };

//--------------------INST_FOR --------------------------------
Inst_for: mc_for '(' Declaration pvg List_Condition pvg Compteur ')' mc_do List_inst mc_endfor ;
Declaration:idf affectation Value
{if(NonDeclaration($1)== -1){printf("Erreur Semantique: Entite %s non declarer ligne:%d colonne:%d \n",$1,nb_ligne,col);}  
else{ verifierAffectation($1,sauvIdf2);}
};
Compteur:idf inc| idf dec;

//----------------------INST_IF -------------------------------
Inst_if: mc_if '(' List_Condition ')' mc_do List_inst mc_endif|Inst_if_else;
Inst_if_else: mc_if '(' List_Condition ')' mc_do List_inst mc_else List_inst mc_endif;
List_Condition: Condition| Condition Op_logiques List_Condition ;
Condition:Value Op_comparaison Value;



//--------------TOUT LES OPERATIONS ----------------------
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
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// Type de Champ Valeur dans la TS
typedef struct
{
    int i_val;
    float f_val;
    int is_i_val; // 0:float 1:int -1: string
} ValueType;

// Type de table utiliser pour analyser l'expression arithmetique
typedef struct
{
    int i_val;
    float f_val;
    char s_val[20];
    int type_val;    //0:int  1:float  2:string
} Type_table;


// Types des champ de la TS
typedef struct
{
    char nomEntite[20];
    char codeEntite[20];
    char type[20];
    ValueType val;
    int hasvalue;
    char Constant[4]; // non:n'est pas const     oui :cst
    int taille_table;
    int isTable;
} TypeTs;

// Type de la table de séparateur et mot clé
typedef struct
{
    char nomEntite[20];
    char codeEntite[20];
} TypeSM;

// Type pour les champs de Array 
typedef struct
{
    int adresse;
    char nomEntite[20];
    ValueType val;
    int hasvalue;
    int index;
} TypeArray;

// cellule table de symbole
typedef struct celluleTs
{
    TypeTs info;
    struct celluleTs *suiv;
} celluleTs;

// cellule table séparateur et mot clé
typedef struct celluleSM
{
    TypeSM info;
    struct celluleSM *suiv;
} celluleSM;


// cellule Array
typedef struct celluleArray
{
    TypeArray info;
    struct celluleArray *suiv;
} celluleArray;

// declaration des listes
typedef struct celluleSM *listSM;
typedef struct celluleTs *listTs;
typedef struct celluleArray *listArray;

listTs t, q;
listSM tS, qS;
listSM tM, qM;
listArray tArray,qArray;

// Initialise l'adresse de Array
int adresse = 0;

// appele dans la partie declaration pour reserver les cases
void allouerArray(char nomEntite[],int taille){
    listArray p = tArray;
    int i = 0;
    // la premier tuple de Array (initialise la tete)
    if(adresse == 0){
        tArray = (listArray)malloc(sizeof(celluleArray));
        strcpy(tArray->info.nomEntite, nomEntite);
        tArray->info.index = i;
        tArray->info.hasvalue = 0;
        tArray->info.adresse = adresse;
        tArray->suiv = NULL;
        qArray = tArray;
        i++;
        adresse++;
    }
    while(i<taille){
        listArray nouv = (listArray)malloc(sizeof(celluleArray));
        strcpy(nouv->info.nomEntite, nomEntite);
        nouv->info.index = i;
        nouv->info.hasvalue = 0;
        nouv->info.adresse = adresse;
        nouv->suiv = NULL;
        qArray->suiv = nouv;
        qArray = nouv;
        i++;
        adresse++;
    }
}

// fonction permet de mettre a jour la valeur dans Array
void updateValueArray(char nomEntite[],ValueType val,int index){
    listArray p = tArray;
    int i = 0;
    while(p != NULL){
        if(strcmp(p->info.nomEntite,nomEntite) == 0){
            while(i<index){
                p = p->suiv;
                i++;
            }
            p->info.val.is_i_val = val.is_i_val;
            p->info.val.i_val = val.i_val;
            p->info.val.f_val = val.f_val;
            p->info.hasvalue = 1;
            break;
        }
        p = p->suiv;
    }
}

// Recherche si l'entite existe dans la TS
int recherche(char nomEntite[], int y)
{
    switch (y)
    {
    case 1:
    {
        listTs p = t;
        while (p != NULL)
        {
            if (strcmp(nomEntite, p->info.nomEntite) == 0)
            {
                return 1;
            }
            p = p->suiv;
        }
    }
    break;
    case 2:
    {
        listSM p = tM;
        while (p != NULL)
        {
            if (strcmp(nomEntite, p->info.nomEntite) == 0)
            {
                return 1;
            }
            p = p->suiv;
        }
    }
    break;
    case 3:
    {
        listSM p = tS;
        while (p != NULL)
        {
            if (strcmp(nomEntite, p->info.nomEntite) == 0)
            {
                return 1;
            }
            p = p->suiv;
        }
    }
    break;
    default:
        return -1;
    }
    return -1;
}

// Insertion de cellule dans la TS
void inserer(char nomEntite[], char codeEntite[], char type[],char Constant[],int y)
{
    if (recherche(nomEntite, y) == -1)
    {
        switch (y)
        {
        case 1:
        {
            if (t == NULL)
            {
                t = (listTs)malloc(sizeof(celluleTs));
                strcpy(t->info.nomEntite, nomEntite);
                strcpy(t->info.codeEntite, codeEntite);
                strcpy(t->info.type, type);
                t->info.hasvalue = 0;
                strcpy(t->info.Constant, Constant);
                t->suiv = NULL;
                q = t;
            }
            else
            {
                listTs nouv = (listTs)malloc(sizeof(celluleTs));
                strcpy(nouv->info.nomEntite, nomEntite);
                strcpy(nouv->info.codeEntite, codeEntite);
                strcpy(nouv->info.type, type);
                t->info.hasvalue = 0;
                strcpy(t->info.Constant, Constant);;
                nouv->suiv = NULL;
                q->suiv = nouv;
                q = nouv;
            }
        }
        break;
        case 2:
        {
            if (tM == NULL)
            {
                tM = (listSM)malloc(sizeof(celluleSM));
                strcpy(tM->info.nomEntite, nomEntite);
                strcpy(tM->info.codeEntite, codeEntite);
                tM->suiv = NULL;
                qM = tM;
            }
            else
            {
                listSM nouv = (listSM)malloc(sizeof(celluleSM));
                strcpy(nouv->info.nomEntite, nomEntite);
                strcpy(nouv->info.codeEntite, codeEntite);
                nouv->suiv = NULL;
                qM->suiv = nouv;
                qM = nouv;
            }
        }
        break;
        case 3:
        {
            if (tS == NULL)
            {
                tS = (listSM)malloc(sizeof(celluleSM));
                strcpy(tS->info.nomEntite, nomEntite);
                strcpy(tS->info.codeEntite, codeEntite);
                tS->suiv = NULL;
                qS = tS;
            }
            else
            {
                listSM nouv = (listSM)malloc(sizeof(celluleSM));
                strcpy(nouv->info.nomEntite, nomEntite);
                strcpy(nouv->info.codeEntite, codeEntite);
                nouv->suiv = NULL;
                qS->suiv = nouv;
                qS = nouv;
            }
        }
        default:
            break;
        }
    }
}

// Affichage TS
void affiche()
{
    printf("\n\n/***************Table des symboles IDF*************/\n");
    printf("_____________________________________________________________________________________\n");
    printf("\t| Nom_Entite |  Code_Entite | Type_Entite | Val_Entite   |    Const    | Taille_Tab \n");
    printf("______________________________________________________________________________________\n");
    if (t == NULL)
    {
        printf("liste est vide");
    }
    else
    {
        listTs p = t;
        while (p != NULL)
        {
            if(p->info.hasvalue != 1){
                printf("\t|%11s |%12s | %12s | %12s | %12s |", p->info.nomEntite, p->info.codeEntite, p->info.type,"--------",p->info.Constant);
            } else {
                if(p->info.val.is_i_val == 0){
                    printf("\t|%11s |%12s | %12s | %12f | %12s |", p->info.nomEntite, p->info.codeEntite, p->info.type, p->info.val.f_val,p->info.Constant);
                } else printf("\t|%11s |%12s | %12s | %12d | %12s |", p->info.nomEntite, p->info.codeEntite, p->info.type, p->info.val.i_val,p->info.Constant);
            }
            if(p->info.isTable == 1) printf(" %d",p->info.taille_table);
                else printf("--------");
            printf("\n");
            p = p->suiv;
        }
    }
    printf("\n/***************Table des symboles 'Mot Cle' ******************/\n");

    printf("____________________________________\n");

    printf("\t| NomEntite | CodeEntite | \n");

    printf("____________________________________\n");
    if (tM == NULL)
    {
        printf("liste est vide");
    }
    else
    {
        listSM p = tM;
        while (p != NULL)
        {
            printf("\t|%11s |%12s\n", p->info.nomEntite, p->info.codeEntite);
            p = p->suiv;
        }
    }

    printf("____________________________________\n");

    printf("\n/***************Table des symboles 'Separateur' ******************/\n");

    printf("____________________________________\n");

    printf("\t| NomEntite | CodeEntite | \n");

    printf("____________________________________\n");
    if (tS == NULL)
    {
        printf("liste est vide");
    }
    else
    {
        listSM p = tS;
        while (p != NULL)
        {
            printf("\t|%11s |%12s\n", p->info.nomEntite, p->info.codeEntite);
            p = p->suiv;
        }
    }
    printf("____________________________________\n");

    // Array:
    printf("\n/***************Table ARRAY ******************/\n");

    printf("__________________________________________________________________\n");

    printf("\t| Adresse    | NomEntite     |   Value      | index       | \n");

    printf("__________________________________________________________________\n");

    
        listArray p = tArray;
        while (p != NULL)
        {
            if(p->info.hasvalue != 1){
                printf("\t| @%11d |%12s | %12s |%12d |\n",p->info.adresse, p->info.nomEntite, "--------",p->info.index);
            } else {
                if(p->info.val.is_i_val == 0){
                    printf("\t| @%11d |%12s | %12f |%12d |\n", p->info.adresse,p->info.nomEntite,  p->info.val.f_val,p->info.index);
                } else printf("\t| @%11d |%12s | %12d |%12d |\n", p->info.adresse,p->info.nomEntite,  p->info.val.i_val,p->info.index);
            }
            p = p->suiv;
        }
    
    printf("____________________________________\n");
}

// fonction permet de mettre a jour le type de variable
void updateType(char nomEntite[], char newType[]) {

    listTs current = t;
    while (current != NULL) {
        if (strcmp(current->info.nomEntite, nomEntite) == 0 )  {
            strcpy(current->info.type, newType);
        }
        
        current = current->suiv;
    }
}

// fonction permet de mettre a jour le champ constante
void updateConst(char nomEntite[], char cst[]) {
   
    listTs current = t;
    while (current != NULL) {
        if (strcmp(current->info.nomEntite, nomEntite) == 0) {
            strcpy(current->info.Constant, cst);
        }
        current = current->suiv;
    }
}

// fonction permet de verifier si le constant a une valeur, si oui:0, non:-1
int checkConstValue(char nomEntite[]){
    listTs p = t;
    while(p != NULL){
        if(strcmp(p->info.nomEntite,nomEntite) == 0 && strcmp(p->info.Constant,"oui") == 0){
            if(p->info.hasvalue != 1) return -1;
            return 0;
        }
        p = p->suiv;
    }
    return -1;
}

// fonction permet de sauvegarder la taille d'une tableau dans la TS
void sauvegarderTailleTable(char nomEntite[],int taille){
    listTs p = t;
    while(p != NULL){
        if(strcmp(p->info.nomEntite,nomEntite) == 0){
            p->info.isTable = 1;
            p->info.taille_table = taille;
        }
        p = p->suiv;
    }
}

// fonction permet de verifier si le nombre de variable égale a nombre de formatage (%d|%f)
int checkNumberVariable(char string[],int numberVariable,char formatTable[]){
    int numberFormat = 0;
    int i = 0;
    // chercher les formats %* et on sauvegarde dans la table formatTable
    while(string[i] != '\0'){
        // Future: ajoute cette condition string[i+1] == 's' || string[i+1] == 'c'
        if(string[i] == '%' && (string[i+1] == 'd' || string[i+1] == 'f')){
            formatTable[numberFormat] = string[i+1];
            numberFormat++;
        };
        i++;
    }
    if(numberFormat == numberVariable) return 0;
    return -1;
}

// fonction permet de verifier compatibilité des types entre format et le type de variable
int checkTypeFormat(char formatTable[],char idfTable[][50],int size){
    int i=0;
    char typeIdf[20];
    while(i<size){
        listTs p = t;
        while(p != NULL){
            if(strcmp(p->info.nomEntite,idfTable[size - i - 1]) == 0){
                switch (formatTable[i])
                {
                    case 'd':
                        if(strcmp(p->info.type,"Integer") != 0) return -1;
                        break;
                    case 'f':
                        if(strcmp(p->info.type,"Float") != 0) return -1;
                        break;
                    default:
                        break;
                }
                break;
            }
            p = p->suiv;
        }
        i++;
    }
    return 0;
}

// Procédure permet de sauvegarder le type de l'IDF dans la variable typeIdf
void searchTypeIdf(char nomEntite[],char typeIdf[]){
    listTs p = t;
    while(p != NULL){
        if(strcmp(p->info.nomEntite,nomEntite) == 0){
            strcpy(typeIdf,p->info.type);
        }
        p = p->suiv;
    }
}

// fonction permet de verifier si l'IDF a été déja déclarer: oui:0, non:-1
int  NonDeclaration(char nomEntite[]){
    //si les deux champ sont remplie nomEntite Type   
    listTs current = t;
    while (current != NULL) {
        if (strcmp(current->info.nomEntite, nomEntite) == 0) {
            if(strcmp(current->info.type, "") != 0) return 0; //declarer
            return -1;//non dec
        }
        current = current->suiv;
    }
    return -1; //non dec
}

// fonction permet de verifier compatibilité de type entre deux variable
int verifierAffectation(char entite1[], char entite2[]){
    char type1[20];
    char type2[20];
    searchTypeIdf(entite1,type1);
    searchTypeIdf(entite2,type2);
    return isCompatible(type1, type2);
}

int isCompatible(char type1[], char type2[]) {
    //isCompatible -->0 ok
    //             -->-1 non compatible

    if (strcmp(type1, type2) == 0) {
        return 0; 
    }    
    if (strcmp(type1, "Float") == 0 && strcmp(type2, "Integer") == 0) {
        return 0; //float f=2.4            int x=6
                  // int x=f; non    But   float f=x  ok
    }
    return -1; 
}

// Procédure permet de sauvegarder la valeur d'une entité dans val_i et val_f
void getvalue(char nomEntite[],int *val_i,float *val_f){
listTs current = t;
while (current != NULL) {
    if (strcmp(current->info.nomEntite, nomEntite) == 0) {

        if (strcmp(current->info.type,"Integer")==0){
        *val_i=current->info.val.i_val;
        *val_f = -1;
        }else if(strcmp(current->info.type,"Float")==0) {
        *val_f=current->info.val.f_val;
        *val_i = -1;
        }  
    }
    current = current->suiv;
}

}

// fonction permet de vérifier compatibilité de type en utilisant ensemble des valeurs 
int checkListCompatible(Type_table T[],char type1[],int size){
    int i=0;
    char type2[20];

   while(i<size){

    if(T[i].type_val==0){
       //integer
       strcpy(type2,"Integer");
    }
    if(T[i].type_val==1){
        //float
         strcpy(type2,"Float");
    }
    if(T[i].type_val==2){
        //idf 
        searchTypeIdf(T[i].s_val,type2);
       
    }

        
        if(isCompatible(type1,type2)!=0){
            return -1; //un de T[i] n'est pas compatible avec idf1 
        }
        i++;
    }
    return 0; //la table des operandes est compatible avec le idf1
    
}

// Fonction permet de vérifier si l'entité est une table
int isTable(char nomEntite[]){
    listTs p = t;
    while (p != NULL)
    {
        if(strcmp(p->info.nomEntite,nomEntite)==0){
            if(p->info.isTable != 1) return 0;
            return 1;
        }
        p = p->suiv;
    }
    return -1; // idf n'existe pas
  
}

// fonction retourne la taille de tableau
int getTailleTable( char nomEntite[]){
    listTs current = t;
    while (current != NULL) {
        if (strcmp(current->info.nomEntite, nomEntite) == 0) {
        return current -> info.taille_table;
        
        }
        current = current->suiv;
    }
    return -1;
}

// Procédure permet de mettre a jour la valeur d'une entité
void updateValue(char nomEntite[],ValueType val ){
    listTs p = t;
    while(p != NULL){
        if(strcmp(p->info.nomEntite,nomEntite) == 0){   
            p->info.val.is_i_val = val.is_i_val;
            p->info.val.i_val = val.i_val;
            p->info.val.f_val = val.f_val;
            p->info.hasvalue = 1;
        }
        p = p->suiv;
    }
}

// Procédure permet de sauvegarder la valeur de Array dans val
void getvalueArray(char nomEntite[],int index,ValueType *val){
listArray current = tArray;
while (current != NULL) {
    if (strcmp(current->info.nomEntite, nomEntite) == 0 && current->info.index == index) {
        val->f_val =  current->info.val.f_val;
        val->i_val =  current->info.val.i_val;
        val->is_i_val =  current->info.val.is_i_val;
    }
    current = current->suiv;
}
}


int searchValueArray(char nomEntite[],int index){
   listArray current = tArray;
while (current != NULL) {
    if (strcmp(current->info.nomEntite, nomEntite) == 0 && current->info.index == index) {
    
       if(current->info.hasvalue==1){
        return 1;// a une val
       }
       else {
        return 0; //pas de val
       }
    }
    current = current->suiv;
} 
    
    return -1; //autre err
}
  void convertArrayType(ValueType array[],Type_table arrayType[],int size){
    int i=0;
    while(i<size){
        arrayType[i].i_val = array[i].i_val;
        arrayType[i].f_val = array[i].f_val;
        if(array[i].is_i_val == 1) arrayType[i].type_val = 0;
        else if(array[i].is_i_val == 0) arrayType[i].type_val = 1;
            else  arrayType[i].type_val = 2;
        i++;
    }
}

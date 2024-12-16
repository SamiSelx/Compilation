#include <stdlib.h>
#include <stdio.h>
#include <string.h>

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

typedef struct
{
    char nomEntite[20];
    char codeEntite[20];
} TypeSM;

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
int adresse = 0;

// appele dans la partie declaration pour reserver les cases
void allouerArray(char nomEntite[],int taille){
    listArray p = tArray;
    int i = 0;
    if(adresse == 0){
        tArray = (listArray)malloc(sizeof(celluleArray));
        strcpy(tArray->info.nomEntite, nomEntite);
        tArray->info.index = i;
        tArray->info.hasvalue = 0;
        tArray->info.adresse = adresse;
        // tArray->info.val = NULL;
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
        // nouv->info.val = NULL;
        nouv->suiv = NULL;
        qArray->suiv = nouv;
        qArray = nouv;
        i++;
        adresse++;
    }
}

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
                // t->info.val = NULL;
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
                // nouv->info.val = NULL;
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
    if (t == NULL)
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
    if (t == NULL)
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

void updateType(char nomEntite[], char newType[]) {

    listTs current = t;
    while (current != NULL) {
        if (strcmp(current->info.nomEntite, nomEntite) == 0 )  {
            strcpy(current->info.type, newType);
        }
        
        current = current->suiv;
    }
}

void updateConst(char nomEntite[], char cst[]) {
   
    listTs current = t;
    while (current != NULL) {
        if (strcmp(current->info.nomEntite, nomEntite) == 0) {
            strcpy(current->info.Constant, cst);
        }
        current = current->suiv;
    }
}

// check constant | updating Values PART

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

int checkNumberVariable(char string[],int numberVariable,char formatTable[]){
    int numberFormat = 0;
    int i = 0;
    while(string[i] != '\0'){
        if(string[i] == '%' && (string[i+1] == 'd' || string[i+1] == 'f' || string[i+1] == 's' || string[i+1] == 'c')){
            formatTable[numberFormat] = string[i+1];
            numberFormat++;
        };
        i++;
    }
    if(numberFormat == numberVariable) return 0;
    return -1;
}

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

void searchTypeIdf(char nomEntite[],char typeIdf[]){
    listTs p = t;
    while(p != NULL){
        if(strcmp(p->info.nomEntite,nomEntite) == 0){
            strcpy(typeIdf,p->info.type);
        }
        p = p->suiv;
    }
}


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

int verifierDiv( Type_table T[],char V[][1],int size){
int i ;
for(i=0;i<size - 1;i++){
    
    if(T[i+1].type_val==0){
        if(T[i+1].i_val == 0 && V[i][0] == '/'){
            return -1;
        }
    }
    if(T[i+1].type_val==1){
        if(T[i+1].f_val == 0 && V[i][0] == '/'){
            return -1;
        }
    }
    if(T[i+1].type_val==2){
        int x1;
        float x2;
        char x3[20];
        
        searchTypeIdf(T[i+1].s_val,x3);
        
        getvalue(T[i+1].s_val,&x1,&x2);
        if(strcmp(x3,"Integer")==0){
             if(x1 == 0 && V[i][0] == '/'){
            return -1;
            }
            
        }

        if(strcmp(x3,"Float")==0){
             if(x2 == 0 && V[i][0] == '/'){
            return -1;
            }
            
        }

         }
    }
    return 0;

}




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
            break;
        }
        i++;
    }
    return 0; //la table des operandes est compatible avec le idf1
    
}

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


void updateValue(char nomEntite[],ValueType val ){
    listTs p = t;
    while(p != NULL){
        if(strcmp(p->info.nomEntite,nomEntite) == 0){   
            // we don't have idf that we want his value
            
            // if(val.is_i_val == -1){
            //     char type[20];
            //     int xEntier;
            //     float xReel;
            //     getvalue(nomEntite,&xEntier,&xReel);
            //     printf("val float %f entier %d",xEntier,xReel);
            //     searchTypeIdf(nomEntite,type);
            //     if(strcmp(type,"Integer") == 0){
            //         val.is_i_val = 1;
            //         val.i_val = xEntier;
            //     }
            //     if(strcmp(type,"Float") == 0){
            //         val.is_i_val = 0;
            //         val.f_val = xReel;
            //     }
            // }
            p->info.val.is_i_val = val.is_i_val;
            p->info.val.i_val = val.i_val;
            p->info.val.f_val = val.f_val;
            p->info.hasvalue = 1;
        }
        p = p->suiv;
    }
}
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

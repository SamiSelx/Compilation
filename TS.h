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
    char nomEntite[20];
    char codeEntite[20];
    char type[20];
    // int val;   // "-":pas de val
    // int i_val;
    // float f_val;
    // int is_i_val;
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

// declaration des listes
typedef struct celluleSM *listSM;
typedef struct celluleTs *listTs;

listTs t, q;
listSM tS, qS;
listSM tM, qM;

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

// listTs recherche(char entite[])
// {
//     listTs p = t;
//     while(p != NULL){
//         if(strcmp(entite,p->info.nomEntite) == 0){
//             return p;
//         }
//         p = p->suiv;
//     }
//     return NULL;
// }

// void inserer(char entite[], char code[])
// {
//     if (recherche(entite) == NULL)
//     {
//         if (t == NULL)
//         {
//             t = (listTs)malloc(sizeof(celluleTs));
//             strcpy(t->info.nomEntite, entite);
//             strcpy(t->info.codeEntite, code);
//             t->suiv = NULL;
//             q = t;
//         }
//         else
//         {
//             listTs nouv = (listTs)malloc(sizeof(celluleTs));
//             strcpy(nouv->info.nomEntite, entite);
//             strcpy(nouv->info.codeEntite, code);
//             nouv->suiv = NULL;
//             q->suiv = nouv;
//             q = nouv;
//         }
//     }
// }

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
}

void updateType(char nomEntite[], char newType[]) {
   //adding search if the type is empty 
    listTs current = t;
    while (current != NULL) {
        if (strcmp(current->info.nomEntite, nomEntite) == 0) {
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

void updateValue(char nomEntite[],ValueType val ){
    listTs p = t;
    while(p != NULL){
        if(strcmp(p->info.nomEntite,nomEntite) == 0){
            // printf("\n entite %s  %d\n",p->info.nomEntite,f_val);
            // printf("entite %s has %f",p->info.nomEntite,p->info.f_val);
            p->info.val.is_i_val = val.is_i_val;
            p->info.val.i_val = val.i_val;
            p->info.val.f_val = val.f_val;
            // p->info.val.is_i_val = value.is_i_val;
            // p->info.val.i_val = value.i_val;
            // p->info.val.f_val = value.f_val;
            p->info.hasvalue = 1;
        }
        p = p->suiv;
    }
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

// will use it later to make function checkTypeFormat readable
void searchTypeIdf(char nomEntite[],char typeIdf[]){
    listTs p = t;
    while(p != NULL){
        if(strcmp(p->info.nomEntite,nomEntite) == 0){
            strcpy(typeIdf,p->info.type);
        }
        p = p->suiv;
    }
}

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct
{
    char nomEntite[20];
    char codeEntite[20];
    char type[20];
    char val[20];   // "-":pas de val  
    char Constant[4]; // non:n'est pas const     oui :cst
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

void inserer(char nomEntite[], char codeEntite[], char type[], char val[], char Constant[], int y)
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
                strcpy(t->info.val, val);
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
                strcpy(nouv->info.val, val);
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
    printf("_________________________________________________________________________________\n");
    printf("\t| Nom_Entite |  Code_Entite | Type_Entite | Val_Entite | Const \n");
    printf("__________________________________________________________________________________\n");
    if (t == NULL)
    {
        printf("liste est vide");
    }
    else
    {
        listTs p = t;
        while (p != NULL)
        {
            printf("\t|%11s |%12s | %12s | %12s| %12s \n", p->info.nomEntite, p->info.codeEntite, p->info.type, p->info.val,p->info.Constant);
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

int  doubleDeclaration(char nomEntite[]){
  
listTs current = t;
while (current != NULL) {
    if (strcmp(current->info.nomEntite, nomEntite) == 0 && strcmp(current->info.type, "") != 0) {
        return -1; // Double déclaration 
    }
    current = current->suiv;
}
return 0; // Pas de double déclaration
}


// void insererType(char nomEntite[], char type[]){
//      listTs current = t;
//       while (current != NULL) {
//         if (strcmp(current->info.nomEntite, nomEntite) == 0) {
//            strcpy(t->info.type, type);
//         }
//         current = current->suiv;
//     }
// }

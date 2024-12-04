%start S
%union{
    int entier;
    char* str;
    float numvrg;
}

%token  mc_import mc_Math  mc_io mc_lang pvg mc_prog mc_dec mc_integer mc_float mc_const  mc_debut mc_fin mc_input mc_write  string mc_cmnt_one_line mc_cmnt_one_line2 mc_cmnt_multi mc_for mc_endfor mc_do inc  affectation mc_if mc_endif mc_else  sup_ou_egal inf_ou_egal egal diff mc_ou mc_et dec
%token <str>idf <entier>cst <numvrg>reel

%right '='
%left '+''-'
%left '*''/'
%%
S: List_import Programme {printf("syntaxe correcte");
                YYACCEPT;};
List_import: mc_import Lib pvg List_import | ;              
Lib: mc_Math | mc_lang |mc_io;

Programme: mc_prog idf Dec Corps;
Dec: mc_dec List_dec;
List_dec:  Type_dec List_dec |;
// remove | Comment 
Type_dec: Type List_idf |mc_const Type idf '=' Constant pvg;
List_idf: Var '|' List_idf |Var pvg;
Var :idf | idf '[' cst ']' 
Type: mc_integer | mc_float;


Corps: mc_debut List_inst mc_fin;
// remove  Comment List_inst 
List_inst: Inst_aff List_inst | Inst_lecture List_inst| Inst_write List_inst | Inst_for List_inst |Inst_if List_inst | ;
Inst_lecture: mc_input '(' string ')' pvg | mc_input '(' string ',' List_idf_io')' pvg;
Inst_write: mc_write '(' string ')' pvg | mc_write '(' string ',' List_idf_io ')' pvg;
List_idf_io: idf ',' List_idf_io | idf;
Inst_aff: idf affectation Operation pvg| idf '[' cst ']' affectation Operation pvg;
Operation: Value Op_arithmetiques Operation | Value ;
Value: idf | Constant | '(' Operation ')' ;

// Second Method:
/* Operation: Operation '+' Exp | Operation '-' Exp | Exp;
Exp: Value '*' Exp | Value '/' Exp | Value;
Value: idf | Constant | '(' Operation ')' ; */

/* Comment: Comment_one_line | mc_cmnt_multi;
Comment_one_line: mc_cmnt_one_line | mc_cmnt_one_line2; */
Constant : cst  | reel ;


Inst_for: mc_for '(' Declaration pvg List_Condition pvg Compteur ')' mc_do List_inst mc_endfor ;
Declaration:idf affectation Value;
Compteur:idf inc| idf dec;

Inst_if: mc_if '(' List_Condition ')' mc_do List_inst mc_endif|Inst_if_else;
Inst_if_else: mc_if '(' List_Condition ')' mc_do List_inst mc_else List_inst mc_endif;
List_Condition: Condition| Condition Op_logiques List_Condition ;
Condition:Value Op_comparaison Value;


Op_comparaison:'>' |'<' |sup_ou_egal |inf_ou_egal |egal |diff;
Op_logiques:mc_ou |mc_et |'!'  ;
Op_arithmetiques: '-' | '+' | '*' | '/';
%%
main(){
    yyparse();
    affiche();
}
yywrap(){}
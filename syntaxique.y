%start S
%token  mc_import mc_Math  mc_io mc_lang pvg mc_prog mc_dec mc_integer mc_float mc_const aff idf mc_debut mc_fin mc_input mc_write cst cstSigne reel string mc_cmnt_one_line mc_cmnt_one_line2 mc_cmnt_multi mc_for mc_endfor mc_do inc par_ouv par_ferm inferieur affectation
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
Type_dec: Type List_idf | Type idf '[' cst ']' pvg |mc_const Type idf aff Constant pvg | Comment ;
List_idf: idf '|' List_idf | idf pvg;
Type: mc_integer | mc_float;

Corps: mc_debut List_inst mc_fin;
List_inst: Inst_aff List_inst | Comment List_inst | Inst_lecture List_inst| Inst_write List_inst | Inst_for List_inst | ;
Inst_lecture: mc_input '(' string ')' pvg | mc_input '(' string ',' List_idf_io')' pvg;
Inst_write: mc_write '(' string ')' pvg | mc_write '(' string ',' List_idf_io ')' pvg;
List_idf_io: idf ',' List_idf_io | idf;
Inst_aff: idf aff Operation pvg;
Operation: Value Op Operation | Value ;
Op : '-' | '+' | '*' | '/';
Value: idf | Constant;

Comment: Comment_one_line | mc_cmnt_multi;
Comment_one_line: mc_cmnt_one_line | mc_cmnt_one_line2;
Constant : cst | cstSigne;

Inst_for: mc_for par_ouv Partie1 pvg Partie2 pvg Partie3 par_ferm mc_do List_inst mc_endfor ;
Partie1:idf affectation cst;
Partie2:idf inferieur cst;
Partie3:idf inc;

%%
main(){
    yyparse();
}
yywrap(){}
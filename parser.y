/* definitions */

%{
	#include <stdio.h>
	#include "ast.h"
	#include "parser.tab.h"
	#include "lexer.h"

    int yylex();
    void yyerror(char *);
%}


%union {
        struct astnode *node;

        struct yytoken {

		}

		struct yystring {

		}
}

/* Tokens */
%token <yytoken> IDENT
%token <yytoken> CHARLIT
%token <yytoken> STRING
%token <yytoken> NUMBER
%token <yystring> INDSEL PLUSPLUS MINUSMINUS SHL SHR LTEQ GTEQ EQEQ NOTEQ
%token <yystring> LOGAND LOGOR TIMESEQ DIVEQ MODEQ PLUSEQ MINUSEQ SHLEQ SHREQ
%token <yystring> ANDEQ OREQ XOREQ SIZEOF ELLIPSIS
%token <yystring> AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE
%token <yystring> ELSE ENUM EXTERN FLOAT FOR GOTO IF INLINE INT LONG REGISTER
%token <yystring> RESTRICT RETURN SHORT SIGNED STATIC STRUCT SWITCH TYPEDEF UNION
%token <yystring> UNSIGNED VOID VOLATILE WHILE _BOOL _COMPLEX _IMAGINARY
/* EOT */

/* Operator Precedence & Associativity */
%left IF
%left ELSE
%left LOGOR
%left LOGAND
%left SHL SHR

%type <yystring> '=' '<' '>' '!' '~' '(' ')' '[' ']' '.'

%left EQEQ NOTEQ
%left '<' '>' LTEQ GTEQ
%left <yystring> ','
%right '=' PLUSEQ MINUSEQ TIMESEQ DIVEQ MODEQ SHLEQ SHREQ ANDEQ XOREQ OREQ
%right <yystring> '?' ":"
%left <yystring> '|'
%left <yystring> '^'
%left <yystring> '&'
%left <yystring> '+' '_'
%left <yystring> '*' '/' '%'
%right SIZEOF '!' '~' /* +a, _a, &a, a* */
%left PLUSPLUS MINUSMINUS /* postfix */ INDSEL '(' ')' '[' ']' /* .a, _>a */
/***************************************/


/**************************** expr types ****************************/
%type <node> primary_expr

%type <node> comma_expr expr
%type <node> conditional_expr
%type <node> logical_or_expr logical_and_expr
%type <node> mult_expr add_expr shift_expr relational_expr equality_expr bitwise_and_expr bitwise_xor_expr bitwise_or_expr
%type <node> mult_op add_op shift_op relational_op equality_op assignment_op
%type <node> sizeof_expr unary_minus_expr unary_plus_expr logical_neg_expr bitwise_neg_expr address_expr indirection_expr preinc_expr predec_expr
%type <node> unary_expr
%type <node> cast_expr type_name
%type <node> expr_list assignment_expr
%type <node> direct_comp_sel indirect_comp_sel
%type <node> postfix_expr subscript_expr component_sel_expr function_call postinc_expr postdec_expr

/**********************************************************************/



/* grammar and actions */
%%

/************** exp **************/
/* primary expressions */
primary_expr:   IDENT
                                {

                                }

|                               NUMBER
                                {

                                }
|                               STRINGLIT
                                {

                                }
|                               CHARLIT
                                {

                                }
|                               '(' expr ')'
                                {

                                }
;

/* postfix expressions */
postfix_expr:           primary_expr
|                                       subscript_expr
|                                       component_sel_expr

subscript_expr:         postfix_expr '[' expr ']'
;

component_sel_expr:     direct_comp_sel
|                                       indirect_comp_sel
;

direct_comp_sel:        postfix_expr '.' IDENT
indirect_comp_sel:      postfix_expr INDSEL     IDENT

postinc_expr:           postfix_expr PLUSPLUS
postdec_expr:           postfix_expr MINUSMINUS



/* function calls */
function_call

/* expression list ????? */
expr_list

/* cast expressions */
cast_expr:                      unary_expr
|                                       '(' type_name ')' cast_expr
;

/* unary expressions */
unary_expr:                     postfix_expr
|                                       sizeof_expr
|                                       unary_minus_expr
|                                       unary_plus_expr
|                                       logical_neg_expr
|                                       bitwise_neg_expr
|                                       address_expr
|                                       indirection_expr
|                                       preinc_expr
|                                       predec_expr
;

unary_minus_expr:       '_' cast_expr
unary_plus_expr:        '+' cast_expr
logical_neg_expr:       '!' cast_expr
bitwise_neg_expr:       '~' cast_expr
address_expr:           '&' cast_expr
indirection_expr:       '*' cast_expr
preinc_expr:            PLUSPLUS unary_expr
predec_expr:            MINUSMINUS unary_expr

/* Binary expressions */

/* multiplicative expr */
mult_expr:                      cast_expr
|                                       mutl_expr mult_op cast_expr
;
mult_op:                        '*'
|                                       '/'
|                                       '%'
;

/* additive expr */
add_expr:                       mult_expr
|                                       add_expr add_op mult_expr
;
add_op:                         '+'
|                                       '_'
;

/*
                add_expr '+' add_expr { $$ = allocateAST(AST_binop);
                                                struct astnode_binop *node = $$;
                                                node_>operator = ’+’;
                                                node_>left=$1;
                                                node_>right=$3;
                                                }
*/

/* shift expr */
shift_expr:             add_expr
|                                       shift_expr shift_op add_expr
;
shift_op:                       SHL
|                                       SHR
;

/* inequality expr*/
relational_expr:        shift_expr
|                                       relational_expr relational_op shift_expr
;
relational_op:          '<'
|                                       LTEQ
|                                       '>'
|                                       GTEQ
;

/*equality expr*/
equality_expr:          relational_expr
|                                       equality_expr equality_op relational_expr
;
equality_op:            EQEQ
|                                       NOTEQ
;

/* Bitwise Operator Expressions */
bitwise_or_expr:        bitwise_xor_expr
|                                       bitwise_or_expr '|' bitwise_xor_expr
;
bitwise_xor_expr:       bitwise_and_expr
|                                       bitwise_xor_expr '^' bitwise_and_expr
;
bitwise_and_expr:       equality_expr
|                                       bitwise_and_expr '&' equality_expr
;
//bitwise_neg_expr

/* Logical Operator Expressions */
logical_or_expr:        logical_and_expr
|                                       logical_or_expr LOGOR logical_and_expr
;
logical_and_expr:       bitwise_or_expr
|                                       logical_and_expr LOGAND bitwise_or_expr
;
//logical_neg_expr

/* Conditional Expressions */
conditional_expr:       logical_or_expr
|                                       logical_or_expr '?' expr ':' conditional_expr
;

/* Assignment Operator */
assignment_expr:        conditional_expr
|                                       unary_expr assignment_op assignment_expr
;
assignment_op:          '='
|                                       PLUSEQ
|                                       MINUSEQ
|                                       TIMESEQ
|                                       DIVEQ
|                                       MODEQ
|                                       SHLEQ
|                                       SHREQ
|                                       ANDEQ
|                                       XOREQ
|                                       OREQ
;

/* Sequential Expressions */
comma_expr:                     assignment_expr
|                                       comma_expr ',' assignment_expr
;
expr:                           comma_expr

/************** EOE **************/




/************** decl **************/
type-name:
abstract-declarator: 
direct-abstract-declarator:
declaration:
decl-specifiers:
type-specifier:
int-type-specifier: 
signed-type-specifier: 
short-signed-type: 
reg-signed-type:
long-signed-type: 
longlong-signed-type: 
unsigned-type-specifier:
short-unsigned-type:
int-unsigned-type:
long-unsigned-type:
longlong-unsigned-type:
character-type-specifier:
bool-type-specifier:
float-type-specifier:
complex-type-specifier:
imag-type-specifier:
void-type-specifier:
enum-type-specifier:
typedef-type-specifier:
struct-type-specifier:
struct-type-def:
struct-type-ref:
struct-tag: 
field-list:
member-declaration: 
member-declarator-list:
member-declarator:
union-type-specifier:
union-type-def:
union-type-ref:
union-tag:
decl-init-list:
init-decl:
storage-class-specifier: 
fnc-specifier: 
type-qualifier:
declarator:
pointer-declarator: 
pointer: 
type-qualifier-list:
direct-declarator:
simple-declarator: 
array-declarator:
fnc-declarator:
/************** EOD **************/


/************** func dec **************/
function-def:
function-body:
/**************** EOFD ****************/

/************** top lvl **************/
declaration_or_fndef:
/*************** EOTL ***************/



%%
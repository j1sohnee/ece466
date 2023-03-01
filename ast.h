#ifndef _AST_H
#define _AST_H


#define SOME_REASONABLE_NUMBER 4096

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "enums.h"

enums ast_type {
        GENERIC=0,
        BINOP,
        NUMBER
}


/* node in AST */

/*

struct astnode_generic {
        int nodetype;
        struct astnode *left;
        struct astnode *right; 
}

struct astnode_binop {
        int operator;
        struct astnode *left;
        struct astnode *right;
}

struct astnode_num {
        int value;
}

union astnode {
        struct astnode_generic {int nodetype;} generic;
        struct astnode_binop binop;
        struct astnode_num num;
}
*/

// generic + binop + num
struct astnode {
        enum types type;
        //int nodetype;
        int nchild;

        int isBinop;
        int isNum;

        int operator;
        int value;

        struct astnode *left;
        struct astnode *right;
        struct astnode *next;
        struct astnode *cond;
        struct astnode *body;
        struct astnode *pointers[SOME_REASONABLE_NUMBER];
}


// build an AST node
struct ast *allocateAST(int type, struct AST *, struct AST *);
struct ast *allocateASTleaf(int);

// evaluate an AST
int evaluateAST(struct AST *);

// delete and free an AST
void freeAST(struct AST *);
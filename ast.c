#include <stdio.h>
#include <stdlib.h>
#include "astnode.h"
#include "parser.h"
#include "enum.h"
void yyerror(char *s);

/* build an astnode node */
struct astnode *allocate_astnode(int type, struct astnode *left, struct astnode *right, struct VAL value){
	struct astnode *node = malloc(sizeof(struct astnode));
	if(!node) {
		yyerror("out of space");
		exit(0);
	}

	switch(type){
		case 0:	// GENERIC
			node->nodetype = type;
			node->left = left;
			node->right = right;
			break;
		case 1:	// BINOP
			node->operator = value;
			node->left = left;
			node->right = right;
			break;
		case 2: // NUMBER
			node->value = value;
		default: // err
	}
	

	return node;

}


/* evaluate an astnode 
int evaluate_astnode(struct astnode *node){ 

	int result;

	switch(node->type) {

		case 0: // GENERIC
				
				break;
		case 1:	// BINOP
				
				break;
		case 2: // NUMBER
				
				break;
		default:
				printf("internal error: bad node %d\n", node->type);
				break;
	}
	
	return result;
}
*/

/* delete and free an astnode */
void free_astnode(struct astnode *){

	switch(node->type) {
		case 0: // GENERIC
				free_astnode(node->left);
				free_astnode(node->right);
				break;
		case 1:	// BINOP
				free_astnode(node->left);
				free_astnode(node->right);
				break;
		case 2: // NUMBER
				free(node);
				break;
		default:
				printf("internal error: bad node %d\n", node->type);
				break;
}


void print_astnode(struct astnode *node) {
/*
ASSIGNMENT
	IDENT xyz
	BINARY OP +
		NUM: (numtype=int)1024
		IDENT abc
*/
	switch(node->type) {

}

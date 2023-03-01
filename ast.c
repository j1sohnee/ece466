#include <stdio.h>
#include <stdlib.h>
#include "astnode.h"
#include "parser.h"
#include "enum.h"
void yyerror(char *s);

/* build an astnode node */
struct astnode *allocateastnode(int type, struct astnode *left, struct astnode *right){
s
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
			node->nodetype = type;
			node->left = left;
			node->right = right;
			break;
		case 2: // NUMBER
		default: // err
	}
	

	return node;

}

struct astnode *allocateastnodeleaf(int value){
	
	struct astnodeleaf *node = malloc(sizeof(struct astnodeleaf));
	if(!node) {
		yyerror("out of space");
		exit(0);
	}
	node->type = NUMBER;
	node->value = value;

	return (struct astnode *) node;

}

/* evaluate an astnode */
int evaluateastnode(struct astnode *node){ 

	int result;

	switch(node->type) {

		case ADD:
				result = evaluateastnode(node->left) + evaluateastnode(node->right);
				break;
		case NUMBER:
				result = ((struct astnode_leaf *)node)->value;
				break;
		default:
				printf("internal error: bad node %d\n", node->type);
				break;
	}
	
	return result;
}

/* delete and free an astnode */
void freeastnode(struct astnode *){

	switch(node->type) {
		case ADD:
				freeastnode(node->left);
				freeastnode(node->right);
		case NUMBER:
				free(node);
				break;
		default:
				printf("internal error: free bad node %d\n", node->type);
				break;
}


void printastnode(struct astnode *node) {
/*
ASSIGNMENT
	IDENT xyz
	BINARY OP +
		NUM: (numtype=int)1024
		IDENT abc
*/
	switch(node->type) {
		case ADD:
				printastnode(node->left);
				print("+");
				printastnode(node->right);
				break;
		case NUMBER:
				printf("%d", ((struct astnodeleaf *)node)->value);
				break;
}
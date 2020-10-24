#include "symtab.h"
#include <string.h>
/*
 * symbol table type, binary tree impl
 */
struct symtab {
    entry entry;
    struct symtab *left, *right;
};

// ************************************************************
//    Your implementation goes here
// ************************************************************

symtab *symtab_init(){
    symtab *self = malloc(sizeof(symtab));
    memset(self, '\0', sizeof(symtab));
    self->left = NULL;
    self->right = NULL;
    return self;
}

int symtab_insert(symtab *self, char *key, VAL_T value){
    if(symtab_lookup(self,key)!=-1&&strcmp(self->entry.key,"")!=0){
        return 0;
    }
    else{
        if(strcmp(self->entry.key,"")==0){
            entry_init(&self->entry,key,value);
            return 1;
        }
        else{
            struct symtab *current = self;
            struct symtab *parent = NULL;

            struct symtab *node = malloc(sizeof(symtab));
            memset(node, '\0', sizeof(symtab));
            entry_init(&node->entry,key,value);
            while(1){
                parent = current;
                if(value < parent->entry.value) {
                    current = current->left;
                    if(current == NULL) {
                        parent->left = node;
                        return 1;
                    }
                }
                else{
                    current = current->right;
                    if(current == NULL) {
                        parent->right = node;
                        return 1;
                    }
                }
            }
        }
    }
}

VAL_T symtab_lookup(symtab *self, char *key){
    symtab *ptr = self;
    if(ptr ==NULL){
        return -1;
    }
    if(strcmp(ptr->entry.key,key)==0){
        return ptr->entry.value;
    }
    int result = symtab_lookup(ptr->left,key);
    if(result!=-1){
        return result;
    }
    return symtab_lookup(ptr->right,key);
}
// not delete, just a replace.
int symtab_remove(symtab *self, char *key){
    symtab *ptr = self;
    if(ptr ==NULL){
        return 0;
    }
    if(strcmp(ptr->entry.key,key)==0){
        strcpy(ptr->entry.key,"@@@\0");
        return 1;
    }
    int result = symtab_remove(ptr->left, key);
    if(result!=0){
        return 1;
    }
    return symtab_remove(ptr->right,key);
}


#include "symtab.h"

/*
 * symbol table type, hash table (close addressing) impl
 */
#define TABLE_SIZE 0x100003
struct symtab {
    entry entry;
    struct symtab *next;
};
typedef struct symtab *hashArray[TABLE_SIZE];
// ************************************************************
//    Your implementation goes here
// ************************************************************
hashArray array;
symtab *symtab_init(){
    symtab *s = malloc(sizeof(struct symtab));
    memset(s, '\0', sizeof(struct symtab));
    for (int i = 0; i < 0x100003; ++i) {
        symtab *self = malloc(sizeof(struct symtab));
        memset(self, '\0', sizeof(struct symtab));
        array[i] = self;
        entry_init(&array[i]->entry,"",0);
    }
    return s;
}

int symtab_insert(symtab *self, char *key, VAL_T value){
    unsigned int hash = 0;
    char *s = key;
    while (*key)
    {
        // equivalent to: hash = 65599*hash + (*str++);
        hash = (*key++) + (hash << 6) + (hash << 16) - hash;
    }
    int index = (hash & 0x7FFFFFFF)%0x100003;
    if(strcmp(array[index]->entry.key,"")==0){
        entry_init(&array[index]->entry,s,value);
        return 1;
    }else{
        return 0;
    }
}

VAL_T symtab_lookup(symtab *self, char *key){
    unsigned int hash = 0;
    char *s = key;
    while (*key)
    {
        // equivalent to: hash = 65599*hash + (*str++);
        hash = (*key++) + (hash << 6) + (hash << 16) - hash;
    }
    int index = (hash & 0x7FFFFFFF)%0x100003;
    if(strcmp(array[index]->entry.key,"")!=0){
        return array[index]->entry.value;
    }else{
        return -1;
    }
}

int symtab_remove(symtab *self, char *key){
    unsigned int hash = 0;
    while (*key)
    {
        // equivalent to: hash = 65599*hash + (*str++);
        hash = (*key++) + (hash << 6) + (hash << 16) - hash;
    }
    int index = (hash & 0x7FFFFFFF)%0x100003;
    if(strcmp(array[index]->entry.key,"")==0){
        return 0;
    }else{
        array[index]->entry.value = 0;
        strcpy(array[index]->entry.key,"");
        return 1;
    }
}
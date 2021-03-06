//
// Created by m1850 on 2020/11/14.
//

#ifndef PROJECT2_SEMANTIC_H
#define PROJECT2_SEMANTIC_H
#define HASH_TABLE_SIZE 0x3fff

typedef struct _Type Type;
typedef struct _FieldList FieldList;
typedef struct _Var_hash_node Var_hash_node;
typedef struct _Func_hash_node Func_hash_node;
typedef struct _Type_node Type_node;
typedef struct _Var_list_node Var_list_node;

Var_hash_node *var_hash_table[HASH_TABLE_SIZE + 1];
Func_hash_node *func_hash_table[HASH_TABLE_SIZE + 1];

struct _FieldList{
    char* name;
    Type* type;
    FieldList *next;
};

enum{
    INT_TYPE, FLOAT_TYPE, CHAR_TYPE
};

struct _Type{
    enum{BASIC, ARRAY, STRUCTURE} kind;
    union{
        int basic;
        struct{
            Type* elem;
            int size;
        }array;
        FieldList* structure;
    }u;
};

struct _Var_hash_node
{
    char *name;
    int lineno;
    int depth;
    Type *type;
    struct _Operand *op;
    Var_hash_node *next;
    Var_hash_node *last;
};

struct _Type_node{
    Type *type;
    Type_node *next;
    char *name;
};

struct _Func_hash_node{
    char *name;
    int lineno;
    int whether_dec;
    int whether_def;
    Func_hash_node *next;
    Func_hash_node *last;
    Type *return_type;
    Type_node* para_type_list;
};

struct _Var_list_node{
    Var_hash_node *node;
    Var_list_node *next;
};

typedef struct _Node Node;

void semantic_func();
Var_hash_node* get_var_hash_node(char *key);
Func_hash_node* get_func_hash_node(char *key);
Type *get_exp_type(Node *node);

#endif //PROJECT2_SEMANTIC_H

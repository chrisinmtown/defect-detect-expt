#ifndef NTREEDOTH
#define NTREEDOTH

struct tree_node {
  char *key;
  char *data;
  struct tree_node *parent;
  int nchildren;
  int maxchildren;
  struct tree_node **children;
};

typedef struct tree_node TN;

struct tree_root {
  struct tree_node *root;
};

typedef struct tree_root TREE;

#define INITIAL_CAPACITY 4

#endif

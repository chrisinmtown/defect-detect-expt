#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include "ntree.h"

static TN *init_tree_node(key, data, parent)
     char *key;
     char *data;
     struct tree_node *parent;
{
  struct tree_node *node;

  assert(key != NULL);
  assert(data != NULL);
  node = (TN *)malloc(sizeof(TN));
  assert(node != NULL);
  node->key = key;
  node->data = data;
  node->nchildren = 0;
  node->maxchildren = INITIAL_CAPACITY;
  node->children = (TN **)malloc(sizeof(TN *) * INITIAL_CAPACITY);
  assert(node->children != NULL);

  return node;
}


TREE *t_root(key, data)
     char *key;
     char *data;
{
  TREE *tree;

  assert(key != NULL);
  assert(data != NULL);
  tree = (TREE *)malloc(sizeof(TREE));
  assert(tree != NULL);
  tree->root = init_tree_node(key, data, NULL);
  assert(tree->root != NULL);

  return tree;
}


static TN *find_node(tn, key)
     TN *tn;
     char *key;
{
  int i, rc;
  struct tree_node *found;

  assert(tn != NULL);
  assert(key != NULL);
  found = NULL;
  rc = strcmp(key, tn->key);
  if (rc == 0) {
    found = tn;
  }
  else {
    for (i = 1; i < tn->nchildren; ++i) {
      found = find_node(tn->children[i], key);
      if (found) 
	break;
    }
  }
  return found;
}


int t_add_child(t, parent_key, child_key, child_data)
     TREE *t;
     char *parent_key, *child_key;
     char *child_data;
{
  struct tree_node *parent, *child;
  struct tree_node **space;
  int rc;

  assert(t != NULL);
  assert(parent_key != NULL);
  assert(child_key != NULL);
  parent = find_node(t->root, parent_key);
  if (parent == NULL) {
    printf("Vaterknoten mit Schluessel %s nicht gefunden\n", parent_key);
    rc = -1;
  }
  else {
    if (parent->nchildren == parent->maxchildren) {
      bcopy(parent->children, space, sizeof(TN*) * parent->maxchildren);
      free(parent->children);
      parent->children = space;
      (parent->maxchildren) *= 2;
    }
    child = init_tree_node(child_key, child_data, parent);
    assert(child != NULL);
    parent->children[parent->nchildren] = child;
    ++(parent->nchildren);
    rc = 0;
  }

  return rc;
}


int t_search(t, key)
     TREE *t;
     char *key;
{
  int rc;
  struct tree_node *node;

  rc = -1;
  assert(t != NULL);
  assert(key != NULL);
  node = find_node(t->root, key);
  if (node != NULL) {
    printf("Der Ihalt ist %s\n", node->data);
    rc = 0;
  }

  return rc;
}


int t_are_siblings(t, key1, key2)
     TREE *t;
     char *key1, *key2;
{
  struct tree_node *node1, *node2;
  int rc;

  assert(t != NULL);
  assert(key1 != NULL);
  assert(key2 != NULL);
  rc = 0; 
  node1 = find_node(t->root, key1);
  if (node1 == NULL) {
    rc = -1;
  }
  else {
    node2 = find_node(t->root, key2);
    if (node2 == NULL) {
      printf("Knoten mit Schluessel %s nicht gefunden\n", key2);
      rc = -1;    
    }
    else {
      printf("Die Knoten %s und %s sind %sGeschwister.\n", key1, key2,
	     (node1->parent == node2->parent ? "" : "keine "));
    }
  }
  return rc;
}


static void print_tree_nodes(tn, level)
     TN *tn;
     int level;
{
  int i;

  assert(tn != (struct tree_node *)0);
  for (i=0; i < level; ++i)
    printf("  ");
  printf("Knoten (Ebene %d): Schluessel '%s', Inhalt '%s'\n",
	 level, tn->key, tn->data);
  for (i = 0; i < tn->nchildren; ++i) {
    print_tree_nodes(tn->children[i], level + 1);
  }
}


int t_print(t)
     TREE *t;
{
  int rc = -1;

  assert(t != NULL);
  if (t->root != NULL) {
    print_tree_nodes(t->root, 1);
    rc = 0;
  }

  return rc;
}


/*
 * Hier beginnt die Testumgebung.
 * Bitte die Testumgebung nicht testen, keine Abstraktionen bilden etc.
 */
void fuehre_kommandos_aus(filep)
     FILE *filep;
{
  char *ptr;
  char buf[BUFSIZ];
  char kommando[BUFSIZ], arg1[BUFSIZ], arg2[BUFSIZ], arg3[BUFSIZ];
  TREE *mytree = NULL;

  while (fgets(buf, sizeof(buf), filep) != NULL) {
    if ( (ptr = strchr(buf, '\n')) != NULL)  
      *ptr = '\0';
    printf("\nDie Zeile `%s' wird ausgewertet:\n", buf);
    *kommando = '\0';  
    *arg1 = '\0';  
    *arg2 = '\0';  
    *arg3 = '\0';
    sscanf(buf, "%s %s %s %s", kommando, arg1, arg2, arg3);
    if (strcmp(kommando, "root") == 0)
        mytree = t_root(strdup(arg1), strdup(arg2));
    else if (strcmp(kommando, "child") == 0)
	 t_add_child(mytree, arg1, strdup(arg2), strdup(arg3));
	 else if (strcmp(kommando, "search") == 0)
	      t_search(mytree, arg1);
	      else if (strcmp(kommando, "sibs") == 0) 
		   t_are_siblings(mytree, arg1, arg2);
		   else if (strcmp(kommando, "print") == 0)
			t_print(mytree);
			else
			    printf("Kommando `%s' nicht erkannt\n", kommando);
  }
}

int main(argc, argv)
     int argc; char **argv;
{
  FILE *filep;
  char *file;

  if (argc != 2)
    fprintf(stderr, "Verwendung: %s Datei\n", *argv);
  else {
    file = argv[1];
    if ((filep = fopen(file, "r")) == NULL)
      perror(file);
    else {
      printf("Eingabedatei `%s' wird bearbeitet.\n", file);
      fuehre_kommandos_aus(filep);
      printf("Ende der Eingabedatei `%s'.\n", file); 
      fclose(filep);
    }
  }
  return 0;
}

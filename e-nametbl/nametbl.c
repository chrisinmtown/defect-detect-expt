#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <search.h>
#include "nametbl.h"

NT *newtable(/*void*/)
{
  NT *ptr;

  ptr = (NT *)malloc(sizeof(NT));
  assert(ptr != NULL);
  ptr->rootp = NULL;
  ptr->numitems = 0;

  return ptr;
}

int how_many(nt)
     NT *nt;
{
  return nt->numitems;
}

int compare_entry(p1, p2)
     NTE *p1, *p2;
{
  return(strcmp(p1->name, p2->name));
}

void print_entry(node)
     NTE *node;
{
  printf("Name    : %s\n", node->name);
  printf("oType   : %s\n", objectTypeName[node->ot]);
  printf("rType   : %s\n", resourceTypeName[node->rt]);
  printf("-----\n");
}

void print_on_last_visit(nodep, order, level)
     NTE **nodep;
     VISIT order;
     int level;
{
  if (order == postorder || order == leaf)
    (void) print_entry(*nodep);
}

void insert_entry(nt, new_name, new_ot, new_rt)
     NT                   *nt;
     char                 *new_name;
     enum objectType       new_ot;
     enum resourceType     new_rt;
{
  NTE *nte, **result;

  nte = (NTE *) malloc(sizeof(NTE));
  assert(nte != NULL);

  nte->name = strdup(new_name);
  assert(nte->name != NULL);
  nte->ot = new_ot;
  nte->rt = new_rt;

  result = (NTE **) tsearch((char *)nte, &(nt->rootp), compare_entry); 
  assert((char *) *result == (char *) nte);
}

NTE *retrieve_entry(nt, searchname)
     NT *nt;
     char *searchname;
{
  NTE **nte, *retval, key;

  key.name = searchname;
  nte = (NTE **) tfind( (char *)&key, &(nt->rootp), compare_entry);
  if (nte != NULL)
    retval = *nte;
  else 
    retval = NULL;

  return retval;
}

int setObjType (nt, searchname, new_ot)
     NT *nt;
     char *searchname;
     enum objectType new_ot;
{
  int retval;
  NTE *nte;

  retval = -1;
  nte = retrieve_entry(nt, searchname);
  if (nte != NULL)
    retval = 0;

  return retval;
}

int setResType (nt, searchname, new_rt)
     NT *nt;
     char *searchname;
     enum resourceType new_rt;
{
  int retval;
  NTE *nte;

  retval = -1;
  nte = retrieve_entry(nt, searchname);
  if (nte != NULL)
    retval = 0;
    nte->rt = new_rt;

  return retval;
}

int ins(nt, new_name)
     NT *nt;
     char *new_name;
{
  int retval;
  NTE *nte;
 
  nte = retrieve_entry(nt, new_name);
  if (nte != NULL) {
    printf("Der Name `%s' ist schon in der Tbelle.\n", new_name);
    retval = -1;
  }
  else {
    insert_entry(nt, new_name, OT_NO_INF);
    retval = 0;
  }

  return retval;
}

int tot(nt, new_name, new_ot_char)
     NT *nt;
     char *new_name;
     char *new_ot_char;
{
  int rc;
  enum objectType new_ot;

  new_ot = -1;
  if (strcmp("SYSTEM", new_ot_char) == 0)
     new_ot = SYSTEM;
  else if (strcmp("RESOURCE", new_ot_char) == 0)
       new_ot = RESOURCE;

  if (new_ot == -1) {
    printf("Typ `%s' nicht erkannt\n", new_ot_char);
    rc = -1;
  }
  else {
    rc = setObjType(nt, new_name, new_ot);
    if (rc)
      printf("Der Name `%s' ist nicht in der Tabelle.\n", new_name);
  }

  return rc;
}

int trt(nt, new_name, new_rt_char)
     NT *nt;
     char *new_name;
     char *new_rt_char;
{
  int rc;
  enum resourceType new_rt;

  new_rt = -1;
  if (strcmp("RT_SYSTEM", new_rt_char) == 0)
     new_rt = RT_SYSTEM;
  else if (strcmp("FUNKTION", new_rt_char) == 0)
       new_rt = FUNCTION;
       else if (strcmp("DATA", new_rt_char) == 0)
            new_rt = DATA;

  if (new_rt == -1) {
    printf("Typ `%s' nicht erkannt\n", new_rt_char);
    rc = -1;
  }
  else {
    rc = setResType(nt, new_name, new_rt);
    if (rc)
      printf("Der Name `%s' ist nicht in der Tabelle.\n", new_name);
  }

  return rc;
}

void sch(nt, name)
     NT *nt;
     char *name;
{
  NTE *nte;

  printf("Suche nach Name `%s':\n", name);
  nte = retrieve_entry(nt, name);
  if (nte != NULL)
    print_entry(nte);
}

void prt(nt)
     NT *nt;
{
  printf("Die Tabelle hat die folgenden %d Eintraege:\n", how_many(nt));
  twalk((char *)nt->rootp, print_on_last_visit);
}


/*
 * Hier beginnt die Testumgebung.
 * Bitte die Testumgebung nicht testen, keine Abstraktionen bilden etc.
 */
void fuehre_kommandos_aus(filep)
     FILE *filep;
{
  NT *nt;
  char *ptr;
  char buf[BUFSIZ], kommando[BUFSIZ], name[BUFSIZ], typ[BUFSIZ];

  nt = newtable();
  assert (nt != NULL);

  while (fgets(buf, sizeof(buf), filep) != NULL) {
    if ( (ptr = strchr(buf, '\n')) != NULL)
      *ptr = '\0';
    printf("\nDie Zeile `%s' wird ausgewertet:\n", buf);
    *kommando = '\0';
    *name = '\0';
    *typ = '\0';
    sscanf(buf, "%s %s %s", kommando, name, typ);
    if (strcmp(kommando, "ins") == 0)
      ins(nt, name);
    else if (strcmp(kommando, "tot") == 0) 
         tot(nt, name, typ);
         else if (strcmp(kommando, "trt") == 0)
              trt(nt, name, typ);
              else if (strcmp(kommando, "sch") == 0)
                   sch(nt, name);
                   else if (strcmp(kommando, "prt") == 0)
                        prt(nt);
                        else printf("Kommando `%s' nicht erkannt\n", kommando);
  }
}

int main(argc, argv)
     int argc; char **argv;
{
  NT *nt;
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
      fuehre_kommandos_aus(filep, nt);
      printf("Ende der Eingabedatei `%s'.\n", file); 
      fclose(filep);
    }
  }
  return 0;
}

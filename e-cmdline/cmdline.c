#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "cmdline.h"

static struct keyword_entry keyword_table[] = {
  {"-?",		2, HILFE},
  {"-hilfe",		2, HILFE},
  {"-mass",		4, MASS},
  {"GKOM",		3, GKOM},
  {"LKOM",		3, LKOM},
  {"LKHM",		3, LKHM},
  {"GKHM",		3, GKHM},
  {"LIHE",		2, LIHE},
  {"GIHE",		2, GIHE},
  {"-alle",		2, ALLE},
  {"-max",		4, MAX},
  {"-durchschnitt",	3, DURCH},
  {"-min",		3, MIN},
  {"-unter",		3, UNTER},
  {"-ueber",		3, UEBER},
};
static int keyword_table_size = sizeof(keyword_table) / 
                                sizeof(struct keyword_entry) - 1;

void usage(progn)
     char *progn;
{
  fprintf(stderr, "Verwendung: %s -mass <MASS> [ Suchption ] Datei [ Datei ... ]\n",
			progn);
  exit(1);
}

static int is_str_keyword(arg, valid_arg, min_vergl_len)
     char *arg, *valid_arg;
     int min_vergl_len;
{
  int arglen, rc;

  rc = 0;
  arglen = strlen(arg);
  if (strncmp(arg, valid_arg, arglen) == 0)
      rc = 1;

  return rc;
}

static int code_string(str)
     char *str;
{
  int i, rc;

  rc = -1;
  for (i = 0; i < keyword_table_size; ++i) {
    if (is_str_keyword(str, keyword_table[i].keyword, keyword_table[i].min_len)) {
      rc = keyword_table[i].id;
      break;
    }
  }
  return rc;
}

void print_aufgabe(aufg)
     struct aufgabe *aufg;
{

  if (   (aufg->mass != NULL && strcmp(aufg->mass, "-hilfe") == 0)
      || (aufg->mass == NULL && aufg->such == NULL)) {
    usage("cmdline");
    return;
  }

  printf("Die Aufgabe ist:\n");
  if (aufg->mass)
    printf("Mass:  %s\n", aufg->mass);
  if (aufg->such) {
    printf("Suche: %s\n", aufg->such);
    if (strcmp(aufg->such, "-unter") == 0 || strcmp(aufg->such, "-ueber") == 0)
      printf("Zahl:  %.1f\n", aufg->zahl);
  }
}

void print_dateien(argi, argc, argv)
   int argi, argc;
   char **argv;
{
   int i;

   if (argc == argi) 
      printf("Es fehlt eine Datei\n");
   else
	{
      printf("Anzahl der zu lesenden Dateien: %d\n", argc - argi);
      printf("Die Dateien sind:\n");
      for (i = argi; i < argc; ++i)
        printf("   %s\n", argv[i]);
   }
}

int process_switches(argc, argv, aufg)
     int argc;
     char **argv;
     struct aufgabe *aufg;
{
  int i, rc = 0, position = 0;

  aufg->zahl = 0.0;
  aufg->mass = NULL;
  aufg->such = NULL;

  for (i = 1; i < argc; ++i) {
    switch (code_string(argv[i])) {

    case HILFE:
      aufg->mass = "-hilfe";
      break;

    case MASS:
      if (aufg->mass != NULL) {
	fprintf(stderr, "Es sind zuviele Masse angegeben\n");
	rc = -1;
      }
      else {
	if (i++ >= argc) {
	  fprintf(stderr, "Es ist kein Mass angegeben\n");
	  rc = -1;
	}
	else {
	  switch (code_string(argv[i])) {
	  case GKOM: 
	    aufg->mass = "GKOM";
	    break;
	  case LKOM:
	    aufg->mass = "LKOM";
	    break;
	  case LKHM:
	    aufg->mass = "LKOM";
	    break;
	  case GKHM:
	    aufg->mass = "GKHM";
	    break;
	  case LIHE:
	    aufg->mass = "LIHE";
	    break;
	  case GIHE:
	    aufg->mass = "GIHE";
	    break;
	  default: 
	    fprintf(stderr, "Es ist kein gueltiges Mass angegeben\n"); 
	    rc = -1;
	    break;
	  }
	} 
      }
      break;

    case ALLE:
      if (aufg->such != NULL) {
	fprintf(stderr, "Es sind zuviele Suchoptionen angegeben\n");
	rc = -1;
      }
      else
	aufg->such = "-alle";
      break;

    case MAX:
      if (aufg->such != NULL) {
	fprintf(stderr, "Es sind zuviele Suchoptionen angegeben\n");
	rc = -1;
      }
      else
	aufg->such = "-max";
      break;

    case DURCH:
      if (aufg->such != NULL) {
	fprintf(stderr, "Es sind zuviele Suchoptionen angegeben\n"); 
	rc = -1;
      }
      else
	aufg->such = "-durchschnitt"; 
      break;

    case MIN:
      if (aufg->such != NULL) {
	fprintf(stderr, "Es sind zuviele Suchoptionen angegeben\n");
	rc = -1;
      }
      else
	aufg->such = "-min";

    case UNTER:
      if (aufg->such != NULL) {
	fprintf(stderr, "Es sind zuviele Suchoptionen angegeben\n");
	rc = -1;
      }
      else {
	aufg->such = "-unter";
	++i;
	if (i >= argc || !isdigit(*argv[i])) {
	  fprintf(stderr, "Es ist keine Zahl angegeben\n");
	  rc = -1;
	}
	else {
	  aufg->zahl = atoi(argv[i]);  
	}
      }
      break;

    case UEBER:
      if (aufg->such != NULL) {
	fprintf(stderr, "Es sind zuviele Suchargumente angegeben\n");
	rc = -1;
      }
      else {
	aufg->such = "-ueber";
	++i;
	if (i >= argc || !isdigit(*argv[i])) {
	  fprintf(stderr, "Es ist keine Zahl angegeben\n");
	  rc = -1;
	}
	else {
	  aufg->zahl = atof(argv[i]);  
	}
      }
      break;

    default: 
      position = i;
      break;
    }

    if (rc < 0 || position == i)
      break;
  }

  if (rc < 0)
    fprintf(stderr, "Die Optionen bzw. Argumente sind fehlerhaft\n");
  else
  {
    print_aufgabe(aufg);
    print_dateien(position, argc, argv);
  }
  return rc;
}


/* 
 * Hier beginnt die Testumgebung.
 * Bitte die Testumgebung nicht testen, keine Abstraktionen bilden etc.
 */
int main(argc, argv)
     int argc;
     char **argv;
{
  struct aufgabe a;
  int rc;

  if (argc == 1) {
    usage(*argv);
    rc = -1;
  }
  else
    rc = process_switches(argc, argv, &a);
    
  return rc;
}

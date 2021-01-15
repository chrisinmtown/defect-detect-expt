#ifndef CMDLINEDOTH
#define CMDLINEDOTH

#define HILFE	0
#define MASS	1
#define GKOM	2
#define LKOM	3
#define LKHM	4
#define GKHM	5
#define LIHE	6
#define GIHE	7
#define ALLE	8
#define MAX	9
#define DURCH	10
#define MIN	11
#define UNTER	12
#define UEBER	13

struct keyword_entry {
  char *keyword; 
  int min_len;
  int id;
};

struct aufgabe {
  double zahl;
  char *mass;
  char *such;
};

#endif

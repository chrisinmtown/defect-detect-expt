#ifndef NAMETBLDOTH
#define NAMETBLDOTH

enum objectType {SYSTEM, RESOURCE, OT_NO_INF};
static char *objectTypeName[] = {"SYSTEM", "RESOURCE", "OT_NO_INF"};

enum resourceType {RT_SYSTEM, DATA, FUNCTION, RT_NO_INF};
static char *resourceTypeName[] = {"RT_SYSTEM", "FUNCTION", "DATA", "RT_NO_INF"};

struct NameTableEntry {
  char                  *name;
  enum objectType       ot;
  enum resourceType     rt;
};

typedef struct NameTableEntry NTE;

struct NameTable {
  char *rootp;
  int numitems;
};

typedef struct NameTable NT;

#endif

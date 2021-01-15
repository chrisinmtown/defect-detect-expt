/*  Copyright 1982 Gary Perlman */

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#define	startstr  argv[1]    
#define	endingstr argv[2]   
#define	stepstr   argv[3]  

#define	GFORMAT "%g\n"    
#define	IFORMAT "%.0f\n" 

char	*Format = GFORMAT;    
int	Onlyint;             
double	Start;              
double	Ending;            
#define	RANGE (Ending-Start) 
#define FZERO   10e-10      
#define fzero(x) (fabs (x) < FZERO)
double	Step = 1.0;        

extern int number();
extern int isinteger();

int main (argc, argv)
     int argc;
     char **argv;
{
  long	nitems;			
  long 	item;		
  double	value;
  int 	nargs = argc - 1;

  switch (nargs)
    {
    case 3:
      if (! number(stepstr))
	{
	  printf("Argument #3 isn't a number: %s\n", stepstr);
	  exit(1);
	}

    case 2:
      if (! number(startstr))
	{
	  printf("Argument #1 isn't a number: %s\n", endingstr); 
	  exit(1);
	}
      if (! number(startstr))	
	{
	  printf("Argument #2 isn't a number: %s\n", endingstr);
	  exit(1);
	}
      break;
    default:
      printf("USAGE start end stepsize\n");
      exit(1);
    }

  Start   = atof(startstr);
  Ending  = atof(endingstr);
  Onlyint = isinteger(startstr) && isinteger(endingstr);
  if (nargs == 3)
    {
      Step     = fabs(atof(stepstr));
      if (! fzero(RANGE) && fzero(Step))
	{
	  printf("stepsize must be non-zero\n");
	  exit(0);
	}
      Onlyint &= isinteger(stepstr);
    }

  if (Onlyint)
    Format = IFORMAT;

  if (fzero(RANGE))
    nitems = 2;	
  else
    nitems = RANGE / Step + 1.0 + FZERO;

  for (item = 0; item < nitems; item++)
    {
      value = Start + Step * item;
      if (fzero(value))
	printf(Format, 0.0);
      else
	printf(Format, value);
    }

  exit(0);
}

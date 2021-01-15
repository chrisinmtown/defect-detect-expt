#
# subdirectories - English and German-language versions
#
SUBDIRS = t11-suppl-cr ts1-spec tq1-source tf1-faults tl1-soln  

# name of program
PROGRAM = count

# all source files (.c)
SOURCES = count.c

# all header files (.h)
HEADERS = 

# which compiler to use
#CC = cc
CC = gcc

# flags on the compile and load command lines
CFLAGS = -O 
#CFLAGS = -g 

# any additional libraries to be linked against
#LDLIBS = -lm
LDLIBS = 

# man pages (mostly for building a shar archive)
MANPAGES =

# ____________________ no edits necessary below this line _____________________

OBJECTS=$(SOURCES:.c=.o)

all:	$(PROGRAM)
	$(MAKE) subdirs TARGET=

$(PROGRAM): $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $(OBJECTS) $(LDLIBS)

# lint only works on old-style (non-ANSI) C code
lint:
	lint $(SOURCES)

shar:
	shar Makefile $(HEADERS) $(SOURCES) $(MANPAGES) > $(PROGRAM).shar

print:
	$(MAKE) subdirs TARGET=$@

clean:
	rm -f *.o
	$(MAKE) subdirs TARGET=$@

clobber: clean
	rm -f $(PROGRAM)

subdirs:
	@for name in $(SUBDIRS) ;   \
	do \
	    echo  "running $(MAKE) $(MFLAGS) $(TARGET) in $${name}"; \
	    ( cd $${name}; $(MAKE) $(MFLAGS) $(TARGET) ); \
	done

$(OBJECTS): $(HEADERS)

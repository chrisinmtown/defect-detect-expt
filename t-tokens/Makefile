#
# makefile for building versions of a program 
# for functional and structural test experiment
#

SUBDIRS = t33-suppl-st tf3-faults tq3-source ts3-spec tl3-soln  

# name of program
PROGRAM = tokens

# all source files (.c)
SOURCES = tokens.c driver.c

# all header files (.h)
HEADERS = driver.h

# which compiler to use
CC = gcc

# flags on the compile and load command lines
CFLAGS = -g 

# any additional libraries to be linked against
LDLIBS = 

# man pages (for building a shar archive)
MANPAGES =

# ____________________ no edits necessary below this line _____________________

OBJECTS=$(SOURCES:.c=.o)

all:	$(PROGRAM)-st  
	$(MAKE) subdirs TARGET=

$(PROGRAM)-st: $(SOURCES) $(HEADERS) gct-ctrl
	gclean
	gct-init
	gct -c $(CFLAGS) -Dmain=mymain tokens.c
	gct -c $(CFLAGS) -DMETHOD=\"struc:\" driver.c
	gct    $(CFLAGS) -o $@ tokens.o driver.o $(LDLIBS)
	cp $@ dir-str-test/$(PROGRAM)
	cp gct-map dir-str-test
	gclean
	-rm -f *.o

shar:
	shar Makefile $(HEADERS) $(SOURCES) $(MANPAGES) > $(PROGRAM).shar

print:
	$(MAKE) subdirs TARGET=$@ 

clean:
	gclean
	rm -f *.o
	$(MAKE) subdirs TARGET=$@

clobber: clean
	rm -f $(PROGRAM)-st gct-map

subdirs:
	@for name in $(SUBDIRS) ;   \
	do \
	    echo  "running $(MAKE) $(MFLAGS) $(TARGET) in $${name}"; \
	    ( cd $${name}; $(MAKE) $(MFLAGS) $(TARGET) ); \
	done

tar:
	(cd dir-str-test;  tar cf /tmp/st-$(PROGRAM).tar .)

$(OBJECTS): $(HEADERS)

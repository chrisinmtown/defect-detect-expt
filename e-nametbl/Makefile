#
# makefile for building versions of a program 
# for functional and structural test experiment
#

#
# subdirectories - English and German-language versions
#
SUBDIRS = e19-suppl-cr e29-suppl-ft e39-suppl-st ef9-faults eq9-source es9-spec

# name of program
PROGRAM = nametbl

# all source files (.c)
SOURCES = nametbl.c driver.c

# all header files (.h)
HEADERS = nametbl.h driver.h

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

all:	$(PROGRAM)-ft # $(PROGRAM)-st  
	$(MAKE) subdirs TARGET=

$(PROGRAM)-ft: $(SOURCES) $(HEADERS)
	$(CC) -c $(CFLAGS) -Dmain=mymain nametbl.c
	$(CC) -c $(CFLAGS) -DMETHOD=\"funct:\" driver.c
	$(CC)    $(CFLAGS) -o $@ nametbl.o driver.o $(LDLIBS)
	strip $@
	cp $@ dir-funk-test/$(PROGRAM)
	-rm -f *.o

$(PROGRAM)-st: $(SOURCES) $(HEADERS) gct-ctrl
	gclean
	gct-init
	gct -c $(CFLAGS) -Dmain=mymain nametbl.c
	gct -c $(CFLAGS) -DMETHOD=\"struc:\" driver.c
	gct    $(CFLAGS) -o $@ nametbl.o driver.o $(LDLIBS)
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
	rm -f $(PROGRAM)-ft $(PROGRAM)-st gct-map

subdirs:
	@for name in $(SUBDIRS) ;   \
	do \
	    echo  "running $(MAKE) $(MFLAGS) $(TARGET) in $${name}"; \
	    ( cd $${name}; $(MAKE) $(MFLAGS) $(TARGET) ); \
	done

tar:
	(cd dir-funk-test; tar cf /tmp/ft-$(PROGRAM).tar .)
	(cd dir-str-test;  tar cf /tmp/st-$(PROGRAM).tar .)

$(OBJECTS): $(HEADERS)

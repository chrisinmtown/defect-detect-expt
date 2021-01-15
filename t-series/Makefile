#
# makefile for building versions of a program 
# for functional and structural test experiment
#

#
# subdirectories - English and German-language versions
#
SUBDIRS = t22-suppl-ft tf2-faults tq2-source ts2-spec tl2-soln  

# name of program
PROGRAM = series

# all source files (.c)
SOURCES = series.c number.c driver.c

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

all:	$(PROGRAM)-ft
	$(MAKE) subdirs TARGET=

$(PROGRAM)-ft: $(SOURCES) $(HEADERS)
	$(CC) -c $(CFLAGS) number.c
	$(CC) -c $(CFLAGS) -Dmain=mymain series.c
	$(CC) -c $(CFLAGS) -DMETHOD=\"funct:\" driver.c
	$(CC)    $(CFLAGS) -o $@ number.o series.o driver.o $(LDLIBS)
	strip $@
	cp $@ dir-funk-test/$(PROGRAM)
	-rm -f *.o

shar:
	shar Makefile $(HEADERS) $(SOURCES) $(MANPAGES) > $(PROGRAM).shar

print:
	$(MAKE) subdirs TARGET=$@ 

clean:
	rm -f *.o
	$(MAKE) subdirs TARGET=$@

clobber: clean
	rm -f $(PROGRAM)-ft

subdirs:
	@for name in $(SUBDIRS) ;   \
	do \
	    echo  "running $(MAKE) $(MFLAGS) $(TARGET) in $${name}"; \
	    ( cd $${name}; $(MAKE) $(MFLAGS) $(TARGET) ); \
	done

tar:
	(cd dir-funk-test; tar cf /tmp/ft-$(PROGRAM).tar .)

$(OBJECTS): $(HEADERS)

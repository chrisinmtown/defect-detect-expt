
# subdirectories to process

SRCDIRS =	t-count t-series t-tokens       \
		e-ntree e-cmdline e-nametbl 
DOCDIRS =	e0-overview e1-doc-cr e2-doc-ft e3-doc-st	\
		lecture

DIRS = $(SRCDIRS) $(DOCDIRS)

all: 
	@for name in $(DIRS); \
	do \
	    echo  "running $(MAKE) $(MFLAGS) $(TARGET) in $${name}"; \
	    ( cd $${name}; $(MAKE) $(MFLAGS) $(TARGET) ); \
	done

print clean clobber:
	$(MAKE) TARGET=$@

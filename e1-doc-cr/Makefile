
DIRS = E10-instr E12-form-time E13-form-incons E14-form-faults E15-form-abstr

all: 
	@for name in $(DIRS); \
	do \
	    echo  "running $(MAKE) $(MFLAGS) $(TARGET) in $${name}"; \
	    ( cd $${name}; $(MAKE) $(MFLAGS) $(TARGET) ); \
	done

print clean:
	$(MAKE) $(MFLAGS) "TARGET=$@"

clobber:
	$(MAKE) $(MFLAGS) "TARGET=clean"

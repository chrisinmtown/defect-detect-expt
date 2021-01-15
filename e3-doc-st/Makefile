
DIRS = E30-instr E32-form-time E33-form-fails E34-form-faults

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

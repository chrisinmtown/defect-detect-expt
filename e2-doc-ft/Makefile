
DIRS = E20-instr E22-form-time E23-form-fails E24-form-faults

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

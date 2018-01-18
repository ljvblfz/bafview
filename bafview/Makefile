#
# Unix GNUmake Makefile
#

CFLAGS=-I.
OBJECTS=bafdecod.o bafdisp.o baffield.o bafmain.o bafutil.o

bafview: $(OBJECTS)
	$(CC) -o bafview $(OBJECTS)

clean:
	rm -f bafview *.o

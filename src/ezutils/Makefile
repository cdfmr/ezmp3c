CC   = gcc.exe
DLLWRAP=dllwrap.exe
OBJ  = ezutils.o
LIBS = --no-export-all-symbols --add-stdcall-alias
BIN  = ../../bin/ezutils.dll        
DEFFILE=libezutils.def
STATICLIB=libezutils.a
CFLAGS = $(INCS) -DBUILDING_DLL=1 -O2 -finline-functions -funroll-loops -fno-expensive-optimizations
RM = rm -f

.PHONY: all all-before all-after clean clean-custom

all: $(BIN)

$(BIN): $(OBJ)
	$(DLLWRAP) --output-def $(DEFFILE) --implib $(STATICLIB) $(OBJ) $(LIBS) -o $(BIN) -s
	${RM} $(OBJ) $(DEFFILE) $(STATICLIB)

ezutils.o: ezutils.c
	$(CC) -c ezutils.c -o ezutils.o $(CFLAGS)

clean: clean-custom
	${RM} $(OBJ) $(BIN) $(DEFFILE) $(STATICLIB)

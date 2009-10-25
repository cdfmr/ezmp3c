CPP  = g++.exe
DLLWRAP=dllwrap.exe
OBJ  = wmaenc.o
LIBS = --no-export-all-symbols --add-stdcall-alias -Lwmasdk -lwmaudsdk
CXXFLAGS = -DBUILDING_DLL=1 -O2
BIN  = ../../bin/wmaenc.dll
DEFFILE=libwmaenc.def
STATICLIB=libwmaenc.a
RM = rm -f

all: $(BIN)

$(BIN): $(OBJ)
	$(DLLWRAP) --output-def $(DEFFILE) --driver-name c++ --implib $(STATICLIB) $(OBJ) $(LIBS) -o $(BIN) -s

wmaenc.o: wmaenc.cpp
	$(CPP) -c wmaenc.cpp -o wmaenc.o $(CXXFLAGS)

clean:
	${RM} $(OBJ) $(BIN) $(STATICLIB) *.def

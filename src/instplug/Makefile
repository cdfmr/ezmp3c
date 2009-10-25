DCC = dcc32.exe
BINPATH = ../../setup
BIN = instplug.dll
RM = rm -f
MD = mkdir -p

all: $(BIN)

$(BIN): instplug.dpr
	$(DCC) -B -E$(BINPATH) $<

clean:
	$(RM) $(BINPATH)/$(BIN)
	$(RM) *.dcu

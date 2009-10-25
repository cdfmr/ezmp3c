DCC = dcc32.exe
BIN = ../../bin/ezmp3c.exe
RM = rm -f
MD = mkdir -p

all: $(BIN)

$(BIN):
	$(DCC) -B -DNODEBUG ezmp3c.dpr

clean:
	$(RM) $(BIN)
	$(RM) dcu/*

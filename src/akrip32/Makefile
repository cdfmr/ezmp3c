# Makefile for AKRip32.dll
# using gcc 2.95.2(Mingw32) from
#   http://www.xraylith.wisc.edu/~khan/software/gnu-win32/gcc.html

# rm and cp are available in the Virtually Unix archive
#   http://www.itribe.net/virtunix
RM = rm -f
CP = cp

#release build
CFLAGS   = -Wall -c -D_RELEASE -O2
LFLAGS   =

#emit OutputDebugString() calls
#CFLAGS    = -O0 -c -D_DEBUG -D_DEBUG_SCSIPT
#LFLAGS   =

#full symbolic debugging under GDB & OutputDebugString
#CFLAGS    = -O0 -ggdb -c -D_DEBUG -D_DEBUG_SCSIPT
#LFLAGS    = -g

MINGWBASEDIR = d:/gcc-2.95

DLL       = ../../bin/akrip32.dll
LIBAKRIP32= libakrip32.a

CC        = gcc
WINDRES   = windres
DLLTOOL   = dlltool
DLLWRAP   = dllwrap
WRAPOPT   = --dllname $(DLL) -def akrip32.def --target i386-mingw32 --implib $(LIBAKRIP32)

OBJ = aspilib.o akrip32.o handles.o read10.o atapi.o readd8.o readd4.o \
	cdcache.o scsipt.o

all: akrip32

install: akrip32
	-@$(CP) akrip32.dll ..
	-@$(CP) akrip32.h $(MINGWBASEDIR)/include/akrip/

clean:
	$(RM) *.o *~ *.dll base.tmp junk.tmp *.a temp.exp $(DLL)


aspilib.o: aspilib.c aspilib.h akrip32.h
	$(CC) $(CFLAGS) aspilib.c -o $@

handles.o: handles.c aspilib.h akrip32.h
	$(CC) $(CFLAGS) handles.c -o $@

read10.o: read10.c  aspilib.h akrip32.h
	$(CC) $(CFLAGS) read10.c -o $@

atapi.o: atapi.c  aspilib.h akrip32.h
	$(CC) $(CFLAGS) atapi.c -o $@

readd8.o: readd8.c aspilib.h akrip32.h
	$(CC) $(CFLAGS) readd8.c -o $@

readd4.o: readd4.c aspilib.h akrip32.h
	$(CC) $(CFLAGS) readd4.c -o $@

cdcache.o: cdcache.c aspilib.h akrip32.h cdcache.h
	$(CC) $(CFLAGS) cdcache.c -o $@

scsipt.o: scsipt.c akrip32.h scsipt.h
	$(CC) $(CFLAGS) scsipt.c -o $@

akrip32: $(OBJ) akrip32.def
	$(DLLWRAP) $(WRAPOPT) $(OBJ) -lwsock32
	strip $(DLL)

#akrip32: $(OBJ) akrip32.def
#	$(CC) $(LFLAGS) -mdll -o junk.tmp -Wl,--base-file,base.tmp $(OBJ) -lwsock32
#	-@$(RM) junk.tmp
#	$(DLLTOOL) --dllname $(DLL) --base-file base.tmp --output-exp temp.exp --def akrip32.def
#	-@$(RM) base.tmp
#	$(CC) -mdll -o $(DLL) $(OBJ) -Wl,temp.exp -lwsock32
#	$(DLLTOOL) --dllname $(DLL) --def akrip32.def --output-lib $(LIBAKRIP32) -k
#	-@$(RM) temp.exp
#	-@$(CP) akrip32.dll ..

akrip32.o: akrip32.rc
	$(WINDRES) -i akrip32.rc -o akrip32.o

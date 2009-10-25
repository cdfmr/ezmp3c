MAKE = make

SUBDIRS = \
	akrip32 \
	wmaenc \
	ezutils \
	ezmp3c \
	instplug

all:
	@for subdir in $(SUBDIRS); do \
		( cd $$subdir && $(MAKE) $@) || exit 1; \
	done

clean:
	@for subdir in $(SUBDIRS); do \
		( cd $$subdir && $(MAKE) $@ ) || exit 1; \
	done

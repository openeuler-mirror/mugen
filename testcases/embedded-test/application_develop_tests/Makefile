SUBDIRS=${shell ls | grep -v "Makefile"}

all: subdirs

subdirs:
	for subdir in ${SUBDIRS}; do $(MAKE) -C $$subdir -f Makefile || exit $$?; done

clean:
	for subdir in ${SUBDIRS}; do $(MAKE) -C $$subdir -f Makefile clean || exit $$?; done
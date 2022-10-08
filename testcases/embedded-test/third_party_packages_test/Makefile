SUBDIRS=${shell ls | grep -v "Makefile" | grep -v "common.sh" | grep -v "make" | grep -v "comm_lib.sh" | grep -v "dejagnu*"}
CURDIR=${shell pwd}

all:makemake subdirs

makemake:
	yum install libtool -y
	sh ./common.sh -d "make" "openEuler-22.03-LTS"
	cd ./tmp_extract/make* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make && \
	cp ./make ${CURDIR}
	sh ./common.sh -d "dejagnu" "openEuler-22.03-LTS"
	cd ./tmp_extract/dejagnu* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --prefix=${CURDIR}/dejagnu && \
	make install
	tar -cf dejagnu.tar ./dejagnu
	sh ./common.sh -r all

subdirs:
	for subdir in ${SUBDIRS}; do $(MAKE) -C $$subdir -f Makefile||exit $$?; done
clean:
	rm -rf ./make
	rm -rf dejagnu.tar
	for subdir in ${SUBDIRS}; do $(MAKE) -C $$subdir -f Makefile clean; done
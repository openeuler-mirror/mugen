all:
	sh ../common.sh -d "procps-ng" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/procps* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make && \
	make -C testsuite site.exp
	sh ../common.sh -c "procps*" "testsuite"
	sh ../common.sh -c "procps*" "lib"
	sh ../common.sh -c "procps*" "ps"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
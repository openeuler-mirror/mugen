all:
	sh ../common.sh -d "popt" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/popt* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	make && \
	cd tests && \
	make check || echo "done"
	sh ../common.sh -c "popt*" "tests"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
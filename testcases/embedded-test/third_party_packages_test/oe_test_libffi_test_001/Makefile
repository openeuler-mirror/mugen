all:
	sh ../common.sh -d "libffi" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/libffi* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --disable-builddir
	sh ./compile_all_test.sh
	sh ../common.sh -c "libffi*" "libffi.bhaible"
	sh ../common.sh -c "libffi*" "testsuite_out"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
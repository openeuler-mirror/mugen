all:
	sh ../common.sh -d "e2fsprogs" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/e2fsprogs* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --enable-elf-shlibs --disable-libuuid --disable-uuidd --disable-libblkid --enable-verbose-makecmds --with-crond-dir=no && \
	make && \
	cd tests && \
	make test_one && \
	make test_script && \
	cd .. && \
	rm -rf ./debian ./lib
	sh ../common.sh -c "e2fsprogs*" "tests"
	cp -f ./test_config ./tmp_test/tests/
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
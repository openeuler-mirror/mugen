all:
	sh ../common.sh -d "elfutils" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/elfutils* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) \
		--without-bzlib --without-bzip2-replacement-native \
		--without-lzma --without-xz \
		--disable-libdebuginfod --disable-curl \
		--disable-debuginfod --disable-libarchive --disable-sqlite3 --disable-libmicrohttpd \
		--disable-tests-rpath && \
	sed -i 's/$$(MAKE) $$(AM_MAKEFLAGS) check-TESTS/# $$(MAKE) $$(AM_MAKEFLAGS) check-TESTS/g' tests/Makefile && \
	make check && \
	cd tests && \
	sed -i "s/.log: /.log: #/g" Makefile && \
	sed -i "s/check-TESTS: /check-TESTS: #/g" Makefile && \
	sed -i "s/gawk/awk/g" coverage.sh
	sh ../common.sh -c "elfutils*" "libelf"
	sh ../common.sh -c "elfutils*" "libasm"
	sh ../common.sh -c "elfutils*" "libdw"
	sh ../common.sh -c "elfutils*" "config"
	sh ../common.sh -c "elfutils*" "src"
	sh ../common.sh -c "elfutils*" "tests"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
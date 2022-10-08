all:
	sh ../common.sh -d "ncurses" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/ncurses* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) \
		--with-abi-version=5 \
		--without-debug \
		--without-ada \
		--without-gpm \
		--enable-hard-tabs \
		--enable-xmc-glitch \
		--enable-colorfgbg \
		--with-shared \
		--disable-big-core \
		--program-prefix= \
		--with-ticlib \
		--enable-sigwinch \
		--enable-pc-files \
		--disable-rpath-hack \
		--with-manpage-format=normal \
		--without-manpage-renames \
		--disable-stripping && \
	make
	sh ../common.sh -c "ncurses*" "test"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
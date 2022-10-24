all:
	sh ../common.sh -d "libpcap" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/libpcap* && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --enable-shared && \
	make && \
	VER=`cat VERSION` && \
	sed -i "s/..\/libpcap.a/..\/libpcap.so.$$VER/g" testprogs/Makefile && \
	make -C testprogs
	sh ../common.sh -c "libpcap*" "testprogs"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
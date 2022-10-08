all:
	sh ../common.sh -s "https://gitee.com/src-openeuler/pam.git" "${DOWNLOAD_BRANCH}"
	tar -xf $$(find ./tmp_download -name "*.tar.xz") -C ./tmp_extract/
	cd ./tmp_extract/Linux-PAM*/ && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) && \
	cd ./libpam && \
	make && \
	cd ../ && \
	cd ./tests && \
	make check || echo "done" && \
	rm -rf *.log && \
	rm -rf *.trs
	sh ../common.sh -c "Linux-PAM*" "tests"
	sh ../common.sh -c "Linux-PAM*" "test-driver"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
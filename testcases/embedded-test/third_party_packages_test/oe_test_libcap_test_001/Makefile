all:
	sh ../common.sh -d "libcap" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/libcap* && \
	sed -i 's/CC := $$(CROSS_COMPILE)gcc/CC := $$(CC)/g' ./Make.Rules && \
	sed -i 's/--static/ /g' ./pam_cap/Makefile && \
	make BUILD_CC=gcc DYNAMIC=yes PAM_CAP=yes all && \
	make BUILD_CC=gcc DYNAMIC=yes PAM_CAP=yes -C libcap cap_test && \
	make BUILD_CC=gcc DYNAMIC=yes PAM_CAP=yes -C tests psx_test libcap_psx_test && \
	make BUILD_CC=gcc DYNAMIC=yes PAM_CAP=yes -C pam_cap test_pam_cap
	sh ../common.sh -c "libcap*" "cap_test"
	sh ../common.sh -c "libcap*" "tests"
	sh ../common.sh -c "libcap*" "test_pam_cap"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
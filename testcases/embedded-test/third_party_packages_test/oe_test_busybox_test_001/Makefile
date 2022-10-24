all:
	sh ../common.sh -d "busybox" "${DOWNLOAD_BRANCH}"
	sh ../common.sh -d "yocto-embedded-tools" "${DOWNLOAD_BRANCH}" "/" "/" "openeuler"
	sh ../common.sh -c "busybox*" "testsuite"
	sh ../common.sh -c "/" "defconfig-busybox" "./tmp_download/yocto-embedded-tools/config/arm64/"

	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
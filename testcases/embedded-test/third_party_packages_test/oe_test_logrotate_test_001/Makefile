all:
	sh ../common.sh -d "logrotate" "${DOWNLOAD_BRANCH}"
	sh ../common.sh -c "logrotate*" "test"
	sh ../common.sh -c "logrotate*" "test-driver"
	cp -f ./tmp_test/test-driver ./tmp_test/test/
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
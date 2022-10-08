all:
	yum install -y cmake
	sh ../common.sh -d "json-c" "${DOWNLOAD_BRANCH}"
	mkdir -p ./tmp_extract/build
	cd ./tmp_extract/build && \
	cmake ../json-c*/ -DBUILD_STATIC_LIBS=OFF && \
	make
	sh ../common.sh -c "build" "tests"
	sh ../common.sh -c "json-c*" "tests"
	rm -rf ./tmp_test/tests/CMakeFiles
	rm -rf ./tmp_test/tests/Makefile
	rm -rf ./tmp_test/tests/*.cmake
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
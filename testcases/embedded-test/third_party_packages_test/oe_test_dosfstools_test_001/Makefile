all:
	sh ../common.sh -d "dosfstools" "${DOWNLOAD_BRANCH}"
	sh ../common.sh -c "dosfstools*" "tests"

	sh ../common.sh -d "vim" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/vim* && \
	cd src/xxd/ && \
	make
	cp ./tmp_extract/vim*/src/xxd/xxd ./tmp_test/xxd

	sed -i "s/$$RUN \"..\/src\//$$RUN \"/g" ./tmp_test/tests/test-fsck
	sed -i "s/$$RUN \"..\/src\//$$RUN \"/g" ./tmp_test/tests/test-label
	sed -i "s/$$RUN \"..\/src\//$$RUN \"/g" ./tmp_test/tests/test-mkfs

	sed -i "s/xxd -r/..\/xxd -r/g" ./tmp_test/tests/test-fsck
	sed -i "s/xxd -r/..\/xxd -r/g" ./tmp_test/tests/test-label
	sed -i "s/xxd -r/..\/xxd -r/g" ./tmp_test/tests/test-mkfs

	sed -i "s/exit 77/#exit 77/g" ./tmp_test/tests/test-mkfs
	sed -i "s/exit 77/#exit 77/g" ./tmp_test/tests/test-label
	sed -i "s/exit 77/#exit 77/g" ./tmp_test/tests/test-fsck

	sed -i 's/cmp $$limitarg/cmp /g' ./tmp_test/tests/test-mkfs

	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"

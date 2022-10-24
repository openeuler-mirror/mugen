all:
	sh ../common.sh -s "https://github.com/shadow-maint/shadow.git" "v4.9"
	cp -rR ./tmp_download/* ./tmp_extract/
	sh ../common.sh -c "shadow" "tests"
	cp ./run_embedded ./tmp_test/tests/run_embedded
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
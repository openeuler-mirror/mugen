all:
	yum install gettext-devel -y
	sh ../common.sh -d "util-linux" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/util-linux* && \
	sh autogen.sh && \
	./configure --host=$${CROSS_COMPILE%-} --build=$$(gcc -dumpmachine) --without-systemd && \
	make check-programs && \
	allSample=$$(find ./ -name "sample-*")" test_uuid_parser test_uuidd"; \
	for oneSampel in $${allSample[@]}; do \
	sh $${oneSampel} || echo "run $${oneSampel} done"; \
	sed -i "s/relink_command=/# relink_command=/g" $${oneSampel}; \
	done &&\
	sed -i 's/-P $$paraller_jobs//g' tests/run.sh && \
	mkdir -p run_test_dir && \
	cp -r test_* ./run_test_dir/ && \
	cp -r sample-* ./run_test_dir/ && \
	cp -r .libs ./run_test_dir/ && \
	cp Makefile ./run_test_dir/ && \
	cp config.h ./run_test_dir/ && \
	cp -r tests ./run_test_dir/ 
	sh ../common.sh -c "util-linux*" "run_test_dir"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
all:
	yum install -y rpcgen
	sh ../common.sh -d "nfs-utils" "${DOWNLOAD_BRANCH}"
	cd ./tmp_extract/nfs-utils* && \
	./configure --host=$${CROSS_COMPILE%-} \
				--build=$$(gcc -dumpmachine) \
				--with-statduser=rpcuser \
                --enable-mountconfig \
                --enable-libmount-mount \
                --enable-uuid \
                --disable-gss \
                --disable-nfsdcltrack \
                --with-statdpath=/var/lib/nfs/statd  && \
	make || echo "done"
	cd ./tmp_extract/nfs-utils* && \
	cd tests && \
	make && \
	make statdb_dump && \
	cd nsm_client && \
	make nsm_client 
	cd ./tmp_extract/nfs-utils* && \
	cd tests && \
	sed -i 's/$$srcdir\/..\/utils\/statd\/statd/\/usr\/sbin\/rpc.statd/g' test-lib.sh && \
	sed -i 's/DUMPER=`realpath ..\/tools\/nfsconf\/nfsconftool`/DUMPER=\/usr\/sbin\/nfsconf/g' t0002-nfsconf.sh
	sh ../common.sh -c "nfs-utils*" "tests"
	sh ../common.sh -r
clean:
	sh ../common.sh -r "all"
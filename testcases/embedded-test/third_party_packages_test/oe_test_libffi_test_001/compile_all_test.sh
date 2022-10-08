#!/usr/bin/bash

cd ./tmp_extract/libffi*/testsuite

mkdir -p testsuite_out

pushd libffi.bhaible
sed -i "s/CC = gcc/# CC = gcc/g" ./Makefile
sed -i "s/CFLAGS = -O2 -Wall/# CFLAGS = -O2 -Wall/g" ./Makefile
sed -i "s/prefix =/# prefix =/g" ./Makefile
sed -i "s/includedir =/# includedir =/g" ./Makefile
sed -i "s/libdir =/# libdir =/g" ./Makefile
sed -i "s/CPPFLAGS =/# CPPFLAGS =/g" ./Makefile
sed -i "s/LDFLAGS =/# LDFLAGS =/g" ./Makefile
sed -i "s/check-call: test-call/check-call: /g" ./Makefile
sed -i "s/check-callback: test-callback/check-callback: /g" ./Makefile
make test-call
make test-callback
popd

compileDirs=("libffi.call" "libffi.closures" "libffi.complex" "libffi.go")
for oneDir in ${compileDirs[*]}; do 
    pushd ./${oneDir}
        allCompileFiles=$(find ./ -name "*.c")
        for oneFile in ${allCompileFiles[*]}; do
            compilteName=$(basename $oneFile .c)
            ${CC} ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} -I../../ -o ../testsuite_out/${compilteName} ${oneFile} -lffi
        done
    popd
done
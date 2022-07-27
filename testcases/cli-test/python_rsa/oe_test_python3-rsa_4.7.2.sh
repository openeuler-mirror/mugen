#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   zhangpanting
#@Contact   	:   1768492250@qq.com
#@Date      	:   2022-10-18
#@License   	:   Mulan PSL v2
#@Desc      	:   command test-python3-rsa
#####################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "python3-rsa"
    dd if=/dev/zero of=bigfile bs=200K count=1
    echo hello there >testfile.txt
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    openssl genrsa -out myprivatekey.pem 512
    CHECK_RESULT $?
    pyrsa-priv2pub-3 -i myprivatekey.pem -o mypublicekey.pem && test -f mypublicekey.pem
    CHECK_RESULT $?
    pyrsa-keygen-3 --pubout=publickey.pem -o privatekey.pem 1024 && test -f privatekey.pem
    CHECK_RESULT $?
    pyrsa-encrypt-3 -i testfile.txt -o testfile.rsa publickey.pem && test -f testfile.rsa
    CHECK_RESULT $?
    pyrsa-decrypt-3 -i testfile.rsa -o testfile_af.txt privatekey.pem && grep 'hello' testfile_af.txt
    CHECK_RESULT $?
    pyrsa-sign-3 -i testfile.txt -o testfile_sign.txt privatekey.pem MD5 && test -f testfile_sign.txt
    CHECK_RESULT $?
    pyrsa-verify-3 -i testfile.txt publickey.pem testfile_sign.txt 2>&1 | grep 'Verification OK'
    CHECK_RESULT $?
    pyrsa-encrypt-3 -i bigfile -o bigfile.rsa publickey.pem
    CHECK_RESULT $? 1
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf $(ls | grep -vE '.sh')
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

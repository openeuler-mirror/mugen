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
#@Author    	:   s-c-c
#@Contact   	:   shichuchao@huawei.com
#@Date      	:   2020-08-25 11:03:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run libcap testsuite
#####################################

source ../comm_lib.sh

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run libcap test."

    # testsuite: libcap/Makefile test
    pushd ./tmp_test

    chmod +x cap_test
    ./cap_test
    CHECK_RESULT $? 0 0 "run cap_test failed!"

    CAPLIBNAME=($(find / -name "*libcap.so*"))
    PSXLIBNAME=($(find / -name "*libpsx.so*"))

    ${CAPLIBNAME[0]}
    CHECK_RESULT $? 0 0 "run ${CAPLIBNAME[0]} failed!"

    ${CAPLIBNAME[0]} --usage
    CHECK_RESULT $? 0 0 "run ${CAPLIBNAME[0]} --usage failed!"

    ${CAPLIBNAME[0]} --help
    CHECK_RESULT $? 0 0 "run ${CAPLIBNAME[0]} --help failed!"
    
    ${CAPLIBNAME[0]} --summary
    CHECK_RESULT $? 0 0 "run ${CAPLIBNAME[0]} --summary failed!"

    ${PSXLIBNAME[0]}
    CHECK_RESULT $? 0 0 "run ${PSXLIBNAME[0]} failed!"

    # testsuite: pam_cap/Makefile test
    chmod +x test_pam_cap
    ./test_pam_cap
    CHECK_RESULT $? 0 0 "run test_pam_cap failed!"

    PAMCAPNAME=($(find / -name "pam_cap.so"))

    ${PAMCAPNAME[0]}
    CHECK_RESULT $? 0 0 "run ${PAMCAPNAME[0]} failed!"

    ${PAMCAPNAME[0]} --help
    CHECK_RESULT $? 0 0 "run ${PAMCAPNAME[0]} --help failed!"
    popd
    # testsuite: tests/Makefile test
    pushd ./tmp_test/tests

    chmod +x psx_test
    ./psx_test
    CHECK_RESULT $? 0 0 "run psx_test failed!"

    chmod +x libcap_psx_test
    ./libcap_psx_test
    CHECK_RESULT $? 0 0 "run libcap_psx_test failed!"

    popd

    LOG_INFO "End to run libcap test."
}

main "$@"

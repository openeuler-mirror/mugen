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
#@Date      	:   2020-09-02 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run libpcap testsuite
#####################################

source ../comm_lib.sh

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run libpcap test."

    pushd ./tmp_test/testprogs

    PROGS_0=(reactivatetest can_set_rfmon_test findalldevstest-perf findalldevstest)
    for prog in ${PROGS_0[@]}; do
        ./${prog} --help
        CHECK_RESULT $? 0 0 "run ${prog} --help failed!"
    done

    PROGS_1=(selpolltest writecaptest opentest filtertest valgrindtest threadsignaltest capturetest)
    for prog in ${PROGS_1[@]}; do
        ./${prog} --help
        CHECK_RESULT $? 1 0 "run ${prog} --help failed!"
    done

    ./opentest
    CHECK_RESULT $? 0 0 "run opentest failed!"

    popd

    LOG_INFO "End to run libcap test."
}

main "$@"

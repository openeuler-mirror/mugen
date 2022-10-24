#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   saarloos
#@Contact   	:   9090-90-90-9090@163.com
#@Date      	:   2020-08-12 11:03:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run libffi testsuite
#####################################

source ../comm_lib.sh

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    MAKEDIR=$(cd .. && pwd)
    chmod 777 ${MAKEDIR}/make
    MAKE=${MAKEDIR}/make

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    pushd ./tmp_test/libffi.bhaible
        chmod 777 ./*
        ${MAKE} check-call
        CHECK_RESULT $? 0 0 "run libffi test check-call fail"
        ${MAKE} check-callback
        CHECK_RESULT $? 0 0 "run libffi test check-callback fail"
    popd

    pushd ./tmp_test/testsuite_out
        chmod 777 ./*
        allTest=$(ls)
        for oneTest in ${allTest[*]}; do
            ./${oneTest}
            CHECK_RESULT $? 0 0 "run libffi test $oneTest fail"
        done
    popd

    LOG_INFO "End to run test."
}

main "$@"

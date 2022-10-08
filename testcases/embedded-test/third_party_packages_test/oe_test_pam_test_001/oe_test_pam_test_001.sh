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
#@Desc      	:   Run pam testsuite
#####################################

source ../comm_lib.sh

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    nowdir=$(    
        cd "$(dirname "$0")" || exit 1
        pwd)
    export srcdir=$nowdir

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    pushd ./tmp_test/tests

    chmod 777 ./*

    runList=$(find ./ -name "*.c" | sort)
    failTitles=("XPASS" "ERROR" "FAIL")
    for onetest in ${runList[@]}; do
        testName=$(basename ${onetest##*/} .c)
        if [[ $testName == "tst-pam_start_confdir" ]]; then 
            continue
        fi
        echo "Run: ../test-driver --test-name ${testName} --log-file ${testName}.log --trs-file ${testName}.trs ./$testName"
        outStr=$(../test-driver --test-name ${testName} --log-file ${testName}.log --trs-file ${testName}.trs ./$testName)
        echo "Output: $outStr"
        outTitle=${outStr%%:*}
        if [[ "${failTitles[*]}" =~ "${outTitle}" && "${outTitle}" != "PASS" ]]; then
            CHECK_RESULT 1 0 0 "run pam testcase $testName fail"
            cat ${testName}.log
        fi
    done

    popd

    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    export srcdir=

    LOG_INFO "End to restore the test environment."
}

main "$@"
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
#@Desc      	:   Run dosfstools testsuite
#####################################

source ../comm_lib.sh

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    export XXD_FOUND=yes
    nowPwd=$(cd "$(dirname "$0")" || exit 1
             pwd)
    export srcdir=${nowPwd}/tmp_test/tests

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    pushd ./tmp_test/tests

    chmod 777 ./test-*

    runList=$(find ./ -name "*.mkfs")
    for onetest in ${runList[@]}; do
        ./test-mkfs $onetest
        CHECK_RESULT $? 0 0 "run dosfstools testcase $onetest fail"
    done

    needFail=("./check-huge.fsck")
    runList=$(find ./ -name "*.fsck")
    for onetest in ${runList[@]}; do
        if [[ "${needFail[*]}" =~ "${onetest}" ]]; then
            ./test-fsck $onetest
            CHECK_RESULT $? 0 1 "run dosfstools testcase $onetest fail"
        else
            ./test-fsck $onetest
            CHECK_RESULT $? 0 0 "run dosfstools testcase $onetest fail"
        fi
    done

    runList=$(find ./ -name "*.label")
    for onetest in ${runList[@]}; do
        ./test-label $onetest
        CHECK_RESULT $? 0 0 "run dosfstools testcase $onetest fail"
    done

    popd

    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    export XXD_FOUND=
    export srcdir=

    LOG_INFO "End to restore the test environment."
}

main "$@"

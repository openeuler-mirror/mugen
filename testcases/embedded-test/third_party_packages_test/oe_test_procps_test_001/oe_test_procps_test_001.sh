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
#@Author    	:   s-c-c
#@Contact   	:   shichuchao@huawei.com
#@Date      	:   2022-08-31 16:24:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run procps-ng testsuite
#####################################

source ../comm_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    pushd ./tmp_test/ps
    # 去掉pscommand wrapper
    rm -f pscommand
    cp .libs/pscommand pscommand
    chmod +x pscommand
    popd

    pushd ./tmp_test/testsuite
    # 修改site.exp
    cur=$(pwd)
    sed -i "s\set objdir .*$\set objdir ${cur}\g" site.exp

    # 修改unix.exp 避免调用getconf
    sed -i 's/min(\[ exec \/usr\/bin\/getconf ARG_MAX \], 104857)/104857/g' config/unix.exp
    popd
    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    pushd ./tmp_test/testsuite

    suites=$(ls *.test -d)
    for tc in ${suites}; do
        tool=${tc%.test}
        cmd=$(which ${tool})
        if [[ -n "${cmd}" ]]; then
            ln -s ${cmd} ../${tool}
        fi
        ${RUNTEST} --tool ${tool} --srcdir .
        CHECK_RESULT $? 0 0 "run procps-ng test ${tool} fail"
    done

    popd

    LOG_INFO "End to run test."
}

main "$@"

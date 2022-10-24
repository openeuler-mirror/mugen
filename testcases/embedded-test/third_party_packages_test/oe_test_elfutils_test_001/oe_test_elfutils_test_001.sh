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
#@Desc      	:   Run elfutils testsuite
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

    declare -A ignoreFail
    getCasesFromFile ignoreFail ignore.txt

    chmod -R 777 ./tmp_test/*

    pushd ./tmp_test/tests

    ${MAKE} -k installcheck-local CC=gcc abs_srcdir=$PWD abs_builddir=$PWD srcdir=$PWD top_srcdir=$PWD/../ abs_top_builddir=$PWD/../ libdir=/usr/lib64 elfutils_testrun=installed elfutils_tests_rpath=no program_transform_name=s,^,eu-, > tmp_log.log 2>&1

    failTitles=("XPASS" "ERROR" "FAIL")
    while read line; do
        [[ $line =~ ^make.* ]] && continue
        [[ $line =~ ^cd.* ]] && continue
        if [[ $line =~ ":" ]]; then
            resultTitle=${line%%:*}
            resultTail=${line##*:}
            testcase=`echo $resultTail | sed -e 's/^[ \t]//g' -e 's/[ \t]*$//g'`
            [[ ${ignoreFail[$testcase]} -eq 1 ]] && continue
            if [[ "${failTitles[*]}" =~ "${resultTitle}" && "${resultTitle}" != "PASS" ]]; then
                CHECK_RESULT 1 0 0 "run elfutils $testcase fail"
                cat $testcase.log
            fi
        fi
    done < tmp_log.log

    popd

    LOG_INFO "End to run test."
}

main "$@"
